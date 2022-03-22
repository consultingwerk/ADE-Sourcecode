/* *************************************************************************************************************************
Copyright (c) 2020-2021 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
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

using OpenEdge.Core.Collections.Array.
using Progress.Lang.Object.

/** Keep this commented-out section to be able to replace with Progress.Collections.List<OpenEdge.ABLUnit.Results.TestTestResult>
using OpenEdge.ABLUnit.Results.TestResultList.
using OpenEdge.ABLUnit.Results.TestTestResult.

{OpenEdge/Core/Collections/typedlistclass.i
    &Package        = OpenEdge.ABLUnit.Results
    &CollectionType = TestResultList
    &ValueType      = TestTestResult
    &NoEndClass     = false
}
**/

class OpenEdge.ABLUnit.Results.TestResultList inherits Array:
    /* Default constructor */
    constructor public TestResultList (  ):
        super ().
        this-object:AutoExpand = true.
    end constructor.

    method override public logical Add(input pIndex as integer, input pElement as Object ):
        // The backing of this collection is an Array, which allows null items, rather than
        // a List, which does not. So we act like a List here
        if not valid-object(pElement) then
            return false.
        
        return super:Add(pIndex, pElement).
    end method.
    
    method override public logical Add(input pElement as Object):
        // The backing of this collection is an Array, which allows null items, rather than
        // a List, which does not. So we act like a List here
        if not valid-object(pElement) then
            return false.
        
        return super:Add(pElement).
    end method.

end class.