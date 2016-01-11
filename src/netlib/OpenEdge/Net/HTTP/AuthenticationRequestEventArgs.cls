/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : AuthenticationRequestEventArgs
    Purpose     : Event arguments for the HttpAuthenticationRequest event,
                  published from the AuthorizationStatusFilter. 
    Author(s)   : pjudge
    Created     : Mon Jul 07 11:13:33 EDT 2014
    Notes       : * This object acts as a parameter object, gathering information
                    about the Domain and user that should be used for HTTP 
                    authentication purposes. The passwords/credentials will be
                    retrieved from an ICredentialStore object that the request
                    knows about when the request is being executed. 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Net.HTTP.HttpRequest.
using OpenEdge.Net.HTTP.Credentials.

class OpenEdge.Net.HTTP.AuthenticationRequestEventArgs:
    /** Request is for informational purposes (eg querying the URI). */
    define public property Request as HttpRequest no-undo get. private set.
    
    /** Subscribers must set the various values, as needed */
    define public property Credentials as Credentials no-undo get. set.
    
    /* If the Cancel property is true, go no further. */
    define public property Cancel as logical no-undo get. set.
    
    constructor public AuthenticationRequestEventArgs(input poRequest as HttpRequest):
        Assert:NotNull(poRequest, 'Http request').
        
        assign this-object:Request = poRequest
               this-object:Cancel = false.
    end method.
    
end class.