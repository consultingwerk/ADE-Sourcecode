/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*-----------------------------------------------------------------------------

  File: _runard.p

  Description: Runs e.Report Designer.

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Gerry Seidl

  Modified on 
     05/04/99 by gfs - Created
     01/06/00 by gfs - Changed to create a .bat file defining PROGRESS env vars
 *---------------------------------------------------------------------------*/
DEFINE VARIABLE locard   AS CHARACTER NO-UNDO.
DEFINE VARIABLE DLCValue AS CHARACTER NO-UNDO.

GET-KEY-VALUE SECTION "Startup":U KEY "DLC":U VALUE DLCValue.
IF DLCValue = ? THEN DLCValue = OS-GETENV("DLC":U).

RUN adecomm/_locard.p(OUTPUT locard).
IF locard <> ? THEN DO:
    OUTPUT TO ard.bat.
      PUT UNFORMATTED "@echo off":U SKIP.
      PUT UNFORMATTED "set DLC=":U + DLCValue SKIP.
      PUT UNFORMATTED "set PROMSGS=":U + DLCValue + "~\promsgs":U SKIP.
      PUT UNFORMATTED "set PROCFG=":U + DLCValue + "~\progress.cfg":U SKIP.
      PUT UNFORMATTED "path=":U + DLCValue + "~\bin;":U + DLCValue + ";%path%":U SKIP.
      PUT UNFORMATTED FILE-INFO:FULL-PATHNAME SKIP.
    OUTPUT CLOSE.

    /* Execute the batch file */
    OS-COMMAND NO-WAIT VALUE("ard.bat":U).
END.
RETURN.
