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
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&SCOP ADMSuper action.p

  /* Custom exclude file */

  {src/adm2/custom/actionexclcustom.i}

DEFINE VARIABLE ghAction      AS HANDLE NO-UNDO.
DEFINE VARIABLE ghInitialized AS LOG    NO-UNDO.
  
DEFINE TEMP-TABLE tAction 
 FIELD Action         AS CHAR FORMAT "x(12)":U
 FIELD Name           AS CHAR FORMAT "x(25)":U
 FIELD Parent         AS CHAR FORMAT "x(12)":U
 FIELD Caption        AS CHAR FORMAT "x(25)":U
 FIELD Image          AS CHAR FORMAT "x(25)":U
 FIELD Accelerator    AS CHAR FORMAT "x(25)":U
 FIELD Description    AS CHAR FORMAT "x(40)":U
 FIELD AccessType     AS CHAR FORMAT "x(25)":U
 FIELD Link           AS CHAR FORMAT "x(12)":U
 FIELD Type           AS CHAR FORMAT "x(8)":U
 FIELD InitCode       AS CHAR FORMAT "x(25)":U
 FIELD createEvent    AS CHAR FORMAT "x(25)":U
 FIELD Refresh        AS LOG
 FIELD OnChoose       AS CHAR FORMAT "x(25)":U
 FIELD Order          AS INT  FORMAT "zz9"
 FIELD ToolbarHandle  AS HANDLE
 
 INDEX Action         AS UNIQUE Action ToolbarHandle
 INDEX targetProc               ToolbarHandle
 INDEX Parent                   Parent ToolbarHandle Order.

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

&IF DEFINED(EXCLUDE-actionCaption) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionCaption Procedure 
FUNCTION actionCaption RETURNS CHARACTER
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

&IF DEFINED(EXCLUDE-actionGroups) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionGroups Procedure 
FUNCTION actionGroups RETURNS CHARACTER
  ()  FORWARD.

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

&IF DEFINED(EXCLUDE-actionLink) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionLink Procedure 
FUNCTION actionLink RETURNS CHARACTER
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

&IF DEFINED(EXCLUDE-actionParent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD actionParent Procedure 
FUNCTION actionParent RETURNS CHARACTER
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

&IF DEFINED(EXCLUDE-assignActionImage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignActionImage Procedure 
FUNCTION assignActionImage RETURNS LOGICAL
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
         HEIGHT             = 15.1
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
ghAction  = BUFFER tAction:HANDLE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-destroyObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject Procedure 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose: Delete the toolbars instance actions when it is destroyed   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR EACH tAction WHERE tAction.ToolbarHandle = TARGET-PROCEDURE:
    DELETE tAction.
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
  DEFINE QUERY qAction FOR tAction SCROLLING.
  
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
      WHEN "parent" THEN OPEN QUERY qAction FOR EACH tAction  BY PARENT BY order.
      WHEN "name" THEN OPEN QUERY qAction FOR EACH tAction  BY Name.
      WHEN "Action" THEN OPEN QUERY qAction FOR EACH tAction  BY Action.
      OTHERWISE OPEN QUERY qAction FOR EACH tAction  BY Action.
    END CASE.
  END.
      
  ENABLE Radio-Sort bAction   Btn_OK   
      WITH FRAME Dialog-Frame.
  
  OPEN QUERY qAction FOR EACH tAction  BY PARENT BY order.
  
  WAIT-FOR GO OF FRAME Dialog-Frame.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initAction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initAction Procedure 
PROCEDURE initAction :
/*------------------------------------------------------------------------------
  Purpose: Defines all default actions for the adm.     
  Parameters:  <none>
  Notes:  The actions defined here are class actions and are available for all 
          objects (toolbars) that inherits from this class. 
          This procedure is called from initializeObject, but ONLY the first 
          time it's been called. 
------------------------------------------------------------------------------*/
   DEF VAR xcColumns AS CHAR INIT 
   "Name,Caption,Image,Type,OnChoose,AccessType,Parent":U.
   
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
                "TABLEIO":U
                ).
   defineAction("UPDATE":U,xcColumns,
                "Update" {&dlmt}   
                "Update record" {&dlmt}
                "update.bmp":U  {&dlmt}
                "PUBLISH":U  {&dlmt}
                "updateMode('updateBegin')":U {&dlmt}
                "WRITE":U {&dlmt}
                "TABLEIO":U
                ).
                   
   defineAction("COPY":U,xcColumns,
                "Copy" {&dlmt}   
                "Copy record" {&dlmt}
                "copyrec.bmp":U  {&dlmt}
                "PUBLISH":U  {&dlmt}
                "copyRecord":U {&dlmt}
                "CREATE":U {&dlmt}
                "TABLEIO":U
                ).
  
    defineAction("DELETE":U,xcColumns,
                "Delete" {&dlmt}   
                "Delete record" {&dlmt}
                "deleterec.bmp":U  {&dlmt}
                "PUBLISH":U  {&dlmt}
                "deleteRecord":U {&dlmt}
                "DELETE":U {&dlmt}
                "TABLEIO":U
                ).
                
   defineAction("SAVE":U,xcColumns,
                "Save" {&dlmt}   
                "Save record" {&dlmt}
                "saverec.bmp":U  {&dlmt}
                "PUBLISH":U  {&dlmt}
                "updateRecord":U {&dlmt}
                "WRITE":U {&dlmt}
                "TABLEIO":U
                ).
   
   defineAction("RESET":U,xcColumns,
                "Reset" {&dlmt}   
                "Reset" {&dlmt}
                "reset.bmp":U  {&dlmt}
                "PUBLISH":U  {&dlmt}
                "resetRecord":U {&dlmt}
                "":U {&dlmt}
                "TABLEIO":U
                ).
   
   defineAction("CANCEL":U,xcColumns,
                "Cance&l" {&dlmt}   
                "Cance&l" {&dlmt}
                "cancel.bmp":U  {&dlmt}
                "PUBLISH":u  {&dlmt}
                "cancelRecord":U {&dlmt}
                "":U {&dlmt}
                "TABLEIO":U
                ).
   
   defineAction("UNDO":U,xcColumns,
                "U&ndo" {&dlmt}   
                "U&ndo" {&dlmt}
                "rollback.bmp":U  {&dlmt}
                "PUBLISH":U  {&dlmt}
                "undoTransaction":U {&dlmt}
                "":U {&dlmt}
                "TRANSACTION":U
                ).
  
  defineAction("COMMIT":U,xcColumns,
                "Co&mmit" {&dlmt}   
                "Co&mmit" {&dlmt}
                "commit.bmp":U  {&dlmt}
                "PUBLISH":U  {&dlmt}
                "commitTransaction":U {&dlmt}
                "WRITE":U {&dlmt}
                "TRANSACTION":U
                ).
   defineAction("FIRST":U,xcColumns,
                "First" {&dlmt}   
                "First" {&dlmt}
                "first.bmp":U  {&dlmt}
                "PUBLISH":U  {&dlmt}
                "fetchFirst":U {&dlmt}
                "READ":U {&dlmt}
                "NAVIGATION":U
                ).
   defineAction("PREV":U,xcColumns,
                "Prev" {&dlmt}   
                "Prev" {&dlmt}
                "prev.bmp":U  {&dlmt}
                "PUBLISH":U  {&dlmt}
                "fetchPrev":U {&dlmt}
                "READ":U {&dlmt}
                "NAVIGATION":U
                ).
   defineAction("NEXT":U,xcColumns,
                "Next" {&dlmt}   
                "Next" {&dlmt}
                "next.bmp":U  {&dlmt}
                "PUBLISH":U  {&dlmt}
                "fetchNext":U {&dlmt}
                "READ":U {&dlmt}
                "NAVIGATION":U
                ).   
   defineAction("LAST":U,xcColumns,
                "Last" {&dlmt}   
                "Last" {&dlmt}
                "last.bmp":U  {&dlmt}
                "PUBLISH":U  {&dlmt}
                "fetchLast":U {&dlmt}
                "READ":U {&dlmt}
                "NAVIGATION":U
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
   
   defineAction("FILTER":U,xcColumns,
                "Filter" {&dlmt}   
                "Filter" {&dlmt}
                "filter.bmp":U  {&dlmt}
                "PUBLISH":U  {&dlmt}
                "startFilter":U {&dlmt}
                "READ":U {&dlmt}
                "FUNCTION":U {&dlmt}
                "":U
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
  
  IF NOT ghInitialized THEN
  DO:
    /* This is condsidered class properties and will only be defined the
       first time an instance is initialized. */
    RUN initAction IN TARGET-PROCEDURE. 
    ghInitialized = TRUE.
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

&IF DEFINED(EXCLUDE-actionCaption) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionCaption Procedure 
FUNCTION actionCaption RETURNS CHARACTER
  (pcAction AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
   DEFINE VARIABLE cCaption AS CHAR   NO-UNDO.
   cCaption = columnStringValue("Action":U,pcAction,"Caption":U,TARGET-PROCEDURE).
   RETURN IF cCaption <> "":U THEN cCaption
          ELSE {fnarg actionName pcAction}. 
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
  DEFINE BUFFER tChild FOR tAction.
  DEFINE VARIABLE cActions AS CHAR NO-UNDO. 
  
  IF findAction(pcId,TARGET-PROCEDURE) THEN   
  DO:
    FOR EACH tChild WHERE tChild.Parent = pcId
                    AND   tChild.ToolbarHandle = ? 
                    BY tChild.order:  
      cActions = cActions + ",":U + tChild.Action.
    END.
    FOR EACH tChild WHERE tChild.Parent = pcId
                    AND   tChild.ToolbarHandle = TARGET-PROCEDURE
                    BY tChild.order:  
      cActions = cActions + ",":U + tChild.Action.
    END.
  END.

  RETURN LEFT-TRIM(cActions,",":U).

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

&IF DEFINED(EXCLUDE-actionGroups) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionGroups Procedure 
FUNCTION actionGroups RETURNS CHARACTER
  () :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER btChild FOR tAction.
  
  DEFINE VARIABLE cActions AS CHAR NO-UNDO. 
  
  FOR 
  EACH tAction, 
  FIRST btChild WHERE btChild.Parent = tAction.Action:  
     ASSIGN cActions = cActions + ",":U + tAction.Action.
  END.
  RETURN LEFT-TRIM(cActions,",":U).

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
         (CAN-FIND(FIRST tAction WHERE tAction.parent = pcAction)).
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
  RETURN columnStringValue("Action":U,pcAction,"Link":U,TARGET-PROCEDURE). 
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

&IF DEFINED(EXCLUDE-actionParent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION actionParent Procedure 
FUNCTION actionParent RETURNS CHARACTER
  (pcAction AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
 RETURN columnStringValue("Action":U,pcAction,"Parent":U,TARGET-PROCEDURE).  
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
  FIND tAction WHERE tAction.Action        = pcAction 
               AND   tAction.ToolbarHandle = ? NO-ERROR.
  IF NOT AVAILABLE tAction AND phTarget <> ? THEN
     FIND tAction WHERE tAction.Action = pcAction 
                  AND   tAction.ToolbarHandle = phTarget NO-ERROR.

  RETURN AVAILABLE tAction.
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
  DEFINE BUFFER btAction FOR tACTION.

  DEFINE VARIABLE hBuffer AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cColumn AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hColumn AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iOrder  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE i       AS INTEGER   NO-UNDO.
  
  hBuffer = bufferHandle(pcObject).  
  
  IF NOT findAction(pcId,phTarget) THEN
  DO:
    /* If we are creating a class make sure there's no instance defined */
    IF  NOT CAN-DO(pcColumns,"Instance":U)
    AND CAN-FIND(FIRST btAction WHERE btAction.Action = pcId) THEN 
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
 
  END. /* not findAction */

  /* If the action exists and this is the definition of an instance 
     action, check that the one we have found is not a class action.  */ 
  ELSE IF CAN-DO(pcColumns,"Instance":U) THEN 
  DO:
    hColumn = hBuffer:BUFFER-FIELD('toolbarHandle').
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
        hColumn = hBuffer:BUFFER-FIELD('toolbarHandle':U)
        hColumn:BUFFER-VALUE = phTarget.
    ELSE
      ASSIGN
        hColumn = hBuffer:BUFFER-FIELD(cColumn)
        hColumn:BUFFER-VALUE = IF NUM-ENTRIES(pcValues,CHR(1)) >= i
                               THEN ENTRY(i,pcValues,CHR(1))
                               ELSE ?.   

    IF cColumn = "Order":U THEN
      iOrder = hColumn:BUFFER-VALUE. 
     /* Here we should probably loop through the siblings and increase 
        their order. () */ 

  END. /* do i = 1 to num-entries(pccolumns) */ 
  
  /* If order has not been assigned assign default order */
  IF iOrder = 0 THEN 
  DO:      
    FIND LAST btAction WHERE btAction.Parent = tAction.Parent NO-ERROR.
    ASSIGN 
      iOrder = IF AVAIL btAction 
               THEN btAction.Order + 1 
               ELSE 1      
      hColumn = hBuffer:BUFFER-FIELD("ORDER":U)
      hColumn:BUFFER-VALUE = iOrder.           
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

