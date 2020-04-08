/************************************************
Copyright (c) 2015-2019 by Progress Software Corporation. All rights reserved.
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
using Ccs.Common.Support.IPrimitiveArrayHolder.
using OpenEdge.Core.ByteBucket.
using OpenEdge.Core.Collections.Array.
using OpenEdge.Core.Collections.ICollection.
using OpenEdge.Core.Collections.IMap.
using OpenEdge.Core.DataTypeEnum.
using OpenEdge.Core.DataTypeHelper.
using OpenEdge.Core.IObjectArrayHolder.
using OpenEdge.Core.Json.IJsonSerializer.
using OpenEdge.Core.JsonDataTypeEnum.
using OpenEdge.Core.Memptr.
using OpenEdge.Core.Session.
using OpenEdge.Logging.Logger.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using Progress.IO.FileInputStream.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Lang.AppError.
using Progress.Lang.Object.
using OpenEdge.Core.Json.JsonConverter.

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
    
    method protected int64 Write(input poData as Object extent):
        define variable jsonData as JsonArray no-undo.
        
        assign jsonData = JsonConverter:ToArray(poData).
        
        return this-object:Write(jsonData).
    end method.
    
    method override public int64 Write(input poData as Object):
        define variable mJson as memptr no-undo.
        define variable lcJson as longchar no-undo.
        define variable iBytesWritten as int64 no-undo.
        define variable fileStream as FileInputStream no-undo.
        define variable objArray as Progress.Lang.Object extent no-undo.
        define variable jsonData as JsonObject no-undo.
        
        // JSON is defined as UTF-8
        fix-codepage(lcJson) = 'utf-8':u.
        
        case true:
            when not valid-object(poData) then
            do:
                cast(this-object:Entity, ByteBucket):Clear().
                
                cast(this-object:Entity, ByteBucket):PutString(lc(string(JsonDataTypeEnum:Null))).
                return length(lc(string(JsonDataTypeEnum:Null)), 'raw':u).
            end.    // nulls/empty  
            
            // first try the object's own serialization, then the hard-coded ones below
            when type-of(poData, IJsonSerializer) then
                return this-object:Write(cast(poData, IJsonSerializer):ToJsonConstruct()).
            
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
                cast(poData, JsonConstruct):Write(mJson).   //, session:debug-alert).
                
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
            
            when type-of(poData, IMap) then
                return this-object:Write(JsonConverter:ToObject(cast(poData, IMap))).
            
            when type-of(poData, ICollection) then
                return this-object:Write(JsonConverter:ToArray(cast(poData, ICollection))).
            
            when type-of(poData, IPrimitiveArrayHolder) then
                return this-object:Write(JsonConverter:ToArray(cast(poData, IPrimitiveArrayHolder))).
            
            // object array types
            when type-of(poData, IObjectArrayHolder) then
                return this-object:Write(JsonConverter:ToArray(cast(poData, IObjectArrayHolder))).
                
            when type-of(poData, Array) then
                return this-object:Write(cast(poData, Array):ToArray()).
            
            when type-of(poData, OpenEdge.Core.String) or
            when type-of(poData, ICharacterHolder) or
            when type-of(poData, ILongcharHolder) then
            do:
                // coerce into using the LONGCHAR version
                assign lcJson = dynamic-property(poData, 'Value':u).
                
                // longchars are passed by-value, so don't do that
                cast(this-object:Entity, ByteBucket):PutString(lcJson, 'utf-8':u).
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
                return this-object:Write(JsonConverter:ToObject(cast(poData, Progress.Lang.Error))).
            
            otherwise
                return error new AppError(
                                substitute('JsonBodyWriter cannot convert object type &1 to JSON ', poData:GetClass():TypeName)
                                , 0).
        end case.
        
        return 0.
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
                do:
                    def var timer as datetime-tz extent 2.
                    timer[1] = now.
                    phData:write-json(DataTypeEnum:Memptr:ToString(), mJson, session:debug-alert).
                    timer[2] = now.
                    
                    Logger:Trace(substitute('WRITE-JSON took &1ms', interval(timer[2], timer[1], 'milliseconds'))).
                end.
                
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