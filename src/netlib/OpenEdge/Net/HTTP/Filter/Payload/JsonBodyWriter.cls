/************************************************
Copyright (c) 2015-2017 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : JsonBodyWriter
    Purpose     : Writes JSON as a series of bytes/chars
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Jan 29 10:47:13 EST 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.ICharacterHolder.
using Ccs.Common.Support.IHandleHolder.
using Ccs.Common.Support.ILongcharHolder.
using Ccs.Common.Support.IMemptrHolder.
using OpenEdge.Core.Assert.
using OpenEdge.Core.ByteBucket.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.IStringKeyedMap.
using OpenEdge.Core.Collections.MapEntry.
using OpenEdge.Core.DataTypeEnum.
using OpenEdge.Core.DataTypeHelper.
using OpenEdge.Core.JsonDataTypeEnum.
using OpenEdge.Core.Memptr.
using OpenEdge.Core.Session.
using OpenEdge.Core.StringConstant.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using Progress.IO.FileInputStream.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.AppError.
using Progress.Lang.Object.
using Progress.Reflect.DataType.

class OpenEdge.Net.HTTP.Filter.Payload.JsonBodyWriter inherits MessageWriter: 
    constructor public JsonBodyWriter():
        super (get-class(ByteBucket)).
    end constructor.    
    
    method override public void Open():    
        if not valid-object(this-object:Entity) then
            assign this-object:Entity = ByteBucket:Instance().
        
        super:Open().
    end method.
    
    method override public int64 Write(input pmData as memptr):       
        cast(this-object:Entity, ByteBucket):PutBytes(get-pointer-value(pmData), get-size(pmData)).
        
        return get-size(pmData).        
    end method.

    method override public int64 Write(input pData as longchar):       
        cast(this-object:Entity, ByteBucket):PutString(pData).
        
        return length(pData, 'raw':u).
    end method.
    
    method override public int64 Write( input poData as Object):
        define variable mJson as memptr no-undo.
        define variable lcJson as longchar no-undo.
        define variable iBytesWritten as int64 no-undo.
        define variable fileStream as FileInputStream no-undo.
        
        case true:
            when not valid-object(poData) then
            do:
                cast(this-object:Entity, ByteBucket):Clear().
                
                cast(this-object:Entity, ByteBucket):PutString(lc(string(JsonDataTypeEnum:Null))).
                return length(lc(string(JsonDataTypeEnum:Null)), 'raw':u).
            end.    // nulls/empty  
            
            when type-of(poData, Memptr) or
            when type-of(poData, IMemptrHolder) then
            do on error undo, throw:
                // choose Write(<MEMPTR>) at compile time
                assign mJson = dynamic-property(poData, 'Value':u).
                
                return this-object:Write(mJson).
                finally:
                    if get-size(mJson) gt 0 then
                        set-size(mJson) = 0.
                end finally.
            end.
            
            when type-of(poData, JsonConstruct) then
            do on error undo, throw:
                cast(poData, JsonConstruct):Write(mJson, session:debug-alert).
                
                /* Add the JSON to the message body's bytebucket */
                assign iBytesWritten = get-size(mJson).
                cast(this-object:Entity, ByteBucket):PutBytes(get-pointer-value(mJson),
                                                              iBytesWritten).
                return iBytesWritten.
                finally:
                    set-size(mJson) = 0.
                end finally.
            end.
            
            when type-of(poData, IHandleHolder) then
                return this-object:Write(cast(poData, IHandleHolder):Value).
            
            when type-of(poData, IStringKeyedMap) then
            do:
                define variable oIterator as IIterator no-undo.
                define variable oValue as MapEntry no-undo.
                define variable oJson as JsonObject no-undo.
                
                assign oJson = new JsonObject()
                       oIterator = cast(poData, IStringKeyedMap):EntrySet:Iterator().
                do while oIterator:HasNext():
                    assign oValue = cast(oIterator:Next(), MapEntry).
                    oJson:Add(oValue:Key:ToString(),
                              oValue:Value:ToString()).
                end.
                
                return this-object:Write(oJson).
            end.
            
            when type-of(poData, OpenEdge.Core.String) or
            when type-of(poData, ICharacterHolder) or
            when type-of(poData, ILongcharHolder) then
            do:
                // coerce into using the LONGCHAR version
                assign lcJson = dynamic-property(poData, 'Value':u).
                
                // longchars are passed by-value, so don't do that
                cast(this-object:Entity, ByteBucket):PutString(lcJson).                
                return length(lcJson, 'raw':u).
            end.    // characters
            
            when type-of(poData, FileInputStream) then
            do:
                assign fileStream = cast(poData, FileInputStream).
                case entry(num-entries(fileStream:FileName, '.':u), fileStream:FileName, '.':u):
                    when 'json':u then
                        return WriteFileStream(fileStream). 
                    otherwise 
                    return error new AppError(substitute('Unsupported file extension .&1 for JSON', 
                                                    entry(num-entries(fileStream:FileName, '.':u), fileStream:FileName, '.':u))
                                    , 0).
                end case.
            end.    // file stream
            
            when type-of(poData, Progress.Lang.Error) then
                return this-object:Write(WriteError(cast(poData, Progress.Lang.Error))).
            
            otherwise
                return error new AppError(
                                substitute('Unsupported object type: &1', poData:GetClass():TypeName)
                                , 0).
        end case.
        
        return 0.
    end method.
    
    /* Writes an error into a known/consistent format 
       
       @param Progress.Lang.Error The error to write.
       @return JsonObject JSON representation of the error */
    method private JsonObject WriteError(input poError as Progress.Lang.Error):
        define variable oResponse as JsonObject no-undo.
        define variable oError as JsonObject no-undo.
        define variable oErrorList as JsonArray no-undo.
        define variable iLoop as integer no-undo.
        define variable cRetVal as character no-undo.
        define variable iMax as integer no-undo.
        define variable oProp as Progress.Reflect.Property no-undo.
        define variable oInner as Progress.Lang.Error no-undo.

        Assert:NotNull(poError, 'Error').
        
        /* build the current error */
         assign oResponse  = new JsonObject()
                oErrorList = new JsonArray()
                iMax       = poError:NumMessages
                .
        if type-of(poError, AppError) then
            oResponse:Add('_retVal':u, cast(poError, AppError):ReturnValue).
        
        oResponse:Add('_errors':u, oErrorList).
        do iLoop = 1 to iMax:
            assign oError = new JsonObject().
            oErrorList:Add(oError).
            
            oError:Add('_errorMsg':u, poError:GetMessage(iLoop)).
            oError:Add('_errorNum':u, poError:GetMessageNum(iLoop)).
        end.
        
        if session:debug-alert then
            oResponse:Add('_type':u, poError:GetClass():TypeName).
            
        if not poError:CallStack eq ? then
        do:
            assign oErrorList = new JsonArray()
                   iMax       = num-entries(poError:CallStack, StringConstant:LF)
                   .
            oResponse:Add('_stack':u, oErrorList).
            do iLoop = 1 to iMax:
                oErrorList:Add(entry(iLoop, poError:CallStack, StringConstant:LF)).
            end.
        end.
        
        assign oProp = poError:GetClass():GetProperty('InnerError':u).
        if      valid-object(oProp) 
           and oProp:DataType eq Progress.Reflect.DataType:Object 
           and Progress.Lang.Class:GetClass(oProp:DataTypeName):IsA(get-class(Progress.Lang.Error)) 
           then
        do:           
            assign oInner = oProp:Get(poError).
            if valid-object(oInner) then
                this-object:WriteError(oInner).
        end.
        
        return oResponse.
    end method.

    method public int64 WriteHandle(input phData as handle):
        return this-object:Write(phData).
    end method.
    
    method override public int64 Write(input phData as handle):        
        define variable iBytesWritten as int64 no-undo.
        define variable mJson as memptr no-undo.
        
        if valid-handle(phData) then
        do:
            case phData:type:
                when DataTypeHelper:GetMask(DataTypeEnum:TempTable) or
                when DataTypeHelper:GetMask(DataTypeEnum:Buffer) or
                when DataTypeHelper:GetMask(DataTypeEnum:Dataset) then
                    phData:write-json(DataTypeEnum:Memptr:ToString(), mJson, session:debug-alert).
                
                otherwise
                    return error new AppError(
                                    substitute('Unsupported handle type: &1', phData:type)
                                    , 0).
            end case.
            
            assign iBytesWritten = get-size(mJson).        
            cast(this-object:Entity, ByteBucket):PutBytes(mJson).
        end.
        else
        do:
            cast(this-object:Entity, ByteBucket):Clear().
            
            cast(this-object:Entity, ByteBucket):PutString(lc(string(JsonDataTypeEnum:Null))).
            assign iBytesWritten = length(lc(string(JsonDataTypeEnum:Null)), 'raw':u).
        end.
        
        return iBytesWritten.
        finally:
            set-size(mJson) = 0.
        end finally.
    end method.
    
end class.