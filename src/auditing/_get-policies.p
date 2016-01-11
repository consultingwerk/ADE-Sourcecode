&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : _get-policies.p
    Purpose     : Read the settings of the audit policies stored on a given
                  database into the dataset passed by the caller. 
                  pcDbName is the logical database name.

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

DEFINE INPUT PARAMETER pcDbName  AS CHAR    NO-UNDO.
DEFINE OUTPUT PARAMETER DATASET FOR dsAudPolicy.
DEFINE OUTPUT PARAMETER errorMsg AS CHAR    NO-UNDO.

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
   ASSIGN DATASET dsAudPolicy:ERROR = YES
          errorMsg = "ERROR: Database " + pcDbName + " is not connected.".
   RETURN.
END.

RUN fill-ds.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-fill-ds) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fill-ds Procedure 
PROCEDURE fill-ds :
/*------------------------------------------------------------------------------
  Purpose:     Fill the dataset with data from database specified
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE hPolicyDS          AS HANDLE NO-UNDO.
DEFINE VARIABLE hFilePolicyDS      AS HANDLE NO-UNDO.
DEFINE VARIABLE hFieldPolicyDS     AS HANDLE NO-UNDO.
DEFINE VARIABLE hEventPolicyDS     AS HANDLE NO-UNDO.
DEFINE VARIABLE cPolicyTable       AS CHAR   NO-UNDO.
DEFINE VARIABLE cFilePolicyTable   AS CHAR   NO-UNDO.
DEFINE VARIABLE cFieldPolicyTable  AS CHAR   NO-UNDO.
DEFINE VARIABLE cEventPolicyTable  AS CHAR   NO-UNDO.

DEFINE VARIABLE hbufferPolicy      AS HANDLE NO-UNDO.
DEFINE VARIABLE hbufferFilePolicy  AS HANDLE NO-UNDO.
DEFINE VARIABLE hbufferFieldPolicy AS HANDLE NO-UNDO.
DEFINE VARIABLE hbufferEventPolicy AS HANDLE NO-UNDO.

DEFINE VARIABLE hQuery             AS HANDLE NO-UNDO.
DEFINE VARIABLE hBufferEvents      AS HANDLE NO-UNDO.
DEFINE VARIABLE cAuditEventTable   AS CHAR   NO-UNDO.
DEFINE VARIABLE hField             AS HANDLE NO-UNDO.

DEFINE VARIABLE i                  AS INTEGER NO-UNDO.

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
 
  ASSIGN hField = DATASET dsAudPolicy:GET-BUFFER-HANDLE(4):BUFFER-FIELD ('_Event-Name':U) NO-ERROR.
IF VALID-HANDLE (hField) THEN DO:
    CREATE QUERY hQuery.
    ASSIGN cAuditEventTable = pcDbName + '._aud-event':U.

    CREATE BUFFER hBufferEvents FOR TABLE cAuditEventTable.
    hEventPolicyDS:ADD-SOURCE-BUFFER(hBufferEvents,"_Event-id").

    hQuery:ADD-BUFFER(hbufferEventPolicy).
    hQuery:ADD-BUFFER(hBufferEvents).
    hQuery:QUERY-PREPARE ('FOR EACH ' + cEventPolicyTable + ', FIRST ' + 
                     cAuditEventTable + ' OF _aud-event-policy').


    hEventPolicyDS:QUERY = hQuery.
END.

DATASET    dsAudPolicy:GET-BUFFER-HANDLE(1):ATTACH-DATA-SOURCE(hPolicyDS ) NO-ERROR.
DATASET    dsAudPolicy:GET-BUFFER-HANDLE(2):ATTACH-DATA-SOURCE(hFilePolicyDS) NO-ERROR.
DATASET    dsAudPolicy:GET-BUFFER-HANDLE(3):ATTACH-DATA-SOURCE(hFieldPolicyDS) NO-ERROR.
DATASET    dsAudPolicy:GET-BUFFER-HANDLE(4):ATTACH-DATA-SOURCE(hEventPolicyDS) NO-ERROR.

DO i = 1 TO 4 :
    IF NOT VALID-HANDLE(DATASET dsAudPolicy:GET-BUFFER-HANDLE(i):DATA-SOURCE) THEN DO:
        DATASET dsAudPolicy:GET-BUFFER-HANDLE(i):TABLE-HANDLE:ERROR-STRING =
        "Data-Source for the table #" + STRING(i) + " not attached".
        DATASET dsAudPolicy:ERROR = TRUE.
        LEAVE.
    END.
END.
IF NOT DATASET dsAudPolicy:ERROR THEN
   DATASET dsAudPolicy:FILL.

DATASET dsAudPolicy:GET-BUFFER-HANDLE(1):DETACH-DATA-SOURCE NO-ERROR.
DATASET dsAudPolicy:GET-BUFFER-HANDLE(2):DETACH-DATA-SOURCE NO-ERROR.
DATASET dsAudPolicy:GET-BUFFER-HANDLE(3):DETACH-DATA-SOURCE NO-ERROR.
DATASET dsAudPolicy:GET-BUFFER-HANDLE(4):DETACH-DATA-SOURCE NO-ERROR.

DELETE OBJECT hPolicyDS NO-ERROR.
DELETE OBJECT hFilePolicyDS NO-ERROR.
DELETE OBJECT hFieldPolicyDS NO-ERROR.
DELETE OBJECT hEventPolicyDS NO-ERROR.
 
DELETE OBJECT hBufferPolicy NO-ERROR.
DELETE OBJECT hBufferFilePolicy NO-ERROR.
DELETE OBJECT hBufferFieldPolicy NO-ERROR.
DELETE OBJECT hBufferEventPolicy NO-ERROR.
 
IF VALID-HANDLE (hQuery) THEN DO:
    hQuery:QUERY-CLOSE.
    DELETE OBJECT hQuery NO-ERROR.
    DELETE OBJECT hBufferEvents NO-ERROR.
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

