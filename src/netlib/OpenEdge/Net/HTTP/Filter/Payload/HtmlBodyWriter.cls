/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : HtmlBodyWriter
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
using OpenEdge.Core.String.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.Filter.Payload.HtmlBodyWriter inherits MessageWriter: 
        
    constructor public HtmlBodyWriter():
        super (get-class(ByteBucket)).
    end constructor.

    method override public void Open():
        /* If nothing's passed in, use a bucket of our own. 
           Don't do this in the constructor as a micro-optimisation (yes, I know) */
        if not valid-object(this-object:Entity) then
            assign this-object:Entity = ByteBucket:Instance().
        
        super:Open().
    end method.
    
    method override public int64 Write( input poData as Object):
        Assert:IsType(poData, get-class(String)).
        
        cast(this-object:Entity, ByteBucket):PutString(cast(poData, String)).
        
        return cast(poData, String):Size.
    end method.

end class.