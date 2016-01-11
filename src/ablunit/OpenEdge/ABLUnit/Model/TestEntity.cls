/************************************************
Copyright (c)  2013 by Progress Software Corporation. All rights reserved.
*************************************************/ 
 /*------------------------------------------------------------------------
    File        : TestEntity
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : svutla
    Created     : Wed Sep 18 11:54:23 IST 2013
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING OpenEdge.ABLUnit.Results.TestTestResult.
USING OpenEdge.ABLUnit.Model.TestEntity.
USING OpenEdge.Core.Collections.Array.

ROUTINE-LEVEL ON ERROR UNDO, THROW.

CLASS OpenEdge.ABLUnit.Model.TestEntity: 
    
      DEFINE PUBLIC PROPERTY name AS CHARACTER NO-UNDO GET. SET.
      DEFINE PUBLIC PROPERTY id AS INTEGER NO-UNDO GET. SET.
      DEFINE PUBLIC PROPERTY testResult AS TestTestResult NO-UNDO GET. SET.
      DEFINE PUBLIC PROPERTY timeTaken  AS  DECIMAL  NO-UNDO GET. SET.
      
      DEFINE PRIVATE VARIABLE testEntities AS Array NO-UNDO.
      DEFINE PRIVATE VARIABLE testEntitySize AS INTEGER NO-UNDO INIT 0.
        /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
        
    CONSTRUCTOR PUBLIC TestEntity (INPUT id1 AS INTEGER):
        SUPER ().
        testEntities =  new Array().
        testEntities:AutoExpand = true.
        id = id1.
    END CONSTRUCTOR.

      
      METHOD PUBLIC Array getTestEntities():
        RETURN testEntities.
    END METHOD.
    
    METHOD PUBLIC INTEGER getChildrenSize():
        RETURN testEntitySize.
    END METHOD.
    

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    METHOD PUBLIC VOID addTestEntity( INPUT testEntity AS TestEntity ):
        testEntitySize = testEntitySize + 1.
        testEntities:SetValue(testEntity, testEntitySize).
        RETURN.

    END METHOD.
    

END CLASS.