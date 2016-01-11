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
  File: rtbpreevent.p

  Description:  RTB pre event procedure

  Purpose:      Used to do any pre Roundtable hooks and events processing

  Parameters:   <none>

  History:
  --------
  (v:010001)    Task:        0000   UserRef:    
                Date:   22/07/2002  Author:     Anthony Swindells

  Update Notes: Initial code

  (v:010000)    Task:           3   UserRef:    
                Date:   01/12/2003  Author:     

  Update Notes: Test creation of custom variants

  (v:020000)    Task:          47   UserRef:    
                Date:   05/09/2003  Author:     Thomas Hansen

  Update Notes: Issue 10308:
                Added check for a locked workspace to prevent the DCU upgrade
                from being run if the import process is cancelled.

  (v:030000)    Task:          52   UserRef:    
                Date:   06/16/2003  Author:     Thomas Hansen

  Update Notes: Issue 10472:
                Prevent users from being able to log on to workspace during DCU upgrade

  (v:030001)    Task:          58   UserRef:    
                Date:   09/01/2003  Author:     Thomas Hansen

  Update Notes: Add extra checks for DCU files

-----------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rtbpreevent.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010001

DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.
ASSIGN
  cObjectName = "{&object-name}":U.

ASSIGN
  THIS-PROCEDURE:PRIVATE-DATA = "rtbpreevntp.p":U.

/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

{rtb/inc/afrtbglobs.i}

DEFINE VARIABLE cMesWinTitle                AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cMesWinMessage              AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cMesWinButtonList           AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cMesWinButtonDefault        AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cMesWinButtonCancel         AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cMesWinAnswerValue          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cMesWinAnswerDataType       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cMesWinAnswerFormat         AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cMesWinButtonPressed        AS CHARACTER    NO-UNDO.
DEFINE VARIABLE glDCUCancelled              AS LOGICAL      NO-UNDO INITIAL FALSE.
DEFINE VARIABLE cRTBSessionSettings         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hConfMan                    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRtbApi                     AS HANDLE     NO-UNDO.

DEFINE STREAM sOut.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-buildFileSCM) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD buildFileSCM Procedure 
FUNCTION buildFileSCM RETURNS CHARACTER
  ( INPUT ipFilename AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createFile Procedure 
FUNCTION createFile RETURNS LOGICAL
  ( INPUT ipFilename AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD deleteFile Procedure 
FUNCTION deleteFile RETURNS LOGICAL
  ( INPUT ipFilename AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD findFile Procedure 
FUNCTION findFile RETURNS CHARACTER
  ( INPUT ipFilename AS CHARACTER )  FORWARD.

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
         HEIGHT             = 36.57
         WIDTH              = 74.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

{ry/app/ryplipmain.i}

SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "DCU_BeforeInitialize":U  ANYWHERE.

SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "DCU_Cancel":U  ANYWHERE.

SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "ICFCFM_UpgradeStart"     ANYWHERE.

SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "ICFCFM_UpgradeComplete"  ANYWHERE.

SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "ICFStart_BeforeInitialize":U  ANYWHERE.

SUBSCRIBE TO "logEvent" ANYWHERE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-compileModules) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE compileModules Procedure 
PROCEDURE compileModules :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  pcCompileModules - the MATCHES list of module to compile. 
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcCompileModules  AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plShowErrors      AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE iCompileLoop            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cCompileError           AS CHARACTER  NO-UNDO.
  
  PUBLISH "logEvent" (INPUT "IMPORT EVENT", 
                      INPUT "[":U + STRING(TIME , "HH:MM:SS") + "] Compiling DCU & RTB procedures.", 
                      INPUT "":U, 
                      INPUT Grtb-wspace-id, 
                      INPUT Grtb-userid, 
                      INPUT "LOG,STATUS":U,
                      INPUT "dynrtb_import.log", 
                      INPUT "":U) .        
  
  /* Do a selective compile of all of the objects in the specified modules */
  /* - *DCU* : The DCU specific modules */
  /* - *RTB* : The RTB and SCMRTB specific modules */ 
  /* - *af-aaa* : Files in the root Dynamics directory */ 
  /* - *af-app* : Files in the af/app directory */ 
  
  /*     The code has been changed to only do a selective compile - not a forced compile, as this */
  /*     will take a very long time when a large module like af-app is included                   */
  
  DO iCompileLoop = 1 TO NUM-ENTRIES(pcCompileModules,","):  
    SESSION:SET-WAIT-STATE("GENERAL":U). 
    
    IF NOT VALID-HANDLE(hRtbApi) THEN
        RUN rtb/p/rtb_api.p PERSISTENT SET hRtbApi.
  
    PUBLISH "logEvent" (INPUT "IMPORT EVENT", 
                        INPUT "[":U + STRING(TIME , "HH:MM:SS") + "] Compiling modules " + ENTRY(iCompileLoop, pcCompileModules) + ".":U, 
                        INPUT "":U, 
                        INPUT Grtb-wspace-id, 
                        INPUT Grtb-userid, 
                        INPUT "LOG,STATUS":U,
                        INPUT "dynrtb_import.log", 
                        INPUT "":U) .        

    RUN selective_compile IN hRtbApi
                         (INPUT 0,               /* Ptask-num  - task number to select objects from or 0 to ignore tasks */
                         INPUT ENTRY(iCompileLoop, pcCompileModules),            /* Pmodule    - module to select objects from or MATCHES pattern */
                         INPUT "*":U,            /* Pobj-group - Object group to select objects from or MATCHES pattern */
                         INPUT "PCODE":U,       /* Pobj-type  - Object types to select (PCODE, PFILE, etc.) or MATCHES pattern */
                         INPUT "*":U,           /* Pobject    - Object to select or MATCHES pattern */
                         INPUT YES,             /* Pforce     - Logical YES to force compile of (current) objects */
                         INPUT NO,              /* Plistings  - Logical YES to generate compile listings */
                         INPUT NO,              /* Pxref      - Logical YES to perform xref of selected object(s) */
                         OUTPUT cCompileError  /* Perror     - This will be non-blank if the process could no be performed */
                         ).
    
      SESSION:SET-WAIT-STATE("":U). 
    
    /* If there are errors during the compile, then show the 
       contents of the log file in a procedure editor in the same
       way as RTB does 
    */
    IF cCompileError <> "":U AND 
       plShowErrors THEN
        IF SEARCH("rtb/p/rtb_rnpw.p") <> ? OR 
           SEARCH("rtb/p/rtb_rnpw.r") <> ? THEN
        RUN rtb/p/rtb_rnpw.p (INPUT ENTRY(2,cCompileError), INPUT 0).               
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-DCU_BeforeInitialize) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DCU_BeforeInitialize Procedure 
PROCEDURE DCU_BeforeInitialize :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iSessionParamLoop       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cSessionParameters      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSessionParamEntry      AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cSessionTypeDCU         AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cSessionFullSetup       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSessionDefaultSetup    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSessionDefaultDCUType  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSessionDefaultICFType  AS CHARACTER  NO-UNDO.

  ASSIGN
    cSessionParameters      = SESSION:ICFPARAM
    cSessionDefaultSetup   = "icfsetup.xml":U
    cSessionDefaultDCUType  = "ProgressSetup":U
    cSessionDefaultICFType  = cSessionDefaultDCUType
    .
    
  cSessionFullSetup = findFile(cSessionDefaultSetup).
  IF cSessionFullSetup <> "":U
  THEN
    ASSIGN
      cSessionDefaultSetup = cSessionFullSetup.

  blockSessionParam:
  DO iSessionParamLoop = 1 TO NUM-ENTRIES(cSessionParameters):

    ASSIGN
      cSessionParamEntry = ENTRY(iSessionParamLoop, cSessionParameters).

    /* If there are no = or more than one =, this is an invalid parameter, so ignore it. */
    IF NUM-ENTRIES(cSessionParamEntry,"=":U) <> 2
    THEN
      NEXT blockSessionParam.

    IF ENTRY(1,cSessionParamEntry,"=":U) = "DCUSETUPTYPE":U
    THEN
      ASSIGN
        cSessionDefaultDCUType = ENTRY(2,cSessionParamEntry,"=":U).

  END.

  IF cSessionDefaultSetup <> "":U
  THEN
    ASSIGN
      cSessionTypeDCU = "ICFCONFIG=" + cSessionDefaultSetup.

  IF cSessionDefaultDCUType <> "":U
  THEN
    ASSIGN
      cSessionTypeDCU = cSessionTypeDCU + (IF cSessionTypeDCU <> "" THEN "," ELSE "")
                      + "DCUSETUPTYPE=" + cSessionDefaultDCUType.

  IF cSessionDefaultICFType <> "":U
  THEN
    ASSIGN
      cSessionTypeDCU = cSessionTypeDCU + (IF cSessionTypeDCU <> "" THEN "," ELSE "")
                      + "ICFSESSTYPE=" + cSessionDefaultICFType.

  IF cSessionTypeDCU = "":U
  THEN
    ASSIGN
      cSessionTypeDCU = SESSION:ICFPARAM.

  DYNAMIC-FUNCTION ("setSessionParam":U IN THIS-PROCEDURE, "ICFPARAM":U, cSessionTypeDCU ).

  DYNAMIC-FUNCTION ("setSessionParam":U IN THIS-PROCEDURE, "quit_on_end":U, "NO" ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-DCU_Cancel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DCU_Cancel Procedure 
PROCEDURE DCU_Cancel :
/*------------------------------------------------------------------------------
  Purpose:     Catch that the DCU has been cancelled
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  ASSIGN glDCUCancelled = TRUE. 

  /* Now that the DCU upgrade has been cancelled,
     we need to remove the lock on the workspace.
  */   

  FIND FIRST rtb_wspace WHERE rtb_wspace.wspace-id = Grtb-wspace-id NO-LOCK. 
  
  IF INDEX(rtb_wspace.locked-by, "DCU":U) > 0 THEN
  DO:
    FIND FIRST rtb_wspace WHERE rtb_wspace.wspace-id = Grtb-wspace-id EXCLUSIVE-LOCK. 
    PUBLISH "logEvent" (INPUT "IMPORT POST-EVENT", 
                        INPUT "[":U + STRING(TIME , "HH:MM:SS") + "] Removing lock on workspace after DCU upgrade." + "~n":U, 
                        INPUT "":U, 
                        INPUT Grtb-wspace-id, 
                        INPUT Grtb-userid, 
                        INPUT "LOG,STATUS":U,
                        INPUT "dynrtb_import.log", 
                        INPUT "":U) .        
  
    ASSIGN rtb_wspace.locked-by = "":U.     
    /* re-find the workspace with a NO-LOCK */
    RELEASE rtb_wspace.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ICFCFM_UpgradeComplete) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ICFCFM_UpgradeComplete Procedure 
PROCEDURE ICFCFM_UpgradeComplete :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE lOverrideCreated        AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cFileName               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE  lActionUnderway         AS LOGICAL    NO-UNDO.

  ASSIGN
    cFileName = buildFileSCM(grtb-wspace-id).

  /* Step 9.2 */
  ASSIGN
    lOverrideCreated = deleteFile(cFileName).

  IF lOverrideCreated
  THEN DO:
    IF VALID-HANDLE(gshSessionManager) THEN
    /* Delete the actionUnderWay event that was created when the upgrade was started */
    RUN getActionUnderway IN gshSessionManager
                         (INPUT  "SCM":U,
                          INPUT  "DCUUPGRADE":U,
                          INPUT  "":U,
                          INPUT  "":U,
                          INPUT  "":U,
                          INPUT  YES,
                          OUTPUT lActionUnderway).
  END. /* lOverrideCreated */
  /* Now that the DCU upgrade has either been completed,
     we need to remove the lock on the workspace.
  */   
  
  FIND FIRST rtb_wspace WHERE rtb_wspace.wspace-id = Grtb-wspace-id NO-LOCK. 
  
  IF INDEX(rtb_wspace.locked-by, "DCU":U) > 0 THEN
  DO:
    FIND FIRST rtb_wspace WHERE rtb_wspace.wspace-id = Grtb-wspace-id EXCLUSIVE-LOCK. 
    PUBLISH "logEvent" (INPUT "IMPORT POST-EVENT", 
                        INPUT "[":U + STRING(TIME , "HH:MM:SS") + "] Removing lock on workspace after DCU upgrade." + "~n":U, 
                        INPUT "":U, 
                        INPUT Grtb-wspace-id, 
                        INPUT Grtb-userid, 
                        INPUT "LOG,STATUS":U,
                        INPUT "dynrtb_import.log", 
                        INPUT "":U) .        
  
    ASSIGN rtb_wspace.locked-by = "":U.     
    /* re-find the workspace with a NO-LOCK */
    RELEASE rtb_wspace.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ICFCFM_UpgradeStart) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ICFCFM_UpgradeStart Procedure 
PROCEDURE ICFCFM_UpgradeStart :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lOverrideCreated        AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE cFileName AS CHARACTER  NO-UNDO.

  ASSIGN
    cFileName = buildFileSCM(grtb-wspace-id).

  /* Step 9.1 */
  ASSIGN
    lOverrideCreated = createFile(cFileName).

  IF lOverrideCreated
  THEN DO:
    IF VALID-HANDLE(gshSessionManager) THEN DO:
      /* Set the actionUnderWay event that indicates that we are in 
         the middle of a DCU update
      */  
      RUN setActionUnderway IN gshSessionManager
                           (INPUT "SCM":U,
                            INPUT "DCUUPGRADE":U,
                            INPUT "":U,
                            INPUT "":U,
                            INPUT "":U).    
    END.
  END. /* lOverrideCreated */
  /* Before we start the DCU we have to place a lock on the workspace, 
     so that users who try and log on to the workspace during an upgrade are 
     prevented from starting the Dynamics environment.  */
  
  FIND FIRST rtb_wspace WHERE rtb_wspace.wspace-id = Grtb-wspace-id EXCLUSIVE-LOCK. 
  IF rtb_wspace.locked-by = "":U THEN
  DO:
    PUBLISH "logEvent" (INPUT "IMPORT PRE-EVENT", 
                        INPUT "[":U + STRING(TIME , "HH:MM:SS") + "] Locking workspace before DCU upgrade starts." + "~n":U, 
                        INPUT "":U, 
                        INPUT Grtb-wspace-id, 
                        INPUT Grtb-userid, 
                        INPUT "LOG,STATUS":U,
                        INPUT "dynrtb_import.log", 
                        INPUT "":U) .        
  
    ASSIGN rtb_wspace.locked-by = "DCU (Dynamics Upgrade in Process)":U.     
    /* re-find the workspace with a NO-LOCK */
    RELEASE rtb_wspace.
  END.
      

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ICFStart_BeforeInitialize) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ICFStart_BeforeInitialize Procedure 
PROCEDURE ICFStart_BeforeInitialize :
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
  Parameter :  ipScmContext       : ""
  / Meaning :  ipScmOther         : Workspace id
               cErrorMessage : ignored

  Notes:       The main contents of this hook have been moved to the before-assign hook so
               every movement of an object is captured rather than just via an import.

               This procedure will be run automatically from Roundtable when an import is
               completed.

------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER ipFilename      AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER opReturnMessage AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE iLoop                   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cMessage                AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hHandle                 AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRtbevntp               AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hRtbApi                 AS HANDLE     NO-UNDO.

  DEFINE VARIABLE cCompileError           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lOverrideCreated        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lCompile                AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lViewCompileErrors      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cFullName               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cButton                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lAnswer                 AS LOGICAL    NO-UNDO.

  ASSIGN cFullName = findFile(ipFilename).
  
  IF cFullName <> "":U THEN 
  DO:
    /* Check if the workspace is still locked by the import process- 
       which will indicate that the import was cancelled. This is the only 
       way we can check if the import process has been cancelled. */
    
    FIND FIRST rtb_wspace WHERE rtb_wspace.wspace-id = Grtb-wspace-id NO-LOCK NO-ERROR. 
    /* Check if the workspace is locked  */
    IF rtb_wspace.locked-by = "import":U THEN 
    DO:
        /* Delete the log file preventing the hooks from running. */
        ASSIGN lOverrideCreated = deleteFile(ipFilename).
    
      /* Show a message to the user */
        cMessage = "The import process was cancelled. The DCU upgrade process will therefore also be cancelled. " + "~n":U.
  
        MESSAGE 
           cMessage
          VIEW-AS ALERT-BOX INFO
          TITLE "DCU Upgrade":U.    
        
        RETURN.
    END.
    
    cMessage = "Before running the DCU it is necessary to compile all of the objects in the DCU and RTB modules." + "~n":U + "~n":U + 
               "This will ensure that the latest version of the source code for the DCU and RTB procedures is being run. ".
    
      MESSAGE 
         cMessage
        VIEW-AS ALERT-BOX INFO
        TITLE "RTB and Dynamics pre DCU upgrade compilation":U.      
    
    /* Compile the DCU and framework code before start the DCU */
    RUN compileModules (INPUT "*dcu*,*rtb*,*af-aaa*,*af-app*",
                        INPUT NO /* Show errors */).

    /* Step 5 - Kill all running environment plips. 
       This only needs to be done if the DCU is to be run and should only be done once the messages 
       above have been displayed correctly - as we use the session manage rto display the messages
    */
    
    PUBLISH "logEvent" (INPUT "IMPORT EVENT", 
                        INPUT "[":U + STRING(TIME , "HH:MM:SS") + "] Shutting down Dynamics environment ...", 
                        INPUT "":U, 
                        INPUT Grtb-wspace-id, 
                        INPUT Grtb-userid, 
                        INPUT "LOG,STATUS":U,
                        INPUT "dynrtb_import.log", 
                        INPUT "":U) .        
    
    /* The Configuration Manager is responsible for shutting down the environment */
    IF VALID-HANDLE(hConfMan) THEN
      APPLY "CLOSE":U TO hConfMan.
    
    /* As we may not have the SCM procedures shut down yet, as the event              */
    /* ICFCFM_StartSessionShutdown may NOT have been published from the               */
    /* configuration manager, we publish it separately to force the SCM               */
    /* procedures referencing the ICFDB database to shut down before we start the DCU */
    PUBLISH "ICFCFM_SessionShutdown". 

    PUBLISH "logEvent" (INPUT "IMPORT EVENT", 
                        INPUT "[":U + STRING(TIME , "HH:MM:SS") + "] Running Dynamics Configuration Utility ..." + "~n":U, 
                        INPUT "":U, 
                        INPUT Grtb-wspace-id, 
                        INPUT Grtb-userid, 
                        INPUT "LOG,STATUS":U,
                        INPUT "dynrtb_import.log", 
                        INPUT "":U) .        
    
    PUBLISH "ICFCFM_UpgradeStart".

    RUN icfcfg.w.

    IF NOT glDCUCancelled THEN
    DO:
      PUBLISH "ICFCFM_UpgradeComplete".
      /* If the DCU has not been cancelled, then we continue with the rest of the
         post import processing */

      PUBLISH "logEvent" (INPUT "IMPORT EVENT",
                          INPUT "[":U + STRING(TIME , "HH:MM:SS") + "] Dynamics Configuration Utility Upgrade Complete." + "~n":U,
                          INPUT "":U,
                          INPUT Grtb-wspace-id,
                          INPUT Grtb-userid,
                          INPUT "LOG,STATUS":U,
                          INPUT "dynrtb_import.log",
                          INPUT "":U).


      /* To ensure that the Framework is restarted with the correct session type settings,
         ICFSTART_beforeInitialize procedure has been added - this works in the same
         way as the procedure with the same name in rtb/prc/ryrtbevntp.p.
      */
      cMessage = "Before running the second stage of the DCU it is necessary to compile all of the objects in the DCU, RTB and essential framework modules." + "~n":U + "~n":U +
                 "This will ensure that the latest version of the source code for the DCU, RTB and essential framework procedures are being run. ".

      MESSAGE
         cMessage
        VIEW-AS ALERT-BOX INFO
        TITLE "RTB and Dynamics post DCU upgrade compulsory compilation":U.

      /* Compile the DCU and framework code before re-starting the framework */
      RUN compileModules (INPUT "*dcu*,*rtb*,*af-app*,*ry-app*",
                          INPUT YES /* Show errors */).
    END.
    ELSE
      PUBLISH "logEvent" (INPUT "IMPORT EVENT",
                          INPUT "[":U + STRING(TIME , "HH:MM:SS") + "] Dynamics Configuration Utility Upgrade Cancelled." + "~n":U,
                          INPUT "":U,
                          INPUT Grtb-wspace-id,
                          INPUT Grtb-userid,
                          INPUT "LOG,STATUS":U,
                          INPUT "dynrtb_import.log",
                          INPUT "":U).

    /* Delete the lock file preventing the integration hooks from running */
    ASSIGN lOverrideCreated = deleteFile(ipFilename).

    IF lOverrideCreated THEN
    DO:

    END. /* lOverrideCreated */

    /* Re-start the Framework. */
    PUBLISH "logEvent" (INPUT "IMPORT EVENT",
                        INPUT "[":U + STRING(TIME , "HH:MM:SS") + "] Re-starting Dynamics Environment." + "~n":U,
                        INPUT "":U,
                        INPUT Grtb-wspace-id,
                        INPUT Grtb-userid,
                        INPUT "LOG,STATUS":U,
                        INPUT "dynrtb_import.log",
                        INPUT "":U) .

    RUN icfstart.p.

    PUBLISH "logEvent" (INPUT "IMPORT EVENT",
                        INPUT "[":U + STRING(TIME , "HH:MM:SS") + "] Dynamics Environment started." + "~n":U,
                        INPUT "":U,
                        INPUT Grtb-wspace-id,
                        INPUT Grtb-userid,
                        INPUT "LOG,STATUS":U,
                        INPUT "dynrtb_import.log",
                        INPUT "":U) .

  END. /* IF cFullName <> "":U */

  /* Write a closing comment to the import log file */
  ASSIGN cMessage = "[":U + STRING(TODAY) + " - ":U + STRING(TIME, "HH:MM:SS") + "] ":U +
                    "Import Pre-Processing Complete for Workspace : ":U + Grtb-wspace-id.

  PUBLISH "logEvent" (INPUT "IMPORT EVENT":U,
                      INPUT cMessage,
                      INPUT "":U,
                      INPUT Grtb-wspace-id,
                      INPUT Grtb-userid,
                      INPUT "LOG":U,
                      INPUT "dynrtb_import.log",
                      INPUT "":U) .
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-importBefore) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE importBefore Procedure 
PROCEDURE importBefore :
/*------------------------------------------------------------------------------
  Purpose   : Before import
  Parameter :  
  Notes     : This procedure will be run automatically from Roundtable when an import is started.
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER ipFilename      AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER opErrorMessage  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE lUpgrade                AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lChoice                 AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lOverrideCreated        AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cMessage  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDCUObjectList          AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE lAnswer AS LOGICAL    NO-UNDO INITIAL FALSE.
  
  ASSIGN lChoice          = YES
         lOverrideCreated = NO.
    
 
  ASSIGN cMessage = "[":U + STRING(TODAY) + " ":U + STRING(TIME, "HH:MM:SS") + "] ":U + 
                    "ImportBefore Pre-Processing for workspace : ":U + Grtb-wspace-id. 
                    
  PUBLISH "logEvent" (INPUT "IMPORT-BEFORE PRE-EVENT":U, 
                      INPUT cMessage, 
                      INPUT "":U, 
                      INPUT Grtb-wspace-id, 
                      INPUT Grtb-userid, 
                      INPUT "LOG":U,
                      INPUT "dynrtb_import.log", 
                      INPUT "OVERWRITE":U) .
    
  /*  Check if there are DCU files in the import that should result in a DCU session being run after the import. */
  /*                                                                                                             */
  /*  This is done by searching for the following objects :                                                      */
  /*  icfsetup.xml                                                                                               */
  /*  *patch.xml                                                                                                 */
  /*  setup.xml e.g. setup20A01.xml                                                                              */
  /*                                                                                                             */
  /*  This is only necessary to do in the *af-aaa and *db-icfdfd modules - where these objects will be located   */
          
  /* First set the upgrade status to be NO */
  ASSIGN lUpgrade = NO.
  
  /* Check the contents of the rtb_import table for this workspace */
  FOR EACH rtb_import NO-LOCK 
      WHERE rtb_import.wspace-id  = grtb-wspace-id AND   
                    rtb_import.obj-type   = "PCODE":U : 
    
    /* Only look for certani files in the af-aa and db-icfdfd modules */
    IF (rtb_import.pmod MATCHES "*db-icfdfd":U OR 
        rtb_import.pmod MATCHES "*af-aaa":U) THEN
      IF (rtb_import.OBJECT = "icfsetup.xml":U      OR 
          rtb_import.OBJECT MATCHES "*patch~.xml":U OR 
          rtb_import.OBJECT MATCHES "*setup*~.xml":U) AND 
          (NOT rtb_import.done) THEN
      DO:
        ASSIGN cDcuObjectList = IF cDcuObjectList = "":U THEN rtb_import.OBJECT + "~n":U ELSE cDcuObjectList + rtb_import.OBJECT + "~n":U. 
        ASSIGN lUpgrade = YES.
      END.     
  END.
  
  IF lUpgrade
  THEN DO:
      ASSIGN
        cMesWinTitle            = "Roundtable Import / DCU Extensions (Dynamics Enhancement)":U
        cMesWinMessage          = "The IMPORT contains object(s) that are used by the Progress Dynamics Configuration Utility (DCU)." + "~n":U + 
                                  "The following DCU objects are included in the import : " + "~n":U +
                                  cDcuObjectList + "~n":U +
                                  "This Import will be flagged as an Version Upgrade." + "~n":U + "~n":U +
                                  "The Progress Dynamics Configuration Utility (DCU) is a deployment utility used to automate the installation" +
                                  "of an upgrade to an application. Updates to Progress Dynamics are applied using the DCU." + "~n":U + "~n":U +
                                  "When working with Progress Dynamics through Roundtable, the DCU still must be run as part of the upgrade" + 
                                  "to the receipt workspace, i.e. the workspace used to receipt the latest version of Progress Dynamics into it." + 
                                  "The issue with Roundtable is that the updates installed by the DCU need to be applied to the other workspaces" + 
                                  "managed in Roundtable, and these are managed through Roundtable by doing standard Roundtable imports." + "~n":U + "~n":U +
                                  "The DCU manages schema deltas, loading data, and running fix programs at various stages of the upgrade cycle " + 
                                  "that typically must be done in a strict sequence that cannot be replicated by the standard Roundtable import process." + 
                                  "The workspace import process therefore needs to integrate with the DCU in cases where an upgrade is being propagated" + 
                                  "through the workspaces." + "~n":U + "~n":U +
                                  "The impact of cancelling a Version Upgrade is severe and could corrupt your Roundtable environment" + 
                                  "Ensure you understand the impact of cancelling a Version Upgrade" + "~n":U + "~n":U + 
                                  "Do you want to Continue with the Version Upgrade or Cancel and continue with a normal Import ?" + "~n":U + "~n":U + 
                                  "(Yes) - Version Upgrade / (No) - Normal Import".

      MESSAGE 
         cMesWinMessage
        VIEW-AS ALERT-BOX QUESTION 
        BUTTONS YES-NO
        TITLE cMesWinTitle
        UPDATE lAnswer.
      
      IF lAnswer THEN
        lUpgrade = YES. 
      ELSE 
        lUpgrade = NO.        
  END. /* IF lUpgrade */

  /* Make sure we have a valid handle to the session manager. If not, then the selective compile of the DCU procedures will 
     be done without asking the user.*/
  IF lUpgrade
  THEN DO:
      /* Step 1 */
    ASSIGN 
       cMesWinMessage = "For the Version Upgrade to continue, the DCU needs to update the Progress Dynamics Repository." + "~n":U + "~n":U +
                        "Please ensure ALL other connections has been shutdown before continueing" + "~n":U +
                        " - Client-Server" + "~n":U +
                        " - WebClient" + "~n":U +
                        " - Appserver agents & brokers" + "~n":U +
                        " - Webspeed Server agents & brokers".
  
    MESSAGE 
       cMesWinMessage
      VIEW-AS ALERT-BOX INFO 
      TITLE "Roundtable / DCU Extensions".
    
    ASSIGN
      cMesWinTitle            = "Roundtable Import / DCU Extensions (Dynamics Enhancement)":U
      cMesWinMessage          = "Have you shutdown all other running session and servers ?" + "~n":U + "~n":U +
                                "Should the Upgrade continue or do you wish to Cancel the Upgrade Process ?" + "~n":U + "~n":U +
                                "(Yes) - Continue with Version Upgrade / (No) - Cancel Version Upgrade".

    MESSAGE 
       cMesWinMessage
      VIEW-AS ALERT-BOX QUESTION 
      BUTTONS YES-NO
      TITLE cMesWinTitle
      UPDATE lAnswer.
    
    IF lAnswer THEN
      ASSIGN opErrorMessage = "":U.
    ELSE DO:
      ASSIGN opErrorMessage = "Cancelled":U.
      RETURN.
    END.
  END. /* IF lUpgrade */

  IF lUpgrade THEN 
  DO:
    /* Step 2 */
    ASSIGN lOverrideCreated = createFile(ipFilename).

    /* Step 3 */
    /* Continue with IMPORT without any Hooks or Replication */
    IF lOverrideCreated THEN 
    DO:
      /* ??? */
      /* The code to disable the replication triggers has been placed in the event procedure ICFCFM_UpgradeStart - which is triggered from the DCU when it starts  */
    END. /* lOverrideCreated */
  END. /* IF lUpgrade */
  
  /* Write the status of the upgrade process to the log file */
  ASSIGN cMessage = "[":U + STRING(TIME, "HH:MM:SS":U) + "] Running RTB / DCU Integration Upgrade : " + STRING(lUpgrade) + ".":U + "~n":U.
  /* Warn the user that the logging is not going ot show the normal processing of objects being 
     ASSIGNed or DELETEd from the workspace - as the integration hooks (rtb/prc/ryrtbevnt.p) has 
     is disabled when running in upgrade mode
  */
  IF lUpgrade THEN
  ASSIGN 
    cMessage = cMessage + "NOTE: Separate events for objects being imported into the workspace will not be logged.". 
  
  PUBLISH "logEvent" (INPUT "IMPORT-BEFORE PRE-EVENT", 
                      INPUT cMessage, 
                      INPUT "":U, 
                      INPUT Grtb-wspace-id, 
                      INPUT Grtb-userid, 
                      INPUT "LOG":U,
                      INPUT "dynrtb_import.log", 
                      INPUT "":U) .
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

&IF DEFINED(EXCLUDE-logEvent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE logEvent Procedure 
PROCEDURE logEvent :
/*------------------------------------------------------------------------------
  Purpose:     Process log messages being published from various event 
               handler procedures. 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER pcEvent        AS CHARACTER  NO-UNDO.
 DEFINE INPUT  PARAMETER pcEventMessage AS CHARACTER  NO-UNDO.
 DEFINE INPUT  PARAMETER pcMessageType  AS CHARACTER  NO-UNDO.
 DEFINE INPUT  PARAMETER pcWorkspace    AS CHARACTER  NO-UNDO.
 DEFINE INPUT  PARAMETER pcUserId       AS CHARACTER  NO-UNDO.
 DEFINE INPUT  PARAMETER pcLogOutPut    AS CHARACTER  NO-UNDO.
 DEFINE INPUT  PARAMETER pcLogFile      AS CHARACTER  NO-UNDO.
 DEFINE INPUT  PARAMETER pcOther        AS CHARACTER  NO-UNDO.
 
 DEFINE VARIABLE cButton                AS CHARACTER  NO-UNDO.
 
 /* Set default properties if they have not been passed in */
  IF pcMessageType = "":U THEN 
    ASSIGN 
      pcMessageType = "INFORMATION"
      . 
      
  /* If no log file is specified, then use the default dynrtb-log.txt file */
  IF pcLogFile = "":U THEN
    ASSIGN pcLogFile = "dynrtb_log.log".
      
  IF pcLogOutput = "":U THEN
    ASSIGN pcLogOutput = "MESSAGE":U.
  
  IF LOOKUP("STATUS":U, pcLogOutPut) > 0 THEN DO:
    IF VALID-HANDLE(Grtb-p-stat) THEN 
      RUN show_status_line IN Grtb-p-stat (INPUT pcEventMessage).       
  END. /*IF LOOKUP("STATUS":U, pcLogOutPut) > 0 ... */
  
  
  IF LOOKUP("LOG":U, pcLogOutPut) > 0 THEN DO: 
    IF LOOKUP("OVERWRITE":U, pcOther) > 0 THEN
      OUTPUT TO VALUE(pcLogFile). 
    ELSE      
      OUTPUT TO VALUE(pcLogFile) APPEND.       
      PUT UNFORMATTED pcEventMessage SKIP.     
    OUTPUT CLOSE. 
  END. /*IF LOOKUP("LOG":U, pcLogOutPut) > 0 ... */
  
  IF LOOKUP("MESSAGE":U, pcLogOutPut) > 0 THEN DO:
    MESSAGE 
      pcEventMessage
      VIEW-AS ALERT-BOX INFORMATION
      BUTTONS OK.      
  END. /*IF LOOKUP("MESSAGE":U, pcLogOutPut) > 0 ... */ 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-overrideCheck) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE overrideCheck Procedure 
PROCEDURE overrideCheck :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER cCheckType              AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER opReturnMessage          AS CHARACTER NO-UNDO.

  DEFINE VARIABLE cFullFileName AS CHARACTER  NO-UNDO.

  ASSIGN
    cFullFileName = buildFileSCM(grtb-wspace-id).

  CASE cCheckType:
    WHEN "VALIDATE":U THEN 
    DO:
        IF SEARCH(cFullFileName) <> ? THEN 
        DO:
          ASSIGN opReturnMessage = "FOUND":U.
        END.
        ELSE
          ASSIGN opReturnMessage = "":U.
      END.
    WHEN "CREATE":U THEN 
    DO:
        OUTPUT STREAM sOut TO VALUE(cFullFileName).
        PUT STREAM sOut UNFORMATTED
          TODAY "^" STRING(TIME) "^" TIME.
        OUTPUT STREAM sOut CLOSE.
      END.
    WHEN "DELETE":U THEN 
    DO:
        OS-DELETE VALUE(cFullFileName).
      END.
  END CASE.

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
DEFINE VARIABLE iCount      AS INTEGER    NO-UNDO.
DEFINE VARIABLE cTitle      AS CHARACTER  NO-UNDO.

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
    /* Clean up RTB API handle */
    IF VALID-HANDLE(hRtbApi)
    THEN DO: 
        DELETE PROCEDURE hRtbApi.
        ASSIGN hRtbAPi = ?.
    END.

  {ry/app/ryplipshut.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processPreEvent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processPreEvent Procedure 
PROCEDURE processPreEvent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  ipScmEvent                  AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ipScmContext                AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  ipScmOther                  AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER opScmErrorMessage           AS CHARACTER NO-UNDO.

  DEFINE VARIABLE cFileName   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFullName   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hLoopHandle AS HANDLE     NO-UNDO.  

  /* Get the handle of the configuration manager */
  IF NOT VALID-HANDLE(hConfMan) THEN
  DO:
     hLoopHandle = SESSION:FIRST-PROCEDURE.
     DO WHILE VALID-HANDLE(hLoopHandle):
       IF R-INDEX(hLoopHandle:FILE-NAME,"afxmlcfgp.p":U) > 0 OR 
          R-INDEX(hLoopHandle:FILE-NAME,"afxmlcfgp.r":U) > 0 THEN 
       DO:
         hConfMan = hLoopHandle.
         hLoopHandle = ?.
       END.
       ELSE
         hLoopHandle = hLoopHandle:NEXT-SIBLING.            
     END. /* VALID-HANDLE(hLoopHandle) */
  END.

  ASSIGN
    cFileName = buildFileSCM(Grtb-wspace-id)
    cFullName = "":U.

  CASE ipScmEvent:
    WHEN "IMPORT-BEFORE":U THEN RUN importBefore  (INPUT cFileName, OUTPUT opScmErrorMessage).
    WHEN "IMPORT":U        THEN RUN import        (INPUT cFileName, OUTPUT opScmErrorMessage).
  END CASE.

  cFullName = findFile(cFileName).

  IF opScmErrorMessage = "":U THEN
    ASSIGN opScmErrorMessage = cFullName.

  RETURN.

END PROCEDURE.

/*
CASE ipScmEvent:
  WHEN "ASSIGN-OBJECT":U              THEN RUN assign-object.
  WHEN "ASSIGN-OBJECT-BEFORE":U       THEN RUN assign-object-before.
  WHEN "BEFORE-CHANGE-WORKSPACE":U    THEN RUN before-change-workspace.
  WHEN "CHANGE-WORKSPACE":U           THEN RUN change-workspace.
  WHEN "CREATE-CV":U                  THEN RUN create-cv.
  WHEN "CREATE-CV-BEFORE":U           THEN RUN create-cv-before.
  WHEN "DEPLOY":U                     THEN RUN deploy.
  WHEN "DEPLOY-BEFORE":U              THEN RUN deploy-before.
  WHEN "DEPLOY-SITE-CREATE":U         THEN RUN deploy-site-create.
  WHEN "DEPLOY-SITE-CREATE-BEFORE":U  THEN RUN deploy-site-create-before.
  WHEN "IMPORT":U                     THEN RUN import.
  WHEN "IMPORT-BEFORE":U              THEN RUN import-before.
  WHEN "MOVE-TO-WEB":U                THEN RUN move-to-web.
  WHEN "MOVE-TO-WEB-BEFORE":U         THEN RUN move-to-web-before.
  WHEN "OBJECT-ADD":U                 THEN RUN object-add.
  WHEN "OBJECT-ADD-BEFORE":U          THEN RUN object-add-before.
  WHEN "OBJECT-CHECK-IN":U            THEN RUN object-check-in.
  WHEN "OBJECT-CHECK-IN-BEFORE":U     THEN RUN object-check-in-before.
  WHEN "OBJECT-CHECK-OUT":U           THEN RUN object-check-out.
  WHEN "OBJECT-CHECK-OUT-BEFORE":U    THEN RUN object-check-out-before.
  WHEN "OBJECT-COMPILE":U             THEN RUN object-compile.
  WHEN "OBJECT-COMPILE-BEFORE":U      THEN RUN object-compile-before.
  WHEN "OBJECT-DELETE":U              THEN RUN object-delete.
  WHEN "OBJECT-DELETE-BEFORE":U       THEN RUN object-delete-before.
  WHEN "PARTNER-LOAD":U               THEN RUN partner-load.
  WHEN "PARTNER-LOAD-BEFORE":U        THEN RUN partner-load-before.
  WHEN "PROPATH-CHANGE":U             THEN RUN propath-change.
  WHEN "PROPATH-CHANGE-BEFORE":U      THEN RUN propath-change-before.
  WHEN "RELEASE-CREATE":U             THEN RUN release-create.
  WHEN "RELEASE-CREATE-BEFORE":U      THEN RUN release-create-before.
  WHEN "SCHEMA-UPDATE":U              THEN RUN schema-update.
  WHEN "SCHEMA-UPDATE-BEFORE":U       THEN RUN schema-update-before.
  WHEN "TASK-CHANGE":U                THEN RUN task-change.
  WHEN "TASK-COMPLETE":U              THEN RUN task-complete.
  WHEN "TASK-COMPLETE-BEFORE":U       THEN RUN task-complete-before.
  WHEN "TASK-CREATE":U                THEN RUN task-create.
  WHEN "TASK-CREATE-BEFORE":U         THEN RUN task-create-before.
  WHEN "TASK-CREATE-DURING":U         THEN RUN task-create-during.
END CASE.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRTBSessionType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setRTBSessionType Procedure 
PROCEDURE setRTBSessionType :
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

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-buildFileSCM) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION buildFileSCM Procedure 
FUNCTION buildFileSCM RETURNS CHARACTER
  ( INPUT ipFilename AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cFileDir      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFileName     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFullFileName AS CHARACTER  NO-UNDO.

  ASSIGN
    cFileDir      = RIGHT-TRIM(REPLACE(SESSION:TEMP-DIRECTORY,"~\":U,"~/":U),"~/":U)
    cFilename     = TRIM(ipFilename + ".log","~/":U)
    cFullFileName = cFileDir + "~/":U + cFilename
    .

  RETURN cFullFileName.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createFile Procedure 
FUNCTION createFile RETURNS LOGICAL
  ( INPUT ipFilename AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cFileExist AS CHARACTER NO-UNDO.

  OUTPUT STREAM sOut TO VALUE(ipFilename).
  PUT STREAM sOut UNFORMATTED
    TODAY "^" STRING(TIME) "^" TIME
    .
  OUTPUT STREAM sOut CLOSE.

  cFileExist = findFile(ipFilename).

  IF cFileExist <> "":U
  THEN RETURN TRUE.
  ELSE RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION deleteFile Procedure 
FUNCTION deleteFile RETURNS LOGICAL
  ( INPUT ipFilename AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cFileExist AS CHARACTER NO-UNDO.

  OS-DELETE VALUE(ipFilename).

  cFileExist = findFile(ipFilename).

  IF cFileExist <> "":U
  THEN RETURN FALSE.
  ELSE RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION findFile Procedure 
FUNCTION findFile RETURNS CHARACTER
  ( INPUT ipFilename AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  FILE-INFO:FILENAME = SEARCH(ipFilename).

  IF FILE-INFO:FULL-PATHNAME = ?
  THEN
    RETURN "":U.
  ELSE DO:
    IF  FILE-INFO:FILE-MOD-DATE = TODAY
    OR (FILE-INFO:FILE-MOD-DATE = TODAY - 1
    AND FILE-INFO:FILE-MOD-TIME > TIME)
    THEN
      RETURN FILE-INFO:FULL-PATHNAME.
    ELSE
      RETURN "":U.
  END.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

