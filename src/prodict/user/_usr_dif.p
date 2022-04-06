/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: prodict/gate/_usr_dif.p

Description:   
   Displays gate-edit in an editor-widget. 
   Designed to run persistently and get the following events to 
   invoke the following methods:
   
Input: 
   "U1"     new gate-work-recid in s_gw-recid
   "U2"     delete procedure

Output:
    none
 
History:
    hutegger    95/03   creation

----------------------------------------------------------------------------*/
/*h-*/

/* this file gets used only with GUI, so we make it an empty file for TTY
 */
&IF "{&WINDOW-SYSTEM}" <> "TTY"
 &THEN

&SCOPED-DEFINE DATASERVER YES
{ prodict/dictvar.i }
{ prodict/user/uservar.i }
&UNDEFINE DATASERVER

define input parameter p_prc_parent as handle.

define shared variable s_edt_diff   as character     NO-UNDO.
define shared variable s_tgl_upd    as logical       NO-UNDO.

define        variable l_wdw_diff   as widget-handle NO-UNDO.

/* create window */
if SESSION:DISPLAY-TYPE = "GUI":U
 then create window l_wdw_diff
   assign
         HIDDEN             = YES
         TITLE              = "Schema-Verify - Detected Differences"
         HEIGHT             = 14
         WIDTH              = 69
         MAX-HEIGHT         = 14
         MAX-WIDTH          = 69
         VIRTUAL-HEIGHT     = 14
         VIRTUAL-WIDTH      = 69
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
 else assign l_wdw_diff = CURRENT-WINDOW.

/*================================Forms====================================*/

form
                                                        skip({&TFM_WID})
   "Verifying this object resulted in these messages:" 
                                    at  2 view-as TEXT  skip({&VM_WID})
   s_edt_diff                       at  2 no-label
                        view-as EDITOR 
                        scrollbar-horizontal scrollbar-vertical
                        inner-chars 58 inner-lines 12   skip({&VM_WID})
                        space(1)
   s_tgl_upd                        at 2 view-as text label "Update" 
   {adecomm/okform.i
      &BOX    = rect_btns
      &CANCEL = " "
      &HELP   = "{&HLP_BTN_NAME}"
      &OK     = btn_OK
      &OTHER  = " "
      &STATUS = no
      }
  with side-labels
       row 1 column 1
       title "Verify - Report"
       frame l_frm_diff.

/*===============================Triggers==================================*/

/*----- HELP -----*/
&IF "{&WINDOW-SYSTEM}" <> "TTY"
 &THEN
  on HELP of frame l_frm_diff OR CHOOSE of btn_Help in frame l_frm_diff
     RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
                               INPUT {&Schema_Verify_Dlg_Box},
                               INPUT ?).
 &ENDIF
 
/*----- U1 of PROCEDURE -----*/
on  U1 of THIS-PROCEDURE do: /* refresh with new values */

  display
    s_edt_diff s_tgl_upd
    with frame l_frm_diff in window l_wdw_diff.

  end.

/*----- WINDOW-CLOSE of dialog -----*/
on WINDOW-CLOSE of frame l_frm_diff
  apply "END-ERROR" to frame l_frm_diff.

/*----- U2 of PROCEDURE -----*/
on  U2     of THIS-PROCEDURE do: /* parent wants to close me */
  if SESSION:DISPLAY-TYPE = "GUI":U
   then delete widget l_wdw_diff.
  delete procedure THIS-PROCEDURE.
  end.

/*----- CLOSE of PROCEDURE -----*/
on  CLOSE  of THIS-PROCEDURE /* I want to close myself -> msg to parent */
 or CHOOSE of btn_ok in frame l_frm_diff do:
  APPLY "U1" to p_prc_parent.
  if SESSION:DISPLAY-TYPE = "GUI":U
   then delete widget l_wdw_diff.
  delete procedure THIS-PROCEDURE.
  end.


/*============================Mainline code============================*/
 

/* Run time layout for button areas. */
{adecomm/okrun.i  
   &FRAME  = "FRAME l_frm_diff" 
   &BOX    = "rect_Btns"
   &OK     = "btn_OK" 
   &CANCEL = "  " 
   {&HLP_BTN}
}

do with frame l_frm_diff:
  assign
    s_edt_diff:read-only = yes
    btn_ok:label         = "Close"
    l_wdw_diff:width-p   = frame l_frm_diff:width-p /* - 10*/
    l_wdw_diff:height-p  = frame l_frm_diff:height-p
    s_edt_diff:width-p   = /*min(s_edt_diff:width-p
                           ,*/ frame l_frm_diff:width-p
                           - frame l_frm_diff:border-left-p
                           - frame l_frm_diff:border-right-p
                           - 2 * s_edt_diff:x
                                    /* )*/
    l_wdw_diff:x = session:width-p - l_wdw_diff:width-p - 10
    THIS-PROCEDURE:current-window = l_wdw_diff.
  end.
  
do ON ERROR   UNDO, LEAVE
   ON END-KEY UNDO, LEAVE:

  display
    s_edt_diff
    s_tgl_upd
    with frame l_frm_diff in window l_wdw_diff.
  enable
    s_edt_diff
/*  s_tgl_upd */
    btn_OK
    {&HLP_BTN_NAME}
    with frame l_frm_diff in window l_wdw_diff.
  view l_wdw_diff.
  end.

  &ENDIF   /* "{&WINDOW-SYSTEM}" <> "TTY" */
/*=====================================================================*/
