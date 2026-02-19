/************************************************
Copyright (c) 2013-2020,2023 by Progress Software Corporation. All rights reserved.
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

    Description : Driver program which accepts the testcases, test suites
                  and test directory or a configuration file as input

    Author(s)   : hgarapat

    Created     : Wed Jun 27 12:08:26 IST 2012
    Notes       :
  ----------------------------------------------------------------------*/

using OpenEdge.ABLUnit.Runner.ABLRunner.
using OpenEdge.ABLUnit.Runner.TestConfig.
using OpenEdge.Core.StringConstant.
using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.ObjectModelParser.
using Progress.Lang.AppError.
using Progress.Lang.Error.

block-level on error undo, throw.

/* ***************************  Definitions  ************************** */

define variable commandParams as character         no-undo.
define variable jsonParser    as ObjectModelParser no-undo.
define variable configJson    as class             JsonObject no-undo.
define variable testConfig    as class             TestConfig no-undo.
define variable ablRunner     as ABLRunner         no-undo.
define variable updateFile    as character         no-undo.
define variable quitOnEnd     as logical           no-undo init false.
define variable configFile    as character         no-undo.

/* ***************************  UDF  *************************** */

/* Returns the config file name from the session params */
function GetConfigFile returns character (input pParams as character):
    define variable fileName as character no-undo.
    define variable loop     as integer   no-undo.
    define variable cnt      as integer   no-undo.

    assign
        cnt      = num-entries(pParams, StringConstant:SPACE)
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
assign
    session:suppress-warnings = yes
    commandParams             = trim(session:parameter, StringConstant:DOUBLE_QUOTE)
    .
/**
 * The goal is to always run the tests off a JSON configuration file,
 * even if that structure must be created from any passed parameters.
 */
assign configFile = GetConfigFile(commandParams).
if not configFile eq '':u then
    assign
        jsonParser = new ObjectModelParser()
        configJson = cast(jsonParser:ParseFile(configFile), JsonObject)
        updateFile = '':u  // make it explicit
        .
else
    run CreateJsonFromParam (input commandParams, output configJson, output updateFile).

testConfig = new TestConfig(configJson).
/* If there is no error, we should assign the corresponding 'quitOnEnd' */
quitOnEnd = testConfig:quitOnEnd.

ablRunner = new ABLRunner(testConfig, updateFile).
ablRunner:RunTests().

catch e as Error:
    if configJson = ? then
    do:
        quitOnEnd = true.
        return error new AppError("An error occured: " + e:GetMessage(1), 0).
    end.

    if testConfig:WriteLog then
    do:
        log-manager:logfile-name = session:temp-dir + "ablunit.log".
        log-manager:write-message(e:GetMessage(1)).
        if type-of(e, AppError) then
            log-manager:write-message(cast(e, AppError):ReturnValue).
        log-manager:write-message(e:CallStack).
        log-manager:close-log().
    end.
    if testConfig:ShowErrorMessage then
        message e:GetMessage(1)
            view-as alert-box error.
    if testConfig:ThrowError then
        undo, throw e.
end.
finally:
    if quitOnEnd then
        quit.
    else
        {&_proparse_ prolint-nowarn(returnfinally)}
        return. /* Need to return to avoid errors when running as an ANT task. */
end.

/* **********************  Internal Procedures  *********************** */

procedure CreateJsonFromParam private:
    /*------------------------------------------------------------------------------
     Purpose: This procedure create a JSON object for the input test passed from command line.
     Notes:
    ------------------------------------------------------------------------------*/
    define input  parameter pCmdParams  as character  no-undo.
    define output parameter pConfigJson as JsonObject no-undo.
    define output parameter pUpdateFile as character  no-undo.

    define variable testCase         as character  no-undo.
    define variable tcCount          as integer    no-undo init 1.
    define variable testCasesCount   as integer    no-undo.
    define variable testMethodsCount as integer    no-undo.
    define variable testResource     as character  no-undo.
    define variable testMethod       as character  no-undo.
    define variable testsString      as character  no-undo.
    define variable testsJson        as JsonArray  no-undo.
    define variable testJson         as JsonObject no-undo.
    define variable casesArray       as JsonArray  no-undo.
    define variable outputFolder     as character  no-undo.
    define variable cParam           as integer    no-undo.
    define variable numParams        as integer    no-undo.
    define variable tmpParam         as character  no-undo.

    assign
        pConfigJson = new JsonObject()
        testsJson   = new JsonArray()
        pUpdateFile = os-getenv("ATTR_ABLUNIT_EVENT_FILE":u)
        testsString = os-getenv("ATTR_ABLUNIT_TESTCASE_NAME":u)
        numParams   = num-entries(pCmdParams, StringConstant:SPACE)
        .
    if pUpdateFile eq ? then
        assign pUpdateFile = '':u.

    if testsString eq ? then
        assign testsString = entry(1, pCmdParams, StringConstant:SPACE).

    PARAM-LOOP:
    do cParam = 1 to numParams:
        assign
            tmpParam = entry(cParam, pCmdParams, StringConstant:SPACE).
        if (tmpParam = "-outputLocation") then
        do:
            assign
                outputFolder = entry (cParam + 1, pCmdParams, StringConstant:SPACE).
            leave PARAM-LOOP.
        end.
    end.

    if outputFolder ne "" then
    do:
        define variable optionsJson as JsonObject no-undo.
        define variable outputJson  as JsonObject no-undo.

        optionsJson = new JsonObject().
        outputJson = new JsonObject().

        outputJson:Add("location", outputFolder).
        optionsJson:Add("output", outputJson).
        pConfigJson:Add("options", optionsJson).
    end.

    assign
        testCasesCount = num-entries(testsString)
        testJson       = new JsonObject()
        .

    TEST-CASE-LOOP:
    do tcCount = 1 to testCasesCount:
        assign
            testCase         = entry(tcCount, testsString)
            testMethodsCount = num-entries(testCase, "#")
            .
        if testMethodsCount gt 2 then
            // update message : only 1 testMethod supported
            return error new AppError ("More than one test method per test case is not supported", 0).

        assign
            testResource        = entry(1, testCase, "#")
            testJson            = new JsonObject()
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

        if testMethodsCount eq 2 then
        do:
            assign
                testMethod = entry(2, testCase, "#")
                casesArray = new JsonArray()
                .
            casesArray:Add(testMethod).
            testJson:Add("cases", casesArray).
        end.
        testsJson:Add(testJson).
    end.

    pConfigJson:Add("tests", testsJson).
end procedure.
