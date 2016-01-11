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

/*--------------------------------------------------------------------

File: prodict/user/_usr_gsl.p

Description:
    
    User-Interface for _xxx_get.p-programs
    
    Asks user for selection-criterias for the objects to be displayed 
    and selectable in the followup-list
                
Input-Output Parameters:
    p_name       object-name for pre-selection of objects
    p_owner      owner-name for pre-selection of objects
    p_qual       qualifier for pre-selection of objects
    p_type       object-type for pre-selection of objects
    p_frame      name of the frame to use
    
called from:
    odb/_odb_get.p
    ora/_ora6get.p
    ora/_ora7get.p
    syb/syb_getp.i
    
History:
    hutegger    94/07/29    creation
    
--------------------------------------------------------------------*/        
/*h-*/

/*----------------------------  DEFINES  ---------------------------*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

{prodict/gate/gatework.i 
  &options    = "format ""x(30)"" "
  &SelVarType = "INPUT-OUTPUT PARAMETER p"
  }

define input        parameter p_frame    as   character.
define input        parameter p_link     as   character.
define input        parameter p_master   as   character.

define variable               canned     as   logical init yes.
define variable               l_link     as   character format "x(30)".
define variable               l_verify   as   logical.


form
                                                          skip({&VM_WIDG})
  l_link    label "Link-Path  "  format "x(30)" colon 14  skip({&VM_WIDG})
  p_name    label "Object &Name"                 colon 14  skip({&VM_WIDG})
  p_type    label "Object &Type"                 colon 14  skip({&VM_WIDG})
  p_owner   label "Object &Owner"                colon 14  skip({&VM_WIDG})
  p_vrfy    label "&Verify only objects that currently exist in the schema holder"
            view-as toggle-box
  {prodict/user/userbtns.i}
 with frame frm_link
  centered row 5 attr-space
  overlay side-labels
  view-as dialog-box default-button btn_ok cancel-button btn_cancel
  TITLE " Pre-Selection Criteria For Schema Pull ".
  
form
                                             skip({&VM_WIDG})
  p_name    label "Object &Name"   colon 14   skip({&VM_WIDG})
/*  p_type    label "Object &Type"  colon 14   skip({&VM_WIDG})*/
  p_owner   label "Object &Owner"  colon 14   skip({&VM_WIDG})
  p_qual    label "&Qualifier  "   colon 14   skip({&VM_WIDG})
  p_vrfy    label "&Verify only objects that currently exist in the schema holder"
            view-as toggle-box
  {prodict/user/userbtns.i}
 with frame frm_ntoq
  centered row 5 attr-space
  overlay side-labels
  view-as dialog-box default-button btn_ok cancel-button btn_cancel
  TITLE " Pre-Selection Criteria For Schema Pull ".
  
form
                                             skip({&VM_WIDG})
  p_name    label "Object &Name"   colon 14   skip({&VM_WIDG})
  p_type    label "Object &Type"   colon 14   skip({&VM_WIDG})
  p_owner   label "Object &Owner"  colon 14   skip({&VM_WIDG})
  p_vrfy    label "&Verify only objects that currently exist in the schema holder"
            view-as toggle-box
  {prodict/user/userbtns.i}
 with frame frm_nto
  centered row 5 attr-space
  overlay side-labels
  view-as dialog-box default-button btn_ok cancel-button btn_cancel
  TITLE " Pre-Selection Criteria For Schema Pull ".


/*---------------------------  TRIGGERS  ---------------------------*/


&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
/*----- HELP -----*/
  on HELP of frame frm_ntoq
    or CHOOSE of btn_Help in frame frm_ntoq
    RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
 			      INPUT {&Presel_Schema_Pull_Qual_Dlg_Box},
			      INPUT ?).
  on HELP of frame frm_link
    or CHOOSE of btn_Help in frame frm_link
    RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
 			      INPUT {&Presel_Schema_Pull_Dlg_Box},
			      INPUT ?).
  on HELP of frame frm_nto
    or CHOOSE of btn_Help in frame frm_nto
    RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
			      INPUT {&Presel_Schema_Pull_Dlg_Box},
			      INPUT ?).
  &ENDIF
  
on GO of frame frm_link do:
  assign
    p_name  = p_name:screen-value  in frame frm_link
    p_owner = p_owner:screen-value in frame frm_link
    p_type  = p_type:screen-value  in frame frm_link
    .
  end.
  
on GO of frame frm_ntoq do:
  assign
    p_name  = p_name:screen-value  in frame frm_ntoq
    p_owner = p_owner:screen-value in frame frm_ntoq
    p_qual  = p_qual:screen-value  in frame frm_ntoq
/*    p_type  = p_type:screen-value  in frame frm_ntoq*/
    .
  end.
  
on GO of frame frm_nto do:
  assign
    p_name  = p_name:screen-value  in frame frm_nto
    p_owner = p_owner:screen-value in frame frm_nto
    p_type  = p_type:screen-value  in frame frm_nto
    .
  end.

on WINDOW-CLOSE of frame frm_link
   apply "END-ERROR" to frame frm_link.
    
on WINDOW-CLOSE of frame frm_ntoq
   apply "END-ERROR" to frame frm_ntoq.

on WINDOW-CLOSE of frame frm_nto
   apply "END-ERROR" to frame frm_nto.
    
/*------------------------  INT.-PROCEDURES  -----------------------*/

/*---------------------------  MAIN-CODE  --------------------------*/

/*------------------------------------------------------------------*/

do on ENDKEY undo,leave:

  assign l_verify = user_env[25] begins "compare"
                 or user_env[25] begins "auto-compare".

  if p_frame = "frm_link":U
   then do:  /* frame frm_link */
    
    if not l_verify
     then assign
      p_vrfy:hidden in frame frm_link = TRUE.

    {adecomm/okrun.i  
      &FRAME  = "FRAME frm_link" 
      &BOX    = "rect_Btns"
      &OK     = "btn_OK" 
      {&CAN_BTN}
      {&HLP_BTN}
      }

    if p_link <> ""
     then assign
      l_link = p_master + p_link
      l_link = substring(l_link,
                         max(1,length(l_link,"character") - 30),
                         -1,
                         "character").
     else assign l_link = "<Local DB>":L30.
      
    display l_link with frame frm_link.
      
    update
      p_name
      p_type 
      p_owner 
      p_vrfy when l_verify
      btn_OK 
      btn_Cancel
      {&HLP_BTN_NAME}
     with frame frm_link.
  
    hide frame frm_link no-pause.
    assign canned = false.

    end.     /* frame frm_link */
  
  else if p_frame = "frm_ntoq":U
   then do:  /* frame frm_ntoq */
 
    if not l_verify
     then assign
      p_vrfy:hidden in frame frm_ntoq = TRUE.

    {adecomm/okrun.i  
      &FRAME  = "FRAME frm_ntoq" 
      &BOX    = "rect_Btns"
      &OK     = "btn_OK" 
      {&CAN_BTN}
      {&HLP_BTN}
      }

    update
      p_name
/*      p_type */
      p_owner
      p_qual
      p_vrfy when l_verify
      btn_OK 
      btn_Cancel
      {&HLP_BTN_NAME}
     with frame frm_ntoq.
  
    hide frame frm_ntoq no-pause.
    assign canned = false.

    end.     /* frame frm_ntoq */
  
  else if p_frame = "frm_nto":U
   then do:  /* frame frm_nto */
 
    if not l_verify
     then assign
      p_vrfy:hidden in frame frm_nto = TRUE.

    {adecomm/okrun.i  
      &FRAME  = "FRAME frm_nto" 
      &BOX    = "rect_Btns"
      &OK     = "btn_OK" 
      {&CAN_BTN}
      {&HLP_BTN}
      }

    update
      p_name
      p_type
      p_owner
      p_vrfy when l_verify
      btn_OK 
      btn_Cancel
      {&HLP_BTN_NAME}
     with frame frm_nto.
  
    hide frame frm_nto no-pause.
    assign canned = false.
    
    end.     /* frame frm_nto */
    
  end.  /* do on endkey undo, leave */
  
RETURN if canned then "cancel":U else "ok":U.
  
/*------------------------------------------------------------------*/        
