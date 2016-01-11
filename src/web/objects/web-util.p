&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000-2002 by Progress Software Corporation ("PSC"),  *
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

  File: web-util.p

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

------------------------------------------------------------------------*/
&GLOBAL-DEFINE WEB-UTIL_P TRUE           /* lets proto.i know where to find functions */

{ src/web/method/cgidefs.i  }            /* Basic CGI variables */
{ src/web/method/cgiarray.i }            /* Extended CGI array variables */
{ src/web/method/tagmap.i   }            /* Tagmap Temp-Table definition */

DEFINE SHARED VARIABLE server-connection AS CHARACTER NO-UNDO.

&GLOBAL-DEFINE CONNECTION-NAME "SERVER_CONNECTION_ID":U
&SCOPED-DEFINE WEB-CURRENT-ENVIRONMENT WEB-CONTEXT:CURRENT-ENVIRONMENT
&SCOPED-DEFINE WEB-EXCLUSIVE-ID WEB-CONTEXT:EXCLUSIVE-ID
&GLOBAL-DEFINE WSEU-NAME "WSEU":U
&SCOPED-DEFINE tagMapFileName "tagmap.dat":U

DEFINE STREAM  tagMapStream.

/* Variables for configuration options.  Initialized upon Agent startup. */
DEFINE VARIABLE cfg-appurl           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cfg-environment      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cfg-eval-mode        AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cfg-cookiedomain     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cfg-cookiepath       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cfg-debugging        AS CHARACTER  NO-UNDO.

/* Configuration options for enhanced functionality. */
DEFINE VARIABLE cfg-checktime        AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cfg-compile-on-fly   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cfg-compile-options  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cfg-compile-xcode    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cfg-development-mode AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cfg-no-save-rcode    AS LOGICAL    NO-UNDO INITIAL TRUE.
DEFINE VARIABLE cfg-web-run-path     AS CHARACTER  NO-UNDO.

{ src/web/method/proto.i}
{ src/web/method/admweb.i}

/* Override cgiutils.i version of output-content-type */
&SCOPED-DEFINE EXCLUDE-output-content-type TRUE
{ src/web/method/cgiutils.i}
&UNDEFINE EXCLUDE-output-content-type 

{ src/web/method/cookies.i}
{ src/web/method/message.i}
{ src/web/method/webutils.i }

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-check-agent-mode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD check-agent-mode Procedure 
FUNCTION check-agent-mode RETURNS LOGICAL
  ( INPUT p_mode AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-devCheck) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD devCheck Procedure 
FUNCTION devCheck RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-config) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD get-config Procedure 
FUNCTION get-config RETURNS CHARACTER
  ( INPUT cVarName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAgentSetting) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAgentSetting Procedure 
FUNCTION getAgentSetting RETURNS CHARACTER
  (cInKey  AS CHARACTER,
   cInSub  AS CHARACTER,
   cInName AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-logNote) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD logNote Procedure 
FUNCTION logNote RETURNS LOGICAL
  ( INPUT pcLogType AS CHARACTER,
    INPUT pcLogText AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-output-content-type) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD output-content-type Procedure 
FUNCTION output-content-type RETURNS LOGICAL
  ( INPUT p_type AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAgentSetting) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAgentSetting Procedure 
FUNCTION setAgentSetting RETURNS LOGICAL
  (cInKey  AS CHARACTER,
   cInSub  AS CHARACTER,
   cInName AS CHARACTER,
   cInVal  AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-showErrorScreen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD showErrorScreen Procedure 
FUNCTION showErrorScreen RETURNS LOGICAL
  ( INPUT cErrorMsg AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-trueRandom) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD trueRandom Procedure 
FUNCTION trueRandom RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-webCompile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD webCompile Procedure 
FUNCTION webCompile RETURNS CHARACTER
  ( INPUT cFile     AS CHARACTER)  FORWARD.

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
         HEIGHT             = 18.86
         WIDTH              = 109.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-dbCheck) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dbCheck Procedure 
PROCEDURE dbCheck :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:      Called from web-util after filename has been figured out 
------------------------------------------------------------------------------*/
   DEFINE INPUT  PARAMETER pcFilename AS CHARACTER  NO-UNDO.
   DEFINE OUTPUT PARAMETER lRetVal    AS LOGICAL    NO-UNDO INITIAL TRUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-delete-tagmap-utilities) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE delete-tagmap-utilities Procedure 
PROCEDURE delete-tagmap-utilities :
/*------------------------------------------------------------------------------
  Purpose:     Delete any tagmap utility procedures as well as the tagmap
               records.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* Remove any existing tagmap records and persistent utilities. */
  FOR EACH tagmap:
    /* Delete the persistent process. */
    IF VALID-HANDLE(tagmap.util-Proc-Hdl) THEN
      DELETE PROCEDURE tagmap.util-Proc-Hdl NO-ERROR.
    /* Now the record can be deleted. */
    DELETE tagmap.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroy) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroy Procedure 
PROCEDURE destroy :
/*------------------------------------------------------------------------------
  Purpose:     Destroy Web object, if any, before destroying this-procedure. 
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
  ASSIGN web-utilities-hdl = ?.
  DELETE PROCEDURE THIS-PROCEDURE NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-end-request) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE end-request Procedure 
PROCEDURE end-request :
/*------------------------------------------------------------------------------
  Purpose:     place-holder procedure for allowing other super procedures to run
               after a web request has completed
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-server-connection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-server-connection Procedure 
PROCEDURE get-server-connection :
/*------------------------------------------------------------------------------
  Purpose:     Return the value of SESSION:SERVER-CONNECTION-ID
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RETURN server-connection.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-transaction-state) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-transaction-state Procedure 
PROCEDURE get-transaction-state :
/*------------------------------------------------------------------------------
  Purpose:     Return the transaction state.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF glStateAware THEN DO:
    /* Run get-transaction-state in web/objects/stateaware.p. */
    RUN SUPER.
    RETURN RETURN-VALUE.
  END.
  ELSE
    DYNAMIC-FUNCTION ("logNote":U IN web-utilities-hdl, "Error":U,
                      "#3 StateAware support is inactive.  To activate, create a broker 'STATE_AWARE_ENABLED' environment variable with value of 'yes'.") NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-init-cgi) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE init-cgi Procedure 
PROCEDURE init-cgi :
/*---------------------------------------------------------------------------
  Procedure:   init-cgi
  Description: Initializes WebSpeed functionality prior to web request
  Input:       Environment variables
  Output:      Sets global variables defined in src/web/method/cgidefs.i
---------------------------------------------------------------------------*/
  DEFINE VARIABLE v-http-host     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE v-host          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE v-port          AS CHARACTER  NO-UNDO.

  RUN init-variables.    /* initialize CGI and misc. variables */
  
  /* Reset the server-connection variable and SERVER_CONNECTION_ID cookie. */
  RUN set-server-connection(SESSION:SERVER-CONNECTION-ID).
    
  /* Initialize User Fields */
  ASSIGN
    UserFieldVar  = ""
    UserFieldList = "".

  /* Set global variables HostURL, AppURL and SelfURL so self-referencing
     URL's can be generated by applications. If the Host: header (HTTP_HOST) 
     was sent by the browser, using it will provide for fewer problems with 
     self-referencing URL's than SERVER_NAME and SERVER_PORT. */
  ASSIGN 
    v-http-host = get-cgi("HTTP_HOST":U).
  IF v-http-host = "" THEN
    /* No Host: header was sent by the browser. */
    ASSIGN 
      v-host = SERVER_NAME
      v-port = SERVER_PORT.
  ELSE IF NUM-ENTRIES(v-http-host, ":":U) = 2 THEN
  /* Host: hostname:port combination was sent by the browser */
    ASSIGN 
      v-host = ENTRY(1, v-http-host, ":":U)
      v-port = ENTRY(2, v-http-host, ":":U).
  ELSE
  /* Else Host: hostname with no port number was sent by the browser */
    ASSIGN 
      v-host = v-http-host
      v-port = SERVER_PORT.
  /* Set the scheme, host and port of the URL to ourself.  Omit
     port if 80 or 443 if https is on. */
  IF HTTPS = "ON":U THEN
    ASSIGN 
      HostURL = (IF v-host = "" THEN ""
                 ELSE "https://":U + v-host +
                  (IF v-port = "443":U THEN "" ELSE ":":U + v-port)).
  ELSE
    ASSIGN 
      HostURL = (IF v-host = "" THEN ""
                 ELSE "http://":U + v-host +
                  (IF v-port = "80":U THEN "" ELSE ":":U + v-port)).

  /* Server-relative URL to ourself (this program) except for optional
       QUERY_STRING. */
  ASSIGN
    SelfURL = SCRIPT_NAME + PATH_INFO.

  /* Check for alternate URL format used by the Messengers */
  IF PATH_INFO BEGINS "/WService=":U THEN
    ASSIGN
      /* Web object filename is everything after the second "/" in PATH_INFO */
      AppProgram = (IF NUM-ENTRIES(PATH_INFO, "/":U) >= 3 THEN
                      SUBSTRING(PATH_INFO, INDEX(PATH_INFO, "/":U, 2) + 1)
                    ELSE "")
      /* Server relative URL of this Web objects's application */
      AppURL     = SCRIPT_NAME + "/":U + ENTRY(2, PATH_INFO, "/":U).

  ELSE
    ASSIGN
      /* Web object filename is everything after the second "/" in PATH_INFO */
      AppProgram = SUBSTRING(PATH_INFO, 2)
      /* Server relative URL of this Web objects's application */
      AppURL     = SCRIPT_NAME.

  /* If the ApplicationURL option was set in the Windows Registry or
     webspeed.cnf, then use that to set AppURL instead of SCRIPT_NAME and
     PATH_INFO.  Make sure it's prefixed with a "/" since we don't handle
     an entire URL. */
  IF cfg-appurl BEGINS "/":U THEN
    ASSIGN
      AppURL  = cfg-appurl
      SelfURL = AppURL + "/":U + AppProgram.

  /* The Alibaba 2.0 NT server upper cases SCRIPT_NAME and PATH_INFO.  This
     is a bug.  To work around this, lower case AppURL, etc.  Otherwise
     Cookies (which are case sensitive) will fail to match preventing
     locking from working . */
  IF SERVER_SOFTWARE BEGINS "Alibaba/2":U THEN
    ASSIGN
      HostURL    = LC(HostURL)
      AppURL     = LC(AppURL)
      SelfURL    = LC(SelfURL)
      AppProgram = LC(AppProgram).
 
  ASSIGN
    http-newline = (IF SERVER_SOFTWARE BEGINS "Netscape-":U 
                    OR SERVER_SOFTWARE BEGINS "IPlanet-":U 
                    OR SERVER_SOFTWARE BEGINS "Sun ONE":U 
                    OR SERVER_SOFTWARE BEGINS "FrontPage-PWS":U THEN "~n":U
                    ELSE "~r~n":U)

    /* Set cookie defaults from either configuration defaults or AppURL */
    CookiePath   = (IF cfg-cookiepath <> "" THEN cfg-cookiepath ELSE AppURL)
    CookieDomain = cfg-cookiedomain.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-init-config) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE init-config Procedure 
PROCEDURE init-config :
/*------------------------------------------------------------------------------
  Purpose:     Read in extra configuration options at Agent startup.
  Parameters:  None
  Notes:       Watch the propath issues
               Check for @{workpath} and v-workdir 
               Review Xcode option(s)
               Consider prefixing settings.
               Bring all Dynamics vars (icf*) into variable(s) then parse. This will avoid 
               hard-coding, but it will add a level of complexity.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE ix         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cDatabases AS CHARACTER  NO-UNDO.

  /* Set a default session tracking cookie. This allows the application to automatically 
     track anonymouse/unidentified user 'movements' through the system.  This is 
     the prefix of the cookie. If it is non-blank the session tracking cookie 
     will be used automatically. */
  ASSIGN cValue = OS-GETENV("SESSION_COOKIE":U).
  IF cValue > "" THEN
    setAgentSetting("Session":U,"","Cookie":U,cValue).

  /* WebRunPath example.  Allow specific resources to be accessed via the URL.  
     This does not override the PROPATH.
        
     WebRunPath=c:\webapps\apps\ *,c:\program files\progress\tty\webtools\ *,
                c:\program files\progress\tty\webedit\ *,
                c:\program files\progress\tty\workshop.r
  */
  ASSIGN cValue = REPLACE(OS-GETENV("WEB_RUN_PATH":U),';',',').
  IF cValue > "" THEN
    setAgentSetting("Path":U,"","WebRunPath":U,cValue).
  
  /* Batch Interval Time.  Amount of time agents sit idle before breaking out 
     of WAIT-FOR and running DB checks and the batch procedure.  Wait for 
     web-request for the larger of either 15, or cfg-check-interval seconds. By 
     breaking out of WAIT-FOR we can simulate a batch procedure.  NOTE: Anything 
     that goes into the batch program should have a relatively short run time,
     otherwise agents could potentially all lock. */ 
  ASSIGN ix = INTEGER(OS-GETENV("BATCH_INTERVAL":U)) NO-ERROR.
  ASSIGN ix = IF ix > 0 THEN MAXIMUM(15,ix) ELSE -1.
  setAgentSetting("Misc":U,"","BatchInterval":U,STRING(ix)).

  /* CompileOnFly.  What options to use when compilation is needed.
     Save:  Save the r-code after the compile.
     CheckTime: Check the time difference between the source and R-code and 
     compile if source is newer. */    
  ASSIGN cValue  = REPLACE(OS-GETENV("COMPILE_ON_FLY":U),";",",").
  IF cValue > "" THEN
    setAgentSetting("Compile":U,"":U, "Options":U,cValue).

  /* CompileXCODE -- Xcode to be used when compile code. */
  ASSIGN cValue = OS-GETENV("COMPILE_XCODE":U).
  IF cValue > "" THEN
    setAgentSetting("Compile":U,"","xcode",cValue).

  /* SessionPath configuration -- path for storing session information.
     This option is not used when using database-driven session storage 
     mechanism. */
  ASSIGN cValue = OS-GETENV("SESSION_PATH":U).
  IF cValue > "" THEN
    setAgentSetting("Session":U,"","StorePath":U, REPLACE(cValue,"~\","~/")).

  /* Set flag that activates state-aware support code. Check for missing value
     for backward compatability. */
  ASSIGN cValue = OS-GETENV("STATE_AWARE_ENABLED":U).
  IF cValue = "yes":U OR cValue = "" OR cValue = ? THEN
    setAgentSetting("Session":U, "", "StateAware":U, "yes":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-init-request) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE init-request Procedure 
PROCEDURE init-request :
/*---------------------------------------------------------------------------
  Procedure:   init-request
  Description: Initializes WebSpeed environment for each web request
  Input:       Environment variables
  Output:      Sets global variables defined in src/web/method/cgidefs.i
---------------------------------------------------------------------------*/
  
  IF glStateAware THEN  
    RUN SUPER.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-init-session) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE init-session Procedure 
PROCEDURE init-session :
/*---------------------------------------------------------------------------
  Procedure:   init-session
  Description: Initializes PROGRESS session variables from the environment. 
  Input:       <none>
  Output:      Sets global variables defined in src/web/method/cgidefs.i
  Notes:       These values should be the default values on a WEB-based client.
               (But it never hurts to make sure.)
----------------------------------------------------------------------------*/
  DEFINE VARIABLE cValue AS  CHARACTER  NO-UNDO.

  /* Never pause for user input. */
  PAUSE 0 BEFORE-HIDE.
  ASSIGN 
    SESSION:SYSTEM-ALERT-BOXES = FALSE
    SESSION:APPL-ALERT-BOXES   = FALSE.
 
  /* Get configuration settings from ubroker.properties */
  ASSIGN
    cfg-environment  = WEB-CONTEXT:GET-CONFIG-VALUE("srvrAppMode":U) 
    cfg-eval-mode    = check-agent-mode("Evaluation") /* TRUE if eval mode */
    cfg-debugging    = WEB-CONTEXT:GET-CONFIG-VALUE("srvrDebug":U) 
    cfg-appurl       = WEB-CONTEXT:GET-CONFIG-VALUE("applicationURL":U)
    cfg-cookiepath   = WEB-CONTEXT:GET-CONFIG-VALUE("defaultCookiePath":U)
    cfg-cookiedomain = WEB-CONTEXT:GET-CONFIG-VALUE("defaultCookieDomain":U)
    RootURL          = WEB-CONTEXT:GET-CONFIG-VALUE("wsRoot":U)
    .

  /* If in Production mode and debugging is not enabled or debugging is
     disabled, then set flag to disable debugging. */
  IF (check-agent-mode("Production":U) AND 
      NOT CAN-DO(cfg-debugging, "Enabled":U)) OR
    CAN-DO(cfg-debugging, "Disabled":U)       OR
    CAN-DO(cfg-debugging, "Off":U) THEN
    ASSIGN debugging-enabled = FALSE.

  IF debugging-enabled THEN
    /* The following values are retrieved from the Configuration Manager. */
    ASSIGN
      cfg-development-mode = cfg-environment BEGINS "Dev"
      cfg-compile-options  = getAgentSetting("Compile":U, "":U, "Options":U)
      cfg-compile-xcode    = getAgentSetting("Compile":U, "":U, "xcode":U)
      cfg-web-run-path     = getAgentSetting("Path":U, "":U,"WebRunPath":U)
      cfg-no-save-rcode    = CAN-DO(cfg-compile-options,"NoSave")
      cfg-checktime        = CAN-DO(cfg-compile-options,"CheckTime")
      cfg-compile-on-fly   = cfg-compile-options > "" AND cfg-development-mode
      .
      
  ASSIGN
    glStateAware = (getAgentSetting("Session":U, "":U, "StateAware":U) = "yes":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-init-variables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE init-variables Procedure 
PROCEDURE init-variables :
/*---------------------------------------------------------------------------
Procedure:   init-variables
Description: Initializes PROGRESS variables from the environment
Input:       Environment variables
Output:      Sets global variables defined in src/web/method/cgidefs.i
----------------------------------------------------------------------------*/
  DEFINE VARIABLE i-field AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i-pair  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE asc-del AS CHARACTER  NO-UNDO
    INITIAL "~377":U.   /* delimiter character in octal = CHR(255) */
  DEFINE VARIABLE hex-del AS CHARACTER  NO-UNDO
    INITIAL "%FF":U.    /* delimiter character in encoded hex */
  DEFINE VARIABLE ix      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE eql     AS INTEGER    NO-UNDO.
  
  /* Global variables to initialize with each request */
  ASSIGN
    CgiVar              = ""  
    CgiList             = ""  
    output-content-type = ""
    SelDelim            = ",":U
    FieldList           = ""
    FieldVar            = "".

  /* Read in the CGI environment variable pairs which are delimited by 
     ASCII 255 characters.  Any literal ASCII 255 values have been encoded
     as hexidecimal %FF in the same manner as URL encoding. */
  DO ix = 1 TO NUM-ENTRIES({&WEB-CURRENT-ENVIRONMENT}, asc-del):
    ASSIGN
      i-pair     = ENTRY(ix, {&WEB-CURRENT-ENVIRONMENT}, asc-del)
      eql        = INDEX(i-pair,"=":U)
      i-field    = SUBSTRING(i-pair,1,eql - 1,"RAW":U)
      CgiVar[ix] = REPLACE(SUBSTRING(i-pair,eql + 1,-1,"RAW":U),hex-del,asc-del)
      CgiList    = CgiList + (IF CgiList = "" THEN "" ELSE ",":U ) + i-field.
  END.

  /* Import CGI 1.1 variables into global variables */
  ASSIGN
    AUTH_TYPE               = get-cgi("AUTH_TYPE":U)
    CONTENT_LENGTH          = INTEGER(get-cgi("CONTENT_LENGTH":U))
    CONTENT_TYPE            = get-cgi("CONTENT_TYPE":U)
    GATEWAY_INTERFACE       = get-cgi("GATEWAY_INTERFACE":U)
    PATH_INFO               = get-cgi("PATH_INFO":U)
    PATH_TRANSLATED         = get-cgi("PATH_TRANSLATED":U)
    QUERY_STRING            = get-cgi("QUERY_STRING":U)
    REMOTE_ADDR             = get-cgi("REMOTE_ADDR":U)
    REMOTE_HOST             = get-cgi("REMOTE_HOST":U)
    REMOTE_IDENT            = get-cgi("REMOTE_IDENT":U)
    REMOTE_USER             = get-cgi("REMOTE_USER":U)
    REQUEST_METHOD          = get-cgi("REQUEST_METHOD":U)
    SCRIPT_NAME             = get-cgi("SCRIPT_NAME":U)
    SERVER_PROTOCOL         = get-cgi("SERVER_PROTOCOL":U)
    SERVER_NAME             = get-cgi("SERVER_NAME":U)
    SERVER_PORT             = get-cgi("SERVER_PORT":U)
    SERVER_SOFTWARE         = get-cgi("SERVER_SOFTWARE":U) NO-ERROR.

  /* Import some HTTP variables into global variables */
  ASSIGN
    HTTP_ACCEPT             = get-cgi("HTTP_ACCEPT":U)
    HTTP_COOKIE             = get-cgi("HTTP_COOKIE":U)
    HTTP_REFERER            = get-cgi("HTTP_REFERER":U)
    HTTP_USER_AGENT         = get-cgi("HTTP_USER_AGENT":U)
    HTTPS                   = get-cgi("HTTPS":U).

  /* Test for Microsoft's IIS which doesn't use HTTPS ON/OFF*/
  IF SERVER_SOFTWARE BEGINS "Microsoft-IIS/":U AND
    get-cgi("SERVER_PORT_SECURE":U) = "1":U THEN
    ASSIGN HTTPS = "ON":U.

  /* Other environment variables */
  ASSIGN
     UTC-OFFSET             = WEB-CONTEXT:UTC-OFFSET.

  /* If SERVER_PORT is null, then set it 80 or 443 if HTTPS is ON */
  IF SERVER_PORT = "" THEN
    ASSIGN SERVER_PORT = (IF HTTPS = "ON":U THEN "443":U ELSE "80":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-reset-tagmap-utilities) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE reset-tagmap-utilities Procedure 
PROCEDURE reset-tagmap-utilities :
/*------------------------------------------------------------------------------
  Purpose:     Load the tagmap.dat file and create entries in the tagmap temp-
               table. Run the procedures associated with each one of these
               files.              
  Parameters:  <none>
  Notes:       Any existing tagmap records are first deleted.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE next-line   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE tagmapfile  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSearchFile AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i-count     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE num-ent     AS INTEGER    NO-UNDO.
  
  DEFINE BUFFER xtagmap FOR tagmap.
  
  /* Remove any existing tagmap records and persistent utilities. */
  RUN delete-tagmap-utilities NO-ERROR.
  
  /* Make sure the tagmap.dat file exists in the PROPATH */
  ASSIGN 
    tagmapfile = SEARCH({&tagMapFileName})
    i-count    = 0.
  IF tagmapfile EQ ? THEN DO:
    DYNAMIC-FUNCTION ("logNote" IN web-utilities-hdl, "Error":U,
                                 "The file '":U + {&tagMapFileName} + "' was not in your PROPATH":U) NO-ERROR.
    RETURN ERROR.
  END.

  INPUT STREAM tagMapStream FROM VALUE(tagmapfile) NO-ECHO.
  REPEAT ON ENDKEY UNDO, LEAVE:
    /* Clear variable before read to handle blank lines. */
    ASSIGN 
      next-line = "". 
    IMPORT STREAM tagMapStream UNFORMATTED next-line.
    
    IF LENGTH(next-line,"CHARACTER":U) > 4 AND
      SUBSTRING(next-line,1,1,"CHARACTER":U) <> "#":U THEN DO:
      CREATE tagmap.
      ASSIGN
        i-count               = i-count + 1
        num-ent               = NUM-ENTRIES(next-line)
        tagmap.i-order        = i-count
        tagmap.htm-Tag        = ENTRY(1,next-line)
        tagmap.htm-Type       = (IF num-ent >= 3 THEN 
                                   ENTRY(3,next-line) ELSE "":U)
        tagmap.psc-Type       = (IF num-ent >= 4 
                                   THEN ENTRY(4,next-line) ELSE "":U)
        tagmap.util-Proc-Name = (IF num-ent >= 5 
                                   THEN ENTRY(5,next-line) ELSE "":U)
        .
      
      /* We allow for empty utility procedures. */
      IF tagmap.util-Proc-Name ne "":U THEN DO:
        /* If there another tagmap that is already running this procedure? */
        FIND FIRST xtagmap WHERE xtagmap.util-Proc-Name eq tagmap.util-Proc-Name
                             AND RECID(xtagmap) ne RECID(tagmap) NO-ERROR.
        IF AVAILABLE (xtagmap) AND VALID-HANDLE(xtagmap.util-Proc-Hdl) THEN
          tagmap.util-Proc-Hdl = xtagmap.util-Proc-Hdl.
        ELSE DO:
          /* Check that the file exists. */
          RUN adecomm/_rsearch.p (INPUT tagmap.util-Proc-Name, OUTPUT cSearchFile).
          IF cSearchFile ne ? THEN DO:
            /*RUN VALUE(cSearchFile) PERSISTENT SET tagmap.util-Proc-Hdl NO-ERROR.*/
            RUN VALUE(tagmap.util-Proc-Name) PERSISTENT SET tagmap.util-Proc-Hdl NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
              tagmap.util-Proc-Hdl = ?.
              RUN HtmlError (SUBSTITUTE ("Unable to run Tagmap Utility file '&1'", 
                                           tagmap.util-Proc-Name )).
            END. /* IF...ERROR... */
          END. /* IF cSearchFile ne ?... */
          ELSE
            RUN HtmlError (SUBSTITUTE ("Unable to find Tagmap Utility file '&1'", 
                                          tagmap.util-Proc-Name )).
        END. /* IF <not> AVAILABLE (xtagmap)... */
      END. /* IF...util-Proc-Name ne ""... */
     END. /* IF LENGTH... */
  END. /* REPEAT... */
  
  /* Close the tagmap stream. */
  INPUT STREAM tagMapStream CLOSE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-run-batch-object) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE run-batch-object Procedure 
PROCEDURE run-batch-object :
/*------------------------------------------------------------------------------
  Purpose:      Runs the user specified procedure during the 'break wait-state' intervals.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  MESSAGE "Batch Procedure called but not configured!".
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-run-web-object) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE run-web-object Procedure 
PROCEDURE run-web-object :
/*------------------------------------------------------------------------------
  Purpose:     Run the selected program 
  Parameters:  pcFilename = (CHAR) Name of application file user is requesting
  Notes:       If this agent is in development and rcode does not exist, then a 
               compile on the requested HTML program will be attempted and the 
               resulting rcode will be run if possible.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcFilename     AS CHARACTER  NO-UNDO.
   
  DEFINE VARIABLE cCompileExt            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCompilerMsg           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFileExt               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLog                   AS CHARACTER  NO-UNDO. 
  DEFINE VARIABLE cRFile                 AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSearch                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSearchFile            AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSessionPrefix         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dFile                  AS DATE       NO-UNDO.
  DEFINE VARIABLE lCompiled              AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lRetVal                AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lRunOk                 AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE tFile                  AS INTEGER    NO-UNDO.

  /* Log all runs of workshop in Production */
  IF cfg-development-mode NE TRUE AND pcFilename MATCHES "workshop*" THEN DO:
    ASSIGN
      cLog = SUBSTITUTE("WebSpeed Workshop (&1) was requested by &2",
                         pcFilename, REMOTE_ADDR) NO-ERROR.
    DYNAMIC-FUNCTION ("logNote":U IN web-utilities-hdl, "WARNING":U, cLog).
  END.
   
  /* Make sure the file is in the PROPATH.  Make sure we can find rcode. */
  RUN adecomm/_rsearch.p (INPUT pcFilename, OUTPUT cSearchFile).

  IF cSearchFile = ? THEN
    /* If there is no rcode then just make sure the file is in the propath */
    RUN webutil/_relname.p (INPUT pcFilename, "MUST-BE-REL":U, OUTPUT cSearchFile).  
  ELSE DO:
    /* If we found rcode, then make sure the Rcode is in the propath */
    /* 
       This is not necessary if we found the rcode in a .pl file, since the .pl must
       have been added to the PROPATH, otherwise we wouldn't have found it in
       _rsearch.p to begin with. WE can't call _relname.p for .pl since it will always
       fail. 
    */
    IF NOT cSearchFile MATCHES ('*<<*>>':U) THEN 
       RUN webutil/_relname.p (INPUT cSearchFile, "MUST-BE-REL":U, OUTPUT cSearchFile).
  END.

  /* If the rcode or the file was not in the propath then error */
  IF cSearchFile = ? THEN DO:
      /* If we found rcode but the file was not in the propath then reject it */
    DYNAMIC-FUNCTION ("logNote":U IN web-utilities-hdl, "WARNING",
      SUBSTITUTE ("&1 was requested by &2 but was not in the propath and was rejected. (Ref: &3)", 
                  pcFilename, REMOTE_ADDR, HTTP_REFERER)) NO-ERROR.
    DYNAMIC-FUNCTION ("ShowErrorScreen":U IN web-utilities-hdl,
      SUBSTITUTE ("Unable to find web object file '&1'", 
                  pcFilename)) NO-ERROR.  
    RETURN.
  END. /* Not found in the propath */

  /* If this is configured then perform the check, if its left blank, then 
     allow anything.  Check and see if there is a more restricted path for 
     running objects. */
  ASSIGN
    cSearchFile = SEARCH(cSearchFile).
    
  IF cfg-web-run-path > "" AND NOT CAN-DO(cfg-web-run-path,cSearchFile) THEN DO:
    DYNAMIC-FUNCTION ("logNote":U IN web-utilities-hdl, "WARNING":U,
                                SUBSTITUTE ("&1 was requested by &2 but was not in the WebRunPath and was rejected. (Ref: &3)",
                                            pcFilename, REMOTE_ADDR, HTTP_REFERER)) NO-ERROR.
    DYNAMIC-FUNCTION ("ShowErrorScreen":U IN web-utilities-hdl,
                                SUBSTITUTE ("Unable to find web object file '&1'",
                                            pcFilename )) NO-ERROR.  
    RETURN.
  END. /* not found in the WebRunPath */

  /* Verify file extension is valid, i.e. .w, .r, .p, or .  */
  ASSIGN
    cSearch = IF cSearchFile = ? THEN pcFileName
              ELSE IF cSearchFile MATCHES ('*<<*>>':U) THEN
                ENTRY(1,ENTRY(3,cSearchFile,'<':U),'>':U)
              ELSE cSearchFile.
  RUN adecomm/_osfext.p (INPUT cSearch, OUTPUT cFileExt) NO-ERROR.
    
  IF cFileExt > "" AND NOT CAN-DO(".w,.p,.r,.":U, cFileExt) THEN 
    /* if the file cannot be run directly then look for rcode by the same file name */
    cSearchFile = SEARCH(SUBSTRING(pcFilename, 1, R-INDEX(pcFilename, ".":U),"CHARACTER":U) + "r":U).

  IF cfg-compile-xcode > "" AND CAN-DO(".w,.p":U, cFileExt) THEN
    cSearchFile = SEARCH(SUBSTRING(pcFilename, 1, R-INDEX(pcFilename, ".":U),"CHARACTER":U) + "r":U).

  IF cfg-checktime AND cSearchFile > "" AND NOT CAN-DO(".r,.":U, cFileExt) THEN DO:
    ASSIGN
      FILE-INFO:FILE-NAME = cSearchFile
      dFile               = FILE-INFO:FILE-MOD-DATE
      tFile               = FILE-INFO:FILE-MOD-TIME
      FILE-INFO:FILE-NAME = SEARCH(pcFilename).
    IF   dFile < FILE-INFO:FILE-MOD-DATE OR 
        (dFile = FILE-INFO:FILE-MOD-DATE AND 
         tFile < FILE-INFO:FILE-MOD-TIME) OR 
         tFile = ?  THEN  DO:
      DYNAMIC-FUNCTION ("logNote":U IN web-utilities-hdl, "COMPILE":U,
                        "Source Code has changed since compile.") NO-ERROR.
      OS-DELETE VALUE(cSearchFile) NO-ERROR.
      cSearchFile = ?.
    END.
  END.

  /* If rcode is not available then see if we can compile the current file. */
  IF cfg-compile-on-fly AND cSearchFile = ? AND NOT CAN-DO(".r,.":U, cFileExt) THEN DO: 
    /* If we're allowed, try to find .html or .htm and try to compile it */
    ASSIGN 
      cSearchFile = SEARCH(pcFilename).
    IF cSearchFile > "" THEN DO:

      ASSIGN cCompilerMsg =  webCompile(cSearchFile).  

      /* If the compile failed, then log the failed compile and return an error 
         to the user. */
      IF NOT cCompilerMsg BEGINS "OK" THEN DO:
        DYNAMIC-FUNCTION ("logNote":U IN web-utilities-hdl, "COMPILE":U,
                                     cCompilerMsg + " ") NO-ERROR.
        DYNAMIC-FUNCTION ("logNote":U IN web-utilities-hdl, "ERROR":U,
                                     SUBSTITUTE ("&1 cannot be run as a web object (Ref: &2)"), 
                                                 pcFileName, HTTP_REFERER) NO-ERROR.
        DYNAMIC-FUNCTION ("ShowErrorScreen":U IN web-utilities-hdl,
                                     cCompilerMsg) NO-ERROR.
        RETURN.
      END. 
      ELSE DO:
        DYNAMIC-FUNCTION ("logNote":U IN web-utilities-hdl, "COMPILE":U,
                                     SUBSTITUTE ("Compiled &1 at run time", 
                                                 cSearchFile)) NO-ERROR.
        lCompiled = TRUE.
      END. /* compilermsg eq OK */
    END. /* could not find HTML file */
  END. /* Could not find the file at all and not in development mode */

  IF cSearchfile = ? THEN DO: /* could not find html or rcode */
    DYNAMIC-FUNCTION ("logNote":U IN web-utilities-hdl, "ERROR":U,
                                SUBSTITUTE("& could not be found (Ref: &2)",
                                           pcFilename, HTTP_REFERER)) NO-ERROR.
    DYNAMIC-FUNCTION ("ShowErrorScreen":U IN web-utilities-hdl,
                                SUBSTITUTE("Unable to find web object file '&1'", 
                                           pcFilename )) NO-ERROR.
    RETURN.
  END.  /* cannot find a file to run anywhere (or not in development )*/
        
  /* Now check database connections prior to running/compiling. */
  RUN dbCheck IN web-utilities-hdl (INPUT pcFilename, OUTPUT lRetVal).
  IF lRetVal EQ FALSE THEN DO:
    DYNAMIC-FUNCTION ("logNote":U IN web-utilities-hdl, "ERROR":U,
                                SUBSTITUTE("&1 did not have the required databases connected (Ref: &2)",
                                           pcFilename, HTTP_REFERER)) NO-ERROR.
    DYNAMIC-FUNCTION ("ShowErrorScreen":U IN web-utilities-hdl,
                                SUBSTITUTE("&1 cannot be run as a web object.", 
                                           pcFilename)) NO-ERROR.
    RETURN.
  END.
  
  /* Make a note about which program we are running. */
  cLog = "Running: " + pcFilename.
  DYNAMIC-FUNCTION ("logNote":U IN web-utilities-hdl, "RUN":U, cLog) NO-ERROR.
  ASSIGN
    ERROR-STATUS:ERROR = FALSE
    COMPILER:ERROR     = FALSE.

  EXECUTE-BLOCK:   
  DO ON ERROR  UNDO EXECUTE-BLOCK, LEAVE EXECUTE-BLOCK  
     ON ENDKEY UNDO EXECUTE-BLOCK, LEAVE EXECUTE-BLOCK
     ON STOP   UNDO EXECUTE-BLOCK, LEAVE EXECUTE-BLOCK
     ON QUIT                     , LEAVE EXECUTE-BLOCK:

     /* Assumes state-aware support is turned on.  Run run-web-object in
        web/objects/stateaware.p. */
     IF glStateAware THEN
       RUN SUPER (pcFileName) NO-ERROR.
     ELSE 
       RUN VALUE(pcFilename) NO-ERROR. 
  END.

  /* Did the code run okay?  Also trap for compiler error here, since some code 
     may run a program directly without running it through run-web-object */
  lRunOk = (NOT ERROR-STATUS:ERROR AND NOT COMPILER:ERROR).  
  IF NOT lRunOk THEN DO:
    IF COMPILER:ERROR = TRUE THEN
      DYNAMIC-FUNCTION ("logNote":U IN web-utilities-hdl, "Error":U,
                                   SUBSTITUTE ("Compile error in &1 at line &2.",
                                               COMPILER:FILENAME, COMPILER:ERROR-ROW)) NO-ERROR.
    DYNAMIC-FUNCTION ("logNote":U IN web-utilities-hdl, "Error":U,
                                 SUBSTITUTE ("&1 tried to run but failed. Message: &2", pcFilename, ERROR-STATUS:GET-MESSAGE(1))) NO-ERROR.

    DYNAMIC-FUNCTION ("ShowErrorScreen":U IN web-utilities-hdl,
                                 SUBSTITUTE ("Unable to run Web object '&1'",pcFilename)) NO-ERROR.
  END. /* IF...ERROR... */
  
  ASSIGN cLog = SUBSTITUTE ("Finished: &1 : &2",pcFilename,
                            STRING(lRunOk,"OK/ERROR")).
  DYNAMIC-FUNCTION ("logNote":U IN web-utilities-hdl, "RUN":U, cLog) NO-ERROR.

   /* If the requested file was compiled on the fly, and NoSave was specified 
      for r-code, then delete the temporary .r file. */
  IF cfg-no-save-rcode AND lCompiled THEN DO:
    /** check which file to delete */
      cSearchFile = SUBSTRING(cSearchFile,1,R-INDEX(cSearchFile, ".":U), "CHARACTER":U) + "r":U.
      DYNAMIC-FUNCTION ("logNote":U IN web-utilities-hdl, "COMPILE":U,
                        "NoSave Option -> Removing:" + cSearchFile) NO-ERROR.
      OS-DELETE VALUE(cSearchFile) NO-ERROR.
  END.

   /* close default logging */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-set-server-connection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-server-connection Procedure 
PROCEDURE set-server-connection :
/*------------------------------------------------------------------------------
  Purpose:     Used to reset server-connection variable or destroy the 
               SERVER_CONNECTION_ID cookie
  Parameters:  p_wo-hdl        - TARGET-PROCEDURE handle
               p_connection-id - SESSION:SERVER-CONNECTION-ID value or blank
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_connection-id   AS CHARACTER NO-UNDO.

  server-connection = p_connection-id.

  IF useConnID = "0":U THEN DO:
    /* Delete the SERVER_CONNECTION_ID cookie */
    IF INDEX(HTTP_COOKIE,"SERVER_CONNECTION_ID=":U) > 0 THEN
      delete-cookie({&CONNECTION-NAME}, ?, ?).
    
    /* Let core know the logical session has ended */
    WEB-CONTEXT:SESSION-END = TRUE.
  END.
  ELSE IF p_connection-id <> "" THEN DO:
    /* Create the SERVER_CONNECTION_ID cookie used to maintain context across 
       browser sessions. */
    set-cookie({&CONNECTION-NAME}, p_connection-id, ?, ?, ?, ?, ?).
    
    /* Let core know the logical session is active */
    WEB-CONTEXT:SESSION-END = FALSE.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-set-transaction-state) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-transaction-state Procedure 
PROCEDURE set-transaction-state :
/*------------------------------------------------------------------------------
  Purpose:     Set transaction state.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pState AS CHARACTER NO-UNDO.
  
  IF glStateAware THEN
    /* Run set-transaction-state in web/objects/stateaware.p. */
    RUN SUPER (pState).
  ELSE
    DYNAMIC-FUNCTION ("logNote":U IN web-utilities-hdl, "Error":U,
                      "#1 StateAware support is inactive.  To activate, create a broker 'STATE_AWARE_ENABLED' environment variable with value of 'yes'.") NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-set-web-state) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-web-state Procedure 
PROCEDURE set-web-state :
/*------------------------------------------------------------------------------
  Purpose:     Set web-state for the current Web object. Create appropriate 
               cookie information.
  Parameters:  p_wo-hdl:  Procedure handle of the Web object
               p_timeout: Timeout period in minutes
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_wo-hdl          AS HANDLE  NO-UNDO.
  DEFINE INPUT PARAMETER p_timeout         AS DECIMAL NO-UNDO.

  IF glStateAware THEN
    /* Run set-web-state in web/objects/stateaware.p. */
    RUN SUPER (p_wo-hdl, p_timeout).
  ELSE
    DYNAMIC-FUNCTION ("logNote":U IN web-utilities-hdl, "Error":U,
                      "#2 StateAware support is inactive.  To activate, create a broker 'STATE_AWARE_ENABLED' environment variable with value of 'yes'.") NO-ERROR.
                      
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-show-errors) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE show-errors Procedure 
PROCEDURE show-errors :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Empty stub - no longer needed, but still referenced by admweb.i, 
               which we need
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-check-agent-mode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION check-agent-mode Procedure 
FUNCTION check-agent-mode RETURNS LOGICAL
  ( INPUT p_mode AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN CAN-DO(cfg-environment, p_mode).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-devCheck) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION devCheck Procedure 
FUNCTION devCheck RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  To check for development mode for security
    Notes:  
------------------------------------------------------------------------------*/
  RETURN WEB-CONTEXT:GET-CONFIG-VALUE("srvrAppMode":U) BEGINS "Dev".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-config) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION get-config Procedure 
FUNCTION get-config RETURNS CHARACTER
  ( INPUT cVarName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN WEB-CONTEXT:GET-CONFIG-VALUE(cVarName).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAgentSetting) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAgentSetting Procedure 
FUNCTION getAgentSetting RETURNS CHARACTER
  (cInKey  AS CHARACTER,
   cInSub  AS CHARACTER,
   cInName AS CHARACTER):
/*------------------------------------------------------------------------------
  Purpose:  Used to get the value of a Name/Value key out of the user-specified 
            agent setting temp-table.
   Inputs:  cInKey: key name that the name/value is specified under
            cInSub: sub-key, provides for sub-type orginization. Not required
            cInName: name of 'variable' that is being requested
  Returns:  Value or "" if not available
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cRetVal AS CHARACTER NO-UNDO.
   
  FIND ttAgentSetting WHERE
       ttAgentSetting.cKey  EQ cInKey AND
       ttAgentSetting.cSub  EQ cInSub AND
       ttAgentSetting.cName BEGINS cInName NO-ERROR.

  ASSIGN cRetVal = (IF AVAILABLE ttAgentSetting THEN ttAgentSetting.cVal ELSE "").

  RETURN cRetVal.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-logNote) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION logNote Procedure 
FUNCTION logNote RETURNS LOGICAL
  ( INPUT pcLogType AS CHARACTER,
    INPUT pcLogText AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Will not cause errors if called and logging not configured  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN FALSE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-output-content-type) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION output-content-type Procedure 
FUNCTION output-content-type RETURNS LOGICAL
  ( INPUT p_type AS CHARACTER ) :
/****************************************************************************
Function: output-content-type
Description: Sets and outputs the MIME Content-Type header followed by a
  blank line.  If the header was already output, no action is taken.
****************************************************************************/
   DEFINE VARIABLE cMimeCharset AS CHARACTER  NO-UNDO.
   
   IF output-content-type EQ "" THEN DO:
      ASSIGN 
        output-content-type = (IF p_type = "" THEN ? ELSE p_type).
      
      &IF KEYWORD-ALL("HTML-CHARSET") <> ? &THEN  
      /* Add MIME codepage, if available. */
      IF output-content-type BEGINS TRIM("text/html":U) 
         AND INDEX(output-content-type, "charset":U) = 0
         AND WEB-CONTEXT:HTML-CHARSET <> "" THEN DO:
         RUN adecomm/convcp.p ( WEB-CONTEXT:HTML-CHARSET, "toMime":U,
                                OUTPUT cMimeCharset ) NO-ERROR.
         IF cMimeCharset <> "" THEN
            output-content-type = output-content-type + "; charset=":U + 
                                  cMimeCharset.
      END.
      &ENDIF
      
      IF output-content-type NE ? THEN
         output-http-header ("Content-Type":U, output-content-type).
    
      /* This is required as a 'delimiter' for the header information */
      output-http-header ("", "").  /* blank line */

      /* If output-content-type is not ?, then a Content-Type header was output so return TRUE. */
      RETURN (output-content-type NE ?).
   END. /* output-content-type eq "" */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAgentSetting) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAgentSetting Procedure 
FUNCTION setAgentSetting RETURNS LOGICAL
  (cInKey  AS CHARACTER,
   cInSub  AS CHARACTER,
   cInName AS CHARACTER,
   cInVal  AS CHARACTER):
/*------------------------------------------------------------------------------
  Purpose:  Used to set the value of a Name/Value key to the user-specified 
            agent setting temp-table.
   Inputs:  cInKey: key name that the name/value is specified under
            cInSub: sub-key, provides for sub-type orginization. Not required
            cInName: name of 'variable' that is being requested
            cInVal: value that the 'variable' is to be set to
  Returns:  Logical ERROR-STATUS:ERROR
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE retVal AS LOGICAL NO-UNDO.

  SettingBLOCK:
  DO ON ERROR UNDO SettingBlock, LEAVE SettingBlock:
    FIND ttAgentSetting WHERE
      ttAgentSetting.cKey  EQ cInKey  AND
      ttAgentSetting.cSub  EQ cInSub  AND
      ttAgentSetting.cName EQ cInName EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE ttAgentSetting THEN DO:
      CREATE ttAgentSetting.
      ASSIGN 
        ttAgentSetting.cKey  = cInKey
        ttAgentSetting.cSub  = cInSub
        ttAgentSetting.cName = cInName NO-ERROR.
    END. /* name/value not available */
   
    ASSIGN ttAgentSetting.cVal = cInVal.
    RELEASE ttAgentSetting.
    ASSIGN retVal = ERROR-STATUS:ERROR. 
  END. /* SettingBlock */

  RETURN retVal.

END FUNCTION. /* setValue */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-showErrorScreen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION showErrorScreen Procedure 
FUNCTION showErrorScreen RETURNS LOGICAL
  ( INPUT cErrorMsg AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iCntr   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cTxt    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lRetVal AS LOGICAL    NO-UNDO.

  /* Check to see if there are any errors. If so, output them one by one. */
  IF ERROR-STATUS:ERROR             AND 
    ERROR-STATUS:NUM-MESSAGES GT 0 THEN DO:
    ASSIGN cErrorMsg = cErrorMsg + "~n<br><H1>Error Messages</H1>~n~n".

    DO iCntr = 1 TO ERROR-STATUS:NUM-MESSAGES:
      ASSIGN cErrorMsg = cErrorMsg +
                         "<P>":U + html-encode(ERROR-STATUS:GET-MESSAGE(iCntr)) + 
                         "</P>~n":U NO-ERROR.
      DYNAMIC-FUNCTION ("LogNote":U IN web-utilities-hdl, "Note":U,
                        STRING (" " + ERROR-STATUS:GET-MESSAGE(iCntr) + "")).
    END. /* DO cntr... */
  END. /* IF...NUM-MESSAGES > 0 */
    
  /* Custom error file... this should be enhanced to handle specific errors
     such as database connectivity, redirects, run-time problems,  access denial
     and other similar things.  This would mean another input parameter would
     need to be added for error type. */
  ASSIGN FILE-INFO:FILE-NAME = 
    SEARCH(getAgentSetting("Misc":U, "":U, "ErrorProc":U)) NO-ERROR.
    
  IF FILE-INFO:FULL-PATHNAME NE ? THEN 
    RUN VALUE(FILE-INFO:FULL-PATHNAME)(cErrorMsg) NO-ERROR.
  ELSE DO:
    DYNAMIC-FUNCTION("output-content-type" IN web-utilities-hdl,"text/html").
    {&OUT} "<BR>" cErrorMsg "<BR>".
  END.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-trueRandom) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION trueRandom Procedure 
FUNCTION trueRandom RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN STRING(RANDOM(1000,9999))             +
         ENTRY(3,WEB-CONTEXT:EXCLUSIVE-ID,":") + 
         ENTRY(4,WEB-CONTEXT:EXCLUSIVE-ID,":").

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-webCompile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION webCompile Procedure 
FUNCTION webCompile RETURNS CHARACTER
  ( INPUT cFile     AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Compile one file
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE object-type AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cTempFile   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cReturn     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE ix          AS INTEGER    NO-UNDO.
  
  IF cFile MATCHES "*.html" OR cFile MATCHES "*.htm" THEN DO:
    RUN webutil/e4gl-gen.p (SEARCH(cFile), INPUT-OUTPUT object-type, 
                            INPUT-OUTPUT cTempFile) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN 
      RETURN ERROR-STATUS:GET-MESSAGE(1).
  END.
  ELSE 
    cTempFile = cFile.
  
  IF cfg-compile-xcode > "" THEN DO:
    COMPILE VALUE(cTempFile) SAVE XCODE cfg-compile-xcode NO-ERROR.
    DYNAMIC-FUNCTION ("logNote":U IN web-utilities-hdl, "COMPILE":U,
                                  "XCode Compile:" + cFile) NO-ERROR.
  END.                                
  ELSE DO: 
    DYNAMIC-FUNCTION ("logNote":U IN web-utilities-hdl, "COMPILE":U,
                                  "CompileOnFly:" + cFile) NO-ERROR.
    COMPILE VALUE(cTempFile) SAVE NO-ERROR.
  END.
  IF ERROR-STATUS:NUM-MESSAGES > 0 THEN DO:
    cReturn = "<h1>Compile Error: " + cFile + "</h1>".
    DO ix = 1 TO ERROR-STATUS:NUM-MESSAGES:
      cReturn = cReturn + "<br>" + ERROR-STATUS:GET-MESSAGE(ix).
    END.
    DYNAMIC-FUNCTION ("logNote":U IN web-utilities-hdl, "COMPILE":U,
         "ERROR:" + ERROR-STATUS:GET-MESSAGE(ix)) NO-ERROR.
  END.
  ELSE DO: 
    cReturn = "OK".
    IF cTempFile > "" AND cTempFile <> cFile THEN
      OS-DELETE VALUE(cTempFile) NO-ERROR.
  END.
  RETURN cReturn.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

