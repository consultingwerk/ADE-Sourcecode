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
  File: dcuphase2.p

  Description:  Batch DCU updater for loading ADOs

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   12/09/2004  Author:     Bruce S Gruenbaum

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       dcuphase2.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}
{af/sup2/afsetuppath.i}

DEFINE VARIABLE hConfMan     AS HANDLE     NO-UNDO.
DEFINE VARIABLE lWaitFor     AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lICF         AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cCFMProc     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hWaitForProc AS HANDLE     NO-UNDO.
DEFINE VARIABLE hLoopHandle  AS HANDLE     NO-UNDO.

DEFINE VARIABLE cICFParam    AS CHARACTER  NO-UNDO INITIAL "":U.
DEFINE VARIABLE lError       AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lStartConfMan AS LOGICAL    NO-UNDO.

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
         HEIGHT             = 30.29
         WIDTH              = 52.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

SESSION:APPL-ALERT-BOXES = TRUE.

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

  /* Publish the startup event. This allows other code, such as RoundTable
     to trap this event and set a special -icfparam parameter if they want to. */
  PUBLISH "ICFSTART_BeforeInitialize".
     
  /* Now we need to see if anyone has set anything in the properties */
  cICFParam = DYNAMIC-FUNCTION("getSessionParam" IN THIS-PROCEDURE,
                               "ICFPARAM":U) NO-ERROR.
  ERROR-STATUS:ERROR = NO.
    
  IF cICFParam = ? THEN
    cICFParam = "":U.

  /* Initialize the Dynamics session */
  RUN initializeSession IN THIS-PROCEDURE (cICFParam).
  IF RETURN-VALUE <> "" AND
     RETURN-VALUE <> "QUIT":U THEN
  DO:
    RUN createErrorFile ("Unable to start the Progress Dynamics environment. The Configuration File Manager returned the following errors: ":U
                         + (if return-value eq ? then 'Unknown error' else return-value)).
    lError = YES.
  END.

  IF lError THEN
    RETURN.

END.
ELSE
  RUN createErrorFile ("Unable to start Configuration File Manager.":U).

/* If Dynamics is running, then we need to shut down all the
 * manager procedures gracefully.                            */
RUN sessionShutdown IN THIS-PROCEDURE NO-ERROR.
IF VALID-HANDLE(hConfMan)
AND lStartConfMan = YES
THEN
  APPLY "CLOSE":U TO hConfMan.

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

  OUTPUT TO dcuphase2err.txt.
  EXPORT pcErrorString.
  OUTPUT CLOSE. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ICFCFM_InitializedServices) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ICFCFM_InitializedServices Procedure 
PROCEDURE ICFCFM_InitializedServices :
/*------------------------------------------------------------------------------
  Purpose:     Traps the InitializedServices event and creates all the 
               appropriate aliases for the databases.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF CONNECTED("ICFDB":U) THEN
  DO:
    CREATE ALIAS AFDB           FOR DATABASE VALUE("ICFDB":U).
    CREATE ALIAS ASDB           FOR DATABASE VALUE("ICFDB":U).
    CREATE ALIAS RYDB           FOR DATABASE VALUE("ICFDB":U).
    CREATE ALIAS db_metaschema  FOR DATABASE VALUE("ICFDB":U).
    CREATE ALIAS db_index       FOR DATABASE VALUE("ICFDB":U).
  END.

  IF NOT VALID-HANDLE(gshAstraAppServer) THEN
    gshAstraAppServer = SESSION:HANDLE.


  IF gshAstraAppserver = SESSION:HANDLE THEN
    RUN af/sup2/afsessnidp.p(OUTPUT gscSessionId).  /* Use seq. for session id */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ICFCFM_Login) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ICFCFM_Login Procedure 
PROCEDURE ICFCFM_Login :
/*------------------------------------------------------------------------------
  Purpose:     Traps the login event and logs the user into the ICF framework.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* run login window to authenticate user */
  DEFINE VARIABLE cPropertyList                       AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cValueList                          AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cDateFormat                         AS CHARACTER    NO-UNDO.

  /* Must have logged in ok, set appropriate values in Client Session Manager,
   which will also set values in Context database via Server Session Manager
  */
  
  cDateFormat = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                     INPUT "dateFormat":U,
                                                     INPUT NO).
  ASSIGN
    cPropertyList = "CurrentUserObj,CurrentUserLogin,CurrentUserName,CurrentUserEmail,CurrentOrganisationObj,CurrentOrganisationCode,CurrentOrganisationName,CurrentOrganisationShort,CurrentLanguageObj,CurrentLanguageName,CurrentProcessDate,CurrentLoginValues,DateFormat,LoginWindow":U
    cValueList = "0" + CHR(3) +
                 "admin" + CHR(3) +
                 "Batch DCU" + CHR(3) +
                 "" + CHR(3) +
                 "0" + CHR(3) +
                 "" + CHR(3) +
                 "" + CHR(3) +
                 "" + CHR(3) +
                 "0" + CHR(3) +
                 "" + CHR(3) +
                 "" + CHR(3) +
                 "" + CHR(3) +
                 cDateFormat + CHR(3) +
                 "batchDCU".

  DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager,
                                       INPUT cPropertyList,
                                       INPUT cValueList,
                                       INPUT NO).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

