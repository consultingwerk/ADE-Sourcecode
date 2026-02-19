/************************************************
Copyright (c)  2013-2014, 2020 by Progress Software Corporation. All rights reserved.
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
block-level on error undo, throw.

using OpenEdge.ABLUnit.Model.TestEntity.
using OpenEdge.ABLUnit.Reflection.TestInfo.

class OpenEdge.ABLUnit.Model.TestMethod inherits TestEntity:

    define private variable testInfo as TestInfo no-undo.

    constructor public TestMethod ( input id1 as integer ):
        super (input id1).
    end constructor.

    method public void setTestInfo(input testInfo1 as TestInfo):
        testInfo = testInfo1.
    end method.

    method public TestInfo getTestInfo():
        return testInfo.
    end method.
end class.