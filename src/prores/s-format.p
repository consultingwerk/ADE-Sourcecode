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
/* s-format.p - set a field's attributes, such as format/label */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/t-define.i }
{ prores/t-set.i &mod=s &set=3 }

DEFINE INPUT PARAMETER qbf-w AS CHARACTER NO-UNDO. /* where called from */
DEFINE INPUT PARAMETER qbf-p AS INTEGER   NO-UNDO.
/*
qbf-w = "r" (report) or "d" (export)
qbf-p = qbf-rc?[] subscript or ? for choose list

If qbf-w = "r" and qbf-p = ? then we want to keep looping until end-error.
*/

DEFINE VARIABLE qbf-a AS LOGICAL              NO-UNDO.
DEFINE VARIABLE qbf-c AS CHARACTER            NO-UNDO.
DEFINE VARIABLE qbf-e AS CHARACTER            NO-UNDO.
DEFINE VARIABLE qbf-f AS CHARACTER            NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER              NO-UNDO.
DEFINE VARIABLE qbf-l AS LOGICAL              NO-UNDO.
DEFINE VARIABLE qbf-m AS CHARACTER EXTENT   8 NO-UNDO.
DEFINE VARIABLE qbf-o AS CHARACTER INITIAL "" NO-UNDO.
DEFINE VARIABLE qbf-t AS CHARACTER EXTENT   8 NO-UNDO.

qbf-a = (qbf-w = "r" AND qbf-p = ?). /* repeat until end-error */

{ prores/c-field.i
  &new=NEW &down=12 &row="ROW 4" &column="COLUMN 4" &title=qbf-f
}

/* qbf-lang[20]: 'Expression cannot be unknown value (?)' */

FORM
  qbf-t[1] FORMAT "x(25)" NO-ATTR-SPACE /*"Label:"*/
    qbf-rcl[qbf-p] FORMAT "x(32)"
    VALIDATE(qbf-rcl[qbf-p] <> ?,qbf-lang[20]) SKIP
  qbf-t[2] FORMAT "x(25)" NO-ATTR-SPACE /*"Format:"*/
    qbf-e FORMAT "x(32)"
    VALIDATE(qbf-e <> ?,qbf-lang[20]) SKIP
  qbf-t[8] FORMAT "x(25)" NO-ATTR-SPACE /*"Hide Repeating Values?"*/
    qbf-l VALIDATE(qbf-l <> ?,qbf-lang[20]) SKIP
  HEADER
  qbf-t[3]   FORMAT "x(25)" NO-ATTR-SPACE /*"Database:"*/
    qbf-m[3] FORMAT "x(32)" SKIP
  qbf-t[4]   FORMAT "x(25)" NO-ATTR-SPACE /*"File:"*/
    qbf-m[4] FORMAT "x(32)" SKIP
  qbf-t[5]   FORMAT "x(25)" NO-ATTR-SPACE /*"Field:"*/
    qbf-m[5] FORMAT "x(32)" SKIP
  qbf-t[6]   FORMAT "x(25)" NO-ATTR-SPACE /*"Expr:"*/
    qbf-m[6] FORMAT "x(32)" SKIP
  qbf-t[7]   FORMAT "x(25)" NO-ATTR-SPACE /*"Type:"*/
    qbf-m[7] FORMAT "x(32)" SKIP
  WITH FRAME qbf-r-options ROW 3 CENTERED OVERLAY NO-LABELS ATTR-SPACE
  TITLE COLOR NORMAL " " + qbf-lang[12] + " ". /*"Labels and Formats"*/
FORM
  qbf-t[2]   FORMAT "x(25)" NO-ATTR-SPACE /*"Format:"*/
    qbf-e FORMAT "x(32)"
    VALIDATE(qbf-e <> ?,qbf-lang[20]) SKIP
  HEADER
  qbf-t[3]   FORMAT "x(25)" NO-ATTR-SPACE /*"Database:"*/
    qbf-m[3] FORMAT "x(32)" SKIP
  qbf-t[4]   FORMAT "x(25)" NO-ATTR-SPACE /*"File:"*/
    qbf-m[4] FORMAT "x(32)" SKIP
  qbf-t[5]   FORMAT "x(25)" NO-ATTR-SPACE /*"Field:"*/
    qbf-m[5] FORMAT "x(32)" SKIP
  qbf-t[7]   FORMAT "x(25)" NO-ATTR-SPACE /*"Type:"*/
    qbf-m[7] FORMAT "x(32)" SKIP
  WITH FRAME qbf-d-options ROW 3 CENTERED OVERLAY NO-LABELS ATTR-SPACE
  TITLE COLOR NORMAL " " + qbf-lang[13] + " ". /*"Format"*/

DO WHILE TRUE:

  IF qbf-p = ? THEN DO:
    qbf-f = ' ' + qbf-lang[14] + ' '. /*Choose a Field*/
    RUN prores/s-field.p ("current","","*",INPUT-OUTPUT qbf-o).
    HIDE FRAME qbf-pick NO-PAUSE.
    IF qbf-o = "" THEN RETURN.
    IF qbf-o MATCHES "*~~.qbf-*" THEN
      qbf-o = SUBSTRING(qbf-o,INDEX(qbf-o,".qbf-") + 1).
    DO qbf-p = 1 TO qbf-rc#
      WHILE ENTRY(1,qbf-rcn[qbf-p]) <> qbf-o:
    END.
  END.

  ASSIGN
    qbf-i    = INDEX("rpcsdnle",SUBSTRING(qbf-rcc[qbf-p],1,1))
    qbf-o    = (IF qbf-i > 0 THEN ENTRY(qbf-i + 1,qbf-etype) + ".." ELSE "")
             + ENTRY(1,qbf-rcn[qbf-p])
    qbf-m[4] = SUBSTRING(qbf-o,INDEX(qbf-o,".") + 1)   /*file*/
    qbf-m[4] = SUBSTRING(qbf-m[4],1,INDEX(qbf-m[4],".") - 1)
    qbf-m[5] = SUBSTRING(qbf-o,R-INDEX(qbf-o,".") + 1) /*field*/
    qbf-m[3] = SUBSTRING(qbf-o,1,INDEX(qbf-o,".") - 1) /*db*/
    qbf-l    = (IF LENGTH(qbf-rca[qbf-p]) > 1 /*OR qbf-rcc[qbf-p] <> ""*/ THEN ?
               ELSE qbf-rca[qbf-p] = "&")

    /*qbf-lang[10]="FROM,BY,FOR"*/
    qbf-m[6] = (IF qbf-i = 1 OR qbf-i = 2 THEN ENTRY(2,qbf-rcn[qbf-p])
               ELSE IF qbf-i = 3 THEN
                 ENTRY(1,qbf-lang[10]) + " " + ENTRY(2,qbf-rcn[qbf-p])
                 + " " + ENTRY(2,qbf-lang[10]) + " "  + ENTRY(3,qbf-rcn[qbf-p])
               ELSE IF qbf-i = 8 THEN
                 qbf-o + "[1 " + ENTRY(3,qbf-lang[10]) + " "
                 + SUBSTRING(qbf-rcc[qbf-p],2) + "]"
               ELSE IF qbf-i > 0 THEN
                 SUBSTRING(qbf-rcn[qbf-p],INDEX(qbf-rcn[qbf-p],",") + 1)
               ELSE "")
    qbf-m[6] = (IF LENGTH(qbf-m[6]) <= 32 THEN qbf-m[6]
               ELSE SUBSTRING(qbf-m[6],1,29) + "...")
    qbf-m[7] = ENTRY(qbf-rct[qbf-p],qbf-dtype).

  IF qbf-m[3] <> "" AND qbf-m[4] = "" THEN
    ASSIGN
      qbf-o    = qbf-m[3]
      qbf-m[3] = qbf-m[4]
      qbf-m[4] = qbf-o.

  ASSIGN
    qbf-m[1] = (IF qbf-i = 0 THEN "" ELSE qbf-m[4] + ".")
             + ENTRY(1,qbf-rcn[qbf-p])

    qbf-t[1] = qbf-lang[15]                                 /*'Label'     */
    qbf-t[2] = qbf-lang[16]                                 /*'Format'    */
    qbf-t[3] = (IF qbf-m[3] = "" THEN "" ELSE qbf-lang[17]) /*'Database'  */
    qbf-t[4] = (IF qbf-m[4] = "" THEN "" ELSE qbf-lang[ 3]) /*'File'      */
    qbf-t[5] = qbf-lang[ 6]                                 /*'Field'     */
    qbf-t[6] = qbf-lang[ 7]                                 /*'Expression'*/
    qbf-t[7] = qbf-lang[18]                                 /*'Type'      */
    qbf-t[8] = (IF qbf-l = ? THEN "" ELSE       /*'Hide Repeating Values?'*/
               qbf-lang[9]).

  DO qbf-i = 1 TO 7:
    IF qbf-t[qbf-i] <> "" THEN
      qbf-t[qbf-i] = FILL(" ",24 - LENGTH(qbf-t[qbf-i])) + qbf-t[qbf-i] + ":".
  END.
  IF qbf-t[8] <> "" THEN qbf-t[8] = FILL(" ",25 - LENGTH(qbf-t[8])) + qbf-t[8].

  /* swap for European "." and "," */
  qbf-e = qbf-rcf[qbf-p].
  IF STRING(0,"9.") = "0," THEN
    RUN prores/d-extra.p (INPUT-OUTPUT qbf-e). 

  PAUSE 0.
  IF qbf-w = "r" THEN
    DISPLAY qbf-rcl[qbf-p] qbf-e qbf-t[1] qbf-t[2] qbf-t[8]
      qbf-l WHEN qbf-l <> ?
      WITH FRAME qbf-r-options.
  ELSE
    DISPLAY qbf-e qbf-t[2] WITH FRAME qbf-d-options.
  DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
    IF qbf-w = "r" THEN
      PROMPT-FOR
        qbf-rcl[qbf-p]
        qbf-e
        qbf-l WHEN qbf-l <> ?
        WITH FRAME qbf-r-options.
    ELSE
      PROMPT-FOR
        qbf-e
        WITH FRAME qbf-d-options.

    qbf-c = (IF qbf-w = "r" THEN
              INPUT FRAME qbf-r-options qbf-e
            ELSE
              INPUT FRAME qbf-d-options qbf-e).
    IF STRING(0,"9.") = "0," THEN
      RUN prores/d-extra.p (INPUT-OUTPUT qbf-c). 

    /* this code will generate an error if the format is bad. */
    /*1=char, 2=date, 3=log, 4/5=int/dec */
    qbf-c = (IF qbf-rct[qbf-p] = 1      THEN STRING(""   ,qbf-c)
             ELSE IF qbf-rct[qbf-p] = 2 THEN STRING(TODAY,qbf-c)
             ELSE IF qbf-rct[qbf-p] = 3 THEN STRING(TRUE ,qbf-c)
             ELSE /*numeric*/                STRING(0    ,qbf-c)).

    qbf-c = (IF qbf-w = "r" THEN
              INPUT FRAME qbf-r-options qbf-e
            ELSE
              INPUT FRAME qbf-d-options qbf-e).
    IF STRING(0,"9.") = "0," THEN
      RUN prores/d-extra.p (INPUT-OUTPUT qbf-c). 

    IF qbf-w = "r" THEN DO:
      IF qbf-l <> ? AND INPUT FRAME qbf-r-options qbf-l THEN
        qbf-rca[qbf-p] = "&".
      ELSE IF INDEX(qbf-rca[qbf-p],"&") > 0 THEN
        SUBSTRING(qbf-rca[qbf-p],INDEX(qbf-rca[qbf-p],"&"),1) = "".
      ASSIGN
        qbf-rcf[qbf-p] = qbf-c
        qbf-rcl[qbf-p] = INPUT FRAME qbf-r-options qbf-rcl[qbf-p].
    END.
    IF qbf-w = "d" THEN
      qbf-rcf[qbf-p] = qbf-c.

  END.

  HIDE FRAME qbf-r-options NO-PAUSE.
  HIDE FRAME qbf-d-options NO-PAUSE.
  IF KEYFUNCTION(LASTKEY) <> "END-ERROR" THEN DO:
    IF qbf-w = "r" THEN 
      RUN prores/r-label.p (qbf-rcl[qbf-p],qbf-rcf[qbf-p],qbf-rct[qbf-p],
                            OUTPUT qbf-rcw[qbf-p],OUTPUT qbf-i).
  END.
  IF KEYFUNCTION(LASTKEY) = "END-ERROR" OR NOT qbf-a THEN LEAVE.
  ASSIGN
    qbf-o = qbf-m[1]
    qbf-p = ?.
END.

{ prores/t-reset.i }
RETURN.
