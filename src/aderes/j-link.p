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
/*
* j-link.p - add back relation information. This has grown to add
* any where information for all tables, even if there are no
* joins (ie, there is only 1 table)
*/

{ aderes/s-define.i }
{ aderes/j-define.i }
{ aderes/s-system.i }

DEFINE VARIABLE qbf-1 AS INTEGER   NO-UNDO. /* 1st table id */
DEFINE VARIABLE qbf-2 AS INTEGER   NO-UNDO. /* 2nd table id */
DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO. /* inner loop */
DEFINE VARIABLE qbf-l AS LOGICAL   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-o AS INTEGER   NO-UNDO. /* outer loop */
DEFINE VARIABLE qbf-p AS INTEGER   NO-UNDO. /* pos in qbf-rel-tt.rels */
DEFINE VARIABLE qbf-w AS INTEGER   NO-UNDO. /* pos in qbf-rel-whr array */
DEFINE VARIABLE qbf-c AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE jc-ix AS INTEGER   NO-UNDO. /* index into qbf-rel-choice */

FOR EACH qbf-where:
  ASSIGN
    qbf-where.qbf-wrel = ""
    qbf-where.qbf-wrid = "".
END.

DO qbf-o = 2 TO NUM-ENTRIES(qbf-tables):
  qbf-2 = INTEGER(ENTRY(qbf-o,qbf-tables)).

  /*- - - - - - - - - - - - - - - -- - - - - - - - - - --
  We've removed the ability for user to select which join
  partner he wants.  Also, user can no longer join a table
  to any table before it in the list - it must be joined to
  the previous table.  Leave this for future.
  
  Preceeding comment no longer applies - left for reference
  -dma
  - - - - - - - - - - - - - - - - - - - - - - - - - -*/

  /* If user specified a preferred join partner, use that.  In this
  case we know lookup_join will succeed but do it anyway in order
  to get qbf-w if join is based on a where.
  */
  RUN get_join_choice (STRING(qbf-2),OUTPUT jc-ix,OUTPUT qbf-c).
  
  IF jc-ix > 0 THEN DO:
    qbf-1 = INTEGER(qbf-c).
    RUN lookup_join (qbf-1,qbf-2,OUTPUT qbf-p,OUTPUT qbf-w).
  END.
  ELSE DO qbf-i = 1 TO qbf-o - 1: /* attempt matches from outer to inner */
    qbf-1 = integer(entry(qbf-i,qbf-tables)).

    RUN lookup_join (qbf-1,qbf-2,OUTPUT qbf-p,OUTPUT qbf-w).
    IF qbf-p > 0 THEN LEAVE. /* join found, exit inner loop */
  END.

  /*------------------------------------------------------------
  /* Instead: */
  qbf-1 = INTEGER(ENTRY(qbf-o - 1,qbf-tables)).
  RUN lookup_join (qbf-1,qbf-2,OUTPUT qbf-p,OUTPUT qbf-w).
  ------------------------------------------------------------*/

  /* This code is valid for both join strategies */
  IF qbf-p > 0 THEN DO:
    FIND FIRST qbf-where WHERE qbf-where.qbf-wtbl = qbf-2 NO-ERROR.
    IF NOT AVAILABLE qbf-where THEN
      CREATE qbf-where.
    {&FIND_TABLE_BY_ID} qbf-1.

    IF qbf-w > 0 THEN
      {&FIND_WHERE_BY_ID} qbf-w. 
    
    ASSIGN
      qbf-where.qbf-wtbl = qbf-2 /* base table */
      qbf-where.qbf-wrid = STRING(qbf-1) /* related table */
      qbf-where.qbf-wrel = (IF qbf-w <= 0 THEN
                              "OF ":u + qbf-rel-buf.tname
                            ELSE
                              "WHERE ":u + qbf-rel-whr.jwhere)
      .
  END.
END. /* qbf-o, outer loop */

/* Now add in the admin defined WHERE clause */
RUN synchAdminWhere.

/*
* Make another pass through the list of tables. Add the security information
* if there is a function for it.. This is its own block to properly handle
* error messages.
*/

IF _whereSecurity <> ? THEN DO:
  security:
  DO ON STOP UNDO security, RETRY security:
    IF RETRY THEN DO:
      RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l,"error":u,"ok":u,
        SUBSTITUTE("There is a problem with &1.  &2 cannot add Where Clause Security.",_whereSecurity,qbf-product)).

      LEAVE.
    END.

    DO qbf-o = 1 TO NUM-ENTRIES(qbf-tables):
      qbf-2 = INTEGER(ENTRY(qbf-o,qbf-tables)).

      FIND FIRST qbf-where WHERE qbf-where.qbf-wtbl = qbf-2 NO-ERROR.

      IF NOT AVAILABLE qbf-where THEN DO:
        CREATE qbf-where.
        qbf-where.qbf-wtbl = qbf-2.
      END.

      {&FIND_TABLE_BY_ID} qbf-2.
      qbf-c = qbf-rel-buf.tname.
      RUN VALUE(_whereSecurity) (qbf-c, USERID(ENTRY(1, qbf-c, ".":u)),
                                OUTPUT qbf-where.qbf-wsec).
    END.
  END.
END.

/* If first table was there before but in a different place, outer join
flag may still be on.  Turn it off.
*/
FIND qbf-where WHERE qbf-where.qbf-wtbl = INTEGER(ENTRY(1,qbf-tables)) NO-ERROR.
IF AVAILABLE qbf-where THEN
  qbf-where.qbf-wojo = NO.

RUN removeEmptyWheres.
RETURN.


/* lookup_join and get_join_choice routines */
{ aderes/p-join.i }
{ aderes/p-where.i }

/* j-link.p - end of file */

