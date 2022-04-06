&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
/* Procedure Description
"This SmartPanel sends navigation messages
to its NAVIGATION-TARGET. Its buttons have
text labels and are arranged horizontally."
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS P-Win 
/***********************************************************************
* Copyright (C) 2000,2007 by Progress Software Corporation. All rights *
* reserved. Prior versions of this work may contain portions           *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*------------------------------------------------------------------------

  File: pnavlbl.w

  Description: new V9 version July 8, 1998

        This is the label version of the navigation SmartPanel.
        It sends navigation events to its NAVIGATION-TARGET(s),
        such is a SmartQuery.
 
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

  &GLOB ADM-Panel-Type Nav-Label

/* Tell smart.i to not exclude the default destroyObject */ 
&SCOPED-DEFINE include-destroyobject

/* This is the procedure to execute to set InstanceProperties at design time. */
&IF DEFINED (ADM-PROPERTY-DLG) = 0 &THEN
  &SCOP ADM-PROPERTY-DLG adm2/support/n-paneld.w
&ENDIF

/* Local Variable Definitions ---                                       */

/* The following variable is used whenever the smartpanel is sent an */
/* update state. The smartpanel must know whether it's updating so   */
/* that it can re-set itself properly when the paging mechanism is   */
/* used. Only pnstates.i references this variable.                   */
DEFINE VARIABLE updating      AS LOGICAL INIT FALSE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartPanel
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Navigation-Source

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Panel-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Btn-First Btn-Prev Btn-Next Btn-Last 

/* Custom List Definitions                                              */
/* Box-Rectangle,List-2,List-3,List-4,List-5,List-6                     */
&Scoped-define Box-Rectangle RECT-1 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNavigationTarget P-Win 
FUNCTION getNavigationTarget RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNavigationTargetEvents P-Win 
FUNCTION getNavigationTargetEvents RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setNavigationTarget P-Win 
FUNCTION setNavigationTarget RETURNS LOGICAL
  ( pcObject AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setNavigationTargetEvents P-Win 
FUNCTION setNavigationTargetEvents RETURNS LOGICAL
  ( pcEvents AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn-First 
     LABEL "&First" 
     SIZE 8 BY 1.29
     FONT 4.

DEFINE BUTTON Btn-Last 
     LABEL "&Last" 
     SIZE 8 BY 1.29
     FONT 4.

DEFINE BUTTON Btn-Next 
     LABEL "&Next" 
     SIZE 8 BY 1.29
     FONT 4.

DEFINE BUTTON Btn-Prev 
     LABEL "&Prev" 
     SIZE 8 BY 1.29
     FONT 4.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 34 BY 1.76.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Panel-Frame
     Btn-First AT ROW 1.29 COL 2  WIDGET-ID 2
     Btn-Prev  AT ROW 1.29 COL 10 WIDGET-ID 4
     Btn-Next  AT ROW 1.29 COL 18 WIDGET-ID 6
     Btn-Last  AT ROW 1.29 COL 26 WIDGET-ID 8
     RECT-1    AT ROW 1    COL 1  WIDGET-ID 10
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
  CREATE WINDOW P-Win ASSIGN
         HEIGHT             = 2.1
         WIDTH              = 42.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB P-Win 
/* ************************* Included-Libraries *********************** */

{src/adm2/panel.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW P-Win
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

&Scoped-define SELF-NAME Btn-First
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-First P-Win
ON CHOOSE OF Btn-First IN FRAME Panel-Frame /* First */
DO:
    PUBLISH 'fetchFirst':U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-Last
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-Last P-Win
ON CHOOSE OF Btn-Last IN FRAME Panel-Frame /* Last */
DO:
     PUBLISH 'fetchLast':U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-Next
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-Next P-Win
ON CHOOSE OF Btn-Next IN FRAME Panel-Frame /* Next */
DO:
  PUBLISH 'fetchNext':U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn-Prev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn-Prev P-Win
ON CHOOSE OF Btn-Prev IN FRAME Panel-Frame /* Prev */
DO:
  PUBLISH 'fetchPrev':U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setButtons P-Win 
PROCEDURE setButtons :
/*------------------------------------------------------------------------------
  Purpose: Sets sensitivity of panel buttons based on record states.    
  Parameters:  new state name
  Notes:  DEPRECATED in the sense that the toolbar disabling/enabling 
          has been replaced by rule based state management. The procedure 
          is still callable and may still be called in odd cases.  
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcPanelState AS CHARACTER NO-UNDO.
  
  DO WITH FRAME Panel-Frame:
    CASE pcPanelState:
      WHEN 'disable-all':U THEN 
      DO:
  
        /* all the buttons are disabled, which might happen in the case of */
        /* only a single record available in a table.                      */

        &IF LOOKUP("Btn-First":U, "{&ENABLED-OBJECTS}":U," ":U) NE 0 &THEN
             Btn-First:SENSITIVE = NO.
        &ENDIF            
        &IF LOOKUP("Btn-Last":U, "{&ENABLED-OBJECTS}":U," ":U) NE 0 &THEN
             Btn-Last:SENSITIVE = NO.
        &ENDIF
        &IF LOOKUP("Btn-Prev":U, "{&ENABLED-OBJECTS}":U," ":U) NE 0 &THEN
             Btn-Prev:SENSITIVE = NO.
        &ENDIF
        &IF LOOKUP("Btn-Next":U, "{&ENABLED-OBJECTS}":U," ":U) NE 0 &THEN
             Btn-Next:SENSITIVE = NO.
        &ENDIF
      END. /* PanelState = disable-all */

      WHEN 'enable-all':U THEN 
      DO: 
        /* This was a next or prev-enable all */

        &IF LOOKUP("Btn-First":U, "{&ENABLED-OBJECTS}":U," ":U) NE 0 &THEN
             Btn-First:SENSITIVE = YES.
        &ENDIF     
        &IF LOOKUP("Btn-Last":U, "{&ENABLED-OBJECTS}":U," ":U) NE 0 &THEN
             Btn-Last:SENSITIVE = YES.
        &ENDIF
        &IF LOOKUP("Btn-Prev":U, "{&ENABLED-OBJECTS}":U," ":U) NE 0 &THEN
             Btn-Prev:SENSITIVE = YES.
        &ENDIF
        &IF LOOKUP("Btn-Next":U, "{&ENABLED-OBJECTS}":U," ":U) NE 0 &THEN
             Btn-Next:SENSITIVE = YES.
        &ENDIF
      END.
      WHEN 'first':U THEN
      DO:
        &IF LOOKUP("Btn-First":U, "{&ENABLED-OBJECTS}":U," ":U) NE 0 &THEN
          Btn-First:SENSITIVE = NO.
        &ENDIF
        &IF LOOKUP("Btn-Prev":U, "{&ENABLED-OBJECTS}":U," ":U) NE 0 &THEN
          Btn-Prev:SENSITIVE = NO.
        &ENDIF
        &IF LOOKUP("Btn-Next":U, "{&ENABLED-OBJECTS}":U," ":U) NE 0 &THEN
          Btn-Next:SENSITIVE = YES.
          &IF "{&WINDOW-SYSTEM}":U = "TTY":U &THEN
            APPLY "ENTRY":U TO Btn-Next.  /* Keep focus in the panel. */
          &ENDIF
        &ENDIF
        &IF LOOKUP("Btn-Last":U, "{&ENABLED-OBJECTS}":U," ":U) NE 0 &THEN
          Btn-Last:SENSITIVE = YES.
        &ENDIF

      END.  /* END 'first' */
      WHEN 'last':U THEN
      DO:                                                 /* "Last" */
        &IF LOOKUP("Btn-First":U, "{&ENABLED-OBJECTS}":U," ":U) NE 0 &THEN
           Btn-First:SENSITIVE = YES.
        &ENDIF
        &IF LOOKUP("Btn-Prev":U, "{&ENABLED-OBJECTS}":U," ":U) NE 0 &THEN
           Btn-Prev:SENSITIVE = YES.
           &IF "{&WINDOW-SYSTEM}":U = "TTY":U &THEN
             APPLY "ENTRY":U TO Btn-Prev.  /* Keep focus in the panel. */
           &ENDIF
        &ENDIF
        &IF LOOKUP("Btn-Next":U, "{&ENABLED-OBJECTS}":U," ":U) NE 0 &THEN
           Btn-Next:SENSITIVE = NO.
        &ENDIF
        &IF LOOKUP("Btn-Last":U, "{&ENABLED-OBJECTS}":U," ":U) NE 0 &THEN
           Btn-Last:SENSITIVE = NO.
        &ENDIF
      END.     /* END 'Last' */
      OTHERWISE RETURN "ADM-ERROR":U.           /* Unrecognized state value */
    END.         /* END CASE */
  END.           /* END DO WITH FRAME */            
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNavigationTarget P-Win 
FUNCTION getNavigationTarget RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns in character format the handle(s) of this object's
            Navigation-Target(s)
   Params:  none
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cTarget AS CHARACTER NO-UNDO.
  {get NavigationTarget cTarget}.
  RETURN cTarget.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNavigationTargetEvents P-Win 
FUNCTION getNavigationTargetEvents RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a comma-separated list of the events this object wants 
            to subscribe to in its NavigationTarget
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cEvents AS CHARACTER NO-UNDO.
  {get NavigationTargetEvents cEvents}.
  RETURN cEvents.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setNavigationTarget P-Win 
FUNCTION setNavigationTarget RETURNS LOGICAL
  ( pcObject AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the NavigationTarget link value.
   Params:  pcObject AS CHARACTER -- CHARACTER string form of the procedure
               handle(s) which should be made Navigation-Target(s)
    Notes:  Because the value can be a list, it should be changed using
              modifyListProperty
------------------------------------------------------------------------------*/

  {set NavigationTarget pcObject}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setNavigationTargetEvents P-Win 
FUNCTION setNavigationTargetEvents RETURNS LOGICAL
  ( pcEvents AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the list of events to subscribe to in the NavigationTarget.
   Params:  pcEvents AS CHARACTER -- CHARACTER string form of the event names.
    Notes:  Because the value can be a list, it should be changed using
              modifyListProperty
------------------------------------------------------------------------------*/

  {set NavigationTargetEvents pcEvents}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

