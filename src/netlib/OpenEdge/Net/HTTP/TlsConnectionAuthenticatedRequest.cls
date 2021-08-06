/************************************************
Copyright (c) 2021 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : TlsConnectionAuthenticatedRequest
    Purpose     : Decorates an HTTP request with TLS client connections credentials.
    Syntax      : 
    Description : 
    Author(s)   : dugrau
    Created     : Wed Feb 24 12:03:10 EST 2021
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.Collections.ISet.
using OpenEdge.Core.Collections.Set.
using OpenEdge.Core.ServerConnection.IConnectionParameters.
using OpenEdge.Net.HTTP.HttpRequestDecorator.
using OpenEdge.Net.HTTP.IHttpRequest.
using OpenEdge.Net.HTTP.ISecureConnectionAuthenticatedRequest.
using OpenEdge.Net.ServerConnection.ISocketConnectionCredentialsHandler.
using OpenEdge.Security.ICredentials.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Net.ServerConnection.CredentialsEventArgs.

class OpenEdge.Net.HTTP.TlsConnectionAuthenticatedRequest inherits HttpRequestDecorator implements ISecureConnectionAuthenticatedRequest: 

    /** Holds distinct credentials for the request */
    define public property Credentials as ICredentials no-undo get. set. 

    /** Unordered, unique set of callback objects. */
    define protected property Callbacks as ISet no-undo get. set.

    /** Returns the number of callbacks registered. */
    define public property NumCallbacks as integer no-undo
        get():
            return Callbacks:size.
        end get.

    /** Constructor.

        @param OpenEdge.Net.HTTP.IHttpRequest Request being decorated */
    constructor public TlsConnectionAuthenticatedRequest ( input poHttpRequest as IHttpRequest ):
        super (input poHttpRequest).

        this-object:Callbacks = new Set(). 
    end constructor.

    /** Returns an instance of the credentials to use for a given connection.

        @param OpenEdge.Core.ServerConnection.IConnectionParameters Should be a valid connection
        @return OpenEdge.Security.ICredentials A set of credentials to use for the connection. */
    method public ICredentials GetCredentials ( input pConnection as IConnectionParameters ):
        if valid-object(this-object:Credentials) then
            return this-object:Credentials.

        if this-object:NumCallbacks gt 0 then do:
            define variable oIter as IIterator            no-undo.
            define variable oArgs as CredentialsEventArgs no-undo.

            assign oArgs = new CredentialsEventArgs(pConnection).

            assign oIter = this-object:Callbacks:Iterator().
            do while oIter:HasNext():
                /* Callbacks should only consist of non-null items in the set. */
                cast(oIter:Next(), ISocketConnectionCredentialsHandler)
                                    :ClientSocket_ConnectionCredentialsHandler(this-object, oArgs).
            
                /* Args indicated we should cancel as of this callback, return the credentials found. */
                if oArgs:Cancel then return oArgs:Credentials.
            end.

            /* If not cancelled prior to this point, return the last credentials object. */
            return oArgs:Credentials.
        end.

        return ?. /* "We ain't found sh*t." -Spaceballs */
    end method.

    /** Registers an instance of ISocketConnectionCredentialsHandler as a callback for credentials.

        @param  OpenEdge.Net.ServerConnection.ISocketConnectionCredentialsHandler
        @return logical If the instance is already registered, or is null, then return FALSE. Otherwise return TRUE. */
    method public logical AddCallback ( input pCallback as ISocketConnectionCredentialsHandler ):
        Assert:NotNull(pCallback, 'Callback').

        return Callbacks:Add(pCallback).
    end method.

    /** Checks if an instance of ISocketConnectionCredentialsHandler exists as a callback.

        @param  OpenEdge.Net.ServerConnection.ISocketConnectionCredentialsHandler
        @return logical If the instance is already registered, then return TRUE. Otherwise return FALSE. */
    method public logical HasCallback ( input pCallback as ISocketConnectionCredentialsHandler ):
        Assert:NotNull(pCallback, 'Callback').

        return Callbacks:Contains(pCallback).
    end method.

    /** Removes an instance of ISocketConnectionCredentialsHandler as a callback for credentials.

        @param  OpenEdge.Net.ServerConnection.ISocketConnectionCredentialsHandler
        @return logical If the instance is already removed, or is null, then return TRUE. Otherwise return FALSE. */
    method public logical RemoveCallback ( input pCallback as ISocketConnectionCredentialsHandler ):
        Assert:NotNull(pCallback, 'Callback').

        return Callbacks:Remove(pCallback).
    end method.

end class.