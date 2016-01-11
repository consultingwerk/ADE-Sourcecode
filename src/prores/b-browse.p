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
/* b-browse.p - show compile failures */

{ prores/s-system.i }
{ prores/t-define.i }

DEFINE INPUT PARAMETER qbf-b AS LOGICAL NO-UNDO.
/* qbf-b = TRUE for *build* or FALSE for *rebuild* */

DEFINE VARIABLE qbf-c AS CHARACTER         NO-UNDO.
DEFINE VARIABLE qbf-s AS INTEGER INITIAL 0 NO-UNDO.

{ prores/t-set.i &mod=b &set=1 }
RUN prores/s-error.p ("#32").
/*
Errors were found during the build and/or compile stages.
^^Press a key to see the query log file.  Lines
containing errors will be hilighted.
*/
{ prores/t-reset.i }

/*qbf-p = "phase= " + (IF qbf-b THEN "" ELSE "re") + "compile".*/

RUN prores/s-quoter.p
  (SEARCH(qbf-qcfile + ".ql"),qbf-tempdir + "1.d").

IF NOT qbf-b THEN DO:
  INPUT FROM VALUE(qbf-tempdir + "1.d") NO-ECHO.
  /* find [last] occurrence of phase= [re]compile */
  REPEAT:
    IMPORT qbf-c.
    IF qbf-c MATCHES "phase= *compile" THEN qbf-s = SEEK(INPUT).
  END.
  INPUT CLOSE.
END.

RUN prores/s-page.p (qbf-tempdir + "1.d",qbf-s,TRUE).

RETURN.
