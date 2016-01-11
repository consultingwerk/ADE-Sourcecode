&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME f_windows
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS f_windows 
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
/*------------------------------------------------------------------------

  File: _winmgr.w

  Description: Creates a TEMP-TABLE of all the windows (SESSION:Childen)
               in this PROGRESS Session and lets the user:
                   a) hide them
                   b) minimize them
                   c) maximize them  

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: William T. Wood

  Created: 11/10/93 - 10:17 am
  
  Modified by Gerry Seidl - UI redesigned, parent/child support
  
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/
{ protools/ptlshlp.i } /* help definitions */
{ adecomm/_adetool.i }

/* ***************************  Definitions  ************************** */

/* Local Definitions ---                                           */
DEFINE TEMP-TABLE w
    FIELD wHandle AS WIDGET-HANDLE
    FIELD wParent AS WIDGET-HANDLE
    FIELD level   AS INT
    FIELD cTitle  AS CHAR FORMAT "X(45)":U LABEL "Title"
    FIELD cStatus AS CHAR FORMAT "X(12)":U Label "Status"
    FIELD lHidden AS LOGICAL FORMAT "Hidden    /" LABEL "Hidden"
    FIELD srtfld  AS INT
    INDEX srtfld IS PRIMARY srtfld
    .
    
DEFINE VAR h      AS WIDGET-HANDLE NO-UNDO.
DEFINE VAR ldummy AS LOGICAL       NO-UNDO.
DEFINE VAR wseq   AS INTEGER       NO-UNDO INITIAL 0.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f_windows

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Btn_Done b_Help 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Done AUTO-GO 
     LABEL "&Close":L 
     SIZE 15 BY 1.14.

DEFINE BUTTON b_Help 
     LABEL "&Help" 
     SIZE 15 BY 1.14.

DEFINE BUTTON b_hide 
     LABEL "&Show":L 
     SIZE 15 BY 1.14.

DEFINE BUTTON b_pop 
     LABEL "&Pop to Top":L 
     SIZE 15 BY 1.14.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f_windows
     Btn_Done AT ROW 1.48 COL 76.6
     b_hide AT ROW 3.38 COL 76.6
     b_pop AT ROW 4.71 COL 76.6
     b_Help AT ROW 6.1 COL 76.6
     SPACE(1.06) SKIP(4.35)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS THREE-D  SCROLLABLE 
         TITLE "PROGRESS Window Viewer":L
         DEFAULT-BUTTON Btn_Done.

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX f_windows
   UNDERLINE Default                                                    */
ASSIGN 
       FRAME f_windows:SCROLLABLE       = FALSE.

/* SETTINGS FOR BUTTON Btn_Done IN FRAME f_windows
   NO-DISPLAY                                                           */
/* SETTINGS FOR BUTTON b_hide IN FRAME f_windows
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR BUTTON b_pop IN FRAME f_windows
   NO-DISPLAY NO-ENABLE                                                 */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME b_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Help f_windows
ON CHOOSE OF b_Help IN FRAME f_windows /* Help */
DO:
  RUN adecomm/_adehelp.p ( "ptls", "CONTEXT", {&Window_Viewer}, ? ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_hide
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_hide f_windows
ON CHOOSE OF b_hide IN FRAME f_windows /* Show */
DO:
  DEFINE VARIABLE choice AS LOGICAL INITIAL NO NO-UNDO.
  
  IF AVAILABLE w THEN DO:
    IF whandle:TITLE = "PROGRESS" AND REPLACE(SELF:LABEL,"&","") = "Hide" THEN DO:
      MESSAGE "The window named 'PROGRESS' is typically the PROGRESS Desktop." skip
              "Hiding this window may prevent you from using another tool" skip
              "or from exiting from PROGRESS." skip(1)
              "Do you really want to hide it?"
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE choice. 
      IF NOT choice THEN RETURN NO-APPLY.
    END.
    RUN hide_current.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_pop
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_pop f_windows
ON CHOOSE OF b_pop IN FRAME f_windows /* Pop to Top */
DO:
  /* Pop the selected window (move it to top). */
  IF AVAILABLE w THEN DO:
    ASSIGN w.wHandle:VISIBLE = YES
           ldummy = w.wHandle:MOVE-TO-TOP().
    RUN redisplay_w.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK f_windows 


/* ************************* Browser Definitons *********************** */

/* Definitions of the queries                                           */
DEFINE QUERY browser_w FOR w SCROLLING.

/* Definitions of the browser frames                                    */
DEFINE BROWSE browser_w QUERY BROWSER_w DISPLAY 
      w.cTitle 
      w.cStatus
      w.lHidden
     WITH NO-UNDERLINE SIZE 74 BY 9.5.

/* Add the browser to the frame */    
DEFINE FRAME {&FRAME-NAME} browser_w AT ROW 1.5 COL 2.

/* Hide or show the current selection */
ON MOUSE-SELECT-DBLCLICK OF browser_w DO:
  IF AVAILABLE w THEN APPLY "CHOOSE" TO b_Hide.
END.

ON ITERATION-CHANGED OF browser_w DO:
   b_hide:LABEL = IF w.lHidden THEN "&Show" ELSE "&Hide".
   /* Enable buttons that depend on a valid window */
   IF AVAILABLE(w) ne b_hide:SENSITIVE
   THEN ASSIGN b_hide:SENSITIVE = AVAILABLE(w)
               b_pop:SENSITIVE  = b_hide:SENSITIVE
               .
END.

/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  /* Find the handles, titles, etc of all windows in the session. */
  RUN wins (SESSION, 1).
  /* Populate and show the browser on session windows. */
  OPEN QUERY browser_w FOR EACH w.
  ASSIGN browser_w:SENSITIVE = YES.
  IF browser_w:SELECT-ROW(1) THEN.
  APPLY "ITERATION-CHANGED" TO browser_w.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI f_windows _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME f_windows.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI f_windows _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  ENABLE Btn_Done b_Help 
      WITH FRAME f_windows.
  {&OPEN-BROWSERS-IN-QUERY-f_windows}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE hide_current f_windows 
PROCEDURE hide_current :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  IF w.wHandle eq FRAME {&FRAME-NAME}:PARENT AND w.wHandle:VISIBLE
  THEN MESSAGE "Sorry.  This window is the parent of this dialog-box." SKIP
               "It cannot be hidden."
               VIEW-AS ALERT-BOX WARNING BUTTONS OK.  
  ELSE DO:
    ASSIGN w.wHandle:HIDDEN = NOT w.wHandle:HIDDEN.
    RUN redisplay_w.         
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE redisplay_w f_windows 
PROCEDURE redisplay_w :
/* -----------------------------------------------------------
  Purpose:     Redisplay the current visiblility of the current
               window (this is the only thing that can change
               in the browser).
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE BUFFER ww FOR w.
  DEFINE VARIABLE oldrecid AS RECID   NO-UNDO.
  DEFINE VARIABLE h        AS HANDLE  NO-UNDO.
  DEFINE VARIABLE l        AS LOGICAL NO-UNDO.
  
  oldrecid = RECID(w).
  ASSIGN w.lHidden = w.wHANDLE:HIDDEN
         b_hide:LABEL IN FRAME {&FRAME-NAME} = 
                     IF w.wHandle:HIDDEN THEN "&Show" ELSE "&Hide".
  IF CAN-FIND (FIRST ww WHERE ww.wParent = w.wHANDLE AND ww.level > w.level) THEN 
  DO:
    FOR EACH ww WHERE ww.wParent = w.wHANDLE AND ww.level > 1:
      ww.wHandle:HIDDEN = w.wHandle:HIDDEN.
      IF w.lHidden THEN ww.lHidden = w.wHANDLE:HIDDEN.
      ELSE ww.lHidden = ww.wHandle:HIDDEN.
    END.    
    ASSIGN h = browser_w:HANDLE
           l = h:SET-REPOSITIONED-ROW (MAX(1,h:FOCUSED-ROW), "CONDITIONAL").
    OPEN QUERY browser_w FOR EACH w.
    REPOSITION browser_w TO RECID(oldrecid).
    /*IF browser_w:SELECT-ROW(1) THEN.*/
  END.    
  ELSE DISPLAY w.lHidden  WITH BROWSE browser_w.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE wins f_windows 
PROCEDURE wins :
DEFINE INPUT PARAMETER w  AS HANDLE  NO-UNDO.
  DEFINE INPUT PARAMETER l  AS INTEGER NO-UNDO.
  DEFINE VARIABLE        h1 AS HANDLE  NO-UNDO.
  
  ASSIGN h1 = w:FIRST-CHILD.
  DO WHILE VALID-HANDLE(h1):
    IF h1:TYPE = "WINDOW" THEN DO:
      CREATE w.
      ASSIGN w.wHANDLE = h1
             w.wParent = (IF h1:PARENT EQ ? THEN h1 ELSE h1:PARENT)
             w.cTitle  = FILL("- ",l - 1) + " " + (IF h1:TITLE NE ? AND h1:TITLE NE "" THEN h1:TITLE ELSE "<no title>")
             w.cStatus = ENTRY(h1:WINDOW-STATE,"Maximized,Minimized,Normal":U)
             w.lHidden = IF w.wPARENT:HIDDEN THEN YES ELSE h1:HIDDEN
             w.level   = l
             wseq      = wseq + 1
             w.srtfld  = wseq.
    END.
    IF CAN-QUERY(h1,"FIRST-CHILD") THEN RUN wins (INPUT h1, l + 1).
    ASSIGN h1 = h1:NEXT-SIBLING.
  end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


