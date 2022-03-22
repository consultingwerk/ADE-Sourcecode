/**********************************************************************
* Copyright (C) 2000-2010 by Progress Software Corporation. All rights*
* reserved.  Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                            *
*                                                                     *
**********************************************************************/

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
   &prop         - only defined for sequence properties
 
Author: Laura Stern

Date Created: 02/20/92 
    Modified: 05/25/06 fernando   Support for large sequences

----------------------------------------------------------------------------*/
form
   SKIP({&TFM_WID})

   b_Sequence._Seq-Name	   label "Sequence &Name"   colon {&col1} {&STDPH_FILL}
   SKIP({&VM_WID})
   b_Sequence._Seq-Attributes[1]    label "&Multi-tenant" at    {&col2}
                           view-as toggle-box     
   SKIP({&VM_WID})                              
   b_Sequence._Seq-Init	   label "Initial &Value"   format "->,>>>,>>>,>>>,>>>,>>>,>>9"
                                                    colon {&col1} {&STDPH_FILL}
   SKIP({&VM_WID})

   b_Sequence._Seq-Incr    label "&Increment by"    format "->,>>>,>>>,>>>,>>>,>>>,>>9"
                                                    colon {&col1} {&STDPH_FILL}
   SKIP({&VM_WID})

   s_Seq_Limit 	     	   label "&Upper Limit"	    format "->,>>>,>>>,>>>,>>>,>>>,>>9"
                                                    colon {&col1} {&STDPH_FILL}
   SKIP({&VM_WID})

   b_Sequence._Cycle-Ok    label "C&ycle at Limit?" at    {&col2}
      	       	     	   view-as toggle-box                
   SKIP({&VM_WID})
   
&if defined(prop) &then
    s_Seq_Current_Value    label "Current Value" format "X(30)" colon {&col1} {&STDPH_FILL}
    SKIP(0.1)
&endif

   b_Sequence._Seq-misc[1] label "&DataServer Name" colon {&col1} {&STDPH_FILL}
     format "x(32)"  SKIP({&VM_WID}) 

   b_Sequence._Seq-misc[2] label "&Owner"	    colon {&col1} {&STDPH_FILL}

   b_Sequence._Seq-misc[8]  label "DB &Link"        colon {&col1}  
                        format "x(21)"                       {&STDPH_FILL}

 &if defined(prop) &then
    b_Sequence._Seq-misc[6]  label "Data Type"  format "x(32)" colon {&col1} 
                        {&STDPH_FILL} SKIP({&VM_WID})
   b_Sequence._Seq-misc[7]  label "Cache Size" colon {&col1} {&STDPH_FILL} SKIP({&VM_WID})
   
   RECT-DS AT ROW 8.7 COL 2    
&endif

   s_Large_Seq_info        no-label format "X(40)" at 2 
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








