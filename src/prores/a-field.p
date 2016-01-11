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
/* a-field.p - select fields for forms */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/a-define.i }
{ prores/t-define.i }

DEFINE OUTPUT PARAMETER qbf-e AS LOGICAL   INITIAL FALSE NO-UNDO.
DEFINE OUTPUT PARAMETER qbf-o AS CHARACTER INITIAL    "" NO-UNDO.
/* something changed */

DEFINE VARIABLE qbf-c AS CHARACTER             NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER               NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER               NO-UNDO.
DEFINE VARIABLE qbf-k AS INTEGER               NO-UNDO.
DEFINE VARIABLE qbf-l AS INTEGER               NO-UNDO.
DEFINE VARIABLE qbf-p AS INTEGER INITIAL     1 NO-UNDO.
DEFINE VARIABLE qbf-r AS ROWID                 NO-UNDO.
DEFINE VARIABLE qbf-w AS LOGICAL INITIAL  TRUE NO-UNDO. /* redraw */
DEFINE VARIABLE qbf-x AS INTEGER               NO-UNDO. /* maximum */
DEFINE VARIABLE qbf-y AS INTEGER               NO-UNDO. /* down */

DEFINE WORKFILE qbf-z NO-UNDO
  FIELD qbf-n AS CHARACTER /* name */
  FIELD qbf-t AS INTEGER   /* dtype */
  FIELD qbf-d AS LOGICAL   /* display? */
  FIELD qbf-u AS LOGICAL   /* update? */
  FIELD qbf-q AS LOGICAL   /* query? */
  FIELD qbf-b AS LOGICAL   /* browse? */
  FIELD qbf-a AS LOGICAL   /* is array? */
  FIELD qbf-s AS INTEGER.  /* sequence */

FORM
  qbf-z.qbf-n FORMAT "x(36)" NO-ATTR-SPACE
  qbf-z.qbf-d LABEL "-   -" /*"Disp?"*/
  qbf-z.qbf-u LABEL "-   -" /*"Upd? "*/
  qbf-z.qbf-q LABEL "-   -" /*"Qry? "*/
  qbf-z.qbf-b LABEL "-   -" /*"Brow?"*/
  qbf-z.qbf-s LABEL "-  -"  /*"Seq"*/ FORMAT ">>>9"
    VALIDATE((qbf-z.qbf-s > 0 AND qbf-z.qbf-s < 10000)
      OR NOT (INPUT qbf-z.qbf-d OR INPUT qbf-z.qbf-u
        OR    INPUT qbf-z.qbf-q OR INPUT qbf-z.qbf-b),
      qbf-lang[31]) /*Must be within the range 1 to 9999.*/
  WITH FRAME qbf-edit SCROLL 1 OVERLAY NO-LABELS ATTR-SPACE
  qbf-y DOWN ROW 4 COLUMN 2 NO-BOX.

{ prores/s-alias.i
  &prog=prores/a-field.p
  &dbname=qbf-db[1]
  &params=" "
}

{ prores/t-set.i &mod=a &set=6 }

ASSIGN
  qbf-c = ""
  qbf-x = 0.
DO qbf-i = 1 TO { prores/s-limcol.i } WHILE qbf-rcn[qbf-i] <> "":
  qbf-c = qbf-c + (IF qbf-c = "" THEN "" ELSE ",") + qbf-rcn[qbf-i].
END.
/* filter out sql92 tables and views */
IF INTEGER(DBVERSION("QBF$0":U)) > 8 THEN
  FIND FIRST QBF$0._File OF QBF$0._Db 
    WHERE QBF$0._File._File-name = qbf-file[1] AND
      (QBF$0._File._Owner = "PUB":U OR QBF$0._File._Owner = "_FOREIGN":U)
    NO-LOCK.
ELSE 
  FIND FIRST QBF$0._File OF QBF$0._Db 
    WHERE QBF$0._File._File-name = qbf-file[1] NO-LOCK.
  
FOR EACH QBF$0._Field OF QBF$0._File BY QBF$0._Field._Order:
  CREATE qbf-z.
  ASSIGN
    qbf-x       = qbf-x + 1
    qbf-i       = LOOKUP(QBF$0._Field._Field-name,qbf-c)
    qbf-z.qbf-n = QBF$0._Field._Field-name
    qbf-z.qbf-t = QBF$0._Field._dtype
    qbf-z.qbf-d = qbf-i > 0 AND SUBSTRING(qbf-rca[qbf-i],1,1) = "y"
    qbf-z.qbf-u = qbf-i > 0 AND SUBSTRING(qbf-rca[qbf-i],2,1) = "y"
    qbf-z.qbf-q = qbf-i > 0 AND SUBSTRING(qbf-rca[qbf-i],3,1) = "y"
    qbf-z.qbf-b = qbf-i > 0 AND SUBSTRING(qbf-rca[qbf-i],4,1) = "y"
    qbf-z.qbf-s = (IF qbf-i = 0 THEN 0 ELSE qbf-rcw[qbf-i])
    qbf-z.qbf-a = QBF$0._Field._Extent > 0.
END.

DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:

  ASSIGN
    qbf-l = ?
    qbf-y = MINIMUM(qbf-x,SCREEN-LINES - 6).
  VIEW FRAME qbf-edit.

  FIND FIRST qbf-z.
  DO WHILE TRUE WITH FRAME qbf-edit:

    /* put labels where they go */
    /*    qbf-lang[30] = 'Disp? Upd?  Qry?  Brow  Seq'*/
    /*                   "----- ----- ----- ----- ---"*/
    PUT SCREEN
      ROW FRAME-ROW(qbf-edit)
      COLUMN FRAME-COL(qbf-edit) + 37
      qbf-lang[30].

    IF NOT AVAILABLE qbf-z THEN FIND FIRST qbf-z.

    IF qbf-w THEN DO:
      ASSIGN
        qbf-i = MAXIMUM(1,FRAME-LINE)
        qbf-r = ROWID(qbf-z)
        qbf-w = FALSE.
      DO qbf-j = 2 TO qbf-i WHILE AVAILABLE qbf-z:
        FIND PREV qbf-z NO-ERROR.
      END.
      IF NOT AVAILABLE qbf-z THEN DO:
        FIND FIRST qbf-z.
        ASSIGN
          qbf-i = 1
          qbf-r = ROWID(qbf-z).
      END.
      UP MAXIMUM(0,FRAME-LINE - 1).
      DO qbf-j = 1 TO qbf-y:
        IF NOT AVAILABLE qbf-z THEN
          CLEAR NO-PAUSE.
        ELSE DO:
          ASSIGN
            qbf-c = qbf-z.qbf-n + (IF qbf-z.qbf-a THEN "[]" ELSE "")
            qbf-c = FILL(" ",MAXIMUM(0,36 - LENGTH(qbf-c))) + qbf-c.
          DISPLAY qbf-c @ qbf-z.qbf-n
            qbf-z.qbf-d qbf-z.qbf-u qbf-z.qbf-q qbf-z.qbf-b qbf-z.qbf-s.
        END.
        IF AVAILABLE qbf-z THEN FIND NEXT qbf-z NO-ERROR.
        IF qbf-j < qbf-y THEN DOWN 1.
      END.
      UP qbf-y - qbf-i.
      FIND FIRST qbf-z WHERE ROWID(qbf-z) = qbf-r.
    END.

    qbf-c = qbf-z.qbf-n + (IF qbf-z.qbf-a THEN "[]" ELSE "").
    /*PUT SCREEN ROW SCREEN-LINES COLUMN 69 COLOR VALUE(qbf-plo)
      STRING(qbf-p,"ZZ9").*/
    DISPLAY
      qbf-z.qbf-d qbf-z.qbf-u qbf-z.qbf-q qbf-z.qbf-b qbf-z.qbf-s
      FILL(" ",MAXIMUM(0,36 - LENGTH(qbf-c))) + qbf-c @ qbf-z.qbf-n.

    SET
      qbf-z.qbf-d
      qbf-z.qbf-u
      qbf-z.qbf-q WHEN NOT qbf-z.qbf-a
      qbf-z.qbf-b WHEN NOT qbf-z.qbf-a
      qbf-z.qbf-s
      EDITING:
        READKEY.
        APPLY
          (IF CAN-DO("*-UP,*-DOWN,GO,END-ERROR,HOME,MOVE",KEYFUNCTION(LASTKEY))
          THEN KEYCODE(KBLABEL("GO")) ELSE LASTKEY).
/*
        IF GO-PENDING AND INPUT qbf-z.qbf-s = 0 AND
          (qbf-z.qbf-d OR qbf-z.qbf-u OR qbf-z.qbf-q OR qbf-z.qbf-b) THEN DO:
          MESSAGE qbf-lang[31].  /*Must be within the range 1 to 9999.*/
          BELL.
          NEXT.
        END.
*/
      END.
    STATUS INPUT OFF.
    qbf-e = qbf-e            OR (qbf-z.qbf-d ENTERED
      OR qbf-z.qbf-u ENTERED OR  qbf-z.qbf-q ENTERED
      OR qbf-z.qbf-b ENTERED OR  qbf-z.qbf-s ENTERED).
    /*IF qbf-z.qbf-s ENTERED THEN qbf-w = TRUE.*/
    DISPLAY qbf-z.qbf-d qbf-z.qbf-u qbf-z.qbf-q qbf-z.qbf-b qbf-z.qbf-s.

    IF CAN-DO("RETURN,CURSOR-DOWN",KEYFUNCTION(LASTKEY)) THEN DO:
      FIND NEXT qbf-z NO-ERROR.
      IF NOT AVAILABLE qbf-z THEN
        FIND LAST qbf-z.
      ELSE
        IF FRAME-LINE = FRAME-DOWN THEN SCROLL UP. ELSE DOWN.
    END.
    ELSE
    IF KEYFUNCTION(LASTKEY) = "CURSOR-UP" THEN DO:
      FIND PREV qbf-z NO-ERROR.
      IF NOT AVAILABLE qbf-z THEN
        FIND FIRST qbf-z.
      ELSE
        IF FRAME-LINE = 1 THEN SCROLL DOWN. ELSE UP.
    END.
    ELSE
    IF CAN-DO("PAGE-UP,PAGE-DOWN",KEYFUNCTION(LASTKEY)) THEN DO:
      DO qbf-i = 1 TO qbf-y WHILE AVAILABLE qbf-z:
        IF KEYFUNCTION(LASTKEY) = "PAGE-UP" THEN
          FIND PREV qbf-z NO-ERROR.
        ELSE
          FIND NEXT qbf-z NO-ERROR.
      END.
      IF NOT AVAILABLE qbf-z THEN
        IF KEYFUNCTION(LASTKEY) = "PAGE-UP" THEN
          FIND FIRST qbf-z NO-ERROR.
        ELSE
          FIND LAST qbf-z NO-ERROR.
      qbf-w = TRUE.
    END.
    ELSE
    IF CAN-DO("HOME,MOVE",KEYFUNCTION(LASTKEY)) THEN DO:
      qbf-r = ROWID(qbf-z).
      FIND FIRST qbf-z.
      IF ROWID(qbf-z) = qbf-r THEN FIND LAST qbf-z.
      qbf-w = TRUE.
      UP FRAME-LINE - (IF qbf-r = ROWID(qbf-z) THEN 1 ELSE qbf-y).
    END.
    ELSE
    IF CAN-DO("GO,END-ERROR",KEYFUNCTION(LASTKEY)) THEN LEAVE.

  END.

END.

qbf-a = KEYFUNCTION(LASTKEY) = "GO".
IF qbf-e AND NOT qbf-a THEN
  RUN prores/s-box.p (INPUT-OUTPUT qbf-a,?,?,"#32").
  /*Do you want to save the changes you just made to the field list?*/
IF qbf-a THEN DO:
  ASSIGN
    qbf-i   = 0
    qbf-rcn = ""
    qbf-o   = ""
    qbf-rcl = ""
    qbf-rcf = ""
    qbf-rca = ""
    qbf-rcw = ?
    qbf-rct = 0.
  FOR EACH qbf-z
    WHERE qbf-z.qbf-d OR qbf-z.qbf-u OR qbf-z.qbf-q OR qbf-z.qbf-b
    BY qbf-z.qbf-s
    WHILE qbf-i < { prores/s-limcol.i }:
    ASSIGN
      qbf-i          = qbf-i + 1
      qbf-rcn[qbf-i] = qbf-z.qbf-n
      qbf-rct[qbf-i] = qbf-z.qbf-t
      qbf-rcw[qbf-i] = qbf-z.qbf-s
      qbf-rca[qbf-i] = STRING(qbf-z.qbf-d,"y/n")
                     + STRING(qbf-z.qbf-u,"y/n")
                     + STRING(qbf-z.qbf-q,"y/n")
                     + STRING(qbf-z.qbf-b,"y/n")
                     + STRING(qbf-z.qbf-a,"y/n")
      qbf-o          = qbf-o + (IF qbf-o = "" THEN "" ELSE ",") + qbf-z.qbf-n.
  END.
END.

HIDE FRAME qbf-edit NO-PAUSE.
HIDE MESSAGE NO-PAUSE.
/*
PUT SCREEN ROW SCREEN-LINES COLUMN 69 "---".
PUT SCREEN ROW SCREEN-LINES COLUMN 73 "--".
PUT SCREEN ROW SCREEN-LINES COLUMN 76 "---".
*/

{ prores/t-reset.i }
RETURN.
