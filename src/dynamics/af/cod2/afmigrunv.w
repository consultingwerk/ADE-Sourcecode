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

  Author: Sunil Belgaonkar
  Created: 08/15/2003

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

DEFINE VARIABLE ghContainerSource           AS HANDLE NO-UNDO.
DEFINE VARIABLE ghRepositoryDesignManager   AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-3 buMigrate buCancel 
&Scoped-Define DISPLAYED-OBJECTS fiChar 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD updateStatus sObject 
FUNCTION updateStatus RETURNS LOGICAL
  ( INPUT phStatus AS HANDLE,
    INPUT pcLine AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON buCancel 
     IMAGE-UP FILE "ry/img/stop.gif":U
     LABEL "&Cancel" 
     SIZE 5 BY 1.19 TOOLTIP "Press to cancel migration process"
     BGCOLOR 8 .

DEFINE BUTTON buMigrate 
     IMAGE-UP FILE "ry/img/active.gif":U
     LABEL "&Migrate" 
     SIZE 5 BY 1.19 TOOLTIP "Migrate widget-based translation with selected options"
     BGCOLOR 8 .

DEFINE VARIABLE fiChar AS CHARACTER FORMAT "X(50)":U INITIAL "Migrate:" 
     CONTEXT-HELP-ID 0
      VIEW-AS TEXT 
     SIZE 68 BY .71 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 117 BY 1.67.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     buMigrate AT ROW 1.71 COL 112
     buCancel AT ROW 1.71 COL 112
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
         WIDTH              = 117.4.
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
   NOT-VISIBLE Size-to-Fit                                              */
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
  PUBLISH "cancelMigration" FROM ghContainerSource.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buMigrate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buMigrate sObject
ON CHOOSE OF buMigrate IN FRAME F-Main /* Migrate */
DO:
  DEFINE VARIABLE cButton        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAnswer        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hEntityBrowse  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lTestMigration AS LOGICAL    NO-UNDO.

  PUBLISH "getEntityBrowse":U FROM ghContainerSource (OUTPUT hEntityBrowse).
  PUBLISH "getTestMigration":U FROM ghContainerSource (OUTPUT lTestMigration).

  IF hEntityBrowse:NUM-SELECTED-ROWS = 0 THEN
  DO:
      RUN showMessages IN gshSessionManager (INPUT "No entities were selected for migration.",
                                       INPUT "ERR":U,
                                       INPUT "OK":U,
                                       INPUT "OK":U,
                                       INPUT "OK":U,
                                       INPUT "Migrate Widget Translation",
                                       INPUT YES,
                                       INPUT ?,
                                       OUTPUT cButton).
      RETURN.
  END.

  ASSIGN buMigrate:HIDDEN    IN FRAME {&FRAME-NAME} = TRUE
         buCancel:HIDDEN     IN FRAME {&FRAME-NAME} = FALSE.

  ASSIGN ERROR-STATUS:ERROR = FALSE.
  RUN askQuestion IN gshSessionManager ( 
        INPUT "Do you wish to continue and " 
              + (IF lTestMigration THEN "test the migration of" ELSE "migrate")
              + " widget-based translations for the selected entities?",
                                       INPUT "&Yes,&No":U,     /* button list */
                                       INPUT "&No":U,         /* default */
                                       INPUT "&No":U,          /* cancel */
                                       INPUT "Migrate Widget Translation":U, /* title */
                                       INPUT "":U,             /* datatype */
                                       INPUT "":U,             /* format */
                                       INPUT-OUTPUT cAnswer,   /* answer */
                                       OUTPUT cButton          /* button pressed */ ).

  IF cButton = "&Yes":U OR cButton = "Yes":U THEN
  DO:
    RUN selectPage IN ghContainerSource (2).
    RUN migrateTranslations.
  END.

  ASSIGN buMigrate:HIDDEN    IN FRAME {&FRAME-NAME} = FALSE
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
    fiChar:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = "Migrate using selected entities:".
/*
  DYNAMIC-FUNCTION("disablePagesInFolder":U IN ghContainerSource, INPUT "2":U).
 */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE migrateTranslations sObject 
PROCEDURE migrateTranslations :
/*------------------------------------------------------------------------------
  Purpose:     This procedure is the control program that will migrate the 
               widget-based translation for the selected entities
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hStatus       AS HANDLE      NO-UNDO.
  DEFINE VARIABLE cError        AS CHARACTER   NO-UNDO.
 
  PUBLISH "getLogEditorHandle":U FROM ghContainerSource (OUTPUT hStatus).
  PUBLISH "runMigration" FROM ghContainerSource (INPUT hStatus).

  IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN
  DO:
     cError = ERROR-STATUS:GET-MESSAGE(1) + "~n" + RETURN-VALUE.
     MESSAGE "Error in migration of widget-based translation" cError VIEW-AS ALERT-BOX INFO BUTTONS OK.
     updateStatus(hStatus, "ERROR in migration of widget-based translation") NO-ERROR.
     updateStatus(hStatus, cError) NO-ERROR.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION updateStatus sObject 
FUNCTION updateStatus RETURNS LOGICAL
  ( INPUT phStatus AS HANDLE,
    INPUT pcLine AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  This function appends the status in the status window.
    Notes:  Input - phStatus - The handle to the status Editor widget
                  - pcLine - the contents to be displayed.
------------------------------------------------------------------------------*/
  /* We don't want the editor blowing any limits */
  IF NOT VALID-HANDLE(phStatus) THEN
    RETURN FALSE.

  IF LENGTH(phStatus:SCREEN-VALUE) > 30000 THEN
    ASSIGN phStatus:SCREEN-VALUE = "":U.

  IF phStatus:SCREEN-VALUE = "":U THEN
    ASSIGN phStatus:SCREEN-VALUE = pcLine.
  ELSE
    ASSIGN phStatus:SCREEN-VALUE = phStatus:SCREEN-VALUE + CHR(10) + pcLine.

  phStatus:MOVE-TO-EOF().

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

