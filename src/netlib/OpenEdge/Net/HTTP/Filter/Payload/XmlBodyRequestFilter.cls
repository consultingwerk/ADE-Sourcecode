/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : XmlBodyRequestFilter
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
using OpenEdge.Net.HTTP.Filter.Payload.DefaultRequestFilter.
using OpenEdge.Net.HTTP.IHttpRequest.

class OpenEdge.Net.HTTP.Filter.Payload.XmlBodyRequestFilter inherits DefaultRequestFilter:
	constructor public XmlBodyRequestFilter(input poMessage as IHttpRequest):
		super (input poMessage).
	end constructor.
	
	method override protected ByteBucket ExtractEntity():
        define variable hDocument as handle no-undo.
        define variable mXml as memptr no-undo.
        define variable oBody as ByteBucket no-undo.
        
        Assert:IsType(this-object:Message:Entity, get-class(WidgetHandle)).
                
        assign hDocument = cast(this-object:Message:Entity, WidgetHandle):Value.
        
        hDocument:save('memptr':u, mXml).
        
        /* Add the JSON to the message body's bytebucket */
        assign oBody = ByteBucket:Instance()
               this-object:Message:CharacterEncoding = hDocument:encoding.
        
        oBody:PutBytes(get-pointer-value(mXml), get-size(mXml)).
        
        return oBody.
        finally:
            set-size(mXml) = 0.
        end finally.	    
	end method.

end class.