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
  File: afxmlcfgp.p

  Description:  XML Configuration File Manager

  Purpose:      XML Configuration File Manager

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:    90000023   UserRef:    
                Date:   20/03/2001  Author:     Bruce Gruenbaum

  Update Notes: Created from Template rytemprocp.p

  (v:010001)    Task:    90000017   UserRef:    
                Date:   01/04/2001  Author:     Bruce Gruenbaum

  Update Notes: Check out to create procedure

  (v:010002)    Task:          22   UserRef:    
                Date:   03/02/2003  Author:     Thomas Hansen

  Update Notes: Issue 8778:
                Added getSessionRootDirectory function to get the root directory in the following order:
                _scm_root_directory
                _framework_root_directory
                _start_in-directory
                SESSION:TEMP-DIR
                
                Also added getComponentRootDirectory to get the root directory for the following components:
                AB
                framework
                SCM
                "" - returns getSessionrootDirectory

  (v:010003)    Task:    90000132   UserRef:    
                Date:   14/05/2001  Author:     Bruce Gruenbaum

  Update Notes: XML configuration manager
  
  (v:010004)    Task:       
                Date:   12/06/2002  Author:     Bruce Gruenbaum

  Update Notes: Improved support for integration with RoundTable.
                Made program into a plip.


------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afxmlcfgp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.
ASSIGN
  cObjectName = "{&object-name}":U.

/* Astra object identifying preprocessor */
&glob   AstraProcedure    yes

/* The following variable is cut and pasted from the Progress standard adecomm/appserv.i
   file. The variable contains the handle to AppServer Utility procedure in the
   standard Progress code (as-utils.w) but we need to be able to completely
   replace that API here so we define the global variable at this point and 
   assume that the configuration file will have a setting that will change it */
DEFINE NEW GLOBAL SHARED VARIABLE appSrvUtils AS HANDLE                NO-UNDO.

/* This variable, global to this procedure, determines whether the ICF session
   has been properly established. It is set using setICFIsRunning and its value
   can be retrieved from anywhere using a dynamic function call to isICFRunning */
DEFINE VARIABLE glICFIsRunning        AS LOGICAL INITIAL ? NO-UNDO.
DEFINE VARIABLE glProfiler            AS LOGICAL           NO-UNDO.
DEFINE VARIABLE ghCFGParser           AS HANDLE            NO-UNDO.
DEFINE VARIABLE ghConnManager         AS HANDLE     NO-UNDO.
DEFINE VARIABLE gcStartupManagerList  AS CHARACTER  NO-UNDO.


/* The global variables that are used by the existing ICF framework are
   included so that they can be manually set as well. */
{src/adm2/globals.i}

/* The following include brings in the temp-tables that we need to parse
   the XML file */
&GLOBAL-DEFINE defineTTParam YES
{af/sup2/afxmlcfgtt.i}
&UNDEFINE defineTTParam

/* The following include contains the replaceCtrlChar function */
{af/sup2/afxmlreplctrl.i}

/* The following include contains the manipulation of the ttNode table */
{af/sup2/afttnode.i}

/* The AppBuilder should not remove this procedure */
{adecomm/_adetool.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-buildErrorList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD buildErrorList Procedure 
FUNCTION buildErrorList RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-detectFileType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD detectFileType Procedure 
FUNCTION detectFileType RETURNS CHARACTER
  ( INPUT pcFileName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-expandTokens) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD expandTokens Procedure 
FUNCTION expandTokens RETURNS CHARACTER
  ( INPUT pcString AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD findFile Procedure 
FUNCTION findFile RETURNS CHARACTER
  ( INPUT pcFileName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCodePath) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCodePath Procedure 
FUNCTION getCodePath RETURNS CHARACTER
  (INPUT pcFileName AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getComponentRootDirectory) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getComponentRootDirectory Procedure 
FUNCTION getComponentRootDirectory RETURNS CHARACTER
  ( pcComponent AS CHARACTER /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getExpandablePropertyValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getExpandablePropertyValue Procedure 
FUNCTION getExpandablePropertyValue RETURNS CHARACTER
  ( INPUT pcProperty AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getManagerHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getManagerHandle Procedure 
FUNCTION getManagerHandle RETURNS HANDLE
  ( INPUT pcManagerName AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPhysicalSessionType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPhysicalSessionType Procedure 
FUNCTION getPhysicalSessionType RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getProcedureHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getProcedureHandle Procedure 
FUNCTION getProcedureHandle RETURNS HANDLE
  (INPUT pcFileName AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSessionParam) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSessionParam Procedure 
FUNCTION getSessionParam RETURNS CHARACTER
  ( INPUT pcOption AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSessionRootDirectory) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSessionRootDirectory Procedure 
FUNCTION getSessionRootDirectory RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isConfigManRunning) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isConfigManRunning Procedure 
FUNCTION isConfigManRunning RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isICFRunning) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isICFRunning Procedure 
FUNCTION isICFRunning RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isProcedureRegistered) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isProcedureRegistered Procedure 
FUNCTION isProcedureRegistered RETURNS LOGICAL
  ( INPUT phHandle AS HANDLE)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setICFIsRunning) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setICFIsRunning Procedure 
FUNCTION setICFIsRunning RETURNS LOGICAL
  ( INPUT plRunning AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSessionParam) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSessionParam Procedure 
FUNCTION setSessionParam RETURNS LOGICAL
  ( INPUT pcOption AS CHARACTER,
    INPUT pcValue  AS CHARACTER  )  FORWARD.

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
         HEIGHT             = 27.67
         WIDTH              = 80.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */ 

{ry/app/ryplipmain.i}

/* We want to make this procedure a SESSION:SUPER-PROCEDURE for now. */
IF THIS-PROCEDURE:PERSISTENT THEN
  SESSION:ADD-SUPER-PROCEDURE(THIS-PROCEDURE).


ON "CTRL-ALT-SHIFT-S":U ANYWHERE
DO:
  IF getSessionParam("_debug_tools_on":U) = "YES":U THEN
    RUN af/cod2/afsessinfo.w PERSISTENT.
END.

ON "CTRL-ALT-SHIFT-C":U ANYWHERE
DO:
  IF getSessionParam("_debug_tools_on":U) = "YES":U 
  AND VALID-HANDLE(gshSessionManager) 
  THEN DO:
      DEFINE VARIABLE hContainerHandle AS HANDLE     NO-UNDO.
      DEFINE VARIABLE cProcedureType   AS CHARACTER  NO-UNDO.

      RUN launchContainer IN gshSessionManager (INPUT "cachefoldw":U,
                                                INPUT "":U,
                                                INPUT "cachefoldw":U,
                                                INPUT YES,
                                                INPUT "":U,
                                                INPUT "":U,
                                                INPUT "":U,
                                                INPUT "":U,
                                                INPUT ?,
                                                INPUT ?,
                                                INPUT ?,
                                                OUTPUT hContainerHandle,
                                                OUTPUT cProcedureType).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-cleanupSession) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cleanupSession Procedure 
PROCEDURE cleanupSession PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     This procedure cleans up any existing procedures and managers to
               restart them.
  Parameters:  <none>
  Notes:       
  ------------------------------------------------------------------------------*/

  EMPTY TEMP-TABLE ttParam.
  EMPTY TEMP-TABLE ttNode.
  EMPTY TEMP-TABLE ttProperty.
  EMPTY TEMP-TABLE ttService.
  EMPTY TEMP-TABLE ttManager.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeSession) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeSession Procedure 
PROCEDURE initializeSession :
/*------------------------------------------------------------------------------
  Purpose:     Controlling procedure that sets all the global environment
               settings.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcICFParam   AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hConfig             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hCurrManager        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cCurrSessType       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPhysSessTypes      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCurrPhysSessType   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValidOSList        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cConfig             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cLoginWindow        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hHandle             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cMode               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lOSUpdates          AS LOGICAL    NO-UNDO.

  DEFINE BUFFER bttProperty           FOR ttProperty.
  DEFINE BUFFER bttManager            FOR ttManager.
  DEFINE BUFFER bttParam              FOR ttParam.
  DEFINE BUFFER bttService            FOR ttService.
   
  SESSION:SET-WAIT-STATE("GENERAL":U).
  RUN startProcedure IN TARGET-PROCEDURE
    ("ONCE|af/sup2/afcfgprsrp.p":U, OUTPUT ghCFGParser).
  SESSION:SET-WAIT-STATE("":U).


  IF NOT VALID-HANDLE(ghCFGParser) THEN
    RETURN "ICFSTARTUPERR: UNABLE TO START CFG PARSER":U.

  /* What type of physical session are we? */
  cCurrPhysSessType = getPhysicalSessionType().

  /* If the physical session type comes back as blank, we
     don't know what session type this is, and we need to bail */
  IF cCurrPhysSessType = "":U THEN
    RETURN "ICFSTARTUPERR: UNRECOGNIZED PROGRESS 4GL CLIENT":U.

  /* If the pcICFParam parameter is specified, see if you can find an ICFCONFIG
     parameter. If not, tag the current value of ICFCONFIG onto the parameter 
     line if it is set. */
  IF pcICFParam <> "":U AND 
     pcICFParam <> ? AND
     INDEX(pcICFParam,"ICFCONFIG=":U) = 0 THEN
  DO:
    cConfig = getSessionParam("ICFCONFIG":U).
    IF cConfig <> ? AND 
       cConfig <> "":U THEN
      pcICFParam = pcICFParam + ",ICFCONFIG=":U + cConfig.
  END.

  /* Now we need to cleanup the existing session if there is one. */
  RUN cleanupSession.

  /* Get the session parameters from the command-line/env variable into the
     parameters temp-table. */ 
  RUN readParams(pcICFParam).

  /* By this point we should have a session type, so get its value */
  cCurrSessType = getSessionParam("ICFSESSTYPE":U).

  /* If the session type has not been set, we're hosed. Bail out */
  IF cCurrSessType = "":U OR
     cCurrSessType = ? THEN
    RETURN "ICFSTARTUPERR: SESSION TYPE NOT RECOGNIZED":U.

  SESSION:SET-WAIT-STATE("GENERAL":U).
  RUN readConfigFile IN ghCFGParser
      (getSessionParam("ICFCONFIG":U),
       cCurrSessType,
       YES,
       OUTPUT hConfig).
  SESSION:SET-WAIT-STATE("":U).
  
  IF RETURN-VALUE <> "":U AND
     RETURN-VALUE <> ? THEN
    RETURN RETURN-VALUE.

  RUN obtainCFGTables IN ghCFGParser
    (OUTPUT TABLE ttProperty,
     OUTPUT TABLE ttService,
     OUTPUT TABLE ttManager).

  RUN resetParser IN ghCFGParser.
  
  /* Now we need to run a procedure that will set up the system params
     that can be used as macros to expand the other properties */
  RUN setSystemParams.

  /* Now we need to copy the other properties to the ttParams */
  FOR EACH bttProperty:
    setSessionParam(bttProperty.cProperty,bttProperty.cValue).
  END.

  /* Now we need to figure out if this is a valid session type for this 
     environment. Get the list of supported physical session types */
  cPhysSessTypes = getSessionParam("physical_session_list":U).

  /* If the profiler is running we need to do regular run statements so we
     get debug listings. */
  glProfiler    = getSessionParam("_profiler_run":U) = "YES":U.

  /* If the physical session type is not supported in this Progress client,
     bail out. */
  IF cPhysSessTypes <> "":U AND
     cPhysSessTypes <> ? AND 
     NOT CAN-DO(cPhysSessTypes,cCurrPhysSessType) THEN
    RETURN "ICFSTARTUPERR: PHYSICAL SESSION NOT SUPPORTED BY SESSION TYPE":U.

  /* Now check that the OS list contains the current OS */
  cValidOsList = getSessionParam("valid_os_list":U).

  /* If the operating system is not supported in this Progress client,
     bail out. */
  IF cValidOsList <> "":U AND
     cValidOsList <> ? AND 
     NOT CAN-DO(cValidOsList,OPSYS) THEN
    RETURN "ICFSTARTUPERR: OPERATING SYSTEM NOT SUPPORTED BY SESSION TYPE":U.

  /* Set the manager handle for the configuration file manager in case
     there is code that needs to get the handle of the CFM. */
  RUN setConfigManagerHandle (cCurrSessType).

  /* Read the registry key list and it's values */
  IF OPSYS = "WIN32":U THEN
    RUN obtainRegistryKeys.

  /* Expand the properties that should be expanded */ 
  RUN propertyExpander.

  /* Now we set up all the SESSION attributes */
  RUN setSessionAttributes.

  /* If there was a RETURN-VALUE from the parse, we need to return it */
  IF RETURN-VALUE <> "":U THEN
    RETURN RETURN-VALUE.

  /* Publish ICFCM_Startup. This is here to allow the startup procedure to
     set the event handler for the configuration file manager. If one
     is set in the event procedure here, it will override the event handler
     that has already been set. If one is not set here, the default from
     the configuration file will be used. */
  PUBLISH "ICFCFM_Startup":U.
  IF RETURN-VALUE <> "":U AND 
   RETURN-VALUE <> ? THEN
  RETURN RETURN-VALUE.

  /* Now we need to start the event handler for the configuration file manager
     if there is one. */
  RUN startEventHandler("ICFEH_CFM":U).

  /* Publish the ICFCFM_ParametersSet event */
  PUBLISH "ICFCFM_ParametersSet":U.
  IF RETURN-VALUE <> "":U AND 
   RETURN-VALUE <> ? THEN
  RETURN RETURN-VALUE.

  /* Time to run the connection manager.
     Assume that the first procedure in the Managers list contains the 
     connection parameters for the connection manager. */
  DO FOR bttManager:
    FIND FIRST bttManager NO-LOCK 
      WHERE bttManager.cSessionType = cCurrSessType 
        AND bttManager.iOrder = 1 NO-ERROR.
    IF NOT AVAILABLE(bttManager) OR 
      bttManager.cManagerName <> "ConnectionManager":U THEN
      RETURN "ICFSTARTUPERR: CONNECTION MANAGER NOT SPECIFIED AS FIRST MANAGER":U.

    RUN startManager (bttManager.cManagerName, OUTPUT ghConnManager).
    IF RETURN-VALUE <> "":U THEN
      RETURN RETURN-VALUE.

    PUBLISH "ICFCFM_ConnectionManagerStarted":U.
    IF RETURN-VALUE <> "":U AND 
       RETURN-VALUE <> ? THEN
      RETURN RETURN-VALUE.

    /* Add this manager to the startup manager list so that we can skip it later.
       This is a LIFO list because we need to shut these things down in reverse
       order later. */
    gcStartupManagerList = STRING(ghConnManager).
  END.

  /* Assuming the connection manager started properly, we need to 
     start the individual service connection managers. */
  FOR EACH bttParam NO-LOCK
    WHERE bttParam.cOption BEGINS "ICFCM_":U:

    /* First start the manager */
    RUN startManager (bttParam.cValue, OUTPUT hCurrManager).
    IF RETURN-VALUE <> "":U THEN
      RETURN RETURN-VALUE.

    /* Now we need to register the manager with the connection
       manager for this specific type of service */
    IF NOT DYNAMIC-FUNCTION("setServiceTypeManager":U 
                             IN ghConnManager,
                             hCurrManager) THEN
      RETURN "ICFSTARTUPERR: UNABLE TO REGISTER MANAGER ":U + bttParam.cOption 
             + " = ":U + bttParam.cValue.

    PUBLISH "ICFCFM_ServiceTypeManagerStarted":U (INPUT bttParam.cValue).
    IF RETURN-VALUE <> "":U AND 
       RETURN-VALUE <> ? THEN
      RETURN RETURN-VALUE.


    /* Add this manager to the startup manager list so that we can skip it later.
       This is a LIFO list because we need to shut these things down in reverse
       order later. */
    gcStartupManagerList = STRING(hCurrManager) + ",":U
                         + gcStartupManagerList.
  END.


  /* Start any left over event handlers that have not yet been started */
  FOR EACH bttParam NO-LOCK
    WHERE bttParam.cOption BEGINS "ICFEH_":U:

    /* The startEventHandler procedure will ignore any events that have
       already been started.  */
    RUN startEventHandler(bttParam.cOption).

  END.

  /* Now we need to sequence the services so that all databases are started
     before the AppServers are connected */

  FOR EACH bttService 
    WHERE cSessionType = cCurrSessType:
    bttService.iStartOrder = ?.  /* Unknown sorts high */
  END.

  iCount = 0.
  FOR EACH bttService 
    WHERE cSessionType = cCurrSessType
      AND cServiceType = "Database":U
    BY cSessionType
    BY cServiceType
    BY iOrder:
    iCount = iCount + 1.
    bttService.iStartOrder = iCount.
  END.

  FOR EACH bttService 
    WHERE cSessionType = cCurrSessType
      AND cServiceType <> "Database":U
    BY cSessionType
    BY cServiceType
    BY iOrder:
    iCount = iCount + 1.
    bttService.iStartOrder = iCount.
  END.

  /* Now give the handle to the temp-table that contains the services
     that need to be started to the connection manager and let it 
     make connections to each service that requires a connection */
  PUBLISH "ICFCFM_InitializingServices":U.
  IF RETURN-VALUE <> "":U AND 
     RETURN-VALUE <> ? THEN
    RETURN RETURN-VALUE.
  
  RUN initializeServices IN ghConnManager
    (INPUT BUFFER ttService:HANDLE, 
     YES /* we want them connected */ ).

  IF RETURN-VALUE <> "":U THEN
    RETURN RETURN-VALUE.
  
  PUBLISH "ICFCFM_InitializedServices":U.
  IF RETURN-VALUE <> "":U AND 
     RETURN-VALUE <> ? THEN
    RETURN RETURN-VALUE.
  
  /* As we're now done with the ttProperty table, empty it */
  EMPTY TEMP-TABLE ttProperty.

  /* Now go through the list of managers that are in the
     the managers table and start all that do not yet have a handle set */
  FOR EACH bttManager NO-LOCK
    WHERE bttManager.cSessionType = cCurrSessType
      AND bttManager.hHandle = ?
    BY bttManager.cSessionType
    BY bttManager.hHandle
    BY bttManager.iOrder:
    
    PUBLISH "ICFCFM_StartingManager":U (INPUT bttManager.cManagerName).
    IF RETURN-VALUE <> "":U AND 
       RETURN-VALUE <> ? THEN
      RETURN RETURN-VALUE.

    RUN startManager (bttManager.cManagerName, OUTPUT hCurrManager).
    IF RETURN-VALUE <> "":U THEN
      RETURN RETURN-VALUE.

    PUBLISH "ICFCFM_StartedManager":U (INPUT bttManager.cManagerName).
    IF RETURN-VALUE <> "":U AND 
       RETURN-VALUE <> ? THEN
      RETURN RETURN-VALUE.

  END.

  PUBLISH "ICFCFM_ManagersStarted":U.
  IF RETURN-VALUE <> "":U THEN
    RETURN RETURN-VALUE.
  /* See if there are any outstanding database updates that still need to be
     run. */
  IF VALID-HANDLE(gshGenManager) THEN
  DO:
    lOSUpdates = DYNAMIC-FUNCTION("haveOutstandingUpdates":U IN gshGenManager).
    IF lOSUpdates = ? THEN
      lOSUpdates = NO.

    IF lOSUpdates AND
       (NOT CAN-DO("GUI,BTC",cCurrPhysSessType) OR
        NOT CONNECTED("ICFDB":U)) THEN
      RETURN "ICFSTARTUPERR: OUTSTANDING DATABASE UPDATES. PLEASE RUN GUI CLIENT CLIENT-SERVER OR BATCH DCU":U.
  END.


  /* Publish the ICFCFM_ConfigParsed event. This notifies any subscribers
     that the file has been parsed in and provides an opportunity to parse
     the XML file further if necessary before the XML handle is deleted.
     This needs to happen after the managers have been started so that
     the manager handles are all valid at this point */
  PUBLISH "ICFCFM_ConfigParsed":U (INPUT hConfig, INPUT cCurrSessType).
  IF RETURN-VALUE <> "":U AND 
     RETURN-VALUE <> ? THEN
    RETURN RETURN-VALUE.

  /* We're done with the XML file, so we delete the object */
  RUN releaseConfigDoc IN ghCFGParser
    (hConfig).
  
  /* Publish the login event */
  PUBLISH "ICFCFM_Login":U.
  IF RETURN-VALUE <> "":U AND 
     RETURN-VALUE <> ? THEN
    RETURN RETURN-VALUE.

  /* If we have updates to do, see if this is an admin user. If not,
     we need to jump out */
  IF lOSUpdates THEN
  DO:
    /* Publish an event that indicates that an upgrade is starting */
    PUBLISH "ICFCFM_UpgradeStart":U.
    IF RETURN-VALUE <> "":U AND 
       RETURN-VALUE <> ? THEN
      RETURN RETURN-VALUE.

    /* Do the upgrade */
    RUN startProcedure("install/prc/insessupdp.p":U, OUTPUT hHandle) NO-ERROR.
    IF ERROR-STATUS:ERROR OR
       (RETURN-VALUE <> "":U AND
        RETURN-VALUE <> ?) THEN
      RETURN RETURN-VALUE.
    
    /* Publish an event that indicates that an upgrade is complete */
    PUBLISH "ICFCFM_UpgradeComplete":U.
    IF RETURN-VALUE <> "":U AND 
       RETURN-VALUE <> ? THEN
      RETURN RETURN-VALUE.

  END.

  /* If the login is successful, then publish that fact. */
  PUBLISH "ICFCFM_LoginComplete":U.
  IF RETURN-VALUE NE "":U AND RETURN-VALUE NE ? THEN
      RETURN RETURN-VALUE.

  /* Finally, run each of the startup procedures that have been
     specified. Note that if any of them fail, we quit the session */
  FOR EACH bttParam 
    WHERE bttParam.cOption BEGINS "startup_procedure":U 
    BY bttParam.cOption:
    
    PUBLISH "ICFCFM_StartingProcedure":U (INPUT bttParam.cValue).
    IF RETURN-VALUE <> "":U AND 
       RETURN-VALUE <> ? THEN
      RETURN RETURN-VALUE.


    IF NUM-ENTRIES(bttParam.cValue, "|":U) > 1 THEN
      ASSIGN 
        cMode = ENTRY(1, bttParam.cValue, "|":U)
      .

    RUN startProcedure(bttParam.cValue, OUTPUT hHandle) NO-ERROR.

    IF ERROR-STATUS:ERROR OR 
       RETURN-VALUE <> "":U THEN
      RETURN "ICFSTARTUPERR: STARTUP PROCEDURE ":U + bttParam.cValue +
             " RETURNED ERROR " + RETURN-VALUE.

    IF cMode = "PERSIST":U OR
       cMode = "ADM2":U OR
       cMode = "ICFOBJ":U OR
       cMode = "ONCE":U THEN
    DO:
      setSessionParam("wait_for_required":U, "YES":U).
      setSessionParam("wait_for_proc":U, STRING(hHandle)).
    END.
    
    PUBLISH "ICFCFM_StartedProcedure":U (INPUT bttParam.cValue).
    IF RETURN-VALUE <> "":U AND 
       RETURN-VALUE <> ? THEN
      RETURN RETURN-VALUE.

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeWithChanges) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeWithChanges Procedure 
PROCEDURE initializeWithChanges :
/*------------------------------------------------------------------------------
  Purpose:     Revisit the temp-tables and make sure that anything that has 
               changes in it is reset at this point.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE BUFFER bttProperty FOR ttProperty.
  DEFINE BUFFER bttManager  FOR ttManager.
  DEFINE BUFFER bttService  FOR ttService.

  DEFINE VARIABLE cSessType AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount    AS INTEGER    NO-UNDO.

  cSessType = getSessionParam("ICFSESSTYPE":U).

  /* First reset all the properties */ 
  FOR EACH bttProperty:
    IF bttProperty.cSessionType = cSessType THEN
    DO:
      IF bttProperty.lDelete THEN
        setSessionParam(bttProperty.cProperty, ?).
      ELSE
        setSessionParam(bttProperty.cProperty, bttProperty.cValue).
    END.
    DELETE bttProperty.
  END.

  /* Read the registry key list and it's values */
  IF OPSYS = "WIN32":U THEN
    RUN obtainRegistryKeys.

  /* Expand the properties that should be expanded */ 
  RUN propertyExpander.

  /* Now we set up all the SESSION attributes */
  RUN setSessionAttributes.

  /* If there was a RETURN-VALUE from the parse, we need to return it */
  IF RETURN-VALUE <> "":U THEN
    RETURN RETURN-VALUE.

  /* Now we need to worry about the services. */

  /* Now we need to sequence the services so that all databases are started
     before the AppServers are connected */

  FOR EACH bttService 
    WHERE cSessionType = cSessType:
    IF bttService.lDelete OR 
       NOT bttService.lUpdated THEN
      DELETE bttService.
    ELSE
      bttService.iStartOrder = ?.  /* Unknown sorts high */
  END.

  iCount = 0.
  FOR EACH bttService 
    WHERE cSessionType = cSessType
      AND cServiceType = "Database":U
    BY cSessionType
    BY cServiceType
    BY iOrder:
    iCount = iCount + 1.
    bttService.iStartOrder = iCount.
  END.

  FOR EACH bttService 
    WHERE cSessionType = cSessType
      AND cServiceType <> "Database":U
    BY cSessionType
    BY cServiceType
    BY iOrder:
    iCount = iCount + 1.
    bttService.iStartOrder = iCount.
  END.

  /* Now give the handle to the temp-table that contains the services
     that need to be started to the connection manager and let it 
     make connections to each service that requires a connection */
  PUBLISH "ICFCFM_InitializingServices":U.
  IF RETURN-VALUE <> "":U AND 
     RETURN-VALUE <> ? THEN
    RETURN RETURN-VALUE.
  
  RUN initializeServices IN ghConnManager
    (INPUT BUFFER ttService:HANDLE, 
     YES /* we want them connected */ ).

  IF RETURN-VALUE <> "":U THEN
    RETURN RETURN-VALUE.

  /* Any managers that we don't need to run need to be removed. */
  FOR EACH bttManager 
    WHERE bttManager.lDelete = YES
      AND bttManager.hHandle = ?:
    DELETE bttManager.
  END. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-killPlip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE killPlip Procedure 
PROCEDURE killPlip PRIVATE :
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

&IF DEFINED(EXCLUDE-obtainCFMTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE obtainCFMTables Procedure 
PROCEDURE obtainCFMTables :
/*------------------------------------------------------------------------------
  Purpose:     Returns the handles to the temp-tables that the connection
               file manager has populated after the XML file has been read.
  Parameters:  <none>
  Notes:       This procedure deliberately does not return all the temp-tables 
               as some of them are working tables that should not have their 
               values displayed.
------------------------------------------------------------------------------*/

  DEFINE OUTPUT PARAMETER phParam    AS HANDLE     NO-UNDO.
  DEFINE OUTPUT PARAMETER phManager  AS HANDLE     NO-UNDO.

  ASSIGN
    phParam    = TEMP-TABLE ttParam:HANDLE
    phManager  = TEMP-TABLE ttManager:HANDLE
  .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtainRegistryKeys) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE obtainRegistryKeys Procedure 
PROCEDURE obtainRegistryKeys :
/*------------------------------------------------------------------------------
  Purpose:     This procedure parses the RegistryKeys property for the list
               of properties that contain registry keys that need to be loaded.
               It then parses each of those keys and loads the key values.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iCount       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cKeyList     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCurrKeyProp AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyString   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cBaseKey     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEnvironment AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSection     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKey         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cEntry       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cKeyValue    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProp        AS CHARACTER  NO-UNDO.

  /* Obtain a list of all the properties that contain registry keys */
  cKeyList = getSessionParam("registry_keys":U).

  /* Ignore the key list if it is blank. */
  IF cKeyList = "":U OR
     cKeyList = ? THEN 
    RETURN.

  /* Loop through those properties */
  REPEAT iCount = 1 TO NUM-ENTRIES(cKeyList):
    ASSIGN
      cCurrKeyProp  = ENTRY(iCount,cKeyList)
      cKeyString    = getSessionParam(cCurrKeyProp)
      cBaseKey      = "":U
      cEnvironment  = "":U
      cSection      = "":U
      cKey          = "":U
      .
    /* Set up the three strings that affect this. */
    DO iLoop = 1 TO NUM-ENTRIES(cKeyString,":":U):
      cEntry = ENTRY(iLoop,cKeyString,":":U).
      CASE iLoop:
        WHEN 1 THEN
          cBaseKey = cEntry.
        WHEN 2 THEN
          cEnvironment = cEntry.
        WHEN 3 THEN
          cSection = cEntry.
        WHEN 4 THEN
          cKey = cEntry.
      END CASE.
    END.
    ERROR-STATUS:ERROR = NO.

    /* Try and load the environment */
    IF cEnvironment <> "" THEN
    DO:
      IF cBaseKey <> "":U THEN
        LOAD cEnvironment BASE-KEY cBaseKey NO-ERROR.
      ELSE
        LOAD cEnvironment NO-ERROR.
    END.
    IF ERROR-STATUS:ERROR THEN
    DO:
      ERROR-STATUS:ERROR = NO.
      setSessionParam(cCurrKeyProp,"ERROR":U).
      NEXT.
    END.

    /* Now try and use the environment we loaded */
    USE cEnvironment NO-ERROR.                   
    IF ERROR-STATUS:ERROR THEN
    DO:
      IF cEnvironment <> "":U THEN
        UNLOAD cEnvironment.
      ERROR-STATUS:ERROR = NO.
      setSessionParam(cCurrKeyProp,"ERROR":U).
      NEXT.
    END.

    /* Now we get the key value */
    IF cSection <> "":U THEN
    DO:
      IF cKey = "DEFAULT":U THEN
        GET-KEY-VALUE SECTION cSection 
          KEY DEFAULT 
          VALUE cKeyValue.
      ELSE
        GET-KEY-VALUE SECTION cSection 
          KEY cKey 
          VALUE cKeyValue.
    END.
    IF ERROR-STATUS:ERROR THEN
    DO:
      IF cEnvironment <> "":U THEN
        UNLOAD cEnvironment.
      ERROR-STATUS:ERROR = NO.
      setSessionParam(cCurrKeyProp,"ERROR":U).
      NEXT.
    END.

    /* If the cKey field is "" or unknown, we get all the keys in that section */
    IF cKey = ? OR 
       cKey = "":U THEN
    DO:
      DO iLoop = 1 TO NUM-ENTRIES(cKey):
        GET-KEY-VALUE SECTION cSection
          KEY ENTRY(iLoop,cKey)
          VALUE cKeyValue.
        ASSIGN 
          cProp  = cBaseKey + "~\":U + cEnvironment + "~\":U + cSection + "~\":U + ENTRY(iLoop,cKey)
          .
        setSessionParam(cProp, cKeyValue).
      END.
    END.
    /* Otherwise we just set the key to what we got in */
    ELSE
    DO:
      ASSIGN 
        cProp  = cBaseKey + "~\":U + cEnvironment + "~\":U + cSection + "~\":U + cKey
        .
      setSessionParam(cProp, cKeyValue).
    END.
    IF cEnvironment <> "":U THEN
      UNLOAD cEnvironment.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtainSessionTableHandles) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE obtainSessionTableHandles Procedure 
PROCEDURE obtainSessionTableHandles :
/*------------------------------------------------------------------------------
  Purpose:     Returns the handles to the static temp-tables belonging to
               this session. 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER phtProperty AS HANDLE     NO-UNDO.
  DEFINE OUTPUT PARAMETER phtService  AS HANDLE     NO-UNDO.
  DEFINE OUTPUT PARAMETER phtManager  AS HANDLE     NO-UNDO.

  phtProperty = TEMP-TABLE ttProperty:HANDLE.
  phtService  = TEMP-TABLE ttService:HANDLE.
  phtManager  = TEMP-TABLE ttManager:HANDLE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipSetup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipSetup Procedure 
PROCEDURE plipSetup PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:    Run by main-block of PLIP at startup of PLIP
  Parameters: <none>
  Notes:       
------------------------------------------------------------------------------*/

  {ry/app/ryplipsetu.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipShutdown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipShutdown Procedure 
PROCEDURE plipShutdown PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will be run just before the calling program 
               terminates
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  {ry/app/ryplipshut.i}

  RUN sessionShutdown.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-propertyExpander) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE propertyExpander Procedure 
PROCEDURE propertyExpander :
/*------------------------------------------------------------------------------
  Purpose:     Expands all the properties in the expand list using the
               appropriate method.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cExpandList    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCount2        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cPropertyList  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cExpander      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cExpand        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPropertyValue AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProperty      AS CHARACTER  NO-UNDO.

  /* We need to know what order to expand the stuff in */
  cExpandList = getSessionParam("expand_list":U).

  /* Loop through all the properties in expand list */
  DO iCount = 1 TO NUM-ENTRIES(cExpandList):
    
    /* Obtain the current entry */
    cExpand = ENTRY(iCount,cExpandList).

    /* Get the property list to be expanded */
    cPropertyList = ENTRY(1,cExpand,"|":U).

    /* If there is a | sign, there is a special procedure to run to 
       expand the list */
    IF NUM-ENTRIES(cExpand,"|":U) > 1 THEN
    DO:
      cExpander = ENTRY(2,cExpand,"|":U).
      RUN VALUE(cExpander) IN THIS-PROCEDURE
        (cPropertyList).
    END.

    /* Otherwise just expand the list the normal way */
    ELSE  
    DO:
      DO iCount2 = 1 TO NUM-ENTRIES(cPropertyList):
        cProperty = ENTRY(iCount2,cPropertyList).
        cPropertyValue = getExpandablePropertyValue(cProperty).
        cPropertyValue = expandTokens(cPropertyValue).
        setSessionParam(cProperty,cPropertyValue).
      END.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-readParams) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE readParams Procedure 
PROCEDURE readParams PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     This procedure determines the source of the parameters for the
               session and parses them into the local temp-table.
  Parameters:  <none>
  Notes:       Session parameters could come from either -icfparam, -param,
               or ICFPARAM environment variable.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcICFParam  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cParam      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cOption     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCurrEntry  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDefault    AS CHARACTER  
    INITIAL "ICFCONFIG=icfconfig.xml,ICFSESSTYPE=Default":U
    NO-UNDO.

  /* If the ICF PARAM setting has been specified as an input parameter,
     use the input parameter */
  IF pcICFParam <> "":U THEN
    cParam = pcICFParam.

  /* Try and get the parameters from -icfparam */
  IF (cParam = "":U OR
      cParam = ?) AND
     CAN-QUERY(SESSION:HANDLE, "ICFPARAM":U) THEN
    cParam = SESSION:ICFPARAM.

  /* If cParam is not set, try get it from the ICFPARAM environment variable */
  IF cParam = "":U OR
     cParam = ? THEN
    cParam = OS-GETENV("ICFPARAM":U).

  /* If cParam still does not have a value, try and get the value from -param */
  IF cParam = "":U OR
     cParam = ? THEN
    cParam = SESSION:PARAM.

  /* To make sure that the required default settings are set, we prepend the 
     default settings onto the front of the cParam string. */

  cParam = cDefault + ",":U + cParam.

  /* Now loop through the cParam string. The string should be in the format
     option=value,option=value,option=value 
     Values cannot contain commas. */
  iter-block:
  DO iCount = 1 TO NUM-ENTRIES(cParam):
    cCurrEntry = ENTRY(iCount, cParam).

    /* If there are no = or more than one =, this is an invalid parameter,
       so ignore it. */
    IF NUM-ENTRIES(cCurrEntry,"=":U) <> 2 THEN
      NEXT iter-block.

    /* Set the option and value */
    cOption = ENTRY(1,cCurrEntry,"=":U).
    cValue  = ENTRY(2,cCurrEntry,"=":U).

    /* Set the option's value */
    setSessionParam(cOption,cValue).

  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-sessionShutdown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sessionShutdown Procedure 
PROCEDURE sessionShutdown :
/*------------------------------------------------------------------------------
  Purpose:     Cleans up the session and makes sure that all the managers are
               properly closed down. 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hConnManager AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hManager     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hProc        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hNext        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cPath        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFile        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSessionType AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount       AS INTEGER    NO-UNDO.
  DEFINE BUFFER bttManager FOR ttManager.

  PUBLISH "ICFCFM_StartSessionShutdown":U.

  cSessionType = getSessionParam("ICFSESSTYPE":U).

  /* We shut procedures in this order:                                            *
   * 1) Running Dynamics procedures. (deletePersistentProc IN gshSessionManager)  *
   * 2) ADM procedures               (deletePersistentProc IN gshSessionManager)  *
   * 3) Managers                                                                  */
  IF VALID-HANDLE(gshSessionManager) THEN
    RUN deletePersistentProc IN gshSessionManager.

  /* Now add the globals to the gcStartupManagerList */
  /* First shutdown the ICF managers */
  IF VALID-HANDLE(gshRIManager)           THEN 
    gcStartupManagerList = STRING(gshRIManager) + ",":U
                         + gcStartupManagerList.
  IF VALID-HANDLE(gshSessionManager)      THEN 
    gcStartupManagerList = STRING(gshSessionManager) + ",":U
                         + gcStartupManagerList.
  IF VALID-HANDLE(gshSecurityManager)     THEN 
    gcStartupManagerList = STRING(gshSecurityManager) + ",":U
                         + gcStartupManagerList.
  IF VALID-HANDLE(gshProfileManager)      THEN 
    gcStartupManagerList = STRING(gshProfileManager) + ",":U
                       + gcStartupManagerList.
  IF VALID-HANDLE(gshRepositoryManager)   THEN 
    gcStartupManagerList = STRING(gshRepositoryManager) + ",":U
                         + gcStartupManagerList.
  IF VALID-HANDLE(gshTranslationManager)  THEN 
    gcStartupManagerList = STRING(gshTranslationManager) + ",":U
                         + gcStartupManagerList.
  IF VALID-HANDLE(gshGenManager)          THEN 
    gcStartupManagerList = STRING(gshGenManager) + ",":U
                         + gcStartupManagerList.
  IF VALID-HANDLE(gshFinManager)          THEN 
    gcStartupManagerList = STRING(gshFinManager) + ",":U
                         + gcStartupManagerList.
  IF VALID-HANDLE(gshAgnManager)          THEN 
    gcStartupManagerList = STRING(gshAgnManager) + ",":U
                         + gcStartupManagerList.

  /* Now go through anything else that is left in the procedure handle table
     and try and shut it down. */

  FOR EACH bttManager
    WHERE bttManager.cSessionType = cSessionType
      AND bttManager.iOrder > 0
    BY iOrder DESCENDING:
    hManager = bttManager.hHandle.
    IF VALID-HANDLE(hManager) THEN
    DO:
      IF CAN-DO(gcStartupManagerList,STRING(hManager)) THEN
        NEXT.
      
      APPLY "CLOSE" TO hManager.
      IF VALID-HANDLE(hManager) THEN
      DO:

        IF CAN-DO(hManager:INTERNAL-ENTRIES,"plipShutdown":U) THEN
          RUN plipShutdown IN hManager.

        /* If it still doesn't work, DELETE PROCEDURE */
        IF VALID-HANDLE(hManager) THEN
          DELETE PROCEDURE hManager.
      END.
    END.
    DELETE bttManager.
  END.
  
  REPEAT iCount = 1 TO NUM-ENTRIES(gcStartupManagerList):
    hManager = WIDGET-HANDLE(ENTRY(iCount,gcStartupManagerList)).
    /* See if we can find any entry in the bttManager table with this
       handle */
    FIND FIRST bttManager 
      WHERE bttManager.cSessionType = cSessionType
        AND bttManager.hHandle      = hManager
      NO-ERROR.

    IF VALID-HANDLE(hManager) THEN
    DO:
      APPLY "CLOSE" TO hManager.
      IF VALID-HANDLE(hManager) THEN
      DO:
        IF CAN-DO(hManager:INTERNAL-ENTRIES,"plipShutdown":U) THEN
          RUN plipShutdown IN hManager.

        /* If it still doesn't work, DELETE PROCEDURE */
        IF VALID-HANDLE(hManager) THEN
          DELETE PROCEDURE hManager.
      END.
    END.
    
    /* If there is no bttManager record, return NO */
    IF AVAILABLE(bttManager) THEN
      DELETE bttManager.
  END.

  /* Now make sure that all the global handles are unknown */
  ASSIGN 
    gshAgnManager         = ?
    gshFinManager         = ?
    gshGenManager         = ?
    gshTranslationManager = ?
    gshRepositoryManager  = ?
    gshProfileManager     = ?
    gshSecurityManager    = ?
    gshSessionManager     = ?
    gshAstraAppserver     = ?
    ghConnManager         = ?
    .

  /* Nothing should be left in ttManager, but just in case. */ 
  FOR EACH bttManager
    WHERE bttManager.cSessionType = cSessionType
      AND bttManager.iOrder > 0
    BY iOrder DESCENDING:
    hManager = bttManager.hHandle.
    IF VALID-HANDLE(hManager) THEN
    DO:
      /* Try and APPLY CLOSE to this procedure */
      APPLY "CLOSE":U TO hManager.

      /* If the handle is still valid, apply close failed. Call plipShutdown */
      IF VALID-HANDLE(hManager) THEN
      DO:
        IF CAN-DO(hManager:INTERNAL-ENTRIES,"plipShutdown":U) THEN
          RUN plipShutdown IN hManager.

        /* If it still doesn't work, DELETE PROCEDURE */
        IF VALID-HANDLE(hManager) THEN
          DELETE PROCEDURE hManager.
      END.
    END.
    DELETE bttManager.
  END.

  /* For Roundtable's sake, make sure nothing is left */
  hProc = SESSION:FIRST-PROCEDURE.
  do-loop:
  DO WHILE VALID-HANDLE(hProc):
    /* Don't delete this procedure. It will get whacked when we exit this loop */
    IF hProc = THIS-PROCEDURE:HANDLE THEN
    DO:
      hProc = hProc:NEXT-SIBLING.
      NEXT do-loop.
    END.
  
    /* See if the filename starts with rtb. */
    cPath = REPLACE(hProc:FILE-NAME, "~\":U, "/":U).
    /* cFile = ENTRY(NUM-ENTRIES(cPath,"/":U),"/":U). */
    cPath = ENTRY(1,cPath,"/":U).
  
    /* If this is an RTB procedure, don't whack it */
    IF cPath = "rtb":U THEN
    DO:
      hProc = hProc:NEXT-SIBLING.
      NEXT do-loop.
    END.

    /* If this is an ADE procedure, don't whack it */
    IF CAN-DO(hProc:INTERNAL-ENTRIES, "ADEPersistent":U) THEN
    DO:
      hProc = hProc:NEXT-SIBLING.
      NEXT do-loop.
    END.

    /* Get the handle to the next sibling. */
    hNext = hProc:NEXT-SIBLING.
    /* Whack the procedure */
    DELETE PROCEDURE hProc.
    /* Set hProc */
    hProc = hNext.
  END.
  
  PUBLISH "ICFCFM_SessionShutdown":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setConfigManagerHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConfigManagerHandle Procedure 
PROCEDURE setConfigManagerHandle PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     This procedure simply writes a record the the ttManager table
               with the handle of THIS-PROCEDURE so that calls to 
               getManagerHandle using ConfigFileManager as the manager name
               will succeed.
               
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcSessType  AS CHARACTER  NO-UNDO.
  DEFINE BUFFER bttManager      FOR ttManager.

  DO TRANSACTION:
    FIND bttManager NO-LOCK 
      WHERE bttManager.cSessionType = pcSessType
        AND bttManager.iOrder = 0
      NO-ERROR.
    IF NOT AVAILABLE(bttManager) THEN
    DO:
      CREATE bttManager.
      ASSIGN 
        bttManager.cSessionType = pcSessType
        bttManager.iOrder       = 0
      .
    END.
    ASSIGN
        bttManager.cManagerName = "ConfigFileManager":U
        bttManager.cFileName    = THIS-PROCEDURE:FILE-NAME
        bttManager.cHandleName  = "NON"
        bttManager.hHandle      = THIS-PROCEDURE:HANDLE
        bttManager.iUniqueID    = THIS-PROCEDURE:UNIQUE-ID
      .
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSessionAttributes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setSessionAttributes Procedure 
PROCEDURE setSessionAttributes PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Parses the list of incoming parameters for session parameters 
               that need to set session attributes and sets the attributes 
               accordingly.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE BUFFER bttParam      FOR ttParam.
  DEFINE VARIABLE cAttribute  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPropath    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hCall       AS HANDLE     NO-UNDO.
  
  DEFINE VARIABLE cAttrs      AS CHARACTER  
    INITIAL "APPL-ALERT-BOXES,CONTEXT-HELP-FILE,DATA-ENTRY-RETURN,DATE-FORMAT,DEBUG-ALERT,IMMEDIATE-DISPLAY,MULTITASKING-INTERVAL,SUPPRESS-WARNINGS,SYSTEM-ALERT-BOXES,TIME-SOURCE,TOOLTIPS,V6DISPLAY,YEAR-OFFSET":U
    NO-UNDO.
  DEFINE VARIABLE cDataTypes  AS CHARACTER  
    INITIAL "LOGICAL,CHARACTER,LOGICAL,CHARACTER,LOGICAL,LOGICAL,INTEGER,LOGICAL,LOGICAL,CHARACTER,LOGICAL,LOGICAL,INTEGER":U
    NO-UNDO.
  
  /* Loop through all the properties that look like they may set session
     parameters */
  FOR EACH bttParam NO-LOCK
    WHERE bttParam.cOption BEGINS "session_":U:

    /* Make sure that we have something after the _ */
    IF LENGTH(bttParam.cOption) < 9 THEN
      NEXT.

    /* Take the piece after session_ and replace all its _ with - */ 
    cAttribute = REPLACE(SUBSTRING(bttParam.cOption,9),"_":U,"-":U).

    /* Treat PROPATH as a special case. It is not attached to the session
       handle, but it is useful to set it here */
    IF cAttribute = "PROPATH":U THEN
    DO:
      cPropath = REPLACE(bttParam.cValue,"$PROPATH":U,PROPATH).
      PROPATH = cPropath.
    END.

    /* We have to treat NUMERIC-FORMAT as a special case */
    IF cAttribute = "NUMERIC-FORMAT":U THEN
    DO:
      IF bttParam.cValue = "EUROPEAN":U OR 
         bttParam.cValue = "AMERICAN":U THEN
        SESSION:NUMERIC-FORMAT = bttParam.cValue.
      ELSE
      DO:
        IF LENGTH(bttParam.cValue) = 2 THEN
          SESSION:SET-NUMERIC-FORMAT(SUBSTRING(bttParam.cValue,1,1), SUBSTRING(bttParam.cValue,2,1)).
      END.
    END.

    IF CAN-DO(cAttrs, cAttribute) THEN
    DO:
      /* The rest of the attributes can be treated the same way */
      IF NOT VALID-HANDLE(hCall) THEN
        CREATE CALL hCall.
      ELSE
        hCall:CLEAR().

      ASSIGN
        hCall:CALL-TYPE = SET-ATTR-CALL-TYPE
        hCall:CALL-NAME = cAttribute
        hCall:IN-HANDLE = SESSION:HANDLE
        hCall:NUM-PARAMETERS = 1
      .

      hCall:SET-PARAMETER(1,ENTRY(LOOKUP(cAttribute,cAttrs),cDataTypes),"INPUT":U,bttParam.cValue).

      hCall:INVOKE no-error. 
    END.
  END.

  IF VALID-HANDLE(hCall) THEN
    DELETE OBJECT hCall.

  /* Now we need to make sure that we have all of these set as session parameters. The AppServer
     may need to check what it started with */
  
  setSessionParam("session_propath":U, PROPATH).
  setSessionParam("session_date_format":U, SESSION:DATE-FORMAT).
  setSessionParam("session_year_offset":U, STRING(SESSION:YEAR-OFFSET)).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSystemParams) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setSystemParams Procedure 
PROCEDURE setSystemParams :
/*------------------------------------------------------------------------------
  Purpose:     There are several system parameters that may be referenced
               in the configuration XML file macros. These have values that the
               environment automatically derives for the user. This is where
               those parameters get set.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cICFPath      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cPath         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cStartupPath  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cStartupProc  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDynamicsPath AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cStartIn      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cString       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEntry        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDirToDrop    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDropParam    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDirToAdd     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cAddParam     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDriveLetter  AS CHARACTER  NO-UNDO.

  cDirToDrop  = "/af/app,/icf,/dynamics,/gui,/src,/tty":U.
  cDropParam  = "_framework_directory,_framework_code_directory,_framework_code_directory,_framework_root_directory,_framework_root_directory,_framework_root_directory":U.
  cDirToAdd   = "/src,/gui,/tty":U.
  cAddParam   = "_framework_source_directory,_framework_gui_directory,_framework_tty_directory":U.

  /* Establish the full path to the _start_in and
     root_directory */
  FILE-INFO:FILE-NAME = ".":U.
  cStartIn = REPLACE(FILE-INFO:FULL-PATHNAME, "~\":U, "/":U).
  setSessionParam("_start_in_directory":U, cStartIn).
  setSessionParam("root_directory":U, cStartIn).

  /* First break ICFPATH into all its components. Now there will be 
     ICFPATH<n> session params where <n> is the entry number in the list. 
     We also add an ICFPATHn which contains the value of the last entry in 
     the path list. */
  cICFPath = getSessionParam("ICFPATH":U).
  IF cICFPath <> "":U THEN
  DO:
    DO iCount = 1 TO NUM-ENTRIES(cICFPath,";":U):
      cPath = ENTRY(iCount,cICFPath,";":U).
      setSessionParam("ICFPATH":U + STRING(iCount), cPath).
      IF iCount = NUM-ENTRIES(cICFPath,";":U) THEN
        setSessionParam("ICFPATHn":U, cPath).
    END.
  END.

  /* When running from RTB there are a number of peristent procedures in memory at the top 
     of the stack which should not be used as a reference for the _framework_directory. The 
     hard-coded exceptions in the code below caters for all knonw occurences of such procedures. 
  */
  
  iCount = 1.
  DO WHILE PROGRAM-NAME(iCount) <> ? AND 
           PROGRAM-NAME(iCount) <> "_rtb.r":U AND /* RTB Startup procedure*/
           PROGRAM-NAME(iCount) <> "rtbrun.p":U AND /* Procedure to launch objects from RTB */
           INDEX(REPLACE(PROGRAM-NAME(iCount), "~\":U, "~/":U), "/rtb_":U) = 0 AND /* Procedures like "D:\rtb91c\rtb\w\rtb_desk.w" */
           INDEX(REPLACE(PROGRAM-NAME(iCount), "~\":U, "~/":U), "/com.openedge.pdt":U) = 0 AND /* Procedures in OpenEdge Architect, in project plug-in. */
           SUBSTRING(PROGRAM-NAME(iCount), 1, 3) NE "ade":U: /* ADE procedures like adeuib/_desk.p */
       iCount = iCount + 1.   
  END.

  cStartupProc = PROGRAM-NAME(iCount - 1).  
  setSessionParam("_startup_proc":U, cStartupProc).

  /* Find the file that contains the startup procedure. */
  cStartupPath = SEARCH(cStartupProc).
  IF cStartupPath = ? THEN
    cStartupPath = SEARCH(THIS-PROCEDURE:FILE-NAME).

  /* Replace all the backslashes with forward slashes and get drop the
     file name off the end. */
  cStartupPath = REPLACE(cStartupPath, "~\":U, "/":U).
  iCount = R-INDEX(cStartupPath,"/":U).
  IF iCount > 0 THEN
    cStartupPath = SUBSTRING(cStartupPath,1,iCount - 1).
  ELSE
    cStartupPath = "":U.
  
  /* If the startup path is invalid at this point, we need to accept the
     startup procedure path. */
  IF cStartupPath = ? OR
     cStartupPath = "":U OR
     SUBSTRING(cStartupPath,1,1) = ".":U THEN
    cStartupPath = cStartIn.

  /* Set the framework drive letter from the path */
  IF LENGTH(cStartupPath) > 2 AND
     SUBSTRING(cStartupPath,2,2) = ":/":U THEN
  DO:
    cDriveLetter = SUBSTRING(cStartupPath,1,1).
    setSessionParam("_framework_drive_letter":U, cDriveLetter).
  END.
  ELSE
    setSessionParam("_framework_drive_letter":U, "":U).

  /* Whatever is left in cStartupPath now is the _framework_directory */
  setSessionParam("_framework_directory":U, cStartupPath).

  /* See if we can drop any of the directories in cDirToDrop off the path. */
  DO iCount = 1 TO NUM-ENTRIES(cDirToDrop):
    cEntry = ENTRY(iCount,cDirToDrop).
    IF LENGTH(cStartupPath) > LENGTH(cEntry) THEN
    DO:
      cString = SUBSTRING(cStartupPath,LENGTH(cStartupPath) - LENGTH(cEntry) + 1).
      IF cString = cEntry THEN
        cStartupPath = SUBSTRING(cStartupPath,1,LENGTH(cStartupPath) - LENGTH(cEntry)).
      setSessionParam(ENTRY(iCount,cDropParam), cStartupPath).
    END.
  END.

  /* Add back any of the additional directories */
  DO iCount = 1 TO NUM-ENTRIES(cDirToAdd):
    cEntry = ENTRY(iCount,cDirToAdd).
    cString = cStartupPath + cEntry.
    FILE-INFO:FILE-NAME = cString.
    IF FILE-INFO:FULL-PATHNAME <> ? THEN
      setSessionParam(ENTRY(iCount,cAddParam), cStartupPath + cEntry).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setupPaths) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setupPaths Procedure 
PROCEDURE setupPaths :
/*------------------------------------------------------------------------------
  Purpose:     This procedure establishes all the defaults for the paths.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcPathOrder AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cString     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iCount2     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cRawPath    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPath       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPathOrder  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cStripStart AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cStripEnd   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCurrPath   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iNoColon    AS INTEGER    NO-UNDO.


  cPathOrder = getSessionParam(pcPathOrder).


  /* Now we loop through the paths in the right order and handle them */
  DO iCount = 1 TO NUM-ENTRIES(cPathOrder):

    /* Get the current path value */
    cCurrPath = ENTRY(iCount, cPathOrder).

    cRawPath = getExpandablePropertyValue(cCurrPath).

    /* If the current path value is ?, there's nothing we can do with
       it except set it to "" to avoid making anything that depends
       on it ? */
    IF cRawPath = ? THEN
      cRawPath = "":U.
    
    /* Break the path into its components and expand the tokens */
    iNoColon = NUM-ENTRIES(cRawPath,"|":U).
    cPath = expandTokens(ENTRY(1,cRawPath,"|":U)).
    IF iNoColon > 1 THEN
      cStripStart = expandTokens(ENTRY(2,cRawPath,"|":U)).
    IF iNoColon > 2 THEN
      cStripEnd = expandTokens(ENTRY(3,cRawPath,"|":U)).

    /* Now strip off the front portion if there's anything to strip */
    IF cStripStart <> ? AND
       cStripStart <> "":U AND
       SUBSTRING(cPath,1,LENGTH(cStripStart)) = cStripStart THEN
      cPath = SUBSTRING(cPath,LENGTH(cPath) - LENGTH(cStripStart)).

    /* And strip off the back if there's anything to strip */
    IF cStripEnd <> ? AND
       cStripEnd <> "":U AND
       SUBSTRING(cPath,LENGTH(cPath) - LENGTH(cStripEnd) + 1) = cStripEnd THEN
      cPath = SUBSTRING(cPath,1,LENGTH(cPath) - LENGTH(cStripEnd)).

    setSessionParam(cCurrPath, cPath).

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-startEventHandler) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startEventHandler Procedure 
PROCEDURE startEventHandler :
/*------------------------------------------------------------------------------
  Purpose:     Starts the event handler for a particular event
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcEventHandler AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cEventProc    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hEventHandler AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cRetVal       AS CHARACTER  NO-UNDO.

  cEventProc = getSessionParam(pcEventHandler).

  IF cEventProc = ? THEN
    RETURN.

  IF NUM-ENTRIES(cEventProc,"|":U) < 2 THEN
    cEventProc = "ONCE|":U + cEventProc.

  RUN startProcedure (cEventProc, OUTPUT hEventHandler) NO-ERROR.
  IF RETURN-VALUE <> "":U AND
     RETURN-VALUE <> ? THEN
  DO:
    /* Build up a string that contains the error information */
    cRetVal = "EVENT HANDLER ":U + pcEventHandler + " - " + cEventProc + " FAILED TO LOAD.":U
            + CHR(10) + RETURN-VALUE.
    ERROR-STATUS:ERROR = NO.

    RETURN cRetVal.
  END. /* IF RETURN-VALUE <> "":U */
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-startManager) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startManager Procedure 
PROCEDURE startManager :
/*------------------------------------------------------------------------------
  Purpose:     Starts all the managers that need to be run prior to the
               start of the session manager. 
  Parameters:  
    pcManagerName = corresponds to a manager in the ttManager table.
    phManager     = returned handle to the started procedure.

  Notes:
    All the managers that are started using this procedure need to be 
    persistent and should not require any parameters. 

    It is possible that the ttManager table contains more than one entry
    for a specific file. For example, the Session Manager and Context Manager
    may be the same procedure. If that's the case we need to use the same
    instance of the procedure in both cases. 
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcManagerName AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER phManager     AS HANDLE     NO-UNDO.

  DEFINE BUFFER bttManager      FOR ttManager.
  DEFINE BUFFER b2ttManager     FOR ttManager.
  DEFINE VARIABLE cSessionType  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFileName     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRetVal       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hSuperOf AS HANDLE     NO-UNDO.

  DEFINE VARIABLE hManager      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cManagerFile  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSupers       AS CHARACTER  NO-UNDO.



  /* Figure out the current session type */
  cSessionType = getSessionParam("ICFSESSTYPE":U).

    FIND FIRST bttManager 
      WHERE bttManager.cSessionType = cSessionType
        AND bttManager.cManagerName = pcManagerName
      NO-ERROR.
    IF NOT AVAILABLE(bttManager) THEN
      RETURN "ICFSTARTUPERR: MANAGER NOT AVAILABLE":U.

    IF bttManager.cFileName = "":U OR
       bttManager.cFileName = ? THEN
    DO:
      DELETE bttManager.
      RETURN "":U.
    END.

    /* If the Manager already has a handle and the handle is valid
       just return the handle. */
    IF VALID-HANDLE(bttManager.hHandle) THEN
    DO:
      phManager = bttManager.hHandle.
      IF phManager:TYPE = "PROCEDURE":U AND
         phManager:UNIQUE-ID = bttManager.iUniqueID THEN
        RETURN.
      ELSE
        phManager = ?.
    END.


    /* Check to see if there is another procedure in the manager list
       with the same handle as this one. If so, set it. */
    FOR EACH b2ttManager 
      WHERE b2ttManager.cSessionType = cSessionType
        AND b2ttManager.cFileName = bttManager.cFileName:
      IF ROWID(b2ttManager) = ROWID(bttManager) THEN
        NEXT.
      IF VALID-HANDLE(b2ttManager.hHandle) THEN
      DO:
        phManager = b2ttManager.hHandle.
        /* If the handle is invalid then ignore it, otherwise use this handle */
        IF phManager:TYPE <> "PROCEDURE":U OR
           phManager:UNIQUE-ID <> b2ttManager.iUniqueID THEN
          phManager = ?.
        ELSE
          LEAVE.
      END.

    END.

    /* Only do this if we haven't started this manager yet */
    IF NOT VALID-HANDLE(phManager) THEN
    DO:
      cSupers = "":U.
      DO iCount = 1 TO NUM-ENTRIES(bttManager.cFileName, CHR(3)):
        cManagerFile = ENTRY(iCount,bttManager.cFileName, CHR(3)).
        hManager     = getProcedureHandle(cManagerFile).
        IF NOT VALID-HANDLE(hManager) THEN
        DO:
          RUN startProcedure("ONCE|":U + cManagerFile, OUTPUT hManager) NO-ERROR.
          IF RETURN-VALUE <> "":U AND
             RETURN-VALUE <> ? THEN
          DO:
            /* Build up a string that contains the error information */
            cRetVal = "PROCEDURE ":U + cManagerFile + " FAILED TO LOAD.":U
                    + CHR(10) + RETURN-VALUE.
            ERROR-STATUS:ERROR = NO.
          
            RETURN cRetVal.
          END. /* IF RETURN-VALUE <> "":U */
        END.
        IF iCount > 1 THEN
          cSupers = STRING(hManager) + MIN(cSupers,",":U)
                  + cSupers.
        ELSE
          phManager = hManager.
      END.
      DO iCount = 1 TO NUM-ENTRIES(cSupers):
        phManager:ADD-SUPER-PROCEDURE(WIDGET-HANDLE(ENTRY(iCount,cSupers)), SEARCH-TARGET).
      END.
    END. /* IF NOT VALID-HANDLE(phManager)...*/
  
    DO TRANSACTION:

      ASSIGN
        bttManager.hHandle = phManager
        bttManager.iUniqueID = phManager:UNIQUE-ID
        .

      IF bttManager.cHandleName = "":U THEN
        bttManager.cHandleName = "NON":U.
    END.

    /* The handle ties certain hardcoded global variables to certain
       handles. This CASE statement makes sure the appropriate handles
       are set. */
    CASE bttManager.cHandleName:
      WHEN "SM":U THEN
        gshSessionManager = phManager.
      WHEN "RI":U THEN
        gshRIManager = phManager.
      WHEN "SEM":U THEN
        gshSecurityManager = phManager.
      WHEN "PM":U THEN
        gshProfileManager = phManager.
      WHEN "RM":U THEN
        gshRepositoryManager = phManager.
      WHEN "TM":U THEN
        gshTranslationManager = phManager.
      WHEN "WM":U THEN
        gshWebManager = phManager.
      WHEN "FM":U THEN
        gshFinManager = phManager.
      WHEN "GM":U THEN
        gshGenManager = phManager.
      WHEN "AM":U THEN
        gshAgnManager = phManager.
      WHEN "AU":U THEN
        appSrvUtils = phManager.
    END CASE.

    /* Now we need to handle the SUPER case */
    IF bttManager.cSuperOf <> "":U AND
       bttManager.cSuperOf <> ? THEN
    DO:
      CASE bttManager.cSuperOf:
         WHEN "SESSION":U THEN
           SESSION:ADD-SUPER-PROCEDURE(phManager, SEARCH-TARGET).
         OTHERWISE
         DO:
           hSuperOf = getManagerHandle(bttManager.cSuperOf).
           IF VALID-HANDLE(hSuperOf) THEN
             hSuperOf:ADD-SUPER-PROCEDURE(phManager, SEARCH-TARGET).
         END.
      END CASE.
    END.

    /* Now we need to start the event handler for the manager
       if there is one. */
    RUN startEventHandler("ICFEH_":U + pcManagerName).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-startProcedure) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startProcedure Procedure 
PROCEDURE startProcedure :
/*------------------------------------------------------------------------------
  Purpose:     Determines the name of the procedure to start and how to start
               it.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcProcName AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER phHandle   AS HANDLE     NO-UNDO.

  DEFINE VARIABLE cMode        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cProcName    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFileName    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLogicalName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hProc        AS HANDLE     NO-UNDO.

  DEFINE VARIABLE lMultiInstance              AS LOGICAL      NO-UNDO.
  DEFINE VARIABLE cChildDataKey               AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cRunAttribute               AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE hContainerWindow            AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hContainerSource            AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hObject                     AS HANDLE       NO-UNDO.
  DEFINE VARIABLE hRunContainer               AS HANDLE       NO-UNDO.
  DEFINE VARIABLE cRunContainerType           AS CHARACTER    NO-UNDO.

  {aficfcheck.i}

  IF NUM-ENTRIES(pcProcName,"|":U) > 1 THEN
    ASSIGN 
      cMode = ENTRY(1,pcProcName,"|":U)
      cProcName = SUBSTRING(pcProcName, LENGTH(cMode) + 2)
    .
  ELSE
    ASSIGN
      cMode = "EXEC":U
      cProcName = pcProcName
    .

  IF cMode <> "ICFOBJ":U AND
     cMode <> "EVENT":U THEN
  DO:
    cFileName = getCodePath(cProcName).
    IF cFileName = ? THEN
      RETURN "UNKNOWN FILENAME ":U + cProcName.
  END.

  IF NOT lICFRunning AND
     SUBSTRING(cMode,1,3) = "ICF":U THEN
    RETURN "ATTEMPT TO START ICF PROCEDURE ":U + cProcName + " BEFORE ICF IS INITIALIZED":U.

  IF cMode = "ONCE":U THEN
  DO:
    hProc = getProcedureHandle(cFileName).
    IF VALID-HANDLE(hProc) THEN
    DO:
      phHandle = hProc.
      RETURN.
    END.
  END.

 
  CASE cMode:
    WHEN "PERSIST":U OR
    WHEN "ONCE":U OR
    WHEN "ADM2":U THEN
    DO:
      RUN VALUE(cFileName) PERSISTENT SET hProc NO-ERROR.
    END.
    WHEN "EXEC":U THEN
    DO:
      RUN VALUE(cFileName) NO-ERROR.
    END.
    WHEN "ICFOBJ":U THEN
    DO:

      IF cProcName = "":U
      THEN
        RETURN "Please specify the name of an object to run.: ":U.

      /* Run startup window if specified */
      IF cProcName <> "":U THEN
      RUN-BLOCK:
      DO ON STOP UNDO RUN-BLOCK, LEAVE RUN-BLOCK ON ERROR UNDO RUN-BLOCK, LEAVE RUN-BLOCK:

        ASSIGN
          lMultiInstance    = NO
          cChildDataKey     = "":U
          cRunAttribute     = "":U
          hContainerWindow  = ?
          hContainerSource  = ?
          hObject           = ?
          hContainerWindow  = ?
          cRunContainerType = "":U
          .

        IF NOT VALID-HANDLE(gshSessionManager) THEN
          RETURN "Session Manager is not running. Ensure the Progress Dynamics Application is running".

        IF VALID-HANDLE(gshSessionManager) THEN
        DO:
          RUN launchContainer IN gshSessionManager
                             (INPUT  cProcName            /* object filename if physical/logical names unknown */
                             ,INPUT  "":U                 /* physical object name (with path and extension) if known */
                             ,INPUT  cProcName            /* logical object name if applicable and known */
                             ,INPUT  (NOT lMultiInstance) /* run once only flag YES/NO */
                             ,INPUT  "":U                 /* instance attributes to pass to container */
                             ,INPUT  cChildDataKey        /* child data key if applicable */
                             ,INPUT  cRunAttribute        /* run attribute if required to post into container run */
                             ,INPUT  "":U                 /* container mode, e.g. modify, view, add or copy */
                             ,INPUT  hContainerWindow     /* parent (caller) window handle if known (container window handle) */
                             ,INPUT  hContainerSource     /* parent (caller) procedure handle if known (container procedure handle) */
                             ,INPUT  hObject              /* parent (caller) object handle if known (handle at end of toolbar link, e.g. browser) */
                             ,OUTPUT hRunContainer        /* procedure handle of object run/running */
                             ,OUTPUT cRunContainerType    /* procedure type (e.g ADM1, Astra1, ADM2, ICF, "") */
                             ).
          hProc = hRunContainer.
        END.
      END.

    END.
    WHEN "EVENT":U THEN
    DO:
      IF NUM-ENTRIES(cProcName,"|":U) > 1 THEN
        ASSIGN
          hProc = WIDGET-HANDLE(ENTRY(1,cProcName,"|":U))
          cProcName = SUBSTRING(cProcName,LENGTH(ENTRY(1,cProcName,"|":U)) + 2)
          
        .
      IF VALID-HANDLE(hProc) THEN
        PUBLISH cProcName FROM hProc.
      ELSE
        PUBLISH cProcName.
    END.
  END.

  IF ERROR-STATUS:ERROR OR
     (RETURN-VALUE <> "":U AND
      RETURN-VALUE <> ?) THEN 
    RETURN ERROR RETURN-VALUE + CHR(10) + buildErrorList().      

  IF cMode = "ADM2":U THEN
    RUN initializeObject IN hProc.

  phHandle = hProc.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-subscribeAll) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE subscribeAll Procedure 
PROCEDURE subscribeAll :
/*------------------------------------------------------------------------------
  Purpose:     Subscribes this procedure to the events that we need to trap
               from the configuration file manager startup.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phSourceProc AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER phTargetProc AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cEvents    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEntries   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCurrEvent AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount     AS INTEGER    NO-UNDO.

  /* If the source procedure handle is invalid, return */
  IF phSourceProc <> ? AND
     NOT VALID-HANDLE(phSourceProc) THEN
    RETURN.

  /* If the target procedure handle is invalid, use THIS-PROCEDURE */
  IF NOT VALID-HANDLE(phTargetProc) THEN
    phTargetProc = THIS-PROCEDURE:HANDLE.

  /* Get the list of events that are published by the source procedure */
  cEvents  = phSourceProc:PUBLISHED-EVENTS.

  /* Get the internal entries in this procedure */
  cEntries = phTargetProc:INTERNAL-ENTRIES.


  /* For each of the events published from the procedure, subscribe to the
     event if there is a corresponding event handler in the procedure. */

  /* Loop through all the published events */
  DO iCount = 1 TO NUM-ENTRIES(cEvents):
    /* Set the current event */
    cCurrEvent = ENTRY(iCount,cEvents).

    /* If we can find the current event in the internal entries, subscribe to 
       the event */
    IF CAN-DO(cEntries, cCurrEvent) THEN
    DO:
      IF phSourceProc = ? THEN
        SUBSCRIBE PROCEDURE phTargetProc TO cCurrEvent ANYWHERE.
      ELSE
        SUBSCRIBE PROCEDURE phTargetProc TO cCurrEvent IN phSourceProc.
    END.

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-buildErrorList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION buildErrorList Procedure 
FUNCTION buildErrorList RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Iterates through the errors on the ERROR-STATUS handle and builds 
            up a string with all the errors.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iCount   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cMessages AS CHARACTER  NO-UNDO.

  DO iCount = 1 TO ERROR-STATUS:NUM-MESSAGES:
    cMessages = cMessages + (IF cMessages = "":U THEN "":U ELSE CHR(13))
              + ERROR-STATUS:GET-MESSAGE(iCount).
  END.

  RETURN cMessages.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-detectFileType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION detectFileType Procedure 
FUNCTION detectFileType RETURNS CHARACTER
  ( INPUT pcFileName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:   Determines from the filename the type of file.
    Notes:   Valid file types are:
             U = URL
             N = UNC File Name (\\Machine\share\directory\file)
             D = DOS/Windows   (D:\directory\file)
             X = Unix Filename
------------------------------------------------------------------------------*/

  /* If the first 7 characters are http:// or the
     first 8 are https:// (secure http) or the 
     first 6 are ftp:// this is a URL */
  IF (SUBSTRING(pcFileName,1,7) = "http://":U OR
      SUBSTRING(pcFileName,1,8) = "https://":U OR
      SUBSTRING(pcFileName,1,6) = "ftp://":U) THEN
    RETURN "U":U. 

  /* If the first two characters are // and we are on a WIN32 machine,
     it's a UNC file name */
  IF (SUBSTRING(pcFileName,1,2) = "//":U OR
      SUBSTRING(pcFileName,1,2) = "~\~\":U) THEN
    RETURN "N":U.

  /* If the second character is a colon, or there is a backslash 
     anywhere in this filename, it is DOS filename */
  IF SUBSTRING(pcFileName,2,1) = ":":U OR
     INDEX(pcFileName,"~\":U) <> 0 THEN
    RETURN "D":U.

  /* If the first character is a / we've got a Unix file. */
  IF SUBSTRING(pcFileName,1,1) = "/":U THEN
   RETURN "X":U.

  /* Now we're down to figuring out from the operating system that we're on
     the type of file. */
  IF OPSYS = "UNIX":U THEN
    RETURN "X":U.

  RETURN "D":U.   /* If all else fails it must be DOS */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-expandTokens) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION expandTokens Procedure 
FUNCTION expandTokens RETURNS CHARACTER
  ( INPUT pcString AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Replaces tokens in the string with the values from the session
            parameters.
    Notes:  Takes a string with tokens in the form #<token># and replaces the
            token with a value that is derived from getSessionParam.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cRetVal  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cToken   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iPos     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLastPos AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cString  AS CHARACTER  NO-UNDO.

  /* If the string is blank, then just return */
  IF pcString = "":U THEN 
    RETURN pcString.

  /* Tokens may be nested inside the tokens. */
  iPos     = R-INDEX(pcString,"~{#":U).
  IF iPos > 0 THEN
    iLastPos = INDEX(pcString,"#~}":U, iPos).

  DO WHILE iPos <> 0: 
      cToken  = SUBSTRING(pcString,iPos + 2, iLastPos - iPos - 2).
      cString = getSessionParam(cToken).
      IF cString = ? THEN
        cString = "":U.
      pcString = REPLACE(pcString,"~{#":U + cToken + "#~}":U, cString).
      iPos     = R-INDEX(pcString,"~{#":U).
      IF iPos > 0 THEN
        iLastPos = INDEX(pcString,"#~}":U, iPos).
  END.
  
  /* Get the position of the first # */
  iLastPos = 1.
  iPos     = INDEX(pcString,"#":U).
  cRetVal  = "":U.
  cString  = "":U.

  /* Keep looping until we get to the end of the string */
  DO WHILE iPos <= LENGTH(pcString) AND iPos <> 0:
    cRetVal = cRetVal + SUBSTRING(pcString, iLastPos, iPos - iLastPos).
    /* Set the last position */
    iLastPos = iPos + 1.
    /* Find the next # in the string -- this would give us a token in between */
    iPos = INDEX(pcString,"#":U, iLastPos).

    /* If there is another #, we have a token */
    IF iPos <> 0 THEN 
    DO:
      /* Extract the token and look up its value */
      cToken = SUBSTRING(pcString, iLastPos, iPos - iLastPos).
      cString = getSessionParam(cToken).

      /* If the value of the token is unknow, set it to blank */
      IF cString = ? THEN
         cString = "":U.
      /* Put the value into the return value */
      cRetVal = cRetVal + cString.

      /* Set the last position ahead of this token */
      iLastPos = iPos + 1.

      /* And find the next # */
      iPos = INDEX(pcString,"#":U, iLastPos).

    END.
  END.
  cRetVal = cRetVal + SUBSTRING(pcString, iLastPos).

  RETURN cRetVal.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION findFile Procedure 
FUNCTION findFile RETURNS CHARACTER
  ( INPUT pcFileName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Takes a file name and tries to find the file on disk using the 
            _start_in_dir and _framework directories.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDisk      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDirectory AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cFile      AS CHARACTER  NO-UNDO.

  /* First try and find the file using the PROPATH */
  cFile = SEARCH(pcFileName).
  IF cFile <> ? THEN
    RETURN cFile.

  /* At this point we couldn't find the file, so lets try and find it in the 
     _start_in_directory */
  cDirectory = getSessionParam("_start_in_directory":U).
  IF cDirectory <> ? THEN
  DO:
    cFile = REPLACE(cDirectory,"~\":U,"/":U).
    IF SUBSTRING(cFile,LENGTH(cFile)) <> "/":U THEN
      cFile = cFile + "/":U.
    cFile = SEARCH(cFile + pcFileName).
    IF cFile <> ? THEN
      RETURN cFile.
  END.

  /* Get the framework drive letter */
  cDisk = getSessionParam("_framework_drive_letter":U).
  IF cDisk = ? OR
     cDisk = "":U THEN
    cDisk = "":U.
  ELSE
    cDisk = cDisk + ":":U.

  /* Next look in the framework source directory */
  cDirectory = getSessionParam("_framework_directory":U).
  IF cDirectory <> ? THEN
  DO:
    cFile = REPLACE(cDirectory,"~\":U,"/":U).
    IF SUBSTRING(cFile,LENGTH(cFile)) <> "/":U THEN
      cFile = cFile + "/":U.
    cFile = SEARCH(cDisk + cFile + pcFileName).
    IF cFile <> ? THEN
      RETURN cFile.
  END.

  /* Next, look in the framework directory */
  cDirectory = getSessionParam("_framework_code_directory":U).
  IF cDirectory <> ? THEN
  DO:
    cFile = REPLACE(cDirectory,"~\":U,"/":U).
    IF SUBSTRING(cFile,LENGTH(cFile)) <> "/":U THEN
      cFile = cFile + "/":U.
    cFile = SEARCH(cDisk + cFile + pcFileName).
    IF cFile <> ? THEN
      RETURN cFile.
  END.


  /* Next, look in the object code directory */
  IF SESSION:WINDOW-SYSTEM = "TTY":U THEN
    cDirectory = getSessionParam("_framework_tty_directory":U).
  ELSE
    cDirectory = getSessionParam("_framework_gui_directory":U).
  IF cDirectory <> ? THEN
  DO:
    cFile = REPLACE(cDirectory,"~\":U,"/":U).
    IF SUBSTRING(cFile,LENGTH(cFile)) <> "/":U THEN
      cFile = cFile + "/":U.
    cFile = SEARCH(cDisk + cFile + pcFileName).
    IF cFile <> ? THEN
      RETURN cFile.
  END.


  /* Next, look in the source code directory */
  cDirectory = getSessionParam("_framework_source_directory":U).
  IF cDirectory <> ? THEN
  DO:
    cFile = REPLACE(cDirectory,"~\":U,"/":U).
    IF SUBSTRING(cFile,LENGTH(cFile)) <> "/":U THEN
      cFile = cFile + "/":U.
    cFile = SEARCH(cDisk + cFile + pcFileName).
    IF cFile <> ? THEN
      RETURN cFile.
  END.

  /* Next, look in the root code directory */
  cDirectory = getSessionParam("_framework_root_directory":U).
  IF cDirectory <> ? THEN
  DO:
    cFile = REPLACE(cDirectory,"~\":U,"/":U).
    IF SUBSTRING(cFile,LENGTH(cFile)) <> "/":U THEN
      cFile = cFile + "/":U.
    cFile = SEARCH(cDisk + cFile + pcFileName).
    IF cFile <> ? THEN
      RETURN cFile.
  END.
  
  RETURN ?.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCodePath) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCodePath Procedure 
FUNCTION getCodePath RETURNS CHARACTER
  (INPUT pcFileName AS CHARACTER):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSourceCode AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRCode      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRootFile   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cExtension  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iEntry      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cRetVal     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lRunSource  AS LOGICAL    NO-UNDO.

  /* If the profiler is running, just run the file as the name was provided */
  IF glProfiler THEN
  DO:
    cRetVal = SEARCH(pcFileName).
    IF cRetVal <> ? THEN
      cRetVal = pcFileName.
    RETURN cRetVal.
  END.
  
  iEntry = NUM-ENTRIES(pcFileName,".":U).

  IF iEntry > 1 THEN
    cExtension = ENTRY(iEntry, pcFileName, ".":U).
  cRootFile = SUBSTRING(pcFileName,1,LENGTH(pcFileName) - LENGTH(cExtension)).

  IF cExtension <> "r" THEN
  DO:
    cSourceCode = SEARCH(pcFileName).
    cRCode      = SEARCH(cRootFile + "r").
  END.
  ELSE
  DO:
    cSourceCode = ?.
    cRCode      = SEARCH(pcFileName).
  END.

  cRetVal = ?.

  IF cRCode <> ? THEN 
    cRetVal = cRCode.

  IF cSourceCode <> ? THEN
  DO:
    IF cRetVal = ? THEN
      cRetVal = cSourceCode.
    ELSE
    DO:
      lRunSource = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                    "run_source_code":U) = "YES":U NO-ERROR.
      IF lRunSource = ? THEN
        lRunSource = NO.
      ERROR-STATUS:ERROR = NO.

      IF lRunSource THEN
        cRetVal = cSourceCode.
    END.
  END.

  IF cRetVal = ? THEN
    cRetVal = pcFileName.

  RETURN cRetVal.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getComponentRootDirectory) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getComponentRootDirectory Procedure 
FUNCTION getComponentRootDirectory RETURNS CHARACTER
  ( pcComponent AS CHARACTER /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Return the root directory for a given component. 
    Notes:  Valid components are : 
            AB (AppBuilder)
            framework
            SCM
            "" - will run getSessionrootDirectory
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cRootDirectory  AS CHARACTER  NO-UNDO.
  
  IF pcComponent = "":U  THEN 
  ASSIGN 
    cRootDirectory = DYNAMIC-FUNCTION('getSessionRootDirectory':U) NO-ERROR. 
  
  CASE pcComponent:  
     WHEN "SCM":U THEN
        /* Get the root directory set by the SCM tool */
        ASSIGN 
          cRootDirectory = DYNAMIC-FUNCTION('getSessionParam':U IN THIS-PROCEDURE, '_scm_root_directory':U) NO-ERROR. 
     
     WHEN "AB":U THEN
        /* Get the root directory set for the AB */
        ASSIGN 
          cRootDirectory = DYNAMIC-FUNCTION('getSessionParam':U IN THIS-PROCEDURE, 'AB_root_directory':U) NO-ERROR. 
     
     WHEN "framework":U THEN
        /* get the root directory set for the framework */
        ASSIGN 
          cRootDirectory = DYNAMIC-FUNCTION('getSessionParam':U IN THIS-PROCEDURE, '_framework_root_directory':U) NO-ERROR.         
  END CASE.
  
  /* Finally, make sure that we have a directory, it is valid and that we can write to it. */
  ASSIGN  
    FILE-INFO:FILE-NAME = cRootDirectory NO-ERROR.
  IF FILE-INFO:FULL-PATHNAME = ?
    OR INDEX(FILE-INFO:FILE-TYPE,"D") = 0
    OR INDEX(FILE-INFO:FILE-TYPE,"W") = 0
  THEN 
    ASSIGN 
      cRootDirectory  = "":U.
  ELSE DO:
    ASSIGN 
      cRootDirectory = FILE-INFO:FULL-PATHNAME      
      /* Clean up the directory name to replace back slashes with slashes and remove trailing slashes */
      cRootDirectory               = REPLACE(cRootDirectory,"~\":U,"~/":U)
      cRootDirectory               = RIGHT-TRIM(cRootDirectory,"/":U)
      .
  END.

  RETURN cRootDirectory.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getExpandablePropertyValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getExpandablePropertyValue Procedure 
FUNCTION getExpandablePropertyValue RETURNS CHARACTER
  ( INPUT pcProperty AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Obtains the value of the expandable property. 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cRetVal  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOrigVal AS CHARACTER  NO-UNDO.

  /* See if there is an original value */
  cOrigVal = getSessionParam(";:":U + pcProperty).

  /* See if we have expanded this before. If we have there 
     will be a :: property */
  cRetVal = getSessionParam("::":U + pcProperty).

  /* We haven't set it up before if cRetVal is unknown, so we 
     expand it from the original path */
  IF cRetVal = ? THEN
  DO:
    cRetVal = getSessionParam(pcProperty).
    setSessionParam("::":U + pcProperty, cRetVal).
  END.

  IF cOrigVal = ? THEN
   setSessionParam(";:":U + pcProperty, cRetVal).

  RETURN cRetVal.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getManagerHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getManagerHandle Procedure 
FUNCTION getManagerHandle RETURNS HANDLE
  ( INPUT pcManagerName AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Gets the handle of an already started manager or returns ? if 
            the manager has not been started.
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE BUFFER bttManager      FOR ttManager.
  DEFINE VARIABLE cSessionType  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hManager      AS HANDLE   NO-UNDO.


  /* Figure out the current session type */
  cSessionType = getSessionParam("ICFSESSTYPE":U).

  FIND FIRST bttManager 
    WHERE bttManager.cSessionType = cSessionType
      AND bttManager.cManagerName = pcManagerName
    NO-ERROR.
  IF NOT AVAILABLE(bttManager) THEN
    RETURN ?.

  /* If the Manager already has a handle and the handle is valid
     just return the handle. */
  IF VALID-HANDLE(bttManager.hHandle) THEN
  DO:
    hManager = bttManager.hHandle.
    IF hManager:TYPE <> "PROCEDURE":U OR
       hManager:UNIQUE-ID <> bttManager.iUniqueID THEN
      hManager = ?.
  END.

  RETURN hManager.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPhysicalSessionType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPhysicalSessionType Procedure 
FUNCTION getPhysicalSessionType RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Determines the Session's physical session type. If the value
            has not previously been set as a parameter, it is set here.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cPhysSessType AS CHARACTER  NO-UNDO.

  cPhysSessType = getSessionParam("PhysicalSessionType":U).

  /* If the physical session type has not previously been set it will
     return unknown */
  IF cPhysSessType = ? THEN
  DO:
    CASE SESSION:CLIENT-TYPE:
      WHEN "MULTI-SESSION-AGENT":U OR
      WHEN "APPSERVER" THEN
        cPhysSessType = "APP":U.
      WHEN "4GLCLIENT" THEN
      DO:
        IF SESSION:BATCH-MODE THEN
          cPhysSessType = "BTC":U.
        ELSE IF SESSION:DISPLAY-TYPE = "TTY":U THEN
          cPhysSessType = "CUI":U.
        ELSE
          cPhysSessType = "GUI":U.
      END.
      WHEN "WEBCLIENT" THEN
        cPhysSessType = "WBC":U.
      WHEN "WEBSPEED" THEN
        cPhysSessType = "WBS":U.
    END CASE.
    IF cPhysSessType = ? THEN
      cPhysSessType = "":U.

    setSessionParam("PhysicalSessionType":U, cPhysSessType).
  END.

  RETURN cPhysSessType.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getProcedureHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getProcedureHandle Procedure 
FUNCTION getProcedureHandle RETURNS HANDLE
  (INPUT pcFileName AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Determines the handle to a running procedure (if it is running) and 
            returns the handle or ? if the handle cannot be determined.
    Notes:  This function assumes that there is only one running copy of the
            procedure.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hProc               AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cFullPath           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRCode              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lUsePrivateData     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cPrivateDataString  AS CHARACTER  NO-UNDO.
  
  IF INDEX(pcFileName, "PRIVATE-DATA:") > 0 THEN 
     ASSIGN 
        lUsePrivateData = TRUE
        cPrivateDataString = REPLACE(pcFileName, "PRIVATE-DATA:":U, "":U). 
  ELSE
     lUsePrivateData = FALSE.    
  
  IF NOT lUsePrivateData THEN DO:
    cFullPath = SEARCH(pcFileName).
  
    IF SUBSTRING(pcFileName,LENGTH(pcFileName) - 1,1) = ".":U THEN
      cRCode = SUBSTRING(pcFileName,1,LENGTH(pcFileName) - 2).
    ELSE
      cRCode = pcFileName.
     
    cRCode = SEARCH(cRCode + ".r":U).
  
    IF cFullPath = ? THEN
      cFullPath = "":U.
    IF cRCode = ? THEN
      cRCode = "":U.
  END.
  
  hProc = SESSION:FIRST-PROCEDURE.

  DO WHILE VALID-HANDLE(hProc):
    IF lUsePrivateData AND cPrivateDataString <> "":U THEN DO: 
       IF hProc:PRIVATE-DATA = cPrivateDataString THEN
          RETURN hProc.
    END.
    ELSE 
    IF hProc:FILE-NAME = pcFileName OR
       hProc:FILE-NAME = cFullPath OR
       hProc:FILE-NAME = cRCode THEN
      RETURN hProc.
    hProc = hProc:NEXT-SIBLING.
  END.  

  RETURN ?.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSessionParam) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSessionParam Procedure 
FUNCTION getSessionParam RETURNS CHARACTER
  ( INPUT pcOption AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the value associated with an option.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER bttParam FOR ttParam.
  DEFINE VARIABLE cRetVal AS CHARACTER  NO-UNDO.

  /* Find the ttParam record and set the return value 
     to the value of the parameter */
  DO FOR bttParam:
    FIND bttParam
      WHERE bttParam.cOption = pcOption
      NO-ERROR.
    IF NOT AVAILABLE(bttParam) THEN
      cRetVal = ?.
    ELSE
      cRetVal = bttParam.cValue.
  END.
  RETURN cRetVal.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSessionRootDirectory) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSessionRootDirectory Procedure 
FUNCTION getSessionRootDirectory RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Get the root directory for the session
    Notes:  The root directory will vary, depending on whether we are running with 
            the SCM tool or not. If the SCM tool is running, then the root 
            directory for the currently selected workspace must be returned. If not, 
            then the framework root directory or the session start up or session temp
            directories wil be returned. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cRootDirectory AS CHARACTER  NO-UNDO.
  
  /* Check to see if the _scm_root_directory has been set - this should be used if available */
  ASSIGN 
    cRootDirectory = DYNAMIC-FUNCTION('getSessionParam':U IN THIS-PROCEDURE, '_scm_root_directory':U) NO-ERROR
    .
    
/*   IF cRootDirectory = ? OR cRootDirectory = "":U THEN                                                                */
/*   /* If the SCM root directory is not available, then get the _framework_root_directory */                           */
/*   ASSIGN                                                                                                             */
/*     cRootDirectory = DYNAMIC-FUNCTION('getSessionParam':U IN THIS-PROCEDURE, '_framework_root_directory':U) NO-ERROR */
/*     .                                                                                                                */
  IF cRootDirectory = ? OR cRootDirectory = "":U THEN
  /* if the _framework_root_directory is not available then we need to get the AB_source_code_directory */
  ASSIGN
    cRootDirectory = DYNAMIC-FUNCTION('getSessionParam':U IN THIS-PROCEDURE, 'AB_source_code_directory':U) NO-ERROR
    .
  IF cRootDirectory = ? OR cRootDirectory = "":U THEN
  /* if the AB_source_code_directory is not available then we need to get the _start_in_directory */
  ASSIGN 
    cRootDirectory = DYNAMIC-FUNCTION('getSessionParam':U IN THIS-PROCEDURE, '_start_in_directory':U) NO-ERROR
    .  
  IF cRootDirectory = ? OR cRootDirectory = "":U THEN
    /* If the root-directory is not available then we get the "." directory */    
    ASSIGN 
      cRootDirectory = ".":U. 
  /* Finally, make sure that we have a directory, it is valid and that we can write to it. */
  ASSIGN  
    FILE-INFO:FILE-NAME = cRootDirectory NO-ERROR
    .
  
  IF FILE-INFO:FULL-PATHNAME = ?
    OR INDEX(FILE-INFO:FILE-TYPE,"D") = 0
    OR INDEX(FILE-INFO:FILE-TYPE,"W") = 0
  THEN
    cRootDirectory  = SESSION:TEMP-DIRECTORY.
  ELSE
    cRootDirectory = FILE-INFO:FULL-PATHNAME.
      
  /* Clean up the directory name to replace back slashes with slashes and remove trailing slashes */
  ASSIGN 
    cRootDirectory = REPLACE(cRootDirectory,"~\":U,"~/":U)
    cRootDirectory = RIGHT-TRIM(cRootDirectory,"/":U)
    .

  RETURN cRootDirectory.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isConfigManRunning) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isConfigManRunning Procedure 
FUNCTION isConfigManRunning RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns true indicating that the configuration manager is 
               running.
  Notes:       This function avoids users having to obtain the handle to the 
               configuration file manager to figure out if it is running as
               they can simpley call it using a dynamic-function call.
------------------------------------------------------------------------------*/

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isICFRunning) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isICFRunning Procedure 
FUNCTION isICFRunning RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns TRUE if the ICF environment is established and running.
    Notes:  If the global variable glICFIsRunning is unknown, this function
            checks the values of the global variables that contain the essential
            managers for the ICF environment.
            If the glICFIsRunning is not unknown, this function returns the 
            value of that variable thereby allowing the user to override our
            definition of what constitutes a running ICF session.
            
            THIS FUNCTION PRE-SUPPOSES THAT OPAQUE HANDLES ARE SWITCHED ON.
------------------------------------------------------------------------------*/
  IF glICFIsRunning = ? THEN
    RETURN VALID-HANDLE(gshSessionManager) AND
           VALID-HANDLE(gshSecurityManager) AND
           VALID-HANDLE(gshProfileManager) AND
           VALID-HANDLE(gshRepositoryManager) AND
           VALID-HANDLE(gshTranslationManager) AND
           VALID-HANDLE(gshGenManager).
  ELSE
    RETURN glICFIsRunning.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isProcedureRegistered) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isProcedureRegistered Procedure 
FUNCTION isProcedureRegistered RETURNS LOGICAL
  ( INPUT phHandle AS HANDLE) :
/*------------------------------------------------------------------------------
  Purpose:  Checks to see whether the handle provided belongs to a manager 
            that is in the ttManager table.
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE BUFFER bttManager      FOR ttManager.
  DEFINE VARIABLE cSessionType  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hManager      AS HANDLE     NO-UNDO.


  /* Figure out the current session type */
  cSessionType = getSessionParam("ICFSESSTYPE":U).

  /* See if we can find any entry in the bttManager table with this
     handle */
  FIND FIRST bttManager 
    WHERE bttManager.cSessionType = cSessionType
      AND bttManager.hHandle      = phHandle
    NO-ERROR.

  /* If there is no bttManager record, return NO */
  IF NOT AVAILABLE(bttManager) THEN
    RETURN NO.
  ELSE
    RETURN YES.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setICFIsRunning) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setICFIsRunning Procedure 
FUNCTION setICFIsRunning RETURNS LOGICAL
  ( INPUT plRunning AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:   Exposes the glICFIsRunning variable to other procedures so that
             it can be set and retrieved to determine if the ICF environment
             has been properly established.
    Notes:  
------------------------------------------------------------------------------*/
  ASSIGN
    glICFIsRunning = plRunning
    .

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSessionParam) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSessionParam Procedure 
FUNCTION setSessionParam RETURNS LOGICAL
  ( INPUT pcOption AS CHARACTER,
    INPUT pcValue  AS CHARACTER  ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the value of a parameter in the ttParam table.
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE BUFFER bttParam FOR ttParam.

  /* Find the ttParam record, creating it if necessary, and set the 
     value of the parameter to the value in the input parameter */
  DO FOR bttParam:
    FIND bttParam
      WHERE bttParam.cOption = pcOption
      NO-ERROR.
    IF NOT AVAILABLE(bttParam) AND
       pcValue <> ? THEN
    DO:
      CREATE bttParam.
      ASSIGN
        bttParam.cOption = pcOption
        .
    END.
    
    IF pcValue = ? THEN
    DO:
      IF AVAILABLE(bttParam) THEN
        DELETE bttParam.
    END.
    ELSE
    DO:
      ASSIGN
        bttParam.cValue = pcValue.
      IF LENGTH(pcValue) > 128 THEN
        bttParam.cDispValue = SUBSTRING(pcValue,1,128).
      ELSE
        bttParam.cDispValue = pcValue.
    END.

  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

