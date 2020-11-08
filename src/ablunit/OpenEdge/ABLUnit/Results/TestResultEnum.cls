/************************************************
Copyright (c) 2020 by Progress Software Corporation. All rights reserved.
*************************************************/  
/*------------------------------------------------------------------------
    File        : TestResultEnum
    Purpose     : Enumerates a test result
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : 2020-02-05
    Notes       : 
  ----------------------------------------------------------------------*/
enum OpenEdge.ABLUnit.Results.TestResultEnum: 
    define enum StatusIgnored    = 1
                StatusNoTests
                StatusPassed
                StatusNotStarted
                StatusFailed
                StatusError
                .
end enum.