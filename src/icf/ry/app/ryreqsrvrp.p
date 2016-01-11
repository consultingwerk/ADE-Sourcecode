&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2002 by Progress Software Corporation ("PSC"),       *
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
/*------------------------------------------------------------------------
    File        : ry/app/ryreqsrvrp.p     (Request Manager)
    Purpose     : Handles the Web-requests and does authentication, security checks
    Syntax      :
    Description :
    Updated     : 1/2/2001  Per Digre / PSC
                    Initial version
    Notes       :

    History:
    --------
    (v:020000)    Task:   4665         UserRef:    POSSE
                  Date:   06/13/2002   Author:    Sunil Belgaonkar

    Update Notes: Added Authentication, Security and Regional Settings and
                  changed the structure of the program


  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Pull in Dynamics global variables as NEW GLOBAL */
{af/sup2/afglobals.i NEW GLOBAL }
{af/sup/afghplipdf.i NEW GLOBAL}
{src/web2/wrap-cgi.i}

DEFINE NEW GLOBAL SHARED VARIABLE web-utilities-hdl AS HANDLE NO-UNDO.

DEFINE VARIABLE  ghUIManager AS HANDLE NO-UNDO.

DEFINE VARIABLE LOGIN                   AS CHARACTER  NO-UNDO INITIAL "login".
DEFINE VARIABLE LOGIN_CHARSET           AS CHARACTER  NO-UNDO INITIAL "dlogin.wscharset".
DEFINE VARIABLE LOGIN_COMPANY           AS CHARACTER  NO-UNDO INITIAL "dlogin.company".
DEFINE VARIABLE LOGIN_LANGUAGE          AS CHARACTER  NO-UNDO INITIAL "dlogin.language".
DEFINE VARIABLE LOGIN_PROCESSING_DATE   AS CHARACTER  NO-UNDO INITIAL "dlogin.processdate".
DEFINE VARIABLE LOGIN_USER_NAME         AS CHARACTER  NO-UNDO INITIAL "dlogin.username".
DEFINE VARIABLE LOGIN_USER_PASSWORD     AS CHARACTER  NO-UNDO INITIAL "dlogin.password".

/* The gc/gl parameters defined below are loaded from the session type -
   for Anonymous Login */
DEFINE VARIABLE gcAnonymousUserName     AS CHARACTER  NO-UNDO INITIAL "anonymous":U.
DEFINE VARIABLE gcAnonymousUserPassword AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcCharset               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcImagePath             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE glAllowAnonymousLogin   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE glDisplayLoginScreen    AS LOGICAL    NO-UNDO INITIAL YES.

/* The gc/gl parameters defined below are loaded from the session type -
   for regional Settings*/
DEFINE VARIABLE gcDateFormat            AS CHARACTER  NO-UNDO INITIAL 'mdy':U.
DEFINE VARIABLE gcTimeFormat            AS CHARACTER  NO-UNDO INITIAL 'HH:MM:SS':U.
DEFINE VARIABLE gcNumericFormat         AS CHARACTER  NO-UNDO INITIAL 'AMERICAN':U.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-authenticateUser) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD authenticateUser Procedure 
FUNCTION authenticateUser RETURNS CHARACTER
  (pcAppProgram AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cacheSessionParam) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD cacheSessionParam Procedure 
FUNCTION cacheSessionParam RETURNS LOGICAL
  () FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getClientType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getClientType Procedure 
FUNCTION getClientType RETURNS CHARACTER
  ()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContext) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getContext Procedure 
FUNCTION getContext RETURNS CHARACTER
  ( INPUT PropertyNames AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getInput) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getInput Procedure 
FUNCTION getInput RETURNS CHARACTER
  ( INPUT pcInputParam AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLoginData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLoginData Procedure 
FUNCTION getLoginData RETURNS LOGICAL
  ( OUTPUT pcUserName AS CHARACTER,
    OUTPUT pcPassword AS CHARACTER,
    OUTPUT pdCompanyObj AS DECIMAL,
    OUTPUT pdLanguageObj AS DECIMAL,
    OUTPUT pcProcessingDate AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSessionId) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSessionId Procedure 
FUNCTION getSessionId RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUIManager) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUIManager Procedure 
FUNCTION getUIManager RETURNS HANDLE
  ()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setContext) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setContext Procedure 
FUNCTION setContext RETURNS LOGICAL
  ( INPUT PropertyName AS CHARACTER,
    INPUT PropertyValue AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRegionalSettings) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setRegionalSettings Procedure 
FUNCTION setRegionalSettings RETURNS LOGICAL
  ( pcLanguage AS character,
    pcDateFormat AS CHARACTER,
    pcNumericFormat AS CHARACTER,
    pcTimeFormat AS CHARACTER,
    pcCharset AS CHARACTER)  FORWARD.

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
         HEIGHT             = 22.62
         WIDTH              = 55.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-init-request) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE init-request Procedure 
PROCEDURE init-request :
/*------------------------------------------------------------------------------
  Purpose:    Initialize the request.
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
  ghUIManager = getUIManager().
  IF NOT VALID-HANDLE(ghUIManager) THEN RETURN.

  RUN setClientAction IN ghUIManager('app.sessionid|':U + gscSessionID).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-init-session) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE init-session Procedure 
PROCEDURE init-session :
/*------------------------------------------------------------------------------
  Purpose:  Initialize the Session here
    Notes:
------------------------------------------------------------------------------*/
  /* Cache all the session parameters */
  DYNAMIC-FUNCTION('cacheSessionParam':U).
  
  ghUIManager = getUIManager().
  IF VALID-HANDLE(ghUIManager) THEN
    DYNAMIC-FUNCTION("setImagePath" IN ghUIManager, gcImagePath).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-listInputs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE listInputs Procedure 
PROCEDURE listInputs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       For debugging
------------------------------------------------------------------------------*/
  DEFINE VARIABLE c1 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE c2 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i1 AS INTEGER    NO-UNDO.
  
  c1 = get-value(?).
  lognote('html','HTML inputs, ' + c1).
  DO i1 = 1 TO NUM-ENTRIES(c1):
    c2 = ENTRY(i1,c1).
    logNote('html',c2 + '=' + get-value(c2)).
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-processRequest) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE processRequest Procedure 
PROCEDURE processRequest :
/*------------------------------------------------------------------------------
  Purpose:     Process a request based on client type.
  Parameters:  AppProgram - The repository object name
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcAppProgram AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cAuthenticationResponse AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUserLanguage           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dObjectObj              AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE iPos                    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lSecurityRestricted     AS LOGICAL    NO-UNDO INITIAL TRUE.

  /* 2. Get handle to appropriate UI Manager (based on client type) */
  ghUIManager = getUIManager().
  IF NOT VALID-HANDLE(ghUIManager) THEN
  DO:
    /* The following assumes a client type of HTML/DTHML - if this Request Manager is to be used by other client types
       then this will need to be updated to cater for this. */
    /* Output HTTP Header */
    output-content-type ("text/html":U).
    {&out}
      '<html><head><title>ERROR</title></head><body>' skip
      '<h1>Error:</h1>' skip
      '<h2>Could not get valid handle to User Interface Manager.</h2>' skip
      '(from processRequest in Request Manager)'
      /* Also output a javascript alert - in case the frame this is output to is not visible. */
      '<script>alert("ERROR: Could not get valid handle to User Interface Manager."); </script>' skip
      '</body></html>' skip.

    RETURN.
  END.

  RUN listInputs.

  /* 3. Perform Authentication */
  cAuthenticationResponse = DYNAMIC-FUNCTION('authenticateUser':U, pcAppProgram).
  IF ( cAuthenticationResponse > '') THEN
  DO:
    RUN screenEmpty IN ghUIManager.
    RETURN.
  END.
  ELSE
    logNote("NOTE":U, 'Authentication Check Successful!') NO-ERROR.

  IF pcAppProgram = LOGIN THEN
  DO:
    /* Finish login by returning to correct screen */
    RUN setClientAction IN ghUIManager ("app.continue":U).
    IF getContext('returnto') > '' THEN
      RUN setClientAction IN ghUIManager ('wbo.submit':U).
    ELSE
      RUN setClientAction IN ghUIManager ("app.refresh":U).
    RUN screenEmpty IN ghUIManager.
    RETURN ''.
  END.

  /* 4. Security check for the object */
  RUN objectSecurityCheck IN gshSecurityManager ( INPUT-OUTPUT pcAppProgram,
                                                  INPUT-OUTPUT dObjectObj,
                                                  OUTPUT lSecurityRestricted).
  IF (lSecurityRestricted) THEN
  DO:
    logNote("NOTE":U, 'Security Check Failed') NO-ERROR.
    RUN setMessage IN ghUIManager (INPUT 'AF^17^' + REPLACE(PROGRAM-NAME(1), '~\', '/') + '^Security Check Failed for Object: ' + pcAppProgram + ' (possible cause: object may not exist)', INPUT 'ERR':u).
    RUN screenEmpty IN ghUIManager.
    RETURN.
  END.
  logNote("NOTE":U, 'Security Check Successful!') NO-ERROR.

  /* 5. set regional settings */
  cUserLanguage = getContext("CurrentLanguageName") NO-ERROR.
  IF (cUserLanguage = ? OR cUserLanguage = "") THEN
    cUserLanguage = "English".

  logNote('note','Regional=' + SESSION:DATE-FORMAT + ',' + SESSION:NUMERIC-FORMAT).
  
  /* 6. Get values from UI & store in sesson/context data */
  RUN initializeRequest IN ghUIManager.

  /* 7. Output to Client (update UI) */
  RUN processRequest IN ghUIManager (AppProgram).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-authenticateUser) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION authenticateUser Procedure 
FUNCTION authenticateUser RETURNS CHARACTER
  (pcAppProgram AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:     Authenticate the request
  Parameters:  AppProgram - The repository object name
  Notes:
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cBaseHref                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDateFormat               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNumFormat                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCurrentLanguageName      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCurrentOrganisationCode  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCurrentOrganisationName  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCurrentOrganisationShort AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCurrentUserEmail         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCurrentUserName          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDoAction                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFailedReason             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLoginMessage             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectName               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPassword                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProcessingDate           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPropertyList             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUserName                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValueList                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cReturn                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dCompanyObj               AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dCurrentUserObj           AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dLanguageObj              AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE lReturnStatus             AS LOGICAL    NO-UNDO.

  /* First check if the sessionid is valid user.  If so the user authentication
     is complete and return success.  If not, then try to login the user or
     display the login screen.  If this is a relogin request then do not do the
     following step. */

  /** Activating session and set regional settings the first time **/
  IF ( pcAppProgram <> LOGIN ) THEN
  DO:
    RUN activateSession IN gshSessionManager
      (INPUT gscSessionId, /* Old session ID */
       INPUT ?,            /* New session ID */
       INPUT ?,            /* Client Session Type */
       INPUT ?,            /* Client Numeric Format */
       INPUT ?,            /* Client Date Format */
       INPUT YES,          /* Are we activating an already existing session */
       INPUT YES)          /* Should we check inactivity timeouts */
       NO-ERROR.
    IF (RETURN-VALUE = '' OR RETURN-VALUE = ?)  THEN RETURN ''.
  END.

  IF get-value('lookup') BEGINS "DYN=" THEN
    cBaseHref = SUBSTRING(get-value('lookup'),5).
  ELSE IF getInput('dlogin.lookup') BEGINS "DYN=" THEN
    cBaseHref = SUBSTRING(getInput('dlogin.lookup'),5).
  ELSE
    cBaseHref = '####'.

  ASSIGN
    cDateFormat = ENTRY(4,cBaseHref,'#')
    cNumFormat  = IF ENTRY(2,cBaseHref,'#') = ',' THEN 'European' ELSE 'American'.
    
  ERROR-STATUS:ERROR = NO.
  IF ( pcAppProgram <> LOGIN ) THEN
  DO:
    IF (NOT glAllowAnonymousLogin OR (glAllowAnonymousLogin AND glDisplayLoginScreen))  THEN
    DO:
      cDoAction = getInput("do":U).
      setContext('returnto',cDoAction).
      RUN setClientAction IN ghUIManager ("dlg.login").
      RETURN 'Display Login Screen'.
    END.
  END.

  /* Get the login information - This is a function, so it can be over ridden*/
  lReturnStatus = DYNAMIC-FUNCTION('getLoginData',
                                  OUTPUT cUserName,
                                  OUTPUT cPassword,
                                  OUTPUT dCompanyObj,
                                  OUTPUT dLanguageObj,
                                  OUTPUT cProcessingDate) NO-ERROR.

  ERROR-STATUS:ERROR = NO.
  RUN checkUser IN gshSecurityManager (INPUT cUserName,
                                       INPUT cPassword,
                                       INPUT dCompanyObj,
                                       INPUT dLanguageObj,
                                       OUTPUT dCurrentUserObj,
                                       OUTPUT cCurrentUserName,
                                       OUTPUT cCurrentUserEmail,
                                       OUTPUT cCurrentOrganisationCode,
                                       OUTPUT cCurrentOrganisationName,
                                       OUTPUT cCurrentOrganisationShort,
                                       OUTPUT cCurrentLanguageName,
                                       OUTPUT cFailedReason) NO-ERROR.

  IF (ERROR-STATUS:ERROR) THEN
  DO:
    MESSAGE 'Login Failed due to error : ' cFailedReason.
    RUN setClientAction IN ghUIManager ("info.alert||Login Failed due to error!":U).
    RETURN 'Display Login Screen'.
  END.

  IF ( cFailedReason > "":U ) THEN
  DO:
    RUN setMessage IN ghUIManager (INPUT REPLACE(cFailedReason, '~\':U, '/':U), INPUT 'ERR':u).
    RETURN 'Display Login Screen'.
  END.
  ELSE
  DO:
    /* User Authenticated - change the context info */
    ERROR-STATUS:ERROR = NO.

    /* If this is a relogin then activate the old session */
    RUN activateSession IN gshSessionManager
      (INPUT gscSessionId, /* Old session ID */
       INPUT ?,            /* New session ID */
       INPUT ?,            /* Client Session Type */
       INPUT ?,            /* Client Numeric Format */
       INPUT ?,            /* Client Date Format */
       INPUT YES,          /* Are we activating an already existing session */
       INPUT YES)          /* Should we check inactivity timeouts */
       NO-ERROR.

    /* If the error was returned from the previous activate the there is
       no existing session, so go ahead and create a new one as the user is
       already authenticated.
    */
    ASSIGN ERROR-STATUS:ERROR = NO.
    IF (RETURN-VALUE > "":U) THEN
    DO:
      logNote("note", "No existing session found for session id: " + gscSessionId + " , creating a new Dynamics session.").
      RUN activateSession IN gshSessionManager
        (INPUT ?,            /* Old session ID        */
         INPUT gscSessionId, /* New session ID        */
         INPUT ?,            /* Client Session Type   */
         INPUT cNumFormat,   /* Client Numeric Format */
         INPUT cDateFormat,  /* Client Date Format    */
         INPUT NO,           /* Are we activating an already existing session */
         INPUT YES)          /* Should we check inactivity timeouts           */
        NO-ERROR.
    END.
    ELSE
      logNote("note", "Existing session found for session id: " + gscSessionId + " , reusing the same session.").

    IF ERROR-STATUS:ERROR THEN
    DO:
      RUN setClientAction IN ghUIManager ("info.alert||":U + 'UNABLE TO CREATE PROGRESS DYNAMICS SESSION.':U).
      RETURN 'UNABLE TO CREATE PROGRESS DYNAMICS SESSION.':U.
    END.

    IF ( cProcessingDate = ? OR cProcessingDate = "" ) THEN
      cProcessingDate = STRING(TODAY) NO-ERROR.

    IF (ERROR-STATUS:ERROR) THEN
    DO:
      RUN setClientAction IN ghUIManager ("info.alert||":U + 'Date format or the Processing date entered incorrectly!':U).
      RETURN 'Date format or the Processing date entered incorrectly!':U.
    END.

    ASSIGN
      cPropertyList = "CurrentUserObj,CurrentUserLogin,CurrentUserName,CurrentUserEmail,currentOrganisationObj,CurrentOrganisationCode,CurrentOrganisationName,CurrentOrganisationShort,CurrentLanguageObj,CurrentLanguageName,CurrentProcessDate,DateFormat":U
      cValueList = STRING(dCurrentUserObj) + CHR(3) +
                   cUserName + CHR(3) +
                   cCurrentUserName + CHR(3) +
                   cCurrentUserEmail + CHR(3) +
                   STRING(dCompanyObj) + CHR(3) +
                   cCurrentOrganisationCode + CHR(3) +
                   cCurrentOrganisationName + CHR(3) +
                   cCurrentOrganisationShort + CHR(3) +
                   STRING(dLanguageObj) + CHR(3) +
                   cCurrentLanguageName + CHR(3) +
                   cProcessingDate + CHR(3) +
                   cDateFormat.

    DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager,
                                         INPUT cPropertyList,
                                         INPUT cValueList,
                                         INPUT NO).
  END.
  RETURN ''.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cacheSessionParam) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION cacheSessionParam Procedure 
FUNCTION cacheSessionParam RETURNS LOGICAL
  ():
/*------------------------------------------------------------------------------
  Purpose: This function will cache the session parameters from icfconfig file.
    Notes:
------------------------------------------------------------------------------*/
  /* Get the anonymous login data from the XML File */
  glAllowAnonymousLogin = LOGICAL(DYNAMIC-FUNCTION('getSessionParam' IN THIS-PROCEDURE, "allow_anonymous_login")).
  IF (glAllowAnonymousLogin = ?) THEN glAllowAnonymousLogin = NO.

  glDisplayLoginScreen = LOGICAL(DYNAMIC-FUNCTION('getSessionParam' IN THIS-PROCEDURE, "display_login_screen")).
  IF (glDisplayLoginScreen = ?) THEN glDisplayLoginScreen = YES.

  gcAnonymousUserName = DYNAMIC-FUNCTION('getSessionParam' IN THIS-PROCEDURE, "anonymous_user_name").
  IF (gcAnonymousUserName = ?) THEN gcAnonymousUserName = 'anonymous':U.

  gcAnonymousUserPassword = DYNAMIC-FUNCTION('getSessionParam' IN THIS-PROCEDURE, "anonymous_user_password").
  IF (gcAnonymousUserPassword = ?) THEN gcAnonymousUserPassword = '':U.

  /* Get the regional settings from the XML file */
  gcDateFormat = DYNAMIC-FUNCTION('getSessionParam' IN THIS-PROCEDURE, "session_date_format").
  IF (gcDateFormat = ?) THEN gcDateFormat = SESSION:DATE-FORMAT.

  gcTimeFormat = DYNAMIC-FUNCTION('getSessionParam' IN THIS-PROCEDURE, "session_time_format").
  IF (gctimeFormat = ?) THEN gcTimeFormat = "HH:MM:SS":U.

  /* At a later time, these can also come from XML file - Hence global variables */
  gcNumericFormat = SESSION:NUMERIC-FORMAT.

  /* Get the image file path */
  gcImagePath = DYNAMIC-FUNCTION('getSessionParam' IN THIS-PROCEDURE, "image_path").
  IF (gcImagePath = ?) THEN gcImagePath = "ry/img/,../img/":U.
  
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getClientType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getClientType Procedure 
FUNCTION getClientType RETURNS CHARACTER
  () :
/*------------------------------------------------------------------------------
  Purpose:  Determine the type of client that made the initial request.
    Notes:  ** YET TO BE DONE!
------------------------------------------------------------------------------*/
  /* Use this for now (while developing/testing) */
  RETURN "DHTML":U.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContext) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getContext Procedure 
FUNCTION getContext RETURNS CHARACTER
  ( INPUT PropertyNames AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  sets session values in the sessio nmanager
    Notes:
------------------------------------------------------------------------------*/
  DEFINE VARIABLE PropertyValueList AS CHARACTER NO-UNDO.

  IF VALID-HANDLE(gshSessionManager) THEN
    PropertyValueList = DYNAMIC-FUNCTION ("getPropertyList":U IN gshSessionManager,
                                          INPUT PropertyNames, INPUT NO ).

  RETURN PropertyValueList.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getInput) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getInput Procedure 
FUNCTION getInput RETURNS CHARACTER
  ( INPUT pcInputParam AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Get the request value
    Notes:
------------------------------------------------------------------------------*/
  ASSIGN
    pcInputParam = '|' + get-value(pcInputParam)
    pcInputParam = ENTRY(NUM-ENTRIES(pcInputParam,'|'),pcInputParam,'|').
    
  RETURN pcInputParam.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLoginData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLoginData Procedure 
FUNCTION getLoginData RETURNS LOGICAL
  ( OUTPUT pcUserName AS CHARACTER,
    OUTPUT pcPassword AS CHARACTER,
    OUTPUT pdCompanyObj AS DECIMAL,
    OUTPUT pdLanguageObj AS DECIMAL,
    OUTPUT pcProcessingDate AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  This function will return the data either from the CGI stream or
            from the session type.
    Notes:
------------------------------------------------------------------------------*/
  /* first check if the CGI stream or the form has this data */
  DEFINE BUFFER bgsm_user FOR gsm_user.

  ASSIGN
    pcUserName = getInput(LOGIN_USER_NAME)
    pcPassword = getInput(LOGIN_USER_PASSWORD).
  IF ( pcPassword <> ? AND pcPassword <> '' ) THEN
    pcPassword = ENCODE(pcPassword).

  ASSIGN
    pdCompanyObj     = DECIMAL(getInput(LOGIN_COMPANY))
    pdLanguageObj    = DECIMAL(getInput(LOGIN_LANGUAGE))
    pcProcessingDate = getInput(LOGIN_PROCESSING_DATE)
    gcCharset        = getInput(LOGIN_CHARSET).

  /* If the username is not specified, then find if anonymous login is allowed */
  IF (pcUserName= ? OR pcUserName = "") THEN
  DO:
      IF NOT (glAllowAnonymousLogin) THEN RETURN FALSE.
      ASSIGN pcUserName = gcAnonymousUserName
             pcPassword = gcAnonymousUserPassword
             pdCompanyObj = 0
             pdLanguageObj = 0
             pcProcessingDate = ?.
  END.
      
  /* go find the appropriate language and company oj for this user */
  FIND FIRST bgsm_user NO-LOCK 
       WHERE bgsm_user.USER_login_name = pcUserName NO-ERROR.
  IF AVAILABLE bgsm_user THEN
    ASSIGN pdCompanyObj  = IF pdCompanyObj  > 0 THEN pdCompanyObj  ELSE bgsm_user.DEFAULT_login_company_obj 
           pdLanguageObj = IF pdLanguageObj > 0 THEN pdLanguageObj ELSE bgsm_user.LANGUAGE_obj.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSessionId) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSessionId Procedure 
FUNCTION getSessionId RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Return the session id.
    Notes:
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSessionid AS CHARACTER NO-UNDO.

  IF VALID-HANDLE(gshSessionManager) THEN
    RETURN gscSessionId.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUIManager) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUIManager Procedure 
FUNCTION getUIManager RETURNS HANDLE
  () :
/*------------------------------------------------------------------------------
  Purpose:  Retrieve the handle to the appropriate UI Manager based on the
            Client Type.
    Notes:  
------------------------------------------------------------------------------*/
  /*
  DEFINE VARIABLE cClientType AS CHARACTER  NO-UNDO.
  cClientType = getClientType().
  CASE cClientType:
      WHEN "DHTML":U THEN   /* Complex HTML */
          ghUIManager = ghDHTMLUIM
      WHEN "HTML":U THEN    /* Simple HTML */
          ghUIManager = ghHTMLUIM
  END CASE.
  */

  IF NOT VALID-HANDLE(ghUIManager) THEN
    ghUIManager = DYNAMIC-FUNCTION("getManagerHandle":U IN THIS-PROCEDURE,
                                   "UserInterfaceManager":U).
  IF NOT VALID-HANDLE(ghUIManager) THEN
  DO:
    MESSAGE "Could not retrieve UI Manager handle.".
    QUIT.
  END.
  RETURN ghUIManager.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setContext) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setContext Procedure 
FUNCTION setContext RETURNS LOGICAL
  ( INPUT PropertyName AS CHARACTER,
    INPUT PropertyValue AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:  PropertyNames is a comma-delimited list.
            PropertyValues is a CHR(3) delimited list.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lResult AS LOGICAL NO-UNDO.

  IF VALID-HANDLE(gshSessionManager) THEN
    lResult = DYNAMIC-FUNCTION ("setPropertyList":U IN gshSessionManager,
                                 PropertyName, PropertyValue, NO).

  RETURN lResult.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRegionalSettings) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setRegionalSettings Procedure 
FUNCTION setRegionalSettings RETURNS LOGICAL
  ( pcLanguage AS character,
    pcDateFormat AS CHARACTER,
    pcNumericFormat AS CHARACTER,
    pcTimeFormat AS CHARACTER,
    pcCharset AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  This function will do the regional settings - (This should be in UI Manager)
    Notes:  The regional setting being set by this function includes
            - language (& locale, eg: en us, en uk)
            - date format
            - time format
            - numeric format
            - charset/codepage
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cCharset AS CHARACTER  NO-UNDO.
  
  RUN setClientAction IN ghUIManager ('app.dateformat|':U + pcDateFormat). /* dmy/mdy */
  RUN setClientAction IN ghUIManager ('app.timeformat|mil':U). /* mil/std only 24hour (Mil) supported so far */
  RUN setClientAction IN ghUIManager ('app.numformat|':U  + IF pcNumericFormat = "American":U THEN '.' ELSE ',').  
  
  RUN adecomm/convcp.p (WEB-CONTEXT:HTML-CHARSET, "toMime":U, OUTPUT cCharset).
  RUN setClientAction IN ghUIManager ('app.charset|':U  + cCharset /*pcCharset*/ ).

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

