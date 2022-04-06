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
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: afverxftrp.p

  Description:  Object version XFTR

  Purpose:      XFTR for all objects to automatically create / update the
                pre-rocessors in the definition section of each object describing
                the object name and its version. The pre-processors are as follows:
                object-name = the actual object name, no quotes !
                object-version-number = the SCM version of the object.

                This XFTR will execute on save of an object. It will check to see if
                the pre-processors exist, and if not, create them. It will then
                check the object in Roundtable and ensure the pre-processors are set
                to the current version of the object in Roundtable for the current
                task.

  Parameters:   ip_context_id   Context ID of the XFTR code block
                iop_code        Code section

  History:
  --------
  (v:010000)    Task:          46   UserRef:    AS0
                Date:   14/01/1998  Author:     Anthony Swindells

  Update Notes: Wrote a new XFTR to update 2 new preprocessors in definition section, object-name and object-version with SCM object version and name.
                Added a new standard procedure to all objects mip-get-object-version and a new procedure to all containers mip-get-container-versions to return the version of all objects on the container.
                Finally wrote a standard about window to display the above version details.

  (v:010001)    Task:          51   UserRef:    AS0
                Date:   05/02/1998  Author:     Anthony Swindells

  Update Notes: Added new XFTR to enforce addition of version notes for the current object version on open of an object.

  (v:010002)    Task:          54   UserRef:    
                Date:   12/02/1998  Author:     Anthony Swindells

  Update Notes: Kill persistent procedure rtbprocp.p when finished

  (v:010004)    Task:         142   UserRef:    
                Date:   06/04/1998  Author:     Anthony Swindells

  Update Notes: Modify wizards to only run if not editing in read-only mode, i.e. if the object
                being edited belongs to the current task.

  (v:010005)    Task:        5755   UserRef:    
                Date:   22/05/2000  Author:     Anthony Swindells

  Update Notes: Fix version XFTR to save correctly.

-------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE INPUT        PARAMETER  ip_context_id                    AS INTEGER      NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER  iop_code                         AS CHARACTER    NO-UNDO.

/* UIB API call general variables */
DEFINE VARIABLE                 lv_uibinfo                      AS CHARACTER    NO-UNDO.
DEFINE VARIABLE                 lv_srecid                       AS INTEGER      NO-UNDO.
DEFINE VARIABLE                 lv_code                         AS CHARACTER    NO-UNDO.

/* Handle to procedure containing Roundtable procedures */
DEFINE VARIABLE hScmTool                     AS HANDLE       NO-UNDO.

/* Roundtable/Object information variables */
DEFINE VARIABLE lv_task_number          AS INTEGER NO-UNDO.
DEFINE VARIABLE lv_task_summary         AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_task_description     AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_task_programmer      AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_task_userref         AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_task_workspace       AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_task_date            AS DATE NO-UNDO.
DEFINE VARIABLE lv_user_code            AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_user_name            AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_object_name          AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_template_name        AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_object_version       AS INTEGER NO-UNDO.
DEFINE VARIABLE lv_object_summary       AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_object_description   AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_object_upd_notes     AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_previous_versions    AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_object_version_task  AS INTEGER NO-UNDO.

/* Shared variable from AppBuilder adeuib/sharvars.i */
DEFINE SHARED VARIABLE _save_file       AS CHARACTER NO-UNDO.
DEFINE SHARED VARIABLE _p_status        AS CHARACTER NO-UNDO.

/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afverxftrp.p
&scop object-version    010000

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
         HEIGHT             = 7.48
         WIDTH              = 45.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
/* Versioning not required when performing a check-syntax or running */
IF CAN-DO("CHECK-SYNTAX,RUN",_p_status) THEN
   RETURN.

/* Get the handle to the persistent procedure containing Roundtable access Routines. */
hScmTool = DYNAMIC-FUNCTION('getProcedureHandle':U IN THIS-PROCEDURE, INPUT "PRIVATE-DATA:SCMTool":U).

/* Get the object name if it has been saved */
ASSIGN lv_object_name = "".
/* donb - fix Issue 3568 */
IF _save_file = ?  THEN
  RUN adeuib/_uibinfo.p ( ?, ?, "FILE-NAME":U, OUTPUT lv_uibinfo ).
ELSE
  lv_uibinfo = _save_file.
IF lv_uibinfo <> ? THEN
    DO:
        ASSIGN lv_uibinfo = TRIM(LC(REPLACE(lv_uibinfo,"~\":U,"/":U))).
        IF R-INDEX(lv_uibinfo,"/":U) > 0 THEN
            ASSIGN lv_uibinfo = TRIM(SUBSTRING(lv_uibinfo, R-INDEX(lv_uibinfo,"/":U) + 1)).
        ASSIGN lv_object_name = lv_uibinfo.
    END.

/* Next populate the SCM details if we can */
RUN getScmInfo.

/* Got all information we require - next read current definition section */
RUN adeuib/_accsect.p( "GET":U, ?, "DEFINITIONS":U,
                       INPUT-OUTPUT lv_srecid,
                       INPUT-OUTPUT lv_code ).

/* See if pre-processors exist, and if not add them */
IF INDEX(lv_code,"/* MIP-GET-OBJECT-VERSION":U) = 0 THEN
    ASSIGN
        lv_code = lv_code + CHR(10) + CHR(10) +
                            "/* MIP-GET-OBJECT-VERSION pre-processors":U + CHR(10) +
                            "   The following pre-processors are maintained automatically when the object is":U + CHR(10) +
                            "   saved. They pull the object and version from Roundtable if possible so that it":U + CHR(10) +
                            "   can be displayed in the about window of the container */":U + CHR(10) + CHR(10) +
                            "&scop object-name       ":U + CHR(10) +
                            "&scop object-version    ":U + CHR(10).

/* Replace values with new values from Roundtable */
DEFINE VARIABLE lv_start_posn AS INTEGER NO-UNDO.
DEFINE VARIABLE lv_end_posn AS INTEGER NO-UNDO.

IF lv_object_name <> "":U THEN
ASSIGN
    lv_start_posn = INDEX(lv_code,"&scop object-name":U) + LENGTH("&scop object-name":U)
    lv_end_posn = INDEX(lv_code,CHR(10),lv_start_posn - 1) - 1
    SUBSTRING(lv_code,lv_start_posn,(lv_end_posn - lv_start_posn) + 1) = "       ":U + lv_object_name
    lv_start_posn = INDEX(lv_code,"&scop object-version":U) + LENGTH("&scop object-version":U)
    lv_end_posn = (IF INDEX(lv_code,CHR(10),lv_start_posn - 1) - 1 > lv_start_posn
                      THEN INDEX(lv_code,CHR(10),lv_start_posn - 1) - 1
                      ELSE LENGTH(lv_code))
    SUBSTRING(lv_code,lv_start_posn,(lv_end_posn - lv_start_posn) + 1) = "    ":U + STRING(lv_object_version,"999999":U)
    .

/* Write back definition section */
RUN adeuib/_accsect.p( "SET":U, ?, "DEFINITIONS":U,
                       INPUT-OUTPUT lv_srecid,
                       INPUT-OUTPUT lv_code ).


/*  Finally, mark the window as unsaved */          
RUN adeuib/_uibinfo( INPUT  ?,              /* Don't know the context ID               */
                     INPUT  "WINDOW ?",     /* We want the handle of the design window */
                     INPUT  "HANDLE",       /* We want the handle                      */
                     OUTPUT lv_uibinfo ).   /* Returns a string of the handle          */
RUN adeuib/_winsave( WIDGET-HANDLE( lv_uibinfo ), FALSE ).

/* Finished */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-getScmInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getScmInfo Procedure 
PROCEDURE getScmInfo :
/*------------------------------------------------------------------------------
  Purpose:     Read information from Roundtable if possible
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

IF VALID-HANDLE(hScmTool)
THEN DO:

  RUN rtb-get-taskinfo IN hScmTool
              (   OUTPUT  lv_task_number,
                  OUTPUT  lv_task_summary,
                  OUTPUT  lv_task_description,
                  OUTPUT  lv_task_programmer,
                  OUTPUT  lv_task_userref,
                  OUTPUT  lv_task_workspace,
                  OUTPUT  lv_task_date   ).

  RUN rtb-get-userinfo IN hScmTool
              (   OUTPUT  lv_user_code,
                  OUTPUT  lv_user_name).

  IF lv_object_name <> ""
  AND lv_task_number > 0
  THEN
    RUN rtb-get-objectinfo IN hScmTool
                (    INPUT   lv_object_name,
                     INPUT   lv_task_number,
                     OUTPUT  lv_object_version,
                     OUTPUT  lv_object_summary,
                     OUTPUT  lv_object_description,
                     OUTPUT  lv_object_upd_notes,
                     OUTPUT  lv_previous_versions,
                     OUTPUT  lv_object_version_task).
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

