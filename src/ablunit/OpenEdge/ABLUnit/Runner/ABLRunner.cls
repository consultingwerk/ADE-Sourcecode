/************************************************
Copyright (c)  2013-2014 by Progress Software Corporation. All rights reserved.
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
USING OpenEdge.Core.AssertionFailedError.
USING OpenEdge.ABLUnit.Model.File.
USING OpenEdge.ABLUnit.Model.TestClass.
USING OpenEdge.ABLUnit.Model.TestEntity.
USING OpenEdge.ABLUnit.Model.TestMethod.
USING OpenEdge.ABLUnit.Model.TestProcedure.
USING OpenEdge.ABLUnit.Model.TestRootModel.
USING OpenEdge.ABLUnit.Model.TestSuite.
USING OpenEdge.ABLUnit.Reflection.AnnotationInfo.
USING OpenEdge.ABLUnit.Reflection.ClassAnnotationInfo.
USING OpenEdge.ABLUnit.Reflection.ClassInfo.
USING OpenEdge.ABLUnit.Reflection.ProcedureAnnotationInfo.
USING OpenEdge.ABLUnit.Reflection.TestInfo.
USING OpenEdge.ABLUnit.Reflection.TypeInfo.
USING OpenEdge.ABLUnit.Results.TestTestResult.
USING OpenEdge.ABLUnit.Results.TestTypeResult.
USING OpenEdge.ABLUnit.Runner.TestConfig.
USING OpenEdge.Core.Collections.Array.
USING Progress.Json.ObjectModel.JsonArray.
USING Progress.Json.ObjectModel.JsonObject.
USING Progress.Lang.AppError.

ROUTINE-LEVEL ON ERROR UNDO, THROW.

CLASS OpenEdge.ABLUnit.Runner.ABLRunner: 

    DEFINE STREAM dirlist.
    
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
             
    DEFINE PRIVATE VARIABLE testModel AS TestEntity NO-UNDO. 
    DEFINE PRIVATE VARIABLE TEST_FOLDER_ROOT AS CHARACTER NO-UNDO INIT "TEST_ROOT".   
    DEFINE PRIVATE VARIABLE currentID AS INTEGER NO-UNDO INIT 0.
    
    DEFINE PRIVATE VARIABLE testMethodInfo  AS TestInfo NO-UNDO.
    DEFINE PRIVATE VARIABLE summaryResult AS TestTypeResult NO-UNDO.
    
    DEFINE PRIVATE VARIABLE testConfig AS TestConfig NO-UNDO.
    DEFINE PRIVATE VARIABLE updateFile AS CHARACTER NO-UNDO.
    DEFINE PRIVATE VARIABLE prevStackTraceProperty AS LOGICAL NO-UNDO.
    DEFINE PRIVATE VARIABLE oldWarningsList AS CHARACTER NO-UNDO.
    DEFINE VARIABLE ablResultsFile AS CHARACTER NO-UNDO.
    
     /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
        
    CONSTRUCTOR PUBLIC ABLRunner (  ):
        SUPER ().
        testModel = NEW TestRootModel(currentID).
        currentID = currentID + 1.
        testModel:name = TEST_FOLDER_ROOT.
        summaryResult = NEW TestTypeResult().
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
       
        DEFINE VARIABLE testSummary AS TestTypeResult NO-UNDO.
        DEFINE VARIABLE testEntity AS TestEntity NO-UNDO.
        
        testsArray = testConfig:testsJson.
        
        DEFINE VARIABLE testJson AS JsonObject NO-UNDO.
        DEFINE VARIABLE testResource AS CHARACTER NO-UNDO.
        
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
            testSummary = runtests(testEntity, updateFile).
            WriteTestResults(ablResultsFile, testEntity, testSummary).
        END.
        
        updateFile(updateFile, "COMPLETE", FALSE).
        SESSION:ERROR-STACK-TRACE = prevStackTraceProperty.
        SESSION:SUPPRESS-WARNINGS-LIST = oldWarningsList.
        RETURN.

    END METHOD.

    /*------------------------------------------------------------------------------
        Generates the procedure information in xref xml file                                                                     
    ------------------------------------------------------------------------------*/   
    
    METHOD PUBLIC TypeInfo BuildTypeInfo (INPUT testCase AS CHARACTER ):
        
        DEFINE VARIABLE xrefFile AS CHARACTER NO-UNDO.
        xrefFile = SESSION:TEMP-DIR + testConfig:ResultsFileName + ".xref".
        COMPILE value(testCase) xref-xml VALUE(xrefFile).
        DEFINE VARIABLE typeInfo AS TypeInfo NO-UNDO.
        typeInfo = ParseXMLDocument(xrefFile).
        /*Adding a check for debug mode for users to inspect the file in case something unexpected happens.*/
        IF NOT SESSION:DEBUG-ALERT THEN
            OS-DELETE value(xrefFile).
        RETURN typeInfo.
        
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
        CREATE X-NODEREF xmlRefElement.
        DEFINE VARIABLE methodInfoList  AS Array  NO-UNDO.
        DEFINE VARIABLE typeInfo  AS TypeInfo  NO-UNDO.
        DEFINE VARIABLE isStaticHandle AS HANDLE NO-UNDO.
        CREATE X-NODEREF isStaticHandle.
         DEFINE VARIABLE isStaticValueHandle AS HANDLE NO-UNDO.
        CREATE X-NODEREF isStaticValueHandle.
        
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
                            END.
                        END.
                    WHEN "METHOD" THEN 
                        DO:
                            IF NOT annotationInfo EQ ? THEN 
                            DO:
                                DEFINE VARIABLE methodIn AS TestInfo NO-UNDO.
                                methodIn = NEW TestInfo(annotationsInfo, 1, GetObjectIdAttribute(xmlRefElement)).
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
                                procIn = NEW TestInfo(annotationsInfo, 1, GetObjectIdAttribute(xmlRefElement)).
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
       IF typeInfo:methodsCount = 0 AND NOT annotationInfo = ? AND NOT classInfo = ? THEN
        DO:
            DEFINE VARIABLE emptyMethod AS TestInfo NO-UNDO.
            emptyMethod = NEW TestInfo(annotationsInfo, annotationsCount,  ?).
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
        INPUT testMethod AS CHARACTER, INPUT testEntity AS TestEntity):
        DEFINE VARIABLE testClassType   AS Progress.Lang.Object                       NO-UNDO.
        DEFINE VARIABLE methodInfoList  AS Array  NO-UNDO.
        DEFINE VARIABLE testSuiteInfo   AS TestInfo       NO-UNDO.
        DEFINE VARIABLE classAnnotInfo  AS ClassAnnotationInfo NO-UNDO.
        DEFINE VARIABLE i               AS INTEGER                                    NO-UNDO.
        DEFINE VARIABLE testSuiteCount  AS INTEGER                                    NO-UNDO INIT 0.
        DEFINE VARIABLE annotationName  AS CHARACTER                                  NO-UNDO.
        
        DEFINE VARIABLE typeInfo AS TypeInfo NO-UNDO.
        /** for qualified classes input **/
        testClassName = getRelativePathOfClasses(testClassName). 
        typeInfo = BuildTypeInfo(testClassName).
        
        methodInfoList = typeInfo:methods.
        classAnnotInfo = NEW ClassAnnotationInfo().
        
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
                DO:
                    testSuiteCount = testSuiteCount + 1.
                    testSuiteInfo = testInfo.
                END.
                    
                WHEN "Before" THEN
                DO:
                    classAnnotInfo:setBeforeClass(testInfo).
                    IF testInfo:getTestName() = testMethod THEN
                        testMethodInfo = testInfo.
                END.
                    
                WHEN "Setup" THEN
                DO:
                    classAnnotInfo:setBeforeMethod(testInfo).
                    IF testInfo:getTestName() = testMethod THEN
                        testMethodInfo = testInfo.
                END.
                    
                WHEN "Test" THEN
                DO:
                    classAnnotInfo:AddTestMethod(testInfo).
                    IF testInfo:getTestName() = testMethod THEN
                        testMethodInfo = testInfo.
                END.
                    
                WHEN "TearDown" THEN
                DO:
                    classAnnotInfo:setAfterMethod(testInfo).
                    IF testInfo:getTestName() = testMethod THEN
                        testMethodInfo = testInfo.
                END.
                    
                WHEN "After" THEN
                DO:
                    classAnnotInfo:setAfterClass(testInfo).
                    IF testInfo:getTestName() = testMethod THEN
                        testMethodInfo = testInfo.
                END.
            END CASE.
            END.
        END.        
        
        IF NOT testSuiteCount = 0  THEN
        DO:
            isTestSuite =  TRUE.

            DEFINE VARIABLE testSuite AS TestSuite.
            testSuiteName = testClassName.
            testSuite = NEW TestSuite(currentID).
            currentID = currentID + 1. 
            testSuite:Name = testClassName.
            testModel:addTestEntity(testSuite).
            testSuite:classInfo = typeInfo:classInfo.
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
            populateTestModelForTestMethod(testClassType, testClassName, classAnnotInfo, testMethodInfo, (testMethod = ""), testClass).

        END.
            
    END METHOD.
    
    METHOD PUBLIC VOID populateTestModelForTestMethod(INPUT testClassType AS Progress.Lang.Object,
        INPUT testClassName AS CHARACTER, 
        INPUT classAnnotInfo AS ClassAnnotationInfo,
        INPUT testMethodInfo AS TestInfo, 
        INPUT runAllMethods AS LOGICAL, INPUT testEntity AS TestEntity):
      
        DEFINE VARIABLE testmethods  AS Array NO-UNDO.
        DEFINE VARIABLE testCount AS INTEGER NO-UNDO.
        DEFINE VARIABLE j AS INTEGER NO-UNDO.
        
        DEFINE VARIABLE testmethod  AS TestMethod NO-UNDO.
         
       testmethods = classAnnotInfo:getTestList().
       testCount = classAnnotInfo:testCount.
       
       IF(runAllMethods) THEN
            DO j=1 TO testCount ON ERROR UNDO, THROW :
               testMethod = NEW TestMethod(currentID).
               currentID = currentID + 1.
               DEFINE VARIABLE testInfo AS TestInfo.
               testInfo = CAST(testmethods:GetValue(j), TestInfo).
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
     
    
     METHOD PUBLIC VOID populateTestModelForInternalProcs(INPUT procHandle AS HANDLE, INPUT testProcedureName AS CHARACTER,
            INPUT procAnnotInfo AS ProcedureAnnotationInfo,
            INPUT testProcInfo AS TestInfo,
            INPUT runAllProcs AS LOGICAL, INPUT testEntity AS TestEntity):
                
                DEFINE VARIABLE testProcs AS Array NO-UNDO.
                DEFINE VARIABLE testProcsCount AS INTEGER NO-UNDO.
                DEFINE VARIABLE j AS INTEGER NO-UNDO.
                DEFINE VARIABLE internalProcTestEntity AS TestMethod NO-UNDO.
                
                 testProcs = procAnnotInfo:getTestProcs().
                 IF(runAllProcs) THEN
                    DO j=1 TO procAnnotInfo:testCount  ON ERROR UNDO, THROW :
                    internalProcTestEntity = NEW TestMethod(currentID).
                    currentID = currentID + 1.
                    DEFINE VARIABLE testInfo AS TestInfo.
                    testInfo = CAST(testProcs:GetValue(j), TestInfo).
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
                DO:
                    testSuiteCount = testSuiteCount + 1.
                    testSuiteList  = testInfo.
                END.
                    
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
            END CASE.
            END.
        END.
        IF NOT testSuiteCount = 0  THEN 
        DO:
            isTestSuite =  TRUE.
            testSuiteName = testProcedureName.
            DEFINE VARIABLE testProcSuite AS TestEntity.
            testProcSuite = NEW TestSuite(currentID).
            currentID = currentID + 1.
            testProcSuite:Name = testSuiteName.
            testEntity:addTestEntity(testProcSuite). 
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
            Invokes the method in the object                                                                      
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC VOID Invoke(INPUT obj AS Progress.Lang.Object, INPUT testMethod AS CHARACTER):
        DYNAMIC-INVOKE (obj, testMethod).
    END METHOD.
  
    /*------------------------------------------------------------------------------
       Compiles and call the corresponding method or internal procedure to run the testcase                                                                        
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC VOID populateTestModelForTestCase(INPUT testCase AS CHARACTER, INPUT test AS CHARACTER, INPUT testEntity AS TestEntity):
            IF(testCase MATCHES "*.p") THEN
                populateTestModelForProcedureType(testCase, test, testEntity).
            ELSE  
                populateTestModelForTestClass(testCase, test, testEntity).
    END METHOD.
    
    /*------------------------------------------------------------------------------
            Runs the corresponding method based on the type of the testcase.                                                                       
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC TestEntity populateTestModel(INPUT testCase AS CHARACTER, INPUT testCount AS INTEGER):
        DEFINE VARIABLE serializedtree AS CHARACTER  NO-UNDO.
        populateTestModel(testCase, testCount, testModel).
        serializedtree = loadSerializedTree(testModel).
       RETURN testModel.
      END METHOD.

    /*------------------------------------------------------------------------------
            load serialized tree                                                                       
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC CHARACTER loadSerializedTree(INPUT testEntity AS TestEntity):
    DEFINE VARIABLE testEntities AS Array NO-UNDO.
    DEFINE VARIABLE newTestEntity AS TestEntity NO-UNDO.
    DEFINE VARIABLE i AS INTEGER NO-UNDO.
    DEFINE VARIABLE serializedtree AS CHARACTER NO-UNDO.
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
            DO:
                populateTestModelForTestFolder(testCase, testEntity).
            END. 
            ELSE
            DO:
                populateTestModelForTestCase(testCase, "", testEntity).
            END.
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
        DEFINE VARIABLE testFiles AS ARRAY NO-UNDO.
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
               populateTestModelForTestCase(testFolder + "~\" + fileInput:fileN, "", testEnity).
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

    /*------------------------------------------------------------------------------
            Writes the testclass results in the xml file                                                                       
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC VOID WriteTestResults(INPUT pcXmlFileName AS CHARACTER, 
        INPUT testEntity AS TestEntity, INPUT testTypeResult AS TestTypeResult):
        
        DEFINE VARIABLE i                 AS INTEGER                                 NO-UNDO.
        DEFINE VARIABLE testCaseHandle    AS HANDLE                                  NO-UNDO.
        DEFINE VARIABLE phDoc             AS HANDLE    NO-UNDO.
        DEFINE VARIABLE phRootNode        AS HANDLE    NO-UNDO.
        DEFINE VARIABLE children  AS ARRAY NO-UNDO. 
        DEFINE VARIABLE newTestEntity AS TestEntity NO-UNDO.
         
         CREATE X-DOCUMENT phDoc.
         CREATE X-NODEREF phRootNode.
            
            /*'testsuites' is the root element*/
            phDoc:CREATE-NODE(phRootNode, "testsuites", "ELEMENT").
            phDoc:APPEND-CHILD(phRootNode).
            phRootNode:SET-ATTRIBUTE("name", "ABLUnit").
            phRootNode:SET-ATTRIBUTE("tests", STRING(testTypeResult:getTestCount())).
            phRootNode:SET-ATTRIBUTE("errors", STRING(testTypeResult:GetErrorCount())).
            phRootNode:SET-ATTRIBUTE("failures", STRING(testTypeResult:GetFailureCount())).

        children = testEntity:getTestEntities().
        DO i=1 TO testEntity:getChildrenSize():
            newTestEntity = CAST(children:GetValue(i),TestEntity).
            WriteChildEntities(newTestEntity, phDoc, phRootNode).
         END.
         phDoc:SAVE("file", pcXmlFileName).
    END METHOD.
    
      /*------------------------------------------------------------------------------
           writes the details of a particular test case into the given handle      
           'time' is in sec, 'tests' represent the number of tests.                                                           
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC VOID WriteChildEntities(INPUT testEntity AS TestEntity, INPUT phDoc AS HANDLE, INPUT parentNode AS HANDLE ):
        DEFINE VARIABLE children  AS ARRAY NO-UNDO. 
        DEFINE VARIABLE childrenSize AS INTEGER NO-UNDO.
        DEFINE VARIABLE i AS INTEGER NO-UNDO.
        DEFINE VARIABLE newTestEntity AS TestEntity NO-UNDO.
        DEFINE VARIABLE testResult AS TestTestResult.
        DEFINE VARIABLE testEntityHandle AS HANDLE    NO-UNDO.
       
        CREATE X-NODEREF testEntityHandle.
        IF TYPE-OF (testEntity, TestSuite) THEN
        DO:
            phDoc:CREATE-NODE (testEntityHandle, "testsuite", "ELEMENT").
            testEntityHandle:SET-ATTRIBUTE ("name", testEntity:Name).
            testEntityHandle:SET-ATTRIBUTE ("tests", STRING(testEntity:getChildrenSize())).
            parentNode:APPEND-CHILD (testEntityHandle).
        END.
        ELSE IF TYPE-OF (testEntity, TestClass) OR TYPE-OF (testEntity, TestProcedure) THEN
        DO:
            /*Each class or procedure is a  'testsuite'*/
            phDoc:CREATE-NODE (testEntityHandle, "testsuite", "ELEMENT").
            testEntityHandle:SET-ATTRIBUTE ("name", testEntity:Name).
            testEntityHandle:SET-ATTRIBUTE ("tests", STRING(testEntity:getChildrenSize())).
            parentNode:APPEND-CHILD (testEntityHandle).
        END.    
        ELSE
        DO:
            testEntityHandle = createTestXMLResult(phDoc, testEntityHandle, testEntity, parentNode).
        END.    
        
        testEntityHandle:SET-ATTRIBUTE ("time", STRING (testEntity:timeTaken)).
        
        children = testEntity:getTestEntities().
        DO i=1 TO testEntity:getChildrenSize():
            newTestEntity = CAST(children:GetValue(i),TestEntity).
            WriteChildEntities(newTestEntity, phDoc, testEntityHandle).
         END.
         
    END METHOD.

    /*------------------------------------------------------------------------------
            Creates the <testcase> tag element for every test method or test procedure.
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC HANDLE CreateTestXMLResult(INPUT phDoc AS HANDLE, INPUT hXnode AS HANDLE, INPUT testEntity AS TestEntity, INPUT parentNode AS HANDLE):
        DEFINE VARIABLE testResult AS TestTestResult NO-UNDO.
        /*Attribute 'status' represents the test case status 'Success', 'Error' or 'Failure'*/
        DEFINE VARIABLE statusAttr AS CHARACTER NO-UNDO INIT "status".
        testResult = testEntity:TestResult.
        phDoc:CREATE-NODE(hXnode, "testcase", "ELEMENT").
        parentNode:APPEND-CHILD (hXnode).
        hXnode:SET-ATTRIBUTE ("name", testEntity:Name).

        IF testResult:TestResult = TestTestResult:StatusPassed THEN
        DO:
            hXnode:SET-ATTRIBUTE (statusAttr, "Success").
        END.
        ELSE IF testResult:TestResult = TestTestResult:StatusFailed THEN
            DO:
                   DEFINE VARIABLE traceHandle AS HANDLE NO-UNDO.
                   hXnode:SET-ATTRIBUTE (statusAttr, "Failure").
                   /*Creates a child node with the name 'failure'*/
                   traceHandle = createTraceElement(phDoc, hXnode, testResult, "failure").
                    IF NOT traceHandle = ? THEN
                    hXnode:APPEND-CHILD(traceHandle).
            END.
            ELSE IF testResult:TestResult = TestTestResult:StatusError THEN
                DO:
                    hXnode:SET-ATTRIBUTE (statusAttr, "Error").
                    /*Creates a child node with the name 'error'*/
                    traceHandle = createTraceElement(phDoc, hXnode, testResult, "error").
                    IF NOT traceHandle = ? THEN
                    hXnode:APPEND-CHILD(traceHandle).
                END.
            
        RETURN hXnode.
    END METHOD.
    
      /*------------------------------------------------------------------------------
            creates the trace element with the given name and result in the xml file . Applicable for both error and exception      
            nodeName: the name of the node 'error' or 'failure'.                                             
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC HANDLE createTraceElement( INPUT phDoc AS HANDLE,INPUT hXnode AS HANDLE, INPUT testResult AS TestTestResult, INPUT nodeName AS CHARACTER):
                DEFINE VARIABLE hXResult AS HANDLE NO-UNDO.
                DEFINE VARIABLE traceHandle AS HANDLE NO-UNDO.
                
                CREATE X-NODEREF traceHandle.
                CREATE X-NODEREF hXResult.
                
                phDoc:CREATE-NODE(traceHandle, nodeName, "ELEMENT").
                phDoc:CREATE-NODE(hXResult, "", "TEXT").
                
                /*If the message is not empty, create an attribute named 'message'*/
                IF LENGTH(testResult:ErrorMessage) > 0 THEN
                    traceHandle:SET-ATTRIBUTE("message", testResult:ErrorMessage).
               
                IF testResult:Error:CallStack <> ? THEN DO:
                    hXResult:NODE-VALUE = STRING(testResult:Error:CallStack).
                    traceHandle:APPEND-CHILD (hXResult).
                 END.
              RETURN traceHandle.
     END METHOD.           
    
    METHOD PUBLIC TestTypeResult runtests(INPUT testEntity AS TestEntity, INPUT updateFile AS CHARACTER):
        runtests(testEntity, updateFile, summaryResult).
        RETURN summaryResult.
       END METHOD.
       
    /*------------------------------------------------------------------------------
           runs all the tests that are populated in OpenEdge.ABLUnit.Model.TestEntity recursively                                                           
    ------------------------------------------------------------------------------*/
    METHOD PRIVATE VOID runtests(INPUT testEntity AS TestEntity, INPUT updateFile AS CHARACTER, INPUT summaryResult AS TestTypeResult):   
    DEFINE VARIABLE children  AS ARRAY NO-UNDO. 
    DEFINE VARIABLE childrenSize AS INTEGER NO-UNDO.
    DEFINE VARIABLE j AS INTEGER NO-UNDO.
    DEFINE VARIABLE testMethodInfo AS TestInfo NO-UNDO.
    DEFINE VARIABLE testMethodEntity AS TestMethod NO-UNDO.
    DEFINE VARIABLE testClassType AS Progress.Lang.Object NO-UNDO.
    
       DEFINE VARIABLE testResult AS TestTestResult NO-UNDO.
       DEFINE VARIABLE classEntity AS TestClass NO-UNDO.
       DEFINE VARIABLE classAnnotationInfo AS ClassAnnotationInfo NO-UNDO.
       DEFINE VARIABLE procHandle AS HANDLE   NO-UNDO.
       DEFINE VARIABLE procedureAnnotInfo  AS ProcedureAnnotationInfo       NO-UNDO.
       DEFINE VARIABLE procedureEntity AS TestProcedure NO-UNDO.     
       DEFINE VARIABLE timeString AS DECIMAL DECIMALS 3 NO-UNDO.
       DEFINE VARIABLE childTimeString AS DECIMAL DECIMALS 3 NO-UNDO.

    DEFINE VARIABLE className AS CHARACTER NO-UNDO.
        updateFile(updateFile, "TEST_START " + STRING(testEntity:Id), FALSE).

        timeString = MTIME.
        
        children = testEntity:getTestEntities().
        childrenSize = testEntity:getChildrenSize().
        
        IF(TYPE-OF (testEntity , TestClass)) THEN
        DO:  
            DEFINE VARIABLE testClass AS TestClass NO-UNDO.
            testClass = CAST(testEntity, TestClass).
            className = testClass:classInfo:getClassName().
            testClassType = DYNAMIC-NEW className () NO-ERROR.
            classEntity =   CAST(testEntity , TestClass).
            classAnnotationInfo =classEntity:AnnotationInfo.
            classAnnotationInfo:RunBeforeClass(testClassType, summaryResult).
        END.
        ELSE IF(TYPE-OF (testEntity , TestProcedure)) THEN
        DO: 
            RUN value(testEntity:Name) PERSISTENT SET procHandle NO-ERROR.
            procedureEntity =   CAST(testEntity , TestProcedure).
            procedureAnnotInfo = procedureEntity:annotationInfo. 
            procedureAnnotInfo:RunBeforeProcedure(procHandle, summaryResult).
        END.   
        
        DO j = 1 TO childrenSize:
             IF(TYPE-OF (children:GetValue(j), TestMethod)) THEN
                DO:
                    DEFINE VARIABLE content AS CHARACTER NO-UNDO.
                    DEFINE VARIABLE testMethod AS TestMethod NO-UNDO.
                    testMethod = CAST(children:GetValue(j), TestMethod).
                     content = "TEST_START " + STRING(testMethod:Id).
                     updateFile(updateFile, content, FALSE).
                     
                     testMethodEntity = CAST(testMethod , TestMethod).
                     childTimeString = MTIME.
                     IF(testEntity:Name MATCHES "*.cls") THEN
                        testResult = runTestClassMethod(CAST(testEntity , TestClass), testMethodEntity:getTestInfo(), testClassType).
                     IF(testEntity:Name MATCHES "*.p") THEN
                       testResult = runTestProcedure(CAST(testEntity , TestProcedure), testMethodEntity:getTestInfo(), testMethod).    
                     
                     testMethodEntity:TestResult = testResult.
                     updateTestSummary(summaryResult, testResult).
                    
                     IF(testResult:TestResult = TestTestResult:StatusFailed) THEN
                        DO:
                             updateFile(updateFile, "TEST_FAIL " + STRING(testMethod:Id), FALSE).
                             updateStackTrace(testResult:Error, updateFile, STRING(testMethod:Id)).
                       END.
                     
                     ELSE IF(testResult:TestResult = TestTestResult:StatusError) THEN     
                         DO:
                             updateFile(updateFile, "TEST_EXCEPTION " + STRING(testMethod:Id), FALSE).
                             updateStackTrace(testResult:Error, updateFile, STRING(testMethod:Id)).
                        END.
                        
                     childTimeString = MTIME - childTimeString. 
                     childTimeString = childTimeString / 1000.
                     testMethod:TimeTaken = childTimeString.
                     updateFile(updateFile, "TEST_END " + STRING(testMethod:Id) + " " + STRING(childTimeString), FALSE).
                END.
              ELSE
                 runtests(CAST(children:GetValue(j), TestEntity), updateFile).
        END.
        
        IF(TYPE-OF (testEntity , TestClass)) THEN
             DO:  
                classAnnotationInfo:RunAfterClass(testClassType).
             END.
        ELSE IF(TYPE-OF (testEntity , TestProcedure)) THEN
        DO: 
                procedureAnnotInfo:RunAfterProcedure(procHandle).
        END.  
        
        timeString = MTIME - timeString.
        timeString = timeString / 1000.
        testEntity:TimeTaken = timeString.
        updateFile(updateFile, "TEST_END " + STRING(testEntity:Id) + " " + STRING(timeString) , FALSE).
    
    END METHOD.
    
    
    /*------------------------------------------------------------------------------
           updates stack trace with the given error in the given file                                                           
    ------------------------------------------------------------------------------*/
    METHOD PRIVATE VOID updateStackTrace(INPUT errorResult AS Progress.Lang.Error, INPUT updateFile AS CHARACTER, INPUT id AS CHARACTER):
            IF NOT updateFile = "" THEN
           DO:
               DEFINE VARIABLE stackTrace AS CHARACTER NO-UNDO.
               DEFINE VARIABLE stackTraceLine AS CHARACTER NO-UNDO.
               DEFINE VARIABLE i AS INTEGER NO-UNDO.
               DEFINE VARIABLE numMessages AS INTEGER NO-UNDO.
               DEFINE VARIABLE exception AS AssertionFailedError NO-UNDO.
               stackTrace = errorResult:CallStack.
               OUTPUT TO VALUE(updateFile) APPEND.
               numMessages = errorResult:NumMessages.
               DO i=1 TO numMessages:
                    PUT UNFORMATTED "STACK_TRACE " id " " errorResult:GetMessage(i) SKIP.
               END.
               
               DO i=1 TO NUM-ENTRIES(stackTrace,CHR(10) + CHR(13)):
                  stackTraceLine = ENTRY(i, stackTrace, CHR(10) + CHR(13)).
                  PUT UNFORMATTED "STACK_TRACE " id " " stackTraceLine SKIP.
               END.
               OUTPUT close.  
          END.            
    END METHOD.
    
     /*------------------------------------------------------------------------------
           writes to the update file the given content. If override is true, the file is overwritten.                                                        
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC VOID updateFile(INPUT updateFile AS CHARACTER, INPUT content AS CHARACTER, INPUT override AS LOGICAL):
        IF NOT updateFile = "" THEN
           DO:
                   IF override THEN
                    OUTPUT TO VALUE(updateFile) .
                   ELSE
                    OUTPUT TO VALUE(updateFile) append.
                   
                   PUT UNFORMATTED content SKIP.
                   OUTPUT close.
           END.
    END METHOD.
    
    METHOD PRIVATE VOID updateTestSummary(INPUT summaryResult AS TestTypeResult, INPUT testMethodResult AS TestTestResult):
        IF(testMethodResult:TestResult = TestTestResult:StatusError) THEN
                summaryResult:incrementError().
        ELSE IF(testMethodResult:TestResult = TestTestResult:StatusFailed) THEN
                summaryResult:incrementFailure().
        ELSE
               summaryResult:incrementSuccess().
    END.
    
    /*------------------------------------------------------------------------------
         runs a given test method denoted by  OpenEdge.ABLUnit.Reflection.TestInfo in the class OpenEdge.ABLUnit.Model.TestClass                                                     
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC TestTestResult runTestClassMethod(INPUT testClass AS TestClass, INPUT testMethodInfo  AS TestInfo, INPUT testClassType  AS Progress.Lang.Object):
        DEFINE VARIABLE classAnnotInfo  AS ClassAnnotationInfo       NO-UNDO.
        DEFINE VARIABLE testListCount AS INTEGER NO-UNDO.
        DEFINE VARIABLE testResult AS TestTestResult NO-UNDO.  
        
        classAnnotInfo = testClass:AnnotationInfo. 
        RETURN classAnnotInfo:RunSelectedTestMethod(testClassType, testMethodInfo).
        
    END METHOD.
    
    /*------------------------------------------------------------------------------
         runs a given internal procedure denoted by  OpenEdge.ABLUnit.Reflection.TestInfo in the class OpenEdge.ABLUnit.Model.TestProcedure                                                     
    ------------------------------------------------------------------------------*/
     METHOD PUBLIC TestTestResult runTestProcedure(INPUT testProcedure AS TestProcedure, INPUT testProcInfo  AS TestInfo, INPUT testMethod AS TestEntity):
        DEFINE VARIABLE procHandle AS HANDLE   NO-UNDO.
        DEFINE VARIABLE procedureAnnotInfo  AS ProcedureAnnotationInfo       NO-UNDO.
        
        RUN value(testProcedure:Name) PERSISTENT SET procHandle NO-ERROR.
        procedureAnnotInfo = testProcedure:annotationInfo. 
        RETURN procedureAnnotInfo:RunSelectedTestProc(procHandle, testProcInfo).
        
    END METHOD.
               
END CLASS.