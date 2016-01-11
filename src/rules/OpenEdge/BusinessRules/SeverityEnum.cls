/************************************************
Copyright (c)  2013, 2015 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : SeverityEnum
    Purpose     : Enumeration of rules message severity
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Mar 01 14:30:23 EST 2013
    Notes       : * Based on Corticon Rules Message severity 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

enum OpenEdge.BusinessRules.SeverityEnum: 
    define enum       Info
                      Warning
                      Violation.
end enum.
