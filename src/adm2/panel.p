&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    File        : panel.p
    Purpose     : Super procedure for Panel class
    Syntax      : adm2/panel.p
    Notes       : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Tell the method-library/include (panlprop.i) that this is the Super procedure. */
&SCOP ADMSuper panel.p
   
{src/adm2/custom/panelexclcustom.i}
   
/* This variable is needed at least temporarily in 9.1B so that a called
   fn can tell who the actual source was.  */
DEFINE VARIABLE ghTargetProcedure   AS HANDLE     NO-UNDO.
DEFINE VARIABLE gcLoadedPanels      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE glClassInitialized  AS LOGICAL    NO-UNDO.

/* Used in resizeObject to avoid changing the order of NO-FOCUS buttons. */                        
DEFINE TEMP-TABLE tButton NO-UNDO
  FIELD hdl     AS HANDLE
  FIELD btnY    AS INT
  FIELD btnX    AS INT
  INDEX order btnY btnX.

/* This manages the various dynamic temptables created to store func names and
   values for a linked target 
   NOTE: All of the following code is duplicated in the toolbar super proc toolbar.p */
DEFINE VARIABLE xiMaxLinkChecks AS INTEGER INIT 3  NO-UNDO.

DEFINE TEMP-TABLE ttLinkRuleTable NO-UNDO
  FIELD ProcedureHandle AS HANDLE 
  FIELD LinkName        AS CHAR
  FIELD TableHandle     AS HANDLE
  FIELD BufferHandle    AS HANDLE
  FIELD LinkHandles     AS CHAR 
  FIELD NumErrors       AS INTEGER 
  INDEX Link LinkName ProcedureHandle.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-actionTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionTarget Procedure 
FUNCTION actionTarget RETURNS HANDLE
  ( pcAction AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-errorMessage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD errorMessage Procedure 
FUNCTION errorMessage RETURNS LOGICAL
( pcError AS char)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getButtonCount) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getButtonCount Procedure 
FUNCTION getButtonCount RETURNS INTEGER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMarginPixels) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getMarginPixels Procedure 
FUNCTION getMarginPixels RETURNS INTEGER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPanelFrame) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPanelFrame Procedure 
FUNCTION getPanelFrame RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPanelLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPanelLabel Procedure 
FUNCTION getPanelLabel RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getStaticPrefix) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getStaticPrefix Procedure 
FUNCTION getStaticPrefix RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTableioType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTableioType Procedure 
FUNCTION getTableioType RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTargetProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTargetProcedure Procedure 
FUNCTION getTargetProcedure RETURNS HANDLE
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-sensitizeActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD sensitizeActions Procedure 
FUNCTION sensitizeActions RETURNS LOGICAL
  ( pcActions AS CHAR,
    plSensitive AS LOG)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setEdgePixels) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setEdgePixels Procedure 
FUNCTION setEdgePixels RETURNS LOGICAL
  ( piPixels AS INTEGER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPanelState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPanelState Procedure 
FUNCTION setPanelState RETURNS LOGICAL
  ( pcPanelState AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setStaticPrefix) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setStaticPrefix Procedure 
FUNCTION setStaticPrefix RETURNS LOGICAL
  ( pcStaticPrefix AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-targetActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD targetActions Procedure 
FUNCTION targetActions RETURNS CHARACTER
  ( pcLinkType AS CHAR )  FORWARD.

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
         HEIGHT             = 21.19
         WIDTH              = 57.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/panlprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */ 
&IF DEFINED(EXCLUDE-loadToolbar) = 0 &THEN
		
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadToolbar Procedure
PROCEDURE loadToolbar:
/*------------------------------------------------------------------------------
    Purpose: make panel polymorphistic...  
    Parameters: <none>
    Notes:   This is called from createobjects in toolbar.
------------------------------------------------------------------------------*/
   run loadPanel in target-procedure.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-countButtons) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE countButtons Procedure 
PROCEDURE countButtons :
/*------------------------------------------------------------------------------
  Purpose:   Walk the widget tree of the frame and count all the buttons.  
  Parameters:  <none>
  Notes:     This sets the Panel property ButtonCount.   Used only internally.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hFrame       AS HANDLE  NO-UNDO.
  DEFINE VARIABLE iButtonCount AS INTEGER NO-UNDO.
 
  /* Loop through all the button children and count them. */
  {get PanelFrame hFrame}.
  ASSIGN hFrame  = hFrame:CURRENT-ITERATION
         hFrame  = hFrame:FIRST-CHILD
         iButtonCount = 0.
  DO WHILE VALID-HANDLE (hFrame):
    /* Get all the statically defined buttons in the frame. (We don't want
       the little UIB-generated button in the upper-left corner). */
    IF hFrame:DYNAMIC eq no AND hFrame:TYPE eq "BUTTON":U THEN DO:
       iButtonCount = iButtonCount + 1.
    END.
    /* Get the next child. */
    hFrame = hFrame:NEXT-SIBLING.
  END.
  {set ButtonCount iButtonCount}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-enableObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableObject Procedure 
PROCEDURE enableObject :
/*------------------------------------------------------------------------------
  Purpose:  Reset the panel buttons to the correct state anytime the panel
            is re-enabled.
   Params:  <none>
    Notes:  The "correct" state is the state that the buttons were in
            before the SmartPanel was disabled. This may not be the "initial"
            state. If a SmartPanel has been disabled because the page it is
            on was hidden, its previous state must be restored when the page
            is viewed again.
------------------------------------------------------------------------------*/
  
  DEFINE VARIABLE cState AS CHARACTER NO-UNDO.

  RUN SUPER.      /* Get all objects enabled to start. */
  {get PanelState cState}.
  RUN setButtons IN TARGET-PROCEDURE(cState).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-linkState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkState Procedure 
PROCEDURE linkState :
/*------------------------------------------------------------------------------
  Purpose:     Receives messages when an object linked to this one becomes
               'active' or 'inactive'  
               'activetarget' or 'inactivetarget' is also valid states 
  Parameters:  pcState AS CHARACTER -- 'active*'/'inactive*'
   Notes:      resetTableio and resetNavigation..
               Completely changed for 9.1C, copied from toolbar, but toolbar 
               still overrides because panelType logic is different and
               toolbar can have both nav and tableio source. 
               See Linkstate in data.p also.                
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcState AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE cPanelState             AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cPanelType              AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTargets                AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cLink                   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lDeactivateTargetOnHide AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE iTarget                 AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hTarget                 AS HANDLE    NO-UNDO.
  
  &SCOPED-DEFINE xp-assign
  {get PanelType cPanelType}
  {get DeactivateTargetOnHide lDeactivateTargetOnHide}.
  &UNDEFINE xp-assign

  IF cPanelType BEGINS 'Nav':U THEN
    cLink = 'NavigationTarget':U.
  ELSE IF cPanelType BEGINS 'Save':U OR cPanelType BEGINS 'Update':U THEN
    cLink = 'TableioTarget':U.
  ELSE IF cPanelType BEGINS 'Commit':U THEN
    cLink = 'CommitTarget':U.
  ELSE 
    RETURN.

  cTargets = DYNAMIC-FUNCTION('get':U + cLink IN TARGET-PROCEDURE). 
  
  IF CAN-DO(cTargets,STRING(SOURCE-PROCEDURE)) THEN
  DO:
    IF pcState BEGINS 'active':U 
    AND NOT lDeactivateTargetOnHide 
    AND NUM-ENTRIES(cTargets) > 1  THEN
    DO:
      DO iTarget = 1 TO NUM-ENTRIES(cTargets):
        hTarget = WIDGET-HANDLE(ENTRY(iTarget,cTargets)). 
        IF hTarget <> SOURCE-PROCEDURE THEN
        DO:
          RUN linkStateHandler IN hTarget ('inactive':U,
                                           TARGET-PROCEDURE,
                                           REPLACE(cLink,'Target','Source':U)).
        END.
      END.
    END.

    IF (pcState BEGINS 'active':U OR lDeactivateTargetOnHide) THEN
    DO:  
      RUN linkStateHandler IN SOURCE-PROCEDURE (REPLACE(pcstate,'Target':U,'':U),
                                                TARGET-PROCEDURE,
                                                REPLACE(cLink,'Target','Source':U)).
      CASE cLink: 
        WHEN 'NavigationTarget':U THEN
          RUN resetNavigation IN TARGET-PROCEDURE.
        WHEN 'TableioTarget':U THEN
          RUN resetTableio IN TARGET-PROCEDURE.
        WHEN 'CommitTarget':U THEN
          RUN resetCommit IN TARGET-PROCEDURE.
      END CASE.
    END.
  END.

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadPanel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadPanel Procedure 
PROCEDURE loadPanel :
/*------------------------------------------------------------------------------
  Purpose:  Load all actions from Repository for the panel    
  Parameters:  <none>
  Notes:    The action list is extracted from the EnabledObjFlds (static buttons)
            by removing the StaticPrefix from the button names. 
            The Loaded panel's Logical Object Name is stored in a list to avoid
            loading it again   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cActions       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPrefix        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectName    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lUseRepository AS LOGICAL    NO-UNDO.
 
  {get UseRepository lUseRepository}.
  
  IF NOT lUseRepository THEN 
    RETURN.
  
  {get LogicalObjectName cObjectName}.
  
  IF cObjectName = '':U THEN
    {get ObjectName cObjectName}.

  IF NOT CAN-DO(gcLoadedPanels,cObjectName) THEN
  DO:
    &SCOPED-DEFINE xp-assign
    {get EnabledObjFlds cActions}
    {get StaticPrefix  cPrefix}.
    &UNDEFINE xp-assign

    cActions = TRIM(REPLACE(',':U + cActions,',' + cPrefix,',':U),',':U).
    RUN loadActions IN TARGET-PROCEDURE (cActions). 
    gcLoadedPanels = gcLoadedPanels
                   + (IF gcLoadedPanels <> '':U THEN ',':U ELSE '':U)
                   + cObjectName.
  END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-onChoose) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE onChoose Procedure 
PROCEDURE onChoose :
/*------------------------------------------------------------------------------
  Purpose:  Read action and parameter from Action class (Repository)    
  Parameters:  Action
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER pcAction AS CHARACTER  NO-UNDO.
  
 DEFINE VARIABLE cCall          AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cParam         AS CHARACTER  NO-UNDO.

  cCall  =  {fnarg actionOnChoose pcAction}.
  cParam =  {fnarg actionParameter pcAction}.

  IF cParam = "":U THEN
    PUBLISH cCall FROM TARGET-PROCEDURE.  
  ELSE
    PUBLISH cCall FROM TARGET-PROCEDURE (cParam).  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-queryPosition) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE queryPosition Procedure 
PROCEDURE queryPosition :
/*------------------------------------------------------------------------------
  Purpose:     Captures "state" events for the associated Query in the Panel's
               NavigationTarget. Invokes the setPanelState function which stores
               the new state in the object's PanelState property and then 
               invokes the setButtons procedure to change the Panel.
  Parameters:  pcState AS CHARACTER -- Panel State
    Notes:     See resetTableio and resetNavigation..
               Completely changed for 9.1C, copied from toolbar, but toolbar 
               still overrides because panelType logic is different and
               toolbar can have both nav and tableio source.    
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcState AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE cPanelState    AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE cPanelType     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lDataModified  AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lHidden        AS LOGICAL   NO-UNDO.
  
  /* Ignore events from a hidden Navigation or TableIO-Target */
  {get ObjectHidden lHidden SOURCE-PROCEDURE} NO-ERROR.
  IF lHidden THEN                    
    RETURN.
    
  {get PanelType cPanelType}.
  IF cPanelType BEGINS 'Nav':U THEN
    RUN resetNavigation IN TARGET-PROCEDURE.
  ELSE IF cPanelType BEGINS 'Save':U OR cPanelType BEGINS 'Update':U THEN
    RUN resetTableio IN TARGET-PROCEDURE.

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resetAllTargetActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetAllTargetActions Procedure 
PROCEDURE resetAllTargetActions :
/*------------------------------------------------------------------------------
  Purpose:   Override reset 'all' target actions to reset based on paneltype.    
  Parameters:  <none>
  Notes:     The default method in toolbar.p resets the correct actions based 
             on LinkTargetNames, which is not maintained in the panel (yet..).        
             This override is old logic moved from panel.p initializeObject
             when it was changed to inherit from toolbar.p, which calls this 
             directly from its initializeObject.
  ------------------------------------------------------------------------------*/
  DEFINE VARIABLE cPanelType     AS CHARACTER  NO-UNDO.

  {get PanelType cPanelType}.
  IF cPanelType BEGINS 'Nav':U THEN
    RUN resetNavigation IN TARGET-PROCEDURE.
  ELSE IF cPanelType BEGINS "Save":U OR cPanelType BEGINS "Update":U THEN
    RUN resetTableio IN TARGET-PROCEDURE.
  ELSE IF cPanelType BEGINS "Commit":U THEN
    {set PanelState 'disable-all':U}.

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resetTargetActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetTargetActions Procedure 
PROCEDURE resetTargetActions :
/*------------------------------------------------------------------------------
  Purpose:  reset action sensitivivty and visiblilty    
  Parameters:  <none>
  Notes:    Overrides toolbar.p to use StaticPrefix 
            (also do not need logic for alternate image)   
------------------------------------------------------------------------------*/
 DEFINE INPUT PARAMETER pcLink  AS CHARACTER  NO-UNDO.
 
 DEFINE VARIABLE cEnableActions    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDisableActions   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cHideActions      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cViewActions      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cImage1Actions    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cImage2Actions    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cCheckedActions   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cUncheckedActions AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lInitialized      AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE cLinkActions      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hTarget           AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cLinkName         AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cAction           AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hAction           AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cActionList       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iAction           AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cHandles          AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cPrefix           AS CHARACTER  NO-UNDO.

 {get ObjectInitialized lInitialized}.
 IF NOT lInitialized THEN 
   RETURN.
 
 IF pcLink <> '':U THEN
   hTarget = {fnarg activeTarget pcLink}.
 ELSE 
   {get ContainerSource hTarget}.

 IF NOT VALID-HANDLE(hTarget) THEN
 DO:
   cLinkActions =  {fnarg targetActions pcLink}.
   {fnarg disableActions cLinkActions}.  
   RETURN.
 END.
  
 &SCOPED-DEFINE xp-assign
 {get EnabledObjFlds cActionList}
 {get EnabledObjHdls cHandles}
 {get StaticPrefix  cPrefix}.
 &UNDEFINE xp-assign
 
 DO iAction = 1 TO NUM-ENTRIES(cActionList):
   ASSIGN 
    cAction = REPLACE(ENTRY(iAction,cActionList),cPrefix,'':U)
    hAction = WIDGET-HANDLE(ENTRY(iAction,cHandles)).
   IF VALID-HANDLE(hAction) THEN
   DO:
     ASSIGN
        cEnableActions = cEnableActions 
                       + (IF hAction:SENSITIVE 
                          THEN ',':U + cAction
                          ELSE '':U)
         cDisableActions = cDisableActions 
                         + (IF NOT hAction:SENSITIVE 
                            THEN ',':U + cAction
                            ELSE '':U)
         cViewActions = cViewActions 
                        + (IF NOT hAction:HIDDEN 
                           THEN ',':U + cAction
                           ELSE '':U)
         cHideActions = cHideActions 
                         + (IF hAction:HIDDEN 
                            THEN ',':U + cAction
                            ELSE '':U).
   END.
 END.

 ASSIGN 
   cEnableActions    = TRIM(cEnableActions,',':U)
   cDisableActions   = TRIM(cDisableActions,',':U)
   cViewActions      = TRIM(cViewActions,',':U)
   cHideActions      = TRIM(cHideActions,',':U)
   cImage1Actions    = TRIM(cImage1Actions,',':U)
   cImage2Actions    = TRIM(cImage2Actions,',':U)
   cUncheckedActions = TRIM(cUncheckedActions,',':U)
   cCheckedActions   = TRIM(cCheckedActions,',':U).

 cLinkName = pcLink + '-target':U. 

 RUN ruleStatechanges IN TARGET-PROCEDURE
       (cLinkName,
        hTarget,
        INPUT-OUTPUT cEnableActions,
        INPUT-OUTPUT cDisableActions,
        INPUT-OUTPUT cViewActions,
        INPUT-OUTPUT cHideActions,
        INPUT-OUTPUT cImage1Actions,
        INPUT-OUTPUT cImage2Actions,
        INPUT-OUTPUT cUncheckedActions,
        INPUT-OUTPUT cCheckedActions).
 
 IF cEnableActions <> '':U THEN
   {fnarg EnableActions cEnableActions}.
 
 IF cDisableActions <> '':U THEN
    {fnarg disableActions cDisableActions}.

 IF cViewActions <> '':U OR cHideActions <> '' THEN
   RUN viewHideActions IN TARGET-PROCEDURE (cViewActions,cHideactions).

 RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resizeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject Procedure 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose: Changes the size and shape of the panel.  This routine
           spaces the buttons to fill the available space.  
  Parameters: 
           pd_height AS DECIMAL - the desired height (in rows)
           pd_width  AS DECIMAL - the desired width (in columns)
    Notes: Used internally. Calls to resizeObject are generated by the
           AppBuilder in adm-create-objects for objects which implement it.
           Having a resizeObject procedure is also the signal to the AppBuilder
           to allow the object to be resized at design time.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pd_height AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER pd_width  AS DECIMAL NO-UNDO.
    
  DEFINE VARIABLE hFrame   AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hLabel   AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRect    AS HANDLE  NO-UNDO.
  DEFINE VARIABLE iButtons AS INTEGER NO-UNDO.
  DEFINE VAR btn-height-p  AS INTEGER NO-UNDO.
  DEFINE VAR btn-width-p   AS INTEGER NO-UNDO.  
  DEFINE VAR btn-X         AS INTEGER NO-UNDO.
  DEFINE VAR btn-Y         AS INTEGER NO-UNDO.
  DEFINE VAR h             AS WIDGET  NO-UNDO.
  DEFINE VAR i_margin      AS INTEGER NO-UNDO. /* Margin from frame to buttons */
  DEFINE VAR i_border-h    AS INTEGER NO-UNDO. /* Horizontal frame border      */
  DEFINE VAR i_border-v    AS INTEGER NO-UNDO. /* Vertical frame border        */
  DEFINE VAR i_box-y       AS INTEGER NO-UNDO. /* Start of BOX-RECTANGLE       */
  DEFINE VAR i_lbl-hgt-p   AS INTEGER NO-UNDO. /* Height of (label) Font       */
  DEFINE VAR i_test        AS INTEGER NO-UNDO.    
  DEFINE VAR i_height-p    AS INTEGER NO-UNDO. /* Desired frame height, pixels */
  DEFINE VAR i_width-p     AS INTEGER NO-UNDO. /* Desired frame width, pixels  */
  DEFINE VAR ic            AS INTEGER NO-UNDO.
  DEFINE VAR ir            AS INTEGER NO-UNDO.    
  DEFINE VAR l_hidden      AS LOGICAL NO-UNDO.
  DEFINE VAR l_box-hidden  AS LOGICAL NO-UNDO.
  DEFINE VAR l_selected    AS LOGICAL NO-UNDO.
  DEFINE VAR min-height    AS DECIMAL NO-UNDO. /* Minumum frame height, chars */
  DEFINE VAR min-width     AS DECIMAL NO-UNDO. /* Minumum frame width, chars  */
  DEFINE VAR num-rows      AS INTEGER NO-UNDO.
  DEFINE VAR num-cols      AS INTEGER NO-UNDO.
  DEFINE VAR p-width-p     AS INTEGER NO-UNDO. /* Width of all panel buttons  */
  DEFINE VAR p-height-p    AS INTEGER NO-UNDO. /* Height of all panel buttons */
  
  &SCOPED-DEFINE xp-assign
  {get PanelFrame hFrame}
  {get BoxRectangle hRect}
  {get PanelLabel hLabel}
  {get ButtonCount iButtons}.
  &UNDEFINE xp-assign
 
    /* The margin is based on the standard column width, unless specified
       as an attribute. The margin is 0 for character mode SmartObjects. */
    &IF "{&WINDOW-SYSTEM}" eq "TTY" &THEN
      i_margin = 0.
    &ELSE
      {get MarginPixels i_margin}. /* Some panels set a specific margin.*/
      IF i_margin eq 0 THEN
        i_margin = SESSION:PIXELS-PER-COLUMN.
    &ENDIF
    /* If there is a label, then this will move the top margin. */      
    IF VALID-HANDLE(hLabel) THEN
    DO:
      IF hLabel:SCREEN-VALUE ne "":U THEN 
      DO:
       i_lbl-hgt-p = FONT-TABLE:GET-TEXT-HEIGHT-P (hFrame:FONT).
       IF VALID-HANDLE(hRect) THEN
         i_box-Y = MAX(0, i_lbl-hgt-p - hRect:EDGE-PIXELS) / 2.
       ELSE i_box-Y = i_lbl-hgt-p.       
      END.
    END.
    ELSE ASSIGN i_lbl-hgt-p = 0
                i_box-Y     = 0.
    
    /* How many rows should there be? We assume rows should be about one ROW
       high, though this might be fudged later. */
    IF iButtons = 0 THEN    /* Deal with degenerate case to prevent a loop. */
       ASSIGN num-rows = 1
              num-cols = 1.    
    ELSE DO:
      ASSIGN num-rows = 
               TRUNCATE( pd_height - 2 * (i_margin / SESSION:PIXELS-PER-ROW),0)
             num-rows = MAX (1, MIN (iButtons, num-rows))
             num-cols = iButtons / num-rows.  
      /* Do we have enough rows and columns to hold all the buttons? If not add
         another row or column. (We add the smaller of the two so there will be a minimun
         of wasted spaces.)  */
      DO WHILE num-cols * num-rows < iButtons:
        IF num-cols > num-rows
        THEN num-cols = num-cols + 1.
        ELSE num-rows = num-rows + 1. 
      END. 
    
      /* Check that the last row is not empty. */
      DO WHILE num-cols * (num-rows - 1) >= iButtons:
        num-rows = num-rows - 1.
      END.
    END.  /* End code when iButtons is not 0. */     
    /* Don't allow a size that won't hold the margins, the frame borders, the 
       label and the UIB "affordance" menu (about 16 pixels square, located at 
       (4,4)) [Add in an extra 2 pixels for a fudge factor].
       Note that if we need to increase the size based on a minumum, 
       then we will need to verify that the frame will still fit in its parent.  One final check
       is to guarantee that each row and column is at least one pixel (this is only
       a problem if you have more than about 16 buttons). This minimum only applies
       on MS-Windows, because that is where the object will be used inside the UIB */
     &IF "{&WINDOW-SYSTEM}" eq "TTY" &THEN
       &Scoped-define min-p 0
     &ELSE
       &Scoped-define min-p 22
     &ENDIF
 
      assign
        min-height = (MAX ({&min-p}, 
                             num-rows 
                             + (2 * i_margin) + i_box-Y, i_lbl-hgt-p) / SESSION:PIXELS-PER-ROW) 
                             + (if hFrame:box then hFrame:BORDER-TOP + hFrame:BORDER-BOTTOM else 0)  
        min-width  = (MAX ({&min-p}, 
                             num-cols + 2 * i_margin) 
                             / 
                             SESSION:PIXELS-PER-COLUMN) 
                             + (if hFrame:box then hFrame:BORDER-LEFT + hFrame:BORDER-RIGHT else 0).   
 
    /* Hide the frame to reduce "flashing". Remember if it was already
       hidden, so we don't view it unnecessarily at the end of this
       procedure. (Note: Hiding a SELECTED frame turns off the Selection, 
       so we save the value to use when we make the Frame visible again.) */
    ASSIGN l_selected = hFrame:SELECTED 
           l_hidden   = hFrame:HIDDEN 
           hFrame:HIDDEN = yes
           NO-ERROR.
           
    /* Do we need to adjust the size (and position). */
    IF min-height > pd_height OR min-width > pd_width THEN 
    DO:
      /* Get the parent to insure that the frame will still fit inside it. */ 
      h = hFrame:PARENT.
      IF h:TYPE ne "WINDOW":U THEN h = hFrame:FRAME.
      /* Test width. */  
      IF min-width > pd_width THEN 
      DO:
        ASSIGN pd_width  = min-width
               i_width-p = 1 + (pd_width * SESSION:PIXELS-PER-COLUMN)
               i_test    = IF h:TYPE eq "WINDOW":U OR h:SCROLLABLE
                           THEN h:VIRTUAL-WIDTH-P
                           ELSE h:WIDTH-P - h:BORDER-LEFT-P - h:BORDER-RIGHT-P.
        IF i_test < hFrame:X + i_width-p THEN 
          ASSIGN hFrame:X = MAX(0, i_test - i_width-p) NO-ERROR.
      END.
      /* Test height. */
      IF min-height > pd_height THEN 
      DO:
        ASSIGN pd_height  = min-height 
               i_height-p = 1 + (pd_height * SESSION:PIXELS-PER-ROW)
               i_test     = IF h:TYPE eq "WINDOW":U OR h:SCROLLABLE
                            THEN h:VIRTUAL-HEIGHT-P
                            ELSE h:HEIGHT-P - h:BORDER-TOP-P - h:BORDER-BOTTOM-P.
        IF i_test < hFrame:Y + i_height-p THEN 
          ASSIGN hFrame:Y = MAX(0, i_test - i_height-p) NO-ERROR.
      END.
    END.
    /* Resize the frame and determine values based on the desired size. */
    ASSIGN 
        hFrame:SCROLLABLE = yes
        hFrame:WIDTH      = pd_width
        hFrame:HEIGHT     = pd_height
        /* Convert from Decimal width and height be reading from the 
           FRAME itself. */
        i_width-p    = pd_width * session:pixels-per-column /*hFrame:WIDTH-P*/
        i_height-p   = pd_height * session:pixels-per-row /*hFrame:HEIGHT-P*/
        .
    
    if hFrame:box then 
      assign
        /* Save the calculation of frame borders. */
        i_border-v   = hFrame:BORDER-TOP-P +
                       hFrame:BORDER-BOTTOM-P
        i_border-h   = hFrame:BORDER-LEFT-P +
                       hFrame:BORDER-RIGHT-P
       .
     assign
        /* Compute the total width/height of the buttons in the panel. 
           That is, subtract all the margins, decoration, and borders 
           from the frame size. */
        p-width-p    = i_width-p - i_border-h - (2 * i_margin)
        p-height-p   = i_height-p - i_border-v - i_box-Y - (2 * i_margin).
   
    /* Loop through all the button children and move them. */
    ASSIGN h     = hFrame:CURRENT-ITERATION
           h     = h:FIRST-CHILD
           ic    = 0
           ir    = 1
           btn-X = i_margin 
           btn-Y = i_margin + i_box-Y
           btn-height-p = p-height-p / num-rows
           .

    /* NO-FOCUS buttons appear in the widget tree in the order they were 
       realized. We cannot reposition the buttons in this order instead 
       we walk the widget tree and populate a temp-table that are indexed
       on the buttons Y and X and uses the temp-table to ensure correct 
       order when the buttons are repositioned */

    EMPTY TEMP-TABLE tButton NO-ERROR.
    
    DO WHILE VALID-HANDLE (h):
      IF h:HIDDEN = FALSE AND h:DYNAMIC eq no AND h:TYPE eq "BUTTON":U THEN DO:
         CREATE tButton.
         ASSIGN 
            tButton.hdl  = h
            tButton.btnY = h:Y
            tButton.btnX = h:X.
      END.
      /* Get the next child. */
      h = h:NEXT-SIBLING.
    END. /* do while valid-handle*/
    
    /* Now loop through the buttons in the Y X order (default index) */
    FOR EACH tButton:
      /* Get all the statically defined buttons in the frame. (We don't want
         the little UIB-generated button in the upper-left corner). */
      h = tButton.hdl.
          /* We compute the button width and height for every row and column 
           independently. This is because we want the total size of the buttons
           to be the desired size. But each button must be an integer number of
           pixels. The round-off error can accumulate for a large panel.
           (e.g. 7 buttons in 40 pixels would mean either buttons 5 or 6 pixels
           wide. Unless we mix the sizing, then there will be only 35 pixels
           total (35 = 7 * 5). The algorithm below will have 5 buttons 6 pixels
           high and two buttons only 5 pixels high. */
      ASSIGN ic = ic + 1.
      IF ic > num-cols THEN
         ASSIGN 
               ic    = 1
               ir    = ir + 1
               btn-X = i_margin
               btn-Y = (p-height-p * (ir - 1) / num-rows) + i_margin + i_box-Y
               btn-height-p = (p-height-p * ir / num-rows) + i_margin + i_box-Y -
                               btn-Y.
        /* Hide the button before resizing (in case we are setting the width
           and height to be larger than the frame will accomodate). */
      ASSIGN h:HIDDEN   = yes 
             h:WIDTH-P  = ((p-width-p * ic / num-cols) + i_margin) - btn-X
             h:HEIGHT-P = btn-height-p
             h:X        = btn-X
             h:Y        = btn-Y
             btn-X      = h:X + h:WIDTH-P
             h:HIDDEN   = NO
             NO-ERROR.
    END. /* for each tButton */
    
    /* If defined, set the Bounding Rectangle size. */
    IF VALID-HANDLE(hRect) THEN
      ASSIGN l_box-hidden   = hRect:HIDDEN
             hRect:HIDDEN   = yes
             hRect:X        = 0
             hRect:Y        = i_box-Y
             hRect:WIDTH-P  = i_width-p - i_border-h
             hRect:HEIGHT-P = i_height-p - i_border-v - i_box-Y
             hRect:HIDDEN   = l_box-hidden             
            NO-ERROR.

    /* If defined, set the LABEL width. */
    IF VALID-HANDLE(hLabel) THEN
      ASSIGN hLabel:HIDDEN   = yes
             hLabel:X        = i_margin
             hLabel:Y        = 0 
             hLabel:WIDTH-P  = MIN(FONT-TABLE:GET-TEXT-WIDTH-P 
                                     (hLabel:SCREEN-VALUE, hFrame:FONT),
                                    i_width-p - hLabel:X - i_border-h) 
             hLabel:HEIGHT-P = MIN(i_lbl-hgt-p, i_height-p - i_border-v)
             hLabel:HIDDEN   = (hLabel:SCREEN-VALUE eq "":U)                                
            NO-ERROR.


    /* Show the frame. Turn off SCROLLABLE to force virtual size to match
       viewport size.  We will turn SCROLLABLE back on so that the SmartPanel
       can be resized smaller. */
    ASSIGN hFrame:SCROLLABLE       = NO
           hFrame:WIDTH-P          = i_width-p
           hFrame:HEIGHT-P         = i_height-p
           NO-ERROR .  
    /* Frame must be SCROLLABLE if it is to be resized smaller than its
       contained buttons and rectangles. */    
    ASSIGN hFrame:SCROLLABLE = YES.
    /* View, and select, the frame, if necessary. */
    IF NOT l_hidden THEN hFrame:HIDDEN   = no NO-ERROR.
    IF l_selected   THEN hFrame:SELECTED = yes.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateState Procedure 
PROCEDURE updateState :
/*------------------------------------------------------------------------------
  Purpose:     Receives state message events related to record updates.
  Parameters:  pcState AS CHARACTER -- upstate state, can be 'Update' or
               'UpdateComplete'
    Notes:     See resetTableio and resetNavigation..
               Completely changed for 9.1C, copied from toolbar, but overides
               toolbar because panelType logic is different
              (toolbar can have both nav and tableio source).
-----------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcState AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE cPanelType     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cPanelState    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hNavTarget     AS HANDLE    NO-UNDO.

  {get PanelType cPanelType}.
  IF cPanelType BEGINS 'Save':U OR cPanelType BEGINS 'Update':U THEN
    RUN resetTableio IN TARGET-PROCEDURE.   
  ELSE IF cPanelType BEGINS 'Nav':U THEN  
    RUN resetNavigation IN TARGET-PROCEDURE.  
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-viewHideActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE viewHideActions Procedure 
PROCEDURE viewHideActions :
/*------------------------------------------------------------------------------
  Purpose: Views and hides static actions              
    Notes: Overrides the dynamic version in toolbar.p  
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcViewActions AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER pcHideActions AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE iAction      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLookup      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hAction      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cAction      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cActions     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPrefix      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cHandles     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lResize      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iButtonCount AS INTEGER    NO-UNDO.
  
  DEFINE VARIABLE hFrame       AS HANDLE     NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get EnabledObjFlds cActions}
  {get EnabledObjHdls cHandles} 
  {get StaticPrefix  cPrefix}
  {get ButtonCount iButtonCount}.
  &UNDEFINE xp-assign

  DO iAction = 1 TO NUM-ENTRIES(cActions):
    ASSIGN 
      hAction = WIDGET-HANDLE(ENTRY(iAction,cHandles))
      cAction = ENTRY(iAction,cActions)
      cAction = REPLACE(' ':U + cAction,' ' + cPrefix,'':U).
    IF CAN-DO(pcViewActions,cAction) AND hAction:HIDDEN = TRUE THEN
      ASSIGN
         hAction:HIDDEN = FALSE
         iButtonCount = iButtonCount + 1
         lResize      = TRUE.    
    IF CAN-DO(pcHideActions,cAction) AND hAction:HIDDEN = FALSE THEN
      ASSIGN 
        hAction:HIDDEN = TRUE
        iButtonCount   = iButtonCount - 1
        lResize        = TRUE.    
  END.
  {set ButtonCount iButtonCount}.
  
  IF lResize THEN
  DO:
    {get ContainerHandle hframe}.
    RUN resizeObject IN TARGET-PROCEDURE (hFrame:HEIGHT, hFrame:WIDTH). 
  END.

  RETURN.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-actionTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionTarget Procedure 
FUNCTION actionTarget RETURNS HANDLE
  ( pcAction AS CHAR ) :
/*------------------------------------------------------------------------------
 Purpose:  Returns the handle of the target based on PanelType.
           Used by actions of Type RUN or PROPERTY. 
Parameter: pcAction - Action id     
    Notes: Overrides toolbar, which uses the action link.
           Meaning: This override can be removed as the panel are using actions
                    with link info.  (but if it ain't broken.... )
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cPanelType AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hObject        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cLink          AS CHARACTER  NO-UNDO.
  
  {get PanelType cPanelType}.

  IF cPanelType BEGINS 'Nav':U THEN
    cLink = 'Navigation':U.
  ELSE IF cPanelType BEGINS 'Save':U OR cPanelType BEGINS 'Update':U THEN
    cLink = 'Tableio':U.
  ELSE IF cPanelType BEGINS 'Commit':U THEN
    cLink = 'Commit':U.
  
  IF cLink <> "":U THEN
    hObject = {fnarg activeTarget cLink}.
  
  RETURN hObject.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-errorMessage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION errorMessage Procedure 
FUNCTION errorMessage RETURNS LOGICAL
( pcError AS char) :
/*------------------------------------------------------------------------------
  Purpose: Display an error message 
    Notes: The object is generally forgiving, but some errors are captured. 
------------------------------------------------------------------------------*/
  
  MESSAGE {fnarg messageNumber 36} SKIP
           pcError
  VIEW-AS ALERT-BOX WARNING.
  RETURN FALSE.   /* Function return value. */


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getButtonCount) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getButtonCount Procedure 
FUNCTION getButtonCount RETURNS INTEGER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the number of buttons in a SmartPanel, for resizeObject
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iCount AS INTEGER NO-UNDO.
  {get ButtonCount iCount}.
  RETURN iCount.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMarginPixels) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getMarginPixels Procedure 
FUNCTION getMarginPixels RETURNS INTEGER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the number of pixels to reserve for the Panel margin --
            used by resizeObject.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iPixels AS INTEGER NO-UNDO.
  {get MarginPixels iPixels}.
  RETURN iPixels.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPanelFrame) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPanelFrame Procedure 
FUNCTION getPanelFrame RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the Frame handle of the SmartPanel, for resizeObject
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hFrame AS HANDLE NO-UNDO.
  {get PanelFrame hFrame}.
  RETURN hFrame.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPanelLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPanelLabel Procedure 
FUNCTION getPanelLabel RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle of the Panel's Label, if any 
   Params:  <none>
    Notes:  used by resizeObject.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hLabel AS HANDLE NO-UNDO.
  {get PanelLabel hLabel}.
  RETURN hLabel.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getStaticPrefix) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getStaticPrefix Procedure 
FUNCTION getStaticPrefix RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the prefix used before the action name in static definitions
    Notes: This allows static panels to use action/repository data. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cStaticPrefix AS CHARACTER  NO-UNDO.
  {get StaticPrefix cStaticPrefix}.

  RETURN cStaticPrefix.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTableioType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTableioType Procedure 
FUNCTION getTableioType RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Return PanelType for tableio, so that resetTableio can handle panel 
           similar to toolbar.      
  Parameters:  
    Notes:       
------------------------------------------------------------------------------*/
   DEFINE VARIABLE cPanelType AS CHARACTER  NO-UNDO.
   
   {get PanelType cPanelType}.
   IF cPanelType BEGINS 'Save':U OR cPanelType BEGINS 'Update':U THEN
     RETURN cPanelType.
   ELSE 
     RETURN '':U.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTargetProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTargetProcedure Procedure 
FUNCTION getTargetProcedure RETURNS HANDLE
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Temporary fn to return the source-procedure's target-procedure
            to a function such as colValues in an SBO who needs to know who
            the *real* caller object is.
    Notes:  
------------------------------------------------------------------------------*/

  RETURN ghTargetProcedure.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-sensitizeActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION sensitizeActions Procedure 
FUNCTION sensitizeActions RETURNS LOGICAL
  ( pcActions AS CHAR,
    plSensitive AS LOG) :
/*------------------------------------------------------------------------------
  Purpose:  Set a lits of actions sensitive true or false. 
    Notes:  Static override that finds action handles by looking up each entry 
            in EnabledObjFlds by prepending the StaticPrefix to the Action.   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iAction AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLookup AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hAction AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cAction AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cActions AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPrefix AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cHandles AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisabledActions AS CHARACTER NO-UNDO.
  
  &SCOPED-DEFINE xp-assign
  {get DisabledActions cDisabledActions}
  {get EnabledObjFlds cActions}
  {get EnabledObjHdls cHandles}
  {get StaticPrefix  cPrefix}.
  &UNDEFINE xp-assign

  DO iAction = 1 TO NUM-ENTRIES(pcActions):
    ASSIGN 
      cAction = ENTRY(iAction,pcActions)
      iLookup = LOOKUP(cPrefix + cAction,cActions).
    IF iLookup > 0  THEN
    DO:
      /* if not in disabled list */
      IF LOOKUP(cAction, cDisabledActions) = 0 THEN 
        ASSIGN 
          hAction = WIDGET-HANDLE(ENTRY(iLookup,cHandles))
          hAction:SENSITIVE = plSensitive.
    END.
  END.
  
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setEdgePixels) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setEdgePixels Procedure 
FUNCTION setEdgePixels RETURNS LOGICAL
  ( piPixels AS INTEGER) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the number of edge-pixels in the enclosing rectangle 
  Params:  piPixels AS INTEGER
           (xp because panel has override) 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRect   AS HANDLE  NO-UNDO.
  DEFINE VARIABLE iPixels AS INTEGER NO-UNDO.
  
  {get BoxRectangle hRect}.
  IF VALID-HANDLE(hRect) THEN
  DO:
    &IF "{&WINDOW-SYSTEM}":U = "TTY":U &THEN 
       iPixels = 0.     /* No border rectangle for TTY. */
    &ELSE
       iPixels = piPixels.
    &ENDIF    
    IF piPixels NE hRect:EDGE-PIXELS THEN
      hRect:EDGE-PIXELS = iPixels.
  END.
  ELSE 
    iPixels = piPixels.
  
  RETURN SUPER(iPixels).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPanelState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setPanelState Procedure 
FUNCTION setPanelState RETURNS LOGICAL
  ( pcPanelState AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  DEPRECATED - Set the state of the Panel's buttons.
   Params:  pcPanelState AS CHARACTER
    Notes:  Also runs the procedure setButtons, which changes which 
            buttons are enabled and disabled based on the state.
         -  DEPRECATED in the sense that the toolbar disabling/enabling 
            has been replaced by rule based state management. The function 
            is still callable and may still be called in odd cases.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cPanelType AS CHARACTER  NO-UNDO.
  
  {get PanelType cPanelType}.
  
  /* Deal with backwards compatibility for navigation panels */
  IF cPaneltype BEGINS 'nav':U THEN
  DO:
    IF pcPanelState = 'disable-nav':U THEN pcPanelState = 'disable-all':U.
    IF pcPanelState = 'enable-nav':U  THEN pcPanelState = 'enable-all':U.
  END.

  /* Deal with backwards compatibility for update panels */
  IF cPaneltype BEGINS 'save':U OR cPanelType BEGINS 'Update':U THEN
  DO:
    IF pcPanelState = 'initial-tableio':U THEN pcPanelState = 'initial':U.
    IF pcPanelState = 'disable-tableio':U THEN pcPanelState = 'disable-all'.
  END.
  
  RETURN SUPER(pcPanelState).

 END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setStaticPrefix) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setStaticPrefix Procedure 
FUNCTION setStaticPrefix RETURNS LOGICAL
  ( pcStaticPrefix AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Set the prefix used before the action name in static definitions.
Parameter: Prefix -   
    Notes: This allows static panels to use action/repository data. 
------------------------------------------------------------------------------*/
  {set StaticPrefix pcStaticPrefix}.

  RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-targetActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION targetActions Procedure 
FUNCTION targetActions RETURNS CHARACTER
  ( pcLinkType AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Return the actions for a target specified by link type 
parameter: Linktype     
    Notes: This is the static version used for static buttons in panels. 
           Overidden in toolbar  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cActions AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPrefix  AS CHARACTER  NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get EnabledObjFlds cActions}
  {get StaticPrefix  cPrefix}.
  &UNDEFINE xp-assign
  cActions = TRIM(REPLACE(",":U + cActions,",":U + cPrefix,",":U),',':U).  
  
  RETURN cActions.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

