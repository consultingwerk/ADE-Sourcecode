/**********************************************************************
* Copyright (C) 2000,2006,2014 by Progress Software Corporation. All  *
* rights reserved. Prior versions of this work may contain portions   *
* contributed by participants of Possenet.                            *
*                                                                     *
**********************************************************************/

/*----------------------------------------------------------------------------

File: idxprop.f

Description:   
   This file contains the form for showing index properties.

Author: Laura Stern

Date Created: 04/29/92
     History: 03/26/98 D. McMann Added Area name 
              06/08/06 fernando   Support for large keys
----------------------------------------------------------------------------*/

&IF "{&WINDOW-SYSTEM}" begins "MS-WIN" &THEN
   &global-define  lbl_col  4.5
   &global-define  lst_col  4.0
&ELSE
   &global-define  lbl_col  7.5
   &global-define  lst_col  7.0
&ENDIF

/* Note: both the declarations for b_Index buffer and the browser on the
   temp-table query have been moved into the .f file to emphasize the
   importance that they all be declared NEW SHARED at the same time.  This
   was not always the case and it was the cause of a major bug.  (Any
   dictionary bug is a major bug.)     DRH 4/32/97                       */
Define {1} buffer b_Index for DICTDB._Index. 

define {1} browse b-idx-list query q-idx-list 
       display fld-nam column-label "Field Name" 
               fld-typ column-label "Field Type"
               asc-desc column-label "A(SC)/!D(esc)"
       with 7 down width 65.

form
   SKIP({&TFM_WID})

   b_Index._Index-Name label "Index &Name" colon 13  {&STDPH_FILL}
   SKIP({&VM_WID})
   s_Idx_Local	       label "&Index Type"  colon 13
   s_Idx_Area          label "Area" colon 13 
   s_area_mttext       no-label 
   SKIP({&VM_WID})
   b_Index._Desc       label "Descri&ption"    colon 13
                       view-as EDITOR SCROLLBAR-VERTICAL
      	       	       INNER-CHARS 62 INNER-LINES 2  {&STDPH_EDITOR}
   SKIP({&VM_WIDG})

   s_Idx_Primary     	label "Pri&mary"       colon  13
       	       	     	view-as TOGGLE-BOX     SPACE({&HM_WIDG})
   ActRec       	    label "Ac&tive"         
      	       	     	view-as TOGGLE-BOX     SPACE({&HM_WIDG})
   b_Index._Unique 	    label "Uni&que"         
      	       	     	view-as TOGGLE-BOX     SPACE({&HM_WIDG})
   s_Idx_Word           label "&Word Index"     
                        view-as TOGGLE-BOX     SPACE({&HM_WIDG})
   s_Idx_Abbrev         label "A&bbreviated"     
      	       	     	view-as TOGGLE-BOX     SPACE({&HM_WIDG})   
   SKIP({&VM_WIDG})
  
   b-idx-list           colon 13 
   
   SKIP(.25)
   s_msg NO-LABEL      format "x(50)" at  7 view-as TEXT 
   SKIP(.25)
   s_Status            NO-LABEL format "x(55)" at  2
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
      SIDE-LABELS SCROLLABLE NO-BOX.

