&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File       : _wizmap.w
  Purpose    : Start the mapping browser persistently 
  Description: External Table wizard screen 

  Input Parameters:
               hWizard (hdl) - handle of Wizard dialog
  
  Subscribe  : ab_FocusedRowIsMapped to setUnmapButton 
  
  Publish    : ab_UnmapField 
               ab_MapField
               ab_UnMapall
               Are all published by the corresponding buttons
                                
  Author: Haavard Danielsen (Copied from old v7 templates) 

  Created: 3/2/98
  Note   :  
  Changed: 4/7/98 
           Cleaned up the interface to the browser.
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
{ src/adm2/support/admhlp.i } /* ADM Help Defs */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER hWizard AS WIDGET-HANDLE NO-UNDO.

DEFINE Variable xBrowseCol      AS INTEGER INIT 2 NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE proc-recid      AS CHARACTER         NO-UNDO.
DEFINE VARIABLE hBrowse         AS HANDLE            NO-UNDO.
DEFINE VARIABLE iSectionRecid   AS INTEGER   INIT ?  NO-UNDO.
DEFINE VARIABLE cCode           AS CHARACTER INIT ?  NO-UNDO.
DEFINE Variable gWizardHdl      AS HANDLE            NO-UNDO.

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS e_xtbl b_Automap b_Map btnHelp 
&Scoped-Define DISPLAYED-OBJECTS e_xtbl 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnHelp 
     LABEL "Help on Mapping" 
     SIZE 26 BY 1.14.

DEFINE BUTTON b_Automap 
     LABEL "Automap Fields" 
     SIZE 26 BY 1.14.

DEFINE BUTTON b_Map 
     LABEL "Map Field..." 
     SIZE 26 BY 1.14.

DEFINE BUTTON b_unmap 
     LABEL "Unmap Field" 
     SIZE 26 BY 1.14.

DEFINE VARIABLE e_xtbl AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 26 BY 4.57
     BGCOLOR 8 FONT 4 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     e_xtbl AT ROW 1.52 COL 57 NO-LABEL
     b_Automap AT ROW 6.38 COL 57
     b_Map AT ROW 7.71 COL 57
     b_unmap AT ROW 9.1 COL 57
     btnHelp AT ROW 10.95 COL 57
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 83.86 BY 11.35.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Window
   Frames: 1
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* SUPPRESS Window definition (used by the UIB) 
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "<insert window title>"
         HEIGHT             = 11.67
         WIDTH              = 83.8
         MAX-HEIGHT         = 16
         MAX-WIDTH          = 83.8
         VIRTUAL-HEIGHT     = 16
         VIRTUAL-WIDTH      = 83.8
         SHOW-IN-TASKBAR    = no
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
                                                                        */
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME
ASSIGN C-Win = CURRENT-WINDOW.




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
                                                                        */
ASSIGN 
       FRAME DEFAULT-FRAME:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON b_unmap IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
ASSIGN 
       e_xtbl:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* <insert window title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* <insert window title> */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnHelp C-Win
ON CHOOSE OF btnHelp IN FRAME DEFAULT-FRAME /* Help on Mapping */
DO:
  RUN adecomm/_adehelp.p ("AB":U, "CONTEXT":U, {&Help_on_Mapping}, ?).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_Automap
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Automap C-Win
ON CHOOSE OF b_Automap IN FRAME DEFAULT-FRAME /* Automap Fields */
DO:
  PUBLISH "ab_AutoMap":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_Map
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Map C-Win
ON CHOOSE OF b_Map IN FRAME DEFAULT-FRAME /* Map Field... */
DO:
  PUBLISH "ab_MapField":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_unmap
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_unmap C-Win
ON CHOOSE OF b_unmap IN FRAME DEFAULT-FRAME /* Unmap Field */
DO:
  PUBLISH "ab_UnMapField":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */
ASSIGN FRAME {&FRAME-NAME}:FRAME    = hwizard
       FRAME {&FRAME-NAME}:HEIGHT-P = FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT-P
       FRAME {&FRAME-NAME}:WIDTH-P  = FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-P
       FRAME {&FRAME-NAME}:HIDDEN   = NO
       gWizardHdl                   = SOURCE-PROCEDURE       

      /* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
       CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.       

/* Get Procedure context (recid of procedure record in the UIB) */
RUN adeuib/_uibinfo.p(?, "PROCEDURE ?":U, "PROCEDURE":U, OUTPUT proc-recid).

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE DO: 
  RUN ProcessPage. 
  APPLY 'CLOSE':U TO  hBrowse.
  RUN disable_UI.
END.

RUN adeweb/_brwsmap.w PERSISTENT set hBrowse.

SUBSCRIBE "ab_FocusedRowIsMapped":U IN hBrowse RUN-PROCEDURE "setUnmapButton":U. 

RUN setParentFrame   IN hBrowse (hWizard:FIRST-CHILD). 
RUN repositionObject IN hBrowse (e_xtbl:row IN FRAME {&FRAME-NAME}, xBrowseCol).
RUN setWidth         IN hBrowse (e_xtbl:col IN FRAME {&FRAME-NAME} - (xBrowseCol * 2) + 1 ).

RUN initializeObject IN hBrowse. 

ASSIGN 
  e_xtbl = "Press Automap for a best guess mapping.  "
         + "Press Map/Unmap to add/remove mapping for a field.  "
         + "Press Next to continue".    

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
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
  HIDE FRAME DEFAULT-FRAME.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
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
  DISPLAY e_xtbl 
      WITH FRAME DEFAULT-FRAME.
  ENABLE e_xtbl b_Automap b_Map btnHelp 
      WITH FRAME DEFAULT-FRAME.
  VIEW FRAME DEFAULT-FRAME.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ProcessPage C-Win 
PROCEDURE ProcessPage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF DYNAMIC-FUNCTION ("GetLastButton" IN gWizardHdl) = "NEXT":U THEn
  DO:
     RUN adeuib/_accsect.p ("SET":U,
                             INT(proc-recid),
                            "PROCEDURE:htmOffsets:_WEB-HTM-OFFSETS":U,
                             INPUT-OUTPUT iSectionRecid, /* Must be ? */
                             INPUT-OUTPUT cCode          /* Must be ? */ ). 

     APPLY 'U1':U to hWizard.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setUnmapButton C-Win 
PROCEDURE setUnmapButton :
/*------------------------------------------------------------------------------
  Purpose: Set the unmap button sensitive attribute basee on whats the stae of the 
           current row in the browser 
           This procedures is subscred to ab_FocusedRowIsMapped. 
                 
  Parameters:  pMapped - Yes current row is mapped 
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pMappedRow AS LOG.
  
  b_unmap:SENSITIVE IN FRAME {&FRAME-NAME} = pMappedRow.   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

