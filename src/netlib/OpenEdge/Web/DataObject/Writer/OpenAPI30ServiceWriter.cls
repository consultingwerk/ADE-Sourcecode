/* *************************************************************************************************************************
Copyright (c) 2018 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : OpenAPI30ServiceWriter
    Purpose     : Writes a DataObjectService to a OpenApi (Swagger) 3.0 doc
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2018-09-20
    Notes       : - https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.1.md 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.SemanticVersion.
using OpenEdge.Net.HTTP.HttpHeader.
using OpenEdge.Net.HTTP.MethodEnum.
using OpenEdge.Net.URI.
using OpenEdge.Web.DataObject.DataObjectService.
using OpenEdge.Web.DataObject.ElementTypeEnum.
using OpenEdge.Web.DataObject.MappedOperation.
using OpenEdge.Web.DataObject.MessageElement.
using OpenEdge.Web.DataObject.OperationParameter.
using OpenEdge.Web.DataObject.TargetTypeEnum.
using OpenEdge.Web.DataObject.Writer.DataObjectServiceWriter.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonObject.

class OpenEdge.Web.DataObject.Writer.OpenAPI30ServiceWriter inherits DataObjectServiceWriter:
    
    define static public property OPEN_API_VERSION as SemanticVersion no-undo
        get.
        private set.
    
    constructor static OpenAPI30ServiceWriter():
        assign OPEN_API_VERSION = new SemanticVersion(3,0,1).
    end constructor.
    
    /* Default constructor */
    constructor public OpenAPI30ServiceWriter():
        super (get-class(JsonObject)).
    end constructor.
    
    method override public void Open(  ):
        // If nothing's passed in, create an instance of the Argument Type
        if not valid-object(this-object:Value) then
            assign this-object:Value = WriteServiceRoot().
        
        super:Open().
    end method.
    
    method protected JsonArray WriteDefaultServers():
        define variable servers as JsonArray no-undo.
        define variable arrayData as JsonArray no-undo.
        define variable defaultServer as JsonObject no-undo.
        define variable varData as JsonObject no-undo.
        define variable childData as JsonObject no-undo.
        
        assign servers       = new JsonArray()
               defaultServer = new JsonObject()
               childData     = new JsonObject()
               .
        // abs path
        servers:Add(defaultServer).
        
        defaultServer:Add('url':u, '~{scheme}://~{host}:~{port}~{ctx}/web~{basePath}':u).
        defaultServer:Add('description':u, 'Default server configuration':u).
        defaultServer:Add('variables':u, childData).
        
        assign varData   = new JsonObject()
               arrayData = new JsonArray()
               .
        childData:Add('scheme':u, varData).
            varData:Add('enum':u, arrayData).
                arrayData:Add('http':u).
                arrayData:Add('https':u).
            varData:Add('default':u, 'http':u).
        
        assign varData   = new JsonObject()
               arrayData = new JsonArray()
               .
        childData:Add('host':u, varData).
            varData:Add('default':u, 'localhost':u).
        
        assign varData   = new JsonObject()
               arrayData = new JsonArray()
               .
        childData:Add('port':u, varData).
            varData:Add('default':u, '8810':u).
        
        assign varData   = new JsonObject()
               arrayData = new JsonArray()
               .
        childData:Add('ctx':u, varData).
            varData:Add('description':u, 'The webapp/context for this service. Empty/blank indicates ROOT':u).
            varData:Add('default':u, '':u).
        
        assign varData = new JsonObject().
        childData:Add('basePath':u, varData).
            varData:Add('default':u, '/pdo':u).
        
        // relative path. will work relative to the OpenApi doc location 
        assign defaultServer = new JsonObject()
               childData     = new JsonObject()
               .
        servers:Add(defaultServer).
        
        defaultServer:Add('url':u, '~{ctx}/web~{basePath}':u).
        defaultServer:Add('description':u, 'Default relative-path server configuration':u).
        defaultServer:Add('variables':u, childData).
        
        assign varData   = new JsonObject()
               arrayData = new JsonArray()
               .
        childData:Add('ctx':u, varData).
            varData:Add('description':u, 'The webapp/context for this service. Empty/blank indicates ROOT':u).
            varData:Add('default':u, '':u).
        
        assign varData = new JsonObject().
        childData:Add('basePath':u, varData).
            varData:Add('default':u, '/pdo':u).
        
        return servers.
    end method.
    
    method protected JsonObject WriteInfo():
        define variable infoData as JsonObject no-undo.
        define variable childData as JsonObject no-undo.
        
        assign infoData = new JsonObject().
        //string  Required. The title of the application.
        infoData:Add('title':u, 'OpenAPI documentation for DataObjectHandler-based services':u).
        //string  A short description of the application. GFM syntax can be used for rich text representation.
        infoData:Add('description':u, '':u).
        //string  The Terms of Service for the API.
        infoData:Add('termsOfService':u, '':u).
        
        //Object  The contact information for the exposed API.
        assign childData = new JsonObject().
        infoData:Add('contact':u, childData).
            childData:Add('name':u, '':u).
            childData:Add('url':u, '':u).
            childData:Add('email':u, '':u).
        
        //Object  The license information for the exposed API.
        assign childData = new JsonObject().
        infoData:Add('license':u, childData).
            childData:Add('name':u, '':u).
            childData:Add('url':u, '':u).
        
        // The version of the OpenAPI document (which is distinct from the OpenAPI Specification
        // version or the API implementation version).
        infoData:Add('version':u, '1.0.0':u).   
        
        return infoData.
    end method.
    
    method protected JsonObject WriteServiceRoot():
        define variable svcJson as JsonObject no-undo.
        define variable jsonData as JsonObject no-undo.
        define variable childData as JsonObject no-undo.
        define variable arrayData as JsonArray no-undo.
        define variable varData as JsonObject no-undo.
        
        assign svcJson   = new JsonObject()
               jsonData  = new JsonObject()
               arrayData = new JsonArray()
               childData = new JsonObject()
               .
        
        svcJson:Add('openapi':u,    string(OPEN_API_VERSION)).      //REQUIRED. This string MUST be the semantic version number of the OpenAPI Specification version that the OpenAPI document uses. The openapi field SHOULD be used by tooling specifications and clients to interpret the OpenAPI document. This is not related to the API info.version string.
        svcJson:Add('info':u,       WriteInfo()).
        svcJson:Add('servers':u,    WriteDefaultServers()).         //An array of Server Objects, which provide connectivity information to a target server. If the servers property is not provided, or is an empty array, the default value would be a Server Object with a url value of /.
        svcJson:Add('paths':u,      new JsonObject()).              //REQUIRED. The available paths and operations for the API.
        
        assign childData = new JsonObject().
        svcJson:Add('components':u,    childData).              //An element to hold various schemas for the specification.
            childData:Add('schemas':u, WriteDefaultSchemas()). 
            childData:AddNull('securitySchemes':u).
        
        svcJson:Add('security':u,      new JsonArray()).   //A declaration of which security mechanisms can be used across the API. The list of values includes alternative security requirement objects that can be used. Only one of the security requirement objects need to be satisfied to authorize a request. Individual operations can override this definition.
        svcJson:Add('tags':u,          new JsonArray()).   //A list of tags used by the specification with additional metadata. The order of the tags can be used to reflect on their order by the parsing tools. Not all tags that are used by the Operation Object must be declared. The tags that are not declared MAY be organized randomly or based on the tools' logic. Each tag name in the list MUST be unique.
        svcJson:AddNull('externalDocs':u).                 //Additional external documentation.                              
        
        return svcJson.
    end method.
    
    method protected JsonObject WriteDefaultSchemas():
        define variable schemas as JsonObject no-undo.
        define variable schemaData as JsonObject no-undo.
        
        assign schemas    = new JsonObject()
               //schemaData = new JsonObject()
               .
        //schemas:Add('dataServiceCatalog':u, schemaData).
            // Requires a cdo.json to be deployed 'next to' this openapi.json document
            //schemaData:Add('$ref':u, 'cdo.json#/components/schemas/dataServiceCatalog').
        
        return schemas.
    end method.
    
    method protected JsonObject GetPathJson(input pService as DataObjectService,
                                            input pUri as character,
                                            input pMethod as MethodEnum):
        define variable pathJson as JsonObject no-undo.
        define variable uriJson as JsonObject no-undo.
        define variable childData as JsonObject no-undo.
        define variable path as character no-undo.
        define variable svcName as character no-undo.
        define variable operationJson as JsonObject no-undo.
        
        assign svcName = pService:Name.
        if svcName eq DataObjectService:ROOT_SERVICE_NAME then
            assign svcName = DataObjectService:ROOT_SERVICE_URI.
        
        assign pathJson = cast(this-object:Value, JsonObject):GetJsonObject('paths':u)
               path     = left-trim(svcName + '/':u + left-trim(pURI, '/':u), '/':u)
               path     = '/':u + path
               .
        if pathJson:Has(path) then
            assign uriJson = pathJson:GetJsonObject(path).
        else
        do:
            assign uriJson = new JsonObject().
            pathJson:Add(path, uriJson).
        end. 
        
        if uriJson:Has(lc(string(pMethod))) then
            assign operationJson = uriJson:GetJsonObject(lc(string(pMethod))).
        else
        do:
            assign operationJson = new JsonObject().
            uriJson:Add(lc(string(pMethod)), operationJson).
            
            operationJson:Add('tags':u,          new JsonArray()).
            operationJson:Add('summary':u,       '':u).
            operationJson:Add('description':u,   '':u).
            operationJson:Add('operationId':u,   '':u).
            operationJson:Add('parameters':u,    new JsonArray()).
            operationJson:Add('responses':u,     new JsonObject()).
            operationJson:Add('security':u,      new JsonArray()).
        end.
        
        return operationJson.
    end method.
    
    method protected JsonObject WriteHeaders(input pData as MappedOperation):
        define variable jsonHeaders as JsonObject no-undo.
        define variable hdrData as JsonObject no-undo.
        define variable headers as HttpHeader extent no-undo.
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        
        assign cnt = pData:Headers:GetAll(headers).
        if cnt eq 0 then
            return jsonHeaders.
        
        assign jsonHeaders = new JsonObject()
               hdrData     = new JsonObject()
               .
        hdrData:Add('description':u, '':u).
        hdrData:Add('type':u,        'string':u).
        
        do loop = 1 to cnt:
            jsonHeaders:Add(headers[loop]:Name, hdrData).
        end.
        
        return jsonHeaders.
    end method.
    
    method override protected void WriteOperation(input pService as DataObjectService,
                                                  input pData as MappedOperation ):
        define variable operJson as JsonObject no-undo.
        define variable jsonData as JsonObject no-undo.
        define variable childObj as JsonObject no-undo.
        define variable contentJson as JsonObject no-undo.
        define variable schemaJson as JsonObject no-undo.
        define variable schemaChild as JsonObject no-undo.
        define variable arrayData as JsonArray no-undo.
        define variable iter as IIterator no-undo.
        define variable opParam as OperationParameter no-undo.
        define variable paramJson as JsonArray no-undo.
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        define variable inputElem as MessageElement extent no-undo.
        define variable operSchema as handle no-undo.
        define variable fldType as character no-undo.
        define variable fldFormat as character no-undo.
        
        assign operJson = GetPathJson(pService, pData:ServiceURI, pData:Method).
        
        operJson:Set('summary':u, pData:Name).
        case pData:TargetType:
            when string(TargetTypeEnum:File) then
                operJson:Set('operationId':u, substitute('&2:&1':u, entry(num-entries(pData:TargetName, '/':u), pData:TargetName, '/':u), pData:TargetType)).
            when string(TargetTypeEnum:Procedure) then
                operJson:Set('operationId':u, substitute('&3:&1+&2':u, entry(num-entries(pData:TargetName, '/':u), pData:TargetName, '/':u), pData:TargetFunction, pData:TargetType)).
            otherwise
                operJson:Set('operationId':u, substitute('&3:&1+&2':u, pData:TargetName, pData:TargetFunction, pData:TargetType)).
        end case.
        
        operJson:GetJsonArray('tags':u):Add(pService:Name).
        
        //responses
        assign childObj    = new JsonObject()
               jsonData    = new JsonObject()
               schemaJson  = new JsonObject()
               contentJson = new JsonObject()
               .
        operJson:GetJsonObject('responses':u):Add(string(pData:StatusCode, '999':u), childObj).
        childObj:Add('description':u, substitute('&1 &2 operation for service &3 v&4':u,
                                            string(pData:Method), pData:ServiceURI, pService:Name, string(pService:Version))).
        if pData:Name eq 'dataservice.catalog' then
        do:
            childObj:Add('content':u,   jsonData).
                jsonData:Add(pData:ContentType, contentJson).
                    contentJson:Add('schema':u, schemaJson).
                // Requires a cdo.json to be deployed 'next to' this openapi.json document
                schemaJson:Add('$ref':u, 'cdo.json#/components/schemas/dataServiceCatalog').
        end.
        else
            schemaJson:Add('type':u,   'object':u).
        
        // if we use the return value, write that
        if valid-object(pData:ReturnValue) then 
            assign cnt = extent(pData:ReturnValue:OutputElement).
        
        do loop = 1 to cnt:
            assign jsonData = operJson:GetJsonObject('responses':u):GetJsonObject(string(pData:StatusCode, '999':u)).
            case pData:ReturnValue:OutputElement[loop]:ElementType:
                when ElementTypeEnum:Field then
                do:
                    if not jsonData:Has('content':u) then
                    do:
                        assign childObj    = new JsonObject()
                               contentJson = new JsonObject()
                               schemaJson  = new JsonObject()
                               .
                        jsonData:Add('content':u,   childObj).
                            childObj:Add(pData:ContentType, contentJson).
                                contentJson:Add('schema':u, schemaJson).
                                    schemaJson:Add('type':u, 'object':u).
                                    schemaJson:Add('description':u, 'FIELD mapping').
                    end.
                end.
                
                when ElementTypeEnum:Body then
                do:
                    assign childObj    = new JsonObject()
                           contentJson = new JsonObject()
                           schemaJson  = new JsonObject()
                           .
                    jsonData:Add('content':u,   childObj).
                        childObj:Add(pData:ContentType, contentJson).
                            contentJson:Add('schema':u, schemaJson).
                    // for per-operation schemas, use inline; for service schemas, use a reference
                    assign operSchema = pData:GetSchema(pData:ReturnValue:ABLName).
                    if valid-handle(operSchema) then
                    do:
                        assign schemaChild = new JsonObject().
                        
                        schemaJson:Add('type':u, 'object':u).
                        schemaJson:Add('additionalProperties':u, false).
                        schemaJson:Add('properties', schemaChild).
                        
                        case operSchema:type:
                            when 'dataset':u then
                                schemaChild:Add(operSchema:serialize-name, WriteDataset(operSchema)).
                            when 'buffer':u then
                                schemaChild:Add(operSchema:serialize-name, WriteTable(operSchema)).
                            when 'table':u then
                                schemaChild:Add(operSchema:serialize-name, WriteTable(operSchema:default-buffer-handle)).
                        end case.
                    end.
                    else
                        assign operSchema = pService:GetSchema(pData:ReturnValue:ABLName).
                    
                    if valid-handle(operSchema) then
                        schemaJson:Add('$ref':u, '#/components/schemas/':u + operSchema:serialize-name).
                    else
                        schemaJson:Add('type':u, 'object':u).
                end.
                otherwise
                    next.
            end case.
        end.        //output
        
        if pData:Headers:Size gt 0 then
            childObj:Add('headers':u, WriteHeaders(pData)).
        
        //parameters
        assign iter      = pData:Parameters:Iterator()
               paramJson = operJson:GetJsonArray('parameters':u)
               .
        do while iter:HasNext():
            assign opParam  = cast(iter:Next(), OperationParameter).
            
            // we only care about inputs here
            assign cnt = extent(opParam:InputElement).
            do loop = 1 to cnt:  
                // REQUIRED. The location of the parameter. Possible values are "query", "header", "path" or "cookie".
                case opParam:InputElement[loop]:ElementType:
                    when ElementTypeEnum:Query  or
                    when ElementTypeEnum:Header or
                    when ElementTypeEnum:Cookie or
                    when ElementTypeEnum:Path then
                    do:
                        assign childObj   = new JsonObject()
                               schemaJson = new JsonObject()
                               fldType    = FieldInfo(opParam:ABLType, output fldFormat)
                               .
                        paramJson:Add(childObj).
                            childObj:Add('in':u,        lc(string(opParam:InputElement[loop]:ElementType))).
                            childObj:Add('name':u,      opParam:InputElement[loop]:ElementName).
                            childObj:Add('required':u,  (opParam:InputElement[loop]:ElementType eq ElementTypeEnum:Path)).
                            childObj:Add('schema':u, schemaJson).
                                schemaJson:Add('type':u,   fldType).
                                schemaJson:Add('format':u, fldFormat).
                                schemaJson:Add('description':u, caps(string(opParam:InputElement[loop]:ElementType)) + ' mapping').
                    end.
                    
                    when ElementTypeEnum:Field then
                    do:
                        if not operJson:Has('requestBody':u) then
                        do:
                            assign childObj    = new JsonObject()
                                   jsonData    = new JsonObject()
                                   contentJson = new JsonObject()
                                   schemaJson  = new JsonObject()
                                   .
                            operJson:Add('requestBody':u, childObj).
                                childObj:Add('description':u, opParam:ABLType).
                                childObj:Add('content':u,   jsonData).
                                    jsonData:Add(pData:ContentType, contentJson).
                                        contentJson:Add('schema':u, schemaJson).
                                            schemaJson:Add('type':u, 'object':u).
                                            schemaJson:Add('description':u, 'FIELD mapping').
                        end.
                    end.
                    
                    when ElementTypeEnum:Body then
                    do:
                        assign childObj    = new JsonObject()
                               jsonData    = new JsonObject()
                               contentJson = new JsonObject()
                               schemaJson  = new JsonObject()
                               .
                        operJson:Add('requestBody':u, childObj).
                            childObj:Add('description':u, opParam:ABLType).
                            childObj:Add('content':u,   jsonData).
                                jsonData:Add(pData:ContentType, contentJson).
                                    contentJson:Add('schema':u, schemaJson).
                        // for per-operation schemas, use inline; for service schemas, use a reference
                        assign operSchema  = pData:GetSchema(opParam:ABLName).
                        if valid-handle(operSchema) then
                        do:
                            assign schemaChild = new JsonObject().
                            schemaJson:Add('type':u, 'object':u).
                            schemaJson:Add('description':u, 'BODY mapping').
                            schemaJson:Add('additionalProperties':u, false).
                            schemaJson:Add('properties', schemaChild).
                            /*
                                "type": "object",
                                "additionalProperties": false,
                                "properties": {"dsEmployee": {
                            */
                            case operSchema:type:
                                when 'dataset':u then
                                    schemaChild:Add(operSchema:serialize-name, WriteDataset(operSchema)).
                                when 'buffer':u then
                                    schemaChild:Add(operSchema:serialize-name, WriteTable(operSchema)).
                                when 'table':u then
                                    schemaChild:Add(operSchema:serialize-name, WriteTable(operSchema:default-buffer-handle)).
                            end case.
                        end.
                        else
                            assign operSchema = pService:GetSchema(opParam:ABLName).
                        
                        if valid-handle(operSchema) then
                        do:
                            //WriteSchema(pService, operSchema).
                            schemaJson:Add('$ref':u, '#/components/schemas/':u + operSchema:serialize-name).
                        end.
                        else
                            schemaJson:Add('type':u, 'object':u).
                    end.
                    
                    otherwise
                        next.
                end case.
            end.    // input loop
            
            // now outputs
            assign cnt = extent(opParam:OutputElement).
            do loop = 1 to cnt:  
                assign jsonData = operJson:GetJsonObject('responses':u):GetJsonObject(string(pData:StatusCode, '999':u)).
                case opParam:OutputElement[loop]:ElementType:
                    when ElementTypeEnum:Field then
                    do:
                        if not jsonData:Has('content':u) then
                        do:
                            assign childObj    = new JsonObject()
                                   contentJson = new JsonObject()
                                   schemaJson  = new JsonObject()
                                   .
                            jsonData:Add('content':u,   childObj).
                                childObj:Add(pData:ContentType, contentJson).
                                    contentJson:Add('schema':u, schemaJson).
                                        schemaJson:Add('type':u, 'object':u).
                                        schemaJson:Add('description':u, 'FIELD mapping').
                        end.
                    end.
                    
                    when ElementTypeEnum:Body then
                    do:
                        assign childObj    = new JsonObject()
                               contentJson = new JsonObject()
                               schemaJson  = new JsonObject()
                               .
                        if not jsonData:Has('content':U) then
                        do:
                            jsonData:Add('content':u,   childObj).
                                    childObj:Add(pData:ContentType, contentJson).
                                        contentJson:Add('schema':u, schemaJson).
                        end.
                        else
                            assign schemaJson = jsonData:GetJsonObject('content':u)
                                                            :GetJsonObject(pData:ContentType)
                                                                :GetJsonObject('schema':u).
                         
                        // for per-operation schemas, use inline; for service schemas, use a reference
                        assign operSchema = pData:GetSchema(opParam:ABLName).
                        if valid-handle(operSchema) then
                        do:
                            assign schemaChild = new JsonObject().
                            schemaJson:Add('type':u, 'object':u).
                            schemaJson:Add('description':u, 'BODY mapping').
                            schemaJson:Add('additionalProperties':u, false).
                            schemaJson:Add('properties', schemaChild).
                            /*
                                "type": "object",
                                "additionalProperties": false,
                                "properties": {"dsEmployee": {
                            */
                            case operSchema:type:
                                when 'dataset':u then
                                    schemaChild:Add(operSchema:serialize-name, WriteDataset(operSchema)).
                                when 'buffer':u then
                                    schemaChild:Add(operSchema:serialize-name, WriteTable(operSchema)).
                                when 'table':u then
                                    schemaChild:Add(operSchema:serialize-name, WriteTable(operSchema:default-buffer-handle)).
                            end case.
                        end.
                        else
                            assign operSchema = pService:GetSchema(opParam:ABLName).
                        if valid-handle(operSchema) then
                        do:
                            //WriteSchema(pService, operSchema).
                            schemaJson:Add('$ref':u, '#/components/schemas/':u + operSchema:serialize-name).
                        end.
                        else
                            schemaJson:Add('type':u, 'object':u).
                    end.
                    
                    otherwise
                        next.
                end case.
            end.        //output
        end.
    end method.
    
    method protected JsonObject WriteDataset(input pDataset as handle):
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        define variable childData as JsonObject no-undo.
        define variable datasetJson as JsonObject no-undo.
        define variable bufferHdl as handle no-undo.
        define variable propsJson as JsonObject no-undo.
        
        if not valid-handle(pDataset) then
            return datasetJson.
        
        assign datasetJson = new JsonObject()
               propsJson   = new JsonObject()
               childData   = new JsonObject()
               cnt         = pDataset:num-buffers
               .
        datasetJson:Add('type':u, 'object':u).
        datasetJson:Add('additionalProperties':u, false).
        datasetJson:Add('properties':u, propsJson).
            propsJson:Add(pDataset:serialize-name, childData).
                childData:Add('type':u, 'object':u).
                childData:Add('additionalProperties':u, false).
                
        assign propsJson = new JsonObject().
                childData:Add('properties':u, propsJson).
        
        do loop = 1 to cnt:
            assign bufferHdl = pDataset:get-buffer-handle(loop).
            propsJson:Add(bufferHdl:serialize-name, WriteTable(bufferHdl)).
        end.
        
        return datasetJson.
    end method.
    
    method protected JsonObject WriteTable(input pTable as handle):
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        define variable idx as integer no-undo.
        define variable tableJson as JsonObject no-undo.
        define variable fldJson as JsonObject no-undo.
        define variable itemsJson as JsonObject no-undo.
        define variable childObj as JsonObject no-undo.
        define variable bufferFld as handle no-undo.
        define variable fldFormat as character no-undo.
        define variable fldType as character no-undo.
        define variable propsJson as JsonObject no-undo.
        define variable uniqueFld as character no-undo.
        define variable idxInfo as character no-undo.
        define variable delim as character no-undo.
        
        if not valid-handle(pTable) then
            return tableJson.
        
        // determine required fields -> those that are in a unique index
        assign idx    = 1
               idxInfo = pTable:index-information(idx)
               .
        do while not idxInfo eq ?:
            if entry(2, idxInfo) eq '1':u then
            do:
                // index fields
                assign cnt = num-entries(idxInfo).
                do loop = 5 to cnt by 2:
                    if entry(loop, idxInfo) eq '':u then
                        next.
                    assign uniqueFld = uniqueFld + delim + entry(loop, idxInfo)
                           delim     = ',':u
                           .
                end.
            end.
            
            assign idx    = idx + 1
                   idxInfo = pTable:index-information(idx)
                   .
        end.
        
        assign tableJson = new JsonObject()
               itemsJson = new JsonObject()
               propsJson = new JsonObject()
               cnt       = pTable:num-fields
               .
        tableJson:Add('type':u, 'array':u).
        tableJson:Add('items':u, itemsJson).
            itemsJson:Add('additionalProperties':u, false).
            itemsJson:Add('properties':u, propsJson).
        
        do loop = 1 to cnt:
            assign bufferFld = pTable:buffer-field(loop).
            
            // not visible to the outside world
            if bufferFld:serialize-hidden then
                next.
                
            /* Create the new field object. */
            assign fldJson= new JsonObject().
            propsJson:Add(bufferFld:serialize-name, fldJson).
            
            assign fldType = FieldInfo(bufferFld:data-type,
                                       output fldFormat).
            
            if bufferFld:extent gt 0 then 
            do:
                fldJson:Add('type':u, 'array':u).
                fldJson:Add('title':u, bufferFld:label).
                fldJson:Add('maxItems':u, bufferFld:extent).
                assign childObj = new JsonObject().
                fldJson:Add('items':u, childObj).
                    childObj:Add('type':u, fldType).
                    childObj:Add('nullable':u, true).
                    if lookup(bufferFld:name, uniqueFld) gt 0 then
                        childObj:Add('required':u, true).
                    
                    if not fldFormat eq '':u then
                        childObj:Add('format':u, fldFormat ).
                    
                    WriteDefaultFieldValue(bufferFld, childObj).
            end. /* Extent */
            else
            do:
                fldJson:Add('title':u, bufferFld:label).
                fldJson:Add('type':u,  fldType).
                fldJson:Add('nullable':u, true).
                if lookup(bufferFld:name, uniqueFld) gt 0 then
                    fldJson:Add('required':u, true).
                if not fldFormat eq '':u then
                    fldJson:Add('format':u, fldFormat ).
                
                WriteDefaultFieldValue(bufferFld, fldJson). 
            end. /* Normal */
            delete object bufferFld.
        end. /* num-fields */
        
        return tableJson.
    end method.
    
    /* Writes the correctly-typed default value for a field
       
       @param handle A valid buffer-field handle
       @param JsonObject A valid JSON object representing the field */
    method protected void WriteDefaultFieldValue(input pField as handle,
                                                 input pJson as JsonObject):
        if not valid-handle(pField)
           or not valid-object(pJson)
        then
            return.
        
        if pField:default-value eq ? then
            pJson:AddNull('default':u).
        else
        case pField:data-type:
            when 'date':u then
                //date-fullyear "-" date-month "-" date-mday
                pJson:Add('default':u, substitute('&1-&2-&3':u,
                                    string(year(pField:default-value), '9999':u),
                                    string(month(pField:default-value), '99':u),
                                    string(day(pField:default-value), '99':u))).
                
            when 'datetime':u or
            when 'datetime-tz':u then
                pJson:Add('default':u, iso-date(pField:default-value)).
            
            when 'integer':u or
            when 'int64':u then
                pJson:Add('default':u, int64(pField:default-value)).
            
            when 'decimal':u then
                pJson:Add('default':u, decimal(pField:default-value)).
            
            when 'logical':u then
                pJson:Add('default':u, logical(pField:default-value)).
            
            when 'blob':u or
            when 'raw':u then
                pJson:AddNull('default':u).
            
            otherwise
                pJson:Add('default':u, string(pField:default-value)).
        end case.
    end method.
    
    method protected character FieldInfo (input  pAblType as character,
                                          output pFormat as character):
        define variable fldType as character no-undo.
        
        case pAblType:
            when 'date':u then
                assign fldType = 'string':u
                       pFormat = 'date':u
                       .
            when 'datetime':u or
            when 'datetime-tz':u then
                assign fldType = 'string':u
                       pFormat = 'date-time':u
                       . 
            when 'character':u or
            when 'clob':u or
            when 'longchar' then
                assign fldType = 'string':u
                       pFormat = '':u
                       . 
            when 'integer':u then
                assign fldType = 'integer':u
                       pFormat = 'int32':u
                       . 
            when 'int64':u then
                assign fldType = 'integer':u
                       pFormat = 'int64':u
                       . 
            when 'decimal':u then
                assign fldType = 'number':u
                       pFormat = '':u
                       . 
            when 'logical':u then
                assign fldType = 'boolean':u
                       pFormat = '':u
                       . 
            when 'blob':u or
            when 'raw':u then
                assign fldType = 'string':u
                       pFormat = 'binary':u
                       .
            otherwise
                assign fldType = 'string':u
                       pFormat = '':u
                       . 
        end case.
        
        return fldType.
    end method.
    
    method override protected void WriteSchema(input pService as DataObjectService,
                                               input pData as handle ):
        define variable schemaRoot as JsonObject no-undo.
        define variable schemaData as JsonObject no-undo.
        
        if not valid-handle(pData) then
            return.
        
        assign schemaRoot = cast(this-object:Value, JsonObject)
                                :GetJsonObject('components':u)
                                :GetJsonObject('schemas':u).
        
        case pData:type:
            when 'dataset':u then
                assign schemaData = WriteDataset(pData).
            when 'buffer':u then
                assign schemaData = WriteTable(pData).
            when 'table':u then
                assign schemaData = WriteTable(pData:default-buffer-handle).
        end case.
        
        if not valid-object(schemaData) then
            return.
        
        if schemaRoot:Has(pData:serialize-name) then
            schemaRoot:Set(pData:serialize-name, schemaData).
        else
            schemaRoot:Add(pData:serialize-name, schemaData).
    end method.
    
    method protected void WriteTag(input pName as character,
                                   input pDescription as character,
                                   input pExtDoc as JsonObject):
        define variable tagArray as JsonArray no-undo.
        define variable tagData as JsonObject no-undo.
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        define variable tagExists as logical no-undo.
        
        assign tagArray  = cast(this-object:Value, JsonObject):GetJsonArray('tags':u)
               cnt       = tagArray:Length
               tagExists = no 
               .
        do loop = 1 to cnt while not tagExists:
            assign tagData   = tagArray:GetJsonObject(loop)
                   tagExists = tagData:GetCharacter('name':u) eq pName
                   .
        end.
        
        if tagExists then
        do:
            tagData:Set('description':u, pDescription).
            tagData:Set('externalDocs':u, pExtDoc).
        end.
        else
        do:
            assign tagData = new JsonObject().
            tagArray:Add(tagData).
                tagData:Add('name':u, pName).
                tagData:Add('description':u, pDescription).
                tagData:Add('externalDocs':u, pExtDoc).
        end.
    end method.
    
    method override protected void WriteService(input pData as DataObjectService):
        if not valid-object(pData) then
            return.
        
        WriteTag(pData:Name, 
                 substitute('Service for &1 v&2',
                                trim(pData:Name, '/':u), string(pData:Version)),
                 ?).
    end method.
    
    /* Writes a URI to the output 
       
       @param URI The URI to write */
    method override protected void WriteURI(input pData as URI):
        define variable servers as JsonArray no-undo.
        define variable svr as JsonObject no-undo.
        
        if not valid-object(pData) then
            return.
        
        assign servers = cast(this-object:Value, JsonObject):GetJsonArray('servers':u)
               svr     = new JsonObject()
               .
        servers:Add(svr).
        svr:Add('url':u, pData:ToString()).
        svr:Add('description':u, 'Server configuration':u).
    end method.
    
end class.