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
/* a-join.p - maintain relations */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/c-form.i }
{ prores/t-define.i }
{ prores/s-edit.i NEW 20 }
{ prores/c-merge.i NEW }
{ prores/t-set.i &mod=a &set=8 }
{ prores/reswidg.i } /* must precede resfunc.i */
{ prores/resfunc.i }

DEFINE VARIABLE lReturn   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE qbf-1st   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE qbf-2nd   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE qbf-a     AS LOGICAL    NO-UNDO.
DEFINE VARIABLE qbf-c     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE qbf-claws AS CHARACTER  NO-UNDO. /* where clause */
DEFINE VARIABLE qbf-d     AS CHARACTER  NO-UNDO. /*deleted joins list*/
DEFINE VARIABLE qbf-g     AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-h     AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-i     AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-j     AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-k     AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-l     AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-o     AS INTEGER    NO-UNDO. /* orig qbf-join# */
DEFINE VARIABLE qbf-p     AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-t     AS CHARACTER  NO-UNDO EXTENT 2.
DEFINE VARIABLE qbf-w     AS CHARACTER  NO-UNDO. /* scrap */

/*message "[a-join.p]" view-as alert-box.*/

/* c-merge.i is included NEW, so empty qbf-schema temp-table */
EMPTY TEMP-TABLE qbf-schema.

FORM
  qbf-1st      FORMAT "x(64)" NO-ATTR-SPACE SKIP /*Relation of:*/
  qbf-2nd      FORMAT "x(64)" NO-ATTR-SPACE SKIP /*         to:*/
  qbf-lang[27] FORMAT "x(76)" NO-ATTR-SPACE SKIP
  /*Enter WHERE or OF clause: (leave blank to remove relation)*/
  WITH FRAME qbf-where NO-LABELS NO-BOX OVERLAY ATTR-SPACE ROW 14 COLUMN 2.

qbf-o = qbf-join#.

/* qbf-a & qbf-i are scrap in c-merge.p call below. */
RUN prores/c-merge.p ("*",TRUE,OUTPUT qbf-a,OUTPUT qbf-i).

/* map qbf-join onto qbf-schema */
RUN prores/c-map.p.

DO WHILE TRUE ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
  ASSIGN
    qbf-i    = MAXIMUM(LENGTH(qbf-lang[25]),LENGTH(qbf-lang[26]))
    qbf-t[1] = FILL(" ",qbf-i - LENGTH(qbf-lang[25])) + qbf-lang[25]
    qbf-t[2] = FILL(" ",qbf-i - LENGTH(qbf-lang[26])) + qbf-lang[26].
  DISPLAY
    qbf-t[1] + ":" @ qbf-1st  /*Relation of:*/
    qbf-t[2] + ":" @ qbf-2nd  /*         to:*/
    qbf-lang[27]
    WITH FRAME qbf-where.
  STATUS DEFAULT qbf-lang[28]. /*Press [END-ERROR] when done updating*/

  qbf-schema% = "".
  HIDE MESSAGE NO-PAUSE.
  PUT SCREEN ROW SCREEN-LINES + 1 COLUMN 1 COLOR MESSAGES
    qbf-lang[31]. /*"Enter first file of relation to add or remove."*/
  RUN prores/c-file.p ("?","l",OUTPUT qbf-1st).
  PUT SCREEN ROW SCREEN-LINES + 1 COLUMN 1 COLOR NORMAL FILL(" ",77).
  IF qbf-1st = "" THEN LEAVE.

  /*
  a) find qbf-1st in qbf-schema.
  b) for each ### in qbf-schema,
  c)   lookup join record.
  d)   get join filename
  e)   lookup join filename w/binsearch
  f)   substring(qbf-schema%,p,1) = "*".
  g) end.
  */
  ASSIGN
    qbf-schema% = FILL(" ",qbf-schema#)
    qbf-j       = INTEGER(ENTRY(1,qbf-1st))
    qbf-1st     = ENTRY(2,qbf-1st).
  {&FIND_QBF_SCHEMA} qbf-j.

  DISPLAY qbf-t[1] + ": " + qbf-1st @ qbf-1st WITH FRAME qbf-where.
  DO qbf-i = 3 TO NUM-ENTRIES(qbf-schema.cValue) - 1:
    {&FIND_QBF_JOIN} INTEGER(ENTRY(qbf-i,qbf-schema.cValue)) NO-ERROR.
    ASSIGN
      qbf-c = qbf-join.cValue
      qbf-c = ENTRY(IF ENTRY(1,qbf-c) = qbf-1st THEN 2 ELSE 1,qbf-c)
      qbf-c = SUBSTRING(qbf-c,INDEX(qbf-c,".") + 1) + ","
            + SUBSTRING(qbf-c,1,INDEX(qbf-c,".") - 1) + ",".

    FIND FIRST buf-schema WHERE buf-schema.cSort BEGINS qbf-c NO-ERROR.
    IF AVAILABLE buf-schema THEN
      SUBSTRING(qbf-schema%,buf-schema.iIndex,1) = "*".
  END.

  HIDE MESSAGE NO-PAUSE.
  PUT SCREEN ROW SCREEN-LINES + 1 COLUMN 1 COLOR MESSAGES
    qbf-lang[32]. /*"Now enter second file of relation."*/
  RUN prores/c-file.p ("?","r",OUTPUT qbf-2nd).
  PUT SCREEN ROW SCREEN-LINES + 1 COLUMN 1 COLOR NORMAL FILL(" ",77).
  IF qbf-2nd = "" THEN UNDO,RETRY.

  ASSIGN
    qbf-k   = INTEGER(ENTRY(1,qbf-2nd))
    qbf-2nd = ENTRY(2,qbf-2nd).
  DISPLAY qbf-t[2] + ": " + qbf-2nd @ qbf-2nd WITH FRAME qbf-where.
  HIDE MESSAGE NO-PAUSE.

  IF qbf-1st = qbf-2nd THEN DO:
    /*"Sorry, but at this time self-joins are not allowed."*/
    RUN prores/s-error.p ("#23").
    UNDO,RETRY.
  END.

  /*now find the qbf-join record that corresponds to qbf-1st and qbf-2nd.*/
  IF qbf-1st > qbf-2nd THEN
    ASSIGN
      qbf-c   = qbf-2nd     
      qbf-i   = qbf-j
      qbf-2nd = qbf-1st     
      qbf-j   = qbf-k
      qbf-1st = qbf-c       
      qbf-k   = qbf-i.

  ASSIGN
    qbf-c = qbf-1st + "," + qbf-2nd.
  FIND FIRST qbf-join WHERE qbf-join.cValue BEGINS qbf-c NO-ERROR.
  
  ASSIGN
    qbf-p     = IF AVAILABLE qbf-join THEN qbf-join.iIndex ELSE qbf-join# + 1
    lReturn   = getRecord("qbf-join":U, qbf-p)
    qbf-claws = qbf-join.cWhere.

  IF qbf-p <= qbf-join# AND qbf-p <> INTEGER(ENTRY(1,qbf-d)) THEN
    qbf-claws = (IF qbf-claws = "" THEN "OF " + qbf-1st
                 ELSE "WHERE " + qbf-claws).

  /* split the string into several elements */
  { prores/s-split.i &src=qbf-claws &dst=qbf-text &num=20 &len=72 &chr=" " }

  DISPLAY
    qbf-t[1] + ": " + qbf-1st @ qbf-1st
    qbf-t[2] + ": " + qbf-2nd @ qbf-2nd
    WITH FRAME qbf-where.

  ASSIGN
    qbf-g       = INDEX(qbf-1st,".")
    qbf-db[1]   = SUBSTRING(qbf-1st,1,qbf-g - 1)
    qbf-file[1] = SUBSTRING(qbf-1st,qbf-g + 1)
    qbf-g       = INDEX(qbf-2nd,".")
    qbf-db[2]   = SUBSTRING(qbf-2nd,1,qbf-g - 1)
    qbf-file[2] = SUBSTRING(qbf-2nd,qbf-g + 1)
    qbf-a       = FALSE.
    
  DO WHILE TRUE ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
    IF qbf-a = ? OR RETRY THEN
      DO qbf-i = qbf-text# TO 1 BY -1.
        IF qbf-text[qbf-i] <> "" THEN LEAVE.
      END.
    IF qbf-a = ? THEN
      qbf-text[qbf-i + 1] = "** " + qbf-lang[30].
      /*"The statement must begin with WHERE or OF."*/
    ELSE
    IF RETRY THEN DO:
      RUN prores/s-quoter.p (qbf-tempdir + ".d",qbf-tempdir + ".p").
      INPUT FROM VALUE(qbf-tempdir + ".p") NO-ECHO.
      REPEAT:
        IMPORT qbf-c.
        ASSIGN
          qbf-c = (IF qbf-c BEGINS "**" THEN "" ELSE "** ") + qbf-c
          qbf-g = INDEX(qbf-c,qbf-tempdir + ".p").
        IF qbf-g > 0 THEN SUBSTRING(qbf-c,qbf-g,6) = "".
        ASSIGN
          qbf-i           = qbf-i + 1
          qbf-text[qbf-i] = qbf-c.
      END.
      INPUT CLOSE.
    END.
    qbf-c = ?.
    RUN prores/s-edit.p (-16,"",OUTPUT qbf-a).
    IF NOT qbf-a THEN UNDO,LEAVE.
    qbf-claws = "".
    DO qbf-i = 1 TO qbf-text#:
      IF qbf-text[qbf-i] BEGINS "**" THEN qbf-text[qbf-i] = "".
      IF qbf-text[qbf-i] = "" THEN NEXT.
      qbf-claws = qbf-claws + " " + qbf-text[qbf-i].
    END.
    ASSIGN
      qbf-claws = TRIM(qbf-claws)
      qbf-a     = qbf-claws BEGINS "WHERE "
               OR qbf-claws BEGINS "OF "
               OR qbf-claws = "".
    IF qbf-claws = "" THEN LEAVE.
    IF qbf-a THEN DO:
      OUTPUT TO VALUE(qbf-tempdir + ".p") NO-ECHO NO-MAP.
      PUT UNFORMATTED
        'FIND FIRST ' qbf-1st '.' SKIP
        'FIND FIRST ' qbf-2nd ' ' qbf-claws '.' SKIP.
      OUTPUT CLOSE.
      ASSIGN
        qbf-c = SEARCH(qbf-tempdir + ".p")
        SUBSTRING(qbf-c,LENGTH(qbf-c),1) = "r".
      INPUT FROM VALUE(qbf-tempdir + ".p") NO-ECHO.
        /* input from is a dummy to suppress message to screen */
      OUTPUT TO VALUE(qbf-tempdir + ".d") NO-ECHO.
      DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
        COMPILE VALUE(qbf-tempdir + ".p") SAVE ATTR.
      END.
      OUTPUT CLOSE.
      INPUT CLOSE.
      IF qbf-c <> SEARCH(qbf-tempdir + ".r") THEN UNDO,RETRY.
      IF qbf-c <> ? THEN
        RUN prores/a-zap.p (qbf-c).
      LEAVE.
    END.
    ELSE
      qbf-a = ?.
  END.
  STATUS DEFAULT.
  IF NOT qbf-a THEN UNDO,RETRY.

  IF qbf-claws = "" THEN DO: /* deleted where clause */
    IF qbf-p <= qbf-join# AND qbf-p <> INTEGER(ENTRY(1,qbf-d)) THEN
      ASSIGN
        qbf-d           = qbf-d + (IF qbf-d = "" THEN "" ELSE ",")
                        + STRING(qbf-p).
    {&FIND_QBF_JOIN} qbf-p.
    ASSIGN
      qbf-join.cValue = ""
      qbf-join.cWhere = "".

    /* yank entries from entry(3+,qbf-schema.cValue) */
    {&FIND_QBF_SCHEMA} qbf-j.
    {&FIND_BUF_SCHEMA} qbf-k.
    ASSIGN
      qbf-c = "," + STRING(qbf-p)
      qbf-h = INDEX(qbf-schema.cValue,qbf-c + ",":U)
      qbf-i = INDEX(buf-schema.cValue,qbf-c + ",":U)
      SUBSTRING(qbf-schema.cValue,qbf-h,LENGTH(qbf-c)) = "".
      SUBSTRING(buf-schema.cValue,qbf-i,LENGTH(qbf-c)) = "".
  END.
  ELSE DO:
    /* add entries to entry(3+,qbf-schema.cValue) */
    IF qbf-p > qbf-join# OR qbf-p = INTEGER(ENTRY(1,qbf-d)) THEN DO:
      {&FIND_QBF_SCHEMA} qbf-j.
      {&FIND_BUF_SCHEMA} qbf-k.
      ASSIGN
        qbf-schema.cValue = qbf-schema.cValue + STRING(qbf-p) + ",":U
        buf-schema.cValue = buf-schema.cValue + STRING(qbf-p) + ",":U.
    END.

    /* clean out entry from deletion cache */
    IF qbf-p <= qbf-join# AND qbf-p = INTEGER(ENTRY(1,qbf-d)) THEN
      qbf-d = SUBSTRING(qbf-d,LENGTH(STRING(qbf-p)) + 2).

    {&FIND_QBF_JOIN} qbf-p.
    ASSIGN
      qbf-join.cValue = qbf-1st + ",":U + qbf-2nd
      qbf-join.cWhere = (IF qbf-claws BEGINS "OF" THEN "" /*"OF " + qbf-1st*/
                         ELSE TRIM(SUBSTRING(qbf-claws,6)))
      qbf-join#       = MAXIMUM(qbf-p,qbf-join#).
  END.

  HIDE FRAME qbf-where NO-PAUSE.

END.

ASSIGN
  qbf-db    = ""
  qbf-file  = ""
  qbf-j     = qbf-join#
  qbf-join# = 0.
DO qbf-i = 1 TO qbf-j:
  {&FIND_QBF_JOIN} qbf-i.
  IF qbf-join.cValue <> "" THEN DO:
    ASSIGN
      qbf-join#           = qbf-join# + 1
      qbf-c               = qbf-join.cValue
      qbf-w               = qbf-join.cWhere
      qbf-join.cValue     = ""
      qbf-join.cWhere     = "".
    {&FIND_BUF_JOIN} qbf-join#.
    ASSIGN
      buf-join.cValue = qbf-c
      buf-join.cWhere = qbf-w.
  END.
END.

IF qbf-join# >= 2 THEN DO: /* sort */
  REPEAT PRESELECT EACH qbf-join USE-INDEX iIndex:
    FIND NEXT qbf-join.
    qbf-join.iIndex = qbf-join.iIndex + 100000.
  END.
  qbf-i = 0.
  /* Reindex joins alphabetically */
  REPEAT PRESELECT EACH qbf-join USE-INDEX cValue:
    FIND NEXT qbf-join.
    ASSIGN
      qbf-i           = qbf-i + 1
      qbf-join.iIndex = qbf-i.
  END.
END.

HIDE FRAME qbf-where NO-PAUSE.
HIDE MESSAGE NO-PAUSE.
STATUS INPUT.
STATUS DEFAULT.

{ prores/t-reset.i }
RETURN.

/* a-join.p - end of file */
