&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
/* Procedure Description
"This SmartPanel sends navigation messages 
to its NAVIGATION-TARGET. Its buttons have 
icons and are arranged horizontally."
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS P-Win 
/*******************************************************************
* Copyright (C) 2006 by Progress Software Corporation. All rights  *
* reserved.  Prior versions of this work may contain portions      *
* contributed by participants of Possenet.                         *
*                                                                  *
********************************************************************/
/*------------------------------------------------------------------------

  File:  adm2/dyntoolbar.w

  Description: SmartToolbar object  
  
  Input Parameters:
      <none>

  Output Parameters:
      <none>

    Created: April 1999 -- Progress Version 9.1A
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
&GLOB ADM-Panel-Type    Toolbar
/* tell smart.i that we can use the default destroyObject */ 
&SCOPED-DEFINE include-destroyobject
/* Local Variable Definitions ---                                       */

DEFINE VARIABLE ghMenu        AS HANDLE  NO-UNDO.
DEFINE VARIABLE glResetRecord AS LOG     NO-UNDO INITIAL FALSE .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE toolbar
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Navigation-Source,TableIo-Source

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Panel-Frame

/* Custom List Definitions                                              */
/* Box-Rectangle,List-2,List-3,List-4,List-5,List-6                     */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initializeMenu P-Win 
FUNCTION initializeMenu RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD initializeToolBar P-Win 
FUNCTION initializeToolBar RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Panel-Frame
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 67.2 BY 1.57.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: toolbar
   Allow: Basic
   Frames: 1
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW P-Win ASSIGN
         HEIGHT             = 1.57
         WIDTH              = 67.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB P-Win 
/* ************************* Included-Libraries *********************** */

{src/adm2/toolbar.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW P-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME Panel-Frame
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME Panel-Frame:SCROLLABLE       = FALSE
       FRAME Panel-Frame:HIDDEN           = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME Panel-Frame
/* Query rebuild information for FRAME Panel-Frame
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME Panel-Frame */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK P-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN initializeObject.        
  &ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI P-Win  _DEFAULT-DISABLE
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
  HIDE FRAME Panel-Frame.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getWindowName P-Win 
PROCEDURE getWindowName :
/**
*   @desc  Procedure to retrieve the filename of the window  (wxxxxx.w)
*   @returns <code> file-name</code> Filename of windowprocedure
*/
  DEFINE VARIABLE hWin AS HANDLE NO-UNDO.

  ASSIGN hwin =  DYNAMIC-FUNCTION('getContainerSource':U).
  
  RETURN hWin:file-name.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetLink P-Win 
PROCEDURE resetLink :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER pcLink AS CHARACTER  NO-UNDO.
 
 DEFINE VARIABLE cActionList AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hTarget     AS HANDLE     NO-UNDO.
 DEFINE VARIABLE iAction     AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cAction     AS CHARACTER  NO-UNDO.

 cActionList = {fnarg linkActions pcLink}.
  
 IF pcLink <> '':U THEN
   hTarget     = {fnarg activeTarget ENTRY(1,pcLink,'-':U)}.
 ELSE 
   {get ContainerSource hTarget}.

 IF NOT VALID-HANDLE(hTarget) THEN
   RETURN.

 DO iAction = 1 TO NUM-ENTRIES(cActionList):
    cAction = ENTRY(iAction,cActionList).


 END.

 RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initializeMenu P-Win 
FUNCTION initializeMenu RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Create the menus for the toolbar 
    Notes: This function is defined locally, but will skip the default 
           behavior if there is a super defined AND it returns true.     
           buildMenu() is always called! so it should not be part of the 
           super procedure. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lOverridden AS LOG    NO-UNDO.

  /* Allow a super-procedure to override the default toolbar */
  lOverridden = SUPER() NO-ERROR.
  
  /* not (true) for unknown */
  IF NOT (lOverridden = TRUE) THEN
  DO:
    insertMenu("":U,"File,Navigation":U,no,?).
  
    insertMenu("File":U,
       "Add,Update,Copy,Delete,RULE,":U
    +  "Save,UndoChange,Reset,Cancel,RULE,Transaction,":U
    +  "RULE,Function,RULE,Exit":U,
        yes, /* expand children */
        ?).  
 END.
   
 /* build the menubar */
 buildMenu("").
  
 RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION initializeToolBar P-Win 
FUNCTION initializeToolBar RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Creates the toolbar for the toolbar 
    Notes: This function is defined locally, but will skip the default 
           behavior if there is a super defined AND it returns true.      
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lOverridden AS LOG    NO-UNDO.

  /* Allow a super-procedure to override the default toolbar */
  lOverridden = SUPER() NO-ERROR.
  
  /* not (true) for unknown */
  IF NOT (lOverridden = TRUE) THEN
  DO:
    createToolBar
     ("Tableio,RULE,Transaction,RULE,Navigation,RULE,Function,RULE").
  END.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

