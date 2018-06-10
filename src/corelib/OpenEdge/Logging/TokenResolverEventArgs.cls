/************************************************
Copyright (c) 2017-2018 by Progress Software Corporation. All rights reserved.
*************************************************/
 /*------------------------------------------------------------------------
    File        : TokenResolverEventArgs
    Purpose     : Arguments for events published when an individual token is resolved.
                  Wraps the general OpenEdge.Core.Util.TokenResolverEventArgs 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2017-02-15
    Notes       : * See OE.Core.Util.TokenResolver for info about the type and args
                  * Token substitutions are allowed for file names
                    the token format is ${<token>}, where
                        token = group "." arg
                    groups = session | env | guid | t[ime] | web | ver[sion]
                             cp | req[uest] | name 
                    
                    If a token cannot be resovled, or resolves to a value of
                    ? (unknown) then the token name is used.   
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.EventArgs.
using OpenEdge.Core.Assert.

class OpenEdge.Logging.TokenResolverEventArgs inherits OpenEdge.Core.Util.TokenResolverEventArgs :
    /* Constructor
       
       @param character The base token (mandatory) */
    constructor public TokenResolverEventArgs(input pToken as character):
        super(pToken).
    end constructor.
    
    /* Constructor
       
       @param character The token group (mandatory)
       @param character The token arguments (if any) */
    constructor public TokenResolverEventArgs(input pGroup as character,
                                              input pArg as character):
        super(pGroup, pArg, ?).
    end constructor.
    
    /* Constructor
       
       @param character The token group (mandatory)
       @param character The token arguments (if any)
       @param character The token value     */
    constructor public TokenResolverEventArgs(input pGroup as character,
                                              input pArg as character,
                                              input pValue as character):
        super(pGroup, pArg, pValue).
    end constructor.
         
end class.