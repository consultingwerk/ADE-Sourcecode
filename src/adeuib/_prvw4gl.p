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
/********************************************************************/
/* Encrypted code which is part of this file is subject to the      */
/* Possenet End User Software License Agreement Version 1.0         */
/* (the "License"); you may not use this file except in             */
/* compliance with the License. You may obtain a copy of the        */
/* License at http://www.possenet.org/license.html                  */
/********************************************************************/

/*----------------------------------------------------------------------------

File: _prvw4gl.p

Description:
    A first pass at the 4GL code previewer (it shows the compilation file).

Input Parameters:
   pc_file  : File Name
   pc_msg   : Error message to display at startup (this can be ?)
   pi_char  : Initial cursor-char offset (eg. COMPILER:ERROR-COLUMN)
   pi_line  : Initial cursor-line offset (eg. COMPILER:ERROR-ROW)
   
Output Parameters:
   <None>

Note: If either pi_line or pi_char is UNKNOWN, then neither will be set.

Author: D. Ross Hunter,  Wm.T.Wood

Date Created: October 1992 

----------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pc_file   AS CHAR    NO-UNDO.
DEFINE INPUT PARAMETER pc_msg    AS CHAR    NO-UNDO.
DEFINE INPUT PARAMETER pi_char   AS INTEGER NO-UNDO.
DEFINE INPUT PARAMETER pi_line   AS INTEGER NO-UNDO.

/* Use 3D dialog-boxes -- */
&Scoped-define USE-3D YES
&GLOBAL-DEFINE WIN95-BTN YES
{adecomm/adestds.i}   /* Standard Definitions             */ 
{adeuib/uibhlp.i}     /* Help pre-processor directives    */

/* These provide editor functionality */
{adecomm/dsearch.i}  /* Search Defines */
{adecomm/psearch.i}  /* Search Procedures */
{adecomm/peditor.i}  /* Editor procedures */

DEFINE VAR too_big	AS DECIMAL				NO-UNDO.
DEFINE VAR ed 		AS CHAR					NO-UNDO	
       VIEW-AS EDITOR LARGE
               SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
               SIZE 80 BY 25 {&STDPH_ED4GL}.

/* Buttons for the bottom of the screen                                      */
DEFINE BUTTON btn_ok     LABEL "OK":C12     {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON btn_help   LABEL "&Help":C12  {&STDPH_OKBTN}.

/* standard button rectangle */
&IF {&OKBOX} &THEN
DEFINE RECTANGLE rect_btns {&STDPH_OKBOX}.
&ENDIF

DEFINE FRAME f_preview
        SKIP({&TFM_WID}) SPACE ({&HFM_WID}) 
	ed
	{adecomm/okform.i
		&BOX    = "rect_btns"
		&STATUS = "no"
		&OK     = "btn_ok"
		&HELP   = "btn_help" }

	WITH NO-LABELS DEFAULT-BUTTON btn_ok WIDTH 90
             TITLE "Code Preview" VIEW-AS DIALOG-BOX THREE-D.

/* Standard UIB dialog code -- to prevent "wind-close" error */
{adeuib/std_dlg.i &FRAME_CLOSE = f_preview}

/* Help triggers: there are two kinds.  
    1) If the user clicks the help button, then run the dialog help.
    2) If the user hits help in the editor, then do Editor help which
       provides syntax help.  */
ON CHOOSE OF btn_help IN FRAME f_preview OR HELP OF FRAME f_preview
  RUN adecomm/_adehelp.p ( "AB", "CONTEXT", {&Code_Preview_Dlg_Box}, ? ).
ON HELP OF ed
  RUN adecomm/_kwhelp.p (SELF, "AB", {&Code_Preview_Dlg_Box}).

/* Find/Find Next/Find Previous */
ON CTRL-F   OF FRAME f_preview ANYWHERE run FindText (ed:HANDLE).
ON F9       OF FRAME f_preview ANYWHERE run FindNext (ed:HANDLE, Find_Criteria).
ON SHIFT-F9 OF FRAME f_preview ANYWHERE run FindPrev (ed:HANDLE, Find_Criteria).

ASSIGN FRAME f_preview:HIDDEN = TRUE.

RUN SetEditor (INPUT ed:HANDLE).   /* adecomm/peditor.i */
ASSIGN ed:WIDTH  = FONT-TABLE:GET-TEXT-WIDTH(FILL("0":U, 85), editor_font).
ASSIGN FRAME f_preview:WIDTH = ed:WIDTH + 
                               FRAME f_preview:BORDER-LEFT + 
                               FRAME f_preview:BORDER-RIGHT + {&HFM_WID} .

/* This line fixes bug 97-03-24-033. Without it, the READ-FILE method in the
   next code line clears the SCROLLBAR-HORIZONTAL. - jep */
ASSIGN ed:VISIBLE IN FRAME f_preview = TRUE.

/* Read the preview file into the preview buffer. */
IF NOT ed:READ-FILE(pc_file) IN FRAME f_preview 
THEN MESSAGE "The preview file ~"" pc_file "~" could not be opened." 
	     VIEW-AS ALERT-BOX ERROR BUTTONS OK.

/* adecomm/peditor.i */
/* Sets the buffer type for color coding based on the extension. We presume
   that to be .w (.w, .p, and .i all have same color coding). So pass
   a dummy procedure file name with .w extension. - jep */
RUN SetEdBufType (INPUT ed:HANDLE IN FRAME f_preview, INPUT 'progress4gl.w':u).

/* Make sure the input values of pi_line and pi_char are valid */
IF pi_line eq ? or pi_line < 1 THEN pi_line = 1.
IF pi_char eq ? or pi_char < 1 THEN pi_char = 1.

DO WITH FRAME f_preview:

   /* Do more setup for the frame and its contents. */
  ASSIGN ed:READ-ONLY = TRUE
        /* Shrink the size of everything if the window is too big */
        too_big = FRAME f_preview:HEIGHT - SESSION:HEIGHT
                 &IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN + 2 &ENDIF 
        /* Point to the current cursor position (or the top-of-file) */
        ed:CURSOR-LINE = pi_line
        ed:CURSOR-CHAR = pi_char
        .

  IF too_big > 0 THEN 
    ASSIGN
       btn_ok:ROW                   = btn_ok:ROW - too_big
	   btn_help:ROW		            = btn_ok:ROW
           &IF {&OKBOX} &THEN
           rect_btns:ROW            = rect_btns:ROW - too_big
           &ELSE
           FRAME f_preview:RULE-ROW = FRAME f_preview:RULE-ROW - too_big
           &ENDIF
	   ed:HEIGHT                    = ed:HEIGHT - too_big
           FRAME f_preview:HEIGHT   = FRAME f_preview:HEIGHT - too_big.

  /* Run time layout for button area. */
  {adecomm/okrun.i  
     &FRAME = "FRAME f_preview" 
     &BOX   = "rect_btns"
     &OK    = "btn_ok" 
     &HELP  = "btn_help"
  }

  ENABLE ed btn_ok btn_help WITH FRAME f_preview.
  
  /* Show any error message. */
  IF pc_msg ne ? THEN MESSAGE pc_msg VIEW-AS ALERT-BOX ERROR BUTTONS OK.

  ASSIGN FRAME f_preview:HIDDEN = FALSE.
  WAIT-FOR GO OF FRAME f_preview FOCUS ed.

END. 

/* Finish up */
HIDE FRAME f_preview.

