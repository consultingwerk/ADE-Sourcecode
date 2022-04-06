/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: trigdlg.i

Description:
   Some standard definitions and triggers for the dictionary trigger 
   editor and UIB section editor.

Arguments:
   &Insert_Lbl - Label for the Insert button
   &Insert_Wid - Width for the insert button
   &Apply_Action - Then text string for the Apply Action 
                   (usually "Save" or "Store") 

Author: Laura Stern

Date Created: 05/11/93
----------------------------------------------------------------------------*/

/* Widget definitions */

define button btn_cut      label "Cu&t"		  size 9 BY 1.125.
define button btn_copy     label "&Copy"	         size 9 BY 1.125.
define button btn_paste    label "&Paste"	         size 9 BY 1.125.
     
define button btn_find     label "&Find..."	  size 9 BY 1.125.
define button btn_next     label "&>"		  size 3 BY 1.125.
define button btn_prev     label "&<"		  size 3 BY 1.125.

define button btn_replace  label "&Replace..."     size 12 BY 1.125.
define button btn_insert   label "{&Insert_Lbl}"   size {&Insert_Wid} BY 1.125.

define button btn_delete   label "&Delete"         size 9 BY 1.125.
define button btn_revert   label "Re&vert"         size 9 BY 1.125.

define button btn_now      label "No&w"            size 6 BY 1.125.

define var tgl_syntax_lbl as char    init "Check Syntax:" no-undo
      	   format "x(13)".
define var tgl_syntax 	  as logical label "&On {&Apply_Action}"  no-undo
      	   view-as TOGGLE-BOX.

&global-define TRIG_LAYOUT   SKIP({&VM_WIDG})                 ~
      	       	     	     btn_cut   at 2 SPACE({&HM_BTN})  ~
			     btn_copy	    SPACE({&HM_BTN})  ~
			     btn_paste	    SPACE({&HM_BTNG}) ~
			     btn_find	    SPACE({&HM_BTN})  ~
			     btn_prev	    SPACE({&HM_BTN})  ~
			     btn_next	    SPACE({&HM_BTN})  ~
			     btn_replace    SPACE({&HM_BTNG}) ~
			     btn_insert	                      ~
			     SKIP({&VM_WID})                  ~
      	       	     	     "Trigger:" at 3                  ~
                             btn_delete                       ~
			     btn_revert     SPACE({&HM_WIDG}) ~
			     tgl_syntax_lbl no-label SPACE(0) ~
			     btn_now                          ~
			     tgl_syntax

/* Widget handle to the text editor widget - must be set by includer. */
define var h_Editor as widget-handle no-undo.

/*--------------------------------------------------------------
   Do some runtime frame layout.

   Input Parameters:
      p_FrameWid - internal width of the frame
      p_Lbl      - widget handle of check syntax label widget
      p_Btn    	 - widget handle of check syntax button
      p_Tgl    	 - widget handle of check syntax toggle
      p_Rect   	 - widget handle of separator rectangle 
      	           between the button section and rest of frame
--------------------------------------------------------------*/
procedure Adjust_Trig_Layout:

   define input parameter p_FrameWid as decimal       no-undo.
   define input parameter p_Lbl      as widget-handle no-undo.
   define input parameter p_Btn      as widget-handle no-undo.
   define input parameter p_Tgl      as widget-handle no-undo.
   define input parameter p_Rep      as widget-handle no-undo.
   define input parameter p_Nex      as widget-handle no-undo.
   define input parameter p_Pre      as widget-handle no-undo.
   define input parameter p_Fin      as widget-handle no-undo.
   define input parameter p_Ins      as widget-handle no-undo.
   define input parameter p_Cop      as widget-handle no-undo.
   define input parameter p_Pas      as widget-handle no-undo.
   define input parameter p_Del      as widget-handle no-undo.
   define input parameter p_Rev      as widget-handle no-undo.

   define var w_col as decimal no-undo.
   define var diff  as decimal no-undo.

   assign
      /* Move syntax label, button and toggle over (right justified) */
      w_col = p_FrameWid - (p_Lbl:width + p_Btn:width + p_Tgl:width)
      diff          = w_col - p_Lbl:col
      p_Lbl:col     = p_Lbl:col + diff - .5
      p_LBL:WIDTH   = p_Lbl:WIDTH + .5
      p_Btn:col     = p_Btn:col + diff
      p_Tgl:col     = p_Tgl:col + diff

      p_Rep:col     = p_Rep:col + 1.5
      p_Nex:col     = p_Nex:col + 1.5
      p_Pre:col     = p_Pre:col + 1.5
      p_Fin:col     = p_Fin:col + 1.5
      p_Ins:col     = p_Btn:col
      p_Del:col     = p_Cop:col
      p_Rev:col     = p_Pas:col
      p_Ins:WIDTH   = p_Tgl:col + p_Tgl:WIDTH - p_Ins:col
   
      h_Editor:width = p_FrameWid.
end.



