&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*************************************************************/  
/* Copyright (c) 1984-2009 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : _update-policies.p
    Purpose     : Save the changes to the policies stored in the dataset
                  passed in into a database (also passed in by the caller)

    Syntax      :

    Description :

    Author(s)   : Fernando de Souza
    Created     : Feb 23,2005
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
{auditing/ttdefs/_audpolicytt.i}
{auditing/ttdefs/_audfilepolicytt.i}
{auditing/ttdefs/_audfieldpolicytt.i}
{auditing/ttdefs/_audeventpolicytt.i}

{auditing/include/_dspolicy.i}

DEFINE INPUT PARAMETER pcDbName AS CHAR    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER DATASET FOR dsAudPolicy.
DEFINE OUTPUT PARAMETER pcErrorMsg AS CHAR  NO-UNDO.


DEFINE VARIABLE hPolicyDS          AS HANDLE NO-UNDO.
DEFINE VARIABLE hFilePolicyDS      AS HANDLE NO-UNDO.
DEFINE VARIABLE hFieldPolicyDS     AS HANDLE NO-UNDO.
DEFINE VARIABLE hEventPolicyDS     AS HANDLE NO-UNDO.
DEFINE VARIABLE cPolicyTable       AS CHAR   NO-UNDO.
DEFINE VARIABLE cFilePolicyTable   AS CHAR   NO-UNDO.
DEFINE VARIABLE cFieldPolicyTable  AS CHAR   NO-UNDO.
DEFINE VARIABLE cEventPolicyTable  AS CHAR   NO-UNDO.
DEFINE VARIABLE cAudEventTable     AS CHAR   NO-UNDO.

DEFINE VARIABLE hbufferPolicy      AS HANDLE NO-UNDO.
DEFINE VARIABLE hbufferFilePolicy  AS HANDLE NO-UNDO.
DEFINE VARIABLE hbufferFieldPolicy AS HANDLE NO-UNDO.
DEFINE VARIABLE hbufferEventPolicy AS HANDLE NO-UNDO.
DEFINE VARIABLE hbufferAudEvent    AS HANDLE NO-UNDO.

DEFINE VARIABLE cPolicyName   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cMsg          AS CHARACTER NO-UNDO.
DEFINE VARIABLE errorNum      AS INTEGER   NO-UNDO.
DEFINE VARIABLE errorMsg      AS CHARACTER NO-UNDO.

DEFINE VARIABLE hQuery        AS HANDLE     NO-UNDO.
DEFINE VARIABLE hPolicyBuffer AS HANDLE     NO-UNDO.
DEFINE VARIABLE cTableName    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE phDbName      AS CHARACTER  NO-UNDO.

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
   ASSIGN pcErrorMsg = "ERROR: Database " + pcDbName + " is not connected.".
   RETURN.
END.

IF INDEX (DBRESTRICTIONS(pcDbName), "READ-ONLY":U) > 0 THEN DO:
    ASSIGN pcErrorMsg = "ERROR: Database " + pcDbName + " is read-only.".
    RETURN.
END.

/* need the physical db name */
ASSIGN phDbName = PDBNAME(pcDbName).

RUN attach-ds.

RUN save-data.

RUN detach-ds.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-attach-ds) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE attach-ds Procedure 
PROCEDURE attach-ds :
/*------------------------------------------------------------------------------
  Purpose:     Attach dataset to datasource
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
ASSIGN cPolicyTable = pcDbName + "._aud-audit-policy":U
       cFilePolicyTable = pcDbName + "._aud-file-policy":U
       cFieldPolicyTable = pcDbName + "._aud-field-policy":U
       cEventPolicyTable = pcDbName + "._aud-event-policy":U.

CREATE BUFFER hBufferPolicy      FOR TABLE cPolicyTable. 
CREATE BUFFER hBufferFilePolicy  FOR TABLE cFilePolicyTable. 
CREATE BUFFER hBufferFieldPolicy FOR TABLE cFieldPolicyTable. 
CREATE BUFFER hBufferEventPolicy FOR TABLE cEventPolicyTable. 

CREATE DATA-SOURCE hPolicyDS.
hPolicyDS:ADD-SOURCE-BUFFER(hbufferPolicy,"_Audit-policy-guid").
CREATE DATA-SOURCE hFilePolicyDS.
hFilePolicyDS:ADD-SOURCE-BUFFER(hbufferFilePolicy,"_Audit-policy-guid,_file-Name,_Owner").
CREATE DATA-SOURCE hFieldPolicyDS.
hFieldPolicyDS:ADD-SOURCE-BUFFER(hbufferFieldPolicy,"_Audit-policy-guid,_File-Name,_Owner,_Field-Name").
CREATE DATA-SOURCE hEventPolicyDS.
hEventPolicyDS:ADD-SOURCE-BUFFER(hbufferEventPolicy,"_Audit-policy-guid,_Event-id").
 
DATASET    dsAudPolicy:GET-BUFFER-HANDLE(1):ATTACH-DATA-SOURCE(hPolicyDS).
DATASET    dsAudPolicy:GET-BUFFER-HANDLE(2):ATTACH-DATA-SOURCE(hFilePolicyDS).
DATASET    dsAudPolicy:GET-BUFFER-HANDLE(3):ATTACH-DATA-SOURCE(hFieldPolicyDS).

DATASET    dsAudPolicy:GET-BUFFER-HANDLE(4):ATTACH-DATA-SOURCE(hEventPolicyDS).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-detach-ds) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE detach-ds Procedure 
PROCEDURE detach-ds :
/*------------------------------------------------------------------------------
  Purpose:    Detach datasrouces fromd dataset
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


DATASET dsAudPolicy:GET-BUFFER-HANDLE(1):DETACH-DATA-SOURCE.
DATASET dsAudPolicy:GET-BUFFER-HANDLE(2):DETACH-DATA-SOURCE.
DATASET dsAudPolicy:GET-BUFFER-HANDLE(3):DETACH-DATA-SOURCE.
DATASET dsAudPolicy:GET-BUFFER-HANDLE(4):DETACH-DATA-SOURCE.

DELETE OBJECT hPolicyDS.
DELETE OBJECT hFilePolicyDS.
DELETE OBJECT hFieldPolicyDS.
DELETE OBJECT hEventPolicyDS.
 
DELETE OBJECT hBufferPolicy.
DELETE OBJECT hBufferFilePolicy.
DELETE OBJECT hBufferFieldPolicy.
DELETE OBJECT hBufferEventPolicy.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-process-audit-event-policy) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE process-audit-event-policy Procedure 
PROCEDURE process-audit-event-policy :
/*------------------------------------------------------------------------------
  Purpose:    Process the changes on the aud-event-policy table and save them 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

        /* if no error has happened so far, keep going with the updates */
        IF NOT DATASET dsAudPolicy:ERROR THEN DO:
            /* let's process the audit-event changes */
             FOR EACH ttAuditEventPolicyBefore.

                /* tries to find the record in the after table */
                BUFFER ttAuditEventPolicy:FIND-BY-ROWID(BUFFER ttAuditEventPolicyBefore:AFTER-ROWID) NO-ERROR.
    
                IF AVAILABLE (ttAuditEventPolicy) AND (BUFFER ttAuditEventPolicyBefore:ROW-STATE = ROW-CREATED OR
                   BUFFER ttAuditEventPolicyBefore:ROW-STATE = ROW-MODIFIED) THEN DO:

                   /* validate record before saving it */

                   /* check if policy guid is valid */
                   IF ttAuditEventPolicy._Audit-policy-guid = "" OR ttAuditEventPolicy._Audit-policy-guid= ? THEN DO:
                       ASSIGN DATASET dsAudPolicy:ERROR = YES
                              BUFFER ttAuditEventPolicyBefore:ERROR = YES
                              BUFFER ttAuditEventPolicyBefore:ERROR-STRING = "Policy GUID is a mandatory field (event id "
                                     + STRING(ttAuditEventPolicy._Event-id) + ")".
                       UNDO, LEAVE.
                   END.

                   /* check if a policy with the GUID exists */
                   hPolicyBuffer:FIND-FIRST ("where _Audit-policy-guid = " + QUOTER(ttAuditEventPolicy._Audit-policy-guid)) NO-ERROR.

                   IF NOT hPolicyBuffer:AVAILABLE THEN DO:
                       ASSIGN DATASET dsAudPolicy:ERROR = YES
                              BUFFER ttAuditEventPolicyBefore:ERROR = YES
                              BUFFER ttAuditEventPolicyBefore:ERROR-STRING = "Policy GUID " + QUOTER(ttAuditEventPolicy._Audit-policy-guid)
                                     + "is invalid (event id" + STRING(ttAuditEventPolicy._Event-id) + ")".

                       UNDO, LEAVE.
                   END.

                   /* make sure event ids are valid */

                   IF NOT VALID-HANDLE(hbufferAudEvent) THEN DO:
                       /* create a buffer for the _aud-event table so we can validate if the event ids are valid */
                       CREATE BUFFER hbufferAudEvent FOR TABLE cAudEventTable NO-ERROR.
                       IF ERROR-STATUS:ERROR THEN DO:
                          ASSIGN DATASET dsAudPolicy:ERROR = YES
                                 BUFFER ttAuditEventPolicyBefore:ERROR = YES
                                 BUFFER ttAuditEventPolicyBefore:ERROR-STRING = "Coud not access " + cAudEventTable 
                                        + CHR(10) + ERROR-STATUS:GET-MESSAGE(1).

                           UNDO, LEAVE.
                       END.
                   END.

                   /* check if the create event id is valid */
                   hbufferAudEvent:FIND-FIRST ("WHERE _Event-id = " + STRING(ttAuditEventPolicy._Event-id)) NO-ERROR.

                   IF NOT hbufferAudEvent:AVAILABLE THEN DO:
                       ASSIGN DATASET dsAudPolicy:ERROR = YES
                              BUFFER ttAuditEventPolicyBefore:ERROR = YES
                              BUFFER ttAuditEventPolicyBefore:ERROR-STRING = "Event id " + STRING(ttAuditEventPolicy._Event-id) 
                                     + " is invalid (policy " + QUOTER(hPolicyBuffer::_Audit-policy-name) + ")".

                        UNDO, LEAVE.
                   END.

                   /* make sure level is valid */
                   IF ttAuditEventPolicy._Event-level < 0 OR ttAuditEventPolicy._Event-level > 2 THEN DO:
                   
                      ASSIGN DATASET dsAudPolicy:ERROR = YES
                             BUFFER ttAuditEventPolicyBefore:ERROR = YES
                             BUFFER ttAuditEventPolicyBefore:ERROR-STRING = "Event level is invalid (event id " 
                                    + STRING(ttAuditEventPolicy._Event-id) + " policy "
                                      + QUOTER(hPolicyBuffer::_Audit-policy-name) + ")".

                      UNDO, LEAVE.
                   END.

                 END.

                 /* try to save changes */
                 BUFFER ttAuditEventPolicyBefore:SAVE-ROW-CHANGES() NO-ERROR.

                 /* trap errors */
                 IF BUFFER ttAuditEventPolicyBefore:ERROR THEN DO:
                    /* hold on to the error number and error message so we don't loose them after
                      calling the find-first methods below.
                    */
                     ASSIGN errorNum = ERROR-STATUS:GET-NUMBER(1)
                            errorMsg = ERROR-STATUS:GET-MESSAGE(1).

                     /* if this was a new row, need to get the values out of the after table */
                     IF BUFFER ttAuditEventPolicyBefore:ROW-STATE = ROW-DELETED THEN
                         hPolicyBuffer:FIND-FIRST ("where _Audit-policy-guid = " + QUOTER(ttAuditEventPolicyBefore._Audit-policy-guid)) NO-ERROR.
                     ELSE
                        hPolicyBuffer:FIND-FIRST ("where _Audit-policy-guid = " + QUOTER(ttAuditEventPolicy._Audit-policy-guid)) NO-ERROR.

                     /* build a common error message with all the info we have */
                     ASSIGN cMsg = "event id " + (IF AVAILABLE ttAuditEventPolicy THEN STRING(ttAuditEventPolicy._Event-id) ELSE STRING(ttAuditEventPolicyBefore._Event-id))
                                    + " policy " + QUOTER(hPolicyBuffer::_Audit-policy-name) .

                    /* could not get a lock */
                     IF errorNum = 12300 THEN DO:
                         ASSIGN BUFFER ttAuditEventPolicyBefore:ERROR-STRING = 
                                "Record for " + cMsg + " is locked by another user.".
                     END.
                     ELSE IF errorNum = 132 THEN DO: /* duplicate record */
                         ASSIGN BUFFER ttAuditEventPolicyBefore:ERROR-STRING = cMsg 
                             + " was added by another user.".
                     END.
                     ELSE DO:
                         /* check if record was modified or deleted. DATA-SOURCE-MODIFIED returns
                            true for both cases
                         */
                          IF BUFFER ttAuditEventPolicyBefore:DATA-SOURCE-MODIFIED THEN DO:
                             hPolicyBuffer:FIND-FIRST ("where _Audit-policy-guid = " + QUOTER(ttAuditPolicyBefore._Audit-policy-guid)) NO-ERROR.
                        
                             ASSIGN BUFFER ttAuditEventPolicyBefore:ERROR-STRING = 
                                          "Settings for " + cMsg + " have been changed or deleted by another user.".
                          END.
                          ELSE
                              ASSIGN BUFFER ttAuditEventPolicyBefore:ERROR-STRING = cMsg + errorMsg.
                    END.
                 END. /* BUFFER ttAuditEventPolicyBefore:ERROR */
             END. /* FOR EACH ttAuditEventPolicyBefore */
        END. /* NOT DATASET dsAudPolicy:ERROR */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-process-audit-field-policy) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE process-audit-field-policy Procedure 
PROCEDURE process-audit-field-policy :
/*------------------------------------------------------------------------------
  Purpose:    Process the changes on the aud-field-policy table and save them 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

        /* if no error has happened so far, keep going with the updates */
        IF NOT DATASET dsAudPolicy:ERROR THEN DO:
            /* let's process the audit-field changes */
            FOR EACH ttAuditFieldPolicyBefore:
                
                /* tries to find the record in the after table */
                BUFFER ttAuditFieldPolicy:FIND-BY-ROWID(BUFFER ttAuditFieldPolicyBefore:AFTER-ROWID) NO-ERROR.
    
                IF AVAILABLE (ttAuditFieldPolicy) AND (BUFFER ttAuditFieldPolicyBefore:ROW-STATE = ROW-CREATED OR
                   BUFFER ttAuditFieldPolicyBefore:ROW-STATE = ROW-MODIFIED) THEN DO:

                   /* validate record before saving it */

                   /* check if policy guid is valid */
                   IF ttAuditFieldPolicy._Audit-policy-guid = "" OR ttAuditFieldPolicy._Audit-policy-guid= ? THEN DO:
                       ASSIGN DATASET dsAudPolicy:ERROR = YES
                              BUFFER ttAuditFieldPolicyBefore:ERROR = YES
                              BUFFER ttAuditFieldPolicyBefore:ERROR-STRING = "Policy GUID is a mandatory field (table "
                                 + ttAuditFieldPolicy._File-name + "/" + ttAuditFieldPolicy._Owner + "/" 
                                 + ttAuditFieldPolicy._Field-name + ")".
                       UNDO, LEAVE.
                   END.

                   /* check if a policy with the GUID exists */
                   hPolicyBuffer:FIND-FIRST ("where _Audit-policy-guid = " + QUOTER(ttAuditFieldPolicy._Audit-policy-guid)) NO-ERROR.

                   IF NOT hPolicyBuffer:AVAILABLE THEN DO:
                       ASSIGN DATASET dsAudPolicy:ERROR = YES
                              BUFFER ttAuditFieldPolicyBefore:ERROR = YES
                              BUFFER ttAuditFieldPolicyBefore:ERROR-STRING = "Policy GUID " + QUOTER(ttAuditFieldPolicy._Audit-policy-guid)
                                     + "is invalid (table"  + ttAuditFieldPolicy._File-name + "/" + ttAuditFieldPolicy._Owner + "/" 
                                     + ttAuditFieldPolicy._Field-name + ")".

                       UNDO, LEAVE.
                   END.

                   /* make sure table name, owner and field info were specified */
                   IF ttAuditFieldPolicy._File-name = "" OR ttAuditFieldPolicy._File-name = ? OR 
                       ttAuditFieldPolicy._Owner = "" OR ttAuditFieldPolicy._Owner = ? OR 
                       ttAuditFieldPolicy._Field-Name = "" OR ttAuditFieldPolicy._Field-name = ? THEN DO:
                       ASSIGN DATASET dsAudPolicy:ERROR = YES
                              BUFFER ttAuditFieldPolicyBefore:ERROR = YES
                              BUFFER ttAuditFieldPolicyBefore:ERROR-STRING = "Table name, SQL owner and field name are mandatory fields (policy "
                                 + ttAuditFieldPolicy._Audit-policy-guid  + ")".
                       UNDO, LEAVE.
                   END.

                   /* make sure we don't get audit data tables */
                   IF ttAuditFieldPolicy._File-name = "_aud-audit-data":U OR
                      ttAuditFieldPolicy._File-name = "_aud-audit-data-value":U THEN DO:
                       ASSIGN DATASET dsAudPolicy:ERROR = YES
                              BUFFER ttAuditFieldPolicyBefore:ERROR = YES
                              BUFFER ttAuditFieldPolicyBefore:ERROR-STRING = "Table " + ttAuditFieldPolicy._File-name + " cannot be audited (policy "
                                 + QUOTER(hPolicyBuffer::_Audit-policy-name)  + ")".
                       UNDO, LEAVE.
                   END.

                   /* make sure levels are valid */
                   IF ttAuditFieldPolicy._Audit-create-level < -1 OR 
                      (ttAuditFieldPolicy._Audit-create-level > 2 AND ttAuditFieldPolicy._Audit-create-level NE 12 /* compressed mode */)  OR
                      ttAuditFieldPolicy._Audit-update-level < -1 OR 
                      (ttAuditFieldPolicy._Audit-update-level > 3 AND ttAuditFieldPolicy._Audit-update-level NE 12 AND ttAuditFieldPolicy._Audit-update-level NE 13) OR 
                      ttAuditFieldPolicy._Audit-delete-level < -1 OR 
                      (ttAuditFieldPolicy._Audit-delete-level > 2 AND ttAuditFieldPolicy._Audit-delete-level NE 12)  THEN DO:
                   
                      ASSIGN DATASET dsAudPolicy:ERROR = YES
                             BUFFER ttAuditFieldPolicyBefore:ERROR = YES
                             BUFFER ttAuditFieldPolicyBefore:ERROR-STRING = "One of the event levels is invalid (table " 
                                    + ttAuditFieldPolicy._File-name + "/" + ttAuditFieldPolicy._Owner + "/" 
                                    + ttAuditFieldPolicy._Field-name
                                    + ") on policy " + QUOTER(hPolicyBuffer::_Audit-policy-name).

                      UNDO, LEAVE.
                   END.
                END.

                /* try to save changes */
                BUFFER ttAuditFieldPolicyBefore:SAVE-ROW-CHANGES() NO-ERROR.
    
                /* trap errors */
                IF BUFFER ttAuditFieldPolicyBefore:ERROR THEN DO:
                    /* hold on to the error number and error message so we don't loose them after
                      calling the find-first methods below.
                    */
                    ASSIGN errorNum = ERROR-STATUS:GET-NUMBER(1)
                           errorMsg = ERROR-STATUS:GET-MESSAGE(1).

                    /* if this was a new row, need to get the values out of the after table */
                    IF BUFFER ttAuditFieldPolicyBefore:ROW-STATE = ROW-DELETED THEN
                        hPolicyBuffer:FIND-FIRST ("where _Audit-policy-guid = " + QUOTER(ttAuditFieldPolicyBefore._Audit-policy-guid)) NO-ERROR.
                    ELSE
                       hPolicyBuffer:FIND-FIRST ("where _Audit-policy-guid = " + QUOTER(ttAuditFieldPolicy._Audit-policy-guid)) NO-ERROR.

                    /* build a common error message with all the info we have */
                    ASSIGN cMsg = "field:"  + (IF AVAILABLE ttAuditFieldPolicy THEN ttAuditFieldPolicy._Field-name ELSE ttAuditFieldPolicyBefore._Field-name)
                                  + " table:" + (IF AVAILABLE ttAuditFieldPolicy THEN ttAuditFieldPolicy._File-name ELSE ttAuditFieldPolicyBefore._File-name)
                                  + " owner:" +  (IF AVAILABLE ttAuditFieldPolicy THEN ttAuditFieldPolicy._Owner ELSE ttAuditFieldPolicyBefore._Owner)
                                  + " policy " + QUOTER(hPolicyBuffer::_Audit-policy-name).
                                                       
                    /* could not get a lock */
                    IF errorNum = 12300 THEN DO:
                        ASSIGN BUFFER ttAuditFieldPolicyBefore:ERROR-STRING = 
                               "Record for " + cMsg + " is locked by another user.".
                    END.
                    ELSE IF errorNum = 132 THEN DO: /* duplicate record */
                        ASSIGN BUFFER ttAuditFieldPolicyBefore:ERROR-STRING = cMsg
                               + " was added by another user.".
                    END.
                    ELSE DO:
                         /* check if record was modified or deleted. DATA-SOURCE-MODIFIED returns
                            true for both cases
                         */
                         IF BUFFER ttAuditFieldPolicyBefore:DATA-SOURCE-MODIFIED THEN DO:
            
                           ASSIGN BUFFER ttAuditFieldPolicyBefore:ERROR-STRING = 
                             "Settings for " + cMsg + " have been changed or deleted by another user.".
                         END.
                         ELSE
                             ASSIGN BUFFER ttAuditFieldPolicyBefore:ERROR-STRING = cMsg + " " + errorMsg.
                    END.
                END.  /* BUFFER ttAuditFieldPolicyBefore:ERROR */
             END. /* FOR EACH ttAuditFieldPolicyBefore */
        END. /* NOT DATASET dsAudPolicy:ERROR */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-process-audit-file-policy) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE process-audit-file-policy Procedure 
PROCEDURE process-audit-file-policy :
/*------------------------------------------------------------------------------
  Purpose:    Process the changes on the aud-file-policy table and save them 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cIds AS CHARACTER NO-UNDO.

    /* if no error has happened so far, keep going with the updates */
    IF NOT DATASET dsAudPolicy:ERROR THEN DO:
        /* let's process the audit-file changes */
        FOR EACH ttAuditFilePolicyBefore:

            /* tries to find the record in the after table */
            BUFFER ttAuditFilePolicy:FIND-BY-ROWID(BUFFER ttAuditFilePolicyBefore:AFTER-ROWID) NO-ERROR.

            IF AVAILABLE (ttAuditFilePolicy) AND (BUFFER ttAuditFilePolicyBefore:ROW-STATE = ROW-CREATED OR
               BUFFER ttAuditFilePolicyBefore:ROW-STATE = ROW-MODIFIED) THEN DO:

               /* validate record before saving it */

               /* check if policy guid is valid */
               IF ttAuditFilePolicy._Audit-policy-guid = "" OR ttAuditFilePolicy._Audit-policy-guid= ? THEN DO:
                   ASSIGN DATASET dsAudPolicy:ERROR = YES
                          BUFFER ttAuditFilePolicyBefore:ERROR = YES
                          BUFFER ttAuditFilePolicyBefore:ERROR-STRING = "Policy GUID is a mandatory field (table "
                             + ttAuditFilePolicy._File-name + "/" + ttAuditFilePolicy._Owner + ")".
                   UNDO, LEAVE.
               END.

               /* check if a policy with the GUID exists */
               hPolicyBuffer:FIND-FIRST ("where _Audit-policy-guid = " + QUOTER(ttAuditFilePolicy._Audit-policy-guid)) NO-ERROR.

               IF NOT hPolicyBuffer:AVAILABLE THEN DO:
                   ASSIGN DATASET dsAudPolicy:ERROR = YES
                          BUFFER ttAuditFilePolicyBefore:ERROR = YES
                          BUFFER ttAuditFilePolicyBefore:ERROR-STRING = "Policy GUID " + QUOTER(ttAuditFilePolicy._Audit-policy-guid)
                                 + "is invalid (table"  + ttAuditFilePolicy._File-name + "/" + ttAuditFilePolicy._Owner + ")".
                   UNDO, LEAVE.
               END.

               /* make sure table name and owner info were specified */
               IF ttAuditFilePolicy._File-name = "" OR ttAuditFilePolicy._File-name = ? OR 
                   ttAuditFilePolicy._Owner = "" OR ttAuditFilePolicy._Owner = ? THEN DO:
                   ASSIGN DATASET dsAudPolicy:ERROR = YES
                          BUFFER ttAuditFilePolicyBefore:ERROR = YES
                          BUFFER ttAuditFilePolicyBefore:ERROR-STRING = "Table name and SQL owner are mandatory fields (policy "
                                 + ttAuditFilePolicy._Audit-policy-guid  + ")".
                   UNDO, LEAVE.
               END.

               /* make sure we don't get audit data tables */
               IF ttAuditFilePolicy._File-name = "_aud-audit-data":U OR
                  ttAuditFilePolicy._File-name = "_aud-audit-data-value":U THEN DO:
                   ASSIGN DATASET dsAudPolicy:ERROR = YES
                          BUFFER ttAuditFilePolicyBefore:ERROR = YES
                          BUFFER ttAuditFilePolicyBefore:ERROR-STRING =  "Table " + ttAuditFilePolicy._File-name + " cannot be audited (policy "
                                 + QUOTER(hPolicyBuffer::_Audit-policy-name)  + ")".
                   UNDO, LEAVE.
               END.

               /* make sure levels are valid */
               IF ttAuditFilePolicy._Audit-create-level < 0 OR 
                  (ttAuditFilePolicy._Audit-create-level > 2 AND ttAuditFilePolicy._Audit-create-level NE 12) OR 
                  ttAuditFilePolicy._Audit-update-level < 0 OR 
                  (ttAuditFilePolicy._Audit-update-level > 3 AND ttAuditFilePolicy._Audit-update-level NE 12 AND ttAuditFilePolicy._Audit-update-level NE 13) OR 
                  ttAuditFilePolicy._Audit-delete-level < 0 OR 
                  (ttAuditFilePolicy._Audit-delete-level > 2 AND ttAuditFilePolicy._Audit-delete-level NE 12) THEN DO:

                  ASSIGN DATASET dsAudPolicy:ERROR = YES
                         BUFFER ttAuditFilePolicyBefore:ERROR = YES
                         BUFFER ttAuditFilePolicyBefore:ERROR-STRING = "One of the event levels is invalid (table " 
                                + ttAuditFilePolicy._File-name + "/" + ttAuditFilePolicy._Owner 
                                + ") on policy " + QUOTER(hPolicyBuffer::_Audit-policy-name).

                  UNDO, LEAVE.
               END.

               /* make sure event ids are valid */

               IF NOT VALID-HANDLE(hbufferAudEvent) THEN DO:
                   /* create a buffer for the _aud-event table so we can validate if the event ids are valid */
                   CREATE BUFFER hbufferAudEvent FOR TABLE cAudEventTable NO-ERROR.
                   IF ERROR-STATUS:ERROR THEN DO:
                      ASSIGN DATASET dsAudPolicy:ERROR = YES
                             BUFFER ttAuditFilePolicyBefore:ERROR = YES
                             BUFFER ttAuditFilePolicyBefore:ERROR-STRING = "Coud not access " + cAudEventTable 
                                    + CHR(10) + ERROR-STATUS:GET-MESSAGE(1).

                       UNDO, LEAVE.
                   END.
               END.

               /* check if the create event id is valid */
               /* try to get the default event id for the events */
               /* cIds has the ids in the following order:
                  create,update,delete 
               */
               RUN auditing/_get-def-eventids.p (INPUT ttAuditFilePolicy._File-name, OUTPUT cIds).

               /* if the default create event level value is 0, then it doesn't apply to the table */
               IF INTEGER(ENTRY(1,cIds)) > 0 THEN DO:
                   hbufferAudEvent:FIND-FIRST ("WHERE _Event-id = " + STRING(ttAuditFilePolicy._Create-event-id)) NO-ERROR.
    
                   IF NOT hbufferAudEvent:AVAILABLE THEN DO:
                       ASSIGN DATASET dsAudPolicy:ERROR = YES
                              BUFFER ttAuditFilePolicyBefore:ERROR = YES
                              BUFFER ttAuditFilePolicyBefore:ERROR-STRING = "Create event id " + STRING(ttAuditFilePolicy._Create-event-id) 
                                     + " is invalid (table " + ttAuditFilePolicy._File-name + "/" + ttAuditFilePolicy._Owner 
                                    + ") on policy " + QUOTER(hPolicyBuffer::_Audit-policy-name).
    
                        UNDO, LEAVE.
                   END.
               END.

               /* if the default update event level value is 0, then it doesn't apply to the table */
               IF INTEGER(ENTRY(2,cIds)) > 0 THEN DO:
                   /* check if the update event id is valid */
                   IF  ttAuditFilePolicy._Update-event-id <> ttAuditFilePolicy._Create-event-id THEN DO:
                       hbufferAudEvent:FIND-FIRST ("WHERE _Event-id = " + STRING(ttAuditFilePolicy._Update-event-id)) NO-ERROR.
    
                       IF NOT hbufferAudEvent:AVAILABLE THEN DO:
                           ASSIGN DATASET dsAudPolicy:ERROR = YES
                                  BUFFER ttAuditFilePolicyBefore:ERROR = YES
                                  BUFFER ttAuditFilePolicyBefore:ERROR-STRING = "Update event id " + STRING(ttAuditFilePolicy._Update-event-id) 
                                         + " is invalid (table " + ttAuditFilePolicy._File-name + "/" + ttAuditFilePolicy._Owner 
                                        + ") on policy " + QUOTER(hPolicyBuffer::_Audit-policy-name).
    
                            UNDO, LEAVE.
                       END.
                   END.
               END.

               /* if the default delete event level value is 0, then it doesn't apply to the table */
               IF INTEGER(ENTRY(3,cIds)) > 0 THEN DO:
                   /* check if the delete event id is valid */
                   IF  ttAuditFilePolicy._Delete-event-id <> ttAuditFilePolicy._Create-event-id AND 
                       ttAuditFilePolicy._Delete-event-id <> ttAuditFilePolicy._Update-event-id THEN DO:
                       hbufferAudEvent:FIND-FIRST ("WHERE _Event-id = " + STRING(ttAuditFilePolicy._Delete-event-id)) NO-ERROR.
    
                       IF NOT hbufferAudEvent:AVAILABLE THEN DO:
                           ASSIGN DATASET dsAudPolicy:ERROR = YES
                                  BUFFER ttAuditFilePolicyBefore:ERROR = YES
                                  BUFFER ttAuditFilePolicyBefore:ERROR-STRING = "Delete event id " + STRING(ttAuditFilePolicy._Delete-event-id) 
                                         + " is invalid (table " + ttAuditFilePolicy._File-name + "/" + ttAuditFilePolicy._Owner 
                                        + ") on policy " + QUOTER(hPolicyBuffer::_Audit-policy-name).
    
                            UNDO, LEAVE.
                       END.
                   END.
               END.

            END.

            /* try to save changes */
            BUFFER ttAuditFilePolicyBefore:SAVE-ROW-CHANGES() NO-ERROR.

            /* trap errors */
            IF BUFFER ttAuditFilePolicyBefore:ERROR THEN DO:
                /* hold on to the error number and error message so we don't loose them after
                  calling the find-first methods below.
                */
                ASSIGN errorNum = ERROR-STATUS:GET-NUMBER(1)
                       errorMsg = ERROR-STATUS:GET-MESSAGE(1).

                /* if this was a deleted row, need to get the values out of the before table */
                IF BUFFER ttAuditFilePolicyBefore:ROW-STATE = ROW-DELETED THEN
                    hPolicyBuffer:FIND-FIRST ("where _Audit-policy-guid = " + QUOTER(ttAuditFilePolicyBefore._Audit-policy-guid)) NO-ERROR.
                ELSE
                   hPolicyBuffer:FIND-FIRST ("where _Audit-policy-guid = " + QUOTER(ttAuditFilePolicy._Audit-policy-guid)) NO-ERROR.

                /* build a common error message with all the info we have */
                ASSIGN cMsg = "table:" + (IF AVAILABLE ttAuditFilePolicy THEN ttAuditFilePolicy._File-name ELSE ttAuditFilePolicyBefore._File-name)
                              + " owner:" +  (IF AVAILABLE ttAuditFilePolicy THEN ttAuditFilePolicy._Owner ELSE ttAuditFilePolicyBefore._Owner)
                              + " policy " + QUOTER(hPolicyBuffer::_Audit-policy-name).                         

                /* could not get a lock */
                IF errorNum = 12300 THEN DO:
                    ASSIGN BUFFER ttAuditFilePolicyBefore:ERROR-STRING = 
                           "Record for " + cMsg + " is locked by another user.".
                END.
                ELSE IF errorNum = 132 THEN DO: /* duplicate record */
                    /* if adding record, need to get the values from the after table */
                    ASSIGN BUFFER ttAuditFilePolicyBefore:ERROR-STRING = cMsg 
                                 + " was added by another user.".
                END.
                ELSE DO:
                     /* check if record was modified or deleted. DATA-SOURCE-MODIFIED returns
                        true for both cases
                     */
                     IF BUFFER ttAuditFilePolicyBefore:DATA-SOURCE-MODIFIED THEN DO:
                       ASSIGN BUFFER ttAuditFilePolicyBefore:ERROR-STRING = 
                         "Settings for " + cMsg + " have been changed or deleted by another user.".
                     END.
                     ELSE
                         ASSIGN BUFFER ttAuditFilePolicyBefore:ERROR-STRING = cMsg + " " + errorMsg.
                END.
            END. /*  BUFFER ttAuditFilePolicyBefore:ERROR */
        END. /* FOR EACH ttAuditFilePolicyBefore */
    END. /* NOT DATASET dsAudPolicy:ERROR */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-process-audit-policy) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE process-audit-policy Procedure 
PROCEDURE process-audit-policy :
/*------------------------------------------------------------------------------
  Purpose:    Process the changes on the audit-policy table and save them 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE i             AS INTEGER   NO-UNDO.
DEFINE VARIABLE hQueryChild   AS HANDLE    NO-UNDO.
DEFINE VARIABLE hBufferChild  AS HANDLE    NO-UNDO.

    /* now, let's process changes to any policy record. If a policy record is deleted, we have
       to delete all related records in the children tables.
    */
    FOR EACH ttAuditPolicyBefore:

        /* check if we are deleting a policy */
        IF  BUFFER ttAuditPolicyBefore:ROW-STATE = ROW-DELETED THEN DO:

            /* let's delete the children records */
            DO i = 2 TO DATASET dsAudPolicy:NUM-BUFFERS:

                /* we get buffer handle of the table in the actual database and delete the records */
               hbufferChild = DATASET dsAudPolicy:GET-BUFFER-HANDLE(i):DATA-SOURCE:QUERY:GET-BUFFER-HANDLE(1).
               CREATE QUERY hQueryChild.
               hQueryChild:ADD-BUFFER(hbufferChild).
               /* find all the records on this child table with the same GUID */
               hQueryChild:QUERY-PREPARE ("for each " + hbufferChild:NAME + " where _Audit-policy-guid = "
                                          + QUOTER (ttAuditPolicyBefore._Audit-policy-guid)).
               hQueryChild:QUERY-OPEN.

               hQueryChild:GET-FIRST(EXCLUSIVE-LOCK,NO-WAIT).

               DO WHILE  NOT hQueryChild:QUERY-OFF-END:

                   /* if a record is locked by someone else, abort the whole update */
                   IF hBufferChild:LOCKED THEN DO:
                       ASSIGN DATASET dsAudPolicy:ERROR = YES
                              BUFFER ttAuditPolicyBefore:ERROR = YES
                              BUFFER ttAuditPolicyBefore:ERROR-STRING = hbufferChild:NAME + " locked by another user. "
                              + "Cannot delete policy " + QUOTER (ttAuditPolicyBefore._Audit-policy-name).
                       LEAVE.
                   END.
                   ELSE DO:

                       hBufferChild:BUFFER-DELETE() NO-ERROR.
                       /* todo: do we care if something can't be deleted in one of the children tables? */
                   END.
                   hQueryChild:GET-NEXT(EXCLUSIVE-LOCK,NO-WAIT).
               END.

               hQueryChild:QUERY-CLOSE.
               DELETE OBJECT hQueryChild.

               /* leave if we found an error */
               IF DATASET dsAudPolicy:ERROR THEN 
                   LEAVE.
            END.

        END.

        /* if the user is adding a new policy or modifying, we have to make sure the policy name is
           unique on this given datasource
        */
        IF  BUFFER ttAuditPolicyBefore:ROW-STATE = ROW-CREATED OR
            BUFFER ttAuditPolicyBefore:ROW-STATE = ROW-MODIFIED THEN DO:

            /* get the policy name, in case this is a row-created state */
            BUFFER ttAuditPolicy:FIND-BY-ROWID(BUFFER ttAuditPolicyBefore:AFTER-ROWID) NO-ERROR.

            IF AVAILABLE ttAuditPolicy THEN DO:

                ASSIGN cPolicyName = ttAuditPolicy._Audit-policy-name.

                /* make sure policy name was specified */
                IF cPolicyName = "" OR cPolicyName = ? THEN DO:
                   ASSIGN DATASET dsAudPolicy:ERROR = YES
                          BUFFER ttAuditPolicyBefore:ERROR = YES
                          BUFFER ttAuditPolicyBefore:ERROR-STRING = "Audit policy name is a mandatory field".
                   UNDO, LEAVE.
                END.

                /* make sure policy guid was specified */
                IF ttAuditPolicy._Audit-policy-guid = "" OR ttAuditPolicy._Audit-policy-guid= ? THEN DO:
                   ASSIGN DATASET dsAudPolicy:ERROR = YES
                          BUFFER ttAuditPolicyBefore:ERROR = YES
                          BUFFER ttAuditPolicyBefore:ERROR-STRING = "Policy GUID is a mandatory field".
                   UNDO, LEAVE.
                END.


                /* if creating new record, make sure there is no other record with the same GUID */
                IF BUFFER ttAuditPolicyBefore:ROW-STATE = ROW-CREATED  THEN DO:
                    /* check if a policy with the GUID exists */
                    hPolicyBuffer:FIND-FIRST ("where _Audit-policy-guid = " + QUOTER(ttAuditPolicy._Audit-policy-guid)) NO-ERROR.

                    IF hPolicyBuffer:AVAILABLE THEN DO:
                        ASSIGN DATASET dsAudPolicy:ERROR = YES
                               BUFFER ttAuditPolicyBefore:ERROR = YES
                               BUFFER ttAuditPolicyBefore:ERROR-STRING = "Another policy exists with policy GUID " + QUOTER(ttAuditPolicy._Audit-policy-guid).

                        UNDO, LEAVE.
                    END.
                END.

            END.
                           
            /* see if name is duplicate */
            hPolicyBuffer:FIND-FIRST ("WHERE _Audit-policy-name = " + QUOTER(cPolicyName)) NO-ERROR.

            IF hPolicyBuffer:AVAILABLE AND hPolicyBuffer::_Audit-policy-name = cPolicyName THEN DO:
                /* new record been added - display error message */
                IF  BUFFER ttAuditPolicyBefore:ROW-STATE = ROW-CREATED THEN DO:
                    /* can't have more than one policy with the same name */
                    ASSIGN DATASET dsAudPolicy:ERROR = YES
                           BUFFER ttAuditPolicyBefore:ERROR = YES
                           BUFFER ttAuditPolicyBefore:ERROR-STRING = 
                             "Policy "+ QUOTER(cPolicyName) + 
                             " was added by another user.".
                    UNDO, LEAVE.
                END.
                ELSE DO:
                    /* user is updating the record - check if the one we found is not
                       the one we are trying to update
                    */
                    IF hPolicyBuffer::_Audit-policy-guid <> ttAuditPolicyBefore._Audit-policy-guid THEN DO:
                        /* user updated the policy name, but it matches another policy
                           that may have been added by another user. Set error flags
                        */
                        ASSIGN DATASET dsAudPolicy:ERROR = YES
                               BUFFER ttAuditPolicyBefore:ERROR = YES
                               BUFFER ttAuditPolicyBefore:ERROR-STRING = 
                                 "Policy name "+ QUOTER(cPolicyName) + 
                                 " conflicts with another policy added by another user.".
                        UNDO, LEAVE.
                    END. /* diff policies */
                END.
            END.

            /* if importing policies, keep a list of the policy names, so that we
               fire the event later 
            */
            IF AVAILABLE ttAuditPolicy AND ttAuditPolicy._imported THEN DO:
               /* fire auditing event for load of policies */
               AUDIT-CONTROL:LOG-AUDIT-EVENT(10304, /* import of policies */
                                             "APM." + cPolicyName /* util-name.policy-name */, 
                                             phDbName + ",XML":U /* detail */).
            END.
        END.

        /* all is good - try to save the policy record */
        BUFFER ttAuditPolicyBefore:SAVE-ROW-CHANGES() NO-ERROR.

        IF BUFFER ttAuditPolicyBefore:ERROR THEN DO: /* trap errors */

            IF  BUFFER ttAuditPolicyBefore:DATA-SOURCE-MODIFIED THEN DO:
                /* check if we can find the record in the table. If not, the record was deleted
                   by another user 
                */
                hPolicyBuffer:FIND-FIRST ("where _Audit-policy-name = " + QUOTER(ttAuditPolicyBefore._Audit-policy-name)) NO-ERROR.

                cMsg = "Policy "+ QUOTER(ttAuditPolicyBefore._Audit-policy-name).

                IF hPolicyBuffer:AVAILABLE THEN
                    ASSIGN BUFFER ttAuditPolicyBefore:ERROR-STRING = cMsg 
                           + " has been changed by another user.".
                ELSE
                    ASSIGN BUFFER ttAuditPolicyBefore:ERROR-STRING = cMsg
                                 + " has been deleted by another user.".
            END.
            ELSE /* some other error - add the error message */
                 ASSIGN BUFFER ttAuditPolicyBefore:ERROR-STRING = cMsg + " " +
                     ERROR-STATUS:GET-MESSAGE(1).

        END. /* BUFFER ttAuditPolicyBefore:ERROR */
    END. /* FOR EACH ttAuditPolicyBefore */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-save-data) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE save-data Procedure 
PROCEDURE save-data :
/*------------------------------------------------------------------------------
  Purpose:    Process the changes and save them 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE newAppCtx   AS LOGICAL     NO-UNDO INITIAL FALSE.

    /* build a query against the _aud-audit-policy and lock the first policy record. If
       another user tries to update a policy through this procedure, we will return an error
       message.
    */   
    ASSIGN cTableName =  pcDbName + "._aud-audit-policy":U
           cAudEventTable = pcDbName + "._aud-event":U.
    
    CREATE QUERY hQuery.
    CREATE BUFFER hPolicyBuffer FOR TABLE cTableName.
    hQuery:ADD-BUFFER(hPolicyBuffer).
    hQuery:QUERY-PREPARE ('FOR EACH ' + cTableName).
    hQuery:QUERY-OPEN.

    /* check if any policies were imported, in which case we need to  */
    FIND FIRST ttAuditPolicy WHERE ttAuditPolicy._imported = YES NO-LOCK NO-ERROR.

    IF AVAILABLE ttAuditPolicy THEN DO:
        /* auditing - start a new application context so that one can report
           all the records that are loaded as a group.
        */
        IF AUDIT-CONTROL:APPL-CONTEXT-ID = ? THEN DO:
           ASSIGN newAppCtx = YES.
           AUDIT-CONTROL:SET-APPL-CONTEXT("Import Audit Policies", "XML", "").
        END.
      RELEASE ttAuditPolicy.
    END.

    main-trans:
    DO TRANSACTION ON ERROR UNDO, LEAVE
                   ON STOP  UNDO, LEAVE:

        /* lock the first policy right away */
        hQuery:GET-FIRST(EXCLUSIVE-LOCK,NO-WAIT).

        IF hPolicyBuffer:LOCKED THEN DO:
            /* if another user has it locked, return an error */
            ASSIGN DATASET dsAudPolicy:ERROR = YES
                   pcErrorMsg = "Another user is locking one or more policies "
                   + "in this database. ".
            UNDO,LEAVE.
        END.

        RUN process-audit-policy.

        /* if we found an error, abort the whole update */
        IF DATASET dsAudPolicy:ERROR THEN
            UNDO main-trans, LEAVE main-trans.

        RUN process-audit-file-policy.

        /* if we found an error, abort the whole update */
        IF DATASET dsAudPolicy:ERROR THEN
            UNDO main-trans, LEAVE main-trans.

        RUN process-audit-field-policy.

        /* if we found an error, abort the whole update */
        IF DATASET dsAudPolicy:ERROR THEN
            UNDO main-trans, LEAVE main-trans.

        RUN process-audit-event-policy.

        /* if any error occurred, abort the whole update */
        IF DATASET dsAudPolicy:ERROR THEN
           UNDO, LEAVE.

        /* OE00181502  - must release the buffer so that any changes
           to it get written to the db now, before we refresh the 
           policy cache 
         */
        IF hPolicyBuffer:AVAILABLE THEN
           hPolicyBuffer:BUFFER-RELEASE().

        /* if all went well, let's tell the db to refresh its cache */
        AUDIT-POLICY:REFRESH-AUDIT-POLICY(pcDbName).

    END. /* DO TRANSACTION */

    /* for auditing - clear the application context, if we have set one */
    IF newAppCtx THEN
       AUDIT-CONTROL:CLEAR-APPL-CONTEXT.

    IF VALID-HANDLE(hQuery) THEN DO:
       hQuery:QUERY-CLOSE.
       DELETE OBJECT hQuery.
    END.

    IF VALID-HANDLE(hPolicyBuffer) THEN
       DELETE OBJECT hPolicyBuffer.

    IF VALID-HANDLE(hBufferAudEvent) THEN
       DELETE OBJECT hbufferAudEvent.

/*  DEBUGGING CODE

    DEF VAR hDSChanges AS HANDLE.
    hDSChanges = DATASET dsAudPolicy:HANDLE.

    DO i = 1 TO hDSChanges:NUM-BUFFERS.
        CREATE QUERY hQuery.
        hBuffer = hDSChanges:GET-BUFFER-HANDLE(i):BEFORE-BUFFER.
        hQuery:ADD-BUFFER(hBuffer).
        
        hQuery:QUERY-PREPARE("FOR EACH " + hBuffer:NAME).
        hQuery:QUERY-OPEN().
        hQuery:GET-FIRST().
        DO WHILE NOT hQuery:QUERY-OFF-END:
            IF hBuffer:ERROR THEN
                MESSAGE hBuffer:ERROR-STRING.
            hQuery:GET-NEXT().
        END.
        hQuery:QUERY-CLOSE().
        DELETE OBJECT hQuery.
    END.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

