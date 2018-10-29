/* *************************************************************************************************************************
Copyright (c) 2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : MappingFileServiceWriter
    Purpose     : Serializes a DataObjectService to a Data Object Handler mapping file JSON format
    Author(s)   : pjudge
    Created     : 2018-08-06
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.IOModeEnum.
using OpenEdge.Core.Util.BuilderRegistry.
using OpenEdge.Logging.Logger.
using OpenEdge.Net.HTTP.Cookie.
using OpenEdge.Net.HTTP.CookieCollection.
using OpenEdge.Net.HTTP.HttpHeader.
using OpenEdge.Net.HTTP.HttpHeaderCollection.
using OpenEdge.Net.HTTP.MethodEnum.
using OpenEdge.Web.DataObject.DataObjectService.
using OpenEdge.Web.DataObject.MappedOperation.
using OpenEdge.Web.DataObject.MessageElement.
using OpenEdge.Web.DataObject.OperationOptions.
using OpenEdge.Web.DataObject.OperationParameter.
using OpenEdge.Web.DataObject.SchemaOption.
using OpenEdge.Web.DataObject.ServiceMappingFileSchemaEnum.
using OpenEdge.Web.DataObject.TargetTypeEnum.
using OpenEdge.Web.DataObject.Writer.DataObjectServiceWriter.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Json.ObjectModel.JsonDataType.
using Progress.Json.ObjectModel.JsonObject.

class OpenEdge.Web.DataObject.Writer.MappingFileServiceWriter inherits DataObjectServiceWriter: 
    
    /* Default constructor */
    constructor public MappingFileServiceWriter():
        super(get-class(JsonObject)).
    end constructor.
    
    method override public void Open(): 
        // If nothing's passed in, create an instance of the Argument Type
        if not valid-object(this-object:Value) then
        do:
            assign this-object:Value = new JsonObject().
            
            cast(this-object:Value, JsonObject):Add(string(ServiceMappingFileSchemaEnum:services), new JsonObject()).
        end.
        else
        if not cast(this-object:Value, JsonObject):Has(string(ServiceMappingFileSchemaEnum:services)) then
            cast(this-object:Value, JsonObject):Add(string(ServiceMappingFileSchemaEnum:services), new JsonObject()).
        else
        if cast(this-object:Value, JsonObject):GetType(string(ServiceMappingFileSchemaEnum:services)) eq JsonDataType:OBJECT then
            cast(this-object:Value, JsonObject):Set(string(ServiceMappingFileSchemaEnum:services), new JsonObject()).
        
        super:Open().
    end method.
    
    /* Writes a single MappedOperation
       
       @param DataObjectService The current service 
       @param MappedOperation The service operation to write */
    method override protected void WriteOperation(input pService as DataObjectService, 
                                                  input pOperation as MappedOperation).
        define variable svcData as JsonObject no-undo.
        define variable opMethod as JsonObject no-undo.
        
        if not valid-object(pOperation) then
            return.
        
        assign svcData  = GetServiceJson(pService)
               opMethod = GetOperationJson(svcData, pOperation:ServiceURI, pOperation:Method)
               .
        
        opMethod:Add(string(ServiceMappingFileSchemaEnum:contentType), pOperation:ContentType).
        opMethod:Add(string(ServiceMappingFileSchemaEnum:statusCode),  pOperation:StatusCode).
        opMethod:Add(string(ServiceMappingFileSchemaEnum:name),        pOperation:Name).
        opMethod:Add(string(ServiceMappingFileSchemaEnum:options),     WriteOperationOptions(pOperation:Options)).
        opMethod:Add(string(ServiceMappingFileSchemaEnum:headers),     WriteOperationHeaders(pOperation:Headers)).
        opMethod:Add(string(ServiceMappingFileSchemaEnum:cookies),     WriteOperationCookies(pOperation:Cookies)).
        
        case pOperation:TargetType:
            when string(TargetTypeEnum:Void) then       WriteVoidOperation(pOperation, opMethod).
            when string(TargetTypeEnum:File) then       WriteFileOperation(pOperation, opMethod).
            when string(TargetTypeEnum:Class) then      WriteEntityOperation(pOperation, opMethod).
            when string(TargetTypeEnum:Procedure) then  WriteEntityOperation(pOperation, opMethod).
            otherwise                                   WriteUnknownOperation(pOperation, opMethod).
        end case.
    end method.
    
    method protected JsonObject GetSchemaJson(input pServiceData as JsonObject,
                                              input pSchemaName as character):
        define variable schemaData as JsonObject no-undo.
        define variable allSchemas as JsonObject no-undo.
        
        /*
            {"1.0.0": {
                "operations": {
                    "/": {
                        "GET": {
                } 
            }
        */
        assign allSchemas = pServiceData:GetJsonObject(string(ServiceMappingFileSchemaEnum:schemas)).
        
        if allSchemas:Has(pSchemaName) then
            assign schemaData = allSchemas:GetJsonObject(pSchemaName).
        else
        do:
            assign schemaData = new JsonObject().
            allSchemas:Add(pSchemaName, schemaData).
        end. 
        
        return schemaData.
    end method.
    
    method protected JsonObject GetOperationJson(input pServiceData as JsonObject,
                                                 input pUri as character,
                                                 input pMethod as MethodEnum):
        define variable methodData as JsonObject no-undo.
        define variable uriData as JsonObject no-undo.
        define variable opsData as JsonObject no-undo.
        
        /*
            {"1.0.0": {
                "operations": {
                    "/": {
                        "GET": {
                } 
            }
        */
        assign opsData = pServiceData:GetJsonObject(string(ServiceMappingFileSchemaEnum:operations)).
        
        if opsData:Has(pUri) then
            assign uriData = opsData:GetJsonObject(pUri).
        else
        do:
            assign uriData    = new JsonObject()
                   methodData = new jsonObject()
                   .
            opsData:Add(pUri, uriData).
            uriData:Add(string(pMethod), methodData).
            
            return methodData.
        end. 
        
        if uriData:Has(string(pMethod)) then
            assign methodData = uriData:GetJsonObject(string(pMethod)).
        else
        do:
            assign methodData = new JsonObject().
            uriData:Add(string(pMethod), methodData).
        end.
        
        return methodData.
    end method.
    
    method protected JsonObject GetServiceJson(input pService as DataObjectService):
        define variable svcData as JsonObject no-undo.
        define variable services as JsonObject no-undo.
        define variable namedSvc as JsonArray no-undo.
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        define variable svcName as character no-undo.
        
        /* the target JSON looks like 
        { "services: 
            { "svcName":
                [
                    { "1.0.0" },
                    { "2.0.0" }
                ]
        }
        */
        assign svcName = pService:Name.
        if svcName eq DataObjectService:ROOT_SERVICE_NAME then
            assign svcName = DataObjectService:ROOT_SERVICE_URI.
        
        assign services = cast(this-object:Value, JsonObject):GetJsonObject(string(ServiceMappingFileSchemaEnum:services)).
        if not services:Has(svcName) then
        do:
            assign namedSvc = new JsonArray().
            services:Add(svcName, namedSvc). 
        end.
        else
        case services:GetType(svcName):
            when JsonDataType:ARRAY then
                assign namedSvc = services:GetJsonArray(svcName).
            when JsonDataType:OBJECT then
            do:
                assign namedSvc = new JsonArray().
                namedSvc:Add(services:GetJsonObject(svcName)).
                services:Set(svcName, namedSvc).
            end.
            otherwise
            do:
                assign namedSvc = new JsonArray().
                services:Set(svcName, namedSvc).
            end.
        end case.
        
        assign cnt = namedSvc:Length.
        do loop = 1 to cnt while not valid-object(svcData):
            if namedSvc:GetType(loop) eq JsonDataType:OBJECT then
                assign svcData = namedSvc:GetJsonObject(loop). 
            
            if not svcData:GetCharacter(string(ServiceMappingFileSchemaEnum:version)) eq string(pService:Version) then
                assign svcData = ?.
        end.
        
        if valid-object(svcData) then
        do:
            if not svcData:Has(string(ServiceMappingFileSchemaEnum:version)) then
                svcData:Add(string(ServiceMappingFileSchemaEnum:version), string(pService:Version)).
            if not svcData:Has(string(ServiceMappingFileSchemaEnum:options)) then
                svcData:Add(string(ServiceMappingFileSchemaEnum:options), new JsonObject()).
            if not svcData:Has(string(ServiceMappingFileSchemaEnum:argumentWriters)) then
                svcData:Add(string(ServiceMappingFileSchemaEnum:argumentWriters), new JsonObject()).
            if not svcData:Has(string(ServiceMappingFileSchemaEnum:operations)) then
                svcData:Add(string(ServiceMappingFileSchemaEnum:operations), new JsonObject()).
            if not svcData:Has(string(ServiceMappingFileSchemaEnum:schemas)) then
                svcData:Add(string(ServiceMappingFileSchemaEnum:schemas), new JsonObject()).
        end.
        else
        do:
        
            assign svcData = new JsonObject().
            svcData:Add(string(ServiceMappingFileSchemaEnum:version),           string(pService:Version)).
            svcData:Add(string(ServiceMappingFileSchemaEnum:options),           new JsonObject()).
            svcData:Add(string(ServiceMappingFileSchemaEnum:argumentWriters),   new JsonObject()).
            svcData:Add(string(ServiceMappingFileSchemaEnum:operations),        new JsonObject()).
            svcData:Add(string(ServiceMappingFileSchemaEnum:schemas),           new JsonObject()).
            namedSvc:Add(svcData).
        end.
        
        return svcData.
    end method.
    
    /* Writes a single Data Object Service 
       
       @param DataObjectService The service to write */
    method override protected void WriteService(input pData as DataObjectService):
        define variable svcData as JsonObject no-undo.
        
        if not valid-object(pData) then
            return.
        
        assign svcData = GetServiceJson(pData).
        
        // version is already set in the svcData object
        
        // catalog
        if valid-object(pData:Catalog) then
            svcData:Add(string(ServiceMappingFileSchemaEnum:catalog), pData:Catalog).
        
        // writers
        svcData:Set(string(ServiceMappingFileSchemaEnum:argumentWriters), WriteArgumentWriters(pData:ArgumentWriters)).
        
        // options. nothing to write yet
        // svcData:Set(string(ServiceMappingFileSchemaEnum:options), ).
    end method.
    
    /* Writes a single schema
       
       @param DataObjectService The current service 
       @param handle The service schema to write */
    method override protected void WriteSchema(input pService as DataObjectService, 
                                               input pSchema as handle):
        define variable schemaJson as JsonObject no-undo.
        define variable childJson as JsonObject no-undo.
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        define variable tableHdl as handle no-undo.
        define variable tableBaseHdl as handle no-undo.
        define variable svcData as JsonObject no-undo.
        define variable schemas as JsonObject no-undo.
        
        if not valid-handle(pSchema)
          // this is part of a dataset and we write it out as the dataset.
          // child TT's get written out as part of the dataset
           or (     pSchema:type eq 'temp-table':u
                and valid-handle(pSchema:default-buffer-handle:dataset) )
           or (     pSchema:type eq 'buffer':u
                and valid-handle(pSchema:dataset) )
        then
            return.
        
        assign svcData    = GetServiceJson(pService)
               schemaJson = GetSchemaJson(svcData, pSchema:name)
               .
        if pSchema:type eq 'dataset':u then
        do:
            if    pSchema:serialize-hidden
               or not pSchema:serialize-name eq pSchema:name
            then
            do:
                assign childJson = new JsonObject().
                schemaJson:Add(string(ServiceMappingFileSchemaEnum:attr), childJson).
                
                childJson:Add(string(ServiceMappingFileSchemaEnum:serializeHidden), pSchema:serialize-hidden).
                childJson:Add(string(ServiceMappingFileSchemaEnum:serializeName),   pSchema:serialize-name).
            end.
            
            assign cnt = pSchema:num-buffers.
            do loop = 1 to cnt:
                assign tableHdl = pSchema:get-buffer-handle(loop).
                schemaJson:Add(tableHdl:name, WriteSchemaTable(tableHdl)).
            end.
        end.
        else
            schemaJson:Add(pSchema:name, WriteSchemaTable(pSchema)).
    end method.
    
    /* Writes schema data for a table 
       
       @param handle The schema to write */
    method protected JsonObject WriteSchemaTable(input pSchema as handle ):
        define variable bufferHdl as handle no-undo.
        define variable tableJson as JsonObject no-undo.
        define variable childObj as JsonObject no-undo.
        define variable fldJson as JsonArray no-undo.
        define variable idxJson as JsonObject no-undo.
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        define variable idx as integer no-undo.
        define variable fieldHdl as handle no-undo.
        define variable idxInfo as character no-undo.
        
        // we want to work with buffer handles
        case pSchema:type:
            when 'dataset':u then
                return ?.
            when 'buffer':u then
                assign bufferHdl = pSchema.
            otherwise 
                assign bufferHdl = pSchema:default-buffer-handle.
        end case.
        
        assign tableJson = new JsonObject().
        
        tableJson:Add(string(ServiceMappingFileSchemaEnum:trackChanges), valid-object(bufferHdl:table-handle:before-table)).
        
        if not bufferHdl:serialize-name eq bufferHdl:name then
            tableJson:Add(string(ServiceMappingFileSchemaEnum:serializeName), bufferHdl:serialize-name).
        
        // fields
        assign cnt     = bufferHdl:num-fields
               fldJson = new JsonArray()
               .
        tableJson:Add(string(ServiceMappingFileSchemaEnum:fields), fldJson).
        
        do loop = 1 to cnt:
            assign childObj = new JsonObject()
                   fieldHdl = bufferHdl:buffer-field(loop)
                   .
            fldJson:Add(childObj).
            
            childObj:Add(string(ServiceMappingFileSchemaEnum:name), fieldHdl:name).
            childObj:Add(string(ServiceMappingFileSchemaEnum:ablType), fieldHdl:data-type).
            childObj:Add(string(ServiceMappingFileSchemaEnum:extent), fieldHdl:extent).
            
            if fieldHdl:serialize-hidden then
                childObj:Add(string(ServiceMappingFileSchemaEnum:serializeHidden), fieldHdl:serialize-hidden).
            
            if not fieldHdl:serialize-name eq fieldHdl:name then
                childObj:Add(string(ServiceMappingFileSchemaEnum:serializeName), fieldHdl:name).
        end.
        
        // indexes
        assign idx     = 1 
               idxInfo = bufferHdl:index-information(idx)
               idxJson = new JsonObject()
               .
        tableJson:Add(string(ServiceMappingFileSchemaEnum:indexes), idxJson).
        
        do while idxInfo ne ?:
            assign childObj = new JsonObject()
                   cnt      = num-entries(idxInfo)
                   fldJson  = new JsonArray() 
                   .
            idxJson:Add(entry(1, idxInfo), childObj).
            
            childObj:Add(string(ServiceMappingFileSchemaEnum:unique),  logical(integer(entry(2, idxInfo)))).
            childObj:Add(string(ServiceMappingFileSchemaEnum:primary), logical(integer(entry(3, idxInfo)))).
            childObj:Add(string(ServiceMappingFileSchemaEnum:word),    logical(integer(entry(4, idxInfo)))).
            childObj:Add(string(ServiceMappingFileSchemaEnum:fields),  fldJson).
            
            // index fields
            do loop = 5 to cnt by 2:
                if entry(loop, idxInfo) eq '':u then
                    next.
                
                fldJson:Add(substitute('&1:&2':u,
                                entry(loop, idxInfo),
                                string(logical(integer(entry(loop + 1, idxInfo))), 'DESC/ASC':u))).
            end.
            
            assign idx     = idx + 1
                   idxInfo = bufferHdl:index-information(idx)
                   .
        end.
        
        return tableJson.
    end method.

    /* Writes the Operation Headers into JSON
       
       @param OperationOptions A set of options
       @return JsonObject The JSON data */
    method protected JsonObject WriteOperationHeaders(input pData as HttpHeaderCollection):
        define variable hdrJson as JsonObject no-undo.
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        define variable hdrs as HttpHeader extent no-undo.
        
        pData:GetAll(output hdrs).
        assign hdrJson = new JsonObject()
               cnt     = extent(hdrs)
               .
        do loop = 1 to cnt:
            hdrJson:Add(hdrs[loop]:Name, hdrs[loop]:Value).
        end.
        
        return hdrJson.
    end method.
    
    /* Writes the Operation Cookies into JSON
       
       @param OperationOptions A set of options
       @return JsonArray */
    method protected JsonArray WriteOperationCookies(input pData as CookieCollection):
        define variable cookieJson as JsonArray no-undo.
        define variable iter as IIterator no-undo.
        define variable cookie as Cookie no-undo.
        
        assign iter       = pData:Iterator()
               cookieJson = new JsonArray()
               .
        do while iter:HasNext():
            assign cookie = cast(iter:Next(), Cookie).
            cookieJson:Add(string(cookie)).
        end.
        
        return cookieJson.
    end method.
    
    /* Writes the Operation Cookies into JSON
       
       @param OperationOptions A set of options
       @return JsonArray */
    method protected JsonArray WriteArgumentWriters(input pData as BuilderRegistry):
        define variable writerJson as JsonArray no-undo.
        define variable writerKeys as character extent no-undo.
        define variable singleWriter as JsonObject no-undo.
        define variable cnt as integer no-undo.
        define variable loop as integer no-undo.
        
        assign writerJson = new JsonArray()
               writerKeys = pData:GetKeys()
               cnt        = extent(writerKeys)
               .
        do loop = 1 to cnt:
            assign singleWriter = new JsonObject().
            writerJson:Add(singleWriter).
            
            singleWriter:Add(string(ServiceMappingFileSchemaEnum:name), writerKeys[loop]).
            singleWriter:Add(string(ServiceMappingFileSchemaEnum:type), pData:Get(writerKeys[loop]):TypeName).
        end.
        
        return writerJson.
    end method.
    
    /* Writes the Operation options into JSON
       
       @param OperationOptions A set of options
       @return JsonObject */
    method protected JsonObject WriteOperationOptions(input pData as OperationOptions):
        define variable optionsJson as JsonObject no-undo.
        define variable childObj as JsonObject no-undo.
        define variable schemasJson as JsonObject no-undo.
        define variable fldJson as JsonObject no-undo.
        define variable detailJson as JsonObject no-undo.
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        define variable schemaOption as SchemaOption no-undo.
        define variable childOption as SchemaOption no-undo.
        define variable names as character extent no-undo.
        define variable iter as IIterator no-undo.
        
        if not valid-object(pData) then
            return optionsJson.
        assign optionsJson = new JsonObject().
        
        optionsJson:Add(string(ServiceMappingFileSchemaEnum:writeBI), pData:WriteBI).
        optionsJson:Add(string(ServiceMappingFileSchemaEnum:timeout), pData:Timeout).
        if pData:HasRequestEnvelope then
            optionsJson:Add(string(ServiceMappingFileSchemaEnum:requestEnvelope), pData:RequestEnvelope).
        if pData:HasResponseEnvelope then
            optionsJson:Add(string(ServiceMappingFileSchemaEnum:responseEnvelope), pData:ResponseEnvelope).
        if pData:HasErrorEnvelope then
            optionsJson:Add(string(ServiceMappingFileSchemaEnum:errorEnvelope), pData:ErrorEnvelope).
        
        // schema options
        assign schemasJson = new JsonObject().
        optionsJson:Add(string(ServiceMappingFileSchemaEnum:schemas), schemasJson).
        
        assign iter = pData:SchemaOptions:Values:Iterator().
        do while iter:HasNext():
            assign schemaOption = cast(iter:Next(), SchemaOption)
                   childObj = new JsonObject()
                   .
            schemasJson:Add(schemaOption:SchemaName, childObj).
            
            childObj:Add(string(ServiceMappingFileSchemaEnum:serializeHidden), schemaOption:Hidden).
            if not schemaOption:SerializeName eq ? then
                childObj:Add(string(ServiceMappingFileSchemaEnum:serializeName),   schemaOption:SerializeName). 
            
            // child schema options
            if schemaOption:HasChildSchema() then
            do:
                assign fldJson = new JsonObject()
                       names   = schemaOption:GetChildSchemas()
                       cnt     = extent(names) 
                       .
                childObj:Add(string(ServiceMappingFileSchemaEnum:fields), fldJson).
                do loop = 1 to cnt:
                    assign childOption = schemaOption:GetChildSchema(names[loop])
                           detailJson  = new JsonObject()   
                           .
                    fldJson:Add(childOption:SchemaName, detailJson).
                    
                    detailJson:Add(string(ServiceMappingFileSchemaEnum:serializeHidden), childOption:Hidden).
                    if not schemaOption:SerializeName eq ? then
                        detailJson:Add(string(ServiceMappingFileSchemaEnum:serializeName), childOption:SerializeName). 
                end.
            end.    // has child schemas
        end.    // iterate over schema options
        
        return optionsJson.
    end method.
    
    /* Writes the contents of an unknown (undefined) operation to the JSON
        
        @param MappedOperation The operation to write
        @param JsonObject The JSON output */
    method protected void WriteUnknownOperation(input pOperation as MappedOperation,
                                                input pJson as JsonObject):
        pJson:AddNull('unknown':u).
        Logger:Warn(substitute('Unknown target type &1 for operation "&4 &5"',
                                                pOperation:TargetType,
                                                string(pOperation:Method),
                                                pOperation:ServiceURI )).
    end method.
    
    /* Writes the contents of a VOID operation to the JSON
        
        @param MappedOperation The operation to write
        @param JsonObject The JSON output */
    method protected JsonObject WriteVoidOperation(input pOperation as MappedOperation,
                                                   input pJson as JsonObject):
        // void is simple
        pJson:AddNull(string(ServiceMappingFileSchemaEnum:void)).
    end method.
    
    /* Writes the contents of anh ENTITY operation to the JSON
        
        @param MappedOperation The operation to write
        @param JsonObject The JSON output */
    method protected void WriteEntityOperation(input pOperation as MappedOperation,
                                               input pJson as JsonObject):
        define variable entityJson as JsonObject no-undo.
        define variable argJson as JsonObject no-undo.
        define variable elemJson as JsonConstruct no-undo.
        define variable args as JsonArray no-undo.
        define variable iter as IIterator no-undo.
        define variable operParm as OperationParameter no-undo.
        
        assign entityJson = new JsonObject()
               args       = new JsonArray()
               iter       = pOperation:Parameters:Iterator()
               .
        pJson:Add(string(ServiceMappingFileSchemaEnum:entity), entityJson).
        
        entityJson:Add(string(ServiceMappingFileSchemaEnum:name),       pOperation:TargetName). 
        entityJson:Add(string(ServiceMappingFileSchemaEnum:function),   pOperation:TargetFunction).
        entityJson:Add(string(ServiceMappingFileSchemaEnum:type),       pOperation:TargetType).
        entityJson:Add(string(ServiceMappingFileSchemaEnum:typeOf),     pOperation:EntityType:TypeName).
        entityJson:Add(string(ServiceMappingFileSchemaEnum:arg),        args).
        
        if valid-object(pOperation:ReturnValue) then
        do:
            assign argJson   = new JsonObject()
                   elemJson = WriteMessageElement(pOperation:ReturnValue)
                   .
            args:Add(argJson).
            
            argJson:Add(string(ServiceMappingFileSchemaEnum:ablName), '':u).
            argJson:Add(string(ServiceMappingFileSchemaEnum:ablType), pOperation:ReturnValue:ABLType).
            argJson:Add(string(ServiceMappingFileSchemaEnum:ioMode),  string(IOModeEnum:Return)).
            
            case true:
                when not valid-object(elemJson)    then argJson:AddNull(string(ServiceMappingFileSchemaEnum:msgElem)).
                when type-of(elemJson, JsonArray)  then argJson:Add(string(ServiceMappingFileSchemaEnum:msgElem), cast(elemJson, JsonArray)).
                when type-of(elemJson, JsonObject) then argJson:Add(string(ServiceMappingFileSchemaEnum:msgElem), cast(elemJson, JsonObject)).
            end case.                
        end.
        
        do while iter:HasNext():
            assign operParm = cast(iter:Next(), OperationParameter)
                   elemJson = WriteMessageElement(operParm)
                   argJson = new JsonObject()
                   .
            args:Add(argJson).
            
            argJson:Add(string(ServiceMappingFileSchemaEnum:ablName), operParm:ABLName).
            argJson:Add(string(ServiceMappingFileSchemaEnum:ablType), operParm:ABLType).
            argJson:Add(string(ServiceMappingFileSchemaEnum:ioMode),  string(operParm:IOMode)).
            
            case true:
                when not valid-object(elemJson)    then argJson:AddNull(string(ServiceMappingFileSchemaEnum:msgElem)).
                when type-of(elemJson, JsonArray)  then argJson:Add(string(ServiceMappingFileSchemaEnum:msgElem), cast(elemJson, JsonArray)).
                when type-of(elemJson, JsonObject) then argJson:Add(string(ServiceMappingFileSchemaEnum:msgElem), cast(elemJson, JsonObject)).
            end case.                
        end.
    end method.
    
    /* Builds the appropriate JSON for a parameter's messgae element(s)
       
       @param OperationParameter
       @return JsonConstruct  Either unknown, or a JsonObject or JsonArray  */
    method protected JsonConstruct WriteMessageElement(input pParam as OperationParameter):
        define variable elemObj as JsonObject no-undo.
        define variable elemArr as JsonArray no-undo.
        define variable msgElem as MessageElement no-undo.
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        
        if     extent(pParam:InputElement) eq ?
           and extent(pParam:OutputElement) eq ?
        then
            return ?.
        
        assign cnt     = extent(pParam:InputElement)
               elemArr = new JsonArray()
               .
        do loop = 1 to cnt:
            assign elemObj = new JsonObject()
                   msgElem = pParam:InputElement[loop]
                   .
            elemArr:Add(elemObj).
            
            elemObj:Add(string(ServiceMappingFileSchemaEnum:type),   caps(string(msgElem:ElementType))).
            elemObj:Add(string(ServiceMappingFileSchemaEnum:name),   msgElem:ElementName).
            elemObj:Add(string(ServiceMappingFileSchemaEnum:ioMode), string(IoModeEnum:Input)).
            if not msgElem:ABLReference eq ? then
                elemObj:Add(string(ServiceMappingFileSchemaEnum:ablRef), msgElem:ABLReference).
        end.
        
        assign cnt = extent(pParam:OutputElement).
        do loop = 1 to cnt:
            assign elemObj = new JsonObject()
                   msgElem = pParam:OutputElement[loop]
                   .
            elemArr:Add(elemObj).
            
            elemObj:Add(string(ServiceMappingFileSchemaEnum:type),   caps(string(msgElem:ElementType))).
            elemObj:Add(string(ServiceMappingFileSchemaEnum:name),   msgElem:ElementName).
            elemObj:Add(string(ServiceMappingFileSchemaEnum:ioMode), string(IoModeEnum:Output)).
            if not msgElem:ABLReference eq ? then
                elemObj:Add(string(ServiceMappingFileSchemaEnum:ablRef), msgElem:ABLReference).
        end.
        
        if elemArr:Length eq 1 then
            return elemArr:GetJsonObject(1).
        else
            return elemArr.
    end method.
    
    /* Writes the contents of a FILE operation to the JSON
        
        @param MappedOperation The operation to write
        @param JsonObject The JSON output */
    method protected void WriteFileOperation(input pOperation as MappedOperation,
                                             input pJson as JsonObject):
        pJson:Add(string(ServiceMappingFileSchemaEnum:file), pOperation:TargetName).
    end method.
    
end class.
