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

File: _qidxdat.p

Description:
   Display _Index information for the quick index report.  It will go to 
   the currently set output device (e.g., a file, the printer).
 
Input Parameters:
   p_DbId - Id of the _Db record for this database.
   p_Tbl  - The name of the table whose indexes we're showing or "ALL".

Author: Tony Lavinio, Laura Stern

Date Created: 10/05/92

Modified on 06/14/94 by Gerry Seidl. Added NO-LOCKs to file accesses. 
Modified on 02/13/95 by D. McMann to work with Progress/400 data dictionary.
            04/06/99 D. McMann Added stored procedure support
----------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p_DbId AS RECID NO-UNDO.
DEFINE INPUT PARAMETER p_Tbl  AS CHAR  NO-UNDO.

DEFINE SHARED STREAM rpt.
DEFINE VARIABLE flags      AS CHARACTER   NO-UNDO. 
DEFINE VARIABLE acedec     AS CHARACTER FORMAT "x(1)" NO-UNDO.

FORM
   as4dict.p__File._File-name  LABEL "Table"
   SKIP
   WITH FRAME tblhdr NO-ATTR-SPACE USE-TEXT SIDE-LABELS STREAM-IO.

FORM
  flags                   FORMAT "x(5)"  COLUMN-LABEL "Flags"
  as4dict.p__Index._Index-name      FORMAT "x(32)" COLUMN-LABEL "Index Name"
  as4dict.p__Index._Num-comp        FORMAT ">>9"   COLUMN-LABEL "Cnt"
  acedec       COLUMN-LABEL "Fi" SPACE(0)
  as4dict.p__Field._Field-name      FORMAT "x(31)" COLUMN-LABEL "eld Name"
  WITH FRAME shoindex 
  DOWN USE-TEXT STREAM-IO.

FORM
  SKIP(1) 
  SPACE(3) as4dict.p__File._File-name LABEL "Working on" FORMAT "x(32)" SPACE
  SKIP(1)
  WITH FRAME working_on SIDE-LABELS VIEW-AS DIALOG-BOX 
  TITLE "Generating Report".


/*----------------------------Mainline code--------------------------------*/

IF p_Tbl = "ALL" THEN
   SESSION:IMMEDIATE-DISPLAY = yes.

FOR EACH as4dict.p__File NO-LOCK WHERE (IF p_Tbl = "ALL" THEN as4dict.p__File._Hidden = "N"
      	       	     	                  ELSE as4dict.p__File._File-name = p_Tbl)
      	       BY as4dict.p__File._File-name:
   IF as4dict.p__File._For-Info = "PROCEDURE" THEN NEXT.
   IF p_Tbl = "ALL" THEN
      DISPLAY as4dict.p__File._File-name WITH FRAME working_on.

   DISPLAY STREAM rpt as4dict.p__File._File-name WITH FRAME tblhdr.

   FOR EACH as4dict.p__Index WHERE as4dict.p__Index._File-number =  
                                         as4dict.p__File._File-number NO-LOCK 
                              BREAK BY as4dict.p__Index._Index-name:
      FIND LAST as4dict.p__Idxfd WHERE as4dict.p__Idxfd._File-number =
                                               as4dict.p__Index._File-number 
             AND as4dict.p__Idxfd._Idx-num = as4dict.p__Index._Idx-num
             NO-LOCK NO-ERROR.
      flags = 
      	 ( (IF as4dict.p__File._Prime-index = as4dict.p__Index._Idx-num 
	       THEN "p" ELSE "")
	   + (IF as4dict.p__Index._Unique = "Y"   
	       THEN "u" ELSE "")
	   + (IF as4dict.p__Index._Active <> "Y"
	       THEN "i" ELSE "") 
	   + (IF as4dict.p__Index._Wordidx = 1
	       THEN "w" ELSE "") 
      	   + (IF AVAILABLE as4dict.p__Idxfd AND 
      	         as4dict.p__Idxfd._Abbreviate = "Y"
      	       THEN "a" ELSE "") ).

      DISPLAY STREAM rpt
      	  flags
	  as4dict.p__Index._Index-name
      	  as4dict.p__Index._Num-comp
      	  WITH FRAME shoindex.
      
      FOR EACH as4dict.p__Idxfd where   as4dict.p__Idxfd._File-number = as4dict.p__Index._File-number
                                                    AND as4dict.p__Idxfd._Idx-num = as4dict.p__Index._Idx-num:
           IF as4dict.p__Idxfd._If-misc2[8] = "Y" THEN NEXT.                                        
           FOR EACH as4dict.p__Field where as4dict.p__Field._Fld-number = as4dict.p__Idxfd._Fld-number  
                                   and as4dict.p__Field._File-number = as4dict.p__Index._File-number NO-LOCK:
                 ASSIGN acedec = (IF as4dict.p__Idxfd._Ascending = "Y" THEN "+" ELSE "-").
                 DISPLAY STREAM rpt
                      acedec
	    as4dict.p__Field._Field-name
	    WITH FRAME shoindex.
	DOWN STREAM rpt WITH FRAME shoindex.     
             END.
      END.
      
     /* Put an extra line in between each index. */
     IF LAST-OF(as4dict.p__Index._Index-name) THEN 
        DOWN STREAM rpt 1 WITH FRAME shoindex.
   END.
END.

IF p_Tbl = "ALL" THEN
DO:
   HIDE FRAME working_on NO-PAUSE.
   SESSION:IMMEDIATE-DISPLAY = no.
END.


