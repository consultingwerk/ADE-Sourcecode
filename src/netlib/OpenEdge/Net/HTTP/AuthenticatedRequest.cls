/************************************************
Copyright (c)  2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : AuthenticatedRequest
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Jan 30 09:35:29 EST 2015
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Net.HTTP.AuthenticationMethodEnum.
using OpenEdge.Net.HTTP.Credentials.
using OpenEdge.Net.HTTP.Filter.Writer.AuthenticationRequestWriterBuilder.
using OpenEdge.Net.HTTP.HttpRequestDecorator.
using OpenEdge.Net.HTTP.IAuthenticatedRequest.
using OpenEdge.Net.HTTP.IHttpMessageWriter.
using OpenEdge.Net.HTTP.IHttpRequest.
using Progress.Lang.Class.
using Progress.Lang.Object.
using OpenEdge.Net.HTTP.Filter.Auth.IAuthFilterEventHandler.
using OpenEdge.Net.HTTP.Filter.IFilterEvents.

class OpenEdge.Net.HTTP.AuthenticatedRequest inherits HttpRequestDecorator  
        implements IAuthenticatedRequest:
    
    /** a list of listeners for this request */
    define private variable moEventListener as IAuthFilterEventHandler extent no-undo.
    
    /** The authentication method for this request. Defaults to none/blankNone */
    define public property AuthenticationMethod as character no-undo get. private set.
    
    /** Credentials  to be used for authentication */
    define public property Credentials as Credentials no-undo get. set.
    
    /** The challenge text required for creating the authentication response, 
        typically from a 401/Unauthorized response. This is usually the contents
        of the WWW-Authenticate header, but might also be a chunk of HTML for 
        Forms-based authentication requests.        */
    define public property AuthenticationChallenge as character no-undo get. private set.
    
    constructor public AuthenticatedRequest(input poHttpRequest as IHttpRequest):
        super(poHttpRequest).
        
        assign this-object:AuthenticationMethod = string(AuthenticationMethodEnum:None).
    end constructor.

    /** Add authentication to this request. */
    method public void AddAuthentication():
        define variable oAuthWriter as IHttpMessageWriter no-undo.
        
        assign oAuthWriter = AuthenticationRequestWriterBuilder:Build(this-object, moEventListener).
        if valid-object (oAuthWriter) then
        do:
            oAuthWriter:Open().
            oAuthWriter:Flush().
            oAuthWriter:Close().
        end.
        
        assign oAuthWriter = ?.
    end method.
    
    /** Sets the authentication challenge information for this request. 
        
        @param character The authentication method
        @param character The challenge text     */
    method public void SetChallenge(input pcAuthMethod as character,
                                    input pcChallenge as character):
        Assert:NotNullOrEmpty(pcAuthMethod, 'Authentication method').
        
        assign this-object:AuthenticationMethod    = pcAuthMethod
               this-object:AuthenticationChallenge = pcChallenge.
    end method.
    
    /** Adds a subscriber to the events from this request
        
        @param IAuthFilterEventHandler The EventProvider.   */
    method public void AddAuthenticationCallback(input poListener as IAuthFilterEventHandler):
        define variable oNewArray as IAuthFilterEventHandler extent no-undo.
        define variable iOldArraySize as integer no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable iIdx as integer no-undo.

        Assert:NotNull(poListener, 'Listener').
                        
        assign iOldArraySize = extent(moEventListener).
        if iOldArraySize eq ? then
            assign iOldArraySize = 0.
        
        /* Add existing items to the new array */
        assign extent(oNewArray) = iOldArraySize + 1
               iIdx = 1. 
        
        do iLoop = 1 to iOldArraySize:
            /* don't add invalid object */
            if not valid-object(moEventListener[iLoop]) then
                next.
            
            /* we have it in our list already */
            if moEventListener[iLoop]:Equals(poListener) then
                return.
            
            /* we're starting at 1 , so increment *after* */
            assign oNewArray[iIdx] = moEventListener[iLoop]
                   iIdx = iIdx + 1.
        end.
        
        assign extent(moEventListener) = ?
               oNewArray[iIdx] = poListener
               moEventListener = oNewArray.
    end method.
    
    method public void RemoveAuthenticationCallback(input poListener as IAuthFilterEventHandler):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
        assign iMax = extent(moEventListener).
        do iLoop = 1 to iMax:
            /* remove all instances */
            if moEventListener[iLoop]:Equals(poListener) then
                assign moEventListener[iLoop] = ?.
        end.
    end method.

    /** Returns the registered listeners.
        
        @param IAuthFilterEventHandler[] An array of listeners 
        @return integer The number of registgered listeners. */    
    method public integer GetAuthenticationCallbacks(output poListener as IAuthFilterEventHandler extent).
        assign poListener = moEventListener. 
        return extent(moEventListener).
    end method.
    
end class.
