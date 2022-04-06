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
  File: aferrloglp.p

  Description:  Loads Errors loged in an ascii file

  Purpose:      This procedure will be run when a user logs in to load their error files, but may
                also be run on demand.
                It will load the contents of the user error files into the error log and clear out the
                user error files - all except the error file for the current day of the week.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:         130   UserRef:    MD
                Date:   01/04/1998  Author:     Mark Davies

  Update Notes: Created from Template aftemprocp.p

  (v:010001)    Task:         281   UserRef:    JB
                Date:   04/06/1998  Author:     Jenny Bond

  Update Notes: Rectify error messages

  (v:010003)    Task:         807   UserRef:    Astra
                Date:   01/12/1998  Author:     Anthony Swindells

  Update Notes: Fully implement error log. This involves the conditional writing to the error log,
                the review of the error log, and the loading of the flat files into the error log table,
                plus a review of errors in general.

-------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       aferrloglp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010003


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

DEFINE VARIABLE lv_loop         AS INTEGER   NO-UNDO.
DEFINE VARIABLE lv_file_name    AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_error_file   AS CHARACTER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure



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

{af/sup/afsysuser.i}

FIND FIRST gsc_security_control NO-LOCK NO-ERROR.
IF AVAILABLE gsc_security_control THEN
  ASSIGN lv_file_name = gsc_security_control.error_log_filename.
ELSE
  ASSIGN lv_file_name = "c:/temp/errlog&1.lg":U.

DO lv_loop = 1 TO 7:
    IF lv_loop = WEEKDAY(TODAY) THEN 
       NEXT.
    lv_error_file = SUBSTITUTE(lv_file_name,STRING(lv_loop)).

    /***************** Check To See If File Does Exist *****************/
    IF SEARCH(lv_error_file) = ? THEN
        NEXT.

    /********** Check To See If File Is Readable And Writable ***********/
    FILE-INFO:FILE-NAME = lv_error_file.
    IF INDEX(FILE-INFO:FILE-TYPE,"R":U) = 0 THEN DO:
        CREATE gst_error_log.
        ASSIGN gst_error_log.business_logic_error = NO
               gst_error_log.error_number         = 10    /* Permission Denied */
               gst_error_log.error_message        = "Can Not Read Error Log File For " + lv_error_file
               gst_error_log.error_group          = "AF":U
               gst_error_log.user_obj             = gsm_user.user_obj
               gst_error_log.error_in_program     = PROGRAM-NAME(1)
               gst_error_log.error_date           = TODAY
               gst_error_log.error_time           = TIME
               NO-ERROR.
        NEXT.
    END.
    IF INDEX(FILE-INFO:FILE-TYPE,"W":U) = 0 THEN DO:
        CREATE gst_error_log.
        ASSIGN gst_error_log.business_logic_error = NO
               gst_error_log.error_number         = 10    /* Permission Denied */
               gst_error_log.error_message        = "Can Not Write To Error Log File For " + lv_error_file
               gst_error_log.error_group          = "AF":U
               gst_error_log.user_obj             = gsm_user.user_obj
               gst_error_log.error_in_program     = PROGRAM-NAME(1)
               gst_error_log.error_date           = TODAY
               gst_error_log.error_time           = TIME
               NO-ERROR.
        NEXT.
    END.

    /********************** Open File For Input ************************/
    INPUT FROM VALUE(lv_error_file).
    REPEAT:
        CREATE gst_error_log.
        IMPORT DELIMITER "|":U
               gst_error_log.business_logic_error /* Business Logic Error Yes/No  */
               gst_error_log.error_group          /* Error Group For tTis Message */
               gst_error_log.error_number         /* Error Number As In gsc_error */
               gst_error_log.error_message        /* Error Message Displayed      */
               gst_error_log.user_obj             /* User Object Code That Got Err*/
               gst_error_log.error_date           /* Date Error Was Encountered   */
               gst_error_log.error_time           /* Time Error Was Encountered   */
               gst_error_log.error_in_program     /* Program Name That Got Error  */
               NO-ERROR.
        PROCESS EVENTS.
    END. /* REPEAT */
    INPUT CLOSE.

    OUTPUT TO VALUE(lv_error_file). /* Clear Error Log File */
    OUTPUT CLOSE.
END. /* DO lv_loop */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


