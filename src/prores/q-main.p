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
/* q-main.p - Query module main procedure */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/t-define.i }
{ prores/q-define.i NEW NEW }
{ prores/c-form.i }
{ prores/t-set.i &mod=q &set=1 }

DEFINE VARIABLE qbf-a AS LOGICAL   NO-UNDO.
DEFINE VARIABLE qbf-c AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-h AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-l AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-o AS CHARACTER NO-UNDO.

/*message "[q-main.p]" view-as alert-box.*/

IF qbf-form# = 0 THEN
  /* There are no query forms currently defined. */
  RUN prores/s-error.p ("#15").
ELSE
IF qbf-file[1] = "" THEN DO WITH FRAME qbf-query:
  FORM qbf-c FORMAT "x(76)"
    WITH DOWN NO-LABELS ATTR-SPACE OVERLAY
    TITLE COLOR NORMAL " " + qbf-lang[16] + " ". /* Query */
  DISPLAY qbf-c. /* this gets frame-line initialized */
  DOWN FRAME-DOWN - 1.
  /* Please select the name of the Query form to use. */
  DISPLAY qbf-lang[17] @ qbf-c.
  COLOR DISPLAY MESSAGES qbf-c.
  /* Press [GO] or [RETURN] to select a form, or [END-ERROR] to exit. */
  STATUS DEFAULT qbf-lang[18].
END.
ELSE
  qbf-o = "*" + qbf-db[1] + "." + qbf-file[1].
RUN prores/c-form.p ("r004c014",INPUT-OUTPUT qbf-o).
STATUS DEFAULT.
HIDE FRAME qbf-query NO-PAUSE.
IF qbf-o = "" THEN qbf-module = ?.

qbf-h = 0.
IF qbf-module <> ? THEN
  DO qbf-i = 1 TO 5 WHILE qbf-file[qbf-i] <> "" AND qbf-h = 0:
    IF INDEX(qbf-where[qbf-i],"~{~{") > 0 THEN qbf-h = qbf-i.
  END.
IF qbf-h > 0 THEN DO:
  qbf-a = FALSE.
  RUN prores/s-box.p (INPUT-OUTPUT qbf-a,?,?,"#21").
  IF NOT qbf-a THEN
    qbf-module = ?.
  ELSE
  DO qbf-i = 1 TO 5:
    IF INDEX(qbf-where[qbf-i],"~{~{") > 0 THEN qbf-where[qbf-i] = "".
  END.
  /* There is a WHERE clause for the current query which contains values 
     that are asked for at RUN-TIME.  This is not supported in the Query 
     module.  Ignore WHERE clauses and continue? */
END.

DO WHILE qbf-module = "q":
  IF SEARCH(ENTRY(2,qbf-o) + ".r") = ? THEN DO:
    qbf-a = FALSE.
    RUN prores/s-box.p (INPUT-OUTPUT qbf-a,?,?,"#20").
    IF NOT qbf-a THEN DO:
      qbf-module = ?.
      NEXT.
    END.
    /* The compiled query form is missing for this procedure.  The problem 
       may be 1) incorrect PROPATH, 2) missing query .r file, or 3) 
       uncompiled .r file. (Check the <dbname>.ql file for compiler error 
       messages). You may try to continue, but this may result in an error 
       message. Do you want to attempt to continue? */
  END.
  MESSAGE qbf-lang[19].  /* Loading query form... */

  ASSIGN
    qbf-order    = ""
    qbf-db[1]    = SUBSTRING(ENTRY(1,qbf-o),1,INDEX(ENTRY(1,qbf-o),".") - 1)
    qbf-file[1]  = SUBSTRING(ENTRY(1,qbf-o),INDEX(ENTRY(1,qbf-o),".") + 1)
    qbf-query[1] = (IF qbf-where[1] = "" THEN ? ELSE FALSE).
  CREATE ALIAS "QBF$0" FOR DATABASE VALUE(SDBNAME(qbf-db[1])).
  OUTPUT TO VALUE(qbf-tempdir + "1.d") NO-ECHO.
  PUT UNFORMATTED "-" SKIP "-" SKIP.
  OUTPUT CLOSE.

  RUN VALUE(ENTRY(2,qbf-o) + ".p").

  IF qbf-module BEGINS "q:" THEN
    ASSIGN
      qbf-o      = SUBSTRING(qbf-module,3)
      qbf-module = "q".
END.

IF qbf-module <> "q" THEN DO:
  PUT SCREEN ROW 1 COLUMN 1 FILL(" ",79).
  PUT SCREEN ROW 2 COLUMN 1 FILL(" ",79).
  PUT SCREEN ROW SCREEN-LINES + MESSAGE-LINES + 1 COLUMN 1 FILL(" ",63).
END.

IF qbf-module <> ? THEN
  /* if no fields selected, then copy browse fields into report columns */
  RUN prores/r-file.p (?).

{ prores/t-reset.i }
RETURN.

/* q-main.p - end of file */

