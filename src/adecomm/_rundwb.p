/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*-----------------------------------------------------------------------------

  File: _rundwb.p

  Description: Runs Actuate Developer Workbench.

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Gerry Seidl

  Modified on 
     05/04/99 by gfs - Created
     01/06/00 by gfs - Changed to create a .bat file defining PROGRESS env vars
 *---------------------------------------------------------------------------*/
DEFINE VARIABLE locdwb   AS CHARACTER NO-UNDO.
DEFINE VARIABLE DLCValue AS CHARACTER NO-UNDO.

GET-KEY-VALUE SECTION "Startup":U KEY "DLC":U VALUE DLCValue.
IF DLCValue = ? THEN DLCValue = OS-GETENV("DLC":U).

RUN adecomm/_locdwb.p(OUTPUT locdwb).
IF locdwb <> ? THEN DO:
    OUTPUT TO dwb.bat.
      PUT UNFORMATTED "@echo off":U SKIP.
      PUT UNFORMATTED "set DLC=":U + DLCValue SKIP.
      PUT UNFORMATTED "set PROMSGS=":U + DLCValue + "~\promsgs":U SKIP.
      PUT UNFORMATTED "set PROCFG=":U + DLCValue + "~\progress.cfg":U SKIP.
      PUT UNFORMATTED "path=":U + DLCValue + "~\bin;":U + DLCValue + ";%path%":U SKIP.
      PUT UNFORMATTED FILE-INFO:FULL-PATHNAME SKIP.
    OUTPUT CLOSE.

    /* Execute the batch file */
    OS-COMMAND NO-WAIT VALUE("dwb.bat":U).
END.
RETURN.
