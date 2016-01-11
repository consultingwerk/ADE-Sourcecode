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

File: seqprop.f

Description:   
   This file contains the form for adding and editing sequences.

Arguments:
   &frame_phrase - this should be a frame phrase for the frame that we want
                   to associate this form with. e.g., "frame foo OVERLAY".
   &apply_btn    - The apply button (e.g., Save or Create)
   &other_btns   - phrase for layout of other default buttons
   &col1         - column for lining up the colons
   &col2         - column for other stuff
 
Author: Laura Stern

Date Created: 02/20/92 

----------------------------------------------------------------------------*/


form
   SKIP({&TFM_WID})

   b_Sequence._Seq-Name	   label "Sequence &Name"   colon {&col1} {&STDPH_FILL}
   SKIP({&VM_WID})

   b_Sequence._Seq-Init	   label "Initial &Value"   format "->,>>>,>>>,>>9"
                                                    colon {&col1} {&STDPH_FILL}
   SKIP({&VM_WID})

   b_Sequence._Seq-Incr    label "&Increment by"    format "->,>>>,>>>,>>9"
                                                    colon {&col1} {&STDPH_FILL}
   SKIP({&VM_WID})

   s_Seq_Limit 	     	   label "&Upper Limit"	    format "->,>>>,>>>,>>9"
                                                    colon {&col1} {&STDPH_FILL}
   SKIP({&VM_WID})

   b_Sequence._Cycle-Ok    label "C&ycle at Limit?" at    {&col2}
      	       	     	   view-as toggle-box                
   SKIP({&VM_WID})

   b_Sequence._Seq-misc[1] label "&DataServer Name" colon {&col1} {&STDPH_FILL}
   format "x(32)" SKIP({&VM_WID})

   b_Sequence._Seq-misc[2] label "&Owner"	    colon {&col1} {&STDPH_FILL}

   b_Sequence._Seq-misc[8]  label "DB &Link"        colon {&col1}  
                        format "x(21)"                       SKIP({&VM_WID})
   SKIP(.25)

   s_Status                NO-LABEL format "x(50)"  at    2 
                           view-as TEXT 

   {adecomm/okform.i
      &BOX    = s_rect_btns
      &STATUS = yes
      &OK     = s_btn_OK
      &CANCEL = {&apply_btn}
      &OTHER  = "{&other_btns}"
      &HELP   = s_btn_Help}

   with {&frame_phrase} SIDE-LABELS.








