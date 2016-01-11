/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : IAuthFilterEventHandler
    Purpose     : Interface containing a set of event handler methods for  
                  AuthFilter events.
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Jul 07 15:08:10 EDT 2014
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.Net.HTTP.AuthenticationRequestEventArgs.
using Progress.Lang.Object.

interface OpenEdge.Net.HTTP.Filter.Auth.IAuthFilterEventHandler:
    /** Event handler for the HttpCredentialRequest event.
        
        @param Object The filter object that publishes the event.
        @param AuthenticationRequestEventArgs The event args for the event */
    method public void AuthFilter_HttpCredentialRequestHandler(
                                input poSender as Object,
                                input poEventArgs as AuthenticationRequestEventArgs).
    
end interface.