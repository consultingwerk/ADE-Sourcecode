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
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: afusrschkp.p

  Description:  User Security Check Procedure

  Purpose:      User Security Check Procedure.
                This procedure checks user security clearance for the passed in details.It
                accesses the database directly.
                The procedure is run on the Appserver as an external procedure non
                persistently from the Client Security Manager, and is included as in internal
                procedre in the Server Security Manager.

  Parameters:   input the user being checked
                input the company the user is logged into
                input the security table being checked
                input the security table object being checked
                output YES if security restricted
                output any specific security data
                output any specific security data

  History:
  --------
  (v:010000)    Task:        5653   UserRef:    
                Date:   01/06/2000  Author:     Anthony Swindells

  Update Notes: Write Astra2 Toolbar

  (v:010100)    Task:    90000045   UserRef:    POSSE
                Date:   21/04/2001  Author:     Phil Magnay

  Update Notes: Security allocation changes

--------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afusrschkp.p
&scop object-version    000000


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

  DEFINE INPUT PARAMETER  pdUserObj                   AS DECIMAL      NO-UNDO.
  DEFINE INPUT PARAMETER  pdOrganisationObj           AS DECIMAL      NO-UNDO.
  DEFINE INPUT PARAMETER  pcOwiningEntityMnemonic     AS CHARACTER    NO-UNDO.
  DEFINE INPUT PARAMETER  pdOwiningObj                AS DECIMAL      NO-UNDO.
  DEFINE INPUT PARAMETER  plReturnValues              AS LOGICAL      NO-UNDO.

  DEFINE OUTPUT PARAMETER plSecurityRestricted        AS LOGICAL      NO-UNDO.
  DEFINE OUTPUT PARAMETER pcSecurityValue1            AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT PARAMETER pcSecurityValue2            AS CHARACTER    NO-UNDO.

{af/sup2/afglobals.i}     /* Astra global shared variables */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



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
         HEIGHT             = 13.81
         WIDTH              = 47.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/*  0) If security is disabled, then just pass back that security is cleared */
FIND FIRST gsc_security_control NO-LOCK NO-ERROR.

IF NOT AVAILABLE gsc_security_control
OR gsc_security_control.security_enabled = NO
THEN DO:
    ASSIGN plSecurityRestricted = NO.
    RETURN.
END.

ASSIGN plSecurityRestricted = YES.

/* 1) If any record is found with an owning_obj of 0, this means that security is restricted but no values are to be returned */
IF CAN-FIND(FIRST gsm_user_allocation
            WHERE gsm_user_allocation.owning_entity_mnemonic = pcOwiningEntityMnemonic
              AND gsm_user_allocation.owning_obj             = 0)
THEN DO:
    /* All users, all companies */
    IF CAN-FIND(FIRST gsm_user_allocation
                WHERE gsm_user_allocation.user_obj               = 0
                  AND gsm_user_allocation.login_organisation_obj = 0
                  AND gsm_user_allocation.owning_entity_mnemonic = pcOwiningEntityMnemonic
                  AND gsm_user_allocation.owning_obj             = 0)
    THEN RETURN.
    
    /* This user, all companies */
    IF CAN-FIND(FIRST gsm_user_allocation
                WHERE gsm_user_allocation.user_obj               = pdUserObj
                  AND gsm_user_allocation.login_organisation_obj = 0
                  AND gsm_user_allocation.owning_entity_mnemonic = pcOwiningEntityMnemonic
                  AND gsm_user_allocation.owning_obj             = 0)
    THEN RETURN.
    
    /* All users, this company */
    IF CAN-FIND(FIRST gsm_user_allocation
                WHERE gsm_user_allocation.user_obj               = 0
                  AND gsm_user_allocation.login_organisation_obj = pdOrganisationObj
                  AND gsm_user_allocation.owning_entity_mnemonic = pcOwiningEntityMnemonic
                  AND gsm_user_allocation.owning_obj             = 0)
    THEN RETURN.
    
    /* This user, this company */
    IF CAN-FIND(FIRST gsm_user_allocation
                WHERE gsm_user_allocation.user_obj               = pdUserObj
                  AND gsm_user_allocation.login_organisation_obj = pdOrganisationObj
                  AND gsm_user_allocation.owning_entity_mnemonic = pcOwiningEntityMnemonic
                  AND gsm_user_allocation.owning_obj             = 0)
    THEN RETURN.
END.

/*  If a record is found with an owning_obj = pdOwiningObj, this means that security is restricted and values may be returned. */
IF CAN-FIND(FIRST gsm_user_allocation
            WHERE gsm_user_allocation.owning_entity_mnemonic = pcOwiningEntityMnemonic
              AND gsm_user_allocation.owning_obj             = pdOwiningObj) 
THEN DO:
    /* All users, all companies */
    IF CAN-FIND(FIRST gsm_user_allocation
                WHERE gsm_user_allocation.user_obj               = 0
                  AND gsm_user_allocation.login_organisation_obj = 0
                  AND gsm_user_allocation.owning_entity_mnemonic = pcOwiningEntityMnemonic
                  AND gsm_user_allocation.owning_obj             = pdOwiningObj) 
    THEN DO:
        IF plReturnValues THEN
        DO:
            FIND FIRST gsm_user_allocation NO-LOCK
                 WHERE gsm_user_allocation.user_obj               = 0
                   AND gsm_user_allocation.login_organisation_obj = 0
                   AND gsm_user_allocation.owning_entity_mnemonic = pcOwiningEntityMnemonic
                   AND gsm_user_allocation.owning_obj             = pdOwiningObj
                   NO-ERROR.

            ASSIGN pcSecurityValue1     = gsm_user_allocation.user_allocation_value1
                   pcSecurityValue2     = gsm_user_allocation.user_allocation_value2.
        END.
        RETURN.
    END.

    /* This user, all companies */
    IF CAN-FIND(FIRST gsm_user_allocation
                WHERE gsm_user_allocation.user_obj               = pdUserObj
                  AND gsm_user_allocation.login_organisation_obj = 0
                  AND gsm_user_allocation.owning_entity_mnemonic = pcOwiningEntityMnemonic
                  AND gsm_user_allocation.owning_obj             = pdOwiningObj) 
    THEN DO:   
        IF plReturnValues THEN
        DO:    
            FIND FIRST gsm_user_allocation NO-LOCK
                 WHERE gsm_user_allocation.user_obj               = pdUserObj
                   AND gsm_user_allocation.login_organisation_obj = 0
                   AND gsm_user_allocation.owning_entity_mnemonic = pcOwiningEntityMnemonic
                   AND gsm_user_allocation.owning_obj             = pdOwiningObj
                   NO-ERROR.

            ASSIGN pcSecurityValue1     = gsm_user_allocation.user_allocation_value1
                   pcSecurityValue2     = gsm_user_allocation.user_allocation_value2.
        END.
        RETURN.
    END.

    /* All users, this company */
    IF CAN-FIND(FIRST gsm_user_allocation
                WHERE gsm_user_allocation.user_obj               = 0
                  AND gsm_user_allocation.login_organisation_obj = pdOrganisationObj
                  AND gsm_user_allocation.owning_entity_mnemonic = pcOwiningEntityMnemonic
                  AND gsm_user_allocation.owning_obj             = pdOwiningObj)
    THEN DO:
        IF plReturnValues THEN
        DO:
            FIND FIRST gsm_user_allocation NO-LOCK
                 WHERE gsm_user_allocation.user_obj               = 0
                   AND gsm_user_allocation.login_organisation_obj = pdOrganisationObj
                   AND gsm_user_allocation.owning_entity_mnemonic = pcOwiningEntityMnemonic
                   AND gsm_user_allocation.owning_obj             = pdOwiningObj
                   NO-ERROR.

            ASSIGN pcSecurityValue1     = gsm_user_allocation.user_allocation_value1
                   pcSecurityValue2     = gsm_user_allocation.user_allocation_value2.
        END.
        RETURN.
    END.

    /* This user, this company */
    IF CAN-FIND(FIRST gsm_user_allocation
                WHERE gsm_user_allocation.user_obj               = pdUserObj
                  AND gsm_user_allocation.login_organisation_obj = pdOrganisationObj
                  AND gsm_user_allocation.owning_entity_mnemonic = pcOwiningEntityMnemonic
                  AND gsm_user_allocation.owning_obj             = pdOwiningObj) 
    THEN DO:
        IF plReturnValues THEN
        DO:
           FIND FIRST gsm_user_allocation NO-LOCK
                WHERE gsm_user_allocation.user_obj               = pdUserObj
                  AND gsm_user_allocation.login_organisation_obj = pdOrganisationObj
                  AND gsm_user_allocation.owning_entity_mnemonic = pcOwiningEntityMnemonic
                  AND gsm_user_allocation.owning_obj             = pdOwiningObj
                NO-ERROR.
           ASSIGN pcSecurityValue1     = gsm_user_allocation.user_allocation_value1
                  pcSecurityValue2     = gsm_user_allocation.user_allocation_value2.
        END.
        RETURN.
    END.
END.

/* If we get here, we couldn't find security applicable to all (owning obj = 0) or to the specific object (owning obj = pdOwiningObj) */
ASSIGN plSecurityRestricted = NO
       pcSecurityValue1     = "":U
       pcSecurityValue1     = "":U.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


