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
/* r-file.p - does dirty work for joins and file selection/de-selection */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/c-form.i }
{ prores/c-merge.i NEW }

DEFINE INPUT PARAMETER qbf-n AS INTEGER NO-UNDO.

DEFINE VARIABLE qbf-c AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-f AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-k AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-l AS LOGICAL   NO-UNDO.
DEFINE VARIABLE qbf-o AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-s AS INTEGER   NO-UNDO.

IF qbf-n = ? OR qbf-n < 0 THEN DO:
  IF qbf-n <> ? THEN DO:
    /* blank out extraneous file entries */
    DO qbf-j = 1 - qbf-n TO 5:
     ASSIGN
       qbf-db[qbf-j]    = ""
       qbf-file[qbf-j]  = ""
       qbf-where[qbf-j] = ""
       qbf-of[qbf-j]    = "".
    END.
    /* now re-attach where-clauses from files being moved around */
    DO qbf-j = 1 TO 5 WHILE qbf-file[qbf-j] <> "":
      DO qbf-k = 1 TO 5:
        IF qbf-db[qbf-j] + "." + qbf-file[qbf-j]
          <> ENTRY(1,qbf-asked[qbf-k]) THEN NEXT.
        qbf-where[qbf-j] =
          SUBSTRING(qbf-asked[qbf-k],INDEX(qbf-asked[qbf-k],",") + 1).
      END.
    END.
  END.
  ASSIGN
    qbf-j = 0
    qbf-f = qbf-db[1] + "." + qbf-file[1] + ","
          + qbf-db[2] + "." + qbf-file[2] + ","
          + qbf-db[3] + "." + qbf-file[3] + ","
          + qbf-db[4] + "." + qbf-file[4] + ","
          + qbf-db[5] + "." + qbf-file[5] + ",".
  /* handle fields for de-selected files */
  DO qbf-i = 1 TO qbf-rc#:
    ASSIGN
      qbf-c = ENTRY(IF INDEX(qbf-rcn[qbf-i],",") > 0 THEN 2 ELSE 1,
              qbf-rcn[qbf-i])
      qbf-c = (IF R-INDEX(qbf-c,".") = 0 THEN ""
              ELSE SUBSTRING(qbf-c,1,R-INDEX(qbf-c,".") - 1)).
    IF CAN-DO(qbf-f,qbf-c) OR CAN-DO("d*,l*,n*,s*",qbf-rcc[qbf-i]) THEN
      ASSIGN
        qbf-j          = qbf-j + 1
        qbf-rcn[qbf-j] = qbf-rcn[qbf-i]
        qbf-rcf[qbf-j] = qbf-rcf[qbf-i]
        qbf-rcl[qbf-j] = qbf-rcl[qbf-i]
        qbf-rca[qbf-j] = qbf-rca[qbf-i]
        qbf-rcc[qbf-j] = qbf-rcc[qbf-i]
        qbf-rct[qbf-j] = qbf-rct[qbf-i]
        qbf-rcw[qbf-j] = qbf-rcw[qbf-i].
  END.
  DO qbf-i = qbf-rc# + 1 TO { prores/s-limcol.i }:
    ASSIGN
      qbf-rcn[qbf-i] = ""
      qbf-rcf[qbf-i] = ""
      qbf-rcl[qbf-i] = ""
      qbf-rca[qbf-i] = ""
      qbf-rcc[qbf-i] = ""
      qbf-rct[qbf-i] = 0
      qbf-rcw[qbf-i] = 0.
  END.
  ASSIGN
    qbf-rc# = qbf-j
    qbf-j   = 0.
  /* handle order-by for de-selected files */
  DO qbf-i = 1 TO 5:
    IF CAN-DO(qbf-f,
      SUBSTRING(qbf-order[qbf-i],1,R-INDEX(qbf-order[qbf-i],".") - 1)) THEN
      ASSIGN
        qbf-j            = qbf-j + 1
        qbf-order[qbf-j] = qbf-order[qbf-i].
  END.
  DO qbf-i = qbf-j + 1 TO 5:
    qbf-order[qbf-i] = "".
  END.
  { prores/s-order.i } /* handle totals on deleted order-bys */
END.
ELSE DO: /*-----------------------------------------------------------------*/
  /* temporarily store where clauses in qbf-asked[].  this way, we can
  reassign where clauses to files even if repositioned in qbf-file[]
  array. */
  IF qbf-n = 1 THEN
    ASSIGN
      qbf-asked[1] = qbf-db[1] + "." + qbf-file[1] + "," + qbf-where[1]
      qbf-asked[2] = qbf-db[2] + "." + qbf-file[2] + "," + qbf-where[2]
      qbf-asked[3] = qbf-db[3] + "." + qbf-file[3] + "," + qbf-where[3]
      qbf-asked[4] = qbf-db[4] + "." + qbf-file[4] + "," + qbf-where[4]
      qbf-asked[5] = qbf-db[5] + "." + qbf-file[5] + "," + qbf-where[5].

  PAUSE 0.
  qbf-f = (IF qbf-n > 1 THEN qbf-db[1] + "." + qbf-file[1] + "," ELSE "")
        + (IF qbf-n > 2 THEN qbf-db[2] + "." + qbf-file[2] + "," ELSE "")
        + (IF qbf-n > 3 THEN qbf-db[3] + "." + qbf-file[3] + "," ELSE "")
        + (IF qbf-n > 4 THEN qbf-db[4] + "." + qbf-file[4]       ELSE "").
  RUN prores/c-file.p (qbf-f,"f",OUTPUT qbf-o).
  ASSIGN
    qbf-f           = qbf-db[qbf-n] + "," + qbf-file[qbf-n]
    qbf-db[qbf-n]   = ""
    qbf-file[qbf-n] = "".
  IF qbf-o = "" AND qbf-n = 1 THEN /*special case*/
    ASSIGN
      qbf-db[qbf-n]   = ENTRY(1,qbf-f)
      qbf-file[qbf-n] = ENTRY(2,qbf-f).
  IF qbf-o = "" THEN RETURN.
  ASSIGN
    qbf-f            = ENTRY(IF qbf-n = 1 THEN 1 ELSE 2,qbf-o)
    qbf-db[qbf-n]    = SUBSTRING(qbf-f,1,INDEX(qbf-f,".") - 1)
    qbf-file[qbf-n]  = SUBSTRING(qbf-f,INDEX(qbf-f,".") + 1)
    qbf-of[qbf-n]    = ""
    qbf-where[qbf-n] = "". /* added back later */

  IF qbf-n > 1 THEN DO:
    ASSIGN
      qbf-c         = SUBSTRING(qbf-o,INDEX(qbf-o,",") + 1)
      qbf-of[qbf-n] = SUBSTRING(qbf-c,INDEX(qbf-c,",") + 1). /*after 2nd comma*/
    /* OF <filename> stored as "" */
    IF qbf-of[qbf-n] = "" THEN qbf-of[qbf-n] = "OF " + ENTRY(1,qbf-o).
  END.
END.

RETURN.
