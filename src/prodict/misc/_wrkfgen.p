/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* This program generates explicit FRAME definitions from file
definitions in the database.  These frame definitions can then
be customized.

This is especially useful if the default frame for a file won't
fit completely on the screen.  This program allows you to make
a form statement up that matches the default frame, and then you
can remove the fields that are not necessary.

HISTORY:

tomn        12/05/95    Added spacing to frame "working" to fix 4041 
                        errors on intl windows platforms  
                        
mcmann      03/05/03    Excluded LOB fields                       

*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

DEFINE VARIABLE fa   AS LOGICAL           NO-UNDO.
DEFINE VARIABLE fs   AS CHARACTER         NO-UNDO.
DEFINE VARIABLE ft   AS CHARACTER         NO-UNDO.
DEFINE VARIABLE i    AS INTEGER           NO-UNDO.
DEFINE VARIABLE lb   AS CHARACTER         NO-UNDO.
DEFINE VARIABLE lin  AS CHARACTER         NO-UNDO.
DEFINE VARIABLE lp   AS CHARACTER         NO-UNDO.
DEFINE VARIABLE qs   AS LOGICAL           NO-UNDO.
DEFINE STREAM code.

FORM
  SKIP(1)
  _Field._Field-name LABEL "Working on Field" AT 3
  SKIP(1)
  WITH FRAME working 
  WIDTH 58 SIDE-LABELS ROW 5 CENTERED &IF "{&WINDOW-SYSTEM}" <> "TTY"
  &THEN VIEW-AS DIALOG-BOX THREE-D &ENDIF
  TITLE "Generate FORM Statement".
  
COLOR DISPLAY MESSAGES _Field._Field-name WITH FRAME working.

SESSION:IMMEDIATE-DISPLAY = yes.

ASSIGN
    /* user_env[1] */    /* output file name */
    /* user_env[2] */    /* fully quality */
  fa = user_env[3] = "Y" /* expand arrays */
    /* user_env[4] */    /* format */
    /* user_env[5] */    /* validation */
    /* user_env[6] */    /* labeling */
  fs = user_env[7].      /* columns */
  ft = user_env[8].      /* overlay */

FIND _File WHERE _File._Db-recid = drec_db AND _File._File-name = user_filename.

qs = NOT (fs BEGINS "T" OR fs BEGINS "N").
IF fs BEGINS "N" THEN qs = ?.

PAUSE 0.
OUTPUT STREAM code TO VALUE(user_env[1]) NO-ECHO NO-MAP.
PUT STREAM code UNFORMATTED
  "/* " STRING(TODAY,"99/99/99") " FORM LIKE table"
    " " _File._File-name " */" SKIP(1)
  "FORM".

FOR EACH _Field OF _File WHERE _Field._Data-type <> "BLOB"
                           AND _Field._Data-type <> "CLOB"
                           AND _Field._Data-type <> "XLOB"
                           BY _Order:
  IF TERMINAL <> "" THEN
    DISPLAY _Field._Field-name WITH FRAME working.
  lb = "".

  IF user_env[4] = "Y" THEN DO:
    lp = "".
    DO i = 1 TO LENGTH(_Format):
      lp = lp + SUBSTRING(_Format,i,1)
         + (IF SUBSTRING(_Format,i,1) = "~"" THEN "~"" ELSE "").
    END.
    lb = lb + " FORMAT ~"" + lp + "~"".
  END.

  IF user_env[6] BEGINS "E" THEN DO:
    IF ((qs) OR (NOT qs AND _Col-label = ?)) AND _Label <> ? THEN DO:
      lp = "".
      DO i = 1 TO LENGTH(_Label):
        lp = lp + SUBSTRING(_Label,i,1)
           + (IF SUBSTRING(_Label,i,1) = "~"" THEN "~"" ELSE "").
      END.
      lb = lb + " LABEL ~"" + lp + "~"".
    END.
    IF NOT qs AND _Col-label <> ? THEN DO:
      lp = "".
      DO i = 1 TO LENGTH(_Col-label):
        lp = lp + SUBSTRING(_Col-label,i,1)
           + (IF SUBSTRING(_Col-label,i,1) = "~"" THEN "~"" ELSE "").
      END.
      lb = lb + " COLUMN-LABEL ~"" + lp + "~"".
    END.
  END.

  IF user_env[5] BEGINS "E" AND _Field._Valexp <> ? THEN DO:
    lp = "".
    DO i = 1 TO LENGTH(_Field._Valmsg):
      lp = lp + SUBSTRING(_Field._Valmsg,i,1)
         + (IF SUBSTRING(_Field._Valmsg,i,1) = "~"" THEN "~"" ELSE "").
    END.
    lb = lb + " VALIDATE(" + _Field._Valexp + ",~"" + lp + "~")".
  END.

  DO i = 1 TO (IF _Extent > 0 AND fa THEN _Extent ELSE 1):
    lin = "  "
       + (IF user_env[2] = "Y" THEN _File._File-name + "." ELSE "")
       + _Field-name
       + (IF _Extent = 0 THEN "" ELSE "["
           + (IF fa THEN STRING(i) ELSE "1 FOR " + STRING(_Extent))
           + "]")
       + lb.
    DO WHILE ASC(SUBSTRING(lin,LENGTH(lin),1)) = 32:
      lin = SUBSTRING(lin,1,LENGTH(lin) - 1).
    END.
    PUT STREAM code UNFORMATTED SKIP lin.
  END.
END.

PUT STREAM code UNFORMATTED SKIP "  WITH FRAME " + LC(_File._File-name).

IF      ft BEGINS "O" THEN PUT STREAM code UNFORMATTED " OVERLAY".
ELSE IF ft BEGINS "T" THEN PUT STREAM code UNFORMATTED " TOP-ONLY".

IF NOT user_env[5] BEGINS "D" AND NOT user_env[5] BEGINS "E" THEN
  PUT STREAM code UNFORMATTED " NO-VALIDATE".

IF          fs BEGINS "N" THEN PUT STREAM code UNFORMATTED " NO-LABELS".
ELSE IF     fs BEGINS "S" THEN PUT STREAM code UNFORMATTED " SIDE-LABELS".
ELSE IF NOT fs BEGINS "T" THEN PUT STREAM code UNFORMATTED " " fs " COLUMNS".

IF ft BEGINS "D" THEN PUT STREAM code UNFORMATTED " VIEW-AS DIALOG-BOX".

PUT STREAM code UNFORMATTED "." SKIP.
OUTPUT STREAM code CLOSE.

HIDE FRAME working NO-PAUSE.
SESSION:IMMEDIATE-DISPLAY = no.
MESSAGE "Output Completed" VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
RETURN.
