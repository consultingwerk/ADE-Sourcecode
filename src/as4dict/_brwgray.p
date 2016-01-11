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
File: _brwgray.p

Description:
   On each change of state in the dictionary, this is called to gray or ungray
   menu items as appropriate for the state.  States are based on
   what is selected.  See dictvar.i for a more complete comment on
   the meaning of each state.  The enabled-ness of the browse buttons 
   (create/props/delete) is also adjusted here.
   
   NOTE: Undo and Commit are handled by a different mechanism.
      	 Undo and commit are grayed/ungrayed based on whether
      	 the dictionary is dirty or not.  Connect and disconnect are 
      	 also handled separately - Connect is always sensitive.  Disconnect
      	 is sensitive unless there are no databases in the list. 

Input Parameter:
   p_Init - yes  - initialize the gray tables.
      	    no   - gray/ungray menu items as appropriate.

Author: Laura Stern

Date Created: 03/26/92   
    Modified: 01/1995  D. McMann to work with PROGRESS/400 Data Dictionary
              06/17/96 D. McMann Removed &ADMIN_SYNC so that the sync
                       process will always be available.
              10/25/96 D. McMann Added Freeze/Unfreeze to admin menu and can
                       only be enabled if in DBA Mode.     
              09/29/99 D. McMann Added proper greying when procedures and
                       parameters are being selected.  
              01/31/01 D. MCMann Added loading AS/400 Incremental  
----------------------------------------------------------------------------*/

{as4dict/dictvar.i shared}
{as4dict/menu.i shared}
{as4dict/brwvar.i shared}

Define INPUT PARAMETER p_Init as logical NO-UNDO.

/* Indicates which items need to be grayed (no) or ungrayed (yes). */
Define var ungray    as logical extent {&NUM_GRAY_ITEMS} NO-UNDO.
Define var read_only as logical                          NO-UNDO.

&Global-define    DETAILEDTBL    1 
&Global-define    QUICKTBL       2 
&Global-define    FLDRPT_CURRTBL 3
&Global-define    FLDRPT_ALLTBLS 4
&Global-define    IDXRPT_CURRTBL 5
&Global-define    IDXRPT_ALLTBLS 6
&Global-define    QUICKVIW       7
&Global-define    QUICKSEQ       8 
&Global-define    TRIG_RPT       9
&Global-define    QUICKUSR       10 
&Global-define    RELRPT_CURRTBL 11
&Global-define    RELRPT_ALLTBLS 12
&Global-define    EXIT	      13
&Global-define    DELETE   	      14
&Global-define    PROPERTIES     15
&Global-define    CRT_DATABASE   16
&Global-define    CRT_TABLE      17
&Global-define    CRT_SEQUENCE   18
&Global-define    CRT_FIELD      19
&Global-define    CRT_INDEX      20
&Global-define    FIELD_RENAME   21
&Global-define    SHOW_HIDDEN    23
&Global-define    ORDER_FIELDS   24
&Global-define    BUTTON_CREATE  25
&Global-define    BUTTON_PROPS   26   
&Global-define    BUTTON_DELETE  27   
&Global-define    MODE_DATABASE  28
&Global-define    MODE_TABLE     29
&Global-define    MODE_SEQUENCE  30
&Global-define    MODE_FIELD     31
&Global-define    MODE_INDEX     32 
&Global-define    LOAD_DEF       33
&Global-define    LOAD_DATA      34
&Global-define    LOAD_SEQ       35
&Global-define    FREZ_UNFREZ    36
&Global-define    CRT_PROC       37
&Global-define    CRT_PARM       38
&Global-define    MODE_PROC      39
&Global-define    MODE_PARM      40
&Global-define    DETAILEDPROC   41
&Global-define    LOAD_INC       42

Define var item   as integer  	    NO-UNDO. /* index into Gray_Items array */
Define var h_item as widget-handle  NO-UNDO. /* menu item handle value */


/*--------------------------- Mainline Code --------------------------------*/

if p_Init then
do:
   assign
      Gray_Items[{&DETAILEDTBL}]    = MENU-ITEM mi_DetailedTbl:HANDLE
      Gray_Items[{&QUICKTBL}]       = MENU-ITEM mi_QuickTbl:HANDLE
      Gray_Items[{&FLDRPT_CURRTBL}] = MENU-ITEM mi_f_CurrTbl:HANDLE
      Gray_Items[{&FLDRPT_ALLTBLS}] = MENU-ITEM mi_f_AllTbls:HANDLE
      Gray_Items[{&IDXRPT_CURRTBL}] = MENU-ITEM mi_i_CurrTbl:HANDLE
      Gray_Items[{&IDXRPT_ALLTBLS}] = MENU-ITEM mi_i_AllTbls:HANDLE
      Gray_Items[{&QUICKSEQ}]       = MENU-ITEM mi_QuickSeq:HANDLE
      Gray_Items[{&TRIG_RPT}]       = MENU-ITEM mi_Trigger:HANDLE
      Gray_Items[{&RELRPT_CURRTBL}] = MENU-ITEM mi_r_CurrTbl:HANDLE
      Gray_Items[{&RELRPT_ALLTBLS}] = MENU-ITEM mi_r_AllTbls:HANDLE
      Gray_Items[{&DETAILEDPROC}]   = MENU-ITEM mi_DetailedPrc:HANDLE
      Gray_Items[{&EXIT}]           = MENU-ITEM mi_Exit:HANDLE
      Gray_Items[{&DELETE}]         = MENU-ITEM mi_Delete:HANDLE
      Gray_Items[{&PROPERTIES}]     = MENU-ITEM mi_Properties:HANDLE
      Gray_Items[{&CRT_TABLE}]      = MENU-ITEM mi_Crt_Table:HANDLE
      Gray_Items[{&CRT_SEQUENCE}]   = MENU-ITEM mi_Crt_Sequence:HANDLE
      Gray_Items[{&CRT_PARM}]       = MENU-ITEM mi_Crt_PARM:HANDLE
      Gray_Items[{&CRT_PROC}]       = MENU-ITEM mi_Crt_PROC:HANDLE
      Gray_Items[{&CRT_FIELD}]      = MENU-ITEM mi_Crt_Field:HANDLE
      Gray_Items[{&CRT_INDEX}]      = MENU-ITEM mi_Crt_Index:HANDLE
      Gray_Items[{&FIELD_RENAME}]   = MENU-ITEM mi_Field_Rename:HANDLE
      Gray_Items[{&SHOW_HIDDEN}]    = MENU-ITEM mi_Show_Hidden:HANDLE
      Gray_Items[{&ORDER_FIELDS}]   = MENU-ITEM mi_Order_Fields:HANDLE
      Gray_Items[{&BUTTON_CREATE}]  = s_btn_Create:HANDLE in frame browse
      Gray_Items[{&BUTTON_PROPS}]   = s_btn_Props:HANDLE in frame browse
      Gray_Items[{&BUTTON_DELETE}]  = s_btn_Delete:HANDLE in frame browse
      Gray_Items[{&MODE_DATABASE}]  = MENU-ITEM mi_Mode_Db:HANDLE
      Gray_Items[{&MODE_TABLE}]     = MENU-ITEM mi_Mode_Tbl:HANDLE
      Gray_Items[{&MODE_SEQUENCE}]  = MENU-ITEM mi_Mode_Seq:HANDLE
      Gray_Items[{&MODE_FIELD}]     = MENU-ITEM mi_Mode_Fld:HANDLE
      Gray_Items[{&MODE_INDEX}]     = MENU-ITEM mi_Mode_Idx:HANDLE
      Gray_Items[{&MODE_PROC}]      = MENU-ITEM mi_Mode_Proc:HANDLE
      Gray_Items[{&MODE_PARM}]      = MENU-ITEM mi_Mode_Parm:HANDLE
      Gray_Items[{&LOAD_DEF}]       = MENU-ITEM mi_Load_Defs:HANDLE
      Gray_Items[{&LOAD_INC}]       = MENU-ITEM mi_Load_Inc:HANDLE
      Gray_Items[{&LOAD_DATA}]      = MENU-ITEM mi_Load_Contents:HANDLE 
      Gray_Items[{&LOAD_SEQ}]       = MENU-ITEM mi_Load_SeqVals:HANDLE
      Gray_Items[{&FREZ_UNFREZ}]    = MENU-ITEM mi_Frozen:HANDLE 
      .
      
   /* Initialize these. */
   assign
      MENU-ITEM mi_Undo:sensitive = false
      MENU-ITEM mi_Commit:sensitive = false.
 
   return.
end.
/*-----------------------End of Init code-------------------------------*/

ungray = no.  /* init array to no's */
read_only = s_ReadOnly OR s_DB_ReadOnly.
 
/* For each progressive state determine which items should be enabled */
if s_DictState >= {&STATE_NO_DB_SELECTED} then
   assign
      ungray[{&EXIT}] = yes
      ungray[{&BUTTON_CREATE}] = yes
      ungray[{&MODE_DATABASE}] = yes.

if s_DictState >= {&STATE_NO_OBJ_SELECTED} then
do:
   assign
      ungray[{&DETAILEDTBL}] = yes
      ungray[{&DETAILEDPROC}] = (IF allow_st_proc THEN YES ELSE NO)
      ungray[{&QUICKTBL}] = yes
      ungray[{&FLDRPT_ALLTBLS}] = yes
      ungray[{&IDXRPT_ALLTBLS}] = yes
      ungray[{&QUICKVIW}] = yes 
      ungray[{&QUICKSEQ}] = yes
      ungray[{&QUICKUSR}] = yes 
      ungray[{&TRIG_RPT}] = yes
      ungray[{&RELRPT_ALLTBLS}] = yes
      ungray[{&MODE_TABLE}] = yes
      ungray[{&MODE_SEQUENCE}] = YES
      ungray[{&MODE_FIELD}] = (IF s_CurrTbl <> "" THEN YES ELSE NO)
      ungray[{&MODE_INDEX}] = (IF s_CurrTbl <> "" THEN YES ELSE NO). 

   IF allow_st_proc THEN 
     ASSIGN ungray[{&MODE_PROC}] = yes.
            ungray[{&MODE_PARM}] = (IF s_CurrProc <> "" THEN YES ELSE NO).  
                  
   if s_CurrObj = {&OBJ_DB} then
      assign
      	 ungray[{&PROPERTIES}] = yes
      	 ungray[{&BUTTON_PROPS}] = yes
         ungray[{&MODE_FIELD}] = NO
         ungray[{&MODE_INDEX}] = NO            
         ungray[{&MODE_PARM}] = NO.
   else
      /* Here's the only place we have to undo what we did above since now
      	 create doesn't mean create database but create some schema object.
      */
      if read_only then
          ASSIGN ungray[{&BUTTON_CREATE}] = no.


   if NOT read_only then
      assign
	 ungray[{&CRT_TABLE}] = yes
	 ungray[{&CRT_SEQUENCE}] = yes
	 ungray[{&CRT_PROC}] = (IF allow_st_proc THEN YES ELSE NO)	 
     ungray[{&FIELD_RENAME}] = yes.
end.

if s_DictState = {&STATE_OBJ_SELECTED} then
do:
   if s_Lvl1Obj = {&OBJ_TBL} then
      assign
      	 ungray[{&SHOW_HIDDEN}] = yes.

   if ((s_CurrObj = {&OBJ_TBL} AND s_CurrTbl <> "") OR
       (s_CurrObj = {&OBJ_SEQ} AND s_CurrSeq <> "") OR
       (s_CurrObj = {&OBJ_FLD} AND s_CurrFld <> "") OR
       (s_CurrObj = {&OBJ_IDX} AND s_CurrIdx <> "") OR
       (s_CurrObj = {&OBJ_PROC} AND s_CurrProc <> "") OR
       (s_CurrObj = {&OBJ_PARM} AND s_CurrParm <> "")) then
   do:
      assign
      	 ungray[{&PROPERTIES}] = yes
      	 ungray[{&BUTTON_PROPS}] = yes.
      	 
      if NOT read_only then
      	 assign
      	    ungray[{&DELETE}] = yes
      	    ungray[{&BUTTON_DELETE}] = yes.
   end.

   if (s_Lvl1Obj = {&OBJ_TBL} AND s_CurrTbl <> "") OR s_win_Tbl <> ? then
   do:

      assign
      	 ungray[{&FLDRPT_CURRTBL}] = yes
      	 ungray[{&IDXRPT_CURRTBL}] = yes
      	 ungray[{&RELRPT_CURRTBL}] = yes.

      if NOT read_only then
      	 assign
	    ungray[{&CRT_FIELD}] = yes
	    ungray[{&CRT_INDEX}] = yes
        ungray[{&FIELD_RENAME}] = YES
      	ungray[{&MODE_FIELD}] = yes
      	ungray[{&MODE_INDEX}] = yes
        ungray[{&CRT_PARM}] = NO
        ungray[{&MODE_PARM}] = NO.
      ELSE
        ASSIGN ungray[{&MODE_PARM}] = NO.

   end.

   if s_Lvl1Obj = {&OBJ_SEQ}  THEN     
         ASSIGN
            ungray[{&CRT_TABLE}] = NO
            ungray[{&CRT_FIELD}] = NO
	        ungray[{&CRT_INDEX}] = NO
            ungray[{&CRT_PROC}] = NO 
            ungray[{&CRT_PARM}] = NO
            ungray[{&MODE_FIELD}] = NO
            ungray[{&MODE_INDEX}] = NO            
            ungray[{&MODE_PARM}] = NO.

   if s_Lvl1Obj = {&OBJ_PROC} THEN do:
      if NOT read_only then
      	 ASSIGN ungray[{&CRT_PARM}] = ( IF s_CurrProc <> "" THEN YES ELSE NO )
                ungray[{&MODE_PARM}] = ( IF s_CurrProc <> "" THEN YES ELSE NO )
                ungray[{&CRT_TABLE}] = NO
                ungray[{&CRT_SEQUENCE}] = NO
                ungray[{&CRT_FIELD}] = NO
	            ungray[{&CRT_INDEX}] = NO
                ungray[{&MODE_FIELD}] = NO
      	        ungray[{&MODE_INDEX}] = NO.
      ELSE
        ASSIGN ungray[{&MODE_FIELD}] = NO
      	       ungray[{&MODE_INDEX}] = NO
               ungray[{&CRT_PARM}] = NO
               ungray[{&MODE_PARM}] = ( IF s_CurrProc <> "" THEN YES ELSE NO ).
   end.

   if (s_Lvl2Obj = {&OBJ_FLD} AND s_CurrFld <> "") then
      assign
      	 ungray[{&ORDER_FIELDS}] = yes.             
      	 
   if NOT read_only then
         assign
            ungray[{&LOAD_DEF}] = yes
            ungray [{&LOAD_INC}] = no
            ungray[{&LOAD_DATA}] = no
            ungray[{&LOAD_SEQ}] = yes
            ungray[{&FREZ_UNFREZ}] = yes.

    ELSE
         assign
            ungray[{&LOAD_DEF}] = no
            ungray [{&LOAD_INC}] = ( IF allow_enhdba THEN YES ELSE NO )
            ungray[{&LOAD_DATA}] = yes
            ungray[{&LOAD_SEQ}] = no
            ungray[{&FREZ_UNFREZ}] = no.
 
end.

/* Now enable all those we just set "yes" for.  Whatever is left "no"
   in the ungray array needs to be disabled.
*/
do item = 1 to {&NUM_GRAY_ITEMS}:
   if Gray_Items[item] <> ? then
      Gray_Items[item]:sensitive = ungray[item].
end.




