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
  File: ryrtbevntp.p

  Description:  Roundtable events API hook
  
  Purpose:      This procedure will be run automatically from Roundtable when any event is
                fired within rtb_evnt.p

  Parameters:

  History:
  --------
  (v:010000)    Task:        4043   UserRef:    
                Date:   21/12/1999  Author:     Anthony Swindells

  Update Notes: Created from scratch

  (v:010001)    Task:           2   UserRef:    Issue 8482
                Date:   02/13/2003  Author:     Thomas Hansen

  Update Notes: 05/02/03 thomas:
                - Added code to show additional information to the user when assigning objects.
                - Added generic log capabilities and added sue of this to the import events
                - Added support for new RTB events for RTB 9.1C02

  (v:010002)    Task:          20   UserRef:    
                Date:   03/06/2003  Author:     Thomas Hansen

  Update Notes: Issue 8696 : Module Load of DynObjc generate .edo?

  (v:010003)    Task:          26   UserRef:    
                Date:   03/11/2003  Author:     Thomas Hansen

  Update Notes: Issue 7361:
                - fixed bug where object checkin was not deletnig actionUnderWay records.
                - changed some of the formatting of the object-checkin and object-checkin-befor eprocedures.

  (v:010004)    Task:    90000018   UserRef:    
                Date:   01/28/2002  Author:     Dynamics Admin User

  Update Notes: Fix RV and RTB objects, to allow single r-code set

  (v:010005)    Task:    90000021   UserRef:    
                Date:   02/12/2002  Author:     Dynamics Admin User

  Update Notes: Remove RVDB dependency

  (v:010006)    Task:    90000048   UserRef:    
                Date:   12/18/2002  Author:     Dynamics Administration User

  Update Notes: 

  (v:020000)    Task:          31   UserRef:    
                Date:   03/25/2003  Author:     Thomas Hansen

  Update Notes: Issue 9648 :
                - Checked handling of object extensions for events regarding processing of objects in ICFDB
                - Removed auto-create of .ado file at cehck-out as this is not necessary

--------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       ryrtbevntp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    020000

DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.
ASSIGN
  cObjectName = "{&object-name}":U.

ASSIGN
  THIS-PROCEDURE:PRIVATE-DATA = "ryrtbevntp.p":U.

/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

DEFINE STREAM ls_output.

/* Integrate with afdbintrap.p */
{src/adm2/globals.i NEW GLOBAL}

{rtb/inc/afrtbglobs.i} /* pull in Roundtable global variables */

{launch.i     &Define-only = YES}
{checkerr.i &Define-only = YES}

DEFINE VARIABLE lv_assign_object_name       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lv_assign_object_type       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lv_assign_product_module    AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lv_assign_object_version    AS CHARACTER    NO-UNDO.

DEFINE VARIABLE cMesWinTitle                AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cMesWinMessage              AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cMesWinButtonList           AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cMesWinButtonDefault        AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cMesWinButtonCancel         AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cMesWinAnswerValue          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cMesWinAnswerDataType       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cMesWinAnswerFormat         AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cMesWinButtonPressed        AS CHARACTER    NO-UNDO.

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
         HEIGHT             = 33.67
         WIDTH              = 69.6.
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
               See notes in code for further explanation.

               Also needs to deal with regeneration of repository object data via xml file.

------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_event            AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_context          AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_other            AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error_message    AS CHARACTER NO-UNDO.

  DEFINE VARIABLE lActionUnderway             AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lImportUnderway             AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lSuppressMessages           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cReturnCharacter  AS CHARACTER  NO-UNDO.
  
  IF VALID-HANDLE(gshSessionManager)
  THEN
    RUN getActionUnderway IN gshSessionManager
                         (INPUT  "DYN":U,
                          INPUT  "ANY":U,
                          INPUT  "":U,
                          INPUT  "":U,
                          INPUT  "":U,
                          INPUT  NO,
                          OUTPUT lActionUnderway).
  IF  lActionUnderway = YES
  THEN RETURN.
  
  /* Inform the user that additional processing is being done. */
  IF VALID-HANDLE(Grtb-p-stat) THEN 
    RUN show_status_line IN Grtb-p-stat ("Processing Dynamics extensions for " + lv_assign_object_name + " ...").
  
  RUN scmHookAssignObject (INPUT grtb-wspace-id,
                           INPUT grtb-task-num,
                           INPUT grtb-userid,
                           INPUT lv_assign_object_name,
                           INPUT lv_assign_object_type,
                           INPUT lv_assign_product_module,
                           INPUT INTEGER(lv_assign_object_version),
                           OUTPUT op_error_message).
   
  /* If there are error messages from the assign process, 
     we should write these to the log if we are inthe process of importing */
      
  /* First check if we are in the process of importing. 
     If we are not importing, then we do not want to log the event, as 
     this is not all that useful. The collection of assign changes that '
     are made during the import process are much more useful. 
  */     
  IF VALID-HANDLE(gshSessionManager) THEN
  RUN getActionUnderway IN gshSessionManager
                       (INPUT  "SCM":U,
                        INPUT  "IMPORT":U,
                        INPUT  Grtb-wspace-id,
                        INPUT  "":U,
                        INPUT  "":U,
                        INPUT  NO,
                        OUTPUT lImportUnderway).
                        
  IF lImportUnderWay THEN DO:                                      
    PUBLISH "logEvent" (INPUT ip_event, 
                       INPUT "[":U + STRING(TIME, "HH:MM:SS":U) + "] ":U + ip_event + " - ":U + ip_other, 
                       INPUT "INF":U, 
                       INPUT Grtb-wspace-id, 
                       INPUT Grtb-userid, 
                       INPUT "LOG":U,
                       INPUT "dynrtb_import.log", 
                       INPUT "":U) .  
  
    IF op_error_message <> "":U THEN
    PUBLISH "logEvent" (INPUT ip_event, 
                       INPUT "ERROR / ":U + ip_event + " (":U + ip_other + ") : ":U + op_error_message, 
                       INPUT "ERROR":U, 
                       INPUT Grtb-wspace-id, 
                       INPUT Grtb-userid, 
                       INPUT "LOG,STATUS":U,
                       INPUT "dynrtb_import.log", 
                       INPUT "":U) .
    /* If we are suppressing error messages then reset the error message - 
       as we do not want this displaying in the process-event procedure 
       afterwards
    */    
    cReturnCharacter =  DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager, 
                        INPUT "SuppressMessages":U, 
                        INPUT YES). 
                        
    IF cReturnCharacter = "YES" THEN 
      ASSIGN 
        lSuppressMessages = TRUE. 
    ELSE 
      ASSIGN   
        lSuppressMessages = FALSE. 
        
    IF lSuppressMessages THEN 
      ASSIGN 
        op_error_message = "":U
        .
  END.   /* IF lImportUnderWay ...*/

  IF VALID-HANDLE(gshSessionManager) THEN
    RUN getActionUnderway IN gshSessionManager
                         (INPUT  "SCM":U,
                          INPUT  "ASS":U,
                          INPUT  ip_other,
                          INPUT  "":U,
                          INPUT  "":U,
                          INPUT  YES,
                          OUTPUT lActionUnderway).

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

  DEFINE VARIABLE lActionUnderway             AS LOGICAL   NO-UNDO.
  IF VALID-HANDLE(gshSessionManager)
  THEN
    RUN getActionUnderway IN gshSessionManager
                         (INPUT  "DYN":U
                         ,INPUT  "ANY":U
                         ,INPUT  "":U
                         ,INPUT  "":U
                         ,INPUT  "":U
                         ,INPUT  NO
                         ,OUTPUT lActionUnderway).
  IF lActionUnderway = YES
  THEN RETURN.

  ASSIGN
    lv_assign_object_name     = ENTRY(1, ip_other)
    lv_assign_object_type     = ENTRY(2, ip_other)
    lv_assign_product_module  = ENTRY(3, ip_other)
    lv_assign_object_version  = ENTRY(4, ip_other)
    .

  IF VALID-HANDLE(gshSessionManager)
  THEN
    RUN setActionUnderway IN gshSessionManager
                         (INPUT "SCM":U
                         ,INPUT "ASS":U
                         ,INPUT lv_assign_object_name
                         ,INPUT "":U
                         ,INPUT "":U
                         ).

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

  /* Set the workspace Root as an SCM session parameter */
  DYNAMIC-FUNCTION ("setSessionParam":U IN THIS-PROCEDURE, "_scm_root_directory":U, Grtb-wsroot ).     
  
  /* Set the relative source code directory as an SCM session parameter */
  DYNAMIC-FUNCTION ("setSessionParam":U IN THIS-PROCEDURE, "_scm_relative_source_directory":U, "src/icf":U).     

  /* Set the Currently Selected workspace as an SCM session parameter  */
  DYNAMIC-FUNCTION ("setSessionParam":U IN THIS-PROCEDURE, "_scm_current_workspace":U, Grtb-wspace-id ).     
  
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

  DEFINE VARIABLE ip_object_name              AS CHARACTER NO-UNDO.

  DEFINE VARIABLE lv_recid                    AS RECID     NO-UNDO.

  DEFINE VARIABLE lActionUnderway             AS LOGICAL   NO-UNDO.
  IF VALID-HANDLE(gshSessionManager)
  THEN
    RUN getActionUnderway IN gshSessionManager
                         (INPUT  "DYN":U
                         ,INPUT  "ANY":U
                         ,INPUT  "":U
                         ,INPUT  "":U
                         ,INPUT  "":U
                         ,INPUT  NO
                         ,OUTPUT lActionUnderway).
  IF  lActionUnderway = YES
  THEN RETURN.

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
      "The update of data failed as the Roundtable object (rtb_object) could not be found."
      VIEW-AS ALERT-BOX WARNING BUTTONS OK.
    ASSIGN
      op_error_message = "error":U.
    RETURN.
  END.

  RUN scmHookMoveModule (INPUT  grtb-wspace-id
                        ,INPUT  grtb-task-num
                        ,INPUT  grtb-userid
                        ,INPUT  rtb_object.object
                        ,INPUT  rtb_object.pmod
                        ,INPUT  rtb_object.version
                        ,OUTPUT op_error_message
                        ).

  IF VALID-HANDLE(gshSessionManager)
  THEN
    RUN getActionUnderway IN gshSessionManager
                         (INPUT  "SCM":U
                         ,INPUT  "MOV":U
                         ,INPUT  ip_other
                         ,INPUT  "":U
                         ,INPUT  "":U
                         ,INPUT  YES
                         ,OUTPUT lActionUnderway).

  /* The following code will clean up the actionUnderway table and also 
     re-enable the replication triggers - which may have been 
     disabled in scmHookMoveModule in rtb/prc/ryscmevntp.p 
  */
  ASSIGN
    ip_object_name = ip_other
    ip_object_name = REPLACE(ip_object_name,".ado":U,"":U)
    .
  IF VALID-HANDLE(gshSessionManager)
  THEN
    RUN getActionUnderway IN gshSessionManager
                         (INPUT  "SCM":U
                         ,INPUT  "ASS":U
                         ,INPUT  ip_object_name
                         ,INPUT  "":U
                         ,INPUT  "":U
                         ,INPUT  YES
                         ,OUTPUT lActionUnderway).

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

  DEFINE VARIABLE lActionUnderway             AS LOGICAL   NO-UNDO.
  IF VALID-HANDLE(gshSessionManager)
  THEN
    RUN getActionUnderway IN gshSessionManager
                         (INPUT  "DYN":U
                         ,INPUT  "ANY":U
                         ,INPUT  "":U
                         ,INPUT  "":U
                         ,INPUT  "":U
                         ,INPUT  NO
                         ,OUTPUT lActionUnderway).
  IF  lActionUnderway = YES
  THEN RETURN.

  IF VALID-HANDLE(gshSessionManager)
  THEN
    RUN setActionUnderway IN gshSessionManager
                         (INPUT "SCM":U
                         ,INPUT "MOV":U
                         ,INPUT ip_other
                         ,INPUT "":U
                         ,INPUT "":U
                         ).

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

------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER ip_event            AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER ip_context          AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER ip_other            AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error_message    AS CHARACTER NO-UNDO.

  DEFINE VARIABLE lDeployQuestion AS LOGICAL INITIAL YES NO-UNDO.

  IF SEARCH("rtb/uib/rtbdeployw.w":U) <> ?
  OR SEARCH("rtb/uib/rtbdeployw.r":U) <> ?
  THEN DO:

    MESSAGE   "Do you want to proceed with the Deployment Package enhancments ?"
      SKIP(1) " This hook deals with Application specific deployment issues."
      SKIP(1) "Continue with Deployment Package Hook?"
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
      UPDATE lDeployQuestion.

    IF lDeployQuestion = YES
    THEN DO:

      FIND FIRST rtb_site NO-LOCK
        WHERE STRING(RECID(rtb_site)) = ip_context
        NO-ERROR.
      IF NOT AVAILABLE rtb_site
      THEN DO:
        ASSIGN
          op_error_message = "Roundtable Site RECID value not found":U
          lDeployQuestion  = NO
          .
        RETURN.
      END.

      FIND FIRST rtb_deploy NO-LOCK
        WHERE STRING(RECID(rtb_deploy)) = ip_other
        NO-ERROR.
      IF NOT AVAILABLE rtb_deploy
      THEN DO:
        ASSIGN
          op_error_message = "Roundtable Deployment RECID value not found":U
          lDeployQuestion  = NO
          .
        RETURN.
      END.

      IF rtb_site.site-code <> rtb_deploy.site-code
      OR rtb_site.wspace-id <> rtb_deploy.wspace-id
      THEN DO:
        ASSIGN
          op_error_message = "Roundtable Site and Deployment value discrepencies":U
          lDeployQuestion  = NO
          .
        RETURN.
      END.
  
    END.

  END.

  IF lDeployQuestion = YES
  AND (SEARCH("rtb/uib/rtbdeployw.w":U) <> ?
    OR SEARCH("rtb/uib/rtbdeployw.r":U) <> ?)
  THEN DO:

    RUN rtb/uib/rtbdeployw.w (INPUT ip_context ,INPUT ip_other).

  END.

  ASSIGN
    op_error_message = "":U
    NO-ERROR.
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
               completed.

------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER ip_event            AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER ip_context          AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER ip_other            AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error_message    AS CHARACTER NO-UNDO.

  DEFINE VARIABLE cFileName                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFileList                   AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE lImportUnderway             AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cMessage                    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton                     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAnswer                     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cError  AS CHARACTER  NO-UNDO.
  
  
  ASSIGN
    op_error_message = "":U
    NO-ERROR.

  ASSIGN 
    cMessage = "Print a report of the import table as an audit detailing " + 
               "which objects were included in the import.".
                 
    IF VALID-HANDLE(gshSessionManager) THEN                 
    RUN showMessages IN gshSessionManager (INPUT  cMessage,    /* message to display */
                                           INPUT  "INF":U,          /* error type */
                                           INPUT  "&OK":U,    /* button list */
                                           INPUT  "&OK":U,           /* default button */ 
                                           INPUT  "":U,       /* cancel button */
                                           INPUT  "Roundtable Import Control (Dynamics Enhancement)":U,             /* error window title */
                                           INPUT  NO,              /* display if empty */ 
                                           INPUT  ?,                /* container handle */ 
                                           OUTPUT cButton           /* button pressed */
                                          ).
    ELSE 
    /* Display the message with a normal message dialog  */
    MESSAGE 
      cMessage
      VIEW-AS ALERT-BOX INFO BUTTONS OK
      TITLE "Roundtable Import Control (Dynamics Enhancement)":U.                                            

  ASSIGN
    cFileList = "":U
    .

  /* get list of deltas included in import */
  import-loop:
  FOR EACH rtb_import NO-LOCK
    WHERE rtb_import.wspace-id  = ip_other
    AND   rtb_import.done       = YES
    :

    IF INDEX(rtb_import.object,".df":U) = 0
    THEN NEXT import-loop.

    RUN rtb/p/rtb_pnam.p (INPUT  "", /* no root path to get relative path names */ 
                      INPUT  rtb_import.pmod, /*product Module */
                      INPUT  "DataDef":U, /*Code Subtype */
                      INPUT  rtb_import.OBJECT, /* Name of object */
                      INPUT  "PCODE":U,
                      OUTPUT cFileName, /* Comma separated list of object parts */ 
                      OUTPUT cError).

   /* As cFilename may contain multiple file parts, only kjeep the first part */
   cFilename = ENTRY(1, cFileName). 

    ASSIGN
      cFileList         = cFileList
                        + (IF cFileList <> "":U THEN ",":U ELSE "":U)
                        + cFileName
      .
  END.

  IF cFileList <> "":U
  THEN DO:
  
    PUBLISH "logEvent" (INPUT ip_event, 
                      INPUT "Import contained .df files. Remember to update databases with changes." + "~n", 
                      INPUT "":U, 
                      INPUT Grtb-wspace-id, 
                      INPUT Grtb-userid, 
                      INPUT "LOG":U,
                      INPUT "dynrtb_import.log", 
                      INPUT "":U) .

    ASSIGN
      cMessage = "The import table contained delta files that may need to be applied to the " + 
                  "databases in this workspace manually. Review the import list to see what deltas " +
                  "were included. Ensure any databases you are going to apply deltas for are connected " +
                  "and that no procedures are running that reference them." + "~n" + "~n" +
                  "Also be sure that the deltas in the list are not for common databases or have " +
                  "not already been applied manually." + "~n" + "~n" +
                  "To apply the deltas manually, use the database administration tool, before doing a " +
                  "recompile of the workspace.".
  
      IF VALID-HANDLE(gshSessionManager) THEN
      RUN showMessages IN gshSessionManager (INPUT  cMessage,    /* message to display */
                                             INPUT  "INF":U,          /* error type */
                                             INPUT  "&OK":U,    /* button list */
                                             INPUT  "&OK":U,           /* default button */ 
                                             INPUT  "":U,       /* cancel button */
                                             INPUT  "Roundtable Import Control (Dynamics Enhancement)":U,             /* error window title */
                                             INPUT  NO,              /* display if empty */ 
                                             INPUT  ?,                /* container handle */ 
                                             OUTPUT cButton           /* button pressed */
                                            ).
      ELSE 
      /* Display the message with a normal message dialog  */
      MESSAGE 
        cMessage
        VIEW-AS ALERT-BOX INFO BUTTONS OK
        TITLE "Roundtable Import Control (Dynamics Enhancement)":U.                                            
  END.
  
  /* Remove the actionUnderWay record for the import process. */
  IF VALID-HANDLE(gshSessionManager) THEN 
    RUN getActionUnderway IN gshSessionManager
                       (INPUT  "SCM":U,
                        INPUT  "IMPORT":U,
                        INPUT  Grtb-wspace-id,
                        INPUT  "":U,
                        INPUT  "":U,
                        INPUT  YES,
                        OUTPUT lImportUnderway).
  
  /* Write a closing comment to the import log file */
  ASSIGN cMessage = "[":U + STRING(TODAY) + " ":U + STRING(TIME, "HH:MM:SS") + "] ":U + 
                    "Import Processing Complete for workspace : ":U + Grtb-wspace-id + "~n":U  
                    + "===============================================================":U. 
                    
  PUBLISH "logEvent" (INPUT ip_event, 
                      INPUT cMessage, 
                      INPUT "":U, 
                      INPUT Grtb-wspace-id, 
                      INPUT Grtb-userid, 
                      INPUT "LOG":U,
                      INPUT "dynrtb_import.log", 
                      INPUT "":U) .

   RUN askQuestion IN gshSessionManager (INPUT        "Do you want to view the import log file? ",    /* message to display */
                                         INPUT        "&Yes,&No":U,    /* button list */
                                         INPUT        "&Yes":U,           /* default button */ 
                                         INPUT        "&No":U,       /* cancel button */
                                         INPUT        "Roundtable Import Control (Dynamics Enhancement)":U,             /* window title */
                                         INPUT        "":U,      /* data type of question */ 
                                         INPUT        "":U,          /* format mask for question */ 
                                         INPUT-OUTPUT cAnswer,              /* character value of answer to question */ 
                                               OUTPUT cButton           /* button pressed */
                                         ).
   
   IF TRIM(cButton, "&":U) = "YES":U THEN
   RUN rtb/p/rtb_rnpw.p (INPUT SEARCH("dynrtb_import.log"), INPUT 0).                                           

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
               started.

------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_event            AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_context          AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_other            AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error_message    AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE cMessage  AS CHARACTER  NO-UNDO.
  
  ASSIGN cMessage = "[":U + STRING(TODAY) + " ":U + STRING(TIME, "HH:MM:SS") + "] ":U + 
                    "Import Processing Begin for Workspace : ":U + Grtb-wspace-id. 
                    
  PUBLISH "logEvent" (INPUT ip_event, 
                      INPUT cMessage, 
                      INPUT "":U, 
                      INPUT Grtb-wspace-id, 
                      INPUT Grtb-userid, 
                      INPUT "LOG":U,
                      INPUT "dynrtb_import.log", 
                      INPUT "":U) .
       
  IF VALID-HANDLE(gshSessionManager) THEN DO:
    RUN setActionUnderway IN gshSessionManager
                         (INPUT "SCM":U,
                          INPUT "IMPORT":U,
                          INPUT Grtb-wspace-id,
                          INPUT "":U,
                          INPUT "":U).
                          
    ASSIGN
      cMesWinTitle            = "Roundtable Import Control (Dynamics Enhancement)":U
      cMesWinButtonList       = "&Yes,&No":U
      cMesWinButtonDefault    = "&Yes":U
      cMesWinButtonCancel     = "&No":U
      cMesWinAnswerValue      = "":U
      cMesWinAnswerDataType   = "":U
      cMesWinAnswerFormat     = "":U
      cMesWinMessage          = "If errors are encountered during the import processing, " + 
                                "do you want to continue having messages shown in a message dialog, " +
                                "or have all subsequent messages written to the status window and log file?" + "~n":U + "~n":U +  
                                "(Yes) - Show Messages / (No) - Suppress Messages".                    
                                
    RUN askQuestion IN gshSessionManager
     (INPUT cMesWinMessage,
      INPUT cMesWinButtonList,
      INPUT cMesWinButtonDefault,
      INPUT cMesWinButtonCancel,
      INPUT cMesWinTitle,
      INPUT cMesWinAnswerDataType,
      INPUT cMesWinAnswerFormat,
      INPUT-OUTPUT cMesWinAnswerValue,
      OUTPUT cMesWinButtonPressed
     ).
  
    IF TRIM(cMesWinButtonPressed, "&":U) = "No"
    THEN DO: 
        DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager,
                                             INPUT "SuppressMessages",
                                             INPUT "YES":U,
                                             INPUT YES).
    END.
    ELSE DO:
        DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager,
                                             INPUT "SuppressMessages",
                                             INPUT "NO":U,
                                             INPUT YES).    
    END.
  END. /* IF VALID-HANDLE() ...*/
                          
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

  DEFINE VARIABLE lActionUnderway             AS LOGICAL   NO-UNDO.

  DEFINE VARIABLE lv_recid                    AS RECID     NO-UNDO.

  DEFINE VARIABLE cButton                     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cErrorText                  AS CHARACTER NO-UNDO.

  ASSIGN lv_recid = INTEGER(ip_context) NO-ERROR.

  FIND FIRST rtb_object NO-LOCK
    WHERE RECID(rtb_object) = lv_recid
    NO-ERROR.
  IF NOT AVAILABLE rtb_object
  OR rtb_object.object <> ip_other THEN 
  DO:
    IF VALID-HANDLE(gshSessionManager) THEN 
    DO:
      RUN showMessages IN gshSessionManager
                      (INPUT {af/sup2/aferrortxt.i 'AF' '36' '?' '?' "'Progress Dynamics'" "'because the rtb_object record could not be found or the wrong object was found from the recid'"}
                      ,INPUT "ERR":U
                      ,INPUT "OK":U
                      ,INPUT "OK":U
                      ,INPUT "OK":U
                      ,INPUT "RTB Error"
                      ,INPUT YES
                      ,INPUT ?
                      ,OUTPUT cButton).
    END.
    ELSE 
    DO:
      MESSAGE
        "The update of data failed because the rtb_object record could not be found or the wrong object was found from the recid"
        VIEW-AS ALERT-BOX WARNING BUTTONS OK.
    END.
    ASSIGN
      op_error_message = "error":U.
    RETURN.
  END.

  IF rtb_object.obj-type <> "PCODE":U THEN 
  DO:
    IF VALID-HANDLE(gshSessionManager) THEN
      RUN getActionUnderway IN gshSessionManager
                           (INPUT  "SCM":U
                           ,INPUT  "ADD":U
                           ,INPUT  ip_other
                           ,INPUT  "":U
                           ,INPUT  "":U
                           ,INPUT  YES
                           ,OUTPUT lActionUnderway).
    RETURN. /* only interested in pcode objects */
  END.


  IF VALID-HANDLE(gshSessionManager) THEN
    RUN getActionUnderway IN gshSessionManager
                         (INPUT  "DYN":U
                         ,INPUT  "ANY":U
                         ,INPUT  "":U
                         ,INPUT  "":U
                         ,INPUT  "":U
                         ,INPUT  NO
                         ,OUTPUT lActionUnderway).
  IF lActionUnderway = YES THEN 
    RETURN.

  RUN scmHookCreateObject (INPUT  grtb-wspace-id
                          ,INPUT  grtb-task-num
                          ,INPUT  grtb-userid
                          ,INPUT  ip_other
                          ,OUTPUT op_error_message
                          ).

  IF VALID-HANDLE(gshSessionManager) THEN
    RUN getActionUnderway IN gshSessionManager
                         (INPUT  "SCM":U
                         ,INPUT  "ADD":U
                         ,INPUT  ip_other
                         ,INPUT  "":U
                         ,INPUT  "":U
                         ,INPUT  YES
                         ,OUTPUT lActionUnderway).

  IF op_error_message <> "":U THEN 
    RETURN.

  ASSIGN op_error_message = "":U NO-ERROR.
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

  DEFINE VARIABLE lActionUnderway             AS LOGICAL   NO-UNDO.
  IF VALID-HANDLE(gshSessionManager) THEN
    RUN getActionUnderway IN gshSessionManager
                         (INPUT  "DYN":U
                         ,INPUT  "ANY":U
                         ,INPUT  "":U
                         ,INPUT  "":U
                         ,INPUT  "":U
                         ,INPUT  NO
                         ,OUTPUT lActionUnderway).
  IF  lActionUnderway = YES THEN 
    RETURN.

  IF VALID-HANDLE(gshSessionManager) THEN
    RUN setActionUnderway IN gshSessionManager
                         (INPUT "SCM":U
                         ,INPUT "ADD":U
                         ,INPUT ip_other
                         ,INPUT "":U
                         ,INPUT "":U
                         ).

  ASSIGN op_error_message = "":U NO-ERROR.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-object-change-share-status) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE object-change-share-status Procedure 
PROCEDURE object-change-share-status :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:   ip_event          :   "OBJECT-CHANGE-SHARE-STATUS",
                ip_context        :   String value of RECID for rtb.rtb_object
                ip_other          :   Object, Old status, New Status, Workspace Path, Task Path
                ip_error_message  :   Ignored
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER ip_event            AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER ip_context          AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER ip_other            AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error_message    AS CHARACTER NO-UNDO.

  ASSIGN
    op_error_message = "":U
    NO-ERROR.
  RETURN. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-object-change-share-status-before) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE object-change-share-status-before Procedure 
PROCEDURE object-change-share-status-before :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters: ip_event     :   "OBJECT-CHANGE-SHARE-STATUS-BEFORE",
              ip_context   :   String value of RECID for rtb.rtb_object
              ip_other     :   Object, Old status, New Status, Workspace Path, Task Path
              ip_ok        :   Cancel if false 
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER ip_event            AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER ip_context          AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER ip_other            AS CHARACTER NO-UNDO.
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

  Notes:       
  
  ------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_event            AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_context          AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_other            AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error_message    AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE lv_recid                    AS RECID     NO-UNDO.
  DEFINE VARIABLE cButton                     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cErrorText                  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cObjectName                 AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lActionUnderway             AS LOGICAL    NO-UNDO.

  IF VALID-HANDLE(gshSessionManager) THEN 
  DO:

    RUN getActionUnderway IN gshSessionManager
                         (INPUT  "SCM":U,
                          INPUT  "TASKCOMP":U,
                          INPUT  "":U,
                          INPUT  "":U,
                          INPUT  "":U,
                          INPUT  NO,
                          OUTPUT lActionUnderway).
                         
    IF lActionUnderway = NO THEN 
    DO:

      RUN getActionUnderway IN gshSessionManager
                           (INPUT  "SCM":U,
                            INPUT  "SKIPDUMPYES":U,
                            INPUT  ip_other,
                            INPUT  "":U,
                            INPUT  "":U,
                            INPUT  YES,
                            OUTPUT lActionUnderway).

      RUN getActionUnderway IN gshSessionManager
                           (INPUT  "SCM":U,
                            INPUT  "SKIPDUMPNO":U,
                            INPUT  ip_other,
                            INPUT  "":U,
                            INPUT  "":U,
                            INPUT  YES,
                            OUTPUT lActionUnderway).

    END. /* lActionUnderway = NO */
  END. /* VALID-HANDLE(gshSessionManager) */

  ASSIGN lv_recid = INTEGER(ip_context) NO-ERROR.

  FIND FIRST rtb_object NO-LOCK
    WHERE RECID(rtb_object) = lv_recid
    NO-ERROR.
  IF NOT AVAILABLE rtb_object
  OR rtb_object.object <> ip_other THEN 
  DO:
    IF VALID-HANDLE(gshSessionManager) THEN     
      RUN showMessages IN gshSessionManager
                      (INPUT {af/sup2/aferrortxt.i 'AF' '36' '?' '?' "'Progress Dynamics'" "'because the rtb_object record could not be found or the wrong object was found from the recid'"},
                       INPUT "ERR":U,
                       INPUT "OK":U,
                       INPUT "OK":U,
                       INPUT "OK":U,
                       INPUT "RTB Error",
                       INPUT YES,
                       INPUT ?,
                       OUTPUT cButton).
    ELSE 
      MESSAGE
        "The update of data failed because the rtb_object record could not be found or the wrong object was found from the recid"
        VIEW-AS ALERT-BOX WARNING BUTTONS OK.
        
    ASSIGN op_error_message = "error":U.
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
  IF NOT AVAILABLE rtb_ver THEN 
  DO:
    IF VALID-HANDLE(gshSessionManager) THEN 
      RUN showMessages IN gshSessionManager
                      (INPUT {af/sup2/aferrortxt.i 'AF' '36' '?' '?' "'Progress Dynamics'" "'because the rtb_ver record could not be found'"},
                       INPUT "ERR":U,
                       INPUT "OK":U,
                       INPUT "OK":U,
                       INPUT "OK":U,
                       INPUT "RTB Error",
                       INPUT YES,
                       INPUT ?,
                       OUTPUT cButton).
    ELSE 
      MESSAGE
        "The update of data failed because the rtb_ver record could not be found"
        VIEW-AS ALERT-BOX WARNING BUTTONS OK.
    
    ASSIGN op_error_message = "error":U.
    RETURN.
  END.

  /* The following code will clean up the actionUnderway table and also 
     re-enable the replication triggers - which may have been 
     disabled in scmHookMoveModule in rtb/prc/ryscmevntp.p 
  */
  ASSIGN
    cObjectName = ip_other
    cObjectName = REPLACE(cObjectName,".ado":U,"":U).
    
  IF VALID-HANDLE(gshSessionManager) THEN
    RUN getActionUnderway IN gshSessionManager
                         (INPUT  "SCM":U, 
                          INPUT  "ASS":U,
                          INPUT  cObjectName,
                          INPUT  "":U,
                          INPUT  "":U,
                          INPUT  YES,
                          OUTPUT lActionUnderway).

  ASSIGN op_error_message = "":U NO-ERROR.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-object-check-in-before) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE object-check-in-before Procedure 
PROCEDURE object-check-in-before :
/* ------------------------------------------------------------------------------
Purpose:     Before object is checked in
  Parameter :  ip_context       : STRING value of RECID of the rtb_object table
  / Meaning :  ip_other         : Object name
               op_error_message : non blank will cancel check in

  Notes:       Do preliminary checking and abort object check in if details 
               cannot be found that will be required after the check in to
               update the Dynamics task object table.
               Belt and braces really !
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_event            AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_context          AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER  ip_other            AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error_message    AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE lv_recid                    AS RECID      NO-UNDO.

  DEFINE VARIABLE cButton                     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cErrorText                  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE lActionUnderway             AS LOGICAL    NO-UNDO.

  ASSIGN lv_recid = INTEGER(ip_context) NO-ERROR.

  FIND FIRST rtb_object NO-LOCK
    WHERE RECID(rtb_object) = lv_recid
    NO-ERROR.
  IF NOT AVAILABLE rtb_object
  OR rtb_object.object <> ip_other THEN 
  DO:
    IF VALID-HANDLE(gshSessionManager) THEN 
    DO:
      RUN showMessages IN gshSessionManager
                      (INPUT {af/sup2/aferrortxt.i 'AF' '36' '?' '?' "'Progress Dynamics'" "'the rtb_object record could not be found or the wrong object was found from the recid'"},
                       INPUT "ERR":U,
                       INPUT "OK":U,
                       INPUT "OK":U,
                       INPUT "OK":U,
                       INPUT "RTB Error",
                       INPUT YES,
                       INPUT ?,
                       OUTPUT cButton).
    END.
    ELSE 
    DO:
      MESSAGE
        "The update of data failed because the rtb_object record could not be found or the wrong object was found from the recid"
        VIEW-AS ALERT-BOX WARNING BUTTONS OK.
    END.
    ASSIGN op_error_message = "error":U.
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
  IF NOT AVAILABLE rtb_ver THEN 
  DO:
    IF VALID-HANDLE(gshSessionManager) THEN 
      RUN showMessages IN gshSessionManager
                      (INPUT {af/sup2/aferrortxt.i 'AF' '36' '?' '?' "'Progress Dynamics'" "'the rtb_ver record could not be found'"},
                       INPUT "ERR":U,
                       INPUT "OK":U,
                       INPUT "OK":U,
                       INPUT "OK":U,
                       INPUT "RTB Error",
                       INPUT YES,
                       INPUT ?,
                       OUTPUT cButton).
    ELSE
      MESSAGE
        "The update of data failed because the rtb_ver record could not be found"
        VIEW-AS ALERT-BOX WARNING BUTTONS OK.
        
    ASSIGN op_error_message = "error":U.
    RETURN.
  END.

  IF VALID-HANDLE(gshSessionManager) THEN 
  DO:
    RUN getActionUnderway IN gshSessionManager
                         (INPUT  "SCM":U,
                          INPUT  "TASKCOMP":U,
                          INPUT  "":U,
                          INPUT  "":U,
                          INPUT  "":U,
                          INPUT  NO,
                          OUTPUT lActionUnderway).
                         
    IF lActionUnderway = NO THEN 
    DO:
      ASSIGN
        cMesWinTitle            = "Object Check-In (Dynamics Enhancement)":U
        cMesWinButtonList       = "Export,Skip,Cancel":U
        cMesWinButtonDefault    = "Export":U
        cMesWinButtonCancel     = "Cancel":U
        cMesWinAnswerValue      = "":U
        cMesWinAnswerDataType   = "":U
        cMesWinAnswerFormat     = "":U.

      /* Question 01 */
      ASSIGN
        cMesWinMessage  = 'Do you wish to automatically export the object information from the Progress Dynamics repository (ICFDB)'
                        + 'and generate the new/updated .ado file containing the XML content/information of the object.' + '~n':U + '~n' 
                        + 'If you answer "Skip", an INCORRECT version could be checked into the Roundtable Repository.'
                        + 'This should ONLY be skipped if the correct version is already on the O/S, i.e.'
                        + 'a Module Load has been done and you are just completing the task. And NO changes have been done'
                        + 'to the object in the Progress Dynamics repository since the module load.' + '~n':U + '~n':U
                        + 'Generate .ado XML files ? (usually choose "Export")'.

      /* Try and display a nice formatted error if we can */
      RUN askQuestion IN gshSessionManager
                     (INPUT cMesWinMessage,
                      INPUT cMesWinButtonList,
                      INPUT cMesWinButtonDefault,
                      INPUT cMesWinButtonCancel,
                      INPUT cMesWinTitle,
                      INPUT cMesWinAnswerDataType,
                      INPUT cMesWinAnswerFormat,
                      INPUT-OUTPUT cMesWinAnswerValue,
                      OUTPUT cMesWinButtonPressed).

      IF LOOKUP(cMesWinButtonPressed,"Skip":U) > 0 THEN 
      DO:
        /* Question 02 */
        ASSIGN 
          cMesWinMessage  = 'Are you really sure you know what you are doing and really do not want the Progress Dynamics enhancement.'
                          + 'If you continue with this decision, then the INCORRECT version of objects could be checked into Roundtable.'
                          + '~n':U + '~n':U 
                          + 'So, to be sure we will ask again: '+ '~n':U
                          + 'Do you want to SKIP the Progress Dynamics enhancement and NOT generate the new/updated .ado file'
                          + ' containing the XML content/information of the object.'
                          + '~n':U + '~n':U 
                          + 'Please obtain appropriate authorisation if you answer "Skip" to this question'.

        /* Try and display a nice formatted error if we can */
        RUN askQuestion IN gshSessionManager
                       (INPUT cMesWinMessage,
                        INPUT cMesWinButtonList,
                        INPUT cMesWinButtonDefault,
                        INPUT cMesWinButtonCancel,
                        INPUT cMesWinTitle,
                        INPUT cMesWinAnswerDataType,
                        INPUT cMesWinAnswerFormat,
                        INPUT-OUTPUT cMesWinAnswerValue,
                        OUTPUT cMesWinButtonPressed).
      END.

      CASE cMesWinButtonPressed:
        WHEN cMesWinButtonCancel /* Cancel */ THEN 
        DO:
            ASSIGN
              op_error_message = "Object Check-In Cancelled".
            RETURN.
        END.
        WHEN "Export":U THEN
            RUN setActionUnderway IN gshSessionManager
                                 (INPUT "SCM":U,
                                  INPUT "SKIPDUMPNO":U,
                                  INPUT ip_other,
                                  INPUT "":U,
                                  INPUT "":U).
        WHEN "Skip":U THEN
            RUN setActionUnderway IN gshSessionManager
                                 (INPUT "SCM":U,
                                  INPUT "SKIPDUMPYES":U,
                                  INPUT ip_other,
                                  INPUT "":U,
                                  INPUT "":U).
        OTHERWISE 
        DO: /* DECIDE LATER */
          /* do nothing */
        END.
      END CASE.

    END. /* lActionUnderway = NO */

  END. /* VALID-HANDLE(gshSessionManager) */

  RUN scmHookCheckInObject (INPUT grtb-wspace-id,
                            INPUT grtb-task-num,
                            INPUT grtb-userid,
                            INPUT ip_other,
                            OUTPUT op_error_message).

  IF op_error_message <> "":U THEN 
    RETURN.

  ASSIGN op_error_message = "":U NO-ERROR.
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

&IF DEFINED(EXCLUDE-object-check-out-before) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE object-check-out-before Procedure 
PROCEDURE object-check-out-before :
/*------------------------------------------------------------------------------
  Purpose:     Before object is checked out
  Parameter :  ip_context       : STRING value of RECID of the rtb_object table
  / Meaning :  ip_other         : Object name
               op_error_message : non blank will cancel

  Notes:       There is no concept of checking out objects in the Dynamics 
               repository. But, we can use this hook to check if the object 
               exists in the ICFDB database. If it does, then we should try 
               and get it created in the ICFDB database. 
               
               The checks to see if objects should be registered in the ICFDB 
               database (if RTB expects a .ado file) and other checks will be 
               done in ryscmevntp.p - where this is already being done for the 
               hooks to move objects to a new module. 
               
               We will use the same hook as the one to move objects to a new module 
               as this does exactly the same thing. 
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

  /*
  IF SEARCH("rtb/prc/afrtbappsp.p":U) <> ?
  OR SEARCH("rtb/prc/afrtbappsp.r":U) <> ?
  THEN DO:
    RUN rtb/prc/afrtbappsp.p (INPUT INTEGER(ip_context)
                             ,INPUT ip_other
                             ,OUTPUT op_error_message).
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

  DEFINE VARIABLE lActionUnderway             AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lImportUnderway             AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lSuppressMessages           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cReturnCharacter  AS CHARACTER  NO-UNDO.

  IF VALID-HANDLE(gshSessionManager)
  THEN
    RUN getActionUnderway IN gshSessionManager
                         (INPUT  "DYN":U
                         ,INPUT  "ANY":U
                         ,INPUT  "":U
                         ,INPUT  "":U
                         ,INPUT  "":U
                         ,INPUT  NO
                         ,OUTPUT lActionUnderway).
  IF  lActionUnderway = YES
  THEN RETURN.

  /* First check if we are in the process of importing. 
     If we are not importing, then we do not want to log the event, as 
     this is not all that useful. The collection of assign changes that '
     are made during the import process are much more useful. 
  */     
  IF VALID-HANDLE(gshSessionManager) THEN
  RUN getActionUnderway IN gshSessionManager
                       (INPUT  "SCM":U,
                        INPUT  "IMPORT":U,
                        INPUT  Grtb-wspace-id,
                        INPUT  "":U,
                        INPUT  "":U,
                        INPUT  NO,
                        OUTPUT lImportUnderway).
                        
  IF lImportUnderWay THEN DO:                                      
    PUBLISH "logEvent" (INPUT ip_event, 
                       INPUT ip_event + " - ":U + ip_other, 
                       INPUT "ERROR":U, 
                       INPUT Grtb-wspace-id, 
                       INPUT Grtb-userid, 
                       INPUT "LOG":U,
                       INPUT "dynrtb_import.log", 
                       INPUT "":U) .  
  
    IF op_error_message <> "":U THEN
    PUBLISH "logEvent" (INPUT ip_event, 
                       INPUT "ERROR / ":U + ip_event + " (":U + ip_other + ") : ":U + op_error_message, 
                       INPUT "ERROR":U, 
                       INPUT Grtb-wspace-id, 
                       INPUT Grtb-userid, 
                       INPUT "LOG,STATUS":U,
                       INPUT "dynrtb_import.log", 
                       INPUT "":U) .
    /* If we are suppressing error messages then reset the error message - 
       as we do not want this displaying in the process-event procedure 
       afterwards
    */    
    cReturnCharacter =  DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager, 
                        INPUT "SuppressMessages":U, 
                        INPUT YES). 
                        
    IF cReturnCharacter = "YES" THEN 
      ASSIGN 
        lSuppressMessages = TRUE. 
    ELSE 
      ASSIGN   
        lSuppressMessages = FALSE. 
        
    IF lSuppressMessages THEN 
      ASSIGN 
        op_error_message = "":U
        .
  END.   /* IF lImportUnderWay ...*/

  IF VALID-HANDLE(gshSessionManager)
  THEN
    RUN getActionUnderway IN gshSessionManager
                         (INPUT  "SCM":U
                         ,INPUT  "DEL":U
                         ,INPUT  lv_assign_object_name
                         ,INPUT  "":U
                         ,INPUT  "":U
                         ,INPUT  YES
                         ,OUTPUT lActionUnderway).

  IF VALID-HANDLE(gshSessionManager)
  THEN
    RUN getActionUnderway IN gshSessionManager
                         (INPUT  "SCM":U
                         ,INPUT  "SKIPDEL":U
                         ,INPUT  lv_assign_object_name
                         ,INPUT  "":U
                         ,INPUT  "":U
                         ,INPUT  YES
                         ,OUTPUT lActionUnderway).

  ASSIGN
    lv_assign_object_name = "":U
    op_error_message      = "":U
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
  DEFINE VARIABLE lChoice                     AS LOGICAL   NO-UNDO.

  ASSIGN
    lv_assign_object_name = ip_other.

  DEFINE VARIABLE lActionUnderway             AS LOGICAL   NO-UNDO.
  IF VALID-HANDLE(gshSessionManager)
  THEN
    RUN getActionUnderway IN gshSessionManager
                         (INPUT  "DYN":U
                         ,INPUT  "ANY":U
                         ,INPUT  "":U
                         ,INPUT  "":U
                         ,INPUT  "":U
                         ,INPUT  NO
                         ,OUTPUT lActionUnderway).
  IF  lActionUnderway = YES
  THEN RETURN.

  IF VALID-HANDLE(gshSessionManager)
  THEN
    RUN setActionUnderway IN gshSessionManager
                         (INPUT "SCM":U
                         ,INPUT "DEL":U
                         ,INPUT ip_other
                         ,INPUT "":U
                         ,INPUT "":U
                         ).

  ASSIGN
    lChoice = YES.

  MESSAGE
    "Progress Dynamics Enhancement (usually say YES):"
    SKIP(1)
    "Do you wish to DELETE the objects information from the Progress Dynamics Repository (ICFDB)."
    SKIP(1)
    "If you answer NO, an data inconsistancy could occur between the two Repositories."
    SKIP(1)
    "This should ONLY be skipped if you reverting to a previous version, i.e."
    SKIP
    "By doing a DELETE and reverting back to a previous version"
    SKIP(1)
    "Delete the Object from the Progress Dynamics Repository ?"
    SKIP(1)
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
    UPDATE lChoice.

  IF lChoice = NO
  THEN DO:

    MESSAGE
      "Are you really sure you know what you are doing and really do not want the Progress Dynamics enhancement."
      SKIP
      "If you continue with this decision, then data inconsistancies could occur between the two Repositories."
      SKIP(1)
      "So, to be sure we will ask again."
      SKIP
      "Do you want to SKIP the Progress Dynamics enhancement and NOT delete the object from the Progress Dynamics Repository."
      SKIP
      "You should normally answer NO."
      SKIP
      "Please obtain appropriate authorisation if you answer YES to this question"
      SKIP(1)
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
      UPDATE lChoice.

    IF lChoice = YES
    THEN DO:

      IF VALID-HANDLE(gshSessionManager)
      THEN
        RUN setActionUnderway IN gshSessionManager
                             (INPUT "SCM":U
                             ,INPUT "SKIPDEL":U
                             ,INPUT ip_other
                             ,INPUT "":U
                             ,INPUT "":U
                             ).

    END.

  END.

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

  DEFINE VARIABLE cProcName                   AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE hProcHandle                 AS HANDLE       NO-UNDO.

  ASSIGN
    cProcName   = "rtb/prc/ryscmevntp.p":U
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
  DEFINE VARIABLE hValidHandles              AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hProcHandle                 AS HANDLE       NO-UNDO.

  ASSIGN
    cProcName      = "ryscmevntp.p":U
    hValidHandles = SESSION:FIRST-PROCEDURE.

  DO WHILE VALID-HANDLE(hValidHandles)
  AND NOT (VALID-HANDLE(hProcHandle))
  :

    IF hValidHandles:PRIVATE-DATA = cProcName
    THEN
      ASSIGN
        hProcHandle = hValidHandles.

    ASSIGN
      hValidHandles = hValidHandles:NEXT-SIBLING.

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

  DEFINE VARIABLE cSummaryMessages            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFullMessages               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButtonList                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessageTitle               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lUpdateErrorLog             AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lSuppressDisplay            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cButton                     AS CHARACTER  NO-UNDO.
  
  ASSIGN
    op_error_message = "":U
    NO-ERROR.

  /*
  IF ip_event = "ASSIGN-OBJECT-BEFORE":U OR ip_event = "ASSIGN-OBJECT":U
  OR ip_event = "CREATE-CV-BEFORE":U     OR ip_event = "CREATE-CV":U
  OR ip_event = "OBJECT-ADD-BEFORE":U    OR ip_event = "OBJECT-ADD":U
  OR ip_event = "OBJECT-DELETE-BEFORE":U OR ip_event = "OBJECT-DELETE":U
  THEN DO:

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

    {af/sup/afdebug.i}

  END.
  */

  /* Must we check if plips are running ? */

  IF NOT CONNECTED("ICFDB":U)
  THEN RETURN.

  CASE ip_event:
    WHEN "ASSIGN-OBJECT":U                      THEN RUN assign-object              (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "ASSIGN-OBJECT-BEFORE":U               THEN RUN assign-object-before       (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "BEFORE-CHANGE-WORKSPACE":U            THEN RUN before-change-workspace    (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "CHANGE-WORKSPACE":U                   THEN RUN change-workspace           (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "CREATE-CV":U                          THEN RUN create-cv                  (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "CREATE-CV-BEFORE":U                   THEN RUN create-cv-before           (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "DEPLOY":U                             THEN RUN deploy                     (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "DEPLOY-BEFORE":U                      THEN RUN deploy-before              (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "DEPLOY-SITE-CREATE":U                 THEN RUN deploy-site-create         (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "DEPLOY-SITE-CREATE-BEFORE":U          THEN RUN deploy-site-create-before  (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "IMPORT":U                             THEN RUN import                     (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "IMPORT-BEFORE":U                      THEN RUN import-before              (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "MOVE-TO-WEB":U                        THEN RUN move-to-web                (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "MOVE-TO-WEB-BEFORE":U                 THEN RUN move-to-web-before         (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "OBJECT-ADD":U                         THEN RUN object-add                 (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "OBJECT-ADD-BEFORE":U                  THEN RUN object-add-before          (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "OBJECT-CHANGE-SHARE-STATUS-BEFORE":U  THEN RUN object-change-share-status-before (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "OBJECT-CHANGE-SHARE-STATUS":U         THEN RUN object-change-share-status (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "OBJECT-CHECK-IN":U                    THEN RUN object-check-in            (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "OBJECT-CHECK-IN-BEFORE":U             THEN RUN object-check-in-before     (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "OBJECT-CHECK-OUT":U                   THEN RUN object-check-out           (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "OBJECT-CHECK-OUT-BEFORE":U            THEN RUN object-check-out-before    (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "OBJECT-COMPILE":U                     THEN RUN object-compile             (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "OBJECT-COMPILE-BEFORE":U              THEN RUN object-compile-before      (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "OBJECT-DELETE":U                      THEN RUN object-delete              (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "OBJECT-DELETE-BEFORE":U               THEN RUN object-delete-before       (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "PARTNER-LOAD":U                       THEN RUN partner-load               (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "PARTNER-LOAD-BEFORE":U                THEN RUN partner-load-before        (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "PROPATH-CHANGE":U                     THEN RUN propath-change             (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "PROPATH-CHANGE-BEFORE":U              THEN RUN propath-change-before      (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "RELEASE-CREATE":U                     THEN RUN release-create             (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "RELEASE-CREATE-BEFORE":U              THEN RUN release-create-before      (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "ROUNDTABLE-STARTUP":U                 THEN RUN roundtable-startup         (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "ROUNDTABLE-SHUTDOWN":U                THEN RUN roundtable-shutdown        (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "SCHEMA-UPDATE":U                      THEN RUN schema-update              (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "SCHEMA-UPDATE-BEFORE":U               THEN RUN schema-update-before       (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "SESSION-SHUTDOWN":U                   THEN RUN session-shutdown           (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "TASK-CHANGE":U                        THEN RUN task-change                (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "TASK-COMPLETE":U                      THEN RUN task-complete              (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "TASK-COMPLETE-BEFORE":U               THEN RUN task-complete-before       (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "TASK-CREATE":U                        THEN RUN task-create                (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "TASK-CREATE-BEFORE":U                 THEN RUN task-create-before         (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
    WHEN "TASK-CREATE-DURING":U                 THEN RUN task-create-during         (INPUT ip_event, INPUT ip_context, INPUT ip_other, OUTPUT op_error_message).
  END CASE.

  /* Try and display a nice formatted error if we can */
  IF op_error_message <> "":U
  THEN DO:

    IF VALID-HANDLE(gshSessionManager)
    THEN DO:
      RUN showMessages IN gshSessionManager
                      (INPUT op_error_message
                      ,INPUT "ERR":U
                      ,INPUT "OK":U
                      ,INPUT "OK":U
                      ,INPUT "OK":U
                      ,INPUT "RTB Error"
                      ,INPUT YES
                      ,INPUT ?
                      ,OUTPUT cButton
                      ).
      ASSIGN
        op_error_message = "Failed".
    END.
    ELSE DO:
      RUN af/app/afmessagep.p (INPUT  op_error_message
                              ,INPUT  "OK":U
                              ,INPUT  "RTB Error":U
                              ,OUTPUT cSummaryMessages
                              ,OUTPUT cFullMessages
                              ,OUTPUT cButtonList
                              ,OUTPUT cMessageTitle
                              ,OUTPUT lUpdateErrorLog
                              ,OUTPUT lSuppressDisplay
                              ).
      ASSIGN
        op_error_message = cFullMessages.

    END.

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

------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_event            AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_context          AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_other            AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error_message    AS CHARACTER NO-UNDO.

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

&IF DEFINED(EXCLUDE-roundtable-shutdown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE roundtable-shutdown Procedure 
PROCEDURE roundtable-shutdown :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:   ip_event          :   "ROUNDTABLE-SHUTDOWN",
                ip_context        :   
                ip_other          :   
                ip_error_message  :   Ignored 
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

&IF DEFINED(EXCLUDE-roundtable-startup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE roundtable-startup Procedure 
PROCEDURE roundtable-startup :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:   ip_event          :   "ROUNDTABLE-STARTUP",
                ip_context        :   
                ip_other          :   
                ip_error_message  :   Cancel if false 

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

&IF DEFINED(EXCLUDE-session-shutdown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE session-shutdown Procedure 
PROCEDURE session-shutdown :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:   ip_event          :   "SESSION-SHUTDOWN",
                ip_context        :   
                ip_other          :   
                ip_error_message  :   Ignored 
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

  /* Set the currently selecte dtask number as an SCM session parameter  */
  DYNAMIC-FUNCTION ("setSessionParam":U IN THIS-PROCEDURE, "_scm_current_task_number":U, ip_other ).  
  
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

------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_event            AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_context          AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_other            AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error_message    AS CHARACTER NO-UNDO.

  DEFINE VARIABLE cButton                     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cErrorText                  AS CHARACTER NO-UNDO.

  DEFINE VARIABLE lActionUnderway    AS LOGICAL    NO-UNDO.

  IF VALID-HANDLE(gshSessionManager)
  THEN DO:

    RUN getActionUnderway IN gshSessionManager
                         (INPUT  "SCM":U
                         ,INPUT  "SKIPDUMPYES":U
                         ,INPUT  ip_other
                         ,INPUT  "":U
                         ,INPUT  "":U
                         ,INPUT  YES
                         ,OUTPUT lActionUnderway).

    RUN getActionUnderway IN gshSessionManager
                         (INPUT  "SCM":U
                         ,INPUT  "SKIPDUMPNO":U
                         ,INPUT  ip_other
                         ,INPUT  "":U
                         ,INPUT  "":U
                         ,INPUT  YES
                         ,OUTPUT lActionUnderway).

    RUN getActionUnderway IN gshSessionManager
                         (INPUT  "SCM":U
                         ,INPUT  "TASKCOMP":U
                         ,INPUT  ip_other
                         ,INPUT  "":U
                         ,INPUT  "":U
                         ,INPUT  YES
                         ,OUTPUT lActionUnderway).

  END. /* VALID-HANDLE(gshSessionManager) */

  FIND FIRST rtb_task NO-LOCK
    WHERE rtb_task.task-num = INTEGER(ip_other)
    NO-ERROR.

  /* Ensure completion worked ok and they did not cancel due to errors */
  IF NOT AVAILABLE rtb_task
  OR rtb_task.task-status = "w":U
  THEN RETURN.

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

  ASSIGN
    cMesWinTitle            = "Task Completion (Dynamics Enhancement)":U
    cMesWinButtonList       = "Export All,Skip All,Decide Later,Cancel":U
    cMesWinButtonDefault    = "Export All":U
    cMesWinButtonCancel     = "Cancel":U
    cMesWinAnswerValue      = "":U
    cMesWinAnswerDataType   = "":U
    cMesWinAnswerFormat     = "":U
    .

  IF VALID-HANDLE(gshSessionManager)
  THEN DO:

    /* Question 01 */
    ASSIGN
      cMesWinMessage  = 'Do you wish to automatically export the objects information from the Progress Dynamics repository (ICFDB)'
                      + ' and generate the new/updated .ado file containing the XML content/information of the object.'
                      + CHR(10)
                      + 'If you choose "Decide Later", you will asked for each object if you wish to export it or not.'
                      + CHR(10)
                      + 'If you answer "Skip All", an INCORRECT version could be checked into the Roundtable Repository.'
                      + ' This should ONLY be skipped if the correct version is already on the O/S, i.e.'
                      + ' a Module Load has been done and you are just completing the task. And NO changes have been done'
                      + ' to the object in the Progress Dynamics repository since the module load.'
                      + CHR(10)
                      + 'Generate .ado XML files ? (usually choose "Export All")'
                      .

    /* Try and display a nice formatted error if we can */
    RUN askQuestion IN gshSessionManager
                   (INPUT cMesWinMessage
                   ,INPUT cMesWinButtonList
                   ,INPUT cMesWinButtonDefault
                   ,INPUT cMesWinButtonCancel
                   ,INPUT cMesWinTitle
                   ,INPUT cMesWinAnswerDataType
                   ,INPUT cMesWinAnswerFormat
                   ,INPUT-OUTPUT cMesWinAnswerValue
                   ,OUTPUT cMesWinButtonPressed
                   ).

    IF LOOKUP(cMesWinButtonPressed,"Skip All":U) > 0
    THEN DO:

      /* Question 02 */
      ASSIGN
        cMesWinMessage  = 'Are you really sure you know what you are doing and really do not want the Progress Dynamics enhancement.'
                        + CHR(10)
                        + 'If you continue with this decision, then the INCORRECT version of objects could be checked into Roundtable.'
                        + CHR(10)
                        + 'So, to be sure we will ask again.'
                        + CHR(10)
                        + 'Do you want to SKIP the Progress Dynamics enhancement and NOT generate the new/updated .ado file'
                        + ' containing the XML content/information of the object.'
                        + CHR(10)
                        + 'Please obtain appropriate authorisation if you answer "Skip All" to this question'
                        .

      /* Try and display a nice formatted error if we can */
      RUN askQuestion IN gshSessionManager
                     (INPUT cMesWinMessage
                     ,INPUT cMesWinButtonList
                     ,INPUT cMesWinButtonDefault
                     ,INPUT cMesWinButtonCancel
                     ,INPUT cMesWinTitle
                     ,INPUT cMesWinAnswerDataType
                     ,INPUT cMesWinAnswerFormat
                     ,INPUT-OUTPUT cMesWinAnswerValue
                     ,OUTPUT cMesWinButtonPressed
                     ).

    END.

    CASE cMesWinButtonPressed:
      WHEN cMesWinButtonCancel /* Cancel */
        THEN DO:
          ASSIGN
            op_error_message = "Task Completion Cancelled".
          RETURN.
        END.
      WHEN "Export All":U
        THEN
          RUN setActionUnderway IN gshSessionManager
                               (INPUT "SCM":U
                               ,INPUT "SKIPDUMPNO":U
                               ,INPUT ip_other
                               ,INPUT "":U
                               ,INPUT "":U
                               ).
      WHEN "Skip All":U
        THEN DO:
          RUN setActionUnderway IN gshSessionManager
                               (INPUT "SCM":U
                               ,INPUT "SKIPDUMPYES":U
                               ,INPUT ip_other
                               ,INPUT "":U
                               ,INPUT "":U
                               ).        
      END.
      OTHERWISE DO: /* DECIDE LATER */
        /* do nothing */
      END.
    END CASE.

    RUN setActionUnderway IN gshSessionManager
                         (INPUT "SCM":U
                         ,INPUT "TASKCOMP":U
                         ,INPUT ip_other
                         ,INPUT "":U
                         ,INPUT "":U
                         ).

  END. /* VALID-HANDLE(gshSessionManager) */

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

------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ip_event            AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_context          AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ip_other            AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER op_error_message    AS CHARACTER NO-UNDO.

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

