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
  File: afconmgrp.p

  Description:  Connection Manager

  Purpose:      Provides the interface for connecting to services

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:    90000027   UserRef:    
                Date:   18/04/2001  Author:     Bruce Gruenbaum

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afconmgrp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* Astra object identifying preprocessor */
&glob   AstraProcedure    yes

{af/sup2/afglobals.i}
{af/app/afconttdef.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-getConnectionParams) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getConnectionParams Procedure 
FUNCTION getConnectionParams RETURNS CHARACTER
  ( INPUT pcServiceName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getConnectionString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getConnectionString Procedure 
FUNCTION getConnectionString RETURNS CHARACTER
  ( INPUT pcServiceName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPhysicalService) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPhysicalService Procedure 
FUNCTION getPhysicalService RETURNS CHARACTER
  ( INPUT pcServiceName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getServiceHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getServiceHandle Procedure 
FUNCTION getServiceHandle RETURNS CHARACTER
  ( INPUT pcServiceName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getServiceList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getServiceList Procedure 
FUNCTION getServiceList RETURNS CHARACTER
  ( INPUT pcServiceType AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getServiceSTManager) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getServiceSTManager Procedure 
FUNCTION getServiceSTManager RETURNS HANDLE
  ( INPUT pcServiceName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getServiceType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getServiceType Procedure 
FUNCTION getServiceType RETURNS CHARACTER
  ( INPUT pcServiceName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getServiceTypeManager) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getServiceTypeManager Procedure 
FUNCTION getServiceTypeManager RETURNS HANDLE
  ( INPUT pcServiceType AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isConnected) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isConnected Procedure 
FUNCTION isConnected RETURNS LOGICAL
  ( INPUT pcServiceName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setServiceTypeManager) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setServiceTypeManager Procedure 
FUNCTION setServiceTypeManager RETURNS LOGICAL
  ( INPUT phServiceProc AS HANDLE )  FORWARD.

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
         HEIGHT             = 15.91
         WIDTH              = 56.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

IF THIS-PROCEDURE:PERSISTENT THEN
  SESSION:ADD-SUPER-PROCEDURE(THIS-PROCEDURE, SEARCH-TARGET).

ON "CLOSE":U OF THIS-PROCEDURE
DO :
  RUN plipShutdown.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-connectService) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE connectService Procedure 
PROCEDURE connectService :
/*------------------------------------------------------------------------------
  Purpose:     This procedure is responsible for establishing the connection to
               the physical service that is required.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcServiceName AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcHandle      AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hServiceType      AS HANDLE   NO-UNDO.

  ERROR-STATUS:ERROR = NO.

  /* Get the handle to the procedure that is responsible for 
     making the connection */
  hServiceType = getServiceSTManager(pcServiceName).

  IF NOT VALID-HANDLE(hServiceType) THEN
    RETURN "INVALID SERVICE TYPE.":U.

  /* Now call the connect procedure in the specific service
     API */
  RUN connectService 
    IN hServiceType 
    (pcServiceName, OUTPUT pcHandle) 
    NO-ERROR.
  IF RETURN-VALUE <> "":U THEN
  DO:
    pcHandle = "":U.
    RETURN RETURN-VALUE.
  END.
  ELSE
    RETURN "":U.

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
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcServiceName AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hServiceType      AS HANDLE   NO-UNDO.

  ERROR-STATUS:ERROR = NO.
  /* Get the handle to the procedure that is responsible for 
     making the connection */
  hServiceType = getServiceSTManager(pcServiceName).

  IF NOT VALID-HANDLE(hServiceType) THEN
    RETURN "INVALID SERVICE TYPE MANAGER.":U.

  /* Now call the connect procedure in the specific service
     API */
  RUN disconnectService 
    IN hServiceType (pcServiceName) NO-ERROR.
  IF RETURN-VALUE <> "":U THEN
    RETURN RETURN-VALUE.
  ELSE
    RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeServices) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeServices Procedure 
PROCEDURE initializeServices :
/*------------------------------------------------------------------------------
  Purpose:     Reads the contents of the table passed using the temp-table
               and buffer-copies it to the ttService table.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phService AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER plConnect AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE hQuery            AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hServiceName      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hPhysicalService  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hServiceType      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hConnectParams    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cRetVal           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cHandle           AS CHARACTER  NO-UNDO.


  /* Make sure that we have handles to all the buffer fields that 
     we need. */
  hServiceName = phService:BUFFER-FIELD("cServiceName":U) NO-ERROR.
  hPhysicalService = phService:BUFFER-FIELD("cPhysicalService":U) NO-ERROR.
  hServiceType = phService:BUFFER-FIELD("cServiceType":U) NO-ERROR.
  hConnectParams = phService:BUFFER-FIELD("cConnectParams":U) NO-ERROR.

  IF NOT VALID-HANDLE(hServiceName) OR
     NOT VALID-HANDLE(hConnectParams) OR
     NOT VALID-HANDLE(hServiceType) THEN
    RETURN "SERVICE TABLE MUST CONTAIN FIELDS cServiceName, cPhysicalService, cServiceType":U. 

  /* Create a query based on the buffer */
  CREATE QUERY hQuery.
  hQuery:SET-BUFFERS(phService).
  hQuery:QUERY-PREPARE("FOR EACH ":U + phService:NAME + " NO-LOCK BY iStartOrder":U).
  hQuery:QUERY-OPEN().
  hQuery:GET-FIRST().

  /* Iterate through the records in the buffer */
  repeat-loop:
  REPEAT WHILE NOT hQuery:QUERY-OFF-END:

    RUN registerService(phService).
    IF RETURN-VALUE <> "":U THEN
    DO:
      IF RETURN-VALUE BEGINS "SERVICE ALREADY SETUP AND CONNECTED":U THEN
        NEXT repeat-loop.
      ELSE
      DO:
        cRetVal = RETURN-VALUE.
        LEAVE repeat-loop.
      END.
    END.

    /* All is well so connect the service if required */
    IF plConnect THEN
    DO:
      RUN connectService(hServiceName:BUFFER-VALUE,
                         OUTPUT cHandle).
      IF RETURN-VALUE <> "":U THEN
      DO:
        cRetVal = RETURN-VALUE.
        LEAVE.
      END.

    END.

    hQuery:GET-NEXT().
  END.

  /* Close the query and delete all the dynamic query objects */
  hQuery:QUERY-CLOSE().
  DELETE OBJECT hQuery.
  hQuery = ?.
  hServiceName = ?.
  hPhysicalService = ?.
  hServiceType = ?.
  hConnectParams = ?.

  IF NOT VALID-HANDLE(gshAstraAppserver) THEN 
    ASSIGN
      gshAstraAppserver = SESSION:HANDLE.

  /* If we have a return value, return it as an error. */
  IF cRetVal <> "":U THEN
    RETURN cRetVal.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-obtainConnectionTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE obtainConnectionTables Procedure 
PROCEDURE obtainConnectionTables :
/*------------------------------------------------------------------------------
  Purpose:     Returns a the handles to the temp-tables that
               contain the Connection and Service Manager's data.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER phServiceType AS HANDLE     NO-UNDO.
  DEFINE OUTPUT PARAMETER phService     AS HANDLE     NO-UNDO.

  ASSIGN
    phServiceType = TEMP-TABLE ttServiceType:HANDLE
    phService     = TEMP-TABLE ttService:HANDLE
  .


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipShutdown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipShutdown Procedure 
PROCEDURE plipShutdown PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE BUFFER bttServiceType FOR ttServiceType.
  DEFINE VARIABLE hProc        AS HANDLE     NO-UNDO.

  /* Make sure that all the service type managers have been shutdown. */
  FOR EACH bttServiceType:
    hProc = bttServiceType.hSTManager.
    IF NOT VALID-HANDLE(hProc) THEN
      NEXT.

    /* We don't apply close here because close does not work on all
       platforms. */
    IF CAN-DO(hProc:INTERNAL-ENTRIES,"plipShutdown":U) THEN
      RUN plipShutdown IN hProc.
    DELETE bttServiceType.
  END.

  hProc = DYNAMIC-FUNCTION("getProcedureHandle":U IN THIS-PROCEDURE,
                           "af/app/afservicetype.p":U).
  IF VALID-HANDLE(hProc) THEN
    DELETE OBJECT hProc.

  DELETE PROCEDURE THIS-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-reconnectService) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE reconnectService Procedure 
PROCEDURE reconnectService :
/*------------------------------------------------------------------------------
  Purpose:     Reconnects a session after the session failed.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcServiceName AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcHandle      AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE hServiceType      AS HANDLE   NO-UNDO.

  ERROR-STATUS:ERROR = NO.

  /* Get the handle to the procedure that is responsible for 
     making the connection */
  hServiceType = getServiceSTManager(pcServiceName).

  IF NOT VALID-HANDLE(hServiceType) THEN
    RETURN "INVALID SERVICE TYPE.":U.

  /* Now call the connect procedure in the specific service
     API */
  RUN reconnectService 
    IN hServiceType 
    (pcServiceName, OUTPUT pcHandle) 
    NO-ERROR.
  IF RETURN-VALUE <> "":U THEN
  DO:
    pcHandle = "":U.
    RETURN RETURN-VALUE.
  END.
  ELSE
    RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-registerService) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE registerService Procedure 
PROCEDURE registerService :
/*------------------------------------------------------------------------------
  Purpose:     Registers a service with the Connection Manager and the
               appropriate Service Type Manager.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phService AS HANDLE     NO-UNDO.

  DEFINE VARIABLE hServiceName        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hPhysicalService    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hServiceType        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hConnectParams      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDefaultService      AS HANDLE     NO-UNDO.

  DEFINE VARIABLE cRetVal             AS CHARACTER  NO-UNDO.

  DEFINE BUFFER bttService     FOR ttService.
  DEFINE BUFFER bttServiceType FOR ttServiceType.

  /* Make sure that we have handles to all the buffer fields that 
     we need. */
  hServiceName = phService:BUFFER-FIELD("cServiceName":U) NO-ERROR.
  hPhysicalService = phService:BUFFER-FIELD("cPhysicalService":U) NO-ERROR.
  hDefaultService = phService:BUFFER-FIELD("lDefaultService":U) NO-ERROR.
  hServiceType = phService:BUFFER-FIELD("cServiceType":U) NO-ERROR.
  hConnectParams = phService:BUFFER-FIELD("cConnectParams":U) NO-ERROR.
  IF NOT VALID-HANDLE(hServiceName) OR
     NOT VALID-HANDLE(hConnectParams) OR
     NOT VALID-HANDLE(hServiceType) THEN
    RETURN "SERVICE TABLE MUST CONTAIN FIELDS cServiceName, cPhysicalService, cServiceType":U. 


  DO TRANSACTION:
    /* First make sure that we have a valid service type procedure 
       already established */
    FIND FIRST bttServiceType NO-LOCK
      WHERE bttServiceType.cServiceType = hServiceType:BUFFER-VALUE
      NO-ERROR.
    IF NOT AVAILABLE(bttServiceType) OR
       NOT VALID-HANDLE(bttServiceType.hSTManager) THEN
    DO:
      cRetVal = "SERVICE TYPE NOT REGISTERED FOR ":U + hServiceType:BUFFER-VALUE.
      LEAVE.
    END.

    /* Now find the service record to check if it exists */
    FIND FIRST bttService 
      WHERE bttService.cServiceName = hServiceName:BUFFER-VALUE
      NO-ERROR.
    /* If the service does not exist, create the service record */
    IF NOT AVAILABLE(bttService) THEN
    DO:
      CREATE bttService.
      ASSIGN
        bttService.cServiceName = hServiceName:BUFFER-VALUE
        .
    END.
    /* Make sure that everything matches. If not, bail out */
    ELSE IF isConnected(bttService.cServiceName)  THEN
    DO:
      cRetVal = "SERVICE ALREADY SETUP AND CONNECTED ":U + hServiceName:BUFFER-VALUE .
      LEAVE.
    END.

    /* Set the appropriate field values */
    ASSIGN
      bttService.cServiceType     = hServiceType:BUFFER-VALUE
      bttService.cConnectParams   = hConnectParams:BUFFER-VALUE 
      bttService.cPhysicalService = (IF VALID-HANDLE(hPhysicalService) THEN
                                     hPhysicalService:BUFFER-VALUE ELSE
                                     "":U)
      bttService.lDefaultService = (IF VALID-HANDLE(hDefaultService) THEN
                                     hDefaultService:BUFFER-VALUE ELSE
                                     NO)
      .

    /* Add the service to the service type manager's list of services. */
    RUN registerService
      IN bttServiceType.hSTManager 
      (INPUT BUFFER bttService:HANDLE) 
      NO-ERROR.
    IF RETURN-VALUE <> "":U THEN
      UNDO, RETURN RETURN-VALUE.
  END. /* DO TRANSACTION */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-getConnectionParams) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getConnectionParams Procedure 
FUNCTION getConnectionParams RETURNS CHARACTER
  ( INPUT pcServiceName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the connection parameters for a logical service
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hServiceType      AS HANDLE   NO-UNDO.

  /* Get the handle to the procedure that is responsible for 
     making the connection */
  hServiceType = getServiceSTManager(pcServiceName).

  IF NOT VALID-HANDLE(hServiceType) THEN
    RETURN ?.

  /* Now call the connect procedure in the specific service
     API */
  RETURN DYNAMIC-FUNCTION("getConnectionParams":U IN hServiceType,pcServiceName).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getConnectionString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getConnectionString Procedure 
FUNCTION getConnectionString RETURNS CHARACTER
  ( INPUT pcServiceName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Retrieves the connection string for a logical service.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hServiceType      AS HANDLE   NO-UNDO.

  /* Get the handle to the procedure that is responsible for 
     making the connection */
  hServiceType = getServiceSTManager(pcServiceName).

  IF NOT VALID-HANDLE(hServiceType) THEN
    RETURN ?.

  /* Now call the connect procedure in the specific service
     API */
  RETURN DYNAMIC-FUNCTION("getConnectionString":U IN hServiceType,pcServiceName).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPhysicalService) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPhysicalService Procedure 
FUNCTION getPhysicalService RETURNS CHARACTER
  ( INPUT pcServiceName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the physical service associated with a logical service name.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hServiceType      AS HANDLE   NO-UNDO.

  /* Get the handle to the procedure that is responsible for 
     making the connection */
  hServiceType = getServiceSTManager(pcServiceName).

  IF NOT VALID-HANDLE(hServiceType) THEN
    RETURN ?.

  /* Now call the connect procedure in the specific service
     API */
  RETURN DYNAMIC-FUNCTION("getPhysicalService":U IN hServiceType,pcServiceName).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getServiceHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getServiceHandle Procedure 
FUNCTION getServiceHandle RETURNS CHARACTER
  ( INPUT pcServiceName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Gets the handle to a specific service.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hServiceType      AS HANDLE   NO-UNDO.

  /* Get the handle to the procedure that is responsible for 
     making the connection */
  hServiceType = getServiceSTManager(pcServiceName).

  IF NOT VALID-HANDLE(hServiceType) THEN
    RETURN ?.

  /* Now call the connect procedure in the specific service
     API */
  RETURN DYNAMIC-FUNCTION("getServiceHandle":U IN hServiceType,pcServiceName).


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getServiceList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getServiceList Procedure 
FUNCTION getServiceList RETURNS CHARACTER
  ( INPUT pcServiceType AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hServiceType      AS HANDLE   NO-UNDO.

  /* Get the handle to the procedure that is responsible for 
     making the connection */
  hServiceType = getServiceTypeManager(pcServiceType).

  IF NOT VALID-HANDLE(hServiceType) THEN
    RETURN ?.

  /* Now call the connect procedure in the specific service
     API */
  RETURN DYNAMIC-FUNCTION("getServiceList":U IN hServiceType).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getServiceSTManager) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getServiceSTManager Procedure 
FUNCTION getServiceSTManager RETURNS HANDLE
  ( INPUT pcServiceName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the Service Type Manager handle given a service name.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hServiceType      AS HANDLE   NO-UNDO.
  DEFINE VARIABLE cRetVal           AS CHARACTER  NO-UNDO.

  DEFINE BUFFER bttService FOR ttService.

  /* Find the service */
  FIND FIRST bttService NO-LOCK
    WHERE bttService.cServiceName = pcServiceName 
    NO-ERROR.
  IF NOT AVAILABLE(bttService) THEN
    RETURN ?.   

  /* Get the handle to the procedure that is responsible for 
     making the connection */
  hServiceType = getServiceTypeManager(bttService.cServiceType).

  RETURN hServiceType.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getServiceType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getServiceType Procedure 
FUNCTION getServiceType RETURNS CHARACTER
  ( INPUT pcServiceName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the service type of a known service
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hServiceType      AS HANDLE   NO-UNDO.
  DEFINE VARIABLE cRetVal           AS CHARACTER  NO-UNDO.

  DEFINE BUFFER bttService FOR ttService.

  /* Find the service */
  FIND FIRST bttService NO-LOCK
    WHERE bttService.cServiceName = pcServiceName 
    NO-ERROR.
  IF NOT AVAILABLE(bttService) THEN
    RETURN ?.   

  RETURN bttService.cServiceType.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getServiceTypeManager) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getServiceTypeManager Procedure 
FUNCTION getServiceTypeManager RETURNS HANDLE
  ( INPUT pcServiceType AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Determines the handle to the procedure that is responsible for 
            managing a particular service.
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE BUFFER bttServiceType FOR ttServiceType.
  FIND FIRST bttServiceType 
    WHERE bttServiceType.cServiceType = pcServiceType
    NO-ERROR.
  IF NOT AVAILABLE(bttServiceType) OR
     NOT VALID-HANDLE(bttServiceType.hSTManager) THEN
    RETURN ?.
  ELSE
    RETURN bttServiceType.hSTManager.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isConnected) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isConnected Procedure 
FUNCTION isConnected RETURNS LOGICAL
  ( INPUT pcServiceName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Determines whether or not a specific services is connected.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hServiceType      AS HANDLE   NO-UNDO.

  /* Get the handle to the procedure that is responsible for 
     making the connection */
  hServiceType = getServiceSTManager(pcServiceName).

  /* If the hServiceType is not valid, it means we know nothing
     about this service. Assume that it is a database that has been
     connected externally and poll the Database service type manager
     to see if it is connected. */
  IF NOT VALID-HANDLE(hServiceType) THEN
    hServiceType = getServiceTypeManager("Database":U).

  /* If the handle to the service type manager is valid, call the isConnected
     function in that manager, otherwise just return false. */
  IF VALID-HANDLE(hServiceType) THEN
    RETURN DYNAMIC-FUNCTION("isConnected":U IN hServiceType,pcServiceName).
  ELSE
    RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setServiceTypeManager) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setServiceTypeManager Procedure 
FUNCTION setServiceTypeManager RETURNS LOGICAL
  ( INPUT phServiceProc AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:   Creates a record in the service type temp-table that registers
             which persistent procedure is responsible for managing which 
             service type
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lRequiresHandle AS LOGICAL NO-UNDO.
  DEFINE VARIABLE cServiceType    AS CHARACTER  NO-UNDO.
  DEFINE BUFFER bttServiceType FOR ttServiceType.

  /* Check to see that the input parameter handle is a procedure and has 
     the appropriate entry points */ 
  IF phServiceProc:TYPE <> "PROCEDURE":U OR
     NOT CAN-DO(phServiceProc:INTERNAL-ENTRIES,"servicesServiceType":U) OR
     NOT CAN-DO(phServiceProc:INTERNAL-ENTRIES,"requiresHandle":U) THEN
    RETURN FALSE.

  /* Check the two attributes */
  lRequiresHandle = DYNAMIC-FUNCTION("requiresHandle":U IN phServiceProc).
  cServiceType = DYNAMIC-FUNCTION("servicesServiceType":U IN phServiceProc).

  /* Create the ttServiceType record */
  DO TRANSACTION:
    FIND FIRST bttServiceType 
      WHERE bttServiceType.cServiceType = cServiceType
      NO-ERROR.
    IF NOT AVAILABLE(bttServiceType) THEN
    DO:
      CREATE bttServiceType.
      ASSIGN
        bttServiceType.cServiceType = cServiceType
        .
    END.
    ASSIGN
      bttServiceType.hSTManager = phServiceProc
      bttServiceType.cSTProcName = phServiceProc:FILE-NAME
      bttServiceType.lUseHandle = lRequiresHandle
      .
  END.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

