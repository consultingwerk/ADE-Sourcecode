/************************************************
Copyright (c)  2013 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : EnumMember
    Purpose     : Abstract class for Enumerations' members.  
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Jan 21 10:07:10 EST 2010
    Notes       : * We could add a temp-table to manage the EnumMembers' values
                    etc. That's not done right now because there's no pressing 
                    need for it.
                 * Value takes precedence over name, when both are specified.
                 * This version based on the AutoEdge|TheFactory version
  --------------------------------------------------------------------- */
block-level on error undo, throw.

using OpenEdge.Core.EnumMember.
using Progress.Lang.Class.
using Progress.Lang.AppError.
using Progress.Lang.Object.

class OpenEdge.Core.EnumMember abstract serializable:
    
    define public property Name as character no-undo get. private set.
    define public property Value as integer no-undo get. private set.
    
    constructor protected EnumMember(input piValue as integer, input pcName as character):        
        assign this-object:Name = pcName
               this-object:Value = piValue.
    end constructor.

    constructor protected EnumMember(input piValue as integer):
        this-object(piValue, ?).
    end constructor.

    constructor protected EnumMember(input pcName as character):        
        this-object(?, pcName).
    end constructor.

    method public logical Equals(input pcName as character):
        define variable lEquals as logical no-undo.
        
        lEquals = this-object:Name eq pcName. 
        
        return lEquals.
    end method.
    
    method public override logical Equals(poEnumMember as Object):
        define variable lEquals as logical no-undo.

        /* checks for instance equality (ie reference values ('handles') are same */
        lEquals = super:Equals(poEnumMember).
        
        /* ABL deals with unknown values just fine */
        if not lEquals then
            lEquals = type-of(poEnumMember, EnumMember) and 
                      this-object:ToString() eq  cast(poEnumMember, EnumMember):ToString().

        return lEquals.
    end method.

    method public override character ToString():
        define variable cName as character no-undo.
        
        if this-object:Name ne ? then
            cName = substitute('&1', this-object:Name).
        else
        if this-object:Value eq ? then
            cName = substitute('&1_Value_&2', this-object:GetClass():TypeName, this-object:Value).
        else
            cName = substitute('&1_&2', this-object:GetClass():TypeName, this-object).
        
        return cName.
    end method.
    
end class. 
