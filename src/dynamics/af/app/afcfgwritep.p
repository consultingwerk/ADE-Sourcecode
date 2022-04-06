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
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: afcfgwritep.p

  Description:  Writes out the ICFCONFIG.XML file

  Purpose:      Writes out the ICFCONFIG.XML file

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:    90000132   UserRef:    
                Date:   14/05/2001  Author:     Bruce Gruenbaum

  Update Notes: Created from Template rytemplipp.p

  (v:010002)    Task:    90000135   UserRef:    
                Date:   15/05/2001  Author:     Bruce Gruenbaum

  Update Notes: Fix return status

  (v:010003)    Task:    90000137   UserRef:    
                Date:   16/05/2001  Author:     Bruce Gruenbaum

  Update Notes: Fix FIND FIRST bttManager bug

-------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afcfgwritep.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Astra object identifying preprocessor */
&glob   AstraPlip    yes

DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.
DEFINE VARIABLE ghXMLHlpr           AS HANDLE    NO-UNDO.

ASSIGN cObjectName = "{&object-name}":U.

&scop   mip-notify-user-on-plip-close   NO

{src/adm2/globals.i}
{af/sup2/afxmlcfgtt.i
  &session-table = YES}
{checkerr.i &define-only = yes}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-addManager) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD addManager Procedure 
FUNCTION addManager RETURNS LOGICAL
  ( INPUT phRequiredManager AS HANDLE,
    INPUT plICFBound        AS LOGICAL,
    INPUT pcSessionType     AS CHARACTER,
    INPUT pcManagerName     AS CHARACTER,
    INPUT pdObjectObj       AS DECIMAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getManagerName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getManagerName Procedure 
FUNCTION getManagerName RETURNS CHARACTER
  (INPUT pdObjectObj AS DECIMAL,
   INPUT pcFileName  AS CHARACTER)  FORWARD.

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
         HEIGHT             = 27.95
         WIDTH              = 64.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

 

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  ******************************* */

{ry/app/ryplipmain.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-buildTempTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildTempTables Procedure 
PROCEDURE buildTempTables :
/*------------------------------------------------------------------------------
  Purpose:     Build the temp-tables that contain the data that we need to
               build the XML file.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcSessionTypes  AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plMinimum       AS LOGICAL    NO-UNDO.

  DEFINE BUFFER bgsm_session_type         FOR gsm_session_type.
  DEFINE BUFFER bttService                FOR ttService.

  DEFINE VARIABLE lICFBound               AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cMessage                AS CHARACTER  NO-UNDO.

  /* First lets populate the temp-tables */
  FOR EACH bgsm_session_type NO-LOCK
    WHERE CAN-DO(pcSessionTypes,bgsm_session_type.session_type_code):

    CREATE ttSession.
    ASSIGN
      ttSession.cSessionType = bgsm_session_type.session_type_code
      .

    /* We need to derive the list of session properties for a session from the
       parent's session properties and all the way up the chain so that we have
       set all the appropriate properties for later as we will may need to get
       the values of those properties later when we are building the remainder 
       of the configuration file - eg. bound_icfdb tells us that we must 
       read the DBBound managers rather than the non DBBound managers. */

    /* Derive Session Properties */
    RUN deriveProperties (bgsm_session_type.session_type_obj, bgsm_session_type.session_type_code, plMinimum). 

    /* Now that we have the properties we need to figure out what services need to 
       be added. These can also be derived from the parent. If we're making a database 
       connection to ICFDB and bound_icfdb has not been set, we will 
       assume later that we should be running the server side managers. */

    /* Derive Session Services */
    RUN deriveServices (bgsm_session_type.session_type_obj, bgsm_session_type.session_type_code, plMinimum). 


    /* Now we need to determine if this is a bound or unbound icfdb connection. There may already be a 
       property that has been set to provide this information. If so, we need to use that. If not, we 
       need to figure it out. No matter what happens, there will be a property for bound_icfdb that will 
       provide the appropriate value.
        */
    lICFBound = LOGICAL(getProperty(bgsm_session_type.session_type_code, "bound_icfdb":U)).

    IF lICFBound = ? THEN
    DO:
      lICFBound = NO.
      FOR EACH bttService NO-LOCK
        WHERE bttService.cSessionType =  bgsm_session_type.session_type_code
          AND bttService.cServiceName = "ICFDB":U:
        IF bttService.cServiceType = "Database":U THEN
        DO:
          lICFBound = YES.
          LEAVE.
        END.
      END.
    END.

    /* Set the property for bound_icfdb */
    setProperty(bgsm_session_type.session_type_code, 
                "bound_icfdb":U,
                STRING(lICFBound)).

    /* Now we need to add the managers that we need to the session. Connection manager
       and service type managers need to get added first. */
    /* Derive Managers */
    RUN deriveManagers (bgsm_session_type.session_type_obj, 
                        bgsm_session_type.session_type_code,
                        lICFBound,
                        plMinimum). 

  END. /* FOR EACH bgsm_session_type */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createXMLDoc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createXMLDoc Procedure 
PROCEDURE createXMLDoc :
/*------------------------------------------------------------------------------
  Purpose:     Reads the contents of the temp-tables and builds an XML document
               from them.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phNode AS HANDLE NO-UNDO.

  DEFINE VARIABLE hSessionNode  AS HANDLE   NO-UNDO.
  DEFINE VARIABLE hServicesNode  AS HANDLE   NO-UNDO.
  DEFINE VARIABLE hPropertiesNode  AS HANDLE   NO-UNDO.
  DEFINE VARIABLE hServiceNode  AS HANDLE   NO-UNDO.
  DEFINE VARIABLE hManagersNode  AS HANDLE   NO-UNDO.
  DEFINE VARIABLE hManagerNode  AS HANDLE   NO-UNDO.

  /* Loop through all the session records. */
  FOR EACH ttSession
    BREAK BY ttSession.cSessionType:

    /* Create the Session node */
    hSessionNode = DYNAMIC-FUNCTION("createElementNode":U IN ghXMLHlpr,
                                    phNode, 
                                    "session":U).
    /* Make sure the session type is specified */
    hSessionNode:SET-ATTRIBUTE("SessionType":U,ttSession.cSessionType).

    /* Create the Session node */
    hPropertiesNode = DYNAMIC-FUNCTION("createElementNode":U IN ghXMLHlpr,
                                       hSessionNode, 
                                       "properties":U).

    /* Create an element for each property */
    FOR EACH ttProperty
      WHERE ttProperty.cSessionType = ttSession.cSessionType:

      DYNAMIC-FUNCTION("setNodeElementValue":U IN ghXMLHlpr,
                       hPropertiesNode, 
                       ttProperty.cProperty,
                       ttProperty.cValue).

    END.

    /* Delete the Properties node as we are done with it */
    IF VALID-HANDLE(hPropertiesNode) THEN
    DO:
      DELETE OBJECT hPropertiesNode.
      hPropertiesNode = ?.
    END.

    hServicesNode = ?.

    /* Create a service for each ttService */
    FOR EACH ttService 
      WHERE ttService.cSessionType = ttSession.cSessionType
      BREAK BY ttService.cSessionType
            BY ttService.iOrder:

      /* Create the services node */
      IF FIRST-OF(ttService.cSessionType) THEN
      DO:
        hServicesNode = DYNAMIC-FUNCTION("createElementNode":U IN ghXMLHlpr,
                                         hSessionNode, 
                                         "services":U).
      END.

      /* Create a node for this service */
      hServiceNode = DYNAMIC-FUNCTION("createElementNode":U IN ghXMLHlpr,
                                       hServicesNode, 
                                       "service":U).
      DYNAMIC-FUNCTION("buildElementsFromBuffer":U IN ghXMLHlpr,
                       hServiceNode, 
                       INPUT BUFFER ttService:HANDLE,
                       "cServiceType,cServiceName,cPhysicalService,cConnectParams,lDefaultService,lCanRunLocal,lConnectAtStartup":U).

      DELETE OBJECT hServiceNode.
      hServiceNode = ?.
    END. /* FOR EACH ttService */

    /* set the services node handle to ? and delete it */
    IF VALID-HANDLE(hServicesNode) THEN
    DO:
      DELETE OBJECT hServicesNode.
      hServicesNode = ?.
    END.

    hManagersNode = ?.
    /* Create a manager for each ttManager */
    FOR EACH ttManager 
      WHERE ttManager.cSessionType = ttSession.cSessionType
      BREAK BY ttManager.cSessionType
            BY ttManager.iOrder:

      /* Create the Managers node */
      IF FIRST-OF(ttManager.cSessionType) THEN
      DO:
        hManagersNode = DYNAMIC-FUNCTION("createElementNode":U IN ghXMLHlpr,
                                         hSessionNode, 
                                         "managers":U).
      END.

      /* Create a node for this Manager */
      hManagerNode = DYNAMIC-FUNCTION("createElementNode":U IN ghXMLHlpr,
                                       hManagersNode, 
                                       "manager":U).
      DYNAMIC-FUNCTION("buildElementsFromBuffer":U IN ghXMLHlpr,
                       hManagerNode, 
                       INPUT BUFFER ttManager:HANDLE,
                       "cManagerName,cFileName,cHandleName":U).

      DELETE OBJECT hManagerNode.
      hManagerNode = ?.
    END. /* FOR EACH ttManager */

    /* set the Managers node handle to ? and delete it */
    IF VALID-HANDLE(hManagersNode) THEN
    DO:
      DELETE OBJECT hManagersNode.
      hManagersNode = ?.
    END.

    DELETE OBJECT hSessionNode.
    hSessionNode = ?.

  END.  /* FOR EACH ttSession */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deriveManagers) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deriveManagers Procedure 
PROCEDURE deriveManagers :
/*------------------------------------------------------------------------------
  Purpose:     
      This procedure derives all the managers to be used from the parent 
      session types that this session type is derived from.
      
  Parameters:  
      poParentObj   - the object ID of the parent session.
      pcSessionType - the session type to add these data for.
      plICFBound    - Indicates whether the session being set up is bound to
                      the repository - this decides the manager to be used.

  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER poParentObj   AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pcSessionType AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plICFBound    AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plMinimum     AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE cMessage    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cText       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iOrder      AS INTEGER    NO-UNDO.

  DEFINE BUFFER bgsm_session_type           FOR gsm_session_type.
  DEFINE BUFFER bgsm_required_manager       FOR gsm_required_manager.
  DEFINE BUFFER bgsc_manager_type           FOR gsc_manager_type.
  DEFINE BUFFER bgsc_service_type           FOR gsc_service_type.
  DEFINE BUFFER b_ConMgr                    FOR gsc_manager_type.
  DEFINE BUFFER bttManager                  FOR ttManager.


  /* First lets populate the temp-tables */
  FIND FIRST bgsm_session_type NO-LOCK
    WHERE bgsm_session_type.session_type_obj = poParentObj
    NO-ERROR.
  IF NOT AVAILABLE(bgsm_session_type) THEN
  DO:
    cMessage = {aferrortxt.i 'AF' '124' '?' '?' "'ConnectionManager Manager Type not specified'"}.
    RETURN cMessage.
  END.

  IF bgsm_session_type.extends_session_type_obj <> 0.0 AND
     bgsm_session_type.extends_session_type_obj <> ? THEN
    RUN deriveManagers (bgsm_session_type.extends_session_type_obj, pcSessionType, plICFBound, plMinimum).

  /* Now we need to add the managers for the connection and service type managers. These are
     special because their value is not derived from the same place as the regular managers. Find 
     out which is the connection manager's obj. Without the connection manager, nothing else will 
     work. As we need this for all the session types, we'll read this buffer here and hold onto it.
     */
  FIND FIRST b_ConMgr NO-LOCK
    WHERE b_ConMgr.manager_type_code = "ConnectionManager":U
    NO-ERROR.
  IF NOT AVAILABLE(b_ConMgr) THEN
  DO:
    cMessage = {aferrortxt.i 'AF' '124' '?' '?' "'ConnectionManager Manager Type not specified'"}.
    RETURN cMessage.
  END.

  /* See if we can find the manager procedure for the connection manager */
  FIND FIRST bgsm_required_manager NO-LOCK
    WHERE bgsm_required_manager.manager_type_obj = b_ConMgr.manager_type_obj
      AND bgsm_required_manager.session_type_obj = bgsm_session_type.session_type_obj
    NO-ERROR.
  IF NOT AVAILABLE(bgsm_required_manager) THEN
  DO:
    /* None of the parents have specified a connection manager, so we need to 
       see if one has already been specified. */                                                                
    FIND FIRST bttManager 
      WHERE bttManager.cSessionType = pcSessionType 
        AND bttManager.cManagerName = "ConnectionManager":U
      NO-ERROR.
    IF NOT AVAILABLE(bttManager) THEN
    DO:
      cText    = "ConnectionManager not specified for session type " + pcSessionType.
      cMessage = {aferrortxt.i 'AF' '124' '?' '?' "cText" }.
      RETURN cMessage.
    END.
  END.
  ELSE
    /* Add the connection manager to the list of managers */
    addManager(INPUT BUFFER bgsm_required_manager:HANDLE, 
               plICFBound,
               pcSessionType, 
               "":U, 
               0.0).

  /* We should always add the AppServer and Database connection managers */
  FOR EACH bgsc_service_type NO-LOCK:

    /* Add the manager object to the manager list */
    addManager(?,
               plICFBound,
               pcSessionType,
               bgsc_service_type.service_type_code + "ConnectionManager":U,
               bgsc_service_type.management_object_obj).

    /* Set the property for this connection manager */
    setProperty(pcSessionType,
                "ICFCM_":U + bgsc_service_type.service_type_code,
                bgsc_service_type.service_type_code + "ConnectionManager":U).
  END.

  /* Now just add the managers that are left over */
  mngr-loop:
  FOR EACH bgsm_required_manager NO-LOCK
    WHERE bgsm_required_manager.session_type_obj = bgsm_session_type.session_type_obj
    BY bgsm_required_manager.session_type_obj
    BY bgsm_required_manager.startup_order:

    /* We've already set up the connection manager, so skip it */
    IF bgsm_required_manager.manager_type_obj =  b_ConMgr.manager_type_obj THEN
      NEXT.

    IF plMinimum THEN
    DO:
      FIND FIRST bgsc_manager_type NO-LOCK
        WHERE bgsc_manager_type.manager_type_obj = bgsm_required_manager.manager_type_obj
        NO-ERROR.
      IF NOT AVAILABLE(bgsc_manager_type) OR
         NOT bgsc_manager_type.write_to_config THEN
        NEXT mngr-loop.
    END.

    addManager(INPUT BUFFER bgsm_required_manager:HANDLE, 
               plICFBound,
               pcSessionType, 
               "":U, 
               0.0).

  END. /* FOR EACH bgsm_required_manager */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deriveProperties) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deriveProperties Procedure 
PROCEDURE deriveProperties :
/*------------------------------------------------------------------------------
  Purpose:     
      This procedure derives all the properties to be used from the parent 
      session types that this session type is derived from.
      
  Parameters:  
      poParentObj   - the object ID of the parent session.
      pcSessionType - the session type to add these data for.
  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER poParentObj   AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pcSessionType AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plMinimum     AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE cMessage     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDateFormat  AS CHARACTER  NO-UNDO. 
  DEFINE VARIABLE cPropValue   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMinimumList AS CHARACTER  
    INITIAL "session_date_format,session_numeric_format,session_year_offset,run_local,root_directory":U
    NO-UNDO.
  DEFINE VARIABLE cLoginProc   AS CHARACTER  NO-UNDO.

  DEFINE BUFFER bgsm_session_type           FOR gsm_session_type.
  DEFINE BUFFER bgsm_session_type_property  FOR gsm_session_type_property.
  DEFINE BUFFER bgsc_session_property       FOR gsc_session_property.
  DEFINE BUFFER bgsc_global_control         FOR gsc_global_control.
  DEFINE BUFFER bgsc_security_control       FOR gsc_security_control.

  /* First lets populate the temp-tables */
  FIND FIRST bgsm_session_type NO-LOCK
    WHERE bgsm_session_type.session_type_obj = poParentObj
    NO-ERROR.
  IF NOT AVAILABLE(bgsm_session_type) THEN
  DO:
    cMessage = {aferrortxt.i 'AF' '124' '?' '?' "'ConnectionManager Manager Type not specified'"}.
    RETURN cMessage.
  END.

  IF bgsm_session_type.extends_session_type_obj <> 0.0 AND
     bgsm_session_type.extends_session_type_obj <> ? THEN
    RUN deriveProperties (bgsm_session_type.extends_session_type_obj, pcSessionType, plMinimum).

  /* Set the property for valid OS list */
  setProperty(pcSessionType,
              "valid_os_list":U,
              bgsm_session_type.valid_os_list).

  /* Set the property for physical session list */
  setProperty(pcSessionType,
              "physical_session_list":U,
              bgsm_session_type.physical_session_list).

  /* Now loop through the session property table */
  FOR EACH bgsc_session_property NO-LOCK:

    IF plMinimum AND
       NOT CAN-DO(cMinimumList, bgsc_session_property.session_property_name) THEN
      NEXT.

    /* This is a workaround. We need a way to ignore template session types and
       we implemented this property to support it. In a furture release this
       will be a field on gsm_session_type. We will also add a "private" flag 
       to the session_property table. That will mean that session properties that
       are private can not be inherited. In future, those will be skipped here. */
    IF bgsc_session_property.session_property_name = "session_type_template":U THEN
      NEXT.

    /* Try and find a specific bgsm_session_type property for this 
       session type */
    FIND FIRST bgsm_session_type_property NO-LOCK
      WHERE bgsm_session_type_property.session_property_obj = bgsc_session_property.session_property_obj
        AND bgsm_session_type_property.session_type_obj = bgsm_session_type.session_type_obj
      NO-ERROR.

    /* If we find one, set that property */
    IF AVAILABLE(bgsm_session_type_property) THEN
      setProperty(pcSessionType,
                  bgsc_session_property.session_property_name,
                  bgsm_session_type_property.property_value).

    /* If we don't find a specific entry for this session type and
       the property is supposed to always be used, set the property
       to the default value. */
    ELSE IF bgsc_session_property.always_used THEN
    DO:
      /* First check if there is a property in the property temp-table. If there
         is it may have been overridden by the parent, so we don't set it here. */
      cPropValue = getProperty(pcSessionType,
                               bgsc_session_property.session_property_name).
      IF cPropValue = ? OR
         cPropValue = "":U THEN
        setProperty(pcSessionType,
                    bgsc_session_property.session_property_name,
                    bgsc_session_property.default_property_value).
    END.

  END. /* FOR EACH bgsc_session_property */


  /* Now see if a session_date_format has been set. */
  cDateFormat = getProperty(pcSessionType,
                            "session_date_format":U).
  IF cDateFormat = ? OR
     cDateFormat = "":U THEN
  DO:
    FIND FIRST bgsc_global_control NO-LOCK
      NO-ERROR.
    IF AVAILABLE(bgsc_global_control) AND
      bgsc_global_control.date_format <> ? AND
      bgsc_global_control.date_format <> "":U THEN
      setProperty(pcSessionType,
                  "session_date_format":U,
                  bgsc_global_control.date_format).

  END.

  IF NOT plMinimum THEN
  DO:
    cLoginProc = getProperty(pcSessionType,
                             "login_procedure":U).
    IF cLoginProc = ? OR
       cLoginProc = "":U THEN
    DO:
      FIND FIRST bgsc_security_control NO-LOCK
        NO-ERROR.
      IF AVAILABLE(bgsc_security_control) AND
         bgsc_security_control.login_filename <> "":U AND
         bgsc_security_control.login_filename <> "":U THEN
        setProperty(pcSessionType,
                    "login_procedure":U,
                    bgsc_security_control.login_filename).
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deriveServices) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deriveServices Procedure 
PROCEDURE deriveServices :
/*------------------------------------------------------------------------------
  Purpose:     
      This procedure derives all the services to be used from the parent 
      session types that this session type is derived from.
      
  Parameters:  
      poParentObj   - the object ID of the parent session.
      pcSessionType - the session type to add these data for.
  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER poParentObj   AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pcSessionType AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plMinimum     AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE cMessage    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iOrder      AS INTEGER    NO-UNDO.

  DEFINE BUFFER bgsm_session_type           FOR gsm_session_type.
  DEFINE BUFFER bgsm_session_service        FOR gsm_session_service.
  DEFINE BUFFER bgsm_physical_service       FOR gsm_physical_service.
  DEFINE BUFFER bgsc_logical_service        FOR gsc_logical_service.
  DEFINE BUFFER bgsc_service_type           FOR gsc_service_type.

  /* First lets populate the temp-tables */
  FIND FIRST bgsm_session_type NO-LOCK
    WHERE bgsm_session_type.session_type_obj = poParentObj
    NO-ERROR.
  IF NOT AVAILABLE(bgsm_session_type) THEN
  DO:
    cMessage = {aferrortxt.i 'AF' '124' '?' '?' "'ConnectionManager Manager Type not specified'"}.
    RETURN cMessage.
  END.

  IF bgsm_session_type.extends_session_type_obj <> 0.0 AND
     bgsm_session_type.extends_session_type_obj <> ? THEN
    RUN deriveServices (bgsm_session_type.extends_session_type_obj, pcSessionType, plMinimum).

  /* Create a ttService record for each of the services that need to be started. */
  FOR EACH bgsm_session_service NO-LOCK
    WHERE bgsm_session_service.session_type_obj = bgsm_session_type.session_type_obj:

    /* Find the logical service */
    FIND FIRST bgsc_logical_service NO-LOCK
      WHERE bgsc_logical_service.logical_service_obj = bgsm_session_service.logical_service_obj
      NO-ERROR.
    IF NOT AVAILABLE(bgsc_logical_service) OR
       (NOT bgsc_logical_service.write_to_config AND
        plMinimum) THEN
      NEXT.

    /* Find the physical service */
    FIND FIRST bgsm_physical_service NO-LOCK
      WHERE bgsm_physical_service.physical_service_obj = bgsm_session_service.physical_service_obj
      NO-ERROR.
    IF NOT AVAILABLE(bgsm_physical_service) THEN
      NEXT.

    /* Now find the service type */
    FIND FIRST bgsc_service_type NO-LOCK
      WHERE bgsc_service_type.service_type_obj = bgsc_logical_service.service_type_obj
      NO-ERROR.
    IF NOT AVAILABLE(bgsc_service_type) THEN
      NEXT.

    FIND FIRST ttService 
      WHERE ttService.cSessionType = pcSessionType
        AND ttService.cServiceName = bgsc_logical_service.logical_service_code
      NO-ERROR.

    IF NOT AVAILABLE(ttService) THEN
    DO:
      iOrder = getNextOrderNum(INPUT BUFFER ttService:HANDLE,
                               pcSessionType).
      CREATE ttService.
      ASSIGN
        ttService.cSessionType      = pcSessionType
        ttService.iOrder            = iOrder
        ttService.cServiceType      = bgsc_service_type.service_type_code
        ttService.cServiceName      = bgsc_logical_service.logical_service_code
        ttService.cPhysicalService  = bgsm_physical_service.physical_service_code
        ttService.cConnectParams    = bgsm_physical_service.connection_parameters
        ttService.lDefaultService   = bgsc_logical_service.logical_service_obj = bgsc_service_type.default_logical_service_obj
        ttService.lCanRunLocal      = bgsc_logical_service.can_run_locally
        ttService.lConnectAtStartup = bgsc_logical_service.CONNECT_at_startup
        .
    END.
    ELSE
    DO:
      ASSIGN
        ttService.cPhysicalService  = bgsm_physical_service.physical_service_code
        ttService.cConnectParams    = bgsm_physical_service.connection_parameters
        ttService.lDefaultService   = bgsc_logical_service.logical_service_obj = bgsc_service_type.default_logical_service_obj
        ttService.lCanRunLocal      = bgsc_logical_service.can_run_locally
        ttService.lConnectAtStartup = bgsc_logical_service.CONNECT_at_startup
        .
    END.
  END. /* FOR EACH bgsm_session_service */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTempTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTempTables Procedure 
PROCEDURE getTempTables :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER TABLE FOR ttSession.
  DEFINE OUTPUT PARAMETER TABLE FOR ttProperty.
  DEFINE OUTPUT PARAMETER TABLE FOR ttService.
  DEFINE OUTPUT PARAMETER TABLE FOR ttManager.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-killPlip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE killPlip Procedure 
PROCEDURE killPlip :
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

&IF DEFINED(EXCLUDE-objectDescription) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE objectDescription Procedure 
PROCEDURE objectDescription :
/*------------------------------------------------------------------------------
  Purpose:     Pass out a description of the PLIP, used in Plip temp-table
  Parameters:  <none>
  Notes:       This should be changed manually for each plip
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER cDescription AS CHARACTER NO-UNDO.

ASSIGN cDescription = "Dynamics XML Config PLIP".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipSetup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipSetup Procedure 
PROCEDURE plipSetup :
/*------------------------------------------------------------------------------
  Purpose:    Run by main-block of PLIP at startup of PLIP
  Parameters: <none>
  Notes:       
------------------------------------------------------------------------------*/

{ry/app/ryplipsetu.i}


{aflaunch.i &PLIP = 'af/app/afxmlhlprp.p'
            &IProc = ''
            &OnApp = 'NO'}

ghXMLHlpr = hPlip.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipShutdown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipShutdown Procedure 
PROCEDURE plipShutdown :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will be run just before the calling program 
               terminates
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF VALID-HANDLE(ghXMLHlpr) THEN
    RUN killPlip IN ghXMLHlpr.

  {ry/app/ryplipshut.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-writeConfigXML) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE writeConfigXML Procedure 
PROCEDURE writeConfigXML :
/*------------------------------------------------------------------------------
  Purpose:     This procedure prepares an XML document containing the data to 
               be written to the file system as the ICFCONFIG.XML file.
               The XML document is then either written to a file as specified
               in the pcFileName parameter or it is written to the MEMPTR
               and returned as a MEMPTR to the client who is then responsible
               for writing out the document to a file.
  Parameters:
    pcSessionTypes - Contains a comma separated list of session types to 
                     write out in CAN-DO format.
    pcFileName     - The name of the file to write the XML document to. If
                     <MEMPTR>, the contents are returned in pmXMLDoc.
    plMinimum      - Indicates whether a full XML file should be generated.
    pmXMLDoc       - A MEMPTR parameter to contain the document to be returned.

  Notes:
    This procedure can only be run from inside the framework. It is thus 
    assumed that the framework is running when this file is generated.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcSessionTypes  AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcFileName      AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plMinimum       AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER pmXMLDoc        AS MEMPTR     NO-UNDO.

  DEFINE VARIABLE hXMLDoc     AS HANDLE   NO-UNDO.
  DEFINE VARIABLE hRootNode   AS HANDLE   NO-UNDO.
  DEFINE VARIABLE cRetMessage AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessage    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lAns        AS LOGICAL    NO-UNDO.

  EMPTY TEMP-TABLE ttProperty.
  EMPTY TEMP-TABLE ttService.
  EMPTY TEMP-TABLE ttManager.
  EMPTY TEMP-TABLE ttSession.

  RUN buildTempTables (pcSessionTypes, plMinimum).

  CREATE X-DOCUMENT hXMLDoc.

  hXMLDoc:ENCODING = "utf-8":U.

  /* Create a root node */
  hRootNode = DYNAMIC-FUNCTION("createElementNode":U IN ghXMLHlpr,
                               hXMLDoc, 
                               "sessions":U).

  RUN createXMLDoc (hRootNode).
  {afcheckerr.i &no-return = YES}

  IF cMessageList <> "":U THEN
    cRetMessage = cRetMessage + CHR(3) + cMessageList.


  /* Now save away the XML document. If the value of pcFileName is 
     <MEMPTR>, save the XML document to a memptr, otherwise save
     it to the filename specified. */

  ERROR-STATUS:ERROR = NO.
  IF cRetMessage = "":U THEN
  DO:
    IF pcFileName = "<MEMPTR>":U THEN
    DO:
      SET-SIZE(pmXMLDoc) = 0. 
      lAns =  hXMLDoc:SAVE("MEMPTR":U,pmXMLDoc) NO-ERROR.
      cMessage = "to memory pointer":U.
    END.
    ELSE
    DO:
      lAns = hXMLDoc:SAVE("FILE",pcFileName) NO-ERROR.
      cMessage = pcFileName.
    END.
    {af/sup2/afcheckerr.i
      &errors-not-zero = YES
      &no-return = YES}
    IF cMessageList <> "":U OR 
       NOT lAns THEN
      cRetMessage = cRetMessage + CHR(3) + 
                    {af/sup2/aferrortxt.i 'AF' '117' '?' '?' 'save' cMessage cMessageList}.
  END.

  DELETE OBJECT hRootNode.
  DELETE OBJECT hXMLDoc.

  IF cRetMessage <> "":U THEN
    RETURN cRetMessage.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-addManager) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION addManager Procedure 
FUNCTION addManager RETURNS LOGICAL
  ( INPUT phRequiredManager AS HANDLE,
    INPUT plICFBound        AS LOGICAL,
    INPUT pcSessionType     AS CHARACTER,
    INPUT pcManagerName     AS CHARACTER,
    INPUT pdObjectObj       AS DECIMAL ) :
/*------------------------------------------------------------------------------
  Purpose:     Adds a manager to the Managers table
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE BUFFER bttManager       FOR ttManager.
  DEFINE BUFFER bgsc_Manager     FOR gsc_manager_type.
  DEFINE BUFFER bgsm_Session     FOR gsm_session_type.

  DEFINE VARIABLE hSessionObj AS HANDLE   NO-UNDO.
  DEFINE VARIABLE hObjectObj  AS HANDLE   NO-UNDO.
  DEFINE VARIABLE hManagerObj AS HANDLE   NO-UNDO.

  DEFINE VARIABLE cFileName     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSessionType  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cManagerName  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cHandleName   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dObjectObj    AS DECIMAL DECIMALS 9   NO-UNDO.

  DEFINE VARIABLE iOrder    AS INTEGER    NO-UNDO.

  /* If the buffer handle was specified, read the data from the database. */
  IF VALID-HANDLE(phRequiredManager) THEN
  DO:
    /* Get the obj fields for the related tables */

    hSessionObj = phRequiredManager:BUFFER-FIELD("session_type_obj":U).
    hManagerObj = phRequiredManager:BUFFER-FIELD("manager_type_obj":U).

    IF pcSessionType <> "":U THEN
    DO:
      cSessionType = pcSessionType.
    END.
    ELSE
    DO:
      /* Get the session type record */
      FIND FIRST bgsm_Session NO-LOCK
        WHERE bgsm_Session.session_type_obj = hSessionObj:BUFFER-VALUE
        NO-ERROR.
      IF NOT AVAILABLE(bgsm_Session) THEN
        RETURN FALSE.
      cSessionType = bgsm_Session.session_type_code.
    END.

    /* Get the manager type record */
    FIND FIRST bgsc_Manager NO-LOCK
      WHERE bgsc_Manager.manager_type_obj = hManagerObj:BUFFER-VALUE
      NO-ERROR.
    IF NOT AVAILABLE(bgsc_Manager) THEN
      RETURN FALSE.

    ASSIGN
      cManagerName = bgsc_Manager.manager_type_code
      cHandleName  = bgsc_Manager.static_handle
      dObjectObj   = (IF plICFBound THEN bgsc_Manager.db_bound_smartobject_obj ELSE bgsc_Manager.db_unbound_smartobject_obj)
      .
  END.
  /* Otherwise read the data from the input parameters */
  ELSE
  DO:
    ASSIGN
      cSessionType = pcSessionType
      cManagerName = pcManagerName
      cHandleName  = "NON":U
      dObjectObj   = pdObjectObj
      .
  END.

  cFileName = getManagerName(dObjectObj, "":U).

  IF cFileName = "":U OR
     cFileName = ? THEN
    RETURN FALSE.

  /* Add this manager to the table */                                                                
  FIND FIRST bttManager 
    WHERE bttManager.cSessionType = cSessionType 
      AND bttManager.cManagerName = cManagerName
    NO-ERROR.

  IF NOT AVAILABLE(bttManager) THEN
  DO TRANSACTION:
    iOrder = getNextOrderNum(INPUT BUFFER bttManager:HANDLE,cSessionType).
    CREATE bttManager.
    ASSIGN
      bttManager.cSessionType = cSessionType
      bttManager.cManagerName = cManagerName
      bttManager.cHandleName  = cHandleName
      bttManager.cFileName    = cFileName
      bttManager.iOrder       = iOrder
    .
  END.

  ERROR-STATUS:ERROR = NO.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getManagerName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getManagerName Procedure 
FUNCTION getManagerName RETURNS CHARACTER
  (INPUT pdObjectObj AS DECIMAL,
   INPUT pcFileName  AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Retrieves a manager and all its super procedures and returns a 
            CHR(3) list of names to the caller.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFileName         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFileToGet        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSuperProcedures  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cExtension        AS CHARACTER  NO-UNDO.

  DEFINE BUFFER bryc_smartobject      FOR ryc_smartobject.
  DEFINE BUFFER bryc_attribute_value  FOR ryc_attribute_value.

  IF pdObjectObj = 0.0 AND
     (pcFileName = "":U OR
      pcFileName = ?) THEN
    RETURN "":U.
  
  IF pdObjectObj <> 0.0 THEN
  DO:
    /* Get the ryc_smartobject record to base this on */
    FIND FIRST bryc_smartobject NO-LOCK
         WHERE bryc_smartobject.smartobject_obj = pdObjectObj
         NO-ERROR.
    IF NOT AVAILABLE(bryc_smartobject) THEN
      RETURN "":U.
  END.
  ELSE
  DO:
    ASSIGN
      cFileToGet = REPLACE(pcFileName,"~\":U,"/":U)
      cFileToGet = ENTRY(NUM-ENTRIES(cFileToGet,"/":U),cFileToGet,"/":U)
    .
    IF cFileToGet <> "":U THEN
    DO:
      FIND FIRST bryc_smartobject NO-LOCK
        WHERE bryc_smartobject.object_filename = cFileToGet
          AND bryc_smartobject.customization_result_obj = 0.00 /* we don't support customization like this */
        NO-ERROR.
      IF NOT AVAILABLE(bryc_smartobject) AND
         R-INDEX(cFileToGet, ".":U) > 0 THEN
      DO:
        cExtension = ENTRY(NUM-ENTRIES(cFileToGet,".":U),cFileToGet,".":U).
        cFileToGet = SUBSTRING(cFileToGet,1,R-INDEX(cFileToGet, ".":U) - 1).
        FIND FIRST bryc_smartobject NO-LOCK
          WHERE bryc_smartobject.object_filename          = cFileToGet
            AND bryc_smartobject.customization_result_obj = 0.00 /* we don't support customization like this */
            AND bryc_smartobject.object_extension         = cExtension
          NO-ERROR.
      END.
    END.
    IF NOT AVAILABLE(bryc_smartobject) THEN
      RETURN pcFileName.
  END.

  /* Build up the filename */
  cFileName = bryc_smartobject.object_path 
            + (IF bryc_smartobject.object_path <> "":U THEN "/":U ELSE "":U)
            + bryc_smartobject.object_filename
            + (IF bryc_smartobject.object_extension <> "":U THEN "." + bryc_smartobject.object_extension ELSE "":U).


  /* Now we need to see if this procedure has a super procedure. */
  FIND FIRST bryc_attribute_value NO-LOCK
    WHERE bryc_attribute_value.object_type_obj      = bryc_smartobject.object_type_obj
      AND bryc_attribute_value.smartobject_obj      = bryc_smartobject.smartobject_obj
      AND bryc_attribute_value.object_instance_obj  = 0.00
      AND bryc_attribute_value.render_type_obj      = 0.00
      AND bryc_attribute_value.attribute_label      = "SuperProcedure":U
    NO-ERROR.
  IF AVAILABLE(bryc_attribute_value) AND
     bryc_attribute_value.character_value <> "":U AND
     bryc_attribute_value.character_value <> ? THEN
  DO:
    cSuperProcedures = getManagerName(0.00, bryc_attribute_value.character_value).
    IF cSuperProcedures <> ? AND
       cSuperProcedures <> "":U THEN
      cFileName = cFileName + CHR(3) + cSuperProcedures.
  END.

  RETURN cFileName.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

