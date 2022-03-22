&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/***********************************************************************
* Copyright (C) 2005-2007 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*------------------------------------------------------------------------
    File        : field.p
    Purpose     : Super procedure for SmartDataField objects

    Syntax      : adm2/field.p

    Modified    : June 23, 1999 Version 9.1A
    Modified    : 16/11/2001    Mark Davies (MIP)
                  Added functions getSDFFrameHandle to return the frame
                  handle of any SDF frame. This is used to move away
                  from using PRIVATE-DATA in ADM procedures.
                  17 Nov 2001   Peter Judge
                  Added support for SDF's on local fill-ins. The FieldName
                  attribute of SDF's on local fill-in's must be "<Local>".
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Tell fieldprop.i that this is the Super procedure. */
  &SCOP ADMSuper field.p
  
  {src/adm2/custom/fieldexclcustom.i}

{launch.i &define-only = YES }

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */
&IF DEFINED(EXCLUDE-getFrameWidgetID) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFrameWidgetID Procedure
FUNCTION getFrameWidgetID RETURNS INTEGER 
	(  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFrameWidgetID) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFrameWidgetID Procedure
FUNCTION setFrameWidgetID RETURNS LOGICAL 
	(INPUT piFrameWidgetID AS INTEGER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-formattedValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD formattedValue Procedure 
FUNCTION formattedValue RETURNS CHARACTER
  (pcValue AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getColonPosition) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getColonPosition Procedure 
FUNCTION getColonPosition RETURNS DECIMAL
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCustomSuperProc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCustomSuperProc Procedure 
FUNCTION getCustomSuperProc RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataModified Procedure 
FUNCTION getDataModified RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataValue Procedure 
FUNCTION getDataValue RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDisplayField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDisplayField Procedure 
FUNCTION getDisplayField RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDisplayValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDisplayValue Procedure 
FUNCTION getDisplayValue RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getEnableField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getEnableField Procedure 
FUNCTION getEnableField RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldEnabled) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFieldEnabled Procedure 
FUNCTION getFieldEnabled RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFieldHandle Procedure 
FUNCTION getFieldHandle RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFieldName Procedure 
FUNCTION getFieldName RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getKeyField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getKeyField Procedure 
FUNCTION getKeyField RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getKeyFieldValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getKeyFieldValue Procedure 
FUNCTION getKeyFieldValue RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLocalField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLocalField Procedure 
FUNCTION getLocalField RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSavedScreenValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSavedScreenValue Procedure 
FUNCTION getSavedScreenValue RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSDFFrameHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSDFFrameHandle Procedure 
FUNCTION getSDFFrameHandle RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCustomSuperProc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCustomSuperProc Procedure 
FUNCTION setCustomSuperProc RETURNS LOGICAL
  ( INPUT pcCustomSuperProc AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataModified Procedure 
FUNCTION setDataModified RETURNS LOGICAL
  ( plModified AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataValue Procedure 
FUNCTION setDataValue RETURNS LOGICAL
  ( INPUT pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDisplayField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDisplayField Procedure 
FUNCTION setDisplayField RETURNS LOGICAL
  ( plDisplay AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDisplayValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDisplayValue Procedure 
FUNCTION setDisplayValue RETURNS LOGICAL
  ( INPUT pcValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setEnableField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setEnableField Procedure 
FUNCTION setEnableField RETURNS LOGICAL
  ( plEnable AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFieldEnabled) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFieldEnabled Procedure 
FUNCTION setFieldEnabled RETURNS LOGICAL
  ( plEnabled AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFieldName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFieldName Procedure 
FUNCTION setFieldName RETURNS LOGICAL
  ( pcField AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setKeyField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setKeyField Procedure 
FUNCTION setKeyField RETURNS LOGICAL
  ( pcKeyField AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setKeyFieldValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setKeyFieldValue Procedure 
FUNCTION setKeyFieldValue RETURNS LOGICAL
  ( pcValue AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLocalField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLocalField Procedure 
FUNCTION setLocalField RETURNS LOGICAL
  ( plLocal AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSavedScreenValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSavedScreenValue Procedure 
FUNCTION setSavedScreenValue RETURNS LOGICAL
  ( pcValue AS CHAR )  FORWARD.

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
         HEIGHT             = 22.67
         WIDTH              = 58.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/fieldprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */ 
&IF DEFINED(EXCLUDE-assignWidgetID) = 0 &THEN
		
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignWidgetID Procedure
PROCEDURE assignWidgetID:
/*------------------------------------------------------------------------------
    Purpose: This procedure is called from combo.p, lookup.p and select.p to
             assign widget-ids for their created widgets.
             Before assign the widget-id to those widgets it is required to
             validate the container source and WidgetIDFileName attribute, if
             they have invalid values, we don't set the widget-ids in order to
             avoid duplicates.
    Parameters:
    Notes:
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER hWidget1 AS HANDLE     NO-UNDO.
DEFINE INPUT  PARAMETER iWidget1 AS INTEGER    NO-UNDO.
DEFINE INPUT  PARAMETER hWidget2 AS HANDLE     NO-UNDO.
DEFINE INPUT  PARAMETER iWidget2 AS INTEGER    NO-UNDO.

DEFINE VARIABLE hContainer AS HANDLE NO-UNDO.
DEFINE VARIABLE cFileName  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cUIBMode   AS CHARACTER  NO-UNDO.

{get UIBMode cUIBMode}.

IF cUIBMode BEGINS 'DESIGN':U THEN RETURN.

ASSIGN hContainer = DYNAMIC-FUNCTION('getContainerSource' IN TARGET-PROCEDURE) NO-ERROR.

IF NOT VALID-HANDLE(hContainer) THEN RETURN.

ASSIGN cFileName = DYNAMIC-FUNCTION('getWidgetIDFileName' IN hContainer).

IF cFileName = ? OR cFileName = "" THEN RETURN.

IF hWidget1 NE ? THEN
ASSIGN hWidget1:WIDGET-ID = iWidget1 NO-ERROR.

IF hWidget2 NE ? THEN
ASSIGN hWidget2:WIDGET-ID = iWidget2 NO-ERROR.

RETURN.
END PROCEDURE.
	
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF
&IF DEFINED(EXCLUDE-assignLabelWidgetID) = 0 &THEN
		
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignLabelWidgetID Procedure
PROCEDURE assignLabelWidgetID:
/*------------------------------------------------------------------------------------
    Purpose: Assign the widget-id for the field label.
    Parameters: <none>
    Notes: The label is placed over the viewer frame, and not over the SDF frame.
           Therefore if another widget over the frame has the same widget-id value (4)
           than the label, we get duplicate widget-ids.
           In order to avoid that this procedure gets the widget-id assigned to the
           SDF frame, and adds that value to the label widget-id set to 4.
------------------------------------------------------------------------------------*/
DEFINE VARIABLE hLabel         AS HANDLE    NO-UNDO.
DEFINE VARIABLE iFrameWidgetID AS INTEGER   NO-UNDO.
DEFINE VARIABLE hContainer     AS HANDLE    NO-UNDO.
DEFINE VARIABLE cFileName      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cUIBMode       AS CHARACTER NO-UNDO.
  &SCOPED-DEFINE xp-assign
  {get LabelHandle hLabel}
  {get FrameWidgetID iFrameWidgetID}
  {get ContainerSource hContainer}
  {get UIBMode cUIBMode}.  
  &UNDEFINE xp-assign

IF cUIBMode BEGINS 'DESIGN':U THEN RETURN.

IF NOT VALID-HANDLE(hContainer) THEN RETURN.

ASSIGN cFileName = DYNAMIC-FUNCTION('getWidgetIDFileName' IN hContainer).

IF cFileName = ? THEN RETURN.

  ASSIGN hLabel:WIDGET-ID = iFrameWidgetID + 4 NO-ERROR.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-clearField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearField Procedure 
PROCEDURE clearField :
/*------------------------------------------------------------------------------
  Purpose: Clear the widget WITHOUT displaying a corresponding value.    
    Notes: It should typically NOT be used as part of a normal display, but 
           may be useful to clear the screen, for example in filter UIs. 
           The viewer will call this when there is no record available to 
           display.  
         - This allows the sub-classes; lookup and select to be cleared 
           without any lookup and potential appserver hits to set the 
           DisplayedValue. 
         - setDataValue('') should normally be used to Display the blank value
           of the Lookup as a blank value may not necessarily be visualized as
           blank, but require the DisplayedField to show a corresponding value.
         - If getFieldHandle does not return a valid handle then 
           setDataValue('') will be called. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hField AS HANDLE     NO-UNDO.

  {get FieldHandle hField}.

  IF VALID-HANDLE(hField) THEN
  DO:
    CASE hField:TYPE:
      WHEN 'COMBO-BOX':U THEN
        {fnarg clearCombo hField}.
      WHEN 'RADIO-SET':U THEN  /* radio-set show first button */
        hField:SCREEN-VALUE = ENTRY(2,hField:RADIO-BUTTONS) NO-ERROR. 

      OTHERWISE /* fill-in selection-list */
        hField:SCREEN-VALUE = '' NO-ERROR. 
    END CASE.
  END. /* valid */
  
  /* Static instances may not have a FieldHandle, setDataValue('') is called 
     to achieve old behavior. 
     THIS MUST ONLY BE DONE WHEN NOT VALID-HANDLE as some setDataValue 
     overrides actually calls this when blank.  */
  ELSE 
    {set DataValue ''}.

  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Special code for initializing SmartDataFields.
  Parameters:  <none>
  Notes:       The SmartDataField adds itself to the DisplayedFields property
               of its containing SmartDataViewer if the DisplayField logical 
               property is true, and to the EnabledFields or, if localField, 
               EnabledObjFlds, if EnableField is true.
------------------------------------------------------------------------------*/
    DEFINE VARIABLE lInitialized      AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE cField            AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lLocal            AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE lEnable           AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE lDisplay          AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE hSource           AS HANDLE     NO-UNDO.
    DEFINE VARIABLE cCustomSuperProc  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cList             AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lDisableOnInit    AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE lHideOnInit       AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE cEnabledObjFlds   AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lSecured          AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE lTranslated       AS LOGICAL    NO-UNDO.

    DEFINE VARIABLE cSuperProcedureMode         AS CHARACTER          NO-UNDO.
    
    {get ObjectInitialized lInitialized}.
    IF lInitialized THEN 
       RETURN "adm-error":U. 

    {get ContainerSource hSource}.
    IF VALID-HANDLE(hSource) THEN
    DO:
      /* Start the SDF's super procedure - if specified */
      {get CustomSuperProc cCustomSuperProc}.
      /* If the super procedure couldn't be found for in the CustomSuperProc
         property then we should test for it in SuperProcedure */
      IF cCustomSuperProc = "":U OR cCustomSuperProc = ? THEN
        {get SuperProcedure cCustomSuperProc}.

      IF cCustomSuperProc <> "":U AND cCustomSuperProc <> ? THEN
      DO:
          /* Default to STATEFUL mode because that is historically our default. */
          ASSIGN cSuperProcedureMode = "STATEFUL":U.
          
          /* Is Dynamics running? */
          IF VALID-HANDLE(gshSessionManager) THEN
          DO:
              {launch.i
                  &PLIP  = cCustomSuperProc
                  &IProc = ''
                  &OnApp = 'NO'
              }
              /* Add all the super procedures. */
              DYNAMIC-FUNCTION("addAsSuperProcedure":U IN gshSessionManager,
                               INPUT hPlip, INPUT TARGET-PROCEDURE).
          END.    /* session manager is running */
          ELSE
          DO:
              DO ON STOP UNDO, RETURN 'ADM-ERROR':U:
                  RUN VALUE(cCustomSuperProc) PERSISTENT SET hPlip.
              END.    /* run the super procedure */
              
              IF VALID-HANDLE(hPlip) THEN
                  TARGET-PROCEDURE:ADD-SUPER-PROCEDURE(hPlip, SEARCH-TARGET).
          END.    /* sesison manger not running */
          
          /* Store the handle of the super so that it is killed when
             this object shuts down. The destruction of this super procedure
             is done by the container (the viewer typically).
           */
          IF cSuperProcedureMode NE "STATELESS":U THEN
              {set SuperProcedureHandle STRING(hPlip)}.
      END.    /* super procedure exists */
    END.   /* END DO IF ContainerSource */
    
    /* The SUPER call adds a cost that, although small per object, adds a 
       substantial performance cost when there are many datafields on an viewer. 
       So we call SUPER 
       - when there are fields/widgets in EnabledObjFlds (static SDF built in 
         Appbuilder) as we then need to build the corresponding EnabledObjHdls
         and also call EnableObject to enable them.
       - when the object is not secured or translated as we then need the call 
         to widgetwalk in visual.p (Rep man does this, so this should only 
         be false when inside static viewers) */    

    &SCOPED-DEFINE xp-assign
    {get ObjectSecured lSecured}
    {get ObjectTranslated lTranslated}
    {get EnabledObjFlds cEnabledObjFlds}
     .
    &SCOPED-DEFINE xp-assign
    /* not (log = true) to treat unknown and false similar  */ 
    IF NOT (lSecured = TRUE) OR NOT (lTranslated = TRUE) OR (cEnabledObjFlds > '':U) THEN
      RUN SUPER.
    
    ELSE DO: /* Duplicate the important stuff that would happen in supers */      
      &SCOPED-DEFINE xp-assign
      {set ObjectInitialized YES}
      {get DisableOnInit lDisableOnInit}
      {get HideOnInit lHideOnInit}.
      &UNDEFINE xp-assign
      
      IF NOT lDisableOnInit AND lEnable THEN
        RUN enableObject IN TARGET-PROCEDURE. 

      IF NOT lHideOnInit THEN 
        RUN viewObject IN TARGET-PROCEDURE.
      ELSE 
        PUBLISH "LinkState":U FROM TARGET-PROCEDURE ('inactive':U).      
    END. /* No enabledObjFlds (dynselect etc.. ) */

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resizeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject Procedure 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose: Resize the Field
  
  Parameters:  INPUT pidHeight decimal New height of component 
               INPUT pidWidth decimal New width of component
  
  Notes:  The procedure steps through all the widgets on the frame and, resizes
          the frame and the widgets.  
          The resizing logic is very primitive and its purpose is mainly to 
          ensure that a fill-in width a button to the right is resized nicely.
          It does this by ensurung that widgets keep the same distance to the 
          right edge decided by the right most widget. (assuming size to fit)
       -  Buttons. toggle-boxes and images (stretch-to-fit=false) are not 
          resized, but moved. Except if they are so far left that there should 
          not be any widget to the left of it... this is used to limit how much 
          the frame can schrink also.. 
        - Used at runtime and in AB when resized at designtime.   
        - The string 'NO-RESIZE' in the widget's PRIVATE-DATA will prevent
          resizing of a widget
        - The height is not changed on any widgets. 
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pdHeight AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER pdWidth  AS DECIMAL NO-UNDO.
  
  DEFINE VARIABLE dMinHeight       AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dMaxDiff         AS DECIMAL    NO-UNDO INIT ?.
  DEFINE VARIABLE dMinStretchWidth AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dMinMovableCol   AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dMinWidth        AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dMaxRight        AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dDiffWidth       AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE hWidget          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFieldGroup      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cUIBMode         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hFrame           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hUIBButton       AS HANDLE     NO-UNDO.
  /* buttons to the left of this will not be moved.. */  
  DEFINE VARIABLE xiMinWidth       AS INTEGER    NO-UNDO INIT 2.
  DEFINE VARIABLE xiLeftCol        AS INTEGER    NO-UNDO INIT 4.

  &SCOPED-DEFINE NoStretchWidget ~
((    hWidget:TYPE = 'BUTTON':U ~
  OR  hWidget:TYPE = 'TOGGLE-BOX':U ~
  OR (hWidget:TYPE = 'IMAGE':U AND hWidget:STRETCH-TO-FIT = FALSE)) ~
 AND hWidget:COL >= xiLeftCol) 
 
  &SCOPED-DEFINE xp-assign
  {get UIBmode cUIBMode} 
  {get ContainerHandle hFrame}
   .
  &UNDEFINE xp-assign
   
  ASSIGN
    hFieldGroup      = hFrame:FIRST-CHILD
    hWidget          = hFieldGroup:FIRST-CHILD.
  /* Loop through the widget and find the right/bottom minimum sizes 
    (this logic assumes size-to-fit)*/ 
  DO WHILE VALID-HANDLE(hWidget):
    /* In design mode the first dynamic button would be the UIB affordance 
       for the popup menu.  */
    IF cUIBMode = 'DESIGN':U 
    AND NOT VALID-HANDLE(hUIBButton)
    AND hWidget:TYPE = 'BUTTON':U
    AND hWidget:DYNAMIC THEN
      hUIBButton = hWidget.
    ELSE DO:
      ASSIGN
        dMinHeight       = MAX(hWidget:ROW + hWidget:HEIGHT - 1,dMinHeight)
        dMaxRight        = MAX(hWidget:COL + hWidget:WIDTH - 1,dMaxRight).

      /* If object is made smaller then keep track of min size 
         and max schrinkage */
      IF hWidget:TYPE = 'LITERAL':U 
      OR INDEX(hWidget:PRIVATE-DATA,'NO-RESIZE':U) > 0 THEN
         dMinWidth = MAX(hWidget:COL + hWidget:WIDTH - 1,dMinWidth).
       /* leftmost movable widget defines max shrinkage.. */
      ELSE IF {&NoStretchWidget} THEN 
         dMinMovableCol = IF dMinMovablecol = 0 THEN hWidget:COL 
                           ELSE MIN(hWidget:COL,dMinMovableCol).
      ELSE 
        /* smallest resizable widget defines max schrinkage */
        dMinStretchWidth = IF dMinStretchWidth = 0 THEN hWidget:WIDTH
                           ELSE MIN(hWidget:WIDTH,dMinStretchWidth).
    END.
    hWidget = hWidget:NEXT-SIBLING.
  END.
    
  /* If Maxright > new width then ensure we don't shrink too much */
  IF dMaxRight > pdWidth THEN
  DO:
    /* Increase width if necessary to keep leftmost movable object at leftcol */ 
    IF dMinMovableCol > 0 THEN
      pdWidth = MAX(pdWidth,dMaxRight - (dMinMovableCol - xiLeftcol)). 
    /* Increase width if necessary to keep mallest schrinkable widget ge min */ 
    IF dMinStretchWidth > 0 THEN
       pdWidth = MAX(pdWidth,dMaxRight - (dMinStretchWidth - xiMinWidth)). 
  END.

  ASSIGN 
    hFrame:SCROLLABLE     = TRUE
    hFrame:WIDTH          = MAX(dMinWidth,pdWidth)
    hFrame:HEIGHT         = MAX(dMinHeight,pdHeight)
    hFrame:VIRTUAL-WIDTH  = hFrame:WIDTH
    hFrame:VIRTUAL-HEIGHT = hFrame:HEIGHT
    hFrame:SCROLLABLE     = FALSE
    dDiffWidth            = hFrame:WIDTH - dMaxRight.

  IF dDiffWidth <> 0 OR cUIBMode = 'Design':U THEN
  DO:
    hWidget = hFieldGroup:FIRST-CHILD.        
    DO WHILE VALID-HANDLE(hWidget):

      IF  hWidget:TYPE <> 'LITERAL':U 
      AND (hWidget:PRIVATE-DATA = ? 
           OR INDEX(hWidget:PRIVATE-DATA,'NO-RESIZE':U) = 0)  
      AND hUIBButton <> hWidget THEN
      DO:
        /* Move buttons and fixed images on the right part of the screen 
           accordingly, unless they are far to the left */  
       IF {&NoStretchWidget} THEN
         hWidget:COL = hWidget:COL + dDiffWidth NO-ERROR.
       ELSE 
         hWidget:WIDTH = hWidget:WIDTH + dDiffwidth NO-ERROR.
      END.
      hWidget = hWidget:NEXT-SIBLING.
    END. /* do while valid hWidget */
  END.

  ASSIGN hFrame:SCROLLABLE = TRUE.

  RETURN.

  &UNDEFINE NoStretchWidget
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-formattedValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION formattedValue Procedure 
FUNCTION formattedValue RETURNS CHARACTER
  (pcValue AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Return the formatted value of a passed value according to the 
           SmartSelect/Dynamic Combo/Dynamic Lookup/SDF format. 
Parameter: pcValue - The value that need to be formatted.      
    Notes: Used internally in order to ensure that unformatted data can be 
           applied to screen-value (setDataValue) or used as lookup in
           list-item-pairs in (getDisplayValue)  
           This code was moved from select.p into field.p to accomodate
           dynamic lookups and combos
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSelection AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cFormat    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataType  AS CHARACTER  NO-UNDO.

  {get SelectionHandle hSelection TARGET-PROCEDURE} NO-ERROR.
  /* For selection lists */
  IF VALID-HANDLE(hSelection) AND CAN-QUERY(hSelection,'FORMAT':U) THEN
    ASSIGN cFormat   = hSelection:FORMAT
           cDataType = hSelection:DATA-TYPE.
  /* For Dynamic Lookups and Combos */
  ELSE DO: 
    ASSIGN cFormat   = DYNAMIC-FUNCTION("getKeyFormat":U IN TARGET-PROCEDURE) NO-ERROR.
    ASSIGN cDataType = DYNAMIC-FUNCTION("getKeyDataType":U IN TARGET-PROCEDURE) NO-ERROR.
  END.

  /* Invalid Format */
  IF cFormat = "":U OR cFormat = ? OR cFormat = "?":U THEN
    RETURN pcValue.
  IF cDataType = "":U OR cDataType = ? OR cDataType = "?":U THEN
    RETURN pcValue.

  CASE cDataType:
    WHEN 'CHARACTER':U THEN
      pcValue = RIGHT-TRIM(STRING(pcValue,cFormat)).
    WHEN 'DATE':U THEN
      pcValue = STRING(DATE(pcValue),cFormat).
    WHEN 'DATETIME':U THEN
      pcValue = STRING(DATETIME(pcValue),cFormat).
    WHEN 'DATETIME-TZ':U THEN
      pcValue = STRING(DATETIME-TZ(pcValue),cFormat).
    WHEN 'DECIMAL':U THEN
      pcValue = STRING(DECIMAL(pcValue),cFormat).
    WHEN 'INTEGER':U THEN
      pcValue = STRING(INT(pcValue),cFormat).
    WHEN 'LOGICAL':U THEN
      pcValue = ENTRY(IF CAN-DO('yes,true':U,pcValue) THEN 1 ELSE 2,
                       cFormat,'/':U).
  END CASE.
  
  RETURN pcValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getColonPosition) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getColonPosition Procedure 
FUNCTION getColonPosition RETURNS DECIMAL
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
  Purpose:  Returns the 'colon' position  of the first viewable widget in 
            a SDF. This is used by the translateWidget() API in the Session
            Manager to determine where to reposition a SDF to in case of 
            translations.
    Notes:  *** This code is work-in-progress code to resolve issues around
                the positions of translated static SmartDataFields. 
------------------------------------------------------------------------------*/
    DEFINE VARIABLE dColonPosition              AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE dWidgetColumn               AS DECIMAL              NO-UNDO.
    DEFINE VARIABLE hWidget                     AS HANDLE               NO-UNDO.
    DEFINE VARIABLE cAllFieldHandles            AS CHARACTER            NO-UNDO.
    DEFINE VARIABLE iLoop                       AS INTEGER              NO-UNDO.

    /* Set a default value of 1. */
    ASSIGN dColonPosition = 1.
    
    {get LookupHandle hWidget} NO-ERROR.
    IF NOT VALID-HANDLE(hWidget) THEN
        {get ComboHandle hWidget} NO-ERROR.

    /* In the case of DynLookups and DynCombos
       the label is rendered outside of the SDF and 
       so the column position of the SDF will suffice.       
     */
    
    {get COL dColonPosition}.
    
    IF NOT VALID-HANDLE(hWidget) THEN
    /* For non-DynCombos, the label can be in or outside of the
       SDF.
     */
    DO:
        ASSIGN dWidgetColumn = 1.
        {get AllFieldHandles cAllFieldHandles}.
        DO iLoop = 1 TO NUM-ENTRIES(cAllFieldHandles):
            ASSIGN hWidget = WIDGET-HANDLE(ENTRY(iLoop, cAllFieldHandles)) NO-ERROR.
            
            IF NOT VALID-HANDLE(hWidget) OR
               NOT CAN-DO("fill-in,selection-list,editor,combo-box,radio-set,slider,toggle-box":U, hWidget:TYPE) THEN
                NEXT.

            ASSIGN dWidgetColumn = hWidget:COL.

            /* Just get the first non-default widget. */
            IF dWidgetColumn NE 1 THEN
                LEAVE.
        END.    /* loop through field handles */

        ASSIGN dColonPosition = dWidgetColumn.
    END.    /* this is not a dyncombo or lookup. */
    
    RETURN dColonPosition.
END FUNCTION.   /* getColonPosition */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCustomSuperProc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCustomSuperProc Procedure 
FUNCTION getCustomSuperProc RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the value of a SmartDataField.
   Params:  <none>
------------------------------------------------------------------------------*/

 DEFINE VARIABLE cCustomSuperProc AS CHARACTER NO-UNDO.
  
 &SCOPED-DEFINE xpCustomSuperProc
 {get CustomSuperProc cCustomSuperProc}.
 &UNDEFINE xpCustomSuperProc

  RETURN cCustomSuperProc.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataModified Procedure 
FUNCTION getDataModified RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns true if the SmartDataField value has been
            changed but not saved, otherwise false.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lModified AS LOGICAL NO-UNDO.
  
  &SCOPED-DEFINE xpDataModified
  {get DataModified lModified}.
  &UNDEFINE xpDataModified
 
  RETURN lModified.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataValue Procedure 
FUNCTION getDataValue RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the value of a SmartDataField.
   Params:  <none>
------------------------------------------------------------------------------*/

 DEFINE VARIABLE cDataValue AS CHARACTER NO-UNDO.
  
 &SCOPED-DEFINE xpDataValue
 {get DataValue cDataValue}.
 &UNDEFINE xpDataValue

  RETURN cDataValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDisplayField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDisplayField Procedure 
FUNCTION getDisplayField RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns true if the SmartDataField is to be displayed
            along with other fields in its Container, otherwise false.
   Params:  <none>
    Notes:  This instance property is initialized by the AppBuilder
            in adm-create-objects.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lDisplay AS LOGICAL NO-UNDO.
  
  {get DisplayField lDisplay}.
  RETURN lDisplay.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDisplayValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDisplayValue Procedure 
FUNCTION getDisplayValue RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the saved screen/display value of a SmartDataField.
   Params:  <none>
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cDisplayValue AS CHARACTER NO-UNDO.
 &SCOPED-DEFINE xpDisplayValue
 {get DisplayValue cDisplayValue}.
 &UNDEFINE xpDisplayValue  
  
 RETURN cDisplayValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getEnableField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getEnableField Procedure 
FUNCTION getEnableField RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns true if the SmartDataField is to be enabled for user
            input along with other fields in its Container, otherwise false.
   Params:  <none>
    Notes:  This instance property is initialized by the AppBuilder
            in adm-create-objects.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lEnable AS LOGICAL NO-UNDO.
  
  {get EnableField lEnable}.
  RETURN lEnable.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldEnabled) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFieldEnabled Procedure 
FUNCTION getFieldEnabled RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns true if the SmartDataField is enabled for user
            input, otherwise false.
   Params:  <none>
    Notes:  This property is set by user-defined SDF procedures
            enableField and disableField.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lEnabled AS LOGICAL NO-UNDO.
  
  {get FieldEnabled lEnabled}.
  RETURN lEnabled.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFieldHandle Procedure 
FUNCTION getFieldHandle RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: NO default value. 
    Notes: Overridden by subclasses or objects to return the field handle in 
           the cases where there is one single widget that is used for display 
           by the object.
         - The different sibling classes, like lookup and combo have all been 
           implemented with different names. 
         - This function is expected to replace those in order to achieve 
           polymorphism. 
         - Currently used by clearField.
------------------------------------------------------------------------------*/
  RETURN ?.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFieldName Procedure 
FUNCTION getFieldName RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the name of the SDO field this object maps to.
   Params: <none>  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cField AS CHARACTER NO-UNDO.
  {get FieldName cField}.
  RETURN cField.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getKeyFieldValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getKeyFieldValue Procedure 
FUNCTION getKeyFieldValue RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: See DataValue  
    Notes: Obsolete, but kept for backwards compatibility with ICF 0.9  
------------------------------------------------------------------------------*/
  RETURN {fn getDataValue}.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLocalField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLocalField Procedure 
FUNCTION getLocalField RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns TRUE if the field name begins with "<" (backswards 
            compatibility where fields were called <Local> to indicate
            that they were local fields) or it returns the value
            of the LocalField property.
   Params:  <none>
------------------------------------------------------------------------------*/
DEFINE VARIABLE cFieldName AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lLocal     AS LOGICAL NO-UNDO.
  
  {get FieldName cFieldName}.
  IF cFieldName BEGINS '<':U THEN RETURN TRUE.

  &SCOPED-DEFINE xpLocalField
  {get LocalField lLocal}.
  &UNDEFINE xpLocalField
  
  RETURN lLocal.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSavedScreenValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSavedScreenValue Procedure 
FUNCTION getSavedScreenValue RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: See DisplayValue  
    Notes: Obsolete, but kept for backwards compatibility with ICF 0.9  
------------------------------------------------------------------------------*/
  RETURN {fn getDisplayValue}.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSDFFrameHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSDFFrameHandle Procedure 
FUNCTION getSDFFrameHandle RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFrame  AS HANDLE     NO-UNDO.

  {get ContainerSource hSource}.
  IF VALID-HANDLE(hSource) THEN DO:
    {get ContainerHandle hFrame}. 
    IF VALID-HANDLE(hFrame) THEN
      RETURN hFrame.
  END.
  
  RETURN ?.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCustomSuperProc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCustomSuperProc Procedure 
FUNCTION setCustomSuperProc RETURNS LOGICAL
  ( INPUT pcCustomSuperProc AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE xpCustomSuperProc
  {set CustomSuperProc pcCustomSuperProc}.
  &UNDEFINE xpCustomSuperProc

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataModified Procedure 
FUNCTION setDataModified RETURNS LOGICAL
  ( plModified AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the DataModified property of the SmartDataField,
            and uses a standard event to notify the containing
            SmartDataViewer of this change.
   Params:  plModified AS LOGICAL
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hContainer  AS HANDLE  NO-UNDO.
  DEFINE VARIABLE lEnabled    AS LOGICAL NO-UNDO.
  DEFINE VARIABLE lContainMod AS LOGICAL    NO-UNDO.

  &SCOPED-DEFINE xpDataModified
  {set DataModified plModified}.
  &UNDEFINE xpDataModified
  
  IF plModified THEN  /* If it's "yes" then... */
  DO:
    {get ContainerSource hContainer}.  /* pass on to our parent. */    
    IF VALID-HANDLE(hContainer) THEN
      RUN fieldModified IN hContainer ( TARGET-PROCEDURE ).
  END.  /* END DO IF plModified */
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataValue Procedure 
FUNCTION setDataValue RETURNS LOGICAL
  ( INPUT pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE xpDataValue
  {set DataValue pcValue}.
  &UNDEFINE xpDataValue
  
  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDisplayField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDisplayField Procedure 
FUNCTION setDisplayField RETURNS LOGICAL
  ( plDisplay AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the DisplayField property of the SmartDataField.
   Params:  plDisplay AS LOGICAL
    Notes:  This property determines whether the field is to be Displayd
            along with other fields in its Container.
------------------------------------------------------------------------------*/

  {set DisplayField plDisplay}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDisplayValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDisplayValue Procedure 
FUNCTION setDisplayValue RETURNS LOGICAL
  ( INPUT pcValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    /* Set a variable to the value passed in to this function. This
       is because there is a 4GL bug in the 9.x family where, when
       assigning a field's INPUT-VALUE to a dynamic temp-table field,
       an error [** setDisplayValue adm2/field.p: Unable to evaluate 
       field for assignment. (143)] results if the input value 
       is the unknown value. This is logged as 20031205-002 (IZ13893),
       with the 4GL bug being 20030731-010.
       
       We get around this by using a literal unknown value when the 
       input-ed value is unknown, and using the passed in value in
       all other cases.
     */
  &SCOPED-DEFINE xpDisplayValue
  {set DisplayValue
      "(if pcValue eq ? then ? else pcValue)"
  }.
  &UNDEFINE xpDisplayValue

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setEnableField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setEnableField Procedure 
FUNCTION setEnableField RETURNS LOGICAL
  ( plEnable AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the EnableField property of the SmartDataField.
   Params:  plEnable AS LOGICAL
    Notes:  This property determines whether the field is to be enabled
            along with other fields in its Container.
------------------------------------------------------------------------------*/

  {set EnableField plEnable}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFieldEnabled) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFieldEnabled Procedure 
FUNCTION setFieldEnabled RETURNS LOGICAL
  ( plEnabled AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the FieldEnabled property of the SmartDataField.
   Params:  plEnabled AS LOGICAL
    Notes:  This property is set from user-defined procedures
            enableField and disableField
------------------------------------------------------------------------------*/

  {set FieldEnabled plEnabled}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFieldName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFieldName Procedure 
FUNCTION setFieldName RETURNS LOGICAL
  ( pcField AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the FieldName property of the SmartDataField, 
            identifying the name of the SDO field this maps to.
   Params:  pcField AS CHARACTER
    Notes:  This is run from the containing SmartDataViewer.
------------------------------------------------------------------------------*/

  {set FieldName pcField}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setKeyFieldValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setKeyFieldValue Procedure 
FUNCTION setKeyFieldValue RETURNS LOGICAL
  ( pcValue AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: See DataValue 
    Notes: Kept for backwards compatibility with ICF 0.9  
------------------------------------------------------------------------------*/
  RETURN {set DataValue pcValue}.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLocalField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLocalField Procedure 
FUNCTION setLocalField RETURNS LOGICAL
  ( plLocal AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the LocalField property of the SmartDataField.
   Params:  plLocal AS LOGICAL
    Notes:  This property determines whether the field provides data to
            a local field rather than a data field.
------------------------------------------------------------------------------*/

  &SCOPED-DEFINE xpLocalField
  {set LocalField plLocal}.
  &UNDEFINE xpLocalField
  
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSavedScreenValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSavedScreenValue Procedure 
FUNCTION setSavedScreenValue RETURNS LOGICAL
  ( pcValue AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: See DisplayValue 
    Notes: Kept for backwards compatibility with ICF 0.9  
------------------------------------------------------------------------------*/
  RETURN {set DisplayValue pcValue}.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFrameWidgetID) = 0 &THEN
		
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFrameWidgetID Procedure
FUNCTION getFrameWidgetID RETURNS INTEGER 
	(  ):
/*------------------------------------------------------------------------------
    Purpose:
    Notes:
------------------------------------------------------------------------------*/
DEFINE VARIABLE iFrameWidgetID AS INTEGER    NO-UNDO.
{get FrameWidgetID iFrameWidgetID}.
RETURN iFrameWidgetID.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF
&IF DEFINED(EXCLUDE-setFrameWidgetID) = 0 &THEN
		
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFrameWidgetID Procedure
FUNCTION setFrameWidgetID RETURNS LOGICAL 
	(INPUT piFrameWidgetID AS INTEGER):
/*------------------------------------------------------------------------------
    Purpose: The container use this property to set the widget-id value for the
             SmartDataField frame.
    Notes: This value is required to set the widget-id value for the label.
------------------------------------------------------------------------------*/
{set FrameWidgetID piFrameWidgetID}.
END FUNCTION.
	
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getKeyField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getKeyField Procedure 
FUNCTION getKeyField RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the name of the field name which value is: 
           - received from the SmartDataViewer in setDataValue  
           - retrieved by the SmartDataViewer in getDataValue   
    Notes:   
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cKeyField AS CHARACTER NO-UNDO.
  {get KeyField cKeyField}.
  RETURN cKeyField.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setKeyField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setKeyField Procedure 
FUNCTION setKeyField RETURNS LOGICAL
  ( pcKeyField AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Stores the name of the field to use as the keyfield in the selection
Parameters: INPUT picKeyField - fieldname    
    Notes: - received from the SmartDataViewer in setDataValue  
           - retrieved by the SmartDataViewer in getDataValue   
------------------------------------------------------------------------------*/

  {set KeyField pcKeyField}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF
