&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS sObject 
/*------------------------------------------------------------------------

  File:

  Description: from SMART.W - Template for basic ADM2 SmartObject

  Author:
  Created:

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

/* Local Variable Definitions ---                                       */

{src/adm2/globals.i}


{src/adm2/widgetprto.i}

  DEFINE VARIABLE glDBConfigDefault AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE glDBAllowUnreg    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE gcDBPermittedUnregistered AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE glUnset           AS LOGICAL    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartObject
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS lConfigDefault lAllowUnreg btnAdd fiSessType ~
btnMoveUp cPermittedUnregistered btnMoveDown btnRemove btnApply btnReset ~
RECT-1 RECT-2 RECT-3 
&Scoped-Define DISPLAYED-OBJECTS lConfigDefault lAllowUnreg fiSessType ~
cPermittedUnregistered 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON btnAdd 
     LABEL "A&dd" 
     CONTEXT-HELP-ID 0
     SIZE 15 BY 1.14.

DEFINE BUTTON btnApply 
     LABEL "&Apply" 
     CONTEXT-HELP-ID 0
     SIZE 15 BY 1.14.

DEFINE BUTTON btnMoveDown 
     LABEL "Move &Down" 
     CONTEXT-HELP-ID 0
     SIZE 15 BY 1.14.

DEFINE BUTTON btnMoveUp 
     LABEL "Move &Up" 
     CONTEXT-HELP-ID 0
     SIZE 15 BY 1.14.

DEFINE BUTTON btnRemove 
     LABEL "Remo&ve" 
     CONTEXT-HELP-ID 0
     SIZE 15 BY 1.14.

DEFINE BUTTON btnReset 
     LABEL "&Reset" 
     CONTEXT-HELP-ID 0
     SIZE 15 BY 1.14.

DEFINE VARIABLE fiSessType AS CHARACTER FORMAT "X(50)":U 
     LABEL "Session Type" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 57.2 BY 1 NO-UNDO.

DEFINE VARIABLE lConfigDefault AS LOGICAL 
     CONTEXT-HELP-ID 0
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Default to Config File", yes,
"Default to Database", no
     SIZE 26 BY 2.57 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 58.4 BY 7.43.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 89.4 BY 9.71.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 89.2 BY 3.33.

DEFINE VARIABLE cPermittedUnregistered AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL 
     SIZE 56 BY 6.67 NO-UNDO.

DEFINE VARIABLE lAllowUnreg AS LOGICAL INITIAL no 
     LABEL "Allow Unregistered Session Types" 
     VIEW-AS TOGGLE-BOX
     SIZE 38.6 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     lConfigDefault AT ROW 1.95 COL 32.2 NO-LABEL
     lAllowUnreg AT ROW 4.81 COL 3.4
     btnAdd AT ROW 5.67 COL 74.6
     fiSessType AT ROW 5.81 COL 14.6 COLON-ALIGNED
     btnMoveUp AT ROW 7 COL 74.6
     cPermittedUnregistered AT ROW 7.62 COL 16.6 NO-LABEL
     btnMoveDown AT ROW 8.33 COL 74.6
     btnRemove AT ROW 9.71 COL 74.6
     btnApply AT ROW 15.05 COL 57.6
     btnReset AT ROW 15.05 COL 74.4
     RECT-1 AT ROW 7.24 COL 15.4
     RECT-2 AT ROW 5.19 COL 1.6
     RECT-3 AT ROW 1.38 COL 1.8
     "Permitted Unregistered Session Types:" VIEW-AS TEXT
          SIZE 37.6 BY .62 AT ROW 6.91 COL 16.6
     "Session Types with no configuration_source:" VIEW-AS TEXT
          SIZE 43.2 BY .62 AT ROW 1.1 COL 2.6
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
         HEIGHT             = 15.29
         WIDTH              = 90.6.
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

&Scoped-define SELF-NAME btnAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnAdd sObject
ON CHOOSE OF btnAdd IN FRAME F-Main /* Add */
DO:
  RUN addSessType.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnApply
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnApply sObject
ON CHOOSE OF btnApply IN FRAME F-Main /* Apply */
DO:
  RUN applyChanges.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnMoveDown
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnMoveDown sObject
ON CHOOSE OF btnMoveDown IN FRAME F-Main /* Move Down */
DO:
  RUN moveEntry("DOWN":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnMoveUp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnMoveUp sObject
ON CHOOSE OF btnMoveUp IN FRAME F-Main /* Move Up */
DO:
  RUN moveEntry("UP":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnRemove
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnRemove sObject
ON CHOOSE OF btnRemove IN FRAME F-Main /* Remove */
DO:
  RUN removeSessType.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnReset
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnReset sObject
ON CHOOSE OF btnReset IN FRAME F-Main /* Reset */
DO:
  RUN resetScreen.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cPermittedUnregistered
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cPermittedUnregistered sObject
ON VALUE-CHANGED OF cPermittedUnregistered IN FRAME F-Main
DO:
  RUN setState.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiSessType
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiSessType sObject
ON VALUE-CHANGED OF fiSessType IN FRAME F-Main /* Session Type */
DO:
  RUN setState.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lAllowUnreg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lAllowUnreg sObject
ON VALUE-CHANGED OF lAllowUnreg IN FRAME F-Main /* Allow Unregistered Session Types */
DO:
  RUN setState.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lConfigDefault
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lConfigDefault sObject
ON VALUE-CHANGED OF lConfigDefault IN FRAME F-Main
DO:
  RUN setState.
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addSessType sObject 
PROCEDURE addSessType :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iCount AS INTEGER    NO-UNDO.
  DO WITH FRAME {&FRAME-NAME}:
    iCount = cPermittedUnregistered:LOOKUP(fiSessType:SCREEN-VALUE).
    IF iCount = ? OR
       iCount = 0 THEN
      cPermittedUnregistered:ADD-LAST(fiSessType:SCREEN-VALUE).
    fiSessType:SCREEN-VALUE = "":U.
    RUN setState.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyChanges sObject 
PROCEDURE applyChanges :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      lConfigDefault
      lAllowUnreg
      cPermittedUnregistered
      .
    ASSIGN
      glDBConfigDefault = lConfigDefault
      glDBAllowUnreg    = lAllowUnreg
      gcDBPermittedUnregistered = cPermittedUnregistered:LIST-ITEMS 
      .
    RUN setSessTypeOverrideInfo IN gshSessionManager
      (INPUT glDBConfigDefault,
       INPUT glDBAllowUnreg,
       INPUT gcDBPermittedUnregistered) NO-ERROR.
    {checkerr.i &display-error = YES}

  END.
  RUN resetScreen.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject sObject 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

  DO WITH FRAME {&FRAME-NAME}:
    RUN getSessTypeOverrideInfo IN gshSessionManager
      (OUTPUT glDBConfigDefault,
       OUTPUT glDBAllowUnreg,
       OUTPUT gcDBPermittedUnregistered).
    RUN resetScreen.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE moveEntry sObject 
PROCEDURE moveEntry :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcDirection AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE iCurrPos AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iNewPos  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cRepVal  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCurrVal AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cList    AS CHARACTER  NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    cList    = cPermittedUnregistered:LIST-ITEMS.
    iCurrPos = LOOKUP(cPermittedUnregistered:SCREEN-VALUE, cList).
    IF pcDirection = "UP":U THEN
      iNewPos  = iCurrPos - 1.
    ELSE
      iNewPos  = iCurrPos + 1.
    cRepVal  = ENTRY(iNewPos,cList).
    cCurrVal = cPermittedUnregistered:SCREEN-VALUE.
    ENTRY(iCurrPos,cList) = cRepVal.
    ENTRY(iNewPos,cList)  = cCurrVal.
    cPermittedUnregistered:LIST-ITEMS = cList.
    cPermittedUnregistered:SCREEN-VALUE = cCurrVal.
  END.
  RUN setState.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE removeSessType sObject 
PROCEDURE removeSessType :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    cPermittedUnregistered:DELETE(cPermittedUnregistered:SCREEN-VALUE).
  END.
  RUN setState.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetScreen sObject 
PROCEDURE resetScreen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    IF glDBConfigDefault = ?          AND
       glDBAllowUnreg    = ?          AND
       gcDBPermittedUnregistered = ?  THEN
      glUnset = YES.
    ELSE
      glUnset = NO.

    ASSIGN
      fiSessType:SCREEN-VALUE = "":U
      cPermittedUnregistered = "":U
      cPermittedUnregistered:SCREEN-VALUE = "":U
      .
    ASSIGN
      lConfigDefault = (IF glDBConfigDefault = ? THEN YES ELSE glDBConfigDefault)
      lAllowUnreg    = (IF glDBAllowUnreg = ? THEN YES ELSE glDBAllowUnreg)
      cPermittedUnregistered:LIST-ITEMS = (IF gcDBPermittedUnregistered = ? THEN "*":U ELSE gcDBPermittedUnregistered)
      .
    DISPLAY
      lConfigDefault
      lAllowUnreg
      cPermittedUnregistered
    .
  END.
  RUN setState.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setState sObject 
PROCEDURE setState :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      lConfigDefault
      lAllowUnreg
      cPermittedUnregistered
      .
    IF NOT lAllowUnreg:INPUT-VALUE THEN
      fiSessType:SCREEN-VALUE = "":U.
    IF VALID-HANDLE(FOCUS) THEN
    DO:
      IF FOCUS:HANDLE <> fiSessType:HANDLE THEN
        fiSessType:SENSITIVE              = lAllowUnreg.
    END.
    ELSE
      fiSessType:SENSITIVE              = lAllowUnreg.
    ASSIGN
      cPermittedUnregistered:SENSITIVE  = lAllowUnreg
      btnAdd:SENSITIVE                  = (lAllowUnreg AND fiSessType:SCREEN-VALUE <> "":U)
      btnRemove:SENSITIVE               = (lAllowUnreg AND cPermittedUnregistered:SCREEN-VALUE <> ? AND cPermittedUnregistered:SCREEN-VALUE <> "":U)
      btnMoveUp:SENSITIVE               = (cPermittedUnregistered:SCREEN-VALUE <> ? AND cPermittedUnregistered:LOOKUP(cPermittedUnregistered:SCREEN-VALUE) > 1)
      btnMoveDown:SENSITIVE             = (cPermittedUnregistered:SCREEN-VALUE <> ? AND cPermittedUnregistered:LOOKUP(cPermittedUnregistered:SCREEN-VALUE) < NUM-ENTRIES(cPermittedUnregistered:LIST-ITEMS))
      btnApply:SENSITIVE                = glUnset OR
                                          (lConfigDefault <> (IF glDBConfigDefault = ? THEN YES ELSE glDBConfigDefault)
                                          OR lAllowUnreg <> (IF glDBAllowUnreg = ? THEN YES ELSE glDBAllowUnreg)
                                          OR cPermittedUnregistered:LIST-ITEMS <>  gcDBPermittedUnregistered)
      btnReset:SENSITIVE                = btnApply:SENSITIVE
    .                                                                
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

