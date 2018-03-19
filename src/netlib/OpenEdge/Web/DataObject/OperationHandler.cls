/* *************************************************************************************************************************
Copyright (c) 2016-2017 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : OperationHandler
    Purpose     : Abstract oepration handler class, with helper methods mainly  
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2016-07-26
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.
 
using Ccs.Common.Support.ICharacterHolder.
using Ccs.Common.Support.IDateHolder.
using Ccs.Common.Support.IDateTimeHolder.
using Ccs.Common.Support.IDateTimeTzHolder.
using Ccs.Common.Support.IHandleHolder.
using Ccs.Common.Support.IInt64Holder.
using Ccs.Common.Support.IIntegerHolder.
using Ccs.Common.Support.ILongcharHolder.
using Ccs.Common.Support.IMemptrHolder.
using OpenEdge.Core.Assert.
using OpenEdge.Core.Collections.IStringStringMap.
using OpenEdge.Core.Collections.StringStringMap.
using OpenEdge.Core.DataTypeEnum.
using OpenEdge.Core.DataTypeHelper.
using OpenEdge.Core.IOModeEnum.
using OpenEdge.Core.KeyValuePair.
using OpenEdge.Core.Session.
using OpenEdge.Core.TimeStamp.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.ISupportLogging.
using OpenEdge.Logging.LoggerBuilder.
using OpenEdge.Net.HTTP.Cookie.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using OpenEdge.Net.HTTP.Filter.Writer.EntityWriterBuilder.
using OpenEdge.Net.HTTP.HttpHeader.
using OpenEdge.Net.HTTP.HttpHeaderBuilder.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.HTTP.StatusCodeEnum.
using OpenEdge.Net.MessagePart.
using OpenEdge.Net.MimeTypeHelper.
using OpenEdge.Net.MultipartEntity.
using OpenEdge.Web.DataObject.ElementTypeEnum.
using OpenEdge.Web.DataObject.IOperationHandler.
using OpenEdge.Web.DataObject.MappedOperation.
using OpenEdge.Web.DataObject.OperationArgument.
using OpenEdge.Web.DataObject.OperationParameter.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriter.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriterBuilder.
using OpenEdge.Web.IWebRequest.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Json.ObjectModel.JsonDataType.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.ObjectModelParser.

class OpenEdge.Web.DataObject.OperationHandler implements IOperationHandler, ISupportLogging
      abstract: 
    
    // A reference to the Logger in use by an implementer
    define public property Logger as ILogWriter no-undo get. set.
    
    /* transient/temp data for a single request execution */
    define static protected temp-table ttArgument no-undo
        field ParentOH as int64
        field ParamIndex as integer
        field Argument as Progress.Lang.Object
        index idx1 as primary unique ParentOH ParamIndex. 
    
    // helper property to avoid extraneous def-var's 
    define protected property JsonParser as ObjectModelParser no-undo
        get():
            if not valid-object(this-object:JsonParser) then
                assign this-object:JsonParser = new ObjectModelParser().
            return this-object:JsonParser.
        end get.
        private set.
        
    constructor public OperationHandler():
        assign this-object:Logger = LoggerBuilder:GetLogger(this-object:GetClass()).
    end constructor.
    
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
       @param MappedOperation The mapped operation
       @param P.L.Object The business entity (business logic service)  
       @return integer A non-null status code use to deal with errors */
    method abstract public integer Execute(input poRequest as IWebRequest, 
                                           input poMessageBody as Progress.Lang.Object, 
                                           input poResponse as IHttpResponse,
                                           input poOperation as MappedOperation, 
                                           input poBusinessEntity as Progress.Lang.Object ).
    
    method protected void GetInputValue(input poArg as OperationArgument, 
                                        input piIdx as integer,
                                        input poMessageBody as Progress.Lang.Object):
        define variable oValue as Progress.Lang.Object no-undo.
        define variable oValueWriter as ArgumentValueWriter no-undo.
        define variable oHeader as HttpHeader no-undo.
        define variable oCookie as Cookie no-undo.
        define variable hSchema as handle no-undo.
        
        Assert:NotNull(poArg, 'Operation argument').
        Assert:IsPositive(piIdx, 'Input element index').
        
        Logger:Trace(substitute('GetInputValue for &1 &5 &2 &3 &4',
                                poArg:Parameter:ABLType,
                                poArg:ArgumentType:TypeName,
                                string(poArg:Parameter:InputElementType[piIdx]),
                                string(poArg:Parameter:InputElementName[piIdx]),
                                piIdx )).
        
        assign oValueWriter = ArgumentValueWriterBuilder:Build(poArg)
                                    :Logger(this-object:Logger)
                                    :Writer.
        
        if not valid-object(oValueWriter) then
        do:
            Logger:Warn(substitute('Cannot convert input message element type &2 to argument &1',
                                    poArg:ArgumentType:TypeName,
                                    string(poArg:Parameter:InputElementType[piIdx]))).
            return.
        end.
        
        Logger:Trace(substitute('GetInputValue ValueWriter is &1 for &2',
                                oValueWriter:GetClass():TypeName,
                                oValueWriter:ArgumentType:TypeName)).
        
        oValueWriter:Open().
        
        // Use a schema if we have one
        if poArg:Parameter:HasSchema and valid-object(poArg:ArgumentValue) then
            oValueWriter:Write(poArg:ArgumentValue).
        
        case poArg:Parameter:InputElementType[piIdx]:
            when ElementTypeEnum:None then
                /* simple no-op here */
                .            
            when ElementTypeEnum:Path then
                oValueWriter:Write(poArg:Request:GetPathParameter(poArg:Parameter:InputElementName[piIdx])).
            
            when ElementTypeEnum:Query then
                oValueWriter:Write(poArg:Request:URI:GetQueryValue(poArg:Parameter:InputElementName[piIdx])).
            
            when ElementTypeEnum:Header then
            do:
                if poArg:Request:HasHeader(poArg:Parameter:InputElementName[piIdx]) then
                    oValueWriter:Write(poArg:Request:GetHeader(poArg:Parameter:InputElementName[piIdx]):Value).
            end.
                
            when ElementTypeEnum:Constant then
                oValueWriter:Write(poArg:Parameter:InputElementName[piIdx]).
            
            /* Returns the cookie value only */
            when ElementTypeEnum:Cookie then
            do:
                assign oCookie = poArg:Request:GetCookie(poArg:Parameter:InputElementName[piIdx]).
                if valid-object(oCookie) then
                    oValueWriter:Write(oCookie:Value).
            end.
            
            when ElementTypeEnum:Body then
                oValueWriter:Write(poMessageBody).
            
            when ElementTypeEnum:Field then
                // this method writes into the value writer 
                ReadFieldValue(poArg, piIdx, poMessageBody, oValueWriter).
            
            /* cannot convert */
            when ElementTypeEnum:Request then
                oValueWriter:Write(poArg:Request).

            when ElementTypeEnum:HttpMethod then
                oValueWriter:Write(poArg:Request:Method).            
                
            /* output only */
            when ElementTypeEnum:StatusCode or
            when ElementTypeEnum:StatusReason then
                Logger:Warn(substitute('Invalid (output-only) message element type &1 for input',
                                string(poArg:Parameter:InputElementType[piIdx]))).

            /* unsupported */
            otherwise 
                Logger:Warn(substitute('Unsupported message element type &1 for input',
                                string(poArg:Parameter:InputElementType[piIdx]))).
        end case.   /* message elements */
        
        /* close and write to OperationArgument */        
        oValueWriter:Close().
        
        assign poArg:ArgumentValue = oValueWriter:Value.
    end method. /* GetInputValue */
    
    /* Creates/inits a temp-table or dataset for used as an argument.
       we pass in the value writer since we may (in some case) write 
       schema once and then write data into that structure. 
       
       @param OperationArgument The current argument */    
    method protected void InitDataStructure(input poArg as OperationArgument):
        define variable hSchema as handle no-undo.
        define variable oValueWriter as ArgumentValueWriter no-undo.
        define variable schemaHolder as Progress.Lang.Object no-undo.
        
        Assert:NotNull(poArg, 'Operation argument').
        // nope
        if not poArg:Parameter:HasSchema then
            return.
        
        assign schemaHolder = poArg:Operation:Schemas:Get(poArg:Parameter:ABLName).
        if     valid-object(schemaHolder)
           and type-of(schemaHolder, IHandleHolder) 
           then
            assign hSchema = cast(schemaHolder, IHandleHolder):Value.
        
        if not valid-handle(hSchema) then
        do:
            Logger:Warn(substitute('Unable to find schema &2 for service &1; using inferred data schema may result in errors',
                            poArg:Operation:ServiceName,
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
           or hSchema:type eq 'temp-table':u
           then
            oValueWriter:Write(schemaHolder).
        else
            oValueWriter:Write(hSchema:get-buffer-handle(poArg:Parameter:ABLName)
                                      :table-handle).
        
        // empties the argument value - we dont' want dirty data
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
        define variable mData as memptr no-undo.
        define variable lWriteBI as logical no-undo.
        define variable hData as handle no-undo.
        define variable jsonData as JsonObject no-undo.
        
        Assert:NotNull(poArg, 'Operation arg').
        
        /* if we are working with a dataset or temp-table, write to MEMPTR now. This lets us
           apply the 'writeBI' option if set */
        if poArg:Parameter:DataType eq 'dataset-handle':u or 
           poArg:Parameter:DataType eq 'table-handle':u   or
           poArg:Parameter:DataType eq 'handle':u         then
        do:
            assign lWriteBI =  poArg:Operation:Options:WriteBI.
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
                    when DataTypeHelper:GetMask(DataTypeEnum:TempTable) or
                    when DataTypeHelper:GetMask(DataTypeEnum:Buffer) or
                    when DataTypeHelper:GetMask(DataTypeEnum:Dataset) then
                    do on error undo, throw:
                        if lWriteBI and hData:type ne 'dataset':u then
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
                                hData:write-xml('memptr':u, mData, session:debug-alert, ?, ?, ?, ?, lWriteBI).
                            
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
        end.
    end method.
    
    method protected void SetOutputValue(input poArg as OperationArgument):
        define variable iLoop as integer no-undo.
        define variable oValueWriter as ArgumentValueWriter no-undo.
        
        Assert:NotNull(poArg, 'Operation argument').
        
        if extent(poArg:Parameter:OutputElementType) eq ? then
            Logger:Info(substitute('No output elements defined for argument &1 &2',
                        poArg:ArgumentType,
                        string(poArg:ArgumentValue) )).
        else
        /* order shouldn't matter */
        do iLoop = extent(poArg:Parameter:OutputElementType) to 1 by -1:
            Logger:Trace(substitute('SetOutputValue &5 param=&6; arg=&1; type &2; elem=&3 &4',
                                    string(poArg:ArgumentValue),
                                    poArg:ArgumentType:TypeName,
                                    string(poArg:Parameter:OutputElementType[iLoop]),
                                    string(poArg:Parameter:OutputElementName[iLoop]),
                                    iLoop,
                                    poArg:Parameter:ABLName)).
            
            // Converts PDS , TT or buffer data from handle form into JsonObject or Memptr representations
            ExtractTableData(poArg).
            
            case poArg:Parameter:OutputElementType[iLoop]:
                when ElementTypeEnum:None then
                    return.
                
                when ElementTypeEnum:Header then
                case true:
                    when poArg:ArgumentType:IsA(get-class(ILongcharHolder)) then
                        poArg:Response
                                :SetHeader(HttpHeaderBuilder
                                                :Build(poArg:Parameter:OutputElementName[iLoop])
                                                :Value(string(cast(poArg:ArgumentValue, ILongcharHolder):Value))
                                                :Header).
                    when poArg:ArgumentType:IsA(get-class(HttpHeader)) then
                        poArg:Response
                                :SetHeader(cast(poArg:ArgumentValue, HttpHeader)).
                    
                    otherwise                    
                        Logger:Warn(substitute('Cannot convert argument &1 to message element type &2',
                                        poArg:ArgumentType:TypeName,
                                        string(poArg:Parameter:OutputElementType[iLoop]))).
                end case.    /* header */
                
                when ElementTypeEnum:Cookie then
                do:
                    if poArg:ArgumentType:IsA(get-class(Cookie)) then
                        poArg:Response
                                :SetCookie(cast(poArg:ArgumentValue, Cookie)).
                    else
                        Logger:Warn(substitute('Cannot convert message element type &1 to &2',
                                        poArg:ArgumentType:TypeName,
                                        string(poArg:Parameter:OutputElementType[iLoop]))).
                end.    /* cookie */
                
                when ElementTypeEnum:Body then
                do:
                    if valid-object(poArg:Response:Entity) then
                        Logger:Warn(substitute('Response entity &1 &2 overwritten by &3 &4',
                                        poArg:Response:Entity:GetClass():TypeName,
                                        int64(poArg:Response:Entity),
                                        poArg:Parameter:OutputElementName[iLoop],
                                        poArg:ArgumentType:TypeName )).
                    
                    assign poArg:Response:Entity = poArg:ArgumentValue.
                end.    /* body */
                
                when ElementTypeEnum:StatusCode then
                case true:
                    when type-of(poArg:ArgumentValue, StatusCodeEnum) then
                        assign poArg:Response:StatusCode = int64(cast(poArg:ArgumentValue, StatusCodeEnum)).
                    
                    when type-of(poArg:ArgumentValue, ILongcharHolder) or 
                    when type-of(poArg:ArgumentValue, ICharacterHolder) then
                        assign poArg:Response:StatusCode = integer(StatusCodeEnum:GetEnum(
                                                                    string(cast(poArg:ArgumentValue, ILongcharHolder):Value))).
                    
                    when type-of(poArg:ArgumentValue, IMemptrHolder) then
                    case true:
                        when poArg:ArgumentType:IsA(get-class(StatusCodeEnum)) then
                            assign poArg:Response:StatusCode = get-int64(cast(poArg:ArgumentValue, IMemptrHolder):Value, 1).

                        when poArg:ArgumentType:IsA(get-class(IIntegerHolder)) then
                            assign poArg:Response:StatusCode = cast(poArg:ArgumentValue, IIntegerHolder):Value.
                        
                        when poArg:ArgumentType:IsA(get-class(IInt64Holder)) then
                            assign poArg:Response:StatusCode = cast(poArg:ArgumentValue, IInt64Holder):Value.
                        
                        when poArg:ArgumentType:IsA(get-class(ICharacterHolder)) or
                        when poArg:ArgumentType:IsA(get-class(ILongcharHolder)) then                            
                            assign poArg:Response:StatusCode = integer(StatusCodeEnum:GetEnum(
                                                                        get-string(cast(poArg:ArgumentValue, IMemptrHolder):Value, 1))).
                        
                        otherwise
                            Logger:Warn(substitute('Cannot convert MEMPTR argument value (defined type: &1) to status code',
                                            poArg:ArgumentType:TypeName)).
                    end case.       // memptr value
                    
                    when type-of(poArg:ArgumentValue, IInt64Holder) then
                        assign poArg:Response:StatusCode = integer(cast(poArg:ArgumentValue, IInt64Holder):Value). 
                    
                    otherwise
                        Logger:Warn(substitute('Cannot convert argument value &1 (defined type: &2) to status code',
                                        poArg:ArgumentValue:GetClass():TypeName,
                                        poArg:ArgumentType:TypeName)).
                    
                end case.
                
                when ElementTypeEnum:StatusReason then
                case true:
                    when type-of(poArg:ArgumentValue, ILongcharHolder) then 
                        assign poArg:Response:StatusReason  = cast(poArg:ArgumentValue, ICharacterHolder):Value.
                        
                    when type-of(poArg:ArgumentValue, ICharacterHolder) then
                        assign poArg:Response:StatusReason  = cast(poArg:ArgumentValue, ILongcharHolder):Value. 

                    when type-of(poArg:ArgumentValue, IMemptrHolder) then
                        assign poArg:Response:StatusReason = get-string(cast(poArg:ArgumentValue, IMemptrHolder):Value, 1).
                    
                    otherwise
                        Logger:Warn(substitute('Cannot convert argument value &1 (defined type: &2) to status reason',
                                        poArg:ArgumentValue:GetClass():TypeName,
                                        poArg:ArgumentType:TypeName)).
                end case.
                
                /* Input-only elements */
                when ElementTypeEnum:HttpMethod or
                when ElementTypeEnum:Request or
                when ElementTypeEnum:Path or
                when ElementTypeEnum:Constant or
                when ElementTypeEnum:Query then
                    Logger:Warn(substitute('Invalid (input-only) message element type &1 for output',
                                    string(poArg:Parameter:OutputElementType[iLoop]))).
                
                // covers multipart, json, xml, form-field, etc
                when ElementTypeEnum:Field then
                    WriteFieldValue(poArg, iLoop).
                
                otherwise 
                    Logger:Warn(substitute('Unsupported message element type &1 for output &2',
                                    string(poArg:Parameter:OutputElementType[iLoop]),
                                    poArg:Parameter:OutputElementName[iLoop])).
            end case.   /* element type */
        end.    /* loop */        
    end method. //SetOutputValue
    
    /* Reads the value of a named field from the body.
       
       @param OperationArgument The current argument being processed
       @param integer In ordinal or the current argument 
       @param ArgumentValueWriter The writer used for this field */
    method protected void ReadFieldValue(input poArg as OperationArgument,    
                                         input piIdx as integer,
                                         input poMessageBody as Progress.Lang.Object,
                                         input poValueWriter as ArgumentValueWriter):
        define variable oPart as MessagePart extent no-undo.
        define variable oJsonData as JsonObject no-undo.
        define variable mValue as memptr no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
        Assert:NotNull(poArg, 'Operation argument').
        Assert:IsPositive(piIdx, 'Input element index').

        if not valid-object(poValueWriter) then
            return.
            
        if not valid-object(poMessageBody) then
            return.            

        case true:
            when MimeTypeHelper:IsJson(poArg:Operation:ContentType) then
            do:
                if not type-of(poMessageBody, JsonObject) then
                do:
                    Logger:Warn(substitute('Only JsonObject types supported for Field mapping, not &1',
                                    poMessageBody:GetClass():TypeName)).
                    return.
                end.
                
                // CAST for ease of reading/use
                assign oJsonData = cast(poMessageBody, JsonObject). 
                if not oJsonData:Has(poArg:Parameter:InputElementName[piIdx]) then
                do:
                    Logger:Warn(substitute('Field "&1" not found in message body',
                                    poArg:Parameter:InputElementName[piIdx])).
                    return.
                end.
                
                // We assume that all the elements in the JsonArray are of the same, correct type, since that's
                // how ABL arrays work. The ValueWriter will do this validation
                if poArg:Parameter:IsArray then
                    poValueWriter:Write(oJsonData:GetJsonArray(poArg:Parameter:InputElementName[piIdx])).
                else
                case poArg:Parameter:DataType:
                    when 'character':u then
                        poValueWriter:Write(oJsonData:GetCharacter(poArg:Parameter:InputElementName[piIdx])).
                    when 'longchar':u then
                        poValueWriter:Write(oJsonData:GetLongchar(poArg:Parameter:InputElementName[piIdx])).
                    when 'integer':u then
                        poValueWriter:Write(oJsonData:GetInteger(poArg:Parameter:InputElementName[piIdx])).
                    when 'int64':u then
                        poValueWriter:Write(oJsonData:GetInt64(poArg:Parameter:InputElementName[piIdx])).
                    when 'decimal':u then
                        poValueWriter:Write(oJsonData:GetDecimal(poArg:Parameter:InputElementName[piIdx])).
                    when 'logical':u then   
                        poValueWriter:Write(oJsonData:GetLogical(poArg:Parameter:InputElementName[piIdx])).
                    when 'rowid':u then
                        poValueWriter:Write(oJsonData:GetRowid(poArg:Parameter:InputElementName[piIdx])).
                    when 'recid':u then
                        poValueWriter:Write(oJsonData:GetRecid(poArg:Parameter:InputElementName[piIdx])).
                    when 'date':u then
                        poValueWriter:Write(oJsonData:GetDate(poArg:Parameter:InputElementName[piIdx])).
                    when 'datetime':u then
                        poValueWriter:Write(oJsonData:GetDateTime(poArg:Parameter:InputElementName[piIdx])).
                    when 'datetime-tz':u then
                        poValueWriter:Write(oJsonData:GetDateTimeTz(poArg:Parameter:InputElementName[piIdx])).
                    
                    when 'raw':u or
                    when 'memptr':u then
                    do on error undo, throw:
                        // Assume a base64-encoded value since it's JSON
                        assign mValue = base64-decode(oJsonData:GetLongchar(poArg:Parameter:InputElementName[piIdx])).
                        
                        poValueWriter:Write(mValue).
                        finally:
                            set-size(mValue) = 0.
                        end finally.
                    end.
                    
                    otherwise
                        // JsonObject and JsonArray can carry dataset and temp-tables
                        case oJsonData:GetType(poArg:Parameter:InputElementName[piIdx]):
                            when JsonDataType:OBJECT then
                                poValueWriter:Write(oJsonData:GetJsonObject(poArg:Parameter:InputElementName[piIdx])).
    
                            when JsonDataType:ARRAY then
                                poValueWriter:Write(oJsonData:GetJsonArray(poArg:Parameter:InputElementName[piIdx])).
                            
                            otherwise
                                Logger:Warn(substitute('Unsupported data type &1 for JSON field ',
                                            poArg:ArgumentType:TypeName)).
                                
                        end case.   //JSON data type
                end case.   //argument data type
            end.    //JSON

            /** FUTURES
            when MimeTypeHelper:IsMultipart(poArg:Operation:ContentType) then
            when MimeTypeHelper:IsXML(poArg:Operation:ContentType) then
            when MimeTypeHelper:IsFormEncoded(poArg:Operation:ContentType) then
            **/
                        
            otherwise
                Logger:Warn(substitute('Unsupported MIME type &1 for field mapping',
                            poArg:Operation:ContentType)).
        end case.
    end method.
    
    /* Writes a field name/value for the appropriate content type
       
       @param OperationArgument The value, etc for the argument
       @param integer Which element we're working with */
    method protected void WriteFieldValue(input poArg as OperationArgument,
                                          input piIdx as integer):
        define variable oJson as JsonObject no-undo.
        define variable oData as JsonObject no-undo.
        define variable oJsonArray as JsonArray no-undo.
        define variable hHandleArray as handle extent no-undo.
        define variable mMemptrArray as memptr extent no-undo.
        define variable oObjectArray as Progress.Lang.Object extent no-undo.
        define variable cMethodName as character no-undo.
        define variable oMPE as MultipartEntity no-undo.
        define variable oPart as MessagePart no-undo.
        define variable dValue as datetime-tz no-undo.
        define variable cValue as character no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable writer as MessageWriter no-undo.
        
        case true:
            when MimeTypeHelper:IsMultipart(poArg:Operation:ContentType) then
            do:
                if not valid-object(poArg:Response:Entity) then
                    assign poArg:Response:Entity = new MultipartEntity().
                else
                    Assert:IsType(poArg:Response:Entity, get-class(MultipartEntity)).
                
                /* ease-of-use */
                assign oMPE            = cast(poArg:Response:Entity, MultipartEntity)
                       
                       oPart           = new MessagePart()
                       oPart:ContentID = poArg:Parameter:OutputElementName[piIdx]
                       oPart:Body      = poArg:ArgumentValue
                       .
                oMPE:AddPart(oPart).
                
                case true:
                    when type-of(poArg:ArgumentValue, JsonConstruct) then assign oPart:ContentType = 'application/json':u.
                    when type-of(poArg:ArgumentValue, IHandleHolder) then assign oPart:ContentType = 'text/plain':u.
                    otherwise                                             assign oPart:ContentType = 'application/octet-stream':u.
                end case.
                Logger:Trace(substitute('Multipart part id=&1 ; type=&2 inferred from &3',
                                        oPart:ContentID,
                                        oPart:ContentType,
                                        (if valid-object(poArg:ArgumentValue) then poArg:ArgumentValue:GetClass():TypeName else 'unknown type'))).
            end.    /* multipart */
            
            when MimeTypeHelper:IsJson(poArg:Operation:ContentType) then
            do:
                if not valid-object(poArg:Response:Entity) then
                    assign poArg:Response:Entity = new JsonObject().
                else
                    Assert:IsType(poArg:Response:Entity, get-class(JsonObject)).
                
                /* ease-of-use */
                assign oJson  = cast(poArg:Response:Entity, JsonObject)
                       writer = EntityWriterBuilder:Build(poArg:Operation:ContentType)
                                    :WriteTo(oJson)
                                    :Writer.
                writer:Open().
                
                // single write
                writer:Write(new KeyValuePair(
                                    poArg:Parameter:OutputElementName[piIdx],
                                    poArg:ArgumentValue)).
                
                writer:Close().
            end.    /* json */
            
            when MimeTypeHelper:IsFormEncoded(poArg:Operation:ContentType) then
            do:
                if not valid-object(poArg:Response:Entity) then
                    assign poArg:Response:Entity = new StringStringMap().
                else
                    Assert:IsType(poArg:Response:Entity, get-class(IStringStringMap)).
                
                case true:
                    when type-of(poArg:ArgumentValue, ILongcharHolder) then
                        cast(poArg:Response:Entity, IStringStringMap)
                                        :Put(poArg:Parameter:OutputElementName[piIdx], 
                                             cast(poArg:ArgumentValue, ILongcharHolder):Value).
                    
                    when type-of(poArg:ArgumentValue, IDateHolder) then
                    do:
                        assign dValue = cast(poArg:ArgumentValue, IDateHolder):Value.
                        
                        cast(poArg:Response:Entity, IStringStringMap)
                                                :Put(poArg:Parameter:OutputElementName[piIdx],
                                                     substitute('&1-&2-&3':u,
                                                        string(year(dValue), '9999':u),
                                                        string(month(dValue), '99':u),
                                                        string(day(dValue), '99':u))                                                     
                                                     ).
                    end.    //date
                    
                    when type-of(poArg:ArgumentValue, IDateTimeHolder) then
                        cast(poArg:Response:Entity, IStringStringMap)
                                        :Put(poArg:Parameter:OutputElementName[piIdx], 
                                             TimeStamp:ToISODateFromABL(cast(poArg:ArgumentValue, IDateTimeHolder):Value)
                                             ).
                    
                    when type-of(poArg:ArgumentValue, IDateTimeTzHolder) then
                        cast(poArg:Response:Entity, IStringStringMap)
                                        :Put(poArg:Parameter:OutputElementName[piIdx], 
                                             TimeStamp:ToISODateFromABL(cast(poArg:ArgumentValue, IDateTimeTzHolder):Value)
                                             ).
                    
                    otherwise
                        cast(poArg:Response:Entity, IStringStringMap)
                                        :Put(poArg:Parameter:OutputElementName[piIdx], 
                                             poArg:ArgumentValue:ToString()).
                end case.
            end.    /* form */
            
            otherwise
                Logger:Warn(substitute('Unsupported MIME type &1 for field',
                            poArg:Operation:ContentType)).
        end case.
    end method.
    
    method protected void GetInputValue(input poArg as OperationArgument,
                                        input poMessageBody as Progress.Lang.Object):
        define variable iLoop as integer no-undo.
        
        case extent(poArg:Parameter:InputElementName):
            when 1 then
                GetInputValue(poArg, 1, poMessageBody).
            /* there are no inputs defined */
            when ? then
                return.
            otherwise
            do:
                if not poArg:Parameter:IsArray then
                    GetInputValue(poArg, 1, poMessageBody).
                else
                /* order shouldn't matter */
                do iLoop = extent(poArg:Parameter:InputElementName) to 1 by -1:
                    GetInputValue(poArg, iLoop, poMessageBody).
                end.
            end.
        end case.
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
        define variable schemaHolder as IHandleHolder no-undo.
        
        Assert:NotNull(poArg, 'Argument').
        
        if not poArg:Parameter:HasSchema then
            return.
        
        // TRACKING-CHANGES is only supported for tables-in-datasets
        if     not poArg:Parameter:DataType eq 'dataset-handle':u
           and not poArg:Parameter:DataType eq 'table-handle':u
           and not poArg:Parameter:DataType eq 'handle':u
           then
            return.
        
        assign schemaHolder = cast(poArg:Operation:Schemas:Get(poArg:Parameter:ABLName), IHandleHolder).
        if valid-object(schemaHolder) then
            assign hDataSet = schemaHolder:Value.
        
        // double-check in case of lies above
        if not valid-handle(hDataset) then
            return.
        
        Assert:NotUnknown(plTrackChanges, 'Tracking changes').
        
        case hDataSet:type:
            when 'buffer':u or
            when 'temp-table':u then
            do:
                if hDataSet:type eq 'buffer':u then
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
            
            when 'dataset':u then 
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
                                         input poOperation as MappedOperation ):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable oOperArg as OperationArgument no-undo.
        define variable iArgIdx as integer no-undo.
        
        define buffer lbArg for ttArgument.
        
        if valid-object(poOperation:ReturnValue) then
        do:
            create lbArg.
            assign lbArg.ParentOH   = int64(this-object)
                   lbArg.ParamIndex = 0
                   oOperArg = new OperationArgument(poOperation, 
                                                    poOperation:ReturnValue, 
                                                    poRequest, 
                                                    poResponse)
                   lbArg.Arg = oOperArg
                   .
        end.
        
        assign iMax = poOperation:Parameters:Size.
        PARAM-LOOP:            
        do iLoop = 1 to iMax:
            assign oOperArg = new OperationArgument(poOperation, 
                                                    cast(poOperation:Parameters:Get(iLoop), OperationParameter), 
                                                    poRequest, 
                                                    poResponse).
            
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
            GetInputValue(oOperArg, poMessageBody).
            
            /* Sets the value to true if required. Only do this AFTER we've loaded data
               from the HTTP message since things like READ-JSON do a CREATE tt. under the 
               covers which messes with the ROW-STATE */
            SetTrackingChanges(oOperArg, true).
        end.    // PARAM-LOOP    
    end method.
    
end class.
