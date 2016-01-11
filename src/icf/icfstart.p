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

{afglobals.i}

DEFINE VARIABLE hConfMan AS HANDLE     NO-UNDO.
DEFINE VARIABLE lWaitFor AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lICF     AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cCFMProc AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cICFParam    AS CHARACTER  NO-UNDO INITIAL "":U.
DEFINE VARIABLE lQuitOnEnd   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lShutOnEnd   AS LOGICAL    NO-UNDO.

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
         HEIGHT             = 22.43
         WIDTH              = 59.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
SESSION:APPL-ALERT-BOXES = TRUE.

SESSION:DEBUG-ALERT = YES.

cCFMProc = SEARCH("af/app/afxmlcfgp.r":U).

IF cCFMProc = ? THEN
  cCFMProc = SEARCH("af/app/afxmlcfgp.p":U).

IF cCFMProc <> ? THEN
  RUN VALUE(cCFMProc) PERSISTENT SET hConfMan.

IF VALID-HANDLE(hConfMan) THEN
DO:
  RETURN-VALUE = "":U.

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
     anther procedure. */
  lQuitOnEnd = DYNAMIC-FUNCTION("getSessionParam" IN THIS-PROCEDURE,
                                 "quit_on_end":U) <> "NO":U NO-ERROR.
  ERROR-STATUS:ERROR = NO.

  lShutOnEnd = DYNAMIC-FUNCTION("getSessionParam" IN THIS-PROCEDURE,
                                 "shut_on_end":U) <> "NO":U NO-ERROR.
  ERROR-STATUS:ERROR = NO.

  IF cICFParam = ? THEN
    cICFParam = "":U.

  /* Initialize the ICF session */
  RUN initializeSession IN THIS-PROCEDURE (cICFParam).
  IF RETURN-VALUE <> "" THEN
  DO:
    MESSAGE 
      "Unable to start ICF environment. The Configuration File Manager returned the following errors:":U
      SKIP
      RETURN-VALUE
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  END.

END.
ELSE
  MESSAGE 
  "Unable to start Configuration File Manager.":U
  SKIP
  RETURN-VALUE
  VIEW-AS ALERT-BOX ERROR BUTTONS OK.


lWaitFor = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                            "wait_for_required":U) = "YES":U NO-ERROR.

IF lWaitFor = YES THEN
DO ON ERROR UNDO, LEAVE:
  WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

lICF = DYNAMIC-FUNCTION("isICFRunning":U IN THIS-PROCEDURE) = YES NO-ERROR.
ERROR-STATUS:ERROR = NO.

/* Publish the shutdown event. This allows other code, such as RoundTable
 * to trap this event and set a special -icfparam parameter if they want to. */
PUBLISH "ICFSTART_BeforeShutdown".

/* If Dynamics is running, then we need to shut down all the
 * manager procedures gracefully.                            */
IF lICF
AND lShutOnEnd
THEN
    RUN sessionShutdown IN THIS-PROCEDURE NO-ERROR.

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
  RETURN-VALUE = "":U.

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
     RETURN-VALUE <> "":U OR
     dCurrentUserObj <= 0 THEN
    RETURN "LOG IN FAILED":U.

  /* Must have logged in ok, set appropriate values in Client Session Manager,
   which will also set values in Context database via Server Session Manager
  */
  IF tCurrentProcessDate = ? THEN ASSIGN tCurrentProcessDate = TODAY.
  
  cDateFormat = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                     INPUT "dateFormat":U,
                                                     INPUT NO).
  
  ASSIGN
    cPropertyList = "CurrentUserObj,CurrentUserLogin,CurrentUserName,CurrentUserEmail,CurrentOrganisationObj,CurrentOrganisationCode,CurrentOrganisationName,CurrentOrganisationShort,CurrentLanguageObj,CurrentLanguageName,CurrentProcessDate,CurrentLoginValues,DateFormat,LoginWindow":U
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
                 cLoginProc
    .
  
  DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager,
                                       INPUT cPropertyList,
                                       INPUT cValueList,
                                       INPUT NO).
  
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

