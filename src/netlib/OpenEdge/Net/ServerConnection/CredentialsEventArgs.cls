/************************************************
Copyright (c) 2021 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : CredentialsEventArgs
    Purpose     : Event argument for the ISocketConnectionCredentialsHandler event handler method.
    Syntax      : 
    Description : 
    Author(s)   : Dustin Grau
    Created     : Wed Feb 24 11:57:48 EST 2021
    Notes       : 
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.EventArgs.
using OpenEdge.Core.ServerConnection.IConnectionParameters.
using OpenEdge.Security.ICredentials.

class OpenEdge.Net.ServerConnection.CredentialsEventArgs inherits EventArgs:

    /** The credentials for the connection parameters. May be set by a callback/subscriber. */
    define public property Credentials as ICredentials no-undo get. set.

    /** The parameters for which credentials are requested. */
    define public property ConnectionParameters as IConnectionParameters no-undo get. private set. 

    /** A flag to indicate whether any subsequent callbacks/event handlers should be cancelled. */
    define public property Cancel as logical no-undo initial false get. set. 

    /** Default constructor, requires passing of connection parameters.

        @param IConnectionParameters Any non-null object */
    constructor public CredentialsEventArgs ( input pConnection as IConnectionParameters ):
        Assert:NotNull(pConnection, 'Connection Parameters').

        this-object:ConnectionParameters = pConnection.
    end constructor.

end class.