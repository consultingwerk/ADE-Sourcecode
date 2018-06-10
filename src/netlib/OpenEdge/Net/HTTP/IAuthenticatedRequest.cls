/************************************************
Copyright (c) 2015, 2017 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : IAuthenticatedRequest
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Jan 28 21:19:56 EST 2015
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.Net.HTTP.Credentials.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.Filter.Auth.IAuthFilterEventHandler.

interface OpenEdge.Net.HTTP.IAuthenticatedRequest:
    
    /** The authentication method for this request. */
    define public property AuthenticationMethod as character no-undo get.
    
    /** Credentials to be used for authentication */
    define public property Credentials as Credentials no-undo get. set.
    
    /** The challenge text required for creating the authentication response, 
        typically from a 401/Unauthorized response. This is usually the contents
        of the WWW-Authenticate header, but might also be a chunk of HTML for 
        Forms-based authentication requests.        */
    define public property AuthenticationChallenge as character no-undo get.
  
    /** Sets the authentication challenge information for this request. 
        
        @param character The authentication method
        @param character The challenge text     */
    method public void SetChallenge(input poAuthMethod  as character,
                                    input pcChallenge   as character).
    
    /** Add the actual authentication to this request, based on the
        request's challenge, credentials and authentication method. */
    method public void AddAuthentication().
    
    /** Adds a subscriber to the events from this request
        
        @param IAuthFilterEventHandler The EventProvider.   */
    method public void AddAuthenticationCallback(input poListener as IAuthFilterEventHandler).
    
    /** Removes a subscriber from the events from this request
        
        @param IAuthFilterEventHandler The EventProvider.   */
    method public void RemoveAuthenticationCallback(input poListener as IAuthFilterEventHandler).
    
    /** Returns the registered listeners.
        
        @param IAuthFilterEventHandler[] An array of listeners 
        @return integer The number of registgered listeners. */    
    method public integer GetAuthenticationCallbacks(output poListener as IAuthFilterEventHandler extent).
    
end interface.