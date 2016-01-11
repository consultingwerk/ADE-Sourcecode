/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* b-join.p - find all implied of-relationships */

{ prores/s-system.i }
{ prores/t-define.i }
{ prores/c-form.i }
{ prores/t-set.i &mod=b &set=1 }
{ prores/b-join.i NEW }
{ prores/reswidg.i }
{ prores/resfunc.i }

DEFINE VARIABLE lFound  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lReturn AS LOGICAL    NO-UNDO.
DEFINE VARIABLE qbf-c   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE qbf-g   AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-i   AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-k   AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-l   AS INTEGER    NO-UNDO.
DEFINE VARIABLE qbf-r   AS RECID      NO-UNDO.
DEFINE VARIABLE qbf-o   AS CHARACTER  NO-UNDO.

/* b-join.i is included NEW, so the temp-tables should be emptied, too  */
EMPTY TEMP-TABLE qbf-a.
EMPTY TEMP-TABLE qbf-join.

/*message "[b-join.p]" view-as alert-box.*/

/* NOTE: Sometimes, almost every file in a customer database may have a
   common field name in it (e.g. "Code" or "Name").  If this field is a
   unique index component, it can cause the join code below to "choke", or
   produce an unbalanced join listing. */

/*----------------------------------------------- Loading list of relations */
qbf-p = "".
DO qbf-i = 1 TO NUM-DBS:
  IF DBTYPE(qbf-i) = "PROGRESS" THEN
    qbf-p = qbf-p + (IF qbf-p = "" THEN "" ELSE ",") + LDBNAME(qbf-i).
END.

DO qbf-i = 1 TO NUM-ENTRIES(qbf-p):
  CREATE ALIAS "QBF$1" FOR DATABASE VALUE(ENTRY(qbf-i,qbf-p)).
  RUN prores/b-join1.p.
END.

/* qbf-lang[14] = "Eliminating redundant relation information." */
{ prores/b-status.i &text=qbf-lang[14] }

IF qbf-x# > 1 THEN DO:
  /* Right now the joins are stored exactly as found - e.g.
     if tbl 1 is joined to tbl2 AND vice versa, we will have two entries
     with tbl 1 - tbl2 and another with tbl2 - tbl1.  However, if there are
     two entries that are identical it means that tbl1 is joined to tbl2
     by two independent fields. Progress does not pick this is up as an OF
     relation because it does not know which field to base the relationship
     on.  So we need to eliminate these duplicate entries as well as any 
     other entry representing a join on these 2 tables.  First sort to get
     these next to each other so that we can easily recognize the situation. (los)
  */
  RUN shell_sort.

  /* Duplicate elimination (delete all joins between these tbls).
     This checks each set of consecutive pairs. */
  DO qbf-l = 1 TO qbf-x#:
    {&FIND_QBF_A} qbf-l.
    {&FIND_BUF_A} qbf-l + 1 NO-ERROR.
    IF qbf-a.aValue = ? OR NOT AVAILABLE buf-a OR
      (AVAILABLE buf-a AND buf-a.aValue = ?) THEN NEXT.
      
    ASSIGN
      qbf-k  = qbf-l
      lFound = FALSE.
    {&FIND_BUF_A} qbf-k + 1 NO-ERROR.
    IF NOT AVAILABLE buf-a THEN NEXT.
    DO WHILE qbf-a.aValue = buf-a.aValue
         AND qbf-a.xValue = buf-a.xValue
         AND qbf-a.bValue = buf-a.bValue
         AND qbf-a.yValue = buf-a.yValue:
      ASSIGN
        qbf-k  = qbf-k + 1
        lFound = TRUE.
      {&FIND_BUF_A} qbf-k NO-ERROR.
      IF NOT AVAILABLE buf-a THEN LEAVE.
    END.
    IF lFound THEN
      qbf-k = qbf-k - 1.
    
    IF qbf-k > qbf-l THEN DO:
      /* We'll null out this pair.  First find any entries that have
      	 the same tables, but flipped around. */
      DO qbf-i = 1 TO qbf-x#:
        /* Skip entries within current range */
      	IF qbf-i >= qbf-l AND qbf-i <= qbf-k THEN NEXT.

        {&FIND_QBF_A} qbf-i.
        {&FIND_BUF_A} qbf-l.
	/* this is where we null out the joins that are similar to the one we are looking at */
      /* for example, if we are looking at customer,order then order,customer should be eliminated */
        IF qbf-a.aValue = buf-a.bValue AND
           qbf-a.xValue = buf-a.yValue AND
           qbf-a.bValue = buf-a.aValue AND
           qbf-a.yValue = buf-a.xValue THEN DO:
          ASSIGN
            qbf-a.aValue = ?
            qbf-a.bValue = ?
            qbf-a.xValue = ?
            qbf-a.yValue = ?.
        END.
      END.

      /* This is where we null out all the records that are exactly alike and
	   in the same order -- these are ambigous because joined by more than one index (can't do an OF)
       */
      /* DO qbf-g = (qbf-l + 1) TO qbf-k: 	fix for IZ 247 */
      DO qbf-g = qbf-l TO qbf-k:
        {&FIND_QBF_A} qbf-g.
        ASSIGN
          qbf-a.aValue = ?
          qbf-a.xValue = ?
          qbf-a.bValue = ?
          qbf-a.yValue = ?.
      END.
      qbf-l = qbf-k.
    END.
  END.
  
  /* Now we want to flip each join entry around so that the table with
     the smaller RECID is always the first one in the pair.  Once we do 
     that we can find duplicate pairs because tbl 1 is joined to tbl 2 and
     vice versa.  (This will happen if the common field is uniquely 
     indexed in both tables.) */
  DO qbf-l = 1 TO qbf-x#:
    {&FIND_QBF_A} qbf-l.
    IF qbf-a.aValue = ? THEN NEXT.

    IF STRING(qbf-a.bValue) + " " + STRING(qbf-a.yValue) <
       STRING(qbf-a.aValue) + " " + STRING(qbf-a.xValue) THEN
      ASSIGN
        qbf-k        = qbf-a.aValue
        qbf-a.aValue = qbf-a.bValue
        qbf-a.bValue = qbf-k

        qbf-c        = STRING(qbf-a.xValue)
        qbf-a.xValue = qbf-a.yValue
        qbf-a.yValue = INTEGER(qbf-c).
  END.
  
  RUN shell_sort.
  
  /* Duplicate elimination.  This time we only get rid of 1 of the
     two pairs because there IS an OF join here but we only want to
     keep one of the duplicates. */
  DO qbf-l = 1 TO qbf-x#:
    {&FIND_QBF_A} qbf-l NO-ERROR.
    {&FIND_BUF_A} qbf-l + 1 NO-ERROR.
    IF NOT AVAILABLE qbf-a OR
      (AVAILABLE qbf-a AND qbf-a.aValue = ?) OR 
       NOT AVAILABLE buf-a OR
      (AVAILABLE buf-a AND buf-a.aValue = ?) THEN NEXT.
   
    ASSIGN
      qbf-k  = qbf-l
      lFound = FALSE.
    {&FIND_BUF_A} qbf-k + 1 NO-ERROR.
    IF NOT AVAILABLE buf-a THEN NEXT.
    DO WHILE qbf-a.aValue = buf-a.aValue
         AND qbf-a.xValue = buf-a.xValue
         AND qbf-a.bValue = buf-a.bValue
         AND qbf-a.yValue = buf-a.yValue:
      ASSIGN
        qbf-k  = qbf-k + 1
        lFound = TRUE.
      {&FIND_BUF_A} qbf-k NO-ERROR.
      IF NOT AVAILABLE buf-a THEN LEAVE.
    END.
    IF lFound THEN
      qbf-k = qbf-k - 1.
      
    IF qbf-k > qbf-l THEN DO:
      {&FIND_QBF_A} qbf-k NO-ERROR.
      IF AVAILABLE qbf-a THEN
      ASSIGN
        qbf-a.aValue = ?
        qbf-a.xValue = ?
        qbf-a.bValue = ?
        qbf-a.yValue = ?.
      qbf-l = qbf-k.
    END.
  END.

  /* Final cleanup */
  RUN shell_sort.

END. /* qbf-x# > 1 */

/*-------------------------------------------- Processing list of relations */
/* qbf-lang[12] = "Processing list of relations." */
{ prores/b-status.i &text=qbf-lang[12] }

ASSIGN
  qbf-join# = 0.
DO qbf-l = 1 TO qbf-x#:
  {&FIND_QBF_A} qbf-l.
  IF qbf-a.xValue = ? THEN NEXT.

  {&FIND_QBF_A} qbf-l.
  CREATE ALIAS "QBF$1" FOR DATABASE VALUE(ENTRY(qbf-a.aValue,qbf-p)).
  CREATE ALIAS "QBF$2" FOR DATABASE VALUE(ENTRY(qbf-a.bValue,qbf-p)).
  RUN prores/b-join3.p (qbf-a.xValue,qbf-a.yValue,OUTPUT qbf-c,OUTPUT qbf-o).

  ASSIGN
    qbf-join#           = qbf-join# + 1
    lReturn             = getRecord("qbf-join":U, qbf-join#)
    qbf-join.cValue     = MINIMUM(qbf-c,qbf-o) + ',' + MAXIMUM(qbf-c,qbf-o).
END.
EMPTY TEMP-TABLE qbf-a.

IF qbf-join# >= 2 THEN DO: /* sort */
  /* Move indexes 'out of bound' temporarily, create string for sorting */
  REPEAT PRESELECT EACH qbf-join USE-INDEX iIndex:
    FIND NEXT qbf-join.
    ASSIGN
      qbf-join.iIndex = qbf-join.iIndex + 100000
      qbf-join.cScrap = ENTRY(1,qbf-join.cValue) + " " 
                      + ENTRY(2,qbf-join.cValue).
  END.
  qbf-i = 0.
  REPEAT PRESELECT EACH qbf-join USE-INDEX cScrap:
    FIND NEXT qbf-join.
    ASSIGN
      qbf-i           = qbf-i + 1
      qbf-join.iIndex = qbf-i.
  END.
END.

/*------------------------------------------------------------------------- */

STATUS DEFAULT.
{ prores/t-reset.i }
RETURN.

/*------------------------------------------------------------------------- */

PROCEDURE shell_sort:
  IF qbf-x# < 2 THEN RETURN.

  /* Move indexes 'out of bound' temporarily, create string for sorting */
  REPEAT PRESELECT EACH qbf-a USE-INDEX iIndex:
    FIND NEXT qbf-a.
    
    ASSIGN
      qbf-a.iIndex = qbf-a.iIndex + 100000
      qbf-a.cScrap = STRING(qbf-a.aValue) + " " 
                   + STRING(qbf-a.xValue) + " "
                   + STRING(qbf-a.bValue) + " "
                   + STRING(qbf-a.yValue).
  END.

  qbf-i = 0.
  /* Reindex based on sorting string created above */
  REPEAT PRESELECT EACH qbf-a USE-INDEX cScrap:
    FIND NEXT qbf-a.
    IF qbf-a.aValue = ? THEN NEXT.
    ASSIGN
      qbf-i        = qbf-i + 1
      qbf-a.iIndex = qbf-i.
  END.
  qbf-x# = qbf-i.
  
  /* Cleanup unknown values.  These would be records whose index was not
     reset in the last FOR EACH. */
  FOR EACH qbf-a WHERE qbf-a.iIndex > 100000:
    DELETE qbf-a.
  END.
END.


/* b-join.p - end of file */
