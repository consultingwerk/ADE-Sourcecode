&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
    File        : ry/app/rywebspeed.p     (Webspeed Hook for Dynamics)
    Purpose     : Start the Dynamics persistent procedures and perform the
                  entry point for Dynamics web-requests
    Syntax      :
    Description :
    Updated     : 6/13/2002  Sunil S Belgaonkar
                  Initial version
    Notes       :

    History:
    --------


  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Pull in Dynamics global variables as NEW GLOBAL */
{af/sup2/afglobals.i NEW GLOBAL }
{af/sup/afghplipdf.i NEW GLOBAL}
{src/web2/wrap-cgi.i}


DEFINE NEW GLOBAL SHARED VARIABLE web-utilities-hdl AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE HTTP_COOKIE       AS char FORMAT "x(50)":U NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE SCRIPT_NAME       AS char FORMAT "x(50)":U NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE PATH_INFO         AS char FORMAT "x(50)":U NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE AppURL            AS char FORMAT "x(50)":U NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE AppProgram        AS char FORMAT "x(40)":U NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE debugging-enabled AS LOGICAL NO-UNDO INITIAL TRUE.

DEFINE VARIABLE ghRequestManager AS HANDLE NO-UNDO.    /* Handle Dynamics User Interface Manager */
DEFINE VAR hSessionBypass AS HANDLE.

&SCOPED-DEFINE DEBUG FALSE

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-createSessionID) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createSessionID Procedure 
FUNCTION createSessionID RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSessionId) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSessionId Procedure 
FUNCTION getSessionId RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

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
         HEIGHT             = 24.52
         WIDTH              = 51.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

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
  DEFINE VARIABLE htProperty    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE htService     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE htManager     AS HANDLE     NO-UNDO.

  IF CONNECTED("ICFDB":U) THEN
  DO:
    CREATE ALIAS AFDB           FOR DATABASE VALUE("ICFDB":U).
    CREATE ALIAS ASDB           FOR DATABASE VALUE("ICFDB":U).
    CREATE ALIAS RYDB           FOR DATABASE VALUE("ICFDB":U).
    CREATE ALIAS db_metaschema  FOR DATABASE VALUE("ICFDB":U).
    CREATE ALIAS db_index       FOR DATABASE VALUE("ICFDB":U).
  END.

  /* Now we need to retrieve from the database the appropriate session
     information for this session. */
  RUN obtainSessionTableHandles IN THIS-PROCEDURE /* actually in config file maneger */
    (OUTPUT htProperty,
     OUTPUT htService,
     OUTPUT htManager).

  RUN af/app/afsesstyperetr.p
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

&IF DEFINED(EXCLUDE-init-config) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE init-config Procedure 
PROCEDURE init-config :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
  RUN SUPER.
  DYNAMIC-FUNCTION("setAgentSetting" IN web-utilities-hdl, "Session":U,"","Cookie":U,"sessionid").
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-init-request) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE init-request Procedure 
PROCEDURE init-request :
/*------------------------------------------------------------------------------
  Purpose:     initializes session id for this request
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cCookie AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPath   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cField  AS CHARACTER  NO-UNDO.
  ASSIGN
    cCookie = DYNAMIC-FUNCTION ("get-cookie" IN web-utilities-hdl,"sessionid")
    cField  = DYNAMIC-FUNCTION ("get-field" IN web-utilities-hdl,"sessionid")
  .

  IF cField > "" THEN
  DO:
    gscSessionID = ENTRY(1,cField). /* Assuring NO DOUBLE entries */
    DYNAMIC-FUNCTION ("set-user-field" IN web-utilities-hdl,"sessionid",gscSessionID).
    RUN SUPER.
    RETURN "".
  END.
  ASSIGN
    gscSessionID = IF cCookie > "" THEN cCookie ELSE createSessionId()
    cPath = SUBSTRING(AppURL,1,R-INDEX(AppURL,"/") - 1).
  
  gscSessionID = ENTRY(1,gscSessionID). /* Assuring NO DOUBLE entries */
  
  DYNAMIC-FUNCTION ("set-user-field" IN web-utilities-hdl,"sessionid",gscSessionID).
  RUN SUPER.

  DYNAMIC-FUNCTION ("set-cookie" IN web-utilities-hdl,"sessionid",gscSessionID, ?, ?, cPath, ?, ?).

  RUN init-request IN ghRequestManager.

  RETURN "".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-init-session) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE init-session Procedure 
PROCEDURE init-session :
/*------------------------------------------------------------------------------
  Purpose:   This program will start up the Dynamics environment on startup.
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hProc     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cProc     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSupers   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cICFParam AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hLoopHandle AS HANDLE     NO-UNDO.

  hLoopHandle = SESSION:FIRST-PROCEDURE.
  DO WHILE VALID-HANDLE(hLoopHandle):
    IF R-INDEX(hLoopHandle:FILE-NAME,"afxmlcfgp.p":U) > 0
    OR R-INDEX(hLoopHandle:FILE-NAME,"afxmlcfgp.r":U) > 0
    THEN DO:
      hProc = hLoopHandle.
      hLoopHandle = ?.
    END.
    ELSE
      hLoopHandle = hLoopHandle:NEXT-SIBLING.
  END. /* VALID-HANDLE(hLoopHandle) */

  IF NOT VALID-HANDLE(hProc) THEN 
  DO:
    ASSIGN cProc = SEARCH("af/app/afxmlcfgp.r":U).
    IF cProc = ? THEN
      cProc = SEARCH("af/app/afxmlcfgp.p":U).

    IF cProc <> ? THEN
    DO:
      RUN VALUE(cProc) PERSISTENT SET hProc.
      
      /* Subscribe to all the relevant events in the configuration file manager */
      RUN subscribeAll IN THIS-PROCEDURE (hProc, THIS-PROCEDURE).
      
      /* Now we need to see if anyone has set anything in the properties */
      cICFParam = DYNAMIC-FUNCTION("getSessionParam" IN THIS-PROCEDURE,
                                "ICFPARAM":U) NO-ERROR.
      ERROR-STATUS:ERROR = NO.
      
      IF cICFParam = ? THEN
        cICFParam = "":U.
        
      RUN initializeSession IN THIS-PROCEDURE (cICFParam) NO-ERROR.
      IF RETURN-VALUE <> "":U THEN
      DO:
        MESSAGE "Unable to start the Progress Dynamics environment. " SKIP
                "The Configuration File Manager returned the following errors:":U SKIP 
                RETURN-VALUE.
        QUIT.
      END.
      
      /* Get the request manager handle */
      ghRequestManager = DYNAMIC-FUNCTION("getManagerHandle":U IN THIS-PROCEDURE,
                                           "RequestManager":U).

      IF NOT VALID-HANDLE(ghRequestManager) THEN
      DO:
        MESSAGE "Could not retrieve Request Manager handle.".
        QUIT.
      END.

      /* Initialize the session in request manager */
      RUN init-session IN ghRequestManager.
    END.
    ELSE
    DO:
      MESSAGE "af/app/afxmlcfgp can not be found.".
      QUIT.
    END.

  END. /* NOT VALID-HANDLE(hConfMan) */

  RUN SUPER.

  ASSIGN
    cSupers = DYNAMIC-FUNCTION("getSuperStack" in web-utilities-hdl)
    hSessionBypass = DYNAMIC-FUNCTION("getSuperHandle" in web-utilities-hdl,
        ENTRY(LOOKUP('web/objects/session.p',cSupers) - 1,cSupers)).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-run-web-object) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE run-web-object Procedure 
PROCEDURE run-web-object :
/*------------------------------------------------------------------------------
  Purpose:     Dynamics extension mapping hook
  Parameters:  pcFilename = (CHAR) Name of application file user is requesting
  Notes:       if this agent is in development and r code d oes not exist,
               then a compile on the requested html program will be attempted
               and the resulting r code will be run if possible
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcFilename     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i1                     AS INTEGER    NO-UNDO.

  /***** Extension mapping for dynamics *******/
  /*  IF SCRIPT_NAME matches "*icf":U THEN DO:  */
  /* User either PATH_INFO or SCRIPT_NAME - depending on whether using extension mapping or full explicit url */

  IF SCRIPT_NAME matches "*icf":U OR pcFilename matches "*icf" THEN
  DO:
    /* Allow execution of static pages (executed if they exist) */
    IF SCRIPT_NAME matches "*icf":U THEN
    DO:
      ASSIGN
        pcFilename  = SCRIPT_NAME
        SCRIPT_NAME = "/" + ENTRY(2,SCRIPT_NAME,"/")
        pcFilename  = REPLACE(pcFileName,SCRIPT_NAME + "/","")
        AppProgram  = pcFilename.
    END.

    pcFilename = REPLACE(pcFilename,".icf":U,"":U).
    IF ENTRY(NUM-ENTRIES(pcFilename,'/'),pcFilename,'/') = "login" THEN
    DO:
      IF DYNAMIC-FUNCTION ("get-value":U IN web-utilities-hdl, "do":U) > '' THEN
        pcFilename = "rylogin.icf".
      ELSE
        pcFilename = "ry/dhtml/rylogin".
    END.
    IF SEARCH('ry/' + ENTRY(1,pcFilename,'.') + '.r':U) <> ? OR SEARCH('ry/' + ENTRY(1,pcFilename,'.') + '.html':U) <> ? THEN 
      pcFilename = 'ry/' + pcFilename.
    IF SEARCH(ENTRY(1,pcFilename,'.') + '.r':U) <> ? OR SEARCH(ENTRY(1,pcFilename,'.') + '.html':U) <> ? THEN
    DO:
      appProgram = ENTRY(1,pcFilename,'.') + ".html":U.
      logNote("NOTE":U, "Static object found, now running it:":U + appProgram) NO-ERROR.
      /** Execute Request Manager **/
      RUN SUPER (appProgram).
    END. /* if a static file exits */
    ELSE
    DO:
      ASSIGN AppProgram = ENTRY(1,ENTRY(NUM-ENTRIES(AppProgram,'/'), AppProgram, '/'), '.').
      logNote("NOTE":U, "No static object found, running dynamic object '":U + AppProgram + "'") NO-ERROR.

      /* If not static page then call Process Request in Request Manager */
      RUN processRequest IN ghRequestManager (INPUT appProgram).
    END.
  END.  /* if .icf */
  ELSE
    RUN SUPER (pcFilename).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-createSessionID) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createSessionID Procedure 
FUNCTION createSessionID RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cRet AS CHARACTER  NO-UNDO.
  RUN ry/app/rysessnidp.p (OUTPUT cRet).
  ASSIGN
    cRet = cRet + substring(encode(string(random(1,1000)) + cRet),1,6).
  RETURN cRet.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSessionId) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSessionId Procedure 
FUNCTION getSessionId RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:
    Notes:
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cSessionid AS CHARACTER NO-UNDO.

  IF VALID-HANDLE(gshSessionManager) THEN
    RETURN gscSessionId.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

