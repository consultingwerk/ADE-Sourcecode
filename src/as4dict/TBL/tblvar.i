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

File: tblvar.i

Description:   
   Include file which defines the user interface components and related data
   for the main table editor window.
 
Arguments:
   {1} - this is either "new shared" or "shared".

Author: Laura Stern

Date Created: 03/06/92
    Modified: 01/02/95 DLM Changed to work with PROGRESS/400 Data Dictionary
              05/08/96 DLM Changed = MS-WINDOWS to BEGINS MS-WIN 
----------------------------------------------------------------------------*/

Define {1} buffer   b_File          for  as4dict.p__file.

Define {1} frame newtbl.    /* for create table dialog box */
Define {1} frame tblprops.  /* table properties */

/* The main table properties - mostly we user the record buffer. */
Define {1} var s_Tbl_Type     as char        	      	NO-UNDO. 
Define {1} var s_AS400_File_name as char NO-UNDO.
Define {1} var s_AS400_Lib_name as char NO-UNDO.
Define {1} var s_File_Hidden as logical NO-UNDO.  
Define {1} var s_File_Frozen as logical NO-UNDO.  
Define {1} var s_Tbl_IdxCnt   as integer format ">>>9"  NO-UNDO.

Define button s_btn_Tbl_Triggers    label "&Triggers..."     SIZE 17 by 1.
Define button s_btn_Tbl_Validation  label "&Validation..."   SIZE 17 by 1.
Define button s_btn_Tbl_StringAttrs label "St&ring Attrs..." SIZE 17 by 1.

/* These are the forms for the table properties and new table windows. */
&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
   {as4dict/TBL/tblprop.f  
      &frame_phrase = "frame tblprops NO-BOX 
		       default-button s_btn_OK cancel-button s_btn_Close"
      &apply_btn  = s_btn_Save
      &other_btns = "SPACE({&HM_DBTN}) s_btn_Close SPACE({&HM_DBTNG}) 
		     s_btn_Prev SPACE({&HM_DBTN}) s_btn_Next"
      &col1 = 18
      &col2 = 20
      &colbtn = 10
   }
&ELSE /* motif */
   {as4dict/TBL/tblprop.f  
      &frame_phrase = "frame tblprops NO-BOX 
		       default-button s_btn_OK cancel-button s_btn_Close"
      &apply_btn  = s_btn_Save
      &other_btns = "SPACE({&HM_DBTN}) s_btn_Close SPACE({&HM_DBTNG}) 
		     s_btn_Prev SPACE({&HM_DBTN}) s_btn_Next"
      &col1 = 20
      &col2 = 22
      &colbtn = 12
   }
&ENDIF

{as4dict/TBL/tblprop.f  
   &frame_phrase = "frame newtbl view-as DIALOG-BOX TITLE ""Create Table"" 
      	       	   default-button s_btn_OK cancel-button s_btn_Done"
   &apply_btn  = s_btn_Add
   &other_btns = "SPACE({&HM_DBTN}) s_btn_Done"
   &col1 = 18
   &col2 = 20
   &colbtn = 4
}

/* Symbolic constants */

/* for file number (_File-Number) values. */
&global-define 	  TBLNUM_FASTTRK_START 	  -29
&global-define 	  TBLNUM_FASTTRK_END   	  -7




