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
Modified on 02/10/95 by Donna McMann changed to work with as400 meta schema files
----------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p_DbId  AS RECID NO-UNDO.

DEFINE SHARED STREAM rpt.
DEFINE VAR max_min AS INTEGER NO-UNDO.
DEFINE VAR cyc_ok  AS CHARACTER NO-UNDO.

FORM
  as4dict.p__Seq._Seq-Name  FORMAT "x(32)"  	 COLUMN-LABEL "Sequence Name"
  as4dict.p__Seq._Seq-init  FORMAT "->>>>>>>>9"  COLUMN-LABEL "Initial!Value"
  as4dict.p__Seq._Seq-incr  FORMAT "->>>>>>>>9"  COLUMN-LABEL "Increment"
  max_min              FORMAT "->>>>>>>>>9"      COLUMN-LABEL "Max/Min!Value"
  cyc_ok               FORMAT "x(3)"             COLUMN-LABEL "Cycle?"
  WITH FRAME shoseqs 
  DOWN USE-TEXT STREAM-IO.

FOR EACH as4dict.p__Seq NO-LOCK:
   max_min = (IF as4dict.p__Seq._Seq-incr > 0 THEN as4dict.p__Seq._Seq-max
      	       	     	      	       	 ELSE as4dict.p__Seq._Seq-min).   
   cyc_ok = (If as4dict.p__Seq._Cycle-OK = "Y" THEN "yes" ELSE "no").
      	       	     	      	       	 
   DISPLAY STREAM rpt
      as4dict.p__Seq._Seq-Name 
      as4dict.p__Seq._Seq-init 
      as4dict.p__Seq._Seq-incr 
      max_min
      cyc_ok 
      WITH FRAME shoseqs.
  DOWN STREAM rpt WITH FRAME shoseqs.
END.

