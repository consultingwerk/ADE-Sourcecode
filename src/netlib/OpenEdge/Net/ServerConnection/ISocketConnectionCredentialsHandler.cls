/************************************************
Copyright (c) 2021 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : ISocketConnectionCredentialsHandler
    Purpose     : Interface to describe the event handler method for the credential callback
    Syntax      : 
    Description : 
    Author(s)   : dugrau
    Created     : Wed Feb 24 11:47:50 EST 2021
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.Net.ServerConnection.CredentialsEventArgs.

interface OpenEdge.Net.ServerConnection.ISocketConnectionCredentialsHandler:

    /** The event handler for the HttpCredentialRequest event, that must be implemented

        @param Progress.Lang.Object    
        @param OpenEdge.Net.ServerConnection.CredentialsEventArgs */
    method public void ClientSocket_ConnectionCredentialsHandler ( input pSender    as Progress.Lang.Object,
                                                                   input pEventArgs as CredentialsEventArgs ).

end interface.