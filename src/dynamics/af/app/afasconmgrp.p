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
/* Copyright (c) 2000-2006 by Progress Software Corporation.  All rights 
   reserved.  Prior versions of this work may contain portions 
   contributed by participants of Possenet.  */
/*---------------------------------------------------------------------------------
  File: afasconmgrp.p

  Description:  AppServer Service Type Manager

  Purpose:      AppServer Service Type Manager
                This procedure is the service type manager for AppServers.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   08/22/2001  Author:     

  Update Notes: Created from Template afsrvconmgrp.p

  (v:010001)    Task:    90000132   UserRef:    
                Date:   14/05/2001  Author:     Bruce Gruenbaum

  Update Notes: fixes

--------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afasconmgrp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Astra object identifying preprocessor */
&glob   AstraProcedure    yes

/* Connection Manager specific Preprocessors */
&SCOPED-DEFINE ServiceType    AppServer
&SCOPED-DEFINE RequiresHandle YES
/* &SCOPED-DEFINE ServiceTypeFields   */
/* &SCOPED-DEFINE ServiceTypeIndexes */

/* This tool replaces the AS-UTILS tool that was available in the 
     standard AppBuilder */
  {adecomm/appsrvtt.i "NEW GLOBAL"}

{adecomm/_adetool.i}

DEFINE VARIABLE hDynUser AS HANDLE     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-isConnected) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isConnected Procedure 
FUNCTION isConnected RETURNS LOGICAL
  ( INPUT pcServiceName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-parseConnectionParams) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD parseConnectionParams Procedure 
FUNCTION parseConnectionParams RETURNS CHARACTER
  (INPUT pcParams AS CHARACTER )  FORWARD.

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
         HEIGHT             = 23
         WIDTH              = 55.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{af/sup2/afsrvtype.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
ON CLOSE OF THIS-PROCEDURE
  RUN plipShutdown.

RUN initializeSelf.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-connectService) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE connectService Procedure 
PROCEDURE connectService :
/*------------------------------------------------------------------------------
  Purpose:     Connects a physical service for a given service name
  Parameters:  <none>
  Notes:       This procedure is a required entry point for the Connection
               Manager.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcServiceName AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcHandle      AS CHARACTER  NO-UNDO.

  RUN connectServiceWithParams( INPUT pcServiceName, 
                                INPUT "":U, 
                                INPUT "":U, 
                                OUTPUT pchandle).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-connectServiceWithParams) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE connectServiceWithParams Procedure 
PROCEDURE connectServiceWithParams :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcServiceName      AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcParameterList    AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcSubstitutionList AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcHandle           AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cConnectString        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUserName             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPassword             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lRunLocal             AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hServer               AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lAns                  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lDefault              AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cAppServerInfo        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSessionType          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPhysSessType         AS CHARACTER  NO-UNDO.
  define variable cPhysicalService      as character no-undo.
    
    /* Check whether there's a connection already made to the 
       actual AppServer (ie the physical service). If so, re-use
       the connection, while keeping the (logical) service name. */
    cPhysicalService = {fnarg getPhysicalService pcServiceName}.
    hServer = dynamic-function('findConnectedPhysicalService':u in target-procedure,
                               cPhysicalService, '':u /* service name not required */).
    
    /* We use this value regardless of whether we've reused the connection. */    
    lDefault = {fnarg isDefaultService pcServiceName}.
    
    if not valid-handle(hServer) then
    do:
      /* cAppServerInfo contains several parameters in a string. This string is passed
             as the AppServerInfo parameter in the connect method so that the as_connect.p
             procedure can parse these values out for use by the AppServer. */
    
      cPhysSessType  = DYNAMIC-FUNCTION("getPhysicalSessionType":U IN THIS-PROCEDURE).
      IF cPhysSessType = ? THEN
        cPhysSessType = "?":U.
    
      cAppServerInfo = "VER:2.1A":U + CHR(3) 
                     + cPhysSessType + CHR(3)
                     + SESSION:NUMERIC-SEPARATOR + CHR(3) 
                     + SESSION:NUMERIC-DECIMAL-POINT + CHR(3)
                     + SESSION:DATE-FORMAT + CHR(3)
                     + STRING(SESSION:YEAR-OFFSET) + CHR(3).
        
      cSessionType = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                      "ICFSESSTYPE":U).
    
      IF cSessionType = ? THEN
        cSessionType = "?":U.
    
      cAppServerInfo = cAppServerInfo + cSessionType + CHR(3).
           
      IF lDefault AND
         gscSessionID <> "":U AND
         gscSessionID <> ? THEN
        cAppServerInfo = cAppServerInfo + gscSessionID.
    
      {aficfcheck.i}    
    
      /* Get the connection parameters */
      cConnectString = DYNAMIC-FUNCTION("getConnectionString":U IN THIS-PROCEDURE,
                                        INPUT pcServiceName ).
      IF cConnectString = ? THEN
        RETURN "INVALID CONNECTION STRING":U.
    
      lRunLocal = cConnectString = "<LOCAL>":U.
    
      IF NOT lRunLocal THEN DO:
          /* Now append the parameter list to the connection string */
          IF ( pcParameterList > "":U ) THEN
            ASSIGN cConnectString = cConnectString + " ":U + pcParameterList.
    
          /* Now invoke the substitute param to substitute list */
          RUN substituteParams IN TARGET-PROCEDURE (INPUT cConnectString, 
                               INPUT pcSubstitutionList,
                               OUTPUT cConnectString).
    
          lRunLocal = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                     "run_local":U) = "YES":U.
      END.
    
      IF lRunLocal THEN
      DO:
        pcHandle = STRING(SESSION).
        DYNAMIC-FUNCTION("setServiceHandle":U IN THIS-PROCEDURE, 
                         pcServiceName, pcHandle).
        RETURN.
      END.
    
      IF isConnected(pcServiceName) THEN
        RUN disconnectService (pcServiceName).
    
      /* Connect to the AppServer with a generated user name and password */
      cUserName = DYNAMIC-FUNCTION("generateUserName":U IN hDynUser).
      cPassword = DYNAMIC-FUNCTION("createPassword":U IN hDynUser, cUserName).
    
      /* Now create the server and connect it */
      CREATE SERVER hServer.
      lAns = hServer:CONNECT(cConnectString,cUserName,cPassword,cAppServerInfo) NO-ERROR.
    
      IF ERROR-STATUS:ERROR OR
         ERROR-STATUS:NUM-MESSAGES <> 0 OR
         lAns <> YES THEN
        RETURN DYNAMIC-FUNCTION('buildErrorList':U IN THIS-PROCEDURE).
    end.    /* Re-usable connection */
        
  pcHandle = STRING(hServer).

  DYNAMIC-FUNCTION('setServiceHandle':U IN THIS-PROCEDURE,
                    INPUT pcServiceName,
                    INPUT pcHandle). 

  IF lDefault = YES THEN
  DO:
    gshAstraAppServer = hServer.
    gscSessionID = hServer:CLIENT-CONNECTION-ID.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-disconnectService) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disconnectService Procedure 
PROCEDURE disconnectService :
/*------------------------------------------------------------------------------
  Purpose:     This procedure is responsible for disconnecting a
               physical service.
  Parameters:  <none>
  Notes:       This procedure is a required entry point for the Connection
               Manager.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcServiceName AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hServer  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lAns     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lDefault AS LOGICAL    NO-UNDO.
    define variable hOtherServer            as handle no-undo.  
    define variable cPhysicalService        as character no-undo.

  /* Get the handle to the AppServer */
  hServer = WIDGET-HANDLE(DYNAMIC-FUNCTION('getServiceHandle':U IN THIS-PROCEDURE,
                                              INPUT pcServiceName)).
    
  IF NOT VALID-HANDLE(hServer) OR
     hServer = SESSION:HANDLE THEN
    RETURN.

    /* Look for another logical connection using this physical
       connection. */
    cPhysicalService = {fnarg getPhysicalService pcServiceName}.
    hOtherServer = dynamic-function('findConnectedPhysicalService':u in target-procedure,
                                    cPhysicalService, pcServiceName).
    
  lDefault = DYNAMIC-FUNCTION("isDefaultService":U IN THIS-PROCEDURE,
                          INPUT pcServiceName ).
    
    /* Only delete the service if there's no connection sharing going on.
       If there's another logical service using this physical service, then 
       don't delete the physical service. */
    if hServer ne hOtherServer then
    do:
        IF hServer:CONNECTED() THEN
            hServer:DISCONNECT().
        DELETE OBJECT hServer.
    end.    /* there's another service on this connection */
      
  DYNAMIC-FUNCTION('setServiceHandle':U IN THIS-PROCEDURE,
                   INPUT pcServiceName,
                   INPUT ?). 

  IF lDefault = YES THEN
    gshAstraAppServer = ?.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeSelf) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeSelf Procedure 
PROCEDURE initializeSelf :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  /* Get the handle to af/app/afddo.p - ICF is not running so we can't get this
     from the Session manager. The function "getProcedureHandle" lives in the
     Configuration File Manager which is a SESSION super procedure */
  RUN startProcedure IN THIS-PROCEDURE ("ONCE|af/app/afdynuser.p":U, OUTPUT hDynUser) NO-ERROR.

  /* If the handle to hDynUser is invalid, then start it. */
  IF NOT VALID-HANDLE(hDynUser) THEN
    RUN "af/app/afdynuser.p":U PERSISTENT SET hDynUser.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipShutdown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipShutdown Procedure 
PROCEDURE plipShutdown :
/*------------------------------------------------------------------------------
  Purpose:     Cleans up the AppServer connections when the AppServer
               Manager is shut down.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE BUFFER bttService FOR ttService.

  FOR EACH bttService:
    RUN disconnectService(bttService.cServiceName).
  END.

  EMPTY TEMP-TABLE AppSrv-TT.
  
  gshAstraAppServer = ?.

  IF NOT VALID-HANDLE(hDynUser) THEN
    DELETE OBJECT hDynUser.

  DELETE OBJECT THIS-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-reconnectService) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE reconnectService Procedure 
PROCEDURE reconnectService :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcServiceName AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcHandle      AS CHARACTER  NO-UNDO.

  /* Clean up the old handle */
  RUN disconnectService (pcServiceName).

  /* Connect the service again */
  RUN connectService (pcServiceName, OUTPUT pcHandle).



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-registerService) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE registerService Procedure 
PROCEDURE registerService :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER phServiceBuff AS HANDLE NO-UNDO.
  DEFINE VARIABLE cParseConnect AS CHARACTER  NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER(INPUT phServiceBuff).

  IF AVAILABLE(ttService) THEN
  DO:
    ASSIGN cParseConnect = parseConnectionParams(ttService.cConnectParams).
    FIND AppSrv-TT
         WHERE AppSrv-TT.partition = ttService.cServiceName
         NO-ERROR.

    IF NOT AVAILABLE AppSrv-TT 
    THEN DO:
        CREATE AppSrv-TT.
        ASSIGN AppSrv-TT.partition = ttService.cServiceName.
    END.
    ASSIGN AppSrv-TT.Configuration = NOT (cParseConnect = "<LOCAL>":U).
  END.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-security_prompt) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE security_prompt Procedure 
PROCEDURE security_prompt :
/*------------------------------------------------------------------------------
  Purpose:     This is a procedure that was called in the as-utils.
               This is here for backward compatibility.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER lCancel AS LOGICAL              NO-UNDO.

  lCancel = FALSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-isConnected) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isConnected Procedure 
FUNCTION isConnected RETURNS LOGICAL
  ( INPUT pcServiceName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Determines whether the requested service type is connected.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lAns    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hServer AS HANDLE     NO-UNDO.
  /* Get the handle to the AppServer */
  hServer = WIDGET-HANDLE(DYNAMIC-FUNCTION('getServiceHandle':U IN THIS-PROCEDURE,
                                              INPUT pcServiceName)).
  IF VALID-HANDLE(hServer) THEN 
  DO:
    IF hServer = SESSION:HANDLE THEN
      lAns = YES.
    ELSE
      lAns = hServer:CONNECTED().
  END.

  RETURN lAns.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-parseConnectionParams) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION parseConnectionParams Procedure 
FUNCTION parseConnectionParams RETURNS CHARACTER
  (INPUT pcParams AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Parses pcParams and returns the connection string.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cConnectString AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMode          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cString1       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cString2       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cClientType    AS CHARACTER  NO-UNDO.
  
  /* Parse the string to determine what parameters to use */
  cMode = ENTRY(1,pcParams,CHR(3)).

  IF NUM-ENTRIES(pcParams,CHR(3)) > 1 THEN
    cString1 = ENTRY(2,pcParams,CHR(3)).

  IF NUM-ENTRIES(pcParams,CHR(3)) > 2 THEN
    cString2 = ENTRY(3,pcParams,CHR(3)).

  CASE cMode:
    WHEN "R":U OR
    WHEN "U":U THEN
      cConnectString = cString1.
    WHEN "D":U THEN
    DO:
      cClientType = DYNAMIC-FUNCTION("getPhysicalSessionType":U IN THIS-PROCEDURE).
      IF cClientType = "WBC":U THEN
        cConnectString = cString2.
      ELSE
        cConnectString = cString1.
    END.
    OTHERWISE
      cConnectString = "<LOCAL>":U.
  END.

  RETURN cConnectString.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

