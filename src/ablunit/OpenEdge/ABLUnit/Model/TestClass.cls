/************************************************
Copyright (c)  2013 by Progress Software Corporation. All rights reserved.
*************************************************/
 
 /*------------------------------------------------------------------------
    File        : TestClass
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : svutla
    Created     : Wed Sep 18 11:52:34 IST 2013
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

ROUTINE-LEVEL ON ERROR UNDO, THROW.
USING OpenEdge.ABLUnit.Model.TestEntity.
USING OpenEdge.ABLUnit.Reflection.ClassInfo.
USING OpenEdge.ABLUnit.Reflection.ClassAnnotationInfo.

CLASS OpenEdge.ABLUnit.Model.TestClass INHERITS TestEntity: 
    
     DEFINE PUBLIC PROPERTY annotationInfo AS ClassAnnotationInfo  NO-UNDO GET. SET.
     DEFINE PUBLIC PROPERTY classInfo AS ClassInfo  NO-UNDO GET. SET.
    
    CONSTRUCTOR PUBLIC TestClass ( INPUT id1 AS INTEGER ):
        SUPER (INPUT id1).
        
    END CONSTRUCTOR.
    
    
    
    
END CLASS.