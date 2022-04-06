/* *************************************************************************************************************************
Copyright (c) 2019, 2021 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
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

using OpenEdge.Core.Collections.Array.
using OpenEdge.ABLUnit.Reflection.ITestInfoList.
using Progress.Lang.Object.

/** Keep this commented-out section to be able to replace with Progress.Collections.List<OpenEdge.ABLUnit.Reflection.TestInfo>
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
**/
class OpenEdge.ABLUnit.Reflection.TestInfoList
inherits Array
implements ITestInfoList:
    
    constructor public TestInfoList (  ):
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