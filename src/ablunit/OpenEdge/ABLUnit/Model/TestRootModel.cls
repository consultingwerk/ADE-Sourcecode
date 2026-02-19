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
block-level on error undo, throw.

using OpenEdge.ABLUnit.Model.TestEntity.

class OpenEdge.ABLUnit.Model.TestRootModel inherits TestEntity:

    constructor public TestRootModel ( input id1 as integer ):
        super (input id1).
    end constructor.

end class.