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
/* a-read.p - read in .qc file for admin purposes */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/t-define.i }
{ prores/c-form.i }
{ prores/s-print.i }
{ prores/a-define.i }
{ prores/reswidg.i }
{ prores/resfunc.i }

DEFINE VARIABLE lReturn AS LOGICAL    NO-UNDO.
DEFINE VARIABLE qbf-c   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE qbf-h   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE qbf-i   AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-j   AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-l   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE qbf-m   AS CHARACTER  NO-UNDO EXTENT 11.
DEFINE VARIABLE qbf-q   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE qbf-r   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE qbf-s   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE qbf-v   AS CHARACTER  NO-UNDO.

DEFINE STREAM qbf-io.

EMPTY TEMP-TABLE qbf-form.
EMPTY TEMP-TABLE qbf-join.

/*message "[a-read.p]" view-as alert-box.*/

ASSIGN
  qbf-join#     = 0
  qbf-form#     = 0
  qbf-printer#  = 0
  qbf-r-head    = ""
  qbf-r-attr    = 0
  qbf-r-attr[1] = 1
  qbf-r-attr[2] = 66
  qbf-r-attr[3] = 1
  qbf-r-attr[4] = 1
  qbf-r-attr[5] = 1
  qbf-m-perm    = "*"
  qbf-q-perm    = "*"
  qbf-r         = "left-margin=,page-size=,column-spacing=,line-spacing=,"
                + "top-margin=,before-body=,after-body="
  qbf-h         = "first-only=,,,last-only=,,,"
                + "top-left=,,,top-center=,,,top-right=,,,"
                + "bottom-left=,,,bottom-center=,,,bottom-right="
  qbf-l         = "name=,addr1=,addr2=,addr3=,city=,"
                + "state=,zip=,zip+4=,csz=,country="
  qbf-q         = "next=,prev=,first=,last=,add=,update=,"
                + "copy=,delete=,view=,browse=,join=,query=,"
                + "where=,total=,order=,module=,info=,user="
  qbf-s         = "query=,report=,label=,data=,user=,admin="
  qbf-c         = SEARCH(qbf-qcfile + ".qc").

/* Some values are assumed to be already loaded by the initial call to 
   a-load.p */
INPUT STREAM qbf-io FROM VALUE(qbf-c) NO-ECHO.

REPEAT:
  qbf-m = "".
  IMPORT STREAM qbf-io qbf-m.
  IF INDEX(qbf-m[1],"=") = 0 OR qbf-m[1] BEGINS "#" THEN NEXT.

  IF qbf-m[1] = "message=" THEN DO:
    STATUS DEFAULT qbf-m[2].
    NEXT.
  END.

  IF qbf-m[1] BEGINS "version" THEN qbf-v = qbf-m[2].
  ELSE
  IF qbf-m[1] BEGINS "fastload" THEN DO:
    qbf-fastload = qbf-m[2].
    IF qbf-v = qbf-vers THEN DO:
      ASSIGN
        qbf-m[3] = qbf-m[2]
        SUBSTRING(qbf-m[2],LENGTH(qbf-m[2]) - 2,3) = "0.r"
        SUBSTRING(qbf-m[3],LENGTH(qbf-m[3]) - 3,4) = "99.r"
        qbf-m[2] = SEARCH(qbf-m[2])
        qbf-m[3] = SEARCH(qbf-m[3]).
      IF qbf-m[2] = ? OR qbf-m[3] = ? THEN NEXT.
      ASSIGN
        qbf-m[2] = SUBSTRING(qbf-m[2],1,LENGTH(qbf-m[2]) - 1)
        qbf-m[3] = SUBSTRING(qbf-m[3],1,LENGTH(qbf-m[3]) - 1).
      DO qbf-i = 0 TO 9:
        SUBSTRING(qbf-m[2],LENGTH(qbf-m[2]) - 1,1) = STRING(qbf-i).
        IF SEARCH(qbf-m[2] + "r") = qbf-m[2] + "r" THEN
          RUN VALUE(qbf-m[2] + "p") (TRUE).
        ELSE LEAVE.
      END.
      RUN VALUE(qbf-m[3] + "p") (TRUE).
      LEAVE.
    END.
  END.
  ELSE
  IF qbf-m[1] BEGINS "query-"
    AND CAN-DO(qbf-q,SUBSTRING(qbf-m[1],7)) THEN
    qbf-q-perm[LOOKUP(SUBSTRING(qbf-m[1],7),qbf-q)] = qbf-m[2].
  ELSE
  IF qbf-m[1] BEGINS "module-"
    AND CAN-DO(qbf-s,SUBSTRING(qbf-m[1],8)) THEN
    qbf-m-perm[LOOKUP(SUBSTRING(qbf-m[1],8),qbf-s)] = qbf-m[2].
  ELSE
  IF qbf-m[1] MATCHES "color-*=" THEN DO:
    DO qbf-i = 1 TO { prores/s-limtrm.i } - 1 WHILE qbf-t-name[qbf-i] <> "": END.
    ASSIGN
      qbf-t-name[qbf-i] = SUBSTRING(qbf-m[1],7,LENGTH(qbf-m[1]) - 7)
      qbf-t-hues[qbf-i] = qbf-m[2] + "," + qbf-m[3] + "," + qbf-m[4] + ","
                        + qbf-m[5] + "," + qbf-m[6] + "," + qbf-m[7].
  END.
  ELSE
  IF qbf-m[1] BEGINS "printer" AND LENGTH(qbf-m[1]) > 8 THEN
    ASSIGN
      qbf-printer#               = qbf-printer# + 1
      qbf-printer[qbf-printer#]  = qbf-m[2]
      qbf-pr-dev[qbf-printer#]   = qbf-m[3]
      qbf-pr-perm[qbf-printer#]  = (IF qbf-m[4] = "" THEN "*" ELSE qbf-m[4])
      qbf-pr-type[qbf-printer#]  = qbf-m[5]
      qbf-pr-width[qbf-printer#] = INTEGER(qbf-m[6])
      qbf-pr-init[qbf-printer#]  = qbf-m[7]
      qbf-pr-norm[qbf-printer#]  = qbf-m[8]
      qbf-pr-comp[qbf-printer#]  = qbf-m[9]
      qbf-pr-bon[qbf-printer#]   = qbf-m[10]
      qbf-pr-boff[qbf-printer#]  = qbf-m[11].
  ELSE
  IF CAN-DO("form*,view*",qbf-m[1]) THEN DO:
    /*  cValue format: "db.filename,progname,####" */
    IF INDEX(qbf-m[3],".") = 0 THEN
      qbf-m[3] = LDBNAME("RESULTSDB") + "." + qbf-m[3].
    ASSIGN
      qbf-i           = INDEX(qbf-m[3],".") + 1
      qbf-m[7]        = SUBSTRING(qbf-m[7],1,48)
      qbf-m[7]        = (IF  qbf-m[7] = SUBSTRING(qbf-m[3],qbf-i)
                          OR qbf-m[7] = SUBSTRING(qbf-c,1,48)
                         THEN "" ELSE qbf-m[7])
      qbf-m[2]        = (IF qbf-m[2] = SUBSTRING(qbf-m[3],qbf-i,8)
                         THEN "" ELSE qbf-m[2])
      qbf-form#       = qbf-form# + 1
      lReturn         = getRecord("qbf-form":U, qbf-form#)
      qbf-form.cValue = qbf-m[3] + "," + qbf-m[2] + "," +
                        STRING(qbf-form#,"9999")
      qbf-form.cDesc  = qbf-m[7]
      qbf-form.xValue = qbf-m[4].
  END.
  ELSE
  IF qbf-m[1] BEGINS "join" AND LENGTH(qbf-m[1]) > 5 THEN DO:
    IF INDEX(qbf-m[2],".") = 0 THEN
      qbf-m[2] = LDBNAME("RESULTSDB") + "." + qbf-m[2].
    IF INDEX(qbf-m[3],".") = 0 THEN
      qbf-m[3] = LDBNAME("RESULTSDB") + "." + qbf-m[3].
    ASSIGN
      qbf-join#       = qbf-join# + 1
      lReturn         = getRecord("qbf-join":U, qbf-join#)
      qbf-join.cValue = qbf-m[2] + "," + qbf-m[3]
      qbf-join.cWhere = (IF qbf-m[4] BEGINS "OF" THEN ""
                         ELSE SUBSTRING(qbf-m[4],7)).
  END.
  ELSE
  IF CAN-DO(qbf-r,qbf-m[1]) THEN
    ASSIGN
      qbf-i             = LOOKUP(qbf-m[1],qbf-r)
      qbf-r-attr[qbf-i] = INTEGER(qbf-m[2]).
  ELSE
  IF CAN-DO(qbf-h,qbf-m[1]) THEN
    ASSIGN
      qbf-i                 = LOOKUP(qbf-m[1],qbf-h)
      qbf-r-head[qbf-i    ] = qbf-m[2]
      qbf-r-head[qbf-i + 1] = qbf-m[3]
      qbf-r-head[qbf-i + 2] = qbf-m[4].

END.

INPUT STREAM qbf-io CLOSE.

/*--------------------------------------------------------------------------*/
/* now make sure what we loaded was good. */

ASSIGN
  qbf-j     = qbf-form#
  qbf-form# = 0.
DO qbf-i = 1 TO qbf-j:
  /*  format: "db.filename,progname,####" */
  {&FIND_QBF_FORM} qbf-i.
  RUN prores/s-lookup.p (ENTRY(1,qbf-form.cValue),"","","FILE:DESC",
                         OUTPUT qbf-c).
  IF qbf-c <> ? THEN DO:
    ASSIGN
      qbf-form#       = qbf-form# + 1.
    
    {&FIND_BUF_FORM} qbf-form#.
    ASSIGN
      buf-form.cValue = qbf-form.cValue
      buf-form.cDesc  = qbf-form.cDesc
      buf-form.xValue = qbf-form.xValue.
  END.
END.

ASSIGN
  qbf-j     = qbf-join#
  qbf-join# = 0.
DO qbf-i = 1 TO qbf-j:
  {&FIND_QBF_JOIN} qbf-i.
  RUN prores/s-lookup.p (ENTRY(1,qbf-join.cValue),"","","FILE:RECID",
                         OUTPUT qbf-c).
  IF qbf-c <> ? THEN
    RUN prores/s-lookup.p (ENTRY(2,qbf-join.cValue),"","","FILE:RECID",
                           OUTPUT qbf-c).
  IF qbf-c <> ? THEN DO:
    ASSIGN
      qbf-join#       = qbf-join# + 1.

    {&FIND_BUF_JOIN} qbf-join#.
    ASSIGN
      buf-join.cValue = qbf-join.cValue
      buf-join.cWhere = qbf-join.cWhere.
  END.
END.

IF SUBSTRING(qbf-v,1,3) <> SUBSTRING(qbf-vers,1,3) THEN
  RUN prores/a-update.p (TRUE).

STATUS DEFAULT.
RETURN.
