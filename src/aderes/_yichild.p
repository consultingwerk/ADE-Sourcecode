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

