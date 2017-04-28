/* *************************************************************************************************************************
Copyright (c) 2016 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
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

using Ccs.Common.Support.ICharacterArrayHolder.
using Ccs.Common.Support.IDateArrayHolder.
using Ccs.Common.Support.IDateHolder.
using Ccs.Common.Support.IDateTimeArrayHolder.
using Ccs.Common.Support.IDateTimeHolder.
using Ccs.Common.Support.IDateTimeTzArrayHolder.
using Ccs.Common.Support.IDateTimeTzHolder.
using Ccs.Common.Support.IDecimalArrayHolder.
using Ccs.Common.Support.IDecimalHolder.
using Ccs.Common.Support.IHandleArrayHolder.
using Ccs.Common.Support.IHandleHolder.
using Ccs.Common.Support.IInt64ArrayHolder.
using Ccs.Common.Support.IInt64Holder.
using Ccs.Common.Support.IIntegerArrayHolder.
using Ccs.Common.Support.ILogicalArrayHolder.
using Ccs.Common.Support.ILogicalHolder.
using Ccs.Common.Support.ILongcharArrayHolder.
using Ccs.Common.Support.ILongcharHolder.
using Ccs.Common.Support.IMemptrArrayHolder.
using Ccs.Common.Support.IMemptrHolder.
using Ccs.Common.Support.IRowidArrayHolder.
using OpenEdge.Core.Assert.
using OpenEdge.Core.Collections.IStringStringMap.
using OpenEdge.Core.Collections.StringStringMap.
using OpenEdge.Core.DataTypeEnum.
using OpenEdge.Core.DataTypeHelper.
using OpenEdge.Core.ISupportInitialize.
using OpenEdge.Core.LogLevelEnum.
using OpenEdge.Core.TimeStamp.
using OpenEdge.Core.Util.ILogWriter.
using OpenEdge.Core.Util.ISupportLogging.
using OpenEdge.Core.Util.LogManagerLogger.
using OpenEdge.Core.WidgetHandle.
using OpenEdge.Net.HTTP.Cookie.
using OpenEdge.Net.HTTP.HttpHeader.
using OpenEdge.Net.HTTP.HttpHeaderBuilder.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.MessagePart.
using OpenEdge.Net.MimeTypeHelper.
using OpenEdge.Net.MultipartEntity.
using OpenEdge.Web.DataObject.ElementTypeEnum.
using OpenEdge.Web.DataObject.IOperationHandler.
using OpenEdge.Web.DataObject.MappedOperation.
using OpenEdge.Web.DataObject.OperationArgument.
using OpenEdge.Web.DataObject.ServiceRegistry.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriter.
using OpenEdge.Web.DataObject.Writer.ArgumentValueWriterBuilder.
using OpenEdge.Web.IWebRequest.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Json.ObjectModel.JsonDataType.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.AppError.

class OpenEdge.Web.DataObject.OperationHandler implements IOperationHandler, ISupportInitialize, ISupportLogging
      abstract: 

    define public event LogMessage  signature void (input poSender as Progress.Lang.Object, 
                                                    input pcMessageGroup as character, 
                                                    input pcMessage as character, 
                                                    input poLogLevel as LogLevelEnum).       

    define protected property Logger as ILogWriter no-undo get. private set.

    /* transient/temp data for a single request execution */
    define static protected temp-table ttArgument no-undo
        field ParentCOH as int64
        field ParamIndex as int
        field Argument as Progress.Lang.Object
        index idx1 as primary unique ParentCOH ParamIndex. 
    
    constructor public OperationHandler():
        assign this-object:Logger= new LogManagerLogger().
    end constructor.
    
    constructor public OperationHandler(input poLogger as ILogWriter):
        this-object().
        
        Assert:NotNull(poLogger, 'Logger').
        assign this-object:Logger= poLogger.
    end constructor.

    destructor public OperationHandler():
        Destroy().
    end destructor.  
    
    method public void Initialize():
        this-object:Logger:SubscribeTo(this-object).
    end method.
    
    method public void Destroy():
        this-object:Logger:UnsubscribeFrom(this-object).
    end method.
    
    method protected void ClearArguments():
        define buffer lbArg for ttArgument.
        
        for each lbArg where lbArg.ParentCOH eq int64(this-object):
            delete lbArg.
        end.
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
        
        LogMessage(substitute('GetInputValue for &1 &5 &2 &3 &4',
                                poArg:Parameter:ABLType,
                                poArg:ArgumentType:TypeName,
                                string(poArg:Parameter:InputElementType[piIdx]),
                                string(poArg:Parameter:InputElementName[piIdx]),
                                piIdx ),
                   LogLevelEnum:TRACE).
        
        assign oValueWriter = ArgumentValueWriterBuilder:Build(poArg)
                                    :Logger(this-object:Logger)
                                    :Writer.
        
        if not valid-object(oValueWriter) then
        do:
            LogMessage(substitute('Cannot convert input message element type &2 to argument &1',
                                    poArg:ArgumentType:TypeName,
                                    string(poArg:Parameter:InputElementType[piIdx])),
                              LogLevelEnum:WARN).
            return.
        end.

        LogMessage(substitute('GetInputValue ValueWriter is &1 for &2',
                                oValueWriter:GetClass():TypeName,
                                oValueWriter:ArgumentType:TypeName),
                   LogLevelEnum:TRACE).
        
        oValueWriter:Open().
        
        // Use a schema if we have one 
        if poArg:HasSchema and valid-object(poArg:ArgumentValue) then
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
                assign oHeader = poArg:Request:GetHeader(poArg:Parameter:InputElementName[piIdx]).
                if valid-object(oHeader) then
                    oValueWriter:Write(oHeader:Value).
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
            
            /* output only */
            when ElementTypeEnum:StatusCode or
            when ElementTypeEnum:StatusReason then
                LogMessage(substitute('Invalid (output-only) message element type &1 for input',
                                string(poArg:Parameter:InputElementType[piIdx])),
                           LogLevelEnum:WARN).

            /* unsupported */
            otherwise 
                LogMessage(substitute('Unsupported message element type &1 for input',
                                string(poArg:Parameter:InputElementType[piIdx])),
                           LogLevelEnum:WARN).
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
        
        Assert:NotNull(poArg, 'Operation argument').
        // nope
        if not poArg:HasSchema then
            return.
        
        assign hSchema = this-object:GetSchemaClone(poArg).
        if not valid-handle(hSchema) then
        do:
            LogMessage(substitute('Unable to find schema &2 for service &1; using inferred data schema may result in errors',
                            poArg:Operation:ServiceName,
                            poArg:Parameter:ABLName),
                       LogLevelEnum:WARN).
            return.
        end.
        
               /* we want to keep the schema around for the duration of this call and destroy it when we're done */
        assign poArg:SchemaHolder = new WidgetHandle(hSchema, true)
               
               oValueWriter = ArgumentValueWriterBuilder:Build(poArg)
                                    :Logger(this-object:Logger)
                                    :Writer.
        
        if not valid-object(oValueWriter) then
        do:
            LogMessage(substitute('Cannot convert schema to argument &1',
                                    poArg:ArgumentType:TypeName),
                              LogLevelEnum:WARN).
            return.
        end.
        
        oValueWriter:Open().
        
        /* The schema holder may be a dataset or temp-table. If the former, we may only want to
           pass a single table from the dataset, and so need to extract/write that. */           
        if poArg:DataType eq 'dataset-handle':u or
           hSchema:type eq 'temp-table':u       then
            oValueWriter:Write(poArg:SchemaHolder).
        else
            oValueWriter:Write(hSchema:get-buffer-handle(poArg:Parameter:ABLName)
                                      :table-handle).
        
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
        define variable oValueWriter as ArgumentValueWriter no-undo.
        define variable hData as handle no-undo.

        Assert:NotNull(poArg, 'Operation arg').
        
        /* if we are working with a dataset or temp-table, write to MEMPTR now. This lets us
           apply the 'writeBI' option if set */
        if poArg:DataType eq 'dataset-handle':u or 
           poArg:DataType eq 'table-handle':u   or
           poArg:DataType eq 'handle':u         then
        do:
            if poArg:Operation:Options:Has('writeBI':u) then
                assign lWriteBI = poArg:Operation:Options:GetLogical('writeBI':u).
            else
                assign lWriteBI = false.
            
            if not poArg:ArgumentType:IsA(get-class(IHandleHolder)) then
                LogMessage(substitute('Expecting &1 for &2 ; got &3. Before-image data will not be written',
                                get-class(IHandleHolder):TypeName,
                                poArg:DataType,
                                poArg:ArgumentType:TypeName),
                           LogLevelEnum:WARN).
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
                            LogMessage(substitute('writeBI:TRUE only supported for datasets, not &1 &2',
                                        hData:type, poArg:Parameter:ABLName),
                                       LogLevelEnum:WARN).
                            assign lWriteBI = false.
                        end.
                        
                        LogMessage(substitute('Data extracted for &1 &2 with before-image &3',
                                    poArg:Parameter:ABLType,
                                    poArg:Parameter:ABLName,
                                    string(lWriteBI, 'on/off')),
                                   LogLevelEnum:TRACE).
                                   
                        assign oValueWriter = ArgumentValueWriterBuilder:Build(get-class(IMemptrHolder))
                                            :Logger(this-object:Logger)
                                            :Writer.
                        Assert:NotNull(oValueWriter, 'Ccs.Common.Support.IMemptrHolder value writer').
                                        
                        case true:
                            when MimeTypeHelper:IsJson(poArg:Operation:ContentType) then
                                hData:write-json('memptr':u, mData, ?, ?, ?, ?, lWriteBI).
                            
                            when MimeTypeHelper:IsXML(poArg:Operation:ContentType) then
                                hData:write-xml('memptr':u, mData, ?, ?, ?, ?, ?, lWriteBI).
                            
                            otherwise
                                LogMessage(substitute('Unable to WRITE-* &1 into content-type &2 ',
                                                poArg:DataType, poArg:Operation:ContentType),
                                           LogLevelEnum:WARN).
                        end case.
                        
                        if get-size(mData) gt 0 then
                        do:                    
                            oValueWriter:Open().
                            oValueWriter:Write(mData).
                            oValueWriter:Close().
                            
                            assign poArg:ArgumentValue = oValueWriter:Value
                                   poArg:ArgumentType  = get-class(IMemptrHolder)
                                   .
                        end.
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
            LogMessage(substitute('No output elements defined for argument &1 &2',
                        poArg:ArgumentType,
                        string(poArg:ArgumentValue) ),
                       LogLevelEnum:INFO).
        else
        /* order shouldn't matter */
        do iLoop = extent(poArg:Parameter:OutputElementType) to 1 by -1:
            LogMessage(substitute('SetOutputValue &5 param=&6; arg=&1; type &2; elem=&3 &4',
                                    string(poArg:ArgumentValue),
                                    poArg:ArgumentType:TypeName,
                                    string(poArg:Parameter:OutputElementType[iLoop]),
                                    string(poArg:Parameter:OutputElementName[iLoop]),
                                    iLoop,
                                    poArg:Parameter:ABLName),
                       LogLevelEnum:TRACE).
            
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
                        LogMessage(substitute('Cannot convert argument &1 to message element type &2',
                                        poArg:ArgumentType:TypeName,
                                        string(poArg:Parameter:OutputElementType[iLoop])),
                                   LogLevelEnum:WARN).
                end case.    /* header */
                
                when ElementTypeEnum:Cookie then
                do:
                    if poArg:ArgumentType:IsA(get-class(Cookie)) then
                        poArg:Response
                                :SetCookie(cast(poArg:ArgumentValue, Cookie)).
                    else
                        LogMessage(substitute('Cannot convert message element type &1 to &2',
                                        poArg:ArgumentType:TypeName,
                                        string(poArg:Parameter:OutputElementType[iLoop])),
                                   LogLevelEnum:WARN).
                end.    /* cookie */
                
                when ElementTypeEnum:Body then
                do:
                    if valid-object(poArg:Response:Entity) then
                        LogMessage(substitute('Response entity &1 &2 overwritten by &3 &4',
                                        poArg:Response:Entity:GetClass():TypeName,
                                        int64(poArg:Response:Entity),
                                        poArg:Parameter:OutputElementName[iLoop],
                                        poArg:ArgumentType:TypeName     ),
                                  LogLevelEnum:WARN).
                    
                    assign poArg:Response:Entity = poArg:ArgumentValue.
                end.    /* body */
                
                when ElementTypeEnum:StatusCode then
                    assign poArg:Response:StatusCode = integer(cast(poArg:ArgumentValue, IInt64Holder):Value). 

                when ElementTypeEnum:StatusReason then
                    assign poArg:Response:StatusReason  = string(cast(poArg:ArgumentValue, ILongcharHolder):Value). 
                
                /* Input-only elements */
                when ElementTypeEnum:Request or
                when ElementTypeEnum:Path or
                when ElementTypeEnum:Constant or
                when ElementTypeEnum:Query then
                    LogMessage(substitute('Invalid (input-only) message element type &1 for output',
                                    string(poArg:Parameter:OutputElementType[iLoop])),
                               LogLevelEnum:WARN).
                
                // covers multipart, json, xml, form-field, etc
                when ElementTypeEnum:Field then
                    WriteFieldValue(poArg, iLoop).
                
                otherwise 
                    LogMessage(substitute('Unsupported message element type &1 for output &2',
                                    string(poArg:Parameter:OutputElementType[iLoop]),
                                    poArg:Parameter:OutputElementName[iLoop]),
                               LogLevelEnum:WARN).
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
                    LogMessage(substitute('Only JsonObject types supported for Field mapping, not &1',
                                    poMessageBody:GetClass():TypeName),
                               LogLevelEnum:WARN).
                    return.
                end.
                
                // CAST for ease of reading/use
                assign oJsonData = cast(poMessageBody, JsonObject). 
                if not oJsonData:Has(poArg:Parameter:InputElementName[piIdx]) then
                do:
                    LogMessage(substitute('Field "&1" not found in message body',
                                    poArg:Parameter:InputElementName[piIdx]),
                               LogLevelEnum:WARN).
                    return.
                end.
                
                // We assume that all the elements in the JsonArray are of the same, correct type, since that's
                // how ABL arrays work. The ValueWriter will do this validation
                if poArg:IsArray then
                    poValueWriter:Write(oJsonData:GetJsonArray(poArg:Parameter:InputElementName[piIdx])).
                else
                case poArg:DataType:
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
                                LogMessage(substitute('Unsupported data type &1 for JSON field ',
                                            poArg:ArgumentType:TypeName),
                                           LogLevelEnum:WARN).
                                
                        end case.   //JSON data type
                end case.   //argument data type
            end.    //JSON

            /** FUTURES
            when MimeTypeHelper:IsMultipart(poArg:Operation:ContentType) then
            when MimeTypeHelper:IsXML(poArg:Operation:ContentType) then
            when MimeTypeHelper:IsFormEncoded(poArg:Operation:ContentType) then
            **/
                        
            otherwise
                LogMessage(substitute('Unsupported MIME type &1 for field mapping',
                            poArg:Operation:ContentType),
                           LogLevelEnum:WARN).
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
        define variable cMethodName as character no-undo.
        define variable cContentType as character no-undo.
        define variable oMPE as MultipartEntity no-undo.
        define variable oPart as MessagePart no-undo.
        define variable dValue as datetime-tz no-undo.
        define variable cValue as character no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
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
                    when type-of(poArg:ArgumentValue, JsonConstruct) then
                        assign oPart:ContentType = 'application/json':u.

                    when type-of(poArg:ArgumentValue, IMemptrHolder) then
                        assign oPart:ContentType = 'application/octet-stream':u.
                    
                    when type-of(poArg:ArgumentValue, IHandleHolder) then
                    case poArg:DataType:
                        when 'dataset-handle':u or 
                        when 'table-handle':u then
                        do:
                            assign oData = new JsonObject().
                            oData:Read(cast(poArg:ArgumentValue, IHandleHolder):Value).
                            
                            assign oPart:Body        = oData
                                   oPart:ContentType = 'application/json':u.
                        end.
                        otherwise
                            LogMessage(substitute('Unsupported handle data &1 for multipart data',
                                        poArg:ArgumentType:TypeName),
                                       LogLevelEnum:WARN).
                    end case.    /* handles: datasets & TT */
                end case.
                LogMessage(substitute('Multipart part id=&1 ; type=&2 inferred from &3',
                                        oPart:ContentID,
                                        oPart:ContentType,
                                        (if valid-object(poArg:ArgumentValue) then poArg:ArgumentValue:GetClass():TypeName else 'unknown type')),
                                      LogLevelEnum:TRACE).
            end.    /* multipart */
            
            when MimeTypeHelper:IsJson(poArg:Operation:ContentType) then
            do:
                if not valid-object(poArg:Response:Entity) then
                    assign poArg:Response:Entity = new JsonObject().
                else
                    Assert:IsType(poArg:Response:Entity, get-class(JsonObject)).
                
                /* ease-of-use */
                assign oJson = cast(poArg:Response:Entity, JsonObject). 
                
                /* We're going to use reflection because of the mucking about
                   with the various data type passing */
                if oJson:Has(poArg:Parameter:OutputElementName[piIdx]) then
                    assign cMethodName = 'Set':u.
                else
                    assign cMethodName = 'Add':u.
                
                case true:
                    /* PRIMITIVE SCALAR */
                    when type-of(poArg:ArgumentValue, ILongcharHolder) then
                        dynamic-invoke(oJson, cMethodName,
                                       poArg:Parameter:OutputElementName[piIdx],
                                       cast(poArg:ArgumentValue, ILongcharHolder):Value).
                    
                    when type-of(poArg:ArgumentValue, IInt64Holder) then
                        dynamic-invoke(oJson, cMethodName,
                                       poArg:Parameter:OutputElementName[piIdx],
                                       cast(poArg:ArgumentValue, IInt64Holder):Value).
                    
                    when type-of(poArg:ArgumentValue, IDecimalHolder) then
                        dynamic-invoke(oJson, cMethodName,
                                       poArg:Parameter:OutputElementName[piIdx],
                                       cast(poArg:ArgumentValue, IDecimalHolder):Value).

                    when type-of(poArg:ArgumentValue, ILogicalHolder) then
                        dynamic-invoke(oJson, cMethodName,
                                       poArg:Parameter:OutputElementName[piIdx],
                                       cast(poArg:ArgumentValue, ILogicalHolder):Value).
                    
                    when type-of(poArg:ArgumentValue, IDateTimeTzHolder) then
                        dynamic-invoke(oJson, cMethodName,
                                       poArg:Parameter:OutputElementName[piIdx],
                                       cast(poArg:ArgumentValue, IDateTimeTzHolder):Value).                    

                    when type-of(poArg:ArgumentValue, IDateHolder) then
                        dynamic-invoke(oJson, cMethodName,
                                       poArg:Parameter:OutputElementName[piIdx],
                                       cast(poArg:ArgumentValue, IDateHolder):Value).                    

                    when type-of(poArg:ArgumentValue, IDateTimeHolder) then
                        dynamic-invoke(oJson, cMethodName,
                                       poArg:Parameter:OutputElementName[piIdx],
                                       cast(poArg:ArgumentValue, IDateTimeHolder):Value).                    

                    when type-of(poArg:ArgumentValue, IMemptrHolder) then
                        dynamic-invoke(oJson, cMethodName,
                                       poArg:Parameter:OutputElementName[piIdx],
                                       base64-encode(cast(poArg:ArgumentValue, IMemptrHolder):Value)).
                    
                    when type-of(poArg:ArgumentValue, IHandleHolder) then
                    do:
                        assign extent(hHandleArray) = ?
                               extent(hHandleArray) = 1
                               hHandleArray[1] = cast(poArg:ArgumentValue, IHandleHolder):Value.
                               
                        if not valid-handle(hHandleArray[1]) then
                            oJsonArray:AddNull().
                        else                                
                        case hHandleArray[iLoop]:type:
                            when DataTypeHelper:GetMask(DataTypeEnum:Buffer) or
                            when DataTypeHelper:GetMask(DataTypeEnum:TempTable) or
                            when DataTypeHelper:GetMask(DataTypeEnum:Dataset) then
                            do:
                                assign oData = new JsonObject().
                                oData:Read(hHandleArray[1]).
                                
                                oJsonArray:Add(oData).
                            end.    // PDS/TT 
                            otherwise
                            do:
                                LogMessage(substitute('Unsupported data type &1 &2 for JSON property ',
                                            poArg:DataType,
                                            hHandleArray[1]:type),
                                           LogLevelEnum:WARN).
                                oJsonArray:Add(hHandleArray[1]).
                            end.
                        end case.
                    end.        // handles 
                                        
                    /* PRIMITIVE ARRAY */
                    when type-of(poArg:ArgumentValue, IIntegerArrayHolder) then
                        dynamic-invoke(oJson, cMethodName,
                                       poArg:Parameter:OutputElementName[piIdx],
                                       new JsonArray(cast(poArg:ArgumentValue, IIntegerArrayHolder):Value)).

                    when type-of(poArg:ArgumentValue, IInt64ArrayHolder) then
                        dynamic-invoke(oJson, cMethodName,
                                       poArg:Parameter:OutputElementName[piIdx],
                                       new JsonArray(cast(poArg:ArgumentValue, IInt64ArrayHolder):Value)).
                    
                    when type-of(poArg:ArgumentValue, ILongcharArrayHolder) then
                        dynamic-invoke(oJson, cMethodName,
                                       poArg:Parameter:OutputElementName[piIdx],
                                       new JsonArray(cast(poArg:ArgumentValue, ILongcharArrayHolder):Value)).

                    when type-of(poArg:ArgumentValue, ICharacterArrayHolder) then
                        dynamic-invoke(oJson, cMethodName,
                                       poArg:Parameter:OutputElementName[piIdx],
                                       new JsonArray(cast(poArg:ArgumentValue, ICharacterArrayHolder):Value)).
                    
                    when type-of(poArg:ArgumentValue, IDecimalArrayHolder) then
                        dynamic-invoke(oJson, cMethodName,
                                       poArg:Parameter:OutputElementName[piIdx],
                                       new JsonArray(cast(poArg:ArgumentValue, IDecimalArrayHolder):Value)).
                    
                    when type-of(poArg:ArgumentValue, ILogicalArrayHolder) then
                        dynamic-invoke(oJson, cMethodName,
                                       poArg:Parameter:OutputElementName[piIdx],
                                       new JsonArray(cast(poArg:ArgumentValue, ILogicalArrayHolder):Value)).
                    
                    when type-of(poArg:ArgumentValue, IRowidArrayHolder) then
                        dynamic-invoke(oJson, cMethodName,
                                       poArg:Parameter:OutputElementName[piIdx],
                                       new JsonArray(cast(poArg:ArgumentValue, IRowidArrayHolder):Value)).
                    
                    when type-of(poArg:ArgumentValue, IDateArrayHolder) then
                        dynamic-invoke(oJson, cMethodName,
                                       poArg:Parameter:OutputElementName[piIdx],
                                       new JsonArray(cast(poArg:ArgumentValue, IDateArrayHolder):Value)).

                    when type-of(poArg:ArgumentValue, IDateTimeArrayHolder) then
                        dynamic-invoke(oJson, cMethodName,
                                       poArg:Parameter:OutputElementName[piIdx],
                                       new JsonArray(cast(poArg:ArgumentValue, IDateTimeArrayHolder):Value)).

                    when type-of(poArg:ArgumentValue, IDateTimeTzArrayHolder) then
                        dynamic-invoke(oJson, cMethodName,
                                       poArg:Parameter:OutputElementName[piIdx],
                                       new JsonArray(cast(poArg:ArgumentValue, IDateTimeTzArrayHolder):Value)).

                    when type-of(poArg:ArgumentValue, IMemptrArrayHolder) then
                    do on error undo, throw:
                        assign mMemptrArray = cast(poArg:ArgumentValue, IMemptrArrayHolder):Value.
                               iMax = extent(mMemptrArray).
                        assign oJsonArray = new JsonArray().
                        do iLoop = 1 to iMax:
                            oJsonArray:Add(base64-encode(mMemptrArray[iLoop])).
                        end.
                        
                        dynamic-invoke(oJson, cMethodName, poArg:Parameter:OutputElementName[piIdx], oJsonArray).
                        finally:
                            do iLoop = 1 to iMax:
                                set-size(mMemptrArray[iLoop]) = 0.
                            end.
                        end finally.
                    end.    // MEMPTR array 
                    
                    when type-of(poArg:ArgumentValue, IHandleArrayHolder) then
                    do:
                        assign hHandleArray = cast(poArg:ArgumentValue, IHandleArrayHolder):Value
                               iMax = extent(hHandleArray)
                               oJsonArray = new JsonArray().
                        
                        do iLoop = 1 to iMax:
                            if not valid-handle(hHandleArray[iLoop]) then
                                oJsonArray:AddNull().
                            else                                
                            case hHandleArray[iLoop]:type:
                                when DataTypeHelper:GetMask(DataTypeEnum:Buffer) or
                                when DataTypeHelper:GetMask(DataTypeEnum:TempTable) or
                                when DataTypeHelper:GetMask(DataTypeEnum:Dataset) then
                                do:
                                    assign oData = new JsonObject().
                                    oData:Read(hHandleArray[iLoop]).
                                    
                                    oJsonArray:Add(oData).
                                end.    // PDS/TT 
                                otherwise
                                do:
                                    LogMessage(substitute('Unsupported data type &1 &2 for JSON property ',
                                                poArg:DataType,
                                                hHandleArray[iLoop]:type),
                                               LogLevelEnum:WARN).
                                    oJsonArray:Add(hHandleArray[iLoop]).
                                end.
                            end case.
                        end.
                        
                        dynamic-invoke(oJson, cMethodName, poArg:Parameter:OutputElementName[piIdx], oJsonArray).
                    end.    // HANDLE array
                    
                    /* JSON  */
                    when type-of(poArg:ArgumentValue, JsonObject) then
                        dynamic-invoke(oJson, cMethodName,
                                       poArg:Parameter:OutputElementName[piIdx],
                                       cast(poArg:ArgumentValue, JsonObject)).
                    
                    when type-of(poArg:ArgumentValue, JsonArray) then
                        dynamic-invoke(oJson, cMethodName,
                                       poArg:Parameter:OutputElementName[piIdx],
                                       cast(poArg:ArgumentValue, JsonArray)).
                    
                    /* OTHER OBJECTS */
                    when not poArg:IsPrimitive then
                        dynamic-invoke(oJson, cMethodName,
                                       poArg:Parameter:OutputElementName[piIdx],
                                       poArg:ArgumentValue:ToString()).
                    
                    otherwise
                        LogMessage(substitute('Unsupported data type &1 for JSON field ',
                                    poArg:ArgumentType:TypeName),
                                   LogLevelEnum:WARN).
                end case.
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
                LogMessage(substitute('Unsupported MIME type &1 for field',
                            poArg:Operation:ContentType),
                           LogLevelEnum:WARN).
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
                if not poArg:IsArray then
                    GetInputValue(poArg, 1, poMessageBody).
                else
                /* order shouldn't matter */
                do iLoop = extent(poArg:Parameter:InputElementName) to 1 by -1:
                    GetInputValue(poArg, iLoop, poMessageBody).
                end.
            end.
        end case.
    end method.
    
    /* Gets a data structure/schema for use in this operation. 
       We want to use a shadow of the schema cache since at some point the 
       schema cache may be shared among sessions and then we'd get into a world of pain
       with data.
       
       The buffer numbers of the tables that have/need TRACKING-CHANGES are written as
       a CSV into the dataset's PRIVATE-DATA.
       
       @param OperationArgument The current operation
       @return handle A useable temp-table or dataset */
    method protected handle GetSchemaClone (input poArg as OperationArgument):
        define variable hSchema as handle no-undo.
        define variable hDataStructure as handle no-undo.
        define variable iLoop as integer no-undo.
        define variable iTime as integer extent 2 no-undo.
        define variable cDelim as character no-undo.
        
        //nope
        if not poArg:HasSchema then
            return hSchema.  
        
        assign hSchema = ServiceRegistry:GetSchema(poArg:Operation:ServiceName, 
                                                   poArg:Parameter:ABLName).

        LogMessage(substitute('Getting schema for &1 &2 : &3',
                        poArg:Operation:ServiceName,
                        poArg:Parameter:ABLName,
                        hSchema),
                   LogLevelEnum:TRACE).
                   
        if valid-handle(hSchema) then
        do:
            assign iTime[1] = mtime.            
            case poArg:DataType:
                when 'dataset-handle':u then
                    create dataset hDataStructure.
                when 'table-handle':u then
                do:
                    /* If the TT is part of a dataset, clone the DATASET - we'll only use the
                       temp-table but we want it to be part of a whole */ 
                    if valid-handle(hSchema:default-buffer-handle:dataset) then
                    do:
                        create dataset hDataStructure.
                        assign hSchema = hSchema:default-buffer-handle:dataset.
                    end.
                    else
                        create temp-table hDataStructure.
                end.
            end case.
            
            hDataStructure:create-like(hSchema).
            case hDataStructure:type:
                when 'temp-table':u then
                    hDataStructure:temp-table-prepare(hSchema:name).
                when 'dataset' then
                    // If we're passing a single table from a dataset, make sure all the things are flagged/marked
                    if poArg:DataType eq 'table-handle':u then                    
                        assign hDataStructure:get-buffer-handle(poArg:Parameter:ABLName)
                                    :table-handle:private-data 
                                = hSchema:get-buffer-handle(poArg:Parameter:ABLName)
                                    :table-handle:private-data.  
            end case.
            
            // indicate whether tracking changes is set. private-data doesn't get copied
            assign hDataStructure:private-data = hSchema:private-data
                   iTime[2]                    = mtime
                   .
            LogMessage(substitute('Schema &1 clone time &2ms',
                            poArg:Parameter:ABLName,
                            iTime[2] - iTime[1]),
                       LogLevelEnum:TRACE).
        end.
        
        return hDataStructure.
    end method.
    
    /* Sets the value of a dataset's contained buffers' tracking-changes value.
       The dataset's PRIVATE-DATA contains a CSV list of buffer numbers that 
       may have the flag set to true.
       
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
        
        if not poArg:HasSchema then
            return.

        if not valid-object(poArg:ArgumentValue) then
            return.
        if not poArg:ArgumentType:IsA(get-class(IHandleHolder)) then
            return.
        
        assign hDataSet = cast(poArg:ArgumentValue, IHandleHolder):Value.
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
                
                if hDataSet:private-data eq 'trackChanges':u then
                do:
                    /* If this temp-table is part of a dataset, then we can set the tracking-changes flag.
                       Otherwise return an error. */
                    if valid-handle(hDataSet:default-buffer-handle:dataset) then
                    do:
                        assign hDataSet:tracking-changes = plTrackChanges.
                        LogMessage(substitute('Tracking changes set to &1 for buffer &2 (table: &3)',
                                        plTrackChanges, 
                                        hDataSet:default-buffer-handle:name,
                                        hDataset:name),
                                   LogLevelEnum:TRACE).
                        return.
                    end.
                    else
                        undo, throw new AppError(substitute('Unable to set TRACKING-CHANGES on table &1 ; table must be part of a ProDataSet',
                                                    hDataSet:default-buffer-handle:name),
                                                 0).
                end.
            end.    //tt 
            
            when 'dataset':u then 
            do:
                if hDataset:private-data begins 'trackChanges':u then
                    assign iMax = num-entries(entry(2, hDataset:private-data, '=':u)).
                
                LogMessage(substitute('Set tracking changes to &1 for buffers &2 in dataset &3',
                                plTrackChanges,
                                hDataset:private-data, 
                                hDataset:name),
                           LogLevelEnum:TRACE).                           
                do iLoop = 1 to iMax:
                    assign iBuffer = integer(entry(iLoop, hDataset:private-data)) no-error.
                    if iBuffer eq ? or iBuffer eq 0 then
                        next.
                    
                    assign hBuffer = hDataset:get-buffer-handle(iBuffer)
                           hBuffer:table-handle:tracking-changes = plTrackChanges
                           .
                    LogMessage(substitute('Tracking changes set to &1 for buffer &2 (table: &3)',
                                    plTrackChanges, 
                                    hBuffer:name,
                                    hBuffer:table-handle:name),
                               LogLevelEnum:TRACE).                   
                end.
            end.    //pds
            
            // not applicable to other handle-based things    
            otherwise
                // no-op; no failure
                return.
        end case. 
    end method.

    /** Logs a message 
        
        @param character The message to log */ 
    method private void LogMessage(input pcMessage as character,
                                   input poLogLevel as LogLevelEnum):
        OnLogMessage(pcMessage,
                     poLogLevel,
                     'DOH-OPH':u).
    end method.

    /* Fires the LogMesage event */
    method protected void OnLogMessage(input pcMessage as character,
                                       input poLogLevel as LogLevelEnum,
                                       input pcGroup as character):
        this-object:LogMessage:Publish(this-object,
                                       pcGroup,
                                       pcMessage,
                                       poLogLevel).
    end method.                                           

end class.