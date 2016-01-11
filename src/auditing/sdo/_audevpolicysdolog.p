&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
/* Procedure Description
"Data Logic Procedure.
 
Use this template to create a new Data Logic Procedure file to compile and run PROGRESS 4GL code."
*/
&ANALYZE-RESUME
{adecomm/appserv.i}
DEFINE VARIABLE h_APMT                     AS HANDLE          NO-UNDO.
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DataLogicProcedure 
/* ***********Included Temp-Table & Buffer definitions **************** */
{auditing/ttdefs/_audeventpolicytt.i}

/*************************************************************/
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File: _audevpolicysdolog.p 
    Purpose     :
 
    Syntax      :
 
    Description :
 
    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/
 
/* ***************************  Definitions  ************************** */
DEFINE VARIABLE hAuditEventTT AS HANDLE NO-UNDO.

{auditing/include/_aud-cache.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DataLogicProcedure
&Scoped-define DB-AWARE yes


/* Db-Required definitions. */
&IF DEFINED(DB-REQUIRED) = 0 &THEN
    &GLOBAL-DEFINE DB-REQUIRED TRUE
&ENDIF
&GLOBAL-DEFINE DB-REQUIRED-START   &IF {&DB-REQUIRED} &THEN
&GLOBAL-DEFINE DB-REQUIRED-END     &ENDIF


&Global-define DATA-LOGIC-TABLE ttAuditEventPolicy
&Global-define DATA-FIELD-DEFS "auditing/sdo/_audevpolicysdo.i"
&Global-define DATA-TABLE-NO-UNDO NO-UNDO


/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD is-valid-event-id DataLogicProcedure 
FUNCTION is-valid-event-id RETURNS LOGICAL
  ( INPUT pEvent-id AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DataLogicProcedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE APPSERVER DB-AWARE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DataLogicProcedure ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DataLogicProcedure 
/* ************************* Included-Libraries *********************** */
 
{src/adm2/logic.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DataLogicProcedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getAuditEvents DataLogicProcedure 
PROCEDURE getAuditEvents :
/*------------------------------------------------------------------------------
  Purpose:     New Audit database selected - rebuild temp-table
  Parameters:  input database name
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pcDbName  AS CHARACTER    NO-UNDO.

    /* hPolicyTT gets set in changeAuditDatabase() */
    hAuditEventTT:DEFAULT-BUFFER-HANDLE:EMPTY-TEMP-TABLE().

    /* populate the sdo's table with the policies available in the database
       specified in pcDbName.
    */
   /* RUN populateAuditEventData IN hAuditUtils (INPUT pcDbName, 
                                                INPUT-OUTPUT TABLE-HANDLE hAuditEventTT). 
                                                */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject DataLogicProcedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Upon initialization, register the sdo's temp-table with
               the audit cache mgr procedure so it can build the dataset object with the
               tables  needed to mantain the audit policies
------------------------------------------------------------------------------*/
DEFINE VARIABLE hContainerSource AS HANDLE     NO-UNDO.

  ASSIGN 
    hContainerSource = DYNAMIC-FUNCTION('getContainerSource':U IN TARGET-PROCEDURE).
  
  
  /* get the sdo's temp-table handle */
  hAuditEventTT = DYNAMIC-FUNCTION('getTempTableHandle':U IN TARGET-PROCEDURE).

  /* let the audit cache mgr procedure know the handle of the temp-table for the event policy
     table 
  */
  PUBLISH "registerAuditTableHandle":U (INPUT "event-policy":U, 
                                        INPUT hAuditEventTT).

  RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE writeBeginTransValidate DataLogicProcedure 
PROCEDURE writeBeginTransValidate :
/*------------------------------------------------------------------------------
  Purpose:     Does some validation before writing the record to the temp-table
               (in the sdo)
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hdl     AS HANDLE  NO-UNDO.
DEFINE VARIABLE iFound  AS LOGICAL NO-UNDO.
DEFINE VARIABLE hBuffer AS HANDLE  NO-UNDO.
DEFINE VARIABLE cInfo   AS CHAR    NO-UNDO.

    /* get the handle of the sdo's temp-table */
    ASSIGN hdl = DYNAMIC-FUNCTION('getTempTableHandle':U IN TARGET-PROCEDURE).
    
    
    IF isCopy() OR isAdd() THEN DO:

        /* make sure the event id is valid. Can only add events with id >= 32000 */
        IF b_ttauditeventpolicy._Event-id < 1 OR  b_ttauditeventpolicy._Event-id = ? THEN
           RETURN "You must specify an event id >= 32000. Update canceled".

        /* check if event is valid */
        IF NOT is-valid-event-id (b_ttauditeventpolicy._Event-id) THEN
            RETURN "Event id " + STRING(b_ttauditeventpolicy._Event-id) + " is not a valid id".

       /* if adding a new record, make sure it's not a duplicate */
       CREATE BUFFER hBuffer FOR TABLE hdl.

       /* check if this event-id was already picked */
       ASSIGN iFound = hBuffer:FIND-FIRST("where _Event-id = ":U 
                                          + STRING(b_ttauditeventpolicy._Event-id)
                                          + " AND _Audit-policy-guid = '":U 
                                          + b_ttauditeventpolicy._Audit-policy-guid + "'":U) NO-ERROR.

       DELETE OBJECT hBuffer.

       IF iFound THEN
         RETURN "Event id " + STRING(b_ttauditeventpolicy._Event-id) +
           " already set in this policy. Update canceled.".

       PUBLISH "get-audit-event-details" (INPUT b_ttauditeventpolicy._Event-id,
                                          OUTPUT cInfo).

       ASSIGN b_ttauditeventpolicy._Event-name = ENTRY(1,cInfo, CHR(1))
              b_ttauditeventpolicy._Event-type = ENTRY(2,cInfo, CHR(1))
              b_ttauditeventpolicy._Event-description = ENTRY(3,cInfo, CHR(1)) NO-ERROR.

    
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION is-valid-event-id DataLogicProcedure 
FUNCTION is-valid-event-id RETURNS LOGICAL
  ( INPUT pEvent-id AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  Calls a function in the cache manager to find out if an event is valid
            or not
    Notes:  
------------------------------------------------------------------------------*/
    
  /* check if event is valid */
  RETURN  DYNAMIC-FUNCTION ('is-valid-event-id':U IN hAuditCacheMgr, INPUT pEvent-id).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

