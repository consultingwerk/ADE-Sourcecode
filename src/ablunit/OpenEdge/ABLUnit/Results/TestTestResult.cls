/************************************************
Copyright (c)  2013-2014 by Progress Software Corporation. All rights reserved.
*************************************************/   
 /*------------------------------------------------------------------------
    File        : TestTestResult
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hgarapat
    Created     : Tue Aug 14 16:47:53 IST 2012
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.



CLASS OpenEdge.ABLUnit.Results.TestTestResult: 
    DEFINE PUBLIC STATIC PROPERTY StatusIgnored    AS INTEGER NO-UNDO INIT 1 GET.
    DEFINE PUBLIC STATIC PROPERTY StatusNoTests    AS INTEGER NO-UNDO INIT 2 GET.
    DEFINE PUBLIC STATIC PROPERTY StatusPassed     AS INTEGER NO-UNDO INIT 3 GET.
    DEFINE PUBLIC STATIC PROPERTY StatusNotStarted AS INTEGER NO-UNDO INIT 4 GET.
    DEFINE PUBLIC STATIC PROPERTY StatusFailed     AS INTEGER NO-UNDO INIT 5 GET.
    DEFINE PUBLIC STATIC PROPERTY StatusError      AS INTEGER NO-UNDO INIT 6 GET.
  
    DEFINE PUBLIC PROPERTY TestResult       AS INTEGER             NO-UNDO GET. SET.
    DEFINE PUBLIC PROPERTY IsIncomplete     AS LOGICAL             NO-UNDO INIT FALSE GET. SET.
    DEFINE PUBLIC PROPERTY TestName         AS CHARACTER           NO-UNDO GET. SET.
    DEFINE PUBLIC PROPERTY ErrorMessage AS CHARACTER           NO-UNDO GET. SET.
    DEFINE PUBLIC PROPERTY Error    AS Progress.Lang.Error NO-UNDO GET. SET.
    
    
END CLASS.