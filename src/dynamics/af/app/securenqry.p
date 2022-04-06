&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" Procedure _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Procedure _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*---------------------------------------------------------------------------------
  File: securenqry.p

  Description:  Security Enquiry Data Extraction

  Purpose:      Security Enquiry Data Extraction

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   05/26/2003  Author:     

  Update Notes: Created from Template rytemplipp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       securenqry.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Astra object identifying preprocessor */
&glob   AstraPlip    yes

DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.

ASSIGN cObjectName = "{&object-name}":U.

&scop   mip-notify-user-on-plip-close   NO

{src/adm2/globals.i}

/* These variables and temp-table are used to extract security groups */
DEFINE VARIABLE giOrder        AS INTEGER    NO-UNDO.
DEFINE VARIABLE giHighestLevel AS INTEGER    NO-UNDO.

DEFINE TEMP-TABLE ttSecurityGroup NO-UNDO RCODE-INFO
    FIELD security_group_desc  AS CHARACTER LABEL "Security group"     FORMAT "x(50)":U
    FIELD login_company_code   AS CHARACTER LABEL "Applies in company" FORMAT "x(50)":U
    FIELD why_desc             AS CHARACTER LABEL "How group linked"   FORMAT "x(200)"
    FIELD security_group_level AS INTEGER
    FIELD group_user_obj       AS DECIMAL
    FIELD user_obj             AS DECIMAL
    FIELD order                AS INTEGER
    INDEX idx1 group_user_obj
    INDEX idx2 order.

&GLOBAL-DEFINE GSMFFRestrictiveLevels Full Access,READ-ONLY,HIDDEN

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-insertExpression) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD insertExpression Procedure 
FUNCTION insertExpression RETURNS CHARACTER
    (pcWhere      AS CHAR,
     pcExpression AS CHAR,
     pcAndOr      AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newQueryString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD newQueryString Procedure 
FUNCTION newQueryString RETURNS CHARACTER
(pcQueryTables AS CHARACTER,
 pcColumns     AS CHARACTER,
 pcValues      AS CHARACTER,
 pcDataTypes   AS CHARACTER,
 pcOperators   AS CHARACTER,
 pcQueryString AS CHARACTER,
 pcAndOr       AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newWhereClause) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD newWhereClause Procedure 
FUNCTION newWhereClause RETURNS CHARACTER
    (pcBuffer     AS CHARACTER,
     pcExpression AS CHARACTER,
     pcWhere      AS CHARACTER,
     pcAndOr      AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-whereClauseBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD whereClauseBuffer Procedure 
FUNCTION whereClauseBuffer RETURNS CHARACTER
    (pcWhere AS CHAR) FORWARD.

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
         HEIGHT             = 19.62
         WIDTH              = 57.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  ******************************* */

{ry/app/ryplipmain.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-buildQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildQuery Procedure 
PROCEDURE buildQuery :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will build the query to return the records in a table.
               We need it mainly to cater for field, token and data range security,
               where we can't just do a simple FOR EACH:
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcFLA         AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plDataOnly    AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcBuffers     AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcQuery       AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcObjField    AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cTableName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hBuffer    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cFieldName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop      AS INTEGER    NO-UNDO.
 
  RUN getEntityTableName IN gshGenManager (INPUT pcFLA, INPUT "":U, OUTPUT cTableName).

  IF cTableName = "":U THEN 
      RETURN {aferrortxt.i 'AF' '5' '' '' "'entity (' + pcFla + ')'"}.
  
  ASSIGN pcObjField = DYNAMIC-FUNCTION("getObjField":U IN gshGenManager, INPUT pcFLA).

  IF pcObjField = "":U 
  OR pcObjField = ? THEN
      RETURN {aferrortxt.i 'AF' '11' '' '' "'table key field|entity ' + pcFla"}.

  CREATE BUFFER hBuffer FOR TABLE cTableName NO-ERROR.

  IF ERROR-STATUS:ERROR THEN
    RETURN {aferrortxt.i 'AF' '40' '' '' "'Could not create buffer for table ' + cTableName"}.

  IF plDataOnly 
  THEN DO:
      /* Data Only */
      ASSIGN pcBuffers = hBuffer:NAME
             pcQuery   = "FOR EACH ":U + hBuffer:NAME + " NO-LOCK ":U.
      IF hBuffer:NAME = "ryc_smartobject":U THEN
          ASSIGN pcQuery = pcQuery + "WHERE ryc_smartobject.container_object = TRUE ":U.
  END.
  ELSE
      /* Tokens, Fields and Data Ranges */
      ASSIGN pcBuffers = "gsm_security_structure,":U 
                       + cTableName + ",":U 
                       + "gsc_product_module,":U 
                       + "ryc_smartobject,":U
                       + "gsc_instance_attribute":U
             pcQuery   = "FOR EACH gsm_security_structure NO-LOCK ":U
                       +    "WHERE gsm_security_structure.owning_entity_mnemonic = '" + pcFLA + "', ":U
                       +    "FIRST ":U + hBuffer:NAME + " NO-LOCK ":U
                       +    "WHERE ":U + hBuffer:NAME + ".":U + pcObjField + " = gsm_security_structure.owning_obj, ":U
                       +    "FIRST gsc_product_module OUTER-JOIN NO-LOCK ":U
                       +    "WHERE gsc_product_module.product_module_obj = gsm_security_structure.product_module_obj, ":U
                       +    "FIRST ryc_smartobject OUTER-JOIN NO-LOCK ":U
                       +    "WHERE ryc_smartobject.smartobject_obj = gsm_security_structure.object_obj, ":U
                       +    "FIRST gsc_instance_attribute OUTER-JOIN NO-LOCK ":U
                       +    "WHERE gsc_instance_attribute.instance_attribute_obj = gsm_security_structure.instance_attribute_obj":U.

  /* Add a default sort on the first non _obj field of the data table */
  IF VALID-HANDLE(hBuffer) 
  THEN DO:
      DO iLoop = 1 TO hBuffer:NUM-FIELDS:
          ASSIGN cFieldName = hBuffer:BUFFER-FIELD(iLoop):NAME.
          IF  INDEX(cFieldName,"_obj":U) > 0 
          AND SUBSTRING(cFieldName,LENGTH(cFieldName) - 3,4) = "_obj":U THEN
              NEXT.
          ELSE 
              LEAVE.
      END.
      ASSIGN pcQuery = pcQuery + " BY ":U + hBuffer:NAME + ".":U + cFieldName.
  END.

  /* Clean up */
  DELETE OBJECT hBuffer NO-ERROR.
  ASSIGN hBuffer = ?
         ERROR-STATUS:ERROR = NO.
  RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-checkSecurity) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkSecurity Procedure 
PROCEDURE checkSecurity :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pdUserObj              AS DECIMAL    NO-UNDO.
    DEFINE INPUT  PARAMETER pcSecurityGroups       AS CHARACTER  NO-UNDO. /* Resolving these in here will slow this API down too much */
    DEFINE INPUT  PARAMETER pdOrganisationObj      AS DECIMAL    NO-UNDO.
    DEFINE INPUT  PARAMETER pcOwningEntityMnemonic AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER pdOwningObj            AS DECIMAL    NO-UNDO.
    DEFINE INPUT  PARAMETER plReturnValues         AS LOGICAL    NO-UNDO.
    DEFINE OUTPUT PARAMETER plSecurityRestricted   AS LOGICAL    NO-UNDO.
    DEFINE OUTPUT PARAMETER pcSecurityValue1       AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER pcSecurityValue2       AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER pcHowSecured           AS CHARACTER  NO-UNDO.

    DEFINE VARIABLE cRealEntityMnemonic AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lRevokeModel        AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE lCheckCompany       AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE lCheckAllCompanies  AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE cDispUser           AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cDispOrganisation   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cModelDesc          AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cDispName           AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE iOwningCounter      AS INTEGER   NO-UNDO.
    DEFINE VARIABLE dOwningObj          AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE iSecGroupCounter    AS INTEGER   NO-UNDO.
    DEFINE VARIABLE dSecurityGroupObj   AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE lAllocationFound    AS LOGICAL   NO-UNDO.

    DEFINE BUFFER gsm_user               FOR gsm_user.
    DEFINE BUFFER gsm_login_company      FOR gsm_login_company.
    DEFINE BUFFER gsm_security_structure FOR gsm_security_structure.
    DEFINE BUFFER gsc_security_control   FOR gsc_security_control.

    /* If we receive an owning entity mnemonic of GSMSS, we could be dealing with token, field or data range security. *
     * We need to determine which one.  Note Dynamics has been updated to pass GSMFF, GSMTO or GSMRA directly.         *
     * As customers may call this procedure and pass GSMSS, we'll run the code (ELSE below) for them.                  */
    IF CAN-DO("GSMFF,GSMTO,GSMRA":U, pcOwningEntityMnemonic) THEN
        ASSIGN cRealEntityMnemonic    = pcOwningEntityMnemonic
               pcOwningEntityMnemonic = "GSMSS":U.
    ELSE
        IF pcOwningEntityMnemonic = "GSMSS":U
        AND pdOwningObj <> 0
        THEN DO:
            FIND gsm_security_structure NO-LOCK
                 WHERE gsm_security_structure.security_structure_obj = pdOwningObj.
            ASSIGN cRealEntityMnemonic = gsm_security_structure.owning_entity_mnemonic.
        END.
        ELSE
            ASSIGN cRealEntityMnemonic = pcOwningEntityMnemonic.

    /* If no security has been set up for the security type specified:         *
     * Revoke model - Access is granted.                                       *
     * Grant model  - Access is revoked and most restrictive security applied. */
    FIND FIRST gsc_security_control NO-LOCK NO-ERROR.

    IF (AVAILABLE gsc_security_control AND gsc_security_control.full_access_by_default)
    OR NOT AVAILABLE gsc_security_control THEN
        ASSIGN lRevokeModel = YES.
    ELSE
        ASSIGN lRevokeModel = NO.

    ASSIGN plSecurityRestricted = NO /* Initialize to NO */
           pcHowSecured         = "No security allocated"
           cModelDesc           = IF lRevokeModel
                                  THEN "Revoked "
                                  ELSE "Granted ".

    /* We're going to do 2 loops here to check security allocations.                                                       *
     * Loop 1 only applies to data security, where we need to check if all records on a table have been secured.  For      *
     * these security types, a security allocation will exist with its owning_entity_mnemonic set to the FLA of the table  *
     * and its owning_obj set to 0.                                                                                        *
     * Loop 2 applies to all security types, where we will check security against a specific object (field, menu item etc) */
    owning-obj-loop:
    DO iOwningCounter = (IF CAN-DO("GSMSS,GSMMI,GSMMS,RYCSO":U, pcOwningEntityMnemonic) THEN 2 ELSE 1) TO 2:

        /* Get the login company name */
        IF pdOrganisationObj = 0 THEN
            ASSIGN cDispOrganisation = "All".
        ELSE DO:
            FIND gsm_login_company NO-LOCK
                 WHERE gsm_login_company.login_company_obj = pdOrganisationObj
                 NO-ERROR.
            ASSIGN cDispOrganisation = gsm_login_company.login_company_code WHEN AVAILABLE gsm_login_company.
        END.

        ASSIGN dOwningObj         = IF iOwningCounter = 1 THEN 0 ELSE pdOwningObj
               lCheckAllCompanies = CAN-FIND(FIRST gsm_user_allocation
                                             WHERE gsm_user_allocation.login_organisation_obj = 0
                                               AND gsm_user_allocation.owning_entity_mnemonic = pcOwningEntityMnemonic
                                               AND gsm_user_allocation.owning_obj             = dOwningObj)
               lCheckCompany      = CAN-FIND(FIRST gsm_user_allocation
                                             WHERE gsm_user_allocation.login_organisation_obj = pdOrganisationObj
                                               AND gsm_user_allocation.owning_entity_mnemonic = pcOwningEntityMnemonic
                                               AND gsm_user_allocation.owning_obj             = dOwningObj).
        IF lCheckAllCompanies = YES
        OR lCheckCompany      = YES
        THEN DO:
            /* Check security allocations against the user first */
            IF lCheckCompany
            AND CAN-FIND(FIRST gsm_user_allocation
                         WHERE gsm_user_allocation.user_obj               = pdUserObj
                           AND gsm_user_allocation.login_organisation_obj = pdOrganisationObj
                           AND gsm_user_allocation.owning_entity_mnemonic = pcOwningEntityMnemonic
                           AND gsm_user_allocation.owning_obj             = dOwningObj) 
            THEN DO:
                FIND gsm_user NO-LOCK
                     WHERE gsm_user.user_obj = pdUserObj
                     NO-ERROR.

                ASSIGN pcHowSecured = cModelDesc
                                    + (IF pdUserObj <> 0
                                       THEN (IF gsm_user.security_group
                                             THEN "against security group for company: "
                                             ELSE "at user level for company: ")
                                       ELSE "for all users for company: ")
                                    + cDispOrganisation.

                FIND FIRST gsm_user_allocation NO-LOCK
                     WHERE gsm_user_allocation.user_obj               = pdUserObj
                       AND gsm_user_allocation.login_organisation_obj = pdOrganisationObj
                       AND gsm_user_allocation.owning_entity_mnemonic = pcOwningEntityMnemonic
                       AND gsm_user_allocation.owning_obj             = dOwningObj.

                IF plReturnValues = NO
                THEN DO:
                    /* For backward compatibility, we support allocations with no YES or NO allocated in user_allocation_value1.         *
                     * However, in the new security model a YES or NO will be stored to indicate if the object is secured at user level. */
                    IF gsm_user_allocation.user_allocation_value1 = "":U THEN
                        ASSIGN plSecurityRestricted = lRevokeModel.
                    ELSE
                        ASSIGN plSecurityRestricted = (gsm_user_allocation.user_allocation_value1 <> "NO":U)
                               pcHowSecured         = REPLACE(pcHowSecured, cModelDesc, "Secured ").
                    RETURN.
                END.
                ELSE DO:
                    ASSIGN plSecurityRestricted = YES
                           pcSecurityValue1     = gsm_user_allocation.user_allocation_value1
                           pcSecurityValue2     = gsm_user_allocation.user_allocation_value2.
                    RETURN.
                END.
            END.

            /* This user, all companies */
            IF lCheckAllCompanies
            AND CAN-FIND(FIRST gsm_user_allocation
                         WHERE gsm_user_allocation.user_obj               = pdUserObj
                           AND gsm_user_allocation.login_organisation_obj = 0
                           AND gsm_user_allocation.owning_entity_mnemonic = pcOwningEntityMnemonic
                           AND gsm_user_allocation.owning_obj             = dOwningObj) 
            THEN DO:
                FIND gsm_user NO-LOCK
                     WHERE gsm_user.user_obj = pdUserObj
                     NO-ERROR.

                ASSIGN pcHowSecured = cModelDesc 
                                    + IF pdUserObj <> 0
                                      THEN (IF gsm_user.security_group
                                            THEN "against security group for all companies"
                                            ELSE "at user level for all companies")                                         
                                      ELSE "for all users for all companies".

                FIND FIRST gsm_user_allocation NO-LOCK
                     WHERE gsm_user_allocation.user_obj               = pdUserObj
                       AND gsm_user_allocation.login_organisation_obj = 0
                       AND gsm_user_allocation.owning_entity_mnemonic = pcOwningEntityMnemonic
                       AND gsm_user_allocation.owning_obj             = dOwningObj.

                IF plReturnValues = NO
                THEN DO:
                    /* For backward compatibility, we support allocations with no YES or NO allocated in user_allocation_value1.         *
                     * However, in the new security model a YES or NO will be stored to indicate if the object is secured at user level. */
                    IF gsm_user_allocation.user_allocation_value1 = "":U THEN
                        ASSIGN plSecurityRestricted = lRevokeModel.
                    ELSE
                        ASSIGN plSecurityRestricted = (gsm_user_allocation.user_allocation_value1 <> "NO":U)
                               pcHowSecured         = REPLACE(pcHowSecured, cModelDesc, "Secured ").
                    RETURN.
                END.
                ELSE DO:
                    ASSIGN plSecurityRestricted = YES
                           pcSecurityValue1     = gsm_user_allocation.user_allocation_value1
                           pcSecurityValue2     = gsm_user_allocation.user_allocation_value2.
                    RETURN.
                END.
            END.

            /* When we get here, we know we couldn't find any allocations against the user, so we start checking     *
             * against his security groups.                                                                          *
             *                                                                                                       *
             * We'll do the following:                                                                               *
             * GRANT model  - As soon as a security allocation can be found, access is granted.  Where we return     *
             *                values, we keep on checking allocations till we find the least restrictive security.   *
             * REVOKE model - Where we don't return values security needs to be revoked in every group the user      *
             *                belongs to.  As soon as we find a group with no security allocations, the user gets    *
             *                access.                                                                                *
             *                Where we return values we keep on checking till we get the least restrictive security. *
             */
            IF pcSecurityGroups <> "":U
            THEN DO:
                ASSIGN pcHowSecured = "":U.

                do-blk:
                DO iSecGroupCounter = 1 TO NUM-ENTRIES(pcSecurityGroups, CHR(4)):

                    ASSIGN dSecurityGroupObj = DECIMAL(ENTRY(iSecGroupCounter, pcSecurityGroups, CHR(4))).

                    /* Get the user name and login company name */
                    FIND gsm_user NO-LOCK
                         WHERE gsm_user.user_obj = dSecurityGroupObj
                         NO-ERROR.

                    ASSIGN lAllocationFound = NO
                           cDispName = gsm_user.user_login_name WHEN AVAILABLE gsm_user.

                    /* Check security allocations against the security group */
                    IF lCheckCompany
                    AND CAN-FIND(FIRST gsm_user_allocation
                                 WHERE gsm_user_allocation.user_obj               = dSecurityGroupObj
                                   AND gsm_user_allocation.login_organisation_obj = pdOrganisationObj
                                   AND gsm_user_allocation.owning_entity_mnemonic = pcOwningEntityMnemonic
                                   AND gsm_user_allocation.owning_obj             = dOwningObj) 
                    THEN DO:
                        ASSIGN lAllocationFound = YES. /* This does NOT necessarily mean plSecurityRestricted = YES */

                        IF plReturnValues = NO
                        THEN DO:
                            ASSIGN plSecurityRestricted = lRevokeModel. /* In a revoke model, secured = YES.  In a grant model, secured = NO */

                            /* In a grant model, the user gets access as soon as we find an allocation.        *
                             * In a revoke model, we're going to keep on checking to make sure access has been *
                             * revoked in all the security groups the user belongs to.                         */
                            IF NOT lRevokeModel 
                            THEN DO:
                                ASSIGN pcHowSecured = "Granted group " + cDispName + ", company " + cDispOrganisation.
                                RETURN.
                            END.
                            ELSE
                                ASSIGN pcHowSecured = pcHowSecured + "(Revoked group " + cDispName + ", company " + cDispOrganisation + ")":U + CHR(4).
                        END.
                        ELSE DO:
                            ASSIGN plSecurityRestricted = YES.

                            FIND FIRST gsm_user_allocation NO-LOCK
                                 WHERE gsm_user_allocation.user_obj               = dSecurityGroupObj
                                   AND gsm_user_allocation.login_organisation_obj = pdOrganisationObj
                                   AND gsm_user_allocation.owning_entity_mnemonic = pcOwningEntityMnemonic
                                   AND gsm_user_allocation.owning_obj             = dOwningObj.

                            /* Is this least restrictive access? */
                            CASE cRealEntityMnemonic:
                                WHEN "GSMFF":U
                                THEN DO:
                                    IF pcSecurityValue1 = "":U
                                    OR LOOKUP(gsm_user_allocation.user_allocation_value1, "{&GSMFFRestrictiveLevels}":U) < LOOKUP(pcSecurityValue1, "{&GSMFFRestrictiveLevels}":U) THEN
                                        ASSIGN pcSecurityValue1 = gsm_user_allocation.user_allocation_value1
                                               pcHowSecured     = pcHowSecured + "(Group " + cDispName + ", Company " + cDispOrganisation + ": " + CAPS(pcSecurityValue1) + ")" + CHR(4).

                                    /* If we've hit least restrictive access, return. */
                                    IF pcSecurityValue1 = ENTRY(1, "{&GSMFFRestrictiveLevels}":U) THEN RETURN.
                                END.
                                WHEN "GSMRA":U THEN
                                    ASSIGN pcSecurityValue1 = pcSecurityValue1 + gsm_user_allocation.user_allocation_value1 + CHR(3)
                                           pcSecurityValue2 = pcSecurityValue2 + gsm_user_allocation.user_allocation_value2 + CHR(3)
                                           pcHowSecured     = pcHowSecured + "(Group " + cDispName + ", Company " + cDispOrganisation + ": " + gsm_user_allocation.user_allocation_value1 + " to " + gsm_user_allocation.user_allocation_value2 + ")":U + CHR(4).
                            END CASE.
                        END.
                    END.

                    IF lCheckAllCompanies
                    AND NOT lAllocationFound /* If we could find security applicable to this security group and the login company, use it.  If not, check against all companies (below). */
                    AND CAN-FIND(FIRST gsm_user_allocation
                                 WHERE gsm_user_allocation.user_obj               = dSecurityGroupObj
                                   AND gsm_user_allocation.login_organisation_obj = 0
                                   AND gsm_user_allocation.owning_entity_mnemonic = pcOwningEntityMnemonic
                                   AND gsm_user_allocation.owning_obj             = dOwningObj) 
                    THEN DO:
                        ASSIGN lAllocationFound = YES. /* This does NOT necessarily mean plSecurityRestricted = YES */

                        IF plReturnValues = NO
                        THEN DO:
                            ASSIGN plSecurityRestricted = lRevokeModel. /* In a revoke model, secured = YES.  In a grant model, secured = NO */

                            /* In a grant model, the user gets access as soon as we find an allocation.        *
                             * In a revoke model, we're going to keep on checking to make sure access has been *
                             * revoked in all the security groups the user belongs to.                         */
                            IF NOT lRevokeModel 
                            THEN DO:
                                ASSIGN pcHowSecured = "Granted group " + cDispName + ", all companies".
                                RETURN.
                            END.                          
                            ELSE
                                ASSIGN pcHowSecured = pcHowSecured + "(Revoked group " + cDispName + ", all companies)":U + CHR(4).
                        END.
                        ELSE DO:
                            ASSIGN plSecurityRestricted = YES.

                            FIND FIRST gsm_user_allocation NO-LOCK
                                 WHERE gsm_user_allocation.user_obj               = dSecurityGroupObj
                                   AND gsm_user_allocation.login_organisation_obj = 0
                                   AND gsm_user_allocation.owning_entity_mnemonic = pcOwningEntityMnemonic
                                   AND gsm_user_allocation.owning_obj             = dOwningObj.

                            /* Is this least restrictive access? */
                            CASE cRealEntityMnemonic:
                                WHEN "GSMFF":U
                                THEN DO:
                                    IF pcSecurityValue1 = "":U
                                    OR LOOKUP(gsm_user_allocation.user_allocation_value1, "{&GSMFFRestrictiveLevels}":U) < LOOKUP(pcSecurityValue1, "{&GSMFFRestrictiveLevels}":U) THEN
                                        ASSIGN pcSecurityValue1 = gsm_user_allocation.user_allocation_value1
                                               pcHowSecured     = pcHowSecured + "(Group " + cDispName + ", all companies: " + CAPS(pcSecurityValue1) + ")":U + CHR(4).

                                    IF pcSecurityValue1 = ENTRY(1, "{&GSMFFRestrictiveLevels}":U) THEN RETURN.
                                END.
                                WHEN "GSMRA":U THEN
                                    ASSIGN pcSecurityValue1 = pcSecurityValue1 + gsm_user_allocation.user_allocation_value1 + CHR(3)
                                           pcSecurityValue2 = pcSecurityValue2 + gsm_user_allocation.user_allocation_value2 + CHR(3)
                                           pcHowSecured     = pcHowSecured + "(Group " + cDispName + ", all companies: " + gsm_user_allocation.user_allocation_value1 + " to " + gsm_user_allocation.user_allocation_value2 + ")":U + CHR(4).
                            END CASE.
                        END.
                    END.

                    /* In a revoke model, the object has to be secured in every security group the user belongs to. If not, the object is not secured. */
                    IF NOT lAllocationFound
                    AND lRevokeModel
                    THEN DO:
                        ASSIGN plSecurityRestricted = NO
                               pcSecurityValue1     = "":U
                               pcSecurityValue2     = "":U
                               pcHowSecured         = "Not revoked group " + cDispName.
                        LEAVE do-blk.
                    END.
                END.
            END.

            /* If the object has been secured in the security groups the user belongs to, we return.              *
             * The return values will have been set above (if applicable).                                        *
             * Remember, we would have kept on looping...                                                         *
             * 1) To find the security group with least restrictive access when we return values.                 *
             * 2) In a revoke model, we'd have to make sure the object had been revoked in all security groups.   *
             * ...which is why we only RETURN here and not immediately when we found security allocations.        *
             *                                                                                                    *
             * We would have returned immediately:                                                                *
             * 1) when not returning values and we found an allocation in a grant model.                          *
             * 2) when not returning values and we could not find an allocation in a revoke model (the object has *
             *    not been revoked in every security group the user belongs to).                                  */
            IF plSecurityRestricted = YES THEN
                RETURN.

            /* Last, we check for allocations against all users. We only do this if we couldn't find user specific security, *
             * IOW security set up against the user or his groups specifically.                                              */
            IF lCheckCompany
            AND CAN-FIND(FIRST gsm_user_allocation
                         WHERE gsm_user_allocation.user_obj               = 0
                           AND gsm_user_allocation.login_organisation_obj = pdOrganisationObj
                           AND gsm_user_allocation.owning_entity_mnemonic = pcOwningEntityMnemonic
                           AND gsm_user_allocation.owning_obj             = dOwningObj) 
            THEN DO:
                ASSIGN pcHowSecured = cModelDesc + "all users for company: " + cDispOrganisation.

                IF plReturnValues = NO
                THEN DO:
                    ASSIGN plSecurityRestricted = lRevokeModel. /* Revoke model, plSecurityRestricted = YES. Grant model, plSecurityRestricted = NO */
                    RETURN.
                END.
                ELSE DO:
                    FIND FIRST gsm_user_allocation NO-LOCK
                         WHERE gsm_user_allocation.user_obj               = 0
                           AND gsm_user_allocation.login_organisation_obj = pdOrganisationObj
                           AND gsm_user_allocation.owning_entity_mnemonic = pcOwningEntityMnemonic
                           AND gsm_user_allocation.owning_obj             = dOwningObj.

                    ASSIGN plSecurityRestricted = YES
                           pcSecurityValue1     = gsm_user_allocation.user_allocation_value1
                           pcSecurityValue2     = gsm_user_allocation.user_allocation_value2.
                    RETURN.
                END.
            END.

            /* This user, all companies */
            IF lCheckAllCompanies
            AND CAN-FIND(FIRST gsm_user_allocation
                         WHERE gsm_user_allocation.user_obj               = 0
                           AND gsm_user_allocation.login_organisation_obj = 0
                           AND gsm_user_allocation.owning_entity_mnemonic = pcOwningEntityMnemonic
                           AND gsm_user_allocation.owning_obj             = dOwningObj) 
            THEN DO:
                ASSIGN pcHowSecured = cModelDesc + "all users for all companies".

                IF plReturnValues = NO
                THEN DO:
                    ASSIGN plSecurityRestricted = lRevokeModel. /* Revoke model, plSecurityRestricted = YES. Grant model, plSecurityRestricted = NO */
                    RETURN.
                END.
                ELSE DO:
                    FIND FIRST gsm_user_allocation NO-LOCK
                         WHERE gsm_user_allocation.user_obj               = 0
                           AND gsm_user_allocation.login_organisation_obj = 0
                           AND gsm_user_allocation.owning_entity_mnemonic = pcOwningEntityMnemonic
                           AND gsm_user_allocation.owning_obj             = dOwningObj.

                    ASSIGN plSecurityRestricted = YES
                           pcSecurityValue1     = gsm_user_allocation.user_allocation_value1
                           pcSecurityValue2     = gsm_user_allocation.user_allocation_value2.
                    RETURN.
                END.
            END.
        END.
    END.

    /* If we get here, we couldn't find security applicable to all (owning obj = 0) or to the specific object (owning obj = pdOwningObj) *
     * In a grant model, this means we couldn't find anywhere where security was granted.  In a revoke model, we couldn't find anywhere  *
     * where security was revoked.  This is why we assign plSecurityRestricted to NOT lRevokeModel.                                      */
    ASSIGN plSecurityRestricted = NOT lRevokeModel.
    IF NOT lRevokeModel THEN
        ASSIGN pcHowSecured = "Access not granted anywhere".

    /* In a grant model, apply most restrictive security.  In a revoke model, the object is not secured. */
    IF plReturnValues = YES AND NOT lRevokeModel AND cRealEntityMnemonic = "GSMFF":U THEN
        ASSIGN pcSecurityValue1     = ENTRY(NUM-ENTRIES("{&GSMFFRestrictiveLevels}":U),"{&GSMFFRestrictiveLevels}":U)
               pcSecurityValue2     = "":U.

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createTempTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createTempTable Procedure 
PROCEDURE createTempTable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phDataTable AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER plDataOnly  AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pcObjField  AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER phTempTable AS HANDLE     NO-UNDO.

  DEFINE VARIABLE iFieldLoop   AS INTEGER NO-UNDO.
  DEFINE VARIABLE lRevokeModel AS LOGICAL NO-UNDO.
  DEFINE VARIABLE hField       AS HANDLE  NO-UNDO.

  IF NOT VALID-HANDLE(phDataTable) THEN
    RETURN.

  CREATE TEMP-TABLE phTempTable.

  /* We need to know if we're working with a grant or revoke model */
  FIND FIRST gsc_security_control NO-LOCK NO-ERROR.

  IF (AVAILABLE gsc_security_control AND gsc_security_control.full_access_by_default)
  OR NOT AVAILABLE gsc_security_control THEN
      ASSIGN lRevokeModel = YES.
  ELSE
      ASSIGN lRevokeModel = NO.

  /* Add all the fields on the table to the temp-table */
  do-blk:
  DO iFieldLoop = 1 TO phDataTable:NUM-FIELDS:
      phTempTable:ADD-LIKE-FIELD(phDataTable:BUFFER-FIELD(iFieldLoop):TABLE + "__":U + phDataTable:BUFFER-FIELD(iFieldLoop):NAME,phDataTable:BUFFER-FIELD(iFieldLoop)).
  END.

  IF plDataOnly 
  THEN DO:
      phTempTable:ADD-NEW-INDEX("Idx1",FALSE,TRUE).
      phTempTable:ADD-INDEX-FIELD("Idx1":U,phDataTable:NAME + "__":U + pcObjField).
  END.
  ELSE DO:
      phTempTable:ADD-NEW-FIELD("dSecurity_structure_obj":U,"DECIMAL").
      phTempTable:ADD-NEW-FIELD("cProdMod":U     ,"CHARACTER":U,0,"X(30)":U,"":U,"Product module":U).
      phTempTable:ADD-NEW-FIELD("cObject":U      ,"CHARACTER":U,0,"X(30)":U,"":U,"Object filename":U).
      phTempTable:ADD-NEW-FIELD("cInstanceAttr":U,"CHARACTER":U,0,"X(30)":U,"":U,"Instance attribute":U).
      phTempTable:ADD-NEW-INDEX("Idx1",FALSE,TRUE).
      phTempTable:ADD-INDEX-FIELD("Idx1":U,"dSecurity_structure_obj":U).
  END.

  /* Add any extra fields to store additional security info. */
  phTempTable:ADD-NEW-FIELD("lSecured":U,"LOGICAL":U,0,"Yes/No","":U,"Secured").
  phTempTable:ADD-NEW-FIELD("cHowSecured", "CHARACTER":U,0,"x(250)":U,"":U,"Reason").

  CASE phDataTable:NAME:
      WHEN "gsm_field":U THEN
          phTempTable:ADD-NEW-FIELD("cValue1":U,"CHARACTER":U,0,"X(30)":U,"":U,"Security Type":U).

      WHEN "gsm_range":U 
      THEN DO:
          phTempTable:ADD-NEW-FIELD("cValue1":U,"CHARACTER":U,0,"X(70)":U,"":U,"From Value":U).
          phTempTable:ADD-NEW-FIELD("cValue2":U,  "CHARACTER":U,0,"X(70)":U,"":U,"To Value":U).
      END.
  END CASE.

  phTempTable:TEMP-TABLE-PREPARE("SecurityData":U).
  phTempTable:PRIVATE-DATA = phDataTable:NAME.

  /* Tokens have been renamed "actions".  Make sure our labels are correct. */
  IF phDataTable:NAME = "gsm_token":U
  THEN do-blk: DO iFieldLoop = 1 TO phTempTable:DEFAULT-BUFFER-HANDLE:NUM-FIELDS:
      ASSIGN hField              = phTempTable:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(iFieldLoop)
             hField:LABEL        = REPLACE(hField:LABEL, "token":U, "action":U)
             hField:LABEL        = CAPS(SUBSTRING(hField:LABEL,1,1)) + LC(SUBSTRING(hField:LABEL,2))
             hField:COLUMN-LABEL = hField:LABEL.
  END.

  ASSIGN ERROR-STATUS:ERROR = NO.
  RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getData Procedure 
PROCEDURE getData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcFla             AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pdUserObj         AS DECIMAL    NO-UNDO.
DEFINE INPUT  PARAMETER pdOrganisationObj AS DECIMAL    NO-UNDO.
DEFINE INPUT  PARAMETER pcFilterValues    AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phDataTT.

DEFINE VARIABLE cBuffers         AS CHARACTER NO-UNDO.
DEFINE VARIABLE cQuery           AS CHARACTER NO-UNDO.
DEFINE VARIABLE cObjField        AS CHARACTER NO-UNDO.
DEFINE VARIABLE lDataOnly        AS LOGICAL   NO-UNDO.
DEFINE VARIABLE hQuery           AS HANDLE    NO-UNDO.
DEFINE VARIABLE iLoop            AS INTEGER   NO-UNDO.
DEFINE VARIABLE hBuffer          AS HANDLE    NO-UNDO EXTENT 6.
DEFINE VARIABLE hDataTableBuffer AS HANDLE    NO-UNDO.
DEFINE VARIABLE cFieldName       AS CHARACTER  NO-UNDO.

DEFINE VARIABLE iDataTableIndex       AS INTEGER   NO-UNDO.
DEFINE VARIABLE iProdModTableIndex    AS INTEGER   NO-UNDO.
DEFINE VARIABLE iAllocationTableIndex AS INTEGER   NO-UNDO.
DEFINE VARIABLE iAvailableTableIndex  AS INTEGER   NO-UNDO.
DEFINE VARIABLE cSecurityGroups       AS CHARACTER NO-UNDO.
DEFINE VARIABLE lRestricted           AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cValue1               AS CHARACTER NO-UNDO.
DEFINE VARIABLE cValue2               AS CHARACTER NO-UNDO.
DEFINE VARIABLE cHowSecured           AS CHARACTER  NO-UNDO.

ASSIGN lDataOnly = NOT CAN-DO("GSMFF,GSMTO,GSMRA":U, pcFla).

/* First thing we do is get all the information we're going to need to build the query */
RUN buildQuery (INPUT pcFla,
                INPUT lDataOnly,
                OUTPUT cBuffers,
                OUTPUT cQuery,
                OUTPUT cObjField).
IF RETURN-VALUE <> "":U THEN
    RETURN ERROR RETURN-VALUE.

/* Apply Extra filtering */
IF pcFilterValues <> "":U THEN
    ASSIGN cQuery = DYNAMIC-FUNCTION('newQueryString':U IN TARGET-PROCEDURE,
                                     INPUT cBuffers,
                                     INPUT ENTRY(1,pcFilterValues,CHR(4)),
                                     INPUT ENTRY(2,pcFilterValues,CHR(4)),
                                     INPUT ENTRY(3,pcFilterValues,CHR(4)),
                                     INPUT ENTRY(4,pcFilterValues,CHR(4)),
                                     INPUT cQuery,
                                     INPUT ?).

/* Set flags depending on whether we're checking data, or token, field or range security which work differently */
IF lDataOnly THEN
    ASSIGN iDataTableIndex    = 1
           iProdModTableIndex = 0.
ELSE
    ASSIGN iDataTableIndex    = 2
           iProdModTableIndex = 3.

ASSIGN iAllocationTableIndex = 0
       iAvailableTableIndex  = iDataTableIndex.

/* Create and open our query */
CREATE QUERY hQuery.
DO iLoop = 1 TO NUM-ENTRIES(cBuffers):
    CREATE BUFFER hBuffer[iLoop] FOR TABLE ENTRY(iLoop,cBuffers).
    hQuery:ADD-BUFFER(hBuffer[iLoop]).
END.

hQuery:QUERY-PREPARE(cQuery) NO-ERROR.
IF ERROR-STATUS:ERROR THEN 
    RETURN ERROR {aferrortxt.i 'AF' '40' '' '' "'Query could not be opened with phrase: ' + CHR(10) + cQuery"}.

hQuery:QUERY-OPEN().
hQuery:GET-FIRST().

/* Create our temp-table based on our query */
RUN createTempTable (INPUT hBuffer[iDataTableIndex],
                     INPUT lDataOnly,
                     INPUT cObjField,
                     OUTPUT phDataTT).
ASSIGN hDataTableBuffer = phDataTT:DEFAULT-BUFFER-HANDLE.

/* Before we start processing, determine which security groups apply to this user. */
ASSIGN cSecurityGroups = "":U.
RUN getSecurityGroups IN gshSecurityManager (INPUT pdUserObj,
                                             INPUT pdOrganisationObj,
                                             INPUT YES, /* Groups with security only */
                                             INPUT YES, /* Return Obj Field? */
                                             INPUT-OUTPUT cSecurityGroups).
ASSIGN cSecurityGroups = RIGHT-TRIM(cSecurityGroups, CHR(4)) NO-ERROR.

/* Now populate our temp-table */
DO WHILE hBuffer[iAvailableTableIndex]:AVAILABLE:

    hDataTableBuffer:BUFFER-CREATE().
    DO iLoop = 1 TO hBuffer[iDataTableIndex]:NUM-FIELDS:
        ASSIGN hDataTableBuffer:BUFFER-FIELD(iLoop):BUFFER-VALUE = hBuffer[iDataTableIndex]:BUFFER-FIELD(iLoop):BUFFER-VALUE.
    END.

    /* We need to add Product Module and Objects - where applicable */
    IF NOT lDataOnly 
    THEN DO:
        /* Security structure obj */
        ASSIGN hDataTableBuffer:BUFFER-FIELD("dSecurity_structure_obj":U):BUFFER-VALUE = IF hBuffer[1]:AVAILABLE 
                                                                                         THEN hBuffer[1]:BUFFER-FIELD("security_structure_obj":U):BUFFER-VALUE
                                                                                         ELSE "0":U.
        /* Product Module */
        ASSIGN hDataTableBuffer:BUFFER-FIELD("cProdMod":U):BUFFER-VALUE = IF hBuffer[iProdModTableIndex]:AVAILABLE
                                                                          THEN hBuffer[iProdModTableIndex]:BUFFER-FIELD("product_module_code":U):BUFFER-VALUE
                                                                          ELSE "All":U.
        /* Smart Object */
        ASSIGN hDataTableBuffer:BUFFER-FIELD("cObject":U):BUFFER-VALUE = IF hBuffer[iProdModTableIndex + 1]:AVAILABLE
                                                                         THEN hBuffer[iProdModTableIndex + 1]:BUFFER-FIELD("object_filename":U):BUFFER-VALUE
                                                                         ELSE "All":U.
        /* Instance Attribute */
        ASSIGN hDataTableBuffer:BUFFER-FIELD("cInstanceAttr":U):BUFFER-VALUE = IF hBuffer[iProdModTableIndex + 2]:AVAILABLE
                                                                               THEN hBuffer[iProdModTableIndex + 2]:BUFFER-FIELD("attribute_code":U):BUFFER-VALUE
                                                                               ELSE "All":U.
    END.

    /* While we're here, check if this object is secured and how */
    RUN checkSecurity IN TARGET-PROCEDURE (INPUT pdUserObj,
                                           INPUT cSecurityGroups,
                                           INPUT pdOrganisationObj,
                                           INPUT pcFla,
                                           INPUT IF NOT lDataOnly 
                                                 THEN hDataTableBuffer:BUFFER-FIELD("dSecurity_structure_obj":U):BUFFER-VALUE
                                                 ELSE hBuffer[iDataTableIndex]:BUFFER-FIELD(cObjField):BUFFER-VALUE,
                                           INPUT pcFla = "GSMFF":U OR pcFla = "GSMRA":U,
                                           OUTPUT lRestricted,
                                           OUTPUT cValue1,
                                           OUTPUT cValue2,
                                           OUTPUT cHowSecured).

    /* Now update the security fields on the temp-table */
    ASSIGN hDataTableBuffer:BUFFER-FIELD("lSecured":U):BUFFER-VALUE    = lRestricted
           hDataTableBuffer:BUFFER-FIELD("cHowSecured":U):BUFFER-VALUE = cHowSecured.
    ASSIGN hDataTableBuffer:BUFFER-FIELD("cValue1":U):BUFFER-VALUE = cValue1 NO-ERROR.
    ASSIGN hDataTableBuffer:BUFFER-FIELD("cValue2":U):BUFFER-VALUE = cValue2 NO-ERROR.

    hQuery:GET-NEXT().
END.

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSecurityGroups) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSecurityGroups Procedure 
PROCEDURE getSecurityGroups :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pdUserObj         AS DECIMAL  NO-UNDO.
DEFINE INPUT  PARAMETER pdOrganisationObj AS DECIMAL  NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phDataTT.

DEFINE VARIABLE cHowLinked AS CHARACTER  NO-UNDO.

FIND gsm_user NO-LOCK
     WHERE gsm_user.user_obj = pdUserObj
     NO-ERROR.

IF AVAILABLE gsm_user THEN
    ASSIGN cHowLinked = gsm_user.user_login_name + " -> ":U.

EMPTY TEMP-TABLE ttSecurityGroup NO-ERROR.
ASSIGN giOrder = 0.

RUN recursiveGroupFetch IN TARGET-PROCEDURE (INPUT pdUserObj,
                                             INPUT pdOrganisationObj,
                                             INPUT 1,
                                             INPUT-OUTPUT cHowLinked). /* Security group level */

ASSIGN phDataTT = TEMP-TABLE ttSecurityGroup:HANDLE
       giOrder  = 0.

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-killPlip) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE killPlip Procedure 
PROCEDURE killPlip :
/*------------------------------------------------------------------------------
  Purpose:     entry point to instantly kill the plip if it should get lost in memory
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{ry/app/ryplipkill.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-objectDescription) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE objectDescription Procedure 
PROCEDURE objectDescription :
/*------------------------------------------------------------------------------
  Purpose:     Pass out a description of the PLIP, used in Plip temp-table
  Parameters:  <none>
  Notes:       This should be changed manually for each plip
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER cDescription AS CHARACTER NO-UNDO.

ASSIGN cDescription = "Dynamics Template PLIP".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipSetup) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipSetup Procedure 
PROCEDURE plipSetup :
/*------------------------------------------------------------------------------
  Purpose:    Run by main-block of PLIP at startup of PLIP
  Parameters: <none>
  Notes:       
------------------------------------------------------------------------------*/

{ry/app/ryplipsetu.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipShutdown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipShutdown Procedure 
PROCEDURE plipShutdown :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will be run just before the calling program 
               terminates
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{ry/app/ryplipshut.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-recursiveGroupFetch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recursiveGroupFetch Procedure 
PROCEDURE recursiveGroupFetch :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT        PARAMETER pdUserObj         AS DECIMAL    NO-UNDO.
DEFINE INPUT        PARAMETER pdLoginCompanyObj AS DECIMAL    NO-UNDO.
DEFINE INPUT        PARAMETER piLevel           AS INTEGER    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pcHowLinked AS CHARACTER  NO-UNDO.

DEFINE BUFFER gsm_user          FOR gsm_user.
DEFINE BUFFER gsm_login_company FOR gsm_login_company.

DEFINE VARIABLE cLoginCompany      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cGroup             AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cOriginalHowLinked AS CHARACTER  NO-UNDO.

IF piLevel > giHighestLevel THEN
    ASSIGN giHighestLevel = piLevel.

ASSIGN cOriginalHowLinked = pcHowLinked.

fe-blk:
FOR EACH gsm_group_allocation NO-LOCK
   WHERE gsm_group_allocation.user_obj = pdUserObj:

    IF pdLoginCompanyObj = 0
    OR gsm_group_allocation.login_company_obj = 0 /* Security group applies to all companies */
    OR gsm_group_allocation.login_company_obj = pdLoginCompanyObj /* Security group applies to this company */
    THEN DO:
        IF NOT CAN-FIND(FIRST ttSecurityGroup
                        WHERE ttSecurityGroup.group_user_obj = gsm_group_allocation.group_user_obj) 
        THEN DO:
            FIND gsm_user NO-LOCK
                 WHERE gsm_user.user_obj = gsm_group_allocation.group_user_obj
                 NO-ERROR.

            ASSIGN cGroup      = gsm_user.user_login_name
                   pcHowLinked = cOriginalHowLinked + cGroup + " -> ":U.

            IF gsm_group_allocation.login_company_obj <> 0 
            THEN DO:
                FIND gsm_login_company NO-LOCK
                     WHERE gsm_login_company.login_company_obj = gsm_group_allocation.login_company_obj
                     NO-ERROR.

                ASSIGN cLoginCompany = IF AVAILABLE gsm_login_company
                                       THEN gsm_login_company.login_company_code + "(":U + gsm_login_company.login_company_name + ")":U
                                       ELSE "ERROR - Invalid Company".
            END.
            ELSE
                ASSIGN cLoginCompany = "All Companies":U.

            CREATE ttSecurityGroup.
            ASSIGN giOrder                              = giOrder + 1
                   ttSecurityGroup.security_group_desc  = cGroup
                   ttSecurityGroup.login_company_code   = cLoginCompany
                   ttSecurityGroup.security_group_level = piLevel
                   ttSecurityGroup.group_user_obj       = gsm_group_allocation.group_user_obj
                   ttSecurityGroup.user_obj             = gsm_group_allocation.user_obj
                   ttSecurityGroup.order                = giOrder
                   ttSecurityGroup.why_desc             = RIGHT-TRIM(pcHowLinked, " -> ":U).

            /* Now get any groups assigned to this security group */
            RUN recursiveGroupFetch IN TARGET-PROCEDURE (INPUT gsm_group_allocation.group_user_obj,
                                                         INPUT pdLoginCompanyObj,
                                                         INPUT piLevel + 1,
                                                         INPUT-OUTPUT pcHowLinked).
        END.
    END.
END.

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-insertExpression) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION insertExpression Procedure 
FUNCTION insertExpression RETURNS CHARACTER
    (pcWhere      AS CHAR,
     pcExpression AS CHAR,
     pcAndOr      AS CHAR):
  /*------------------------------------------------------------------------------
   Purpose:     Inserts an expression into ONE buffer's where-clause.
   Parameters:
        pcWhere      - Complete where clause with or without the FOR keyword,
                       but without any comma before or after.
        pcExpression - New expression OR OF phrase (Existing OF phrase is replaced)
        pcAndOr      - Specifies what operator is used to add the new expression
                       to existing ones.
                       - AND (default)
                       - OR
   Notes:       The new expression is embedded in parenthesis, but no parentheses
                are placed around the existing one.
                Lock keywords must be unabbreviated or without -lock (i.e. SHARE
                or EXCLUSIVE.)
                Any keyword in comments may cause problems.
                This is PRIVATE to query.p.
  ------------------------------------------------------------------------------*/
    DEFINE VARIABLE cTable        AS CHAR NO-UNDO.
    DEFINE VARIABLE cRelTable     AS CHAR NO-UNDO.
    DEFINE VARIABLE cJoinTable    AS CHAR NO-UNDO.
    DEFINE VARIABLE cWhereOrAnd   AS CHAR NO-UNDO.
    DEFINE VARIABLE iTblPos       AS INT  NO-UNDO.
    DEFINE VARIABLE iWherePos     AS INT  NO-UNDO.
    DEFINE VARIABLE lWhere        AS LOG  NO-UNDO.
    DEFINE VARIABLE iOfPos        AS INT  NO-UNDO.
    DEFINE VARIABLE iRelTblPos    AS INT  NO-UNDO.
    DEFINE VARIABLE iInsertPos    AS INT  NO-UNDO.

    DEFINE VARIABLE iUseIdxPos    AS INT  NO-UNDO.
    DEFINE VARIABLE iOuterPos     AS INT  NO-UNDO.
    DEFINE VARIABLE iLockPos      AS INT  NO-UNDO.

    DEFINE VARIABLE iByPos        AS INT  NO-UNDO.
    DEFINE VARIABLE iIdxRePos     AS INT  NO-UNDO.

    ASSIGN
      cTable        = whereClauseBuffer(pcWhere)
      iTblPos       = INDEX(pcWhere,cTable) + LENGTH(cTable,"CHARACTER":U)

      iWherePos     = INDEX(pcWhere," WHERE ":U) + 6
      iByPos        = INDEX(pcWhere," BY ":U)
      iUseIdxPos    = INDEX(pcWhere," USE-INDEX ":U)
      iIdxRePos     = INDEX(pcWhere + " ":U," INDEXED-REPOSITION ":U)
      iOuterPos     = INDEX(pcWhere + " ":U," OUTER-JOIN ":U)
      iLockPos      = MAX(INDEX(pcWhere + " ":U," NO-LOCK ":U),
                          INDEX(pcWhere + " ":U," SHARE-LOCK ":U),
                          INDEX(pcWhere + " ":U," EXCLUSIVE-LOCK ":U),
                          INDEX(pcWhere + " ":U," SHARE ":U),
                          INDEX(pcWhere + " ":U," EXCLUSIVE ":U)
                          )
      iInsertPos    = LENGTH(pcWhere) + 1
                      /* We must insert before the leftmoust keyword,
                         unless the keyword is Before the WHERE keyword */
      iInsertPos    = MIN(
                        (IF iLockPos   > iWherePos THEN iLockPos   ELSE iInsertPos),
                        (IF iOuterPos  > iWherePos THEN iOuterPos  ELSE iInsertPos),
                        (IF iUseIdxPos > iWherePos THEN iUseIdxPos ELSE iInsertPos),
                        (IF iIdxRePos  > iWherePos THEN iIdxRePos  ELSE iInsertPos),
                        (IF iByPos     > iWherePos THEN iByPos     ELSE iInsertPos)
                         )
      lWhere        = INDEX(pcWhere," WHERE ":U) > 0
      cWhereOrAnd   = (IF NOT lWhere          THEN " WHERE ":U
                       ELSE IF pcAndOr = "":U OR pcAndOr = ? THEN " AND ":U
                       ELSE " ":U + pcAndOr + " ":U)
      iOfPos        = INDEX(pcWhere," OF ":U).

    IF LEFT-TRIM(pcExpression) BEGINS "OF ":U THEN
    DO:
      /* If there is an OF in both the join and existing query we replace the
         table unless they are the same */
      IF iOfPos > 0 THEN
      DO:
        ASSIGN
          /* Find the table in the old join */
          cRelTable  = ENTRY(1,LEFT-TRIM(SUBSTRING(pcWhere,iOfPos + 4))," ":U)
          /* Find the table in the new join */
          cJoinTable = SUBSTRING(LEFT-TRIM(pcExpression),3).

        IF cJoinTable <> cRelTable THEN
          ASSIGN
           iRelTblPos = INDEX(pcWhere + " ":U," ":U + cRelTable + " ":U)
                        + 1
           SUBSTRING(pcWhere,iRelTblPos,LENGTH(cRelTable)) = cJointable.
      END. /* if iOfPos > 0 */
      ELSE
        SUBSTRING(pcWhere,iTblPos,0) = " ":U + pcExpression.
    END. /* if left-trim(pcExpression) BEGINS "OF ":U */
    ELSE
      SUBSTRING(pcWhere,iInsertPos,0) = cWhereOrAnd
                                        + "(":U
                                        + pcExpression
                                        + ")":U.

    RETURN RIGHT-TRIM(pcWhere).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newQueryString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION newQueryString Procedure 
FUNCTION newQueryString RETURNS CHARACTER
(pcQueryTables AS CHARACTER,
 pcColumns     AS CHARACTER,
 pcValues      AS CHARACTER,
 pcDataTypes   AS CHARACTER,
 pcOperators   AS CHARACTER,
 pcQueryString AS CHARACTER,
 pcAndOr       AS CHARACTER):
/*------------------------------------------------------------------------------
   Purpose: Returns a new query string to the passed query.
            The tables in the passed query must match getQueryTables().
            Adds column/value pairs to the corresponding buffer's where-clause.
            Each buffer's expression will always be embedded in parenthesis.
   Parameters:
     pcQueryTables - Table names (Comma separated)
     pcColumns   - Column names (Comma separated) as table.fieldname

     pcValues    - corresponding Values (CHR(1) separated)
     pcDataTypes - corresponding data types (comma seperated)
     pcOperators - Operator - one for all columns
                              - blank - defaults to (EQ)
                              - Use slash to define alternative string operator
                                EQ/BEGINS etc..
                            - comma separated for each column/value
     pcQueryString - A complete querystring matching the queries tables.
                     MUST be qualifed correctly.
     pcAndOr       - AND or OR decides how the new expression is appended to
                     the passed query (for each buffer!).
   Notes:  This was taken from query.p but changed for lookups to work without an
           SDO.
------------------------------------------------------------------------------*/
DEFINE VARIABLE cBufferList AS CHARACTER NO-UNDO.
DEFINE VARIABLE cBuffer     AS CHARACTER NO-UNDO.

/* We need the columns name and the parts */
DEFINE VARIABLE cColumn        AS CHARACTER NO-UNDO.
DEFINE VARIABLE cColumnName    AS CHARACTER NO-UNDO.
DEFINE VARIABLE iBuffer        AS INTEGER   NO-UNDO.
DEFINE VARIABLE iColumn        AS INTEGER   NO-UNDO.
DEFINE VARIABLE cUsedNums      AS CHARACTER NO-UNDO.

/* Used to builds the column/value string expression */
DEFINE VARIABLE cBufWhere      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cDataType      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cQuote         AS CHARACTER NO-UNDO.
DEFINE VARIABLE cValue         AS CHARACTER NO-UNDO.
DEFINE VARIABLE cOperator      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cStringOp      AS CHARACTER NO-UNDO.

ASSIGN cBufferList = pcQueryTables.

/* If unkown value is passed used the existing query string */
IF pcQueryString = ? THEN 
    RETURN ?.

IF pcAndOr = "":U 
OR pcAndOr = ? THEN 
    ASSIGN pcAndOr = "AND":U.

DO iBuffer = 1 TO NUM-ENTRIES(cBufferList):
    ASSIGN cBufWhere = "":U
           cBuffer   = ENTRY(iBuffer,cBufferList).

    ColumnLoop:
    DO iColumn = 1 TO NUM-ENTRIES(pcColumns):
    
        IF CAN-DO(cUsedNums,STRING(iColumn)) THEN
            NEXT ColumnLoop.
    
        ASSIGN cColumn = ENTRY(iColumn,pcColumns).

        /* Unqualified fields will use the first buffer in the query */
        IF INDEX(cColumn,".":U) = 0 THEN
            ASSIGN cColumn = cBuffer + ".":U + cColumn.
    
        /* Wrong buffer? */
        IF NOT (cColumn BEGINS cBuffer + ".":U) THEN 
            NEXT ColumnLoop.
    
        ASSIGN cOperator = IF pcOperators = "":U
                           OR pcOperators BEGINS "/":U
                           OR pcOperators = ?
                           THEN "=":U
                           ELSE IF NUM-ENTRIES(pcOperators) = 1
                                THEN ENTRY(1,pcOperators,"/":U)
                                ELSE ENTRY(iColumn,pcOperators)
        /* Look for optional string operator if only one entry in operator */
               cStringOp   = IF NUM-ENTRIES(pcOperators) = 1
                             AND NUM-ENTRIES(pcOperators,"/":U) = 2
                             THEN ENTRY(2,pcOperators,"/":U)
                             ELSE cOperator.
               cColumnName = ENTRY(NUM-ENTRIES(cColumn,".":U),cColumn,".":U).
               cDataType   = ENTRY(iColumn,pcDataTypes).
    
        IF cDataType <> ? THEN
            ASSIGN cValue     = ENTRY(iColumn,pcValues,CHR(1))
                   cValue     = IF CAN-DO("INTEGER,DECIMAL":U,cDataType) AND cValue = "":U
                                THEN "0":U
                                ELSE IF cDataType = "DATE":U and cValue = "":U
                                     THEN "?":U
                                     ELSE IF cValue = ? /*This could happen if only one value*/
                                          THEN "?":U
                                          ELSE cValue
                   cValue     = (IF cValue <> "":U
                                 THEN REPLACE(cValue,"'","~~~'")
                                 ELSE " ":U)
                   cQuote     = (IF cDataType = "CHARACTER":U AND cValue = "?"
                                 THEN "":U
                                 ELSE "'":U)
                   cBufWhere  = cBufWhere
                              + (IF cBufWhere = "":U
                                 THEN "":U
                                 ELSE " ":U + "AND":U + " ":U)
                              + cColumn + " ":U
                              + (IF cDataType = "CHARACTER":U
                                 THEN cStringOp
                                 ELSE cOperator)
                              + " ":U + cQuote + cValue + cQuote
                   cUsedNums  = cUsedNums
                              + (IF cUsedNums = "":U THEN "":U ELSE ",":U)
                              + STRING(iColumn). 
    END.

    IF cBufWhere <> "":U THEN
        ASSIGN pcQueryString = DYNAMIC-FUNCTION("newWhereClause":U IN TARGET-PROCEDURE, INPUT cBuffer, INPUT cBufWhere, INPUT pcQueryString, INPUT pcAndOr).
END.
RETURN pcQueryString.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newWhereClause) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION newWhereClause Procedure 
FUNCTION newWhereClause RETURNS CHARACTER
    (pcBuffer     AS CHARACTER,
     pcExpression AS CHARACTER,
     pcWhere      AS CHARACTER,
     pcAndOr      AS CHARACTER):
  /*------------------------------------------------------------------------------
    Purpose:     Inserts a new expression to query's prepare string for a specified
                 buffer.
    Parameters:  pcBuffer     - Which buffer.
                 pcExpression - The new expression.
                 pcWhere      - The current query prepare string.
                 pcAndOr      - Specifies what operator is used to add the new
                                expression to existing expression(s)
                                - AND (default)
                                - OR
    Notes:       This is a utility function that doesn't use any properties.
  ------------------------------------------------------------------------------*/
   DEFINE VARIABLE iComma      AS INTEGER   NO-UNDO.
   DEFINE VARIABLE iCount      AS INTEGER   NO-UNDO.
   DEFINE VARIABLE iStart      AS INTEGER   NO-UNDO.
   DEFINE VARIABLE iLength     AS INTEGER   NO-UNDO.
   DEFINE VARIABLE iEnd        AS INTEGER   NO-UNDO.
   DEFINE VARIABLE cWhere      AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cString     AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cFoundWhere AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cNextWhere  AS CHARACTER NO-UNDO.
   DEFINE VARIABLE hQuery      AS HANDLE    NO-UNDO.

   ASSIGN cString = pcWhere
          iStart  = 1.

   DO WHILE TRUE:
       ASSIGN iComma  = INDEX(cString,",").

       /* If a comma was found we split the string into cFoundWhere and cNextwhere */
       IF iComma <> 0 THEN
           ASSIGN cFoundWhere = cFoundWhere + SUBSTRING(cString,1,iComma)
                  cNextWhere  = SUBSTRING(cString,iComma + 1)
                  iCount      = iCount + iComma.
       ELSE
           ASSIGN cFoundWhere = IF cFoundWhere = "":U
                                THEN cString
                                ELSE cFoundWhere + cNextwhere.

       /* We have a complete table whereclause if there are no more commas
          or the next whereclause starts with each,first or last */
       IF iComma = 0
       OR CAN-DO("EACH,FIRST,LAST":U,ENTRY(1,TRIM(cNextWhere)," ":U)) 
       THEN DO:
           /* Remove comma or period before inserting the new expression */
           ASSIGN cFoundWhere = RIGHT-TRIM(cFoundWhere,",.":U)
                  iLength     = LENGTH(cFoundWhere).

           IF whereClauseBuffer(cFoundWhere) = pcBuffer  
           THEN DO:
               SUBSTRING(pcWhere,iStart,iLength) = insertExpression(cFoundWhere,pcExpression,pcAndOr).
               LEAVE.
           END.
           ELSE
               /* We're moving on to the next whereclause so reset cFoundwhere */
               ASSIGN cFoundWhere = "":U
                      iStart      = iCount + 1.

           /* No table found and we are at the end so we need to get out of here */
           IF iComma = 0 THEN
               LEAVE.
       END. /* if iComma = 0 or can-do(EACH,FIRST,LAST */
       ASSIGN cString = cNextWhere.
   END. /* do while true. */
   RETURN pcWhere.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-whereClauseBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION whereClauseBuffer Procedure 
FUNCTION whereClauseBuffer RETURNS CHARACTER
    (pcWhere AS CHAR):
  /*------------------------------------------------------------------------------
    Purpose:     Returns the buffername of a where clause expression.
                 This function avoids problems with leading or double blanks in
                 where clauses.
    Parameters:
      pcWhere - Complete where clause for ONE table with or without the FOR
                keyword. The buffername must be the second token in the
                where clause as in "EACH order OF Customer" or if "FOR" is
                specified the third token as in "FOR EACH order".

    Notes:       PRIVATE, used internally in query.p only.
  ------------------------------------------------------------------------------*/
    pcWhere = LEFT-TRIM(pcWhere).

    /* Remove double blanks */
    DO WHILE INDEX(pcWhere,"  ":U) > 0:
      pcWhere = REPLACE(pcWhere,"  ":U," ":U).
    END.

    RETURN (IF NUM-ENTRIES(pcWhere," ":U) > 1
            THEN ENTRY(IF pcWhere BEGINS "FOR ":U THEN 3 ELSE 2,pcWhere," ":U)
            ELSE "":U).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

