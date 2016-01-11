/************************************************
Copyright (c)  2013-2014 by Progress Software Corporation. All rights reserved.
*************************************************/ 
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


USING OpenEdge.Core.AssertionFailedError.
USING OpenEdge.ABLUnit.Reflection.AnnotationInfo.
USING OpenEdge.ABLUnit.Reflection.TestInfo.
USING OpenEdge.ABLUnit.Results.TestTestResult.
USING OpenEdge.ABLUnit.Results.TestTypeResult.
USING OpenEdge.Core.Collections.Array.
USING OpenEdge.ABLUnit.Reflection.ClassAnnotationInfo.

CLASS OpenEdge.ABLUnit.Reflection.ProcedureAnnotationInfo: 
    
    DEFINE PRIVATE VARIABLE beforeProcMethod   AS  TestInfo   NO-UNDO.
    DEFINE PRIVATE VARIABLE beforeMethod       AS TestInfo    NO-UNDO.
    DEFINE PRIVATE VARIABLE testList           AS Array NO-UNDO.
    DEFINE PUBLIC PROPERTY testCount           AS INTEGER NO-UNDO GET. SET.
    DEFINE PRIVATE VARIABLE afterMethod        AS TestInfo    NO-UNDO.
    DEFINE PRIVATE VARIABLE afterProcMethod    AS TestInfo    NO-UNDO.
    DEFINE PRIVATE VARIABLE testInProcResult   AS TestTestResult NO-UNDO.
    
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
        
    CONSTRUCTOR PUBLIC ProcedureAnnotationInfo (  ):
        SUPER ().
        testList = NEW Array().
        testList:AutoExpand = TRUE.
    END CONSTRUCTOR.
    
    METHOD PUBLIC VOID setBeforeProcedure(INPUT bProc AS TestInfo):
        IF beforeProcMethod = ? THEN
            beforeProcMethod = bProc.
        ELSE 
            throwError().
    END METHOD.
    
    METHOD PUBLIC VOID setAfterProcedure(INPUT aProc AS TestInfo):
        IF afterProcMethod = ? THEN
            afterProcMethod = aProc.
        ELSE 
            throwError().
    END METHOD.
    
    METHOD PUBLIC VOID setBefore(INPUT beforeProc AS TestInfo):
        IF beforeMethod = ? THEN
            beforeMethod = beforeProc.
        ELSE 
            throwError().
    END METHOD.
    
    METHOD PUBLIC VOID setAfter(INPUT afterProc AS TestInfo):
        IF afterMethod = ? THEN
            afterMethod = afterProc.
        ELSE 
            throwError().
    END METHOD.
    
    METHOD PUBLIC VOID addTestProc(INPUT tProc AS TestInfo):
        testCount = testCount + 1.
        testList:SetValue(tProc, testCount).
    END METHOD.
    
    METHOD PUBLIC CHARACTER getBeforeProcedure():
        RETURN beforeProcMethod:getTestName().
    END METHOD.
    
    METHOD PUBLIC CHARACTER getAfterProcedure():
        RETURN afterProcMethod:getTestName().
    END METHOD.
    
    METHOD PUBLIC Array getTestProcs():
        RETURN testList.
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Runs @BeforeProcedure annotated procedure
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC TestTypeResult RunBeforeProcedure(INPUT procHandle AS HANDLE, INPUT testProcResult AS TestTypeResult):
        IF NOT beforeProcMethod = ? AND NOT testList:Size = 0 THEN
        DO ON ERROR UNDO, THROW:
            DEFINE VARIABLE beforeProc AS CHARACTER NO-UNDO.
            beforeProc = beforeProcMethod:getTestName().
            RUN value (beforeProc) IN procHandle NO-ERROR.
            IF (ERROR-STATUS:ERROR) THEN
                RETURN ERROR "Exception in @BeforeProcedure".
        END.
        RETURN testProcResult.
    END METHOD.    

    /*------------------------------------------------------------------------------
    Runs @Before annotated procedure
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC TestTestResult RunBefore(INPUT procHandle AS HANDLE, INPUT testProcResult AS TestTestResult):
        IF NOT beforeMethod = ? THEN 
        DO ON ERROR UNDO, THROW:
            DEFINE VARIABLE before AS CHARACTER NO-UNDO.
            before = beforeMethod:getTestName().
            RUN value (before) IN procHandle NO-ERROR.
            IF (ERROR-STATUS:ERROR) THEN
                RETURN ERROR "Exception in @Before procedure".
        END.
        RETURN testProcResult.
    END METHOD.    
    
    /*------------------------------------------------------------------------------
    Runs a particular @Test annotated procedure
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC TestTestResult RunTestProc(INPUT procHandle AS HANDLE, INPUT testProc AS TestInfo, INPUT testInProcResult AS TestTestResult):

        RUN value (testProc:getTestName()) IN procHandle.
         CATCH e AS Progress.Lang.Error :
             RETURN ERROR e.
        END CATCH.
   
    END METHOD.
    
    /*------------------------------------------------------------------------------
    Runs all @Test annotated procedure
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC TestTestResult RunSelectedTestProc(INPUT procHandle AS HANDLE, INPUT testProc AS TestInfo):
        DEFINE VARIABLE expectedException AS CHARACTER NO-UNDO.
        DEFINE VARIABLE annotations AS Array NO-UNDO. 
        DEFINE VARIABLE annotation AS AnnotationInfo NO-UNDO.
        annotations = testProc:annotations.
        /** considering only the 1st annotation for now**/
        annotation = CAST(annotations:GetValue(1), AnnotationInfo ).
        
        expectedException = annotation:getAttributeValue().
        testInProcResult = NEW TestTestResult().
        RunBefore(procHandle, testInProcResult).
        RunTestProc(procHandle, testProc, testInProcResult).
        /*Ensure that the execution proceeds normally and there are no expected exceptions*/
        IF expectedException = "" THEN DO:
            testInProcResult:TestResult = TestTestResult:StatusPassed.
            testInProcResult:TestName = testProc:getTestName().
        END.
        ELSE
        DO:
            testInProcResult:TestResult = TestTestResult:StatusFailed.
            testInProcResult:TestName = testProc:getTestName().
            testInProcResult:ErrorMessage = "Expecting:" + expectedException + " but this expection is not raised.".
            DEFINE VARIABLE exception AS Progress.Lang.Error NO-UNDO.
            exception = NEW Progress.Lang.AppError("No exception is raised but expecting " + expectedException, 1).
            testInProcResult:Error = exception.
        END.
        CATCH e AS Progress.Lang.Error :
            IF expectedException = "" THEN
            DO:
                IF (e:GetClass():TypeName = "OpenEdge.Core.AssertionFailedError") THEN
                DO:
                    testInProcResult:TestResult  = TestTestResult:StatusFailed.
                    testInProcResult:TestName = testProc:getTestName().
                    testInProcResult:Error = e.
                    testInProcResult:ErrorMessage = e:GetMessage(1).
                END.
                ELSE
                DO:
                    testInProcResult:TestResult  = TestTestResult:StatusError.
                    testInProcResult:TestName = testProc:getTestName().
                    testInProcResult:Error = e.
                END.
            END.
            ELSE IF (ClassAnnotationInfo:IsTypeOf(e, ClassAnnotationInfo:GetExpectedErrorType(expectedException))) THEN
            DO:
                testInProcResult:TestResult = TestTestResult:StatusPassed.
                testInProcResult:TestName = testProc:getTestName().
            END.
            ELSE 
            DO:
                testInProcResult:TestResult = OpenEdge.ABLUnit.Results.TestTestResult:StatusFailed.
                testInProcResult:TestName = testProc:getTestName().
                testInProcResult:ErrorMessage = "Expecting:" + expectedException + " but found:" + e:GetClass():TypeName.
                testInProcResult:Error = e.
            END.
        END CATCH.
        FINALLY:
            RunAfter(procHandle).
            CATCH e AS Progress.Lang.Error :
                testInProcResult:TestResult = TestTestResult:StatusError.
                updateTestResult(testInProcResult, e, testProc).
            END CATCH.
            FINALLY:
                RETURN testInProcResult.    
            END FINALLY.
        END FINALLY.
    END METHOD.
    
    METHOD PUBLIC VOID updateTestResult(INPUT testResult AS TestTestResult,INPUT err AS Progress.Lang.Error,  INPUT testProc AS TestInfo):
            testResult:TestName = testProc:getTestName().
            testResult:IsIncomplete = TRUE.
            testResult:Error = err.
        END METHOD.
    
    /*------------------------------------------------------------------------------
    Runs @After annotated procedure
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC VOID RunAfter(INPUT procHandle AS HANDLE):
        IF NOT afterMethod = ? THEN
        DO ON ERROR UNDO, THROW:
            DEFINE VARIABLE after AS CHARACTER NO-UNDO.
            after = afterMethod:getTestName().
            RUN value (after) IN procHandle NO-ERROR.
            IF (ERROR-STATUS:ERROR) THEN 
                RETURN ERROR "Exception in @After procedure".
        END.
    END METHOD.    
    
    /*------------------------------------------------------------------------------
    Runs @AfterProcedure annotated procedure
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC TestTypeResult RunAfterProcedure(INPUT procHandle AS HANDLE):
        IF NOT afterProcMethod = ? AND NOT testList:size = 0 THEN
        DO:
            DEFINE VARIABLE afterProc AS CHARACTER NO-UNDO.
            afterProc = afterProcMethod:getTestName().
            RUN value (afterProc) IN procHandle NO-ERROR.
            IF (ERROR-STATUS:ERROR) THEN
                RETURN ERROR "Exception in @AfterProcedure".
        END.
    END METHOD.

    METHOD PUBLIC VOID TestMethod(  ):
        
        RETURN ERROR NEW Progress.Lang.AppError().

    END METHOD.

    /*------------------------------------------------------------------------------
        Throws error for multiple occurence of lifecycle methods   
    ------------------------------------------------------------------------------*/
    METHOD PRIVATE VOID throwError( ):
        RETURN ERROR NEW Progress.Lang.AppError("Life cycle annotations can not occur more than once.", 0).
    END METHOD.
END CLASS.