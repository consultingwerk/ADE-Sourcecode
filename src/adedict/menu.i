/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------
File: menu.i

Description:
   This include file contains the definition of the dictionary menu.
 
Arguments:
   {1} - this is either "new shared" or "shared".

Author: Laura Stern

Date Created: 02/17/92 
    Modified: 01/05/98 Added Storage Area Report for V9
              05/19/99 Mario B.  Adjust Width Field browser integration.   
              09/18/02 D. McMann Added verify data report  
              10/01/02 D. McMann Change menu name for Adjust Schema
              07/19/05 kmcintos  Added Auditing Reports
----------------------------------------------------------------------------*/

{adecomm/toolmenu.i &EXCLUDE_DICT = yes}


Define sub-menu s_mnu_QuickFld
   menu-item mi_f_CurrTbl   label "&Selected Table"
   menu-item mi_f_AllTbls   label "&All Tables".

Define sub-menu s_mnu_QuickIdx
   menu-item mi_i_CurrTbl   label "&Selected Table"
   menu-item mi_i_AllTbls   label "&All Tables".

Define sub-menu s_mnu_TblRel
   menu-item mi_r_CurrTbl   label "&Selected Table"
   menu-item mi_r_AllTbls   label "&All Tables".

DEFINE SUB-MENU s_mnu_Aud_Rep
   MENU-ITEM mi_ADRpt_AudPol    LABEL "Track Audit &Policy Changes"
   MENU-ITEM mi_ADRpt_DbSchma   LABEL "Track Database &Schema Changes"
   MENU-ITEM mi_ADRpt_AudAdmn   LABEL "Track &Audit Data Administration (Dump/Load)"
   MENU-ITEM mi_ADRpt_TblAdmn   LABEL "Track Application &Data Administration (Dump/Load)"
   RULE
   MENU-ITEM mi_ADRpt_UsrAct    LABEL "Track &User Account Changes"
   MENU-ITEM mi_ADRpt_SecPerm   LABEL "Track Security Per&missions Changes"
   MENU-ITEM mi_ADRpt_Dba       LABEL "Track SQL Permissions Changes"
   MENU-ITEM mi_ADRpt_AuthSys   LABEL "Track Authe&ntication System Changes"
   RULE
   MENU-ITEM mi_CSRpt_CltSess   LABEL "&Client Session Authentication Report"
   MENU-ITEM mi_ADRpt_DbAdmin   LABEL "Database Administ&ration Report (Utilities)"
   MENU-ITEM mi_ADRpt_AppLogin  LABEL "Database Access Report (Lo&gin/Logout/etc...)"
   RULE
   MENU-ITEM mi_ADRpt_Cust      LABEL "Custom Audit Data &Filter Report".

Define sub-menu s_mnu_Reports	
   menu-item mi_DetailedTbl   	 label "&Detailed Table..."
   menu-item mi_QuickTbl         label "Quick &Table"
   sub-menu s_mnu_QuickFld       label "Quick &Field"
   sub-menu s_mnu_QuickIdx       label "Quick &Index"
   menu-item mi_QuickViw         label "PRO/SQL &View"
   menu-item mi_QuickSeq      	 label "&Sequence"
   menu-item mi_Trigger	      	 label "Tri&gger"
   menu-item mi_QuickUsr         label "&User"
   sub-menu  s_mnu_TblRel        label "Table &Relations"
   menu-item mi_QuickArea        label "Storage &Areas"
   MENU-ITEM mi_Width            label "Verify Data &Width"
   RULE
   SUB-MENU  s_mnu_Aud_Rep       LABEL "Auditing R&eports".

Define sub-menu s_mnu_Database
   menu-item mi_Crt_Database	 label "&Create..."   ACCELERATOR "SHIFT-F3"
   menu-item mi_Connect		 label "Co&nnect..."  ACCELERATOR "F3"
   menu-item mi_Disconnect    	 label "&Disconnect"  ACCELERATOR "F8"
   sub-menu  s_mnu_Reports	 label "&Reports"
   menu-item mi_Exit		 label "E&xit".
      
Define sub-menu s_mnu_Edit	
   menu-item mi_Undo	      	 label "&Undo Transaction"  ACCELERATOR "CTRL-Z"
   menu-item mi_Commit	      	 label "&Commit Transaction" 
      	       	     	      	       	     	      	    ACCELERATOR "CTRL-Y"
   RULE	     
   menu-item mi_Delete      	 label "&Delete"            ACCELERATOR "CTRL-D"
   menu-item mi_Properties	 label "&Properties..."     ACCELERATOR "CTRL-P".
      
Define sub-menu s_mnu_Create      
   menu-item mi_Crt_Table	 label "&Table..."    ACCELERATOR "CTRL-T"
   menu-item mi_Crt_Sequence	 label "&Sequence..." ACCELERATOR "CTRL-S"
   menu-item mi_Crt_Field     	 label "&Field..."    ACCELERATOR "CTRL-F"
   menu-item mi_Crt_Index     	 label "&Index..."    ACCELERATOR "CTRL-X".
/*
Define sub-menu s_mnu_SQL_Props    
   menu-item mi_SQL_Width          label "Adjust Field Width".
*/   
Define sub-menu s_mnu_Options
   menu-item mi_Field_Rename   	 label "&Globally Rename Fields..."
   menu-item mi_Field_Renumber 	 label "&Renumber Fields in Table..."
   menu-item mi_SQL_Width        label "Adjust Field Width".  
   RULE
   menu-item mi_Mode_Db 	 label "&Database Mode" ACCELERATOR "SHIFT-F6"
   menu-item mi_Mode_Tbl 	 label "&Table Mode"    ACCELERATOR "SHIFT-F7"
   menu-item mi_Mode_Seq	 label "&Sequence Mode" ACCELERATOR "SHIFT-F8"
   menu-item mi_Mode_Fld	 label "&Field Mode"    ACCELERATOR "SHIFT-F9"
   menu-item mi_Mode_Idx	 label "&Index Mode"    ACCELERATOR "SHIFT-F10".

Define sub-menu s_mnu_View
   menu-item mi_Order_Fields  label "&Order Fields Alphabetically"
   menu-item mi_Show_Hidden   label "&Show Hidden Tables" TOGGLE-BOX.

Define sub-menu s_mnu_Help SUB-MENU-HELP
   MENU-ITEM mi_Master      LABEL "OpenEdge &Master Help"
   menu-item mi_Contents    label "Data Dictionary &Help Topics"
   RULE
   menu-item mi_messages    label "M&essages..."
   menu-item mi_recent      label "&Recent Messages..."
   RULE
   menu-item mi_About       label "&About Dictionary".

Define {1} menu s_mnu_Dict
   MENUBAR
   sub-menu s_mnu_Database	 label "&Database"
   sub-menu s_mnu_Edit		 label "&Edit"
   sub-menu s_mnu_Create      	 label "&Create"
   sub-menu s_mnu_View	      	 label "&View"
   sub-menu s_mnu_Options	 label "&Options"
   sub-menu mnu_Tools            label "&Tools"
   sub-menu s_mnu_Help	      	 label "&Help".

