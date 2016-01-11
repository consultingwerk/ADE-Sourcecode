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
/* j-pairs.i - Figure out all the pairs of tables that have relationships
      	       and add them to a selection list.

   For example: If we have the following table relationships (left)
      	       	this will generate the following pairs (right)
   --------------------------------------------------------------------
      Customer 	     	      	    Between Customer and Invoice
        Order of Customer           Between Customer and Order
          Order-line of Order       Between Order and Order-line
            Item of Order-line      Between Order-line and Item
          Salesrep of Order         Between Order and Salesrep
        Invoice of Customer         Between Customer and State
        State of Customer

   Input Parameters:
      p_tbl  - The next table id to find relationships for 
      p_list - The selection list widget to add to.
      p_func - The name of a routine to call for each item added to list.
      	       It will be passed p_tbl (a table id) the joined table id,
      	       and the string being added to the select list.
      
   Written: Laura Stern - 5/2/94
*/

PROCEDURE join_pairs:
  DEFINE INPUT PARAMETER p_tbl  AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER p_list AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p_func AS CHARACTER NO-UNDO.

  DEFINE BUFFER b_where FOR qbf-where.

  DEFINE VARIABLE t_id     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lst_item AS CHARACTER NO-UNDO.
  DEFINE VARIABLE stat     AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE tbl1     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE tbl2     AS CHARACTER NO-UNDO.

  /* find all tables related to this one */
  FOR EACH b_where WHERE b_where.qbf-wrid = p_tbl:
    t_id = STRING(b_where.qbf-wtbl).

    /* compose the "between" string */
    {&FIND_TABLE_BY_ID} INTEGER(p_tbl).
    tbl1 = qbf-rel-buf.tname.
    {&FIND_TABLE_BY_ID} INTEGER(t_id).
    tbl2 = qbf-rel-buf.tname.
    lst_item = TRIM("Between":l12)
	       + ' "':u
	       + (IF qbf-hidedb THEN ENTRY(2,tbl1,".":u) ELSE tbl1)
	       + '" ':u
	       + "and":t8
	       + ' "':u
	       + (IF qbf-hidedb THEN ENTRY(2,tbl2,".":u) ELSE tbl2)
	       + '"':u.

    stat = p_list:ADD-LAST(lst_item).

    IF p_func <> "" THEN
      RUN VALUE(p_func) (p_tbl, t_id, lst_item).

    /* Do it again for this guys children */
    RUN join_pairs (t_id, p_list, p_func).
  END.
END.

/* j-pairs.i - end of file */

