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
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: icfstart.p

  Description:  ICF Startup Procedure

  Purpose:      Startup procedure for the GUI version of ICF

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   08/28/2001  Author:     Bruce Gruenbaum

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       icfstart.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* Astra object identifying preprocessor */
&glob   AstraProcedure    yes
{adecomm/oeideservice.i}
{src/adm2/globals.i}
{af/sup2/afsetuppath.i}

DEFINE VARIABLE hConfMan     AS HANDLE     NO-UNDO.
DEFINE VARIABLE lWaitFor     AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lICF         AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cCFMProc     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hWaitForProc AS HANDLE     NO-UNDO.
DEFINE VARIABLE hLoopHandle  AS HANDLE     NO-UNDO.

DEFINE VARIABLE cICFParam    AS CHARACTER  NO-UNDO INITIAL "":U.
DEFINE VARIABLE lQuitOnEnd   AS LOGICAL    INITIAL YES NO-UNDO.
DEFINE VARIABLE lShutOnEnd   AS LOGICAL    INITIAL YES NO-UNDO.
DEFINE VARIABLE cQuitOnEndB4 AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cQuitOnEnd   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cShutOnEndB4 AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cShutOnEnd   AS CHARACTER  NO-UNDO.
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
   Compile into: dynamics
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
         HEIGHT             = 22.43
         WIDTH              = 59.8.
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
  /* Users that set this at this point may want control to return to 
     another procedure. */
  cQuitOnEndB4 = DYNAMIC-FUNCTION("getSessionParam" IN THIS-PROCEDURE,
                                  "quit_on_end":U) NO-ERROR.
  ERROR-STATUS:ERROR = NO.

  cShutOnEndB4 = DYNAMIC-FUNCTION("getSessionParam" IN THIS-PROCEDURE,
                                  "shut_on_end":U) NO-ERROR.
  ERROR-STATUS:ERROR = NO.

  IF cICFParam = ? THEN
    cICFParam = "":U.

  /* Initialize the Dynamics session */
  RUN initializeSession IN THIS-PROCEDURE (cICFParam).
  IF RETURN-VALUE <> "" AND
     RETURN-VALUE <> "QUIT":U THEN
  DO:
    if OEIDEIsRunning then
         ShowMessageInIDE("Unable to start the Progress Dynamics environment. The Configuration File Manager returned the following errors:":U
                           + RETURN-VALUE,
                          "Error",?,"OK",YES).
    else                        
    MESSAGE 
      "Unable to start the Progress Dynamics environment. The Configuration File Manager returned the following errors:":U
      SKIP
      RETURN-VALUE
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    lError = YES.
  END.

  cQuitOnEnd  = DYNAMIC-FUNCTION("getSessionParam" IN THIS-PROCEDURE,
                                 "quit_on_end":U) NO-ERROR.
  ERROR-STATUS:ERROR = NO.
  
  cShutOnEnd  = DYNAMIC-FUNCTION("getSessionParam" IN THIS-PROCEDURE,
                                 "shut_on_end":U) NO-ERROR.
  ERROR-STATUS:ERROR = NO.

  IF cQuitOnEnd <> ? THEN
    lQuitOnEnd = (IF cQuitOnEnd   = "NO":U THEN NO ELSE YES).
  ELSE IF cQuitOnEndB4 <> ? THEN
    lQuitOnEnd = (IF cQuitOnEndB4 = "NO":U THEN NO ELSE YES).
  ELSE
    lQuitOnEnd = YES.
    
  IF cShutOnEnd <> ? THEN
    lShutOnEnd = (IF cShutOnEnd   = "NO":U THEN NO ELSE YES).
  ELSE IF cShutOnEndB4 <> ? THEN
    lShutOnEnd = (IF cShutOnEndB4 = "NO":U THEN NO ELSE YES).
  ELSE
    lShutOnEnd = YES.

  IF lError THEN
  DO:
    IF lQuitOnEnd = NO THEN
      RETURN.
    ELSE.
      QUIT.
  END.

  lWaitFor = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                              "wait_for_required":U) = "YES":U NO-ERROR.

  ERROR-STATUS:ERROR = NO.
  IF lWaitFor = YES THEN
  DO:
    hWaitForProc = WIDGET-HANDLE(DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                                  "wait_for_proc":U)) NO-ERROR.
  
    ERROR-STATUS:ERROR = NO.
  
    IF lWaitFor AND
       VALID-HANDLE(hWaitForProc) THEN
    DO ON ERROR UNDO, LEAVE:
      WAIT-FOR CLOSE OF hWaitForProc.
    END.
  END.
  
  lICF = DYNAMIC-FUNCTION("isICFRunning":U IN THIS-PROCEDURE) = YES NO-ERROR.
  ERROR-STATUS:ERROR = NO.
  
  /* Publish the shutdown event. This allows other code, such as RoundTable
   * to trap this event and set a special -icfparam parameter if they want to. */
  PUBLISH "ICFSTART_BeforeShutdown".

END.
ELSE
  if OEIDEIsRunning then
     ShowMessageInIDE("Unable to start Configuration File Manager.~n" + 
                       RETURN-VALUE,
                       "Error",?,"OK",YES).
  else                        
  MESSAGE 
  "Unable to start Configuration File Manager.":U
  SKIP
  RETURN-VALUE
  VIEW-AS ALERT-BOX ERROR BUTTONS OK.

/* If Dynamics is running, then we need to shut down all the
 * manager procedures gracefully.                            */
IF lICF
AND lShutOnEnd
THEN DO:
  RUN sessionShutdown IN THIS-PROCEDURE NO-ERROR.
  IF VALID-HANDLE(hConfMan)
  AND lStartConfMan = YES
  THEN
    APPLY "CLOSE":U TO hConfMan.
END.

/* More support for RoundTable */
IF lQuitOnEnd = NO THEN
  RETURN.
ELSE.
  QUIT.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-ICFCFM_InitializedServices) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ICFCFM_InitializedServices Procedure 
PROCEDURE ICFCFM_InitializedServices :
/*------------------------------------------------------------------------------
  Purpose:     Traps the InitializedServices event and creates all the 
               appropriate aliases for the databases.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE htProperty      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE htService       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE htManager       AS HANDLE     NO-UNDO.

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
  DO:
    RUN af/sup2/afsessnidp.p(OUTPUT gscSessionId).  /* Use seq. for session id */
  END.
  ELSE
      ASSIGN gscSessionId = gshAstraAppserver:CLIENT-CONNECTION-ID.

  /* Now we need to retrieve from the database the appropriate session
     information for this session. */
  RUN obtainSessionTableHandles IN THIS-PROCEDURE /* actually in config file maneger */
    (OUTPUT htProperty,
     OUTPUT htService,
     OUTPUT htManager).

  RUN af/app/afsesstyperetr.p ON gshAstraAppServer
    (INPUT-OUTPUT TABLE-HANDLE htProperty,
     INPUT-OUTPUT TABLE-HANDLE htService,
     INPUT-OUTPUT TABLE-HANDLE htManager) NO-ERROR.
  IF ERROR-STATUS:ERROR THEN
    RETURN ERROR RETURN-VALUE.

  RUN initializeWithChanges IN THIS-PROCEDURE NO-ERROR.
  IF ERROR-STATUS:ERROR THEN
    RETURN ERROR RETURN-VALUE.

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
  DEFINE VARIABLE cLoginProc    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSearch       AS CHARACTER  NO-UNDO.

  /* run login window to authenticate user */
  DEFINE VARIABLE lCacheTranslations                  AS LOGICAL      NO-UNDO INITIAL YES.
  DEFINE VARIABLE rRowid                              AS ROWID        NO-UNDO.
  DEFINE VARIABLE dCurrentUserObj                     AS DECIMAL      NO-UNDO.
  DEFINE VARIABLE dCurrentOrganisationObj             AS DECIMAL      NO-UNDO.
  DEFINE VARIABLE dCurrentLanguageObj                 AS DECIMAL      NO-UNDO.
  DEFINE VARIABLE tCurrentProcessDate                 AS DATE         NO-UNDO.
  DEFINE VARIABLE cCurrentUserLogin                   AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cCurrentUserName                    AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cCurrentUserEmail                   AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cCurrentOrganisationCode            AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cCurrentOrganisationName            AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cCurrentOrganisationShort           AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cCurrentLanguageName                AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cCurrentLoginValues                 AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cPropertyList                       AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cValueList                          AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cDateFormat                         AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cCacheTranslations                  AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cProfileData                        AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cToolbarsToCache                    AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cObjectsToCacheMenusFor             AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE lForceUserProp                      AS LOGICAL    NO-UNDO.
  define variable cCachedTranslations                 as character no-undo.

  cLoginProc = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                "login_procedure":U).

  IF cLoginProc = ? THEN
    cLoginProc = "af/cod2/aftemlognw.w":U.

  cSearch = DYNAMIC-FUNCTION("getCodePath":U IN THIS-PROCEDURE,
                             cLoginProc) NO-ERROR.

  IF ERROR-STATUS:ERROR OR 
     cSearch = ? THEN
    RETURN "UNABLE TO RUN LOGIN PROCEDURE ":U + cLoginProc.

  cLoginProc = cSearch.

  ERROR-STATUS:ERROR = NO.

  RUN VALUE(cLoginProc) (INPUT  "One":U,                       /* 1st login */
                        OUTPUT dCurrentUserObj,
                        OUTPUT cCurrentUserLogin,
                        OUTPUT cCurrentUserName,
                        OUTPUT cCurrentUserEmail,
                        OUTPUT dCurrentOrganisationObj,
                        OUTPUT cCurrentOrganisationCode,
                        OUTPUT cCurrentOrganisationName,
                        OUTPUT cCurrentOrganisationShort,
                        OUTPUT tCurrentProcessDate,
                        OUTPUT dCurrentLanguageObj,
                        OUTPUT cCurrentLanguageName,
                        OUTPUT cCurrentLoginValues) NO-ERROR.
  /* if failed to login then abort */
  IF ERROR-STATUS:ERROR OR 
     RETURN-VALUE <> "":U THEN
    RETURN "LOG IN FAILED":U.

  IF dCurrentUserObj = 0 THEN
    RETURN "QUIT":U.

  /* Must have logged in ok, set appropriate values in Client Session Manager,
     which will also set values in Context database via Server Session Manager.
     
     The values we get below need to be set on the server, and are hard-coded
     in the Session Manager's initializePropertyList() procedure, but only on
     a client session. We need to fetch them and pass them across to the server.
     
     If this seems odd, it is. */
  IF tCurrentProcessDate = ? THEN ASSIGN tCurrentProcessDate = TODAY.
  
  cPropertyList = 'DateFormat,CachedTranslationsOnly':u.
  IF SESSION = gshAstraAppserver THEN /* client-server */
      cValueList = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                         INPUT cPropertyList,
                                                         INPUT NO).
  ELSE /* If we're running Appserver, these properties have already been set on the Appserver by the call batching mechanism, we only need to set client side */
      cValueList = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                         INPUT cPropertyList,
                                                         INPUT YES).
    /* Parse out the values */
    cDateFormat = entry(lookup('DateFormat':u, cPropertyList), cValueList, chr(3)) no-error.
    cCachedTranslations = entry(lookup('CachedTranslationsOnly':u, cPropertyList), cValueList, chr(3)) no-error.
    
  ASSIGN
    cPropertyList = "CurrentUserObj,CurrentUserLogin,CurrentUserName,CurrentUserEmail,CurrentOrganisationObj,CurrentOrganisationCode,CurrentOrganisationName,CurrentOrganisationShort,CurrentLanguageObj,CurrentLanguageName,CurrentProcessDate,CurrentLoginValues,DateFormat,LoginWindow":U
                  + ',CachedTranslationsOnly':u
    cValueList = STRING(dCurrentUserObj) + CHR(3) +
                 cCurrentUserLogin + CHR(3) +
                 cCurrentUserName + CHR(3) +
                 cCurrentUserEmail + CHR(3) +
                 STRING(dCurrentOrganisationObj) + CHR(3) +
                 cCurrentOrganisationCode + CHR(3) +
                 cCurrentOrganisationName + CHR(3) +
                 cCurrentOrganisationShort + CHR(3) +
                 STRING(dCurrentLanguageObj) + CHR(3) +
                 cCurrentLanguageName + CHR(3) +
                 STRING(tCurrentProcessDate,cDateFormat) + CHR(3) +
                 cCurrentLoginValues + CHR(3) +
                 cDateFormat + CHR(3) +
                 cLoginProc + chr(3) +
                 cCachedTranslations.

  lForceUserProp = LOGICAL(DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                            "forceUserPropertiesToServer":U)).
  IF lForceUserProp = ? THEN
    lForceUserProp = NO.

  IF SESSION = gshAstraAppserver THEN /* client-server */
      DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager,
                                           INPUT cPropertyList,
                                           INPUT cValueList,
                                           INPUT NO).
  ELSE /* If we're running Appserver, these properties have already been set on the Appserver by the call batching mechanism, we only need to set client side
          unless the user is forcing us to set it on the AppServer which they may want to do to ensure that a changed password will still result in 
          a successful login. */
      DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager,
                                           INPUT cPropertyList,
                                           INPUT cValueList,
                                           INPUT (NOT lForceUserProp)). 

  /* for c/s sessions, cache the profile data upfront as the api's assume to only
     use the cache in this mode. For runtime sessions, this will be done via the
     logincacheafter api in the session manager.
  */
  IF SESSION = gshAstraAppserver THEN /* client-server */
    RUN buildclientcache IN gshProfileManager (INPUT "":U).

  cCacheTranslations = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                   INPUT "cachedTranslationsOnly":U,
                                   INPUT NO).
  lCacheTranslations = cCacheTranslations <> "NO":U NO-ERROR.  

  /* if caching translations - do so for logged into language */
  IF lCacheTranslations THEN
    RUN buildClientCache IN gshTranslationManager (INPUT dCurrentLanguageObj).
  
  /* get window user profile settings and action them */
  ASSIGN rRowid = ?.
  RUN getProfileData IN gshProfileManager (INPUT "Window":U,
                                           INPUT "DebugAlert":U,
                                           INPUT "DebugAlert":U,
                                           INPUT NO,
                                           INPUT-OUTPUT rRowid,
                                           OUTPUT cProfileData).
  SESSION:DEBUG-ALERT = cProfileData <> "NO":U.                                         

  ASSIGN rRowid = ?.
  RUN getProfileData IN gshProfileManager (INPUT "Window":U,
                                           INPUT "Tooltips":U,
                                           INPUT "Tooltips":U,
                                           INPUT NO,
                                           INPUT-OUTPUT rRowid,
                                           OUTPUT cProfileData).
  SESSION:TOOLTIPS = cProfileData <> "NO":U.                                         

  /* If the user wants to precache toolbars, do so now.  We can only do this after a successfull login. */
  IF VALID-HANDLE(gshRepositoryManager) 
  THEN DO:
      ASSIGN cToolbarsToCache        = DYNAMIC-FUNCTION("getSessionParam" IN TARGET-PROCEDURE, "StartupCacheToolbars":U) NO-ERROR.
      ASSIGN cObjectsToCacheMenusFor = DYNAMIC-FUNCTION("getSessionParam" IN TARGET-PROCEDURE, "StartupCacheMenusForObjects":U) NO-ERROR.
      IF cToolbarsToCache = ? THEN ASSIGN cToolbarsToCache = "":U.
      IF cObjectsToCacheMenusFor = ? THEN ASSIGN cObjectsToCacheMenusFor = "":U.

      IF cToolbarsToCache <> "":U
      OR cObjectsToCacheMenusFor <> "":U THEN
          RUN createToolbarCache IN gshRepositoryManager (INPUT cToolbarsToCache,
                                                          INPUT cObjectsToCacheMenusFor,
                                                          INPUT NO). /* Cache for single object? */
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ICFCFM_ManagersStarted) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ICFCFM_ManagersStarted Procedure 
PROCEDURE ICFCFM_ManagersStarted :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE glICFRunning AS LOGICAL    NO-UNDO.
    glICFRunning = DYNAMIC-FUNCTION("isICFRunning":U IN THIS-PROCEDURE).
    IF glICFRunning = ? OR 
       glICFRunning = NO THEN
      RETURN "ICFSTARTERR: Unable to start Progress Dynamics. Managers not started.".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ICFCFM_SessionShutdown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ICFCFM_SessionShutdown Procedure 
PROCEDURE ICFCFM_SessionShutdown :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

