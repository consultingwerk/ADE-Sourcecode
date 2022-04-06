/*---------------------------------------------------------------------------------
  File: usrSecChck.i

  Description:  userSecurityCheck API in security manager contents

  Purpose:      userSecurityCheck API in security manager contents

  Parameters:

  History:
  --------
  (v:010000)    Task:               UserRef:    
                Date:   14/08/2003  Author:     Neil Bell        

  Update Notes: Created to prevent blowing of section editor limits.  As all code
                has to run inline for performance, splitting code into multiple APIs
                is not an option

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  pdUserObj                   AS DECIMAL      NO-UNDO.
  DEFINE INPUT PARAMETER  pdOrganisationObj           AS DECIMAL      NO-UNDO.
  DEFINE INPUT PARAMETER  pcOwningEntityMnemonic      AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  pdOwningObj                 AS DECIMAL      NO-UNDO.
  DEFINE INPUT PARAMETER  plReturnValues              AS LOGICAL      NO-UNDO.
  DEFINE OUTPUT PARAMETER plSecurityRestricted        AS LOGICAL      NO-UNDO.
  DEFINE OUTPUT PARAMETER pcSecurityValue1            AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcSecurityValue2            AS CHARACTER    NO-UNDO.

  ASSIGN plSecurityRestricted = YES
         pcSecurityValue1 = "":U
         pcSecurityValue2 = "":U.

  /* If client side, check local cache to see if already checked and if so use cached value */
  IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) 
  THEN DO:
      FIND FIRST ttUserSecurityCheck
           WHERE ttUserSecurityCheck.dUserObj              = pdUserObj
             AND ttUserSecurityCheck.dOrganisationObj      = pdOrganisationObj
             AND ttUserSecurityCheck.cOwningEntityMnemonic = pcOwningEntityMnemonic
             AND ttUserSecurityCheck.dOwningObj            = pdOwningObj
           NO-ERROR.
      IF AVAILABLE ttUserSecurityCheck
      THEN DO:
          ASSIGN plSecurityRestricted = NOT ttUserSecurityCheck.lSecurityCleared
                 pcSecurityValue1     = ttUserSecurityCheck.cSecurityValue1
                 pcSecurityValue2     = ttUserSecurityCheck.cSecurityValue2.
          RETURN.
      END.
  END. /* NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) */

  &IF DEFINED(server-side) = 0 &THEN
      RUN af/app/afsecusrsecchkp.p ON gshAstraAppServer
        (INPUT  pdUserObj, 
         INPUT  pdOrganisationObj,
         INPUT  pcOwningEntityMnemonic,
         INPUT  pdOwningObj,
         INPUT  plReturnValues,
         OUTPUT plSecurityRestricted,
         OUTPUT pcSecurityValue1,
         OUTPUT pcSecurityValue2) NO-ERROR.
      IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN
        RETURN ERROR (IF RETURN-VALUE = "" OR RETURN-VALUE = ? AND ERROR-STATUS:NUM-MESSAGES > 0 THEN 
                      ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
      /* Update client cache */
      IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) 
      THEN DO:
          CREATE ttUserSecurityCheck.
          ASSIGN ttUserSecurityCheck.dUserObj              = pdUserObj
                 ttUserSecurityCheck.dOrganisationObj      = pdOrganisationObj
                 ttUserSecurityCheck.cOwningEntityMnemonic = pcOwningEntityMnemonic
                 ttUserSecurityCheck.dOwningObj            = pdOwningObj
                 ttUserSecurityCheck.lSecurityCleared      = NOT plSecurityRestricted
                 ttUserSecurityCheck.cSecurityValue1       = pcSecurityValue1
                 ttUserSecurityCheck.cSecurityValue2       = pcSecurityValue2.
      END.
  &ELSE
      DEFINE VARIABLE cRealEntityMnemonic AS CHARACTER NO-UNDO.
      DEFINE VARIABLE cSecurityProperties AS CHARACTER NO-UNDO.
      DEFINE VARIABLE cSecurityGroups     AS CHARACTER NO-UNDO.
      DEFINE VARIABLE lRevokeModel        AS LOGICAL   NO-UNDO.
      DEFINE VARIABLE lCheckCompany       AS LOGICAL   NO-UNDO.
      DEFINE VARIABLE lCheckAllCompanies  AS LOGICAL   NO-UNDO.
      
      DEFINE VARIABLE iOwningCounter      AS INTEGER   NO-UNDO.
      DEFINE VARIABLE dOwningObj          AS DECIMAL   NO-UNDO.
      DEFINE VARIABLE iSecGroupCounter    AS INTEGER   NO-UNDO.
      DEFINE VARIABLE dSecurityGroupObj   AS DECIMAL   NO-UNDO.
      DEFINE VARIABLE lAllocationFound    AS LOGICAL   NO-UNDO.
      
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
      
      /* Get all the properties we need to check security (they're set up at session startup in setSecurityProperties in the security manager) */
      ASSIGN cSecurityProperties  = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager, 
                                    INPUT "SecurityEnabled,":U + cRealEntityMnemonic + "SecurityExists,SecurityModel,SecurityGroups":U,INPUT YES). /* These properties should be set client side, don't go to the server */
      
      /* If security is disabled, the object is not secured. */
      IF TRIM(REPLACE(cSecurityProperties, CHR(3), "":U)) = "":U /* We'll only ever get this if the login failed for some reason, and we're still stuck there...The message dialog will then run this security check, but seeing as we don't even know who the user is, we'll ignore it. */
      OR TRIM(REPLACE(cSecurityProperties, CHR(3), "":U)) = ?
      OR ENTRY(1, cSecurityProperties, CHR(3)) = "NO":U
      THEN DO:
          ASSIGN plSecurityRestricted = NO.
          RETURN.
      END.

      /* If no security has been set up for the security type specified:         *
       * Revoke model - Access is granted.                                       *
       * Grant model  - Access is revoked and most restrictive security applied. */
      ASSIGN lRevokeModel = ENTRY(3, cSecurityProperties, CHR(3)) = "Revoke":U.
      
      IF ENTRY(2, cSecurityProperties, CHR(3)) = "NO":U /* SecurityExists */
      THEN DO:
          IF lRevokeModel = YES THEN
              ASSIGN plSecurityRestricted = NO.
          ELSE DO:
              ASSIGN plSecurityRestricted = YES.
              /* In a grant model, apply most restrictive security */
              IF plReturnValues = YES AND cRealEntityMnemonic = "GSMFF":U THEN
                  ASSIGN pcSecurityValue1     = ENTRY(NUM-ENTRIES("{&GSMFFRestrictiveLevels}":U),"{&GSMFFRestrictiveLevels}":U)
                         pcSecurityValue2     = "":U.
          END.
          RETURN.
      END.
      
      ASSIGN plSecurityRestricted = NO. /* Initialize to NO */
      
      /* We're going to do 2 loops here to check security allocations.                                                       *
       * Loop 1 only applies to data security, where we need to check if all records on a table have been secured.  For      *
       * these security types, a security allocation will exist with its owning_entity_mnemonic set to the FLA of the table  *
       * and its owning_obj set to 0.                                                                                        *
       * Loop 2 applies to all security types, where we will check security against a specific object (field, menu item etc) */
      owning-obj-loop:
      DO iOwningCounter = (IF CAN-DO("GSMSS,GSMMI,GSMMS,RYCSO":U, pcOwningEntityMnemonic) THEN 2 ELSE 1) TO 2:
      
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
                  FIND gsm_user_allocation NO-LOCK
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
                          ASSIGN plSecurityRestricted = (gsm_user_allocation.user_allocation_value1 <> "NO":U).

                      /* Update client cache */
                      IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) 
                      THEN DO:
                          CREATE ttUserSecurityCheck.
                          ASSIGN ttUserSecurityCheck.dUserObj              = pdUserObj
                                 ttUserSecurityCheck.dOrganisationObj      = pdOrganisationObj
                                 ttUserSecurityCheck.cOwningEntityMnemonic = cRealEntityMnemonic
                                 ttUserSecurityCheck.dOwningObj            = pdOwningObj
                                 ttUserSecurityCheck.lSecurityCleared      = NOT plSecurityRestricted
                                 ttUserSecurityCheck.cSecurityValue1       = pcSecurityValue1
                                 ttUserSecurityCheck.cSecurityValue2       = pcSecurityValue2.
                      END.

                      RETURN.
                  END.
                  ELSE DO:
                      FIND FIRST gsm_user_allocation NO-LOCK
                           WHERE gsm_user_allocation.user_obj               = pdUserObj
                             AND gsm_user_allocation.login_organisation_obj = pdOrganisationObj
                             AND gsm_user_allocation.owning_entity_mnemonic = pcOwningEntityMnemonic
                             AND gsm_user_allocation.owning_obj             = dOwningObj.
          
                      ASSIGN plSecurityRestricted = YES
                             pcSecurityValue1     = gsm_user_allocation.user_allocation_value1
                             pcSecurityValue2     = gsm_user_allocation.user_allocation_value2.

                      IF  cRealEntityMnemonic = "GSMFF":U
                      AND pcSecurityValue1 = ENTRY(1, "{&GSMFFRestrictiveLevels}":U) THEN /* Full Access = not secured */
                           ASSIGN plSecurityRestricted = NO
                                  pcSecurityValue1     = "":U.

                      /* Update client cache */
                      IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) 
                      THEN DO:
                          CREATE ttUserSecurityCheck.
                          ASSIGN ttUserSecurityCheck.dUserObj              = pdUserObj
                                 ttUserSecurityCheck.dOrganisationObj      = pdOrganisationObj
                                 ttUserSecurityCheck.cOwningEntityMnemonic = cRealEntityMnemonic
                                 ttUserSecurityCheck.dOwningObj            = pdOwningObj
                                 ttUserSecurityCheck.lSecurityCleared      = NOT plSecurityRestricted
                                 ttUserSecurityCheck.cSecurityValue1       = pcSecurityValue1
                                 ttUserSecurityCheck.cSecurityValue2       = pcSecurityValue2.
                      END.

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
                          ASSIGN plSecurityRestricted = (gsm_user_allocation.user_allocation_value1 <> "NO":U).

                      /* Update client cache */
                      IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) 
                      THEN DO:
                          CREATE ttUserSecurityCheck.
                          ASSIGN ttUserSecurityCheck.dUserObj              = pdUserObj
                                 ttUserSecurityCheck.dOrganisationObj      = pdOrganisationObj
                                 ttUserSecurityCheck.cOwningEntityMnemonic = cRealEntityMnemonic
                                 ttUserSecurityCheck.dOwningObj            = pdOwningObj
                                 ttUserSecurityCheck.lSecurityCleared      = NOT plSecurityRestricted
                                 ttUserSecurityCheck.cSecurityValue1       = pcSecurityValue1
                                 ttUserSecurityCheck.cSecurityValue2       = pcSecurityValue2.
                      END.

                      RETURN.
                  END.
                  ELSE DO:          
                      ASSIGN plSecurityRestricted = YES
                             pcSecurityValue1     = gsm_user_allocation.user_allocation_value1
                             pcSecurityValue2     = gsm_user_allocation.user_allocation_value2.

                      IF  cRealEntityMnemonic = "GSMFF":U
                      AND pcSecurityValue1 = ENTRY(1, "{&GSMFFRestrictiveLevels}":U) THEN /* Full Access = not secured */
                           ASSIGN plSecurityRestricted = NO
                                  pcSecurityValue1     = "":U.

                      /* Update client cache */
                      IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) 
                      THEN DO:
                          CREATE ttUserSecurityCheck.
                          ASSIGN ttUserSecurityCheck.dUserObj              = pdUserObj
                                 ttUserSecurityCheck.dOrganisationObj      = pdOrganisationObj
                                 ttUserSecurityCheck.cOwningEntityMnemonic = cRealEntityMnemonic
                                 ttUserSecurityCheck.dOwningObj            = pdOwningObj
                                 ttUserSecurityCheck.lSecurityCleared      = NOT plSecurityRestricted
                                 ttUserSecurityCheck.cSecurityValue1       = pcSecurityValue1
                                 ttUserSecurityCheck.cSecurityValue2       = pcSecurityValue2.
                      END.

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
              ASSIGN cSecurityGroups = ENTRY(4, cSecurityProperties, CHR(3)).
      
              IF cSecurityGroups <> "":U
              THEN do-blk: DO iSecGroupCounter = 1 TO NUM-ENTRIES(cSecurityGroups, CHR(4)):
      
                  ASSIGN dSecurityGroupObj = DECIMAL(ENTRY(iSecGroupCounter, cSecurityGroups, CHR(4)))
                         lAllocationFound  = NO.
      
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
                              /* Update client cache */
                              IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) 
                              THEN DO:
                                  CREATE ttUserSecurityCheck.
                                  ASSIGN ttUserSecurityCheck.dUserObj              = pdUserObj
                                         ttUserSecurityCheck.dOrganisationObj      = pdOrganisationObj
                                         ttUserSecurityCheck.cOwningEntityMnemonic = cRealEntityMnemonic
                                         ttUserSecurityCheck.dOwningObj            = pdOwningObj
                                         ttUserSecurityCheck.lSecurityCleared      = NOT plSecurityRestricted
                                         ttUserSecurityCheck.cSecurityValue1       = pcSecurityValue1
                                         ttUserSecurityCheck.cSecurityValue2       = pcSecurityValue2.
                              END.
                              RETURN.
                          END.
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
                                      ASSIGN pcSecurityValue1 = gsm_user_allocation.user_allocation_value1.
      
                                  /* If we've hit least restrictive access, return. */
                                  IF pcSecurityValue1 = ENTRY(1, "{&GSMFFRestrictiveLevels}":U) 
                                  THEN DO: /* Full Access = not secured */
                                      ASSIGN plSecurityRestricted = NO
                                             pcSecurityValue1     = "":U.

                                      /* Update client cache */
                                      IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) 
                                      THEN DO:
                                          CREATE ttUserSecurityCheck.
                                          ASSIGN ttUserSecurityCheck.dUserObj              = pdUserObj
                                                 ttUserSecurityCheck.dOrganisationObj      = pdOrganisationObj
                                                 ttUserSecurityCheck.cOwningEntityMnemonic = cRealEntityMnemonic
                                                 ttUserSecurityCheck.dOwningObj            = pdOwningObj
                                                 ttUserSecurityCheck.lSecurityCleared      = NOT plSecurityRestricted
                                                 ttUserSecurityCheck.cSecurityValue1       = pcSecurityValue1
                                                 ttUserSecurityCheck.cSecurityValue2       = pcSecurityValue2.
                                      END.

                                      RETURN.
                                  END.
                              END.
                              WHEN "GSMRA":U THEN
                                  ASSIGN pcSecurityValue1 = pcSecurityValue1 + gsm_user_allocation.user_allocation_value1 + CHR(3)
                                         pcSecurityValue2 = pcSecurityValue2 + gsm_user_allocation.user_allocation_value2 + CHR(3).
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
                              /* Update client cache */
                              IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) 
                              THEN DO:
                                  CREATE ttUserSecurityCheck.
                                  ASSIGN ttUserSecurityCheck.dUserObj              = pdUserObj
                                         ttUserSecurityCheck.dOrganisationObj      = pdOrganisationObj
                                         ttUserSecurityCheck.cOwningEntityMnemonic = cRealEntityMnemonic
                                         ttUserSecurityCheck.dOwningObj            = pdOwningObj
                                         ttUserSecurityCheck.lSecurityCleared      = NOT plSecurityRestricted
                                         ttUserSecurityCheck.cSecurityValue1       = pcSecurityValue1
                                         ttUserSecurityCheck.cSecurityValue2       = pcSecurityValue2.
                              END.
                              RETURN.
                          END.
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
                                      ASSIGN pcSecurityValue1 = gsm_user_allocation.user_allocation_value1.
                  
                                  IF pcSecurityValue1 = ENTRY(1, "{&GSMFFRestrictiveLevels}":U) 
                                  THEN DO: /* Full Access = not secured */
                                      ASSIGN plSecurityRestricted = NO
                                             pcSecurityValue1     = "":U.

                                      /* Update client cache */
                                      IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) 
                                      THEN DO:
                                          CREATE ttUserSecurityCheck.
                                          ASSIGN ttUserSecurityCheck.dUserObj              = pdUserObj
                                                 ttUserSecurityCheck.dOrganisationObj      = pdOrganisationObj
                                                 ttUserSecurityCheck.cOwningEntityMnemonic = cRealEntityMnemonic
                                                 ttUserSecurityCheck.dOwningObj            = pdOwningObj
                                                 ttUserSecurityCheck.lSecurityCleared      = NOT plSecurityRestricted
                                                 ttUserSecurityCheck.cSecurityValue1       = pcSecurityValue1
                                                 ttUserSecurityCheck.cSecurityValue2       = pcSecurityValue2.
                                      END.

                                      RETURN.
                                  END.
                              END.
                              WHEN "GSMRA":U THEN
                                  ASSIGN pcSecurityValue1 = pcSecurityValue1 + gsm_user_allocation.user_allocation_value1 + CHR(3)
                                         pcSecurityValue2 = pcSecurityValue2 + gsm_user_allocation.user_allocation_value2 + CHR(3).
                          END CASE.
                      END.
                  END.
      
                  /* In a revoke model, the object has to be secured in every security group the user belongs to. If not, the object is not secured. *
                   * in the groups the user belongs to.  Leave the security group check block and check for allocations applicable to all users.     */
                  IF NOT lAllocationFound
                  AND lRevokeModel
                  THEN DO:
                      ASSIGN plSecurityRestricted = NO
                             pcSecurityValue1     = "":U
                             pcSecurityValue2     = "":U.
                      LEAVE do-blk.
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
              IF plSecurityRestricted = YES 
              THEN DO:
                  ASSIGN pcSecurityValue1 = RIGHT-TRIM(pcSecurityValue1, CHR(3))
                         pcSecurityValue2 = RIGHT-TRIM(pcSecurityValue2, CHR(3)).

                  /* Update client cache */
                  IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) 
                  THEN DO:
                      CREATE ttUserSecurityCheck.
                      ASSIGN ttUserSecurityCheck.dUserObj              = pdUserObj
                             ttUserSecurityCheck.dOrganisationObj      = pdOrganisationObj
                             ttUserSecurityCheck.cOwningEntityMnemonic = cRealEntityMnemonic
                             ttUserSecurityCheck.dOwningObj            = pdOwningObj
                             ttUserSecurityCheck.lSecurityCleared      = NOT plSecurityRestricted
                             ttUserSecurityCheck.cSecurityValue1       = pcSecurityValue1
                             ttUserSecurityCheck.cSecurityValue2       = pcSecurityValue2.
                  END.

                  RETURN.
              END.
      
              /* Last, we check for allocations against all users. We only do this if we couldn't find user specific security, *
               * IOW security set up against the user or his groups specifically.                                              */
              IF lCheckCompany
              AND CAN-FIND(FIRST ttGlobalSecurityAllocation
                           WHERE ttGlobalSecurityAllocation.login_organisation_obj = pdOrganisationObj
                             AND ttGlobalSecurityAllocation.owning_entity_mnemonic = pcOwningEntityMnemonic
                             AND ttGlobalSecurityAllocation.owning_obj             = dOwningObj) THEN
                  IF plReturnValues = NO
                  THEN DO:
                      ASSIGN plSecurityRestricted = lRevokeModel. /* Revoke model, plSecurityRestricted = YES. Grant model, plSecurityRestricted = NO */

                      /* Update client cache */
                      IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) 
                      THEN DO:
                          CREATE ttUserSecurityCheck.
                          ASSIGN ttUserSecurityCheck.dUserObj              = pdUserObj
                                 ttUserSecurityCheck.dOrganisationObj      = pdOrganisationObj
                                 ttUserSecurityCheck.cOwningEntityMnemonic = cRealEntityMnemonic
                                 ttUserSecurityCheck.dOwningObj            = pdOwningObj
                                 ttUserSecurityCheck.lSecurityCleared      = NOT plSecurityRestricted
                                 ttUserSecurityCheck.cSecurityValue1       = pcSecurityValue1
                                 ttUserSecurityCheck.cSecurityValue2       = pcSecurityValue2.
                      END.

                      RETURN.
                  END.
                  ELSE DO:
                      FIND FIRST ttGlobalSecurityAllocation
                           WHERE ttGlobalSecurityAllocation.login_organisation_obj = pdOrganisationObj
                             AND ttGlobalSecurityAllocation.owning_entity_mnemonic = pcOwningEntityMnemonic
                             AND ttGlobalSecurityAllocation.owning_obj             = dOwningObj.
              
                      ASSIGN plSecurityRestricted = YES
                             pcSecurityValue1     = ttGlobalSecurityAllocation.user_allocation_value1
                             pcSecurityValue2     = ttGlobalSecurityAllocation.user_allocation_value2.

                      IF  cRealEntityMnemonic = "GSMFF":U
                      AND pcSecurityValue1 = ENTRY(1, "{&GSMFFRestrictiveLevels}":U) THEN /* Full Access = not secured */
                           ASSIGN plSecurityRestricted = NO
                                  pcSecurityValue1     = "":U.

                      /* Update client cache */
                      IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) 
                      THEN DO:
                          CREATE ttUserSecurityCheck.
                          ASSIGN ttUserSecurityCheck.dUserObj              = pdUserObj
                                 ttUserSecurityCheck.dOrganisationObj      = pdOrganisationObj
                                 ttUserSecurityCheck.cOwningEntityMnemonic = cRealEntityMnemonic
                                 ttUserSecurityCheck.dOwningObj            = pdOwningObj
                                 ttUserSecurityCheck.lSecurityCleared      = NOT plSecurityRestricted
                                 ttUserSecurityCheck.cSecurityValue1       = pcSecurityValue1
                                 ttUserSecurityCheck.cSecurityValue2       = pcSecurityValue2.
                      END.
                      RETURN.
                  END.
              
              /* This user, all companies */
              IF lCheckAllCompanies
              AND CAN-FIND(FIRST ttGlobalSecurityAllocation
                           WHERE ttGlobalSecurityAllocation.login_organisation_obj = 0
                             AND ttGlobalSecurityAllocation.owning_entity_mnemonic = pcOwningEntityMnemonic
                             AND ttGlobalSecurityAllocation.owning_obj             = dOwningObj) THEN
                  IF plReturnValues = NO
                  THEN DO:
                      ASSIGN plSecurityRestricted = lRevokeModel. /* Revoke model, plSecurityRestricted = YES. Grant model, plSecurityRestricted = NO */

                      /* Update client cache */
                      IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) 
                      THEN DO:
                          CREATE ttUserSecurityCheck.
                          ASSIGN ttUserSecurityCheck.dUserObj              = pdUserObj
                                 ttUserSecurityCheck.dOrganisationObj      = pdOrganisationObj
                                 ttUserSecurityCheck.cOwningEntityMnemonic = cRealEntityMnemonic
                                 ttUserSecurityCheck.dOwningObj            = pdOwningObj
                                 ttUserSecurityCheck.lSecurityCleared      = NOT plSecurityRestricted
                                 ttUserSecurityCheck.cSecurityValue1       = pcSecurityValue1
                                 ttUserSecurityCheck.cSecurityValue2       = pcSecurityValue2.
                      END.

                      RETURN.
                  END.
                  ELSE DO:
                      FIND FIRST ttGlobalSecurityAllocation
                           WHERE ttGlobalSecurityAllocation.login_organisation_obj = 0
                             AND ttGlobalSecurityAllocation.owning_entity_mnemonic = pcOwningEntityMnemonic
                             AND ttGlobalSecurityAllocation.owning_obj             = dOwningObj.
          
                      ASSIGN plSecurityRestricted = YES
                             pcSecurityValue1     = ttGlobalSecurityAllocation.user_allocation_value1
                             pcSecurityValue2     = ttGlobalSecurityAllocation.user_allocation_value2.

                      IF  cRealEntityMnemonic = "GSMFF":U
                      AND pcSecurityValue1 = ENTRY(1, "{&GSMFFRestrictiveLevels}":U) THEN /* Full Access = not secured */
                           ASSIGN plSecurityRestricted = NO
                                  pcSecurityValue1     = "":U.

                      /* Update client cache */
                      IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) 
                      THEN DO:
                          CREATE ttUserSecurityCheck.
                          ASSIGN ttUserSecurityCheck.dUserObj              = pdUserObj
                                 ttUserSecurityCheck.dOrganisationObj      = pdOrganisationObj
                                 ttUserSecurityCheck.cOwningEntityMnemonic = cRealEntityMnemonic
                                 ttUserSecurityCheck.dOwningObj            = pdOwningObj
                                 ttUserSecurityCheck.lSecurityCleared      = NOT plSecurityRestricted
                                 ttUserSecurityCheck.cSecurityValue1       = pcSecurityValue1
                                 ttUserSecurityCheck.cSecurityValue2       = pcSecurityValue2.
                      END.

                      RETURN.
                  END.
          END.
      END.

      /* If we get here, we couldn't find security applicable to all (owning obj = 0) or to the specific object (owning obj = pdOwningObj) *
       * In a grant model, this means we couldn't find anywhere where security was granted.  In a revoke model, we couldn't find anywhere  *
       * where security was revoked.  This is why we assign plSecurityRestricted to NOT lRevokeModel.                                      */
      ASSIGN plSecurityRestricted = NOT lRevokeModel.
      
      /* In a grant model, apply most restrictive security.  In a revoke model, the object is not secured. */
      IF plReturnValues = YES AND NOT lRevokeModel AND cRealEntityMnemonic = "GSMFF":U THEN
          ASSIGN pcSecurityValue1     = ENTRY(NUM-ENTRIES("{&GSMFFRestrictiveLevels}":U),"{&GSMFFRestrictiveLevels}":U)
                 pcSecurityValue2     = "":U.

      /* Update client cache */
      IF NOT (SESSION:REMOTE OR SESSION:CLIENT-TYPE = "WEBSPEED":U) 
      THEN DO:
          CREATE ttUserSecurityCheck.
          ASSIGN ttUserSecurityCheck.dUserObj              = pdUserObj
                 ttUserSecurityCheck.dOrganisationObj      = pdOrganisationObj
                 ttUserSecurityCheck.cOwningEntityMnemonic = cRealEntityMnemonic
                 ttUserSecurityCheck.dOwningObj            = pdOwningObj
                 ttUserSecurityCheck.lSecurityCleared      = NOT plSecurityRestricted
                 ttUserSecurityCheck.cSecurityValue1       = pcSecurityValue1
                 ttUserSecurityCheck.cSecurityValue2       = pcSecurityValue2.
      END.
  &ENDIF

  RETURN.
