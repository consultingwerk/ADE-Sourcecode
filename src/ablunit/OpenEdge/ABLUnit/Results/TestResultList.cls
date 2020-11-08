/* *************************************************************************************************************************
Copyright (c) 2020 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : TestResultList
    Purpose     : A list of TestTestResults, for cases where there are multiple failures in running a test,
                  such as when one or more of the BeforeEach, test or AfterEach methods fails 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2020-01-07
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.ABLUnit.Results.TestResultList.
using OpenEdge.ABLUnit.Results.TestTestResult.

{OpenEdge/Core/Collections/typedlistclass.i
    &Package        = OpenEdge.ABLUnit.Results
    &CollectionType = TestResultList
    &ValueType      = TestTestResult
    &NoEndClass     = false
}
