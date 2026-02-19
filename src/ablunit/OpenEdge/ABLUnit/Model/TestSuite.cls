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
block-level on error undo, throw.

using OpenEdge.ABLUnit.Model.TestEntity.
using OpenEdge.ABLUnit.Reflection.ClassInfo.

class OpenEdge.ABLUnit.Model.TestSuite inherits TestEntity:

    define public property classInfo as ClassInfo  no-undo get. set.

    constructor public TestSuite ( input id1 as integer ):
        super (input id1).
    end constructor.

end class.