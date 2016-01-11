/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* Progress Lex Converter 7.1A->7.1C Version 1.26 */

/* s-demo.p - is this the "demo" database? */

DEFINE INPUT  PARAMETER qbf-d AS CHARACTER            NO-UNDO. /* dbname */
DEFINE OUTPUT PARAMETER qbf-a AS LOGICAL INITIAL TRUE NO-UNDO. /* isdemo? */

DEFINE VARIABLE qbf-j AS INTEGER NO-UNDO.

DEFINE VARIABLE qbf-s AS CHARACTER EXTENT 10 NO-UNDO INITIAL [
  "agedar,10,3,3,3":u,
  "customer,19,3,3,3":u,
  "item,13,2,2,2":u,
  "monthly,11,3,3,3":u,
  "order,18,4,3,3":u,
  "order-line,8,3,2,3":u,
  "salesrep,7,1,1,1":u,
  "shipping,3,1,1,1":u,
  "state,4,1,1,1":u,
  "syscontrol,13,1,1,1":u
].

FOR EACH QBF$0._File /* is this the PROGRESS demo database? */
  WHERE NOT QBF$0._File._Hidden NO-LOCK
  BY QBF$0._File._File-name
  WHILE qbf-a
  qbf-j = 1 TO qbf-j + 1:

    /* filter out sql92 views and tables */
    IF INTEGER(DBVERSION("QBF$0":U)) > 8 THEN 
        IF (QBF$0._File._Owner <> "PUB":u AND QBF$0._File._Owner <> "_FOREIGN":u)
            THEN NEXT.

    qbf-a = qbf-j < 11
          AND         ENTRY(1,qbf-s[qbf-j])  = QBF$0._File._File-name
          AND INTEGER(ENTRY(2,qbf-s[qbf-j])) = QBF$0._File._numfld
          AND INTEGER(ENTRY(3,qbf-s[qbf-j])) = QBF$0._File._numkcomp
          AND INTEGER(ENTRY(4,qbf-s[qbf-j])) = QBF$0._File._numkey
          AND INTEGER(ENTRY(5,qbf-s[qbf-j])) = QBF$0._File._numkfld.
END.

RETURN.

/* s-demo.p - end of file */

