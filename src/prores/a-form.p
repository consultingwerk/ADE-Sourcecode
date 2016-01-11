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
/* a-form.p - manage query forms */

{ prores/s-system.i }
{ prores/t-define.i }
{ prores/s-define.i }
{ prores/c-form.i }
{ prores/a-define.i }
{ prores/c-merge.i NEW }
{ prores/reswidg.i }
{ prores/resfunc.i }

DEFINE INPUT PARAMETER qbf-w AS LOGICAL NO-UNDO.
/*
qbf-w = TRUE  - called from a-main (admin)
      = FALSE - called as part of manual build
*/

DEFINE VARIABLE lReturn AS LOGICAL    NO-UNDO.
DEFINE VARIABLE qbf-a   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE qbf-c   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE qbf-d   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE qbf-e   AS LOGICAL    NO-UNDO. /* query edited? */
DEFINE VARIABLE qbf-f   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE qbf-h   AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-i   AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-j   AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-k   AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-m   AS CHARACTER  NO-UNDO EXTENT 6.
DEFINE VARIABLE qbf-n   AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-p   AS CHARACTER  NO-UNDO EXTENT 4.
DEFINE VARIABLE qbf-q   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE qbf-t   AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-x   AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-y   AS LOGICAL    NO-UNDO. /* any edited? */
DEFINE VARIABLE qbf-z   AS CHARACTER  NO-UNDO EXTENT 7.

/*
     Database file name: ________________________________
              Form type: ________                         (default/user)
Query program file name: ________________________________ (.p assumed)
Form physical file name: ________________________________ (needs extension)
Frame name for 4GL code: ________________________________
            Description: ________________________________________________
qbf-file[1]
qbf-a-attr[3] VALIDATE 'Must be one of "default" "ft" or "user"'
qbf-q         VALIDATE 'A query program already exists with that name.'
qbf-a-attr[1] VALIDATE 'This form must already exist, or must end in .f '
                       + 'for automatic generation.'
qbf-a-attr[2] VALIDATE 'The name you picked for the 4GL form is reserved.  '
                       + 'Choose another.'
*/

/*message "[a-form.p]" view-as alert-box.*/

FORM
  qbf-lang[ 9]    FORMAT "x(23)" SPACE(0) ":"
    qbf-file[1]   FORMAT "x(52)" ATTR-SPACE SKIP
  qbf-lang[10]    FORMAT "x(23)" SPACE(0) ":"
    qbf-a-attr[3] FORMAT  "x(8)" ATTR-SPACE SPACE(26) "(default/user)" SKIP
  qbf-lang[11]    FORMAT "x(23)" SPACE(0) ":"
    qbf-q         FORMAT "x(32)" ATTR-SPACE qbf-lang[15] FORMAT "x(17)" SKIP
  qbf-lang[12]    FORMAT "x(23)" SPACE(0) ":"
    qbf-a-attr[1] FORMAT "x(32)" ATTR-SPACE qbf-lang[16] FORMAT "x(17)" SKIP
  qbf-lang[13]    FORMAT "x(23)" SPACE(0) ":"
    qbf-a-attr[2] FORMAT "x(32)" ATTR-SPACE SKIP
  qbf-lang[14]    FORMAT "x(23)" SPACE(0) ":"
    qbf-name      FORMAT "x(48)" ATTR-SPACE SKIP
  WITH FRAME qbf-filer ROW 10 COLUMN 2 NO-BOX NO-ATTR-SPACE OVERLAY NO-LABELS.
FORM
  qbf-file[1]
  qbf-a-attr[3]
  qbf-q         VALIDATE(qbf-n <= qbf-form# OR SEARCH(qbf-q + ".p") = ?,
                  qbf-lang[19])
  qbf-a-attr[1] VALIDATE(SEARCH(qbf-a-attr[1]) <> ?
                  OR qbf-a-attr[1] MATCHES "*~.f",qbf-lang[20])
  qbf-a-attr[2] VALIDATE(KEYWORD(qbf-a-attr[2]) = ? AND qbf-a-attr[2] <> ""
                  AND qbf-a-attr[2] <> ? AND NOT qbf-a-attr[2] BEGINS "qbf-",
                  qbf-lang[21])
  WITH FRAME qbf-filer.

FORM
  /*1:"Permissions:"*/
  /*2:"    *                   - All users are allowed access."              */
  /*3:"    <user>,<user>,etc.  - Only these users have access."              */
  /*4:"    !<user>,!<user>,*   - All except these users have access."        */
  /*5:"    acct*               - Only users that begin with ~"acct~" allowed"*/
  /*6:"List users by their login IDs, and separate them with commas."        */
  /*7:"IDs may contain wildcards.  Use exclamation marks to exclude users."  */
  qbf-z[1] FORMAT "x(78)" NO-ATTR-SPACE SKIP
  qbf-p[1] FORMAT "x(76)" SKIP
  qbf-p[2] FORMAT "x(76)" SKIP
  qbf-p[3] FORMAT "x(76)" SKIP
  qbf-p[4] FORMAT "x(76)" SKIP
  qbf-z[2] FORMAT "x(78)" NO-ATTR-SPACE SKIP
  qbf-z[3] FORMAT "x(78)" NO-ATTR-SPACE SKIP
  qbf-z[4] FORMAT "x(78)" NO-ATTR-SPACE SKIP
  qbf-z[5] FORMAT "x(78)" NO-ATTR-SPACE SKIP
  qbf-z[6] FORMAT "x(78)" NO-ATTR-SPACE SKIP
  qbf-z[7] FORMAT "x(78)" NO-ATTR-SPACE SKIP
  WITH FRAME qbf-perm ROW 10 COLUMN 2 NO-BOX ATTR-SPACE NO-LABELS OVERLAY.

/*
qbf-form.cValue = "_db-name._file-name,dotpname,numb"
qbf-form.xValue = can-do list for permissions
NOTE: See c-form.i for more details about qbf-form structure.
*/

{ prores/t-set.i &mod=a &set=5 }
ASSIGN
  qbf-z[1]   = qbf-lang[1] + ":" /* can-do and permissions explanation */
  qbf-z[2]   = qbf-lang[2]
  qbf-z[3]   = qbf-lang[3]
  qbf-z[4]   = qbf-lang[4]
  qbf-z[5]   = qbf-lang[5]
  qbf-z[6]   = qbf-lang[6]
  qbf-z[7]   = qbf-lang[7]
  qbf-a-attr = "".
{ prores/t-set.i &mod=a &set=9 }

RUN prores/s-zap.p.

/*
  " A. Add New Query Form "
  " C. Choose Query Form to Edit "
  " G. General Form Characteristics "
  " W. Which Fields on Form "
  " P. Permissions "
  " D. Delete Current Query Form "
*/
DISPLAY
  qbf-lang[7]           @ qbf-p[1] FORMAT "x(10)" /*"Select:"*/
            qbf-lang[1] @ qbf-m[1] FORMAT "x(45)" SKIP /*Add*/
  SPACE(13) qbf-lang[2] @ qbf-m[2] FORMAT "x(45)" SKIP /*Choose*/
  qbf-lang[8]           @ qbf-p[2] FORMAT "x(10)" /*"Update:"*/
            qbf-lang[3] @ qbf-m[3] FORMAT "x(45)" SKIP /*General*/
  SPACE(13) qbf-lang[4] @ qbf-m[4] FORMAT "x(45)" SKIP /*Fields*/
  SPACE(13) qbf-lang[5] @ qbf-m[5] FORMAT "x(45)" SKIP /*Perms*/
  SPACE(13) qbf-lang[6] @ qbf-m[6] FORMAT "x(45)" SKIP /*Delete*/
  WITH FRAME qbf-menu ROW 3 COLUMN 2 NO-BOX ATTR-SPACE NO-LABELS OVERLAY.
COLOR DISPLAY MESSAGES qbf-p[1 FOR 2] WITH FRAME qbf-menu.
DISPLAY qbf-lang[9 FOR 8] WITH FRAME qbf-filer.

ON CURSOR-UP BACK-TAB. ON CURSOR-DOWN TAB.

DO WHILE TRUE ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:

  IF qbf-schema% = ? OR qbf-schema# = 0 THEN DO:
    ASSIGN
      qbf-schema# = 0.
    EMPTY TEMP-TABLE qbf-schema.

    /* qbf-i and qbf-a are scrap in next line. */
    RUN prores/c-merge.p ("$*",TRUE,OUTPUT qbf-a,OUTPUT qbf-i).

    /* Contains "*" in position of qbf-schema[qbf-schema#] names a file used
       in a form, or " " if the file is currently "unformed" */
    qbf-schema% = FILL(" ",qbf-schema#).
    FOR EACH qbf-schema:
      ASSIGN
        qbf-f = ENTRY(2,qbf-schema.cValue) + "." + ENTRY(1,qbf-schema.cValue)
        qbf-k = -1.
      FOR EACH qbf-form:
        IF ENTRY(1, qbf-form.cValue) = qbf-f THEN DO:
          qbf-k = qbf-form.iIndex.
          LEAVE.
        END.
      END.
      IF qbf-k <> -1 THEN 
        SUBSTRING(qbf-schema%,qbf-schema.iIndex,1) = "*".
    END.
  END.

  IF qbf-q = "" OR qbf-n = 0 THEN qbf-name = "".
  IF qbf-q = "" OR qbf-q = "*" OR qbf-n = 0 THEN
    ASSIGN
      qbf-n         = 0
      qbf-q         = ""
      qbf-db[1]     = ""
      qbf-file[1]   = ""
      qbf-a-attr    = ""
      qbf-a-attr[3] = ?
      qbf-rc#       = 0.
  DISPLAY qbf-q qbf-name qbf-a-attr[1 FOR 3]
    qbf-db[1] + "." + qbf-file[1] @ qbf-file[1]
    WITH FRAME qbf-filer.
  IF qbf-q = "" THEN 
    qbf-name = "".
  qbf-x = 0.
  STATUS DEFAULT qbf-lang[23]. /*Press [END-ERROR] when done updating*/
  DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
    COLOR DISPLAY NORMAL qbf-m[1 FOR 6] WITH FRAME qbf-menu.
    IF qbf-n > 0 THEN 
      NEXT-PROMPT qbf-m[3] WITH FRAME qbf-menu.
    IF qbf-n = 0 THEN
      CHOOSE FIELD qbf-m[1 FOR 2] AUTO-RETURN WITH FRAME qbf-menu.
    ELSE
      CHOOSE FIELD qbf-m[1 FOR 6] AUTO-RETURN WITH FRAME qbf-menu.
    qbf-x = FRAME-INDEX.
  END.
  STATUS DEFAULT.
  ON CURSOR-UP CURSOR-UP. ON CURSOR-DOWN CURSOR-DOWN.
  COLOR DISPLAY NORMAL qbf-name WITH FRAME qbf-filer.

  IF qbf-n > 0 AND qbf-x < 3 THEN DO:
    IF qbf-x = 0 THEN 
      COLOR DISPLAY NORMAL qbf-m[1 FOR 6] WITH FRAME qbf-menu.
    MESSAGE qbf-lang[24]. /*Saving form information in query form cache...*/

    IF qbf-form# >= 2 THEN DO: 
      /* Move index 'out of bounds' temporarily */
      REPEAT PRESELECT EACH qbf-form USE-INDEX iIndex:
        FIND NEXT qbf-form.
        qbf-form.iIndex = qbf-form.iIndex + 100000.
      END.
      qbf-i = 0.
      /* Reindex based on cValue */
      REPEAT PRESELECT EACH qbf-form USE-INDEX cValue:
        FIND NEXT qbf-form.
        ASSIGN
          qbf-i           = qbf-i + 1
          qbf-form.iIndex = qbf-i.
      END.
    END. /* end of sort */

    FOR EACH qbf-form:
      ENTRY(3, qbf-form.cValue) = STRING(qbf-form.iIndex,"9999").
    END.

    IF qbf-q = "" THEN 
      qbf-e = FALSE. /* if form not just deleted! */

    IF qbf-e AND qbf-a-attr[3] = "default" THEN DO:
      HIDE MESSAGE NO-PAUSE.
      MESSAGE qbf-lang[30]. /*Writing out query form...*/
      qbf-c = "".
      DO qbf-i = 1 TO { prores/s-limcol.i } 
        WHILE qbf-rcn[qbf-i] <> "":
        /*qbf-rca[]: display,update,query,browse,isarray?*/
        IF NOT qbf-rca[qbf-i] BEGINS "nnn" THEN
          qbf-c = qbf-c + (IF qbf-c = "" THEN "" ELSE ",") + qbf-rcn[qbf-i].
      END.
      RUN prores/f-write.p (qbf-c).
    END.

    IF qbf-e THEN DO:
      /* If we think the form changed, then just blow away .r.  Running 
         b-again.p will fix things up later. */
      RUN prores/q-write.p (qbf-q).
      ASSIGN
        qbf-y = TRUE
        qbf-c = SEARCH(qbf-q + ".r").
      IF qbf-c <> ? THEN RUN 
        prores/a-zap.p (qbf-c).
    END.

  END.

  IF qbf-x = 0 THEN LEAVE.
  ELSE
  IF qbf-x = 1 THEN DO: /* Add New Query Form */
    ASSIGN
      qbf-k = 0
      qbf-n = 0.
    RUN prores/c-flag.p (INPUT-OUTPUT qbf-k).
    IF qbf-k = 0 THEN NEXT.
    RUN prores/s-zap.p.

    {&FIND_QBF_SCHEMA} qbf-k.
    RUN prores/a-lookup.p (ENTRY(2,qbf-schema.cValue),
                           ENTRY(1,qbf-schema.cValue),"","q",OUTPUT qbf-c).
    IF qbf-c = "NONE" THEN DO:
      /* Cannot build query form for this file.  In order to build a 
         query form, either the gateway must support RECIDs or there 
         must be a unique index on the file. */
      RUN prores/s-error.p ("#32").
      NEXT.
    END.

    ASSIGN
      qbf-e = TRUE
      qbf-c = ENTRY(2,qbf-schema.cValue) + "." + ENTRY(1,qbf-schema.cValue)
      qbf-d = SUBSTRING(qbf-schema.cValue,INDEX(qbf-schema.cValue,"|") + 1)
      qbf-q = SUBSTRING(qbf-c,INDEX(qbf-c,".") + 1,8)
      SUBSTRING(qbf-schema%,qbf-k,1) = " ":U.
    DO WHILE SEARCH(qbf-q + ".p") <> ? OR SEARCH(qbf-q + ".i") <> ?
      OR     SEARCH(qbf-q + ".f") <> ? OR SEARCH(qbf-q + ".r") <> ?:
      ASSIGN
        qbf-t = qbf-t + 1
        qbf-q = "qry" + STRING(qbf-t,"99999").
    END.

    RUN prores/s-lookup.p (qbf-c,"","","FILE:DESC",OUTPUT qbf-d).

    ASSIGN
      qbf-n           = qbf-form# + 1
      qbf-name        = (IF qbf-d <> "" THEN qbf-d
                        ELSE SUBSTRING(qbf-c,INDEX(qbf-c,".") + 1)).

    ASSIGN
      lReturn         = getRecord("qbf-form":U, qbf-n)
      qbf-form.cValue = qbf-c + ","
                      + (IF qbf-q = SUBSTRING(qbf-c,INDEX(qbf-c,".") + 1,8)
                        THEN "" ELSE qbf-q) + "," + STRING(qbf-n,"9999")
      qbf-form.cDesc  = qbf-name
      qbf-db[1]       = SUBSTRING(qbf-c,1,INDEX(qbf-c,".") - 1)
      qbf-file[1]     = SUBSTRING(qbf-c,INDEX(qbf-c,".") + 1)
      qbf-a-attr[1]   = qbf-q + ".f"
      qbf-a-attr[2]   = LC(qbf-file[1]) /* form name */
      qbf-a-attr[3]   = ?
      qbf-rc#         = 0
      qbf-c           = "*".
    RUN prores/s-lookup.p (qbf-db[1],qbf-file[1],"","FILE:CAN-READ",
                           OUTPUT qbf-form.xValue).
    RUN prores/f-guess.p  (TRUE,INPUT-OUTPUT qbf-c).
    RUN prores/a-lookup.p (qbf-db[1],qbf-file[1],qbf-c,"f",OUTPUT qbf-c).
  END.
  ELSE
  IF qbf-x = 2 THEN DO: /* Choose Query Form To Edit */
    ASSIGN
      qbf-e = FALSE
      qbf-f = "".
    RUN prores/c-form.p ("r004c020",INPUT-OUTPUT qbf-f).
    IF qbf-f = "" THEN NEXT.
    ASSIGN
      qbf-n       = INTEGER(ENTRY(3,qbf-f)).

    {&FIND_QBF_FORM} qbf-n.
    ASSIGN
      qbf-c       = ENTRY(1,qbf-form.cValue)
      qbf-db[1]   = SUBSTRING(qbf-c,1,INDEX(qbf-c,".") - 1)
      qbf-file[1] = SUBSTRING(qbf-c,INDEX(qbf-c,".") + 1)
      qbf-q       = (IF ENTRY(2,qbf-form.cValue) = ""
                     THEN SUBSTRING(qbf-file[1],1,8)
                     ELSE ENTRY(2,qbf-form.cValue))
      qbf-c       = (IF INDEX(qbf-c,".") = 0 THEN LDBNAME("RESULTSDB")
                    ELSE SUBSTRING(qbf-c,1,INDEX(qbf-c,".") - 1)).
    CREATE ALIAS "QBF$0" FOR DATABASE VALUE(SDBNAME(qbf-c)).
    RUN prores/q-read.p (qbf-q).
  END.
  /* no ELSE here! */
  DISPLAY qbf-q qbf-name qbf-a-attr[1 FOR 3]
    qbf-db[1] + "." + qbf-file[1] @ qbf-file[1]
    WITH FRAME qbf-filer.
    
  IF qbf-x <= 3 THEN DO: /* General Form Characteristics */
    DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
      SET
        qbf-q         WHEN qbf-x = 1
        qbf-a-attr[1] WHEN qbf-x = 1
        qbf-a-attr[2]
        qbf-name
        WITH FRAME qbf-filer
          EDITING:
            READKEY.
            APPLY (IF KEYFUNCTION(LASTKEY) = "END-ERROR"
              THEN KEYCODE(KBLABEL("GO")) ELSE LASTKEY).
          END.

      qbf-c = qbf-a-attr[2].
      IF INDEX("abcdefghijklmnopqrstuvwxyz",SUBSTRING(qbf-c,1,1)) = 0
        THEN qbf-c = "f_" + SUBSTRING(qbf-c,1,30).
      DO qbf-i = 2 TO LENGTH(qbf-c):
        IF INDEX("abcdefghijklmnopqrstuvwxyz-_1234567890",
          SUBSTRING(qbf-c,qbf-i,1)) = 0
          THEN SUBSTRING(qbf-c,qbf-i,1) = "_".
      END.

      IF   FRAME qbf-filer qbf-q ENTERED
        OR FRAME qbf-filer qbf-a-attr[1] ENTERED
        OR FRAME qbf-filer qbf-a-attr[2] ENTERED OR qbf-a-attr[2] <> qbf-c
        OR FRAME qbf-filer qbf-name ENTERED THEN qbf-e = TRUE.
      qbf-a-attr[2] = qbf-c.

      IF qbf-x = 1 AND KEYFUNCTION(LASTKEY) = "END-ERROR" THEN DO:
        qbf-n = 0.
        UNDO,LEAVE.
      END.

      IF qbf-x = 1 THEN DO:
        IF SEARCH(qbf-a-attr[1]) = ? THEN DO:
          ASSIGN
            qbf-a = TRUE
            qbf-c = qbf-lang[26]
            SUBSTRING(qbf-c,INDEX(qbf-c,"~{1~}"),3) = qbf-a-attr[1].
          /*No query form called "~{1~}" could be found.*/
          /*Do you want one to be generated?*/
          RUN prores/s-box.p (INPUT-OUTPUT qbf-a,?,?,qbf-c).
          IF KEYFUNCTION(LASTKEY) = "END-ERROR" THEN DO:
            qbf-n = 0.
            UNDO,LEAVE.
          END.
          IF NOT qbf-a THEN UNDO,RETRY.
          qbf-c = "*".
          RUN prores/f-guess.p (TRUE,INPUT-OUTPUT qbf-c).
        END.
        ELSE DO:
          ASSIGN
            qbf-a = TRUE
            qbf-c = qbf-lang[27]
            SUBSTRING(qbf-c,INDEX(qbf-c,"~{1~}"),3) = qbf-a-attr[1].
          /*A query form called "~{1~}" exists.  Use fields from this form?*/
          RUN prores/s-box.p (INPUT-OUTPUT qbf-a,?,?,qbf-c).
          IF NOT qbf-a THEN UNDO,RETRY.
          RUN prores/f-read.p (OUTPUT qbf-c).
          DISPLAY qbf-a-attr[2] WITH FRAME qbf-filer.
        END.
        RUN prores/f-browse.p
          (qbf-db[1],qbf-file[1],qbf-c,OUTPUT qbf-f).
        DO qbf-i = 1 TO { prores/s-limcol.i } WHILE qbf-rcn[qbf-i] <> "":
          ASSIGN
            qbf-j          = LOOKUP(qbf-rcn[qbf-i],qbf-c)
            qbf-rcw[qbf-i] = qbf-j * 10
            qbf-rca[qbf-i] = STRING(qbf-j > 0,"yy/nn")
                           + STRING(SUBSTRING(qbf-rca[qbf-i],5,1) = "n"
                             AND qbf-j > 0,"y/n")
                           + STRING(CAN-DO(qbf-f,qbf-rcn[qbf-i]),"y/n")
                           + SUBSTRING(qbf-rca[qbf-i],5,1).
        END.
      END.

      RUN prores/s-lookup.p (qbf-db[1],qbf-file[1],"","FILE:DESC",
                             OUTPUT qbf-d).
      ASSIGN
        qbf-form#       = MAXIMUM(qbf-form#,qbf-n)
        qbf-a-attr[3]   = (IF qbf-a-attr[3] <> ? THEN qbf-a-attr[3]
                           ELSE IF SEARCH(qbf-a-attr[1]) = ? THEN "default"
                           ELSE "user")
        qbf-d           = SUBSTRING(qbf-d,1,48).

      {&FIND_QBF_FORM} qbf-n.
      ASSIGN
        qbf-form.cValue = qbf-db[1] + "." + qbf-file[1] + ","
                        + (IF qbf-q = SUBSTRING(qbf-file[1],1,8)
                          THEN "" ELSE qbf-q) + ",0000":U
        qbf-form.cDesc  = (IF qbf-name = qbf-d THEN "" ELSE qbf-name).
    END.
    IF qbf-x = 1 AND qbf-n > 0 THEN qbf-x = 4.
  END.

  IF qbf-x = 4 THEN 
  DO WHILE TRUE: /* Which Fields on Form */
    HIDE FRAME qbf-menu NO-PAUSE.
    HIDE FRAME qbf-filer NO-PAUSE.
    RUN prores/a-field.p (OUTPUT qbf-a,OUTPUT qbf-c).
    qbf-e = qbf-e OR qbf-a.
    RUN prores/f-guess.p (FALSE,INPUT-OUTPUT qbf-c).
    IF INTEGER(qbf-a-attr[4]) > 17 THEN DO:
      ASSIGN
        qbf-a                                   = TRUE
        qbf-c                                   = qbf-lang[18]
        SUBSTRING(qbf-c,INDEX(qbf-c,"~{1~}"),3) =
          STRING(INTEGER(qbf-a-attr[4]) + 2).
      RUN prores/s-box.p (INPUT-OUTPUT qbf-a,?,?,qbf-c).
      /* This form is {1} lines long. Since RESULTS reserves five lines for
         its own use, this will exceed the screen size of a 24x80 terminal.  
         Are you sure you want to define a form this large? */
      IF NOT qbf-a THEN NEXT.
    END.
    VIEW FRAME qbf-filer.
    VIEW FRAME qbf-menu.
    LEAVE.
  END.
  ELSE
  IF qbf-x = 5 THEN DO: /* Permissions */
    HIDE FRAME qbf-filer NO-PAUSE.
    {&FIND_QBF_FORM} qbf-n.
    ASSIGN
      qbf-p[1] = qbf-form.xValue
      qbf-p[2] = ""
      qbf-p[3] = ""
      qbf-p[4] = "".
    DO qbf-j = 1 TO 3 WHILE LENGTH(qbf-p[qbf-j]) > 76:
      DO qbf-i = 76 TO 1 BY -1
        WHILE SUBSTRING(qbf-p[qbf-j],qbf-i,1) <> ",":
      END.
      ASSIGN
        qbf-i            = (IF qbf-i = 0 THEN 76 ELSE qbf-i)
        qbf-p[qbf-j + 1] = SUBSTRING(qbf-p[qbf-j],qbf-i + 1)
        qbf-p[qbf-j    ] = SUBSTRING(qbf-p[qbf-j],1,qbf-i).
    END.
    DISPLAY qbf-z[1 FOR 7] WITH FRAME qbf-perm.
    DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
      UPDATE qbf-p[1] qbf-p[2] qbf-p[3] qbf-p[4] WITH FRAME qbf-perm.
      IF qbf-p[2] <> "" AND NOT qbf-p[1] MATCHES "*," THEN
        qbf-p[1] = qbf-p[1] + ",".
      IF qbf-p[3] <> "" AND NOT qbf-p[2] MATCHES "*," THEN
        qbf-p[2] = qbf-p[2] + ",".
      IF qbf-p[4] <> "" AND NOT qbf-p[3] MATCHES "*," THEN
        qbf-p[3] = qbf-p[3] + ",".
      qbf-c = qbf-p[1] + qbf-p[2] + qbf-p[3] + qbf-p[4].
      IF qbf-c MATCHES "*," THEN 
        qbf-c = SUBSTRING(qbf-c,1,LENGTH(qbf-c) - 1).
      qbf-form.xValue = qbf-c.
    END.
    HIDE FRAME qbf-perm NO-PAUSE.
    VIEW FRAME qbf-filer.
  END.
  ELSE
  IF qbf-x = 6 OR qbf-x = -6 THEN DO: /* Delete Current Query Form */
    IF qbf-form# = 0 THEN UNDO,RETRY. /* should never be executed! */
    qbf-a = (qbf-x = -6).
    IF NOT qbf-a THEN 
      RUN prores/s-box.p (INPUT-OUTPUT qbf-a,?,?,
                          qbf-lang[28] + ' "' + qbf-q + '"?').
      /*Are you sure that you want to delete query form "<name>"?*/
    IF qbf-a THEN DO:
      DO qbf-i = qbf-n TO (qbf-form# - 1):
        {&FIND_QBF_FORM} qbf-i.
        {&FIND_BUF_FORM} qbf-i + 1.
        ASSIGN
          qbf-form.cValue           = buf-form.cValue
          qbf-form.cDesc            = buf-form.cDesc 
          qbf-form.xValue           = buf-form.xValue
          ENTRY(3, qbf-form.cValue) = STRING(qbf-i,"9999").
      END.
      ASSIGN
        qbf-form#     = qbf-form# - 1
        qbf-n         = MINIMUM(qbf-n,qbf-form#)
        qbf-schema%   = ? /* regrab file list with "*"'s */
        qbf-m         = ?.

      /* delete associated files */
      IF qbf-a-attr[3] = "default" THEN 
        qbf-m[4] = SEARCH(qbf-a-attr[1]).
      ASSIGN
        qbf-c    = SEARCH(qbf-q + ".r")
        qbf-m[1] = SEARCH(SUBSTRING(qbf-c,1,LENGTH(qbf-c) - 1) + "p")
        qbf-m[2] = SEARCH(SUBSTRING(qbf-c,1,LENGTH(qbf-c) - 1) + "i").
      IF qbf-c <> ? AND qbf-m[1] <> ? AND qbf-m[2] <> ? THEN
        qbf-m[3] = qbf-c.
      ELSE
        ASSIGN
          qbf-m[1] = ? 
          qbf-m[2] = ?.
      qbf-c = (IF qbf-m[1] = ? THEN "" ELSE qbf-m[1]) + ","
            + (IF qbf-m[2] = ? THEN "" ELSE qbf-m[2]) + ","
            + (IF qbf-m[3] = ? THEN "" ELSE qbf-m[3]) + ","
            + (IF qbf-m[4] = ? THEN "" ELSE qbf-m[4]).
      RUN prores/a-zap.p (qbf-c).
      /* the above section of code is also in b-again.p */

      COLOR DISPLAY MESSAGES qbf-name WITH FRAME qbf-filer.
      ASSIGN
        qbf-a-attr  = ""
        qbf-file[1] = ""
        qbf-db[1]   = ""
                    /*'** Query program "~{1~}" deleted. **'*/
        qbf-name    = qbf-lang[29]
        SUBSTRING(qbf-name,INDEX(qbf-name,"~{1~}"),3) = qbf-q
        qbf-q       = "*" /* deletion marker */
        qbf-n       = 0.
    END.
    qbf-x = 6.
  END.

  HIDE MESSAGE NO-PAUSE.
END.

ON CURSOR-UP CURSOR-UP. ON CURSOR-DOWN CURSOR-DOWN.

/* You have changed at least one query form.  You can either compile the */
/* changed form now, or do an "Application Rebuild" later.  Compile now? */
qbf-y = qbf-y AND qbf-w.
IF qbf-y THEN
  RUN prores/s-box.p (INPUT-OUTPUT qbf-y,?,?,"#25").

HIDE FRAME qbf-menu  NO-PAUSE.
HIDE FRAME qbf-perm  NO-PAUSE.
HIDE FRAME qbf-filer NO-PAUSE.
HIDE MESSAGE NO-PAUSE.
IF qbf-y THEN 
  RUN prores/b-again.p (TRUE).

{ prores/t-reset.i }
RETURN.
