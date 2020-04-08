/* *************************************************************************************************************************
Copyright (c) 2019 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : TestInfoList
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2019-12-05
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.ABLUnit.Reflection.TestInfo.
using OpenEdge.ABLUnit.Reflection.ITestInfoList.
using OpenEdge.Core.Collections.IList.

{OpenEdge/Core/Collections/typedlistclass.i
    &Package        = OpenEdge.ABLUnit.Reflection
    &CollectionType = TestInfoList
    &ImplementsType = ITestInfoList
    &ValueType      = TestInfo
    &NoEndClass     = false
}

