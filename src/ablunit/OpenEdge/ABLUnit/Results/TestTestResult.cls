 
 /*------------------------------------------------------------------------
    File        : TestTestResult
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : hgarapat
    Created     : Tue Aug 14 16:47:53 IST 2012
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.



class OpenEdge.ABLUnit.Results.TestTestResult: 
    define public static property StatusIgnored    as integer no-undo init 1 get.
    define public static property StatusNoTests    as integer no-undo init 2 get.
    define public static property StatusPassed     as integer no-undo init 3 get.
    define public static property StatusNotStarted as integer no-undo init 4 get.
    define public static property StatusFailed     as integer no-undo init 5 get.
    define public static property StatusError      as integer no-undo init 6 get.
  
    define variable testResult       as integer             no-undo.
    define variable isIncomplete     as logical             no-undo init false.
    define variable testName         as character           no-undo.
    define variable exceptionMessage as character           no-undo.
    define variable errors           as Progress.Lang.Error.
    
    method public void AddError(input err as Progress.Lang.Error ):
        errors = err.       
    end method.


    method public  character getTestName(  ):
        return testName.
    end method.

    method public void setTestName(input mName as character):
        testName = mName.
    end method.

    method public void setStatus(input testStatus as INTEGER):
        testResult = testStatus.
    end method.

    method public integer getStatus(  ):
        return testResult.
    end method.

    method public void SetExceptionMessage(input mesg as character  ):
        exceptionMessage = mesg.    
    end method.    


    method public character getExceptionMessage(  ):
        return exceptionMessage.
    end method. 

    method public Progress.Lang.Error GetError(  ):
        return errors.
    end method. 

    method public void setIncomplete(input incomplete as logical):
        isIncomplete = incomplete.
    end method.    
    
    method public logical isIncomplete():
        return isIncomplete.
    end method.
end class.