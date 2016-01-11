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

File: tblprop.f

Description:   
   This file contains the form for adding and editing table properties (not
   including triggers and validation info).  All information is in the form.
   Some will be grayed or made invisible if it is not relevant (e.g., for
   gateway vs. Progress tables).

Arguments:
   &frame_phrase - this should be a frame phrase for the frame that we want
                   to associate this form with. e.g., "frame foo OVERLAY".
   &apply_btn    - The apply button (e.g., Save or Create)
   &other_btns   - phrase for layout of other default buttons
   &col1         - column for lining up the colons
   &col2         - column for other stuff
   &colbtn       - column for sub-dialog buttons.

Author: Laura Stern

Date Created: 03/05/92

----------------------------------------------------------------------------*/

form
                                                             SKIP({&TFM_WID})
   b_File._File-Name 	label "Table &Name"  colon {&col2}   
             {&STDPH_FILL}                        SKIP({&VM_WIDG})
   
   s_AS400_File_name                         colon {&col2}   
                        format "x(10)"   {&STDPH_FILL}       SPACE({&HM_WIDG})
   s_AS400_Lib_Name     label "Library Name"    
                        format "x(10)"   {&STDPH_FILL}       SKIP({&VM_WIDG})
                   
   s_Optional           no-label              at     2       SKIP({&VM_WIDG})
   
   b_File._Dump-Name 	label "Dump &File"    colon {&col1}   
                        {&STDPH_FILL}                        SKIP({&VM_WID})
   s_Tbl_Type    	label "Table T&ype"   colon {&col1}
                        format "x(21)"                       SKIP({&VM_WID})
   b_File._File-label   label "&Label"        colon {&col1} 
                        {&STDPH_FILL}
                        view-as fill-in size 38 by 1         SKIP({&VM_WID})

   b_File._Desc	     	label "&Description" FORMAT "x(50)" colon {&col1}
           {&STDPH_FILL}   SKIP({&VM_WID})

   s_File_Hidden        label "Hidd&en"       at    {&col2}
      	       	     	view-as TOGGLE-BOX                   SPACE({&HM_WIDG})
   s_File_Frozen    	label "Frozen"                                              
                        view-as TOGGLE-BOX                   SKIP({&VM_WID})


   b_File._For-Size  	label "Record Si&ze"  FORMAT ">>>>>>>9" colon {&col1}   
                        {&STDPH_FILL}                        SPACE({&HM_WIDG})
   s_Tbl_IdxCnt         label "Total Indexes" at row-of b_File._For-Size
                                                 col-of s_File_Frozen
                                                             SKIP({&VM_WID}) 
   b_File._For-Format  	label "Record Format"       colon {&col1}    
            format "x(10)"       {&STDPH_FILL}                        SKIP(.25)
  
   s_btn_Tbl_Triggers                         at  {&colbtn}  SPACE({&HM_BTN})
   s_btn_Tbl_Validation                                      SPACE({&HM_BTN})
   s_btn_Tbl_StringAttrs                                     SKIP(.25)
   
   s_Status             no-label format "x(50)" at     2
                        view-as TEXT 

   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = yes
      &OK     = s_btn_OK
      &CANCEL = {&apply_btn}
      &OTHER  = "{&other_btns}"
      &HELP   = s_btn_Help}

   with {&frame_phrase} SIDE-LABELS.





