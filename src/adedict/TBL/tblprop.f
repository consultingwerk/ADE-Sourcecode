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
    Modified: 01/19/98 DLM Added variable s_tbl_area for either the 
                           _ianum or N/A for dataserver tables 
              03/26/98 DLM Changed display of area number to area name

----------------------------------------------------------------------------*/

form
                                                             SKIP({&TFM_WID})
   b_File._File-Name 	label "Table &Name"   colon {&col1}   
                        view-as fill-in size 42 by 1
                        {&STDPH_FILL}                        SKIP({&VM_WID}) 

   s_Tbl_Area           label "&Area" colon {&col1} s_btn_File_Area
    SKIP({&VM_WID})
 
  s_Optional           no-label at 2                        SKIP({&VM_WIDG})
      
  b_File._Dump-Name 	label "Dump &File"    colon {&col1}   
                        {&STDPH_FILL}                        SPACE(5)      

   b_File._Hidden       label "H&idden"
      	       	     	view-as TOGGLE-BOX                   SPACE(3)
      	       	     	
   b_File._Frozen    	label "Fr&ozen"          
                        view-as TOGGLE-BOX                   SKIP({&VM_WID})

    s_Tbl_Type           label "Table Type"   colon {&col1}
                        {&STDPH_FILL}
                        view-as fill-in size 20 by 1         SKIP({&VM_WID})

   b_File._File-label   label "&Label"        colon {&col1} 
                        {&STDPH_FILL}
                        view-as fill-in size 42 by 1         SKIP({&VM_WID})

   b_File._Desc	     	label "Descri&ption"  colon {&col1}
                        view-as EDITOR SCROLLBAR-VERTICAL
                        size 42 BY 4 {&STDPH_EDITOR}         SKIP({&VM_WID})

   b_File._Fil-misc2[6] label "R&eplication" format "x(50)"
                        view-as fill-in size 42 by 1
                        {&STDPH_FILL}        colon {&col1}
                                                             SKIP({&VM_WID})

   b_File._Fil-misc2[8] label "DB Link"      colon {&col1}  
                        view-as fill-in size 14 by 1         SPACE(2.5)

   b_File._For-Size     label "Record Size"                
                        {&STDPH_FILL}
                                                            SKIP({&VM_WID})
                                                             
   b_File._For-Name     label "DataServer Name" colon {&col1}  
                        view-as fill-in size 42 by 1
                        {&STDPH_FILL}                        SKIP({&VM_WID})
                        
   b_File._For-Owner    label "Owner"            colon {&col1}       
                        view-as fill-in size 42 by 1
                        {&STDPH_FILL}                        SKIP({&VM_WIDG})

   s_btn_Tbl_Triggers                         at  {&colbtn}  SPACE({&HM_BTN})
   s_btn_Tbl_Validation                                      SPACE({&HM_BTN})
   s_btn_Tbl_StringAttrs             
   {&ds_btn}                                                 SKIP(.25)
   
    s_Status             no-label format "x(50)" at     2
                        view-as TEXT 

   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = yes
      &OK     = s_btn_OK
      &CANCEL = "{&apply_btn} "
      &OTHER  = "{&other_btns} "
      &HELP   = "s_btn_Help"
      }

    s_lst_File_Area      NO-LABEL                at col 1 row 1
   
   with {&frame_phrase} SIDE-LABELS.





