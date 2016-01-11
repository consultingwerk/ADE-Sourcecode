/*********************************************************************
* Copyright (C) 2011 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: _ascompile.p

  Description: This file is used to compile an AppServer Content on server.

  Input Parameters:
      Name of the broker.
      CompileLst file name - compile options and file names to compile are mentioned.
      Json File name - where json result is written.

  Output Parameters:
      Compile results in json format.

  Author: Varun Tayal

  Created: 

------------------------------------------------------------------------*/

/* ************************* Included-Libraries *********************** */
{rmc/rmcutil.i}

DEFINE VARIABLE inValues           AS CHARACTER NO-UNDO.
DEFINE VARIABLE compileLstFileName AS CHARACTER NO-UNDO.
DEFINE VARIABLE brokerName         AS CHARACTER NO-UNDO.
DEFINE VARIABLE jsonFileName       AS CHARACTER NO-UNDO.
DEFINE VARIABLE compileResult      AS CHARACTER NO-UNDO.
DEFINE VARIABLE compileResultAsJson      AS CHARACTER NO-UNDO.
inValues = SESSION:PARAMETER.

DEFINE VARIABLE inCount AS INTEGER NO-UNDO.
inCount = NUM-ENTRIES (inValues).
IF inCount = 3 THEN
DO:
    brokerName = ENTRY(1, inValues).
    compileLstFileName = ENTRY(2, inValues).
    jsonFileName = ENTRY(3, inValues).
    OUTPUT TO value(jsonFileName). 
    DEFINE VARIABLE hAppSrv AS HANDLE NO-UNDO.
    CREATE SERVER hAppSrv.
    hAppSrv:CONNECT("-AppService " + brokerName).

    IF(hAppSrv:CONNECTED()) THEN
    DO:
        RUN rmc/compile_published_files.p ON hAppSrv (INPUT compileLstFileName, OUTPUT compileResult).
    END.
    hAppSrv:DISCONNECT().
    DELETE OBJECT hAppSrv.
    compileResultAsJson = convertToJson (compileResult).
    OS-DELETE VALUE(compileLstFileName).
    EXPORT compileResultAsJson.
    OUTPUT CLOSE.
END.
