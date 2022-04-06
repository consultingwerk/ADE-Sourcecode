&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS sObject 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: Spin.w

  Description: Spin Buttons SmartObject

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

&GLOBAL-DEFINE ADMClass SmartObject

/* ***************************  Definitions  ************************** */

&SCOPED-DEFINE ADM-PROPERTY-LIST SpinStyle,LinkName,ButtonIncrement,~
ButtonMinimum,ButtonMaximum,SpinSpeed,SpinAccel,SpinKeys,AutoPosition,MouseCursor,BufferFlush

&GLOBAL-DEFINE xcInstanceProperties {&ADM-PROPERTY-LIST}

&GLOBAL-DEFINE xcTranslatableProperties {&ADM-PROPERTY-LIST}
/*
&SCOPED-DEFINE ADM-PROPERTY-DLG gui\adm2\support\Spind.w
Removed this property as the property dialog specified does
not exist, Checked previous versions, amd it seems, spind.w 
never existed. Also there does not seem to be a Spin property
dialog box currently..
*/
&SCOPED-DEFINE SPIN-BITMAP ry\img\spin.bmp

&SCOPED-DEFINE INTEGER-LOW -2147483648
&SCOPED-DEFINE INTEGER-HIGH 2147483647

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE iCounter AS DECIMAL NO-UNDO.

DEFINE VARIABLE lButtonDown AS LOGICAL INITIAL TRUE.

DEFINE VARIABLE hContainer AS HANDLE NO-UNDO.
DEFINE VARIABLE hParent    AS HANDLE NO-UNDO.
DEFINE VARIABLE hField     AS HANDLE NO-UNDO.

DEFINE VARIABLE hBtn-Inc AS HANDLE NO-UNDO.
DEFINE VARIABLE hBtn-Dec AS HANDLE NO-UNDO.

DEFINE VARIABLE lResult    AS LOGICAL NO-UNDO.
DEFINE VARIABLE lSpinHoriz AS LOGICAL NO-UNDO.

DEFINE VARIABLE iIncX AS INTEGER NO-UNDO.
DEFINE VARIABLE iIncY AS INTEGER NO-UNDO.
DEFINE VARIABLE iDecX AS INTEGER NO-UNDO.
DEFINE VARIABLE iDecY AS INTEGER NO-UNDO.

DEFINE VARIABLE iImgWidth  AS INTEGER NO-UNDO.
DEFINE VARIABLE iImgHeight AS INTEGER NO-UNDO.
DEFINE VARIABLE iImgOffset AS INTEGER NO-UNDO.

DEFINE VARIABLE iAccelerator AS INTEGER NO-UNDO.

DEFINE VARIABLE XTIME AS INTEGER NO-UNDO.

DEFINE VARIABLE lKeepState AS LOGICAL INITIAL FALSE.

DEFINE VARIABLE cSpinStyle       AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFieldName       AS CHARACTER NO-UNDO.
DEFINE VARIABLE iButtonIncrement AS DECIMAL   NO-UNDO.
DEFINE VARIABLE iButtonMinimum   AS DECIMAL   NO-UNDO.
DEFINE VARIABLE iButtonMaximum   AS DECIMAL   NO-UNDO.
DEFINE VARIABLE iSpinSpeed       AS INTEGER   NO-UNDO.
DEFINE VARIABLE iSpinAccel       AS INTEGER   NO-UNDO.
DEFINE VARIABLE lSpinKeys        AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lBufferFlush     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lAutoPosition    AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cMouseCursor     AS CHARACTER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SpinButtons
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
    WITH 1 DOWN NO-BOX NO-HIDE KEEP-TAB-ORDER OVERLAY NO-HELP 
         NO-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1
         SIZE 20.8 BY 2.05.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SpinButtons
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
         HEIGHT             = 2.05
         WIDTH              = 20.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB sObject 
/* ************************* Included-Libraries *********************** */

{af/sup2/afspventil.i}
{af/sup2/afspcolour.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW sObject
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE                                                          */
ASSIGN 
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

&Scoped-define SELF-NAME F-Main
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL F-Main sObject
ON ENTRY OF FRAME F-Main
DO:
   IF NOT lKeepState
   THEN
       RUN enableAll IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK sObject 


/* ***************************  Main Block  *************************** */
ASSIGN FRAME {&FRAME-NAME}:VISIBLE = FALSE
       FRAME {&FRAME-NAME}:HIDDEN  = TRUE
       FRAME {&FRAME-NAME}:WIDTH-PIXELS = 1
       FRAME {&FRAME-NAME}:HEIGHT-PIXELS = 1.

&GLOBAL-DEFINE xpSpinStyle
&GLOBAL-DEFINE xpLinkName
&GLOBAL-DEFINE xpButtonIncrement
&GLOBAL-DEFINE xpButtonMinimum
&GLOBAL-DEFINE xpButtonMaximum
&GLOBAL-DEFINE xpSpinSpeed
&GLOBAL-DEFINE xpSpinAccel
&GLOBAL-DEFINE xpSpinKeys
&GLOBAL-DEFINE xpAutoPosition
&GLOBAL-DEFINE xpBufferFlush
&GLOBAL-DEFINE xpMouseCursor

/* Now include the other props files which will start the ADMProps def. */
{src/adm2/visprop.i}

/* and then we add our folder property defs to that... */
&IF "{&ADM-VERSION}" = "ADM2.0"
&THEN
    FIELD SpinStyle       AS CHARACTER INIT "Standard Combo Vertical"
    FIELD LinkName        AS CHARACTER 
    FIELD ButtonIncrement AS DECIMAL INIT 1.0
    FIELD ButtonMinimum   AS DECIMAL 
    FIELD ButtonMaximum   AS DECIMAL INIT 99999999.0
    FIELD SpinSpeed       AS INTEGER INIT 0
    FIELD SpinAccel       AS INTEGER INIT 10
    FIELD SpinKeys        AS LOGICAL INIT TRUE
    FIELD AutoPosition    AS LOGICAL INIT TRUE
    FIELD BufferFlush     AS LOGICAL INIT FALSE

    {af/sup2/afspcommdf.i}
/* ... and the final period to end the definition... */
  .
&ELSE
    ghADMProps:ADD-NEW-FIELD('SpinStyle':U      , 'CHARACTER', 0, ?, "Standard Combo Vertical":U).
    ghADMProps:ADD-NEW-FIELD('LinkName':U       , 'CHARACTER', 0, ?,"").
    ghADMProps:ADD-NEW-FIELD('ButtonIncrement':U, 'DECIMAL',   0, ?, 1.0).
    ghADMProps:ADD-NEW-FIELD('ButtonMinimum':U  , 'DECIMAL',   0, ?, 0).
    ghADMProps:ADD-NEW-FIELD('ButtonMaximum':U  , 'DECIMAL',   0, ?, 99999999.0).
    ghADMProps:ADD-NEW-FIELD('SpinSpeed':U      , 'INTEGER',   0, ?, 0).
    ghADMProps:ADD-NEW-FIELD('SpinAccel':U      , 'INTEGER',   0, ?, 10).
    ghADMProps:ADD-NEW-FIELD('SpinKeys':U       , 'LOGICAL',   0, ?, TRUE).
    ghADMProps:ADD-NEW-FIELD('AutoPosition':U   , 'LOGICAL',   0, ?, TRUE).
    ghADMProps:ADD-NEW-FIELD('BufferFlush':U    , 'LOGICAL',   0, ?, TRUE).

    {af/sup2/afspcommdf.i}
&ENDIF

/* Now include out parent class file for visual objects. */
{src/adm2/visual.i} 

/* Include get/set functions for properties */
{af/sup2/afspinprop.i} 

/* Include user-defined Spin button functions */
{af/sup2/afspinmeth.i}

/* If testing in the UIB, initialize the SmartObject. */  
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
  RUN initializeObject.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disableAll sObject 
PROCEDURE disableAll :
/*------------------------------------------------------------------------------
  Purpose:     Disable Both Buttons
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN hBtn-Inc:SENSITIVE = FALSE
       hBtn-Dec:SENSITIVE = FALSE
       FRAME {&FRAME-NAME}:SENSITIVE = FALSE
       lKeepState = TRUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disableButton sObject 
PROCEDURE disableButton :
/*------------------------------------------------------------------------------
  Purpose:     Disable the indicated button
  Parameters:  Button ID Inc[rement] or Dec[rement]
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER ip-id AS CHARACTER NO-UNDO.

IF ip-id BEGINS "Inc" 
THEN
    ASSIGN hBtn-Inc:SENSITIVE = FALSE.
ELSE
IF ip-id BEGINS "Dec" 
THEN
    ASSIGN hBtn-Dec:SENSITIVE = FALSE.

ASSIGN lKeepState = TRUE
       FRAME {&FRAME-NAME}:SENSITIVE = hBtn-Dec:SENSITIVE OR hBtn-Inc:SENSITIVE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableAll sObject 
PROCEDURE enableAll :
/*------------------------------------------------------------------------------
  Purpose:     Enable Both Buttons
  Parameters:  <none>
  Notes:       Field Handle must be set and not in UIB Design mode
------------------------------------------------------------------------------*/

IF VALID-HANDLE(hField) AND NOT UIBMode()
THEN 
     ASSIGN hBtn-Inc:SENSITIVE = hField:SENSITIVE
            hBtn-Dec:SENSITIVE = hField:SENSITIVE
            FRAME {&FRAME-NAME}:SENSITIVE = TRUE
            lKeepState = TRUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableButton sObject 
PROCEDURE enableButton :
/*------------------------------------------------------------------------------
  Purpose:     Enable the indicated button
  Parameters:  Button ID Inc[rement] or Dec[rement]
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER ip-id AS CHARACTER NO-UNDO.

IF ip-id BEGINS "Inc" THEN
    ASSIGN hBtn-Inc:SENSITIVE = TRUE.
ELSE
IF ip-id BEGINS "Dec" THEN
    ASSIGN hBtn-Dec:SENSITIVE = TRUE.

ASSIGN lKeepState = TRUE
       FRAME {&FRAME-NAME}:SENSITIVE = TRUE.

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
  ASSIGN FRAME {&FRAME-NAME}:HIDDEN = TRUE.

  /* Code placed here will execute PRIOR to standard behavior. */
  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

  ASSIGN hContainer = WIDGET-HANDLE(DYNAMIC-FUNCTION('linkHandles':U, 'Container-Source':U))
         hParent    = FRAME {&FRAME-NAME}:FRAME.

  RUN _InitializeObject.

  ASSIGN FRAME {&FRAME-NAME}:VISIBLE = TRUE
         lResult = FRAME {&FRAME-NAME}:MOVE-TO-TOP().

  IF UIBMode()
  THEN DO:
      DO ON ERROR UNDO, LEAVE:
          RUN _getVentilator(FRAME {&FRAME-NAME}:HANDLE).
      END.

      IF VALID-HANDLE(hVentilator)
      THEN
          ASSIGN hVentilator:HIDDEN = TRUE.
  END.
  ELSE DO:
      IF cMouseCursor <> "":U 
      THEN  
          /* Loading the mouse pointer for a frame results in all child 
             widgets having same pointer.
           */
          lResult = FRAME {&FRAME-NAME}:LOAD-MOUSE-POINTER(cMouseCursor).
      
      SUBSCRIBE TO "SyncSpinState" IN hContainer RUN-PROCEDURE "_syncSpinState".
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setFieldHandle sObject 
PROCEDURE setFieldHandle :
/*------------------------------------------------------------------------------
  Purpose:     Links the spin buttons to an INTEGER field
  Parameters:  The handle of the field
  Notes:       This is run internally if the name of the field is specified as
               and attribute and is found in the frame. You can call this method
               manually from outside of this procedure.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER ip-field AS HANDLE NO-UNDO.

IF VALID-HANDLE(ip-field)
AND CAN-SET(ip-field,"SCREEN-VALUE":U)
AND CAN-QUERY(ip-field,"DATA-TYPE":U)
AND CAN-DO("DECIMAL,INTEGER":U,ip-field:DATA-TYPE)
THEN DO:
    ASSIGN hField = ip-field.

    IF lSpinKeys 
    THEN DO:
        ON "CURSOR-UP":U OF hField PERSISTENT RUN _CursorUp IN THIS-PROCEDURE.
        ON "CURSOR-DOWN":U OF hField PERSISTENT RUN _CursorDown IN THIS-PROCEDURE.
    END.

    hField:MOVE-TO-BOTTOM().
END.
ELSE
    ASSIGN hField = ?.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _buttonUp sObject 
PROCEDURE _buttonUp PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Terminate the lButtonDown loop
  Parameters:  <none>
  Notes:       This is run when the mouse button is released, or the user moves
               the mouse too far. The RETURN NO-APPLY ensures that although the
               buttons are defined as MOVABLE, no movement actually takes place.
------------------------------------------------------------------------------*/

ASSIGN lButtonDown = FALSE.

RETURN NO-APPLY.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _cursorDown sObject 
PROCEDURE _cursorDown PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Decrement the field value by keystroke
  Parameters:  <none>
  Notes:       See _Cursor-Up for an explanation.
------------------------------------------------------------------------------*/
DEFINE VARIABLE ivalue AS DECIMAL NO-UNDO.

IF VALID-HANDLE(hField) 
THEN DO:
    ASSIGN ivalue = DECIMAL(hField:SCREEN-VALUE)
           ivalue = MAXIMUM(iButtonMinimum,ivalue - iButtonIncrement)
           hField:SCREEN-VALUE = STRING(ivalue)
           NO-ERROR.

    APPLY "VALUE-CHANGED":U TO hField.

    IF lBufferFlush 
    THEN
        RUN _flushBuffer IN THIS-PROCEDURE.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _cursorUp sObject 
PROCEDURE _cursorUp PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Increment the field-value
  Parameters:  <none>
  Notes:       This works by entering a loop that continues while the mouse is
               held down. The PROCESS EVENTS is essential so that the release
               or attempted movement of the button is detected and the loop
               can terminate. The inner loop is a delay that controls the rate
               of spin. The number of iterations of the inner loop is gradually
               reduced until it reaches the set speed. The inner loop is always
               processed at least once, for each iteration of the outer loop.
------------------------------------------------------------------------------*/
DEFINE VARIABLE ivalue AS DECIMAL NO-UNDO.

IF VALID-HANDLE(hField) 
THEN DO:
    ASSIGN ivalue = DECIMAL(hField:SCREEN-VALUE)
           ivalue = MINIMUM(iButtonMaximum,ivalue + iButtonIncrement)
           hField:SCREEN-VALUE = STRING(ivalue)
           NO-ERROR.

    APPLY "VALUE-CHANGED":U TO hField.

    IF lBufferFlush
    THEN
        RUN _flushBuffer IN THIS-PROCEDURE.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _Decrement sObject 
PROCEDURE _Decrement PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Decrement the field value
  Parameters:  <none>
  Notes:       See _Increment for an explanation.
------------------------------------------------------------------------------*/
DEFINE VARIABLE ivalue AS DECIMAL NO-UNDO.

IF VALID-HANDLE(hField) 
THEN DO:
    ASSIGN lResult = hBtn-Dec:LOAD-IMAGE("{&SPIN-BITMAP}":U,iDecX,iDecY + iImgHeight,iImgWidth,iImgHeight)
           lResult = hBtn-Inc:LOAD-IMAGE("{&SPIN-BITMAP}":U,iIncX,iIncY,iImgWidth,iImgHeight)
           lButtonDown = TRUE 
           ivalue = DECIMAL(hField:SCREEN-VALUE) 
           iAccelerator = 500
           NO-ERROR.

    DO WHILE lButtonDown AND ivalue > iButtonMinimum:

        ASSIGN ivalue = MAXIMUM(iButtonMinimum,ivalue - iButtonIncrement)
               hField:SCREEN-VALUE = STRING(ivalue)
               iAccelerator = iAccelerator - ((iAccelerator * iSpinAccel) / 100) - 1 
               XTIME = ETIME + (iSpinSpeed + iAccelerator) 
               NO-ERROR.

        DO WHILE lButtonDown:
            PROCESS EVENTS.

            IF ETIME > XTIME THEN LEAVE.
        END.

    END.

    IF ivalue <= iButtonMinimum 
    THEN
        ASSIGN lResult = hBtn-Dec:LOAD-IMAGE("{&SPIN-BITMAP}":U,iDecX,iDecY + (iImgHeight * 2),iImgWidth,iImgHeight).
    ELSE   
        ASSIGN lResult = hBtn-Dec:LOAD-IMAGE("{&SPIN-BITMAP}":U,iDecX,iDecY,iImgWidth,iImgHeight).

    PROCESS EVENTS.

    APPLY "VALUE-CHANGED":U TO hField.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _flushBuffer sObject 
PROCEDURE _flushBuffer PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Clear the Keyboard Buffer
  Parameters:  <none>
  Notes:       INPUT CLEAR doesn't seem to work
------------------------------------------------------------------------------*/

DO WHILE LASTKEY <> -1:
    READKEY PAUSE 0.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _getProperties sObject 
PROCEDURE _getProperties PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Extract Properties into local variables
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN cSpinStyle       = getSpinStyle()
       cFieldName       = getLinkName()
       iButtonIncrement = getButtonIncrement()
       iButtonMinimum   = getButtonMinimum()
       iButtonMaximum   = getButtonMaximum()
       iSpinSpeed       = getSpinSpeed()
       iSpinAccel       = getSpinAccel()
       lSpinKeys        = getSpinKeys()
       lAutoPosition    = getAutoPosition()
       lBufferFlush     = getBufferFlush()
       cMouseCursor     = getMouseCursor().

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _Increment sObject 
PROCEDURE _Increment PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Increment the field-value
  Parameters:  <none>
  Notes:       This works by entering a loop that continues while the mouse is
               held down. The PROCESS EVENTS is essential so that the release
               or attempted movement of the button is detected and the loop
               can terminate. The inner loop is a delay that controls the rate
               of spin. The number of iterations of the inner loop is gradually
               reduced until it reaches the set speed. The inner loop is always
               processed at least once, for each iteration of the outer loop.
------------------------------------------------------------------------------*/
DEFINE VARIABLE ivalue AS DECIMAL NO-UNDO.

IF VALID-HANDLE(hField) 
THEN DO:
    ASSIGN lResult = hBtn-Inc:LOAD-IMAGE("{&SPIN-BITMAP}":U,iIncX,iIncY + iImgHeight,iImgWidth,iImgHeight)
           lResult = hBtn-Dec:LOAD-IMAGE("{&SPIN-BITMAP}":U,iDecX,iDecY,iImgWidth,iImgHeight)
           lButtonDown = TRUE 
           ivalue = DECIMAL(hField:SCREEN-VALUE)
           iAccelerator = 500
           NO-ERROR.

    DO WHILE lButtonDown AND ivalue < iButtonMaximum:

        ASSIGN ivalue = MINIMUM(iButtonMaximum,ivalue + iButtonIncrement)
               hField:SCREEN-VALUE = STRING(ivalue)
               iAccelerator = iAccelerator - ((iAccelerator * iSpinAccel) / 100) - 1 
               XTIME = ETIME + (iSpinSpeed + iAccelerator)
               NO-ERROR.

        DO WHILE lButtonDown:
            PROCESS EVENTS.

            IF ETIME > XTIME THEN LEAVE.
        END.

    END.

    IF ivalue >= iButtonMaximum 
    THEN
        ASSIGN lResult = hBtn-Inc:LOAD-IMAGE("{&SPIN-BITMAP}":U,iIncX,iIncY + (iImgHeight * 2),iImgWidth,iImgHeight).
    ELSE   
        ASSIGN lResult = hBtn-Inc:LOAD-IMAGE("{&SPIN-BITMAP}":U,iIncX,iIncY,iImgWidth,iImgHeight).

    PROCESS EVENTS.

    APPLY "VALUE-CHANGED":U TO hField.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _initializeObject sObject 
PROCEDURE _initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Set things up properly. 
  Parameters:  <none>
  Notes:       Sets the image parameters, creates and sizes the buttons, loads
               the images and tweaks their appearance. The iImgOffset variables is
               set to 1 for combo-style images only. This offsets the buttons
               by 1 pixel to the right so that a black line can be seen on the
               left of the buttons, as a separator. (The black line is actually
               the frame, with the BGCOLOR set to zero/black).
------------------------------------------------------------------------------*/

RUN _getProperties.

ASSIGN FRAME {&FRAME-NAME}:HIDDEN = TRUE
       FRAME {&FRAME-NAME}:SCROLLABLE = TRUE
       FRAME {&FRAME-NAME}:WIDTH-PIXELS = 1
       FRAME {&FRAME-NAME}:HEIGHT-PIXELS = 1

       iButtonMinimum = IF iButtonMinimum = ? THEN {&INTEGER-LOW} 
                        ELSE iButtonMinimum 
       iButtonMaximum = IF iButtonMaximum = ? THEN {&INTEGER-HIGH}
                        ELSE iButtonMaximum        
       NO-ERROR.

/* Point to the images, according to the chosen style */
CASE cSpinStyle:

      WHEN "Standard Horizontal" THEN
          ASSIGN iIncX = 0 iIncY = 0 iImgWidth = 12 iImgHeight = 12 iImgOffset = 0 lSpinHoriz = TRUE.

      WHEN "Larger Vertical" THEN
          ASSIGN iIncX = 94 iIncY = 0 iImgWidth = 23 iImgHeight = 24 iImgOffset = 0 lSpinHoriz = FALSE.

      WHEN "Larger Horizontal" THEN
          ASSIGN iIncX = 48 iIncY = 0 iImgWidth = 23 iImgHeight = 24 iImgOffset = 0 lSpinHoriz = TRUE.

      WHEN "Standard Combo Vertical" THEN
          ASSIGN iIncX = 24 iIncY = 36 iImgWidth = 12 iImgHeight = 9 iImgOffset = 1 lSpinHoriz = FALSE.

      WHEN "Standard Combo Horizontal" THEN
          ASSIGN iIncX = 0 iIncY = 36 iImgWidth = 9 iImgHeight = 18 iImgOffset = 1 lSpinHoriz = TRUE.

      WHEN "Wider Combo Vertical" THEN
          ASSIGN iIncX = 20 iIncY = 63 iImgWidth = 14 iImgHeight = 9 iImgOffset = 1 lSpinHoriz = FALSE.

      OTHERWISE
          ASSIGN iIncX = 24 iIncY = 0 iImgWidth = 12 iImgHeight = 12 iImgOffset = 0 lSpinHoriz = FALSE.

END CASE.

ASSIGN iDecX = iIncX + iImgWidth 
       iDecY = iIncY.

IF VALID-HANDLE(hBtn-Dec) THEN
    DELETE WIDGET hBtn-Dec.

IF VALID-HANDLE(hBtn-Inc) THEN
    DELETE WIDGET hBtn-Inc.

ASSIGN FRAME {&FRAME-NAME}:WIDTH-PIXELS = 100 /* make some space for the larger buttons */
       FRAME {&FRAME-NAME}:HEIGHT-PIXELS = 100
       .           
/* We use images here instead of buttons, because
   they're more consistent between XP+manifest and non-manifest
   UI. For the purposes of this SmartObject, the functionality
   of buttons and images is the same, so we use images.
 */
CREATE image hBtn-Dec
    ASSIGN HEIGHT-PIXELS = iImgHeight 
           WIDTH-PIXELS = iImgWidth
           X = iImgOffset
           Y = IF lSpinHoriz THEN 0 ELSE iImgHeight - 1
           MOVABLE = TRUE
           FRAME = FRAME {&FRAME-NAME}:HANDLE
           SENSITIVE = FALSE
    TRIGGERS:
        ON LEFT-MOUSE-DOWN PERSISTENT RUN _Decrement IN THIS-PROCEDURE.
        ON LEFT-MOUSE-UP,START-MOVE PERSISTENT RUN _ButtonUp IN THIS-PROCEDURE.
    END TRIGGERS.

CREATE image hBtn-Inc
    ASSIGN HEIGHT-PIXELS = iImgHeight 
           WIDTH-PIXELS = iImgWidth
           X = IF lSpinHoriz THEN iImgWidth - IF iImgOffset = 1 THEN 0 ELSE 1 ELSE iImgOffset
           Y = 0           
           MOVABLE = TRUE
           FRAME = FRAME {&FRAME-NAME}:HANDLE
           SENSITIVE = FALSE 
    TRIGGERS:
        ON LEFT-MOUSE-DOWN PERSISTENT RUN _Increment IN THIS-PROCEDURE.
        ON LEFT-MOUSE-UP,START-MOVE PERSISTENT RUN _ButtonUp IN THIS-PROCEDURE.
    END TRIGGERS.

IF lSpinHoriz THEN
    ASSIGN FRAME {&FRAME-NAME}:WIDTH-PIXELS = (iImgWidth * 2) - IF iImgOffset = 1 THEN 0 ELSE 1
           FRAME {&FRAME-NAME}:HEIGHT-PIXELS = iImgHeight.
ELSE
    ASSIGN FRAME {&FRAME-NAME}:WIDTH-PIXELS = iImgWidth + iImgOffset
           FRAME {&FRAME-NAME}:HEIGHT-PIXELS = (iImgHeight * 2) - 1. 

/* [PJ] I'm not entirely sure why we need to load the sensitive and insensitive images
   here. However, this is what was previously done and it resulted in the spin buttons 
   being initially disabled, until clicked. I suspect this is a bug, but can't confirm it
   either way.
 */
ASSIGN /* Sensitive */
       lResult = hBtn-Inc:LOAD-IMAGE("{&SPIN-BITMAP}":U,iIncX,iIncY,iImgWidth,iImgHeight)
       /* Insensitive */
       lResult = hBtn-Inc:LOAD-IMAGE("{&SPIN-BITMAP}":U,iIncX,iIncY + (iImgHeight * 2),iImgWidth,iImgHeight)       
       /* Sensitive */
       lResult = hBtn-Dec:LOAD-IMAGE("{&SPIN-BITMAP}":U,iDecX,iDecY,iImgWidth,iImgHeight)                  
       /* Insensitive */
       lResult = hBtn-Dec:LOAD-IMAGE("{&SPIN-BITMAP}":U,iDecX,iDecY + (iImgHeight * 2),iImgWidth,iImgHeight)                     
       NO-ERROR.
    
/* Go look for a field of the specified name in the frame/field-group */
IF NOT UIBMode() AND cFieldName <> "":U 
THEN 
    RUN _matchFieldHandle.

/* There's a slight overlay of 1 pixel on the lower or right-side button
   (depending on whether the style is vertical or horizontal). This gives the
   appearance that the two buttons are a single, split object.
*/
ASSIGN FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT-PIXELS = FRAME {&FRAME-NAME}:HEIGHT-PIXELS
       FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-PIXELS = FRAME {&FRAME-NAME}:WIDTH-PIXELS
       FRAME {&FRAME-NAME}:SCROLLABLE = FALSE
       FRAME {&FRAME-NAME}:HIDDEN = FALSE 
       lResult = IF lSpinHoriz THEN hBtn-Inc:MOVE-TO-TOP()
                 ELSE hBtn-Dec:MOVE-TO-TOP().

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _matchFieldHandle sObject 
PROCEDURE _matchFieldHandle PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Look in the field group for the fill-in widget to get the handle
  Parameters:  <none>
  Notes:       Looks for a field of the specified name to set the handle
------------------------------------------------------------------------------*/
DEFINE VARIABLE lv-field AS HANDLE NO-UNDO.

RUN _walkTree(hParent,cFieldName,"DECIMAL,INTEGER":U,OUTPUT lv-field).

IF VALID-HANDLE(lv-field) 
THEN 
    RUN setFieldHandle(lv-field).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _syncSpinState sObject 
PROCEDURE _syncSpinState :
/*------------------------------------------------------------------------------
  Purpose:     Synchronize Spin Button Senstivity to field sensitivity
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF VALID-HANDLE(hField)
THEN
    ASSIGN hBtn-Inc:SENSITIVE = hField:SENSITIVE
           hBtn-Dec:SENSITIVE = hField:SENSITIVE
           FRAME {&FRAME-NAME}:SENSITIVE = hField:SENSITIVE
           lKeepState = TRUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE _walkTree sObject 
PROCEDURE _walkTree :
/*------------------------------------------------------------------------------
  Purpose:     Walks the widget-tree looking or a field of the specified type
  Parameters:  Start-point handle: a window, frame or field-group
  Notes:       When it finds a match by name, it type-checks. If the type
               matches, returns the handle. The data-type is a comma-separated
               list of data types that you want to match against.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER ip-handle AS HANDLE NO-UNDO.

DEFINE INPUT PARAMETER ip-field-name AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER ip-data-types AS CHARACTER NO-UNDO.

DEFINE OUTPUT PARAMETER op-handle AS HANDLE NO-UNDO.

DO WHILE VALID-HANDLE(ip-handle):

    /* If we come across a container, then process it recursively */
    IF CAN-DO("WINDOW,FRAME,FIELD-GROUP":U,ip-handle:TYPE) 
    THEN DO:
        RUN _walkTree(ip-handle:FIRST-CHILD,ip-field-name,ip-data-types, OUTPUT op-handle).

        IF VALID-HANDLE(op-handle) THEN LEAVE.
    END.

    /* Otherwise, examine the field. Leave if it's valid or get the next field
       in the list.
    */
    ELSE
        IF ip-handle:NAME = ip-field-name 
        AND CAN-DO(ip-data-types,ip-handle:DATA-TYPE) 
        THEN DO:
            ASSIGN op-handle = ip-handle.
            LEAVE.
        END.

    ASSIGN ip-handle = ip-handle:NEXT-SIBLING.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

