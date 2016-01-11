/*********************************************************************
* Copyright (C) 2011 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: _runcompile.p

  Description: This file is running the COMPILE command on all files.

  Author: Varun Tayal

  Created: 

------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER cPrm AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER compileLstFileName AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER compileMessage    AS LONGCHAR NO-UNDO.

/*DEFINE SHARED VARIABLE XCodeKey       AS CHARACTER NO-UNDO INIT "".*/
DEFINE NEW SHARED VARIABLE RCodePath      AS CHARACTER NO-UNDO INIT "".
DEFINE NEW SHARED VARIABLE SourceFileFull AS CHARACTER NO-UNDO INIT "".

DEFINE NEW SHARED STREAM WEBSTREAM.  /** Allow WebSpeed compile */
DEFINE STREAM CMPLSTREAM.
DEFINE STREAM s1.


DEFINE VARIABLE c1               AS CHARACTER NO-UNDO.

/** Compile variables **/
DEFINE VARIABLE PublishDirectory AS CHARACTER NO-UNDO INIT "".
DEFINE VARIABLE cNewfile         AS CHARACTER NO-UNDO INIT "".
DEFINE VARIABLE SourceFile       AS CHARACTER NO-UNDO INIT "".
DEFINE VARIABLE cSpeedfile       AS CHARACTER NO-UNDO INIT "".
DEFINE VARIABLE SaveRCode        AS LOGICAL   NO-UNDO INIT FALSE.
DEFINE VARIABLE CompileTempFile  AS CHARACTER NO-UNDO INIT "". 

DEFINE VARIABLE lHTMLMapped      AS LOGICAL   NO-UNDO INIT FALSE.

&GLOBAL-DEFINE COMMAND_SEPARATOR CHR(3)
&GLOBAL-DEFINE OPTION_SEPARATOR CHR(4)
&GLOBAL-DEFINE ERROR_SEPARATOR CHR(5)


RUN separateOptions.
 
SourceFileFull = SourceFile.

CompileTempFile = PublishDirectory + "/../compile_tmp_" + REPLACE(compileLstFileName, ".lst", "") + ".p".

IF SourceFile MATCHES "*~~.html" OR SourceFile MATCHES "*~~.htm" THEN
DO:
    DEFINE VARIABLE idx AS INTEGER NO-UNDO.

    idx = R-INDEX(SourceFile, ".").
    ASSIGN
        cNewfile = SUBSTRING(SourceFile, 1, idx) + "w".

    FILE-INFO:FILE-NAME = cNewfile.
    IF FILE-INFO:FULL-PATHNAME > "" THEN
        lHTMLMapped = TRUE.
    ELSE
        lHTMLMapped = FALSE.

    IF NOT lHTMLmapped THEN
    DO:
        idx = R-INDEX(SourceFileFull, ".").
        ASSIGN
            cNewfile = SUBSTRING(SourceFileFull, 1, idx) + "w".
    END.

    IF NOT lHTMLMapped THEN
    DO:
        RUN webutil/e4gl-gen.r (INPUT SourceFileFull,
            INPUT-OUTPUT cSpeedFile,
            INPUT-OUTPUT cNewfile).
    END.
    
    ASSIGN
        SourceFileFull = cNewfile.
END.

IF SaveRCode THEN 
DO:
    IF RCodePath <> "" THEN
    DO:
        COMPILE VALUE(SourceFileFull) SAVE INTO VALUE(RCodePath) NO-ERROR.
    END.
    ELSE
    DO:
        COMPILE VALUE(SourceFileFull) SAVE NO-ERROR.
    END.
END.
ELSE
DO:
    COMPILE VALUE(SourceFileFull) NO-ERROR.
END.

RUN parseErrors( OUTPUT compileMessage).

/* cleanup */
IF ((SourceFile MATCHES "*~~.html" OR SourceFile MATCHES "*~~.htm") AND NOT lHTMLMapped) THEN
DO:
    OS-DELETE VALUE(SourceFileFull).
    OS-DELETE VALUE(SEARCH(compileLstFileName)).
END.
compileMessage = {&ERROR_SEPARATOR} + compileMessage. 
RETURN.
/*
  this section initializes all the variables needed by the compile statement generator
  it is the responsability of this section to make sure all paths use forward-slashes ("/")

*/
PROCEDURE separateOptions.

    DEFINE VARIABLE i           AS INTEGER   NO-UNDO.
    
    DEFINE VARIABLE OptionCount AS INTEGER   NO-UNDO.
    DEFINE VARIABLE cOption     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE optName     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE optValue    AS CHARACTER NO-UNDO.
    
    OptionCount = NUM-ENTRIES(cPrm,  {&COMMAND_SEPARATOR}).
    /*
        Should we reset to Unknown. If so we need to use. Whose responsibility to 
        reset this?
    */
    SECURITY-POLICY:XCODE-SESSION-KEY  =  ?.    
    DO i = 1 TO OptionCount:
        cOption = ENTRY(i, cPrm, {&COMMAND_SEPARATOR}).
        OptName = ENTRY(1, cOption, {&OPTION_SEPARATOR}).
        optValue = ENTRY(2, cOption, {&OPTION_SEPARATOR}).
        optValue = REPLACE(optValue, "~\", "/").
        CASE optName:
            WHEN "PUBLISHDIRECTORY" THEN 
                DO:    
                    PublishDirectory = SUBSTRING (SEARCH(compileLstFileName), 1, INDEX (SEARCH(compileLstFileName), compileLstFileName) - 1).
                END.
            WHEN "FILE" THEN
                SourceFile = OptValue.
                
            /*            WHEN "XCODEKEY" THEN    */
            /*                XCodeKey = optValue.*/
               
            WHEN "XCODESESSIONKEY" THEN 
            RUN VALUE(REPLACE(optValue, "~\", "/")).
            WHEN "SAVEINTO" THEN 
                DO:
                    IF OptValue <> "" THEN 
                    DO:
                        RCodePath = SUBSTRING (SEARCH(compileLstFileName), 1, INDEX (SEARCH(compileLstFileName), compileLstFileName) - 1).
                    END.
                END.
            WHEN "SAVE" THEN 
                DO:
                    IF optValue = "true" THEN
                        SaveRCode = TRUE.           
                END.
        END CASE.
    END.
END PROCEDURE.

&scoped-define COMPILE_OK  0
&scoped-define COMPILE_WARNING 1
&scoped-define COMPILE_ERROR 2
&scoped-define COMPILE_FAILURE 4
&scoped-define COMPILE_STOPPED 8
&scoped-define COMPILE_MESSAGES 16

/*
 This reads the error messages from the compiler handle if there are any
and then puts them along with the line number and file name where the error
occured into a format that can be read by OE Architect.  This only works with
10.1B and forward.
*/
PROCEDURE parseErrors.

    DEFINE OUTPUT PARAMETER compileMessage AS LONGCHAR NO-UNDO.

    DEFINE VARIABLE i                AS INTEGER   NO-UNDO.
    DEFINE VARIABLE messageCount     AS INTEGER   NO-UNDO.
    DEFINE VARIABLE msg              AS CHARACTER NO-UNDO.
    DEFINE VARIABLE msgNumber        AS INTEGER   NO-UNDO.
    DEFINE VARIABLE msgRow           AS INTEGER   NO-UNDO.
    DEFINE VARIABLE fileName         AS CHARACTER NO-UNDO.
    DEFINE VARIABLE msgType          AS INTEGER   NO-UNDO.
    DEFINE VARIABLE msgColumn        AS INTEGER   NO-UNDO.
    
    DEFINE VARIABLE compilerState    AS INTEGER   NO-UNDO.
    DEFINE VARIABLE compilerMessages AS LONGCHAR  NO-UNDO.
    
    IF COMPILER:WARNING THEN
        compilerState = compilerState + {&COMPILE_WARNING}.
    
    IF COMPILER:ERROR THEN
        compilerState = compilerState + {&COMPILE_ERROR}.
        
    IF ERROR-STATUS:ERROR THEN
        compilerState = compilerState + {&COMPILE_FAILURE}.
        
    IF COMPILER:STOPPED THEN
        compilerState = compilerState + {&COMPILE_STOPPED}.
    
    IF COMPILER:NUM-MESSAGES > 0 THEN 
    DO:
        ASSIGN 
            messageCount  = COMPILER:NUM-MESSAGES
            compilerState = compilerState + {&COMPILE_MESSAGES}.
        
        DO i = 1 TO messageCount:
            ASSIGN 
                msg       = COMPILER:GET-MESSAGE(i)
                msgNumber = COMPILER:GET-NUMBER(i)
                msgRow    = COMPILER:GET-ROW(i)
                msgColumn = COMPILER:GET-COLUMN(i)
                fileName  = COMPILER:GET-FILE-NAME(i)
                msgType   = COMPILER:GET-MESSAGE-TYPE(i).
            IF msgRow = ? THEN
                msgRow = 0.
            IF msgNumber = ? THEN
                msgNumber = 0.
            IF fileName = ? THEN
                fileName = SourceFile.
            IF msgColumn = ? THEN
                msgColumn = 0.
            compilerMessages = compilerMessages + fileName + {&OPTION_SEPARATOR} + string(msgRow) + {&OPTION_SEPARATOR} + string(msgColumn) + {&OPTION_SEPARATOR}+ msg + {&OPTION_SEPARATOR} + string(msgNumber) + {&OPTION_SEPARATOR} + string(msgType) + {&COMMAND_SEPARATOR}.
        END.
    END.
    ELSE 
    DO:
        /* this handles errors with the execution of the compile statement itself as opposed to problems with the code */
        /* things like a missing "save into" directory would fall into this category */
        ASSIGN
            messageCount = ERROR-STATUS:NUM-MESSAGES.
        DO i = 1 TO messageCount:
            msgRow = COMPILER:ERROR-ROW.
            msgColumn = COMPILER:ERROR-COLUMN.
            IF msgRow = ? THEN
                msgRow = 0.
            IF msgColumn = ? THEN
                msgColumn = 0.
            msgNumber = ERROR-STATUS:GET-NUMBER(i).
            msg = ERROR-STATUS:GET-MESSAGE(i).
            msgType = -1. /* -1 indicates unknown type, the java side will determine the severity based on if the compile failed or succeed */
            
            compilerMessages = compilerMessages + SourceFile + {&OPTION_SEPARATOR} + string(msgRow) + {&OPTION_SEPARATOR} + string(msgColumn) + {&OPTION_SEPARATOR} + msg + {&OPTION_SEPARATOR} + string(msgNumber) + {&OPTION_SEPARATOR} + string(msgType) + {&COMMAND_SEPARATOR}.
        END.
    END.

    compileMessage = STRING(compilerState) + {&COMMAND_SEPARATOR} + COMPILER:CLASS-TYPE + {&COMMAND_SEPARATOR} + string(messageCount) + {&COMMAND_SEPARATOR} + compilerMessages.

END PROCEDURE.