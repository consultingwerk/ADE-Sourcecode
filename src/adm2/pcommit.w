&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
/* Procedure Description
"This SmartPanel sends update, add, 
copy, reset, delete, and cancel messages 
to its TABLEIO-TARGET. "
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-WIn 
/***********************************************************************
* Copyright (C) 2000,2007 by Progress Software Corporation. All rights *
* reserved. Prior versions of this work may contain portions           *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*------------------------------------------------------------------------

  File: pCommit.w

        Version 9 Commit/Undo Panel.
        July 8, 1998
        This SmartPanel allows multiple record changes to be
        Committed to the database or Undone together as a
        single transaction. It uses the Commit link
        to communicate with SmartDataObjects.

  Input Parameters:
      <none>

  Output Parameters:
      <none>

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

/* Parameters Definitions ---                                           */

  &GLOB ADM-Panel-Type Commit

/* Tell smart.i to not exclude the default destroyObject */ 
&SCOPED-DEFINE include-destroyobject

/* This is the procedure to execute to set InstanceProperties at design time. 
   NOTE: Should there be one for this object? */
&IF DEFINED (ADM-PROPERTY-DLG) = 0 &THEN
  &SCOP ADM-PROPERTY-DLG 
&ENDIF

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartPanel
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Commit-Source

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Panel-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Btn-Commit Btn-Undo 

/* Custom List Definitions                                              */
/* Box-Rectangle,List-2,List-3,List-4,List-5,List-6                     */
&Scoped-define Box-Rectangle RECT-1 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCommitTarget C-WIn 
FUNCTION getCommitTarget RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCommitTargetEvents C-WIn 
FUNCTION getCommitTargetEvents RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCommitTarget C-WIn 
FUNCTION setCommitTarget RETURNS LOGICAL
  ( pcObject AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCommitTargetEvents C-WIn 
FUNCTION setCommitTargetEvents RETURNS LOGICAL
  ( pcEvents AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn-Commit 
     LABEL "Co&mmit" 
     SIZE 9 BY 1.33
     FONT 4.

DEFINE BUTTON Btn-Undo 
     LABEL "&Undo" 
     SIZE 9 BY 1.33
     FONT 4.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 20 BY 1.76.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Panel-Frame
     Btn-Commit AT ROW 1.33 COL 2  WIDGET-ID 2
     Btn-Undo   AT ROW 1.33 COL 11 WIDGET-ID 4 
     RECT-1     AT ROW 1 COL 1     WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY NO-HELP 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartPanel
   Allow: Basic
   Frames: 1
   Add Fields to: NEITHER
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
  CREATE WINDOW C-WIn ASSIGN
         HEIGHT             = 1.76
         WIDTH              = 42.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB C-WIn 
/* ************************* Included-Libraries *********************** */

{src/adm2/panel.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-WIn
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME Panel-Frame
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME Panel-Frame:SCROLLABLE       = FALSE
       FRAME Panel-Frame:HIDDEN           = TRUE.

/* SETTINGS FOR RECTANGLE RECT-1 IN FRAME Panel-Frame
   NO-ENABLE 1                                                          */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME Panel-Frame
/* Query rebuild information for FRAME Panel-Frame
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME Panel-Frame */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Btn-Commit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-Commit C-WIn
ON CHOOSE OF Btn-Commit IN FRAME Panel-Frame /* Commit */
DO: 
  PUBLISH 'commitTransaction':U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-Undo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-Undo C-WIn
ON CHOOSE OF Btn-Undo IN FRAME Panel-Frame /* Undo */
DO:
  PUBLISH 'undoTransaction':U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-WIn 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN initializeObject.        
  &ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-WIn  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowObjectState C-WIn 
PROCEDURE rowObjectState :
/*------------------------------------------------------------------------------
  Purpose:     published from Commit-Target to tell the panel when to enable
               itself (when there are uncommitted changes) and disable itself
               (when those changes are committed or undone).
  Parameters:  INPUT pcState AS CHARACTER - 'NoUpdates' or 'RowUpdated'
  Notes:       This could be a property, but for now we just check the state
               of the Commit button to see if we're already enabled/disabled. 
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcState AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cCommitTargetState AS CHARACTER  NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    IF pcState = 'NoUpdates':U AND Btn-Commit:SENSITIVE = yes THEN
      RUN setButtons('disable-all':U).
    ELSE IF pcState = 'RowUpdated':U AND Btn-Commit:SENSITIVE = no THEN
    DO:
      /* Check Commit-Target to make sure it is in the right state. */
      cCommitTargetState = DYNAMIC-FUNCTION("getRowObjectState"
                             IN WIDGET-HANDLE(getCommitTarget())) NO-ERROR.
      IF cCommitTargetState = "RowUpdated":U THEN
        RUN setButtons('enable-all':U).
    END.
  END.    /* END DO WITH FRAME */
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setButtons C-WIn 
PROCEDURE setButtons :
/*------------------------------------------------------------------------------
  Purpose: Sets the sensitivity of the panel's buttons depending upon what
           sort of action is occuring to the COMMIT-TARGET of the panel.
  Parameters:  Character string that denotes which action to set the button
               sensitivities.               
               The values are: enable-all - enable both buttons (when a row has
                                            been changed in the Target)
                               disable-all - disable both buttons (when Commit or
                                             undo is pressed.
  Notes:    DEPRECATED in the sense that the toolbar disabling/enabling 
            has been replaced by rule based state management. The procedure 
            is still callable and may still be called in odd cases.                                                        
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcPanelState AS CHARACTER NO-UNDO.

  DO WITH FRAME Panel-Frame:
    IF pcPanelState = 'disable-all':U THEN 
      ASSIGN Btn-Commit:SENSITIVE = NO 
             Btn-Undo:SENSITIVE   = NO.
    ELSE IF pcPanelState = 'enable-all':U THEN 
      ASSIGN Btn-Commit:SENSITIVE = YES 
             Btn-Undo:SENSITIVE   = YES.

  END. /* END DO WITH FRAME */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCommitTarget C-WIn 
FUNCTION getCommitTarget RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns in character format the handle(s) of this object's
            Commit-Target(s)
   Params:  none
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cTarget AS CHARACTER NO-UNDO.
  {get CommitTarget cTarget}.
  RETURN cTarget.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCommitTargetEvents C-WIn 
FUNCTION getCommitTargetEvents RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a comma-separated list of the events this object wants 
            to subscribe to in its CommitTarget
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cEvents AS CHARACTER NO-UNDO.
  {get CommitTargetEvents cEvents}.
  RETURN cEvents.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCommitTarget C-WIn 
FUNCTION setCommitTarget RETURNS LOGICAL
  ( pcObject AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the CommitTarget link value.
   Params:  pcObject AS CHARACTER -- CHARACTER string form of the procedure
               handle(s) which should be made Commit-Target(s)
    Notes:  Because the value can be a list, it should be changed using
              modifyListProperty
------------------------------------------------------------------------------*/

  {set CommitTarget pcObject}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCommitTargetEvents C-WIn 
FUNCTION setCommitTargetEvents RETURNS LOGICAL
  ( pcEvents AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the list of events to subscribe to in the CommitTarget.
   Params:  pcEvents AS CHARACTER -- CHARACTER string form of the event names.
    Notes:  Because the value can be a list, it should be changed using
              modifyListProperty
------------------------------------------------------------------------------*/

  {set CommitTargetEvents pcEvents}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

