/************************************************
Copyright (c) 2019 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : Token
    Purpose     : Represents a token - group, arg and value. Only the value is
                  mutable
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2019-01-31
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.Util.Token.
using OpenEdge.Core.StringConstant.

class OpenEdge.Core.Util.Token serializable: 
    /* (mandatory) The token group being resolved */
    define public property Group as character no-undo
        get.
        private set.
    
    /* (optional) The token arguments being resolved */
    define public property Arg  as character no-undo
        get.
        private set.
    
    /* The resolved value */
    define public property Value as character initial ? no-undo
        get.
        set.
    
    /* Constructor.
       
       @param character (mandatory) The Token group (not null or empty)
       @param character (mandatory) The Token argument  (not null)  */
    constructor public Token(input pGroup as character,
                             input pArg as character):
        Assert:NotNullOrEmpty(pGroup, 'Token group').
        Assert:NotNull(pArg, 'Token argument').
        
        assign this-object:Group = pGroup
               this-object:Arg   = pArg
               this-object:Value = ?
               .
    end constructor.
    
    /* Parses a token string (group.arg.sub-arg) into a Token object
       
       @param character A complete string token
       @return Token A token instance */
    method static public Token Parse(input pToken as character):
        define variable chrPos      as integer no-undo.
        define variable grp         as character no-undo.
        define variable localArg    as character no-undo.
        
        assign chrPos = index(pToken, '.':u)
               grp    = substring(pToken, 1, chrPos - 1)
               .
        if chrPos gt 0 then
            assign localArg = substring(pToken, chrPos + 1).
        
        return new Token(grp, localArg).
    end method.
    
    method override public character ToString():
        define variable stringToken as character no-undo.
        
        assign stringToken = this-object:Group.
        if not this-object:Arg eq '':u then
            assign stringToken = stringToken + '.':u + this-object:Arg.
        
        return stringToken.
    end method.
    
end class.