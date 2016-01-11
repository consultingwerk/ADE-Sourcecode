/************************************************
Copyright (c)  2013, 2015 by Progress Software Corporation. All rights reserved.
*************************************************/
/** ------------------------------------------------------------------------
    File        : DateTimeAddIntervalEnum
    Purpose     : Enumeration of intervals for DATETIME and -TZ operations
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Mar 11 11:35:55 EST 2010
    Notes       : * Taken from ABL documentation
  ---------------------------------------------------------------------- */
block-level on error undo, throw.

enum OpenEdge.Core.DateTimeAddIntervalEnum: 
    define enum       Default 
                      Years   
                      Months  
                      Weeks   
                      Days    
                      Hours   
                      Minutes 
                      Seconds 
                      Milliseconds .
end enum.
