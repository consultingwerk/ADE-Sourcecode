/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : StringBodyWriter
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
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.Filter.Payload.StringBodyWriter inherits MessageWriter: 
        
    constructor public StringBodyWriter():
        super(get-class(ByteBucket)).
    end constructor.
    
    method override public int64 Write(input poData as Object):
        define variable iBytesBefore as int64 no-undo.
                
        Assert:NotNull(poData).
        
        assign iBytesBefore = cast(this-object:Entity, ByteBucket):Size. 
        
        cast(this-object:Entity, ByteBucket):PutString(poData:ToString()).
        
        return (cast(this-object:Entity, ByteBucket):Size - iBytesBefore).
    end method.

end class.