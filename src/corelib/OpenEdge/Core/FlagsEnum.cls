/************************************************
Copyright (c)  2013 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : FlagsEnum
    Purpose     : Parent class for flags enumerations: enumerations that contain
                  values that can be 'stacked' or stored together in one
                  property/variable.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri May 15 15:41:08 EDT 2009
    Notes       : * These kinds of enumerations allow us to store multiple values
                    in a single value. 
                  * This version based on the AutoEdge|TheFactory version                                    
  ---------------------------------------------------------------------- */
block-level on error undo, throw.

using OpenEdge.Core.EnumMember.
using Progress.Lang.AppError.

class OpenEdge.Core.FlagsEnum abstract serializable inherits EnumMember:
    /** Determines whether a variable or member contains the particular specified
        flag enumeration value.
        
        @param piValueSum Contains the value that is being checked to determine whether
        it contains a particular flag.
        @param poCheckEnum The flag being checked for inclusion.
        @return Whether the value includes the specified member     */
    method static public logical IsA (piValueSum as int, poCheckEnum as EnumMember):
        /* thx to Bronco Oostermeyer */
        /** This value should always be a power of 2. */
        return ((integer(truncate(piValueSum / poCheckEnum:Value, 0)) mod 2) eq 1).        
    end method.
    
    /* Private ctor so that a derived class can't bypass the necessary checks for
       power-of-two-ness. */
    constructor private FlagsEnum():
        super(-1).
    end constructor.
    
    constructor public FlagsEnum(input piValue as integer):
        this-object(piValue, ?).
    end constructor.
    
    constructor public FlagsEnum ( input piValue as integer, input pcName as character ):
        super(input piValue, input pcName).
        
        ValidateEnumMemberValue(piValue).
    end constructor.
    
    /** The value must be a power of 2 for it to be a flag enumeration value.
        The algorithm below adapted from the following comment on Stackoverflow:
        http://stackoverflow.com/questions/600293/how-to-check-if-a-number-is-a-power-of-2/2552559#2552559 */
    method private void ValidateEnumMemberValue(input piValue as integer):
        if not piValue eq exp(2, log(piValue, 2)) then
          undo, throw new AppError(string(piValue) + ' is not a power of 2, which is required for a flag enumeration value').
    end method.

end class.
