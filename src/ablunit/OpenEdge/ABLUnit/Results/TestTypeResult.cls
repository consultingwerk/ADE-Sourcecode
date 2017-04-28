/************************************************
Copyright (c)  2013-2016 by Progress Software Corporation. All rights reserved.
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

USING Progress.Lang.*.



CLASS OpenEdge.ABLUnit.Results.TestTypeResult:
     
/*    DEFINE PRIVATE VARIABLE testCount        AS INTEGER                                   NO-UNDO INIT 1.*/
    DEFINE PRIVATE VARIABLE successCount     AS INTEGER                                   NO-UNDO INIT 0.
    DEFINE PRIVATE VARIABLE failureCount     AS INTEGER                                   NO-UNDO INIT 0.
    DEFINE PRIVATE VARIABLE errorCount       AS INTEGER                                   NO-UNDO INIT 0.      
    DEFINE PRIVATE VARIABLE ignoreCount       AS INTEGER                                   NO-UNDO INIT 0.  

    /*
    Returns all the test methods for a particular test class
    */
    METHOD PUBLIC INTEGER getTestCount(  ):
        RETURN successCount + failureCount + errorCount + ignoreCount.
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
    
END CLASS.