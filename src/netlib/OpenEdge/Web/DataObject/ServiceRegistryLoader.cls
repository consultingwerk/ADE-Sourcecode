/* *************************************************************************************************************************
Copyright (c) 2016-2023 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : ServiceRegistryLoader
    Purpose     : Loads DOH services from a JSON file
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : Wed May 18 13:06:41 EDT 2016
    Notes       : As of the 12.8 release efforts have been made to reduce
                  the number of errors which may cause the creation of
                  services to fail. Instead, errors will be trapped and
                  reported via the logging framework, allow services to be
                  created even if they are not 100% complete. In addition,
                  more checks will be performed on the JSON config values
                  to ensure they either exist or are the expected datatype
                  prior to being requested from the config objects. Any
                  invalid or missing config items will also cause a log
                  message to be generated in hopes that the source of the
                  problem will be more easily identified.
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.Assertion.AssertFile.
using OpenEdge.Core.DateTimeAddIntervalEnum.
using OpenEdge.Core.File.
using OpenEdge.Core.IOModeEnum.
using OpenEdge.Core.Json.JsonPropertyHelper.
using OpenEdge.Core.JsonDataTypeEnum.
using OpenEdge.Core.SemanticVersion.
using OpenEdge.Core.String.
using OpenEdge.Core.StringConstant.
using OpenEdge.Core.Util.TokenResolver.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.ISupportLogging.
using OpenEdge.Logging.LoggerBuilder.
using OpenEdge.Net.HTTP.Cookie.
using OpenEdge.Net.HTTP.HttpHeaderBuilder.
using OpenEdge.Net.HTTP.MethodEnum.
using OpenEdge.Net.HTTP.StatusCodeEnum.
using OpenEdge.Web.DataObject.DataObjectService.
using OpenEdge.Web.DataObject.ElementTypeEnum.
using OpenEdge.Web.DataObject.IServiceRegistry.
using OpenEdge.Web.DataObject.MappedOperation.
using OpenEdge.Web.DataObject.MessageElement.
using OpenEdge.Web.DataObject.OperationOptions.
using OpenEdge.Web.DataObject.OperationParameter.
using OpenEdge.Web.DataObject.SchemaOption.
using OpenEdge.Web.DataObject.ServiceMappingFileSchemaEnum.
using OpenEdge.Web.DataObject.ServiceOptions.
using OpenEdge.Web.DataObject.ServiceRegistryImpl.
using OpenEdge.Web.DataObject.TargetTypeEnum.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonDataType.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.ObjectModelParser.

class OpenEdge.Web.DataObject.ServiceRegistryLoader implements ISupportLogging:

    /* We never add records to this, just use it to test case-sensitivity. */
    define private static temp-table ttCaseSensitive no-undo
        field csChar as character case-sensitive
        field csClob as clob case-sensitive
        .

    // Holds the class that does the actual work/maintains the actual registry
    define public property Registry as IServiceRegistry no-undo
        get():
            if not valid-object(this-object:Registry) then
            do:
                // Use a CCS Service Manager if extant, and let it control this object's lifecycle
                if valid-object(Ccs.Common.Application:ServiceManager) then
                    assign this-object:Registry = cast(Ccs.Common.Application:ServiceManager
                                                                             :getService(get-class(IServiceRegistry)), IServiceRegistry).

                if not valid-object(Registry) then
                    assign this-object:Registry = new ServiceRegistryImpl().
            end.

            return this-object:Registry.
        end get.
        set.

    define private variable mJsonParser as ObjectModelParser no-undo.
    // To avoid having to recache
    define private variable mcInstanceRoot as character no-undo.

    // A reference to the Logger in use by an implementer
    define public property Logger as ILogWriter no-undo get. set.

    /* Constructor

       @param IServiceRegistry The registry into which to load the services */
    constructor public ServiceRegistryLoader(input pRegistry as IServiceRegistry):
        this-object().

        Assert:NotNull(pRegistry, 'Service registry').

        assign this-object:Registry = pRegistry.
    end constructor.

    /* Default constructor */
    constructor public ServiceRegistryLoader():
        assign mJsonParser        = new ObjectModelParser()
               // use the token resolution mechanism to allow hooks for testing
               mcInstanceRoot     = replace(TokenResolver:ResolveToken('env', 'CATALINA_BASE', ?), StringConstant:BACKSLASH, '/':u)
               // Note that it's NOT the ServiceRegistry type
               this-object:Logger = LoggerBuilder:GetLogger(this-object:GetClass())
               .
    end constructor.

    /* Indicates whether a named service is available. Will attempt to
       locate a service map if it is not yet registered, and will register
       it if one can be found. The search path for finding the service mapping
       files is

       1. Look in the webapp's WEB-INF/openedge folder first
       2. Look in the instance's /openedge folder next
       3. Look in the rest of PROPATH

       @param character The name of the mapped service
       @param character The name of the webapp currently executed
       @return logical TRUE if the service exists */
    method public logical TryFindService(input pcServiceName as character,
                                         input pcWebAppPath as character):
        // is there any version registered?
        if this-object:Registry:HasService(pcServiceName) then
            return true.

        return TryFindService(pcServiceName, '':u, pcWebAppPath).
    end method.

    /* Indicates whether a named service is available. Will attempt to
       locate a service map if it is not yet registered, and will register
       it if one can be found. The search path for finding the service mapping
       files is

       1. Look in the webapp's WEB-INF/openedge folder first
       2. Look in the instance's /openedge folder next
       3. Look in the rest of PROPATH

       @param character The name of the mapped service
       @param character The version of the service
       @param character The name of the webapp currently executed
       @return logical TRUE if the service exists */
    method public logical TryFindService(input pServiceName as character,
                                         input pVersion as character,
                                         input pWebAppPath as character):
        var File mappingFile.
        var character filePrefix.

        Assert:NotNull(pServiceName, 'Service name').
        Assert:NotNull(pVersion, 'Service version').
        Assert:NotNull(pWebAppPath, 'Web app path').

        assign pServiceName = DataObjectService:NormaliseServiceName(pServiceName).

        if pWebAppPath eq '':u then
            assign pWebAppPath = 'ROOT':u.

        Logger:Trace(substitute('Searching for service "&1" version "&2" in path "&3"',
                                pServiceName, pVersion, pWebAppPath)).

        if this-object:Registry:HasService(pServiceName, pVersion) then
            return true.

        // 1. Look in the webapps' WEB-INF/openedge folder first
        // -----------------------------------------------------
        assign filePrefix = substitute('&1/webapps/&2/WEB-INF/openedge/&3':u,
                                         mcInstanceRoot,
                                         pWebAppPath,
                                         pServiceName).
        // GEN file first, then MAP file next
        this-object:LoadFromFile(pServiceName, pVersion, new File(filePrefix + '.gen')).
        this-object:LoadFromFile(pServiceName, pVersion, new File(filePrefix + '.map')).

        if this-object:Registry:HasService(pServiceName, pVersion) then
            return true.

        // 2. Look in the instance's /openedge folder next
        // -----------------------------------------------
        assign filePrefix = substitute('&1/openedge/&2':u, mcInstanceRoot, pServiceName).
        // GEN file first, then MAP file next
        this-object:LoadFromFile(pServiceName, pVersion, new File(filePrefix + '.gen')).
        this-object:LoadFromFile(pServiceName, pVersion, new File(filePrefix + '.map')).
        if this-object:Registry:HasService(pServiceName, pVersion) then
            return true.

        // 3. Look in the rest of PROPATH
        // -----------------------------------------------
        // GEN file first
        assign mappingFile = new File(pServiceName + '.gen':u).
        this-object:LoadFromFile(pServiceName, pVersion, mappingFile).

        // MAP file next
        // if a GEN file exists, then look in the same folder, otherwise look anywhere on PROPATH
        if mappingFile:FileExists then
            this-object:LoadFromFile(pServiceName, pVersion, new File(mappingFile:AbsoluteFilePath() + '/' + pServiceName + '.map':u)).
        else
            this-object:LoadFromFile(pServiceName, pVersion, new File(pServiceName + '.map':u)).

        return this-object:Registry:HasService(pServiceName, pVersion).
    end method.

    /* Register a service in this handler.

       @param character  (mandatory) The service name.
       @param JsonObject (recommended) An operation map for the service.
       @param JsonObject (optional) A catalog for the service. Optional since it may exist on disk */
    method public DataObjectService RegisterService(input pcServiceName  as character,
                                                    input pcVersion as character,
                                                    input poOperations as JsonObject,
                                                    input poCatalog as JsonObject,
                                                    input poSchemas as JsonObject ):
        define variable numSchemas    as integer              no-undo initial 0.
        define variable numOperations as integer              no-undo initial 0.
        define variable registerTime  as datetime-tz extent 2 no-undo.
        define variable svc           as DataObjectService    no-undo.

        Assert:NotNullOrEmpty(pcServiceName, 'Service name').
        Assert:NotNull(pcVersion, 'Service version').

        assign registerTime[1] = now
               // Service registration
               svc = this-object:Registry:RegisterService(pcServiceName, SemanticVersion:Parse(pcVersion), ?, poCatalog)
               .

        // Load schemas first since when we create the operation, we'd like to create any schema holders
        if valid-object(poSchemas) then
            assign numSchemas = LoadSchemas(svc, poSchemas).

        if valid-object(poOperations) then
            assign numOperations = LoadOperations(svc, poOperations).

        assign registerTime[2] = now.

        Logger:Info(substitute('Service "&1 v&4" registered with &2 operations and &3 schemas',
                               svc:Name,
                               numOperations,
                               numSchemas,
                               string(svc:Version))).

        Logger:Trace(substitute('Service "&1" registered in &2ms',
                                pcServiceName,
                                interval(registerTime[2], registerTime[1], string(DateTimeAddIntervalEnum:Milliseconds)))).

        return svc.

        catch oError as Progress.Lang.Error:
            Logger:Error(substitute('Error registering service "&1 v&2": &3', svc:Name, string(svc:Version), oError:GetMessage(1)), oError).
            this-object:Registry:DeregisterService(pcServiceName, SemanticVersion:Parse(pcVersion)).
        end catch.
    end method.

    /* Converts a JSON map into internal structures: datasets and/or temp-tables

       @param DataObjectService The service
       @param JsonObject The set of schema
       @return integer The number of schemas loaded */
    method private integer LoadSchemas(input pService as DataObjectService,
                                       input poSchemas as JsonObject):
        define variable iSchemaLoop as integer           no-undo.
        define variable iSchemaMax  as integer           no-undo.
        define variable cSchemaName as longchar   extent no-undo.
        define variable schemaName  as character         no-undo.
        define variable iInnerLoop  as integer           no-undo.
        define variable iInnerMax   as integer           no-undo.
        define variable cTTName     as character  extent no-undo.
        define variable hSchema     as handle            no-undo.
        define variable hTempTable  as handle            no-undo.
        define variable oSchema     as JsonObject        no-undo.
        define variable oTable      as JsonObject        no-undo.
        define variable attribs     as JsonObject        no-undo.

        Assert:NotNull(poSchemas, 'Schemas').

        assign cSchemaName = poSchemas:GetNames()
               iSchemaMax  = extent(cSchemaName)
               .
        if iSchemaMax eq ? then
            return 0.

        SCHEMABLK:
        do iSchemaLoop = 1 to iSchemaMax:
            /* Ignore warnings about possible overflows, as schema names should not exceed 32KB. */
            {&_proparse_ prolint-nowarn(overflow)}
            assign schemaName = string(cSchemaName[iSchemaLoop]).
            if not poSchemas:GetType(schemaName) eq JsonDataType:OBJECT then
                next SCHEMABLK.

            assign oSchema = poSchemas:GetJsonObject(schemaName).
            if oSchema:Has(string(ServiceMappingFileSchemaEnum:fields)) then
                assign hSchema = CreateTempTable(schemaName, oSchema).
            else
            do:
                create dataset hSchema.
                assign hSchema:name    = schemaName
                       extent(cTTName) = ?
                       cTTName         = oSchema:GetNames()
                       iInnerMax       = extent(cTTName)
                       attribs         = ?
                       .

                INNERBLK:
                do iInnerLoop = 1 to iInnerMax:
                    if cTTName[iInnerLoop] eq string(ServiceMappingFileSchemaEnum:attr) then
                    do:
                        if JsonPropertyHelper:HasTypedProperty(oSchema, string(ServiceMappingFileSchemaEnum:attr), JsonDataType:OBJECT) then
                            assign attribs = oSchema:GetJsonObject(string(ServiceMappingFileSchemaEnum:attr)).

                        next INNERBLK.
                    end.

                    assign oTable     = oSchema:GetJsonObject(cTTName[iInnerLoop])
                           hTempTable = CreateTempTable(cTTName[iInnerLoop], oTable)
                           .

                    hSchema:add-buffer(hTempTable:default-buffer-handle).
                end.

                if valid-object(attribs) then
                do:
                    if JsonPropertyHelper:HasTypedProperty(attribs, string(ServiceMappingFileSchemaEnum:serializeHidden), JsonDataType:BOOLEAN) then
                        assign hSchema:serialize-hidden = attribs:GetLogical(string(ServiceMappingFileSchemaEnum:serializeHidden)).

                    if JsonPropertyHelper:HasTypedProperty(attribs, string(ServiceMappingFileSchemaEnum:serializeName), JsonDataType:STRING) then
                        assign hSchema:serialize-name = attribs:GetCharacter(string(ServiceMappingFileSchemaEnum:serializeName)).

                    if JsonPropertyHelper:HasTypedProperty(attribs, string(ServiceMappingFileSchemaEnum:relations), JsonDataType:ARRAY) then
                        AddRelations(hSchema, attribs:GetJsonArray(string(ServiceMappingFileSchemaEnum:relations))).
                end.
            end. //datasets

            pService:PutSchema(schemaName, hSchema).
        end.

        return iSchemaMax.
    end method.

    /* Adds relations between TTs in a dataset

       @param handle The dataset
       @param JsonArray An array of relations */
    method private void AddRelations(input pDataset as handle,
                                     input pRelations as JsonArray):
        define variable loop         as integer    no-undo.
        define variable cnt          as integer    no-undo.
        define variable relFlds      as JsonArray  no-undo.
        define variable fldData      as JsonObject no-undo.
        define variable fldLoop      as integer    no-undo.
        define variable fldCnt       as integer    no-undo.
        define variable fldPairs     as character  no-undo.
        define variable relData      as JsonObject no-undo.
        define variable hdlChild     as handle     no-undo.
        define variable hdlParent    as handle     no-undo.
        define variable hdlRelation  as handle     no-undo.
        define variable delim        as character  no-undo.
        define variable isNested     as logical    no-undo.
        define variable isReposition as logical    no-undo.
        define variable isActive     as logical    no-undo.
        define variable isRecursive  as logical    no-undo.

        Assert:NotNull(pDataset, 'Dataset handle').
        Assert:NotNull(pRelations, 'Dataset relations').

        assign cnt = pRelations:Length.
        LOOPBLK:
        do loop = 1 to cnt
           on error undo, throw:

            if not pRelations:GetType(loop) eq JsonDataType:OBJECT then
            do:
                Logger:Warn(substitute('Unable to add relation &2 to dataset &1 - expecting JsonObject but was &3',
                                       pDataset:name, loop, string(JsonDataTypeEnum:GetEnum(pRelations:GetType(loop))))).
                next LOOPBLK.
            end.

            assign relData = pRelations:GetJsonObject(loop).

            if not JsonPropertyHelper:HasTypedProperty(relData, string(ServiceMappingFileSchemaEnum:parentTable), JsonDataType:STRING) then
            do:
                Logger:Warn(substitute('Unable to add relation &2 to dataset &1 - no parent table name provided',
                                       pDataset:name, loop)).
                next LOOPBLK.
            end.

            if not JsonPropertyHelper:HasTypedProperty(relData, string(ServiceMappingFileSchemaEnum:childTable), JsonDataType:STRING) then
            do:
                Logger:Warn(substitute('Unable to add relation &2 to dataset &1 - no child table name provided',
                                       pDataset:name, loop)).
                next LOOPBLK.
            end.

            if not JsonPropertyHelper:HasTypedProperty(relData, string(ServiceMappingFileSchemaEnum:fields), JsonDataType:ARRAY) then
            do:
                Logger:Warn(substitute('Unable to add relation &2 to dataset &1 - no fields provided',
                                       pDataset:name, loop)).
                next LOOPBLK.
            end.

            assign hdlParent = pDataset:get-buffer-handle(relData:GetCharacter(string(ServiceMappingFileSchemaEnum:parentTable)))
                   hdlChild  = pDataset:get-buffer-handle(relData:GetCharacter(string(ServiceMappingFileSchemaEnum:childTable)))
                   relFlds   = relData:GetJsonArray(string(ServiceMappingFileSchemaEnum:fields))
                   fldCnt    = relFlds:Length
                   fldPairs  = '':u
                   delim     = '':u
                   .

            do fldLoop = 1 to fldCnt:
                if relFlds:GetType(fldLoop) eq JsonDataType:OBJECT then
                do:
                    assign fldData = relFlds:GetJsonObject(fldLoop).
                    if     JsonPropertyHelper:HasTypedProperty(fldData, string(ServiceMappingFileSchemaEnum:parentField), JsonDataType:STRING)
                       and JsonPropertyHelper:HasTypedProperty(fldData, string(ServiceMappingFileSchemaEnum:childField),  JsonDataType:STRING)
                    then
                        assign fldPairs = fldPairs
                                        + delim
                                        + fldData:GetCharacter(string(ServiceMappingFileSchemaEnum:parentField))
                                        + ',':u
                                        + fldData:GetCharacter(string(ServiceMappingFileSchemaEnum:childField))
                               delim    = ',':u
                               .
                end.
            end.

            // make sure we have some fields
            if String:IsNullOrEmpty(fldPairs) then
            do:
                Logger:Warn(substitute('Data-relation field pairs for dataset &1', pDataset:name)).
                next LOOPBLK.
            end.

            if JsonPropertyHelper:HasTypedProperty(relData, string(ServiceMappingFileSchemaEnum:nested), JsonDataType:BOOLEAN) then
                assign isNested = relData:GetLogical(string(ServiceMappingFileSchemaEnum:nested)).
            else
                assign isNested = ?.

            if JsonPropertyHelper:HasTypedProperty(relData, string(ServiceMappingFileSchemaEnum:active), JsonDataType:BOOLEAN) then
                assign isActive = relData:GetLogical(string(ServiceMappingFileSchemaEnum:active)).
            else
                assign isActive = ?.

            if JsonPropertyHelper:HasTypedProperty(relData, string(ServiceMappingFileSchemaEnum:reposition), JsonDataType:BOOLEAN) then
                assign isReposition = relData:GetLogical(string(ServiceMappingFileSchemaEnum:reposition)).
            else
                assign isReposition = ?.

            if JsonPropertyHelper:HasTypedProperty(relData, string(ServiceMappingFileSchemaEnum:recursive), JsonDataType:BOOLEAN) then
                assign isRecursive = relData:GetLogical(string(ServiceMappingFileSchemaEnum:recursive)).
            else
                assign isRecursive = ?.

            assign hdlRelation = pDataset:add-relation(hdlParent, hdlChild, fldPairs,
                                                       isReposition, isNested, isActive, isRecursive).

            // add optional values
            if JsonPropertyHelper:HasTypedProperty(relData, string(ServiceMappingFileSchemaEnum:name), JsonDataType:STRING) then
                assign hdlRelation:name = relData:GetCharacter(string(ServiceMappingFileSchemaEnum:name)).

            if JsonPropertyHelper:HasTypedProperty(relData, string(ServiceMappingFileSchemaEnum:foreignKeyHidden), JsonDataType:BOOLEAN) then
                assign hdlRelation:foreign-key-hidden = relData:GetLogical(string(ServiceMappingFileSchemaEnum:foreignKeyHidden)).

            catch e as Progress.Lang.Error :
                Logger:Warn(substitute('Unable to add data-relation for dataset &1', pDataset:name),
                            e).
            end catch.
        end. // relation loop
    end method.

    /* Creates a temp-table from the JSON config in the mapping file

       @param character The temp-table name
       @param JsonObject The JSON containing the table definition
       @return handle A prepared table-handle   */
    method private handle CreateTempTable(input pcName as character,
                                          input poTable as JsonObject):
        define variable iIndexLoop as integer no-undo.
        define variable iNumIndexes as integer no-undo.
        define variable iFieldLoop as integer no-undo.
        define variable iNumFields as integer no-undo.
        define variable iExtent as integer no-undo.
        define variable oFieldList as JsonArray no-undo.
        define variable oIndexList as JsonObject no-undo.
        define variable oIndex as JsonObject no-undo.
        define variable oField as JsonObject no-undo.
        define variable hTable as handle no-undo.
        define variable hBuffer as handle no-undo.
        define variable hField as handle no-undo.
        define variable cIdxName as character extent no-undo.
        define variable cValue as character no-undo.
        define variable cMode as character no-undo.
        define variable lHasBeforeTable as logical no-undo.
        define variable attrIdx as integer no-undo.
        define variable fieldWithAttr as integer extent no-undo.
        define variable ablType as character no-undo.
        define variable lHasPrimary as logical no-undo.
        define variable lUnique as logical no-undo.
        define variable lPrimary as logical no-undo.
        define variable lWord as logical no-undo.

        create temp-table hTable.

        assign oFieldList = poTable:GetJsonArray(string(ServiceMappingFileSchemaEnum:fields))
               iNumFields = oFieldList:Length
               lHasBeforeTable       = false
               extent(fieldWithAttr) = iNumFields
               attrIdx               = 0
               .

        do iFieldLoop = 1 to iNumFields:
            assign oField  = oFieldList:GetJsonObject(iFieldLoop)
                   iExtent = ?
                   ablType = oField:GetCharacter(string(ServiceMappingFileSchemaEnum:ablType))
                   .

            if oField:Has(string(ServiceMappingFileSchemaEnum:extent)) then
                assign iExtent = oField:GetInteger(string(ServiceMappingFileSchemaEnum:extent)).

            // If there are indexed CHAR or CLOB fields that are case-sensitive, then we must use
            // the static TT in this class to get the proper casing.
            if     iExtent eq ?
               and JsonPropertyHelper:HasTypedProperty(oField, string(ServiceMappingFileSchemaEnum:caseSensitive), JsonDataType:BOOLEAN)
               and oField:GetLogical(string(ServiceMappingFileSchemaEnum:caseSensitive))
            then
                case ablType:
                    when 'character':u then
                        hTable:add-like-field(oField:GetCharacter(string(ServiceMappingFileSchemaEnum:name)),
                                              'ttCaseSensitive.csChar':u).
                    when 'clob':u then
                        hTable:add-like-field(oField:GetCharacter(string(ServiceMappingFileSchemaEnum:name)),
                                              'ttCaseSensitive.csClob':u).
                end case.
            else
                hTable:add-new-field(oField:GetCharacter(string(ServiceMappingFileSchemaEnum:name)), ablType, iExtent).

            // We can only flag fields later so not which (potentially) need updates
            if    oField:Has(string(ServiceMappingFileSchemaEnum:serializeName))
               or oField:Has(string(ServiceMappingFileSchemaEnum:serializeHidden))
            then
                assign attrIdx                = attrIdx + 1
                       fieldWithAttr[attrIdx] = iFieldLoop
                       .
        end.

        if JsonPropertyHelper:HasTypedProperty(poTable, string(ServiceMappingFileSchemaEnum:indexes), JsonDataType:OBJECT) then
            assign oIndexList  = poTable:GetJsonObject(string(ServiceMappingFileSchemaEnum:indexes))
                   cIdxName    = oIndexList:GetNames()
                   iNumIndexes = extent(cIdxName).
        INDEXBLK:
        do iIndexLoop = 1 to iNumIndexes:
            // Basically means there are no [defined] indexes
            if cIdxName[iIndexLoop] eq 'default':u then
                next INDEXBLK.

            assign
                oIndex   = oIndexList:GetJsonObject(cIdxName[iIndexLoop])
                lUnique  = oIndex:GetLogical(string(ServiceMappingFileSchemaEnum:unique))
                lPrimary = oIndex:GetLogical(string(ServiceMappingFileSchemaEnum:primary))
                lWord    = oIndex:GetLogical(string(ServiceMappingFileSchemaEnum:word))
                .

            // By definition a temp-table may only have 1 index marked as primary, regardless of index fields.
            // Only the first primary index to be added as such, while any others will be created as non-primary.
            if lPrimary and not lHasPrimary then do:
                assign lHasPrimary = true. // On the first primary index, mark that we have our 1 possible.
                Logger:Info(substitute('Adding primary index "&1" on temp-table "&2".', cIdxName[iIndexLoop],  pcName)).
            end.
            else if lPrimary then do:
                assign lPrimary = false. // Cannot have more primary indexes after the first is encountered.
                Logger:Warn(substitute('A primary index already exists on "&1", adding "&2" as non-primary.', pcName, cIdxName[iIndexLoop])).
            end.

            hTable:add-new-index(cIdxName[iIndexLoop], lUnique, lPrimary, lWord).

            assign oFieldList = oIndex:GetJsonArray(string(ServiceMappingFileSchemaEnum:fields))
                   iNumFields = oFieldList:Length.
            do iFieldLoop = 1 to iNumFields:
                assign cMode  = 'ASC':u
                       cValue = oFieldList:GetCharacter(iFieldLoop).
                if num-entries(cValue, ':':u) ge 2 then
                    assign cMode = entry(2, cValue, ':':u).

                hTable:add-index-field(cIdxName[iIndexLoop],
                                       entry(1, cValue, ':':u),
                                       cMode).
            end.
        end.

        // Indicate that the TT was defined with BEFORE-TABLE
        if poTable:Has(string(ServiceMappingFileSchemaEnum:trackChanges)) then
            assign lHasBeforeTable = poTable:GetLogical(string(ServiceMappingFileSchemaEnum:trackChanges)).

        hTable:temp-table-prepare(pcName, lHasBeforeTable).

        if JsonPropertyHelper:HasTypedProperty(poTable, string(ServiceMappingFileSchemaEnum:serializeName), JsonDataType:STRING) then
            assign hTable:serialize-name = poTable:GetCharacter(string(ServiceMappingFileSchemaEnum:serializeName)).

        // we use the oFieldList variable for index fields too, so refetch if needed
        if attrIdx gt 0 then
            assign hBuffer    = hTable:default-buffer-handle
                   oFieldList = poTable:GetJsonArray(string(ServiceMappingFileSchemaEnum:fields))
                   .
        do iFieldLoop = 1 to attrIdx:
            assign oField  = oFieldList:GetJsonObject(fieldWithAttr[iFieldLoop])
                   hField  = hBuffer:buffer-field(oField:GetCharacter(string(ServiceMappingFileSchemaEnum:name)))
                   .
            if JsonPropertyHelper:HasTypedProperty(oField, string(ServiceMappingFileSchemaEnum:serializeHidden), JsonDataType:BOOLEAN) then
                assign hField:serialize-hidden = oField:GetLogical(string(ServiceMappingFileSchemaEnum:serializeHidden)).

            if JsonPropertyHelper:HasTypedProperty(oField, string(ServiceMappingFileSchemaEnum:serializeName), JsonDataType:STRING) then
                assign hField:serialize-name = oField:GetCharacter(string(ServiceMappingFileSchemaEnum:serializeName)).
        end.

        return hTable.
    end method.

    /* Converts a JSON map into internal structures: operations with parameters.

       @param DataObjectService The service
       @param JsonObject The operation map
       @return integer The number of operations loaded */
    method private integer LoadOperations(input pService as DataObjectService,
                                          input poOperations as JsonObject):
        define variable numOperations    as integer               no-undo.
        define variable oUri             as JsonObject            no-undo.
        define variable oVerb            as JsonObject            no-undo.
        define variable oEntity          as JsonObject            no-undo.
        define variable oElem            as JsonObject            no-undo.
        define variable propArray        as JsonArray             no-undo.
        define variable oOperationArg    as JsonObject            no-undo.
        define variable oArgs            as JsonArray             no-undo.
        define variable cMethod          as longchar       extent no-undo.
        define variable methodName       as character             no-undo.
        define variable oMethod          as MethodEnum            no-undo.
        define variable iUriLoop         as integer               no-undo.
        define variable iUriMax          as integer               no-undo.
        define variable iVerbLoop        as integer               no-undo.
        define variable iVerbMax         as integer               no-undo.
        define variable iArgLoop         as integer               no-undo.
        define variable iArgMax          as integer               no-undo.
        define variable iElemLoop        as integer               no-undo.
        define variable iElemMax         as integer               no-undo.
        define variable iInputCnt        as integer               no-undo.
        define variable iOutputCnt       as integer               no-undo.
        define variable ioModeName       as character             no-undo.
        define variable ioMode           as IOModeEnum            no-undo.
        define variable oMappedOperation as MappedOperation       no-undo.
        define variable oParam           as OperationParameter    no-undo.
        define variable targetType       as character             no-undo.
        define variable propNames        as longchar       extent no-undo.
        define variable propLoop         as integer               no-undo.
        define variable propMax          as integer               no-undo.
        define variable propData         as JsonObject            no-undo.
        define variable msgElem          as MessageElement extent no-undo.
        define variable propertyName     as character             no-undo.
        define variable relativeUris     as longchar       extent no-undo.
        define variable ablType          as character             no-undo.
        define variable ablName          as character             no-undo.
        define variable elemType         as character             no-undo.
        define variable elemName         as character             no-undo.

        Assert:NotNull(pService, 'Service').
        Assert:NotNull(poOperations, 'Operations').

        assign relativeUris = poOperations:GetNames()
               iUriMax      = extent(relativeUris)
               .

        if iUriMax eq ? then return 0.

        URI-LOOP:
        do iUriLoop = 1 to iUriMax:
            {&_proparse_ prolint-nowarn(overflow)}
            assign extent(cMethod) = ?
                   propertyName    = string(relativeUris[iUriLoop])
                   oUri            = poOperations:GetJsonObject(propertyName)
                   cMethod         = oUri:GetNames()
                   iVerbMax        = extent(cMethod)
                   propertyName    = right-trim(propertyName, '/':u)
                   .

            if propertyName eq '':u then
                assign propertyName = DataObjectService:ROOT_SERVICE_URI.

            VERB-LOOP:
            do iVerbLoop = 1 to iVerbMax:
                {&_proparse_ prolint-nowarn(overflow)}
                assign methodName = string(cMethod[iVerbLoop])
                       oMethod    = MethodEnum:GetEnum(methodName)
                       oVerb      = oUri:GetJsonObject(methodName)
                       .

                case true:
                    when oVerb:Has(string(ServiceMappingFileSchemaEnum:entity)) then do:
                        assign oEntity = oVerb:GetJsonObject(string(ServiceMappingFileSchemaEnum:entity))
                               oArgs   = oEntity:GetJsonArray(string(ServiceMappingFileSchemaEnum:arg))
                               iArgMax = oArgs:Length
                               targetType = '':u
                               .

                        if JsonPropertyHelper:HasTypedProperty(oEntity, string(ServiceMappingFileSchemaEnum:type), JsonDataType:STRING) then
                            assign targetType = oEntity:GetCharacter(string(ServiceMappingFileSchemaEnum:type)).

                        // Backward-compat and values not set in JSON
                        case targetType:
                            when 'cls':u  or
                            when '':u     then
                                assign targetType = string(TargetTypeEnum:Class).
                            when 'proc':u then
                                assign targetType = string(TargetTypeEnum:Procedure).
                        end case.

                        // Continue to the next verb if certain values are not present or are incorrect.
                        if not JsonPropertyHelper:HasTypedProperty(oVerb, string(ServiceMappingFileSchemaEnum:contentType), JsonDataType:STRING) then do:
                            Logger:Error(substitute('&1 is missing or not a string in &2 of "&3" for service "&4"',
                                                    string(ServiceMappingFileSchemaEnum:contentType), methodName, propertyName, pService:Name)).
                            next VERB-LOOP.
                        end.
                        if not JsonPropertyHelper:HasTypedProperty(oEntity, string(ServiceMappingFileSchemaEnum:name), JsonDataType:STRING) then do:
                            Logger:Error(substitute('Entity &1 is missing or not a string in &2 of "&3" for service "&4"',
                                                    string(ServiceMappingFileSchemaEnum:name), methodName, propertyName, pService:Name)).
                            next VERB-LOOP.
                        end.
                        if not JsonPropertyHelper:HasTypedProperty(oEntity, string(ServiceMappingFileSchemaEnum:function), JsonDataType:STRING) then do:
                            Logger:Error(substitute('Entity &1 is missing or not a string in &2 of "&3" for service "&4"',
                                                    string(ServiceMappingFileSchemaEnum:function), methodName, propertyName, pService:Name)).
                            next VERB-LOOP.
                        end.

                        // If data validations passed above, continue to mapping the operation for this service.
                        assign oMappedOperation = new MappedOperation(propertyName,
                                                                      oMethod,
                                                                      oVerb:GetCharacter(string(ServiceMappingFileSchemaEnum:contentType)),
                                                                      targetType,
                                                                      oEntity:GetCharacter(string(ServiceMappingFileSchemaEnum:name)),
                                                                      (if oEntity:Has(string(ServiceMappingFileSchemaEnum:typeof))
                                                                       then oEntity:GetCharacter(string(ServiceMappingFileSchemaEnum:typeof)) else '':u),
                                                                      oEntity:GetCharacter(string(ServiceMappingFileSchemaEnum:function)),
                                                                      (if oVerb:Has(string(ServiceMappingFileSchemaEnum:options))
                                                                       then CreateOperationOptions(oVerb:GetJsonObject(string(ServiceMappingFileSchemaEnum:options))) else ?),
                                                                      (if oVerb:Has(string(ServiceMappingFileSchemaEnum:statusCode))
                                                                       then oVerb:GetInteger(string(ServiceMappingFileSchemaEnum:statusCode)) else integer(StatusCodeEnum:OK))
                                                                      ) no-error.

                        // Because we use GetClass on "targetType" in the constructor of the MappedOperation class, we need to use no-error above.
                        // This will allow us to capture any errors which came from creation of the new operation and gracefully skip to the next.
                        if error-status:error then do:
                            Logger:Error(substitute('Unable to create mapped operation for "&1 &2" for service "&3": &4',
                                                    string(oMethod),
                                                    propertyName,
                                                    pService:Name,
                                                    error-status:get-message(1))).
                            error-status:error = false. // Clear the error condition.
                            next VERB-LOOP.
                        end.

                        // Load the ACLs, if defined
                        if JsonPropertyHelper:HasTypedProperty(oVerb, string(ServiceMappingFileSchemaEnum:accessControl), JsonDataType:ARRAY) then
                            assign propArray                      = oVerb:GetJsonArray(string(ServiceMappingFileSchemaEnum:accessControl))
                                   oMappedOperation:AccessControl = propArray:GetCharacter(1, propArray:Length)
                                   .

                        ARGS-LOOP:
                        do iArgLoop = 1 to iArgMax:
                            assign oOperationArg   = oArgs:GetJsonObject(iArgLoop)
                                   extent(msgElem) = ?
                                   iInputCnt       = 0
                                   iOutputCnt      = 0
                                   .

                            assign ablType = if JsonPropertyHelper:HasTypedProperty(oOperationArg, string(ServiceMappingFileSchemaEnum:ablType), JsonDataType:STRING)
                                             then oOperationArg:GetCharacter(string(ServiceMappingFileSchemaEnum:ablType))
                                             else '':u.

                            // Corrects a common issue where a Progress JSON (object) datatype does not get prefixed with "class".
                            if ablType eq "JsonObject" or ablType eq "Progress.Json.ObjectModel.JsonObject" then
                                assign ablType = "class Progress.Json.ObjectModel.JsonObject".

                            // Corrects a common issue where a Progress JSON (array) datatype does not get prefixed with "class".
                            if ablType eq "JsonArray" or ablType eq "Progress.Json.ObjectModel.JsonArray" then
                                assign ablType = "class Progress.Json.ObjectModel.JsonArray".

                            // The name of the parameter, which may be empty in the case of a return value.
                            assign ablName = if JsonPropertyHelper:HasTypedProperty(oOperationArg, string(ServiceMappingFileSchemaEnum:ablName), JsonDataType:STRING)
                                             then oOperationArg:GetCharacter(string(ServiceMappingFileSchemaEnum:ablName))
                                             else '':u.

                            // Just get the name of the IO mode, will convert to an enum next.
                            assign ioModeName = oOperationArg:GetCharacter(string(ServiceMappingFileSchemaEnum:ioMode)).

                            assign oParam = new OperationParameter(IOModeEnum:GetEnum(ioModeName), ablType, ablName).

                            if oParam:IOMode:IsFlagSet(IOModeEnum:Return) then
                                assign oMappedOperation:ReturnValue = oParam.
                            else
                                oMappedOperation:Parameters:Add(oParam).

                            case oOperationArg:GetType(string(ServiceMappingFileSchemaEnum:msgElem)):
                                when JsonDataType:OBJECT then
                                do:
                                    assign propArray = new JsonArray().
                                    propArray:Add(oOperationArg:GetJsonObject(string(ServiceMappingFileSchemaEnum:msgElem))).
                                end.

                                when JsonDataType:ARRAY then
                                    assign propArray = oOperationArg:GetJsonArray(string(ServiceMappingFileSchemaEnum:msgElem)).

                                otherwise
                                do:
                                    Logger:Error(substitute('Unsupported msgElem type &1',
                                                            oOperationArg:GetType(string(ServiceMappingFileSchemaEnum:msgElem)))).
                                    next ARGS-LOOP.
                                end.
                            end case.

                            assign iElemMax        = propArray:Length
                                   extent(msgElem) = iElemMax
                                   .

                            // we end up with 2 loops because ABL arrays are not dynamically resizable
                            ELEM-CNT-LOOP:
                            do iElemLoop = 1 to iElemMax:
                                assign oElem = propArray:GetJsonObject(iElemLoop)
                                       elemType = '':u
                                       elemName = '':u
                                       .

                                // The splitting of msgElems into INPUT and OUTPUT only makes sense for IN-OUT params
                                if     oElem:Has(string(ServiceMappingFileSchemaEnum:ioMode))
                                   and oParam:IOMode:IsFlagSet(IOModeEnum:Input-Output)
                                then
                                    assign ioMode = IOModeEnum:GetEnum(oElem:GetCharacter(string(ServiceMappingFileSchemaEnum:ioMode))).
                                else
                                    assign ioMode = oParam:IOMode.

                                // The element type tells us how to map this parameter in the HTTP message.
                                if JsonPropertyHelper:HasTypedProperty(oElem, string(ServiceMappingFileSchemaEnum:type), JsonDataType:STRING) then
                                    assign elemType = oElem:GetCharacter(string(ServiceMappingFileSchemaEnum:type)).
                                else do:
                                    Logger:Error(substitute('Element &1 for "&2" is missing or not a string in &3 of "&4" for service "&5"',
                                                            string(ServiceMappingFileSchemaEnum:type), ablName, methodName, propertyName, pService:Name)).
                                    next ELEM-CNT-LOOP.
                                end.

                                // This doesn't mean we fail as this can legit be a NULL value (eg. for the BODY element type).
                                if JsonPropertyHelper:HasTypedProperty(oElem, string(ServiceMappingFileSchemaEnum:name), JsonDataType:STRING) then
                                    assign elemName = oElem:GetCharacter(string(ServiceMappingFileSchemaEnum:name)).

                                // Add element by given name as expected type (eg. field, body, etc.)
                                assign msgElem[iElemLoop] = new MessageElement(ElementTypeEnum:GetEnum(elemType), elemName, ioMode) no-error.
                                if error-status:error then do:
                                    // Certain element types require a name, so we should trap for that case and handle it gracefully.
                                    Logger:Error(substitute('Could not add Message Element for "&1" (as &2) in &3 of "&4" for service "&5"',
                                                            ablName, elemType, methodName, propertyName, pService:Name)).
                                    error-status:error = false. // Clear the error condition.
                                    next ELEM-CNT-LOOP.
                                end.

                                // Increment counts only after completing the creating of the message element.
                                if ioMode:IsFlagSet(IOModeEnum:Input) then
                                    assign iInputCnt = iInputCnt + 1.

                                // Return types are counted as output elements.
                                if    ioMode:IsFlagSet(IOModeEnum:Output)
                                   or ioMode:IsFlagSet(IOModeEnum:Return)
                                then
                                    assign iOutputCnt = iOutputCnt + 1.

                                // If this is an ARRAY of any type or a CLASS then we can set the ablRef
                                if oElem:Has(string(ServiceMappingFileSchemaEnum:ablRef)) then
                                do:
                                    if     oParam:IsArray
                                       and oElem:GetType(string(ServiceMappingFileSchemaEnum:ablRef)) eq JsonDataType:NUMBER
                                    then
                                        assign msgElem[iElemLoop]:ABLReference = string(oElem:GetInteger(string(ServiceMappingFileSchemaEnum:ablRef))).
                                    else
                                    if not oParam:IsPrimitive
                                       and oElem:GetType(string(ServiceMappingFileSchemaEnum:ablRef)) eq JsonDataType:STRING
                                    then
                                        assign msgElem[iElemLoop]:ABLReference = oElem:GetCharacter(string(ServiceMappingFileSchemaEnum:ablRef)).
                                end.
                            end. // ELEM-CNT-LOOP

                            if iInputCnt gt 0 then
                                assign extent(oParam:InputElement) = iInputCnt
                                       // for the ELEM-ADD-LOOP
                                       iInputCnt = 1
                                       .

                            if iOutputCnt gt 0 then
                                assign extent(oParam:OutputElement) = iOutputCnt
                                       // for the ELEM-ADD-LOOP
                                       iOutputCnt = 1
                                       .

                            ELEM-ADD-LOOP:
                            do iElemLoop = 1 to iElemMax:
                                // Only add valid element object instances.
                                if not valid-object(msgElem[iElemLoop]) then
                                    next ELEM-ADD-LOOP.

                                // Covers INPUT and INPUT-OUTPUT parameters
                                if msgElem[iElemLoop]:IoMode:IsFlagSet(IOModeEnum:Input) then
                                    assign oParam:InputElement[iInputCnt] = msgElem[iElemLoop]
                                           iInputCnt                      = iInputCnt + 1
                                           .

                                // Covers INPUT-OUTPUT, OUTPUT and RETURN parameters
                                if    msgElem[iElemLoop]:IoMode:IsFlagSet(IOModeEnum:Output)
                                   or msgElem[iElemLoop]:IoMode:IsFlagSet(IOModeEnum:Return)
                                then
                                    assign oParam:OutputElement[iOutputCnt] = msgElem[iElemLoop]
                                           iOutputCnt                       = iOutputCnt + 1
                                           .
                            end. /* ELEM-ADD-LOOP */
                        end. /* ARGS-LOOP: */

                        // Increment if we survived the loop without exiting.
                        assign numOperations = numOperations + 1.
                    end. // entity

                    when oVerb:Has(string(ServiceMappingFileSchemaEnum:file)) then do:
                        // Continue to the next verb if certain values are not present or are incorrect.
                        if not JsonPropertyHelper:HasTypedProperty(oVerb, string(ServiceMappingFileSchemaEnum:contentType), JsonDataType:STRING) then do:
                            Logger:Error(substitute('&1 is missing or not a string in &2 of "&3" for service "&4"',
                                                    string(ServiceMappingFileSchemaEnum:contentType), methodName, propertyName, pService:Name)).
                            next VERB-LOOP.
                        end.
                        if not JsonPropertyHelper:HasTypedProperty(oVerb, string(ServiceMappingFileSchemaEnum:file), JsonDataType:STRING) then do:
                            Logger:Error(substitute('&1 is missing or not a string in &2 of "&3" for service "&4"',
                                                    string(ServiceMappingFileSchemaEnum:file), methodName, propertyName, pService:Name)).
                            next VERB-LOOP.
                        end.

                        assign oMappedOperation = new MappedOperation(propertyName,
                                                                      oMethod,
                                                                      oVerb:GetCharacter(string(ServiceMappingFileSchemaEnum:contentType)),
                                                                      string(TargetTypeEnum:File),
                                                                      oVerb:GetCharacter(string(ServiceMappingFileSchemaEnum:file)),
                                                                      '':u, // type-of
                                                                      '':u, // function
                                                                      (if JsonPropertyHelper:HasTypedProperty(oVerb, string(ServiceMappingFileSchemaEnum:options), JsonDataType:OBJECT)
                                                                       then CreateOperationOptions(oVerb:GetJsonObject(string(ServiceMappingFileSchemaEnum:options))) else ?),
                                                                      (if JsonPropertyHelper:HasTypedProperty(oVerb, string(ServiceMappingFileSchemaEnum:statusCode), JsonDataType:NUMBER)
                                                                       then oVerb:GetInteger(string(ServiceMappingFileSchemaEnum:statusCode)) else integer(StatusCodeEnum:OK))
                                                                      ).

                        // Increment if we survived the loop without exiting.
                        assign numOperations = numOperations + 1.
                    end. // file

                    otherwise do:
                        // Defaults to VOID
                        {&_proparse_ prolint-nowarn(overflow)}
                        assign oMappedOperation = new MappedOperation(propertyName,
                                                                      oMethod,
                                                                      (if JsonPropertyHelper:HasTypedProperty(oVerb, string(ServiceMappingFileSchemaEnum:contentType), JsonDataType:STRING)
                                                                       then oVerb:GetCharacter(string(ServiceMappingFileSchemaEnum:contentType)) else '':u),
                                                                      string(TargetTypeEnum:Void),
                                                                      // target name can be stringified JSON
                                                                      (if not oVerb:Has(string(ServiceMappingFileSchemaEnum:void)) or oVerb:GetType(string(ServiceMappingFileSchemaEnum:void)) eq JsonDataType:NULL
                                                                       then '':u else string(oVerb:GetJsonText(string(ServiceMappingFileSchemaEnum:void)))),
                                                                      '':u, // type-of
                                                                      '':u, // function
                                                                      (if JsonPropertyHelper:HasTypedProperty(oVerb, string(ServiceMappingFileSchemaEnum:options), JsonDataType:OBJECT)
                                                                       then CreateOperationOptions(oVerb:GetJsonObject(string(ServiceMappingFileSchemaEnum:options))) else ?),
                                                                      (if JsonPropertyHelper:HasTypedProperty(oVerb, string(ServiceMappingFileSchemaEnum:statusCode), JsonDataType:NUMBER)
                                                                       then oVerb:GetInteger(string(ServiceMappingFileSchemaEnum:statusCode)) else integer(StatusCodeEnum:NotFound))
                                                                      ).

                        // Increment if we survived the loop without exiting.
                        assign numOperations = numOperations + 1.
                    end. // void
                end case.

                // Add the operation to the service
                pService:PutOperation(oMappedOperation).

                // If there's a 'name' property, add it to the options for the operation
                if JsonPropertyHelper:HasTypedProperty(oVerb, string(ServiceMappingFileSchemaEnum:name), JsonDataType:STRING) then
                    assign oMappedOperation:Name = oVerb:GetCharacter(string(ServiceMappingFileSchemaEnum:name)).

                // If there are a set of headers defined to return, then add them
                if JsonPropertyHelper:HasTypedProperty(oVerb, string(ServiceMappingFileSchemaEnum:headers), JsonDataType:OBJECT) then
                do:
                    assign extent(propNames) = ?
                           propData  = oVerb:GetJsonObject(string(ServiceMappingFileSchemaEnum:headers))
                           propNames = propData:GetNames()
                           propMax   = extent(propNames)
                           .
                    do propLoop = 1 to propMax:
                        {&_proparse_ prolint-nowarn(overflow)}
                        assign propertyName = string(propNames[propLoop]).
                        if JsonPropertyHelper:HasTypedProperty(propData, propertyName, JsonDataType:STRING) then
                            oMappedOperation:Headers:Put(HttpHeaderBuilder:Build(propertyName)
                                                                          :Value(propData:GetCharacter(propertyName))
                                                                          :Header).
                    end.
                end.

                // If there are a set of cookies defined to return, then add them
                if JsonPropertyHelper:HasTypedProperty(oVerb, string(ServiceMappingFileSchemaEnum:cookies), JsonDataType:ARRAY) then
                do:
                    assign propArray = oVerb:GetJsonArray(string(ServiceMappingFileSchemaEnum:cookies))
                           propMax    = propArray:Length
                           .
                    do propLoop = 1 to propMax:
                        if propArray:GetType(propLoop) eq JsonDataType:STRING then
                            oMappedOperation:Cookies:Add(Cookie:Parse(propArray:GetCharacter(propLoop))).
                    end.
                end.
            end.    /* VERB-LOOP: */
        end.    /* URI-LOOP: */

        return numOperations.
    end method.

    /* Loads all services from the file

       @param File The file being loaded */
    method  private void LoadFromFile(input pFile as File):
        define variable oMap as JsonObject no-undo.
        define variable oServiceList as JsonObject no-undo.
        define variable cServiceName as character extent no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable verCnt as integer no-undo.
        define variable verMax as integer no-undo.
        define variable svcVersions as JsonArray no-undo.
        define variable fileName as character no-undo.

        Assert:NotNull(pFile, 'File').

        if not pFile:FileExists then
        do:
            Logger:Debug(substitute('Mapping file "&1" does not exist', pFile:Name)).
            return.
        end.

        assign fileName = pFile:AbsoluteFileName().
        Logger:Debug(substitute('Loading map: &1', fileName)).

        // Attempt to parse the file and capture any errors which may have arisen.
        // There's really no recovery for a failed parsing of the JSON data.
        assign oMap = cast(mJsonParser:ParseFile(fileName), JsonObject) no-error.
        if error-status:error then do:
            Logger:Error(substitute('Unable to parse mapping file "&1": &2', pFile:Name, error-status:get-message(1))).
            error-status:error = false. // Clear the error condition.
            return.
        end.

        if not oMap:Has(string(ServiceMappingFileSchemaEnum:services)) or
           not oMap:GetType(string(ServiceMappingFileSchemaEnum:services)) eq JsonDataType:OBJECT then
        do:
            Logger:Debug(substitute('Unable to find any services in file &1', fileName)).
            return.
        end.

        assign oServiceList = oMap:GetJsonObject(string(ServiceMappingFileSchemaEnum:services))
               cServiceName = oServiceList:GetNames()
               iMax         = extent(cServiceName)
               .
        LOOPBLK:
        do iLoop = 1 to iMax:
            case oServiceList:GetType(cServiceName[iLoop]):
                when JsonDataType:OBJECT then
                do:
                    assign svcVersions = new JsonArray().
                    svcVersions:Add(oServiceList:GetJsonObject(cServiceName[iLoop])).
                end.
                when JsonDataType:ARRAY then
                    assign svcVersions = oServiceList:GetJsonArray(cServiceName[iLoop]).
                otherwise
                do:
                    Logger:Debug(substitute('Unable to find any load service &1 from &2 JSON data',
                                    cServiceName[iLoop], oServiceList:GetType(cServiceName[iLoop]))).
                    next LOOPBLK.
                end.
            end case.

            assign verMax = svcVersions:Length.
            do verCnt = 1 to verMax:
                LoadService(cServiceName[iLoop], '':u, svcVersions:GetJsonObject(verCnt)).
            end.
        end.
    end method.

    /* Loads a named service from a file

       @param character The service name to load
       @param character A version to load
       @param File The file being loaded */
    method private void LoadFromFile(input pcServiceName as character,
                                     input pVersion as character,
                                     input pFile as File):
        define variable oMap as JsonObject no-undo.
        define variable oServiceList as JsonObject no-undo.
        define variable verCnt as integer no-undo.
        define variable verMax as integer no-undo.
        define variable svcVersions as JsonArray no-undo.
        define variable fileName as character no-undo.

        Assert:NotNullOrEmpty(pcServiceName, 'Service name').
        Assert:NotNull(pVersion, 'Service version').
        Assert:NotNull(pFile, 'File').

        if not pFile:FileExists then
        do:
            Logger:Debug(substitute('Mapping file "&1" does not exist', pFile:Name)).
            return.
        end.

        assign fileName = pFile:AbsoluteFileName().
        Logger:Debug(substitute('Loading map: &1', fileName)).

        // Attempt to parse the file and capture any errors which may have arisen.
        // There's really no recovery for a failed parsing of the JSON data.
        assign oMap = cast(mJsonParser:ParseFile(fileName), JsonObject) no-error.
        if error-status:error then do:
            Logger:Error(substitute('Unable to parse mapping file "&1": &2', pFile:Name, error-status:get-message(1))).
            error-status:error = false. // Clear the error condition.
            return.
        end.

        if not oMap:Has(string(ServiceMappingFileSchemaEnum:services)) or
           not oMap:GetType(string(ServiceMappingFileSchemaEnum:services)) eq JsonDataType:OBJECT then
        do:
            Logger:Debug(substitute('No services found in file &1', fileName)).
            return.
        end.

        assign oServiceList = oMap:GetJsonObject(string(ServiceMappingFileSchemaEnum:services)).
        case true:
            when oServiceList:Has(pcServiceName) then
                /* no-op */ .
            when oServiceList:Has('/':u + pcServiceName) then
                assign pcServiceName = '/':u + pcServiceName.
            otherwise
            do:
                Logger:Debug(substitute('Unable to find service &1 in file &2', pcServiceName, fileName)).
                return.
            end.
        end case.

        case oServiceList:GetType(pcServiceName):
            when JsonDataType:OBJECT then
            do:
                assign svcVersions = new JsonArray().
                svcVersions:Add(oServiceList:GetJsonObject(pcServiceName)).
            end.
            when JsonDataType:ARRAY then
                assign svcVersions = oServiceList:GetJsonArray(pcServiceName).
            otherwise
            do:
                Logger:Debug(substitute('Unable to find any load service &1 from &2 JSON data',
                                pcServiceName, oServiceList:GetType(pcServiceName))).
            end.
        end case.

        assign verMax = svcVersions:Length.
        do verCnt = 1 to verMax:
            LoadService(pcServiceName, pVersion, svcVersions:GetJsonObject(verCnt)).
        end.
    end method.

    /* Loads and registers a single service name/version service from JSON

       @param character The service name
       @param JsonObject The service definition */
    method private void LoadService(input pServiceName as character,
                                    input pVersion as character,
                                    input pService as JsonObject):
        define variable oOperations as JsonObject no-undo.
        define variable oSchemas as JsonObject no-undo.
        define variable oCatalog as JsonObject no-undo.
        define variable semVer as SemanticVersion no-undo.
        define variable svc as DataObjectService no-undo.

        // Service Info
        if JsonPropertyHelper:HasTypedProperty(pService, string(ServiceMappingFileSchemaEnum:version), JsonDataType:STRING) then
            assign semVer = SemanticVersion:Parse(pService:GetCharacter(string(ServiceMappingFileSchemaEnum:version))).
        else
            assign semVer = new SemanticVersion().

        // If we passed a non-empty version in, then compare
        if not pVersion eq '':u
           and not string(semVer) eq pVersion
        then
            return.

        if JsonPropertyHelper:HasTypedProperty(pService, string(ServiceMappingFileSchemaEnum:operations), JsonDataType:OBJECT) then
            assign oOperations = pService:GetJsonObject(string(ServiceMappingFileSchemaEnum:operations)).
        else
            Logger:Trace(substitute('Notice: No &1 configured for service "&2" &3', string(ServiceMappingFileSchemaEnum:operations), pServiceName, pVersion)).

        if JsonPropertyHelper:HasTypedProperty(pService, string(ServiceMappingFileSchemaEnum:schemas), JsonDataType:OBJECT) then
            assign oSchemas = pService:GetJsonObject(string(ServiceMappingFileSchemaEnum:schemas)).
        else
            Logger:Trace(substitute('Notice: No &1 configured for service "&2" &3', string(ServiceMappingFileSchemaEnum:schemas), pServiceName, pVersion)).

        if JsonPropertyHelper:HasTypedProperty(pService, string(ServiceMappingFileSchemaEnum:catalog), JsonDataType:OBJECT) then
            assign oCatalog = pService:GetJsonObject(string(ServiceMappingFileSchemaEnum:catalog)).
        else
            Logger:Trace(substitute('Notice: No &1 configured for service "&2" &3', string(ServiceMappingFileSchemaEnum:catalog), pServiceName, pVersion)).

        assign svc = RegisterService(pServiceName,
                                     semVer:ToString(),
                                     oOperations,
                                     oCatalog,
                                     oSchemas).

        if JsonPropertyHelper:HasTypedProperty(pService, string(ServiceMappingFileSchemaEnum:options), JsonDataType:OBJECT) then
            LoadServiceOptions(svc, pService:GetJsonObject(string(ServiceMappingFileSchemaEnum:options))).

        if JsonPropertyHelper:HasTypedProperty(pService, string(ServiceMappingFileSchemaEnum:argumentWriters), JsonDataType:ARRAY) then
            LoadServiceWriters(svc, pService:GetJsonArray(string(ServiceMappingFileSchemaEnum:argumentWriters))).
    end method.

    /* Registers all services found in a given file. Can be used at agent startup

       @param character An extant file */
    method public void RegisterFromFile(input pcFile as character):
        AssertFile:FileExists(pcFile).

        this-object:LoadFromFile(new File(pcFile)).
     end method.

    /* Registers a named service found in a given file. Can be used at agent startup

       @param character A service name
       @param character An extant file */
    method public void RegisterFromFile(input pcServiceName as character,
                                        input pcFile as character):
        Assert:NotNullOrEmpty(pcServiceName, 'Service name').
        AssertFile:FileExists(pcFile).

        this-object:LoadFromFile(pcServiceName, '':u, new File(pcFile)).
     end method.

    /* Registers all services found in a given folder. Can be used at agent startup

       @param character An extant folder */
    method public void RegisterAllFromFolder(input pcFolder as character):
        define variable cService as character no-undo.
        define variable cFlag as character no-undo.

        AssertFile:DirectoryExists(pcFolder).

        input from os-dir(pcFolder).
        repeat:
            import cService ^ cFlag.

            if index(cFlag, 'F') gt 0
            and num-entries(cService, '.':u) gt 1
            then
            case entry(2, cService, '.':u):
                when 'gen':u or when 'map':u then
                    /* will register if it can */
                    this-object:RegisterFromFile(pcFolder + '/':u + cService).
            end case.
        end.

        finally:
            input close.
        end finally.
    end method.

    /* Creates an Operations Options object from the JSON config. This method will always return an instance,
       even if an invalid object is passed in.

       @param JsonObject The JSON defining the options
       @return OperationOptions A usable options object. */
    method private OperationOptions CreateOperationOptions(input pData as JsonObject):
        define variable options as OperationOptions no-undo.
        define variable maxProps as integer no-undo.
        define variable loop as integer no-undo.
        define variable propName as character extent no-undo.
        define variable jsonData as JsonObject no-undo.
        define variable schemaOption as SchemaOption no-undo.

        assign options = new OperationOptions().

        if not valid-object(pData) then
            return options.

        if JsonPropertyHelper:HasTypedProperty(pData, string(ServiceMappingFileSchemaEnum:writeBI), JsonDataType:BOOLEAN) then
            assign options:WriteBI = pData:GetLogical(string(ServiceMappingFileSchemaEnum:writeBI)).

        if JsonPropertyHelper:HasTypedProperty(pData, string(ServiceMappingFileSchemaEnum:timeout), JsonDataType:NUMBER) then
            assign options:Timeout = pData:GetInteger(string(ServiceMappingFileSchemaEnum:timeout)).

        if pData:Has(string(ServiceMappingFileSchemaEnum:requestEnvelope)) then
            case pData:GetType(string(ServiceMappingFileSchemaEnum:requestEnvelope)):
                when JsonDataType:BOOLEAN then
                    assign options:HasRequestEnvelope = pData:GetLogical(string(ServiceMappingFileSchemaEnum:requestEnvelope)).
                when JsonDataType:STRING then
                    assign options:HasRequestEnvelope = true
                           options:RequestEnvelope = pData:GetCharacter(string(ServiceMappingFileSchemaEnum:requestEnvelope))
                           .
            end case.

        if pData:Has(string(ServiceMappingFileSchemaEnum:responseEnvelope)) then
            case pData:GetType(string(ServiceMappingFileSchemaEnum:responseEnvelope)):
                when JsonDataType:BOOLEAN then
                    assign options:HasResponseEnvelope = pData:GetLogical(string(ServiceMappingFileSchemaEnum:responseEnvelope)).
                when JsonDataType:STRING then
                    assign options:HasResponseEnvelope = true
                           options:ResponseEnvelope    = pData:GetCharacter(string(ServiceMappingFileSchemaEnum:responseEnvelope))
                           .
            end case.

        if pData:Has(string(ServiceMappingFileSchemaEnum:errorEnvelope)) then
            case pData:GetType(string(ServiceMappingFileSchemaEnum:errorEnvelope)):
                when JsonDataType:BOOLEAN then
                    assign options:HasErrorEnvelope = pData:GetLogical(string(ServiceMappingFileSchemaEnum:errorEnvelope)).
                when JsonDataType:STRING then
                    assign options:HasErrorEnvelope = true
                           options:ErrorEnvelope    = pData:GetCharacter(string(ServiceMappingFileSchemaEnum:errorEnvelope))
                           .
            end case.

        if JsonPropertyHelper:HasTypedProperty(pData, string(ServiceMappingFileSchemaEnum:schemas), JsonDataType:OBJECT) then
        do:
            assign jsonData  = pData:GetJsonObject(string(ServiceMappingFileSchemaEnum:schemas))
                   propName = jsonData:GetNames()
                   maxProps = extent(propName)
                   .
            LOOPBLK:
            do loop = 1 to maxProps:
                if not jsonData:GetType(propName[loop]) eq JsonDataType:OBJECT then
                    next LOOPBLK.

                assign schemaOption = new SchemaOption(propName[loop]).
                LoadSchemaOptions(schemaOption, jsonData:GetJsonObject(propName[loop])).

                options:SchemaOptions:Put(schemaOption:SchemaName, schemaOption).
            end.
        end.

        return options.
    end method.

    /* Loads schema options for a given schema and its children

       @param SchemaOption The current option to populate
       @param JsonObject The config data from the MAP/GEN file */
    method private void LoadSchemaOptions(input pSchemaOption as SchemaOption,
                                          input pData as JsonObject):
        define variable propertyNames as character extent no-undo.
        define variable numProps as integer no-undo.
        define variable loop as integer no-undo.
        define variable childOption as SchemaOption no-undo.
        define variable childData as JsonObject no-undo.

        // nothing to load
        if not valid-object(pData) then
            return.

        if JsonPropertyHelper:HasTypedProperty(pData, string(ServiceMappingFileSchemaEnum:serializeHidden), JsonDataType:BOOLEAN) then
            assign pSchemaOption:Hidden = pData:GetLogical(string(ServiceMappingFileSchemaEnum:serializeHidden)).

        if JsonPropertyHelper:HasTypedProperty(pData, string(ServiceMappingFileSchemaEnum:serializeName), JsonDataType:STRING) then
            assign pSchemaOption:SerializeName = pData:GetCharacter(string(ServiceMappingFileSchemaEnum:serializeName)).

        // Can have FIELDS or TABLES as children
        if JsonPropertyHelper:HasTypedProperty(pData, string(ServiceMappingFileSchemaEnum:fields), JsonDataType:OBJECT) then
            assign childData = pData:GetJsonObject(string(ServiceMappingFileSchemaEnum:fields)).
        else
        if JsonPropertyHelper:HasTypedProperty(pData, string(ServiceMappingFileSchemaEnum:tables), JsonDataType:OBJECT) then
            assign childData = pData:GetJsonObject(string(ServiceMappingFileSchemaEnum:tables)).

        if valid-object(childData) then
        do:
            assign propertyNames = childData:GetNames()
                   numProps      = extent(propertyNames)
                   .
            do loop = 1 to numProps:
                assign childOption = new SchemaOption(propertyNames[loop]).
                pSchemaOption:PutChildSchema(childOption).

                LoadSchemaOptions(input childOption,
                                  input childData:GetJsonObject(propertyNames[loop])).
            end.
        end.
    end method.

    /** Loads service writers from JSON config.
        These are classes which know how to write (output) and potentially format argument datatypes.

        @param DataObjectService The service
        @param JsonArray The service writers */
    method private void LoadServiceWriters(input pService as DataObjectService,
                                           input pData    as JsonArray):
        define variable cnt as integer no-undo.
        define variable loop as integer no-undo.
        define variable writerMap as JsonObject no-undo.
        define variable writerName as character no-undo.
        define variable writerType as character no-undo.
        define variable writerClass as class Progress.Lang.Class no-undo.

        Assert:NotNull(pData, 'Writer data').
        assign cnt = pData:Length.
        COUNTLOOP:
        do loop = 1 to cnt
        on error undo, throw:
            if not pData:GetType(loop) eq JsonDataType:OBJECT then
                next COUNTLOOP.

            assign writerMap = pData:GetJsonObject(loop).
            if JsonPropertyHelper:HasTypedProperty(writerMap, string(ServiceMappingFileSchemaEnum:name), JsonDataType:STRING) then
                assign writerName = writerMap:GetCharacter(string(ServiceMappingFileSchemaEnum:name)).

            if JsonPropertyHelper:HasTypedProperty(writerMap, string(ServiceMappingFileSchemaEnum:type), JsonDataType:STRING) then do:
                assign writerType = writerMap:GetCharacter(string(ServiceMappingFileSchemaEnum:type)).
                Logger:Trace(substitute('Attempting to find writer class "&1"...', writerType)).

                // In the event of an error from GetClass() we should report the issue but then move on to the next.
                assign writerClass = Progress.Lang.Class:GetClass(writerType) no-error.
                if error-status:error then do:
                    Logger:Error(substitute('Unable to find service writer class "&1" of type "&2" for "&3": &4',
                                            writerMap:GetCharacter(string(ServiceMappingFileSchemaEnum:type)),
                                            ServiceMappingFileSchemaEnum:type,
                                            pService:Name,
                                            error-status:get-message(1))).
                    error-status:error = false. // Clear the error condition.
                    next COUNTLOOP.
                end.
            end.

            pService:ArgumentWriters:Put(writerName, writerClass).

            {&_proparse_ prolint-nowarn(varusage)}
            catch uncaught as Progress.Lang.Error:
                next COUNTLOOP.
            end catch.
        end.
    end method.

    /** Loads service options from JSON.

        @param DataObjectService The service
        @param JsonObject The service options */
    {&_proparse_ prolint-nowarn(varusage)}
    method private void LoadServiceOptions(input pService as DataObjectService,
                                           input pData    as JsonObject):
        assign pService:Options = new ServiceOptions(pData).
    end method.

end class.
