/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : XmlBodyWriter
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
using OpenEdge.Core.WidgetHandle.
using OpenEdge.Net.HTTP.Filter.Payload.MessageWriter.
using OpenEdge.Net.ISupportEncoding.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.Filter.Payload.XmlBodyWriter inherits MessageWriter
        implements ISupportEncoding:
    /* Content encoding (eg utf-8) used by the implementer */ 
    define public property Encoding as character no-undo get. set. 

    constructor public XmlBodyWriter():
        super(get-class(ByteBucket )).
    end constructor.
    
    method override public int64 Write(input poData as Object):
        define variable hDocument as handle no-undo.
        define variable mXml as memptr no-undo.
        define variable cCharset as character no-undo.
        
        Assert:IsType(poData, get-class(WidgetHandle)).
        
        assign hDocument = cast(poData, WidgetHandle):Value.
        
        hDocument:save('memptr':u, mXml).
        
        /* Add the JSON to the message body's bytebucket */
        
        /* convert to ISO format from ABL */
        run adecomm/convcp.p (input  hDocument:encoding,
                              input  'toMime':u,
                              output cCharset).
        assign this-object:Encoding = cCharset.
        
        cast(this-object:Entity, ByteBucket):PutBytes(get-pointer-value(mXml), get-size(mXml)).
        
        return get-size(mXml).
        finally:
            set-size(mXml) = 0.
        end finally.        
    end method.

end class.