/************************************************
Copyright (c)  2014 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : Credentials
    Purpose     : A generic set of credentials used for HTTP requests
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Jul 08 09:00:51 EDT 2014
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.

class OpenEdge.Net.HTTP.Credentials: 
    /** The domain (or realm) to which the user belongs */
    define public property Domain as character no-undo get. set.
    
    /** The user name */
    define public property UserName as character no-undo get. set.
    
    /** The user's password for this domain */
    define public property Password as character no-undo get. set.
    
    constructor public Credentials():
    end constructor.
    
    constructor public Credentials(input pcDomain as character,
                                   input pcUserName as character,
                                   input pcPassword as character):
        Assert:NotNullOrEmpty(pcDomain, 'Domain').
        Assert:NotNullOrEmpty(pcUserName, 'User Name').
        assign this-object:Domain   = pcDomain
               this-object:UserName = pcUserName
               this-object:Password = pcPassword.
    end constructor.
    
end class.