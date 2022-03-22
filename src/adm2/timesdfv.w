&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS sObject 
/*---------------------------------------------------------------------------------
  File: timesdfv.w

  Description:  Time SmartDataField
  
  Purpose:      Time SmartDataField

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   10/01/2001  Author:     

  Update Notes: Created from Template rysttdatfv.w
                Generic Time SmartDataField

  Modified: 11/08/2001 - Mark Davies (MIP)
            Removed XFTR for version updates
---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       timesdfv.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataField yes

{src/adm2/globals.i}

DEFINE VARIABLE gcTimeEntered     AS CHARACTER  NO-UNDO INITIAL "":U.
DEFINE VARIABLE gcTimeFormat      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcTimeSuffix      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcLastkey         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE giMaxDigits       AS INTEGER    NO-UNDO.
DEFINE VARIABLE gl24HourClock     AS LOGICAL    NO-UNDO.
DEFINE VARIABLE glDisplaySeconds  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE glPM              AS LOGICAL    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataField
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME frMain

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fiTime 
&Scoped-Define DISPLAYED-OBJECTS fiTime 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD displayTime sObject 
FUNCTION displayTime RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataValue sObject 
FUNCTION getDataValue RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD set24HourClock sObject 
FUNCTION set24HourClock RETURNS LOGICAL
  (pl24HourCLock AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setClockFormat sObject 
FUNCTION setClockFormat RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataValue sObject 
FUNCTION setDataValue RETURNS LOGICAL
  (piTime AS INTEGER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDisplaySeconds sObject 
FUNCTION setDisplaySeconds RETURNS LOGICAL
  (plDisplaySeconds AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFieldLabel sObject 
FUNCTION setFieldLabel RETURNS LOGICAL
  (pcFieldLabel AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE fiTime AS CHARACTER FORMAT "xx:xx:xx xx":U INITIAL "0" 
     LABEL "Time" 
     VIEW-AS FILL-IN 
     SIZE 17 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frMain
     fiTime AT ROW 1 COL 19 COLON-ALIGNED
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
         HEIGHT             = 1
         WIDTH              = 37.
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
/* SETTINGS FOR FRAME frMain
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME frMain:SCROLLABLE       = FALSE
       FRAME frMain:HIDDEN           = TRUE.

ASSIGN 
       fiTime:PRIVATE-DATA IN FRAME frMain     = 
                "NO-RESIZE".

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frMain
/* Query rebuild information for FRAME frMain
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME frMain */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME fiTime
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiTime sObject
ON ANY-KEY OF fiTime IN FRAME frMain /* Time */
DO:
  /* This is mainly to cope with if somebody presses the delete button */
  DEFINE VARIABLE iCursorOffset   AS INTEGER  NO-UNDO.
  
  ASSIGN
      iCursorOffset = fiTime:CURSOR-OFFSET.
  
  IF KEY-LABEL(LASTKEY) = "CURSOR-LEFT":U THEN
    iCursorOffset = IF iCursorOffset - 1 > 0 THEN iCursorOffset - 1 ELSE 1.

  IF TRIM(KEY-LABEL(LASTKEY)) = "CURSOR-RIGHT":U THEN
    iCursorOffset = IF iCursorOffset + 1 <= giMaxDigits + 1 THEN iCursorOffset + 1 ELSE giMaxDigits + IF giMaxDigits < 7 THEN 1 ELSE 2.
  
  IF KEY-LABEL(LASTKEY) BEGINS "BACKSPACE":U OR
     KEY-LABEL(LASTKEY) BEGINS "DEL":U       THEN /* Delete */
    ASSIGN
      gcLastkey = "*":U.
  
  {fn displayTime}.
  
  ASSIGN
    fiTime:CURSOR-OFFSET = iCursorOffset.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiTime sObject
ON ANY-PRINTABLE OF fiTime IN FRAME frMain /* Time */
DO:
  /* Set up the format of the text-box if it was clear */
  IF fiTime:FORMAT <> gcTimeFormat THEN
    fiTime:FORMAT = gcTimeFormat.
    
  ASSIGN gcLastKey = CHR(LASTKEY).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiTime sObject
ON MOUSE-SELECT-CLICK OF fiTime IN FRAME frMain /* Time */
DO:
  DEFINE VARIABLE iCursorOffset   AS INTEGER  NO-UNDO.
  
  iCursorOffset = fiTime:CURSOR-OFFSET.
  
  IF giMaxDigits < 7 AND iCursorOffset > giMaxDigits THEN iCursorOffset = giMaxDigits + 1. /* Clock without seconds */
  IF giMaxDigits > 6 AND iCursorOffset > giMaxDigits THEN iCursorOffset = giMaxDigits + 2. /* Clock with    seconds */
  
  fiTime:CURSOR-OFFSET = iCursorOffset.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiTime sObject
ON MOUSE-SELECT-DBLCLICK OF fiTime IN FRAME frMain /* Time */
DO:
  /* On mouse double-click, change the PM/AM setting */
  IF glPM = TRUE THEN
    glPM = FALSE.
  ELSE
    glPM = TRUE.
  
  DYNAMIC-FUNCTION("displayTime":U).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiTime sObject
ON VALUE-CHANGED OF fiTime IN FRAME frMain /* Time */
DO:
  {set DataModified TRUE}.
  
  DEFINE VARIABLE cEnteredCharacter AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTimeEntered      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iEnteredDigit     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCurrentPosition  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCursorOffset     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lError            AS LOGICAL    NO-UNDO.
  
  /* Assign the values to start working from */
  ASSIGN fiTime
         cTimeEntered  = fiTime
         iCursorOffset = fiTime:CURSOR-OFFSET
         lError        = FALSE.
  
  /* Check that the time entered is not blank */
  IF fiTime = ? THEN
    ASSIGN
        gcTimeEntered = "":U
        cTimeEntered  = "":U.
  
  /* If someone pressed delete, just move back */
  IF gcLastkey = "*":U THEN /* Delete */
  DO:
    {fn displayTime}.
    
    fiTime:CURSOR-OFFSET = iCursorOffset.
    
    LEAVE.
  END.
  
  /* Because the SCREEN-VALUE contains ':' and fiTime on its own doesn't, map the position */
  CASE iCursorOffset:
    WHEN 1 THEN iCurrentPosition = 1.
    WHEN 2 THEN iCurrentPosition = 1.
    WHEN 3 THEN iCurrentPosition = 2.
    WHEN 4 THEN iCurrentPosition = 2.
    WHEN 5 THEN iCurrentPosition = 3.
    WHEN 6 THEN iCurrentPosition = 4.
    WHEN 7 THEN iCurrentPosition = 4.
    WHEN 8 THEN iCurrentPosition = 5.
    WHEN 9 THEN iCurrentPosition = 6.
    OTHERWISE   iCurrentPosition = 7.
  END CASE.
  
  /* Get the character that was typed */
  cEnteredCharacter = gcLastkey.
  
  /* Check to see if the extra character allowed was meant to change the time's display */
  IF iCurrentPosition   = giMaxDigits AND
     cEnteredCharacter <> "?":U       AND
     cEnteredCharacter <> "A":U       AND
     cEnteredCharacter <> "P":U       AND
     cEnteredCharacter <> " ":U       THEN
    lError = TRUE.
  
  /* Check if the time field has been cleared or AM/PM changed */
  IF cEnteredCharacter = "?":U OR
     cEnteredCharacter = "A":U OR
     cEnteredCharacter = "P":U OR
     cEnteredCharacter = " ":U THEN
  DO:
    CASE cEnteredCharacter:
      WHEN "?":U THEN
        gcTimeEntered = "":U.
    
      WHEN "A":U THEN
        glPM = FALSE.
      
      WHEN "P":U THEN
        glPM = TRUE.
      
      WHEN " ":U THEN
      DO:
        IF glPM = TRUE THEN
          glPM = FALSE.
        ELSE
          glPM = TRUE.
      END.
    END CASE.
    
    /* Display the time and exit */
    DYNAMIC-FUNCTION("displayTime":U).

    IF iCursorOffset - 1 > 0 THEN
      fiTime:CURSOR-OFFSET = iCursorOffset - 1.
    
    LEAVE.
  END.
  
  /* Check if a digit has been entered */
  ASSIGN iEnteredDigit = INTEGER(cEnteredCharacter) NO-ERROR.
  
  /* Character has been entered */
  IF ERROR-STATUS:ERROR THEN
    ASSIGN
        ERROR-STATUS:ERROR = FALSE
        lError             = TRUE.

  IF lError = FALSE THEN
  DO:
    /* Check validaty of data entered */
    CASE iCurrentPosition:
      WHEN 1 THEN DO:
        IF gl24HourClock = FALSE THEN
        DO:
          IF iEnteredDigit > 1 THEN lError = TRUE.
        
          IF INTEGER(SUBSTRING(gcTimeEntered, 2, 1)) > 2 THEN
            SUBSTRING(gcTimeEntered, 2, 1) = "2":U.
        END.

        IF gl24HourClock = TRUE THEN
        DO: 
          IF iEnteredDigit > 2 THEN lError = TRUE.
          
          IF INTEGER(SUBSTRING(gcTimeEntered, 2, 1)) > 3 THEN
            SUBSTRING(gcTimeEntered, 2, 1) = "3":U.
        END.
      END.
      
      WHEN 2 THEN DO:
        IF gl24HourClock = FALSE THEN DO:
          IF INTEGER(SUBSTRING(cTimeEntered, 1, 1)) = 1 AND iEnteredDigit > 2 THEN lError = TRUE.
          IF INTEGER(SUBSTRING(cTimeEntered, 1, 1)) = 0 AND iEnteredDigit = 0 THEN lError = TRUE.
        END.
        
        IF gl24HourClock = TRUE AND INTEGER(SUBSTRING(cTimeEntered, 1, 1)) = 2 AND iEnteredDigit > 3 THEN lError = TRUE.
      END.
      
      WHEN 3 THEN
        IF iEnteredDigit > 5 THEN lError = TRUE.
    
      WHEN 5 THEN
        IF iEnteredDigit > 5 THEN lError = TRUE.
    END CASE.
  END.
  
  /* If any error was encountered, backout */
  IF lError = TRUE THEN
  DO:
    /* Invalid Digit Entered, set to previous value */
    DYNAMIC-FUNCTION("displayTime":U).

    IF iCursorOffset - 1 > 0 THEN
    DO:
      iCursorOffset = iCursorOffset - 1.
    
      fiTime:CURSOR-OFFSET = iCursorOffset.
    END.
  END.
  ELSE
  DO:
    IF LENGTH(TRIM(gcTimeEntered)) = 0 THEN
    DO:
      IF glDisplaySeconds = TRUE THEN
        gcTimeEntered = cEnteredCharacter + "00000":U.
      ELSE
        gcTimeEntered = cEnteredCharacter + "000":U.
    END.
    
    /* Valid digit entered, update variable */
    SUBSTRING(gcTimeEntered, iCurrentPosition, 1) = cEnteredCharacter.
    
    {fn  displayTime}.
    
    IF iCursorOffset > 0 THEN
      fiTime:CURSOR-OFFSET = iCursorOffset.
  END.


  /* give viewer a chance to do something about this - e.g. work out
     hours between 2 times, etc.
  */
  DEFINE VARIABLE hContainer            AS HANDLE     NO-UNDO.
  {get containerSource hContainer}.
  PUBLISH "timeChanged" FROM hContainer (INPUT getDataValue(), INPUT TARGET-PROCEDURE).

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
  Notes:    SmartDataField:disableFields will call this for all Objects of type
            PROCEDURE that it encounters in the EnableFields Property.  
            The developer must add logic to disable the actual SmartField.    
------------------------------------------------------------------------------*/
   
   {set FieldEnabled FALSE}.
   fiTime:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE.
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
  HIDE FRAME frMain.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableField sObject 
PROCEDURE enableField :
/*------------------------------------------------------------------------------
  Purpose:   Enable the field   
  Parameters:  <none>
  Notes:    SmartDataField:enableFields will call this for all Objects of type
            PROCEDURE that it encounters in the EnableFields Property.  
            The developer must add logic to enable the SmartField.    
------------------------------------------------------------------------------*/
   
   {set FieldEnabled TRUE}.
   fiTime:SENSITIVE IN FRAME {&FRAME-NAME} = TRUE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject sObject 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:  Super Override
  
  Parameters:  
  
  Notes:  The width of the time field must be adjusted automatically according
          to the options specified
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cUIBMode  AS CHARACTER  NO-UNDO.
  
  /* Code placed here will execute PRIOR to standard behavior. */
  {get UIBMode cUIBMode}.

  /* Set the default values */
  ASSIGN
      gl24HourClock    = TRUE
      glDisplaySeconds = FALSE.

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior. */
  {fn setClockFormat}.

  /* In design mode, show the time so its easier to resize the field */
  IF cUIBMode = "DESIGN":U THEN
    {fnarg setDataValue TIME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION displayTime sObject 
FUNCTION displayTime RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iRepeats  AS INTEGER  NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    /* See if any time has been entered - if not, clear the fill-in (of the format as well */
    IF TRIM(gcTimeEntered) = "":U THEN
      fiTime:FORMAT = "x(11)":U.
    ELSE
    DO:
      fiTime:FORMAT = gcTimeFormat.
    
      IF glDisplaySeconds = TRUE THEN
        iRepeats = 6 - LENGTH(TRIM(gcTimeEntered)).
      ELSE
        iRepeats = 4 - LENGTH(TRIM(gcTimeEntered)).
      
      gcTimeEntered = gcTimeEntered + FILL("0":U, iRepeats).
    END.
    
    /* Check the clock mode and set the correct suffix */
    IF gl24HourClock = FALSE THEN
    DO:
      IF glPM = TRUE THEN
        gcTimeSuffix = "PM":U.
      ELSE
        gcTimeSuffix = "AM":U.
      
      IF TRIM(gcTimeEntered) = "":U THEN
        gcTimeSuffix = "":U.
    END.
    ELSE
      gcTimeSuffix = "":U.
  
    IF gl24HourClock = FALSE THEN
    DO:
      IF gcTimeEntered = "0000":U THEN
        gcTimeEntered = "0100":U.
      
      IF gcTimeEntered = "000000":U THEN
        gcTimeEntered = "010000":U.
    END.
    
    /* Clear the SCREEN-VALUE if there is no time to display */
    IF TRIM(gcTimeEntered) = "":U THEN
      fiTime:SCREEN-VALUE = "":U.
    ELSE
      fiTime:SCREEN-VALUE = gcTimeEntered + gcTimeSuffix.
  END.
  
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataValue sObject 
FUNCTION getDataValue RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the current value of the SmartDataField object.
   Params:  none
    Notes:  This function must be defined by the developer of the object
            to return its value.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iTime AS INTEGER  NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN fiTime.
  
    /* See if the time specified was blank */
    IF TRIM(fiTime:SCREEN-VALUE) = "":U THEN
      ASSIGN
          iTime = ?.
    ELSE
    DO:
      /* Check if the Gen Manager handle is valida nd run the standard routine to convert a time string to an integer */
      IF VALID-HANDLE(gshGenManager) THEN
        iTime = DYNAMIC-FUNCTION("convertTimeToInteger":U IN gshGenManager, INPUT gcTimeEntered).
      
      /* If it is a 12-hour clock and it is PM, add 12 hours worth of seconds to the time */
      IF gl24HourClock = FALSE AND
         glPM          = TRUE  THEN
        iTime = iTime + (12 * 60 * 60).
    END.
  END.
  
  IF iTime = ? THEN
    RETURN "?":U.
  ELSE
    RETURN STRING(iTime).   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION set24HourClock sObject 
FUNCTION set24HourClock RETURNS LOGICAL
  (pl24HourCLock AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the global variable to indicate whether or not the clock
            must display 24hr format or not.
    Notes:  
------------------------------------------------------------------------------*/
  gl24HourCLock = pl24HourCLock.

  /* Adjust the clock format and re-display the time */
  {fn setClockFormat}.
  {fn displayTime}.

  RETURN TRUE.   /* Function return value. */
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setClockFormat sObject 
FUNCTION setClockFormat RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Adjust the width of the fill-in accoring
    Notes:  
------------------------------------------------------------------------------*/
  /* Set the widget's format up correctly depending on the required mode */
  DO WITH FRAME {&FRAME-NAME}:
    fiTime:WIDTH = 10.
    
    IF glDisplaySeconds = FALSE THEN
      ASSIGN
          giMaxDigits  = 5
          gcTimeFormat = "XX:XX":U.
    ELSE
      ASSIGN
          giMaxDigits  = 7
          gcTimeFormat = "XX:XX:XX":U
          fiTime:WIDTH = fiTime:WIDTH + 3.
    
    IF gl24HourClock = FALSE THEN
      ASSIGN
          gcTimeFormat = gcTimeFormat + " XX":U
          fiTime:WIDTH = fiTime:WIDTH + 3.
    
    /* Fine Tuning the Width */
    IF glDisplaySeconds = TRUE  AND
       gl24HourClock    = FALSE THEN
      fiTime:WIDTH = fiTime:WIDTH + 1.
    
    IF glDisplaySeconds = FALSE AND
       gl24HourClock    = TRUE  THEN
      fiTime:WIDTH = fiTime:WIDTH - 1.
  END.

  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataValue sObject 
FUNCTION setDataValue RETURNS LOGICAL
  (piTime AS INTEGER):
/*------------------------------------------------------------------------------
  Purpose:  This function receives the value for the SmartDataField and assigns it.
   Params:  The parameter and its datatype must be defined by the developer.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTime   AS CHARACTER  NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    /* Check if a valid time was specified */
    IF piTime >= 0 AND
       piTime <> ? AND
       piTime <= ((24 * 60 * 60) - 1) THEN
    DO:
      IF piTime >= (12 * 60 * 60) THEN
        glPM = TRUE.
      ELSE
        glPM = FALSE.

      IF gl24HourClock = FALSE AND
         glPM          = TRUE  THEN
        piTime = piTime - (12 * 60 * 60).

      ASSIGN
          cTime         = STRING(piTime, "HH:MM:SS":U)
          gcTimeEntered = SUBSTRING(cTime, 1, 2)
                        + SUBSTRING(cTime, 4, 2).
      
      IF glDisplaySeconds = TRUE THEN
        gcTimeEntered = gcTimeEntered
                      + SUBSTRING(cTime, 7, 2).
    END.
    ELSE
      gcTimeEntered = "":U.

    DYNAMIC-FUNCTION("displayTime":U).

    RETURN TRUE.   /* Function return value. */
  END.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDisplaySeconds sObject 
FUNCTION setDisplaySeconds RETURNS LOGICAL
  (plDisplaySeconds AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the global variable to indicate whether or not the clock
            must display seconds or not.
    Notes:  
------------------------------------------------------------------------------*/
  glDisplaySeconds = plDisplaySeconds.
  
  /* Adjust the clock format and re-display the time */
  {fn setClockFormat}.
  {fn displayTime}.
  
  RETURN TRUE.   /* Function return value. */
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFieldLabel sObject 
FUNCTION setFieldLabel RETURNS LOGICAL
  (pcFieldLabel AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Assigns the field's label to whatever was specified
    Notes:  
------------------------------------------------------------------------------*/

  fiTime:LABEL IN FRAME {&FRAME-NAME} = pcFieldLabel NO-ERROR.
  
  RETURN NOT ERROR-STATUS:ERROR.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

