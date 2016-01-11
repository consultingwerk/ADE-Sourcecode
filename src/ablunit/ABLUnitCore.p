/************************************************
Copyright (c)  2013-2014 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
    File        : ABLUnitCore
    
    Purpose     : Driver program which accepts the testcases, test suites 
                  and test directory or a configuration file as input in the following format
                  
                  Format:
                      prowin32 -p ABLUnitCore.p -param TestClass.cls
                      prowin32 -p ABLUnitCore.p -param TestClass.cls#TestM1 (for running a particular method inside a testclass)
                      prowin32 -p ABLUnitCore.p -param TestProcedure.p
                      prowin32 -p ABLUnitCore.p -param TestProcedure.p#TestP1 (for running a particular internal procedure inside a testprocedure)
                      prowin32 -p ABLUnitCore.p -param <Full Path of TestFolder>
                      
                      or to specify an output directory to write the results
                      
                      prowin32 -p ABLUnitCore.p -param "TestClass.cls -outputLocation C:\results"
                      
                      or
                      
                      prowin32 -p ABLUnitCore.p -param "CFG=C:\<config-file>"
    Syntax      :
        
    Description : Driver program which accepts the testcases, test suites 
                  and test directory or a configuration file as input
                  
    Author(s)   : hgarapat
    
    Created     : Wed Jun 27 12:08:26 IST 2012
    Notes       :
  ----------------------------------------------------------------------*/
  
USING OpenEdge.ABLUnit.Runner.ABLRunner.
USING OpenEdge.ABLUnit.Runner.TestConfig.
USING Progress.Json.ObjectModel.JsonArray.
USING Progress.Json.ObjectModel.JsonObject.
USING Progress.Json.ObjectModel.ObjectModelParser.
USING Progress.Lang.AppError.
USING Progress.Lang.Error.

ROUTINE-LEVEL ON ERROR UNDO, THROW.

/* ***************************  Definitions  ************************** */
DEFINE VARIABLE commandParams AS CHARACTER NO-UNDO.
DEFINE VARIABLE jsonParser AS ObjectModelParser NO-UNDO.
DEFINE VARIABLE configJson AS CLASS JsonObject NO-UNDO.

DEFINE VARIABLE testConfig AS CLASS TestConfig NO-UNDO.

DEFINE VARIABLE numParams AS INTEGER NO-UNDO.

DEFINE VARIABLE ablRunner AS ABLRunner NO-UNDO.

DEFINE VARIABLE updateFile AS CHARACTER NO-UNDO.

DEFINE VARIABLE quitOnEnd AS LOGICAL NO-UNDO INIT FALSE.

/* ***************************  Main Block  *************************** */
commandParams = SESSION:PARAM.
numParams = NUM-ENTRIES(commandParams, " ").
IF commandParams BEGINS "CFG=" THEN 
    DO:
        jsonParser = NEW ObjectModelParser().
        configJson = CAST(jsonParser:ParseFile(ENTRY(2, commandParams, "=")), JsonObject).
    END.
ELSE
  RUN CreateJsonFromParam(INPUT commandParams, OUTPUT configJson, OUTPUT updateFile).
testConfig = NEW TestConfig(configJson).
ablRunner = NEW ABLRunner(testConfig, updateFile).
ablRunner:RunTests().

/*If there is no error, we should assign the corresponding 'quiteOnEnd'*/
quitOnEnd = testConfig:quitOnEnd.

CATCH e AS Error:
    IF configJson = ? THEN
    DO:
        quitOnEnd = TRUE.
        RETURN ERROR NEW AppError ("An error occured: " + e:GetMessage(1), 0).
    END.
    ELSE
        quitOnEnd = testConfig:quitOnEnd.
    IF testConfig:WriteLog THEN
        DO:
            LOG-MANAGER:LOGFILE-NAME = SESSION:TEMP-DIR + "ablunit.log".
            LOG-MANAGER:LOG-ENTRY-TYPES = "4GLMessages".
            LOG-MANAGER:WRITE-MESSAGE (e:GetMessage(1)).
            LOG-MANAGER:CLOSE-LOG.
        END.
    IF testConfig:ShowErrorMessage THEN
        MESSAGE e:GetMessage(1)
        VIEW-AS ALERT-BOX ERROR.
    IF testConfig:ThrowError THEN
        UNDO, THROW e.
END.
FINALLY:
    IF quitOnEnd THEN
        QUIT.
END.

/* **********************  Internal Procedures  *********************** */

PROCEDURE CreateJsonFromParam PRIVATE:
/*------------------------------------------------------------------------------
 Purpose: This procedure create a JSON object for the input test passed from command line.
 Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER cmdParams AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER configJson AS JsonObject NO-UNDO.
    DEFINE OUTPUT PARAMETER updateFile AS CHARACTER NO-UNDO.
    
    DEFINE VARIABLE testCase AS CHARACTER NO-UNDO.
    DEFINE VARIABLE tcCount AS INTEGER NO-UNDO INIT 1.
    DEFINE VARIABLE testCasesCount AS INTEGER NO-UNDO.
    DEFINE VARIABLE testMethodsCount AS INTEGER NO-UNDO.
    DEFINE VARIABLE testResource AS CHARACTER NO-UNDO.
    DEFINE VARIABLE testMethod AS CHARACTER NO-UNDO.

    DEFINE VARIABLE testsString AS CHARACTER NO-UNDO.
    
    DEFINE VARIABLE testsJson AS JsonArray NO-UNDO.
    DEFINE VARIABLE testJson AS JsonObject NO-UNDO.
    DEFINE VARIABLE casesArray AS JsonArray NO-UNDO.

    DEFINE VARIABLE outputFolder AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cParam AS INTEGER NO-UNDO.
    
    DEFINE VARIABLE tmpParam AS CHARACTER NO-UNDO.
    
    configJson = NEW JsonObject().
    testsJson = NEW JsonArray().
    
    IF numParams = 0  THEN
    DO:
        testsString = OS-GETENV("ATTR_ABLUNIT_TESTCASE_NAME").
        updateFile =  OS-GETENV("ATTR_ABLUNIT_EVENT_FILE").
    END.
    ELSE    
        testsString = ENTRY (1, cmdParams, " ").
    
    DO cParam = 2 TO numParams:
        tmpParam = ENTRY (cParam, cmdParams, " ").
        IF(tmpParam = "-outputLocation") THEN
            DO:
                outputFolder = ENTRY (cParam + 1, cmdParams, " ").
                cParam = cParam + 1.
            END.
    END.

    IF outputFolder NE "" THEN 
        DO:
            DEFINE VARIABLE optionsJson AS JsonObject NO-UNDO.
            DEFINE VARIABLE outputJson AS JsonObject NO-UNDO.
            
            optionsJson = NEW JsonObject().
            outputJson = NEW JsonObject().
            
            outputJson:Add("location", outputFolder).
            optionsJson:Add("output", outputJson).
            configJson:Add("options", optionsJson).
            
        END.

    testCasesCount = NUM-ENTRIES(testsString, ",").
    
    testJson = NEW JsonObject().
    
    DO tcCount = 1 TO testCasesCount:
        testCase = ENTRY (tcCount, testsString, ",").
        testMethodsCount =  NUM-ENTRIES (testCase, "#").
        IF NOT (testMethodsCount = 2 OR  testMethodsCount = 1 )THEN 
            RETURN ERROR NEW AppError ("Not according to the input format.", 0).
        
        testResource = ENTRY(1, testCase, "#").
        testJson = NEW JsonObject().
        testJson:Add("test", testResource).
        IF testMethodsCount = 2 THEN 
            DO:
                testMethod = ENTRY(2, testCase, "#").
                casesArray = NEW JsonArray().
                casesArray:Add(testMethod).
                testJson:Add("cases", casesArray).
            END.
        testsJson:Add(testJson).
    END.
    configJson:Add("tests", testsJson).
END PROCEDURE.