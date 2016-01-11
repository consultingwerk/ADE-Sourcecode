/************************************************
Copyright (c)  2013-2014 by Progress Software Corporation. All rights reserved.
*************************************************/  
 /*------------------------------------------------------------------------
    File        : TestRootModel
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : svutla
    Created     : Wed Sep 18 12:09:10 IST 2013
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING OpenEdge.ABLUnit.Model.TestEntity.

ROUTINE-LEVEL ON ERROR UNDO, THROW.

CLASS OpenEdge.ABLUnit.Model.TestRootModel INHERITS TestEntity: 
		
	CONSTRUCTOR PUBLIC TestRootModel ( INPUT id1 AS INTEGER ):
		SUPER (INPUT id1).
		
	END CONSTRUCTOR.

    

END CLASS.