
/*------------------------------------------------------------------------
    File        : rmcutil.i
    Purpose     : Utility to convert compile result into Json String

    Syntax      :

    Description : It is used by _ascompile and _wscompile for getting the compile result in json.

    Author(s)   : vtayal
    Created     : Thu Nov 25 16:24:17 IST 2010
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
FUNCTION convertToJson RETURNS CHARACTER 
    ( INPUT cResult AS CHARACTER ) FORWARD.


/* ***************************  Main Block  *************************** */

/* ************************  Function Implementations ***************** */


FUNCTION convertToJson RETURNS CHARACTER 
        (INPUT cResult AS CHARACTER):
/*------------------------------------------------------------------------------
        Purpose:                                                                      
        Notes:                                                                        
------------------------------------------------------------------------------*/    

        &GLOBAL-DEFINE COMMAND_SEPARATOR CHR(3)
&GLOBAL-DEFINE OPTION_SEPARATOR CHR(4)
&GLOBAL-DEFINE ERROR_SEPARATOR CHR(5)
DEFINE VARIABLE compile_Result AS CHARACTER NO-UNDO.
DEFINE VARIABLE compile_ResultAsJson    AS CHARACTER NO-UNDO.
DEFINE VARIABLE failed                AS LOGICAL                              NO-UNDO.
DEFINE VARIABLE errorCount            AS INTEGER                              NO-UNDO.
DEFINE VARIABLE errorMsg              AS CHARACTER                            NO-UNDO.
DEFINE VARIABLE msgCount              AS INTEGER                              NO-UNDO.
DEFINE VARIABLE compilerStatus        AS CHARACTER                            NO-UNDO.
DEFINE VARIABLE messageCount          AS INTEGER                              NO-UNDO.
DEFINE VARIABLE msg                   AS CHARACTER                            NO-UNDO.
DEFINE VARIABLE fileNme               AS CHARACTER                            NO-UNDO.
DEFINE VARIABLE rw                    AS CHARACTER                            NO-UNDO.
DEFINE VARIABLE clm                   AS CHARACTER                            NO-UNDO.
DEFINE VARIABLE descrip               AS CHARACTER                            NO-UNDO.
DEFINE VARIABLE num                   AS CHARACTER                            NO-UNDO.
DEFINE VARIABLE typ                   AS CHARACTER                            NO-UNDO.
    
DEFINE VARIABLE compileResultJson     AS Progress.Json.ObjectModel.JsonObject NO-UNDO.
DEFINE VARIABLE msgJson               AS Progress.Json.ObjectModel.JsonObject NO-UNDO.
DEFINE VARIABLE msgjsonArrayString    AS CHARACTER                            NO-UNDO.
DEFINE VARIABLE errmsgJson            AS Progress.Json.ObjectModel.JsonObject NO-UNDO.
DEFINE VARIABLE errmsgjsonArrayString AS CHARACTER                            NO-UNDO.
    
    
DEFINE VARIABLE i                     AS INTEGER                              NO-UNDO.
DEFINE VARIABLE j                     AS INTEGER                              NO-UNDO.
failed = FALSE.  
compile_Result =  cResult. 
IF compile_Result <> ? AND compile_Result <> "" AND NOT compile_Result BEGINS "ERROR:" THEN
DO :
    errorCount = NUM-ENTRIES (compile_Result, {&ERROR_SEPARATOR}).
    compileResultJson = NEW Progress.Json.ObjectModel.JsonObject().
    DO i = 2 TO errorCount:
        errorMsg = ENTRY(i, compile_Result, {&ERROR_SEPARATOR}).
        IF errorMsg <> "" THEN
        DO :
            msgCount = NUM-ENTRIES (errorMsg, {&COMMAND_SEPARATOR}).
            compilerStatus = ENTRY(1, errorMsg, {&COMMAND_SEPARATOR}).
            messageCount = INTEGER (ENTRY(3, errorMsg, {&COMMAND_SEPARATOR})).
            IF messageCount > 0 THEN
                failed = TRUE.       
                
            errmsgJson = NEW Progress.Json.ObjectModel.JsonObject().
                
            msgCount = msgCount - 1.
            DO j = 4 TO msgCount:
                    
                msg = ENTRY(j, errorMsg, {&COMMAND_SEPARATOR}).
                    
                fileNme = ENTRY(1, msg, {&OPTION_SEPARATOR}).
                rw = ENTRY(2, msg, {&OPTION_SEPARATOR}).
                clm = ENTRY(3, msg, {&OPTION_SEPARATOR}).
                descrip = ENTRY(4, msg, {&OPTION_SEPARATOR}).
                num = ENTRY(5, msg, {&OPTION_SEPARATOR}).
                typ = ENTRY(6, msg, {&OPTION_SEPARATOR}).
                    
                msgJson = NEW Progress.Json.ObjectModel.JsonObject().
                msgJson:Add("fileName", fileNme).
                msgJson:Add("row", rw).
                msgJson:Add("column", clm).
                msgJson:Add("msg", descrip).
                msgJson:Add("number", num).
                msgJson:Add("type", typ).
                IF j = 4 THEN
                    msgjsonArrayString = "[".
                msgjsonArrayString = msgjsonArrayString + msgJson:GetJsonText().
                IF j <> msgCount AND msgJson:GetJsonText() <> "" THEN
                    msgjsonArrayString = msgjsonArrayString + ",".
                IF j = msgCount THEN
                    msgjsonArrayString = msgjsonArrayString + "]".
                    
                IF j <> msgCount THEN
                    DELETE OBJECT msgJson.
            END.
            errmsgJson:Add("compilerStatus", compilerStatus).
            errmsgJson:Add("className", ENTRY(2, errorMsg, {&COMMAND_SEPARATOR})).
            errmsgJson:Add("messageCount", ENTRY(3, errorMsg, {&COMMAND_SEPARATOR})).
            errmsgJson:Add("messages", msgjsonArrayString).
            IF i = 2 THEN
                errmsgjsonArrayString = "[".
            errmsgjsonArrayString = errmsgjsonArrayString + errmsgJson:GetJsonText().
            IF i <> errorCount AND errmsgJson:GetJsonText() <> "" THEN
                errmsgjsonArrayString = errmsgjsonArrayString + ",".
            IF i = errorCount THEN
                errmsgjsonArrayString = errmsgjsonArrayString + "]".
                    
            IF i <> errorCount THEN
                DELETE OBJECT errmsgJson.
        END.
    END.
    compileResultJson:Add("results", errmsgjsonArrayString).
    IF failed = TRUE THEN
        compileResultJson:Add("compile", "failed").
    ELSE
        compileResultJson:Add("compile", "success").
    compile_ResultAsJson = compileResultJson:GetJsonText().
        
    compile_ResultAsJson = REPLACE(compile_ResultAsJson, "~\~"", "~"").
    compile_ResultAsJson = REPLACE(compile_ResultAsJson, "~\~\~"", "~"").
    compile_ResultAsJson = REPLACE(compile_ResultAsJson, "~\~\", "~\").
    compile_ResultAsJson = REPLACE(compile_ResultAsJson, "~\~\", "~\").
    compile_ResultAsJson = REPLACE(compile_ResultAsJson, "~"[", "[").
    compile_ResultAsJson = REPLACE(compile_ResultAsJson, "]~"", "]").
                
END.

ELSE
DO:
    compileResultJson = NEW Progress.Json.ObjectModel.JsonObject().
    errmsgJson = NEW Progress.Json.ObjectModel.JsonObject().
    errmsgJson:Add("number", "0").
    errmsgJson:Add("text", "Problem occurred while compiling files on broker. The problem might be because of the following reasons: \n 1. The publish directory is not in the PROPATH of the broker. \n 2. Broker was not restarted after modification in the PROPATH entry.").
    errmsgJson:Add("source", "ABL").
    errmsgJson:Add("stack", "").
    compileResultJson:Add("error", errmsgJson).
    compile_ResultAsJson = compileResultJson:GetJsonText().
END.

RETURN compile_ResultAsJson.
        
END FUNCTION.
