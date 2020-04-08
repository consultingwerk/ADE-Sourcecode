/************************************************
Copyright (c) 2013, 2019-2020 by Progress Software Corporation. All rights reserved.
*************************************************/ 
 /*------------------------------------------------------------------------
    File        : TestSuite
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : svutla
    Created     : Wed Sep 18 11:50:44 IST 2013
    Notes       : 
  ----------------------------------------------------------------------*/
BLOCK-LEVEL ON ERROR UNDO, THROW.

using OpenEdge.ABLUnit.Model.TestEntity.
using OpenEdge.ABLUnit.Reflection.ClassInfo.

CLASS OpenEdge.ABLUnit.Model.TestSuite INHERITS TestEntity: 
    DEFINE PUBLIC PROPERTY classInfo AS ClassInfo  NO-UNDO GET. SET.
    
    CONSTRUCTOR PUBLIC TestSuite ( INPUT id1 AS INTEGER ):
        SUPER (INPUT id1).
    END CONSTRUCTOR.

END CLASS.