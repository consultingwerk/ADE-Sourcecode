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
File: menu.i

Description:
   This include file contains the definition of the dictionary menu.
 
Arguments:
   {1} - this is either "new shared" or "shared".

Author: Laura Stern

Date Created: 02/17/92 
     Modified    12/95 D. McMann to work with PROGRESS/400 Data Dictionary
     Modified 10/25/96 D. McMann Added Freeze/Unfreeze to menu.
     Modified 06/05/97 D. McMann Added Incremental Dump
              03/30/99 D. McMann Added stored procedure support
              12/07/00 D. McMann Added Enchanced AS/400 Incremental DF.
     
----------------------------------------------------------------------------*/

{adecomm/toolmenu.i &EXCLUDE_DICT = yes}


Define sub-menu s_mnu_QuickFld
   menu-item mi_f_CurrTbl   	 label "&Selected Table"
   menu-item mi_f_AllTbls        label "&All Tables".

Define sub-menu s_mnu_QuickIdx
   menu-item mi_i_CurrTbl   	 label "&Selected Table"
   menu-item mi_i_AllTbls        label "&All Tables".

Define sub-menu s_mnu_TblRel
   menu-item mi_r_CurrTbl   	 label "&Selected Table"
   menu-item mi_r_AllTbls        label "&All Tables".

Define sub-menu s_mnu_Reports	
   menu-item mi_DetailedTbl   	 label "&Detailed Table"
   menu-item mi_QuickTbl         label "Quick &Table"
   sub-menu s_mnu_QuickFld       label "Quick &Field"
   sub-menu s_mnu_QuickIdx       label "Quick &Index"
   menu-item mi_DetailedPrc      label "Detailed &Procedure"
   menu-item mi_QuickSeq         label "&Sequence"
   menu-item mi_Trigger	   label "Tri&gger"
   menu-item mi_QuickUsr         label "&User"  
   sub-menu  s_mnu_TblRel        label "Table &Relations".                 
 
   
Define sub-menu s_mnu_Database
   sub-menu  s_mnu_Reports	 label "&Reports"    
   menu-item mi_Exit		 label "E&xit".               
   
   
Define sub-menu mnu_Dump
   menu-item mi_Dump_Defs     label "&Data Definitions (.df file)..."
   menu-item mi_Dump_Contents label "&Table Contents (.d file)..."
   menu-item mi_Dump_SeqDefs  label "&Sequences Definitions..."
   menu-item mi_Dump_SeqVals  label "Se&quences Current Values..."
   RULE
   menu-item mi_Dump_Inc      label "Create Progress Incremental .df..."
   MENU-ITEM mi_Ench_Inc      LABEL "Create DB2/400 Incremental .df..."
   .

Define sub-menu mnu_Load
   menu-item mi_Load_Defs     label "&Data Definitions (.df file)..."
   menu-item mi_Load_Contents label "&Table Contents (.d file)..."
   menu-item mi_Load_SeqVals  label "&Sequences Current Values..."
   menu-item mi_Load_BadRecs  label "&Reconstruct Bad Load Records..."
   menu-item mi_Load_Inc     label  "D&B2/400 Incremental (.df file)..."
   .

Define sub-menu mnu_Admin
   sub-menu  mnu_Dump 	      label "&Dump Data and Definitions"
   sub-menu  mnu_Load 	      label "&Load Data and Definitions"   
   menu-item mi_Sync          label "&Synchronize PROGRESS/400 Client"
   menu-item mi_Frozen       label "&Freeze/Unfreeze" 
   .
      
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
   menu-item mi_Crt_Field      label "&Field..."    ACCELERATOR "CTRL-F"
   menu-item mi_Crt_Index      label "&Index..."    ACCELERATOR "CTRL-X"
   menu-item mi_Crt_Proc       label "&Procedure.." ACCELERATOR "CTRL-P"
   menu-item mi_Crt_Parm       label "P&arameters.." ACCELERATOR "CTRL-A".

Define sub-menu s_mnu_Options
   menu-item mi_Field_Rename   	 label "&Globally Rename Fields..."
   RULE
   menu-item mi_Mode_Db 	 label "&Database Mode" ACCELERATOR "SHIFT-F6"
   menu-item mi_Mode_Tbl 	 label "&Table Mode"    ACCELERATOR "SHIFT-F7"
   menu-item mi_Mode_Seq	 label "&Sequence Mode" ACCELERATOR "SHIFT-F8"
   menu-item mi_Mode_Fld	 label "&Field Mode"    ACCELERATOR "SHIFT-F9"
   menu-item mi_Mode_Idx	 label "&Index Mode"    ACCELERATOR "SHIFT-F10"
   menu-item mi_Mode_Proc	 label "&Procedure Mode" ACCELERATOR "SHIFT-F11"
   menu-item mi_Mode_Parm	 label "P&arameter Mode"    ACCELERATOR "SHIFT-F12".

Define sub-menu s_mnu_View
   menu-item mi_Order_Fields  	 label "&Order Fields Alphabetically"
   menu-item mi_Show_Hidden   	 label "&Show Hidden Tables" TOGGLE-BOX.

Define sub-menu s_mnu_Help SUB-MENU-HELP
   menu-item mi_Contents         label "&Help Topics"
   RULE
   menu-item mi_messages         label "M&essages..."
   menu-item mi_recent           label "&Recent Messages..."
   RULE
   menu-item mi_About            label "&About Dictionary".

Define {1} menu s_mnu_Dict
   MENUBAR
   sub-menu s_mnu_Database	 label "&Database"   
   sub-menu mnu_Admin          label "&Admin"
   sub-menu s_mnu_Edit		 label "&Edit"
   sub-menu s_mnu_Create       label "&Create"
   sub-menu s_mnu_View	      	 label "&View"
   sub-menu s_mnu_Options	 label "&Options"
   sub-menu mnu_Tools          label "&Tools"
   sub-menu s_mnu_Help	      	 label "&Help".





