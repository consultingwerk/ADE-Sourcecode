/************************************************
Copyright (c)  2013, 2015 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : ErrorSeverityEnum
    Purpose     : Enumeration of error severities 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Jun 26 14:23:12 EDT 2009
    Notes       : * Based on the AutoEdge|TheFactory version 
  ---------------------------------------------------------------------- */
block-level on error undo, throw.

enum OpenEdge.Core.System.ErrorSeverityEnum flags:
    define enum       Default
                      None     
                      Fatal    
                      Critical 
                      Error    
                      Warning  
                      Message  
                      Info     
                      Debug.    
end enum.
