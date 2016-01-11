 
/*------------------------------------------------------------------------
   File        : ABLRunner
   Purpose     : Runner of the ABLUnit framework, which runs the testclasses, test procedures, testsuite classes,
                 testsuite procedures and ABL files inside a folder. 
   Syntax      : 
   Description : 
   Author(s)   : hgarapat
   Created     : Wed Jun 27 18:18:40 IST 2012
   Notes       : 
 ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using Progress.Lang.*.
using Progress.Lang.AppError.
using ABLUnit.Util.*.
using ABLUnit.Reflection.*.
using ABLUnit.Assertions.*.

class OpenEdge.ABLUnit.Runner.ABLRunner: 

    define variable methodcount    as integer no-undo init 0.
    define variable procedurecount as integer no-undo init 0.
    define stream dirlist.
    
    /*
    Static Definitions for writing the results into xml file.
    */    
    define static variable isTestRun         as logical   no-undo init true.
    define static variable docCreated        as logical   no-undo init false.
    define static variable phDoc             as handle    no-undo.
    define static variable phRootNode        as handle    no-undo.

    /*
    Class members
    */    
    define variable isTestSuite       as logical   no-undo init false.
    define variable testSuiteName     as character no-undo.
    define variable testSuiteCreated  as logical   no-undo init false.
    define variable testCasesCount    as integer   no-undo init 0.
    define variable writtenFilesCount as integer   no-undo init 0.
    define variable testSuiteHandle   as handle    no-undo.
            
    /*------------------------------------------------------------------------------
        Generates the procedure information in xref xml file                                                                     
    ------------------------------------------------------------------------------*/
    method public OpenEdge.ABLUnit.Reflection.TestInfo extent 100 BuildTypeInfo (input testCase as character, 
        input testTypeInfo as OpenEdge.ABLUnit.Reflection.TestInfo extent 100):
        
        define variable xrefFile as character no-undo.

        xrefFile = guid(generate-uuid) + ".xml".
        compile value(testCase) xref-xml value(xrefFile).
        return ParseXMLDocument(xrefFile, testTypeInfo).
        
    end method.
    
    /*----------------------------------------------------------------------------
        Returns the relative path to the .cls file for the given class.
    ----------------------------------------------------------------------------*/  
    method private character GetClassFile(input typeClass as Progress.Lang.Class):
        return replace(typeClass:TypeName, ".", "/") + ".cls".
    end method.

    /*------------------------------------------------------------------------------
        Parses the XREF XML file for Test Methods and Procedures                                                                    
    ------------------------------------------------------------------------------*/
    method public OpenEdge.ABLUnit.Reflection.TestInfo extent 100 ParseXMLDocument(input xmlDocument as character,
        input testTypeInfo as OpenEdge.ABLUnit.Reflection.TestInfo extent 100):
  
        define variable xmlDoc           as handle  no-undo.
        define variable xmlDocElement    as handle  no-undo.
        define variable xmlSourceElement as handle  no-undo.
        define variable i                as integer no-undo.
        
        create x-document xmlDoc.
        create x-noderef xmlDocElement.
        create x-noderef xmlSourceElement.
        
        xmlDoc:suppress-namespace-processing = true.
        xmlDoc:load("FILE", xmlDocument, false).
        
        xmlDoc:get-document-element(xmlDocElement).
        
        do i = 1 to xmlDocElement:num-children:
            xmlDocElement:get-child(xmlSourceElement,i).
            if xmlSourceElement:subtype = "ELEMENT" and xmlSourceElement:name = "SOURCE" then 
            do:
                return ParseSourceElement(xmlSourceElement, testTypeInfo).
            end.
        end.
    
        finally:
            delete object xmlDoc no-error.
            delete object xmlDocElement no-error.
            delete object xmlSourceElement no-error.
        end finally.
    end method.    
    
    /*----------------------------------------------------------------------------
        Returns the value of the 'Reference-type' attribute in the given XML element. 
    ----------------------------------------------------------------------------*/  
    method private character GetRefTypeAttribute(input xmlElement as handle):
        return xmlElement:get-attribute("Reference-type").
    end.
  
    /*----------------------------------------------------------------------------
      Returns the value of the 'Object-identifier' attribute in the given XML 
      element. 
    ----------------------------------------------------------------------------*/   
    method private character GetObjectIdAttribute(input xmlElement as handle):
        return xmlElement:get-attribute("Object-identifier").
    end method.                                             
  
    /*----------------------------------------------------------------------------
    Parses a <source> element in the xml-xref, looking for methods and 
    annotations. Methods preceded by annotations are added to the given 
    MethodInfo list.
----------------------------------------------------------------------------*/
       
    method private OpenEdge.ABLUnit.Reflection.TestInfo extent 100 ParseSourceElement(input xmlSourceElement as handle, 
        input testTypeInfo as OpenEdge.ABLUnit.Reflection.TestInfo extent 100):
    
        define variable xmlRefElement  as handle                                     no-undo.
        define variable nodeType       as character                                  no-undo.
        define variable i              as integer                                    no-undo.
        define variable methodName     as character                                  no-undo.
        define variable annotationInfo as OpenEdge.ABLUnit.Reflection.AnnotationInfo no-undo init ?.
        define variable classInfo      as OpenEdge.ABLUnit.Reflection.ClassInfo      no-undo init ?.
    
        create x-noderef xmlRefElement.
        
        do i = 1 to xmlSourceElement:num-children:
            xmlSourceElement:get-child(xmlRefElement, i).
   
            if xmlRefElement:subtype = "ELEMENT" and xmlRefElement:name = "Reference" then 
            do:
                nodeType = GetRefTypeAttribute(xmlRefElement).
                
                case nodeType:
          
                    when "ANNOTATION" then 
                        do:
                            if annotationInfo eq ? then
                                annotationInfo = new OpenEdge.ABLUnit.Reflection.AnnotationInfo(GetObjectIdAttribute(xmlRefElement)).
                        end.
          
                    when "CLASS" then 
                        do:
                            if classInfo = ? then 
                            do:
                                classInfo = new OpenEdge.ABLUnit.Reflection.ClassInfo(GetObjectIdAttribute(xmlRefElement), annotationInfo).
                            end.
                        end.
                    when "method" then 
                        do:
                            if not annotationInfo eq ? then 
                            do:
                                define variable methodIn as OpenEdge.ABLUnit.Reflection.TestInfo no-undo.
                                methodIn = new OpenEdge.ABLUnit.Reflection.TestInfo(annotationInfo, GetObjectIdAttribute(xmlRefElement)).
                                methodcount =  methodcount + 1.
                                testTypeInfo[methodcount] = methodIn.
                                annotationInfo = ?.
                            end.                                             
                        end.
                    when "PROCEDURE" then 
                        do:
                            if not annotationInfo eq ? then 
                            do:
                                define variable procIn as OpenEdge.ABLUnit.Reflection.TestInfo no-undo.
                                procIn = new OpenEdge.ABLUnit.Reflection.TestInfo(annotationInfo, GetObjectIdAttribute(xmlRefElement)).
                                procedurecount =  procedurecount + 1.
                                testTypeInfo[procedurecount] = procIn.
                                annotationInfo = ?.
                            end.                                             
                        end.
                end CASE.
            end.
        end.
        
        /*
        This condition is for testsuites, which has only one annotation preceding the class definition and no methods.
        */
        if methodcount = 0 and not annotationInfo = ? and not classInfo = ? then
        do:
            define variable emptyMethod as OpenEdge.ABLUnit.Reflection.TestInfo no-undo.
            emptyMethod = new OpenEdge.ABLUnit.Reflection.TestInfo(annotationInfo, ?).
            methodcount =  methodcount + 1.
            testTypeInfo[methodcount] = emptyMethod.
            annotationInfo = ?.
        end. 
        /*
        This condition is for testsuites, which has only one annotation in the procedure file.
        */
        else if procedurecount = 0 and not annotationInfo = ? then
            do:
                define variable emptyProcedure as OpenEdge.ABLUnit.Reflection.TestInfo no-undo.
                emptyProcedure = new OpenEdge.ABLUnit.Reflection.TestInfo(annotationInfo, ?).
                procedurecount =  procedurecount + 1.
                testTypeInfo[procedurecount] = emptyProcedure.
                annotationInfo = ?.
            end.
        
        return testTypeInfo.
        finally:
            delete object xmlRefElement no-error.
            delete object xmlSourceElement no-error.
        end finally.
    end method.

    /*------------------------------------------------------------------------------
            Given a testclass and test method, this method will store and 
            run the test methods and calls a method which writes the results in the xml file 																	  
    ------------------------------------------------------------------------------*/

    method public void RunClassType(input testClassName as character, 
        input testMethod as character):
        
        define variable testClassType   as Progress.Lang.Object                       no-undo.
        define variable methodInfoList  as OpenEdge.ABLUnit.Reflection.TestInfo       no-undo extent 100.
        define variable testSuiteList   as OpenEdge.ABLUnit.Reflection.TestInfo       no-undo.
        define variable classAnnotInfo  as OpenEdge.ABLUnit.Reflection.ClassAnnotationInfo no-undo.
        define variable i               as integer                                    no-undo.
        define variable testSuiteCount  as integer                                    no-undo init 0.
        define variable annotationName  as character                                  no-undo.
        define variable testMethodInfo  as OpenEdge.ABLUnit.Reflection.TestInfo       no-undo.
        testClassType = dynamic-new(testClassName) () no-error.
        methodInfoList = BuildTypeInfo(testClassName + ".cls", methodInfoList).
        
        classAnnotInfo = new OpenEdge.ABLUnit.Reflection.ClassAnnotationInfo().
        
        /*
        Loop through the parsed method information from xref xml file
        */
        do i=1 to methodcount:
            
            annotationName = methodInfoList[i]:getAnnotationName().
            
            if annotationName eq "TestSuite" then
            do:
                testSuiteCount = testSuiteCount + 1.
                testSuiteList = methodInfoList[i].
            end.
                
            if annotationName = "BeforeClass" then
            do:
                classAnnotInfo:setBeforeClass(methodInfoList[i]).
                if methodInfoList[i]:getTestName() = testMethod then
                    testMethodInfo = methodInfoList[i].
            end.
                
            if annotationName = "Before" then
            do:
                classAnnotInfo:setBeforeMethod(methodInfoList[i]).
                if methodInfoList[i]:getTestName() = testMethod then
                    testMethodInfo = methodInfoList[i].
            end.
                
            if annotationName = "Test" then
            do:
                classAnnotInfo:setTestMethod(methodInfoList[i]).
                if methodInfoList[i]:getTestName() = testMethod then
                    testMethodInfo = methodInfoList[i].
            end.
                
            if annotationName = "After" then
            do:
                classAnnotInfo:setAfterMethod(methodInfoList[i]).
                if methodInfoList[i]:getTestName() = testMethod then
                    testMethodInfo = methodInfoList[i].
            end.
                
            if annotationName = "AfterClass" then
            do:
                classAnnotInfo:setAfterClass(methodInfoList[i]).
                if methodInfoList[i]:getTestName() = testMethod then
                    testMethodInfo = methodInfoList[i].
            end.
        end.		
        
        if not testSuiteCount = 0  then
        do:
            isTestSuite =  true.
            testSuiteName = testClassName.
            RunTestSuite(testSuiteList).
        end.
        else if testMethod = "" then
            RunTestMethod(testClassType, testClassName, classAnnotInfo, testMethodInfo, true).
        else if not testMethod = "" then 
            RunTestMethod(testClassType, testClassName, classAnnotInfo, testMethodInfo, false).
    end method.
    /*
    Runs the Test Methods in the corresponding Test Class according to testcase lifecycle
    */
    method public void RunTestMethod(input testClassType as Progress.Lang.Object,
        input testClassName as character, 
        input classAnnotInfo as OpenEdge.ABLUnit.Reflection.ClassAnnotationInfo,
        input testMethodInfo as OpenEdge.ABLUnit.Reflection.TestInfo, 
        input runAllMethods as logical):
            
        define variable testClassResult as OpenEdge.ABLUnit.Results.TestTypeResult no-undo.
        define variable testResult      as OpenEdge.ABLUnit.Results.TestTestResult no-undo.
        define variable mCount       as integer                                 no-undo.
        define variable resultsArray as OpenEdge.ABLUnit.Results.TestTestResult no-undo extent 100.
        
        testClassResult = new OpenEdge.ABLUnit.Results.TestTypeResult().
        testClassResult = classAnnotInfo:RunBeforeClass(testClassType, testClassResult).
        if (runAllMethods) then
            testClassResult = classAnnotInfo:RunTestMethods(testClassType, testClassResult).
        else
            testClassResult = classAnnotInfo:RunSelectedTestMethod(testClassType, testClassResult, testMethodInfo).
        catch e1 as OpenEdge.ABLUnit.Assertions.AssertionFailedException :
            testResult = new OpenEdge.ABLUnit.Results.TestTestResult().
            testResult:setStatus(OpenEdge.ABLUnit.Results.TestTestResult:StatusFailed).
            testResult:SetExceptionMessage(e1:GetMessage()).
            testResult:setTestName(classAnnotInfo:getBeforeClass()).
            testClassResult:setBeforeTypeResult(testResult).
            testClassResult:IncrementFailure().
        end catch.
        catch e2 as Progress.Lang.Error :
            testResult = new OpenEdge.ABLUnit.Results.TestTestResult().
            testResult:setStatus(OpenEdge.ABLUnit.Results.TestTestResult:StatusError).
            testResult:AddError(e2).
            testResult:setTestName(classAnnotInfo:getBeforeClass()).
            testClassResult:setBeforeTypeResult(testResult).
            testClassResult:IncrementError().
        end catch.
        finally:
            testClassResult = classAnnotInfo:RunAfterClass(testClassType, testClassResult).
            catch e1 as OpenEdge.ABLUnit.Assertions.AssertionFailedException :
                testResult = new OpenEdge.ABLUnit.Results.TestTestResult().
                testResult:setStatus(OpenEdge.ABLUnit.Results.TestTestResult:StatusFailed).
                testResult:SetExceptionMessage(e1:GetMessage()).
                testResult:setTestName(classAnnotInfo:getAfterClass()).
                mCount = testClassResult:getTestCount().
                resultsArray = testClassResult:getTestResult().
                mCount = mCount + 1.
                resultsArray[mCount] = testResult.
                testClassResult:setTestResult(resultsArray).
                testClassResult:IncrementFailure().
                testClassResult:setTestCount(mCount).
            end catch.
            catch e2 as Progress.Lang.Error :
                testResult = new OpenEdge.ABLUnit.Results.TestTestResult().
                testResult:setStatus(OpenEdge.ABLUnit.Results.TestTestResult:StatusError).
                testResult:AddError(e2).
                testResult:setTestName(classAnnotInfo:getAfterClass()).
                mCount = testClassResult:getTestCount().
                resultsArray = testClassResult:getTestResult().
                mCount = mCount + 1.
                resultsArray[mCount] = testResult.
                testClassResult:setTestResult(resultsArray).
                testClassResult:IncrementError().
                testClassResult:setTestCount(mCount).
            end catch.
            finally:
                delete object testClassType no-error.
                WriteTestResults("results.xml", testClassResult, testClassName).
            end finally.
        end finally.
    end method.
    
    /*
    Runs the Test internal Procedures in the corresponding Test Procedure according to testcase lifecycle
    */
    method public void RunTestProcedure(input procHandle as handle, input testProcedureName as character,
            input procAnnotInfo as OpenEdge.ABLUnit.Reflection.ProcedureAnnotationInfo,
            input testProcInfo as OpenEdge.ABLUnit.Reflection.TestInfo,
            input runAllProcs as logical):
                
        define variable procResult     as OpenEdge.ABLUnit.Results.TestTestResult no-undo.
        define variable testProcResult as OpenEdge.ABLUnit.Results.TestTypeResult no-undo.
        define variable pCount         as integer                                 no-undo.
        define variable resultsArray   as OpenEdge.ABLUnit.Results.TestTestResult no-undo extent 100.
        
        testProcResult = new OpenEdge.ABLUnit.Results.TestTypeResult().
        testProcResult = procAnnotInfo:RunBeforeProcedure(procHandle, testProcResult).
        if (runAllProcs) then 
            testProcResult = procAnnotInfo:RunTestProcs(procHandle, testProcResult).
        else
            testProcResult = procAnnotInfo:RunSelectedTestProc(procHandle, testProcResult, testProcInfo).
            
        catch e as Progress.Lang.Error :
            procResult = new OpenEdge.ABLUnit.Results.TestTestResult().
            procResult:setStatus(OpenEdge.ABLUnit.Results.TestTestResult:StatusFailed).
            procResult:SetExceptionMessage("Exception in @BeforeProcedure").
            procResult:setTestName(procAnnotInfo:getBeforeProcedure()).
            testProcResult:setBeforeTypeResult(procResult).
            testProcResult:IncrementFailure().
        end catch.
        
        finally:
            testProcResult = procAnnotInfo:RunAfterProcedure(procHandle, testProcResult).
            catch e as Progress.Lang.Error :
                procResult = new OpenEdge.ABLUnit.Results.TestTestResult().
                procResult:setStatus(OpenEdge.ABLUnit.Results.TestTestResult:StatusFailed).
                procResult:SetExceptionMessage("Exception in the @AfterProcedure").
                procResult:setTestName(procAnnotInfo:getAfterProcedure()).
                pCount = testProcResult:getTestCount().
                resultsArray = testProcResult:getTestResult().
                pCount = pCount + 1.
                resultsArray[pCount] = procResult.
                testProcResult:setTestResult(resultsArray).
                testProcResult:IncrementFailure().
                testProcResult:setTestCount(pCount).                            
            end catch.
            finally:
                WriteTestResults("results.xml", testProcResult, testProcedureName).                              
            end finally.
        end finally.                    
    end method.

    /*------------------------------------------------------------------------------
            Given a test procedure and test internal procedure, this method will store and 
            run the test procedures and calls a method which writes the results in the xml file                                                                      
            Notes:   																	  
    ------------------------------------------------------------------------------*/

    method public void RunProcedureType(input testProcedureName as character, input testInternalProcedure as character):
    
        define variable procHandle     as        handle                                    no-undo.
        define variable procInfoList   as        OpenEdge.ABLUnit.Reflection.TestInfo      no-undo extent 100.
        define variable procAnnotInfo  as        OpenEdge.ABLUnit.Reflection.ProcedureAnnotationInfo no-undo.
        define variable testSuiteList  as        OpenEdge.ABLUnit.Reflection.TestInfo      no-undo.
        define variable i              as        integer                                   no-undo.
        define variable testSuiteCount as        integer                                   no-undo init 0.
        define variable annotation as             character no-undo.
        define variable attributeName  as        character                                 no-undo.
        define variable attributeValue as        character                                 no-undo.
        define variable testProcInfo   as        OpenEdge.ABLUnit.Reflection.TestInfo      no-undo.
        
        run value(testProcedureName) persistent set procHandle.

        procInfoList = BuildTypeInfo(testProcedureName, procInfoList).
        procAnnotInfo = new OpenEdge.ABLUnit.Reflection.ProcedureAnnotationInfo().   
        /*
        Loops through the procedure information obtained from xref xml file
        */             
        do i=1 to procedurecount:
            annotation = procInfoList[i]:getAnnotationName().

            if annotation eq "TestSuite" then
            do:
                testSuiteCount = testSuiteCount + 1.
                testSuiteList  = procInfoList[i].
            end.
                
            if annotation = "BeforeProcedure" then
            do:
                procAnnotInfo:setBeforeProcedure(procInfoList[i]).
                if procInfoList[i]:getTestName() = testInternalProcedure then
                    testProcInfo = procInfoList[i].
            end.
                
            if annotation = "Before" then
            do:
                procAnnotInfo:setBefore(procInfoList[i]).
                if procInfoList[i]:getTestName() = testInternalProcedure then
                    testProcInfo = procInfoList[i].
            end.
                
            if annotation = "Test" then
            do:
                procAnnotInfo:setTestProc(procInfoList[i]).
                if procInfoList[i]:getTestName() = testInternalProcedure then
                    testProcInfo = procInfoList[i].
            end.
                
            if annotation = "After" then
            do:
                procAnnotInfo:setAfter(procInfoList[i]).
                if procInfoList[i]:getTestName() = testInternalProcedure then
                    testProcInfo = procInfoList[i].
            end.
                
            if annotation = "AfterProcedure" then
            do:
                procAnnotInfo:setAfterProcedure(procInfoList[i]).
                if procInfoList[i]:getTestName() = testInternalProcedure then
                    testProcInfo = procInfoList[i].
            end.
        end.
        
        if not testSuiteCount = 0  then 
        do:
            isTestSuite =  true.
            testSuiteName = testProcedureName.
            RunTestSuite(testSuiteList). 
        end.
        else if testInternalProcedure = "" then
                RunTestProcedure(procHandle, testProcedureName, procAnnotInfo, testProcInfo, true).
        else if not testInternalProcedure = "" then 
            RunTestProcedure(procHandle, testProcedureName, procAnnotInfo, testProcInfo, false).            
    end method.

    /*------------------------------------------------------------------------------
            Invokes the method in the object                                                                      
    ------------------------------------------------------------------------------*/
    method public void Invoke(input obj as Progress.Lang.Object, input testMethod as character):
        DYNAMIC-INVOKE (obj, testMethod).
    end method.
  
    /*------------------------------------------------------------------------------
       Compiles and call the corresponding method or internal procedure to run the testcase                                                                        
    ------------------------------------------------------------------------------*/
    method public void RunTestCase(input testCase as character, input test as character):
        compile value(testCase) no-error.
        if compiler:error then 
            return error.
        else 
        do:
            if (testCase matches "*.cls") then 
                RunClassType(compiler:class-type, test).
            else
                RunProcedureType(testCase, test).
        end.
    end method.
    
    /*------------------------------------------------------------------------------
            Runs the corresponding method based on the type of the testcase.                                                                       
    ------------------------------------------------------------------------------*/
    method public void RunTest(input testCase as character, input testCount as integer):
        methodcount = 0.
        procedurecount = 0.
        if testCount = 1 then 
        do:
            if (testCase matches "*.cls" or testCase matches "*.p") then
                RunTestCase(testCase, "").
            else
                RunTestFolder(testCase). 
        end.
        else 
        do:
            define variable testClass  as character no-undo.
            define variable testMethod as character no-undo.
            testClass = entry(1, testCase, "#").
            testMethod = entry(2, testCase, "#").
            if (testClass matches "*.cls" or testClass matches "*.p") then
                RunTestCase(testClass, testMethod).
            else 
                RunTestFolder(testCase).
        end.
    end method.

    /*------------------------------------------------------------------------------
            Runs the ABL files inside the testfolder                                                                      
    ------------------------------------------------------------------------------*/
    method public void RunTestFolder(input testFolder as character):
        
        define variable fileN     as character format "x(30)" no-undo.
        
        define variable testFiles as character no-undo extent 100.
        define variable i         as integer   no-undo.
        define variable count     as integer   no-undo init 0.
        input stream dirlist from os-dir(testFolder).

        REPEAT:   
            count = count + 1.
            IMPORT stream dirlist fileN.
            testFiles[count] = fileN.
        end.
        
        /*
        Loops through all the files inside the directory
        */
        do i = 1 to count:
            methodcount = 0.
            procedurecount = 0.
            if (testFiles[i] MATCHES "*.cls" or testFiles[i] MATCHES "*.p") then
                RunTestCase(testFiles[i], "").
        end.
        input CLOSE.
    end method.
	
	/*
	Loops through all the testcases in the TestSuite annotation and runs them
	*/
    method public void RunTestSuite(input testSuiteList as OpenEdge.ABLUnit.Reflection.TestInfo):
        define variable attrValue as character no-undo.
        define variable attrName  as character no-undo.
        define variable testCase  as character no-undo.
        define variable i         as integer   no-undo.

        attrName = testSuiteList:getAttributeName().
        if attrName eq "testcases" then 
        do: 
            attrValue = testSuiteList:getAttributeValue().
            testCasesCount = num-entries(attrValue, ",").
            do i = 1 to testCasesCount:
                testCase = entry (i, attrValue, ",").
                testCase = trim(testCase).
                RunTest(testCase, 1).
            end.
        end.
        else
            message "@TestSuite annotation attribute name should be 'testcases'"
                view-as alert-box.    
    end method.

    /*------------------------------------------------------------------------------
            Writes the testclass results in the xml file                                                                       
    ------------------------------------------------------------------------------*/
    method public void WriteTestResults(input pcXmlFileName as character, 
        input testTypeResult as OpenEdge.ABLUnit.Results.TestTypeResult, input testClass as character):
        
        define variable methodResultArray as OpenEdge.ABLUnit.Results.TestTestResult no-undo extent 100.
        define variable i                 as integer                                 no-undo.
        define variable testCaseHandle    as handle                                  no-undo.
        
        /*
        The results xml file document is created only once.
        */
        if not OpenEdge.ABLUnit.Runner.ABLRunner:docCreated then
        do:    
            create x-document phDoc.
            create x-noderef phRootNode.
            OpenEdge.ABLUnit.Runner.ABLRunner:docCreated = true.
        end.
        /*
        <testrun> tag is created only once.
        else block is executed for multiple testcases inside a testsuite.
        */
        if OpenEdge.ABLUnit.Runner.ABLRunner:isTestRun then
        do:
            phDoc:create-node(phRootNode, "testrun", "ELEMENT").
            phDoc:append-child(phRootNode).
            phRootNode:set-attribute("name", "ABLUnit").
            phRootNode:set-attribute("tests", STRING(testTypeResult:getTestCount())).
            phRootNode:set-attribute("errors", STRING(testTypeResult:GetErrorCount())).
            phRootNode:set-attribute("success", STRING(testTypeResult:GetSuccessCount())).
            phRootNode:set-attribute("failures", STRING(testTypeResult:GetFailureCount())).
            OpenEdge.ABLUnit.Runner.ABLRunner:isTestRun = false.
        end.
        else 
        do:
            phRootNode:set-attribute("tests",  STRING(integer (phRootNode:get-attribute ("tests")) + testTypeResult:getTestCount())).
            phRootNode:set-attribute("errors", STRING(integer (phRootNode:get-attribute ("errors")) + testTypeResult:GetErrorCount())).
            phRootNode:set-attribute("success", STRING(integer (phRootNode:get-attribute ("success")) + testTypeResult:GetSuccessCount())).
            phRootNode:set-attribute("failures", STRING(integer (phRootNode:get-attribute ("failures")) + testTypeResult:GetFailureCount())).    
        end.
        
        methodResultArray = testTypeResult:getTestResult().
        
        if isTestSuite then
        do:
            create x-noderef testSuiteHandle.
            isTestSuite = false. /*making it false since only once we need to create testsuite element*/
            testSuiteCreated = true.
            phDoc:create-node (testSuiteHandle, "testsuite", "ELEMENT").
            phRootNode:append-child (testSuiteHandle).
            testSuiteHandle:set-attribute ("name", testSuiteName).
        end.

        if testSuiteCreated then
        do:
            create x-noderef testCaseHandle.
            phDoc:create-node (testCaseHandle, "testcase", "ELEMENT").
            testSuiteHandle:append-child (testCaseHandle).
            testCaseHandle:set-attribute ("name", testClass).
            writtenFilesCount = writtenFilesCount + 1.
        end.            
        else
        do:
            create x-noderef testCaseHandle.
            phDoc:create-node (testCaseHandle, "testcase", "ELEMENT").
            phRootNode:append-child (testCaseHandle).
            testCaseHandle:set-attribute ("name", testClass).
        end.
        
        /*
        This block is for testcases with the @BeforeClass method failing
        */
        if testTypeResult:getTestCount() = 0  then
        do:
            if not testTypeResult:GetFailureCount() = 0 or not testTypeResult:GetErrorCount() = 0 then
            do:
                testCaseHandle:append-child(createTestXMLResult(phDoc, testTypeResult:getBeforeTypeResult())).
            end. 
        end.
        /*
        Loop through all the test methods to create <test> tag
        */
        do i = 1 to testTypeResult:getTestCount() :
            testCaseHandle:append-child(createTestXMLResult(phDoc, methodResultArray[i])).
        end.
        
        phDoc:save("file", pcXmlFileName).
    end method.

    /*------------------------------------------------------------------------------
            Creates the <test> tag element for every test method.                                                                       
    ------------------------------------------------------------------------------*/
    method public handle CreateTestXMLResult(input phDoc as handle,input testResult as OpenEdge.ABLUnit.Results.TestTestResult):
        define variable hXnode   as handle no-undo.
        define variable hXResult as handle no-undo.
        
        create x-noderef hXnode.
        create x-noderef hXResult.
        
        phDoc:create-node(hXnode, "test", "ELEMENT").
        hXnode:set-attribute ("name", testResult:getTestName()).
        if testResult:isIncomplete() then
        do:
            hXnode:set-attribute ("incomplete", "true").    
        end.
        if testResult:getStatus() = 3 then
        do:
            hXnode:set-attribute ("result", "Success").
        end.
        else if testResult:getStatus() = 5 then
            do:
                hXnode:set-attribute ("result", "Failure").
                phDoc:create-node(hXResult, "Failure", "ELEMENT").
                hXResult:set-attribute("Message", testResult:getExceptionMessage()).
                hXnode:append-child(hXResult).
            end.
            else if testResult:getStatus() = 6 then
                do:
                    hXnode:set-attribute ("result", "Error").
                    phDoc:create-node(hXResult, "Error", "ELEMENT").
                    hXResult:set-attribute("Message", testResult:GetError():GetMessage(1)).
                    hXnode:append-child(hXResult).
                end.
            
        return hXnode.
    end method.
    
end CLASS.