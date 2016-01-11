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
{auditing/ttdefs/_audfieldpolicytt.i}

/*************************************************************/
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File: _audfieldpolicysdolog.p 
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

DEFINE VARIABLE hfieldPolicyTT AS HANDLE       NO-UNDO.

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


&Global-define DATA-LOGIC-TABLE ttAuditFieldPolicy
&Global-define DATA-FIELD-DEFS "auditing/sdo/_audfieldpolicysdo.i"
&Global-define DATA-TABLE-NO-UNDO NO-UNDO


/* _UIB-PREPROCESSOR-BLOCK-END */
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
  hfieldPolicyTT = DYNAMIC-FUNCTION('getTempTableHandle':U IN TARGET-PROCEDURE).
  
  /* let the audit cache mgr procedure know the handle of the temp-table for the field policy
     table 
  */
  PUBLISH "registerAuditTableHandle":U (INPUT "field-policy":U,
                                        INPUT hfieldPolicyTT).

  RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE writeBeginTransValidate DataLogicProcedure 
PROCEDURE writeBeginTransValidate :
/*------------------------------------------------------------------------------
  Purpose:     Validate record before saving it into the temp-table.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE hdl     AS HANDLE    NO-UNDO.
DEFINE VARIABLE iFound  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE hBuffer AS HANDLE    NO-UNDO.
DEFINE VARIABLE cField  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cInfo   AS CHARACTER NO-UNDO.


    /* get the sdo's temp-table handle */
    ASSIGN hdl = DYNAMIC-FUNCTION('getTempTableHandle':U IN TARGET-PROCEDURE).
    
    IF isAdd() OR isCopy() THEN DO:

        ASSIGN b_ttAuditFieldPolicy._field-name = TRIM(b_ttAuditFieldPolicy._field-name).
        /* if adding or copying a table setting into the policy, make sure the
           table name is filled out 
        */
       IF b_ttAuditFieldPolicy._field-name = ? OR 
           b_ttAuditFieldPolicy._field-name = "":U THEN
          RETURN "You must specify a field name. Update canceled".
    
       ASSIGN cInfo = b_ttAuditFieldPolicy._File-name + "," + b_ttAuditFieldPolicy._Owner.

       /* see if field name is valid */
       IF DYNAMIC-FUNCTION ('is-valid-field-name' IN hAuditCacheMgr, 
                            INPUT cInfo, INPUT b_ttAuditFieldPolicy._Field-name) = NO THEN DO:
          RETURN "Field name specified is invalid. Update canceled".
       END.

       /* make sure it's not a duplicate */
       CREATE BUFFER hBuffer FOR TABLE hdl.
       ASSIGN iFound = hBuffer:FIND-FIRST("where _File-name = '":U 
                                          + b_ttAuditFieldPolicy._File-name + "' AND _Owner = '":U  
                                          + b_ttAuditFieldPolicy._Owner + "' AND _Field-name = '":U 
                                          + b_ttAuditFieldPolicy._Field-name
                                          + "' AND _Audit-policy-guid = '":U 
                                          + b_ttAuditFieldPolicy._Audit-policy-guid + "'":U) NO-ERROR.
       DELETE OBJECT hBuffer.

       /* can only have one table with a given owner in the policy */
       IF iFound THEN
         RETURN "Field " + b_ttAuditFieldPolicy._Field-name + " from table " 
                + b_ttAuditFieldPolicy._file-name + ", Owner ":U + b_ttAuditFieldPolicy._Owner 
                + " already defined in this policy. Update canceled.".

    END.

    IF b_ttAuditFieldPolicy._Audit-identifying-field < 0 THEN DO:
        RETURN "Cannot assign a negative value to the Identifying field.".
    END.

    IF b_ttAuditFieldPolicy._Audit-identifying-field <> 0 THEN DO:
    /* make sure it's not a duplicate identifying field value */
        CREATE BUFFER hBuffer FOR TABLE hdl.
        ASSIGN iFound = hBuffer:FIND-FIRST("where _File-name = '":U 
                                           + b_ttAuditFieldPolicy._File-name + "' AND _Owner = '":U  
                                           + b_ttAuditFieldPolicy._Owner 
                                           + "' AND _Audit-policy-guid = '":U 
                                           + b_ttAuditFieldPolicy._Audit-policy-guid 
                                           + "' AND _Field-name <> '":U
                                           + b_ttAuditFieldPolicy._Field-name
                                           + "' AND _Audit-identifying-field = ":U
                                           + STRING(b_ttAuditFieldPolicy._Audit-identifying-field)) NO-ERROR.
        IF hBuffer:AVAILABLE THEN
           ASSIGN cField = hBuffer::_Field-name.

        DELETE OBJECT hBuffer.

        IF iFound THEN
            RETURN "Another field (" + cField
                   + ") already defined with identifying value " 
                   + STRING(b_ttAuditFieldPolicy._Audit-identifying-field) 
                   + ". Update canceled.".
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

