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
/* a-init.p - RESULTS startup code */

{ prores/s-system.i }
{ prores/t-define.i }

DEFINE INPUT  PARAMETER qbf-g AS LOGICAL NO-UNDO. /* true=init, false=close */
DEFINE OUTPUT PARAMETER qbf-e AS CHARACTER INITIAL "" NO-UNDO. /* error txt */

DEFINE VARIABLE qbf-a AS LOGICAL   NO-UNDO.
DEFINE VARIABLE qbf-c AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-f AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-t AS CHARACTER NO-UNDO.

IF qbf-g THEN DO:
  /*------------------------------------------------------------------------*/
  /* hack up propath to put blank entry first */
  qbf-c = PROPATH.
  DO WHILE INDEX(qbf-c,",,") > 0:
    SUBSTRING(qbf-c,INDEX(qbf-c,",,"),2) = ",".
  END.
  PROPATH = (IF qbf-c BEGINS "," THEN "" ELSE ",") + qbf-c.

  /* read in default language settings */
  qbf-c = SEARCH("results.l").
  IF qbf-c = ? THEN qbf-c = SEARCH("prores/results.l").
  IF qbf-c <> ? THEN DO:
    INPUT FROM VALUE(qbf-c) NO-ECHO.
    REPEAT:
      IMPORT qbf-c qbf-t.
      IF      qbf-c MATCHES "language*="    THEN qbf-langset = qbf-t.
      ELSE IF qbf-c MATCHES "left-delim*="  THEN qbf-left    = qbf-t.
      ELSE IF qbf-c MATCHES "right-delim*=" THEN qbf-right   = qbf-t.
    END.
    INPUT CLOSE.
  END.

  ASSIGN
    qbf-a = FALSE
    qbf-c = "QBF$0,QBF$1,QBF$2,QBF$3,QBF$4,QBF$5,RESULTSDB"
    qbf-f = "".

  DO qbf-i = 1 TO NUM-ENTRIES(qbf-c):
    DELETE ALIAS VALUE(ENTRY(qbf-i,qbf-c)).
    qbf-a = qbf-a OR LDBNAME(ENTRY(qbf-i,qbf-c)) <> ?.
  END.

  qbf-i = GET-LICENSE ("RESULTS").
  
  IF qbf-i = 1 THEN
    MESSAGE 'Wrong string!'.
  ELSE IF qbf-i = 2 OR qbf-i = 3 THEN
    qbf-e = "#13".

/* GJO
  IF   NOT _CBIT(_CONTROL,32)   THEN qbf-e = "#13".
  ELSE 
*/
  IF NUM-DBS = 0           THEN qbf-e = "#16".
  ELSE IF qbf-a AND NUM-DBS > 1 THEN qbf-e = "#17".
  /*{ prores/t-set.i &mod=a &set=1 }*/
  /*13: "You have not purchased RESULTS.  Program terminated."*/
  /*16: "There are no databases connected."*/
  /*17 "Cannot execute when a database has logical name starting with RESULTS"*/
  /*32: " Your Results lience has expiried" */
  IF qbf-e <> "" THEN RETURN.

  DO qbf-i = 1 TO NUM-ENTRIES(qbf-c):
    CREATE ALIAS VALUE(ENTRY(qbf-i,qbf-c)) FOR DATABASE VALUE(LDBNAME(1)).
  END.

  /* blow away temp files that might cause trouble later (*.r) */
  DO qbf-i = 0 TO 6:
    ASSIGN
      qbf-c = qbf-tempdir + (IF qbf-i = 0 THEN "" ELSE STRING(qbf-i)) + ".r"
      qbf-t = SEARCH(qbf-c).
    IF qbf-t = qbf-c OR qbf-t = "./" + qbf-c THEN qbf-f = qbf-f + "," + qbf-t.
  END.
  IF qbf-f <> "" THEN 
    RUN prores/a-zap.p (qbf-f).

  /* .qc file locator: */
  /* + step 1. if .db reachable, then .qc should be with it. */
  ASSIGN
    qbf-qcfile = SEARCH(DBNAME + ".qc")
    qbf-c      = SEARCH(DBNAME + ".db").

  /* + step 2. if not found, find dbname.qc in propath */
  IF qbf-qcfile = ? THEN DO:
    RUN prores/s-prefix.p (DBNAME,OUTPUT qbf-f).
    qbf-qcfile = SEARCH(SUBSTRING(DBNAME,LENGTH(qbf-f) + 1) + ".qc").
  END.

  /* + step 3. if none avail, new one goes next to .db if possible */
  IF qbf-qcfile = ? AND qbf-c <> ? THEN
    qbf-qcfile = SUBSTRING(qbf-c,1,LENGTH(qbf-c) - 3) + ".qc".

  /* + step 4. if can't put new one there, then current directory */
  IF qbf-qcfile = ? THEN
    qbf-qcfile = SUBSTRING(DBNAME,LENGTH(qbf-f) + 1) + ".qc".

  /* strip off .qc */
  qbf-qcfile = SUBSTRING(qbf-qcfile,1,LENGTH(qbf-qcfile) - 3).

  /* Confusion case! .db not reachable, but .qc of */
  /* correct name local with database also local.  */
  IF SEARCH(DBNAME + ".db") = ? /* .db not reachable */
    AND SEARCH(qbf-qcfile + ".qc") <> ? /* but .qc found locally */
    AND SEARCH(qbf-qcfile + ".db") <> ? /* and .db next to it */
    THEN DO:
    /* ** RESULTS is confused **^^                           */
    /* In the {1} directory, neither {2}.db nor {2}.qc could */
    /* be found.  {3}.qc was found in the PROPATH, but it    */
    /* appears to belong to {3}.db.  Please fix your PROPATH */
    /* or rename/delete {3}.db and .qc.                      */

    RUN prores/s-prefix.p (qbf-qcfile,OUTPUT qbf-c).
    ASSIGN
      qbf-e = qbf-lang[19]
      SUBSTRING(qbf-e,INDEX(qbf-e,"~{1~}"),3) = qbf-c
      qbf-c = SUBSTRING(qbf-qcfile,LENGTH(qbf-c) + 1)
      qbf-i = INDEX(qbf-e,"~{2~}").

    DO WHILE qbf-i > 0:
      ASSIGN
        SUBSTRING(qbf-e,qbf-i,3) = qbf-c
        qbf-i = INDEX(qbf-e,"~{2~}").
    END.

    ASSIGN
      qbf-c = SEARCH(qbf-qcfile + ".db")
      qbf-c = SUBSTRING(qbf-c,1,LENGTH(qbf-c) - 3)
      qbf-i = INDEX(qbf-e,"~{3~}").

    DO WHILE qbf-i > 0:
      ASSIGN
        SUBSTRING(qbf-e,qbf-i,3) = qbf-c
        qbf-i = INDEX(qbf-e,"~{3~}").
    END.
  END.

  /*------------------------------------------------------------------------*/
END.
ELSE DO:
  /*------------------------------------------------------------------------*/
  qbf-f = "".
  DO qbf-i = 0 TO 6:
    ASSIGN
      qbf-c = qbf-tempdir + TRIM(STRING(qbf-i,">")) + ".d"
      qbf-t = SEARCH(qbf-c)
      qbf-f = qbf-f
            + (IF qbf-t = qbf-c OR qbf-t = "./" + qbf-c
              THEN "," + qbf-t ELSE "")
      qbf-c = qbf-tempdir + TRIM(STRING(qbf-i,">")) + ".p"
      qbf-t = SEARCH(qbf-c)
      qbf-f = qbf-f
            + (IF qbf-t = qbf-c OR qbf-t = "./" + qbf-c
              THEN "," + qbf-t ELSE "").
  END.
  IF qbf-f <> "" THEN 
    RUN prores/a-zap.p (qbf-f).
  /*------------------------------------------------------------------------*/
END.

RETURN.

/* a-init.p - end of file */

