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
/* u-load.p - program to dump data directly into a progress database file */

/* part of a set comprised of u-dump.p u-load.p u-pick.p u-used.p */


/* name of database and file to create and load into */
DEFINE INPUT PARAMETER qbf-d AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER qbf-f AS CHARACTER NO-UNDO.


/* All of these shared variables are explained in the RESULTS  */
/* documentation chapter on "Integrating RESULTS Into Existing */
/* Applications", so I am not documenting them here again.     */

DEFINE SHARED VARIABLE qbf-name  AS CHARACTER           NO-UNDO.
DEFINE SHARED VARIABLE qbf-total AS INTEGER             NO-UNDO.

DEFINE SHARED VARIABLE qbf-db    AS CHARACTER EXTENT  5 NO-UNDO.
DEFINE SHARED VARIABLE qbf-file  AS CHARACTER EXTENT  5 NO-UNDO.
DEFINE SHARED VARIABLE qbf-of    AS CHARACTER EXTENT  5 NO-UNDO.
DEFINE SHARED VARIABLE qbf-order AS CHARACTER EXTENT  5 NO-UNDO.
DEFINE SHARED VARIABLE qbf-where AS CHARACTER EXTENT  5 NO-UNDO.

DEFINE SHARED VARIABLE qbf-rc#   AS INTEGER             NO-UNDO.
DEFINE SHARED VARIABLE qbf-rcc   AS CHARACTER EXTENT 64 NO-UNDO.
DEFINE SHARED VARIABLE qbf-rcf   AS CHARACTER EXTENT 64 NO-UNDO.
DEFINE SHARED VARIABLE qbf-rcl   AS CHARACTER EXTENT 64 NO-UNDO.
DEFINE SHARED VARIABLE qbf-rcn   AS CHARACTER EXTENT 64 NO-UNDO.
DEFINE SHARED VARIABLE qbf-rct   AS INTEGER   EXTENT 64 NO-UNDO.
DEFINE SHARED VARIABLE qbf-dtype AS CHARACTER           NO-UNDO.

/* RESULTSDB alias must be set and pointing to destination database. */
/* Do a CREATE ALIAS "RESULTSDB" FOR DATABASE VALUE(SDBNAME(qbf-d))  */
/* before calling.  We do this in u-dump.p.                          */

/* define scrap variables */
DEFINE VARIABLE qbf-c AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER   NO-UNDO.

DO TRANSACTION:

  /* now point to correct _db record */
  FIND RESULTSDB._Db
    WHERE RESULTSDB._Db._Db-name =
      (IF DBTYPE(qbf-d) = "PROGRESS" THEN ? ELSE LDBNAME(qbf-d)).

  /* delete old file if present */
  /* filter out sql92 tables and views */
  IF INTEGER(DBVERSION("RESULTSDB":U)) > 8 THEN
    FIND RESULTSDB._File OF RESULTSDB._Db 
      WHERE RESULTSDB._File._File-name = qbf-f AND
        (RESULTSDB._File._Owner = "PUB":U OR RESULTSDB._File._Owner = "_FOREIGN":U)
      NO-ERROR.
  ELSE 
    FIND RESULTSDB._File OF RESULTSDB._Db
      WHERE RESULTSDB._File._File-name = qbf-f NO-ERROR.
  IF AVAILABLE RESULTSDB._File THEN DO:
    FOR EACH RESULTSDB._Index OF RESULTSDB._File:
      FOR EACH RESULTSDB._Index-field OF RESULTSDB._Index:
        DELETE RESULTSDB._Index-field.
      END.
      DELETE RESULTSDB._Index.
    END.
    FOR EACH RESULTSDB._Field OF RESULTSDB._File:
      DELETE RESULTSDB._Field.
    END.
    DELETE RESULTSDB._File.
  END.

  /* now create new file */
  CREATE RESULTSDB._File.
  ASSIGN
    RESULTSDB._File._Db-recid  = RECID(RESULTSDB._Db)
    RESULTSDB._File._Desc      = qbf-name
    RESULTSDB._File._File-name = qbf-f.

  /* now create field definitions */
  DO qbf-i = 1 TO qbf-rc#:
    CREATE RESULTSDB._Field.

    /* Assign field name.  We must make sure it does not begin with   */
    /* "qbf", so that it won't confuse RESULTS.  And we also loop to  */
    /* add a unique number suffix, in case we already have a field by */
    /* that name.  For example, we may be getting data from           */
    /* demo.customer.amount and demo.order.amount.                    */
    ASSIGN
      qbf-c = ENTRY(1,qbf-rcn[qbf-i])
      qbf-c = (IF qbf-c BEGINS "qbf" THEN
                "calc__" + STRING(qbf-i)
              ELSE
                SUBSTRING(qbf-c,R-INDEX(qbf-c,".") + 1)).
    DO qbf-j = 0 TO qbf-j + 1
      WHILE CAN-FIND(RESULTSDB._Field OF RESULTSDB._File
        WHERE RESULTSDB._Field._Field-name
          = qbf-c + (IF qbf-j = 0 THEN "" ELSE STRING(qbf-j))):
    END.

    /* now assign all field attributes */
    ASSIGN
      RESULTSDB._Field._Field-name = qbf-c
                                   + (IF qbf-j = 0 THEN "" ELSE STRING(qbf-j))
      RESULTSDB._Field._Col-label  = qbf-rcl[qbf-i]
      RESULTSDB._Field._Label      = ?
      RESULTSDB._Field._Data-type  = ENTRY(qbf-rct[qbf-i],qbf-dtype)
      RESULTSDB._Field._File-recid = RECID(RESULTSDB._File)
      RESULTSDB._Field._Format     = qbf-rcf[qbf-i]
      RESULTSDB._Field._Order      = qbf-i * 10.
    IF qbf-rct[qbf-i] = 5 /*dec*/ THEN RESULTSDB._Field._Decimals = 10.
  END.

  /* If order-by clauses defined, treat them as an index definition. */
  /* Pretty cool, huh?                                               */
  IF qbf-order[1] <> "" THEN DO:
    CREATE RESULTSDB._Index.
    ASSIGN
      RESULTSDB._File._Prime-Index = RECID(RESULTSDB._Index)
      RESULTSDB._Index._File-recid = RECID(RESULTSDB._File)
      RESULTSDB._Index._Unique     = FALSE
      RESULTSDB._Index._Active     = TRUE
      RESULTSDB._Index._Index-Name = RESULTSDB._File._File-name.

    /* Strip off " desc" from end of field name, if its there, and    */
    /* remember to set the _ascending flag to true if it's not.  Note */
    /* that we must find the _Field record in order to get the        */
    /* _field-recid.  We are helped by the fact that RESULTS does not */
    /* allow order-by to be defined on calculated fields.             */
    /* It's entirely possible that the field used to order the report */
    /* is not available to us as a selected field.  If this is the    */
    /* case, we have two choices: 1) create extra fields to hold      */
    /* these values, or 2) ignore them.  I have chosen the latter.    */
    qbf-j = 0.
    DO qbf-i = 1 TO 5 WHILE qbf-order[qbf-i] <> "":
      qbf-c = SUBSTRING(qbf-order[qbf-i],R-INDEX(qbf-order[qbf-i],".") + 1).
      FIND RESULTSDB._Field OF RESULTSDB._File
        WHERE RESULTSDB._Field._Field-name =
          SUBSTRING(qbf-c,1,INDEX(qbf-c + " "," ") - 1) NO-ERROR.
      IF NOT AVAILABLE RESULTSDB._Field THEN NEXT.
      CREATE RESULTSDB._Index-field.
      ASSIGN
        qbf-j = qbf-j + 1
        RESULTSDB._Index-field._Index-recid = RECID(RESULTSDB._Index)
        RESULTSDB._Index-field._Abbreviate  = FALSE
        RESULTSDB._Index-field._Ascending   = NOT qbf-order[qbf-i]
                                              MATCHES "* DESC"
        RESULTSDB._Index-field._Field-recid = RECID(RESULTSDB._Field)
        RESULTSDB._Index-field._Index-Seq   = qbf-j
        RESULTSDB._Index-field._Unsorted    = FALSE.
    END.
  END.

END. /* transaction */

/*--------------------------------------------------------------------------*/

/* We should really pick another name for the temp file, but I have   */
/* it on good authority that when user programs are being run,        */
/* RESULTS assumes all _*.p and _*.d files that it created are dirty. */
/* So blast away!                                                     */
OUTPUT TO VALUE("_qbf.p") NO-ECHO NO-MAP.

/* qbf-total counts records, and is defined by u-dump.p */
PUT UNFORMATTED 'DEFINE SHARED VARIABLE qbf-total AS INTEGER NO-UNDO.' SKIP.

/* Create necessary variable definitions for calculated fields.  I know */
/* this looks ugly, but it works.  It's (almost) straight from the      */
/* RESULTS source for creating code for export/labels/reports.          */
/* The fields ending in "%" are used for percent-of-total calculations. */
DO qbf-i = 1 TO qbf-rc#:
  IF qbf-rcc[qbf-i] = "" OR qbf-rcc[qbf-i] BEGINS "e" THEN NEXT.
  qbf-c = ENTRY(1,qbf-rcn[qbf-i]).
  IF qbf-rcc[qbf-i] BEGINS "c" THEN /*counter*/
    qbf-j = INTEGER(ENTRY(2,qbf-rcn[qbf-i])) - INTEGER(ENTRY(3,qbf-rcn[qbf-i])).
  IF qbf-rcc[qbf-i] BEGINS "p" THEN /*percent-of-total*/
    PUT UNFORMATTED SKIP
      'DEFINE VARIABLE ' ENTRY(1,qbf-rcn[qbf-i]) '  AS DECIMAL NO-UNDO.' SKIP
      'DEFINE VARIABLE ' ENTRY(1,qbf-rcn[qbf-i]) '% AS DECIMAL NO-UNDO.'.
  ELSE /*all other calculated field types */
    PUT UNFORMATTED SKIP
      'DEFINE VARIABLE ' ENTRY(1,qbf-rcn[qbf-i]) '  AS '
        CAPS(ENTRY(qbf-rct[qbf-i],qbf-dtype))
        (IF NOT qbf-rcc[qbf-i] BEGINS "c" THEN ''
          ELSE ' INITIAL ' + STRING(qbf-j))
        ' NO-UNDO.'.
END.
PUT UNFORMATTED SKIP(1).

/*--------------------------------------------------------------------------*/

/* Check to see if there are any percent-of-totals fields.  If there  */
/* are, we have to make a pre-pass through the file, to get the total */
/* amounts.  This way, we have the denominator for the percentage.    */
/* The code this generates looks something like:                      */
/*   FOR EACH demo.customer,                                          */
/*     EACH demo.order OF demo.customer:                              */
/*     ASSIGN                                                         */
/*       qbf-001% = qbf-001% + demo.customer.curr-bal                 */
/*       qbf-002% = qbf-002% + demo.customer.ytd-sales.               */
/*   END.                                                             */
qbf-j = 0.
DO qbf-i = 1 TO qbf-rc# WHILE qbf-j < 2:
  IF qbf-rcc[qbf-i] BEGINS "p" THEN qbf-j = qbf-j + 1.
END.

IF qbf-j > 0 THEN DO:
  PUT UNFORMATTED 'FOR '.
  DO qbf-i = 1 TO 5 WHILE qbf-file[qbf-i] <> "":
    qbf-c = (IF qbf-where[qbf-i] = "" THEN
              qbf-of[qbf-i]
            ELSE IF qbf-of[qbf-i] = "" THEN
              "WHERE " + qbf-where[qbf-i]
            ELSE IF qbf-of[qbf-i] BEGINS "OF" THEN
              qbf-of[qbf-i] + " WHERE " + qbf-where[qbf-i]
            ELSE
              "(" + qbf-of[qbf-i] + ") AND (" + qbf-where[qbf-i] + ")"
            ).
    IF qbf-c <> "" THEN qbf-c = " " + qbf-c.
    PUT UNFORMATTED
      'EACH ' qbf-db[qbf-i] '.' qbf-file[qbf-i] qbf-c ' NO-LOCK'.
    IF qbf-i < 5 AND qbf-file[qbf-i + 1] <> "" THEN
      PUT UNFORMATTED ',' SKIP '  '.
  END.
  PUT UNFORMATTED
    ':' SKIP
    '  ASSIGN'.

  DO qbf-i = 1 TO qbf-rc#:
    IF NOT qbf-rcc[qbf-i] BEGINS "p" THEN NEXT.
    PUT UNFORMATTED SKIP '    '.
    PUT UNFORMATTED
      ENTRY(1,qbf-rcn[qbf-i]) '% = ' ENTRY(1,qbf-rcn[qbf-i]) '% + '
      ENTRY(2,qbf-rcn[qbf-i]).
  END.
  PUT UNFORMATTED '.' SKIP 'END.' SKIP(1).
END.

/*--------------------------------------------------------------------------*/

/* FOR EACH with WHEREs and BREAK-BYs. */
/* This code comes from the RESULTS manual. */

PUT UNFORMATTED 'FOR '.

DO qbf-i = 1 TO 5 WHILE qbf-file[qbf-i] <> "":
  qbf-c = (IF qbf-where[qbf-i] = "" THEN
            qbf-of[qbf-i]
          ELSE IF qbf-of[qbf-i] = "" THEN
            "WHERE " + qbf-where[qbf-i]
          ELSE IF qbf-of[qbf-i] BEGINS "OF" THEN
            qbf-of[qbf-i] + " WHERE " + qbf-where[qbf-i]
          ELSE
            "(" + qbf-of[qbf-i] + ") AND (" + qbf-where[qbf-i] + ")"
          ).
  IF qbf-c <> "" THEN qbf-c = " " + qbf-c.
  PUT UNFORMATTED
    'EACH ' qbf-db[qbf-i] '.' qbf-file[qbf-i] qbf-c ' NO-LOCK'.
  IF qbf-i < 5 AND qbf-file[qbf-i + 1] <> "" THEN
    PUT UNFORMATTED ',' SKIP '  '.
END.

qbf-c = ''.
DO qbf-i = 1 TO 5 WHILE qbf-order[qbf-i] <> "":
  qbf-c = qbf-c + ' BY ' + qbf-order[qbf-i].
END.
IF qbf-c <> "" THEN
  PUT UNFORMATTED SKIP ' ' qbf-c.

PUT UNFORMATTED SKIP
  '  qbf-total = 1 TO qbf-total + 1:' SKIP.

/*--------------------------------------------------------------------------*/

/* calc field code for main loop */
qbf-j = 0. /* 0=none, 1=one, 2=many */
DO qbf-i = 1 TO qbf-rc# WHILE qbf-j < 2:
  IF CAN-DO("r*,p*,c*,s*,d*,n*,l*",qbf-rcc[qbf-i]) THEN qbf-j = qbf-j + 1.
END.

/* This horrible beast generates the code for all calculated fields. */
/* Immediately after the for-each statement, we make a big assign    */
/* statement and set the values of each calculated field into the    */
/* defined variables we've created to hold them.                     */
IF qbf-j > 0 THEN DO:
  PUT UNFORMATTED '  ASSIGN'.
  DO qbf-i = 1 TO qbf-rc#:
    qbf-c = (IF qbf-rcc[qbf-i] BEGINS "r" THEN
              ENTRY(1,qbf-rcn[qbf-i]) + ' + ' + ENTRY(2,qbf-rcn[qbf-i])
            ELSE IF qbf-rcc[qbf-i] BEGINS "p" THEN
              ENTRY(2,qbf-rcn[qbf-i]) + ' * 100 / '
                + ENTRY(1,qbf-rcn[qbf-i]) + '%'
            ELSE IF qbf-rcc[qbf-i] BEGINS "c" THEN
              ENTRY(1,qbf-rcn[qbf-i]) + ' + ' + ENTRY(3,qbf-rcn[qbf-i])
            ELSE IF CAN-DO("s*,d*,n*,l*",qbf-rcc[qbf-i]) THEN
              SUBSTRING(qbf-rcn[qbf-i],INDEX(qbf-rcn[qbf-i],",") + 1)
            ELSE
              ''
            ).
    IF qbf-c = "" THEN NEXT.
    PUT UNFORMATTED SKIP '    ' ENTRY(1,qbf-rcn[qbf-i]) ' = ' qbf-c.
  END.
  PUT UNFORMATTED '.' SKIP.
END.

/*--------------------------------------------------------------------------*/

/* This section creates the CREATE statement, and a big ASSIGN statement */
/* to load up the values.  Generally, we are copying field to field.     */
/* Making a big ASSIGN statement helps performance.  Note we look up the */
/* _Field by _Order - this way, we can ignore the field names, which may */
/* have been adjusted by the section above that created them.            */

PUT UNFORMATTED
  '  CREATE ' qbf-d '.' qbf-f '.' SKIP
  '  ASSIGN'.
DO:
  FIND RESULTSDB._Db
    WHERE RESULTSDB._Db._Db-name =
      (IF DBTYPE(qbf-d) = "PROGRESS" THEN ? ELSE LDBNAME(qbf-d)).
      
  /* filter out sql92 tables and views */
  IF INTEGER(DBVERSION("RESULTSDB":U)) > 8 THEN
    FIND RESULTSDB._File OF RESULTSDB._Db 
      WHERE RESULTSDB._File._File-name = qbf-f AND
        (RESULTSDB._File._Owner = "PUB":U OR RESULTSDB._File._Owner = "_FOREIGN":U).
  ELSE 
    FIND RESULTSDB._File OF RESULTSDB._Db
      WHERE RESULTSDB._File._File-name = qbf-f.
    
  DO qbf-i = 1 TO qbf-rc#:
    IF qbf-rcc[qbf-i] BEGINS "e" THEN NEXT. /* skip array fields */
    FIND RESULTSDB._Field OF RESULTSDB._File
      WHERE RESULTSDB._Field._Order = qbf-i * 10.
    ASSIGN
      qbf-c = ENTRY(1,qbf-rcn[qbf-i])
      qbf-c = (IF qbf-c BEGINS "qbf-" THEN
                "calc__" + STRING(qbf-i)
              ELSE
                SUBSTRING(qbf-c,R-INDEX(qbf-c,".") + 1)).
    PUT UNFORMATTED
      SKIP '    ' qbf-d '.' qbf-f '.' qbf-c ' = ' ENTRY(1,qbf-rcn[qbf-i]).
  END.
END.

PUT UNFORMATTED
  '.' SKIP
  'END.' SKIP
  'RETURN.' SKIP.

OUTPUT CLOSE.

/* all done! */
RETURN.
