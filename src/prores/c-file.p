/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* c-file.p - scrolling list of files or join candidates */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/t-define.i }
{ prores/c-form.i }
{ prores/c-merge.i }
{ prores/reswidg.i }
{ prores/resfunc.i }

DEFINE INPUT  PARAMETER qbf-f AS CHARACTER NO-UNDO. /* files,... */
DEFINE INPUT  PARAMETER qbf-g AS CHARACTER NO-UNDO. /* flag */
DEFINE OUTPUT PARAMETER qbf-o AS CHARACTER NO-UNDO. /* join record */

DEFINE VARIABLE lReturn AS LOGICAL    NO-UNDO.

/*
qbf-g contents:
  "f": called from r-file.p
  "l": called from a-join.p for left frame
  "r": called from a-join.p for right frame
  "q": called from q-join.p

qbf-f contents:
  "": (zero-length string)
    Show scrolling list of all files.
  "!can-do-list":
    List all files matching the can-do list.  First entry must be banged.
  comma-separated list of file-names:
    Only list files that can join to those files.
  "?":
    Use values already loaded in qbf-schema.  Note that this is *not*
    the unknown value, but is a quoted question mark.

If comma-sep list, qbf-o will contain the record from qbf-join.
Otherwise, if qbf-g = "f" or "q" then qbf-o will contain just the
file-name.  Otherwise, qbf-o = # in qbf-schema + "," + filename.
*/

/* qbf-schema.cValue = "filename,dbname,0000" */

/*local:*/
DEFINE VARIABLE ix    AS INTEGER                NO-UNDO.
DEFINE VARIABLE qbf-a AS LOGICAL                NO-UNDO.
DEFINE VARIABLE qbf-b AS INTEGER                NO-UNDO.
DEFINE VARIABLE qbf-c AS INTEGER                NO-UNDO.
DEFINE VARIABLE qbf-d AS INTEGER                NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER                NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER                NO-UNDO.
DEFINE VARIABLE qbf-k AS INTEGER                NO-UNDO.
DEFINE VARIABLE qbf-n AS INTEGER                NO-UNDO.
DEFINE VARIABLE qbf-p AS INTEGER   INITIAL ?    NO-UNDO.
DEFINE VARIABLE qbf-r AS INTEGER                NO-UNDO.
DEFINE VARIABLE qbf-t AS CHARACTER              NO-UNDO.
DEFINE VARIABLE qbf-v AS CHARACTER              NO-UNDO.
DEFINE VARIABLE qbf-w AS LOGICAL   INITIAL TRUE NO-UNDO.
DEFINE VARIABLE qbf-x AS INTEGER                NO-UNDO.
DEFINE VARIABLE qbf-y AS INTEGER                NO-UNDO.
DEFINE VARIABLE qbf-z AS CHARACTER              NO-UNDO.

/*forms:*/
FORM
  qbf-t FORMAT "x(48)"
  WITH FRAME qbf-pick SCROLL 1 OVERLAY NO-LABELS ATTR-SPACE
  qbf-d DOWN ROW qbf-y COLUMN qbf-c
  COLOR DISPLAY VALUE(qbf-plo) PROMPT VALUE(qbf-phi)
  TITLE COLOR VALUE(qbf-plo)
    " " + qbf-lang[IF qbf-g = "q" THEN 14 ELSE
                   IF qbf-n = 1 OR qbf-g = "l" THEN 10 ELSE 11] + " ".
    /* 10:"Select File"  11:"Select Related File" 14:"Join"*/

FORM
  qbf-t FORMAT "x(48)"
  WITH FRAME qbf-type OVERLAY NO-LABELS ATTR-SPACE
  ROW qbf-y + qbf-d + 2 COLUMN qbf-c
  COLOR DISPLAY VALUE(qbf-plo) PROMPT VALUE(qbf-phi).

ASSIGN
  qbf-b = (IF LENGTH(qbf-schema%) = 0 THEN 46 ELSE 45) /* used by s-file.i */
  qbf-i = 1
  qbf-f = (IF qbf-f = FILL(",",LENGTH(qbf-f)) THEN "" ELSE qbf-f)
  qbf-n = 0
  qbf-t = "".
/* 3rd param for c-merge.p is scrap */

/*message "[c-file.p]" skip view-as alert-box.*/

IF qbf-f = "?" THEN . /* use list already sitting in qbf-schema */
ELSE
IF qbf-f = "" THEN
  RUN prores/c-merge.p ("*",TRUE,OUTPUT qbf-a,OUTPUT qbf-i).
ELSE 
IF qbf-f BEGINS "!" THEN /* can-do list */
  RUN prores/c-merge.p (qbf-f,TRUE,OUTPUT qbf-a,OUTPUT qbf-i).
ELSE DO:
  EMPTY TEMP-TABLE qbf-schema.
  DO WHILE ENTRY(qbf-n + 1,qbf-f + ",") <> "":
    qbf-n = qbf-n + 1.
    
    DO qbf-i = 1 TO qbf-join#:
      {&FIND_QBF_JOIN} qbf-i.
      ASSIGN
        qbf-z = ENTRY(1,qbf-join.cValue)
        qbf-v = ENTRY(2,qbf-join.cValue).

      IF qbf-z <> ENTRY(qbf-n,qbf-f)          /* not joinable */
        OR CAN-DO(qbf-f,qbf-v)                /* already used */
        OR CAN-DO(qbf-t,qbf-v) THEN           /* already in list */
        ASSIGN
          qbf-v = ENTRY(1,qbf-join.cValue)    /* so swap and try again */
          qbf-z = ENTRY(2,qbf-join.cValue).
      IF qbf-z <> ENTRY(qbf-n,qbf-f)          /* not joinable */
        OR CAN-DO(qbf-f,qbf-v)                /* already used */
        OR CAN-DO(qbf-t,qbf-v) THEN NEXT.     /* already in list */
        
      RUN prores/s-lookup.p (qbf-v,"","","FILE:DESC",OUTPUT qbf-z).
      ASSIGN
        qbf-t                   = qbf-t + "," + qbf-v
        qbf-schema#             = qbf-schema# + 1
        lReturn                 = getRecord("qbf-schema":U, qbf-schema#)
        qbf-schema.cValue       = SUBSTRING(qbf-v,INDEX(qbf-v,".") + 1) + ","
                                + SUBSTRING(qbf-v,1,INDEX(qbf-v,".") - 1)
                                + ",":U + STRING(qbf-i,"9999") + "|":U
                                + SUBSTRING(qbf-z,1,40)
        qbf-schema.cSort        = ENTRY(1, qbf-schema.cValue) + ",":U +
                                  ENTRY(2, qbf-schema.cValue) + ",":U. 
    END.
  END.
  
  IF qbf-schema# >= 2 THEN DO: /* sort */
    REPEAT PRESELECT EACH qbf-schema USE-INDEX iIndex:
      FIND NEXT qbf-schema.
      qbf-schema.iIndex = qbf-schema.iIndex + 100000.
    END.
    ix = 0.
    REPEAT PRESELECT EACH qbf-schema USE-INDEX cSort:
      FIND NEXT qbf-schema.
      ASSIGN
        ix                = ix + 1
        qbf-schema.iIndex = ix.
    END.
  END.
END.

qbf-o = "".
IF qbf-schema# <= 0 THEN RETURN.
{ prores/t-set.i &mod=c &set=0 }

ASSIGN
  qbf-i = MAXIMUM(qbf-i,0)
  qbf-n = qbf-n + 1
  qbf-t = ""
  qbf-r = 1
  qbf-c = INTEGER(ENTRY(INDEX("flrq",qbf-g),"8,2,28,28"))
  qbf-y = INTEGER(ENTRY(INDEX("flrq",qbf-g),STRING(qbf-n + 2) + ",3,3,5"))
  qbf-d = MINIMUM(MINIMUM(qbf-schema#,SCREEN-LINES - qbf-y - 4),
          IF qbf-g = "f" THEN 12 ELSE SCREEN-LINES - 12).
IF qbf-i <> 0 AND qbf-i <> ? AND qbf-i <= qbf-schema# THEN
  ASSIGN
    qbf-p = MINIMUM(qbf-d,qbf-i)
    qbf-r = qbf-i.

PAUSE 0 BEFORE-HIDE.
VIEW FRAME qbf-pick.
/*3: "Press [END-ERROR] to stop selecting files."*/
STATUS DEFAULT qbf-lang[IF qbf-g = "f" THEN 3 ELSE 1].

ASSIGN
  qbf-z = FILL("Z",LENGTH(STRING(qbf-schema#)))
  qbf-x = qbf-c + 49 - LENGTH(qbf-z).
PUT SCREEN ROW qbf-y + qbf-d + 1 COLUMN qbf-x COLOR VALUE(qbf-plo)
  STRING(qbf-schema#).
qbf-x = qbf-x - LENGTH(qbf-xofy) - 1.
PUT SCREEN ROW qbf-y + qbf-d + 1 COLUMN qbf-x COLOR VALUE(qbf-plo)
  qbf-xofy.
qbf-x = qbf-x - LENGTH(qbf-z) - 1.

DO WHILE TRUE:
  qbf-r = MINIMUM(qbf-schema#,MAXIMUM(qbf-r,1)).
  IF qbf-r < FRAME-LINE(qbf-pick) THEN
    DOWN qbf-r - FRAME-LINE(qbf-pick) WITH FRAME qbf-pick.

  IF LENGTH(qbf-t) > 0 THEN
    DISPLAY qbf-t WITH FRAME qbf-type.
  ELSE
    HIDE FRAME qbf-type NO-PAUSE.

  IF qbf-w THEN DO WITH FRAME qbf-pick:
    ASSIGN
      qbf-j = MAXIMUM(1,FRAME-LINE)
      qbf-k = qbf-r - (IF qbf-p = ? THEN qbf-j ELSE qbf-p) + 1.
    UP qbf-j - 1.
    IF qbf-k < 1 THEN ASSIGN
      qbf-k = 1
      qbf-j = 1
      qbf-r = 1.
    DO qbf-i = qbf-k TO qbf-k + qbf-d - 1:
      IF qbf-i > qbf-schema# THEN
        CLEAR NO-PAUSE.
      ELSE DO:
        {&FIND_QBF_SCHEMA} qbf-i.
        DISPLAY SUBSTRING(qbf-schema%,qbf-i,1) + { prores/s-file.i qbf-i } @ qbf-t.
      END.
      IF qbf-i < qbf-k + qbf-d - 1 THEN DOWN 1.
    END.
    qbf-j = (IF qbf-p = ? THEN qbf-j ELSE qbf-p).
    UP qbf-d - qbf-j.
    ASSIGN
      qbf-p = ?
      qbf-w  = FALSE.
    IF CAN-DO("f,q",qbf-g) THEN
      PUT SCREEN ROW qbf-y + qbf-d + 1 COLUMN qbf-c + 2 COLOR VALUE(qbf-plo)
        STRING(qbf-toggle2,qbf-lang[6]). /*"Desc/Name"*/
  END.

  {&FIND_QBF_SCHEMA} qbf-r.
  DISPLAY SUBSTRING(qbf-schema%,qbf-r,1) + { prores/s-file.i qbf-r } @ qbf-t
    WITH FRAME qbf-pick.

  PUT SCREEN ROW qbf-y + qbf-d + 1 COLUMN qbf-x COLOR VALUE(qbf-plo)
    STRING(qbf-r,qbf-z).
  COLOR DISPLAY VALUE(qbf-phi) qbf-t WITH FRAME qbf-pick.
  READKEY.
  COLOR DISPLAY VALUE(qbf-plo) qbf-t WITH FRAME qbf-pick.

  IF (KEYFUNCTION(LASTKEY) = CHR(LASTKEY) AND LASTKEY >= 32)
    OR (KEYFUNCTION(LASTKEY) = "BACKSPACE" AND LENGTH(qbf-t) > 0) THEN DO:
    qbf-t = (IF KEYFUNCTION(LASTKEY) = "BACKSPACE"
            THEN SUBSTRING(qbf-t,1,LENGTH(qbf-t) - 1)
            ELSE qbf-t + CHR(LASTKEY)).
    IF qbf-t = "" OR { prores/s-file.i qbf-r } BEGINS qbf-t THEN NEXT.
    DO qbf-j = qbf-r TO qbf-schema#:
      {&FIND_QBF_SCHEMA} qbf-j.
      IF { prores/s-file.i qbf-j } BEGINS qbf-t THEN LEAVE.
    END.
    IF qbf-j > qbf-schema# THEN DO:
      DO qbf-j = 1 TO qbf-r:
        {&FIND_QBF_SCHEMA} qbf-j.
        IF { prores/s-file.i qbf-j } BEGINS qbf-t THEN LEAVE.
      END.
      IF qbf-j > qbf-r THEN 
        qbf-j = qbf-schema# + 1.
    END.
    IF qbf-j > qbf-schema# THEN DO:
      qbf-t = CHR(LASTKEY).
      DO qbf-j = 1 TO qbf-schema#:
        {&FIND_QBF_SCHEMA} qbf-j.
        IF { prores/s-file.i qbf-j } BEGINS qbf-t THEN LEAVE.
      END.
    END.
    ASSIGN
      qbf-j = (IF qbf-j <= qbf-schema# THEN qbf-j ELSE qbf-r)
      qbf-k = qbf-j - qbf-r + FRAME-LINE(qbf-pick)
      qbf-r = qbf-j.
    IF qbf-k < 1 OR qbf-k > qbf-d THEN
      qbf-w = TRUE.
    ELSE
      UP FRAME-LINE(qbf-pick) - qbf-k WITH FRAME qbf-pick.
    NEXT.
  END.

  qbf-t = "".
  IF KEYFUNCTION(LASTKEY) = "INSERT-MODE" AND CAN-DO("f,q",qbf-g) THEN
    ASSIGN
      qbf-w       = TRUE
      qbf-toggle2 = NOT qbf-toggle2.
  ELSE
  IF CAN-DO("CURSOR-DOWN,TAB",KEYFUNCTION(LASTKEY))
    AND qbf-r < qbf-schema# THEN DO:
    qbf-r = qbf-r + 1.
    IF FRAME-LINE(qbf-pick) = FRAME-DOWN(qbf-pick) THEN
      SCROLL UP WITH FRAME qbf-pick.
    ELSE
      DOWN WITH FRAME qbf-pick.
  END.
  ELSE
  IF CAN-DO("CURSOR-UP,BACK-TAB",KEYFUNCTION(LASTKEY)) AND qbf-r > 1 THEN DO:
    qbf-r = qbf-r - 1.
    IF FRAME-LINE(qbf-pick) = 1 THEN
      SCROLL DOWN WITH FRAME qbf-pick.
    ELSE
      UP WITH FRAME qbf-pick.
  END.
  ELSE
  IF KEYFUNCTION(LASTKEY) = "PAGE-DOWN" THEN DO:
    ASSIGN
      qbf-r = qbf-r + qbf-d
      qbf-w = TRUE.
    IF qbf-r + qbf-d - FRAME-LINE(qbf-pick) > qbf-schema# THEN DO:
      qbf-r = qbf-schema#.
      DOWN MINIMUM(qbf-schema#,qbf-d) - FRAME-LINE(qbf-pick)
        WITH FRAME qbf-pick.
    END.
  END.
  ELSE
  IF KEYFUNCTION(LASTKEY) = "PAGE-UP" THEN
    ASSIGN
      qbf-r = qbf-r - qbf-d
      qbf-w = TRUE.
  ELSE
  IF CAN-DO("HOME,MOVE",KEYFUNCTION(LASTKEY)) THEN DO:
    ASSIGN
      qbf-r = (IF qbf-r = 1 THEN qbf-schema# ELSE 1)
      qbf-w = TRUE.
    UP FRAME-LINE(qbf-pick) - (IF qbf-r = 1 THEN 1 ELSE qbf-d)
      WITH FRAME qbf-pick.
  END.
  ELSE
  IF CAN-DO("GO,RETURN",KEYFUNCTION(LASTKEY)) THEN DO:
    {&FIND_QBF_SCHEMA} qbf-r.

    /* Not all tables have join records, so include NO-ERROR. */
    {&FIND_QBF_JOIN} INTEGER(ENTRY(1,ENTRY(3,qbf-schema.cValue),"|":U)) NO-ERROR.
    qbf-o = (IF qbf-g = "f" THEN "" ELSE STRING(qbf-r) + ",")
          + (IF CAN-DO("l,r",qbf-g) OR qbf-f = "" OR qbf-f BEGINS "!" THEN
              ENTRY(2,qbf-schema.cValue) + "." + ENTRY(1,qbf-schema.cValue)
             ELSE (IF NOT AVAILABLE qbf-join THEN "" ELSE
                     qbf-join.cValue + "," + qbf-join.cWhere)).
    IF qbf-n > 1 THEN
      ASSIGN /*if necessary, swap around entrys 1 & 2 of qbf-join.cValue*/
        qbf-v = (IF CAN-DO(qbf-f,ENTRY(1,qbf-o)) THEN
                  ENTRY(1,qbf-o) + "," + ENTRY(2,qbf-o)
                ELSE
                  ENTRY(2,qbf-o) + "," + ENTRY(1,qbf-o))
        qbf-o = qbf-v + "," + (IF NOT AVAILABLE qbf-join OR
                                (AVAILABLE qbf-join AND qbf-join.cWhere = "")
                               THEN "" ELSE "WHERE " + qbf-join.cWhere).
    LEAVE.
  END.
  ELSE
  IF KEYFUNCTION(LASTKEY) = "HELP" AND LENGTH(qbf-module) > 2 THEN DO:
    RUN prores/applhelp.p.
    PUT SCREEN
      ROW qbf-y + qbf-d + 1 COLUMN qbf-x + LENGTH(qbf-xofy + qbf-z) + 2
      COLOR VALUE(qbf-plo) STRING(qbf-schema#).
    PUT SCREEN
      ROW qbf-y + qbf-d + 1 COLUMN qbf-x + LENGTH(qbf-z) + 1
      COLOR VALUE(qbf-plo) qbf-xofy.
  END.
  ELSE
  IF KEYFUNCTION(LASTKEY) = "END-ERROR" THEN LEAVE.

END.

HIDE FRAME qbf-pick NO-PAUSE.
HIDE FRAME qbf-type NO-PAUSE.
PAUSE BEFORE-HIDE.
STATUS DEFAULT.

{ prores/t-reset.i }
RETURN.
