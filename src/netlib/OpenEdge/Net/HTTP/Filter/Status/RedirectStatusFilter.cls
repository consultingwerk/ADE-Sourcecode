/************************************************
Copyright (c) 2014-2016, 2018 by Progress Software Corporation. All rights reserved.
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
using OpenEdge.Core.String.
using OpenEdge.Logging.ILogWriter.
using OpenEdge.Logging.ISupportLogging.
using OpenEdge.Logging.LoggerBuilder.
using OpenEdge.Net.HTTP.IHttpMessage.
using OpenEdge.Net.HTTP.IHttpMessageWriter.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.IHttpResponse.
using OpenEdge.Net.URI.
using Progress.Lang.Object.
using OpenEdge.Net.HTTP.Filter.Status.RedirectStatusFilter.

class OpenEdge.Net.HTTP.Filter.Status.RedirectStatusFilter implements IHttpMessageWriter, ISupportLogging:
    define public property Logger as ILogWriter no-undo get. set.
    
    /** (mandatory) The message that's being written to. The values passed in to the Write() methods
        will be parsed/processed and writted to this message. */  
    define public property Message as IHttpMessage no-undo get. private set. 
    
    define private variable mcData as character no-undo.
    
    /* Constructor.
       
       @param IHttpRequest The request for to which this status response applies */
    constructor public RedirectStatusFilter(input poMessage as IHttpRequest):
        Assert:NotNull(poMessage, 'Http request').
        
        assign this-object:Message = poMessage
               this-object:Logger  = LoggerBuilder:GetLogger(get-class(RedirectStatusFilter))
               .
    end constructor.
    
    method public void Close():
        Flush().
        
        assign mcData = '':u.
    end method.
    
    method public void Flush():
        define variable requestUri as URI no-undo.
        
        if String:IsNullOrEmpty(mcData) then
            return.
        
        assign requestUri = cast(this-object:Message, IHttpRequest):URI. 
        Logger:Debug(substitute('Redirect from URL "&1" to "&2"':u,
                        string(requestUri), mcData) ).
        
        assign requestUri                                  = URI:ResolveRelativeReference(requestUri, mcData)
               cast(this-object:Message, IHttpRequest):URI = requestUri
               .
        Logger:Debug(substitute('Redirect URL: &1':u, string(requestUri))).
    end method.
    
    method public void Open():
        assign mcData = '':u.
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
        
        /* The value of the Location header is the new host/path
           We will always get some value back, even if it's just ? */
        assign mcData = cast(poData, IHttpResponse):GetHeader('Location':u):Value.
        
        Logger:Debug(substitute('HTTP status &1':u, cast(poData, IHttpResponse):StatusCode)).
    end method.
    
end class.