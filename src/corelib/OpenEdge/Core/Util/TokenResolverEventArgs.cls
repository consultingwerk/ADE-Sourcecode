/************************************************
Copyright (c) 2018 by Progress Software Corporation. All rights reserved.
*************************************************/
 /*------------------------------------------------------------------------
    File        : TokenResolverEventArgs
    Purpose     : Arguments for events published when an individual token is resolved
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2018-01-24
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

using OpenEdge.Core.Assert.
using OpenEdge.Core.EventArgs.

class OpenEdge.Core.Util.TokenResolverEventArgs inherits EventArgs:
    /* (mandatory) The token group being resolved */
    define public property TokenGroup as character no-undo get. private set.
    /* (optional) The token arguments being resolved */
    define public property TokenArg  as character no-undo get. private set.
    /* The resolved value */
    define public property TokenValue as character initial ? no-undo get. set.

    /* (optional) The complete original token being resolved */
    define public property BaseToken as character no-undo get. private set.
    /* (optional) Some tokens may be resolved via input values (name, user, cp). This property holds the 
       input/base value */
    define public property SourceValue as Progress.Lang.Object no-undo get. set.
    
    /* Constructor
       
       @param character The base token (mandatory) */
    constructor public TokenResolverEventArgs(input pToken as character):
        Assert:NotNull(pToken, 'Base token').
        
        assign this-object:TokenArg   = substring(pToken, index(pToken, '.':u) + 1)
               this-object:TokenGroup = entry(1, pToken, '.':u)
               this-object:BaseToken  = pToken
               this-object:TokenValue = ?
               .
    end constructor.
    
    /* Constructor
       
       @param character The token group (mandatory)
       @param character The token arguments (if any) */
    constructor public TokenResolverEventArgs(input pGroup as character,
                                              input pArg as character):
        this-object(pGroup, pArg, ?).
    end constructor.
    
    /* Constructor
       
       @param character The token group (mandatory)
       @param character The token arguments (if any)
       @param character The token value     */
    constructor public TokenResolverEventArgs(input pGroup as character,
                                              input pArg as character,
                                              input pValue as character):
        Assert:NotNullOrEmpty(pGroup, 'Token group').
        Assert:NotNull(pArg, 'Token argument').
        
        assign this-object:TokenGroup = pGroup
               this-object:TokenArg   = pArg
               this-object:TokenValue = pValue
               .
    end constructor.
    
end class.