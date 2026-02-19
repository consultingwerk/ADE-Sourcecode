/************************************************
Copyright (c)  2013-2015,2020,2023 by Progress Software Corporation. All rights reserved.
*************************************************/
/*------------------------------------------------------------------------
   File        : TestConfig
   Purpose     :
   Syntax      :
   Description :
   Author(s)   : psajja
   Created     : Wed Nov 20 15:56:07 IST 2013
   Notes       : The JSON format should be in the following format:

        {
            "options": {
                "output": {
                    "location": "<path-to-results>", // default: present working directory (PWD)
                    "fileName": "<file-name>", // default: results
                    "format": "<file-extension>" // default: xml
                },
                "debug": <boolean>, // enable debug options for ABLUnit, default: false
                "quitOnEnd": <boolean>, // default: true
                "showErrorMessage": <boolean>, // default: true
                "throwError": <boolean>, // default: false
                "writeLog": <boolean>, // default: false
                "xref": {
                    "useXref": <boolean>, // use XREF files from a specified location, default: false
                    "xrefLocation": "<path-to-xref-files>", // default: same as source file (PWD/SRC)
                    "xrefExtension": "<file-extension>", // default: xref (PDSOE uses <file>.xref.xml)
                    "xrefThrowError": <boolean> // default: false
                }
            },
            "tests": [
                {
                    "test": "<class>.cls"
                },
                {
                    "test": "<procedure>.p"
                },
                {
                    "folder": "<path-to-tests>"
                },
                {
                    "test": "<class>.cls",
                    "cases": [
                        "<case-name>"
                    ]
                }
            ]
        }

        Current documentation can be found at the following location:
        https://docs.progress.com/bundle/openedge-developer-studio-help/page/Run-test-cases-from-the-command-prompt.html
 ----------------------------------------------------------------------*/

using Progress.Json.ObjectModel.JsonArray.
using Progress.Json.ObjectModel.JsonObject.
using Progress.Json.ObjectModel.JsonDataType.
using Progress.Lang.AppError.

block-level on error undo, throw.

class OpenEdge.ABLUnit.Runner.TestConfig:

    define private variable configJson as JsonObject no-undo.

    /* List of tests to perform. */
    define public property testsJson as JsonArray no-undo get.
        private set.

    /* Control output for tests. */
    define public property outputLocation as character no-undo initial "PWD" get.
        private set.
    define public property outputFormat as character no-undo initial "xml" get.
        private set.

    /* General options for ABLUnit tests. */
    define public property debugEnabled as logical no-undo initial false get.
        private set.
    define public property quitOnEnd as logical no-undo initial true get.
        private set.
    define public property showErrorMessage as logical no-undo initial true get.
        private set.
    define public property throwError as logical initial false no-undo get.
        private set.
    define public property writeLog as logical no-undo initial false get.
        private set.

    /* XREF options for ABLUnit tests. */
    define public property useXref as logical no-undo initial false get.
        private set.
    define public property xrefLocation as character no-undo initial "SRC" get.
        private set.
    define public property xrefExtension as character no-undo initial "xref" get.
        private set.
    define public property xrefThrowError as logical initial false no-undo get.
        private set.

    /* Results file name user can specify custom file name. */
    define public property ResultsFileName as character no-undo initial "results" get.
        private set.

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    constructor public TestConfig ( input inputJson as class JsonObject ):
        super ().
        if not valid-object(inputJson) then
            return error new AppError("JsonObject can not be null.", 0).
        configJson = inputJson.
        this-object:Initialize().
    end constructor.

    /*------------------------------------------------------------------------------
     Purpose: This method will return the results file name.
     Notes:
    ------------------------------------------------------------------------------*/
    method public character GetResultsFile ( ):
        define variable resFileName as character no-undo.
        if outputLocation = "PWD" then
            resFileName = ResultsFileName + ".xml".
        else
            resFileName = outputLocation + "/" + ResultsFileName + ".xml".
        return resFileName.
    end method.

    /*------------------------------------------------------------------------------
     Purpose: This method parses and initializes the properties from JSON config.
     Notes:
    ------------------------------------------------------------------------------*/
    method private void Initialize ( ):
        define variable optionsJson as JsonObject no-undo.
        define variable outputJson  as JsonObject no-undo.
        define variable xrefJson    as JsonObject no-undo.

        /* Process options, if available. */
        if configJson:Has("options") and configJson:GetType("options") eq JsonDataType:OBJECT then
        do:
            optionsJson = configJson:GetJsonObject("options").

            /* Process the output options .*/
            if optionsJson:Has("output") and optionsJson:GetType("output") eq JsonDataType:OBJECT then
            do:
                outputJson = optionsJson:GetJsonObject("output").
                if outputJson:Has("location") and outputJson:GetType("location") eq JsonDataType:STRING then
                    this-object:outputLocation = outputJson:GetCharacter("location").
                if outputJson:Has("fileName") and outputJson:GetType("fileName") eq JsonDataType:STRING then
                    this-object:ResultsFileName = outputJson:GetCharacter("fileName").

                if outputJson:Has("format") and outputJson:GetType("format") eq JsonDataType:STRING then
                do:
                    if outputJson:GetCharacter("format") eq "xml" then
                        this-object:outputFormat = "xml". /* Only supported type at this time. */
                    else
                        return error new AppError("Invalid format option specified. Currently supports XML only.", 0).
                end.
            end. /* output */

            if optionsJson:Has("debug") and optionsJson:GetType("debug") eq JsonDataType:BOOLEAN then
                this-object:debugEnabled = optionsJson:GetLogical('debug').

            if optionsJson:Has("quitOnEnd") and optionsJson:GetType("quitOnEnd") eq JsonDataType:BOOLEAN then
                this-object:quitOnEnd = optionsJson:GetLogical('quitOnEnd').

            if optionsJson:Has("showErrorMessage") and optionsJson:GetType("showErrorMessage") eq JsonDataType:BOOLEAN then
                this-object:showErrorMessage = optionsJson:GetLogical('showErrorMessage').

            if optionsJson:Has("throwError") and optionsJson:GetType("throwError") eq JsonDataType:BOOLEAN then
                this-object:throwError = optionsJson:GetLogical('throwError').

            if optionsJson:Has("writeLog") and optionsJson:GetType("writeLog") eq JsonDataType:BOOLEAN then
                this-object:writeLog = optionsJson:GetLogical('writeLog').

            /* Process the XREF options, which will use pre-existing XREF files instead of compiling on the fly. */
            if optionsJson:Has("xref") and optionsJson:GetType("xref") eq JsonDataType:OBJECT then
            do:
                xrefJson = optionsJson:GetJsonObject("xref"). // Get reference to the "xref" config object.

                // Directs ABLUnit to find XREF files in a specific location.
                if xrefJson:Has("useXref") and xrefJson:GetType("useXref") eq JsonDataType:BOOLEAN then
                    this-object:useXref = xrefJson:GetLogical("useXref").

                if this-object:useXref then 
                do:
                    /**
                     * These options will provide information about where to find the XREF files
                     * and what to do if they cannot be located. (Describe how they are found)
                     */
                    if xrefJson:Has("xrefLocation") and xrefJson:GetType("xrefLocation") eq JsonDataType:STRING then
                        this-object:xrefLocation = xrefJson:GetCharacter("xrefLocation").
                    if xrefJson:Has("xrefExtension") and xrefJson:GetType("xrefExtension") eq JsonDataType:STRING then
                        this-object:xrefExtension = xrefJson:GetCharacter("xrefExtension").
                    if xrefJson:Has("xrefThrowError") and xrefJson:GetType("xrefThrowError") eq JsonDataType:BOOLEAN then
                        this-object:xrefThrowError = xrefJson:GetLogical("xrefThrowError").
                end. /* useXref */
            end. /* xref */
        end. /* options */

        if configJson:Has("tests") and configJson:GetType("tests") eq JsonDataType:ARRAY then
            this-object:testsJson = configJson:GetJsonArray("tests").
        else
            this-object:testsJson = new JsonArray(). /* Provide an empty array. */
    end method.

end class.