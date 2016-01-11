 
/*------------------------------------------------------------------------
   File        : ClassAnnotationInfo
   Purpose     : Stores the information related to the BeforeClass,Before, Test, After, AfterClass annotations in
                 the test class. Contains methods to run specific annotated methods.  
   Syntax      : 
   Description : 
   Author(s)   : hgarapat
   Created     : Mon Jul 23 11:21:50 IST 2012
   Notes       : 
 ----------------------------------------------------------------------*/

using Progress.Lang.*.
using Progress.Lang.AppError.
using OpenEdge.ABLUnit.Util.*.
using OpenEdge.ABLUnit.Reflection.*.
using OpenEdge.ABLUnit.Assertions.AssertionFailedException.
using OpenEdge.ABLUnit.Assertions.Assert.


class OpenEdge.ABLUnit.Reflection.ClassAnnotationInfo: 
    define variable beforeClassCount     as integer                                 no-undo init 0.
    define variable beforeClassList      as OpenEdge.ABLUnit.Reflection.TestInfo    no-undo.
    define variable beforeCount          as integer                                 no-undo init 0.
    define variable beforeList           as OpenEdge.ABLUnit.Reflection.TestInfo    no-undo.
    define variable testCount            as integer                                 no-undo init 0.
    define variable testList             as OpenEdge.ABLUnit.Reflection.TestInfo    no-undo extent 100.
    define variable afterCount           as integer                                 no-undo init 0.
    define variable afterList            as OpenEdge.ABLUnit.Reflection.TestInfo    no-undo.
    define variable afterClassCount      as integer                                 no-undo init 0.
    define variable afterClassList       as OpenEdge.ABLUnit.Reflection.TestInfo    no-undo.
    
    define variable testMethodResult     as OpenEdge.ABLUnit.Results.TestTestResult no-undo.
    define variable methodResultCount    as integer                                 no-undo init 0.
    define variable testMethodResultList as OpenEdge.ABLUnit.Results.TestTestResult no-undo extent 100.
    
    method public void setBeforeClass(input bClass as OpenEdge.ABLUnit.Reflection.TestInfo):
        beforeClassCount = beforeClassCount + 1.
        beforeClassList= bClass.
    end method.
	
	method public character getBeforeClass():
	    return beforeClassList:getTestName().
	end method.
	
	method public character getAfterClass():
        return afterClassList:getTestName().
    end method.
	
    method public void setAfterClass(input aClass as OpenEdge.ABLUnit.Reflection.TestInfo):
        afterClassCount = afterClassCount + 1.
        afterClassList= aClass.
    end method.
    
    method public void setBeforeMethod(input bMethod as OpenEdge.ABLUnit.Reflection.TestInfo):
        beforeCount = beforeCount + 1.
        beforeList = bMethod.
    end method.
    
    method public void setAfterMethod(input aMethod as OpenEdge.ABLUnit.Reflection.TestInfo):
        afterCount = afterCount + 1.
        afterList = aMethod.
    end method.
    
    method public void setTestMethod(input tMethod as OpenEdge.ABLUnit.Reflection.TestInfo):
        testCount = testCount + 1.
        testList[testCount] = tMethod.
    end method.

    /*------------------------------------------------------------------------------
        Runs the @BeforeClass annotated method.    
    ------------------------------------------------------------------------------*/
    method public OpenEdge.ABLUnit.Results.TestTypeResult RunBeforeClass(input testClassType as Progress.Lang.Object, 
        input testClassResult as OpenEdge.ABLUnit.Results.TestTypeResult):
        if not beforeClassCount = 0 and not testCount = 0 then 
        do on error undo, throw:
            Invoke(testClassType, beforeClassList:getTestName()).
            catch e as Progress.Lang.Error :
                return error e.        		
            end catch.
        end.
        return testClassResult.    
    end method.
    
    /*------------------------------------------------------------------------------
        Runs the @Before annotated method
    ------------------------------------------------------------------------------*/
    method public OpenEdge.ABLUnit.Results.TestTypeResult RunBeforeMethod(input testClassType as Progress.Lang.Object, 
        input testClassResult as OpenEdge.ABLUnit.Results.TestTypeResult):
        if not beforeCount = 0 then
        do on error undo, throw:
            Invoke(testClassType, beforeList:getTestName()).
            catch e as Progress.Lang.Error :
            	return error e.
            end catch.
        end.    
        return testClassResult.
    end method.
    
    /*------------------------------------------------------------------------------
        Runs all @Test annotated methods
    ------------------------------------------------------------------------------*/
    method public OpenEdge.ABLUnit.Results.TestTypeResult RunTestMethods(input testClassType as Progress.Lang.Object, 
        input testClassResult as OpenEdge.ABLUnit.Results.TestTypeResult):
        define variable j as integer no-undo.
        do j=1 to testCount on error undo, throw :
            testClassResult = RunBeforeMethod(testClassType, testClassResult).
            testClassResult = RunTestMethod(testClassType, testClassResult, testList[j]).
            catch err as AssertionFailedException :
                testMethodResult = new OpenEdge.ABLUnit.Results.TestTestResult().
                testMethodResult:setStatus(OpenEdge.ABLUnit.Results.TestTestResult:StatusFailed).
                testMethodResult:SetExceptionMessage(err:GetMessage()).
                testMethodResult:setTestName(testList[j]:getTestName()).
                testMethodResult:setIncomplete(true).
                methodResultCount = methodResultCount + 1.
                testMethodResultList[methodResultCount] = testMethodResult.
                testClassResult:setTestResult(testMethodResultList).
                testClassResult:IncrementFailure().
                testClassResult:setTestCount(methodResultCount).
            end catch.
            catch e as Progress.Lang.Error:
                testMethodResult = new OpenEdge.ABLUnit.Results.TestTestResult().
                testMethodResult:setStatus(OpenEdge.ABLUnit.Results.TestTestResult:StatusError).
                testMethodResult:AddError(e).
                testMethodResult:setTestName(testList[j]:getTestName()).
                testMethodResult:setIncomplete(true).
                methodResultCount = methodResultCount + 1.
                testMethodResultList[methodResultCount] = testMethodResult.
                testClassResult:setTestResult(testMethodResultList).
                testClassResult:setTestCount(methodResultCount).
                testClassResult:IncrementError().
            end catch.
            finally:
                testClassResult = RunAfterMethod(testClassType, testClassResult).
                catch err as AssertionFailedException :
                    testMethodResult = new OpenEdge.ABLUnit.Results.TestTestResult().
                    testMethodResult:setStatus(OpenEdge.ABLUnit.Results.TestTestResult:StatusFailed).
                    testMethodResult:SetExceptionMessage(err:GetMessage()).
                    testMethodResult:setTestName(testList[j]:getTestName()).
                    testMethodResultList[methodResultCount] = testMethodResult.
                    testClassResult:setTestResult(testMethodResultList).
                    testClassResult:IncrementFailure().
                    testClassResult:setTestCount(methodResultCount).
                end catch.
                catch e as Progress.Lang.Error:
                    testMethodResult = new OpenEdge.ABLUnit.Results.TestTestResult().
                    testMethodResult:setStatus(OpenEdge.ABLUnit.Results.TestTestResult:StatusError).
                    testMethodResult:AddError(e).
                    testMethodResult:setTestName(testList[j]:getTestName()).
                    testMethodResultList[methodResultCount] = testMethodResult.
                    testClassResult:setTestResult(testMethodResultList).
                    testClassResult:setTestCount(methodResultCount).
                    testClassResult:IncrementError().
                end catch.
            end finally.
        end.
        return testClassResult.
    end method.
    
    /*------------------------------------------------------------------------------
        Runs all @Test annotated methods
    ------------------------------------------------------------------------------*/
    method public OpenEdge.ABLUnit.Results.TestTypeResult RunSelectedTestMethod(input testClassType as Progress.Lang.Object, 
        input testClassResult as OpenEdge.ABLUnit.Results.TestTypeResult, input testMethod as OpenEdge.ABLUnit.Reflection.TestInfo):
        testClassResult = RunBeforeMethod(testClassType, testClassResult).
        testClassResult = RunTestMethod(testClassType, testClassResult, testMethod).
        catch err as AssertionFailedException :
            testMethodResult = new OpenEdge.ABLUnit.Results.TestTestResult().
            testMethodResult:setStatus(OpenEdge.ABLUnit.Results.TestTestResult:StatusFailed).
            testMethodResult:SetExceptionMessage(err:GetMessage()).
            testMethodResult:setTestName(testMethod:getTestName()).
            testMethodResult:setIncomplete(true).
            methodResultCount = methodResultCount + 1.
            testMethodResultList[methodResultCount] = testMethodResult.
            testClassResult:setTestResult(testMethodResultList).
            testClassResult:IncrementFailure().
            testClassResult:setTestCount(methodResultCount).
        end catch.
        catch e as Progress.Lang.Error:
            testMethodResult = new OpenEdge.ABLUnit.Results.TestTestResult().
            testMethodResult:setStatus(OpenEdge.ABLUnit.Results.TestTestResult:StatusError).
            testMethodResult:AddError(e).
            testMethodResult:setTestName(testMethod:getTestName()).
            testMethodResult:setIncomplete(true).
            methodResultCount = methodResultCount + 1.
            testMethodResultList[methodResultCount] = testMethodResult.
            testClassResult:setTestResult(testMethodResultList).
            testClassResult:setTestCount(methodResultCount).
            testClassResult:IncrementError().
        end catch.
        finally:
            testClassResult = RunAfterMethod(testClassType, testClassResult).
            catch err as AssertionFailedException :
                testMethodResult = new OpenEdge.ABLUnit.Results.TestTestResult().
                testMethodResult:setStatus(OpenEdge.ABLUnit.Results.TestTestResult:StatusFailed).
                testMethodResult:SetExceptionMessage(err:GetMessage()).
                testMethodResult:setTestName(testMethod:getTestName()).
                testMethodResultList[methodResultCount] = testMethodResult.
                testClassResult:setTestResult(testMethodResultList).
                testClassResult:IncrementFailure().
                testClassResult:setTestCount(methodResultCount).
            end catch.
            catch e as Progress.Lang.Error:
                testMethodResult = new OpenEdge.ABLUnit.Results.TestTestResult().
                testMethodResult:setStatus(OpenEdge.ABLUnit.Results.TestTestResult:StatusError).
                testMethodResult:AddError(e).
                testMethodResult:setTestName(testMethod:getTestName()).
                testMethodResultList[methodResultCount] = testMethodResult.
                testClassResult:setTestResult(testMethodResultList).
                testClassResult:setTestCount(methodResultCount).
                testClassResult:IncrementError().
            end catch.
            finally:
                return testClassResult.
            end finally.
        end finally.
    end method.
    
    method public static void Invoke(input obj as Progress.Lang.Object, input testMethod as character):
        dynamic-invoke (obj, testMethod).
        catch e as Progress.Lang.Error :
            return error e.	
        end catch.
    end method.

    /*------------------------------------------------------------------------------
        Runs a particular @Test method
    ------------------------------------------------------------------------------*/
    method public OpenEdge.ABLUnit.Results.TestTypeResult RunTestMethod(input testClassType as Progress.Lang.Object,
        input testClassResult as OpenEdge.ABLUnit.Results.TestTypeResult, input testMethod as OpenEdge.ABLUnit.Reflection.TestInfo):
        testMethodResult = new OpenEdge.ABLUnit.Results.TestTestResult().
        define variable expectedException as character no-undo.
        expectedException = testMethod:getAttributeValue().
        Invoke(testClassType, testMethod:getTestName()).
        if expectedException = "" then
        do:
            testMethodResult:setStatus(OpenEdge.ABLUnit.Results.TestTestResult:StatusPassed).
            testMethodResult:setTestName(testMethod:getTestName()).
            methodResultCount = methodResultCount + 1.
            testMethodResultList[methodResultCount] = testMethodResult.
            testClassResult:setTestResult(testMethodResultList).
            testClassResult:setTestCount(methodResultCount).
            testClassResult:IncrementSuccess().
        end.
        else
        do:
            testMethodResult:setStatus(OpenEdge.ABLUnit.Results.TestTestResult:StatusFailed).
            testMethodResult:setTestName(testMethod:getTestName()).
            testMethodResult:SetExceptionMessage("Expecting: " + expectedException + "but this expection is not raised.").
            methodResultCount = methodResultCount + 1.
            testMethodResultList[methodResultCount] = testMethodResult.
            testClassResult:setTestResult(testMethodResultList).
            testClassResult:setTestCount(methodResultCount).
            testClassResult:IncrementFailure().
        end.
        catch err as AssertionFailedException :
            testMethodResult:setStatus(OpenEdge.ABLUnit.Results.TestTestResult:StatusFailed).
            testMethodResult:setTestName(testMethod:getTestName()).
            testMethodResult:SetExceptionMessage(err:GetMessage()).
            methodResultCount = methodResultCount + 1.
            testMethodResultList[methodResultCount] = testMethodResult.
            testClassResult:setTestResult(testMethodResultList).
            testClassResult:setTestCount(methodResultCount).
            testClassResult:IncrementFailure().		
        end catch.
        catch e as Progress.Lang.Error :
            if expectedException = "" then
            do: 
                testMethodResult:setStatus(OpenEdge.ABLUnit.Results.TestTestResult:StatusError).
                testMethodResult:setTestName(testMethod:getTestName()).
                testMethodResult:AddError(e).
                methodResultCount = methodResultCount + 1.
                testMethodResultList[methodResultCount] = testMethodResult.
                testClassResult:setTestResult(testMethodResultList).
                testClassResult:setTestCount(methodResultCount).
                testClassResult:IncrementError().
            end.
            else if (OpenEdge.ABLUnit.Reflection.ClassAnnotationInfo:IsTypeOf(e, GetExpectedErrorType(expectedException))) THEN
                do:
                    testMethodResult:setStatus(OpenEdge.ABLUnit.Results.TestTestResult:StatusPassed).
                    testMethodResult:setTestName(testMethod:getTestName()).
                    methodResultCount = methodResultCount + 1.
                    testMethodResultList[methodResultCount] = testMethodResult.
                    testClassResult:setTestResult(testMethodResultList).
                    testClassResult:setTestCount(methodResultCount).
                    testClassResult:IncrementSuccess().
                end.
                else 
                do:
                    testMethodResult:setStatus(OpenEdge.ABLUnit.Results.TestTestResult:StatusFailed).
                    testMethodResult:setTestName(testMethod:getTestName()).
                    testMethodResult:SetExceptionMessage("Expecting: " + expectedException + "but found :" + STRING(e)).
                    methodResultCount = methodResultCount + 1.
                    testMethodResultList[methodResultCount] = testMethodResult.
                    testClassResult:setTestResult(testMethodResultList).
                    testClassResult:setTestCount(methodResultCount).
                    testClassResult:IncrementFailure().
                end.
        end catch.
        finally:
            return testClassResult.	
        end finally.
    end method.
    /*----------------------------------------------------------------------------
        Expands the given expected error type if it is a recognised abbreviation.
      ----------------------------------------------------------------------------*/
    method protected static character GetExpectedErrorType(input expectedError as character):
    
        /* Add the package name for recognised error types */
        case expectedError:
            when "Error"           
            or 
            when "AppError"
            or 
            when "ProError"
            or 
            when "SoapFaultError"          
            or 
            when "SysError" then
                return "Progress.Lang." + expectedError.
            when "Stop" then
                return "OEUnit.Reflection.StopConditionError".
            when "Quit" then
                return "OEUnit.Reflection.QuitConditionError".
        end case.
        return expectedError.    
    end method.

    /*----------------------------------------------------------------------------
      Returns true if the given object can be cast to the given type. Otherwise 
      returns false.
    ----------------------------------------------------------------------------*/
    method public static logical IsTypeOf(input obj as Progress.Lang.Object, 
        input castType as character):
        if obj:GetClass():TypeName = castType then return true.
        define variable castObject as Progress.Lang.Object no-undo.
        castObject = dynamic-cast(obj, castType) no-error.
        if error-status:error then
            return false.
        return true.
    end method.
  
    /*------------------------------------------------------------------------------
    Runs @After annotated method
    ------------------------------------------------------------------------------*/
    method public OpenEdge.ABLUnit.Results.TestTypeResult RunAfterMethod(input testClassType as Progress.Lang.Object, 
        input testClassResult as OpenEdge.ABLUnit.Results.TestTypeResult):
        if not afterCount = 0 then
        do on error undo, throw:
            Invoke(testClassType, afterList:getTestName()).
            catch e as Progress.Lang.Error :
                return error e.
            end catch.
        end.
        return testClassResult.
    end method.

    /*------------------------------------------------------------------------------
    Runs @AfterClass annotated method
    ------------------------------------------------------------------------------*/
    method public OpenEdge.ABLUnit.Results.TestTypeResult RunAfterClass(input testClassType as Progress.Lang.Object, 
        input testClassResult as OpenEdge.ABLUnit.Results.TestTypeResult ):
        if not afterClassCount = 0 and not testCount = 0 then
        do on error undo, throw:
            Invoke(testClassType, afterClassList:getTestName()).
            catch e as Progress.Lang.Error :
                return error e.
            end catch.
        end.
        return testClassResult.
    end method.

end class.