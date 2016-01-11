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
                    retrieved from an Credential Store that the application knows about. 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Net.HTTP.Credentials.
using OpenEdge.Net.HTTP.IHttpRequest.

class OpenEdge.Net.HTTP.AuthenticationRequestEventArgs:
    /** (mandatory) Request is for informational purposes (eg querying the URI). */
    define public property Request as IHttpRequest no-undo get. private set.
    
    /** (mandatory) The realm for which we are requesting credentials. */
    define public property Realm as character no-undo get. private set.
    
    /** Subscribers must set the various values, as needed */
    define public property Credentials as Credentials no-undo get. set.
    
    /* If the Cancel property is true, go no further. */
    define public property Cancel as logical no-undo get. set.
    
    constructor public AuthenticationRequestEventArgs(input poRequest as IHttpRequest,
                                                      input pcRealm   as character):
        Assert:NotNull(poRequest, 'Http request').
        Assert:NotNull(pcRealm, 'Authentication realm').
        
        assign this-object:Request = poRequest
               this-object:Realm   = pcRealm
               this-object:Cancel  = false.
    end method.
    
end class.