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
  File: aftokschkp.p

  Description:  Token Security Check Procedure

  Purpose:      Token Security Check Procedure
                Check user security for tokens permitted access to
                The procedure is run on the Appserver as an external procedure non
                persistently from the Client Security Manager, and is included as in internal
                procedre in the Server Security Manager.

  Parameters:   input current program name for security check (no path)
                input Instance attribute posted to program
                output security options as comma delimited list of security tokens
                user does not have security clearance for, currently used in toolbar
                panel views to disable buttons and folder windows to disable
                folder pages, etc.

  History:
  --------
  (v:010000)    Task:        5653   UserRef:    
                Date:   01/06/2000  Author:     Anthony Swindells

  Update Notes: Write Astra2 Toolbar

  (v:010001)    Task:        6066   UserRef:    
                Date:   19/06/2000  Author:     Anthony Swindells

  Update Notes: Fix Security Manager.
                Was not checking property values using chr(3)

  (v:010002)    Task:        6067   UserRef:    
                Date:   19/06/2000  Author:     Anthony Swindells

  Update Notes: Security Mods. Get product module rather than pass in product module.

  (v:010100)    Task:    90000045   UserRef:    POSSE
                Date:   21/04/2001  Author:     Phil Magnay

  Update Notes: Logic changes due to new security allocations

  (v:010200)    Task:    90000156   UserRef:    
                Date:   26/05/2001  Author:     Phil Magnay

  Update Notes: test

-----------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       aftokschkp.p
&scop object-version    010200


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes


{af/sup2/afglobals.i}     /* Astra global shared variables */

DEFINE INPUT PARAMETER  pcObjectName                      AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER  pcAttributeCode                   AS CHARACTER    NO-UNDO.
DEFINE OUTPUT PARAMETER pcSecurityOptions                 AS CHARACTER    NO-UNDO.

DEFINE VARIABLE         dAttributeObj                     AS DECIMAL      NO-UNDO.
DEFINE VARIABLE         lSecurityRestricted               AS LOGICAL      NO-UNDO.
DEFINE VARIABLE         cSecurityValue1                   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE         cSecurityValue2                   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE         lFullAccessByDefault              AS LOGICAL      NO-UNDO.
DEFINE VARIABLE         dProductModuleObj                 AS DECIMAL      NO-UNDO.
DEFINE VARIABLE         dSecurityObjectObj                AS DECIMAL      NO-UNDO.

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
         HEIGHT             = 11.91
         WIDTH              = 48.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* If security is disabled or the security object is not passed in then "" is
   returned indicating full access is permitted.
   The routine loops around the available tokens. If a token is disabled or no
   security structure exists for it, i.e. it is not used, then it is assumed
   that the user is simply ignored - indicating full access to the token.
   For each token that is enabled and used, checks are made to see whether the
   user has restricted access to the token, and if so, whether the token is
   disabled for the user.
   Only restricted (user disabled) tokens are returned in the list.
*/

  ASSIGN pcSecurityOptions = "":U.

  FIND FIRST gsc_security_control NO-LOCK NO-ERROR.
  IF AVAILABLE gsc_security_control
      AND gsc_security_control.security_enabled = NO THEN RETURN. /* Security off */

  /* Check if security is turned on for the object (the object will have a security object
     specified), and if it is, work out what the security object is (probably itself but can
     be set-up as something else).
  */
  ASSIGN dSecurityObjectObj = 0
         dProductModuleObj = 0.
  DEFINE BUFFER b1gsc_object FOR gsc_object.
  IF CAN-FIND(FIRST b1gsc_object
              WHERE b1gsc_object.object_filename = pcObjectName
                AND b1gsc_object.security_object_obj <> 0) THEN

  DO: /* security is turned on for this object */
    FIND FIRST b1gsc_object NO-LOCK
         WHERE b1gsc_object.object_filename = pcObjectName NO-ERROR.
    IF AVAILABLE b1gsc_object THEN
    DO:
      IF b1gsc_object.object_obj <> b1gsc_object.security_object_obj THEN
        DO:
          DEFINE BUFFER b2gsc_object FOR gsc_object.
          FIND FIRST b2gsc_object NO-LOCK
               WHERE b2gsc_object.object_obj = b1gsc_object.security_object_obj NO-ERROR.
          IF AVAILABLE b2gsc_object THEN
              ASSIGN dSecurityObjectObj = b2gsc_object.object_obj
                     dProductModuleObj = b2gsc_object.product_module_obj.
          ELSE
              ASSIGN dSecurityObjectObj = 0
                     dProductModuleObj = 0.
        END.
      ELSE
        ASSIGN dSecurityObjectObj = b1gsc_object.object_obj
               dProductModuleObj = b1gsc_object.product_module_obj.
    END.
    ELSE
      ASSIGN dSecurityObjectObj = 0
             dProductModuleObj = 0.
  END.

  IF dSecurityObjectObj = 0 THEN RETURN.       /* Security off for the object */

  FIND FIRST gsc_instance_attribute NO-LOCK
       WHERE gsc_instance_attribute.attribute_code = pcAttributeCode
       NO-ERROR.
  IF AVAILABLE gsc_instance_attribute THEN
      ASSIGN dAttributeObj = gsc_instance_attribute.instance_attribute_obj.
  ELSE
      ASSIGN dAttributeObj = 0.

  /* Get current up-to-date user information to be sure */
  DEFINE VARIABLE cUserProperties AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cUserValues     AS CHARACTER NO-UNDO.
  ASSIGN cUserProperties = "currentUserObj,currentOrganisationObj".
  cUserValues = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                     INPUT cUserProperties,
                                                     INPUT NO).

  /* Check which tokens user does not have security clearance for. In the case of token security, no
     attributes are passed back, but we must still check for specific object instance details first
     as this will override generic settings.
  */
  ASSIGN pcSecurityOptions = "":U.

  TOKEN-LOOP:
  FOR EACH gsm_token NO-LOCK:
    IF gsm_token.disabled = YES OR
       NOT CAN-FIND(FIRST gsm_security_structure
                    WHERE gsm_security_structure.owning_entity_mnemonic = "GSMTO":U
                      AND gsm_security_structure.owning_obj = gsm_token.token_obj
                      AND gsm_security_structure.disabled = NO) THEN
      DO: /* Token is disabled for security checking or not used at all in a structure
             so by default simply ignore it */
          NEXT TOKEN-LOOP.
      END.

    ASSIGN
      lSecurityRestricted = NO
      cSecurityValue1 = "":U
      cSecurityValue2 = "":U
      .

    IF NOT lSecurityRestricted THEN    /* Check for specific object instance */
      DO:
          FIND FIRST gsm_security_structure NO-LOCK
               WHERE gsm_security_structure.owning_entity_mnemonic = "GSMTO":U
                 AND gsm_security_structure.owning_obj = gsm_token.token_obj
                 AND gsm_security_structure.product_module_obj = dProductModuleObj
                 AND gsm_security_structure.object_obj = dSecurityObjectObj
                 AND gsm_security_structure.instance_attribute_obj = dAttributeObj
                 AND gsm_security_structure.disabled = NO
               NO-ERROR.  
          IF AVAILABLE gsm_security_structure THEN
            DO:
              RUN userSecurityCheck IN gshSecurityManager (INPUT  DECIMAL(ENTRY(1,cUserValues,CHR(3))),  /* logged in as user */
                                                           INPUT  DECIMAL(ENTRY(2,cUserValues,CHR(3))),  /* logged into organisation */
                                                           INPUT  "gsmss":U,                      /* Security Structure FLA */
                                                           INPUT  gsm_security_structure.security_structure_obj,
                                                           INPUT  NO,                             /* Return values - NO */
                                                           OUTPUT lSecurityRestricted,            /* Restricted yes/no ? */
                                                           OUTPUT cSecurityValue1,                /* clearance value 1 */
                                                           OUTPUT cSecurityValue2).               /* clearance value 2 */
            END.
      END.

    IF NOT lSecurityRestricted THEN    /* Check for specific object */
      DO:
          FIND FIRST gsm_security_structure NO-LOCK
               WHERE gsm_security_structure.owning_entity_mnemonic = "GSMTO":U
                 AND gsm_security_structure.owning_obj = gsm_token.token_obj
                 AND gsm_security_structure.product_module_obj = dProductModuleObj
                 AND gsm_security_structure.object_obj = dSecurityObjectObj
                 AND gsm_security_structure.instance_attribute_obj = 0
                 AND gsm_security_structure.disabled = NO
               NO-ERROR.  
          IF AVAILABLE gsm_security_structure THEN
            DO:
              RUN userSecurityCheck IN gshSecurityManager (INPUT  DECIMAL(ENTRY(1,cUserValues,CHR(3))),  /* logged in as user */
                                                           INPUT  DECIMAL(ENTRY(2,cUserValues,CHR(3))),  /* logged into organisation */
                                                           INPUT  "gsmss":U,                      /* Security Structure FLA */
                                                           INPUT  gsm_security_structure.security_structure_obj,
                                                           INPUT  NO,                             /* Return values - NO */
                                                           OUTPUT lSecurityRestricted,            /* Restricted yes/no ? */
                                                           OUTPUT cSecurityValue1,                /* clearance value 1 */
                                                           OUTPUT cSecurityValue2).               /* clearance value 2 */
            END.
      END.

    IF NOT lSecurityRestricted THEN    /* Check for specific product module */
      DO:
          FIND FIRST gsm_security_structure NO-LOCK
               WHERE gsm_security_structure.owning_entity_mnemonic = "GSMTO":U
                 AND gsm_security_structure.owning_obj = gsm_token.token_obj
                 AND gsm_security_structure.product_module_obj = dProductModuleObj
                 AND gsm_security_structure.object_obj = 0
                 AND gsm_security_structure.instance_attribute_obj = 0
                 AND gsm_security_structure.disabled = NO
               NO-ERROR.  
          IF AVAILABLE gsm_security_structure THEN
            DO:
              RUN userSecurityCheck IN gshSecurityManager (INPUT  DECIMAL(ENTRY(1,cUserValues,CHR(3))),  /* logged in as user */
                                                           INPUT  DECIMAL(ENTRY(2,cUserValues,CHR(3))),  /* logged into organisation */
                                                           INPUT  "gsmss":U,                      /* Security Structure FLA */
                                                           INPUT  gsm_security_structure.security_structure_obj,
                                                           INPUT  NO,                             /* Return values - NO */
                                                           OUTPUT lSecurityRestricted,               /* Restricted yes/no ? */
                                                           OUTPUT cSecurityValue1,                /* clearance value 1 */
                                                           OUTPUT cSecurityValue2).               /* clearance value 2 */
            END.
      END.

    IF NOT lSecurityRestricted THEN    /* Check for ALL */
      DO:
          FIND FIRST gsm_security_structure NO-LOCK
               WHERE gsm_security_structure.owning_entity_mnemonic = "GSMTO":U
                 AND gsm_security_structure.owning_obj = gsm_token.token_obj
                 AND gsm_security_structure.product_module_obj = 0
                 AND gsm_security_structure.object_obj = 0
                 AND gsm_security_structure.instance_attribute_obj = 0
                 AND gsm_security_structure.disabled = NO
               NO-ERROR.  
          IF AVAILABLE gsm_security_structure THEN
            DO:
              RUN userSecurityCheck IN gshSecurityManager (INPUT  DECIMAL(ENTRY(1,cUserValues,CHR(3))),  /* logged in as user */
                                                           INPUT  DECIMAL(ENTRY(2,cUserValues,CHR(3))),  /* logged into organisation */
                                                           INPUT  "gsmss":U,                      /* Security Structure FLA */
                                                           INPUT  gsm_security_structure.security_structure_obj,
                                                           INPUT  NO,                             /* Return values - NO */
                                                           OUTPUT lSecurityRestricted,            /* Restricted yes/no ? */
                                                           OUTPUT cSecurityValue1,                /* clearance value 1 */
                                                           OUTPUT cSecurityValue2).               /* clearance value 2 */
            END.
      END.

    /* Only add token to list of disabled tokens if it is specifically secured and set to
       NO for disabled */
    IF lSecurityRestricted THEN
      ASSIGN
          pcSecurityOptions = pcSecurityOptions +
                                (IF pcSecurityOptions <> "":U THEN ",":U ELSE "":U) +
                                gsm_token.token_code.


  END.    /* token-loop */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


