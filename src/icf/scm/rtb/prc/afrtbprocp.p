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
  File: afrtbprocp.p

  Description:  Roundtable API procedures

  Purpose:      Procedures that process the Roundtable repository directly using information
                from the available Roundtable global variables.
                This procedure contains all access to RTB database. It will not compile if
                RTB is not used.
                Alternative procedures should be provided for other SCM tools.

  Parameters:

  History:
  --------
  (v:010000)    Task:          41   UserRef:    AS0
                Date:   05/01/1998  Author:     Anthony Swindells

  Update Notes: Implement Wizard Controller

  (v:010001)    Task:    90000067   UserRef:    
                Date:   26/04/2001  Author:     Anthony Swindells

  Update Notes: extra procedures to fully encapsulate scm integration

  (v:010002)    Task:         101   UserRef:    
                Date:   20/03/1998  Author:     Anthony Swindells

  Update Notes: recomp

  (v:010003)    Task:         142   UserRef:    
                Date:   06/04/1998  Author:     Anthony Swindells

  Update Notes: Modify wizards to only run if not editing in read-only mode, i.e. if the object
                being edited belongs to the current task.

  (v:010006)    Task:        1687   UserRef:    
                Date:   19/07/1999  Author:     Anthony Swindells

  Update Notes: Work on RTB task test procedures

  (v:010007)    Task:        1900   UserRef:    
                Date:   20/07/1999  Author:     Anthony Swindells

  Update Notes: Fix RTB procedures corrupting RTB environment

  (v:010008)    Task:        3168   UserRef:    
                Date:   14/10/1999  Author:     Anthony Swindells

  Update Notes: Fix task note status problems. Cure problems of tasks dissappearing, plus
                status's getting changed incorrectly, i.e. moving back to dev, etc. plus area
                being set to DEV2.

  (v:010009)    Task:        3681   UserRef:    
                Date:   23/11/1999  Author:     Pieter Meyer

  Update Notes: Correct rtb trigger for task control

  (v:010010)    Task:        5521   UserRef:    astra2
                Date:   26/04/2000  Author:     Anthony Swindells

  Update Notes: ICF versioning RTB hooks implement

  (v:010011)    Task:        5564   UserRef:    astra2
                Date:   27/04/2000  Author:     Anthony Swindells

  Update Notes: Fix errors with versioning plip as a result of first tests.

  (v:010012)    Task:        5564   UserRef:    astra2
                Date:   01/05/2000  Author:     Anthony Swindells

  Update Notes: Fix errors with versioning plip as a result of 2nd tests.

  (v:010013)    Task:        5578   UserRef:    astra2
                Date:   02/05/2000  Author:     Anthony Swindells

  Update Notes: Change to scmObjectExists hook - add extra parameter to return the latest
                version available of the obejct, for use by the import procedures.

  (v:010014)    Task:        7361   UserRef:    
                Date:   19/12/2000  Author:     Anthony Swindells

  Update Notes: Allow product module changes in RV and track changes

  (v:010004)    Task:    90000018   UserRef:    
                Date:   01/28/2002  Author:     Dynamics Admin User

  Update Notes: Fix RV and RTB objects, to allow single r-code set

  (v:010005)    Task:    90000021   UserRef:    
                Date:   02/12/2002  Author:     Dynamics Admin User

  Update Notes: Remove RVDB dependency

--------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afrtbprocp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010000

{af/sup2/afglobals.i}

{rtb/inc/afrtbglobs.i} /* pull in Roundtable global variables */

/* Astra object identifying preprocessor */
&glob   AstraPlip    yes

DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.

ASSIGN cObjectName = "{&object-name}":U.

&scop   mip-notify-user-on-plip-close   NO

/* --- Temp-table needed by internal procedure create_xrefs --- */
DEFINE TEMP-TABLE TTxref
  FIELD src-object       AS CHARACTER
  FIELD ref-type         AS CHARACTER FORMAT "x(20)"
  FIELD obj-text         AS CHARACTER FORMAT "x(200)" EXTENT 4
  INDEX object AS PRIMARY
        src-object ASCENDING.

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
         HEIGHT             = 28.76
         WIDTH              = 57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

{ry/app/ryplipmain.i}

/* IF Grtb-userid = "":U THEN ASSIGN Grtb-userid = lv_current_user_login. */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-createDirectory) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createDirectory Procedure 
PROCEDURE createDirectory :
/*------------------------------------------------------------------------------
  Purpose:     Procedure to create a directory, being sure to create the full
               directory path. The standard os-create-dir will not create a full
               path.
  Parameters:  iip_path
               op_error_code
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER ip_path         AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error_code   AS CHARACTER NO-UNDO.

  DEFINE VARIABLE i                       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE pos                     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE tmp                     AS CHARACTER NO-UNDO.

  ASSIGN
    ip_path = REPLACE(ip_path,"/","~\").
  IF SUBSTRING(ip_path,LENGTH(ip_path),1,"CHARACTER":U) NE "~\":U
  THEN
    ASSIGN
      ip_path = ip_path + "~\":U.

  /* WIN95-UNC - Check for UNC \\SERVER\SHARE and treat it like a 
     drive specification. In which case, there is no basename and the prefix
     is the UNC and drive spec. -*/
  IF CAN-DO("OS2,WIN32,MSDOS,UNIX":U,OPSYS)
  THEN DO:
    IF ip_path BEGINS "~\~\" 
    AND NUM-ENTRIES(ip_path,"~\") > 4
    THEN DO:        /* start creating the dir at the 5 slashes down */
      ASSIGN
        pos = INDEX(ip_path,"~\":U).
      DO i = 1 TO 3:
        ASSIGN
          pos = INDEX(ip_path,"~\":U,pos + 1).
      END.
    END.
    ELSE
      ASSIGN
        pos = INDEX(ip_path,"~\":U).
  END.

  DO WHILE pos <> 0:  
    ASSIGN tmp = SUBSTRING(ip_path,1,pos).
    OS-CREATE-DIR VALUE(tmp).
    IF OS-ERROR <> 0
    THEN DO:
      ASSIGN
        op_error_code = "Failed to create directory, error code: " + STRING(OS-ERROR).
      RETURN.
    END.
    ASSIGN
      pos = INDEX(ip_path,"~\":U,pos + 1).
  END.

  ERROR-STATUS:ERROR = NO.
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

&IF DEFINED(EXCLUDE-objectDescription) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE objectDescription Procedure 
PROCEDURE objectDescription :
/*------------------------------------------------------------------------------
  Purpose:     Pass out a description of the PLIP, used in Plip temp-table
  Parameters:  <none>
  Notes:       This should be changed manually for each plip
------------------------------------------------------------------------------*/

  DEFINE OUTPUT PARAMETER cDescription AS CHARACTER NO-UNDO.

  ASSIGN
    cDescription = "RTB Procedures PLIP".

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

{ry/app/ryplipshut.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rtb-change-status) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rtb-change-status Procedure 
PROCEDURE rtb-change-status :
/*------------------------------------------------------------------------------
  Purpose:     To change the status of a task - assumes task exists with a status
  Parameters:  See below
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_task_number                  AS INTEGER      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_user                         AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_new_area                     AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_new_status                   AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT PARAMETER op_tnot_rowid                   AS ROWID        NO-UNDO.
  DEFINE OUTPUT PARAMETER op_rejection                    AS CHARACTER    NO-UNDO.

  DEFINE BUFFER lb1_rtb_tnot FOR rtb_tnot.
  DEFINE BUFFER lb2_rtb_tnot FOR rtb_tnot.

  DEFINE VARIABLE lv_loop                                 AS INTEGER      NO-UNDO.
  DEFINE VARIABLE lv_character                            AS CHARACTER    NO-UNDO.

  DO FOR lb1_rtb_tnot, lb2_rtb_tnot:

    /* Get current status and set as complete */
    FIND FIRST lb1_rtb_tnot EXCLUSIVE-LOCK
      WHERE lb1_rtb_tnot.task-num  = ip_task_number
      AND   lb1_rtb_tnot.note-type = "":U
      AND   lb1_rtb_tnot.obj-type  = "pcode":U
      NO-WAIT NO-ERROR.
    IF NOT AVAILABLE lb1_rtb_tnot
    AND LOCKED lb1_rtb_tnot
    THEN DO:
      ASSIGN
        op_rejection = "Cannot change task status because RTB Task Notes are locked by another user".
      RETURN.
    END.     
    IF AVAILABLE lb1_rtb_tnot
    THEN DO:
      ASSIGN
        lb1_rtb_tnot.obj-type       = "doc":U
        lb1_rtb_tnot.compltd-when   = TODAY
        lb1_rtb_tnot.compltd-by     = ip_user
        NO-ERROR
        .
      IF ERROR-STATUS:ERROR
      THEN DO:
        ASSIGN
          op_rejection = "Cannot update existing RTB Task Notes to change status due to invalid data" NO-ERROR.
        RETURN.
      END.
    END.

    /* Update / create new task notes, coping with change back to old status */
    FIND FIRST lb2_rtb_tnot EXCLUSIVE-LOCK
      WHERE lb2_rtb_tnot.task-num  = ip_task_number
      AND   lb2_rtb_tnot.note-type = "":U
      AND   lb2_rtb_tnot.object    = ip_new_status
      AND   lb2_rtb_tnot.pmod      = ip_new_area
      NO-WAIT NO-ERROR.
    IF NOT AVAILABLE lb2_rtb_tnot
    AND LOCKED lb2_rtb_tnot
    THEN DO:
      ASSIGN
        op_rejection = "Cannot update new status RTB Task Notes as they are locked by another user".
      RETURN.
    END.     
    IF NOT AVAILABLE lb2_rtb_tnot
    THEN DO:
      CREATE lb2_rtb_tnot NO-ERROR.
      IF ERROR-STATUS:ERROR
      THEN DO:
        ASSIGN
          op_rejection = "Cannot create new status RTB Task Notes due to invalid data" NO-ERROR.
        RETURN.
      END.
      ASSIGN
        lb2_rtb_tnot.task-num = ip_task_number
        lb2_rtb_tnot.pmod     = ip_new_area
        lb2_rtb_tnot.obj-type = "pcode":U
        lb2_rtb_tnot.object   = ip_new_status
        lb2_rtb_tnot.version  = 1
        NO-ERROR.
      IF ERROR-STATUS:ERROR
      THEN DO:
        ASSIGN
          op_rejection = "Cannot create / update new status RTB Task Notes due to invalid data" NO-ERROR.
        RETURN.
      END.
    END.

    /* Copy status notes from previous version */
    DO lv_loop = 1 TO 15:
      ASSIGN        
        lb2_rtb_tnot.description[lv_loop] = lb1_rtb_tnot.description[lv_loop].
    END.

    /* Record found or created - update rest of details */
    ASSIGN
      lb2_rtb_tnot.task-num       = ip_task_number
      lb2_rtb_tnot.pmod           = ip_new_area
      lb2_rtb_tnot.obj-type       = "pcode":U
      lb2_rtb_tnot.object         = ip_new_status
      lb2_rtb_tnot.entered-when   = TODAY
      lb2_rtb_tnot.compltd-when   = ?
      lb2_rtb_tnot.compltd-by     = "":U
      lb2_rtb_tnot.act-hours      = 0
      lb2_rtb_tnot.est-hours      = 0
      lb2_rtb_tnot.note-priority  = lb1_rtb_tnot.note-priority
      lb2_rtb_tnot.note-status    = "":U
      lb2_rtb_tnot.note-type      = "":U
      lb2_rtb_tnot.user-name      = ip_user
      NO-ERROR.
    IF ERROR-STATUS:ERROR
    THEN DO:
      ASSIGN
        op_rejection = "Cannot update new status RTB Task Notes due to invalid data" NO-ERROR.
      RETURN.
    END.

    /* No point in doing validation keyword as RTB has no triggers */
    ASSIGN op_tnot_rowid = ROWID(lb2_rtb_tnot).
    RELEASE lb1_rtb_tnot NO-ERROR.
    RELEASE lb2_rtb_tnot NO-ERROR.

    ASSIGN
      op_rejection = "":U NO-ERROR.

  END.    /* do for */

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rtb-change-status-control) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rtb-change-status-control Procedure 
PROCEDURE rtb-change-status-control :
/*------------------------------------------------------------------------------
  Purpose:     To change the status of a task - assumes task exists with a status
  Parameters:  See below
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_task_number                  AS INTEGER      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_user                         AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_new_area                     AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_new_status                   AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT PARAMETER op_tnot_rowid                   AS ROWID        NO-UNDO.
  DEFINE OUTPUT PARAMETER op_rejection                    AS CHARACTER    NO-UNDO.

  TRANSACTION-BLOCK:
  DO TRANSACTION:

    RUN rtb-change-status (INPUT ip_task_number
                          ,INPUT ip_user
                          ,INPUT ip_new_area
                          ,INPUT ip_new_status
                          ,OUTPUT op_tnot_rowid
                          ,OUTPUT op_rejection).

    IF op_rejection <> "":U
    THEN
      UNDO TRANSACTION-BLOCK, LEAVE TRANSACTION-BLOCK.                        

  END. /* transaction-block */

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rtb-get-objectinfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rtb-get-objectinfo Procedure 
PROCEDURE rtb-get-objectinfo :
/*------------------------------------------------------------------------------
  Purpose:     To retrieve information about the current open object in the 
               current workspace for the current task.

  Parameters:
    INPUT   ip_object               object name (including extension)
    INPUT   ip_task_number          current task
    OUTPUT  op_object_version       current version of object in task
    OUTPUT  op_object_summary       summary description of object
    OUTPUT  op_object_description   | delimited list for full object description
    OUTPUT  op_object_upd_notes     version update notes
    OUTPUT  op_previous_versions    comma seperated list of object versions before the current version
    OUTPUT  op_object_version_task  The task the version is/was changed under
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_object               AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_task_number          AS INTEGER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_object_version       AS INTEGER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_object_summary       AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_object_description   AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_object_upd_notes     AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_previous_versions    AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_object_version_task  AS INTEGER NO-UNDO.

  /* Find passed in task to get current workspace */
  FIND rtb_task NO-LOCK
    WHERE rtb_task.task-num = ip_task_number
    NO-ERROR.
  IF NOT AVAILABLE rtb_task
  THEN RETURN.

  /* Find current version of object in the workspace */
  FIND rtb_object NO-LOCK
    WHERE rtb_object.wspace-id = rtb_task.wspace-id
    AND   rtb_object.obj-type  = "PCODE":U
    AND   rtb_object.object    = ip_object
    NO-ERROR.
  IF NOT AVAILABLE rtb_object
  THEN RETURN.

  /* Get object version details */
  FIND rtb_ver NO-LOCK
    WHERE rtb_ver.obj-type = rtb_object.obj-type
    AND   rtb_ver.object = rtb_object.object
    AND   rtb_ver.pmod = rtb_object.pmod
    AND   rtb_ver.version = rtb_object.version
    NO-ERROR.
  IF NOT AVAILABLE rtb_ver
  THEN RETURN.

  ASSIGN
    op_object_version       = rtb_ver.version
    op_object_summary       = rtb_ver.description
    op_object_upd_notes     = rtb_ver.upd-notes
    op_object_version_task  = rtb_ver.task-num.

  DEFINE VARIABLE lv_loop         AS INTEGER NO-UNDO.
  DEFINE VARIABLE lv_num_entries  AS INTEGER NO-UNDO.
  DEFINE VARIABLE lv_character    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lv_line         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lv_text         AS CHARACTER NO-UNDO.

  /* Find out how many entries there are in the description */
  DO lv_loop = 1 to 16:
    IF rtb_ver.text-desc[lv_loop] <> ""
    THEN
      ASSIGN
        lv_num_entries = lv_loop.
  END.

  DO lv_loop = 1 TO lv_num_entries:
    ASSIGN
      lv_character          = REPLACE(rtb_ver.text-desc[lv_loop],"|":U," ":U)
      op_object_description = op_object_description
                            + (IF NUM-ENTRIES(op_object_description,"|":U) > 0 THEN "|":U ELSE "":U)
                            + lv_character.
  END.

  IF op_object_upd_notes = ""
  AND AVAILABLE rtb_task
  THEN DO:
    ASSIGN
      lv_text = "":U.
    DO lv_loop = 1 TO 15:
      ASSIGN
        lv_line = REPLACE(rtb_task.description[lv_loop],"|":U," ":U).
      IF lv_line <> ""
      THEN
        ASSIGN
          lv_text = lv_text
                  + (IF NUM-ENTRIES(lv_text,CHR(10)) > 0 THEN CHR(10) ELSE "":U)
                  + lv_line.
    END.
    ASSIGN
      op_object_upd_notes = op_object_upd_notes + REPLACE(lv_text,"|":U," ":U).
  END.

  IF op_object_upd_notes = ""
  AND AVAILABLE rtb_task
  THEN
    ASSIGN
      op_object_upd_notes = TRIM(rtb_task.summary).

  /* get any previous version numbers for the object */
  DO WHILE AVAILABLE rtb_ver:

    FIND NEXT rtb_ver NO-LOCK
      WHERE rtb_ver.obj-type = rtb_object.obj-type
      AND   rtb_ver.object = rtb_object.object
      AND   rtb_ver.pmod = rtb_object.pmod
      USE-INDEX rtb_ver01
      NO-ERROR.
    IF AVAILABLE rtb_ver
    THEN
      ASSIGN
        op_previous_versions = op_previous_versions
                             + (IF NUM-ENTRIES(op_previous_versions) > 0 THEN ",":U ELSE "":U)
                             + STRING(rtb_ver.version).
  END.

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rtb-get-taskinfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rtb-get-taskinfo Procedure 
PROCEDURE rtb-get-taskinfo :
/*------------------------------------------------------------------------------
  Purpose:      To retrieve information on the currently selected Roundtable Task 
  Parameters:  
    OUTPUT  op_task_number
    OUTPUT  op_task_summary
    OUTPUT  op_task_description     (15 entries, | delimited)
    OUTPUT  op_task_programmer
    OUTPUT  op_task_userref
    OUTPUT  op_task_workspace
    OUTPUT  op_task_entered_date

  Notes:       
------------------------------------------------------------------------------*/

  DEFINE OUTPUT PARAMETER op_task_number      AS INTEGER INITIAL 0 NO-UNDO.
  DEFINE OUTPUT PARAMETER op_task_summary     AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_task_description AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_task_programmer  AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_task_userref     AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_task_workspace   AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_task_entered_date AS DATE NO-UNDO.

  FIND rtb_task NO-LOCK
    WHERE rtb_task.task-num = grtb-task-num
    NO-ERROR.
  IF NOT AVAILABLE rtb_task
  THEN RETURN.

  ASSIGN
    op_task_number        = rtb_task.task-num
    op_task_summary       = TRIM(rtb_task.summary)
    op_task_programmer    = TRIM(LC(rtb_task.programmer))
    op_task_userref       = TRIM(rtb_task.user-task-ref)
    op_task_workspace     = TRIM(LC(rtb_task.wspace-id))
    op_task_entered_date  = rtb_task.entered-when
    .

  DEFINE VARIABLE lv_loop AS INTEGER NO-UNDO.
  DEFINE VARIABLE lv_character AS CHARACTER NO-UNDO.
  DO lv_loop = 1 TO 15:
    ASSIGN
      lv_character = REPLACE(rtb_task.description[lv_loop],"|":U," ":U).
    IF lv_character <> ""
    THEN
      ASSIGN
        op_task_description = op_task_description
                            + (IF NUM-ENTRIES(op_task_description,"|":U) > 0 THEN "|":U ELSE "":U)
                            + lv_character.
  END.

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rtb-get-userinfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rtb-get-userinfo Procedure 
PROCEDURE rtb-get-userinfo :
/*------------------------------------------------------------------------------
  Purpose:     To retrieve information on the current Roundtable user
  Parameters:
    OUTPUT  op_user_code
    OUTPUT  op_user_name
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE OUTPUT PARAMETER op_user_code    AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_user_name    AS CHARACTER NO-UNDO.

  FIND rtb._user NO-LOCK
    WHERE rtb._user._userid = grtb-userid
    NO-ERROR.

  IF AVAILABLE rtb._user
  THEN
    ASSIGN
      op_user_code = rtb._user._userid
      op_user_name = rtb._user._user-name.

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rtb-get-version-notes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rtb-get-version-notes Procedure 
PROCEDURE rtb-get-version-notes :
/*------------------------------------------------------------------------------
  Purpose:     To Retrieve version notes about a passed in object version. All 
               details are passed back in | delimited lists in case multiple
               records exists for the same version. This would only be the case
               if an object has moved modules, but must be coped with and the
               multiple records returned, as they may have been done under
               different tasks and by different people, etc.

               This is not a problem in the other proecdures as we are only
               dealing with the version notes for the current objects module !

  Parameters:
    INPUT   ip_object               object name (including extension)
    INPUT   ip_object_version       version of object
    OUTPUT  op_object_upd_notes     version update notes
    OUTPUT  op_task_number          Task version was editted under
    OUTPUT  op_task_programmer      Author of task     
    OUTPUT  op_task_userref         Project reference for task
    OUTPUT  op_task_date            Task entered date or completed date if complete

  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_object               AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_version       AS INTEGER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_object_upd_notes     AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_task_number          AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_task_programmer      AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_task_userref         AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_task_date            AS CHARACTER NO-UNDO.

  DEFINE VARIABLE lv_loop AS INTEGER NO-UNDO.
  DEFINE VARIABLE lv_line AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lv_text AS CHARACTER NO-UNDO.

  /* Get object version details */
  FOR EACH rtb_ver NO-LOCK
    WHERE rtb_ver.obj-type  = "PCODE":U
    AND   rtb_ver.object    = ip_object
    AND   rtb_ver.version   = ip_object_version
    :

    FIND rtb_task NO-LOCK
      WHERE rtb_task.task-num = rtb_ver.task-num
      NO-ERROR.
    IF AVAILABLE rtb_task
    THEN
      FIND rtb._user NO-LOCK
        WHERE rtb._user._userid = rtb_task.programmer
        NO-ERROR.
    IF AVAILABLE rtb_ver
    AND AVAILABLE rtb_task
    AND AVAILABLE rtb._user
    THEN
      ASSIGN
        op_object_upd_notes = op_object_upd_notes
                            + (IF NUM-ENTRIES(op_object_upd_notes,"|":U) > 0 THEN "|":U ELSE "":U)
                            + REPLACE(rtb_ver.upd-notes,"|":U," ":U)
        op_task_number      = op_task_number
                            + (IF NUM-ENTRIES(op_task_number,"|":U) > 0 THEN "|":U ELSE "":U)
                            + STRING(rtb_task.task-num)
        op_task_programmer  = op_task_programmer
                            + (IF NUM-ENTRIES(op_task_programmer,"|":U) > 0 THEN "|":U ELSE "":U)
                            + REPLACE(rtb._user._user-name,"|":U," ":U)
        op_task_userref     = op_task_userref
                            + (IF NUM-ENTRIES(op_task_userref,"|":U) > 0 THEN "|":U ELSE "":U)
                            + REPLACE(TRIM(rtb_task.user-task-ref),"|":U," ":U)
        op_task_date        = op_task_date
                            + (IF NUM-ENTRIES(op_task_date,"|":U) > 0 THEN "|":U ELSE "":U)
                            + STRING(rtb_task.entered-when)
        .

    IF ENTRY(NUM-ENTRIES(op_task_number,"|":U),op_object_upd_notes,"|":U) = ""
    AND AVAILABLE rtb_task
    THEN DO:
      ASSIGN
        lv_text = "":U.
      DO lv_loop = 1 TO 15:
        ASSIGN
          lv_line = REPLACE(rtb_task.description[lv_loop],"|":U," ":U).
        IF lv_line <> ""
        THEN
          ASSIGN
            lv_text = lv_text
                    + (IF NUM-ENTRIES(lv_text,CHR(10)) > 0 THEN CHR(10) ELSE "":U)
                    + lv_line.
      END.
      ASSIGN
        ENTRY(NUM-ENTRIES(op_task_number,"|":U),op_object_upd_notes,"|":U) =
                (IF REPLACE(lv_text,"|":U," ":U) <> "":U THEN REPLACE(lv_text,"|":U," ":U) ELSE TRIM(rtb_task.summary)).
    END.

  END.

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rtb-set-objectinfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rtb-set-objectinfo Procedure 
PROCEDURE rtb-set-objectinfo :
/*------------------------------------------------------------------------------
  Purpose:     To update information about the passed in object for the passed in
               task, back into roundtable.
  Parameters:
    INPUT   ip_object               object name (including extension)
    INPUT   ip_task_number          current task
    INPUT   ip_object_version       current version of object in task
    INPUT   ip_object_summary       summary description of object
    INPUT   ip_object_description   full object description
    INPUT   ip_object_upd_notes     version update notes
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_object               AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_task_number          AS INTEGER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_version       AS INTEGER NO-UNDO.

  /* These details updated */
  DEFINE INPUT PARAMETER  ip_object_summary       AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_description   AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_upd_notes     AS CHARACTER NO-UNDO.

  /* Find passed in task to get current workspace */
  FIND rtb_task NO-LOCK
    WHERE rtb_task.task-num = ip_task_number
    NO-ERROR.
  IF NOT AVAILABLE rtb_task
  THEN DO:
    MESSAGE
      "Could not update object in Roundtable as the task was not found"
      VIEW-AS ALERT-BOX.
    RETURN.
  END.

  /* Find current version of object in the workspace */
  FIND rtb_object NO-LOCK
    WHERE   rtb_object.wspace-id  = rtb_task.wspace-id
    AND     rtb_object.obj-type   = "PCODE":U
    AND     rtb_object.object     = ip_object
    NO-ERROR.

  IF NOT AVAILABLE rtb_object
  THEN DO:
    MESSAGE
      "Could not update object in Roundtable as the object was not found"
      VIEW-AS ALERT-BOX.
    RETURN.
  END.

  /* Get object vesion details for update */
  FIND rtb_ver
    WHERE   rtb_ver.obj-type  = rtb_object.obj-type
    AND     rtb_ver.object    = rtb_object.object
    AND     rtb_ver.pmod      = rtb_object.pmod
    AND     rtb_ver.version   = ip_object_version
    EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
  IF NOT AVAILABLE rtb_ver
  THEN DO:
    IF LOCKED rtb_ver
    THEN
      MESSAGE
        "Could not update object version - locked by another user !"
        VIEW-AS ALERT-BOX.
    ELSE
      MESSAGE
        "Could not update object version - not found !"
        VIEW-AS ALERT-BOX.
    RETURN.
  END.

  ASSIGN
    rtb_ver.description = ip_object_summary
    rtb_ver.upd-notes   = ip_object_upd_notes.

  DEFINE VARIABLE lv_loop         AS INTEGER NO-UNDO.
  DEFINE VARIABLE lv_num_entries  AS INTEGER NO-UNDO.

  ASSIGN
    lv_num_entries = NUM-ENTRIES(ip_object_description,CHR(10)).
  IF lv_num_entries > 16
  THEN DO:
    MESSAGE
      "Part of the version notes has not been written to Roundtable as" SKIP
      "Roundtable has a maximum of 16 lines for version notes"
      VIEW-AS ALERT-BOX WARNING BUTTONS OK. 
    ASSIGN
      lv_num_entries = 16.
  END.

  DO lv_loop = 1 TO lv_num_entries:
    ASSIGN
      rtb_ver.text-desc[lv_loop] = ENTRY(lv_loop,ip_object_description,CHR(10)).
  END.

  RELEASE rtb_ver.

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rtb-set-taskinfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rtb-set-taskinfo Procedure 
PROCEDURE rtb-set-taskinfo :
/*------------------------------------------------------------------------------
  Purpose:      To update task information into Roundtable - the only task info
                that may be updated is the user reference !
  Parameters:  
    INPUT  ip_task_number
    INPUT  ip_task_userref

  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER ip_task_number  AS INTEGER NO-UNDO.

  /* These details updated */
  DEFINE INPUT PARAMETER ip_task_userref AS CHARACTER NO-UNDO.

  FIND rtb_task EXCLUSIVE-LOCK
    WHERE rtb_task.task-num = ip_task_number
    NO-WAIT NO-ERROR.
  IF NOT AVAILABLE rtb_task
  THEN DO:
    IF LOCKED rtb_task
    THEN
      MESSAGE
        "Could not update task - locked by another user !"
        VIEW-AS ALERT-BOX.
    ELSE
      MESSAGE
        "Could not update task - Task not found !"
        VIEW-AS ALERT-BOX.
  END.
  ELSE DO:
    ASSIGN
      rtb_task.user-task-ref = ip_task_userref.
    RELEASE rtb_task.
  END.

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rtb-update-history-notes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rtb-update-history-notes Procedure 
PROCEDURE rtb-update-history-notes :
/*------------------------------------------------------------------------------
  Purpose:     To update task notes history records
  Parameters:  see below
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_tnot_rowid                   AS ROWID        NO-UNDO.
  DEFINE INPUT PARAMETER  ip_entered_when                 AS DATE         NO-UNDO.
  DEFINE INPUT PARAMETER  ip_completed_when               AS DATE         NO-UNDO.
  DEFINE INPUT PARAMETER  ip_completed_by                 AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_actual_hours                 AS DECIMAL      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_estimate_hours               AS DECIMAL      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_note_priority                AS INTEGER      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_note_status                  AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_note_type                    AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_note_user                    AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_status_notes                 AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT PARAMETER op_rejection                    AS CHARACTER    NO-UNDO.

  DEFINE BUFFER lb1_rtb_tnot FOR rtb_tnot.

  DEFINE VARIABLE lv_loop                                 AS INTEGER      NO-UNDO.
  DEFINE VARIABLE lv_character                            AS CHARACTER    NO-UNDO.

  DO FOR lb1_rtb_tnot:

    FIND FIRST lb1_rtb_tnot EXCLUSIVE-LOCK
      WHERE ROWID(lb1_rtb_tnot) = ip_tnot_rowid
      NO-WAIT NO-ERROR.

    IF NOT AVAILABLE lb1_rtb_tnot
    AND LOCKED lb1_rtb_tnot
    THEN DO:
      ASSIGN
        op_rejection = "Cannot update RTB History Task Notes as they are locked by another user".
      RETURN.
    END.     

    IF NOT AVAILABLE lb1_rtb_tnot
    THEN DO:
      ASSIGN
        op_rejection = "Cannot update RTB History Task Notes as they have been deleted by another user".
      RETURN.
    END.     

    /* Record found or created - update rest of details */
    DO lv_loop = 1 TO 15:
      IF lv_loop <= NUM-ENTRIES(ip_status_notes,CHR(10))
      THEN
        ASSIGN
          lv_character = REPLACE(ENTRY(lv_loop,ip_status_notes,CHR(10)),"|":U," ":U).
      ELSE
        ASSIGN
          lv_character = "":U.
      ASSIGN        
        lb1_rtb_tnot.description[lv_loop] = lv_character.
    END.

    ASSIGN
      lb1_rtb_tnot.entered-when   = ip_entered_when
      lb1_rtb_tnot.compltd-when   = ip_completed_when
      lb1_rtb_tnot.compltd-by     = ip_completed_by
      lb1_rtb_tnot.act-hours      = ip_actual_hours
      lb1_rtb_tnot.est-hours      = ip_estimate_hours
      lb1_rtb_tnot.note-priority  = ip_note_priority
      lb1_rtb_tnot.note-status    = ip_note_status
      lb1_rtb_tnot.note-type      = ip_note_type
      lb1_rtb_tnot.user-name      = ip_note_user
      NO-ERROR.
    IF ERROR-STATUS:ERROR
    THEN DO:
      ASSIGN
        op_rejection = "Cannot update RTB History Task Notes due to invalid data"
        NO-ERROR.
      RETURN.
    END.

    /* No point in doing validation keyword as RTB has no triggers */
    RELEASE lb1_rtb_tnot NO-ERROR.

    ASSIGN
      op_rejection = "":U
      NO-ERROR.

  END.    /* do for */

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rtb-update-history-notes-control) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rtb-update-history-notes-control Procedure 
PROCEDURE rtb-update-history-notes-control :
/*------------------------------------------------------------------------------
  Purpose:     To update task notes history records
  Parameters:  see below
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_tnot_rowid                   AS ROWID        NO-UNDO.
  DEFINE INPUT PARAMETER  ip_entered_when                 AS DATE         NO-UNDO.
  DEFINE INPUT PARAMETER  ip_completed_when               AS DATE         NO-UNDO.
  DEFINE INPUT PARAMETER  ip_completed_by                 AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_actual_hours                 AS DECIMAL      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_estimate_hours               AS DECIMAL      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_note_priority                AS INTEGER      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_note_status                  AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_note_type                    AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_note_user                    AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_status_notes                 AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT PARAMETER op_rejection                    AS CHARACTER    NO-UNDO.

  TRANSACTION-BLOCK:
  DO TRANSACTION:

    RUN rtb-update-history-notes (INPUT ip_tnot_rowid
                                 ,INPUT ip_entered_when
                                 ,INPUT ip_completed_when
                                 ,INPUT ip_completed_by
                                 ,INPUT ip_actual_hours
                                 ,INPUT ip_estimate_hours
                                 ,INPUT ip_note_priority
                                 ,INPUT ip_note_status
                                 ,INPUT ip_note_type
                                 ,INPUT ip_note_user
                                 ,INPUT ip_status_notes
                                 ,OUTPUT op_rejection).

    IF op_rejection <> "":U
    THEN
      UNDO TRANSACTION-BLOCK, LEAVE TRANSACTION-BLOCK.                        

  END. /* transaction-block */

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rtb-update-task) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rtb-update-task Procedure 
PROCEDURE rtb-update-task :
/*------------------------------------------------------------------------------
  Purpose:     To update all task details for an existing task
  Parameters:  SEE BELOW
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_task_number                  AS INTEGER      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_task_summary                 AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_completed_by                 AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_completed_date               AS DATE         NO-UNDO.
  DEFINE INPUT PARAMETER  ip_entered_date                 AS DATE         NO-UNDO.
  DEFINE INPUT PARAMETER  ip_manager                      AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_programmer                   AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_share_status                 AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_task_directory               AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_user_reference               AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_workspace                    AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_task_notes                   AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT PARAMETER op_task_rowid                   AS ROWID        NO-UNDO.
  DEFINE OUTPUT PARAMETER op_rejection                    AS CHARACTER    NO-UNDO.

  DEFINE BUFFER lb_rtb_task FOR rtb_task.

  DEFINE VARIABLE lv_loop                                 AS INTEGER      NO-UNDO.
  DEFINE VARIABLE lv_character                            AS CHARACTER    NO-UNDO.

  DO FOR lb_rtb_task:

    FIND FIRST lb_rtb_task EXCLUSIVE-LOCK
      WHERE lb_rtb_task.task-num = ip_task_number
      NO-WAIT NO-ERROR.
    IF NOT AVAILABLE lb_rtb_task
    THEN DO:
      IF LOCKED lb_rtb_task
      THEN
        ASSIGN
          op_rejection = "Unable to update RTB Task as it is locked by another user".
      ELSE
        ASSIGN
          op_rejection = "Unable to update RTB Task as it has been deleted.".
      RETURN.
    END.

    ASSIGN
      lb_rtb_task.summary         = ip_task_summary
      lb_rtb_task.compltd-by      = ip_completed_by
      lb_rtb_task.compltd-when    = ip_completed_date
      lb_rtb_task.entered-when    = ip_entered_date
      lb_rtb_task.manager         = ip_manager
      lb_rtb_task.programmer      = ip_programmer
      lb_rtb_task.share-status    = ip_share_status
      lb_rtb_task.task-directory  = ip_task_directory
      lb_rtb_task.wspace-id       = ip_workspace
      lb_rtb_task.user-task-ref   = ip_user_reference
      NO-ERROR.

    IF ERROR-STATUS:ERROR
    THEN DO:
      ASSIGN
        op_rejection = "Unable to update RTB Task due to invalid data" NO-ERROR.
      RETURN.
    END.

    DO lv_loop = 1 TO 15:
      IF lv_loop <= NUM-ENTRIES(ip_task_notes,CHR(10))
      THEN
        ASSIGN lv_character = REPLACE(ENTRY(lv_loop,ip_task_notes,CHR(10)),"|":U," ":U).
      ELSE
        ASSIGN lv_character = "":U.
      ASSIGN        
        lb_rtb_task.description[lv_loop] = lv_character.
    END.

    /* No point in doing validation keyword as RTB has no triggers */
    ASSIGN
      op_task_rowid = ROWID(lb_rtb_task).

    RELEASE lb_rtb_task NO-ERROR.

    ASSIGN
      op_rejection = "":U
      NO-ERROR.

  END.    /* do for */

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rtb-update-task-control) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rtb-update-task-control Procedure 
PROCEDURE rtb-update-task-control :
/*------------------------------------------------------------------------------
  Purpose:     To update all task details for an existing task
  Parameters:  SEE BELOW
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_task_number                  AS INTEGER      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_task_summary                 AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_completed_by                 AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_completed_date               AS DATE         NO-UNDO.
  DEFINE INPUT PARAMETER  ip_entered_date                 AS DATE         NO-UNDO.
  DEFINE INPUT PARAMETER  ip_manager                      AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_programmer                   AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_share_status                 AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_task_directory               AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_user_reference               AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_workspace                    AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_task_description             AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT PARAMETER op_task_rowid                   AS ROWID        NO-UNDO.
  DEFINE OUTPUT PARAMETER op_rejection                    AS CHARACTER    NO-UNDO.

  TRANSACTION-BLOCK:
  DO TRANSACTION:

    RUN rtb-update-task (INPUT ip_task_number
                        ,INPUT ip_task_summary
                        ,INPUT ip_completed_by
                        ,INPUT ip_completed_date
                        ,INPUT ip_entered_date
                        ,INPUT ip_manager
                        ,INPUT ip_programmer
                        ,INPUT ip_share_status
                        ,INPUT ip_task_directory
                        ,INPUT ip_user_reference
                        ,INPUT ip_workspace
                        ,INPUT ip_task_description
                        ,OUTPUT op_task_rowid
                        ,OUTPUT op_rejection).

    IF op_rejection <> "":U
    THEN
      UNDO TRANSACTION-BLOCK, LEAVE TRANSACTION-BLOCK.                        

  END. /* transaction-block */

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rtb-update-task-notes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rtb-update-task-notes Procedure 
PROCEDURE rtb-update-task-notes :
/*------------------------------------------------------------------------------
  Purpose:     To update / create task notes
  Parameters:  See below
  Notes:       
-----------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_task_number                  AS INTEGER      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_pmod                         AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_obj_type                     AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object                       AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_version                      AS INTEGER      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_entered_when                 AS DATE         NO-UNDO.
  DEFINE INPUT PARAMETER  ip_completed_when               AS DATE         NO-UNDO.
  DEFINE INPUT PARAMETER  ip_completed_by                 AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_actual_hours                 AS DECIMAL      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_estimate_hours               AS DECIMAL      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_note_priority                AS INTEGER      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_note_status                  AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_note_type                    AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_note_user                    AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_status_notes                 AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_current_area                 AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_new_area                     AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_current_status               AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_new_status                   AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT PARAMETER op_tnot_rowid                   AS ROWID        NO-UNDO.
  DEFINE OUTPUT PARAMETER op_rejection                    AS CHARACTER    NO-UNDO.

  DEFINE BUFFER lb1_rtb_tnot FOR rtb_tnot.
  DEFINE BUFFER lb2_rtb_tnot FOR rtb_tnot.

  DEFINE VARIABLE lv_loop                                 AS INTEGER      NO-UNDO.
  DEFINE VARIABLE lv_character                            AS CHARACTER    NO-UNDO.

  DO FOR lb1_rtb_tnot, lb2_rtb_tnot:

    /* If status changed, update existing notes to complete them */
    IF (ip_current_area <> ip_new_area
    OR ip_current_status <> ip_new_status)
    AND ip_current_area <> "":U
    AND ip_current_status <> "":U
    THEN DO:
      FIND FIRST lb1_rtb_tnot EXCLUSIVE-LOCK
        WHERE lb1_rtb_tnot.task-num = ip_task_number
        AND   lb1_rtb_tnot.obj-type = "pcode":U
        NO-WAIT NO-ERROR.
      IF NOT AVAILABLE lb1_rtb_tnot
      AND LOCKED lb1_rtb_tnot
      THEN DO:
        ASSIGN
          op_rejection = "Cannot update RTB Task Notes as they are locked by another user".
        RETURN.
      END.     
      IF AVAILABLE lb1_rtb_tnot
      THEN DO:
        ASSIGN
          lb1_rtb_tnot.obj-type     = "doc":U
          lb1_rtb_tnot.compltd-when = TODAY
          lb1_rtb_tnot.compltd-by   = grtb-userid
          NO-ERROR.
        IF ERROR-STATUS:ERROR
        THEN DO:
          ASSIGN
            op_rejection = "Cannot update existing RTB Task Notes due to invalid data" NO-ERROR.
          RETURN.
        END.
      END.
    END.

    /* Update / create new task notes, coping with change back to old status */
    FIND FIRST lb2_rtb_tnot EXCLUSIVE-LOCK
      WHERE lb2_rtb_tnot.task-num = ip_task_number
      AND   lb2_rtb_tnot.pmod     = ip_new_area
      AND   lb2_rtb_tnot.object   = ip_new_status
      NO-WAIT NO-ERROR.
    IF NOT AVAILABLE lb2_rtb_tnot
    AND LOCKED lb2_rtb_tnot
    THEN DO:
      ASSIGN
        op_rejection = "Cannot update new RTB Task Notes as they are locked by another user".
      RETURN.
    END.     
    IF NOT AVAILABLE lb2_rtb_tnot
    THEN DO:
      CREATE lb2_rtb_tnot NO-ERROR.
      IF ERROR-STATUS:ERROR
      THEN DO:
        ASSIGN
          op_rejection = "Cannot create new RTB Task Notes due to invalid data"
          NO-ERROR.
        RETURN.
      END.
      ASSIGN
        lb2_rtb_tnot.task-num = ip_task_number
        lb2_rtb_tnot.pmod     = ip_new_area
        lb2_rtb_tnot.obj-type = ip_obj_type
        lb2_rtb_tnot.object   = ip_new_status
        lb2_rtb_tnot.version  = 1
        NO-ERROR.          
      IF ERROR-STATUS:ERROR
      THEN DO:
        ASSIGN
          op_rejection = "Cannot create / update new RTB Task Notes due to invalid data"
          NO-ERROR.
        RETURN.
      END.
    END.

    DO lv_loop = 1 TO 15:
      IF lv_loop <= NUM-ENTRIES(ip_status_notes,CHR(10))
      THEN
        ASSIGN
          lv_character = REPLACE(ENTRY(lv_loop,ip_status_notes,CHR(10)),"|":U," ":U).
      ELSE
        ASSIGN
          lv_character = "":U.
      ASSIGN        
        lb2_rtb_tnot.description[lv_loop] = lv_character.
    END.

    /* Record found or created - update rest of details */
    ASSIGN
      lb2_rtb_tnot.obj-type       = ip_obj_type
      lb2_rtb_tnot.version        = ip_version
      lb2_rtb_tnot.entered-when   = ip_entered_when
      lb2_rtb_tnot.compltd-when   = ip_completed_when
      lb2_rtb_tnot.compltd-by     = ip_completed_by
      lb2_rtb_tnot.act-hours      = ip_actual_hours
      lb2_rtb_tnot.est-hours      = ip_estimate_hours
      lb2_rtb_tnot.note-priority  = ip_note_priority
      lb2_rtb_tnot.note-status    = ip_note_status
      lb2_rtb_tnot.note-type      = ip_note_type
      lb2_rtb_tnot.user-name      = ip_note_user
      NO-ERROR.
    IF ERROR-STATUS:ERROR
    THEN DO:
      ASSIGN
        op_rejection = "Cannot update new RTB Task Notes due to invalid data" NO-ERROR.
      RETURN.
    END.

    /* No point in doing validation keyword as RTB has no triggers */
    ASSIGN op_tnot_rowid = ROWID(lb2_rtb_tnot).
    RELEASE lb1_rtb_tnot NO-ERROR.
    RELEASE lb2_rtb_tnot NO-ERROR.

    ASSIGN
      op_rejection = "":U
      NO-ERROR.

  END.    /* do for */

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rtb-update-task-notes-control) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rtb-update-task-notes-control Procedure 
PROCEDURE rtb-update-task-notes-control :
/*------------------------------------------------------------------------------
  Purpose:     To update / create task notes
  Parameters:  see below
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_task_number                  AS INTEGER      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_pmod                         AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_obj_type                     AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object                       AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_version                      AS INTEGER      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_entered_when                 AS DATE         NO-UNDO.
  DEFINE INPUT PARAMETER  ip_completed_when               AS DATE         NO-UNDO.
  DEFINE INPUT PARAMETER  ip_completed_by                 AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_actual_hours                 AS DECIMAL      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_estimate_hours               AS DECIMAL      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_note_priority                AS INTEGER      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_note_status                  AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_note_type                    AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_note_user                    AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_status_notes                 AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_current_area                 AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_new_area                     AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_current_status               AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_new_status                   AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT PARAMETER op_tnot_rowid                   AS ROWID        NO-UNDO.
  DEFINE OUTPUT PARAMETER op_rejection                    AS CHARACTER    NO-UNDO.

  TRANSACTION-BLOCK:
  DO TRANSACTION:

    RUN rtb-update-task-notes (INPUT ip_task_number
                              ,INPUT ip_pmod
                              ,INPUT ip_obj_type
                              ,INPUT ip_object
                              ,INPUT ip_version
                              ,INPUT ip_entered_when
                              ,INPUT ip_completed_when
                              ,INPUT ip_completed_by
                              ,INPUT ip_actual_hours
                              ,INPUT ip_estimate_hours
                              ,INPUT ip_note_priority
                              ,INPUT ip_note_status
                              ,INPUT ip_note_type
                              ,INPUT ip_note_user
                              ,INPUT ip_status_notes
                              ,INPUT ip_current_area
                              ,INPUT ip_new_area
                              ,INPUT ip_current_status
                              ,INPUT ip_new_status
                              ,OUTPUT op_tnot_rowid
                              ,OUTPUT op_rejection).

    IF op_rejection <> "":U
    THEN
      UNDO TRANSACTION-BLOCK, LEAVE TRANSACTION-BLOCK.                        

  END. /* transaction-block */

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmADOExtAdd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmADOExtAdd Procedure 
PROCEDURE scmADOExtAdd :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT-OUTPUT PARAMETER pcObjectAddADO AS CHARACTER  NO-UNDO.

  /* Add .ado extension to logical Dynamics Data Objects */
  IF NUM-ENTRIES(pcObjectAddADO,".":U) > 1
  AND LOOKUP( ENTRY(NUM-ENTRIES(pcObjectAddADO,".":U),pcObjectAddADO,".":U) , "r,i,p,w,ado,xml,v,d,df" ) > 0
  THEN
    ASSIGN
      pcObjectAddADO = pcObjectAddADO.
  ELSE
    ASSIGN
      pcObjectAddADO = pcObjectAddADO + ".ado":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmADOExtDelete) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmADOExtDelete Procedure 
PROCEDURE scmADOExtDelete :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT-OUTPUT PARAMETER pcObjectDelADO AS CHARACTER  NO-UNDO.

  /* Del .ado extension from logical Dynamics Data Objects */
  ASSIGN
    pcObjectDelADO = REPLACE(pcObjectDelADO,".ado":U,"":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmADOExtReplace) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmADOExtReplace Procedure 
PROCEDURE scmADOExtReplace :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT-OUTPUT PARAMETER pcObjectReplaceADO AS CHARACTER  NO-UNDO.

  /* Replace .ado extension for logical Dynamics Data Objects */
  IF NUM-ENTRIES(pcObjectReplaceADO,".":U) > 1
  AND LOOKUP( ENTRY(NUM-ENTRIES(pcObjectReplaceADO,".":U),pcObjectReplaceADO,".":U) , "r,i,p,w,ado,xml,v,d,df" ) > 0
  THEN
    ASSIGN
      pcObjectReplaceADO = SUBSTRING(pcObjectReplaceADO,1,R-INDEX(pcObjectReplaceADO,".":U)) + "ado":U.
  ELSE
    ASSIGN
      pcObjectReplaceADO = pcObjectReplaceADO + ".ado":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmAssignObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmAssignObject Procedure 
PROCEDURE scmAssignObject :
/*------------------------------------------------------------------------------
  Purpose:     To assign an object version into a workspace
  Parameters:  SEE BELOW
  Notes:       Object type is PCODE
               Version is versioned being assigned to current workspace
               recid is recird of object record assigned
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_product_module               AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_type                  AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_name                  AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_version                      AS INTEGER      NO-UNDO.
  DEFINE OUTPUT PARAMETER op_recid                        AS RECID        NO-UNDO.
  DEFINE OUTPUT PARAMETER op_rejection                    AS CHARACTER    NO-UNDO.

  DEFINE VARIABLE lh_rtbplip                              AS HANDLE       NO-UNDO.

  /*- Run PP of API calls -*/
  IF NOT VALID-HANDLE(lh_rtbplip)
  THEN
    RUN rtb/p/rtb_api.p PERSISTENT SET lh_rtbplip.

  IF ip_product_module <> "":U
  THEN
    RUN scmSitePrefixAdd (INPUT-OUTPUT ip_product_module).

  RUN assign_object IN lh_rtbplip
                   (INPUT ip_product_module
                   ,INPUT ip_object_type
                   ,INPUT ip_object_name
                   ,INPUT ip_version
                   ,OUTPUT op_recid
                   ,OUTPUT op_rejection
                   ).

  IF VALID-HANDLE(lh_rtbplip)
  THEN
    DELETE PROCEDURE lh_rtbplip.

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmAssignObjectControl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmAssignObjectControl Procedure 
PROCEDURE scmAssignObjectControl :
/*------------------------------------------------------------------------------
  Purpose:     To assign an object version into a workspace
  Parameters:  SEE BELOW
  Notes:       Object type is PCODE
               Version is versioned being assigned to current workspace
               recid is recird of object record assigned
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_product_module               AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_type                  AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_name                  AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_version                      AS INTEGER      NO-UNDO.
  DEFINE OUTPUT PARAMETER op_recid                        AS RECID        NO-UNDO.
  DEFINE OUTPUT PARAMETER op_rejection                    AS CHARACTER    NO-UNDO.

  TRANSACTION-BLOCK:
  DO TRANSACTION:

    RUN scmAssignObject (INPUT ip_product_module
                        ,INPUT ip_object_type
                        ,INPUT ip_object_name
                        ,INPUT ip_version
                        ,OUTPUT op_recid
                        ,OUTPUT op_rejection).

    IF op_rejection <> "":U
    THEN
      UNDO TRANSACTION-BLOCK, LEAVE TRANSACTION-BLOCK.                        

  END. /* transaction-block */

  ERROR-STATUS:ERROR = NO.
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmCheckInObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmCheckInObject Procedure 
PROCEDURE scmCheckInObject :
/*------------------------------------------------------------------------------
  Purpose:     To check in an object
  Parameters:  SEE BELOW
  Notes:       If basline = YES then store full source forthis version
               Object type is PCODE
               Version is versioned being assigned to current workspace
               recid is recird of object record assigned
               NOTE: Not implemented warning for orphan conditions at this stage
               which is why ui_on flag is not checked - but is passed in to make 
               it easy to add the mod later if required.

               /* ICF-SCM-XML */
               Ensure .ado file is not empty.
               If empty populate with template xml file.

------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_baseline                     AS LOGICAL      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_product_module               AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_type                  AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_name                  AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_task_number                  AS INTEGER      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_ui_on                        AS LOGICAL      NO-UNDO.
  DEFINE OUTPUT PARAMETER op_rejection                    AS CHARACTER    NO-UNDO.

  DEFINE VARIABLE lh_rtbplip                              AS HANDLE       NO-UNDO.

  IF ip_product_module <> "":U
  THEN RUN scmSitePrefixAdd (INPUT-OUTPUT ip_product_module).

  /* ICF-SCM-XML */

  FIND FIRST rtb_task NO-LOCK
    WHERE rtb_task.task-num = ip_task_number
    NO-ERROR.
  IF NOT AVAILABLE rtb_task
  THEN DO:
    ASSIGN
      op_rejection = "Failed to create object: "  + ip_object_name
                   + " due to invalid task: "     + STRING(ip_task_number).
    RETURN.
  END.

  FIND FIRST rtb_wspace NO-LOCK
    WHERE rtb_wspace.wspace-id = rtb_task.wspace-id
    NO-ERROR.
  IF NOT AVAILABLE rtb_wspace
  THEN DO:
    ASSIGN
      op_rejection = "Failed to create object: "    + ip_object_name
                   + " due to invalid workspace: "  + rtb_task.wspace-id.
    RETURN.
  END.

  FIND FIRST rtb_object NO-LOCK
    WHERE rtb_object.object    = ip_object_name
    AND   rtb_object.wspace-id = rtb_wspace.wspace-id
    NO-ERROR.
  IF AVAILABLE rtb_object
  THEN
    FIND FIRST rtb_ver NO-LOCK 
      WHERE rtb_ver.obj-type = rtb_object.obj-type
      AND   rtb_ver.object   = rtb_object.object
      AND   rtb_ver.pmod     = rtb_object.pmod
      AND   rtb_ver.version  = rtb_object.version
      NO-ERROR.
  IF  AVAILABLE rtb_object
  AND AVAILABLE rtb_ver
  THEN
    FIND FIRST rtb_subtype NO-LOCK
      WHERE rtb_subtype.sub-type = rtb_ver.sub-type
      NO-ERROR.
  IF AVAILABLE rtb_subtype
  AND (rtb_subtype.part-ext[1]  = "ado"
    OR rtb_subtype.part-ext[2]  = "ado"
    OR rtb_subtype.part-ext[3]  = "ado"
    OR rtb_subtype.part-ext[4]  = "ado"
    OR rtb_subtype.part-ext[5]  = "ado"
    OR rtb_subtype.part-ext[6]  = "ado"
    OR rtb_subtype.part-ext[7]  = "ado"
    OR rtb_subtype.part-ext[8]  = "ado"
    OR rtb_subtype.part-ext[9]  = "ado"
    OR rtb_subtype.part-ext[10] = "ado"
      )
  THEN
  adoFileBlock:
  DO:

    DEFINE VARIABLE cAdoFileName                            AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cAdoTemplate                            AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cWorkspaceRoot                          AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cRelativePath                           AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cWorkspacePath                          AS CHARACTER    NO-UNDO.

    ASSIGN
      cAdoFileName = ip_object_name
      cAdoFileName = SUBSTRING(cAdoFileName,1,R-INDEX(cAdoFileName,".":U)) + "ado":U
      cAdoTemplate = "emptyxml.ado"
      .

    FIND FIRST rtb_pmod NO-LOCK
      WHERE rtb_pmod.pmod = ip_product_module
      NO-ERROR.
    IF AVAILABLE rtb_pmod
    THEN
      FIND FIRST rtb_moddef NO-LOCK
        WHERE rtb_moddef.module = rtb_pmod.module
        NO-ERROR.
      IF NOT AVAILABLE rtb_moddef
      THEN DO:
        ASSIGN
          op_rejection = "Failed to create object: "                             + ip_object_name
                       + " due to invalid workspace module for product module: " + ip_product_module.
        RETURN.
      END.

    /* Get module relative path and tidy up - also remove leading slash */
    ASSIGN
      cRelativePath = ENTRY(1,rtb_moddef.DIRECTORY)
      cRelativePath = REPLACE(cRelativePath,"~\":U,"/":U)
      .
    IF cRelativePath <> ""
    THEN
      DO WHILE SUBSTRING(cRelativePath,LENGTH(cRelativePath),1) = "/":
        cRelativePath = SUBSTRING(cRelativePath,1,LENGTH(cRelativePath) - 1).
      END.
    IF LENGTH(cRelativePath) > 1
    THEN
      DO WHILE SUBSTRING(cRelativePath,1,1) = "/":
        cRelativePath = SUBSTRING(cRelativePath,2,LENGTH(cRelativePath)).
      END.

    /* Check if the file exist and if the file is not 0 size */
    IF SEARCH(cRelativePath + "/":U + cAdoFileName) <> ?
    THEN DO:
      FILE-INFO:FILENAME = SEARCH(cRelativePath + "/":U + cAdoFileName).
      IF FILE-INFO:FILE-SIZE > 0
      THEN
        LEAVE adoFileBlock.
    END.

    /* Get workspace root directory and replace back slashes with forward slashes and remove any trailing slashes */
    IF rtb_wspace.wspace-path <> "":U
    THEN
      ASSIGN
        cWorkspaceRoot = ENTRY(1,rtb_wspace.wspace-path)
        cWorkspaceRoot = REPLACE(cWorkspaceRoot,"~\":U,"/":U)
        .
    IF cWorkspaceRoot <> ""
    THEN
      DO WHILE SUBSTRING(cWorkspaceRoot,LENGTH(cWorkspaceRoot),1) = "/":
        cWorkspaceRoot = SUBSTRING(cWorkspaceRoot,1,LENGTH(cWorkspaceRoot) - 1).
      END.

    /* Now work out full path to object for workspace */  
    ASSIGN
      cWorkspacePath = cWorkspaceRoot + (IF cRelativePath <> "":U THEN "/":U ELSE "":U) + cRelativePath
      .

    /* First see if directory exists and if not create it */
    ASSIGN
      op_rejection = "":U.
    FILE-INFO:FILENAME = cWorkspacePath.
    IF FILE-INFO:FILE-TYPE = ?
    OR INDEX(FILE-INFO:FILE-TYPE,"D":U) = 0
    THEN
      RUN createDirectory (INPUT cWorkspacePath, OUTPUT op_rejection). 

    IF op_rejection <> "":U
    THEN RETURN.

    IF cAdoTemplate <> "":U
    AND SEARCH(cAdoTemplate) <> ?
    THEN DO:
      OS-COPY VALUE(SEARCH(cAdoTemplate)) VALUE(cWorkspacePath + "/":U + cAdoFileName).
    END.
    ELSE DO:
      OUTPUT TO VALUE(cWorkspacePath + "/":U + cAdoFileName).
      DISPLAY "/* ICF-SCM-XML */ Dynamics Dynamic Object":U.
      OUTPUT CLOSE.  
    END.
    IF SEARCH(cWorkspacePath + "/":U + cAdoFileName) = ?
    THEN DO:
      ASSIGN
        op_rejection = "Failed to create physical file: " + cWorkspacePath + "/":U + cAdoFileName.     
      RETURN.
    END.

  END.

  /*- Run PP of API calls -*/
  IF NOT VALID-HANDLE(lh_rtbplip)
  THEN
    RUN rtb/p/rtb_api.p PERSISTENT SET lh_rtbplip.

  RUN check_in_object IN lh_rtbplip
                     (INPUT ip_baseline
                     ,INPUT ip_product_module
                     ,INPUT ip_object_type
                     ,INPUT ip_object_name
                     ,INPUT ip_task_number
                     ,OUTPUT op_rejection
                     ).

  IF VALID-HANDLE(lh_rtbplip)
  THEN
    DELETE PROCEDURE lh_rtbplip.

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmCheckInObjectControl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmCheckInObjectControl Procedure 
PROCEDURE scmCheckInObjectControl :
/*------------------------------------------------------------------------------
  Purpose:     To check in an object
  Parameters:  SEE BELOW
  Notes:       If basline = YES then store full source forthis version
               Object type is PCODE
               Version is versioned being assigned to current workspace
               recid is recird of object record assigned
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_baseline                     AS LOGICAL      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_product_module               AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_type                  AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_name                  AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_task_number                  AS INTEGER      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_ui_on                        AS LOGICAL      NO-UNDO.
  DEFINE OUTPUT PARAMETER op_rejection                    AS CHARACTER    NO-UNDO.

  TRANSACTION-BLOCK:
  DO TRANSACTION:

    RUN scmCheckInObject (INPUT ip_baseline
                         ,INPUT ip_product_module
                         ,INPUT ip_object_type
                         ,INPUT ip_object_name
                         ,INPUT ip_task_number
                         ,INPUT ip_ui_on
                         ,OUTPUT op_rejection).

    IF op_rejection <> "":U
    THEN
      UNDO TRANSACTION-BLOCK, LEAVE TRANSACTION-BLOCK.                        

  END. /* transaction-block */

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmCheckOutObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmCheckOutObject Procedure 
PROCEDURE scmCheckOutObject :
/*------------------------------------------------------------------------------
  Purpose:     To check out an object in a workspace under an open task
  Parameters:  SEE BELOW
  Notes:       Change type is patch, revision, or version
               Object type is PCODE
               recid is recid of object record checked out
              - If UI enabled, display messages for following errors, otherwise
                just stop and report an error - depending on flags
              - Display a warning if the object is in a product module that is not
                primary to the workspace.
              - Display a warning if orphan conditions exist
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_change_type                  AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_product_module               AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_type                  AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_name                  AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_task_number                  AS INTEGER      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_ui_on                        AS LOGICAL      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_allow_nonprimary             AS LOGICAL      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_allow_orphans                AS LOGICAL      NO-UNDO.
  DEFINE OUTPUT PARAMETER op_recid                        AS RECID        NO-UNDO.
  DEFINE OUTPUT PARAMETER op_rejection                    AS CHARACTER    NO-UNDO.

  DEFINE VARIABLE lh_rtbplip                              AS HANDLE       NO-UNDO.

  DEFINE VARIABLE lv_nonprimary                           AS LOGICAL      NO-UNDO.
  DEFINE VARIABLE lv_orphans                              AS LOGICAL      NO-UNDO.
  DEFINE VARIABLE lv_continue                             AS LOGICAL      NO-UNDO.

  IF ip_product_module <> "":U
  THEN
    RUN scmSitePrefixAdd (INPUT-OUTPUT ip_product_module).

  /* Check object is primary in workspace */
  IF NOT CAN-FIND(FIRST rtb_wspmod
                  WHERE rtb_wspmod.wspace-id  = Grtb-wspace-id
                  AND   rtb_wspmod.pmod       = ip_product_module
                  AND   rtb_wspmod.src-status = "PRI")
  THEN
    ASSIGN lv_nonprimary = YES.
  ELSE
    ASSIGN lv_nonprimary = NO.

  IF ip_ui_on = NO
  AND ip_allow_nonprimary = NO
  AND lv_nonprimary = YES
  THEN DO:
    ASSIGN
      op_recid = ?
      op_rejection = "Check-out failed - trying to modify object in non-primary workspace, object: " + ip_object_name
      .
    RETURN.
  END.

  IF ip_ui_on = YES
  AND lv_nonprimary = YES
  THEN DO:
    ASSIGN
      lv_continue = ip_allow_nonprimary.
    MESSAGE
      "You are creating a new version of " + ip_object_name + " in a product module that is not primary in this workspace." SKIP
      "Continue?"
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
      UPDATE lv_continue.
    IF lv_continue = NO
    THEN DO:
      ASSIGN
        op_recid = ?
        op_rejection = "Check-out failed - trying to modify object in non-primary workspace, object: " + ip_object_name
        .
      RETURN.
    END.
  END.

  /* warn of orphan conditions */
  DEFINE BUFFER lb_rtb_ver FOR rtb_ver.
  DEFINE BUFFER lb_rtb_object FOR rtb_object.

  FIND FIRST lb_rtb_object NO-LOCK
    WHERE lb_rtb_object.pmod      = ip_product_module
    AND   lb_rtb_object.obj-type  = ip_object_type
    AND   lb_rtb_object.object    = ip_object_name
    AND   lb_rtb_object.wspace-id = Grtb-wspace-id
    NO-ERROR.

  FIND FIRST lb_rtb_ver NO-LOCK  /* index is ascending, so FIND FIRST finds last */
    WHERE lb_rtb_ver.pmod      = ip_product_module
    AND   lb_rtb_ver.obj-type  = ip_object_type
    AND   lb_rtb_ver.object    = ip_object_name
    NO-ERROR.

  IF AVAILABLE lb_rtb_ver
  AND AVAILABLE lb_rtb_object
  AND lb_rtb_ver.version <> lb_rtb_object.version
  THEN
    ASSIGN lv_orphans = YES.
  ELSE
    ASSIGN lv_orphans = NO.

  IF ip_ui_on           = NO
  AND ip_allow_orphans  = NO
  AND lv_orphans        = YES
  THEN DO:
    ASSIGN
      op_recid = ?
      op_rejection = "Check-out failed - orphan conditions exist for object: " + ip_object_name
      .
    RETURN.
  END.

  IF ip_ui_on = YES
  AND lv_orphans = YES
  THEN DO:
    ASSIGN
      lv_continue = ip_allow_orphans.
    MESSAGE
      "Orphan conditions may exists for object " + ip_object_name + "." SKIP
      "Continue?"
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
      UPDATE lv_continue.
    IF lv_continue = NO
    THEN DO:
      ASSIGN
        op_recid = ?
        op_rejection = "Check-out failed - orphan conditions exist for object: " + ip_object_name
        .
      RETURN.
    END.
  END.

  /*- Run PP of API calls -*/
  IF NOT VALID-HANDLE(lh_rtbplip)
  THEN
    RUN rtb/p/rtb_api.p PERSISTENT SET lh_rtbplip.

  RUN check_out_object IN lh_rtbplip
                      (INPUT ip_change_type
                      ,INPUT ip_product_module
                      ,INPUT ip_object_type
                      ,INPUT ip_object_name
                      ,INPUT ip_task_number
                      ,OUTPUT op_recid
                      ,OUTPUT op_rejection
                      ).

  IF VALID-HANDLE(lh_rtbplip)
  THEN
    DELETE PROCEDURE lh_rtbplip.

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmCheckOutObjectControl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmCheckOutObjectControl Procedure 
PROCEDURE scmCheckOutObjectControl :
/*------------------------------------------------------------------------------
  Purpose:     To check out an object in a workspace under an open task
  Parameters:  SEE BELOW
  Notes:       Change type is patch, revision, or version
               Object type is PCODE
               recid is recid of object record checked out
              - If UI enabled, display messages for following errors, otherwise
                just stop and report an error - depending on flags
              - Display a warning if the object is in a product module that is not
                primary to the workspace.
              - Display a warning if orphan conditions exist
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_change_type                  AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_product_module               AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_type                  AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_name                  AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_task_number                  AS INTEGER      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_ui_on                        AS LOGICAL      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_allow_nonprimary             AS LOGICAL      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_allow_orphans                AS LOGICAL      NO-UNDO.
  DEFINE OUTPUT PARAMETER op_recid                        AS RECID        NO-UNDO.
  DEFINE OUTPUT PARAMETER op_rejection                    AS CHARACTER    NO-UNDO.

  TRANSACTION-BLOCK:
  DO TRANSACTION:

    RUN scmCheckOutObject (INPUT ip_change_type
                          ,INPUT ip_product_module
                          ,INPUT ip_object_type
                          ,INPUT ip_object_name
                          ,INPUT ip_task_number
                          ,INPUT ip_ui_on
                          ,INPUT ip_allow_nonprimary
                          ,INPUT ip_allow_orphans
                          ,OUTPUT op_recid
                          ,OUTPUT op_rejection).

    IF op_rejection <> "":U
    THEN
      UNDO TRANSACTION-BLOCK, LEAVE TRANSACTION-BLOCK.                        

  END. /* transaction-block */

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmCompileObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmCompileObject Procedure 
PROCEDURE scmCompileObject :
/*------------------------------------------------------------------------------
  Purpose:     To compile a single object
  Parameters:  SEE BELOW
  Notes:       Object type is PCODE
               Show errors should be set to NO
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_object_type                  AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_name                  AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_save_rcode                   AS LOGICAL      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_with_xref                    AS LOGICAL      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_with_listings                AS LOGICAL      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_show_errors                  AS LOGICAL      NO-UNDO.
  DEFINE OUTPUT PARAMETER op_rejection                    AS CHARACTER    NO-UNDO.

  DEFINE VARIABLE lh_rtbplip                              AS HANDLE       NO-UNDO.

  /*- Run PP of API calls -*/
  IF NOT VALID-HANDLE(lh_rtbplip)
  THEN
    RUN rtb/p/rtb_api.p PERSISTENT SET lh_rtbplip.

  RUN compile_object IN lh_rtbplip
                    (INPUT ip_object_type
                    ,INPUT ip_object_name
                    ,INPUT ip_save_rcode
                    ,INPUT ip_with_xref
                    ,INPUT ip_with_listings
                    ,INPUT ip_show_errors
                    ,OUTPUT op_rejection
                    ).

  IF VALID-HANDLE(lh_rtbplip)
  THEN
    DELETE PROCEDURE lh_rtbplip.

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmCompileObjectControl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmCompileObjectControl Procedure 
PROCEDURE scmCompileObjectControl :
/*------------------------------------------------------------------------------
  Purpose:     To compile a single object
  Parameters:  SEE BELOW
  Notes:       Object type is PCODE
               Show errors should be set to NO
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_object_type                  AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_name                  AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_save_rcode                   AS LOGICAL      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_with_xref                    AS LOGICAL      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_with_listings                AS LOGICAL      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_show_errors                  AS LOGICAL      NO-UNDO.
  DEFINE OUTPUT PARAMETER op_rejection                    AS CHARACTER    NO-UNDO.

  TRANSACTION-BLOCK:
  DO TRANSACTION:

    RUN scmCompileObject (INPUT ip_object_type
                         ,INPUT ip_object_name
                         ,INPUT ip_save_rcode
                         ,INPUT ip_with_xref
                         ,INPUT ip_with_listings
                         ,INPUT ip_show_errors
                         ,OUTPUT op_rejection).

    IF op_rejection <> "":U
    THEN
      UNDO TRANSACTION-BLOCK, LEAVE TRANSACTION-BLOCK.                        

  END. /* transaction-block */

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmCompleteTask) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmCompleteTask Procedure 
PROCEDURE scmCompleteTask :
/*------------------------------------------------------------------------------
  Purpose:     To complete a task
  Parameters:  SEE BELOW
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_task_number                  AS INTEGER      NO-UNDO.
  DEFINE OUTPUT PARAMETER op_rejection                    AS CHARACTER    NO-UNDO.

  DEFINE VARIABLE lh_rtbplip                              AS HANDLE       NO-UNDO.

  /*- Run PP of API calls -*/
  IF NOT VALID-HANDLE(lh_rtbplip)
  THEN
    RUN rtb/p/rtb_api.p PERSISTENT SET lh_rtbplip.

  RUN complete_task IN lh_rtbplip
                   (INPUT ip_task_number
                   ,OUTPUT op_rejection
                   ).

  IF VALID-HANDLE(lh_rtbplip)
  THEN
    DELETE PROCEDURE lh_rtbplip.

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmCompleteTaskControl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmCompleteTaskControl Procedure 
PROCEDURE scmCompleteTaskControl :
/*------------------------------------------------------------------------------
  Purpose:     To complete a task
  Parameters:  SEE BELOW
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_task_number                  AS INTEGER      NO-UNDO.
  DEFINE OUTPUT PARAMETER op_rejection                    AS CHARACTER    NO-UNDO.

  TRANSACTION-BLOCK:
  DO TRANSACTION:

    RUN scmCompleteTask (INPUT ip_task_number
                        ,OUTPUT op_rejection).

    IF op_rejection <> "":U
    THEN
      UNDO TRANSACTION-BLOCK, LEAVE TRANSACTION-BLOCK.                        

  END. /* transaction-block */

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmCreateObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmCreateObject Procedure 
PROCEDURE scmCreateObject :
/*------------------------------------------------------------------------------
  Purpose:     To create an object
  Parameters:  SEE BELOW
  Notes:       Object type is usually PCODE
               If the object name parameter begins with the "@" character (an
               alias), this routine will check for part names in the ip_options
               string.  This should be a comma delimited list of relative path
               name and file name.(ex: "reports/rpt1.p")
               If ui_on is set to TRUE, you want user interaction...
               If this is set to FALSE, Roundtable will not prompt for user
               intervention and default to YES on all questions. 
               The SCM tool API does not provide a facility to create the object
               centrally, even though the task is a share status other than
               central, plus it does not create the physical file on the disk, 
               therefore we do all this manually with extra input parameters 
               into this procedure.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_object_name                  AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_type                  AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_sub_type                     AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_product_module               AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_group                        AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_level                        AS INTEGER      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_description           AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_options                      AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_task_number                  AS INTEGER      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_ui_on                        AS LOGICAL      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_share_status                 AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_create_physical_file         AS LOGICAL      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_physical_file_template       AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT PARAMETER op_recid                        AS RECID        NO-UNDO.
  DEFINE OUTPUT PARAMETER op_rejection                    AS CHARACTER    NO-UNDO.

  DEFINE VARIABLE lh_rtbplip                              AS HANDLE       NO-UNDO.
  DEFINE VARIABLE lv_full_object_name                     AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE lv_relative_path                        AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE lv_task_root                            AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE lv_task_path                            AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE lv_workspace_root                       AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE lv_workspace_path                       AS CHARACTER    NO-UNDO.

  DEFINE VARIABLE iObjectLoop                             AS INTEGER      NO-UNDO.
  DEFINE VARIABLE cObjectRoot                             AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cObjectPath                             AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cXMLRelativeName                        AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hTable01                                AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTable02                                AS HANDLE     NO-UNDO.

  DEFINE BUFFER lb_rtb_object FOR rtb_object.

  ASSIGN
    lv_full_object_name = ip_object_name.
  RUN scmADOExtAdd (INPUT-OUTPUT lv_full_object_name).

  IF ip_product_module <> "":U
  THEN
    RUN scmSitePrefixAdd (INPUT-OUTPUT ip_product_module).
  
  IF ip_create_physical_file = YES
  THEN
  createPhysicalFileBlock:
  DO:

    /* Work out info to create file / change share status, etc. */
    DEFINE BUFFER lb_rtb_task   FOR rtb_task.
    DEFINE BUFFER lb_rtb_wspace FOR rtb_wspace.
    DEFINE BUFFER lb_rtb_moddef FOR rtb_moddef.
    DEFINE BUFFER lb_rtb_pmod   FOR rtb_pmod.

    FIND FIRST lb_rtb_task NO-LOCK
      WHERE lb_rtb_task.task-num = ip_task_number
      NO-ERROR.
    IF NOT AVAILABLE lb_rtb_task
    THEN DO:
      ASSIGN
        op_rejection = "Failed to create object: " + ip_object_name + " due to invalid task: " + STRING(ip_task_number).
      RETURN.
    END.

    FIND FIRST lb_rtb_wspace NO-LOCK
      WHERE lb_rtb_wspace.wspace-id = lb_rtb_task.wspace-id
      NO-ERROR.
    IF NOT AVAILABLE lb_rtb_wspace
    THEN DO:
      ASSIGN
        op_rejection = "Failed to create object: " + ip_object_name + " due to invalid workspace: " + lb_rtb_task.wspace-id.
      RETURN.
    END.

    FIND FIRST lb_rtb_pmod NO-LOCK
      WHERE lb_rtb_pmod.pmod = ip_product_module
      NO-ERROR.
    IF AVAILABLE lb_rtb_pmod
    THEN
      FIND FIRST lb_rtb_moddef NO-LOCK
        WHERE lb_rtb_moddef.module = lb_rtb_pmod.module
        NO-ERROR.
    IF NOT AVAILABLE lb_rtb_moddef
    THEN DO:
      ASSIGN
        op_rejection = "Failed to create object: " + ip_object_name + " due to invalid workspace module for product module: " + ip_product_module.
      RETURN.
    END.

    /* Get workspace root directory and replace back slashes with forward slashes and remove any trailing slashes */
    IF lb_rtb_wspace.wspace-path <> "":U
    THEN
      ASSIGN
        lv_workspace_root = ENTRY(1,lb_rtb_wspace.wspace-path)
        lv_workspace_root = REPLACE(lv_workspace_root,"~\":U,"/":U)
        .
    IF lv_workspace_root <> ""
    THEN
      DO WHILE SUBSTRING(lv_workspace_root,LENGTH(lv_workspace_root),1) = "/":
        lv_workspace_root = SUBSTRING(lv_workspace_root,1,LENGTH(lv_workspace_root) - 1).
      END.

    /* Get task root directory and clean it up */  
    IF lb_rtb_task.task-directory <> "":U
    THEN
      ASSIGN
        lv_task_root = ENTRY(1,lb_rtb_task.task-directory)
        lv_task_root = REPLACE(lv_task_root,"~\":U,"/":U)
        .
    IF lv_task_root <> ""
    THEN
      DO WHILE SUBSTRING(lv_task_root,LENGTH(lv_task_root),1) = "/":
        lv_task_root = SUBSTRING(lv_task_root,1,LENGTH(lv_task_root) - 1).
      END.

    /* Get module relative path and tidy up - also remove leading slash */
    ASSIGN
      lv_relative_path = ENTRY(1,lb_rtb_moddef.directory)
      lv_relative_path = REPLACE(lv_relative_path,"~\":U,"/":U)
      .
    IF lv_relative_path <> ""
    THEN
      DO WHILE SUBSTRING(lv_relative_path,LENGTH(lv_relative_path),1) = "/":
        lv_relative_path = SUBSTRING(lv_relative_path,1,LENGTH(lv_relative_path) - 1).
      END.
    IF LENGTH(lv_relative_path) > 1
    THEN
      DO WHILE SUBSTRING(lv_relative_path,1,1) = "/":
        lv_relative_path = SUBSTRING(lv_relative_path,2,LENGTH(lv_relative_path)).
      END.

    /* Now work out full path to object for workspace and task */  
    ASSIGN
      lv_workspace_path = lv_workspace_root + (IF lv_relative_path <> "":U THEN "/":U ELSE "":U) + lv_relative_path
      lv_task_path      = lv_task_root      + (IF lv_relative_path <> "":U THEN "/":U ELSE "":U) + lv_relative_path
      .

    ASSIGN
      cXMLRelativeName  = lv_relative_path + "~/":U + lv_full_object_name.
      .

    createObjectBlock:
    DO iObjectLoop = 1 TO 2:

      /* iObjectLoop = 1 : Create in workspace directory even if share status is task */
      /* iObjectLoop = 2 : If share status of task the create in task directory       */
      IF iObjectLoop = 1
      THEN
        ASSIGN
          cObjectRoot = lv_workspace_root
          cObjectPath = lv_workspace_path
          .
      ELSE
      IF iObjectLoop = 2
      AND ip_share_status BEGINS "T":U   /* task share status - create in task directory */
      THEN
        ASSIGN
          cObjectRoot = lv_task_root
          cObjectPath = lv_task_path
          .

      ASSIGN
        op_rejection = "":U.
      FILE-INFO:FILENAME = cObjectPath.
      IF FILE-INFO:FILE-TYPE = ?
      OR INDEX(FILE-INFO:FILE-TYPE,"D":U) = 0
      THEN
        RUN createDirectory (INPUT cObjectPath, OUTPUT op_rejection).
      IF op_rejection <> "":U
      THEN RETURN.

      IF SEARCH( cXMLRelativeName ) <> ?
      THEN DO:
        FILE-INFO:FILENAME = SEARCH(cXMLRelativeName).
        IF FILE-INFO:FILE-SIZE > 0
        THEN LEAVE createPhysicalFileBlock.
      END.

      IF ip_physical_file_template <> "":U
      AND SEARCH(ip_physical_file_template) <> ?
      THEN DO:
        OS-COPY VALUE(SEARCH(ip_physical_file_template)) VALUE(cObjectRoot + "~/":U + cXMLRelativeName).
      END.
      ELSE DO:

        ASSIGN
          hTable01      = ?
          hTable02      = ?
          .

        {launch.i &PLIP = 'af/app/gscddxmlp.p'
                  &IProc = 'writeDeploymentDataset'
                  &PList = "(INPUT 'RYCSO':U~
                            ,INPUT ip_object_name~
                            ,INPUT cXMLRelativeName~
                            ,INPUT cObjectRoot~
                            ,INPUT YES~
                            ,INPUT YES~
                            ,INPUT TABLE-HANDLE hTable01~
                            ,INPUT TABLE-HANDLE hTable02~
                            ,OUTPUT op_rejection)"
                  &OnApp = 'no'
                  &Autokill = YES}

      END.

      /* Check if the file exist and if the file is not 0 size */
      IF SEARCH(cXMLRelativeName) <> ?
      THEN DO:

        FILE-INFO:FILENAME = SEARCH(cXMLRelativeName).
        IF FILE-INFO:FILE-SIZE = 0
        THEN DO:
          OUTPUT TO VALUE(SEARCH(cXMLRelativeName)).
          DISPLAY "/* ICF-SCM-XML : Dynamics Dynamic Object */ ":U.
          OUTPUT CLOSE.  
        END.

      END.
      ELSE DO:

        OUTPUT TO VALUE(cObjectRoot + "~/":U + cXMLRelativeName).
        DISPLAY "/* ICF-SCM-XML : Dynamics Dynamic Object */ ":U.
        OUTPUT CLOSE.  

        IF SEARCH(cXMLRelativeName) = ?
        THEN DO:
          ASSIGN
            op_rejection = "Failed to create physical file: " + cXMLRelativeName.     
          RETURN.
        END.

      END.

    END.

  END.  /* If create physical file = yes */

  /*- Run PP of API calls -*/
  IF NOT VALID-HANDLE(lh_rtbplip)
  THEN
    RUN rtb/p/rtb_api.p PERSISTENT SET lh_rtbplip.

  RUN create_object IN lh_rtbplip
                   (INPUT  lv_full_object_name
                   ,INPUT  ip_object_type
                   ,INPUT  ip_sub_type
                   ,INPUT  ip_product_module
                   ,INPUT  ip_group
                   ,INPUT  ip_level
                   ,INPUT  ip_object_description
                   ,INPUT  ip_options
                   ,INPUT  ip_task_number
                   ,INPUT  ip_ui_on
                   ,OUTPUT op_recid
                   ,OUTPUT op_rejection
                   ).

  IF VALID-HANDLE(lh_rtbplip)
  THEN
    DELETE PROCEDURE lh_rtbplip.

  /* Re-find object and update share-status of object */
  IF ip_share_status <> "":U
  THEN DO FOR lb_rtb_object:
    FIND FIRST lb_rtb_object EXCLUSIVE-LOCK
      WHERE RECID(lb_rtb_object) = op_recid
      NO-ERROR. 
    IF AVAILABLE lb_rtb_object
    THEN DO:
      ASSIGN
        lb_rtb_object.share-status = ip_share_status.
      RELEASE lb_rtb_object.   
    END.
  END.

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmCreateObjectControl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmCreateObjectControl Procedure 
PROCEDURE scmCreateObjectControl :
/*------------------------------------------------------------------------------
  Purpose:     To create an object
  Parameters:  SEE BELOW
  Notes:       Object type is usually PCODE
               If the object name parameter begins with the "@" character (an
               alias), this routine will check for part names in the ip_options
               string.  This should be a comma delimited list of relative path
               name and file name.(ex: "reports/rpt1.p")
               If ui_on is set to TRUE, you want user interaction...
               If this is set to FALSE, Roundtable will not prompt for user
               intervention and default to YES on all questions. 
               The SCM tool API does not provide a facility to create the object
               centrally, even though the task is a share status other than
               central, plus it does not create the physical file on the disk, 
               therefore we do all this manually with extra input parameters 
               into this procedure.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_object_name                  AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_type                  AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_sub_type                     AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_product_module               AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_group                        AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_level                        AS INTEGER      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_description           AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_options                      AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_task_number                  AS INTEGER      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_ui_on                        AS LOGICAL      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_share_status                 AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_create_physical_file         AS LOGICAL      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_physical_file_template       AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT PARAMETER op_recid                        AS RECID        NO-UNDO.
  DEFINE OUTPUT PARAMETER op_rejection                    AS CHARACTER    NO-UNDO.

  TRANSACTION-BLOCK:
  DO TRANSACTION:

    RUN scmCreateObject (INPUT ip_object_name
                        ,INPUT ip_object_type
                        ,INPUT ip_sub_type
                        ,INPUT ip_product_module
                        ,INPUT ip_group
                        ,INPUT ip_level
                        ,INPUT ip_object_description
                        ,INPUT ip_options
                        ,INPUT ip_task_number
                        ,INPUT ip_ui_on
                        ,INPUT ip_share_status
                        ,INPUT ip_create_physical_file
                        ,INPUT ip_physical_file_template
                        ,OUTPUT op_recid
                        ,OUTPUT op_rejection).

    IF op_rejection <> "":U
    THEN
      UNDO TRANSACTION-BLOCK, LEAVE TRANSACTION-BLOCK.                        

  END. /* transaction-block */

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmCreateTask) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmCreateTask Procedure 
PROCEDURE scmCreateTask :
/*------------------------------------------------------------------------------
  Purpose:     To create a new task
  Parameters:  SEE BELOW
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_task_summary                 AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_completed_by                 AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_completed_date               AS DATE         NO-UNDO.
  DEFINE INPUT PARAMETER  ip_entered_date                 AS DATE         NO-UNDO.
  DEFINE INPUT PARAMETER  ip_manager                      AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_programmer                   AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_share_status                 AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_task_directory               AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_user_reference               AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_workspace                    AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_task_notes                   AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT PARAMETER op_task_number                  AS INTEGER      NO-UNDO.
  DEFINE OUTPUT PARAMETER op_task_rowid                   AS ROWID        NO-UNDO.
  DEFINE OUTPUT PARAMETER op_rejection                    AS CHARACTER    NO-UNDO.

  DEFINE BUFFER lb_rtb_task FOR rtb_task.

  DEFINE VARIABLE lv_loop                                 AS INTEGER      NO-UNDO.
  DEFINE VARIABLE lv_character                            AS CHARACTER    NO-UNDO.

  DEFINE VARIABLE lh_rtbplip                              AS HANDLE       NO-UNDO.
  DEFINE VARIABLE lv_recid                                AS RECID        NO-UNDO.

  DO FOR lb_rtb_task:

    IF grtb-wspace-id = "":U
    THEN
      ASSIGN
        grtb-wspace-id = ip_workspace.

    /*    /*- Set security for user -*/
     *     IF Grtb-userid <> "" THEN
     *       RUN rtb/p/rtb_bsec.p (INPUT  Grtb-userid,
     *                             OUTPUT Grtb-access).
     *     
     *     IF Grtb-access = "":U OR Grtb-access = "*":U THEN
     *         ASSIGN Grtb-access = "task-create".*/

    /* create the task */    

    /*- Run PP of API calls -*/
    IF NOT VALID-HANDLE(lh_rtbplip)
    THEN
      RUN rtb/p/rtb_api.p PERSISTENT SET lh_rtbplip.

    RUN create_task IN lh_rtbplip
                   (INPUT ip_workspace
                   ,INPUT ip_programmer
                   ,INPUT ip_manager
                   ,OUTPUT lv_recid
                   ,OUTPUT op_rejection
                   ).

    IF VALID-HANDLE(lh_rtbplip)
    THEN
      DELETE PROCEDURE lh_rtbplip.

    IF op_rejection <> "":U
    THEN RETURN.

    /* re-read the task just created */
    FIND FIRST lb_rtb_task EXCLUSIVE-LOCK
      WHERE RECID(lb_rtb_task) = lv_recid
      NO-WAIT NO-ERROR.
    IF NOT AVAILABLE lb_rtb_task
    THEN DO:
      IF LOCKED lb_rtb_task
      THEN
        ASSIGN
          op_rejection = "Unable to update created RTB Task as it is locked by another user".
      ELSE
        ASSIGN
          op_rejection = "Unable to update created RTB Task as it has been deleted.".
      RETURN.
    END.

    ASSIGN
      lb_rtb_task.summary         = ip_task_summary
      lb_rtb_task.compltd-by      = ip_completed_by
      lb_rtb_task.compltd-when    = ip_completed_date
      lb_rtb_task.entered-when    = ip_entered_date
      lb_rtb_task.manager         = ip_manager
      lb_rtb_task.programmer      = ip_programmer
      lb_rtb_task.share-status    = ip_share_status
      lb_rtb_task.task-directory  = ip_task_directory
      lb_rtb_task.wspace-id       = ip_workspace
      lb_rtb_task.user-task-ref   = ip_user_reference
      NO-ERROR.

    IF ERROR-STATUS:ERROR
    THEN DO:
      ASSIGN
        op_rejection = "Unable to update created RTB Task due to invalid data"
        NO-ERROR.
      RETURN.
    END.

    DO lv_loop = 1 TO 15:
      IF lv_loop <= NUM-ENTRIES(ip_task_notes,CHR(10))
      THEN
        ASSIGN
          lv_character = REPLACE(ENTRY(lv_loop,ip_task_notes,CHR(10)),"|":U," ":U).
      ELSE
        ASSIGN
          lv_character = "":U.
      ASSIGN        
        lb_rtb_task.description[lv_loop] = lv_character.
    END.

    /* No point in doing validation keyword as RTB has no triggers */
    ASSIGN
      op_task_rowid   = ROWID(lb_rtb_task)
      op_task_number  = lb_rtb_task.task-num
      .
    RELEASE lb_rtb_task NO-ERROR.

    ASSIGN
      op_rejection = "":U NO-ERROR.    

  END.    /* do for */

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmCreateTaskControl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmCreateTaskControl Procedure 
PROCEDURE scmCreateTaskControl :
/*------------------------------------------------------------------------------
  Purpose:     To create a new task
  Parameters:  SEE BELOW
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_task_summary                 AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_completed_by                 AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_completed_date               AS DATE         NO-UNDO.
  DEFINE INPUT PARAMETER  ip_entered_date                 AS DATE         NO-UNDO.
  DEFINE INPUT PARAMETER  ip_manager                      AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_programmer                   AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_share_status                 AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_task_directory               AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_user_reference               AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_workspace                    AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_task_description             AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT PARAMETER op_task_number                  AS INTEGER      NO-UNDO.
  DEFINE OUTPUT PARAMETER op_task_rowid                   AS ROWID        NO-UNDO.
  DEFINE OUTPUT PARAMETER op_rejection                    AS CHARACTER    NO-UNDO.

  TRANSACTION-BLOCK:
  DO TRANSACTION:

    RUN scmCreateTask (INPUT ip_task_summary
                      ,INPUT ip_completed_by
                      ,INPUT ip_completed_date
                      ,INPUT ip_entered_date
                      ,INPUT ip_manager
                      ,INPUT ip_programmer
                      ,INPUT ip_share_status
                      ,INPUT ip_task_directory
                      ,INPUT ip_user_reference
                      ,INPUT ip_workspace
                      ,INPUT ip_task_description
                      ,OUTPUT op_task_number
                      ,OUTPUT op_task_rowid
                      ,OUTPUT op_rejection).

    IF op_rejection <> "":U
    THEN
      UNDO TRANSACTION-BLOCK, LEAVE TRANSACTION-BLOCK.                        

  END. /* transaction-block */

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmCreateXref) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmCreateXref Procedure 
PROCEDURE scmCreateXref :
/*------------------------------------------------------------------------------
  Purpose:     To create XREF records for non progress objects
  Parameters:  SEE BELOW
  Notes:       input xref temp-table and a log filename for where to log errors
               The temp-table structure is defined at the top of this file and
               contains a record for every object relation you want to create
               where.
               src-object    = Name of object in the selected workspace that
                               contains the reference (e.g. if "program.java"
                               references "java.class", this field should
                               contain "program.java").
               ref-type      = Valid reference type as listed in the Progress
                               Language Reference under the COMPILE statement
                               following the XREF parameter (i.e. "RUN",
                               "INCLUDE", "CREATE", etc.).
               obj-text[1-4] = Valid object identifier as shown in the Progress
                               Language Reference under the COMPILE statement
                               following the XREF parameter. Each element of
                               the object identifier separated by a space should
                               be placed in an extent of this field.
                               Examples:
                               ref-type    : INCLUDE
                               obj-text[1] : include-file-name
                               obj-text[2] : ""
                               obj-text[3] : ""
                               obj-text[4] : ""

                               ref-type    : ACCESS
                               obj-text[1] : database.table
                               obj-text[2] : field
                               obj-text[3] : ""
                               obj-text[4] : ""

                               ref-type    : FUNCTION
                               obj-text[1] : function-name,return-type
                               obj-text[2] : ""
                               obj-text[3] : ""
                               obj-text[4] : ""

------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER TABLE FOR TTxref.
  DEFINE INPUT PARAMETER  ip_log_file                     AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT PARAMETER op_rejection                    AS CHARACTER    NO-UNDO.

  DEFINE VARIABLE lh_rtbplip                              AS HANDLE       NO-UNDO.

  /*- Run PP of API calls -*/
  IF NOT VALID-HANDLE(lh_rtbplip)
  THEN
    RUN rtb/p/rtb_api.p PERSISTENT SET lh_rtbplip.

  RUN create_xrefs IN lh_rtbplip
                  (INPUT TABLE TTxref
                  ,INPUT ip_log_file
                  ,OUTPUT op_rejection
                  ).

  IF VALID-HANDLE(lh_rtbplip)
  THEN
    DELETE PROCEDURE lh_rtbplip.

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmCreateXrefControl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmCreateXrefControl Procedure 
PROCEDURE scmCreateXrefControl :
/*------------------------------------------------------------------------------
  Purpose:     To create XREF records for non progress objects
  Parameters:  SEE BELOW
  Notes:       input xref temp-table and a log filename for where to log errors
               The temp-table structure is defined at the top of this file and
               contains a record for every object relation you want to create
               where.
               src-object    = Name of object in the selected workspace that
                               contains the reference (e.g. if "program.java"
                               references "java.class", this field should
                               contain "program.java").
               ref-type      = Valid reference type as listed in the Progress
                               Language Reference under the COMPILE statement
                               following the XREF parameter (i.e. "RUN",
                               "INCLUDE", "CREATE", etc.).
               obj-text[1-4] = Valid object identifier as shown in the Progress
                               Language Reference under the COMPILE statement
                               following the XREF parameter. Each element of
                               the object identifier separated by a space should
                               be placed in an extent of this field.
                               Examples:
                               ref-type    : INCLUDE
                               obj-text[1] : include-file-name
                               obj-text[2] : ""
                               obj-text[3] : ""
                               obj-text[4] : ""

                               ref-type    : ACCESS
                               obj-text[1] : database.table
                               obj-text[2] : field
                               obj-text[3] : ""
                               obj-text[4] : ""

                               ref-type    : FUNCTION
                               obj-text[1] : function-name,return-type
                               obj-text[2] : ""
                               obj-text[3] : ""
                               obj-text[4] : ""

------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER TABLE FOR TTxref.
  DEFINE INPUT PARAMETER  ip_log_file                     AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT PARAMETER op_rejection                    AS CHARACTER    NO-UNDO.

  TRANSACTION-BLOCK:
  DO TRANSACTION:

    RUN scmCreateXref (INPUT TABLE TTxref
                      ,INPUT ip_log_file
                      ,OUTPUT op_rejection).

    IF op_rejection <> "":U
    THEN
      UNDO TRANSACTION-BLOCK, LEAVE TRANSACTION-BLOCK.                        

  END. /* transaction-block */

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmDeleteObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmDeleteObject Procedure 
PROCEDURE scmDeleteObject :
/*------------------------------------------------------------------------------
  Purpose:     To delete an object
  Parameters:  SEE BELOW
  Notes:       Object type is PCODE
               Task number may be 0 but is requierd if object is WIP
               Params is a comma delimited list of optional parameters, e.g.
               "No-Prompt", "No-Delete-Source"
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_product_module               AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_type                  AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_name                  AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_task_number                  AS INTEGER      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_params                       AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT PARAMETER op_rejection                    AS CHARACTER    NO-UNDO.

  DEFINE VARIABLE lh_rtbplip                              AS HANDLE       NO-UNDO.

  /*- Run PP of API calls -*/
  IF NOT VALID-HANDLE(lh_rtbplip)
  THEN
    RUN rtb/p/rtb_api.p PERSISTENT SET lh_rtbplip.

  IF ip_product_module <> "":U
  THEN
    RUN scmSitePrefixAdd (INPUT-OUTPUT ip_product_module).

  RUN delete_object IN lh_rtbplip
                   (INPUT ip_product_module
                   ,INPUT ip_object_type
                   ,INPUT ip_object_name
                   ,INPUT ip_task_number
                   ,INPUT ip_params
                   ,OUTPUT op_rejection
                   ).

  IF VALID-HANDLE(lh_rtbplip)
  THEN
    DELETE PROCEDURE lh_rtbplip.

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmDeleteObjectControl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmDeleteObjectControl Procedure 
PROCEDURE scmDeleteObjectControl :
/*------------------------------------------------------------------------------
  Purpose:     To delete an object
  Parameters:  SEE BELOW
  Notes:       Object type is PCODE
               Task number may be 0 but is requierd if object is WIP
               Params is a comma delimited list of optional parameters, e.g.
               "No-Prompt", "No-Delete-Source"
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_product_module               AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_type                  AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_name                  AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_task_number                  AS INTEGER      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_params                       AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT PARAMETER op_rejection                    AS CHARACTER    NO-UNDO.

  TRANSACTION-BLOCK:
  DO TRANSACTION:

    RUN scmDeleteObject (INPUT ip_product_module
                        ,INPUT ip_object_type
                        ,INPUT ip_object_name
                        ,INPUT ip_task_number
                        ,INPUT ip_params
                        ,OUTPUT op_rejection).

    IF op_rejection <> "":U
    THEN
      UNDO TRANSACTION-BLOCK, LEAVE TRANSACTION-BLOCK.                        

  END. /* transaction-block */

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmExtractObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmExtractObject Procedure 
PROCEDURE scmExtractObject :
/*------------------------------------------------------------------------------
  Purpose:     To extract source code from the repository
  Parameters:  SEE BELOW
  Notes:       Object type is PCODE
               version is version to extract from the repository
               root directory is directory to put extracted object under
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_product_module               AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_type                  AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_name                  AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_version                      AS INTEGER      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_root_dir                     AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT PARAMETER op_rejection                    AS CHARACTER    NO-UNDO.

  DEFINE VARIABLE lh_rtbplip                              AS HANDLE       NO-UNDO.

  /*- Run PP of API calls -*/
  IF NOT VALID-HANDLE(lh_rtbplip)
  THEN
    RUN rtb/p/rtb_api.p PERSISTENT SET lh_rtbplip.

  IF ip_product_module <> "":U
  THEN
    RUN scmSitePrefixAdd (INPUT-OUTPUT ip_product_module).

  RUN extract_object IN lh_rtbplip
                    (INPUT ip_product_module
                    ,INPUT ip_object_type
                    ,INPUT ip_object_name
                    ,INPUT ip_version
                    ,INPUT ip_root_dir
                    ,OUTPUT op_rejection
                    ).

  IF VALID-HANDLE(lh_rtbplip)
  THEN
    DELETE PROCEDURE lh_rtbplip.

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmExtractObjectControl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmExtractObjectControl Procedure 
PROCEDURE scmExtractObjectControl :
/*------------------------------------------------------------------------------
  Purpose:     To extract source code from the repository
  Parameters:  SEE BELOW
  Notes:       Object type is PCODE
               version is version to extract from the repository
               root directory is directory to put extracted object under
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_product_module               AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_type                  AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_name                  AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_version                      AS INTEGER      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_root_dir                     AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT PARAMETER op_rejection                    AS CHARACTER    NO-UNDO.

  TRANSACTION-BLOCK:
  DO TRANSACTION:

    RUN scmExtractObject (INPUT ip_product_module
                         ,INPUT ip_object_type
                         ,INPUT ip_object_name
                         ,INPUT ip_version
                         ,INPUT ip_root_dir
                         ,OUTPUT op_rejection).

    IF op_rejection <> "":U
    THEN
      UNDO TRANSACTION-BLOCK, LEAVE TRANSACTION-BLOCK.                        

  END. /* transaction-block */

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmFullObjectInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmFullObjectInfo Procedure 
PROCEDURE scmFullObjectInfo :
/*------------------------------------------------------------------------------
  Purpose:     To retrieve LOTS of details about an object in the SCM tool 
               depending on what is passed in.
  Parameters:  input object name (including extension and .ado if logical)
               input current / required workspace
               input current / required task (to get workspace from)
               output object exists in RTB flag
               output object exists in Workspace flag
               output object version number in workspace
               output object product module in workspace
               output object checked out in workspace flag
               output object version created in which task number
               output object latest version number for current module
               output summary description of object
               output pipe delimited list for full object description
               output current version update notes
               output comma seperated list of object versions before the current version

  Notes:       If no workspace is passed in, current workspace will be used
               If no task is passed in, current task will be used.
               If no current workspace or task and not passed in - certain 
               details will not be available.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  pcObject                    AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  pcWorkspace                 AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  piTask                      AS INTEGER    NO-UNDO.
  DEFINE OUTPUT PARAMETER plExistsInSCM               AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER plExistsInWorkspace         AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER piWorkspaceVersion          AS INTEGER    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcWorkspaceModule           AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER plWorkspaceCheckedOut       AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER piVersioninTask             AS INTEGER    NO-UNDO.
  DEFINE OUTPUT PARAMETER piLastestVersion            AS INTEGER    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcObjectSummary             AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcObjectDescription         AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcObjectUpdNotes            AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcPrevVersions              AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE iLoop                               AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iEntries                            AS INTEGER NO-UNDO.
  DEFINE VARIABLE cChar                               AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cLine                               AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cText                               AS CHARACTER NO-UNDO.

  /* If passed in a task but not a workspace, then assign workpsace to task workspace */
  FIND rtb_task NO-LOCK
    WHERE rtb_task.task-num = piTask
    NO-ERROR.
  IF piTask > 0
  AND AVAILABLE rtb_task
  AND pcWorkspace = "":U
  THEN
    ASSIGN
      pcWorkspace = rtb_task.wspace-id.

  /* if workspace or task not set-up, try to use current ones */
  IF pcWorkspace = "":U
  THEN
    ASSIGN
      pcWorkspace = grtb-wspace-id.
  IF piTask = 0
  THEN
    ASSIGN
      piTask = grtb-task-num.

  FIND rtb_task NO-LOCK
    WHERE rtb_task.task-num = piTask
    NO-ERROR.

  IF CAN-FIND(FIRST rtb_ver
              WHERE rtb_ver.obj-type = "pcode":U
              AND   rtb_ver.object   = pcObject)
  THEN
    plExistsInSCM = YES.
  ELSE
    plExistsInSCM = NO.

  /* Find current version of object in the workspace */
  FIND FIRST rtb_object NO-LOCK
    WHERE rtb_object.wspace-id  = pcWorkspace
    AND   rtb_object.obj-type   = "PCODE":U
    AND   rtb_object.object     = pcObject
    NO-ERROR.
  IF AVAILABLE rtb_object
  THEN
    ASSIGN
      plExistsInWorkspace = YES
      piWorkspaceVersion  = rtb_object.version
      pcWorkspaceModule   = rtb_object.pmod
      .
  ELSE 
    ASSIGN
      plExistsInWorkspace = NO
      piWorkspaceVersion  = 0
      pcWorkspaceModule   = ""
      .

  IF pcWorkspaceModule <> "":U
  THEN
    RUN scmSitePrefixDel (INPUT-OUTPUT pcWorkspaceModule).

  /* Find latest version of object that exists */
  IF AVAILABLE rtb_object
  THEN
    FIND FIRST rtb_ver NO-LOCK  /* index is ascending, so FIND FIRST finds last */
      WHERE rtb_ver.obj-type  = rtb_object.obj-type
      AND   rtb_ver.object    = rtb_object.object
      AND   rtb_ver.pmod      = rtb_object.pmod
      NO-ERROR.
  ELSE
    FIND FIRST rtb_ver NO-LOCK  /* index is ascending, so FIND FIRST finds last */
      WHERE rtb_ver.obj-type  = "PCODE":U
      AND   rtb_ver.object    = pcObject
      NO-ERROR.
  IF AVAILABLE rtb_ver
  THEN
    ASSIGN
      piLastestVersion = rtb_ver.version.

  /* If version exists in workspace, see if checked out and under what task */
  IF AVAILABLE rtb_object
  THEN DO:
    FIND FIRST rtb_ver NO-LOCK
      WHERE rtb_ver.obj-type  = "PCODE":U
      AND   rtb_ver.object    = pcObject
      AND   rtb_ver.pmod      = rtb_object.pmod
      AND   rtb_ver.version   = rtb_object.version
      NO-ERROR.
    IF AVAILABLE rtb_ver
    THEN DO:
      ASSIGN
        plWorkspaceCheckedOut = (IF rtb_ver.obj-status = "w":U THEN YES ELSE NO)
        piVersioninTask       = rtb_ver.task-num
        pcObjectSummary       = rtb_ver.description
        pcObjectUpdNotes      = rtb_ver.upd-notes
        .
      /* Find out how many entries there are in the description */
      DO iLoop = 1 to 16:
        IF rtb_ver.text-desc[iLoop] <> ""
        THEN
          ASSIGN
            iEntries = iLoop.
      END.
      DO iLoop = 1 TO iEntries:
        ASSIGN
          cChar               = REPLACE(rtb_ver.text-desc[iLoop],"|":U," ":U)
          pcObjectDescription = pcObjectDescription
                              + (IF NUM-ENTRIES(pcObjectDescription,"|":U) > 0 THEN "|":U ELSE "":U)
                              + cChar.
      END.

      IF pcObjectUpdNotes = ""
      AND AVAILABLE rtb_task
      THEN DO:
        ASSIGN
          cText = "":U.
        DO iLoop = 1 TO 15:
          ASSIGN
            cLine = REPLACE(rtb_task.description[iLoop],"|":U," ":U).
          IF cLine <> ""
          THEN
            ASSIGN
              cText = cText
                    + (IF NUM-ENTRIES(cText,CHR(10)) > 0 THEN CHR(10) ELSE "":U)
                    + cLine.
        END.
        ASSIGN
          pcObjectUpdNotes = pcObjectUpdNotes + REPLACE(cText,"|":U," ":U).
      END.
      IF pcObjectUpdNotes = ""
      AND AVAILABLE rtb_task
      THEN
        ASSIGN
          pcObjectUpdNotes = TRIM(rtb_task.summary).

      /* get any previous version numbers for the object */
      DO WHILE AVAILABLE rtb_ver:
        FIND NEXT rtb_ver NO-LOCK
          WHERE rtb_ver.obj-type = rtb_object.obj-type
          AND   rtb_ver.object = rtb_object.object
          AND   rtb_ver.pmod = rtb_object.pmod
          USE-INDEX rtb_ver01
          NO-ERROR.
        IF AVAILABLE rtb_ver
        THEN
          ASSIGN
            pcPrevVersions = pcPrevVersions
                           + (IF NUM-ENTRIES(pcPrevVersions) > 0 THEN ",":U ELSE "":U)
                           + STRING(rtb_ver.version).
      END.

    END.
    ELSE
      ASSIGN
        plWorkspaceCheckedOut = NO
        piVersioninTask       = 0
        .
  END.
  ELSE
    ASSIGN
      plWorkspaceCheckedOut = NO
      piVersioninTask       = 0
      .

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmGetModuleDetails) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmGetModuleDetails Procedure 
PROCEDURE scmGetModuleDetails :
/*------------------------------------------------------------------------------
  Purpose:     To return product and module details for passed in module code
  Parameters:  input module code
               output product code
               output product desc
               output module desc

  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER pcModule                AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcProduct               AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcProductDesc           AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcModuleDesc            AS CHARACTER  NO-UNDO.

  FIND FIRST rtb_pmod NO-LOCK
    WHERE rtb_pmod.pmod = pcModule
    NO-ERROR.
  IF AVAILABLE rtb_pmod
  THEN
    FIND FIRST rtb_product NO-LOCK
      WHERE rtb_product.product-id = rtb_pmod.product-id
      NO-ERROR.

  IF AVAILABLE rtb_pmod
  AND AVAILABLE rtb_product
  THEN
    ASSIGN
      pcProduct     = rtb_product.product-id
      pcProductDesc = rtb_product.product-name 
      pcModuleDesc  = rtb_pmod.description
      .

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmGetModuleDir) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmGetModuleDir Procedure 
PROCEDURE scmGetModuleDir :
/*------------------------------------------------------------------------------
  Purpose:     To retrieve product module directory
  Parameters:  input product module code
               output corresponding workspace module directory
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcModule                   AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcDir                     AS CHARACTER    NO-UNDO.

  RUN scmSitePrefixAdd (INPUT-OUTPUT pcModule).

  FIND FIRST rtb_pmod NO-LOCK
    WHERE rtb_pmod.pmod = pcModule
    NO-ERROR.
  IF AVAILABLE rtb_pmod
  THEN
    FIND FIRST rtb_moddef NO-LOCK
      WHERE rtb_moddef.module = rtb_pmod.module
      NO-ERROR.
  IF AVAILABLE rtb_moddef
  THEN
    ASSIGN  
      pcDir = TRIM(REPLACE(LC(rtb_moddef.directory),"\":U,"/":U),"/":U).

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmGetObjectModule) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmGetObjectModule Procedure 
PROCEDURE scmGetObjectModule :
/*------------------------------------------------------------------------------
  Purpose:     Get current product module for workspace object
  Parameters:  input workspace code
               input object name
               input object type
               output product module code
               output relative path for product module
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  pcWorkspace                 AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  pcObject                    AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  pcType                      AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcModule                    AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcPath                      AS CHARACTER  NO-UNDO.

  FIND FIRST rtb_ver
    WHERE rtb_ver.object   = pcObject
    AND   rtb_ver.sub-type = pcType
    AND   rtb_ver.obj-type = "PCODE":U 
      NO-LOCK NO-ERROR. 
  IF AVAILABLE rtb_ver
  THEN
  FIND FIRST rtb_object NO-LOCK
    WHERE rtb_object.wspace-id  = pcWorkspace
    AND   rtb_object.obj-type   = "PCODE":U /* pcType */
    AND   rtb_object.object     = pcObject
    NO-ERROR.

  IF AVAILABLE rtb_object
  THEN
    ASSIGN
      pcModule = rtb_object.pmod.

  IF pcModule <> "":U
  THEN DO:

    FIND FIRST rtb_pmod NO-LOCK
      WHERE rtb_pmod.pmod = pcModule
      NO-ERROR.
    IF AVAILABLE rtb_pmod
    THEN
      FIND rtb_moddef NO-LOCK
        WHERE rtb_moddef.module = rtb_pmod.module
        NO-ERROR.
    IF AVAILABLE rtb_moddef
    THEN 
      ASSIGN
        pcPath = rtb_moddef.directory.

    RUN scmSitePrefixDel (INPUT-OUTPUT pcModule).

  END.

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmGetSiteNumber) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmGetSiteNumber Procedure 
PROCEDURE scmGetSiteNumber :
/*------------------------------------------------------------------------------
  Purpose:     Return development site number
  Parameters:  output site number
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE OUTPUT PARAMETER piSite AS INTEGER NO-UNDO.

  FIND FIRST rtb_system NO-LOCK NO-ERROR.

  IF AVAILABLE rtb_system
  THEN
    ASSIGN
      piSite = rtb_system.dsite.
  ELSE
    ASSIGN
      piSite = 0.

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmGetTaskInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmGetTaskInfo Procedure 
PROCEDURE scmGetTaskInfo :
/*------------------------------------------------------------------------------
  Purpose:     Retrieve task information for selected task.
  Parameters:  input-output task (if not input will default to current task)
               output task summary
               output task description
               output task programmer
               output task user reference
               output task workspace
               output task entered dated
               output task status

  Notes:       Supercedes rtb-get-task-info as this does not contain the status
------------------------------------------------------------------------------*/

  DEFINE INPUT-OUTPUT PARAMETER piTaskNumber    AS INTEGER    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcTaskSummary         AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcTaskDescription     AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcTaskProgrammer      AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcTaskUserRef         AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcTaskWorkspace       AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER ptTaskEnteredDate     AS DATE       NO-UNDO.
  DEFINE OUTPUT PARAMETER pcTaskStatus          AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE iLoop                         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cCharacter                    AS CHARACTER  NO-UNDO.

  IF piTaskNumber = 0
  THEN
    ASSIGN
      piTaskNumber = grtb-task-num.

  FIND FIRST rtb_task NO-LOCK
    WHERE rtb_task.task-num = piTaskNumber 
    NO-ERROR.
  IF NOT AVAILABLE rtb_task
  THEN RETURN.

  ASSIGN
    pcTaskSummary     = TRIM(rtb_task.summary)
    pcTaskProgrammer  = TRIM(LC(rtb_task.programmer))
    pcTaskUserRef     = TRIM(rtb_task.user-task-ref)
    pcTaskWorkspace   = TRIM(LC(rtb_task.wspace-id))
    ptTaskEnteredDate = rtb_task.entered-when
    pcTaskStatus      = rtb_task.task-status
    .

  DO iLoop = 1 TO 15:
    ASSIGN
      cCharacter = REPLACE(rtb_task.description[iLoop],"|":U," ":U).
    IF cCharacter <> ""
    THEN
      ASSIGN
        pcTaskDescription = pcTaskDescription
                          + (IF NUM-ENTRIES(pcTaskDescription,"|":U) > 0 THEN "|":U ELSE "":U)
                          + cCharacter.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmGetTaskShareStatus) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmGetTaskShareStatus Procedure 
PROCEDURE scmGetTaskShareStatus :
/*------------------------------------------------------------------------------
  Purpose:     Get task share status
  Parameters:  input task number
               output task exists yes/no
               output share status
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER piTaskNumber                 AS INTEGER    NO-UNDO.
  DEFINE OUTPUT PARAMETER plExists                    AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcShareStatus               AS CHARACTER  NO-UNDO.

  FIND FIRST rtb_task NO-LOCK
    WHERE rtb_task.task-num = piTaskNumber
    NO-ERROR.
  IF NOT AVAILABLE rtb_task
  THEN
    ASSIGN
      plExists      = NO
      pcShareStatus = "":U
      .
  ELSE
    ASSIGN
      plExists      = YES
      pcShareStatus = rtb_task.share-status
      .

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmGetWorkspaceRoot) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmGetWorkspaceRoot Procedure 
PROCEDURE scmGetWorkspaceRoot :
/*------------------------------------------------------------------------------
  Purpose:     Return workspace root directory
  Parameters:  input workspace code
               output workspace root directory
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcWorkspace            AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcRoot                AS CHARACTER  NO-UNDO.

  ASSIGN
    pcRoot = TRIM(REPLACE(LC(grtb-wsroot),"~\":U,"/":U),"/":U).

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmModuleInWorkspace) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmModuleInWorkspace Procedure 
PROCEDURE scmModuleInWorkspace :
/*------------------------------------------------------------------------------
  Purpose:     To check if passed in module is in passed in workspace
  Parameters:  input module code
               input workspace code
               output exists yes/no
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcModule                 AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER pcWorkspace              AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT PARAMETER plExists                AS LOGICAL      NO-UNDO.

  ASSIGN
    plExists = NO.

  FIND FIRST rtb_pmod NO-LOCK
    WHERE rtb_pmod.pmod = pcModule
    NO-ERROR.
  IF AVAILABLE rtb_pmod
  THEN
    IF CAN-FIND(FIRST rtb_module 
                WHERE rtb_module.module    = rtb_pmod.module
                AND   rtb_module.wspace-id = pcWorkspace)
    THEN
      ASSIGN
        plExists = YES.

  IF plExists = NO
  THEN DO:

    IF pcModule <> "":U
    THEN RUN scmSitePrefixAdd (INPUT-OUTPUT pcModule).

    FIND FIRST rtb_pmod NO-LOCK
      WHERE rtb_pmod.pmod = pcModule
      NO-ERROR.
    IF AVAILABLE rtb_pmod
    THEN
      IF CAN-FIND(FIRST rtb_module 
                  WHERE rtb_module.module    = rtb_pmod.module
                  AND   rtb_module.wspace-id = pcWorkspace)
      THEN
        ASSIGN
          plExists = YES.

  END.

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmObjectExists) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmObjectExists Procedure 
PROCEDURE scmObjectExists :
/*------------------------------------------------------------------------------
  Purpose:     To return whether the passed in object exists in the SCM Tool,
               plus extra information about whether it is checked out, what
               the checked out version is, the latest version, etc.
  Parameters:  input object name
               input workspace to check if exists in / is checked out in
               output exists in RTB flag
               output exists in Workspace flag
               output object version number in workspace
               output object checked out in workspace flag
               output object version created in task number
               output object latest version number

  Notes:       This routine is used by the data versioning system to ensure
               data is not created for objects that already exist in RTB, unless
               the object is checked out in RTB under the same task as the data 
               is being created in.
               It is also used in other places where we need to know if an object
               simply already exists in RTB or not.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_object                   AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_workspace                AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER op_exists_in_rtb            AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER op_exists_in_workspace      AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER op_workspace_version        AS INTEGER    NO-UNDO.
  DEFINE OUTPUT PARAMETER op_workspace_checked_out    AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER op_version_task_number      AS INTEGER    NO-UNDO.
  DEFINE OUTPUT PARAMETER op_latest_version           AS INTEGER    NO-UNDO.

  IF CAN-FIND(FIRST rtb_ver
              WHERE rtb_ver.obj-type = "PCODE":U
              AND   rtb_ver.object   = ip_object)
  THEN
    ASSIGN
      op_exists_in_rtb = YES.
  ELSE DO:
    ASSIGN
      op_exists_in_rtb          = NO
      op_exists_in_workspace    = NO
      op_workspace_version      = 0
      op_workspace_checked_out  = NO
      op_version_task_number    = 0
      op_latest_version         = 0
      .
      /* Return - as there is no need to continue processing if the object does not exist in RTB */
      RETURN. 
  END.

  /* Find current version of object in the workspace */
  FIND FIRST rtb_object NO-LOCK
    WHERE rtb_object.wspace-id  = ip_workspace
    AND   rtb_object.obj-type   = "PCODE":U
    AND   rtb_object.object     = ip_object
    NO-ERROR.
  IF AVAILABLE rtb_object
  THEN
    ASSIGN
      op_exists_in_workspace = YES
      op_workspace_version   = rtb_object.version
      .
  ELSE 
    ASSIGN
      op_exists_in_workspace = NO
      op_workspace_version   = 0
      .

  /* Find latest version of object that exists */
  IF AVAILABLE rtb_object
  THEN
    FIND FIRST rtb_ver NO-LOCK  /* index is ascending, so FIND FIRST finds last */
      WHERE rtb_ver.obj-type  = rtb_object.obj-type
      AND   rtb_ver.object    = rtb_object.object
      AND   rtb_ver.pmod      = rtb_object.pmod
      NO-ERROR.
  ELSE
    FIND FIRST rtb_ver NO-LOCK  /* index is ascending, so FIND FIRST finds last */
      WHERE rtb_ver.obj-type  = "PCODE":U
      AND   rtb_ver.object    = ip_object
      NO-ERROR.
  IF AVAILABLE rtb_ver
  THEN
    ASSIGN op_latest_version = rtb_ver.version.

  /* If version exists in workspace, see if checked out and under what task */
  IF AVAILABLE rtb_object
  THEN DO:
    FIND FIRST rtb_ver NO-LOCK
      WHERE rtb_ver.obj-type  = "PCODE":U
      AND   rtb_ver.object    = ip_object
      AND   rtb_ver.version   = rtb_object.version
      NO-ERROR.
    IF AVAILABLE rtb_ver
    THEN
      ASSIGN
        op_workspace_checked_out = (IF rtb_ver.obj-status = "w":U THEN YES ELSE NO)
        op_version_task_number   = rtb_ver.task-num
        .
    ELSE
      ASSIGN
        op_workspace_checked_out = NO
        op_version_task_number = 0
        .
  END.
  ELSE
    ASSIGN
      op_workspace_checked_out = NO
      op_version_task_number = 0
      .

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmObjectHasData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmObjectHasData Procedure 
PROCEDURE scmObjectHasData :
/*------------------------------------------------------------------------------
  Purpose:     To check if passed in object has a part with a .ado extension
               indicating it has associated repository data in an xml file
  Parameters:  input workspace code
               input object name
               output object has data flag yes/no
               output product module code (for use when load into repository)
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER pcWorkspace       AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcObjectName      AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER plObjectHasData   AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcProductModule   AS CHARACTER  NO-UNDO.

  ASSIGN
    plObjectHasData = NO.

  FIND FIRST rtb_object NO-LOCK
    WHERE rtb_object.object    = pcObjectName
    AND   rtb_object.wspace-id = pcWorkspace
    NO-ERROR.
  IF AVAILABLE rtb_object
  THEN
    FIND FIRST rtb_ver NO-LOCK 
      WHERE rtb_ver.obj-type = rtb_object.obj-type
      AND   rtb_ver.object   = rtb_object.object
      AND   rtb_ver.pmod     = rtb_object.pmod
      AND   rtb_ver.version  = rtb_object.version
      NO-ERROR.
  IF  AVAILABLE rtb_object
  AND AVAILABLE rtb_ver
  THEN
    FIND FIRST rtb_subtype NO-LOCK
      WHERE rtb_subtype.sub-type = rtb_ver.sub-type
      NO-ERROR.
  IF  AVAILABLE rtb_object
  AND AVAILABLE rtb_ver
  AND AVAILABLE rtb_subtype
  AND (rtb_subtype.part-ext[1] = "ado":U
    OR rtb_subtype.part-ext[2] = "ado":U
    OR rtb_subtype.part-ext[3] = "ado":U
    OR rtb_subtype.part-ext[4] = "ado":U
    OR rtb_subtype.part-ext[5] = "ado":U
    OR rtb_subtype.part-ext[6] = "ado":U
    OR rtb_subtype.part-ext[7] = "ado":U
    OR rtb_subtype.part-ext[8] = "ado":U
    OR rtb_subtype.part-ext[9] = "ado":U)
    THEN
      ASSIGN 
        plObjectHasData = YES.

  IF AVAILABLE rtb_object
  AND AVAILABLE rtb_ver
  AND AVAILABLE rtb_subtype
  THEN DO:

    ASSIGN
      pcProductModule = rtb_ver.pmod.

    IF pcProductModule <> "":U
    THEN
      RUN scmSitePrefixDel (INPUT-OUTPUT pcProductModule).

  END.

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmObjectIntegrity) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmObjectIntegrity Procedure 
PROCEDURE scmObjectIntegrity :
/*------------------------------------------------------------------------------
  Purpose:     To check an objects integrity between the repository and disk
  Parameters:  SEE BELOW
  Notes:       Object type is PCODE
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_workspace                    AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_product_module               AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_name                  AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_type                  AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT PARAMETER op_rejection                    AS CHARACTER    NO-UNDO.

  DEFINE VARIABLE lh_rtbplip                              AS HANDLE       NO-UNDO.

  /*- Run PP of API calls -*/
  IF NOT VALID-HANDLE(lh_rtbplip)
  THEN
    RUN rtb/p/rtb_api.p PERSISTENT SET lh_rtbplip.

  RUN check_object_integrity IN lh_rtbplip
                             (INPUT ip_workspace
                             ,INPUT ip_product_module
                             ,INPUT ip_object_name
                             ,INPUT ip_object_type
                             ,OUTPUT op_rejection
                             ).

  IF VALID-HANDLE(lh_rtbplip)
  THEN
    DELETE PROCEDURE lh_rtbplip.

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmObjectIntegrityControl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmObjectIntegrityControl Procedure 
PROCEDURE scmObjectIntegrityControl :
/*------------------------------------------------------------------------------
  Purpose:     To check an objects integrity between the repository and disk
  Parameters:  SEE BELOW
  Notes:       Object type is PCODE
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_workspace                    AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_product_module               AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_name                  AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_type                  AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT PARAMETER op_rejection                    AS CHARACTER    NO-UNDO.

  TRANSACTION-BLOCK:
  DO TRANSACTION:

    RUN scmObjectIntegrity (INPUT ip_workspace
                           ,INPUT ip_product_module
                           ,INPUT ip_object_name
                           ,INPUT ip_object_type
                           ,OUTPUT op_rejection).

    IF op_rejection <> "":U
    THEN
      UNDO TRANSACTION-BLOCK, LEAVE TRANSACTION-BLOCK.                        

  END. /* transaction-block */

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmObjectSubType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmObjectSubType Procedure 
PROCEDURE scmObjectSubType :
/*------------------------------------------------------------------------------
  Purpose:     To check if passed in object has a part with a .ado extension
               indicating it has associated repository data in an xml file
  Parameters:  input workspace code
               input object name
               output object has data flag yes/no
               output product module code (for use when load into repository)
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER pcWorkspace       AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcObjectName      AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcObjectSubType   AS CHARACTER  NO-UNDO.

  FIND FIRST rtb_object NO-LOCK
    WHERE rtb_object.object    = pcObjectName
    AND   rtb_object.wspace-id = pcWorkspace
    NO-ERROR.
  IF AVAILABLE rtb_object
  THEN
    FIND FIRST rtb_ver NO-LOCK 
      WHERE rtb_ver.obj-type = rtb_object.obj-type
      AND   rtb_ver.object   = rtb_object.object
      AND   rtb_ver.pmod     = rtb_object.pmod
      AND   rtb_ver.version  = rtb_object.version
      NO-ERROR.
  IF  AVAILABLE rtb_object
  AND AVAILABLE rtb_ver
  THEN
    FIND FIRST rtb_subtype NO-LOCK
      WHERE rtb_subtype.sub-type = rtb_ver.sub-type
      NO-ERROR.
  IF  AVAILABLE rtb_subtype
  THEN
    ASSIGN
      pcObjectSubType = rtb_subtype.sub-type.
  ELSE
    ASSIGN
      rtb_subtype.sub-type = "":U.

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmSelectiveCompile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmSelectiveCompile Procedure 
PROCEDURE scmSelectiveCompile :
/*------------------------------------------------------------------------------
  Purpose:     To seletively compile objects
  Parameters:  SEE BELOW
  Notes:       Ptask-num  - task number to select objects from or 0 to ignore tasks
               Pmodule    - module to select objects from or MATCHES pattern
               Pobj-group - Object group to select objects from or MATCHES pattern
               Pobj-type  - Object types to select (PCODE, PFILE, etc.) or MATCHES
                            pattern
               Pobject    - Object to select or MATCHES pattern
               Pforce     - Logical YES to force compile of (current) objects
               Plistings  - Logical YES to generate compile listings
               Pxref      - Logical YES to perform xref of selected object(s)
               Perror     - This will be non-blank if the process could no be performed
               Compile errors and warnings will be recorded in the selcomp.log file
               created in the rtb_temp directory of the Roundtable session temp
               directory.

               No user interface will be displayed during the compile.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_task_number                  AS INTEGER      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_module                       AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_group                 AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_type                  AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_name                  AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_force                        AS LOGICAL      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_with_listings                AS LOGICAL      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_with_xref                    AS LOGICAL      NO-UNDO.
  DEFINE OUTPUT PARAMETER op_rejection                    AS CHARACTER    NO-UNDO.

  DEFINE VARIABLE lh_rtbplip                              AS HANDLE       NO-UNDO.

  /*- Run PP of API calls -*/
  IF NOT VALID-HANDLE(lh_rtbplip)
  THEN
    RUN rtb/p/rtb_api.p PERSISTENT SET lh_rtbplip.

  RUN selective_compile IN lh_rtbplip
                       (INPUT ip_task_number
                       ,INPUT ip_module
                       ,INPUT ip_object_group
                       ,INPUT ip_object_type
                       ,INPUT ip_object_name
                       ,INPUT ip_force
                       ,INPUT ip_with_listings
                       ,INPUT ip_with_xref
                       ,OUTPUT op_rejection
                       ).

  IF VALID-HANDLE(lh_rtbplip)
  THEN
    DELETE PROCEDURE lh_rtbplip.

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmSelectiveCompileControl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmSelectiveCompileControl Procedure 
PROCEDURE scmSelectiveCompileControl :
/*------------------------------------------------------------------------------
  Purpose:     To seletively compile objects
  Parameters:  SEE BELOW
  Notes:       Ptask-num  - task number to select objects from or 0 to ignore tasks
               Pmodule    - module to select objects from or MATCHES pattern
               Pobj-group - Object group to select objects from or MATCHES pattern
               Pobj-type  - Object types to select (PCODE, PFILE, etc.) or MATCHES
                            pattern
               Pobject    - Object to select or MATCHES pattern
               Pforce     - Logical YES to force compile of (current) objects
               Plistings  - Logical YES to generate compile listings
               Pxref      - Logical YES to perform xref of selected object(s)
               Perror     - This will be non-blank if the process could no be performed
               Compile errors and warnings will be recorded in the selcomp.log file
               created in the rtb_temp directory of the Roundtable session temp
               directory.

               No user interface will be displayed during the compile.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_task_number                  AS INTEGER      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_module                       AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_group                 AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_type                  AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_name                  AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_force                        AS LOGICAL      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_with_listings                AS LOGICAL      NO-UNDO.
  DEFINE INPUT PARAMETER  ip_with_xref                    AS LOGICAL      NO-UNDO.
  DEFINE OUTPUT PARAMETER op_rejection                    AS CHARACTER    NO-UNDO.

  TRANSACTION-BLOCK:
  DO TRANSACTION:

    RUN scmCompileObject (INPUT ip_task_number
                         ,INPUT ip_module
                         ,INPUT ip_object_group
                         ,INPUT ip_object_type
                         ,INPUT ip_object_name
                         ,INPUT ip_force
                         ,INPUT ip_with_listings
                         ,INPUT ip_with_xref
                         ,OUTPUT op_rejection).

    IF op_rejection <> "":U
    THEN
      UNDO TRANSACTION-BLOCK, LEAVE TRANSACTION-BLOCK.                        

  END. /* transaction-block */

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmSitePrefixAdd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmSitePrefixAdd Procedure 
PROCEDURE scmSitePrefixAdd :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT-OUTPUT PARAMETER pcAddSitePrefix AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE iSiteNumber  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cSiteNumber  AS CHARACTER  NO-UNDO.

  RUN scmGetSiteNumber (OUTPUT iSiteNumber).

  ASSIGN
    cSiteNumber = STRING(iSiteNumber,"999":U).

  IF iSiteNumber > 0
  AND SUBSTRING(pcAddSitePrefix,1,3) <> cSiteNumber
  THEN
    pcAddSitePrefix = cSiteNumber + pcAddSitePrefix.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmSitePrefixDel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmSitePrefixDel Procedure 
PROCEDURE scmSitePrefixDel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT-OUTPUT PARAMETER pcDelSitePrefix AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE iSiteInteger      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iSiteNumber       AS INTEGER    NO-UNDO.

  ASSIGN
    iSiteInteger = INTEGER( SUBSTRING(pcDelSitePrefix,1,3) )
    NO-ERROR.

  RUN scmGetSiteNumber (OUTPUT iSiteNumber).

  IF (iSiteNumber  > 0 AND SUBSTRING(pcDelSitePrefix,1,3) = STRING(iSiteNumber,"999":U))
  OR iSiteInteger > 0
  THEN DO:
    ASSIGN
      pcDelSitePrefix = SUBSTRING(pcDelSitePrefix,4,LENGTH(pcDelSitePrefix)).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmUnlockObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmUnlockObject Procedure 
PROCEDURE scmUnlockObject :
/*------------------------------------------------------------------------------
  Purpose:     To unlock an object
  Parameters:  SEE BELOW
  Notes:       Object type is PCODE
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_workspace                    AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_product_module               AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_name                  AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_type                  AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT PARAMETER op_rejection                    AS CHARACTER    NO-UNDO.

  DEFINE VARIABLE lh_rtbplip                              AS HANDLE       NO-UNDO.

  /*- Run PP of API calls -*/
  IF NOT VALID-HANDLE(lh_rtbplip)
  THEN
    RUN rtb/p/rtb_api.p PERSISTENT SET lh_rtbplip.

  RUN unlock_object IN lh_rtbplip
                   (INPUT ip_workspace
                   ,INPUT ip_product_module
                   ,INPUT ip_object_name
                   ,INPUT ip_object_type
                   ,OUTPUT op_rejection
                   ).

  IF VALID-HANDLE(lh_rtbplip)
  THEN
    DELETE PROCEDURE lh_rtbplip.

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmUnlockObjectControl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmUnlockObjectControl Procedure 
PROCEDURE scmUnlockObjectControl :
/*------------------------------------------------------------------------------
  Purpose:     To unlock an object
  Parameters:  SEE BELOW
  Notes:       Object type is PCODE
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_workspace                    AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_product_module               AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_name                  AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  ip_object_type                  AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT PARAMETER op_rejection                    AS CHARACTER    NO-UNDO.

  TRANSACTION-BLOCK:
  DO TRANSACTION:

    RUN scmUnlockObject (INPUT ip_workspace
                        ,INPUT ip_product_module
                        ,INPUT ip_object_name
                        ,INPUT ip_object_type
                        ,OUTPUT op_rejection).

    IF op_rejection <> "":U
    THEN
      UNDO TRANSACTION-BLOCK, LEAVE TRANSACTION-BLOCK.                        

  END. /* transaction-block */

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmUpdateObjectDescription) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmUpdateObjectDescription Procedure 
PROCEDURE scmUpdateObjectDescription :
/*------------------------------------------------------------------------------
  Purpose:     Update object description for current version in workspace
  Parameters:  input workspace code
               input object name
               input object type (pcode)
               input overwrite existing description yes/no
               input new description
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  pcWorkspace                   AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  pcObject                      AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  pcType                        AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  plOverwrite                   AS LOGICAL      NO-UNDO.
  DEFINE INPUT PARAMETER  pcDescription                 AS CHARACTER    NO-UNDO.

  DEFINE BUFFER brtb_ver FOR rtb_ver.

  FIND FIRST rtb_object NO-LOCK
    WHERE rtb_object.wspace-id  = pcWorkspace
    AND   rtb_object.obj-type   = pcType
    AND   rtb_object.object     = pcObject
    NO-ERROR.
  IF AVAILABLE rtb_object
  THEN
    FIND FIRST rtb_ver NO-LOCK
      WHERE rtb_ver.obj-type  = rtb_object.obj-type
      AND   rtb_ver.object    = rtb_object.object
      AND   rtb_ver.pmod      = rtb_object.pmod
      AND   rtb_ver.version   = rtb_object.version
      NO-ERROR.
  IF AVAILABLE rtb_object
  AND AVAILABLE rtb_ver
  AND (plOverwrite = YES
    OR LENGTH(rtb_ver.description) = 0)
  THEN
  trn-block:
  DO FOR brtb_ver TRANSACTION ON ERROR UNDO trn-block, LEAVE trn-block:

    FIND FIRST brtb_ver EXCLUSIVE-LOCK
      WHERE ROWID(brtb_ver) = ROWID(rtb_ver)
      NO-ERROR.
    IF AVAILABLE brtb_ver
    THEN
      ASSIGN
        brtb_ver.description = pcDescription.

    VALIDATE brtb_ver NO-ERROR.

  END.

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

