/************************************************
Copyright (c) 2022 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : LeakReportFilterTypeEnum
    Purpose     : Enumeration of the filter types for a leak report
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : 2022-02-17
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

enum OpenEdge.Core.Util.LeakReportFilterTypeEnum:
    define enum None
                Group
                Session
                Type
                
                Default = None.
end enum.