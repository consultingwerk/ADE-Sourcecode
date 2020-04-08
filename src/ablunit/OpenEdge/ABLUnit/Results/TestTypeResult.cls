/************************************************
Copyright (c)  2013-2016, 2020 by Progress Software Corporation. All rights reserved.
*************************************************/  
/*------------------------------------------------------------------------
   File        : TestTypeResult
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : hgarapat
   Created     : Tue Aug 14 16:43:04 IST 2012
   Notes       : class that stores the test results (TestTestResult) for each of its methods similarly for procedure for each of its internal procs
 ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.ABLUnit.Results.TestResultEnum.
using OpenEdge.ABLUnit.Results.TestTestResult.
using OpenEdge.ABLUnit.Results.TestTypeResult.

CLASS OpenEdge.ABLUnit.Results.TestTypeResult:
    /* The number of tests (independent of the other counts). 
       A single test may have more than one failure associated with it (eg the 'after each' methods fail). */
    define public property TestCount as integer no-undo initial 0
        get.
        set.
    
    DEFINE PUBLIC PROPERTY successCount     AS INTEGER NO-UNDO INIT 0 GET. SET.
    DEFINE PUBLIC PROPERTY failureCount     AS INTEGER NO-UNDO INIT 0 GET. SET.
    DEFINE PUBLIC PROPERTY errorCount       AS INTEGER NO-UNDO INIT 0 GET. SET.
    DEFINE PUBLIC PROPERTY ignoreCount      AS INTEGER NO-UNDO INIT 0 GET. SET.
    
    /*
    Returns all the test methods for a particular test class
    */
    METHOD PUBLIC INTEGER getTestCount(  ):
        if this-object:TestCount eq 0 then
            RETURN successCount + failureCount + errorCount + ignoreCount.
        else
            return this-object:TestCount.
    END METHOD.
    
    METHOD PUBLIC VOID IncrementSuccess(  ):
        successCount = successCount + 1.
        RETURN.
    END METHOD.        

    METHOD PUBLIC VOID IncrementFailure(  ):
        failureCount = failureCount + 1.
        RETURN.
    END METHOD.

    METHOD PUBLIC VOID IncrementError(  ):
        errorCount = errorCount + 1.
        RETURN.
    END METHOD.        

    METHOD PUBLIC VOID IncrementIgnore(  ):
        ignoreCount = ignoreCount + 1.
        RETURN.
    END METHOD.
    
    // These Get*Count*() methods are deprecated since the members are now PROPERTIES instead of  
    // private variables. There are public getter and setter methods and so no reason not to make them properties
    METHOD PUBLIC INTEGER GetSuccessCount(  ):
        RETURN successCount.
    END METHOD.

    METHOD PUBLIC INTEGER GetFailureCount(  ):
        RETURN failureCount.
    END METHOD.

    METHOD PUBLIC INTEGER GetErrorCount(  ):
        RETURN errorCount.
    END METHOD.
    
    METHOD PUBLIC INTEGER GetIgnoreCount(  ):
        RETURN ignoreCount.
    END METHOD.
    
    /* Adds a child result to this result
    
       @param TestTypeResult The child/additive result */
    method public void Add(input pValue as TestTypeResult):
        if valid-object(pValue) then
            assign this-object:successCount = this-object:successCount + pValue:successCount
                   this-object:errorCount   = this-object:errorCount   + pValue:errorCount
                   this-object:failureCount = this-object:failureCount + pValue:failureCount
                   this-object:ignoreCount  = this-object:ignoreCount  + pValue:ignoreCount
                   
                   this-object:TestCount    = this-object:TestCount + pValue:TestCount
                   .
    end method.
    
    /* Increments the relevant counter for a test result
       
       @param TestTestResult The input result  */
    method public void Add(input pResult as TestTestResult):
        if valid-object(pResult) then
        case pResult:TestResult:
            when TestResultEnum:StatusError   then assign errorCount   = errorCount + 1.
            when TestResultEnum:StatusFailed  then assign failureCount = failureCount + 1.
            when TestResultEnum:StatusIgnored then assign ignoreCount  = ignoreCount + 1.
            otherwise                              assign successCount = successCount + 1.
        end case.
    end method.
    
END CLASS.