/************************************************
Copyright (c)  2013-2016 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
   File        : ClassAnnotationInfo
   Purpose     : Stores the information related to the Before, Setup, Test, TearDown, After annotations in
                 the test class. Contains methods to run specific annotated methods.  
   Syntax      : 
   Description : 
   Author(s)   : hgarapat
   Created     : Mon Jul 23 11:21:50 IST 2012
   Notes       : 
 ----------------------------------------------------------------------*/

USING OpenEdge.Core.AssertionFailedError.
USING OpenEdge.ABLUnit.Reflection.AnnotationInfo.
USING OpenEdge.ABLUnit.Reflection.ClassAnnotationInfo.
USING OpenEdge.ABLUnit.Reflection.TestInfo.
USING OpenEdge.ABLUnit.Reflection.TestInfo.
USING OpenEdge.ABLUnit.Results.TestTestResult.
USING OpenEdge.ABLUnit.Results.TestTypeResult.
USING OpenEdge.Core.Collections.Array.
USING OpenEdge.ABLUnit.Reflection.AnnotationUtil.

CLASS OpenEdge.ABLUnit.Reflection.ClassAnnotationInfo: 

    DEFINE PRIVATE VARIABLE beforeClassMethod AS  TestInfo   NO-UNDO.
    DEFINE PRIVATE VARIABLE beforeMethod      AS TestInfo    NO-UNDO.
    DEFINE PRIVATE VARIABLE testList          AS Array NO-UNDO.
    DEFINE PUBLIC PROPERTY testCount         AS INTEGER NO-UNDO GET. SET.
    DEFINE PRIVATE VARIABLE afterMethod       AS TestInfo    NO-UNDO.
    DEFINE PRIVATE VARIABLE afterClassMethod  AS TestInfo    NO-UNDO.
    DEFINE PRIVATE VARIABLE testMethodResult  AS TestTestResult NO-UNDO.
    
    /*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
		
	CONSTRUCTOR PUBLIC ClassAnnotationInfo (  ):
		SUPER ().
		testList = NEW Array().
		testList:AutoExpand = TRUE.
	END CONSTRUCTOR.

    METHOD PUBLIC VOID setBeforeClass(INPUT bClass AS TestInfo):
        IF beforeClassMethod = ? THEN
            beforeClassMethod= bClass.
        ELSE 
            throwError().
    END METHOD.
	
	METHOD PUBLIC CHARACTER getBeforeClass():
	    RETURN beforeClassMethod:getTestName().
	END METHOD.
	
	METHOD PUBLIC CHARACTER getAfterClass():
        RETURN afterClassMethod:getTestName().
    END METHOD.
    
    METHOD PUBLIC Array getTestList():
        RETURN testList.
    END METHOD.
    
    METHOD PUBLIC VOID setAfterClass(INPUT aClass AS TestInfo):
        IF afterClassMethod = ? THEN
            afterClassMethod= aClass.
        ELSE 
            throwError().
    END METHOD.
    
    METHOD PUBLIC VOID setBeforeMethod(INPUT bMethod AS TestInfo):
        IF beforeMethod = ? THEN
            beforeMethod = bMethod.
        ELSE 
            throwError().
    END METHOD.
    
    METHOD PUBLIC VOID setAfterMethod(INPUT aMethod AS TestInfo):
        IF afterMethod = ? THEN
            afterMethod = aMethod.
        ELSE 
            throwError().
    END METHOD.
    
    METHOD PUBLIC VOID AddTestMethod(INPUT tMethod AS TestInfo):
        testCount = testCount + 1.
        testList:SetValue(tMethod, testCount).
    END METHOD.
   
    /*------------------------------------------------------------------------------
        Runs the @Before annotated method.    
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC TestTypeResult RunBeforeClass(INPUT testClassType AS Progress.Lang.Object, 
        INPUT testClassResult AS TestTypeResult ):
        IF NOT beforeClassMethod = ? AND NOT testList:size = 0 THEN 
        DO ON ERROR UNDO, THROW:
            Invoke(testClassType, beforeClassMethod:getTestName()).
            CATCH e AS Progress.Lang.Error :
                RETURN ERROR e.        		
            END CATCH.
        END.
        RETURN testClassResult.    
    END METHOD.
    
    /*------------------------------------------------------------------------------
        Runs the @Setup annotated method
        This method will be exectuted before executing each test method.
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC VOID RunBeforeMethod(INPUT testClassType AS Progress.Lang.Object, 
        INPUT testResult AS TestTestResult):
        IF NOT beforeMethod = ? THEN
        DO ON ERROR UNDO, THROW:
            Invoke(testClassType, beforeMethod:getTestName()).
            CATCH e AS Progress.Lang.Error :
            	RETURN ERROR e.
            END CATCH.
        END.
    END METHOD.
    
    /*------------------------------------------------------------------------------
        Runs a particular test method denoted by OpenEdge.ABLUnit.Reflection.TestInfo
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC TestTestResult RunSelectedTestMethod(INPUT testClassType AS Progress.Lang.Object, INPUT testMethod AS TestInfo):
        DEFINE VARIABLE testResult AS TestTestResult  NO-UNDO.
        DEFINE VARIABLE ignoreTest AS LOGICAL NO-UNDO.
        testResult = NEW TestTestResult().
        
        // Check whether the test method is ignored
        ignoreTest = AnnotationUtil:HasIgnoreAnnotation(testMethod:annotations).
        IF ignoreTest THEN DO:
            testResult:TestResult = TestTestResult:StatusIgnored.
            testResult:TestName = testMethod:getTestName().
            RETURN testResult.
        END.
        
        RunBeforeMethod(testClassType, testResult).
        RunTestMethod(testClassType, testResult, testMethod).
        CATCH err AS AssertionFailedError :
            testResult:testResult = TestTestResult:StatusFailed.
            testResult:ErrorMessage = err:GetMessage().
            testResult:Error = err.
            testResult:TestName = testMethod:getTestName().
            testResult:isIncomplete = TRUE.
        END CATCH.
        CATCH e AS Progress.Lang.Error:
            testResult:testResult = TestTestResult:StatusError.
            testResult:Error  = err.
            testResult:TestName = testMethod:getTestName().
             testResult:isIncomplete = TRUE.
        END CATCH.
        FINALLY:
            IF NOT ignoreTest THEN
                RunAfterMethod(testClassType, testResult).
            CATCH err AS AssertionFailedError :
                testResult:TestResult = TestTestResult:StatusFailed.
                testResult:ErrorMessage = err:GetMessage().
                testResult:TestName = testMethod:getTestName().
                testResult:Error = err.
            END CATCH.
            CATCH e AS Progress.Lang.Error:
                testResult:TestResult = TestTestResult:StatusError.
                testResult:Error = e.
                testResult:TestName = testMethod:getTestName().
            END CATCH.
            FINALLY:
                RETURN testResult.
            END FINALLY.
        END FINALLY.
    END METHOD.
    
   /*------------------------------------------------------------------------------
        Invokes instance method.
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC STATIC VOID Invoke(INPUT obj AS Progress.Lang.Object, INPUT testMethod AS CHARACTER):
        DYNAMIC-INVOKE (obj, testMethod).
        CATCH e AS Progress.Lang.Error :
            RETURN ERROR e.	
        END CATCH.
    END METHOD.

    /*------------------------------------------------------------------------------
        Invokes static method given.
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC STATIC VOID invokeStatic(INPUT obj AS Progress.Lang.Object, INPUT testMethod AS CHARACTER):
        DYNAMIC-INVOKE (obj:GetClass():TypeName, testMethod).
        CATCH e AS Progress.Lang.Error :
            RETURN ERROR e. 
        END CATCH.
    END METHOD.
    
    /*------------------------------------------------------------------------------
        Runs a particular @Test method
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC TestTestResult RunTestMethod(INPUT testClassType AS Progress.Lang.Object, INPUT testResult AS TestTestResult, INPUT testMethod AS TestInfo ):
        DEFINE VARIABLE expectedException AS CHARACTER NO-UNDO.
/*        DEFINE VARIABLE annotations AS Array NO-UNDO.        */
/*        DEFINE VARIABLE annotation AS AnnotationInfo NO-UNDO.*/
        DEFINE VARIABLE exception AS Progress.Lang.Error NO-UNDO.
        
/*        annotations = testMethod:annotations.                       */
/*        /** considering only the 1st annotation for now**/          */
/*        annotation = CAST(annotations:GetValue(1), AnnotationInfo ).*/

        expectedException = AnnotationUtil:GetExpectedExceptionName(testMethod:annotations).
       
        IF testMethod:isStatic THEN
            invokeStatic(testClassType, testMethod:getTestName()).
        ELSE
            Invoke(testClassType, testMethod:getTestName()).
        IF expectedException = "" THEN
        DO:
            testResult:TestResult = TestTestResult:StatusPassed.
            testResult:TestName = testMethod:getTestName().
        END.
        ELSE
        DO:
            testResult:TestResult = TestTestResult:StatusFailed.
            testResult:TestName = testMethod:getTestName().
            testResult:ErrorMessage = "Expecting:" + expectedException + " but this expection is not raised.".
            exception = NEW Progress.Lang.AppError("No exception is raised but expecting " + expectedException, 1).
            testResult:Error = exception.
        END.
        CATCH e AS Progress.Lang.Error :
            IF expectedException = "" THEN
            DO:
                IF (e:GetClass():TypeName = "OpenEdge.Core.AssertionFailedError") THEN
                DO:
                    testResult:TestResult  = TestTestResult:StatusFailed.
                    testResult:TestName = testMethod:getTestName().
                    testResult:Error = e.
                    testResult:ErrorMessage = e:GetMessage(1).
                END.
                ELSE
                DO:
                   testResult:TestResult  = TestTestResult:StatusError.
                    testResult:TestName = testMethod:getTestName().
                    testResult:Error = e.
                END.
            END.
            ELSE IF (ClassAnnotationInfo:IsTypeOf(e, GetExpectedErrorType(expectedException))) THEN
            DO:
                testResult:TestResult = TestTestResult:StatusPassed.
                testResult:TestName = testMethod:getTestName().
            END.
            ELSE 
            DO:
                testResult:TestResult = OpenEdge.ABLUnit.Results.TestTestResult:StatusFailed.
                testResult:TestName = testMethod:getTestName().
                testResult:ErrorMessage = "Expecting:" + expectedException + " but found:" + e:GetClass():TypeName.
                testResult:Error = e.
            END.
        END CATCH.
        FINALLY:
            RETURN testResult.	
        END FINALLY.
    END METHOD.
    
    /*----------------------------------------------------------------------------
        Expands the given expected error type if it is a recognised abbreviation.
      ----------------------------------------------------------------------------*/
    METHOD PUBLIC STATIC CHARACTER GetExpectedErrorType(INPUT expectedError AS CHARACTER):
    
        /* Add the package name for recognised error types */
        CASE expectedError:
            WHEN "Error"           
            OR 
            WHEN "AppError"
            OR 
            WHEN "ProError"
            OR 
            WHEN "SoapFaultError"          
            OR 
            WHEN "SysError" THEN
                RETURN "Progress.Lang." + expectedError.
            WHEN "Stop"
                OR
            WHEN "Quit" THEN
                RETURN "Progress.Lang.SysError".
        END CASE.
        RETURN expectedError.
    END METHOD.

    /*----------------------------------------------------------------------------
      Returns true if the given object can be cast to the given type. Otherwise 
      returns false.
    ----------------------------------------------------------------------------*/
    METHOD PUBLIC STATIC LOGICAL IsTypeOf(INPUT obj AS Progress.Lang.Object, INPUT castType AS CHARACTER):
        IF obj:GetClass():TypeName = castType THEN RETURN TRUE.
        DEFINE VARIABLE castObject AS Progress.Lang.Object NO-UNDO.
        castObject = DYNAMIC-CAST(obj, castType) NO-ERROR.
        IF ERROR-STATUS:ERROR OR ERROR-STATUS:NUM-MESSAGES > 0 THEN
            RETURN FALSE.
        RETURN TRUE.
    END METHOD.
  
    /*------------------------------------------------------------------------------
    Runs @TearDown annotated method.
    This method will be exectuted after executing each test method
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC VOID RunAfterMethod(INPUT testClassType AS Progress.Lang.Object, 
        INPUT testResult AS OpenEdge.ABLUnit.Results.TestTestResult):
        IF NOT afterMethod = ? THEN
        DO ON ERROR UNDO, THROW:
            Invoke(testClassType, afterMethod:getTestName()).
            CATCH e AS Progress.Lang.Error :
                RETURN ERROR e.
            END CATCH.
        END.
        RETURN.
    END METHOD.

    /*------------------------------------------------------------------------------
    Runs @After annotated method
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC OpenEdge.ABLUnit.Results.TestTypeResult RunAfterClass(INPUT testClassType AS Progress.Lang.Object):
        IF NOT afterClassMethod = ? AND NOT testList:size = 0 THEN
        DO ON ERROR UNDO, THROW:
            Invoke(testClassType, afterClassMethod:getTestName()).
            CATCH e AS Progress.Lang.Error :
                RETURN ERROR e.
            END CATCH.
        END.
    END METHOD.

    /*------------------------------------------------------------------------------
        Throws error for multiple occurence of lifecycle methods   
    ------------------------------------------------------------------------------*/
    METHOD PRIVATE VOID throwError( ):
        RETURN ERROR NEW Progress.Lang.AppError("Life cycle annotations can not occur more than once.", 0).
    END METHOD.
    
END CLASS.