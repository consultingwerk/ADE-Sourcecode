/*********************************************************************
* Copyright (C) 2000,2020 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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

DEFINE QUERY q1 FOR dictdb._Sequence.

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
      	 find dictdb._File WHERE dictdb._File._File-name = "_Sequence"
      	              AND dictdb._File._Owner = "PUB"
      	              NO-LOCK.
      	 if NOT can-do(dictdb._File._Can-read, USERID("DICTDB")) then
      	    message s_NoPrivMsg "see any sequence information."
      	       view-as ALERT-BOX ERROR buttons OK.
      	 else
        
        /* OCTA-21469 - Avoids a FOR EACH query for _Sequence due to different index definitions
           between OE 11 and OE 12 */
	    /*for each dictdb._Sequence where dictdb._Sequence._Db-recid = s_DbRecId
                             AND NOT dictdb._Sequence._Seq-name BEGINS "$":
	       s_Res = s_lst_Seqs:add-last(dictdb._Sequence._Seq-name) in frame browse.
	    end.
         */

         QUERY q1:QUERY-PREPARE("FOR EACH dictdb._Sequence where dictdb._Sequence._Db-recid = " + STRING(s_DbRecId) +
                                " AND NOT dictdb._Sequence._Seq-name BEGINS '$'").
         QUERY q1:QUERY-OPEN.
         GET FIRST q1.

         DO WHILE NOT QUERY q1:QUERY-OFF-END:
            s_Res = s_lst_Seqs:add-last(dictdb._Sequence._Seq-name) in frame browse.
            GET NEXT q1.
         END.

         CLOSE QUERY q1.
         
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
      	 find dictdb._File WHERE dictdb._File._File-name = "_Index"
      	              AND dictdb._File._Owner = "PUB"
      	              NO-LOCK.
      	 if NOT can-do(dictdb._File._Can-read, USERID("DICTDB")) then
      	    message s_NoPrivMsg "see any index information."
      	       view-as ALERT-BOX ERROR buttons OK.
      	 else
	    for each dictdb._Index where dictdb._Index._File-recid = s_TblRecId:
	       s_Res = s_lst_Idxs:add-last(dictdb._Index._Index-name) in frame browse.
	    end.
      end.

      run Finish_Up (INPUT p_Obj,
      	       	     INPUT s_lst_Idxs:HANDLE in frame browse,
      	       	     INPUT-OUTPUT s_Idxs_Cached).
   end.
end. /* case */







