&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*************************************************************/  
/* Copyright (c) 1984-2005,2008 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : _get-policies-tt.p
    Purpose     : Get settings of audit policies into temp-tables given
                  by the caller.

    Syntax      :

    Description :

    Author(s)   : Fernando de Souza
    Created     : Feb 23,2005
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE INPUT        PARAMETER mode    AS CHARACTER.
DEFINE INPUT        PARAMETER cDbName AS CHARACTER.
DEFINE INPUT-OUTPUT PARAMETER TABLE-HANDLE hTable.

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

CASE mode:
    WHEN  "_aud-audit-policy"       THEN RUN buildPolicyTable.
    WHEN  "_aud-file-policy"        THEN RUN buildFilePolicyTable.
    WHEN  "_aud-field-policy"       THEN RUN buildFieldPolicyTable.
    WHEN  "_aud-event-policy"       THEN RUN buildEventPolicyTable.
END CASE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-buildEventPolicyTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildEventPolicyTable Procedure 
PROCEDURE buildEventPolicyTable :
/*------------------------------------------------------------------------------
  Purpose:     Populates temp-table passed with data from _aud-event-policy
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cTable                      AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE hQuery                      AS HANDLE       NO-UNDO.
    DEFINE VARIABLE hBuffer                     AS HANDLE       NO-UNDO.
    DEFINE VARIABLE hBufferTT                   AS HANDLE       NO-UNDO.

    DEFINE VARIABLE cTableEvent                 AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE hQueryEvent                 AS HANDLE       NO-UNDO.
    DEFINE VARIABLE hBufferEvent                AS HANDLE       NO-UNDO.

    ASSIGN cTable = cDbName + "._aud-event-policy":U
           cTableEvent = cDbName + "._aud-event":U
           hBufferTT = hTable:DEFAULT-BUFFER-HANDLE.

    CREATE QUERY hQuery.
    CREATE BUFFER hBuffer FOR TABLE cTable. 
    hQuery:ADD-BUFFER(hBuffer).

    hQuery:QUERY-PREPARE('FOR EACH ' + cTable + ' NO-LOCK').
    hQuery:QUERY-OPEN.

    CREATE QUERY hQueryEvent.
    CREATE BUFFER hBufferEvent FOR TABLE cTableEvent. 
    hQueryEvent:ADD-BUFFER(hBufferEvent).
    hQueryEvent:QUERY-PREPARE('FOR EACH ' + cTableEvent + ' NO-LOCK').
    hQueryEvent:QUERY-OPEN.

    REPEAT:
        IF NOT hQuery:GET-NEXT THEN LEAVE.
        hBufferTT:BUFFER-CREATE().

        hBufferEvent:FIND-FIRST(" where _event-id = " + STRING(hBuffer::_Event-id), NO-LOCK) NO-ERROR.

        /* copy the data into the temp-table */
        ASSIGN hBufferTT::_Audit-policy-guid = hBuffer::_Audit-policy-guid
               hBufferTT::_Event-id = hBuffer::_Event-id
               hBufferTT::_Event-level = hBuffer::_Event-level
               hBufferTT::_Event-criteria = hBuffer::_Event-criteria.

        IF hBufferEvent:AVAILABLE THEN
            ASSIGN hBufferTT::_Event-name = hBufferEvent::_Event-name
                   hBufferTT::_Event-type = hBufferEvent::_Event-type
                   hBufferTT::_Event-description = hBufferEvent::_Event-description.

    END.

    hQuery:QUERY-CLOSE.
    DELETE OBJECT hQuery.
    DELETE OBJECT hBuffer.

    hQueryEvent:QUERY-CLOSE.
    DELETE OBJECT hQueryEvent.
    DELETE OBJECT hBufferEvent.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildFieldPolicyTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildFieldPolicyTable Procedure 
PROCEDURE buildFieldPolicyTable :
/*------------------------------------------------------------------------------
  Purpose:  Populates temp-table passed with data from _aud-field-policy   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cTable                      AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE hQuery                      AS HANDLE       NO-UNDO.
    DEFINE VARIABLE hBuffer                     AS HANDLE       NO-UNDO.
    DEFINE VARIABLE hBufferTT                   AS HANDLE       NO-UNDO.

    ASSIGN cTable = cDbName + "._aud-field-policy":U
           hBufferTT = hTable:DEFAULT-BUFFER-HANDLE.

    CREATE QUERY hQuery.
    CREATE BUFFER hBuffer FOR TABLE cTable. 
    hQuery:ADD-BUFFER(hBuffer).

    hQuery:QUERY-PREPARE('FOR EACH ' + cTable + ' NO-LOCK').
    hQuery:QUERY-OPEN.

    REPEAT:
        IF NOT hQuery:GET-NEXT THEN LEAVE.
        hBufferTT:BUFFER-CREATE().

        ASSIGN 
            hBufferTT::_Audit-policy-guid = hBuffer::_Audit-policy-guid
            hBufferTT::_File-name = hBuffer::_File-name
            hBufferTT::_Owner = hBuffer::_Owner
            hBufferTT::_Field-name = hBuffer::_Field-name
            hBufferTT::_Audit-create-level = hBuffer::_Audit-create-level
            hBufferTT::_Audit-update-level = hBuffer::_Audit-update-level
            hBufferTT::_Audit-delete-level = hBuffer::_Audit-delete-level
            hBufferTT::_Audit-read-level = hBuffer::_Audit-read-level
            hBufferTT::_Audit-identifying-field = hBuffer::_Audit-identifying-field.
    END.

    hQuery:QUERY-CLOSE.
    DELETE OBJECT hQuery.
    DELETE OBJECT hBuffer.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildFilePolicyTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildFilePolicyTable Procedure 
PROCEDURE buildFilePolicyTable :
/*------------------------------------------------------------------------------
  Purpose:     Populates temp-table passed with data from _aud-file-policy
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cTable                      AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE hQuery                      AS HANDLE       NO-UNDO.
    DEFINE VARIABLE hBuffer                     AS HANDLE       NO-UNDO.
    DEFINE VARIABLE hBufferTT                   AS HANDLE       NO-UNDO.

    ASSIGN cTable = cDbName + "._aud-file-policy":U
           hBufferTT = hTable:DEFAULT-BUFFER-HANDLE.

    CREATE QUERY hQuery.
    CREATE BUFFER hBuffer FOR TABLE cTable. 
    hQuery:ADD-BUFFER(hBuffer).

    hQuery:QUERY-PREPARE('FOR EACH ' + cTable + ' NO-LOCK').
    hQuery:QUERY-OPEN.

    REPEAT:
        IF NOT hQuery:GET-NEXT THEN LEAVE.
        hBufferTT:BUFFER-CREATE().

        ASSIGN 
            hBufferTT::_Audit-policy-guid = hBuffer::_Audit-policy-guid
            hBufferTT::_File-name = hBuffer::_File-name
            hBufferTT::_Owner = hBuffer::_Owner
            hBufferTT::_Audit-create-level = hBuffer::_Audit-create-level
            hBufferTT::_Create-event-id = hBuffer::_Create-event-id
            hBufferTT::_Audit-create-criteria = hBuffer::_Audit-create-criteria
            hBufferTT::_Audit-update-level = hBuffer::_Audit-update-level
            hBufferTT::_Update-event-id = hBuffer::_Update-event-id
            hBufferTT::_Audit-update-criteria = hBuffer::_Audit-update-criteria
            hBufferTT::_Audit-delete-level = hBuffer::_Audit-delete-level
            hBufferTT::_Delete-event-id = hBuffer::_Delete-event-id
            hBufferTT::_Audit-delete-criteria = hBuffer::_Audit-delete-criteria
            hBufferTT::_Audit-read-level = hBuffer::_Audit-read-level
            hBufferTT::_Read-event-id = hBuffer::_Read-event-id
            hBufferTT::_Audit-read-criteria = hBuffer::_Audit-read-criteria.
    END.

    hQuery:QUERY-CLOSE.
    DELETE OBJECT hQuery.
    DELETE OBJECT hBuffer.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildPolicyTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildPolicyTable Procedure 
PROCEDURE buildPolicyTable :
/*------------------------------------------------------------------------------
  Purpose:    Populates temp-table passed with data from _aud-audit-policy 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cTable                      AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE hQuery                      AS HANDLE       NO-UNDO.
    DEFINE VARIABLE hBuffer                     AS HANDLE       NO-UNDO.
    DEFINE VARIABLE hBufferTT                   AS HANDLE       NO-UNDO.

    ASSIGN cTable = cDbName + "._aud-audit-policy":U
           hBufferTT = hTable:DEFAULT-BUFFER-HANDLE.

    CREATE QUERY hQuery.
    CREATE BUFFER hBuffer FOR TABLE cTable. 
    hQuery:ADD-BUFFER(hBuffer).

    hQuery:QUERY-PREPARE('FOR EACH ' + cTable + ' NO-LOCK').
    hQuery:QUERY-OPEN.

    REPEAT:
        IF NOT hQuery:GET-NEXT THEN LEAVE.
        hBufferTT:BUFFER-CREATE().

        ASSIGN 
            hBufferTT::_Audit-policy-guid = hBuffer::_Audit-policy-guid
            hBufferTT::_Audit-policy-name = hBuffer::_Audit-policy-name
            hBufferTT::_Audit-policy-description = hBuffer::_Audit-policy-description
            hBufferTT::_Audit-data-security-level = hBuffer::_Audit-data-security-level
            hBufferTT::_Audit-custom-detail-level = hBuffer::_Audit-custom-detail-level
            hBufferTT::_Audit-policy-active = hBuffer::_Audit-policy-active.
    END.

    hQuery:QUERY-CLOSE.
    DELETE OBJECT hQuery.
    DELETE OBJECT hBuffer.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

