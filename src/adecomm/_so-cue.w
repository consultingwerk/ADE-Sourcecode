&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
/* Procedure Description
"SmartObject/Template CueCard Driver"
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME w_smbr-cue
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w_smbr-cue 
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

  File: _so-cue.w

  Description: Cue Card for SmartObjects - intended to be invoked via 
               INLINE XFTR.

               The XFTR which calls this program for cue-card support should
               code the XFTR as follows: 
               (See ADM templates viewer.w, browser.w & query.w for real
                examples of the XFTR).
            
The structure of the code block is as follows:
...
/* Actions: <realize> ? <destroy> ? <write> */
/* <subjectname/title for cuecard window>,helpfile,context#
Text to display in the cue card editor...
...
...
*/  

where     
  helpfile is a string which defines the help file to use with
           a call to SYSTEM-HELP. If "ab" is specified, special
           handling occurs through adecomm/_adehelp.p

  context  is a number which identifies the specific help context
           to call within the 'helpfile'. If missing, or '?', then
           'CONTENTS' will be assumed.
               
  Input Parameters:
      trg-recid (INT)  - RECID of _TRG record cast to an INT
      trg-code  (CHAR) - code block of the _TRG

  Output Parameters:
      <none>

  Author: Gerry Seidl

  Created: 3/14/95

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

{ adecomm/adefext.i }   /* Defines Preprocessor variables   */
{ adecomm/_adetool.i}

/* Parameters Definitions ---                                           */
/* trg-code contains a string in the form of:
   type of object/title for window, text file for cue text */
DEFINE INPUT        PARAMETER trg-recid AS INTEGER   NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER trg-code  AS CHARACTER NO-UNDO. 

DEFINE VARIABLE  firstline    AS CHARACTER NO-UNDO.
DEFINE VARIABLE  subject      AS CHARACTER NO-UNDO.
DEFINE VARIABLE  h            AS HANDLE    NO-UNDO.
DEFINE VARIABLE  tcode        AS CHARACTER NO-UNDO.
DEFINE VARIABLE  sctn         AS CHARACTER NO-UNDO INITIAL "ProUIB".
DEFINE VARIABLE  dlist        AS CHARACTER NO-UNDO.
DEFINE VARIABLE  hlpcontext   AS INTEGER   NO-UNDO INITIAL ?.
DEFINE VARIABLE  hlpfile      AS CHARACTER NO-UNDO INITIAL ?.
DEFINE VARIABLE  cResult      AS CHARACTER NO-UNDO INITIAL NO.
DEFINE VARIABLE  hUIB         AS HANDLE    NO-UNDO.
DEFINE VARIABLE  user-ret-val AS CHARACTER NO-UNDO.

/* If we are opening a Template file, then DON'T RUN THE CUECARD.  Use the
   standard UIB call to see if the current code record is in a Template file. */
RUN adeuib/_uibinfo.p (trg-recid, ?, "TEMPLATE", OUTPUT cResult).
IF cResult eq STRING(yes) THEN RETURN.
 
/* This procedure must run PERSISTENT.  If it was called any other way then
   do it correctly. */       
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  RUN adecomm/_so-cue.w PERSISTENT (INPUT trg-recid, INPUT-OUTPUT trg-code).
  RETURN.
END.

ELSE DO:
  ASSIGN   
     h         = SESSION:FIRST-PROCEDURE
     tcode     = TRIM(trg-code)
     firstline = ENTRY(1,tcode,CHR(10))
     subject   = TRIM(SUBSTRING(firstline,3,
                   LENGTH(firstline,"CHARACTER":u) - 2,"CHARACTER")).

  /* Let's see if there is help stuff to process */
  IF NUM-ENTRIES(subject) > 1 THEN DO:
    ASSIGN hlpfile = ENTRY(2,subject).
    IF NUM-ENTRIES(subject) > 2 THEN
      ASSIGN hlpcontext = INT(ENTRY(3,subject)).
    ASSIGN subject = ENTRY(1,subject).
  END.

  /* If meant to be destroyed then delete the _XFTR and _TRG */
  IF TRIM(ENTRY(2, tcode,CHR(10))) = "Destroy on next read */" THEN DO:
    RUN adeuib/_accsect.p ("DELETE",?,?,INPUT-OUTPUT trg-recid,INPUT-OUTPUT trg-code).
    DELETE PROCEDURE THIS-PROCEDURE.
    RETURN.
  END.
  /* Check to see if a cue is already running for this object. If so, delete this one */
  DO WHILE VALID-HANDLE(h):
    IF ENTRY(1, h:PRIVATE-DATA) = "CUE-CARD"      AND
       ENTRY(2, h:PRIVATE-DATA) = subject         AND
                              h NE THIS-PROCEDURE THEN 
    DO:
      /* There is already one running! Kill this one. */
      APPLY "CLOSE" TO THIS-PROCEDURE.
      RETURN.
    END.
    ASSIGN h = h:NEXT-SIBLING. /* next procedure */
  END.
END.

/* If cue cards are OFF or this one is in the exception list, kill it! */
GET-KEY-VALUE SECTION sctn KEY "Disabled_Cue_Cards" VALUE dlist.
RUN adeuib/_uibinfo.p (?, "SESSION", "USE_CUECARDS", OUTPUT user-ret-val).
IF user-ret-val = "FALSE" OR CAN-DO (dlist, subject) THEN DO:
   DELETE PROCEDURE THIS-PROCEDURE.
   RETURN.
END.
IF dlist = ? THEN dlist = "".

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE l         AS LOGICAL NO-UNDO.
DEFINE VARIABLE i         AS WIDGET  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WINDOW
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f_cuecard

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS b_close b_Help e_cue-text t_show 
&Scoped-Define DISPLAYED-OBJECTS e_cue-text t_show 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w_smbr-cue AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON b_close 
     LABEL "&Close" 
     SIZE 6.8 BY 1
     FONT 4.

DEFINE BUTTON b_Help 
     LABEL "&Help" 
     SIZE 6.8 BY 1
     FONT 4.

DEFINE VARIABLE e_cue-text AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 46.6 BY 7.14
     FONT 4 NO-UNDO.

DEFINE VARIABLE t_show AS LOGICAL INITIAL no 
     LABEL "&Don't show me this again." 
     VIEW-AS TOGGLE-BOX
     SIZE 29.6 BY .95
     FONT 4 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f_cuecard
     b_close AT ROW 1.24 COL 34
     b_Help AT ROW 1.24 COL 41.6
     e_cue-text AT ROW 2.52 COL 1.6 NO-LABEL
     t_show AT ROW 9.67 COL 2.6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 48 BY 9.84.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: WINDOW
   Allow: Basic,DB-Fields,Browse,Window
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w_smbr-cue ASSIGN
         HIDDEN             = YES
         TITLE              = "Cue Card"
         HEIGHT             = 9.86
         WIDTH              = 48
         MAX-HEIGHT         = 9.86
         MAX-WIDTH          = 48
         VIRTUAL-HEIGHT     = 9.86
         VIRTUAL-WIDTH      = 48
         SHOW-IN-TASKBAR    = no
         MIN-BUTTON         = no
         MAX-BUTTON         = no
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         FONT               = 4
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT w_smbr-cue:LOAD-ICON("adeicon/cue":U) THEN
    MESSAGE "Unable to load icon: adeicon/cue"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w_smbr-cue
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME f_cuecard
                                                                        */
ASSIGN 
       e_cue-text:READ-ONLY IN FRAME f_cuecard        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w_smbr-cue)
THEN w_smbr-cue:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w_smbr-cue
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w_smbr-cue w_smbr-cue
ON WINDOW-CLOSE OF w_smbr-cue /* Cue Card */
DO:
  ASSIGN {&WINDOW-NAME}:HIDDEN = yes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_close
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_close w_smbr-cue
ON CHOOSE OF b_close IN FRAME f_cuecard /* Close */
DO:
  ASSIGN {&WINDOW-NAME}:HIDDEN = yes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Help w_smbr-cue
ON CHOOSE OF b_Help IN FRAME f_cuecard /* Help */
OR HELP OF {&WINDOW-NAME}
DO:
  IF hlpfile = "AB" OR hlpfile = "UIB" THEN
    RUN adecomm/_adehelp.p ("AB", "CONTEXT", hlpcontext, ?).
  ELSE DO:
    IF hlpfile NE "" AND hlpfile NE ? THEN
      IF hlpcontext NE ? THEN
        SYSTEM-HELP hlpfile CONTEXT hlpcontext.
      ELSE
        SYSTEM-HELP hlpfile CONTENTS.
    ELSE  MESSAGE "Use the cue cards to get more information about a process or object.  Press Close to dismiss the card."
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME t_show
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL t_show w_smbr-cue
ON VALUE-CHANGED OF t_show IN FRAME f_cuecard /* Don't show me this again. */
DO:
  DEFINE VARIABLE tlist AS CHARACTER NO-UNDO.
  
  ASSIGN dlist = dlist + (IF dlist NE "" THEN "," + subject ELSE subject).
  PUT-KEY-VALUE SECTION sctn KEY "Disabled_Cue_Cards" VALUE dlist NO-ERROR.
  GET-KEY-VALUE SECTION sctn KEY "Disabled_Cue_Cards" VALUE tlist.
  IF dlist NE tlist THEN 
    RUN adeshar/_puterr.p (INPUT "Cue Card", INPUT {&WINDOW-NAME}:HANDLE).
  RUN adeuib/_uibinfo.p (?, "SESSION", 
                         "_user_hints=?", OUTPUT user-ret-val).
  APPLY "CLOSE" TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w_smbr-cue 


/* ***************************  Main Block  *************************** */

/* Find UIB's main window so we can parent the cue card window to it */
ASSIGN h = SESSION:FIRST-CHILD.
DO WHILE VALID-HANDLE(h):
  IF h:TYPE = "WINDOW" THEN IF h:TITLE = "{&UIB_NAME}" THEN
    hUIB = h.
  ASSIGN h = h:NEXT-SIBLING.
END.

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}
       {&WINDOW-NAME}:PARENT         = (IF VALID-HANDLE(hUIB) THEN hUIB ELSE ?).

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* These events will close the window and terminate the procedure.      */
/* (NOTE: this will override any user-defined triggers previously       */
/*  defined on the window.)                                             
ON WINDOW-CLOSE OF {&WINDOW-NAME} DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.*/

ON ENDKEY, END-ERROR OF {&WINDOW-NAME} ANYWHERE DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:   
   ASSIGN
     {&WINDOW-NAME}:TITLE        = subject + " Cue Card"
     THIS-PROCEDURE:PRIVATE-DATA = "CUE-CARD," + subject
     e_cue-text                  = 
       TRIM(SUBSTRING(tcode,LENGTH(firstline,"CHARACTER":u) + 1,-1,"CHARACTER"))
     ENTRY(NUM-ENTRIES(e_cue-text,CHR(10)), e_cue-text, CHR(10) ) = "".
     
  RUN enable_UI.
  RUN create_image.
  RUN pos-win.    
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR "WINDOW-CLOSE" OF {&WINDOW-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE create_image w_smbr-cue 
PROCEDURE create_image :
/* -----------------------------------------------------------
  Purpose:     Create cue card image.
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
DO WITH FRAME f_cuecard:  
  CREATE IMAGE i
   ASSIGN X                 = 4
          Y                 = 1
          FRAME             = FRAME f_cuecard:HANDLE
          width-pixels      = 157
          height-pixels     = 36
          HIDDEN            = NO
          CONVERT-3D-COLORS = YES.

  l = i:LOAD-IMAGE("adeicon/cuecard").
END.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w_smbr-cue _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w_smbr-cue)
  THEN DELETE WIDGET w_smbr-cue.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w_smbr-cue _DEFAULT-ENABLE
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
  DISPLAY e_cue-text t_show 
      WITH FRAME f_cuecard IN WINDOW w_smbr-cue.
  ENABLE b_close b_Help e_cue-text t_show 
      WITH FRAME f_cuecard IN WINDOW w_smbr-cue.
  {&OPEN-BROWSERS-IN-QUERY-f_cuecard}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pos-win w_smbr-cue 
PROCEDURE pos-win :
/* -----------------------------------------------------------
  Purpose:     Position the window in the lower right corner.
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE VARIABLE h     AS HANDLE        NO-UNDO.
  DEFINE VARIABLE w     AS WIDGET-HANDLE NO-UNDO.
  DEFINE VARIABLE wlist AS CHARACTER     NO-UNDO.
  DEFINE VARIABLE cueX  AS INTEGER       NO-UNDO.
  DEFINE VARIABLE cueY  AS INTEGER       NO-UNDO.
  DEFINE VARIABLE i     AS INTEGER       NO-UNDO.
  /* special adjustment for Win95 TaskBar */
  DEFINE VARIABLE TBOrientation AS CHARACTER NO-UNDO.
  DEFINE VARIABLE TBHeight      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE TBWidth       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE AutoHide      AS LOGICAL   NO-UNDO.

  RUN adeshar/_taskbar.p (OUTPUT TBOrientation, OUTPUT TBHeight,
                          OUTPUT TBWIdth,       OUTPUT AutoHide).
  
  ASSIGN cueX = SESSION:WIDTH-P -  {&WINDOW-NAME}:WIDTH-P - 2 * SESSION:PIXELS-PER-COLUMN
         cueY = SESSION:HEIGHT-P - {&WINDOW-NAME}:HEIGHT-P - 1.5 * SESSION:PIXELS-PER-ROW
         .
  /* Adjust for taskbar */
  IF NOT AutoHide THEN DO:
    IF TBOrientation = "BOTTOM" THEN cueY = cueY - TBHeight.
    IF TBOrientation = "RIGHT"  THEN cueX = cueX - TBWidth.
  END.
  
  /* Find all existing cue windows besides this one */
  h = SESSION:FIRST-PROCEDURE.
  DO WHILE VALID-HANDLE(h):
    IF ENTRY(1, h:PRIVATE-DATA) = "CUE-CARD"      AND
                              h NE THIS-PROCEDURE THEN 
    DO:
      w = h:CURRENT-WINDOW.
      /* If the user moved the window, we will leave it alone */
      IF (INT(ENTRY(1,w:PRIVATE-DATA)) < w:X + 50  AND
          INT(ENTRY(1,w:PRIVATE-DATA)) > w:X - 50) AND
         (INT(ENTRY(2,w:PRIVATE-DATA)) < w:Y + 50  AND
          INT(ENTRY(2,w:PRIVATE-DATA)) > w:Y - 50) THEN
      DO: /* user didn't move it */
        wlist = wlist + 
                (IF wlist = "" THEN STRING(w:HANDLE) ELSE "," + STRING(w:HANDLE)).
      END.
    END.
    ASSIGN h = h:NEXT-SIBLING. /* next procedure */
  END.
  /* Reposition existing cue windows */
  IF NUM-ENTRIES(wlist) > 0 THEN
  DO i = NUM-ENTRIES(wlist) TO 1 BY -1:
    w = WIDGET-HANDLE(ENTRY(i,wlist)).
    IF VALID-HANDLE(w) THEN
      ASSIGN w:X = cueX - ( i * SESSION:PIXELS-PER-COLUMN)
             w:Y = cueY - ( i * SESSION:PIXELS-PER-ROW)
             w:PRIVATE-DATA = STRING(w:X) + "," + STRING(w:Y)
             l = w:MOVE-TO-TOP().
  END.
  ASSIGN
    {&WINDOW-NAME}:X            = cueX
    {&WINDOW-NAME}:Y            = cueY
    {&WINDOW-NAME}:HIDDEN       = NO
    {&WINDOW-NAME}:PRIVATE-DATA = STRING({&WINDOW-NAME}:X) + "," + STRING({&WINDOW-NAME}:Y)
    l = {&WINDOW-NAME}:MOVE-TO-TOP().
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

