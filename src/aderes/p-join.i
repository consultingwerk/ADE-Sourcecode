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
/* p-join.i - routines to determine valid join possibilities */

/*------------------------------------------------------------------
   Finds if a join between two tables exists in the join table 

   input:  qbf_x, qbf_y - table ids from relation table
   output: qbf_z - ENTRY in qbf-rel-tt.rels for table qbf_x that holds
      	       	   this join, or 0 for none
	   qbf_w - pointer into qbf-rel-whr if WHERE clause used, 
      	       	   else 0 for OF
------------------------------------------------------------------*/
PROCEDURE lookup_join:
  DEFINE INPUT  PARAMETER qbf_x AS INTEGER NO-UNDO. /* 1st file */
  DEFINE INPUT  PARAMETER qbf_y AS INTEGER NO-UNDO. /* 2nd file */
  DEFINE OUTPUT PARAMETER qbf_z AS INTEGER NO-UNDO.
  DEFINE OUTPUT PARAMETER qbf_w AS INTEGER NO-UNDO.

  DEFINE VARIABLE qbf_c AS CHARACTER NO-UNDO. /* scrap */
  DEFINE VARIABLE qbf_i AS INTEGER   NO-UNDO. /* scrap */

  /* Find the relationship record that corresponds to the 2 tables
     with ids qbf_x and qbf_y.
  */
  {&FIND_TABLE_BY_ID} qbf_x.
  DO qbf_i = 2 TO NUM-ENTRIES(qbf-rel-buf.rels) WHILE qbf_z = 0:
    qbf_c = SUBSTRING(ENTRY(qbf_i,qbf-rel-buf.rels),2,-1,"CHARACTER":u).
    IF ENTRY(1,qbf_c,":":u) = STRING(qbf_y) THEN qbf_z = qbf_i.
  END.

  IF qbf_z > 0 THEN qbf_w = INTEGER(ENTRY(2,qbf_c + ":":u,":":u)).
END PROCEDURE.


/*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
   We've removed the ability for user to select which join
   partner he wants.   Leave for future.
   i.e., Only for fancy join support.
- - - - - - - - - - - - - - - - - - - -*/
/*------------------------------------------------------------------
   Finds if there is a preferred join choice for a given table

   input:  qbf_t - table id (string form)
   output: qbf_i - index into qbf-rel-choice if there is a choice
      	       	   or 0 for none
	   qbf_p - the preferred join partner (qbf-rel-tt.tid value) 
      	       	   or "0" for none
------------------------------------------------------------------*/
PROCEDURE get_join_choice:
  DEFINE INPUT  PARAMETER qbf_t AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER qbf_i AS INTEGER   NO-UNDO INIT 0.
  DEFINE OUTPUT PARAMETER qbf_p AS CHARACTER NO-UNDO INIT "0".

  DEFINE VARIABLE qbf_l    AS INTEGER   NO-UNDO. /* loop */
  DEFINE VARIABLE qbf_ch   AS CHARACTER NO-UNDO. /* choice */
  DEFINE VARIABLE colon_ix AS INTEGER   NO-UNDO.

  DO qbf_l = 1 TO NUM-ENTRIES(qbf-rel-choice) WHILE qbf_p = "0":
    qbf_ch = ENTRY(qbf_l, qbf-rel-choice).
    colon_ix = INDEX(qbf_ch, ":").
    IF SUBSTRING(qbf_ch, 1, colon_ix - 1,"CHARACTER":u) = qbf_t THEN
      ASSIGN
        qbf_i = qbf_l
        qbf_p = SUBSTRING(qbf_ch, colon_ix + 1,-1,"CHARACTER":u).
  END.
END PROCEDURE.

/* p-join.i - end of file */

