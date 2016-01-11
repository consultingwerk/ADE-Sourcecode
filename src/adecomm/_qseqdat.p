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

/*----------------------------------------------------------------------------

File: _qseqdat.p

Description:
   Display _Sequence information for the quick sequence report.  It will go 
   to the currently set output device (e.g., a file, the printer).
 
Input Parameters:
   p_DbId - Id of the _Db record for this database.

Author: Tony Lavinio, Laura Stern

Date Created: 10/05/92

Modified on 06/14/94 by Gerry Seidl. Added NO-LOCKs to file accesses.
            08/08/02 D. McMann Eliminated any sequences whose name begins "$" - Peer Direct
----------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p_DbId  AS RECID NO-UNDO.

DEFINE SHARED STREAM rpt.
DEFINE VAR max_min AS INTEGER NO-UNDO.

FORM
  _Sequence._Seq-Name  FORMAT "x(32)"  	    COLUMN-LABEL "Sequence Name"
  _Sequence._Seq-init  FORMAT "->>>>>>>>9"  COLUMN-LABEL "Initial!Value"
  _Sequence._Seq-incr  FORMAT "->>>>>>>>9"  COLUMN-LABEL "Increment"
  max_min              FORMAT "->>>>>>>>>9" COLUMN-LABEL "Max/Min!Value"
  _Sequence._Cycle-Ok  FORMAT "yes/no"	    COLUMN-LABEL "Cycle?"
  WITH FRAME shoseqs 
  DOWN USE-TEXT STREAM-IO.

FOR EACH _Sequence NO-LOCK WHERE _Sequence._Db-recid = p_DbId
                             AND NOT _Sequence._Seq-name BEGINS "$":
   max_min = (IF _Sequence._Seq-incr > 0 THEN _Sequence._Seq-max
      	       	     	      	       	 ELSE _Sequence._Seq-min).
   DISPLAY STREAM rpt
      _Sequence._Seq-Name 
      _Sequence._Seq-init 
      _Sequence._Seq-incr 
      max_min
      _Sequence._Cycle-Ok 
      WITH FRAME shoseqs.
  DOWN STREAM rpt WITH FRAME shoseqs.
END.

