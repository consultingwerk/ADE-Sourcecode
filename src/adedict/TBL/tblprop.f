/**********************************************************************
* Copyright (C) 2000-2010,2013 by Progress Software Corporation. All  *
* rights reserved.  Prior versions of this work may contain portions  *
* contributed by participants of Possenet.                            *
*                                                                     *
**********************************************************************/


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
              06/15/06 fernando Changed Dump-name to allow 32 characters

----------------------------------------------------------------------------*/
 
form    
                                                             SKIP({&TFM_WID})
   b_File._File-Name 	label "Table &Name"   colon {&col1}   
                        view-as fill-in size 42 by 1
                        {&STDPH_FILL}                        
   b_File._File-attributes[3]   label "&Partitioned"    colon {&col1} 
                        view-as toggle-box SKIP({&VM_WID})  
   b_File._File-attributes[1]   label "&Multi-tenant"   colon {&col1}   
                        view-as toggle-box            space(1.5)
   			
   b_File._File-attributes[2]   label "&Support Default Tenant"
                        view-as toggle-box                                                                      
			SKIP({&VM_WID})      			

   s_Tbl_Area           label "&Area" colon {&col1} s_btn_File_Area
    SKIP({&VM_WID})
 
  s_Optional           no-label at 2                        SKIP({&VM_WIDG})
      
  b_File._Dump-Name 	label "Dump &File"    colon {&col1} 
                        view-as fill-in size 42 by 1  format "X(32)"
                        {&STDPH_FILL}                        SPACE(5)      

   s_Tbl_Type           label "Table Type"   colon {&col1}
                        {&STDPH_FILL}
                        view-as fill-in size 20 by 1         SPACE(2)
                        
   b_File._Hidden       label "H&idden"
      	       	     	view-as TOGGLE-BOX                   SPACE(3)
      	       	     	
   b_File._Frozen    	label "Fr&ozen"          
                        view-as TOGGLE-BOX                   SKIP({&VM_WID})


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





