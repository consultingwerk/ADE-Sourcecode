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
  File: aftaskcomp.p

  Description:  RTB task completion hook

  Purpose:      This procedure will be run automatically from Roundtable when a task is
                completed. It's purpose is to post a record into the task test status table to
                monitor the test status of tasks.

  Parameters:   ip_task_number = Thr RTB task number being completed
                op_error_message = An error message to display in the event of failure

  History:
  --------
  (v:010000)    Task:         218   UserRef:    testing
                Date:   21/05/1998  Author:     Anthony Swindells

  Update Notes: Created from Template aftemprocp.p

  (v:010001)    Task:         261   UserRef:    
                Date:   02/06/1998  Author:     Anthony Swindells

  Update Notes: When a task completes, delete all rcode from task directory if applicable

  (v:010004)    Task:         831   UserRef:    
                Date:   08/12/1998  Author:     Anthony Swindells

  Update Notes: Test new task completion hook again

  (v:010005)    Task:         832   UserRef:    
                Date:   08/12/1998  Author:     Anthony Swindells

  Update Notes: Last change to new task completion hook

  (v:010006)    Task:        1687   UserRef:    
                Date:   19/07/1999  Author:     Anthony Swindells

  Update Notes: extra hooks

  (v:010007)    Task:        3201   UserRef:    
                Date:   18/10/1999  Author:     Anthony Swindells

  Update Notes: Remove r-code delete from task completion. The new Roundtable now
                deletes r-code from your task directory when you make an object central. The
                hook to delete r-code in your task directory is now no longer required, so it has
                been removed.

----------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       aftaskcomp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010001


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

DEFINE INPUT PARAMETER  ip_task_number      AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER op_error_message    AS CHARACTER NO-UNDO.

DEFINE STREAM ls_output.

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
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

ASSIGN op_error_message = "":U NO-ERROR.

IF NOT CONNECTED("RTB":U) THEN RETURN.

FIND FIRST rtb_task 
     WHERE rtb_task.task-num = ip_task_number NO-LOCK NO-ERROR.

/* Ensure completion worked ok and they did not cancel due to errors */
IF NOT AVAILABLE rtb_task OR rtb_task.task-status = "w":U THEN RETURN.

/*RUN delete-rcode.*/

/* New procedure for changing task status */
DEFINE VARIABLE lv_current_area                     AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lv_current_status                   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lv_new_area                         AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lv_new_status                       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lh_rtbprocp                         AS HANDLE       NO-UNDO.
DEFINE VARIABLE lv_tnot_rowid                       AS ROWID        NO-UNDO.
DEFINE VARIABLE lv_rejection                        AS CHARACTER    NO-UNDO.

/* Find current status */
FIND FIRST rtb_tnot NO-LOCK
     WHERE rtb_tnot.task-num = ip_task_number
       AND rtb_tnot.obj-type = "pcode":U
     NO-ERROR.
IF AVAILABLE rtb_tnot THEN
  ASSIGN
    lv_current_area = rtb_tnot.pmod
    lv_current_status = rtb_tnot.object
    .
ELSE
  ASSIGN
    lv_current_area = "":U
    lv_current_status = "":U
    .

/* Now some hard coding !!! */
ASSIGN
    lv_new_area = IF lv_current_area <> "":U THEN lv_current_area ELSE "DEV":U 
    lv_new_status = IF lv_new_area <> "dev":U THEN "4-TOT":U ELSE "3-COM":U
    .

RUN rtb/prc/afrtbprocp.p PERSISTENT SET lh_rtbprocp.
IF VALID-HANDLE(lh_rtbprocp) THEN
    RUN rtb-change-status-control IN lh_rtbprocp
                                   ( INPUT ip_task_number
                                    ,INPUT grtb-userid
                                    ,INPUT lv_new_area
                                    ,INPUT lv_new_status
                                    ,OUTPUT lv_tnot_rowid
                                    ,OUTPUT lv_rejection).

IF VALID-HANDLE( lh_rtbprocp ) THEN DELETE PROCEDURE lh_rtbprocp.

IF lv_rejection <> "":U THEN
  MESSAGE "Change of task status failed because: " SKIP lv_rejection SKIP
    VIEW-AS ALERT-BOX ERROR.

/*IF NOT CAN-FIND ( FIRST gst_task_test_status
 *                   WHERE gst_task_test_status.task_number = ip_task_number) THEN
 *   DO:
 *     FIND FIRST rtb_task 
 *          WHERE rtb_task.task-num = ip_task_number NO-LOCK NO-ERROR.
 *     IF AVAILABLE rtb_task THEN
 *       DO:
 *         CREATE gst_task_test_status.
 *         ASSIGN
 *             gst_task_test_status.task_number = ip_task_number
 *             gst_task_test_status.task_completed_date = rtb_task.compltd-when.
 *         RELEASE gst_task_test_status.
 *         ASSIGN op_error_message = "":U NO-ERROR.
 *       END.
 *     ELSE
 *         ASSIGN op_error_message = "Task failed to update task test status table" NO-ERROR.
 *   END.*/

RETURN.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-build-directory-list) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE build-directory-list Procedure 
PROCEDURE build-directory-list :
/*------------------------------------------------------------------------------
  Purpose:     Output a list of Progress files for the specified extensions for the
               passed in directory and all its sub-directories. Only returns
               files that are procedures, or windows ! 
  Parameters:  INPUT    ip_directory
               OUTPUT   op_file_list
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER  ip_directory    AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER  ip_recurse      AS LOGICAL      NO-UNDO.
DEFINE INPUT PARAMETER  ip_extensions   AS CHARACTER    NO-UNDO.
DEFINE OUTPUT PARAMETER op_file_list    AS CHARACTER    NO-UNDO.

DEFINE VARIABLE         lv_batchfile    AS CHARACTER    NO-UNDO.
DEFINE VARIABLE         lv_outputfile   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE         lv_filename     AS CHARACTER    NO-UNDO.
DEFINE VARIABLE         lv_line_numbers AS CHARACTER    NO-UNDO.
DEFINE VARIABLE         lv_line_texts   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE         lv_recurse      AS CHARACTER    NO-UNDO.
DEFINE VARIABLE         lv_loop         AS INTEGER      NO-UNDO.

/* Write batch file to do a directory listing of all files in
   the directory tree specified */
ASSIGN
    lv_batchfile  = SESSION:TEMP-DIRECTORY + "dir.bat":U
    lv_outputfile = SESSION:TEMP-DIRECTORY + "dir.log":U
    ip_directory = LC(TRIM(REPLACE(ip_directory,"/":U,"\":U)))
    lv_recurse = (IF ip_recurse = YES THEN "/s ":U ELSE " ":U).

OUTPUT TO VALUE(lv_batchfile).
DO lv_loop = 1 TO NUM-ENTRIES(ip_extensions):
    PUT UNFORMATTED "dir /b/l/on":U +
                    lv_recurse +
                    ip_directory + 
                    "\*.":U +
                    ENTRY(lv_loop, ip_extensions) +
                    (IF lv_loop = 1 THEN " > ":U ELSE " >> ":U) +
                    lv_outputfile
                    SKIP.
END.

OUTPUT CLOSE.

/* Execute batch file */
OS-COMMAND SILENT VALUE(lv_batchfile).

/* Check result */
IF SEARCH(lv_outputfile) <> ? THEN
  DO:
    INPUT STREAM ls_output FROM VALUE(lv_outputfile) NO-ECHO.
    REPEAT:
        IMPORT STREAM ls_output UNFORMATTED lv_filename.
        IF ip_recurse  = NO THEN ASSIGN lv_filename = ip_directory + "\":U + lv_filename.
        ASSIGN
            op_file_list =  op_file_list +
                            (IF NUM-ENTRIES(op_file_list) > 0 THEN ",":U ELSE "":U) +
                            LC(TRIM(lv_filename)).
    END.
    INPUT STREAM ls_output CLOSE.
  END.

/* Delete temp files */
OS-DELETE VALUE(lv_batchfile).
OS-DELETE VALUE(lv_outputfile). 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-delete-rcode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE delete-rcode Procedure 
PROCEDURE delete-rcode :
/*------------------------------------------------------------------------------
  Purpose:     Delete rcode from task directory of task just completed and all
               subdirectories.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE lv_file_list AS CHARACTER NO-UNDO.
    DEFINE VARIABLE LV_FILE AS CHARACTER FORMAT "X(70)" NO-UNDO.
    DEFINE VARIABLE LV_EXTENSION AS CHARACTER FORMAT "X(1)" NO-UNDO.
    DEFINE VARIABLE lv_loop AS INTEGER NO-UNDO.
    DEFINE VARIABLE lv_recurse AS LOGICAL NO-UNDO.
    DEFINE VARIABLE lv_directory AS CHARACTER NO-UNDO.

    FIND FIRST rtb_task 
         WHERE rtb_task.task-num = ip_task_number NO-LOCK NO-ERROR.
    IF NOT AVAILABLE rtb_task OR rtb_task.task-directory = "":U OR rtb_task.share-status <> "Task":U THEN RETURN.

    ASSIGN lv_directory = rtb_task.task-directory
           lv_recurse = YES.

    DEFINE VARIABLE lv_choice AS LOGICAL INITIAL YES NO-UNDO.
    MESSAGE "Delete r-code from task directory: " lv_directory
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
      UPDATE lv_choice.
    IF lv_choice = NO THEN RETURN.

    /* Turn on egg-timer */
    IF SESSION:SET-WAIT-STATE("GENERAL":U) THEN PROCESS EVENTS.

    /* Get a list of structured includes, procedures, and windows to process */
    RUN build-directory-list (INPUT lv_directory, INPUT lv_recurse, INPUT "r":U, OUTPUT lv_file_list).

    /* Work on each file */
    DO lv_loop = 1 TO NUM-ENTRIES(lv_file_list):
      ASSIGN lv_file = ENTRY(lv_loop,lv_file_list).
      OS-DELETE VALUE(lv_file).
    END.

    /* Turn off egg-timer */
    IF SESSION:SET-WAIT-STATE("":U) THEN PROCESS EVENTS.

    MESSAGE "Task directory: " + lv_directory + " rcode deleted"
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

