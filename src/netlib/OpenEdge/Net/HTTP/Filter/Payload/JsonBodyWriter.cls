/************************************************
Copyright (c)  2015-2016 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : JsonBodyWriter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Jan 29 10:47:13 EST 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.ByteBucket.
using OpenEdge.Core.Memptr.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Lang.Object.
using Progress.Lang.AppError.
using OpenEdge.Core.WidgetHandle.
using OpenEdge.Core.String.
using OpenEdge.Core.DataTypeEnum.
using OpenEdge.Core.DataTypeHelper.
using Ccs.Common.Support.IHandleHolder.
using Ccs.Common.Support.IMemptrHolder.
using Ccs.Common.Support.ILongcharHolder.
using OpenEdge.Core.Collections.IStringKeyedMap.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.MapBackedCollection.
using OpenEdge.Core.Collections.MapEntry.
using Progress.Json.ObjectModel.JsonObject.
using OpenEdge.Core.JsonDataTypeEnum.

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
    
    method override public int64 Write( input poData as Object):
        define variable mJson as memptr no-undo.
        define variable hData as handle no-undo.
        define variable iBytesWritten as int64 no-undo.
        
        case true:
            when not valid-object(poData) then
            do:
                cast(this-object:Entity, ByteBucket):Clear().
                
                cast(this-object:Entity, ByteBucket):PutString(lc(string(JsonDataTypeEnum:Null))).
                return length(lc(string(JsonDataTypeEnum:Null)), 'raw':u).
            end.    // nulls/empty  
            
            when type-of(poData, Memptr) then
            do:
                cast(this-object:Entity, ByteBucket):PutBytes(cast(poData, Memptr)).
                return cast(poData, Memptr):Size.
            end.
            
            when type-of(poData, IMemptrHolder) then
                return this-object:Write(cast(poData, IMemptrHolder):Value).
            
            when type-of(poData, JsonConstruct) then
                cast(poData, JsonConstruct):Write(mJson, session:debug-alert).

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
            
            when type-of(poData, OpenEdge.Core.String) then
            do:
                cast(this-object:Entity, ByteBucket):PutString(cast(poData, String)).
                return cast(poData, String):Size.
            end.

            when type-of(poData, ILongcharHolder) then
                return this-object:Write(cast(poData, ILongcharHolder):Value).
            
            otherwise
                return error new AppError(
                                substitute('Unsupported object type: &1', poData:GetClass():TypeName)
                                , 0).
        end case.
        
        /* Add the JSON to the message body's bytebucket */
        assign iBytesWritten = get-size(mJson).
        cast(this-object:Entity, ByteBucket):PutBytes(get-pointer-value(mJson),
                                         iBytesWritten).
        
        return iBytesWritten.
        finally:
            set-pointer-value(mJson) = 0.
            set-size(mJson) = 0.
        end finally.
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
            set-pointer-value(mJson) = 0.
            set-size(mJson) = 0.
        end finally.
    end method.

    
end class.