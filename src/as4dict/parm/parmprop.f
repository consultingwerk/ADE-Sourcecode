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

File: parmprop.f

Description:   
   This file contains the form for adding and editing the parameter properties.
   It has the full set of properties.  Some properties may be relevant on display
   but not on add.  In these cases, the form will be customized at run time by
   making the offending component(s) invisible.

Arguments:
   &frame_phrase - this should be a frame phrase for the frame that we want
                   to associate this form with. e.g., "frame foo OVERLAY".
 
Author: Donna McMann

Date Created: 05/04/99  
    
----------------------------------------------------------------------------*/

&SCOPED-DEFINE TFM_WID 0.05
&SCOPED-DEFINE VM_WIDG 0.13

form
   SKIP({&TFM_WID})
   b_parm._Field-Name 	label "Parameter &Name"     colon 20 {&STDPH_FILL} SPACE(.3)
   s_btn_Parm_Copy                               
   SKIP({&VM_WID})     
 
   s_Parm_DType          label "Data T&ype"      colon 20 {&STDPH_FILL} 
   s_btn_Parm_DType      SPACE (8) 
   SKIP({&VM_WID}) 
                                                                 
   s_Optional           no-label                at    2 
   SKIP(.2) 

   b_parm._Format      label "&Format"         colon 20 {&STDPH_FILL} 
                        format "x(48)"                   SPACE(.3)
   s_btn_Parm_Format 
   b_parm._Fld-Misc1[5]    label "Length"  colon 20      {&STDPH_FILL}
            FORMAT ">>,>>9"                 SPACE({&HM_WIDG})                     
  
   b_parm._Decimals   label "Decimals"       colon 74  {&STDPH_FILL}
            FORMAT ">>,>>>"                 SPACE ({&HM_WIDG})                     
   SKIP({&VM_WID}) 

   SKIP(.2) 

   b_parm._Initial     label "&Initial Value"  colon 20 {&STDPH_FILL}
                        format "x(43)"  
    s_Parm_type       label "Type" VIEW-AS RADIO-SET 
         RADIO-BUTTONS "Input", "Input", "Output", "Output", "Input-Output", "Input-Output" 
                                                 
    SKIP({&VM_WID})     
   
   b_parm._Order	label "&Parameter Position"        colon 20 {&STDPH_FILL}
                        format ">>>>9"                    
                 
   SKIP({&VM_WID})                    

   b_parm._Desc label "&Description" colon 20 {&STDPH_FILL}       
                        format "x(50)"
                        view-as fill-in size 65 by 1
                                                
   SKIP({&VM_WID})

   
  
   SKIP({&VM_WIDG})

   s_Status             NO-LABEL format "x(50)" at    2
                        view-as TEXT 

   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = yes
      &OK     = s_btn_OK
      &CANCEL = {&apply_btn}
      &OTHER  = "{&other_btns}"
      &HELP   = s_btn_Help}   

   /* Will be repositioned at run time */   
   s_lst_Parm_DType      NO-LABEL                at col 1 row 1

   with {&frame_phrase} SIDE-LABELS SCROLLABLE.






