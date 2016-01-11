&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE
/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* Update Version Notes Wizard
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
/*---------------------------------------------------------------------------------
  File: dcuphase1.p

  Description:  DCU Phase 1 Batch Mode Procedure

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   12/08/2004  Author:     Bruce Gruenbaum

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       dcuphase1.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

{install/inc/indcuglob.i}

DEFINE VARIABLE hConfMan     AS HANDLE     NO-UNDO.
DEFINE VARIABLE hUIUtil      AS HANDLE     NO-UNDO.
DEFINE VARIABLE lICF         AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cCFMProc     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSessType    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hStatusWin   AS HANDLE     NO-UNDO.

DEFINE VARIABLE lStartConfMan AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cICFParam     AS CHARACTER  NO-UNDO INITIAL "":U.
DEFINE VARIABLE hUpgradeAPI   AS HANDLE     NO-UNDO.

DEFINE VARIABLE cScriptFile   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cSiteDataFile AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFullScriptFile   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFullSiteDataFile AS CHARACTER  NO-UNDO.

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
         HEIGHT             = 29.43
         WIDTH              = 79.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* First get the config file manager and the connection manager running */
RUN initializeEnvironment NO-ERROR.
IF ERROR-STATUS:ERROR THEN
DO:
  RUN createErrorFile (RETURN-VALUE).
  RETURN.
END.


/* Now start the upgrade API */
RUN startProcedure IN TARGET-PROCEDURE
  ("ONCE|install/prc/inupgrdapip.p":U, 
   OUTPUT hUpgradeAPI)
  NO-ERROR.
IF ERROR-STATUS:ERROR THEN
DO:
  RUN createErrorFile (RETURN-VALUE).
  RETURN.
END.

/* Get the script file parameter */
cScriptFile = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                               "DCUSCRIPTFILE":U).

/* If the script file has not been specified, barf */
IF cScriptFile = ? THEN
DO:
  RUN createErrorFile ("DCU Script File not specified (-icfparam DCUSCRIPTFILE=<script file name>)").
  RETURN.
END.

/* If the script file is invalid (ie, does not exist), barf */
cFullScriptFile = SEARCH(cScriptFile).
IF cFullScriptFile = ? THEN
DO:
  RUN createErrorFile ("DCU Script File not found: " + cScriptFile).
  RETURN.
END.

/* Get the site data file. */
cSiteDataFile = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                 "DCUSITEDATAFILE":U).

/* It's okay not to specify the site data file so only do this if the site data file *has* been
   specified */
IF cSiteDataFile <> ? THEN
DO:
  /* If we can't find the site data file, barf. */
  cFullSiteDataFile = SEARCH(cSiteDataFile).
  IF cFullSiteDataFile = ? THEN
  DO:
    RUN createErrorFile ("DCU Site Data File not found: " + cSiteDataFile).
    RETURN.
  END.
END.

/* Load the XML file for the temp-table data */
RUN readXMLScript IN hUpgradeAPI
  (cFullScriptFile)
  NO-ERROR.
IF ERROR-STATUS:ERROR THEN
DO:
  RUN createErrorFile ("Unable to load script data from script file. " + RETURN-VALUE).
  RETURN.
END.

/* Now load the site data if necessary */
IF cSiteDataFile <> ? THEN
DO:
  RUN readSiteDataXML IN hUpgradeAPI
    (cFullSiteDataFile)
    NO-ERROR.
  IF ERROR-STATUS:ERROR THEN
  DO:
    RUN createErrorFile ("Unable to load site data from site data file. " + RETURN-VALUE).
    RETURN.
  END.
END.

/* Now apply the upgrade */
RUN applyUpgrade IN hUpgradeAPI
  NO-ERROR.
IF ERROR-STATUS:ERROR THEN
DO:
  RUN createErrorFile("Upgrade failed. " + RETURN-VALUE).
  RETURN.
END.

RETURN.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-createErrorFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createErrorFile Procedure 
PROCEDURE createErrorFile :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcErrorString AS CHARACTER  NO-UNDO.

  OUTPUT TO dcuphase1err.txt.
  EXPORT pcErrorString.
  OUTPUT CLOSE. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeEnvironment) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeEnvironment Procedure 
PROCEDURE initializeEnvironment :
/*------------------------------------------------------------------------------
  Purpose:     This procedure does the work that ICF start does to get
               the environment set up.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hLoopHandle AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iCount      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lConfFileSet AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lSessTypeSet AS LOGICAL    NO-UNDO.

  hLoopHandle = SESSION:FIRST-PROCEDURE.
  DO WHILE VALID-HANDLE(hLoopHandle):
    IF R-INDEX(hLoopHandle:FILE-NAME,"afxmlcfgp.p":U) > 0
    OR R-INDEX(hLoopHandle:FILE-NAME,"afxmlcfgp.r":U) > 0 THEN 
    DO:
      hConfMan = hLoopHandle.
      hLoopHandle = ?.
    END.
    ELSE
      hLoopHandle = hLoopHandle:NEXT-SIBLING.
  END. /* VALID-HANDLE(hLoopHandle) */

  cCFMProc = SEARCH("af/app/afxmlcfgp.r":U).
  IF cCFMProc = ? THEN
    cCFMProc = SEARCH("af/app/afxmlcfgp.p":U).

  IF NOT VALID-HANDLE(hConfMan) 
  AND cCFMProc <> ? THEN
  DO:
    RUN VALUE(cCFMProc) PERSISTENT SET hConfMan.
    ASSIGN
      lStartConfMan = YES.
  END.
  ELSE
    ASSIGN
      lStartConfMan = NO.

  IF VALID-HANDLE(hConfMan) THEN
  DO:
    /* Subscribe to all the relevant events in the configuration file manager */
    RUN subscribeAll IN THIS-PROCEDURE (hConfMan, THIS-PROCEDURE).

    lConfFileSet = NO.

    REPEAT iCount = 1 TO NUM-ENTRIES(SESSION:ICFPARAM):
      cSessType = ENTRY(iCount, SESSION:ICFPARAM).
      IF NUM-ENTRIES(cSessType,"=":U) > 1 AND
        (ENTRY(1,cSessType,"=":U) = "DCUSETUPTYPE":U OR 
         ENTRY(1,cSessType,"=":U) = "ICFSESSTYPE":U) THEN
      DO:
        cSessType = ENTRY(2,cSessType,"=":U).
        cICFParam = cICFParam + (IF cICFParam <> "":U THEN ",":U ELSE "":U)
                  + "ICFSESSTYPE=":U + cSessType .
        lSessTypeSet = YES.
        NEXT.
      END.
      IF NUM-ENTRIES(cSessType,"=":U) > 1 AND
        (ENTRY(1,cSessType,"=":U) = "ICFCONFIG":U OR
         ENTRY(1,cSessType,"=":U) = "ICFSETUP":U OR
         ENTRY(1,cSessType,"=":U) = "DCUSETUP":U) THEN
      DO:
        cSessType = ENTRY(2,cSessType,"=":U).
        cICFParam = cICFParam + (IF cICFParam <> "":U THEN ",":U ELSE "":U)
                  + "ICFCONFIG=":U + cSessType .
        lConfFileSet = YES.
        NEXT.
      END.
      cICFParam = cICFParam + (IF cICFParam <> "":U THEN ",":U ELSE "":U)
                + ENTRY(iCount, SESSION:ICFPARAM) .
    END.

    IF NOT lConfFileSet THEN
      cICFParam = cICFParam + (IF cICFParam <> "":U THEN ",":U ELSE "":U)
                + "ICFCONFIG=dcuphase1.xml":U.

    IF NOT lSessTypeSet THEN
      cICFParam = cICFParam + (IF cICFParam <> "":U THEN ",":U ELSE "":U)
                + "ICFSESSTYPE=dcuphase1":U.

    PUBLISH "DCU_SetStatus":U ("Initializing Configuration File Manager...").

    DYNAMIC-FUNCTION ("setSessionParam":U IN THIS-PROCEDURE, "ICFPARAM":U, cICFParam ).

    /* Publish the startup event. This allows other code, such as RoundTable
       to trap this event and set a special -icfparam parameter if they want to. */
    PUBLISH "DCU_BeforeInitialize".

    /* Now we need to see if anyone has set anything in the properties */
    cICFParam = DYNAMIC-FUNCTION("getSessionParam" IN THIS-PROCEDURE, "ICFPARAM":U) NO-ERROR.
    ERROR-STATUS:ERROR = NO.

    IF cICFParam = ? THEN 
      cICFParam = "":U.

    /* Initialize the ICF session */
    RUN initializeSession IN THIS-PROCEDURE (cICFParam).
    IF RETURN-VALUE <> "" AND
       RETURN-VALUE <> ? THEN
    DO:
      RETURN ERROR 
        "Unable to start the Progress Dynamics environment. The Configuration File Manager returned the following errors:":U +
        RETURN-VALUE.
    END.

  END.
  ELSE
  DO:
    RETURN ERROR  
      "Unable to start Configuration File Manager. ":U + (IF RETURN-VALUE <> ? THEN RETURN-VALUE ELSE "":U).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

