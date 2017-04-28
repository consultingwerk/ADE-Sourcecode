/* *************************************************************************************************************************
Copyright (c) 2016 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : ServiceRegistry
    Purpose     : Contains a registry for mapped services 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed May 18 13:06:41 EDT 2016
    Notes       : * static members let multiple DataObjectHandler instances use this
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.Collections.IList.
using OpenEdge.Core.Collections.List.
using OpenEdge.Core.DataTypeEnum.
using OpenEdge.Core.DataTypeHelper.
using OpenEdge.Core.IOModeEnum.
using OpenEdge.Core.LogLevelEnum.
using OpenEdge.Net.HTTP.MethodEnum.
using OpenEdge.Net.HTTP.StatusCodeEnum.
using OpenEdge.Web.DataObject.DataObjectHandler.
using OpenEdge.Web.DataObject.ElementTypeEnum.
using OpenEdge.Web.DataObject.MappedOperation.
using OpenEdge.Web.DataObject.OperationParameter.
using OpenEdge.Web.DataObject.ServiceRegistryEventArgs.
using OpenEdge.Web.DataObject.TargetTypeEnum.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonDataType.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.ObjectModelParser.
using Progress.Lang.AppError.
using OpenEdge.Web.DataObject.ServiceRegistry.
using OpenEdge.Core.Assertion.AssertFile.

class OpenEdge.Web.DataObject.ServiceRegistry:
    /* Event published when a a service has been registered
       
       @param Progress.Lang.Object The handler publishing the event
       @param HandlerErrorEventArgs Event args for this event */
    define static public event ServiceRegistered signature void (input poSender as Progress.Lang.Object,
                                                                 input poEventArgs as ServiceRegistryEventArgs).

    /* Event published when a a service has been de-registered
       
       @param Progress.Lang.Object The handler publishing the event
       @param HandlerErrorEventArgs Event args for this event */
    define static public event ServiceDeregistered signature void (input poSender as Progress.Lang.Object,
                                                                   input poEventArgs as ServiceRegistryEventArgs).
    
    
    define static public property ROOT_SERVICE_NAME as character init 'ROOT':u no-undo get.
    define static public property ROOT_SERVICE_URI  as character init '/':u no-undo get.
    
    define static private variable mJsonParser as ObjectModelParser no-undo.
    // To avoind having to recache
    define static private variable mcInstanceRoot as character no-undo.
    
    define private static temp-table Service no-undo
        field ServiceName       as character
        field Version           as character                /* semver.org: Major.Minor.Patch */
        field ServiceOptions    as Progress.Lang.Object     /* JsonObject */
        field Catalog           as Progress.Lang.Object     /* JsonObject */
        index idx1 as primary unique ServiceName.
    
    define private static temp-table Operation no-undo
        field ServiceName   as character                /* ROOT or something else */
        field URI           as character                /* / or another path */
        field Method        as character                /* HTTP method (GET|PUT|POST|DELETE|...) */
        field MappedOperation as Progress.Lang.Object   /* OpenEdge.Web.DataObject.MappedOperation */ 
        index idx1 as primary unique ServiceName URI Method.

    define private static temp-table DataSchema no-undo
        field ServiceName   as character
        field SchemaName    as character
        field DataStructure as handle
        index idx1 as primary unique ServiceName SchemaName.
    
    constructor static ServiceRegistry():
        assign mJsonParser    = new ObjectModelParser()
               mcInstanceRoot = replace(os-getenv ('CATALINA_BASE':u), '~\':u, '/':u)
               .
    end constructor.
    
    /* Indicates whether a named service is available. Will attempt to 
       locate a service map if it is not yet registered, and will register
       it if one can be found. The search path for finding the service mapping
       files is
       
       1. Look in the webapps' WEB-INF/openedge folder first
       2. Look in the instance's /openedge folder next
       3. Look in the rest of PROPATH  
       
       If the search finds either a <servicename>.GEN or <servicename>.MAP
       in one of these locations, it returns.
       If a .GEN file is found, a .MAP is also searched for.
       
       @param character The name of the mapped service
       @param character The name of the webapp currently executed
       @return logical TRUE if the service exists */
    method static public logical TryFindService(input pcServiceName as character,
                                                input pcWebAppPath as character):
        define variable cFilename as character no-undo.
        
        Assert:NotNullOrEmpty(pcServiceName, 'Service name').

        if ServiceRegistry:HasService(pcServiceName) then
            return true.
        
        Assert:NotNull(pcWebAppPath, 'Web app path').
        
        if pcWebAppPath eq '':u then
            assign pcWebAppPath = 'ROOT':u.
        
        // 1. Look in the webapps' WEB-INF/openedge folder first
        // GEN file first 
        assign file-info:file-name = substitute('&1/webapps/&2/WEB-INF/openedge/&3.gen':u,
                                mcInstanceRoot,
                                pcWebAppPath,
                                pcServiceName)
               cFilename = file-info:full-pathname.
        if cFilename ne ? then
            ServiceRegistry:RegisterFromFile(pcServiceName, cFilename).
                   
        // MAP file next
        assign file-info:file-name = substitute('&1/webapps/&2/WEB-INF/openedge/&3.map':u,
                                mcInstanceRoot,
                                pcWebAppPath,
                                pcServiceName)
               cFilename = file-info:full-pathname.
        if cFilename ne ? then
            ServiceRegistry:RegisterFromFile(pcServiceName, cFilename).
        
        if ServiceRegistry:HasService(pcServiceName) then
            return true.                                         
        
        // 2. Look in the instance's /openedge folder next
        // GEN file first 
        assign file-info:file-name = substitute('&1/openedge/&2.gen':u,
                                mcInstanceRoot,
                                pcServiceName)
               cFilename = file-info:full-pathname.
        if cFilename ne ? then
            ServiceRegistry:RegisterFromFile(pcServiceName, cFilename).
                   
        // MAP file next
        assign file-info:file-name = substitute('&1/openedge/&2.map':u,
                                mcInstanceRoot,
                                pcServiceName)
               cFilename = file-info:full-pathname.
        if cFilename ne ? then
            ServiceRegistry:RegisterFromFile(pcServiceName, cFilename).
        
        if ServiceRegistry:HasService(pcServiceName) then
            return true.
        
        // 3. Look in the rest of PROPATH 
        assign file-info:file-name = substitute('&1.gen':u, pcServiceName)
               cFilename = file-info:full-pathname.
        if cFilename ne ? then
            ServiceRegistry:RegisterFromFile(pcServiceName, cFilename).

        assign file-info:file-name = substitute('&1.map':u, pcServiceName)
               cFilename = file-info:full-pathname.
        if cFilename ne ? then
            ServiceRegistry:RegisterFromFile(pcServiceName, cFilename).
        
        return ServiceRegistry:HasService(pcServiceName).
    end method.    
    
    /* Indicates whether a named service is available. Will attempt to 
       locate a service map if it is not yet registered, and will register
       it if one can be found.
       
       @param character The name of the mapped service
       @return logical TRUE if the service exists */
    method static public logical TryFindService(input pcServiceName as character):
        define buffer lbService for Service.
        
        FindServiceRecord(pcServiceName, buffer lbService).
        
        if not available lbService then
        do:
            RegisterService(pcServiceName).
            FindServiceRecord(pcServiceName, buffer lbService).
        end.
        
        return (available lbService).                                
    end method.        
    
    /* Indicates whether a named service is available in the registry.  
       
       @param character The name of the mapped service
       @return logical TRUE if the service exists */
    method static public logical HasService(input pcServiceName as character):
        define buffer lbService for Service.

        Assert:NotNullOrEmpty(pcServiceName, 'Service name').
        
        FindServiceRecord(pcServiceName, buffer lbService).
        
        return (available lbService).
    end method.
    
    /* Returns all registered service names 
       
       @return character extent An array of registered services. indeterminate if none. */
    method static public integer GetServices(output pcServices as character extent):
        define buffer lbService for Service.
        define query qryService for lbService.
        
        open query qryService preselect each lbService.
        
        assign extent(pcServices) = query qryService:num-results
               no-error.
        
        get first qryService.
        do while available lbService:
            assign pcServices[query qryService:current-result-row] = lbService.ServiceName.
            get next qryService.
        end.
        
        return extent(pcServices).
        finally:
            close query qryService.
        end finally.
    end method.

    /* Sets the service options for a named service 
       
       @param character The service name. 
       @param JsonObject  A JSON object containing options. 
       @throws AssertionFailedError If the name is empty or null
       @throws AppError If the requested service does not exist in the registry */
    method static public void PutServiceOptions(input pcServiceName as character,
                                                input poOptions as JsonObject):
        define buffer lbService for Service.
        
        Assert:NotNullOrEmpty(pcServiceName, 'Service name').
        Assert:NotNull(poOptions, 'Options').
        
        FindServiceRecord(pcServiceName, buffer lbService).
        if not available lbService then
            undo, throw new AppError(substitute('Unable to find service &1', pcServiceName), 0).
        
        assign lbService.ServiceOptions = poOptions.
    end method.         
    
    /* Returns the service options for a named service 
       
       @param character The service name. 
       @return JsonObject  A JSDO object containing options. If no exist or none can be 
                           found, return an empty JSON object.
       @throws AssertionFailedError If the name is empty or null */
    method static public JsonObject GetServiceOptions(input pcServiceName as character):
        define variable oOptions as JsonObject no-undo.
        define buffer lbService for Service.
        
        Assert:NotNullOrEmpty(pcServiceName, 'Service name').
        
        FindServiceRecord(pcServiceName, buffer lbService).
        if not available lbService then
            undo, throw new AppError(substitute('Unable to find service &1', pcServiceName), 0).
        
        if not valid-object(lbService.ServiceOptions) then
            assign lbService.ServiceOptions = new JsonObject(). 
        
        assign oOptions = cast(lbService.ServiceOptions, JsonObject).
        
        return oOptions. 
    end method.
    
    /* Sets a catalog for a named service 
       
       @param character The service name. 
       @param JsonObject  A JSDO catalog. If no exist or none can be found, return null.
       @throws AssertionFailedError If the name is empty or null
       @throws AppError If the requested service does not exist in the registry */
    method static public void PutServiceCatalog(input pcServiceName as character,
                                                input poCatalog as JsonObject):
        define buffer lbService for Service.
        
        Assert:NotNullOrEmpty(pcServiceName, 'Service name').
        Assert:NotNull(poCatalog, 'Catalog').
        
        FindServiceRecord(pcServiceName, buffer lbService).
        if not available lbService then
            undo, throw new AppError(substitute('Unable to find service &1', pcServiceName), 0).
        
        assign lbService.Catalog = poCatalog.
    end method.         
    
    /* Returns a catalog for a named service 
       
       @param character The service name. 
       @return JsonObject  A JSDO catalog. If no exist or none can be found, return null.
       @throws AssertionFailedError If the name is empty or null
       @throws AppError If the requested service does not exist in the registry */
    method static public JsonObject GetServiceCatalog(input pcServiceName as character):
        define buffer lbService for Service.
        
        Assert:NotNullOrEmpty(pcServiceName, 'Service name').
        
        FindServiceRecord(pcServiceName, buffer lbService).
        if not available lbService then
            undo, throw new AppError(substitute('Unable to find service &1', pcServiceName), 0).
        
        return cast(lbService.Catalog, JsonObject).
    end method.
    
    /* Indicates whether a mapped operation exists  
       
       @param character the service name
       @param character The relative URI (to the service)
       @param MethodEnum The HTTP method
       @return logical TRUE if the service exists */
    method static public logical HasOperation(input pcServiceName as character,
                                              input pcServiceURI as character,
                                              input poMethod as MethodEnum ):
        define buffer lbOperation for Operation.
        
        Assert:NotNullOrEmpty(pcServiceName, 'Service name').
        Assert:NotNullOrEmpty(pcServiceURI, 'Service URI').
        Assert:NotNull(poMethod, 'Service method').
        
        FindOperationRecord(pcServiceName, pcServiceURI, poMethod, buffer lbOperation).
        
        return (available lbOperation).                                
    end method.
    
    /* Adds a new operation map for a service.
       
       @param MethodEnum The HTTP method
       @param character The relative URI
       @param MappedOperation The operation map for this Method/URI */
    method static public void PutOperation(input pcServiceName as character,
                                           input poMappedOperation as MappedOperation):
        define buffer lbService for Service.
        define buffer lbOperation for Operation.
        
        Assert:NotNullOrEmpty(pcServiceName, 'Service name').
        Assert:NotNull(poMappedOperation, 'Mapped operation').
    
        if not HasService(pcServiceName) then
            undo, throw new AppError(substitute('Unable to find service &1', pcServiceName), 0).
        
        FindOperationRecord(pcServiceName, poMappedOperation:ServiceURI, poMappedOperation:Method, buffer lbOperation).
        if not available lbOperation then
        do:
            create lbOperation.
            assign lbOperation.URI          = trim(poMappedOperation:ServiceURI, '/':u)
                   lbOperation.Method       = string(poMappedOperation:Method)
                   lbOperation.ServiceName  = pcServiceName 
                   .
            if lbOperation.URI eq '':u then
                assign lbOperation.URI = ROOT_SERVICE_URI.                   
        end.
        
        assign lbOperation.MappedOperation = poMappedOperation.
        
        LogMessage(substitute('Operation map added for &1 &2 &3',
                                pcServiceName, lbOperation.URI, lbOperation.Method),
                   LogLevelEnum:TRACE).
    end method.
        
    /* Returns details about the operation  
       
       @param character The serviceName
       @param character The relative URI
       @param MethodEnum The HTTP method
       @return MappedOperation The operation map for this Method/URI */
    method static public MappedOperation GetOperation(input pcServiceName as character,
                                                      input pcServiceURI as character,
                                                      input poMethod as MethodEnum ):
        define variable oOperation as MappedOperation no-undo.
        
        define buffer lbOperation for Operation.
        
        Assert:NotNullOrEmpty(pcServiceName, 'Service name').
        Assert:NotNullOrEmpty(pcServiceURI, 'Service URI').
        Assert:NotNull(poMethod, 'Service method').
        
        FindOperationRecord(pcServiceName, pcServiceURI, poMethod, buffer lbOperation).
        if available lbOperation then
            assign oOperation = cast(lbOperation.MappedOperation, MappedOperation).
        
        return oOperation.
    end method.
              
    /* Removes an operation mapping from the collection operation maps.
       No-op if none exists.  
       
       @param character the service name 
       @param character The relative URI    
       @param MethodEnum The HTTP method    */
    method static public void RemoveOperation(input pcServiceName as character,
                                              input pcServiceURI as character,
                                              input poMethod as MethodEnum):
        define buffer lbOperation for Operation.
        
        Assert:NotNullOrEmpty(pcServiceName, 'Service relative URL').
        Assert:NotNullOrEmpty(pcServiceURI, 'Service relative URL').
        Assert:NotNull(poMethod, 'Http Method').

        FindOperationRecord(pcServiceName, pcServiceURI, poMethod, buffer lbOperation).            
        if available lbOperation then
        do:        
            delete lbOperation.
            LogMessage(substitute('Operation map removed for &1 &2 &3',
                            lbOperation.ServiceName, lbOperation.URI, lbOperation.Method),
                      LogLevelEnum:TRACE).
        end.
    end method.

    /* Removes an operation schema from service
       No-op if none exists.  
        
       @param character the service name    
       @param character The schema name   */
    method static public void RemoveSchema(input pcServiceName as character,
                                            input pcSchemaName as character):
        define buffer lbSchema for DataSchema.
        
        Assert:NotNullOrEmpty(pcServiceName, 'Service name').
        Assert:NotNullOrEmpty(pcSchemaName, 'Schema name').
        
        find lbSchema where
             lbSchema.ServiceName eq pcServiceName and
             lbSchema.SchemaName eq pcSchemaName
             no-error.
        if available lbSchema then
        do:
            delete object lbSchema.DataStructure no-error.
            delete lbSchema.
            LogMessage(substitute('Service schema removed  for &1 &2 ',
                            lbSchema.ServiceName, lbSchema.SchemaName),
                      LogLevelEnum:TRACE).
        end.
        
    end method.
    
    /* Saves a schema for a given service
       
       @param character The service name
       @param character The schema name
       @param handle    An empty data structure (TT or PDS) */
    method static public void PutSchema(input pcServiceName as character,
                                        input pcSchemaName as character,
                                        input phSchema as handle):
        define buffer lbSchema for DataSchema.
        
        Assert:NotNullOrEmpty(pcSchemaName, 'Service name').
        Assert:NotNullOrEmpty(pcSchemaName, 'Schema name').
        Assert:NotNull(phSchema, 'Schema ').
        
        case phSchema:type:
            when DataTypeHelper:GetMask(DataTypeEnum:TempTable) or
            when DataTypeHelper:GetMask(DataTypeEnum:Buffer) or
            when DataTypeHelper:GetMask(DataTypeEnum:Dataset) then
                /* NO-OP */
                .
            otherwise
                return error new AppError(substitute('Unsupported schema type: &1', phSchema:type),
                                          0).
        end case.
        
        FindSchemaRecord(pcServiceName, pcSchemaName, buffer lbSchema).
        if not available lbSchema then
        do:
            create lbSchema.
            assign lbSchema.ServiceName = pcServiceName
                   lbSchema.SchemaName  = pcSchemaName.
        end.
        else
            delete object lbSchema.DataStructure no-error.
        
        assign lbSchema.DataStructure = phSchema.
        
        LogMessage(substitute('Schema &2 added for service "&1"',
                                pcServiceName, pcSchemaName),
                   LogLevelEnum:TRACE).
    end method.
    
    /* Returns a schema for a given service oepration.
       
       @param character The service name
       @param character The schema name
       @return handle   An empty data structure (TT or PDS) */
    method static public handle GetSchema(input pcServiceName as character,
                                          input pcSchemaName as character):
        define buffer lbSchema for DataSchema.
        
        Assert:NotNullOrEmpty(pcServiceName, 'Service name').
        Assert:NotNullOrEmpty(pcSchemaName, 'Schema name').
        
        FindSchemaRecord(pcServiceName, pcSchemaName, buffer lbSchema).
        if available lbSchema then
            return lbSchema.DataStructure.
    end method.
    
    /* Register a service in this handler.
    
       @param character  (mandatory) The service name.
       @param JsonObject (recommended) An operation map for the service.
       @param JsonObject (optional) A catalog for the service. Optional since it may exist on disk */
    method static public void RegisterService(input pcServiceName  as character,
                                              input pcVersion as character,
                                              input poOperations as JsonObject,
                                              input poCatalog as JsonObject,
                                              input poSchemas as JsonObject ):
        define buffer lbService for Service.
        
        Assert:NotNullOrEmpty(pcServiceName, 'Service name').
        Assert:NotNull(pcVersion, 'Service version').
        
        assign pcServiceName = trim(pcServiceName, '/':u).
        if pcServiceName eq '':u then
            assign pcServiceName = ROOT_SERVICE_NAME.     
        
        FindServiceRecord(pcServiceName, buffer lbService).
        if not available lbService then
        do:
            create lbService.
            assign lbService.ServiceName = pcServiceName
                   lbService.Version     = pcVersion.
        end.
        
        /* can be unknown */
        assign lbService.Catalog = poCatalog.
        
        if valid-object(poOperations) then
            LoadOperations(pcServiceName, poOperations).
        
        if valid-object(poSchemas) then
            LoadSchemas(pcServiceName, poSchemas).
        
        OnServiceRegistered(new ServiceRegistryEventArgs(pcServiceName)).
        
        LogMessage(substitute('Service &1 registered', quoter(pcServiceName)),
                   LogLevelEnum:INFO).
                   
        catch oError as Progress.Lang.Error :
            LogMessage(substitute('Unable to register service "&1": &2',
                            pcServiceName, oError:GetMessage(1)),
                       LogLevelEnum:ERROR).

            LogMessage(substitute('SERVICE REGISTRATION ERROR: &1', oError:GetClass():TypeName),
                       LogLevelEnum:ERROR).
            LogMessage(substitute('SERVICE REGISTRATION ERROR: &1', oError:CallStack), 
                       LogLevelEnum:ERROR).
        end catch.                   
    end method.

    /* Converts a JSON map into internal structures 
       
       @param character The service name
       @param JsonObject The set of schema */
    method static private void LoadSchemas(input pcServiceName as character,
                                           input poSchemas as JsonObject):
        define variable iSchemaLoop as integer no-undo.
        define variable iSchemaMax as integer no-undo.
        define variable cSchemaName as character extent no-undo.                                               
        define variable iInnerLoop as integer no-undo.
        define variable iInnerMax as integer no-undo.
        define variable cTTName as character extent no-undo.
        define variable hSchema as handle no-undo.
        define variable hTempTable as handle no-undo.
        define variable oSchema as JsonObject no-undo.
        define variable oTable as JsonObject no-undo.
        define variable cDelim as character no-undo.
        
        Assert:NotNull(poSchemas, 'Schemas').
        
        assign cSchemaName = poSchemas:GetNames()
               iSchemaMax = extent(cSchemaName).
        do iSchemaLoop = 1 to iSchemaMax:
            assign oSchema = poSchemas:GetJsonObject(cSchemaName[iSchemaLoop]).
            if oSchema:Has('fields':u) then
                assign hSchema = CreateTempTable(cSchemaName[iSchemaLoop], oSchema).
            else
            do:
                create dataset hSchema.
                assign hSchema:name         =  cSchemaName[iSchemaLoop]
                       hSchema:private-data = '':u
                       
                       extent(cTTName) = ?
                       cTTName         = oSchema:GetNames()
                       iInnerMax       = extent(cTTName) 
                       cDelim          = '':u.
                do iInnerLoop = 1 to iInnerMax:
                    assign oTable     = oSchema:GetJsonObject(cTTName[iInnerLoop])
                           hTempTable = CreateTempTable(cTTName[iInnerLoop], oTable).
                           
                    /* register the temp-tables individually too, since the business logic
                       may use the temp-tables independently of the dataset */
                    PutSchema(pcServiceName, cTTName[iInnerLoop], hTempTable).
                    
                    hSchema:add-buffer(hTempTable:default-buffer-handle).
                    
                    /* can only set if part of a PDS */
                    if hTempTable:private-data eq 'trackChanges':u then
                        assign hTempTable:tracking-changes = true
                               hSchema:private-data = hSchema:private-data
                                                    + cDelim
                                                    + string(iInnerLoop)
                               cDelim = ',':u.
                end.
                if hSchema:private-data ne '':u then  
                    assign hSchema:private-data = 'trackChanges=':u + hSchema:private-data.
            end.    //datasets
            PutSchema(pcServiceName, cSchemaName[iSchemaLoop], hSchema).
        end.
    end method.
    
    method static private handle CreateTempTable(input pcName as character,
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
        define variable cIdxName as character extent no-undo.
        define variable cValue as character no-undo.
        define variable cMode as character no-undo.
        
        create temp-table hTable.

        assign oFieldList = poTable:GetJsonArray('fields':u)
               iNumFields = oFieldList:Length.
        do iFieldLoop = 1 to iNumFields:
            assign oField  = oFieldList:GetJsonObject(iFieldLoop)
                   iExtent = ?.
            if oField:Has('extent':u) then
                assign iExtent = oField:GetInteger('extent':u).
            hTable:add-new-field(oField:GetCharacter('name':u),
                                 oField:GetCharacter('ablType':u),
                                 iExtent).
        end.
        
        assign oIndexList  = poTable:GetJsonObject('indexes':u)
               cIdxName    = oIndexList:GetNames()
               iNumIndexes = extent(cIdxName).
        do iIndexLoop = 1 to iNumIndexes:
            assign oIndex = oIndexList:GetJsonObject(cIdxName[iIndexLoop]).
            hTable:add-new-index(cIdxName[iIndexLoop],
                                 oIndex:GetLogical('unique':u),   
                                 oIndex:GetLogical('primary':u),
                                 oIndex:GetLogical('word':u)).
            assign oFieldList = oIndex:GetJsonArray('fields':u)
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
        
        hTable:temp-table-prepare(pcName).
        
        // indicate that the TT was defined with BEFORE-TABLE
        if poTable:Has('trackChanges':u) and
           poTable:GetLogical('trackChanges':u) then
            assign hTable:private-data = 'trackChanges':u.
        
        return hTable.
    end method.
    
    /* Converts a JSON map into internal structures 
       @param character The service name
       @param JsonObject The operation map */
    method static private void LoadOperations(input pcServiceName as character,
                                              input poOperations as JsonObject):
        define variable oUri as JsonObject no-undo.
        define variable oVerb as JsonObject no-undo.
        define variable oSvc as JsonObject no-undo.
        define variable oElem as JsonObject no-undo.
        define variable oElemArr as JsonArray no-undo.
        define variable oOperationArg as JsonObject no-undo.
        define variable oArgs as JsonArray no-undo.
        define variable cPropertyName as character extent no-undo.
        define variable cMethod as character extent no-undo.
        define variable oMethod as MethodEnum no-undo.
        define variable iSvcLoop as integer no-undo.
        define variable iSvcMax as integer no-undo.
        define variable iUriLoop as integer no-undo.
        define variable iUriMax as integer no-undo.
        define variable iVerbLoop as integer no-undo.
        define variable iVerbMax as integer no-undo.
        define variable iArgLoop as integer no-undo.
        define variable iArgMax as integer no-undo.
        define variable iElemLoop as integer no-undo.
        define variable iElemMax as integer no-undo.
        define variable iInputCnt as integer no-undo.
        define variable iOutputCnt as integer no-undo.
        define variable cIoElement as character extent no-undo.
        define variable oParams as IList no-undo.
        define variable oMappedOperation as MappedOperation no-undo.
        define variable oParam as OperationParameter no-undo.
        
        Assert:NotNull(poOperations, 'Operations').
        
        assign cPropertyName = poOperations:GetNames()
               iUriMax = extent(cPropertyName).
        
        URI-LOOP:
        do iUriLoop = 1 to iUriMax:
            assign extent(cMethod) = ? 
                   oUri     = poOperations:GetJsonObject(cPropertyName[iUriLoop])
                   cMethod  = oUri:GetNames()
                   iVerbMax = extent(cMethod)
                   cPropertyName[iUriLoop] = trim(cPropertyName[iUriLoop], '/':u)
                   .
            if cPropertyName[iUriLoop] eq '':u then
                assign cPropertyName[iUriLoop] = ROOT_SERVICE_URI.
                
            VERB-LOOP:
            do iVerbLoop = 1 to iVerbMax:
                assign oMethod = MethodEnum:GetEnum(cMethod[iVerbLoop])
                       oVerb = oUri:GetJsonObject(cMethod[iVerbLoop])
                       oParams                 = new List()
                       .
                case true:
                    when oVerb:Has('entity':u) then
                    do:
                        assign oSvc    = oVerb:GetJsonObject('entity':u)
                               oArgs   = oSvc:GetJsonArray('arg':u)
                               iArgMax = oArgs:Length

                               oMappedOperation = new MappedOperation(pcServiceName,
                                                                      cPropertyName[iUriLoop],
                                                                      oMethod,
                                                                      oVerb:GetCharacter('contentType':u),
                                                                      TargetTypeEnum:GetEnum(if oSvc:Has('type':u) then oSvc:GetCharacter('type':u) else 'CLS':u),
                                                                      oSvc:GetCharacter('name':u),
                                                                      oSvc:GetCharacter('function':u),
                                                                      (if oVerb:Has('options':u) then oVerb:GetJsonObject('options':u) else ?),
                                                                      (if oVerb:Has('statusCode':u) then oVerb:GetInteger('statusCode':u) else integer(StatusCodeEnum:OK)),
                                                                      oParams).
                        ARGS-LOOP:
                        do iArgLoop = 1 to iArgMax:
                            assign oOperationArg     = oArgs:GetJsonObject(iArgLoop)
                                   extent(cIoElement) = ?
                                   iInputCnt  = 0
                                   iOutputCnt = 0
                                   
                                   oParam = new OperationParameter(
                                                    IOModeEnum:GetEnum(oOperationArg:GetCharacter('ioMode':u)),
                                                    oOperationArg:GetCharacter('ablType':u),
                                                    (if oOperationArg:Has('ablName':u) then oOperationArg:GetCharacter('ablName':u) else '':u) 
                                                ).
                            if oParam:IOMode eq IOModeEnum:Return then
                                oMappedOperation:ReturnValue = oParam. 
                            else
                                oParams:Add(oParam).
                            
                            case oOperationArg:GetType('msgElem':u):
                                when JsonDataType:ARRAY then
                                do:
                                    assign oElemArr = oOperationArg:GetJsonArray('msgElem':u)
                                           iElemMax = oElemArr:Length
                                           extent(cIoElement) = iElemMax
                                           .
                                    /* we end up with 2 loops because ABL arrays are not dynamically resizable */
                                    ELEM-CNT-LOOP:
                                    do iElemLoop = 1 to iElemMax:
                                        assign oElem = oElemArr:GetJsonObject(iElemLoop).
                                        
                                        if oElem:Has('ioMode':u) then
                                            assign cIoElement[iElemLoop] = oElem:GetCharacter('ioMode':u).
                                        else
                                            assign cIoElement[iElemLoop] = oParam:IOMode:ToString().
                                        
                                        if cIoElement[iElemLoop] eq IOModeEnum:Input:ToString() or 
                                           cIoElement[iElemLoop] eq IOModeEnum:Input-Output:ToString() then
                                            assign iInputCnt = iInputCnt + 1. 
                                        
                                        if cIoElement[iElemLoop] eq IOModeEnum:Output:ToString() or
                                           cIoElement[iElemLoop] eq IOModeEnum:Return:ToString() or
                                           cIoElement[iElemLoop] eq IOModeEnum:Input-Output:ToString() then
                                            assign iOutputCnt = iOutputCnt + 1.
                                    end.    /* ELEM-CNT-LOOP */
                                    
                                    if iInputCnt gt 0 then
                                        assign extent(oParam:InputElementType) = iInputCnt
                                               extent(oParam:InputElementName) = iInputCnt
                                               .
                                    if iOutputCnt gt 0 then
                                        assign extent(oParam:OutputElementType) = iOutputCnt
                                               extent(oParam:OutputElementName) = iOutputCnt
                                               .
                                    ELEM-ADD-LOOP:
                                    do iElemLoop = 1 to iElemMax:
                                        assign oElem = oElemArr:GetJsonObject(iElemLoop).
                                        if cIoElement[iElemLoop] eq IOModeEnum:Input:ToString() or 
                                           cIoElement[iElemLoop] eq IOModeEnum:Input-Output:ToString() then
                                            assign oParam:InputElementType[iElemLoop] = ElementTypeEnum:GetEnum(oElem:GetCharacter('type':u))
                                                   oParam:InputElementName[iElemLoop] = oElem:GetCharacter('name':u)
                                                   . 
                                        if cIoElement[iElemLoop] eq IOModeEnum:Output:ToString() or
                                           cIoElement[iElemLoop] eq IOModeEnum:Return:ToString() or
                                           cIoElement[iElemLoop] eq IOModeEnum:Input-Output:ToString() then
                                            assign oParam:OutputElementType[iElemLoop] = ElementTypeEnum:GetEnum(oElem:GetCharacter('type':u))
                                                   oParam:OutputElementName[iElemLoop] = oElem:GetCharacter('name':u)
                                                   .
                                    end.    /* ELEM-ADD-LOOP */
                                end.    /* array */
                                when JsonDataType:OBJECT then
                                do:
                                    assign oElem = oOperationArg:GetJsonObject('msgElem':u).
                                    
                                    /* for single msgElem's we ignore the 'ioMode' */
                                    if oParam:IOMode eq IOModeEnum:Input or 
                                       oParam:IOMode eq IOModeEnum:Input-Output then
                                        assign extent(oParam:InputElementType) = 1
                                               extent(oParam:InputElementName) = 1
                                               
                                               oParam:InputElementType[1] = ElementTypeEnum:GetEnum(oElem:GetCharacter('type':u))
                                               oParam:InputElementName[1] = oElem:GetCharacter('name':u). 

                                    if oParam:IOMode eq IOModeEnum:Output or
                                       oParam:IOMode eq IOModeEnum:Return or
                                       oParam:IOMode eq IOModeEnum:Input-Output then
                                        assign extent(oParam:OutputElementType) = 1
                                               extent(oParam:OutputElementName) = 1
                                               
                                               oParam:OutputElementType[1] = ElementTypeEnum:GetEnum(oElem:GetCharacter('type':u))
                                               oParam:OutputElementName[1] = oElem:GetCharacter('name':u).
                                end.    /* OBJECT */
                                otherwise
                                do:
                                    LogMessage(substitute('Unnsupported msgElem type &1', oOperationArg:GetType('msgElem':u)),
                                               LogLevelEnum:ERROR).
                                    next ARGS-LOOP.
                                end.
                            end case.
                        end.    /* ARGS-LOOP: */
                    end.    /* entity */
                    when oVerb:Has('file':u) then
                        assign oMappedOperation = new MappedOperation(pcServiceName,
                                                                      cPropertyName[iUriLoop],
                                                                      oMethod,
                                                                      oVerb:GetCharacter('contentType':u),
                                                                      TargetTypeEnum:File,
                                                                      oVerb:GetCharacter('file':u),
                                                                      '':u,     /* function */
                                                                      (if oVerb:Has('options':u) then oVerb:GetJsonObject('options':u) else ?),
                                                                      (if oVerb:Has('statusCode':u) then oVerb:GetInteger('statusCode':u) else integer(StatusCodeEnum:OK)),
                                                                      oParams).
                    when oVerb:Has('void':u) then
                        assign oMappedOperation = new MappedOperation(pcServiceName,
                                                                      cPropertyName[iUriLoop],
                                                                      oMethod,
                                                                      '':u,
                                                                      TargetTypeEnum:Void,
                                                                      '',       /* target name */
                                                                      '':u,     /* function */
                                                                      (if oVerb:Has('options':u) then oVerb:GetJsonObject('options':u) else ?),
                                                                      (if oVerb:Has('statusCode':u) then oVerb:GetInteger('statusCode':u) else integer(StatusCodeEnum:InternalServerError)),
                                                                      oParams).
                end case.
                
                PutOperation(pcServiceName, oMappedOperation).
            end.    /* VERB-LOOP: */
        end.    /* URI-LOOP: */
    end method.
    
    /* Removes a service registration.
       
       @param character The name of the service to remove from the registry */
    method static public void DeregisterService(input pcServiceName as character):
        define buffer lbService for Service.
        define buffer lbOperation for Operation.
        define buffer lbSchema for DataSchema.
        
        Assert:NotNullOrEmpty(pcServiceName, 'Data Object Service name').
        
        FindServiceRecord(pcServiceName, buffer lbService).
        if available lbService then
        do:
            for each lbOperation where
                     lbOperation.ServiceName eq lbService.ServiceName:
                
                LogMessage(substitute('Operation map removed for &1 &2 &3',
                                lbOperation.ServiceName, lbOperation.URI, lbOperation.Method),
                          LogLevelEnum:TRACE).
                
                delete lbOperation.
            end.
            
            for each lbSchema where
                     lbSchema.ServiceName eq lbService.ServiceName:
                LogMessage(substitute('Data schema removed for &1 &2',
                                lbSchema.ServiceName, lbSchema.SchemaName),
                          LogLevelEnum:TRACE).
                
                delete object lbSchema.DataStructure no-error.
                delete lbSchema.                          
            end.
            
            delete lbService.

            OnServiceDeregistered(new ServiceRegistryEventArgs(pcServiceName)).
            LogMessage(substitute('Service &1 deregistered', quoter(pcServiceName)),
                       LogLevelEnum:INFO).
        end.
    end method.
    
    /* Register a service in this handler. Attempts to use a default operation map.
       
       @param character  (mandatory) The service name. */
    method static public void RegisterService(input pcServiceName as character):
        define variable lRegistered as logical no-undo.
        
        Assert:NotNullOrEmpty(pcServiceName, 'Data Object Service name').
        
        /* PDSOE-generated map */
        assign file-info:file-name = substitute('&1.gen':u, pcServiceName).
        LogMessage(substitute('Searching for map: &1', file-info:file-name),
                   LogLevelEnum:DEBUG).
        if file-info:full-pathname ne ? then
            assign lRegistered = LoadFromFile(pcServiceName, file-info:handle).
        
        /* custom map */
        assign file-info:file-name = substitute('&1.map':u, pcServiceName).
        LogMessage(substitute('Searching for map: &1', file-info:file-name), 
                   LogLevelEnum:DEBUG).
        if file-info:full-pathname ne ? then
            assign lRegistered = LoadFromFile(pcServiceName, file-info:handle).
            
        /* If we're looking for ROOT and cannot find a .map or .gen file,
           then register it anyway, since there are default operations mapped. */ 
        if not lRegistered and pcServiceName eq ROOT_SERVICE_NAME then
        do:
            RegisterService(pcServiceName, '1.0.0', ?, ?, ?).
            assign lRegistered = true.
        end.
        
        /* Add default catalog operations, if none exists */
        if lRegistered then
            AddDefaultOperations(pcServiceName).
    end method.

    /* loads all service from the file */
    method static private void LoadFromFile(input phFile as handle):
        define variable oMap as JsonObject no-undo.
        define variable oServiceList as JsonObject no-undo.
        define variable oService as JsonObject no-undo.
        define variable oOperations as JsonObject no-undo.
        define variable oSchemas as JsonObject no-undo.
        define variable oCatalog as JsonObject no-undo.
        define variable cVersion as character no-undo.
        define variable cServiceName as character extent no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.

        Assert:NotNull(phFile, 'File handle').
        
        LogMessage(substitute('Loading map: &1', phFile:full-pathname),
                   LogLevelEnum:DEBUG).
        
        assign oMap = cast(mJsonParser:ParseFile(file-info:full-pathname), JsonObject).
        
        if not oMap:Has('services':u) or
           not oMap:GetType('services':u) eq JsonDataType:OBJECT then
        do:
            LogMessage(substitute('Unable to find any services in file &1',
                            phFile:full-pathname),
                       LogLevelEnum:DEBUG).
            return.
        end.
        
        assign oServiceList = oMap:GetJsonObject('services':u)
               cServiceName = oServiceList:GetNames()
               iMax = extent(cServiceName).
        do iLoop = 1 to iMax:
            assign oService = oServiceList:GetJsonObject(cServiceName[iLoop]).
            /* service info */
            if oService:Has('version':u) then
                assign cVersion = oService:GetCharacter('version':u).
            else
                assign cVersion = '1.0.0':u.
            
            if oService:Has('operations':u) then
                assign oOperations = oService:GetJsonObject('operations':u).
            if oService:Has('schemas':u) then
                assign oSchemas = oService:GetJsonObject('schemas':u).
            if oService:Has('catalog':u) then
                assign oCatalog = oService:GetJsonObject('catalog':u).
            
            RegisterService(cServiceName[iLoop],
                            cVersion, 
                            oOperations,
                            oCatalog,
                            oSchemas        ).
            
            if oService:Has('options':u) then
                PutServiceOptions(cServiceName[iLoop], oService:GetJsonObject('options':u)).
        end.
    end method.
    
    method static private logical LoadFromFile(input pcServiceName as character,
                                               input phFile as handle):
        define variable oMap as JsonObject no-undo.
        define variable oService as JsonObject no-undo.
        define variable oOperations as JsonObject no-undo.
        define variable oSchemas as JsonObject no-undo.
        define variable oCatalog as JsonObject no-undo.
        define variable cVersion as character no-undo.
        
        Assert:NotNullOrEmpty(pcServiceName, 'Service name').
        Assert:NotNull(phFile, 'File handle').
        
        LogMessage(substitute('Loading map: &1', phFile:full-pathname),
                   LogLevelEnum:DEBUG).
        
        assign oMap = cast(mJsonParser:ParseFile(file-info:full-pathname), JsonObject).
        
        if not oMap:Has('services':u) or
           not oMap:GetType('services':u) eq JsonDataType:OBJECT then
        do:
            LogMessage(substitute('No services found in file &1', phFile:full-pathname),
                       LogLevelEnum:DEBUG).
            return false.
        end.
        
        case true:
            when oMap:GetJsonObject('services':u):Has(pcServiceName) then
                assign oService = oMap:GetJsonObject('services':u):GetJsonObject(pcServiceName).
            when oMap:GetJsonObject('services':u):Has('/':u + pcServiceName) then
                assign oService = oMap:GetJsonObject('services':u):GetJsonObject('/':u + pcServiceName).
            otherwise
            do:
                LogMessage(substitute('Unable to find service &1 in file &2',
                                pcServiceName, phFile:full-pathname),
                           LogLevelEnum:DEBUG).
                return false.
            end.
        end case.
        
        /* service info */
        if oService:Has('version':u) then
            assign cVersion = oService:GetCharacter('version':u).
        else
            assign cVersion = '1.0.0':u. 
        
        if oService:Has('operations':u) then
            assign oOperations = oService:GetJsonObject('operations':u).
        if oService:Has('schemas':u) then
            assign oSchemas = oService:GetJsonObject('schemas':u).
        if oService:Has('catalog':u) then
            assign oCatalog = oService:GetJsonObject('catalog':u).
        
        RegisterService(pcServiceName,
                        cVersion, 
                        oOperations,
                        oCatalog,
                        oSchemas).
        
        if oService:Has('options':u) then
            PutServiceOptions(pcServiceName, oService:GetJsonObject('options':u)).
        
        return true.
    end method. 
        
    /* Add default operations for a service (if not yet 
        
       @param character The service for which to add default operations */
    method static private void AddDefaultOperations(input pcServiceName as character):
        define variable oOperation as MappedOperation no-undo.
        define variable cCatalogFile as character no-undo.
        
        if pcServiceName eq '':u then
            assign pcServiceName = ROOT_SERVICE_NAME.
        
        if not HasOperation(pcServiceName, ROOT_SERVICE_URI, MethodEnum:GET) then
        do:
            if pcServiceName eq ROOT_SERVICE_NAME then
                assign oOperation = new MappedOperation(pcServiceName,
                                                    ROOT_SERVICE_URI,
                                                    MethodEnum:GET,
                                                    'application/json':u,
                                                    TargetTypeEnum:Self,
                                                    get-class(DataObjectHandler):TypeName,
                                                    'ListServices':u,   /* target function */
                                                    ?,     /* options */
                                                    integer(StatusCodeEnum:OK),                /* status code */
                                                    new List()).
            else
                assign cCatalogFile = substitute('$CATALINA_BASE/webapps/$oepas-webapp/static/&1.json':u,
                                                    pcServiceName)
                       oOperation   = new MappedOperation(pcServiceName,
                                                          ROOT_SERVICE_URI,
                                                          MethodEnum:GET,
                                                          'application/json':u,
                                                          TargetTypeEnum:File,
                                                          cCatalogFile,
                                                          '',         /* target function */
                                                          ?,     /* options */
                                                          integer(StatusCodeEnum:OK),        /* status code */
                                                          new List()).
            
            LogMessage(substitute('Adding default operation &2 for service "&1"', 
                                pcServiceName, oOperation:ToString()),
                           LogLevelEnum:INFO).
            PutOperation(pcServiceName, oOperation).
        end.    /* GET */

        if not HasOperation(pcServiceName, ROOT_SERVICE_URI, MethodEnum:DELETE) then
        do:
            if pcServiceName eq ROOT_SERVICE_NAME then
                assign oOperation = new MappedOperation(pcServiceName,
                                                    ROOT_SERVICE_URI,
                                                    MethodEnum:DELETE,
                                                    'application/json':u,
                                                    TargetTypeEnum:Self,
                                                    get-class(DataObjectHandler):TypeName,
                                                    'DeregisterAllServices':u,   /* target function */
                                                    ?,     /* options */
                                                    integer(StatusCodeEnum:OK),                /* status code */
                                                    new List()).
            else
                assign oOperation = new MappedOperation(pcServiceName,
                                                    ROOT_SERVICE_URI,
                                                    MethodEnum:DELETE,
                                                    'application/json':u,
                                                    TargetTypeEnum:Self,
                                                    get-class(DataObjectHandler):TypeName,
                                                    'DeregisterService':u,   /* target function */
                                                    ?,     /* options */
                                                    integer(StatusCodeEnum:OK),                /* status code */
                                                    new List()).
            LogMessage(substitute('Adding default operation &2 for service "&1"', 
                                pcServiceName, oOperation:ToString()),
                           LogLevelEnum:INFO).
            PutOperation(pcServiceName, oOperation).
        end.
    end method.        
    
    /** Logs a message 
        
        @param character The message to log
        @param integer  The level this message should be logged at */
    method static private void LogMessage(input pcMessage as character,
                                          input poLogLevel as LogLevelEnum):
        if log-manager:logfile-name eq ? then
            return.
        
        if log-manager:logging-level ge integer(poLogLevel) then
            log-manager:write-message(substitute('&1: &2', string(poLogLevel), pcMessage), 'DOH-SVCR':u).
    end method.
    
    /* Helper method to find and position the Service buffer to a given service. Caller must check 
       availablity themselves.
       
       @param character The service name
       @param buffer The Service record to find. */
    method static private void FindServiceRecord(input  pcServiceName as character,
                                                 buffer pbService for Service):
        find pbService where 
             pbService.ServiceName eq pcServiceName
             no-error.
        if not available pbService then
            find pbService where
                 pbService.ServiceName eq trim(pcServiceName, '/':u)
                 no-error.
    end method.
    
    /* Helper method to find and position the Operation buffer to a given service/method. Caller must check 
       availablity themselves.
       
       @param character The service name
       @param character The service URI
       @param MethodEnum the http method
       @param buffer The Operation record to find. */
    method static private void FindOperationRecord(input  pcServiceName as character,
                                                   input  pcServiceURI as character,
                                                   input  poMethod as MethodEnum,
                                                   buffer pbOperation for Operation):
        assign pcServiceName = trim(pcServiceName, '/':u)
               pcServiceURI  = trim(pcServiceURI, '/':u)
               .
        if pcServiceName eq '':u then
            assign pcServiceName = ROOT_SERVICE_NAME.
            
        if pcServiceURI eq '':u then        
            assign pcServiceURI = ROOT_SERVICE_URI.

        find pbOperation where 
             pbOperation.ServiceName eq pcServiceName and 
             pbOperation.URI         eq pcServiceURI and
             pbOperation.Method      eq string(poMethod) 
             no-error.
    end method.
    
    /* Helper method to find and position the Service buffer to a given service. Caller must check 
       availablity themselves.
       
       @param character The service name
       @param buffer The Service record to find. */
    method static private void FindSchemaRecord(input  pcServiceName as character,
                                                input  pcSchemaName as character,
                                                buffer pbSchema for DataSchema):
        find pbSchema where 
             pbSchema.ServiceName eq pcServiceName and
             pbSchema.SchemaName  eq pcSchemaName   
             no-error.
        if not available pbSchema then
            find pbSchema where 
                 pbSchema.ServiceName eq right-trim(pcServiceName, '/':u) and
                 pbSchema.SchemaName  eq pcSchemaName
                 no-error.
    end method.
    
    /* Publishes the ServiceRegistered event
       
       @param ServiceRegistryEventArgs The event args */
    method static  protected void OnServiceRegistered(input poEventArgs as ServiceRegistryEventArgs):
        Assert:NotNull(poEventArgs, 'Event args').
        ServiceRegistry:ServiceRegistered:Publish(get-class(ServiceRegistry), poEventArgs).
    end method.                                              

    /* Publishes the ServiceDeregistered event
       
       @param ServiceRegistryEventArgs The event args */
    method static protected void OnServiceDeregistered(input poEventArgs as ServiceRegistryEventArgs):
        Assert:NotNull(poEventArgs, 'Event args').
        ServiceRegistry:ServiceDeregistered:Publish(get-class(ServiceRegistry), poEventArgs).
    end method.

    /* Registers all services found in a given file. Can be used at agent startup
       
       @param character An extant file */
    method static public void RegisterFromFile(input pcFile as character):
        AssertFile:FileExists(pcFile).
        
        assign file-info:file-name = pcFile.
        
        LoadFromFile(file-info:handle).
     end method.

    /* Registers a named service found in a given file. Can be used at agent startup
       
       @param character A service name
       @param character An extant file */
    method static public void RegisterFromFile(input pcServiceName as character,
                                               input pcFile as character):
        Assert:NotNullOrEmpty(pcServiceName, 'Service name').
        AssertFile:FileExists(pcFile).
        
        assign file-info:file-name = pcFile.
        
        LoadFromFile(pcServiceName, file-info:handle).
     end method.

    /* Registers all services found in a given folder. Can be used at agent startup
       
       @param character An extant folder */
    method static public void RegisterAllFromFolder(input pcFolder as character):
        define variable cService as character no-undo.
        define variable cFlag as character no-undo.
        define variable lRegistered as logical no-undo.
        
        AssertFile:DirectoryExists(pcFolder).
        
        input from os-dir(pcFolder).
        repeat:
            import
                cService ^ cFlag.
            
            if cFlag eq 'F':u and
               num-entries(cService, '.':u) gt 1 then
            case entry(2, cService, '.':u):
                when 'gen':u or when 'map':u then
                    /* will register if it can */
                    TryFindService(entry(1, cService, '.':u)).
            end case.
        end.
        
        finally:
            input close.
        end finally.
    end method.
    
end class.