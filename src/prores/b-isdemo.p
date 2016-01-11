/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* b-isdemo.p - is this the PROGRESS demo database? */

DEFINE OUTPUT PARAMETER qbf-d AS LOGICAL INITIAL TRUE NO-UNDO.

DEFINE VARIABLE lDemo AS LOGICAL INITIAL TRUE NO-UNDO.
DEFINE VARIABLE lSports AS LOGICAL INITIAL TRUE NO-UNDO.

DEFINE VARIABLE qbf-l AS INTEGER NO-UNDO.

DEFINE VARIABLE caSports AS CHARACTER EXTENT 9 NO-UNDO INITIAL [
  "Customer,17,6,5,6",
  "Invoice,9,4,4,4",
  "Item,10,3,3,3", 
  "Local-Default,9,0,1,0",
  "Order,11,5,4,4",
  "Order-Line,9,3,2,3",
  "Ref-Call,7,6,4,4",
  "Salesrep,5,1,1,1",
  "State,4,1,1,1"
].

DEFINE VARIABLE qbf-s AS CHARACTER EXTENT 10 NO-UNDO INITIAL [
  "agedar,10,3,3,3",
  "customer,19,3,3,3",
  "item,13,2,2,2",
  "monthly,11,3,3,3",
  "order,18,4,3,3",
  "order-line,8,3,2,3",
  "salesrep,7,1,1,1",
  "shipping,3,1,1,1",
  "state,4,1,1,1",
  "syscontrol,13,1,1,1"
].

/* b-misc.p has pointed qbf$0 alias to the database to be tested. */

qbf-d = FALSE.

/* is this the PROGRESS demo database?  if so, set defaults differently. */
FOR EACH QBF$0._File
  WHERE NOT QBF$0._File._Hidden NO-LOCK
  BY QBF$0._File._File-name
  WHILE lDemo OR lSports:
  
  /* filter out sql92 tables and views */
  IF INTEGER(DBVERSION("QBF$0":U)) > 8
    THEN IF (QBF$0._File._Owner <> "PUB":U AND QBF$0._File._Owner <> "_FOREIGN":U)
    THEN NEXT.
  
  qbf-l = qbf-l + 1.

  if (lDemo) Then
    lDemo = qbf-l < 11
          AND         ENTRY(1,qbf-s[qbf-l])  = QBF$0._File._File-name
          AND INTEGER(ENTRY(2,qbf-s[qbf-l])) = QBF$0._File._numfld
          AND INTEGER(ENTRY(3,qbf-s[qbf-l])) = QBF$0._File._numkcomp
          AND INTEGER(ENTRY(4,qbf-s[qbf-l])) = QBF$0._File._numkey
          AND INTEGER(ENTRY(5,qbf-s[qbf-l])) = QBF$0._File._numkfld.

  if (lSports and qbf-l <= EXTENT (caSports)) Then
    lSports = ENTRY(1,caSports[qbf-l])  = QBF$0._File._File-name
          AND INTEGER(ENTRY(2,caSports[qbf-l])) = QBF$0._File._numfld
          AND INTEGER(ENTRY(3,caSports[qbf-l])) = QBF$0._File._numkcomp
          AND INTEGER(ENTRY(4,caSports[qbf-l])) = QBF$0._File._numkey
          AND INTEGER(ENTRY(5,caSports[qbf-l])) = QBF$0._File._numkfld.
END.

IF (lSports OR lDemo) THEN
  qbf-d = TRUE.

RETURN.
