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
  File: afservicetype.p

  Description:  Service Type Manager Super Procedure

  Purpose:      Service Type Manager Super Procedure
                This procedure provides standard functionality to all service type managers.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   17/08/2001  Author:    Bruce Gruenbaum 

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afservicetype.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* Astra object identifying preprocessor */
&glob   AstraProcedure    yes

{af/sup2/afglobals.i}

DEFINE VARIABLE hConnMan AS HANDLE     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-canConnectAtStartup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD canConnectAtStartup Procedure 
FUNCTION canConnectAtStartup RETURNS LOGICAL
  ( INPUT pcServiceName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findConnectedPhysicalService) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD findConnectedPhysicalService Procedure 
FUNCTION findConnectedPhysicalService RETURNS HANDLE
    ( input pcPhysicalService      as character,
      input pcServiceName          as character    ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findServiceRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD findServiceRecord Procedure 
FUNCTION findServiceRecord RETURNS HANDLE
  ( INPUT pcServiceName AS CHARACTER,
    INPUT pcLock        AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

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

&IF DEFINED(EXCLUDE-getServiceField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getServiceField Procedure 
FUNCTION getServiceField RETURNS HANDLE
  ( INPUT pcServiceName AS CHARACTER,
    INPUT pcFieldName   AS CHARACTER )  FORWARD.

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
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isDefaultService) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isDefaultService Procedure 
FUNCTION isDefaultService RETURNS LOGICAL
  ( INPUT pcServiceName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setServiceHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setServiceHandle Procedure 
FUNCTION setServiceHandle RETURNS LOGICAL
  ( INPUT pcServiceName AS CHARACTER,
    INPUT pcServiceHandle AS CHARACTER )  FORWARD.

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
         HEIGHT             = 17.95
         WIDTH              = 50.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

RUN initializeSelf.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-initializeSelf) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeSelf Procedure 
PROCEDURE initializeSelf PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:     Initializes the Service Type super procedure and starts the 
               afddo.p library if necessary.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  hConnMan = DYNAMIC-FUNCTION("getManagerHandle":U IN THIS-PROCEDURE,
                              "ConnectionManager":U) NO-ERROR.
  ERROR-STATUS:ERROR = NO.
  IF NOT VALID-HANDLE(hConnMan) THEN
    RETURN "CONNECTION MANAGER HANDLE NOT AVAILABLE IN afservicetype.p":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-registerService) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE registerService Procedure 
PROCEDURE registerService :
/*------------------------------------------------------------------------------
  Purpose:     This procedures takes a buffer containing a service and creates
               an entry in the local service temp-table if necessary, otherwise
               it attempts to disconnect the connected service and resets the
               service data.
  Parameters:  <none>
  Notes:       This procedure is a required entry point for the Connection
               Manager.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phServiceBuff             AS HANDLE   NO-UNDO.

  DEFINE VARIABLE hfServiceName  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hbSTTable      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cRetVal        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cServiceName   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lAns           AS LOGICAL    NO-UNDO.

  {aficfcheck.i}  /* Include the lICFRunning variable and set it */


  /* Make sure we have a valid Service buffer */ 
  IF NOT VALID-HANDLE(phServiceBuff) THEN
  DO:
    IF lICFRunning THEN
    DO:
      cRetVal = {aferrortxt.i 'ICF' '1' '?' '?' "'Service table'"}.
      RETURN cRetVal.
    END.
    ELSE
      RETURN "SERVICE RECORD NOT AVAILABLE":U.
  END.

  /* Make sure we have a Service record in the buffer */
  IF NOT phServiceBuff:AVAILABLE THEN
  DO:
    IF lICFRunning THEN
    DO:
      cRetVal = {aferrortxt.i 'ICF' '2' '?' '?' "phServiceBuff:NAME"}.
      RETURN cRetVal.
    END.
    ELSE
      RETURN "SERVICE RECORD NOT AVAILABLE":U.
  END.
 

  ERROR-STATUS:ERROR = NO.
  /* Obtain a handle to the service name field. */
  hfServiceName = phServiceBuff:BUFFER-FIELD("cServiceName":U) NO-ERROR.
  IF NOT VALID-HANDLE(hfServiceName) THEN
  DO:
    IF lICFRunning THEN
    DO:
      cRetVal = {aferrortxt.i 'ICF' '3' '?' '?' "'cServiceName'" "phServiceBuff:NAME" }.
      RETURN cRetVal.
    END.
    ELSE
      RETURN "INVALID SERVICE RECORD PASSED TO registerService":U.
  END.


  ERROR-STATUS:ERROR = NO.
  /* Obtain a handle to the buffer of the ttServiceType table in the
     TARGET-PROCEDURE */
  hbSTTable = DYNAMIC-FUNCTION("getSTTableBuffer":U IN TARGET-PROCEDURE). 
  IF NOT VALID-HANDLE(hbSTTable) THEN
  DO:
    IF lICFRunning THEN
    DO:
      cRetVal = {aferrortxt.i 'ICF' '1' '?' '?' "'Service Type'"}.
      RETURN cRetVal.
    END.
    ELSE
      RETURN "FUNCTION CALL getSTTableBuffer FAILED":U.
  END.

  /* Set the cServiceName field to contain the value of the field in the 
     buffer */
  cServiceName = hfServiceName:BUFFER-VALUE.

  /* If the ST table has a record in the buffer, release it */
  IF hbSTTable:AVAILABLE THEN
    hbSTTable:BUFFER-RELEASE().

  DO TRANSACTION:
    /* Find the appropriate Service Type record. */
    lAns = hbSTTable:FIND-UNIQUE("WHERE ":U + hbSTTable:NAME + ".cServiceName = ":U + QUOTER(cServiceName), EXCLUSIVE-LOCK) NO-ERROR.
    ERROR-STATUS:ERROR = NO.
      
    /* If the record is not available, then create it */
    IF NOT lAns THEN
    DO:
      hbSTTable:BUFFER-CREATE().
    END.

    /* Now copy the contents of the input buffer to this record */
    hbSTTable:BUFFER-COPY(phServiceBuff,"cServiceHandle":U).

    /* Now find the current record no-lock. This results in a buffer release */
    lAns = hbSTTable:FIND-CURRENT(NO-LOCK) NO-ERROR.
    ERROR-STATUS:ERROR = NO.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-substituteParams) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE substituteParams Procedure 
PROCEDURE substituteParams :
/*------------------------------------------------------------------------------
  Purpose:     The substituteList values are used to replace the tokens 
               in the connectString with appropriate values. If the connection 
               string contains %DynUserID. it is replaces with the Dynamcis 
               user id for the session.
  Parameters:  pcSubstitutionList would be in the form
               %WSDLUserId chr(3) ABCCorp chr(1) %WSDLPassword Chr(3) abc123
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcConnectString            AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcSubstitutionList         AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcSubstitutedConnectString AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE iSubList        AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cSubElement     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cElement        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cUserId         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iPart           AS INTEGER    NO-UNDO.

  /* Make return same as connect string */
  ASSIGN pcSubstitutedConnectString = pcConnectString.

  /* First replace %DynUserId with the actual Dynamics user id */
  IF (INDEX( pcSubstitutedConnectString, "%DynUserId") > 0 ) THEN
  DO:
    cUserId  = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                  INPUT "currentUserLogin":U, INPUT NO).
    ASSIGN iPart = INDEX( pcSubstitutedConnectString, "%DynUserId").
    ASSIGN pcSubstitutedConnectString = 
             SUBSTRING(pcSubstitutedConnectString, 1, iPart - 1) + 
             cUserId + 
             SUBSTRING(pcSubstitutedConnectString, iPart + LENGTH("%DynUserId")).
  END.

  /* If blank or unknown - we are done */
  IF pcSubstitutionList = ? OR pcSubstitutionList = "":U THEN
    RETURN "":U.

  DO iSubList = 1 TO NUM-ENTRIES(pcSubstitutionList, CHR(1)):
    ASSIGN cSubElement = ENTRY(iSubList, pcSubstitutionList, CHR(1)).

    /* We can't deal with incomplete list - so ignore the element */
    IF (NUM-ENTRIES(cSubElement, CHR(3)) <= 1) THEN
      NEXT.
    ASSIGN cElement = ENTRY(1, cSubElement, CHR(3))
           cValue   = ENTRY(2, cSubElement, CHR(3))
           iPart    = INDEX( pcSubstitutedConnectString, cElement).

    IF (iPart > 0) THEN
      ASSIGN pcSubstitutedConnectString = 
               SUBSTRING(pcSubstitutedConnectString, 1, iPart - 1) + 
               cValue + 
               SUBSTRING(pcSubstitutedConnectString, iPart + LENGTH(cElement)).
  END.
  RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-canConnectAtStartup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION canConnectAtStartup Procedure 
FUNCTION canConnectAtStartup RETURNS LOGICAL
  ( INPUT pcServiceName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the Connection parameter field associated with a logical
            service name.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hField       AS HANDLE     NO-UNDO.

  /* Get the handle to the cServiceHandle field */
  hField = DYNAMIC-FUNCTION("getServiceField":U IN TARGET-PROCEDURE,
                             pcServiceName,
                             "lConnectAtStartup":U).

  /* If the field handle is valid, return the field value else return ?. */

  IF VALID-HANDLE(hField) THEN
    RETURN hField:BUFFER-VALUE.
  ELSE
    RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findConnectedPhysicalService) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION findConnectedPhysicalService Procedure 
FUNCTION findConnectedPhysicalService RETURNS HANDLE
    ( input pcPhysicalService      as character,
      input pcServiceName          as character    ):
/*------------------------------------------------------------------------------
  Purpose: Find the first service by physical service that has a valid service handle.
    Notes: - pcServiceName is an optional parameter used in cases where the caller 
             wants to find serivces other than itself that are connected with the
             same physical service.
           - connectServiceWithParams() and disconnectService() are usually the APIs 
             calling this function. This functionality currently only applies to
             AppServer connections.
           - It's up to the calling connection manager to decide what to do in
             cases where a connection already exists.
------------------------------------------------------------------------------*/
    define variable hServer                    as handle no-undo.
    define variable hService                   as handle no-undo.    
    
    hServer = ?.
    
    /* Get the service. Use the buffer handles for better abstraction
       (as oppposed to getting ttService directly). */
    hService = dynamic-function('getSTTableBuffer':u in target-procedure).
    if valid-handle(hService) then
    do:
        if hService:available then
            hService:buffer-release().
        
        hService:find-first('where ':u
                            + hService:name + '.cPhysicalService = ':u + quoter(pcPhysicalService) + ' and ':u                            
                            + (if pcServiceName eq '':u then '':u
                               else hService:name + '.cServiceName <> ':u + quoter(pcServiceName) + ' and ':u)
                            + 'valid-handle(widget-handle(':u + hService:name + '.cServiceHandle))':u ) no-error.
        if hService:available then
            hServer = widget-handle(hService:buffer-field('cServiceHandle':U):buffer-value) no-error.
    end.    /* valid service */
    
    error-status:error = no.
    return hServer.
END FUNCTION.    /* findConnectedPhysicalService */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findServiceRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION findServiceRecord Procedure 
FUNCTION findServiceRecord RETURNS HANDLE
  ( INPUT pcServiceName AS CHARACTER,
    INPUT pcLock        AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Finds the service record for a specific service name
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hbSTTable      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lAns           AS LOGICAL    NO-UNDO.

  ERROR-STATUS:ERROR = NO.
  /* Obtain a handle to the buffer of the ttServiceType table in the
     TARGET-PROCEDURE */
  hbSTTable = DYNAMIC-FUNCTION("getSTTableBuffer":U IN TARGET-PROCEDURE). 
  IF NOT VALID-HANDLE(hbSTTable) THEN
    RETURN ?.

  /* If the ST table has a record in the buffer, release it */
  IF hbSTTable:AVAILABLE THEN
    hbSTTable:BUFFER-RELEASE().

  /* Find the appropriate Service Type record. */
  lAns = hbSTTable:FIND-UNIQUE("WHERE ":U + hbSTTable:NAME + ".cServiceName = ":U + QUOTER(pcServiceName), NO-LOCK) NO-ERROR.
  ERROR-STATUS:ERROR = NO.

  /* If the record is not available, then return unknown */
  IF NOT lAns THEN
    RETURN ?.
  ELSE
    RETURN hbSTTable.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getConnectionParams) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getConnectionParams Procedure 
FUNCTION getConnectionParams RETURNS CHARACTER
  ( INPUT pcServiceName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the Connection parameter field associated with a logical
            service name.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hField       AS HANDLE     NO-UNDO.

  /* Get the handle to the cServiceHandle field */
  hField = DYNAMIC-FUNCTION("getServiceField":U IN TARGET-PROCEDURE,
                             pcServiceName,
                             "cConnectParams":U).

  /* If the field handle is valid, return the field value else
     return ?. */
  IF VALID-HANDLE(hField) THEN
    RETURN hField:BUFFER-VALUE.
  ELSE
    RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getConnectionString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getConnectionString Procedure 
FUNCTION getConnectionString RETURNS CHARACTER
  ( INPUT pcServiceName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the connection string that can be used to connect to a 
            logical service name.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cConnectParams AS CHARACTER     NO-UNDO.
  DEFINE VARIABLE cConnectString AS CHARACTER  NO-UNDO.

  /* Get the handle to the cServiceHandle field */
  cConnectParams = DYNAMIC-FUNCTION("getConnectionParams":U IN TARGET-PROCEDURE,
                                    pcServiceName).

  IF cConnectParams = ? THEN
    RETURN ?.   /* Function return value. */
  
  /* Now parse the connection parameter string and return the connection 
     string from it */
  cConnectString = DYNAMIC-FUNCTION("parseConnectionParams":U IN TARGET-PROCEDURE,
                                     cConnectParams).

  RETURN cConnectString.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPhysicalService) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPhysicalService Procedure 
FUNCTION getPhysicalService RETURNS CHARACTER
  ( INPUT pcServiceName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the name of a physical service associated with a logical
            service name.
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hField       AS HANDLE     NO-UNDO.

  /* Get the handle to the cServiceHandle field */
  hField = DYNAMIC-FUNCTION("getServiceField":U IN TARGET-PROCEDURE,
                             pcServiceName,
                             "cPhysicalService":U).

  /* If the field handle is valid, return the field value else
     return ?. */
  IF VALID-HANDLE(hField) THEN
    RETURN hField:BUFFER-VALUE.
  ELSE
    RETURN ?.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getServiceField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getServiceField Procedure 
FUNCTION getServiceField RETURNS HANDLE
  ( INPUT pcServiceName AS CHARACTER,
    INPUT pcFieldName   AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Obtains a handle to a field in the ttService table.
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hServiceBuff AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hField       AS HANDLE     NO-UNDO.

  /* Get the handle to the Service record buffer with the record that we're
     looking for */
  hServiceBuff = DYNAMIC-FUNCTION("findServiceRecord":U IN TARGET-PROCEDURE,
                                  pcServiceName,
                                  "":U).

  /* If we don't have a valid handle, return the unknown value. */
  IF NOT VALID-HANDLE(hServiceBuff) THEN
    RETURN ?.

  /* Get a handle to the field */
  hField = hServiceBuff:BUFFER-FIELD(pcFieldName) NO-ERROR.
  ERROR-STATUS:ERROR = NO.

  IF VALID-HANDLE(hField) THEN
    RETURN hField.
  ELSE
    RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getServiceHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getServiceHandle Procedure 
FUNCTION getServiceHandle RETURNS CHARACTER
  ( INPUT pcServiceName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:   Returns the handle to a the specific service name.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hField       AS HANDLE     NO-UNDO.

  /* Get the handle to the cServiceHandle field */
  hField = DYNAMIC-FUNCTION("getServiceField":U IN TARGET-PROCEDURE,
                             pcServiceName,
                             "cServiceHandle":U).

  /* If the field handle is valid, return the field value else
     return ?. */
  IF VALID-HANDLE(hField) THEN
    RETURN hField:BUFFER-VALUE.
  ELSE
    RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getServiceList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getServiceList Procedure 
FUNCTION getServiceList RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hbSTTable      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hServiceType   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hServiceName   AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lAns           AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cRetVal        AS CHARACTER  NO-UNDO.

  ERROR-STATUS:ERROR = NO.
  /* Obtain a handle to the buffer of the ttServiceType table in the
     TARGET-PROCEDURE */
  hbSTTable = DYNAMIC-FUNCTION("getSTTableBuffer":U IN TARGET-PROCEDURE). 
  IF NOT VALID-HANDLE(hbSTTable) THEN
    RETURN ?.

  /* Create a new buffer as we don't want to loop through on the 
     table records that will be available at the end. */
  CREATE BUFFER hServiceType FOR TABLE hbSTTable NO-ERROR.
  IF ERROR-STATUS:ERROR THEN
  DO:
    ERROR-STATUS:ERROR = NO.
    RETURN ?.
  END.

  /* Get the handle to the hServiceName field */
  hServiceName = hServiceType:BUFFER-FIELD("cServiceName":U) NO-ERROR.
  IF NOT VALID-HANDLE(hServiceName) THEN
    RETURN ?.

  /* Open a query */
  CREATE QUERY hQuery.
  hQuery:ADD-BUFFER(hServiceType).
  lAns = hQuery:QUERY-PREPARE("FOR EACH ":U + hServiceType:NAME + " NO-LOCK":U).
  IF NOT lAns THEN
    DELETE OBJECT hQuery.
  IF NOT VALID-HANDLE(hQuery) THEN
  DO:
    DELETE OBJECT hServiceType.
    RETURN ?.
  END.
  
  hQuery:QUERY-OPEN().
  hQuery:GET-FIRST(NO-LOCK).

  REPEAT WHILE NOT hQuery:QUERY-OFF-END:

    cRetVal = cRetVal + (IF cRetVal = "":U THEN "":U ELSE CHR(3))
            + hServiceName:BUFFER-VALUE.

    hQuery:GET-NEXT(NO-LOCK).
  END.

  hQuery:QUERY-CLOSE().
  DELETE OBJECT hQuery.

  RETURN cRetVal.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isDefaultService) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isDefaultService Procedure 
FUNCTION isDefaultService RETURNS LOGICAL
  ( INPUT pcServiceName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the Connection parameter field associated with a logical
            service name.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hField       AS HANDLE     NO-UNDO.

  /* Get the handle to the cServiceHandle field */
  hField = DYNAMIC-FUNCTION("getServiceField":U IN TARGET-PROCEDURE,
                             pcServiceName,
                             "lDefaultService":U).

  /* If the field handle is valid, return the field value else
     return ?. */
  IF VALID-HANDLE(hField) THEN
    RETURN hField:BUFFER-VALUE.
  ELSE
    RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setServiceHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setServiceHandle Procedure 
FUNCTION setServiceHandle RETURNS LOGICAL
  ( INPUT pcServiceName AS CHARACTER,
    INPUT pcServiceHandle AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the value of particular service handle.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hServiceBuff AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hField       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lAns         AS LOGICAL    NO-UNDO.

  DO TRANSACTION:
    /* Get the handle to the Service record buffer with the record that we're
       looking for */
    hServiceBuff = DYNAMIC-FUNCTION("findServiceRecord":U IN TARGET-PROCEDURE,
                                    pcServiceName,
                                    "EXCLUSIVE-LOCK":U).

    /* If we don't have a valid handle, return the NO. */
    IF NOT VALID-HANDLE(hServiceBuff) THEN
      RETURN FALSE.

    /* Get a handle to the field */
    hField = hServiceBuff:BUFFER-FIELD("cServiceHandle":U) NO-ERROR.
    ERROR-STATUS:ERROR = NO.

    IF NOT VALID-HANDLE(hField) THEN
    DO:
      hServiceBuff:BUFFER-RELEASE().
      RETURN FALSE.
    END.
    ELSE
      hField:BUFFER-VALUE = pcServiceHandle.


    /* Now find the current record no-lock. This results in a buffer release */
    lAns = hServiceBuff:FIND-CURRENT(NO-LOCK) NO-ERROR.
    ERROR-STATUS:ERROR = NO.

  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

