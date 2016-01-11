&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS sObject 
/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------

  File: ryclcrunv.w 

  Description: This file is the main control viewer for the Client Cache tool.

  Author: Edsel Garcia
  Created: 11/05/2004

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
&scop object-name       ryclasscacherunv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/*  object identifying preprocessor */
&glob   astra2-staticSmartObject yes
{src/adm2/globals.i}

/* Temp-table definitions for ttClass temp table  */
{ ry/app/ryobjretri.i }

DEFINE VARIABLE ghContainerSource           AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghRepositoryDesignManager   AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghToolbarHandle             AS HANDLE     NO-UNDO.
DEFINE VARIABLE gcTargets                   AS CHARACTER  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-3 buCancel buGenerate 
&Scoped-Define DISPLAYED-OBJECTS fiChar 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON buCancel 
     IMAGE-UP FILE "ry/img/stop.gif":U
     LABEL "&Cancel" 
     SIZE 5 BY 1.19 TOOLTIP "Press to cancel generation process"
     BGCOLOR 8 .

DEFINE BUTTON buGenerate 
     IMAGE-UP FILE "ry/img/active.gif":U
     LABEL "&Generate" 
     SIZE 5 BY 1.19 TOOLTIP "Generate 4GL procedures with selected options"
     BGCOLOR 8 .

DEFINE VARIABLE fiChar AS CHARACTER FORMAT "X(256)":U INITIAL "Generate" 
     CONTEXT-HELP-ID 0
      VIEW-AS TEXT 
     SIZE 131 BY .71 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 144 BY 1.67.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     buCancel AT ROW 1.71 COL 138.8
     buGenerate AT ROW 1.71 COL 138.8
     fiChar AT ROW 1.95 COL 1 COLON-ALIGNED NO-LABEL
     RECT-3 AT ROW 1.48 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartObject
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
  CREATE WINDOW sObject ASSIGN
         HEIGHT             = 2.19
         WIDTH              = 145.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB sObject 
/* ************************* Included-Libraries *********************** */

{src/adm2/visual.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW sObject
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN fiChar IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       fiChar:READ-ONLY IN FRAME F-Main        = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME buCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buCancel sObject
ON CHOOSE OF buCancel IN FRAME F-Main /* Cancel */
DO:
  PUBLISH "cancelGeneration" FROM ghContainerSource.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buGenerate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buGenerate sObject
ON CHOOSE OF buGenerate IN FRAME F-Main /* Generate */
DO:
  DEFINE VARIABLE cButton        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAnswer        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessage       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hEntityBrowse  AS HANDLE     NO-UNDO.

  PUBLISH "getEntityBrowse":U FROM ghContainerSource (OUTPUT hEntityBrowse).

  IF hEntityBrowse:NUM-SELECTED-ROWS = 0 THEN
  DO:
      RUN showMessages IN gshSessionManager (INPUT "No objects were selected for generation.",
                                       INPUT "ERR":U,
                                       INPUT "OK":U,
                                       INPUT "OK":U,
                                       INPUT "OK":U,
                                       INPUT "Generate 4GL Programs",
                                       INPUT YES,
                                       INPUT ?,
                                       OUTPUT cButton).
      RETURN.
  END.

  PUBLISH "validateGeneratePage":U FROM ghContainerSource.
  cMessage = RETURN-VALUE.
  IF cMessage > "" THEN
  DO:
      RUN selectPage IN ghContainerSource (3).
      RUN showMessages IN gshSessionManager (INPUT cMessage,
                                       INPUT "ERR":U,
                                       INPUT "OK":U,
                                       INPUT "OK":U,
                                       INPUT "OK":U,
                                       INPUT "Generate 4GL Programs",
                                       INPUT YES,
                                       INPUT ?,
                                       OUTPUT cButton).
      RETURN.
  END.

  ASSIGN buGenerate:HIDDEN    IN FRAME {&FRAME-NAME} = TRUE
         buCancel:HIDDEN     IN FRAME {&FRAME-NAME} = FALSE.

  ASSIGN ERROR-STATUS:ERROR = FALSE.
  RUN askQuestion IN gshSessionManager ( 
        INPUT "Do you wish to continue and generate 4GL programs for the selected objects?",
                                       INPUT "&Yes,&No":U,     /* button list */
                                       INPUT "&No":U,         /* default */
                                       INPUT "&No":U,          /* cancel */
                                       INPUT "Generate 4GL Programs":U, /* title */
                                       INPUT "":U,             /* datatype */
                                       INPUT "":U,             /* format */
                                       INPUT-OUTPUT cAnswer,   /* answer */
                                       OUTPUT cButton          /* button pressed */ ).

  IF cButton = "&Yes":U OR cButton = "Yes":U THEN
  DO:
    RUN disableWindow.
    RUN generate4GLPrograms.
    RUN enableWindow.
  END.

  ASSIGN buGenerate:HIDDEN    IN FRAME {&FRAME-NAME} = FALSE
         buCancel:HIDDEN     IN FRAME {&FRAME-NAME} = TRUE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK sObject 


/* ***************************  Main Block  *************************** */

/* If testing in the UIB, initialize the SmartObject. */  
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
  RUN initializeObject.
&ENDIF

ASSIGN ERROR-STATUS:ERROR = FALSE.
ASSIGN ghRepositoryDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U).
IF (ERROR-STATUS:ERROR) THEN
  RETURN.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disableWindow sObject 
PROCEDURE disableWindow :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE h     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iLoop AS INTEGER    NO-UNDO.

  /* Disable toolbar object */
  ghToolbarHandle = DYNAMIC-FUNCTION("getContainerToolbarSource":U IN ghContainerSource).
  IF VALID-HANDLE(ghToolbarHandle) THEN
      DYNAMIC-FUNCTION("sensitizeActions":U IN ghToolbarHandle, "txtexit,txthelp":U, FALSE) NO-ERROR.

  /* Disable container targets */
  gcTargets = DYNAMIC-FUNCTION("linkHandles":U IN ghContainerSource, "Container-Target":U) NO-ERROR.
  DO iLoop = 1 TO NUM-ENTRIES(gcTargets):
      h = WIDGET-HANDLE(ENTRY(iLoop, gcTargets)).
      IF h <> THIS-PROCEDURE THEN
          RUN disableObject IN h NO-ERROR.
  END.

  /* Disable folder pages */
  PUBLISH "disableFolderPage":U FROM ghContainerSource (1).
  PUBLISH "disableFolderPage":U FROM ghContainerSource (2).
  PUBLISH "disableFolderPage":U FROM ghContainerSource (3).

  /* Disable menubar */
  THIS-PROCEDURE:CURRENT-WINDOW:MENU-BAR:SENSITIVE = FALSE.

  /* Set mouse pointers */
  THIS-PROCEDURE:CURRENT-WINDOW:LOAD-MOUSE-POINTER("APPSTARTING":U).
  buCancel:LOAD-MOUSE-POINTER("ARROW":U) IN FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI sObject  _DEFAULT-DISABLE
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
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableWindow sObject 
PROCEDURE enableWindow :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Uses local variables ghToolbarHandle and gcTargets set by disableWindow
------------------------------------------------------------------------------*/
  DEFINE VARIABLE h     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iLoop AS INTEGER    NO-UNDO.

  /* Enable toolbar object */
  IF VALID-HANDLE(ghToolbarHandle) THEN
      DYNAMIC-FUNCTION("sensitizeActions":U IN ghToolbarHandle, "txtexit,txthelp":U, TRUE) NO-ERROR.

  /* Enable container targets */
  DO iLoop = 1 TO NUM-ENTRIES(gcTargets):
      h = WIDGET-HANDLE(ENTRY(iLoop, gcTargets)).
      RUN enableObject IN h NO-ERROR.
  END.

  /* Enable folder pages */
  PUBLISH "enableFolderPage":U FROM ghContainerSource (1).
  PUBLISH "enableFolderPage":U FROM ghContainerSource (2).
  PUBLISH "enableFolderPage":U FROM ghContainerSource (3).

  /* Enable menubar */
  THIS-PROCEDURE:CURRENT-WINDOW:MENU-BAR:SENSITIVE = TRUE.

  /* Set mouse pointers */
  THIS-PROCEDURE:CURRENT-WINDOW:LOAD-MOUSE-POINTER("ARROW":U).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generate4GLPrograms sObject 
PROCEDURE generate4GLPrograms :
/*------------------------------------------------------------------------------
  Purpose:     This procedure is the control program that will generate the 
               static 4GL objects for the selected objects
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cError        AS CHARACTER   NO-UNDO.
 
  PUBLISH "runGeneration" FROM ghContainerSource.

  IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN
  DO:
     cError = ERROR-STATUS:GET-MESSAGE(1) + "~n" + RETURN-VALUE.
     MESSAGE "Error in generation of 4GL programs" cError VIEW-AS ALERT-BOX INFO BUTTONS OK.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject sObject 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.
  ASSIGN
    buCancel:HIDDEN      IN FRAME {&FRAME-NAME} = YES
    fiChar:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = "Generate 4GL using selected objects".

  IF VALID-HANDLE(ghContainerSource) THEN
  DO:
      SUBSCRIBE TO "updateStatus":U  IN ghContainerSource.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkStateHandler sObject 
PROCEDURE linkStateHandler :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcState  AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER phObject AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER pcLink   AS CHARACTER NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT pcState, INPUT phObject, INPUT pcLink).

  /* Set the handle of the container source immediately upon making the link */
  IF pcLink = "ContainerSource":U AND pcState = "Add":U THEN
     ASSIGN ghContainerSource = phObject.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateStatus sObject 
PROCEDURE updateStatus :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcStatus  AS CHARACTER NO-UNDO.

  fiChar:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = pcStatus.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

