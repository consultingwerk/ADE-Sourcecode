/* *************************************************************************************************************************
Copyright (c) 2017-2019 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
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
using OpenEdge.Core.Util.BuilderRegistry.
using OpenEdge.Core.WidgetHandle.
using OpenEdge.Net.HTTP.MethodEnum.
using OpenEdge.Web.DataObject.MappedOperation.
using OpenEdge.Web.DataObject.SchemaOption.
using OpenEdge.Web.DataObject.ServiceOptions.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriter.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.AppError.
using Progress.Lang.Object.

class OpenEdge.Web.DataObject.DataObjectService:
    
    /* The default name for the root (unnamed) service */
    define static public property ROOT_SERVICE_NAME as character init 'ROOT':u no-undo get.
    
    /* The root uri (ie / ) */
    define static public property ROOT_SERVICE_URI  as character init '/':u no-undo get.
    
    // The ServiceName and URI are derived from the URI path, which are CASE-SENSITIVE (see URI/spec RFC3986)
    define private static temp-table Operation no-undo
        //KEYS
        field ParentSvc         as int64
        field URI               as character case-sensitive // / or another path
        field Method            as character                // HTTP method (GET|PUT|POST|DELETE|...) 
        //DATA
        field Name            as character              //an optional name
        field MappedOperation as Progress.Lang.Object   // OpenEdge.Web.DataObject.MappedOperation  
        index idx1 as primary unique ParentSvc URI Method
        index idx2 ParentSvc Name
        .
    
    define private static temp-table DataSchema no-undo
        //KEYS
        field ParentSvc     as int64
        //DATA
        field SchemaName    as character
        field DataStructure as handle
        index idx1 as primary unique ParentSvc SchemaName
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
        
        assign this-object:mName           = NormaliseServiceName(pName) 
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
    end method.
    
    /* Destructor */
    destructor DataObjectService():
        define buffer lbDataSchema for DataSchema.
        define buffer lbOperation for Operation.
        
        for each lbDataSchema where lbDataSchema.ParentSvc eq int64(this-object):
            delete object lbDataSchema.DataStructure no-error.
            delete lbDataSchema.
        end.
        
        for each lbOperation where lbOperation.ParentSvc eq int64(this-object):
            delete lbOperation.
        end.
    end destructor.
    
    method override public character ToString():
        return substitute('&1 v&2':u, this-object:Name, string(this-object:Version)).
    end method.
    
    method override public logical Equals(input pCompare as Object):
        if super:Equals(pCompare) then
            return true.
        
        if type-of(pCompare, OpenEdge.Web.DataObject.DataObjectService) then
            return (     this-object:Name    eq cast(pCompare, OpenEdge.Web.DataObject.DataObjectService):Name
                     and this-object:Version:Equals(cast(pCompare, OpenEdge.Web.DataObject.DataObjectService):Version)).
        
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
        
        FindOperationRecord(pServiceURI, string(pMethod), buffer lbOperation).
        if available lbOperation then
            assign operation = cast(lbOperation.MappedOperation, MappedOperation).
        
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
                       .
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
        
        define buffer lbOperation for Operation.
        
        Assert:NotNull(pMappedOperation, 'Mapped operation').
        
        FindOperationRecord(pMappedOperation:ServiceURI, string(pMappedOperation:Method), buffer lbOperation).
        assign operationExists = available lbOperation.
        if not operationExists then
        do:
            create lbOperation.
            // The Service URI will always have a leading / 
            assign lbOperation.URI       = pMappedOperation:ServiceURI
                   lbOperation.Method    = string(pMappedOperation:Method)
                   lbOperation.ParentSvc = int64(this-object)
                   .
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
            when string(DataTypeEnum:Buffer) or
            when string(DataTypeEnum:Dataset) then
                .   // NO-OP
            otherwise
                return error new AppError(substitute('Unsupported schema type: &1', pSchema:type), 0).
        end case.
        
        FindSchemaRecord(pSchemaName, buffer lbSchema).
        assign schemaExists = available lbSchema.
        if not schemaExists then
        do:
            create lbSchema.
            assign lbSchema.ParentSvc  = int64(this-object)
                   lbSchema.SchemaName = pSchemaName.
        end.
        else
            delete object lbSchema.DataStructure no-error.
        
        assign lbSchema.DataStructure = pSchema
               // reset the error-status error flag from above
               no-error.
        
        case pSchema:type:
            when string(DataTypeEnum:Dataset) then
            do:
                assign cnt = pSchema:num-buffers.
                do loop = 1 to cnt:
                    assign tbl = pSchema:get-buffer-handle(loop). 
                    // It's posible to have a TT and a PDS with the same name; wwe'll keep the dataset
                    if tbl:name eq pSchema:name then
                        next.
                    
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
            delete lbSchema.
            assign error-status:error = false.
            
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
    
    /* Helper method to find and position the Operation buffer to a given service/method. Caller must check 
       availablity themselves.
       
       @param character The service URI
       @param character The http method
       @param buffer The Operation record to find. */
    method private void FindOperationRecord(input  pServiceUri as character,
                                            input  pMethod as character,
                                            buffer pOperation for Operation):
        // 'let go' of the record so that the AVAILABLE status is always correct
        release pOperation.
        
        // the mapped operation records always have a leading /
        assign pServiceURI  = '/':u + trim(pServiceURI, '/':u).
        if can-find(pOperation where
                    pOperation.ParentSvc eq int64(this-object) and
                    pOperation.URI       eq pServiceURI and
                    pOperation.Method    eq pMethod)
        then 
            find pOperation where
                 pOperation.ParentSvc eq int64(this-object) and
                 pOperation.URI       eq pServiceURI and
                 pOperation.Method    eq pMethod 
                 .
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
                 .
    end method.
    
    /* Makes sure the service name is 'nice' and clean.
       
       @param character A service name that may be empty or have /'s  
       @return character A non-slashed, non-empty name */
    method static public character NormaliseServiceName(input pName as character):
        assign pName = trim(pName, '/':u).
        
        if    pName eq '':u
           or pName eq ? 
        then
            assign pName = ROOT_SERVICE_NAME.
        
        return pName.
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
    end.
    
end class.