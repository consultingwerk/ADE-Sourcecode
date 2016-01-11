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

File: _brwlist.p

Description:
   Fill one of the selection lists shown in the browse window.

Input Parameter:
   p_Obj - The object type indicating which list to fill.
 
Author: Laura Stern

Date Created: 02/04/92 
    Modified: 07/10/98 D. McMann Added _Owner to _File find.
              08/08/02 D. McMann Eliminated any sequences whose name begins "$" - Peer Direct

----------------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i shared}
{adedict/brwvar.i shared}
{adedict/uivar.i shared}


Define INPUT parameter p_Obj as integer NO-UNDO.


/*----------------------------------------------------------------------
   Do some common processing for all objects.

   Input Parameters:
      p_Obj    - The object type indicating which list to fill.
      p_List   - Handle of selection list for this object

   Input/Output Parameters:
      p_Cached - Cached flag

   Output Parameters:
      p_Curr   - Set to the selected value in the list (the first value).

----------------------------------------------------------------------*/
PROCEDURE Finish_Up:

Define INPUT   	     PARAMETER p_Obj  as integer     	 NO-UNDO.
Define INPUT   	     PARAMETER p_List as widget-handle 	 NO-UNDO.
Define INPUT-OUTPUT  PARAMETER p_Cached as logical    	 NO-UNDO.

Define var val as char NO-UNDO.

   if NOT p_Cached then  
   do:
      val = p_List:Entry(1).
      if val <> ? then  /* will be ? if list is empty */
      	 p_List:SCREEN-VALUE = val.
      apply "value-changed" to p_List.
      p_Cached = true.
   end.

   /* view and hide stuff in the browse window. */
   run adedict/_brwadj.p (INPUT p_Obj, INPUT p_List:num-items).
end.   


/*---------------------------Mainline code-------------------------------*/

Define var access as logical NO-UNDO.

CURRENT-WINDOW = s_win_Browse.
s_DictState = {&STATE_OBJ_SELECTED}.

case p_Obj:
   when {&OBJ_TBL} then
   do:
      if NOT s_Tbls_Cached then
      do: 
      	 run adecomm/_tbllist.p
      	    (INPUT  s_lst_Tbls:HANDLE in frame browse,
      	     INPUT  s_Show_Hidden_Tbls,
      	     INPUT  s_DbRecId,
      	     INPUT  "",
             INPUT  " " , /* all foreign types allowed (hutegger 95/06) */
                   /* BUFFER,FUNCTION,PACKAGE,PROCEDURE,SEQUENCE,VIEW", */
      	     OUTPUT access).
      end.

      run Finish_Up (INPUT p_Obj,
      	       	     INPUT s_lst_Tbls:HANDLE in frame browse,
      	       	     INPUT-OUTPUT s_Tbls_Cached).
   end.  

   when {&OBJ_SEQ} then
   do:
      if NOT s_Seqs_Cached then
      do:
      	 find _File WHERE _File._File-name = "_Sequence"
      	              AND _File._Owner = "PUB"
      	              NO-LOCK.
      	 if NOT can-do(_File._Can-read, USERID("DICTDB")) then
      	    message s_NoPrivMsg "see any sequence information."
      	       view-as ALERT-BOX ERROR buttons OK.
      	 else
	    for each _Sequence where _Sequence._Db-recid = s_DbRecId
                             AND NOT _Sequence._Seq-name BEGINS "$":
	       s_Res = s_lst_Seqs:add-last(_Sequence._Seq-name) in frame browse.
	    end.
      end.
   
      run Finish_Up (INPUT p_Obj,
      	       	     INPUT s_lst_Seqs:HANDLE in frame browse,
      	       	     INPUT-OUTPUT s_Seqs_Cached).
   end.

   when {&OBJ_FLD} then
   do:
      if s_CurrTbl = "" then return.
   
      if NOT s_Flds_Cached then
      do:
      	 run adecomm/_fldlist.p
      	    (INPUT   s_lst_Flds:HANDLE in frame browse,
      	     INPUT   s_TblRecId,
      	     INPUT   (if s_Order_By = {&ORDER_ALPHA} then true else false),
      	     INPUT   "",
      	     INPUT   ?,
	     INPUT   no,
      	     INPUT   "",
      	     OUTPUT  access).
      end.
   
      run Finish_Up (INPUT p_Obj,
      	       	     INPUT s_lst_Flds:HANDLE in frame browse,
      	       	     INPUT-OUTPUT s_Flds_Cached).
   end.

   when {&OBJ_IDX} then
   do:
      if s_CurrTbl = "" then return.
   
      if NOT s_Idxs_Cached then
      do:
      	 find _File WHERE _File._File-name = "_Index"
      	              AND _File._Owner = "PUB"
      	              NO-LOCK.
      	 if NOT can-do(_File._Can-read, USERID("DICTDB")) then
      	    message s_NoPrivMsg "see any index information."
      	       view-as ALERT-BOX ERROR buttons OK.
      	 else
	    for each _Index where _Index._File-recid = s_TblRecId:
	       s_Res = s_lst_Idxs:add-last(_Index._Index-name) in frame browse.
	    end.
      end.

      run Finish_Up (INPUT p_Obj,
      	       	     INPUT s_lst_Idxs:HANDLE in frame browse,
      	       	     INPUT-OUTPUT s_Idxs_Cached).
   end.
end. /* case */






