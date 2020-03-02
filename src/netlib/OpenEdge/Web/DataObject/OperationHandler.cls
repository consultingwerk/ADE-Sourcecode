/* *************************************************************************************************************************
Copyright (c) 2016-2019 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : OperationHandler
    Purpose     : Abstract operation handler class, with helper methods mainly  
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-07-26
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.
 
using Ccs.Common.Support.ICharacterArrayHolder.
using Ccs.Common.Support.IDateArrayHolder.
using Ccs.Common.Support.IDateTimeArrayHolder.
using Ccs.Common.Support.IDateTimeTzArrayHolder.
using Ccs.Common.Support.IDecimalArrayHolder.
using Ccs.Common.Support.IHandleArrayHolder.
using Ccs.Common.Support.IHandleHolder.
using Ccs.Common.Support.IInt64ArrayHolder.
using Ccs.Common.Support.IIntegerArrayHolder.
using Ccs.Common.Support.ILogicalArrayHolder.
using Ccs.Common.Support.ILongcharArrayHolder.
using Ccs.Common.Support.ILongcharHolder.
using Ccs.Common.Support.IMemptrArrayHolder.
using Ccs.Common.Support.IMemptrHolder.
using Ccs.Common.Support.IPrimitiveArrayHolder.
using Ccs.Common.Support.IPrimitiveHolder.
using Ccs.Common.Support.IRowidArrayHolder.
using OpenEdge.Core.Assert.
using OpenEdge.Core.Collections.IList.
using OpenEdge.Core.Collections.IMap.
using OpenEdge.Core.DataTypeEnum.
using OpenEdge.Core.DataTypeHelper.
using OpenEdge.Core.DateArrayHolder.
using OpenEdge.Core.DateHolder.
using OpenEdge.Core.DateTimeAddIntervalEnum.
using OpenEdge.Core.DateTimeArrayHolder.
using OpenEdge.Core.DateTimeHolder.
using OpenEdge.Core.DateTimeTzArrayHolder.
using OpenEdge.Core.DateTimeTzHolder.
using OpenEdge.Core.DecimalArrayHolder.
using OpenEdge.Core.HandleArrayHolder.
using OpenEdge.Core.IOModeEnum.
using OpenEdge.Core.IObjectArrayHolder.
using OpenEdge.Core.IntegerArrayHolder.
using OpenEdge.Core.KeyValuePair.
using OpenEdge.Core.LogicalArrayHolder.
using OpenEdge.Core.LogicalValue.
using OpenEdge.Core.LongcharArrayHolder.
using OpenEdge.Core.MemptrArrayHolder.
using OpenEdge.Core.ObjectArrayHolder.
using OpenEdge.Core.RowidArrayHolder.
using OpenEdge.Core.String.
using OpenEdge.Core.StringConstant.
using OpenEdge.Core.WidgetHandle.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.ISupportLogging.
using OpenEdge.Logging.LogLevelEnum.
using OpenEdge.Logging.Logger.
using OpenEdge.Logging.LoggerBuilder.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using OpenEdge.Net.HTTP.Filter.Writer.EntityWriterBuilder.
using OpenEdge.Net.HTTP.HttpHeader.
using OpenEdge.Net.HTTP.HttpHeaderBuilder.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.MessagePart.
using OpenEdge.Net.MimeTypeHelper.
using OpenEdge.Net.MultipartEntity.
using OpenEdge.Web.DataObject.DataObjectService.
using OpenEdge.Web.DataObject.ElementTypeEnum.
using OpenEdge.Web.DataObject.IOperationHandler.
using OpenEdge.Web.DataObject.MappedOperation.
using OpenEdge.Web.DataObject.MessageElement.
using OpenEdge.Web.DataObject.OperationArgument.
using OpenEdge.Web.DataObject.OperationParameter.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriter.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriterBuilder.
using OpenEdge.Web.DataObject.Writer.ResponseElementWriter.
using OpenEdge.Web.DataObject.Writer.ResponseElementWriterBuilder.
using OpenEdge.Web.IWebRequest.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Json.ObjectModel.JsonDataType.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.Object.
using Progress.Reflect.AccessMode.
using Progress.Reflect.DataType.
using Progress.Reflect.Property.
using OpenEdge.Core.Decimal.
using OpenEdge.Core.Integer.
using OpenEdge.Core.Memptr.

class OpenEdge.Web.DataObject.OperationHandler implements IOperationHandler, ISupportLogging
        abstract: 
    
    /* A reference to the Logger in use by an implementer */
    define public property Logger as ILogWriter no-undo get. set.
    
    /* transient/temp data for a single request execution */
    define static protected temp-table ttArgument no-undo
        field ParentOH as int64
        field ParamIndex as integer
        field Argument as Progress.Lang.Object  //instance of OperationArgument
        index idx1 as primary unique ParentOH ParamIndex. 
    
    /* Default Constructor */
    constructor public OperationHandler():
        assign this-object:Logger = LoggerBuilder:GetLogger(this-object:GetClass()).
    end constructor.
    
    /* Destructor */
    destructor OperationHandler():
        // in case there are any 'lying around'
        ClearArguments().
    end destructor.
    
    /* Clears/empties the arguments after an operation's completion (success or failure) */
    method protected void ClearArguments():
        define variable operArg as OperationArgument no-undo.
        define buffer lbArg for ttArgument.
        
        for each lbArg where lbArg.ParentOH eq int64(this-object):
            assign operArg = cast(lbArg.Argument, OperationArgument).
            if     valid-object(operArg)
               and operArg:Parameter:HasSchema
            then
                SetTrackingChanges(operArg, false).
            
            delete lbArg.
        end.
        
        finally:
            // no leaks
            assign operArg = ?.
        end finally.
    end method.
    
    /* Executes the operation.  
       
       @param IWebRequest The request that resulting in the exception
       @param P.L.Object The message body of the incoming request. Typically 
                         will be transformed from bytes into something useful; may also have an envelope removed. 
       @param IHttpResponse The current response object, if any
       @param DataObjectService The service being operated on
       @param MappedOperation The mapped operation
       @param P.L.Object The business entity (business logic service)  
       @return integer A non-null status code use to deal with errors */
    method abstract public integer Execute(input poRequest as IWebRequest, 
                                           input poMessageBody as Progress.Lang.Object, 
                                           input poResponse as IHttpResponse,
                                           input pService as DataObjectService,
                                           input poOperation as MappedOperation, 
                                           input poBusinessEntity as Progress.Lang.Object ).
    
    /* Creates/inits a temp-table or dataset for used as an argument.
       we pass in the value writer since we may (in some case) write 
       schema once and then write data into that structure.
       
       @param OperationArgument The current argument */
    method protected void InitDataStructure(input poArg as OperationArgument):
        define variable hSchema as handle no-undo.
        define variable oValueWriter as ArgumentValueWriter no-undo.
        
        Assert:NotNull(poArg, 'Operation argument').
        
        // nope
        if not poArg:Parameter:HasSchema then
            return.
        
        // there may be an overridden schema for the operation
        assign hSchema = poArg:Operation:GetSchema(poArg:Parameter:ABLName).
        if not valid-handle(hSchema) then
            assign hSchema = poArg:Service:GetSchema(poArg:Parameter:ABLName).
        
        if not valid-handle(hSchema) then
        do:
            Logger:Warn(substitute('Unable to find schema &2 for service &1; using inferred data schema may result in errors',
                            poArg:Service:Name,
                            poArg:Parameter:ABLName)).
            return.
        end.
        
        assign oValueWriter = ArgumentValueWriterBuilder:Build(poArg)
                                    :Logger(this-object:Logger)
                                    :Writer.
        if not valid-object(oValueWriter) then
        do:
            Logger:Warn(substitute('Cannot convert schema to argument &1',
                            poArg:ArgumentType:TypeName)).
            return.
        end.
        
        oValueWriter:Open().
        
        /* The schema holder may be a dataset or temp-table. If the former, we may only want to
           pass a single table from the dataset, and so need to extract/write that. */
        if    poArg:Parameter:DataType eq 'dataset-handle':u
           or hSchema:type eq string(DataTypeEnum:Temp-Table)
        then
            oValueWriter:Write(hSchema).
        else
        if hSchema:type eq string(DataTypeEnum:Buffer) then
            oValueWriter:Write(hSchema:table-handle).
        else
            oValueWriter:Write(hSchema:get-buffer-handle(poArg:Parameter:ABLName)
                                      :table-handle).
        
        // empties the argument value - we don't want dirty data
        oValueWriter:Clear().
        
        oValueWriter:Close().
        
        // we'll use this schema later 
        assign poArg:ArgumentValue = oValueWriter:Value.
    end method.
    
    /* Extracts temp-table or dataset data from a handle-based structure (which is how
       we work with them in the DOH and friends) into a MEMPTR ... we need to do this 
       in this helper class since the operation decides whether to write BI data or not.
       
       @param OperationArgument The *output or return parameter argument*/
    method protected void ExtractTableData(input poArg as OperationArgument):
        define variable extractTime as datetime extent 2 no-undo.
        define variable mData as memptr no-undo.
        define variable lWriteBI as logical no-undo.
        define variable hData as handle no-undo.
        define variable jsonData as JsonObject no-undo.
        
        Assert:NotNull(poArg, 'Operation arg').
        
        /* if we are working with a dataset or temp-table, write to MEMPTR now. This lets us
           apply the 'writeBI' option if set */
        if    poArg:Parameter:HasSchema
           or poArg:Parameter:DataType eq string(DataTypeEnum:Handle)
        then
        do:
            assign extractTime[1] = now
                   lWriteBI       = poArg:Operation:Options:WriteBI
                   .
            if not poArg:ArgumentType:IsA(get-class(IHandleHolder)) then
                Logger:Warn(substitute('Expecting &1 for &2 ; got &3. Before-image data will not be written',
                                get-class(IHandleHolder):TypeName,
                                poArg:Parameter:DataType,
                                poArg:ArgumentType:TypeName)).
            else
            do:
                assign hData = cast(poArg:ArgumentValue, IHandleHolder):Value.
                // only buffers, tables and datasets have data in them. it's no-op otherwise.
                case hData:type:
                    when string(DataTypeEnum:TempTable) or
                    when string(DataTypeEnum:Buffer) or
                    when string(DataTypeEnum:Dataset) then
                    do on error undo, throw:
                        if     lWriteBI 
                           and not hData:type eq string(DataTypeEnum:Dataset)
                        then
                        do:
                            Logger:Warn(substitute('writeBI:TRUE only supported for datasets, not &1 &2',
                                        hData:type, poArg:Parameter:ABLName)).
                            assign lWriteBI = false.
                        end.
                        
                        Logger:Trace(substitute('Data extracted for &1 &2 with before-image &3',
                                    poArg:Parameter:ABLType,
                                    poArg:Parameter:ABLName,
                                    string(lWriteBI, 'on/off'))).
                        
                        case true:
                            when MimeTypeHelper:IsJson(poArg:Operation:ContentType) then
                            do:
                                assign poArg:ArgumentType  = get-class(JsonObject)
                                       jsonData            = new JsonObject()
                                       poArg:ArgumentValue = jsonData 
                                       .
                                if lWriteBI then
                                    jsonData:Read(hData, ?, lWriteBI).
                                else
                                    jsonData:Read(hData).
                            end.
                            
                            when MimeTypeHelper:IsXML(poArg:Operation:ContentType) then
                                hData:write-xml(string(DataTypeEnum:Memptr), mData, (Logger:LogLevel ge LogLevelEnum:DEBUG), ?, ?, ?, ?, lWriteBI).
                            
                            otherwise
                                Logger:Trace(substitute('Unable to WRITE-* &1 into content-type &2 ',
                                                poArg:Parameter:DataType, poArg:Operation:ContentType)).
                        end case.
                        
                        if get-size(mData) gt 0 then
                            assign poArg:ArgumentType  = get-class(IMemptrHolder)
                                   poArg:ArgumentValue = new OpenEdge.Core.Memptr(mData)
                                   .
                        finally:
                            set-size(mData) = 0.
                        end finally.
                    end.    // buffer/table/dataset
                    otherwise   /* NO-OP */  
                        return.
                end case.
            end.
            
            assign extractTime[2] = now.
            Logger:Trace(substitute('Extracted table data in &1ms',
                                    interval(extractTime[2], extractTime[1], string(DateTimeAddIntervalEnum:Milliseconds)))).
        end.
    end method.
    
    /* Sets the output/return value from the target function into the HTTP response
       
       @param OperationArgument The current argument 
       @param IHttpResponse The response being built    */
    method protected void SetOutputValue(input poArg as OperationArgument,
                                         input pResponse as IHttpResponse):
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        define variable msgElem as MessageElement no-undo.
        define variable elemValue as Progress.Lang.Object no-undo.        
        define variable respElemWriter as ResponseElementWriter no-undo.
        define variable operationTime as datetime-tz extent 2 no-undo.
        define variable elementTime as datetime-tz extent 2 no-undo.
                
        Assert:NotNull(poArg, 'Operation argument').
        Assert:NotNull(pResponse, 'Response').
        
        assign operationTime[1] = now.
        
        if     extent(poArg:Parameter:OutputElement) eq ?
           and poArg:Parameter:IOMode:IsFlagSet(IOModeEnum:Output)
        then
        do:
            Logger:Info(substitute('No output elements found for &4 &5: &1 &2 &3',
                                        poArg:Parameter:ABLName,
                                        poArg:Parameter:ABLType,
                                        poArg:ArgumentType:TypeName,
                                        string(poArg:Operation:Method),
                                        poArg:Operation:ServiceURI      )).
            return.
        end.
        
        // Converts PDS , TT or buffer data from handle form into JsonObject or Memptr representations
        ExtractTableData(poArg).
        
        assign cnt = extent(poArg:Parameter:OutputElement).
        do loop = 1 to cnt:
            assign elementTime[1] = now
                   msgElem        = poArg:Parameter:OutputElement[loop]
                   respElemWriter = ResponseElementWriterBuilder:Build(msgElem:ElementType)
                                        :WriteTo(pResponse)
                                        :Logger(this-object:Logger)
                                        :Writer
                   .
            if not valid-object(respElemWriter) then
            do:
                Logger:Warn(substitute('Unsupported message element type &1 for "&2"',
                                string(msgElem:ElementType), msgElem:ElementName)).
                next.
            end.
            
            assign elemValue      = GetElementValue(msgElem, poArg:ArgumentValue, poArg:ArgumentType)
                   elementTime[2] = now
                   .
            Logger:Trace(substitute('SetOutputValue &4 param=&5; arg=&1; type &2; elem=&3 (time:&6ms)',
                                    string(elemValue),
                                    poArg:ArgumentType:TypeName,
                                    string(msgElem),
                                    loop,
                                    poArg:Parameter:ABLName,
                                    interval(elementTime[2], elementTime[1], string(DateTimeAddIntervalEnum:Milliseconds)))).
            
            respElemWriter:Open().
            respElemWriter:Write(msgElem:ElementName, elemValue).
            respElemWriter:Close().
        end.    /* loop */
        finally:
            assign operationTime[2] = now.
            Logger:Trace(substitute('SetOutputValue() for argument &2 &1 - time(ms)=&3',
                            (if valid-object(poArg) then poArg:Parameter:ABLName else '':u), 
                            (if valid-object(poArg) then poArg:Parameter:ABLType else '':u),
                            interval(operationTime[2], operationTime[1], string(DateTimeAddIntervalEnum:Milliseconds)))).
        end finally.
    end method.
    
    /* Returns a value for a message element from the argvalue
       
       @param MessageElement The message element
       @param Progress.Lang.Object The argument value holder
       @param Progress.Lang.Class  The type of the argument value */
    method protected Progress.Lang.Object GetElementValue(input pMesgElem as MessageElement,
                                                          input pArgValue as Progress.Lang.Object,
                                                          input pArgType as Progress.Lang.Class     ):
        define variable elemValue as Progress.Lang.Object no-undo.
        define variable idx as integer no-undo.
        
        case true:
            when not valid-object(pArgValue) then
                assign elemValue = ?.
            
            // if there's no property/field name, then use the whole argument value
            when String:IsNullOrEmpty(pMesgElem:ABLReference) then
                assign elemValue = pArgValue.
            
            when pArgType:IsA(get-class(IPrimitiveHolder)) then
                 assign elemValue = pArgValue. 
            
            when pArgType:IsA(get-class(IPrimitiveArrayHolder)) or
            when pArgType:IsA(get-class(IObjectArrayHolder))    then
            do:
                assign idx = integer(pMesgElem:ABLReference).
                if    idx eq ? 
                   or idx le 0
                then
                    assign elemValue = pArgValue.
                else
                    assign elemValue = ReadArgumentArray(pArgType, pArgValue, idx).
            end.
            
            when pArgType:IsA(get-class(IList)) then
                assign elemValue = cast(pArgValue, IList):Get(integer(pMesgElem:ABLReference)).
            
            when pArgType:IsA(get-class(IMap)) then
                assign elemValue = cast(pArgValue, IMap):Get(new String(pMesgElem:ABLReference)).
            
            // read property value
            otherwise
                assign elemValue = ReadArgumentProperty(pArgType, pArgValue, pMesgElem:ABLReference).
        end case.
        
        return elemValue.        
    end method.
    
    /* Reads the value of a named field from the MULTIPART/FORM-DATA body.
       
       @param  OperationArgument The current argument being processed
       @param  character The field name to read
       @param  Progress.Lang.Object The message body
       @return Progress.Lang.Object The field value */
    method protected Progress.Lang.Object ReadXmlFieldValue(input pArg as OperationArgument,
                                                            input pFieldName as character,
                                                            input pMessageBody as Object):
        //TODO
        Logger:Warn(substitute('Unsupported MIME type &1 for field mapping', pArg:Operation:ContentType)).
        
        return ?.
    end method.
    
    /* Reads the value of a named field from the MULTIPART/FORM-DATA body.
       
       @param  OperationArgument The current argument being processed
       @param  character The field name to read
       @param  MultipartEntity The message body
       @return Progress.Lang.Object The field value */
    method protected Progress.Lang.Object ReadFormFieldValue(input pArg as OperationArgument,
                                                             input pFieldName as character,
                                                             input pMessageBody as MultipartEntity):
        define variable msgPart as MessagePart no-undo.
        define variable loop as integer no-undo.
        define variable contentDispHds as HttpHeader no-undo.
        
        Assert:NotNull(pArg, 'Operation argument').
        Assert:NotNullOrEmpty(pFieldName, 'Field name').
        Assert:NotNull(pMessageBody, 'Multipart form data').
        
        do loop = 1 to pMessageBody:Size:
            assign msgPart        = pMessageBody:GetPart(loop)
                   contentDispHds = msgPart:Headers:Get('Content-Disposition':u)
                   .
            if trim(contentDispHds:GetParameterValue('name':u), StringConstant:DOUBLE_QUOTE) eq pFieldName then  
                return msgPart:Body.
        end.
    end method.
    
    /* Reads the value of a named field from the JSON-OBJCET body.
       
       @param  OperationArgument The current argument being processed
       @param  character The field name to read
       @param  JsonObject The message body
       @return Progress.Lang.Object The field value */
    method protected Progress.Lang.Object ReadJsonFieldValue(input pArg as OperationArgument,
                                                             input pFieldName as character,
                                                             input pMessageBody as JsonObject ):
        define variable fieldData as Object no-undo.
        
        Assert:NotNull(pArg, 'Operation argument').
        Assert:NotNullOrEmpty(pFieldName, 'Field name').
        Assert:NotNull(pMessageBody, 'JSON data').
        
        if not pMessageBody:Has(pFieldName) then
        do:
            Logger:Warn(substitute('Field "&1" not found in message body', pFieldName)).
            return fieldData.
        end.
        
        case pMessageBody:GetType(pFieldName):
            when JsonDataType:ARRAY then
                assign fieldData = pMessageBody:GetJsonArray(pFieldName).
            
            when JsonDataType:BOOLEAN then
                assign fieldData = new LogicalValue(pMessageBody:GetLogical(pFieldName)).
            
            when JsonDataType:NULL then
                assign fieldData = ?.
            
            when JsonDataType:NUMBER then
            case pArg:Parameter:DataType:
                when 'DECIMAL':u then assign fieldData = new Decimal(pMessageBody:GetDecimal(pFieldName)).
                when 'INTEGER':u then assign fieldData = new Integer(pMessageBody:GetInteger(pFieldName)).
                otherwise             assign fieldData = new Integer(pMessageBody:GetInt64(pFieldName)).
            end case.
            
            when JsonDataType:OBJECT then
                assign fieldData = pMessageBody:GetJsonObject(pFieldName).
            
            when JsonDataType:STRING then
            case pArg:Parameter:DataType:
                when 'DATE':u        then assign fieldData = new DateHolder(pMessageBody:GetDate(pFieldName)).
                when 'DATETIME':u    then assign fieldData = new DateTimeHolder(pMessageBody:GetDatetime(pFieldName)).
                when 'DATETIME-TZ':u then assign fieldData = new DateTimeTzHolder(pMessageBody:GetDatetimeTZ(pFieldName)).
                otherwise                 assign fieldData = new String(pMessageBody:GetLongchar(pFieldName)).
            end case.
        end case.
        
        return fieldData.
    end method.
    
    /* Reads the value (base or or parameter) from a named header
       
       @param MessageElement The message element we are reading from
       @param IWebRequest The request message
       @return character The header value (base or parameter) */
    method protected character ReadHeaderValue(input pMsgElement as MessageElement,
                                               input pRequest as IWebRequest):
        define variable hdrName as character no-undo.
        define variable hdrValue as character no-undo.
        define variable paramName as character no-undo.
        
        Assert:NotNull(pMsgElement, 'Message element').
        Assert:NotNull(pRequest, 'Request').
        
        assign hdrName = entry(1, pMsgElement:ElementName, ';':u).
        if num-entries(pMsgElement:ElementName, ';':u) ge 2 then
            assign paramName = entry(2, pMsgElement:ElementName, ';':u).
        else
            assign paramName = ?.
        
        if not pRequest:HasHeader(hdrName) then
            return ?.
        
        if paramName eq ? then
            assign hdrValue = pRequest:GetHeader(hdrName):Value.
        else
            assign hdrValue = pRequest:GetHeader(hdrName):GetParameterValue(paramName).
        
        return hdrValue.
    end method.
    
    /* Reads the value of a named field from the body.
       
       @param OperationArgument The current argument being processed
       @param MessageElement The message element we are reading from
       @param IWebRequest The request message
       @param Progress.Lang.Object The message body (firld source) 
       @param ArgumentValueWriter The writer used for this field */
    method protected void ReadFieldValue(input poArg as OperationArgument,
                                         input pMsgElement as MessageElement,
                                         input pRequest as IWebRequest,
                                         input poMessageBody as Progress.Lang.Object,
                                         input poValueWriter as ArgumentValueWriter):
        define variable oJsonData as JsonObject no-undo.
        define variable mValue as memptr no-undo.
        define variable cValue as character no-undo.
        define variable lcValue as longchar no-undo.
        define variable dtzValue as datetime-tz no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable kvp as KeyValuePair no-undo.
        define variable fieldValue as Object no-undo.
        
        Assert:NotNull(poArg, 'Operation argument').
        Assert:NotNull(pMsgElement, 'Message element').
        
        if not valid-object(poValueWriter) then
            return.
        
        if not valid-object(poMessageBody) then
            return.
        
        // extract the field value from the HTTP message body
        case true:
            when MimeTypeHelper:IsJson(pRequest:ContentType) then
            do:
                if not type-of(poMessageBody, JsonObject) then
                do:
                    Logger:Warn(substitute('Only JsonObject types supported for Field mapping, not &1',
                                    poMessageBody:GetClass():TypeName)).
                    return.
                end.
                
                // CAST for ease of reading/use
                assign oJsonData = cast(poMessageBody, JsonObject). 
                if not oJsonData:Has(pMsgElement:ElementName) then
                do:
                    Logger:Warn(substitute('Field "&1" not found in message body',
                                    pMsgElement:ElementName)).
                    return.
                end.
                
                assign fieldValue = ReadJsonFieldValue(poArg, pMsgElement:ElementName, oJsonData).
            end.    // JSON
            
            when     MimeTypeHelper:IsMultipart(pRequest:ContentType)
                 and MimeTypeHelper:IsFormEncoded(pRequest:ContentType) 
            then
            do:
                if not type-of(poMessageBody, MultipartEntity) then
                do:
                    Logger:Warn(substitute('Only MultipartEntity types supported for Field mapping, not &1',
                                    poMessageBody:GetClass():TypeName)).
                    return.
                end.
                
                // CAST for ease of reading/use
                assign fieldValue = ReadFormFieldValue(poArg, pMsgElement:ElementName, cast(poMessageBody, MultipartEntity)).
            end.    // MULTIPART/FORM-DATA
            
            when MimeTypeHelper:IsXML(pRequest:ContentType) then
                assign fieldValue = ReadXmlFieldValue(poArg, pMsgElement:ElementName, poMessageBody).
            
            otherwise
                Logger:Warn(substitute('Unsupported MIME type &1 for field mapping', poArg:Operation:ContentType)).
        end case.
        
        // If there are base64-encoded values, transform to MEMPTR, unless the target is JSON, in which case keep as-is 
        if    (   poArg:Parameter:DataType eq 'raw':u 
               or poArg:Parameter:DataType eq 'memptr':u)
           and type-of(fieldValue, ILongcharHolder)
        then 
        do on error undo, throw:
            assign mValue     = base64-decode(cast(fieldValue, ILongcharHolder):Value)
                   fieldValue = new Memptr(mValue)
                   .
            finally:
                set-size(mValue) = 0.
            end finally.
        end.    // b64-encoding
        
        // Write the field value into the appropriate writer
        case true:
            // JSON Object must take name-value pairs.
            when not poArg:Parameter:IsArray
                 and poArg:Parameter:ArgumentType:IsA(get-class(JsonObject))
            then
                if String:IsNullOrEmpty(pMsgElement:ABLReference) then
                    poValueWriter:Write(new KeyValuePair(pMsgElement:ElementName, fieldValue)).
                else
                    poValueWriter:Write(new KeyValuePair(pMsgElement:ABLReference, fieldValue)).
            
            otherwise
                   // primitives don't have properties
                if    poArg:Parameter:IsPrimitive
                   // arrays don't use this KVP 
                   or poArg:Parameter:IsArray
                   // ... and we must have a name 
                   or String:IsNullOrEmpty(pMsgElement:ABLReference)
                then
                    poValueWriter:Write(fieldValue).
                else
                    poValueWriter:Write(new KeyValuePair(pMsgElement:ABLReference, fieldValue)).
        end case.
    end method.
    
    /* Writes a field name/value for the appropriate content type
       
       @param OperationArgument The value, etc for the argument
       @param character The field name element we're working with
       @param Progress.Lang.Object The element value for this field
       @param IHttpResponse The response being written */
    method protected void WriteFieldValue(input poArg as OperationArgument,
                                          input pFieldName as character,
                                          input pFieldValue as Progress.Lang.Object,
                                          input pResponse as IHttpResponse ):
        define variable oPart as MessagePart no-undo.
        define variable writer as MessageWriter no-undo.
        
        // determine the field value; mainly for array values
        assign writer = EntityWriterBuilder:Build(poArg:Operation:ContentType)
                            :Writer.
        if not valid-object(writer) then
        do:
            Logger:Warn(substitute('Cannot determine entity writer for &1', poArg:Operation:ContentType)).
            return.
        end.
        
        // reuse existing entity for the new field (if it has one)
        if valid-object(pResponse:Entity) then
            assign writer:Entity = pResponse:Entity.
        
        writer:Open().
        
        case true:
            when MimeTypeHelper:IsMultipart(poArg:Operation:ContentType) then
            do:
                // stick default content-type
                assign oPart = new MessagePart('text/plain':u, pFieldValue).
                oPart:Headers:Put(HttpHeaderBuilder:Build('Content-Disposition':u)
                                    :Value('form-data':u)
                                    :AddParameter('name':u, pFieldName)
                                    :Header).
                case true:
                    when type-of(poArg:ArgumentValue, JsonConstruct) then assign oPart:ContentType = 'application/json':u.
                    when type-of(poArg:ArgumentValue, IMemptrHolder) then assign oPart:ContentType = 'application/octet-stream':u.
                end case.
                
                writer:Write(oPart).
            end.    /* multipart */
            
            when MimeTypeHelper:IsFormEncoded(poArg:Operation:ContentType) or
            when MimeTypeHelper:IsJson(poArg:Operation:ContentType) then
                writer:Write(new KeyValuePair(pFieldName, pFieldValue)).
            
            otherwise
                Logger:Warn(substitute('Unsupported MIME type &1 for field &2',
                                poArg:Operation:ContentType, pFieldName)).
        end case.
        
        writer:Close().
        
        assign pResponse:Entity = writer:Entity.
    end method.
    
    /* Reads a value from an argument array for a message element 
       
       @param Progress.Lang.Class The argument type 
       @param Progress.Lang.Object The returned argument (will be type-of() the arg type but not necessarily =
       @param integer The index to use
       @return Progress.Lang.Object The object value of the array element */
    method protected Progress.Lang.Object ReadArgumentArray(input pArgType as class Progress.Lang.Class,
                                                            input pValueHolder as class Progress.Lang.Object,
                                                            input pIndex as integer ):
        define variable elemValue as Progress.Lang.Object no-undo.
        // need these variables for figuring out how the size of the Value property 
        define variable cah as ICharacterArrayHolder no-undo.
        define variable dah as IDateArrayHolder no-undo.
        define variable dtah as IDateTimeArrayHolder no-undo.
        define variable dtzah  as IDateTimeTzArrayHolder no-undo.
        define variable decah as IDecimalArrayHolder no-undo.
        define variable hah as IHandleArrayHolder no-undo.
        define variable i64ah as IInt64ArrayHolder no-undo.
        define variable iah as IIntegerArrayHolder no-undo.
        define variable lah as ILogicalArrayHolder no-undo.
        define variable lcah as ILongcharArrayHolder no-undo.
        define variable mah as IMemptrArrayHolder no-undo.
        define variable rah as IRowidArrayHolder no-undo.
        define variable oah as IObjectArrayHolder no-undo.
        
        case true:
            when not valid-object(pValueHolder) then
                return pValueHolder.
            
            when not valid-object(pArgType) then
            do:
                Logger:Warn(substitute('Invalid argument type &1 (cannot determine the array holder type). Returning complete value',
                                    pArgType:TypeName)).
                return pValueHolder.
            end.
            
            when pIndex le 0 then
            do:
                Logger:Warn(substitute('Invalid array index &1 (cannot determine the array holder type). Returning complete value',
                                    pIndex)).
                return pValueHolder.
            end.
            
            when pArgType:IsA(get-class(ICharacterArrayHolder)) then
            do:
                assign cah = cast(pValueHolder, ICharacterArrayHolder).
                if pIndex le extent(cah:Value) then
                    assign elemValue = new String(cah:Value[pIndex]).
            end.    //character array
            when pArgType:IsA(get-class(IDateArrayHolder)) then
            do:
                assign dah = cast(pValueHolder, IDateArrayHolder).
                if pIndex le extent(dah:Value) then
                    assign elemValue = new DateHolder(dah:Value[pIndex]).
            end.
            when pArgType:IsA(get-class(IDateTimeArrayHolder)) then
            do:
                assign dtah = cast(pValueHolder, IDateTimeArrayHolder).
                if pIndex le extent(dtah:Value) then
                    assign elemValue = new DateTimeHolder(dtah:Value[pIndex]).
            end.
            when pArgType:IsA(get-class(IDateTimeTzArrayHolder)) then
            do:
                assign dtzah = cast(pValueHolder, IDateTimeTzArrayHolder).
                if pIndex le extent(dtzah:Value) then
                    assign elemValue = new DateTimeTzHolder(dtzah:Value[pIndex]).
            end.
            when pArgType:IsA(get-class(IDecimalArrayHolder)) then
            do:
                assign decah = cast(pValueHolder, IDecimalArrayHolder).
                if pIndex le extent(decah:Value) then
                    assign elemValue = new Decimal(decah:Value[pIndex]).
            end.
            when pArgType:IsA(get-class(IHandleArrayHolder)) then
            do:
                assign hah = cast(pValueHolder, IHandleArrayHolder).
                if pIndex le extent(hah:Value) then
                    assign elemValue = new WidgetHandle(hah:Value[pIndex]).
            end.
            when pArgType:IsA(get-class(IInt64ArrayHolder)) then
            do:
                assign i64ah = cast(pValueHolder, IInt64ArrayHolder).
                if pIndex le extent(i64ah:Value) then
                    assign elemValue = new Integer(i64ah:Value[pIndex]).
            end.
            when pArgType:IsA(get-class(IIntegerArrayHolder)) then
            do:
                assign iah = cast(pValueHolder, IIntegerArrayHolder).
                if pIndex le extent(iah:Value) then
                    assign elemValue = new Integer(iah:Value[pIndex]).
            end.
            when pArgType:IsA(get-class(ILogicalArrayHolder)) then
            do:
                assign lah = cast(pValueHolder, ILogicalArrayHolder).
                if pIndex le extent(lah:Value) then
                    assign elemValue = new LogicalValue(lah:Value[pIndex]).
            end.
            when pArgType:IsA(get-class(ILongcharArrayHolder)) then
            do:                        
                assign lcah = cast(pValueHolder, ILongcharArrayHolder).
                if pIndex le extent(lcah:Value) then
                    assign elemValue = new String(lcah:Value[pIndex]).
            end.
            when pArgType:IsA(get-class(IMemptrArrayHolder)) then
            do:
                assign mah = cast(pValueHolder, IMemptrArrayHolder).
                if pIndex le extent(mah:Value) then
                    assign elemValue = new Memptr(mah:Value[pIndex]).
            end.
            when pArgType:IsA(get-class(IRowidArrayHolder)) then
            do:
                assign rah = cast(pValueHolder, IRowidArrayHolder).
                if pIndex le extent(rah:Value) then
                    assign elemValue = new String(string(rah:Value[pIndex])).
            end.
            when pArgType:IsA(get-class(IObjectArrayHolder)) then
            do:
                assign oah = cast(pValueHolder, IObjectArrayHolder).
                if pIndex le extent(oah:Value) then
                    assign elemValue = oah:Value[pIndex].
            end.
            otherwise
            do:
                Logger:Warn(substitute('Argument type &1 is not a supported array holder. Returning complete value',
                                    pArgType:TypeName)).
                assign elemValue = pValueHolder.
            end.
        end case.   // individual primitive array types
        
        return elemValue.
    end method.
    
    /* Reads a value from an object argument property (returned by the Business Logic) for a message element 
       
       @param Progress.Lang.Class The argument type 
       @param Progress.Lang.Object The returned argument (will be type-of() the arg type but not necessarily EQ)
       @param character The property name to read
       @return Progress.Lang.Object The object value of the property */
    method protected Progress.Lang.Object ReadArgumentProperty(input pArgType as class Progress.Lang.Class,
                                                               input pArgValue as class Progress.Lang.Object,
                                                               input pPropertyName as character    ):
        define variable elemValue  as Progress.Lang.Object no-undo.
        define variable argProperty as Property no-undo.
        
        if not valid-object(pArgValue)
           or String:IsNullOrEmpty(pPropertyName)
        then
            return pArgValue.
        
        // the property must at least be public and instance
        // the GetProperty() call returns ? and does NOT error (hooray)
        assign argProperty = pArgType:GetProperty(pPropertyName). // Implicit Flags:Public OR Flags:Instance
        if not valid-object(argProperty)
            or not argProperty:CanRead
            or not argProperty:GetterAccessMode eq AccessMode:Public
        then
        do:
            Logger:Warn(substitute('Unable to read field &1 of argument type &2. Using entire entire argument value instead.',
                                pPropertyName, 
                                pArgType:TypeName )).
            return pArgValue.
        end.
        
        // read value and objectify it
        case argProperty:DataType:
            when DataType:Character or
            when DataType:Longchar  then
                if argProperty:Extent eq 0 then
                    assign elemValue = new String(argProperty:Get(pArgValue)).
                else
                    assign elemValue = new LongcharArrayHolder(argProperty:Get(pArgValue)).
            
            when DataType:Date then
                if argProperty:Extent eq 0 then
                    assign elemValue = new DateHolder(argProperty:Get(pArgValue)).
                else
                    assign elemValue = new DateArrayHolder(argProperty:Get(pArgValue)).
            
            when DataType:DateTime then
                if argProperty:Extent eq 0 then
                    assign elemValue = new DateTimeHolder(argProperty:Get(pArgValue)).
                else
                    assign elemValue = new DateTimeArrayHolder(argProperty:Get(pArgValue)).
            
            when DataType:DateTimeTZ then
                if argProperty:Extent eq 0 then
                    assign elemValue = new DateTimeTzHolder(argProperty:Get(pArgValue)).
                else
                    assign elemValue = new DateTimeTzArrayHolder(argProperty:Get(pArgValue)).
            
            when DataType:Decimal then
                if argProperty:Extent eq 0 then
                    assign elemValue = new Decimal(argProperty:Get(pArgValue)).
                else
                    assign elemValue = new DecimalArrayHolder(argProperty:Get(pArgValue)).
            
            when DataType:Handle then
                if argProperty:Extent eq 0 then
                    assign elemValue = new WidgetHandle(argProperty:Get(pArgValue)).
                else
                    assign elemValue = new HandleArrayHolder(argProperty:Get(pArgValue)).
            
            when DataType:Int64   or
            when DataType:Integer then
                if argProperty:Extent eq 0 then
                    assign elemValue = new Integer(argProperty:Get(pArgValue)).
                else
                    assign elemValue = new IntegerArrayHolder(argProperty:Get(pArgValue)).
            
            when DataType:Logical then
                if argProperty:Extent eq 0 then
                    assign elemValue = new LogicalValue(argProperty:Get(pArgValue)).
                else
                    assign elemValue = new LogicalArrayHolder(argProperty:Get(pArgValue)).
            
            when DataType:Memptr or
            when DataType:Raw    then
                if argProperty:Extent eq 0 then
                    assign elemValue = new Memptr(argProperty:Get(pArgValue)).
                else
                    assign elemValue = new MemptrArrayHolder(argProperty:Get(pArgValue)).
            
            when DataType:Rowid then
                if argProperty:Extent eq 0 then
                    assign elemValue = new String(string(argProperty:Get(pArgValue))).
                else
                    assign elemValue = new RowidArrayHolder(argProperty:Get(pArgValue)).
            
            when DataType:Object then
                if argProperty:Extent eq 0 then
                    assign elemValue = argProperty:Get(pArgValue).
                else
                    assign elemValue = new ObjectArrayHolder(argProperty:Get(pArgValue)).
            
            otherwise
            do:
                Logger:Warn(substitute('Unable to read field "&1" of data type &2. Using entire entire argument value instead.',
                                pPropertyName,
                                argProperty:DataType:ToString() )).
                assign elemValue = pArgValue.
            end.
        end case.
        
        return elemValue.
    end method.
    
    /** Extract input values from the HTTP request and set against the argument.
        
        @param OperationArgument The current argument
        @param Object The incoming message body
        @param IWebRequest The incoming request */
    method protected void GetInputValue(input poArg as OperationArgument,
                                        input poMessageBody as Progress.Lang.Object,
                                        input pRequest as IWebRequest):
        define variable iLoop as integer no-undo.
        define variable numInputElems as integer no-undo.
        define variable valueWriter as ArgumentValueWriter no-undo.
        define variable headers as HttpHeader extent no-undo.
        define variable hSchema as handle no-undo.
        define variable msgElem as MessageElement no-undo.
        define variable writeProperty as logical no-undo.
        define variable operationTime as datetime-tz extent 2 no-undo.
        
        Assert:NotNull(poArg, 'Operation argument').
        Assert:NotNull(pRequest, 'HTTP Request').
        
        assign operationTime[1] = now
               numInputElems    = extent(poArg:Parameter:InputElement)
               .
        if     numInputElems eq ?
           and poArg:Parameter:IOMode:IsFlagSet(IOModeEnum:Input)
        then
        do:
            Logger:Info(substitute('No input elements found for &4 &5: &1 &2 &3',
                                        poArg:Parameter:ABLName,
                                        poArg:Parameter:ABLType,
                                        poArg:ArgumentType:TypeName,
                                        string(poArg:Operation:Method),
                                        poArg:Operation:ServiceURI      )).
            return.
        end.
        
        // Since this is a single ABL parameter, all the input elements are written into that single value
        assign valueWriter = ArgumentValueWriterBuilder:Build(poArg)
                                    :Logger(this-object:Logger)
                                    :Writer.
        if not valid-object(valueWriter) then
        do:
            Logger:Warn(substitute('Cannot convert input parameter &2 of type &3 to argument &1',
                                    poArg:ArgumentType:TypeName,
                                    poArg:Parameter:ABLName,
                                    poArg:Parameter:ABLType     )).
            return.
        end.
        
        Logger:Trace(substitute('GetInputValue ValueWriter is &1 for &2',
                                valueWriter:GetClass():TypeName,
                                valueWriter:ArgumentType:TypeName)).
        
        /* Open/init the value writer */
        valueWriter:Open().
        
        do iLoop = 1 to numInputElems:
            assign msgElem       = poArg:Parameter:InputElement[iLoop]
                   // For Class-based parameters, we can specify the property the value applies to
                   writeProperty = not (   poArg:Parameter:IsPrimitive
                                        or poArg:Parameter:IsArray    )
                                   and not String:IsNullOrEmpty(msgElem:ABLReference)
                   .
            Logger:Trace(substitute('GetInputValue for &1[elem-num:&4] &2 &3',
                                    poArg:Parameter:ABLType,
                                    poArg:ArgumentType:TypeName, 
                                    string(msgElem),
                                    iLoop )).
            if msgElem:ElementType eq ElementTypeEnum:None then
                next.
            
            // Use a schema if we have one
            if     poArg:Parameter:HasSchema
               and valid-object(poArg:ArgumentValue)
            then
                valueWriter:Write(poArg:ArgumentValue).
            
            case msgElem:ElementType:
                when ElementTypeEnum:Path then
                case true:
                    when writeProperty then
                        valueWriter:Write(new KeyValuePair(msgElem:ABLReference, pRequest:GetPathParameter(msgElem:ElementName))).
                    otherwise
                        valueWriter:Write(pRequest:GetPathParameter(msgElem:ElementName)).
                end case.
                
                when ElementTypeEnum:Query then
                    if pRequest:URI:HasQueryName(msgElem:ElementName) then
                    case true:
                        when writeProperty then
                            valueWriter:Write(new KeyValuePair(msgElem:ABLReference, pRequest:URI:GetQueryValue(msgElem:ElementName))).
                        otherwise
                            valueWriter:Write(pRequest:URI:GetQueryValue(msgElem:ElementName)).
                    end case.
                
                when ElementTypeEnum:QueryMap then
                case true:
                    when writeProperty then
                        valueWriter:Write(new KeyValuePair(msgElem:ABLReference, pRequest:URI:GetQueryMap())).
                    otherwise
                        valueWriter:Write(pRequest:URI:GetQueryMap()).
                end case.
                
                when ElementTypeEnum:Header then
                case true:
                    when writeProperty then
                        valueWriter:Write(new KeyValuePair(msgElem:ABLReference, ReadHeaderValue(msgElem, pRequest))).
                    otherwise
                        valueWriter:Write(ReadHeaderValue(msgElem, pRequest)).
                end case.
                
                when ElementTypeEnum:HeaderSet then
                do:
                    pRequest:GetHeaders(output headers).
                    case true:
                        when writeProperty then
                            valueWriter:Write(new KeyValuePair(msgElem:ABLReference, new ObjectArrayHolder(headers))).
                        otherwise
                            valueWriter:Write(headers).
                    end case.
                end.
                
                when ElementTypeEnum:Constant then
                case true:
                    when writeProperty then
                        valueWriter:Write(new KeyValuePair(msgElem:ABLReference, msgElem:ElementName)).
                    otherwise
                        valueWriter:Write(msgElem:ElementName).
                end case.
                
                /* Returns the cookie value only */
                when ElementTypeEnum:Cookie then
                    if pRequest:HasCookie(msgElem:ElementName) then
                    case true:
                        when writeProperty then
                            valueWriter:Write(new KeyValuePair(msgElem:ABLReference, pRequest:GetCookie(msgElem:ElementName):Value)).
                        otherwise
                            valueWriter:Write(pRequest:GetCookie(msgElem:ElementName):Value).
                    end case.
                
                when ElementTypeEnum:Body then
                case true:
                    when writeProperty then
                        valueWriter:Write(new KeyValuePair(msgElem:ABLReference, poMessageBody)).
                    otherwise
                        valueWriter:Write(poMessageBody).
                end case.
                
                when ElementTypeEnum:Field then
                    // this method writes into the value writer
                    ReadFieldValue(poArg, msgElem, pRequest, poMessageBody, valueWriter).
                
                /* cannot convert */
                when ElementTypeEnum:Request then
                case true:
                    when writeProperty then
                        valueWriter:Write(new KeyValuePair(msgElem:ABLReference, pRequest)).
                    otherwise
                        valueWriter:Write(pRequest).
                end case.
                
                when ElementTypeEnum:HttpMethod then
                case true:
                    when writeProperty then
                        valueWriter:Write(new KeyValuePair(msgElem:ABLReference, pRequest:Method)).
                    otherwise
                        valueWriter:Write(pRequest:Method).
                end case.
                
                /* unsupported */
                otherwise
                    Logger:Warn(substitute('Unsupported message element type &1 for input',
                                    string(msgElem:ElementType))).
            end case.   /* message elements */
        end.
        
        /* close and write to OperationArgument */
        valueWriter:Close().
        
        assign poArg:ArgumentValue = valueWriter:Value.
        finally:
            Logger:Trace(substitute('GetInputValue() for argument &2 &1 - time(ms)=&3',
                            (if valid-object(poArg) then poArg:Parameter:ABLName else '':u), 
                            (if valid-object(poArg) then poArg:Parameter:ABLType else '':u),
                            interval(now, operationTime[1], string(DateTimeAddIntervalEnum:Milliseconds)))).
        end finally.
    end method.
    
    /* Sets the value of a dataset's contained buffers' tracking-changes value.
       
       @param OperationArgument The argument containing the dataset
       @param logical TRUE to enable TRACKING-CHANGES */
    method protected void SetTrackingChanges(input poArg as OperationArgument,
                                             input plTrackChanges as logical):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable hBuffer as handle no-undo.
        define variable hDataSet as handle no-undo.
        define variable iBuffer as integer no-undo.
        
        Assert:NotNull(poArg, 'Argument').
        
        if not poArg:Parameter:HasSchema then
            return.
        
        // TRACKING-CHANGES is only supported for tables-in-datasets
        if     not poArg:Parameter:DataType eq 'dataset-handle':u
           and not poArg:Parameter:DataType eq 'table-handle':u
           and not poArg:Parameter:DataType eq 'handle':u
        then
            return.
        
        assign hDataSet = poArg:Operation:GetSchema(poArg:Parameter:ABLName).
        if not valid-handle(hDataset) then
            assign hDataSet = poArg:Service:GetSchema(poArg:Parameter:ABLName).
        
        // double-check in case of lies above
        if not valid-handle(hDataset) then
            return.
        
        Assert:NotUnknown(plTrackChanges, 'Tracking changes').
        
        case hDataSet:type:
            when string(DataTypeEnum:Buffer) or
            when string(DataTypeEnum:Temp-Table) then
            do:
                if hDataSet:type eq string(DataTypeEnum:Buffer) then
                    assign hDataset = hDataset:table-handle.
                
                /* If this temp-table is part of a dataset, then we can set the tracking-changes flag. 
                   Ignore it otherwise. This changed in 11.7.0 because we can set a before-table on any TT now */
                if     valid-handle(hDataSet:before-table)
                   and valid-handle(hDataSet:default-buffer-handle:dataset) 
                   then
                do:
                    assign hDataSet:tracking-changes = plTrackChanges.
                    Logger:Trace(substitute('Tracking changes set to &1 for buffer &2 (table: &3)',
                                    string(plTrackChanges, 'ON/OFF':u),
                                    hDataSet:default-buffer-handle:name,
                                    hDataset:name)).
                end.
            end.    //tt 
            
            when string(DataTypeEnum:Dataset) then
            do:
                assign iMax = hDataset:num-buffers. 
                do iLoop = 1 to iMax:
                    assign hBuffer = hDataset:get-buffer-handle(iLoop).
                    if not valid-handle(hBuffer:table-handle:before-table) then
                        next.
                    
                    assign hBuffer:table-handle:tracking-changes = plTrackChanges.
                    
                    Logger:Trace(substitute('Tracking changes set to &1 for buffer &2 (table: &3)',
                                    string(plTrackChanges, 'ON/OFF':u), 
                                    hBuffer:name,
                                    hBuffer:table-handle:name)).
                end.
            end.    //pds
            
            // not applicable to other handle-based things    
            otherwise
                // no-op; no failure
                return.
        end case. 
    end method.
    
    /* Builds the parameters for execution by an 'entity'
       
       @param IWebRequest The request that resulting in the exception
       @param P.L.Object The message body of the incoming request. Typically 
                         will be transformed from bytes into something useful; may also have an envelope removed. 
       @param IHttpResponse The current response object, if any
       @param MappedOperation The mapped operation  */
    method protected void BuildArguments(input poRequest  as IWebRequest,
                                         input poMessageBody as Progress.Lang.Object,
                                         input poResponse as IHttpResponse,
                                         input pService as DataObjectService,
                                         input poOperation as MappedOperation ):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable oOperArg as OperationArgument no-undo.
        define variable iArgIdx as integer no-undo.
        define variable operationTime as datetime-tz extent 2 no-undo.
        
        define buffer lbArg for ttArgument.
        
        assign operationTime[1] = now.
        
        if valid-object(poOperation:ReturnValue) then
        do:
            create lbArg.
            assign lbArg.ParentOH   = int64(this-object)
                   lbArg.ParamIndex = 0
                   oOperArg         = new OperationArgument(pService,
                                                            poOperation,
                                                            poOperation:ReturnValue)
                   lbArg.Arg        = oOperArg
                   .
        end.
        
        assign iMax = poOperation:Parameters:Size.
        PARAM-LOOP:
        do iLoop = 1 to iMax:
            assign oOperArg = new OperationArgument(pService,
                                                    poOperation,
                                                    cast(poOperation:Parameters:Get(iLoop), OperationParameter)).
            
            // This covers INPUT, OUTPUT and INPUT-OUTPUT
            if    oOperArg:Parameter:IOMode:IsFlagSet(IOModeEnum:Input)
               or oOperArg:Parameter:IOMode:IsFlagSet(IOModeEnum:Output)
            then
            do:
                // hold and store args for later processing
                create lbArg.
                assign lbArg.ParentOH   = int64(this-object)
                       lbArg.Arg        = oOperArg
                       iArgIdx          = iArgIdx + 1
                       lbArg.ParamIndex = iArgIdx. 
            end.
            else
            do:
                Logger:Info(substitute('IoMode &1 not supported for operation target &2',
                                string(oOperArg:Parameter:IOMode),
                                string(poOperation:TargetType))).
                next PARAM-LOOP.
            end.    /* unsupported */
            
            // always create the schema if there is one.
            InitDataStructure(oOperArg).
            
            // sets the primitive or object value on the operation argument
            if oOperArg:Parameter:IOMode:IsFlagSet(IOModeEnum:Input) then
                GetInputValue(oOperArg, poMessageBody, poRequest).
            
            /* Sets the value to true if required. Only do this AFTER we've loaded data
               from the HTTP message since things like READ-JSON do a CREATE tt. under the 
               covers which messes with the ROW-STATE */
            SetTrackingChanges(oOperArg, true).
            
            logger:Trace(substitute('Operation argument: &3 &2 &1 has value: "&5" of type &4',
                            oOperArg:Parameter:ABLName,
                            oOperArg:Parameter:ABLType,
                            oOperArg:Parameter:IOMode:ToString(),
                            oOperArg:ArgumentType:TypeName,
                            oOperArg:ArgumentValue )).
        end.    // PARAM-LOOP
        
        finally:
            Logger:Trace(substitute('BuildArguments() for operation &1 - time(ms)=&2',
                            (if valid-object(poOperation) then string(poOperation) else '':u), 
                            interval(now, operationTime[1], string(DateTimeAddIntervalEnum:Milliseconds)))).
            
        end finally.
    end method.
    
end class.
