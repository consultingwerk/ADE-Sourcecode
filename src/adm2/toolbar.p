&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    File        : toolbar.p
    Purpose     : Super procedure for toolbar class.

    Syntax      : RUN start-super-proc("adm2/toolbar.p":U).

    Modified    : 1/12/2000
    Modified    : 03/25/2002      Mark Davies (MIP)
                  Added getMinHeight override procedure.
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
&SCOP ADMSuper toolbar.p
&SCOP adm-panel-type toolbar
 
 /* Support customization of action class, which no longer exists  */
{src/adm2/custom/actionexclcustom.i}
  
 /* Custom exclude file */
{src/adm2/custom/toolbarexclcustom.i}

/**** action definitions ****/
{src/adm2/ttaction.i}
  
/* delimiter used between action names in unique menukey  */                              
&SCOPED-DEFINE pathdlm CHR(1) 

/* menu widget-pool prefix (menus need to survive their constructor) */
&SCOPED-DEFINE menuwidgetpool  'menubar-':U

/* This variable is needed at least temporarily in 9.1B so that a called
   fn can tell who the actual source was.  */
DEFINE VARIABLE ghTargetProcedure AS HANDLE     NO-UNDO.

DEFINE VARIABLE glInitialized AS LOG    NO-UNDO.
  
/* Used in resizeObject to determine when initialization is complete */
DEFINE VARIABLE glInitComplete    AS LOGICAL    NO-UNDO.
/* Used to store the image directory */
DEFINE VARIABLE gcImageDirectory AS CHAR        NO-UNDO.

DEFINE VARIABLE xcNoCategory      AS CHARACTER  NO-UNDO  INIT '<none>':U.
DEFINE VARIABLE xcWindowBand      AS CHARACTER  NO-UNDO  INIT 'Window':U.

/* We define a dynamic table and buffer to store all functions that are basis of a 
   rule, in the case where some of the fields are not found we try again each time 
   the link changes, but we do not want to go on and do this forever, so we have a 
   predefined limit of attempted tries (2 may be sufficient..  )*/      
DEFINE VARIABLE xiMaxLinkChecks AS INTEGER INIT 3  NO-UNDO.

/* This manages the various dynamic temptables created to store func names and
   values for a linked target */
DEFINE TEMP-TABLE ttLinkRuleTable NO-UNDO
  FIELD ProcedureHandle AS HANDLE 
  FIELD LinkName        AS CHAR
  FIELD TableHandle     AS HANDLE
  FIELD BufferHandle    AS HANDLE
  FIELD LinkHandles     AS CHAR 
  FIELD NumErrors       AS INTEGER 
  INDEX Link LinkName ProcedureHandle.

/* For performance purposes, we do the find directly in action.
   pcAction is a mandatory variable name for the action
   &scop-define targetproc must define a handle if used where target-procedure 
   cannot be used. Note that this is undefined as soon as it is used */  
&SCOPED-DEFINE findAction ~
IF (AVAIL ttAction AND ttAction.Action <> pcAction) OR NOT AVAIL ttAction THEN DO: ~
FIND FIRST ttAction WHERE ttAction.Action = pcAction ~
AND ttAction.ProcedureHandle  = THIS-PROCEDURE NO-ERROR. ~
IF NOT AVAILABLE ttAction THEN ~
 FIND ttAction WHERE ttAction.Action = pcAction~
               AND   ttAction.ProcedureHandle =~
 &IF DEFINED(targetproc) <> 0 &THEN~
    ~{&targetproc~}~
    &UNDEFINE targetproc~
 &ELSE~
    TARGET-PROCEDURE~
  &ENDIF~
 NO-ERROR. ~
END.

{src/adm2/tttoolbar.i}

/* The main purpose of this TT is to link Repository Bands to physical bands
   Repository bands are unique, but 'File-x' and 'File-z' may both really be 
   File at runtime. There is some redundancy as most of the info also is in 
   tMenu, but the Band is not.   */ 
DEFINE TEMP-TABLE tBandInstance NO-UNDO
 FIELD hTarget     AS HANDLE
 FIELD Band        AS CHAR  /* repository key. API key. */
 /* logical key and also join to the tMenu.name. many instances can have the 
    same name i.e be in the same band */ 
 FIELD MenuName    AS CHAR   
 /* Unique within a menubar join to tMenu children with parentmenukey  */
 FIELD LastSeq     AS INT
 FIELD MenuKey     AS CHAR 
 FIELD Hdl         AS HANDLE
 FIELD RefreshBand AS LOG 
 FIELD MenuBarHdl  AS HANDLE /* currently only set for objectbands */
 FIELD ObjectName  AS CHAR  /* object of objectband */
 
 /* Used to identify bands whose items is added directly on the placeholder's 
    position (InsertSubMenu = FALSE) */
 FIELD PlaceHolder    AS CHAR 
 /* Used to sort items added directly on the placeholder's position */
 FIELD PlaceholderSeq AS INT 
INDEX Hdl Hdl hTarget
INDEX hTarget hTarget Band
INDEX menubarhdl MenuBarHdl ObjectName Band 
INDEX menuname  MenuName hTarget
INDEX menukey   MenuKey  hTarget
INDEX placeholder hTarget PlaceHolder PlaceholderSeq.

DEFINE TEMP-TABLE tMenu NO-UNDO
 FIELD hTarget       AS HANDLE
 FIELD Name          AS CHARACTER
 FIELD MergeOrder    AS INTEGER
 FIELD Caption       AS CHARACTER
 FIELD Link          AS CHARACTER 
 FIELD HasLink       AS LOGICAL  
 FIELD Hdl           AS HANDLE 
 FIELD ChildLinks    AS CHARACTER
 FIELD ChildLabels   AS CHARACTER
 FIELD SubHdls       AS CHARACTER
 FIELD MenuBarHdl    AS HANDLE
 FIELD PageNo        AS INTEGER  
 FIELD Parent        AS CHARACTER
 FIELD ParentMenuKey AS CHARACTER
 FIELD Seq           AS INTEGER 
 FIELD Refresh       AS LOGICAL 
 FIELD Sensitive     AS LOGICAL 
 FIELD Disabled      AS LOGICAL  
 FIELD CaptionSubst AS LOGICAL    

INDEX Name    Name hTarget Parent Seq
INDEX Link    hTarget Link Seq
INDEX Disabled hTarget Disabled
INDEX Hdl     Hdl hTarget
INDEX BandSort  MenuBarHdl ParentMenuKey MergeOrder PageNo hTarget Seq
INDEX MenuSiblingKey MenuBarHdl ParentMenuKey NAME 
INDEX Parent  AS PRIMARY hTarget Parent Seq.

DEFINE TEMP-TABLE tButton NO-UNDO
 FIELD hTarget      AS HANDLE
 FIELD Name         AS CHAR
 FIELD Band         AS CHAR
 FIELD Link         AS CHAR
 FIELD ImageAlt     AS LOG INIT ?
 FIELD Position     AS INT    /* initial position, used for sorting */  
 FIELD Hdl          AS HANDLE
 FIELD Disabled     AS LOG
 FIELD Sensitive    AS LOG 
 FIELD LabelSubst   AS LOG
 FIELD TooltipSubst AS LOG
INDEX Target AS PRIMARY hTarget Position
INDEX Band   Band hTarget Position
INDEX Link   hTarget Link Position
INDEX Name   Name Band hTarget.

DEFINE TEMP-TABLE ttSubMergeTarget
  FIELD BandROWID    AS ROWID
  FIELD hTarget      AS HANDLE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-actionAccelerator) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionAccelerator Procedure 
FUNCTION actionAccelerator RETURNS CHARACTER
  (pcAction AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionAccessType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionAccessType Procedure 
FUNCTION actionAccessType RETURNS CHARACTER
 (pcAction AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionCanLaunch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionCanLaunch Procedure 
FUNCTION actionCanLaunch RETURNS LOGICAL
  ( pcAction AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionCanRun) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionCanRun Procedure 
FUNCTION actionCanRun RETURNS LOGICAL
  (pcAction AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionCaption) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionCaption Procedure 
FUNCTION actionCaption RETURNS CHARACTER
  ( pcAction AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionCategory) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionCategory Procedure 
FUNCTION actionCategory RETURNS CHARACTER
  (pcAction AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionCategoryIsHidden) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionCategoryIsHidden Procedure 
FUNCTION actionCategoryIsHidden RETURNS LOGICAL
  (pcAction AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionChecked) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionChecked Procedure 
FUNCTION actionChecked RETURNS LOGICAL
  (pcAction AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionChildren) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionChildren Procedure 
FUNCTION actionChildren RETURNS CHARACTER
 (pcAction AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionControlType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionControlType Procedure 
FUNCTION actionControlType RETURNS CHARACTER
  (pcAction AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionCreateEvent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionCreateEvent Procedure 
FUNCTION actionCreateEvent RETURNS CHARACTER
  (pcAction AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionDescription) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionDescription Procedure 
FUNCTION actionDescription RETURNS CHARACTER
  (pcAction AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionDisabled) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionDisabled Procedure 
FUNCTION actionDisabled RETURNS LOGICAL
  (pcAction AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionEnableRule) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionEnableRule Procedure 
FUNCTION actionEnableRule RETURNS CHARACTER
  (pcAction AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionGroups) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionGroups Procedure 
FUNCTION actionGroups RETURNS CHARACTER
    ()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionHideRule) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionHideRule Procedure 
FUNCTION actionHideRule RETURNS CHARACTER
  (pcAction AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionImage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionImage Procedure 
FUNCTION actionImage RETURNS CHARACTER
  (pcAction AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionImageAlternate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionImageAlternate Procedure 
FUNCTION actionImageAlternate RETURNS CHARACTER
  (pcAction AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionImageAlternateRule) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionImageAlternateRule Procedure 
FUNCTION actionImageAlternateRule RETURNS CHARACTER
  (pcAction AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionInitCode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionInitCode Procedure 
FUNCTION actionInitCode RETURNS CHARACTER
  (pcAction AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionIsMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionIsMenu Procedure 
FUNCTION actionIsMenu RETURNS LOGICAL
 (pcAction AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionIsParent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionIsParent Procedure 
FUNCTION actionIsParent RETURNS LOGICAL
  (pcAction AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionLabel Procedure 
FUNCTION actionLabel RETURNS CHARACTER
  ( pcAction AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionLink) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionLink Procedure 
FUNCTION actionLink RETURNS CHARACTER
  (pcAction AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionLogicalObjectName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionLogicalObjectName Procedure 
FUNCTION actionLogicalObjectName RETURNS CHARACTER
  (pcAction AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionName Procedure 
FUNCTION actionName RETURNS CHARACTER
  (pcAction AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionOnChoose) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionOnChoose Procedure 
FUNCTION actionOnChoose RETURNS CHARACTER
  (pcAction AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionParameter) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionParameter Procedure 
FUNCTION actionParameter RETURNS CHARACTER
  (pcAction AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionParent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionParent Procedure 
FUNCTION actionParent RETURNS CHARACTER
  (pcAction AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionPhysicalObjectName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionPhysicalObjectName Procedure 
FUNCTION actionPhysicalObjectName RETURNS CHARACTER
  (pcAction AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionPublishCreate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionPublishCreate Procedure 
FUNCTION actionPublishCreate RETURNS LOGICAL
  ( pcAction AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionRefresh) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionRefresh Procedure 
FUNCTION actionRefresh RETURNS LOGICAL
  (pcAction AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionRunAttribute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionRunAttribute Procedure 
FUNCTION actionRunAttribute RETURNS CHARACTER
  (pcAction AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionSecondImage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionSecondImage Procedure 
FUNCTION actionSecondImage RETURNS CHARACTER
  (pcAction AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionSecuredToken) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionSecuredToken Procedure 
FUNCTION actionSecuredToken RETURNS CHARACTER
  (pcAction AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionSubstituteProperty) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionSubstituteProperty Procedure 
FUNCTION actionSubstituteProperty RETURNS CHARACTER
  (pcAction AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionTarget Procedure 
FUNCTION actionTarget RETURNS HANDLE
  (pcAction AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionTooltip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionTooltip Procedure 
FUNCTION actionTooltip RETURNS CHARACTER
  ( pcAction AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionType Procedure 
FUNCTION actionType RETURNS CHARACTER
  (pcAction AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-activeTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD activeTarget Procedure 
FUNCTION activeTarget RETURNS HANDLE
  ( pcLink AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adjustActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD adjustActions Procedure 
FUNCTION adjustActions RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignActionAccelerator) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignActionAccelerator Procedure 
FUNCTION assignActionAccelerator RETURNS LOGICAL
  (pcId AS CHAR,
   pcValue AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignActionAccessType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignActionAccessType Procedure 
FUNCTION assignActionAccessType RETURNS LOGICAL
  (pcId     AS CHAR,
   pcValue  AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignActionCaption) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignActionCaption Procedure 
FUNCTION assignActionCaption RETURNS LOGICAL
  (pcId     AS CHAR,
   pcValue  AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignActionDescription) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignActionDescription Procedure 
FUNCTION assignActionDescription RETURNS LOGICAL
  (pcId     AS CHAR,
   pcValue  AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignActionEnableRule) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignActionEnableRule Procedure 
FUNCTION assignActionEnableRule RETURNS LOGICAL
  (pcId AS CHAR,
   pcValue AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignActionHideRule) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignActionHideRule Procedure 
FUNCTION assignActionHideRule RETURNS LOGICAL
  (pcId AS CHAR,
   pcValue AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignActionImage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignActionImage Procedure 
FUNCTION assignActionImage RETURNS LOGICAL
  (pcId     AS CHAR,
   pcValue  AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignActionImageAlternateRule) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignActionImageAlternateRule Procedure 
FUNCTION assignActionImageAlternateRule RETURNS LOGICAL
  (pcId AS CHAR,
   pcValue AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignActionLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignActionLabel Procedure 
FUNCTION assignActionLabel RETURNS LOGICAL
  (pcId     AS CHAR,
   pcValue  AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignActionName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignActionName Procedure 
FUNCTION assignActionName RETURNS LOGICAL
  (pcId     AS CHAR,
   pcValue  AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignActionOrder) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignActionOrder Procedure 
FUNCTION assignActionOrder RETURNS LOGICAL
  (pcId     AS CHAR,
   piValue  AS INT)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignActionParent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignActionParent Procedure 
FUNCTION assignActionParent RETURNS LOGICAL
  (pcId     AS CHAR,
   pcValue  AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignActionRefresh) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignActionRefresh Procedure 
FUNCTION assignActionRefresh RETURNS LOGICAL
 (pcId     AS CHAR,
  plValue  AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignActionSecondImage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignActionSecondImage Procedure 
FUNCTION assignActionSecondImage RETURNS LOGICAL
  (pcId     AS CHAR,
   pcValue  AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignActionTooltip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignActionTooltip Procedure 
FUNCTION assignActionTooltip RETURNS LOGICAL
  (pcId     AS CHAR,
   pcValue  AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumn) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignColumn Procedure 
FUNCTION assignColumn RETURNS LOGICAL PRIVATE
  (pcObject AS CHAR,
   pcId     AS CHAR,
   pcColumn AS CHAR,
   pcValue  AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-bandActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD bandActions Procedure 
FUNCTION bandActions RETURNS CHARACTER
  ( pcParentBand AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-bandSubmenuLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD bandSubmenuLabel Procedure 
FUNCTION bandSubmenuLabel RETURNS CHARACTER
  ( pcBand      AS CHARACTER,
    pcChildBand AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-bandSubmenus) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD bandSubmenus Procedure 
FUNCTION bandSubmenus RETURNS CHARACTER
  ( pcParentBand AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-bufferHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD bufferHandle Procedure 
FUNCTION bufferHandle RETURNS HANDLE
  (pcObject AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD buildMenu Procedure 
FUNCTION buildMenu RETURNS LOGICAL
  (pcParent AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildMenuBand) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD buildMenuBand Procedure 
FUNCTION buildMenuBand RETURNS LOGICAL
  ( phParent  AS HANDLE, 
    pcMenuKey AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-canFindAction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD canFindAction Procedure 
FUNCTION canFindAction RETURNS LOGICAL
  (pcAction AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-canFindCategory) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD canFindCategory Procedure 
FUNCTION canFindCategory RETURNS LOGICAL
  (pcCategory AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-categoryActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD categoryActions Procedure 
FUNCTION categoryActions RETURNS CHARACTER
  ( pcCategory AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-categoryLink) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD categoryLink Procedure 
FUNCTION categoryLink RETURNS CHARACTER
  (pcCategory AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-checkRule) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD checkRule Procedure 
FUNCTION checkRule RETURNS LOGICAL
     ( pcRule    AS CHAR,
       phHandle  AS HANDLE,
       plDefault AS LOG)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-constructMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD constructMenu Procedure 
FUNCTION constructMenu RETURNS LOGICAL
    ( ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-constructMenuBand) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD constructMenuBand Procedure 
FUNCTION constructMenuBand RETURNS LOGICAL
  (pcBand AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-constructObjectMenus) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD constructObjectMenus Procedure 
FUNCTION constructObjectMenus RETURNS LOGICAL
  ( pcBand  AS CHAR,
    pcPlaceholder AS CHAR, 
    plBlank AS LOG )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-constructToolbar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD constructToolbar Procedure 
FUNCTION constructToolbar RETURNS LOGICAL
    ( ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-create3DRule) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD create3DRule Procedure 
FUNCTION create3DRule RETURNS HANDLE
  (              phParent     AS HANDLE,     /* handle to the parent frame */
    INPUT-OUTPUT piXY         AS INTEGER    /* the x - posistion */                 
  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createButton) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createButton Procedure 
FUNCTION createButton RETURNS HANDLE
  (              phFrame      AS HANDLE,
    INPUT-OUTPUT piXY         AS INTEGER, 
                 pcName       AS CHARACTER,
                 pcLabel      AS CHARACTER,
                 pcTooltip    AS CHARACTER,
                 pcImage      AS CHARACTER,  
                 plSensitive  AS LOGICAL  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createMenuAction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createMenuAction Procedure 
FUNCTION createMenuAction RETURNS HANDLE
  ( pcParent AS CHAR,
    pcAction AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createMenuBar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createMenuBar Procedure 
FUNCTION createMenuBar RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createMenuItem) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createMenuItem Procedure 
FUNCTION createMenuItem /**
*   @desc  Creates a menuitem 
*   @param <code>input pihParent handle</code> handle to (sub)menu
*   @param <code>input picName character</code> Name of menuitem
*   @param <code>input picCaption character</code>  Caption 
*   @param <code>input pilSensitive logical</code>  Item sensitive or not
*   @returns handle to menuitem
*/
RETURNS HANDLE
  ( phParent     AS HANDLE,     
    pcName       AS CHARACTER, 
    pcCaption    AS CHARACTER,  
    pcAccelerator AS CHARACTER,
    plSensitive  AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createMenuTempTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createMenuTempTable Procedure 
FUNCTION createMenuTempTable RETURNS ROWID PRIVATE
  (pcParent    AS CHAR,
   pcName      AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createMenuToggle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createMenuToggle Procedure 
FUNCTION createMenuToggle /**
*   @desc  Creates a menuitem 
*   @param <code>input pihParent handle</code> handle to (sub)menu
*   @param <code>input picName character</code> Name of menuitem
*   @param <code>input picCaption character</code>  Caption 
*   @param <code>input pilSensitive logical</code>  Item sensitive or not
*   @returns handle to menuitem
*/
RETURNS HANDLE
  ( phParent      AS HANDLE,
    pcName        AS CHARACTER,
    pcCaption     AS CHARACTER,
    pcAccelerator AS CHARACTER,
    plSensitive   AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createRule) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createRule Procedure 
FUNCTION createRule /**
*   @desc  Creates a rule
*   @param <code>input pihParent handle</code> handle to (sub)menu
*   @returns handle to rule
*/
RETURNS HANDLE
  ( phParent AS HANDLE /* Handle of the Parent */
  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createSubMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createSubMenu Procedure 
FUNCTION createSubMenu RETURNS HANDLE
  ( phParent     AS HANDLE,    /* Handle of the parent */
    pcName       AS CHARACTER, /* Name of the to be created submenu */
    pcCaption    AS CHARACTER, /* Caption of the be created submenu */
    plSensitive  AS LOGICAL    /* If the submenu has to be sensitive */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createToolbar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createToolbar Procedure 
FUNCTION createToolbar RETURNS LOGICAL
  (pcActions AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createToolbarAction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createToolbarAction Procedure 
FUNCTION createToolbarAction RETURNS HANDLE
  (pcBand            AS CHAR, 
   pcAction          AS CHAR,
   INPUT-OUTPUT piXY AS INT) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createToolbarBorder) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createToolbarBorder Procedure 
FUNCTION createToolbarBorder RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-defineAction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD defineAction Procedure 
FUNCTION defineAction RETURNS LOGICAL
  (pcAction  AS CHAR,
   pcColumns AS CHAR,
   pcValues  AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD deleteMenu Procedure 
FUNCTION deleteMenu RETURNS LOGICAL
  ()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteToolbar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD deleteToolbar Procedure 
FUNCTION deleteToolbar RETURNS LOGICAL
  ()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-disableActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD disableActions Procedure 
FUNCTION disableActions RETURNS LOGICAL
  (pcActions AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-enableActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD enableActions Procedure 
FUNCTION enableActions RETURNS LOGICAL
  (pcActions AS CHAR)  FORWARD.

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

&IF DEFINED(EXCLUDE-findAction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD findAction Procedure 
FUNCTION findAction RETURNS LOGICAL
  (pcAction AS CHAR,
   phTarget AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findCategory) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD findCategory Procedure 
FUNCTION findCategory RETURNS LOGICAL
  (pcCategory AS CHAR,
   phTarget   AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getActionBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getActionBuffer Procedure 
FUNCTION getActionBuffer RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getActionGroups) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getActionGroups Procedure 
FUNCTION getActionGroups RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAvailMenuActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAvailMenuActions Procedure 
FUNCTION getAvailMenuActions RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAvailToolbarActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAvailToolbarActions Procedure 
FUNCTION getAvailToolbarActions RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAvailToolbarBands) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAvailToolbarBands Procedure 
FUNCTION getAvailToolbarBands RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBoxRectangle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBoxRectangle Procedure 
FUNCTION getBoxRectangle RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBoxRectangle2) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBoxRectangle2 Procedure 
FUNCTION getBoxRectangle2 RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCommitTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCommitTarget Procedure 
FUNCTION getCommitTarget RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCommitTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCommitTargetEvents Procedure 
FUNCTION getCommitTargetEvents RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContainerToolbarTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getContainerToolbarTarget Procedure 
FUNCTION getContainerToolbarTarget RETURNS CHARACTER
    ( ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContainerToolbarTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getContainerToolbarTargetEvents Procedure 
FUNCTION getContainerToolbarTargetEvents RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCreateSubMenuOnConflict) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCreateSubMenuOnConflict Procedure 
FUNCTION getCreateSubMenuOnConflict RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDeactivateTargetOnHide) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDeactivateTargetOnHide Procedure 
FUNCTION getDeactivateTargetOnHide RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDisabledActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDisabledActions Procedure 
FUNCTION getDisabledActions RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getEdgePixels) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getEdgePixels Procedure 
FUNCTION getEdgePixels RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFlatButtons) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFlatButtons Procedure 
FUNCTION getFlatButtons RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getHiddenActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getHiddenActions Procedure 
FUNCTION getHiddenActions RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getHiddenMenuBands) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getHiddenMenuBands Procedure 
FUNCTION getHiddenMenuBands RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getHiddenToolbarBands) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getHiddenToolbarBands Procedure 
FUNCTION getHiddenToolbarBands RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getImagePath) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getImagePath Procedure 
FUNCTION getImagePath RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLinkTargetNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLinkTargetNames Procedure 
FUNCTION getLinkTargetNames RETURNS CHARACTER
 (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getMenu Procedure 
FUNCTION getMenu /**
*   @desc  Get attribute
*   @return attribute value true/false
*/
RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMenuMergeOrder) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getMenuMergeOrder Procedure 
FUNCTION getMenuMergeOrder RETURNS INTEGER
  (   )  FORWARD.

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

&IF DEFINED(EXCLUDE-getNavigationTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNavigationTarget Procedure 
FUNCTION getNavigationTarget RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNavigationTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNavigationTargetEvents Procedure 
FUNCTION getNavigationTargetEvents RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNavigationTargetName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNavigationTargetName Procedure 
FUNCTION getNavigationTargetName RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPanelState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPanelState Procedure 
FUNCTION getPanelState RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPanelType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPanelType Procedure 
FUNCTION getPanelType RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRemoveMenuOnHide) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRemoveMenuOnHide Procedure 
FUNCTION getRemoveMenuOnHide RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getShowBorder) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getShowBorder Procedure 
FUNCTION getShowBorder RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSubModules) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSubModules Procedure 
FUNCTION getSubModules RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTableioTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTableioTarget Procedure 
FUNCTION getTableioTarget RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTableioTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTableioTargetEvents Procedure 
FUNCTION getTableioTargetEvents RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTableIOType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTableIOType Procedure 
FUNCTION getTableIOType RETURNS CHARACTER
  (   )  FORWARD.

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

&IF DEFINED(EXCLUDE-getToolbar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getToolbar Procedure 
FUNCTION getToolbar /**
*   @desc  Get attribute
*   @return attribute value true/false
*/
RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolbarAutoSize) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getToolbarAutoSize Procedure 
FUNCTION getToolbarAutoSize RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolbarBands) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getToolbarBands Procedure 
FUNCTION getToolbarBands RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolbarDrawDirection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getToolbarDrawDirection Procedure 
FUNCTION getToolbarDrawDirection RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolbarHeightPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getToolbarHeightPxl Procedure 
FUNCTION getToolbarHeightPxl RETURNS INTEGER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolbarMinWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getToolbarMinWidth Procedure 
FUNCTION getToolbarMinWidth RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolbarParentMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getToolbarParentMenu Procedure 
FUNCTION getToolbarParentMenu RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolbarTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getToolbarTarget Procedure 
FUNCTION getToolbarTarget RETURNS CHARACTER
    ( ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolbarTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getToolbarTargetEvents Procedure 
FUNCTION getToolbarTargetEvents RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolbarWidthPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getToolbarWidthPxl Procedure 
FUNCTION getToolbarWidthPxl RETURNS INTEGER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolHeightPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getToolHeightPxl Procedure 
FUNCTION getToolHeightPxl RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolMarginPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getToolMarginPxl Procedure 
FUNCTION getToolMarginPxl RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolMaxWidthPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getToolMaxWidthPxl Procedure 
FUNCTION getToolMaxWidthPxl RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolSeparatorPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getToolSeparatorPxl Procedure 
FUNCTION getToolSeparatorPxl RETURNS INTEGER
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolSpacingPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getToolSpacingPxl Procedure 
FUNCTION getToolSpacingPxl RETURNS INTEGER
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolWidthPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getToolWidthPxl Procedure 
FUNCTION getToolWidthPxl RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getWindow Procedure 
FUNCTION getWindow RETURNS HANDLE
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hasActiveGATarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD hasActiveGATarget Procedure 
FUNCTION hasActiveGATarget RETURNS LOGICAL
  (phObject AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-imageName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD imageName Procedure 
FUNCTION imageName RETURNS CHARACTER
  ( pcAction AS CHAR,
    piNumber AS INT)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-insertMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD insertMenu Procedure 
FUNCTION insertMenu RETURNS LOGICAL
  (pcParent  AS CHARACTER,
   pcActions AS CHARACTER,
   plExpand  AS LOGICAL,
   pcBefore  AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-insertMenuTempTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD insertMenuTempTable Procedure 
FUNCTION insertMenuTempTable RETURNS LOGICAL PRIVATE
  (pcParent    AS CHAR,
   pcName      AS CHAR,
   pcBefore    AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-linkRuleBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD linkRuleBuffer Procedure 
FUNCTION linkRuleBuffer RETURNS HANDLE
     (pcLink   AS CHAR, 
      phTarget AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadImage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD loadImage Procedure 
FUNCTION loadImage RETURNS LOGICAL PRIVATE
  ( phObject AS HANDLE,
    pcImage AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-menuHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD menuHandle Procedure 
FUNCTION menuHandle RETURNS HANDLE PRIVATE
  (pcName AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-modifyDisabledActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD modifyDisabledActions Procedure 
FUNCTION modifyDisabledActions RETURNS LOGICAL
  ( pcMode    AS CHAR,
    pcActions AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-moveMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD moveMenu Procedure 
FUNCTION moveMenu RETURNS HANDLE
  ( phMenu      AS HANDLE,
    phNewParent AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-moveMenuChildren) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD moveMenuChildren Procedure 
FUNCTION moveMenuChildren RETURNS LOGICAL
  ( phOldParent AS HANDLE,
    phNewParent AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-normalizeActionData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD normalizeActionData Procedure 
FUNCTION normalizeActionData RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-prepareRuleTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD prepareRuleTable Procedure 
FUNCTION prepareRuleTable RETURNS CHARACTER
  ( phTable AS HANDLE,
    pcLink  AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removeMenuBand) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD removeMenuBand Procedure 
FUNCTION removeMenuBand RETURNS LOGICAL
  ( pcBand AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-retrieveBandsAndActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD retrieveBandsAndActions Procedure 
FUNCTION retrieveBandsAndActions RETURNS LOGICAL
    ( input pcToolbarList as character,
      input pcObjectList  as character,
      input pcBandList    as character    ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-sensitizeActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD sensitizeActions Procedure 
FUNCTION sensitizeActions RETURNS LOGICAL
  (pcActions AS CHAR,
   plSensitive AS LOG)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setActionGroups) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setActionGroups Procedure 
FUNCTION setActionGroups RETURNS LOGICAL
  (pcActionGroups AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAvailMenuActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAvailMenuActions Procedure 
FUNCTION setAvailMenuActions RETURNS LOGICAL
  (pcAvailMenuActions AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAvailToolbarActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAvailToolbarActions Procedure 
FUNCTION setAvailToolbarActions RETURNS LOGICAL
  (pcAvailToolbarActions AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBoxRectangle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBoxRectangle Procedure 
FUNCTION setBoxRectangle RETURNS LOGICAL
  ( phRectangle AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBoxRectangle2) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBoxRectangle2 Procedure 
FUNCTION setBoxRectangle2 RETURNS LOGICAL
  ( hValue AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBuffer Procedure 
FUNCTION setBuffer RETURNS LOGICAL PRIVATE
  (pcObject  AS CHAR,
   pcAction      AS CHAR,
   pcColumns AS CHAR,
   pcValues  AS CHAR,
   phTarget  AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCommitTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCommitTarget Procedure 
FUNCTION setCommitTarget RETURNS LOGICAL
  ( pcObject AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCommitTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCommitTargetEvents Procedure 
FUNCTION setCommitTargetEvents RETURNS LOGICAL
  ( pcEvents AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setContainerToolbarTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setContainerToolbarTarget Procedure 
FUNCTION setContainerToolbarTarget RETURNS LOGICAL
    ( pcTarget AS CHARACTER  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setContainerToolbarTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setContainerToolbarTargetEvents Procedure 
FUNCTION setContainerToolbarTargetEvents RETURNS LOGICAL
  ( pcEvents AS CHARACTER  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCreateSubMenuOnConflict) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCreateSubMenuOnConflict Procedure 
FUNCTION setCreateSubMenuOnConflict RETURNS LOGICAL
  ( plCreateSubMenu AS LOG )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDeactivateTargetOnHide) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDeactivateTargetOnHide Procedure 
FUNCTION setDeactivateTargetOnHide RETURNS LOGICAL
  ( plDeactivateTargetOnHide AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDisabledActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDisabledActions Procedure 
FUNCTION setDisabledActions RETURNS LOGICAL
  ( pcActions AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setEdgePixels) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setEdgePixels Procedure 
FUNCTION setEdgePixels RETURNS LOGICAL
  (piPixels AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFlatButtons) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFlatButtons Procedure 
FUNCTION setFlatButtons RETURNS LOGICAL
  ( plFlatButtons AS LOGICAL  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setHiddenActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setHiddenActions Procedure 
FUNCTION setHiddenActions RETURNS LOGICAL
  ( pcActions AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setHiddenMenuBands) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setHiddenMenuBands Procedure 
FUNCTION setHiddenMenuBands RETURNS LOGICAL
  (pcHiddenBands AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setHiddenToolbarBands) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setHiddenToolbarBands Procedure 
FUNCTION setHiddenToolbarBands RETURNS LOGICAL
  (pcHiddenBands AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setImagePath) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setImagePath Procedure 
FUNCTION setImagePath RETURNS LOGICAL
  ( pcImagePath AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLinkTargetNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLinkTargetNames Procedure 
FUNCTION setLinkTargetNames RETURNS LOGICAL
  ( pcLinkList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setMenu Procedure 
FUNCTION setMenu RETURNS LOGICAL
  ( plMenu AS LOGICAL  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setMenuMergeOrder) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setMenuMergeOrder Procedure 
FUNCTION setMenuMergeOrder RETURNS LOGICAL
  ( piOrder AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setNavigationButtons) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setNavigationButtons Procedure 
FUNCTION setNavigationButtons RETURNS LOGICAL
  ( pcState AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setNavigationTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setNavigationTarget Procedure 
FUNCTION setNavigationTarget RETURNS LOGICAL
  ( pcObject AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setNavigationTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setNavigationTargetEvents Procedure 
FUNCTION setNavigationTargetEvents RETURNS LOGICAL
  ( pcEvents AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setNavigationTargetName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setNavigationTargetName Procedure 
FUNCTION setNavigationTargetName RETURNS LOGICAL
  ( pcTargetName AS CHARACTER )  FORWARD.

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

&IF DEFINED(EXCLUDE-setPanelType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPanelType Procedure 
FUNCTION setPanelType RETURNS LOGICAL
  ( pcPanelType AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRemoveMenuOnHide) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setRemoveMenuOnHide Procedure 
FUNCTION setRemoveMenuOnHide RETURNS LOGICAL
  ( plRemoveMenu AS LOG )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setShowBorder) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setShowBorder Procedure 
FUNCTION setShowBorder RETURNS LOGICAL
  ( plShowBorder AS LOGICAL  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSubModules) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSubModules Procedure 
FUNCTION setSubModules RETURNS LOGICAL
  ( pcSubModules AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTableIOButtons) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTableIOButtons Procedure 
FUNCTION setTableIOButtons RETURNS LOGICAL
  ( pcState AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTableIOTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTableIOTarget Procedure 
FUNCTION setTableIOTarget RETURNS LOGICAL
  ( pcObject AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTableIOTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTableIOTargetEvents Procedure 
FUNCTION setTableIOTargetEvents RETURNS LOGICAL
  ( pcEvents AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTableioType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTableioType Procedure 
FUNCTION setTableioType RETURNS LOGICAL
  ( pcType AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolbar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setToolbar Procedure 
FUNCTION setToolbar RETURNS LOGICAL
  ( plToolbar AS LOGICAL  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolbarAutosize) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setToolbarAutosize Procedure 
FUNCTION setToolbarAutosize RETURNS LOGICAL
  ( plToolbarAutoSize AS LOGICAL  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolbarBands) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setToolbarBands Procedure 
FUNCTION setToolbarBands RETURNS LOGICAL
  (pcToolbarBands AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolbarDrawDirection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setToolbarDrawDirection Procedure 
FUNCTION setToolbarDrawDirection RETURNS LOGICAL
  (pcToolbarDrawDirection AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolbarMinWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setToolbarMinWidth Procedure 
FUNCTION setToolbarMinWidth RETURNS LOGICAL
  ( pdMinWidth AS DEC )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolbarParentMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setToolbarParentMenu Procedure 
FUNCTION setToolbarParentMenu RETURNS LOGICAL
  (pcToolbarParentMenu AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolbarTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setToolbarTarget Procedure 
FUNCTION setToolbarTarget RETURNS LOGICAL
    ( pcTarget AS CHARACTER  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolbarTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setToolbarTargetEvents Procedure 
FUNCTION setToolbarTargetEvents RETURNS LOGICAL
  ( pcEvents AS CHARACTER  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolHeightPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setToolHeightPxl Procedure 
FUNCTION setToolHeightPxl RETURNS LOGICAL
  ( iValue AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolMarginPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setToolMarginPxl Procedure 
FUNCTION setToolMarginPxl RETURNS LOGICAL
  ( iValue AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolMaxWidthPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setToolMaxWidthPxl Procedure 
FUNCTION setToolMaxWidthPxl RETURNS LOGICAL
    ( iValue AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolSeparatorPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setToolSeparatorPxl Procedure 
FUNCTION setToolSeparatorPxl RETURNS LOGICAL
    ( iValue AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolSpacingPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setToolSpacingPxl Procedure 
FUNCTION setToolSpacingPxl RETURNS LOGICAL
    ( iValue AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolWidthPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setToolWidthPxl Procedure 
FUNCTION setToolWidthPxl RETURNS LOGICAL
  ( iValue AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-substituteActionText) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD substituteActionText Procedure 
FUNCTION substituteActionText RETURNS CHARACTER
  ( pcAction AS CHAR,
    pcText   AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-supportedObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD supportedObjects Procedure 
FUNCTION supportedObjects RETURNS CHARACTER
  (plLoaded AS LOG)  FORWARD.

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

&IF DEFINED(EXCLUDE-validateBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD validateBuffer Procedure 
FUNCTION validateBuffer RETURNS LOGICAL PRIVATE
  ( pcBuffer AS CHAR,
    pcKey    AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-windowDropDownList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD windowDropDownList Procedure 
FUNCTION windowDropDownList RETURNS LOGICAL
  ( pcAction AS CHARACTER )  FORWARD.

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
         HEIGHT             = 34.05
         WIDTH              = 57.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/toolprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
IF VALID-HANDLE(gshSessionManager) THEN
    SUBSCRIBE TO "clearToolbarCache" IN gshSessionManager.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-buildAllMenus) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildAllMenus Procedure 
PROCEDURE buildAllMenus :
/*------------------------------------------------------------------------------
  Purpose:     Builds all branches of submenus before the persistent trigger 
               On MENU-DROP creates them on mouse click. 
               This will enables shortcuts (accelerators) from the very beginning.                                                                         
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE lOK      AS LOGICAL    NO-UNDO.

DEFINE BUFFER btMenu FOR tMenu.

FOR EACH btMenu WHERE btMenu.htarget = TARGET-PROCEDURE 
                AND   btMenu.PARENT = '':
  lOK = DYNAMIC-FUNCTION('BuildMenu' IN TARGET-PROCEDURE, btMenu.NAME).
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-clearActionCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearActionCache Procedure 
PROCEDURE clearActionCache :
/*------------------------------------------------------------------------------
  Purpose: Clear cached data by Emptying temp-tables        
  Parameters:  <none>
  Notes:   Called from instance clearCache but also directly from 
           session manager    
------------------------------------------------------------------------------*/
  EMPTY TEMP-TABLE ttCategory.
  EMPTY TEMP-TABLE ttAction.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-clearCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearCache Procedure 
PROCEDURE clearCache :
/*------------------------------------------------------------------------------
 Purpose:  Clear cached data by Emptying temp-tables       
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN clearToolbarCache IN TARGET-PROCEDURE.
  RUN SUPER.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-clearToolbarCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearToolbarCache Procedure 
PROCEDURE clearToolbarCache :
/*------------------------------------------------------------------------------
  Purpose:  Clear cached data by Empty temp-tables     
  Parameters: 
   Notes:   Called from instance clearCache but also directly from 
             session manager         
------------------------------------------------------------------------------*/
  EMPTY TEMP-TABLE ttToolbarBand.
  EMPTY TEMP-TABLE ttObjectBand. 
  EMPTY TEMP-TABLE ttBand.
  EMPTY TEMP-TABLE ttBandAction.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject Procedure 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:  Destroy dynamic widgets when the object is destroyed and
            delete the toolbars instance actions when it is destroyed      
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/ 
  DEFINE VARIABLE hMenubar    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cWidgetPool AS CHARACTER  NO-UNDO.

  PUBLISH 'unRegisterObject':U FROM TARGET-PROCEDURE.  /* iz 996*/

  RUN SUPER.

  {fn deleteToolbar}.
  {fn deleteMenu}.
  
  FOR EACH ttAction WHERE ttAction.ProcedureHandle = TARGET-PROCEDURE:
    DELETE ttAction.
  END.
  
  FOR EACH ttLinkRuleTable WHERE ttLinkRuleTable.ProcedureHandle = TARGET-PROCEDURE:
    IF VALID-HANDLE(ttLinkRuleTable.TableHandle) THEN
      DELETE OBJECT ttLinkRuleTable.TableHandle.
    DELETE ttLinkRuleTable.
  END.
  
  {get MenuBarHandle hMenubar}. 
  IF VALID-HANDLE(hMenuBar) THEN 
  DO:
    IF NOT CAN-FIND(FIRST tMenu WHERE tMenu.Menubarhdl = hMenubar) THEN
    DO:  
      /* get rid of the menu bar widget pool 
         (create in createMenuBar, needed because some menus survive their 
          constructor)  
        Non repository toolbars will recreate menu bars for each toolbar, so  
        we need to check if it the expression is valid (OWNER is valid) before
        we try to delete the widget-pool. 
      */
      
      cWidgetPool = {&menuwidgetpool} + STRING(hMenuBar:OWNER).      
      IF cWidgetPool > '':U THEN
        DELETE WIDGET-POOL {&menuwidgetpool} + STRING(hMenuBar:OWNER). 

      /* Really not needed as it went away with the widget-pool.. */
      DELETE OBJECT hMenubar NO-ERROR.     
      {set MenuBarHandle ?}. 
    END.
  END.
   
  ERROR-STATUS:ERROR = NO.  
        
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-displayActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayActions Procedure 
PROCEDURE displayActions :
/*------------------------------------------------------------------------------
  Purpose:     Utility procedure to put up a dialog showing all the Actions
               currently defined.
  Parameters:  <none>
  Notes:       Can be executed by selecting displayActions from the ProTools
               procedure object viewer for the desired SmartContainer.
------------------------------------------------------------------------------*/
  DEFINE QUERY qAction FOR ttAction SCROLLING.
  
  DEFINE VARIABLE Radio-Sort AS CHARACTER  LABEL "Sort By" INIT "Type":U   
         VIEW-AS RADIO-SET HORIZONTAL
         RADIO-BUTTONS 
              "Parent", "Parent":U,
              "Name", "Name":U,
              "Action", "Action":U
         SIZE 32 BY 1 NO-UNDO.

  DEFINE BUTTON Btn_OK AUTO-GO 
         LABEL "OK" 
         SIZE 12 BY 1.08
         BGCOLOR 8 .
  
  DEFINE BROWSE bAction QUERY qAction
    DISPLAY 
       Action  FORMAT "x(16)":U
       Parent  FORMAT "x(16)":U         
       Order            
       Name   FORMAT "x(18)":U
       Caption          
       Image   FORMAT "x(14)":U        
       Accelerator  FORMAT "x(10)":U 
       Link         FORMAT "x(18)":U
       Type         FORMAT "x(14)":U
       CreateEvent  FORMAT "x(14)":U
       OnChoose         
       CreateEvent
       initCode 
  WITH 12 DOWN SIZE 120 BY 10 SEPARATORS.
  
  DEFINE FRAME Dialog-Frame
     Radio-Sort AT ROW 1.5 COL 30
     Btn_OK AT ROW 14 COL 32
     bAction AT ROW 3 COL 1
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Actions":U.
         
  ON VALUE-CHANGED OF Radio-Sort 
  DO:
    CLOSE QUERY qAction.
    ASSIGN Radio-Sort.
    CASE Radio-sort:
      WHEN "parent" THEN OPEN QUERY qAction FOR EACH ttAction  BY PARENT BY order.
      WHEN "name" THEN OPEN QUERY qAction FOR EACH ttAction  BY Name.
      WHEN "Action" THEN OPEN QUERY qAction FOR EACH ttAction  BY Action.
      OTHERWISE OPEN QUERY qAction FOR EACH ttAction  BY Action.
    END CASE.
  END.
      
  ENABLE Radio-Sort bAction   Btn_OK   
      WITH FRAME Dialog-Frame.
  
  OPEN QUERY qAction FOR EACH ttAction  BY PARENT BY order.
  
  WAIT-FOR GO OF FRAME Dialog-Frame.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-displayMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayMenu Procedure 
PROCEDURE displayMenu :
DEFINE BUFFER btMenu FOR tMenu.
 
 DEFINE QUERY qMenu FOR btMenu SCROLLING.
  
  DEFINE VARIABLE Radio-Sort AS CHARACTER  LABEL "Sort By" INIT "Type":U   
         VIEW-AS RADIO-SET HORIZONTAL
         RADIO-BUTTONS 
              "Parent", "Parent":U,
              "Name", "Name":U,
              "Toolbar", "Toolbar",
              "Caption", "Caption":U
         SIZE 70 BY 1 NO-UNDO.

  DEFINE BUTTON Btn_OK AUTO-GO 
         LABEL "OK" 
         SIZE 12 BY 1.08
         BGCOLOR 8 .
  
  DEFINE BROWSE bMenu QUERY qMenu
    DISPLAY 
       Parent  FORMAT "x(16)":U         
       NAME    FORMAT "x(16)":U
       Caption FORMAT "x(35)":U
       STRING(hTarget) @ hTarget
       Seq     
       MergeOrder    
       Link     FORMAT "x(25)"     
  WITH 12 DOWN SIZE 120 BY 10 SEPARATORS .
  
  DEFINE FRAME Dialog-Frame
     Radio-Sort AT ROW 1.5 COL 30
     Btn_OK AT ROW 14 COL 32
     bMenu AT ROW 3 COL 1
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Actions":U.
  bMenu:COLUMN-RESIZABLE = TRUE.
  

  ON VALUE-CHANGED OF Radio-Sort 
  DO:
    CLOSE QUERY qMenu.
    ASSIGN Radio-Sort.
    CASE Radio-sort:
      WHEN "parent" THEN OPEN QUERY qMenu FOR EACH btMenu 
                       BY PARENT.
      WHEN "name" THEN OPEN QUERY qMenu FOR EACH btMenu 
                       BY Name.
      WHEN "toolbar" THEN OPEN QUERY qMenu FOR EACH btMenu 
                        BY hTarget.
      WHEN "Caption" THEN OPEN QUERY qMenu FOR EACH btMenu
                       BY Caption.
      OTHERWISE OPEN QUERY qMenu FOR EACH btMenu  BY hTarget 
                         BY PARENT BY name.
    END CASE.
  END.
      
  ENABLE Radio-Sort bmENU   Btn_OK   
      WITH FRAME Dialog-Frame.
  
 OPEN QUERY qMenu FOR EACH btMenu BY Name.

  WAIT-FOR GO OF FRAME Dialog-Frame.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-filterState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE filterState Procedure 
PROCEDURE filterState :
/*------------------------------------------------------------------------------
  Purpose:     published from Navigation-Target to tell the panel when to enable
               filter action (when its linked).
  Parameters:  INPUT pcState AS CHARACTER - 'FilterAvailable'
  Notes:      
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcState AS CHARACTER NO-UNDO.

  IF pcState = 'FilterAvailable':U THEN
    RUN setButtons IN TARGET-PROCEDURE ('enable-filter':U).
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hideObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE hideObject Procedure 
PROCEDURE hideObject :
/*----------------------------------------------------------------------------
  Purpose: Hide the object 
           The purpose for the override is to remove the menu bar handle 
           from the window for non-repository objects.  
Parameters: <none> 
     Notes: This somewhat strange removal of the menu bar on hide was 
            implemented mostly because we did not support   
     
            Repository objects allows different toolbars to share the menubar
            and does not need to hide it when the object is hidden.             
-----------------------------------------------------------------------------*/
  DEFINE VARIABLE hWindow        AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hMenu          AS HANDLE  NO-UNDO.
  DEFINE VARIABLE lUseRepository AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lMenu       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lRemoveMenu AS LOGICAL    NO-UNDO.

  {get UseRepository lUseRepository}.
  IF NOT lUseRepository THEN
  DO:
    {get Window hWindow}.
    {get MenubarHandle hMenu}.
    IF VALID-HANDLE(hMenu) AND VALID-HANDLE(hWindow) THEN 
    DO:
      /* Only remove if it is our own menubar */
      IF hWindow:MENUBAR = hMenu THEN 
        hWindow:MENUBAR = ?.
    END.
  END.
  ELSE DO: 
    
    &SCOPED-DEFINE xp-assign
    {get Menu lMenu}
    {get RemoveMenuOnhide lRemoveMenu}
    .
    &UNDEFINE xp-assign
    /* if remove on hide then remove */ 
    IF lRemoveMenu AND lMenu THEN
       RUN removeMenu IN TARGET-PROCEDURE.
  END.

  RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initAction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initAction Procedure 
PROCEDURE initAction :
/*------------------------------------------------------------------------------
  Purpose: Defines all default actions for the adm when running without a 
           repository.     
  Parameters:  <none>
  Notes:  The actions defined here are class actions and are available for all 
          objects (toolbars) that inherits from this class. 
          This procedure is called from initializeObject, but ONLY the first 
          time it's been called. 
------------------------------------------------------------------------------*/
   DEF VAR xcColumns AS CHAR INIT 
   "Name,Caption,Image,Type,OnChoose,AccessType,Parent,EnableRule":U.
   
   &SCOP dlmt + CHR(1) + 
   
   defineAction("FILE":U,"Name,Caption,Type":U,
                "File" {&dlmt}
                "File"  {&dlmt}
                "Menu":U).
   
   defineAction("TABLEIO":U,"Name,Caption,Link":U,
                "Tableio" {&dlmt}
                "Tableio" {&dlmt}
                "Tableio-target":U ).
   
   /* The function currently has one child, filter, but it's defined as a 
      group/parent to make it appear in the Inst Props and to be able to add 
      other actions later. */
   defineAction("FUNCTION":U,"Name,Caption":U,
                "Functions" {&dlmt}
                "Functions" ).

   defineAction("NAVIGATION":U,"Name,Caption,Link":U,
                "Navigation" {&dlmt}
                "Navigation" {&dlmt}
                "Navigation-target":U ).
      
   defineAction("TRANSACTION","Name,Caption,Link":U,
                "Commit" {&dlmt}
                "Transaction" {&dlmt}
                "Commit-target":U ).
      
   defineAction("ADD",xcColumns,
                "Add" {&dlmt}   
                "Add record" {&dlmt}
                "add.bmp":U  {&dlmt}
                "PUBLISH":U  {&dlmt}
                "addRecord":U {&dlmt}
                "CREATE":U {&dlmt}
                "TABLEIO":U {&dlmt}
                "RecordState=RecordAvailable,NoRecordAvailable and Editable and DataModified=no and CanNavigate()":U
                ).

   defineAction("UPDATE":U,xcColumns,
                "Update" {&dlmt}   
                "Update record" {&dlmt}
                "update.bmp":U  {&dlmt}
                "PUBLISH":U  {&dlmt}
                "updateMode('updateBegin')":U {&dlmt}
                "WRITE":U {&dlmt}
                "TABLEIO":U {&dlmt}
                "RecordState=RecordAvailable and Editable and ObjectMode=View":U
                ).
                   
   defineAction("COPY":U,xcColumns,
                "Copy" {&dlmt}   
                "Copy record" {&dlmt}
                "copyrec.bmp":U  {&dlmt}
                "PUBLISH":U  {&dlmt}
                "copyRecord":U {&dlmt}
                "CREATE":U {&dlmt}
                "TABLEIO":U {&dlmt}
                "RecordState=RecordAvailable and Editable and DataModified=no and canNavigate()":U
                ).
  
    defineAction("DELETE":U,xcColumns,
                "Delete" {&dlmt}   
                "Delete record" {&dlmt}
                "deleterec.bmp":U  {&dlmt}
                "PUBLISH":U  {&dlmt}
                "deleteRecord":U {&dlmt}
                "DELETE":U {&dlmt}
                "TABLEIO":U {&dlmt}
                "RecordState=RecordAvailable and DataModified=no and canNavigate()":U
                ).
                
   defineAction("SAVE":U,xcColumns,
                "Save" {&dlmt}   
                "Save record" {&dlmt}
                "saverec.bmp":U  {&dlmt}
                "PUBLISH":U  {&dlmt}
                "updateRecord":U {&dlmt}
                "WRITE":U {&dlmt}
                "TABLEIO":U {&dlmt}
                "NewRecord=add,copy or DataModified":U
                ).
   
   defineAction("RESET":U,xcColumns,
                "Reset" {&dlmt}   
                "Reset" {&dlmt}
                "reset.bmp":U  {&dlmt}
                "PUBLISH":U  {&dlmt}
                "resetRecord":U {&dlmt}
                "":U {&dlmt}
                "TABLEIO":U {&dlmt}
                "DataModified"
                ).
   
   defineAction("CANCEL":U,xcColumns,
                "Cance&l" {&dlmt}   
                "Cance&l" {&dlmt}
                "cancel.bmp":U  {&dlmt}
                "PUBLISH":u  {&dlmt}
                "cancelRecord":U {&dlmt}
                "":U {&dlmt}
                "TABLEIO":U {&dlmt}
                "ObjectMode=Modify and SaveSource=no and DataModified or ObjectMode=Update or NewRecord=add,copy":U
                ).
   
   defineAction("UNDO":U,xcColumns,
                "U&ndo" {&dlmt}   
                "U&ndo" {&dlmt}
                "rollback.bmp":U  {&dlmt}
                "PUBLISH":U  {&dlmt}
                "undoTransaction":U {&dlmt}
                "":U {&dlmt}
                "TRANSACTION":U {&dlmt}
                "RowObjectState=RowUpdated"
                ).
  
  defineAction("COMMIT":U,xcColumns,
                "Co&mmit" {&dlmt}   
                "Co&mmit" {&dlmt}
                "commit.bmp":U  {&dlmt}
                "PUBLISH":U  {&dlmt}
                "commitTransaction":U {&dlmt}
                "WRITE":U {&dlmt}
                "TRANSACTION":U {&dlmt}
                "RowObjectState=RowUpdated"
                ).

   defineAction("FIRST":U,xcColumns,
                "First" {&dlmt}   
                "First" {&dlmt}
                "first.bmp":U  {&dlmt}
                "PUBLISH":U  {&dlmt}
                "fetchFirst":U {&dlmt}
                "READ":U {&dlmt}
                "NAVIGATION":U {&dlmt}
                "QueryPosition=LastRecord,NotFirstOrlast and canNavigate()":U
                ).

   defineAction("PREV":U,xcColumns,
                "Prev" {&dlmt}   
                "Prev" {&dlmt}
                "prev.bmp":U  {&dlmt}
                "PUBLISH":U  {&dlmt}
                "fetchPrev":U {&dlmt}
                "READ":U {&dlmt}
                "NAVIGATION":U {&dlmt}
                "QueryPosition=LastRecord,NotFirstOrlast and canNavigate()":U
                ).

   defineAction("NEXT":U,xcColumns,
                "Next" {&dlmt}   
                "Next" {&dlmt}
                "next.bmp":U  {&dlmt}
                "PUBLISH":U  {&dlmt}
                "fetchNext":U {&dlmt}
                "READ":U {&dlmt}
                "NAVIGATION":U {&dlmt}
                "QueryPosition=FirstRecord,NotFirstOrlast and canNavigate()":U
                ).

   defineAction("LAST":U,xcColumns,
                "Last" {&dlmt}   
                "Last" {&dlmt}
                "last.bmp":U  {&dlmt}
                "PUBLISH":U  {&dlmt}
                "fetchLast":U {&dlmt}
                "READ":U {&dlmt}
                "NAVIGATION":U {&dlmt}
                "QueryPosition=FirstRecord,NotFirstOrlast and canNavigate()":U
                ).
  
   defineAction("EXIT":U,xcColumns,
                "Exit" {&dlmt}   
                "Exit" {&dlmt}
                "exit.bmp":U  {&dlmt}
                "PUBLISH":U  {&dlmt}
                "exitObject":U {&dlmt}
                "":U {&dlmt}
                "":U
                ). 
   
   defineAction("FILTER":U,xcColumns + ",":U + 'Link':U,
                "Filter" {&dlmt}   
                "Filter" {&dlmt}
                "filter.bmp":U  {&dlmt}
                "PUBLISH":U  {&dlmt}
                "startFilter":U {&dlmt}
                "READ":U {&dlmt}
                "FUNCTION":U {&dlmt}
                "FilterAvailable=yes":U {&dlmt}
                "navigation-target":U
                ).
                                                                                       
   &UNDEFINE dlmt             

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose: initialize the toolbar by creating all dynmaic buttons and menues.     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lToolBar         AS LOG        NO-UNDO.
  DEFINE VARIABLE lMenu            AS LOG        NO-UNDO.
  DEFINE VARIABLE cBlank           AS CHAR       NO-UNDO.
  DEFINE VARIABLE hFrame           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hWindow          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hPopupFrame      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cUIBMode         AS CHAR       NO-UNDO.
  DEFINE VARIABLE lInit            AS LOG        NO-UNDO.
  DEFINE VARIABLE cInfo            AS CHAR       NO-UNDO.
  DEFINE VARIABLE lHideOnInit      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lUseRepository   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cTableioType     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cHidden          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPanelType       AS CHARACTER  NO-UNDO.

  /* Tableiotype 'save' is managed by HiddenActions from 9.1D */ 
  &SCOPED-DEFINE xp-assign
  {get TableioType cTableioType}
  {get HiddenActions cHidden}
  {get UIBMode cUIBmode}
  {get Menu lMenu}
  {get UseRepository lUseRepository}
  {get PanelType cPanelType}
  .
  &UNDEFINE xp-assign
  

  IF cPanelType = 'toolbar':U AND cTableioType = 'Save':U AND LOOKUP('update':U,cHidden) = 0 THEN
  DO:
    cHidden  = cHidden 
             + (IF cHidden = '':U THEN '':U ELSE ',':U) 
             + 'Update':U.
    {set HiddenActions cHidden}.
  END.

  /* Assign var to determine in resizeObject when initialization is complete */
  ASSIGN glInitComplete = NO.
  IF NOT cUIBMode BEGINS "DESIGN":U THEN 
  DO:
    /* The sbo subscribes to this event in order to update ObjectMapping */
    PUBLISH 'registerObject':U FROM TARGET-PROCEDURE.

    {get ObjectInitialized lInit}.
    IF lInit THEN RETURN "ADM-ERROR":U.
  END.
 
  IF NOT glInitialized AND NOT lUseRepository THEN
  DO:
     /* This is considered class properties and will only be defined the
        first time an instance is initialized. */
    RUN initAction IN TARGET-PROCEDURE. 
    glInitialized = TRUE.
  END.
  
  RUN SUPER. 

  {get ContainerHandle hFrame}.
  
  ASSIGN
    hFrame:SCROLLABLE = FALSE
    hFrame:HIDDEN     = TRUE.
  
  IF cPanelType = 'toolbar' THEN
  DO:
    IF cUIBMode BEGINS "DESIGN":U THEN
    DO:
      IF lMenu THEN
      DO:
        RUN adeuib/_uibinfo.p (?,"PROCEDURE ?","CONTEXT",OUTPUT cInfo). 
        RUN adeuib/_uibinfo.p (INT(cInfo),?,"TYPE":U,OUTPUT cInfo).     
        IF cinfo = "DIALOG-BOX":U THEN 
        DO:
          MESSAGE 
            "A dialog-box cannot have a menu interface."
            "The menu option will be turned off."
          VIEW-AS ALERT-BOX.
          lMenu  = FALSE.
          {set Menu lMenu}.
        END. /* cInfo = dialog */
      
        /* Find the windows context (we could have used WINDOW ? in the next call,
           but this makes it safe if this should be called when not current) */
        {get Window hWindow}.
      
        RUN adeuib/_uibinfo.p 
             (?,"HANDLE " + STRING(hWindow),"CONTEXT",OUTPUT cInfo). 

        RUN adeuib/_uibinfo.p
             (INT(cInfo),?,"CONTAINS MENU RETURN CONTEXT", OUTPUT cInfo).

        IF cInfo <> "":U THEN 
        DO:
          MESSAGE
        "This window already has a menu that has been created with the AppBuilder." 
          SKIP
        "That menu must be deleted before the SmartToolbar menu can be created."
          SKIP
        "The SmartToolbar menu option will be turned off." 
          SKIP
          VIEW-AS ALERT-BOX INFORMATION.
          lMenu  = FALSE.
          {set Menu lMenu}.
        END. /* cInfo <> '' */
     
        {fn deleteMenu}.  
        {fn deleteToolbar}.
        {get Toolbar lToolbar}.
        IF NOT lToolbar THEN
          {set ToolbarAutoSize FALSE}.
  
        /* Find the ventilator frame */
        hPopupFrame = hFrame:FIRST-CHILD.
        hPopupFrame = hPopupframe:FIRST-CHILD.    
        &SCOPED-DEFINE xp-assign
        {set AvailMenuActions cBlank}
        {set AvailToolbarActions cBlank}.
        &UNDEFINE xp-assign
      END. /* If lMenu */  
    END.  

    IF lUseRepository THEN
    DO:
      RUN loadToolbar IN TARGET-PROCEDURE. 
      {fn constructToolbar}.
      {fn constructMenu}.
    END.
    ELSE DO:
      {fn initializeMenu}.
      {fn initializeToolBar}.
    END.
  END.

  {get HideOnInit lHideOnInit}.
   
  IF NOT lHideOnInit THEN 
  DO:
    RUN viewObject IN TARGET-PROCEDURE.
    IF cUIBmode = "DESIGN":U AND ERROR-STATUS:GET-NUMBER(1) = 6491 THEN
    DO:      
      MESSAGE 
     "The toolbar is too small to show all buttons. " 
     "This will typically occur when the container is too small. "  SKIP
     "The container must be resized manually before the toolbar can be resized." SKIP
     "The toolbar may be resized manually or by applying the Instance Properties."  SKIP
     VIEW-AS ALERT-BOX INFORMATION.
  
    END. /* if error */

    IF VALID-HANDLE(hPopupFrame) THEN 
      hPopupframe:MOVE-TO-TOP().
  END.
    
  IF cUIBmode = '':U THEN
    RUN resetAllTargetActions IN TARGET-PROCEDURE.

  ASSIGN glInitComplete = YES.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-linkState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkState Procedure 
PROCEDURE linkState :
/*------------------------------------------------------------------------------
  Purpose:     Receives messages when an object linked to this one becomes
               "active" or "activeTarget" (normally when it's viewed) or 
               "inactive" or "inactiveTarget" (Hidden).
               resets panel buttons accordingly.
  Parameters:  pcState AS CHARACTER -- 'active*'/'inactive*'
               The activeTarget function is very important in the event 
               procedures called by this to identify which object to reset. 
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcState  AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE iLink                   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cLink                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLinkType               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTargets                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hContainerSource        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lDeactivateTargetOnHide AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iTarget                 AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hTarget                 AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cLinkTargetNames        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSources                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDataTargets            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lQuery                  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lHidden                 AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hContainer              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTargetContainer        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cContainerType          AS CHARACTER  NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get LinkTargetNames cLinkTargetNames}
  {get DeactivateTargetOnHide lDeactivateTargetOnHide}.
  &UNDEFINE xp-assign
  
  DO iLink = 1 TO NUM-ENTRIES(cLinkTargetNames):
    ASSIGN 
      cLink     = ENTRY(iLink,cLinkTargetNames)
      cLinkType = ENTRY(1,cLink,'-':U)
      cLink     = REPLACE(cLink,'-':U,'':U)
      cTargets  = DYNAMIC-FUNCTION('get':U + cLink IN TARGET-PROCEDURE) 
      cLink     = REPLACE(cLink,"Target":U,"Source":U)
      NO-ERROR.
    
    IF cLinkType = 'ContainerToolbar':U THEN NEXT.

    IF CAN-DO(cTargets,STRING(SOURCE-PROCEDURE)) THEN
    DO:
      IF pcState BEGINS 'active':U 
      AND NOT lDeactivateTargetOnHide
      AND NUM-ENTRIES(cTargets) > 1  THEN
      DO:
        TargetLoop:
        DO iTarget = 1 TO NUM-ENTRIES(cTargets):
          hTarget = WIDGET-HANDLE(ENTRY(iTarget,cTargets)). 
          IF hTarget <> SOURCE-PROCEDURE THEN
            RUN linkStateHandler IN hTarget ('inactive':U,
                                             TARGET-PROCEDURE,
                                             cLink) NO-ERROR. 
        END.
      END.

      IF (pcState BEGINS 'active':U OR lDeactivateTargetOnHide) THEN
      DO: 
        /* If an indirect message from a Target of our Target, we check 
           the if the visual data targets of the publisher is truly 
           hidden before we disable the link. 
           This is to deal with the case were a datasource has multiple 
           navtargets. In that case we only disable the navtarget on 
           the window where the visual object is hidden.    */
        IF pcstate = 'InActiveTarget':U THEN
        DO:
          {get DataTarget cDataTargets SOURCE-PROCEDURE} NO-ERROR.
          DO iTarget = 1 TO NUM-ENTRIES(cDataTargets):
            hTarget = WIDGET-HANDLE(ENTRY(iTarget,cDataTargets)). 
            {get QueryObject lQuery hTarget}.          
            IF NOT lQuery THEN
            DO:
              lHidden = ?.
              {get GroupAssignHidden lHidden hTarget} NO-ERROR.
              IF lHidden = FALSE THEN
              DO:
                /* Get the window of the target */
                {get ContainerHandle hTargetContainer hTarget}.
                DO WHILE VALID-HANDLE(hTargetContainer):
                  IF hTargetContainer:TYPE = 'WINDOW':U THEN
                    LEAVE.
                  hTargetContainer = hTargetContainer:PARENT.
                END.

                /* Get our window  */
                {get ContainerHandle hContainer}.
                DO WHILE VALID-HANDLE(hContainer):
                  IF hContainer:TYPE = 'WINDOW':U THEN
                    LEAVE.
                  hContainer = hContainer:PARENT.
                END.
                /* We are in the same window as a visible target of the publisher, 
                   ignore the request */
                IF VALID-HANDLE(hContainer) AND hContainer = hTargetContainer THEN
                   RETURN.
              END. /* not hidden */
            END. /* not query (visual) */
          END. /* loop through targets of publisher */
        END.

        RUN linkStateHandler IN SOURCE-PROCEDURE (REPLACE(pcState,'Target':U,'':U),
                                                  TARGET-PROCEDURE,
                                                  cLink) NO-ERROR. 

        RUN VALUE('reset':U + cLinkType) IN TARGET-PROCEDURE. 
      END.
    END.
  END.


  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadActions Procedure 
PROCEDURE loadActions :
/*------------------------------------------------------------------------------
  Purpose:    Load specified actions.  
  Parameters:  
  Notes:      LoadPanel in panel.p uses this to load actions for panels 
------------------------------------------------------------------------------*/
 DEFINE INPUT PARAMETER pcActionList AS CHARACTER  NO-UNDO. 

 DEFINE VARIABLE cProperties      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE dUserObj         AS DECIMAL    NO-UNDO.
 DEFINE VARIABLE dOrganizationObj AS DECIMAL    NO-UNDO.

 /* gshAstraAppserver will only be valid if we're running Dynamics */
 IF VALID-HANDLE(gshAstraAppserver) 
 AND VALID-HANDLE(gshSessionManager) THEN
 DO:
   ASSIGN cProperties      = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                INPUT "currentUserObj,currentOrganisationObj":U,INPUT NO)
          dUserObj         = DECIMAL(ENTRY(1, cProperties, CHR(3)))
          dOrganizationObj = DECIMAL(ENTRY(2, cProperties, CHR(3)))
          NO-ERROR.

   RUN ry/app/rygetitemp.p ON gshAstraAppserver (INPUT '':U,
                                                 INPUT pcActionList,
                                                 INPUT dUserObj,
                                                 INPUT dOrganizationObj,
                                                 OUTPUT TABLE ttAction APPEND,
                                                 OUTPUT TABLE ttCategory APPEND).

   {fn normalizeActionData}.
 END.
 RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadBands) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadBands Procedure 
PROCEDURE loadBands :
/*------------------------------------------------------------------------------
  Purpose:    Load data for one or more band.  
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER pcBandList  AS CHARACTER  NO-UNDO. 

 DEFINE OUTPUT PARAMETER TABLE-HANDLE hBand.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE hBandAction.

 /* gshAstraAppserver will only be valid if we're running Dynamics */
  IF VALID-HANDLE(gshAstraAppserver) 
  AND VALID-HANDLE(gshSessionManager) THEN
    /* Get the band data. */
    dynamic-function('retrieveBandsAndActions':U in target-procedure,
                      input '', input '', input pcBandList).
     
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadCategories) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadCategories Procedure 
PROCEDURE loadCategories :
/*------------------------------------------------------------------------------
  Purpose:    Load specified actions.  
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER pcCategoryList AS CHARACTER  NO-UNDO. 

 IF VALID-HANDLE(gshRepositoryManager) THEN
   RUN getActions IN gshRepositoryManager
                       (INPUT pcCategoryList,
                        INPUT '':U,
                        OUTPUT TABLE ttAction APPEND,
                        OUTPUT TABLE ttCategory APPEND).
                        
 {fn normalizeActionData}.

 END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadObjectBands) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadObjectBands Procedure 
PROCEDURE loadObjectBands :
/*------------------------------------------------------------------------------
  Purpose:    Load bands and actions for one or more objects object  
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER pcObjectList AS CHARACTER  NO-UNDO. 

 /* gshAstraAppserver will only be valid if we're running Dynamics */
 IF  VALID-HANDLE(gshAstraAppserver) 
 AND VALID-HANDLE(gshSessionManager) THEN 
   dynamic-function('retrieveBandsAndActions' in target-procedure,
                    input '', input pcObjectList, input '').
     
 return. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadToolbar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadToolbar Procedure 
PROCEDURE loadToolbar :
/*------------------------------------------------------------------------------
  Purpose:     Load toolbar, bands and actions for the toolbar object
  Parameters:  <none>
  Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cToolbar                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLoadToolbar             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectList              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUIBmode                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAvailableMenuActions    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAvailableToolbarActions AS CHARACTER  NO-UNDO.

  /* Toolbar name? */
  {get LogicalObjectName cToolbar}.
  IF cToolbar = '':U OR cToolbar = ? THEN
  DO:
    &SCOPED-DEFINE xp-assign
    {get ObjectName cToolbar}
    {set LogicalObjectName cToolbar}
    .
    &UNDEFINE xp-assign
  END.

  /* Check if this toolbar is in the cache. If not we need to load it */
  IF NOT CAN-FIND(FIRST ttToolbarBand
                  WHERE ttToolbarBand.Toolbar = cToolbar) THEN
    cLoadToolbar = cToolbar.

  cObjectList = {fnarg supportedObjects NO}. /* no=Only return unloaded bands */

  IF cLoadToolbar > '' OR cObjectList > '' THEN
     /* Extract the toolbar and object bands */
    RUN loadToolbarBands IN TARGET-PROCEDURE ( cLoadToolbar, cObjectList).

  {get UIBMode cUIBMode}.
  /* If we're in design mode, update category lists for Instance Dialog */
  IF cUIBmode = 'Design':U THEN
  DO:
    FOR EACH ttToolbarBand
        WHERE ttToolbarBand.Toolbar = cToolbar,
        EACH ttBand
        WHERE ttBand.Band = ttToolbarBand.Band:

      RUN updateCategoryLists IN TARGET-PROCEDURE 
                                  (ttBand.Band,
                                   ttBand.BandType,
                                   INPUT-OUTPUT cAvailableMenuActions,
                                   INPUT-OUTPUT cAvailableToolbarActions).
    END. /* for each*/

    &SCOPED-DEFINE xp-assign
    {set AvailMenuActions cAvailableMenuActions}
    {set AvailToolbarActions cAvailableToolbarActions}.
    &UNDEFINE xp-assign
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadToolbarBands) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadToolbarBands Procedure 
PROCEDURE loadToolbarBands :
/*------------------------------------------------------------------------------
  Purpose:    Load bands and actions for a toolbar  
  Parameters:  
             
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT PARAMETER pcToolbarList AS CHARACTER  NO-UNDO.
 DEFINE INPUT PARAMETER pcObjectList  AS CHARACTER  NO-UNDO.

 /* gshAstraAppserver will only be valid if we're running Dynamics */
 IF  VALID-HANDLE(gshAstraAppserver) 
 AND VALID-HANDLE(gshSessionManager) THEN
    dynamic-function('retrieveBandsAndActions' in target-procedure,
                     input pcToolbarList, input pcObjectList, input '').
                     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-movebuttons) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE movebuttons Procedure 
PROCEDURE movebuttons :
/*------------------------------------------------------------------------------
  Purpose:     Calculate start positions for left, right, and centre aligned
               bands in the toolbar according to the current width of the toolbar
               frame, then move the existing buttons into their new positions.
               This is called from resizeObject so it is always current for the
               actual size of the toolbar frame.
  Parameters:  input plForceMove to force buttons to be moved if set to YES.
  Notes:       We only work on already built buttons.
               The first thing we must do is see if there are any right and centre
               aligned bands and if not, we can just exist as there is nothing to do.
               Also if all buttons are left aligned there is nothing to do.
               We must ignore hidden buttons.
               When called from viewHideActions procedure after buttons have been
               viewed/hidden, then we must force this procedure to run in order to
               correctly position buttons and not leave any gaps.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcForceMove    AS LOGICAL NO-UNDO.

  DEFINE VARIABLE hFrame                AS HANDLE NO-UNDO.
  DEFINE VARIABLE hWindow               AS HANDLE NO-UNDO.
  DEFINE VARIABLE cLogicalObjectName    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iBeginXpxl            AS INT    NO-UNDO. 
  DEFINE VARIABLE iBeginYpxl            AS INT    NO-UNDO. 
  DEFINE VARIABLE iToolSeparatorPxl     AS INTEGER NO-UNDO.
  DEFINE VARIABLE iToolSpacingPxl       AS INTEGER NO-UNDO.
  DEFINE VARIABLE lShowBorder           AS LOG    NO-UNDO. 
  DEFINE VARIABLE dMinWidth      AS DEC    NO-UNDO. 
  DEFINE VARIABLE dMinHeight     AS DEC    NO-UNDO. 
  DEFINE VARIABLE lToolbarAutoSize      AS LOGICAL NO-UNDO.
  DEFINE VARIABLE cToolbarDrawDirection AS CHAR    NO-UNDO.
  DEFINE VARIABLE iLeftBeginXpxl        AS INT    NO-UNDO. 
  DEFINE VARIABLE iLeftBeginYpxl        AS INT    NO-UNDO. 
  DEFINE VARIABLE iRightBeginXpxl       AS INT    NO-UNDO. 
  DEFINE VARIABLE iRightBeginYpxl       AS INT    NO-UNDO. 
  DEFINE VARIABLE iCentreBeginXpxl      AS INT    NO-UNDO. 
  DEFINE VARIABLE iCentreBeginYpxl      AS INT    NO-UNDO. 

  DEFINE VARIABLE iLeftHeightPxl        AS DEC    NO-UNDO.
  DEFINE VARIABLE iLeftWidthPxl         AS DEC    NO-UNDO.
  DEFINE VARIABLE iRightHeightPxl       AS DEC    NO-UNDO.
  DEFINE VARIABLE iRightWidthPxl        AS DEC    NO-UNDO.
  DEFINE VARIABLE iCentreHeightPxl      AS DEC    NO-UNDO.
  DEFINE VARIABLE iCentreWidthPxl       AS DEC    NO-UNDO.


  DEFINE BUFFER btButton FOR tButton.
  {get LogicalObjectName cLogicalObjectName}.
   /* 1st see if any right or centre alignment options selected and if not, exit */
  IF NOT pcForceMove AND 
     NOT CAN-FIND(FIRST ttToolbarBand
                  WHERE ttToolbarBand.ToolbarName = cLogicalObjectName
                  AND   ttToolbarBand.Alignment   <> "left":U) THEN RETURN. 

  &SCOPED-DEFINE xp-assign
  {get ContainerHandle hFrame}
  {get ShowBorder lShowBorder}
  {get ToolSpacingPxl iToolSpacingPxl}
  {get ToolSeparatorPxl iToolSeparatorPxl}
  {get ToolbarAutoSize lToolbarAutoSize}
  {get ToolbarDrawDirection cToolbarDrawDirection}
  {get Window hWindow}
  {get MinWidth dMinWidth}
  {get MinHeight dMinHeight}
  .
  &UNDEFINE xp-assign

  /* 1st check if any room to move */
  IF NOT pcForceMove AND cToolbarDrawDirection BEGINS "v":U 
  AND hFrame:HEIGHT < dMinHeight THEN 
    RETURN.
  
  IF NOT pcForceMove AND cToolbarDrawDirection BEGINS "h":U 
  AND hFrame:WIDTH < dMinWidth THEN 
    RETURN.

  /* Work out where to start putting buttons */
  ASSIGN
    iBeginXpxl =  iToolSeparatorPxl + (If lShowBorder THEN 2 ELSE 0)
    iBeginYpxl =  iToolSeparatorPxl + (If lShowBorder THEN 2 ELSE 0)
    .

  /* room to move or being forced to, so work out width/height of each alignment option */
  ASSIGN
    iLeftHeightPxl = 0
    iLeftWidthPxl = 0
    iCentreHeightPxl = 0
    iCentreWidthPxl = 0
    iRightHeightPxl = 0
    iRightWidthPxl = 0
    .
  
  FOR EACH ttToolbarBand 
       WHERE ttToolbarBand.ToolbarName = cLogicalObjectName
       AND   ttToolbarBand.Alignment   = "Left":U, 
      EACH btButton
        WHERE btButton.Band       = ttToolbarBand.Band
        AND   btButton.hTarget    = TARGET-PROCEDURE
      BY btButton.Position:
    /* hidden in where clause does not return any records...  */   
    IF VALID-HANDLE(btButton.hdl) AND btButton.hdl:HIDDEN = FALSE THEN 
     ASSIGN
      iLeftHeightPxl = iLeftHeightPxl + (iToolSpacingPxl + btButton.Hdl:HEIGHT-PIXELS)   
      iLeftWidthPxl  = iLeftWidthPxl + (iToolSpacingPxl + btButton.Hdl:WIDTH-PIXELS)  
      .
    
  END.
  
  FOR EACH ttToolbarBand 
       WHERE ttToolbarBand.ToolbarName = cLogicalObjectName
       AND   ttToolbarBand.Alignment = "Center":U,
      EACH btButton 
       WHERE btButton.Band       = ttToolbarBand.Band
       AND   btButton.hTarget    = TARGET-PROCEDURE
      BY btButton.Position:
        /* hidden in where clause does not return any records...  */   
    IF VALID-HANDLE(btButton.hdl) AND btButton.hdl:HIDDEN = FALSE THEN 

     ASSIGN
      iCentreHeightPxl = iCentreHeightPxl + (iToolSpacingPxl + btButton.Hdl:HEIGHT-PIXELS)   
      iCentreWidthPxl  = iCentreWidthPxl  + (iToolSpacingPxl + btButton.Hdl:WIDTH-PIXELS)  
      .
  END.

  FOR EACH ttToolbarBand 
       WHERE ttToolbarBand.ToolbarName = cLogicalObjectName
       AND   ttToolbarBand.Alignment = "Right":U,
      EACH btButton 
       WHERE btButton.Band       = ttToolbarBand.Band
       AND   btButton.hTarget    = TARGET-PROCEDURE
      BY btButton.Position:
    /* hidden in where clause does not return any records...  */   
    IF VALID-HANDLE(btButton.hdl) AND btButton.hdl:HIDDEN = FALSE THEN     
     ASSIGN
      iRightHeightPxl = iRightHeightPxl + (iToolSpacingPxl + btButton.Hdl:HEIGHT-PIXELS)   
      iRightWidthPxl  = iRightWidthPxl  + (iToolSpacingPxl + btButton.Hdl:WIDTH-PIXELS)  
      .
  END.

  /* Now work out the start column position in pixels for each section */
  ASSIGN
    iLeftBeginXpxl = iBeginXpxl
    iLeftBeginYpxl = iBeginYpxl
    .    
  ASSIGN
    iCentreBeginXpxl = ((hFrame:WIDTH-PIXELS - (iLeftWidthPxl + iCentreWidthPxl + iRightWidthPxl)) / 2) + iLeftWidthpxl - (iToolSpacingPxl + (If lShowBorder THEN 2 ELSE 0))
    iCentreBeginYpxl = ((hFrame:HEIGHT-PIXELS - (iLeftHeightPxl + iCentreHeightPxl + iRightHeightPxl)) / 2) + iLeftHeightpxl - (iToolSpacingPxl + (If lShowBorder THEN 2 ELSE 0))
    .
  ASSIGN
    iRightBeginXpxl = (hFrame:WIDTH-PIXELS - iRightWidthPxl) - (iToolSpacingPxl + (If lShowBorder THEN 2 ELSE 0))
    iRightBeginYpxl = (hFrame:HEIGHT-PIXELS - iRightHeightPxl) - (iToolSpacingPxl  + (If lShowBorder THEN 2 ELSE 0))
    .

  /* Now read each section of buttons and put in new positions, starting with new start position in each case */  
  /* left alignment */
  ASSIGN
    iBeginXpxl = iLeftBeginXpxl
    iBeginYpxl = iLeftBeginYpxl
    .
  FOR EACH ttToolbarBand 
       WHERE ttToolbarBand.ToolbarName = cLogicalObjectName
       AND   ttToolbarBand.Alignment = "Left":U,
      EACH btButton 
       WHERE btButton.Band       = ttToolbarBand.Band
       AND   btButton.hTarget    = TARGET-PROCEDURE
      BY btButton.Position:
    /* hidden in where clause does not return any records...  */   
    IF VALID-HANDLE(btButton.hdl) AND btButton.hdl:HIDDEN = FALSE THEN
    DO:
      IF cToolbarDrawDirection BEGINS "v":U THEN
        /* vertical reposition */
        ASSIGN
          btButton.hdl:Y = iBeginYpxl
          iBeginYpxl = iBeginYpxl + iToolSpacingPxl + btButton.hdl:HEIGHT-PIXELS
        NO-ERROR.           
      ELSE
        /* horizontal reposition */
        ASSIGN
          btButton.hdl:X = iBeginXpxl
          iBeginXpxl = iBeginXpxl + iToolSpacingPxl + btButton.hdl:WIDTH-PIXELS
        NO-ERROR.
    END.
  END.
  
  /* centre alignment */
  ASSIGN
    iBeginXpxl = iCentreBeginXpxl
    iBeginYpxl = iCentreBeginYpxl
    .
  FOR EACH ttToolbarBand 
       WHERE ttToolbarBand.ToolbarName = cLogicalObjectName
       AND   ttToolbarBand.Alignment = "Center":U,
      EACH btButton 
       WHERE btButton.Band       = ttToolbarBand.Band
       AND   btButton.hTarget    = TARGET-PROCEDURE
      BY btButton.Position:
   
    /* hidden in where clause does not return any records...  */   
    IF VALID-HANDLE(btButton.hdl) AND btButton.hdl:HIDDEN = FALSE THEN
    DO:
      IF cToolbarDrawDirection BEGINS "v":U THEN
        /* vertical reposition */
        ASSIGN
          btButton.hdl:Y = iBeginYpxl
          iBeginYpxl = iBeginYpxl + iToolSpacingPxl + btButton.hdl:HEIGHT-PIXELS
        NO-ERROR.     
      ELSE
       /* horizontal reposition */
        ASSIGN
          btButton.hdl:X = iBeginXpxl
          iBeginXpxl = iBeginXpxl + iToolSpacingPxl + btButton.hdl:WIDTH-PIXELS
        NO-ERROR.
      
    END.
  END.

  /* right alignment */
  ASSIGN
    iBeginXpxl = iRightBeginXpxl
    iBeginYpxl = iRightBeginYpxl
    .
  FOR EACH ttToolbarBand 
       WHERE ttToolbarBand.ToolbarName = cLogicalObjectName
       AND   ttToolbarBand.Alignment = "Right":U,
      EACH btButton 
       WHERE btButton.Band       = ttToolbarBand.Band
       AND   btButton.hTarget    = TARGET-PROCEDURE
      BY btButton.Position:
      
    /* hidden in where clause does not return any records...  */   
    IF VALID-HANDLE(btButton.hdl) AND btButton.hdl:HIDDEN = FALSE THEN
    DO:
      IF cToolbarDrawDirection BEGINS "v":U THEN
       /* vertical reposition */
        ASSIGN
          btButton.hdl:Y = iBeginYpxl
          iBeginYpxl = iBeginYpxl + iToolSpacingPxl + btButton.hdl:HEIGHT-PIXELS
        NO-ERROR.     
      
      ELSE
        /* horizontal reposition */
        ASSIGN
          btButton.hdl:X = iBeginXpxl
          iBeginXpxl = iBeginXpxl + iToolSpacingPxl + btButton.hdl:WIDTH-PIXELS
        NO-ERROR.
    END.
  END.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-onChoose) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE onChoose Procedure 
PROCEDURE onChoose :
/*------------------------------------------------------------------------------
  Purpose: Persistent trigger code for dynamic menu and toolbar objects.     
  Parameters: INPUT pcName - The Action identifier 
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcAction AS CHAR NO-UNDO.
  DEFINE VARIABLE itime AS INTEGER    NO-UNDO.
  
  DEFINE VARIABLE cType                   AS CHAR       NO-UNDO.
  DEFINE VARIABLE cOnChoose               AS CHAR       NO-UNDO.
  DEFINE VARIABLE cCall                   AS CHAR       NO-UNDO.
  DEFINE VARIABLE cObject                 AS CHAR       NO-UNDO.
  DEFINE VARIABLE hObject                 AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cParam                  AS CHAR       NO-UNDO.
  DEFINE VARIABLE cParent                 AS CHAR       NO-UNDO.
  DEFINE VARIABLE cSignature              AS CHAR       NO-UNDO.
  DEFINE VARIABLE cDataType               AS CHAR       NO-UNDO.
  DEFINE VARIABLE hContainerSource        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hContainerWindow        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lMultiInstanceActivated AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cChildDataKey           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hRunContainer           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cRunContainerType       AS CHARACTER  NO-UNDO.

  IF {fnarg canFindAction pcAction} THEN
  DO:
    RUN runInfo IN TARGET-PROCEDURE
       (INPUT  pcAction,
        OUTPUT cOnChoose,
        OUTPUT cParam).
    cType     = {fnarg actionType pcAction}.
    
    IF CAN-DO("RUN,LAUNCH":U,cType) THEN
      hObject   = {fnarg actionTarget pcAction}.

  END. /* if findAction */

  ELSE /* added by initCode so there's no defined action only two 
          key and text in the menu. The key is : separated and stores
          the parent <action id>:<parameter> */  
    ASSIGN
      cParent   = ENTRY(1,pcAction,":":U)
      cParam    = (IF NUM-ENTRIES(pcAction,":":U) > 1 
                   THEN ENTRY(2,pcAction,":":U)
                   ELSE "":U)
      cOnChoose = {fnarg actionOnChoose cParent}  
      hObject   = {fnarg actionTarget cParent}
      cType     = "RUN":U.  
 
  cCall = ENTRY(1,cOnChoose).

  CASE cType:
      WHEN "LAUNCH":U THEN
      DO:
        {get ContainerSource hContainerSource}.
        IF VALID-HANDLE(hContainerSource) THEN
          {get MultiInstanceActivated lMultiInstanceActivated hContainerSource}.
        {get Window hContainerWindow}.
        IF VALID-HANDLE(hObject) THEN
          {get ChildDataKey cChildDataKey hObject}.

        IF VALID-HANDLE(gshSessionManager) THEN
          RUN launchContainer IN gshSessionManager 
                   (/* This will be resolved into logical and physical parts by launchContainer() */
                    INPUT  {fnarg actionLogicalObjectName pcAction},
                    INPUT  "":U,
                    INPUT  "":U,
                    INPUT  NOT lMultiInstanceActivated,
                    INPUT  "":U,
                    INPUT  cChildDataKey,
                    INPUT  {fnarg actionRunAttribute pcAction},
                    INPUT  "":U, /* container mode */
                    INPUT  hContainerWindow,
                    INPUT  hContainerSource,
                    INPUT  hObject,
                    OUTPUT hRunContainer,
                    OUTPUT cRunContainerType).        
      END.      /* launch */

      WHEN "PUBLISH":U THEN
      DO:
        IF cParam = "":U THEN
          PUBLISH cCall FROM TARGET-PROCEDURE.  
        ELSE
          PUBLISH cCall FROM TARGET-PROCEDURE (cParam).  
      END.
      WHEN "RUN":U THEN
      DO:    
        /* Currently we just give default errors for invalid handles  */
        IF cParam = "":U THEN
          RUN VALUE(cCall) IN hObject.   
        
        ELSE DO:
          cSignature = {fnarg Signature cCall hObject}.
          
          IF cSignature <> "":U THEN
          DO:
            ASSIGN
              cDataType = ENTRY(3,cSignature)
              cDataType = ENTRY(NUM-ENTRIES(cDataType," ":U),cDataType," ":U).      
            CASE cDataType:
              WHEN "CHARACTER":U THEN
                RUN VALUE(cCall) IN hObject (cParam).   
              WHEN "INTEGER":U THEN
                RUN VALUE(cCall) IN hObject (INT(cParam)).   
              WHEN "DECIMAL":U THEN
                RUN VALUE(cCall) IN hObject (DEC(cParam)).   
              WHEN "LOGICAL":U THEN
                RUN VALUE(cCall) IN hObject(CAN-DO("YES,TRUE":U,cParam)).   
              WHEN "HANDLE":U THEN
                RUN VALUE(cCall) IN hObject(WIDGET-HANDLE(cParam)).
            END CASE. /* datatype */
          END. /* signature  <> '' */
        END. /* else (param) */
      END. /* when RUN */
  END CASE.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-onMenuDrop) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE onMenuDrop Procedure 
PROCEDURE onMenuDrop :
/*------------------------------------------------------------------------------
  Purpose:  Logic to execute when a sub-menu is "dropped"    
  Parameters: INPUT pcAction  - The action's unique identifier.  
  Notes:    added as a persistent trigger when the sub-menu is created     
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcAction AS CHAR NO-UNDO.
  
  DEFINE BUFFER btBandInstance FOR tBandInstance. 
  DEFINE BUFFER btMenu FOR tMenu. 

  DEFINE VARIABLE lUseRepository  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cBand           AS CHARACTER  NO-UNDO.
 
 
  {get UseRepository lUseRepository}.
  IF lUseRepository THEN
  DO:
     IF {fnarg actionInitCode pcAction} > "" THEN 
     DO:
        DYNAMIC-FUNCTION("assignActionRefresh" IN TARGET-PROCEDURE, pcAction, YES).
        {fnarg buildMenu pcAction}.
     END.
        
    IF pcAction = xcWindowBand THEN
      {fnarg windowDropdownList pcAction}.
  END.
  ELSE
    {fnarg buildMenu pcAction}.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-onValueChanged) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE onValueChanged Procedure 
PROCEDURE onValueChanged :
/*------------------------------------------------------------------------------
  Purpose :   Persistent trigger for toggle menu-items     
  Parameters: PcAction - Name of action  
  Notes       Added as a persistent trigger when the sub-menu is created.
              Currently we support only logical properties.  
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcAction AS CHAR NO-UNDO.
  
  DEFINE VARIABLE cOnChoose  AS CHAR   NO-UNDO.
  DEFINE VARIABLE hObject    AS HANDLE NO-UNDO.
  
  ASSIGN
    cOnChoose = "set":U + {fnarg actionOnChoose pcAction}.
    hObject = {fnarg actionTarget pcAction}. 
  
  IF VALID-HANDLE(hObject) THEN
     DYNAMIC-FUNCTION(cOnChoose IN hObject, SELF:CHECKED).         

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-preloadToolbar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE preloadToolbar Procedure 
PROCEDURE preloadToolbar :
/*------------------------------------------------------------------------------
  Purpose:     In a Dynamics environment, this API is run to pre-cache all the 
               toolbar and object bands for a container in one Appserver hit.  
               By the time the toolbars are constructed, their information is in 
               the cache already.
  Parameters:  <none>
  Notes:       The toolbars extracted depend on how the container was extracted
               from the repository.  If the whole container was extracted, all
               toolbars on the container will be cached.  If only certain pages
               were extracted, only the toolbars on those pages will be extracted.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcToolbarList    AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER pcObjectList     AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cUIBmode      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lDelete       AS LOGICAL    NO-UNDO.
DEFINE VARIABLE iCnt          AS INTEGER    NO-UNDO.
DEFINE VARIABLE cObjectName   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cRunAttribute AS CHARACTER  NO-UNDO.

/* If we got a list of toolbars from the container, remove any toolbars already cached */
IF pcToolbarList > "":U THEN 
DO:
    /* Remove any toolbars in the cache from the toolbar list */
    DO iCnt = 1 TO NUM-ENTRIES(pcToolbarList):
        IF CAN-FIND(FIRST ttToolbarBand
                    WHERE ttToolbarBand.Toolbar = ENTRY(iCnt, pcToolbarList)) THEN
            ASSIGN ENTRY(iCnt, pcToolbarList) = "":U.
    END.
    ASSIGN pcToolbarList = TRIM(pcToolbarList, ",":U).
END.

/* Work out which object bands we need from the repository. */
IF pcObjectList > "":U THEN 
DO:
    /* Remove any objects already cached from the list */
    DO iCnt = 1 TO NUM-ENTRIES(pcObjectList):
      ASSIGN
        cObjectName   = ENTRY(iCnt, pcObjectList)
        cRunAttribute = (IF NUM-ENTRIES(cObjectName,';':U) > 1 
                         THEN ENTRY(2,cObjectName,';':U)
                         ELSE '':U)
        cObjectName   = ENTRY(1,cObjectName,';':U).

        IF CAN-FIND(FIRST ttObjectBand
                    WHERE ttObjectBand.ObjectName   = cObjectName 
                    AND   ttObjectBand.RunAttribute = cRunAttribute) THEN
            ASSIGN ENTRY(iCnt, pcObjectList) = "":U.
    END.
    ASSIGN pcObjectList = TRIM(pcObjectList, ",":U).
END.

/* If any toolbars or objects not have been cached then load the toolbarbands */
IF  pcToolbarList > "":U OR pcObjectList > "":U THEN
  /* Extract bands and actions from the repository. */
  RUN loadToolbarBands IN TARGET-PROCEDURE (pcToolbarList,
                                            pcObjectList).


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
  Notes:       Because some states may be published from different links
               the source-procedure is always checked.
               This means that this only will work when run/published from 
               the appropriate target !!!
         NB!   We do check the special getTargetProcedure in order to identify 
               the real NavigationTarget since SBO's uses a RUN. 
               This MUST NOT be used to identify TableioTargets. 
               As a TableioSource may set this before a call that may end up 
               here. So a parent may do addRow and set this global property, 
               which then will point to that parent also when children calls 
               this as part of that add.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcState AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE hNavTarget     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hIOTarget      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hSource        AS HANDLE    NO-UNDO.

  /* Is this an active Tableio state? */
  hIOTarget = {fnarg activeTarget 'TableIO':U}.    
  IF hIOTarget = SOURCE-PROCEDURE THEN
    RUN resetTableio IN TARGET-PROCEDURE.
  
  ELSE DO:
    hSource = SOURCE-PROCEDURE.
    /* Is this a NavigationTarget state? */
    hNavTarget = {fnarg activeTarget 'Navigation':U}.
    /* Check if this is a RUN from an SBO where the super is source, so we 
       need to get the target from a special function. */  
    IF hNavTarget <> hSource THEN
      {get TargetProcedure hSource SOURCE-PROCEDURE} NO-ERROR.
    
    IF hNavTarget = hSource THEN
      RUN resetNavigation IN TARGET-PROCEDURE.
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rebuildMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rebuildMenu Procedure 
PROCEDURE rebuildMenu :
/*------------------------------------------------------------------------------
  Purpose:   rebuild a menu after it has been removed or not built on init    
  Parameters:  <none>
  Notes:     The toolbar manages this based on its own RemoveMenuOnHide property, 
             but it is also added as one of the  ContainerSourceEvents and 
             published from container based on its RemoveMenuOnHide property.  
------------------------------------------------------------------------------*/
  IF {fn constructMenu} THEN
    RUN resetAllTargetActions IN TARGET-PROCEDURE.
 END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removeMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE removeMenu Procedure 
PROCEDURE removeMenu :
/*------------------------------------------------------------------------------
  Purpose:   Remove this object's menu from the menubar  
Parameters:  <none>
  Notes:     The toolbar manages this based on its own RemoveMenuOnHide property, 
             but it is also added as one of the  ContainerSourceEvents and 
             published from container based on its RemoveMenuOnHide property.  
------------------------------------------------------------------------------*/
  DEFINE BUFFER btBandInstance FOR tBandInstance.

  FIND btBandInstance WHERE btBandInstance.MenuName = '':U
                      AND   btBandInstance.hTarget  = TARGET-PROCEDURE NO-ERROR.
   
  IF AVAIL btBandInstance THEN
  DO:
    {fnarg removeMenuBand btBandInstance.Band}.
     
    /* we currently don't rebuild the upper level here as it gives extra flashing
       for very little benefit..   
        We currently assume that rebuildMenu or constructMenu will be called 
        from another object if menus are removed and the window stays, in which
        case this is unnecessary 
        
      There are two reasons why this could be useful
      - If this toolbar rearranged the top level and pushed a common item 
        after its items, this call would put that item back to the place it had.
        (very academic... ) 
      - Under certain circumstances unremovable rules ends up on the top
        of a submenu, this would have been cleaned up by this call.
        (core bug or limitation... )
     {get Menubarhandle hMenubar}.                          

     {fnarg buildMenuBand hMenubar,btBandInstance.Menukey}. 
     */
     DELETE btBandInstance.
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-repositionObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionObject Procedure 
PROCEDURE repositionObject :
/*------------------------------------------------------------------------------
  Purpose: Override default reposition.
           Because the coordinates is NOT assigned in DESIGN.
           The position only changes through direct manipulation and not 
           when dropped in the contaner. 
  Parameters:  pdRow 
               pdCol 
  Notes:    toolbar.i defines EXCLUDE-repositionObject (for smart.i)     
------------------------------------------------------------------------------*/
 DEFINE INPUT PARAMETER pdRow AS DECIMAL NO-UNDO.
 DEFINE INPUT PARAMETER pdCol AS DECIMAL NO-UNDO.

 DEFINE VARIABLE cUIBMode              AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cToolbarDrawDirection AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lToolbarAutosize      AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE hFrame                AS HANDLE     NO-UNDO.

 {get UIBMode cUIBMode}.
 /* Keep the default 1 1  position when dropped from Appbuilder's Palette */
 IF cUIBMode <> "DESIGN":U OR LAST-EVENT:FUNCTION <> "MOUSE-SELECT-CLICK":U THEN
 DO:
   &SCOPED-DEFINE xp-assign
   {get ContainerHandle hFrame}
   {get ToolbarAutoSize      lToolbarAutoSize}
   {get ToolbarDrawDirection cToolbarDrawDirection}. 
   &UNDEFINE xp-assign

   /* ignore col if autosize horizontal and row id autosize vertical 
      repositionObject handles this */
   ASSIGN 
     hFrame:ROW = pdRow WHEN NOT lToolbarAutoSize 
                          OR NOT cToolbarDrawDirection BEGINS 'v':U  
     hFrame:COL = pdCol WHEN NOT lToolbarAutoSize 
                          OR cToolbarDrawDirection BEGINS 'v':U NO-ERROR. 
 END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resetAllTargetActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetAllTargetActions Procedure 
PROCEDURE resetAllTargetActions :
/*------------------------------------------------------------------------------
  Purpose: Refresh all actions for all links        
  Parameters:  <none>
  Notes:   Called from initializeObject and rebuildMenu     
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cLinkTargetNames AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLink            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cLink            AS CHARACTER  NO-UNDO.

  {get LinkTargetNames cLinkTargetNames}. 
   
  DO iLink = 1 TO NUM-ENTRIES(cLinkTargetNames):
    ASSIGN 
      cLink = ENTRY(iLink,cLinkTargetNames)
      cLink = ENTRY(1,cLink,'-':U).  
    RUN VALUE('reset':U + cLink) IN TARGET-PROCEDURE NO-ERROR.
    /* if reset<LinkType> doesn't exist run the generic reset */
    IF ERROR-STATUS:ERROR THEN
      RUN resetTargetActions IN TARGET-PROCEDURE (cLink).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resetCommit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetCommit Procedure 
PROCEDURE resetCommit :
/*------------------------------------------------------------------------------
  Purpose:   Reset all actions for the commit link   
  Parameters:  <none>
  Notes:     Defined as CommitTargetEvents so that a commit-target can publish the 
             event to reset/refresh its actions.    
------------------------------------------------------------------------------*/
  RUN resetTargetActions IN TARGET-PROCEDURE ('commit':U).
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resetContainerToolbar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetContainerToolbar Procedure 
PROCEDURE resetContainerToolbar :
/*------------------------------------------------------------------------------
  Purpose: reset containertoolbar actions    
  Parameters:  <none>
  Notes:    Defined as ContainerToolbarTargetEvents so that a ContainerToolbar-target
            can publish the event to reset/refresh its actions.
------------------------------------------------------------------------------*/
   RUN resetTargetActions IN TARGET-PROCEDURE ('ContainerToolbar':U).
   RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resetNavigation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetNavigation Procedure 
PROCEDURE resetNavigation :
/*------------------------------------------------------------------------------
  Purpose:    Reset all navigation actions    
  Parameters:  <none>
  Notes:      Defined as NavigationTargetEvents so that a navigation-target can 
              publish the event to reset/refresh its actions.    
------------------------------------------------------------------------------*/
  RUN resetTargetActions IN TARGET-PROCEDURE ('Navigation':U).
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resetTableio) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetTableio Procedure 
PROCEDURE resetTableio :
/*------------------------------------------------------------------------------
  Purpose:    Reset all tableio actions    
  Parameters:  <none>
  Notes:      Defined as TableioTargetEvents so that a tableio-target can publish 
              the event to reset/refresh its actions.    
              
            - Can probably replace ALL other events except 
              -  linkChanged('inactive').
------------------------------------------------------------------------------*/
  RUN resetTargetActions IN TARGET-PROCEDURE ('Tableio':U).

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resetTargetActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetTargetActions Procedure 
PROCEDURE resetTargetActions :
/*------------------------------------------------------------------------------
  Purpose:  reset the actions of a specific link (disable, hide, image, checked)      
  Parameters: pcLink - Link type 
  Notes:    Called from all reset<Link> methods.   
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
 DEFINE VARIABLE cLabelActions     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cCaptionActions   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cTooltipActions   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lInitialized      AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE cLinkActions      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hTarget           AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cLinkName         AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cAction           AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iAction           AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cImage            AS CHARACTER  NO-UNDO.
 
 DEFINE BUFFER btButton FOR tButton.
 DEFINE BUFFER btMenu FOR tMenu.
     
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
 
 cLinkName = pcLink + '-target':U. 
  
 FOR EACH btButton WHERE btButton.hTarget = TARGET-PROCEDURE
                   AND   btButton.Link    = cLinkName:
   IF VALID-HANDLE(btButton.hdl) THEN
   DO:
     ASSIGN
       cEnableActions = cEnableActions 
                        + (IF btButton.hdl:SENSITIVE 
                           THEN ',':U + btButton.Name
                           ELSE '':U)
       cDisableActions = cDisableActions 
                        + (IF NOT btButton.hdl:SENSITIVE 
                           THEN ',':U + btButton.Name
                           ELSE '':U)
       cViewActions = cViewActions 
                         + (IF NOT btButton.hdl:HIDDEN 
                            THEN ',':U + btButton.Name
                            ELSE '':U)
       cHideActions = cHideActions 
                         + (IF btButton.hdl:HIDDEN 
                            THEN ',':U + btButton.Name
                            ELSE '':U)
       cImage1Actions = cImage1Actions 
                         + (IF btButton.imageAlt = FALSE
                            THEN ',':U + btButton.Name
                            ELSE '':U)
       cImage2Actions = cImage2Actions 
                           + (IF btButton.imageAlt = TRUE
                              THEN ',':U + btButton.Name
                              ELSE '':U)
       cLabelActions  = cLabelActions 
                          + (IF btButton.LabelSubst   
                             THEN ',':U + btButton.Name
                             ELSE '':U)
       cTooltipActions = cTooltipActions 
                          + (IF btButton.TooltipSubst  
                             THEN ',':U + btButton.Name
                             ELSE '':U)
       .
   END.
  
 END.
 
 FOR EACH btMenu WHERE btMenu.hTarget = TARGET-PROCEDURE
                 AND   btMenu.Link     = cLinkName:
   IF VALID-HANDLE(btMenu.hdl) THEN
   DO:
     /* We must allow for discrepancies as menus may have been rebuilt
        so we add to this list also if already in disabledActions  */
     IF NOT CAN-DO(cEnableActions,btMenu.Name) THEN
       ASSIGN
         cEnableActions = cEnableActions 
                        + (IF btMenu.hdl:SENSITIVE 
                           THEN ',':U + btMenu.Name
                           ELSE '':U).
      
     /* We must allow for discrepancies as menus may have been rebuilt
        so we add to this list also if already in enabledActions  */
     IF NOT CAN-DO(cDisableActions,btMenu.Name) THEN
         cDisableActions = cDisableActions 
                         + (IF NOT btMenu.hdl:SENSITIVE 
                            THEN ',':U + btMenu.Name
                            ELSE '':U)      
         .
     IF CAN-QUERY(btMenu.Hdl,'TOGGLE-BOX':U) AND btMenu.hdl:TOGGLE-BOX THEN
       ASSIGN
         cCheckedActions = cCheckedActions 
                           + (IF btMenu.hdl:CHECKED 
                              THEN ',':U + btMenu.Name
                              ELSE '':U)
         cUncheckedActions = cUnCheckedActions 
                           + (IF NOT btMenu.hdl:CHECKED 
                              THEN ',':U + btMenu.Name
                              ELSE '':U).
     cCaptionActions = cCaptionActions 
                     + (IF btMenu.CaptionSubst  
                        THEN ',':U + btMenu.Name
                        ELSE '':U).
   END.
   IF NOT CAN-DO(cViewActions + cHideActions,btMenu.Name) THEN
     ASSIGN
       cViewActions = cViewActions 
                         + (IF VALID-HANDLE(btMenu.hdl) 
                            THEN ',':U + btMenu.Name
                            ELSE '':U)
       cHideActions = cHideActions 
                         + (IF NOT VALID-HANDLE(btMenu.hdl) 
                            THEN ',':U + btMenu.Name
                            ELSE '':U).

 END.
 
 ASSIGN 
   cEnableActions    = TRIM(cEnableActions,',':U)
   cDisableActions   = TRIM(cDisableActions,',':U)
   cViewActions      = TRIM(cViewActions,',':U)
   cHideActions      = TRIM(cHideActions,',':U)
   cImage1Actions    = TRIM(cImage1Actions,',':U)
   cImage2Actions    = TRIM(cImage2Actions,',':U)
   cUncheckedActions = TRIM(cUncheckedActions,',':U)
   cCheckedActions   = TRIM(cCheckedActions,',':U)
   cLabelActions     = TRIM(cLabelActions)
   cCaptionActions    = TRIM(cCaptionActions)
   cTooltipActions   = TRIM(cTooltipActions)
   .
 
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
 
 DO iAction = 1 TO NUM-ENTRIES(cUncheckedactions):
   cAction = ENTRY(iAction,cUncheckedactions).
   FIND btMenu WHERE btMenu.Name    = cAction
                AND  btMenu.hTarget = TARGET-PROCEDURE NO-ERROR.
   IF AVAIL btMenu AND VALID-HANDLE(btMenu.hdl) THEN
      btMenu.hdl:CHECKED = FALSE.

 END.
 DO iAction = 1 TO NUM-ENTRIES(cCheckedactions):
   cAction = ENTRY(iAction,cCheckedactions).
   FIND btMenu WHERE btMenu.Name    = cAction
                AND  btMenu.hTarget = TARGET-PROCEDURE NO-ERROR.
   IF AVAIL btMenu AND VALID-HANDLE(btMenu.hdl) THEN
      btMenu.hdl:CHECKED = TRUE.

 END.
 
 DO iAction = 1 TO NUM-ENTRIES(cImage1actions):
   cAction = ENTRY(iAction,cImage1actions).
   FIND btButton WHERE btButton.Name    = cAction
                 AND   btButton.hTarget = TARGET-PROCEDURE NO-ERROR.

   IF AVAIL btButton THEN
   DO:
     cImage = DYNAMIC-FUNCTION('imageName':U IN TARGET-PROCEDURE,
                                     cAction,
                                     1).
     IF cImage > "" AND VALID-HANDLE(btButton.hdl)  THEN                                
         loadImage(INPUT btButton.hdl, INPUT cImage).
     btButton.imageALt = FALSE.
   END.
 END.
 DO iAction = 1 TO NUM-ENTRIES(cImage2actions):
   cAction = ENTRY(iAction,cImage2actions).
   
   FIND btButton WHERE btButton.Name    = cAction
                 AND   btButton.hTarget = TARGET-PROCEDURE NO-ERROR.
   
   IF AVAIL btButton THEN
   DO:
     cImage = DYNAMIC-FUNCTION('imageName':U IN TARGET-PROCEDURE,
                                     cAction,
                                     2).
      IF cImage > "" AND VALID-HANDLE(btButton.hdl) THEN                                
        loadImage(INPUT btButton.hdl, INPUT cImage). 
     btButton.imageALt = TRUE.
   END.
 END.                                
 
 DO iAction = 1 TO NUM-ENTRIES(cLabelActions):
   cAction = ENTRY(iAction,cLabelActions).
   FIND btButton WHERE btButton.Name    = cAction
                 AND   btButton.hTarget = TARGET-PROCEDURE NO-ERROR.

   IF AVAIL btButton AND VALID-HANDLE(btButton.hdl) THEN
     btButton.hdl:LABEL = {fnarg actionLabel btButton.Name}.
 END.                                  
   
 DO iAction = 1 TO NUM-ENTRIES(cTooltipActions):
   cAction = ENTRY(iAction,cTooltipActions).
   FIND btButton WHERE btButton.Name    = cAction
                 AND   btButton.hTarget = TARGET-PROCEDURE NO-ERROR.

   IF AVAIL btButton AND VALID-HANDLE(btButton.hdl) THEN
     btButton.hdl:TOOLTIP = {fnarg actionTooltip btButton.Name}.
 END.
   
 DO iAction = 1 TO NUM-ENTRIES(cCaptionActions):
   cAction = ENTRY(iAction,cCaptionActions).
   FIND btMenu   WHERE btMenu.Name    = cAction
                 AND   btMenu.hTarget = TARGET-PROCEDURE NO-ERROR.

   IF AVAIL btMenu AND VALID-HANDLE(btMenu.hdl) THEN
     btMenu.hdl:LABEL = {fnarg actionCaption btMenu.Name}.
 END.
 
 IF cEnableActions <> '':U THEN
   {fnarg EnableActions cEnableActions}.
 
 IF cDisableActions <> '':U THEN
    {fnarg disableActions cDisableActions}.

 IF cViewActions <> '':U OR cHideActions <> '':U THEN
   RUN viewHideActions IN TARGET-PROCEDURE (cViewActions,cHideactions).

 RETURN.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resetToolbar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetToolbar Procedure 
PROCEDURE resetToolbar :
/*------------------------------------------------------------------------------
   Purpose:  reset toolbar actions    
Parameters:  <none>
     Notes:  Defined as ToolbarTargetEvents so that a toolbar-target can publish 
             the event to reset/refresh its actions.
------------------------------------------------------------------------------*/
  RUN resetTargetActions IN TARGET-PROCEDURE ('Toolbar':U).
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resizeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject Procedure 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose: Overrides the size after a resize to ensure width is big enough to
           fit all buttons on, and that the height is not accidentally changed.
           This is a design time event that sorts out things when the object is
           manually sized in the Appbuilder.
  Parameters: 
           pd_height AS DECIMAL - the desired height (in rows)
           pd_width  AS DECIMAL - the desired width (in columns)
    Notes: Used internally. Calls to resizeObject are generated by the
           AppBuilder in adm-create-objects for objects which implement it.
           Having a resizeObject procedure is also the signal to the AppBuilder
           to allow the object to be resized at design time.
------------------------------------------------------------------------------*/  
  DEFINE INPUT PARAMETER pdHeight       AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER pdWidth        AS DECIMAL NO-UNDO.
  DEFINE VARIABLE hFrame                AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hWindow               AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hContainerSource      AS HANDLE  NO-UNDO.
  DEFINE VARIABLE dMinWidth      AS DECIMAL NO-UNDO.
  DEFINE VARIABLE dMinHeight     AS DECIMAL NO-UNDO.
  DEFINE VARIABLE hRectangle            AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRectangle2           AS HANDLE  NO-UNDO.  
  DEFINE VARIABLE lShowBorder           AS LOGICAL NO-UNDO.
  DEFINE VARIABLE iDummy                AS INTEGER NO-UNDO.
  DEFINE VARIABLE lToolbarAutoSize      AS LOGICAL NO-UNDO.
  DEFINE VARIABLE cToolbarDrawDirection AS CHAR    NO-UNDO.
  DEFINE VARIABLE hPopupFrame           AS HANDLE  NO-UNDO.
  DEFINE VARIABLE cUIBMode              AS CHAR    NO-UNDO.
  DEFINE VARIABLE lPreviouslyHidden     AS LOGICAL NO-UNDO.
  DEFINE VARIABLE lWindowResize         AS LOGICAL NO-UNDO.
  DEFINE VARIABLE cFrame                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hWindowFrame          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hParent               AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFolder               AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iPage                 AS INTEGER    NO-UNDO.
  DEFINE VARIABLE dRow                  AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dCol                  AS DECIMAL    NO-UNDO.
  
  &SCOPED-DEFINE xp-assign
  {get UIBMode              cUIBmode}
  {get ContainerHandle      hFrame}
  {get ContainerSource      hContainerSource}
  {get BoxRectangle         hRectangle}
  {get BoxRectangle2        hRectangle2}
  {get ShowBorder           lShowBorder}
  {get ToolbarAutoSize      lToolbarAutoSize}
  {get ToolbarDrawDirection cToolbarDrawDirection}
  {get MinWidth             dMinWidth}
  {get MinHeight            dMinHeight}
  {get Window               hWindow}
  .
  &UNDEFINE xp-assign

  hFrame:SCROLLABLE = FALSE.                                               
  lPreviouslyHidden = hFrame:HIDDEN.                                                           
  hFrame:HIDDEN = TRUE.
 
  /* If autosize turned on - always resize according to the window or folder size */  
  IF lToolbarAutoSize THEN    
  DO: 
    IF VALID-HANDLE(hContainerSource) THEN
    DO:
      /* Set height or width from container. 
         we check pageSource for inner values later, but the page device 
         may not exist or have these functions so we must always set values
         here first */
      IF cToolbarDrawDirection BEGINS "v":U THEN
      DO:
        dRow  = 1.
        {get Height pdHeight hContainerSource}.
      END.
      ELSE
      DO:
        dCol = 1.
        {get Width pdWidth hContainerSource}.
      END.
      iPage = {fnarg targetPage TARGET-PROCEDURE hContainerSource}.
      IF iPage > 0 THEN 
      DO:
        {get PageSource hFolder hContainerSource}.
        IF VALID-HANDLE(hFolder) THEN
        DO:
          IF cToolbarDrawDirection BEGINS "v":U THEN
            ASSIGN
              dRow      = {fn getInnerRow hFolder} 
              pdHeight  = {fn getInnerHeight hFolder} NO-ERROR.
          ELSE
            ASSIGN
              dCol      = {fn getInnerCol hFolder} 
              pdWidth   = {fn getInnerWidth hFolder} NO-ERROR.
        END.
      END.
    END. 
    ELSE DO:
      IF cToolbarDrawDirection BEGINS "v":U THEN
        ASSIGN
          dRow     = 1
          pdHeight = hWindow:HEIGHT.
      ELSE
        ASSIGN
          dCol    = 1
          pdWidth = hWindow:WIDTH.
    END.

    IF cToolbarDrawDirection BEGINS "v":U THEN
      ASSIGN
          hFrame:ROW         = dRow
          hFrame:HEIGHT      = pdHeight
        NO-ERROR.
    ELSE
      ASSIGN
          hframe:COL        = dCol
          hFrame:WIDTH      = pdWidth 
        NO-ERROR.          
    
  END.
  ELSE /* Ensure that the frame is sized to stored values on open 
          otherwise the max logic further down would use the frame's initial        
          size */          
          
    ASSIGN 
      hFrame:HEIGHT      = pdHeight WHEN dMinHeight < pdHeight
      hFrame:WIDTH       = pdWidth WHEN dMinWidth < pdWidth. 
  
  IF dMinHeight > 0 AND dMinHeight < (SESSION:HEIGHT - 1) AND
     dMinWidth > 0 AND dMinWidth < (SESSION:WIDTH - 1) AND
     (hWindow:WIDTH < dMinWidth OR hWindow:HEIGHT < dMinHeight) THEN
  DO:
    IF hWindow:HEIGHT < dMinHeight THEN
      ASSIGN
        hWindow:HEIGHT     = dMinHeight
        hWindow:MIN-HEIGHT = dMinHeight NO-ERROR.
    
    IF hWindow:WIDTH < dMinWidth THEN
      ASSIGN
        hWindow:WIDTH     = dMinWidth
        hWindow:MIN-WIDTH = dMinWidth NO-ERROR.
    RUN resizeWindow IN hContainerSource NO-ERROR.
    lWindowResize = TRUE. /* flag for design mode further down  */
  END.
    
  /* Ensure frame height / width is not smaller than minimum allowed to fit buttons, plus reset to 1 column/row
     depending on horizontal / vertical alignment
     Also ensure that height/width is not changed on horizontal/vertical */
  IF cToolbarDrawDirection BEGINS "v":U THEN
    ASSIGN
      hFrame:WIDTH       = dMinWidth
      hFrame:HEIGHT      = MAX(hFrame:HEIGHT,dMinHeight) 
      hRectangle:HEIGHT  = hFrame:HEIGHT WHEN VALID-HANDLE(hRectangle)
      hRectangle2:HEIGHT = hFrame:HEIGHT WHEN VALID-HANDLE(hRectangle2)
    NO-ERROR.
  ELSE 
    ASSIGN
      hFrame:HEIGHT      = dMinHeight
      hFrame:WIDTH       = MAX(hFrame:WIDTH,dMinWidth) 
      hRectangle:WIDTH   = hFrame:WIDTH WHEN VALID-HANDLE(hRectangle)
      hRectangle2:WIDTH  = hFrame:WIDTH WHEN VALID-HANDLE(hRectangle2)
    NO-ERROR.
  /* reposition buttons according to new size of frame */
  RUN moveButtons IN TARGET-PROCEDURE (INPUT NO).

  /* bring ventilator back onto top */
  IF cUIBMode BEGINS "DESIGN":U THEN 
  DO:
    /* If the window was resized the frame is not resized accordingly 
       in Design mode as there is no persistent ContainerSource */
    IF lWindowResize THEN
    DO:
      RUN adeuib/_uibinfo.p (?,'frame ?':U,'handle':U, OUTPUT cFrame).
     
      hWindowFrame = WIDGET-HANDLE(cFrame).  

      hWindowFrame:WIDTH  = MAX(hWindow:WIDTH,hWindowFrame:WIDTH).
      hWindowFrame:HEIGHT = MAX(hWindow:HEIGHT,hWindowFrame:HEIGHT).
    END.

    /* Find the ventilator frame */
    hPopupFrame = hFrame:FIRST-CHILD.
    hPopupFrame = hPopupframe:FIRST-CHILD.
    IF VALID-HANDLE(hPopupFrame) THEN 
      hPopupframe:MOVE-TO-TOP().
    
   IF program-name(2) <> 'adeuib/_setsize.p':u AND glInitComplete THEN
    DO:
      APPLY "end-resize":U TO hFrame.
      APPLY "end-resize":U TO hWindow. 
    END.
    
  END.

  hFrame:HIDDEN = lPreviouslyHidden NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rowObjectState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowObjectState Procedure 
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
  
  RUN resetCommit IN TARGET-PROCEDURE.
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ruleStateChanges) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ruleStateChanges Procedure 
PROCEDURE ruleStateChanges :
/*------------------------------------------------------------------------------
   Purpose: Check rules for all passed actions
Parameters:  pcLink - link name
             phTarget
     Notes:  The purpose is to retrieve only the actions that have changed
             so the OUTPUT values must be found in the opposite INPUT list.
           - The performance of this is extremely important since it is called 
             for almost any event in order to reset the toolbar states correctly 
             so the Hide, Enable and ImageAlternate rules are read from the 
             temp-table and not through the API. 
           - The exception is the case where the corresponding action* function 
             is overidden in an instance. This allows for example the panel 
             to have a different hide rule than the toolbar, but an override of 
             these action* functions in a custom super-procedure will have no 
             effect. 
  IMPORTANT: This procedure is duplicated in the Panel super proc panel.p         
------------------------------------------------------------------------------*/  
  DEFINE INPUT PARAMETER pcLink   AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER phTarget AS HANDLE     NO-UNDO.
  
  DEFINE INPUT-OUTPUT PARAMETER piocEnable    AS CHARACTER  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER piocDisable   AS CHARACTER  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER piocVisible   AS CHARACTER  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER piocHidden    AS CHARACTER  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER piocImage1    AS CHARACTER  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER piocImage2    AS CHARACTER  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER piocFalse     AS CHARACTER  NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER piocTrue      AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE lok      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cEnable  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisable AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cHidden  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cVisible AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cImage1  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cImage2  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTrue    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFalse   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iFunc    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hFunc    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuffer  AS HANDLE     NO-UNDO.
  
  DEFINE VARIABLE lEnablerule AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lHiderule   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lImagerule  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cEnablerule AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cHiderule   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cImagerule  AS CHARACTER  NO-UNDO.

  DEFINE BUFFER bttAction FOR ttAction. 

  hBuffer = DYNAMIC-FUNCTION('linkRuleBuffer':U IN TARGET-PROCEDURE,
                              pcLink,
                              phTarget).
  
  IF NOT VALID-HANDLE(hBuffer) THEN
     RETURN.
  
  /* Check if any of the rules have local overrides in an object in which case 
     we read the rules from the API instead of from the temp-table.
     The reason for this logic is that we do not want the overhead of the 
     function call unless it really is needed.  */

  ASSIGN
    lEnableRule = CAN-DO(TARGET-PROCEDURE:INTERNAL-ENTRIES,'actionEnableRule':u)
    lHideRule   = CAN-DO(TARGET-PROCEDURE:INTERNAL-ENTRIES,'actionHideRule':u)
    lImageRule  = CAN-DO(TARGET-PROCEDURE:INTERNAL-ENTRIES,'actionImageAlternateRule':u).

  DO iFunc = 1 TO hBuffer:NUM-FIELDS.
    hFunc = hBuffer:BUFFER-FIELD(iFunc).
    ghTargetProcedure = TARGET-PROCEDURE. 
    hFunc:BUFFER-VALUE = DYNAMIC-FUNCTION(hFunc:NAME IN phTarget) NO-ERROR.
  END.
  ghTargetProcedure = ?.

  FOR EACH bttAction WHERE bttAction.link = pcLink :
                     /*
                     AND  (bttAction.EnableRule <> '':U
                           OR 
                           bttAction.HideRule <> '':U 
                           OR 
                           bttAction.ImageAlternateRule <> '':U
                           OR 
                           bttAction.Type = 'PROPERTY':U)
                           */
    
    cEnableRule  = IF NOT lEnableRule 
                   THEN bttAction.EnableRule
                   ELSE {fnarg actionEnableRule bttAction.Action}. 
    
      
    IF cEnableRule = '':U OR DYNAMIC-FUNCTION('checkRule':U IN TARGET-PROCEDURE,
                                              cEnableRule,
                         /* If the rule is overidden we may not have 
                            the property in the linkRulebuffer so 
                            we check the object directly 
                            (checkRule checks the type of the handle)*/ 
                                              IF NOT lEnableRule THEN hBuffer ELSE phTarget,
                                              FALSE
                                             ) THEN 
    DO:
      IF CAN-DO(piocDisable,bttAction.Action) THEN
        cEnable = cEnable + ",":U + bttAction.Action.    
    END.
    ELSE DO:
      IF CAN-DO(piocEnable,bttAction.Action) THEN
        cDisable = cDisable + ",":U + bttAction.Action. 
    END.
   
    cHideRule = IF NOT lHideRule 
                THEN bttAction.HideRule 
                ELSE {fnarg actionHideRule bttAction.Action}.

    IF cHideRule <> '':U THEN 
    DO:
      IF DYNAMIC-FUNCTION('checkRule':U IN TARGET-PROCEDURE,
                          cHideRule,
                          /* if the rule is overidden we may not have 
                             the property in the linkrulebuffer so 
                             we check the object directly  
                            (checkRule checks the type of the handle)*/ 
                           IF NOT lHideRule THEN hBuffer ELSE phTarget,
                           FALSE
                         ) THEN 
      DO:
        IF CAN-DO(piocVisible,bttAction.Action) THEN
          cHidden = cHidden + ",":U + bttAction.Action. 
      END.
      ELSE DO:
        IF CAN-DO(piocHidden,bttAction.Action) THEN
          cVisible = cVisible + "," + bttAction.Action. 
      END.
    END.
    
    cImageRule = IF NOT lImageRule 
                 THEN bttAction.ImageAlternateRule
                 ELSE {fnarg actionImageAlternateRule bttAction.Action}.                       

    IF cImageRule <> '':U THEN
    DO:
      IF DYNAMIC-FUNCTION('checkRule':U IN TARGET-PROCEDURE,
                          cImageRule,
                         /* If the rule is overidden we may not have 
                            the property in the linkRulebuffer so 
                            we check the object directly 
                            (checkRule checks the type of the handle)*/ 
                          IF NOT lImageRule THEN hBuffer ELSE phTarget,                          
                          FALSE) THEN 
      DO:
        IF CAN-DO(piocImage1,bttAction.Action) THEN
          cImage2 = cImage2 + ",":U + bttAction.Action. 
      END.
      ELSE DO:
        IF CAN-DO(piocImage2,bttAction.Action) THEN
          cImage1 = cImage1 + "," + bttAction.Action. 
      END.
    END.
    
    IF bttAction.Type = 'PROPERTY':U THEN
    DO:
      IF DYNAMIC-FUNCTION('checkRule':U IN TARGET-PROCEDURE,
                          bttAction.OnChoose,
                          hBuffer,
                          FALSE) THEN 
      DO:
        IF CAN-DO(piocFalse,bttAction.Action) THEN
          cTrue = cTrue + ",":U + bttAction.Action. 
      END.
      ELSE DO:
        IF CAN-DO(piocTrue,bttAction.Action) THEN
            cFalse = cFalse + ",":U + bttAction.Action. 
      END.
    END.
  END.  /* for each bttAtction */
  
  ASSIGN
    piocEnable   = TRIM(cEnable,',':U) 
    piocDisable  = TRIM(cDisable,',':U) 
    piocVisible  = TRIM(cVisible,',':U) 
    piocHidden   = TRIM(cHidden,',':U)
    piocImage1   = TRIM(cImage1,',':U)
    piocImage2   = TRIM(cImage2,',':U)
    piocFalse    = TRIM(cFalse,',':U)
    piocTrue     = TRIM(cTrue,',':U).
 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-runInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE runInfo Procedure 
PROCEDURE runInfo :
/*------------------------------------------------------------------------------
  Purpose: Return the necessary information for RUN or PROERTY     
  Parameters: INPUT  pcAction    - Action Id where type = RUN.
              OUTPUT pohTarget    - Target handle
              OUTPUT pocProcedure - Target Procedure
  
  Notes: This encapsulates the logic to look for this info in the parent if 
         it's not defined in the action itself.        
-----------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER  pcAction AS CHAR   NO-UNDO.
   
   DEFINE OUTPUT PARAMETER pocProcedure AS CHAR   NO-UNDO.
   DEFINE OUTPUT PARAMETER pocParam     AS CHAR   NO-UNDO.

   DEFINE VARIABLE cParent        AS CHAR    NO-UNDO.
   DEFINE VARIABLE cOnChoose      AS CHAR    NO-UNDO.
   DEFINE VARIABLE lUseRepository AS LOGICAL NO-UNDO.

   cOnChoose = {fnarg actionOnChoose pcAction}.
   {get UseRepository lUseRepository}.
   
   IF lUseRepository THEN
   DO:
     ASSIGN  
       pocProcedure = cOnChoose
       pocParam = {fnarg actionParameter pcAction}. 
   END.
   ELSE
   DO:
     /* Find the procedure on the parent and use the action as input. */
     IF cOnChoose = "":U THEN
       ASSIGN
         cParent      = {fnarg actionParent pcAction}  
         pocProcedure = {fnarg actionOnChoose cParent}
         pocParam     = pcAction.
     ELSE  /* we allow harcoded parameter on the action  */ 
       ASSIGN
         pocProcedure = TRIM(ENTRY(1,cOnChoose,"(":U))
         pocParam     = IF NUM-ENTRIES(cOnChoose,"(":U) > 1 
                        THEN TRIM(ENTRY(2,cOnChoose,"(":U),"')":U)
                        ELSE "":U.
   END.

   RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setButtons) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setButtons Procedure 
PROCEDURE setButtons :
/*----------------------------------------------------------------------- 
  Purpose: DEPRECATED - enable/disable actions according to state.  
Parameters: INPUT pcPanelState - State
            - onlyRecord
            - disable-nav
            - first
            - last 
            - initial-tableio 
            - update
            - add-only
            - disable-commit 
            - enable-commit
            - enable-filter            
     Notes: Called directly or indirectly from procedures that subscribes to 
            linked objects;
            queryPosition, updateState, rowObjectState or LinkState.
         -  DEPRECATED in the sense that the toolbar disabling/enabling 
            has been replaced by rule based state management. The procedure 
            is still callable and works on the predefined set of states
            and may still be called in odd cases.                          
---------------------------------------------------------------------------*/     
 DEFINE INPUT PARAMETER pcPanelState AS CHARACTER NO-UNDO.                     
  
 DEF VAR cParam       AS CHAR NO-UNDO.
 DEF VAR cTableIoType AS CHAR NO-UNDO.
  
 {get TableIoType cTableIoType}.
  DO WITH FRAME Panel-Frame:
    CASE pcPanelState:
      WHEN 'OnlyRecord':U  THEN 
      DO:
        cParam = "Next,Prev,First,Last":U.
        {fnarg disableActions cparam}.
      END.      
      WHEN 'Disable-Nav':U  THEN 
      DO:
        cParam = "Next,Prev,First,Last":U.
        {fnarg disableActions cParam}.
      END.    
      WHEN 'first':U THEN 
      DO:
        cParam = "First,Prev":U.
        {fnarg disableActions cParam}.
        cParam = "Last,Next":U.
        {fnarg enableActions cParam}.
      END. /* first */
      WHEN 'last':U THEN 
      DO:
        cParam = "Last,Next":U.
        {fnarg disableActions cParam}.
        cParam = "First,Prev":U.
        {fnarg enableActions cParam}.
      END.
      WHEN 'NotFirstOrLast':U  THEN 
      DO:
        cParam = "Next,Prev,First,Last":U.
        {fnarg enableActions cparam}.
      END.
      WHEN 'Enable-Nav':U  THEN 
      DO:
        cParam = "Next,Prev,First,Last":U.
        {fnarg enableActions cparam}.
      END.
      WHEN 'Initial-TableIo':U  THEN 
      DO:
        cParam =  "Save,Cancel,Reset":U.
        {fnarg disableActions cParam}.
        cParam = "add,update,delete,copy":U.
        {fnarg enableActions cparam}.
      END.      
      WHEN 'Update':U  THEN 
      DO:
        cParam = "Add,Update,Delete,Copy,Cancel":U.
        {fnarg disableActions cParam}.       
        cParam = "Save,Reset".
        {fnarg enableActions cparam}.
      END.
      WHEN 'Modal-Update':U  THEN 
      DO:
        cParam = "Add,Update,Delete,Copy,Reset":U.
        {fnarg disableActions cParam}.       
        cParam = "Save,Cancel".
        {fnarg enableActions cparam}.
      END.
      WHEN 'Modal-Update-Modified':U  THEN 
      DO:
        cParam = "Add,Update,Delete,Copy":U.
        {fnarg disableActions cParam}.       
        cParam = "Save,Reset,Cancel".
        {fnarg enableActions cparam}.
      END.
      WHEN 'Delete-Only':U  THEN 
      DO:
        cParam = "Add,Copy,Update,Save,Cancel,Reset":U.
        {fnarg disableActions cParam}.
        cParam = "Delete".
        {fnarg enableActions cparam}.     
      END.  
      WHEN 'Add-Only':U  THEN 
      DO:
        cParam = "Copy,Update,Delete,Save,Cancel,Reset":U.
        {fnarg disableActions cParam}.
        cParam = "Add".
        {fnarg enableActions cparam}.     
      END. 
      WHEN 'Update-Only':U  THEN 
      DO:
        cParam = "Add,Copy,Delete,Save,Cancel,Reset":U.
        {fnarg disableActions cParam}.
        cParam = "Update".
        {fnarg enableActions cparam}.     
      END. 
      WHEN 'Disable-tableio':U  THEN 
      DO:
        cParam = "Add,Copy,Edit,Update,Delete,Save,Cancel,Reset".
        {fnarg disableActions cParam}.
      END.      
      WHEN 'Disable-commit':U  THEN 
      DO:
          cParam = "commit,undo".
          {fnarg disableActions cParam}.
      END.
      WHEN 'Enable-commit':U  THEN 
      DO:
          cParam = "commit,undo".
         {fnarg enableActions cParam}.
      END.
      WHEN 'Enable-filter':U  THEN 
      DO:
          cParam = "filter".
         {fnarg enableActions cParam}.
      END.
      OTHERWISE RETURN "ADM-ERROR":U.          

    END.         /* END CASE */

  END.           /* END DO WITH FRAME */  

  RETURN.               

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateActive) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateActive Procedure 
PROCEDURE updateActive :
/*------------------------------------------------------------------------------
  Purpose:   published from toolbar-target (container) to signal that 
             some of its objects have changed state  
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER plActive AS LOGICAL NO-UNDO.

  RUN resetToolbar IN TARGET-PROCEDURE. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateCategoryLists) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateCategoryLists Procedure 
PROCEDURE updateCategoryLists :
/*------------------------------------------------------------------------------
  Purpose:    Update the lists of available categories for the toolbar.                                                          
  Parameters: pcBand         - Band name  
              pcTopLevelBand - The Type of the band that are directly connected 
                               to the toolbar. (Used to figure out which lists 
                               to update)
  Notes:      This is called from loadToolbar at design time only and the result
              are currently stored in AvailMenuActions and AvailToolbarActions, 
              which has their names from pre-repository when the actions groups
              also were actions.     
------------------------------------------------------------------------------*/
   DEFINE INPUT  PARAMETER pcBand         AS CHARACTER  NO-UNDO.
   DEFINE INPUT  PARAMETER pcTopLevelType AS CHARACTER  NO-UNDO.
   DEFINE INPUT-OUTPUT PARAMETER pcMenuCategories    AS CHARACTER  NO-UNDO.
   DEFINE INPUT-OUTPUT PARAMETER pcToolbarCategories AS CHARACTER  NO-UNDO.
   
   DEFINE BUFFER bttBandAction FOR ttBandAction.

   DEFINE VARIABLE cCategory AS CHARACTER  NO-UNDO.
   
   FOR EACH bttBandAction
        WHERE bttBandAction.Band = pcBand:

     IF bttBandAction.Action <> '':U THEN
     DO:
       cCategory = {fnarg ActionCategory bttBandAction.Action}.
       IF cCategory = '':U THEN 
          cCategory = xcNocategory.

       /* include blank for uncategorized */
       IF cCategory = xcNocategory OR {fnarg CategoryLink cCategory} <> '':U THEN 
       DO:
         IF  pcTopLevelType = 'Menubar':U 
         AND NOT CAN-DO(pcMenuCategories,cCategory) THEN 
           ASSIGN pcMenuCategories = pcMenuCategories 
                                   + (IF pcMenuCategories <> '':U THEN ',':U ELSE '':U)
                                   + cCategory.
         ELSE 
         IF NOT CAN-DO(pcToolbarCategories,cCategory) THEN 
           ASSIGN pcToolbarCategories = pcToolbarCategories 
                                   + (IF pcToolbarCategories <> '':U THEN ',':U ELSE '':U)
                                   + cCategory .
       END.
     END.
     IF bttBandAction.ChildBand <> '':U THEN
        RUN updateCategoryLists IN TARGET-PROCEDURE
                              (bttBandAction.ChildBand,
                               pcTopLevelType,
                               INPUT-OUTPUT pcMenuCategories,
                               INPUT-OUTPUT pcToolbarCategories). 
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateState Procedure 
PROCEDURE updateState :
/*------------------------------------------------------------------------------
  Purpose:     Receives state message events related to record updates.
  Parameters:  pcState AS CHARACTER -- upstate state
   Notes:      Because some states may be published from different links
               the source-procedure is always checked.
               This means that this only will work when run/published from 
               the appropriate target !!!
         NB!   We do check the special getTargetProcedure in order to identify 
               the real NavigationTarget since SBO's uses a RUN. 
               This MUST NOT be used to identify TableioTarg
               ets. 
               As a TableioSource may set this before a call that may end up 
               here for a child. (This is not so very likely for updatestate) 
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcState AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE hIOTarget    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hNavTarget   AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hSource      AS HANDLE    NO-UNDO.

  hSource = SOURCE-PROCEDURE.

  /* Is this from the tableio-target? */
  hIoTarget  = {fnarg activeTarget 'Tableio':U}. 
  IF hSource = hIOTarget THEN
    /* From 9.1C we don't care what state, but check the linked object's state 
       instead */ 
    RUN resetTableio IN TARGET-PROCEDURE.     
 
  ELSE DO: 
    /* is this from a navtarget ?*/
    hNavTarget = {fnarg activeTarget 'Navigation':U}. 
    IF hSource <> hNavTarget THEN
    /* The SBO does not publish, so we need to do this trick to find the actual
        source-procedure. This is only an issue for navigationTarget */
       {get TargetProcedure hSource SOURCE-PROCEDURE} NO-ERROR.
    /* From 9.1C we don't care what state, but check the linked object's state 
       instead */ 
    IF hSource = hNavTarget THEN
      RUN resetNavigation IN TARGET-PROCEDURE.     
  END.
  
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-viewHideActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE viewHideActions Procedure 
PROCEDURE viewHideActions :
/*------------------------------------------------------------------------------
  Purpose: To view and hide actions according to state (called from setbuttons)
Parameter: input comma seperated list of actions to view
           input comma seperated list of actions to hide
    Notes: For buttons we simply hide/view existing buttons and then remove them
           into new positions.
           For menu items we must reconstruct any submenus that have been
           modified as menu items do not have a hidden attribute.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcViewActions  AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER pcHideActions  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE iLoop           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cAction         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRebuildBands   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lButtonsChanged AS LOGICAL    NO-UNDO.

  DEFINE BUFFER btMenu FOR tMenu.
  DEFINE BUFFER btButton FOR tButton.

  DO iLoop = 1 TO NUM-ENTRIES(pcViewActions):
    cAction = ENTRY(iLoop,pcViewActions).  
    /*
    FIND btMenu WHERE btMenu.Name    = cAction
                  AND btMenu.hTarget = TARGET-PROCEDURE NO-ERROR.
    
    IF AVAILABLE btMenu AND btMenu.hdl:HIDDEN = TRUE THEN 
    DO:
      IF LOOKUP(btMenu.PARENT,cRebuildBands) = 0 THEN
        ASSIGN cRebuildBands = cRebuildBands + (IF cRebuildBands = "":U THEN "":U ELSE ",":U) + btMenu.PARENT.
    END.
    */
    FIND btButton WHERE btButton.Name    = cAction
                    AND btButton.hTarget = TARGET-PROCEDURE NO-ERROR.
    IF AVAILABLE btButton AND VALID-HANDLE(btButton.Hdl) 
    AND btButton.hdl:HIDDEN = TRUE THEN 
    DO:
      btButton.Hdl:HIDDEN = FALSE.          
      IF NOT lButtonsChanged THEN ASSIGN lButtonsChanged = TRUE.
    END.
  END. /* do iLoop = 1 to num-entries(pcViewActions) */

  DO iLoop = 1 TO NUM-ENTRIES(pcHideActions):
    cAction = ENTRY(iLoop,pcHideActions).  

    /*
    FIND btMenu WHERE btMenu.Name    = cAction
                  AND btMenu.hTarget = TARGET-PROCEDURE NO-ERROR.
    
    IF AVAILABLE btMenu AND btMenu.hdl.HIDDEN = FALSE THEN 
    DO:
      btMenu.HIDDEN = TRUE.
      IF LOOKUP(btMenu.PARENT,cRebuildBands) = 0 THEN
      ASSIGN cRebuildBands = cRebuildBands + (IF cRebuildBands = "":U THEN "":U ELSE ",":U) + btMenu.PARENT.
    END.
    */
    FIND btButton WHERE btButton.Name    = cAction
                    AND btButton.hTarget = TARGET-PROCEDURE NO-ERROR.
    IF AVAILABLE btButton AND VALID-HANDLE(btButton.Hdl)
    AND btButton.Hdl:HIDDEN = FALSE THEN 
    DO:
      btButton.Hdl:HIDDEN = TRUE.          
      IF NOT lButtonsChanged THEN ASSIGN lButtonsChanged = TRUE.
    END.
  END. /* do iLoop = 1 to num-entries(pcViewActions) */

  /* If any buttons have changed, fix button positions */
  IF lButtonsChanged THEN
    RUN moveButtons IN TARGET-PROCEDURE (INPUT YES).
    
  /* 
  /* If any menu items have changed, rebuild appropriate band submenus */
  IF cRebuildBands <> "":U THEN
  DO iLoop = 1 TO NUM-ENTRIES(cRebuildBands):
    /* 1st zap existing items on toolbar band */
    FOR EACH btMenu
       WHERE btMenu.hTarget = TARGET-PROCEDURE
         AND btMenu.PARENT = ENTRY(iLoop,cRebuildBands): 
      IF VALID-HANDLE(btMenu.hdl) THEN
        DELETE WIDGET btMenu.hdl.
      ASSIGN btMenu.hdl = ?.
    END.

    /* then reconstruct toolbar band */        
    DYNAMIC-FUNCTION("constructMenuItems":U IN TARGET-PROCEDURE,
                     ENTRY(iLoop,cRebuildBands),
                     "":U).
  END.
  */
RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-viewObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE viewObject Procedure 
PROCEDURE viewObject :
/*------------------------------------------------------------------------------
  Purpose: View the object 
           The purpose for the override is to add the menu bar handle 
           to the window.  
Parameters: <none> 
     Notes: we do not call super, but make sure objecthidden is managed here    
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lToolBar    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hFrame      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cUIBmode    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hPopupFrame AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hWindow     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hMenu       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lNoMenu     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lMenu       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lUseRepos   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lRemoveMenu AS LOGICAL    NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get Window hWindow}
  {get ContainerHandle hFrame}
  {get Toolbar lToolbar}
  {get UIBMode cUIBMode}
  {get UseRepository lUseRepos}
   .
  &UNDEFINE xp-assign
  /*
  IF lUseRepos  THEN
  {fn constructMenu}.
  */
  /* If the toolbar is not used, just move the frame to bottom
   (keeping it hidden, caused overlapping frames to remain hidden??) */
  hFrame:HIDDEN = FALSE NO-ERROR.
  IF NOT lToolbar THEN
    hFrame:MOVE-TO-BOTTOM().
  
  IF cUIBMode ='Design':U THEN
  DO:
    /* check this special designtime property in design.p that is set from 
        Appbuilder to avoid 'viewing' menus on hidden pages, because this
        will override the visible ones and hideObject will remove it.*/
    IF NOT lUseRepos THEN
      lNoMenu = DYNAMIC-FUNCTION('getDesignTimeHideMenu':U IN TARGET-PROCEDURE)
                NO-ERROR. 

      /* Find the ventilator frame */
    hPopupFrame = hFrame:FIRST-CHILD.
    hPopupFrame = hPopupframe:FIRST-CHILD.
    IF VALID-HANDLE(hPopupFrame) THEN 
      hPopupframe:MOVE-TO-TOP().
  END.
  
  IF NOT lUseRepos THEN
  DO:  
    {get MenubarHandle hMenu}.
    IF VALID-HANDLE(hMenu) AND VALID-HANDLE(hMenu:FIRST-CHILD) AND NOT (lNoMenu = TRUE) THEN  
      hWindow:MENUBAR = hMenu.
    /* This is only done to enable accellerators, before the menus are dropped */
    IF cUIBMode = '':U THEN 
      RUN buildAllMenus IN TARGET-PROCEDURE.
    {fnarg enableActions 'Exit':U}.
  END.
  ELSE DO: 
    
    &SCOPED-DEFINE xp-assign
    {get Menu lMenu}
    {get RemoveMenuOnhide lRemoveMenu}
     .
    &UNDEFINE xp-assign
    /* if remove on hide , ensure the memu is added back 
      (nothing will happen if is there already) */
    IF lRemoveMenu AND lMenu THEN
      RUN rebuildMenu IN  TARGET-PROCEDURE.
  END.

  {set ObjectHidden NO}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-windowEnabled) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE windowEnabled Procedure 
PROCEDURE windowEnabled :
/*------------------------------------------------------------------------------
  Purpose:     To check if window enabled (for window drop down list)
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phHandle     AS HANDLE   NO-UNDO.
  DEFINE OUTPUT PARAMETER plEnabled   AS LOGICAL  NO-UNDO.

  DEFINE VARIABLE lEnabled AS LOGICAL.

  IF phHandle  = ? THEN
  DO:
    lEnabled = NO.
    RETURN.
  END.

  IF NOT phHandle:SENSITIVE THEN
  DO:
    ASSIGN
      lEnabled = NO.
    RETURN.
  END.

  phHandle = phHandle:FIRST-CHILD.

  DO WHILE phHandle <> ?:
    IF phHandle:SENSITIVE THEN 
    DO:
      plEnabled = YES.
      RETURN.
    END. 

    RUN WindowEnabled IN TARGET-PROCEDURE (INPUT phHandle, OUTPUT lEnabled).
    IF lEnabled THEN
    DO:
      plEnabled = YES.
      RETURN.
    END.
    phHandle = phHandle:NEXT-SIBLING.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-windowFocus) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE windowFocus Procedure 
PROCEDURE windowFocus :
/*------------------------------------------------------------------------------
  Purpose:     Focus window
  Parameters:  input window handle
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER  phHandle                  AS HANDLE   NO-UNDO.

IF VALID-HANDLE(phHandle) THEN
DO:
  APPLY "ENTRY":U TO phHandle.
  phHandle:MOVE-TO-TOP().  
  IF phHandle:WINDOW-STATE = WINDOW-MINIMIZED
    THEN phHandle:WINDOW-STATE = WINDOW-NORMAL.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-windowListMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE windowListMenu Procedure 
PROCEDURE windowListMenu :
/*------------------------------------------------------------------------------
  Purpose:     Build drop down list of session windows menu
  Parameters:  input submenu handle to build list in
               input toolbar container procedure handle
               input start handle (first time = session).
               input window count
  Notes:       Recursive procedure !
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcParent                 AS CHAR     NO-UNDO.
DEFINE INPUT PARAMETER phContainer              AS HANDLE   NO-UNDO.
DEFINE INPUT PARAMETER phStart                  AS HANDLE   NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER piCount                  AS INTEGER  NO-UNDO.

DEFINE BUFFER btMenu   FOR tMenu.
DEFINE BUFFER btParent FOR tMenu.

DEFINE VARIABLE hHandle                         AS HANDLE     NO-UNDO.
DEFINE VARIABLE lEnabled                        AS LOGICAL INITIAL YES NO-UNDO.    
DEFINE VARIABLE istartAlpha                     AS INTEGER    NO-UNDO.
DEFINE VARIABLE cLabel                          AS CHARACTER  NO-UNDO.

FIND btParent WHERE btParent.Name    = pcParent 
              AND   btParent.hTarget = TARGET-PROCEDURE NO-ERROR. 

IF NOT AVAIL btParent THEN 
  RETURN.

ASSIGN
  hHandle = phStart:FIRST-CHILD.
  
DO WHILE VALID-HANDLE(hHandle):
  IF hHandle:TYPE = "WINDOW" AND
     hHandle:VISIBLE AND
     LENGTH(TRIM(hHandle:TITLE)) > 1 AND
     hHandle <> phContainer:CURRENT-WINDOW THEN
  DO:
    ASSIGN piCount = piCount + 1.
    RUN WindowEnabled IN TARGET-PROCEDURE (INPUT hHandle, OUTPUT lEnabled).
    
    IF piCount > 9 THEN
      ASSIGN
        iStartAlpha =  ASC("a":U)
        iStartAlpha = iStartAlpha + piCount - 10
        cLabel = "&":U + CHR(iStartAlpha) + " ":U + hHandle:TITLE
        .
    ELSE cLabel = "&":U + TRIM(STRING(piCount)) + " ":U + hHandle:TITLE.
          
    CREATE btMenu.
    ASSIGN
      btMenu.hTarget = TARGET-PROCEDURE
      btMenu.NAME    = pcParent + ":":U + STRING(hHandle)
      btMenu.PARENT  = pcParent
      btMenu.seq     = piCount
      btMenu.REFRESH = NO
      btMenu.Sensitive = lEnabled.         
    CREATE MENU-ITEM btMenu.hdl
    ASSIGN  
      LABEL = cLabel
      PARENT = btParent.hdl
      SENSITIVE = lEnabled
    TRIGGERS:
      ON "CHOOSE":U PERSISTENT RUN WindowFocus IN TARGET-PROCEDURE (INPUT hHandle).
    END.                
  END.
  IF hHandle:TYPE = "WINDOW":U THEN 
  DO:
    RUN WindowListMenu IN TARGET-PROCEDURE 
                      (INPUT pcParent,
                       INPUT phContainer,
                       INPUT hHandle,
                       INPUT-OUTPUT piCount).
  END.

  ASSIGN hHandle = hHandle:NEXT-SIBLING.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-actionAccelerator) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionAccelerator Procedure 
FUNCTION actionAccelerator RETURNS CHARACTER
  (pcAction AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
 {&findaction}
 RETURN IF AVAIL ttAction THEN ttAction.ACCELERATOR ELSE ?.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionAccessType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionAccessType Procedure 
FUNCTION actionAccessType RETURNS CHARACTER
 (pcAction AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
 {&findaction}
 RETURN IF AVAIL ttAction THEN ttAction.AccessType ELSE ?.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionCanLaunch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionCanLaunch Procedure 
FUNCTION actionCanLaunch RETURNS LOGICAL
  ( pcAction AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Check for the existence of the object to launch   
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFileName  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRCodeName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lOk        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iPeriod    AS INTEGER    NO-UNDO.
  
  ASSIGN 
    cFileName  = {fnarg actionPhysicalObjectName pcAction}
    iPeriod    = NUM-ENTRIES(cFileName,'.':U)
    cRCodeName = cFileName.

  /* set RcodeName */
  IF iPeriod > 0 THEN 
    ENTRY(iPeriod,cRCodeName,'.':U) = 'r':U.
  ELSE 
    cFileName = cRCodeName + '.r':U.

  lOk  = SEARCH(cRCodeName) <> ?.  
  
  /* if rcode not found search for repository stored name (assuming source)*/
  IF NOT lok THEN
    lOk  = SEARCH(cFileName) <> ?.
  
  RETURN lOk.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionCanRun) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionCanRun Procedure 
FUNCTION actionCanRun RETURNS LOGICAL
  (pcAction AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Returns true if the target is valid and the procedure exists in it.
Parameter: pcAction - Action id of an action of type 'RUN'    
    Notes: Use to enable/disable 'run' and 'property' actions   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cProcedure       AS CHAR   NO-UNDO.
  DEFINE VARIABLE cParam           AS CHAR   NO-UNDO.
  DEFINE VARIABLE hobject          AS HANDLE NO-UNDO.
  DEFINE VARIABLE cDisabledActions AS CHAR   NO-UNDO.
  
  {get DisabledActions cDisabledActions}.
  
  IF CAN-DO(cDisabledActions,pcAction) THEN
    RETURN FALSE.

  RUN runInfo IN TARGET-PROCEDURE
       (INPUT  pcAction,
        OUTPUT cProcedure,
        OUTPUT cParam).
  
  hObject = {fnarg actionTarget pcAction}.

  IF VALID-HANDLE(hObject) THEN 
     RETURN {fnarg Signature cProcedure hObject} <> "":U.
  ELSE RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionCaption) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionCaption Procedure 
FUNCTION actionCaption RETURNS CHARACTER
  ( pcAction AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Override action class for substitution 
    Notes:  
------------------------------------------------------------------------------*/ 
  DEFINE BUFFER btMenu FOR tMenu.

  DEFINE VARIABLE cCaption    AS CHARACTER  NO-UNDO.
  
  {&findaction}
  cCaption = IF AVAIL ttAction AND ttAction.Caption <> "":U   
             THEN ttAction.Caption
             ELSE IF AVAIL ttAction AND ttAction.Name <> "":U 
                  THEN ttAction.Name
                  ELSE IF AVAIL ttAction
                       THEN ttAction.Action
                       ELSE pcAction. 
  
  
  /* If the Caption is substitutable we log it here before it is 
     substituted. This allows us to only call this for required cases in 
     resetTargetAction */ 
  IF INDEX(cCaption,'&1':U) > 0 THEN
  DO:
    FIND btMenu WHERE btMenu.NAME    = pcAction
                  AND btMenu.hTARGET = TARGET-PROCEDURE NO-ERROR. 
    IF AVAIL btMenu THEN
      ASSIGN btMenu.CaptionSubst = TRUE.
    cCaption = DYNAMIC-FUNCTION('substituteActionText':U IN TARGET-PROCEDURE,
                                 pcAction,
                                 cCaption).
  END.
  RETURN cCaption.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionCategory) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionCategory Procedure 
FUNCTION actionCategory RETURNS CHARACTER
  (pcAction AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {&findaction}
  RETURN IF AVAIL ttAction THEN ttAction.Category ELSE ?. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionCategoryIsHidden) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionCategoryIsHidden Procedure 
FUNCTION actionCategoryIsHidden RETURNS LOGICAL
  (pcAction AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Check if the action's category is hidden  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cGroups   AS CHARACTER  NO-UNDO.

  
  {&findaction}
  IF AVAIL ttAction AND ttAction.Category <> '' THEN 
  DO:
    FIND FIRST ttCategory WHERE ttCategory.Category = ttAction.Category NO-ERROR.
    /* Currently only link categories are manageable  */
    IF AVAIL ttCategory AND ttCategory.link > '':U THEN
    DO:
      {get ActionGroups cGroups}.
      RETURN NOT CAN-DO(cGroups,ttCategory.Category). 
    END.  
  END.
  
  RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionChecked) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionChecked Procedure 
FUNCTION actionChecked RETURNS LOGICAL
  (pcAction AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Returns true if the get<Property> returns a value that matches
           the actions checked.
Parameter: pcAction - Action id of an action of type 'RUN'    
    Notes: Currently we only support logical values.
           returns unknown when the function does not exist or the object is 
           not valid. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cProperty  AS CHAR   NO-UNDO.
  DEFINE VARIABLE hObject    AS HANDLE NO-UNDO.
  DEFINE VARIABLE cChecked   AS LOG    NO-UNDO INIT ?.
  ASSIGN
    cProperty = "get":U + {fnarg actionOnChoose pcAction}.
    hObject = {fnarg actionTarget pcAction}. 
  
  IF VALID-HANDLE(hObject) THEN
    cChecked = DYNAMIC-FUNCTION(cProperty IN hObject) NO-ERROR.         
          
  RETURN cChecked.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionChildren) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionChildren Procedure 
FUNCTION actionChildren RETURNS CHARACTER
 (pcAction AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Return a comma separated list of all child actions of an action. 
Parameter: Parent action id.     
    Notes: We return the class actions first.
           This is done to keep a consistent order of actions in subsequent 
           realizations of the same objects. All objects share the class 
           actions, while instance actions are created for each object 
           so instance classes will eventually have a higher order, but 
           as they may be defined before the class actions they could have 
           a lower order in the first realization.  
           The order of actions can be manipulated in the toolbar.p insertMenu() 
           and createToolbar().
------------------------------------------------------------------------------*/
  DEFINE BUFFER bttChild FOR ttAction.
  DEFINE VARIABLE cActions AS CHAR NO-UNDO. 
  
  {&findAction}
  IF AVAIL ttAction THEN   
  DO:
    FOR EACH bttChild WHERE bttChild.Parent = pcAction
                      AND   bttChild.ProcedureHandle = THIS-PROCEDURE
    BY bttChild.order:  
      cActions = cActions + ",":U + bttChild.Action.
    END.
    FOR EACH bttChild WHERE bttChild.Parent = pcAction
                      AND   bttChild.ProcedureHandle = TARGET-PROCEDURE
    BY bttChild.order:  
      cActions = cActions + ",":U + bttChild.Action.
    END.
  END.

  RETURN LEFT-TRIM(cActions,",":U).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionControlType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionControlType Procedure 
FUNCTION actionControlType RETURNS CHARACTER
  (pcAction AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Return the action's control type 
           - The repository supports 'Action','Label','placeholder' or 'separator'  
           - For non repository actions we return 'Action' if onchoose <> '' 
             otherwise it is a 'label' (this is set in defineAction)
              (RULE is not defined in action for non-repository toolbars) 
   Notes:  Used in targetActions to retrieve actions for a link 
           and in createMenuAction to ensure that a submenu NOT is created 
           for a placeholder. 
------------------------------------------------------------------------------*/
  {&findaction}
  RETURN IF AVAIL ttAction THEN ttAction.ControlType ELSE ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionCreateEvent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionCreateEvent Procedure 
FUNCTION actionCreateEvent RETURNS CHARACTER
  (pcAction AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Returns the createEvent 
           (published when the action is created/realized in the interface)
    Notes: Cannot be changed.   
------------------------------------------------------------------------------*/
  {&findaction}
  RETURN IF AVAIL ttAction THEN ttAction.CreateEvent ELSE ?.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionDescription) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionDescription Procedure 
FUNCTION actionDescription RETURNS CHARACTER
  (pcAction AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {&findaction}
  RETURN IF AVAIL ttAction THEN ttAction.Description ELSE ?.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionDisabled) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionDisabled Procedure 
FUNCTION actionDisabled RETURNS LOGICAL
  (pcAction AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {&findaction}
  RETURN IF AVAIL ttAction THEN ttAction.Disabled ELSE ?. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionEnableRule) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionEnableRule Procedure 
FUNCTION actionEnableRule RETURNS CHARACTER
  (pcAction AS CHAR) :
/*------------------------------------------------------------------------------
   Purpose: Return the ImageEnableRule for a given action as stored in the 
            repository 
Parameters: pcAction - Action name    
     Notes: The rules are evaluated in ruleStateChanges, which for performance
            reasons normally does not call the method, but instead uses the 
            value as stored in the temp-table. 
            This means that overriding this in a custom super procedure will
            have no effect. 
            It may, however, be overridden in an instance since ruleStateChanges
            does a specific check of internal-entries and uses the function in
            that case.
IMPORTANT: This function is duplicated in the Panel super proc panel.p            
------------------------------------------------------------------------------*/
  {&findaction}
  RETURN IF AVAIL ttAction THEN ttAction.EnableRule ELSE ?. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionGroups) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionGroups Procedure 
FUNCTION actionGroups RETURNS CHARACTER
    () :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER bttChild FOR ttAction.
  
  DEFINE VARIABLE cActions AS CHAR NO-UNDO. 
  FOR EACH ttCategory:
    ASSIGN cActions = cActions + ",":U + ttCategory.Category.

  END.
  FOR 
  EACH ttAction, 
  FIRST bttChild WHERE bttChild.Parent = ttAction.Action:  
     ASSIGN cActions = cActions + ",":U + ttAction.Action.
  END.
  RETURN LEFT-TRIM(cActions,",":U).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionHideRule) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionHideRule Procedure 
FUNCTION actionHideRule RETURNS CHARACTER
  (pcAction AS CHAR) :
/*------------------------------------------------------------------------------
   Purpose: Return the HideRule for a given action as stored in the repository 
Parameters: pcAction - Action name    
     Notes: The rules are evaluated in ruleStateChanges, which for performance
            reasons normally does not call the method, but instead uses the 
            value as stored in the temp-table. 
            It may, however, be overridden in an instance since ruleStateChanges
            does a specific check of internal-entries and uses the function in
            that case.
            This means that overriding this in a custom super procedure will
            have no effect. 
IMPORTANT: This function is duplicated in the Panel super proc panel.p            
------------------------------------------------------------------------------*/
  {&findaction}
  RETURN IF AVAIL ttAction THEN ttAction.HideRule ELSE ?. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionImage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionImage Procedure 
FUNCTION actionImage RETURNS CHARACTER
  (pcAction AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  PicClip images are defined in the Down Image and are used if 
            the offsets are defined in the image as a comma delimited list
            containing image, x-offset, y-offset, width, height
------------------------------------------------------------------------------*/
  {&findaction}
  RETURN IF AVAIL ttAction AND NUM-ENTRIES(ttAction.ImageDown) > 1
         THEN ttAction.ImageDown 
         ELSE IF AVAIL ttAction THEN ttAction.Image 
         ELSE ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionImageAlternate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionImageAlternate Procedure 
FUNCTION actionImageAlternate RETURNS CHARACTER
  (pcAction AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  PicClip images are defined in the Down Image and are used if 
            the offsets are defined in the image as a comma delimited list
            containing image, x-offset, y-offset, width, height
------------------------------------------------------------------------------*/
  {&findaction}
  RETURN IF AVAIL ttAction AND NUM-ENTRIES(ttAction.Image2Down) > 1
         THEN ttAction.Image2Down 
         ELSE IF AVAIL ttAction THEN ttAction.Image2 
         ELSE ?.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionImageAlternateRule) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionImageAlternateRule Procedure 
FUNCTION actionImageAlternateRule RETURNS CHARACTER
  (pcAction AS CHAR) :
/*------------------------------------------------------------------------------
   Purpose: Return the ImageAlternateRule for a given action as stored in the 
            repository 
Parameters: pcAction - Action name    
     Notes: The rules are evaluated in ruleStateChanges, which for performance
            reasons normally does not call the method, but instead uses the 
            value as stored in the temp-table. 
            This means that overriding this in a custom super procedure will
            have no effect. 
            It may, however, be overridden in an instance since ruleStateChanges
            does a specific check of internal-entries and uses the function in
            that case.
IMPORTANT: This function is duplicated in the Panel super proc panel.p            
------------------------------------------------------------------------------*/
  {&findaction}
  RETURN IF AVAIL ttAction THEN ttAction.ImageAlternateRule ELSE ?.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionInitCode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionInitCode Procedure 
FUNCTION actionInitCode RETURNS CHARACTER
  (pcAction AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
 {&findaction}
  RETURN IF AVAIL ttAction THEN ttAction.InitCode ELSE ?.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionIsMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionIsMenu Procedure 
FUNCTION actionIsMenu RETURNS LOGICAL
 (pcAction AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Returns true if an action is Menu. 
           Action defined as menu is considered to be a constant part of 
           the toolbar and are not selectable.    
           This means that it's always available (It needs to be added to a 
           toolbar with createToolbar or insertMenu(). 
           It will NOI appear as a selectable action in the instance property 
           dialog even if it isParent  
    Notes:   
------------------------------------------------------------------------------*/
  {&findaction}
  RETURN AVAIL ttAction AND ttAction.Type = "MENU":U .
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionIsParent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionIsParent Procedure 
FUNCTION actionIsParent RETURNS LOGICAL
  (pcAction AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {&findaction}

  RETURN AVAIL ttAction  
         AND (ttAction.InitCode <> "":U
              OR
              ttAction.CreateEvent <> "":U
              OR
              CAN-FIND(FIRST ttAction WHERE ttAction.parent = pcAction)
             ).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionLabel Procedure 
FUNCTION actionLabel RETURNS CHARACTER
  ( pcAction AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  Override action class and caption  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER btButton  FOR tButton.

  DEFINE VARIABLE cLabel    AS CHARACTER  NO-UNDO.
  
  {&findaction}
  cLabel = IF AVAIL ttAction AND ttAction.Name <> '':U THEN ttAction.Name
           ELSE IF AVAIL ttAction                      THEN ttAction.Action
           ELSE ?. 
    /* If the label is substitutable we log it here before it is 
     substituted. This allows us to only call this for required cases in 
     resetTargetAction */ 
  IF INDEX(cLabel,'&1':U) > 0 THEN
  DO:
    FIND btButton WHERE btButton.NAME     = pcAction
                   AND   btButton.hTARGET = TARGET-PROCEDURE NO-ERROR. 
    IF AVAIL btButton THEN
      ASSIGN btButton.LabelSubst = TRUE.
    cLabel = DYNAMIC-FUNCTION('substituteActionText':U IN TARGET-PROCEDURE,
                       pcAction,
                       cLabel).
  END.
  RETURN cLabel.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionLink) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionLink Procedure 
FUNCTION actionLink RETURNS CHARACTER
  (pcAction AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cLink          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCategory      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParent        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lUseRepository AS LOGICAL    NO-UNDO.
  
  {&findaction}
  cLink = IF AVAIL ttAction THEN ttAction.Link ELSE ?. 

  IF cLink = '':U THEN
  DO:
    {get UseRepository lUseRepository}.
    IF lUseRepository THEN
    DO:
      cCategory = ttAction.Category.

      IF cCategory <> '':U THEN
        cLink = {fnarg categoryLink cCategory}. 

    END.
    ELSE DO:
      cParent = {fnarg actionParent pcAction}.
      IF cParent <> '':u THEN
        cLink   = {fnarg actionLink cParent}.
    END.
  END.

  RETURN cLink.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionLogicalObjectName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionLogicalObjectName Procedure 
FUNCTION actionLogicalObjectName RETURNS CHARACTER
  (pcAction AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {&findaction}
  RETURN IF AVAIL ttAction THEN ttAction.LogicalObjectName ELSE ?. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionName Procedure 
FUNCTION actionName RETURNS CHARACTER
  (pcAction AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
 {&findaction}
 RETURN IF AVAIL ttAction AND ttAction.Name <> '':U THEN ttAction.Name
        ELSE IF AVAIL ttAction                      THEN ttAction.Action
        ELSE ?. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionOnChoose) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionOnChoose Procedure 
FUNCTION actionOnChoose RETURNS CHARACTER
  (pcAction AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {&findaction}
  RETURN IF AVAIL ttAction THEN ttAction.OnChoose ELSE ?.
         
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionParameter) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionParameter Procedure 
FUNCTION actionParameter RETURNS CHARACTER
  (pcAction AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {&findaction}
  RETURN IF AVAIL ttAction THEN ttAction.RunParameter ELSE ?.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionParent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionParent Procedure 
FUNCTION actionParent RETURNS CHARACTER
  (pcAction AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Parent can be another action or an actionCategory 
    Notes:  
------------------------------------------------------------------------------*/
    {&findaction}
  RETURN IF AVAIL ttAction THEN ttAction.Parent ELSE ?.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionPhysicalObjectName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionPhysicalObjectName Procedure 
FUNCTION actionPhysicalObjectName RETURNS CHARACTER
  (pcAction AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {&findaction}
  RETURN IF AVAIL ttAction THEN ttAction.PhysicalObjectName ELSE ?. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionPublishCreate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionPublishCreate Procedure 
FUNCTION actionPublishCreate RETURNS LOGICAL
  ( pcAction AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Subscribe create events to objects 
    Notes: Subscribes both active and inactive (hidden) objects
           -target links are considered as multiple.
           -source as single. 
           The reason why subscribe and publish is used is mostly to be able
           to reference source-procedure in the events, but it also makes it
           possible to just subscribe without linking.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cLink        AS CHAR   NO-UNDO.
  DEFINE VARIABLE cEvent       AS CHAR   NO-UNDO.
  DEFINE VARIABLE cLinkHandles AS CHAR   NO-UNDO.
  DEFINE VARIABLE hObject      AS HANDLE NO-UNDO.
  DEFINE VARIABLE i            AS INT    NO-UNDO.
  
  cEvent = {fnarg actionCreateEvent pcAction}.
  
  IF cEvent = "":U  THEN 
     RETURN FALSE.
  cLink = {fnarg actionLink pcAction}.
  IF cLink <> "":U THEN
  DO:  
    IF ENTRY(2,cLink,"-":U) = "target":U THEN
      cLinkHandles = DYNAMIC-FUNCTION("get":U + REPLACE(cLink,"-":U,"":U)
                                       IN TARGET-PROCEDURE).
    
    ELSE
      hObject = DYNAMIC-FUNCTION("get":U + REPLACE(cLink,"-":U,"":U)
                                  IN TARGET-PROCEDURE).

  END. /* clink <> '' */
  ELSE  /* container is default  */
    {get ContainerSource hObject}.

  DO i = 1 TO IF cLinkHandles <> "":U THEN NUM-ENTRIES(clinkHandles)
              ELSE 1:
    IF cLinkHandles <> "":U THEN 
       hObject = WIDGET-HANDLE(ENTRY(i,cLinkHandles)).
    
    SUBSCRIBE PROCEDURE hObject TO cEvent IN  TARGET-PROCEDURE NO-ERROR.
  END.
  
  PUBLISH cEvent FROM TARGET-PROCEDURE (pcAction).

  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionRefresh) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionRefresh Procedure 
FUNCTION actionRefresh RETURNS LOGICAL
  (pcAction AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {&findaction}
  RETURN IF AVAIL ttAction THEN ttAction.Refresh ELSE ?.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionRunAttribute) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionRunAttribute Procedure 
FUNCTION actionRunAttribute RETURNS CHARACTER
  (pcAction AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {&findaction}
  RETURN IF AVAIL ttAction THEN ttAction.RunAttribute ELSE ?.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionSecondImage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionSecondImage Procedure 
FUNCTION actionSecondImage RETURNS CHARACTER
  (pcAction AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {&findaction}
  RETURN IF AVAIL ttAction THEN ttAction.Image2 ELSE ?.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionSecuredToken) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionSecuredToken Procedure 
FUNCTION actionSecuredToken RETURNS CHARACTER
  (pcAction AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {&findaction}
  RETURN IF AVAIL ttAction THEN ttAction.SecurityToken ELSE ?.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionSubstituteProperty) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionSubstituteProperty Procedure 
FUNCTION actionSubstituteProperty RETURNS CHARACTER
  (pcAction AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {&findaction}
  RETURN IF AVAIL ttAction THEN ttAction.SubstituteProperty ELSE ?.    
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionTarget Procedure 
FUNCTION actionTarget RETURNS HANDLE
  (pcAction AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Returns the handle of the target.
           Used by actions of Type RUN or PROPERTY. 
Parameter: pcAction - Action id     
    Notes: The container-Source is the default target.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hObject        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cParent        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCategory      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLink          AS CHARACTER  NO-UNDO.
  
  cLink = {fnarg actionLink pcAction}.   
 
  IF cLink <> "":U THEN
  DO:
    IF ENTRY(2,cLink,"-":U) = "target":U THEN
      ASSIGN
        cLink = ENTRY(1,cLink,"-":U)
        hObject = {fnarg activeTarget cLink}.
    ELSE 
      hObject = DYNAMIC-FUNCTION("get":U + REPLACE(cLink,"-":U,"":U) IN TARGET-PROCEDURE) NO-ERROR.          
  END. /* if link <> "" */
  ELSE
    {get ContainerSource hObject} NO-ERROR.
              
  RETURN hObject.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionTooltip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionTooltip Procedure 
FUNCTION actionTooltip RETURNS CHARACTER
  ( pcAction AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  Override action class and caption  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER btButton FOR tButton.

  DEFINE VARIABLE cTooltip     AS CHARACTER  NO-UNDO.
  
  {&findaction}
  cTooltip = IF AVAIL ttAction AND ttAction.Tooltip      <> "":U THEN ttAction.Tooltip
             ELSE IF AVAIL ttAction AND ttAction.Caption <> "":U THEN ttAction.Caption
             ELSE IF AVAIL ttAction AND ttAction.NAME <> "":U    THEN ttAction.Name
             ELSE IF AVAIL ttAction                              THEN ttAction.Action
             ELSE ?. 

  /* If the tooltip is substitutable we log it here before it is 
     substituted. This allows us to only call this for required cases in 
     resetTargetAction */ 
  IF INDEX(cTooltip,'&1':U) > 0 THEN
  DO:
    FIND btButton WHERE btButton.NAME     = pcAction
                   AND  btButton.hTARGET = TARGET-PROCEDURE NO-ERROR. 
    IF AVAIL btButton THEN 
      ASSIGN btButton.TooltipSubst = TRUE.
    
    cTooltip = DYNAMIC-FUNCTION('substituteActionText':U IN TARGET-PROCEDURE,
                                pcAction,
                                cTooltip).
  END.
     
  RETURN cTooltip.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionType Procedure 
FUNCTION actionType RETURNS CHARACTER
  (pcAction AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {&findaction}
  RETURN IF AVAIL ttAction THEN ttAction.Type ELSE ?.   
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-activeTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION activeTarget Procedure 
FUNCTION activeTarget RETURNS HANDLE
  ( pcLink AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Return the active target linked object.   
   pcLink: pcLink - "Tableio", "Navigation" "Commit"  
    Notes: The toolbar only supports one active object in these, but it may 
           be linked to inactive objects on hidden pages. 
           If more than one target this procedure returns the object where 
           IsLinkInActive = false or a GaTarget is not hidden. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cLinkHandles   AS CHAR      NO-UNDO.
  DEFINE VARIABLE iLink          AS INT       NO-UNDO.
  DEFINE VARIABLE hObject        AS HANDLE    NO-UNDO.

  cLinkHandles = DYNAMIC-FUNCTION("get":U + pcLink + "Target":U IN TARGET-PROCEDURE) NO-ERROR.

  /* This addition is to incorporate user-defined links. If the function does not exist, cLinkHandles will be ? */
  IF ERROR-STATUS:ERROR     OR
     cLinkHandles       = ? THEN
    cLinkHandles = DYNAMIC-FUNCTION("linkHandles":U IN TARGET-PROCEDURE, pcLink + "-Target":U) NO-ERROR.

  DO iLink = 1 TO NUM-ENTRIES(cLinkHandles):
    hObject = WIDGET-HANDLE(ENTRY(iLink,cLinkHandles)).
    IF VALID-HANDLE(hObject) THEN
    DO:
      IF NOT DYNAMIC-FUNCTION('isLinkInactive':U IN hObject,
                               pcLink + "Source":U,
                              TARGET-PROCEDURE) THEN
         RETURN hObject. 
    END. /* valid(hObject) */
  END.
  
  RETURN ?.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-adjustActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION adjustActions Procedure 
FUNCTION adjustActions RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Called after realization of toolbar to adjust sizes  
    Notes: Returns true if changes happened 
           Currently changes width of all actions in a horizontal toolbar
           to maxwidth encountered during realization
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cToolbarDrawDirection AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iToolMaxWidthPxl      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iToolWidthPxl         AS INTEGER    NO-UNDO.
  
  DEFINE BUFFER btButton FOR tButton.

  {get ToolbarDrawDirection cToolbarDrawDirection}.

  IF cToolbarDrawDirection BEGINS 'v':U THEN
  DO:
    &SCOPED-DEFINE xp-assign
    {get ToolMaxWidthPxl iToolMaxWidthPxl}
    {get ToolWidthPxl iToolWidthPxl}.
    &UNDEFINE xp-assign
    IF iToolMaxWidthPxl > iToolWidthPxl THEN
    DO:
      FOR EACH btButton WHERE btbutton.hTarget = TARGET-PROCEDURE:
        IF VALID-HANDLE(btButton.hdl) THEN
        btButton.hdl:WIDTH-P = iToolMaxWidthPxl.
      END.
    END.
  END.

  RETURN iToolMaxWidthPxl > iToolWidthPxl. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignActionAccelerator) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignActionAccelerator Procedure 
FUNCTION assignActionAccelerator RETURNS LOGICAL
  (pcId AS CHAR,
   pcValue AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN assignColumn("Action":U,pcId,"Accelerator":U,pcValue).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignActionAccessType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignActionAccessType Procedure 
FUNCTION assignActionAccessType RETURNS LOGICAL
  (pcId     AS CHAR,
   pcValue  AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN assignColumn("Action":U,pcId,"AccessType":U,pcValue).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignActionCaption) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignActionCaption Procedure 
FUNCTION assignActionCaption RETURNS LOGICAL
  (pcId     AS CHAR,
   pcValue  AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN assignColumn("Action":U,pcId,"Caption":U,pcValue).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignActionDescription) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignActionDescription Procedure 
FUNCTION assignActionDescription RETURNS LOGICAL
  (pcId     AS CHAR,
   pcValue  AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN assignColumn("Action":U,pcId,"Description":U,pcValue).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignActionEnableRule) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignActionEnableRule Procedure 
FUNCTION assignActionEnableRule RETURNS LOGICAL
  (pcId AS CHAR,
   pcValue AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN assignColumn("Action":U,pcId,"EnableRule":U,pcValue).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignActionHideRule) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignActionHideRule Procedure 
FUNCTION assignActionHideRule RETURNS LOGICAL
  (pcId AS CHAR,
   pcValue AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN assignColumn("Action":U,pcId,"HideRule":U,pcValue).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignActionImage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignActionImage Procedure 
FUNCTION assignActionImage RETURNS LOGICAL
  (pcId     AS CHAR,
   pcValue  AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN assignColumn("Action":U,pcId,"Image":U,pcValue).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignActionImageAlternateRule) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignActionImageAlternateRule Procedure 
FUNCTION assignActionImageAlternateRule RETURNS LOGICAL
  (pcId AS CHAR,
   pcValue AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN assignColumn("Action":U,pcId,"ImageAlternateRule":U,pcValue).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignActionLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignActionLabel Procedure 
FUNCTION assignActionLabel RETURNS LOGICAL
  (pcId     AS CHAR,
   pcValue  AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:   
    Notes: actionLabel is an alias for actionName 
------------------------------------------------------------------------------*/
  RETURN DYNAMIC-FUNCTION ('assignActionName':U IN TARGET-PROCEDURE,
                           pcId,
                           pcValue).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignActionName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignActionName Procedure 
FUNCTION assignActionName RETURNS LOGICAL
  (pcId     AS CHAR,
   pcValue  AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN assignColumn("Action":U,pcId,"Name":U,pcValue).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignActionOrder) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignActionOrder Procedure 
FUNCTION assignActionOrder RETURNS LOGICAL
  (pcId     AS CHAR,
   piValue  AS INT) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN assignColumn("Action":U,pcId,"Order":U,STRING(piValue)).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignActionParent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignActionParent Procedure 
FUNCTION assignActionParent RETURNS LOGICAL
  (pcId     AS CHAR,
   pcValue  AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN assignColumn("Action":U,pcId,"Parent":U,pcValue).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignActionRefresh) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignActionRefresh Procedure 
FUNCTION assignActionRefresh RETURNS LOGICAL
 (pcId     AS CHAR,
  plValue  AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN assignColumn("Action":U,pcId,"Refresh":U,STRING(plValue)).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignActionSecondImage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignActionSecondImage Procedure 
FUNCTION assignActionSecondImage RETURNS LOGICAL
  (pcId     AS CHAR,
   pcValue  AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN assignColumn("Action":U,pcId,"Image2":U,pcValue).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignActionTooltip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignActionTooltip Procedure 
FUNCTION assignActionTooltip RETURNS LOGICAL
  (pcId     AS CHAR,
   pcValue  AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN assignColumn("Action":U,pcId,"Tooltip":U,pcValue).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumn) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignColumn Procedure 
FUNCTION assignColumn RETURNS LOGICAL PRIVATE
  (pcObject AS CHAR,
   pcId     AS CHAR,
   pcColumn AS CHAR,
   pcValue  AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBuffer AS HANDLE NO-UNDO.
  DEFINE VARIABLE hColumn AS HANDLE NO-UNDO.
  
  IF DYNAMIC-FUNCTION("find":U + pcObject, pcId,?) THEN     
  DO:
    ASSIGN
      hBuffer = bufferHandle(pcObject)
      hColumn = hBuffer:BUFFER-FIELD(pcColumn)
      hColumn:BUFFER-VALUE = pcValue.
    RETURN TRUE.
  END. 
  ELSE 
    errorMessage (SUBSTITUTE({fnarg messageNumber 40},'assign':U + pcColumn + "()":U, pcId)).
         
  RETURN FALSE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-bandActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION bandActions Procedure 
FUNCTION bandActions RETURNS CHARACTER
  ( pcParentBand AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the available menu band for this toolbar master 
    Notes:  Used in the Instance Property dialog to select MenuBands
------------------------------------------------------------------------------*/
 DEFINE BUFFER bttBand       FOR ttBand.
 DEFINE BUFFER bttBandAction FOR ttBandAction.
 
 DEFINE VARIABLE cLogicalObject AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cActionList    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cType          AS CHARACTER  NO-UNDO.

 {get LogicalObjectName cLogicalObject}.
 
 FOR EACH bttBandAction 
      WHERE bttBandAction.Band = pcParentBand 
 BY bttBandAction.Sequence:    
   IF bttBandAction.ChildBand = '':U THEN
   DO:
     cType = {fnarg actionType bttBandAction.Action}.
     IF NOT CAN-DO('Separator,Placeholder':U,bttBandAction.Action) THEN
     DO:
       cActionList = cActionList 
                   + (IF cActionList <> '':U THEN ',':U ELSE '':U) 
                   +  bttBandAction.Action.
     END.
   END.
 END.
 RETURN cActionList.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-bandSubmenuLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION bandSubmenuLabel Procedure 
FUNCTION bandSubmenuLabel RETURNS CHARACTER
  ( pcBand      AS CHARACTER,
    pcChildBand AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Return the label for a specific childband 
    Notes:  Currently used for instance property dialog
------------------------------------------------------------------------------*/
 DEFINE BUFFER bttChildBand   FOR ttBand.
 DEFINE BUFFER bttBandAction  FOR ttBandAction.       
 DEFINE BUFFER bttToolbarBand FOR ttToolbarBand. 
 DEFINE BUFFER bttBand        FOR ttBand.

 DEFINE VARIABLE cLogicalObject AS CHARACTER  NO-UNDO. 

 IF pcBand = '':U THEN
 DO:
   {get LogicalObjectName cLogicalObject}.
   FOR EACH bttToolbarBand 
       WHERE bttToolbarBand.Toolbar  = cLogicalObject,
       EACH bttBand 
       WHERE bttBand.Band     = bttToolbarBand.Band  
       AND   bttBand.BandType = 'Menubar':U :

     pcBand = bttBand.Band.
     LEAVE. /* there should be only one, but let's leave and use the first
                no matter what */
   END.
 END.

 FIND bttBandAction 
      WHERE bttBandAction.Band      = pcBand 
      AND   bttBandAction.ChildBand = pcChildBand NO-ERROR.
 IF AVAIL bttBandAction THEN
 DO:
   IF bttBandAction.Action <> '':U THEN
      RETURN {fnarg actionLabel bttBandAction.Action}.

   /* Find the default label of the band */
   FIND bttChildBand WHERE bttChildBand.Band = bttBandAction.ChildBand.
   IF bttChildBand.BandLabelAction <> '':U THEN
     RETURN {fnarg actionLabel bttChildBand.BandLabelAction}.

   ELSE RETURN bttBandAction.ChildBand.
 END.

 /* If there's more than one child band (??) just return the band name */  
 ELSE IF AMBIGUOUS bttBandAction THEN
   RETURN pcBand.
    
 RETURN "":U.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-bandSubmenus) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION bandSubmenus Procedure 
FUNCTION bandSubmenus RETURNS CHARACTER
  ( pcParentBand AS CHAR) :
/*------------------------------------------------------------------------------
   Purpose:  Returns the available child bands on a specific band             
 Parameter: pcParentBand - Band name 
                         - Blank - The menubar of the Toolbar master
            plLabels     - Return the action labels if defined               
     Notes:  Used in the Instance Property dialog to select MenuBands
------------------------------------------------------------------------------*/
 DEFINE BUFFER bttBand        FOR ttBand.
 DEFINE BUFFER bttBandAction  FOR ttBandAction.
 DEFINE BUFFER bttToolbarBand FOR ttToolbarBand.

 DEFINE VARIABLE cLogicalObject AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cBandList      AS CHARACTER  NO-UNDO.
  
 /* if no parent specified find and use the menubar */
 IF pcParentBand = '':U THEN
 DO:
   {get LogicalObjectName cLogicalObject}.
   FOR EACH bttToolbarBand 
       WHERE bttToolbarBand.Toolbar  = cLogicalObject,
       EACH bttBand 
       WHERE bttBand.Band     = bttToolbarBand.Band  
       AND   bttBand.BandType = 'Menubar':U :

     pcParentBand = bttBand.Band.
     LEAVE. /* there should be only one, but let's leave and use the first
                no matter what */
   END.
 END.

 FOR EACH bttBandAction 
      WHERE bttBandAction.Band = pcParentBand 
 BY bttBandAction.Sequence:    
   IF bttBandAction.ChildBand <> '':U THEN
   DO:
     cBandList = cBandList 
               + (IF cBandList <> '':U THEN ',':U ELSE '':U) 
               + bttBandAction.ChildBand.
   END.
 END.
 RETURN cBandList.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-bufferHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION bufferHandle Procedure 
FUNCTION bufferHandle RETURNS HANDLE
  (pcObject AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBuffer AS HANDLE NO-UNDO.
  CASE pcObject:
    WHEN "Action":U THEN 
      hBuffer = BUFFER ttAction:HANDLE.     
    WHEN "Category":U THEN 
      hBuffer = BUFFER ttCategory:HANDLE.
  END.

  RETURN hBuffer.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION buildMenu Procedure 
FUNCTION buildMenu RETURNS LOGICAL
  (pcParent AS CHAR) :
/*------------------------------------------------------------------------------
   Purpose: Build one branch of a menu.  
Parameters: INPUT pcParent - The  name of the sub-menu that this menu will use 
                             as its parent
                             Blank - means that we are creating a menu-bar. 
     Notes: Called from onMenuDrop  
------------------------------------------------------------------------------*/
  DEFINE BUFFER tChild  FOR tMenu.

  DEFINE VARIABLE hMenu            AS HANDLE NO-UNDO. 
  DEFINE VARIABLE cType            AS CHAR   NO-UNDO. 
  DEFINE VARIABLE cBuildInitCode   AS CHAR   NO-UNDO. 
  DEFINE VARIABLE cMenuItems       AS CHAR   NO-UNDO. 
  DEFINE VARIABLE lRefresh         AS LOG    NO-UNDO. 
  DEFINE VARIABLE lMenu            AS LOG    NO-UNDO. 
  DEFINE VARIABLE lDefined         AS LOG    NO-UNDO. 
  DEFINE VARIABLE i                AS INT    NO-UNDO. 
  DEFINE VARIABLE lCanAddRule      AS LOG    NO-UNDO.
  DEFINE VARIABLE hActionTarget    AS HANDLE NO-UNDO.
  DEFINE VARIABLE lChecked         AS LOG    NO-UNDO.
  DEFINE VARIABLE cDisabledActions AS CHAR   NO-UNDO.
  
  &SCOPED-DEFINE xp-assign
  {get Menu lMenu}
  {get DisabledActions cDisabledActions}.
  &UNDEFINE xp-assign

  IF NOT lMenu THEN 
    RETURN FALSE.

  If pcParent = "":U THEN 
    hMenu = {fn createMenuBar}.
  ELSE    
  DO:
    FIND tMenu WHERE tMenu.Name    = pcParent
                 AND tMenu.hTarget = TARGET-PROCEDURE NO-ERROR.
    IF NOT AVAIL tMenu THEN 
       RETURN FALSE.
    hMenu = tMenu.Hdl.   
  END.
  
  /* Initcode menues are always recreated  */
  cBuildInitCode  = {fnarg ActionInitCode pcParent}.    
  
  IF cBuildInitCode <> "":U THEN 
  FOR EACH tMenu WHERE tMenu.Parent  = pcParent 
                 AND   tMenu.hTarget = TARGET-PROCEDURE
                 AND   tMenu.NAME BEGINS pcParent + ":":U:
    IF VALID-HANDLE(tMenu.Hdl) THEN 
      DELETE WIDGET tMenu.Hdl.
    DELETE tMenu.   
  END.
  
  /* If refresh then delete all */ 
  lRefresh   = {fnarg ActionRefresh pcParent}.
  
  IF lRefresh THEN 
  FOR EACH tMenu WHERE tMenu.Parent  = pcParent 
                 AND   tMenu.hTarget = TARGET-PROCEDURE:
    
    IF VALID-HANDLE(tMenu.Hdl) THEN 
        DELETE WIDGET tMenu.Hdl.
    DELETE tMenu.   
  END.
  
  IF VALID-HANDLE(hMenu) AND NOT VALID-HANDLE(hMenu:FIRST-CHILD) THEN 
  DO:
    FOR EACH tMenu WHERE tMenu.Parent  = pcParent 
                   AND   tMenu.hTarget = TARGET-PROCEDURE:
      IF tMenu.Name <> "RULE":U OR lCanAddRule THEN
      DO:
        DYNAMIC-FUNCTION('createMenuAction':U IN TARGET-PROCEDURE,
                          pcParent,
                          tMenu.Name).
        lCanAddRule = tMenu.Name <> "RULE":U.
      END. /* if rule */
    END. /* for each tMenu */
  END. /* if not valid handle first tmenu */
  
  /* initCode procedures can create a poor-mans menu 
     that just creates key and text based on the CHR(1) separated list
     returned from the function. The key will be passed as input parameter 
     to the parents onChoose */

  IF cBuildInitCode <> "":U THEN 
  DO:
    ASSIGN 
      hActionTarget = {fnarg actionTarget pcParent}. 
      
    IF VALID-HANDLE(hActionTarget) THEN      
        cMenuItems = DYNAMIC-FUNCTION(cBuildInitCode IN hActionTarget).
      
    DO i = 1 TO NUM-ENTRIES(cMenuItems,CHR(1)) BY 2:  
        DYNAMIC-FUNCTION('insertMenuTempTable':U IN TARGET-PROCEDURE,
                         pcParent,
                         /* add parent in order to make it identifiable */ 
                         pcParent + ":" + ENTRY(i,cMenuItems,CHR(1)),
                         ?).
        tMenu.Sensitive = TRUE.
        tMenu.Hdl = DYNAMIC-FUNCTION("createMenuItem":U IN TARGET-PROCEDURE,
                        hMenu,
                        tMenu.Name,
                        ENTRY(i + 1,cMenuItems,CHR(1)),
                        "":U,
                        tMenu.Sensitive
                  ).  
   
    END. /* do i = 1 to num-entries(cMenuItems,CHR(1)) */
  END. /* cInitCode <> "":U */
  
  FIND LAST tMenu WHERE tMenu.Parent  = pcParent 
                  AND   tMenu.hTarget = TARGET-PROCEDURE NO-ERROR.
    
  /* make sure that we don't have a RULE as the last entry */
  IF AVAIL tMenu AND tMenu.Name = "RULE":U AND VALID-HANDLE(tMenu.Hdl) THEN
     DELETE WIDGET tMenu.Hdl.  


  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildMenuBand) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION buildMenuBand Procedure 
FUNCTION buildMenuBand RETURNS LOGICAL
  ( phParent  AS HANDLE, 
    pcMenuKey AS CHAR) :
/*------------------------------------------------------------------------------
    Purpose: Build a submenu for a band for the target or across the entire 
              menubar.   
 Parameters:           
   phParent - Parent handle to add menus to 
            - unknown - add menus to target's parent          
    Notes: Called from constructMenuband with unknown parent to add menus 
           to the recently creatred parent 
           Called from removeMenuBand to move menus to the menu that took 
           over the removed menu's position.
-----------------------------------------------------------------------------*/
  DEFINE VARIABLE hParent        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hMenubar       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lCreateSub     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cTargetList    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lRule          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hUseParent     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hCurrentTarget AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lLinkAdded     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lSubAdded      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cSubList       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iSub           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hToolbar       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSubMenu       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSubParent     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lContainerLink AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lRebuild       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cParentMenuKey AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParent        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMenuKey       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lNoAccelerator AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hRuleDel       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRule          AS HANDLE     NO-UNDO.

  DEFINE VARIABLE cCurrentLabel  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLabel         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cLabel         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLink          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSubLabels     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSubLabelHdls  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSubHdls       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLinkToolbarId AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSubHdl        AS HANDLE     NO-UNDO.

  DEFINE BUFFER btMenu            FOR tMenu.
  DEFINE BUFFER btBandMenu        FOR tMenu.
  DEFINE BUFFER btFirstBandMenu   FOR tMenu.
  DEFINE BUFFER btParentInstance  FOR tBandInstance.
  DEFINE BUFFER btInsertInstance  FOR tBandInstance.

  {get MenuBarHandle hMenuBar}.
  
  IF NOT VALID-HANDLE(phParent) THEN
  DO:
    FIND btParentInstance WHERE btParentInstance.MenuKey = pcMenuKey 
                          AND   btParentInstance.hTarget = TARGET-PROCEDURE NO-ERROR.  
            
    IF NOT AVAIL btParentInstance THEN
      RETURN FALSE.
    IF NOT VALID-HANDLE(btParentInstance.hdl)  THEN
      hParent = hMenubar.
    ELSE 
      hParent = btParentInstance.hdl.
  END.
  ELSE DO:
    lRebuild = TRUE.
    hParent = phParent. 
  END.
  
  ASSIGN
   lRule      = TRUE
   hUseParent = hParent. 
  FOR EACH btMenu WHERE btMenu.MenubarHdl    = hMenuBar
                  AND   btMenu.ParentMenuKey = pcMenuKey
           BY btMenu.MenubarHdl
           BY btMenu.ParentMenuKey
           BY btMenu.Mergeorder
           BY btMenu.Pageno 
           BY btMenu.hTarget
           BY btMenu.seq:
    IF NOT VALID-HANDLE(btMenu.Hdl) THEN
    DO:
      
      IF {fnarg actionControlType btMenu.NAME} = 'Placeholder' THEN
      DO:
        FOR EACH btInsertInstance 
                 WHERE btInsertInstance.hTarget     = TARGET-PROCEDURE
                 AND   btInsertInstance.PlaceHolder = btMenu.Name 
                 BY btInsertInstance.PlaceHolderSeq:
          DYNAMIC-FUNCTION('buildMenuBand':U IN TARGET-PROCEDURE,
                            hUseParent,
                            btInsertInstance.MenuKey).
        END.
      END.
      ELSE
      
      /* Add a rule back if */ 
      IF NOT lRule 
      AND btMenu.NAME = 'RULE':U
      AND btMenu.hTarget = hCurrentTarget 
      AND hUseParent:TYPE = 'sub-menu'
      AND hCurrentTarget <> ? THEN
        ASSIGN
          btMenu.Hdl   = {fnarg createRule hUseParent}
          lRule        = TRUE.           

    END.
    ELSE
    DO:
      IF  hParent:TYPE = 'sub-menu':U 
      AND btMenu.hTarget <> hCurrentTarget AND hcurrentTarget <> ? THEN
      DO:
        IF NOT lRule THEN
          {fnarg createRule hParent}.           
       
        IF lLinkAdded AND NOT lSubAdded THEN
        DO:
          IF pcMenuKey > ''  THEN
          DO:
            IF NUM-ENTRIES(pcMenuKey,{&pathDlm}) > 1 THEN
              ASSIGN
                cParentMenuKey = SUBSTR(pcMenuKey,1,R-INDEX(pcMenuKey,{&pathDlm}) - 1)
                cParent        = SUBSTR(pcMenuKey,R-INDEX(pcMenuKey,{&pathDlm}) + 1).
            ELSE
              ASSIGN
                cParentMenuKey = ''
                cParent        = pcMenuKey.
                           
            /* Find this band in the current/first toolbar and its label */ 
            FIND btBandMenu WHERE btBandMenu.MenubarHdl    = hMenuBar
                            AND   btBandMenu.ParentMenuKey = cParentMenuKey
                            AND   btBandMenu.NAME          = cParent
                            AND   btBandMenu.hTarget       = hCurrentTarget 
                            NO-ERROR.
            
            IF AVAIL btBandMenu THEN
            DO:
              /* If the current toolbar has non-ambiguous Label then 
                 we use it to identify conflicts when adding subbands below 
                (The label entry is set to blank if more than one target 
                 exists for a link) */
              cCurrentLabel = ENTRY(1,btBandMenu.ChildLabels).
              /* all links must have same label to be non-ambiguous */
              IF cCurrentLabel <> '':U THEN
              DO iLabel = 2 TO NUM-ENTRIES(btBandMenu.ChildLabels):
                /* set to blank if different labels to signal ambiguity */ 
                IF ENTRY(iLabel,btBandMenu.ChildLabels) <> cCurrentLabel THEN
                DO:
                  cCurrentLabel = ''.
                  LEAVE.
                END.
              END. /* do ilabel = 2 to numo1  */             
            END. /* if avail btBandMenu */
            /* Loop through sibling bands and create submenus for conflicts */ 
            FOR EACH btBandMenu WHERE btBandMenu.MenubarHdl    = hMenuBar
                                AND   btBandMenu.ParentMenuKey = cParentMenuKey
                                AND   btBandMenu.NAME          = cParent
                                AND   btBandMenu.hTarget       <> hCurrentTarget 
            BY btBandMenu.Mergeorder
            BY btBandMenu.Pageno 
            BY btBandMenu.hTarget:
         /* BY btBandMenu.seq  (not needed, one record per hTarget) */
      
              IF btBandMenu.HasLink AND VALID-HANDLE(btBandMenu.hTarget) THEN
              DO:
                {get createSubMenuOnConflict lCreateSub btBandMenu.hTarget}.
                IF lCreateSub THEN
                DO:
                  /* loop through labels and create submenus for each label 
                     that conflicts with current/first  */  
                  DO iLabel = 1 TO NUM-ENTRIES(btBandMenu.ChildLabels):
                    ASSIGN
                      cLabel = ENTRY(iLabel,btBandMenu.ChildLabels)
                      cLink  = ENTRY(iLabel,btBandMenu.ChildLinks).

                    /* We set label to blank to indicate multi-targets, as 
                       w do not support submenuing for those toolbars. In 
                       any case if the link-label is blank we cannot create a 
                       sub menu.. (cLink check issanity, should most 
                       definitely be set)*/    
                    IF cLabel > '':U AND cLink > '':U THEN
                    DO:
                      /* If the label matches the current label then there
                         is no conflict */
                      IF cCurrentLabel <> cLabel THEN
                      DO:
                        /* link + target is used as the id to find the subband
                           handle when we traverse the items in the outer 
                           for each */
                        ASSIGN 
                          cLinkToolbarId = cLink 
                                         + '-':U 
                                         + STRING(btBandMenu.hTarget)
                          iSub           = LOOKUP(cLabel,cSubLabels). 
                          .
                        
                        IF iSub = 0 THEN
                        DO:
                          /* create the submenu in the owner so trigger stays 
                             in synch. Then name is used to redefine the 
                             trigger correctly in moveMenu  */
                             
                          hSubHdl  = DYNAMIC-FUNCTION("createSubMenu":U IN btBandMenu.hTarget,
                                                       hParent,
                                                       cLabel + ':' + STRING(btBandMenu.hTarget),
                                                       cLabel,
                                                       TRUE). 

                          /* avoid double entries of subs with same labels */
                          cSubLabels    = cSubLabels 
                                        + (IF cSubLabels = '':U THEN '' ELSE ',')
                                        + cLabel.
                          cSubLabelHdls = cSubLabelHdls 
                                        + (IF cSubLabelHdls = '':U THEN '' ELSE ',')
                                        + STRING(hSubHdl).

                        END.
                        ELSE 
                          hSubHdl = WIDGET-HANDLE(ENTRY(iSub,cSubLabelHdls)).

                        ASSIGN
                          cSubList = cSubList 
                                   + (IF cSubList = '' THEN '' ELSE ',')
                                   + cLinkToolbarId
                          cSubHdls = cSubHdls 
                                   + (IF cSubHdls = '' THEN '' ELSE ',')
                                   + STRING(hSubHdl).
                      END. /* current <> label */
                    END. /* label > '' and link > '' */
                  END. /* loop through link labels  */ 
                  btBandMenu.SubHdls = cSubHdls.
                END. /* CreateSubMenuOnConflict */
              END. /* btBandMenu.hasLink */
            END. /* for each */
          END. /* pcMenuKey > '' */
          IF cSubList <> '' AND btMenu.NAME <> 'RULE':U THEN
            {fnarg createRule hParent}.           
          
          lSubAdded = TRUE.
        END. /* if lLinkAdded and not lSubAdded */
      END.   /* hCurrentTarget ne btMenu.hTarget */

      ASSIGN
        hCurrentTarget = btMenu.hTarget
        lNoAccelerator = FALSE
        lContainerLink = IF (btMenu.Link > '':U AND btMenu.Link <> 'ContainerToolbar-Target':U)
                         THEN FALSE 
                         ELSE TRUE.
      
      IF NOT lContainerLink THEN
      DO:
        ASSIGN
          lLinkAdded     = TRUE
          hUseParent     = hParent.
        IF lSubAdded THEN
        DO:
          ASSIGN 
            cLinkToolbarId = btMenu.Link + '-':U + STRING(btMenu.hTarget)
            iSub           = LOOKUP(cLinkToolbarId,cSubList). 
          IF iSub > 0 THEN
            ASSIGN 
              hUseParent      = WIDGET-HANDLE(ENTRY(iSub,cSubHdls))
              lNoAccelerator = TRUE.    
        END.
      END.
      ELSE IF btMenu.NAME = 'RULE':U THEN
      DO:
        IF lRule THEN
        DO:
          DELETE OBJECT btMenu.Hdl.
          btMenu.Hdl = ?.
          NEXT.
        END.
      END.
      /* if containerlink use the origianal parent */
      ELSE 
        hUseParent = hParent.

      IF NOT lRebuild AND btMenu.hTarget = TARGET-PROCEDURE THEN
        btMenu.hdl:PARENT = hUseParent NO-ERROR.
      ELSE
        DYNAMIC-FUNCTION('moveMenu':U IN TARGET-PROCEDURE,btMenu.Hdl,hUseParent). 

      /* Turn off accelerators for link */
      IF lNoAccelerator AND btMenu.Hdl:ACCELERATOR <> '' THEN
        btMenu.Hdl:ACCELERATOR  = ''.
      ASSIGN
          lRule = (btMenu.NAME = 'RULE':U).
    END.  /* valid btMenu.hdl*/
  END. /* for each */ 
  
  hRule = hParent:LAST-CHILD NO-ERROR. 

  DO WHILE VALID-HANDLE(hRule) AND hRule:TYPE = 'menu-item':U AND hRule:SUBTYPE = 'rule':
     hRuleDel = hRule.
     hRule = hRule:PREV-SIBLING. 
     DELETE OBJECT hRuleDel.
  END.

  DO iSub = 1 TO NUM-ENTRIES(cSubHdls):
    hSubMenu = WIDGET-HANDLE(ENTRY(isub,cSubHdls)) NO-ERROR. 
    IF VALID-HANDLE(hSubMenu) THEN
    DO:
      hRule = hSubMenu:LAST-CHILD NO-ERROR. 
      DO WHILE VALID-HANDLE(hRule) AND hRule:TYPE = 'menu-item':U AND hRule:SUBTYPE = 'rule':
        hRuleDel = hRule.
        hRule = hRule:PREV-SIBLING.
        DELETE OBJECT hRuleDel NO-ERROR.
      END.
    END.
  END.

  /** Keep this for debugging... (it's also educational, demonstrates sorting) 

  DEFINE VARIABLE cList AS CHARACTER  NO-UNDO.
  IF hparent = hMenubar  THEN
  DO:
    FOR EACH btMenu WHERE btMenu.MenubarHdl    = hMenuBar
                    AND   btMenu.ParentMenuKey = pcMenuKey
             BY btMenu.MenubarHdl
             BY btMenu.ParentMenuKey
             BY btMenu.Mergeorder
             BY btMenu.Pageno 
             BY btMenu.hTarget
             BY btMenu.seq:

   
     cList = cList 
       + (IF VALID-HANDLE(btMenu.hdl) THEN '' ELSE '->') 
       + (IF btMenu.hTarget = TARGET-PROCEDURE THEN 'New '  ELSE 'Old ')
       + btMenu.Caption
       + ' menukey: ' + (IF btMenu.ParentMenuKey= ? THEN '?' ELSE btMenu.Parentmenukey) 
       + ' mrg: ' + (IF btMenu.mergeorder = ? THEN '?' ELSE string(btMenu.Mergeorder)) 
       + ' pg: ' + (IF btMenu.PAgeno = ? THEN '?' ELSE string(btMenu.pageno)) 
       + ' hdl ' + STRING(btMenu.hTarget) 
       + ' seq: ' + STRING(btMenu.seq)
       +  (' ' + IF VALID-HANDLE(btMenu.hdl) THEN STRING(btMenu.hdl) ELSE '')
       + CHR(10)
       .

  END.
    
  MESSAGE
    'MENUBAR' STRING(hMenubar) SKIP
    cList VIEW-AS ALERT-BOX.
  END.
    **/
    
  

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-canFindAction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION canFindAction Procedure 
FUNCTION canFindAction RETURNS LOGICAL
  (pcAction AS CHAR):
/*------------------------------------------------------------------------------
  Purpose: Check if an action exist. 
    Notes:  
------------------------------------------------------------------------------*/
  {&findaction}
  RETURN AVAIL ttAction.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-canFindCategory) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION canFindCategory Procedure 
FUNCTION canFindCategory RETURNS LOGICAL
  (pcCategory AS CHAR):
/*------------------------------------------------------------------------------
  Purpose: Check if an action exist. 
    Notes:  
------------------------------------------------------------------------------*/
  RETURN findCategory(pcCategory,TARGET-PROCEDURE).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-categoryActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION categoryActions Procedure 
FUNCTION categoryActions RETURNS CHARACTER
  ( pcCategory AS CHAR ) :
/*------------------------------------------------------------------------------
   Purpose:  Returns the available actions for a specific category on this 
            toolbar master. 
Parameters: pcCategory - category name 
                       - blank is valid as it is used to find uncategorized 
                         actions  
                       - '*' All actions.              
     Notes: Used in the Instance Property dialog to select MenuBands
------------------------------------------------------------------------------*/
 DEFINE BUFFER bttBand        FOR ttBand.
 DEFINE BUFFER bttBandAction  FOR ttBandAction.
 DEFINE BUFFER bttToolbarBand FOR ttToolbarBand. 
 DEFINE VARIABLE cLogicalObject AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cActionList    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cType          AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cCategory      AS CHARACTER  NO-UNDO.

 IF pcCategory = xcNoCategory THEN
    pcCategory = '':U.

 {get LogicalObjectName cLogicalObject}.
 
 FOR 
 EACH bttToolbarband WHERE bttToolbarBand.toolbar = cLogicalObject,
 EACH bttBand WHERE bttBand.band = bttToolbarband.Band,
 EACH bttBandAction WHERE bttBandAction.Band = bttBand.band 
     BY (IF bttBand.Bandtype = 'Toolbar' OR bttBand.Bandtype = 'Menu&Toolbar' 
         THEN IF bttToolbarBand.alignment = 'Left' 
              THEN 1
              ELSE IF bttToolbarBand.alignment = 'Center' 
              THEN 2
              ELSE 3
          ELSE 4)
     BY bttBandAction.Sequence:  
   IF bttBandAction.ChildBand = '':U THEN
   DO:
     IF cCategory <> '*':U THEN
     DO:
       cCategory = {fnarg actionCategory bttBandAction.Action}.
     END.
     cType = {fnarg actionType bttBandAction.Action}.
     IF  (cCategory = '*':U OR cCategory = pcCategory)
     AND NOT CAN-DO('Separator,Placeholder':U,cType) 
     AND NOT CAN-DO(cActionList,bttBandAction.Action)  THEN
       cActionList = cActionList 
                   + (IF cActionList <> '':U THEN ',':U ELSE '':U) 
                   +  bttBandAction.Action.
   END.
 END.
 RETURN cActionList.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-categoryLink) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION categoryLink Procedure 
FUNCTION categoryLink RETURNS CHARACTER
  (pcCategory AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  FIND FIRST ttCategory WHERE ttCategory.Category = pcCategory NO-ERROR.
  RETURN IF AVAIL ttCategory THEN ttCategory.Link ELSE ?.
 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-checkRule) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION checkRule Procedure 
FUNCTION checkRule RETURNS LOGICAL
     ( pcRule    AS CHAR,
       phHandle  AS HANDLE,
       plDefault AS LOG) :
/*------------------------------------------------------------------------------
   Purpose: Check the rule of an action against the target 
Parameters: pcrule    - The rule 
            phHandle  - Handle of the dynamic Buffer with the rules OR  
                        the handle of the target.   
            plDefault - Default is used when function/property is not found
                        or if the function returns ?.
     Notes:  
IMPORTANT: This function is duplicated in the Panel super proc adm2/panel.p 
------------------------------------------------------------------------------*/    
DEFINE VARIABLE cAndDlm    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cOrDlm     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iAnd       AS INTEGER    NO-UNDO.
DEFINE VARIABLE iOr        AS INTEGER    NO-UNDO.
DEFINE VARIABLE cAndRule   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cOrRule    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFuncOp    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cCall      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cValueList AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cValue     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lOk        AS LOGICAL    NO-UNDO.
DEFINE VARIABLE hBuffer    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hField     AS HANDLE     NO-UNDO.
DEFINE VARIABLE cCheckType AS CHARACTER  NO-UNDO.
       
ASSIGN
  cCheckType = phHandle:TYPE
  cFuncOp    = '=':U
  cAndDlm    = CHR(1)
  cOrDlm     = CHR(2)
  pcRule     = REPLACE(pcRule,' and ':U,cAndDlm)
  pcRule     = REPLACE(pcRule,' or ':U,cOrDlm).
  
  OrLOOP:
  DO iOr = 1 TO NUM-ENTRIES(pcRule,cOrDlm):
    cOrRule = TRIM(ENTRY(iOr,pcRule,cOrDlm)).
    
    Andloop:
    DO iAnd = 1 TO NUM-ENTRIES(cOrRule,cAndDlm):
      ASSIGN
        cAndRule   = TRIM(ENTRY(iAnd,cOrRule,cAndDlm))
        cValuelist = (IF NUM-ENTRIES(cAndRule,cFuncOp) > 1 THEN
                      ENTRY(2,cAndRule,cFuncOp)
                      ELSE 'YES':U)
        cCall      = ENTRY(1,cAndRule,cFuncOp)
        cCall      = (IF INDEX(cCall,'(':U) > 0  
                      THEN ENTRY(1,cCall,'(':U)
                      ELSE 'get':U + cCall).
    

      IF cCheckType = 'BUFFER':U THEN
      DO:
        ASSIGN 
          hField = phHandle:BUFFER-FIELD(cCall)
          cValue = hField:BUFFER-VALUE NO-ERROR.
      END.
      ELSE 
        cValue = STRING(DYNAMIC-FUNCTION(cCall IN phHandle)) NO-ERROR.
      
      lOk = IF cValue  <> ? 
            THEN CAN-DO(cValueList,cValue)
            ELSE plDefault.          
      IF cCheckType = 'BUFFER':U AND NOT lok AND VALID-HANDLE(hField) AND hField:DATA-TYPE = 'logical':U THEN
      DO:
        IF cValue  = 'YES':U THEN 
          lok = CAN-DO(cValueList,'TRUE':U).
        ELSE IF cValue  = 'NO':U THEN 
          lok = CAN-DO(cValueList,'FALSE':U).
      END.

      IF lOk = FALSE THEN 
       LEAVE andloop.
    END.
    IF lOk THEN 
     LEAVE orLoop.
  END.

  RETURN lOk.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-constructMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION constructMenu Procedure 
FUNCTION constructMenu RETURNS LOGICAL
    ( ):         
/*------------------------------------------------------------------------------
  Purpose: Construct the toolbar from loaded data. 
    Notes: This will realize bands read from the repository 
           Non-repository toolbars are created with createToolbar. 
           Both uses createToolbarAction to realize the actions/widgets. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cActions          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLogicalObject    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lMenu             AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cHiddenMenuBands  AS CHARACTER  NO-UNDO.
 
  &SCOPED-DEFINE xp-assign
  {get Menu lMenu}
  {get LogicalObjectName cLogicalObject}
  {get HiddenMenuBands cHiddenMenuBands}.
  &UNDEFINE xp-assign
    /* run only once, (unless removed..) */
  FIND tBandInstance WHERE tBandInstance.MenuName = '':U
                     AND   tBandInstance.hTarget  = TARGET-PROCEDURE NO-ERROR.
  
  IF lMenu AND NOT AVAIL tBandInstance THEN
  DO:

    /* The toolbar bands stores data for a toolbar object (master) and 
       are loaded for the first instance */
    FOR 
    EACH ttToolbarBand 
     WHERE ttToolbarBand.Toolbar  = cLogicalObject
     AND  (LOOKUP (ttToolbarBand.Band,cHiddenMenuBands) = 0),
    EACH ttBand 
     WHERE ttBand.Band  = ttToolbarBand.Band  
     AND (ttBand.BandType = 'Menubar':U):

      CREATE tBandInstance.
      ASSIGN 
        tBandInstance.hdl      = {fn createMenuBar}
        tBandInstance.Band     = ttBand.Band
        tBandInstance.MenuName = '':U /* tells menu APIs to use menubar as
                                         parent */ 
        tBandInstance.MenuKey = '':U /* menubar is parent */

        tBandInstance.hTarget  = TARGET-PROCEDURE.
      {fnarg constructMenuBand ttBand.Band}.
    END.
    RETURN TRUE.
  END. 
  
  RETURN FALSE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-constructMenuBand) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION constructMenuBand Procedure 
FUNCTION constructMenuBand RETURNS LOGICAL
  (pcBand AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose: Create all items/subbandd for a band   
    Notes: Bands are only supported for Repository toolbars
------------------------------------------------------------------------------*/
  DEFINE BUFFER bttBand          FOR ttBand. 
  DEFINE BUFFER bttChildBand     FOR ttBand. 
  DEFINE BUFFER btParentInstance FOR tBandInstance.
  DEFINE BUFFER btBandInstance   FOR tBandInstance.
  DEFINE BUFFER bttBandAction    FOR ttBandAction.
  DEFINE BUFFER btMenu           FOR tMenu.
  DEFINE BUFFER btOldMenu        FOR tMenu.
  DEFINE BUFFER btParent         FOR tMenu.
  DEFINE BUFFER btBandMenu       FOR tMenu.
  DEFINE BUFFER btSubMenu        FOR tMenu.

  DEFINE VARIABLE cAction          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cHiddenMenuBands AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hMenu            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hMenuBar         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cControlType     AS CHAR       NO-UNDO.
  DEFINE VARIABLE cSecuredTokens   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hParent          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iSeq             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lUseParent       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iMergeOrder      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iPage            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cLink            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lContainerLink   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hSubParent       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cTargetList      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hToolbar         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cLabel           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTarget          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hUseParent       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cLinkHandles     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lUseOld          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lUseNew          AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cDeleteList      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDelete          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cNavigationTarget AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hContainerSrc     AS HANDLE     NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get MenuMergeOrder iMergeOrder}
  {get ObjectPage iPage}
  {get HiddenMenuBands cHiddenMenuBands}
  {get MenuBarHandle hMenuBar}
  .
  &UNDEFINE xp-assign

  DEFINE VARIABLE ldebug AS LOGICAL    NO-UNDO.
  
  FIND bttBand WHERE bttBand.Band = pcBand NO-ERROR.   
  
  IF NOT AVAIL bttBand THEN
    RETURN FALSE.
  
  FIND btParentInstance WHERE btParentInstance.Band    = pcBand 
                        AND   btParentInstance.hTarget = TARGET-PROCEDURE NO-ERROR.  
  IF NOT AVAIL btParentInstance THEN
    RETURN FALSE.
  
  IF NOT VALID-HANDLE(btParentInstance.hdl)  THEN
    hParent = hMenubar.
  ELSE 
    hParent = btParentInstance.hdl.
  
  IF btParentInstance.MenuName > '':U THEN
  DO:
    FIND btParent WHERE btParent.Name    = btParentInstance.MenuName 
                  AND   btParent.hTarget = TARGET-PROCEDURE NO-ERROR.
    
  END.
  
  FOR EACH bttBandAction WHERE bttBandAction.Band = bttBand.Band 
  BY bttBandAction.Sequence:
    
    IF bttBandAction.Childband <> '':U
    AND CAN-DO(cHiddenMenuBands,bttBandAction.ChildBand)  THEN
      NEXT.
    
    ASSIGN cAction  = bttBandAction.Action.

    /* Publish Event */
    {fnarg actionPublishCreate cAction}.     

    
    /* use default label if no label defined */
    IF cAction = '':U AND bttBandAction.ChildBand <> '':U THEN
    DO:
      FIND bttChildBand WHERE bttChildBand.Band = bttBandAction.ChildBand NO-ERROR.
      IF AVAIL bttChildBand THEN
        cAction = bttChildBand.BandLabelAction.
      
      /* The use of the band as action is a last resort and may have 
         undesired effects if a real action has the same name. 
         ( not likely to be a problem, as they probablky are similar 
         if the names are... )
         This will/should be removed when tools and/or repository ensures 
         this cannot happen */
      IF cAction = '' THEN
        cAction = bttBandAction.ChildBand. 
    END.
    /* This does not happen.. with current data and tools. 
       the check was really added to make the code above complete.  */
    IF cAction = '':U THEN
      NEXT.

    /* We log LastControlType during the loop to avoid double rules */
    cControlType = {fnarg actionControlType cAction}.
    cLink        = {fnarg actionLink cAction}.

    ASSIGN
      iSeq           = iSeq + 1
      lUseParent     = FALSE
      lContainerLink = cLink = '' OR cLink = ? OR cLink = 'ContainerToolbar-Target':U
      lUseOld        = FALSE
      lUseNew        = FALSE.
    
    IF cAction <> 'RULE':U THEN
    DO:
     
      IF lContainerLink THEN
      DO:
        FIND FIRST btOldMenu WHERE btOldMenu.MenubarHdl    = hMenuBar
                             AND   btOldMenu.ParentMenuKey = btParentInstance.MenuKey
                             AND   btOldMenu.NAME          = cAction 
                             AND VALID-HANDLE(btOldMenu.Hdl) NO-ERROR.
        IF AVAIL btOldMenu THEN 
        DO:

          /* A newer/later (this) toolbar decides the position, unless it is 
             the first item on the toolbar in which case it should stay where it 
             is
             --
             The code below is simply a GE expression.. (simply..NOT...) 
             The main issue is that mergeorder 0 is stored as ? in order 
             to sort high.... (Possible improvement is to store 0 as 999999 
             or whatever the highest integer is. or use a for each and leave,
             but then we would lose the unofficial record of having the longest
             GE expression ever written.) */  
          IF ((btOldMenu.MergeOrder > iMergeOrder OR btOldMenu.Mergeorder = ?)
               AND 
               iMergeOrder <> 0
             ) THEN 
          DO:
            IF iSeq = 1 THEN 
              lUseNew = TRUE.
            ELSE 
              lUseold = TRUE.
          END.
          ELSE
          IF (btOldMenu.MergeOrder = iMergeOrder 
              OR (btOldMenu.MergeOrder = ? AND iMergeOrder = 0)
             )
             AND btOldMenu.Pageno > iPage THEN
          DO:
            IF iSeq = 1 THEN 
              lUseNew = TRUE.
            ELSE 
              lUseold = TRUE.
          END.
          ELSE
          IF (btOldMenu.MergeOrder = iMergeOrder 
              OR (btOldMenu.MergeOrder = ? AND iMergeOrder = 0)
             )
             AND btOldMenu.Pageno = iPage 
             AND INT(btOldMenu.htarget) > INT(TARGET-PROCEDURE) THEN
          DO:
            IF iSeq = 1 THEN 
              lUseNew = TRUE.
            ELSE 
              lUseold = TRUE.
          END.
          ELSE IF iSeq = 1 THEN
            lUseOld = TRUE.
          ELSE
            lUseNew = TRUE.
        END.
      END. /* container link */
    END.
    
    hMenu = DYNAMIC-FUNCTION('createMenuAction':U IN TARGET-PROCEDURE,
                              btParentInstance.Band,
                              cAction). 

    IF VALID-HANDLE(hMenu) THEN
    DO:
      IF AVAIL btParent AND NOT lContainerLink THEN
      DO: 
        btParent.HasLink = TRUE. 
        IF LOOKUP(cLink,btParent.ChildLinks) = 0 THEN
        DO:
          /* Default in case no link etc (design time).. */ 
          {get ObjectName cLabel}.
          cLinkHandles = DYNAMIC-FUNCTION("linkHandles":U IN TARGET-PROCEDURE, cLink) NO-ERROR.
          IF NUM-ENTRIES(cLinkHandles) = 1 THEN
          DO:        
            hTarget = WIDGET-HANDLE(cLinkHandles).
            IF cLink = 'Navigation-target':U THEN
            DO:
              {get NavigationTargetName cNavigationTarget}.
              IF cNavigationtarget > '':U THEN
                hTarget = {fnarg DataObjectHandle cNavigationTarget hTarget} NO-ERROR.
            END.
            IF VALID-HANDLE(hTarget) THEN
              {get LABEL cLabel hTarget}.
              /* labels and links are synchronized, so ChildLinks is used
                 to identify first entry in both cases .. */ 
          END.
          /* Blank out the label for multi-targets, we're not going to add 
             sun menus for it */ 
          ELSE IF NUM-ENTRIES(cLinkHandles) > 1 THEN
            cLabel = ''.
          
          ASSIGN
            btParent.ChildLabels = btParent.ChildLabels 
                                 + (IF btParent.ChildLinks = '' THEN '' ELSE ',':U)  
                                 + cLabel
            btParent.ChildLinks  = btParent.ChildLinks 
                                 + (IF btParent.ChildLinks = '' THEN '' ELSE ',':U)
                                 + cLink.
        END. /* lookup(clink,childLinks) = 0 */
      END. /* avail parent */
          
      IF bttBandAction.Childband <> '':U THEN
      DO:
        IF VALID-HANDLE(hMenu) THEN
        DO:
          CREATE tBandInstance.
          ASSIGN 
            tBandInstance.Band      = bttBandAction.Childband
            tBandInstance.hdl       = hMenu
            tBandInstance.MenuName  = cAction 
            tBandInstance.MenuKey   = btParentinstance.MenuKey 
                                      + (IF btParentInstance.MenuKey = ''
                                         THEN ''
                                         ELSE {&pathdlm})
                                      + cAction
            tBandInstance.hTarget   = TARGET-PROCEDURE.
          DYNAMIC-FUNCTION('constructMenuBand':U IN TARGET-PROCEDURE,       
                            bttBandAction.ChildBand).          
        END.
      END.
      
      /* We have a duplicate .. get rid of the old widget  */
      IF lUseOld OR lUseNew THEN
      DO:
      
        /* Postpone delete of the last menu on the menubar to avoid 
           earthquake eh. screenquake .. windowquake*/  
        IF btOldMenu.Hdl:PARENT = hMenuBar 
        AND hMenuBar:FIRST-CHILD = btOldMenu.Hdl 
        AND hMenuBar:LAST-CHILD  = btOldMenu.Hdl THEN
          hDelete = btOldMenu.Hdl.
        ELSE
          DELETE OBJECT btOldMenu.Hdl. 

        /* Keep the old position, so give the new handle to the old record */ 
        IF lUseold THEN
        DO:
          FIND btMenu WHERE btMenu.NAME    = cAction
                      AND   btMenu.hTarget = TARGET-PROCEDURE.

          ASSIGN
            btOldMenu.Hdl = btMenu.Hdl
            btMenu.Hdl    = ?.
          /* We currently add the trigger back to match the target in the tMenu 
             TT. This will probably be moved into createMenuAction where it 
             will be easier to avoid creating the new if old is to be used */
          IF btOldMenu.Hdl:TYPE = 'menu-item':U AND btOldMenu.Hdl:SUBTYPE = 'normal':U THEN
          DO:
            IF btOldMenu.Hdl:TOGGLE-BOX THEN
              ON VALUE-CHANGED OF btOldMenu.Hdl 
                 PERSISTENT RUN OnValueChanged IN btOldMenu.hTarget(btOldMenu.Hdl:NAME).
            ELSE
              ON CHOOSE OF btOldMenu.Hdl
                PERSISTENT RUN OnChoose IN btOldMenu.hTarget(btOldMenu.Hdl:NAME).
          END.
          ELSE IF btOldMenu.Hdl:TYPE = 'sub-menu':U THEN
            ON MENU-DROP OF btOldMenu.Hdl 
             PERSISTENT RUN OnMenuDrop IN btOldMenu.hTarget(btOldMenu.Hdl:NAME).
        END. /* use old  */
        /* else if keep new, set the old handle invalid */  
        ELSE 
          btOldMenu.Hdl = ?.
      END.
    END. /* if valid-handle */
    ELSE IF cControlType = 'placeholder':U THEN 
      DYNAMIC-FUNCTION('constructObjectMenus':U IN TARGET-PROCEDURE,
                        pcBand,
                        bttBandAction.Action,
                        TRUE).               
  END.  /* for each btBandaction */

  /* Build the physical menus, unless this is a band directly inserted on a 
     placeholder (These bands will be built when buildMenuBand is called for 
     the parent of the placeholder) */ 
  IF btParentInstance.placeholder = '' THEN
  /* use menukey as this builds menus for all targets in menubar*/ 
  DYNAMIC-FUNCTION('buildMenuBand':U IN TARGET-PROCEDURE,?,btParentInstance.MenuKey).

  IF VALID-HANDLE(hDelete) THEN
    DELETE OBJECT hDelete.
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-constructObjectMenus) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION constructObjectMenus Procedure 
FUNCTION constructObjectMenus RETURNS LOGICAL
  ( pcBand  AS CHAR,
    pcPlaceholder AS CHAR, 
    plBlank AS LOG ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER bttObjectBand        FOR ttObjectBand. 
  DEFINE BUFFER bttBand              FOR ttBand. 
  DEFINE BUFFER btParentInstance     FOR tBandInstance.
  DEFINE BUFFER btBandInstance       FOR tBandInstance.
  
  DEFINE VARIABLE cObjectList   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectName   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRunAttribute AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iPlaceholder  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cAction       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hMenubar      AS HANDLE     NO-UNDO.

  FIND bttBand WHERE bttBand.Band = pcBand NO-ERROR. 
  
  IF NOT AVAIL bttBand THEN
    RETURN FALSE.

  FIND btParentInstance WHERE btParentInstance.Band    = pcBand 
                        AND   btParentInstance.hTarget = TARGET-PROCEDURE NO-ERROR.  
  cObjectList = {fnarg supportedObjects YES}.
  
  {get MenuBarHandle hMenuBar}.

  DO i = 1 TO NUM-ENTRIES(cObjectList):
    ASSIGN
      cObjectName   = ENTRY(i,cObjectList)
      cRunAttribute = (IF NUM-ENTRIES(cObjectName,';':U) > 1 
                       THEN ENTRY(2,cObjectName,';':U)
                       ELSE '':U)
      cObjectName   = ENTRY(1,cObjectName,';':U).

    DO iPlaceHolder = 1 TO IF plBLank THEN 2 ELSE 1:
      FOR EACH bttObjectBand 
          WHERE bttObjectBand.Action       = (IF iPlaceHolder = 1
                                              THEN pcPlaceholder
                                              ELSE '':U)
          AND   bttObjectBand.ObjectName   = cObjectName
          AND   bttObjectBand.RunAttribute = cRunAttribute,

         EACH bttBand WHERE bttBand.Band = bttObjectBand.Band
          BY bttObjectBand.ObjectName
          BY bttObjectBand.Sequence:
        
        /* Ensure band are only added once for each object 
           (two toolbars could have placeholders) */
        IF NOT CAN-FIND(FIRST btBandInstance 
                          WHERE btBandInstance.MenubarHdl = hMenubar
                          AND   btBandInstance.ObjectName = bttObjectBand.ObjectName
                          AND   btBandInstance.Band       = bttObjectBand.Band) THEN
        DO:
         
  
          /* separate with rule if on submenu */
          IF btParentInstance.Hdl:TYPE <> 'menu':U THEN           
            DYNAMIC-FUNCTION('createMenuAction':U IN TARGET-PROCEDURE,
                              bttBand.Band,
                             'RULE':U).
           
          /* The use of the band as action is a last resort and may have 
             undesired effects if a real action has the same name. 
             ( not likely to be a problem, as they probablky are similar 
             if the names are... )
             This will/should be removed when tools and/or repository ensures 
             this cannot happen */
          cAction = IF bttBand.BandLabelAction <> ''
                    THEN bttBand.BandLabelAction
                    ELSE bttBand.Band.
          
          CREATE btBandInstance.
          ASSIGN 
            btBandInstance.Band       = bttBand.Band
            btBandInstance.hTarget    = TARGET-PROCEDURE
            btBandInstance.MenuName   = bttBand.BandLabelAction 
            btBandInstance.MenuKey    = btParentinstance.MenuKey
                                      + (IF btParentInstance.MenuKey = ''
                                         THEN ''
                                         ELSE {&pathdlm})
                                      + cAction
            /* for the can-find above  */
            btBandInstance.MenubarHdl = hMenubar
            btBandInstance.ObjectName = bttObjectBand.ObjectName
            .
  
          /* If insertSubMenu add the Band on the place holder as a submenu */
          IF bttObjectBand.InsertSubmenu THEN
            btBandInstance.Hdl = DYNAMIC-FUNCTION('createMenuAction':U IN TARGET-PROCEDURE,
                                                   btParentinstance.Band,
                                                   cAction). 
  
          ELSE
            ASSIGN 
              btBandInstance.Placeholder    = pcPlaceHolder
              btBandInstance.PlaceholderSeq = bttObjectBand.Sequence
              btBandInstance.Hdl            = btParentInstance.hdl.
  
          DYNAMIC-FUNCTION('constructMenuBand':U IN TARGET-PROCEDURE,       
                            bttBand.Band).
        END. /* not can-find (band object menubar) */
      END. /* for each bttObjectband */
    END. /* do loop twice (unamed and named place holders) */
  END.

  RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-constructToolbar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION constructToolbar Procedure 
FUNCTION constructToolbar RETURNS LOGICAL
    ( ):         
/*------------------------------------------------------------------------------
  Purpose: Construct the toolbar from loaded repository data. 
    Notes: This will realize bands read from the repository 
           Non-repository toolbars are created with createToolbar. 
           Both uses createToolbarAction to realize the actions/widgets. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cActions            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLogicalObject      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lShowBorder         AS LOG        NO-UNDO. 
  DEFINE VARIABLE iPosition           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iToolbarHeightPxl   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iToolSeparatorPxl   AS INTEGER    NO-UNDO.  
  DEFINE VARIABLE lToolbar            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lActions            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lAnyActions         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE dMinWidth           AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dMinHeight          AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cHiddenToolbarBands AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hButton             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cSecuredTokens      AS CHARACTER     NO-UNDO.
  
  &SCOPED-DEFINE xp-assign
  {get Toolbar lToolbar}
  {get ToolSeparatorPxl iToolSeparatorPxl}
  {get LogicalObjectName cLogicalObject}
  {get ToolBarHeightPxl iToolBarHeightPxl}
  {get ShowBorder lShowBorder}
  {get HiddenToolbarBands cHiddenToolbarBands}
  {get SecuredTokens cSecuredTokens}
  {set MinWidth  0}
  {set MinHeight 0} 
  {set ToolMaxWidthPxl  0}.
  &UNDEFINE xp-assign

  ASSIGN 
    iPosition = iToolSeparatorPxl
              + (If lShowBorder THEN 2 ELSE 0).  
  
  /* The toolbar bands stores data for a toolbar object (master) and are loaded 
     for the first instance */
  IF lToolbar THEN
  DO:
    FOR 
    EACH ttToolbarBand 
       WHERE ttToolbarBand.toolbar  = cLogicalObject
       AND  (LOOKUP (ttToolbarBand.Band,cHiddenToolbarBands) = 0),
    EACH ttBand 
       WHERE ttBand.Band  = ttToolbarBand.Band  
       AND (ttBand.BandType = 'Toolbar':U 
            OR
            ttBand.BandType = 'Menu&Toolbar':U)
    BY (IF ttToolbarBand.Alignment = 'Left':U         THEN 1
        ELSE IF ttToolbarBand.Alignment = 'Center':U  THEN 2
        ELSE                                               3)
    BY ttToolbarBand.Sequence:
      
      IF lActions AND ttToolbarBand.InsertRule THEN 
      DO:
        IF lShowborder THEN
           DYNAMIC-FUNCTION('createToolbarAction':U IN TARGET-PROCEDURE,
                            ttToolbarBand.Band,
                            'RULE':U,
                            INPUT-OUTPUT iPosition). 
        ELSE
           iPosition = iPosition + iToolSeparatorPxl.  
         lActions = FALSE.
      END.

      FOR EACH ttBandAction 
        WHERE ttBandAction.Band = ttBand.Band 
      BY ttBandAction.Sequence:  
      
        IF cSecuredTokens <> '':U 
            AND CAN-DO(cSecuredTokens,{fnarg actionSecuredToken ttBandAction.Action}) 
            OR  CAN-DO(cSecuredTokens,ttBandAction.Action) THEN 
        NEXT.

        /* Publish Event */
        {fnarg actionPublishCreate ttBandAction.Action}.     

       
        hButton = DYNAMIC-FUNCTION('createToolbarAction':U IN TARGET-PROCEDURE,
                                    ttToolbarBand.Band,
                                    ttBandAction.Action,
                                    INPUT-OUTPUT iPosition). 
        
        IF NOT lActions THEN
          lActions = VALID-HANDLE(hButton).
        IF NOT lAnyActions THEN
          lAnyActions = VALID-HANDLE(hButton).
      END.
    END.
    
    IF lAnyActions THEN
    DO:
      {fn createToolbarBorder}.
    
      &SCOPED-DEFINE xp-assign
      {get MinWidth  dMinWidth} 
      {get MinHeight dMinHeight}.
      &UNDEFINE xp-assign

      RUN resizeObject IN TARGET-PROCEDURE(dMinHeight,dMinWidth).
      {fn adjustActions}.
    END.
  END.
  
  RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-create3DRule) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION create3DRule Procedure 
FUNCTION create3DRule RETURNS HANDLE
  (              phParent     AS HANDLE,     /* handle to the parent frame */
    INPUT-OUTPUT piXY         AS INTEGER    /* the x - posistion */                 
  ) :
/*------------------------------------------------------------------------------
  Purpose: Create a separator between toolbasr actions in the forma of a rectangle
Parameters: INPUT        phParent - Frame handle.
            INPUT-OUTPUT piX      - in X position - out used X and + height-p 
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE hTmp              AS HANDLE NO-UNDO.

DEFINE VARIABLE iToolSeparatorPxl     AS INTEGER NO-UNDO.
DEFINE VARIABLE iToolWidthPxl         AS INTEGER NO-UNDO.
DEFINE VARIABLE iToolHeightPxl        AS INTEGER NO-UNDO.
DEFINE VARIABLE iToolSpacingPxl       AS INTEGER NO-UNDO.
DEFINE VARIABLE iToolMarginPxl        AS INTEGER    NO-UNDO.
DEFINE VARIABLE cToolbarDrawDirection AS CHARACTER  NO-UNDO.  
DEFINE VARIABLE iEdgePixels           AS INTEGER    NO-UNDO.
DEFINE VARIABLE lShowBorder           AS LOGICAL    NO-UNDO.

&SCOPED-DEFINE xp-assign
{get ToolbarDrawDirection cToolbarDrawDirection}
{get ToolSeparatorPxl     iToolSeparatorPxl}
{get ToolWidthPxl         iToolWidthPxl}
{get ToolHeightPxl        iToolHeightPxl}
{get ToolMarginPxl        iToolMarginPxl}
{get EdgePixels           iEdgePixels}
{get ShowBorder           lShowBorder}.
&UNDEFINE xp-assign

 CREATE RECTANGLE  hTmp 
    ASSIGN FRAME         = phParent
           GRAPHIC-EDGE  = TRUE
           FILLED        = FALSE
           X             = 0
           Y             = 0
           EDGE-PIXELS   = 2
           WIDTH-PIXELS  = (IF cToolbarDrawDirection BEGINS "v":U 
                            THEN iToolWidthPxl  
                            ELSE (IF iEdgePixels = 1 THEN 1 ELSE 2))
           HEIGHT-PIXELS = (IF cToolbarDrawDirection BEGINS "v":U 
                            THEN (IF iEdgePixels = 1 THEN 1 ELSE 2)
                            ELSE iToolHeightPxl) 
           HIDDEN        = TRUE. 
      /* piX + iToolWidthPxl > phParent:WIDTH-PIXELS */
 IF cToolbarDrawDirection BEGINS "v":U THEN
 DO:
   ASSIGN 
     hTmp:X  = (IF iToolMarginPxl < 2 AND lShowBorder 
                THEN 2 
                ELSE iToolMarginPxl)
     hTmp:Y  = piXY + iToolSeparatorPxl 
     hTmp:HIDDEN = FALSE  NO-ERROR. 
   piXY = hTmp:Y + hTmp:HEIGHT-P + iToolSeparatorPxl.
 END.
 ELSE
 DO:
   ASSIGN
     hTmp:Y  = (IF iToolMarginPxl < 2 AND lShowBorder 
                THEN 2 
                ELSE iToolMarginPxl) 
     hTmp:X  = piXY + iToolSeparatorPxl 
     hTmp:HIDDEN = FALSE  NO-ERROR. 
   piXY = hTmp:X + hTmp:WIDTH-P + iToolSeparatorPxl.
 END. 
 
 RETURN hTmp.     

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createButton) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createButton Procedure 
FUNCTION createButton RETURNS HANDLE
  (              phFrame      AS HANDLE,
    INPUT-OUTPUT piXY         AS INTEGER, 
                 pcName       AS CHARACTER,
                 pcLabel      AS CHARACTER,
                 pcTooltip    AS CHARACTER,
                 pcImage      AS CHARACTER,  
                 plSensitive  AS LOGICAL  ) :
/*------------------------------------------------------------------------------
  Purpose: Create a button 
Parameters: 
  INPUT          phParent    - handle    - parent frame
  INPUT-OUTPUT   piX         - integer   - in X position - out X + height-p 
  INPUT          pcName      - character - the name of the button
  INPUT          pcLabel     - character - the label
  INPUT          pcCaption   - character - the tooltip of the button  
  INPUT          pcBitmap    - character - the bitmap of the button  
  INPUT          plSensitive - logical   - Yes if the button should be sensitive 
    Notes:  Creates a persistent trigger ON CHOOSE that runs onChoose(pcName).  
------------------------------------------------------------------------------*/

DEFINE VARIABLE hTmp              AS HANDLE NO-UNDO.

DEFINE VARIABLE iTextWidthPxl         AS INTEGER    NO-UNDO.
DEFINE VARIABLE iToolSpacingPxl       AS INTEGER    NO-UNDO.
DEFINE VARIABLE iToolSeparatorPxl     AS INTEGER    NO-UNDO.
DEFINE VARIABLE iToolWidthPxl         AS INTEGER    NO-UNDO.
DEFINE VARIABLE iToolHeightPxl        AS INTEGER    NO-UNDO.
DEFINE VARIABLE iToolMaxWidthPxl      AS INTEGER    NO-UNDO.
DEFINE VARIABLE iToolMarginPxl        AS INTEGER    NO-UNDO.
DEFINE VARIABLE lShowBorder           AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cUIBmode              AS CHAR       NO-UNDO.
DEFINE VARIABLE cToolbarDrawDirection AS CHARACTER  NO-UNDO.  
DEFINE VARIABLE lImageLoad            AS LOGICAL    NO-UNDO.

&SCOPED-DEFINE xp-assign
{get ToolSpacingPxl       iToolSpacingPxl}
{get ToolSeparatorPxl     iToolSeparatorPxl}
{get ToolWidthPxl         iToolWidthPxl}
{get ToolHeightPxl        iToolHeightPxl}
{get ToolMarginPxl        iToolMarginPxl}
{get ShowBorder           lShowBorder}
{get ToolbarDrawDirection cToolbarDrawDirection}.
&UNDEFINE xp-assign

 CREATE BUTTON hTmp
    ASSIGN NO-FOCUS = TRUE
           FRAME    = phFrame
           NAME     = pcName
           LABEL    = pcLabel
           FLAT-BUTTON   = TRUE /*GetFlatButtons()*/
           HEIGHT-PIXELS = iToolHeightPxl
           TOOLTIP       = pcTooltip
           WIDTH-PIXELS  = iToolWidthPxl
           SENSITIVE     = plSensitive
           HIDDEN        = FALSE.
 IF pcImage > "" THEN
    lImageLoad = LoadImage(INPUT hTmp, INPUT pcImage).

 /* If this is a text button, reset the width to be the width of text and if
    necessary, reset toolbar max width to width of this label */ 
 IF NOT lImageLoad or pcImage = ? OR pcImage = "" THEN
 DO:
   /* Work out width of text  */
   iTextWidthPxl = FONT-TABLE:GET-TEXT-WIDTH-PIXELS(pcLabel) + 6. 
   
   /* Ensure not smaller than normal button */
   IF iTextWidthPxl < iToolWidthPxl THEN 
      iTextWidthPxl = iToolWidthPxl. 
   /* set this width equal to text width */
   iToolWidthPxl = iTextWidthPxl.   
   /* get current max tool width */
   {get ToolMaxWidthPxl iToolMaxWidthPxl}.                                   
   /* and reset to this width if this width is greater */
   IF iTextWidthPxl > iToolMaxWidthPxl THEN                                   
   DO:
     iToolMaxWidthPxl = iTextWidthPxl.
     {set ToolMaxWidthPxl iToolMaxWidthPxl}.
   END.
   ASSIGN hTmp:HEIGHT-PIXELS = iToolHeightPxl
          hTmp:WIDTH-PIXELS  = iToolWidthPxl NO-ERROR.
 END. 
 
 IF cToolbarDrawDirection BEGINS "v":U THEN
 DO:
   ASSIGN hTmp:Y         = piXY
          hTmp:X         = IF iToolMarginPxl < 2 AND lShowBorder 
                           THEN 2 
                           ELSE iToolMarginPxl
          hTmp:SENSITIVE = plSensitive 
          piXY           = piXY + iToolHeightPxl + iToolSpacingPxl
          NO-ERROR.  /* Error will be checked when frame:hidden = false in
                        initializeobject */ 
 END.
 ELSE
 DO:
   ASSIGN hTmp:X         = piXY
          hTmp:Y         = IF iToolMarginPxl < 2 AND lShowBorder 
                           THEN 2 
                           ELSE iToolMarginPxl
          hTmp:SENSITIVE = plSensitive 
          piXY           = piXY + iToolWidthPxl + iToolSpacingPxl
          NO-ERROR.  /* Error will be checked when frame:hidden = false in
                        initializeobject */ 
 END. /* horizontal */

 /* No triggers or sensitive actions at design time */
 {get UIBMode cUIBMode}.
  
 IF cUIBMode <> "Design":U THEN
   ON CHOOSE OF hTmp 
     PERSISTENT RUN OnChoose IN TARGET-PROCEDURE (pcName).
 ELSE /* disable at design time */ 
   hTmp:SENSITIVE = FALSE.

 RETURN hTmp.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createMenuAction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createMenuAction Procedure 
FUNCTION createMenuAction RETURNS HANDLE
  ( pcParent AS CHAR,
    pcAction AS CHAR) :
/*------------------------------------------------------------------------------
   Purpose: Create a menu action widget
Parameters: pcParent 
              Repository     - The name of the created parent band
              Non repository - The unique action name of an already created 
                               parent
                             - Blank means that this is the top level(menu-bar)
            pcAction - action name                                        
     Notes: For non-repository objects this is called from buildMenu inside 
            a for each tMenu.  
            Repository objects calls this from constructMenuBand before the
            TT is created and createFindMenuTT finds or creates the tMenu record                           
------------------------------------------------------------------------------*/
  DEFINE BUFFER btMenu FOR tMenu.
  DEFINE BUFFER btParent FOR tMenu.
  DEFINE BUFFER btChild  FOR tMenu.
  DEFINE BUFFER btParentInstance FOR tBandInstance. 
  DEFINE BUFFER btBandInstance   FOR tBandInstance. 

  DEFINE VARIABLE hParent          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cType            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lChecked         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lUseRepository   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cDisabledActions AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cHiddenActions   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cControlType     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cParentMenu      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLinkTargetNames AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCaption         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hMenuBar         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iMergeOrder      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iPage            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cSecuredTokens   AS CHARACTER  NO-UNDO.

  {get HiddenActions cHiddenActions}.
  IF CAN-DO(cHiddenActions,pcAction) THEN
     RETURN ?.
  
  {get UseRepository lUseRepository}.
  IF lUseRepository THEN
  DO:
 
    IF {fnarg actionCategoryIsHidden pcAction} THEN
      RETURN ?.
    
    FIND btParentInstance WHERE btParentInstance.Band     = pcParent 
                           AND  btParentInstance.hTarget  = TARGET-PROCEDURE
    NO-ERROR. 
    
    IF NOT AVAIL btParentInstance THEN
      RETURN ?.
    
    &SCOPED-DEFINE xp-assign
    {get MenubarHandle hMenuBar}
    {get menuMergeOrder iMergeOrder}
    {get ObjectPage iPage}
    {get SecuredTokens cSecuredTokens}
    .
    &UNDEFINE xp-assign

    {&findaction}
    IF cSecuredTokens <> '':U 
    AND (CAN-DO(cSecuredTokens,(IF AVAIL ttAction THEN ttAction.SecurityToken ELSE '')) 
         OR  
         CAN-DO(cSecuredTokens,pcAction)) THEN 
      RETURN ?.

    /* Only ONE entry of each action per band per toolbar, except for RULE. */
    IF pcAction <> "RULE":U THEN
    DO:
      FIND btMenu WHERE btMenu.hTarget       = TARGET-PROCEDURE  
                  AND   btMenu.NAME          = pcAction
                  AND   btMenu.PARENT        = btParentInstance.MenuName 
       /* parent and parentmenukey is somewhat reduntant, but parentmenukey 
          could be more precise as it would ensure that children with similar 
          parents, but different grandparents does not see each other 
          as duplicates. But as long as this API is using Parent,name
          this decides what's unique across the toolbar.               
                  AND   btMenu.ParentMenukey = btParentInstance.MenuName
          */
                  NO-ERROR. 
      /* valid or not.. return unknown */
      IF AVAIL btMenu THEN
        RETURN ?.
    END. /* not rule */

    CREATE btMenu.
    ASSIGN 
      btMenu.Caption        = {fnarg actionCaption pcAction}
      btMenu.hTarget        = TARGET-PROCEDURE 
      btMenu.Name           = pcAction
      btMenu.Sensitive      = FALSE
      btMenu.ParentMenuKey  = btParentInstance.MenuKey
      btMenu.Parent         = pcParent /*btParentInstance.MenuName*/
      btMenu.Seq            = btParentInstance.LastSeq + 1
      btParentInstance.LastSeq = btMenu.Seq
      btMenu.Link           = (IF AVAIL ttAction THEN ttAction.Link ELSE '')
      btMenu.PageNo         = iPage
      btMenu.MergeOrder     = (IF iMergeOrder > 0 THEN iMergeOrder ELSE ?)
      btMenu.MenuBarhdl     = hMenuBar
      hParent                  = ?. 
    
  END.
  ELSE DO:
     IF pcParent = '':U THEN
       {get menubarHandle hParent}.
     ELSE
     DO:
       FIND btParent WHERE btParent.Name    = pcParent
                     AND   btParent.hTarget = TARGET-PROCEDURE NO-ERROR.
       IF NOT AVAIL btParent THEN
         RETURN ?.
       hParent = btParent.Hdl. 
     END.

     /* 'Rule' is not unique so find last that has not been created as a 
        widget  (index has sequence as last component) */ 
     FIND LAST btMenu WHERE btMenu.Parent  = pcParent 
                      AND   btMenu.Name    = pcAction 
                      AND   btMenu.hTarget = TARGET-PROCEDURE
                      AND   btMenu.hdl     = ? NO-ERROR.
                      
     {&findaction}
     
  END.
   

  IF AVAIL btMenu AND btMenu.Link > "":U THEN
  DO:
    {get LinkTargetNames cLinkTargetNames}.
    IF NUM-ENTRIES(btMenu.Link,"-":U) > 1 
       AND ENTRY(2,btMenu.Link,"-":U) = "target":U
       AND NOT CAN-DO(cLinkTargetNames,btMenu.Link) THEN 
    DO:
       cLinkTargetNames = cLinkTargetNames
                        + (IF cLinkTargetNames = "":U THEN "":U ELSE ",":U) 
                        + btMenu.Link.
       {set LinkTargetNames cLinkTargetNames}.
    END.
  END.
  
  {get DisabledActions cDisabledActions}.
  
  IF pcAction = "RULE":U THEN
    ASSIGN
     btMenu.Hdl = DYNAMIC-FUNCTION("createRule":U IN TARGET-PROCEDURE,
                                    hParent). 
   
  ELSE
  DO:
    ASSIGN   /* non existing actions are treated as labels for repository */
      cControlType     = (IF AVAIL ttAction 
                          THEN ttAction.ControlType 
                          ELSE IF lUseRepository THEN 'Label' ELSE ?)
      cType            = (IF AVAIL ttAction THEN ttAction.Type ELSE ?) 
      btMenu.Disabled  = (IF AVAIL ttAction THEN ttAction.DISABLED ELSE FALSE) 
      btMenu.Refresh   = CAN-DO("run,property":U,cType).
    
    IF CAN-DO("RUN,PUBLISH,LAUNCH":U, cType) 
        /* if it don't exist it has just been added wih insertMenu,
           in that case we make it a menu-item if it has a parent.
           (the user must override onChoose to react on it) */
    OR (pcParent <> "":U AND NOT AVAIL ttAction AND NOT lUseRepository) THEN
    DO:
      
      ASSIGN 
        btMenu.Sensitive = IF btMenu.Disabled OR CAN-DO(cDisabledActions,btMenu.Name)
                           THEN FALSE 
                           /* keep value if already sensitized  */
                           ELSE IF btMenu.Sensitive THEN TRUE
                           ELSE IF cType = "RUN":U 
                              /* CanRun checks disabled actions */
                           THEN {fnarg actionCanRun btMenu.Name}
                           ELSE IF cType = "LAUNCH":U 
                           THEN TRUE
          /* This has really nothing to do with repository, it's just that we use a
             different default since non-repository need strict backwards compatibility
             while the use of repository makes it so easy to override this with no code
             that it makes sense to have a more sensible default. 
             NOTE: the default must match the craatetoolbarAction setting of tbutton as 
                   resetTargetActions just checks tButton to see if this is a change */
                           ELSE lUseRepository
                                   
        btMenu.Hdl = DYNAMIC-FUNCTION
                  ("createMenuItem":U IN TARGET-PROCEDURE,
                   hParent,
                   btMenu.Name,
                   DYNAMIC-FUNCTION ("actionCaption":U IN TARGET-PROCEDURE,
                                      btMenu.Name),
                   IF AVAIL ttAction THEN ttAction.ACCELERATOR ELSE ?,
                   btMenu.Sensitive
                  ). 
    END.

    ELSE IF cType = "PROPERTY":U THEN
    DO:
      ASSIGN
        lChecked = {fnarg actionChecked btMenu.Name}  
        btMenu.Sensitive = (lChecked <> ?) AND NOT btMenu.Disabled                             
        btMenu.Hdl = DYNAMIC-FUNCTION
                          ("createMenuToggle":U IN TARGET-PROCEDURE,
                            hParent,
                            btMenu.Name,
                            DYNAMIC-FUNCTION ("actionCaption":U IN TARGET-PROCEDURE,
                                               btMenu.Name),
                            IF AVAIL ttAction THEN ttAction.ACCELERATOR ELSE ?,
                            btMenu.Sensitive).
        IF VALID-HANDLE(btMenu.hdl) THEN
           btMenu.Hdl:CHECKED = lChecked  = TRUE.
    END.    
    ELSE IF cControlType = 'Label':U THEN
      ASSIGN
        btMenu.Sensitive = IF lUseRepository THEN TRUE
                            ELSE 
                              (CAN-FIND 
                               (FIRST btChild WHERE btChild.PARENT = btMenu.NAME
                                             AND   btChild.hTarget = TARGET-PROCEDURE)
                                OR {fnarg actionInitCode btMenu.Name} <> "":U
                               )
        btMenu.Hdl = DYNAMIC-FUNCTION
                    ("createSubMenu":U IN TARGET-PROCEDURE,
                      hParent,
                      btMenu.Name,
                      DYNAMIC-FUNCTION ("actionCaption":U IN TARGET-PROCEDURE,
                                        btMenu.Name),
                      btMenu.Sensitive). 

  END. /* else (ie: tMeny <> rule) */
  
  RETURN IF AVAIL btMenu THEN btMenu.Hdl ELSE ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createMenuBar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createMenuBar Procedure 
FUNCTION createMenuBar RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Create a menubar object on the window if it does not already exist
            and return the handle of the menu bar. 
    Notes:  No data is added 
            Repository toolbars calls this all the time because the window's 
            menu-bar is reused.
            non-repository objects does not have this capability, so they 
            only call this once from buildMenu when the parameter is blank 
            to create the menubar and uses getMenubarHandle to get the 
            existing handle.    
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hMenu          AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hWindow        AS HANDLE  NO-UNDO.
  DEFINE VARIABLE lUseRepository AS LOGICAL NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get UseRepository lUseRepository}
  {get Window hWindow}
  .
  &UNDEFINE xp-assign
  
  IF NOT lUseRepository OR NOT VALID-HANDLE(hWindow:MENU-BAR) THEN
  DO:
    /* CREATE a WIDGET-POOL for all menus since the toolbar may need to delete 
       and recreate menus in order to merge them, they may end up in different
       default widget-pools and subsequently get detroyed too early 
      (non-repository just recreates menubars for each toolbar..)    
    */
    IF lUseRepository OR NOT VALID-HANDLE(hWindow:MENU-BAR) THEN
      CREATE WIDGET-POOL {&menuwidgetpool} + STRING(hWindow)  PERSISTENT NO-ERROR.

    CREATE MENU hMenu IN WIDGET-POOL {&menuwidgetpool} + STRING(hWindow)
      ASSIGN
        NAME      = "MainMenu":U. 

    hWindow:MENU-BAR = hMenu.
  END.
  ELSE hMenu = hWindow:MENU-BAR.
  
  {set menubarHandle hMenu}. 

  RETURN hMenu.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createMenuItem) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createMenuItem Procedure 
FUNCTION createMenuItem /**
*   @desc  Creates a menuitem 
*   @param <code>input pihParent handle</code> handle to (sub)menu
*   @param <code>input picName character</code> Name of menuitem
*   @param <code>input picCaption character</code>  Caption 
*   @param <code>input pilSensitive logical</code>  Item sensitive or not
*   @returns handle to menuitem
*/
RETURNS HANDLE
  ( phParent     AS HANDLE,     
    pcName       AS CHARACTER, 
    pcCaption    AS CHARACTER,  
    pcAccelerator AS CHARACTER,
    plSensitive  AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Create and return a new menu-item with an on choose trigger.
Parameters: 
  INPUT          phParent    - handle    - parent frame
  INPUT          pcName      - character - the name of the button
  INPUT          pcCaption   - character - the tooltip of the button  
  INPUT          pcAccelerator - character - the action accelerator  
  INPUT          plSensitive - logical   - Yes if the item should be sensitive
 
    Notes:  Creates a persistent trigger ON CHOOSE that runs onChoose(pcName).  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hTmp       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cUIBMode   AS CHAR       NO-UNDO.
  DEFINE VARIABLE hMenuBar   AS HANDLE     NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get UIBMode cUIBMode}
  {get MenuBarHandle hMenubar}
  .
  &UNDEFINE xp-assign
  
  CREATE MENU-ITEM hTmp IN WIDGET-POOL {&menuwidgetpool} + STRING(hMenuBar:OWNER) 
      ASSIGN
        LABEL       = IF pcCaption <> "":U THEN pcCaption ELSE pcName
        NAME        = pcName
        SENSITIVE   = plSensitive
        ACCELERATOR = pcAccelerator.

  IF phParent <> ? THEN
    hTmp:PARENT  = phParent.

  IF cUIBMode <> "Design":U THEN
    ON CHOOSE OF hTmp 
      PERSISTENT RUN OnChoose IN TARGET-PROCEDURE (pcName).
  ELSE /* disable at design time */ 
    hTmp:SENSITIVE = FALSE.
  
  RETURN hTmp. /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createMenuTempTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createMenuTempTable Procedure 
FUNCTION createMenuTempTable RETURNS ROWID PRIVATE
  (pcParent    AS CHAR,
   pcName      AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Create the temp-table for the menu.
Parameters:
         INPUT pcParent - The unique Band name of an already created parent
         INPUT pcName   - A unique name
                                 
    Notes: PRIVATE (we do not want to support this as an API, but rather 
                    create a combination of insertMenuTempTable and this one)  
------------------------------------------------------------------------------*/
  DEFINE BUFFER btMenu   FOR tMenu.
  DEFINE BUFFER btParent FOR tMenu.

  DEFINE BUFFER btBandInstance FOR tBandInstance.

  DEFINE VARIABLE iSeq             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cCaption         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE clink            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hMenu            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iMergeOrder      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lSubstitute      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hMenuBar         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hParent          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iPage            AS INTEGER    NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get menuMergeOrder iMergeOrder}
  {get ObjectPage iPage}
  {get menubarHandle hMenuBar}
  .
  &UNDEFINE xp-assign
  
  IF pcParent <> '':U THEN
  DO:
    FIND btParent WHERE btParent.Name    = pcParent
                  AND   btParent.hTarget = TARGET-PROCEDURE NO-ERROR.
    IF NOT AVAIL btParent THEN
      RETURN ?.
    hParent = btParent.Hdl.
  END.
  ELSE
    hParent = hMenuBar.

  /*
  FIND btBandInstance WHERE btBandInstance.Band    = pcParent 
                      AND   btBandInstance.hTarget = TARGET-PROCEDURE NO-ERROR. 
  */
  cCaption      = {fnarg actionCaption pcName}.
  cLink         = {fnarg actionLink pcName}.
  /**
  IF AVAIL btBandInstance AND cLink = '':U 
  AND pcName <> "RULE":U THEN
  DO:
    
    FIND FIRST btMenu WHERE btMenu.ParentHdl   = btBandInstance.hdl
                      AND   btMenu.Caption     = cCaption
                      AND   btMenu.Link        = '':U NO-ERROR.
     
    
    IF AVAIL btmenu THEN
    DO:
      hMenu = btMenu.hdl.
    END.
  END.
  **/
  FIND LAST btMenu WHERE btMenu.Parent  = pcParent 
                   AND   btMenu.hTarget = TARGET-PROCEDURE NO-ERROR.
  
  iSeq = IF AVAIL btMenu THEN btMenu.Seq + 1 ELSE 1. 
  /*
  IF iSeq > 1 AND VALID-HANDLE(hMenu) THEN
    hMenu = DYNAMIC-FUNCTION('moveMenu':U IN TARGET-PROCEDURE,
                                hMenu,
                                hMenu:PARENT).
  */  
  /* If this is this object's first menu on this Band and another object 
     already has menus here create a rule first */ 
  
  /**                                                
  IF iSeq = 1 AND pcName <> 'RULE':U AND btBandInstance.hdl:TYPE <> 'MENU':U 
  AND NOT VALID-HANDLE(hMenu) THEN
  DO:
    IF CAN-FIND(FIRST btMenu WHERE btMenu.ParentHdl  = btBandInstance.hdl) THEN
    DO:
      DYNAMIC-FUNCTION ('createMenuTempTable':U IN TARGET-PROCEDURE,
                                  pcParent,
                                  'RULE':U).
      FIND LAST btMenu WHERE btMenu.Parent = pcParent 
                       AND   btMenu.Name   = 'RULE':U 
                       AND   btMenu.hTarget = TARGET-PROCEDURE.
      
      btMenu.hdl = DYNAMIC-FUNCTION("createRule":U IN TARGET-PROCEDURE,
                                    btBandInstance.hdl).       
    END.
  END.
  **/
  /* Only ONE entry of each action, except for RULE. 
     The last entry will potentially change the parent.
     The menu may also exist with "*" as parent because it was enabled/disabled
     before insert */
  IF pcName <> "RULE":U THEN
    FIND btMenu WHERE btMenu.hTarget = TARGET-PROCEDURE  
                AND   btMenu.NAME    = pcName NO-ERROR. 
  ELSE RELEASE btMenu.

  IF NOT AVAIL btMenu OR pcName = "RULE":U THEN 
  DO:
    CREATE btMenu.  
    ASSIGN 
      btMenu.hTarget   = TARGET-PROCEDURE 
      /* Caption is stored because its used to identify the Menu when merging */
      btMenu.Caption   = cCaption 
     /* btMenu.ParentHdl = hParent /*btBandInstance.hdl*/ */ 
      btMenu.Name      = pcName
      btMenu.Sensitive = FALSE.
  END.
  
  ASSIGN
    btMenu.Parent      = pcParent
    btMenu.Seq         = iSeq
    btMenu.Link        = cLink
    btMenu.PageNo      = iPage
    btMenu.MergeOrder  = IF iMergeOrder > 0 THEN iMergeOrder ELSE ?
    btMenu.MenuBarhdl  = hMenuBar
    btMenu.hdl         = hMenu.
  
  /* return true if a btMenu was created with*/
  RETURN ROWID(btMenu).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createMenuToggle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createMenuToggle Procedure 
FUNCTION createMenuToggle /**
*   @desc  Creates a menuitem 
*   @param <code>input pihParent handle</code> handle to (sub)menu
*   @param <code>input picName character</code> Name of menuitem
*   @param <code>input picCaption character</code>  Caption 
*   @param <code>input pilSensitive logical</code>  Item sensitive or not
*   @returns handle to menuitem
*/
RETURNS HANDLE
  ( phParent      AS HANDLE,
    pcName        AS CHARACTER,
    pcCaption     AS CHARACTER,
    pcAccelerator AS CHARACTER,
    plSensitive   AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:  Creates and return a new toggle menu-item with an on choose trigger.
Parameters: 
  INPUT          phParent      - handle    - parent frame
  INPUT          pcName        - character - the name of the button
  INPUT          pcCaption     - character - the tooltip of the button  
  INPUT          pcAccelerator - character - the action accelerator  
  INPUT          plSensitive   - logical   - Yes sensitive, no disabled
 
    Notes:  Creates a persistent trigger 
               ON VALUE-CHANGED that runs onValueChanged(pcName).  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hTmp      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cUIBmode  AS CHAR       NO-UNDO.
  DEFINE VARIABLE hMenubar  AS HANDLE     NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get UIBMode cUIBMode}
  {get MenuBarHandle hMenubar}
  .
  &UNDEFINE xp-assign
  
  CREATE MENU-ITEM hTmp IN WIDGET-POOL {&menuwidgetpool} + STRING(hMenuBar:OWNER) 
      ASSIGN
        TOGGLE-BOX  = TRUE
        LABEL       = IF pcCaption <> "":U THEN pcCaption ELSE pcName
        NAME        = pcName
        SENSITIVE   = plSensitive 
        ACCELERATOR = pcAccelerator.
                                                               
  IF phParent <> ? THEN 
     hTmp:PARENT  = phParent.

  IF cUIBMode <> "Design":U THEN
    ON VALUE-CHANGED OF hTmp 
        PERSISTENT RUN OnValueChanged IN TARGET-PROCEDURE (pcName).
 
  ELSE /* Always disable at design time */ 
    hTmp:SENSITIVE = FALSE.

  RETURN hTmp. /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createRule) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createRule Procedure 
FUNCTION createRule /**
*   @desc  Creates a rule
*   @param <code>input pihParent handle</code> handle to (sub)menu
*   @returns handle to rule
*/
RETURNS HANDLE
  ( phParent AS HANDLE /* Handle of the Parent */
  ) :
/*------------------------------------------------------------------------------
  Purpose: Create and return the handle of a RULE menu-item.
Parameters:   INPUT phParent - handle - parent frame
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hTmp     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hMenubar AS HANDLE     NO-UNDO.

  {get MenuBarHandle hMenubar}.
  
  CREATE MENU-ITEM hTmp IN WIDGET-POOL {&menuwidgetpool} + STRING(hMenuBar:OWNER) 
    ASSIGN
      SUBTYPE = 'RULE':U.

  IF phParent <> ? THEN
      hTmp:PARENT  = phParent.
  RETURN hTmp.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createSubMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createSubMenu Procedure 
FUNCTION createSubMenu RETURNS HANDLE
  ( phParent     AS HANDLE,    /* Handle of the parent */
    pcName       AS CHARACTER, /* Name of the to be created submenu */
    pcCaption    AS CHARACTER, /* Caption of the be created submenu */
    plSensitive  AS LOGICAL    /* If the submenu has to be sensitive */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Create and return a new sub-menu-item with an on menu-drop trigger.
Parameters: 
  INPUT          phParent    - handle    - parent frame
  INPUT          pcName      - character - the name of the button
  INPUT          pcCaption   - character - the tooltip of the button  
  INPUT          plSensitive - logical   - Yes if the item should be sensitive
 
    Notes:  Creates a persistent trigger ON MENU-DROP that runs 
             onMenuDrop(pcName).  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hTmp     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hMenubar AS HANDLE    NO-UNDO.
  
  {get MenuBarHandle hMenubar}.
  
  CREATE SUB-MENU hTmp IN WIDGET-POOL {&menuwidgetpool} + STRING(hMenuBar:OWNER) 
    ASSIGN
      NAME      = pcName
      LABEL     = IF pcCaption <> "":U THEN pcCaption ELSE pcName
      SENSITIVE = plSensitive
    TRIGGERS:
      ON MENU-DROP PERSISTENT RUN onMenuDrop IN TARGET-PROCEDURE (pcName).
    END TRIGGERS.
  
  IF phParent <> ? THEN
    hTmp:PARENT  = phParent.
  RETURN hTmp.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createToolbar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createToolbar Procedure 
FUNCTION createToolbar RETURNS LOGICAL
  (pcActions AS CHARACTER) :
/*------------------------------------------------------------------------------
   Purpose: Create a toolbar  
Parameters: INPUT pcActions - A comma seaparted list of actions or actionGroups
                            - RULE specifies a delimiter.     
     Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE i                    AS INT     NO-UNDO. 
  DEFINE VARIABLE cAction              AS CHAR    NO-UNDO.
  DEFINE VARIABLE hFrame               AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hWindow              AS HANDLE  NO-UNDO.
  DEFINE VARIABLE cChildren            AS CHAR    NO-UNDO.  
  DEFINE VARIABLE cTableIOType         AS CHAR    NO-UNDO.  
  DEFINE VARIABLE cName                AS CHAR    NO-UNDO.  
  DEFINE VARIABLE iBtn                 AS INT     NO-UNDO. 
  DEFINE VARIABLE iBegin               AS INT     NO-UNDO. 
  DEFINE VARIABLE iToolSeparatorPxl    AS INTEGER NO-UNDO.
  DEFINE VARIABLE cParent              AS CHAR    NO-UNDO .  
  DEFINE VARIABLE cActionGroups        AS CHAR    NO-UNDO.  
  DEFINE VARIABLE cAvailToolbarActions AS CHAR    NO-UNDO.  
  DEFINE VARIABLE lToolbar             AS LOG     NO-UNDO.
  DEFINE VARIABLE lRule                AS LOG     NO-UNDO.
  DEFINE VARIABLE lShowBorder          AS LOG     NO-UNDO. 
  DEFINE VARIABLE hBtn                 AS HANDLE  NO-UNDO.
  DEFINE VARIABLE dMinWidth            AS DEC     NO-UNDO. 
  DEFINE VARIABLE dMinHeight           AS DEC     NO-UNDO. 
  
  &SCOPED-DEFINE xp-assign
  {get ShowBorder lShowBorder}
  {get ActionGroups cActionGroups}
  {get AvailToolbarActions cAvailToolbarActions}
  {get ContainerHandle hFrame}
  {get TableIOType cTableIoType}
  {get Window hWindow}
  {get Toolbar lToolbar}
  {get ToolSeparatorPxl iToolSeparatorPxl}
  {get MinWidth dMinWidth}.   
  &UNDEFINE xp-assign
 
  ASSIGN 
    iBegin     =  INT((dMinWidth * SESSION:PIXELS-PER-COLUMN))
                  + iToolSeparatorPxl
                  + (If lShowBorder THEN 2 ELSE 0)  
    lRule = TRUE.
  
  DO i = 1 TO NUM-ENTRIES(pcActions):
    cAction   = ENTRY(i,pcActions).
    
    /* Logic to avoid double RULEs if some of the groups are skipped */
    IF cAction = "RULE":U AND lRule THEN    
      NEXT.   
       
    /* We might give birth to children so do this before checking isParent */
    IF (CAN-DO(cActionGroups,cAction) OR {fnarg actionIsMenu cAction}) THEN
       {fnarg actionPublishCreate cAction}.

    /* If this is a parent we logg and check it as a group and find children */  
    IF {fnarg actionIsParent cAction} THEN 
    DO:
      IF NOT {fnarg actionIsMenu cAction} THEN
      DO:
        /* logg this as available for the Instance Property dialog */
        IF NOT CAN-DO(cAvailToolbarActions,cAction) THEN
          ASSIGN cAvailToolbarActions = 
                   cAvailToolbarActions
                   + (IF cAvailToolbarActions = "":U THEN "":U ELSE ",":U)
                   + cAction. 

         /* Skip it if not amongst the selected actionGroups */
        IF NOT lToolbar OR NOT CAN-DO(cActionGroups,cAction) THEN
          NEXT.   
      END.
      ELSE
        IF NOT lToolbar THEN NEXT.

      ASSIGN                                
        cChildren = {fnarg actionChildren cAction}
        cAction   = cChildren.
            
    END. /* if actionIsParent */                                                                      
    DO iBtn = 1 TO NUM-ENTRIES(cAction):
      cName = ENTRY(iBtn,cAction). 
   
      /* if this is not children found above logg and check the parent */
      IF cChildren = "":U THEN
      DO:
        cParent = {fnarg actionParent cAction}.
        
        IF cParent <> "":U THEN
        DO:         
          IF NOT {fnarg actionIsMenu cAction} THEN
          DO:
            /* logg the parent as available for the Instance Property dialog */      
           IF NOT CAN-DO(cAvailToolbarActions,cParent) THEN
             ASSIGN cAvailToolbarActions = 
                      cAvailToolbarActions
                      + (IF cAvailToolbarActions = "":U THEN "":U ELSE ",":U)
                      + cAction. 

           /* Skip it if the parent is not amongst the selected actionGroups */
           IF NOT CAN-DO(cActionGroups,cParent) THEN
            NEXT.   
          END.
        END. /* if cParent <> "" */  
      END.
      
      IF NOT lToolbar
      OR (cName = "UPDATE":U AND cTableIoType <> "UPDATE":U) THEN
        NEXT.
            
      IF cName = "RULE":U AND NOT lShowBorder THEN  
        ASSIGN iBegin = iBegin + iToolSeparatorPxl
               lRule  = TRUE.                                 
      
      ELSE DO: 
        hBtn = DYNAMIC-FUNCTION ("createToolbarAction":U IN TARGET-PROCEDURE,
                                 '':U, 
                                 cName,
                                 INPUT-OUTPUT iBegin).

        IF VALID-HANDLE(hBtn) THEN 
           lRule = (cName = 'RULE':U).

      END. /* else (border or button) */
    END. /* do iBtn = 1 to num-entries(cAction) */  
  END. /* do i = 1 to num-entries(pcActions) */ 
  
  /* Set the available actionsgroups for the Instance Property dialog */      
  {set AvailToolbarActions cAvailToolbarActions}.  
  
  IF lToolbar AND VALID-HANDLE(hWindow) THEN 
  DO:  
    {fn createToolbarBorder}.
      
    &SCOPED-DEFINE xp-assign
    {get MinWidth  dMinWidth} 
    {get MinHeight dMinHeight}. 
    &UNDEFINE xp-assign

    RUN resizeObject IN TARGET-PROCEDURE(dMinHeight,dMinWidth).
    {fn adjustActions}.
  END. /* lToolbar and valid-handle(hWindow) */

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createToolbarAction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createToolbarAction Procedure 
FUNCTION createToolbarAction RETURNS HANDLE
  (pcBand            AS CHAR, 
   pcAction          AS CHAR,
   INPUT-OUTPUT piXY AS INT):
/*------------------------------------------------------------------------------
   Purpose: Create a toolbar button.  
Parameters: pcName  - Action name 
                     (the button will be created also if no Action is available
                      in the action class)
            pcBand  - Optional Band 
                      Used when created from Repository.
            io-piXY - X or Y Position depending on toolbarDrawDirection           
     Notes: Create the local temp-table record and call  
            createButton or create3dRule to create the actual widget.       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hFrame                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cType                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cImagePath            AS CHAR       NO-UNDO.
  DEFINE VARIABLE cImage                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dMinWidth             AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dMinHeight            AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cToolbarDrawDirection AS CHARACTER  NO-UNDO.  
  DEFINE VARIABLE cDisabledActions      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cHiddenActions        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cGroups               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cControlType          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCategory             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lUseRepository        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cLinkTargetNames      AS CHARACTER  NO-UNDO.
 
  {get HiddenActions cHiddenActions}.
 
  IF CAN-DO(cHiddenActions,pcAction) THEN
    RETURN ?.
  
  IF {fnarg actionCategoryIsHidden pcAction} THEN
    RETURN ?.
  
  &SCOPED-DEFINE xp-assign
  {get DisabledActions cDisabledActions}
  {get UseRepository lUseRepository}.
  &UNDEFINE xp-assign

  {&findaction}
  
  IF AVAIL ttAction THEN
     ASSIGN
       cType        =  ttAction.TYPE /*{fnarg actionType pcAction}*/
       cControlType =  ttAction.ControlType.

  /* If no repository the 'RULE' is not found in action, and if repository is 
     used it should only have one separator and its name is 'rule', but just in 
     case someone messed up let's name it here */ 
  IF cControlType = 'Separator':U THEN 
    pcAction = 'RULE':U.

  IF pcAction <> 'RULE':U THEN
  DO:
    FIND FIRST tButton WHERE tButton.Name    = pcAction
                       AND   tButton.hTarget = TARGET-PROCEDURE NO-ERROR.
    /* non repository object still may create buttons 
       when a message is received before initialization so check handle */
    IF AVAIL tButton AND VALID-HANDLE(tButton.hdl) THEN
      RETURN ?.
  END.

  {get ContainerHandle hFrame}.
        
  IF NOT AVAIL tButton OR pcAction = "RULE":U THEN
    CREATE tButton.
  
  ASSIGN
      tButton.imageAlt = (IF AVAIL ttAction AND ttAction.ImageAlternateRule <> '':U
                          THEN FALSE
                          ELSE ?)
      tButton.Link     = {fnarg actionLink pcAction} 
      tButton.Name     = pcAction
      tbutton.Band     = pcBand
      tButton.hTarget  = TARGET-PROCEDURE
      tButton.Position = piXY.
  
  IF pcAction = "RULE":U THEN
    ASSIGN
      tButton.Hdl = DYNAMIC-FUNCTION("create3DRule":U IN TARGET-PROCEDURE,
                                      hFrame,
                                      INPUT-OUTPUT piXY).
                                      
  ELSE 
    ASSIGN
      tButton.Disabled = IF AVAIL ttAction THEN ttAction.Disabled ELSE ?
      tButton.Sensitive = IF tButton.Disabled OR CAN-DO(cDisabledActions,pcAction)
                          THEN FALSE
                            /* keep value if already sensitized  */
                          ELSE IF tButton.Sensitive THEN TRUE
                          ELSE IF cType = "RUN":U 
                                /* CanRun checks disabled actions */
                          THEN {fnarg actionCanRun tButton.Name}
                          ELSE IF cType = "LAUNCH":U 
                          THEN TRUE                       
           /* This has really nothing to do with repository, it's just that we use a
             different default since non-repository need strict backwards compatibility
             while the use of repository makes it so easy to override this with no code
             that it makes sense to have a more sensible default. 
             NOTE: the default must match the craatetoolbarAction setting of tbutton as 
                   resetTargetActions just checks tButton to see if this is a change */
                          ELSE lUseRepository
     tButton.Hdl = DYNAMIC-FUNCTION ("createButton":U IN TARGET-PROCEDURE,
                        hFrame,
                        INPUT-OUTPUT piXY,
                        tButton.Name,
                        {fnarg actionLabel tButton.Name},
                        {fnarg actionTooltip tButton.Name},
                        DYNAMIC-FUNCTION('imageName':U IN TARGET-PROCEDURE,
                                          tButton.Name,1),
                        tButton.Sensitive).
  IF VALID-HANDLE(tButton.Hdl) THEN 
  DO:
    &SCOPED-DEFINE xp-assign 
    {get MinWidth  dMinWidth} 
    {get MinHeight dMinHeight}.
    &UNDEFINE xp-assign
    ASSIGN 
      dMinWidth  = MAX(dMinWidth,tButton.Hdl:COL + tButton.Hdl:WIDTH - 1)
      dMinHeight = MAX(dMinHeight,tButton.Hdl:ROW + tButton.Hdl:HEIGHT - 1).
    &SCOPED-DEFINE xp-assign
    {set MinWidth  dMinWidth} 
    {set MinHeight dMinHeight}. 
    &UNDEFINE xp-assign
  END.

    /* Add Target link to LinkTargetNames property */
  IF tButton.Link > "":U THEN
  DO:
     {get LinkTargetNames cLinkTargetNames}.
     IF NUM-ENTRIES(tButton.Link,"-":U) > 1 
       AND ENTRY(2,tButton.Link,"-":U) = "target":U
        AND NOT CAN-DO(cLinkTargetNames,tButton.Link) THEN 
     DO:
       cLinkTargetNames = cLinkTargetNames + (IF cLinkTargetNames = "" THEN "" ELSE ",") + tButton.Link.
      {set LinkTargetNames cLinkTargetNames}.
     END.
  END.

  RETURN tButton.Hdl. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createToolbarBorder) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createToolbarBorder Procedure 
FUNCTION createToolbarBorder RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Add the border on the toolbar  
    Notes:  
------------------------------------------------------------------------------*/   
 DEFINE VARIABLE hFrame                AS HANDLE     NO-UNDO. 
 DEFINE VARIABLE lShowBorder           AS LOG        NO-UNDO. 
 DEFINE VARIABLE lToolbarAutoSize      AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE hRect                 AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hRect2                AS HANDLE     NO-UNDO.
 DEFINE VARIABLE iEdgePixels           AS INTEGER    NO-UNDO.
 DEFINE VARIABLE iToolMarginPxl        AS INTEGER    NO-UNDO.
 DEFINE VARIABLE dMinWidth      AS DECIMAL    NO-UNDO.
 DEFINE VARIABLE dMinHeight     AS DECIMAL    NO-UNDO.
 DEFINE VARIABLE iToolSeparatorPxl     AS INTEGER    NO-UNDO.
 DEFINE VARIABLE cDrawDirection        AS CHARACTER  NO-UNDO. 

 &SCOPED-DEFINE xp-assign
 {get ContainerHandle hframe}
 {get ShowBorder lShowBorder}
 {get ToolbarAutosize lToolbarAutosize}
 {get EdgePixels iEdgePixels}
 {get ToolMarginPxl iToolMarginPxl}
 {get ToolbarDrawDirection cDrawDirection}
 {get MinWidth  dMinWidth}
 {get MinHeight dMinHeight}.
 &UNDEFINE xp-assign

 iEdgePixels = IF iEdgePixels = 1 THEN 1 ELSE 2.

 IF lShowBorder THEN 
 DO:
   CREATE RECTANGLE hRect
      ASSIGN
        GRAPHIC-EDGE = TRUE
        Y            = 0
        X            = 0
        FILLED       = FALSE
        EDGE-PIXELS  = iEdgePixels
        HIDDEN       = FALSE
        FRAME        = hFrame.
              
   {set BoxRectangle hRect}.
   /* If not autosize draw a border around the toolbar */
   IF NOT lToolbarAutoSize THEN
   DO:
     ASSIGN
       hRect:HEIGHT   = dMinHeight
       hRect:WIDTH    = dMinWidth
     NO-ERROR.
     /* Add Margin, but include border size in margin size */
     IF cDrawDirection BEGINS 'v':U THEN
       hRect:WIDTH-P  = hRect:WIDTH-P
                      + iToolMarginPxl NO-ERROR.
     ELSE 
       hRect:HEIGHT-P = hRect:HEIGHT-P                          
                      + iToolMarginPxl NO-ERROR.
    /* If a 'rule' is the last 'button' we keep the current size and just
       hide it with this rectangle, but otherwise we add the separator so 
       both sides are equal  */             
     FIND LAST tButton WHERE tButton.hTarget = TARGET-PROCEDURE NO-ERROR.
     IF tButton.NAME <> 'RULE' THEN 
     DO:
      {get ToolSeparatorPxl iToolSeparatorPxl}.
       IF cDrawDirection BEGINS 'v':U THEN
         hRect:HEIGHT-P = hRect:HEIGHT-P + iToolSeparatorPxl + iEdgePixels
         NO-ERROR.
       ELSE 
         hRect:WIDTH-P = hRect:WIDTH-P + iToolSeparatorPxl + iEdgePixels
         NO-ERROR.
     END.
     ASSIGN
       dMinHeight = hRect:HEIGHT
       dMinWidth  = hRect:WIDTH. 
     &SCOPED-DEFINE xp-assign
     {set MinWidth dMinWidth}
     {set MinHeight dMinHeight}.
     &UNDEFINE xp-assign
   END.

   /* otherwise we draw one rectangle over and one under (or left right ) */
   ELSE 
   IF cDrawDirection BEGINS 'v':U THEN
     ASSIGN
       hRect:HEIGHT   = dMinHeight
       hRect:WIDTH-P  = 2
     NO-ERROR.
   ELSE
     ASSIGN
       hRect:HEIGHT-P = 2
       hRect:WIDTH    = dMinWidth
     NO-ERROR.

   IF lToolbarAutoSize THEN 
   DO:            
     CREATE RECTANGLE hRect2
       ASSIGN
         GRAPHIC-EDGE  = TRUE
         FILLED        = FALSE
         EDGE-PIXELS   = IF iEdgePixels = 1 THEN 1 ELSE 2
         HIDDEN        = FALSE
         FRAME         = hFrame.

     {set BoxRectangle2 hRect2}.
     
     /*  override errors. initializeObject will give an error message
         if frame hidden =  false gives error. */
     IF cDrawDirection BEGINS 'v':U THEN
       ASSIGN
         hRect2:ROW      = 1
         hRect2:HEIGHT   = dMinHeight
         hRect2:COL      = dMinWidth + 1
         hRect2:WIDTH-P  = iEdgePixels 
         /* Add Margin, but include border size in margin size */
         hRect2:X        = hRect2:X 
                          + MAX(iToolMarginPxl,hRect2:WIDTH-P)
                          - hRect2:WIDTH-P
       NO-ERROR.
      ELSE 
        ASSIGN
          hRect2:ROW      = dMinHeight + 1
          hRect2:HEIGHT-P = iEdgePixels
          hRect2:COL      = 1
          hRect2:WIDTH    = dMinWidth
          /* Add Margin, but include border size in margin size */
          hRect2:Y        = hRect2:Y 
                            + MAX(iToolMarginPxl,hRect2:HEIGHT-P)
                            - hRect2:HEIGHT-P 

        NO-ERROR.

     ASSIGN
       dMinHeight = hRect2:ROW + hRect2:HEIGHT - 1
       dMinWidth  = hRect2:COL + hRect2:WIDTH - 1. 

     &SCOPED-DEFINE xp-assign
     {set MinWidth dMinWidth}
     {set MinHeight dMinHeight}.
     &UNDEFINE xp-assign
   END.
   ELSE
     {set BoxRectangle2 ?}.
 END. /* showBorder */
 ELSE DO:
   &SCOPED-DEFINE xp-assign
   {set BoxRectangle ?}
   {set BoxRectangle2 ?}.
   &UNDEFINE xp-assign
 END.
 
 RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-defineAction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION defineAction Procedure 
FUNCTION defineAction RETURNS LOGICAL
  (pcAction  AS CHAR,
   pcColumns AS CHAR,
   pcValues  AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: API used to define Actions for the class or a particalar instance  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lUseRepository AS LOGICAL   NO-UNDO.    
  DEFINE VARIABLE lOK            AS LOGICAL   NO-UNDO.    
    
  DEFINE BUFFER bttBand       FOR ttBand.
  DEFINE BUFFER bttBandAction FOR ttBandAction.

  IF TARGET-PROCEDURE = THIS-PROCEDURE THEN 
    lUseRepository = DYNAMIC-FUNCTION('isICFRunning':U IN THIS-PROCEDURE) NO-ERROR.
  ELSE /* minimize risk of the above and use the normal call in other cases */ 
    {get UseRepository lUseRepository}.

  lOK =  setBuffer("Action":U,pcAction,pcColumns,PcValues,TARGET-PROCEDURE).

  /* For customized createEvent, set repository bands and actions */
  IF lUseRepository AND lOK THEN
  DO:
     {&findaction}
     IF AVAIL ttAction AND ttAction.Parent > "" THEN
     DO:
        FIND bttBand WHERE bttBand.Band            = ttAction.Parent 
                       AND bttBand.ProcedureHandle = THIS-PROCEDURE NO-ERROR.
        IF NOT AVAIL bttBand THEN
        DO:
           CREATE bttBand.
           ASSIGN bttBand.Band            = ttAction.Parent
                  bttBand.BandType        = 'Menu&Toolbar'
                  bttBand.ProcedureHandle = THIS-PROCEDURE.
        END.
        FIND bttBandAction WHERE bttBandAction.Band            = ttAction.Parent 
                             AND bttBandAction.action          = pcAction 
                             AND bttBandAction.ProcedureHandle = THIS-PROCEDURE NO-ERROR.
        IF NOT AVAIL bttBandAction THEN
        DO:
           CREATE bttBandAction.
           ASSIGN bttBandAction.Band            = bttBand.Band
                  bttBandAction.Action          = pcAction
                  bttBandAction.sequence        = ttAction.Order
                  bttBandAction.ProcedureHandle = THIS-PROCEDURE.
                  
        END.
       /* Now specify the child band for all instances*/
       FOR EACH bttBandAction WHERE bttBandAction.Action          = ttAction.Parent
                                AND bttBandAction.ProcedureHandle = THIS-PROCEDURE:
          ASSIGN bttBandAction.ChildBand = bttBand.Band.
       END.
    END.
  END.


  RETURN lOK.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION deleteMenu Procedure 
FUNCTION deleteMenu RETURNS LOGICAL
  () :
/*------------------------------------------------------------------------------
  Purpose: Delete the dynamic menu included all menu-items and sub-menues. 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER btMenu FOR tMenu.
  DEFINE BUFFER btBandInstance FOR tBandInstance.

  DEFINE VARIABLE hMenu    AS HANDLE   NO-UNDO.
  DEFINE VARIABLE hWindow  AS HANDLE   NO-UNDO.
  DEFINE VARIABLE hMenuBar AS HANDLE   NO-UNDO.
  DEFINE VARIABLE cInfo    AS CHAR     NO-UNDO.
  DEFINE VARIABLE lOk      AS LOG      NO-UNDO.
  DEFINE VARIABLE hContainer AS HANDLE NO-UNDO.
  DEFINE VARIABLE cType      AS CHAR   NO-UNDO.
  DEFINE VARIABLE lUseRepository AS LOGICAL  NO-UNDO.
  
  /* Don't attempt to delete menu if toolbar is in a dialog box,
     as it may delete the menu from the parent window. */
  {get ContainerSource hContainer}.

  IF VALID-HANDLE(hContainer) THEN  /* not valid when selecting from palette */
    cType = DYNAMIC-FUNCTION("getContainerType":U IN hContainer).
  
  IF cType = "DIALOG-BOX":U THEN
    RETURN FALSE.
  
  {get Window hWindow}.

  IF VALID-HANDLE(hWindow) THEN
    hMenu = hWindow:MENU-BAR.  

  {get UseRepository lUseRepository}.
  IF lUseRepository THEN
    RUN removeMenu IN TARGET-PROCEDURE.
  ELSE DO:
  
    FOR EACH tBandInstance WHERE tBandInstance.hTarget = TARGET-PROCEDURE:     
      IF VALID-HANDLE(tBandInstance.hdl) THEN
      DO:
        IF NOT CAN-FIND(FIRST btBandInstance
                              WHERE btBandInstance.hdl = tBandInstance.hdl
                              AND   btBandInstance.hTarget <> tBandInstance.hTarget) THEN
        DO:
          DELETE WIDGET tBandInstance.hdl.
          IF tBandInstance.Hdl = hMenubar THEN {set MenuBarHandle ?}. 
        END.
      END.
      DELETE tBandInstance.
    END. 

    FOR EACH tMenu WHERE tMenu.hTarget = TARGET-PROCEDURE:     
       IF VALID-HANDLE(tMenu.hdl) THEN
       DO:
         IF NOT CAN-FIND(FIRST btMenu WHERE btMenu.Hdl     = tMenu.hdl
                                      AND   btMenu.hTarget <> tMenu.hTarget) THEN      
           DELETE WIDGET tmenu.hdl.
       END.
       DELETE tMenu.
    END. 
  END. /* End if non-dynamics */

  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteToolbar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION deleteToolbar Procedure 
FUNCTION deleteToolbar RETURNS LOGICAL
  () :
/*------------------------------------------------------------------------------
  Purpose:  Delete the dynamic toolbar and its buttons
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRect  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRect2 AS HANDLE     NO-UNDO.

  FOR EACH tButton WHERE tButton.hTarget = TARGET-PROCEDURE:     
     IF VALID-HANDLE(tButton.Hdl) THEN
        DELETE WIDGET tButton.Hdl.
     DELETE tButton.
  END. 
  &SCOPED-DEFINE xp-assign
  {set MinWidth 0}
  {set MinHeight 0}
  {get BoxRectangle hRect}
  {get BoxRectangle2 hRect2}.
  &UNDEFINE xp-assign
  
  DELETE OBJECT hRect  NO-ERROR.
  DELETE OBJECT hRect2 NO-ERROR.

  &SCOPED-DEFINE xp-assign
  {set BoxRectangle ?}
  {set BoxRectangle2 ?}.
  &UNDEFINE xp-assign
  
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-disableActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION disableActions Procedure 
FUNCTION disableActions RETURNS LOGICAL
  (pcActions AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Disable a list of actions 
Parameters: INPUT pcActions - A comma separated list of actions to disable
                              "*" - means disable all     
    Notes:  This function is used internally to turn actions on/off depending
            of the state.  
            Use modifyDisabledActions or setDisabledActions to override 
            enabling.             
------------------------------------------------------------------------------*/
  RETURN DYNAMIC-FUNC("sensitizeActions":U IN TARGET-PROCEDURE,pcActions,FALSE).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-enableActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION enableActions Procedure 
FUNCTION enableActions RETURNS LOGICAL
  (pcActions AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Enable a list of actions 
Parameters: INPUT pcActions - A comma separated list of actions to enable
                              "*" - means enable all     
    Notes:  This function is used internally to turn actions on/off depending
            of the state.  
            Use modifyDisabledActions or setDisabledActions to override 
            enabling.             
------------------------------------------------------------------------------*/
  RETURN DYNAMIC-FUNC("sensitizeActions" IN TARGET-PROCEDURE,pcActions,TRUE).
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

&IF DEFINED(EXCLUDE-findAction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION findAction Procedure 
FUNCTION findAction RETURNS LOGICAL
  (pcAction AS CHAR,
   phTarget AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose: Find the action override to ensure panel class accesses this class
           static ttAction.   
    Notes:  
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE targetproc phTarget
  {&findaction}
  RETURN AVAILABLE ttAction.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findCategory) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION findCategory Procedure 
FUNCTION findCategory RETURNS LOGICAL
  (pcCategory AS CHAR,
   phTarget   AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  FIND FIRST ttCategory WHERE ttCategory.Category = pcCategory NO-ERROR.
  RETURN AVAILABLE ttCategory.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getActionBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getActionBuffer Procedure 
FUNCTION getActionBuffer RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN BUFFER ttAction:HANDLE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getActionGroups) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getActionGroups Procedure 
FUNCTION getActionGroups RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the action groups selected in the Instance Properties.    
    Notes: Repository toolbar uses categories while non-repository objects
           uses parent actions  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cActionGroups AS CHARACTER NO-UNDO.
  {get ActionGroups cActionGroups}.
  RETURN cActionGroups.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAvailMenuActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAvailMenuActions Procedure 
FUNCTION getAvailMenuActions RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the actions that are available in this toolbar   
    Notes: The Instance Property dialog shows these and AvailToolbarActions. 
           The actions/categories that are selected will be saved as 
           ActionGroups.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cAvailMenuActions AS CHARACTER NO-UNDO.
  {get AvailMenuActions cAvailMenuActions}.
  RETURN cAvailMenuActions.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAvailToolbarActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAvailToolbarActions Procedure 
FUNCTION getAvailToolbarActions RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the actions that are available in the menu of this toolbar   
    Notes: The Instance Property dialog shows these and AvailMenuActions. 
           The actions/categories that are selected will be saved as 
           ActionGroups.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cAvailToolbarActions AS CHARACTER NO-UNDO.
  {get AvailToolbarActions cAvailToolbarActions}.
  RETURN cAvailToolbarActions.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAvailToolbarBands) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAvailToolbarBands Procedure 
FUNCTION getAvailToolbarBands RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the available toolbar bands for this toolbar master 
    Notes:  Used in the Instance Property dialog to select ToolbarBands
------------------------------------------------------------------------------*/
 DEFINE BUFFER bttToolbarBand FOR ttToolbarBand.
 DEFINE BUFFER bttBand    FOR ttBand.
 
 DEFINE VARIABLE cLogicalObject AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cBandList AS CHARACTER  NO-UNDO.

 {get LogicalObjectName cLogicalObject}.

 FOR EACH bttToolbarBand 
      WHERE bttToolbarBand.toolbar  = cLogicalObject,
      EACH bttBand 
      WHERE bttBand.Band  = bttToolbarBand.Band  
      AND  (bttBand.BandType = 'Toolbar':U 
            OR
           bttBand.BandType = 'Menu&Toolbar':U)
     BY (IF bttToolbarBand.Alignment = 'Left':U         THEN 1
         ELSE IF bttToolbarBand.Alignment = 'Center':U  THEN 2
         ELSE                                                3)
    BY bttToolbarBand.Sequence:
    IF NOT CAN-DO(cBandList,bttBand.Band) THEN
       cBandList = cBandList 
               + (IF cBandList <> '':U THEN ',':U ELSE '':U) 
               + bttBand.Band.

 END.
 RETURN cBandList.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBoxRectangle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBoxRectangle Procedure 
FUNCTION getBoxRectangle RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle to the rectangle, if any, which draws a 
            "box" around the buttons in the toolbar
            -- used by resizeObject.
   Params:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBox AS HANDLE NO-UNDO.
  {get BoxRectangle hBox}.
  RETURN hBox.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBoxRectangle2) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBoxRectangle2 Procedure 
FUNCTION getBoxRectangle2 RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Used for bottom rectangle on toolbars with toolbarautosize true  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hValue AS HANDLE NO-UNDO.
    {get BoxRectangle2 hValue}.
    RETURN hValue.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCommitTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCommitTarget Procedure 
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

&ENDIF

&IF DEFINED(EXCLUDE-getCommitTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCommitTargetEvents Procedure 
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

&ENDIF

&IF DEFINED(EXCLUDE-getContainerToolbarTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getContainerToolbarTarget Procedure 
FUNCTION getContainerToolbarTarget RETURNS CHARACTER
    ( ):
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle of the object's containertoolbar-target.
   Params:  <none>
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTarget   AS CHARACTER NO-UNDO.
  
  {get ContainerToolbarTarget cTarget}.
  RETURN cTarget.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContainerToolbarTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getContainerToolbarTargetEvents Procedure 
FUNCTION getContainerToolbarTargetEvents RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the list of events to be subscribed to in the
            ContainerToolbar-Target.  
   Params:  <none>
    Notes:             
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cEvents AS CHARACTER NO-UNDO.
  {get ContainerToolbarTargetEvents cEvents}.
  RETURN cEvents.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCreateSubMenuOnConflict) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCreateSubMenuOnConflict Procedure 
FUNCTION getCreateSubMenuOnConflict RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
 Purpose: Decides whether to create submenu for conflicting bands 
 Parameters: INPUT plCreateSubMenu 
             Yes - Create a submenu when a band already has linked actions for another toolbar. 
             No - Insert conflicting bands in same submenu
     Notes:
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lCreateSubMenu AS LOGICAL    NO-UNDO.

  {get CreateSubMenuOnConflict lCreateSubMenu}.
  RETURN lCreateSubMenu.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDeactivateTargetOnHide) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDeactivateTargetOnHide Procedure 
FUNCTION getDeactivateTargetOnHide RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Returns true if a target should be deactivated immediately on hide  
           If false the hidden targets are deactivated on view of another 
           target. 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lDeactivateTargetOnHide AS LOGICAL    NO-UNDO.
  {get DeactivateTargetOnHide lDeactivateTargetOnHide}.
  RETURN lDeactivateTargetOnHide.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDisabledActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDisabledActions Procedure 
FUNCTION getDisabledActions RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  RETURNS a comma separated list of disabled actions.
   Params:  <NONE>
    Notes: - The actions will be immediately disabled and subsequent calls 
             to enableActions will not enable them again. This makes it 
             possible to permanently disable actions independent of state 
             changes.
           - If you remove actions from the list they will be enabled the next
             time enableActions is used on them.
           - Use the modifyDisabledActions to add or remove actions. 
-----------------------------------------------------------------------------*/
DEFINE VARIABLE cActions AS CHARACTER  NO-UNDO.

  &SCOPED-DEFINE xpDisabledActions
  {get DisabledActions cActions}.
  &UNDEFINE xpDisabledActions

  RETURN cActions.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getEdgePixels) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getEdgePixels Procedure 
FUNCTION getEdgePixels RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the number of pixels that should be used to draw the
            rectangle around the buttons on a SmartPanel/toolbar.
            (max 2 on toolbar...)
   Params:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iValue AS INTEGER NO-UNDO.

  &SCOPED-DEFINE xpEdgePixels
  {get EdgePixels iValue}.
  &UNDEFINE xpEdgePixels
  
  RETURN iValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFlatButtons) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFlatButtons Procedure 
FUNCTION getFlatButtons RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/**
*   @desc  Get attribute
*   @return attribute value true/false
*/
/*------------------------------------------------------------------------------
  Purpose: Use flat buttons 
    Notes: NOT IN USE 
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lValue AS LOGICAL NO-UNDO.
  {get FlatButtons lValue}.
  RETURN lValue.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getHiddenActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getHiddenActions Procedure 
FUNCTION getHiddenActions RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  RETURNS a comma separated list of hidden actions.
   Params:  <NONE>
    Notes: - The actions will be immediately hidden or viewed.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cActions AS CHARACTER  NO-UNDO.
  &SCOPED-DEFINE xpHiddenActions
  {get HiddenActions cActions}.
  &UNDEFINE xpHiddenActions
  RETURN cActions.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getHiddenMenuBands) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getHiddenMenuBands Procedure 
FUNCTION getHiddenMenuBands RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cHiddenBands AS CHARACTER  NO-UNDO.
  {get HiddenMenuBands cHiddenBands}. 
 
  RETURN cHiddenBands.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getHiddenToolbarBands) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getHiddenToolbarBands Procedure 
FUNCTION getHiddenToolbarBands RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cHiddenBands AS CHARACTER  NO-UNDO.
  {get HiddenToolbarBands cHiddenBands}. 
 
  RETURN cHiddenBands.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getImagePath) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getImagePath Procedure 
FUNCTION getImagePath RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the opsys path of the images   
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cImagePath AS CHARACTER NO-UNDO.  
  {get ImagePath cImagePath}.
  RETURN cImagePath.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLinkTargetNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLinkTargetNames Procedure 
FUNCTION getLinkTargetNames RETURNS CHARACTER
 (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a list of the supported toolbar links. This is based on 
            either the tool's specified item-Link, or the Category the tools
            belong to.
   Params:  <none>
  Returns: CHARACTER
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cLinks AS CHARACTER NO-UNDO.
  {get LinkTargetNames cLinks}.
  RETURN cLinks.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getMenu Procedure 
FUNCTION getMenu /**
*   @desc  Get attribute
*   @return attribute value true/false
*/
RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns TRUE if a menu is to be generated
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lValue AS LOGICAL NO-UNDO.
  {get Menu lValue}.
  RETURN lValue.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMenuMergeOrder) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getMenuMergeOrder Procedure 
FUNCTION getMenuMergeOrder RETURNS INTEGER
  (   ) :
/*------------------------------------------------------------------------------
 Purpose: Decides the order of which the menus will be merged with other 
          toolbar instances. 
 Parameters: INPUT piOrder 
     Notes:
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iOrder AS INTEGER  NO-UNDO.
  {get MenuMergeOrder iOrder}.
  RETURN iOrder.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMinHeight) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getMinHeight Procedure 
FUNCTION getMinHeight RETURNS DECIMAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dHeight AS DECIMAL    NO-UNDO.
  
  &SCOPED-DEFINE xpMinHeight
  {get MinHeight dHeight}.
  &UNDEFINE xpMinHeight
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
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dWidth AS DECIMAL    NO-UNDO.
  
  &SCOPED-DEFINE xpMinWidth
  {get MinWidth dWidth}.
  &UNDEFINE xpMinWidth
  RETURN dWidth.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNavigationTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNavigationTarget Procedure 
FUNCTION getNavigationTarget RETURNS CHARACTER
  (  ) :
/**
*   @desc  Get attribute
*   @return attribute value true/false
*/
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

&ENDIF

&IF DEFINED(EXCLUDE-getNavigationTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNavigationTargetEvents Procedure 
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

&ENDIF

&IF DEFINED(EXCLUDE-getNavigationTargetName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNavigationTargetName Procedure 
FUNCTION getNavigationTargetName RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the ObjectName of the Data Object to be navigated by this
            panel. This would be set if the Navigation-Target is an SBO
            or other Container with DataObjects.
   Params:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTargetName AS CHAR   NO-UNDO.

  {get NavigationTargetName cTargetName}.
  RETURN cTargetName.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPanelState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPanelState Procedure 
FUNCTION getPanelState RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  DEPRECATED -- Returns the current state of the SmartPanel.
   Params:  <none>
    Notes:  DEPRECATED in the sense that the toolbar disabling/enabling 
            has been replaced by rule based state management. The function 
            is still callable and may still be called in odd cases.              
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cState AS CHARACTER NO-UNDO.

  &SCOPED-DEFINE xpPanelState
  {get PanelState cState}.
  &UNDEFINE xpPanelState
  
  RETURN cState.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPanelType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPanelType Procedure 
FUNCTION getPanelType RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the type of Panel: Navigation, Save, Update 
    Notes:  Is defined in toolbar class for backwards compatibility since it 
            was defined as an instance property. 
         -  The value for the toolbar is 'toolbar'.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cType AS CHARACTER NO-UNDO.
  {get PanelType cType}.
  RETURN cType.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRemoveMenuOnHide) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRemoveMenuOnHide Procedure 
FUNCTION getRemoveMenuOnHide RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
 Purpose: Decides whether the the menus should be removed from the menubar 
          on hide of the toolbar. 
 Parameters: INPUT plRemove 
     Notes:
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lRemoveMenu AS LOGICAL    NO-UNDO.
  {get RemoveMenuOnhide lRemoveMenu}.
  RETURN lRemoveMenu.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getShowBorder) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getShowBorder Procedure 
FUNCTION getShowBorder RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  True if a three-d border is to be used around the buttons 
            and as a delimiter when "RULE" is specified in createToolbar 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lShowBorder AS LOGICAL NO-UNDO.
  {get ShowBorder lShowBorder}.
  RETURN lShowBorder.
 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSubModules) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSubModules Procedure 
FUNCTION getSubModules RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  NOT USED
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSubModules AS CHAR NO-UNDO.
  {get SubModules cSubModules}.
  RETURN cSubModules.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTableioTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTableioTarget Procedure 
FUNCTION getTableioTarget RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns in CHARACTER form a list of the handles of the object's 
            TableIO Targets
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cTarget AS CHARACTER NO-UNDO.
  {get TableIOTarget cTarget}.
  RETURN cTarget.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTableioTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTableioTargetEvents Procedure 
FUNCTION getTableioTargetEvents RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a comma-separated list of the events this object wants 
            to subscribe to in its TableIO Target
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cEvents AS CHARACTER NO-UNDO.
  {get TableIOTargetEvents cEvents}.
  RETURN cEvents.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTableIOType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTableIOType Procedure 
FUNCTION getTableIOType RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns in CHARACTER form a list of the handles of the object's 
            TableIO Targets
   Params:  <none>
    Notes: This is the same as PanelType in the update panel
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cType AS CHARACTER NO-UNDO.
  {get TableIOType cType}.
  RETURN cType.

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

&IF DEFINED(EXCLUDE-getToolbar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getToolbar Procedure 
FUNCTION getToolbar /**
*   @desc  Get attribute
*   @return attribute value true/false
*/
RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Return TRUE if the toolbar is to be created 
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lValue AS LOGICAL NO-UNDO.
  {get Toolbar lValue}.
  RETURN lValue.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolbarAutoSize) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getToolbarAutoSize Procedure 
FUNCTION getToolbarAutoSize RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns whether the toolbar should be auto-sized to the width of
            the window at run-time. 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lToolbarAutoSize AS LOGICAL NO-UNDO.
  {get ToolbarAutoSize lToolbarAutoSize}.
  RETURN lToolbarAutoSize.
 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolbarBands) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getToolbarBands Procedure 
FUNCTION getToolbarBands RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the toolbar bands selected in the Instance Properties.    
    Notes:  NOt in use
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cToolbarBands AS CHARACTER NO-UNDO.
  {get ToolbarBands cToolbarBands}.
  RETURN cToolbarBands.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolbarDrawDirection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getToolbarDrawDirection Procedure 
FUNCTION getToolbarDrawDirection RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the draw direction of the toolbar (horizontal or vertical).    
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cToolbarDrawDirection AS CHARACTER NO-UNDO.
  {get ToolbarDrawDirection cToolbarDrawDirection}.
  RETURN cToolbarDrawDirection.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolbarHeightPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getToolbarHeightPxl Procedure 
FUNCTION getToolbarHeightPxl RETURNS INTEGER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Calculate the toolbar height from the three Properties
           ToolHeightPXL, ToolbarMarginPxl and ShowBorder.      
    Notes:  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE lShowBorder          AS LOG    NO-UNDO. 
 DEFINE VARIABLE iToolHeightPxl       AS INTEGER NO-UNDO.
 DEFINE VARIABLE iToolMarginPxl       AS INTEGER NO-UNDO.
 
 &SCOPED-DEFINE xp-assign
 {get ToolMarginPxl iToolMarginPxl}
 {get ToolHeightPxl iToolHeightPxl}.
 &UNDEFINE xp-assign
 
 /* If margin is less than 2, we must make space for the border */
 IF iToolMarginPxl < 2 THEN 
 DO:
   {get ShowBorder lShowBorder}.
   IF lShowBorder THEN
      iToolMarginPxl = 2.
 END. /* if ToolMargin < 2 */

 RETURN (iToolMarginPxl * 2) + iToolHeightPxl.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolbarMinWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getToolbarMinWidth Procedure 
FUNCTION getToolbarMinWidth RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose: Min width  
    Notes: Use getMinWidth - Kept for backwards compatibility  
------------------------------------------------------------------------------*/
  RETURN {fn getMinWidth}.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolbarParentMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getToolbarParentMenu Procedure 
FUNCTION getToolbarParentMenu RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the toolbar parent menu selected in the Instance Properties.    
   Notes: Only required if any toolbar menus need to be added under a specific
          submenu, which will also be created if it does not exist.    
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cToolbarParentMenu AS CHARACTER NO-UNDO.
  {get ToolbarParentMenu cToolbarParentMenu}.
  RETURN cToolbarParentMenu.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolbarTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getToolbarTarget Procedure 
FUNCTION getToolbarTarget RETURNS CHARACTER
    ( ):
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle of the object's toolbar-target.
   Params:  <none>
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTarget   AS CHARACTER NO-UNDO.
  
  {get ToolbarTarget cTarget}.
  RETURN cTarget.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolbarTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getToolbarTargetEvents Procedure 
FUNCTION getToolbarTargetEvents RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the list of events to be subscribed to in the
            Toolbar-Target.  
   Params:  <none>
    Notes:             
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cEvents AS CHARACTER NO-UNDO.
  {get ToolbarTargetEvents cEvents}.
  RETURN cEvents.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolbarWidthPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getToolbarWidthPxl Procedure 
FUNCTION getToolbarWidthPxl RETURNS INTEGER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Calculate the toolbar width from the three Properties
           ToolMaxWidthPXL, ToolbarMarginPxl and ShowBorder.      
    Notes: Used if toolbar is vertical aligned and assumes a single column.
------------------------------------------------------------------------------*/
 DEFINE VARIABLE lShowBorder          AS LOG    NO-UNDO. 
 DEFINE VARIABLE iToolWidthPxl        AS INTEGER NO-UNDO.
 DEFINE VARIABLE iToolMarginPxl       AS INTEGER NO-UNDO.
 DEFINE VARIABLE iToolMaxWidthPxl     AS INTEGER NO-UNDO.
 
 &SCOPED-DEFINE xp-assign
 {get ToolMarginPxl   iToolMarginPxl}
 {get ToolWidthPxl    iToolWidthPxl}
 {get ToolMaxWidthPxl iToolMaxWidthPxl}.
 &UNDEFINE xp-assign
 
 /* If margin is less than 2, we must make space for the border */
 IF iToolMarginPxl < 2 THEN 
 DO:
   {get ShowBorder lShowBorder}.
   IF lShowBorder THEN
      iToolMarginPxl = 2.
 END. /* if ToolMargin < 2 */

 RETURN (iToolMarginPxl * 2) + (IF iToolMaxWidthPxl > iToolWidthPxl THEN iToolMaxWidthPxl ELSE iToolWidthPxl).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolHeightPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getToolHeightPxl Procedure 
FUNCTION getToolHeightPxl RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iVar AS INTEGER    NO-UNDO.

  {get ToolHeightPxl iVar}. 

  RETURN iVar.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolMarginPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getToolMarginPxl Procedure 
FUNCTION getToolMarginPxl RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iMargin AS INTEGER    NO-UNDO.
  &SCOPED-DEFINE xpToolMarginPxl  
  {get ToolMarginPxl iMargin}. 
  &UNDEFINE xpToolMarginPxl

  RETURN iMargin.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolMaxWidthPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getToolMaxWidthPxl Procedure 
FUNCTION getToolMaxWidthPxl RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iVar AS INTEGER    NO-UNDO.

  {get ToolMaxWidthPxl iVar}. 

  RETURN iVar.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolSeparatorPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getToolSeparatorPxl Procedure 
FUNCTION getToolSeparatorPxl RETURNS INTEGER
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
Purpose:  
  Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iVar AS INTEGER    NO-UNDO.

    {get ToolSeparatorPxl iVar}. 

    RETURN iVar.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolSpacingPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getToolSpacingPxl Procedure 
FUNCTION getToolSpacingPxl RETURNS INTEGER
    ( /* parameter-definitions */ ) :
  /*------------------------------------------------------------------------------
    Purpose:  
      Notes:  
  ------------------------------------------------------------------------------*/
    DEFINE VARIABLE iVar AS INTEGER    NO-UNDO.

    {get ToolSpacingPxl iVar}. 

    RETURN iVar.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getToolWidthPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getToolWidthPxl Procedure 
FUNCTION getToolWidthPxl RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iVar AS INTEGER    NO-UNDO.

  {get ToolWidthPxl iVar}. 

  RETURN iVar.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getWindow Procedure 
FUNCTION getWindow RETURNS HANDLE
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Return the Window handle where the toolbar is  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hContainer       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hContainerSource AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cUIBMode         AS CHARACTER NO-UNDO.
  
  &SCOPED-DEFINE xp-assign
  {get ContainerHandle hContainer}
  {get UIBMode cUIBMode}.
  &UNDEFINE xp-assign
  
  IF cUIBmode = "":U THEN
  DO: 
    {get ContainerSource hContainerSource}.
    IF VALID-HANDLE(hContainerSource) THEN
    DO:
      {get ContainerHandle hContainer hContainerSource}.
       /* If this is not a window loop thru the parents until a window is found */
      DO WHILE VALID-HANDLE(hContainer) AND hContainer:TYPE <> "WINDOW":U:
        hContainer = hContainer:PARENT.
      END.      
      IF VALID-HANDLE(hContainer) THEN
         CURRENT-WINDOW = hContainer.
      RETURN hContainer.
    END.  
  END. 
  ELSE
  DO WHILE VALID-HANDLE(hContainer):
    
    IF hContainer:TYPE = "WINDOW":U THEN
      RETURN hContainer. 
    
    hContainer = hContainer:PARENT.
  END.  
  
  RETURN ?.     

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hasActiveGATarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION hasActiveGATarget Procedure 
FUNCTION hasActiveGATarget RETURNS LOGICAL
  (phObject AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose: Check if any group assign targets are active.
Pparameters: phObject - Procedure object that is tableioTarget and potential
                        GroupAssignTarget    
    Notes:   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cLinkHandles AS CHAR   NO-UNDO.
  DEFINE VARIABLE iLink        AS INT    NO-UNDO.
  DEFINE VARIABLE lHidden      AS LOG    NO-UNDO.
  DEFINE VARIABLE hObject      AS HANDLE NO-UNDO.
  
  cLinkHandles = DYNAMIC-FUNCTION("getGroupAssignTarget":U IN phObject) 
                 NO-ERROR.
  IF cLinkHandles <> "":U THEN
  DO iLink = 1 TO NUM-ENTRIES(cLinkHandles):
     hObject = WIDGET-HANDLE(ENTRY(iLink,cLinkHandles)).
     IF VALID-HANDLE(hObject) THEN
     DO:
       {get ObjectHidden lHidden hObject}. 
       IF NOT lHidden THEN
         RETURN TRUE. 
       ELSE IF {fnarg hasActiveGATarget hObject} THEN
         RETURN TRUE. 
     END. /* valid(hObject) */
  END.
  RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-imageName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION imageName Procedure 
FUNCTION imageName RETURNS CHARACTER
  ( pcAction AS CHAR,
    piNumber AS INT) :
/*------------------------------------------------------------------------------
   Purpose: Return the image name 
Parameters: pcaction - action name
            piNumber - Image number 1 or 2  
     Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cImagePath     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lUseRepository AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cImage        AS CHARACTER  NO-UNDO.
  
  {get UseRepository lUseRepository}.
  
  IF NOT lUseRepository THEN
  DO:
    {get ImagePath cImagePath}.
    cImagePath = (IF cImagePath <> "":U 
                  THEN cImagePath + "/":U
                  ELSE "":U).  
  END.

  RETURN cImagePath 
         + IF piNumber = 1 
           THEN {fnarg actionImage pcAction}
           ELSE {fnarg actionImageAlternate pcAction}.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-insertMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION insertMenu Procedure 
FUNCTION insertMenu RETURNS LOGICAL
  (pcParent  AS CHARACTER,
   pcActions AS CHARACTER,
   plExpand  AS LOGICAL,
   pcBefore  AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose: Create a set of menu-items or sub-menues under a parent menu  
            RETURNS true if ANY of the passed actions or its children
            where added to the menu.
Parameters:
  INPUT pcParent char  - The unique action name of an already inserted action.
                         Blank means that this is the top level (menu-bar)                     
  INPUT pcActions char - A comma separated list of actions or actionGroups
                         RULE specifies a delimiter.   
  INPUT plExpand log   - TRUE - actions that are parents is expanded. 
                         i.e that all the actions of the action group is added
                         as entries directly under this parent. 
                         FALSE actions that are parents is created as 
                         sub-menues and all their children is added as items
                         under it.   
  INPUT pcBefore       - The unique action name of an already inserted sibling
                         of the same parent.
                           
    Notes:  Menus are allowed based on whether their parent is allowed.
            Parent is allowed if they are in the ActionGroups or actionIsMenu
            if not actionIsMenu the action is added to the availmenuActions
            At design time this procedure needs to run even if 
            getMenu() is false add the parent to the the AvailMenuActions
            so they can be selected in the Instance Property dialog.
            We always look up the parent (Note: the actionParent is the defined
            parent not necessary the pcParent) and check if it's allowed and 
            add it to the AvailMenuActions if not actionIsMenu. 
            The function is called recursively for each action in the list 
            that isParent.
            The function prevents double RULEs from being entered. This is to 
            avoid double RULEs where menus did not have any children, this will
            will prevent double RULEs also when opassed in as parameters.    
            RULEs will be added first or last in case we are appending or 
            other calls are appending to the list. buildMenu() does the final 
            filtering to ensure that no RULE is first,last or double.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE i                  AS INT    NO-UNDO. 
  DEFINE VARIABLE cAction            AS CHAR   NO-UNDO.
  DEFINE VARIABLE hMenu              AS HANDLE NO-UNDO.
  DEFINE VARIABLE hWindow            AS HANDLE NO-UNDO.
  DEFINE VARIABLE cChild             AS CHAR   NO-UNDO.
  DEFINE VARIABLE cChildren          AS CHAR   NO-UNDO.
  DEFINE VARIABLE cParent            AS CHAR   NO-UNDO.  
  DEFINE VARIABLE lParentIsMenu      AS LOG    NO-UNDO.  
  DEFINE VARIABLE cActionGroups      AS CHAR   NO-UNDO.  
  DEFINE VARIABLE cAvailMenuActions  AS CHAR   NO-UNDO.  
  DEFINE VARIABLE lRule              AS LOG    NO-UNDO. 
  DEFINE VARIABLE lMenu              AS LOG    NO-UNDO. 
  DEFINE VARIABLE lIsParent          AS LOG    NO-UNDO. 
  DEFINE VARIABLE cTableIOType       AS CHAR   NO-UNDO.
  DEFINE VARIABLE cUIBMode           AS CHAR   NO-UNDO.
  DEFINE VARIABLE lParentOK          AS LOG    NO-UNDO. 
  DEFINE VARIABLE lReturnOK          AS LOG    NO-UNDO. 
  
  &SCOPED-DEFINE xp-assign
  {get TableIOType cTableIoType}
  {get Menu lMenu}
  {get UIBMode cUIBMode}.
  &UNDEFINE xp-assign
  
  /* No need to do this at run-time if menues is not used */
  IF NOT lMenu AND cUIBMode <> "Design":U THEN
    RETURN FALSE.
  
  {get ActionGroups cActionGroups}.

  DO i = 1 TO NUM-ENTRIES(pcActions):    
    cAction   = ENTRY(i,pcActions).
    /* Avoid double RULEs if some of the groups are skipped */
    IF cAction = "RULE":U AND lRule THEN    
      NEXT.   
    
    cParent  = {fnarg actionParent cAction}.
    
    /* If the parent is a defined action we add it to the availableGroups
       and check if it is allowed */
    IF {fnarg canFindAction cParent} THEN
    DO:
      IF {fnarg actionIsMenu cParent} THEN 
        lParentOk = TRUE.      
      ELSE 
      DO:
        lParentOk = CAN-DO(cActionGroups,cParent). 
        {get AvailMenuActions cAvailMenuActions}. 
    
        IF NOT CAN-DO(cAvailMenuActions,cParent) THEN
        DO:
          ASSIGN cAvailMenuActions = 
                  cAvailMenuActions 
                  + (IF cAvailMenuActions = "":U THEN "":U ELSE ",":U)
                  + cParent.      
          /* Set the available actionsgroups for the Instance Property dialog */      
          {set AvailMenuActions cAvailMenuActions}.  
        END. /* not in availMenu actions */
      END.
    END. /* if findAction(parent)  */
    ELSE /* Undefined parents are always inserted. */
      lParentOk = TRUE.
    
    /* Don't bother if this menu is not going to be added */
    IF (CAN-DO(cActionGroups,cAction) OR {fnarg actionIsMenu cAction}) THEN
      {fnarg actionPublishCreate cAction}.

    lIsParent = {fnarg actionIsParent cAction}.    
    
    IF lMenu AND lParentOK
    AND (cAction <> "UPDATE":U OR cTableIoType = "UPDATE":U)
    AND ((NOT lIsParent)
        OR
        (lIsParent AND 
         (CAN-DO(cActionGroups,cAction) OR {fnarg actionIsMenu cAction})  AND
         NOT plExpand)) THEN
    DO:
      DYNAMIC-FUNCTION("insertMenuTempTable":U IN TARGET-PROCEDURE, 
                        pcParent,cAction,pcBefore).        
      ASSIGN
       lReturnOK = TRUE
       lRule = (cAction = "RULE":U).
    END. /* if lmenu and parentok ...*/
    
    /* If this is a parent we need to add the children */ 
    IF lIsParent THEN
    DO:
      IF DYNAMIC-FUNCTION("insertMenu":U IN TARGET-PROCEDURE,
                           IF plExpand THEN pcParent ELSE cAction,
                           {fnarg actionChildren cAction}, 
                            NO,
                           ?)                                THEN
      DO: 
        ASSIGN
          lRule     = FALSE
          lReturnOK = TRUE.
      END. /* if insertMenu */
      
      /* This is the rare situation where the action is parent, but don't 
        have children at design-time so it did not get added in the recursive 
        call */
      IF NOT {fnarg actionIsMenu cAction} THEN
      DO:
        {get AvailMenuActions cAvailMenuActions}. 
        IF NOT CAN-DO(cAvailMenuActions,cAction) THEN
        DO:
          ASSIGN cAvailMenuActions = 
                    cAvailMenuActions 
                    + (IF cAvailMenuActions = "":U THEN "":U ELSE ",":U)
                    + cAction.      
          /* Set the available actionsgroups for the Instance Property dialog */      
          {set AvailMenuActions cAvailMenuActions}.  
        END. /* not in availMenu actions */
      END.
    END. /* if lIsParent */
  END. /* i = 1 to num-entries */
  
  RETURN lReturnOk.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-insertMenuTempTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION insertMenuTempTable Procedure 
FUNCTION insertMenuTempTable RETURNS LOGICAL PRIVATE
  (pcParent    AS CHAR,
   pcName      AS CHAR,
   pcBefore    AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Create the temp-table for the menu.
Parameters:
         INPUT pcParent - The unique action name of an already created parent
                        - Blank means that this is the top level (menu-bar)
         INPUT pcName   - A unique name
         INPUT pcBefore - The unique action name of an already created sibling
                                 
  Notes: PRIVATE  
         This is called before the menu is built in order to be able to insert 
         actions.
         Because some disable and enable actions may take place BEFORE
         initialize some tmenu record may exist with "*" as parent.  
------------------------------------------------------------------------------*/
  DEFINE BUFFER btMenu FOR tMenu.
  DEFINE VARIABLE iSeq         AS INT  NO-UNDO.
  
  FIND LAST btMenu WHERE btMenu.Parent  = pcParent 
                   AND   btMenu.hTarget = TARGET-PROCEDURE NO-ERROR.
                   
  iSeq = IF AVAIL btMenu THEN btMenu.Seq + 1 ELSE 1. 
            
  /* loop from the end to increase the sequence of everyone 
     we are supposed to be before. 
     (If before is not found we will add the entry first ) */
  DO WHILE AVAIL btMenu AND pcBefore <> ? :    
    ASSIGN
      iSeq       = btMenu.Seq
      btMenu.Seq = btMenu.Seq + 1.  
    
    IF btMenu.Name = pcBefore THEN LEAVE.
    
    FIND PREV btMenu WHERE btMenu.Parent  = pcParent 
                     AND   btMenu.hTarget = TARGET-PROCEDURE NO-ERROR. 
    
  END. /* do while avail btMenu */ 

  /* Only ONE entry of each action, except for RULE. 
     The last entry will potentially change the parent.
     The menu may also exist with "*" as parent because it was enabled/disabled
     before insert */
  IF pcName <> "RULE":U THEN
    FIND tMenu WHERE tMenu.hTarget = TARGET-PROCEDURE 
               AND   tMenu.NAME    = pcName NO-ERROR. 
  
  IF NOT AVAIL tMenu OR pcName = "RULE":U THEN 
  DO:
    CREATE tMenu.  
    ASSIGN 
      tMenu.Link      = {fnarg actionLink pcName}
      tMenu.hTarget   = TARGET-PROCEDURE
      tMenu.Name      = pcName
      tMenu.Sensitive = FALSE.
  END.
  ASSIGN
    tMenu.Parent  = pcParent
    tMenu.Seq     = iSeq.    
  
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-linkRuleBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION linkRuleBuffer Procedure 
FUNCTION linkRuleBuffer RETURNS HANDLE
     (pcLink   AS CHAR, 
      phTarget AS HANDLE) :
/*------------------------------------------------------------------------------
    Purpose: Create the dynamic table used to check the rules against a target 
 Parameters: pcLink    - Linkname 
             phTarget  - Handle of any Target 
                         we do not create this again if the link is switched
                         but assume that all objects of same type have the same 
                         api. (if not found the data-type will be set to 
                         character)  
      Notes:               
------------------------------------------------------------------------------*/    
DEFINE VARIABLE cDlm          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLoop         AS INTEGER    NO-UNDO.
DEFINE VARIABLE cRule         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cRuleEntry    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFuncOp       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFunction     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cProp         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFuncList     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDataTypeList AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iRule         AS INTEGER    NO-UNDO.
DEFINE VARIABLE cDatatype     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hTable        AS HANDLE     NO-UNDO.
DEFINE VARIABLE hBuffer       AS HANDLE     NO-UNDO.
DEFINE VARIABLE lFieldsAdded  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE iNumErrors    AS INTEGER    NO-UNDO.

DEFINE BUFFER bttAction FOR ttAction.


 FIND ttLinkRuleTable WHERE ttLinkRuleTable.Linkname = pcLink
                     AND   ttLinkRuleTable.ProcedureHandle = TARGET-PROCEDURE
 NO-ERROR.

 IF AVAIL ttLinkRuleTable THEN
 DO:
   /* If we have a buffer with no field errors just return the handle
      OR 
      if we already have attempted to find the methods in this target 
      then return it whether it is valid or not 
      OR 
      if we already have tried the predefined number of attempts 
      then also return it whether it is valid or not */ 
   IF (VALID-HANDLE(ttLinkRuleTable.BufferHandle) 
       AND ttLinkRuleTable.NumErrors = 0)
   OR CAN-DO(ttLinkRuleTable.LinkHandles,STRING(phTarget))    
   OR NUM-ENTRIES(ttLinkRuleTable.LinkHandles) >= xiMaxLinkChecks  THEN 
      RETURN ttLinkRuleTable.BufferHandle.   
   
 END.
 ELSE DO:
   CREATE ttLinkRuleTable.
   ASSIGN
     ttLinkRuleTable.Linkname        = pcLink
     ttLinkRuleTable.ProcedureHandle = TARGET-PROCEDURE.
 END.

 /* Log the target handle so the check above can find it the next time */
 ASSIGN 
   ttlinkRuleTable.LinkHandles = ttlinkRuleTable.LinkHandles 
                               + (IF ttlinkRuleTable.LinkHandles = '':U
                                  THEN '':U
                                  ELSE ',':U)
                               + STRING(phTarget) 

   cFuncOp = '=':U
   cDlm    = CHR(1).

 CREATE TEMP-TABLE hTable.

 FOR EACH bttAction WHERE bttAction.link = pcLink 
                    AND  (bttAction.EnableRule <> '':U
                          OR
                          bttAction.HideRule <> '':U 
                          OR
                          bttAction.ImageAlternateRule <> '':U
                          OR 
                          bttAction.Type = 'PROPERTY':U):  
   DO iRule = 1 TO 4:
     ASSIGN
       cProp = '':U
       cRule = '':U.
     CASE iRule:
       WHEN 1 THEN 
         cRule = bttAction.EnableRule.
       WHEN 2 THEN
         cRule = bttAction.HideRule.
       WHEN 3 THEN
         cRule = bttAction.ImageAlternateRule.
       OTHERWISE 
         cProp = IF bttAction.Type = 'PROPERTY':U
                 THEN bttAction.OnChoose
                 ELSE '':U.
     END.
     IF cRule <> '':U OR cProp <> '':U THEN
     DO:
       IF cRule <> '':U THEN
         ASSIGN 
          cRule  = REPLACE(cRule,' and ':U,cDlm)
          cRule  = REPLACE(cRule,' or ':U,cDlm).
       
       DO iLoop = 1 TO IF cRule = '':U THEN 1 ELSE NUM-ENTRIES(cRule,cDlm):
         /* 1 2 3 = Rules */
         IF cRule <> '':U THEN
           ASSIGN
             cRuleEntry = TRIM(ENTRY(iLoop,cRule,cDlm))
             cFunction  = ENTRY(1,cRuleEntry,cFuncOp)
             cProp      = (IF INDEX(cFunction,'(':U) = 0 THEN cFunction ELSE '')  
             cFunction  = (IF INDEX(cFunction,'(':U) > 0  
                           THEN ENTRY(1,cFunction,'(':U)
                           ELSE 'get':U + cFunction).
         ELSE 
           cFunction = 'get':U + cProp.
         
         IF cFunction <> '':U AND NOT CAN-DO(cFuncList,cFunction) THEN
         DO:
           ASSIGN
             cFuncList = cFuncList + ",":U + cFunction
             cDataType = {fnarg propertyType cProp phTarget}
             lFieldsAdded = TRUE.
           
           IF cDataType = ? THEN 
           DO:
             cDataType = ENTRY(2,{fnarg signature cFunction phTarget}) NO-ERROR.
             IF cDataType = ?  THEN 
               ASSIGN iNumErrors = iNumErrors + 1.
           END.
           hTable:ADD-NEW-FIELD(cFunction,(IF cDataType <> ? THEN cdataType ELSE 'CHARACTER':U),0,?,?).
         END.
       END. /* loop through the function in rules or  prop */
     END. /* rule or property found */
   END. /* do i loop 1 to 4  */
 END. /* for each tAction */
 
 /* If any fields found and this is new or has less errors than the old 
    then prepare the temp-table */ 
 IF lFieldsAdded 
 AND (NOT VALID-HANDLE(ttlinkRuleTable.TableHandle) 
      OR
      iNumErrors < ttlinkRuleTable.NumErrors) THEN
 DO:
    /* Delete the old if it exists */
    IF VALID-HANDLE(ttlinkRuleTable.TableHandle) THEN
        DELETE OBJECT ttlinkRuleTable.TableHandle NO-ERROR.
    /* prepare the TT  */
    hTable:TEMP-TABLE-PREPARE(pcLink).
    ASSIGN
      ttLinkRuleTable.NumErrors   = iNumErrors
      ttlinkRuleTable.TableHandle = hTable
      ttlinkRuleTable.BufferHandle = ttlinkRuleTable.TableHandle:DEFAULT-BUFFER-HANDLE. 
    /* and create a record in the buffer */
    ttlinkRuleTable.BufferHandle:BUFFER-CREATE().
 END.
 ELSE 
   DELETE OBJECT hTable NO-ERROR.

 RETURN ttlinkRuleTable.BufferHandle.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadImage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION loadImage Procedure 
FUNCTION loadImage RETURNS LOGICAL PRIVATE
  ( phObject AS HANDLE,
    pcImage AS CHARACTER ) :
/*------------------------------------------------------------------------------
  ACCESS_LEVEL=PRIVATE
  Purpose:  Loads the image into the object, typically a button    
   Params:  phObject  Handle of object (i.e. button)
            pcImage:  Relative name of image with optional offsets.
                       <image>, <X offset>, <Y offset>, <width>, <height>
   Notes:  The image may contain a delimited list specifying the offsets, width
           and height. 
           This is a utility that should not access object properties.
------------------------------------------------------------------------------*/
DEFINE VARIABLE cSearchImage          AS CHARACTER  NO-UNDO.  
DEFINE VARIABLE lImageLoad            AS LOGICAL    NO-UNDO.
DEFINE VARIABLE iImageOffsetX         AS INTEGER    NO-UNDO.
DEFINE VARIABLE iImageOffsetY         AS INTEGER    NO-UNDO.
DEFINE VARIABLE iImageWidth           AS INTEGER    NO-UNDO.
DEFINE VARIABLE iImageHeight          AS INTEGER    NO-UNDO.
DEFINE VARIABLE cImage                AS CHARACTER  NO-UNDO.  

IF pcImage = ? OR pcImage = "" THEN
    RETURN FALSE.

 /* Calculate the image directory and load all subsequent images specifying the full 
    path and assuming the same directory for the images. This eliminates the need to 
    redo a SEARCH for each image.  If the image load fails, only then is a search done again. */
 IF gcImageDirectory = "" THEN
 DO:
   ASSIGN cSearchImage =  REPLACE(SEARCH(ENTRY(1,pcImage)),"~\","/")
          pcImage      = REPLACE(pcImage,"~\","/").
   IF cSearchImage <> ? THEN
      ASSIGN gcImageDirectory =  SUBSTRING(cSearchImage,1,R-INDEX(cSearchImage,ENTRY(1,pcImage)) - 1)
             gcImageDirectory =  REPLACE(gcImageDirectory,"~\":U, "/")
             gcImageDirectory =  RIGHT-TRIM(gcImageDirectory,"/":U)  NO-ERROR.
 END.

 /* Test whether offsets are specified in the image file, if yes load with specified offsets */
 IF NUM-ENTRIES(pcImage) > 1 THEN
 DO:
    ASSIGN cImage        = ENTRY(1,pcImage)
           iImageOffsetX = INT(ENTRY(2,pcImage))
           iImageOffsetY = INT(ENTRY(3,pcImage))
           iImageWidth   = INT(ENTRY(4,pcImage))
           iImageHeight  = INT(ENTRY(5,pcImage))
           NO-ERROR.
    IF iImageWidth  = 0 THEN iImageWidth  = 16.
    IF iImageHeight = 0 THEN iImageHeight = 16.

    lImageLoad = phObject:LOAD-IMAGE( gcImageDirectory + (IF gcImageDirectory > "" THEN "/":U ELSE "")
                                                       + cImage,
                                      iImageOffsetX, iImageOffsetY, iImageWidth,iImageHeight) NO-ERROR.         
 END.
 ELSE
    lImageLoad = phObject:LOAD-IMAGE( gcImageDirectory + (IF gcImageDirectory > "" THEN "/":U ELSE "")
                                                       + pcImage )  NO-ERROR.
 /* If image fails to load, it may be a result of the imageDirectory being invalid for the specified image.
    Perform a SEARCH to find whether the image is in the Propath and re-calculate the Full Path and assign to
    the imageDirectory variable for later use */
 IF NOT lImageLoad THEN
 DO:
    cSearchImage =  REPLACE(SEARCH(ENTRY(1,pcImage)),"~\":U,"/"). 
    IF cSearchImage <> ? THEN
    DO:
       ASSIGN gcImageDirectory =  SUBSTRING(cSearchImage,1,R-INDEX(cSearchImage,ENTRY(1,pcImage)) - 1) 
              gcImageDirectory =  REPLACE(gcImageDirectory,"~\":U, "/")
              gcImageDirectory =  RIGHT-TRIM(gcImageDirectory,"/":U)  NO-ERROR.
        IF NUM-ENTRIES(pcImage) > 1 THEN
            lImageLoad = phObject:LOAD-IMAGE(cSearchImage,iImageOffsetX, iImageOffsetY, iImageWidth,iImageHeight) NO-ERROR.
        ELSE    
           lImageLoad = phObject:LOAD-IMAGE(cSearchImage) NO-ERROR.     
    END.
 END.

  
 RETURN lImageLoad.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-menuHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION menuHandle Procedure 
FUNCTION menuHandle RETURNS HANDLE PRIVATE
  (pcName AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Return the handle of a menu.
PArameters: INPUT pcName - The action name of a menu.    
    Notes: PRIVATE     
------------------------------------------------------------------------------*/
  FIND tMenu WHERE tMenu.hTarget = TARGET-PROCEDURE
             AND   tMenu.Name = pcName NO-ERROR.

  IF AVAIL tMenu THEN RETURN tMenu.Hdl.
  
  RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-modifyDisabledActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION modifyDisabledActions Procedure 
FUNCTION modifyDisabledActions RETURNS LOGICAL
  ( pcMode    AS CHAR,
    pcActions AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Modify the DisabledActions property and make it possible to 
           permanently disable actions independent of state changes. 
Parameters: pcMode  
               - "ADD"    - Adds the actions to the DisabledActions.
               - "REMOVE" - Removes the actions from the DisabledActions.
            pcActions - Comma separated list of actions          
   Notes:  - ADD: The actions will be immediately disabled and subsequent calls 
             to enableActions will not enable them again.
             REMOVE: Actions that are removed from the list will be enabled 
             the next time they are called with enableActions.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDisabledActions AS CHAR NO-UNDO.
  DEFINE VARIABLE cAction          AS CHAR NO-UNDO.
  DEFINE VARIABLE iLoop            AS INT  NO-UNDO.
  DEFINE VARIABLE iNum             AS INT  NO-UNDO.
  DEFINE VARIABLE iAction          AS INT  NO-UNDO.

  {get DisabledActions cDisabledActions}.  
  DO iLoop = 1 TO NUM-ENTRIES(pcActions):
    ASSIGN
      cAction = ENTRY(iLoop,pcActions)
      iNum    = LOOKUP(cAction,cDisabledActions).
    
    IF iNum = 0 AND pcMode = 'ADD':U THEN
      cDisabledActions = cDisabledActions
                         + (IF cDisabledActions = "":U THEN "":U ELSE ",":U)
                         + cAction.

    ELSE IF iNum <> 0 AND pcMode = 'REMOVE':U THEN
                /* Add comma before and after entry to make sure we replace 
                   a complete action.
                   Add comma before and after the list to replace first,last.
                   Trim any leading or trailing commas away  */
                      
      cDisabledActions = TRIM(REPLACE(",":U + cDisabledActions + ",":U,
                                      ",":U + cAction + ",":U,","),
                              ",":U). 
  END. /* do iloop = 1 to num-entries */

  RETURN {set DisabledActions cDisabledActions}.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-moveMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION moveMenu Procedure 
FUNCTION moveMenu RETURNS HANDLE
  ( phMenu      AS HANDLE,
    phNewParent AS HANDLE) :
/*------------------------------------------------------------------------------
   Purpose: Move a menu 
 Parameter: phMenu      - menu to move.
            phNewParent - new parent
     Notes: creates a new tree and deletes the existing so make sure 
            the next-sibling is available before this is called if this is
            done in a widget-tree loop. (or use moveMenuChildren)
------------------------------------------------------------------------------*/
  DEFINE BUFFER btMenu FOR tMenu.  
  DEFINE BUFFER btBandInstance FOR tBandInstance. 

  DEFINE VARIABLE hNewMenu AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRule    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cUIBmode AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTarget  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hMenubar AS HANDLE    NO-UNDO.

  &SCOPED-DEFINE xp-assign
  {get UIBMode cUIBMode}
  {get MenuBarHandle hMenuBar}
  .
  &UNDEFINE xp-assign
  
  CASE phMenu:TYPE:
    WHEN 'menu-item':U THEN
    DO:
      /* We create the menu-item in a widget-pool as they may belong to 
        other toolbars and must not go away with whatever toolbar created 
        the last widget-pool
      */
      CREATE MENU-ITEM hNewMenu  IN WIDGET-POOL {&menuwidgetpool} + STRING(hMenuBar:OWNER) 
        ASSIGN 
          SUBTYPE   = phMenu:SUBTYPE
          SENSITIVE = phMenu:SENSITIVE.
      
      FIND btMenu WHERE btMenu.hdl  = phMenu NO-ERROR. 
       
      ASSIGN 
        /* if the hdl is not unique in btMenu then another target has reused 
           it and it should not matter which toolbar that fires the trigger */              
        hTarget = IF AVAIL btMenu THEN btMenu.hTarget ELSE TARGET-PROCEDURE 
        hNewMenu:LABEL       = phMenu:LABEL WHEN CAN-SET(hNewMenu,'LABEL':U)
        hNewMenu:ACCELERATOR = phMenu:ACCELERATOR WHEN CAN-SET(hNewMenu,'ACCELERATOR':U)
        hNewMenu:TOGGLE-BOX  = phMenu:TOGGLE-BOX WHEN CAN-QUERY(hNewMenu,'TOGGLE-BOX':U)
        hNewMenu:NAME        = phMenu:NAME WHEN phMenu:NAME <> ?
      .
      IF cUIBMode <> "Design":U AND CAN-QUERY(hNewMenu,'TOGGLE-BOX':U)  THEN
      DO:
        IF hNewMenu:TOGGLE-BOX THEN
          ON VALUE-CHANGED OF hNewMenu 
           PERSISTENT RUN OnValueChanged IN hTarget(phMenu:NAME).
        ELSE
          ON CHOOSE OF hNewMenu 
            PERSISTENT RUN OnChoose IN hTarget(phMenu:NAME).
      END.
    END.
    WHEN 'sub-menu':U THEN
    DO:
      FIND btMenu WHERE btMenu.hdl  = phMenu NO-ERROR. 
      /* if the hdl is not unique in btMenu then another target has reused 
         it and it should not matter which toolbar that fires the trigger */                    
      IF AVAIL btMenu THEN 
        hTarget = btMenu.hTarget.
      ELSE  /* ad-hoc merge-conflict submenus have name label:target */ 
        hTarget = WIDGET-HANDLE(ENTRY(2,phMenu:NAME,':')) NO-ERROR.
      
      IF NOT VALID-HANDLE(hTarget) THEN
        hTarget = TARGET-PROCEDURE.

      /* We create the submenu in a widget-pool as they may belong to other toolbars
         and must not go away with whatever toolbar created the last widget-pool
      */
      CREATE SUB-MENU hNewMenu IN WIDGET-POOL {&menuwidgetpool} + STRING(hMenuBar:OWNER) 
       ASSIGN 
          LABEL       = phMenu:LABEL
          SENSITIVE   = phMenu:SENSITIVE 
       TRIGGERS :
         ON MENU-DROP PERSISTENT RUN onMenuDrop IN hTarget (phMenu:Name).
       END.
       ASSIGN hNewMenu:NAME  = phMenu:NAME WHEN phMenu:NAME <> ?.

       DYNAMIC-FUNCTION('moveMenuChildren':U IN TARGET-PROCEDURE,
                         phMenu,
                         hNewMenu).
    END.
  END CASE.

  hNewMenu:PARENT = phNewParent.
  
  FOR EACH btMenu WHERE btMenu.Hdl = phMenu:
    ASSIGN btMenu.Hdl = hNewMenu.
  END.
  FOR EACH btBandInstance WHERE btBandInstance.Hdl = phMenu:
    ASSIGN btBandInstance.Hdl = hNewMenu.
  END.
 
  /* remove duplicate rules */
  IF phNewParent = phMenu:PARENT THEN
  DO:
    hRule = phMenu:PREV-SIBLING.
    IF VALID-HANDLE(hRule) AND hRule:TYPE = 'menu-item':U AND hRule:SUBTYPE = 'RULE' THEN
    DO:
      hRule = phMenu:NEXT-SIBLING. 
      IF VALID-HANDLE(hRule) AND hRule:TYPE = 'menu-item':U AND hRule:SUBTYPE = 'RULE' THEN
      DO:
        FOR EACH btMenu WHERE btMenu.Hdl = hRule:
          ASSIGN btMenu.Hdl = ?.
        END.
        DELETE OBJECT hRule.
      END. /* next.. if valid-handle(hRule) AND hRule:SUBTYPE = */
    END. /* prev.. if valid-handle(hRule) AND hRule:SUBTYPE = 'RULE' */
  END. /*phNewParent = phMenu:parent */

  DELETE OBJECT phMenu.
  
  RETURN hNewMenu.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-moveMenuChildren) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION moveMenuChildren Procedure 
FUNCTION moveMenuChildren RETURNS LOGICAL
  ( phOldParent AS HANDLE,
    phNewParent AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hMoveMenu AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hMenu     AS HANDLE     NO-UNDO.
  
  hMenu = phOldParent:FIRST-CHILD.
  DO WHILE VALID-HANDLE(hMenu):
    ASSIGN
      hMoveMenu = hMenu /* we must get next before we call moveMenu because 
                          it will be deleted */
      hMenu = hMenu:NEXT-SIBLING.
    DYNAMIC-FUNCTION('moveMenu':U IN TARGET-PROCEDURE,
                      hMoveMenu,
                      phNewParent).
  END.

  RETURN TRUE.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-normalizeActionData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION normalizeActionData Procedure 
FUNCTION normalizeActionData RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Remove duplicate entries of temp-tables after load
    Notes:  The procedurehandle is used to identify data that has just been 
            added 
------------------------------------------------------------------------------*/   
 DEFINE BUFFER bttAction   FOR ttAction.
 DEFINE BUFFER bttCategory FOR ttCategory.
 
 /* For actions, always use the extracted record to ensure we're up to date */
 FOR EACH ttAction WHERE ttAction.ProcedureHandle = ?:
   FIND bttAction
        WHERE bttAction.Action             =  ttAction.Action
          AND bttAction.ProcedureHandle <> ?
        NO-ERROR.

   IF AVAILABLE bttAction THEN
     DELETE bttAction.

   ASSIGN ttAction.ProcedureHandle = THIS-PROCEDURE.
 END.

 FOR EACH ttCategory WHERE ttCategory.ProcedureHandle = ?:
   IF CAN-FIND(FIRST bttCategory 
               WHERE bttCategory.Category        =  ttCategory.Category
                 AND   bttCategory.ProcedureHandle <> ?) THEN
     DELETE ttCategory.
   ELSE  
     ttCategory.ProcedureHandle = THIS-PROCEDURE.

 END.
 
 RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-prepareRuleTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION prepareRuleTable Procedure 
FUNCTION prepareRuleTable RETURNS CHARACTER
  ( phTable AS HANDLE,
    pcLink  AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN "".   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removeMenuBand) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION removeMenuBand Procedure 
FUNCTION removeMenuBand RETURNS LOGICAL
  ( pcBand AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Remove the menu of the band from the menubar. 
    Notes: Called from removeMenu 
           Calls buildMenuBand to refresh menus after removal
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cGrandParent AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hMenuBar     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hParent      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hSubMenu     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRule        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRuleDel     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hStale       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hStaleDel    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE rRowid       AS ROWID      NO-UNDO.
  DEFINE VARIABLE iSub         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cParentMenuKey AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMenuName      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMenuKey       AS CHARACTER  NO-UNDO.


  DEFINE BUFFER btThisMenu  FOR tMenu.
  DEFINE BUFFER btMenu      FOR tMenu.
  DEFINE BUFFER btParent    FOR tMenu.
  DEFINE BUFFER btBandMenu  FOR tMenu.
  DEFINE BUFFER btParentInstance     FOR tBandInstance.
  DEFINE BUFFER btThisBandInstance   FOR tBandInstance.
  DEFINE BUFFER btBandInstance       FOR tBandInstance.

  {get MenuBarHandle hMenuBar}.

  FIND btParentInstance WHERE btParentInstance.Band    = pcBand 
                        AND   btParentInstance.hTarget = TARGET-PROCEDURE NO-ERROR.  
  
 
  IF NOT AVAIL btParentInstance THEN
    RETURN FALSE.
  
  IF btParentInstance.MenuName > '':U THEN
  DO:
    FIND btParent WHERE btParent.Name    = btParentInstance.MenuName 
                  AND   btParent.hTarget = TARGET-PROCEDURE NO-ERROR.
    
    IF AVAIL btParent THEN
    DO:
      cGrandParent = btParent.PARENT. 
    END.
  END.

  FOR EACH btThisMenu WHERE btThisMenu.MenubarHdl    = hMenuBar
                      AND   btThisMenu.ParentMenuKey = btParentInstance.MenuKey
                      AND   btThisMenu.hTarget     = TARGET-PROCEDURE:  
    
    hSubMenu = ?.  

    /* Remove directly inserted placeholder items (InsertSubMenu = No) */ 
    IF {fnarg actionControlType btThisMenu.NAME} = 'Placeholder':U THEN
    DO:
      FOR EACH btThisBandInstance 
               WHERE btThisBandInstance.hTarget     = TARGET-PROCEDURE
               AND   btThisBandInstance.PlaceHolder = btThisMenu.Name: 
        {fnarg removeMenuBand btThisBandInstance.Band}.
        DELETE btThisBandInstance.
      END.
    END.

    FIND btThisBandInstance WHERE btThisBandInstance.MenuKey  = btParentinstance.MenuKey 
                                                              + (IF btParentInstance.MenuKey = ''
                                                                 THEN ''
                                                                 ELSE {&pathdlm})
                                                              + btThisMenu.NAME
                            AND   btThisBandInstance.hTarget  = TARGET-PROCEDURE NO-ERROR.

    IF AVAIL btThisBandInstance THEN
    DO:
      {fnarg removeMenuBand btThisBandInstance.Band}.
    END.
    ELSE 
      RELEASE btThisBandInstance.
    
    IF VALID-HANDLE(btThisMenu.hdl) THEN
    DO:
      rRowid = ?.
      FOR EACH btMenu WHERE btMenu.MenubarHdl    = hMenuBar
                      AND   btMenu.ParentMenuKey = btThisMenu.ParentMenuKey 
                      AND   btMenu.NAME          = btThisMenu.Name
                      AND   NOT VALID-HANDLE(btMenu.hdl)
                        BY btMenu.MenubarHdl
                        BY btMenu.ParentMenuKey                    
                        BY btMenu.Mergeorder
                        BY btMenu.Pageno 
                        BY btMenu.hTarget
                        BY btMenu.seq:
          
          rRowid = ROWID(btMenu).
          IF btThisMenu.Seq = 1 THEN
            LEAVE.
      END.
        
      /* If we found the menu that should take the place of the one that 
         is being deleted then give the handle and triggers to it.  */
      IF rRowid <> ? THEN
      DO:
        FIND btMenu WHERE ROWID(btMenu) = rRowid.    
        ASSIGN
          btMenu.Hdl     = btThisMenu.Hdl
          btThisMenu.Hdl = ?. 
        
        IF AVAIL btThisBandInstance THEN
        DO:
          ON MENU-DROP OF btMenu.Hdl 
            PERSISTENT RUN OnMenuDrop IN btMenu.hTarget(btMenu.Hdl:NAME).
          FIND btBandInstance 
              WHERE btBandInstance.MenuName = btThisBandInstance.MenuName
              AND   btBandInstance.hTarget  = btMenu.htarget.
          ASSIGN
            btBandInstance.hdl = btMenu.Hdl
            hSubMenu           = btMenu.hdl.
        END.
        ELSE IF btMenu.hdl:TYPE = 'menu-item':U AND btMenu.Hdl:SUBTYPE = 'normal':U THEN
        DO:
          IF btMenu.Hdl:TOGGLE-BOX THEN
            ON VALUE-CHANGED OF btMenu.Hdl 
              PERSISTENT RUN OnValueChanged IN btMenu.hTarget(btMenu.Hdl:NAME).
          ELSE
            ON CHOOSE OF btMenu.Hdl
              PERSISTENT RUN OnChoose IN btMenu.hTarget(btMenu.Hdl:NAME).
        END.
      END.
      IF VALID-HANDLE(btThisMenu.Hdl) THEN
         DELETE OBJECT btThisMenu.hdl.      
    END. /* for each */
    ELSE IF AVAIL btThisBandInstance THEN
    DO:
      FIND FIRST btMenu WHERE btMenu.MenubarHdl    = hMenuBar
                        AND   btMenu.ParentMenuKey = btThisMenu.ParentMenuKey
                        AND   btMenu.NAME        = btThisMenu.Name
                        AND   VALID-HANDLE(btMenu.hdl) NO-ERROR.
      IF AVAIL btMenu THEN
        hSubMenu = btMenu.Hdl.
    
    END.

    /* Delete the temp-tables for this item.  
       We do this BEFORE the build to ensure that merge sub-menus are not 
       added for non-existing bands, so we need to store the keys to use */
    IF AVAIL btThisBandInstance THEN
    DO:
      cMenuKey    = btThisBandInstance.MenuKey.
      DELETE btThisBandInstance.
    END.
    ELSE
      cMenuKey = '':U.


    cMenuName = btThisMenu.NAME.
    DELETE btThisMenu.

    IF cMenuKey <> '':U THEN 
    DO:
      IF VALID-HANDLE(hSubMenu) THEN
      DO:
        DYNAMIC-FUNCTION('buildMenuBand':U IN TARGET-PROCEDURE,
                          hSubMenu, cMenuKey).
        /* submenus are recreated on each build. We need to keep them until 
           their children have been moved in buildMenuband above, but since 
           they have no tMenu record they end up as empty submenus at top, so
           get rid if them  */ 
        hStale = hSubMenu:FIRST-CHILD.
        DO WHILE VALID-HANDLE(hStale):
          FIND FIRST btMenu WHERE btMenu.Hdl = hStale NO-ERROR.
          IF AVAIL btMenu AND btMenu.NAME <> 'RULE' THEN
            LEAVE.
          hStaleDel = hStale.
          hStale = hStale:NEXT-SIBLING.
          DELETE WIDGET hStaleDel.
        END.
      END.
    END.
    hRule = hParent:FIRST-CHILD NO-ERROR. 
    DO WHILE VALID-HANDLE(hRule) AND hRule:TYPE = 'menu-item':U AND hRule:SUBTYPE = 'rule':
      hRuleDel = hRule.
      hRule = hRule:NEXT-SIBLING.
      DELETE OBJECT hRuleDel NO-ERROR.
    END.
  END.
  
  RETURN TRUE. 
      
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-retrieveBandsAndActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION retrieveBandsAndActions Procedure 
FUNCTION retrieveBandsAndActions RETURNS LOGICAL
    ( input pcToolbarList as character,
      input pcObjectList  as character,
      input pcBandList    as character    ):
/*------------------------------------------------------------------------------
  Purpose: Retrieves menu data (actions, bands, etc) and makes them available
                   to this toolbar.
    Notes: * this function only retrieves data. it does not ensure uniqueness
                 of the data. there are normalize* functions that ensure that the data 
                 is unique.
------------------------------------------------------------------------------*/
  DEFINE BUFFER bttBand       FOR ttBand.
  DEFINE BUFFER bttBandAction FOR ttBandAction.
  DEFINE BUFFER bttObjectBand FOR ttObjectBand.

  define variable hContainer        as handle     no-undo.
  define variable cProperties       as character  no-undo.
  define variable cActions          as character  no-undo.
  define variable cBands            as character  no-undo.
  define variable cHiddenActions    as character  no-undo.
  define variable cDisabledActions  as character  no-undo.
  define variable cHiddenStructures as character  no-undo.
  define variable iLoop             as integer    no-undo.
  define variable dUserObj          as decimal    no-undo.
  define variable dOrganisationObj  as decimal    no-undo.
  define variable lSecurityEnabled  as logical    no-undo.
  define variable lHidden           as logical    no-undo.
  define variable lDisabled         as logical    no-undo.
  define variable lApplySecurity    as logical    no-undo.
  
  DEFINE VARIABLE lDelete           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iObject           AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cObject           AS CHARACTER  NO-UNDO.

  if pcToolbarList eq ? then pcToolbarList = ''.
  if pcObjectList eq ? then pcObjectList = ''.
  if pcBandList eq ? then pcBandList = ''.
  
  lApplySecurity = no.
  
  /* Check whether there's an adm-loadToolbar procedure in the toolbar.
     We can use internal-entries because the adm-loadToolbar procedure
     is generated into the object itself.
     
     Only attempt to retrive the toolbar information if it has been
     requested (i.e. the toolbarlist parameter is non-empty).
   */
  if pcToolbarList ne '' and 
     can-do(target-procedure:internal-entries, 'adm-loadToolbar') then
  do:
      /* The adm-loadToolbar procedures implcitly contain
         information for one specific object or toolbar.
         
         If bands are requested separately, outside of the context of an
         object (either toolbar or container object), they need to be 
         retrieved by calling the standard api rygetmensp.p.
       */
      assign pcToolbarList = ''
             lApplySecurity = yes.
      
      /* Get the toolbar information */
      run adm-loadToolbar in target-procedure (output table ttToolbarBand append,
                                               output table ttObjectBand append,
                                               output table ttBand append,
                                               output table ttBandAction append,
                                               output table ttAction append,
                                               output table ttCategory append ) no-error.
  end.    /* this is a generated toolbar. */    
  
  /* Get the object menu information.
  
     Check whether there's an adm-loadToolbar procedure in the container.
     We can use internal-entries because the adm-loadToolbar procedure
     is generated into the object itself.
     
     These checks are separate because the container may be generated 
     but the toolbar not. We need to get the correct items.
     
     Only attempt to retrive the object menu information if it has been
     requested (i.e. the objectlist parameter is non-empty).
   */
  {get ContainerSource hContainer} no-error.
  if valid-handle(hContainer) and
     pcObjectList ne '' and 
     can-do(hContainer:internal-entries, 'adm-loadToolbar') then
  do:
      assign pcObjectList = ''
             lApplySecurity = yes.
      
      run adm-loadToolbar in hContainer (output table ttToolbarBand append,
                                         output table ttObjectBand append,
                                         output table ttBand append,
                                         output table ttBandAction append,
                                         output table ttAction append,
                                         output table ttCategory append ) no-error.
  end.    /* the container has generated menu items. */
  
  /* Apply security (for objects loaded with adm-loadToolbar above).     
     If the toolbar information is retrieved from the repository,
     security is applied as part of the retrieval process on the server
     and we don't need to do it again.
     When toolbar information is retrieved from the object via adm-loadToolbar
     no security has yet been applied and so we must ensure that all
     toolbar information is secured before use.  */
  if lApplySecurity then
  do:
      if valid-handle(gshSessionManager) and valid-handle(gshSecurityManager) then
      do:
          assign cProperties = dynamic-function('getPropertyList':U in gshSessionManager,
                                                        'SecurityEnabled':U, No)
                lSecurityEnabled = logical(entry(1, cProperties, CHR(3)))
          no-error.
          
          if lSecurityEnabled eq ? then
              lSecurityEnabled = yes.
          
          if lSecurityEnabled then
          do:
              /* Only run security against the actions just received. These
                 actions will have a ProcedureHandle of ? (this is set in
                 normalizeActionData).
               */
              for each ttAction where ttAction.ProcedureHandle = ?:
                  cActions = cActions + ',' + ttAction.Action.
              end.    /* build action list */
               
              for each ttBand where ttBand.ProcedureHandle = ?:
                  cBands = cBands + ',' + ttBand.Band.
              end.    /* build band list */
              
              assign cActions = left-trim(cActions, ',')
                     cBands = left-trim(cBands, ',').
              
              run menuItemStructureSecurityCheck in gshSecurityManager (input  cActions,
                                                                        input  cBands,
                                                                        output cHiddenActions,
                                                                        output cDisabledActions,
                                                                        output cHiddenStructures ) no-error.
              
              /* Secure hidden actions */
              do iLoop = 1 to num-entries(cHiddenActions):
                  find ttAction where
                       ttAction.Action = entry(iLoop, cHiddenActions)
                       no-error.
                  if available ttAction then
                  do:
                      for each ttBandAction where
                               ttBandAction.Action = ttAction.Action:
                          delete ttBandAction.
                      end.    /* remove the band actions */
                      
                      delete ttAction.                        
                  end.    /* action hidden */
              end.    /* loop through hidden actions */
              
              /* Secure disabled actions */
              do iLoop = 1 to num-entries(cDisabledActions):
                  find ttAction where
                       ttAction.Action = entry(iLoop, cDisabledActions)
                       no-error.
                  if available ttAction then
                      ttAction.Disabled = yes.
              end.    /* loop through disabled actions */
              
              /* Secure hidden bands */
              do iLoop = 1 to num-entries(cHiddenStructures):
                  find ttBand where
                       ttBand.Band = entry(iLoop, cHiddenStructures)
                       no-error.
                  if available ttBand then
                  do:
                      for each ttBandAction where
                               ttBandAction.Band = ttBand.Band:                            
                          /* Keep any actions that appear on on the band actions, 
                             since they may be used by other bands. The action security
                             above will make sure that actions are cleaned up OK if
                             the actions are secured.
                           */
                          delete ttBandAction.
                      end.    /* each band action */
                      
                      for each ttObjectBand where
                               ttObjectBand.Band = ttBand.Band:
                          delete ttObjectBand.
                      end.    /* object band */
                      
                      for each ttToolbarBand where
                               ttToolbarBand.Band = ttband.Band:
                          delete ttToolbarBand.
                      end.    /* toolbar band */
                      
                      /* now delete the band */
                      delete ttBand.                    
                  end.    /* band to secure */                             
              end.    /* loop through hidden bands */
          end.    /* security enabled*/               
      end.    /* valid security and session managers */
  end.    /* apply security */
  
  if pcObjectList ne '' or pcToolbarList ne '' or pcBandList ne '' then
  do:
    ASSIGN cProperties      = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                               "currentUserObj,currentOrganisationObj":U,
                                               Yes)
           dUserObj         = DECIMAL(ENTRY(1, cProperties, CHR(3)))
           dOrganisationObj = DECIMAL(ENTRY(2, cProperties, CHR(3)))
           NO-ERROR.

    RUN ry/app/rygetmensp.p ON gshAstraAppserver 
                                     (INPUT  pcToolbarList,
                                      INPUT  pcObjectList,
                                      INPUT  pcBandList,
                                      INPUT  dUserObj,
                                      INPUT  dOrganisationObj,
                                      OUTPUT TABLE ttToolbarBand APPEND,
                                      OUTPUT TABLE ttObjectBand APPEND,
                                      OUTPUT TABLE ttBand APPEND,
                                      OUTPUT TABLE ttBandAction APPEND,
                                      OUTPUT TABLE ttAction APPEND,
                                      OUTPUT TABLE ttCategory APPEND).
  end.  /* get toolbars, objects or bands */                                   

  /* Remove any duplicated actions and action categories */
  {fn normalizeActionData}.

  /* Remove duplicates from the band and bandAction tables */
  FOR EACH ttBand WHERE ttBand.ProcedureHandle = ?:
    lDelete = CAN-FIND(FIRST bttBand WHERE bttBand.Band = ttBand.Band
                                         AND bttBand.ProcedureHandle <> ?).
    FOR EACH ttBandAction WHERE ttBandAction.ProcedureHandle = ? 
                              AND ttBandAction.Band            = ttBand.Band:

      IF lDelete THEN
        DELETE ttBandAction.
      ELSE DO:
          /* Check whether there exists an action containing the same band name, sequence and procedureHandle 
             This could occur if the same band is used twice in the same position (sequence) */
          IF CAN-FIND (FIRST bttBandAction 
                       WHERE bttBandAction.Band = ttBandAction.Band
                         AND bttbandAction.Sequence = ttBandAction.Sequence
                         AND bttBandAction.ProcedureHandle = THIS-PROCEDURE) THEN
            DELETE ttBandAction.
          ELSE
            ttBandAction.ProcedureHandle = THIS-PROCEDURE.
      END.
    END. /* for each ttBand */
    IF lDelete THEN 
      DELETE ttBand.
    ELSE   
      ttBand.ProcedureHandle = THIS-PROCEDURE.
  END.
    
  /* Remove duplicate objectband/runattribute: 
     If runattributes is used then we check retrieved objectbands for 
     invalid runattributes, which are returned with unknown value in 
     order not to clash with blank. Invalid runattribute is treated as 
     no runattribute, so we delete it if it already exists and set the 
     runattribute to blank if this is the first retrieval. */  
  IF INDEX(';',pcObjectList) > 0 THEN
  DO:
    DO iObject = 1 TO NUM-ENTRIES(pcObjectList):
      cObject  = ENTRY(iObject,pcObjectList).
      IF NUM-ENTRIES(cObject,';') > 1 THEN
      DO:
        FOR EACH ttObjectBand WHERE ttObjectBand.ObjectName   = cObject 
                              AND   ttObjectBand.RunAttribute = ?:
          IF CAN-FIND (bttObjectBand 
                       WHERE bttObjectBand.ObjectName   = cObject 
                       AND   bttObjectBand.RunAttribute = ''
                       AND   bttObjectBand.Resultcode   = ttObjectBand.Resultcode
                       AND   bttObjectband.Sequence     = ttObjectBand.Sequence) THEN
            DELETE ttObjectBand.
          ELSE 
            ttObjectBand.RunAttribute = ''.
        END. /* for each where ObjectName = cObject and runattribute = ? */
      END. /* if runattribute defined */
    END. /* loop through pcObjectList */
  END. /* INDEX(';',pcObjectList) > 0 (runattribute used) */
  
  return true.

END FUNCTION.    /* retrieveBandsAndActions */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-sensitizeActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION sensitizeActions Procedure 
FUNCTION sensitizeActions RETURNS LOGICAL
  (pcActions AS CHAR,
   plSensitive AS LOG) :
/*------------------------------------------------------------------------------
  Purpose: Set actions sensitive attibute 
           (The main ourpose ia to have the same logic for disableActions and
            enableActions) 
Parameters: INPUT pcActions - A comma separated list of actions to disable
                              "*" - means disable all 
            INPUT plSensitive - Logical value that specifies sensitive.                                                       
    Notes:
           Actions may be created in other procedures, but this is the only place
           that they are enabled. except that submenues are currently set to true
           when created. 
           This procedure will probably need to be public in order to call the 
           canDo function.  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cAction        AS CHAR    NO-UNDO.
  DEFINE VARIABLE i              AS INTEGER NO-UNDO.
  DEFINE VARIABLE cDisabled      AS CHAR   NO-UNDO.
  DEFINE VARIABLE lUseRepository AS LOGICAL    NO-UNDO.

  IF plSensitive THEN 
    {get DisabledActions cDisabled}.

  {get UseRepository lUseRepository}.

  IF pcActions = "*":U THEN 
  DO:
    FOR EACH tMenu WHERE tMenu.hTarget = TARGET-PROCEDURE
                   AND   tMenu.Disabled = FALSE
                   AND   NOT CAN-DO(cDisabled,tMenu.Name):
      IF plSensitive 
      AND {fnarg ActionType tMenu.Name} = 'RUN':U 
      AND {fnarg actionCanRun tMenu.Name} = FALSE THEN 
         NEXT.

      IF VALID-HANDLE(tMenu.Hdl) THEN 
         tMenu.Hdl:SENSITIVE = plSensitive.         
      tMenu.Sensitive = plSensitive.    
    END.
    FOR EACH tButton WHERE tButton.hTarget = TARGET-PROCEDURE
                     AND  tbutton.Disabled = FALSE
                     AND  NOT CAN-DO(cDisabled,tButton.Name):
      IF plSensitive 
      AND {fnarg ActionType tButton.Name} = 'RUN':U 
      AND {fnarg actionCanRun tButton.Name} = FALSE THEN 
         NEXT.

      IF VALID-HANDLE(tButton.Hdl) THEN 
          tButton.Hdl:SENSITIVE = plSensitive.         
    END.
  END.
  ELSE DO i = 1 TO NUM-ENTRIES(pcActions):
    cAction = ENTRY(i,pcActions).  
    
    IF plSensitive THEN 
    DO:
      IF CAN-DO(cDisabled,cAction) THEN 
        NEXT. /* -----> */
    
      IF  {fnarg actionType cAction} = 'RUN':U 
      AND {fnarg actionCanRun cAction} = FALSE THEN 
        NEXT.  /* -----> */
    END.

    IF NOT lUseRepository THEN
    DO:
      FIND tMenu WHERE tMenu.Name    = cAction
                 AND   tMenu.hTarget = TARGET-PROCEDURE NO-ERROR.
      IF NOT AVAIL tMenu THEN 
         /* '*' means that the parent may be changed by this function later */ 
         DYNAMIC-FUNCTION('insertMenuTempTable':U IN TARGET-PROCEDURE,
                           "*":U,cAction,?).
    
      IF AVAIL tMenu AND tMenu.Disabled = FALSE THEN
      DO:
        IF VALID-HANDLE(tMenu.Hdl)THEN
           tMenu.Hdl:SENSITIVE = plSensitive.
        tMenu.Sensitive = plSensitive.            
      END.
    END.
    ELSE DO:
      /* We only prevent multiple items of same action under the same parent when Repository, 
         so use FOR EACH just in case there are duplicates under different parents  */
      FOR EACH tMenu WHERE tMenu.Name     = cAction
                     AND   tMenu.hTarget  = TARGET-PROCEDURE
                     AND   tMenu.Disabled = FALSE:
        IF VALID-HANDLE(tMenu.Hdl) THEN 
           tMenu.Hdl:SENSITIVE = plSensitive.         
        tMenu.Sensitive = plSensitive.    
      END. 
    END. /* else (i.e. UseRepository) */

    FIND tButton WHERE tButton.Name    = cAction
                 AND   tButton.hTarget = TARGET-PROCEDURE NO-ERROR.
        
    IF NOT AVAIL tButton AND NOT lUseRepository THEN 
    DO: 
      CREATE tButton.
      ASSIGN
        tButton.Name    = cAction
        tButton.hTarget = TARGET-PROCEDURE.
    END. /* if not avail */
    IF AVAIL tButton AND tButton.Disabled = FALSE THEN
    DO:
      tButton.Sensitive = plSensitive.    
      IF VALID-HANDLE(tButton.Hdl) THEN
         tButton.Hdl:SENSITIVE = plSensitive.          
    END.
  END. /* do i = 1 to num-entries(cAction) */
  
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setActionGroups) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setActionGroups Procedure 
FUNCTION setActionGroups RETURNS LOGICAL
  (pcActionGroups AS CHARACTER) :
/*------------------------------------------------------------------------------
 Purpose: Sets the action groups selected in the Instance Properties.    
Parameters: INPUT pcActionGroups - Comma separated list of actionGroups    
    Notes: Repository toolbar uses categories while non-repository objects
           uses parent actions      
----------------------------------------------------------------------------*/
  {set ActionGroups pcActionGroups}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAvailMenuActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAvailMenuActions Procedure 
FUNCTION setAvailMenuActions RETURNS LOGICAL
  (pcAvailMenuActions AS CHARACTER) :
/*------------------------------------------------------------------------------
 Purpose: Sets the actions that are available in the menu of the toolbar object   
Parameters: INPUT pcAvailMenuActions - Comma separated list of actionGroups    
    Notes:  Updated internally from insertMenu 
           The Instance Property dialog shows these and AvailToolbarActions. 
           The actions that are selected will be saved as ActionGroups. 
------------------------------------------------------------------------------*/
  {set AvailMenuActions pcAvailMenuActions}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAvailToolbarActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAvailToolbarActions Procedure 
FUNCTION setAvailToolbarActions RETURNS LOGICAL
  (pcAvailToolbarActions AS CHARACTER) :
/*------------------------------------------------------------------------------
 Purpose: Sets the actions that are available in the toolbar.   
Parameters: INPUT pcAvailToolbarActions - Comma separated list of actionGroups    
    Notes:  Updated internally from createToolbar 
           The Instance Property dialog shows these and AvailMenuActions. 
           The actions that are selected will be saved as ActionGroups. 
------------------------------------------------------------------------------*/
  {set AvailToolbarActions pcAvailToolbarActions}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBoxRectangle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBoxRectangle Procedure 
FUNCTION setBoxRectangle RETURNS LOGICAL
  ( phRectangle AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose:  Store the handle to the rectangle, if any "box" is used around the
            buttons in the toolbar, or the top rectangle if toolbarAutoSize. 
   Params:  hRectangle - handle
------------------------------------------------------------------------------*/
  {set BoxRectangle phRectangle}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBoxRectangle2) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBoxRectangle2 Procedure 
FUNCTION setBoxRectangle2 RETURNS LOGICAL
  ( hValue AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  bottom rectangle if toolbarautosize
    Notes:  
------------------------------------------------------------------------------*/

  {set BoxRectangle2 hValue}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBuffer Procedure 
FUNCTION setBuffer RETURNS LOGICAL PRIVATE
  (pcObject  AS CHAR,
   pcAction      AS CHAR,
   pcColumns AS CHAR,
   pcValues  AS CHAR,
   phTarget  AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose: Creates or assigns properties for an action. 
    Notes: PRIVATE -  
------------------------------------------------------------------------------*/
  DEFINE BUFFER bttAction FOR ttACTION.

  DEFINE VARIABLE hBuffer        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cColumn        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hColumn        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iOrder         AS INTEGER   NO-UNDO.
  DEFINE VARIABLE i              AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cLink          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cControlType   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lUseRepository AS LOGICAL    NO-UNDO.

  /* Tell findAction to use phTarget (this is undefined in findaction) */
  &SCOPED-DEFINE TargetProc phTarget
  {&findaction}
  IF NOT AVAIL ttAction THEN
  DO:
    /* If we are creating a class make sure there's no instance defined */
    IF  NOT CAN-DO(pcColumns,"Instance":U)
    AND CAN-FIND(FIRST bttAction WHERE bttAction.Action = pcAction) THEN 
    DO:
      errorMessage (SUBSTITUTE({fnarg messageNumber 38}, pcAction)).
      RETURN FALSE.
    END.
    
    CREATE ttAction.
    
    ASSIGN
      ttAction.Action = pcAction.  
    /* Set target to class in order to check for duplicates when reading
       data from repository */
    IF NOT CAN-DO(pcColumns,"Instance":U) THEN
      ASSIGN
        ttAction.ProcedureHandle = THIS-PROCEDURE.
  END. /* not findAction */

  /* If the action exists and this is the definition of an instance 
     action, check that the one we have found is not a class action.  */ 
  ELSE IF CAN-DO(pcColumns,"Instance":U) THEN 
  DO:
    IF ttAction.ProcedureHandle <> phTarget THEN 
    DO:
      errorMessage (SUBSTITUTE({fnarg messageNumber 39}, pcAction)).
      RETURN FALSE.
    END.
  END. /* else (avail action) can-do(pccolumns,'instance') */ 
  
  hBuffer = BUFFER ttAction:HANDLE.
  DO i = 1 TO NUM-ENTRIES(pcColumns):        
    cColumn = ENTRY(i,pcColumns).
    /* If instance assign toolbarhandle = target, we don't care about the 
       value.  */
    IF cColumn = 'Instance':U THEN
      ASSIGN
        hColumn = hBuffer:BUFFER-FIELD('ProcedureHandle':U)
        hColumn:BUFFER-VALUE = phTarget.
    ELSE
      ASSIGN
        hColumn = hBuffer:BUFFER-FIELD(cColumn)
        hColumn:BUFFER-VALUE = IF NUM-ENTRIES(pcValues,CHR(1)) >= i
                               THEN ENTRY(i,pcValues,CHR(1))
                               ELSE ?.   

    IF cColumn = "Order":U THEN
      iOrder = hColumn:BUFFER-VALUE. 
    IF cColumn = "Link":U THEN
      cLink = hColumn:BUFFER-VALUE. 
     /* Here we should probably loop through the siblings and increase 
        their order. () */ 

  END. /* do i = 1 to num-entries(pccolumns) */ 
  
  /* If order has not been assigned assign default order */
  IF iOrder = 0 THEN 
  DO:      
    FIND LAST bttAction WHERE bttAction.Parent = ttAction.Parent NO-ERROR.
    ASSIGN 
      iOrder = IF AVAIL bttAction 
               THEN bttAction.Order + 1 
               ELSE 1      
      hColumn = hBuffer:BUFFER-FIELD("ORDER":U)
      hColumn:BUFFER-VALUE = iOrder.           
  END. 
  /* If cLink has not been assigned assign the default link from the parent  */
  IF cLink = '':U THEN 
  DO:      
    FIND bttAction WHERE bttAction.Action = ttAction.Parent NO-ERROR.
    IF AVAIL bttAction THEN
      ASSIGN 
        hColumn = hBuffer:BUFFER-FIELD("Link":U)
        hColumn:BUFFER-VALUE = bttAction.Link.           
  END. 


  /* Set ControlType for non-repository objects, this used to be resolved 
     in the retrieval, but was moved at creation for performance reasons     
   Non repository calls defineAction without target from initAction,
   so we use the direct check if super is target as getUseRepository will
   not be found */
  IF phTarget = THIS-PROCEDURE THEN 
    lUseRepository = DYNAMIC-FUNCTION('isICFRunning':U IN THIS-PROCEDURE) NO-ERROR.
  ELSE /* minimize risk of the above and use the normal call in other cases */ 
    lUseRepository = DYNAMIC-FUNCTION("getUseRepository":U IN phTarget).

  /* Ensure that Unknown is handled as FALSE (if isICFRunning will be unknown
     if the function is not there)  */
  IF NOT (lUseRepository = TRUE) THEN
  DO:
    hColumn = hBuffer:BUFFER-FIELD("OnChoose":U).
    cControlType = IF hColumn:BUFFER-VALUE <> '':U THEN 'Action':U ELSE 'Label':U.
    hColumn = hBuffer:BUFFER-FIELD("ControlType":U).
    hColumn:BUFFER-VALUE = cControlType.
  END.  

  RETURN hBuffer:AVAILABLE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCommitTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCommitTarget Procedure 
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

&ENDIF

&IF DEFINED(EXCLUDE-setCommitTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCommitTargetEvents Procedure 
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

&ENDIF

&IF DEFINED(EXCLUDE-setContainerToolbarTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setContainerToolbarTarget Procedure 
FUNCTION setContainerToolbarTarget RETURNS LOGICAL
    ( pcTarget AS CHARACTER  ):
/*------------------------------------------------------------------------------
  Purpose:  Sets the handle of the object's containertoolbar-target. This 
            may be a delimited list of handles.
   Params:   
    Notes:   
------------------------------------------------------------------------------*/
  {set ContainerToolbarTarget pcTarget}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setContainerToolbarTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setContainerToolbarTargetEvents Procedure 
FUNCTION setContainerToolbarTargetEvents RETURNS LOGICAL
  ( pcEvents AS CHARACTER  ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the list of events to be subscribed to in the
            ContainerToolbar-target.  
   Params:  <none>
    Notes:             
------------------------------------------------------------------------------*/
  {set ContainerToolbarTargetEvents pcEvents}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCreateSubMenuOnConflict) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCreateSubMenuOnConflict Procedure 
FUNCTION setCreateSubMenuOnConflict RETURNS LOGICAL
  ( plCreateSubMenu AS LOG ) :
/*------------------------------------------------------------------------------
 Purpose: Decides whether to create submenu for conflicting bands 
 Parameters: INPUT plCreateSubMenu 
             Yes - Create a submenu when a band already has linked actions for another toolbar. 
             No - Insert conflicting bands in same submenu
     Notes:
------------------------------------------------------------------------------*/
  {set CreateSubMenuOnConflict plCreateSubMenu}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDeactivateTargetOnHide) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDeactivateTargetOnHide Procedure 
FUNCTION setDeactivateTargetOnHide RETURNS LOGICAL
  ( plDeactivateTargetOnHide AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose: Set to true if a target should be deactivated immediately on hide  
           False indicates that the hidden targets are deactivated on view of 
           another target. 
    Notes: True should be used to disable a toolbar when the object is hidden 
           also when the object has only one target or to disable the toolbar 
           when the current page is a page that does not have any target. 
           False (default) ensures that the targets always are active if 
           only one link even if they are hidden and avoids the disabling 
           in a paged container when switching pages.  
------------------------------------------------------------------------------*/
  {set DeactivateTargetOnHide plDeactivateTargetOnHide}.
  RETURN plDeactivateTargetOnHide.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDisabledActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDisabledActions Procedure 
FUNCTION setDisabledActions RETURNS LOGICAL
  ( pcActions AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Stores a comma separated list of disabled actions.
   Params:  pcActions AS CHARACTER -- Comma separated list of actions
    Notes: - The actions will be immediately disabled and subsequent calls 
             to enableActions will not enable them again. This makes it 
             possible to permanently disable actions independent of state 
             changes.
           - Use the modifyDisabledActions to add or remove actions. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cEnabledActions    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisabledActions   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lInitialized       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iLoop              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cOldActions        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAction            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hTarget            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cEnableRule        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lEnable            AS LOGICAL    NO-UNDO.
  
  {get ObjectInitialized lInitialized}.
  
  cDisabledActions = pcActions.
  /* If initialized then check if states should be enabled */ 
  IF lInitialized THEN
  DO:
    {get DisabledActions cOldActions}.
    DO iLoop = 1 TO NUM-ENTRIES(cOldActions):
      cAction = ENTRY(iLoop,cOldActions).
      /* Removed from list, potential candidate for enabling */   
      IF NOT CAN-DO(pcActions,cAction) THEN
         cEnabledActions = cEnabledActions
                         + (IF cEnabledActions = "":U THEN "":U ELSE ",":U)
                         + cAction.
      ELSE /* Already in list noneed to disable */
        cDisabledActions = TRIM(REPLACE(",":U + cDisabledActions + ",":U,
                                        ",":U + cAction + ",":U,","),
                                        ",":U). 
    END.
    
    /* loop through enable candidates and check if the Enablerule allows 
       immediate enabling */
    DO iLoop = 1 TO NUM-ENTRIES(cEnabledActions):
      cAction = ENTRY(iLoop,cEnabledActions).
      hTarget = {fnarg actionTarget cAction}.
      IF VALID-HANDLE(hTarget) THEN
      DO:
        ASSIGN
          cEnableRule = {fnarg actionEnableRule cAction}
          lEnable     = TRUE.

        IF cEnableRule > "":U THEN
          lEnable = DYNAMIC-FUNCTION('checkRule':U IN TARGET-PROCEDURE,
                                      cEnableRule,
                                      hTarget,
                                      lEnable).
        IF lEnable THEN
          {fnarg EnableActions cAction}.
      END.
    END.    
  END.
  
  /* This could possibly also be done only if initializated, but we do it
     always to ensure that old behavior is not broken 
     (this could  possibly be used for unsupported/unlinked actions ) */
  {fnarg disableActions cDisabledActions}.

  &SCOPED-DEFINE xpDisabledActions
  {set DisabledActions pcActions}.
  &UNDEFINE xpDisabledActions

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setEdgePixels) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setEdgePixels Procedure 
FUNCTION setEdgePixels RETURNS LOGICAL
  (piPixels AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the number of edge-pixels in the enclosing rectangle 
  Params:  piPixels AS INTEGER
           (xp because panel has override) 
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE xpEdgePixels
  {set EdgePixels piPixels}.
  &UNDEFINE xpEdgePixels

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFlatButtons) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFlatButtons Procedure 
FUNCTION setFlatButtons RETURNS LOGICAL
  ( plFlatButtons AS LOGICAL  ) :
/*------------------------------------------------------------------------------
  Purpose:  
   Params: NOT IN USE 
------------------------------------------------------------------------------*/
  {set FlatButtons plFlatButtons}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setHiddenActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setHiddenActions Procedure 
FUNCTION setHiddenActions RETURNS LOGICAL
  ( pcActions AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE xpHiddenActions
  {set HiddenActions pcActions}.
  &UNDEFINE xpHiddenActions
  RETURN TRUE. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setHiddenMenuBands) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setHiddenMenuBands Procedure 
FUNCTION setHiddenMenuBands RETURNS LOGICAL
  (pcHiddenBands AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: This must be set before initialization 
    Notes:  
------------------------------------------------------------------------------*/
  {set HiddenMenuBands pcHiddenBands}. 
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setHiddenToolbarBands) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setHiddenToolbarBands Procedure 
FUNCTION setHiddenToolbarBands RETURNS LOGICAL
  (pcHiddenBands AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: This must be set before initialization 
    Notes:  
------------------------------------------------------------------------------*/
  {set HiddenToolbarBands pcHiddenBands}. 
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setImagePath) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setImagePath Procedure 
FUNCTION setImagePath RETURNS LOGICAL
  ( pcImagePath AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Set the opsys path of the images   
    Notes:  
------------------------------------------------------------------------------*/
  {set ImagePath pcImagePath}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLinkTargetNames) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLinkTargetNames Procedure 
FUNCTION setLinkTargetNames RETURNS LOGICAL
  ( pcLinkList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Modifies the list of the supported toolbar links. This is based on 
            either the tool's specified item-Link, or the Category the tools
            belong to.
   Params:  pcLinkList AS CHARACTER -- comma-separated list of links.
  Returns:  LOGICAL (true)
    Notes:  Because this is a comma-separated list, it should normally be
            invoked indirectly, through modifyListProperty.
------------------------------------------------------------------------------*/

   {set LinkTargetNames pcLinkList}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setMenu Procedure 
FUNCTION setMenu RETURNS LOGICAL
  ( plMenu AS LOGICAL  ) :
/*------------------------------------------------------------------------------
   Purpose:  set to TRUE if a menu is to be generated
Parameters: INPUT plMenu - log     
     Notes:
------------------------------------------------------------------------------*/
  {set Menu plMenu}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setMenuMergeOrder) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setMenuMergeOrder Procedure 
FUNCTION setMenuMergeOrder RETURNS LOGICAL
  ( piOrder AS INT ) :
/*------------------------------------------------------------------------------
 Purpose: Decides the order of which the menus will be merged with other 
          toolbar instances. 
 Parameters: INPUT piOrder 
     Notes:
------------------------------------------------------------------------------*/
  {set MenuMergeOrder piOrder}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setNavigationButtons) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setNavigationButtons Procedure 
FUNCTION setNavigationButtons RETURNS LOGICAL
  ( pcState AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: DEPRECATED -- Did convert a navigation QueryPosition to setButton 
           parameter..    
  pcState: State from QueryPosition 
    Notes: Will still set PanelState, which is also DEPRECATED .
------------------------------------------------------------------------------*/    /* Navigation states */
  DEF VAR cPanelState AS CHAR NO-UNDO.
 
  CASE pcState:
      WHEN 'FirstRecord':U THEN
        cPanelState = 'first':U.
      WHEN 'LastRecord':U THEN
        cPanelState = 'last':U.
      WHEN 'NotFirstOrLast':U THEN
        cPanelState = 'enable-nav':U.
      WHEN 'OnlyRecord':U OR 
      WHEN 'NoRecordAvailable':U OR
      WHEN 'NoRecordAvailableExt':U THEN
         cPanelState = 'disable-nav':U.
  
  END CASE.

  IF cPanelState NE "":U THEN 
    {set PanelState cPanelState}. /* runs setButtons */ 
  
  RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setNavigationTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setNavigationTarget Procedure 
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

&ENDIF

&IF DEFINED(EXCLUDE-setNavigationTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setNavigationTargetEvents Procedure 
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

&ENDIF

&IF DEFINED(EXCLUDE-setNavigationTargetName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setNavigationTargetName Procedure 
FUNCTION setNavigationTargetName RETURNS LOGICAL
  ( pcTargetName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the ObjectName of the Data Object to be navigated by this
            panel. This would be set if the Navigation-Target is an SBO
            or other Container with DataObjects.
   Params:  pcTargetName AS CHARACTER
------------------------------------------------------------------------------*/

  {set NavigationTargetName pcTargetName}.
  RETURN TRUE.

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
    Notes:  Also runs the panel procedure setButtons, which changes which 
            buttons are enabled and disabled based on the state.
         -  DEPRECATED in the sense that the toolbar disabling/enabling 
            has been replaced by rule based state management. The function 
            is still callable and may still be called in odd cases.              
------------------------------------------------------------------------------*/
  RUN setButtons IN TARGET-PROCEDURE (pcPanelState).
  IF RETURN-VALUE NE "ADM-ERROR":U THEN
  DO:
    &SCOPED-DEFINE xpPanelState
    {set PanelState pcPanelState}.
    &UNDEFINE xpPanelState
    RETURN TRUE.
  END.
  ELSE 
    RETURN FALSE.   /* new state was invalid somehow. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPanelType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setPanelType Procedure 
FUNCTION setPanelType RETURNS LOGICAL
  ( pcPanelType AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the type of Panel: Navigation, Save, Update 
   Params:  pcPanelType AS CHARACTER
    Notes:  Is defined in toolbar class for backwards compatibility since it 
            was defined as an instance property. 
         -  The value for the toolbar is 'toolbar'.
------------------------------------------------------------------------------*/
  {set PanelType pcPanelType}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRemoveMenuOnHide) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setRemoveMenuOnHide Procedure 
FUNCTION setRemoveMenuOnHide RETURNS LOGICAL
  ( plRemoveMenu AS LOG ) :
/*------------------------------------------------------------------------------
 Purpose: Decides whether the the menus should be removed from the menubar 
          on hide of the toolbar. 
 Parameters: INPUT plRemove 
     Notes:
------------------------------------------------------------------------------*/
  {set RemoveMenuOnhide plRemoveMenu}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setShowBorder) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setShowBorder Procedure 
FUNCTION setShowBorder RETURNS LOGICAL
  ( plShowBorder AS LOGICAL  ) :
/*------------------------------------------------------------------------------
 Purpose: set to True if a three-d border is to be used around the buttons 
          and as a delimiter when "RULE" is specified in createToolbar
 Parameters: INPUT plShowBorder - logical  
     Notes:
------------------------------------------------------------------------------*/
  {set ShowBorder plShowBorder}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSubModules) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSubModules Procedure 
FUNCTION setSubModules RETURNS LOGICAL
  ( pcSubModules AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the SubModules.
   Params:   
    Notes:  NOT IN USE ()  
------------------------------------------------------------------------------*/

  {set SubModules pcSubModules}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTableIOButtons) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTableIOButtons Procedure 
FUNCTION setTableIOButtons RETURNS LOGICAL
  ( pcState AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Convert a tableio recordState to setButton parameter   
  pcState: State received from QueryPosition or tableioTarget's RecordState
    Notes: Not actively used anymore  
------------------------------------------------------------------------------*/  
  DEFINE VARIABLE cPanelState AS CHARACTER  NO-UNDO.

  CASE pcState:        
     WHEN 'FirstRecord':U OR /* All these amount to RecordAvailable update*/
     WHEN 'LastRecord':U OR
     WHEN 'NotFirstOrLast':U OR
     WHEN 'OnlyRecord':U OR
     WHEN 'RecordAvailable':U THEN
           cPanelState = 'initial-tableio':U.
     WHEN 'NoRecordAvailable':U THEN
          cPanelState = 'add-only':U.
     WHEN 'NoRecordAvailableExt':U THEN
          cPanelState = 'disable-tableio':U.
  END CASE.  /* pcState */
  
  /* If we found a case for the state, reset it. */
  IF cPanelState NE "":U THEN 
    RUN setButtons IN TARGET-PROCEDURE(cPanelState). 
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTableIOTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTableIOTarget Procedure 
FUNCTION setTableIOTarget RETURNS LOGICAL
  ( pcObject AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the TableIOTarget link value.
   Params:  pcObject AS CHARACTER -- handle or handles of object(s) which
              should be made TableIOTargets of the current object.1
    Notes:  Because this value can be a list, it should be changed using
              modifyListProperty
------------------------------------------------------------------------------*/

  {set TableIOTarget pcObject}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTableIOTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTableIOTargetEvents Procedure 
FUNCTION setTableIOTargetEvents RETURNS LOGICAL
  ( pcEvents AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the list of events to subscribe to in the TableIOTarget.
   Params:  pcEvents AS CHARACTER -- CHARACTER string form of the event names.
    Notes:  Because the value can be a list, it should be changed using
              modifyListProperty
------------------------------------------------------------------------------*/

  {set TableIOTargetEvents pcEvents}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setTableioType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTableioType Procedure 
FUNCTION setTableioType RETURNS LOGICAL
  ( pcType AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the TableIOType link value.
   Params:  pcObject AS CHARACTER --  "Save" or "Update" 
    Notes: This is the same as PanelType in the update panel
------------------------------------------------------------------------------*/
  {set TableIOType pcType}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolbar) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setToolbar Procedure 
FUNCTION setToolbar RETURNS LOGICAL
  ( plToolbar AS LOGICAL  ) :
/*------------------------------------------------------------------------------
   Purpose: set to TRUE if the toolbar is to be created  
Parameters: INPUT plToolbar - logical  
     Notes:
------------------------------------------------------------------------------*/
  {set Toolbar plToolbar}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolbarAutosize) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setToolbarAutosize Procedure 
FUNCTION setToolbarAutosize RETURNS LOGICAL
  ( plToolbarAutoSize AS LOGICAL  ) :
/*------------------------------------------------------------------------------
 Purpose: Set to True if the toolbar should be automatically sized to the full
          width of the window at run-time.
 Parameters: INPUT plToolbarAutoSize - logical  
     Notes:
------------------------------------------------------------------------------*/
  {set ToolbarAutoSize plToolbarAutoSize}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolbarBands) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setToolbarBands Procedure 
FUNCTION setToolbarBands RETURNS LOGICAL
  (pcToolbarBands AS CHARACTER) :
/*------------------------------------------------------------------------------
 Purpose: Sets the toolbar bands selected in the Instance Properties.    
Parameters: INPUT pcToolbarBands - Comma separated list of Toolbar Bands    
   Notes: NOT USED    
----------------------------------------------------------------------------*/
  {set ToolbarBands pcToolbarBands}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolbarDrawDirection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setToolbarDrawDirection Procedure 
FUNCTION setToolbarDrawDirection RETURNS LOGICAL
  (pcToolbarDrawDirection AS CHARACTER) :
/*------------------------------------------------------------------------------
 Purpose: Sets the toolbar draw direction.    
Parameters: INPUT pcToolbarDrawDirection - horizontal or vertical    
   Notes:     
----------------------------------------------------------------------------*/
  {set ToolbarDrawDirection pcToolbarDrawDirection}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolbarMinWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setToolbarMinWidth Procedure 
FUNCTION setToolbarMinWidth RETURNS LOGICAL
  ( pdMinWidth AS DEC ) :
/*------------------------------------------------------------------------------
  Purpose: set min width 
    Notes: Use setMinWidth -- Kept for backwards compatibility  
------------------------------------------------------------------------------*/
  RETURN {fnarg setMinWidth pdMinWidth}.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolbarParentMenu) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setToolbarParentMenu Procedure 
FUNCTION setToolbarParentMenu RETURNS LOGICAL
  (pcToolbarParentMenu AS CHARACTER) :
/*------------------------------------------------------------------------------
 Purpose: Sets the toolbar parent menu selected in the Instance Properties.    
Parameters: INPUT pcToolbarParentMenu     
   Notes: Only required if any toolbar menus need to be added under a specific
          submenu, which will also be created if it does not exist.    
----------------------------------------------------------------------------*/
  {set ToolbarParentMenu pcToolbarParentMenu}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolbarTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setToolbarTarget Procedure 
FUNCTION setToolbarTarget RETURNS LOGICAL
    ( pcTarget AS CHARACTER  ):
/*------------------------------------------------------------------------------
  Purpose:  Sets the handle of the object's toolbar-target. This may be a
            delimited list of handles.
   Params:   
    Notes:   
------------------------------------------------------------------------------*/
  {set ToolbarTarget pcTarget}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolbarTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setToolbarTargetEvents Procedure 
FUNCTION setToolbarTargetEvents RETURNS LOGICAL
  ( pcEvents AS CHARACTER  ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the list of events to be subscribed to in the
            Toolbar-target.  
   Params:  <none>
    Notes:             
------------------------------------------------------------------------------*/
  {set ToolbarTargetEvents pcEvents}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolHeightPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setToolHeightPxl Procedure 
FUNCTION setToolHeightPxl RETURNS LOGICAL
  ( iValue AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  {set ToolHeightPxl iValue}. 
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolMarginPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setToolMarginPxl Procedure 
FUNCTION setToolMarginPxl RETURNS LOGICAL
  ( iValue AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  &SCOPED-DEFINE xpToolMarginPxl  
  {set ToolMarginPxl iValue}. 
  &UNDEFINE xpToolMarginPxl
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolMaxWidthPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setToolMaxWidthPxl Procedure 
FUNCTION setToolMaxWidthPxl RETURNS LOGICAL
    ( iValue AS INTEGER ) :
/*------------------------------------------------------------------------------
Purpose:  
  Notes:  
------------------------------------------------------------------------------*/

    {set ToolMaxWidthPxl iValue}. 
    RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolSeparatorPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setToolSeparatorPxl Procedure 
FUNCTION setToolSeparatorPxl RETURNS LOGICAL
    ( iValue AS INTEGER ) :
/*------------------------------------------------------------------------------
Purpose:  
  Notes:  
------------------------------------------------------------------------------*/

    {set ToolSeparatorPxl iValue}. 
    RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolSpacingPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setToolSpacingPxl Procedure 
FUNCTION setToolSpacingPxl RETURNS LOGICAL
    ( iValue AS INTEGER ) :
/*------------------------------------------------------------------------------
Purpose:  
  Notes:  
------------------------------------------------------------------------------*/

    {set ToolSpacingPxl iValue}. 
    RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setToolWidthPxl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setToolWidthPxl Procedure 
FUNCTION setToolWidthPxl RETURNS LOGICAL
  ( iValue AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  {set ToolWidthPxl iValue}. 
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-substituteActionText) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION substituteActionText Procedure 
FUNCTION substituteActionText RETURNS CHARACTER
  ( pcAction AS CHAR,
    pcText   AS CHAR ) :
/*------------------------------------------------------------------------------
    Purpose: Substitute &1 in the passed text with the substitute property.
 Parameters: pcAction - action name 
             pcText   - Text to substitute  
      Notes: Used by actionLabel, actionCaption and actionTooltip overrrides 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cProperty   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSubstitute AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hLink       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hObject     AS HANDLE     NO-UNDO.
  
  IF INDEX(pcText,'&1':U) > 0 THEN
  DO:    
    ASSIGN
      hObject   = {fnarg actionTarget pcAction} 
      cProperty = {fnarg actionSubstituteProperty pcAction}. 
            
    IF VALID-HANDLE(hObject) AND cProperty > '':U THEN
      cSubstitute = DYNAMIC-FUNCTION('get':U + cProperty IN hObject) NO-ERROR.         
    
    IF cSubstitute = ? THEN
      cSubstitute = '':U.
    
    pcText = REPLACE(pcText,'&1':U,cSubstitute).
   
  END.
  RETURN pctext. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-supportedObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION supportedObjects Procedure 
FUNCTION supportedObjects RETURNS CHARACTER
  (plLoaded AS LOG) :
/*------------------------------------------------------------------------------
   Purpose: Returns a comma separated list of object names for object linked 
            with supported links. 
            Semi-colon is used to separate a potential RunAtttribute  
 Parameter: plLoaded - Yes - return all objects
                       No  - return objects with unloaded ObjectBands                         
     Notes: Currently only returns the container since this is the only 
            object that supports ObjectBands.     
------------------------------------------------------------------------------*/  
  DEFINE VARIABLE cObjectName      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRunAttribute    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hContainerSource AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cObjectList      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lHasObjectMenu   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cLinkTargetNames AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLink            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cLink            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hObject          AS HANDLE     NO-UNDO.

  {get ContainerSource hContainerSource}.

  IF VALID-HANDLE(hContainerSource) THEN
  DO:
    &SCOPED-DEFINE xp-assign
    {get LogicalObjectName cObjectName hContainerSource}
    {get RunAttribute cRunAttribute hContainerSource}
    {get HasObjectMenu lHasObjectMenu hContainerSource}
    .
    &UNDEFINE xp-assign

    IF plLoaded 
    OR (lHasObjectMenu = TRUE 
        AND NOT CAN-FIND(FIRST ttObjectBand 
                         WHERE ttObjectBand.ObjectName   = cObjectName 
                         AND   ttObjectBand.Runattribute = cRunAttribute)) THEN

       cObjectList = cObjectName + 
                    (IF cRunattribute = '':U THEN '':U ELSE ';':U + cRunattribute).


  END.
  
  /**  We currently do not support ObjectMenus on linked objects 
      {get LinkTargetNames cLinkTargetNames}.  
      DO iLink = 1 TO NUM-ENTRIES(cLinkTargetNames):
        ASSIGN 
         cLink       = ENTRY(iLink,cLinkTargetNames)
         hObject     = DYNAMIC-FUNCTION('get':U + cLink) NO-ERROR.
        IF VALID-HANDLE(hObject) THEN
        DO:
          {get LogicalObjectName cObjectName hObject}.
          lHasObjectMenu = NO.
          {get HasObjectMenu lHasObjectMenu hObject} NO-ERROR.
          IF plLoaded  
          OR (lHasObjectMenu = TRUE 
             AND 
             NOT CAN-FIND(FIRST ttObjectBand 
                              WHERE ttObjectBand.ObjectName = cObjectName)) THEN      
          cObjectList = cObjectList 
                      + (IF cObjectList <> '':U THEN ',':U ELSE '':U)
                      + cObjectName.
        END.
      END.
  END.
  **/

  RETURN cObjectList.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-targetActions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION targetActions Procedure 
FUNCTION targetActions RETURNS CHARACTER
  ( pcLinkType AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the actions that applies to a specific target 
Parameter: LinkType 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER btMenu   FOR tMenu.
  DEFINE BUFFER btButton FOR tButton.
  
  DEFINE VARIABLE cLink        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cActions     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cControlType AS CHARACTER  NO-UNDO.

  IF pcLinkType <> '':U THEN  
    cLink = pcLinkType + '-target':U. 
  
  FOR EACH btButton WHERE btButton.hTarget = TARGET-PROCEDURE
                    AND   btButton.Link    = cLink:
    IF VALID-HANDLE(btButton.hdl) THEN
    DO:
      cControlType = {fnarg actionControlType btButton.Name}.
      IF cControlType = 'Action':U THEN
        cActions = cActions 
                   + (IF cActions <> '':U THEN ',':U ELSE '':U)
                   + btButton.Name.
    END.
  END.
  FOR EACH btMenu WHERE btMenu.hTarget = TARGET-PROCEDURE
                 AND   btMenu.Link     = cLink:
    
    IF NOT CAN-DO(cActions,btMenu.Name) AND VALID-HANDLE(btMenu.hdl) THEN
    DO: 
      cControlType = {fnarg actionControlType btMenu.Name}.
      IF cControlType = 'Action':U THEN
        cActions = cActions 
                 + (IF cActions <> '':U THEN ',':U ELSE '':U)
                 + btMenu.Name.     
    END.
  END.
  
  RETURN cActions. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validateBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION validateBuffer Procedure 
FUNCTION validateBuffer RETURNS LOGICAL PRIVATE
  ( pcBuffer AS CHAR,
    pcKey    AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Validate the data of a buffer (Action is the only buffer) 
    Notes: this is done after create  
------------------------------------------------------------------------------*/
  IF pcKey = "delete" THEN
  DO:
     MESSAGE {fnarg messageNumber 37} TRANSACTION VIEW-AS ALERT-BOX.
     RETURN FALSE.   /* Function return value. */
  END.
  ELSE RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-windowDropDownList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION windowDropDownList Procedure 
FUNCTION windowDropDownList RETURNS LOGICAL
  ( pcAction AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     (re)build drop down list of session windows
  Parameters:  input submenu to build list in
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE cUIBMode         AS CHARACTER NO-UNDO.  
DEFINE VARIABLE iCount           AS INTEGER   NO-UNDO.
DEFINE VARIABLE hwindowRule      AS HANDLE    NO-UNDO.
DEFINE VARIABLE hContainerSource AS HANDLE    NO-UNDO.

{get UIBMode cUIBMode}.

IF cUIBMode = "Design":U THEN 
  RETURN FALSE.

DEFINE BUFFER btParent FOR tMenu.
DEFINE BUFFER btMenu   FOR tMenu.

FIND btParent  WHERE btParent.Name = pcAction 
               AND   btParent.hTarget = TARGET-PROCEDURE NO-ERROR. 

IF NOT AVAIL btparent OR NOT VALID-HANDLE(btParent.Hdl) THEN
  RETURN FALSE.


/* 1st zap existing window drop down list entries () */
FOR EACH btMenu
   WHERE btMenu.PARENT = pcAction 
     AND btMenu.NAME   BEGINS pcAction + ':':U.
   IF VALID-HANDLE(btMenu.hdl) THEN
     DELETE WIDGET btMenu.hdl.
   DELETE btMenu.
END. 

/* Add a rule if there is a fixed item on the menu and no rule */
FIND LAST btMenu WHERE btMenu.Parent  = pcAction 
                 AND   btMenu.hTarget = btParent.hTarget NO-ERROR. 

IF AVAIL btMenu AND btMenu.Name <> 'RULE':U OR NOT VALID-HANDLE(btMenu.Hdl) THEN
DO:                    
  hWindowRule = DYNAMIC-FUNCTION ('createMenuAction':U IN TARGET-PROCEDURE,
                       pcAction,
                      'RULE':U).  
  hWindowRule:PARENT = btParent.Hdl.
END.

{get ContainerSource hContainerSource}.
/* And build new list */
RUN WindowListMenu IN TARGET-PROCEDURE (INPUT pcAction,
                                        INPUT hContainerSource,
                                        INPUT SESSION,
                                        INPUT-OUTPUT iCount).

/* Remove the rule added above if no windows were added */
IF iCount = 0 AND VALID-HANDLE(hWindowRule) THEN
DO:
  FIND btMenu WHERE btMenu.hdl     = hWindowRule NO-ERROR.
  IF AVAIL btMenu THEN 
     DELETE btMenu.
          
  DELETE OBJECT hWindowRule.

END.

RETURN iCount > 0.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

