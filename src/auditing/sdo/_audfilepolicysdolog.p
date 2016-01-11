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
{auditing/ttdefs/_audfilepolicytt.i}

/*************************************************************/
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File: _audfilepolicysdolog.p 
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

DEFINE VARIABLE hfilePolicyTT AS HANDLE       NO-UNDO.

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


&Global-define DATA-LOGIC-TABLE ttAuditFilePolicy
&Global-define DATA-FIELD-DEFS "auditing/sdo/_audfilepolicysdo.i"
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject DataLogicProcedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Upon initialization, register the sdo's temp-table with
               the audit cache mgr procedure so it can build the dataset object with the
               tables needed to mantain the audit policies
------------------------------------------------------------------------------*/
DEFINE VARIABLE hContainerSource AS HANDLE     NO-UNDO.

  ASSIGN hContainerSource = DYNAMIC-FUNCTION('getContainerSource':U IN TARGET-PROCEDURE).

  /* get the sdo's temp-table handle */
  hfilePolicyTT = DYNAMIC-FUNCTION('getTempTableHandle':U IN TARGET-PROCEDURE).

  /* let the audit cache mgr procedure know the handle of the temp-table for the file policy
     table 
  */
  PUBLISH "registerAuditTableHandle":U (INPUT "file-policy":U,
                                        INPUT hfilePolicyTT).

  RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE writeBeginTransValidate DataLogicProcedure 
PROCEDURE writeBeginTransValidate :
/*------------------------------------------------------------------------------
  Purpose:     Validate record when saving it into the temp-table.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hdl    AS HANDLE  NO-UNDO.
DEFINE VARIABLE iFound AS LOGICAL NO-UNDO.

DEFINE VARIABLE hBuffer AS HANDLE    NO-UNDO.
DEFINE VARIABLE cIds    AS CHARACTER NO-UNDO.

    /* get the sdo's temp-table handle */
    ASSIGN hdl = DYNAMIC-FUNCTION('getTempTableHandle':U IN TARGET-PROCEDURE).
    
    IF isCopy() OR isAdd() THEN DO:

        ASSIGN b_ttAuditFilePolicy._file-name = TRIM(b_ttAuditFilePolicy._file-name).

        /* if adding or copying a table setting into the policy, make sure the
           table name is filled out 
        */
       IF b_ttAuditFilePolicy._file-name = "" THEN
          RETURN "You must specify a table name. Update canceled".

       /* now check if it a duplicate */
       CREATE BUFFER hBuffer FOR TABLE hdl.

       ASSIGN iFound = hBuffer:FIND-FIRST("where _Audit-policy-guid = '":U
                                          + b_ttAuditFilePolicy._Audit-policy-guid + "' AND _File-name = '":U
                                          + b_ttAuditFilePolicy._file-name 
                                          + "' AND _Owner = '":U  + b_ttAuditFilePolicy._Owner 
                                          + "'":U) NO-ERROR.
       DELETE OBJECT hBuffer.

       /* can only have one table with a given owner in the policy */
       IF iFound THEN
         RETURN "Table " + b_ttAuditFilePolicy._file-name + ", owner "
               + b_ttAuditFilePolicy._Owner + " already defined in this policy. Update canceled.".

    END.

    /* check if event is valid . Event id 0 is valid for some tables, so skip this check when
       value is zero
    */
    IF b_ttAuditFilePolicy._Create-event-id <> 0 AND 
       NOT is-valid-event-id (b_ttAuditFilePolicy._Create-event-id) THEN
       RETURN "Event id " + STRING(b_ttAuditFilePolicy._Create-event-id) + " is not a valid id (create)".

    IF b_ttAuditFilePolicy._Update-event-id <> 0 AND 
       NOT is-valid-event-id (b_ttAuditFilePolicy._Update-event-id) THEN
       RETURN "Event id " + STRING(b_ttAuditFilePolicy._Update-event-id) + " is not a valid id (update)".

    IF b_ttAuditFilePolicy._Delete-event-id <> 0 AND 
       NOT is-valid-event-id (b_ttAuditFilePolicy._Delete-event-id) THEN
       RETURN "Event id " + STRING(b_ttAuditFilePolicy._Delete-event-id) + " is not a valid id (delete)".

    /* check if the event id is valid for each event type */
    RUN auditing/_get-def-eventids.p (INPUT b_ttAuditFilePolicy._File-name,
                                      OUTPUT cIds).

    /*  if the default create event id for this table is zero,
        we will silently reset it to 0 if we got a different value..
        This can happen if the user changed multiple records at the
        same time and selected a table which we don't audit
        create events (such as the _Db table
    */
    IF ENTRY(1,cIds) <> "0":U THEN DO:
        IF  b_ttAuditFilePolicy._Create-event-id = 0 THEN
            RETURN "Create event id cannot be zero".
    END.
    ELSE DO:
        /* if the create event is not valid for this table, make
           sure we don't record a change to the create-level or
           create-event-id.
        */
         IF b_ttAuditFilePolicy._Create-event-id <> 0 THEN
            ASSIGN b_ttAuditFilePolicy._Create-event-id = 0.

         IF b_ttAuditFilePolicy._Audit-create-level <> 0 THEN
            ASSIGN b_ttAuditFilePolicy._Audit-create-level = 0.
    END.

    /* same as create event - see comments above */
    IF NUM-ENTRIES(cIds) > 1 AND ENTRY(2,cIds) <> "0":U THEN DO:
        IF  b_ttAuditFilePolicy._Update-event-id = 0 THEN
            RETURN "Update event id cannot be zero".
    END.
    ELSE DO: 
        IF b_ttAuditFilePolicy._Update-event-id <> 0 THEN
            b_ttAuditFilePolicy._Update-event-id = 0.

        IF b_ttAuditFilePolicy._Audit-update-level <> 0 THEN
            b_ttAuditFilePolicy._Audit-update-level = 0.

    END.

    /* same as create event - see comments above */
    IF NUM-ENTRIES(cIds) > 2 AND ENTRY(3,cIds) <> "0":U THEN DO:
        IF  b_ttAuditFilePolicy._Delete-event-id = 0 THEN
            RETURN "Delete event id cannot be zero".
    END.
    ELSE DO: 
        IF b_ttAuditFilePolicy._Delete-event-id <> 0 THEN
            b_ttAuditFilePolicy._Delete-event-id = 0.

        IF b_ttAuditFilePolicy._Audit-delete-level <> 0 THEN
            b_ttAuditFilePolicy._Audit-delete-level = 0.
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

