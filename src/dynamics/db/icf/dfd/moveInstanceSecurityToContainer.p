/** This utility will move all security structures allocated against container instances to the container.
    This program is rerunnable.
   ------------------------------------------------------------------------------------------------------ **/
DEFINE BUFFER gsm_security_structure  FOR gsm_security_structure.
DEFINE BUFFER bgsm_security_structure FOR gsm_security_structure.
DEFINE BUFFER gsm_user_allocation     FOR gsm_user_allocation.
DEFINE BUFFER bgsm_user_allocation    FOR gsm_user_allocation.
DEFINE BUFFER ryc_smartobject         FOR ryc_smartobject.
DEFINE BUFFER brycso_container        FOR ryc_smartobject.
DEFINE BUFFER gsc_object_type         FOR gsc_object_type.

DEFINE VARIABLE dObjectTypeObj    AS DECIMAL    NO-UNDO.
DEFINE VARIABLE lError            AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cContainerClasses AS CHARACTER  NO-UNDO INITIAL "smartDialog,smartFolder,smartWindow,window,folder,dyncontainer,dynobjc,staticobjc,dynmenc,staticmenc,staticcont,staticdiag,staticframe,smartcontainer".

/* Inform the DCU of what's happening */
PUBLISH "DCU_WriteLog":U ("Moving security structures from object instance to container level.").

/* Now:
 * - Find security structures set up against instances.
 * - Create the security structure against the container if it doesn't exist.
 * - Move any security allocation against the instance structure to the container structure.
 * - Delete all security allocations against the instance structure. (We created them against the container)
 * - Delete the structure against the instance.
 */
structure-blk:
FOR EACH gsm_security_structure NO-LOCK:

    /* If this is a global security structure, skip it.                         *
     * IOW its been set up for all objects, or all objects in a product module. */
    IF gsm_security_structure.object_obj = 0 THEN
        NEXT structure-blk.

    /* We want to move any security at instance level to container level, so look for *
     * instances. */
    IF CAN-FIND(FIRST ryc_object_instance
                WHERE ryc_object_instance.smartobject_obj = gsm_security_structure.object_obj) 
    THEN DO:
        /* Move security structures to container level. */
        update-blk:
        DO TRANSACTION ON ERROR UNDO update-blk, LEAVE update-blk:

            instance-blk:
            FOR EACH ryc_object_instance NO-LOCK
               WHERE ryc_object_instance.smartobject_obj = gsm_security_structure.object_obj:

                FIND brycso_container NO-LOCK
                     WHERE brycso_container.smartobject_obj = ryc_object_instance.container_smartobject_obj
                     NO-ERROR.

                IF NOT AVAILABLE brycso_container THEN
                    NEXT instance-blk.

                /* First check if we already have a security structure record set up against 
                 * the container.  If we don't, create a new structure record. */
                FIND bgsm_security_structure NO-LOCK
                     WHERE bgsm_security_structure.owning_entity_mnemonic = gsm_security_structure.owning_entity_mnemonic
                       AND bgsm_security_structure.owning_obj             = gsm_security_structure.owning_obj
                       AND bgsm_security_structure.product_module_obj     = brycso_container.product_module_obj
                       AND bgsm_security_structure.object_obj             = brycso_container.smartobject_obj
                       AND bgsm_security_structure.instance_attribute_obj = gsm_security_structure.instance_attribute_obj
                     NO-ERROR.

                IF NOT AVAILABLE bgsm_security_structure
                THEN DO:
                    CREATE bgsm_security_structure.
                    BUFFER-COPY gsm_security_Structure
                         EXCEPT gsm_security_Structure.security_structure_obj
                             TO bgsm_security_structure
                         ASSIGN bgsm_security_structure.product_module_obj = brycso_container.product_module_obj
                                bgsm_security_structure.object_obj         = brycso_container.smartobject_obj
                                NO-ERROR.

                    IF ERROR-STATUS:ERROR 
                    THEN DO:
                        IF NOT lError THEN
                            ASSIGN lError = YES.
                        UNDO update-blk, LEAVE update-blk.
                    END.
                END.

                /* Now move all the user allocations against the instance to the container */
                FOR EACH gsm_user_allocation NO-LOCK
                   WHERE gsm_user_allocation.owning_entity_mnemonic = "GSMSS":U
                     AND gsm_user_allocation.owning_obj             = gsm_security_structure.security_structure_obj:

                    IF NOT CAN-FIND(FIRST bgsm_user_allocation
                                    WHERE bgsm_user_allocation.owning_entity_mnemonic = "GSMSS":U
                                      AND bgsm_user_allocation.owning_obj             = bgsm_security_Structure.security_structure_obj
                                      AND bgsm_user_allocation.user_obj               = gsm_user_allocation.user_obj
                                      AND bgsm_user_allocation.login_organisation_obj = gsm_user_allocation.login_organisation_obj)
                    THEN DO:
                        CREATE bgsm_user_allocation.
                        BUFFER-COPY gsm_user_allocation
                             EXCEPT gsm_user_allocation.user_allocation_obj
                                 TO bgsm_user_allocation
                             ASSIGN bgsm_user_allocation.owning_obj = bgsm_security_Structure.security_structure_obj
                                    NO-ERROR.

                        IF ERROR-STATUS:ERROR 
                        THEN DO:
                            IF NOT lError THEN
                                ASSIGN lError = YES.
                            UNDO update-blk, LEAVE update-blk.
                        END.
                    END.
                END.
            END.

            /* Now that we've moved all the structures and allocations to the container from the instance, *
             * delete the instance structure and allocations. */
            FOR EACH gsm_user_allocation EXCLUSIVE-LOCK
               WHERE gsm_user_allocation.owning_entity_mnemonic = "GSMSS":U
                 AND gsm_user_allocation.owning_obj             = gsm_security_structure.security_structure_obj:

                DELETE gsm_user_allocation NO-ERROR.
                IF ERROR-STATUS:ERROR
                THEN DO:
                    IF NOT lError THEN
                        ASSIGN lError = YES.
                    UNDO update-blk, LEAVE update-blk.
                END.
            END.

            FIND bgsm_security_structure EXCLUSIVE-LOCK
                 WHERE ROWID(bgsm_security_structure) = ROWID(gsm_security_structure).
            DELETE bgsm_security_structure NO-ERROR.
            IF ERROR-STATUS:ERROR
            THEN DO:
                IF NOT lError THEN
                    ASSIGN lError = YES.
                UNDO update-blk, LEAVE update-blk.
            END.
        END.
    END.
    ELSE DO:
        /* If we get here, the object is a container.  If not a container, it's not in use. */
        FIND ryc_smartobject NO-LOCK
             WHERE ryc_smartobject.smartobject_obj = gsm_security_structure.object_obj
             NO-ERROR.

        IF NOT AVAILABLE ryc_smartobject THEN
            NEXT structure-blk.

        ASSIGN dObjectTypeObj = ryc_smartobject.object_type_obj.
        DO WHILE dObjectTypeObj <> 0:

            FIND gsc_object_type NO-LOCK
                 WHERE gsc_object_type.object_type_obj = dObjectTypeObj
                 NO-ERROR.

            IF CAN-DO(cContainerClasses, gsc_object_type.object_type_code) THEN
                NEXT structure-blk.

            ASSIGN dObjectTypeObj = gsc_object_type.extends_object_type_obj.
        END.

        /* The object security is not assigned against a container. *
         * As it is not an instance on a container, it is not in use.  Delete the security *
         * allocation. */
        delete-blk:
        DO TRANSACTION ON ERROR UNDO delete-blk, LEAVE delete-blk:
            FIND bgsm_security_structure EXCLUSIVE-LOCK
                 WHERE ROWID(bgsm_security_structure) = ROWID(gsm_security_structure).
            DELETE bgsm_security_structure NO-ERROR.
            IF ERROR-STATUS:ERROR
            AND NOT lError 
            THEN DO:
                ASSIGN lError = YES.
                UNDO delete-blk, LEAVE delete-blk. 
            END.
        END.
    END.
END.

PUBLISH "DCU_WriteLog":U ("Security structures moved from object instance to container level "
                         + IF lError
                           THEN "unsuccessfully.  Please delete any security structures against container instances and recreate against the container."
                           ELSE "successfully.").
