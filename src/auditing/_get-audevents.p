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
    File        : _get-audevents.p
    Purpose     : Fills the dataset passed with the _aud-event records from
                  the database pased in pcDbName.

    Syntax      :

    Description :

    Author(s)   :  Fernando de Souza
    Created     :  Feb 24,2005
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

{auditing/ttdefs/_audeventtt.i}

DEFINE DATASET dsAuditEvent FOR ttAuditEvent.

/* ***************************  Definitions  ************************** */
DEFINE INPUT  PARAMETER pcDbName       AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER plGetAllEvents AS LOGICAL   NO-UNDO.
DEFINE OUTPUT PARAMETER DATASET FOR dsAuditEvent.
DEFINE OUTPUT PARAMETER errorMsg       AS CHARACTER NO-UNDO.

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

RUN fillDataset.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-fillDataset) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fillDataset Procedure 
PROCEDURE fillDataset :
/*------------------------------------------------------------------------------
  Purpose:     Update temp-table with audit events from database passed in
               pcDbName
  Parameters:  input database name
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hEventDS     AS HANDLE NO-UNDO.
DEFINE VARIABLE cEventTable  AS CHAR   NO-UNDO.
DEFINE VARIABLE hQuery       AS HANDLE NO-UNDO.
DEFINE VARIABLE hbufferEvent AS HANDLE NO-UNDO.

    ASSIGN cEventTable = pcDbName + "._aud-event":U.
    
    CREATE BUFFER hBufferEvent FOR TABLE cEventTable. 
    
    CREATE DATA-SOURCE hEventDS.
    hEventDS:ADD-SOURCE-BUFFER(hbufferEvent,"_Event-id").

    IF NOT plGetAllEvents THEN DO:
       CREATE QUERY hQuery.
       hQuery:SET-BUFFERS(hbufferEvent).
       hQuery:QUERY-PREPARE ("FOR EACH ":U + hbufferEvent:NAME + " where _Event-id >= 32000":U).
       hEventDS:QUERY = hQuery.
    END.
    
    DATASET dsAuditEvent:GET-BUFFER-HANDLE(1):ATTACH-DATA-SOURCE(hEventDS) NO-ERROR.
    IF NOT DATASET dsAuditEvent:ERROR THEN
       DATASET dsAuditEvent:FILL.


    DATASET dsAuditEvent:GET-BUFFER-HANDLE(1):DETACH-DATA-SOURCE NO-ERROR.
    
    IF VALID-HANDLE(hQuery) THEN
       DELETE OBJECT hQuery.
    
    DELETE OBJECT hEventDS NO-ERROR.
    DELETE OBJECT hBufferEvent NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

