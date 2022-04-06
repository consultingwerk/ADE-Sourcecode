&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
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
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: afsecmngrp.i

  Description:  Astra Security Manager Code

  Purpose:      The Astra Security Manager is a standard procedure encapsulating all user
                security checks supported by the Astra framework, including token
                checks, field security, data security, menu security, etc.
                The Security Manager is not used to maintain security settings, it is merely
                for performing security checks.
                This include file contains the common code for both the server and client
                security manager procedures.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        5653   UserRef:    
                Date:   01/06/2000  Author:     Anthony Swindells

  Update Notes: Created from Template aftemplipp.p

  (v:010001)    Task:        6018   UserRef:    
                Date:   12/06/2000  Author:     Anthony Swindells

  Update Notes: Add new procedure to security manager to retrieve security control data as a
                temp-table.

  (v:010003)    Task:        6067   UserRef:    
                Date:   19/06/2000  Author:     Anthony Swindells

  Update Notes: Security Mods. Get product module rather than pass in product module.

  (v:010004)    Task:        6153   UserRef:    
                Date:   26/06/2000  Author:     Pieter Meyer

  Update Notes: Add Web check in Managers

  (v:010005)    Task:        6983   UserRef:    6970
                Date:   31/10/2000  Author:     Marcia Bouwman

  Update Notes: Create a new procedure which returns a comma delimited list of login
                organisations which a user has access to.

  (v:010006)    Task:        6970   UserRef:    
                Date:   02/11/2000  Author:     Marcia Bouwman

  Update Notes: changes made in gs-dev are not compiling

  (v:010100)    Task:    90000045   UserRef:    POSSE
                Date:   21/04/2001  Author:     Phil Magnay

  Update Notes: New security check for objects

  (v:010200)    Task:    90000156   UserRef:    
                Date:   26/05/2001  Author:     Phil Magnay

  Update Notes: test
                  
  (v:010300)    Task:                UserRef:    
                Date:   APR/11/2002  Author:     Mauricio J. dos Santos (MJS) 
                                                 mdsantos@progress.com
  Update Notes: Adapted for WebSpeed by changing SESSION:PARAM = "REMOTE" 
                to SESSION:CLIENT-TYPE = "WEBSPEED" in main block + various
                procedures.

--------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afsecmngrp.i
&scop object-version    000000

/* Astra object identifying preprocessor */
&GLOBAL-DEFINE astraSecurityManager  yes
&GLOBAL-DEFINE GSMFFRestrictiveLevels Full Access,READ-ONLY,HIDDEN

{af/sup2/afglobals.i} /* Astra global shared variables */
{af/app/afsecttdef.i}

DEFINE VARIABLE gcCacheSystemIcon      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcCacheSmallSystemIcon AS CHARACTER  NO-UNDO.

DEFINE TEMP-TABLE ttUserSecurityCheck NO-UNDO
FIELD dUserObj                        AS DECIMAL
FIELD dOrganisationObj                AS DECIMAL
FIELD cOwningEntityMnemonic           AS CHARACTER
FIELD dOwningObj                      AS DECIMAL
FIELD lSecurityCleared                AS LOGICAL
FIELD CSecurityValue1                 AS CHARACTER
FIELD CSecurityValue2                 AS CHARACTER
    INDEX key1 AS UNIQUE PRIMARY dUserObj dOrganisationObj cOwningEntityMnemonic dOwningObj.

DEFINE TEMP-TABLE ttFieldSecurityCheck NO-UNDO
FIELD cObjectName                     AS CHARACTER
FIELD cAttributeCode                  AS CHARACTER
FIELD cSecurityOptions                AS CHARACTER
INDEX key1 AS UNIQUE PRIMARY cObjectName cAttributeCode
.

DEFINE TEMP-TABLE ttTokenSecurityCheck NO-UNDO
FIELD cObjectName                     AS CHARACTER
FIELD cAttributeCode                  AS CHARACTER
FIELD cSecurityOptions                AS CHARACTER
INDEX key1 AS UNIQUE PRIMARY cObjectName cAttributeCode
.

DEFINE TEMP-TABLE ttTableSecurityCheck NO-UNDO
FIELD cOwningEntityMnemonic           AS CHARACTER
FIELD cEntityFieldName                AS CHARACTER
FIELD cValidValues                    AS CHARACTER
INDEX key1 AS UNIQUE PRIMARY cOwningEntityMnemonic cEntityFieldName cValidValues
.
DEFINE TEMP-TABLE ttRangeSecurityCheck NO-UNDO
FIELD cRangeCode                      AS CHARACTER
FIELD cObjectName                     AS CHARACTER
FIELD cAttributeCode                  AS CHARACTER
FIELD cRangeFrom                      AS CHARACTER
FIELD cRangeTo                        AS CHARACTER
INDEX key1 AS UNIQUE PRIMARY cRangeCode cObjectName cAttributeCode
.

DEFINE TEMP-TABLE ttObjectSecurityCheck NO-UNDO
FIELD cObjectName AS CHARACTER
FIELD dObjectObj  AS DECIMAL
FIELD lRestricted AS LOGICAL
INDEX key1 AS UNIQUE PRIMARY cObjectName 
INDEX key2 dObjectObj
.

DEFINE TEMP-TABLE ttMenuSecurity NO-UNDO
    FIELD cName             as CHARACTER
    FIELD cMenuType         as character    /* 'Item' or 'Structure' / corresponds to Actions and Bands resp. */
    FIELD cSecurityOptions  as CHARACTER
    index idxNameType
        cName
        cMenuType.               
        

DEFINE TEMP-TABLE ttUser               NO-UNDO
FIELD userObj                         AS DECIMAL.

{af/app/afttsecurityctrl.i}

DEFINE TEMP-TABLE ttGlobalSecurityStructure NO-UNDO
FIELD product_module_obj     AS DECIMAL
FIELD owning_entity_mnemonic AS CHARACTER
FIELD owning_obj             AS DECIMAL
FIELD security_structure_obj AS DECIMAL
FIELD security_object_name   AS CHARACTER

/* These fields are only populated in a client-server         *
 * environment, we can then assign security directly from     *
 * the temp-table, instead of having to run the checking API. */
FIELD restricted             AS LOGICAL
FIELD user_allocation_value1 AS CHARACTER
FIELD user_allocation_value2 AS CHARACTER
INDEX key1 owning_entity_mnemonic
.

DEFINE TEMP-TABLE ttGlobalSecurityAllocation NO-UNDO
FIELD login_organisation_obj  AS DECIMAL
FIELD owning_entity_mnemonic  AS CHARACTER
FIELD owning_obj              AS DECIMAL
FIELD user_allocation_value1  AS CHARACTER
FIELD user_allocation_value2  AS CHARACTER
INDEX key1 login_organisation_obj owning_entity_mnemonic owning_obj
.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-areFieldsCached) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD areFieldsCached Procedure 
FUNCTION areFieldsCached RETURNS LOGICAL
  (INPUT pcObjectName   AS CHARACTER,
   INPUT pcRunAttribute AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-areTokensCached) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD areTokensCached Procedure 
FUNCTION areTokensCached RETURNS LOGICAL
  (INPUT pcObjectName   AS CHARACTER,
   INPUT pcRunAttribute AS CHARACTER)  FORWARD.

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
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 26.62
         WIDTH              = 51.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  ******************************* */
CREATE WIDGET-POOL NO-ERROR.

ON CLOSE OF THIS-PROCEDURE 
DO:
    DELETE WIDGET-POOL NO-ERROR.

    RUN plipShutdown IN TARGET-PROCEDURE.

    DELETE PROCEDURE THIS-PROCEDURE.
    RETURN.
END.

/* This functionality has been moved to the session manager login cache call for the client. */
&IF DEFINED(server-side) <> 0 &THEN
IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN
DO:
    RUN getSecurityControl IN TARGET-PROCEDURE (OUTPUT TABLE ttSecurityControl).

    FIND FIRST ttSecurityControl NO-ERROR.

    IF NOT AVAILABLE ttSecurityControl OR ttSecurityControl.translation_enabled = YES 
    THEN DO: /* set translation enabled property to true */
        DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager,
                                             INPUT "translationEnabled":U,
                                             INPUT "YES":U,
                                             INPUT NO).
    END.
    ELSE DO: /* set translation enabled property to false */ 
        DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager,
                                             INPUT "translationEnabled":U,
                                             INPUT "NO":U,
                                             INPUT NO).
    END.

    /* Need to empty temp table so that it re-caches after user login so that the default user info is reset */
    EMPTY TEMP-TABLE ttSecurityControl.
END.

/* Cache global security structures and global allocations */
RUN cacheGlobalSecurityAllocations IN TARGET-PROCEDURE.
RUN cacheGlobalSecurityStructures  IN TARGET-PROCEDURE.
&ENDIF

/* Listen for the clearing of the Repository cache. If the repository cache is cleared, then we need
 * to signal the Security cache that it is also to be refreshed.                                        */
SUBSCRIBE PROCEDURE TARGET-PROCEDURE TO "repositoryCacheCleared" ANYWHERE RUN-PROCEDURE "clearClientCache":U.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-authenticateUser) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE authenticateUser Procedure 
PROCEDURE authenticateUser :
/*------------------------------------------------------------------------------
  Purpose:     Authenticate the user.  This procedure verifies that a user 
               exists in the database and that the password provided is 
               legitimate. It does not establish any permissions.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcUserName AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcPassword AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcError    AS CHARACTER  NO-UNDO.

&IF DEFINED(server-side) = 0 &THEN
    RUN af/app/afsecauthuserp.p ON gshAstraAppServer
       (INPUT pcUserName,
        INPUT pcPassword,
        OUTPUT pcError) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
        RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                        ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
&ELSE
    DEFINE BUFFER gsm_user          FOR gsm_user.
    DEFINE BUFFER gsm_user_category FOR gsm_user_category.
    
    /* 1st check user is valid */
    FIND FIRST gsm_user NO-LOCK
         WHERE gsm_user.user_login_name = pcUserName
         NO-ERROR.
    
    IF NOT AVAILABLE gsm_user
    THEN DO:
        ASSIGN pcError = {af/sup2/aferrortxt.i 'AF' '17' '?' '?' "'Invalid User ID or Password'"}.
        RETURN.
    END.
    
    /* Check the password */
    IF pcPassword <> gsm_user.user_password 
    THEN DO:
        ASSIGN pcError = {af/sup2/aferrortxt.i 'AF' '17' '?' '?' "'Invalid User ID or Password'"}.
        RETURN "password_failed":U. /* If called from checkUser, we need to increment password fail counts etc. */
    END.
    
    /* If this is a security group, we can't log into it */
    IF gsm_user.security_group
    THEN DO:
        ASSIGN pcError = {af/sup2/aferrortxt.i 'AF' '17' '?' '?' "'Invalid User ID or Password'"}.
        RETURN.
    END.
    
    /* Check if the user disabled */
    IF gsm_user.DISABLED
    THEN DO:
        ASSIGN pcError = {af/sup2/aferrortxt.i 'AF' '17' '?' '?' "'User account is disabled, contact System Administrator'"}.
        RETURN.
    END.
    
    /* Check if the user category for the user is disabled */
    FIND FIRST gsm_user_category NO-LOCK
         WHERE gsm_user_category.user_category_obj = gsm_user.user_category_obj
         NO-ERROR.
    
    IF AVAILABLE gsm_user_category AND gsm_user_category.DISABLED
    THEN DO:
        ASSIGN pcError = {af/sup2/aferrortxt.i 'AF' '17' '?' '?' "'User category is disabled, contact System Administrator'"}.
        RETURN.
    END.
    
    ASSIGN pcError = "":U.
&ENDIF

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cacheContainerSecurity) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cacheContainerSecurity Procedure 
PROCEDURE cacheContainerSecurity :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PRIVATE
     Purpose: Caches all the security for a given container in one call.
  Parameters: pcContainerName - the name of the container to secure. Mandatory.
              pcRunAttribute  - the run attribute for the running instance of the container.
              pcMenuStructure - CSV of menu structures to secure
              pcMenuItem      - CSV of menu items to secure                           
       Notes: * This API caches the security information for a container on the client.
                it does not 
              * Generally used by generated objects. Dynamic objects perform
                their security on the server, so there's no need to cache the
                security for each object on the client.
------------------------------------------------------------------------------*/
    define input parameter pcContainerName        as character            no-undo.
    define input parameter pcRunAttribute         as character            no-undo.
    define input parameter pcMenuStructure        as character            no-undo.
    define input parameter pcMenuItem             as character            no-undo.
    
    define variable cCheckType            as character               no-undo.
    define variable cItemList             as character               no-undo.
    define variable cStructureList        as character               no-undo.
    define variable cEntry                as character               no-undo.
    define variable cSecuredFields        as character               no-undo.
    define variable cSecuredTokens        as character               no-undo.
    define variable cItemHidden           as character               no-undo.
    define variable cItemDisabled         as character               no-undo.
    define variable cStructureHidden      as character               no-undo.           
    define variable iLoop                 as integer                 no-undo.
    define variable dObjectObj            as decimal                 no-undo.
    define variable lObjectSecured        as logical                 no-undo.
    
    /* Security is cached if:
        - client session in an AppServer/GUI environment
        - client session in DB-aware/GUI environment.
           don't cache:
           - on webspeed client
           - on AppServer.
          
          This code should only execute if the security information needs
          to be cached. There's no point in executing it if the current 
          session doesn't support caching.        
     */
    if not (session:remote or session:client-type eq 'Webspeed') then
    do:
        /* Validate container name */
        if pcContainerName eq ? or pcContainerName eq '' then
            return error {aferrortxt.i 'AF' '5' '?' '?' '"container being secured"'}.
        
            /* Check what's already cached. Only retrieve across the A/S            
               that which is not cached. Build the secured lists for
               those cached data.
               ============================================================
             */
        
        /* Find out what needs caching */
        if not can-find(ttObjectSecurityCheck where
                        ttObjectSecurityCheck.cObjectName = pcContainerName) then
            cCheckType = 'Object'.
        
        if not can-find(first ttFieldSecurityCheck where
                              ttFieldSecurityCheck.cObjectName = pcContainerName and
                              ttFieldSecurityCheck.cAttributeCode = pcRunAttribute ) then
            cCheckType = cCheckType + ',Field'.
        
        if not can-find(first ttTokenSecurityCheck where
                              ttTokenSecurityCheck.cObjectName = pcContainerName and
                              ttTokenSecurityCheck.cAttributeCode = pcRunAttribute ) then
            cCheckType = cCheckType + ',Token'.
        
        do iLoop = 1 to num-entries(pcMenuItem):
            cEntry = entry(iLoop, pcMenuItem).
            
            if not can-find(first ttMenuSecurity where
                                  ttMenuSecurity.cName     = cEntry and
                                  ttMenuSecurity.cMenuType = 'Item' ) then
                cItemList = cItemList + ',' + cEntry.
        end.    /* item loop */
        if cItemList ne '' then
            cCheckType = cCheckType + ',MenuItem'.
        
        /* Determine which structures are secured */
        do iLoop = 1 to num-entries(pcMenuStructure):
            cEntry = entry(iLoop, pcMenuStructure).
            
            if not can-find(first ttMenuSecurity where
                                  ttMenuSecurity.cName     = cEntry and
                                  ttMenuSecurity.cMenuType = 'Structure' ) then
                cStructureList = cStructureList + ',' + cEntry.
        end.    /* structure loop */
        if cStructureList ne '' then
            cCheckType = cCheckType + ',MenuStructure'.
        
        /* Cleanup lists */
        assign cCheckType = left-trim(cCheckType, ',')
               cItemList = left-trim(cItemList, ',')
               cStructureList = left-trim(cStructureList, ',').        
    
            &if defined(server-side) eq 0 &then
            /* Only go and get something if needed. */
        if cCheckType ne '' then
        do:
            run af/app/afsecccsep.p on gshAstraAppServer (input  pcContainerName,
                                                          input  pcRunAttribute,
                                                          input  cStructureList,
                                                          input  cItemList,
                                                          input  cCheckType,
                                                          output lObjectSecured,
                                                          output dObjectObj,
                                                          output cSecuredFields,
                                                          output cSecuredTokens,
                                                          output cItemHidden,
                                                          output cItemDisabled,
                                                          output cStructureHidden        ) no-error.
            if error-status:error or return-value ne '' then return error return-value.
            
            /* Only cache stuff if this is a client-side session. The individual API calls will
               decide whether to cache stuff or not.
             */
                    
            /* Cache object security */
            if can-do(cCheckType, 'Object') then
            do:
                create ttObjectSecurityCheck.
                assign ttObjectSecurityCheck.cObjectName = pcContainerName
                       ttObjectSecurityCheck.dObjectObj  = dObjectObj
                       ttObjectSecurityCheck.lRestricted = lObjectSecured.        
            end.    /* cache object security */
                    
            /* Cache field security */
            if can-do(cCheckType, 'Field') then
            do:
                create ttFieldSecurityCheck.
                assign ttFieldSecurityCheck.cObjectName      = pcContainerName
                       ttFieldSecurityCheck.cAttributeCode   = pcRunAttribute
                       ttFieldSecurityCheck.cSecurityOptions = cSecuredFields.
            end.    /* cache field security */
                    
            /* Cache token/action security */
            if can-do(cCheckType, 'Token') then
            do:
                create ttTokenSecurityCheck.
                assign ttTokenSecurityCheck.cObjectName      = pcContainerName
                       ttTokenSecurityCheck.cAttributeCode   = pcRunAttribute
                       ttTokenSecurityCheck.cSecurityOptions = cSecuredTokens.
            end.    /* cache token security */
            
            if can-do(cCheckType, 'MenuStructure') then
            do:
                do iLoop = 1 to num-entries(cStructureList):
                    cEntry = entry(iLoop, cStructureList).
                            
                    create ttMenuSecurity.
                    assign ttMenuSecurity.cName           = cEntry
                           ttMenuSecurity.cMenuType       = "Structure"
                           ttMenuSecurity.cSecurityOption = "Hidden" when can-do(cStructureHidden, cEntry).
                end.    /* structure loop */        
            end.    /* cache menu structure security */
                                            
            if can-do(cCheckType, 'MenuItem') then
            do:
                do iLoop = 1 to num-entries(cItemList):
                    cEntry = entry(iLoop, cItemList).
                    
                    create ttMenuSecurity.
                    assign ttMenuSecurity.cName           = cEntry
                           ttMenuSecurity.cMenuType       = "Item"
                           ttMenuSecurity.cSecurityOption = "Hidden" when can-do(cItemHidden, cEntry)
                           ttMenuSecurity.cSecurityOption = ttMenuSecurity.cSecurityOption
                                                          + ",Disabled" when can-do(cItemDisabled, cEntry)
                           ttMenuSecurity.cSecurityOption = left-trim(ttMenuSecurity.cSecurityOption, ',').
                end.    /* item loop */
            end.    /* cache menu item security */    
        end.    /* check type is non-blank (get something) */
        &else
        /* Since we're in a DB-bound session, each of these security check calls
           will do its own caching, so we don't need to do that in this API.
         */
        if can-do(cCheckType, 'Object') then
        do:
            run objectSecurityCheck (input-output pcContainerName,
                                     input-output dObjectObj,
                                           output lObjectSecured ) no-error.
            if error-status:error or return-value ne '' then return error return-value.
        end.    /* secure object */
        
        /* Bundle Field and Token/Action security into one call */
        if can-do(cCheckType, 'Field') or can-do(cCheckType, 'Token') then    
        do:
            run fieldAndTokenSecurityCheck (input  pcContainerName,
                                            input  pcRunAttribute,
                                            input  can-do(cCheckType, 'Field'),  /* check field sec? */
                                            input  can-do(cCheckType, 'Token'),  /* check token sec? */
                                            output cSecuredFields,
                                            output cSecuredTokens  ) no-error.
            if error-status:error or return-value ne '' then return error return-value.
        end.    /* field and token security */
            
        /* Bundle menu item and structure security into one call */
        if can-do(cCheckType, 'MenuStructure') or can-do(cCheckType, 'MenuItem') then
        do:
            run menuItemStructureSecurityCheck (input  pcMenuItem,
                                                input  pcMenuStructure,
                                                output cItemHidden,
                                                output cItemDisabled,
                                                output cStructureHidden ) no-error.
            if error-status:error or return-value ne '' then return error return-value.
        end.    /* item or structure security */
    &endif
    end.    /* caching client session */
    
    /* Go home happy that all is now cached .... */
    
    error-status:error = no.
    return.
END PROCEDURE.    /* cacheContainerSecurity */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cacheGlobalSecurityAllocations) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cacheGlobalSecurityAllocations Procedure 
PROCEDURE cacheGlobalSecurityAllocations :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF DEFINED(server-side) <> 0 &THEN
EMPTY TEMP-TABLE ttGlobalSecurityAllocation.

DEFINE BUFFER gsm_user_allocation FOR gsm_user_allocation.

FOR EACH gsm_user_allocation NO-LOCK
   WHERE gsm_user_allocation.user_obj = 0:
    
    CREATE ttGlobalSecurityAllocation.
    BUFFER-COPY gsm_user_allocation TO ttGlobalSecurityAllocation.
END.
&ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cacheGlobalSecurityStructures) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cacheGlobalSecurityStructures Procedure 
PROCEDURE cacheGlobalSecurityStructures :
/*------------------------------------------------------------------------------
  Purpose:     Caches all global security structures at session startup.  We can
               then use the cached data instead of reading these records from the
               database repeatedly.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF DEFINED(server-side) <> 0 &THEN
DEFINE BUFFER gsm_security_structure FOR gsm_security_structure.
DEFINE BUFFER gsm_field              FOR gsm_field.
DEFINE BUFFER gsm_token              FOR gsm_token.

EMPTY TEMP-TABLE ttGlobalSecurityStructure.

/* Global structures */
FOR EACH gsm_security_structure NO-LOCK
   WHERE gsm_security_structure.product_module_obj     = 0
     AND gsm_security_structure.object_obj             = 0
     AND gsm_security_structure.instance_attribute_obj = 0
     AND gsm_security_structure.DISABLED               = NO:

    CREATE ttGlobalSecurityStructure.
    BUFFER-COPY gsm_security_structure TO ttGlobalSecurityStructure.

    CASE ttGlobalSecurityStructure.owning_entity_mnemonic:
        WHEN "GSMFF":U 
        THEN DO:
            FIND gsm_field NO-LOCK
                 WHERE gsm_field.field_obj = ttGlobalSecurityStructure.owning_obj
                 NO-ERROR.

            IF AVAILABLE gsm_field THEN
                ASSIGN ttGlobalSecurityStructure.security_object_name = gsm_field.field_name.
            ELSE
                DELETE ttGlobalSecurityStructure.
        END.

        WHEN "GSMTO":U 
        THEN DO:
            FIND gsm_token NO-LOCK
                 WHERE gsm_token.token_obj = ttGlobalSecurityStructure.owning_obj
                 NO-ERROR.

            IF AVAILABLE gsm_token THEN
                ASSIGN ttGlobalSecurityStructure.security_object_name = gsm_token.token_code.
            ELSE
                DELETE ttGlobalSecurityStructure.
        END.
    END CASE.
END.

/* Product module structures */
FOR EACH gsm_security_structure NO-LOCK
   WHERE gsm_security_structure.product_module_obj    <> 0
     AND gsm_security_structure.object_obj             = 0
     AND gsm_security_structure.instance_attribute_obj = 0
     AND gsm_security_structure.DISABLED               = NO:

    CREATE ttGlobalSecurityStructure.
    BUFFER-COPY gsm_security_structure TO ttGlobalSecurityStructure.

    CASE ttGlobalSecurityStructure.owning_entity_mnemonic:
        WHEN "GSMFF":U 
        THEN DO:
            FIND gsm_field NO-LOCK
                 WHERE gsm_field.field_obj = ttGlobalSecurityStructure.owning_obj
                 NO-ERROR.

            IF AVAILABLE gsm_field THEN
                ASSIGN ttGlobalSecurityStructure.security_object_name = gsm_field.field_name.
            ELSE
                DELETE ttGlobalSecurityStructure.
        END.

        WHEN "GSMTO":U 
        THEN DO:
            FIND gsm_token NO-LOCK
                 WHERE gsm_token.token_obj = ttGlobalSecurityStructure.owning_obj
                 NO-ERROR.

            IF AVAILABLE gsm_token THEN
                ASSIGN ttGlobalSecurityStructure.security_object_name = gsm_token.token_code.
            ELSE
                DELETE ttGlobalSecurityStructure.
        END.
    END CASE.
END.

&ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-changePassword) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changePassword Procedure 
PROCEDURE changePassword :
/*------------------------------------------------------------------------------
  Purpose:     To change a users password, doing all relevant checks in password
               history, etc.
  Parameters:  input user object number if known
               input user login name if known
               input old password (encoded)
               input new password (encoded)
               input password expired flag
               input number of password characters entered in new password
               output failure reason (standard Astra formatted error)
  Notes:       This procedure first checks the passed in user is valid and
               not disabled (either on user record or user category record).
               The procedure first validates the old password is correct
               similar to the checkUser procedure and returns an error if not.
               Providing the old password is OK, the new password is then 
               validated according to the rules set up on the system / user
               record. It checks password minimum length, the password history if
               enabled, etc.
               If all is ok, the new password is saved for the user and appropriate
               user details updated. If the password was expired, the expiry details
               are reset.

------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER  pdUserObj                     AS DECIMAL    NO-UNDO.
DEFINE INPUT PARAMETER  pcLoginName                   AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcOldPassword                 AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcNewPassword                 AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  plExpired                     AS LOGICAL    NO-UNDO.
DEFINE INPUT PARAMETER  piLength                      AS INTEGER    NO-UNDO.
DEFINE OUTPUT PARAMETER pcError                       AS CHARACTER  NO-UNDO.

&IF DEFINED(server-side) = 0 &THEN
    RUN af/app/afsecchgpwdp.p ON gshAstraAppServer
      (INPUT pdUserObj,
       INPUT pcLoginName,
       INPUT pcOldPassword,
       INPUT pcNewPassword,
       INPUT plExpired,
       INPUT piLength,
       OUTPUT pcError) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
        RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                        ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
&ELSE
    DEFINE BUFFER bgsm_user FOR gsm_user.
    
    DEFINE VARIABLE iPasswordMaxRetries      AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iPasswordHistoryLifeTime AS INTEGER   NO-UNDO.
    DEFINE VARIABLE pcText                   AS CHARACTER NO-UNDO.
    
    IF NOT CAN-FIND(FIRST ttSecurityControl) 
    THEN DO:
        RUN getSecurityControl IN TARGET-PROCEDURE (OUTPUT TABLE ttSecurityControl).
        FIND FIRST ttSecurityControl NO-ERROR.
    END.
    
    IF pdUserObj <> 0 THEN
        FIND FIRST gsm_user NO-LOCK
             WHERE gsm_user.USER_obj = pdUserObj
             NO-ERROR.
    ELSE IF pcLoginName <> "":U THEN
             FIND FIRST gsm_user NO-LOCK
                  WHERE gsm_user.USER_login_name = pcLoginName
                  NO-ERROR.
    
    IF NOT AVAILABLE gsm_user 
    THEN DO:
        ASSIGN pcError = {af/sup2/aferrortxt.i 'AF' '36' '?' '?' "'user password'" "'the user specified is invalid'"}.
        RETURN.
    END.
    
    /* see if account / categort disabled */
    IF gsm_user.DISABLED 
    THEN DO:
        ASSIGN pcError = {af/sup2/aferrortxt.i 'AF' '36' '?' '?' "'user password'" "'the user account is disabled, contact System Administrator'"}.
        RETURN.
    END.
    
    FIND FIRST gsm_user_category NO-LOCK
         WHERE gsm_user_category.user_category_obj = gsm_user.user_category_obj
         NO-ERROR.
    
    IF AVAILABLE gsm_user_category AND gsm_user_category.DISABLED 
    THEN DO:
        ASSIGN pcError = {af/sup2/aferrortxt.i 'AF' '36' '?' '?' "'user password'" "'the user category is disabled, contact System Administrator'"}.
        RETURN.
    END.
    
    /* check max. retries allowed for password */
    FIND FIRST gsc_security_control NO-LOCK NO-ERROR.
    IF AVAILABLE gsc_security_control THEN
        ASSIGN iPasswordMaxRetries      = gsc_security_control.password_max_retries
               iPasswordHistoryLifeTime = gsc_security_control.password_history_life_time.
    ELSE
        ASSIGN iPasswordMaxRetries      = 0
               iPasswordHistoryLifeTime = 0.
    
    ASSIGN pcError = "":U.
    /* check old password if necessary */
    IF pcOldPassword <> gsm_user.user_password THEN
    trn-block:
    DO FOR bgsm_user TRANSACTION ON ERROR UNDO trn-block, LEAVE trn-block:
    
        ASSIGN pcError = {af/sup2/aferrortxt.i 'AF' '36' '?' '?' "'user password'" "'Invalid existing user password specified'"}.
    
        FIND FIRST bgsm_user EXCLUSIVE-LOCK
             WHERE bgsm_user.user_obj = gsm_user.user_obj
             NO-ERROR.
    
        IF NOT AVAILABLE bgsm_user THEN
            UNDO trn-block, LEAVE trn-block.
    
        ASSIGN bgsm_user.password_fail_count = bgsm_user.password_fail_count + 1
               bgsm_user.password_fail_date = TODAY
               bgsm_user.password_fail_time = TIME.
    
        IF iPasswordMaxRetries > 0 AND bgsm_user.password_fail_count > iPasswordMaxRetries THEN
            ASSIGN bgsm_user.disabled            = YES
                   bgsm_user.password_fail_count = 0
                   pcError                       = {af/sup2/aferrortxt.i 'AF' '17' '?' '?' "'Maximum password retries exceeded, user account has been disabled'"}.
        VALIDATE bgsm_user NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
            UNDO trn-block, LEAVE trn-block.
    END.
    IF pcError <> "":U THEN RETURN.
    
    /* If get here - old password is ok so update user details */
    trn-block2:
    DO FOR bgsm_user TRANSACTION ON ERROR UNDO trn-block2, LEAVE trn-block2:
    
      FIND FIRST bgsm_user EXCLUSIVE-LOCK
           WHERE bgsm_user.user_obj = gsm_user.user_obj
           NO-ERROR.
    
      IF NOT AVAILABLE bgsm_user THEN
          UNDO trn-block2, LEAVE trn-block2.
    
      ASSIGN bgsm_user.password_fail_count = 0
             bgsm_user.password_fail_date  = ?
             bgsm_user.password_fail_time  = 0
             bgsm_user.last_login_date     = TODAY 
             bgsm_user.last_login_time     = TIME
             bgsm_user.disabled            = NO.
    
      VALIDATE bgsm_user NO-ERROR.
      IF ERROR-STATUS:ERROR THEN
          UNDO trn-block2, LEAVE trn-block2.
    END.
    
    /* now validate new password */
    IF gsm_user.password_minimum_length > 0 
    AND piLength < gsm_user.password_minimum_length 
    THEN DO:
        ASSIGN pcText  = "password must be at least " + STRING(gsm_user.password_minimum_length) + " characters":U
               pcError = {af/sup2/aferrortxt.i 'AF' '36' '?' '?' "'user password'" pcText}.
        RETURN.
    END.
    
    IF gsm_user.user_password =  pcNewPassword 
    THEN DO:
        ASSIGN pcError = {af/sup2/aferrortxt.i 'AF' '36' '?' '?' "'user password'" "'you cannot use the same password'"}.
        RETURN.
    END.
    
    IF gsm_user.check_password_history = YES AND LENGTH(pcNewPassword) > 0 
    AND CAN-FIND(FIRST gst_password_history
                 WHERE gst_password_history.user_obj              = gsm_user.user_obj
                   AND gst_password_history.password_change_date >= (TODAY - iPasswordHistoryLifeTime)
                   AND gst_password_history.old_password          = pcNewPassword) 
    THEN DO:             
      ASSIGN pcText  = "the same password cannot be used within " + (IF iPasswordHistoryLifeTime > 0 THEN STRING(iPasswordHistoryLifeTime) ELSE "unlimited":U) + " days":U
             pcError = {af/sup2/aferrortxt.i 'AF' '36' '?' '?' "'user password'" pcText}.
      RETURN.
    END.
    
    /* check if password unique */
    IF AVAILABLE ttSecurityControl AND ttSecurityControl.force_unique_password = YES 
    THEN DO:
        IF piLength = 0 /* Don't allow blanks if unique is enforced */
        OR CAN-FIND(FIRST bgsm_user
                    WHERE ENCODE(bgsm_user.user_password) = pcNewPassword
                      AND bgsm_user.user_obj             <> gsm_user.user_obj) 
        THEN DO:         
            ASSIGN pcError = {af/sup2/aferrortxt.i 'GS' '11'}.
            RETURN.
        END.
    END.    
    
    /* if get here - we can actually update the user with the new password */
    trn-block3:
    DO FOR bgsm_user TRANSACTION ON ERROR UNDO trn-block3, LEAVE trn-block3:
    
      FIND FIRST bgsm_user EXCLUSIVE-LOCK
           WHERE bgsm_user.user_obj = gsm_user.user_obj
           NO-ERROR.
    
      IF NOT AVAILABLE bgsm_user 
      THEN DO:
          ASSIGN pcError = {af/sup2/aferrortxt.i 'AF' '36' '?' '?' "'user password'" "'user record is not available'"}.
          UNDO trn-block3, LEAVE trn-block3.
      END.
    
      ASSIGN bgsm_user.user_password = pcNewPassword.
    
      IF plExpired THEN
          ASSIGN bgsm_user.password_preexpired  = NO
                 bgsm_user.password_expiry_date = TODAY
                                                + (IF bgsm_user.password_expiry_days > 0 THEN bgsm_user.password_expiry_days ELSE 30).
      VALIDATE bgsm_user NO-ERROR.
      IF ERROR-STATUS:ERROR 
      THEN DO:
          ASSIGN pcError = RETURN-VALUE.
          UNDO trn-block3, LEAVE trn-block3.
      END.
    END.    
&ENDIF

RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-checkUser) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkUser Procedure 
PROCEDURE checkUser :
/*------------------------------------------------------------------------------
  Purpose:     This procedure authenticates passed in user / company, etc.
  Parameters:  input user login name
               input encoded user password
               input login company obj specified
               input language obj specified
               output login user object number
               output user full name
               output user email
               output organisation code
               output organisation name
               output organisation short name
               output language name
               output failure reason (standard Astra formatted error)
  Notes:       This procedure does not cache as we always want the very
               latest information, i.e. how many times they have failed
               to enter the correct password.
               The following checks are made on the user details entered:
               1. We check if this is a valid user and if not, we return an
               error stating that an invalid login name was specified.
               2. We check if the account has been disabled, and return an
               error if it has.
               3. We check the category of user and see if this category of
               user has been disabled - returning an error if so.
               4. If in AstraGen, we check the login company specified is a
               valid login company. We then check if the user has access to the
               login company, and if not, return an errr.
               5. If in AstraGen, we also check whether the user has restricted
               access to any login companies. If they have restricted access to
               any companies at all, then they must log into the system with a 
               valid company and the <none> option is not available to them. This
               is very useful when letting external clients into your application
               to prevent them seeing other clients information.
               6. If multi-user checking is enabled, we see if the user is already
               logged in and prevent login if so.
               7. We then check the password entered is valid for the user if indeed
               a password was entered. If the password is not valid, then the fail
               count is updated on the user record, and if this exceeds the maximum
               retries, the account will be additionally disabled and the retries
               reset back to 0.
               8. If a valid password is entered, the fail count should be reset, and
               the login details updated on the user.
               9. If the user password has expired, then we need to return this fact
               back to the login window so that it can prompt for a new password
               before proceeding with the login. If this fails, the login will be
               aborted.
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER  pcLoginName                   AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcPassword                    AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pdCompanyObj                  AS DECIMAL    NO-UNDO.
DEFINE INPUT PARAMETER  pdLanguageObj                 AS DECIMAL    NO-UNDO.
DEFINE OUTPUT PARAMETER pdUserObj                     AS DECIMAL    NO-UNDO.
DEFINE OUTPUT PARAMETER pcUserName                    AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcUserEmail                   AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcOrganisationCode            AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcOrganisationName            AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcOrganisationShort           AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcLanguageName                AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcError                       AS CHARACTER  NO-UNDO.

&IF DEFINED(server-side) = 0 &THEN
    RUN af/app/afsecchkusrp.p ON gshAstraAppServer
      (INPUT  pcLoginName,
       INPUT  pcPassword,
       INPUT  pdCompanyObj,
       INPUT  pdLanguageObj,
       OUTPUT pdUserObj,
       OUTPUT pcUserName,
       OUTPUT pcUserEmail,
       OUTPUT pcOrganisationCode,
       OUTPUT pcOrganisationName,
       OUTPUT pcOrganisationShort,
       OUTPUT pcLanguageName,
       OUTPUT pcError) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
        RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                        ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
&ELSE    
    DEFINE VARIABLE lSecurityRestricted AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE cSecurityValue1     AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cSecurityValue2     AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE iPasswordMaxRetries AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cDefaultHelpFile    AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cDummy              AS CHARACTER  NO-UNDO.
    
    DEFINE BUFFER gsc_security_control FOR gsc_security_control.
    DEFINE BUFFER bgsm_user            FOR gsm_user.
    DEFINE BUFFER gsm_user_category    FOR gsm_user_category.
    DEFINE BUFFER gsm_user_allocation  FOR gsm_user_allocation.
    DEFINE BUFFER gsm_user             FOR gsm_user.
    DEFINE BUFFER gsm_login_company    FOR gsm_login_company.
    
    /* 1st check user is valid */
    FIND FIRST gsm_user NO-LOCK
         WHERE gsm_user.user_login_name = pcLoginName
         NO-ERROR.
    
    IF NOT AVAILABLE gsm_user
    THEN DO:
        ASSIGN pcError = {af/sup2/aferrortxt.i 'AF' '17' '?' '?' "'Invalid User ID or Password'"}.
        RETURN.
    END.
    
    /* If this is a security group, we can't log into it */
    IF gsm_user.security_group
    THEN DO:
        ASSIGN pcError = {af/sup2/aferrortxt.i 'AF' '17' '?' '?' "'Invalid User ID or Password'"}.
        RETURN.
    END.
    
    /* See if account / category disabled */
    IF gsm_user.DISABLED
    THEN DO:
        ASSIGN pcError = {af/sup2/aferrortxt.i 'AF' '17' '?' '?' "'User account is disabled, contact System Administrator'"}.
        RETURN.
    END.
    
    FIND FIRST gsm_user_category NO-LOCK
         WHERE gsm_user_category.user_category_obj = gsm_user.user_category_obj
         NO-ERROR.
    
    IF AVAILABLE gsm_user_category AND gsm_user_category.DISABLED 
    THEN DO:
        ASSIGN pcError = {af/sup2/aferrortxt.i 'AF' '17' '?' '?' "'User category is disabled, contact System Administrator'"}.
        RETURN.
    END.
    
    /* Check max. retries allowed for password */
    FIND FIRST gsc_security_control NO-LOCK NO-ERROR.
    
    IF AVAILABLE gsc_security_control THEN
        ASSIGN iPasswordMaxRetries = gsc_security_control.password_max_retries.
    ELSE
        ASSIGN iPasswordMaxRetries = 0.
    
    ASSIGN pcError = "":U.
    
    IF pcPassword <> gsm_user.user_password THEN
    trn-block:
    DO FOR bgsm_user TRANSACTION ON ERROR UNDO trn-block, LEAVE trn-block:
    
      ASSIGN pcError = {af/sup2/aferrortxt.i 'AF' '17' '?' '?' "'Invalid User ID or Password'"}.
    
      FIND FIRST bgsm_user EXCLUSIVE-LOCK 
           WHERE bgsm_user.user_obj = gsm_user.user_obj
           NO-ERROR.
    
      IF NOT AVAILABLE bgsm_user THEN
        UNDO trn-block, LEAVE trn-block.
    
      ASSIGN bgsm_user.password_fail_count = bgsm_user.password_fail_count + 1
             bgsm_user.password_fail_date  = TODAY
             bgsm_user.password_fail_time  = TIME.
    
      IF iPasswordMaxRetries > 0 AND bgsm_user.password_fail_count > iPasswordMaxRetries THEN
        ASSIGN bgsm_user.disabled            = YES
               bgsm_user.password_fail_count = 0
               pcError                       = {af/sup2/aferrortxt.i 'AF' '17' '?' '?' "'Maximum password retries exceeded, user account has been disabled'"}.
    
      VALIDATE bgsm_user NO-ERROR.
      IF ERROR-STATUS:ERROR THEN
          UNDO trn-block, LEAVE trn-block.
    END.
    IF pcError <> "":U THEN RETURN.
    
    /* Check user has access to login company specified */
    IF pdCompanyObj <> 0 
    THEN DO:
        FIND FIRST gsm_login_company NO-LOCK
             WHERE gsm_login_company.login_company_obj = pdCompanyObj
             NO-ERROR.
    
        IF NOT AVAILABLE gsm_login_company THEN
            ASSIGN pdCompanyObj = 0.
    END.
    
    /* We need to set the currentUserObj and LoginCompanyObj properties for security.  We need these        * 
     * to be able to set all the security properties.  Seeing as we're checking login company security next *
     * we HAVE to set all these properties here.                                                            */
    DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager,INPUT "currentUserObj,currentOrganisationObj",
                                                              INPUT STRING(gsm_user.user_obj) + CHR(3) + STRING(pdCompanyObj),
                                                              INPUT YES).
    
    /* Now that the session knows who the user is and what the company is, set all the security properties. */
    RUN setSecurityProperties IN TARGET-PROCEDURE (OUTPUT cDummy,  /* We'd usually get the security property names here... */
                                                   OUTPUT cDummy). /* ...and their values here, but we don't need them     */
    
    /* Check if the user is allowed to log in to the specified company. */
    IF pdCompanyObj <> 0 AND AVAILABLE gsm_login_company 
    THEN DO:
        ASSIGN lSecurityRestricted = YES.
        RUN userSecurityCheck IN TARGET-PROCEDURE (INPUT gsm_user.user_obj,
                                                   INPUT 0,                      /* All companies */
                                                   INPUT "gsmlg":U,              /* login company FLA */
                                                   INPUT gsm_login_company.login_company_obj,
                                                   INPUT NO,                     /* Return security values - NO */
                                                   OUTPUT lSecurityRestricted,   /* Restricted yes/no ? */
                                                   OUTPUT cSecurityValue1,       /* clearance value 1 */
                                                   OUTPUT cSecurityValue2).      /* clearance value 2 */
        IF lSecurityRestricted
        THEN DO:
            ASSIGN pcError = {af/sup2/aferrortxt.i 'AF' '17' '?' '?' "'User specified does not have access to selected company'"}.
            RETURN.
        END.
    END.
    ELSE DO:
        /* ensure ok to login with empty company - i.e. ensure no company restrictions exist */
        ASSIGN lSecurityRestricted = YES.
        RUN userSecurityCheck IN TARGET-PROCEDURE (INPUT gsm_user.user_obj,
                                                   INPUT 0,                      /* All companies */
                                                   INPUT "gsmlg":U,              /* login company FLA */
                                                   INPUT 0,
                                                   INPUT NO,                     /* Return security values - NO */
                                                   OUTPUT lSecurityRestricted,   /* Restricted yes/no ? */
                                                   OUTPUT cSecurityValue1,       /* clearance value 1 */
                                                   OUTPUT cSecurityValue2).      /* clearance value 2 */
        IF lSecurityRestricted
        THEN DO:
            ASSIGN pcError = {af/sup2/aferrortxt.i 'AF' '17' '?' '?' "'This user must log into a specific company'"}.
            RETURN.
        END.
    END.
    
    /* if get here, all is ok, so update user details */
    trn-block2:
    DO FOR bgsm_user TRANSACTION ON ERROR UNDO trn-block2, LEAVE trn-block2:
    
      FIND FIRST bgsm_user EXCLUSIVE-LOCK 
           WHERE bgsm_user.user_obj = gsm_user.user_obj
           NO-ERROR.
    
      IF NOT AVAILABLE bgsm_user THEN
          UNDO trn-block2, LEAVE trn-block2.
    
      ASSIGN bgsm_user.password_fail_count = 0
             bgsm_user.password_fail_date  = ?
             bgsm_user.password_fail_time  = 0
             bgsm_user.last_login_date     = TODAY 
             bgsm_user.last_login_time     = TIME
             bgsm_user.disabled            = NO.
      VALIDATE bgsm_user NO-ERROR.
    
      IF ERROR-STATUS:ERROR THEN
          UNDO trn-block2, LEAVE trn-block2.
    END.
    
    /* finally check if password expired and if so, return "expired" in error to indicate *
     * to caller that password must be changed.                                           */
    IF gsm_user.password_preexpired OR
       (gsm_user.password_expiry_date <> ? AND
        gsm_user.password_expiry_date < TODAY) OR
       (gsm_user.password_expiry_date = TODAY AND
        gsm_user.password_expiry_time <= TIME) THEN
      ASSIGN pcError = "expired":U.
    
    /* pass back rest of details */  
    IF pdLanguageObj <> 0 THEN 
        FIND FIRST gsc_language NO-LOCK
             WHERE gsc_language.LANGUAGE_obj = pdLanguageObj
             NO-ERROR.
    
    ASSIGN pdUserObj   = gsm_user.USER_obj
           pcUserName  = gsm_user.USER_full_name
           pcUserEmail = gsm_user.USER_email_address.
    
    IF AVAILABLE gsm_login_company THEN
      ASSIGN pcOrganisationCode  = gsm_login_company.login_company_code
             pcOrganisationName  = gsm_login_company.login_company_name
             pcOrganisationShort = gsm_login_company.login_company_short_name.
    
    IF AVAILABLE gsc_language THEN
      ASSIGN pcLanguageName = gsc_language.LANGUAGE_name.
&ENDIF

RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-clearClientCache) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearClientCache Procedure 
PROCEDURE clearClientCache :
/*------------------------------------------------------------------------------
  Purpose:     To empty client cache temp-tables to ensure the database is accessed
               again to retrieve up-to-date information. This may be called when 
               security maintennance programs have been run. The procedure prevents
               having to log off and start a new session in order to use the new
               security settings.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) 
THEN DO:
    DEFINE VARIABLE cDummy AS CHARACTER  NO-UNDO.

    EMPTY TEMP-TABLE ttUserSecurityCheck.
    EMPTY TEMP-TABLE ttFieldSecurityCheck.
    EMPTY TEMP-TABLE ttTokenSecurityCheck.
    EMPTY TEMP-TABLE ttRangeSecurityCheck.
    EMPTY TEMP-TABLE ttTableSecurityCheck.
    EMPTY TEMP-TABLE ttSecurityControl.
    EMPTY TEMP-TABLE ttMenuSecurity.

    ASSIGN gcCacheSystemIcon      = "":U
           gcCacheSmallSystemIcon = "":U.

    /* Now recache global security structures and allocations */
    RUN cacheGlobalSecurityAllocations IN TARGET-PROCEDURE.
    RUN cacheGlobalSecurityStructures  IN TARGET-PROCEDURE.

    /* ...and reset security properties */
    RUN setSecurityProperties IN TARGET-PROCEDURE (OUTPUT cDummy,  /* Security properties */
                                                   OUTPUT cDummy). /* Security property values */
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createGroupAllocation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createGroupAllocation Procedure 
PROCEDURE createGroupAllocation :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pdUserObj               AS DECIMAL   NO-UNDO.
DEFINE INPUT  PARAMETER pdGroupObj              AS DECIMAL   NO-UNDO.

  &IF DEFINED(server-side) = 0 &THEN
      RUN af/app/afseccrtgrpallocp.p ON gshAstraAppServer
        (INPUT  pdUserObj,
         INPUT  pdGroupObj) NO-ERROR.
      IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
          RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                          ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
  &ELSE
  
    DEFINE BUFFER gsm_group_allocation FOR gsm_group_allocation.
    
    CREATE gsm_group_allocation NO-ERROR.
    
    IF RETURN-VALUE <> "":U THEN
        RETURN RETURN-VALUE.
    ELSE
        IF ERROR-STATUS:ERROR THEN
            RETURN {aferrortxt.i 'AF' '40' '' '' "'Creation of Group allocation failed, reason not known.  Please contact your System Administrator.'"}.
    
    ASSIGN gsm_group_allocation.group_user_obj     = pdGroupObj
           gsm_group_allocation.user_obj           = pdUserObj
           gsm_group_allocation.login_company_obj  = 0.
           
    VALIDATE gsm_group_allocation NO-ERROR.
    
    IF RETURN-VALUE <> "":U THEN
        RETURN RETURN-VALUE.
    ELSE
        IF ERROR-STATUS:ERROR THEN
            RETURN {aferrortxt.i 'AF' '40' '' '' "'Assignment of Group allocation values failed, reason not known.  Please contact your System Administrator.'"}.
        
  &ENDIF

  ERROR-STATUS:ERROR = NO.
  RETURN.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createGroupFromUser) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createGroupFromUser Procedure 
PROCEDURE createGroupFromUser :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER pdUserObj               AS DECIMAL   NO-UNDO.
  DEFINE INPUT  PARAMETER pcSecurityGroupName     AS CHARACTER NO-UNDO.

  &IF DEFINED(server-side) = 0 &THEN
      RUN af/app/afseccrtgrpfusrp.p ON gshAstraAppServer
        (INPUT  pdUserObj,
         INPUT  pcSecurityGroupName) NO-ERROR.
      IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
          RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                          ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
  &ELSE
  
    DEFINE BUFFER gsm_user                FOR gsm_user.
    DEFINE BUFFER b_gsm_user              FOR gsm_user.
    DEFINE BUFFER gsm_user_allocation     FOR gsm_user_allocation.
    DEFINE BUFFER b_gsm_user_allocation   FOR gsm_user_allocation.

    DEFINE VARIABLE dSecurityGroupObj     AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE lMoveAllocation       AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE dLoginOrganisation    AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE lCreateGroupLink      AS LOGICAL    NO-UNDO.

    IF CAN-FIND(FIRST gsm_user NO-LOCK WHERE gsm_user.user_login_name = pcSecurityGroupName) THEN
      RETURN {aferrortxt.i 'AF' '8' '' '' "'User Group Name'" pcSecurityGroupName "''"}.

    /* This big Transaction block is here because if there are any errors in the process
       we want to undo ALL changes made, and return the error message to the User  */
    process-block:
    DO TRANSACTION ON ERROR UNDO process-block, RETURN RETURN-VALUE:

      /* Create the New Security Group User */
      CREATE gsm_user NO-ERROR.

      IF RETURN-VALUE <> "":U THEN
          RETURN RETURN-VALUE.
      ELSE
          IF ERROR-STATUS:ERROR THEN
              RETURN {aferrortxt.i 'AF' '40' '' '' "'Creation of Security Group failed, reason not known.  Please contact your System Administrator.'"}.

      /* assign the New Security group Details */
      ASSIGN gsm_user.security_group  = YES
             gsm_user.user_full_name  = pcSecurityGroupName
             gsm_user.user_login_name = pcSecurityGroupName
             dSecurityGroupObj        = gsm_user.user_obj.

      VALIDATE gsm_user NO-ERROR.

      IF RETURN-VALUE <> "":U THEN
          RETURN RETURN-VALUE.
      ELSE
          IF ERROR-STATUS:ERROR THEN
              RETURN {aferrortxt.i 'AF' '40' '' '' "'Assignment of Security Group values failed, reason not known.  Please contact your System Administrator.'"}.

      /* Find the user that the New User Group is to be based on */
      FIND FIRST gsm_user NO-LOCK
        WHERE gsm_user.user_obj = pdUserObj NO-ERROR.

      IF NOT AVAILABLE gsm_user THEN
        RETURN {aferrortxt.i 'AF' '5' '' '' "'user'"}.

      /* link Profile user/user to the new Security Group */
      RUN createGroupAllocation (INPUT gsm_user.user_obj, INPUT dSecurityGroupObj) NO-ERROR.
      IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.

      /* If the User that the Security Group is to be based on is a Profile User, then we only want to move/copy the 
         common Security Allocations, anything that is NOT common among the users will be left alone, and not created
         for the new security group. Also we want to link all users based on this profile user to the new Security Group */
      IF gsm_user.profile_user THEN
      DO:

        FOR EACH b_gsm_user NO-LOCK
          WHERE b_gsm_user.created_from_profile_user_obj = gsm_user.user_obj:

          /* Link Profile users to the new Security Group */
          RUN createGroupAllocation (INPUT b_gsm_user.user_obj, INPUT dSecurityGroupObj) NO-ERROR.
          IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
          /* Store the Users in a temp-table for perfomance, and to decrease db hits */
          CREATE ttUser.
          ASSIGN ttUser.userObj = b_gsm_user.user_obj.

        END.

        FOR EACH gsm_user_allocation NO-LOCK
          WHERE gsm_user_allocation.user_obj = gsm_user.user_obj:

          ASSIGN lMoveAllocation = TRUE.

          /* check if this allocation is common */
          FOR EACH ttUser:

            IF NOT(CAN-FIND(FIRST b_gsm_user_allocation NO-LOCK
              WHERE b_gsm_user_allocation.login_organisation_obj = gsm_user_allocation.login_organisation_obj
                AND b_gsm_user_allocation.user_obj               = ttUser.UserObj
                AND b_gsm_user_allocation.owning_entity_mnemonic = gsm_user_allocation.owning_entity_mnemonic
                AND b_gsm_user_allocation.owning_obj             = gsm_user_allocation.owning_obj))
            THEN
              ASSIGN lMoveAllocation = FALSE.

          END.

          IF lMoveAllocation THEN
          DO:
            /* If the is allocation is common, move it to the new Security group */
            FIND FIRST b_gsm_user_allocation EXCLUSIVE-LOCK
              WHERE b_gsm_user_allocation.login_organisation_obj = gsm_user_allocation.login_organisation_obj
                AND b_gsm_user_allocation.user_obj               = gsm_user.user_obj
                AND b_gsm_user_allocation.owning_entity_mnemonic = gsm_user_allocation.owning_entity_mnemonic
                AND b_gsm_user_allocation.owning_obj             = gsm_user_allocation.owning_obj
                NO-ERROR.

            ASSIGN b_gsm_user_allocation.user_obj = dSecurityGroupObj.

            VALIDATE b_gsm_user_allocation NO-ERROR.

            IF RETURN-VALUE <> "":U THEN
                RETURN RETURN-VALUE.
            ELSE
                IF ERROR-STATUS:ERROR THEN
                    RETURN {aferrortxt.i 'AF' '40' '' '' "'Moving of Group allocations failed, reason not known.  Please contact your System Administrator.'"}.
            
            /* Delete this allocation for all users based on the profile user  */
            FOR EACH ttUser NO-LOCK:

              FIND FIRST b_gsm_user_allocation EXCLUSIVE-LOCK
                WHERE b_gsm_user_allocation.login_organisation_obj = gsm_user_allocation.login_organisation_obj
                  AND b_gsm_user_allocation.user_obj               = ttUser.UserObj
                  AND b_gsm_user_allocation.owning_entity_mnemonic = gsm_user_allocation.owning_entity_mnemonic
                  AND b_gsm_user_allocation.owning_obj             = gsm_user_allocation.owning_obj
                  NO-ERROR.

              IF NOT AVAILABLE b_gsm_user_allocation THEN
                RETURN {aferrortxt.i 'AF' '5' '' '' "'allocation'"}.

              DELETE b_gsm_user_allocation NO-ERROR.

              IF RETURN-VALUE <> "":U THEN
                  RETURN RETURN-VALUE.
              ELSE
                  IF ERROR-STATUS:ERROR THEN
                      RETURN {aferrortxt.i 'AF' '40' '' '' "'Deletion of Group allocations failed, reason not known.  Please contact your System Administrator.'"}.
            END.  /* end Delete of all User Allocations*/
          END.  /* End Move Allocations */
        END.   /* */
      END.   /* end profile User */
      ELSE
      /* if the User that the New security Group is to be based on, is NOT a profile User, then we move/copy all Security
         Allocations regardless */
      DO:
        FOR EACH gsm_user_allocation EXCLUSIVE-LOCK
          WHERE gsm_user_allocation.user_obj = gsm_user.user_obj:

          ASSIGN gsm_user_allocation.user_obj = dSecurityGroupObj.

          VALIDATE gsm_user_allocation NO-ERROR.

          IF RETURN-VALUE <> "":U THEN
              RETURN RETURN-VALUE.
          ELSE
              IF ERROR-STATUS:ERROR THEN
                  RETURN {aferrortxt.i 'AF' '40' '' '' "'Moving of Group allocations failed, reason not known.  Please contact your System Administrator.'"}.

        END.
      END.
    END. /* Undo Process-Block */

  &ENDIF

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fieldAndTokenSecurityCheck) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fieldAndTokenSecurityCheck Procedure 
PROCEDURE fieldAndTokenSecurityCheck :
/*------------------------------------------------------------------------------
  Purpose:     Does a field AND token security check for the specified object 
               together, retrieving the information in one appserver hit.
  Parameters:  pcObjectName         - current program object for security check
               pcAttributeCode      - current instance attribute posted to program
               plCheckFieldSecurity - Extract field security?
               plCheckTokenSecurity - Extract token security?
               pcFieldSecurity      - comma delimited list of secured fields, each with 2 entries. 
                                      Entry 1 = table.fieldname,
                                      Entry 2 = hidden/read-only
               pcTokenSecurity      - security options as comma delimited list of security tokens
                                      user does not have security clearance for, currently used in toolbar
                                      panel views to disable buttons and folder windows to disable
                                      folder pages, etc.
  Notes: 
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcObjectName         AS CHARACTER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcAttributeCode      AS CHARACTER    NO-UNDO.
  DEFINE INPUT  PARAMETER plCheckFieldSecurity AS LOGICAL      NO-UNDO. 
  DEFINE INPUT  PARAMETER plCheckTokenSecurity AS LOGICAL      NO-UNDO.
  DEFINE OUTPUT PARAMETER pcFieldSecurity      AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcTokenSecurity      AS CHARACTER    NO-UNDO.

  /* If client side, check local cache to see if already checked and if so use cached value */
  IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) 
  THEN DO:
      /* Field security */
      IF plCheckFieldSecurity
      THEN DO:
          FIND FIRST ttFieldSecurityCheck
               WHERE ttFieldSecurityCheck.cObjectName    = pcObjectName
                 AND ttFieldSecurityCheck.cAttributeCode = pcAttributeCode
               NO-ERROR.
    
          IF AVAILABLE ttFieldSecurityCheck THEN
              ASSIGN pcFieldSecurity      = ttFieldSecurityCheck.cSecurityOptions
                     plCheckFieldSecurity = NO.
      END.

      /* Token security */
      IF plCheckTokenSecurity 
      THEN DO:
          FIND FIRST ttTokenSecurityCheck
               WHERE ttTokenSecurityCheck.cObjectName    = pcObjectName
                 AND ttTokenSecurityCheck.cAttributeCode = pcAttributeCode
               NO-ERROR.

          IF AVAILABLE ttTokenSecurityCheck THEN
              ASSIGN pcTokenSecurity      = ttTokenSecurityCheck.cSecurityOptions
                     plCheckTokenSecurity = NO.
      END.
  END.

  IF  NOT plCheckTokenSecurity 
  AND NOT plCheckFieldSecurity THEN
      RETURN.

  /* Extract security */
  &IF DEFINED(server-side) = 0 &THEN
      RUN af/app/afsecfldtokchkp.p ON gshAstraAppServer
        (INPUT  pcObjectName,
         INPUT  pcAttributeCode,
         INPUT  plCheckFieldSecurity,
         INPUT  plCheckTokenSecurity,
         OUTPUT pcFieldSecurity,
         OUTPUT pcTokenSecurity) NO-ERROR.
      IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
          RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                          ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).

      /* Update the client cache */
      IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U)
      THEN DO:
          IF plCheckFieldSecurity
          THEN DO:
              CREATE ttFieldSecurityCheck.
              ASSIGN ttFieldSecurityCheck.cObjectName = pcObjectName
                     ttFieldSecurityCheck.cAttributeCode = pcAttributeCode
                     ttFieldSecurityCheck.cSecurityOptions = pcFieldSecurity.
          END.

          IF plCheckTokenSecurity
          THEN DO:
              CREATE ttTokenSecurityCheck.
              ASSIGN ttTokenSecurityCheck.cObjectName      = pcObjectName
                     ttTokenSecurityCheck.cAttributeCode   = pcAttributeCode
                     ttTokenSecurityCheck.cSecurityOptions = pcTokenSecurity.
          END.
      END.
  &ELSE
      /* Check field security */
      IF plCheckFieldSecurity THEN
          RUN fieldSecurityCheck IN TARGET-PROCEDURE (INPUT pcObjectName,
                                                      INPUT pcAttributeCode,
                                                      OUTPUT pcFieldSecurity).
      /* Check token security */
      IF plCheckTokenSecurity THEN
          RUN tokenSecurityCheck IN TARGET-PROCEDURE (INPUT pcObjectName,
                                                      INPUT pcAttributeCode,
                                                      OUTPUT pcTokenSecurity).
  &ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fieldSecurityCheck) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fieldSecurityCheck Procedure 
PROCEDURE fieldSecurityCheck :
/*------------------------------------------------------------------------------
  Purpose:     This procedure checks a user's security for fields permitted
               access to.
  Parameters:  input current program object for security check
               input current instance attribute posted to program
               output security options as comma delimited list of secured
               fields, each with 2 entries. 
               Entry 1 = table.fieldname,
               Entry 2 = hidden/read-only
  Notes:       See Dynamics Security Documentation for full information.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcObjectName                    AS CHARACTER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcAttributeCode                 AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcSecurityOptions               AS CHARACTER    NO-UNDO.

  /* If client side, check local cache to see if already checked and if so use cached value */
  IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) 
  THEN DO:
      FIND FIRST ttFieldSecurityCheck
           WHERE ttFieldSecurityCheck.cObjectName = pcObjectName
             AND ttFieldSecurityCheck.cAttributeCode = pcAttributeCode
           NO-ERROR.

      IF AVAILABLE ttFieldSecurityCheck 
      THEN DO:
          ASSIGN pcSecurityOptions = ttFieldSecurityCheck.cSecurityOptions.
          RETURN.        
      END.
  END.

  &IF DEFINED(server-side) = 0 &THEN
      RUN af/app/afsecfldsecchkp.p ON gshAstraAppServer
        (INPUT  pcObjectName,
         INPUT  pcAttributeCode,
         OUTPUT pcSecurityOptions) NO-ERROR.
      IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
          RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                          ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
  &ELSE
    DEFINE VARIABLE dProductModuleObj   AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE dSecurityObjectObj  AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE dAttributeObj       AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE cObjectExt          AS CHARACTER NO-UNDO. /* File extension */
    DEFINE VARIABLE dUserObj            AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE dOrganisationObj    AS DECIMAL   NO-UNDO.
    DEFINE VARIABLE cObjsSecured        AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cSecurityProperties AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lSecurityRestricted AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE cSecurityValue1     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cSecValueNotUsed    AS CHARACTER NO-UNDO.
    
    DEFINE BUFFER b1ryc_smartobject      FOR ryc_smartobject.
    DEFINE BUFFER b2ryc_smartobject      FOR ryc_smartobject.
    DEFINE BUFFER gsm_security_structure FOR gsm_security_structure.
    DEFINE BUFFER gsm_field              FOR gsm_field.
    
    /* If security is disabled or the security object is not passed in then "" is
       returned indicating full access is permitted.
       The routine loops around the available fields. If a field is disabled or no
       security structure exists for it, i.e. it is not used, then it is assumed
       that the user is simply ignored - indicating full access to the field.
       For each field that is enabled and used, checks are made to see whether
       the user has restricted access to the field, and if so, what actions may be
       taken on the field.
       For fields - only secured fields are returned in the list. If the field is
       not in the returned list, then full access is assumed.
    */
    ASSIGN cSecurityProperties = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager, 
                                 INPUT "SecurityEnabled,currentUserObj,currentOrganisationObj":U,INPUT YES). /* These properties should be set in the session manager cache, don't go to the db */
    
    IF ENTRY(1, cSecurityProperties, CHR(3)) = "NO":U /* Security Enabled */
    OR NOT CAN-FIND(FIRST gsm_field) THEN 
        RETURN.

    ASSIGN dUserObj         = DECIMAL(ENTRY(2,cSecurityProperties,CHR(3)))
           dOrganisationObj = DECIMAL(ENTRY(3,cSecurityProperties,CHR(3)))
           NO-ERROR.
    
    FIND FIRST b1ryc_smartobject NO-LOCK
         WHERE b1ryc_smartobject.object_filename = pcObjectName
         NO-ERROR.

    /* If not found then check with separated extension */
    IF NOT AVAILABLE b1ryc_smartobject THEN
        IF R-INDEX(pcObjectName,".":U) > 0
        THEN DO:
            ASSIGN cObjectExt = ENTRY(NUM-ENTRIES(pcObjectName,".":U),pcObjectName,".":U).

            FIND FIRST b1ryc_smartobject NO-LOCK
                 WHERE b1ryc_smartobject.object_filename  = REPLACE(pcObjectName,(".":U + cObjectExt),"":U) 
                   AND b1ryc_smartobject.object_Extension = cObjectExt
                 NO-ERROR.

            IF NOT AVAILABLE b1ryc_smartobject THEN
                RETURN.
        END.
        ELSE
            RETURN.

    /* Is this object secured by another object? */
    IF b1ryc_smartobject.smartobject_obj = b1ryc_smartobject.security_smartobject_obj THEN
        ASSIGN dSecurityObjectObj = b1ryc_smartobject.smartobject_obj
               dProductModuleObj  = b1ryc_smartobject.product_module_obj.
    ELSE DO:
        FIND FIRST b2ryc_smartobject NO-LOCK
             WHERE b2ryc_smartobject.smartobject_obj = b1ryc_smartobject.security_smartobject_obj
             NO-ERROR.


        IF AVAILABLE b2ryc_smartobject THEN
            ASSIGN dSecurityObjectObj = b2ryc_smartobject.smartobject_obj
                   dProductModuleObj  = b2ryc_smartobject.product_module_obj.
        ELSE
            RETURN.
    END.

    /* Get the attribute obj */
    IF pcAttributeCode <> "":U
    THEN DO:
        FIND FIRST gsc_instance_attribute NO-LOCK
             WHERE gsc_instance_attribute.attribute_code = pcAttributeCode
             NO-ERROR.
    
        IF AVAILABLE gsc_instance_attribute THEN
            ASSIGN dAttributeObj = gsc_instance_attribute.instance_attribute_obj.
    END.
    
    /* Check which fields user has restricted access to. In the case of field security,  *
     * attributes are passed back indicating what actions may be performed on the field, *
     * so it is important to check specific object instance details first.               */
    
    /* Check for specific object instance */
    IF dAttributeObj <> 0 THEN /* This test only makes sense if we're running with an attribute.  Otherwise, we're just duplicating the check below */
        fe-blk:
        FOR EACH gsm_security_structure NO-LOCK
           WHERE gsm_security_structure.owning_entity_mnemonic = "GSMFF":U            
             AND gsm_security_structure.product_module_obj      = dProductModuleObj   
             AND gsm_security_structure.object_obj              = dSecurityObjectObj  
             AND gsm_security_structure.instance_attribute_obj  = dAttributeObj       
             AND gsm_security_structure.DISABLED                = NO:
        
            /* If the field is secured already, then do nothing. */
            IF CAN-DO(cObjsSecured, STRING(gsm_security_structure.owning_obj)) THEN
                NEXT fe-blk.
        
            RUN userSecurityCheck IN TARGET-PROCEDURE (INPUT  dUserObj,                      /* logged in as user */
                                                       INPUT  dOrganisationObj,              /* logged into organisation */
                                                       INPUT  "GSMFF":U,                     /* Security Structure FLA */
                                                       INPUT  gsm_security_structure.security_structure_obj,
                                                       INPUT  YES,                           /* Return security values - YES */
                                                       OUTPUT lSecurityRestricted,           /* Restricted yes/no ? */
                                                       OUTPUT cSecurityValue1,               /* clearance value 1 */
                                                       OUTPUT cSecValueNotUsed).              /* clearance value 2 */
        
            IF lSecurityRestricted AND cSecurityValue1 <> "":U 
            THEN DO:
                FIND gsm_field NO-LOCK
                     WHERE gsm_field.field_obj = gsm_security_structure.owning_obj.
    
                IF NOT gsm_field.DISABLED THEN
                    ASSIGN pcSecurityOptions = pcSecurityOptions + (IF pcSecurityOptions <> "":U THEN ",":U ELSE "":U)
                                             + gsm_field.field_name + ",":U + cSecurityValue1
                           cObjsSecured      = cObjsSecured + (IF cObjsSecured <> "":U THEN ",":U ELSE "":U)
                                             + STRING(gsm_field.field_obj).
            END.
        END.
    
    /* Check for specific object, no attribute. */
    fe-blk:
    FOR EACH gsm_security_structure NO-LOCK
       WHERE gsm_security_structure.owning_entity_mnemonic = "GSMFF":U            
         AND gsm_security_structure.product_module_obj      = dProductModuleObj   
         AND gsm_security_structure.object_obj              = dSecurityObjectObj  
         AND gsm_security_structure.instance_attribute_obj  = 0                   
         AND gsm_security_structure.disabled                = NO:
    
        /* If the field is secured already, then do nothing. */
        IF CAN-DO(cObjsSecured, STRING(gsm_security_structure.owning_obj)) THEN
            NEXT fe-blk.
     
        RUN userSecurityCheck IN TARGET-PROCEDURE (INPUT  dUserObj,                      /* logged in as user */
                                                   INPUT  dOrganisationObj,              /* logged into organisation */
                                                   INPUT  "GSMFF":U,                     /* Security Structure FLA */
                                                   INPUT  gsm_security_structure.security_structure_obj,
                                                   INPUT  YES,                           /* Return security values - YES */
                                                   OUTPUT lSecurityRestricted,           /* Restricted yes/no ? */
                                                   OUTPUT cSecurityValue1,               /* clearance value 1 */
                                                   OUTPUT cSecValueNotUsed).              /* clearance value 2 */
    
        IF lSecurityRestricted AND cSecurityValue1 <> "":U 
        THEN DO:
            FIND gsm_field NO-LOCK
                 WHERE gsm_field.field_obj = gsm_security_structure.owning_obj.
    
            IF NOT gsm_field.DISABLED THEN
                ASSIGN pcSecurityOptions = pcSecurityOptions + (IF pcSecurityOptions <> "":U THEN ",":U ELSE "":U)
                                         + gsm_field.field_name + ",":U + cSecurityValue1
                       cObjsSecured      = cObjsSecured + (IF cObjsSecured <> "":U THEN ",":U ELSE "":U)
                                         + STRING(gsm_field.field_obj).
        END.
    END.
    
    /* Check for fields secured at product module level (cached) */
    fe-blk:
    FOR EACH ttGlobalSecurityStructure
       WHERE ttGlobalSecurityStructure.product_module_obj     = dProductModuleObj
         AND ttGlobalSecurityStructure.owning_entity_mnemonic = "GSMFF":U:

        /* If the field is secured already, then do nothing. */
        IF CAN-DO(cObjsSecured, STRING(ttGlobalSecurityStructure.owning_obj)) THEN
            NEXT fe-blk.
    
        /* In a client-server session, we've already resolved security for this field, just copy it *
         * into our secured field list.                                                             */
        IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN
            ASSIGN pcSecurityOptions = pcSecurityOptions 
                                     + (IF pcSecurityOptions <> "":U THEN ",":U ELSE "":U)
                                     + ttGlobalSecurityStructure.security_object_name + ",":U + ttGlobalSecurityStructure.user_allocation_value1
                   cObjsSecured      = cObjsSecured 
                                     + (IF cObjsSecured <> "":U THEN ",":U ELSE "":U)
                                     + STRING(ttGlobalSecurityStructure.owning_obj).
        ELSE DO:
            RUN userSecurityCheck IN TARGET-PROCEDURE (INPUT  dUserObj,                      /* logged in as user */
                                                       INPUT  dOrganisationObj,              /* logged into organisation */
                                                       INPUT  "GSMFF":U,                     /* Security Structure FLA */
                                                       INPUT  ttGlobalSecurityStructure.security_structure_obj,
                                                       INPUT  YES,                           /* Return security values - YES */
                                                       OUTPUT lSecurityRestricted,           /* Restricted yes/no ? */
                                                       OUTPUT cSecurityValue1,               /* clearance value 1 */
                                                       OUTPUT cSecValueNotUsed).              /* clearance value 2 */
    
            IF lSecurityRestricted AND cSecurityValue1 <> "":U THEN
                ASSIGN pcSecurityOptions = pcSecurityOptions 
                                         + (IF pcSecurityOptions <> "":U THEN ",":U ELSE "":U)
                                         + ttGlobalSecurityStructure.security_object_name + ",":U + cSecurityValue1
                       cObjsSecured      = cObjsSecured 
                                         + (IF cObjsSecured <> "":U THEN ",":U ELSE "":U)
                                         + STRING(ttGlobalSecurityStructure.owning_obj).
        END.
    END.

    /* Check for globally secured fields (cached) */
    fe-blk:
    FOR EACH ttGlobalSecurityStructure
       WHERE ttGlobalSecurityStructure.product_module_obj     = 0
         AND ttGlobalSecurityStructure.owning_entity_mnemonic = "GSMFF":U:

        /* If the field is secured already, then do nothing. */
        IF CAN-DO(cObjsSecured, STRING(ttGlobalSecurityStructure.owning_obj)) THEN
            NEXT fe-blk.
    
        /* In a client-server session, we've already resolved security for this field, just copy it *
         * into our secured field list.                                                             */
        IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN
            ASSIGN pcSecurityOptions = pcSecurityOptions 
                                     + (IF pcSecurityOptions <> "":U THEN ",":U ELSE "":U)
                                     + ttGlobalSecurityStructure.security_object_name + ",":U + ttGlobalSecurityStructure.user_allocation_value1
                   cObjsSecured      = cObjsSecured 
                                     + (IF cObjsSecured <> "":U THEN ",":U ELSE "":U)
                                     + STRING(ttGlobalSecurityStructure.owning_obj).
        ELSE DO:
            RUN userSecurityCheck IN TARGET-PROCEDURE (INPUT  dUserObj,                      /* logged in as user */
                                                       INPUT  dOrganisationObj,              /* logged into organisation */
                                                       INPUT  "GSMFF":U,                     /* Security Structure FLA */
                                                       INPUT  ttGlobalSecurityStructure.security_structure_obj,
                                                       INPUT  YES,                           /* Return security values - YES */
                                                       OUTPUT lSecurityRestricted,           /* Restricted yes/no ? */
                                                       OUTPUT cSecurityValue1,               /* clearance value 1 */
                                                       OUTPUT cSecValueNotUsed).              /* clearance value 2 */
    
            IF lSecurityRestricted AND cSecurityValue1 <> "":U THEN
                ASSIGN pcSecurityOptions = pcSecurityOptions 
                                         + (IF pcSecurityOptions <> "":U THEN ",":U ELSE "":U)
                                         + ttGlobalSecurityStructure.security_object_name + ",":U + cSecurityValue1
                       cObjsSecured      = cObjsSecured 
                                         + (IF cObjsSecured <> "":U THEN ",":U ELSE "":U)
                                         + STRING(ttGlobalSecurityStructure.owning_obj).
        END.
    END.
  &ENDIF

  /* Update client cache */
  IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) 
  THEN DO:
      CREATE ttFieldSecurityCheck.
      ASSIGN ttFieldSecurityCheck.cObjectName = pcObjectName
             ttFieldSecurityCheck.cAttributeCode = pcAttributeCode
             ttFieldSecurityCheck.cSecurityOptions = pcSecurityOptions.
  END.

  ASSIGN ERROR-STATUS:ERROR = NO.
  RETURN "":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fieldSecurityGet) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fieldSecurityGet Procedure 
PROCEDURE fieldSecurityGet :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will check fields secured for the passed in object.
               If a valid procedure handle is passed in, and the object has been secured
               by the repository manager already, the security stored in the object
               will be used.  If we can't find the security in the object, we'll fetch
               the applicable security from the db/Appserver and return it (by running
               the fieldSecurityCheck procedure).
  Parameters:  phObject          - The handle to the object being checked.  This parameter
                                   is optional.  If not specified, a standard security check
                                   will be done using the object name.
               pcObjectName      - The name of the object being checked. (Mandatory)
               pcAttributeCode   - The attribute code of the object being checked. (Mandatory)
               pcSecurityOptions - The list of secured fields.
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phObject          AS HANDLE     NO-UNDO.
DEFINE INPUT  PARAMETER pcObjectName      AS CHARACTER    NO-UNDO.
DEFINE INPUT  PARAMETER pcAttributeCode   AS CHARACTER    NO-UNDO.
DEFINE OUTPUT PARAMETER pcSecurityOptions AS CHARACTER    NO-UNDO.

DEFINE BUFFER ttFieldSecurityCheck FOR ttFieldSecurityCheck.

DEFINE VARIABLE lObjectSecured AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cSecurity      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFields        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cObjectType    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iCnt           AS INTEGER    NO-UNDO.

IF (pcObjectName = "" OR pcObjectName = ?)
AND VALID-HANDLE(phObject)
THEN DO:
    {get logicalObjectName pcObjectName phObject}.

    /* If we can't find the name of the object we're trying to extract security for, return. */
    IF pcObjectName = ?
    OR pcObjectName = "":U THEN
        RETURN.
END.

/* We used to extract security directly from the browser or viewer here.     *
 * However, from V2.1, we'll only ever check security against the container, *
 * so the check against the instance has become redundant.                   */

/* If we get here, the object hasn't been secured yet.  We're going to have to get security from the database/Appserver. */
RUN fieldSecurityCheck IN TARGET-PROCEDURE (INPUT pcObjectName,
                                            INPUT pcAttributeCode,
                                            OUTPUT pcSecurityOptions).

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContainerIcons) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getContainerIcons Procedure 
PROCEDURE getContainerIcons :
/*------------------------------------------------------------------------------
  Purpose:     This API returns the icons to load for each window launched.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER pcSystemIcon AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcSmallSystemIcon AS CHARACTER  NO-UNDO.

/* Check the icon cache first */
IF gcCacheSystemIcon <> "":U 
THEN DO:
    ASSIGN pcSystemIcon      = gcCacheSystemIcon
           pcSmallSystemIcon = gcCacheSmallSystemIcon.
    RETURN.
END.

FIND FIRST ttSecurityControl NO-ERROR.

IF NOT AVAILABLE ttSecurityControl
THEN DO:
    RUN getSecurityControl IN TARGET-PROCEDURE (OUTPUT TABLE ttSecurityControl).

    FIND FIRST ttSecurityControl NO-ERROR.
    IF NOT AVAILABLE ttSecurityControl
    THEN DO:
        ASSIGN pcSystemIcon      = ?
               pcSmallSystemIcon = ?.
        RETURN.
    END.
END.

ASSIGN pcSystemIcon = SEARCH(IF ttSecurityControl.system_icon_filename <> "":U
                             THEN ttSecurityControl.system_icon_filename
                             ELSE "adeicon/icfdev.ico":U)
       pcSmallSystemIcon = SEARCH(IF ttSecurityControl.small_icon_filename <> "":U
                                  THEN ttSecurityControl.small_icon_filename
                                  ELSE "adeicon/icfdev.ico":U)
       .
/* If Icon file is found to be in a PL library - the path returned from the search above will
   not be valid for the LOAD-ICON method, so in this case we rather have to use the relative
   path as setup in the DB.
*/
IF INDEX(pcSystemIcon,"<":U) <> 0 THEN
  ASSIGN pcSystemIcon = (IF ttSecurityControl.system_icon_filename <> "":U
                             THEN ttSecurityControl.system_icon_filename
                             ELSE "adeicon/icfdev.ico":U).
IF INDEX(pcSmallSystemIcon,"<":U) <> 0 THEN
  ASSIGN pcSmallSystemIcon = (IF ttSecurityControl.small_icon_filename <> "":U
                             THEN ttSecurityControl.small_icon_filename
                             ELSE "adeicon/icfdev.ico":U).
ASSIGN       
       gcCacheSystemIcon      = pcSystemIcon
       gcCacheSmallSystemIcon = pcSmallSystemIcon.

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldSecurity) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getFieldSecurity Procedure 
PROCEDURE getFieldSecurity :
/*------------------------------------------------------------------------------
  Purpose:     This procedure allows you to pass in a list of CHR(1) seperated 
               field names. It will then return a comma seperated list of how 
               the fields are secured.  Entry 1 in the field list will correspond 
               to entry 1 in the 'how secured' list, and so on...
  Parameters:  pcFieldList    - The fields to check
               pcSecurityList - The list of security
  Notes:       This API has been written to check field security for audit trails 
               specifically, as we cannot determine which object or container
               the field was updated from.  We'll check if the field has been 
               secured anywhere, and apply the most restrictive security if set
               up.  Rather safe than sorry...
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcFieldList    AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcSecurityList AS CHARACTER  NO-UNDO.

&IF DEFINED(server-side) = 0 &THEN
    /* We need to pass the request to the Appserver */
    RUN af/app/afsecgtfldsecp.p ON gshAstraAppServer
      (INPUT  pcFieldList,   
       OUTPUT pcSecurityList) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN
    DO:
      ASSIGN pcSecurityList = "":U.
      RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                    ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
    END.
&ELSE
    DEFINE VARIABLE iFieldCnt           AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cProperties         AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE dUserObj            AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE dOrganisationObj    AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE lSecurityRestricted AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE cSecurityValue1     AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cSecurityValue2     AS CHARACTER  NO-UNDO.

    DEFINE BUFFER gsm_field              FOR gsm_field.
    DEFINE BUFFER gsm_security_structure FOR gsm_security_structure.
    DEFINE BUFFER gsc_security_control   FOR gsc_security_control.

    /* First, initialize the security list by ensuring it has the same number of *
     * entries as the field list                                                 */
    ASSIGN pcSecurityList = FILL(",":U, NUM-ENTRIES(pcFieldList, CHR(1)) - 1).

    /* If security is disabled, return */
    FIND FIRST gsc_security_control NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gsc_security_control OR gsc_security_control.security_enabled = NO THEN
        RETURN.

    /* Find out who the user is and which company he's logged into */
    ASSIGN cProperties      = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager, INPUT "currentUserObj,currentOrganisationObj":U, INPUT YES)
           dUserObj         = DECIMAL(ENTRY(1, cProperties, CHR(3)))
           dOrganisationObj = DECIMAL(ENTRY(2, cProperties, CHR(3)))
           NO-ERROR.

    /* Cycle through the fields sent, and check for security against them */    
    do-blk:
    DO iFieldCnt = 1 TO NUM-ENTRIES(pcFieldList, CHR(1)):

        FIND gsm_field NO-LOCK
             WHERE gsm_field.field_name = ENTRY(iFieldCnt, pcFieldList, CHR(1))
             NO-ERROR.

        IF NOT AVAILABLE gsm_field THEN
            NEXT do-blk.

        FOR EACH gsm_security_structure NO-LOCK
           WHERE gsm_security_structure.owning_entity_mnemonic = "GSMFF":U
             AND gsm_security_structure.owning_obj             = gsm_field.field_obj
             AND gsm_security_structure.DISABLED               = NO:

            /* Check if any security has been set applicable to this user */
            RUN userSecurityCheck IN TARGET-PROCEDURE (INPUT  dUserObj,
                                                       INPUT  dOrganisationObj,
                                                       INPUT  "GSMSS":U,
                                                       INPUT  gsm_security_structure.security_structure_obj,
                                                       INPUT  YES, /* Return Values? */
                                                       OUTPUT lSecurityRestricted,
                                                       OUTPUT cSecurityValue1,
                                                       OUTPUT cSecurityValue2).

            /* We're dealing with fields, so securityValue1 should contain how the field is secured */
            IF  lSecurityRestricted = YES 
            AND cSecurityValue1 <> "":U                             /* must be HIDDEN or READ ONLY then */
            AND ENTRY(iFieldCnt, pcSecurityList) <> "HIDDEN":U THEN /* If HIDDEN, leave it that way (most restrictive) */
                ASSIGN ENTRY(iFieldCnt, pcSecurityList) = cSecurityValue1 NO-ERROR.
        END.
    END.
&ENDIF

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMandatoryTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getMandatoryTables Procedure 
PROCEDURE getMandatoryTables :
/*------------------------------------------------------------------------------
  Purpose:     A field is passed to this procedure, it will then run through the
               connected databases, and determine on which tables the specified
               field is mandatory.  If running Appserver, it will then run itself
               on the Appserver, to determine mandatory tables for databases connected
               to the Appserver.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER        pcFieldName AS CHARACTER  NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER pcTableList AS CHARACTER  NO-UNDO.

DEFINE VARIABLE iCnt       AS INTEGER    NO-UNDO.
DEFINE VARIABLE hQuery     AS HANDLE     NO-UNDO.
DEFINE VARIABLE hField     AS HANDLE     NO-UNDO.
DEFINE VARIABLE hFile      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hFilename  AS HANDLE     NO-UNDO.

/* First, check if the specified field is mandatory on any table in any connected db */

IF NUM-DBS <> 0 
THEN DO iCnt = 1 TO NUM-DBS:

    CREATE BUFFER hField FOR TABLE LDBNAME(iCnt) + "._field":U.
    CREATE BUFFER hFile  FOR TABLE LDBNAME(iCnt) + "._file":U.

    ASSIGN hFilename = hFile:BUFFER-FIELD("_file-name":U).

    CREATE QUERY hQuery.
    hQuery:SET-BUFFERS(hField,hFile).
    hQuery:QUERY-PREPARE("FOR EACH ":U + LDBNAME(iCnt) + "." + hField:NAME + " NO-LOCK":U
                         + " WHERE ":U + LDBNAME(iCnt) + "." + hField:NAME + "._field-name = '":U + pcFieldName + "'":U
                         +   " AND ":U + LDBNAME(iCnt) + "." + hField:NAME + "._mandatory  = YES,":U
                         + " FIRST ":U + LDBNAME(iCnt) + "." + hFile:NAME  + " NO-LOCK OF ":U + LDBNAME(iCnt) + "." + hField:NAME
                        ).
    hQuery:QUERY-OPEN().

    /* Cycle through all mandatory fields with the name supplied */

    hQuery:GET-FIRST().
    DO WHILE hField:AVAILABLE:

        IF LOOKUP(LDBNAME(iCnt) + " - ":U + hFilename:BUFFER-VALUE, pcTableList) = 0
        OR LOOKUP(LDBNAME(iCnt) + " - ":U + hFilename:BUFFER-VALUE, pcTableList) = ? THEN
            ASSIGN pcTableList = pcTableList + ",":U + LDBNAME(iCnt) + " - ":U + hFilename:BUFFER-VALUE. /* dbname - tablename */

        hQuery:GET-NEXT().
    END.

    hQuery:QUERY-CLOSE().

    DELETE OBJECT hField NO-ERROR.
    DELETE OBJECT hFile  NO-ERROR.
    DELETE OBJECT hQuery NO-ERROR.

    ASSIGN hQuery    = ?
           hField    = ?
           hFile     = ?
           hFileName = ?.
END.
IF SUBSTRING(pcTableList,1,1) = ",":U THEN
    ASSIGN pcTableList = SUBSTRING(pcTableList,2).

&IF DEFINED(server-Side) = 0 &THEN
      RUN af/app/afsecgtmndtblp.p ON gshAstraAppServer
        (INPUT  pcFieldName,
         INPUT-OUTPUT  pcTableList) NO-ERROR.
      IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN 
          RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                          ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
&ENDIF

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSecurityControl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSecurityControl Procedure 
PROCEDURE getSecurityControl :
/*------------------------------------------------------------------------------
  Purpose:     To return the security control details in the form of a temp-table.
  Parameters:  output table containing single security control record
  Notes:       If the temp-table is empty, then it first goes to the appserver
               to read the details and populate the temp-table. If any of the
               security control,settings are changed in a session, the clear
               cache procedure could be run and then this procedure will pick up
               the new details.
               On the server, we must always access the database to get the
               information.
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER TABLE FOR ttSecurityControl.

/* If there is a record in the ttSecurityControl table, we don't need to fetch it 
   again. */
IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U)
AND CAN-FIND(FIRST ttSecurityControl) THEN 
  RETURN.

/* ttSecurity Control is not cached, fetch it and assign it */
&IF DEFINED(server-side) = 0 &THEN
  DEFINE VARIABLE hBufferHandle AS HANDLE     NO-UNDO.

  /* first check to see if session manager is running and has the security control 
     temp-table already - which it gets as part of the login cache work it does -
     this therefore avoids an extra appserver hit 
  */
  RUN getSecurityControlCache IN gshSessionManager (OUTPUT TABLE ttSecurityControl).
  IF CAN-FIND(FIRST ttSecurityControl) THEN RETURN.

  /* We need to pass the request to the Appserver */
  RUN af/app/afsecgtsecctrlp.p ON gshAstraAppServer
    (OUTPUT TABLE ttSecurityControl) NO-ERROR.
  IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN
    RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                  ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
&ELSE
  {af/app/afsecgtsecctrlp.i}
&ENDIF

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
  Purpose:     This procedure builds a list of all the groups a user is linked to, 
               and then calls itself to get all the groups the groups are linked 
               to, and so on...We only add the security group if security allocations
               have been made against it and if it has been allocated to the user
               for the current logged in company.
  Parameters:  <none>
  Notes:       This is not a developer API and should only ever be run server side.
               It is not made available client side as it could potentially result
               in lots of Appserver hits and will be really inefficient.  If you need
               to run it, write one API on the server that calls this procedure.
------------------------------------------------------------------------------*/
&IF DEFINED(server-side) <> 0 &THEN
DEFINE INPUT  PARAMETER pdUserObj                      AS DECIMAL    NO-UNDO.
DEFINE INPUT  PARAMETER pdLoginCompanyObj              AS DECIMAL    NO-UNDO.
DEFINE INPUT  PARAMETER plReturnGroupsWithSecurityOnly AS LOGICAL    NO-UNDO.
DEFINE INPUT  PARAMETER plReturnObjField               AS LOGICAL    NO-UNDO. /* If YES, will return the security group obj, else will return the security group name. */
DEFINE INPUT-OUTPUT PARAMETER pcSecurityGroups         AS CHARACTER  NO-UNDO.

DEFINE BUFFER gsm_group_allocation FOR gsm_group_allocation.
DEFINE BUFFER gsm_user             FOR gsm_user.

DEFINE VARIABLE lGroupAlreadyInList AS LOGICAL NO-UNDO.

fe-blk:
FOR EACH gsm_group_allocation NO-LOCK
   WHERE gsm_group_allocation.user_obj = pdUserObj:

    IF gsm_group_allocation.login_company_obj = 0 /* Security group applies to all companies */
    OR gsm_group_allocation.login_company_obj = pdLoginCompanyObj /* Security group applies to this company */
    THEN DO:
        IF NOT plReturnObjField
        THEN DO:
            FIND gsm_user NO-LOCK
                 WHERE gsm_user.user_obj = gsm_group_allocation.group_user_obj
                 NO-ERROR.

            IF NOT AVAILABLE gsm_user THEN
                NEXT fe-blk.
        END.

        ASSIGN lGroupAlreadyInList = IF plReturnObjField
                                     THEN LOOKUP(STRING(gsm_group_allocation.group_user_obj), pcSecurityGroups, CHR(4)) <> 0
                                     ELSE LOOKUP(gsm_user.user_login_name, pcSecurityGroups, CHR(4)) <> 0.
        IF NOT lGroupAlreadyInList
        THEN DO:
            /* Only add the security group to the list of security groups for the session is security has been  *
             * allocated against it.  If not, we're just going to be wasting time checking security against it. */
            IF plReturnGroupsWithSecurityOnly = YES 
            THEN DO:
                IF CAN-FIND(FIRST gsm_user_allocation
                            WHERE gsm_user_allocation.user_obj               = gsm_group_allocation.group_user_obj
                              AND gsm_user_allocation.login_organisation_obj = 0)
                OR CAN-FIND(FIRST gsm_user_allocation
                            WHERE gsm_user_allocation.user_obj               = gsm_group_allocation.group_user_obj
                              AND gsm_user_allocation.login_organisation_obj = pdLoginCompanyObj) THEN
                    ASSIGN pcSecurityGroups = pcSecurityGroups 
                                            + (IF plReturnObjField
                                               THEN STRING(gsm_group_allocation.group_user_obj)
                                               ELSE gsm_user.user_login_name) 
                                            + CHR(4).
            END.
            ELSE
                ASSIGN pcSecurityGroups = pcSecurityGroups 
                                        + (IF plReturnObjField
                                           THEN STRING(gsm_group_allocation.group_user_obj)
                                           ELSE gsm_user.user_login_name)                                            
                                        + CHR(4).

            /* Now get any groups assigned to this security group */
            RUN getSecurityGroups IN TARGET-PROCEDURE (INPUT gsm_group_allocation.group_user_obj,
                                                       INPUT pdLoginCompanyObj,
                                                       INPUT plReturnGroupsWithSecurityOnly,
                                                       INPUT plReturnObjField,
                                                       INPUT-OUTPUT pcSecurityGroups).
        END.
    END.
END.

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.
&ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-menuItemSecurityCheck) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE menuItemSecurityCheck Procedure 
PROCEDURE menuItemSecurityCheck :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:     Secures Menu items (actions)
  Parameters:  pcItem         - the menu item (action) to secure
               plItemHidden   - whether the item is hidden as a result of security
               plItemDisabled - whether the item is disabled, either as a result of
                                security or because of user or menu item settings.
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcItem          as CHARACTER            NO-UNDO.
    DEFINE OUTPUT PARAMETER plItemHidden    as logical              NO-UNDO.
    DEFINE OUTPUT PARAMETER plItemDisabled  as logical              NO-UNDO.
            
    /* If client side, check local cache to see 
       if already checked and if so use cached value
     */
    IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE eq "WEBSPEED":U) THEN
    DO:
        FIND FIRST ttMenuSecurity WHERE
                   ttMenuSecurity.cName     = pcItem AND
                   ttMenuSecurity.cMenuType = "Item"
                   NO-ERROR.
        if AVAILABLE ttMenuSecurity THEN
        do:
            ASSIGN plItemHidden   = CAN-DO(ttMenuSecurity.cSecurityOptions, "Hidden")
                   plItemDisabled = CAN-DO(ttMenuSecurity.cSecurityOptions, "Disabled")
                   ERROR-STATUS:ERROR = no.
            RETURN.
        END.    /* available cached security */
    END.    /* not remote or webspeed session */

    &IF DEFINED(Server-Side) eq 0 &THEN
    run af/app/afsecmiscp.p on gshAstraAppServer (input pcItem, output plItemHidden, output plItemDisabled) no-error.
    if error-status:error or return-value ne '' then
        return error return-value.
    &ELSE
    DEFINE VARIABLE cProperties                 as character        NO-UNDO.
    DEFINE VARIABLE cSecurityModel              as character        NO-UNDO.
    DEFINE VARIABLE cSecurityDummyValue         as character        NO-UNDO.
    DEFINE VARIABLE cContainerName              as character        NO-UNDO.
    DEFINE VARIABLE lGSMMISecurityExists        as logical          NO-UNDO.
    DEFINE VARIABLE lRYCSOSecurityExists        as logical          NO-UNDO.
    DEFINE VARIABLE lSecurityEnabled            as logical          NO-UNDO.
    DEFINE VARIABLE dUserObj                    as decimal          NO-UNDO.
    DEFINE VARIABLE dOrganisationObj            as decimal          no-undo.
    DEFINE VARIABLE dContainerObjectObj         as decimal          NO-UNDO.
                
    DEFINE BUFFER gsmmi             FOR GSM_MENU_ITEM.
    DEFINE BUFFER gsmus             FOR GSM_USER.
    
    cProperties = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                   ("SecurityModel,GSMMISecurityExists,RYCSOSecurityExists," +
                                    "SecurityEnabled,currentUserObj,currentOrganisationObj"),
                                   No).
        
    ASSIGN cSecurityModel       = ENTRY(1, cProperties, CHR(3))
           lGSMMISecurityExists = ENTRY(2, cProperties, CHR(3)) <> "NO":U
           lRYCSOSecurityExists = ENTRY(3, cProperties, CHR(3)) <> "NO":U
           lSecurityEnabled     = ENTRY(4, cProperties, CHR(3)) <> "NO":U
           dUserObj             = DECIMAL(ENTRY(5, cProperties, CHR(3)))
           dOrganisationObj     = DECIMAL(ENTRY(6, cProperties, CHR(3)))
           NO-ERROR.
    
    /* put this stuff into a block because we always need to create a 
       ttMenuSecurity record.
     */                        
    ITEM-SECURITY-BLK:
    do:
        /* set variable initial values.*/
        plItemHidden = no.
        plItemDisabled = no.
                
        FIND gsmmi WHERE gsmmi.menu_item_reference = pcItem NO-LOCK NO-ERROR.
        if NOT AVAILABLE gsmmi THEN
        do:
            /* secure menu item according to security model if not found in repository;
               unless security disabled in which case don't.
             */
            plItemHidden   = (if NOT lSecurityEnabled THEN NO ELSE (cSecurityModel eq 'Grant')).
            plItemDisabled = YES.
            LEAVE ITEM-SECURITY-BLK.
        END.    /* n/a item */
        
        if NOT lSecurityEnabled THEN
        do:
            plItemDisabled = gsmmi.disabled.
            LEAVE ITEM-SECURITY-BLK.
        END.    /* security disabled */
        
        /* If the security model is 'Grant' then
           the default behaviour, in cases where
           no security or other records can be found,
           the item is assumed to be secured.
         */
        /* If no action security exists, the administrator hasn't allocated any to this user. *
         * In a grant model, this means the item is secured.  In a revoke model, it isn't. */
        if NOT lGSMMISecurityExists THEN
        do:
            plItemDisabled = (cSecurityModel eq 'Grant').
            LEAVE ITEM-SECURITY-BLK.
        END.    /* GSMMI security exists */
                            
        FIND gsmus WHERE gsmus.user_obj = dUserObj NO-LOCK NO-ERROR.
        if NOT AVAILABLE gsmus THEN
        do:
            plItemDisabled = (cSecurityModel eq 'Grant').
            LEAVE ITEM-SECURITY-BLK.
        END.    /* n/a user */
        
        if gsmmi.disabled THEN
        do:
            plItemDisabled = YES.
            LEAVE ITEM-SECURITY-BLK.
        END.    /* hide if disabled and hide-on-disable */
                        
        if gsmmi.item_control_type eq 'Action' AND
           gsmmi.under_development and
           gsmus.development_user then
        do:
            plItemDisabled = YES.
            plItemHidden = YES.
            LEAVE ITEM-SECURITY-BLK.
        END.    /* not a development user */
        
        /* check security allocations */
        RUN userSecurityCheck (INPUT  dUserObj,
                               INPUT  dOrganisationObj,
                               INPUT  "GSMMI":U,
                               INPUT  gsmmi.menu_item_obj,
                               INPUT  NO,
                               OUTPUT plItemDisabled,
                               OUTPUT cSecurityDummyValue,
                               OUTPUT cSecurityDummyValue).
        
        if plItemDisabled THEN
            LEAVE ITEM-SECURITY-BLK.
        
        if gsmmi.item_select_type eq 'Launch' THEN
        do:
            /* Is the container we're going to launch secured? */
            IF lRYCSOSecurityExists THEN
            DO:             
                dContainerObjectObj = gsmmi.object_obj.
                cContainerName = ''.
                RUN objectSecurityCheck (INPUT-OUTPUT cContainerName,
                                         INPUT-OUTPUT dContainerObjectObj,
                                               OUTPUT plItemDisabled).
                if plItemDisabled THEN
                    LEAVE ITEM-SECURITY-BLK.
            END.    /* container security exists */
            ELSE
            /* In a grant model, this means the container is secured.  In a revoke model, it isn't.  */
            if cSecurityModel eq 'Grant' THEN
            do:
                plItemDisabled = yes.
                LEAVE ITEM-SECURITY-BLK.
            END.    /* no container security */
        END.    /* Launch */        
    END.    /* ITEM-SECURITY-BLK: */
    
    /* If the item is disabled, then it should be
       hidden if the menu item's hide if disabled 
       flag is set.
     */
    if plItemDisabled and not plItemHidden and 
       available gsmmi and gsmmi.hide_if_disabled then
        plItemHidden = yes.
    &ENDIF
                                    
    IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE eq "WEBSPEED":U) THEN
    DO:
        CREATE ttMenuSecurity.
        ASSIGN ttMenuSecurity.cName           = pcItem
               ttMenuSecurity.cMenuType       = "Item"
               ttMenuSecurity.cSecurityOption = "Hidden" WHEN plItemHidden
               ttMenuSecurity.cSecurityOption = ttMenuSecurity.cSecurityOption + ",Disabled" WHEN plItemDisabled
               ttMenuSecurity.cSecurityOption = left-TRIM(ttMenuSecurity.cSecurityOption, ",").
    END.    /* not remote or webspeed session */
    
    ERROR-STATUS:ERROR = no.
    RETURN.
END PROCEDURE.  /* menuItemSecurityCheck */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-menuItemStructureSecurityCheck) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE menuItemStructureSecurityCheck Procedure 
PROCEDURE menuItemStructureSecurityCheck :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
     Purpose: Secures a set of menu structures and menu items, so that
              many of these can be secured in one AppServer call.
  Parameters: pcItem                    - CSV list of menu items
              pcStructure           - CSV list of menu structures
              pcItemHidden          - CSV list of hidden menu items
              pcItemDisabled        - CSV list of disabled menu items
              pcStructureHidden - CSV list of hidden menu structures
       Notes: Menu security information is cached on:
                - the client session in an AppServer/GUI environment
                - the client session in a DB-aware/GUI environment.
              It is not cached:
                - on the Webspeed client
                - on the AppServer        
------------------------------------------------------------------------------*/
    define input  parameter pcItem             as character            no-undo.
    define input  parameter pcStructure        as character            no-undo.
    define output parameter pcItemHidden       as character            no-undo.
    define output parameter pcItemDisabled     as character            no-undo.
    define output parameter pcStructureHidden  as character            no-undo.
    
    define variable iLoop                 as integer                  no-undo.
    define variable cEntry                as character                no-undo.
    define variable lHidden               as logical                  no-undo.
    define variable lDisabled             as logical                  no-undo.    
    define variable cItemList             as character                no-undo.
    define variable cStructureList        as character                no-undo.
    define variable cItemHiddenList       as character                no-undo.
    define variable cItemDisabledList     as character                no-undo.
    define variable cStructureHiddenList  as character                no-undo.    
        
    /* cache if:
        - client session in an AppServer/GUI environment
        - client session in DB-aware/GUI environment.
           don't cache:
           - on webspeed client
           - on AppServer        
     */
    if not (session:remote or session:client-type eq 'Webspeed') then
    do:
        /* 1. Check what's already cached. Only retrieve across the A/S
              that which is not cached. Build the secured lists for
              those cached data.
           ============================================================
         */
        do iLoop = 1 to num-entries(pcItem):
            cEntry = entry(iLoop, pcItem).
            
            find first ttMenuSecurity where
                       ttMenuSecurity.cName     = cEntry and
                       ttMenuSecurity.cMenuType = "Item"
                       no-error.
            if available ttMenuSecurity then
            do:
                if ttMenuSecurity.cSecurityOption > '' then
                do:
                    if can-do(ttMenuSecurity.cSecurityOption, 'Hidden') then
                        pcItemHidden = pcItemHidden + ',' + cEntry.
                    if can-do(ttMenuSecurity.cSecurityOption, 'Disabled') then
                        pcItemDisabled = pcItemDisabled + ',' + cEntry.                
                end.    /* security set */
            end.    /* available security */
            /* Only query security on server if there is no cached security on
               the client. Careful not to go if there is an unsecured item cached
               on the client.
             */
            else
                cItemList = cItemList + ',' + cEntry.
        end.    /* item loop */
            
        /* Determine which structures are secured */
        do iLoop = 1 to num-entries(pcStructure):
            cEntry = entry(iLoop, pcStructure).
            
            find first ttMenuSecurity where
                       ttMenuSecurity.cName     = cEntry and
                       ttMenuSecurity.cMenuType = "Structure"
                       no-error.
            if available ttMenuSecurity then
            do:
                if ttMenuSecurity.cSecurityOption > '' and
                   can-do(ttMenuSecurity.cSecurityOption, 'Hidden') then
                    pcStructureHidden = pcStructureHidden + ',' + cEntry.
            end.    /* available security */
            /* Only query security on server if there is no cached security on
               the client. Careful not to go if there is an unsecured structure 
               cached on the client.
             */
            else
                cStructureList = cStructureList + ',' + cEntry.
        end.    /* structure loop */
    end.    /* not local and not webspeed */
    else
        assign cItemList      = pcItem
               cStructureList = pcStructure.
    
    /* Cleanup lists */
    assign cItemList = left-trim(cItemList, ',')
           cStructureList = left-trim(cStructureList, ',').
    
    /* 2. Get security for remaining data
       ===================================
     */
    &if defined(server-side) = 0 &then
    if cItemList ne '' or cStructureList ne '' then
    do:
        run af/app/afsecwmscp.p on gshAstraAppServer ( input  cItemList,
                                                       input  cStructureList,
                                                       output cItemHiddenList,
                                                       output cItemDisabledList,
                                                       output cStructureHiddenList ) no-error.
        if error-status:error or return-value <> '' then return error return-value.
        
        /* 3. Cache newly-retrieved data. The
                  information about which data is secured
                  is added to the return lists later.
               ==================================================
         */
        /* cache if:
                - client session in an AppServer/GUI environment
                - client session in DB-aware/GUI environment.
                   don't cache:
                   - on webspeed client
                   - on AppServer        
         */
        if not (session:remote or session:client-type eq 'Webspeed') then
        do:
            do iLoop = 1 to num-entries(cItemList):
                cEntry = entry(iLoop, cItemList).
                    
                create ttMenuSecurity.
                assign ttMenuSecurity.cName           = cEntry
                       ttMenuSecurity.cMenuType       = "Item"
                       ttMenuSecurity.cSecurityOption = "Hidden" when can-do(cItemHiddenList, cEntry)
                       ttMenuSecurity.cSecurityOption = ttMenuSecurity.cSecurityOption
                                                      + ",Disabled" when can-do(cItemDisabledList, cEntry)
                       ttMenuSecurity.cSecurityOption = left-trim(ttMenuSecurity.cSecurityOption, ',').
            end.    /* item loop */
                
            do iLoop = 1 to num-entries(cStructureList):
                cEntry = entry(iLoop, cStructureList).
                    
                create ttMenuSecurity.
                assign ttMenuSecurity.cName           = cEntry
                       ttMenuSecurity.cMenuType       = "Structure"
                       ttMenuSecurity.cSecurityOption = "Hidden" when can-do(cStructureHiddenList, cEntry).
            end.    /* structure loop */
        end.    /* not on client */    
    end.    /* there are things to fetch. */     
    &else
    /* Determine which items are secured */
    do iLoop = 1 to num-entries(cItemList):
        cEntry = entry(iLoop, cItemList).
        run menuItemSecurityCheck (input  cEntry,
                                   output lHidden, output lDisabled).
        if lHidden then
            cItemHiddenList = cItemHiddenList + ',' + cEntry.
        
        if lDisabled then
            cItemDisabledList = cItemDisabledList + ',' + cEntry.                
    end.    /* item loop */
    
    /* Determine which structures are secured */
    do iLoop = 1 to num-entries(cStructureList):
        cEntry = entry(iLoop, cStructureList).
        run menuStructureSecurityCheck (input cEntry, output lHidden).
        
        if lHidden then
            cStructureHiddenList = cStructureHiddenList + ',' + cEntry.                        
    end.    /* structure loop */
    /* The menu*SecurityCheck() calls do their own caching */
    &endif
    
    /* 4. Build lists of secured data for return.
       ==========================================
     */
    assign pcItemHidden = pcItemHidden + ',' + cItemHiddenList
           pcItemDisabled = pcItemDisabled + ',' + cItemDisabledList
           pcStructureHidden = pcStructureHidden + ',' + cStructureHiddenList
           /* clean up variables */
           pcStructureHidden = left-trim(pcStructureHidden, ',')
           pcItemHidden = left-trim(pcItemHidden, ',')
           pcItemDisabled = left-trim(pcItemDisabled, ',').
    
    error-status:error = no.
    return.
END PROCEDURE.     /* menuItemStructureSecurityCheck */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-menuStructureSecurityCheck) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE menuStructureSecurityCheck Procedure 
PROCEDURE menuStructureSecurityCheck :
/*------------------------------------------------------------------------------
ACCESS_LEVEL=PUBLIC
  Purpose:     Secures menu structures (bands)
  Parameters:  pcStructure       - the menu structure to secure
               plStructureHidden - whether the structure is hidden as the result
                                   of security.
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcStructure             as CHARACTER        NO-UNDO.
    DEFINE OUTPUT PARAMETER plStructureHidden       as logical          NO-UNDO.
        
    /* If client side, check local cache to see 
       if already checked and if so use cached value
     */
    IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE eq "WEBSPEED":U) THEN
    DO:
        FIND FIRST ttMenuSecurity WHERE
                   ttMenuSecurity.cName     = pcStructure AND
                   ttMenuSecurity.cMenuType = "Structure"
                   NO-ERROR. 
        if AVAILABLE ttMenuSecurity THEN
        do:
            ASSIGN plStructureHidden  = CAN-DO(ttMenuSecurity.cSecurityOptions, "Hidden")
                   ERROR-STATUS:ERROR = no.
            RETURN.
        END.    /* available cached security */
    END.    /* not remote or webspeed session */
                
    &IF DEFINED(Server-Side) eq 0 &THEN
    run af/app/afsecmsscp.p on gshAstraAppServer (input pcStructure, output plStructureHidden) no-error.
    if error-status:error or return-value ne '' then
        return error return-value.
    &ELSE
    DEFINE VARIABLE cProperties                 as character        NO-UNDO.
    DEFINE VARIABLE cSecurityModel              as character        NO-UNDO.
    DEFINE VARIABLE cSecurityDummyValue         as character        NO-UNDO.
    DEFINE VARIABLE lGSMMSSecurityExists        as logical          NO-UNDO.
    DEFINE VARIABLE lSecurityEnabled            as logical          NO-UNDO.
    DEFINE VARIABLE dUserObj                    as decimal          NO-UNDO.
    DEFINE VARIABLE dOrganisationObj            as decimal          no-undo.
    DEFINE VARIABLE dContainerObjectObj         as decimal          NO-UNDO.
                
    DEFINE BUFFER gsmms             FOR GSM_MENU_structure.
    DEFINE BUFFER gsmus             FOR GSM_USER.
    
    cProperties = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                   ("SecurityModel,GSMMSSecurityExists," +
                                    "SecurityEnabled,CurrentUserObj,CurrentOrganisationObj"),
                                   No).
    
    ASSIGN cSecurityModel       = ENTRY(1, cProperties, CHR(3))
           lGSMMSSecurityExists = ENTRY(2, cProperties, CHR(3)) <> "NO":U
           lSecurityEnabled     = ENTRY(3, cProperties, CHR(3)) <> "NO":U
           dUserObj             = DECIMAL(ENTRY(4, cProperties, CHR(3)))
           dOrganisationObj     = DECIMAL(ENTRY(5, cProperties, CHR(3)))
           NO-ERROR. 
    
    STRUCTURE-SECURITY-BLK:
    do:
        /* set variable initial values. */
        plStructureHidden = no.
        
        FIND gsmms WHERE gsmms.menu_structure_code = pcStructure NO-LOCK NO-ERROR.
        if NOT AVAILABLE gsmms THEN
        do:
            /* secure menu structure according to security model if not found in repository;
               unless security disabled in which case don't.
             */
            plStructureHidden = (if NOT lSecurityEnabled THEN NO ELSE (cSecurityModel eq 'Grant')).
            LEAVE STRUCTURE-SECURITY-BLK.
        END.    /* n/a structure */
        
        if NOT lSecurityEnabled THEN
        do:
            plStructureHidden = no.
            LEAVE STRUCTURE-SECURITY-BLK.
        END.    /* security disabled */
        
        /* If the security model is 'Grant' then
           the default behaviour, in cases where
           no security or other records can be found,
           the item is assumed to be secured.
         */
        /* If no action security exists, the administrator hasn't allocated any to this user. *
         * In a grant model, this means the item is secured.  In a revoke model, it isn't. */
        if NOT lGSMMSSecurityExists THEN
        do:
           if cSecurityModel eq 'Grant' THEN
               plStructureHidden = YES.
           LEAVE STRUCTURE-SECURITY-BLK.
        END.    /* GSMMS security exists */
                
        FIND gsmus WHERE gsmus.user_obj = dUserObj NO-LOCK NO-ERROR.
        if NOT AVAILABLE gsmus THEN
        do:
            if cSecurityModel eq 'Grant' THEN
                plStructureHidden = YES.
            LEAVE STRUCTURE-SECURITY-BLK.
        END.    /* n/a item */
        
        if gsmms.disabled THEN
        do:
            plStructureHidden = YES.
            LEAVE STRUCTURE-SECURITY-BLK.
        END.    /* menu structure is disabled */
        
        if gsmms.under_development AND NOT gsmus.development_user THEN
        do:
                plStructureHidden = YES.
                LEAVE STRUCTURE-SECURITY-BLK.
        END.    /* structure under development */
                
        RUN userSecurityCheck (INPUT  dUserObj,
                               INPUT  dOrganisationObj,
                               INPUT  "GSMMS":U,
                               INPUT  gsmms.menu_structure_obj,
                               INPUT  NO,
                               OUTPUT plStructureHidden,
                               OUTPUT cSecurityDummyValue,
                               OUTPUT cSecurityDummyValue).
    END.    /* STRUCTURE-SECURITY-BLK: */    
    &ENDIF                                        
    IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE eq "WEBSPEED":U) THEN
    DO:
        CREATE ttMenuSecurity.
        ASSIGN ttMenuSecurity.cName           = pcStructure
               ttMenuSecurity.cMenuType       = "Structure"
               ttMenuSecurity.cSecurityOption = "Hidden" WHEN plStructureHidden.
    END.    /* not remote or webspeed session */
    
    ERROR-STATUS:ERROR = no.
    RETURN.
END PROCEDURE.  /* menuStructureSecurityCheck */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-objectSecurityCheck) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE objectSecurityCheck Procedure 
PROCEDURE objectSecurityCheck :
/*------------------------------------------------------------------------------
  Purpose:     This procedure checks a user's security for objects permitted
               to run.

  Parameters:  input current program object for security check
               input current instance attribute posted to program
               output security options as comma delimited list of security tokens
               user does not have security clearance for, currently used in toolbar
               panel views to disable buttons and folder windows to disable
               folder pages, etc.

  Notes:       See Astra Security Documentation for full information.
------------------------------------------------------------------------------*/

  DEFINE INPUT-OUTPUT PARAMETER  pcObjectName                    AS CHARACTER    NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER  pdObjectObj                     AS DECIMAL      NO-UNDO.
  DEFINE OUTPUT       PARAMETER  plSecurityRestricted            AS LOGICAL      NO-UNDO.

  IF pcObjectName = ? THEN ASSIGN pcObjectName = "":U.
  IF pdObjectObj  = ? THEN ASSIGN pdObjectObj  = 0.

  DEFINE BUFFER ttObjectSecurityCheck FOR ttObjectSecurityCheck.

  /* If we're on the client, check the cache first.  Server side we don't have a cache. */
  IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) 
  THEN DO:
      /* Find on the object name */
      IF pcObjectName <> "":U THEN
          FIND ttObjectSecurityCheck
               WHERE ttObjectSecurityCheck.cObjectName = pcObjectName
               NO-ERROR.

      /* Find on the object obj */
      IF NOT AVAILABLE ttObjectSecurityCheck 
      AND pdObjectObj <> 0 THEN
          FIND ttObjectSecurityCheck
               WHERE ttObjectSecurityCheck.dObjectObj = pdObjectObj
               NO-ERROR.
    
      IF AVAILABLE ttObjectSecurityCheck 
      THEN DO:
          ASSIGN plSecurityRestricted = ttObjectSecurityCheck.lRestricted
                 ERROR-STATUS:ERROR   = NO.
          RETURN "":U.
      END.
  END.

  /* Run objectSecurityCheck to retrieve object security */
  &IF DEFINED(server-side) = 0 &THEN
      /* We need to pass the request to the Appserver */
      RUN af/app/afsecobjsecchkp.p ON gshAstraAppServer
        (INPUT-OUTPUT pcObjectName,
         INPUT-OUTPUT pdObjectObj,   
         OUTPUT       plSecurityRestricted) NO-ERROR.
      IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN
        RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                      ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
  &ELSE
      DEFINE VARIABLE cSecValueNotUsed    AS CHARACTER NO-UNDO.
      DEFINE VARIABLE cSecurityProperties AS CHARACTER NO-UNDO.
    
      DEFINE BUFFER ryc_smartobject     FOR ryc_smartobject.
      DEFINE BUFFER gsm_user_allocation FOR gsm_user_allocation.
    
      /* We're only going to check security if it has been enabled and applicable object security exists. */
      ASSIGN cSecurityProperties = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                   INPUT "SecurityEnabled,currentUserObj,currentOrganisationObj,SecurityModel":U,INPUT YES). /* These properties should be set in the session manager cache, don't go to the db */
    
      IF ENTRY(1, cSecurityProperties, CHR(3)) = "NO":U THEN /* Security Enabled */
          RETURN.
    
      /* If we can't find any object allocations in the db: *
       * - Access is granted in a revoke model.             *
       * - Access is revoked in a grant model.              */
      IF NOT CAN-FIND(FIRST gsm_user_allocation
                      WHERE gsm_user_allocation.owning_entity_mnemonic = "RYCSO":U) 
      THEN DO:
          ASSIGN plSecurityRestricted = (ENTRY(4, cSecurityProperties, CHR(3)) = "Grant":U). /* In a grant model, restricted = YES.  Revoke model, restricted = NO. */
          RETURN.
      END.
    
      ASSIGN plSecurityRestricted = YES.
    
      /* Find the object, it should be available. */
      IF pdObjectObj <> 0 THEN
          FIND ryc_smartobject NO-LOCK
               WHERE ryc_smartobject.smartobject_obj = pdObjectObj
               NO-ERROR.
      ELSE
          IF pcObjectName NE "":U
          THEN DO:
              FIND ryc_smartobject NO-LOCK
                   WHERE ryc_smartobject.object_filename          = pcObjectName
                     AND ryc_smartobject.customization_result_obj = 0
                   NO-ERROR.
    
              IF NOT AVAILABLE ryc_smartobject /* Remove the file extension and try again */
              AND NUM-ENTRIES(pcObjectName, ".":U) > 1 
              THEN DO:
                  ASSIGN pcObjectName = SUBSTRING(pcObjectName, 1, R-INDEX(pcObjectName, ".":U) - 1).
                  FIND ryc_smartobject NO-LOCK
                       WHERE ryc_smartobject.object_filename          = pcObjectName
                         AND ryc_smartobject.customization_result_obj = 0
                       NO-ERROR.
              END.
          END.
    
      IF AVAILABLE ryc_smartobject 
      THEN DO:
          /* We want to return the filename and obj, always. Important to cache correctly.*/
          ASSIGN pcObjectName = ryc_smartobject.object_filename
                 pdObjectObj  = ryc_smartobject.smartobject_obj.
    
          IF ryc_smartobject.security_smartobject_obj = 0 THEN. /* the object is secured.  Nothing more to do as plSecurityRestricted is already set to YES */
          ELSE
              RUN userSecurityCheck IN TARGET-PROCEDURE (INPUT  DECIMAL(ENTRY(2,cSecurityProperties,CHR(3))),  /* logged in as user */
                                                         INPUT  DECIMAL(ENTRY(3,cSecurityProperties,CHR(3))),  /* logged into organisation */
                                                         INPUT  "RYCSO":U,                      /* Security Structure FLA */
                                                         INPUT  ryc_smartobject.smartobject_obj,
                                                         INPUT  NO,                             /* Return security values - NO */
                                                         OUTPUT plSecurityRestricted,           /* Restricted yes/no ? */
                                                         OUTPUT cSecValueNotUsed,               /* clearance value 1 */
                                                         OUTPUT cSecValueNotUsed).              /* clearance value 2 */
      END.
      ELSE
          ASSIGN pdObjectObj          = 0
                 plSecurityRestricted = NO. /* Issue 7466 - If we can't find it, we couldn't have secured it */  
  &ENDIF

  /* If we're client side, add the result to the cache. */
  IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) 
  THEN DO:
      /* We have to check for the record in the cache because pcObjectName in could differ from pcObjectName out */
      IF NOT CAN-FIND(FIRST ttObjectSecurityCheck
                      WHERE ttObjectSecurityCheck.cObjectName = pcObjectName
                        AND ttObjectSecurityCheck.dObjectObj  = pdObjectObj) 
      THEN DO:
          CREATE ttObjectSecurityCheck.
          ASSIGN ttObjectSecurityCheck.cObjectName = pcObjectName
                 ttObjectSecurityCheck.dObjectObj  = pdObjectObj
                 ttObjectSecurityCheck.lRestricted = plSecurityRestricted.
      END.
  END.

  ASSIGN ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-plipShutdown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE plipShutdown Procedure 
PROCEDURE plipShutdown :
/*------------------------------------------------------------------------------
  Purpose:     Run on close of procedure
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rangeSecurityCheck) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rangeSecurityCheck Procedure 
PROCEDURE rangeSecurityCheck :
/*------------------------------------------------------------------------------
  Purpose:     This procedure checks a user's security for the passed in range
               code.

  Parameters:   input range code to check user security clearance for
                input current program object for security check
                input instance attribute posted to program
                output from value permitted for user, "" = all
                output to value permitted for user, "" = all

  Notes:       See Astra Security Documentation for full information.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcRangeCode     AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER pcObjectName    AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER pcAttributeCode AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER pcRangeFrom     AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER pcRangeTo       AS CHARACTER NO-UNDO.
 
  ASSIGN pcRangeFrom = "":U
         pcRangeTo   = "":U.

  /* If client side, check local cache to see if already checked and if so use cached value */
  IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) 
  THEN DO:
      FIND FIRST ttRangeSecurityCheck
           WHERE ttRangeSecurityCheck.cRangeCode = pcRangeCode
             AND ttRangeSecurityCheck.cObjectName = pcObjectName
             AND ttRangeSecurityCheck.cAttributeCode = pcAttributeCode
           NO-ERROR.

      IF AVAILABLE ttRangeSecurityCheck 
      THEN DO:
          ASSIGN pcRangeFrom = ttRangeSecurityCheck.cRangeFrom
                 pcRangeTo   = ttRangeSecurityCheck.cRangeTo.
          RETURN.        
      END.
  END.

  &IF DEFINED(server-side) = 0 &THEN
      /* We need to pass the request to the Appserver */
      RUN af/app/afsecrngsecchkp.p ON gshAstraAppServer
        (INPUT  pcRangeCode,
         INPUT  pcObjectName,   
         INPUT  pcAttributeCode,   
         OUTPUT pcRangeFrom,   
         OUTPUT pcRangeTo) NO-ERROR.
      IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN
        RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                      ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
  &ELSE      
      DEFINE VARIABLE lSecurityRestricted  AS LOGICAL   NO-UNDO.
      DEFINE VARIABLE dProductModuleObj    AS DECIMAL   NO-UNDO.
      DEFINE VARIABLE dSecurityObjectObj   AS DECIMAL   NO-UNDO.
      DEFINE VARIABLE dAttributeObj        AS DECIMAL   NO-UNDO.
      DEFINE VARIABLE cSecurityProperties  AS CHARACTER NO-UNDO.
      DEFINE VARIABLE dUserObj             AS DECIMAL   NO-UNDO.
      DEFINE VARIABLE dOrganisationObj     AS DECIMAL   NO-UNDO.
        
      DEFINE BUFFER b1ryc_smartobject FOR ryc_smartobject.
      DEFINE BUFFER b2ryc_smartobject FOR ryc_smartobject.
        
      /* If security is disabled or the security object is not passed in then "" is 
         returned for both values indicating full access is permitted.
         For the passed in range, checks are made as to whether any security restrictions
         exist for the user. If restrictions exist, the from and to values are passed
         back. */
      ASSIGN cSecurityProperties = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager, 
                                   INPUT "SecurityEnabled,currentUserObj,currentOrganisationObj":U,INPUT YES). /* These properties should be set in the session manager cache, don't go to the db */
        
      IF ENTRY(1, cSecurityProperties, CHR(3)) = "NO":U THEN /* Security Enabled */
          RETURN.
        
      ASSIGN dUserObj           = DECIMAL(ENTRY(2, cSecurityProperties, CHR(3)))
             dOrganisationObj   = DECIMAL(ENTRY(3, cSecurityProperties, CHR(3)))
             NO-ERROR.
        
      /* Check if security is turned on for the object (the object will have a security object
       *  specified), and if it is, work out what the security object is (probably itself but can
       *  be set-up as something else).
       */
      FIND b1ryc_smartobject NO-LOCK
           WHERE b1ryc_smartobject.object_filename = pcObjectName 
           NO-ERROR.
        
      IF AVAILABLE b1ryc_smartobject 
      THEN DO:
          IF b1ryc_smartobject.smartobject_obj = b1ryc_smartobject.security_smartobject_obj THEN
              ASSIGN dSecurityObjectObj = b1ryc_smartobject.smartobject_obj
                     dProductModuleObj  = b1ryc_smartobject.product_module_obj.
          ELSE DO:
              FIND b2ryc_smartobject NO-LOCK
                   WHERE b2ryc_smartobject.smartobject_obj = b1ryc_smartobject.security_smartobject_obj 
                   NO-ERROR.
      
              IF AVAILABLE b2ryc_smartobject THEN
                  ASSIGN dSecurityObjectObj = b2ryc_smartobject.smartobject_obj
                         dProductModuleObj  = b2ryc_smartobject.product_module_obj.
              ELSE
                  ASSIGN dSecurityObjectObj = 0
                         dProductModuleObj  = 0.
          END.
      END.
      ELSE
        ASSIGN dSecurityObjectObj = 0
               dProductModuleObj  = 0.
        
      IF pcAttributeCode <> "":U 
      THEN DO:
          FIND gsc_instance_attribute NO-LOCK
               WHERE gsc_instance_attribute.attribute_code = pcAttributeCode
               NO-ERROR.
        
          IF AVAILABLE gsc_instance_attribute THEN
              ASSIGN dAttributeObj = gsc_instance_attribute.instance_attribute_obj.
          ELSE
              ASSIGN dAttributeObj = 0.
      END.
        
      /* Find the range */
      FIND FIRST gsm_range NO-LOCK
           WHERE gsm_range.range_code = pcRangeCode
           NO-ERROR.
        
      IF NOT AVAILABLE gsm_range
      OR gsm_range.DISABLED
      OR NOT CAN-FIND(FIRST gsm_security_structure
                      WHERE gsm_security_structure.owning_entity_mnemonic = "GSMRA":U
                        AND gsm_security_structure.owning_obj             = gsm_range.range_obj
                        AND gsm_security_structure.disabled               = NO) THEN
          RETURN.
      
      /* Default security to NO */
      lSecurityRestricted = no.
      
      /* Check for specific object instance */
      IF dAttributeObj <> 0 THEN /* This test only makes sense if we're running with an attribute.  Otherwise, we're just duplicating the check below */
          fe-blk:
          FOR EACH gsm_security_structure NO-LOCK
             WHERE gsm_security_structure.owning_entity_mnemonic  = "GSMRA":U            
               AND gsm_security_structure.owning_obj              = gsm_range.range_obj
               AND gsm_security_structure.product_module_obj      = dProductModuleObj   
               AND gsm_security_structure.object_obj              = dSecurityObjectObj  
               AND gsm_security_structure.instance_attribute_obj  = dAttributeObj
               AND gsm_security_structure.DISABLED                = NO:
        
              RUN userSecurityCheck IN TARGET-PROCEDURE (INPUT  dUserObj,                      /* logged in as user */
                                                         INPUT  dOrganisationObj,              /* logged into organisation */
                                                         INPUT  "GSMSS":U,                     /* Security Structure FLA */
                                                         INPUT  gsm_security_structure.security_structure_obj,
                                                         INPUT  YES,                           /* Return security values - YES */
                                                         OUTPUT lSecurityRestricted,           /* Restricted yes/no ? */
                                                         OUTPUT pcRangeFrom,                   /* clearance value 1 */
                                                         OUTPUT pcRangeTo).                    /* clearance value 2 */
              IF lSecurityRestricted THEN
                  leave FE-BLK.
          END.    /* fe-blk: specific object instance */
        
      /* Check for specific object, no attribute. */
      if not lSecurityRestricted then      
      fe-blk:
      FOR EACH gsm_security_structure NO-LOCK
         WHERE gsm_security_structure.owning_entity_mnemonic  = "GSMRA":U            
           AND gsm_security_structure.owning_obj              = gsm_range.range_obj
           AND gsm_security_structure.product_module_obj      = dProductModuleObj   
           AND gsm_security_structure.object_obj              = dSecurityObjectObj  
           AND gsm_security_structure.instance_attribute_obj  = 0
           AND gsm_security_structure.DISABLED                = NO:
        
          RUN userSecurityCheck IN TARGET-PROCEDURE (INPUT  dUserObj,                      /* logged in as user */
                                                     INPUT  dOrganisationObj,              /* logged into organisation */
                                                     INPUT  "GSMSS":U,                     /* Security Structure FLA */
                                                     INPUT  gsm_security_structure.security_structure_obj,
                                                     INPUT  YES,                           /* Return security values - YES */
                                                     OUTPUT lSecurityRestricted,           /* Restricted yes/no ? */
                                                     OUTPUT pcRangeFrom,                   /* clearance value 1 */
                                                     OUTPUT pcRangeTo).              /* clearance value 2 */
          IF lSecurityRestricted then
              leave FE-BLK.
      END.    /* fe-blk: specific object, no attribute */
        
      /* Check for product module */
      if not lSecurityRestricted then
      fe-blk:
      FOR EACH ttGlobalSecurityStructure
         WHERE ttGlobalSecurityStructure.product_module_obj     = dProductModuleObj
           AND ttGlobalSecurityStructure.owning_entity_mnemonic = "GSMRA":U
           AND ttGlobalSecurityStructure.owning_obj             = gsm_range.range_obj:
        
          IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN
              ASSIGN lSecurityRestricted = ttGlobalSecurityStructure.restricted
                     pcRangeFrom         = ttGlobalSecurityStructure.user_allocation_value1
                     pcRangeTo           = ttGlobalSecurityStructure.user_allocation_value2.
          ELSE
              /* In a client-server environment, this security has already been resolved */
              RUN userSecurityCheck IN TARGET-PROCEDURE (INPUT  dUserObj,                      /* logged in as user */
                                                         INPUT  dOrganisationObj,              /* logged into organisation */
                                                         INPUT  "GSMSS":U,                     /* Security Structure FLA */
                                                         INPUT  ttGlobalSecurityStructure.security_structure_obj,
                                                         INPUT  YES,                           /* Return security values - YES */
                                                         OUTPUT lSecurityRestricted,           /* Restricted yes/no ? */
                                                         OUTPUT pcRangeFrom,                   /* clearance value 1 */
                                                         OUTPUT pcRangeTo).                    /* clearance value 2 */
          IF lSecurityRestricted then
              leave FE-BLK.
      END.    /* fe-blk: product module */
        
      /* Check for all */
      if not lSecurityRestricted then
      fe-blk:
      FOR EACH ttGlobalSecurityStructure
         WHERE ttGlobalSecurityStructure.product_module_obj     = 0
           AND ttGlobalSecurityStructure.owning_entity_mnemonic = "GSMRA":U
           AND ttGlobalSecurityStructure.owning_obj             = gsm_range.range_obj:
        
          IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN
              ASSIGN lSecurityRestricted = ttGlobalSecurityStructure.restricted
                     pcRangeFrom         = ttGlobalSecurityStructure.user_allocation_value1
                     pcRangeTo           = ttGlobalSecurityStructure.user_allocation_value2.
          ELSE
              /* In a client-server environment, this security has already been resolved */
              RUN userSecurityCheck IN TARGET-PROCEDURE (INPUT  dUserObj,                      /* logged in as user */
                                                         INPUT  dOrganisationObj,              /* logged into organisation */
                                                         INPUT  "GSMSS":U,                     /* Security Structure FLA */
                                                         INPUT  ttGlobalSecurityStructure.security_structure_obj,
                                                         INPUT  YES,                           /* Return security values - YES */
                                                         OUTPUT lSecurityRestricted,           /* Restricted yes/no ? */
                                                         OUTPUT pcRangeFrom,                   /* clearance value 1 */
                                                         OUTPUT pcRangeTo).                    /* clearance value 2 */
          IF lSecurityRestricted then
              leave FE-BLK.
      END.    /* fe-blk: all */
  &ENDIF
  
  /* Update client cache */
  IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) 
  THEN DO:
      CREATE ttRangeSecurityCheck.
      ASSIGN ttRangeSecurityCheck.cRangeCode     = pcRangeCode
             ttRangeSecurityCheck.cObjectName    = pcObjectName
             ttRangeSecurityCheck.cAttributeCode = pcAttributeCode
             ttRangeSecurityCheck.cRangeFrom     = pcRangeFrom
             ttRangeSecurityCheck.cRangeTo       = pcRangeTo.
  END.
  ASSIGN ERROR-STATUS:ERROR = NO.
  RETURN "":U.
END PROCEDURE.    /* rangeSecurityCheck */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-receiveCacheFldSecurity) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE receiveCacheFldSecurity Procedure 
PROCEDURE receiveCacheFldSecurity :
/*------------------------------------------------------------------------------
  Purpose:     This procedure allows external procedures to supplement the security
               cache.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcObjectName      AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcAttributeCode   AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcSecurityOptions AS CHARACTER  NO-UNDO.
DEFINE BUFFER ttFieldSecurityCheck FOR ttFieldSecurityCheck.
FIND FIRST ttFieldSecurityCheck
     WHERE ttFieldSecurityCheck.cObjectName    = pcObjectName
       AND ttFieldSecurityCheck.cAttributeCode = pcAttributeCode
     NO-ERROR.
IF NOT AVAILABLE ttFieldSecurityCheck 
THEN DO:
    CREATE ttFieldSecurityCheck.
    ASSIGN ttFieldSecurityCheck.cObjectName      = pcObjectName
           ttFieldSecurityCheck.cAttributeCode   = pcAttributeCode.
END.
ASSIGN ttFieldSecurityCheck.cSecurityOptions = pcSecurityOptions
       ERROR-STATUS:ERROR = NO.
RETURN "":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-receiveCacheSessionSecurity) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE receiveCacheSessionSecurity Procedure 
PROCEDURE receiveCacheSessionSecurity :
/*------------------------------------------------------------------------------
  Purpose:     Receives the initial session security cache
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER TABLE FOR ttSecurityControl.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-receiveCacheTokSecurity) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE receiveCacheTokSecurity Procedure 
PROCEDURE receiveCacheTokSecurity :
/*------------------------------------------------------------------------------
  Purpose:     This procedure allows external procedures to supplement the security
               cache.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcObjectName      AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcAttributeCode   AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcSecurityOptions AS CHARACTER  NO-UNDO.
DEFINE BUFFER ttTokenSecurityCheck FOR ttTokenSecurityCheck.
FIND FIRST ttTokenSecurityCheck
     WHERE ttTokenSecurityCheck.cObjectName    = pcObjectName
       AND ttTokenSecurityCheck.cAttributeCode = pcAttributeCode
     NO-ERROR.
IF NOT AVAILABLE ttTokenSecurityCheck 
THEN DO:
    CREATE ttTokenSecurityCheck.
    ASSIGN ttTokenSecurityCheck.cObjectName      = pcObjectName
           ttTokenSecurityCheck.cAttributeCode   = pcAttributeCode.
END.
ASSIGN ttTokenSecurityCheck.cSecurityOptions = pcSecurityOptions
       ERROR-STATUS:ERROR = NO.
RETURN "":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSecurityProperties) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setSecurityProperties Procedure 
PROCEDURE setSecurityProperties :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will:
               1) Set the SecurityEnabled property.
               2) Determine which security groups apply to the user for the login company
               logged into and set a property for easy retrieval.
               3) Set the properties indicating which security to check
                  - FieldSecurityExists YES/NO, TokenSecurityExists YES/NO etc.
  Parameters:  pcProperties - Comma delimited list of session properties to set.
               pcPropValues - CHR(3) list of session property values.  Maps to pcProperties.
  Notes:       This API is for internal Dynamics framework use only.  It is not meant
               to be called from any non-framework objects.
               This API is run at session startup and is called when security information
               is updated.
  ------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER pcProperties AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcPropValues AS CHARACTER  NO-UNDO.

&IF DEFINED(server-side) = 0 &THEN
    /* We need to pass the request to the Appserver */
    RUN af/app/afsecstsecprpp.p ON gshAstraAppServer
      (OUTPUT pcProperties,   
       OUTPUT pcPropValues) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN
      RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                    ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
    /* Set the session properties on the client, the server properties have already been set */
    DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager, INPUT pcProperties, INPUT pcPropValues, INPUT YES) NO-ERROR.

&ELSE
    DEFINE VARIABLE cProperty        AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE dUserObj         AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE dLoginCompanyObj AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE cLoginCompanies  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cSecurityGroups  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE iGroupCnt        AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iCompanyCnt      AS INTEGER    NO-UNDO.

    DEFINE VARIABLE lCheckTokenSecurity      AS LOGICAL    NO-UNDO. 
    DEFINE VARIABLE lCheckFieldSecurity      AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE lCheckMenuItemSecurity   AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE lCheckMenuStructSecurity AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE lCheckObjectSecurity     AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE iSecurityTypesSet        AS INTEGER    NO-UNDO.

    DEFINE BUFFER gsc_security_control   FOR gsc_security_control.
    DEFINE BUFFER gsm_security_structure FOR gsm_security_structure.
    DEFINE BUFFER gsm_user_allocation    FOR gsm_user_allocation.
    DEFINE BUFFER gsm_user               FOR gsm_user.

    /* Clear the ttSecurityControl temp-table. */
    EMPTY TEMP-TABLE ttSecurityControl NO-ERROR.

    /* We're running server side so set our properties while building the lists of *
     * properties and values to return to the client.                              *
     * First we check if security has been enabled.                                */
    FIND FIRST gsc_Security_control NO-ERROR.

    IF NOT AVAILABLE gsc_security_control
    OR gsc_security_control.security_enabled = NO 
    THEN DO:
        ASSIGN pcProperties = "SecurityEnabled,SecurityModel,SecurityGroups,GSMTOSecurityExists,GSMFFSecurityExists,RYCSOSecurityExists,GSMMISecurityExists,GSMMSSecurityExists"
               pcPropValues = "NO":U + CHR(3)
                            + (IF gsc_security_control.full_access_by_default = YES 
                               THEN "Revoke":U
                               ELSE "Grant":U)
                            + CHR(3) + CHR(3) + "NO":U + CHR(3) + "NO":U + CHR(3) + "NO":U + CHR(3)+ "NO":U + CHR(3) + "NO":U.
        DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager, INPUT pcProperties, INPUT pcPropValues, INPUT YES) NO-ERROR.

        ASSIGN ERROR-STATUS:ERROR = NO.
        RETURN "":U.
    END.
    ELSE
        ASSIGN pcProperties = "SecurityEnabled"
               pcPropValues = "YES":U.

    /* Set the GRANT/REVOKE model property */
    ASSIGN pcProperties = pcProperties + ",SecurityModel":U
           pcPropValues = pcPropValues + CHR(3) + IF gsc_security_control.full_access_by_default = YES 
                                                  THEN "Revoke":U
                                                  ELSE "Grant":U.

    /* Now check which security groups apply to this session */
    ASSIGN cProperty        = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,INPUT "currentUserObj,currentOrganisationObj":U,INPUT NO)
           dUserObj         = DECIMAL(ENTRY(1,cProperty,CHR(3)))
           dLoginCompanyObj = DECIMAL(ENTRY(2,cProperty,CHR(3))) 
           NO-ERROR.

    FIND gsm_user NO-LOCK
         WHERE gsm_user.user_obj = dUserObj
         NO-ERROR.

    IF AVAILABLE gsm_user 
    THEN DO:
        RUN getSecurityGroups IN TARGET-PROCEDURE (INPUT dUserObj,
                                                   INPUT dLoginCompanyObj,
                                                   INPUT YES,
                                                   INPUT YES,
                                                   INPUT-OUTPUT cSecurityGroups).

        /* If the user is based on a profile user, get the security groups for the profile user as well */
        IF  gsm_user.created_from_profile_user_obj <> 0
        AND gsm_user.created_from_profile_user_obj <> ? THEN
            RUN getSecurityGroups IN TARGET-PROCEDURE (INPUT gsm_user.created_from_profile_user_obj,
                                                       INPUT dLoginCompanyObj,
                                                       INPUT YES,
                                                       INPUT YES,
                                                       INPUT-OUTPUT cSecurityGroups).
    END.

    ASSIGN cSecurityGroups = RIGHT-TRIM(cSecurityGroups, CHR(4)) /* Remove any trailing CHR(4)s */
           pcProperties    = pcProperties + ",SecurityGroups"
           pcPropValues    = pcPropValues + CHR(3) + cSecurityGroups.

    /* Check which security types apply to this session */
    ASSIGN cSecurityGroups = "0":U + CHR(4) 
                           + (IF cSecurityGroups <> "":U THEN (cSecurityGroups + CHR(4)) ELSE "":U)
                           + STRING(dUserObj) /* Only for the check below - Usually the user is checked seperately, but we want to know if ANY security can be found so include him in the list */
           cLoginCompanies = "0":U + CHR(4) + STRING(dLoginCompanyObj).  /* Only for the check below - We want to check for ALL companies, so check for login company obj = 0 as well */

    allocation-check-blk:
    DO iGroupCnt = 1 TO NUM-ENTRIES(cSecurityGroups, CHR(4)):
        ASSIGN dUserObj = DECIMAL(ENTRY(iGroupCnt, cSecurityGroups, CHR(4))).

        DO iCompanyCnt = 1 TO NUM-ENTRIES(cLoginCompanies, CHR(4)):
            ASSIGN dLoginCompanyObj = DECIMAL(ENTRY(iCompanyCnt, cLoginCompanies, CHR(4))).

            /* Object Security */
            IF lCheckObjectSecurity = NO
            AND CAN-FIND(FIRST gsm_user_allocation NO-LOCK
                         WHERE gsm_user_allocation.user_obj               = dUserObj
                           AND gsm_user_allocation.login_organisation_obj = dLoginCompanyObj 
                           AND gsm_user_allocation.owning_entity_mnemonic = "RYCSO":U) THEN
                ASSIGN lCheckObjectSecurity = YES
                       iSecurityTypesSet    = iSecurityTypesSet + 1.

            IF iSecurityTypesSet >= 5 THEN LEAVE allocation-check-blk. /* We've determined we need to check all 5 types of security, no use in checking further */

            /* Menu Item Security */
            IF lCheckMenuItemSecurity = NO
            AND CAN-FIND(FIRST gsm_user_allocation NO-LOCK
                         WHERE gsm_user_allocation.user_obj               = dUserObj
                           AND gsm_user_allocation.login_organisation_obj = dLoginCompanyObj 
                           AND gsm_user_allocation.owning_entity_mnemonic = "GSMMI":U) THEN
                ASSIGN lCheckMenuItemSecurity = YES
                       iSecurityTypesSet      = iSecurityTypesSet + 1.

            IF iSecurityTypesSet >= 5 THEN LEAVE allocation-check-blk. /* We've determined we need to check all 5 types of security, no use in checking further */

            /* Menu Structure Security */
            IF lCheckMenuStructSecurity = NO
            AND CAN-FIND(FIRST gsm_user_allocation NO-LOCK
                         WHERE gsm_user_allocation.user_obj               = dUserObj
                           AND gsm_user_allocation.login_organisation_obj = dLoginCompanyObj 
                           AND gsm_user_allocation.owning_entity_mnemonic = "GSMMS":U) THEN
                ASSIGN lCheckMenuStructSecurity = YES
                       iSecurityTypesSet        = iSecurityTypesSet + 1.

            IF iSecurityTypesSet >= 5 THEN LEAVE allocation-check-blk. /* We've determined we need to check all 5 types of security, no use in checking further */

            /* Token and field security - user allocations with owning entity of GSMSS are either: data ranges - IGNORE, tokens or fields. */
            IF lCheckFieldSecurity = NO
            OR lCheckTokenSecurity = NO THEN
                fe-blk:
                FOR EACH gsm_user_allocation NO-LOCK
                   WHERE gsm_user_allocation.user_obj               = dUserObj
                     AND gsm_user_allocation.login_organisation_obj = dLoginCompanyObj
                     AND gsm_user_allocation.owning_entity_mnemonic = "GSMSS":U:
    
                    /* Field security */
                    IF lCheckFieldSecurity = NO
                    AND CAN-FIND(FIRST gsm_security_structure
                                 WHERE gsm_security_structure.security_structure_obj = gsm_user_allocation.owning_obj
                                   AND gsm_security_structure.owning_entity_mnemonic = "GSMFF":U) THEN
                        ASSIGN lCheckFieldSecurity = YES
                               iSecurityTypesSet   = iSecurityTypesSet + 1.
    
                    IF iSecurityTypesSet >= 5 THEN LEAVE allocation-check-blk. /* We've determined we need to check all 5 types of security, no use in checking further */
    
                    /* Token security */
                    IF lCheckTokenSecurity = NO
                    AND CAN-FIND(FIRST gsm_security_structure
                                 WHERE gsm_security_structure.security_structure_obj = gsm_user_allocation.owning_obj
                                   AND gsm_security_structure.owning_entity_mnemonic = "GSMTO":U) THEN
                        ASSIGN lCheckTokenSecurity = YES
                               iSecurityTypesSet   = iSecurityTypesSet + 1.
    
                    IF iSecurityTypesSet >= 5 THEN LEAVE allocation-check-blk. /* We've determined we need to check all 5 types of security, no use in checking further */
                END.
        END.
    END.

    /* Ok, we've determined which security types to check, now update the property */
    ASSIGN pcProperties = pcProperties + ",GSMTOSecurityExists,GSMFFSecurityExists,RYCSOSecurityExists,GSMMISecurityExists,GSMMSSecurityExists":U
           pcPropValues = pcPropValues
                        + CHR(3) + STRING(lCheckTokenSecurity)
                        + CHR(3) + STRING(lCheckFieldSecurity)
                        + CHR(3) + STRING(lCheckObjectSecurity)
                        + CHR(3) + STRING(lCheckMenuItemSecurity)
                        + CHR(3) + STRING(lCheckMenuStructSecurity).

    /* Set the session properties on the server, and return the property list and values to the client */
    DYNAMIC-FUNCTION("setPropertyList":U IN gshSessionManager, INPUT pcProperties, INPUT pcPropValues, INPUT YES) NO-ERROR.
    
    /* Now that we've set all the necessary security properties, resolve security structures assigned globally.        *
     * This only makes sense in a client-server environment.  Appserver, we'd have to cache every possible permutation *
     * of user_obj, organisation_obj for every single user in the system.                                              */
    IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN
        FOR EACH ttGlobalSecurityStructure:
            RUN userSecurityCheck IN TARGET-PROCEDURE (INPUT dUserObj,
                                                       INPUT dLoginCompanyObj,
                                                       INPUT ttGlobalSecurityStructure.owning_entity_mnemonic,
                                                       INPUT ttGlobalSecurityStructure.security_structure_obj,
                                                       INPUT NOT ttGlobalSecurityStructure.owning_entity_mnemonic = "GSMTO":U,
                                                       OUTPUT ttGlobalSecurityStructure.restricted,
                                                       OUTPUT ttGlobalSecurityStructure.user_allocation_value1,
                                                       OUTPUT ttGlobalSecurityStructure.user_allocation_value2).
            IF NOT ttGlobalSecurityStructure.restricted THEN
                DELETE ttGlobalSecurityStructure.
        END.
&ENDIF

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":u.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tableSecurityCheck) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE tableSecurityCheck Procedure 
PROCEDURE tableSecurityCheck :
/*------------------------------------------------------------------------------
  Purpose:     This procedure checks a user's security for table field values
               permitted access to.

  Parameters:  Input table FLA to check user security clearance for
               Input field name with no table prefix
               Output comma seperated list of valid values, "" = all

  Notes:       See Astra Security Documentation for full information.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  pcOwningEntityMnemonic          AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  pcEntityFieldName               AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcValidValues                   AS CHARACTER    NO-UNDO.

  ASSIGN pcValidValues = "":U.

  /* If client side, check local cache to see if already checked and if so use cached value */
  IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) 
  THEN DO:
      FIND FIRST ttTableSecurityCheck
           WHERE ttTableSecurityCheck.cOwningEntityMnemonic = pcOwningEntityMnemonic
             AND ttTableSecurityCheck.cEntityFieldName = pcEntityFieldName
           NO-ERROR.
      IF AVAILABLE ttTableSecurityCheck 
      THEN DO:
          ASSIGN pcValidValues = ttTableSecurityCheck.cValidValues.
          RETURN.        
      END.
  END.

  &IF DEFINED(server-side) = 0 &THEN
      /* We need to pass the request to the Appserver */
        RUN af/app/afsectblsecchkp.p ON gshAstraAppServer
          (INPUT  pcOwningEntityMnemonic,   
           INPUT  pcEntityFieldName,   
           OUTPUT pcValidValues) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN
          RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                        ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
  &ELSE
      DEFINE VARIABLE lSecurityRestricted AS LOGICAL   NO-UNDO.
      DEFINE VARIABLE cSecurityValue1     AS CHARACTER NO-UNDO.
      DEFINE VARIABLE cSecurityValue2     AS CHARACTER NO-UNDO.
      DEFINE VARIABLE cSecurityProperties AS CHARACTER NO-UNDO.
      DEFINE VARIABLE cUserProperties     AS CHARACTER NO-UNDO.
      DEFINE VARIABLE cUserValues         AS CHARACTER NO-UNDO.
                
      ASSIGN pcValidValues       = "":U
             cSecurityProperties = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager, INPUT "SecurityEnabled":U,INPUT YES).

      IF ENTRY(1, cSecurityProperties, CHR(3)) = "NO":U THEN /* Security Enabled */
          RETURN.
        
      FIND FIRST gsm_entity_field NO-LOCK
           WHERE gsm_entity_field.owning_entity_mnemonic = pcOwningEntityMnemonic
             AND gsm_entity_field.entity_field_name = pcEntityFieldName
           NO-ERROR.

      IF NOT AVAILABLE gsm_entity_field 
      OR NOT CAN-FIND(FIRST gsm_entity_field_value
                      WHERE gsm_entity_field_value.entity_field_obj = gsm_entity_field.entity_field_obj) THEN
          RETURN.
        
      /* Get current up-to-date user information to be sure */
      ASSIGN cUserProperties = "currentUserObj,currentOrganisationObj".
             cUserValues     = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,INPUT cUserProperties,INPUT NO).
        
      FOR EACH gsm_entity_field_value NO-LOCK
         WHERE gsm_entity_field_value.entity_field_obj = gsm_entity_field.entity_field_obj:
        
          RUN userSecurityCheck IN TARGET-PROCEDURE (INPUT  DECIMAL(ENTRY(1,cUserValues,CHR(3))),  /* logged in as user */
                                                     INPUT  DECIMAL(ENTRY(2,cUserValues,CHR(3))),  /* logged into organisation */
                                                     INPUT  "gsmev":U,                      /* Entity field value FLA */
                                                     INPUT  gsm_entity_field_value.entity_field_value_obj,
                                                     INPUT  NO,                             /* Return values - NO */
                                                     OUTPUT lSecurityRestricted,            /* Restricted yes/no ? */
                                                     OUTPUT cSecurityValue1,                /* clearance value 1 */
                                                     OUTPUT cSecurityValue2).               /* clearance value 2 */
          IF NOT lSecurityRestricted THEN
            ASSIGN pcValidValues = pcValidValues + (IF pcValidValues <> "":U THEN ",":U ELSE "":U) 
                                 + REPLACE(gsm_entity_field_value.entity_field_contents,",":U," ":U).
      END. /* each entity field value */
  &ENDIF

  /* Update client cache */
  IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) 
  THEN DO:
      CREATE ttTableSecurityCheck.
      ASSIGN ttTableSecurityCheck.cOwningEntityMnemonic = pcOwningEntityMnemonic
             ttTableSecurityCheck.cEntityFieldName = pcEntityFieldName
             ttTableSecurityCheck.cValidValues = pcValidValues.
  END.

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tokenSecurityCheck) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE tokenSecurityCheck Procedure 
PROCEDURE tokenSecurityCheck :
/*------------------------------------------------------------------------------
  Purpose:     This procedure checks a user's security for tokens permitted
               access to.

  Parameters:  input current program object for security check
               input current instance attribute posted to program
               output security options as comma delimited list of security tokens
               user does not have security clearance for, currently used in toolbar
               panel views to disable buttons and folder windows to disable
               folder pages, etc.

  Notes:       See Astra Security Documentation for full information.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcObjectName      AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER pcAttributeCode   AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER pcSecurityOptions AS CHARACTER NO-UNDO.

  /* If client side, check local cache to see if already checked and if so use cached value */
  IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) 
  THEN DO:
      FIND FIRST ttTokenSecurityCheck
           WHERE ttTokenSecurityCheck.cObjectName    = pcObjectName
             AND ttTokenSecurityCheck.cAttributeCode = pcAttributeCode
           NO-ERROR.

      IF AVAILABLE ttTokenSecurityCheck 
      THEN DO:
          ASSIGN pcSecurityOptions = ttTokenSecurityCheck.cSecurityOptions.
          RETURN.        
      END.
  END.

  &IF DEFINED(server-side) = 0 &THEN
      RUN af/app/afsectknsecchkp.p ON gshAstraAppServer
        (INPUT  pcObjectName,   
         INPUT  pcAttributeCode,   
         OUTPUT pcSecurityOptions) NO-ERROR.
      IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN
        RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                      ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
  &ELSE
      DEFINE VARIABLE dProductModuleObj     AS DECIMAL   NO-UNDO.
      DEFINE VARIABLE dSecurityObjectObj    AS DECIMAL   NO-UNDO.
      DEFINE VARIABLE dAttributeObj         AS DECIMAL   NO-UNDO.
      DEFINE VARIABLE cSecurityProperties   AS CHARACTER NO-UNDO.
      DEFINE VARIABLE dUserObj              AS DECIMAL   NO-UNDO.
      DEFINE VARIABLE dOrganisationObj      AS DECIMAL   NO-UNDO.
      DEFINE VARIABLE cObjectExt            AS CHARACTER NO-UNDO.
      DEFINE VARIABLE lSecurityRestricted   AS LOGICAL   NO-UNDO.
      DEFINE VARIABLE cReturnValueNeverUsed AS CHARACTER NO-UNDO.
      DEFINE VARIABLE cObjList              AS CHARACTER NO-UNDO.
      
      DEFINE BUFFER b1ryc_smartobject      FOR ryc_smartobject.
      DEFINE BUFFER b2ryc_smartobject      FOR ryc_smartobject.
      DEFINE BUFFER gsm_security_structure FOR gsm_security_structure.
      DEFINE BUFFER gsm_token              FOR gsm_token.
      
      /* If security is disabled or the security object is not passed in then "" is
       * returned indicating full access is permitted.
       * The routine loops around the available tokens. If a token is disabled or no
       * security structure exists for it, i.e. it is not used, then it is assumed
       * that the user is simply ignored - indicating full access to the token.
       * For each token that is enabled and used, checks are made to see whether the
       * user has restricted access to the token, and if so, whether the token is
       * disabled for the user.
       * Only restricted (user disabled) tokens are returned in the list. */
      ASSIGN cSecurityProperties  = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager, 
                                    INPUT "SecurityEnabled,currentUserObj,currentOrganisationObj":U,INPUT YES). /* These properties should be set in the session manager cache, don't go to the db */
      
      IF ENTRY(1, cSecurityProperties, CHR(3)) = "NO":U THEN /* Security Enabled */
          RETURN.
      
      ASSIGN dUserObj         = DECIMAL(ENTRY(2,cSecurityProperties,CHR(3)))
             dOrganisationObj = DECIMAL(ENTRY(3,cSecurityProperties,CHR(3)))
             NO-ERROR.
      
      /* Check if security is turned on for the object (the object will have a security object   *
       * specified), and if it is, work out what the security object is (probably itself but can *
       * be set-up as something else).                                                           */
      FIND FIRST b1ryc_smartobject NO-LOCK
           WHERE b1ryc_smartobject.object_filename = pcObjectName
           NO-ERROR.

      /* If not found then check with separated extension */
      IF NOT AVAILABLE b1ryc_smartobject THEN
          IF R-INDEX(pcObjectName,".") > 0
          THEN DO:
              ASSIGN cObjectExt = ENTRY(NUM-ENTRIES(pcObjectName,"."),pcObjectName,".").

              FIND FIRST b1ryc_smartobject NO-LOCK
                   WHERE b1ryc_smartobject.object_filename  = REPLACE(pcObjectName,("." + cObjectExt),"") /* Replace .ext with blank, effectively removing the file extension */ 
                     AND b1ryc_smartobject.object_Extension = cObjectExt
                   NO-ERROR.

              IF NOT AVAILABLE b1ryc_smartobject THEN
                  RETURN.
          END.
          ELSE
              RETURN. /* The object is not in the repository */

      /* Is the object secured by another object? */
      IF b1ryc_smartobject.smartobject_obj = b1ryc_smartobject.security_smartobject_obj THEN
          ASSIGN dSecurityObjectObj = b1ryc_smartobject.smartobject_obj
                 dProductModuleObj  = b1ryc_smartobject.product_module_obj.
      ELSE DO:
          FIND b2ryc_smartobject NO-LOCK
               WHERE b2ryc_smartobject.smartobject_obj = b1ryc_smartobject.security_smartobject_obj
               NO-ERROR.

          IF AVAILABLE b2ryc_smartobject THEN
              ASSIGN dSecurityObjectObj = b2ryc_smartobject.smartobject_obj
                     dProductModuleObj  = b2ryc_smartobject.product_module_obj.
          ELSE
              RETURN. /* Couldn't find the security object */
      END.
      
      /* Find the run attribute obj if a run attribute has been passed in */
      IF pcAttributeCode <> "":U 
      THEN DO:
          FIND gsc_instance_attribute NO-LOCK
               WHERE gsc_instance_attribute.attribute_code = pcAttributeCode
               NO-ERROR.
      
          IF AVAILABLE gsc_instance_attribute THEN
              ASSIGN dAttributeObj = gsc_instance_attribute.instance_attribute_obj.
      END.
      
      /* Check which tokens user does not have security clearance for. In the case of token security, no
       * attributes are passed back, but we must still check for specific object instance details first
       * as this will override generic settings. */
      
      /* Check for specific object instance */
      IF dAttributeObj <> 0 THEN
          fe-blk:
          FOR EACH gsm_security_structure NO-LOCK
             WHERE gsm_security_structure.owning_entity_mnemonic = "GSMTO":U            
               AND gsm_security_structure.product_module_obj     = dProductModuleObj   
               AND gsm_security_structure.object_obj             = dSecurityObjectObj  
               AND gsm_security_structure.instance_attribute_obj = dAttributeObj       
               AND gsm_security_structure.disabled               = NO:
          
              /* If the field is secured already, then do nothing. */
              IF LOOKUP(STRING(gsm_security_structure.owning_obj), cObjList, CHR(4)) > 0 THEN
                  NEXT fe-blk.
      
              RUN userSecurityCheck IN TARGET-PROCEDURE (INPUT  dUserObj,                      /* logged in as user */
                                                         INPUT  dOrganisationObj,              /* logged into organisation */
                                                         INPUT  "GSMTO":U,                     /* The user allocation check will assign this back to GSMSS, which is the Security Structure FLA */
                                                         INPUT  gsm_security_structure.security_structure_obj,
                                                         INPUT  NO,                            /* Return security values - NO */
                                                         OUTPUT lSecurityRestricted,           /* Restricted yes/no ? */
                                                         OUTPUT cReturnValueNeverUsed,         /* clearance value 1 */
                                                         OUTPUT cReturnValueNeverUsed).        /* clearance value 2 */
              IF lSecurityRestricted 
              THEN DO:
                  FIND gsm_token NO-LOCK
                       WHERE gsm_token.token_obj = gsm_security_structure.owning_obj
                       NO-ERROR.
                  IF AVAILABLE gsm_token
                  AND NOT gsm_token.DISABLED THEN /* We so this check here because chances are EXTREMELY small that the token is going to disabled.  We only want to do a find if really necessary */
                      ASSIGN pcSecurityOptions = pcSecurityOptions + gsm_token.token_code + ",":U
                             cObjList          = cObjList + STRING(gsm_token.token_obj) + CHR(4).
              END.
          END.
      
      /* Check for object with no run attribute */
      fe-blk:
      FOR EACH gsm_security_structure NO-LOCK
         WHERE gsm_security_structure.owning_entity_mnemonic = "GSMTO":U
           AND gsm_security_structure.product_module_obj     = dProductModuleObj   
           AND gsm_security_structure.object_obj             = dSecurityObjectObj  
           AND gsm_security_structure.instance_attribute_obj = 0                   
           AND gsm_security_structure.disabled               = NO:
      
          /* If the field is secured already, then do nothing. */
          IF LOOKUP(STRING(gsm_security_structure.owning_obj), cObjList, CHR(4)) > 0 THEN
              NEXT fe-blk.
       
          RUN userSecurityCheck IN TARGET-PROCEDURE (INPUT  dUserObj,                      /* logged in as user */
                                                     INPUT  dOrganisationObj,              /* logged into organisation */
                                                     INPUT  "GSMTO":U,                     /* The user allocation check will assign this back to GSMSS, which is the Security Structure FLA */
                                                     INPUT  gsm_security_structure.security_structure_obj,
                                                     INPUT  NO,                            /* Return security values - NO */
                                                     OUTPUT lSecurityRestricted,           /* Restricted yes/no ? */
                                                     OUTPUT cReturnValueNeverUsed,         /* clearance value 1 */
                                                     OUTPUT cReturnValueNeverUsed).        /* clearance value 2 */
          IF lSecurityRestricted 
          THEN DO:
              FIND gsm_token NO-LOCK
                   WHERE gsm_token.token_obj = gsm_security_structure.owning_obj
                   NO-ERROR.
              IF AVAILABLE gsm_token
              AND NOT gsm_token.DISABLED THEN /* We so this check here because chances are EXTREMELY small that the token is going to disabled.  We only want to do a find if really necessary */
                  ASSIGN pcSecurityOptions = pcSecurityOptions + gsm_token.token_code + ",":U
                         cObjList          = cObjList + STRING(gsm_token.token_obj) + CHR(4).
          END.        
      END.    /* object instance */
      
      /* Check for all objects in specific product module */
      fe-blk:
      FOR EACH ttGlobalSecurityStructure
         WHERE ttGlobalSecurityStructure.product_module_obj     = dProductModuleObj
           AND ttGlobalSecurityStructure.owning_entity_mnemonic = "GSMTO":U:
      
          /* If the field is secured already, then do nothing. */
          IF LOOKUP(STRING(ttGlobalSecurityStructure.owning_obj), cObjList, CHR(4)) > 0 THEN
              NEXT fe-blk.

          /* When running client-server, security for this token has already been resolved */
          IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN
              ASSIGN pcSecurityOptions = pcSecurityOptions + ttGlobalSecurityStructure.security_object_name + ",":U
                     cObjList          = cObjList + STRING(ttGlobalSecurityStructure.owning_obj) + CHR(4).
          ELSE DO:
              RUN userSecurityCheck IN TARGET-PROCEDURE (INPUT  dUserObj,                      /* logged in as user */
                                                         INPUT  dOrganisationObj,              /* logged into organisation */
                                                         INPUT  "GSMTO":U,                     /* The user allocation check will assign this back to GSMSS, which is the Security Structure FLA */
                                                         INPUT  ttGlobalSecurityStructure.security_structure_obj,
                                                         INPUT  NO,                            /* Return security values - NO */
                                                         OUTPUT lSecurityRestricted,           /* Restricted yes/no ? */
                                                         OUTPUT cReturnValueNeverUsed,         /* clearance value 1 */
                                                         OUTPUT cReturnValueNeverUsed).        /* clearance value 2 */

              IF lSecurityRestricted THEN
                  ASSIGN pcSecurityOptions = pcSecurityOptions + ttGlobalSecurityStructure.security_object_name + ",":U
                         cObjList          = cObjList + STRING(ttGlobalSecurityStructure.owning_obj) + CHR(4).
          END.
      END.
      
      /* Globally defined token security (as cached in ttGlobalSecurityStructure) */
      fe-blk:
      FOR EACH ttGlobalSecurityStructure
         WHERE ttGlobalSecurityStructure.product_module_obj     = 0
           AND ttGlobalSecurityStructure.owning_entity_mnemonic = "GSMTO":U:
      
          /* If the field is secured already, then do nothing. */
          IF LOOKUP(STRING(ttGlobalSecurityStructure.owning_obj), cObjList, CHR(4)) > 0 THEN
              NEXT fe-blk.

          /* When running client-server, security for this token has already been resolved */
          IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) THEN
              ASSIGN pcSecurityOptions = pcSecurityOptions + ttGlobalSecurityStructure.security_object_name + ",":U
                     cObjList          = cObjList + STRING(ttGlobalSecurityStructure.owning_obj) + CHR(4).
          ELSE DO:
              RUN userSecurityCheck IN TARGET-PROCEDURE (INPUT  dUserObj,                      /* logged in as user */
                                                         INPUT  dOrganisationObj,              /* logged into organisation */
                                                         INPUT  "GSMTO":U,                     /* The user allocation check will assign this back to GSMSS, which is the Security Structure FLA */
                                                         INPUT  ttGlobalSecurityStructure.security_structure_obj,
                                                         INPUT  NO,                            /* Return security values - NO */
                                                         OUTPUT lSecurityRestricted,           /* Restricted yes/no ? */
                                                         OUTPUT cReturnValueNeverUsed,         /* clearance value 1 */
                                                         OUTPUT cReturnValueNeverUsed).        /* clearance value 2 */

              IF lSecurityRestricted THEN
                  ASSIGN pcSecurityOptions = pcSecurityOptions + ttGlobalSecurityStructure.security_object_name + ",":U
                         cObjList          = cObjList + STRING(ttGlobalSecurityStructure.owning_obj) + CHR(4).
          END.
      END. /* all tokens */

      ASSIGN pcSecurityOptions = RIGHT-TRIM(pcSecurityOptions, ",":U).
  &ENDIF

  /* Update client cache */
  IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) 
  THEN DO:
      CREATE ttTokenSecurityCheck.
      ASSIGN ttTokenSecurityCheck.cObjectName      = pcObjectName
             ttTokenSecurityCheck.cAttributeCode   = pcAttributeCode
             ttTokenSecurityCheck.cSecurityOptions = pcSecurityOptions.
  END.

  ASSIGN ERROR-STATUS:ERROR = NO.
  RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tokenSecurityGet) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE tokenSecurityGet Procedure 
PROCEDURE tokenSecurityGet :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will check tokens secured for the passed in object.
               If a valid procedure handle is passed in, and the object has been secured
               by the repository manager already, the security stored in the object
               will be used.  If we can't find the security in the object, we'll fetch
               the applicable security from the db/Appserver and return it (by running
               the tokenSecurityCheck procedure).
  Parameters:  phObject          - The handle to the object being checked.  This parameter
                                   is optional.  If not specified, a standard security check
                                   will be done using the object name.
               pcObjectName      - The name of the object being checked. (Mandatory)
               pcAttributeCode   - The attribute code of the object being checked. (Mandatory)
               pcSecurityOptions - The list of secured fields.
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phObject          AS HANDLE     NO-UNDO.
DEFINE INPUT  PARAMETER pcObjectName      AS CHARACTER    NO-UNDO.
DEFINE INPUT  PARAMETER pcAttributeCode   AS CHARACTER    NO-UNDO.
DEFINE OUTPUT PARAMETER pcSecurityOptions AS CHARACTER    NO-UNDO.

DEFINE BUFFER ttTokenSecurityCheck FOR ttTokenSecurityCheck.

DEFINE VARIABLE lObjectSecured AS LOGICAL    NO-UNDO.

/* Always check the cache first */
FIND FIRST ttTokenSecurityCheck
     WHERE ttTokenSecurityCheck.cObjectName    = pcObjectName
       AND ttTokenSecurityCheck.cAttributeCode = pcAttributeCode
     NO-ERROR.

IF AVAILABLE ttTokenSecurityCheck 
THEN DO:
    ASSIGN pcSecurityOptions = ttTokenSecurityCheck.cSecurityOptions.
    RETURN.
END.

/* Has the object been secured?  No use in trying to get security from it if it hasn't... */
IF VALID-HANDLE(phObject)
THEN then-blk: DO:
    {get objectSecured lObjectSecured phObject}.
    IF lObjectSecured
    THEN DO:
        {get SecuredTokens pcSecurityOptions phObject}.
        IF pcSecurityOptions = ? THEN
            LEAVE then-blk.

        /* Add the security to the security manager cache if its not in yet. */
        CREATE ttTokenSecurityCheck.
        ASSIGN ttTokenSecurityCheck.cObjectName      = pcObjectName
               ttTokenSecurityCheck.cAttributeCode   = pcAttributeCode
               ttTokenSecurityCheck.cSecurityOptions = pcSecurityOptions.
        RETURN.
    END.
END.

/* If we get here, the object hasn't been secured yet.  We're going to have to get security from the database/Appserver. */
RUN tokenSecurityCheck IN TARGET-PROCEDURE (INPUT pcObjectName,
                                            INPUT pcAttributeCode,
                                            OUTPUT pcSecurityOptions).

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateUserAllocations) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateUserAllocations Procedure 
PROCEDURE updateUserAllocations :
/*------------------------------------------------------------------------------
  Purpose:     Creates user security allocations in the database.
  Parameters:  pdUserObj         - The user obj number or 0 for all
               pdOrganisationObj - The login organisation obj or 0 for all
               TEMP-TABLE ttUpdatedAllocations - containing info for user allocations
               to update.
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pdUserObj         AS DECIMAL    NO-UNDO.
DEFINE INPUT PARAMETER pdOrganisationObj AS DECIMAL    NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR ttUpdatedAllocations.

&IF DEFINED(server-side) = 0 &THEN
    RUN af/app/afsecupdusrallocp.p ON gshAstraAppServer
      (INPUT  pdUserObj,   
       INPUT  pdOrganisationObj,   
       INPUT TABLE ttUpdatedAllocations) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN
      RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                    ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
&ELSE
    {af/app/afsecupdusrallocp.i}
&ENDIF

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-userLoginOrganisations) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE userLoginOrganisations Procedure 
PROCEDURE userLoginOrganisations :
/*------------------------------------------------------------------------------
  Purpose:     To check which Organisations a user has access to.
  Parameters:  Input the User Obj
               Output a comma delimited list of list pairs i.e. 
               organisation obj, name of organisation, organisation obj, name of organisation etc. 
  Notes:       This procedure is not used anywhere in Dynamics and is kept purely for
               backward compatibility.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pdUserObj       AS DECIMAL   NO-UNDO.
  DEFINE OUTPUT PARAMETER pcOrganisations AS CHARACTER NO-UNDO.

  &IF DEFINED(server-side) = 0 &THEN
      RUN af/app/afsecusrlgnorgp.p ON gshAstraAppServer
        (INPUT  pdUserObj,   
         OUTPUT pcOrganisations) NO-ERROR.
      IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN
        RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                      ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
  &ELSE
    DEFINE BUFFER bgsm_user_allocation FOR gsm_user_allocation.
    DEFINE BUFFER bgsm_login_company   FOR gsm_login_company.

    /* if there are NO specific login companies to which this user is denied access, list all the login companies*/
    /* PSC00328149:
     we cann't use comma(,) in pcOrganisations assignment string, since bgsm_login_company.login_company_obj 
     will have comma(,) as numeric-decimal-point for European settings. further where ever pcOrganisations
     is used to get the expected output it returns wrong result. So to make it operational we will be using hash(#).
    */
    IF NOT CAN-FIND(FIRST bgsm_user_allocation
                    WHERE bgsm_user_allocation.USER_obj               = pdUserObj
                      AND bgsm_user_allocation.login_organisation_obj = 0
                      AND bgsm_user_allocation.owning_entity_mnemonic = 'GSMLG':U) 
    THEN DO:
        FOR EACH bgsm_login_company NO-LOCK:
            ASSIGN pcOrganisations = pcOrganisations + bgsm_login_company.login_company_name + " (" + bgsm_login_company.login_company_short_name + ")#" + string(bgsm_login_company.login_company_obj) + "#".
        END.
    END.
    /* if there ARE specific login companies to which this user has restricted access, list only those login companies they have access to */
    ELSE DO:
        FOR EACH bgsm_login_company NO-LOCK:
            IF CAN-FIND(FIRST bgsm_user_allocation
                            WHERE bgsm_user_allocation.USER_obj = pdUserObj
                              AND bgsm_user_allocation.login_organisation_obj = 0
                              AND bgsm_user_allocation.owning_entity_mnemonic = 'GSMLG':U
                              AND bgsm_user_allocation.owning_obj = bgsm_login_company.login_company_obj
                              and bgsm_user_allocation.user_allocation_value1 = "no" ) THEN
            ASSIGN pcOrganisations = pcOrganisations + bgsm_login_company.login_company_name + " (" + bgsm_login_company.login_company_short_name + ")#" + string(bgsm_login_company.login_company_obj) + "#".
        END.
    END.
  &ENDIF

  IF SUBSTRING(pcOrganisations,LENGTH(pcOrganisations)) = "#"  THEN
      ASSIGN pcOrganisations = SUBSTRING(pcOrganisations,1,(LENGTH(pcOrganisations) - 1)).

  ERROR-STATUS:ERROR = NO.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-userSecurityCheck) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE userSecurityCheck Procedure 
PROCEDURE userSecurityCheck :
/*------------------------------------------------------------------------------
  Purpose:     This procedure checks a user's security allocation for the passed
               in company, and security option, according to the rules mentioned in
               the notes. The types of security checks that could be made are for
               access to tokens, fields, data, data ranges, menu items, etc. The type
               of security check is dependant on the entity mnemonic and obj passed in.

  Parameters:  pdUserObj                  The user being checked
               pdOrganisationObj          The company the user is logged into
               pcOwningEntityMnemonic     The security table being checked
               pdOwningObj                The security table object being checked
               plSecurityCleared          Returns YES if security checked is passed
               pcSecurityValue1           Returns any specific security data
               pcSecurityValue2           Returns any specific security data

  Notes:       See Astra Security Documentation for full information on the rules that
               apply to security checks for a user / company. 
------------------------------------------------------------------------------*/
{af/app/usrSecChck.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-areFieldsCached) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION areFieldsCached Procedure 
FUNCTION areFieldsCached RETURNS LOGICAL
  (INPUT pcObjectName   AS CHARACTER,
   INPUT pcRunAttribute AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Indicates if security fields for a specific object have been cached.
    Notes:  
------------------------------------------------------------------------------*/
RETURN CAN-FIND(FIRST ttFieldSecurityCheck
                WHERE ttFieldSecurityCheck.cObjectName    = pcObjectName
                  AND ttFieldSecurityCheck.cAttributeCode = pcRunAttribute).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-areTokensCached) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION areTokensCached Procedure 
FUNCTION areTokensCached RETURNS LOGICAL
  (INPUT pcObjectName   AS CHARACTER,
   INPUT pcRunAttribute AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Indicates if security tokens for a specific object have been cached.
    Notes:  
------------------------------------------------------------------------------*/
RETURN CAN-FIND(FIRST ttTokenSecurityCheck
                WHERE ttTokenSecurityCheck.cObjectName    = pcObjectName
                  AND ttTokenSecurityCheck.cAttributeCode = pcRunAttribute).
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

