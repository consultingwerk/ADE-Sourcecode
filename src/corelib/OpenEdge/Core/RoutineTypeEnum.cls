/************************************************
Copyright (c)  2013, 2015 by Progress Software Corporation. All rights reserved.
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

enum OpenEdge.Core.RoutineTypeEnum:
    
    define enum       Constructor
                      Destructor
                      Method
                      PropertySetter
                      PropertyGetter
                      UserDefinedFunction
                      Procedure
                      . 
end enum.
