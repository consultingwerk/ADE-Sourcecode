/************************************************
Copyright (c)  2013-2014 by Progress Software Corporation. All rights reserved.
*************************************************/  
 /*------------------------------------------------------------------------
    File        : TestMethod
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : svutla
    Created     : Wed Sep 18 11:52:47 IST 2013
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING OpenEdge.ABLUnit.Model.TestEntity.
USING OpenEdge.ABLUnit.Reflection.TestInfo.

ROUTINE-LEVEL ON ERROR UNDO, THROW.

CLASS OpenEdge.ABLUnit.Model.TestMethod INHERITS TestEntity: 
    
    DEFINE PRIVATE VARIABLE testInfo AS TestInfo NO-UNDO. 
		
	CONSTRUCTOR PUBLIC TestMethod ( INPUT id1 AS INTEGER ):
		SUPER (INPUT id1).
		
	END CONSTRUCTOR.
	
	
	METHOD PUBLIC VOID setTestInfo(INPUT testInfo1 AS TestInfo):
	    testInfo = testInfo1.
	END METHOD.
	
	METHOD PUBLIC TestInfo getTestInfo():
        RETURN testInfo.
    END METHOD.


END CLASS.