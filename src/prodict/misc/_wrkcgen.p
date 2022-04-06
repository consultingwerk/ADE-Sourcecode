/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*
This program generates a COPY assignment for copying the contents of
one buffer to another.


HISTORY:

tomn        12/05/95    Added spacing to frame "working" to fix 4041 
                        errors on intl windows platforms  
D. McMann   09/08/00    Added owner to find statement     
D. McMann   03/05/03    Excluded LOB fields from being outputted.                    

*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

DEFINE VARIABLE i    AS INTEGER           NO-UNDO.
DEFINE VARIABLE lin  AS CHARACTER         NO-UNDO.
DEFINE VARIABLE mlen AS INTEGER INITIAL 1 NO-UNDO.
DEFINE VARIABLE mstr AS CHARACTER         NO-UNDO.
DEFINE VARIABLE maxlin AS INTEGER INITIAL 0 NO-UNDO.
DEFINE STREAM code.

FORM
  SKIP(1)
  _Field._Field-name LABEL "Working on Field" AT 3
  SKIP(1)
  WITH FRAME working
  WIDTH 58 SIDE-LABELS ROW 5 CENTERED &IF "{&WINDOW-SYSTEM}" <> "TTY"
  &THEN VIEW-AS DIALOG-BOX THREE-D &ENDIF
  TITLE "Generate ASSIGN Statement".
  
COLOR DISPLAY MESSAGES _Field._Field-name WITH FRAME working.

SESSION:IMMEDIATE-DISPLAY = yes.
PAUSE 0.
OUTPUT STREAM code TO VALUE(user_env[1]) NO-ECHO NO-MAP.
PUT STREAM code UNFORMATTED 
 "/* " STRING(TODAY,"99/99/99") " COPY assignment */" SKIP(1)
  "DO:" SKIP.
PUT STREAM code UNFORMATTED SPACE(2) "ASSIGN".

FIND _File WHERE _File._Db-recid = drec_db AND _File._File-name = user_filename
             AND (_File._Owner = "PUB" OR _file._Owner = "_FOREIGN") .

FOR EACH _Field OF _File:
  mlen = MAXIMUM(mlen,LENGTH(_Field._Field-name)
       + (IF _Extent = 0 THEN 0 ELSE 2 + LENGTH(STRING(_Extent)))).
END.
mstr = "x(" + STRING(mlen) + ")".
FOR EACH _Field OF _File WHERE _Field._Data-type <> "BLOB"
                           AND _Field._Data-type <> "CLOB"
                           AND _Field._Data-type <> "XLOB"
                           BY _Field._Order:
  IF TERMINAL <> "" THEN
    DISPLAY _Field._Field-name WITH FRAME working.

  DO i = MINIMUM(1,_Extent) TO _Extent:
    lin = _Field-name
        + (IF _Extent = 0 THEN "" ELSE "["
        + STRING(i,FILL("Z",LENGTH(STRING(_Extent)))) + "]").
    PUT STREAM code UNFORMATTED
      SKIP SPACE(2) "  ~{1~}." STRING(lin,mstr) " = ~{2~}." lin.
    maxlin = maxlin + 1.
    IF maxlin = 20 THEN DO:
      PUT STREAM code UNFORMATTED "." SKIP(1).
      PUT STREAM code UNFORMATTED SPACE(2) "ASSIGN".
      maxlin = 0.
     END.
  END.

END.
PUT STREAM code UNFORMATTED "." SKIP.
PUT STREAM code UNFORMATTED "END.".
OUTPUT STREAM code CLOSE.

HIDE FRAME working NO-PAUSE.
SESSION:IMMEDIATE-DISPLAY = no.
MESSAGE "Output Completed" VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
RETURN.
