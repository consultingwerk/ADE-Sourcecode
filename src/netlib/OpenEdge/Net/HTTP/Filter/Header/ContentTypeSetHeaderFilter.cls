/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : ContentTypeSetHeaderFilter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge 
    Created     : Thu Feb 12 09:08:39 EST 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Net.HTTP.HttpHeader.
using OpenEdge.Net.HTTP.IHttpMessageWriter.
using Progress.Lang.Object.
using OpenEdge.Net.HTTP.IHttpMessage.

class OpenEdge.Net.HTTP.Filter.Header.ContentTypeSetHeaderFilter implements IHttpMessageWriter: 
    
    define private variable mcContentType as character no-undo.
    define private variable mcCharset as character no-undo.
    
	define public property Message as IHttpMessage no-undo get. private set. 

    constructor public ContentTypeSetHeaderFilter(input poMessage as IHttpMessage):
        Assert:NotNull(poMessage, 'Http message').
        assign this-object:Message = poMessage.
    end constructor.

	method public void Open(  ):
	    assign mcContentType = '':u
               mcCharset     = '':u.        
	end method.

	method public void Write( input poData as Object):
	    define variable oHeader as HttpHeader no-undo.
        Assert:IsType(poData, get-class(HttpHeader)).

        assign oHeader       = cast(poData, HttpHeader)
               mcContentType = trim(entry(1, oHeader:Value, ';':u))
               mcCharset     = GetHeaderParameterValue(oHeader:Value, 'charset':u).        
	end method.

	method public void Write( input-output pcData as longchar ):
	    define variable cData as character no-undo.
	    
	    assign cData = string(pcData).
        
        this-object:Write(input-output cData).
        
        assign pcData = cData.	    
	end method.

    method public void Write( input-output pcData as character):
        assign mcContentType = trim(entry(1, pcData, ';':u))
               mcCharset     = GetHeaderParameterValue(pcData, 'charset':u).        
    end method.
	
	method public void Write(input pmData as memptr ):
	    define variable cData as character no-undo.
	    assign cData = get-string(pmData, 1).
	    this-object:Write(input-output cData).
	end method.
	
	method public void Write( input phData as handle):
        /* no-op */
    end method.

	method public void Flush(  ):
	           /* content type */
        assign this-object:Message:ContentType = mcContentType
               /* encoding */
               this-object:Message:CharacterEncoding = mcCharset.	    
	end method.

	method public void Close(  ):
	    Flush().
	end method.
	
    /** Returns the 'charset' parameter from a (for example) Content-Type header value 
        
        @param character  The header value
        @param character  The name of the parameter value to retrieve
        @return character The charset paremeter value; blank/empty otherwise */
    method private character GetHeaderParameterValue(input pcValue as character,
                                                     input pcParamName as character):
        define variable cParam as character no-undo.
        define variable iLoop as integer no-undo.
        define variable cParamValue as character no-undo.
        define variable iMax as integer no-undo.
        
        Assert:NotNull(pcValue, 'Header value').
        Assert:NotNullOrEmpty(pcParamName, 'Param name').
                      
        if pcValue eq ? then
            return '':u.
        
        assign iMax = num-entries(pcValue, ';':u).
        /* first entry is the content type (eg text/plain) */
        do iLoop = 2 to iMax while cParamValue eq '':u:
            assign cParam = trim(entry(iLoop, pcValue, ';':u)).
            if entry(1, cParam, '=':u) eq pcParamName then
                assign pcParamName = entry(2, cParam, '=':u).
        end.
        
        return cParamValue.
    end method.
    
end class.