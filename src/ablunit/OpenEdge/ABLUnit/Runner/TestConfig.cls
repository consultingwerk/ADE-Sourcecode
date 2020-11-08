/************************************************
Copyright (c)  2013-2015,2020 by Progress Software Corporation. All rights reserved.
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
                    "location": "<path-to-results>", // default: present working directory
                    "fileName": "<file-name>", // default: results
                    "format": "<file-extension>" // default: xml
                },
                "quitOnEnd": <boolean>, // default: true
                "writeLog": <boolean>, // default: false
                "showErrorMessage": <boolean>, // default: true
                "throwError": <boolean>, // default: false
                "xref": {
                    "useXref": <boolean>, // default false
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
        https://docs.progress.com/bundle/developer-studio-olh/page/Run-test-cases-from-the-command-prompt.html
 ----------------------------------------------------------------------*/

USING Progress.Json.ObjectModel.JsonArray.
USING Progress.Json.ObjectModel.JsonObject.
USING Progress.Json.ObjectModel.JsonDataType.
USING Progress.Lang.AppError.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS OpenEdge.ABLUnit.Runner.TestConfig:

    DEFINE PRIVATE VARIABLE configJson AS JsonObject NO-UNDO.

    /* List of tests to perform. */
    DEFINE PUBLIC PROPERTY testsJson AS JsonArray NO-UNDO GET.
        PRIVATE SET.

    /* Control output for tests. */
    DEFINE PUBLIC PROPERTY outputLocation AS CHARACTER NO-UNDO INITIAL "PWD" GET.
        PRIVATE SET.
    DEFINE PUBLIC PROPERTY outputFormat AS CHARACTER NO-UNDO INITIAL "xml" GET.
        PRIVATE SET.

    /* General options for ABLUnit tests. */
    DEFINE PUBLIC PROPERTY quitOnEnd AS LOGICAL NO-UNDO INITIAL TRUE GET.
        PRIVATE SET.
    DEFINE PUBLIC PROPERTY writeLog AS LOGICAL NO-UNDO INITIAL FALSE GET.
        PRIVATE SET.
    DEFINE PUBLIC PROPERTY showErrorMessage AS LOGICAL NO-UNDO INITIAL TRUE GET.
        PRIVATE SET.
    DEFINE PUBLIC PROPERTY throwError AS LOGICAL INITIAL FALSE NO-UNDO GET.
        PRIVATE SET.

    /* XREF options for ABLUnit tests. */
    DEFINE PUBLIC PROPERTY useXref AS LOGICAL NO-UNDO INITIAL FALSE GET.
        PRIVATE SET.
    DEFINE PUBLIC PROPERTY xrefLocation AS CHARACTER NO-UNDO INITIAL "SRC" GET.
        PRIVATE SET.
    DEFINE PUBLIC PROPERTY xrefExtension AS CHARACTER NO-UNDO INITIAL "xref" GET.
        PRIVATE SET.
    DEFINE PUBLIC PROPERTY xrefThrowError AS LOGICAL INITIAL FALSE NO-UNDO GET.
        PRIVATE SET.

    /* Results file name user can specify custom file name. */
    DEFINE PUBLIC PROPERTY ResultsFileName AS CHARACTER NO-UNDO INITIAL "results" GET.
        PRIVATE SET.

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    CONSTRUCTOR PUBLIC TestConfig ( INPUT inputJson AS CLASS JsonObject ):
        SUPER ().
        IF NOT VALID-OBJECT(inputJson) THEN
            RETURN ERROR NEW AppError("JsonObject can not be null.", 0).
        configJson = inputJson.
        THIS-OBJECT:Initialize().
    END CONSTRUCTOR.

    /*------------------------------------------------------------------------------
     Purpose: This method will return the results file name.
     Notes:
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC CHARACTER GetResultsFile ( ):
        DEFINE VARIABLE resFileName AS CHARACTER NO-UNDO.
         IF outputLocation = "PWD" THEN
            resFileName = ResultsFileName + ".xml".
        ELSE
            resFileName = outputLocation + "/" + ResultsFileName + ".xml".
        RETURN resFileName.
    END METHOD.

    /*------------------------------------------------------------------------------
     Purpose: This method parses and initializes the properties from JSON config.
     Notes:
    ------------------------------------------------------------------------------*/
    METHOD PRIVATE VOID Initialize ( ):
        DEFINE VARIABLE optionsJson AS JsonObject NO-UNDO.
        DEFINE VARIABLE outputJson  AS JsonObject NO-UNDO.
        DEFINE VARIABLE xrefJson    AS JsonObject NO-UNDO.

        /* Process options, if available. */
        IF configJson:Has("options") AND configJson:GetType("options") EQ JsonDataType:OBJECT THEN
        DO:
            optionsJson = configJson:GetJsonObject("options").

            /* Process the output options .*/
            IF optionsJson:Has("output") AND optionsJson:GetType("output") EQ JsonDataType:OBJECT THEN
            DO:
                outputJson = optionsJson:GetJsonObject("output").
                IF outputJson:Has("location") AND outputJson:GetType("location") EQ JsonDataType:STRING THEN
                    THIS-OBJECT:outputLocation = outputJson:GetCharacter("location").
                IF outputJson:Has("fileName") AND outputJson:GetType("fileName") EQ JsonDataType:STRING THEN
                    THIS-OBJECT:ResultsFileName = outputJson:GetCharacter("fileName").

                IF outputJson:Has("format") AND outputJson:GetType("format") EQ JsonDataType:STRING THEN
                DO:
                    IF outputJson:GetCharacter("format") EQ "xml" THEN
                        THIS-OBJECT:outputFormat = "xml". /* Only supported type at this time. */
                    ELSE
                        RETURN ERROR NEW AppError("Invalid format option specified. Currently supports XML only.", 0).
                END.
            END. /* output */

            IF optionsJson:Has("quitOnEnd") AND optionsJson:GetType("quitOnEnd") EQ JsonDataType:BOOLEAN THEN
                THIS-OBJECT:quitOnEnd = optionsJson:GetLogical('quitOnEnd').

            IF optionsJson:Has("writeLog") AND optionsJson:GetType("writeLog") EQ JsonDataType:BOOLEAN THEN
                THIS-OBJECT:writeLog = optionsJson:GetLogical('writeLog').

            IF optionsJson:Has("showErrorMessage") AND optionsJson:GetType("showErrorMessage") EQ JsonDataType:BOOLEAN THEN
                THIS-OBJECT:showErrorMessage = optionsJson:GetLogical('showErrorMessage').

            IF optionsJson:Has("throwError") AND optionsJson:GetType("throwError") EQ JsonDataType:BOOLEAN THEN
                THIS-OBJECT:throwError = optionsJson:GetLogical('throwError').

            /* Process the XREF options, which will use pre-existing XREF files instead of compiling on the fly. */
            IF optionsJson:Has("xref") AND optionsJson:GetType("xref") EQ JsonDataType:OBJECT THEN
            DO:
                xrefJson = optionsJson:GetJsonObject("xref").
                IF xrefJson:Has("useXref") AND xrefJson:GetType("useXref") EQ JsonDataType:BOOLEAN THEN
                    THIS-OBJECT:useXref = xrefJson:GetLogical("useXref").

                IF THIS-OBJECT:useXref THEN DO:
                    /**
                     * These options will provide information about where to find the XREF files
                     * and what to do if they cannot be located. (Describe how they are found)
                     */
                    IF xrefJson:Has("xrefLocation") AND xrefJson:GetType("xrefLocation") EQ JsonDataType:STRING THEN
                        THIS-OBJECT:xrefLocation = xrefJson:GetCharacter("xrefLocation").
                    IF xrefJson:Has("xrefExtension") AND xrefJson:GetType("xrefExtension") EQ JsonDataType:STRING THEN
                        THIS-OBJECT:xrefExtension = xrefJson:GetCharacter("xrefExtension").
                    IF xrefJson:Has("xrefThrowError") AND xrefJson:GetType("xrefThrowError") EQ JsonDataType:BOOLEAN THEN
                        THIS-OBJECT:xrefThrowError = xrefJson:GetLogical("xrefThrowError").
                END. /* useXref */
            END. /* xref */
        END. /* options */

        IF configJson:Has("tests") AND configJson:GetType("tests") EQ JsonDataType:ARRAY THEN
            THIS-OBJECT:testsJson = configJson:GetJsonArray("tests").
        ELSE
            THIS-OBJECT:testsJson = NEW JsonArray(). /* Provide an empty array. */
    END METHOD.

END CLASS.