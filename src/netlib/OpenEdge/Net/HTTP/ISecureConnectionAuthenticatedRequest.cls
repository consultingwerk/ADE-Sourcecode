/************************************************
Copyright (c) 2021 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : ISecureConnectionAuthenticatedRequest
    Purpose     : An interface used to identify a request as having TLS client authentication.
    Syntax      : 
    Description : 
    Author(s)   : dugrau
    Created     : Wed Feb 24 12:03:10 EST 2021
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using OpenEdge.Core.ServerConnection.IConnectionParameters.
using OpenEdge.Net.ServerConnection.ISocketConnectionCredentialsHandler.
using OpenEdge.Security.ICredentials.

interface OpenEdge.Net.HTTP.ISecureConnectionAuthenticatedRequest: 

    /** Holds distinct credentials for the request */
    define public property Credentials as OpenEdge.Security.ICredentials no-undo get. set. 

    /** Returns the number of callbacks registered. */
    define public property NumCallbacks as integer no-undo get.

    /** Returns an instance of the credentials to use for a given connection.

        @param OpenEdge.Core.ServerConnection.IConnectionParameters Should be a valid connection
        @return OpenEdge.Security.ICredentials A set of credentials to use for the connection. */
    method public ICredentials GetCredentials ( input pConnection as IConnectionParameters ).

    /** Registers an instance of ISocketConnectionCredentialsHandler as a callback for credentials.

        @param  OpenEdge.Net.ServerConnection.ISocketConnectionCredentialsHandler
        @return logical If the instance is already registered, or is null, then return FALSE. Otherwise return TRUE. */
    method public logical AddCallback ( input pCallback as ISocketConnectionCredentialsHandler ).

    /** Checks if an instance of ISocketConnectionCredentialsHandler exists as a callback.

        @param  OpenEdge.Net.ServerConnection.ISocketConnectionCredentialsHandler
        @return logical If the instance is already registered, then return TRUE. Otherwise return FALSE. */
    method public logical HasCallback ( input pCallback as ISocketConnectionCredentialsHandler ).

    /** Removes an instance of ISocketConnectionCredentialsHandler as a callback for credentials.

        @param  OpenEdge.Net.ServerConnection.ISocketConnectionCredentialsHandler
        @return logical If the instance is already removed, or is null, then return TRUE. Otherwise return FALSE. */
    method public logical RemoveCallback ( input pCallback as ISocketConnectionCredentialsHandler ).

end interface.