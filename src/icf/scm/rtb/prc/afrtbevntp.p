&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" Procedure _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Procedure _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
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
/*---------------------------------------------------------------------------------
  File: afrtbevntp.p

  Description:  Roundtable events API hook
  
  Purpose:      This procedure will be run automatically from Roundtable when any event is
                fired within rtb_evnt.p

  Parameters:

  History:
  --------
  (v:010000)    Task:        4043   UserRef:    
                Date:   21/12/1999  Author:     Anthony Swindells

  Update Notes: Created from scratch

  (v:010001)    Task:    90000007   UserRef:    
                Date:   29/03/2001  Author:     Anthony Swindells

  Update Notes: Fix afrtbevntp.p to turn on rv system

  (v:010002)    Task:    90000067   UserRef:    
                Date:   25/04/2001  Author:     Anthony Swindells

  Update Notes: Remove RTB dependancy, so code does not break if RTB not connected /
                in use.

  (v:010003)    Task:    90000018   UserRef:    
                Date:   01/24/2002  Author:     Dynamics Admin User

  Update Notes: add after assign hook for SCM

  (v:010004)    Task:    90000018   UserRef:    
                Date:   01/28/2002  Author:     Dynamics Admin User

  Update Notes: Fix RV and RTB objects, to allow single r-code set

-----------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afrtbevntp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010004

DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.
ASSIGN
  cObjectName = "{&object-name}":U.

ASSIGN
  THIS-PROCEDURE:PRIVATE-DATA = "afrtbevntp.p":U.

/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

DEFINE STREAM ls_output.

/* Integrate with afdbintrap.p */
{af/sup2/afglobals.i NEW GLOBAL}

{rtb/inc/afrtbglobs.i} /* pull in Roundtable global variables */

{af/sup2/afrun2.i     &Define-only = YES}
{af/sup2/afcheckerr.i &Define-only = YES}

DEFINE VARIABLE lv_assign_object_name       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE lv_assign_object_type       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE lv_assign_product_module    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE lv_assign_object_version    AS CHARACTER   NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-isLogicalObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isLogicalObject Procedure 
FUNCTION isLogicalObject RETURNS LOGICAL
  ( ip_object AS CHARACTER )  FORWARD.

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
         HEIGHT             = 5.24
         WIDTH              = 52.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

{ry/app/ryplipmain.i}

SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "ICFSTART_BeforeInitialize":U ANYWHERE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-assign-object) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assign-object Procedure 
PROCEDURE assign-object :
/*------------------------------------------------------------------------------
  Purpose:     After object is assigned
  Parameter :  ip_context       : STRING value of RECID of the rtb_object table
  / Meaning :  ip_other         : Object name
               op_error_message : ignored

  Notes:       The parameters do not work here so we must use the saved variables
               set-up during the before assign hook.
               If we get here, the assign must have worked anyway.

               An object assignment occurs whenever an object version is manually assigned
               between workspaces, an object import is done, or an object version is deleted
               in favour of a previous version.
               In any of these cases, the Dynamics task object test area needs to be reviewed
               for the object versions, plus task statuses may need to be moved.
               This hook handles the above as best it can.
               See notes in code for further explanation.

               Also needs to deal with regeneration of repository object data via xml file.

               /* ICF-SCM-TASK */
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_event            AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_context          AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_other            AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error_message    AS CHARACTER NO-UNDO.

  DEFINE VARIABLE lv_current_workspace        AS CHARACTER    NO-UNDO.

  DEFINE VARIABLE lv_workspace_code           AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE lv_task_workspace           AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE lv_new_area                 AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE lv_new_status               AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE lv_test_area                AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE lv_test_status              AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE lv_choice                   AS LOGICAL INITIAL YES NO-UNDO.
  DEFINE VARIABLE lv_tnot_rowid               AS ROWID        NO-UNDO.
  DEFINE VARIABLE lv_rejection                AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE lv_task                     AS INTEGER      NO-UNDO.
  DEFINE VARIABLE lv_loop                     AS INTEGER      NO-UNDO.
  DEFINE VARIABLE lv_task_list                AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE lv_workspaces               AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE lv_importing                AS LOGICAL      NO-UNDO.
  DEFINE VARIABLE lv_change_status            AS LOGICAL      NO-UNDO.

  DEFINE VARIABLE cButton                     AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cErrorText                  AS CHARACTER    NO-UNDO.

  RUN scmHookAssignObject (INPUT grtb-wspace-id
                          ,INPUT grtb-task-num
                          ,INPUT grtb-userid
                          ,INPUT lv_assign_object_name
                          ,INPUT lv_assign_object_type
                          ,INPUT lv_assign_product_module
                          ,INPUT INTEGER(lv_assign_object_version)
                          ,OUTPUT op_error_message
                          ).

  IF op_error_message <> "":U
  THEN RETURN.

  /* ICF-SCM-TASK */
  /*

  DEFINE BUFFER lb_rvm_task         FOR rvm_task.
  DEFINE BUFFER lb_rvm_task_object  FOR rvm_task_object.

  /*
  Work out workspace code from 1st part of workspace name before the hyphen.
  This is used to check that the object was worked on in a workspace associated with the current workspace.
  For example, if the current workspace this object is being assigned into is gs-v1x,
  then we are only interested in updating test areas and statuses if the task was done in a workspace beginning with gs.
  This avoids the situations of corrupting task status's when importing gs objects into pa workspaces for example.
  */

  ASSIGN
    lv_workspace_code = ENTRY(1,Grtb-wspace-id, "-":U)
    NO-ERROR.

  IF lv_workspace_code = "":U
  THEN DO:

    IF VALID-HANDLE(gshSessionManager)
    THEN DO:
      RUN showMessages IN gshSessionManager
                      (INPUT {af/sup2/aferrortxt.i 'AF' '36' '?' '?' "'the Dynamics task statuses'" "'the workspace name does not contain a hyphen'"}
                      ,INPUT "ERR":U
                      ,INPUT "OK":U
                      ,INPUT "OK":U
                      ,INPUT "OK":U
                      ,INPUT "RTB Error"
                      ,INPUT YES
                      ,INPUT ?
                      ,OUTPUT cButton
                      ).
    END.
    ELSE DO:
      MESSAGE
        "The update of the Dynamics task statuses failed because the workspace name does not contain a hyphen"
        VIEW-AS ALERT-BOX WARNING BUTTONS OK.
    END.

    ASSIGN
      op_error_message = "error":U.
    RETURN.

  END.

  ASSIGN
    lv_current_workspace = Grtb-wspace-id
    .

  FIND FIRST rvm_task_object NO-LOCK
     WHERE rvm_task_object.task_object_name = lv_assign_object_name
     AND   rvm_task_object.object_version   = INTEGER(lv_assign_object_version)
     NO-ERROR.
  IF NOT AVAILABLE rvm_task_object
  THEN RETURN.

  FIND FIRST rvm_task NO-LOCK
    WHERE rvm_task.task_number = rvm_task_object.task_number
    NO-ERROR.
  IF NOT AVAILABLE rvm_task
  THEN RETURN.
  IF NOT rvm_task.task_workspace BEGINS lv_workspace_code
  THEN RETURN.

  /* Work out new test area being imported into from the 2nd part of the workspace name, after the hyphen e.g. dev, tst, v1x, etc. */
  ASSIGN
    lv_new_area = CAPS(ENTRY(2, lv_current_workspace, "-":U))
    NO-ERROR.
  /* This needs to be reviewed */
  IF LENGTH(lv_new_area) > 3
  THEN
    ASSIGN
      lv_new_area = SUBSTRING(lv_new_area,1,3). /* cope with DEV2 workspace */

  IF lv_new_area BEGINS "D":U THEN ASSIGN lv_new_area = "DEV":U.
  IF lv_new_area BEGINS "T":U THEN ASSIGN lv_new_area = "TST":U.
  IF lv_new_area BEGINS "V":U THEN ASSIGN lv_new_area = "V1X":U.

  IF lv_new_area = "":U
  THEN DO:
    IF VALID-HANDLE(gshSessionManager)
    THEN DO:
      RUN showMessages IN gshSessionManager
                      (INPUT {af/sup2/aferrortxt.i 'AF' '36' '?' '?' "'the Dynamics task statuses'" "'the workspace name does not contain a hyphen'"}
                      ,INPUT "ERR":U
                      ,INPUT "OK":U
                      ,INPUT "OK":U
                      ,INPUT "OK":U
                      ,INPUT "RTB Error"
                      ,INPUT YES
                      ,INPUT ?,
                       OUTPUT cButton).
    END.
    ELSE DO:
      MESSAGE
        "The update of the Dynamics task statuses failed because the workspace name does not contain a hyphen"
        VIEW-AS ALERT-BOX WARNING BUTTONS OK.
    END.
    ASSIGN
      op_error_message = "error":U.
    RETURN.
  END.

  IF NOT CAN-DO("DEV,TST,V1X",lv_new_area)
  THEN DO:
    IF VALID-HANDLE(gshSessionManager)
    THEN DO:
      RUN showMessages IN gshSessionManager
                      (INPUT {af/sup2/aferrortxt.i 'AF' '36' '?' '?' "'the Dynamics task statuses'" "'the part of the workspace name after the hyphen must start with a D, T, or V'"}
                      ,INPUT "ERR":U
                      ,INPUT "OK":U
                      ,INPUT "OK":U
                      ,INPUT "OK":U
                      ,INPUT "RTB Error"
                      ,INPUT YES
                      ,INPUT ?
                      ,OUTPUT cButton).
    END.
    ELSE DO:
      MESSAGE
        "The update of the Dynamics task statuses failed because the part of the workspace name after the hyphen must start with a D, T, or V"
        VIEW-AS ALERT-BOX WARNING BUTTONS OK.
    END.
    ASSIGN
      op_error_message = "error":U.
    RETURN.
  END.

  /*
  Go through all versions of this object and reset their current test area.
  We need to always do this for all objects as following the assign,
  some object versions may now be archived.
  Also, certain object versions may never be included in an import
  because they were modified multiple times before an import was done,
  so will miss this assign hook.
  We reset the test area by allocating an area for the highest workspace this object
  version is currently allocated to - but only looking at workspaces that are are
  associated with the task workspace.
  */
  ASSIGN
    cErrorText = "":U.

  DO FOR lb_rvm_task_object:

    TASK-OBJECT-LOOP:
    FOR EACH lb_rvm_task_object EXCLUSIVE-LOCK
      WHERE lb_rvm_task_object.task_object_name = lv_assign_object_name
      TRANSACTION ON ERROR UNDO TASK-OBJECT-LOOP ,NEXT TASK-OBJECT-LOOP
      :
      ASSIGN
        lv_task_workspace = lv_workspace_code.
      FIND FIRST rvm_task NO-LOCK
        WHERE rvm_task.task_number = lb_rvm_task_object.task_number
        NO-ERROR.
      IF AVAILABLE rvm_task
      THEN
        ASSIGN
          lv_task_workspace = ENTRY(1,rvm_task.task_workspace, "-":U)
          NO-ERROR.
      ASSIGN
        lv_workspaces = "":U.
      FOR EACH rtb_object NO-LOCK
        WHERE rtb_object.pmod       = lb_rvm_task_object.object_product_module
        AND   rtb_object.obj-type   = lb_rvm_task_object.object_type
        AND   rtb_object.object     = lb_rvm_task_object.task_object_name
        AND   rtb_object.version    = lb_rvm_task_object.object_version
        AND   rtb_object.wspace-id  BEGINS lv_task_workspace
        :
        ASSIGN
          lv_workspaces = lv_workspaces
                        + (IF lv_workspaces <> "":U THEN ",":U ELSE "":U)
                        + rtb_object.wspace-id
                        .
      END.

      /* Assign an appropriate test area */        
      IF INDEX(lv_workspaces,"-V":U) > 0
      THEN
        ASSIGN
          lb_rvm_task_object.current_test_area = "V1X":U.
      ELSE
      IF INDEX(lv_workspaces,"-T":U) > 0
      THEN
        ASSIGN
          lb_rvm_task_object.current_test_area = "TST":U.
      ELSE
      IF INDEX(lv_workspaces,"-D":U) > 0
      THEN
        ASSIGN
          lb_rvm_task_object.current_test_area = "DEV":U.
      IF lv_workspaces = "":U
      THEN
        ASSIGN
          lb_rvm_task_object.current_test_area = "ARC":U. /* Archived - superceded by a later version */

      VALIDATE lb_rvm_task_object NO-ERROR.
      {af/sup2/afcheckerr.i &no-return = YES}    
      IF cMessageList <> "":U
      THEN DO:
        ASSIGN
          cErrorText = cMessageList.
        UNDO TASK-OBJECT-LOOP, LEAVE TASK-OBJECT-LOOP.
      END.

    END. /* TASK-OBJECT-LOOP */

  END.

  IF cErrorText <> "":U
  THEN DO:
    IF VALID-HANDLE(gshSessionManager)
    THEN DO:
      RUN showMessages IN gshSessionManager
                      (INPUT cErrorText
                      ,INPUT "ERR":U
                      ,INPUT "OK":U
                      ,INPUT "OK":U
                      ,INPUT "OK":U
                      ,INPUT "RTB Error"
                      ,INPUT YES
                      ,INPUT ?
                      ,OUTPUT cButton).
    END.
    ELSE DO:
      MESSAGE
        cErrorText
        VIEW-AS ALERT-BOX WARNING BUTTONS OK.
    END.
    ASSIGN
      op_error_message = "error":U.
    RETURN.
  END.

  IF lv_new_area = "DEV":U
  THEN RETURN.
  /* do not move task status's when importing into dev area */

  /*
  Next sort out task test areas and statuses. We always check all tasks everytime to be sure.
     1) When importing into a TST workspace, we will only automatically move the status of tasks
        with a test area of DEV and a test status of 3-COM. The test area will move to TST and 
        the status will move to 4-TOT, according to the rules below.
     2) When importing into a V?X workspace, we will only automatically move the status of tasks
        with a test area of TST and a test status of 6-TOK. The test area will move to V1X and 
        the status will stay at 6-TOK, according to the rules below.
     RULES:
     1) If a task is at one of the above valid status's and contains no objects, then its status
        will be moved as explained.
     2) If any objects in the task that have not been manually excluded from an import, are still
        in the DEV area, or when importinging into a V?X workspace are still in the TST area, then 
        do not change the area or status of the task until all objects have been fully moved to the
        correct workspace.
     3) If only some of the objects in a task have been promoted to the next workspace, then the task
        will remain at its old area and status.
  */
  IF lv_new_area = "TST":U
  THEN                             /* assigning into test area T?? */
    ASSIGN
      lv_test_area    = "DEV":U    /* look for dev tasks */
      lv_test_status  = "3-COM":U  /* that are completed */
      lv_new_status   = "4-TOT":U  /* and set status to 4-TOT */
      .
  ELSE                             /* assigning into deployment area V?? */ 
    ASSIGN
      lv_test_area    = "TST":U    /* look for test tasks */
      lv_test_status  = "6-TOK":U  /* that do not contain bugs */
      lv_new_status   = "6-TOK":U  /* and leave status at 6-TOK, just change area */
      .

  TASKS-LOOP:
  FOR EACH rvm_task NO-LOCK
    WHERE rvm_task.current_test_area    = lv_test_area
    AND   rvm_task.current_test_status  = lv_test_status
    AND   rvm_task.task_workspace       BEGINS lv_workspace_code
    :

    ASSIGN
      lv_change_status = NO.
    IF NOT CAN-FIND(FIRST rvm_task_object 
                    WHERE rvm_task_object.task_number = rvm_task.task_number)
    THEN ASSIGN lv_change_status = YES.
    IF lv_change_status = NO
    THEN DO:
      ASSIGN
        lv_change_status = YES.
      FOR EACH rvm_task_object NO-LOCK
        WHERE rvm_task_object.task_number         = rvm_task.task_number
        AND   rvm_task_object.exclude_from_import = NO
        :
        IF rvm_task_object.current_test_area = "DEV":U
        THEN
          ASSIGN
            lv_change_status = NO.   /* objects still in development area */
        IF lv_new_area BEGINS "V":U
        AND rvm_task_object.current_test_area = "TST":U
        THEN
          ASSIGN
            lv_change_status = NO.   /* objects still in test area */
      END.
    END.

    IF lv_change_status = YES
    THEN
    UPDATE-STATUS:
    DO FOR lb_rvm_task TRANSACTION ON ERROR UNDO UPDATE-STATUS, LEAVE UPDATE-STATUS:
      FIND FIRST lb_rvm_task EXCLUSIVE-LOCK
        WHERE ROWID(lb_rvm_task) = ROWID(rvm_task)
        NO-ERROR.
      IF AVAILABLE lb_rvm_task
      THEN DO:
        ASSIGN
          lb_rvm_task.current_test_area   = CAPS(lv_new_area)
          lb_rvm_task.current_test_status = CAPS(lv_new_status)
          .                
        VALIDATE lb_rvm_task NO-ERROR.
        {af/sup2/afcheckerr.i &no-return = YES}    
        IF cMessageList <> "":U
        THEN DO:
          ASSIGN
            cErrorText = cMessageList.
          UNDO UPDATE-STATUS, LEAVE UPDATE-STATUS.
        END.
      END.
    END.

    IF cErrorText <> "":U
    THEN DO:
      IF VALID-HANDLE(gshSessionManager)
      THEN DO:
        RUN showMessages IN gshSessionManager
                        (INPUT cErrorText,
                         INPUT "ERR":U,
                         INPUT "OK":U,
                         INPUT "OK":U,
                         INPUT "OK":U,
                         INPUT "RTB Error",
                         INPUT YES,
                         INPUT ?,
                         OUTPUT cButton).
      END.
      ELSE DO:
        MESSAGE
          cErrorText
          VIEW-AS ALERT-BOX WARNING BUTTONS OK.
      END.
      ASSIGN
        op_error_message = "error":U.
      RETURN.
    END.

  END.

  ASSIGN
    op_error_message = "":U
    NO-ERROR.
  RETURN.
  */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assign-object-before) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assign-object-before Procedure 
PROCEDURE assign-object-before :
/*------------------------------------------------------------------------------
  Purpose:     Before object is assigned
  Parameter :  ip_context       : ""
  / Meaning :  ip_other         : Object name, Object type, Product Module, Version
               op_error_message : non blank will cancel

  Notes:       Set-up object being assigned as after assign hook parameters do not work.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_event            AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_context          AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_other            AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error_message    AS CHARACTER NO-UNDO.

  ASSIGN
    lv_assign_object_name     = ENTRY(1, ip_other)
    lv_assign_object_type     = ENTRY(2, ip_other)
    lv_assign_product_module  = ENTRY(3, ip_other)
    lv_assign_object_version  = ENTRY(4, ip_other)
    .

  RUN scmHookAssignObjectBefore (INPUT grtb-wspace-id
                                ,INPUT grtb-task-num
                                ,INPUT grtb-userid
                                ,INPUT lv_assign_object_name
                                ,INPUT lv_assign_object_type
                                ,INPUT lv_assign_product_module
                                ,INPUT INTEGER(lv_assign_object_version)
                                ,OUTPUT op_error_message
                                ).

  IF op_error_message <> "":U
  THEN RETURN.

  ASSIGN
    op_error_message = "":U
    NO-ERROR.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-before-change-workspace) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE before-change-workspace Procedure 
PROCEDURE before-change-workspace :
/*------------------------------------------------------------------------------
  Purpose:     Before changed workspace
  Parameter :  ip_context       : STRING(Grtb-proc-handle) (main Roundtable procedure handle)
  / Meaning :  ip_other         : String value of the name of the workspace that was selected.
               op_error_message : ignored

  Notes:       This hook should not fire custom code off.

               Nothing happens in this hook apart from shutdown, 
               which happens in rtb_evnt.p.

------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_event            AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_context          AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_other            AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error_message    AS CHARACTER NO-UNDO.

  RUN scmHookBeforeChangeWorkspace (INPUT grtb-wspace-id
                                   ,INPUT ip_other
                                   ,INPUT grtb-userid
                                   ,OUTPUT op_error_message
                                   ).

  IF op_error_message <> "":U
  THEN RETURN.

  ASSIGN
    op_error_message = "":U
    NO-ERROR.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-change-workspace) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE change-workspace Procedure 
PROCEDURE change-workspace :
/*------------------------------------------------------------------------------
  Purpose:     After changed workspace
  Parameter :  ip_context       : STRING(Grtb-proc-handle) (main Roundtable procedure handle)
  / Meaning :  ip_other         : String value of the name of the workspace that was selected.
               op_error_message : ignored

  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_event            AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_context          AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_other            AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error_message    AS CHARACTER NO-UNDO.

  RUN scmHookChangeWorkspace (INPUT grtb-wspace-id
                             ,INPUT ip_other
                             ,INPUT grtb-userid
                             ,OUTPUT op_error_message
                             ).

  IF op_error_message <> "":U
  THEN RETURN.

  ASSIGN
    op_error_message = "":U
    NO-ERROR.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-create-cv) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE create-cv Procedure 
PROCEDURE create-cv :
/*------------------------------------------------------------------------------
  Purpose:     After moved an object to a new product module
  Parameter :  ip_context       : STRING value of RECID of the rtb_object table
  / Meaning :  ip_other         : Object name
               op_error_message : ignored

  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_event            AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_context          AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_other            AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error_message    AS CHARACTER NO-UNDO.

  DEFINE VARIABLE lv_recid                    AS RECID NO-UNDO.

  ASSIGN
    lv_recid = INTEGER(ip_context)
    NO-ERROR.

  FIND FIRST rtb_object NO-LOCK
    WHERE RECID(rtb_object) = lv_recid
    NO-ERROR.
  IF NOT AVAILABLE rtb_object
  OR rtb_object.object <> ip_other
  THEN DO:
    MESSAGE
      "The update of the Dynamics RVDB version data failed as the rtb_object could not be found."
      VIEW-AS ALERT-BOX WARNING BUTTONS OK.
    ASSIGN
      op_error_message = "error":U.
    RETURN.
  END.

  RUN scmHookMoveModule (INPUT grtb-wspace-id
                        ,INPUT grtb-task-num
                        ,INPUT grtb-userid
                        ,INPUT rtb_object.object
                        ,INPUT rtb_object.pmod
                        ,INPUT rtb_object.version
                        ,OUTPUT op_error_message
                        ).

  IF op_error_message <> "":U
  THEN RETURN.

  ASSIGN
    op_error_message = "":U
    NO-ERROR.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-create-cv-before) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE create-cv-before Procedure 
PROCEDURE create-cv-before :
/*------------------------------------------------------------------------------
  Purpose:     Before object is moved to a new module
  Parameter :  ip_context       : ""
  / Meaning :  ip_other         : Object name
               op_error_message : non blank will cancel

  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_event            AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_context          AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_other            AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error_message    AS CHARACTER NO-UNDO.

  RUN scmHookMoveModuleBefore (INPUT grtb-wspace-id
                              ,INPUT grtb-task-num
                              ,INPUT grtb-userid
                              ,INPUT ip_other
                              ,OUTPUT op_error_message
                              ).

  IF op_error_message <> "":U
  THEN RETURN.

  ASSIGN
    op_error_message = "":U
    NO-ERROR.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deploy) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deploy Procedure 
PROCEDURE deploy :
/*------------------------------------------------------------------------------
  Purpose:     After deployment created
  Parameter :  ip_context       : STRING value of RECID of the rtb_site table
  / Meaning :  ip_other         : STRING value of RECID of the rtb_deploy table
               op_error_message : ignored

  Notes:       

          /* ICF-SCM-DEPLOY */  
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER ip_event            AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER ip_context          AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER ip_other            AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error_message    AS CHARACTER NO-UNDO.

  DEFINE VARIABLE lHookContinue AS LOGICAL INITIAL YES NO-UNDO.

  MESSAGE 
    "Do you want to proceed with the Dynamics Deployment Package hooks. These hooks"
    SKIP
    "deal with the selective deployment of Dynamics static data, deployment of ICFDB"
    SKIP
    "repository data for modified dynamic objects, plus RVDB version data if this"
    SKIP
    "is a partner site deployment package."
    SKIP(1)
    "If you elect not to run the Dynamics deployment at this time, or run into problems"
    SKIP
    "and need to re-run it later, then you may use the standalone launch window"
    SKIP
    "rtb/uib/afrtbdepsw.w. Run it from the Roundtable desktop directly or from the"
    SKIP
    "Dynamics menus"
    SKIP(1)
    "Continue with Dynamics Deployment Packaging?"
    SKIP
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
    UPDATE lHookContinue.

  IF lHookContinue
  THEN DO:

    FIND FIRST rtb_site NO-LOCK
      WHERE STRING(RECID(rtb_site)) = ip_context
      NO-ERROR.
    IF NOT AVAILABLE rtb_site
    THEN DO:
      ASSIGN
        op_error_message = "Roundtable Site RECID value not found":U.
      RETURN.
    END.

    FIND FIRST rtb_deploy NO-LOCK
      WHERE STRING(RECID(rtb_deploy)) = ip_other
      NO-ERROR.
    IF NOT AVAILABLE rtb_deploy
    THEN DO:
      ASSIGN
        op_error_message = "Roundtable Deployment RECID value not found":U.
      RETURN.
    END.

    IF rtb_site.site-code <> rtb_deploy.site-code
    OR rtb_site.wspace-id <> rtb_deploy.wspace-id
    THEN DO:
      ASSIGN
        op_error_message = "Roundtable Site and Deployment value discrepencies":U.
      RETURN.
    END.

    /* ICF-SCM-DEPLOY */
    /*
    RUN rtb/uib/afrtbdepsw.w (INPUT ip_context ,INPUT ip_other).
    */

  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deploy-before) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deploy-before Procedure 
PROCEDURE deploy-before :
/*------------------------------------------------------------------------------
  Purpose:     Before deployment created
  Parameter :  ip_context       : STRING value of RECID of the rtb_site table
  / Meaning :  ip_other         : STRING value of RECID of the rtb_deploy table
               op_error_message : non blank will cancel deployment creation

  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_event            AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_context          AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_other            AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error_message    AS CHARACTER NO-UNDO.

  ASSIGN
    op_error_message = "":U
    NO-ERROR.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deploy-site-create) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deploy-site-create Procedure 
PROCEDURE deploy-site-create :
/*------------------------------------------------------------------------------
  Purpose:     After deployment created
  Parameter :  ip_context       : ""
  / Meaning :  ip_other         : Workspace, License Type, Site Code
               op_error_message : logical - false will cancel site creation

  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_event            AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_context          AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_other            AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error_message    AS CHARACTER NO-UNDO.

  ASSIGN
    op_error_message = "":U
    NO-ERROR.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deploy-site-create-before) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deploy-site-create-before Procedure 
PROCEDURE deploy-site-create-before :
/*------------------------------------------------------------------------------
  Purpose:     After deployment created
  Parameter :  ip_context       : ""
  / Meaning :  ip_other         : Workspace, License Type, Site Code
               op_error_message : logical - false will cancel site creation

  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_event            AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_context          AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_other            AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error_message    AS CHARACTER NO-UNDO.

  ASSIGN
    op_error_message = "":U
    NO-ERROR.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ICFSTART_BeforeInitialize) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ICFSTART_BeforeInitialize Procedure 
PROCEDURE ICFSTART_BeforeInitialize :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cSessionTypeRTB       AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE iSessionParamLoop     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cSessionParameters    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSessionParamEntry    AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cSessionDefaultConfig AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSessionDefaultType   AS CHARACTER  NO-UNDO.

  ASSIGN
    cSessionDefaultConfig = "icfconfig.xml":U
    cSessionDefaultType   = "Default":U
    cSessionParameters    = SESSION:ICFPARAM
    .

  blockSessionParam:
  DO iSessionParamLoop = 1 TO NUM-ENTRIES(cSessionParameters):

    ASSIGN
      cSessionParamEntry = ENTRY(iSessionParamLoop, cSessionParameters).

    /* If there are no = or more than one =, this is an invalid parameter, so ignore it. */
    IF NUM-ENTRIES(cSessionParamEntry,"=":U) <> 2
    THEN
      NEXT blockSessionParam.

    IF ENTRY(1,cSessionParamEntry,"=":U) = "ICFCONFIG":U
    THEN
      ASSIGN cSessionDefaultConfig  = ENTRY(2,cSessionParamEntry,"=":U).

    IF ENTRY(1,cSessionParamEntry,"=":U) = "ICFSESSTYPE":U
    THEN
      ASSIGN cSessionDefaultType    = ENTRY(2,cSessionParamEntry,"=":U).

  END.

  IF grtb-wspace-id <> "":U
  THEN
    ASSIGN
      cSessionDefaultType = "rtb_" + REPLACE(grtb-wspace-id,"-","").

  IF cSessionDefaultConfig <> "":U
  THEN
    ASSIGN
      cSessionTypeRTB = "ICFCONFIG=" + cSessionDefaultConfig.

  IF cSessionDefaultType <> "":U
  THEN
    ASSIGN
      cSessionTypeRTB = cSessionTypeRTB + (IF cSessionTypeRTB <> "" THEN "," ELSE "")
                      + "ICFSESSTYPE=" + cSessionDefaultType.

  IF cSessionTypeRTB = "":U
  THEN
    ASSIGN
      cSessionTypeRTB = SESSION:ICFPARAM.

  DYNAMIC-FUNCTION ("setSessionParam":U IN THIS-PROCEDURE, "ICFPARAM":U, cSessionTypeRTB ).

  DYNAMIC-FUNCTION ("setSessionParam":U IN THIS-PROCEDURE, "quit_on_end":U, "NO" ).

  DYNAMIC-FUNCTION ("setSessionParam":U IN THIS-PROCEDURE, "shut_on_end":U, "NO" ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-import) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE import Procedure 
PROCEDURE import :
/*------------------------------------------------------------------------------
  Purpose:     After import
  Parameter :  ip_context       : ""
  / Meaning :  ip_other         : Workspace id
               op_error_message : ignored

  Notes:       The main contents of this hook have been moved to the before-assign hook so
               every movement of an object is captured rather than just via an import.

               This procedure will be run automatically from Roundtable when an import is
               completed. It's purpose is to update task test status's and object test areas.

               Put code in here to move task status's for tasks with no objects.

               This hooks optionally applies any deltas and static RY data.

               /* ICF-SCM-IMPORT */
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_event            AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_context          AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_other            AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error_message    AS CHARACTER NO-UNDO.

  DEFINE VARIABLE cDeltaFile                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFileName                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDBDeltas                   AS CHARACTER EXTENT 20 NO-UNDO.
  DEFINE VARIABLE cRawFile                    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLastDB                     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iPosn                       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLoop                       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iEntry                      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cFileList                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFullList                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDisconnected               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDBList                     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cErrorFile                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cErrorText                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lRYData                     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lDeltas                     AS LOGICAL    NO-UNDO.

  ASSIGN
    op_error_message = "":U
    NO-ERROR.

  MESSAGE
    "Dynamics Notice:"
    SKIP
    "Please remember to print a report of the import table as an audit detailing"
    SKIP
    "what objects were included in the import. Please file the report with the"
    SKIP
    "team in charge of the product workspace"
    SKIP
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.

  ASSIGN
    cLastDB   = "":U
    cFileList = "":U
    cDBList   = "":U
    iEntry    = 0
    lRYData   = NO
    .

  /* get list of deltas included in import */
  import-loop:
  FOR EACH rtb_import NO-LOCK
    WHERE rtb_import.wspace-id  = ip_other
    AND   rtb_import.done       = YES
    :

    IF INDEX(rtb_import.object,"ryactionlp":U) <> 0
    THEN
      ASSIGN
        lRYData = YES.
    IF INDEX(rtb_import.object,".df":U) = 0
    THEN NEXT import-loop.

    FIND FIRST rtb_pmod NO-LOCK
      WHERE rtb_pmod.pmod = rtb_import.pmod
      NO-ERROR.
    IF AVAILABLE rtb_pmod
    THEN
      FIND FIRST rtb_moddef NO-LOCK
        WHERE rtb_moddef.module = rtb_pmod.module
        NO-ERROR.
    IF AVAILABLE rtb_moddef
    THEN
      ASSIGN
        cFileName = TRIM(rtb_moddef.directory,"~/":U)
                  + (IF rtb_moddef.directory = "":U THEN "":U ELSE "~/":U)
                  + rtb_import.object.
    ELSE
      ASSIGN
        cFileName = rtb_import.object.

    ASSIGN
      iPosn = R-INDEX(cFileName,"/":U) + 1.
    IF iPosn = 1
    THEN
      ASSIGN
        iPosn = R-INDEX(cFileName,"~\":U) + 1.
    ASSIGN
      cRawFile = TRIM(LC(SUBSTRING(cFileName,iPosn))).

    IF SUBSTRING(cRawFile,1,4) = cLastDB
    OR cLastDB = "":U
    THEN DO:
      IF cLastDB = "":U
      THEN
        ASSIGN
          cLastDB = SUBSTRING(cRawFile,1,4). /* First time issue */
      ASSIGN
        cFileList = cFileList
                  + (IF cFileList <> "":U THEN ",":U ELSE "":U)
                  + cFileName.
    END.
    ELSE DO: 
      ASSIGN
        iEntry            = iEntry  + 1
        cDBList           = cDBList + (IF iEntry = 1 THEN "":U ELSE ",":U) + cLastDB
        cDBDeltas[iEntry] = cFileList
        cLastDB           = SUBSTRING(cRawFile,1,4)
        cFileList         = cFileName
        .
    END.

  END.

  /* Finish off last one */
  IF cFileList <> "":U
  THEN DO:
    ASSIGN
      iEntry            = iEntry  + 1
      cDBList           = cDBList + (IF iEntry = 1 THEN "":U ELSE ",":U) + cLastDB
      cDBDeltas[iEntry] = cFileList
      cLastDB           = "":U
      cFileList         = "":U
      .    
  END.

  ASSIGN
    cDisconnected = "":U.
  DO iLoop = 1 TO NUM-ENTRIES(cDBList):
    IF NOT CONNECTED(ENTRY(iLoop,cDBList))
    THEN
      ASSIGN
        cDisconnected = cDisconnected + (IF cDisconnected <> "":U THEN ",":U ELSE "":U) + ENTRY(iLoop,cDBList).
    IF INDEX (cDBDeltas[iLoop],"full.df":U) <> 0
    THEN
      ASSIGN
        cFullList = cFullList + (IF cFullList <> "":U THEN ",":U ELSE "":U) + ENTRY(iLoop,cDBList).
  END.

  IF lRYData
  AND NOT CONNECTED("icfdb":U)
  THEN
    ASSIGN
      lRYData = NO.

  /* see if anything to do */
  IF cDbList = "":U
  AND NOT lRYData
  THEN DO:
    ASSIGN
      op_error_message = "":U
      NO-ERROR.
    RETURN.
  END.

  /* ICF-SCM-IMPORT */
  /*
  /* check if new bands and actions to load */
  IF lRYData
  THEN
    MESSAGE
      "The Dynamics Repository standard bands and actions as defined in the program"
      SKIP
      "ryactionlp.p have been modified. Do you want to run this program to delete"
      SKIP
      "all existing bands and actions and recreate the ones in this program."
      SKIP(1)
      "Any customised bands and actions in this workspace repository will be lost."
      SKIP(1)
      "If you do not continue, you should review the differences in this program with"
      SKIP
      "its previous version and manually create the new bands and actions."
      SKIP(1)
      "Continue with rebuild of bands and actions?"
      SKIP(1)
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
      UPDATE lRYData.

  IF lRYData
  THEN DO:
    SESSION:SET-WAIT-STATE("general":U).
    COMPILE VALUE("ry/app/ryactionlp.p":U) SAVE.
    RUN ry/app/ryactionlp.p.
    SESSION:SET-WAIT-STATE("":U).
  END.
  */

  IF cDBList <> "":U
  THEN DO:
    ASSIGN
      lDeltas = YES.
    MESSAGE
      "The import table contained delta files that may need to be applied to the"
      SKIP
      "databases in this workspace. Review the import list to see what deltas were"
      SKIP
      "included. Ensure any databases you are going to apply deltas for are connected"
      SKIP
      "and that no procedures are running that reference them."
      SKIP(1)
      "Also be sure that the deltas in the list are not for common databases or have"
      SKIP
      "not already been applied manually."
      SKIP(1)
      "If you do not want to apply the deltas automatically, then you can use the"
      SKIP
      "database administration tool to apply the deltas later, before doing a"
      SKIP
      "recompile of the workspace."
      SKIP(1)
      "Do you want to automatically apply the deltas included in the import table?"
      SKIP(1)
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
      UPDATE lDeltas.
    IF NOT lDeltas
    THEN DO:
      ASSIGN
        op_error_message = "":U
        NO-ERROR.
      RETURN.
    END.

    IF cDisconnected <> "":U
    THEN DO:
      MESSAGE
        "Cannot automatically apply deltas - the following databases are not connected"
        SKIP(1)
        cDisconnected
        SKIP(1)
        VIEW-AS ALERT-BOX INFORMATION.
      ASSIGN
        op_error_message = "":U
        NO-ERROR.
      RETURN.
    END.

    IF cFullList <> "":U
    THEN
      MESSAGE
        "The following databases have schema changes, but the import table"
        SKIP
        "contains a full Definition File (DF) for them:"
        SKIP(1)
        cFullList
        SKIP(1)
        "You may only proceed with the load of these definition files if your"
        SKIP
        "databases are completely empty and this is a first time import."
        SKIP(1)
        "If this is not a first time import and your databases contain data"
        SKIP
        "then you will need to manually dump your data, apply the schema changes"
        SKIP
        "and reload your data."
        SKIP(1)
        "Do you want to continue with the automatic full schema load?"
        SKIP(1)
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
        UPDATE lDeltas.
    IF NOT lDeltas
    THEN DO:
      MESSAGE
        "Update of deltas aborted."
        VIEW-AS ALERT-BOX INFORMATION.
      ASSIGN
        op_error_message = "":U
        NO-ERROR.
      RETURN.
    END.

    /* Databases connected - process deltas for them in order */
    db-loop:
    DO iLoop = 1 TO NUM-ENTRIES(cDBList):

      CREATE ALIAS DICTDB FOR DATABASE VALUE(ENTRY(iLoop,cDBList)).

      DO iEntry = 1 TO NUM-ENTRIES(cDBDeltas[iLoop]):
        ASSIGN
          cFileName = SEARCH(ENTRY(iEntry,cDBDeltas[iLoop])).

        IF cFileName = ?
        THEN DO:
          MESSAGE
            "Delta load failed."
            SKIP
            "Delta File: " + ENTRY(iEntry,cDBDeltas[iLoop]) + " not found."
            SKIP
            VIEW-AS ALERT-BOX INFORMATION.
          LEAVE db-loop.
        END.

        df-block:
        DO ON STOP UNDO df-block, LEAVE df-block ON ERROR UNDO df-block, LEAVE df-block:
          RUN prodict/load_df.p (INPUT TRIM(cFileName)). 
        END.
      END.
    END.

  END. /* cdblist <> "":U */

  ASSIGN
    op_error_message = "":U
    NO-ERROR.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-import-before) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE import-before Procedure 
PROCEDURE import-before :
/*------------------------------------------------------------------------------
  Purpose:     Before import
  Parameter :  ip_context       : ""
  / Meaning :  ip_other         : Workspace id importing into
               op_error_message : non blank will cancel

  Notes:       This procedure will be run automatically from Roundtable when an import is
               started. It's purpose is to automatically exclude any objects from the import
               that have not been tested or that have been tested and found to contain bugs.
               RULES SUMMARY
               1) Objects included in the import table for tasks with a status of 1-OPN, 2-WIP
                  or 3-COM will be included. The reason to include objects even with a status
                  less than 3-COM is that individual objects may have been checked in for the 
                  task before the task is finished, and need to get through to testing, e.g. 
                  when changing a plip required by somebody else. Care must be taken therefore
                  when checking objects in prematurely as they may not have been tested
                  thoroughly but will still progress to the new workspace. To prevent them
                  from moving, their exclude flag could be set manually before doing the
                  import.
                  Usually this will not be a problem as tasks with these status's will be in
                  the DEV area and the object will be moving into a test area. Once in the test
                  area, it will not be allowed to move further until the full task has been 
                  flagged as tested.
               2) Objects in tasks with a status of 4-TOT or 5-TIP will always be excluded
                  as this task has moved to the test area and is either being tested or
                  waiting to be tested. The results of the test are not yet known for any of
                  the objects, so all objects should be stopped from going any further.
               3) Objects in tasks with a status of 6-TOK, 6-BAS, 6-BUG, or 7-DEP will be included
                  unless their exclude flag is set specifically indicating a bug was found in
                  the specific object.

                /* ICF-SCM-TASK */

------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_event            AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_context          AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_other            AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error_message    AS CHARACTER NO-UNDO.

  /* ICF-SCM-TASK */
  /*

  ASSIGN
    op_error_message = "":U
    NO-ERROR.

  IF NOT CAN-FIND(FIRST rtb_import
                  WHERE rtb_import.wspace-id = ip_other
                  AND   rtb_import.done      = NO)
  THEN RETURN.

  DEFINE VARIABLE lv_new_area                 AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE lv_test_status              AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE lv_choice                   AS LOGICAL INITIAL YES NO-UNDO.
  DEFINE VARIABLE lh_rtbprocp                 AS HANDLE       NO-UNDO.
  DEFINE VARIABLE lv_tnot_rowid               AS ROWID        NO-UNDO.
  DEFINE VARIABLE lv_rejection                AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE lv_old_task                 AS INTEGER      NO-UNDO.

  ASSIGN
    lv_new_area     = CAPS(ENTRY(2, ip_other, "-":U))
    lv_test_status  = "4-TOT,5-TIP":U
    .

  IF LENGTH(lv_new_area) > 3
  THEN
    ASSIGN
      lv_new_area = SUBSTRING(lv_new_area,1,3).  /* cope with DEV2 workspace */

  ASSIGN
    lv_choice = YES.
  MESSAGE
    "Dynamics Enhancement (usually say YES):"
    SKIP(1)
    "Do you wish to automatically exclude any objects in tasks that have not been tested, i.e."
    SKIP
    "have a status of 4-TOT or 5-TIP, plus any objects that have been flagged to contained bugs."
    SKIP(1)
    "If you answer YES, then please ensure you have remembered to update the status of"
    SKIP
    "any tested tasks and flagged any objects with bugs in. If you forget, then objects"
    SKIP
    "may be excluded that should move to the next workspace, or may move to the next workspace"
    SKIP
    "even though they contain bugs"
    SKIP(1)
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
    UPDATE lv_choice.
  IF lv_choice = NO
  THEN DO:
    ASSIGN
      lv_choice = YES.
    MESSAGE
      "Are you really sure you know what you are doing and really do not want the Dynamics enhancement."
      SKIP
      "If you continue with this decision, then objects that have not been tested may get released to site."
      SKIP
      "So, to be sure we will ask again. Do you want to run the Dynamics enhancement to exclude untested objects."
      SKIP
      "You should normally answer YES. Please obtain appropriate authorisation"
      SKIP
      "if you answer NO to this question"
      SKIP(1)
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
      UPDATE lv_choice.
  END.
  IF lv_choice = NO
  THEN RETURN.

  IF NOT VALID-HANDLE(lh_rtbprocp)
  THEN DO:
    ASSIGN
      op_error_message = "error":U.
    MESSAGE "Failed to start plip rtb/prc/afrtbprocp.p"
        VIEW-AS ALERT-BOX INFORMATION.
    RETURN.
  END.

  FOR EACH rtb_import EXCLUSIVE-LOCK
    WHERE rtb_import.wspace-id  = ip_other
    AND   rtb_import.done       = NO
    :

    /* 1st check task status and if not a valid tested status, then set to exclude
       the object from the import
    */
    FIND FIRST rvm_task NO-LOCK
      WHERE rvm_task.task_number = rtb_import.task-num
      NO-ERROR.
    IF AVAILABLE rvm_task
    AND CAN-DO(lv_test_status, rvm_task.current_test_status)
    THEN
      ASSIGN
        rtb_import.imp-status = "EXC":U.

    /* When importing into a deployment workspace, the whole task must
       have been tested for any individual objects to move forward
    */
    IF lv_new_area BEGINS "V"
    AND INTEGER(SUBSTRING(rvm_task.current_test_status,1,1)) < 6
    THEN
      ASSIGN
        rtb_import.imp-status = "EXC":U.

    /* If task not tested ok, then check exclude flag on object and exclude if flag set to 
       YES - indicating the specific object contains a bug and should not move forward.
    */
    IF AVAILABLE rvm_task
    THEN DO:
      IF CAN-FIND(FIRST rvm_task_object
                  WHERE rvm_task_object.task_number       = rtb_import.task-num
                  AND rvm_task_object.task_object_name    = rtb_import.object
                  AND rvm_task_object.object_version      = rtb_import.version
                  AND rvm_task_object.exclude_from_import = YES)
        THEN
          ASSIGN
            rtb_import.imp-status = "EXC":U. 
    END.

  END.
  */

  ASSIGN
    op_error_message = "":U
    NO-ERROR.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-killPlip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE killPlip Procedure 
PROCEDURE killPlip :
/*------------------------------------------------------------------------------
  Purpose:     entry point to instantly kill the plip if it should get lost in memory
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  {ry/app/ryplipkill.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-move-to-web) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE move-to-web Procedure 
PROCEDURE move-to-web :
/*------------------------------------------------------------------------------
  Purpose:     After moved to WEB
  Parameter :  ip_context       : STRING value of RECID of rtb.rtb_object
  / Meaning :  ip_other         : INPUT Object, Obj-Type, Pmod, WS Module
               op_error_message : ignored

  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_event            AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_context          AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_other            AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error_message    AS CHARACTER NO-UNDO.

  ASSIGN
    op_error_message = "":U
    NO-ERROR.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-move-to-web-before) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE move-to-web-before Procedure 
PROCEDURE move-to-web-before :
/*------------------------------------------------------------------------------
  Purpose:     Before move to WEB
  Parameter :  ip_context       : STRING value of RECID of rtb.rtb_object
  / Meaning :  ip_other         : INPUT Object, Obj-Type, Pmod, WS Module
               op_error_message : non blank will cancel

  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_event            AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_context          AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_other            AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error_message    AS CHARACTER NO-UNDO.

  ASSIGN
    op_error_message = "":U
    NO-ERROR.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-object-add) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE object-add Procedure 
PROCEDURE object-add :
/*------------------------------------------------------------------------------
  Purpose:     After object is added
  Parameter :  ip_context       : STRING value of RECID of the rtb_object table
  / Meaning :  ip_other         : Object name
               op_error_message : ignored

  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_event            AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_context          AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_other            AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error_message    AS CHARACTER NO-UNDO.

  RUN scmHookCreateObject (INPUT grtb-wspace-id
                          ,INPUT grtb-task-num
                          ,INPUT grtb-userid
                          ,INPUT ip_other
                          ,OUTPUT op_error_message
                          ).

  IF op_error_message <> "":U
  THEN RETURN.

  ASSIGN
    op_error_message = "":U
    NO-ERROR.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-object-add-before) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE object-add-before Procedure 
PROCEDURE object-add-before :
/*------------------------------------------------------------------------------
  Purpose:     Before object is added
  Parameter :  ip_context       : ""
  / Meaning :  ip_other         : Object name
               op_error_message : non blank will cancel

  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_event            AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_context          AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_other            AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error_message    AS CHARACTER NO-UNDO.

  ASSIGN
    op_error_message = "":U
    NO-ERROR.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-object-check-in) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE object-check-in Procedure 
PROCEDURE object-check-in :
/*------------------------------------------------------------------------------
  Purpose:     After object is checked in
  Parameter :  ip_context       : STRING value of RECID of the rtb_object table
  / Meaning :  ip_other         : Object name
               op_error_message : ignored

  Notes:       When an object is checked in under a task, the object needs to be
               created in the rvm_task_object table to record the test status of
               the specific object.
               This is only required for PCODE type objects, not schema as schema
               changes do not requires specific testing - the programs that use the
               new schema rather get tested.
               We only create records in this table when an object is checked in, as
               until this time we are not interested in the object as the sole purpose
               of this table is to track testing of the object once programming changes
               have been completed. We also will not get cluttered with objects that
               were not changed and were simply deleted from the task.
               We must also fix all object test areas when an object is checked in,
               like an assign, because some will now be archived.

              /* ICF-SCM-TASK */

------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_event            AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_context          AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_other            AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error_message    AS CHARACTER NO-UNDO.

  DEFINE VARIABLE lv_recid                    AS RECID     NO-UNDO.
  DEFINE VARIABLE lv_current_workspace        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lv_workspace_code           AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lv_task_workspace           AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lv_workspaces               AS CHARACTER NO-UNDO.

  DEFINE VARIABLE cButton                     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cErrorText                  AS CHARACTER NO-UNDO.

  ASSIGN
    lv_workspace_code = ENTRY(1,Grtb-wspace-id, "-":U)
    NO-ERROR.

  IF lv_workspace_code = "":U
  THEN DO:
    IF VALID-HANDLE(gshSessionManager)
    THEN DO:
      RUN showMessages IN gshSessionManager
                      (INPUT {af/sup2/aferrortxt.i 'AF' '36' '?' '?' "'the Dynamics task statuses'" "'the workspace name does not contain a hyphen'"}
                      ,INPUT "ERR":U
                      ,INPUT "OK":U
                      ,INPUT "OK":U
                      ,INPUT "OK":U
                      ,INPUT "RTB Error"
                      ,INPUT YES
                      ,INPUT ?
                      ,OUTPUT cButton).
    END.
    ELSE DO:
      MESSAGE
        "The update of the Dynamics task statuses failed because the workspace name does not contain a hyphen"
        VIEW-AS ALERT-BOX WARNING BUTTONS OK.
    END.
    ASSIGN
      op_error_message = "error":U.
    RETURN.
  END.

  ASSIGN
    lv_current_workspace = Grtb-wspace-id
    .

  ASSIGN
    lv_recid = INTEGER(ip_context)
    NO-ERROR.
  FIND FIRST rtb_object NO-LOCK
    WHERE RECID(rtb_object) = lv_recid
    NO-ERROR.
  IF NOT AVAILABLE rtb_object
  OR rtb_object.object <> ip_other
  THEN DO:
    IF VALID-HANDLE(gshSessionManager)
    THEN DO:
      RUN showMessages IN gshSessionManager
                      (INPUT {af/sup2/aferrortxt.i 'AF' '36' '?' '?' "'the Dynamics task statuses'" "'because the rtb_object record could not be found or the wrong object was found from the recid'"}
                      ,INPUT "ERR":U
                      ,INPUT "OK":U
                      ,INPUT "OK":U
                      ,INPUT "OK":U
                      ,INPUT "RTB Error"
                      ,INPUT YES
                      ,INPUT ?
                      ,OUTPUT cButton).
    END.
    ELSE DO:
      MESSAGE
        "The update of the Dynamics task statuses failed because because the rtb_object record could not be found or the wrong object was found from the recid"
        VIEW-AS ALERT-BOX WARNING BUTTONS OK.
    END.
    ASSIGN
      op_error_message = "error":U.
    RETURN.
  END.

  IF rtb_object.obj-type <> "PCODE":U
  THEN RETURN. /* only interested in pcode objects */

  FIND FIRST rtb_ver NO-LOCK
    WHERE rtb_ver.obj-type  = rtb_object.obj-type
    AND   rtb_ver.object    = rtb_object.object
    AND   rtb_ver.pmod      = rtb_object.pmod
    AND   rtb_ver.version   = rtb_object.version
    NO-ERROR.
  IF NOT AVAILABLE rtb_ver
  THEN DO:
    IF VALID-HANDLE(gshSessionManager)
    THEN DO:
      RUN showMessages IN gshSessionManager
                      (INPUT {af/sup2/aferrortxt.i 'AF' '36' '?' '?' "'the Dynamics task statuses'" "'because the rtb_ver record could not be found'"}
                      ,INPUT "ERR":U
                      ,INPUT "OK":U
                      ,INPUT "OK":U
                      ,INPUT "OK":U
                      ,INPUT "RTB Error"
                      ,INPUT YES
                      ,INPUT ?
                      ,OUTPUT cButton).
    END.
    ELSE DO:
      MESSAGE
        "The update of the Dynamics task statuses failed because the rtb_ver record could not be found"
        VIEW-AS ALERT-BOX WARNING BUTTONS OK.
    END.
    ASSIGN
      op_error_message = "error":U.
    RETURN.
  END.

  FIND FIRST rvm_task NO-LOCK
    WHERE rvm_task.task_number = rtb_ver.task-num
    NO-ERROR.
  IF NOT AVAILABLE rvm_task
  THEN DO:
    IF VALID-HANDLE(gshSessionManager)
    THEN DO:
      RUN showMessages IN gshSessionManager
                      (INPUT {af/sup2/aferrortxt.i 'AF' '36' '?' '?' "'the Dynamics task object'" "'because the rvm_task record could not be found'"}
                      ,INPUT "ERR":U
                      ,INPUT "OK":U
                      ,INPUT "OK":U
                      ,INPUT "OK":U
                      ,INPUT "RTB Error"
                      ,INPUT YES
                      ,INPUT ?
                      ,OUTPUT cButton).
    END.
    ELSE DO:
      MESSAGE
        "The update of the Dynamics task object failed because rvm_task record could not be found"
        VIEW-AS ALERT-BOX WARNING BUTTONS OK.
    END.
    ASSIGN
      op_error_message = "error":U.
    RETURN.
  END.

  /* Now we have object details - create / update Dynamics task object table */
  DEFINE BUFFER lb_rvm_task_object FOR rvm_task_object.

  TRANSACTION-BLOCK:
  DO FOR lb_rvm_task_object
    TRANSACTION ON ERROR UNDO TRANSACTION-BLOCK, LEAVE TRANSACTION-BLOCK
    :

    FIND FIRST lb_rvm_task_object EXCLUSIVE-LOCK
      WHERE lb_rvm_task_object.task_number      = rtb_ver.task-num
      AND   lb_rvm_task_object.task_object_name = rtb_object.object
      AND   lb_rvm_task_object.object_version   = rtb_object.version
      NO-ERROR.
    IF NOT AVAILABLE lb_rvm_task_object
    THEN DO:
      CREATE lb_rvm_task_object NO-ERROR.
      {af/sup2/afcheckerr.i &no-return = YES}    
      IF cMessageList <> "":U
      THEN DO:
        ASSIGN
          cErrorText = cMessageList.
        UNDO TRANSACTION-BLOCK, LEAVE TRANSACTION-BLOCK.
      END.
    END.

    ASSIGN
      lb_rvm_task_object.task_number              = rtb_ver.task-num
      lb_rvm_task_object.task_object_name         = rtb_object.object
      lb_rvm_task_object.object_version           = rtb_object.version
      lb_rvm_task_object.object_product_module    = rtb_object.pmod
      lb_rvm_task_object.object_type              = rtb_object.obj-type  
      lb_rvm_task_object.object_description       = rtb_ver.description  
      lb_rvm_task_object.previous_object_version  = rtb_ver.prev-version  
      lb_rvm_task_object.current_test_area        = CAPS(rvm_task.current_test_area)  
      lb_rvm_task_object.test_area_date           = TODAY  
      lb_rvm_task_object.object_test_notes        = "":U  
      lb_rvm_task_object.exclude_from_import      = NO  
      .

    VALIDATE lb_rvm_task_object NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}    
    IF cMessageList <> "":U
    THEN DO:
      ASSIGN
        cErrorText = cMessageList.
      UNDO TRANSACTION-BLOCK, LEAVE TRANSACTION-BLOCK.
    END.

  END.                                              

  IF cErrorText <> "":U
  THEN DO:
    IF VALID-HANDLE(gshSessionManager)
    THEN DO:
      RUN showMessages IN gshSessionManager
                      (INPUT cErrorText
                      ,INPUT "ERR":U
                      ,INPUT "OK":U
                      ,INPUT "OK":U
                      ,INPUT "OK":U
                      ,INPUT "RTB Error"
                      ,INPUT YES
                      ,INPUT ?
                      ,OUTPUT cButton).
    END.
    ELSE DO:
      MESSAGE
        cErrorText
        VIEW-AS ALERT-BOX WARNING BUTTONS OK.
    END.
    ASSIGN
      op_error_message = "error":U.
    RETURN.
  END.

  /* ICF-SCM-TASK */
  /*
  /* Go through all versions of this object and reset their current test area.
     We need to always do this for all objects as following the check-in, some object
     versions may now be archived.
     We reset the test area by allocating an area for the highest workspace this object
     version is currently allocated to - but only looking at workspaces that are are
     associated with the task workspace.
  */

  DO FOR lb_rvm_task_object:

    TASK-OBJECT-LOOP:
    FOR EACH lb_rvm_task_object EXCLUSIVE-LOCK
      WHERE lb_rvm_task_object.task_object_name = rtb_ver.object
      TRANSACTION ON ERROR UNDO TASK-OBJECT-LOOP, NEXT TASK-OBJECT-LOOP:

      ASSIGN
        lv_task_workspace = lv_workspace_code.
      FIND FIRST rvm_task NO-LOCK
        WHERE rvm_task.task_number = lb_rvm_task_object.task_number
      NO-ERROR.
      IF AVAILABLE rvm_task
      THEN
        ASSIGN
          lv_task_workspace = ENTRY(1,rvm_task.task_workspace, "-":U)
          NO-ERROR.

      ASSIGN
        lv_workspaces = "":U.
      FOR EACH rtb_object NO-LOCK
        WHERE rtb_object.pmod       = lb_rvm_task_object.object_product_module
        AND   rtb_object.obj-type   = lb_rvm_task_object.object_type
        AND   rtb_object.object     = lb_rvm_task_object.task_object_name
        AND   rtb_object.version    = lb_rvm_task_object.object_version
        AND   rtb_object.wspace-id  BEGINS lv_task_workspace:
        ASSIGN
          lv_workspaces = lv_workspaces
                        + (IF lv_workspaces <> "":U THEN ",":U ELSE "":U)
                        + rtb_object.wspace-id
                        .
      END.

      /* Assign an appropriate test area */        
      IF INDEX(lv_workspaces,"-V":U) > 0
      THEN
        ASSIGN
          lb_rvm_task_object.current_test_area = "V1X":U.
      ELSE
      IF INDEX(lv_workspaces,"-T":U) > 0
      THEN
        ASSIGN
          lb_rvm_task_object.current_test_area = "TST":U.
      ELSE
      IF INDEX(lv_workspaces,"-D":U) > 0
      THEN
        ASSIGN
          lb_rvm_task_object.current_test_area = "DEV":U.
      IF lv_workspaces = "":U
      THEN
        ASSIGN
          lb_rvm_task_object.current_test_area = "ARC":U. /* Archived - superceded by a later version */

      VALIDATE lb_rvm_task_object NO-ERROR.
      {af/sup2/afcheckerr.i &no-return = YES}    
      IF cMessageList <> "":U
      THEN DO:
        ASSIGN cErrorText = cMessageList.
        UNDO TASK-OBJECT-LOOP, LEAVE TASK-OBJECT-LOOP.
      END.

    END. /* TASK-OBJECT-LOOP */
  END.

  IF cErrorText <> "":U
  THEN DO:
    IF VALID-HANDLE(gshSessionManager)
    THEN DO:
      RUN showMessages IN gshSessionManager
                      (INPUT cErrorText
                      ,INPUT "ERR":U
                      ,INPUT "OK":U
                      ,INPUT "OK":U
                      ,INPUT "OK":U
                      ,INPUT "RTB Error"
                      ,INPUT YES
                      ,INPUT ?
                      ,OUTPUT cButton).
    END.
    ELSE DO:
      MESSAGE
        cErrorText
        VIEW-AS ALERT-BOX WARNING BUTTONS OK.
    END.
    ASSIGN
      op_error_message = "error":U.
    RETURN.
  END.
  */

  ASSIGN
    op_error_message = "":U
    NO-ERROR.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-object-check-in-before) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE object-check-in-before Procedure 
PROCEDURE object-check-in-before :
/*------------------------------------------------------------------------------
  Purpose:     Before object is checked in
  Parameter :  ip_context       : STRING value of RECID of the rtb_object table
  / Meaning :  ip_other         : Object name
               op_error_message : non blank will cancel check in

  Notes:       Do preliminary checking and abort object check in if details 
               cannot be found that will be required after the check in to
               update the Dynamics task object table.
               Belt and braces really !
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_event            AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_context          AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_other            AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error_message    AS CHARACTER NO-UNDO.

  DEFINE VARIABLE lv_recid AS RECID NO-UNDO.

  DEFINE VARIABLE cButton                     AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cErrorText                  AS CHARACTER    NO-UNDO.

  ASSIGN
    lv_recid = INTEGER(ip_context)
    NO-ERROR.

  FIND FIRST rtb_object NO-LOCK
    WHERE RECID(rtb_object) = lv_recid
    NO-ERROR.
  IF NOT AVAILABLE rtb_object
  OR rtb_object.object <> ip_other
  THEN DO:
    IF VALID-HANDLE(gshSessionManager)
    THEN DO:
      RUN showMessages IN gshSessionManager
                      (INPUT {af/sup2/aferrortxt.i 'AF' '36' '?' '?' "'the Dynamics task object'" "'the rtb_object record could not be found or the wrong object was found from the recid'"}
                      ,INPUT "ERR":U
                      ,INPUT "OK":U
                      ,INPUT "OK":U
                      ,INPUT "OK":U
                      ,INPUT "RTB Error"
                      ,INPUT YES
                      ,INPUT ?
                      ,OUTPUT cButton).
    END.
    ELSE DO:
      MESSAGE
        "The update of the Dynamics task object failed because the rtb_object record could not be found or the wrong object was found from the recid"
        VIEW-AS ALERT-BOX WARNING BUTTONS OK.
    END.
    ASSIGN
      op_error_message = "error":U.
    RETURN.
  END.

  IF rtb_object.obj-type <> "PCODE":U
  THEN RETURN. /* only interested in pcode objects */

  FIND FIRST rtb_ver NO-LOCK
    WHERE rtb_ver.obj-type  = rtb_object.obj-type
    AND   rtb_ver.object    = rtb_object.object
    AND   rtb_ver.pmod      = rtb_object.pmod
    AND   rtb_ver.version   = rtb_object.version
    NO-ERROR.
  IF NOT AVAILABLE rtb_ver
  THEN DO:
    IF VALID-HANDLE(gshSessionManager)
    THEN DO:
      RUN showMessages IN gshSessionManager
                      (INPUT {af/sup2/aferrortxt.i 'AF' '36' '?' '?' "'the Dynamics task object'" "'the rtb_ver record could not be found'"}
                      ,INPUT "ERR":U
                      ,INPUT "OK":U
                      ,INPUT "OK":U
                      ,INPUT "OK":U
                      ,INPUT "RTB Error"
                      ,INPUT YES
                      ,INPUT ?
                      ,OUTPUT cButton).
    END.
    ELSE DO:
      MESSAGE
        "The update of the Dynamics task object failed because the rtb_ver record could not be found"
        VIEW-AS ALERT-BOX WARNING BUTTONS OK.
    END.
    ASSIGN
      op_error_message = "error":U.
    RETURN.
  END.

  RUN scmHookCheckInObject (INPUT grtb-wspace-id
                           ,INPUT grtb-task-num
                           ,INPUT grtb-userid
                           ,INPUT ip_other
                           ,OUTPUT op_error_message
                           ).

  IF op_error_message <> "":U
  THEN RETURN.

  ASSIGN
    op_error_message = "":U
    NO-ERROR.

RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-object-check-out) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE object-check-out Procedure 
PROCEDURE object-check-out :
/*------------------------------------------------------------------------------
  Purpose:     After object is checked out
  Parameter :  ip_context       : STRING value of RECID of the rtb_object table
  / Meaning :  ip_other         : Object name
               op_error_message : ignored

  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_event            AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_context          AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_other            AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error_message    AS CHARACTER NO-UNDO.

  DEFINE VARIABLE lv_new_version              AS INTEGER   NO-UNDO.

  DEFINE BUFFER lb_rtb_object FOR rtb_object.

  FIND FIRST lb_rtb_object NO-LOCK
    WHERE RECID(lb_rtb_object) = INTEGER(ip_context)
    NO-ERROR.
  IF AVAILABLE lb_rtb_object
  THEN
    ASSIGN
      lv_new_version = lb_rtb_object.version.
  ELSE
    ASSIGN
      lv_new_version = 999999. /* We have a problem */

  RUN scmHookCheckOutObject (INPUT grtb-wspace-id
                            ,INPUT grtb-task-num
                            ,INPUT grtb-userid
                            ,INPUT ip_other
                            ,INPUT lv_new_version
                            ,OUTPUT op_error_message
                            ).

  IF op_error_message <> "":U THEN RETURN.

  ASSIGN
    op_error_message = "":U
    NO-ERROR.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-object-check-out-before) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE object-check-out-before Procedure 
PROCEDURE object-check-out-before :
/*------------------------------------------------------------------------------
  Purpose:     Before object is checked out
  Parameter :  ip_context       : STRING value of RECID of the rtb_object table
  / Meaning :  ip_other         : Object name
               op_error_message : non blank will cancel

  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_event            AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_context          AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_other            AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error_message    AS CHARACTER NO-UNDO.

  DEFINE VARIABLE lv_new_version              AS INTEGER   NO-UNDO.

  RUN scmHookCheckOutObject (INPUT grtb-wspace-id
                            ,INPUT grtb-task-num
                            ,INPUT grtb-userid
                            ,INPUT ip_other
                            ,INPUT lv_new_version
                            ,OUTPUT op_error_message
                            ).

  IF op_error_message <> "":U THEN RETURN.

  ASSIGN
    op_error_message = "":U
    NO-ERROR.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-object-compile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE object-compile Procedure 
PROCEDURE object-compile :
/*------------------------------------------------------------------------------
  Purpose:     After object is compiled
  Parameter :  ip_context       : STRING value of RECID of the rtb_object table
  / Meaning :  ip_other         : Object name
               op_error_message : ignored

  Notes:       

               /* ICF-SCM-DEPLOY */

------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_event            AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_context          AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_other            AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error_message    AS CHARACTER NO-UNDO.

  /* ICF-SCM-DEPLOY */
  /*
  Removed compile of _cl part of SDO
  RTB91C does this automaically
  
  /* Compile client proxy _cl version of SDO also */
  IF SEARCH("rtb/prc/afcompsdop.p":U) <> ?
  OR SEARCH("rtb/prc/afcompsdop.r":U) <> ?
  THEN DO:
    FIND FIRST rtb_object NO-LOCK
      WHERE RECID(rtb_object) = INTEGER(ip_context)
      NO-ERROR.
    IF AVAILABLE rtb_object
    THEN
      FIND FIRST rtb_ver NO-LOCK
        WHERE rtb_ver.object  = "PCODE":U
        AND   rtb_ver.object  = rtb_object.object
        AND   rtb_ver.pmod    = rtb_object.pmod
        AND   rtb_ver.version = rtb_object.version
        NO-ERROR.
    IF AVAILABLE rtb_ver
    AND AVAILABLE rtb_object
    AND rtb_ver.sub-type = "SDO":U
    THEN DO:
      RUN rtb/prc/afcompsdop.p (INPUT ip_context).
    END.
  END.
  */

  IF SEARCH("rtb/prc/afrtbappsp.p":U) <> ?
  OR SEARCH("rtb/prc/afrtbappsp.r":U) <> ?
  THEN DO:
    RUN rtb/prc/afrtbappsp.p (INPUT INTEGER(ip_context)
                             ,INPUT ip_other
                             ,OUTPUT op_error_message).
  END.

  ASSIGN
    op_error_message = "":U
    NO-ERROR.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-object-compile-before) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE object-compile-before Procedure 
PROCEDURE object-compile-before :
/*------------------------------------------------------------------------------
  Purpose:     Before object is compiled
  Parameter :  ip_context       : STRING value of RECID of the rtb_object table
  / Meaning :  ip_other         : Object name
               op_error_message : non blank will cancel

  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_event            AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_context          AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_other            AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error_message    AS CHARACTER NO-UNDO.

  ASSIGN
    op_error_message = "":U
    NO-ERROR.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-object-delete) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE object-delete Procedure 
PROCEDURE object-delete :
/*------------------------------------------------------------------------------
  Purpose:     After object is deleted
  Parameter :  ip_context       : ""
  / Meaning :  ip_other         : ""
               op_error_message : ignored

  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_event            AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_context          AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_other            AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error_message    AS CHARACTER NO-UNDO.

  ASSIGN
    op_error_message = "":U
    NO-ERROR.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-object-delete-before) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE object-delete-before Procedure 
PROCEDURE object-delete-before :
/*------------------------------------------------------------------------------
  Purpose:     Before object is deleted
  Parameter :  ip_context       : STRING value of RECID of rtb_object table
  / Meaning :  ip_other         : Object name
               op_error_message : non blank will cancel

  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_event            AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_context          AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_other            AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error_message    AS CHARACTER NO-UNDO.

  RUN scmHookDeleteObject (INPUT grtb-wspace-id
                          ,INPUT grtb-task-num
                          ,INPUT grtb-userid
                          ,INPUT ip_other
                          ,OUTPUT op_error_message
                          ).

  IF op_error_message <> "":U
  THEN RETURN.

  ASSIGN
    op_error_message = "":U
    NO-ERROR.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-partner-load) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE partner-load Procedure 
PROCEDURE partner-load :
/*------------------------------------------------------------------------------
  Purpose:     After partner load
  Parameter :  ip_context       : String value of RECID of rtb.rtb_wspace loaded
  / Meaning :  ip_other         : Workspace Path, /* entry 1 is the root path */
               op_error_message : ignored

  Notes:      
  
          /* ICF-SCM-DEPLOY */
  
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_event            AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_context          AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_other            AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error_message    AS CHARACTER NO-UNDO.

  /* ICF-SCM-DEPLOY */
  /*
  DEFINE VARIABLE lContinue AS LOGICAL NO-UNDO.

  ASSIGN
    lContinue = YES.

  MESSAGE "Do you want to continue with the Dynamics partner load hooks" SKIP
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
    UPDATE lContinue.

  IF lContinue
  THEN DO:
    RUN rtb/uib/afdbupdatw.w.
  END.
  */

  ASSIGN
    op_error_message = "":U
    NO-ERROR.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-partner-load-before) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE partner-load-before Procedure 
PROCEDURE partner-load-before :
/*------------------------------------------------------------------------------
  Purpose:     Before partner load
  Parameter :  ip_context       : Potential Workspace ID,   /* no records are created yet */
  / Meaning :  ip_other         : Workspace Path,  /* entry 1 is the root path */
               op_error_message : Cancel load if FALSE

  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_event            AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_context          AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_other            AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error_message    AS CHARACTER NO-UNDO.

  ASSIGN
    op_error_message = "":U
    NO-ERROR.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipSetup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipSetup Procedure 
PROCEDURE plipSetup :
/*------------------------------------------------------------------------------
  Purpose:    Run by main-block of PLIP at startup of PLIP
  Parameters: <none>
  Notes:       
------------------------------------------------------------------------------*/

  {ry/app/ryplipsetu.i}

  /* If versioning database connected, start RV Utility PLIP */
  IF CONNECTED("RVDB":U)
  THEN DO:

    DEFINE VARIABLE cProcName                   AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE hProcHandle                 AS HANDLE       NO-UNDO.

    ASSIGN
      cProcName   = "rtb/prc/rvutlplipp.p":U
      hProcHandle = SESSION:FIRST-PROCEDURE.

    DO WHILE VALID-HANDLE(hProcHandle)
    AND hProcHandle:FILE-NAME <> cProcName
    :
      hProcHandle = hProcHandle:NEXT-SIBLING.
    END.

    IF NOT VALID-HANDLE(hProcHandle)
    THEN
      RUN VALUE(cProcName) PERSISTENT SET hProcHandle.

    THIS-PROCEDURE:ADD-SUPER-PROCEDURE(hProcHandle, SEARCH-TARGET).

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipShutdown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipShutdown Procedure 
PROCEDURE plipShutdown :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will be run just before the calling program 
               terminates
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cProcName                   AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE hValidHanldles              AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hProcHandle                 AS HANDLE       NO-UNDO.

  ASSIGN
    cProcName      = "rtb/prc/rvutlplipp.p":U
    hValidHanldles = SESSION:FIRST-PROCEDURE.

  DO WHILE VALID-HANDLE(hValidHanldles)
  AND NOT (VALID-HANDLE(hProcHandle))
  :

    IF hValidHanldles:PRIVATE-DATA = cProcName
    THEN
      ASSIGN
        hProcHandle = hValidHanldles.

    ASSIGN
      hValidHanldles = hValidHanldles:NEXT-SIBLING.

  END.

  IF VALID-HANDLE(hProcHandle)
  THEN
    RUN killPlip IN hProcHandle.

  {ry/app/ryplipshut.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-process-event) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE process-event Procedure 
PROCEDURE process-event :
/*------------------------------------------------------------------------------
  Purpose:      Event control procedure hook
  Parameters:   ip_event = name of event
                ip_context = event dependant
                ip_other = event dependant
                op_error_message = An error message to display in the event of failure

  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_event            AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_context          AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_other            AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error_message    AS CHARACTER NO-UNDO.

  DEFINE VARIABLE hValidHanldles              AS HANDLE    NO-UNDO.

  ASSIGN
    op_error_message = "":U
    NO-ERROR.

  /*
  DEFINE VARIABLE lv_choice AS LOGICAL NO-UNDO.
  MESSAGE
      SKIP "Event: "   ip_event
      SKIP "Context: " ip_context
      SKIP "Other: "   ip_other
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lv_choice.
  IF lv_choice = NO
  THEN DO:
    ASSIGN
      op_error_message  = "Error".
    RETURN.
  END.
  */

  /* Must we check if plips are running ? */

  IF NOT CONNECTED("ICFDB":U)
  THEN RETURN.

  CASE ip_event:
    WHEN "ASSIGN-OBJECT":U              THEN RUN assign-object              (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "ASSIGN-OBJECT-BEFORE":U       THEN RUN assign-object-before       (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "BEFORE-CHANGE-WORKSPACE":U    THEN RUN before-change-workspace    (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "CHANGE-WORKSPACE":U           THEN RUN change-workspace           (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "CREATE-CV":U                  THEN RUN create-cv                  (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "CREATE-CV-BEFORE":U           THEN RUN create-cv-before           (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "DEPLOY":U                     THEN RUN deploy                     (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "DEPLOY-BEFORE":U              THEN RUN deploy-before              (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "DEPLOY-SITE-CREATE":U         THEN RUN deploy-site-create         (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "DEPLOY-SITE-CREATE-BEFORE":U  THEN RUN deploy-site-create-before  (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "IMPORT":U                     THEN RUN import                     (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "IMPORT-BEFORE":U              THEN RUN import-before              (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "MOVE-TO-WEB":U                THEN RUN move-to-web                (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "MOVE-TO-WEB-BEFORE":U         THEN RUN move-to-web-before         (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "OBJECT-ADD":U                 THEN RUN object-add                 (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "OBJECT-ADD-BEFORE":U          THEN RUN object-add-before          (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "OBJECT-CHECK-IN":U            THEN RUN object-check-in            (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "OBJECT-CHECK-IN-BEFORE":U     THEN RUN object-check-in-before     (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "OBJECT-CHECK-OUT":U           THEN RUN object-check-out           (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "OBJECT-CHECK-OUT-BEFORE":U    THEN RUN object-check-out-before    (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "OBJECT-COMPILE":U             THEN RUN object-compile             (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "OBJECT-COMPILE-BEFORE":U      THEN RUN object-compile-before      (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "OBJECT-DELETE":U              THEN RUN object-delete              (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "OBJECT-DELETE-BEFORE":U       THEN RUN object-delete-before       (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "PARTNER-LOAD":U               THEN RUN partner-load               (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "PARTNER-LOAD-BEFORE":U        THEN RUN partner-load-before        (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "PROPATH-CHANGE":U             THEN RUN propath-change             (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "PROPATH-CHANGE-BEFORE":U      THEN RUN propath-change-before      (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "RELEASE-CREATE":U             THEN RUN release-create             (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "RELEASE-CREATE-BEFORE":U      THEN RUN release-create-before      (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "SCHEMA-UPDATE":U              THEN RUN schema-update              (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "SCHEMA-UPDATE-BEFORE":U       THEN RUN schema-update-before       (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "TASK-CHANGE":U                THEN RUN task-change                (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "TASK-COMPLETE":U              THEN RUN task-complete              (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "TASK-COMPLETE-BEFORE":U       THEN RUN task-complete-before       (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "TASK-CREATE":U                THEN RUN task-create                (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "TASK-CREATE-BEFORE":U         THEN RUN task-create-before         (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "TASK-CREATE-DURING":U         THEN RUN task-create-during         (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
  END CASE.

  /* Try and display a nice formatted error if we can */
  IF op_error_message <> "":U
  AND VALID-HANDLE(gshSessionManager)
  THEN DO:
    DEFINE VARIABLE cButton AS CHARACTER NO-UNDO.
    RUN showMessages IN gshSessionManager
                    (INPUT op_error_message,
                     INPUT "ERR":U,
                     INPUT "OK":U,
                     INPUT "OK":U,
                     INPUT "OK":U,
                     INPUT "RTB Error",
                     INPUT YES,
                     INPUT ?,
                     OUTPUT cButton).
    ASSIGN
      op_error_message = "Failed".
  END.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-propath-change) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE propath-change Procedure 
PROCEDURE propath-change :
/*------------------------------------------------------------------------------
  Purpose:    After propath change
  Parameter : ip_context       : RECID (table depends on context)
  / Meaning : ip_other         : context (see note)
              op_error_message : Cancel load if FALSE

  Notes:      Possible "other" and "context" values include

                  p_other     - BEFORE-COMPILE
                  p_context   - RECID is rtb_object to be compiled.
                                It is not perfect as the workspace path is stripped
                                from the ProPath before this hook is fired.

                  p_other     - AFTER-COMPILE
                  p_context   - RECID is rtb_object that was compiled

                  p_other     - BEFORE-XREF
                  p_context   - RECID is rtb_object that was compiled

                  p_other     - AFTER
                  p_context   - RECID is rtb_object that was compiled

------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_event            AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_context          AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_other            AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error_message    AS CHARACTER NO-UNDO.

  ASSIGN
    op_error_message = "":U
    NO-ERROR.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-propath-change-before) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE propath-change-before Procedure 
PROCEDURE propath-change-before :
/*------------------------------------------------------------------------------
  Purpose:    Before propath change
  Parameter : ip_context       : RECID (table depends on context)
  / Meaning : ip_other         : context (see note)
              op_error_message : Cancel load if FALSE

  Notes:      Possible "other" and "context" values include

                  p_other     - BEFORE-COMPILE
                  p_context   - RECID is rtb_object to be compiled.
                                It is not perfect as the workspace path is stripped
                                from the ProPath before this hook is fired.

                  p_other     - AFTER-COMPILE
                  p_context   - RECID is rtb_object that was compiled

                  p_other     - BEFORE-XREF
                  p_context   - RECID is rtb_object that was compiled

                  p_other     - AFTER
                  p_context   - RECID is rtb_object that was compiled

------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_event            AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_context          AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_other            AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error_message    AS CHARACTER NO-UNDO.

  ASSIGN
    op_error_message = "":U
    NO-ERROR.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-release-create) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE release-create Procedure 
PROCEDURE release-create :
/*------------------------------------------------------------------------------
  Purpose:     After release is created
  Parameter :  ip_context       : ""
  / Meaning :  ip_other         : Workspace id, release number
               op_error_message : ignored

  Notes:       After a release is created in a deployment workspace, set all
               V1X, 6-TOK tasks to V1X, 7-DEP in that workspace, providing the
               current workspace has the same initial characters as the task
               workspace, i.e. if the current workspace s gs-v1x, then the task
               workspace must begin with gs.
               Any errors will be ignored and will not cause the creation of the
               release to fail.

               /* ICF-SCM-TASK */

------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_event            AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_context          AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_other            AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error_message    AS CHARACTER NO-UNDO.

  /* ICF-SCM-TASK */
  /*
  DEFINE VARIABLE lv_workspace_code           AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lv_search_area              AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lv_search_status            AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lv_release_area             AS CHARACTER NO-UNDO.

  DEFINE VARIABLE cButton                     AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cErrorText                  AS CHARACTER    NO-UNDO.

  DEFINE BUFFER lb_rvm_task FOR rvm_task.

  ASSIGN
    lv_release_area = CAPS(ENTRY(2, Grtb-wspace-id, "-":U))
    NO-ERROR.

  ASSIGN
    lv_workspace_code = ENTRY(1,Grtb-wspace-id, "-":U)
    NO-ERROR.

  ASSIGN
    op_error_message = "":U
    NO-ERROR.

  IF lv_workspace_code = "":U
  THEN RETURN.

  IF NOT lv_release_area BEGINS "V":U
  AND lv_workspace_code <> "pc":U
  THEN RETURN.

  /* fudge for pc-dev as it has no tst or v?x workspace */
  IF lv_workspace_code = "pc":U
  THEN
    ASSIGN
      lv_search_area    = "DEV":U
      lv_search_status  = "3-COM":U.
  ELSE
    ASSIGN
      lv_search_area    = "V1X":U
      lv_search_status  = "6-TOK":U.

  FOR EACH rvm_task NO-LOCK
    WHERE rvm_task.current_test_area    BEGINS lv_search_area
    AND   rvm_task.current_test_status  = lv_search_status
    AND   rvm_task.task_workspace       BEGINS lv_workspace_code
    :

    /* update task status to 7-DEP */
    TRANSACTION-BLOCK:
    DO FOR lb_rvm_task
      TRANSACTION ON ERROR UNDO TRANSACTION-BLOCK, LEAVE TRANSACTION-BLOCK
      :
      FIND FIRST lb_rvm_task EXCLUSIVE-LOCK 
        WHERE ROWID(lb_rvm_task) = ROWID(rvm_task)
        NO-ERROR.
      IF AVAILABLE lb_rvm_task
      THEN DO:
        ASSIGN
          lb_rvm_task.current_test_status = "7-DEP":U.

        VALIDATE lb_rvm_task NO-ERROR.
        {af/sup2/afcheckerr.i &no-return = YES}    
        IF cMessageList <> "":U THEN
        DO:
          ASSIGN cErrorText = cMessageList.
          UNDO TRANSACTION-BLOCK, LEAVE TRANSACTION-BLOCK.
        END.

        RELEASE lb_rvm_task.
      END.
    END.
  END.

  IF cErrorText <> "":U
  THEN DO:
    IF VALID-HANDLE(gshSessionManager)
    THEN DO:
      RUN showMessages IN gshSessionManager
                      (INPUT cErrorText
                      ,INPUT "ERR":U
                      ,INPUT "OK":U
                      ,INPUT "OK":U
                      ,INPUT "OK":U
                      ,INPUT "RTB Error"
                      ,INPUT YES
                      ,INPUT ?
                      ,OUTPUT cButton).
    END.
    ELSE DO:
      MESSAGE
        cErrorText
        VIEW-AS ALERT-BOX WARNING BUTTONS OK.
    END.

    ASSIGN
      op_error_message = "error":U.
    RETURN.

  END.
  */

  ASSIGN
    op_error_message = "":U.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-release-create-before) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE release-create-before Procedure 
PROCEDURE release-create-before :
/*------------------------------------------------------------------------------
  Purpose:     Before release is created
  Parameter :  ip_context       : ""
  / Meaning :  ip_other         : Workspace id
               op_error_message : non blank will cancel

  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_event            AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_context          AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_other            AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error_message    AS CHARACTER NO-UNDO.

  ASSIGN
    op_error_message = "":U
    NO-ERROR.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-schema-update) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE schema-update Procedure 
PROCEDURE schema-update :
/*------------------------------------------------------------------------------
  Purpose:     Update Schema
  Parameter :  ip_context       : "" 
               ip_other         : Workspace id 
               op_error_message : Ignored

  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_event            AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_context          AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_other            AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error_message    AS CHARACTER NO-UNDO.

  ASSIGN
    op_error_message = "":U
    NO-ERROR.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-schema-update-before) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE schema-update-before Procedure 
PROCEDURE schema-update-before :
/*------------------------------------------------------------------------------
  Purpose:     Update Schema Before
  Parameter :  ip_context       : "" 
               ip_other         : Workspace id 
               op_error_message : non blank will cancel (logical - false will cancel schema update)

  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_event            AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_context          AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_other            AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error_message    AS CHARACTER NO-UNDO.

  ASSIGN
    op_error_message = "":U
    NO-ERROR.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-task-change) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE task-change Procedure 
PROCEDURE task-change :
/*------------------------------------------------------------------------------
  Purpose:     After changed task
  Parameter :  ip_context       : STRING(Grtb-proc-handle) (main Roundtable procedure handle)
  / Meaning :  ip_other         : String value of the task that was selected.
               op_error_message : ignored

  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_event            AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_context          AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_other            AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error_message    AS CHARACTER NO-UNDO.

  RUN scmHookChangeTask (INPUT grtb-wspace-id
                        ,INPUT ip_other
                        ,INPUT grtb-userid
                        ,OUTPUT op_error_message
                        ).

  IF op_error_message <> "":U THEN RETURN.

  ASSIGN
    op_error_message = "":U
    NO-ERROR.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-task-complete) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE task-complete Procedure 
PROCEDURE task-complete :
/*------------------------------------------------------------------------------
  Purpose:     After task completed
  Parameter :  ip_context       : ""
  / Meaning :  ip_other         : task number
               op_error_message : ignored

  Notes:       Update test status of Dynamics task to 3-COM if a DEV task or 4-TOT
               if not a DEV task.
               The roundtable write trigger will update the actual task status
               and completed date.
               The Dynamics write trigger will update the task history with the
               new test area details.

              /* ICF-SCM-TASK */

------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_event            AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_context          AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_other            AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error_message    AS CHARACTER NO-UNDO.

  DEFINE VARIABLE cButton                     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cErrorText                  AS CHARACTER NO-UNDO.

  FIND FIRST rtb_task NO-LOCK
    WHERE rtb_task.task-num = INTEGER(ip_other)
    NO-ERROR.

  /* Ensure completion worked ok and they did not cancel due to errors */
  IF NOT AVAILABLE rtb_task
  OR rtb_task.task-status = "w":U
  THEN RETURN.

  /* ICF-SCM-TASK */
  /*
  /* New procedure for changing task status */
  DEFINE VARIABLE lv_current_area             AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lv_current_status           AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lv_new_area                 AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lv_new_status               AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lh_rtbprocp                 AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lv_tnot_rowid               AS ROWID     NO-UNDO.
  DEFINE VARIABLE lv_rejection                AS CHARACTER NO-UNDO.

  DEFINE BUFFER lb_rvm_task FOR rvm_task.
  
  TRANSACTION-BLOCK:
  DO FOR lb_rvm_task
    TRANSACTION ON ERROR UNDO TRANSACTION-BLOCK, LEAVE TRANSACTION-BLOCK
    :
    FIND FIRST lb_rvm_task EXCLUSIVE-LOCK
      WHERE lb_rvm_task.task_number = INTEGER(ip_other)
      NO-ERROR.
    IF NOT AVAILABLE lb_rvm_task
    THEN DO:
      IF VALID-HANDLE(gshSessionManager)
      THEN DO:
        RUN showMessages IN gshSessionManager
                        (INPUT {af/sup2/aferrortxt.i 'AF' '36' '?' '?' "'the Dynamics task status to complete'" "'the rvm_task record could not be found'"},
                         INPUT "ERR":U,
                         INPUT "OK":U,
                         INPUT "OK":U,
                         INPUT "OK":U,
                         INPUT "RTB Error",
                         INPUT YES,
                         INPUT ?,
                         OUTPUT cButton).
      END.
      ELSE DO:
        MESSAGE
          "The update of the Dynamics task status to complete failed because the rvm_task record could not be found"
          VIEW-AS ALERT-BOX WARNING BUTTONS OK.
      END.
      ASSIGN
        op_error_message = "error":U.
      RETURN.
    END.

    /* Only need to change status here - trigger will update history
       Also, Roundtable write trigger will update the rvm_task status to complete "C" and
       give it a completed date
    */
    ASSIGN
      lb_rvm_task.current_test_area   = (IF lb_rvm_task.current_test_area <> "":U    THEN lb_rvm_task.current_test_area ELSE "DEV":U)
      lb_rvm_task.current_test_status = (IF lb_rvm_task.current_test_area <> "DEV":U THEN "4-TOT":U                     ELSE "3-COM":U)
      lb_rvm_task.task_status         = "C":U
      .

    VALIDATE lb_rvm_task NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}    
    IF cMessageList <> "":U
    THEN DO:
      ASSIGN
        cErrorText = cMessageList.
      UNDO TRANSACTION-BLOCK, LEAVE TRANSACTION-BLOCK.
    END.

  END.

  IF cErrorText <> "":U
  THEN DO:
    IF VALID-HANDLE(gshSessionManager)
    THEN DO:
      RUN showMessages IN gshSessionManager
                      (INPUT cErrorText
                      ,INPUT "ERR":U
                      ,INPUT "OK":U
                      ,INPUT "OK":U
                      ,INPUT "OK":U
                      ,INPUT "RTB Error"
                      ,INPUT YES
                      ,INPUT ?
                      ,OUTPUT cButton).
    END.
    ELSE DO:
      MESSAGE
        cErrorText
        VIEW-AS ALERT-BOX WARNING BUTTONS OK.
    END.
    ASSIGN
      op_error_message = "error":U.
    RETURN.
  END.
  */

  ASSIGN
    op_error_message = ""
    NO-ERROR.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-task-complete-before) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE task-complete-before Procedure 
PROCEDURE task-complete-before :
/*------------------------------------------------------------------------------
  Purpose:     Before task is completed
  Parameter :  ip_context       : ""
  / Meaning :  ip_other         : task number
               op_error_message : non blank will cancel

  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_event            AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_context          AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_other            AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error_message    AS CHARACTER NO-UNDO.

  RUN scmHookCompleteTask (INPUT grtb-wspace-id
                          ,INPUT INTEGER(ip_other)
                          ,INPUT grtb-userid
                          ,OUTPUT op_error_message
                          ).

  IF op_error_message <> "":U
  THEN RETURN.

  ASSIGN
    op_error_message = "":U
    NO-ERROR.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-task-create) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE task-create Procedure 
PROCEDURE task-create :
/*------------------------------------------------------------------------------
  Purpose:     After task created - but no details entered yet
  Parameter :  ip_context       : ""
  / Meaning :  ip_other         : ""
               op_error_message : ignored

  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_event            AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_context          AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_other            AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error_message    AS CHARACTER NO-UNDO.

  ASSIGN
    op_error_message = "":U
    NO-ERROR.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-task-create-before) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE task-create-before Procedure 
PROCEDURE task-create-before :
/*------------------------------------------------------------------------------
  Purpose:     Before task is created
  Parameter :  ip_context       : ""
  / Meaning :  ip_other         : Workspace id
               op_error_message : non blank will cancel

  Notes:       Tried to put a warning in here, but this event fires even if we
               are creating a task from Dynamics.

               /* ICF-SCM-TASK */

------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_event            AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_context          AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_other            AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error_message    AS CHARACTER NO-UNDO.

  /* ICF-SCM-TASK */
  /*
  MESSAGE
    "You should NOT be creating a task from here - rather use the "
    SKIP
    "Dynamics task creation which allows the entry of additional details."
    SKIP(1)
    "If you continue, an Dynamics task will also be created automatically"
    SKIP
    "and you will need to revisit the task created in Dynamics to add the"
    SKIP
    "extra details."
    SKIP(1)
    "Continue despite the warning?"
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
    UPDATE lv_choice AS LOGICAL.
    IF lv_choice = YES
    THEN
      ASSIGN
        op_error_message = "":U
        NO-ERROR.
    ELSE
      ASSIGN
        op_error_message = "error":U
        NO-ERROR.
  */

  ASSIGN
    op_error_message = "":U. 
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-task-create-during) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE task-create-during Procedure 
PROCEDURE task-create-during :
/*------------------------------------------------------------------------------
  Purpose:     During task create
  Parameter :  ip_context       : String value of RECID of rtb.rtb_task 
               ip_other         : Task number in GUI - Wspace-id in TTY 
               op_error_message : Ignored

  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_event            AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_context          AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_other            AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error_message    AS CHARACTER NO-UNDO.

  ASSIGN
    op_error_message = "":U
    NO-ERROR.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-isLogicalObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isLogicalObject Procedure 
FUNCTION isLogicalObject RETURNS LOGICAL
  ( ip_object AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: To check whether the passed in object is a logical object
    Notes: For now, we will assume the following ...
            1. The subtype has only one part which has a .ado extention
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lReturnValue AS LOGICAL NO-UNDO.

  ASSIGN
    lReturnValue = FALSE.

  FIND FIRST rtb_ver NO-LOCK
    WHERE rtb_ver.obj-type = "PCODE":U
    AND   rtb_ver.object   = ip_object
    NO-ERROR.
  IF AVAILABLE rtb_ver
  THEN DO:
    FIND FIRST rtb_subtype NO-LOCK
      WHERE rtb_subtype.obj-type = rtb_ver.obj-type
      AND   rtb_subtype.sub-type = rtb_ver.sub-type
      NO-ERROR.
    IF AVAILABLE rtb_subtype
    AND rtb_subtype.part[1]  <> "":U AND rtb_subtype.part-ext[1]  = "ado":U
    AND rtb_subtype.part[2]  =  "":U AND rtb_subtype.part-ext[2]  = "":U
    AND rtb_subtype.part[3]  =  "":U AND rtb_subtype.part-ext[3]  = "":U
    AND rtb_subtype.part[4]  =  "":U AND rtb_subtype.part-ext[4]  = "":U
    AND rtb_subtype.part[5]  =  "":U AND rtb_subtype.part-ext[5]  = "":U
    AND rtb_subtype.part[6]  =  "":U AND rtb_subtype.part-ext[6]  = "":U
    AND rtb_subtype.part[7]  =  "":U AND rtb_subtype.part-ext[7]  = "":U
    AND rtb_subtype.part[8]  =  "":U AND rtb_subtype.part-ext[8]  = "":U
    AND rtb_subtype.part[9]  =  "":U AND rtb_subtype.part-ext[9]  = "":U
    AND rtb_subtype.part[10] =  "":U AND rtb_subtype.part-ext[10] = "":U
    THEN
      ASSIGN
        lReturnValue = TRUE.
    ELSE
      ASSIGN
        lReturnValue = FALSE.
  END.
  ELSE
    ASSIGN
      lReturnValue = FALSE.

  RETURN lReturnValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

