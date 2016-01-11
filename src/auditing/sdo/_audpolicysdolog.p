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
{auditing/ttdefs/_audpolicytt.i}

/*************************************************************/
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File: _audpolicysdolog.p 
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

DEFINE VARIABLE hpolicyTT AS HANDLE       NO-UNDO.

/*{auditing/_aud-utils.i}*/

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


&Global-define DATA-LOGIC-TABLE ttAuditPolicy
&Global-define DATA-FIELD-DEFS "auditing/sdo/_audpolicysdo.i"
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
         WIDTH              = 66.8.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getAuditPolicies DataLogicProcedure 
PROCEDURE getAuditPolicies :
/*------------------------------------------------------------------------------
  Purpose:     New Audit database selected - rebuild temp-table
  Parameters:  input database name
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pcDbName  AS CHARACTER    NO-UNDO.

    /* hPolicyTT gets set in changeAuditDatabase() */
    hPolicyTT:DEFAULT-BUFFER-HANDLE:EMPTY-TEMP-TABLE().

    /* populate the sdo's table with the policies available in the database
       specified in pcDbName.
    */
   /* RUN populateAuditPolicyData IN hAuditUtils (INPUT pcDbName, 
                                                INPUT-OUTPUT TABLE-HANDLE hpolicyTT). 
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
               tables needed to mantain the audit policies
------------------------------------------------------------------------------*/
DEFINE VARIABLE hContainerSource AS HANDLE     NO-UNDO.

  ASSIGN 
    hContainerSource = DYNAMIC-FUNCTION('getContainerSource':U IN TARGET-PROCEDURE).

  /* get the sdo's temp-table handle */
  hPolicyTT = DYNAMIC-FUNCTION('getTempTableHandle':U IN TARGET-PROCEDURE).
  
  /* let the audit cache mgr procedure know the handle of the temp-table for the policy
     table 
  */
  PUBLISH "registerAuditTableHandle":U (INPUT "policy":U,
                                        INPUT hPolicyTT).

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

DEFINE VARIABLE hdl    AS HANDLE  NO-UNDO.
DEFINE VARIABLE iFound AS LOGICAL NO-UNDO.

    /* the the sdo's temp-table handle */
    ASSIGN hdl = DYNAMIC-FUNCTION('getTempTableHandle':U IN TARGET-PROCEDURE).
    
    /* always trim the policy name */
    ASSIGN b_ttauditpolicy._Audit-policy-name = TRIM(b_ttauditpolicy._Audit-policy-name).

    /* make sure a policy name was specified */
    IF b_ttauditpolicy._Audit-policy-name = "":U OR 
       b_ttauditpolicy._Audit-policy-name = ? THEN
       RETURN "You must specify a name for the policy. Update canceled".

    /* make sure there are no commas in the policy name */
    IF INDEX(b_ttauditpolicy._Audit-policy-name, ",":U) > 0 THEN
        RETURN "Invalid character in the policy name. Update canceled".
    
    /* if adding new record, check if it's not a duplicate */
    IF isCopy() OR isAdd() THEN DO:
        /* check if this policy name already exists */
       ASSIGN iFound = hdl:DEFAULT-BUFFER-HANDLE:FIND-FIRST("where _Audit-policy-name = '":U 
                                                            + b_ttauditpolicy._Audit-policy-name 
                                                            + "'":U) NO-ERROR.
       IF iFound THEN
         RETURN "Policy name must me unique in the working database. Update canceled.".
    
        /* need to assign new guid value*/
        /* todo */
       IF b_ttauditpolicy.RowMod <> 'U':U  THEN
          ASSIGN b_ttauditpolicy._Audit-policy-guid = SUBSTRING(BASE64-ENCODE(GENERATE-UUID), 1, 22).
    END.
    ELSE IF b_ttauditpolicy.RowMod = 'U':U THEN DO:

        /* if updating polcy,make sure policy name is not duplicate */
        ASSIGN iFound = hdl:DEFAULT-BUFFER-HANDLE:FIND-FIRST("where _Audit-policy-name = '":U +
                                                             b_ttauditpolicy._Audit-policy-name +
                                                             "' AND _Audit-policy-guid <> '":U +
                                                             b_ttauditpolicy._Audit-policy-guid + "'":U) NO-ERROR.
        IF iFound THEN
          RETURN "Policy name must me unique in the working database. Update canceled.".

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

