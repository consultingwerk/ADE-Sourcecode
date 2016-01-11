&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*************************************************************/  
/* Copyright (c) 1984-2005,2007 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/

/*------------------------------------------------------------------------
    File        : _aud-utils.p
    Purpose     : Contains the API for the auditing policy control. 
                  This is used by the APMT utility.
                  The procedures and functions herein defined can be used
                  by other applications if developers want to take advantage
                  of this code and build a different UI, for instance. 
    Syntax      :

    Description : The procedures take advantage of ProDataSets to read and
                  write policies from / to databases. They call external
                  procedures responsible for reading and updating the data
                  on a given database. They also provide support for AppServers,
                  so one could run APMT through WebClient.

    Author(s)   : Fernando de Souza
    Created     : Feb 25, 2005
    Notes       :
    
    History
    fernando  06/20/07 Support for large files
    
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

{adecomm/appserv.i}

{auditing/include/_aud-std.i}

DEFINE VARIABLE tryToConnecttoAS    AS LOGICAL NO-UNDO INIT YES.

DEFINE VARIABLE hCaller           AS HANDLE NO-UNDO.

/* set when calling the import procedure (xml) */
DEFINE VARIABLE hImportProc       AS HANDLE NO-UNDO.

/* applications can provide the handle to the AppServer connection they may
   already have
*/
DEFINE VARIABLE suppliedAppSrvHdl AS HANDLE  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-checkPartition) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD checkPartition Procedure 
FUNCTION checkPartition RETURNS LOGICAL
  ( cPartitionName AS CHARACTER /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-DB-Name) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD get-DB-Name Procedure 
FUNCTION get-DB-Name RETURNS CHARACTER
  ( pcDbInfo AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAppServerHdl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAppServerHdl Procedure 
FUNCTION getAppServerHdl RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-has-DB-option) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD has-DB-option Procedure 
FUNCTION has-DB-option RETURNS LOGICAL
  ( pcDbInfo AS CHARACTER, pcDbOption AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isDBOnAppServer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isDBOnAppServer Procedure 
FUNCTION isDBOnAppServer RETURNS LOGICAL
  ( pcDbInfo AS CHARACTER  )  FORWARD.

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
         HEIGHT             = 15.1
         WIDTH              = 60.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-cancel-import-from-xml) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cancel-import-from-xml Procedure 
PROCEDURE cancel-import-from-xml :
/*------------------------------------------------------------------------------
  Purpose:    Delete the persistent procedure started in policies-dataset-read-xml 
              to load an xml file. This should only be called if the call to 
              policies-dataset-read-xml returned a list of duplicate policy names 
              and the caller decided not to call override-policies-from-xml to 
              override the policies.
               
  Parameters:  <none>
  
  Notes:       
------------------------------------------------------------------------------*/
    
    /* check if procedure handle is valid */
    IF VALID-HANDLE (hImportProc) THEN DO:
        RUN cleanup IN hImportProc.
        DELETE PROCEDURE hImportProc.
        ASSIGN hImportProc = ?.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-check-conflicts) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE check-conflicts Procedure 
PROCEDURE check-conflicts :
/*------------------------------------------------------------------------------
  Purpose:     Check for conflicts on all policies stored in the dataset
               object passed by the caller. We follow the following rules
               to determine if a conflict should be reported:
               
               - We only check active policies;
               - Report conflict on the security and custom detail level on all
                 active policies;
               - Event can only have a single setting. Report if a given event is
                 defined in multiple active policies;
               - table/field can only have a single setting - report if table /field
                 is in more than one active policy.
               - check if conflicting identifying ordinal positions exist.
               
  Parameters:  INPUT hDset - dataset object with policies
               OUTPUT ttHandle - temp-table handle where we store conflict info
  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER DATASET-HANDLE hDset.
DEFINE OUTPUT PARAMETER TABLE-HANDLE ttHandle.

RUN auditing/_aud-conflict.p (yes, /*conflict mode */
                              INPUT DATASET-HANDLE hDset BY-REFERENCE,
                              OUTPUT TABLE-HANDLE ttHandle).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-connectAppServer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE connectAppServer Procedure 
PROCEDURE connectAppServer :
/*------------------------------------------------------------------------------
  Purpose: Check if we need to connect to an AppServer. Caller passes the partition
           name and we try to find it in the current session. This is to support the
           method used by ADM2. If we can't find it, we will return "PARTITION-NOT-FOUND",
           so caller can decide what to do.
           
           This is mainly to handle partition names for the APMT utility. Since all
           the code that read and updates the data from/to the database is called from
           this procedure, we let the caller define what is the partition name they want
           to use. 
           
           Alternatively, the caller can handle the connection to the AppServer, and
           call setAppServerHandle so we use the connection they already made.
               
  Parameters:  INPUT pcPartitionName - name of the AppServer partition.
  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcPartitionName AS CHARACTER NO-UNDO.

DEFINE VARIABLE hAppserver          AS HANDLE  NO-UNDO.

    /* don't do this when running on the AppServer */
    IF SESSION:CLIENT-TYPE = "APPSERVER" THEN
        RETURN.
     
    /* we only do AppServer if there is a partition with the name specified
       by the caller. This is the "APMT" partition for the APMT utility.
    */
    IF checkPartition (pcPartitionName) THEN DO:

        hAppserver = DYNAMIC-FUNCTION('getServiceHandle':U IN appSrvUtils,pcPartitionName).

        IF hAppserver = SESSION THEN 
           tryToConnecttoAS = FALSE. /* Appserver connected as session already */

        /* check if we should connect to it */
        IF tryToConnecttoAS AND 
            (NOT VALID-HANDLE (hAppserver) OR 
            NOT hAppserver:CONNECTED()) THEN DO:

               /* try to connect now */
               RUN appServerConnect IN appSrvUtils (INPUT pcPartitionName, 
                         INPUT  NO,
                         INPUT  "":U, 
                         OUTPUT hAppserver) NO-ERROR.

                IF NOT VALID-HANDLE (hAppServer) OR RETURN-VALUE = "ERROR":U THEN
                    ASSIGN hAppServer = ?.
                
                /* if the partition is set to 'local', don't bother with appserver. */
                IF hAppserver = SESSION THEN DO:
                    ASSIGN tryToConnecttoAS = FALSE.

                    /* disconnect now */
                    RUN appServerDisconnect IN appSrvUtils 
                        (INPUT pcPartitionName) NO-ERROR.
                END.
        END.
    END.
    ELSE
        RETURN "PARTITION-NOT-FOUND":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject Procedure 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     Called before procedure is deleted so we can do some cleanup
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    IF VALID-HANDLE(hImportProc) THEN
       DELETE PROCEDURE hImportProc.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-disconnectAppServer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disconnectAppServer Procedure 
PROCEDURE disconnectAppServer :
/*------------------------------------------------------------------------------
  Purpose:     Disconnect the appserver based on the partition named
               specified by the caller.
               
  Parameters:  INPUT pcPartitionName - partition name.
  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcPartitionName AS CHARACTER NO-UNDO.

    /* we only do AppServer if there is a partition with the name specified
       by the caller. This is the "APMT" partition for the APMT utility.
    */
    IF checkPartition (pcPartitionName) THEN DO:
        /* disconnect now */
        RUN appServerDisconnect IN appSrvUtils 
            (INPUT pcPartitionName) NO-ERROR.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-export-audit-events) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE export-audit-events Procedure 
PROCEDURE export-audit-events :
/*------------------------------------------------------------------------------
  Purpose:     Export the audit events from the database specified to a .ad file.
               This routine retrieves the data using a dataset and then exports the data.
               See export-cached-audit-events if you want to export the info already cached
               in a dataset, if you have your own dataset object.
               
  Parameters:  INPUT  pcDbInfo    - db info. You can specify the unknown value if one
                                    and only one db is connected.
               INPUT  pcFileName  - name of file to generate
               OUTPUT pnumRecords - number of records exported
               
  Notes:       This routine returnes message to the caller, which should then check
               RETURN-VALUE
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER  pcDbInfo   AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER  pcFileName  AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pnumRecords AS INT64     NO-UNDO.

DEFINE VARIABLE hDset AS HANDLE    NO-UNDO.

    /* get latest records into a dataset */
    RUN getAuditEvents ( INPUT pcDbInfo, INPUT YES, OUTPUT DATASET-HANDLE hDSet).
    
    IF RETURN-VALUE <> "":U THEN
       RETURN RETURN-VALUE.    

    /* call the procedure to export the events, and return any error to the caller */
    RUN auditing/_exp-audevent.p (INPUT pcFileName,
                                  INPUT DATASET-HANDLE hDset BY-REFERENCE,
                                  OUTPUT pnumRecords) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN
       RETURN ERROR-STATUS:GET-MESSAGE(1).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-export-cached-audit-events) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE export-cached-audit-events Procedure 
PROCEDURE export-cached-audit-events :
/*------------------------------------------------------------------------------
  Purpose:     Export the audit events from the dataset specified to a .ad file.
               This routine retrieves the data cached in a dataset object passed in. 
               See exportAuditEvents if you want to refresh the data before exporting.
               
  Parameters:  INPUT pcFileName - name of file to generate
               INPUT dataset-handle 
               OUTPUT pnumRecords - number of records exported
               
  Notes:       This routine returnes message to the caller, which should then check
               RETURN-VALUE  
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER  pcFileName  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER  DATASET-HANDLE hDset.
DEFINE OUTPUT PARAMETER pnumRecords AS INT64     NO-UNDO.

    /* call the procedure to export the events, and return any error to the caller */
    RUN auditing/_exp-audevent.p (INPUT pcFileName,
                                  INPUT DATASET-HANDLE hDset BY-REFERENCE,
                                  OUTPUT pnumRecords) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
        RETURN ERROR-STATUS:GET-MESSAGE(1).
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fill-audit-dataset) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fill-audit-dataset Procedure 
PROCEDURE fill-audit-dataset :
/*------------------------------------------------------------------------------
  Purpose:     Fill a dataset with the audit policies from the database specified.
               pcDbInfo contains the db info string which contains the logical db
               name and also information on whether the db is on an AppServer, in 
               which case we have to forward the request to the AppServer.
  
  Parameters:  INPUT  pcDbInfo - db info. 
               OUTPUT phDset   - dataset object
               
  Notes:       Caller should check RETURN-VALUE for error messages
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcDbInfo AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER DATASET-HANDLE phDset.

DEFINE VARIABLE phAppService AS HANDLE    NO-UNDO.
DEFINE VARIABLE errorMsg     AS CHARACTER NO-UNDO.   
DEFINE VARIABLE cDbName      AS CHARACTER NO-UNDO.

    /* get the db name out of the dbinfo string */
    ASSIGN cDbName = get-DB-Name(pcDbInfo).

    /* check if we need to direct the call to the appserver */
    IF isDBOnAppServer(pcDbInfo) THEN DO:

        /* get appserver handle */
        ASSIGN phAppService = getAppServerHdl().
         
        /* send request to Appserver, if one is connected */
        IF VALID-HANDLE(phAppService) THEN DO:
           RUN auditing/_get-policies.p ON phAppService(INPUT cDbName,
                                                        OUTPUT DATASET-HANDLE phDset,
                                                        OUTPUT errorMsg).
        END.

    END.
    ELSE
        RUN auditing/_get-policies.p (INPUT cDbName,
                                      OUTPUT DATASET-HANDLE phDset,
                                      OUTPUT errorMsg).

    /* save this info away */
    phDset:PRIVATE-DATA = pcDbInfo.

    RETURN errorMsg.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fill-fields-tt) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fill-fields-tt Procedure 
PROCEDURE fill-fields-tt :
/*------------------------------------------------------------------------------
  Purpose:    Populate a temp-table with the fields of a table. The procedure
              we call will only load the fields of a given table/owner
              combination once - which means, if more than one db is connected
              which contains the same table/owner, we will only load the first
              one we find into the temp-table. 
              
  Parameters: INPUT  pcTableInfo - table,owner information
              OUTPUT hFieldTT    - temp-table handle where to load the records
                                   into.
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcTableInfo AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE-HANDLE hFieldTT.

DEFINE VARIABLE phAppService AS HANDLE    NO-UNDO.
    
    /* only look at local db's if not on WebClient */
    IF {&NOT-WEBCLIENT} THEN DO:
        /* build temp-table with tables from local connected dbs first */
        RUN auditing/_get-field-list.p (INPUT pcTableInfo,
                                        OUTPUT TABLE-HANDLE hFieldTT).
        IF VALID-HANDLE(hFieldTT) THEN DO:
            /* if we found the table in one of the connected db's,
               we are all set - don't need to submit request to the AppServer */
            hFieldTT:DEFAULT-BUFFER-HANDLE:FIND-FIRST() NO-ERROR.
    
            IF hFieldTT:DEFAULT-BUFFER-HANDLE:AVAILABLE THEN
                RETURN.
        END.
    END.

    /* get appserver handle */
    ASSIGN phAppService = getAppServerHdl().
    
    /* send request to Appserver, if one is connected */
    IF VALID-HANDLE(phAppService) THEN DO:
        RUN auditing/_get-field-list.p ON phAppService (INPUT pcTableInfo,
                                                        OUTPUT TABLE-HANDLE hFieldTT).
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fill-tables-tt) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fill-tables-tt Procedure 
PROCEDURE fill-tables-tt :
/*------------------------------------------------------------------------------
  Purpose:    Populate a temp-table with the tables in a given database 
  
  Parameters: INPUT pcDbInfo - db info string
              OUTPUT hFileTT - temp-table handle
              
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcDbInfo AS CHARACTER.
DEFINE OUTPUT PARAMETER TABLE-HANDLE hFileTT.
    
DEFINE VARIABLE iCnt AS INTEGER  NO-UNDO.
DEFINE VARIABLE cAppService  AS CHARACTER NO-UNDO.
DEFINE VARIABLE phAppService AS HANDLE    NO-UNDO.
DEFINE VARIABLE cDbName      AS CHARACTER NO-UNDO.
    
DEFINE VARIABLE hQuery  AS HANDLE NO-UNDO.
DEFINE VARIABLE hBuffer AS HANDLE NO-UNDO.

    /* get the db name out of the dbinfo string */
    ASSIGN cDbName = get-DB-Name (pcDbInfo).

    /* check if we need to direct the call to the appserver */
    IF isDBOnAppServer(pcDbInfo) THEN DO:
    
        /* get appserver handle */
        ASSIGN phAppService = getAppServerHdl().

        /* send request to Appserver, if one is connected */
        IF VALID-HANDLE(phAppService) THEN DO:
    
            RUN auditing/_get-table-list.p ON phAppService (INPUT cDbName,
                                                            OUTPUT TABLE-HANDLE hFileTT).
        END.

    END.
    ELSE IF {&NOT-WEBCLIENT} THEN DO:
        /* build temp-table with tables from connected dbs */
        RUN auditing/_get-table-list.p (INPUT cDbName, 
                                        OUTPUT TABLE-HANDLE hFileTT).
    END.

    /* now go through each one of the records we got in the temp-table
       and replace the db-name with the dbinfo passed in.
    */
    CREATE QUERY hQuery.
    hBuffer = hFileTT:DEFAULT-BUFFER-HANDLE.
    hQuery:SET-BUFFERS(hBuffer).
    hQuery:QUERY-PREPARE("FOR EACH ":U + hBuffer:NAME).
    hQuery:QUERY-OPEN.
    hQuery:GET-FIRST().
    DO WHILE NOT hQuery:QUERY-OFF-END.
        hBuffer::_db-name = pcDbInfo.
        hQuery:GET-NEXT().
    END.
    hQuery:QUERY-CLOSE.
    DELETE OBJECT hQuery.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-complete-dbname-list) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-complete-dbname-list Procedure 
PROCEDURE get-complete-dbname-list :
/*------------------------------------------------------------------------------
  Purpose:     Get a complete list of connected databases. It also handles cases
               where db is on the AppServer, if we have a connection to the AppServer.
               The list contains entries separated by chr(1). The list contains entries
               separated by chr(1). Each entry contains the logical database name. 
               It may also contain some additional information such as read-only or 
               appserver. List of possible entries is defined in auditing/include/_aud-std.i.
               
  Parameters:  OUTPUT pcList - list of databases, each db separated by chr(1) - see comments
                               above
                               
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER pcList AS CHAR NO-UNDO.

DEFINE VARIABLE cAppList AS CHAR    NO-UNDO.
DEFINE VARIABLE iLoop    AS INTEGER NO-UNDO.

DEFINE VARIABLE phAppService AS HANDLE    NO-UNDO.

    /* only look at local db's if not running WebClient */
    IF {&NOT-WEBCLIENT} THEN
        /* first get db's connected on this session */
        RUN auditing/_get-db-list.p (YES /* complete list */, 
                                     OUTPUT pcList).
      
    /* get appserver handle */
    ASSIGN phAppService = getAppServerHdl().

    /* now let's see if we need to add databases connected on the AppServer */
    IF VALID-HANDLE(phAppService) AND 
       phAppService <> SESSION AND
       phAppService:CONNECTED() THEN DO:

        RUN auditing/_get-db-list.p ON  phAppService (YES, OUTPUT cAppList).
      
        /* append to the existing list */
        IF pcList = "":U OR pcList = ? THEN
           ASSIGN pcList = cAppList.
        ELSE IF cAppList <> ? AND cAppList <> "":U THEN
           ASSIGN pcList = pcList + CHR(1) + cAppList.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-dbname-list) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-dbname-list Procedure 
PROCEDURE get-dbname-list :
/*------------------------------------------------------------------------------
  Purpose:    Get a list of connected databases with auditing enabled. It also handles cases
              where db is on the appserver, if we have a connection to an AppServer.
              The list contains entries separated by chr(1). Each entry contains the 
              logical database name. It may also contain additional information such 
              as read-only or appserver. List of possible entries is defined in 
              auditing/include/_aud-std.i.
              
  Parameters:  OUTPUT pcList - list of databases, each db separated by chr(1) - see comments
                               above
                               
  Notes:
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER pcList AS CHAR NO-UNDO.

DEFINE VARIABLE cAppList     AS CHAR      NO-UNDO.
DEFINE VARIABLE phAppService AS HANDLE    NO-UNDO.
DEFINE VARIABLE iLoop        AS INTEGER   NO-UNDO.
    
    /* only look at local db's if not running WebClient */
    IF {&NOT-WEBCLIENT} THEN
        /* first get db's connected on this session */
        RUN auditing/_get-db-list.p (NO /* not complete list */, 
                                     OUTPUT pcList).

    /* get appserver handle */
    ASSIGN phAppService = getAppServerHdl().

    /* now let's see if we need to add databases connected on the AppServer */
    IF VALID-HANDLE(phAppService) AND 
       phAppService <> SESSION AND
       phAppService:CONNECTED() THEN DO:
    
        RUN auditing/_get-db-list.p ON  phAppService (NO, OUTPUT cAppList).
    
        /* append to the existing list */
        IF pcList = "":U OR pcList = ? THEN
           ASSIGN pcList = cAppList.
        ELSE IF cAppList <> ? AND cAppList <> "":U THEN
           ASSIGN pcList = pcList + CHR(1) + cAppList.
    END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-policies-merge) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-policies-merge Procedure 
PROCEDURE get-policies-merge :
/*------------------------------------------------------------------------------
  Purpose:     Get the merged version of the active policies so the caller
               can generate a report. We follow the following rules
               to determine if a given setting should be reported:
               
               - We only read active policies;
               - Audit events take precedence over table or field setting. Therefore,
                 auditing is off for an event at table or field level (create, delete,
                 update), the table and field level setting is ignored;
               - Event can only have a single setting - aggregate values;
               - table/field can only have a single setting - aggregate values.
               - check if identifying fields as unique for a given table (if posiiton  > 0)
               
  Parameters:  INPUT    hDset - dataset with policies
               OUTPUT  ttHandle - temp-table where we will store merged information
  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER DATASET-HANDLE hDset.
DEFINE OUTPUT PARAMETER TABLE-HANDLE ttHandle.

RUN auditing/_aud-conflict.p (NO, /*not conflict mode */
                              INPUT DATASET-HANDLE hDset BY-REFERENCE,
                              OUTPUT TABLE-HANDLE ttHandle).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAuditEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getAuditEvents Procedure 
PROCEDURE getAuditEvents :
/*------------------------------------------------------------------------------
  Purpose:     Populate a dataset with the audit event records from the database
               specified in pcDbInfo.   
               
  Parameters:  INPUT pcDbInfo    - database name plus additional info
               INPUT plGetAllEvents - determines if caller wants to get system events as well
               OUTPUT hEventDset - handle to dataset object
               
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcDbInfo       AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER plGetAllEvents AS LOGICAL   NO-UNDO.
DEFINE OUTPUT PARAMETER DATASET-HANDLE hEventDset.

DEFINE VARIABLE errorMsg     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDbName      AS CHARACTER NO-UNDO.
DEFINE VARIABLE phAppService AS HANDLE    NO-UNDO.

    /* get the db name out of the dbinfo string */
    ASSIGN cDbName = get-DB-Name (pcDbInfo).

    /* check if we need to direct the call to the appserver */
    IF isDBOnAppServer(pcDbInfo) THEN DO:

        /* get appserver handle */
        ASSIGN phAppService = getAppServerHdl().

        /* send request to Appserver, if one is connected */
        IF VALID-HANDLE(phAppService) THEN
           RUN auditing/_get-audevents.p ON phAppService (INPUT cDbName, 
                                                          INPUT plGetAllEvents,
                                                          OUTPUT DATASET-HANDLE hEventDset,
                                                          OUTPUT errorMsg). 
                                                       
    END.
    ELSE DO:
        RUN auditing/_get-audevents.p (INPUT cDbName, 
                                       INPUT plGetAllEvents,
                                       OUTPUT DATASET-HANDLE hEventDset,
                                       OUTPUT errorMsg).
    END.
           
    IF errorMsg = "":U OR errorMsg = ? THEN
       /* let everyone interested know that we retrieve the events*/
       PUBLISH "refreshAuditEvents" (?).

    RETURN errorMsg.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-override-policies-from-xml) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE override-policies-from-xml Procedure 
PROCEDURE override-policies-from-xml :
/*------------------------------------------------------------------------------
  Purpose:     This should only be called after a call to policies-dataset-read-xml
               returned a list with duplicate policy names. The caller calls
               this when we are supposed to override the existing polcies by copying the 
               records it previously loaded into the dataset passed in.
               
  Parameters:  INPUT-OUTPUT phDataset - dataset where to copy the info to
               OUTPUT       pcErrorMsg - error messages
               
  Notes:       See policies-dataset-read-xml for more details.
------------------------------------------------------------------------------*/
DEFINE INPUT-OUTPUT PARAMETER DATASET-HANDLE phDataSet.
DEFINE OUTPUT       PARAMETER pcErrorMsg    AS CHARACTER NO-UNDO.
    
    IF NOT VALID-HANDLE(hImportProc) THEN DO:
        /* if the import procedure was deleted, then we must have had an error
           or the caller didn't even try to call policies-dataset-read-xml
        */
        ASSIGN pcErrorMsg = "Cannot override dataset from XML. Invalid state".
        RETURN.
    END.

    /* tell the procedure to copy the records into the dataset */
    RUN copy-changes-to-dset IN hImportProc (INPUT-OUTPUT DATASET-HANDLE phDataSet BY-REFERENCE,
                                             OUTPUT pcErrorMsg).

    /* we are done, get rid of the import procedure */
    RUN cleanup IN hImportProc.
    DELETE PROCEDURE hImportProc.
    ASSIGN hImportProc = ?.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-policies-dataset-read-xml) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE policies-dataset-read-xml Procedure 
PROCEDURE policies-dataset-read-xml :
/*------------------------------------------------------------------------------
  Purpose:    Read xml file containing audit policies and populate dataset. If the
              dataset already conatins one or more policies defined in the
              XML file, this routine returns a comma-separated list of
              duplicate policies in pcList so caller can decide if
              we should override existing policies while loading the xml
              into the dataset. See resubmit-import-from-xml.
              
  Parameters:  INPUT        pcxmlFileName - xml file name
               INPUT-OUPUT  phDataSet     - dataset object
               OUTPUT       pcList        - list of existing policies
               OUTPUT       pcErrorMsg    - error messages
               
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT        PARAMETER pcxmlFileName AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER DATASET-HANDLE phDataSet.
DEFINE OUTPUT       PARAMETER pcList        AS CHARACTER NO-UNDO.
DEFINE OUTPUT       PARAMETER pcErrorMsg    AS CHARACTER NO-UNDO.


    /* start it if not already started */
    IF NOT VALID-HANDLE (hImportProc) THEN
       RUN auditing/_imp-policies.p  PERSISTENT SET hImportProc.
    
    /* call the generic call passing our local dataset */
    RUN import-xml-fill-dset IN hImportProc (INPUT pcxmlFileName,
                                             INPUT NO, /* don't override */
                                             INPUT-OUTPUT DATASET-HANDLE phDataSet BY-REFERENCE,
                                             OUTPUT pcList,
                                             OUTPUT pcErrorMsg).

    /* if no error and duplicate list is empty, we successfully imported
       the policies from the xml into the dataset, so we can clean up
       and delete procedure 
    */
    IF pcErrorMsg <> "" AND pcList = "" THEN DO:
        RUN cleanup IN hImportProc.
        DELETE PROCEDURE hImportProc.
        ASSIGN hImportProc = ?.
    END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-policies-dataset-write-xml) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE policies-dataset-write-xml Procedure 
PROCEDURE policies-dataset-write-xml :
/*------------------------------------------------------------------------------
  Purpose:     Generate XML file with policy settings stored in dataset passed in
  
  Parameters:  INPUT  pcPolicyList  - comma-separated list of policies to export,
                                      or '*' for all policies
               INPUT  pcxmlFileName - file name
               INPUT  phDataSet     - dataset object holding the policy settings
               OUTPUT pcErrorMsg    - error messages
               
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcPolicyList  AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pcxmlFileName AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER DATASET-HANDLE phDataSet.
DEFINE OUTPUT PARAMETER pcErrorMsg    AS CHARACTER NO-UNDO.

DEFINE VARIABLE cDbInfo       AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDbName       AS CHARACTER NO-UNDO.
DEFINE VARIABLE cList         AS CHARACTER NO-UNDO.
DEFINE VARIABLE phAppService  AS HANDLE    NO-UNDO.

DEFINE VARIABLE hQuery        AS HANDLE    NO-UNDO.
DEFINE VARIABLE hBuffer       AS HANDLE    NO-UNDO.

/* we save away the db info in the dataset's provate data. So check if there is something in there.
   If not, this could be someone else's dataset and we don't know what's in there.
*/
cDbInfo = phDataSet:PRIVATE-DATA.

IF LENGTH(cDbInfo) > 0 THEN DO:

    cDbName = get-DB-Name (cDbInfo).

    IF cDbName NE ? AND cDbName NE "" THEN DO:

        /* get a list of the policies that will be exported */

        CREATE QUERY hQuery.

        hBuffer = phDataSet:GET-BUFFER-HANDLE(1).
        hquery:SET-BUFFERS(hBuffer).
        hQuery:QUERY-PREPARE("FOR EACH ":U + hBuffer:NAME + " WHERE CAN-DO('" +
                             pcPolicyList + "',_audit-policy-name)" ).
        hQuery:QUERY-OPEN.
        hQuery:GET-FIRST().
        DO WHILE NOT hQuery:QUERY-OFF-END.
            IF cList = "" THEN
               cList = hBuffer::_audit-policy-name.
            ELSE
               cList = cList + "," + hBuffer::_audit-policy-name NO-ERROR.

            hQuery:GET-NEXT().
        END.
        hQuery:QUERY-CLOSE.
        DELETE OBJECT hQuery.

        IF isDBOnAppServer(cDbInfo) THEN DO:
    
            /* get appserver handle */
            ASSIGN phAppService = getAppServerHdl().
             
            /* send request to Appserver, if one is connected */
            IF VALID-HANDLE(phAppService) THEN DO:
               RUN auditing/_wrtev.p ON phAppService(INPUT 10303,
                                                     INPUT cList,
                                                     INPUT cDbName,
                                                     OUTPUT pcErrorMsg).
               IF pcErrorMsg NE "" THEN
                   RETURN.
            END.
        END.
        ELSE DO:
            RUN auditing/_wrtev.p (INPUT 10303,
                                   INPUT cList,
                                   INPUT cDbName,
                                   OUTPUT pcErrorMsg).
            IF pcErrorMsg NE "" THEN
                RETURN.
        END.
    END.

END.

/* call _exp-policies.p to do the job */
RUN auditing/_exp-policies.p (INPUT pcPolicyList,
                              INPUT pcxmlFileName, 
                              INPUT DATASET-HANDLE phDataSet BY-REFERENCE,
                              OUTPUT pcErrorMsg).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-populate-aud-event-policy-tt) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populate-aud-event-policy-tt Procedure 
PROCEDURE populate-aud-event-policy-tt :
/*------------------------------------------------------------------------------
  Purpose:    Populate the temp-table with the records from the _aud-event-policy
              table from the database specified in pcDbInfo.
              
  Parameters: INPUT  pcDbInfo - database info string
              INPUT-OUTPUT  hEventPolicyTT - handle to the temp-table
               
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT        PARAMETER pcDbInfo  AS CHARACTER    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE hEventPolicyTT.

DEFINE VARIABLE phAppService AS HANDLE    NO-UNDO.
DEFINE VARIABLE cDbName      AS CHARACTER NO-UNDO.

    /* get the db name out of the dbinfo string */
    ASSIGN cDbName = get-DB-Name (pcDbInfo).

    /* check if we need to direct the call to the appserver */
    IF isDBOnAppServer(pcDbInfo) THEN DO:
        
        /* get appserver handle */
        ASSIGN phAppService = getAppServerHdl().

        /* send request to Appserver, if one is connected */
        IF VALID-HANDLE(phAppService) THEN DO:
            RUN auditing/_get-policies-tt.p ON phAppService (INPUT "_aud-event-policy":U,
                                                             INPUT cDbName, 
                                                             INPUT-OUTPUT TABLE-HANDLE hEventPolicyTT). 
        END.
    END.
    ELSE DO:
        RUN auditing/_get-policies-tt.p (INPUT "_aud-event-policy":U,
                                         INPUT cDbName, 
                                         INPUT-OUTPUT TABLE-HANDLE hEventPolicyTT). 
    END.
            
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-populate-aud-field-policy-tt) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populate-aud-field-policy-tt Procedure 
PROCEDURE populate-aud-field-policy-tt :
/*------------------------------------------------------------------------------
  Purpose:    Populatesthe temp-table with the records from the _aud-file-policy
              table in the database specified in pcDbInfo.
              
  Parameters:  INPUT pcDbInfo - database info string
               INPUT-OUTPUT hFieldPolicyTT - handle to the temp-table
               
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT        PARAMETER pcDbInfo  AS CHARACTER    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE hFieldPolicyTT.

DEFINE VARIABLE phAppService AS HANDLE    NO-UNDO.
DEFINE VARIABLE cDbName      AS CHARACTER NO-UNDO.

    /* get the db name out of the dbinfo string */
    ASSIGN cDbName = get-DB-Name (pcDbInfo).

    /* check if we need to direct the call to the appserver */
    IF isDBOnAppServer (pcDbInfo) THEN DO:

        /* get appserver handle */
        ASSIGN phAppService = getAppServerHdl().

        /* send request to Appserver, if one is connected */
        IF VALID-HANDLE(phAppService) THEN DO:
            RUN auditing/_get-policies-tt.p ON phAppService (INPUT "_aud-field-policy":U,
                                                             INPUT cDbName, 
                                                             INPUT-OUTPUT TABLE-HANDLE hFieldPolicyTT). 
        END.
    END.
    ELSE DO:
        RUN auditing/_get-policies-tt.p (INPUT "_aud-field-policy":U,
                                         INPUT cDbName, 
                                         INPUT-OUTPUT TABLE-HANDLE hFieldPolicyTT). 
    END.
            
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-populate-aud-file-policy-tt) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populate-aud-file-policy-tt Procedure 
PROCEDURE populate-aud-file-policy-tt :
/*------------------------------------------------------------------------------
  Purpose:    Populate the temp-table with the records from the _aud-file-policy
              table in the database specified in pcDbInfo.
              
  Parameters:  INPUT pcDbName - database info string
               INPUT-OUTPUT hFilePolicyTT - handle to the temp-table
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT        PARAMETER pcDbInfo  AS CHARACTER    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE hFilePolicyTT.

DEFINE VARIABLE phAppService AS HANDLE    NO-UNDO.
DEFINE VARIABLE cDbName      AS CHARACTER NO-UNDO.

    /* get the db name out of the dbinfo string */
    ASSIGN cDbName = get-DB-Name (pcDbInfo).

    /* check if we need to direct the call to the appserver */
    IF isDBOnAppServer(pcDbInfo) THEN DO:
        
        /* get appserver handle */
        ASSIGN phAppService = getAppServerHdl().

        /* send request to Appserver, if one is connected */
        IF VALID-HANDLE(phAppService) THEN DO:
            RUN auditing/_get-policies-tt.p ON phAppService (INPUT "_aud-file-policy":U,
                                                            INPUT cDbName, 
                                                            INPUT-OUTPUT TABLE-HANDLE hFilePolicyTT). 
        END.
    END.
    ELSE DO:
        RUN auditing/_get-policies-tt.p (INPUT "_aud-file-policy":U,
                                         INPUT cDbName, 
                                         INPUT-OUTPUT TABLE-HANDLE hFilePolicyTT). 
    END.
            
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-populate-audit-policy-tt) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populate-audit-policy-tt Procedure 
PROCEDURE populate-audit-policy-tt :
/*------------------------------------------------------------------------------
  Purpose:    Populate the temp-table with the records from the _aud-audit-policy
              table in the database specified in pcDbInfo.
              
  Parameters:  pcDbInfo - database info string
               hpolicyTT - handle to the temp-table where to load the info into
               
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT        PARAMETER pcDbInfo  AS CHARACTER    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE hpolicyTT.

DEFINE VARIABLE phAppService AS HANDLE    NO-UNDO.
DEFINE VARIABLE cDbName      AS CHARACTER NO-UNDO.

    /* get the db name out of the dbinfo string */
    ASSIGN cDbName = get-DB-Name (pcDbInfo).

    /* check if we need to direct the call to the appserver */
    IF isDBOnAppServer(pcDbInfo) THEN DO:

        /* get appserver handle */
        ASSIGN phAppService = getAppServerHdl().

        /* send request to Appserver, if one is connected */
        IF VALID-HANDLE(phAppService) THEN DO:
            RUN auditing/_get-policies-tt.p ON phAppService (INPUT "_aud-audit-policy":U,
                                                             INPUT cDbName, 
                                                             INPUT-OUTPUT TABLE-HANDLE hPolicyTT). 
        END.
    END.
    ELSE DO:
        RUN auditing/_get-policies-tt.p (INPUT "_aud-audit-policy":U,
                                         INPUT cDbName, 
                                         INPUT-OUTPUT TABLE-HANDLE hPolicyTT). 
    END.
            
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAppServerHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setAppServerHandle Procedure 
PROCEDURE setAppServerHandle :
/*------------------------------------------------------------------------------
  Purpose:     Set the AppServer handle specified by the caller and use it
               whenever this procedure needs to forward a request to the 
               AppServer.
               
  Parameters:  INPUT hAppServer - handle of an AppServer connection
  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER hAppServer AS HANDLE NO-UNDO.

ASSIGN suppliedAppSrvHdl = hAppServer.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCallerHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setCallerHandle Procedure 
PROCEDURE setCallerHandle :
/*------------------------------------------------------------------------------
  Purpose:     Set the handle of the caller procedure. Basically only used by
               the APMT
  
  Parameters:  INPUT h-proc - procedure's handle
  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER h-proc AS HANDLE.

    ASSIGN hCaller = h-proc.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-update-auditing-policies) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE update-auditing-policies Procedure 
PROCEDURE update-auditing-policies :
/*------------------------------------------------------------------------------
  Purpose:     Save the changes tracked in the dataset object passed in into the
               database specified. The dataset contains audit policy settings.
               
  Parameters: INPUT pcDbInfo - database info string
              INPUT-OUTPUT dataset - dataset where to save the changes   
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT        PARAMETER pcDbInfo AS CHAR    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER DATASET-HANDLE hDset.

DEFINE VARIABLE phAppService AS HANDLE    NO-UNDO.
DEFINE VARIABLE errorMsg     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDbName      AS CHARACTER NO-UNDO.

    /* get the db name out of the dbinfo string */
    ASSIGN cDbName = get-DB-Name (pcDbInfo).

    /* check if we need to direct the call to the appserver */
    IF isDBOnAppServer(pcDbInfo) THEN DO:

        /* get appserver handle */
        ASSIGN phAppService = getAppServerHdl().

        /* send request to Appserver, if one is connected */
        IF VALID-HANDLE(phAppService) THEN DO:
           RUN auditing/_update-policies.p ON phAppService(INPUT cDbName,
                                                           INPUT-OUTPUT DATASET-HANDLE hDset,
                                                           OUTPUT errorMsg).
         END.
    END.
    ELSE
        RUN auditing/_update-policies.p (INPUT cDbName,
                                         INPUT-OUTPUT DATASET-HANDLE hDset BY-REFERENCE,
                                         OUTPUT errorMsg).

    RETURN errorMsg.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateAuditEvent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateAuditEvent Procedure 
PROCEDURE updateAuditEvent :
/*------------------------------------------------------------------------------
  Purpose:    Save the changes tracked in the given dataset object into 
              the database specified in pcDbInfo. The dataset contains records
              from the audit event table.
              
  Parameters:  INPUT pcDbInfo - database info string
               INPUT-OUTPUT dataset - dataset where to save the changes   
                             
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcDbInfo AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER DATASET-HANDLE hDset.

DEFINE VARIABLE phAppService AS HANDLE    NO-UNDO.
DEFINE VARIABLE errorMsg     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDbName      AS CHARACTER NO-UNDO.

    /* get the db name out of the dbinfo string */
    ASSIGN cDbName = get-DB-Name (pcDbInfo).

    /* check if we need to direct the call to the appserver */
    IF isDBOnAppServer(pcDbInfo) THEN DO:
        
        /* get appserver handle */
        ASSIGN phAppService = getAppServerHdl().

        /* send request to Appserver, if one is connected */
        IF VALID-HANDLE(phAppService) THEN DO: 
        
            RUN auditing/_update-audevents.p ON phAppService (INPUT cDbName,
                                                              INPUT-OUTPUT DATASET-HANDLE hDset,
                                                              OUTPUT errorMsg).
        END.
    END.
    ELSE DO:
        RUN auditing/_update-audevents.p (INPUT cDbName,
                                          INPUT-OUTPUT DATASET-HANDLE hDset BY-REFERENCE,
                                          OUTPUT errorMsg).
    END.

    RETURN errorMsg.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-checkPartition) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION checkPartition Procedure 
FUNCTION checkPartition RETURNS LOGICAL
  ( cPartitionName AS CHARACTER /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Check if partition cPartitionName exists
    Notes:  This is used by the APMT to handle AppServer connection. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cPartitions AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iloop       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iFound      AS LOGICAL   NO-UNDO INIT NO.
  
  cPartitions = DYNAMIC-FUNCTION('definedPartitions' IN AppSrvUtils) NO-ERROR.

  DO iLoop = 1 TO NUM-ENTRIES(cPartitions,CHR(3)):
     IF ENTRY(iLoop,cPartitions,CHR(3)) <> cPartitionName THEN NEXT.
     /* if we got here, we found it */
     ASSIGN iFound = TRUE.
  END.

  RETURN iFound.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-DB-Name) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION get-DB-Name Procedure 
FUNCTION get-DB-Name RETURNS CHARACTER
  ( pcDbInfo AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Get the db name out of the db info string
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VAR cRet AS CHARACTER NO-UNDO INIT ?.

  cRet = ENTRY(1,pcDbInfo) NO-ERROR.
 
  RETURN cRet.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAppServerHdl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAppServerHdl Procedure 
FUNCTION getAppServerHdl RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Get the AppServer handle we should use to get to the AppServer.
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cAppService  AS CHARACTER NO-UNDO.
DEFINE VARIABLE phAppService AS HANDLE    NO-UNDO.

  IF suppliedAppSrvHdl = SESSION THEN
     RETURN ?. /* not valid appserver hdl */

  /* if we were told to use a specific AppServer, return it */
  IF VALID-HANDLE (suppliedAppSrvHdl) THEN
     RETURN suppliedAppSrvHdl.

  ASSIGN 
  cAppService =  DYNAMIC-FUNCTION('getAppService':U IN hCaller)
  phAppService = DYNAMIC-FUNCTION('getServiceHandle':U IN appSrvUtils,cAppService) NO-ERROR.

  IF phAppService = SESSION THEN
     phAppService = ?.

  RETURN phAppService.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-has-DB-option) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION has-DB-option Procedure 
FUNCTION has-DB-option RETURNS LOGICAL
  ( pcDbInfo AS CHARACTER, pcDbOption AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Check if we can find a given option in the db info string.
            The database info string is returned by get-complete-dbname-list, 
            get-dbname-list and auditing/_get-db-list.p. 
            List of possible entries is defined in auditing/include/_aud-std.i.
    Notes:  
------------------------------------------------------------------------------*/

  /* check if we find the option */
  IF LOOKUP(pcDbOption,pcDbInfo) > 0 THEN
      RETURN TRUE.

  RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-isDBOnAppServer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isDBOnAppServer Procedure 
FUNCTION isDBOnAppServer RETURNS LOGICAL
  ( pcDbInfo AS CHARACTER  ) :
/*------------------------------------------------------------------------------
  Purpose:  Check if the database for the database info passed is on the AppServer.
            If we are running a WebClient session, this is always the case, in which case
            we return TRUE.
    Notes:  
------------------------------------------------------------------------------*/

  /* if can find "APPSERVER" as an entry in the string, return yes */
  /* if WebClient, db is always on the AppServer */
  IF has-DB-option (pcDbInfo, {&APPSRV-MODE}) OR  
     SESSION:CLIENT-TYPE = "WEBCLIENT":U THEN 
      RETURN TRUE.

  RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

