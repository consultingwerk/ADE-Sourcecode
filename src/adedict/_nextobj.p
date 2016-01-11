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

File: _nextobj.p

Description:
   Get the next or previous of an object and update the property window
   and possibly the browse window to show the new object.   

Input Parameter: 
   p_Obj  - The object type (e.g., OBJ_TBL)
   p_Next - True - Do Next;  False - do Previous
      
Author: Laura Stern

Date Created: 05/03/92 
    Modified: 06/29/98 D. McMann Added _Owner to _File find
              05/19/99 Mario B.  Adjust Width Field browser integration.
              08/08/02 D. McMann Eliminated any sequences whose name begins "$" - Peer Direct

----------------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES
{adedict/dictvar.i  shared}
{adedict/uivar.i    shared}
{adedict/brwvar.i shared}    
{adecomm/cbvar.i    shared}

{adedict/TBL/tblvar.i shared}
{adedict/SEQ/seqvar.i shared}
{adedict/FLD/fldvar.i shared}
{adedict/IDX/idxvar2.i shared}
{adedict/IDX/idxvar.i shared}


Define INPUT PARAMETER p_Obj  as integer NO-UNDO.
Define INPUT PARAMETER p_Next as logical NO-UNDO.

Define var nxttbl as char NO-UNDO.

case p_Obj:
   when {&OBJ_TBL} then	
   do:
      if p_Next then 
      do:
      	 {adedict/TBL/nexttbl.i &Name = s_CurrTbl
      	       	     	      	&Next = nxttbl}
	 if nxttbl <> "" then
	 do:
	    run adecomm/_setcurs.p ("WAIT").
	    s_lst_Tbls:screen-value in frame browse = nxttbl.
      	    s_TblFill:screen-value in frame browse = nxttbl.
      	    run adedict/_objsel.p (INPUT {&OBJ_TBL}).
	    run adecomm/_setcurs.p ("").
	 end.
	 else do:
	    IF s_win_Tbl <> ? THEN
      	       current-window = s_win_Tbl.
	    ELSE IF s_win_Width <> ? THEN
	       current-window = s_win_Width.
	    message "You are at the last table." 
      	       view-as alert-box information buttons ok.
      	 end.
      end.
      else do:
	 find _File where _File._Db-recid = s_DbRecId AND
			  _File._File-Name = s_CurrTbl AND
			  (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN").
      	 if s_Show_Hidden_Tbls then
	    find PREV _File use-index _File-name
	      where _File._Db-recid = s_DbRecId 
	        and (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN") NO-ERROR.
      	 else
	    find PREV _File use-index _File-name 
      	      where NOT _File._Hidden and _File._Db-recid = s_DbRecId 
      	        and (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN") NO-ERROR.
      
	 if AVAILABLE _File then
	 do:
	    run adecomm/_setcurs.p ("WAIT").
	    s_lst_Tbls:screen-value in frame browse = _File._File-Name.
      	    s_TblFill:screen-value in frame browse  = _File._File-Name.
      	    run adedict/_objsel.p (INPUT {&OBJ_TBL}).
	    run adecomm/_setcurs.p ("").
	 end.
	 else do:
	    IF s_win_Tbl <> ? THEN
               current-window = s_win_Tbl.
	    ELSE IF s_win_Width <> ? THEN
	       current-window = s_win_Width.
	    message "You are at the first table."
	       view-as alert-box information buttons ok.
      	 end.
      end.
   end.
   when {&OBJ_SEQ} then
   do:	 
      if p_Next then
      do:
	 find FIRST _Sequence where _Sequence._Db-recid = s_DbRecId 
                            AND NOT _Sequence._Seq-Name BEGINS "$"
                            AND _Sequence._Seq-Name > s_CurrSeq NO-ERROR.
      
	 if AVAILABLE _Sequence then
	 do:
	    run adecomm/_setcurs.p ("WAIT").
	    s_lst_Seqs:screen-value in frame browse = _Sequence._Seq-Name.
      	    s_SeqFill:screen-value in frame browse = _Sequence._Seq-Name.
      	    run adedict/_objsel.p (INPUT {&OBJ_SEQ}).
	    run adecomm/_setcurs.p ("").
	 end.
	 else do:
      	    current-window = s_win_Seq.
	    message "You are at the last sequence."
	       view-as alert-box information buttons ok.
      	 end.
      end.
      else do:
	 find _Sequence where _Sequence._Db-recid = s_DbRecId 
                      AND NOT _Sequence._Seq-Name BEGINS "$"
                      AND _Sequence._Seq-Name = s_CurrSeq.
	 find PREV _Sequence where _Sequence._Db-recid = s_DbRecId 
                      AND NOT _Sequence._Seq-Name BEGINS "$"
                      use-index _Seq-name NO-ERROR.
      
	 if AVAILABLE _Sequence then
	 do:
	    run adecomm/_setcurs.p ("WAIT").
	    s_lst_Seqs:screen-value in frame browse = _Sequence._Seq-Name.
      	    s_SeqFill:screen-value in frame browse = _Sequence._Seq-Name.
      	    run adedict/_objsel.p (INPUT {&OBJ_SEQ}).
	    run adecomm/_setcurs.p ("").
	 end.
	 else do:
      	    current-window = s_win_Seq.
	    message "You are at the first sequence."
	       view-as alert-box information buttons ok.
      	 end.
      end.
   end.

   when {&OBJ_FLD} then
   do:	 
      if p_Next then
      do:
      	 find _File where RECID(_File) = s_TblRecId.
	 find _Field of _File where _Field._Field-Name = s_CurrFld.
	 if s_Order_By = {&ORDER_ALPHA} THEN
	    find NEXT _Field of _File use-index _Field-name NO-ERROR.
	 ELSE
	    find NEXT _Field of _File use-index _Field-position NO-ERROR.
	  
	 if AVAILABLE _Field then
	 do:
	    run adecomm/_setcurs.p ("WAIT").
      	    if s_Flds_Cached then
      	    do:
	       s_lst_Flds:screen-value in frame browse = _Field._Field-Name.
      	       s_FldFill:screen-value in frame browse = _Field._Field-Name.
      	    end.
      	    run adedict/_objsel.p (INPUT {&OBJ_FLD}).
	    run adecomm/_setcurs.p ("").
	 end.
	 else do:
      	    current-window = s_win_Fld.
	    message "You are at the last field."
	       view-as alert-box information buttons ok.
      	 end.
      end.
      else do:
      	 find _File where RECID(_File) = s_TblRecId.
	 find _Field of _File where _Field._Field-Name = s_CurrFld.
	 if s_Order_By = {&ORDER_ALPHA} THEN
	    find PREV _Field of _File use-index _Field-name NO-ERROR.
	 ELSE
	    find PREV _Field of _File use-index _Field-position NO-ERROR.
      
	 if AVAILABLE _Field then
	 do:
	    run adecomm/_setcurs.p ("WAIT").
      	    if s_Flds_Cached then
      	    do:
	       s_lst_Flds:screen-value in frame browse = _Field._Field-Name.
      	       s_FldFill:screen-value in frame browse = _Field._Field-Name.
      	    end.
	    run adedict/_objsel.p (INPUT {&OBJ_FLD}).
	    run adecomm/_setcurs.p ("").
	 end.
	 else do:
      	    current-window = s_win_Fld.
	    message "You are at the first field."
	       view-as alert-box information buttons ok.
      	 end.
      end.
   end.

   when {&OBJ_IDX} then
   do:	 
      if p_Next then 
      do:
      	 find _File where RECID(_File) = s_TblRecId.
	 find FIRST _Index of _File where _Index._Index-name > s_CurrIdx 
      	    NO-ERROR.
      
	 if AVAILABLE _Index then
	 do:	
	    run adecomm/_setcurs.p ("WAIT").
      	    if s_Idxs_Cached then
      	    do:
	       s_lst_Idxs:screen-value in frame browse = _Index._Index-Name.
      	       s_IdxFill:screen-value in frame browse = _Index._Index-Name.
      	    end.
	    run adedict/_objsel.p (INPUT {&OBJ_IDX}).
	    run adecomm/_setcurs.p ("").
	 end.
	 else do:
      	    current-window = s_win_Idx.
	    message "You are at the last index."
	       view-as alert-box information buttons ok.
      	 end.
      end.
      else do:
      	 find _File where RECID(_File) = s_TblRecId.
	 find _Index of _File where _Index._Index-Name = s_CurrIdx.
	 find PREV _Index of _File use-index _Index-name NO-ERROR.
      
	 if AVAILABLE _Index then
	 do:
	    run adecomm/_setcurs.p ("WAIT").
      	    if s_Idxs_Cached then
      	    do:
	       s_lst_Idxs:screen-value in frame browse = _Index._Index-Name.
      	       s_IdxFill:screen-value in frame browse = _Index._Index-Name.
      	    end.
	    run adedict/_objsel.p (INPUT {&OBJ_IDX}).
	    run adecomm/_setcurs.p ("").
	 end.
	 else do:
      	    current-window = s_win_Idx.
	    message "You are at the first index."
	       view-as alert-box information buttons ok.
      	 end.
      end.
   end.
end.




