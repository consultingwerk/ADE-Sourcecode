/************************************************
Copyright (c)  2014, 2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : RedirectStatusFilter
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Feb 17 13:06:38 EST 2014
    Notes       : - The Message for this writer is the REQUEST since it 
                    will retrieve data from the request (Location header) and
                    write a new URI to the request.
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Net.HTTP.IHttpMessage.
using OpenEdge.Net.HTTP.IHttpMessageWriter.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.URI.
using OpenEdge.Net.UriSchemeEnum.
using Progress.Lang.Object.

class OpenEdge.Net.HTTP.Filter.Status.RedirectStatusFilter implements IHttpMessageWriter:
     
    /** (mandatory) The message that's being written to. The values passed in to the Write() methods
        will be parsed/processed and writted to this message. */  
	define public property Message as IHttpMessage no-undo get. private set. 
	
	define private variable mcData as character no-undo.
	
    constructor public RedirectStatusFilter(input poMessage as IHttpRequest):
        Assert:NotNull(poMessage, 'Http request').
        
        assign this-object:Message = poMessage.
    end constructor.

	method public void Close():
	    Flush().
	end method.
	
	method public void Flush():
	    define variable oScheme as UriSchemeEnum no-undo.
	    
	    Assert:NotNullOrEmpty(mcData, 'Location').
	    
	    /* despite the spec, the Location may be a relative URI */
        assign oScheme = UriSchemeEnum:FromString(right-trim(entry(1, mcData, '/':u), ':':u)).
        if not valid-object(oScheme) then
            assign mcData = cast(this-object:Message, IHttpRequest):URI:BaseUri + mcData.

        cast(this-object:Message, IHttpRequest):URI = URI:Parse(string(mcData)).   	    
	end method.

	method public void Open():
	end method.
	
    /** Write data to/from the message

        @param handle Data to write */
    method public void Write(input phData as handle):    
        /* no-op */
    end method.

    /** Write data to/from the message

        @param character Data to write */
    method public void Write(input-output pcData as character):   
        Assert:NotNullOrEmpty(pcData, 'Location').
        
        assign mcData = pcData.
    end method.    

	method public void Write(input-output pcData as longchar):
	    Assert:NotNullOrEmpty(pcData, 'Location').
	    
        assign mcData = string(pcData).
	end method.

	method public void Write(input pmData as memptr):
	    Assert:IsPositive(get-size(pmData), 'Data size').	    
	    assign mcData = get-string(pmData, 1).
	end method.

	method public void Write(input poData as Object):
	    Assert:IsType(poData, get-class(IHttpResponse)).
	    
        /* the value of the Location header is the new host/path */
        if cast(poData, IHttpResponse):HasHeader('Location':u) then
            assign mcData = cast(poData, IHttpResponse):GetHeader('Location':u):Value.
	end method.

end class.