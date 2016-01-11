/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : HtmlBodyFilter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Feb 17 13:06:38 EST 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Net.HTTP.Filter.Body.MessageBodyFilter.
using OpenEdge.Net.HTTP.HttpMessage.
using OpenEdge.Core.String.
using OpenEdge.Core.ByteBucket.
using OpenEdge.Core.Memptr.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.Filter.Body.HtmlBodyFilter inherits MessageBodyFilter: 
    define private variable mcTypes as character extent 2 no-undo
        initial ['text/html', ''].
    
    constructor public HtmlBodyFilter(input poMessage as HttpMessage):
		super (mcTypes, poMessage).
    end constructor.
    
    /** Replaces any existing object with HTML content. this is not an append. */
    method override public logical ExtractBody(input-output poEntity as Object):
        define variable lcData as longchar no-undo.
        define variable cCharset as character no-undo.
        define variable cName as character no-undo.
        define variable cValue as character no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable oData as class Memptr no-undo.
        
        iMax = num-entries(this-object:Message:ContentTypeEncoding, ';').
        
        do iLoop = 1 to iMax:
            assign cName  = entry(iLoop, this-object:Message:ContentTypeEncoding, ';')
                   cValue = entry(2, cName, '=')
                   cName  = entry(1, cName, '=').
            
            if cName eq 'charset' then
                cCharset = cValue.
        end.
        
        if cCharset eq '' then
            cCharset = 'UTF-8'.
        
        fix-codepage(lcData) = cCharset.
        if this-object:Message:ContentLength gt 0 then
        do:
            oData = this-object:Message:MessageBody:GetBytes().
            copy-lob from oData:Value 
                        for this-object:Message:ContentLength /* - 1 */
                     to lcData.
        end.
        
        assign poEntity = new String(lcData).
        
        return true.
	end method.
	
    /** Replaces any existing message body with HTMl content. this is not an append. */
    method override public logical InsertBody(input-output poMessageBody as ByteBucket):
        if not valid-object(poMessageBody) then
            poMessageBody = ByteBucket:Instance().
        
        poMessageBody:PutString(cast(this-object:Message:Entity, String)).
        
        return true.        
    end method.
    
end class.