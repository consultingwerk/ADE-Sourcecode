/*********************************************************************
* Copyright (C) 2000-2015 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* _dctlrec.p - create .d of unloadable records from another .d & error .e */

{ prodict/user/uservar.i }
{ prodict/dictvar.i }

DEFINE STREAM dot-d.
DEFINE STREAM dot-e.
DEFINE STREAM third.

DEFINE VARIABLE c	AS CHARACTER NO-UNDO.
DEFINE VARIABLE d-lin	AS INTEGER   NO-UNDO.
DEFINE VARIABLE d-txt	AS CHARACTER NO-UNDO.
DEFINE VARIABLE e-cnt	AS INTEGER   NO-UNDO.
DEFINE VARIABLE e-lin	AS INTEGER   NO-UNDO.
DEFINE VARIABLE e-ofs	AS INT64   NO-UNDO.
DEFINE VARIABLE e-txt	AS CHARACTER NO-UNDO.
DEFINE VARIABLE siz	AS INTEGER   NO-UNDO.
DEFINE VARIABLE tmpfile AS CHARACTER NO-UNDO.

FORM
  e-cnt LABEL "Working on error number" COLON 25 SKIP
  e-lin LABEL "For line number"         COLON 25 SKIP
  WITH FRAME working 
  ROW 5 CENTERED ATTR-SPACE SIDE-LABELS USE-TEXT &IF "{&WINDOW-SYSTEM}"
  <> "TTY" &THEN VIEW-AS DIALOG-BOX THREE-D
  TITLE "Reconstruct Bad Load Records" &ENDIF.

COLOR DISPLAY MESSAGES e-cnt e-lin WITH FRAME working.

SESSION:IMMEDIATE-DISPLAY = yes.

IF OPSYS = "UNIX" OR OPSYS = "OS2" THEN
  INPUT STREAM dot-e THROUGH quoter VALUE(user_env[2]) NO-ECHO.
ELSE DO:
  RUN "adecomm/_tmpfile.p" (INPUT "", INPUT ".adm", OUTPUT tmpfile).
  RUN "prodict/misc/osquoter.p" (user_env[2],?,?,tmpfile).
  INPUT STREAM dot-e FROM VALUE(tmpfile) NO-ECHO.
END.

INPUT  STREAM dot-d FROM VALUE(user_env[1]) NO-ECHO.
OUTPUT STREAM third TO   VALUE(user_env[3]) NO-ECHO.

PAUSE 0.
run adecomm/_setcurs.p ("WAIT").
VIEW FRAME working.

REPEAT:
  IMPORT STREAM dot-e e-txt.
  IF NOT e-txt BEGINS ">>" THEN NEXT.

  ASSIGN
    c     = SUBSTRING(e-txt,INDEX(e-txt,"#") + 1)
    e-lin = INTEGER(SUBSTRING(c,1,INDEX(c," ") - 1))
    c     = SUBSTRING(e-txt,INDEX(e-txt,"=") + 1)
    e-ofs = INT64(SUBSTRING(c,1,INDEX(c,")") - 1))
    e-cnt = e-cnt + 1
    d-txt = "".

  DISPLAY e-cnt e-lin WITH FRAME working.
  SEEK STREAM dot-d TO e-ofs.
  IMPORT STREAM dot-d UNFORMATTED d-txt.
  PUT STREAM third UNFORMATTED d-txt SKIP.

END.

INPUT  STREAM dot-d CLOSE.
INPUT  STREAM dot-e CLOSE.
OUTPUT STREAM third CLOSE.
IF OPSYS <> "UNIX" AND OPSYS <> "OS2" THEN OS-DELETE VALUE(tmpfile).
run adecomm/_setcurs.p ("").

MESSAGE "Reconstruction completed" VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
HIDE FRAME working NO-PAUSE.
SESSION:IMMEDIATE-DISPLAY = no.

user_env[4] = STRING(e-cnt).
RETURN.
