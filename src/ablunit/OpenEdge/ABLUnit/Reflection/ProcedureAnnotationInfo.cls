 
/*------------------------------------------------------------------------
   File        : ProcedureAnnotationInfo
   Purpose     : Stores the information related to the BeforeProcedure,Before, Test, After, AfterProcedure annotations in
                 the test procedure. Contains methods to run specific annotated procedures.
   Syntax      : 
   Description : 
   Author(s)   : hgarapat
   Created     : Tue Jul 24 11:36:16 IST 2012
   Notes       : 
 ----------------------------------------------------------------------*/

using Progress.Lang.*.
using Progress.Lang.AppError.
using OpenEdge.ABLUnit.Util.*.
using OpenEdge.ABLUnit.Reflection.*.
using OpenEdge.ABLUnit.Assertions.AssertionFailedException.
using OpenEdge.ABLUnit.Assertions.Assert.



class OpenEdge.ABLUnit.Reflection.ProcedureAnnotationInfo: 
    define variable beforeProcCount      as integer                                 no-undo init 0.
    define variable beforeProcList       as OpenEdge.ABLUnit.Reflection.TestInfo    no-undo.
    define variable beforeCount          as integer                                 no-undo init 0.
    define variable beforeList           as OpenEdge.ABLUnit.Reflection.TestInfo    no-undo.
    define variable testCount            as integer                                 no-undo init 0.
    define variable testList             as OpenEdge.ABLUnit.Reflection.TestInfo    no-undo extent 100.
    define variable afterCount           as integer                                 no-undo init 0.
    define variable afterList            as OpenEdge.ABLUnit.Reflection.TestInfo    no-undo.
    define variable afterProcCount       as integer                                 no-undo init 0.
    define variable afterProcList        as OpenEdge.ABLUnit.Reflection.TestInfo    no-undo.
    define variable testInProcResult     as OpenEdge.ABLUnit.Results.TestTestResult no-undo.
    define variable inProcResultCount    as integer                                 no-undo init 0.
    define variable testInProcResultList as OpenEdge.ABLUnit.Results.TestTestResult no-undo extent 100.
    
    method public void setBeforeProcedure(input bProc as OpenEdge.ABLUnit.Reflection.TestInfo):
        beforeProcCount = beforeProcCount + 1.
        beforeProcList = bProc.
    end method.
    
    method public void setAfterProcedure(input aProc as OpenEdge.ABLUnit.Reflection.TestInfo):
        afterProcCount = afterProcCount + 1.
        afterProcList = aProc.
    end method.
    
    method public void setBefore(input beforeProc as OpenEdge.ABLUnit.Reflection.TestInfo):
        beforeCount = beforeCount + 1.
        beforeList = beforeProc.
    end method.
    
    method public void setAfter(input afterProc as OpenEdge.ABLUnit.Reflection.TestInfo):
        afterCount = afterCount + 1.
        afterList = afterProc.
    end method.
    
    method public void setTestProc(input tProc as OpenEdge.ABLUnit.Reflection.TestInfo):
        testCount = testCount + 1.
        testList[testCount] = tProc.
    end method.
    
    method public character getBeforeProcedure():
        return beforeProcList:getTestName().
    end method.
    
    method public character getAfterProcedure():
        return afterProcList:getTestName().
    end method.

    /*------------------------------------------------------------------------------
    Runs @BeforeProcedure annotated procedure
    ------------------------------------------------------------------------------*/
    method public OpenEdge.ABLUnit.Results.TestTypeResult RunBeforeProcedure(input procHandle as handle, input testProcResult as OpenEdge.ABLUnit.Results.TestTypeResult):
        if not beforeProcCount = 0 and not testCount = 0 then
        do on error undo, throw:
            define variable beforeProc as character no-undo.
            beforeProc = beforeProcList:getTestName().
            run value (beforeProc) in procHandle no-error.
            if (error-status:error) then
                return error "Exception in @BeforeProcedure".
        end.
        return testProcResult.
    end method.    

    /*------------------------------------------------------------------------------
    Runs @Before annotated procedure
    ------------------------------------------------------------------------------*/
    method public OpenEdge.ABLUnit.Results.TestTypeResult RunBefore(input procHandle as handle, input testProcResult as OpenEdge.ABLUnit.Results.TestTypeResult):
        if not beforeCount = 0 then 
        do on error undo, throw:
            define variable before as character no-undo.
            before = beforeList:getTestName().
            run value (before) in procHandle no-error.
            if (error-status:error) then
                return error "Exception in @Before procedure".
        end.
        return testProcResult.
    end method.    
    
    /*------------------------------------------------------------------------------
    Runs a particular @Test annotated procedure
    ------------------------------------------------------------------------------*/
    method public OpenEdge.ABLUnit.Results.TestTypeResult RunTestProc(input procHandle as handle,
        input testProcResult as OpenEdge.ABLUnit.Results.TestTypeResult, input testProc as OpenEdge.ABLUnit.Reflection.TestInfo):
        define variable expectedException as character no-undo.
        expectedException = testProc:getAttributeValue().
        run value (testProc:getTestName()) in procHandle no-error.
        if (error-status:error) then
        do:
            if expectedException = "" then
            do:
                testInProcResult = new OpenEdge.ABLUnit.Results.TestTestResult().
                testInProcResult:setStatus(OpenEdge.ABLUnit.Results.TestTestResult:StatusFailed).
                testInProcResult:setTestName(testProc:getTestName()).
                testInProcResult:SetExceptionMessage("Not Expecting any exception but found one").
                inProcResultCount = inProcResultCount + 1.
                testInProcResultList[inProcResultCount] = testInProcResult.
                testProcResult:setTestResult(testInProcResultList).
                testProcResult:setTestCount(inProcResultCount).
                testProcResult:IncrementFailure().
            end.
            else
            do:
                testInProcResult = new OpenEdge.ABLUnit.Results.TestTestResult().
                testInProcResult:setStatus(OpenEdge.ABLUnit.Results.TestTestResult:StatusPassed).
                testInProcResult:setTestName(testProc:getTestName()).
                inProcResultCount = inProcResultCount + 1.
                testInProcResultList[inProcResultCount] = testInProcResult.
                testProcResult:setTestResult(testInProcResultList).
                testProcResult:setTestCount(inProcResultCount).
                testProcResult:IncrementSuccess().
            end.
            return testProcResult.
        end.
        else
        do:
            if expectedException = "" then
            do:
                testInProcResult = new OpenEdge.ABLUnit.Results.TestTestResult().
                testInProcResult:setStatus(OpenEdge.ABLUnit.Results.TestTestResult:StatusPassed).
                testInProcResult:setTestName(testProc:getTestName()).
                inProcResultCount = inProcResultCount + 1.
                testInProcResultList[inProcResultCount] = testInProcResult.
                testProcResult:setTestResult(testInProcResultList).
                testProcResult:setTestCount(inProcResultCount).
                testProcResult:IncrementSuccess().
            end.
            else
            do:
                testInProcResult = new OpenEdge.ABLUnit.Results.TestTestResult().
                testInProcResult:setStatus(OpenEdge.ABLUnit.Results.TestTestResult:StatusFailed).
                testInProcResult:setTestName(testProc:getTestName()).
                testInProcResult:SetExceptionMessage("Expecting: " + expectedException + " but did not find any").
                inProcResultCount = inProcResultCount + 1.
                testInProcResultList[inProcResultCount] = testInProcResult.
                testProcResult:setTestResult(testInProcResultList).
                testProcResult:setTestCount(inProcResultCount).
                testProcResult:IncrementFailure().
            end.
            return testProcResult.
        end.
    end method.
    
    
    
    /*------------------------------------------------------------------------------
    Runs all @Test annotated procedure
    ------------------------------------------------------------------------------*/
    method public OpenEdge.ABLUnit.Results.TestTypeResult RunTestProcs(input procHandle as handle, 
        input testProcResult as OpenEdge.ABLUnit.Results.TestTypeResult):
        define variable j as integer no-undo.
        do j=1 to testCount on error undo, throw :
            testProcResult = RunBefore(procHandle, testProcResult).
            testProcResult = RunTestProc(procHandle, testProcResult, testList[j]).
            catch e as Progress.Lang.Error :
            	testInProcResult = new OpenEdge.ABLUnit.Results.TestTestResult().
                testInProcResult:setStatus(OpenEdge.ABLUnit.Results.TestTestResult:StatusFailed).
                testInProcResult:SetExceptionMessage("Exception in @Before procedure").
                testInProcResult:setTestName(testList[j]:getTestName()).
                testInProcResult:setIncomplete(true).
                inProcResultCount = inProcResultCount + 1.
                testInProcResultList[inProcResultCount] = testInProcResult.
                testProcResult:setTestResult(testInProcResultList).
                testProcResult:IncrementFailure().
                testProcResult:setTestCount(inProcResultCount).	
            end catch.
            finally:
                testProcResult = RunAfter(procHandle, testProcResult).
                catch e as Progress.Lang.Error :
                    testInProcResult = new OpenEdge.ABLUnit.Results.TestTestResult().
                    testInProcResult:setStatus(OpenEdge.ABLUnit.Results.TestTestResult:StatusFailed).
                    testInProcResult:SetExceptionMessage("Exception in @After procedure").
                    testInProcResult:setTestName(testList[j]:getTestName()).
                    testInProcResultList[inProcResultCount] = testInProcResult.
                    testProcResult:setTestResult(testInProcResultList).
                    testProcResult:IncrementFailure().
                    testProcResult:setTestCount(inProcResultCount). 
                end catch.                		
            end finally.
        end.
        return testProcResult.
    end method.
    
    
    /*------------------------------------------------------------------------------
    Runs all @Test annotated procedure
    ------------------------------------------------------------------------------*/
    method public OpenEdge.ABLUnit.Results.TestTypeResult RunSelectedTestProc(input procHandle as handle, 
        input testProcResult as OpenEdge.ABLUnit.Results.TestTypeResult, input testProc as OpenEdge.ABLUnit.Reflection.TestInfo):
        testProcResult = RunBefore(procHandle, testProcResult).
        testProcResult = RunTestProc(procHandle, testProcResult, testProc).
        catch e as Progress.Lang.Error :
            testInProcResult = new OpenEdge.ABLUnit.Results.TestTestResult().
            testInProcResult:setStatus(OpenEdge.ABLUnit.Results.TestTestResult:StatusFailed).
            testInProcResult:SetExceptionMessage("Exception in @Before procedure").
            testInProcResult:setTestName(testProc:getTestName()).
            testInProcResult:setIncomplete(true).
            inProcResultCount = inProcResultCount + 1.
            testInProcResultList[inProcResultCount] = testInProcResult.
            testProcResult:setTestResult(testInProcResultList).
            testProcResult:IncrementFailure().
            testProcResult:setTestCount(inProcResultCount). 
        end catch.
        finally:
            testProcResult = RunAfter(procHandle, testProcResult).
            catch e as Progress.Lang.Error :
                testInProcResult = new OpenEdge.ABLUnit.Results.TestTestResult().
                testInProcResult:setStatus(OpenEdge.ABLUnit.Results.TestTestResult:StatusFailed).
                testInProcResult:SetExceptionMessage("Exception in @After procedure").
                testInProcResult:setTestName(testProc:getTestName()).
                testInProcResultList[inProcResultCount] = testInProcResult.
                testProcResult:setTestResult(testInProcResultList).
                testProcResult:IncrementFailure().
                testProcResult:setTestCount(inProcResultCount). 
            end catch.
            finally:
                	return testProcResult.	
            end finally.                      
        end finally.
    end method.
    /*------------------------------------------------------------------------------
    Runs @After annotated procedure
    ------------------------------------------------------------------------------*/
    method public OpenEdge.ABLUnit.Results.TestTypeResult RunAfter(input procHandle as handle, input testProcResult as OpenEdge.ABLUnit.Results.TestTypeResult):
        if not afterCount = 0 then
        do on error undo, throw:
            define variable after as character no-undo.
            after = afterList:getTestName().
            run value (after) in procHandle no-error.
            if (error-STATUS:error) then 
                return error "Exception in @After procedure".
        end.
        return testProcResult.
    end method.    
    
    /*------------------------------------------------------------------------------
    Runs @AfterProcedure annotated procedure
    ------------------------------------------------------------------------------*/
    method public OpenEdge.ABLUnit.Results.TestTypeResult RunAfterProcedure(input procHandle as handle, input testProcResult as OpenEdge.ABLUnit.Results.TestTypeResult):
        if not afterProcCount = 0 and not testCount = 0 then
        do:
            define variable afterProc as character no-undo.
            afterProc = afterProcList:getTestName().
            run value (afterProc) in procHandle no-error.
            if (error-status:error) then
                return error "Exception in @AfterProcedure".
        end.
        return testProcResult.
    end method.

	method public void TestMethod(  ):
		
		return error new Progress.Lang.AppError().

	end method.

end class.