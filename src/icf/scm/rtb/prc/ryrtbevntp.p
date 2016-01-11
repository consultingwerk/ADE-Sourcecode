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

  (v:010005)    Task:    90000021   UserRef:    
                Date:   02/12/2002  Author:     Dynamics Admin User

  Update Notes: Remove RVDB dependency

----------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       ryrtbevntp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010001

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

DEFINE VARIABLE lv_assign_object_name       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lv_assign_object_type       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lv_assign_product_module    AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lv_assign_object_version    AS CHARACTER    NO-UNDO.

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
         HEIGHT             = 27.14
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
               See notes in code for further explanation.

               Also needs to deal with regeneration of repository object data via xml file.

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

  RUN scmHookAssignObject (INPUT grtb-wspace-id
                          ,INPUT grtb-task-num
                          ,INPUT grtb-userid
                          ,INPUT lv_assign_object_name
                          ,INPUT lv_assign_object_type
                          ,INPUT lv_assign_product_module
                          ,INPUT INTEGER(lv_assign_object_version)
                          ,OUTPUT op_error_message
                          ).

  DEFINE VARIABLE lAtionUnderway    AS LOGICAL    NO-UNDO.
  IF VALID-HANDLE(gshSessionManager)
  THEN
    RUN getActionUnderway IN gshSessionManager
                         (INPUT  "SCM":U
                         ,INPUT  "ASS":U
                         ,INPUT  ip_other
                         ,INPUT  "":U
                         ,INPUT  "":U
                         ,INPUT  YES
                         ,OUTPUT lAtionUnderway).

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
      "The update of Dynamics data failed as the Roundtable object (rtb_object) could not be found."
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

  DEFINE VARIABLE lAtionUnderway    AS LOGICAL    NO-UNDO.
  IF VALID-HANDLE(gshSessionManager)
  THEN
    RUN getActionUnderway IN gshSessionManager
                         (INPUT  "SCM":U
                         ,INPUT  "MOV":U
                         ,INPUT  ip_other
                         ,INPUT  "":U
                         ,INPUT  "":U
                         ,INPUT  YES
                         ,OUTPUT lAtionUnderway).

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

  ASSIGN
    op_error_message = "":U
    NO-ERROR.

  MESSAGE
    SKIP "Print a report of the import table as an audit detailing"
    SKIP "what objects were included in the import."
    SKIP
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.

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
      cFileList         = cFileList
                        + (IF cFileList <> "":U THEN ",":U ELSE "":U)
                        + cFileName
      .

  END.

  IF cFileList <> "":U
  THEN
    MESSAGE   "The import table contained delta files that may need to be applied to the"
      SKIP    "databases in this workspace manually. Review the import list to see what deltas"
      SKIP    "were included. Ensure any databases you are going to apply deltas for are connected"
      SKIP    "and that no procedures are running that reference them."
      SKIP(1) "Also be sure that the deltas in the list are not for common databases or have"
      SKIP    "not already been applied manually."
      SKIP(1) "To apply the deltas manually, use the database administration tool, before doing a"
      SKIP    "recompile of the workspace."
      SKIP
      VIEW-AS ALERT-BOX INFORMATION.

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
                      (INPUT {af/sup2/aferrortxt.i 'AF' '36' '?' '?' "'Dynamics'" "'because the rtb_object record could not be found or the wrong object was found from the recid'"}
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
        "The update of Dynamics failed because because the rtb_object record could not be found or the wrong object was found from the recid"
        VIEW-AS ALERT-BOX WARNING BUTTONS OK.
    END.
    ASSIGN
      op_error_message = "error":U.
    RETURN.
  END.

  IF rtb_object.obj-type <> "PCODE":U
  THEN DO:
    IF VALID-HANDLE(gshSessionManager)
    THEN
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

  RUN scmHookCreateObject (INPUT  grtb-wspace-id
                          ,INPUT  grtb-task-num
                          ,INPUT  grtb-userid
                          ,INPUT  ip_other
                          ,OUTPUT op_error_message
                          ).

  IF VALID-HANDLE(gshSessionManager)
  THEN
    RUN getActionUnderway IN gshSessionManager
                         (INPUT  "SCM":U
                         ,INPUT  "ADD":U
                         ,INPUT  ip_other
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
                         ,INPUT "ADD":U
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
                      (INPUT {af/sup2/aferrortxt.i 'AF' '36' '?' '?' "'Dynamics'" "'because the rtb_object record could not be found or the wrong object was found from the recid'"}
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
        "The update of Dynamics failed because because the rtb_object record could not be found or the wrong object was found from the recid"
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
                      (INPUT {af/sup2/aferrortxt.i 'AF' '36' '?' '?' "'Dynamics'" "'because the rtb_ver record could not be found'"}
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
        "The update of Dynamics failed because the rtb_ver record could not be found"
        VIEW-AS ALERT-BOX WARNING BUTTONS OK.
    END.
    ASSIGN
      op_error_message = "error":U.
    RETURN.
  END.

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
                      (INPUT {af/sup2/aferrortxt.i 'AF' '36' '?' '?' "'Dynamics'" "'the rtb_object record could not be found or the wrong object was found from the recid'"}
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
        "The update of Dynamics failed because the rtb_object record could not be found or the wrong object was found from the recid"
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
                      (INPUT {af/sup2/aferrortxt.i 'AF' '36' '?' '?' "'Dynamics'" "'the rtb_ver record could not be found'"}
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
        "The update of Dynamics failed because the rtb_ver record could not be found"
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

  DEFINE VARIABLE lAtionUnderway    AS LOGICAL    NO-UNDO.
  IF VALID-HANDLE(gshSessionManager)
  THEN
    RUN getActionUnderway IN gshSessionManager
                         (INPUT  "SCM":U
                         ,INPUT  "DEL":U
                         ,INPUT  lv_assign_object_name
                         ,INPUT  "":U
                         ,INPUT  "":U
                         ,INPUT  YES
                         ,OUTPUT lAtionUnderway).

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

  /* handle:FILE-NAME    = "rtb/prc/ryscmevntp.p":U */
  /* handle:PRIVATE-DATA = "ryscmevntp.p":U         */
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
  DEFINE VARIABLE hValidHanldles              AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hProcHandle                 AS HANDLE       NO-UNDO.

  ASSIGN
    cProcName      = "ryscmevntp.p":U
    hValidHanldles = SESSION:FIRST-PROCEDURE.

  /* handle:FILE-NAME    = "rtb/prc/ryscmevntp.p":U */
  /* handle:PRIVATE-DATA = "ryscmevntp.p":U         */
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

  DEFINE VARIABLE lAtionUnderway    AS LOGICAL    NO-UNDO.
  IF VALID-HANDLE(gshSessionManager)
  THEN
    RUN getActionUnderway IN gshSessionManager
                         (INPUT  "SCM":U
                         ,INPUT  "SKIPDUMP":U
                         ,INPUT  ip_other
                         ,INPUT  "":U
                         ,INPUT  "":U
                         ,INPUT  YES
                         ,OUTPUT lAtionUnderway).

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

  DEFINE VARIABLE lChoice                     AS LOGICAL   NO-UNDO.

  ASSIGN
    lChoice = YES.

  MESSAGE
    "Dynamics Enhancement (usually say YES):"
    SKIP(1)
    "Do you wish to automatically export the objects information from the Dynamics repository (ICFDB)"
    SKIP
    "and generate the new/updated .ado file containing the XML content/information of the object."
    SKIP(1)
    "If you answer NO, an INCORRECT version could be checked into the Roundtable Repository."
    SKIP(1)
    "This should ONLY be skipped if the correct version is already on the O/S, i.e."
    SKIP
    "a Module Load has been done and you are just completing the task. And NO changes have been done"
    SKIP
    "to the object in the Dynamics repository since the module load."
    SKIP(1)
    "Generate .ado XML files ?"
    SKIP(1)
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
    UPDATE lChoice.

  IF lChoice = NO
  THEN DO:

    MESSAGE
      "Are you really sure you know what you are doing and really do not want the Dynamics enhancement."
      SKIP
      "If you continue with this decision, then the INCORRECT version of objects could be checked into Roundtable."
      SKIP(1)
      "So, to be sure we will ask again."
      SKIP
      "Do you want to SKIP the Dynamics enhancement and NOT generate the new/updated .ado file"
      SKIP
      "containing the XML content/information of the object. You should normally answer NO."
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
                             ,INPUT "SKIPDUMP":U
                             ,INPUT ip_other
                             ,INPUT "":U
                             ,INPUT "":U
                             ).

    END.

  END.

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

