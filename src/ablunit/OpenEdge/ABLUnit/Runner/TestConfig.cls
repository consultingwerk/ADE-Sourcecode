/************************************************
Copyright (c)  2013-2015 by Progress Software Corporation. All rights reserved.
*************************************************/ 
/*------------------------------------------------------------------------
   File        : TestConfig
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : psajja
   Created     : Wed Nov 20 15:56:07 IST 2013
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Json.ObjectModel.JsonArray.
USING Progress.Json.ObjectModel.JsonObject.
USING Progress.Lang.AppError.

ROUTINE-LEVEL ON ERROR UNDO, THROW.

CLASS OpenEdge.ABLUnit.Runner.TestConfig: 

    DEFINE PUBLIC PROPERTY testsJson AS JsonArray GET. 
        PRIVATE SET.
    DEFINE PRIVATE VARIABLE configJson AS JsonObject NO-UNDO.
    
    DEFINE PUBLIC PROPERTY outputLocation AS CHARACTER NO-UNDO INIT "PWD" GET. 
        PRIVATE SET.
    DEFINE PUBLIC PROPERTY outputFormat AS CHARACTER NO-UNDO INIT "xml" GET. 
        PRIVATE SET.
    
    DEFINE PUBLIC PROPERTY quitOnEnd AS LOGICAL NO-UNDO INIT TRUE GET. 
        PRIVATE SET.
    DEFINE PUBLIC PROPERTY writeLog AS LOGICAL NO-UNDO INIT FALSE GET. 
        PRIVATE SET.
    DEFINE PUBLIC PROPERTY showErrorMessage AS LOGICAL NO-UNDO INIT TRUE GET. 
        PRIVATE SET.
    DEFINE PUBLIC PROPERTY throwError AS LOGICAL INIT FALSE NO-UNDO GET. 
        PRIVATE SET.
    
    /*Results file name user can specify custom file name*/
    DEFINE PUBLIC PROPERTY ResultsFileName AS CHARACTER NO-UNDO INIT "results" GET. 
        PRIVATE SET.
    
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
        
    CONSTRUCTOR PUBLIC TestConfig (INPUT inputJson AS CLASS JsonObject ):
        SUPER ().
        IF inputJson = ? THEN
            RETURN ERROR NEW AppError("JsonObject can not be null.", 0).
        configJson = inputJson.
        THIS-OBJECT:Initialize().
    END CONSTRUCTOR.
    
    /*------------------------------------------------------------------------------
     Purpose: This method will return the restuls file name.
     Notes:
    ------------------------------------------------------------------------------*/

    METHOD PUBLIC CHARACTER GetResultsFile(  ):
		
        DEFINE VARIABLE resFileName AS CHARACTER NO-UNDO.
         IF outputLocation = "PWD" THEN 
            resFileName = ResultsFileName + ".xml".
        ELSE 
            resFileName = outputLocation + "/" + ResultsFileName + ".xml".
        RETURN resFileName.

    END METHOD.

    /*------------------------------------------------------------------------------
     Purpose: This method parses and initializes the valies.
     Notes:
    ------------------------------------------------------------------------------*/

    METHOD PRIVATE VOID Initialize(  ):
        DEFINE VARIABLE optionsJson AS JsonObject NO-UNDO.
        DEFINE VARIABLE outputJson  AS JsonObject NO-UNDO.
        IF configJson:Has("options") THEN 
        DO:
            optionsJson = configJson:GetJsonObject("options").
            IF optionsJson:Has("output") THEN 
            DO:
                outputJson = optionsJson:GetJsonObject("output").
                IF outputJson:Has("location") THEN
                    outputLocation = outputJson:GetCharacter("location").
                IF outputJson:Has("fileName") THEN
                    ResultsFileName = outputJson:GetCharacter("fileName").
                IF outputJson:Has("format") THEN
                DO:
                    outputFormat = outputJson:GetCharacter("format").
                    IF outputFormat NE "xml" THEN
                        RETURN ERROR NEW AppError("Invalid format option specified. Currently supports xml only.", 0).
                END.
            END.
                    
            IF optionsJson:Has("quitOnEnd") THEN 
                quitOnEnd = optionsJson:GetLogical('quitOnEnd').
                    
            IF optionsJson:Has("writeLog") THEN 
                writeLog = optionsJson:GetLogical('writeLog').
                    
            IF optionsJson:Has("showErrorMessage") THEN 
                showErrorMessage = optionsJson:GetLogical('showErrorMessage').
                    
            IF optionsJson:Has("throwError") THEN 
                throwError = optionsJson:GetLogical('throwError').
        END.
            
        testsJson = configJson:GetJsonArray("tests").
            
        RETURN.
    END METHOD.

END CLASS.