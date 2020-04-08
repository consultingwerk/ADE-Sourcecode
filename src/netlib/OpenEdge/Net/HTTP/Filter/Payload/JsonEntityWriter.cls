/************************************************
Copyright (c) 2015-2019 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : JsonEntityWriter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Jan 29 10:47:13 EST 2015
    Notes       : - Write() operations are destructive (they replace the existing
                    Entity).
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.ICharacterHolder.
using Ccs.Common.Support.IHandleHolder.
using Ccs.Common.Support.ILongcharHolder.
using Ccs.Common.Support.IPrimitiveArrayHolder.
using OpenEdge.Core.Assert.
using OpenEdge.Core.ByteBucket.
using OpenEdge.Core.Collections.IMap.
using OpenEdge.Core.Collections.IMapEntry.
using OpenEdge.Core.DataTypeEnum.
using OpenEdge.Core.DataTypeHelper.
using OpenEdge.Core.Json.IJsonSerializer.
using OpenEdge.Core.Json.JsonConverter.
using OpenEdge.Core.KeyValuePair.
using OpenEdge.Core.Memptr.
using OpenEdge.Net.HTTP.Cookie.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using OpenEdge.Net.HTTP.HttpHeader.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.ObjectModelParser.
using Progress.Lang.AppError.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.Filter.Payload.JsonEntityWriter inherits MessageWriter:
    // we may parse multiple inputs; keep this around
    define private variable moParser as ObjectModelParser no-undo.
    
    /* Default constructor */    
    constructor public JsonEntityWriter():
        this-object(get-class(JsonConstruct)).
    end constructor. 
    
    /** Default constructor. */
    constructor protected JsonEntityWriter(input pType as class Progress.Lang.Class):
        super(pType).
    end constructor.
    
    /* Opens the writer */
    method override public void Open():       
        super:Open().
        
        assign moParser = new ObjectModelParser().
    end method.
    
    /* Closes the writer */
    method override public void Close():
        super:Close().
        
        assign moParser = ?.
    end method.
    
    /* Writes an HTTP  Cookie into a JSON property & value
       
       @param Cookie THe cookie to write        */
    method protected JsonObject Write(input pCookie as Cookie):
        define variable cookie as JsonObject no-undo.
        
        assign cookie = new JsonObject().
        cookie:Add('name':u, pCookie:Name).
        cookie:Add('value':u, pCookie:Value).
        cookie:Add('path':u, pCookie:Path).
        cookie:Add('domain':u, pCookie:Domain).
        cookie:Add('expires':u, pCookie:ExpiresAt).
        cookie:Add('httpOnly':u, pCookie:HttpOnly).
        cookie:Add('secure':u, pCookie:Secure).
        
        return cookie.
    end method.

    /* Writes an HTTP header into a JSON property & value
       
       @param HttpHeader The header to write */
    method protected JsonObject Write(input pHeader as HttpHeader):
        define variable hdr as JsonObject no-undo.
        
        assign hdr = new JsonObject().
        hdr:Add('name':u, pHeader:Name).
        hdr:Add('value':u, pHeader:GetBaseValue() + pHeader:GetParameterValues()).
    end method.
    
    /* Writes a tuple (key-value pair) as a JSON property & value
       
       @param Progress.Lang.Object The key value - property name (required)
       @param Progress.Lang.Object A value to be written for teh proeprty. May be null. */
    method protected void WriteTuple(input pKey as Progress.Lang.Object,
                                     input pValue as Progress.Lang.Object):
        define variable jsonData as JsonObject no-undo.
        
        Assert:NotNull(pKey, 'Tuple key').
        
        assign jsonData = JsonConverter:ToObject(pKey, pValue).
        
        if valid-object(this-object:Entity) then
        do:
            if type-of(this-object:Entity, JsonObject) then
                JsonConverter:Merge(cast(this-object:Entity, JsonObject),
                                    jsonData,
                                    true).
            else
            // JsonArray
                cast(this-object:Entity, JsonArray):Add(jsonData).
        end.
        else
            assign this-object:Entity = jsonData.
    end method.
    
    method protected void WriteMap(input pValue as IMap):
        assign this-object:Entity = JsonConverter:ToObject(pValue).
    end method.
    
    method protected void WriteError(input poError as Progress.Lang.Error):
        define variable oErrorList as JsonArray no-undo.
        define variable oResponse as JsonObject no-undo.
        
        assign oResponse = JsonConverter:ToObject(poError).
        
        case true:
            // single error? add an simple JSON object
            when not valid-object(this-object:Entity) then
                assign this-object:Entity = oResponse.
            
            // if there's already an array, add to it
            when type-of(this-object:Entity, JsonArray) then
                cast(this-object:Entity, JsonArray):Add(oResponse).
            
            // if there's a single json object, switch to an array
            when type-of(this-object:Entity, JsonObject) then
            do:
                assign oErrorList = new JsonArray().
                oErrorList:Add(cast(this-object:Entity, JsonObject)).
                oErrorList:Add(oResponse).
                
                assign this-object:Entity = oErrorList.
            end.
        end case.
    end method.
    
    /** Write data to/from the message
        
        @param Progress.Lang.Object Data to write 
        @return int64 The number ofbytes written 
        @throws P.L.AppError if an type is not supported */
    method override public int64 Write(input poData as Object):
        define variable oBody as class Memptr no-undo.
        
        case true:
            when not valid-object(poData) then
            do:
                assign this-object:Entity = new JsonObject().
                return 0.
            end.
            
            // first try the object's own serialization, then the hard-coded ones below
            when type-of(poData, IJsonSerializer) then
            do:
                assign this-object:Entity = cast(poData, IJsonSerializer):ToJsonConstruct().
                if not valid-object(this-object:Entity) then
                    assign this-object:Entity = new JsonObject().
                
                return 0.
            end.
            
            when type-of(poData, Progress.Lang.Error) then
            do:
                WriteError(cast(poData, Progress.Lang.Error)).
                return 0.
            end.
            
            when type-of(poData, Memptr) then
            do:
                assign oBody = cast(poData, Memptr).
                if oBody:Size eq 0 then
                    assign this-object:Entity = new JsonObject().
                else
                    assign this-object:Entity = cast(moParser:Parse(oBody:Value) , JsonConstruct).
                
                return oBody:Size.
            end.
            
            when type-of(poData, JsonConstruct) then
            do:
                assign this-object:Entity = poData.
                return 0.
            end.
            
            when type-of(poData, ByteBucket) then
            do:
                assign oBody = cast(poData, ByteBucket):GetBytes().
                if oBody:Size eq 0 then
                    assign this-object:Entity = new JsonObject().
                else
                    assign this-object:Entity = cast(moParser:Parse(oBody:Value) , JsonConstruct).
                
                return oBody:Size.
            end.
            
            when type-of(poData, IMap) then
            do:
                this-object:WriteMap(cast(poData, IMap)).
                return 0.
            end.
            
            when type-of(poData, IMapEntry) then
            do:
                this-object:WriteTuple(cast(poData, IMapEntry):Key,
                                       cast(poData, IMapEntry):Value).
                return 0.
            end.
            
            when type-of(poData, KeyValuePair) then
            do:
                this-object:WriteTuple(cast(poData, KeyValuePair):Key,
                                       cast(poData, KeyValuePair):Value).
                return 0.
            end.
            
            when type-of(poData, ILongcharHolder) then
                return this-object:Write(cast(poData, ILongcharHolder):Value).
            
            when type-of(poData, ICharacterHolder) then
                return this-object:Write(cast(poData, ICharacterHolder):Value).
            
            when type-of(poData, IPrimitiveArrayHolder) then
                assign this-object:Entity = JsonConverter:ToArray(cast(poData, IPrimitiveArrayHolder)). 
            
            when type-of(poData, IHandleHolder) then
                return this-object:WriteHandle(cast(poData, IHandleHolder):Value).
            
            when type-of(poData, Cookie) then
                return this-object:Write(this-object:Write(cast(poData, Cookie))).
            
            when type-of(poData, HttpHeader) then
                return this-object:Write(this-object:Write(cast(poData, HttpHeader))).
            
            otherwise
                return error new AppError(
                            substitute('Unsupported object type: &1', poData:GetClass():TypeName)
                            , 0).
        end case.
        
        return 0.
    end method.
    
    /** Write data to/from the message
        
        @param longchar Data to write 
        @return int64 The number ofbytes written */
    method override public int64 Write(input pcData as longchar):
        define variable iBytesWritten as integer no-undo.
        
        assign iBytesWritten = length(pcData, 'raw':u).
        
        Assert:IsZeroOrPositive(iBytesWritten, 'Data').
        
        if iBytesWritten eq 0 then
            assign this-object:Entity = new JsonObject().
        else
            assign this-object:Entity = cast(moParser:Parse(pcData), JsonConstruct).
        
        return iBytesWritten.
    end method.
    
    /** Write data to/from the message
        
        @param memptr Data to write 
        @return int64 The number ofbytes written */
    method override public int64 Write( input pmData as memptr):
        define variable iBytesWritten as integer no-undo.
        
        assign iBytesWritten = get-size(pmData).
        Assert:IsZeroOrPositive(iBytesWritten, 'Data size').
        
        if iBytesWritten eq 0 then
            assign this-object:Entity = new JsonObject().
        else
           assign this-object:Entity = cast(moParser:Parse(pmData), JsonConstruct).
        
        return iBytesWritten.
    end method.
    
    /** Write data to/from the message
        
        @param handle Data to write 
        @return int64 The number ofbytes written */
    method public int64 WriteHandle(input phData as handle):
        return this-object:Write(phData).
    end method.
    
    /** Write data to/from the message
        
        @param handle Data to write 
        @return int64 The number ofbytes written */
    method override public int64 Write(input phData as handle):
        define variable lOk as logical no-undo.
        define variable oData as JsonObject no-undo.
        
        Assert:NotNull(phData, 'Data').
        
        case phData:type:
            when DataTypeHelper:GetMask(DataTypeEnum:Buffer) or
            when DataTypeHelper:GetMask(DataTypeEnum:TempTable) or
            when DataTypeHelper:GetMask(DataTypeEnum:Dataset) then
                assign oData = new JsonObject()
                       this-object:Entity = oData
                       lOk = oData:Read(phData)
                       .
            
            /* this should cater for WEB-CONTEXT and that only. */
            when 'pseudo-widget':u then
                if lookup('HTML-CHARSET':u, list-query-attrs(phData)) gt 0 then
                    assign this-object:Entity = cast(moParser:Parse(phData), JsonConstruct).
        end case.
        
        return ?.
    end method.
    
    /** Write data to/from the message
        
        @param character Data to write 
        @return int64 The number ofbytes written */
    method override public int64 Write(input pcData as character):
        define variable iBytesWritten as integer no-undo.
        
        assign iBytesWritten = length(pcData, 'raw':u).
        
        Assert:IsZeroOrPositive(iBytesWritten, 'Data').
        
        if iBytesWritten eq 0 then
            assign this-object:Entity = new JsonObject().
        else
            assign this-object:Entity = cast(moParser:Parse(pcData), JsonConstruct).
        
        return iBytesWritten.
    end method.
    
end class.