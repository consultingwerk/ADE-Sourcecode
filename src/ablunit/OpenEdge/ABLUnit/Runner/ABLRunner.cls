/************************************************
Copyright (c) 2013-2021 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
   File        : ABLRunner
   Purpose     : Runner of the ABLUnit framework, which runs the testclasses, test procedures, testsuite classes,
                 testsuite procedures and ABL files inside a folder. 
   Syntax      : 
   Description : 
   Author(s)   : hgarapat
   Created     : Wed Jun 27 18:18:40 IST 2012
   Notes       : Modified the annotations. The newly modified annotations are common for both class and procedure files.
                 Current annotations are Before, Setup, Test, TearDown, After.
 ----------------------------------------------------------------------*/
BLOCK-LEVEL ON ERROR UNDO, THROW.

using OpenEdge.ABLUnit.Model.File FROM PROPATH.
using OpenEdge.ABLUnit.Model.IRunnableEntity.
using OpenEdge.ABLUnit.Model.TestCase.
using OpenEdge.ABLUnit.Model.TestClass FROM PROPATH.
using OpenEdge.ABLUnit.Model.TestEntity FROM PROPATH.
using OpenEdge.ABLUnit.Model.TestMethod FROM PROPATH.
using OpenEdge.ABLUnit.Model.TestProcedure FROM PROPATH.
using OpenEdge.ABLUnit.Model.TestRootModel FROM PROPATH.
using OpenEdge.ABLUnit.Model.TestSuite FROM PROPATH.
using OpenEdge.ABLUnit.Reflection.AnnotationInfo FROM PROPATH.
using OpenEdge.ABLUnit.Reflection.AnnotationUtil FROM PROPATH.
using OpenEdge.ABLUnit.Reflection.ClassAnnotationInfo FROM PROPATH.
using OpenEdge.ABLUnit.Reflection.ClassInfo FROM PROPATH.
using OpenEdge.ABLUnit.Reflection.ProcedureAnnotationInfo FROM PROPATH.
using OpenEdge.ABLUnit.Reflection.TestInfo FROM PROPATH.
using OpenEdge.ABLUnit.Reflection.TypeInfo FROM PROPATH.
using OpenEdge.ABLUnit.Results.TestResultEnum.
using OpenEdge.ABLUnit.Results.TestTestResult FROM PROPATH.
using OpenEdge.ABLUnit.Results.TestTypeResult FROM PROPATH.
using OpenEdge.ABLUnit.Runner.TestConfig FROM PROPATH.
using OpenEdge.ABLUnit.Writer.IResultsWriter.
using OpenEdge.ABLUnit.Writer.ResultsXmlWriter.
using OpenEdge.Core.Collections.Array FROM PROPATH.
using Progress.Json.ObjectModel.JsonArray FROM PROPATH.
using Progress.Json.ObjectModel.JsonObject FROM PROPATH.
using Progress.Lang.AppError FROM PROPATH.
using Progress.Lang.LockConflict.

CLASS OpenEdge.ABLUnit.Runner.ABLRunner: 
    DEFINE PRIVATE STREAM dirlist.
    
    /*
    Class members
    */    
    DEFINE PRIVATE VARIABLE isTestSuite       AS LOGICAL   NO-UNDO INIT FALSE.
    DEFINE PRIVATE VARIABLE testSuiteName     AS CHARACTER NO-UNDO.
    DEFINE PRIVATE VARIABLE testSuiteCreated  AS LOGICAL   NO-UNDO INIT FALSE.
    DEFINE PRIVATE VARIABLE testCasesCount    AS INTEGER   NO-UNDO INIT 0.
    DEFINE PRIVATE VARIABLE writtenFilesCount AS INTEGER   NO-UNDO INIT 0.
    DEFINE PRIVATE VARIABLE testSuiteHandle   AS HANDLE    NO-UNDO.
    
    DEFINE PRIVATE VARIABLE ABLUNIT_VERSION   AS CHARACTER  NO-UNDO INIT "VERSION".
    DEFINE PRIVATE VARIABLE TEST_TREE   AS CHARACTER  NO-UNDO INIT "TEST_TREE".
    DEFINE PRIVATE VARIABLE TREE_DEPTH_END   AS CHARACTER  NO-UNDO INIT "\NULL".
             
    DEFINE PRIVATE VARIABLE testModel AS TestRootModel NO-UNDO.
    DEFINE PRIVATE VARIABLE TEST_FOLDER_ROOT AS CHARACTER NO-UNDO INIT "TEST_ROOT".   
    DEFINE PRIVATE VARIABLE currentID AS INTEGER NO-UNDO INIT 0.
    
    DEFINE PRIVATE VARIABLE testMethodInfo  AS TestInfo NO-UNDO.
    DEFINE PRIVATE VARIABLE testConfig AS TestConfig NO-UNDO.
    DEFINE PRIVATE VARIABLE updateFile AS CHARACTER NO-UNDO.
    DEFINE PRIVATE VARIABLE prevStackTraceProperty AS LOGICAL NO-UNDO.
    DEFINE PRIVATE VARIABLE oldWarningsList AS CHARACTER NO-UNDO.
    DEFINE PRIVATE VARIABLE ablResultsFile AS CHARACTER NO-UNDO.
    
    /* Default constructor */
    CONSTRUCTOR PUBLIC ABLRunner (  ):
        SUPER ().
        testModel = NEW TestRootModel(currentID).
        currentID = currentID + 1.
        testModel:name = TEST_FOLDER_ROOT.
        updateStackTraceProperty().
        oldWarningsList = SESSION:SUPPRESS-WARNINGS-LIST.
        SESSION:SUPPRESS-WARNINGS-LIST = '6430,' + SESSION:SUPPRESS-WARNINGS-LIST.
    END CONSTRUCTOR.
    
    METHOD PRIVATE VOID updateStackTraceProperty():
     prevStackTraceProperty = SESSION:ERROR-STACK-TRACE.
     SESSION:ERROR-STACK-TRACE = TRUE.
    END METHOD.
    
    /*------------------------------------------------------------------------------
     Purpose: This is newly added constructor, which accepts formatted JSON object of configuration file.
     Notes:
    ------------------------------------------------------------------------------*/
    CONSTRUCTOR PUBLIC ABLRunner (INPUT inputConfig AS CLASS TestConfig, INPUT updateFile AS CHARACTER ):
        THIS-OBJECT().
        DEFINE VARIABLE outputLocation AS CHARACTER NO-UNDO.
        IF inputConfig = ? THEN
            RETURN ERROR NEW AppError("TestConfig can not be null.", 0).
        testConfig = inputConfig.
        /*Get the ABLUnit results file*/
        ablResultsFile = testConfig:GetResultsFile().
        THIS-OBJECT:updateFile = updateFile.
    END CONSTRUCTOR.
    
    /*------------------------------------------------------------------------------
     Purpose: This method runs the tests that are passed as JsonObject.
     Notes:
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC VOID RunTests(  ):
        DEFINE VARIABLE testsArray AS JsonArray NO-UNDO.
        DEFINE VARIABLE testCasesArray AS JsonArray NO-UNDO.
        DEFINE VARIABLE testIndex AS INTEGER NO-UNDO.
        DEFINE VARIABLE caseIndex AS INTEGER NO-UNDO.
        DEFINE VARIABLE testEntity AS TestEntity NO-UNDO.
        define variable writer as IResultsWriter no-undo.
        
        testsArray = testConfig:testsJson.
        
        DEFINE VARIABLE testJson AS JsonObject NO-UNDO.
        DEFINE VARIABLE testResource AS CHARACTER NO-UNDO.
        
        assign writer = new ResultsXmlWriter().
        
        DO testIndex = 1 TO testsArray:Length:
            testJson = testsArray:GetJsonObject(testIndex).
            IF (testJson:Has("folder")) THEN DO:
                testResource = testJson:GetCharacter("folder").
                testEntity = populateTestModel(testResource, 1).
                updateFile(updateFile, "TEST_TREE" + " "  +  loadSerializedTree(testEntity), FALSE).
            END.
            ELSE IF (testJson:Has("test")) THEN DO:
                testResource = testJson:GetCharacter("test").
                IF (testJson:Has("cases")) THEN DO:
                    testCasesArray = testJson:GetJsonArray("cases").
                    DEFINE VARIABLE testCase AS CHARACTER NO-UNDO.
                    testCase = testCasesArray:GetCharacter(1).
                    testEntity = populateTestModel(testResource + "#" + testCase, testCasesArray:Length + 1).
                    updateFile(updateFile, "TEST_TREE" + " "  +  loadSerializedTree(testEntity), FALSE).
                END.
                ELSE DO:
                    testEntity = populateTestModel(testResource, 1).
                    updateFile(updateFile, "TEST_TREE" + " "  +  loadSerializedTree(testEntity), FALSE).
                END.
            END. 
        END.
        IF testEntity NE ? THEN DO:
            runtests(testEntity, updateFile).
            writer:WriteToFile(ablResultsFile, testEntity).
        END.
        
          FINALLY:
              /* COMPLETE event has to be updated anyway to complete the session. */
              updateFile(updateFile, "COMPLETE", FALSE).
              SESSION:ERROR-STACK-TRACE = prevStackTraceProperty.
              SESSION:SUPPRESS-WARNINGS-LIST = oldWarningsList.
        END.
    END METHOD.
    
    /*------------------------------------------------------------------------------
        Generates the procedure information in xref xml file
        
        @param character The ABL program (.P or .CLS) file name 
        @return TypeInfo Unit test type info about the program 
    ------------------------------------------------------------------------------*/   
    METHOD PUBLIC TypeInfo BuildTypeInfo (INPUT testCase AS CHARACTER ):
        DEFINE VARIABLE xrefFile AS CHARACTER NO-UNDO.
        DEFINE VARIABLE typeInfo AS TypeInfo NO-UNDO.
        
        xrefFile = SESSION:TEMP-DIR + testConfig:ResultsFileName + ".xref".
        COMPILE value(testCase) xref-xml VALUE(xrefFile).
        typeInfo = ParseXMLDocument(xrefFile).
        /*Adding a check for debug mode for users to inspect the file in case something unexpected happens.*/
        IF NOT SESSION:DEBUG-ALERT THEN
            OS-DELETE value(xrefFile).
        RETURN typeInfo.
        // If any one of the test case/suites doesn't compile, then the whole test run fails.
        // Return a better message so that we know which test case failed to build 
        catch err as Progress.Lang.Error:
            undo, throw new AppError(substitute('Unable to build type info for &1: &2',
                                     testCase, err:GetMessage(1)),
                                     0).
        end catch.
    END METHOD.
    
    /*----------------------------------------------------------------------------
        Returns the relative path to the .cls file for the given class.
    ----------------------------------------------------------------------------*/  
    METHOD PRIVATE CHARACTER GetClassFile(INPUT typeClass AS Progress.Lang.Class):
        RETURN REPLACE(typeClass:TypeName, ".", "/") + ".cls".
    END METHOD.

    /*------------------------------------------------------------------------------
        Parses the XREF XML file for Test Methods and Procedures
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC TypeInfo ParseXMLDocument(INPUT xmlDocument AS CHARACTER):
  
        DEFINE VARIABLE xmlDoc           AS HANDLE  NO-UNDO.
        DEFINE VARIABLE xmlDocElement    AS HANDLE  NO-UNDO.
        DEFINE VARIABLE xmlSourceElement AS HANDLE  NO-UNDO.
        DEFINE VARIABLE i                AS INTEGER NO-UNDO.
        
        CREATE X-DOCUMENT xmlDoc.
        CREATE X-NODEREF xmlDocElement.
        CREATE X-NODEREF xmlSourceElement.
        xmlDoc:SUPPRESS-NAMESPACE-PROCESSING = TRUE.
        xmlDoc:LOAD("FILE", xmlDocument, FALSE).
        
        xmlDoc:GET-DOCUMENT-ELEMENT(xmlDocElement).
        
        DO i = 1 TO xmlDocElement:NUM-CHILDREN:
            xmlDocElement:GET-CHILD(xmlSourceElement,i).
            IF xmlSourceElement:SUBTYPE = "ELEMENT" AND xmlSourceElement:NAME = "SOURCE" THEN 
            DO:
                RETURN ParseSourceElement(xmlSourceElement).
            END.
        END.
    
        FINALLY:
            DELETE OBJECT xmlDoc NO-ERROR.
            DELETE OBJECT xmlDocElement NO-ERROR.
            DELETE OBJECT xmlSourceElement NO-ERROR.
        END FINALLY.
    END METHOD.    
    
    /*----------------------------------------------------------------------------
        Returns the value of the 'Reference-type' attribute in the given XML element. 
    ----------------------------------------------------------------------------*/  
    METHOD PRIVATE CHARACTER GetRefTypeAttribute(INPUT xmlElement AS HANDLE):
        RETURN xmlElement:GET-ATTRIBUTE("Reference-type").
    END.
  
    /*----------------------------------------------------------------------------
      Returns the value of the 'Object-identifier' attribute in the given XML 
      element. 
    ----------------------------------------------------------------------------*/   
    METHOD PRIVATE CHARACTER GetObjectIdAttribute(INPUT xmlElement AS HANDLE):
        RETURN xmlElement:GET-ATTRIBUTE("Object-identifier").
    END METHOD.
  
    /*----------------------------------------------------------------------------
    Parses a <source> element in the xml-xref, looking for methods and 
    annotations. Methods preceded by annotations are added to the given 
    MethodInfo list.
----------------------------------------------------------------------------*/
       
    METHOD PRIVATE TypeInfo ParseSourceElement(INPUT xmlSourceElement AS HANDLE):
    
        DEFINE VARIABLE xmlRefElement  AS HANDLE                                     NO-UNDO.
        DEFINE VARIABLE nodeType       AS CHARACTER                                  NO-UNDO.
        DEFINE VARIABLE i              AS INTEGER                                    NO-UNDO.
        DEFINE VARIABLE j              AS INTEGER                                    NO-UNDO.
        DEFINE VARIABLE methodName     AS CHARACTER                                  NO-UNDO.
        DEFINE VARIABLE annotationsInfo AS Array NO-UNDO.
        DEFINE VARIABLE annotationsCount AS INTEGER NO-UNDO INIT 0.
        DEFINE VARIABLE classInfo      AS ClassInfo      NO-UNDO.
        DEFINE VARIABLE methodInfoList  AS Array  NO-UNDO.
        DEFINE VARIABLE typeInfo  AS TypeInfo  NO-UNDO.
        DEFINE VARIABLE isStaticHandle AS HANDLE NO-UNDO.
        DEFINE VARIABLE isStaticValueHandle AS HANDLE NO-UNDO.
        
        DEFINE VARIABLE isTestSuiteClass AS LOGICAL NO-UNDO.
        
        CREATE X-NODEREF xmlRefElement.
        CREATE X-NODEREF isStaticValueHandle.
        CREATE X-NODEREF isStaticHandle.
        
        methodInfoList = NEW Array().
        methodInfoList:AutoExpand = TRUE.
        typeInfo = NEW OpenEdge.ABLUnit.Reflection.TypeInfo().
        
        annotationsInfo = NEW Array().
        annotationsInfo:AutoExpand = TRUE.
        
        DO i = 1 TO xmlSourceElement:NUM-CHILDREN:
            xmlSourceElement:GET-CHILD(xmlRefElement, i).
            IF xmlRefElement:SUBTYPE = "ELEMENT" AND xmlRefElement:NAME = "Reference" THEN 
            DO:
                nodeType = GetRefTypeAttribute(xmlRefElement).
                
                CASE nodeType:
                    WHEN "ANNOTATION" THEN 
                        DO:
                            DEFINE VARIABLE annotationInfo AS AnnotationInfo NO-UNDO.
                            annotationInfo = NEW AnnotationInfo(GetObjectIdAttribute(xmlRefElement)).
                            annotationsCount = annotationsCount + 1.
                            annotationsInfo:SetValue(annotationInfo,  annotationsCount).
                        END.
                    WHEN "CLASS" THEN 
                        DO:
                            IF classInfo = ? THEN 
                            DO:
                                 classInfo = NEW ClassInfo(GetObjectIdAttribute(xmlRefElement), annotationsInfo).
                                 typeInfo:classInfo = classInfo.
                                 isTestSuiteClass = AnnotationUtil:HasAnnotation(annotationsInfo, "TestSuite").
                                 IF isTestSuiteClass THEN
                                    LEAVE.
                                 // Done processing class level annotations, reset annotaions here.
                                 annotationsCount = 0.
                                 annotationInfo = ?.
                                 annotationsInfo = NEW Array().
                                 annotationsInfo:AutoExpand = TRUE.
                            END.
                        END.
                    WHEN "METHOD" THEN 
                        DO:
                            IF NOT annotationInfo EQ ? THEN 
                            DO:
                                DEFINE VARIABLE methodIn AS TestInfo NO-UNDO.
                                methodIn = NEW TestInfo(annotationsInfo, annotationsCount, GetObjectIdAttribute(xmlRefElement)).
                                typeInfo:methodsCount = typeInfo:methodsCount + 1.
                                REPEAT j = 1 TO xmlRefElement:NUM-CHILDREN:
                                    xmlRefElement:GET-CHILD(isStaticHandle, j).
                                    IF isStaticHandle:SUBTYPE <> "element" THEN NEXT.
                                        IF isStaticHandle:NAME = "Is-Static" THEN DO:
                                            isStaticHandle:GET-CHILD(isStaticValueHandle, 1).
                                            methodIn:isStatic = LOGICAL (isStaticValueHandle:NODE-VALUE).
                                            LEAVE.
                                        END.
                                END.
                                methodInfoList:SetValue(methodIn, typeInfo:methodsCount).
                                annotationsCount = 0.
                                annotationInfo = ?.
                                annotationsInfo = NEW Array().
                                annotationsInfo:AutoExpand = TRUE.
                            END.
                        END.
                    WHEN "PROCEDURE" THEN 
                        DO:
                            IF NOT annotationInfo EQ ? THEN 
                            DO:
                                DEFINE VARIABLE procIn AS TestInfo NO-UNDO.
                                procIn = NEW TestInfo(annotationsInfo, annotationsCount, GetObjectIdAttribute(xmlRefElement)).
                                typeInfo:methodsCount = typeInfo:methodsCount + 1.
                                methodInfoList:SetValue(procIn, typeInfo:methodsCount).
                                annotationsCount = 0.
                                annotationInfo = ?.
                                annotationsInfo = NEW Array().
                                annotationsInfo:AutoExpand = TRUE.
                            END.
                        END.
                END CASE.
            END.
        END.
        
        /*
        This condition is for testsuites, which has only one annotation preceding the class definition and no methods.
        */
       IF typeInfo:methodsCount = 0 AND isTestSuiteClass AND NOT classInfo = ? THEN
        DO:
            DEFINE VARIABLE emptyMethod AS TestInfo NO-UNDO.
            emptyMethod = NEW TestInfo(classInfo:annotationsInfo, annotationsCount,  ?).
            typeInfo:methodsCount =  typeInfo:methodsCount + 1.
            methodInfoList:SetValue(emptyMethod, typeInfo:methodsCount).
            annotationInfo = ?.
           
        END. 
        /*
        This condition is for testsuites, which has only one annotation in the procedure file.
        */
        ELSE IF typeInfo:methodsCount = 0 AND NOT annotationInfo = ? THEN
            DO:
                DEFINE VARIABLE emptyProcedure AS TestInfo NO-UNDO.
                emptyProcedure = NEW TestInfo(annotationsInfo, annotationsCount,  ?).
                typeInfo:methodsCount =  typeInfo:methodsCount + 1.
                methodInfoList:SetValue(emptyProcedure, typeInfo:methodsCount).
                annotationInfo = ?.
            END.
            
       typeInfo:methods = methodInfoList.
       RETURN typeInfo.
        FINALLY:
            DELETE OBJECT xmlRefElement NO-ERROR.
            DELETE OBJECT xmlSourceElement NO-ERROR.
            DELETE OBJECT isStaticHandle NO-ERROR.
            DELETE OBJECT isStaticValueHandle NO-ERROR.
        END FINALLY.
    END METHOD.

    /*------------------------------------------------------------------------------
            Given a testclass and test method, this method will store and 
            run the test methods and calls a method which writes the results in the xml file
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC VOID populateTestModelForTestClass(INPUT testClassName AS CHARACTER, 
                                                     input testMethod as character,
                                                     input testEntity as TestEntity):
        DEFINE VARIABLE testClassType   AS Progress.Lang.Object                       NO-UNDO.
        DEFINE VARIABLE methodInfoList  AS Array  NO-UNDO.
        DEFINE VARIABLE testSuiteInfo   AS TestInfo       NO-UNDO.
        DEFINE VARIABLE classAnnotInfo  AS ClassAnnotationInfo NO-UNDO.
        DEFINE VARIABLE i               AS INTEGER                                    NO-UNDO.
        DEFINE VARIABLE testSuiteCount  AS INTEGER                                    NO-UNDO INIT 0.
        DEFINE VARIABLE annotationName  AS CHARACTER                                  NO-UNDO.
        DEFINE VARIABLE ignoreTest  AS LOGICAL                                  NO-UNDO.
        DEFINE VARIABLE testResult AS TestTestResult NO-UNDO.
        DEFINE VARIABLE typeInfo AS TypeInfo NO-UNDO.
        define variable isTestClass as logical no-undo initial no.
        
        /** for qualified classes input **/
        testClassName = getRelativePathOfClasses(testClassName). 
        typeInfo = BuildTypeInfo(testClassName).
        
        methodInfoList = typeInfo:methods.
        classAnnotInfo = NEW ClassAnnotationInfo().
        
        // Check whether the test method is ignored
        ignoreTest = AnnotationUtil:HasIgnoreAnnotation(typeInfo:classInfo:annotationsInfo).
        /*
        Loop through the parsed method information from xref xml file
        */
        DEFINE VARIABLE testInfo AS TestInfo.
        
        
        DO i=1 TO typeInfo:methodsCount:
            testInfo = CAST(methodInfoList:GetValue(i), TestInfo).
            
            DEFINE VARIABLE annotations AS Array NO-UNDO.
            DEFINE VARIABLE annotationsCount AS INTEGER NO-UNDO.
            DEFINE VARIABLE annotationInfo AS AnnotationInfo NO-UNDO.
            DEFINE VARIABLE j AS INTEGER NO-UNDO.
            
            annotations = testInfo:annotations.
            annotationsCount = testInfo:annotationsCount.
            
            DO j=1 TO annotationsCount:
            annotationInfo = CAST(annotations:GetValue(j), AnnotationInfo).
            annotationName = annotationInfo:getAnnotationName().
            CASE annotationName:
                WHEN "TestSuite" THEN
                IF NOT ignoreTest THEN
                    assign testSuiteCount = testSuiteCount + 1
                           testSuiteInfo  = testInfo
                           isTestClass    = true
                           .
                WHEN "Before" THEN
                DO:
                    classAnnotInfo:setBeforeClass(testInfo).
                    IF testInfo:getTestName() = testMethod THEN
                        assign testMethodInfo = testInfo.
                END.
                    
                WHEN "Setup" THEN
                do:
                    classAnnotInfo:setBeforeMethod(testInfo).
                    IF testInfo:getTestName() = testMethod THEN
                        assign testMethodInfo = testInfo.
                END.
                    
                WHEN "Test" THEN
                DO:
                    classAnnotInfo:AddTestMethod(testInfo).
                    
                    // if there's one annotated method, this is a test
                    assign isTestClass = true.
                    
                    IF testInfo:getTestName() = testMethod THEN
                        assign testMethodInfo = testInfo.
                END.
                    
                WHEN "TearDown" THEN
                DO:
                    classAnnotInfo:setAfterMethod(testInfo).
                    IF testInfo:getTestName() = testMethod THEN
                        assign testMethodInfo = testInfo.
                END.
                    
                    
                WHEN "After" THEN
                DO:
                    classAnnotInfo:setAfterClass(testInfo).
                    IF testInfo:getTestName() = testMethod THEN
                        assign testMethodInfo = testInfo.
                END.
            END CASE.
            END.
        END.
        
        if not isTestClass then
            return.
        
        IF NOT testSuiteCount = 0  THEN
        DO:
            isTestSuite =  TRUE.
            
            DEFINE VARIABLE testSuite AS TestSuite.
            testSuite = NEW TestSuite(currentID).
            currentID = currentID + 1. 
            testSuite:Name = testClassName.
            testModel:addTestEntity(testSuite).
            testSuite:classInfo = typeInfo:classInfo.
            // Check whether the suite class is ignored
            IF ignoreTest THEN 
                UpdateIgnoreDetails(testResult, testSuite, testClassName, testModel:Summary).
            ELSE
                populateTestModelForTestSuite(testSuiteInfo, testSuite).
        END.
        ELSE DO:
            DEFINE VARIABLE testClass AS TestClass NO-UNDO.
            testClass = NEW TestClass(currentID).
                currentID = currentID + 1. 
            testClass:Name = testClassName.
            testClass:AnnotationInfo = classAnnotInfo.  
            testClass:classInfo = typeInfo:classInfo.
            testEntity:addTestEntity(testClass).
            // Check whether the class is ignored
            IF ignoreTest THEN 
                UpdateIgnoreDetails(testResult, testClass, testClassName, testModel:Summary).
            ELSE 
                populateTestModelForTestMethod(testClassType, testClassName, classAnnotInfo, testMethodInfo, (testMethod = ""), testClass).

        END.
            
    END METHOD.
    
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    METHOD PRIVATE VOID UpdateIgnoreDetails( testResult AS TestTestResult, testEntity AS TestEntity, testName AS CHARACTER, summaryResult AS TestTypeResult ):
        assign testResult = NEW TestTestResult(testName).
        testResult:TestResult = TestResultEnum:StatusIgnored.
        
        testEntity:AddTestResult(testResult).
        
        summaryResult:Add(testResult).
    END METHOD.

    METHOD PUBLIC VOID populateTestModelForTestMethod(INPUT testClassType AS Progress.Lang.Object,
                                                      input testClassName as character, 
                                                      input classAnnotInfo as ClassAnnotationInfo,
                                                      input testMethodInfo as TestInfo, 
                                                      input runAllMethods as logical,
                                                      input testEntity as TestEntity):
        DEFINE VARIABLE testmethods  AS Array NO-UNDO.
        DEFINE VARIABLE testmethod  AS TestMethod NO-UNDO.
        DEFINE VARIABLE testInSuitResult AS TestTestResult NO-UNDO.
        DEFINE VARIABLE ignoreTest AS LOGICAL NO-UNDO.
        define variable testInfo as TestInfo.
        define variable j as integer no-undo.
        define variable testCount as integer no-undo.
        
        assign testCount  = classAnnotInfo:Tests:Size.
        IF(runAllMethods) THEN
        DO j=1 TO testCount:
            testMethod = NEW TestMethod(currentID).
            currentID = currentID + 1.
            
            testInfo = cast(classAnnotInfo:Tests:Get(j), TestInfo).
            
            testmethod:Name = testInfo:getTestName().
            testmethod:setTestInfo(testInfo).
            testEntity:addTestEntity(testmethod).
        END.
        ELSE
        DO:
            testMethod = NEW TestMethod(currentID).
            currentID = currentID + 1.
            testmethod:Name = testMethodInfo:getTestName().
            testmethod:setTestInfo(testMethodInfo).
            testEntity:addTestEntity(testmethod).
        END.
    END METHOD.
    
    METHOD PUBLIC VOID populateTestModelForInternalProcs(INPUT procHandle AS HANDLE,
                                                         INPUT testProcedureName AS CHARACTER,
                                                         INPUT procAnnotInfo AS ProcedureAnnotationInfo,
                                                         INPUT testProcInfo AS TestInfo,
                                                         INPUT runAllProcs AS LOGICAL, 
                                                         INPUT testEntity AS TestEntity):
        DEFINE VARIABLE testProcsCount AS INTEGER NO-UNDO.
        DEFINE VARIABLE j AS INTEGER NO-UNDO.
        DEFINE VARIABLE internalProcTestEntity AS TestMethod NO-UNDO.
        DEFINE VARIABLE testInfo AS TestInfo.
        
        assign testProcsCount = procAnnotInfo:Tests:Size.
        IF(runAllProcs) THEN
        DO j=1 TO testProcsCount:
            internalProcTestEntity = NEW TestMethod(currentID).
            currentID = currentID + 1.
            
            testInfo = cast(procAnnotInfo:Tests:Get(j), TestInfo).
            
            internalProcTestEntity:Name = testInfo:getTestName().
            internalProcTestEntity:setTestInfo(testInfo).
            testEntity:addTestEntity(internalProcTestEntity).
        END.
        ELSE
        DO:
            internalProcTestEntity = NEW TestMethod(currentID).
            currentID = currentID + 1.
            internalProcTestEntity:Name = testProcInfo:getTestName().
            internalProcTestEntity:setTestInfo(testProcInfo).
            testEntity:addTestEntity(internalProcTestEntity).
        END.
    END METHOD.
    
    /*------------------------------------------------------------------------------
            Given a test procedure and test internal procedure, this method will store and 
            run the test procedures and calls a method which writes the results in the xml file
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC VOID populateTestModelForProcedureType(INPUT testProcedureName AS CHARACTER, INPUT testInternalProcedure AS CHARACTER, INPUT testEntity AS TestEntity):
        DEFINE VARIABLE procHandle     AS        HANDLE                                    NO-UNDO.
        DEFINE VARIABLE procInfoList   AS        Array      NO-UNDO.
        DEFINE VARIABLE procAnnotInfo  AS        ProcedureAnnotationInfo NO-UNDO.
        DEFINE VARIABLE testSuiteList  AS        TestInfo      NO-UNDO.
        DEFINE VARIABLE i              AS        INTEGER                                   NO-UNDO.
        DEFINE VARIABLE testSuiteCount AS        INTEGER                                   NO-UNDO INIT 0.
        DEFINE VARIABLE annotation AS             CHARACTER NO-UNDO.
        DEFINE VARIABLE attributeName  AS        CHARACTER                                 NO-UNDO.
        DEFINE VARIABLE attributeValue AS        CHARACTER                                 NO-UNDO.
        DEFINE VARIABLE testProcInfo   AS        TestInfo      NO-UNDO.
        DEFINE VARIABLE procTestEntity   AS      TestProcedure     NO-UNDO.
        DEFINE VARIABLE typeInfo AS TypeInfo  NO-UNDO.
        DEFINE VARIABLE ignoreTest AS LOGICAL  NO-UNDO.
        define variable isTestProc as logical no-undo initial no.
        
        typeInfo = BuildTypeInfo(testProcedureName).
        procInfoList = typeInfo:methods.
        
        procAnnotInfo = NEW ProcedureAnnotationInfo().  
        /*
        Loops through the procedure information obtained from xref xml file
        */     
        DEFINE VARIABLE testInfo AS TestInfo.        
        DO i=1 TO typeInfo:methodsCount:
            testInfo = CAST(procInfoList:GetValue(i), TestInfo).
            DEFINE VARIABLE annotations AS Array NO-UNDO.
            DEFINE VARIABLE annotationsCount AS INTEGER NO-UNDO.
            DEFINE VARIABLE annotationInfo AS AnnotationInfo NO-UNDO.
            DEFINE VARIABLE j AS INTEGER NO-UNDO.
            annotations = testInfo:annotations.
            annotationsCount = testInfo:annotationsCount.
            DO j=1 TO annotationsCount:
            annotationInfo = CAST(annotations:GetValue(j), AnnotationInfo).
            annotation = annotationInfo:getAnnotationName().
            CASE annotation:
                WHEN "TestSuite" THEN
                    assign testSuiteCount = testSuiteCount + 1
                           testSuiteList  = testInfo
                           isTestProc     = yes
                           .
                    
                WHEN "Before" THEN
                DO:
                    procAnnotInfo:setBeforeProcedure(testInfo).
                    IF testInfo:getTestName() = testInternalProcedure THEN
                        testProcInfo = testInfo.
                END.
                    
                WHEN "Setup" THEN
                DO:
                    procAnnotInfo:setBefore(testInfo).
                    IF testInfo:getTestName() = testInternalProcedure THEN
                        testProcInfo = testInfo.
                END.
                    
                WHEN "Test" THEN
                DO:
                    procAnnotInfo:addTestProc(testInfo).
                    
                    // if there's one annotated method, this is a test
                    assign isTestProc = true.
                    
                    IF testInfo:getTestName() = testInternalProcedure THEN
                        testProcInfo = testInfo.
                END.
                    
                WHEN "TearDown" THEN
                DO:
                    procAnnotInfo:setAfter(testInfo).
                    IF testInfo:getTestName() = testInternalProcedure THEN
                        testProcInfo = testInfo.
                END.
                    
                WHEN "After" THEN
                DO:
                    procAnnotInfo:setAfterProcedure(testInfo).
                    IF testInfo:getTestName() = testInternalProcedure THEN
                        testProcInfo = testInfo.
                END.
                WHEN "Ignore" THEN
                   ignoreTest = TRUE.
            END CASE.
            END.
        END.
        
        if not isTestProc then
            return.
        
        IF NOT testSuiteCount = 0  THEN 
        DO:
            isTestSuite =  TRUE.
            testSuiteName = testProcedureName.
            DEFINE VARIABLE testProcSuite AS TestEntity.
            testProcSuite = NEW TestSuite(currentID).
            currentID = currentID + 1.
            testProcSuite:Name = testSuiteName.
            testEntity:addTestEntity(testProcSuite). 
            // Check whether the suite proc is ignored
            IF ignoreTest THEN 
            DO:
                DEFINE VARIABLE testResult AS TestTestResult NO-UNDO.
                UpdateIgnoreDetails(testResult, testProcSuite, testSuiteName, testModel:Summary).
            END.
            ELSE
                populateTestModelForTestSuite(testSuiteList, testProcSuite). 
        END.
        ELSE IF testSuiteCount = 0 THEN
        DO:
            procTestEntity = NEW TestProcedure(currentID).
            currentID = currentID + 1.
            procTestEntity:Name = testProcedureName.
            procTestEntity:AnnotationInfo = procAnnotInfo.
            testEntity:addTestEntity(procTestEntity).  
            IF testInternalProcedure = "" THEN
                populateTestModelForInternalProcs(procHandle, testProcedureName, procAnnotInfo, testProcInfo, TRUE, procTestEntity).
            ELSE
                populateTestModelForInternalProcs(procHandle, testProcedureName, procAnnotInfo, testProcInfo, FALSE, procTestEntity).   
        END.         
    END METHOD.
    
    /*------------------------------------------------------------------------------
       Compiles and call the corresponding method or internal procedure to run the testcase
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC VOID populateTestModelForTestCase(INPUT testCase AS CHARACTER, INPUT test AS CHARACTER, INPUT testEntity AS TestEntity):
            IF(testCase MATCHES "*.p") THEN
                populateTestModelForProcedureType(testCase, test, testEntity).
            /*We should explicitly check that file is class or not*/
            ELSE IF(testCase MATCHES "*.cls") THEN 
                populateTestModelForTestClass(testCase, test, testEntity).
    END METHOD.
    
    /*------------------------------------------------------------------------------
            Runs the corresponding method based on the type of the testcase.
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC TestEntity populateTestModel(INPUT testCase AS CHARACTER, INPUT testCount AS INTEGER):
        DEFINE VARIABLE serializedtree AS LONGCHAR  NO-UNDO.
        populateTestModel(testCase, testCount, testModel).
        serializedtree = loadSerializedTree(testModel).
       RETURN testModel.
      END METHOD.

    /*------------------------------------------------------------------------------
            load serialized tree                                                                       
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC LONGCHAR loadSerializedTree(INPUT testEntity AS TestEntity):
    DEFINE VARIABLE testEntities AS Array NO-UNDO.
    DEFINE VARIABLE newTestEntity AS TestEntity NO-UNDO.
    DEFINE VARIABLE i AS INTEGER NO-UNDO.
    DEFINE VARIABLE serializedtree AS LONGCHAR NO-UNDO.
    DEFINE VARIABLE isTestSuite AS CHARACTER NO-UNDO INIT "false".
    testEntities = testEntity:getTestEntities().
   
    DO i=1 TO testEntity:getChildrenSize():
        newTestEntity = CAST(testEntities:GetValue(i), TestEntity).
        serializedTree = serializedTree + loadSerializedTree(newTestEntity).
     END.
        
     IF(TYPE-OF (testEntity, TestSuite)) THEN
         isTestSuite = "true".
     serializedTree =   testEntity:Name + "?" + isTestSuite + "?" + String(testEntity:id) +  "*" + serializedTree + TREE_DEPTH_END + "*".
     RETURN serializedTree.
    END METHOD.
    
    /*------------------------------------------------------------------------------
            populates the model based on the test input. looks at all the relavant test methods,internal procedures in the test input.                                                                        
    ------------------------------------------------------------------------------*/
    METHOD PRIVATE VOID populateTestModel(INPUT testCase AS CHARACTER, INPUT testCount AS INTEGER, INPUT testEntity AS TestEntity):
        IF testCount = 1 THEN 
        DO:
            FILE-INFO:FILE-NAME = testCase.
            /** For directory inputs **/
            IF (FILE-INFO:FILE-TYPE BEGINS "D") THEN  
                populateTestModelForTestFolder(testCase, testEntity).
            ELSE
                populateTestModelForTestCase(testCase, "", testEntity).
        END.
        ELSE 
        DO:
            DEFINE VARIABLE testClass  AS CHARACTER NO-UNDO.
            DEFINE VARIABLE testMethod AS CHARACTER NO-UNDO.
            testClass = ENTRY(1, testCase, "#").
            testMethod = ENTRY(2, testCase, "#").
            FILE-INFO:FILE-NAME = testCase.
            IF (FILE-INFO:FILE-TYPE BEGINS "D") THEN
                populateTestModelForTestFolder(testCase, testEntity). 
            ELSE IF (testClass MATCHES "*.cls" OR testClass MATCHES "*.p") THEN
                populateTestModelForTestCase(testClass, testMethod, testModel).
        END.
    END METHOD.

    /*------------------------------------------------------------------------------
            populates the test model for the ABL Unit files inside the testfolder                                                                      
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC VOID populateTestModelForTestFolder(INPUT testFolder AS CHARACTER, INPUT testEnity AS TestEntity):
        
        DEFINE VARIABLE fileN     AS CHARACTER FORMAT "x(30)" NO-UNDO.
        DEFINE VARIABLE testFiles AS Array NO-UNDO.
        DEFINE VARIABLE i         AS INTEGER   NO-UNDO.
        DEFINE VARIABLE count     AS INTEGER   NO-UNDO INIT 0.
        INPUT stream dirlist from os-dir(testFolder).
        testFiles = NEW Array().
        testFiles:AutoExpand = TRUE.
        REPEAT:   
            IMPORT STREAM dirlist fileN.
            count = count + 1.
            testFiles:SetValue(NEW File(fileN), count).
        END.
        /*
        Loops through all the files inside the directory
        */
        DO i = 1 TO count:
            DEFINE VARIABLE fileInput AS File.
            fileInput= CAST(testFiles:GetValue(i), File).
            IF (fileInput:fileN MATCHES "*.cls" OR fileInput:fileN MATCHES "*.p") THEN
               populateTestModelForTestCase(testFolder + "~/" + fileInput:fileN, "", testEnity).
        END.
        INPUT CLOSE.
    END METHOD.
    
    /*
        populates through all the testcases in the TestSuite annotation
    */
    METHOD PUBLIC VOID populateTestModelForTestSuite(INPUT testSuiteList AS TestInfo, INPUT testEntity AS TestEntity):
        DEFINE VARIABLE attrValue AS CHARACTER NO-UNDO.
        DEFINE VARIABLE attrName  AS CHARACTER NO-UNDO.

        DEFINE VARIABLE annotations AS Array NO-UNDO.
        DEFINE VARIABLE annotationsCount AS INTEGER NO-UNDO.
        DEFINE VARIABLE annotationInfo AS AnnotationInfo NO-UNDO.
        DEFINE VARIABLE j AS INTEGER NO-UNDO.
        DEFINE VARIABLE classes AS CHARACTER NO-UNDO.
        DEFINE VARIABLE procedures AS CHARACTER NO-UNDO.
        DEFINE VARIABLE proceduresIndex AS INTEGER NO-UNDO.
        DEFINE VARIABLE classesIndex AS INTEGER NO-UNDO.
        DEFINE VARIABLE procedureSyntax AS CHARACTER NO-UNDO INIT "procedures=".
        DEFINE VARIABLE classSyntax AS CHARACTER NO-UNDO INIT "classes=".
            
        annotations = testSuiteList:annotations.
        annotationsCount = testSuiteList:annotationsCount.
        DO j=1 TO annotationsCount:
        annotationInfo = CAST(annotations:GetValue(j), AnnotationInfo).
        IF annotationInfo:AnnotationType NE "TestSuite" THEN
            NEXT.
        attrName = annotationInfo:getAttributeName().
        
        IF attrName EQ "classes" THEN 
        DO: 
            attrValue = annotationInfo:getAttributeValue().
            proceduresIndex = INDEX(attrValue, procedureSyntax).
            IF NOT proceduresIndex = 0 THEN
                DO:
                 classes = SUBSTRING(attrValue, 1, proceduresIndex - 1, "CHARACTER").
                 procedures = SUBSTRING(attrValue, proceduresIndex + LENGTH (procedureSyntax), -1, "CHARACTER").
                END.
            ELSE
                DO:
                    classes = attrValue.
                    procedures = "".
                END.
            attrValue = TRIM (classes).
            HandleTestSuiteClasses(testEntity, attrValue).
            attrValue = TRIM (procedures).
            HandleTestSuiteProcedures(testEntity, attrValue).
        END.
        ELSE IF attrName EQ "procedures" THEN 
        DO: 
            attrValue = annotationInfo:getAttributeValue().
            classesIndex = INDEX(attrValue, classSyntax).
            IF NOT classesIndex = 0 THEN
                DO:
                procedures = SUBSTRING(attrValue, 1, classesIndex - 1, "CHARACTER").
                classes = SUBSTRING(attrValue, classesIndex + LENGTH(classSyntax), -1, "CHARACTER").
                END.
            ELSE
                DO:
                procedures = attrValue.
                classes = "".
                END.
            attrValue = TRIM (procedures).
            HandleTestSuiteProcedures(testEntity, attrValue).
            attrValue = TRIM (classes).
            HandleTestSuiteClasses(testEntity, attrValue).
        END.
        ELSE
            MESSAGE "@TestSuite annotation attribute name should be 'classes' or 'procedures'"
                VIEW-AS ALERT-BOX. 
        END.   
    END METHOD.
    
    METHOD PUBLIC VOID HandleTestSuiteClasses(INPUT testEntity AS TestEntity, INPUT classes AS CHARACTER):
    DEFINE VARIABLE testClassesCount AS INTEGER NO-UNDO.
    DEFINE VARIABLE i AS INTEGER NO-UNDO.
    DEFINE VARIABLE testCase  AS CHARACTER NO-UNDO.
    testClassesCount = NUM-ENTRIES(classes, ",").
            DO i = 1 TO testClassesCount:
                testCase = ENTRY (i, classes, ",").
                testCase = TRIM(testCase).
                IF NOT testcase = "" THEN
                DO:
                    testCase = getRelativePathOfClasses(testCase).
                    populateTestModel(testCase, 1, testEntity).
                END.
            END.
    END METHOD.
    
    /**
    returns the relative path of the classes if the input is of qualified type.
    **/
     METHOD PUBLIC CHARACTER getRelativePathOfClasses(INPUT testcase AS CHARACTER):
     IF NOT testCase MATCHES "*.cls" THEN
            DO:
                testcase = REPLACE (testCase, ".", "/").
                testcase = testCase + ".cls".
            END.
      RETURN testcase.
     END METHOD.

    METHOD PUBLIC VOID HandleTestSuiteProcedures(INPUT testEntity AS TestEntity, INPUT procedures AS CHARACTER):
      DEFINE VARIABLE testProceduresCount AS INTEGER NO-UNDO.
      DEFINE VARIABLE i AS INTEGER NO-UNDO.
      DEFINE VARIABLE testCase  AS CHARACTER NO-UNDO.
      testProceduresCount = NUM-ENTRIES(procedures, ",").
            DO i = 1 TO testProceduresCount:
                testCase = ENTRY (i, procedures, ",").
                testCase = TRIM(testCase).
                IF NOT testcase = "" THEN
                    populateTestModel(testCase, 1, testEntity).
            END.
    END METHOD.

    /* Processes a test entity's TestResult based on status
       
       @param TestEntity     The entity to process
       @param TestTypeResult The summary to which this result aggregates */
    method private void ProcessTestResult(input pEntity as TestEntity,
                                          input pSummary as TestTypeResult):
        define variable tr as TestTestResult extent no-undo.
        define variable cnt as integer no-undo.
        define variable loop as integer no-undo.
        define variable failType as character no-undo.
        
        if not valid-object(pEntity) then
            return.
        
        if valid-object(pSummary) then
            pSummary:Add(pEntity:Summary).
        
        if pEntity:Summary:ignoreCount gt 0 then
            updateFile(updateFile, "TEST_IGNORED " + STRING(pEntity:Id), false).
        else
        if    pEntity:Summary:errorCount gt 0 
           or pEntity:Summary:failureCount gt 0 
        then
        do:
            assign tr  = pEntity:GetTestResults()
                   cnt = extent(tr)
                   .
            do loop = 1 to cnt:
                case tr[loop]:TestResult:
                    when TestResultEnum:StatusFailed then
                        // errors > failures since they're not deliberate
                        if not failType eq 'TEST_EXCEPTION':u then 
                            assign failType = 'TEST_FAIL':u.
                    when TestResultEnum:StatusError then
                        assign failType = 'TEST_EXCEPTION':u.
                    otherwise
                        next.
                end case.
                
                if valid-object(tr[loop]:Stop) then
                    updateStackTrace(tr[loop]:Stop, updateFile, string(pEntity:Id)).
                else
                    updateStackTrace(tr[loop]:Error, updateFile, string(pEntity:Id)).
            end.
            
            updateFile(updateFile, failType + " " + STRING(pEntity:Id), false).
        end.
        else
        // no failures or errors mean success
            updateFile(updateFile, "TEST_END " + STRING(pEntity:Id) + " " + STRING(pEntity:timeTaken), false).
    end method.
     
    /* Runs a TestEntity and aggregates results
       
       @param TestEntity The entity being run (class/method/suite/root)
       @param character The ABLUnit output file (not results.xml)
       @return TestTypeResult  The aggregate result for this test entity  */
    METHOD PUBLIC TestTypeResult runtests(INPUT testEntity AS TestEntity,
                                          INPUT updateFile AS CHARACTER):
        DEFINE VARIABLE children            AS Array                  NO-UNDO. 
        DEFINE VARIABLE childrenSize        AS INTEGER                 NO-UNDO.
        DEFINE VARIABLE j                   AS INTEGER                 NO-UNDO.
        define variable childEntity as TestEntity no-undo.
        define variable startTime as datetime no-undo.
        define variable runnableEntity as IRunnableEntity no-undo.
        define variable tr as TestTestResult no-undo.
        
        updateFile(updateFile, "TEST_START " + STRING(testEntity:Id), FALSE).
        
        assign startTime = now.
        /* Suite Class, Suite Procedure, Test Class may have configured with Ignore Annotation*/
        /*Start*/
        if testEntity:Summary:ignoreCount gt 0 then
        do:
            updateFile(updateFile, "TEST_IGNORED " + STRING(testEntity:Id), false).
            assign testEntity:TimeTaken = 0.
            updateFile(updateFile, "TEST_END " + STRING(testEntity:Id) + " " + STRING(testEntity:TimeTaken) , false).
            
            return testEntity:Summary.
        end.
        /*End*/
        
        children = testEntity:getTestEntities().
        childrenSize = testEntity:getChildrenSize().
        
        if type-of(testEntity, IRunnableEntity) then
        do:
            assign runnableEntity = cast(testEntity, IRunnableEntity).
            
            runnableEntity:StartEntity().
            if    testEntity:Summary:errorCount gt 0 
               or testEntity:Summary:failureCount gt 0
            then
                return testEntity:Summary.
            else
                // ... but don't add success (since we're not _actually_ running a test here ...
                ProcessTestResult(testEntity, ?).
        end.
        
        do j = 1 to childrenSize:
            assign childEntity = cast(children:GetValue(j), TestEntity).
            if    type-of(childEntity, TestMethod) 
              and valid-object(runnableEntity)
            then
            do:
                updateFile(updateFile, "TEST_START " + STRING(childEntity:Id), false).
                
                runnableEntity:RunChild(childEntity).
                // for individual tests, always add the count & process the result
                ProcessTestResult(childEntity, testEntity:Summary). 
            end.
            else
            do:
                // suite, class, procedure
                runtests(childEntity, updateFile).
                // add the counts from the children to this run
                testEntity:Summary:Add(childEntity:Summary).
            end.
        end.
        
        if valid-object(runnableEntity) then
        do:
            runnableEntity:StopEntity().
            // if there's an error we don't want to write TEST_END
            if    testEntity:Summary:errorCount gt 0 
               or testEntity:Summary:failureCount gt 0
            then
                return testEntity:Summary.
            else
                // ... but don't add success (since we're not _actually_ running a test here ...
                ProcessTestResult(testEntity, ?).
        end.
        
        assign testEntity:TimeTaken = interval(now, startTime, 'milliseconds':u) / 1000.
        updateFile(updateFile, "TEST_END " + STRING(testEntity:Id) + " " + STRING(testEntity:TimeTaken) , false).
        
        catch stoi as Progress.Lang.Stop :
            assign tr      = new TestTestResult(testEntity:name)
                   tr:Stop = stoi.
            testEntity:AddTestResult(tr).
            ProcessTestResult(testEntity, testEntity:Summary).
        end catch.
        catch runErr as Progress.Lang.Error:
            assign tr       = new TestTestResult(testEntity:name)
                   tr:Error = runErr
                   .
            testEntity:AddTestResult(tr).
            ProcessTestResult(testEntity, testEntity:Summary).
        end catch.
        // always return a result, even if there was an error
        finally:
            return testEntity:Summary.
        end.
    END METHOD.
    
    /*------------------------------------------------------------------------------
           updates stack trace with the given error in the given file
    ------------------------------------------------------------------------------*/
    METHOD PRIVATE VOID updateStackTrace(INPUT errorResult AS Progress.Lang.Error,
                                         INPUT updateFile AS CHARACTER,
                                         INPUT id AS CHARACTER):
        IF NOT updateFile = "" THEN
        DO on error undo, throw:
            DEFINE VARIABLE stackTrace     AS CHARACTER            NO-UNDO.
            DEFINE VARIABLE stackTraceLine AS CHARACTER            NO-UNDO.
            DEFINE VARIABLE i              AS INTEGER              NO-UNDO.
            DEFINE VARIABLE numMessages    AS INTEGER              NO-UNDO.
            
            OUTPUT TO VALUE(updateFile) APPEND.
            
            if not valid-object(errorResult) then
            do:
                PUT UNFORMATTED "STACK_TRACE " id " UNKNOWN ERROR " SKIP.
                return.
            end.
            
            stackTrace = errorResult:CallStack.
            
            numMessages = errorResult:NumMessages.
            DO i=1 TO numMessages:
                PUT UNFORMATTED "STACK_TRACE " id " " errorResult:GetMessage(i) SKIP.
            END.
            
            if type-of(errorResult, AppError) then
            do:
                stackTraceLine = cast(errorResult, AppError):ReturnValue.
                if not stackTraceLine eq '':u then
                    PUT UNFORMATTED "STACK_TRACE " id " " stackTraceLine SKIP.
            end.
            
            numMessages = NUM-ENTRIES(stackTrace,CHR(10) + CHR(13)). 
            DO i=1 TO numMessages:
                stackTraceLine = ENTRY(i, stackTrace, CHR(10) + CHR(13)).
                PUT UNFORMATTED "STACK_TRACE " id " " stackTraceLine SKIP.
            END.
            
            finally:
                OUTPUT close.
            end finally.
        END.
    END METHOD.
    
    /* Writes a stack trace for a stop condition 
       
       @param Progress.Lang.Stop THe stop condition 
       @param character The file into which to write 
       @param character The ID of the test entity   */
    method private void updateStackTrace(input pStop as Progress.Lang.Stop,
                                         input pUpdateFile as character,
                                         input pId as character):
        define variable loop as integer no-undo.
        define variable cnt as integer no-undo.
        define variable traceLine as character no-undo.
        
        if pUpdateFile eq '':u then
            return.
        
        output to value(pUpdateFile) append.
        
        if not valid-object(pStop) then
        do:
            put unformatted "STACK_TRACE " pId " UNKNOWN STOP CONDITION " skip.
            return.
        end.
        
        put unformatted "STACK_TRACE " pId " STOP CONDITION: " pStop:GetClass():TypeName skip.
        
        if type-of(pStop, LockConflict) then
        do:
            // Device
            assign traceLine = cast(pStop, LockConflict):Device.
            if not traceLine eq '':u then
                put unformatted "STACK_TRACE " pId " Device: " traceLine skip.
            // TableName
            assign traceLine = cast(pStop, LockConflict):TableName.
            if not traceLine eq '':u then
                put unformatted "STACK_TRACE " pId " TableName: " traceLine skip.
            // User
            assign traceLine = cast(pStop, LockConflict):User.
            if not traceLine eq '':u then
                put unformatted "STACK_TRACE " pId " User: " traceLine skip.
        end.
        //
        assign cnt = num-entries(pStop:CallStack, chr(10) + CHR(13)). 
        do loop = 1  to cnt:
            assign traceLine = entry(loop, pStop:CallStack, chr(10) + CHR(13)).
            put unformatted "STACK_TRACE " pId " " traceLine skip.
        end.
        finally:
            output close.
        end finally.
    end method.
    
     /*------------------------------------------------------------------------------
           writes to the update file the given content. If override is true, the file is overwritten.
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC VOID updateFile(INPUT updateFile AS CHARACTER, INPUT content AS LONGCHAR, INPUT override AS LOGICAL):
        IF NOT updateFile = "" THEN
           DO:
                content = content + "~n".
                   IF override THEN
                    COPY-LOB content TO FILE updateFile. 
                   ELSE
                    COPY-LOB content TO FILE updateFile APPEND.
           END.
    END METHOD.
    
END CLASS.
