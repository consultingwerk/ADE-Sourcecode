/* *************************************************************************************************************************
Copyright (c) 2019, 2021 by Progress Software Corporation and/or one of its subsidiaries or affiliates. All rights reserved.
************************************************************************************************************************** */
/*------------------------------------------------------------------------
    File        : ITestInfoList
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2019-12-06
    Notes       :
  ----------------------------------------------------------------------*/

using OpenEdge.ABLUnit.Reflection.TestInfo.
using OpenEdge.Core.Collections.IList.

/** Keep this commented-out section to be able to replace with Progress.Collections.List<OpenEdge.ABLUnit.Reflection.TestInfo>
{OpenEdge/Core/Collections/typedlistinterface.i
    &Package        = OpenEdge.ABLUnit.Reflection
    &CollectionType = ITestInfoList
    &ValueType      = TestInfo
    &NoEndClass     = false
}
**/
interface OpenEdge.ABLUnit.Reflection.ITestInfoList
inherits IList:
    // comment to stop SQ complaining
end interface.