/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
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
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using Progress.Json.ObjectModel.JsonConstruct.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.Filter.Payload.JsonBodyWriter inherits MessageWriter: 
    
    constructor public JsonBodyWriter():
        super (get-class(ByteBucket)).
    end constructor.    
    
    method override public void Open():    
        if not valid-object(this-object:Entity) then
            assign this-object:Entity = ByteBucket:Instance().
        
        super:Open().
    end method.
    
    method override public int64 Write( input poData as Object):
        define variable mJson as memptr no-undo.
        define variable iBytesWritten as int64 no-undo.
        
        Assert:IsType(poData, get-class(JsonConstruct)).
        cast(poData, JsonConstruct):Write(mJson).
        
        /* Add the JSON to the message body's bytebucket */
        assign iBytesWritten = get-size(mJson).
        
        cast(this-object:Entity, ByteBucket):PutBytes(get-pointer-value(mJson),
                                         iBytesWritten).
        
        return iBytesWritten.
        finally:
            set-size(mJson) = 0.
        end finally.        
    end method.
    
end class.