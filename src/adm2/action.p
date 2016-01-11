&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
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
    File        : action.p
    Purpose     : Super procedure for action class.
                  Manages actions for an application. 
                  The object manages class actions and instance actions.
                  Class Actions are never destroyed and are shared by all 
                  objects while Instance Actions are created for each instance 
                  of an object and deleted in destroyObject. 
                  defineAction creates an action (if it already exist it will 
                  be overwritten). If 'instance' is one of the fields in the 
                  field list the action is created as an instance class and
                  the target-procedure will be stored in the action temp-table.
                  findAction will always look for a class action first.  
                - The Action id is unique within the instance and the class.
                  It's not possible to create an instance action with the same 
                  id as a class action or vice versa.  
                - Action properties are only accessed through the action*() 
                  methods. The temp-table is never exposed. 
                - There is a set of assignAction* methods, which only can
                  be used to change class actions.                  
                                     
    Syntax      : RUN start-super-proc("adm2/action.p":U).

    Modified    : 12/28/1999
    Modofied    : 13/11/2001 - Mark Davies (MIP)
                  Check for valid-handle for all gsh... variables
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&SCOP ADMSuper action.p

  /* Custom exclude file */

  {src/adm2/custom/actionexclcustom.i}

DEFINE VARIABLE ghAction      AS HANDLE NO-UNDO.
DEFINE VARIABLE ghCategory    AS HANDLE NO-UNDO.
DEFINE VARIABLE ghInitialized AS LOG    NO-UNDO.

/* This variable is needed at least temporarily in 9.1B so that a called
   fn can tell who the actual source was.  */
DEFINE VARIABLE ghTargetProcedure AS HANDLE     NO-UNDO.

{src/adm2/ttaction.i}

/* We define a dynamic table and buffer to store all functions that 
   are basis of a rule, in the case where some of the fields are not found
   we try again if the link changes, but we do not want to go on and  
   do this forever since the problem may be in the actual object type we are 
   linked to, for example in a menu/treeview which  may switch 100s of links.. 
   so we have a low predefined limit of attempted tries 
   (maybe 2 is sufficient? )*/ 
     
DEFINE VARIABLE xiMaxLinkChecks AS INTEGER INIT 3  NO-UNDO.

/* This manages the various dynamic temptables created to store func names and
   values for a linked target */
DEFINE TEMP-TABLE ttLinkRuleTable
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

&IF DEFINED(EXCLUDE-actionCaption) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionCaption Procedure 
FUNCTION actionCaption RETURNS CHARACTER
  (pcAction AS CHAR)  FORWARD.

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

&IF DEFINED(EXCLUDE-actionChildren) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionChildren Procedure 
FUNCTION actionChildren RETURNS CHARACTER
  (pcId AS CHAR)  FORWARD.

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
  ( pcAction AS CHAR)  FORWARD.

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

&IF DEFINED(EXCLUDE-actionTooltip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionTooltip Procedure 
FUNCTION actionTooltip RETURNS CHARACTER
  (pcAction AS CHAR)  FORWARD.

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

&IF DEFINED(EXCLUDE-assignActionAlternateImageRule) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignActionAlternateImageRule Procedure 
FUNCTION assignActionAlternateImageRule RETURNS LOGICAL
  (pcId AS CHAR,
   pcValue AS CHAR)  FORWARD.

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

&IF DEFINED(EXCLUDE-assignActionDisableRule) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignActionDisableRule Procedure 
FUNCTION assignActionDisableRule RETURNS LOGICAL
  (pcId AS CHAR,
   pcValue AS CHAR)  FORWARD.

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

&IF DEFINED(EXCLUDE-bufferHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD bufferHandle Procedure 
FUNCTION bufferHandle RETURNS HANDLE
  (pcObject AS CHAR)  FORWARD.

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

&IF DEFINED(EXCLUDE-columnStringValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnStringValue Procedure 
FUNCTION columnStringValue RETURNS CHAR PRIVATE
  (pcObject AS CHAR,
   pcId     AS CHAR,
   pcColumn AS CHAR,
   phTarget AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-defineAction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD defineAction Procedure 
FUNCTION defineAction RETURNS LOGICAL
  (pcId      AS CHAR,
   pcColumns AS CHAR,
   pcValues  AS CHAR)  FORWARD.

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
FUNCTION findAction RETURNS LOGICAL PRIVATE
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

&IF DEFINED(EXCLUDE-getTargetProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTargetProcedure Procedure 
FUNCTION getTargetProcedure RETURNS HANDLE
  (   )  FORWARD.

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

&IF DEFINED(EXCLUDE-setBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBuffer Procedure 
FUNCTION setBuffer RETURNS LOGICAL PRIVATE
  (pcObject  AS CHAR,
   pcId      AS CHAR,
   pcColumns AS CHAR,
   pcValues  AS CHAR,
   phTarget  AS HANDLE)  FORWARD.

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
         HEIGHT             = 12.81
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/actiprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
ghAction   = BUFFER ttAction:HANDLE.
ghCategory = BUFFER ttCategory:HANDLE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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
  Notes:    toolbar override deletes toolbar class tables   
------------------------------------------------------------------------------*/
  RUN clearActionCache IN TARGET-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject Procedure 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose: Delete the toolbars instance actions when it is destroyed   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH ttAction WHERE ttAction.ProcedureHandle = TARGET-PROCEDURE:
    DELETE ttAction.
  END.
  FOR EACH ttLinkRuleTable WHERE ttLinkRuleTable.ProcedureHandle = TARGET-PROCEDURE:
    IF VALID-HANDLE(ttLinkRuleTable.TableHandle) THEN
      DELETE OBJECT ttLinkRuleTable.TableHandle.
    DELETE ttLinkRuleTable.
  END.
  RUN SUPER.
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
                "RecordState=RecordAvailable  and  Editable and ObjectMode=View":U
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
                "NewRecord=add,copy or ObjectMode=Update":U
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
  Purpose: intializeObject    
  Parameters:  
  Notes:   Main purpose is to run initAction to define 'class' actions. 
           These properties are   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lUseRepos AS LOGICAL    NO-UNDO.

  {get UseRepository lUseRepos}.
  IF NOT ghInitialized AND NOT lUseRepos THEN
  DO:
    /* This is considered class properties and will only be defined the
       first time an instance is initialized. */
    RUN initAction IN TARGET-PROCEDURE. 
    ghInitialized = TRUE.
  END.
  
  RUN SUPER.

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
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER pcActionList AS CHARACTER  NO-UNDO. 

 IF VALID-HANDLE(gshRepositoryManager) THEN
   RUN getActions IN gshRepositoryManager
                       (INPUT '':U,
                        INPUT pcActionList,
                        OUTPUT TABLE ttAction APPEND,
                        OUTPUT TABLE ttCategory APPEND).
                        
 {fn normalizeActionData}.

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

 DEFINE VARIABLE hToolbarBand AS HANDLE. 
 DEFINE VARIABLE hObjectBand  AS HANDLE. 

 IF VALID-HANDLE(gshRepositoryManager) THEN
   RUN getToolbarBandActions IN gshRepositoryManager
                          (INPUT '', /* no toolbar */
                           INPUT '':U, /* no object */
                           INPUT pcBandList,
                           OUTPUT TABLE-HANDLE hToolbarBand,
                           OUTPUT TABLE-HANDLE hObjectBand,
                           OUTPUT TABLE-HANDLE hBand,
                           OUTPUT TABLE-HANDLE hBandAction,
                           OUTPUT TABLE ttAction APPEND,
                           OUTPUT TABLE ttCategory APPEND).
                        
 {fn normalizeActionData}.

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
 DEFINE OUTPUT PARAMETER TABLE-HANDLE hObjectBand.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE hBand.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE hBandAction.

 DEFINE VARIABLE hToolbarBand AS HANDLE. 
 
 IF VALID-HANDLE(gshRepositoryManager) THEN
   RUN getToolbarBandActions IN gshRepositoryManager
                          (INPUT '',
                           INPUT pcObjectList,
                           INPUT '':U,
                           OUTPUT TABLE-HANDLE hToolbarBand,
                           OUTPUT TABLE-HANDLE hObjectBand,
                           OUTPUT TABLE-HANDLE hBand,
                           OUTPUT TABLE-HANDLE hBandAction,
                           OUTPUT TABLE ttAction APPEND,
                           OUTPUT TABLE ttCategory APPEND).
                        
 {fn normalizeActionData}.

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
 DEFINE INPUT  PARAMETER pcToolbar    AS CHARACTER  NO-UNDO.
 DEFINE INPUT  PARAMETER pcObjectList AS CHARACTER  NO-UNDO.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE hToolbarBand.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE hObjectBand.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE hBand.
 DEFINE OUTPUT PARAMETER TABLE-HANDLE hBandAction.

 IF VALID-HANDLE(gshRepositoryManager) THEN
   RUN getToolbarBandActions IN gshRepositoryManager
                          (INPUT pcToolbar,
                           INPUT pcObjectList,
                           INPUT '':U,
                           OUTPUT TABLE-HANDLE hToolbarBand,
                           OUTPUT TABLE-HANDLE hObjectBand,
                           OUTPUT TABLE-HANDLE hBand,
                           OUTPUT TABLE-HANDLE hBandAction,
                           OUTPUT TABLE ttAction APPEND,
                           OUTPUT TABLE ttCategory APPEND).
                        
 {fn normalizeActionData}.

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
 
END.

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
 RETURN columnStringValue("Action":U,pcAction,"Accelerator":U,TARGET-PROCEDURE).  
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
 RETURN columnStringValue("Action":U,pcAction,"AccessType":U,TARGET-PROCEDURE).  
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

&IF DEFINED(EXCLUDE-actionCaption) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionCaption Procedure 
FUNCTION actionCaption RETURNS CHARACTER
  (pcAction AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
   DEFINE VARIABLE cCaption AS CHAR   NO-UNDO.
   cCaption = columnStringValue("Action":U,pcAction,"TranslatedActionMLabel":U,TARGET-PROCEDURE).
   IF cCaption = '':U THEN
     cCaption = columnStringValue("Action":U,pcAction,"TranslatedActionLabel":U,TARGET-PROCEDURE).
   IF cCaption = '':U THEN
     cCaption = columnStringValue("Action":U,pcAction,"Caption":U,TARGET-PROCEDURE).
   RETURN IF cCaption <> "":U THEN cCaption
          ELSE {fnarg actionName pcAction}. 
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
 RETURN columnStringValue("Action":U,pcAction,"Category":U,TARGET-PROCEDURE).  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionChildren) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionChildren Procedure 
FUNCTION actionChildren RETURNS CHARACTER
  (pcId AS CHAR) :
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
  
  IF findAction(pcId,TARGET-PROCEDURE) THEN   
  DO:
    FOR EACH bttChild WHERE bttChild.Parent = pcId
                      AND   bttChild.ProcedureHandle = THIS-PROCEDURE
    BY bttChild.order:  
      cActions = cActions + ",":U + bttChild.Action.
    END.
    FOR EACH bttChild WHERE bttChild.Parent = pcId
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
           - For non repository actions 
              we return 'Action' if onchoose <> '' and not a parent action 
              otherwise it is a 'label' (RULE is not defined in action) 
   Notes:  Used in targetActions to retrieve actions for a link 
           and in createMenuAction to ensure that a submenu NOT is created 
           for a placeholder. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lUseRepository  AS LOGICAL  NO-UNDO.
  
  {get UseRepository lUseRepository}.
  IF lUseRepository THEN
    RETURN columnStringValue("Action":U,pcAction,"ControlType":U,TARGET-PROCEDURE).  
  ELSE DO:
    RETURN IF  {fnarg actionOnChoose pcAction} <> '':u 
           AND {fnarg actionIsParent pcAction} = FALSE 
           THEN 'Action':U
           ELSE 'Label':U.
  END.

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
 RETURN columnStringValue("Action":U,pcAction,"CreateEvent":U,TARGET-PROCEDURE).  
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
 RETURN columnStringValue("Action":U,pcAction,"Description":U,TARGET-PROCEDURE).  
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
RETURN CAN-DO("YES,TRUE":U,
            columnStringValue("Action":U,pcAction,"Disabled":U,TARGET-PROCEDURE)).

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
------------------------------------------------------------------------------*/
 RETURN columnStringValue("Action":U,pcAction,"EnableRule":U,TARGET-PROCEDURE).  
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
------------------------------------------------------------------------------*/
 RETURN columnStringValue("Action":U,pcAction,"HideRule":U,TARGET-PROCEDURE).  
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
    Notes:  
------------------------------------------------------------------------------*/
  RETURN columnStringValue("Action":U,pcAction,"Image":U,TARGET-PROCEDURE). 
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
    Notes:  
------------------------------------------------------------------------------*/
  RETURN columnStringValue("Action":U,pcAction,"Image2":U,TARGET-PROCEDURE). 
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
------------------------------------------------------------------------------*/
 RETURN columnStringValue("Action":U,pcAction,"ImageAlternateRule":U,TARGET-PROCEDURE).  
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
 RETURN columnStringValue("Action":U,pcAction,"InitCode":U,TARGET-PROCEDURE).  
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
  RETURN  {fnarg actionType pcAction} = "MENU":U .
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
  RETURN ({fnarg actionInitCode pcAction} <> "":U) 
         OR 
         ({fnarg actionCreateEvent pcAction} <> "":U)
         OR 
         (CAN-FIND(FIRST ttAction WHERE ttAction.parent = pcAction)).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionLabel Procedure 
FUNCTION actionLabel RETURNS CHARACTER
  ( pcAction AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Return the button label of the action 
    Notes: actionLabel is an alias for actionName 
------------------------------------------------------------------------------*/
  RETURN {fnarg ActionName pcAction}.

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
  cLink = columnStringValue("Action":U,pcAction,"Link":U,TARGET-PROCEDURE). 
  IF cLink = '':U THEN
  DO:
    {get UseRepository lUseRepository}.
    IF lUseRepository THEN
    DO:
      cCategory = {fnarg actionCategory pcAction}.
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
  RETURN columnStringValue("Action":U,pcAction,"LogicalObjectName":U,TARGET-PROCEDURE). 
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
  DEFINE VARIABLE cName AS CHAR   NO-UNDO.
  cName = columnStringValue("Action":U,pcAction,"TranslatedActionLabel":U,TARGET-PROCEDURE).
  IF cName = '':U THEN
     cName = columnStringValue("Action":U,pcAction,"Name":U,TARGET-PROCEDURE).  
  IF cName = "":U THEN
     cName = columnStringValue("Action":U,pcAction,"Action":U,TARGET-PROCEDURE).
  RETURN cName.

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
 RETURN columnStringValue("Action":U,pcAction,"OnChoose":U,TARGET-PROCEDURE).  
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
 RETURN columnStringValue("Action":U,pcAction,"RunParameter":U,TARGET-PROCEDURE).  
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
  RETURN columnStringValue("Action":U,pcAction,"Parent":U,TARGET-PROCEDURE).  
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
  RETURN columnStringValue("Action":U,pcAction,"PhysicalObjectName":U,TARGET-PROCEDURE). 
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
  RETURN CAN-DO("YES,TRUE":U,
            columnStringValue("Action":U,pcAction,"Refresh":U,TARGET-PROCEDURE)). 
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
  RETURN columnStringValue("Action":U,pcAction,"RunAttribute":U,TARGET-PROCEDURE). 
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
  RETURN columnStringValue("Action":U,pcAction,"Image2":U,TARGET-PROCEDURE). 
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
  RETURN columnStringValue("Action":U,pcAction,"SecurityToken":U,TARGET-PROCEDURE). 
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
 RETURN columnStringValue("Action":U,pcAction,"SubstituteProperty":U,TARGET-PROCEDURE).  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-actionTooltip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionTooltip Procedure 
FUNCTION actionTooltip RETURNS CHARACTER
  (pcAction AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
   DEFINE VARIABLE cTooltip AS CHAR   NO-UNDO.
   cTooltip = columnStringValue("Action":U,pcAction,"TranslatedActionTooltip":U,TARGET-PROCEDURE).
   IF cTooltip = '':U THEN
     cTooltip = columnStringValue("Action":U,pcAction,"TranslatedActionMLabel":U,TARGET-PROCEDURE).
   IF cTooltip = '':U THEN
     cTooltip = columnStringValue("Action":U,pcAction,"TranslatedActionLabel":U,TARGET-PROCEDURE).
   IF cTooltip = '':U THEN
      cTooltip = columnStringValue("Action":U,pcAction,"Tooltip":U,TARGET-PROCEDURE).
   IF cTooltip = '':U THEN
     cTooltip = {fnarg ActionCaption pcAction}.
   
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
 RETURN columnStringValue("Action":U,pcAction,"Type":U,TARGET-PROCEDURE).  
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

&IF DEFINED(EXCLUDE-assignActionAlternateImageRule) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignActionAlternateImageRule Procedure 
FUNCTION assignActionAlternateImageRule RETURNS LOGICAL
  (pcId AS CHAR,
   pcValue AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN assignColumn("Action":U,pcId,"AlternateImageRule":U,pcValue).

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

&IF DEFINED(EXCLUDE-assignActionDisableRule) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignActionDisableRule Procedure 
FUNCTION assignActionDisableRule RETURNS LOGICAL
  (pcId AS CHAR,
   pcValue AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN assignColumn("Action":U,pcId,"DisableRule":U,pcValue).

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
  ELSE errorMessage ('assign':U + pcColumn + "()":U 
                      + ' could not find class action ~'' +  pcId + '~'').
         
  RETURN FALSE.
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
      hBuffer = ghAction.     
    WHEN "Category":U THEN 
      hBuffer = ghCategory.     
  END.

  RETURN hBuffer.
  
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
  RETURN findAction(pcAction,TARGET-PROCEDURE).

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

&IF DEFINED(EXCLUDE-categoryLink) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION categoryLink Procedure 
FUNCTION categoryLink RETURNS CHARACTER
  (pcCategory AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
 RETURN columnStringValue("Category":U,pcCategory,"Link":U,TARGET-PROCEDURE).  
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

&IF DEFINED(EXCLUDE-columnStringValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnStringValue Procedure 
FUNCTION columnStringValue RETURNS CHAR PRIVATE
  (pcObject AS CHAR,
   pcId     AS CHAR,
   pcColumn AS CHAR,
   phTarget AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBuffer AS HANDLE NO-UNDO.
  DEFINE VARIABLE hColumn AS HANDLE NO-UNDO.
  
  IF DYNAMIC-FUNCTION("find":U + pcObject, pcId, phTarget) THEN     
  DO:
    ASSIGN
      hBuffer = bufferHandle(pcObject)
      hColumn = hBuffer:BUFFER-FIELD(pcColumn).  
    RETURN TRIM(hColumn:BUFFER-VALUE).   
  END.
  ELSE RETURN "":U.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-defineAction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION defineAction Procedure 
FUNCTION defineAction RETURNS LOGICAL
  (pcId      AS CHAR,
   pcColumns AS CHAR,
   pcValues  AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN setBuffer("Action":U,pcId,pcColumns,PcValues,TARGET-PROCEDURE).
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
  
  MESSAGE "Action error: " SKIP
           pcError
  VIEW-AS ALERT-BOX WARNING.
  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findAction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION findAction Procedure 
FUNCTION findAction RETURNS LOGICAL PRIVATE
  (pcAction AS CHAR,
   phTarget AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  FIND FIRST ttAction WHERE ttAction.Action = pcAction 
                      AND   ttAction.ProcedureHandle  = THIS-PROCEDURE NO-ERROR.
  IF NOT AVAILABLE ttAction AND phTarget <> ? THEN
     FIND ttAction WHERE ttAction.Action = pcAction 
                   AND   ttAction.ProcedureHandle = phTarget NO-ERROR.

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
           hTable:ADD-NEW-FIELD(cFunction,(IF cDataType <> ? THEN cdataType ELSE 'CHARACTER'),0,?,?).
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

&IF DEFINED(EXCLUDE-normalizeActionData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION normalizeActionData Procedure 
FUNCTION normalizeActionData RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Remove duplicate entries of temp-tables after load
    Notes:  The procedurehandle is used to identify data that justr have been 
            added 
------------------------------------------------------------------------------*/   
 DEFINE BUFFER bttAction   FOR ttAction.
 DEFINE BUFFER bttCategory FOR ttCategory.
 
 FOR EACH ttAction WHERE ttAction.ProcedureHandle = ?:
   IF CAN-FIND(FIRST bttAction 
                     WHERE bttAction.Action          =  ttAction.Action
                     AND   bttAction.ProcedureHandle <> ?) THEN
     DELETE ttAction.
   ELSE 
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

&IF DEFINED(EXCLUDE-setBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBuffer Procedure 
FUNCTION setBuffer RETURNS LOGICAL PRIVATE
  (pcObject  AS CHAR,
   pcId      AS CHAR,
   pcColumns AS CHAR,
   pcValues  AS CHAR,
   phTarget  AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose: Creates or assigns properties for an action. 
    Notes: PRIVATE -  
------------------------------------------------------------------------------*/
  DEFINE BUFFER bttAction FOR ttACTION.

  DEFINE VARIABLE hBuffer      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cColumn      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hColumn      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iOrder       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE i            AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cLink        AS CHARACTER NO-UNDO.

  hBuffer = bufferHandle(pcObject).  
  
  IF NOT findAction(pcId,phTarget) THEN
  DO:
    /* If we are creating a class make sure there's no instance defined */
    IF  NOT CAN-DO(pcColumns,"Instance":U)
    AND CAN-FIND(FIRST bttAction WHERE bttAction.Action = pcId) THEN 
    DO:
      errorMessage ('Cannot create class action ~'' +  pcId + '~'.'
                    + CHR(10) +
                    'It already exists as an instance action.').
      RETURN FALSE.
    END.
    
    hBuffer:BUFFER-CREATE().
    
    ASSIGN
      hColumn = hBuffer:BUFFER-FIELD('Action':U)
      hColumn:BUFFER-VALUE = pcId.  
    /* Set target to class in order to check for duplicates when reading
       data from repository */
    IF NOT CAN-DO(pcColumns,"Instance":U) THEN
      ASSIGN
        hColumn = hBuffer:BUFFER-FIELD('ProcedureHandle':U)
        hColumn:BUFFER-VALUE = THIS-PROCEDURE.
  END. /* not findAction */

  /* If the action exists and this is the definition of an instance 
     action, check that the one we have found is not a class action.  */ 
  ELSE IF CAN-DO(pcColumns,"Instance":U) THEN 
  DO:
    hColumn = hBuffer:BUFFER-FIELD('ProcedureHandle').
    IF hColumn:BUFFER-VALUE <> phTarget THEN 
    DO:
      errorMessage ('Cannot create instance action ~'' +  pcId + '~'.'
                    + CHR(10) +
                    'It already exists as a class action.').
      RETURN FALSE.
    END.
  END. /* else (avail action) can-do(pccolumns,'instance') */ 
  
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

  RETURN hBuffer:AVAILABLE. 
 
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
     MESSAGE 'undo' TRANSACTION VIEW-AS ALERT-BOX.
     RETURN FALSE.   /* Function return value. */
  END.
  ELSE RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

