/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
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
    Modified: 01/14/98 D. McMann added graying out of create button when
                                 AS400 or ORACLE databases
              05/19/99 Mario B.  Adjust Width Field browser integration.   
              03/22/00 D. McMann Added support for MS SQL Server 7 (MSS)   
              09/18/02 D. McMann Added verify data report 		 
              07/19/05 kmcintos  Added Auditing Reports
              07/27/05 kmcintos  Added check for db connection before creating
                                 a buffer for _file 20050727-027.
----------------------------------------------------------------------------*/
CREATE WIDGET-POOL.

{adedict/dictvar.i shared}
{adedict/menu.i shared}
{adedict/brwvar.i shared}

Define INPUT PARAMETER p_Init as logical NO-UNDO.

/* Indicates which items need to be grayed (no) or ungrayed (yes). */
Define var ungray    as logical extent {&NUM_GRAY_ITEMS} NO-UNDO.
Define var read_only as logical                          NO-UNDO.

DEFINE VARIABLE lAuditing AS LOGICAL                     NO-UNDO.
DEFINE VARIABLE lSecurity AS LOGICAL                     NO-UNDO.

DEFINE VARIABLE hMenuItem AS HANDLE                      NO-UNDO.
DEFINE VARIABLE hBuffer   AS HANDLE                      NO-UNDO.

&Global-define    DETAILEDTBL      1 
&Global-define    QUICKTBL         2 
&Global-define    FLDRPT_CURRTBL   3
&Global-define    FLDRPT_ALLTBLS   4
&Global-define    IDXRPT_CURRTBL   5
&Global-define    IDXRPT_ALLTBLS   6
&Global-define    QUICKVIW   	 7
&Global-define    QUICKSEQ   	 8 
&Global-define    TRIG_RPT    	 9
&Global-define    QUICKUSR    	 10 
&Global-define    RELRPT_CURRTBL   11
&Global-define    RELRPT_ALLTBLS   12
&Global-define    EXIT	      	 13
&Global-define    DELETE           14
&Global-define    PROPERTIES	 15
&Global-define    CRT_DATABASE	 16
&Global-define    CRT_TABLE   	 17
&Global-define    CRT_SEQUENCE	 18
&Global-define    CRT_FIELD   	 19
&Global-define    CRT_INDEX   	 20
&Global-define    FIELD_RENAME	 21
&Global-define    FIELD_RENUMBER   22
&Global-define    SQL_WIDTH        23
&Global-define    SHOW_HIDDEN 	 24
&Global-define    ORDER_FIELDS	 25
&Global-define    BUTTON_CREATE    26
&Global-define    BUTTON_PROPS     27   
&Global-define    BUTTON_DELETE    28   
&Global-define    MODE_DATABASE    29
&Global-define    MODE_TABLE       30
&Global-define    MODE_SEQUENCE    31
&Global-define    MODE_FIELD       32
&Global-define    MODE_INDEX       33
&Global-define    DATA_RPT         34

Define var item   as integer  	    NO-UNDO. /* index into Gray_Items array */
Define var h_item as widget-handle  NO-UNDO. /* menu item handle value */


/*--------------------------- Mainline Code --------------------------------*/
if p_Init then
do:
   assign
      Gray_Items[{&DETAILEDTBL}]    = MENU-ITEM mi_DetailedTbl:HANDLE
      Gray_Items[{&QUICKTBL}]  	    = MENU-ITEM mi_QuickTbl:HANDLE
      Gray_Items[{&FLDRPT_CURRTBL}] = MENU-ITEM mi_f_CurrTbl:HANDLE
      Gray_Items[{&FLDRPT_ALLTBLS}] = MENU-ITEM mi_f_AllTbls:HANDLE
      Gray_Items[{&IDXRPT_CURRTBL}] = MENU-ITEM mi_i_CurrTbl:HANDLE
      Gray_Items[{&IDXRPT_ALLTBLS}] = MENU-ITEM mi_i_AllTbls:HANDLE
      Gray_Items[{&QUICKVIW}]       = MENU-ITEM mi_QuickViw:HANDLE
      Gray_Items[{&QUICKSEQ}]       = MENU-ITEM mi_QuickSeq:HANDLE
      Gray_Items[{&TRIG_RPT}] 	    = MENU-ITEM mi_Trigger:HANDLE
      Gray_Items[{&QUICKUSR}]       = MENU-ITEM mi_QuickUsr:HANDLE
      Gray_Items[{&RELRPT_CURRTBL}] = MENU-ITEM mi_r_CurrTbl:HANDLE
      Gray_Items[{&RELRPT_ALLTBLS}] = MENU-ITEM mi_r_AllTbls:HANDLE
      Gray_Items[{&DATA_RPT}]       = MENU-ITEM mi_Width:HANDLE
      Gray_Items[{&EXIT}]     	    = MENU-ITEM mi_Exit:HANDLE
      Gray_Items[{&DELETE}]   	    = MENU-ITEM mi_Delete:HANDLE
      Gray_Items[{&PROPERTIES}]     = MENU-ITEM mi_Properties:HANDLE
      Gray_Items[{&CRT_DATABASE}]   = MENU-ITEM mi_Crt_Database:HANDLE
      Gray_Items[{&CRT_TABLE}] 	    = MENU-ITEM mi_Crt_Table:HANDLE
      Gray_Items[{&CRT_SEQUENCE}]   = MENU-ITEM mi_Crt_Sequence:HANDLE
      Gray_Items[{&CRT_FIELD}] 	    = MENU-ITEM mi_Crt_Field:HANDLE
      Gray_Items[{&CRT_INDEX}] 	    = MENU-ITEM mi_Crt_Index:HANDLE
      Gray_Items[{&FIELD_RENAME}]   = MENU-ITEM mi_Field_Rename:HANDLE
      Gray_Items[{&FIELD_RENUMBER}] = MENU-ITEM mi_Field_Renumber:HANDLE
      Gray_Items[{&SQL_WIDTH}]      = MENU-ITEM mi_SQL_Width:HANDLE
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
      .

   /* Initialize these. */
   assign
      MENU-ITEM mi_Undo:sensitive = false
      MENU-ITEM mi_Commit:sensitive = false
      MENU-ITEM mi_Connect:sensitive = true
      MENU-ITEM mi_Disconnect:sensitive = true.

   return.
end.
/*-----------------------End of Init code-------------------------------*/

ungray = no.  /* init array to no's */
read_only = s_ReadOnly OR s_DB_ReadOnly.

/* For each progressive state determine which items should be enabled */
if s_DictState >= {&STATE_NO_DB_SELECTED} then
   assign
      ungray[{&EXIT}] = yes
      ungray[{&CRT_DATABASE}] = yes
      ungray[{&BUTTON_CREATE}] = yes
      ungray[{&MODE_DATABASE}] = yes.

if s_DictState >= {&STATE_NO_OBJ_SELECTED} then
do:
   assign
      ungray[{&DETAILEDTBL}] = yes
      ungray[{&QUICKTBL}] = yes
      ungray[{&FLDRPT_ALLTBLS}] = yes
      ungray[{&IDXRPT_ALLTBLS}] = yes
      ungray[{&QUICKVIW}] = yes
      ungray[{&QUICKSEQ}] = yes
      ungray[{&QUICKUSR}] = yes
      ungray[{&TRIG_RPT}] = yes
      ungray[{&RELRPT_ALLTBLS}] = yes
     ungray[{&DATA_RPT}] = YES.

   if s_CurrObj = {&OBJ_DB} then
      assign
      	 ungray[{&PROPERTIES}] = yes
      	 ungray[{&BUTTON_PROPS}] = yes.
   ELSE if read_only then
      	 ungray[{&BUTTON_CREATE}] = no.      
      	 
   if NOT read_only then
      assign
	 ungray[{&CRT_TABLE}] = yes
	 ungray[{&MODE_TABLE}] = YES
	 ungray[{&CRT_SEQUENCE}] = yes
	 ungray[{&MODE_SEQUENCE}] = yes.
	
    /* IF foreign database do not let user create tables or sequences */	 
    if s_DbCache_Type[s_DbCache_ix] = "ORACLE" OR
       s_DbCache_Type[s_DbCache_ix] = "ODBC"   OR
       s_DbCache_Type[s_DbCache_ix] = "MSS"    OR
       s_DbCache_Type[s_DbCache_ix] = "AS400"  THEN
       ASSIGN ungray[{&CRT_TABLE}] = no
              ungray[{&CRT_SEQUENCE}] = no
              ungray[{&BUTTON_CREATE}] = no
              ungray[{&DATA_RPT}] = NO.
end.

if s_DictState = {&STATE_OBJ_SELECTED} then
do:
   if s_Lvl1Obj = {&OBJ_TBL} then
      assign
      	 ungray[{&SHOW_HIDDEN}] = yes.

   if ((s_CurrObj = {&OBJ_TBL} AND s_CurrTbl <> "") OR
       (s_CurrObj = {&OBJ_SEQ} AND s_CurrSeq <> "") OR
       (s_CurrObj = {&OBJ_FLD} AND s_CurrFld <> "") OR
       (s_CurrObj = {&OBJ_IDX} AND s_CurrIdx <> "")) then
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
      
      if s_DbCache_type[s_DbCache_ix] = "PROGRESS" THEN
         ungray[{&SQL_WIDTH}]      = yes.

      if NOT read_only then
      	 assign
	    ungray[{&CRT_FIELD}] = yes
	    ungray[{&CRT_INDEX}] = yes
      	    ungray[{&FIELD_RENAME}] = yes
	    ungray[{&FIELD_RENUMBER}] = yes
      	    ungray[{&MODE_FIELD}] = yes
      	    ungray[{&MODE_INDEX}] = yes.
      	    
      if s_DbCache_Type[s_DbCache_ix] = "ORACLE" OR
         s_DbCache_Type[s_DbCache_ix] = "ODBC"   OR
         s_DbCache_Type[s_DbCache_ix] = "MSS"   OR
         s_DbCache_Type[s_DbCache_ix] = "AS400"  THEN
        ASSIGN ungray[{&CRT_FIELD}] = no
               ungray[{&BUTTON_CREATE}] = no.

      IF s_DbCache_Type[s_DbCache_ix] = "AS400" THEN        
        ASSIGN ungray[{&CRT_INDEX}] = no.       
        
      /* The following handles the graying of items when Adjust SQL Width    *
       * browse screen is open. 
      */
      IF s_win_Width <> ? THEN
        ASSIGN 
           ungray[{&BUTTON_CREATE}]  = IF s_CurrObj = {&OBJ_TBL} OR 
                                          s_CurrObj = {&OBJ_FLD} THEN 
                                             NO ELSE YES
           ungray[{&BUTTON_PROPS}]   = IF s_CurrObj = {&OBJ_FLD} THEN 
                                             NO ELSE YES

           ungray[{&CRT_TABLE}]      = NO
           ungray[{&DELETE}]         = IF s_CurrObj = {&OBJ_FLD} THEN
	                                     NO ELSE YES
           ungray[{&PROPERTIES}]     = IF s_CurrObj = {&OBJ_FLD} THEN
	                                     NO ELSE YES
           ungray[{&CRT_FIELD}]      = NO
           ungray[{&FIELD_RENAME}]   = NO
           ungray[{&FIELD_RENUMBER}] = NO.

   end.

   if (s_Lvl1Obj = {&OBJ_SEQ} AND s_CurrTbl <> "") OR s_win_Tbl <> ? THEN
      IF s_win_Width <> ? THEN
         ASSIGN
            ungray[{&CRT_TABLE}] = NO.          
         
   if (s_Lvl2Obj = {&OBJ_FLD} AND s_CurrFld <> "") then
      assign
      	 ungray[{&ORDER_FIELDS}] = yes.
    if s_CurrObj = {&OBJ_IDX} AND NOT read_only AND
       (s_DbCache_Type[s_DbCache_ix] = "ORACLE" OR
	    s_DbCache_Type[s_DbCache_ix] = "ODBC" OR
        s_DbCache_Type[s_DbCache_ix] = "MSS" ) THEN
      ASSIGN ungray[{&BUTTON_CREATE}] = yes.

     IF s_CurrObj = {&OBJ_IDX} AND
        s_DbCache_Type[s_DbCache_ix] = "AS400" THEN
           ASSIGN ungray[{&CRT_INDEX}] = no
                  ungray[{&BUTTON_CREATE}] = no.
                            
                  
     IF s_win_Width <> ? AND s_CurrObj = {&OBJ_FLD} THEN
        ASSIGN
           ungray[{&BUTTON_DELETE}] = NO.      
           
     IF s_win_Width <> ? AND s_CurrObj = {&OBJ_IDX} THEN
        ASSIGN
           ungray[{&DELETE}] = yes
           ungray[{&PROPERTIES}] = yes.
                 

     IF s_win_FLD <> ? THEN
        ASSIGN
           ungray[{&SQL_WIDTH}] = NO.      
  
end.

/* Now enable all those we just set "yes" for.  Whatever is left "no"
   in the ungray array needs to be disabled.
*/
do item = 1 to {&NUM_GRAY_ITEMS}:
   if Gray_Items[item] <> ? then
      Gray_Items[item]:sensitive = ungray[item].     
end.

IF CONNECTED("DICTDB") THEN DO:
  CREATE BUFFER hBuffer FOR TABLE "DICTDB._file".
  hBuffer:FIND-FIRST("WHERE _tbl-type EQ ~'S~'" + 
                     " AND _file-name BEGINS ~'_aud-~'",NO-LOCK) NO-ERROR.
  lAuditing = hBuffer:AVAILABLE.
  hBuffer:FIND-FIRST("WHERE _tbl-type EQ ~'S~'" + 
                     " AND _file-name BEGINS ~'_sec-~'",NO-LOCK) NO-ERROR.
  lSecurity = hBuffer:AVAILABLE.

  DELETE OBJECT hBuffer.
END.

hMenuItem = SUB-MENU s_mnu_Aud_Rep:HANDLE:FIRST-CHILD.

DO WHILE VALID-HANDLE(hMenuItem):
  IF hMenuItem:NAME BEGINS "mi_ADRpt" THEN
    hMenuItem:SENSITIVE = lAuditing.
  ELSE IF hMenuItem:NAME BEGINS "mi_CSRpt" THEN
    hMenuItem:SENSITIVE = lSecurity.

  hMenuItem = hMenuItem:NEXT-SIBLING.
END.
