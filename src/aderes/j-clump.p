/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* Progress Lex Converter 7.1A->7.1C Version 1.26 */

/* j-clump.p - general-purpose field acquisition program */

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/j-define.i }
{ aderes/j-clump.i }

/*
set 0 = [calc fields]
set 1 = [master file]
set n + 1 = [sub-master #n]
*/

DEFINE INPUT PARAMETER qbf-p AS CHARACTER NO-UNDO. /* parameter string */
DEFINE INPUT PARAMETER qbf-t AS CHARACTER NO-UNDO. /* table index list */

/*
qbf-p is parameter string:
   contains "$" - allow scalar database fields
   contains "#" - allow array database fields
   contains "<" - load initial settings from qbf-rc# and qbf-rc?[]
   contains ">" - hmmm...
   contains any of "rpcsdnlex" - allow that type of calc field:
                  r=running_total p=pct_of_total, c=counter,
                  s=string_exp, d=date_exp, n=numeric_exp, l-logical_exp,
                  e=stacked_array, x=lookup_field
   contains any of "12345" - allow that dtype:
                  1=char 2=date 3=log 4=int 5=dec
   contains "=" - shorthand for all calc-fields and all database fields
                  same as "rpcsdnlex12345"
*/

DEFINE VARIABLE qbf-a AS LOGICAL NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-i AS INTEGER NO-UNDO. /* scrap */

IF INDEX(qbf-p,"=":u) > 0 THEN
  SUBSTRING(qbf-p,INDEX(qbf-p,"=":u),1,"CHARACTER":u) = "rpcsdnlex12345":u.

/* insert calc fields in set #0 */
CREATE qbf-clump.
ASSIGN
  qbf-clump.qbf-csho = TRUE
  qbf-clump.qbf-cfil = 0
  qbf-clump.qbf-csiz = 0
  qbf-clump.qbf-cnam = ""
  qbf-clump.qbf-clbl = ""
  qbf-clump.qbf-cext = 0.

/* load up calculated fields into qbf-clump #0 */
DO qbf-i = 1 TO qbf-rc#:
  IF qbf-rcc[qbf-i] = "" 
    OR INDEX(qbf-p,SUBSTRING(qbf-rcc[qbf-i],1,1,"CHARACTER":u)) = 0 THEN NEXT.
    /*OR qbf-rcc[qbf-i] BEGINS "e":u THEN NEXT.*/
  ASSIGN
    qbf-clump.qbf-csiz = qbf-clump.qbf-csiz + 1
    qbf-clump.qbf-cnam[qbf-clump.qbf-csiz] = ENTRY(1,qbf-rcn[qbf-i])
    qbf-clump.qbf-clbl[qbf-clump.qbf-csiz] = qbf-rcl[qbf-i]
    OVERLAY(qbf-clump.qbf-calc,qbf-clump.qbf-csiz,1,"CHARACTER":u)
      = SUBSTRING(qbf-rcc[qbf-i],1,1,"CHARACTER":u).
END.

/* load up non-calculated fields into qbf-clump #0 */
IF INDEX(qbf-p,"#":u) + INDEX(qbf-p,"$":u) = 0 THEN
  DO qbf-i = 1 TO qbf-rc#:
    IF qbf-rcc[qbf-i] > "" THEN NEXT.
    ASSIGN
      qbf-clump.qbf-csiz = qbf-clump.qbf-csiz + 1
      qbf-clump.qbf-cnam[qbf-clump.qbf-csiz] = ENTRY(1,qbf-rcn[qbf-i])
      qbf-clump.qbf-clbl[qbf-clump.qbf-csiz] = qbf-rcl[qbf-i].
  END.

/* insert database fields into each set */
ASSIGN
  qbf-a = INDEX(qbf-p,"#":u) > 0
  qbf-a = (IF qbf-a AND INDEX(qbf-p,"$":u) > 0 THEN ? ELSE qbf-a).

IF INDEX(qbf-p,"#":u) > 0 OR INDEX(qbf-p,"$":u) > 0 THEN
  DO qbf-i = 1 TO NUM-ENTRIES(qbf-t):
    CREATE qbf-clump.
    ASSIGN
      qbf-clump.qbf-csiz = 0
      qbf-clump.qbf-csho = (qbf-i < 2 OR INDEX(qbf-p,"$":u) = 0)
      qbf-clump.qbf-cext = 0
      qbf-clump.qbf-cnam = ""
      qbf-clump.qbf-clbl = ""
      qbf-clump.qbf-cfil = INTEGER(ENTRY(qbf-i,qbf-t)).
    {&FIND_TABLE_BY_ID} qbf-clump.qbf-cfil.
    CREATE ALIAS "QBF$0":u FOR DATABASE
      VALUE(SDBNAME(ENTRY(1,qbf-rel-buf.tname,".":u))).
    RUN aderes/j-clump2.p (qbf-clump.qbf-cfil,qbf-a,qbf-p).
  END.

FOR EACH qbf-clump WHERE qbf-clump.qbf-csiz = 0:
  DELETE qbf-clump.
END.
FIND FIRST qbf-clump NO-ERROR.

RETURN.

/* j-clump.p - end of file */

