/* *************************************************************************************************************************
Copyright (c) 2017-2021,2024-2025 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : DataObjectService
    Purpose     : A representation of a Data Service
    Author(s)   : pjudge
    Created     : 2017-08-31
    Notes       : * the service provides access to contained schemas and operations within,
                    as well as a means to update/save itself in a registry
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.IHandleHolder.
using OpenEdge.Core.Assert.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.DataTypeEnum.
using OpenEdge.Core.SemanticVersion.
using OpenEdge.Core.StringConstant.
using OpenEdge.Core.Util.BuilderRegistry.
using OpenEdge.Core.WidgetHandle.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.ISupportLogging.
using OpenEdge.Logging.LoggerBuilder.
using OpenEdge.Logging.LogLevelEnum.
using OpenEdge.Net.HTTP.MethodEnum.
using OpenEdge.Web.DataObject.DataObjectService.
using OpenEdge.Web.DataObject.MappedOperation.
using OpenEdge.Web.DataObject.SchemaOption.
using OpenEdge.Web.DataObject.ServiceOptions.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriter.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.AppError.
using Progress.Lang.Object.

class OpenEdge.Web.DataObject.DataObjectService
        implements ISupportLogging:

    /* The default name for the root (unnamed) service */
    define static public property ROOT_SERVICE_NAME as character init 'ROOT':u no-undo get.

    /* The root uri (ie / ) */
    define static public property ROOT_SERVICE_URI  as character init '/':u no-undo get.

    define private variable PATH_SEPARATOR as character init '/':u no-undo.

    // A reference to the Logger in use by an implementer
    define public property Logger as ILogWriter no-undo
        get():
            if not valid-object(this-object:Logger) then
                assign this-object:Logger = LoggerBuilder:GetLogger(this-object:GetClass()).

            return this-object:Logger.
        end get.
        set.

    // The ServiceName and URI are derived from the URI path, which are CASE-SENSITIVE (see URI/spec RFC3986)
    define private static temp-table Operation no-undo
        //KEYS
        field ParentSvc       as int64                    // Keeps all operations relative to a parent service
        field URI             as character case-sensitive // Either "/" or another valid path
        field Method          as character                // HTTP method (GET|PUT|POST|DELETE|...)
        //DATA
        field Name            as character                // an optional name for the operation
        field MappedOperation as Progress.Lang.Object serialize-hidden // OpenEdge.Web.DataObject.MappedOperation
        //EXTRA
        field PathSeg         as integer                  // Count of path segments
        index pukService      as primary unique ParentSvc URI Method
        index idxName                           ParentSvc Name
        .

    // Holds empty schemas for use by operations
    define private static temp-table DataSchema no-undo
        //KEYS
        field ParentSvc     as int64
        field SchemaName    as character
        //DATA
        field DataStructure as handle
        index pukName       as primary unique ParentSvc SchemaName
        .

    // Use a variable since we need the value to be CASE-SENSITIVE since its part of a URI
    define private variable mName as character case-sensitive no-undo.

    /* (mandatory) The name of the service */
    define public property Name as character no-undo
        get():
            return mName.
        end get.
        // effectively private-set

    /* (mandatory) The version of the service */
    define public property Version as SemanticVersion no-undo
        get.
        private set.

    /* (optional) Options for this service. */
    define public property Options as ServiceOptions no-undo get. set.

    /* (optional) A Data Service Catalog associated with the service */
    define public property Catalog as JsonObject no-undo get. set.

    /* (optional) A collection of ArgumentValueWriter types for this service that provide custom writing */
    define public property ArgumentWriters as BuilderRegistry no-undo
        get.
        private set.

    /* Constructor

       @param character The service name
       @param SemanticVersion The service version */
    constructor public DataObjectService(input pName as character,
                                         input pVersion as SemanticVersion):
        super().

        Assert:NotNullOrEmpty(pName, 'Service name').
        Assert:NotNull(pVersion, 'Service version').

        assign this-object:mName           = NormalizeServiceName(pName)
               this-object:Version         = pVersion
               this-object:ArgumentWriters = new BuilderRegistry(get-class(ArgumentValueWriter))
               .
    end constructor.

    /* Constructor

       @param character The service name
       @param character The service version */
    constructor public DataObjectService(input pName as character,
                                         input pVersion as character):
        this-object(pName, SemanticVersion:Parse(pVersion)).
    end constructor.

    /* Destructor */
    destructor DataObjectService():
        define buffer lbDataSchema for DataSchema.
        define buffer lbOperation for Operation.

        for each lbDataSchema exclusive-lock
           where lbDataSchema.ParentSvc eq int64(this-object):
            delete object lbDataSchema.DataStructure no-error.
            delete lbDataSchema.
        end.

        for each lbOperation exclusive-lock
           where lbOperation.ParentSvc eq int64(this-object):
            delete object lbOperation.MappedOperation no-error.
            delete lbOperation.
        end.
    end destructor.

    method override public character ToString():
        return substitute('&1 v&2':u, this-object:Name, string(this-object:Version)).
    end method.

    method override public logical Equals(input pCompare as Object):
        if super:Equals(pCompare) then
            return true.

        if type-of(pCompare, DataObjectService) then
            return (     this-object:Name    eq cast(pCompare, DataObjectService):Name
                     and this-object:Version:Equals(cast(pCompare, DataObjectService):Version)).

        return false.
    end method.

/* OPERATIONS */
    /* Indicates whether a mapped operation exists with a given name

       @param character The operation name
       @return logical TRUE if the service exists */
    method public logical HasOperation(input pOperationName as character):
        define buffer lbOperation for Operation.

        Assert:NotNull(pOperationName, 'Operation name').

        return can-find(first lbOperation where
                              lbOperation.ParentSvc eq int64(this-object) and
                              lbOperation.Name      eq pOperationName).
    end method.

    /* Indicates whether a mapped operation exists for this service

       @param character The relative URI (to the service)
       @param MethodEnum The HTTP method
       @return logical TRUE if the service exists */
    method public logical HasOperation(input pServiceURI as character,
                                       input pMethod as MethodEnum):
        define buffer lbOperation for Operation.

        Assert:NotNull(pServiceURI, 'Service URI').
        Assert:NotNull(pMethod, 'Service method').

        FindOperationRecord(pServiceURI, string(pMethod), buffer lbOperation).

        this-object:Logger:Trace(substitute("Has Operation: &1", available(lbOperation))).

        return (available lbOperation).
    end method.

    /* Returns details about an operation in this service

       @param character The relative URI
       @param MethodEnum The HTTP method
       @return MappedOperation The operation map for this Method/URI */
    method public MappedOperation GetOperation(input pServiceURI as character,
                                               input pMethod as MethodEnum):
        define variable operation as MappedOperation no-undo.

        define buffer lbOperation for Operation.

        Assert:NotNull(pServiceURI , 'Service URI').
        Assert:NotNull(pMethod, 'Operation method').

        if Logger:LogLevel eq LogLevelEnum:Trace then
            temp-table Operation:write-json("file", substitute("&1/operation.json", right-trim(replace(session:temp-directory, StringConstant:BACKSLASH, "/"), "/")), true).

        FindOperationRecord(pServiceURI, string(pMethod), buffer lbOperation).
        if available(lbOperation) then
            assign operation = cast(lbOperation.MappedOperation, MappedOperation).

        if valid-object(operation) then
            this-object:Logger:Trace(substitute("Found Operation (by Method/URI): &1 &2", string(operation:Method), operation:ServiceURI)).

        return operation.
    end method.

    /* Returns details about the operation, for a service by name. If more than one
       operation exists with the same name, pick the first.

       @param character An optional name for the operation
       @return MappedOperation The operation map for this name  */
    method public MappedOperation GetOperation(input pOperationName as character):
        define variable operation as MappedOperation no-undo.

        define buffer lbOperation for Operation.

        Assert:NotNullOrEmpty(pOperationName, 'Operation name').

        if can-find(first lbOperation where
                          lbOperation.ParentSvc eq int64(this-object) and
                          lbOperation.Name      eq pOperationName) then
            find first lbOperation where
                       lbOperation.ParentSvc eq int64(this-object) and
                       lbOperation.Name      eq pOperationName
                       no-error.
        if available lbOperation then
            assign operation = cast(lbOperation.MappedOperation, MappedOperation).

        return operation.
    end method.

    /* Removes an operation mapping from the collection operation maps.
       No-op if none exists.

       @param character The relative URI
       @param MethodEnum The HTTP method */
    method public void RemoveOperation(input pServiceURI as character,
                                       input pMethod as MethodEnum):
        define buffer lbOperation for Operation.

        Assert:NotNull(pServiceURI, 'Service relative URL').
        Assert:NotNull(pMethod, 'Http Method').

        FindOperationRecord(pServiceURI, string(pMethod), buffer lbOperation).
        if available lbOperation then
            delete lbOperation.
    end method.

    /* Returns an array or operations for the service

       @return MappedOperation[] The operations for this service */
    method public MappedOperation extent GetOperations():
        define variable operations as MappedOperation extent no-undo.

        define buffer lbOperation for Operation.
        define query qryOps for lbOperation.

        open query qryOps preselect each lbOperation where lbOperation.ParentSvc eq int64(this-object).
        if query qryOps:num-results gt 0 then
            assign extent(operations) = query qryOps:num-results.
        get first qryOps.
        do while available lbOperation:
            assign operations[query qryOps:current-result-row] = cast(lbOperation.MappedOperation, MappedOperation).
            get next qryOps.
        end.

        return operations.
        finally:
            close query qryOps.
        end finally.
    end method.

    /* Adds a new operation map for a service.

       @param  MappedOperation The operation map for this Method/URI
       @return logical TRUE if the operation already exists. */
    method public logical PutOperation(input pMappedOperation as MappedOperation):
        define variable operationExists as logical no-undo.
        define variable schemaClone as IHandleHolder no-undo.
        define variable schemaOption as SchemaOption no-undo.
        define variable iter as IIterator no-undo.
        var integer iCount = 0.

        define buffer lbOperation for Operation.

        Assert:NotNull(pMappedOperation, 'Mapped operation').

        FindOperationRecord(pMappedOperation:ServiceURI, string(pMappedOperation:Method), buffer lbOperation).
        assign operationExists = available lbOperation.
        if not operationExists then
        do:
            create lbOperation.
            // Note that a Service URI will always have a leading "/"
            assign lbOperation.URI       = pMappedOperation:ServiceURI
                   lbOperation.Method    = string(pMappedOperation:Method)
                   lbOperation.ParentSvc = int64(this-object)
                   .

            // Count the segments of the service URI, omitting any leading/trailing slash
            assign iCount = num-entries(NormalizeServiceName(pMappedOperation:ServiceURI), PATH_SEPARATOR).
            if iCount gt 0 then
                assign lbOperation.PathSeg = iCount.
        end.

        assign lbOperation.MappedOperation = pMappedOperation
               lbOperation.Name            = pMappedOperation:Name
               iter                        = pMappedOperation:Options:SchemaOptions:Values:Iterator()
               .
        // if this is an existing operation we may have changed the schema options so clean out just in case
        pMappedOperation:Schemas:Clear().

        do while iter:HasNext():
            assign schemaOption = cast(iter:Next(), SchemaOption)
                   schemaClone  = CloneServiceSchema(schemaOption)
                   .
            if valid-object(schemaClone) then
                pMappedOperation:Schemas:Put(schemaOption:SchemaName, schemaClone).
        end.
        return operationExists.
    end method.

/** SCHEMAS **/

    /* Saves a schema for a given service.

       @param character The schema name
       @param handle    An empty data structure (TT or PDS)
       @return logical TRUE if the schema already exists. */
    method public logical PutSchema(input pSchemaName as character,
                                    input pSchema as handle):
        define variable schemaExists as logical no-undo.
        define variable schemaClone as IHandleHolder no-undo.
        define variable oper as MappedOperation no-undo.
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        define variable tbl as handle no-undo.

        define buffer lbSchema for DataSchema.
        define buffer lbOper for Operation.

        Assert:NotNullOrEmpty(pSchemaName, 'Schema name').
        Assert:NotNull(pSchema, 'Schema ').

        case pSchema:type:
            when string(DataTypeEnum:Temp-Table) or
            when string(DataTypeEnum:Buffer)     or
            when string(DataTypeEnum:Dataset)    then
                /* no-op */ .
            otherwise
                return error new AppError(substitute('Unsupported schema type: &1', pSchema:type), 0).
        end case.

        FindSchemaRecord(pSchemaName, buffer lbSchema).
        assign schemaExists = available lbSchema.
        // The RemoveSchema() call recurses down the parent/child tree
        if schemaExists then
            RemoveSchema(pSchemaName).

        create lbSchema.
        assign lbSchema.ParentSvc     = int64(this-object)
               lbSchema.SchemaName    = pSchemaName
               lbSchema.DataStructure = pSchema
               .
        case pSchema:type:
            when string(DataTypeEnum:Dataset) then
            do:
                assign cnt = pSchema:num-buffers.
                COUNTLOOP:
                do loop = 1 to cnt:
                    assign tbl = pSchema:get-buffer-handle(loop).
                    // It's posible to have a TT and a PDS with the same name; we'll keep the dataset
                    if tbl:name eq pSchema:name then
                        next COUNTLOOP.
                    PutSchema(tbl:name, tbl:table-handle).
                end.
            end.
        end case.

        // do we need to clone this schema for any operation?
        for each lbOper where lbOper.ParentSvc eq int64(this-object):
            assign oper = cast(lbOper.MappedOperation, MappedOperation).
            // only go further if there are options
            if oper:Options:SchemaOptions:ContainsKey(pSchemaName) then
            do:
                // even if a clone exists, reapply because the schema may have changed
                assign schemaClone = CloneServiceSchema(cast(oper:Schemas:Get(pSchemaName), SchemaOption)).
                if valid-object(schemaClone) then
                    oper:Schemas:Put(pSchemaName, schemaClone).
            end.
        end.

        return schemaExists.
    end method.

    /* Removes a schema from service
       No-op if none exists.

       @param character The schema name  */
    method public void RemoveSchema(input pSchemaName as character):
        define buffer lbSchema for DataSchema.
        define buffer lbOper for Operation.

        Assert:NotNullOrEmpty(pSchemaName, 'Schema name').

        FindSchemaRecord(pSchemaName, buffer lbSchema).
        if available lbSchema then
        do:
            delete object lbSchema.DataStructure no-error.
            // to clear the previous one
            delete lbSchema no-error.

            // Are there schema clones? Remove them too
            for each lbOper where lbOper.ParentSvc eq int64(this-object):
                cast(lbOper.MappedOperation, MappedOperation):Schemas:Remove(pSchemaName).
            end.
        end.
    end method.

    /* Indicates whether a mapped operation exists with a given name

       @param character The operation name
       @return logical TRUE if the service exists */
    method public logical HasSchema(input pName as character):
        define buffer lbSchema for DataSchema.

        Assert:NotNull(pName, 'Schema name').

        return can-find(first lbSchema where
                              lbSchema.ParentSvc  eq int64(this-object) and
                              lbSchema.SchemaName eq pName).
    end method.

    /* Returns all of the schema names associated with a service .

       @return handle[] An array of service schemas */
    method public handle extent GetSchemas():
        define variable schemas as handle extent no-undo.

        define buffer lbSchema for DataSchema.
        define query qrySchema for lbSchema.

        open query qrySchema preselect each lbSchema where lbSchema.ParentSvc eq int64(this-object).
        if query qrySchema:num-results gt 0 then
            assign extent(schemas) = query qrySchema:num-results.
        get first qrySchema.
        do while available lbSchema:
            assign schemas[query qrySchema:current-result-row] = lbSchema.DataStructure.
            get next qrySchema.
         end.

        return schemas.
        finally:
            close query qrySchema.
        end finally.
    end method.

    /* Returns a named schema for a latest version of a service.

       @param character The schema name
       @return handle   An empty data structure (TT or PDS) */
    method public handle GetSchema(input pName as character):
        define buffer lbSchema for DataSchema.

        Assert:NotNullOrEmpty(pName, 'Schema name').

        FindSchemaRecord(pName, buffer lbSchema).

        if available lbSchema then
            return lbSchema.DataStructure.

        return ?.
    end method.

    /* Helper method to find and position the Operation buffer (record) to a given service/method.
       Caller must check buffer availablity themselves before accessing the MappedOperation which
       will be contained within the available buffer. Note: For service URIs which are expected to
       be used with tokenized path parameters, this method will attempt to match based on the URI
       provided which may be either the URI from the client (with values filled in where tokens
       should be) or the URI provided by the WEB transport which would be the URI matched in the
       Handlers definition. The latter could have been provided in the openedge.properties file
       or via a .handlers file.

       @param character The service URI
       @param character The http method
       @param buffer The Operation record to find. */
    method private void FindOperationRecord(input  pServiceUri as character,
                                            input  pMethod as character,
                                            buffer pOperation for Operation):
        // 'let go' of the record so that the AVAILABLE status is always correct
        release pOperation.

        // the mapped operation records always have a leading "/"
        assign pServiceURI  = PATH_SEPARATOR + trim(pServiceURI, PATH_SEPARATOR).
        Logger:Trace(substitute("Finding Operation: &1 &2", pMethod, pServiceUri)).
        if can-find(pOperation no-lock where
                    pOperation.ParentSvc eq int64(this-object) and
                    pOperation.URI       eq pServiceURI and
                    pOperation.Method    eq pMethod)
        then
            find pOperation no-lock where
                 pOperation.ParentSvc eq int64(this-object) and
                 pOperation.URI       eq pServiceURI and
                 pOperation.Method    eq pMethod
                 no-error.

        // we did not find a direct match to our service URI and method
        if not available(pOperation) then do:
            define variable iCount as integer no-undo.
            define variable iSeg as integer no-undo.
            define variable rRec as rowid no-undo.
            define variable cToken as character no-undo.
            define variable cSeg1 as character no-undo.
            define variable cSeg2 as character no-undo.

            // get a count of the service segments for searching
            assign
                cToken = (StringConstant:CURLY_OPEN + "*" + StringConstant:CURLY_CLOSE)
                iCount = num-entries(NormalizeServiceName(pServiceURI), PATH_SEPARATOR)
                rRec   = ?
                .

            Logger:Debug(substitute("Finding operation by URI segments (&1).", iCount)).

            // match the URI segment by segment until we have a candidate match
            OPMATCH:
            for each pOperation no-lock
               where pOperation.ParentSvc eq int64(this-object)
                 and pOperation.Method eq pMethod
                 and pOperation.PathSeg eq iCount:
                Logger:Trace(substitute("|-Candidate URI: &1", pOperation.URI)).

                SEGMATCH:
                do iSeg = 1 to iCount:
                    // Do something if we match this path element exactly.
                    assign
                        cSeg1 = entry(iSeg, NormalizeServiceName(pOperation.URI), PATH_SEPARATOR)
                        cSeg2 = entry(iSeg, NormalizeServiceName(pServiceURI), PATH_SEPARATOR)
                        .

                    // If service URI segment matches a token (identified as a value in curly braces represented as "{*}"),
                    // then we continue to the next segment--unless we're on the last segment then we assume "this is it".
                    if cSeg1 matches cToken then do:
                        Logger:Trace(substitute("|--Segment #&1: &2 matches Token", iSeg, cSeg1)).

                        if iSeg eq iCount then
                            assign rRec = rowid(pOperation). // Even if we end with a token we must assume this a viable service URI.
                        else
                            next SEGMATCH.
                    end.

                    // If a segment matches exactly we either call it done (for last entry) or continue to the next segment.
                    if cSeg1 eq cSeg2 then do:
                        Logger:Trace(substitute("|--Segment #&1: &2 = &3", iSeg, cSeg1, cSeg2)).

                        if iSeg eq iCount then
                            assign rRec = rowid(pOperation). // This URI is valid if we've positively matched to the last path segment.
                        else
                            next SEGMATCH.
                    end.

                    // If segments don't match at all then we're done with this service.
                    if cSeg1 ne cSeg2 then
                        leave SEGMATCH.
                end.

                if rRec ne ? then
                    leave OPMATCH.
            end.

            // Make sure we don't have a record buffer in scope.
            release pOperation no-error.

            // Seek to the expected record.
            if rRec ne ? then
                find pOperation no-lock where rowid(pOperation) eq rRec no-error.
        end. // not available(pOperation)
    end method.

    /* Helper method to find and position the Service buffer to a given service. Caller must check
       availablity themselves.

       @param character The schema name
       @param buffer The schema record to find. */
    method  private void FindSchemaRecord(input  pcSchemaName as character,
                                          buffer pbSchema for DataSchema):
        // 'let go' of the record so that the AVAILABLE status is always correct
        release pbSchema.

        if can-find(pbSchema where
                    pbSchema.ParentSvc  eq int64(this-object) and
                    pbSchema.SchemaName eq pcSchemaName) then
            find pbSchema where
                 pbSchema.ParentSvc  eq int64(this-object) and
                 pbSchema.SchemaName eq pcSchemaName
                 no-error.
    end method.

    /* Makes sure the service name is 'nice' and clean.

       @param character A service name that may be empty or have /'s
       @return character A non-slashed, non-empty name */
    method static public character NormalizeServiceName(input pName as character):
        assign pName = trim(pName, '/':u).

        if    pName eq '':u
           or pName eq ?
        then
            assign pName = ROOT_SERVICE_NAME.

        return pName.
    end method.

    /* Makes sure the service name is 'nice' and clean.
       This is a deprecated method name using older spelling.

       @param character A service name that may be empty or have /'s
       @return character A non-slashed, non-empty name */
    method static public character NormaliseServiceName(input pName as character):
        return NormalizeServiceName(pName).
    end method.

    /* Clones a service schema

       @param SchemaOption The schema option to apply
       @return handle A schema handle. UNKNOWN if the schema cannot be found */
    method private IHandleHolder CloneServiceSchema(input pOption as SchemaOption):
        define variable hClone as handle no-undo.
        define variable hSchema as handle no-undo.
        define variable schemaClone as IHandleHolder no-undo.

        if not valid-object(pOption) then
            return schemaClone.

        assign hSchema = this-object:GetSchema(pOption:SchemaName).
        // if there's no schema for this service at all then g'way
        if not valid-handle(hSchema) then
            return schemaClone.

        case hSchema:type:
            when string(DataTypeEnum:Dataset) then
                create dataset hClone.
            when string(DataTypeEnum:Temp-Table) then
            do:
                // If the TT is part of a dataset, clone the DATASET - we'll only use the
                // temp-table but we want it to be part of a whole
                if valid-handle(hSchema:default-buffer-handle:dataset) then
                    return schemaClone.
                else
                    create temp-table hClone.
            end.
        end case.

        hClone:create-like(hSchema).
        case hClone:type:
            when string(DataTypeEnum:Temp-Table) then
            do:
                // The BEFORE-TABLE does NOT come along for the ride by default ...
                hClone:temp-table-prepare(hSchema:name, valid-handle(hSchema:before-table) ).
                assign hClone = hClone:default-buffer-handle.
            end.
        end case.

        assign schemaClone = new WidgetHandle(hClone, true /*destroy clone on GC*/ ).

        // Apply the options to the cloned schema. This will recurse into tables and fields as needed
        ApplySchemaOptions(hClone, pOption).

        return schemaClone.
    end method.

    /** Applies schema-related options (serialize-*) to a table/dataset/child handle

        @param handle The buffer/dataset handle to which to apply the option
        @param SchemaOption The schema option to apply to the input schema structure */
    method private void ApplySchemaOptions (input pSchema as handle,
                                            input pOptions as SchemaOption):
        define variable childSchemaNames as character extent no-undo.
        define variable numChildren as integer no-undo.
        define variable loop as integer no-undo.
        define variable childOption as SchemaOption no-undo.
        define variable schemaElement as handle no-undo.

        // we may have no options
        if not valid-object(pOptions) then
            return.

        Assert:NotNull(pSchema, 'Schema').

        // this schemas
        if not pOptions:SerializeName eq ? then
            assign pSchema:serialize-name = pOptions:SerializeName.

        if     pOptions:Hidden
           and index(list-set-attrs(pSchema), 'serialize-hidden':u) gt 0
        then
            assign pSchema:serialize-hidden = pOptions:Hidden.

        // Child schemas are only for tables/buffers
        if pOptions:HasChildSchema() then
            assign childSchemaNames = pOptions:GetChildSchemas()
                   numChildren      = extent(childSchemaNames)
                   .
        do loop =  1 to numChildren:
            assign childOption = pOptions:GetChildSchema(childSchemaNames[loop]).
            case pSchema:type:
                when string(DataTypeEnum:Dataset) then
                    assign schemaElement = pSchema:get-buffer-handle(childSchemaNames[loop]).
                when string(DataTypeEnum:Temp-Table) then
                    assign schemaElement = pSchema:buffer-field(childSchemaNames[loop]).
                otherwise
                    assign schemaElement = pSchema.
            end case.
            // recurse
            ApplySchemaOptions(schemaElement, childOption).
        end.
    end method.

    /* Merges service information into this one. The source of the
       merge data must have the same name and version, otherwise
       an error is thrown.

       A Merge will overwrite the schemas, operations, catalogs and
       argument writers in this object with those that are passed in
       (the source service).

       If there are schemas, operations and argument writers in the
       source service that are not in this service, they will be added.

       If there are schemas, operations and argument writers in the
       THIS service that are not in the source service, they will be
       not be touched.

       @param DataObjectService A service to merge into this one. */
    method public void Merge(input pSvc as DataObjectService):
        define buffer bSchema for DataSchema.
        define buffer bOper for Operation.

        Assert:NotNull(pSvc, 'Merge source Data Object Service').

        if not pSvc:Name eq this-object:Name
        or not pSvc:Version:Equals(this-object:Version)
        then
            undo, throw new AppError(substitute('Merge source service name and version do not match: &1', ToString()), 0).

        assign this-object:Catalog = pSvc:Catalog.
        // ServiceOptions have nothing as yet, so no work needed

        this-object:ArgumentWriters:PutAll(pSvc:ArgumentWriters).

        for each bSchema
           where bSchema.ParentSvc eq int64(pSvc):
            PutSchema(bSchema.SchemaName, bSchema.DataStructure).
        end.

        for each bOper
           where bOper.ParentSvc eq int64(pSvc):
            PutOperation(cast(bOper.MappedOperation, MappedOperation)).
        end.
    end method.

end class.