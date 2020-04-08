/************************************************
Copyright (c) 2013-2014, 2020 by Progress Software Corporation. All rights reserved.
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
BLOCK-LEVEL ON ERROR UNDO, THROW.

using OpenEdge.ABLUnit.Model.TestEntity.

CLASS OpenEdge.ABLUnit.Model.TestRootModel INHERITS TestEntity:
    CONSTRUCTOR PUBLIC TestRootModel ( INPUT id1 AS INTEGER ):
        SUPER (INPUT id1).
    END CONSTRUCTOR.
    
END CLASS.