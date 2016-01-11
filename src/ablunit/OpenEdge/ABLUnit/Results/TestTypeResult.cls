 
/*------------------------------------------------------------------------
   File        : TestTypeResult
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : hgarapat
   Created     : Tue Aug 14 16:43:04 IST 2012
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.



CLASS OpenEdge.ABLUnit.Results.TestTypeResult:
     
    define variable testCount        as integer                                   no-undo.
    define variable testResultList   as OpenEdge.ABLUnit.Results.TestTestResult extent 100.
    define variable beforeTypeResult as OpenEdge.ABLUnit.Results.TestTestResult.    
    define variable successCount     as integer                                   no-undo init 0.
    define variable failureCount     as integer                                   no-undo init 0.
    define variable errorCount       as integer                                   no-undo init 0.      

    /*
    Returns all the test methods for a particular test class
    */
    method public integer getTestCount(  ):
        return testCount.
    end method.

    method public void setTestCount(input i as  integer ):
        testCount= i.
    end method.
    
    /*--------------------------------------------------------------------
    All the method results inside a test class are stored in an array.
    ----------------------------------------------------------------------*/
    method public void setTestResult(input resultList as OpenEdge.ABLUnit.Results.TestTestResult extent 100):
        testResultList = resultList.
    end method.
    
    /*--------------------------------------------------------------------
    All the method results inside a test class are stored in an array.
    ----------------------------------------------------------------------*/
    method public void setBeforeTypeResult(input resultList as OpenEdge.ABLUnit.Results.TestTestResult):
        beforeTypeResult = resultList.
    end method.

    method public OpenEdge.ABLUnit.Results.TestTestResult extent 100 getTestResult(  ):
        return testResultList.
    end method.
    
    method public OpenEdge.ABLUnit.Results.TestTestResult getBeforeTypeResult(  ):
        return beforeTypeResult.
    end method.

    method public void IncrementSuccess(  ):
        successCount = successCount + 1.        
        return.
    end method.        

    method public void IncrementFailure(  ):
        failureCount = failureCount + 1.        
        return.
    end method.        

    method public void IncrementError(  ):
        errorCount = errorCount + 1.        
        return.
    end method.        

    method public integer GetSuccessCount(  ):
        return successCount.
    end method.

    method public integer GetFailureCount(  ):
        return failureCount.
    end method.

    method public integer GetErrorCount(  ):
        return errorCount.
    end method.
    
end class.