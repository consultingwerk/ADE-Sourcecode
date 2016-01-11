/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : XmlBodyFilter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Feb 17 13:06:38 EST 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.ByteBucket.
using OpenEdge.Core.WidgetHandle.
using OpenEdge.Net.HTTP.Filter.Body.MessageBodyFilter.
using OpenEdge.Net.HTTP.HttpMessage.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.Filter.Body.XmlBodyFilter inherits MessageBodyFilter: 
    define private variable mcTypes as character extent 5 no-undo
        initial ['text/xml',
                 'application/xml',
                 'text/xml-external-parsed-entity',
                 'application/xml-external-parsed-entity',
                 'application/xml-dtd'].
    
    constructor public XmlBodyFilter(input poMessage as HttpMessage):
		super(mcTypes, poMessage).
    end constructor.
    
    /** Replaces any existing object with XML content. this is not an append. */
	method override public logical ExtractBody(input-output poEntity as Object):
        define variable hDocument as handle no-undo.
        
        create x-document hDocument.
        hDocument:load('memptr',
                       this-object:Message:MessageBody:GetBytes():Value,
                       true).
        assign poEntity = new WidgetHandle(hDocument).
        
        return true.
	end method.
	
	/** Replaces any existing message body with XML content. this is not an append. */
    method override public logical InsertBody(input-output poMessageBody as ByteBucket):
        define variable hDocument as handle no-undo.
        define variable mDocument as memptr no-undo.
        
        hDocument = cast(this-object:Message:Entity, WidgetHandle):Value.
        hDocument:save('memptr', mDocument).
        
        if not valid-object(poMessageBody) then
            poMessageBody = ByteBucket:Instance().
        
        poMessageBody:PutBytes(get-pointer-value(mDocument), get-size(mDocument)).
         
        return true.
        finally:
            set-size(mDocument) = 0.
        end finally.
	end method.
	
end class.