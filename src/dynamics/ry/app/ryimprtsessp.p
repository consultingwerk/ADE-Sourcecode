&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
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
/*---------------------------------------------------------------------------------
  File: ryimprtsessp.p

  Description:  Session Import procedure

  Purpose:      Takes the temp-tables that define a session type and imports them into the
                repository.

  Parameters:   pcSessionList - List of sessions to import
                plOWManagers  - Overwrite Managers?
                plOWLogSrv    - Overwrite Logical Services?
                plOWPhysSrv   - Overwrite Physical Services?
                ttProperty    - ttProperty temp-table
                ttManager     - ttManager temp-table
                ttService     - ttService temp-table
                
                If plOWManagers is set to yes, we will replace the manager settings on
                the gsc_manager_type table with the values in the XML file, otherwise
                we will accept the value in the database as correct.
                
                If plOWLogSrv is set to yes, we replace the logical service information with 
                the information in the XML file.
                
                The temp-tables should previously have been populated by a call into the
                XML file load procedure.

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   09/11/2003  Author:     Bruce S Gruenbaum

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/
{af/sup2/afxmlcfgtt.i}

/* ***************************  Parameters   ************************** */
  DEFINE INPUT  PARAMETER pcSessionList AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plOWManagers  AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plOWLogSrv    AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plOWPhysSrv   AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER TABLE FOR ttProperty.
  DEFINE INPUT  PARAMETER TABLE FOR ttService.
  DEFINE INPUT  PARAMETER TABLE FOR ttManager.

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       ryimprtsessp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}

  DEFINE VARIABLE gcServiceList   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE gcSTManagerList AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE gcImport        AS CHARACTER
    INITIAL "**(IMPORT) - ":U
    NO-UNDO.


DEFINE TEMP-TABLE ttSession NO-UNDO 
  FIELD cSessionType AS CHARACTER
  FIELD lLoadSession AS LOGICAL
  INDEX pudx IS PRIMARY UNIQUE
     cSessionType
  INDEX dx 
    lLoadSession
  .

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
         HEIGHT             = 32.57
         WIDTH              = 46.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

RUN validateParameters.

RUN importSessions NO-ERROR.
IF ERROR-STATUS:ERROR OR 
   (RETURN-VALUE <> "":U AND
    RETURN-VALUE <> ?) THEN
  RETURN ERROR RETURN-VALUE.
ELSE
  RETURN "":U.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-applyManagers) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyManagers Procedure 
PROCEDURE applyManagers :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcSession         AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER poSessionObj      AS DECIMAL    NO-UNDO.
  
  DEFINE BUFFER bttManager                  FOR ttManager.
  DEFINE BUFFER bttService                  FOR ttService.
  DEFINE BUFFER bgsc_manager_type           FOR gsc_manager_type.
  DEFINE BUFFER bgsm_required_manager       FOR gsm_required_manager.

  DEFINE VARIABLE iOrder                    AS INTEGER    NO-UNDO.

  FOR EACH bgsm_required_manager NO-LOCK
    WHERE bgsm_required_manager.session_type_obj = poSessionObj
       BY bgsm_required_manager.startup_order DESCENDING:
    ASSIGN
      iOrder = bgsm_required_manager.startup_order
      .
    LEAVE.
  END.

  /* Loop through all the managers that apply to this session type. */
  FOR EACH bttManager NO-LOCK
    WHERE bttManager.cSessionType = pcSession:

    /* Start a transaction. If anything goes wrong, we need to back out completely */
    DO TRANSACTION ON ERROR UNDO, RETURN ERROR RETURN-VALUE:

      /* If this is a service type manager, skip it. We don't write these here. */
      IF CAN-DO(gcSTManagerList, bttManager.cManagerName) THEN
        NEXT.

      /* Find a ryc_smartobject for this procedure */
      ASSIGN
        cFilename = REPLACE(bttManager.cFilename, "~\":U, "/":U)
      .
      IF NUM-ENTRIES(cFilename,"/":U) > 0 THEN
        ASSIGN
          cFilename = ENTRY(NUM-ENTRIES(cFilename,"/":U), cFilename,"/":U)
        .

      /* Find the manager type. */
      FIND FIRST bgsc_manager_type EXCLUSIVE-LOCK
        WHERE bgsc_manager_type.manager_type_code = bttManager.cManagerName
        NO-ERROR.

      IF NOT AVAILABLE(bgsc_manager_type) THEN
      DO:
        CREATE bgsc_manager_type NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
          RETURN ERROR RETURN-VALUE.
        ASSIGN
          bgsc_manager_type.manager_type_code        = bttManager.cManagerName
          bgsc_manager_type.manager_type_name        = gcImport + bttManager.cManagerName
          bgsc_manager_type.write_to_config          = yes
          bgsc_manager_type.static_handle            = bttManager.cHandleName
          NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
          RETURN ERROR RETURN-VALUE.
        
        VALIDATE bgsc_manager_type NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
          RETURN ERROR RETURN-VALUE.
      END.
      ELSE IF plOWManagers THEN
      DO:
        IF bgsc_manager_type.write_to_config <> yes OR
           bgsc_manager_type.static_handle   <> bttManager.cHandleName THEN
        DO:
          IF NOT (LENGTH(bgsc_manager_type.manager_type_name) > LENGTH(gcImport) AND
                  SUBSTRING(bgsc_manager_type.manager_type_name, 1, LENGTH(gcImport)) = gcImport) THEN
            ASSIGN
              bgsc_manager_type.manager_type_name = gcImport + bgsc_manager_type.manager_type_name
            .
          ASSIGN
            bgsc_manager_type.write_to_config          = yes
            bgsc_manager_type.static_handle            = bttManager.cHandleName
            NO-ERROR.
          IF ERROR-STATUS:ERROR THEN
            RETURN ERROR RETURN-VALUE.

          VALIDATE bgsc_manager_type NO-ERROR.
          IF ERROR-STATUS:ERROR THEN
            RETURN ERROR RETURN-VALUE.
        END.
      END.

      FIND FIRST bgsm_required_manager EXCLUSIVE-LOCK
        WHERE bgsm_required_manager.manager_type_obj = bgsc_manager_type.manager_type_obj
          AND bgsm_required_manager.session_type_obj = poSessionObj
        NO-ERROR.

      IF NOT AVAILABLE(bgsm_required_manager) THEN
      DO:
        CREATE bgsm_required_manager NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
          RETURN ERROR RETURN-VALUE.
        ASSIGN
          iOrder = iOrder + 1
          bgsm_required_manager.manager_type_obj = bgsc_manager_type.manager_type_obj
          bgsm_required_manager.session_type_obj = poSessionObj
          bgsm_required_manager.startup_order    = iOrder
          NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
          RETURN ERROR RETURN-VALUE.
        
        VALIDATE bgsm_required_manager NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
          RETURN ERROR RETURN-VALUE.
      END.

    END. /* DO TRANSACTION */

  END. /* FOR EACH bttManager NO-LOCK */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-applyServices) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyServices Procedure 
PROCEDURE applyServices :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcSession         AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER poSessionObj      AS DECIMAL    NO-UNDO.

  DEFINE BUFFER bttService                  FOR ttService.
  DEFINE BUFFER bgsc_logical_service        FOR gsc_logical_service.
  DEFINE BUFFER bgsm_physical_service       FOR gsm_physical_service.
  DEFINE BUFFER bgsc_service_type           FOR gsc_service_type.
  DEFINE BUFFER bgsm_session_service        FOR gsm_session_service.

  DEFINE QUERY qService FOR bgsm_physical_service.

  DEFINE VARIABLE lCreateNewPhys            AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lDup                      AS LOGICAL    NO-UNDO.

  /* Loop through all the managers that apply to this session type. */
  FOR EACH bttService NO-LOCK
    WHERE bttService.cSessionType = pcSession:

    /* Start a transaction. If anything goes wrong, we need to back out completely */
    DO TRANSACTION ON ERROR UNDO, RETURN ERROR RETURN-VALUE:

      /* First make sure the service type exists. */
      FIND FIRST bgsc_service_type EXCLUSIVE-LOCK
        WHERE bgsc_service_type.service_type_code = bttService.cServiceType
          NO-ERROR.
      IF NOT AVAILABLE(bgsc_service_type) THEN
      DO:
        CREATE bgsc_service_type NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
          RETURN ERROR RETURN-VALUE.

        ASSIGN
          bgsc_service_type.service_type_code         = bttService.cServiceType
          bgsc_service_type.service_type_description  = gcImport + bttService.cServiceType
          NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
          RETURN ERROR RETURN-VALUE.

        VALIDATE bgsc_service_type NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
          RETURN ERROR RETURN-VALUE.
      END.

      /* Find the logical service */
      FIND FIRST bgsc_logical_service EXCLUSIVE-LOCK
        WHERE bgsc_logical_service.logical_service_code = bttService.cServiceName
        NO-ERROR.
      IF NOT AVAILABLE(bgsc_logical_service) THEN
      DO:
        CREATE bgsc_logical_service NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
          RETURN ERROR RETURN-VALUE.

        ASSIGN
          bgsc_logical_service.logical_service_code        = bttService.cServiceName
          bgsc_logical_service.logical_service_description = gcImport + bttService.cServiceName
          bgsc_logical_service.service_type_obj            = bgsc_service_type.service_type_obj
          bgsc_logical_service.can_run_locally             = bttService.lCanRunLocal
          bgsc_logical_service.connect_at_startup          = bttService.lConnectAtStartup
          bgsc_logical_service.system_owned                = no
          bgsc_logical_service.write_to_config             = yes
          NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
          RETURN ERROR RETURN-VALUE.

        VALIDATE bgsc_logical_service NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
          RETURN ERROR RETURN-VALUE.

      END.
      ELSE IF plOWLogSrv THEN
      DO:
        IF bgsc_logical_service.service_type_obj <> bgsc_service_type.service_type_obj OR
           bgsc_logical_service.can_run_locally  <> bttService.lCanRunLocal OR
            bgsc_logical_service.connect_at_startup <> bttService.lConnectAtStartup OR
           bgsc_logical_service.system_owned     <> no OR
           bgsc_logical_service.write_to_config  <> yes THEN
        DO:
          IF NOT (LENGTH(bgsc_logical_service.logical_service_description) > LENGTH(gcImport) AND
                  SUBSTRING(bgsc_logical_service.logical_service_description, 1, LENGTH(gcImport)) = gcImport) THEN
            ASSIGN
              bgsc_logical_service.logical_service_description = gcImport + bgsc_logical_service.logical_service_description
            .
          ASSIGN
            bgsc_logical_service.service_type_obj            = bgsc_service_type.service_type_obj
            bgsc_logical_service.can_run_locally             = bttService.lCanRunLocal
            bgsc_logical_service.connect_at_startup          = bttService.lConnectAtStartup
            bgsc_logical_service.system_owned                = no
            bgsc_logical_service.write_to_config             = yes
            NO-ERROR.
          IF ERROR-STATUS:ERROR THEN
            RETURN ERROR RETURN-VALUE.
  
          VALIDATE bgsc_logical_service NO-ERROR.
          IF ERROR-STATUS:ERROR THEN
            RETURN ERROR RETURN-VALUE.
        END.
      END.

      /* Deal with the physical service. The big difference with this one is that
         if the physical service already exists*/
      lCreateNewPhys = NO.
      lDup = NO.
      FIND FIRST bgsm_physical_service EXCLUSIVE-LOCK
        WHERE bgsm_physical_service.physical_service_code = bttService.cPhysicalService
        NO-ERROR.

      IF NOT AVAILABLE(bgsm_physical_service) THEN
        lCreateNewPhys = YES.
      ELSE
      DO:
        IF bgsm_physical_service.service_type_obj <> bgsc_service_type.service_type_obj OR
           bgsm_physical_service.connection_parameters <> bttService.cConnectParams THEN
        DO:
          IF NOT plOWPhysSrv THEN
          DO:      
            OPEN QUERY qService
              FOR EACH bgsm_physical_service EXCLUSIVE-LOCK
                 WHERE bgsm_physical_service.service_type_obj = bgsc_service_type.service_type_obj
                   AND bgsm_physical_service.physical_service_code BEGINS bttService.cPhysicalService
                   AND bgsm_physical_service.physical_service_code <> bttService.cPhysicalService
                   AND bgsm_physical_service.connection_parameters = bttService.cConnectParams.

            GET FIRST qService EXCLUSIVE-LOCK.
            ERROR-STATUS:ERROR = NO.
            CLOSE QUERY qService.
            IF NOT AVAILABLE(bgsm_physical_service) THEN
              ASSIGN
                lCreateNewPhys = YES
                lDup           = YES
              .
          END.
          ELSE
          DO:
            IF NOT (LENGTH(bgsm_physical_service.physical_service_description) > LENGTH(gcImport) AND
                    SUBSTRING(bgsm_physical_service.physical_service_description, 1, LENGTH(gcImport)) = gcImport) THEN
              ASSIGN
                bgsm_physical_service.physical_service_description = gcImport + bgsm_physical_service.physical_service_description
              .
            ASSIGN
              bgsm_physical_service.service_type_obj      = bgsc_service_type.service_type_obj
              bgsm_physical_service.connection_parameters = bttService.cConnectParams
              NO-ERROR.
            IF ERROR-STATUS:ERROR THEN
              RETURN ERROR RETURN-VALUE.

            VALIDATE bgsm_physical_service NO-ERROR.
            IF ERROR-STATUS:ERROR THEN
              RETURN ERROR RETURN-VALUE.

          END.
        END.
      END.

      IF lCreateNewPhys THEN
      DO:
        CREATE bgsm_physical_service NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
          RETURN ERROR RETURN-VALUE.
        ASSIGN
          bgsm_physical_service.physical_service_code        = bttService.cPhysicalService + (IF lDup THEN "-":U + STRING(bgsm_physical_service.physical_service_obj) ELSE "":U)
          bgsm_physical_service.physical_service_description = gcImport + bttService.cPhysicalService
          bgsm_physical_service.service_type_obj             = bgsc_service_type.service_type_obj 
          bgsm_physical_service.connection_parameters        = bttService.cConnectParams
          NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
          RETURN ERROR RETURN-VALUE.

        VALIDATE bgsm_physical_service NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
          RETURN ERROR RETURN-VALUE.
      END.

      /* Finally, create the appropriate session service if applicable. */
      FIND FIRST bgsm_session_service EXCLUSIVE-LOCK
        WHERE bgsm_session_service.session_type_obj     = poSessionObj
          AND bgsm_session_service.logical_service_obj  = bgsc_logical_service.logical_service_obj
        NO-ERROR.
      IF NOT AVAILABLE(bgsm_session_service) THEN
      DO:
        CREATE bgsm_session_service NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
          RETURN ERROR RETURN-VALUE.
        ASSIGN
          bgsm_session_service.session_type_obj     = poSessionObj                              
          bgsm_session_service.logical_service_obj  = bgsc_logical_service.logical_service_obj  
          bgsm_session_service.physical_service_obj = bgsm_physical_service.physical_service_obj
          NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
          RETURN ERROR RETURN-VALUE.
        VALIDATE bgsm_session_service NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
          RETURN ERROR RETURN-VALUE.

      END.
    END. /* DO TRANSACTION */
  END. /* FOR EACH bttService NO-LOCK */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-importSessions) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE importSessions Procedure 
PROCEDURE importSessions :
/*------------------------------------------------------------------------------
  Purpose:     Loop through the sessions that we need to load and add them to
               to the gsm_session_type table. 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  &SCOPED-DEFINE SKIP-LIST "valid_os_list,physical_session_list":U
  DEFINE BUFFER bgsm_session_type           FOR gsm_session_type.    
  DEFINE BUFFER bgsc_session_property       FOR gsc_session_property.
  DEFINE BUFFER bgsm_session_type_property  FOR gsm_session_type_property.
  DEFINE BUFFER bttSession                  FOR ttSession.
  DEFINE BUFFER bttProperty                 FOR ttProperty.
  DEFINE BUFFER bttService                  FOR ttService.
    
  DEFINE VARIABLE cSTManager      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount          AS INTEGER    NO-UNDO.

  /* Before this call was made we have created records in the ttSession temp-table
     and noted which ones we want to import. No we need to loop through all the
     sessions that we want to import and suck them in. */
  FOR EACH bttSession NO-LOCK
    WHERE bttSession.lLoadSession:

    /* Start a transaction. If anything goes wrong, we need to back out completely */
    DO TRANSACTION ON ERROR UNDO, RETURN ERROR RETURN-VALUE:

      /* Try and find a session type for this session, creating it if it doesn't exist. */
      FIND FIRST bgsm_session_type EXCLUSIVE-LOCK
        WHERE bgsm_session_type.session_type_code = bttSession.cSessionType
        NO-ERROR.
      IF NOT AVAILABLE(bgsm_session_type) THEN
      DO:
        CREATE bgsm_session_type.
        ASSIGN
          bgsm_session_type.session_type_code        = bttSession.cSessionType
          bgsm_session_type.session_type_description = gcImport + bttSession.cSessionType
        .
      END.

      /* The value of the following fields are generated into properties by the 
         configuration file generator. Here we retrieve them from those properties. */
      ASSIGN
        bgsm_session_type.valid_os_list            = getProperty(bttSession.cSessionType, "valid_os_list":U)
        bgsm_session_type.physical_session_list    = getProperty(bttSession.cSessionType, "physical_session_list":U)
      .

      VALIDATE bgsm_session_type NO-ERROR.
      IF ERROR-STATUS:ERROR THEN
        UNDO, RETURN ERROR RETURN-VALUE.

      /* Now we loop through all the properties and import them. */
      FOR EACH bttProperty NO-LOCK
        WHERE bttProperty.cSessionType = bttSession.cSessionType:

        /* Ignore any properties in the skip list */
        IF CAN-DO({&SKIP-LIST}, bttProperty.cProperty) THEN
          NEXT.

        /* Ignore any properties that are auto-generated into the config.xml 
           file */
        IF LENGTH(bttProperty.cProperty) > 6 AND
           SUBSTRING(bttProperty.cProperty,1,6) = "ICFCM_":U THEN
          NEXT.

        /* Check to see if a session property record exists for this property and create it if 
           necessary */
        FIND FIRST bgsc_session_property EXCLUSIVE-LOCK
          WHERE bgsc_session_property.session_property_name = bttProperty.cProperty
          NO-ERROR.
        IF NOT AVAILABLE(bgsc_session_property) THEN
        DO:
          CREATE bgsc_session_property NO-ERROR.
          IF ERROR-STATUS:ERROR THEN
            UNDO, RETURN ERROR RETURN-VALUE.
          ASSIGN
            bgsc_session_property.session_property_name        = bttProperty.cProperty
            bgsc_session_property.session_property_description = gcImport + bttProperty.cProperty
            bgsc_session_property.system_owned                 = no
            bgsc_session_property.always_used                  = no
            NO-ERROR.
          IF ERROR-STATUS:ERROR THEN
            UNDO, RETURN ERROR RETURN-VALUE.
          VALIDATE bgsc_session_property NO-ERROR.
          IF ERROR-STATUS:ERROR THEN
            UNDO, RETURN ERROR RETURN-VALUE.
        END.

        /* See if there is a corresponding session type property and create it if necessary */
        FIND FIRST bgsm_session_type_property EXCLUSIVE-LOCK
          WHERE bgsm_session_type_property.session_type_obj     = bgsm_session_type.session_type_obj
            AND bgsm_session_type_property.session_property_obj = bgsc_session_property.session_property_obj
          NO-ERROR.
        IF NOT AVAILABLE(bgsm_session_type_property) THEN
        DO:
          CREATE bgsm_session_type_property NO-ERROR.
          IF ERROR-STATUS:ERROR THEN
            UNDO, RETURN ERROR RETURN-VALUE.
          ASSIGN
            bgsm_session_type_property.session_type_obj     = bgsm_session_type.session_type_obj
            bgsm_session_type_property.session_property_obj = bgsc_session_property.session_property_obj
            NO-ERROR.
          IF ERROR-STATUS:ERROR THEN
            UNDO, RETURN ERROR RETURN-VALUE.
        END.

        /* Set the value of the session type property to be the value of the ttProperty record */
        ASSIGN
          bgsm_session_type_property.property_value = bttProperty.cValue
          NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
          UNDO, RETURN ERROR RETURN-VALUE.

        VALIDATE bgsm_session_type_property NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
          UNDO, RETURN ERROR RETURN-VALUE.

      END. /* FOR EACH bttProperty NO-LOCK */

      

      /* Get a list of all the service types for this session type */
      FOR EACH bttService NO-LOCK
        WHERE bttService.cSessionType = bttSession.cSessionType:
        IF NOT CAN-DO(gcServiceList, bttService.cServiceType) THEN
        DO:
          ASSIGN
            gcServiceList = gcServiceList + MIN(",":U, gcServiceList)
                         +  bttService.cServiceType
            cSTManager = getProperty(bttSession.cSessionType, "ICFCM_":U + bttService.cServiceType)
          .
          IF cSTManager <> ? AND
             cSTManager <> "":U THEN
            gcSTManagerList = gcSTManagerList + MIN(",":U, gcSTManagerList)
                            + cSTManager.
        END.
      END.
      
      RUN applyManagers (bttSession.cSessionType, bgsm_session_type.session_type_obj) NO-ERROR.
      IF ERROR-STATUS:ERROR THEN
        UNDO, RETURN ERROR RETURN-VALUE.

      RUN applyServices (bttSession.cSessionType, bgsm_session_type.session_type_obj) NO-ERROR.
      IF ERROR-STATUS:ERROR THEN
        UNDO, RETURN ERROR RETURN-VALUE.

    END.  /* DO TRANSACTION */

  END. /* FOR EACH bttSession NO-LOCK */
    
  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-validateParameters) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateParameters Procedure 
PROCEDURE validateParameters :
/*------------------------------------------------------------------------------
  Purpose:     Obtains a list of all the sessions and then marks the ones that
               are to be loaded.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSessions AS CHARACTER  NO-UNDO.

  EMPTY TEMP-TABLE ttSession.

  DEFINE BUFFER bttSession FOR ttSession.
 
  FOR EACH ttProperty:
    FIND FIRST bttSession
      WHERE bttSession.cSessionType = ttProperty.cSessionType
      NO-ERROR.
    IF NOT AVAILABLE(bttSession) THEN
    DO:
      CREATE bttSession.
      ASSIGN
        bttSession.cSessionType = ttProperty.cSessionType
      .
    END.
  END.
  
  FOR EACH ttManager:
    FIND FIRST bttSession
      WHERE bttSession.cSessionType = ttManager.cSessionType
      NO-ERROR.
    IF NOT AVAILABLE(bttSession) THEN
    DO:
      CREATE bttSession.
      ASSIGN
        bttSession.cSessionType = ttManager.cSessionType
      .
    END.
  END.

  FOR EACH ttService:
    FIND FIRST bttSession
      WHERE bttSession.cSessionType = ttService.cSessionType
      NO-ERROR.
    IF NOT AVAILABLE(bttSession) THEN
    DO:
      CREATE bttSession.
      ASSIGN
        bttSession.cSessionType = ttService.cSessionType
      .
    END.
  END.

  cSessions = REPLACE(pcSessionList, CHR(3), ",":U).

  FOR EACH bttSession:
    IF cSessions = "":U OR 
       CAN-DO(cSessions, bttSession.cSessionType) THEN
      ASSIGN
        bttSession.lLoadSession = YES
      .
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

