/************************************************
Copyright (c)  2013, 2015 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : DecisionServiceSelectorEnum
    Purpose     : Enumeration of the methods available for decision service selection
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Jun 17 16:17:39 EDT 2013
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

enum OpenEdge.BusinessRules.DecisionServiceSelectorEnum :
    define enum       Default
                      Date
                      Version.
end enum.
