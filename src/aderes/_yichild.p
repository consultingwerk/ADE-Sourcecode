/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* _yichild.p - (Inner Child) 
   Get the first child table across a master-detail split that we want to
   do an inner join with.  This enables us to get only parent records
   where any child records exist.

   Input Parameter:
      p_sout - the section outline for the parent section.

   Output Parameter:
      p_ctbl - child table OR ? if there is no child section or
      	       the join relationship is an outer join.
*/
{ aderes/s-define.i}

DEFINE INPUT  PARAMETER p_sout AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER p_ctbl AS CHAR NO-UNDO. 

DEFINE BUFFER qbf_sbuffer FOR qbf-section.

p_ctbl = ?.
FIND FIRST qbf_sbuffer 
  WHERE qbf_sbuffer.qbf-sout BEGINS p_sout AND
        NUM-ENTRIES(qbf_sbuffer.qbf-sout,".":u) = 
      	  NUM-ENTRIES(p_sout,".":u) + 1 NO-ERROR.
IF AVAILABLE qbf_sbuffer AND 	    /* found a child section */
   NOT qbf_sbuffer.qbf-sojo THEN    /* want inner join */
  p_ctbl = ENTRY(1, qbf_sbuffer.qbf-stbl).

/* _yichild.p - end of file */

