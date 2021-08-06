/************************************************
Copyright (c) 2021 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
    File        : OpenEdge.Net.ServerConnection.TlsClientCredentials
    Description : An implementation of Crededntials 
    Author(s)   : Cameron David Wright - cwright@progress.com
    Created     : 
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Ccs.Common.Support.ILongcharHolder.
using OpenEdge.Core.Assert.
using OpenEdge.Core.EncodedString.
using OpenEdge.Security.ICredentials.

class OpenEdge.Net.ServerConnection.TlsClientCredentials
        implements ICredentials:

    /* The identity. */
    define public property Identity as Progress.Lang.Object no-undo
        get.
        set(input inID as Progress.Lang.Object):
            assert:isType(inID, get-class(ILongcharHolder)).
            assign Identity = inID.
        end set.
    /* The identity's secret. For a username, this might be a password.
       For a token it might be a base64-encoded value. */
    define public property Secret as Progress.Lang.Object no-undo
        get. 
        set(input inSec as Progress.Lang.Object):
            assert:isType(inSec, get-class(EncodedString)).
            assign Secret = inSec.
        end set.

    /* Constructor - Default
       
       */    
    constructor PUBLIC TlsClientCredentials():
        // default consturctor does nothing.
    end constructor.

    /* Constructor
       
       @param ILongcharHolder - The identity for credentials
       @param EncodedString - The secret */
    constructor PUBLIC TlsClientCredentials(input pIdentity as ILongcharHolder, input pSecret as EncodedString):
        assign 
            Identity = pIdentity
            Secret = pSecret.

    end constructor.

end class