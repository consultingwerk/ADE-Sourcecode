&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*************************************************************/  
/* Copyright (c) 1984-2006 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : _update-audevents.p
    Purpose     : Handles the update of audit event records. Used by the
                  APMT. The callers passes the logical db name where we
                  should save the changes to and a dataset with the changes that
                  we should save into the database. 
     

    Syntax      :

    Description :

    Author(s)   : Fernando de Souza
    Created     : Feb 23,2005
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

{auditing/ttdefs/_audeventtt.i}

DEFINE DATASET dsAuditEvent FOR ttAuditEvent.

/* ***************************  Definitions  ************************** */
DEFINE INPUT        PARAMETER pcDbName   AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER DATASET FOR dsAuditEvent.
DEFINE OUTPUT       PARAMETER errorMsg   AS CHARACTER NO-UNDO.

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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

IF NOT CONNECTED(pcDbName)  THEN DO:
   ASSIGN DATASET dsAuditEvent:ERROR = YES
          errorMsg = "ERROR: Database " + pcDbName + " is not connected.".
   RETURN.
END.

IF INDEX (DBRESTRICTIONS(pcDbName), "READ-ONLY":U) > 0 THEN DO:
    ASSIGN DATASET dsAuditEvent:ERROR = YES
           errorMsg = "ERROR: Database " + pcDbName + " is read-only.".
    RETURN.
END.

RUN saveChanges.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-saveChanges) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveChanges Procedure 
PROCEDURE saveChanges :
/*------------------------------------------------------------------------------
  Purpose:     Update temp-table with audit events from database passed in
               cDbName
  Parameters:  input database name
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hEventDS     AS HANDLE  NO-UNDO.
DEFINE VARIABLE cEventTable  AS CHAR    NO-UNDO.
DEFINE VARIABLE errorNum     AS INTEGER NO-UNDO.
DEFINE VARIABLE errorMsg     AS CHAR    NO-UNDO.
DEFINE VARIABLE event-id     AS INTEGER NO-UNDO.
DEFINE VARIABLE hbufferEvent AS HANDLE  NO-UNDO.
DEFINE VARIABLE hBufferDF    AS HANDLE  NO-UNDO.
DEFINE VARIABLE largeKeys    AS LOGICAL NO-UNDO.

/* check if large keys is enabled so that we antecipate if the description is too big */
CREATE BUFFER hBufferDF FOR TABLE pcDbName + "._Database-feature" NO-ERROR.
IF VALID-HANDLE(hBufferDF) THEN DO:

    hBufferDF:FIND-FIRST('WHERE _DBFeature_Name = "Large Keys"', NO-LOCK) NO-ERROR.
    IF hBufferDF:AVAILABLE THEN DO:
        IF hBufferDF::_DBFeature_Enabled = "1" THEN
            largeKeys = YES.
    END.
    DELETE OBJECT hBufferDF NO-ERROR.
END.

ASSIGN cEventTable = pcDbName + "._aud-event":U.

CREATE BUFFER hBufferEvent FOR TABLE cEventTable. 

CREATE DATA-SOURCE hEventDS.
hEventDS:ADD-SOURCE-BUFFER(hbufferEvent,"_Event-id").

DATASET dsAuditEvent:GET-BUFFER-HANDLE(1):ATTACH-DATA-SOURCE(hEventDS) NO-ERROR.


DO TRANSACTION ON ERROR UNDO, LEAVE:
        FOR EACH ttAuditEventBefore:

            /* cannot allow delete operation !!! */
            IF BUFFER ttAuditEventBefore:ROW-STATE = ROW-DELETED THEN DO:
                ASSIGN DATASET dsAuditEvent:ERROR = YES
                       BUFFER ttAuditEventBefore:ERROR = YES
                      BUFFER ttAuditEventBefore:ERROR-STRING = "You are not allowed to delete a record from the" 
                    + " audit event table (event id " + STRING(ttAuditEvent._Event-id) + ")".
                LEAVE.
            END.
            
            /* validate the record before writing it to the database */
            /* if this was a new row, need to get the values out of the after table */
            BUFFER ttAuditEvent:FIND-BY-ROWID(BUFFER ttAuditEventBefore:AFTER-ROWID) NO-ERROR.

            IF AVAILABLE (ttAuditEvent) AND (BUFFER ttAuditEventBefore:ROW-STATE = ROW-CREATED OR
               BUFFER ttAuditEventBefore:ROW-STATE = ROW-MODIFIED) THEN DO:

                    IF ttAuditEvent._Event-id < 32000 THEN DO:
                        ASSIGN DATASET dsAuditEvent:ERROR = YES
                               BUFFER ttAuditEventBefore:ERROR = YES
                               BUFFER ttAuditEventBefore:ERROR-STRING = "Event id " + STRING(ttAuditEvent._Event-id)
                                      + " is invalid. It must be >= 32000".
                        LEAVE. /* leave the loop */
                    END.
    
                    IF ttAuditEvent._Event-type = "" OR ttAuditEvent._Event-type = ? THEN DO:
                        ASSIGN DATASET dsAuditEvent:ERROR = YES
                               BUFFER ttAuditEventBefore:ERROR = YES
                               BUFFER ttAuditEventBefore:ERROR-STRING = "Event type is mandatory (event id " 
                                          + STRING(ttAuditEvent._Event-id) + " )".
                        LEAVE. /* leave the loop */
                    END.
    
                    IF ttAuditEvent._Event-name = "" OR ttAuditEvent._Event-name = ? THEN DO:
                        ASSIGN DATASET dsAuditEvent:ERROR = YES
                               BUFFER ttAuditEventBefore:ERROR = YES
                               BUFFER ttAuditEventBefore:ERROR-STRING = "Event name is mandatory (event id " 
                                          + STRING(ttAuditEvent._Event-id) + " )".
                        LEAVE. /* leave the loop */
                    END.

                    IF (NOT largeKeys AND LENGTH(ttAuditEvent._Event-description) > 188) 
                        OR (largekeys AND LENGTH(ttAuditEvent._Event-description) > 1970) THEN DO:
                        ASSIGN DATASET dsAuditEvent:ERROR = YES
                               BUFFER ttAuditEventBefore:ERROR = YES
                               BUFFER ttAuditEventBefore:ERROR-STRING = "Description exceeded the maximum length of " 
                                          + (IF largeKeys THEN "1970" ELSE "188") + " characters (event id " 
                                          + STRING(ttAuditEvent._Event-id) + " )".
                        LEAVE. /* leave the loop */
                    END.
            END.

            /* record was validate */
            BUFFER ttAuditEventBefore:SAVE-ROW-CHANGES() NO-ERROR.

            IF BUFFER ttAuditEventBefore:ERROR THEN DO:

                ASSIGN errorNum = ERROR-STATUS:GET-NUMBER(1)
                       errorMsg = ERROR-STATUS:GET-MESSAGE(1)
                       event-id = (IF AVAILABLE ttAuditEvent THEN ttAuditEvent._Event-id ELSE ttAuditEventBefore._Event-id).

                   /* could not get a lock */
                   IF errorNum = 12300 THEN DO:
                       ASSIGN BUFFER ttAuditEventBefore:ERROR-STRING = 
                              "Record for event id " + STRING(event-id) + " is locked by another user.".
                   END.
                   ELSE IF errorNum = 132 THEN DO: /* duplicate record */
                       /* if adding record, need to get the values from the after table */
                       ASSIGN errorMsg = STRING((IF AVAILABLE ttAuditEvent THEN ttAuditEvent._Event-id ELSE ttAuditEventBefore._Event-id))
                              BUFFER ttAuditEventBefore:ERROR-STRING = "Event id " + STRING(event-id)
                                    + " was added by another user.".
                   END.
                   ELSE DO:
                        /* check if record was modified or deleted. DATA-SOURCE-MODIFIED returns
                           true for both cases
                        */
                        IF BUFFER ttAuditEventBefore:DATA-SOURCE-MODIFIED THEN DO:
                          ASSIGN BUFFER ttAuditEventBefore:ERROR-STRING = 
                            "Settings for event id " + STRING(event-id) + " have been changed or deleted by another user.".
                        END.
                        ELSE
                            ASSIGN BUFFER ttAuditEventBefore:ERROR-STRING = "Event id " + STRING(event-id) 
                                     + " : " + errorMsg.
                   END. /* if errorNum */
            END. /* IF BUFFER ttAuditEventBefore */
        END. /* FOR EACH */

        IF DATASET dsAuditEvent:ERROR THEN
            UNDO, LEAVE.
END.

DATASET dsAuditEvent:GET-BUFFER-HANDLE(1):DETACH-DATA-SOURCE NO-ERROR.

DELETE OBJECT hEventDS NO-ERROR.

DELETE OBJECT hBufferEvent NO-ERROR.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

