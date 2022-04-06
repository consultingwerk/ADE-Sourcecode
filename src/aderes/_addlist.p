/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
* _addlist.p
*
*   Returns list of calculated fields for Where Builder
*/

{ aderes/j-define.i }
{ aderes/s-alias.i } 
{ aderes/s-define.i }
{ adeshar/quryshar.i }

DEFINE OUTPUT PARAMETER qbf-f AS CHARACTER NO-UNDO.

DEFINE VARIABLE qbf-i   AS INTEGER   NO-UNDO.
DEFINE VARIABLE refName AS CHARACTER NO-UNDO.

/* For RESULTS, _AliasList should only contain one table name */
RUN alias_to_tbname (_AliasList,TRUE,OUTPUT refName).

/* Make sure we grab calc fields from the proper qbf-section */
IF AVAILABLE qbf-rel-buf THEN
  FIND FIRST qbf-section 
    WHERE CAN-DO(qbf-section.qbf-stbl,STRING(qbf-rel-buf.tid)) NO-ERROR.
IF NOT AVAILABLE qbf-section THEN RETURN.

DO qbf-i = 1 TO qbf-rc#:
  /*
  message
    "sout" qbf-section.qbf-sout skip
    "rcn" qbf-rcn[qbf-i] skip
    "rcs" qbf-rcs[qbf-i] skip
    view-as alert-box title "_addlist.p".
  */

  IF qbf-rcc[qbf-i] = "" OR NOT CAN-DO("s,d,n,l":u,
    SUBSTRING(qbf-rcc[qbf-i],1,1,"CHARACTER":u)) 
    OR qbf-section.qbf-sout <> qbf-rcs[qbf-i] THEN NEXT.

  qbf-f = qbf-f
        + (IF qbf-f = "" THEN "" ELSE ",":u)
        + ENTRY(1,qbf-rcn[qbf-i]).
END.

RETURN.

/* _calcfld.p - end of file */

