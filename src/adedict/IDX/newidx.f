/*********************************************************************
* Copyright (C) 2000,2014 by Progress Software Corporation. All      *
* rights reserved. Prior versions of this work may contain portions  *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: newidx.f

Description:   
   This file contains the form for adding an index.

Author: Laura Stern

Date Created: 04/22/92
    Modified: 03/26/98 DLM Added Area Support
----------------------------------------------------------------------------*/


form
   SKIP({&TFM_WID})
 
   b_Index._Index-Name 	label "Index &Name" colon 15 {&STDPH_FILL}
   SKIP({&VM_WID})
   s_idx_Local		    label "&Index Type"  colon 15
   s_Idx_Area           label "Area" colon 15 s_area_mttext no-label  
   SKIP({&VM_WID})
   b_Index._Desc        label "Descri&ption" colon 15
      	       	     	view-as EDITOR SCROLLBAR-VERTICAL
      	       	     	SIZE 65 BY 2                 {&STDPH_EDITOR}
   SKIP({&VM_WIDG})

   s_Idx_Primary     	label "Pri&mary"    colon 15 
      	       	     	view-as TOGGLE-BOX  SPACE({&HM_WIDG})
   b_Index._Active   	label "Ac&tive" 	    
      	       	     	view-as TOGGLE-BOX  SPACE({&HM_WIDG})
   b_Index._Unique 	label "Uni&que"      
      	       	     	view-as TOGGLE-BOX  SPACE({&HM_WIDG})
   s_Idx_Word           label "&Word Index"  
                        view-as TOGGLE-BOX  SPACE({&HM_WIDG})
   s_Idx_Abbrev         label "A&bbreviated"     
      	       	     	view-as TOGGLE-BOX  /*SPACE({&HM_WIDG})*/
   SKIP({&VM_WIDG})

   "Select field to add to index:":t33   	    at 2
                        view-as TEXT                               
   "New Index's Fields:":t25 		    at 57
                        view-as TEXT                               
   SKIP

   s_lst_IdxFldChoice 	NO-LABEL      	    at 2
                        view-as SELECTION-LIST SINGLE 
                        INNER-CHARS 30 INNER-LINES 12
                        SCROLLBAR-V SCROLLBAR-H        
   
   s_lst_IdxFlds     	NO-LABEL       	    at 57 
                        view-as SELECTION-LIST SINGLE 
                        INNER-CHARS 31 INNER-LINES 12     
                        SCROLLBAR-V SCROLLBAR-H       
   SKIP({&VM_WID})

   s_IdxFld_AscDesc	NO-LABEL            at 57
   SKIP(.1)

   s_Status             NO-LABEL            at 2
                        format "x(50)" view-as TEXT 

   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = yes
      &OK     = s_btn_OK
      &CANCEL = s_btn_Add /* where cancel button usually goes */
      &OTHER  = "SPACE({&HM_DBTN}) s_btn_Done"
      &HELP   = s_btn_Help}

   s_btn_IdxFldAdd   	      	       	     at col 39 row 9 SKIP({&VM_WID})
   s_btn_IdxFldRmv   	      	       	     at     39       SKIP({&VM_WIDG})
   s_btn_IdxFldDwn                           at     39       SKIP({&VM_WID})
   s_btn_IdxFldUp                            at     39

/*   s_lst_Idx_Area1      NO-LABEL                at col 1 row 1*/

   with frame newidx
      default-button s_btn_Add cancel-button s_btn_Done
      SIDE-LABELS SCROLLABLE THREE-D
      TITLE "Create Index" view-as DIALOG-BOX.




