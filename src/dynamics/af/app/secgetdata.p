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
/*---------------------------------------------------------------------------------
  File: secgetdata

  Description:  Get Security Data PLIP

  Purpose:      This plip contains procedures to return information on tables in the database to be used when allocation is done

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   05/12/2003  Author:     Mark Davies (MIP)

  Update Notes: Created from Template rytemplipp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       secgetdata.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Astra object identifying preprocessor */
&glob   AstraPlip    yes

DEFINE VARIABLE cObjectName         AS CHARACTER NO-UNDO.

ASSIGN cObjectName = "{&object-name}":U.

&scop   mip-notify-user-on-plip-close   NO

{src/adm2/globals.i}

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
    (pcBuffer     AS CHAR,
     pcExpression AS char,
     pcWhere      AS CHAR,
     pcAndOr      AS CHAR) FORWARD.

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
         HEIGHT             = 14.57
         WIDTH              = 48.
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
  Purpose:     This procedure will build the query dynamically 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcFLA         AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plSecuredData AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plDataOnly    AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pdUserObj     AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pdCompanyObj  AS DECIMAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcBuffers     AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcQuery       AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcObjField    AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cTableName  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hQuery      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuffer     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cFieldName  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop       AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lGroupGSMLG AS LOGICAL    NO-UNDO.

  /* For the link between groups and login organisations, we store an owning entity of 'GSMGA', even *
   * though we're actually linking to the gsm_login_company table.  If we don't do this, login companies  *
   * a group is linked to are automatically secured for all users belonging to the group (issue 11337)    */
  IF pcFla = "GSMGA":U THEN
      ASSIGN pcFla = "GSMLG":U
             lGroupGSMLG = YES.
  ELSE
      ASSIGN lGroupGSMLG = NO.

  RUN getEntityTableName IN gshGenManager (INPUT pcFLA, INPUT "":U, OUTPUT cTableName).

  IF cTableName = "":U THEN 
    RETURN "The entity specified is invalid":U.
  
  pcObjField = DYNAMIC-FUNCTION("getObjField":U IN gshGenManager, INPUT pcFLA).

  IF pcObjField = "":U OR pcObjField = ? THEN
    RETURN "The entity specified does not have an obj field.":U.

  CREATE BUFFER hBuffer FOR TABLE cTableName NO-ERROR.

  IF ERROR-STATUS:ERROR THEN
    RETURN ("Could not create buffer for " + cTableName).

  IF NOT plDataOnly THEN DO:
    /* Tokens, Fields, Menu Items, Containers etc. */
    ASSIGN pcBuffers = "gsm_security_structure,":U.
    IF plSecuredData THEN
      pcBuffers = pcBuffers + "gsm_user_allocation,":U.
    ASSIGN pcBuffers = pcBuffers + 
                       cTableName + ",":U +
                       "gsc_product_module,":U +
                       "ryc_smartobject,":U +
                       "gsc_instance_attribute":U.

    pcQuery = "FOR EACH gsm_security_structure NO-LOCK ":U +
             "WHERE gsm_security_structure.owning_entity_mnemonic = '" + pcFLA + "', ":U.
    IF plSecuredData THEN DO:
      pcQuery = pcQuery +
               "FIRST gsm_user_allocation NO-LOCK ":U +
               "WHERE gsm_user_allocation.user_obj = ":U + QUOTER(pdUserObj) + " ":U +
               "AND   gsm_user_allocation.login_organisation_obj = ":U + QUOTER(pdCompanyObj) + " ":U + 
               "AND   gsm_user_allocation.owning_entity_mnemonic = 'GSMSS' " + 
               "AND   gsm_user_allocation.owning_obj = gsm_security_structure.security_structure_obj, ":U.
    END.

    pcQuery = pcQuery +
             "FIRST ":U + hBuffer:NAME + " NO-LOCK ":U +
             "WHERE ":U + hBuffer:NAME + ".":U + pcObjField + " = gsm_security_structure.owning_obj, " +
             "FIRST gsc_product_module OUTER-JOIN NO-LOCK ":U +
             "WHERE gsc_product_module.product_module_obj = gsm_security_structure.product_module_obj, ":U +
             "FIRST ryc_smartobject OUTER-JOIN NO-LOCK ":U +
             "WHERE ryc_smartobject.smartobject_obj = gsm_security_structure.object_obj, ":U + 
             "FIRST gsc_instance_attribute OUTER-JOIN NO-LOCK ":U +
             "WHERE gsc_instance_attribute.instance_attribute_obj = gsm_security_structure.instance_attribute_obj":U.
  END.
  ELSE DO:
    /* Data Only */
    IF plSecuredData THEN
      ASSIGN pcBuffers = "gsm_user_allocation,":U + hBuffer:NAME
             pcQuery   = "FOR EACH gsm_user_allocation NO-LOCK ":U +
                         "WHERE gsm_user_allocation.user_obj = ":U + QUOTER(pdUserObj) + " ":U +
                         "AND   gsm_user_allocation.login_organisation_obj = ":U + QUOTER(pdCompanyObj) + " ":U + 
                         "AND   gsm_user_allocation.owning_entity_mnemonic = '" + (IF lGroupGSMLG THEN "GSMGA":U ELSE pcFLA) + "', ":U +
                         "FIRST ":U + hBuffer:NAME + " NO-LOCK ":U + 
                         "WHERE ":U + hBuffer:NAME + ".":U + pcObjField + " = gsm_user_allocation.owning_obj ".
    ELSE DO:
      ASSIGN pcBuffers = hBuffer:NAME
             pcQuery   = "FOR EACH ":U + hBuffer:NAME + " NO-LOCK ":U.
      IF hBuffer:NAME = "ryc_smartobject":U THEN
        pcQuery = pcQuery + 
                  "WHERE ryc_smartobject.container_object = TRUE ":U.
    END.
  END.

  /* Add a default sort on the first non _obj field of the data table */
  IF VALID-HANDLE(hBuffer) THEN DO:
    DO iLoop = 1 TO hBuffer:NUM-FIELDS:
      cFieldName = hBuffer:BUFFER-FIELD(iLoop):NAME.
      IF INDEX(cFieldName,"_obj":U) > 0 AND
         SUBSTRING(cFieldName,LENGTH(cFieldName) - 3,4) = "_obj":U THEN
        NEXT.
      ELSE 
        LEAVE.
    END.
    pcQuery = pcQuery + " BY ":U + hBuffer:NAME + ".":U + cFieldName.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createDataTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createDataTable Procedure 
PROCEDURE createDataTable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phDataTable    AS HANDLE     NO-UNDO.
  DEFINE INPUT  PARAMETER plDataOnly     AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pcObjField     AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plUserNotGroup AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER phTempTable    AS HANDLE     NO-UNDO.

  DEFINE VARIABLE iFieldLoop AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hField     AS HANDLE     NO-UNDO.

  IF NOT VALID-HANDLE(phDataTable) THEN
    RETURN.

  CREATE TEMP-TABLE phTempTable.
  
  /* We could do a CREATE-LIKE() statement, but I need to get rid 
     of any indexes */
  DO iFieldLoop = 1 TO phDataTable:NUM-FIELDS:
    phTempTable:ADD-LIKE-FIELD(phDataTable:BUFFER-FIELD(iFieldLoop):TABLE + "__":U + phDataTable:BUFFER-FIELD(iFieldLoop):NAME,phDataTable:BUFFER-FIELD(iFieldLoop)).
  END.
  
  /* Add fields - Product Module and Object */
  IF NOT plDataOnly THEN DO:
    phTempTable:ADD-NEW-FIELD("dSecurity_structure_obj":U,"DECIMAL").
    phTempTable:ADD-NEW-FIELD("cProdMod":U     ,"CHARACTER":U,0,"X(30)":U,"":U,"Product module":U).
    phTempTable:ADD-NEW-FIELD("cObject":U      ,"CHARACTER":U,0,"X(30)":U,"":U,"Object filename":U).
    phTempTable:ADD-NEW-FIELD("cInstanceAttr":U,"CHARACTER":U,0,"X(30)":U,"":U,"Instance attribute":U).
    phTempTable:ADD-NEW-INDEX("Idx1",FALSE,TRUE).
    phTempTable:ADD-INDEX-FIELD("Idx1":U,"dSecurity_structure_obj":U).
  END.
  ELSE DO:
    phTempTable:ADD-NEW-INDEX("Idx1",FALSE,TRUE).
    phTempTable:ADD-INDEX-FIELD("Idx1":U,phDataTable:NAME + "__":U + pcObjField).
  END.
    
  CASE phDataTable:NAME:
      /* For field security we need to add an extra field to convert field security types */
      WHEN "gsm_field":U THEN
          phTempTable:ADD-NEW-FIELD("cSecurityType":U,"CHARACTER":U,0,"X(30)":U,"":U,"Security Type":U).

      /* For range security we need to 2 extra fields for the from and to values */
      WHEN "gsm_range":U 
      THEN DO:
          phTempTable:ADD-NEW-FIELD("cFromValue":U,"CHARACTER":U,0,"X(70)":U,"":U,"From Value":U).
          phTempTable:ADD-NEW-FIELD("cToValue":U,  "CHARACTER":U,0,"X(70)":U,"":U,"To Value":U).
      END.

      OTHERWISE 
          /* IF we're dealing with data security at user level, the user can enter YES/NO to indicate if an object is secured. *
           * At all other levels, the existance of an allocation indicates that the object has been granted/revoked.           */
          IF plUserNotGroup THEN
              phTempTable:ADD-NEW-FIELD("cSecured":U,"LOGICAL":U,0,"Yes/No":U,"Yes":U,"Secured":U).
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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAllocatedGroups) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getAllocatedGroups Procedure 
PROCEDURE getAllocatedGroups :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will receive an Obj number of a user and a login
               company and return all available groups and groups allocated to 
               to the user
  Parameters:  pdUserObj - The Obj number of the user
               pdLoginCompanyObj - The obj number of the assigned login company
               pcAvailableGroups - CHR(5) and CHR(4) delimited list of User_obj 
                                  and login_name of users not allocated to the
                                  specified group and login company
                                  eg: 24125|Admin^55415|Guest
                                  where | = CHR(4)
                                  and   ^ = CHR(5)
               pcAllocatedGroups - CHR(5) and CHR(4) delimited list of User_obj 
                                  and login_name of all users allocated for the
                                  specified user and login company
                                  eg: 24125|Admin^55415|Guest
                                  where | = CHR(4)
                                  and   ^ = CHR(5)
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pdUserObj        AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pdLoginCompanyObj AS DECIMAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcAvailableGroups  AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcAllocatedGroups  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cUserString AS CHARACTER  NO-UNDO.
  
  FOR EACH  gsm_user
      WHERE gsm_user.security_group = TRUE
      AND   gsm_user.disabled       = FALSE
      NO-LOCK:
    cUserString = STRING(gsm_user.user_obj) + CHR(4) + gsm_user.user_login_name.
    FIND FIRST gsm_group_allocation
         WHERE gsm_group_allocation.group_user_obj    = gsm_user.user_obj
         AND   gsm_group_allocation.user_obj          = pdUserObj
         AND   gsm_group_allocation.login_company_obj = pdLoginCompanyObj
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gsm_group_allocation THEN DO:
      /* Check if group allpies to All Companies */
      IF pdLoginCompanyObj = 0 AND 
         CAN-FIND(FIRST gsm_user_allocation
                  WHERE gsm_user_allocation.user_obj = gsm_user.user_obj
                  AND   gsm_user_allocation.owning_entity_mnemonic = "GSMGA":U NO-LOCK) THEN
        NEXT.
      IF pdLoginCompanyObj <> 0 AND
         NOT CAN-FIND(FIRST gsm_user_allocation
                  WHERE gsm_user_allocation.user_obj = gsm_user.user_obj
                  AND   gsm_user_allocation.owning_entity_mnemonic = "GSMGA":U 
                  AND   gsm_user_allocation.owning_obj             = pdLoginCompanyObj NO-LOCK) AND
         CAN-FIND(FIRST gsm_user_allocation
                  WHERE gsm_user_allocation.user_obj = gsm_user.user_obj
                  AND   gsm_user_allocation.owning_entity_mnemonic = "GSMGA":U NO-LOCK) THEN
        NEXT.
      ASSIGN pcAvailableGroups = IF pcAvailableGroups = "":U THEN cUserString ELSE pcAvailableGroups + CHR(5) + cUserString.
    END.
    ELSE
      ASSIGN pcAllocatedGroups = IF pcAllocatedGroups = "":U THEN cUserString ELSE pcAllocatedGroups + CHR(5) + cUserString.
  END.
  
  /* Now look for all users allocated to specified group and login company */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAllocatedUsers) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getAllocatedUsers Procedure 
PROCEDURE getAllocatedUsers :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will receive an Obj number of a group and a login
               company and return all available users and users allocated to 
               to the group
  Parameters:  pdGroupObj - The Obj number of the group
               pdLoginCompanyObj - The obj number of the assigned login company
               pcAvailableUsers - CHR(5) and CHR(4) delimited list of User_obj 
                                  and login_name of users not allocated to the
                                  specified group and login company
                                  eg: 24125|Admin^55415|Guest
                                  where | = CHR(4)
                                  and   ^ = CHR(5)
               pcAllocatedUsers - CHR(5) and CHR(4) delimited list of User_obj 
                                  and login_name of all users allocated for the
                                  specified user and login company
                                  eg: 24125|Admin^55415|Guest
                                  where | = CHR(4)
                                  and   ^ = CHR(5)
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pdGroupObj        AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pdLoginCompanyObj AS DECIMAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcAvailableUsers  AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcAllocatedUsers  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cUserString AS CHARACTER  NO-UNDO.

  /* If this group is not valid for the specified login company, we can't allocate any users to it */
  IF pdLoginCompanyObj = 0 
  AND CAN-FIND(FIRST gsm_user_allocation 
               WHERE gsm_user_allocation.user_obj               = pdGroupObj
                 AND gsm_user_allocation.owning_entity_mnemonic = "GSMGA":U) THEN
      RETURN. /* The group has been allocated to specific companies */

  IF pdLoginCompanyObj <> 0
  AND NOT CAN-FIND(FIRST gsm_user_allocation
                   WHERE gsm_user_allocation.user_obj               = pdGroupObj
                     AND gsm_user_allocation.owning_entity_mnemonic = "GSMGA":U 
                     AND gsm_user_allocation.owning_obj             = pdLoginCompanyObj) /* Hasn't been allocated to this company */
  AND CAN-FIND(FIRST gsm_user_allocation
               WHERE gsm_user_allocation.user_obj               = pdGroupObj
                 AND gsm_user_allocation.owning_entity_mnemonic = "GSMGA":U) /* ...but has been allocated to other companies */ THEN
      RETURN.

  /* The group is valid for the company specified, build the user list */
  FOR EACH  gsm_user
      WHERE gsm_user.user_obj <> pdGroupObj
      AND   gsm_user.disabled = FALSE
      NO-LOCK:
    cUserString = STRING(gsm_user.user_obj) + CHR(4) + gsm_user.user_login_name.
    FIND FIRST gsm_group_allocation
         WHERE gsm_group_allocation.group_user_obj    = pdGroupObj
         AND   gsm_group_allocation.user_obj          = gsm_user.user_obj
         AND   gsm_group_allocation.login_company_obj = pdLoginCompanyObj
         NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gsm_group_allocation THEN
      ASSIGN pcAvailableUsers = IF pcAvailableUsers = "":U THEN cUserString ELSE pcAvailableUsers + CHR(5) + cUserString.
    ELSE
      ASSIGN pcAllocatedUsers = IF pcAllocatedUsers = "":U THEN cUserString ELSE pcAllocatedUsers + CHR(5) + cUserString.
  END.
  
  /* Now look for all users allocated to specified group and login company */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSecurityData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSecurityData Procedure 
PROCEDURE getSecurityData :
/*------------------------------------------------------------------------------
  Purpose:     This procedure gets an FLA and builds a query on this table depending
               on the secured input parameter that tells it if it should return
               data not secured yet, or data already secured
  Parameters:  pdUserObj - Query for security applied to this user only
                           If 0 (zero) - All users
               pdLoginCompany - Query for security applied to this login company
                                If 0 (zero) - All login companies
               pcFLA - The FLA of the table we want to apply security to
               plSecuredData - Since we want to queries, one for data with security
                               and one without security - this flag will tell us
                               what the query should look like
               plDataSecurity - We can secure certain preset objects e.g. tokens, 
                                fields etc, or raw data. If it is raw data we
                                do not want to join to the product module table
               piRowsToBatch - The number of rows to batch with the return of the
                               query. If this is ?, we will return every thing
               plFieldsOnly - If this is set to TRUE, we will only build the
                              query and return the table-handle. No data
               pcFromRowID - If this value is ? then we will start from the
                             first record, otherwise we need to start from this
                             record onwards. This should contain a comma seperated
                             list of all rowid of all buffers in that query.
               pcFilterData - A CHR(4) delimited list with the following filter information
                              1 - Comma seperated list of field name
                              2 - CHR(1) seperated list of filter values
                              3 - Comma seperated list of field data type
                              4 - Comma seperated list of filter comparison
             OUTPUT  
               pcLastRowId - This will return a comma seperated list of ROWIDs of 
                             all the buffers of the last record sent 
                             in the temp-table. This must then be sent in pcFromRowID
                             the next time this is run to ensure we start from this
                             record.
               plQueryComplete - Returns TRUE if the query complete - no more records
                                 are available
               phDataTable - This returns the data table handle to the client side
              
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pdUserObj       AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pdLoginCompany  AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pcFLA           AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plSecuredData   AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plDataSecurity  AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER piRowsToBatch   AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER plFieldsOnly    AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pcFromRowID     AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcFilterData    AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcLastRowId     AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER plQueryComplete AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phDataTable.

  DEFINE VARIABLE cBufferList             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQuery                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hQuery                  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuffer                 AS HANDLE     NO-UNDO EXTENT 10.
  DEFINE VARIABLE cObjField               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop                   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iDataTableIndex         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iProdModTableIndex      AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iAllocationTableIndex   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iAvailableTableIndex    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hDataTable              AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDataTableBuffer        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iLoopCounter            AS INTEGER    NO-UNDO.
  DEFINE VARIABLE rRowIds                 AS ROWID      NO-UNDO EXTENT 10.
  DEFINE VARIABLE hValidField             AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lUserNotGroup           AS LOGICAL    NO-UNDO.

  DEFINE BUFFER gsm_user FOR gsm_user.

  IF piRowsToBatch <= 0 
  OR piRowsToBatch = ? THEN
      ASSIGN piRowsToBatch = 50.

  /* If we're allocating against the user directly, we need to add an extra field for data security to store a YES/NO */
  IF plDataSecurity
  OR pcFla = "GSMTO":U /* We store a YES/NO against tokens at user level as well */
  THEN DO:
      FIND gsm_user NO-LOCK
           WHERE gsm_user.user_obj = pdUserObj
           NO-ERROR.
      ASSIGN lUserNotGroup = AVAILABLE gsm_user AND NOT gsm_user.security_group.
  END.
  ELSE
      ASSIGN lUserNotGroup = NO.

  RUN buildQuery (INPUT pcFLA,
                  INPUT plSecuredData,
                  INPUT plDataSecurity,
                  INPUT pdUserObj,
                  INPUT pdLoginCompany,
                  OUTPUT cBufferList,
                  OUTPUT cQuery,
                  OUTPUT cObjField).
  
  IF RETURN-VALUE <> "":U THEN
    RETURN ERROR RETURN-VALUE.

  /* Apply Extra filtering */
  IF pcFilterData <> "":U AND NOT plSecuredData THEN DO:
    cQuery = DYNAMIC-FUNCTION('newQueryString':U IN THIS-PROCEDURE,
                            cBufferList,
                            ENTRY(1,pcFilterData,CHR(4)),
                            ENTRY(2,pcFilterData,CHR(4)),
                            ENTRY(3,pcFilterData,CHR(4)),
                            ENTRY(4,pcFilterData,CHR(4)),
                            cQuery,
                            ?).
  END.
    
  /* Not data security */
  IF NOT plDataSecurity THEN DO:
    IF NOT plSecuredData THEN
      ASSIGN iDataTableIndex       = 2
             iProdModTableIndex    = 3
             iAllocationTableIndex = 0
             iAvailableTableIndex  = iDataTableIndex.
    ELSE
      ASSIGN iDataTableIndex       = 3
             iProdModTableIndex    = 4
             iAllocationTableIndex = 2
             iAvailableTableIndex  = iAllocationTableIndex.
  END.
  ELSE DO: /* Data Security */
    IF NOT plSecuredData THEN
      ASSIGN iDataTableIndex       = 1
             iProdModTableIndex    = 0
             iAllocationTableIndex = 0
             iAvailableTableIndex  = iDataTableIndex.
    ELSE
      ASSIGN iDataTableIndex       = 2
             iProdModTableIndex    = 0
             iAllocationTableIndex = 1
             iAvailableTableIndex  = iAllocationTableIndex.

  END.

  CREATE QUERY hQuery.
  DO iLoop = 1 TO NUM-ENTRIES(cBufferList):
    CREATE BUFFER hBuffer[iLoop] FOR TABLE ENTRY(iLoop,cBufferList).
    hQuery:ADD-BUFFER(hBuffer[iLoop]).
  END.
  
  hQuery:QUERY-PREPARE(cQuery) NO-ERROR.
  IF ERROR-STATUS:ERROR THEN 
    RETURN ERROR ("INVALIDQUERY^" + cQuery).

  hQuery:QUERY-OPEN().

  IF pcFromRowID <> ? THEN DO:
    DO iLoop = 1 TO NUM-ENTRIES(pcFromRowId):
      rRowIds[iLoop] = TO-ROWID(ENTRY(iLoop,pcFromRowId)).
    END.
    IF hQuery:REPOSITION-TO-ROWID(rRowIds) THEN DO:
      hQuery:GET-NEXT(). /* get row repositioned */
      hQuery:GET-NEXT(). /* get next record */
    END.
  END.
  ELSE
    hQuery:GET-FIRST().

  RUN createDataTable (INPUT hBuffer[iDataTableIndex], 
                       INPUT plDataSecurity,
                       INPUT cObjField,
                       INPUT lUserNotGroup,
                       OUTPUT hDataTable).
  hDataTableBuffer = hDataTable:DEFAULT-BUFFER-HANDLE.

  IF NOT plSecuredData THEN DO:
  /* When we check for data that does not yet have security,
     we have to add an extra check to ensure we could not
     find any security for that record */
    DO WHILE hBuffer[iAvailableTableIndex]:AVAILABLE:
      IF NOT CAN-FIND(FIRST gsm_user_allocation
                      WHERE gsm_user_allocation.user_obj               = pdUserObj
                      AND   gsm_user_allocation.login_organisation_obj = pdLoginCompany
                      AND   gsm_user_allocation.owning_entity_mnemonic = (IF plDataSecurity THEN pcFLA ELSE "GSMSS":U)
                      AND   gsm_user_allocation.owning_obj             = (IF plDataSecurity THEN DECIMAL(hBuffer[iDataTableIndex]:BUFFER-FIELD(cObjField):BUFFER-VALUE)
                                                                                            ELSE DECIMAL(hBuffer[1]:BUFFER-FIELD("security_structure_obj"):BUFFER-VALUE))) 
      THEN DO:
        iLoopCounter = iLoopCounter + 1.
        hDataTableBuffer:BUFFER-CREATE().
        /* I had to move away from the BUFFER-COPY method since I
           had to rename the fields to allow me to apply filters 
           where the field name contains the name of the table and field 
           I did test performance and could not really see a decrease 
           doing it this way*/
        DO iLoop = 1 TO hBuffer[iDataTableIndex]:NUM-FIELDS:
          ASSIGN hDataTableBuffer:BUFFER-FIELD(iLoop):BUFFER-VALUE = hBuffer[iDataTableIndex]:BUFFER-FIELD(iLoop):BUFFER-VALUE.
        END.
          /*
        hDataTableBuffer:BUFFER-COPY(hBuffer[iDataTableIndex]).
            */
        /* We need to add Product Module and Objects - where applicable */
        IF NOT plDataSecurity THEN DO:
          /* Security structure obj */
          IF hBuffer[1]:AVAILABLE THEN
            ASSIGN hDataTableBuffer:BUFFER-FIELD("dSecurity_structure_obj":U):BUFFER-VALUE = hBuffer[1]:BUFFER-FIELD("security_structure_obj":U):BUFFER-VALUE.
          ELSE
            ASSIGN hDataTableBuffer:BUFFER-FIELD("dSecurity_structure_obj":U):BUFFER-VALUE = "0":U.
          /* Product Module */
          IF hBuffer[iProdModTableIndex]:AVAILABLE THEN
            ASSIGN hDataTableBuffer:BUFFER-FIELD("cProdMod":U):BUFFER-VALUE = hBuffer[iProdModTableIndex]:BUFFER-FIELD("product_module_code":U):BUFFER-VALUE.
          ELSE
            ASSIGN hDataTableBuffer:BUFFER-FIELD("cProdMod":U):BUFFER-VALUE = "All":U.
          /* Smart Object */
          IF hBuffer[iProdModTableIndex + 1]:AVAILABLE THEN
            ASSIGN hDataTableBuffer:BUFFER-FIELD("cObject":U):BUFFER-VALUE = hBuffer[iProdModTableIndex + 1]:BUFFER-FIELD("object_filename":U):BUFFER-VALUE.
          ELSE
            ASSIGN hDataTableBuffer:BUFFER-FIELD("cObject":U):BUFFER-VALUE = "All":U.
          /* Instance Attribute */
          IF hBuffer[iProdModTableIndex + 2]:AVAILABLE THEN
            ASSIGN hDataTableBuffer:BUFFER-FIELD("cInstanceAttr":U):BUFFER-VALUE = hBuffer[iProdModTableIndex + 2]:BUFFER-FIELD("attribute_code":U):BUFFER-VALUE.
          ELSE
            ASSIGN hDataTableBuffer:BUFFER-FIELD("cInstanceAttr":U):BUFFER-VALUE = "All":U.
          
          /* Field Security */
          hValidField = hDataTableBuffer:BUFFER-FIELD("cSecurityType":U) NO-ERROR.
          IF VALID-HANDLE(hValidField) THEN
            ASSIGN hValidField:BUFFER-VALUE = "Full Access":U.
        END.

        /* At user level, we store a YES/NO against data security and action security */
        ASSIGN hValidField = hDataTableBuffer:BUFFER-FIELD("cSecured":U) NO-ERROR.
        IF VALID-HANDLE(hValidField) THEN
            ASSIGN hValidField:BUFFER-VALUE = "Yes":U.
      END.
      IF iLoopCounter >= piRowsToBatch THEN DO:
        pcLastRowId = FILL(",":U,NUM-ENTRIES(cBufferList) - 1).
        DO iLoop = 1 TO NUM-ENTRIES(cBufferList):
          IF hBuffer[iLoop]:AVAILABLE THEN
            ENTRY(iLoop,pcLastRowId) = STRING(hBuffer[iLoop]:ROWID).
          ELSE
            ENTRY(iLoop,pcLastRowId) = "?":U.
        END.
        LEAVE.
      END.
      hQuery:GET-NEXT().
    END.          
    plQueryComplete = hQuery:QUERY-OFF-END.
    IF plQueryComplete THEN
      pcLastRowId = ?.
  END.
  ELSE DO:
    /* For secured data we will only be getting data that
       has security. We now only need to build the temp-table
       and assign the data */
    DO WHILE hBuffer[iAvailableTableIndex]:AVAILABLE:
      hDataTableBuffer:BUFFER-CREATE().
      
      /* I had to move away from the BUFFER-COPY method since I
         had to rename the fields to allow me to apply filters 
         where the field name contains the name of the table and field 
         I did test performance and could not really see a decrease 
         doing it this way*/
      DO iLoop = 1 TO hBuffer[iDataTableIndex]:NUM-FIELDS:
        ASSIGN hDataTableBuffer:BUFFER-FIELD(iLoop):BUFFER-VALUE = hBuffer[iDataTableIndex]:BUFFER-FIELD(iLoop):BUFFER-VALUE.
      END.
        /*
      hDataTableBuffer:BUFFER-COPY(hBuffer[iDataTableIndex]).
          */
      /* We need to add Product Module and Objects - where applicable */
      IF NOT plDataSecurity THEN DO:
        /* Security structure obj */
        IF hBuffer[1]:AVAILABLE THEN
          ASSIGN hDataTableBuffer:BUFFER-FIELD("dSecurity_structure_obj":U):BUFFER-VALUE = hBuffer[1]:BUFFER-FIELD("security_structure_obj":U):BUFFER-VALUE.
        ELSE
          ASSIGN hDataTableBuffer:BUFFER-FIELD("dSecurity_structure_obj":U):BUFFER-VALUE = "0":U.
        /* Product Module */
        IF hBuffer[iProdModTableIndex]:AVAILABLE THEN
          ASSIGN hDataTableBuffer:BUFFER-FIELD("cProdMod":U):BUFFER-VALUE = hBuffer[iProdModTableIndex]:BUFFER-FIELD("product_module_code":U):BUFFER-VALUE.
        ELSE
          ASSIGN hDataTableBuffer:BUFFER-FIELD("cProdMod":U):BUFFER-VALUE = "All":U.
        /* Smart Object */
        IF hBuffer[iProdModTableIndex + 1]:AVAILABLE THEN
          ASSIGN hDataTableBuffer:BUFFER-FIELD("cObject":U):BUFFER-VALUE = hBuffer[iProdModTableIndex + 1]:BUFFER-FIELD("object_filename":U):BUFFER-VALUE.
        ELSE
          ASSIGN hDataTableBuffer:BUFFER-FIELD("cObject":U):BUFFER-VALUE = "All":U.
        /* Instance Attribute */
        IF hBuffer[iProdModTableIndex + 2]:AVAILABLE THEN
          ASSIGN hDataTableBuffer:BUFFER-FIELD("cInstanceAttr":U):BUFFER-VALUE = hBuffer[iProdModTableIndex + 2]:BUFFER-FIELD("attribute_code":U):BUFFER-VALUE.
        ELSE
          ASSIGN hDataTableBuffer:BUFFER-FIELD("cInstanceAttr":U):BUFFER-VALUE = "All":U.

        /* Field Security */
        hValidField = hDataTableBuffer:BUFFER-FIELD("cSecurityType":U) NO-ERROR.
        IF VALID-HANDLE(hValidField) 
        THEN DO:
            IF hBuffer[2]:AVAILABLE THEN
                ASSIGN hValidField:BUFFER-VALUE = hBuffer[2]:BUFFER-FIELD("user_allocation_value1":U):BUFFER-VALUE.
            ELSE
                ASSIGN hValidField:BUFFER-VALUE = "Full Access":U.
        END.

        /* Range Security */
        hValidField = hDataTableBuffer:BUFFER-FIELD("cFromValue":U) NO-ERROR.
        IF hBuffer[2]:AVAILABLE AND 
          VALID-HANDLE(hValidField) THEN
          ASSIGN hDataTableBuffer:BUFFER-FIELD("cFromValue":U):BUFFER-VALUE = hBuffer[2]:BUFFER-FIELD("user_allocation_value1":U):BUFFER-VALUE
                 hDataTableBuffer:BUFFER-FIELD("cToValue":U):BUFFER-VALUE   = hBuffer[2]:BUFFER-FIELD("user_allocation_value2":U):BUFFER-VALUE.

        /* Token security */
        ASSIGN hValidField = hDataTableBuffer:BUFFER-FIELD("cSecured":U) NO-ERROR.
        IF VALID-HANDLE(hValidField)
        THEN DO:
            IF hBuffer[2]:AVAILABLE THEN
                ASSIGN hValidField:BUFFER-VALUE = (hBuffer[2]:BUFFER-FIELD("user_allocation_value1":U):BUFFER-VALUE <> "NO":U).
            ELSE
                ASSIGN hValidField:BUFFER-VALUE = "NO":U.
        END.
      END.
      ELSE DO:
          /* Data security at user level stores a YES/NO in user_allocation_value1 */
          ASSIGN hValidField = hDataTableBuffer:BUFFER-FIELD("cSecured":U) NO-ERROR.
          IF VALID-HANDLE(hValidField) 
          THEN DO:
              IF hBuffer[1]:AVAILABLE THEN
                  ASSIGN hValidField:BUFFER-VALUE = (hBuffer[1]:BUFFER-FIELD("user_allocation_value1":U):BUFFER-VALUE <> "NO":U).
              ELSE
                  ASSIGN hValidField:BUFFER-VALUE = "NO":U.
          END.
      END.

      IF iLoopCounter >= piRowsToBatch THEN DO:
        pcLastRowId = FILL(",":U,NUM-ENTRIES(cBufferList) - 1).
        DO iLoop = 1 TO NUM-ENTRIES(cBufferList):
          IF hBuffer[iLoop]:AVAILABLE THEN
            ENTRY(iLoop,pcLastRowId) = STRING(hBuffer[iLoop]:ROWID).
          ELSE
            ENTRY(iLoop,pcLastRowId) = "?":U.
        END.
        LEAVE.
      END.
      hQuery:GET-NEXT().
    END.
    plQueryComplete = hQuery:QUERY-OFF-END.
    IF plQueryComplete THEN
      pcLastRowId = ?.
  END.

  hQuery:QUERY-CLOSE().

  DO iLoop = 1 TO NUM-ENTRIES(cBufferList):
    DELETE OBJECT hBuffer[iLoop] NO-ERROR.
  END.
  DELETE OBJECT hQuery NO-ERROR.

  IF VALID-HANDLE(hDataTable) THEN DO:
    ASSIGN phDataTable = hDataTable.
    /* Delete temp-table object */
    DELETE OBJECT hDataTable.
    hDataTable = ?.
  END.

  ASSIGN ERROR-STATUS:ERROR = NO.
  RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSecurityDataAll) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSecurityDataAll Procedure 
PROCEDURE getSecurityDataAll :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will call getSecurityData twice - the first time
               to fetch the non secured data and the second time to get the
               secured data.
               The reason for this procedure is to allow us to get as much data
               with 1 AppServer hit
  Parameters:  pdUserObj - Query for security applied to this user only
                           If 0 (zero) - All users
               pdLoginCompany - Query for security applied to this login company
                                If 0 (zero) - All login companies
               pcFLA - The FLA of the table we want to apply security to
               plDataSecurity - We can secure certain preset objects e.g. tokens, 
                                fields etc, or raw data. If it is raw data we
                                do not want to join to the product module table
               piRowsToBatch - The number of rows to batch with the return of the
                               query. If this is ?, we will return every thing
               plFieldsOnly - If this is set to TRUE, we will only build the
                              query and return the table-handle. No data
               pcFilterData - A CHR(4) delimited list with the following filter information
                              1 - Comma seperated list of field name
                              2 - CHR(1) seperated list of filter values
                              3 - Comma seperated list of field data type
                              4 - Comma seperated list of filter comparison
             OUTPUT  
               pcNonSecLastRowId - This will return a comma seperated list of ROWIDs of 
                                   all the buffers of the last record sent for non secured data
                                   in the temp-table. This must then be sent in pcFromRowID
                                   the next time this is run to ensure we start from this
                                   record.
               pcSecLastRowId - This will return a comma seperated list of ROWIDs of 
                                all the buffers of the last record sent for secured data
                                in the temp-table. This must then be sent in pcFromRowID
                               the next time this is run to ensure we start from this
                               record.
               plNonSecQueryComplete - Returns TRUE if the query complete - no more records
                                      are available for non secured data
               plSecQueryComplete - Returns TRUE if the query complete - no more records
                                    are available for secured data
               phNonSecuredData - This returns the data table handle to the client side
                                  for non secured data only
               phSecuredData - This returns the data table handle to the client side
                               for secured data only
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pdUserObj         AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pdLoginCompany    AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pcFLA             AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plDataSecurity    AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER piRowsToBatch     AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER plFieldsOnly      AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pcFilterData      AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcNonSecLastRowId AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcSecLastRowId    AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER plNonSecQryComp   AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER plSecQryComp      AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phNonSecuredData.
  DEFINE OUTPUT PARAMETER TABLE-HANDLE phSecuredData.


  /* Firt get the Non Secured Data */
  RUN getSecurityData (INPUT  pdUserObj,
                       INPUT  pdLoginCompany,
                       INPUT  pcFLA,
                       INPUT  FALSE, /* Non Secured Data */
                       INPUT  plDataSecurity,
                       INPUT  piRowsToBatch,
                       INPUT  plFieldsOnly,
                       INPUT  ?, /* Start From the beginning */
                       INPUT  pcFilterData,
                       OUTPUT pcNonSecLastRowId,
                       OUTPUT plNonSecQryComp,
                       OUTPUT TABLE-HANDLE phNonSecuredData).

  /* Now get the Secured Data */
  RUN getSecurityData (INPUT  pdUserObj,
                       INPUT  pdLoginCompany,
                       INPUT  pcFLA,
                       INPUT  TRUE, /* Non Secured Data */
                       INPUT  plDataSecurity,
                       INPUT  piRowsToBatch,
                       INPUT  plFieldsOnly,
                       INPUT  ?, /* Start From the beginning */
                       INPUT  pcFilterData,
                       OUTPUT pcSecLastRowId,
                       OUTPUT plSecQryComp,
                       OUTPUT TABLE-HANDLE phSecuredData).

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

&IF DEFINED(EXCLUDE-setAllocatedGroups) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setAllocatedGroups Procedure 
PROCEDURE setAllocatedGroups :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will assign allocated groups for a specified user
               and login company
  Parameters:  pdUserObj - The Obj number of the user
               pdLoginCompanyObj - The obj number of the assigned login company
               pdAlloactedUsers  - A CHR(4) delimited list of all user_objs allocated
                                   to the specified group and login company.
                                   
  Notes:       Check the RETURN-VALUE of this procedure to check of any errors
               ocurred.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pdUserObj         AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pdLoginCompanyObj AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pcAllocatedGroups AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE iLoop     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE dGroupObj  AS DECIMAL    NO-UNDO.

  /* First delete any previousely allocated users if they are not in the list */
  FOR EACH  gsm_group_allocation
      WHERE gsm_group_allocation.user_obj          = pdUserObj
      AND   gsm_group_allocation.login_company_obj = pdLoginCompanyObj
      EXCLUSIVE-LOCK:
    IF LOOKUP(STRING(gsm_group_allocation.group_user_obj),pcAllocatedGroups,CHR(4)) = 0 THEN
      DELETE gsm_group_allocation.
  END.

  DO iLoop = 1 TO NUM-ENTRIES(pcAllocatedGroups,CHR(4)):
    dGroupObj = DECIMAL(ENTRY(iLoop,pcAllocatedGroups,CHR(4))).
    IF NOT CAN-FIND(FIRST gsm_group_allocation
                    WHERE gsm_group_allocation.user_obj          = pdUserObj
                    AND   gsm_group_allocation.login_company_obj = pdLoginCompanyObj 
                    AND   gsm_group_allocation.group_user_obj    = dGroupObj NO-LOCK) THEN DO:
      CREATE gsm_group_allocation.
      ASSIGN gsm_group_allocation.user_obj          = pdUserObj
             gsm_group_allocation.login_company_obj = pdLoginCompanyObj
             gsm_group_allocation.group_user_obj    = dGroupObj.
    END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAllocatedUsers) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setAllocatedUsers Procedure 
PROCEDURE setAllocatedUsers :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will assign allocated users for a specified group
               and login company
  Parameters:  pdGroupObj - The Obj number of the group
               pdLoginCompanyObj - The obj number of the assigned login company
               pdAlloactedUsers  - A CHR(4) delimited list of all user_objs allocated
                                   to the specified group and login company.
                                   
  Notes:       Check the RETURN-VALUE of this procedure to check of any errors
               ocurred.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pdGroupObj        AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pdLoginCompanyObj AS DECIMAL    NO-UNDO.
  DEFINE INPUT  PARAMETER pcAllocatedUsers  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE iLoop     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE dUserObj  AS DECIMAL    NO-UNDO.

  /* First delete any previousely allocated users if they are not in the list */
  FOR EACH  gsm_group_allocation
      WHERE gsm_group_allocation.group_user_obj    = pdGroupObj
      AND   gsm_group_allocation.login_company_obj = pdLoginCompanyObj
      EXCLUSIVE-LOCK:
    IF LOOKUP(STRING(gsm_group_allocation.user_obj),pcAllocatedUsers,CHR(4)) = 0 THEN
      DELETE gsm_group_allocation.
  END.

  DO iLoop = 1 TO NUM-ENTRIES(pcAllocatedUsers,CHR(4)):
    dUserObj = DECIMAL(ENTRY(iLoop,pcAllocatedUsers,CHR(4))).
    IF NOT CAN-FIND(FIRST gsm_group_allocation
                    WHERE gsm_group_allocation.group_user_obj    = pdGroupObj
                    AND   gsm_group_allocation.login_company_obj = pdLoginCompanyObj 
                    AND   gsm_group_allocation.user_obj          = dUserObj NO-LOCK) THEN DO:
      CREATE gsm_group_allocation.
      ASSIGN gsm_group_allocation.group_user_obj    = pdGroupObj
             gsm_group_allocation.login_company_obj = pdLoginCompanyObj
             gsm_group_allocation.user_obj          = dUserObj.
    END.
  END.

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
  DEFINE VARIABLE cBufferList    AS CHAR      NO-UNDO.
  DEFINE VARIABLE cBuffer        AS CHARACTER NO-UNDO.

  /* We need the columns name and the parts */
  DEFINE VARIABLE cColumn        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cColumnName    AS CHARACTER NO-UNDO.

  DEFINE VARIABLE iBuffer        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iColumn        AS INTEGER   NO-UNDO.

  DEFINE VARIABLE cUsedNums      AS CHAR      NO-UNDO.

  /* Used to builds the column/value string expression */
  DEFINE VARIABLE cBufWhere      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDataType      AS CHAR      NO-UNDO.
  DEFINE VARIABLE cQuote         AS CHAR      NO-UNDO.
  DEFINE VARIABLE cValue         AS CHAR      NO-UNDO.
  DEFINE VARIABLE cOperator      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cStringOp      AS CHARACTER NO-UNDO.

  cBufferList = pcQueryTables.

  /* If unkown value is passed used the existing query string */
  IF pcQueryString = ? THEN RETURN ?.

  IF pcAndOr = "":U OR pcAndOr = ? THEN pcAndOr = "AND":U.

  DO iBuffer = 1 TO NUM-ENTRIES(cBufferList):
    ASSIGN
      cBufWhere      = "":U
      cBuffer        = ENTRY(iBuffer,cBufferList).

    ColumnLoop:
    DO iColumn = 1 TO NUM-ENTRIES(pcColumns):

      IF CAN-DO(cUsedNums,STRING(iColumn)) THEN
        NEXT ColumnLoop.

      cColumn     = ENTRY(iColumn,pcColumns).

      /* Unqualified fields will use the first buffer in the query */
      IF INDEX(cColumn,".":U) = 0 THEN
        cColumn = cBuffer + ".":U + cColumn.

      /* Wrong buffer? */
      IF NOT (cColumn BEGINS cBuffer + ".":U) THEN NEXT ColumnLoop.

      ASSIGN
        /* Get the operator for this valuelist.
           Be forgiving and make sure we handle '',? and '/begins' as default */
        cOperator   = IF pcOperators = "":U
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
                      ELSE cOperator
        cColumnName = ENTRY(NUM-ENTRIES(cColumn,".":U),cColumn,".":U)
        cDataType   = ENTRY(iColumn,pcDataTypes).

      IF cDataType <> ? THEN
      DO:
        ASSIGN
          cValue     = ENTRY(iColumn,pcValues,CHR(1))
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
                       + (If cBufWhere = "":U
                          THEN "":U
                          ELSE " ":U + "AND":U + " ":U)
                       + cColumn
                       + " ":U
                       + (IF cDataType = "CHARACTER":U
                          THEN cStringOp
                          ELSE cOperator)
                       + " ":U
                       + cQuote
                       + cValue
                       + cQuote
          cUsedNums  = cUsedNums
                       + (IF cUsedNums = "":U THEN "":U ELSE ",":U)
                       + STRING(iColumn).

      END. /* if cDatatype <> ? */
    END. /* do iColumn = 1 to num-entries(pColumns) */
    /* We have a new expression */
    IF cBufWhere <> "":U THEN
      ASSIGN
        pcQueryString = DYNAMIC-FUNCTION("newWhereClause":U IN TARGET-PROCEDURE, INPUT cBuffer, INPUT cBufWhere, INPUT pcQueryString, INPUT pcAndOr).
  END. /* do iBuffer = 1 to hQuery:num-buffers */
  RETURN pcQueryString.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newWhereClause) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION newWhereClause Procedure 
FUNCTION newWhereClause RETURNS CHARACTER
    (pcBuffer     AS CHAR,
     pcExpression AS char,
     pcWhere      AS CHAR,
     pcAndOr      AS CHAR):
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
   DEFINE VARIABLE iComma      AS INT    NO-UNDO.
   DEFINE VARIABLE iCount      AS INT    NO-UNDO.
   DEFINE VARIABLE iStart      AS INT    NO-UNDO.
   DEFINE VARIABLE iLength     AS INT    NO-UNDO.
   DEFINE VARIABLE iEnd        AS INT    NO-UNDO.
   DEFINE VARIABLE cWhere      AS CHAR   NO-UNDO.
   DEFINE VARIABLE cString     AS CHAR   NO-UNDO.
   DEFINE VARIABLE cFoundWhere AS CHAR   NO-UNDO.
   DEFINE VARIABLE cNextWhere  AS CHAR   NO-UNDO.
   DEFINE VARIABLE hQuery      AS HANDLE NO-UNDO.

   ASSIGN
     cString = pcWhere
     iStart  = 1.

   DO WHILE TRUE:

     iComma  = INDEX(cString,",").

     /* If a comma was found we split the string into cFoundWhere and cNextwhere */
     IF iComma <> 0 THEN
       ASSIGN
         cFoundWhere = cFoundWhere + SUBSTR(cString,1,iComma)
         cNextWhere  = SUBSTR(cString,iComma + 1)
         iCount      = iCount + iComma.
     ELSE

       /* cFoundWhere is blank if this is the first time or if we have moved on
          to the next buffers where clause
          If cFoundwhere is not blank the last comma that was used to split
          the string into cFoundwhere and cNextwhere was not a join,
          so we must set them together again.
       */
       cFoundWhere = IF cFoundWhere = "":U
                     THEN cString
                     ELSE cFoundWhere + cNextwhere.

     /* We have a complete table whereclause if there are no more commas
        or the next whereclause starts with each,first or last */
     IF iComma = 0
     OR CAN-DO("EACH,FIRST,LAST":U,ENTRY(1,TRIM(cNextWhere)," ":U)) THEN
     DO:
       /* Remove comma or period before inserting the new expression */
       ASSIGN
         cFoundWhere = RIGHT-TRIM(cFoundWhere,",.":U)
         iLength     = LENGTH(cFoundWhere).

       IF whereClauseBuffer(cFoundWhere) = pcBuffer  THEN
       DO:
         SUBSTR(pcWhere,iStart,iLength) = insertExpression(cFoundWhere,
                                                           pcExpression,
                                                           pcAndOr).
         LEAVE.
       END.
       ELSE
         /* We're moving on to the next whereclause so reset cFoundwhere */
         ASSIGN
           cFoundWhere = "":U
           iStart      = iCount + 1.

       /* No table found and we are at the end so we need to get out of here */
       IF iComma = 0 THEN
       DO:
         /* (Buffer is not in query) Is this a run time error ? */.
         LEAVE.
       END.
     END. /* if iComma = 0 or can-do(EACH,FIRST,LAST */
     cString = cNextWhere.
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

