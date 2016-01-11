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
/* brsscrl.i - trigger code for SCROLL-NOTIFY trigger of SmartDataBrowse - 10/19/99 */

/* Reset the row count so that rowDisplay knows to clear the 
   list with the next rowDisplay event. */
DEFINE VARIABLE cRowVis       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hRowObj       AS HANDLE     NO-UNDO.
DEFINE VARIABLE lScrollRemote AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cRowids       AS CHARACTER  NO-UNDO.

{set VisibleRowReset YES}.
{get ScrollRemote lScrollRemote}.

/* If the number of rows currently displayed in the browse is less than the  
   number than can be displayed in the browse then we may have gotten to the
   end of a batch and need to get more rows to display, if the number of 
   rows currently displayed in the browse is zero then we don't want to
   do this because there are no records that satisfy the query */ 
                                   
IF BROWSE {&BROWSE-NAME}:NUM-ENTRIES NE 0 AND 
  BROWSE {&BROWSE-NAME}:NUM-ENTRIES < BROWSE {&BROWSE-NAME}:DOWN THEN DO:

    {src/adm2/brsoffnd.i}
END.  /* if num-entries < down */
ELSE IF lScrollRemote THEN DO:
  {get VisibleRowids cRowids}.
  {get QueryRowObject hRowObj}. 
  cRowVis = DYNAMIC-FUNCTION("rowVisible":U,cRowids,hRowObj).
  CASE cRowVis:
    WHEN "FIRST":U THEN
    DO:
      {src/adm2/brsoffhm.i}
    END.
    WHEN "LAST":U THEN
    DO:
      {src/adm2/brsoffnd.i}
    END.
  END CASE.
END.






