/* *************************************************************************************************************************
Copyright (c) 2016-2017 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : ServiceRegistryImpl
    Purpose     : Contains a registry for mapped services 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed May 18 13:06:41 EDT 2016
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.Assertion.AssertFile.
using OpenEdge.Core.Collections.IList.
using OpenEdge.Core.Collections.List.
using OpenEdge.Core.DateTimeAddIntervalEnum.
using OpenEdge.Core.IOModeEnum.
using OpenEdge.Core.SemanticVersion.
using OpenEdge.Core.StringConstant.
using OpenEdge.Core.WidgetHandle.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.ISupportLogging.
using OpenEdge.Logging.LoggerBuilder.
using OpenEdge.Net.HTTP.MethodEnum.
using OpenEdge.Net.HTTP.StatusCodeEnum.
using OpenEdge.Web.DataObject.ElementTypeEnum.
using OpenEdge.Web.DataObject.IServiceRegistry.
using OpenEdge.Web.DataObject.MappedOperation.
using OpenEdge.Web.DataObject.OperationOptions.
using OpenEdge.Web.DataObject.OperationParameter.
using OpenEdge.Web.DataObject.SchemaOption.
using OpenEdge.Web.DataObject.ServiceMappingFileSchemaEnum.
using OpenEdge.Web.DataObject.ServiceOptions.
using OpenEdge.Web.DataObject.ServiceRegistry.
using OpenEdge.Web.DataObject.ServiceRegistryImpl.
using OpenEdge.Web.DataObject.TargetTypeEnum.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonDataType.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.ObjectModelParser.
using OpenEdge.Web.DataObject.ServiceRegistryLoader.
using OpenEdge.Web.DataObject.Writer.OperationHandlerRegistry.
using Progress.Lang.AppError.

class OpenEdge.Web.DataObject.ServiceRegistryLoader implements ISupportLogging:
    
    // Holds the class that does the actual work/maintains the actual registry
    define public property Registry as IServiceRegistry no-undo
        get():
            if not valid-object(this-object:Registry) then
            do:
                // Use a CCS Service Manager if extant, and let it control this object's lifecycle
                if valid-object(Ccs.Common.Application:ServiceManager) then
                    assign this-object:Registry = cast(Ccs.Common.Application:ServiceManager
                                                                :getService(get-class(IServiceRegistry)),
                                                           IServiceRegistry).
                
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
        assign mJsonParser    = new ObjectModelParser()
               mcInstanceRoot = replace(os-getenv ('CATALINA_BASE':u), StringConstant:BACKSLASH, '/':u)
               // Note that it's NOT the ServiceRegistry type
               this-object:Logger = LoggerBuilder:GetLogger(get-class(ServiceRegistryLoader))
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
        
        return TryFindService(pcServiceName, '', pcWebAppPath).
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
        define variable cFilename as character no-undo.
        define variable lRegistered  as logical no-undo.
        define variable semVer as SemanticVersion no-undo.
        
        Assert:NotNull(pServiceName, 'Service name').
        Assert:NotNull(pVersion, 'Service version').
        Assert:NotNull(pWebAppPath, 'Web app path').
        
        if pServiceName eq '':u then
            assign pServiceName = ServiceRegistry:ROOT_SERVICE_NAME.
        if pWebAppPath eq '':u then
            assign pWebAppPath = 'ROOT':u.
        
        Logger:Trace(substitute('Searching for service "&1" version "&2" in path "&3"',
                            pServiceName, pVersion, pWebAppPath)).
        
        if this-object:Registry:HasService(pServiceName, pVersion) then
            return true.
        
        assign lRegistered = false
               semVer      = SemanticVersion:Parse(pVersion)
               .
        // 1. Look in the webapps' WEB-INF/openedge folder first
        // -----------------------------------------------------
        // GEN file first 
        assign file-info:file-name = substitute('&1/webapps/&2/WEB-INF/openedge/&3.gen':u,
                                mcInstanceRoot,
                                pWebAppPath,
                                pServiceName)
               cFilename = file-info:full-pathname.
        if cFilename ne ? then
            LoadFromFile(pServiceName, pVersion, file-info:handle).
        
        // MAP file next
        assign file-info:file-name = substitute('&1/webapps/&2/WEB-INF/openedge/&3.map':u,
                                mcInstanceRoot,
                                pWebAppPath,
                                pServiceName)
               cFilename = file-info:full-pathname.
        if cFilename ne ? then
            LoadFromFile(pServiceName, pVersion, file-info:handle).
        
        assign lRegistered = this-object:Registry:HasService(pServiceName, pVersion).
        
        // 2. Look in the instance's /openedge folder next
        // -----------------------------------------------
        if not lRegistered  then
        do:
            // GEN file first 
            assign file-info:file-name = substitute('&1/openedge/&2.gen':u,
                                    mcInstanceRoot,
                                    pServiceName)
                   cFilename = file-info:full-pathname.
            if cFilename ne ? then
                LoadFromFile(pServiceName, pVersion, file-info:handle).
                       
            // MAP file next
            assign file-info:file-name = substitute('&1/openedge/&2.map':u,
                                    mcInstanceRoot,
                                    pServiceName)
                   cFilename = file-info:full-pathname.
            if cFilename ne ? then
                LoadFromFile(pServiceName, pVersion, file-info:handle).
            
            assign lRegistered = this-object:Registry:HasService(pServiceName, pVersion).
        end.    // #2
        
        // 3. Look in the rest of PROPATH 
        // -----------------------------------------------
        if not lRegistered then
        do:
            // GEN file first 
            assign file-info:file-name = substitute('&1.gen':u, pServiceName)
                   cFilename = file-info:full-pathname.
            if cFilename ne ? then
                LoadFromFile(pServiceName, pVersion, file-info:handle).
            
            // MAP file next        
            assign file-info:file-name = substitute('&1.map':u, pServiceName)
                   cFilename = file-info:full-pathname.
            if cFilename ne ? then
                LoadFromFile(pServiceName, pVersion, file-info:handle).
            
            assign lRegistered = this-object:Registry:HasService(pServiceName, pVersion).
        end.    // #3
        
        return lRegistered.
    end method.
    
    /* Register a service in this handler.
    
       @param character  (mandatory) The service name.
       @param JsonObject (recommended) An operation map for the service.
       @param JsonObject (optional) A catalog for the service. Optional since it may exist on disk */
    method public void RegisterService(input pcServiceName  as character,
                                       input pcVersion as character,
                                       input poOperations as JsonObject,
                                       input poCatalog as JsonObject,
                                       input poSchemas as JsonObject ):
        define variable numSchemas as integer no-undo.
        define variable numOperations as integer no-undo.
        define variable registerTime as datetime-tz extent 2 no-undo.
        
        Assert:NotNullOrEmpty(pcServiceName, 'Service name').
        Assert:NotNull(pcVersion, 'Service version').
        
        assign registerTime[1] = now 
               pcServiceName   = trim(pcServiceName, '/':u)
               .
        if pcServiceName eq '':u then
            assign pcServiceName = ServiceRegistry:ROOT_SERVICE_NAME.
        
        // service registration
        this-object:Registry:RegisterService(pcServiceName, SemanticVersion:Parse(pcVersion), ?, poCatalog).
        
        // load schemas first since when we create the operation, we'd like to create any schema holders
        if valid-object(poSchemas) then
            assign numSchemas = LoadSchemas(pcServiceName, SemanticVersion:Parse(pcVersion), poSchemas).
        
        if valid-object(poOperations) then
            assign numOperations = LoadOperations(pcServiceName, SemanticVersion:Parse(pcVersion), poOperations).
        
        assign registerTime[2] = now.
        Logger:Info(substitute('Service &1 version &4 registered with &2 operations and &3 schemas',
                        quoter(pcServiceName),
                        numOperations,
                        numSchemas,
                        pcVersion )).
        Logger:Trace(substitute('Service "&1" registered in &2ms',
                        pcServiceName,
                        interval(registerTime[2], registerTime[1], string(DateTimeAddIntervalEnum:Milliseconds)))).
        
        catch oError as Progress.Lang.Error:
            Logger:Error(substitute('Error registering service "&1" &2 ', pcServiceName, pcVersion), oError).
            this-object:Registry:DeregisterService(pcServiceName, SemanticVersion:Parse(pcVersion)).
        end catch.
    end method.

    /* Converts a JSON map into internal structures 
       
       @param character The service name
       @param character The service version
       @param JsonObject The set of schema
       @return integer The number of schemas loaded */
    method private integer LoadSchemas(input pcServiceName as character,
                                       input pVersion as SemanticVersion,
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
        define variable attribs as JsonObject no-undo.
        
        Assert:NotNull(poSchemas, 'Schemas').
        
        assign cSchemaName = poSchemas:GetNames()
               iSchemaMax = extent(cSchemaName).
        do iSchemaLoop = 1 to iSchemaMax:
            if not poSchemas:GetType(cSchemaName[iSchemaLoop]) eq JsonDataType:OBJECT then
                next.
            
            assign oSchema = poSchemas:GetJsonObject(cSchemaName[iSchemaLoop]).
            if oSchema:Has(string(ServiceMappingFileSchemaEnum:fields)) then
                assign hSchema = CreateTempTable(cSchemaName[iSchemaLoop], oSchema ).
            else
            do:
                create dataset hSchema.
                assign hSchema:name    =  cSchemaName[iSchemaLoop]
                       extent(cTTName) = ?
                       cTTName         = oSchema:GetNames()
                       iInnerMax       = extent(cTTName) 
                       .
                do iInnerLoop = 1 to iInnerMax:
                    if cTTName[iInnerLoop] eq string(ServiceMappingFileSchemaEnum:attr) then
                    do:
                        if oSchema:GetType(string(ServiceMappingFileSchemaEnum:attr)) eq JsonDataType:OBJECT then
                            assign attribs = oSchema:GetJsonObject(string(ServiceMappingFileSchemaEnum:attr)).
                        
                        next.
                    end.
                    
                    assign oTable     = oSchema:GetJsonObject(cTTName[iInnerLoop])
                           hTempTable = CreateTempTable(cTTName[iInnerLoop], oTable)
                           .
                    /* register the temp-tables individually too, since the business logic
                       may use the temp-tables independently of the dataset */
                    this-object:Registry:PutSchema(pcServiceName, pVersion, cTTName[iInnerLoop], hTempTable).
                    
                    hSchema:add-buffer(hTempTable:default-buffer-handle).
                end.
                
                if valid-object(attribs) then
                do:
                    if     attribs:Has(string(ServiceMappingFileSchemaEnum:serializeHidden)) 
                       and attribs:GetType(string(ServiceMappingFileSchemaEnum:serializeHidden)) eq JsonDataType:BOOLEAN
                       then
                        assign hSchema:serialize-hidden = attribs:GetLogical(string(ServiceMappingFileSchemaEnum:serializeHidden)).
                    
                    if     attribs:Has(string(ServiceMappingFileSchemaEnum:serializeName)) 
                       and attribs:GetType(string(ServiceMappingFileSchemaEnum:serializeName)) eq JsonDataType:STRING
                       then
                        assign hSchema:serialize-name = attribs:GetCharacter(string(ServiceMappingFileSchemaEnum:serializeName)).                        
                end.
            end.    //datasets
            
            this-object:Registry:PutSchema(pcServiceName, pVersion, cSchemaName[iSchemaLoop], hSchema).
        end.
        
        return iSchemaMax.
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
        
        create temp-table hTable.
        
        assign oFieldList = poTable:GetJsonArray(string(ServiceMappingFileSchemaEnum:fields))
               iNumFields = oFieldList:Length
               lHasBeforeTable       = false
               extent(fieldWithAttr) = iNumFields
               attrIdx               = 0 
               .
        do iFieldLoop = 1 to iNumFields:
            assign oField  = oFieldList:GetJsonObject(iFieldLoop)
                   iExtent = ?.
            if oField:Has(string(ServiceMappingFileSchemaEnum:extent)) then
                assign iExtent = oField:GetInteger(string(ServiceMappingFileSchemaEnum:extent)).
            hTable:add-new-field(oField:GetCharacter(string(ServiceMappingFileSchemaEnum:name)),
                                 oField:GetCharacter(string(ServiceMappingFileSchemaEnum:ablType)),
                                 iExtent).
            // We can only flag fields later so not which (potentially) need updates  
            if    oField:Has(string(ServiceMappingFileSchemaEnum:serializeName))
               or oField:Has(string(ServiceMappingFileSchemaEnum:serializeHidden))
               then
                assign attrIdx                = attrIdx + 1
                       fieldWithAttr[attrIdx] = iFieldLoop
                       .
        end.
        
        if     poTable:Has(string(ServiceMappingFileSchemaEnum:indexes))
           and poTable:GetType(string(ServiceMappingFileSchemaEnum:indexes)) eq JsonDataType:OBJECT
           then
            assign oIndexList  = poTable:GetJsonObject(string(ServiceMappingFileSchemaEnum:indexes))
                   cIdxName    = oIndexList:GetNames()
                   iNumIndexes = extent(cIdxName).
        do iIndexLoop = 1 to iNumIndexes:
            assign oIndex = oIndexList:GetJsonObject(cIdxName[iIndexLoop]).
            hTable:add-new-index(cIdxName[iIndexLoop],
                                 oIndex:GetLogical(string(ServiceMappingFileSchemaEnum:unique)),   
                                 oIndex:GetLogical(string(ServiceMappingFileSchemaEnum:primary)),
                                 oIndex:GetLogical(string(ServiceMappingFileSchemaEnum:word))).
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
        
        // indicate that the TT was defined with BEFORE-TABLE
        if poTable:Has(string(ServiceMappingFileSchemaEnum:trackChanges)) then
            assign lHasBeforeTable = poTable:GetLogical(string(ServiceMappingFileSchemaEnum:trackChanges)).
        
        hTable:temp-table-prepare(pcName, lHasBeforeTable).
        
        if     poTable:Has(string(ServiceMappingFileSchemaEnum:serializeName)) 
           and poTable:GetType(string(ServiceMappingFileSchemaEnum:serializeName)) eq JsonDataType:STRING 
           then
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
            if     oField:Has(string(ServiceMappingFileSchemaEnum:serializeHidden)) 
               and oField:GetType(string(ServiceMappingFileSchemaEnum:serializeHidden)) eq JsonDataType:BOOLEAN
               then 
                assign hField:serialize-hidden = oField:GetLogical(string(ServiceMappingFileSchemaEnum:serializeHidden)).
                                        
            if     oField:Has(string(ServiceMappingFileSchemaEnum:serializeName)) 
               and oField:GetType(string(ServiceMappingFileSchemaEnum:serializeName)) eq JsonDataType:STRING
               then
                assign hField:serialize-name = oField:GetCharacter(string(ServiceMappingFileSchemaEnum:serializeName)).                        
        end.        
        
        return hTable.
    end method.
    
    /* Converts a JSON map into internal structures 
       
       @param character The service name
       @param character The service version
       @param JsonObject The operation map
       @return integer The number of operations loaded */
    method private integer LoadOperations(input pcServiceName as character,
                                          input pVersion as SemanticVersion,
                                          input poOperations as JsonObject):
        define variable numOperations as integer no-undo.
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
        define variable targetType as character no-undo.
        
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
                   
                   // add here instead of incrementing so that we have fewer LoC  
                   numOperations = numOperations + iVerbMax
                   .
            if cPropertyName[iUriLoop] eq '':u then
                assign cPropertyName[iUriLoop] = ServiceRegistry:ROOT_SERVICE_URI.
                            
            VERB-LOOP:
            do iVerbLoop = 1 to iVerbMax:
                assign oMethod = MethodEnum:GetEnum(cMethod[iVerbLoop])
                       oVerb = oUri:GetJsonObject(cMethod[iVerbLoop])
                       oParams                 = new List()
                       .
                case true:
                    when oVerb:Has(string(ServiceMappingFileSchemaEnum:entity)) then
                    do:
                        assign oSvc    = oVerb:GetJsonObject(string(ServiceMappingFileSchemaEnum:entity))
                               oArgs   = oSvc:GetJsonArray(string(ServiceMappingFileSchemaEnum:arg))
                               iArgMax = oArgs:Length
                               targetType = '':u
                               .
                        if oSvc:Has(string(ServiceMappingFileSchemaEnum:type)) then
                            assign targetType = oSvc:GetCharacter(string(ServiceMappingFileSchemaEnum:type)).
                        // backward-compat and un-set
                        case targetType:
                            when 'cls':u  or
                            when '':u     then
                                assign targetType = string(TargetTypeEnum:Class).
                            when 'proc':u then
                                assign targetType = string(TargetTypeEnum:Procedure).
                        end case.
                        
                        assign oMappedOperation = new MappedOperation(pcServiceName,
                                                                      pVersion,
                                                                      cPropertyName[iUriLoop],
                                                                      oMethod,
                                                                      oVerb:GetCharacter(string(ServiceMappingFileSchemaEnum:contentType)),
                                                                      targetType,
                                                                      oSvc:GetCharacter(string(ServiceMappingFileSchemaEnum:name)),
                                                                      (if oSvc:Has(string(ServiceMappingFileSchemaEnum:typeof)) then oSvc:GetCharacter(string(ServiceMappingFileSchemaEnum:typeof)) else '':u),
                                                                      oSvc:GetCharacter(string(ServiceMappingFileSchemaEnum:function)),
                                                                      (if oVerb:Has(string(ServiceMappingFileSchemaEnum:options)) then CreateOperationOptions(oVerb:GetJsonObject(string(ServiceMappingFileSchemaEnum:options))) else ?),                                                                      
                                                                      (if oVerb:Has(string(ServiceMappingFileSchemaEnum:statusCode)) then oVerb:GetInteger(string(ServiceMappingFileSchemaEnum:statusCode)) else integer(StatusCodeEnum:OK)),
                                                                      oParams).
                        
                        ARGS-LOOP:
                        do iArgLoop = 1 to iArgMax:
                            assign oOperationArg     = oArgs:GetJsonObject(iArgLoop)
                                   extent(cIoElement) = ?
                                   iInputCnt  = 0
                                   iOutputCnt = 0
                                   
                                   oParam = new OperationParameter(
                                                    IOModeEnum:GetEnum(oOperationArg:GetCharacter(string(ServiceMappingFileSchemaEnum:ioMode))),
                                                    oOperationArg:GetCharacter(string(ServiceMappingFileSchemaEnum:ablType)),
                                                    (if oOperationArg:Has(string(ServiceMappingFileSchemaEnum:ablName)) then oOperationArg:GetCharacter(string(ServiceMappingFileSchemaEnum:ablName)) else '':u) 
                                                ).
                                                    
                            // from the Param's ABLType we know that this is a dataset/temp-table, and we can create an empty schema
                            CreateParameterSchema(oMappedOperation, oParam).
                            
                            if oParam:IOMode eq IOModeEnum:Return then
                                oMappedOperation:ReturnValue = oParam. 
                            else
                                oParams:Add(oParam).
                            
                            case oOperationArg:GetType(string(ServiceMappingFileSchemaEnum:msgElem)):
                                when JsonDataType:ARRAY then
                                do:
                                    assign oElemArr = oOperationArg:GetJsonArray(string(ServiceMappingFileSchemaEnum:msgElem))
                                           iElemMax = oElemArr:Length
                                           extent(cIoElement) = iElemMax
                                           .
                                    /* we end up with 2 loops because ABL arrays are not dynamically resizable */
                                    ELEM-CNT-LOOP:
                                    do iElemLoop = 1 to iElemMax:
                                        assign oElem = oElemArr:GetJsonObject(iElemLoop).
                                        
                                        if oElem:Has(string(ServiceMappingFileSchemaEnum:ioMode)) then
                                            assign cIoElement[iElemLoop] = oElem:GetCharacter(string(ServiceMappingFileSchemaEnum:ioMode)).
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
                                            assign oParam:InputElementType[iElemLoop] = ElementTypeEnum:GetEnum(oElem:GetCharacter(string(ServiceMappingFileSchemaEnum:type)))
                                                   oParam:InputElementName[iElemLoop] = oElem:GetCharacter(string(ServiceMappingFileSchemaEnum:name))
                                                   . 
                                        if cIoElement[iElemLoop] eq IOModeEnum:Output:ToString() or
                                           cIoElement[iElemLoop] eq IOModeEnum:Return:ToString() or
                                           cIoElement[iElemLoop] eq IOModeEnum:Input-Output:ToString() then
                                            assign oParam:OutputElementType[iElemLoop] = ElementTypeEnum:GetEnum(oElem:GetCharacter(string(ServiceMappingFileSchemaEnum:type)))
                                                   oParam:OutputElementName[iElemLoop] = oElem:GetCharacter(string(ServiceMappingFileSchemaEnum:name))
                                                   .
                                    end.    /* ELEM-ADD-LOOP */
                                end.    /* array */
                                when JsonDataType:OBJECT then
                                do:
                                    assign oElem = oOperationArg:GetJsonObject(string(ServiceMappingFileSchemaEnum:msgElem)).
                                    
                                    /* for single msgElem's we ignore the 'ioMode' */
                                    if oParam:IOMode:IsFlagSet(IOModeEnum:Input) then
                                        assign extent(oParam:InputElementType) = 1
                                               extent(oParam:InputElementName) = 1
                                               
                                               oParam:InputElementType[1] = ElementTypeEnum:GetEnum(oElem:GetCharacter(string(ServiceMappingFileSchemaEnum:type)))
                                               oParam:InputElementName[1] = oElem:GetCharacter(string(ServiceMappingFileSchemaEnum:name)). 

                                    if    oParam:IOMode:IsFlagSet(IOModeEnum:Output)
                                       or oParam:IOMode:IsFlagSet(IOModeEnum:Return)
                                       then
                                        assign extent(oParam:OutputElementType) = 1
                                               extent(oParam:OutputElementName) = 1
                                               
                                               oParam:OutputElementType[1] = ElementTypeEnum:GetEnum(oElem:GetCharacter(string(ServiceMappingFileSchemaEnum:type)))
                                               oParam:OutputElementName[1] = oElem:GetCharacter(string(ServiceMappingFileSchemaEnum:name)).
                                end.    /* OBJECT */
                                otherwise
                                do:
                                    Logger:Error(substitute('Unnsupported msgElem type &1', oOperationArg:GetType(string(ServiceMappingFileSchemaEnum:msgElem)))).
                                    next ARGS-LOOP.
                                end.
                            end case.
                        end.    /* ARGS-LOOP: */
                    end.    /* entity */
                    when oVerb:Has(string(ServiceMappingFileSchemaEnum:file)) then
                        assign oMappedOperation = new MappedOperation(pcServiceName,
                                                                      pVersion,
                                                                      cPropertyName[iUriLoop],
                                                                      oMethod,
                                                                      oVerb:GetCharacter(string(ServiceMappingFileSchemaEnum:contentType)),
                                                                      string(TargetTypeEnum:File),
                                                                      oVerb:GetCharacter(string(ServiceMappingFileSchemaEnum:file)),
                                                                      '':u,     /* type-of */
                                                                      '':u,     /* function */
                                                                      (if oVerb:Has(string(ServiceMappingFileSchemaEnum:options)) then CreateOperationOptions(oVerb:GetJsonObject(string(ServiceMappingFileSchemaEnum:options))) else ?),
                                                                      (if oVerb:Has(string(ServiceMappingFileSchemaEnum:statusCode)) then oVerb:GetInteger(string(ServiceMappingFileSchemaEnum:statusCode)) else integer(StatusCodeEnum:OK)),
                                                                      oParams).
                    when oVerb:Has(string(ServiceMappingFileSchemaEnum:void)) then
                        assign oMappedOperation = new MappedOperation(pcServiceName,
                                                                      pVersion,
                                                                      cPropertyName[iUriLoop],
                                                                      oMethod,
                                                                      (if oVerb:Has(string(ServiceMappingFileSchemaEnum:contentType)) then oVerb:GetCharacter(string(ServiceMappingFileSchemaEnum:contentType)) else '':u),
                                                                      string(TargetTypeEnum:Void),
                                                                      '',       /* target name */
                                                                      '':u,     /* type-of */
                                                                      '':u,     /* function */
                                                                      (if oVerb:Has(string(ServiceMappingFileSchemaEnum:options)) then CreateOperationOptions(oVerb:GetJsonObject(string(ServiceMappingFileSchemaEnum:options))) else ?),
                                                                      (if oVerb:Has(string(ServiceMappingFileSchemaEnum:statusCode)) then oVerb:GetInteger(string(ServiceMappingFileSchemaEnum:statusCode)) else integer(StatusCodeEnum:NotFound)),
                                                                      oParams).
                end case.
                
                // If there's a 'name' property, add it to the options for the operation
                if     oVerb:Has(string(ServiceMappingFileSchemaEnum:name))
                   and oVerb:GetType(string(ServiceMappingFileSchemaEnum:name)) eq JsonDataType:STRING
                   then
                    assign oMappedOperation:Name = oVerb:GetCharacter(string(ServiceMappingFileSchemaEnum:name)).
                
                this-object:Registry:PutOperation(pcServiceName, pVersion, oMappedOperation).
            end.    /* VERB-LOOP: */
        end.    /* URI-LOOP: */
        
        return numOperations.    
    end method.
    
    /* Loads all services from the file
       
       @param handle The FILE-INFO handle for the file. */
    method  private void LoadFromFile(input phFile as handle):
        define variable oMap as JsonObject no-undo.
        define variable oServiceList as JsonObject no-undo.
        define variable cServiceName as character extent no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable verCnt as integer no-undo.
        define variable verMax as integer no-undo.
        define variable svcVersions as JsonArray no-undo.

        Assert:NotNull(phFile, 'File handle').
        
        Logger:Debug(substitute('Loading map: &1', phFile:full-pathname)).
        
        assign oMap = cast(mJsonParser:ParseFile(file-info:full-pathname), JsonObject).
        
        if not oMap:Has(string(ServiceMappingFileSchemaEnum:services)) or
           not oMap:GetType(string(ServiceMappingFileSchemaEnum:services)) eq JsonDataType:OBJECT then
        do:
            Logger:Debug(substitute('Unable to find any services in file &1', phFile:full-pathname)).
            return.
        end.
        
        assign oServiceList = oMap:GetJsonObject(string(ServiceMappingFileSchemaEnum:services))
               cServiceName = oServiceList:GetNames()
               iMax = extent(cServiceName).
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
                    Logger:Debug(substitute('Unable to find any load service &1 from &2 JSON data1',
                                    cServiceName[iLoop], oServiceList:GetType(cServiceName[iLoop]))).
                    next.
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
       @param handle The FILE-INFO handle for the file
       @return logical TRUE if the named service was found */
    method private logical LoadFromFile(input pcServiceName as character,
                                        input pVersion as character,
                                        input phFile as handle):
        define variable oMap as JsonObject no-undo.
        define variable oServiceList as JsonObject no-undo.
        define variable verCnt as integer no-undo.
        define variable verMax as integer no-undo.
        define variable svcVersions as JsonArray no-undo.
        
        Assert:NotNullOrEmpty(pcServiceName, 'Service name').
        Assert:NotNull(pVersion, 'Service version'). 
        Assert:NotNull(phFile, 'File handle').
        
        Logger:Debug(substitute('Loading map: &1', phFile:full-pathname)).
        
        assign oMap = cast(mJsonParser:ParseFile(file-info:full-pathname), JsonObject).
        
        if not oMap:Has(string(ServiceMappingFileSchemaEnum:services)) or
           not oMap:GetType(string(ServiceMappingFileSchemaEnum:services)) eq JsonDataType:OBJECT then
        do:
            Logger:Debug(substitute('No services found in file &1', phFile:full-pathname)).
            return false.
        end.
        
        assign oServiceList = oMap:GetJsonObject(string(ServiceMappingFileSchemaEnum:services)). 
        case true:
            when oServiceList:Has(pcServiceName) then
                . //no-op
            when oServiceList:Has('/':u + pcServiceName) then
                assign pcServiceName = '/':u + pcServiceName. 
            otherwise
            do:
                Logger:Debug(substitute('Unable to find service &1 in file &2', pcServiceName, phFile:full-pathname)).
                return false.
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
                Logger:Debug(substitute('Unable to find any load service &1 from &2 JSON data1',
                                pcServiceName, oServiceList:GetType(pcServiceName))).
                next.
            end.
        end case.
        
        assign verMax = svcVersions:Length.
        do verCnt = 1 to verMax:
            LoadService(pcServiceName, pVersion, svcVersions:GetJsonObject(verCnt)).
        end.
        
        return true.
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
        
        /* service info */
        if pService:Has(string(ServiceMappingFileSchemaEnum:version)) then
            assign semVer = SemanticVersion:Parse(pService:GetCharacter(string(ServiceMappingFileSchemaEnum:version))).
        else
            assign semVer = new SemanticVersion().
        
        // If we passed a non-empty version in, then compare         
        if not pVersion eq '':u
           and not string(semVer) eq pVersion  
           then
            return.
        
        if     pService:Has(string(ServiceMappingFileSchemaEnum:operations)) 
           and pService:GetType(string(ServiceMappingFileSchemaEnum:operations)) eq JsonDataType:OBJECT 
           then
            assign oOperations = pService:GetJsonObject(string(ServiceMappingFileSchemaEnum:operations)).
        
        if     pService:Has(string(ServiceMappingFileSchemaEnum:schemas)) 
           and pService:GetType(string(ServiceMappingFileSchemaEnum:schemas)) eq JsonDataType:OBJECT 
           then
            assign oSchemas = pService:GetJsonObject(string(ServiceMappingFileSchemaEnum:schemas)).
        
        if    pService:Has(string(ServiceMappingFileSchemaEnum:catalog))
          and pService:GetType(string(ServiceMappingFileSchemaEnum:catalog)) eq JsonDataType:OBJECT then
            assign oCatalog = pService:GetJsonObject(string(ServiceMappingFileSchemaEnum:catalog)).
        
        RegisterService(pServiceName,
                        semVer:ToString(), 
                        oOperations,
                        oCatalog,
                        oSchemas        ).
        
        if     pService:Has(string(ServiceMappingFileSchemaEnum:options)) 
           and pService:GetType(string(ServiceMappingFileSchemaEnum:options)) eq JsonDataType:OBJECT 
           then
            this-object:Registry:PutServiceOptions(pServiceName,
                              semVer, 
                              LoadServiceOptions(pService:GetJsonObject(string(ServiceMappingFileSchemaEnum:options)))).
    end method.
     
    /* Registers all services found in a given file. Can be used at agent startup
       
       @param character An extant file */
    method public void RegisterFromFile(input pcFile as character):
        AssertFile:FileExists(pcFile).
        
        assign file-info:file-name = pcFile.
        
        LoadFromFile(file-info:handle).
     end method.

    /* Registers a named service found in a given file. Can be used at agent startup
       
       @param character A service name
       @param character An extant file */
    method public void RegisterFromFile(input pcServiceName as character,
                                        input pcFile as character):
        Assert:NotNullOrEmpty(pcServiceName, 'Service name').
        AssertFile:FileExists(pcFile).
        
        assign file-info:file-name = pcFile. 
        
        LoadFromFile(pcServiceName, '':u, file-info:handle).
     end method.

    /* Registers all services found in a given folder. Can be used at agent startup
       
       @param character An extant folder */
    method public void RegisterAllFromFolder(input pcFolder as character):
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
                    RegisterFromFile(pcFolder + '/':u + cService).
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
        define variable maxSchema as integer no-undo.
        define variable loop as integer no-undo.
        define variable childLoop as integer no-undo.
        define variable schemaName as character extent no-undo.
        define variable jsonData as JsonObject no-undo.
        define variable schemaOption as SchemaOption no-undo.
        
        assign options = new OperationOptions().
        
        if not valid-object(pData) then
            return options.
        
        if     pData:Has(string(ServiceMappingFileSchemaEnum:writeBI))
           and pData:GetType(string(ServiceMappingFileSchemaEnum:writeBI)) eq JsonDataType:BOOLEAN
           then
            assign options:WriteBI = pData:GetLogical(string(ServiceMappingFileSchemaEnum:writeBI)).

        if     pData:Has(string(ServiceMappingFileSchemaEnum:timeout))
           and pData:GetType(string(ServiceMappingFileSchemaEnum:timeout)) eq JsonDataType:NUMBER
           then
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
        
        if     pData:Has(string(ServiceMappingFileSchemaEnum:schemas)) 
           and pData:GetType(string(ServiceMappingFileSchemaEnum:schemas)) eq JsonDataType:OBJECT
           then
        do:
            assign jsonData   = pData:GetJsonObject(string(ServiceMappingFileSchemaEnum:schemas))
                   schemaName = jsonData:GetNames()
                   maxSchema  = extent(schemaName)
                   .
            do loop = 1 to maxSchema:
                if not jsonData:GetType(schemaName[loop]) eq JsonDataType:OBJECT then
                    next.
                
                assign schemaOption = new SchemaOption(schemaName[loop]).
                LoadSchemaOptions(input schemaOption,
                                  input jsonData:GetJsonObject(schemaName[loop])).
                
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
        
        // nothing to load
        if not valid-object(pData) then
            return.
        
        if     pData:Has(string(ServiceMappingFileSchemaEnum:serializeHidden))
           and pData:GetType(string(ServiceMappingFileSchemaEnum:serializeHidden)) eq JsonDataType:BOOLEAN
           then
            assign pSchemaOption:Hidden = pData:GetLogical(string(ServiceMappingFileSchemaEnum:serializeHidden)).

        if     pData:Has(string(ServiceMappingFileSchemaEnum:serializeName))
           and pData:GetType(string(ServiceMappingFileSchemaEnum:serializeName)) eq JsonDataType:STRING
           then
            assign pSchemaOption:SerializeName = pData:GetCharacter(string(ServiceMappingFileSchemaEnum:serializeName)).
        
        if     pData:Has(string(ServiceMappingFileSchemaEnum:fields))
           and pData:GetType(string(ServiceMappingFileSchemaEnum:fields)) eq JsonDataType:OBJECT
           then
        do:
            assign pData         = pData:GetJsonObject(string(ServiceMappingFileSchemaEnum:fields))
                   propertyNames = pData:GetNames()
                   numProps      = extent(propertyNames)
                   .
            do loop = 1 to numProps:
                assign childOption = new SchemaOption(propertyNames[loop]).
                pSchemaOption:PutChildSchema(childOption).
                
                LoadSchemaOptions(input childOption,
                                  input pData:GetJsonObject(propertyNames[loop])).
            end.
        end.
    end.
    
    /* Creates a schema holder for this parameter for this operation.
       
       @param MappedOperation The operation to which this parameter applies
       @param OperationParameter The parameter for which to create a schema holder 
       @param handle An empty schema for this operation/parameter */
    method private void CreateParameterSchema(input pOperation as MappedOperation,
                                              input pParam as OperationParameter):
        define variable serviceSchema as handle no-undo.
        define variable operationSchema as handle no-undo.
        define variable cloneTime as datetime extent 2 no-undo.
        define variable excludeElements as character no-undo.
        define variable mapElements as character no-undo.
        
        Assert:NotNull(pOperation, 'Mapped operation').
        Assert:NotNull(pParam, 'Operation parameter').
        
        // if there's no schema, or we have a valid schema, return
        if not pParam:HasSchema
           or  valid-object(pOperation:Schemas:Get(pParam:ABLName))
           then
            return.
        
        assign serviceSchema = this-object:Registry:GetSchema(pOperation:ServiceName, pParam:ABLName).
        if not valid-handle(serviceSchema) then
        do:
            Logger:Warn(substitute('Unable to find schema &2 for service &1',
                            pOperation:ServiceName, 
                            pParam:ABLName)).
            return.
        end.
        
        assign cloneTime[1] = now.
        case pParam:DataType:
            when 'dataset-handle':u then
                create dataset operationSchema.
            when 'table-handle':u then
            do:
                /* If the TT is part of a dataset, clone the DATASET - we'll only use the
                   temp-table but we want it to be part of a whole */
                if valid-handle(serviceSchema:default-buffer-handle:dataset) then
                do:
                    create dataset operationSchema.
                    assign serviceSchema = serviceSchema:default-buffer-handle:dataset.
                end.
                else
                    create temp-table operationSchema.
            end.
        end case.
        
        operationSchema:create-like(serviceSchema).
        case operationSchema:type:
            when 'table':u then
            do:
                // The BEFORE-TABLE does NOT come along for the ride ...
                operationSchema:temp-table-prepare(serviceSchema:name,
                                                   valid-handle(serviceSchema:before-table) ).
                
                // apply serialize-* settings to TT
                ApplySchemaOptions(operationSchema:default-buffer-handle,
                                   cast(pOperation:Options:SchemaOptions:Get(pParam:ABLName), SchemaOption)).
            end.    // TT
            when 'dataset' then
                // apply serialize-* settings to TT
                ApplySchemaOptions(operationSchema,
                                   cast(pOperation:Options:SchemaOptions:Get(pParam:ABLName), SchemaOption)).
        end case.
        
        assign cloneTime[2] = now.
        Logger:Trace(substitute('Schema &1 clone time &2ms',
                        pParam:ABLName,
                        interval(cloneTime[2], cloneTime[1], string(DateTimeAddIntervalEnum:Milliseconds)))).
        
        /* we want to keep the schema around for the duration of this call and destroy it when we're done */
        pOperation:Schemas:Put(pParam:ABLName, new WidgetHandle(operationSchema, true)).
    end method.
    
    /** Applies schema-related options (serialize-*) to a buffer
        
        @param handle The buffer handle to which to apply the option
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
            
        Assert:NotNull(pSchema, 'Service Schema').
        
        // this schema 
        if not pOptions:SerializeName eq ? then
            assign pSchema:serialize-name = pOptions:SerializeName.
        
        if     pOptions:Hidden
           and not (    pSchema:type eq 'buffer':u
                     or pSchema:type eq 'temp-table':u )
           then
            assign pSchema:serialize-hidden = pOptions:Hidden.
        
        // Child schemas are only for tables/buffers
        if     pOptions:HasChildSchema()
           and (   pSchema:type eq 'buffer':u
                or pSchema:type eq 'temp-table':u)
           then 
            assign childSchemaNames = pOptions:GetChildSchemas()
                   numChildren      = extent(childSchemaNames)
                   .
        do loop =  1 to numChildren:
            assign childOption = pOptions:GetChildSchema(childSchemaNames[loop])
                   schemaElement = pSchema:buffer-field(childSchemaNames[loop])
                   
                   schemaElement:serialize-hidden = childOption:Hidden
                   schemaElement:serialize-name   = childOption:SerializeName
                   .
            //recurse
            ApplySchemaOptions(schemaElement, childOption).
        end.
    end.
    
    /** Loads service options from JSON.
        
        @param JsonObject The service options
        @return ServiceOptions The service options */
    method private ServiceOptions LoadServiceOptions(input pData as JsonObject):
        define variable svcOptions as ServiceOptions no-undo.
        
        assign svcOptions = new ServiceOptions().
        
        return svcOptions. 
    end method.
    
end class.
