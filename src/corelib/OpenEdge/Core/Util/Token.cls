/************************************************
Copyright (c) 2019, 2022 by Progress Software Corporation. All rights reserved.
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
using Progress.Collections.IComparable.
using Progress.Lang.Object.

class OpenEdge.Core.Util.Token
serializable
implements IComparable<Token>
:

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
    
    /* Is the unknown value a legitimate value? */
    define public property AllowUnknownValue as logical no-undo
        get.
        private set.
    
    /* Constructor.
       
       @param character (mandatory) The Token group (not null or empty)
       @param character (mandatory) The Token argument  (not null) */
    constructor public Token(input pGroup as character,
                             input pArg as character):
        this-object(pGroup, pArg, no /*allow unknown*/).
    end constructor.
    
    /* Constructor.
       
       @param character (mandatory) The Token group (not null or empty)
       @param character (mandatory) The Token argument  (not null)
       @param logical   (mandatory) Whether the unknown value is a valid value */
    constructor public Token(input pGroup as character,
                             input pArg as character,
                             input pUnknownValAllowed as logical):
        Assert:NotNullOrEmpty(pGroup, 'Token group').
        Assert:NotNull(pArg, 'Token argument').
        Assert:NotUnknown(pUnknownValAllowed, 'Unknown value allowed').
        
        assign this-object:Group             = pGroup
               this-object:Arg               = pArg
               this-object:Value             = ?
               this-object:AllowUnknownValue = pUnknownValAllowed
               .
    end constructor.
    
    /* Parses a token string (group.arg.sub-arg) into a Token object
       
       If the token starts with "?" then
       - the AllowUnknownValue property is set to TRUE
       - the ? is stripped off the group name
       So parsing "?cp.uid" results in grp=cp, arg=uid, as does parsing "cp.uid"
       
       @param character A complete string token
       @return Token A token instance */
    method static public Token Parse(input pToken as character):
        var integer chrPos.
        var character grp, localArg.
        var logical nullAllowed.
        
        assign chrPos = index(pToken, '.':u)
               grp    = substring(pToken, 1, chrPos - 1)
               .
        if chrPos gt 0 then
            assign localArg = substring(pToken, chrPos + 1).
        
        assign nullAllowed = (grp begins '?').
        if nullAllowed then
            assign grp = substring(grp, 2).
        
        return new Token(grp, localArg, nullAllowed).
    end method.
    
    method override public character ToString():
        define variable stringToken as character no-undo.
        
        if this-object:AllowUnknownValue then
            assign stringToken = '?'.
        
        assign stringToken += this-object:Group.
        if not this-object:Arg eq '':u then
            assign stringToken += '.':u + this-object:Arg.
        
        return stringToken.
    end method.
    
    method override public logical Equals(input pCompare as Object):
        var Token other.
        
        if super:Equals(pCompare) then
            return true.
        
        // caters for unknown too
        if not type-of(pCompare, Token) then
            return false.
        
        assign other = cast(pCompare, Token).
        
        // The AllowUnknownValue flag is part of the token string, a leading "?"
        return (    this-object:Group             eq other:Group
                and this-object:Arg               eq other:Arg
                and this-object:AllowUnknownValue eq other:AllowUnknownValue).
    end method.
    
    /* Comparison method, used by SortedSet's default comparer
        
        - If the returned value is less than 0 (zero), then the current object sorts before the object passed in.
        - If the returned value equals 0 (zero), then the current object occupies the same position in the sort order.
        - If the returned value is greater than 0 (zero), then the current object sorts after the object passed in.
        
        @param Token The object to compare to.
        @return integer  0 = same object
                        +1 = sorts after
                        -1 = sorts before   */
    method public integer CompareTo(input pOther as Token):
        Assert:NotNull(pOther, 'CompareTo object').
        
        // direct property comparisons are cheaper than string concat
        if this-object:Group              eq pOther:Group
        and this-object:Arg               eq pOther:Arg
        and this-object:AllowUnknownValue eq pOther:AllowUnknownValue
        then
            return 0.
        
        // String comparisons are easier (less error-prone) than group > group AND arg > arg etc
        if this-object:ToString() gt pOther:ToString() then
            return +1.
        else
            return -1.
    end method.
    
end class.