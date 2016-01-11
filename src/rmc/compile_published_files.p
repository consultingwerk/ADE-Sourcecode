/*********************************************************************
* Copyright (C) 2011 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: compile_published_files.p

  Description: This file internally calls _runcompile.p to fire Compile command.

  Author: Varun Tayal

  Created: 

------------------------------------------------------------------------*/


DEFINE STREAM compileLst.

DEFINE INPUT  PARAMETER compileLstFileName      AS CHARACTER    NO-UNDO.
DEFINE OUTPUT PARAMETER compileResult           AS CHARACTER    NO-UNDO.
DEFINE VARIABLE compileLstLocation AS CHARACTER NO-UNDO.

DEFINE VARIABLE txtLine            AS CHARACTER NO-UNDO.
DEFINE VARIABLE compileOptions     AS CHARACTER NO-UNDO.
DEFINE VARIABLE userCompileOptions AS CHARACTER NO-UNDO.
DEFINE VARIABLE fileToCompile      AS CHARACTER NO-UNDO.
DEFINE VARIABLE publishDirectory   AS CHARACTER NO-UNDO.
DEFINE VARIABLE compileMessage     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCurrDir           AS CHARACTER NO-UNDO.

&GLOBAL-DEFINE COMMAND_SEPARATOR CHR(3)
&GLOBAL-DEFINE OPTION_SEPARATOR CHR(4)

/* Find working directory START*/
ASSIGN 
    FILE-INFO:FILE-NAME = ".":U    
    cCurrDir            = FILE-INFO:FULL-PATHNAME.
IF SUBSTRING(cCurrDir, LENGTH(cCurrDir), 1) = ".":U THEN
    ASSIGN cCurrDir = SUBSTRING(cCurrDir, 1, LENGTH(cCurrDir) - 1).
IF SUBSTRING(cCurrDir, LENGTH(cCurrDir), 1) NE "/":U AND
    SUBSTRING(cCurrDir, LENGTH(cCurrDir), 1) NE "~\":U THEN
    ASSIGN cCurrDir = cCurrDir + "/":U.
/* Find working directory END*/
        
compileLstLocation = SEARCH(compileLstFileName).
compileLstLocation = REPLACE(compileLstLocation, "~\", "/").
IF compileLstLocation BEGINS "./" THEN 
DO:
    compileLstLocation = SUBSTRING (compileLstLocation, 3).
    compileLstLocation = cCurrDir + compileLstLocation.
    compileLstLocation = REPLACE(compileLstLocation, "~\", "/").
END.
IF(compileLstLocation <> ?) THEN 
DO:

    INPUT stream compileLst from value(compileLstLocation) NO-ECHO.
    REPEAT:
        IMPORT STREAM compileLst UNFORMATTED txtLine.
        IF txtLine BEGINS "CompileOptions=" THEN 
        DO:
            userCompileOptions = SUBSTRING (txtLine, LENGTH ("CompileOptions=")).
        END.
        IF NOT txtLine BEGINS "CompileOptions=" AND txtLine <> "" THEN
        DO:
            fileToCompile = SEARCH (txtLine).
            fileToCompile = REPLACE(fileToCompile, "~\", "/").
            IF fileToCompile BEGINS "./" THEN 
            DO:
                fileToCompile = SUBSTRING (fileToCompile, 3).
                fileToCompile = cCurrDir + fileToCompile.
                fileToCompile = REPLACE(fileToCompile, "~\", "/").
            END.
            IF(fileToCompile <> ?) THEN 
            DO:
                compileOptions =             "PUBLISHDIRECTORY" + {&OPTION_SEPARATOR} + "" 
                    + {&COMMAND_SEPARATOR} + "FILE"             + {&OPTION_SEPARATOR} + fileToCompile 
                    + {&COMMAND_SEPARATOR} + "SAVE"             + {&OPTION_SEPARATOR} + "true" 
                    + {&COMMAND_SEPARATOR} + "SAVEINTO"         + {&OPTION_SEPARATOR} + "".
                RUN rmc/_runcompile.p (INPUT compileOptions, INPUT compileLstFileName, OUTPUT compileMessage).
                compileResult = compileResult + compileMessage.
            END.
        END.
    END.
END.
ELSE IF (compileLstLocation = ?) THEN
DO:
    compileResult = "ERROR:Compile List File Location not found.".
END.
RETURN.