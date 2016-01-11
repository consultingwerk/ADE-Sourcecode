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
  File: afranschkp.p

  Description:  Range Security Check Procedure

  Purpose:      Range Security Check Procedure
                Check user security for passed in range code
                The procedure is run on the Appserver as an external procedure non
                persistently from the Client Security Manager, and is included as in internal
                procedre in the Server Security Manager.

  Parameters:   input range code to check user security clearance for
                input current program object for security check
                input instance attribute posted to program
                output from value permitted for user, "" = all
                output to value permitted for user, "" = all

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

  Update Notes: Logic changes due to new security allocations method

------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afranschkp.p
&scop object-version    000000


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes


{af/sup2/afglobals.i}     /* Astra global shared variables */

DEFINE INPUT PARAMETER  pcRangeCode                     AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER  pcObjectName                    AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER  pcAttributeCode                 AS CHARACTER    NO-UNDO.
DEFINE OUTPUT PARAMETER pcRangeFrom                     AS CHARACTER    NO-UNDO.
DEFINE OUTPUT PARAMETER pcRangeTo                       AS CHARACTER    NO-UNDO.

DEFINE VARIABLE         dAttributeObj                AS DECIMAL      NO-UNDO.
DEFINE VARIABLE         lSecurityRestricted          AS LOGICAL      NO-UNDO.
DEFINE VARIABLE         cSecurityValue1              AS CHARACTER    NO-UNDO.
DEFINE VARIABLE         cSecurityValue2              AS CHARACTER    NO-UNDO.
DEFINE VARIABLE         lFound                       AS LOGICAL      NO-UNDO.
DEFINE VARIABLE         lFullAccessByDefault         AS LOGICAL      NO-UNDO.
DEFINE VARIABLE         dProductModuleObj            AS DECIMAL      NO-UNDO.
DEFINE VARIABLE         dSecurityObjectObj           AS DECIMAL      NO-UNDO.

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
         HEIGHT             = 12
         WIDTH              = 48.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* If security is disabled or the security object is not passed in then "" is 
   returned for both values indicating full access is permitted.
   For the passed in range, checks are made as to whether any security restrictions
   exist for the user. If restrictions exist, the from and to values are passed
   back.
*/
  ASSIGN
      pcRangeFrom = "":U
      pcRangeTo = "":U
      .

  FIND FIRST gsc_security_control NO-LOCK NO-ERROR.
  IF AVAILABLE gsc_security_control
      AND gsc_security_control.security_enabled = NO THEN RETURN. /* Security off */

  /* Check if security is turned on for the object (the object will have a security object
     specified), and if it is, work out what the security object is (probably itself but can
     be set-up as something else).
  */
  ASSIGN dSecurityObjectObj = 0
         dProductModuleObj = 0.
  DEFINE BUFFER b1ryc_smartobject FOR ryc_smartobject.
  IF CAN-FIND(FIRST b1ryc_smartobject
              WHERE b1ryc_smartobject.object_filename = pcObjectName
                AND b1ryc_smartobject.security_smartobject_obj <> 0) THEN

  DO: /* security is turned on for this object */
    FIND FIRST b1ryc_smartobject NO-LOCK
         WHERE b1ryc_smartobject.object_filename = pcObjectName NO-ERROR.
    IF AVAILABLE b1ryc_smartobject THEN
    DO:
      IF b1ryc_smartobject.smartobject_obj <> b1ryc_smartobject.security_smartobject_obj THEN
        DO:
          DEFINE BUFFER b2ryc_smartobject FOR ryc_smartobject.
          FIND FIRST b2ryc_smartobject NO-LOCK
               WHERE b2ryc_smartobject.smartobject_obj = b1ryc_smartobject.security_smartobject_obj NO-ERROR.
          IF AVAILABLE b2ryc_smartobject THEN
              ASSIGN dSecurityObjectObj = b2ryc_smartobject.smartobject_obj
                     dProductModuleObj = b2ryc_smartobject.product_module_obj.
          ELSE
              ASSIGN dSecurityObjectObj = 0
                     dProductModuleObj = 0.
        END.
      ELSE
        ASSIGN dSecurityObjectObj = b1ryc_smartobject.smartobject_obj
               dProductModuleObj = b1ryc_smartobject.product_module_obj.
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

  ASSIGN lFullAccessByDefault = (IF AVAILABLE gsc_security_control
                                      AND gsc_security_control.full_access_by_default = NO
                                      THEN NO ELSE YES).

  FIND FIRST gsm_range NO-LOCK
       WHERE gsm_range.range_code = pcRangeCode
       NO-ERROR.
  IF NOT AVAILABLE gsm_range THEN RETURN.

  IF gsm_range.disabled = YES OR
     NOT CAN-FIND(FIRST gsm_security_structure
                  WHERE gsm_security_structure.owning_entity_mnemonic = "GSMRA":U
                    AND gsm_security_structure.owning_obj = gsm_range.range_obj
                    AND gsm_security_structure.disabled = NO) THEN
    /* Range is disabled for security checking or not used at all in a structure
       so simply ignore it */
    RETURN.

  /* Get current up-to-date user information to be sure */
  DEFINE VARIABLE cUserProperties AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cUserValues     AS CHARACTER NO-UNDO.
  ASSIGN cUserProperties = "currentUserObj,currentOrganisationObj".
  cUserValues = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                     INPUT cUserProperties,
                                                     INPUT NO).

  /* First check if the user has any range allocations at all. If not, then
     grant full access. This check can not be left to the userSecurityCheck
     because structures are being used and structures can exist for fields,
     tokens, or ranges. What happens therefore is that as soon as any allocations
     are set-up for the user, the routine thinks some allocations exist, even if
     they are not range allocations, and does not pass security correctly.
  */
  ASSIGN lFound = NO.
  ALLOCATION-CHECK:
  FOR EACH gsm_user_allocation NO-LOCK
     WHERE (gsm_user_allocation.user_obj = DECIMAL(ENTRY(1,cUserValues,CHR(3)))
            OR gsm_user_allocation.user_obj = 0)
       AND gsm_user_allocation.owning_entity_mnemonic = "GSMSS":U,
     FIRST gsm_security_structure NO-LOCK
     WHERE gsm_security_structure.security_structure_obj = gsm_user_allocation.owning_obj,
     FIRST gsm_range NO-LOCK
     WHERE gsm_range.range_obj = gsm_security_structure.owning_obj:
      ASSIGN lFound = YES.
      LEAVE ALLOCATION-CHECK.
  END.
  IF lFound = NO AND lFullAccessByDefault THEN RETURN.

  ASSIGN
      lFound = NO
      lSecurityRestricted = NO
      cSecurityValue1 = "":U
      cSecurityValue2 = "":U
      .

  IF NOT lSecurityRestricted THEN    /* Check for specific object instance */
    DO:
        FIND FIRST gsm_security_structure NO-LOCK
             WHERE gsm_security_structure.owning_entity_mnemonic = "GSMRA":U
               AND gsm_security_structure.owning_obj = gsm_range.range_obj
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
                                                         INPUT  YES,                            /* Return security values - YES */
                                                         OUTPUT lSecurityRestricted,            /* Restriction yes/no ? */
                                                         OUTPUT cSecurityValue1,                /* clearance value 1 */
                                                         OUTPUT cSecurityValue2).               /* clearance value 2 */
            ASSIGN lFound = YES.
          END.
    END.

  IF NOT lSecurityRestricted THEN    /* Check for specific object */
    DO:
        FIND FIRST gsm_security_structure NO-LOCK
             WHERE gsm_security_structure.owning_entity_mnemonic = "GSMRA":U
               AND gsm_security_structure.owning_obj = gsm_range.range_obj
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
                                                         INPUT  YES,                            /* Return values - YES */
                                                         OUTPUT lSecurityRestricted,            /* Restriction yes/no ? */
                                                         OUTPUT cSecurityValue1,                /* clearance value 1 */
                                                         OUTPUT cSecurityValue2).               /* clearance value 2 */
            ASSIGN lFound = YES.
          END.
    END.

  IF NOT lSecurityRestricted THEN    /* Check for specific product module */
    DO:
        FIND FIRST gsm_security_structure NO-LOCK
             WHERE gsm_security_structure.owning_entity_mnemonic = "GSMRA":U
               AND gsm_security_structure.owning_obj = gsm_range.range_obj
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
                                                         INPUT  YES,                            /* Return values - YES */
                                                         OUTPUT lSecurityRestricted,            /* Restriction yes/no ? */
                                                         OUTPUT cSecurityValue1,                /* clearance value 1 */
                                                         OUTPUT cSecurityValue2).               /* clearance value 2 */
            ASSIGN lFound = YES.
          END.
    END.

  IF NOT lSecurityRestricted THEN    /* Check for ALL */
    DO:
        FIND FIRST gsm_security_structure NO-LOCK
             WHERE gsm_security_structure.owning_entity_mnemonic = "GSMRA":U
               AND gsm_security_structure.owning_obj = gsm_range.range_obj
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
                                                         INPUT  YES,                            /* Return values - YES */
                                                         OUTPUT lSecurityRestricted,            /* Restriction yes/no ? */
                                                         OUTPUT cSecurityValue1,                /* clearance value 1 */
                                                         OUTPUT cSecurityValue2).               /* clearance value 2 */
            ASSIGN lFound = YES.
          END.
    END.

  /* If security Restriction or no structures exist for this object for this range or
     no allocations are found for the user and full access by default is on then
     pass security clearance for the range
  */
  IF lSecurityRestricted THEN
    ASSIGN
        pcRangeFrom = cSecurityValue1
        pcRangeTo   = cSecurityValue2
        .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


