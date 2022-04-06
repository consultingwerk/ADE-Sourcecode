&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*---------------------------------------------------------------------------------
  File:         afsecupdusrallocp.i

  Description:  Update User Allocation include

  Purpose:      Update User Allocation include

  Parameters:

  History:
  --------
  (v:010000)    Task:             UserRef:    
                Date:   07/30/2003  Author:     Bruce S Gruenbaum

  Update Notes: Move osm- modules to af- modules

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* object identifying preprocessor */
&glob   AstraInclude    yes

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 23.48
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */

    DEFINE BUFFER bttUpdatedAllocations FOR ttUpdatedAllocations.

    DEFINE VARIABLE cSecurityType AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cOwningEntity AS CHARACTER  NO-UNDO.

    /* Server side, do validation */
    IF pdUserObj <> 0 THEN
        IF NOT CAN-FIND(FIRST gsm_user
                        WHERE gsm_user.user_obj = pdUserObj) THEN
            RETURN {aferrortxt.i 'AF' '5' '' '' "'user'"}.

    IF pdOrganisationObj <> 0 THEN
        IF NOT CAN-FIND(FIRST gsm_login_company
                        WHERE gsm_login_company.login_company_obj = pdOrganisationObj) THEN
            RETURN {aferrortxt.i 'AF' '5' '' '' "'login organisation'"}.

    main-fe-blk:
    FOR EACH bttUpdatedAllocations
       BREAK BY bttUpdatedAllocations.owning_entity_mnemonic:

        /* If we have to delete all allocations of this security type, then do so. */
        IF FIRST-OF(bttUpdatedAllocations.owning_entity_mnemonic)
        THEN DO:
            /* Make sure we know what type of security we're processing and under what *
             * owning entity it would be stored.                                       */
            ASSIGN cSecurityType = bttUpdatedAllocations.owning_entity_mnemonic.
            IF CAN-DO("GSMRA,GSMFF,GSMTO":U, cSecurityType) THEN
                ASSIGN cOwningEntity = "GSMSS".
            ELSE
                ASSIGN cOwningEntity = cSecurityType.

            /* If we need to delete all user allocations for this security type, do so */
            IF CAN-FIND(FIRST ttUpdatedAllocations
                        WHERE ttUpdatedAllocations.owning_entity_mnemonic = cSecurityType
                          AND ttUpdatedAllocations.lDeleteAll = YES)
            THEN DO TRANSACTION ON ERROR UNDO, RETURN {aferrortxt.i 'AF' '40' '' '' "'User allocation update failed, reason not known.  Please contact your System Administrator.'"}:
                fe-blk:
                FOR EACH gsm_user_allocation EXCLUSIVE-LOCK
                   WHERE gsm_user_allocation.owning_entity_mnemonic = (IF cOwningEntity = "ALL":U THEN gsm_user_allocation.owning_entity_mnemonic ELSE cOwningEntity)
                     AND gsm_user_allocation.user_obj               = (IF cOwningEntity = "ALL":U THEN gsm_user_allocation.user_obj ELSE pdUserObj)
                     AND gsm_user_allocation.login_organisation_obj = (IF cOwningEntity = "ALL":U THEN gsm_user_allocation.login_organisation_obj ELSE pdOrganisationObj):

                    /* Make sure we don't delete tokens, fields or range allocations by mistake when the owning entity = GSMSS */
                    IF CAN-DO("GSMRA,GSMFF,GSMTO":U, cSecurityType) THEN
                            IF NOT CAN-FIND(FIRST gsm_security_structure
                                            WHERE gsm_security_structure.security_structure_obj = gsm_user_allocation.owning_obj
                                              AND gsm_security_structure.owning_entity_mnemonic = cSecurityType) THEN
                                NEXT fe-blk.

                    DELETE gsm_user_allocation NO-ERROR.
                    IF RETURN-VALUE <> "":U THEN
                        RETURN RETURN-VALUE.
                    ELSE
                        IF ERROR-STATUS:ERROR THEN
                            RETURN {aferrortxt.i 'AF' '40' '' '' "'Deletion of user allocations failed, reason not known.  Please contact your System Administrator.'"}.
                END.

                /* Delete all other records of the security type on the temp-table */
                FOR EACH ttUpdatedAllocations
                   WHERE ttUpdatedAllocations.owning_entity_mnemonic = IF cOwningEntity = "ALL":U THEN ttUpdatedAllocations.owning_entity_mnemonic ELSE cSecurityType:
                    DELETE ttUpdatedAllocations.
                END.
                NEXT main-fe-blk.
            END.

            FOR EACH ttUpdatedAllocations
               WHERE ttUpdatedAllocations.owning_entity_mnemonic = cSecurityType:
                /* Update the record */
                FIND gsm_user_allocation NO-LOCK
                     WHERE gsm_user_allocation.owning_entity_mnemonic = cOwningEntity
                       AND gsm_user_allocation.owning_obj             = ttUpdatedAllocations.owning_obj
                       AND gsm_user_allocation.user_obj               = pdUserObj
                       AND gsm_user_allocation.login_organisation_obj = pdOrganisationObj
                     NO-ERROR.

                DO TRANSACTION ON ERROR UNDO, RETURN "Error":
                    /* If the user allocation does not exist, create it */
                    IF NOT AVAILABLE gsm_user_allocation 
                    THEN DO:
                        CREATE gsm_user_allocation NO-ERROR.
                        IF RETURN-VALUE <> "":U THEN
                            RETURN RETURN-VALUE.
                        ELSE
                            IF ERROR-STATUS:ERROR THEN
                                RETURN {aferrortxt.i 'AF' '40' '' '' "'Creation of user allocation failed, reason not known.  Please contact your System Administrator.'"}.

                        /* Assign values */
                        ASSIGN gsm_user_allocation.owning_entity_mnemonic = cOwningEntity
                               gsm_user_allocation.owning_obj             = ttUpdatedAllocations.owning_obj
                               gsm_user_allocation.user_obj               = pdUserObj
                               gsm_user_allocation.login_organisation_obj = pdOrganisationObj.

                        VALIDATE gsm_user_allocation NO-ERROR.
                        IF RETURN-VALUE <> "":U THEN
                            RETURN RETURN-VALUE.
                        ELSE
                            IF ERROR-STATUS:ERROR THEN
                                RETURN {aferrortxt.i 'AF' '40' '' '' "'Assignment of user allocation values failed, reason not known.  Please contact your System Administrator.'"}.
                    END.

                    /* Upgrade the lock */
                    FIND CURRENT gsm_user_allocation EXCLUSIVE-LOCK.

                    /* Now check what we want to do */
                    IF ttUpdatedAllocations.lDelete 
                    THEN DO:
                        DELETE gsm_user_allocation NO-ERROR.
                        IF RETURN-VALUE <> "":U THEN
                            RETURN RETURN-VALUE.
                        ELSE
                            IF ERROR-STATUS:ERROR THEN
                                RETURN {aferrortxt.i 'AF' '40' '' '' "'Deletion of user allocations failed, reason not known.  Please contact your System Administrator.'"}.
                    END.
                    ELSE
                        IF ttUpdatedAllocations.lUpdateValue1AndValue2 
                        THEN DO:
                            ASSIGN gsm_user_allocation.user_allocation_value1 = ttUpdatedAllocations.user_allocation_value1
                                   gsm_user_allocation.user_allocation_value2 = ttUpdatedAllocations.user_allocation_value2.
                            VALIDATE gsm_user_allocation NO-ERROR.
                            IF RETURN-VALUE <> "":U THEN
                                RETURN RETURN-VALUE.
                            ELSE
                                IF ERROR-STATUS:ERROR THEN
                                    RETURN {aferrortxt.i 'AF' '40' '' '' "'Assignment of user allocation values failed, reason not known.  Please contact your System Administrator.'"}.
                        END.
                END.

                /* Downgrade the lock */
                IF AVAILABLE gsm_user_allocation THEN
                    FIND CURRENT gsm_user_allocation NO-LOCK.
            END.
        END.
    END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


