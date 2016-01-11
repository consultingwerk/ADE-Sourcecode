/************************************************
Copyright (c)  2013 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : RoutineTypeEnum
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Nov 18 15:25:50 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.RoutineTypeEnum. 
using OpenEdge.Core.EnumMember.

class OpenEdge.Core.RoutineTypeEnum inherits EnumMember: 
    
    define static public property Constructor as RoutineTypeEnum no-undo get. private set.
    define static public property Destructor as RoutineTypeEnum no-undo get. private set.
    define static public property Method as RoutineTypeEnum no-undo get. private set.
    define static public property PropertySetter as RoutineTypeEnum no-undo get. private set.
    define static public property PropertyGetter as RoutineTypeEnum no-undo get. private set.
    define static public property UserDefinedFuntion as RoutineTypeEnum no-undo get. private set.
    define static public property Procedure as RoutineTypeEnum no-undo get. private set.

    constructor static RoutineTypeEnum():
        RoutineTypeEnum:Constructor    = new RoutineTypeEnum('Constructor').
        RoutineTypeEnum:Destructor     = new RoutineTypeEnum('Destructor').
        RoutineTypeEnum:Method         = new RoutineTypeEnum('Method').
        RoutineTypeEnum:PropertySetter = new RoutineTypeEnum('PropertySetter').
        RoutineTypeEnum:PropertyGetter = new RoutineTypeEnum('PropertyGetter').
        
        RoutineTypeEnum:UserDefinedFuntion = new RoutineTypeEnum('Function').
        RoutineTypeEnum:Procedure = new RoutineTypeEnum('Procedure').
    end constructor.
    
    constructor public RoutineTypeEnum ( input pcName as character ):
        super (input pcName).
    end constructor.
    
    method public static RoutineTypeEnum EnumFromString(input pcName as character):
        define variable oEnum as RoutineTypeEnum no-undo.
        
        case pcName:
            when RoutineTypeEnum:Constructor:ToString() then oEnum = RoutineTypeEnum:Constructor.
            when RoutineTypeEnum:Destructor:ToString() then oEnum = RoutineTypeEnum:Destructor.
            when RoutineTypeEnum:Method:ToString() then oEnum = RoutineTypeEnum:Method.
            when RoutineTypeEnum:PropertySetter:ToString() then oEnum = RoutineTypeEnum:PropertySetter.
            when RoutineTypeEnum:PropertyGetter:ToString() then oEnum = RoutineTypeEnum:PropertyGetter.
            when RoutineTypeEnum:UserDefinedFuntion:ToString() then oEnum = RoutineTypeEnum:UserDefinedFuntion.
            when RoutineTypeEnum:Procedure:ToString() then oEnum = RoutineTypeEnum:Procedure.
        end case.
        
        return oEnum.
    end method.
    
end class.
