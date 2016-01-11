/************************************************
Copyright (c)  2013-2014 by Progress Software Corporation. All rights reserved.
*************************************************/  
 /*------------------------------------------------------------------------
    File        : TestProcedure
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : svutla
    Created     : Fri Sep 20 22:47:19 IST 2013
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING OpenEdge.ABLUnit.Model.TestEntity.
USING OpenEdge.ABLUnit.Reflection.ProcedureAnnotationInfo.

ROUTINE-LEVEL ON ERROR UNDO, THROW.

CLASS OpenEdge.ABLUnit.Model.TestProcedure INHERITS TestEntity: 

     DEFINE PUBLIC PROPERTY annotationInfo AS ProcedureAnnotationInfo NO-UNDO GET. SET.
    
    CONSTRUCTOR PUBLIC TestProcedure ( INPUT id1 AS INTEGER ):
        SUPER (INPUT id1).
        
    END CONSTRUCTOR.
    
    
END CLASS.