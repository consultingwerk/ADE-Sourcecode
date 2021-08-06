/************************************************
Copyright (c) 2021 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : ICredentials
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2020-12-03
    Notes       :
  ----------------------------------------------------------------------*/
interface OpenEdge.Security.ICredentials:
    /* The identity. */
    define public property Identity as Progress.Lang.Object no-undo
        get.
    
    /* The identity's secret. For a username, this might be a password.
       For a token it might be a base64-encoded value. */
    define public property Secret as Progress.Lang.Object no-undo
        get.
    
end interface.