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

File: idxprop.f

Description:   
   This file contains the form for showing index properties.

Author: Laura Stern

Date Created: 04/29/92
     Modified: DLM To work with the PROGRESS/400 Data Dictionary
               DLM 05/08/96 Change = MS-WINDOWS to BEGINS MS-WIN
               DLM 12/02/96 changed spacing for as400 name because
                            82 changed font          
               DLM 06/24/97 Added word index support             

----------------------------------------------------------------------------*/

&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
   &global-define  lbl_col  /* 4.5 */ 5.0
   &global-define  lst_col  4.0
&ELSE
   &global-define  lbl_col  7.5
   &global-define  lst_col  7.0
&ENDIF

form
   SKIP({&TFM_WID})

   b_Index._Index-Name label "Index &Name"     colon 16  {&STDPH_FILL}
   SKIP({&VM_WID})   
   b_Index._AS4-File label "AS/400 Name"  FORMAT "x(10)" colon 16 FONT 0
      {&STDPH_FILL} 
   b_Index._AS4-Library label "Library Name" FORMAT "x(10)" FONT 0 {&STDPH_FILL}   
      SKIP({&VM_WID}) 
   b_Index._Desc       label "&Description"    colon 16   
            FORMAT "x(50)" {&STDPH_FILL}
   SKIP({&VM_WIDG})
                    
   s_Idx_Primary     	label "&Primary"       at  10
      	       	     	view-as TOGGLE-BOX     SPACE({&HM_WIDG})
   ActRec       	label "A&ctive"         
      	       	     	view-as TOGGLE-BOX     SPACE({&HM_WIDG})
   s_Idx_Unique 	label "Uni&que"         
      	       	     	view-as TOGGLE-BOX     SPACE({&HM_WIDG}) 
                         	       	     	
   s_Idx_Abbrev         label "A&bbreviated"     
      	       	     	view-as TOGGLE-BOX   SKIP({&VM_WIDG})
   s_Idx_Word           label "&Word Index   Word Size" at 20 
                        view-as TOGGLE-BOX  
   word_size          no-label  SKIP({&VM_WIDG})    	       	     	

   s_txt_List_Labels[1] no-label     at  2 FONT 0 /* fixed */
                        view-as TEXT format "x(52)"
   SKIP
   s_txt_List_Labels[2] no-label     at 2 FONT 0
                        view-as TEXT format "x(52)"
   SKIP({&VM_WID})

   s_lst_IdxFlds       NO-LABEL      FONT 0 
                       view-as SELECTION-LIST SINGLE 
                       INNER-CHARS 50 INNER-LINES 7     
                       SCROLLBAR-V             
   SKIP (.25) 

   s_Status            NO-LABEL format "x(50)" at  2
                       view-as TEXT 

   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = yes
      &OK     = s_btn_OK
      &CANCEL = s_btn_Save
      &OTHER  = "SPACE({&HM_DBTN}) s_btn_Close 
                 SPACE({&HM_DBTNG}) s_btn_Prev SPACE({&HM_DBTN}) s_btn_Next"
      &HELP   = s_btn_Help}

   with frame idxprops
      default-button s_btn_OK cancel-button s_btn_Close
      SIDE-LABELS NO-BOX.

