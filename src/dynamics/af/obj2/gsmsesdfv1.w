&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS sObject 
/*------------------------------------------------------------------------

  File:

  Description: from FIELD.W - Template for ADM2 SmartDataField object

  Created: June 1999 -- Progress Version 9.1A

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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataField
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS raTimeoutUnits fiDays fiHours fiMinutes ~
RECT-2 
&Scoped-Define DISPLAYED-OBJECTS raTimeoutUnits fiDays fiHours fiMinutes 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataValue sObject 
FUNCTION getDataValue RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD resetScreenValues sObject 
FUNCTION resetScreenValues RETURNS LOGICAL PRIVATE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataValue sObject 
FUNCTION setDataValue RETURNS LOGICAL
  ( cValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSelectedField sObject 
FUNCTION setSelectedField RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE fiDays AS INTEGER FORMAT ">>>":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12.2 BY 1 NO-UNDO.

DEFINE VARIABLE fiHours AS INTEGER FORMAT ">>>":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12.2 BY 1 NO-UNDO.

DEFINE VARIABLE fiMinutes AS INTEGER FORMAT ">>>":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 12.2 BY 1 NO-UNDO.

DEFINE VARIABLE raTimeoutUnits AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Never", "Never",
"Days", "Days",
"Hours", "Hours",
"Minutes", "Minutes"
     SIZE 13.2 BY 4.38 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 30.4 BY 5.29.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     raTimeoutUnits AT ROW 1.95 COL 2.6 NO-LABEL
     fiDays AT ROW 3.1 COL 14 COLON-ALIGNED NO-LABEL
     fiHours AT ROW 4.24 COL 14 COLON-ALIGNED NO-LABEL
     fiMinutes AT ROW 5.38 COL 14 COLON-ALIGNED NO-LABEL
     RECT-2 AT ROW 1.52 COL 1
     "Inactivity timeout:" VIEW-AS TEXT
          SIZE 18 BY .62 AT ROW 1.19 COL 2.2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataField
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
         HEIGHT             = 6.57
         WIDTH              = 33.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB sObject 
/* ************************* Included-Libraries *********************** */

{src/adm2/field.i}

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

&Scoped-define SELF-NAME fiDays
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiDays sObject
ON VALUE-CHANGED OF fiDays IN FRAME F-Main
DO:
  {set DataModified TRUE}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiHours
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiHours sObject
ON VALUE-CHANGED OF fiHours IN FRAME F-Main
DO:
  {set DataModified TRUE}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiMinutes
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiMinutes sObject
ON VALUE-CHANGED OF fiMinutes IN FRAME F-Main
DO:
  {set DataModified TRUE}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME raTimeoutUnits
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL raTimeoutUnits sObject
ON VALUE-CHANGED OF raTimeoutUnits IN FRAME F-Main
DO:

  {set DataModified TRUE}.
  {fn resetScreenValues}.
  {fn setSelectedField}.  
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disableField sObject 
PROCEDURE disableField :
/*------------------------------------------------------------------------------
  Purpose:   Disable the field   
  Parameters:  <none>
  Notes:    SmartDataViewer:disableFields will call this for all Objects of type
            PROCEDURE that it encounters in the EnableFields Property.  
            The developer must add logic to disable the actual SmartField.    
------------------------------------------------------------------------------*/
   
   {set FieldEnabled FALSE}.
   DISABLE
      raTimeoutUnits
      fiDays
      fiHours
      fiMinutes
   WITH FRAME {&FRAME-NAME}.
   
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableField sObject 
PROCEDURE enableField :
/*------------------------------------------------------------------------------
  Purpose:   Enable the field   
  Parameters:  <none>
  Notes:    SmartDataViewer:enableFields will call this for all Objects of type
            PROCEDURE that it encounters in the EnableFields Property.  
            The developer must add logic to enable the SmartField.    
------------------------------------------------------------------------------*/
   
   {set FieldEnabled TRUE}.
   {fn setSelectedField}.  
   ENABLE raTimeoutUnits WITH FRAME {&FRAME-NAME}.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject sObject 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pidHeight AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER pidWidth  AS DECIMAL NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  /*                                                
  RUN SUPER( INPUT pidHeight, INPUT pidWidth).
  Commented out above line so that the super does not get run, and the
  widgets on this smartDataField do not get resized. This is a bug, where
  the fields on a smartDataField get resized to the max width of the frame 
  If this Procedure were to be deleted, then the super would run , producing
  the incorrect behaviour.
  */

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataValue sObject 
FUNCTION getDataValue RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the current value of the SmartDataField object.
   Params:  none
    Notes:  This function must be defined by the developer of the object
            to return its value.
------------------------------------------------------------------------------*/
 DEFINE VARIABLE dTimeOut         AS DECIMAL    NO-UNDO.
                     
  DO WITH FRAME {&FRAME-NAME}:
  
    CASE raTimeoutUnits:SCREEN-VALUE:
      
      WHEN "Days":U THEN
        ASSIGN dTimeout = DECIMAL(fiDays:SCREEN-VALUE).
      WHEN "Hours":U THEN
        ASSIGN dTimeout = DECIMAL(fiHours:SCREEN-VALUE) * 3600 / 100000.
      WHEN "Minutes":U THEN
        ASSIGN dTimeout = (DECIMAL(fiMinutes:SCREEN-VALUE) * 60) / 100000. 
      OTHERWISE
        ASSIGN dTimeout = 0.
    
    END CASE.
    
  END.
  
  RETURN STRING(dTimeout).   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION resetScreenValues sObject 
FUNCTION resetScreenValues RETURNS LOGICAL PRIVATE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: To reset the screen-values of the fill-in fields on this SDF 
    Notes:  
------------------------------------------------------------------------------*/
  
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      fiDays:SCREEN-VALUE     = "":U
      fiHours:SCREEN-VALUE    = "":U
      fiMinutes:SCREEN-VALUE  = "":U.
  END.
  
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataValue sObject 
FUNCTION setDataValue RETURNS LOGICAL
  ( cValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  This function receives the value for the SmartDataField and assigns it.
   Params:  The parameter and its datatype must be defined by the developer.
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE dTimeOut AS DECIMAL    NO-UNDO.
  
  {fn resetScreenValues}.
  ASSIGN dTimeOut = DECIMAL(cValue).
  DO WITH FRAME {&FRAME-NAME}:  
  
    IF dTimeOut = 0 OR dTimeOut = ? THEN
      ASSIGN 
        raTimeoutUnits:SCREEN-VALUE = "Never"
        fiDays:SCREEN-VALUE         = "".
    ELSE
    DO:
      IF dTimeOut >= 1 AND dTimeOut - TRUNC(dTimeout,0) = 0 THEN
        ASSIGN raTimeoutUnits:SCREEN-VALUE  = "Days"
               fiDays:SCREEN-VALUE          = STRING(INTEGER(dTimeout)).
      ELSE
      DO:
        ASSIGN dTimeOut = dTimeOut * 100000.
        IF (dTimeOut MOD 3600) = 0 THEN
          ASSIGN raTimeoutUnits:SCREEN-VALUE = "Hours"
                 fiHours:SCREEN-VALUE         = STRING(INTEGER(dTimeout / 3600)).
        ELSE
          ASSIGN raTimeoutUnits:SCREEN-VALUE  = "Minutes"
                 fiMinutes:SCREEN-VALUE       = STRING(INTEGER(dTimeout / 60)).
      END.
    END.
  END.
  {fn setSelectedField}.

  RETURN TRUE. /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSelectedField sObject 
FUNCTION setSelectedField RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: To set which fill-ins are sensitive depending on the Toggle Box value
    Notes:  
------------------------------------------------------------------------------*/
  
  IF {fn getFieldEnabled} THEN
  DO WITH FRAME {&FRAME-NAME}:
  
    CASE raTimeoutUnits:SCREEN-VALUE:
    
      WHEN "Never":U THEN
      DO:
        DISABLE fiDays
                fiHours
                fiMinutes.
      END.
          
      WHEN "Days":U THEN
      DO:
        ENABLE  fiDays.
        DISABLE fiHours
                fiMinutes.
      END.
          
      WHEN "Hours":U THEN
      DO:
        DISABLE fiDays
                fiMinutes.
        ENABLE  fiHours.
      END.
          
      WHEN "Minutes":U THEN
      DO:
        DISABLE fiDays
                fiHours.
        ENABLE  fiMinutes.
      END.
          
    END CASE.
    
  END.
  
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

