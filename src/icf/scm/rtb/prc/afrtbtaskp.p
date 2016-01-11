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
  File: afrtbtaskp.p

  Description:  Load Program for Roundtable Tasks

  Purpose:      Load Program for Roundtable Tasks - to create task information in
                ICFDB database.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        4043   UserRef:    
                Date:   20/12/1999  Author:     Anthony Swindells

  Update Notes: Task test procedures - use new ICFDB tables

  (v:010001)    Task:    90000067   UserRef:    
                Date:   25/04/2001  Author:     Anthony Swindells

  Update Notes: Remove RTB dependancy, so code does not break if RTB not connected / in use.

--------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afrtbtaskp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010001


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

{af/sup/afproducts.i}

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
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEFINE VARIABLE lv_loop                             AS INTEGER      NO-UNDO.
DEFINE VARIABLE lv_workspaces                       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lv_task_workspace                   AS CHARACTER    NO-UNDO.

/* Loop around every task and create if it is not in our tables / update if it is */
FOR EACH rtb_task NO-LOCK:

  ASSIGN lv_task_workspace = "":U NO-ERROR.
  ASSIGN
      lv_task_workspace = ENTRY(1,rtb_task.wspace-id, "-":U)
      NO-ERROR.
  IF lv_task_workspace = "lrps2":U THEN ASSIGN lv_task_workspace = "lrps":U. /* fudge */

  /* 1st create / update rvm_task task records */
  FIND FIRST rvm_task EXCLUSIVE-LOCK
       WHERE rvm_task.task_number = rtb_task.task-num
       NO-ERROR.
  IF NOT AVAILABLE rvm_task THEN
    CREATE rvm_task.

  ASSIGN
    rvm_task.task_number = rtb_task.task-num
    rvm_task.task_workspace = LC(rtb_task.wspace-id)
    rvm_task.task_manager = rtb_task.manager
    rvm_task.task_programmer = rtb_task.programmer
    rvm_task.task_status = CAPS(rtb_task.task-status)
    rvm_task.task_entered_date = rtb_task.entered-when
    rvm_task.task_completed_date = rtb_task.compltd-when
    rvm_task.task_user_reference = rtb_task.user-task-ref
    rvm_task.task_summary = rtb_task.summary
    rvm_task.task_description = "":U
    .
  DO lv_loop = 1 TO 15:
    IF LENGTH(rtb_task.description[lv_loop]) > 0 THEN
      ASSIGN rvm_task.task_description = rvm_task.task_description +
                                         IF LENGTH(rvm_task.task_description) > 0 THEN CHR(10) ELSE "":U +
                                         rtb_task.description[lv_loop].
  END.
  IF LENGTH(rvm_task.task_description) = 0 THEN
    ASSIGN rvm_task.task_description = rvm_task.task_summary.

  FIND FIRST rtb_tnot NO-LOCK
       WHERE rtb_tnot.task-num = rtb_task.task-num
         AND rtb_tnot.obj-type = "pcode":U
       NO-ERROR.
  IF AVAILABLE rtb_tnot THEN
    DO:
      ASSIGN
        rvm_task.current_test_area = rtb_tnot.pmod
        rvm_task.current_test_status = rtb_tnot.object 
        rvm_task.test_status_date = rtb_tnot.entered-when
        rvm_task.test_status_user = rtb_tnot.user-name
        rvm_task.task_priority = 99
        rvm_task.estimated_hrs = rtb_tnot.est-hours
        rvm_task.actual_hrs = rtb_tnot.act-hours
        .
    END.
  ELSE
    DO:
      ASSIGN
        rvm_task.current_test_area = IF rtb_task.task-status = "w":U THEN "DEV":U ELSE "V1X":U
        rvm_task.current_test_status = IF rtb_task.task-status = "w":U THEN "1-OPN":U ELSE "7-DEP":U
        rvm_task.test_status_date = rtb_task.entered-when
        rvm_task.test_status_user = rtb_task.programmer
        rvm_task.task_priority = 99
        rvm_task.estimated_hrs = 0
        rvm_task.actual_hrs = 0
        .
    END.

  /* Change any v2x, etc. status's to V1X and remove duff status's */
  IF rvm_task.current_test_area BEGINS "D":U THEN ASSIGN rvm_task.current_test_area = "DEV":U.
  IF rvm_task.current_test_area BEGINS "T":U THEN ASSIGN rvm_task.current_test_area = "TST":U.
  IF rvm_task.current_test_area BEGINS "V":U THEN ASSIGN rvm_task.current_test_area = "V1X":U.
  IF rvm_task.current_test_area = "DEV":U AND INTEGER(SUBSTRING(rvm_task.current_test_status,1,1)) > 3 
     AND rvm_task.task_workspace <> "pc-dev":U THEN
    ASSIGN rvm_task.current_test_status = "3-COM":U.
  IF rvm_task.current_test_area = "TST":U AND rvm_task.current_test_status = "3-COM":U THEN
    ASSIGN rvm_task.current_test_status = "6-TOK":U.
  IF rvm_task.current_test_area = "V1X":U AND rvm_task.current_test_status = "3-COM":U THEN
    ASSIGN rvm_task.current_test_status = "6-TOK":U.
  IF rvm_task.current_test_status = "7-BAS" THEN
    ASSIGN rvm_task.current_test_status = "6-BAS":U.
  IF rvm_task.current_test_area = "TST":U AND INTEGER(SUBSTRING(rvm_task.current_test_status,1,1)) > 6 THEN
    ASSIGN rvm_task.current_test_status = "6-TOK":U.
  IF rvm_task.current_test_area = "V1X":U AND INTEGER(SUBSTRING(rvm_task.current_test_status,1,1)) < 6 THEN
    ASSIGN rvm_task.current_test_status = "6-TOK":U.

  /* 2nd create / update task history record for current task status */
  FIND FIRST rvm_task_history EXCLUSIVE-LOCK
       WHERE rvm_task_history.task_number = rvm_task.task_number
         AND rvm_task_history.task_test_area = rvm_task.current_test_area
         AND rvm_task_history.task_test_status = rvm_task.current_test_status
         AND rvm_task_history.test_status_date = rvm_task.test_status_date
       NO-ERROR.
  IF NOT AVAILABLE rvm_task_history THEN
    CREATE rvm_task_history.
  ASSIGN
    rvm_task_history.task_number = rvm_task.task_number
    rvm_task_history.task_test_area = rvm_task.current_test_area
    rvm_task_history.task_test_status = rvm_task.current_test_status
    rvm_task_history.test_status_date = rvm_task.test_status_date
    rvm_task_history.test_status_user = rvm_task.test_status_user
    rvm_task_history.task_history_notes = rvm_task.task_description
    rvm_task_history.estimated_hrs = rvm_task.estimated_hrs
    rvm_task_history.actual_hrs = rvm_task.actual_hrs
    .    

  /* 3rd create / update task history records rvm_task_history from existing task notes */
  FOR EACH rtb_tnot NO-LOCK
     WHERE rtb_tnot.task-num = rtb_task.task-num:

    FIND FIRST rvm_task_history EXCLUSIVE-LOCK
         WHERE rvm_task_history.task_number = rtb_tnot.task-num
           AND rvm_task_history.task_test_area = rtb_tnot.pmod
           AND rvm_task_history.task_test_status = rtb_tnot.object
           AND rvm_task_history.test_status_date = rtb_tnot.entered-when
         NO-ERROR.
    IF NOT AVAILABLE rvm_task_history THEN
      CREATE rvm_task_history.
    ASSIGN
      rvm_task_history.task_number = rtb_tnot.task-num
      rvm_task_history.task_test_area = rtb_tnot.pmod
      rvm_task_history.task_test_status = rtb_tnot.object
      rvm_task_history.test_status_date = rtb_tnot.entered-when
      rvm_task_history.test_status_user = rtb_tnot.user-name
      rvm_task_history.estimated_hrs = rtb_tnot.est-hours
      rvm_task_history.actual_hrs = rtb_tnot.act-hours
      .    

    DO lv_loop = 1 TO 15:
      IF LENGTH(rtb_tnot.description[lv_loop]) > 0 THEN
        ASSIGN rvm_task_history.task_history_notes = rvm_task_history.task_history_notes +
                                           IF LENGTH(rvm_task_history.task_history_notes) > 0 THEN CHR(10) ELSE "":U +
                                           rtb_tnot.description[lv_loop].
    END.
  END.

  /* 4th create / update task objects gsm-task_object */

  FOR EACH rtb_ver NO-LOCK
     WHERE rtb_ver.task-num = rtb_task.task-num:

    IF rtb_ver.obj-type <> "pcode":U THEN NEXT.
    IF rtb_ver.obj-status = "W":U THEN NEXT. /* only create objects when checked in */

    FIND FIRST rvm_task_object EXCLUSIVE-LOCK
         WHERE rvm_task_object.task_number = rtb_ver.task-num
           AND rvm_task_object.task_object_name = rtb_ver.object
           AND rvm_task_object.object_version = rtb_ver.version
         NO-ERROR.
    IF NOT AVAILABLE rvm_task_object THEN
      CREATE rvm_task_object.         
    ASSIGN
      rvm_task_object.task_number = rtb_ver.task-num
      rvm_task_object.task_object_name = rtb_ver.object
      rvm_task_object.object_version = rtb_ver.version
      rvm_task_object.object_product_module = rtb_ver.pmod
      rvm_task_object.object_type = rtb_ver.obj-type
      rvm_task_object.object_description = rtb_ver.description
      rvm_task_object.previous_object_version = rtb_ver.prev-version
      .

    ASSIGN lv_workspaces = "":U.
    FOR EACH rtb_object NO-LOCK
       WHERE rtb_object.pmod = rtb_ver.pmod
         AND rtb_object.obj-type = rtb_ver.obj-type
         AND rtb_object.object = rtb_ver.object
         AND rtb_object.version = rtb_ver.version
         AND rtb_object.wspace-id BEGINS lv_task_workspace:

          ASSIGN
            lv_workspaces = lv_workspaces +
                            (IF lv_workspaces <> "":U THEN ",":U ELSE "":U) +
                            rtb_object.wspace-id
            .
    END.

    IF INDEX(lv_workspaces,"-V":U) > 0 THEN
      ASSIGN
        rvm_task_object.current_test_area = "V1X":U.
    ELSE IF INDEX(lv_workspaces,"-T":U) > 0 THEN
      ASSIGN
        rvm_task_object.current_test_area = "TST".
    ELSE IF INDEX(lv_workspaces,"-D":U) > 0 THEN
      ASSIGN
        rvm_task_object.current_test_area = "DEV".
    IF lv_workspaces = "":U THEN
      ASSIGN
        rvm_task_object.current_test_area = "ARC":U. /* Archived - superceded by a later version */
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


