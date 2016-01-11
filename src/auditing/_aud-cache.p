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
    File        : _aud-cache.p
    Purpose     : Contains the API for caching the auditing policies from a
                  given database into a dataset object. The procedures and
                  functions herein defined can be used by other applications
                  if developers want to take advantage of this code and
                  build a different UI, for instance. 
    Syntax      :

    Description : The procedures take advantage of ProDataSets to read and
                  write policies from / to databases. This procedure works
                  as a wrapper for the API defined in auditing/_aud-utils.p,
                  which is a generic API that can potentially work with
                  any dataset (not only the one defined here).
                  We create a dataset object in this procedure and mantain it
                  for the caller so the caller doesn't have to build one.
                  The procedures pass the local dataset to the procedures
                  and functions in the _aud-utils procedure, which is 
                  responsible for doing all the actual work 
                  (reading/writing policies from/to the database).
                  
    Author(s)   : Fernando de Souza
    Created     : Mar 04, 2005
    Notes       :
    
    History
    fernando  06/20/07 Support for large files
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* definition of the audit event temp-table */
{auditing/ttdefs/_audeventtt.i}

/* definition of the temp-table for table names */
{auditing/ttdefs/_audfilett.i}

/* definition of the temp-table for field names */
{auditing/ttdefs/_audfieldtt.i}

{auditing/include/_aud-std.i}

DEFINE VARIABLE tableHandleList   AS HANDLE  EXTENT 4 NO-UNDO.
DEFINE VARIABLE hAuditDset        AS HANDLE  NO-UNDO.
DEFINE VARIABLE hAuditEventDset   AS HANDLE  NO-UNDO.
DEFINE VARIABLE hRelation         AS HANDLE  NO-UNDO.

/* this holds the handle of the caller procedure */
DEFINE VARIABLE hCaller           AS HANDLE    NO-UNDO.

/* holds info about the db we are reading the audit policies from.
   We set it when the caller calls changeAuditDatabase */
DEFINE VARIABLE cDbInfo           AS CHARACTER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-get-owner-tbl-cache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD get-owner-tbl-cache Procedure 
FUNCTION get-owner-tbl-cache RETURNS CHARACTER
  ( pcTableName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNextAppLevelEventID) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNextAppLevelEventID Procedure 
FUNCTION getNextAppLevelEventID RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hasApplEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD hasApplEvents Procedure 
FUNCTION hasApplEvents RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-is-valid-event-id) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD is-valid-event-id Procedure 
FUNCTION is-valid-event-id RETURNS LOGICAL
  ( INPUT pEvent-id AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-is-valid-field-name) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD is-valid-field-name Procedure 
FUNCTION is-valid-field-name RETURNS LOGICAL
  ( pcTableInfo AS CHARACTER, pcFieldName AS CHARACTER )  FORWARD.

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

/*subscribe to some events */

/* this gets published by the sdo's so we can build the dataset object */
SUBSCRIBE "registerAuditTableHandle":U ANYWHERE.

/* this gets published when the user switches to a different database */
SUBSCRIBE "changeAuditDatabase":U ANYWHERE.

/* this event gets published when we need to populate a widget with the
   event id values avaiable in the _aud-event table.
*/
SUBSCRIBE "build-audit-events-list":U ANYWHERE.

/* this event gets published when someone wants the details of a given
   event id.
*/
SUBSCRIBE "get-audit-event-details":U ANYWHERE.

/* start the utilities persistent procedure */
{auditing/include/_aud-utils.i}

/* let's add the audit utilities procedure as our super procedure */
THIS-PROCEDURE:ADD-SUPER-PROCEDURE(hAuditUtils).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-build-audit-events-list) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE build-audit-events-list Procedure 
PROCEDURE build-audit-events-list :
/*------------------------------------------------------------------------------
  Purpose:     Add the event ids available in our cache as items to a
               combo-box.
               
  Parameters:  INPUT hField - the combo-box handle
  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER hField   AS HANDLE NO-UNDO.

  /* get the audit event records into the cache, if not already cached */
  RUN get-audit-events (INPUT ?).

  IF hField:TYPE = "COMBO-BOX":U THEN DO:
      /* clear the item list */
      hField:LIST-ITEMS = "".
      /* add event ids to combo-box */
      FOR EACH ttAuditEvent.
          hField:ADD-LAST(STRING(ttAuditEvent._Event-id)).
      END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-build-local-audit-dataset) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE build-local-audit-dataset Procedure 
PROCEDURE build-local-audit-dataset :
/*------------------------------------------------------------------------------
  Purpose:     Build a dataset in behalf of the caller. Caller passes a comma
               separated list of temp-table handles. The order of the tables in the list 
               must be:
               audit-policy,file-policy,field-policy,event-policy
               
  Parameters:  INPUT tblhdllist - comma-separated character list of temp-table handles
                                  to be used to build the dataset and hold de policy
                                  records
                                  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER tblhdllist AS CHARACTER NO-UNDO.

DEFINE VARIABLE hPolicy      AS HANDLE NO-UNDO.
DEFINE VARIABLE hFilePolicy  AS HANDLE NO-UNDO.
DEFINE VARIABLE hFieldPolicy AS HANDLE NO-UNDO.
DEFINE VARIABLE hEventPolicy AS HANDLE NO-UNDO.

    /* if we already built it, go back - don't need to recreate it */
    IF VALID-HANDLE(hAuditDset) THEN
        RETURN.
    
    CREATE DATASET hAuditDset.

    /* let's get the handle of the tables */
    ASSIGN hPolicy      = WIDGET-HANDLE(ENTRY(1,tblhdllist))
           hFilePolicy  = WIDGET-HANDLE(ENTRY(2,tblhdllist))
           hFieldPolicy = WIDGET-HANDLE(ENTRY(3,tblhdllist))
           hEventPolicy = WIDGET-HANDLE(ENTRY(4,tblhdllist)).
    
    /* add them to the dataset one by one */
    hAuditDset:ADD-BUFFER(hPolicy:DEFAULT-BUFFER-HANDLE).
    hAuditDset:ADD-BUFFER(hFilePolicy:DEFAULT-BUFFER-HANDLE).
    hAuditDset:ADD-BUFFER(hFieldPolicy:DEFAULT-BUFFER-HANDLE).
    hAuditDset:ADD-BUFFER(hEventPolicy:DEFAULT-BUFFER-HANDLE).
    
    /* add the relations */
    hRelation = hAuditDset:ADD-RELATION(hAuditDset:GET-BUFFER-HANDLE(1), 
                                        hAuditDset:GET-BUFFER-HANDLE(2), 
                                        "_Audit-policy-guid,_Audit-policy-guid":U).
    
    hRelation = hAuditDset:ADD-RELATION(hAuditDset:GET-BUFFER-HANDLE(1), 
                                        hAuditDset:GET-BUFFER-HANDLE(3), 
                                        "_Audit-policy-guid,_Audit-policy-guid":U).
    
    hRelation = hAuditDset:ADD-RELATION(hAuditDset:GET-BUFFER-HANDLE(1), 
                                        hAuditDset:GET-BUFFER-HANDLE(4), 
                                        "_Audit-policy-guid,_Audit-policy-guid":U).

    /* set a callback for the row-delete event on the audit-policy and
       audit-file-policy tables, so we delete the corresponding records
       in the children tables.
    */
    hPolicy:DEFAULT-BUFFER-HANDLE:SET-CALLBACK-PROCEDURE('ROW-DELETE':U,"delete-policy":U, THIS-PROCEDURE).
    hFilePolicy:DEFAULT-BUFFER-HANDLE:SET-CALLBACK-PROCEDURE('ROW-DELETE':U,"delete-file-policy":U, THIS-PROCEDURE).

    /* let's set the min-schema-marshal for these temp-tables in case
       we run against an AppServer
    */
    ASSIGN hPolicy:MIN-SCHEMA-MARSHAL = TRUE
           hFilePolicy:MIN-SCHEMA-MARSHAL = TRUE
           hFieldPolicy:MIN-SCHEMA-MARSHAL = TRUE
           hEventPolicy:MIN-SCHEMA-MARSHAL = TRUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-build-local-audit-event-dataset) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE build-local-audit-event-dataset Procedure 
PROCEDURE build-local-audit-event-dataset :
/*------------------------------------------------------------------------------
  Purpose:     Create a local dataset object that we are going to use for 
               the audit event records. We use our local temp-table ttAuditEvent
               
  Parameters:  <none>
  
  Notes:       
------------------------------------------------------------------------------*/

  /* if already built, return */
  IF VALID-HANDLE(hAuditEventDset) THEN
      RETURN.

  CREATE DATASET hAuditEventDset.
              
  /* add ttAuditEvent to the dataset */
  hAuditEventDset:ADD-BUFFER(TEMP-TABLE ttAuditEvent:DEFAULT-BUFFER-HANDLE).

  /* let's set the min-schema-marshal for the temp-tables in case
     we run against an AppServer
  */
  ASSIGN TEMP-TABLE ttAuditEvent:MIN-SCHEMA-MARSHAL = TRUE
         hAuditEventDset:PRIVATE-DATA = "". /* reset private-data */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-changeAuditDatabase) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changeAuditDatabase Procedure 
PROCEDURE changeAuditDatabase :
/*------------------------------------------------------------------------------
  Purpose:    This gets executed/published when we need to change the working database.
              Go ahead and fill our internal dataset object with the policy
              data from the database specified. This should only get executed/published
              if the caller does not have its own dataset object and wants
              us to keep one for them. If the caller passed an empty string,
              we empty the temp-tables in the dataset.
              
  Parameters:  INPUT pcDbInfo - comma-separated list with db info, where db name
                                is the first entry
                                
  Notes:       This routine returns the errors to the caller, so caller should check
               RETURN-VALUE.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcDbInfo AS CHARACTER NO-UNDO.

DEFINE VARIABLE cHdlList  AS CHARACTER NO-UNDO.
DEFINE VARIABL  cErrorMsg AS CHARACTER NO-UNDO.

    /* check if we need to build the dataset - only do this if not already created */
    IF NOT VALID-HANDLE (hAuditDset) THEN DO:
    
        /* if the caller passed an empty string, and we haven't build our
           local dataset, just return. 
        */
        IF pcDbInfo = "" THEN
            RETURN.

        /* we use the list of handles passed to us through registerAuditTableHandle */
        ASSIGN cHdlList = STRING(tableHandleList[1]) + ",":U +
                          STRING(tableHandleList[2]) + ",":U +
                          STRING(tableHandleList[3]) + ",":U +
                          STRING(tableHandleList[4]).
        
        IF cHdlList = ? THEN
            RETURN "Could not retrieve policies. One or more tables are unknown".

        RUN build-local-audit-dataset (INPUT cHdlList).
    
    END.

    /* if he have a dataset for the audit event table, empty it */
    /* we will fill it only when necessary - the caller determines
       when to fill it 
    */
    IF VALID-HANDLE(hAuditEventDset) THEN DO:
        /* make sure tracking changes is off and empty the dataset */
        hAuditEventDset:GET-BUFFER-HANDLE(1):TABLE-HANDLE:TRACKING-CHANGES = NO.
        hAuditEventDset:PRIVATE-DATA = "":U.

        /* remove the application level events and leave system events so we don't have to
           read them again the next time. 
           NOTE: If we add different events in a next release, then this code should be removed
            since we would have to get all of them anyway.
        */
        FOR EACH ttAuditEvent WHERE _event-id >= 32000.
            DELETE ttAuditEvent.
        END.

    END.
    
    /* fill the dataset with the policies from the given db, If db info
       is an empty string, it will handle it correctly
    */
    RUN populate-local-audit-dataset (INPUT pcDbInfo).
    
    ASSIGN cErrorMsg = RETURN-VALUE.

    /* remember where we read the policies from */
    IF cErrorMsg = "" THEN
       ASSIGN cDbInfo = pcDbinfo.
    ELSE
       ASSIGN cDbInfo = ?.

    /* return any error message to the caller */
    RETURN cErrorMsg.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-delete-file-policy) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE delete-file-policy Procedure 
PROCEDURE delete-file-policy :
/*------------------------------------------------------------------------------
  Purpose:     This is a callback procedure for the ROW-DELETE event of
               the Audit File Policy temp-table. When the user deletes a table
               setting, we have to delete all the settings in the audit field
               policy for that table.
               
  Parameters:  INPUT dsHandle - the dataset handle
  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER DATASET-HANDLE dsHandle.

DEFINE VARIABLE hQuery  AS HANDLE  NO-UNDO.
DEFINE VARIABLE hBuffer AS HANDLE  NO-UNDO.
DEFINE VARIABLE i       AS INTEGER NO-UNDO.

    /* the audit field table should be the 3rd buffer in the dataset */
    hBuffer = hAuditDset:GET-BUFFER-HANDLE(3).

    CREATE QUERY hQuery.
    hQuery:SET-BUFFERS(hBuffer).

    hQuery:QUERY-PREPARE ("FOR EACH ":U + hBuffer:NAME + " WHERE _Audit-policy-guid = "
                           + QUOTER(SELF::_Audit-policy-guid) +  " AND _File-name = ":U
                           + QUOTER(SELF::_File-Name) + " AND _Owner = ":U
                           + QUOTER(SELF::_Owner)) .
    hQuery:QUERY-OPEN.
    hQuery:GET-FIRST.

    DO WHILE NOT hQuery:QUERY-OFF-END:
        hBuffer:BUFFER-DELETE().
        hQuery:GET-NEXT.
    END.

    hQuery:QUERY-CLOSE.
    DELETE OBJECT hQuery.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-delete-policy) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE delete-policy Procedure 
PROCEDURE delete-policy :
/*------------------------------------------------------------------------------
  Purpose:     This is a callback procedure for the ROW-DELETE event of
               the Audit Policy temp-table. When the user deletes a policy
               we have to delete all the settings in the other tables.
               
  Parameters:  INPUT dsHandle - the dataset handle
  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER DATASET-HANDLE dsHandle.

DEFINE VARIABLE hQuery  AS HANDLE  NO-UNDO.
DEFINE VARIABLE hBuffer AS HANDLE  NO-UNDO.
DEFINE VARIABLE i       AS INTEGER NO-UNDO.

    /* go through each buffer in the dataset and delete the records for this policy */
    DO i = 2 TO hAuditDSet:NUM-BUFFERS:
    
        hBuffer = hAuditDset:GET-BUFFER-HANDLE(i).

        CREATE QUERY hQuery.
        hQuery:SET-BUFFERS(hBuffer).

        hQuery:QUERY-PREPARE ("FOR EACH ":U + hBuffer:NAME + " WHERE _Audit-policy-guid = ":U
                               + QUOTER(SELF::_Audit-policy-guid)).
        hQuery:QUERY-OPEN.
        hQuery:GET-FIRST.

        DO WHILE NOT hQuery:QUERY-OFF-END:
            hBuffer:BUFFER-DELETE()>
            hQuery:GET-NEXT.
        END.

        hQuery:QUERY-CLOSE.
        DELETE OBJECT hQuery.
    END.

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
    
    IF VALID-HANDLE(hAuditDset) THEN
       DELETE OBJECT hAuditDset.

    IF VALID-HANDLE (hAuditEventDset) THEN
       DELETE OBJECT hAuditEventDset.

    IF VALID-HANDLE(hAuditUtils) THEN DO:
       DELETE PROCEDURE hAuditUtils.
       ASSIGN hAuditUtils = ?.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-export-cached-audit-events) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE export-cached-audit-events Procedure 
PROCEDURE export-cached-audit-events :
/*------------------------------------------------------------------------------
  Purpose:     Export the audit events from the database specified to a ,ad file.
               This routine retrieves the data cached in our dataset object. See
               exportAuditEvents in aud-utils.p if you want to refresh the data
               before exporting.
               
  Parameters:  pcFileName - name of file to generate
               pnumRecords - number of records exported
               
  Notes:       This routine returnes message to the caller, which should then check
               RETURN-VALUE  
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER  pcFileName  AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pnumRecords AS INT64     NO-UNDO.

    /* call the procedure to export the events, and return any error to the caller */
    RUN auditing/_exp-audevent.p (INPUT pcFileName,
                                  INPUT DATASET-HANDLE hAuditEventDset BY-REFERENCE,
                                  OUTPUT pnumRecords) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN
       RETURN ERROR-STATUS:GET-MESSAGE(1).
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-export-policies-to-xml) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE export-policies-to-xml Procedure 
PROCEDURE export-policies-to-xml :
/*------------------------------------------------------------------------------
  Purpose:    Export policies stored in the local dataset to a XML file.
              Caller specifies the list of policies to be exported, which could be
              "*" to export all policies stored in the dataset.
              
  Parameters:  <none>
  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcPolicyList  AS CHAR      NO-UNDO.
DEFINE INPUT  PARAMETER pcxmlFileName AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pcErrorMsg    AS CHARACTER NO-UNDO.

/* export the policies stored in our local dataset */
RUN policies-dataset-write-xml(INPUT pcPolicyList,
                               INPUT pcxmlFileName, 
                               INPUT DATASET-HANDLE hAuditDset BY-REFERENCE,
                               OUTPUT pcErrorMsg).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-audit-event-details) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-audit-event-details Procedure 
PROCEDURE get-audit-event-details :
/*------------------------------------------------------------------------------
  Purpose:     Return the details of a given event-id (we read them from the cache
               we store in the ttAuditEvent temp-table).
               
  Parameters:  INPUT pEvent-id    - the event id value
               OUTPUT pcEventInfo - the event name and event type separated by chr(1)
               
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER  pEvent-id   AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER pcEventinfo AS CHARACTER NO-UNDO.
    
   /* get the audit event records into the cache, if not already cached */
   RUN get-audit-events (INPUT ?).

   FIND FIRST ttAuditEvent WHERE _Event-id = pEvent-id NO-ERROR.
   IF AVAILABLE ttAuditEvent THEN DO:
        ASSIGN pcEventInfo = ttAuditEvent._Event-name +  CHR(1) 
              + ttAuditEvent._Event-type + CHR(1) 
              /* get just the first 100 characters, in case it's too big */
              + SUBSTRING(ttAuditEvent._Event-description,1,100).
   END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-audit-event-tbl-handle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-audit-event-tbl-handle Procedure 
PROCEDURE get-audit-event-tbl-handle :
/*------------------------------------------------------------------------------
  Purpose:     Return the handle of our ttAuditEvent temp-table
  
  Parameters:  <none>
  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER audit-table-handle AS HANDLE NO-UNDO.

  ASSIGN audit-table-handle = TEMP-TABLE ttAuditEvent:HANDLE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-audit-events) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-audit-events Procedure 
PROCEDURE get-audit-events :
/*------------------------------------------------------------------------------
  Purpose:     Populate our temp-table with the records from the _aud-event
               table of a given db - we read them from the database passed in.
               
  Parameters:  INPUT pcDbInfo - database info, including logical db name.
  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcDbInfo AS CHARACTER NO-UNDO.

DEFINE VARIABLE lGetAll AS LOGICAL NO-UNDO INIT YES.

    IF NOT VALID-HANDLE (hAuditEventDset) THEN
       RUN build-local-audit-event-dataset.
    
    /* if running the APMT utility, we are going to use the same db info set 
       when we executed changeAuditDatabase
    */
    IF pcDbInfo = ? THEN
       pcDbInfo = cDbInfo.

    /* if we emptied the dataset or it's the fist time we are here, fill
       the temp-table 
    */
    IF hAuditEventDSet:PRIVATE-DATA <> pcDbInfo THEN DO:
        
        /* check if we have any system events, if we don't, we need to retrieve
           them as well.
           NOTE: If we add different events in a next release, then this code should be removed
           since we would have to get all of them anyway.
        */
        FIND FIRST ttAuditEvent NO-ERROR.
        IF AVAILABLE ttAuditEvent THEN DO:
           FOR EACH ttAuditEvent WHERE _Event-id >= 32000.
               DELETE ttAuditEvent.
           END.

           ASSIGN lGetAll = NO.
        END.

        RUN getAuditEvents (INPUT pcDbInfo,
                            INPUT lGetAll,
                            OUTPUT DATASET-HANDLE hAuditEventDset APPEND).

        IF RETURN-VALUE <> "" THEN
           RETURN RETURN-VALUE.
    
        /* make sure we turn on tracking-changes */
        ASSIGN TEMP-TABLE ttAuditEvent:TRACKING-CHANGES = YES
               hAuditEventDSet:PRIVATE-DATA = pcDbInfo.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-conflict-info) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-conflict-info Procedure 
PROCEDURE get-conflict-info :
/*------------------------------------------------------------------------------
  Purpose:     Call the generic procedure to check for conflicts on all active
               policies stored in our internal dataset.
               
  Parameters:  OUTPUT ttHandle - temp-table where we store the info
               OUTPUT       pcErrorMsg - error messages returned
  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER TABLE-HANDLE ttHandle.
DEFINE OUTPUT PARAMETER pcErrorMsg AS CHAR NO-UNDO.

    IF NOT VALID-HANDLE(hAuditDset) THEN DO:
        ASSIGN pcErrorMsg = "Invalid state. Dataset object was not created".
        RETURN.
    END.

    /* call the generic function passing our internal dataset object */
    RUN check-conflicts (INPUT DATASET-HANDLE hAuditDset BY-REFERENCE,
                        OUTPUT TABLE-HANDLE ttHandle).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-field-list-cache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-field-list-cache Procedure 
PROCEDURE get-field-list-cache :
/*------------------------------------------------------------------------------
  Purpose:     Return the handle of the ttField temp-table which contains
               the name of the fields of a given table in our cache. 
               We cache them so  we don't have to retrieve them over and over.
               
  Parameters:  INPUT  pcTableInfo - table-name,owner
               OUTPUT hTable   - the handle of the ttField temp-table
  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcTableInfo  AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER hTable       AS HANDLE    NO-UNDO.

   /* check if we already retrieved the list of tables for this db */
   FIND FIRST ttField where ttField._File-name = ENTRY(1,pcTableInfo) AND
       ttField._Owner = entry(2,pcTableInfo) NO-ERROR.

   IF NOT AVAILABLE ttField THEN
      /* populate temp-table */
      RUN fill-fields-tt IN hAuditUtils (INPUT pcTableInfo,
                                         OUTPUT TABLE ttField APPEND ).

   /* return the handle of the ttField to the caller */
   ASSIGN hTable = TEMP-TABLE ttField:HANDLE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-merge-info) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-merge-info Procedure 
PROCEDURE get-merge-info :
/*------------------------------------------------------------------------------
  Purpose:     Call the generic function to get a report of the merged policies
               stored in our internal dataset.
               
  Parameters: OUTPUT ttHandle - temp-table where the report data will be stored  
              OUTPUT pcErrorMsg - returns text with error message
  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER TABLE-HANDLE ttHandle.
DEFINE OUTPUT PARAMETER pcErrorMsg AS CHAR NO-UNDO.

    IF NOT VALID-HANDLE(hAuditDset) THEN DO:
        ASSIGN pcErrorMsg = "Invalid state. Dataset object was not created".
        RETURN.
    END.

    /* call the generic function passing our internal dataset object */
    RUN get-policies-merge (INPUT DATASET-HANDLE hAuditDset BY-REFERENCE,
                            OUTPUT TABLE-HANDLE ttHandle).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-get-table-list-cache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE get-table-list-cache Procedure 
PROCEDURE get-table-list-cache :
/*------------------------------------------------------------------------------
  Purpose:     Return the handle of the ttFile temp-table which contains
               the name of the tables of a given db. We cache them so 
               we don't have to retrieve them over and over.
               
  Parameters:  INPUT  pcDbInfo - db info including db name
               OUTPUT hTable   - the handle of the ttFile temp-table
  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcDbInfo AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER hTable   AS HANDLE    NO-UNDO.

DEFINE VARIABLE cDbName          AS CHARACTER NO-UNDO.
   
   /* get the db name out of the dbinfo string */
   ASSIGN cDbName = DYNAMIC-FUNCTION ('get-DB-Name' IN hAuditUtils, pcDbInfo).

   /* the only option we care is appserver, so if it's there, add it to the mix */
   IF DYNAMIC-FUNCTION ('has-DB-Option' IN hAuditUtils, pcDbInfo, {&DB-APPSERVER}) THEN
      ASSIGN cDbname = cDbName + "," + {&DB-APPSERVER}.

   /* check if we already retrieved the list of tables for this db */
   FIND FIRST ttFile where _db-name = cDbName NO-ERROR.

   IF NOT AVAILABLE ttFile THEN
      /* populate temp-table */
      RUN fill-tables-tt IN hAuditUtils (INPUT pcDbInfo,
                                         OUTPUT TABLE ttFile APPEND ).

   /* return the handle of the ttFile to the caller */
   ASSIGN hTable = TEMP-TABLE ttFile:HANDLE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDataModified Procedure 
PROCEDURE getDataModified :
/*------------------------------------------------------------------------------
  Purpose:     Check if there are any changes since we turned on tracking-changes
               on our local dataset object (created in build-local-audit-dataset)
               
  Parameters:  OUTPUT lMod - returns YES if there are changes pending, otherwise NO
  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER lMod AS LOGICAL NO-UNDO.

DEFINE VARIABLE hBuffer AS HANDLE  NO-UNDO.
DEFINE VARIABLE i       AS INTEGER NO-UNDO.

    ASSIGN lMod = NO.

    /* go through each buffer in the dataset, and check if we can find a record in 
       the before table
    */
    DO i = 1 TO hAuditDset:NUM-BUFFERS:
        ASSIGN hBuffer = hAuditDset:GET-BUFFER-HANDLE(i) /* temp-table buffer */
               hBuffer = hBuffer:BEFORE-BUFFER. /* before buffer */

        /* try to find a record in the before-table */
        hBuffer:FIND-FIRST() NO-ERROR.

        IF hBuffer:AVAILABLE THEN DO:
            lmod = TRUE. /* a change was made */
            LEAVE.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWorkingDbInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getWorkingDbInfo Procedure 
PROCEDURE getWorkingDbInfo :
/*------------------------------------------------------------------------------
  Purpose:     This is used by the APMT to get the db info for the working database
  
  Parameters:  <none>
  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER cDbInfo AS CHAR.

IF VALID-HANDLE (hCaller) THEN
   RUN getWorkingAuditDbInfo IN hCaller (OUTPUT cDbInfo).
ELSE
   ASSIGN cDbInfo = ?.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-import-audit-events) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE import-audit-events Procedure 
PROCEDURE import-audit-events :
/*------------------------------------------------------------------------------
  Purpose:    Import audit events from a .ad file into a dataset.
  
  Parameters:  INPUT pcFileName - file to import
               INPUT perror% - percentage of errors - similar to Data Admin load process.
                               0 means any error aborts import, and continue process
                               regardless of any error.
               OUTPUT pnumRecords - number of records imported
               
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT        PARAMETER pcFileName         AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER perror%            AS INTEGER   NO-UNDO.
DEFINE OUTPUT       PARAMETER pnumRecords        AS INT64     NO-UNDO.


    /* let's try to import it. If we hit the error threshold, we will get an error back.
       The procedure rejects the changes on the dataset in that case.
       It also turns on tracking-changes before starting to load the changes in.
    */
    RUN auditing/_imp-audevent.p (INPUT pcFileName,
                                  INPUT perror%,
                                  INPUT-OUTPUT DATASET-HANDLE hAuditEventDset BY-REFERENCE,
                                  OUTPUT pnumRecords) NO-ERROR.
       
    /* return any error that may have happened */
    IF ERROR-STATUS:ERROR THEN
       RETURN ERROR-STATUS:GET-MESSAGE(1).
    ELSE
       RETURN RETURN-VALUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-import-policies-from-xml) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE import-policies-from-xml Procedure 
PROCEDURE import-policies-from-xml :
/*------------------------------------------------------------------------------
  Purpose:    Import policies from a XML file into the local dataset object
              created in build-local-audit-dataset. . If the XML file contains 
              duplicate policy names, this procedure returns a comma-separated list
              of duplicate policy names, in which case the caller can decide if it
              wants to override them and call resubmit-import-from-xml.
  
  Parameters: INPUT  pcxmlFileName - name of the xml file
              OUTPUT pcList        - list of existing policies
              OUTPUT pcErrorMsg    - error messages
              
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcxmlFileName AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pcList        AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pcErrorMsg    AS CHARACTER NO-UNDO.

DEFINE VARIABLE hQuery  AS HANDLE  NO-UNDO.
DEFINE VARIABLE hBuffer AS HANDLE  NO-UNDO.
DEFINE VARIABLE iValue  AS INTEGER NO-UNDO.

    /* make sure tracking changes is set */
    RUN set-tracking-changes (YES).
    
    /* let's populate our local dataset */
    RUN policies-dataset-read-xml (INPUT pcxmlFileName, 
                                   INPUT-OUTPUT DATASET-HANDLE hAuditDset BY-REFERENCE,
                                   OUTPUT pcList,
                                   OUTPUT pcErrorMsg).

    IF pcErrorMsg = "" AND pcList = "" THEN DO:
    
        /* if we loaded file with no errors, go through the records in the event-policy table and 
          fill the event name and event type. Turn off tracking changes for this operation.
        */
        RUN set-tracking-changes (NO).
    
        /* get the audit event records into the cache, if not already cached */
        RUN get-audit-events (INPUT ?).
    
        CREATE QUERY hQuery.
        hBuffer = hAuditDset:GET-BUFFER-HANDLE(4).
        hQuery:SET-BUFFERS(hBuffer).
        hQuery:QUERY-PREPARE('FOR EACH ':U + hBuffer:NAME + ' WHERE _Event-name = ""':U).
        hQuery:QUERY-OPEN.
        hQuery:GET-FIRST().
        
        DO WHILE NOT hQuery:QUERY-OFF-END:
            
            ASSIGN iValue = hBuffer::_Event-id.

            /* find the event in our cached table */
            FIND FIRST ttAuditEvent WHERE _Event-id = iValue NO-ERROR.
            IF AVAILABLE ttAuditEvent THEN DO:
                ASSIGN hBuffer::_Event-name = ttAuditEvent._Event-name
                       hBuffer::_Event-type = ttAuditEvent._Event-type
                       hBuffer::_Event-description = ttAuditEvent._Event-description.
            END.
    
            hQuery:GET-NEXT().
        END.
    
        hQuery:QUERY-CLOSE.
        DELETE OBJECT hQuery.
    
        RUN set-tracking-changes (YES).

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-populate-local-audit-dataset) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populate-local-audit-dataset Procedure 
PROCEDURE populate-local-audit-dataset :
/*------------------------------------------------------------------------------
  Purpose:     Called to populate the local dataset built in build-local-audit-dataset
               with policy information from database specified in pcDbInfo. We
               basically get rid of the existing records and replace them with
               the dataset we get back from fill-audit-dataset. We also turn on
               tracking changes at the end.
               
  Parameters:  INPUT pcDbInfo - the database name (which can include "APPSERVER" so we know
                                we have to direct the call to the AppServer
                                
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcDbInfo AS CHARACTER NO-UNDO.

DEFINE VARIABLE cErrorMsg AS CHARACTER NO-UNDO.

   IF NOT VALID-HANDLE (hAuditDset) THEN
       RETURN "Invalid state. Dataset does not exist".

   /* turn off tracking-changes before filling the dataset */
   RUN  set-tracking-changes (NO).

   /* if the caller passed an empty string as the dbinfo, then there is no
      db info and we have to empty the dataset.
   */
   IF pcDbInfo = "" OR pcDbInfo = ? THEN DO:
      hAuditDset:EMPTY-DATASET().
      RETURN.
   END.

   /* call the generic procedure passing our local dataset */
   RUN fill-audit-dataset (INPUT pcDbInfo,
                           OUTPUT DATASET-HANDLE hAuditDset BY-REFERENCE).  

   IF RETURN-VALUE <> "":U THEN 
       ASSIGN cErrorMsg = RETURN-VALUE.

   /* if no error happened, turn tracking-changes on */
   IF cErrorMsg = "":U THEN
      RUN set-tracking-changes (YES).
   
   RETURN cErrorMsg.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-registerAuditTableHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE registerAuditTableHandle Procedure 
PROCEDURE registerAuditTableHandle :
/*------------------------------------------------------------------------------
  Purpose:     Caller specifies the handle of temp-tables that this procedure will
               use when building a local dataset object in build-local-audit-dataset.
               
  Parameters:  INPUT pcID    - if for the table which can be "policy", "file-policy",
                              "field-policy" or "event-policy"
               INPUT hTable - handle of the temp-table
  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcID    AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER hTable AS HANDLE    NO-UNDO.

    CASE pcID:
        WHEN 'policy':U THEN DO:
         ASSIGN tableHandleList[1] = hTable.
        END.
        WHEN 'file-policy':U THEN DO:
            ASSIGN tableHandleList[2] = hTable.
        END.
        WHEN 'field-policy':U THEN DO:
            ASSIGN tableHandleList[3] = hTable.
        END.
        WHEN 'event-policy':U THEN DO:
            ASSIGN tableHandleList[4] = hTable.
        END.
    END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rejectChangesAuditDatabase) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rejectChangesAuditDatabase Procedure 
PROCEDURE rejectChangesAuditDatabase :
/*------------------------------------------------------------------------------
  Purpose:     Reject the changes tracked in the local dataset object built
               in build-local-audit-dataset, undoing any changes to the records in 
               the local database object.
               
  Parameters:  <none>
  
  Notes:       
------------------------------------------------------------------------------*/
   
   IF VALID-HANDLE(hAuditDset) THEN
      hAuditDset:REJECT-CHANGES().

   /* set tracking changes on */
   RUN set-tracking-changes (YES).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-remove-table-list-cache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE remove-table-list-cache Procedure 
PROCEDURE remove-table-list-cache :
/*------------------------------------------------------------------------------
  Purpose:     Remove the tables we have in the ttFile for a given db
  
  Parameters:  INPUT  pcDbInfo - db info including db name
  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcDbInfo   AS CHARACTER NO-UNDO.

DEFINE VARIABLE cDbName    AS CHARACTER NO-UNDO.

   /* get the db name out of the dbinfo string */
   ASSIGN cDbName = DYNAMIC-FUNCTION ('get-DB-Name' IN hAuditUtils, pcDbInfo).

   /* now delete all table names from this database */
   FOR EACH ttFile WHERE _db-name = cDbName.
       DELETE ttFile.
   END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resubmit-import-from-xml) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resubmit-import-from-xml Procedure 
PROCEDURE resubmit-import-from-xml :
/*------------------------------------------------------------------------------
  Purpose:     Called after a call to import-policies-from-xml returned with
               a list of existing policies while trying to import  policies
               from a XML file. If the caller calls this, we are meant to
               override any existing policy.
               
  Parameters:  OUTPUT pcErrorMsg - error messages
  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT       PARAMETER pcErrorMsg    AS CHARACTER NO-UNDO.

DEFINE VARIABLE hQuery  AS HANDLE  NO-UNDO.
DEFINE VARIABLE hBuffer AS HANDLE  NO-UNDO.
DEFINE VARIABLE iValue  AS INTEGER NO-UNDO.

    /* call the generic procedure passing our local dataset */
    RUN override-policies-from-xml(INPUT-OUTPUT DATASET-HANDLE hAuditDset BY-REFERENCE,
                                   OUTPUT pcErrorMsg).

    IF pcErrorMsg = "" THEN DO:
    
        /* if we loaded file with no errors, go through the records in the event-policy table and 
          fill the event name and event type. Turn off tracking changes for this operation.
        */
        RUN set-tracking-changes (NO).
    
        /* get the audit event records into the cache, if not already cached */
        RUN get-audit-events (INPUT ?).
    
        CREATE QUERY hQuery.
        hBuffer = hAuditDset:GET-BUFFER-HANDLE(4).
        hQuery:SET-BUFFERS(hBuffer).
        hQuery:QUERY-PREPARE('FOR EACH ':U + hBuffer:NAME + ' WHERE _Event-name = ""':U).
        hQuery:QUERY-OPEN.
        hQuery:GET-FIRST().
        
        DO WHILE NOT hQuery:QUERY-OFF-END:
            
            ASSIGN iValue = hBuffer::_Event-id.

            /* find the event in our cached table */
            FIND FIRST ttAuditEvent WHERE _Event-id = iValue NO-ERROR.
            IF AVAILABLE ttAuditEvent THEN DO:
                ASSIGN hBuffer::_Event-name = ttAuditEvent._Event-name
                       hBuffer::_Event-type = ttAuditEvent._Event-type
                       hBuffer::_Event-description = ttAuditEvent._Event-description.
            END.
    
            hQuery:GET-NEXT().
        END.
    
        hQuery:QUERY-CLOSE.
        DELETE OBJECT hQuery.
    
        RUN set-tracking-changes (YES).

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-save-audit-event) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE save-audit-event Procedure 
PROCEDURE save-audit-event :
/*------------------------------------------------------------------------------
  Purpose:     Save the data passed in plcData into the ttAuditEvent temp-table and
               also propagate the change to the database.
               
  Parameters:  INPUT plcData - field values to be saved separated by CHR(1).
                               Values are in this order: mode event-id event-type 
                                                         event-name description
  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER plcData  AS LONGCHAR NO-UNDO.

DEFINE VARIABLE cMode      AS CHARACTER NO-UNDO.
DEFINE VARIABLE event-id   AS INTEGER   NO-UNDO.
DEFINE VARIABLE hDSChanges AS HANDLE    NO-UNDO.
DEFINE VARIABLE cStatus    AS CHAR      NO-UNDO.
DEFINE VARIABLE hQuery     AS HANDLE    NO-UNDO.
DEFINE VARIABLE hBuffer    AS HANDLE    NO-UNDO.

    ASSIGN event-id = INTEGER(STRING(ENTRY(2, plcData,CHR(1)))).

    /* make sure event-id is >= 32000 */
    IF event-id < 32000 THEN
       RETURN "Event id  must be greater than 31999".
    
    /* check the mode */
    ASSIGN cMode = ENTRY(1, plcData,CHR(1)).
    
    /* make sure tracking-changes is turned on */
    ASSIGN TEMP-TABLE ttAuditEvent:TRACKING-CHANGES = YES.

    /* check if we are adding a new record, or updating an existing one */
    IF cMode = "Add":U OR cMode = "Copy":U THEN DO:
        /* check if event id is unique */
        FIND ttAuditEvent WHERE ttAuditEvent._Event-id = event-id NO-ERROR.
        IF AVAILABLE ttAuditEvent THEN DO:
            RETURN "Event id " + STRING(event-id) + " already exists".
        END.
        
        CREATE ttAuditEvent.
        ASSIGN ttAuditEvent._Event-id = event-id
               ttAuditEvent._Event-type = ENTRY(3, plcData,CHR(1))
               ttAuditEvent._Event-name = ENTRY(4, plcData,CHR(1))
               ttAuditEvent._Event-description = ENTRY(5, plcData,CHR(1)).
    END.
    ELSE IF cMode = "Update" THEN DO:
    
        FIND ttAuditEvent WHERE ttAuditEvent._Event-id = event-id NO-ERROR.
        /* should not happen, but if it does, return an error */
        IF NOT AVAILABLE ttAuditEvent THEN DO:
            RETURN "Could not find event id " + ENTRY(2, plcData,CHR(1)).
        END.

        ASSIGN ttAuditEvent._Event-type = ENTRY(3, plcData,CHR(1))
               ttAuditEvent._Event-name = ENTRY(4, plcData,CHR(1))
               ttAuditEvent._Event-description = ENTRY(5, plcData,CHR(1)).
    END.
    ELSE
        RETURN "ERROR: Invalid mode".

    /* now let's save it to the database */

    ASSIGN TEMP-TABLE ttAuditEvent:TRACKING-CHANGES = NO.

    /* create a dataset with the changes */
    CREATE DATASET hDSChanges.
    hDSChanges:CREATE-LIKE(hAuditEventDset).
    hDSChanges:GET-CHANGES(hAuditEventDset).

    /* pass the update request alomg to the auditUtils procedure */
    RUN updateAuditEvent IN hAuditUtils(INPUT hAuditEventDset:PRIVATE-DATA,
                                        INPUT-OUTPUT DATASET-HANDLE hDSChanges BY-REFERENCE).

    /* trap errors */
    ASSIGN cStatus = RETURN-VALUE.

    /* Check the ERROR status that might have been returned. */
    IF cStatus <> "":U OR hDSChanges:ERROR THEN
    DO:
        /* There was an error somewhere in the update. Find it. */
        CREATE QUERY hQuery.
        hBuffer = hDSChanges:GET-BUFFER-HANDLE(1).
        hQuery:ADD-BUFFER(hBuffer).
        hQuery:QUERY-PREPARE("FOR EACH ":U + hBuffer:NAME).
        hQuery:QUERY-OPEN().
        hQuery:GET-FIRST().
        DO WHILE NOT hQuery:QUERY-OFF-END:
            IF hBuffer:ERROR THEN
                cStatus = cStatus + hBuffer:ERROR-STRING + CHR(10).

            hQuery:GET-NEXT().
        END.

        hQuery:QUERY-CLOSE().
        DELETE OBJECT hQuery.

        /* reject all the changes */
        hAuditEventDset:REJECT-CHANGES().

        ASSIGN cstatus =  "ERROR: " + cstatus.
    END.
    ELSE DO:
        /* everything is fine - accept the changes */
       hAuditEventDset:ACCEPT-CHANGES().

       /* publish this event so others know we made changes to the audit
         event table
       */
       PUBLISH 'refresh-Audit-Events':U.
    END.

    DELETE OBJECT hDSChanges.

    /* turn tracking changes back on */
    ASSIGN TEMP-TABLE ttAuditEvent:TRACKING-CHANGES = YES.

    RETURN cStatus.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-saveAuditEventChanges) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveAuditEventChanges Procedure 
PROCEDURE saveAuditEventChanges :
/*------------------------------------------------------------------------------
  Purpose:     Save the changes tracked in the ttAuditEvent temp-table to the
               same database where we read the records from.
               
  Parameters:  
  
  Notes:       Caller should check RETURN-VALUE for error messages.
------------------------------------------------------------------------------*/

DEFINE VARIABLE hDSChanges       AS HANDLE  NO-UNDO.
DEFINE VARIABLE cStatus          AS CHAR    NO-UNDO.
DEFINE VARIABLE hQuery           AS HANDLE  NO-UNDO.
DEFINE VARIABLE hBuffer          AS HANDLE  NO-UNDO.
DEFINE VARIABLE hTT              AS HANDLE  NO-UNDO.

    IF NOT VALID-HANDLE (hAuditEventDset) THEN
       RETURN "ERROR: Cannot save changes (dataset invalid).".
    
    /* turn off tracking for now */
    ASSIGN hTT = hAuditEventDset:GET-BUFFER-HANDLE(1):TABLE-HANDLE
           hTT:TRACKING-CHANGES = NO.

    /* create a dataset with the changes */
    CREATE DATASET hDSChanges.
    hDSChanges:CREATE-LIKE(hAuditEventDset).
    hDSChanges:GET-CHANGES(hAuditEventDset).
        
    /* pass the update request alomg to the auditUtils procedure */
    RUN updateAuditEvent IN hAuditUtils(INPUT hAuditEventDset:PRIVATE-DATA,
                                        INPUT-OUTPUT DATASET-HANDLE hDSChanges BY-REFERENCE).
    
    /* trap errors */
    ASSIGN cStatus = RETURN-VALUE.
    
    /* Check the ERROR status that might have been returned. */
    IF cStatus <> "":U OR hDSChanges:ERROR THEN
    DO:
        /* There was an error somewhere in the update. Find it. */
            CREATE QUERY hQuery.
            hBuffer = hDSChanges:GET-BUFFER-HANDLE(1).
            hQuery:ADD-BUFFER(hBuffer).
            hQuery:QUERY-PREPARE("FOR EACH ":U + hBuffer:NAME).
            hQuery:QUERY-OPEN().
            hQuery:GET-FIRST().
            DO WHILE NOT hQuery:QUERY-OFF-END:
                IF hBuffer:ERROR THEN
                    cStatus = cStatus + hBuffer:ERROR-STRING + CHR(10).
                    
                hQuery:GET-NEXT().
            END.

            hQuery:QUERY-CLOSE().
            DELETE OBJECT hQuery.

            /* reject all the chnages */
            hAuditEventDset:REJECT-CHANGES().
    END.
    ELSE DO:
       cstatus = "":U.

        /* everything is good - accept the changes */
       hAuditEventDset:ACCEPT-CHANGES().

       /* publish this event so others know we made changes to the audit
         event table */
       PUBLISH 'refresh-Audit-Events':U.

    END.

    DELETE OBJECT hDSChanges.

    /* set tracking-changes back on */
    hTT:TRACKING-CHANGES = YES.

    IF cStatus <> "":U THEN
       RETURN "ERROR: " + cstatus.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-saveChangesAuditDatabase) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveChangesAuditDatabase Procedure 
PROCEDURE saveChangesAuditDatabase :
/*------------------------------------------------------------------------------
  Purpose:     Save changes tracked in the local dataset object into the same
               database we read them from.
               
  Parameters:  
                   
  Notes:       Caller should check RETURN-VALUE for error messages
------------------------------------------------------------------------------*/
DEFINE VARIABLE hDSChanges AS HANDLE NO-UNDO.
DEFINE VARIABLE hQuery     AS HANDLE NO-UNDO.
DEFINE VARIABLE hBuffer    AS HANDLE NO-UNDO.
DEFINE VARIABLE i          AS INT    NO-UNDO.
DEFINE VARIABLE cStatus    AS CHAR   NO-UNDO INIT "".
DEFINE VARIABLE errorMsg   AS CHAR   NO-UNDO.

    /* turn tracking-changes off */
    RUN set-tracking-changes (INPUT NO).
    
    /* create a dataset with the changes before sending it to the other procedure */
    CREATE DATASET hDSChanges.
    hDSChanges:CREATE-LIKE(hAuditDset).
    hDSChanges:GET-CHANGES(hAuditDset). /* get the changes */
    ASSIGN errorMsg = "".
    
    /* call the generic procedure passing our local dataset */
    RUN update-auditing-policies (INPUT cDbInfo, 
                                  INPUT-OUTPUT DATASET-HANDLE hDSChanges BY-REFERENCE).
    
    ASSIGN errorMsg = RETURN-VALUE.

    /* turn tracking changes back on */    
    RUN set-tracking-changes (INPUT YES).

    /* Check the ERROR status that might have been returned. */
    IF errorMsg = "":U AND hDSChanges:ERROR THEN
    DO:
        /* There was an error somewhere in the updates. Find it. */
        DO i = 1 TO hDSChanges:NUM-BUFFERS.
            CREATE QUERY hQuery.
            hBuffer = hDSChanges:GET-BUFFER-HANDLE(i):BEFORE-BUFFER.
            hQuery:ADD-BUFFER(hBuffer).
            
            hQuery:QUERY-PREPARE("FOR EACH " + hBuffer:NAME).
            hQuery:QUERY-OPEN().
            hQuery:GET-FIRST().
            
            DO WHILE NOT hQuery:QUERY-OFF-END:
                IF hBuffer:ERROR THEN
                    cStatus = cStatus + hBuffer:ERROR-STRING + CHR(10) NO-ERROR.
                hQuery:GET-NEXT().
            END.
            hQuery:QUERY-CLOSE().
            DELETE OBJECT hQuery.
        END.
        
    END.
    
    /* delete the dataset with changes */
    DELETE OBJECT hDSChanges.
    
    IF errorMsg <> "":U THEN
        RETURN errorMsg.
    
    IF cstatus = "" THEN
        /* if no errors so far, accept all the changes */
        hAuditDset:ACCEPT-CHANGES().
    ELSE
       RETURN cstatus.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-set-tracking-changes) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-tracking-changes Procedure 
PROCEDURE set-tracking-changes :
/*------------------------------------------------------------------------------
  Purpose:    Set tracking-changes of all temp-tables in the local dataset object 
  
  Parameters:  <none>
  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER newValue AS LOGICAL NO-UNDO.

DEFINE VAR Y AS INTEGER NO-UNDO.

  IF NOT VALID-HANDLE (hAuditDset) THEN
     RETURN.

  /* go through every buffer in the dataset */
  DO Y = 1 TO hAuditDset:NUM-BUFFERS:
      hAuditDset:GET-BUFFER-HANDLE(Y):TABLE-HANDLE:TRACKING-CHANGES = newValue.
  END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-set-tt-hdls-for-dataset) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-tt-hdls-for-dataset Procedure 
PROCEDURE set-tt-hdls-for-dataset :
/*------------------------------------------------------------------------------
  Purpose:     Caller specifies the handles of temp-tables that this procedure will
               use when building a local dataset object in build-local-audit-dataset.
               
  Parameters:  INPUT pcList  - comma-separated list of handles. The order must be for
                               policy, file-policy, field-policy and event-policy
                               tables.
  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcList    AS CHARACTER NO-UNDO.

    IF NUM-ENTRIES(pcList) <> 4 THEN
        RETURN "You must specify four table-handles".

     ASSIGN tableHandleList[1] = WIDGET-HANDLE(ENTRY(1, pcList))
            tableHandleList[2] = WIDGET-HANDLE(ENTRY(2, pcList))
            tableHandleList[3] = WIDGET-HANDLE(ENTRY(3, pcList))
            tableHandleList[4] = WIDGET-HANDLE(ENTRY(4, pcList)).

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
  
  Parameters:  INPUT h-proc - caller procedure's handle
  
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER h-proc AS HANDLE.

    ASSIGN hCaller = h-proc.
    RUN SUPER (INPUT h-proc).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-get-owner-tbl-cache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION get-owner-tbl-cache Procedure 
FUNCTION get-owner-tbl-cache RETURNS CHARACTER
  ( pcTableName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Given a table name, try to find it in our cache and 
            return the owner name, or an empty string if not found.
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cTableName AS CHARACTER NO-UNDO.

  /* check if we already retrieved the list of tables for this db */
  FIND FIRST ttFile where _db-name = cDbInfo NO-ERROR.

  IF NOT AVAILABLE ttFile THEN
     /* populate temp-table */
     RUN fill-tables-tt IN hAuditUtils (INPUT cDbInfo,
                                        OUTPUT TABLE ttFile APPEND ).

  FIND FIRST ttFile WHERE ttFile._db-name = cDbInfo AND 
                          ttFile._file-name = pcTableName NO-ERROR.
  IF AVAILABLE ttFile THEN
     RETURN ttFile._Owner.
  
  RETURN "". 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNextAppLevelEventID) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNextAppLevelEventID Procedure 
FUNCTION getNextAppLevelEventID RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  find out the last application level event id in the ttAuditEvent 
            temp-table and return the next value.
            
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE bh       AS HANDLE  NO-UNDO.
  DEFINE VARIABLE i        AS LOGICAL NO-UNDO.
  DEFINE VARIABLE ret      AS CHAR    NO-UNDO.
  DEFINE VARIABLE hEventTT AS HANDLE  NO-UNDO.

  /* get the handle of the datasource from the sdo, so we can get the temp-table's
     handle
  */
  ASSIGN hEventTT = hAuditEventDset:GET-BUFFER-HANDLE(1):TABLE-HANDLE.

  CREATE BUFFER bh FOR TABLE hEventTT.

  ASSIGN i = bh:FIND-LAST() NO-ERROR.

  /* if not found any application event, start with 32000 */
  IF NOT i OR bh::_Event-id < 32000 THEN
      ret = "32000".
  ELSE DO:
      ret = STRING(bh::_Event-id  + 1).
  END.

  DELETE OBJECT bh.

  RETURN ret. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-hasApplEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION hasApplEvents Procedure 
FUNCTION hasApplEvents RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Return YES if there are application-level events defined in the
            ttAuditEvent temp-table.
            
    Notes:  
------------------------------------------------------------------------------*/

    IF VALID-HANDLE(hAuditEventDset) THEN DO:

        hAuditEventDset:GET-BUFFER-HANDLE(1):FIND-FIRST("where _Event-id >= 32000":U) NO-ERROR.
        RETURN hAuditEventDset:GET-BUFFER-HANDLE(1):AVAILABLE.
    END.

  RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-is-valid-event-id) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION is-valid-event-id Procedure 
FUNCTION is-valid-event-id RETURNS LOGICAL
  ( INPUT pEvent-id AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  Verify if event id passed in is valid. We check our cached information
    Notes:  
------------------------------------------------------------------------------*/
    
   /* get the audit event records into the cache, if not already cached */
   RUN get-audit-events (INPUT ?).

   FIND FIRST ttAuditEvent WHERE _Event-id = pEvent-id NO-ERROR.
   IF AVAILABLE ttAuditEvent THEN
      RETURN TRUE.

  RETURN FALSE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-is-valid-field-name) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION is-valid-field-name Procedure 
FUNCTION is-valid-field-name RETURNS LOGICAL
  ( pcTableInfo AS CHARACTER, pcFieldName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Given a table-name/owner combination, try to find out if field
            name is valid in our cache.
    Notes:  
------------------------------------------------------------------------------*/
  /* check if we already retrieved the list of tables for this db */
  FIND FIRST ttField where ttField._File-name = ENTRY(1,pcTableInfo) AND 
      ttField._Owner = ENTRY(2,pcTableInfo) NO-ERROR.

  IF NOT AVAILABLE ttField THEN
     /* populate temp-table */
     RUN fill-fields-tt IN hAuditUtils ( INPUT pcTableInfo,
                                         OUTPUT TABLE ttField APPEND).

  FIND FIRST ttField WHERE ttField._File-name = ENTRY(1,pcTableInfo) AND 
      ttField._Owner = ENTRY(2,pcTableInfo) AND ttField._Field-name = pcFieldName NO-ERROR.

  IF AVAILABLE ttField THEN
     RETURN TRUE.
  
  RETURN FALSE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

