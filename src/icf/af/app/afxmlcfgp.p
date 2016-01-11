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

  (v:010002)    Task:    90000027   UserRef:    
                Date:   25/04/2001  Author:     Bruce Gruenbaum

  Update Notes: Writes the code. Initial version was a placeholder.

  (v:010003)    Task:    90000132   UserRef:    
                Date:   14/05/2001  Author:     Bruce Gruenbaum

  Update Notes: XML configuration manager

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
DEFINE VARIABLE glICFIsRunning AS LOGICAL INITIAL ? NO-UNDO.


/* The global variables that are used by the existing ICF framework are
   included so that they can be manually set as well. */
{afglobals.i}

/* The following include brings in the temp-tables that we need to parse
   the XML file */
{afxmlcfgtt.i}

/* The following include contains the replaceCtrlChar function */
{afxmlreplctrl.i}

/* The following include contains the manipulation of the ttNode table */
{afttnode.i}

/* The AppBuilder should not remove this procedure */
{adecomm/_adetool.i}

/* This table contains the session's parameters. All values are get and
   set using the getValue and setValue functions. */
DEFINE TEMP-TABLE ttParam NO-UNDO RCODE-INFORMATION
  FIELD cOption AS CHARACTER FORMAT "X(25)" LABEL "Parameter"
  FIELD cValue  AS CHARACTER FORMAT "X(50)" LABEL "Value"
  INDEX pudx IS UNIQUE PRIMARY
    cOption
  .

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

&IF DEFINED(EXCLUDE-getCodePath) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCodePath Procedure 
FUNCTION getCodePath RETURNS CHARACTER
  (INPUT pcFileName AS CHARACTER) FORWARD.

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

&IF DEFINED(EXCLUDE-writeConfigRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD writeConfigRecord Procedure 
FUNCTION writeConfigRecord RETURNS LOGICAL PRIVATE
  ( INPUT phBuffer AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-writeNode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD writeNode Procedure 
FUNCTION writeNode RETURNS LOGICAL PRIVATE
  ( /* No Parameters */ )  FORWARD.

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
         HEIGHT             = 26.52
         WIDTH              = 63.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */ 


/* We want to make this procedure a SESSION:SUPER-PROCEDURE for now. */
IF THIS-PROCEDURE:PERSISTENT THEN
  SESSION:ADD-SUPER-PROCEDURE(THIS-PROCEDURE).


ON "CLOSE":U OF THIS-PROCEDURE
DO:
  RUN sessionShutdown.
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
  Notes:       This procedure is a placeholder. It needs to be fleshed out more 
               later.
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
  DEFINE INPUT  PARAMETER pcICFParam  AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE hConfig             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hCurrManager        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hConnManager        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cCurrSessType       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPhysSessTypes      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cCurrPhysSessType   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValidOSList        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cConfig             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount              AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cLoginWindow        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hHandle             AS HANDLE     NO-UNDO.

  DEFINE BUFFER bttProperty           FOR ttProperty.
  DEFINE BUFFER bttManager            FOR ttManager.
  DEFINE BUFFER bttParam              FOR ttParam.
  DEFINE BUFFER bttService            FOR ttService.

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

  /* Confirm that the configuration file is correct, and obtain a handle to 
     the X document. */
  RUN validateConfigFile (INPUT getSessionParam("ICFCONFIG":U),OUTPUT hConfig).
  IF RETURN-VALUE <> "":U THEN
    RETURN "ICFSTARTUPERR: ":U + RETURN-VALUE.

  /* We decided that if the configuration file is empty, nothing happens.
     IOW, if we can't find a config file, or the config file is invalid,
     we ignore it and carry on. */
  IF NOT VALID-HANDLE(hConfig) THEN
    RETURN "ICFSTARTUPERR: INVALID CONFIG FILE OR CONFIG FILE NOT FOUND":U.

  /* Now we need to parse the configuration file and read in the data from
     the file. */
  RUN parseConfig (hConfig,cCurrSessType).

  /* Publish the ICFCFM_ConfigParsed event. This notifies any subscribers
     that the file has been parsed in and provides an opportunity to parse
     the XML file further if necessary */
  PUBLISH "ICFCFM_ParametersSet":U (INPUT hConfig, INPUT cCurrSessType).
  
  /* We're done with the XML file, so we delete the object */
  DELETE OBJECT hConfig.
  hConfig = ?.

  /* If there was a RETURN-VALUE from the parse, we need to return it */
  IF RETURN-VALUE <> "":U THEN
    RETURN RETURN-VALUE.

  /* Now we need to copy the properties to the ttParams */
  FOR EACH bttProperty:
    setSessionParam(bttProperty.cProperty,bttProperty.cValue).
  END.
  /* As we're now done with the ttProperty table, empty it */
  EMPTY TEMP-TABLE ttProperty.

  
  /* Now we need to figure out if this is a valid session type for this 
     environment. Get the list of supported physical session types */
  cPhysSessTypes = getSessionParam("physical_session_list":U).

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

  /* Now we need to start the event handler for the configuration file manager
     if there is one. */
  RUN startEventHandler("ICFEH_CFM":U).

  /* Publish the ICFCFM_ParametersSet event */
  PUBLISH "ICFCFM_ParametersSet":U.

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

    RUN startManager (bttManager.cManagerName, OUTPUT hConnManager).
    IF RETURN-VALUE <> "":U THEN
      RETURN RETURN-VALUE.

    PUBLISH "ICFCFM_ConnectionManagerStarted":U.
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
                             IN hConnManager,
                             hCurrManager) THEN
      RETURN "ICFSTARTUPERR: UNABLE TO REGISTER MANAGER ":U + bttParam.cOption 
             + " = ":U + bttParam.cValue.

    PUBLISH "ICFCFM_ServiceTypeManagerStarted":U (INPUT bttParam.cValue).
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
  
  RUN initializeServices IN hConnManager
    (INPUT BUFFER ttService:HANDLE, 
     YES /* we want them connected */ ).

  IF RETURN-VALUE <> "":U THEN
    RETURN RETURN-VALUE.
  
  PUBLISH "ICFCFM_InitializedServices":U.


  /* Now go through the list of managers that are in the
     the managers table and start all that do not yet have a handle set */
  FOR EACH bttManager NO-LOCK
    WHERE bttManager.cSessionType = cCurrSessType
      AND bttManager.hHandle = ?
    BY bttManager.cSessionType
    BY bttManager.hHandle
    BY bttManager.iOrder:
    
    PUBLISH "ICFCFM_StartingManager":U (INPUT bttManager.cManagerName).

    RUN startManager (bttManager.cManagerName, OUTPUT hCurrManager).
    IF RETURN-VALUE <> "":U THEN
      RETURN RETURN-VALUE.

    PUBLISH "ICFCFM_StartedManager":U (INPUT bttManager.cManagerName).

  END.

  /* Publish the login event */
  PUBLISH "ICFCFM_Login":U.
  IF RETURN-VALUE <> "":U AND 
     RETURN-VALUE <> ? THEN
    RETURN RETURN-VALUE.

  
  /* Finally, run each of the startup procedures that have been
     specified. Note that if any of them fail, we quit the session */
  FOR EACH bttParam 
    WHERE bttParam.cOption BEGINS "startup_procedure":U 
    BY bttParam.cOption:
    
    PUBLISH "ICFCFM_StartingProcedure":U (INPUT bttParam.cValue).

    RUN startProcedure(bttParam.cValue, OUTPUT hHandle) NO-ERROR.
    IF ERROR-STATUS:ERROR OR 
       RETURN-VALUE <> "":U THEN
      RETURN "ICFSTARTUPERR: STARTUP PROCEDURE ":U + bttParam.cValue +
             " RETURNED ERROR " + RETURN-VALUE.
    
    PUBLISH "ICFCFM_StartedProcedure":U (INPUT bttParam.cValue).
  END.

  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtainCFMTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE obtainCFMTables Procedure 
PROCEDURE obtainCFMTables :
/*------------------------------------------------------------------------------
  Purpose:     Returns the handles to all the temp-tables that the connection
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

&IF DEFINED(EXCLUDE-parseConfig) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE parseConfig Procedure 
PROCEDURE parseConfig :
/*------------------------------------------------------------------------------
  Purpose:     Takes the handle to the XML document and retrieves the contents 
               of the requested session types into the configuration temp-tables.
  Parameters:  phXDoc    - Handle to the X Document that has the info.
               pcSessType - Session Type to read in. A blank value will retrieve
                            all the data.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phXDoc  AS HANDLE   NO-UNDO.
  DEFINE INPUT  PARAMETER pcSessType  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hRootNode     AS HANDLE   NO-UNDO.
  DEFINE VARIABLE hSessionNode  AS HANDLE   NO-UNDO.
  DEFINE VARIABLE lSuccess      AS LOGICAL  NO-UNDO.
  DEFINE VARIABLE iCount        AS INTEGER  NO-UNDO.

  /* Create two node references */
  CREATE X-NODEREF hRootNode.
  CREATE X-NODEREF hSessionNode.

  /* Set the root node */
  lSuccess = phXDoc:GET-DOCUMENT-ELEMENT(hRootNode).

  /* If we're not successful we have an invalid XML file */
  IF NOT lSuccess THEN
    RETURN "ICFSTARTUPERR: COULD NOT PARSE CONFIG FILE":U.

  /* Iterate through the root node's children */
  REPEAT iCount = 1 TO hRootNode:NUM-CHILDREN:
    /* Set the current Session Node */
    lSuccess = hRootNode:GET-CHILD(hSessionNode,iCount).

    IF NOT lSuccess THEN
      NEXT.

    /* If the session node is blank, skip it */
    IF hSessionNode:SUBTYPE = "TEXT":U AND
       hSessionNode:NODE-VALUE = CHR(10) THEN
      NEXT.
    /* If the name of this node is "Session" and the SessionType attribute matches the
       one(s) we need to retrieve, we'll process this node */  
    IF hSessionNode:NAME = "session":U AND
       CAN-DO(hSessionNode:ATTRIBUTE-NAMES,"SessionType":U) AND
       (pcSessType = "":U OR
        hSessionNode:GET-ATTRIBUTE("SessionType":U) = pcSessType) THEN
    DO:
      EMPTY TEMP-TABLE ttNode.
      RUN recurseNodes(hSessionNode,hSessionNode:GET-ATTRIBUTE("SessionType":U)).
    END.
  END.
   
  /* Make sure that ttNode is empty */
  EMPTY TEMP-TABLE ttNode.
  
  /* Delete the objects */
  DELETE OBJECT hRootNode.
  hRootNode = ?.
  DELETE OBJECT hSessionNode.
  hSessionNode = ?.

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

&IF DEFINED(EXCLUDE-recurseNodes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recurseNodes Procedure 
PROCEDURE recurseNodes PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     This procedure is responsible for constructing the attributes
               into the node table to prepare them for the write into the
               appropriate tables.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phParent      AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER pcStack       AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hNode       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lSuccess    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iCount      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLevel      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cTest       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRecordType AS CHARACTER  NO-UNDO.


  /* If we're at the top of the stack, put the name in the node table */
  IF NUM-ENTRIES(pcStack) = 1 THEN
    setNode("SessionType":U,pcStack,NUM-ENTRIES(pcStack),NO).

  /* Set the node to look at the next child */
  CREATE X-NODEREF hNode.

  /* Iterate through the children */
  REPEAT iCount = 1 TO phParent:NUM-CHILDREN:
    /* Set the node to the child node */
    lSuccess = phParent:GET-CHILD(hNode,iCount).
    IF NOT lSuccess THEN
      NEXT.

    /* If the text has nothing in it, skip it */
    IF hNode:SUBTYPE = "TEXT":U THEN
    DO:
      cTest = REPLACE(hNode:NODE-VALUE, CHR(10), "":U).
      cTest = REPLACE(cTest, CHR(13), "":U).
      cTest = TRIM(cTest).
      IF cTest = "" THEN
        NEXT.
    END.

    /* When we hit level 2, we know what kind of records these are,
       and we need to make sure that they get appropriately set. */
    IF NUM-ENTRIES(pcStack) = 2 THEN
    DO:
      cRecordType = ENTRY(1,pcStack).
      setNode("RecordType":U,cRecordType,NUM-ENTRIES(pcStack),NO).
    END.

    /* Set a node value for this node */
    IF hNode:SUBTYPE = "TEXT":U THEN
      setNode(ENTRY(1,pcStack),hNode:NODE-VALUE,NUM-ENTRIES(pcStack),YES).

    /* Go down lower if need be */
    RUN recurseNodes(hNode,hNode:NAME + ",":U + pcStack).

    /* If this is level 2 on the stack, we can write out this data
       to the appropriate files */
    IF NUM-ENTRIES(pcStack) = 2 THEN
      writeNode().

  END.

  DELETE OBJECT hNode.
  hNode = ?.
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
  DEFINE BUFFER bttManager FOR ttManager.

  /* First shutdown the ICF managers */
  IF VALID-HANDLE(gshAgnManager)          THEN 
    APPLY "CLOSE":U TO gshAgnManager.
  IF VALID-HANDLE(gshFinManager)          THEN 
    APPLY "CLOSE":U TO gshFinManager.
  IF VALID-HANDLE(gshGenManager)          THEN 
    APPLY "CLOSE":U TO gshGenManager.
  IF VALID-HANDLE(gshTranslationManager)  THEN 
    APPLY "CLOSE":U TO gshTranslationManager.
  IF VALID-HANDLE(gshRepositoryManager)   THEN 
    APPLY "CLOSE":U TO gshRepositoryManager.
  IF VALID-HANDLE(gshProfileManager)      THEN 
    APPLY "CLOSE":U TO gshProfileManager.
  IF VALID-HANDLE(gshSecurityManager)     THEN 
    APPLY "CLOSE":U TO gshSecurityManager.
  IF VALID-HANDLE(gshSessionManager)      THEN 
    APPLY "CLOSE":U TO gshSessionManager.

  /* Now make sure that all their handles are unknown */
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
    .

  /* Now shut down the Connection Manager */
  hConnManager = getManagerHandle("ConnectionManager":U).  

  IF VALID-HANDLE(hConnManager) THEN
  DO:
    IF CAN-DO(hConnManager:INTERNAL-ENTRIES,"plipShutdown":U) THEN
      RUN plipShutdown IN hConnManager.
    ELSE
      DELETE PROCEDURE hConnManager.
  END.

  /* Now go through anything else that is left in the procedure handle table
     and try and shut it down. */

  FOR EACH bttManager:
    hManager = bttManager.hHandle.
    IF VALID-HANDLE(hManager) THEN
    DO:
      IF CAN-DO(hManager:INTERNAL-ENTRIES,"plipShutdown":U) THEN
        RUN plipShutdown IN hConnManager.
      ELSE
        DELETE PROCEDURE hConnManager.
    END.
    DELETE bttManager.
  END.

  /* Anthony insisted this code be put in here to support RoundTable */
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

  DEFINE BUFFER bttParam FOR ttParam.
  DEFINE VARIABLE cAttribute  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPropath    AS CHARACTER  NO-UNDO.


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
      NEXT.
    END.

    /* If it's not an attribute of the session handle that can be set, skip 
       it */
    IF NOT CAN-SET(SESSION,cAttribute) THEN
      NEXT.

    /* Wouldn't it be nice to have a dynamic attribute setting mechanism?
       To get around that, we  use a huge CASE statement */
    CASE cAttribute:
      WHEN "APPL-ALERT-BOXES":U THEN
        SESSION:APPL-ALERT-BOXES = bttParam.cValue = "YES":U.

      WHEN "CONTEXT-HELP-FILE":U THEN
        SESSION:CONTEXT-HELP-FILE = bttParam.cValue.

      WHEN "DATA-ENTRY-RETURN":U THEN
        SESSION:DATA-ENTRY-RETURN = bttParam.cValue = "YES":U.

      WHEN "DATE-FORMAT":U THEN
        SESSION:DATE-FORMAT = bttParam.cValue.

      WHEN "DEBUG-ALERT":U THEN
        SESSION:DEBUG-ALERT = bttParam.cValue = "YES":U.

      WHEN "IMMEDIATE-DISPLAY":U THEN
        SESSION:IMMEDIATE-DISPLAY = bttParam.cValue = "YES":U.

      WHEN "MULTITASKING-INTERVAL":U THEN
        SESSION:MULTITASKING-INTERVAL = INTEGER(bttParam.cValue).

      WHEN "NUMERIC-FORMAT":U THEN
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

      WHEN "SUPPRESS-WARNINGS":U THEN
        SESSION:SUPPRESS-WARNINGS = bttParam.cValue = "YES":U.

      WHEN "SYSTEM-ALERT-BOXES":U THEN
        SESSION:SYSTEM-ALERT-BOXES = bttParam.cValue = "YES":U.

      WHEN "TIME-SOURCE":U THEN
        SESSION:TIME-SOURCE = bttParam.cValue.

      WHEN "TOOLTIPS":U THEN
        SESSION:TOOLTIPS = bttParam.cValue = "YES":U.

      WHEN "V6DISPLAY":U THEN
        SESSION:V6DISPLAY = bttParam.cValue = "YES":U.

      WHEN "YEAR-OFFSET":U THEN
        SESSION:YEAR-OFFSET = INTEGER(bttParam.cValue).
    END CASE.
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



  /* Figure out the current session type */
  cSessionType = getSessionParam("ICFSESSTYPE":U).

    FIND FIRST bttManager 
      WHERE bttManager.cSessionType = cSessionType
        AND bttManager.cManagerName = pcManagerName
      NO-ERROR.
    IF NOT AVAILABLE(bttManager) THEN
      RETURN "ICFSTARTUPERR: MANAGER NOT AVAILABLE":U.

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

    /* Only do this if we don't yet have a valid handle */
    IF NOT VALID-HANDLE(phManager) THEN
    DO:

      RUN startProcedure("ONCE|":U + bttManager.cFileName, OUTPUT phManager) NO-ERROR.
      IF RETURN-VALUE <> "":U AND
         RETURN-VALUE <> ? THEN
      DO:
        /* Build up a string that contains the error information */
        cRetVal = "PROCEDURE ":U + bttManager.cFileName + " FAILED TO LOAD.":U
                + CHR(10) + RETURN-VALUE.
        ERROR-STATUS:ERROR = NO.

        RETURN cRetVal.
      END. /* IF RETURN-VALUE <> "":U */
    END. /* IF NOT VALID-HANDLE(phManager)...*/
  
    DO TRANSACTION:

      ASSIGN
        bttManager.hHandle = phManager
        bttManager.iUniqueID = phManager:UNIQUE-ID
        .
    END.

    /* The handle ties certain hardcoded global variables to certain
       handles. This CASE statement makes sure the appropriate handles
       are set. */
    CASE bttManager.cHandleName:
      WHEN "SM":U THEN
        gshSessionManager = phManager.
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
    IF cFileName = cProcName THEN
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
      RUN getObjectNames IN gshRepositoryManager (
          INPUT  cProcName,
          OUTPUT cFileName,
          OUTPUT cLogicalName).
      IF cFileName = "":U THEN
        RETURN "Could not find Physical Name for Logical Object: ":U + cProcName.

      IF cLogicalName <> "":U THEN
        DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager,
                                             INPUT "LaunchLogicalObject":U,
                                             INPUT cLogicalName,
                                             INPUT NO).

      /* Run startup window if specified */
      IF cFileName <> "":U THEN
      RUN-BLOCK:
      DO ON STOP UNDO RUN-BLOCK, LEAVE RUN-BLOCK ON ERROR UNDO RUN-BLOCK, LEAVE RUN-BLOCK:
      /*   SESSION:SET-WAIT-STATE('general':U). */
        RUN VALUE(cFileName).
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

&IF DEFINED(EXCLUDE-validateConfigFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateConfigFile Procedure 
PROCEDURE validateConfigFile :
/*------------------------------------------------------------------------------
  Purpose: Validates that the config file name actually exists and tries to
           load it into an XML handle to confirm that it is valid.

  Parameters: 
    pcFileName = Name of the file to be read. May be a URL, standard filename
                 or UNC Filename.
    phXDoc     = Handle to the XML document object that gets created in here.

  Notes:
    The URL portion of this LOAD only works with Progress V9.1C or later. The
    XML engine prior to 9.1C did not support loading from URLs.  
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcFileName  AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER phXDoc      AS HANDLE   NO-UNDO.

  DEFINE VARIABLE cFullPath     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFileType     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lSuccess      AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cRetVal       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount        AS INTEGER    NO-UNDO.

  /* Figure out what type of filename it is. */
  cFileType = detectFileType(pcFileName).

  /* If this is a DOS or UNC filename, and we are not on a
     Unix machine, convert the backslashes to forward slashes */
  IF CAN-DO("D,N":U,cFileType) AND
     OPSYS <> "UNIX":U THEN
    pcFileName = REPLACE(pcFileName,"/":U,"~\":U).

  /* If the filetype is not a URL, see if you can find the file */
  IF cFileType = "U":U THEN
    cFullPath = pcFileName.
  ELSE
    cFullPath = SEARCH(pcFileName).

  /* If the file does not exist, return the ? value */
  IF cFullPath <> ? THEN
  DO:
    /* Next thing to do is try creating and loading the XML document */
    CREATE X-DOCUMENT phXDoc.
    lSuccess = phXDoc:LOAD("FILE":U,cFullPath,FALSE) NO-ERROR.

    /* If we didn't succeed in loading the XML file, we need to 
       bail out */
    cRetVal = "":U.
    IF ERROR-STATUS:ERROR OR 
       NOT lSuccess THEN
    DO:
      /* Build up a string that contains the error information */
      cRetVal = "XML LOAD FAILED.":U. 
      IF ERROR-STATUS:ERROR THEN
      DO:
        cRetVal = cRetVal + CHR(10) + "Progress returned these errors: ".
        DO iCount = 1 TO ERROR-STATUS:NUM-MESSAGES:
          cRetVal = cRetVal + CHR(10) + ERROR-STATUS:GET-MESSAGE(iCount).
        END.
        ERROR-STATUS:ERROR = NO.
      END.

      /* Delete the object or we'll have a memory leak */
      DELETE OBJECT phXDoc.
      phXDoc = ?.
    END.
  END.
  
  RETURN cRetVal.

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
  DEFINE VARIABLE hProc     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cFullPath AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cRCode    AS CHARACTER  NO-UNDO.
  
  cFullPath = SEARCH(pcFileName).
  cRCode    = SEARCH(SUBSTRING(pcFileName,1,LENGTH(pcFileName) - 2) + ".r":U).
  IF cFullPath = ? THEN
    cFullPath = "":U.
  IF cRCode = ? THEN
    cRCode = "":U.

  hProc = SESSION:FIRST-PROCEDURE.

  DO WHILE VALID-HANDLE(hProc):
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
      bttParam.cValue = pcValue.
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-writeConfigRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION writeConfigRecord Procedure 
FUNCTION writeConfigRecord RETURNS LOGICAL PRIVATE
  ( INPUT phBuffer AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:   Creates a buffer record and populates the contents with the
             data contained in the ttNodes table.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSessType   AS HANDLE   NO-UNDO.
  DEFINE VARIABLE hOrder      AS HANDLE   NO-UNDO.
  DEFINE VARIABLE iNextRec    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cSessType   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hCurrField  AS HANDLE   NO-UNDO.

  /* Get the current session type */
  cSessType = getNode("SessionType":U).

  hSessType = phBuffer:BUFFER-FIELD("cSessionType":U).

  /* Figure out if there is an iOrder field. If there is, get the next
     number */
  hOrder = phBuffer:BUFFER-FIELD("iOrder":U).
  IF VALID-HANDLE(hOrder) THEN
    iNextRec = getNextOrderNum(phBuffer,cSessType).

  /* Go into a transaction */
  DO TRANSACTION:
    /* Create a record */
    phBuffer:BUFFER-CREATE().

    /* Set the value of the cSessionType and iOrder fields */
    hSessType:BUFFER-VALUE = cSessType.
    IF VALID-HANDLE(hOrder) THEN
      hOrder:BUFFER-VALUE = iNextRec.

    /* Loop through the records in the ttNode table that are not 
       either RecordType or SessionType properties.*/
    FOR EACH ttNode
      WHERE NOT CAN-DO("RecordType,SessionType",ttNode.cNode):

      /* Get the handle to a field in the TEMP-TABLE that has 
         the name of this node. If we find
         it we set its value */
      hCurrField = phBuffer:BUFFER-FIELD(ttNode.cNode).
      IF VALID-HANDLE(hCurrField) THEN
        hCurrField:BUFFER-VALUE = ttNode.cValue.
    END.

    /* Release the buffer so that it gets written */
    phBuffer:BUFFER-RELEASE().
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-writeNode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION writeNode Procedure 
FUNCTION writeNode RETURNS LOGICAL PRIVATE
  ( /* No Parameters */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Writes the data from the Node table out to the appropriate
            temp table.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cRecordType AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSessType   AS CHARACTER  NO-UNDO.

  /* Figure out what type of record we're dealing with */
  cRecordType = getNode("RecordType":U).


  /* Handle each record type appropriately */
  CASE cRecordType:
    /* Properties are set up as a record per property.
       We use the setProperty function in this procedure to
       do this. */
    WHEN "properties":U THEN
    DO:
      /* Get the session type */
      cSessType   = getNode("SessionType":U).
      /* If this is a property record, set a property for the
         session type */
      FOR EACH ttNode
        WHERE NOT CAN-DO("RecordType,SessionType",ttNode.cNode):
        setProperty(cSessType,ttNode.cNode,ttNode.cValue).
      END.
    END.

    /* For services and managers we can use the 
       writeConfigRecord function and pass in the appropriate 
       temp-table's buffer as a handle */
    WHEN "services":U THEN
      writeConfigRecord(INPUT BUFFER ttService:HANDLE).
    WHEN "managers":U THEN
      writeConfigRecord(INPUT BUFFER ttManager:HANDLE).
  END CASE.

  /* Empty the node table for all old values */
  FOR EACH ttNode WHERE lDelete:
    DELETE ttNode.
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

