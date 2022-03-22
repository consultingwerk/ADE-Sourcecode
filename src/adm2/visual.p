&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************
* Copyright (C) 2005,2010 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*--------------------------------------------------------------------------
    File        : visual.p
    Purpose     : Code common to all objects with a visualization, including
                  Viewers, Browsers, Windows, and Frames

    Syntax      : adm2/visual.p

    Modified    : May 19, 1999 Version 9.1A
    Modified    : 11/14/2001          Mark Davies (MIP)
                  Renamed property 'DisplayFieldsSecurity' to 'FieldSecurity'
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Tell visattr.i that this is the Super procedure. */
   &SCOP ADMSuper visual.p
   
   {src/adm2/custom/visualexclcustom.i}
  
DEFINE VARIABLE giColor3DFace          AS INTEGER    NO-UNDO.
DEFINE VARIABLE giColor3DHighLight     AS INTEGER    NO-UNDO.
DEFINE VARIABLE giColor3DShadow        AS INTEGER    NO-UNDO.

&SCOPED-DEFINE COLOR_3DFACE      15
&SCOPED-DEFINE COLOR_3DSHADOW    16
&SCOPED-DEFINE COLOR_3DHIGHLIGHT 20

/* External Procedure Declaration */
PROCEDURE GetSysColor EXTERNAL "USER32.DLL" :
    DEFINE INPUT  PARAMETER iIndex  AS LONG NO-UNDO.
    DEFINE RETURN PARAMETER iRGB    AS LONG NO-UNDO.
END PROCEDURE.

/* This delimiter used for Repository objects; primarily on the cacheObject
 * EventValues and AttrValues fields.
 */
&SCOPED-DEFINE Value-Delimiter CHR(1)

/** This pre-processor is used to save space, since the section editor limits
 *  are exceeded when this code is included, as it is repeated for each event
 *  that is added. This pre-processor is used in createUiEvents.
 *  ----------------------------------------------------------------------- **/
&SCOPED-DEFINE RUN-PROCESS-EVENT-PROCEDURE ~
RUN processEventProcedure IN TARGET-PROCEDURE ( INPUT ENTRY((4 * iLoop + 1)    , cEventValues, {&Value-Delimiter}),  /* RUN/PUBLISH */~
                                                INPUT ENTRY((4 * iLoop + 1) + 2, cEventValues, {&Value-Delimiter}),  /* The procedure to RUN or PUBLISH */~
                                                INPUT ENTRY((4 * iLoop + 1) + 1, cEventValues, {&Value-Delimiter}),  /* SELF,CONTAINER,ANYWHERE */ ~
                                                INPUT ENTRY((4 * iLoop + 1) + 3, cEventValues, {&Value-Delimiter}) ) /* Parameters */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-applyFocusToFrame) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD applyFocusToFrame Procedure 
FUNCTION applyFocusToFrame RETURNS LOGICAL
  ( phFrame AS HANDLE,
    pcField AS CHAR,
    pcFrameList AS CHAR,
    pcObjectList AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignFocusedWidget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignFocusedWidget Procedure 
FUNCTION assignFocusedWidget RETURNS LOGICAL
  ( INPUT pcName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignWidgetValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignWidgetValue Procedure 
FUNCTION assignWidgetValue RETURNS LOGICAL
  ( INPUT pcName  AS CHARACTER,
    INPUT pcValue AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignWidgetValueList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignWidgetValueList Procedure 
FUNCTION assignWidgetValueList RETURNS LOGICAL
  ( INPUT pcNameList  AS CHARACTER,
    INPUT pcValueList AS CHARACTER,
    INPUT pcDelimiter AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-blankWidget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD blankWidget Procedure 
FUNCTION blankWidget RETURNS LOGICAL
  ( INPUT pcNameList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-clearWidget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD clearWidget Procedure 
FUNCTION clearWidget RETURNS LOGICAL
  ( INPUT pcNameList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createDynamicColor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createDynamicColor Procedure 
FUNCTION createDynamicColor RETURNS INTEGER
  ( pcName AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createUiEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createUiEvents Procedure 
FUNCTION createUiEvents RETURNS LOGICAL
    ( /* No parameters */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyPopups) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD destroyPopups Procedure 
FUNCTION destroyPopups RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-disableRadioButton) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD disableRadioButton Procedure 
FUNCTION disableRadioButton RETURNS LOGICAL
  ( INPUT pcNameList  AS CHARACTER,
    INPUT piButtonNum AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-disableWidget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD disableWidget Procedure 
FUNCTION disableWidget RETURNS LOGICAL
  ( INPUT pcNameList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-enableRadioButton) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD enableRadioButton Procedure 
FUNCTION enableRadioButton RETURNS LOGICAL
  ( INPUT pcNameList  AS CHARACTER,
    INPUT piButtonNum AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-enableWidget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD enableWidget Procedure 
FUNCTION enableWidget RETURNS LOGICAL
  ( INPUT pcNameList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fieldSecurityRule) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fieldSecurityRule Procedure 
FUNCTION fieldSecurityRule RETURNS CHARACTER
  ( phWidget AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-formattedWidgetValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD formattedWidgetValue Procedure 
FUNCTION formattedWidgetValue RETURNS CHARACTER
  ( INPUT pcName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-formattedWidgetValueList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD formattedWidgetValueList Procedure 
FUNCTION formattedWidgetValueList RETURNS CHARACTER
  ( INPUT pcNameList  AS CHARACTER,
    INPUT pcDelimiter AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAllFieldHandles) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAllFieldHandles Procedure 
FUNCTION getAllFieldHandles RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAllFieldNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAllFieldNames Procedure 
FUNCTION getAllFieldNames RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBGColor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBGColor Procedure 
FUNCTION getBGColor RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCol) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCol Procedure 
FUNCTION getCol RETURNS DECIMAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getColor3DFace) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getColor3DFace Procedure 
FUNCTION getColor3DFace RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getColor3DHighLight) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getColor3DHighLight Procedure 
FUNCTION getColor3DHighLight RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getColor3DShadow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getColor3DShadow Procedure 
FUNCTION getColor3DShadow RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getColorErrorBG) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getColorErrorBG Procedure 
FUNCTION getColorErrorBG RETURNS INTEGER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getColorErrorFG) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getColorErrorFG Procedure 
FUNCTION getColorErrorFG RETURNS INTEGER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getColorInfoBG) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getColorInfoBG Procedure 
FUNCTION getColorInfoBG RETURNS INTEGER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getColorInfoFG) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getColorInfoFG Procedure 
FUNCTION getColorInfoFG RETURNS INTEGER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getColorWarnBG) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getColorWarnBG Procedure 
FUNCTION getColorWarnBG RETURNS INTEGER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getColorWarnFG) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getColorWarnFG Procedure 
FUNCTION getColorWarnFG RETURNS INTEGER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDefaultLayout) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDefaultLayout Procedure 
FUNCTION getDefaultLayout RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDisableOnInit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDisableOnInit Procedure 
FUNCTION getDisableOnInit RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getEnabledObjFlds) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getEnabledObjFlds Procedure 
FUNCTION getEnabledObjFlds RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getEnabledObjHdls) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getEnabledObjHdls Procedure 
FUNCTION getEnabledObjHdls RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFGColor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFGColor Procedure 
FUNCTION getFGColor RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldPopupMapping) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFieldPopupMapping Procedure 
FUNCTION getFieldPopupMapping RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldSecurity) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFieldSecurity Procedure 
FUNCTION getFieldSecurity RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFont) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFont Procedure 
FUNCTION getFont RETURNS INTEGER
(  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getHeight) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getHeight Procedure 
FUNCTION getHeight RETURNS DECIMAL
    (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLayoutOptions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLayoutOptions Procedure 
FUNCTION getLayoutOptions RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLayoutVariable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLayoutVariable Procedure 
FUNCTION getLayoutVariable RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMinHeight) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getMinHeight Procedure 
FUNCTION getMinHeight RETURNS DECIMAL
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMinWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getMinWidth Procedure 
FUNCTION getMinWidth RETURNS DECIMAL
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectEnabled) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjectEnabled Procedure 
FUNCTION getObjectEnabled RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectLayout) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjectLayout Procedure 
FUNCTION getObjectLayout RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectSecured) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjectSecured Procedure 
FUNCTION getObjectSecured RETURNS LOGICAL
    (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectTranslated) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjectTranslated Procedure 
FUNCTION getObjectTranslated RETURNS LOGICAL
    (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPopupButtonsInFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPopupButtonsInFields Procedure 
FUNCTION getPopupButtonsInFields RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getResizeHorizontal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getResizeHorizontal Procedure 
FUNCTION getResizeHorizontal RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getResizeVertical) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getResizeVertical Procedure 
FUNCTION getResizeVertical RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRow Procedure 
FUNCTION getRow RETURNS DECIMAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSecuredTokens) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSecuredTokens Procedure 
FUNCTION getSecuredTokens RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUseWidgetID) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUseWidgetID Procedure 
FUNCTION getUseWidgetID RETURNS LOGICAL
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getWidth Procedure 
FUNCTION getWidth RETURNS DECIMAL
    (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hideWidget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD hideWidget Procedure 
FUNCTION hideWidget RETURNS LOGICAL
  ( INPUT pcNameList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-highlightWidget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD highlightWidget Procedure 
FUNCTION highlightWidget RETURNS LOGICAL
  ( INPUT pcNameList AS CHARACTER,
    INPUT pcHighlightType AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-internalWidgetHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD internalWidgetHandle Procedure 
FUNCTION internalWidgetHandle RETURNS HANDLE
  ( INPUT pcField AS CHARACTER,
    INPUT pcSearchMode AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-popupHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD popupHandle Procedure 
FUNCTION popupHandle RETURNS HANDLE
  ( pcField AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resetWidgetValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD resetWidgetValue Procedure 
FUNCTION resetWidgetValue RETURNS LOGICAL
  ( INPUT pcNameList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-sensitizePopup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD sensitizePopup Procedure 
FUNCTION sensitizePopup RETURNS LOGICAL
  ( phField     AS HANDLE,
    plSensitive AS LOG )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-sensitizeRadioButton) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD sensitizeRadioButton Procedure 
FUNCTION sensitizeRadioButton RETURNS LOGICAL
  ( INPUT pcNameList  AS CHARACTER,
    INPUT piButtonNum AS INTEGER,
    INPUT plEnable    AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAllFieldHandles) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAllFieldHandles Procedure 
FUNCTION setAllFieldHandles RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAllFieldNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAllFieldNames Procedure 
FUNCTION setAllFieldNames RETURNS LOGICAL
  ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBGColor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBGColor Procedure 
FUNCTION setBGColor RETURNS LOGICAL
 ( piBGColor AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setColorErrorBG) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setColorErrorBG Procedure 
FUNCTION setColorErrorBG RETURNS LOGICAL
  ( piColor AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setColorErrorFG) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setColorErrorFG Procedure 
FUNCTION setColorErrorFG RETURNS LOGICAL
  ( piColor AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setColorInfoBG) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setColorInfoBG Procedure 
FUNCTION setColorInfoBG RETURNS LOGICAL
  ( piColor AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setColorInfoFG) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setColorInfoFG Procedure 
FUNCTION setColorInfoFG RETURNS LOGICAL
  ( piColor AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setColorWarnBG) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setColorWarnBG Procedure 
FUNCTION setColorWarnBG RETURNS LOGICAL
  ( piColor AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setColorWarnFG) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setColorWarnFG Procedure 
FUNCTION setColorWarnFG RETURNS LOGICAL
  ( piColor AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDefaultLayout) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDefaultLayout Procedure 
FUNCTION setDefaultLayout RETURNS LOGICAL
  ( pcDefault AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDisableOnInit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDisableOnInit Procedure 
FUNCTION setDisableOnInit RETURNS LOGICAL
  ( plDisable AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setEnabledObjFlds) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setEnabledObjFlds Procedure 
FUNCTION setEnabledObjFlds RETURNS LOGICAL
    ( pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setEnabledObjHdls) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setEnabledObjHdls Procedure 
FUNCTION setEnabledObjHdls RETURNS LOGICAL
  ( pcHdls AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFGColor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFGColor Procedure 
FUNCTION setFGColor RETURNS LOGICAL
( piFGColor AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFieldPopupMapping) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFieldPopupMapping Procedure 
FUNCTION setFieldPopupMapping RETURNS LOGICAL
  ( pcFieldPopupMapping AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFieldSecurity) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFieldSecurity Procedure 
FUNCTION setFieldSecurity RETURNS LOGICAL
  ( pcSecurityType AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFont) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFont Procedure 
FUNCTION setFont RETURNS LOGICAL
( piFont AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLayoutOptions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLayoutOptions Procedure 
FUNCTION setLayoutOptions RETURNS LOGICAL
  ( pcOptions AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setMinHeight) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setMinHeight Procedure 
FUNCTION setMinHeight RETURNS LOGICAL
    ( INPUT pdHeight            AS DECIMAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setMinWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setMinWidth Procedure 
FUNCTION setMinWidth RETURNS LOGICAL
    ( INPUT pdWidth            AS DECIMAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setObjectLayout) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setObjectLayout Procedure 
FUNCTION setObjectLayout RETURNS LOGICAL
  ( pcLayout AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setObjectSecured) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setObjectSecured Procedure 
FUNCTION setObjectSecured RETURNS LOGICAL
  ( plSecured as logical )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setObjectTranslated) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setObjectTranslated Procedure 
FUNCTION setObjectTranslated RETURNS LOGICAL
  ( plValue as logical )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPopupButtonsInFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPopupButtonsInFields Procedure 
FUNCTION setPopupButtonsInFields RETURNS LOGICAL
  ( plPopupButtonsInFields AS LOG )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setResizeHorizontal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setResizeHorizontal Procedure 
FUNCTION setResizeHorizontal RETURNS LOGICAL
  ( INPUT plResizeHorizontal AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setResizeVertical) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setResizeVertical Procedure 
FUNCTION setResizeVertical RETURNS LOGICAL
  ( INPUT plResizeVertical AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSecuredTokens) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSecuredTokens Procedure 
FUNCTION setSecuredTokens RETURNS LOGICAL
    ( pcSecuredTokens AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setWidgetID) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setWidgetID Procedure 
FUNCTION setWidgetID RETURNS LOGICAL
        (INPUT piWidgetID AS INTEGER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-toggleWidget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD toggleWidget Procedure 
FUNCTION toggleWidget RETURNS LOGICAL
  ( INPUT pcNameList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-viewWidget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD viewWidget Procedure 
FUNCTION viewWidget RETURNS LOGICAL
  ( INPUT pcNameList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-widgetHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD widgetHandle Procedure 
FUNCTION widgetHandle RETURNS HANDLE
  ( INPUT pcName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-widgetIsBlank) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD widgetIsBlank Procedure 
FUNCTION widgetIsBlank RETURNS LOGICAL
  ( pcNameList AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-widgetIsFocused) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD widgetIsFocused Procedure 
FUNCTION widgetIsFocused RETURNS LOGICAL
  ( INPUT pcName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-widgetIsModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD widgetIsModified Procedure 
FUNCTION widgetIsModified RETURNS LOGICAL
  ( INPUT pcNameList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-widgetIsTrue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD widgetIsTrue Procedure 
FUNCTION widgetIsTrue RETURNS LOGICAL
  ( INPUT pcName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-widgetLongcharValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD widgetLongcharValue Procedure 
FUNCTION widgetLongcharValue RETURNS LONGCHAR
  ( INPUT pcName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-widgetName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD widgetName Procedure 
FUNCTION widgetName RETURNS CHARACTER
           ( phField AS HANDLE ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-widgetValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD widgetValue Procedure 
FUNCTION widgetValue RETURNS CHARACTER
  ( INPUT pcName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-widgetValueList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD widgetValueList Procedure 
FUNCTION widgetValueList RETURNS CHARACTER
  ( INPUT pcNameList  AS CHARACTER,
    INPUT pcDelimiter AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 20.24
         WIDTH              = 62.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/visprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

RUN initWinColors IN TARGET-PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-applyLayout) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyLayout Procedure 
PROCEDURE applyLayout :
/*------------------------------------------------------------------------------
  Purpose:     Apply the value of the Layout Attribute. This changes the
               object display to an alternate layout when multiple layouts
               have been defined for the object.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cLayout    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cLayoutVar AS CHARACTER NO-UNDO.
  
  /* Get the layout name. */
  &SCOPED-DEFINE xp-assign
  {get ObjectLayout cLayout}
  {get LayoutVariable cLayoutVar}.
  &UNDEFINE xp-assign
  IF cLayout eq ? THEN cLayout = "":U.
  
  /* A blank cLayout means return to the Default-Layout. If there is
     no default-layout, then return to the Master Layout. */

  IF cLayout eq "":U THEN DO:
    {get defaultLayout cLayout}.
    IF cLayout eq ? THEN cLayout = "":U.
    IF cLayout eq "":U THEN cLayout = "Master Layout":U.
  END. /* IF cLayout eq ... */
  
  /* Does the layout REALLY need changing, or is it already in use? */
  
  IF cLayoutVar ne cLayout THEN DO:
    /* Always change layouts by FIRST resetting to the Master Layout. 
       (assuming that the layout isn't already the Master.) */
    IF cLayoutVar ne "Master Layout":U THEN 
      RUN VALUE(cLayoutVar + "s":U) IN TARGET-PROCEDURE ("Master Layout":U).
    /* Now change to the desired layout. */
    IF cLayout ne "Master Layout":U THEN 
      RUN VALUE(cLayoutVar + "s":U) IN TARGET-PROCEDURE (cLayout).
    /* NOTE: DISPLAY-FIELDS NEEDS A VALUE LIST ARGUMENT 
    RUN displayFields IN TARGET-PROCEDURE ("").  /* redisplay any newly viewed fields. */
    */
  END. /* IF...LAYOUT...ne cLayout... */

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createObjects Procedure 
PROCEDURE createObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lUseRepository              AS LOGICAL              NO-UNDO.
    
  {get UseRepository lUseRepository}.

  IF lUseRepository THEN
    {fn createUiEvents} NO-ERROR.

  RUN updateFieldProperties IN TARGET-PROCEDURE.
  
  {set ObjectsCreated true}.
  
  RETURN.
END PROCEDURE.  /* createObjects */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject Procedure 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  {fn destroyPopups}.

  RUN SUPER NO-ERROR.  
  IF ERROR-STATUS:ERROR OR RETURN-VALUE = "ADM-ERROR":U THEN
      RETURN ERROR "ADM-ERROR":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-disableObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disableObject Procedure 
PROCEDURE disableObject :
/* -----------------------------------------------------------------------------
      Purpose:     Disables all enabled objects in the frame.
                   Note that this includes RowObject fields if any.
      Parameters:  <none>
      Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cEnabledObjHdls AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iField          AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hField          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lObjectHidden   AS LOGICAL    NO-UNDO.  

  {get EnabledObjHdls cEnabledObjHdls}.
  IF cEnabledObjHdls NE "":U THEN
  DO iField = 1 TO NUM-ENTRIES(cEnabledObjHdls):
     hField = WIDGET-HANDLE(ENTRY(iField, cEnabledObjHdls)).

     /* Cater for local SDF's */
     IF hField:TYPE EQ "PROCEDURE":U THEN
     DO:
         {get ObjectHidden lObjectHidden}.
         IF NOT lObjectHidden THEN
             RUN DisableField IN hField.
     END. /* Procedure: SDF */
     ELSE /* Skip fields hidden for multi-layout etc.*/
     IF CAN-SET(hField, "HIDDEN":U) 
     AND NOT hField:HIDDEN THEN 
     DO:
       hField:SENSITIVE = NO.
       DYNAMIC-FUNCTION('sensitizePopup':U IN TARGET-PROCEDURE,
                         hField, NO).
     END.
  END.   /* END DO iField */
    
  RUN disableFields IN TARGET-PROCEDURE ("ALL":U) NO-ERROR.
  {set ObjectEnabled no}.
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-enableObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableObject Procedure 
PROCEDURE enableObject :
/* -----------------------------------------------------------------------------
      Purpose:    Enable an object - all components except RowObject fields,
                  which are enabled using EnableFields().
      Parameters:  <none>
      Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cAllFieldHandles AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cEnabledObjHdls  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cSecuredFields   AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE iField           AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iFieldPos        AS INTEGER    NO-UNDO.
    DEFINE VARIABLE hField           AS HANDLE     NO-UNDO.
    DEFINE VARIABLE lObjectHidden    AS LOGICAL    NO-UNDO.
    
    &SCOPED-DEFINE xp-assign
    {get FieldSecurity cSecuredFields}
    {get AllFieldHandles cAllFieldHandles}
    {get EnabledObjHdls cEnabledObjHdls}.
    &UNDEFINE xp-assign

    IF cEnabledObjHdls NE "":U THEN
    DO iField = 1 TO NUM-ENTRIES(cEnabledObjHdls):
      ASSIGN 
        hField    = WIDGET-HANDLE(ENTRY(iField, cEnabledObjHdls))
        iFieldPos = 0
        iFieldPos = LOOKUP(STRING(hField),cAllFieldHandles).

      IF VALID-HANDLE(hField) THEN 
      DO:
        /* Cater for local SDF's */
        IF hField:TYPE EQ "PROCEDURE":U THEN
        DO:
          {get ObjectHidden lObjectHidden hField}.
          IF NOT lObjectHidden 
          AND (((iFieldPos <> 0 
                 AND NUM-ENTRIES(cSecuredFields) >= iFieldPos 
                 AND ENTRY(iFieldPos,cSecuredFields) = "":U) 
                OR iFieldPos = 0) 
               OR cSecuredFields = "":U) THEN /* Check Security */                  
            RUN enableField IN hField.
          ELSE DO:
            IF NUM-ENTRIES(cSecuredFields) >= iFieldPos THEN
            DO:
              IF ENTRY(iFieldPos,cSecuredFields) = "Hidden":U THEN
                RUN hideObject IN hField NO-ERROR.
              ELSE IF ENTRY(iFieldPos,cSecuredFields) <> "":U THEN
                RUN disableField IN hField NO-ERROR.
            END.
          END.
        END. /* Procedure: SDF */
        ELSE 
        IF (CAN-SET(hField, "HIDDEN":U) AND NOT hField:HIDDEN) 
        AND (((iFieldPos <> 0 
               AND NUM-ENTRIES(cSecuredFields) >= iFieldPos 
               AND ENTRY(iFieldPos,cSecuredFields) = "":U) 
              OR iFieldPos = 0) 
             OR cSecuredFields = "":U) THEN  
        DO:
          hField:SENSITIVE = YES.
          IF hField:TYPE = "EDITOR":U THEN /* Ed's must be sensitive, not R-O*/
            hField:READ-ONLY = NO.          
          /* don't enable if read-only (can-query is ok as only fields can 
             have popups) */
          IF CAN-QUERY(hField,'read-only':U) AND NOT hField:READ-ONLY THEN
            DYNAMIC-FUNCTION('sensitizePopup':U IN TARGET-PROCEDURE,
                              hField, YES).
        END.
      END. /* If hField is a valid-handle */
    END.    /* loop thorough handles */

    {set ObjectEnabled yes}.  

    /* We also run enable_UI from here. */ 
    RUN enable_UI IN TARGET-PROCEDURE NO-ERROR.
    
    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:  Initialization code specific to visualizations.
   Params:  <none>
    Notes:  Enables and views the object depending on the values of 
            DisableOnInit and HideOnInit instance properties.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lHideOnInit        AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lDisableOnInit     AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cLayout            AS CHARACTER NO-UNDO. 
  DEFINE VARIABLE hContainer         AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hParent            AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cSource            AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hSource            AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cResult            AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lResult            AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lCreated           AS LOGICAL    NO-UNDO.
  define variable cObjectType       as character   no-undo.
    
  /* createObjects for visual mainly class builds property lists 
     most extended classes will already have created objects at this stage */ 
  {get ObjectsCreated lCreated}.
  /* unknown not really supported, but only skip if really TRUE..  */
  IF NOT (lCreated = YES) THEN
     RUN createObjects IN TARGET-PROCEDURE.

  RUN SUPER.
 
  IF RETURN-VALUE = "ADM-ERROR":U THEN 
    RETURN "ADM-ERROR":U.

  /* Skip all intiialization except viewing in design mode. */
  {get UIBMode cResult}.
  IF cResult BEGINS "Design":U THEN
  DO:
    RUN viewObject IN TARGET-PROCEDURE.
    RETURN.                      
  END.       /* END DO design mode */
   
  /* Set the procedure's CURRENT-WINDOW to its parent window container
     (which may be several levels up). This will assure correct parenting
     of alert boxes, etc. */
  &scoped-define xp-Assign     
  {get ContainerHandle hContainer}
  {get ObjectType cObjectType}.  
  &undefine xp-Assign
  IF NOT VALID-HANDLE(hContainer) THEN
    RETURN.  /* If no container then skip all visual initialization. */
 
  hParent = hContainer.
  DO WHILE VALID-HANDLE(hParent:PARENT) AND hParent:TYPE NE "WINDOW":U:
    hParent = hParent:PARENT.
  END.
  
  IF VALID-HANDLE(hParent) AND hParent:TYPE = "WINDOW":U THEN
    TARGET-PROCEDURE:CURRENT-WINDOW = hParent.
    
  /* The visual class takes care of viewing and enabling all non-window-like
     objects; things like viewers, browsers etc. 
     
     The container class takes care of enabling and viewing window-like
     containers (SmartWindows, SmartFrames, SmartDialogs).
     
     The visual class shouldn't visualise window-like containers since
     they need their visualisation deferred, until it's time, according
     to the containr class.
     
     We check the ObjectType of the object, since checking the container
     handle's type is not guaranteed: we only need to do this for window-like
     containers, like windows, dialogs and contained smartframes. We don't 
     want to do it for dynamic viewers etc, which have FRAMEs as their
     container handles (just like Dialogues or SmartFrames).
  */
  if not can-do('SmartWindow,SmartFrame,SmartDialog', cObjectType) then
  DO:
    {get DisableOnInit lDisableOnInit}.   
    IF NOT lDisableOnInit THEN
      RUN enableObject IN TARGET-PROCEDURE. 
  END.

   /* Before Viewing, change the object to the correct layout
     if there are multiple layouts.  */
  {get LayoutVariable cLayout}.
  IF cLayout NE "":U THEN
  DO:
    {get ObjectLayout cLayout}.
    IF cLayout NE "":U THEN 
      RUN applyLayout IN TARGET-PROCEDURE.
    ELSE DO:  
      {get defaultLayout cLayout}.
      IF cLayout ne "":U THEN DO:
        {set ObjectLayout cLayout}.
        RUN applyLayout IN TARGET-PROCEDURE. 
      END.   /* END DO IF NE "" */
    END.     /* END ELSE DO     */
  END.       /* END DO IF LayoutVariable */
  
  /* See comments above. */
  if not can-do('SmartWindow,SmartFrame,SmartDialog':U, cObjectType) then      
  DO:
    {get HideOnInit lHideOnInit}.
    IF NOT lHideOnInit THEN 
      RUN viewObject IN TARGET-PROCEDURE.
    ELSE 
      PUBLISH "LinkState":U FROM TARGET-PROCEDURE ('inactive':U).
  END.
  
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initWinColors) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initWinColors Procedure 
PROCEDURE initWinColors :
/*------------------------------------------------------------------------------
  Purpose:  Defines 3D colors dynamically    
  Parameters:  <none>
  Notes:    These are class properties so this is run from the main block    
------------------------------------------------------------------------------*/
  giColor3DFace = {fnarg createDynamicColor 'Color3DFace':U}.
  IF giColor3DFace = ? THEN
    giColor3DFace = 8. /* default to Grey */
  
  giColor3DHighLight = {fnarg createDynamicColor 'Color3DHighLight':U}.
  IF giColor3DHighLight = ? THEN
    giColor3DHighLight = 15. /* default to White */

  giColor3DShadow = {fnarg createDynamicColor 'Color3DShadow':U}.
  IF giColor3DShadow = ? THEN
    giColor3DShadow = 7. /* default to DarkGrey */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-locateWidget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE locateWidget Procedure 
PROCEDURE locateWidget :
/*------------------------------------------------------------------------------
  Purpose:     Locates a widget and retuns its handle and the handle of its
               TARGET-PROCEDURE
  Parameters:  pcWidget AS CHARACTER
               phWidget AS HANDLE
               phTarget AS HANDLE
  Notes:       Support for locating widgets by instance name and 
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcWidget AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER phWidget AS HANDLE     NO-UNDO.
DEFINE OUTPUT PARAMETER phTarget AS HANDLE     NO-UNDO.

DEFINE VARIABLE cDataObjectNames   AS CHARACTER  NO-UNDO. 
DEFINE VARIABLE cDataObjectType    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDataSourceNames   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDataTargets       AS CHARACTER  NO-UNDO. 
DEFINE VARIABLE cDisplayedFields   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cField             AS CHARACTER  NO-UNDO. 
DEFINE VARIABLE cInstanceName      AS CHARACTER  NO-UNDO. 
DEFINE VARIABLE cNameWOInstance    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cObjectName        AS CHARACTER  NO-UNDO. 
DEFINE VARIABLE cObjectType        AS CHARACTER  NO-UNDO. 
DEFINE VARIABLE cQualifier         AS CHARACTER  NO-UNDO. 
DEFINE VARIABLE cSDOField          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSDOQualifier      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTargets           AS CHARACTER  NO-UNDO. 
DEFINE VARIABLE cTargetObjectType  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cUpdateSources     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cUpdateTargetNames AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hContainer         AS HANDLE     NO-UNDO. 
DEFINE VARIABLE hDataTarget        AS HANDLE     NO-UNDO. 
DEFINE VARIABLE hTarget            AS HANDLE     NO-UNDO. 
DEFINE VARIABLE hUpdateSource      AS HANDLE     NO-UNDO. 
DEFINE VARIABLE iDataTarget        AS INTEGER    NO-UNDO. 
DEFINE VARIABLE iNumObjects        AS INTEGER    NO-UNDO.
DEFINE VARIABLE iTarget            AS INTEGER    NO-UNDO. 
DEFINE VARIABLE lBrowsed           AS LOGICAL    NO-UNDO. 
DEFINE VARIABLE lBrowseQualified   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lQueryObject       AS LOGICAL    NO-UNDO. 
DEFINE VARIABLE lTargetQueryObject AS LOGICAL    NO-UNDO.   

  IF NUM-ENTRIES(pcWidget, '.':U) > 1 THEN
    ASSIGN
      cInstanceName =   ENTRY(1, pcWidget, '.':U)
      cNameWOInstance = DYNAMIC-FUNCTION('deleteEntry':U IN TARGET-PROCEDURE,
                                          INPUT 1,
                                          INPUT pcWidget,
                                          INPUT '.':U). 
  
  /* Need to only get targets of this object if it is a real container of SmartObjects 
    (not a viewer that may contain SmartDataFields) */
  {get ObjectType cObjectType}.
  IF cObjectType NE 'SmartDataViewer':U THEN 
    cTargets = DYNAMIC-FUNCTION('linkHandles':U IN TARGET-PROCEDURE, 'Container-Target':U) NO-ERROR.
  IF cTargets = ? OR cTargets = '':U THEN 
  DO:
    {get ContainerSource hContainer} NO-ERROR.
    cTargets = DYNAMIC-FUNCTION('linkHandles':U IN hContainer, 'Container-Target':U) NO-ERROR.
  END.  /* if cTargets = ? - not a container */
  
  /* Search through targets for instance */
  DO iTarget = 1 TO NUM-ENTRIES(cTargets):
    hTarget = WIDGET-HANDLE(ENTRY(iTarget, cTargets)).
    {get ObjectName cObjectName hTarget}.
    IF cObjectName = cInstanceName THEN
    DO:
      {get QueryObject lQueryObject hTarget}.
      IF lQueryObject THEN 
      DO:
        &SCOPED-DEFINE xp-assign
        {get ObjectType cDataObjectType hTarget}
        {get DataTarget cDataTargets hTarget}
        {get DataQueryBrowsed lBrowsed hTarget}.
        &UNDEFINE xp-assign

        IF NUM-ENTRIES(cNameWOInstance, '.':U) > 1 AND
           ENTRY(1, cNameWOInstance, '.':U) = 'Browse':U THEN 
           ASSIGN 
             lBrowseQualified = TRUE
             cField = DYNAMIC-FUNCTION('deleteEntry':U IN TARGET-PROCEDURE,
                                        INPUT 1,
                                        INPUT cNameWOInstance,
                                        INPUT '.':U). 
        ELSE cField = cNameWOInstance.

        IF lBrowseQualified AND NOT lBrowsed THEN RETURN.

        IF cDataObjectType = 'SmartDataObject':U THEN
        DO:
          /* If not qualfied with "Browse", then attempt to locate widget in 
             the SDO's update source. */
          IF NOT lBrowseQualified THEN
          DO:
            {get UpdateSource hUpdateSource hTarget}.
            ASSIGN
              phWidget = DYNAMIC-FUNCTION('internalWidgetHandle':U IN hUpdateSource,
                                          INPUT cField, INPUT 'ALL':U)
              phTarget = hUpdateSource NO-ERROR.
            IF phWidget NE ? THEN RETURN.
          END.  /* if not browse qualified */          
          
          /* If the widget was not found in the update source or if it is 
             qualified with "Browse", then attempt to locate it within the data targets
             of the SDO (if Browse qualified then it only looks at SmartDataBrowser
             objects) */
          DO iDataTarget = 1 TO NUM-ENTRIES(cDataTargets):
            ASSIGN hDataTarget = WIDGET-HANDLE(ENTRY(iDataTarget, cDataTargets)) NO-ERROR.
            {get QueryObject lTargetQueryObject hDataTarget}.
            {get ObjectType cTargetObjectType hDataTarget}.
            IF VALID-HANDLE(hDataTarget) AND hDataTarget NE hTarget AND 
               NOT lTargetQueryObject THEN
            DO:
              IF (lBrowseQualified AND cTargetObjectType = 'SmartDataBrowser':U) OR
                  NOT lBrowseQualified THEN
              DO:
                ASSIGN
                  phWidget = DYNAMIC-FUNCTION('internalWidgetHandle':U IN hDataTarget,
                                              INPUT cField, INPUT 'ALL':U)
                  phTarget = hDataTarget NO-ERROR.
                IF phWidget NE ? THEN RETURN.
              END.  /* if field found */
            END.  /* if valid data target and not query object */           
          END.  /* do iDataTarget 1 to number data targets */
        END.  /* if SDO */
        ELSE DO:  /* SBO */
          IF NUM-ENTRIES(cField, '.':U) > 1 THEN
            ASSIGN 
              cSDOQualifier = ENTRY(1, cField, '.':U)
              cSDOField = DYNAMIC-FUNCTION('deleteEntry':U IN TARGET-PROCEDURE,
                                          INPUT 1,
                                          INPUT cField,
                                          INPUT '.':U). 
          ELSE RETURN.  /* SDO qualification is required for SBOs */

          /* If it is not qualified with "Browse", then it attempts to 
             locate the widget in the update sources of the SBO where the 
             update target name of those update sources matches the SDO qualifier. */
          IF NOT lBrowseQualified THEN
          DO:            
            {get UpdateSource cUpdateSources hTarget}.
            DO iNumObjects = 1 TO NUM-ENTRIES(cUpdateSources):
              hUpdateSource = WIDGET-HANDLE(ENTRY(iNumObjects, cUpdateSources)).

              {get UpdateTargetNames cUpdateTargetNames hUpdateSource}.
              IF LOOKUP(cSDOQualifier, cUpdateTargetNames) > 0 THEN
              DO:
                /* If the fields are qualified with SDO name in the visual object 
                   then search for them with the qualified name (cField). */
                {get DisplayedFields cDisplayedFields hUpdateSource}.
               IF INDEX(ENTRY(1, cDisplayedFields), '.':U) > 0 THEN cSDOField = cField.
                ASSIGN
                  phWidget = DYNAMIC-FUNCTION('internalWidgetHandle':U IN hUpdateSource,
                                              INPUT cSDOField, INPUT 'ALL':U)
                  phTarget = hUpdateSource NO-ERROR.
                IF phWidget NE ? THEN RETURN.
              END.  /* if qualifier (SDO) is the update target */            
            END.  /* do 1 to number update sources */
          END.  /* if not browse qualified */

          /* If the widget was not found in the update source of the SBO that
             mapped to the SDO qualifier, or if the widget is qualified with
             "Browse", then it attempts to locate the widget in the data 
             targets of the SBO where the data source name of those data 
             targets matches the SDO qualifier.  */
          {get DataTarget cDataTargets hTarget}.
          DO iNumObjects = 1 TO NUM-ENTRIES(cDataTargets):
            hDataTarget = WIDGET-HANDLE(ENTRY(iNumObjects, cDataTargets)).

            &SCOPED-DEFINE xp-assign
            {get DataSourceNames cDataSourceNames hDataTarget}
            {get ObjectType cTargetObjectType hDataTarget}.
            &UNDEFINE xp-assign
            IF (LOOKUP(cSDOQualifier, cDataSourceNames) > 0) AND
               ((lBrowseQualified AND cTargetObjectType = 'SmartDataBrowser':U) OR
                 NOT lBrowseQualified) THEN
            DO:
              /* If the fields are qualified with SDO name in the visual object 
                 then search for them with the qualified name (cField). */
              {get DisplayedFields cDisplayedFields hDataTarget}.
              IF INDEX(ENTRY(1, cDisplayedFields), '.':U) > 0 THEN cSDOField = cField.
              ASSIGN
                phWidget = DYNAMIC-FUNCTION('internalWidgetHandle':U IN hDataTarget,
                                            INPUT cSDOField, INPUT 'ALL':U)
                phTarget = hDataTarget NO-ERROR.
              IF phWidget NE ? THEN RETURN.
            END.  /* if qualifier (SDO) is the data source */
          END.  /* do 1 to number data target */ 
        END.  /* if SBO */
      END.  /* if query object */
      ELSE DO:  /* not query object - any other instance */
        ASSIGN 
          phWidget = DYNAMIC-FUNCTION('internalWidgetHandle':U IN hTarget,
                                       INPUT cNameWOInstance, 'ALL':U)
          phTarget = hTarget NO-ERROR.
        IF phWidget NE ? THEN RETURN.
      END.  /* if not query object */
    END.  /* if object = instance */
  END.  /* DO iTarget to number targets */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processAction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processAction Procedure 
PROCEDURE processAction :
/*------------------------------------------------------------------------------
  Purpose:     Generic procedure to process keyboard and mouse actions for
               visual objects.
  Parameters:  input name of action
  Notes:       Typically a generic event will be put in visualcustom.i that
               will run this procedure in order to do the work. It can not do the
               work nornmally itself as container handles, etc. are not valid
               yet. Also this keeps the code size down.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcAction               AS CHARACTER  NO-UNDO.

DEFINE VARIABLE hContainerSource              AS HANDLE     NO-UNDO.

  if pcAction = "Ctrl-page-up":U 
  or pcAction = "ctrl-page-down":U THEN
  do:
    /* the containersource overrides this for these events, so we know we're 
       not a container that can handle these events and can just pass it up to 
       our container source */
    {get containersource hContainerSource}.
    IF VALID-HANDLE(hContainerSource) THEN 
      run processAction in hContainerSource(pcAction).  
  end.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processEventProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processEventProcedure Procedure 
PROCEDURE processEventProcedure :
/*------------------------------------------------------------------------------
  Purpose:     Procedure called when a UI event is fired. This procedure will
               process the request according to the relevant parameters.
  Parameters:  pcActionType     - RUN/PUBLISH
               pcEventAction    - the name of the procedure to run. This must be a 
                                  procedure - not a function.
               pcActionTarget   - SELF,CONTAINER,ANYWHERE, ManagerCode
               pcEventParameter - a parameter to pass into the event procedure.
  Notes:       * Although this API should be used wiht a Dynamcis Repository 
                 connected, it may be possible to use without one.
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcActionType        AS CHARACTER            NO-UNDO.
    DEFINE INPUT  PARAMETER pcEventAction       AS CHARACTER            NO-UNDO.
    DEFINE INPUT  PARAMETER pcActionTarget      AS CHARACTER            NO-UNDO.
    DEFINE INPUT  PARAMETER pcEventParameter    AS CHARACTER            NO-UNDO.

    DEFINE VARIABLE hActionTarget           AS HANDLE                   NO-UNDO.

    CASE pcActionTarget:
        WHEN "SELF":U      THEN ASSIGN hActionTarget = TARGET-PROCEDURE.
        WHEN "CONTAINER":U THEN {get ContainerSource hActionTarget}.
        /* Run anywhere. This is only valid for an action type of PUB. */
        WHEN "ANYWHERE":U  THEN ASSIGN hActionTarget = ?.
        /* Run on the AppServer. This is only valid for an action type of RUN. */
        WHEN "AS":U        THEN ASSIGN hActionTarget = gshAstraAppServer.
        /* Managers: of the manager handle is used, we use the hard-coded,
         * predefined handle variables. Any managers which are referred
         * to by their manager name (i.e. CustomizationManager) will be
         * handled by the getManagerHandle API call performed elsewhere in
         * the case statement.
         * 
         * The manager handles are provided purely for backwards compatibility 
         * and should NOT be used at all.                                       */
        WHEN "GM":U        THEN ASSIGN hActionTarget = gshGenManager.
        WHEN "SM":U        THEN ASSIGN hActionTarget = gshSessionManager.
        WHEN "SEM":U       THEN ASSIGN hActionTarget = gshSecurityManager.
        WHEN "PM":U        THEN ASSIGN hActionTarget = gshProfileManager.
        WHEN "RM":U        THEN ASSIGN hActionTarget = gshRepositoryManager.
        WHEN "TM":U        THEN ASSIGN hActionTarget = gshTranslationManager.
        OTHERWISE               ASSIGN hActionTarget = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT pcActionTarget) NO-ERROR.
    END CASE.   /* action target */

    IF VALID-HANDLE(hActionTarget) THEN
    DO:
        IF pcActionType = "RUN":U THEN
        DO:
            IF pcEventParameter EQ "":U THEN
            DO:
               IF pcActionTarget EQ "AS":U THEN
                   RUN VALUE(pcEventAction) ON hActionTarget NO-ERROR.
               ELSE
                   RUN VALUE(pcEventAction) IN hActionTarget NO-ERROR.
            END.    /* no parameter */
            ELSE
            DO:
                IF pcActionTarget EQ "AS":U THEN
                    RUN VALUE(pcEventAction) ON hActionTarget ( INPUT pcEventParameter) NO-ERROR.
                ELSE
                    RUN VALUE(pcEventAction) IN hActionTarget ( INPUT pcEventParameter) NO-ERROR.
            END.    /* a parameter exists */
            
            /* if explicit ERROR returned from procedure then RETURN no-apply 
               in order to ignore the event. (Return NO-APPLY is not propagated 
               from the sub procedures. The ERROR do however also work in 
               persistent triggers so the event proc would still work if 
               processEventProcedure is removed and the triggers were defined 
               as persistent triggers directly on the widget) */ 
            IF ERROR-STATUS:ERROR THEN
            DO:
                ERROR-STATUS:ERROR = NO.
                /* Do NOT ignore the event if there is an error message.
                   This allows trigger code to use explicit RETURN ERROR
                   to stop the event, while errors left from find and run 
                   no-error etc. do not cause the event to be ignored. 
                   It also ensures that the trigger still fires if the event 
                   proc is missing. (yes, we can check get-message AFTER the 
                   error-status:error is set to no) */
                IF ERROR-STATUS:GET-MESSAGE(1) = '':U THEN
                    RETURN NO-APPLY.
            END.
        END.    /* run */
        ELSE
        DO:
            IF pcActionTarget EQ "ANYWHERE":U THEN
            DO:
                IF pcEventParameter = "":U THEN
                    PUBLISH pcEventAction.
                ELSE
                    PUBLISH pcEventAction ( INPUT pcEventParameter ).
            END.    /* anywhere */
            ELSE
            IF VALID-HANDLE(hActionTarget) THEN
            DO:
                IF pcEventParameter EQ "":U THEN
                    PUBLISH pcEventAction FROM hActionTarget.
                ELSE
                    PUBLISH pcEventAction FROM hActionTarget ( INPUT pcEventParameter).
            END.    /* not anywhere */
        END.    /* publish */
    END.    /* valid action target. */   

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
END PROCEDURE.  /* processEventProcedure */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateFieldProperties) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateFieldProperties Procedure 
PROCEDURE updateFieldProperties :
/*------------------------------------------------------------------------------
  Purpose: update field list properties     
  Parameters:  none 
  Notes: No processing takes place if AllFieldNames already is set. 
       - AllFieldHandles and AllFieldNames are both updated.  
       - EnabledObjFlds is set before this is called, but entries may be 
         removed if they are a non supported widget type.
       - EnabledObjHdls is set from EnabledObjFlds.               
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hFrame             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hField             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cObjectType        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEnabledObjFlds    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEnabledObjHdls    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAllFieldNames     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAllFieldHandles   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldName         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLocal             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hContainerSource   AS HANDLE     NO-UNDO.  
  DEFINE VARIABLE lPopupsinFields    AS LOGICAL    NO-UNDO.
  
  &SCOPED-DEFINE xp-assign
  {get AllFieldNames cAllFieldNames}
  {get EnabledObjFlds cEnabledObjFlds}
  {get ObjectType cObjectType}
  {get ContainerHandle hFrame}
  {get ContainerSource hContainerSource}
  {get PopupButtonsInFields lPopupsInFields}
  .
  &UNDEFINE xp-assign 
    
  
  /* If AllfieldNames is not already set then loop through the widget to build 
     the property lists. Viewers will build these properties and several other
     properties in their own widget loop in a createObjects override. */
  IF cAllFieldNames = '':U AND VALID-HANDLE(hFrame) THEN
  DO:
    /* If window then this is container class, so get the main frame */
    IF hFrame:TYPE = "WINDOW":U THEN
      {get WindowFrameHandle hFrame}.  

    IF VALID-HANDLE(hFrame) THEN
      ASSIGN
        hField           = hFrame:FIRST-CHILD:FIRST-CHILD
        /* The order of the lists of handles must match the order of the 
           DisplayedField and EnabledField properties, so initialise with the 
           current number of entries */
        cEnabledObjHdls  = FILL(",":U, NUM-ENTRIES(cEnabledObjFlds) - 1)
        .
 
    /* widgetloop */
    DO WHILE VALID-HANDLE(hField): 
      IF hField:TYPE <> 'FRAME':U THEN
      DO:
        ASSIGN
          cFieldName = hField:NAME 
          iLocal     = LOOKUP(cFieldName, cEnabledObjFlds).
                
        IF iLocal > 0 THEN
        DO:
          IF LOOKUP(hField:TYPE,"FILL-IN,RADIO-SET,COMBO-BOX,SELECTION-LIST,SLIDER,TOGGLE-BOX,BROWSE,BUTTON":U) > 0 
           /* if marked as read-only in design remove from enable list
             (Remember to add editor back in list above if this logic is 
              removed/changed..) */
          or (hField:type = 'EDITOR':U and hField:read-only = false) then 
            ENTRY(iLocal, cEnabledObjHdls) = STRING(hField).
          ELSE
            ASSIGN
              cEnabledObjFlds =  DYNAMIC-FUNCTION('deleteEntry' IN TARGET-PROCEDURE,
                                          iLocal,cEnabledObjFlds,',')
              cEnabledObjHdls = DYNAMIC-FUNCTION('deleteEntry' IN TARGET-PROCEDURE,
                                          iLocal,cEnabledObjHdls,',').
        END.
        /* Editor is always sensitive (false is useless - affects scrollbars)
           and use read-only as disabled */ 
        IF hField:TYPE = 'EDITOR':U then
          assign
            hField:SENSITIVE = true
            hField:READ-ONLY = TRUE. /* initialize disabled */
               
        /* Anonymous widgets are not allowed (labels) */
        IF cFieldName > '' THEN
          ASSIGN
            cAllFieldNames   = cAllFieldnames + ',' + cFieldName 
            cAllFieldHandles = cAllFieldHandles + ',' + STRING(hField). 
      END. /* not a frame */
      else if valid-handle(gshSessionManager) then 
        /* widgetwalk non smart frames on this objects frame  */ 
        RUN widgetWalk IN gshSessionManager (hContainerSource, 
                                             TARGET-PROCEDURE, 
                                             hField, 
                                             "setup":U,
                                             lPopupsInFields).  
           
      hField = hField:NEXT-SIBLING.
    END. /* do while */   
    
    ASSIGN
      cAllFieldNames   = TRIM(cAllFieldNames,",")
      cAllFieldHandles = TRIM(cAllFieldHandles,",").
  
    /* Store the properties */
    &SCOPED-DEFINE xp-assign
    {set EnabledObjFlds cEnabledObjFlds}
    {set EnabledObjHdls cEnabledObjHdls}
    {set AllFieldHandles cAllFieldHandles}
    {set AllFieldNames cAllFieldNames}
    .
    &UNDEFINE xp-assign
    /*  do the widget walk */
    IF VALID-HANDLE(gshSessionManager) THEN 
      RUN widgetWalk IN gshSessionManager (hContainerSource, 
                                           TARGET-PROCEDURE, 
                                           hFrame, 
                                           "setup":U,
                                           lPopupsInFields).
  END. /* if allfieldnames = '' */
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-applyFocusToFrame) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION applyFocusToFrame Procedure 
FUNCTION applyFocusToFrame RETURNS LOGICAL
  ( phFrame AS HANDLE,
    pcField AS CHAR,
    pcFrameList AS CHAR,
    pcObjectList AS CHAR ) :
/*------------------------------------------------------------------------------
    Purpose: Override the smart utility to look for field name. 
             Applies focus ("entry") to the specified or first tab 
             item in the passed frame, including possible child frames and 
             optionally through the child objects that owns the frame.   
 Parameters:
  phFrame      - frame handle to check
  pcField      - field name of widget to apply entry to 
               - blank or ? means find first tab item. 
  pcFrameList  - List of frame handles that belongs to SmartObjects.   
  pcObjectList - List of objects that corresponds to the frame list.   
    Notes:   This is a frame level utility used by the object level applyFocus
             not really intended for direct calls. 
             Use applyFocus or run applyEntry.
           - Returns false also if a widget is found, but cannot be focused 
             because it is not visible or sensitive.        
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cAllFieldNames   AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cAllFieldHandles AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE iObject          AS INTEGER     NO-UNDO.
  DEFINE VARIABLE hObject          AS HANDLE      NO-UNDO.
 
  IF pcField > "":U then
  DO:
    {get AllFieldNames cAllFieldNames}.
    {get AllFieldHandles cAllFieldHandles}.
    iObject = LOOKUP(pcField,cAllFieldNames). 
    IF iObject > 0 THEN
    DO:
      hObject = WIDGET-HANDLE(ENTRY(iObject,cAllFieldHandles)).
      IF hObject:TYPE = "procedure":U THEN
      DO:
        if {fnarg applyFocus pcField hObject} then
          return TRUE.
      END.
      ELSE IF hObject:VISIBLE AND hObject:SENSITIVE THEN
      DO:
         APPLY "entry":U TO hObject.
         RETURN TRUE.
      END.
    END.
  END.
  RETURN SUPER(phFrame,pcField,pcFrameList,pcObjectList).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignFocusedWidget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignFocusedWidget Procedure 
FUNCTION assignFocusedWidget RETURNS LOGICAL
  ( INPUT pcName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Applies "ENTRY" to pcName
   Params:  INPUT pcName AS CHARACTER
    Notes:  Does not support SmartDataFields
------------------------------------------------------------------------------*/
DEFINE VARIABLE cValue     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hBuffer    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hField     AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTarget    AS HANDLE     NO-UNDO.
DEFINE VARIABLE lInvalid   AS LOGICAL    NO-UNDO.

  RUN locateWidget IN TARGET-PROCEDURE (INPUT pcName, OUTPUT hField, OUTPUT hTarget).
  IF VALID-HANDLE(hField) THEN
  DO:
    IF CAN-QUERY(hField, 'FILE-NAME':U) THEN 
      lInvalid = YES.
    ELSE 
      APPLY 'ENTRY':U TO hField.
  END.  /* if valid hField */
  ELSE lInvalid = YES.

  /* Return FALSE if field was invalid or not sensitive. */
  RETURN NOT lInvalid.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignWidgetValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignWidgetValue Procedure 
FUNCTION assignWidgetValue RETURNS LOGICAL
  ( INPUT pcName  AS CHARACTER,
    INPUT pcValue AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the SCREEN-VALUE of an object.
   Params:  INPUT pcName  AS CHARACTER
            INPUT pcValue AS CHARACTER
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE hBuffer          AS HANDLE     NO-UNDO.
DEFINE VARIABLE hField           AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTarget          AS HANDLE     NO-UNDO.
DEFINE VARIABLE lInvalid         AS LOGICAL    NO-UNDO.
  
  RUN locateWidget IN TARGET-PROCEDURE (INPUT pcName, OUTPUT hField, OUTPUT hTarget).
  IF VALID-HANDLE(hField) THEN
  DO:
    /* not allowed if secured  */       
    IF {fnarg fieldSecurityRule hField hTarget} > '':U THEN
      lInvalid = TRUE.

    /* This is a SmartDataField. Use its setDataValue method. */
    ELSE IF CAN-QUERY(hField, 'FILE-NAME':U) THEN
    DO:
      /* Workaround for Issue 9121 - setting the DataValue for a lookup who's 
         displayed field is not the same as its key field does not refresh
         the displayed field.  assignNewValue is used instead because this
         does refresh the displayed field but it is specific to lookups only.
         When Issue 9121 is fixed this code should be removed so that only
         set DataValue is done for all SmartDataFields.  */
      IF {fnarg Signature 'initializeLookup':U hField} NE '':U THEN 
      DO:
        RUN assignNewValue IN hField (INPUT pcValue, INPUT '':U, INPUT TRUE) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
          lInvalid = YES.
      END.  /* if dynLookup */
      ELSE DO:
        {set DataValue pcValue hField} NO-ERROR. 
        IF ERROR-STATUS:ERROR THEN
          lInvalid = YES.
        ELSE 
          {set DataModified TRUE hField} NO-ERROR.
      END.  /* else do */
    END.  /* if SmartDataField */
    ELSE IF CAN-SET(hField, 'SCREEN-VALUE':U) THEN  
    DO:
      hField:SCREEN-VALUE = pcValue NO-ERROR.
      IF ERROR-STATUS:ERROR THEN
        lInvalid = YES.
      ELSE 
        RUN fieldModified IN hTarget (hField) NO-ERROR.
    END.  /* if can set screen-value */
    ELSE lInvalid = YES.
    
  END.  /* if hField valid */
  ELSE lInvalid = YES.

  RETURN NOT lInvalid.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignWidgetValueList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignWidgetValueList Procedure 
FUNCTION assignWidgetValueList RETURNS LOGICAL
  ( INPUT pcNameList  AS CHARACTER,
    INPUT pcValueList AS CHARACTER,
    INPUT pcDelimiter AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the SCREEN-VALUE of objects in a delimited list.
   Params:  INPUT pcNameList  AS CHARACTER
            INPUT pcValueList AS CHARACTER
            INPUT pcDelimiter AS CHARACTER
    Notes:  If pcDelimiter is ?, | is used
------------------------------------------------------------------------------*/
DEFINE VARIABLE cField     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cQualifier AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cValue     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cValueList AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iField     AS INTEGER    NO-UNDO.
DEFINE VARIABLE lAssigned  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lInvalid   AS LOGICAL    NO-UNDO.

  IF pcDelimiter = ? THEN pcDelimiter = '|':U.

  /* If there is more than one value and the number of values do not 
     match the number of names, false is returned and no assignments are done */
  IF NUM-ENTRIES(pcValueList, pcDelimiter) > 1 AND
     NUM-ENTRIES(pcValueList, pcDelimiter) NE NUM-ENTRIES(pcNameList) THEN RETURN FALSE.

  /* If the first name in the list is qualified that is stored so that it can be used
     as the qualifier for following non-qualified names in the list.  */
  IF NUM-ENTRIES(pcNameList) > 1 AND NUM-ENTRIES(ENTRY(1, pcNameList), '.':U) > 1 THEN
  ASSIGN cQualifier = SUBSTRING(ENTRY(1, pcNameList), 1, R-INDEX(ENTRY(1, pcNameList), '.')).

  DO iField = 1 TO NUM-ENTRIES(pcNameList):
    cField = ENTRY(iField, pcNameList).
    IF NUM-ENTRIES(cField, '.':U) = 1 AND cQualifier NE '':U THEN
      cField = cQualifier + cField.
    cValue = IF NUM-ENTRIES(pcValueList, pcDelimiter) >= iField THEN ENTRY(iField, pcValueList, pcDelimiter)
             ELSE ENTRY(1, pcValueList, pcDelimiter).
    lAssigned = DYNAMIC-FUNCTION('assignWidgetValue':U IN TARGET-PROCEDURE,
                                INPUT cField,
                                INPUT cValue).
    /* If an assignment failed processing of assignments will continue but false
       will be returned. */
    IF NOT lAssigned THEN lInvalid = TRUE.
  END.  /* do iField to number entries in namelist */

  RETURN NOT lInvalid.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-blankWidget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION blankWidget Procedure 
FUNCTION blankWidget RETURNS LOGICAL
  ( INPUT pcNameList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Blanks the SCREEN-VALUE of the object or objects in the NameList.
   Params:  INPUT pcNameList AS CHARACTER
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE iField                AS INTEGER    NO-UNDO.
DEFINE VARIABLE cField                AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cQualifier            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hField                AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTarget               AS HANDLE     NO-UNDO.
DEFINE VARIABLE lInvalid              AS LOGICAL    NO-UNDO.

  /* If the first name in the list is qualified that is stored so that it can be used
     as the qualifier for following non-qualified names in the list.  */
  IF NUM-ENTRIES(pcNameList) > 1 AND NUM-ENTRIES(ENTRY(1, pcNameList), '.':U) > 1 THEN
    ASSIGN cQualifier = SUBSTRING(ENTRY(1, pcNameList), 1, R-INDEX(ENTRY(1, pcNameList), '.')).

  DO iField = 1 TO NUM-ENTRIES(pcNameList):
    cField = ENTRY(iField, pcNameList).
    IF NUM-ENTRIES(cField, '.':U) = 1 AND cQualifier NE '':U THEN
      cField = cQualifier + cField.
    RUN locateWidget IN TARGET-PROCEDURE (INPUT cField, OUTPUT hField, OUTPUT hTarget).
    IF VALID-HANDLE(hField) THEN
    DO:
      /* This is a SmartDataField. Use its setDataValue method. */
      IF CAN-QUERY(hField, 'FILE-NAME':U) THEN
      DO:  
        /* Test for lookup */
        IF {fnarg Signature 'initializeLookup':U hField} NE '':U THEN 
        DO:
          RUN assignNewValue IN hField (INPUT "":U, INPUT "":U, INPUT TRUE).
          IF ERROR-STATUS:ERROR THEN
            lInvalid = YES.
        END.  /* if dynLookup */
        ELSE DO:
          {set DataValue '':U hField} NO-ERROR. 
          
          IF ERROR-STATUS:ERROR THEN
            lInvalid = YES.
          ELSE 
            {set DataModified TRUE hField} NO-ERROR.
        END.  /* else do */
      END.  /* if can-query file-name */
      ELSE DO:
        IF CAN-QUERY(hField, 'TYPE':U) 
        AND hField:TYPE = 'COMBO-BOX':U THEN 
        DO:
          /* Apply space (this is required if there is blank in list-items 
           or list-item-pairs) */
          hField:SCREEN-VALUE = ' ' NO-ERROR.
          /* if blank is not defined in list then clear the widget */ 
          IF ERROR-STATUS:ERROR THEN
          DO:
            IF CAN-QUERY(hField, 'LIST-ITEMS':U) THEN
            DO:
              hField:LIST-ITEMS = hField:LIST-ITEMS NO-ERROR.
              IF ERROR-STATUS:ERROR THEN
                lInvalid = YES.
            END.  /* if list-items */
            ELSE DO:
              hField:LIST-ITEM-PAIRS = hField:LIST-ITEM-PAIRS NO-ERROR.
              IF ERROR-STATUS:ERROR THEN
                lInvalid = YES.
            END.  /* else list-item-pairs */
          END.
        END.  /* if combo-box */
        ELSE IF CAN-SET(hField, 'SCREEN-VALUE':U) THEN
        DO:
          hField:SCREEN-VALUE = '':U NO-ERROR.
          /* Assigning the SCREEN-VALUE to blank for certain widgets (e.g. toggle-boxes) 
             raises an error but the error status is not true.  */
          IF ERROR-STATUS:ERROR OR ERROR-STATUS:NUM-MESSAGES > 0 THEN
            lInvalid = YES.  
        END.  /* if can set screen-value */
        ELSE lInvalid = YES. 

        /* SetDataModified if applicable (no-error as this is in datavis) */
        IF NOT lInvalid THEN
          RUN fieldModified IN hTarget (hField) NO-ERROR.
          
      END.  /* else do - not SDF */
    END.  /* END ELSE DO IF VALID-HANDLE */
    ELSE lInvalid = YES.
  END.    /* END DO iField */
  
   /* Return FALSE if any field was invalid. */
  RETURN NOT lInvalid.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-clearWidget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION clearWidget Procedure 
FUNCTION clearWidget RETURNS LOGICAL
  ( INPUT pcNameList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Clears the object or objects in the NameList.
   Params:  INPUT pcNameList AS CHARACTER
    Notes:  This should only be used to clear the widget, not as a way to 
            display blank. For most widgets there is no difference, but  
            this does NOT display the corresponding Display value for objects 
            that have a different value and display value, like widgets with 
            list-item-pairs or SmartObjects like DynCombo, Lookup and SmartSelect.  
            This will also avoid the potential AppServer hit to find the 
            correspondng Display value for these SmartObjects. 
          - Note that the SCREEN-VALUE and the widgetValue API may not 
            necessarily return blank for a cleared widget. The objects for which
            this makes a differerence will typically return the unknown value
            after this call.
          - Radio-sets will be set to the first entry and logicals 
           (except radio-sets) will be set to false. 
------------------------------------------------------------------------------*/
DEFINE VARIABLE iField                AS INTEGER    NO-UNDO.
DEFINE VARIABLE cField                AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cQualifier            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hField                AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTarget               AS HANDLE     NO-UNDO.
DEFINE VARIABLE lInvalid              AS LOGICAL    NO-UNDO.

  /* If the first name in the list is qualified that is stored so that it can be used
     as the qualifier for following non-qualified names in the list.  */
  IF NUM-ENTRIES(pcNameList) > 1 AND NUM-ENTRIES(ENTRY(1, pcNameList), '.':U) > 1 THEN
    ASSIGN cQualifier = SUBSTRING(ENTRY(1, pcNameList), 1, R-INDEX(ENTRY(1, pcNameList), '.')).

  DO iField = 1 TO NUM-ENTRIES(pcNameList):
    cField = ENTRY(iField, pcNameList).
    IF NUM-ENTRIES(cField, '.':U) = 1 AND cQualifier NE '':U THEN
      cField = cQualifier + cField.
    RUN locateWidget IN TARGET-PROCEDURE (INPUT cField, OUTPUT hField, OUTPUT hTarget).
    IF VALID-HANDLE(hField) THEN
    DO:
      /* This is a SmartDataField. Use its setDataValue method. */
      IF CAN-QUERY(hField, 'FILE-NAME':U) THEN
      DO:  
        RUN clearField IN hField NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
           lInvalid = YES.
        ELSE 
          {set DataModified TRUE hField} NO-ERROR.
      END.  /* if can-query file-name */
      ELSE DO:
        IF CAN-QUERY(hField, 'TYPE':U)  
        AND hField:TYPE = 'COMBO-BOX':U THEN 
        DO:
          IF CAN-QUERY(hField, 'LIST-ITEMS':U) THEN
            hField:LIST-ITEMS = hField:LIST-ITEMS NO-ERROR.
          ELSE 
            hField:LIST-ITEM-PAIRS = hField:LIST-ITEM-PAIRS NO-ERROR.
          IF ERROR-STATUS:ERROR THEN
             lInvalid = YES.
        END.  /* if combo-box */
        ELSE IF CAN-QUERY(hField, 'TYPE':U)  
        AND hField:TYPE = 'RADIO-SET':U THEN 
        DO:
          hField:SCREEN-VALUE = ENTRY(2,hField:RADIO-BUTTONS) NO-ERROR. 
          IF ERROR-STATUS:ERROR THEN
            lInvalid = YES.
        END. /* radio-set */
        ELSE IF hField:DATA-TYPE = 'LOGICAL':U THEN
        DO:
          IF hField:TYPE = "TOGGLE-BOX":U THEN
            hField:CHECKED = FALSE.
          ELSE
            hField:SCREEN-VALUE = 'NO':U.
        END. /* logical */
        ELSE IF CAN-SET(hField, 'SCREEN-VALUE':U) THEN
        DO:
          hField:SCREEN-VALUE = '':U NO-ERROR.
          /* Assigning the SCREEN-VALUE to blank for certain widgets (e.g. toggle-boxes) 
             raises an error but the error status is not true.  */
          IF ERROR-STATUS:ERROR OR ERROR-STATUS:NUM-MESSAGES > 0 THEN
            lInvalid = YES.  
        END.  /* if can set screen-value */
        ELSE lInvalid = YES. 

        /* SetDataModified if applicable (no-error as this is in datavis) */
        IF NOT lInvalid THEN
          RUN fieldModified IN hTarget (hField) NO-ERROR.
          
      END.  /* else do - not SDF */
    END.  /* END ELSE DO IF VALID-HANDLE */
    ELSE lInvalid = YES.
  END.    /* END DO iField */
  
   /* Return FALSE if any field was invalid. */
  RETURN NOT lInvalid.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createDynamicColor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createDynamicColor Procedure 
FUNCTION createDynamicColor RETURNS INTEGER
  ( pcName AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Creates a Progress 3D color in the color-table and returns its 
           number.
Parameter: pcName - colorname to add to the ADM section in .ini                         
    Notes: Returns unknown if the color could not be created.
         - The color is added to the color-table ans the .ini file if it 
           doesn't exist, menaing that this code is the originator of the 
           entry in the .ini.
         - It is also possible to manually add or change the entries in 
           the .ini to point to some other color. This color will be made 
           dynamic unless it is one of the 16 (0 - 15) reserved colors.   
         - See initWinColors for usage  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iColor      AS INTEGER    NO-UNDO.
  
  GET-KEY-VALUE SECTION 'ADM':U KEY pcName VALUE cValue.
  
  iColor = INT(cValue).
  
  IF iColor > 255 THEN 
    RETURN ?.
  
  /* If not defined or not enough entries in the color-table then add it */
  IF iColor = ? OR COLOR-TABLE:NUM-ENTRIES < iColor + 1 THEN
  DO:
    /* If undefined; get new number and add it to the ini file. */
    IF iColor = ? THEN
    DO:
      iColor = COLOR-TABLE:NUM-ENTRIES.    
      /* only put to 'adm' section if within max entries */
      IF iColor < 256 THEN
        PUT-KEY-VALUE SECTION 'ADM':U KEY pcName VALUE STRING(iColor).
      ELSE iColor = ?.
    END.
    
    /* add an entry to the color table */
    IF iColor <> ? THEN
      COLOR-TABLE:NUM-ENTRIES = iColor + 1.  
  END.
  
  /* Don't mess with the default ADE colors */ 
  IF iColor > 15 THEN
    COLOR-TABLE:SET-DYNAMIC(iColor,TRUE).  

  RETURN iColor.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createUiEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createUiEvents Procedure 
FUNCTION createUiEvents RETURNS LOGICAL
    ( /* No parameters */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Creates custom events for the widget. 
    Notes:  * A Dynamics Repository is required for this API.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hObjectBuffer               AS HANDLE               NO-UNDO.
    DEFINE VARIABLE hWidget                     AS HANDLE               NO-UNDO.
    DEFINE VARIABLE cEventName                  AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE cEventNames                                 AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE cEventValues                                AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE lUseRepository              AS LOGICAL              NO-UNDO.
    DEFINE VARIABLE dInstanceId                 AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE iLoop                                               AS INTEGER                      NO-UNDO.
    
    /* This API only works with a connected Dynamics Repository. */
    {get useRepository lUseRepository}.

    IF lUseRepository EQ YES AND VALID-HANDLE(gshRepositoryManager) THEN
    DO:
        /* Get this object's unique Repository cache identifier. */
        {get InstanceId dInstanceId}.
                
        /* Get the default frame, window or container handle depending on the object type.
         * In the case of a container window, the getContainerHandle() call will return
         * the window handle. In the case of a viewer, it will return the frame's handle. */
        IF {fnarg instanceOf 'Browser'} THEN
            {get BrowseHandle hWidget}.
        ELSE
            {get ContainerHandle hWidget}.
        
        /* Get the handle to the object buffer containing cached events. */
        ASSIGN hObjectBuffer = DYNAMIC-FUNCTION("getCacheObjectBuffer":U IN gshRepositoryManager,
                                                INPUT dInstanceId).
        IF hObjectBuffer:AVAILABLE THEN
            ASSIGN cEventNames  = hObjectBuffer:BUFFER-FIELD("EventNames":U):BUFFER-VALUE
                   cEventValues = hObjectBuffer:BUFFER-FIELD("EventActions":U):BUFFER-VALUE.
        
                /* Use a zero-based loop because it makes the determination of the entries in the EventValues
                   variable eaiser to determine (there is less calculation required).
                 */
            DO iLoop = 0 TO NUM-ENTRIES(cEventNames) - 1:
                ASSIGN cEventName = ENTRY(iLoop + 1, cEventNames).
            
            /* Make sure that this is a valid event for the widget */
            IF VALID-EVENT(hWidget, cEventName) THEN
            CASE cEventName:
                WHEN "ANY-KEY":U                THEN ON ANY-KEY                OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                WHEN "ANY-PRINTABLE":U          THEN ON ANY-PRINTABLE          OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                WHEN "BACK-TAB":U               THEN ON BACK-TAB               OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                WHEN "BACKSPACE":U              THEN ON BACKSPACE              OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                WHEN "BELL":U                   THEN ON BELL                   OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                WHEN "CHOOSE":U                 THEN ON CHOOSE                 OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                WHEN "CLEAR":U                  THEN ON CLEAR                  OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                WHEN "DEFAULT-ACTION":U         THEN ON DEFAULT-ACTION         OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                WHEN "DEL":U                    THEN ON DEL                    OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                WHEN "DELETE-CHAR":U            THEN ON DELETE-CHAR            OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                WHEN "DELETE-CHARACTER":U       THEN ON DELETE-CHARACTER       OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                WHEN "DESELECT":U               THEN ON DESELECT               OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                WHEN "DESELECTION":U            THEN ON DESELECTION            OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                WHEN "DROP-FILE-NOTIFY":U       THEN ON DROP-FILE-NOTIFY       OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                WHEN "EMPTY-SELECTION":U        THEN ON EMPTY-SELECTION        OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                WHEN "END-BOX-SELECTION":U      THEN ON END-BOX-SELECTION      OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                WHEN "END-ERROR":U              THEN ON END-ERROR              OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                WHEN "END-MOVE":U               THEN ON END-MOVE               OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                WHEN "END-RESIZE":U             THEN ON END-RESIZE             OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                WHEN "ENDKEY":U                 THEN ON ENDKEY                 OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                WHEN "ENTRY":U                  THEN ON ENTRY                  OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                WHEN "ERROR":U                  THEN ON ERROR                  OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                WHEN "GO":U                     THEN ON GO                     OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                WHEN "HELP":U                   THEN ON HELP                   OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                WHEN "LEAVE":U                  THEN ON LEAVE                  OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                WHEN "MOUSE-MENU-CLICK":U       THEN ON MOUSE-MENU-CLICK       OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                WHEN "MOUSE-SELECT-CLICK":U     THEN ON MOUSE-SELECT-CLICK     OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                WHEN "MOUSE-SELECT-DBLCLICK":U  THEN ON MOUSE-SELECT-DBLCLICK  OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                WHEN "PARENT-WINDOW-CLOSE"      THEN ON PARENT-WINDOW-CLOSE    OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                WHEN "RECALL":U                 THEN ON RECALL                 OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                WHEN "RETURN":U                 THEN ON RETURN                 OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                WHEN "SELECT":U                 THEN ON SELECT                 OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                WHEN "SELECTION":U              THEN ON SELECTION              OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                WHEN "START-BOX-SELECTION":U    THEN ON START-BOX-SELECTION    OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                WHEN "START-MOVE":U             THEN ON START-MOVE             OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                WHEN "START-RESIZE":U           THEN ON START-RESIZE           OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                WHEN "TAB":U                    THEN ON TAB                    OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                WHEN "VALUE-CHANGED":U          THEN ON VALUE-CHANGED          OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                WHEN "WINDOW-CLOSE":U           THEN ON WINDOW-CLOSE           OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                WHEN "WINDOW-MAXIMIZED":U       THEN ON WINDOW-MAXIMIZED       OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                WHEN "WINDOW-MINIMIZED":U       THEN ON WINDOW-MINIMIZED       OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                WHEN "WINDOW-RESIZED":U         THEN ON WINDOW-RESIZED         OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                WHEN "WINDOW-RESTORED":U        THEN ON WINDOW-RESTORED        OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                /* User-defined events */
                WHEN "U1":U                     THEN ON U1  OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                WHEN "U2":U                     THEN ON U2  OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                WHEN "U3":U                     THEN ON U3  OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                WHEN "U4":U                     THEN ON U4  OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                WHEN "U5":U                     THEN ON U5  OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                WHEN "U6":U                     THEN ON U6  OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                WHEN "U7":U                     THEN ON U7  OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                WHEN "U8":U                     THEN ON U8  OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                WHEN "U9":U                     THEN ON U9  OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
                WHEN "U10":U                    THEN ON U10 OF hWidget PERSISTENT {&RUN-PROCESS-EVENT-PROCEDURE}.
            END CASE.    /* only valid events */
        END.    /* UI events. */
        
        /* Return true because the UI events, if any, have been added. 
         * Even if there are no UI events, still return true because
         * the attempt to add UI events succeeded.                     */
        RETURN TRUE.
    END.    /* valid repository manager */

    /* If we get here, it means that the UI events have not been added from the Repository. */
    RETURN FALSE.
END FUNCTION.   /* createUiEvents */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyPopups) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION destroyPopups Procedure 
FUNCTION destroyPopups RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Destroy dynamically created popups kept in FieldPopupMapping.
    Notes: The popups is in every second entry (the first entry is the field 
           widget) 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFieldPopupMapping AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i                  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hPopup             AS HANDLE     NO-UNDO.
  
  {get FieldPopupMapping cFieldPopupMapping}.
  DO i = 2 TO NUM-ENTRIES(cFieldPopupMapping) BY 2:
    hPopup = WIDGET-HANDLE(ENTRY(i,cFieldPopupMapping)).
    DELETE OBJECT hPopup NO-ERROR.
  END.
  {set FieldPopupMapping '':U}.
  
  RETURN TRUE. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-disableRadioButton) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION disableRadioButton Procedure 
FUNCTION disableRadioButton RETURNS LOGICAL
  ( INPUT pcNameList  AS CHARACTER,
    INPUT piButtonNum AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  Disables the specified radio button in the object or objects 
            in the NameList.
   Params:  INPUT pcNameList  AS CHARACTER
            INPUT piButtonNum AS INTEGER
    Notes:  Does not support SmartDataFields
------------------------------------------------------------------------------*/
  RETURN DYNAMIC-FUNCTION('sensitizeRadioButton':U IN TARGET-PROCEDURE,
                           INPUT pcNameList, INPUT piButtonNum, INPUT NO).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-disableWidget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION disableWidget Procedure 
FUNCTION disableWidget RETURNS LOGICAL
  ( INPUT pcNameList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Disables the object or objects in the NameList.
   Params:  INPUT pcNameList AS CHARACTER
    Notes:  The field is removed from EnabledFields and EnabledHandles so that
            it remains disabled.
------------------------------------------------------------------------------*/
DEFINE VARIABLE cDisplayedFields      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEnabledObjFlds       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEnabledObjHdls       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cField                AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFieldHandles         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFieldObjectName      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFldsToDisable        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cQualifier            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hField                AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTarget               AS HANDLE     NO-UNDO.
DEFINE VARIABLE iField                AS INTEGER    NO-UNDO.
DEFINE VARIABLE iFieldNum             AS INTEGER    NO-UNDO.
DEFINE VARIABLE iFldToDisable         AS INTEGER    NO-UNDO.
DEFINE VARIABLE lInvalid              AS LOGICAL    NO-UNDO.

  /* If the first name in the list is qualified that is stored so that it can be used
     as the qualifier for following non-qualified names in the list.  */
  IF NUM-ENTRIES(pcNameList) > 1 AND NUM-ENTRIES(ENTRY(1, pcNameList), '.':U) > 1 THEN
    ASSIGN cQualifier = SUBSTRING(ENTRY(1, pcNameList), 1, R-INDEX(ENTRY(1, pcNameList), '.')).

  DO iField = 1 TO NUM-ENTRIES(pcNameList):
    cField = ENTRY(iField, pcNameList).
    IF NUM-ENTRIES(cField, '.':U) = 1 AND cQualifier NE '':U THEN
      cField = cQualifier + cField.
    RUN locateWidget IN TARGET-PROCEDURE (INPUT cField, OUTPUT hField, OUTPUT hTarget).
    IF VALID-HANDLE(hField) THEN
    DO:
      /* This is a SmartDataField. Use its disableField function. 
         ALso set the flag that it should not re-enabled. */
      IF CAN-QUERY(hField, 'FILE-NAME':U) THEN
      DO:  
        RUN disableField IN hField NO-ERROR.
        IF ERROR-STATUS:ERROR THEN lInvalid = YES.
        ELSE DO:
          DYNAMIC-FUNCTION('setEnableField':U IN hField, NO) NO-ERROR.
          IF ERROR-STATUS:ERROR THEN lInvalid = YES.
        END.  /* else no error */
      END.  /* if can-query file-name */  
      /* skip editor here as we need to use read-only (below) */
      else if hField:type <> 'editor':u and CAN-SET(hField, 'SENSITIVE':U) THEN
      DO:
        hField:SENSITIVE = NO NO-ERROR.
        IF ERROR-STATUS:ERROR THEN lInvalid = YES.
        ELSE 
          DYNAMIC-FUNCTION('sensitizePopup':U IN hTarget,
                            hField, NO).
        
      END.  /* if can set sensitive - viewer */
      ELSE IF CAN-SET(hField, 'READ-ONLY':U) THEN
      DO:
        hField:READ-ONLY = YES NO-ERROR.
        IF ERROR-STATUS:ERROR THEN lInvalid = YES.
        ELSE 
          DYNAMIC-FUNCTION('sensitizePopup':U IN hTarget,
                            hField, NO).
      END.  /* if can set read-only - browser */
      ELSE lInvalid = YES.
      IF NOT lInvalid THEN
      DO:
        /* Need to get the field name in the object, not necessarily the field name in pcNameList,
           because it may by qualified with an SDO name (e.g. viewer based on SBO).  */
        {get DisplayedFields cDisplayedFields hTarget} NO-ERROR.
        {get FieldHandles cFieldHandles hTarget} NO-ERROR.
        {get EnabledObjFlds cEnabledObjFlds hTarget} NO-ERROR.
        {get EnabledObjHdls cEnabledObjHdls hTarget} NO-ERROR.

        /* Remove the field from the enabled fields so that it stays disabled. */
        iFieldNum = LOOKUP(STRING(hField), cFieldHandles).
        IF iFieldNum > 0 THEN
        DO:
          cFieldObjectName = ENTRY(iFieldNum, cDisplayedFields) NO-ERROR.
          RUN modifyListProperty IN TARGET-PROCEDURE
            (hTarget, 'REMOVE':U, 'EnabledFields':U, cFieldObjectName) NO-ERROR.
          RUN modifyListProperty IN TARGET-PROCEDURE
            (hTarget, 'REMOVE':U, 'EnabledHandles':U, hField) NO-ERROR. 
        END.  /* if DisplayedField */
        /* Remove field from EnabledObjFldsToDisable so that it stays disabled.  If
           EnabledObjFldsToDisable is (All), then set it to all enabled objects 
           except this field.  */
        ELSE DO:
          iFieldNum = LOOKUP(STRING(hField), cEnabledObjHdls).
          IF iFieldNum > 0 THEN
          DO:
            {get EnabledObjFldsToDisable cFldsToDisable hTarget} NO-ERROR.
            IF cFldsToDisable = '(All)':U THEN
            DO:
              cFldsToDisable = DYNAMIC-FUNCTION('deleteEntry':U IN hTarget,
                                                INPUT iFieldNum,
                                                INPUT cEnabledObjFlds,
                                                INPUT '':U) NO-ERROR.
              {set EnabledObjFldsToDisable cFldsToDisable hTarget} NO-ERROR.
            END.  /* if EnabledObjFldsToDisable is (All) */
            ELSE IF cFldsToDisable NE '(None)':U THEN DO:
              cFieldObjectName = ENTRY(iFieldNum, cEnabledObjFlds) NO-ERROR.
              RUN modifyListProperty IN TARGET-PROCEDURE
                (hTarget, 'REMOVE':U, 'EnabledObjFldsToDisable':U, cFieldObjectName) NO-ERROR.
            END.  /* else EnabledObjFldsToDisable is not (All) */            
          END.  /* if enabled object */
        END.  /* else do - not data field */                                                       
      END.  /* if valid */
    END.    /* END ELSE DO IF VALID-HANDLE */
      
    ELSE lInvalid = YES.
  END.        /* END DO iField */

  /* Return FALSE if any field was invalid. */
  RETURN NOT lInvalid.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-enableRadioButton) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION enableRadioButton Procedure 
FUNCTION enableRadioButton RETURNS LOGICAL
  ( INPUT pcNameList  AS CHARACTER,
    INPUT piButtonNum AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  Enables the specified radio button in the object or objects 
            in the NameList.
   Params:  INPUT pcNameList  AS CHARACTER
            INPUT piButtonNum AS INTEGER
    Notes:  Does not support SmartDataFields
------------------------------------------------------------------------------*/
  RETURN DYNAMIC-FUNCTION('sensitizeRadioButton':U IN TARGET-PROCEDURE,
                           INPUT pcNameList, INPUT piButtonNum, INPUT YES).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-enableWidget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION enableWidget Procedure 
FUNCTION enableWidget RETURNS LOGICAL
  ( INPUT pcNameList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Enables the object or objects in the NameList.
   Params:  INPUT pcNameList AS CHARACTER
    Notes:  The field is added to EnabledFields and EnabledHandles so that
            it remains enabled.
------------------------------------------------------------------------------*/
DEFINE VARIABLE cDisplayedFields      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEnabledObjFlds       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEnabledObjHdls       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cField                AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFieldHandles         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFieldObjectName      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFldsToDisable        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cQualifier            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hField                AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTarget               AS HANDLE     NO-UNDO.
DEFINE VARIABLE iField                AS INTEGER    NO-UNDO.
DEFINE VARIABLE iFieldNum             AS INTEGER    NO-UNDO.
DEFINE VARIABLE lInvalid              AS LOGICAL    NO-UNDO.

  /* If the first name in the list is qualified that is stored so that it can be used
     as the qualifier for following non-qualified names in the list.  */
  IF NUM-ENTRIES(pcNameList) > 1 AND NUM-ENTRIES(ENTRY(1, pcNameList), '.':U) > 1 THEN
    ASSIGN cQualifier = SUBSTRING(ENTRY(1, pcNameList), 1, R-INDEX(ENTRY(1, pcNameList), '.')).

  DO iField = 1 TO NUM-ENTRIES(pcNameList):
    cField = ENTRY(iField, pcNameList).
    IF NUM-ENTRIES(cField, '.':U) = 1 AND cQualifier NE '':U THEN
      cField = cQualifier + cField.
    RUN locateWidget IN TARGET-PROCEDURE (INPUT cField, OUTPUT hField, OUTPUT hTarget).
        
    IF VALID-HANDLE(hField) THEN
    DO:
      /* not allowed if secured */ 
      IF {fnarg fieldSecurityRule hField hTarget} > '':U THEN
        lInvalid = TRUE.
      /* This is a SmartDataField. Use its enableField function. */
      ELSE IF CAN-QUERY(hField, 'FILE-NAME':U) THEN
      DO:  
        RUN enableField IN hField NO-ERROR.
        IF ERROR-STATUS:ERROR THEN lInvalid = YES.
        ELSE DO:
          DYNAMIC-FUNCTION('setEnableField':U IN hField, YES) NO-ERROR.
          IF ERROR-STATUS:ERROR THEN lInvalid = YES.
        END.  /* else no error */
      END.  /* if can-query file-name */
      /* skip editor here as we need to use read-only (below) */
      else if hField:type <> 'editor':u and CAN-SET(hField, 'SENSITIVE':U) THEN
      DO:
        hField:SENSITIVE = YES.
        IF ERROR-STATUS:ERROR THEN lInvalid = YES.
        ELSE 
          DYNAMIC-FUNCTION('sensitizePopup':U IN hTarget,
                            hField, YES).
      END.  /* if can set sensitive - viewer */
      ELSE IF CAN-SET(hField, 'READ-ONLY':U) THEN
      DO:
        hField:READ-ONLY = NO NO-ERROR.
        IF ERROR-STATUS:ERROR THEN lInvalid = YES.
        ELSE 
          DYNAMIC-FUNCTION('sensitizePopup':U IN hTarget,
                            hField, YES).
      END.  /* if can set read-only - browser */
      ELSE lInvalid = YES.
      IF NOT lInvalid THEN
      DO:
        /* Need to get the field name in the object, not necessarily the field name in pcNameList,
           because it may by qualified with an SDO name (e.g. viewer based on SBO).  */
        {get DisplayedFields cDisplayedFields hTarget} NO-ERROR.
        {get FieldHandles cFieldHandles hTarget} NO-ERROR.
        {get EnabledObjFlds cEnabledObjFlds hTarget} NO-ERROR.
        {get EnabledObjHdls cEnabledObjHdls hTarget} NO-ERROR.

        /* Add the field to enabled fields so that it stays enabled. */
        iFieldNum = LOOKUP(STRING(hField), cFieldHandles).
        IF iFieldNum > 0 THEN
        DO:
          cFieldObjectName = ENTRY(iFieldNum, cDisplayedFields) NO-ERROR.
          RUN modifyListProperty IN TARGET-PROCEDURE
            (hTarget, 'ADD':U, 'EnabledFields':U, cFieldObjectName) NO-ERROR.
          RUN modifyListProperty IN TARGET-PROCEDURE
            (hTarget, 'ADD':U, 'EnabledHandles':U, hField) NO-ERROR. 
        END.  /* if DisplayedField */
        /* Add field to EnabledObjFldsToDisable so that it stays enabled.  */
        ELSE DO:
          iFieldNum = LOOKUP(STRING(hField), cEnabledObjHdls).
          IF iFieldNum > 0 THEN
          DO:
            {get EnabledObjFldsToDisable cFldsToDisable hTarget} NO-ERROR.    
            IF cFldsToDisable NE '(All)':U AND cFldsToDisable NE '(None)':U THEN
            DO:
              cFieldObjectName = ENTRY(iFieldNum, cEnabledObjFlds) NO-ERROR. 
              RUN modifyListProperty IN TARGET-PROCEDURE
                (hTarget, 'ADD':U, 'EnabledObjFldsToDisable':U, cFieldObjectName) NO-ERROR.
            END.  /* if EnabledObjFldsToDisable not (all) or (none) */
          END.  /* if enabled object */
        END.  /* else do - not displayed field */                                                       
      END.  /* if valid */
    END.    /* END ELSE DO IF VALID-HANDLE */
    ELSE lInvalid = YES.
  END.        /* END DO iField */

  /* Return FALSE if any field was invalid. */
  RETURN NOT lInvalid.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fieldSecurityRule) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fieldSecurityRule Procedure 
FUNCTION fieldSecurityRule RETURNS CHARACTER
  ( phWidget AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose: Check a field name against the FieldSecurity of the object 
Parameter: phWidget - handle (in order to be used after locateWidget in
                              the client api)
    Notes: Considered as Private  - but overidden in browser 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cAllFieldHandles AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSecuredFields   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iPos             AS INTEGER    NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get FieldSecurity cSecuredFields}
  {get AllFieldHandles cAllFieldHandles}
  .
  &UNDEFINE xp-assign
  
  iPos = LOOKUP(STRING(phWidget),cAllFieldHandles).

  /* Bad reference */
  IF iPos = 0 THEN
    RETURN ?.

  IF iPos <= NUM-ENTRIES(cSecuredFields) THEN
    RETURN ENTRY(iPos,cSecuredFields).
  
  RETURN "":U.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-formattedWidgetValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION formattedWidgetValue Procedure 
FUNCTION formattedWidgetValue RETURNS CHARACTER
  ( INPUT pcName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the formatted value of an object.
   Params:  INPUT pcName AS CHARACTER
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cValue     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hBuffer    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hField     AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTarget    AS HANDLE     NO-UNDO.

  RUN locateWidget IN TARGET-PROCEDURE (INPUT pcName, OUTPUT hField, OUTPUT hTarget).
  IF VALID-HANDLE(hField) THEN
  DO:
    /* not allowed if secured as hidden */       
    IF {fnarg fieldSecurityRule hField hTarget} = 'Hidden':U THEN
      cValue = ?.
  
    /* This is a SmartDataField. Return its DataValue property.
       Note that this is the underlying "key" value that is meaningful
       to the code, not the "DisplayValue" shown to the user. */
    ELSE IF CAN-QUERY(hField, 'FILE-NAME':U) THEN
      {get DataValue cValue hField}.
    ELSE IF CAN-QUERY(hField, 'SCREEN-VALUE':U) THEN  /* Viewer fields */
        cValue = hField:SCREEN-VALUE.
    /* If cannot query SCREEN-VALUE then this is a browser and we are in the middle of a 
       ROW-DISPLAY trigger so we must use the buffer instead */
    ELSE DO: 
      {get QueryRowObject hBuffer hTarget} NO-ERROR.
      IF VALID-HANDLE(hBuffer) THEN
      DO:
        IF NUM-ENTRIES(pcName, ".") = 2 THEN
          pcName = ENTRY(2, pcName, ".").
        ASSIGN hField = hBuffer:BUFFER-FIELD(pcName)
               cValue = STRING(hField:STRING-VALUE) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN cValue = ?.
      END.  /* if hBuffer valid */
      ELSE cValue = ?.  
    END.  /* else do - browser */
  END.  /* if hField valid */
  ELSE cValue = ?.

  RETURN cValue.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-formattedWidgetValueList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION formattedWidgetValueList Procedure 
FUNCTION formattedWidgetValueList RETURNS CHARACTER
  ( INPUT pcNameList  AS CHARACTER,
    INPUT pcDelimiter AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the formatted value of objects in a delimited list.
   Params:  INPUT pcNameList  AS CHARACTER
            INPUT pcDelimiter AS CHARACTER
    Notes:  If pcDelimiter is ?, | is used
------------------------------------------------------------------------------*/
DEFINE VARIABLE cField     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cQualifier AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cValue     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cValueList AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iField     AS INTEGER    NO-UNDO.

  IF pcDelimiter = ? THEN pcDelimiter = '|':U.

  /* If the first name in the list is qualified that is stored so that it can be used
     as the qualifier for following non-qualified names in the list.  */
  IF NUM-ENTRIES(pcNameList) > 1 AND NUM-ENTRIES(ENTRY(1, pcNameList), '.':U) > 1 THEN
    ASSIGN cQualifier = SUBSTRING(ENTRY(1, pcNameList), 1, R-INDEX(ENTRY(1, pcNameList), '.')).

  DO iField = 1 TO NUM-ENTRIES(pcNameList):
    cField = ENTRY(iField, pcNameList).
    IF NUM-ENTRIES(cField, '.':U) = 1 AND cQualifier NE '':U THEN
      cField = cQualifier + cField.
    cValue = DYNAMIC-FUNCTION('formattedWidgetValue':U IN TARGET-PROCEDURE, INPUT cField).
    cValueList = cValueList + (IF iField = 1 THEN '':U ELSE pcDelimiter) +
                 IF cValue = ? THEN '?':U ELSE cValue.
  END.  /* do iField to number entries in namelist */

  RETURN cValueList.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAllFieldHandles) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAllFieldHandles Procedure 
FUNCTION getAllFieldHandles RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get allFieldHandles cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAllFieldNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAllFieldNames Procedure 
FUNCTION getAllFieldNames RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: 
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.
  {get allFieldNames cValue}.
  RETURN cValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBGColor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBGColor Procedure 
FUNCTION getBGColor RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the Background color of the frame
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iBGColor AS INTEGER NO-UNDO INIT ?.
  DEFINE VARIABLE hFrame   AS HANDLE  NO-UNDO.
  
  {get ContainerHandle hFrame}.
  IF VALID-HANDLE(hFrame) THEN
       iBGCOLOR = hFrame:BGCOLOR NO-ERROR.
  
  RETURN iBGColor.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCol) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCol Procedure 
FUNCTION getCol RETURNS DECIMAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Return the Col(umn) of the object 
    Notes: Use repositionObject to set the COL.   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hContainer AS HANDLE NO-UNDO.
  
  {get ContainerHandle hContainer}.

  RETURN IF VALID-HANDLE(hContainer) THEN hContainer:COL ELSE ?.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getColor3DFace) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getColor3DFace Procedure 
FUNCTION getColor3DFace RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE iRGB AS INTEGER    NO-UNDO.
 RUN GetSysColor ({&COLOR_3DFACE}, OUTPUT iRGB). 
 COLOR-TABLE:SET-RGB-VALUE(giColor3DFace,iRGB) NO-ERROR.
 RETURN giColor3DFace.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getColor3DHighLight) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getColor3DHighLight Procedure 
FUNCTION getColor3DHighLight RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iRGB AS INTEGER    NO-UNDO.
  RUN GetSysColor ({&COLOR_3DHIGHLIGHT}, OUTPUT iRGB). 
  COLOR-TABLE:SET-RGB-VALUE(giColor3DHighLight,iRGB) NO-ERROR. 
  RETURN giColor3DHighLight.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getColor3DShadow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getColor3DShadow Procedure 
FUNCTION getColor3DShadow RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iRGB AS INTEGER    NO-UNDO.
  RUN GetSysColor ({&COLOR_3DSHADOW}, OUTPUT iRGB). 
  COLOR-TABLE:SET-RGB-VALUE(giColor3DShadow,iRGB) NO-ERROR.

  RETURN giColor3DShadow.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getColorErrorBG) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getColorErrorBG Procedure 
FUNCTION getColorErrorBG RETURNS INTEGER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the error background color number
   Params:  <none>
    Notes:  Used by highlightWidget
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iColor AS INTEGER NO-UNDO.
  {get ColorErrorBG iColor}.
  RETURN iColor.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getColorErrorFG) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getColorErrorFG Procedure 
FUNCTION getColorErrorFG RETURNS INTEGER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the error foreground color number
   Params:  <none>
    Notes:  Used by highlightWidget
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iColor AS INTEGER NO-UNDO.
  {get ColorErrorFG iColor}.
  RETURN iColor.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getColorInfoBG) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getColorInfoBG Procedure 
FUNCTION getColorInfoBG RETURNS INTEGER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the information background color number
   Params:  <none>
    Notes:  Used by highlightWidget
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iColor AS INTEGER NO-UNDO.
  {get ColorInfoBG iColor}.
  RETURN iColor.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getColorInfoFG) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getColorInfoFG Procedure 
FUNCTION getColorInfoFG RETURNS INTEGER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the information foreground color number
   Params:  <none>
    Notes:  Used by highlightWidget
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iColor AS INTEGER NO-UNDO.
  {get ColorInfoFG iColor}.
  RETURN iColor.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getColorWarnBG) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getColorWarnBG Procedure 
FUNCTION getColorWarnBG RETURNS INTEGER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the warning background color number
   Params:  <none>
    Notes:  Used by highlightWidget
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iColor AS INTEGER NO-UNDO.
  {get ColorWarnBG iColor}.
  RETURN iColor.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getColorWarnFG) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getColorWarnFG Procedure 
FUNCTION getColorWarnFG RETURNS INTEGER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the warning foreground color number
   Params:  <none>
    Notes:  Used by highlightWidget
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iColor AS INTEGER NO-UNDO.
  {get ColorWarnFG iColor}.
  RETURN iColor.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDefaultLayout) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDefaultLayout Procedure 
FUNCTION getDefaultLayout RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the name of the default for this object.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cDefault AS CHARACTER NO-UNDO.
  {get DefaultLayout cDefault}.
  RETURN cDefault.
  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDisableOnInit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDisableOnInit Procedure 
FUNCTION getDisableOnInit RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a flag indicating whether the current object should be
            left disabled when it is first initialized.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lDisable AS LOGICAL NO-UNDO.
  {get DisableOnInit lDisable}.
  RETURN lDisable.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getEnabledObjFlds) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getEnabledObjFlds Procedure 
FUNCTION getEnabledObjFlds RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a list of the field names of widgets enabled in this object
            not associated with data fields.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cFields AS CHARACTER NO-UNDO.
  {get EnabledObjFlds cFields}.
  RETURN cFields.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getEnabledObjHdls) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getEnabledObjHdls Procedure 
FUNCTION getEnabledObjHdls RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a list of the handles of widgets enabled in this object
            not associated with data fields.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cHdls AS CHARACTER NO-UNDO.
  {get EnabledObjHdls cHdls}.
  RETURN cHdls.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFGColor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFGColor Procedure 
FUNCTION getFGColor RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Retrieves the Foreground Color of the frame 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iFGColor AS INTEGER NO-UNDO INIT ?.
  DEFINE VARIABLE hFrame   AS HANDLE  NO-UNDO.
    
  {get ContainerHandle hFrame}.
  IF VALID-HANDLE(hFrame) THEN
     iFGCOLOR = hFrame:FGCOLOR NO-ERROR.
    
  RETURN iFGColor.
  
  
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldPopupMapping) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFieldPopupMapping Procedure 
FUNCTION getFieldPopupMapping RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the mapping of field and object handles and their dynamically 
           created popup handle. The list can be used directly, but is also used
           by popupHandle(<field>) to return a specific popup.  
    Notes: The popup widget and this property will be created and set by 
           widgetwalk in the session manager when this manager is running. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFieldPopupMapping AS CHARACTER  NO-UNDO.
  {get FieldPopupMapping cFieldPopupMapping}.

  RETURN cFieldPopupMapping.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldSecurity) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFieldSecurity Procedure 
FUNCTION getFieldSecurity RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a character value  (in a list form, comma-seperated) 
            of the security type corresponding to AllFieldHandles.
            <security type>,<security type>...
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cSecurityType AS CHARACTER NO-UNDO.
  {get FieldSecurity cSecurityType}.
  RETURN cSecurityType.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFont) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFont Procedure 
FUNCTION getFont RETURNS INTEGER
(  ) :
/*------------------------------------------------------------------------------
  Purpose: get the font of the frame 
    Notes:  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE hFrame AS HANDLE     NO-UNDO.

 {get ContainerHandle hFrame}.
 IF VALID-HANDLE(hFrame) THEN
   RETURN hFrame:FONT.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getHeight) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getHeight Procedure 
FUNCTION getHeight RETURNS DECIMAL
    (  ) :
/*------------------------------------------------------------------------------
  Purpose: Return the height of the object 
    Notes: Use resizeObject to set the height. 
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hContainer    AS HANDLE    NO-UNDO.
    {get ContainerHandle hContainer}.

    IF VALID-HANDLE(hContainer)THEN 
       RETURN hContainer:HEIGHT.

    RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLayoutOptions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLayoutOptions Procedure 
FUNCTION getLayoutOptions RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the list of multi-layout options for the 
            object.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cLayout AS CHARACTER NO-UNDO.
  {get LayoutOptions cLayout}.
  RETURN cLayout.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLayoutVariable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLayoutVariable Procedure 
FUNCTION getLayoutVariable RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the name of the &LAYOUT-VARIABLE preprocessor for the 
            object, which is used as a prefix to the name of the procedure 
            which resets it.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cLayout AS CHARACTER NO-UNDO.
  {get LayoutVariable cLayout}.
  RETURN cLayout.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMinHeight) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getMinHeight Procedure 
FUNCTION getMinHeight RETURNS DECIMAL
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the pre-determined minimum height of a visual object
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE dHeight             AS DECIMAL    NO-UNDO.

    &SCOPED-DEFINE xpMinHeight
    {get MinHeight dHeight}.
    &UNDEFINE xpMinHeight
    
    IF dHeight = 0 OR dHeight = ? THEN
    DO:
      &SCOPED-DEFINE xp-assign
      {get Height dHeight}
      {set MinHeight dHeight}.
      &UNDEFINE xp-assign
    END.

    RETURN dHeight.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMinWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getMinWidth Procedure 
FUNCTION getMinWidth RETURNS DECIMAL
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the pre-determined minimum width of a visual object
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE dWidth              AS DECIMAL    NO-UNDO.

    &SCOPED-DEFINE xpMinWidth
    {get MinWidth dWidth}.
    &UNDEFINE xpMinWidth
    
    IF dWidth = 0 OR dWidth = ? THEN
    DO:
      &SCOPED-DEFINE xp-assign
      {get Width dWidth}
      {set MinWidth dWidth}.
      &UNDEFINE xp-assign
    END.

    RETURN dWidth.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectEnabled) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjectEnabled Procedure 
FUNCTION getObjectEnabled RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a flag indicating whether the current object is enabled.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lEnabled AS LOGICAL NO-UNDO.
  {get ObjectEnabled lEnabled}.
  RETURN lEnabled.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectLayout) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjectLayout Procedure 
FUNCTION getObjectLayout RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the current Layout Name for the object.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cLayout AS CHARACTER NO-UNDO.
  {get ObjectLayout cLayout}.
  RETURN cLayout.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectSecured) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjectSecured Procedure 
FUNCTION getObjectSecured RETURNS LOGICAL
    (   ) :
/*------------------------------------------------------------------------------
  Purpose: Tells whether the Security has been applied to the object 
    Notes: Set to true by the Repository retrieval process for dynamic objects
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lObjectSecured  AS LOGICAL  NO-UNDO.
  {get ObjectSecured lObjectSecured}.    
  RETURN lObjectSecured.
END FUNCTION.   /* getObjectSecured */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getObjectTranslated) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjectTranslated Procedure 
FUNCTION getObjectTranslated RETURNS LOGICAL
    (   ) :
/*------------------------------------------------------------------------------
  Purpose: Tells whether Translation has been applied to the object 
    Notes: Set to true by the Repository retrieval process for dynamic objects
------------------------------------------------------------------------------*/
DEFINE VARIABLE lObjectTranslated  AS LOGICAL  NO-UNDO.

  {get ObjectTranslated lObjectTranslated}.
  RETURN lObjectTranslated.
END FUNCTION.   /* getObjectTranslated */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPopupButtonsInFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPopupButtonsInFields Procedure 
FUNCTION getPopupButtonsInFields RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: When set to YES, automatic calendar and calculator popup buttons will 
           be placed inside, on the right hand side of the field.  
           When NO, the popup button will be placed outside, to the right of the 
           field.  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lPopupButtonsInFields AS LOGICAL   NO-UNDO.
  {get PopupButtonsInFields lPopupButtonsInFields}. 
  RETURN lPopupButtonsInFields.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getResizeHorizontal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getResizeHorizontal Procedure 
FUNCTION getResizeHorizontal RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns TRUE of the object can be resized horizontal
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE lResizeHorizontal AS LOGICAL NO-UNDO.

    {get ResizeHorizontal lResizeHorizontal}.

    RETURN lResizeHorizontal.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getResizeVertical) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getResizeVertical Procedure 
FUNCTION getResizeVertical RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns TRUE of the object can be resized vertical
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE lResizeVertical AS LOGICAL NO-UNDO.

    {get ResizeVertical lResizeVertical}.

    RETURN lResizeVertical.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRow Procedure 
FUNCTION getRow RETURNS DECIMAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Return the height of the object 
    Notes: Use repositionObject to set the Row.   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hContainer AS HANDLE NO-UNDO.
  
  {get ContainerHandle hContainer}.

  RETURN IF VALID-HANDLE(hContainer) THEN hContainer:ROW ELSE ?.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSecuredTokens) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSecuredTokens Procedure 
FUNCTION getSecuredTokens RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Return the list of securedtokens for the container 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hContainerSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cObjectName      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRunAttribute    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSecuredTokens   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lObjectSecured   AS LOGICAL    NO-UNDO.

  &SCOPED-DEFINE xpSecuredTokens
  {get SecuredTokens cSecuredTokens}.
  &UNDEFINE xpSecuredTokens
  
  IF cSecuredtokens = ? THEN
  DO:
      /* if object is secured, we do not need to get the tokens as there must not
         be any, we must just set the secured tokens to blank and not null, so the
         check is never done again. The reason why it may be null and object 
         secured already yes is because the dynamics repository manager does not
         set the secured tokens to blank even though it has checked the object 
         security and determined that there are no security tokens for the 
         container. It was decided that a check in here for the object secured 
         property was the safest fix for this so it can cater for other potential
         scenarios where this may also be the case.
         Without the check for object secured, we end up with an extra appserver
         hit per container when there are no secured tokens for an object.
      */  
      {get ObjectSecured lObjectSecured}.
      /* not (log = TRUE) to treat unknown as false */
      IF NOT (lObjectSecured = TRUE) THEN
      DO:
          {get ContainerSource hContainerSource}.

        
          IF VALID-HANDLE(hContainerSource) THEN
          DO:              
              &SCOPED-DEFINE xp-assign
              {get LogicalObjectName cObjectName hContainerSource}
              {get RunAttribute cRunAttribute hContainerSource}.
              &UNDEFINE xp-assign
          END.
          ELSE
              ASSIGN
                cObjectName = "":U
                cRunAttribute = "":U.
        
          IF VALID-HANDLE(gshSecurityManager) THEN
              /* get list of secured tokens for the container instance */
              RUN tokenSecurityCheck IN gshSecurityManager (INPUT  cObjectName,
                                                            INPUT  cRunAttribute,
                                                            OUTPUT cSecuredTokens).
      END.
      
      IF cSecuredTokens EQ ? THEN
          ASSIGN cSecuredTokens = "":U.                                                        
      
      /* Set it to indicate that we have done some security. */
      &SCOPED-DEFINE xp-assign
      {set ObjectSecured YES}
      {set SecuredTokens cSecuredTokens}.      
      &UNDEFINE xp-assign
  END.    /* object not secured */
  
  RETURN cSecuredTokens.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUseWidgetID) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUseWidgetID Procedure 
FUNCTION getUseWidgetID RETURNS LOGICAL
        (  ):
/*------------------------------------------------------------------------------
    Purpose:
    Notes:
------------------------------------------------------------------------------*/
RETURN CAN-DO(SESSION:STARTUP-PARAMETERS, "-usewidgetid":U).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getWidth Procedure 
FUNCTION getWidth RETURNS DECIMAL
    (  ) :
/*------------------------------------------------------------------------------
  Purpose: Return the Width of the object 
    Notes: Use resizeObject to set the Width. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hContainer  AS HANDLE  NO-UNDO. 

  {get ContainerHandle hContainer}.
  IF VALID-HANDLE(hContainer) THEN 
    RETURN hContainer:WIDTH.
    
  RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hideWidget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION hideWidget Procedure 
FUNCTION hideWidget RETURNS LOGICAL
  ( INPUT pcNameList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Hides the object or objects in the NameList.
   Params:  INPUT pcNameList AS CHARACTER
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE iField     AS INTEGER    NO-UNDO.
DEFINE VARIABLE cField     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cQualifier AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hField     AS HANDLE     NO-UNDO.
DEFINE VARIABLE hPopup     AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTarget    AS HANDLE     NO-UNDO.
DEFINE VARIABLE lInvalid   AS LOGICAL    NO-UNDO.

  /* If the first name in the list is qualified that is stored so that it can be used
     as the qualifier for following non-qualified names in the list.  */
  IF NUM-ENTRIES(pcNameList) > 1 AND NUM-ENTRIES(ENTRY(1, pcNameList), '.':U) > 1 THEN
    ASSIGN cQualifier = SUBSTRING(ENTRY(1, pcNameList), 1, R-INDEX(ENTRY(1, pcNameList), '.')).

  DO iField = 1 TO NUM-ENTRIES(pcNameList):
    cField = ENTRY(iField, pcNameList).
    IF NUM-ENTRIES(cField, '.':U) = 1 AND cQualifier NE '':U THEN
      cField = cQualifier + cField.
    RUN locateWidget IN TARGET-PROCEDURE (INPUT cField, OUTPUT hField, OUTPUT hTarget).
    IF VALID-HANDLE(hField) THEN
    DO:
      /* This is a SmartDataField. */
      IF CAN-QUERY(hField, 'FILE-NAME':U) THEN
        RUN hideObject IN hField.
      ELSE IF CAN-SET(hField, 'HIDDEN':U) THEN  /* Viewer fields */
      DO:
        hField:HIDDEN = YES NO-ERROR.
        IF ERROR-STATUS:ERROR THEN lInvalid = YES.
        ELSE 
          hPopup = DYNAMIC-FUNCTION('popupHandle':U IN hTarget, INPUT hField) NO-ERROR.
        IF VALID-HANDLE(hPopup) THEN
          hPopup:HIDDEN = YES.
      END.  /* else if can set hidden */
      ELSE IF CAN-SET(hField, 'VISIBLE':U) THEN  /* Browser columns */
      DO:
        hField:VISIBLE = NO NO-ERROR.
        IF ERROR-STATUS:ERROR THEN lInvalid = YES.
      END.  /* if can set visible - browser */
      ELSE lInvalid = YES.
    END.    /* END ELSE DO IF VALID-HANDLE */
    ELSE lInvalid = YES.
  END.        /* END DO iField */

  /* Return FALSE if any field was invalid. */
  RETURN NOT lInvalid.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-highlightWidget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION highlightWidget Procedure 
FUNCTION highlightWidget RETURNS LOGICAL
  ( INPUT pcNameList AS CHARACTER,
    INPUT pcHighlightType AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Highlights the object or objects in the NameList based on 
            highlight type.
   Params:  INPUT pcNameList AS CHARACTER
    Notes:  Valid highlight types are:
            info[rmation] - uses colorInfoBG & FG
            warn[inf] - uses colorWarnBG & FG
            err[or] - uses colorErrorBG & FB
            def[ault] - sets to Windows default
            Does not support SmartDataFields
------------------------------------------------------------------------------*/
DEFINE VARIABLE iBGColor   AS INTEGER    INIT ?  NO-UNDO.
DEFINE VARIABLE iFGColor   AS INTEGER    INIT ?  NO-UNDO.
DEFINE VARIABLE iField     AS INTEGER            NO-UNDO.
DEFINE VARIABLE cField     AS CHARACTER          NO-UNDO.
DEFINE VARIABLE cQualifier AS CHARACTER          NO-UNDO.
DEFINE VARIABLE hField     AS HANDLE             NO-UNDO.
DEFINE VARIABLE hTarget    AS HANDLE             NO-UNDO.
DEFINE VARIABLE lInvalid   AS LOGICAL            NO-UNDO.

  /* If the first name in the list is qualified that is stored so that it can be used
     as the qualifier for following non-qualified names in the list.  */
  IF NUM-ENTRIES(pcNameList) > 1 AND NUM-ENTRIES(ENTRY(1, pcNameList), '.':U) > 1 THEN
    ASSIGN cQualifier = SUBSTRING(ENTRY(1, pcNameList), 1, R-INDEX(ENTRY(1, pcNameList), '.')).

  DO iField = 1 TO NUM-ENTRIES(pcNameList):
    cField = ENTRY(iField, pcNameList).
    IF NUM-ENTRIES(cField, '.':U) = 1 AND cQualifier NE '':U THEN
      cField = cQualifier + cField.
    RUN locateWidget IN TARGET-PROCEDURE (INPUT cField, OUTPUT hField, OUTPUT hTarget).
    IF VALID-HANDLE(hField) THEN
    DO:
      /* not allowed if secured as hidden */       
      IF {fnarg fieldSecurityRule hField hTarget} = 'Hidden':U THEN
        lInvalid = TRUE.
      ELSE IF pcHighlightType BEGINS 'INFO':U THEN
      DO:
        &SCOPED-DEFINE xp-assign
        {get ColorInfoBG iBGColor hTarget}
        {get ColorInfoFG iFGColor hTarget}.
        &UNDEFINE xp-assign
      END.  /* if info */
      ELSE IF pcHighlightType BEGINS 'WARN':U THEN
      DO:
        &SCOPED-DEFINE xp-assign
        {get ColorWarnBG iBGColor hTarget}
        {get ColorWarnFG iFGColor hTarget}.
        &UNDEFINE xp-assign
      END.  /* if warn */
      ELSE IF pcHighlightType BEGINS 'ERR':U THEN
      DO:
        &SCOPED-DEFINE xp-assign
        {get ColorErrorBG iBGColor hTarget}
        {get ColorErrorFG iFGColor hTarget}.
        &UNDEFINE xp-assign
      END.  /* if error */
      ELSE IF pcHighlightType BEGINS 'DEF':U THEN.
      ELSE RETURN FALSE.

      IF CAN-SET(hField, 'BGCOLOR':U) AND CAN-SET(hField, 'FGCOLOR':U) THEN  
      DO:
        ASSIGN 
          hField:BGCOLOR = iBGColor 
          hField:FGCOLOR = iFGColor NO-ERROR.
        IF ERROR-STATUS:ERROR THEN lInvalid = YES.
      END.  /* if can set visible - browser */
      ELSE lInvalid = YES.
    END.    /* END ELSE DO IF VALID-HANDLE */
    ELSE lInvalid = YES.
  END.        /* END DO iField */

  /* Return FALSE if any field was invalid. */
  RETURN NOT lInvalid.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-internalWidgetHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION internalWidgetHandle Procedure 
FUNCTION internalWidgetHandle RETURNS HANDLE
  ( INPUT pcField AS CHARACTER,
    INPUT pcSearchMode AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Return handle of named widget in this object  
    Notes:  This version is for visual objects and does not use
            search mode, it searches in AllFieldNames for the widget
------------------------------------------------------------------------------*/
DEFINE VARIABLE cFieldNames   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFieldHandles AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iFieldPos     AS INTEGER    NO-UNDO.
DEFINE VARIABLE hField        AS HANDLE     NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get AllFieldNames cFieldNames}
  {get AllFieldHandles cFieldHandles}.
  &UNDEFINE xp-assign
  iFieldPos = LOOKUP(pcField, cFieldNames).
  IF iFieldPos NE 0 THEN 
    hField = WIDGET-HANDLE(ENTRY(iFieldPos, cFieldHandles)).

  IF VALID-HANDLE(hField) THEN RETURN hField.
  ELSE RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-popupHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION popupHandle Procedure 
FUNCTION popupHandle RETURNS HANDLE
  ( pcField AS CHAR) :
/*------------------------------------------------------------------------------
   Purpose: Returns the dynamically created popup button handle for a field  
Parameters: pcFieldName - char
            - The stringed handle of the widget. 
            - The unique name of the Field in the object.    
     Notes: The popup widget and the corresponding FieldPopupMapping property 
            will be created by widgetwalk in the session manager when this 
            manager is running.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFieldPopupMapping AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldNames        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldHandles      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cHandle            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hPopup             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iPos               AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hField             AS HANDLE     NO-UNDO.

  hField = WIDGET-HANDLE(pcField) NO-ERROR.
  /* if not valid widget then assume a name is passed */
  IF NOT VALID-HANDLE(hField) THEN
  DO:
    /* Although this only applies to enabled fields we check the Displayed list
      as the EnabledFields may change while the object is running */
    {get DisplayedFields cFieldNames}.
    ipos = LOOKUP(pcField,cFieldNames).  
    IF iPos > 0 THEN
    DO:
      {get FieldHandles cFieldHandles}.
      cHandle = ENTRY(iPos,cFieldHandles).
    END.
    ELSE DO:
      {get EnabledObjFlds cFieldNames}.
      ipos = LOOKUP(pcField,cFieldNames).
      IF iPos > 0 THEN
      DO:
        {get EnabledObjHdls cFieldHandles}.
        cHandle = ENTRY(iPos,cFieldHandles).
      END.
    END.
  END.
  ELSE  /* Passed in a handle */
  DO:
    /* The allFieldHandles can be used to find all the handles  */
    {get AllFieldHandles cFieldHandles}.
    iPos = LOOKUP(pcField,cFieldHandles). 
    IF iPos > 0 THEN
      cHandle = pcField.
  END.

  IF iPos > 0 AND cHandle > '':U THEN 
  DO:
    {get FieldPopupMapping cFieldPopupMapping}.
    
    iPos = LOOKUP(cHandle,cFieldPopupMapping).
    IF iPos > 0 AND (iPos MOD 2) = 1 THEN
      hPopup = WIDGET-HANDLE(ENTRY(iPos + 1,cFieldPopupMapping)) NO-ERROR.
  END.
  RETURN hPopup. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resetWidgetValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION resetWidgetValue Procedure 
FUNCTION resetWidgetValue RETURNS LOGICAL
  ( INPUT pcNameList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Resets the SCREEN-VALUE of the object or objects in the NameList
            to their original values from their data source.
   Params:  INPUT pcNameList AS CHARACTER
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE iField        AS INTEGER   NO-UNDO.
DEFINE VARIABLE cField        AS CHARACTER NO-UNDO.
DEFINE VARIABLE cQualifier    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cValue        AS CHARACTER NO-UNDO.
DEFINE VARIABLE hDataSource   AS HANDLE    NO-UNDO.
DEFINE VARIABLE hField        AS HANDLE    NO-UNDO.
DEFINE VARIABLE hTarget       AS HANDLE    NO-UNDO.
DEFINE VARIABLE lInvalid      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE hColumnHandle AS HANDLE    NO-UNDO.
DEFINE VARIABLE cWidgetName   AS CHARACTER NO-UNDO.

  /* If the first name in the list is qualified that is stored so that it can be used
     as the qualifier for following non-qualified names in the list.  */
  IF NUM-ENTRIES(pcNameList) > 1 AND NUM-ENTRIES(ENTRY(1, pcNameList), '.':U) > 1 THEN
    ASSIGN cQualifier = SUBSTRING(ENTRY(1, pcNameList), 1, R-INDEX(ENTRY(1, pcNameList), '.')).

  DO iField = 1 TO NUM-ENTRIES(pcNameList):
    cField = ENTRY(iField, pcNameList).
    IF NUM-ENTRIES(cField, '.':U) = 1 AND cQualifier NE '':U THEN
      cField = cQualifier + cField.
    RUN locateWidget IN TARGET-PROCEDURE (INPUT cField, OUTPUT hField, OUTPUT hTarget).
    IF VALID-HANDLE(hField) THEN
    DO:
      /* not allowed if secured as hidden */       
      IF {fnarg fieldSecurityRule hField hTarget} = 'Hidden':U THEN
        lInvalid = TRUE.
      ELSE
      DO:
        {get DataSource hDataSource hTarget}.
        IF VALID-HANDLE(hDataSource) THEN
        DO:
          /*This function is designed only to work with db fields, if a non-db field is passed as parameter,
            the columnHandle function returns null. That field is ignored.*/
          ASSIGN cWidgetName   = DYNAMIC-FUNCTION('widgetName':U IN TARGET-PROCEDURE, INPUT hField) 
                 hColumnHandle = DYNAMIC-FUNCTION('columnHandle':U IN hDataSource, INPUT cWidgetName).
          IF hColumnHandle = ? THEN
              lInvalid = YES.
          ELSE DO:
              cValue = {fnarg columnValue cWidgetName hDataSource}.
              lInvalid = NOT DYNAMIC-FUNCTION('assignWidgetValue':U IN TARGET-PROCEDURE,
                                               INPUT cField, INPUT cValue).
          END.
        END.  /* if valid data source */
        ELSE lInvalid = YES.
      END. /* else (if not secured hidden) */
    END.  /* if valid hField */
    ELSE lInvalid = YES.
  END.  /* END DO iField */

  /* Return FALSE if any field was invalid. */
  RETURN NOT lInvalid.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-sensitizePopup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION sensitizePopup Procedure 
FUNCTION sensitizePopup RETURNS LOGICAL
  ( phField     AS HANDLE,
    plSensitive AS LOG ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hPopup AS HANDLE     NO-UNDO.
  
  hPopup = {fnarg popupHandle phField}.
  IF VALID-HANDLE(hPopup) THEN
  DO:
    hPopup:SENSITIVE = plSensitive.
    IF SESSION:WINDOW-SYSTEM ="MS-WINXP":U THEN 
      ASSIGN
        hPopup:BGCOLOR = IF plSensitive 
                         THEN IF phField:BGCOLOR = ? 
                              THEN 15 
                              ELSE phField:BGCOLOR
                         ELSE ?.

    RETURN TRUE. 
  END.

  RETURN FALSE.    

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-sensitizeRadioButton) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION sensitizeRadioButton Procedure 
FUNCTION sensitizeRadioButton RETURNS LOGICAL
  ( INPUT pcNameList  AS CHARACTER,
    INPUT piButtonNum AS INTEGER,
    INPUT plEnable    AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:  Disables/enables the specified radio button for the object or 
            objects in the NameList.
   Params:  INPUT pcNameList  AS CHARACTER
            INPUT piButtonNum AS INTEGER
            INPUT plEnable    AS LOGICAL
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE iField                AS INTEGER    NO-UNDO.
DEFINE VARIABLE cField                AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cLabel                AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cQualifier            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hField                AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTarget               AS HANDLE     NO-UNDO.
DEFINE VARIABLE lInvalid              AS LOGICAL    NO-UNDO.

  /* If the first name in the list is qualified that is stored so that it can be used
     as the qualifier for following non-qualified names in the list.  */
  IF NUM-ENTRIES(pcNameList) > 1 AND NUM-ENTRIES(ENTRY(1, pcNameList), '.':U) > 1 THEN
    ASSIGN cQualifier = SUBSTRING(ENTRY(1, pcNameList), 1, R-INDEX(ENTRY(1, pcNameList), '.')).

  DO iField = 1 TO NUM-ENTRIES(pcNameList):
    cField = ENTRY(iField, pcNameList).
    IF NUM-ENTRIES(cField, '.':U) = 1 AND cQualifier NE '':U THEN
      cField = cQualifier + cField.
    RUN locateWidget IN TARGET-PROCEDURE (INPUT cField, OUTPUT hField, OUTPUT hTarget).
    IF VALID-HANDLE(hField) THEN
    DO:
      IF {fnarg fieldSecurityRule hField hTarget} > '':U THEN
        lInvalid = TRUE.
      ELSE IF CAN-QUERY(hField, 'RADIO-BUTTONS':U) THEN
      DO:
        cLabel = ENTRY((piButtonNum * 2) - 1, hField:RADIO-BUTTONS, hField:DELIMITER) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN lInvalid = YES.
        ELSE DO:
          IF plEnable THEN hField:ENABLE(cLabel) NO-ERROR.
          ELSE hField:DISABLE(cLabel) NO-ERROR.
          IF ERROR-STATUS:ERROR THEN 
            lInvalid = YES.
        END.  /* else no error */
      END.  /* if can query radio buttons */
      ELSE lInvalid = YES.
    END.  /* if valid hField */
    ELSE lInvalid = YES.
  END.  /* do iField to number in namelist */

  /* Return FALSE if any field was invalid. */
  RETURN NOT lInvalid.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAllFieldHandles) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAllFieldHandles Procedure 
FUNCTION setAllFieldHandles RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:    
    Notes:   
------------------------------------------------------------------------------*/
  {set AllFieldHandles pcValue}.
  RETURN TRUE.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAllFieldNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAllFieldNames Procedure 
FUNCTION setAllFieldNames RETURNS LOGICAL
  ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:    
    Notes:   
------------------------------------------------------------------------------*/
  {set AllFieldNames pcValue}.
  RETURN TRUE.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBGColor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBGColor Procedure 
FUNCTION setBGColor RETURNS LOGICAL
 ( piBGColor AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose: Sets the background color of the frame 
   Params: piBGColor AS INTEGER 
    Notes:  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE hFrame AS HANDLE     NO-UNDO.

 {get ContainerHandle hFrame}.
 IF VALID-HANDLE(hFrame) THEN
    hFrame:BGCOLOR = piBGColor.  

 {set BGCOLOR piBGColor}.
 RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setColorErrorBG) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setColorErrorBG Procedure 
FUNCTION setColorErrorBG RETURNS LOGICAL
  ( piColor AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the error background color number
   Params:  piColor AS INTEGER 
    Notes:  Used by highlightWidget function
------------------------------------------------------------------------------*/
  {set ColorErrorBG piColor}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setColorErrorFG) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setColorErrorFG Procedure 
FUNCTION setColorErrorFG RETURNS LOGICAL
  ( piColor AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the error foreground color number
   Params:  piColor AS INTEGER 
    Notes:  Used by highlightWidget function
------------------------------------------------------------------------------*/
  {set ColorErrorFG piColor}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setColorInfoBG) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setColorInfoBG Procedure 
FUNCTION setColorInfoBG RETURNS LOGICAL
  ( piColor AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the information background color number
   Params:  piColor AS INTEGER 
    Notes:  Used by highlightWidget function
------------------------------------------------------------------------------*/
  {set ColorInfoBG piColor}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setColorInfoFG) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setColorInfoFG Procedure 
FUNCTION setColorInfoFG RETURNS LOGICAL
  ( piColor AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the information foreground color number
   Params:  piColor AS INTEGER 
    Notes:  Used by highlightWidget function
------------------------------------------------------------------------------*/
  {set ColorInfoFG piColor}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setColorWarnBG) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setColorWarnBG Procedure 
FUNCTION setColorWarnBG RETURNS LOGICAL
  ( piColor AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the warning background color number
   Params:  piColor AS INTEGER 
    Notes:  Used by highlightWidget function
------------------------------------------------------------------------------*/
  {set ColorWarnBG piColor}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setColorWarnFG) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setColorWarnFG Procedure 
FUNCTION setColorWarnFG RETURNS LOGICAL
  ( piColor AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the warning foreground color number
   Params:  piColor AS INTEGER 
    Notes:  Used by highlightWidget function
------------------------------------------------------------------------------*/
  {set ColorWarnFG piColor}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDefaultLayout) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDefaultLayout Procedure 
FUNCTION setDefaultLayout RETURNS LOGICAL
  ( pcDefault AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  sets the default layout name for this object.
   Params:  pcDefault AS CHARACTER
------------------------------------------------------------------------------*/

  {set DefaultLayout pcDefault}.
  RETURN TRUE.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDisableOnInit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDisableOnInit Procedure 
FUNCTION setDisableOnInit RETURNS LOGICAL
  ( plDisable AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets a flag indicating whether the object should be disabled when
            it's first realized.
   Params:  plDisable AS LOGICAL -- true if object should be disabled on init.
------------------------------------------------------------------------------*/
  {set DisableOnInit plDisable}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setEnabledObjFlds) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setEnabledObjFlds Procedure 
FUNCTION setEnabledObjFlds RETURNS LOGICAL
    ( pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: 
Parameters:    
    Notes:   
------------------------------------------------------------------------------*/
    {set EnabledObjFlds pcValue}.

    RETURN TRUE.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setEnabledObjHdls) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setEnabledObjHdls Procedure 
FUNCTION setEnabledObjHdls RETURNS LOGICAL
  ( pcHdls AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the list of the handles of widgets enabled in this object
            not associated with data fields.
   Params:  INPUT pcHdls AS CHARACTER
------------------------------------------------------------------------------*/
  {set EnabledObjHdls pcHdls}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFGColor) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFGColor Procedure 
FUNCTION setFGColor RETURNS LOGICAL
( piFGColor AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose: Sets the foreground color of the frame 
   Params: piBGColor AS INTEGER 
    Notes:  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE hFrame AS HANDLE     NO-UNDO.

 {get ContainerHandle hFrame}.
 IF VALID-HANDLE(hFrame) THEN
    hFrame:FGCOLOR = piFGColor.  

 {set FGCOLOR piFGColor}.
 RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFieldPopupMapping) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFieldPopupMapping Procedure 
FUNCTION setFieldPopupMapping RETURNS LOGICAL
  ( pcFieldPopupMapping AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the mapping of field and object handles and their dynamically 
           created popup handle. The list can be used directly, but is also used
           by popupHandle(<field>) to return a specific popup.  
    Notes: The popup widget and this property will be created and set by 
           widgetwalk in the session manager when this manager is running. 
------------------------------------------------------------------------------*/
  {set FieldPopupMapping pcFieldPopupMapping}.

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFieldSecurity) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFieldSecurity Procedure 
FUNCTION setFieldSecurity RETURNS LOGICAL
  ( pcSecurityType AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets a character value  (in a list form, comma-seperated) 
            of the security type corresponding to AllFieldHandles.
            e.g. <security type>,<security type>...
   Params:  <none>
------------------------------------------------------------------------------*/
  
  {set FieldSecurity pcSecurityType}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFont) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFont Procedure 
FUNCTION setFont RETURNS LOGICAL
( piFont AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose: Sets the font of the frame 
   Params: piFont AS INTEGER 
    Notes:  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE hFrame AS HANDLE     NO-UNDO.

 {get ContainerHandle hFrame}.
 IF VALID-HANDLE(hFrame) THEN
    hFrame:FONT = piFont.
 
 RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLayoutOptions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLayoutOptions Procedure 
FUNCTION setLayoutOptions RETURNS LOGICAL
  ( pcOptions AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the list of different multi-layout option names for this object.
   Params:  pcOptions AS CHARACTER -- comma-separated list of layout names.  
------------------------------------------------------------------------------*/

  {set LayoutOptions pcOptions}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setMinHeight) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setMinHeight Procedure 
FUNCTION setMinHeight RETURNS LOGICAL
    ( INPUT pdHeight            AS DECIMAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the minimum height of a visual object
    Notes:  
------------------------------------------------------------------------------*/
    &SCOPED-DEFINE xpMinHeight
    {set MinHeight pdHeight}.
    &UNDEFINE xpMinHeight

    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setMinWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setMinWidth Procedure 
FUNCTION setMinWidth RETURNS LOGICAL
    ( INPUT pdWidth            AS DECIMAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the minimum width of a visual object
    Notes:  
------------------------------------------------------------------------------*/
    
    &SCOPED-DEFINE xpMinWidth
    {set MinWidth pdWidth}.
    &UNDEFINE xpMinWidth

    RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setObjectLayout) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setObjectLayout Procedure 
FUNCTION setObjectLayout RETURNS LOGICAL
  ( pcLayout AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the Layout of the object for Alternate Layout support.
   Params:  <none>
------------------------------------------------------------------------------*/

  {set ObjectLayout pcLayout}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setObjectSecured) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setObjectSecured Procedure 
FUNCTION setObjectSecured RETURNS LOGICAL
  ( plSecured as logical ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the Layout of the object for Alternate Layout support.
   Params:  <none>
------------------------------------------------------------------------------*/
  {set ObjectSecured plSecured}.
  
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setObjectTranslated) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setObjectTranslated Procedure 
FUNCTION setObjectTranslated RETURNS LOGICAL
  ( plValue as logical ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the Layout of the object for Alternate Layout support.
   Params:  <none>
------------------------------------------------------------------------------*/
  {set ObjectTranslated plValue}.
  
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPopupButtonsInFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setPopupButtonsInFields Procedure 
FUNCTION setPopupButtonsInFields RETURNS LOGICAL
  ( plPopupButtonsInFields AS LOG ) :
/*------------------------------------------------------------------------------
  Purpose: When set to YES, automatic calendar and calculator popup buttons will 
           be placed inside, on the right hand side of the field.  
           When NO, the popup button will be placed outside, to the right of the 
           field.  
    Notes:  
------------------------------------------------------------------------------*/
  {set PopupButtonsInFields plPopupButtonsInFields}. 
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setResizeHorizontal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setResizeHorizontal Procedure 
FUNCTION setResizeHorizontal RETURNS LOGICAL
  ( INPUT plResizeHorizontal AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets TRUE of the object can be resized horizontally
    Notes:  
------------------------------------------------------------------------------*/
    {set ResizeHorizontal plResizeHorizontal}.

    RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setResizeVertical) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setResizeVertical Procedure 
FUNCTION setResizeVertical RETURNS LOGICAL
  ( INPUT plResizeVertical AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets TRUE of the object can be resized vertically
    Notes:  
------------------------------------------------------------------------------*/

    {set ResizeVertical plResizeVertical}.

    RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSecuredTokens) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSecuredTokens Procedure 
FUNCTION setSecuredTokens RETURNS LOGICAL
    ( pcSecuredTokens AS CHAR ) :
  /*------------------------------------------------------------------------------
    Purpose:  Set the list of securedtokens (from the container really) 
      Notes:  SET from getSecuredTokens the first time (when the value is ?)
  ------------------------------------------------------------------------------*/   
    &SCOPED-DEFINE xpSecuredTokens
    {set SecuredTokens pcSecuredTokens}.
    &UNDEFINE xpSecuredTokens

    RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setWidgetID) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setWidgetID Procedure 
FUNCTION setWidgetID RETURNS LOGICAL
        (INPUT piWidgetID AS INTEGER):
/*------------------------------------------------------------------------------
    Purpose:
    Notes:
------------------------------------------------------------------------------*/
DEFINE VARIABLE hFrame AS HANDLE     NO-UNDO.
    {get ContainerHandle hFrame}.
    ASSIGN hFrame:WIDGET-ID = piWidgetID NO-ERROR.
    RETURN NOT ERROR-STATUS:ERROR.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-toggleWidget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION toggleWidget Procedure 
FUNCTION toggleWidget RETURNS LOGICAL
  ( INPUT pcNameList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Reverses the value the object or objects of type LOGICAL in the NameList.
   Params:  INPUT pcNameList AS CHARACTER
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE iField                AS INTEGER    NO-UNDO.
DEFINE VARIABLE cField                AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cQualifier            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFalseFormat          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTrueFormat           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hField                AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTarget               AS HANDLE     NO-UNDO.
DEFINE VARIABLE lInvalid              AS LOGICAL    NO-UNDO.
  
  /* If the first name in the list is qualified that is stored so that it can be used
     as the qualifier for following non-qualified names in the list.  */
  IF NUM-ENTRIES(pcNameList) > 1 AND NUM-ENTRIES(ENTRY(1, pcNameList), '.':U) > 1 THEN
    ASSIGN cQualifier = SUBSTRING(ENTRY(1, pcNameList), 1, R-INDEX(ENTRY(1, pcNameList), '.')).

  DO iField = 1 TO NUM-ENTRIES(pcNameList):
    cField = ENTRY(iField, pcNameList).
    IF NUM-ENTRIES(cField, '.':U) = 1 AND cQualifier NE '':U THEN
      cField = cQualifier + cField.
    RUN locateWidget IN TARGET-PROCEDURE (INPUT cField, OUTPUT hField, OUTPUT hTarget).
    IF VALID-HANDLE(hField) THEN
    DO:
      /* not allowed if secured as hidden */       
      IF {fnarg fieldSecurityRule hField hTarget} = 'Hidden':U THEN
        lInvalid = TRUE.

      ELSE IF CAN-QUERY(hField, 'SCREEN-VALUE':U) 
      AND CAN-QUERY(hField, 'DATA-TYPE':U) 
      AND hField:DATA-TYPE = 'LOGICAL':U THEN
      DO:

        ASSIGN 
          cTrueFormat  = ENTRY(1, hField:FORMAT, "/":U)
          cFalseFormat = ENTRY(2, hField:FORMAT, "/":U) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN lInvalid = YES.
        ELSE DO:
          IF NUM-ENTRIES(cField, '.':U) > 1 THEN
            cField = ENTRY(NUM-ENTRIES(cField, '.':U), cField, '.':U).
          CASE hField:SCREEN-VALUE:
            WHEN cTrueFormat THEN hField:SCREEN-VALUE = cFalseFormat NO-ERROR.
            WHEN cFalseFormat THEN hField:SCREEN-VALUE = cTrueFormat NO-ERROR.
            OTHERWISE lInvalid = YES.
          END CASE.
          IF ERROR-STATUS:ERROR THEN 
            lInvalid = YES.
          ELSE 
             /* SetDataModified if applicable (no-error as this is in datavis) */
            RUN fieldModified IN hTarget (hField) NO-ERROR.
        END.  /* else do - no error */
      END.  /* if can query screen-value and data-type and logical */
      ELSE lInvalid = YES.
    END.  /* if valid hField */
    ELSE lInvalid = YES.
  END.        /* END DO iField */

  /* Return FALSE if any field was invalid. */
  RETURN NOT lInvalid.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-viewWidget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION viewWidget Procedure 
FUNCTION viewWidget RETURNS LOGICAL
  ( INPUT pcNameList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Views the object or objects in the NameList.
   Params:  INPUT pcNameList AS CHARACTER
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE iField     AS INTEGER    NO-UNDO.
DEFINE VARIABLE cField     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cQualifier AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hField     AS HANDLE     NO-UNDO.
DEFINE VARIABLE hPopup     AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTarget    AS HANDLE     NO-UNDO.
DEFINE VARIABLE lInvalid   AS LOGICAL    NO-UNDO.

  /* If the first name in the list is qualified that is stored so that it can be used
     as the qualifier for following non-qualified names in the list.  */
  IF NUM-ENTRIES(pcNameList) > 1 AND NUM-ENTRIES(ENTRY(1, pcNameList), '.':U) > 1 THEN
    ASSIGN cQualifier = SUBSTRING(ENTRY(1, pcNameList), 1, R-INDEX(ENTRY(1, pcNameList), '.')).

  DO iField = 1 TO NUM-ENTRIES(pcNameList):
    cField = ENTRY(iField, pcNameList).
    IF NUM-ENTRIES(cField, '.':U) = 1 AND cQualifier NE '':U THEN
      cField = cQualifier + cField.
    RUN locateWidget IN TARGET-PROCEDURE (INPUT cField, OUTPUT hField, OUTPUT hTarget).
    IF VALID-HANDLE(hField) THEN
    DO:
       /* not allowed if secured as hidden */       
      IF {fnarg fieldSecurityRule hField hTarget} = 'Hidden':U THEN
        lInvalid = TRUE.

      /* This is a SmartDataField. */
      ELSE IF CAN-QUERY(hField, 'FILE-NAME':U) THEN
        RUN viewObject IN hField.
      ELSE IF CAN-SET(hField, 'HIDDEN':U) THEN  /* Viewer fields */
      DO:
        hField:HIDDEN = NO NO-ERROR.
        IF ERROR-STATUS:ERROR THEN lInvalid = YES.
        ELSE 
          hPopup = DYNAMIC-FUNCTION('popupHandle':U IN hTarget, INPUT hField) NO-ERROR.
        IF VALID-HANDLE(hPopup) THEN
          hPopup:HIDDEN = NO.
      END.  /* else if can set hidden */
      ELSE IF CAN-SET(hField, 'VISIBLE':U) THEN  /* Browser columns */
      DO:
        hField:VISIBLE = YES NO-ERROR.
        IF ERROR-STATUS:ERROR THEN lInvalid = YES.
      END.  /* if can set visible - browser */
      ELSE lInvalid = YES.
    END.    /* END ELSE DO IF VALID-HANDLE */
    ELSE lInvalid = YES.
  END.        /* END DO iField */

  /* Return FALSE if any field was invalid. */
  RETURN NOT lInvalid.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-widgetHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION widgetHandle Procedure 
FUNCTION widgetHandle RETURNS HANDLE
  ( INPUT pcName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle of pcName 
   Params:  INPUT pcName AS CHARACTER
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cField                AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hField                AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTarget               AS HANDLE     NO-UNDO.

  RUN locateWidget IN TARGET-PROCEDURE (INPUT pcName, OUTPUT hField, OUTPUT hTarget).
  IF VALID-HANDLE(hField) THEN RETURN hField.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-widgetIsBlank) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION widgetIsBlank Procedure 
FUNCTION widgetIsBlank RETURNS LOGICAL
  ( pcNameList AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Check if one or several widgets are blank 
Parameter: pcColumn - column name (comma-separated list)  
    Notes: This was implemented to be able workaround the fact that INPUT-VALUE 
           performs an implicit validation of format that makes it impossible
           to check whether a field with a restrictive format really is blank.
         - Returns true if ALL widgets are blank  
------------------------------------------------------------------------------*/  
  DEFINE VARIABLE hField        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cField        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iWidget       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cChar         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQualifier    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTarget       AS HANDLE     NO-UNDO.

  DEFINE FRAME testFrame cChar. 

  /* If the first name in the list is qualified that is stored so that it can be used
     as the qualifier for following non-qualified names in the list.  */
  IF NUM-ENTRIES(pcNameList) > 1 AND NUM-ENTRIES(ENTRY(1, pcNameList), '.':U) > 1 THEN
    ASSIGN cQualifier = SUBSTRING(ENTRY(1, pcNameList), 1, R-INDEX(ENTRY(1, pcNameList), '.')).
  
  DO iWidget = 1 TO NUM-ENTRIES(pcNameList) WITH FRAME testFrame:
    cField = ENTRY(iWidget,pcNameList). 
    IF NUM-ENTRIES(cField, '.':U) = 1 AND cQualifier NE '':U THEN
      cField = cQualifier + cField.
    RUN locateWidget IN TARGET-PROCEDURE (INPUT cField, OUTPUT hField, OUTPUT hTarget).
    
    /* If the widget is not valid then return unknown. */
    IF NOT VALID-HANDLE(hField) THEN RETURN ?.    
    
    /* not allowed if secured as hidden */       
    IF {fnarg fieldSecurityRule hField hTarget} = 'Hidden':U THEN
      RETURN ?.
    
    /* This is a SmartDataField, check its DataValue */
    IF CAN-QUERY(hField, 'FILE-NAME':U) THEN
    DO:
      {get DataValue cValue hField}.
      IF cValue <> '':U THEN RETURN FALSE.
    END.  /* if can query file-name - SDF */
    ELSE DO:
      IF hField:DATA-TYPE <> 'CHARACTER':U THEN
        RETURN FALSE.  

      IF CAN-QUERY(hField, 'FORMAT':U) AND CAN-QUERY(hField, 'SCREEN-VALUE':U) THEN 
      DO:
        /* We assign the fields screen-value to another field, to take advantage of
           the fact that the screen-value of this will return blank even in the case 
           where the original screen-value is different from blank due to the format 
           mask. */        
        ASSIGN 
          cChar:FORMAT       = hField:FORMAT
          cChar:SCREEN-VALUE = hField:SCREEN-VALUE NO-ERROR.    
    
        IF cChar:SCREEN-VALUE <> '':U THEN
          RETURN FALSE.
      END.  /* if can query format */
      ELSE IF CAN-QUERY(hField, 'SCREEN-VALUE':U) THEN DO:
        IF hField:SCREEN-VALUE <> '':U THEN
          RETURN FALSE.
      END.  /* else if can query screen-value */
      ELSE RETURN ?.

    END. /* else do - not SDF */
  END. 

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-widgetIsFocused) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION widgetIsFocused Procedure 
FUNCTION widgetIsFocused RETURNS LOGICAL
  ( INPUT pcName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the TRUE if pcName has focus
   Params:  INPUT pcName AS CHARACTER
    Notes:  Does not support SmartDataFields
------------------------------------------------------------------------------*/
DEFINE VARIABLE hField                AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTarget               AS HANDLE     NO-UNDO.

  RUN locateWidget IN TARGET-PROCEDURE (INPUT pcName, OUTPUT hField, OUTPUT hTarget).
  IF VALID-HANDLE(hField) THEN DO: 
    IF hField = FOCUS THEN RETURN TRUE.
    ELSE RETURN FALSE.
  END.  /* if valid hField */
  ELSE RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-widgetIsModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION widgetIsModified Procedure 
FUNCTION widgetIsModified RETURNS LOGICAL
  ( INPUT pcNameList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a logical value indicating whether the value of any of
            the list of fields passed in has changed since it was displayed.
   Params:  INPUT pcNameList AS CHARACTER
    Notes:  A single LOGICAL value is returned if *any* of the INPUT fields
            has changed. This makes it easy to determine whether any of the
            values which are involved in an expression or calculation have 
            changed.
            The function returns unknown (?) if any field is invalid or
            can't be queried.
------------------------------------------------------------------------------*/
DEFINE VARIABLE iField     AS INTEGER    NO-UNDO.
DEFINE VARIABLE cField     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cQualifier AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hField     AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTarget    AS HANDLE     NO-UNDO.
DEFINE VARIABLE lModified  AS LOGICAL    NO-UNDO.

  /* If the first name in the list is qualified that is stored so that it can be used
     as the qualifier for following non-qualified names in the list.  */
  IF NUM-ENTRIES(pcNameList) > 1 AND NUM-ENTRIES(ENTRY(1, pcNameList), '.':U) > 1 THEN
    ASSIGN cQualifier = SUBSTRING(ENTRY(1, pcNameList), 1, R-INDEX(ENTRY(1, pcNameList), '.')).

  DO iField = 1 TO NUM-ENTRIES(pcNameList):
    cField = ENTRY(iField, pcNameList).
    IF NUM-ENTRIES(cField, '.':U) = 1 AND cQualifier NE '':U THEN
      cField = cQualifier + cField.
    RUN locateWidget IN TARGET-PROCEDURE (INPUT cField, OUTPUT hField, OUTPUT hTarget).
    IF NOT VALID-HANDLE(hField) THEN
      RETURN ?.
    ELSE DO:
      IF CAN-QUERY(hField, 'FILE-NAME':U) THEN
        /* This is a SmartDataField. Use its DataModified property. */
        {get DataModified lModified hField}.
      ELSE IF CAN-QUERY(hField, 'MODIFIED':U) THEN
        lModified = hField:MODIFIED.
      ELSE RETURN ?.

      IF lModified THEN
        RETURN TRUE.
    END.    /* END ELSE DO IF VALID-HANDLE */
  END.    /* END DO iField */

  /* If we fell through, then no field was modified. */
  RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-widgetIsTrue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION widgetIsTrue Procedure 
FUNCTION widgetIsTrue RETURNS LOGICAL
  ( INPUT pcName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the value of pcName 
   Params:  INPUT pcName AS CHARACTER
    Notes:  pcName must be a logical 
            Does not support SmartDataFields
------------------------------------------------------------------------------*/
DEFINE VARIABLE cField                AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hBuffer               AS HANDLE     NO-UNDO.
DEFINE VARIABLE hField                AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTarget               AS HANDLE     NO-UNDO.
DEFINE VARIABLE lValue                AS LOGICAL    NO-UNDO.

  RUN locateWidget IN TARGET-PROCEDURE (INPUT pcName, OUTPUT hField, OUTPUT hTarget).
  IF VALID-HANDLE(hField) THEN
  DO:
    /* not allowed if secured as hidden */       
    IF {fnarg fieldSecurityRule hField hTarget} = 'Hidden':U THEN
      lValue = ?.
    ELSE IF CAN-QUERY(hField, 'DATA-TYPE':U) 
    AND hField:DATA-TYPE = 'LOGICAL':U THEN
    DO:
      IF CAN-QUERY(hField, 'INPUT-VALUE':U) THEN
      DO:
        lValue = hField:INPUT-VALUE NO-ERROR.
        IF ERROR-STATUS:ERROR THEN lValue = ?.
      END.  /* if can query input value */
      /* If cannot query INPUT-VALUE then this is a browser and we are in the middle of a
         ROW-DISPLAY trigger so we must use the buffer instead */
      ELSE DO:
        {get QueryRowObject hBuffer hTarget} NO-ERROR.
        IF VALID-HANDLE(hBuffer) THEN
        DO:
          IF NUM-ENTRIES(pcName, ".") = 2 THEN
            pcName = ENTRY(2, pcName, ".").
          ASSIGN hField = hBuffer:BUFFER-FIELD(pcName)
                 lValue = hField:BUFFER-VALUE NO-ERROR.
          IF ERROR-STATUS:ERROR THEN lValue = ?.
        END.  /* if hBuffer valid */
        ELSE lValue = ?.
      END.  /* else do - browser */
    END.  /* if logical */
    ELSE lValue =  ?.
  END.  /* if valid hField */
  ELSE lValue = ?.

  RETURN lValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-widgetLongcharValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION widgetLongcharValue Procedure 
FUNCTION widgetLongcharValue RETURNS LONGCHAR
  ( INPUT pcName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the unformatted value of an object.
   Params:  INPUT pcName AS CHARACTER
    Notes:  Does not support SmartDataFields
------------------------------------------------------------------------------*/
DEFINE VARIABLE cValue     AS LONGCHAR   NO-UNDO.
DEFINE VARIABLE hBuffer    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hField     AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTarget    AS HANDLE     NO-UNDO.

  RUN locateWidget IN TARGET-PROCEDURE (INPUT pcName, OUTPUT hField, OUTPUT hTarget).
  IF VALID-HANDLE(hField) THEN
  DO:
    /* not allowed if secured as hidden */       
    IF {fnarg fieldSecurityRule hField hTarget} = 'Hidden':U THEN
      cValue = ?.

    ELSE IF hField:DATA-TYPE = 'LONGCHAR':U THEN
      cValue = hField:INPUT-VALUE.

    ELSE 
      cValue = DYNAMIC-FUNCTION('widgetValue':U IN TARGET-PROCEDURE,pcName).
                                 
  END.  /* if hField valid */
  ELSE cValue = ?.

  RETURN cValue.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-widgetName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION widgetName Procedure 
FUNCTION widgetName RETURNS CHARACTER
           ( phField AS HANDLE ):
/*------------------------------------------------------------------------------
  Purpose:  Return name of widget in this object  
    Notes:  The :NAME attribute of a field does NOT always have the name of 
            an object. 
          - Cannot currently be used BEFORE the object is initialized   
------------------------------------------------------------------------------*/
DEFINE VARIABLE cFieldNames   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFieldHandles AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iFieldPos     AS INTEGER    NO-UNDO.
DEFINE VARIABLE cField        AS CHARACTER  NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get AllFieldNames cFieldNames}
  {get AllFieldHandles cFieldHandles}.
  &UNDEFINE xp-assign
  iFieldPos = LOOKUP(STRING(phField), cFieldHandles).
  IF iFieldPos NE 0 THEN 
    cField = ENTRY(iFieldPos, cFieldNames).
  ELSE 
    cField = phField:NAME.

  RETURN cField.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-widgetValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION widgetValue Procedure 
FUNCTION widgetValue RETURNS CHARACTER
  ( INPUT pcName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the unformatted value of an object.
   Params:  INPUT pcName AS CHARACTER
    Notes:  Does not support SmartDataFields
------------------------------------------------------------------------------*/
DEFINE VARIABLE cValue     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hBuffer    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hField     AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTarget    AS HANDLE     NO-UNDO.

  RUN locateWidget IN TARGET-PROCEDURE (INPUT pcName, OUTPUT hField, OUTPUT hTarget).
  IF VALID-HANDLE(hField) THEN
  DO:
    /* not allowed if secured as hidden */       
    IF {fnarg fieldSecurityRule hField hTarget} = 'Hidden':U THEN
      cValue = ?.
    ELSE IF CAN-QUERY(hField, 'FILE-NAME':U) THEN
      cValue = {fn getDataValue hField}.
    ELSE IF CAN-QUERY(hField, 'INPUT-VALUE':U) THEN  /* Viewer fields */
    DO:
      cValue = hField:INPUT-VALUE NO-ERROR.
      /* INPUT-VALUE will return a 4GL error if the value is blank and the format does not
         allow blank.  If there is an error, check if the widget is blank and if so return blank */
      IF ERROR-STATUS:ERROR THEN
      DO:
        IF DYNAMIC-FUNCTION('widgetIsBlank':U IN hTarget,pcName) THEN 
          cValue = '':U.
        ELSE 
          cValue = ?.
      END.
    END.  /* if can query input-value - viewer */
    /* If cannot query INPUT-VALUE then this is a browser and we are in the middle of a 
       ROW-DISPLAY trigger so we must use the buffer instead */
    ELSE DO:  
      {get QueryRowObject hBuffer hTarget} NO-ERROR.
      IF VALID-HANDLE(hBuffer) THEN
      DO:
        IF NUM-ENTRIES(pcName, ".") = 2 THEN
          pcName = ENTRY(2, pcName, ".").
        ASSIGN hField = hBuffer:BUFFER-FIELD(pcName)
               cValue = STRING(hField:BUFFER-VALUE) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN cValue = ?.
      END.  /* if hBuffer valid */
      ELSE cValue = ?.  
    END.  /* else do - browser */
  END.  /* if hField valid */
  ELSE cValue = ?.

  RETURN cValue.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-widgetValueList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION widgetValueList Procedure 
FUNCTION widgetValueList RETURNS CHARACTER
  ( INPUT pcNameList  AS CHARACTER,
    INPUT pcDelimiter AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the unformatted value of objects in a delimited list.
   Params:  INPUT pcNameList  AS CHARACTER
            INPUT pcDelimiter AS CHARACTER
    Notes:  If pcDelimiter is ?, | is used
            Does not support SmartDataFields
------------------------------------------------------------------------------*/
DEFINE VARIABLE cField     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cQualifier AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cValue     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cValueList AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iField     AS INTEGER    NO-UNDO.

  IF pcDelimiter = ? THEN pcDelimiter = '|':U.

  /* If the first name in the list is qualified that is stored so that it can be used
     as the qualifier for following non-qualified names in the list.  */
  IF NUM-ENTRIES(pcNameList) > 1 AND NUM-ENTRIES(ENTRY(1, pcNameList), '.':U) > 1 THEN
    ASSIGN cQualifier = SUBSTRING(ENTRY(1, pcNameList), 1, R-INDEX(ENTRY(1, pcNameList), '.')).

  DO iField = 1 TO NUM-ENTRIES(pcNameList):
    cField = ENTRY(iField, pcNameList).
    IF NUM-ENTRIES(cField, '.':U) = 1 AND cQualifier NE '':U THEN
      cField = cQualifier + cField.
    cValue = DYNAMIC-FUNCTION('widgetValue':U IN TARGET-PROCEDURE, INPUT cField).
    cValueList = cValueList + (IF iField = 1 THEN '':U ELSE pcDelimiter) +
                 IF cValue = ? THEN '?':U ELSE cValue.
  END.  /* do iField to number entries in namelist */

  RETURN cValueList.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

