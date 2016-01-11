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

File: fldprop.f

Description:   
   This file contains the form for adding and editing the main field and
   domain properties.  It has the full set of properties.  Some properties
   may be relevant on display but not on add, for fields but not for
   domains.  In these cases, the form will be customized at run time by
   making the offending component(s) invisible.

Arguments:
   &frame_phrase - this should be a frame phrase for the frame that we want
                   to associate this form with. e.g., "frame foo OVERLAY".
 
Author: Laura Stern

Date Created: 02/04/92 
    Modified: 04/01/98 Added display of _field-rpos

----------------------------------------------------------------------------*/

&SCOPED-DEFINE TFM_WID 0.05
&SCOPED-DEFINE VM_WIDG 0.33

form
   SKIP({&TFM_WID})
   b_Field._Field-Name 	label "Field &Name"     colon 18 {&STDPH_FILL} SPACE(.3)
   s_btn_Fld_Copy                               
   SKIP({&VM_WID})

   s_Fld_DType          label "Data T&ype"      colon 18 {&STDPH_FILL} 
   s_btn_Fld_DType   
   SKIP({&VM_WIDG})

   s_Optional           no-label                at    2 
   SKIP(.2) 

   b_Field._Format      label "&Format"         colon 18 {&STDPH_FILL} 
                        format "x(48)"                                 SPACE(.3)
   s_btn_Fld_Format 
   SKIP({&VM_WID}) 

   b_Field._Label 	label "La&bel"          colon 18 {&STDPH_FILL}
                        format "x(48)"
   SKIP({&VM_WID}) 
   
   b_Field._Col-label   label "Col&umn Label"   colon 18 {&STDPH_FILL}
                        format "x(48)"
   SKIP({&VM_WID}) 

   b_Field._Initial     label "&Initial Value"  colon 18 {&STDPH_FILL}
                        format "x(48)"
   SKIP({&VM_WID}) 
   
   b_Field._Order	label "&Order #"        colon 18 {&STDPH_FILL}
                        format ">>>>9"          SPACE({&HM_WIDG})
   /* R10 is so if we change label to "Bit offset" it will work */
   b_Field._Decimals    label "Decimal&s":R10            {&STDPH_FILL}
   b_Field._Field-rpos  label "Position" {&STDPH_FILL}
   SKIP({&VM_WID})

   b_Field._Desc        label "Descri&ption"    colon 18 {&STDPH_EDITOR}
                        view-as EDITOR SCROLLBAR-VERTICAL
                        SIZE 65 by 2
   SKIP({&VM_WID})

   b_Field._Help        label "He&lp Text"      colon 18 {&STDPH_FILL}
                        format "x(63)" 
                        view-as fill-in size 65 by 1
   SKIP(.2)

   b_Field._Mandatory   label "&Mandatory"      at    20
                        view-as TOGGLE-BOX      SPACE ({&HM_WIDG})
   b_Field._Fld-case    label "C&ase-Sensitive" 
                        view-as TOGGLE-BOX      SPACE ({&HM_WIDG})
   s_Fld_Array          label "E&xtent"        
                        view-as TOGGLE-BOX     
   b_Field._Extent	no-label                {&STDPH_FILL}
   SKIP({&VM_WIDG})

   s_btn_Fld_Triggers    	       	        at    2 SPACE({&HM_BTN})
   s_btn_Fld_Validation                                 SPACE({&HM_BTN})
   s_btn_Fld_ViewAs                                     SPACE({&HM_BTN})
   s_btn_Fld_StringAttrs                                SPACE({&HM_BTN})
   s_btn_Fld_Gateway                                     
   SKIP(.25)

   s_Status             NO-LABEL format "x(50)" at    2
                        view-as TEXT 

   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = yes
      &OK     = s_btn_OK
      &CANCEL = {&apply_btn}
      &OTHER  = "{&other_btns}"
      &HELP   = s_btn_Help}

   s_Fld_InIndex        no-label view-as TEXT   at col 60 row 1.35
   SKIP
   s_Fld_InView         no-label view-as TEXT   at     60 

   /* Will be repositioned at run time */   
   s_lst_Fld_DType      NO-LABEL                at col 1 row 1

   with {&frame_phrase} SIDE-LABELS SCROLLABLE.




