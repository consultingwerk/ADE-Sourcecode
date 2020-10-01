/************************************************
Copyright (c) 2013-2020 by Progress Software Corporation. All rights reserved.
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
using OpenEdge.Core.StringConstant.
USING Progress.Json.ObjectModel.JsonArray.
USING Progress.Json.ObjectModel.JsonObject.
USING Progress.Json.ObjectModel.ObjectModelParser.
USING Progress.Lang.AppError.
USING Progress.Lang.Error.

BLOCK-LEVEL ON ERROR UNDO, THROW.

/* ***************************  Definitions  ************************** */
DEFINE VARIABLE commandParams AS CHARACTER NO-UNDO.
DEFINE VARIABLE jsonParser AS ObjectModelParser NO-UNDO.
DEFINE VARIABLE configJson AS CLASS JsonObject NO-UNDO.
DEFINE VARIABLE testConfig AS CLASS TestConfig NO-UNDO.
DEFINE VARIABLE ablRunner AS ABLRunner NO-UNDO.
DEFINE VARIABLE updateFile AS CHARACTER NO-UNDO.
DEFINE VARIABLE quitOnEnd AS LOGICAL NO-UNDO INIT FALSE.
define variable configFile as character no-undo.

/* ***************************  UDF  *************************** */
/* Returns the config file name from the session params */
function GetConfigFile returns character (input pParams as character):
    define variable fileName as character no-undo.
    define variable loop as integer no-undo.
    define variable cnt as integer no-undo.
    
    assign cnt      = num-entries(pParams, StringConstant:SPACE)
           fileName = '':u
           .
    do loop = 1 to cnt
    while fileName eq '':u:
        if entry(loop, pParams, StringConstant:SPACE) begins 'CFG=':u then
            assign fileName = entry(2, entry(loop, pParams, StringConstant:SPACE), '=':u).
    end.
    
    return fileName. 
end function.

/* ***************************  Main Block  *************************** */
// Supress the warnings
assign SESSION:SUPPRESS-WARNINGS = YES
       commandParams = TRIM(SESSION:PARAMETER, StringConstant:DOUBLE_QUOTE)
       .
/**
 * The goal is to always run the tests off a JSON configuration file,
 * even if that structure must be created from any passed parameters.
 */
assign configFile = GetConfigFile(commandParams).
if not configFile eq '':u then
    assign jsonParser = NEW ObjectModelParser()
           configJson = CAST(jsonParser:ParseFile(configFile), JsonObject)
           updateFile = '':u  // make it explicit
           .
ELSE
    RUN CreateJsonFromParam (INPUT commandParams, OUTPUT configJson, OUTPUT updateFile).

testConfig = NEW TestConfig(configJson).
/* If there is no error, we should assign the corresponding 'quitOnEnd' */
quitOnEnd = testConfig:quitOnEnd.

ablRunner = NEW ABLRunner(testConfig, updateFile).
ablRunner:RunTests().

CATCH e AS Error:
    IF configJson = ? THEN
    DO:
        quitOnEnd = TRUE.
        RETURN ERROR NEW AppError ("An error occured: " + e:GetMessage(1), 0).
    END.
    
    IF testConfig:WriteLog THEN
    DO:
        LOG-MANAGER:LOGFILE-NAME = SESSION:TEMP-DIR + "ablunit.log".
        LOG-MANAGER:WRITE-MESSAGE (e:GetMessage(1)).
        if type-of(e, AppError) then
            LOG-MANAGER:WRITE-MESSAGE (cast(e, AppError):ReturnValue).
        LOG-MANAGER:WRITE-MESSAGE (e:CallStack).
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
    ELSE
        {&_proparse_ prolint-nowarn(returnfinally)}
        RETURN. /* Need to return to avoid errors when running as an ANT task. */
END.

/* **********************  Internal Procedures  *********************** */
PROCEDURE CreateJsonFromParam PRIVATE:
/*------------------------------------------------------------------------------
 Purpose: This procedure create a JSON object for the input test passed from command line.
 Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pCmdParams AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pConfigJson AS JsonObject NO-UNDO.
    DEFINE OUTPUT PARAMETER pUpdateFile AS CHARACTER NO-UNDO.

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
    define variable numParams as integer no-undo.
    DEFINE VARIABLE tmpParam AS CHARACTER NO-UNDO.
    
    assign pConfigJson = NEW JsonObject()
           testsJson   = NEW JsonArray()
           pUpdateFile = OS-GETENV("ATTR_ABLUNIT_EVENT_FILE":u)
           testsString = OS-GETENV("ATTR_ABLUNIT_TESTCASE_NAME":u)
           numParams   = num-entries(pCmdParams, StringConstant:SPACE)
           .
    if pUpdateFile eq ? then
        assign pUpdateFile = '':u.
    
    if testsString eq ? then
        assign testsString = entry(1, pCmdParams, StringConstant:SPACE).
    
    PARAM-LOOP:
    DO cParam = 1 TO numParams:
        assign tmpParam = ENTRY(cParam, pCmdParams, StringConstant:SPACE).
        IF (tmpParam = "-outputLocation") THEN
        do:
            assign outputFolder = ENTRY (cParam + 1, pCmdParams, StringConstant:SPACE).
            leave PARAM-LOOP.
        end.
    END.
    
    IF outputFolder NE "" THEN
    DO:
        DEFINE VARIABLE optionsJson AS JsonObject NO-UNDO.
        DEFINE VARIABLE outputJson AS JsonObject NO-UNDO.

        optionsJson = NEW JsonObject().
        outputJson = NEW JsonObject().
        
        outputJson:Add("location", outputFolder).
        optionsJson:Add("output", outputJson).
        pConfigJson:Add("options", optionsJson).
    END.
    
    assign testCasesCount = NUM-ENTRIES(testsString)
           testJson       = NEW JsonObject()
           .
    TEST-CASE-LOOP:
    DO tcCount = 1 TO testCasesCount:
        assign testCase         = ENTRY(tcCount, testsString)
               testMethodsCount = NUM-ENTRIES(testCase, "#")
               .
        IF testMethodsCount gt 2 THEN
            // update message : only 1 testMethod supported
            RETURN ERROR NEW AppError ("More than one test method per test case is not supported", 0).
        
        assign testResource        = ENTRY(1, testCase, "#")
               testJson            = NEW JsonObject()
               file-info:file-name = testResource
               .
        if index(file-info:file-type, 'D':u) gt 0 then
            testJson:Add('folder':u, testResource).
        else
        if index(file-info:file-type, 'F':u) gt 0 then
            testJson:Add('test':u, testResource).
        else
        do:
            // if a type name was used (instead of a .cls file) then try to find and use the associated cls file
            assign file-info:file-name = replace(testResource, '.':u, '/':u) + '.cls':u.
            if file-info:full-pathname eq ? then
                // we don't know what this is, and it doesn't look like a test, so skip
                next TEST-CASE-LOOP.
            else
                testJson:Add('test':u, file-info:full-pathname).
        end.
        
        IF testMethodsCount = 2 THEN
        DO:
            assign testMethod = ENTRY(2, testCase, "#")
                   casesArray = NEW JsonArray()
                   .
            casesArray:Add(testMethod).
            testJson:Add("cases", casesArray).
        END.
        testsJson:Add(testJson).
    END.
    
    pConfigJson:Add("tests", testsJson).
END PROCEDURE.
