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
  File: afrtbimptp.p

  Description:  RTB import hook

  Purpose:      This procedure will be run automatically from Roundtable when an import is
                completed. It's purpose is to update task status's

  Parameters:   ip_workspace = The RTB workspace
                op_error_message = An error message to display in the event of failure

  History:
  --------
  (v:010000)    Task:        1687   UserRef:    
                Date:   19/07/1999  Author:     Anthony Swindells

  Update Notes: Created from Template aftemprocp.p

  (v:010002)    Task:        3168   UserRef:    
                Date:   14/10/1999  Author:     Anthony Swindells

  Update Notes: Fix task note status problems. Cure problems of tasks dissappearing, plus
                status's getting changed incorrectly, i.e. moving back to dev, etc. plus area
                being set to DEV2.

  (v:010003)    Task:        3188   UserRef:    
                Date:   15/10/1999  Author:     Anthony Swindells

  Update Notes: Test test procedures, not moving notes to v1x

  (v:010004)    Task:        3196   UserRef:    
                Date:   15/10/1999  Author:     Anthony Swindells

  Update Notes: Remove user acceptance test option

  (v:010005)    Task:        3363   UserRef:    
                Date:   01/11/1999  Author:     Anthony Swindells

  Update Notes: Task testing mods for character workspaces.
                Workspace pc-dev has no tst or v?x so auto-set status to 6-tot when task
                imported into dev.

  (v:010006)    Task:        3681   UserRef:    
                Date:   23/11/1999  Author:     Pieter Meyer

  Update Notes: Correct rtb trigger for task control

  (v:010001)    Task:    90000067   UserRef:    
                Date:   25/04/2001  Author:     Anthony Swindells

  Update Notes: Remove RTB dependancy, so code does not break if RTB not connected / in use.

-----------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afrtbimptp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010001


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

DEFINE INPUT PARAMETER  ip_workspace        AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER op_error_message    AS CHARACTER NO-UNDO.

{af/sup/afproducts.i}

{rtb/inc/afrtbglobs.i} /* pull in Roundtable global variables */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



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
         HEIGHT             = 12
         WIDTH              = 43.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

ASSIGN op_error_message = "":U NO-ERROR.

IF NOT CAN-FIND(FIRST rtb_import WHERE rtb_import.wspace-id = ip_workspace AND rtb_import.done = YES) THEN RETURN.

DEFINE VARIABLE lv_new_area                         AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lv_new_status                       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lv_choice                           AS LOGICAL INITIAL YES NO-UNDO.
DEFINE VARIABLE lh_rtbprocp                         AS HANDLE       NO-UNDO.
DEFINE VARIABLE lv_tnot_rowid                       AS ROWID        NO-UNDO.
DEFINE VARIABLE lv_rejection                        AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lv_task                             AS INTEGER      NO-UNDO.
DEFINE VARIABLE lv_loop                             AS INTEGER      NO-UNDO.
DEFINE VARIABLE lv_task_list                        AS CHARACTER    NO-UNDO.

ASSIGN
    lv_new_area = CAPS(ENTRY(2, ip_workspace, "-":U))
    lv_new_status = "4-TOT":U
    .

IF LENGTH(lv_new_area) > 3 THEN
  ASSIGN lv_new_area = SUBSTRING(lv_new_area,1,3).  /* cope with DEV2 workspace */

/* Normally leave status alone if importing into a dev workspace, unless importing from 
   pc-dev which is the character print spooler - as this has no tst or v1x workspaces,
   so the status must move to 6-tok
*/
IF lv_new_area BEGINS "D":U AND
  NOT CAN-FIND(FIRST rtb_import
               WHERE rtb_import.src-wspace-id = "pc-dev":U) THEN RETURN.

IF lv_new_area BEGINS "D":U AND
  CAN-FIND(FIRST rtb_import
           WHERE rtb_import.src-wspace-id = "pc-dev":U) THEN
    ASSIGN lv_new_status = "6-TOK":U.

IF lv_new_area BEGINS "V":U THEN
  DO:

/*    MESSAGE "Are you performing user acceptance testing in the deployment workspace ?" SKIP(1)
 *             "If you answer YES to this question, then the status of the tasks" SKIP
 *             "being imported will be set to 4-TOT rather than 6-TOK indicating" SKIP
 *             "further testing is required in the deployment workspace before deployment" SKIP
 *             "can be done. If you answer NO to this question, the tasks being" SKIP
 *             "imported will be flagged as 6-TOK, testing complete." SKIP
 *             VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lv_choice.
 *     IF lv_choice = NO THEN */

        ASSIGN lv_new_status = "6-TOK":U.

  END.

RUN rtb/prc/afrtbprocp.p PERSISTENT SET lh_rtbprocp.
IF NOT VALID-HANDLE(lh_rtbprocp) THEN
  DO:
    ASSIGN op_error_message = "Failed to start plip rtb/prc/afrtbprocp.p".
    MESSAGE op_error_message
        VIEW-AS ALERT-BOX ERROR.
    RETURN.
  END.

ASSIGN
    lv_task_list = "":U
    .

/* go through each object in import list that was imported */
OBJECT-LOOP:
FOR EACH rtb_import NO-LOCK
   WHERE rtb_import.wspace-id = ip_workspace
     AND rtb_import.done = YES:

    /* loop through current and previous object versions to check task status 
       and move if necessary
    */

    FOR EACH rtb_ver NO-LOCK
       WHERE rtb_ver.obj-type = rtb_import.obj-type
         AND rtb_ver.object   = rtb_import.object
         AND rtb_ver.pmod     = rtb_import.pmod
         AND rtb_ver.version <= rtb_import.version
         :
      IF LOOKUP(STRING(rtb_ver.task-num), lv_task_list) = 0
      THEN
        ASSIGN
          lv_task_list = lv_task_list + (IF lv_task_list = "":U THEN "":U ELSE ",":U)
                                      + STRING(rtb_ver.task-num).  
    END. 

    TASK-LOOP:
    DO lv_loop = 1 TO NUM-ENTRIES(lv_task_list):

        ASSIGN
            lv_task = INTEGER(ENTRY(lv_loop, lv_task_list)).

        /* Ignore task if WIP */
        FIND FIRST rtb_task NO-LOCK
             WHERE rtb_task.task-num = lv_task
             NO-ERROR.
        IF AVAILABLE rtb_task AND rtb_task.compltd-when = ? THEN NEXT TASK-LOOP.

        FIND FIRST rtb_tnot NO-LOCK
             WHERE rtb_tnot.task-num  = lv_task
               AND rtb_tnot.note-type = "":U
               AND rtb_tnot.obj-type  = "pcode":U
             NO-ERROR.

        IF NOT AVAILABLE rtb_tnot THEN NEXT TASK-LOOP.      
        IF lv_new_area BEGINS "T" AND NOT (rtb_tnot.object BEGINS "3":U) THEN NEXT TASK-LOOP.

        /* This next line may still be a problem for previous object version tasks */
        IF lv_new_area BEGINS "V" AND INTEGER(SUBSTRING(rtb_tnot.object,1,1)) < 6 AND lv_task = rtb_import.task-num THEN NEXT TASK-LOOP.
        IF (NOT (lv_new_status BEGINS "4":U)) AND lv_new_area = rtb_tnot.pmod
           AND NOT CAN-FIND(FIRST rtb_import WHERE rtb_import.src-wspace-id = "pc-dev":U) THEN NEXT TASK-LOOP.
        IF CAN-FIND(FIRST rtb_import WHERE rtb_import.src-wspace-id = "pc-dev":U) 
           AND rtb_tnot.object BEGINS "6":U THEN NEXT TASK-LOOP. /* Only need to do once */

        RUN rtb-change-status-control IN lh_rtbprocp
                                       ( INPUT lv_task
                                        ,INPUT grtb-userid
                                        ,INPUT lv_new_area
                                        ,INPUT IF (lv_new_status BEGINS "4":U OR CAN-FIND(FIRST rtb_import WHERE rtb_import.src-wspace-id = "pc-dev":U)) THEN lv_new_status ELSE rtb_tnot.object 
                                        ,OUTPUT lv_tnot_rowid
                                        ,OUTPUT lv_rejection).
        IF lv_rejection <> "":U THEN LEAVE TASK-LOOP.
    END.    
    IF lv_rejection <> "":U THEN LEAVE OBJECT-LOOP.

END.

IF VALID-HANDLE( lh_rtbprocp ) THEN DELETE PROCEDURE lh_rtbprocp.
IF lv_rejection <> "":U THEN
  DO:
    ASSIGN op_error_message = "Change of task status failed because: " + lv_rejection. 
    MESSAGE op_error_message
      VIEW-AS ALERT-BOX ERROR.
  END.

RETURN.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


