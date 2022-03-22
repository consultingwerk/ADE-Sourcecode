/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* c-field.p - select multiple fields, in a specific order */

{ prores/s-system.i }
{ prores/t-define.i }
{ prores/c-cache.i NEW }
{ prores/reswidg.i }
{ prores/resfunc.i }

/*i/o:*/
DEFINE INPUT        PARAMETER qbf-f AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER qbf-g AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER qbf-o AS CHARACTER NO-UNDO.
/* qbf-f can contain a file-name, comma-sep file-names, or "current",
   for current field settings ("current" always reloads cache) */

/*local:*/
DEFINE VARIABLE lReturn AS LOGICAL    NO-UNDO.
DEFINE VARIABLE qbf-1   AS CHARACTER  NO-UNDO. /*used in s-field.i*/
DEFINE VARIABLE qbf-2   AS CHARACTER  NO-UNDO. /*used in s-field.i*/

DEFINE VARIABLE qbf-a   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE qbf-c   AS INTEGER    NO-UNDO INITIAL 2.
DEFINE VARIABLE qbf-d   AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-h   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE qbf-j   AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-k   AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-l   AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-n   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE qbf-q   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE qbf-r   AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-t   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE qbf-u   AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-v   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE qbf-w   AS LOGICAL    NO-UNDO INITIAL TRUE.
DEFINE VARIABLE qbf-x   AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-y   AS INTEGER    NO-UNDO INITIAL 5.
DEFINE VARIABLE qbf-z   AS CHARACTER  NO-UNDO.

DEFINE TEMP-TABLE qbf-e
  FIELD iIndex AS INTEGER
  FIELD iValue AS INTEGER
  INDEX iIndex IS UNIQUE iIndex.
DEFINE BUFFER buf-e FOR qbf-e.
&GLOBAL-DEFINE FIND_QBF_E FIND FIRST qbf-e WHERE qbf-e.iIndex = 
&GLOBAL-DEFINE FIND_BUF_E FIND FIRST buf-e WHERE buf-e.iIndex = 
            
FUNCTION getTT RETURNS LOGICAL
  (INPUT pTable AS CHARACTER,
   INPUT pIndex AS INTEGER):
   
  CASE pTable:
    WHEN "qbf-e":U THEN DO:
      IF NOT CAN-FIND(qbf-e WHERE qbf-e.iIndex = pIndex) THEN DO:
        CREATE qbf-e.
        ASSIGN qbf-e.iIndex = pIndex.
      END.
      ELSE FIND qbf-e WHERE qbf-e.iIndex = pIndex.
    END.
  END CASE.
  
  RETURN TRUE.
  
END FUNCTION.

/*message "[c-field.p]" view-as alert-box.*/

/*forms:*/
FORM
  qbf-u           FORMAT ">>>" SPACE(0)
  qbf-cfld.cValue FORMAT "x(40)"
  WITH FRAME qbf-pick SCROLL 1 OVERLAY /*TOP-ONLY*/ NO-LABELS ATTR-SPACE
  qbf-d DOWN ROW qbf-y COLUMN qbf-c
  COLOR DISPLAY VALUE(qbf-plo) PROMPT VALUE(qbf-phi)
  TITLE COLOR VALUE(qbf-plo) " " + qbf-lang[9] + " ". /*"Choose Fields"*/

FORM
  qbf-t FORMAT "x(45)"
  WITH FRAME qbf-type OVERLAY NO-LABELS ATTR-SPACE
  ROW qbf-y + qbf-d + 2 COLUMN qbf-c
  COLOR DISPLAY VALUE(qbf-plo) PROMPT VALUE(qbf-phi).

ASSIGN
  qbf-h = qbf-o = "" /* initially empty */
  qbf-d = SCREEN-LINES - 6
  qbf-t = "!raw,!rowid,*".

EMPTY TEMP-TABLE qbf-cfld.

{ prores/t-set.i &mod=c &set=0 }

/* Looking up available fields... */
STATUS DEFAULT qbf-lang[8].
RUN prores/c-vector.p ("a",qbf-module = "r",INPUT-OUTPUT qbf-o,OUTPUT qbf-v).
IF INDEX(qbf-f,":") > 0 THEN
  ASSIGN
    qbf-t = SUBSTRING(qbf-f,INDEX(qbf-f,":") + 1)
    qbf-f = SUBSTRING(qbf-f,1,INDEX(qbf-f,":") - 1).
DO qbf-k = 1 TO 5: /* hack! */
  IF DBTYPE("QBF$" + STRING(qbf-k)) <> "PROGRESS" THEN
    CREATE ALIAS VALUE("QBF$" + STRING(qbf-k)) FOR DATABASE VALUE(SDBNAME(1)).
END.
RUN prores/c-cache.p (qbf-f,qbf-t,qbf-o,qbf-v,OUTPUT qbf-v).

DO WHILE qbf-g <> "":
  IF qbf-g BEGINS "d" THEN 
  ASSIGN
    qbf-d = INTEGER(SUBSTRING(qbf-g,2,3))
    qbf-g = SUBSTRING(qbf-g,5).
  ELSE
  IF qbf-g BEGINS "r" THEN 
  ASSIGN
    qbf-y = INTEGER(SUBSTRING(qbf-g,2,3))
    qbf-g = SUBSTRING(qbf-g,5).
  ELSE
  IF qbf-g BEGINS "c" THEN 
  ASSIGN
    qbf-c = INTEGER(SUBSTRING(qbf-g,2,3))
    qbf-g = SUBSTRING(qbf-g,5).
END.

IF qbf-ctop <= 0 THEN DO:
  { prores/t-reset.i }
  STATUS DEFAULT.
  RETURN.
END.

/*"Press [F1] to select, [F3] to toggle name/label, [F4] to exit"*/
STATUS DEFAULT qbf-lang[2].

ASSIGN
  qbf-t = ""
  qbf-o = (IF qbf-o = ? THEN "" ELSE qbf-o)
  qbf-r = 1
  qbf-d = MINIMUM(SCREEN-LINES - 5 - qbf-y,qbf-d)
  qbf-k = 1.

DO qbf-j = 1 TO NUM-ENTRIES(qbf-v) - 1:
  ASSIGN
    lReturn      = getTT("qbf-e":U, INTEGER(ENTRY(qbf-j,qbf-v)))
    qbf-e.iValue = qbf-j.
END.
qbf-u = qbf-j - 1.

ASSIGN
  qbf-t = ""
  qbf-d = MINIMUM(qbf-ctop,qbf-d)
  qbf-o = ""
  qbf-z = FILL("Z",LENGTH(STRING(qbf-ctop)))
  qbf-x = qbf-c + 47 - LENGTH(qbf-z).

PAUSE 0 BEFORE-HIDE.
VIEW FRAME qbf-pick.

PUT SCREEN ROW qbf-d + qbf-y + 1 COLUMN qbf-x COLOR VALUE(qbf-plo)
  STRING(qbf-ctop).
qbf-x = qbf-x - LENGTH(qbf-xofy) - 1.
PUT SCREEN ROW qbf-d + qbf-y + 1 COLUMN qbf-x COLOR VALUE(qbf-plo) qbf-xofy.
qbf-x = qbf-x - LENGTH(qbf-z) - 1.

DO WHILE TRUE:
  qbf-r = MINIMUM(qbf-ctop,MAXIMUM(qbf-r,1)).
  IF qbf-r < FRAME-LINE(qbf-pick) THEN
    DOWN qbf-r - FRAME-LINE(qbf-pick) WITH FRAME qbf-pick.

  IF LENGTH(qbf-t) > 0 THEN
    DISPLAY qbf-t WITH FRAME qbf-type.
  ELSE
    HIDE FRAME qbf-type NO-PAUSE.

  IF qbf-w THEN DO:
    ASSIGN
      qbf-w = FALSE
      qbf-l = MAXIMUM(1,FRAME-LINE(qbf-pick))
      qbf-k = qbf-r - qbf-l + 1.
    UP qbf-l - 1 WITH FRAME qbf-pick.
    IF qbf-k < 1 THEN
      ASSIGN
        qbf-k = 1
        qbf-l = 1
        qbf-r = 1.
    DO qbf-j = qbf-k TO qbf-k + qbf-d - 1:
      IF qbf-j > qbf-ctop THEN
        CLEAR FRAME qbf-pick NO-PAUSE.
      ELSE DO WITH FRAME qbf-pick:
        {&FIND_QBF_CFLD} qbf-j + 1.
        {&FIND_QBF_E} qbf-j NO-ERROR.
        
        { prores/s-field.i qbf-cfld.cValue }
        IF AVAILABLE qbf-e THEN
          DISPLAY qbf-e.iValue @ qbf-u.
        ELSE DISPLAY " ":U @ qbf-u.
        DISPLAY qbf-1 @ qbf-cfld.cValue.
      END.
      IF qbf-j < qbf-k + qbf-d - 1 THEN
        DOWN 1 WITH FRAME qbf-pick.
    END.
    UP qbf-d - qbf-l WITH FRAME qbf-pick.
    PUT SCREEN ROW qbf-d + qbf-y + 1 COLUMN qbf-c + 2
      STRING(qbf-toggle1,qbf-lang[5]). /*"Label/Name-"*/
  END.
  IF qbf-a THEN DO WITH FRAME qbf-pick:
    ASSIGN
      qbf-a = FALSE
      qbf-k = FRAME-LINE.
    UP qbf-k - 1.
    DO qbf-l = 1 TO FRAME-DOWN:
      {&FIND_QBF_E} qbf-r - qbf-k + qbf-l NO-ERROR.
      IF AVAILABLE qbf-e THEN
        DISPLAY qbf-e.iValue WHEN qbf-e.iValue <> INPUT qbf-u @ qbf-u.
      DOWN.
    END.
    UP FRAME-LINE - qbf-k.
  END.

  {&FIND_QBF_CFLD} qbf-r + 1.
  {&FIND_QBF_E} qbf-r NO-ERROR.
  
  { prores/s-field.i qbf-cfld.cValue }
  IF AVAILABLE qbf-e THEN
    DISPLAY qbf-e.iValue @ qbf-u WITH FRAME qbf-pick.
  ELSE DISPLAY " ":U @ qbf-u WITH FRAME qbf-pick.  
  DISPLAY qbf-1 @ qbf-cfld.cValue WITH FRAME qbf-pick.

  PUT SCREEN ROW qbf-d + qbf-y + 1 COLUMN qbf-x COLOR VALUE(qbf-plo)
    STRING(qbf-r,qbf-z).
    
  {&FIND_QBF_CFLD} qbf-r.
  COLOR DISPLAY VALUE(qbf-phi) qbf-u qbf-cfld.cValue WITH FRAME qbf-pick.
  IF NOT qbf-q THEN READKEY.
  COLOR DISPLAY VALUE(qbf-plo) qbf-u qbf-cfld.cValue WITH FRAME qbf-pick.

  IF LENGTH(qbf-t) = 0 AND INDEX("1234567890",CHR(LASTKEY)) > 0 THEN .
  ELSE
  IF (KEYFUNCTION(LASTKEY) = CHR(LASTKEY) AND LASTKEY >= 32)
    OR (KEYFUNCTION(LASTKEY) = "BACKSPACE" AND LENGTH(qbf-t) > 0) THEN DO:
    {&FIND_QBF_CFLD} qbf-r + 1.
    ASSIGN
      qbf-t = (IF KEYFUNCTION(LASTKEY) = "BACKSPACE"
              THEN SUBSTRING(qbf-t,1,LENGTH(qbf-t) - 1)
              ELSE qbf-t + CHR(LASTKEY))
      qbf-v = qbf-cfld.cValue.
    IF qbf-t = ""
      OR (IF qbf-toggle1 THEN SUBSTRING(qbf-v,INDEX(qbf-v,"|") + 1)
      ELSE ENTRY(2,qbf-v)) BEGINS qbf-t THEN NEXT.
    DO qbf-l = qbf-r TO qbf-ctop:
      {&FIND_QBF_CFLD} qbf-l + 1.
      qbf-v = qbf-cfld.cValue.
      IF (IF qbf-toggle1 THEN SUBSTRING(qbf-v,INDEX(qbf-v,"|") + 1)
        ELSE ENTRY(2,qbf-v)) BEGINS qbf-t THEN LEAVE.
    END.
    IF qbf-l > qbf-ctop THEN DO:
      DO qbf-l = 1 TO qbf-r:
        {&FIND_QBF_CFLD} qbf-l + 1.
        qbf-v = qbf-cfld.cValue.
        IF (IF qbf-toggle1 THEN SUBSTRING(qbf-v,INDEX(qbf-v,"|") + 1)
          ELSE ENTRY(2,qbf-v)) BEGINS qbf-t THEN LEAVE.
      END.
      IF qbf-l > qbf-r THEN qbf-l = qbf-ctop + 1.
    END.
    IF qbf-l > qbf-ctop THEN DO:
      qbf-t = CHR(LASTKEY).
      DO qbf-l = 1 TO qbf-ctop:
        {&FIND_QBF_CFLD} qbf-l + 1.
        qbf-v = qbf-cfld.cValue.
        IF (IF qbf-toggle1 THEN SUBSTRING(qbf-v,INDEX(qbf-v,"|") + 1)
          ELSE ENTRY(2,qbf-v)) BEGINS qbf-t THEN LEAVE.
      END.
    END.
    ASSIGN
      qbf-l = (IF qbf-l <= qbf-ctop THEN qbf-l ELSE qbf-r)
      qbf-k = qbf-l - qbf-r + FRAME-LINE(qbf-pick)
      qbf-r = qbf-l.
    IF qbf-k < 1 OR qbf-k > qbf-d THEN
      qbf-w = TRUE.
    ELSE
      UP FRAME-LINE(qbf-pick) - qbf-k WITH FRAME qbf-pick.
    NEXT.
  END.

  ASSIGN
    qbf-q = FALSE
    qbf-t = "".
  DO WHILE INDEX("0123456789",CHR(LASTKEY)) > 0:
    ASSIGN
      qbf-q = TRUE
      qbf-t = qbf-t + CHR(LASTKEY).
    COLOR DISPLAY INPUT qbf-u WITH FRAME qbf-pick.
    DISPLAY INTEGER(qbf-t) @ qbf-u WITH FRAME qbf-pick.
    READKEY.
  END.
  COLOR DISPLAY VALUE(qbf-plo) qbf-u WITH FRAME qbf-pick.
  IF qbf-q THEN DO:
    lReturn = getTT("qbf-e":U, qbf-r).
    IF qbf-e.iValue = 0 THEN DO:
      ASSIGN
        qbf-u        = qbf-u + 1
        qbf-e.iValue = qbf-u.
      DISPLAY qbf-u WITH FRAME qbf-pick.
    END.
    ASSIGN
      qbf-k = qbf-e.iValue                              /*current*/
      qbf-l = MAXIMUM(1,MINIMUM(qbf-u,INTEGER(qbf-t))). /*new*/
    IF qbf-k <> qbf-l THEN DO:
      DO qbf-j = 1 TO qbf-ctop:
        lReturn = getTT("qbf-e":U, qbf-j).
        IF qbf-l > qbf-k THEN
          IF qbf-e.iValue > qbf-k AND qbf-e.iValue <= qbf-l THEN
            qbf-e.iValue = qbf-e.iValue - 1.
        IF qbf-l < qbf-k THEN
          IF qbf-e.iValue >= qbf-l AND qbf-e.iValue < qbf-k THEN
            qbf-e.iValue = qbf-e.iValue + 1.
      END.
      
      ASSIGN
        lReturn      = getTT("qbf-e":U, qbf-r)
        qbf-e.iValue = qbf-l
        qbf-a        = TRUE.
    END.
    ASSIGN
      qbf-t = ""
      qbf-q = CAN-DO("*-UP,*-DOWN,*TAB",KEYFUNCTION(LASTKEY)).
    NEXT.
  END.

  qbf-n = FALSE.
  IF KEYFUNCTION(LASTKEY) = "INSERT-MODE" THEN
    ASSIGN
      qbf-w       = TRUE
      qbf-toggle1 = NOT qbf-toggle1.
  IF KEYFUNCTION(LASTKEY) = "RETURN" THEN DO:
    ASSIGN
      lReturn      = getTT("qbf-e":U, qbf-r)
      qbf-n        = TRUE
      qbf-k        = qbf-e.iValue
      qbf-u        = qbf-u + (IF qbf-k = 0 THEN 1 ELSE -1)
      qbf-e.iValue = (IF qbf-k = 0 THEN qbf-u ELSE 0).
    IF qbf-k > 0 THEN DO:
      qbf-a = TRUE.
      DO qbf-l = 1 TO qbf-ctop:
        lReturn = getTT("qbf-e":U, qbf-l).
        IF qbf-e.iValue > qbf-k THEN 
          qbf-e.iValue = qbf-e.iValue - 1.
      END.
    END.
    {&FIND_QBF_CFLD} qbf-r + 1.
    lReturn      = getTT("qbf-e":U, qbf-r).
    IF qbf-e.iValue > 0 AND
      ENTRY(2,qbf-cfld.cValue) MATCHES "*[*]" THEN
      RUN prores/c-vector.p ("e" + STRING(qbf-c * 1000 + qbf-y,"999999"),
                             qbf-module = "r",INPUT-OUTPUT qbf-cfld.cValue,
                             OUTPUT qbf-v).
                             
    { prores/s-field.i qbf-cfld.cValue }
    IF AVAILABLE qbf-e THEN
      DISPLAY qbf-e.iValue @ qbf-u WITH FRAME qbf-pick.
    ELSE DISPLAY " ":U @ qbf-u WITH FRAME qbf-pick.
    DISPLAY qbf-1 @ qbf-cfld.cValue WITH FRAME qbf-pick.
    qbf-w = ?.
  END.
  IF qbf-n OR CAN-DO("CURSOR-DOWN,TAB,RETURN",KEYFUNCTION(LASTKEY)) THEN DO:
    IF qbf-r = qbf-ctop THEN .
    ELSE
    IF FRAME-LINE(qbf-pick) = FRAME-DOWN(qbf-pick) THEN
      SCROLL UP WITH FRAME qbf-pick.
    ELSE
      DOWN WITH FRAME qbf-pick.
    qbf-r = MINIMUM(qbf-ctop,qbf-r + 1).
  END.
  ELSE
  IF CAN-DO("CURSOR-UP,BACK-TAB",KEYFUNCTION(LASTKEY)) THEN DO:
    IF qbf-r = 1 THEN .
    ELSE
    IF FRAME-LINE(qbf-pick) = 1 THEN
      SCROLL DOWN WITH FRAME qbf-pick.
    ELSE
      UP WITH FRAME qbf-pick.
    qbf-r = MAXIMUM(qbf-r - 1,1).
  END.
  ELSE
  IF KEYFUNCTION(LASTKEY) = "PAGE-DOWN" THEN DO:
    ASSIGN
      qbf-r = qbf-r + qbf-d
      qbf-w = TRUE.
    IF qbf-r + qbf-d - FRAME-LINE(qbf-pick) > qbf-ctop THEN DO:
      qbf-r = qbf-ctop.
      DOWN MINIMUM(qbf-ctop,qbf-d) - FRAME-LINE(qbf-pick)
        WITH FRAME qbf-pick.
    END.
  END.
  ELSE
  IF KEYFUNCTION(LASTKEY) = "PAGE-UP" THEN DO:
    ASSIGN
      qbf-r = MAXIMUM(qbf-r - qbf-d,1)
      qbf-w = TRUE.
    IF qbf-r < 1 THEN
      UP FRAME-LINE(qbf-pick) - 1 WITH FRAME qbf-pick.
  END.
  ELSE
  IF CAN-DO("HOME,MOVE",KEYFUNCTION(LASTKEY)) THEN DO:
    ASSIGN
      qbf-r = (IF qbf-r > 1 THEN 1 ELSE qbf-ctop)
      qbf-w = TRUE.
    UP FRAME-LINE(qbf-pick) - (IF qbf-r = 1 THEN 1 ELSE qbf-d)
      WITH FRAME qbf-pick.
  END.
  ELSE
  IF CAN-DO("GO" + (IF qbf-h THEN ",END-ERROR" ELSE ""),KEYFUNCTION(LASTKEY))
    THEN DO:
    /* if initially no fields selected, then treat end-error as go to
    save selection */
    qbf-o = "".
    DO qbf-j = 1 TO qbf-u:
      qbf-o = qbf-o + (IF qbf-j = 1 THEN "|" ELSE ",|") + STRING(qbf-j).
    END.
    DO qbf-j = 1 TO qbf-ctop:
      lReturn = getTT("qbf-e":U, qbf-j).
      IF qbf-e.iValue = 0 THEN NEXT.
      
      {&FIND_QBF_CFLD} qbf-j + 1.
      ASSIGN
        qbf-t = qbf-cfld.cValue
        qbf-k = LOOKUP(ENTRY(1,qbf-t),qbf-etype)
        qbf-t = (IF qbf-k = 0 THEN ENTRY(1,qbf-t) + "." ELSE "")
              + ENTRY(2,qbf-t)
        qbf-g = "|" + STRING(qbf-e.iValue)
        SUBSTRING(qbf-o,INDEX(qbf-o,qbf-g),LENGTH(qbf-g)) = qbf-t.
    END.
    LEAVE.
  END.
  ELSE
  IF KEYFUNCTION(LASTKEY) = "HELP" AND LENGTH(qbf-module) > 2 THEN DO:
    RUN prores/applhelp.p.
    qbf-w = ?.
  END.
  ELSE
  IF KEYFUNCTION(LASTKEY) = "END-ERROR" THEN LEAVE.

  IF qbf-w = ? THEN DO:
    qbf-w = FALSE.
    PUT SCREEN ROW qbf-d + qbf-y + 1 COLUMN qbf-x + LENGTH(qbf-z) + 1
      COLOR VALUE(qbf-plo) qbf-xofy.
    PUT SCREEN
      ROW qbf-d + qbf-y + 1
      COLUMN qbf-x + LENGTH(qbf-z + qbf-xofy) + 2
      COLOR VALUE(qbf-plo) STRING(qbf-ctop).
  END.

END.

RUN prores/c-vector.p ("p",qbf-module = "r",INPUT-OUTPUT qbf-o,OUTPUT qbf-v).

HIDE FRAME qbf-pick NO-PAUSE.
HIDE FRAME qbf-type NO-PAUSE.

PAUSE BEFORE-HIDE.
STATUS DEFAULT.

{ prores/t-reset.i }
RETURN.
