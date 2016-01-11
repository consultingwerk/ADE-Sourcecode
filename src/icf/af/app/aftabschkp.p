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
  File: aftabschkp.p

  Description:  Table Values Security Check Procedure

  Purpose:      Table Values Security Check Procedure
                Check user security for passed in table field. Pass back a valid
                set of field values the user has access to.
                The procedure is run on the Appserver as an external procedure non
                persistently from the Client Security Manager, and is included as in internal
                procedre in the Server Security Manager.

  Parameters:   Input table FLA to check user security clearance for
                Input field name with no table prefix
                Output comma seperated list of valid values, "" = all

  History:
  --------
  (v:010000)    Task:        5653   UserRef:    
                Date:   01/06/2000  Author:     Anthony Swindells

  Update Notes: Write Astra2 Toolbar

  (v:010001)    Task:        6066   UserRef:    
                Date:   19/06/2000  Author:     Anthony Swindells

  Update Notes: Fix Security Manager.
                Was not checking property values using chr(3)

  (v:010100)    Task:    90000045   UserRef:    POSSE
                Date:   21/04/2001  Author:     Phil Magnay

  Update Notes: Logic changes due to new security allocations method

-------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       aftabschkp.p
&scop object-version    010100


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes


{af/sup2/afglobals.i}     /* Astra global shared variables */

DEFINE INPUT PARAMETER  pcOwningEntityMnemonic          AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER  pcEntityFieldName               AS CHARACTER    NO-UNDO.
DEFINE OUTPUT PARAMETER pcValidValues                   AS CHARACTER    NO-UNDO.

DEFINE VARIABLE         lSecurityRestricted             AS LOGICAL      NO-UNDO.
DEFINE VARIABLE         cSecurityValue1                 AS CHARACTER    NO-UNDO.
DEFINE VARIABLE         cSecurityValue2                 AS CHARACTER    NO-UNDO.

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
         HEIGHT             = 12.1
         WIDTH              = 51.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* If security is disabled or the security object is not passed in then "" is
   returned indicating full access is permitted.
   This routine uses the information maintained in the gsm_entity_field and
   gsm_entity_field_value tables.
   To a large extent this routine is superseded by the generic data security
   facility - see Security Manager Documentation for details.
   The returned valid value list is comma seperated, so if the contents contain
   commas, these will be removed
*/

  ASSIGN
      pcValidValues = "":U.

  FIND FIRST gsc_security_control NO-LOCK NO-ERROR.
  IF AVAILABLE gsc_security_control
      AND gsc_security_control.security_enabled = NO THEN RETURN. /* Security off */

  FIND FIRST gsm_entity_field NO-LOCK
       WHERE gsm_entity_field.owning_entity_mnemonic = pcOwningEntityMnemonic
         AND gsm_entity_field.entity_field_name = pcEntityFieldName
       NO-ERROR.
  IF NOT AVAILABLE gsm_entity_field OR
     NOT CAN-FIND(FIRST gsm_entity_field_value
                  WHERE gsm_entity_field_value.entity_field_obj = gsm_entity_field.entity_field_obj)
     THEN RETURN.

  /* Get current up-to-date user information to be sure */
  DEFINE VARIABLE cUserProperties AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cUserValues     AS CHARACTER NO-UNDO.
  ASSIGN cUserProperties = "currentUserObj,currentOrganisationObj".
  cUserValues = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                     INPUT cUserProperties,
                                                     INPUT NO).

  FOR EACH gsm_entity_field_value NO-LOCK
     WHERE gsm_entity_field_value.entity_field_obj = gsm_entity_field.entity_field_obj:

      RUN userSecurityCheck IN gshSecurityManager (INPUT  DECIMAL(ENTRY(1,cUserValues,CHR(3))),  /* logged in as user */
                                                   INPUT  DECIMAL(ENTRY(2,cUserValues,CHR(3))),  /* logged into organisation */
                                                   INPUT  "gsmev":U,                      /* Entity field value FLA */
                                                   INPUT  gsm_entity_field_value.entity_field_value_obj,
                                                   INPUT  NO,                             /* Return values - NO */
                                                   OUTPUT lSecurityRestricted,            /* Restricted yes/no ? */
                                                   OUTPUT cSecurityValue1,                /* clearance value 1 */
                                                   OUTPUT cSecurityValue2).               /* clearance value 2 */
      IF NOT lSecurityRestricted THEN
        ASSIGN
          pcValidValues = pcValidValues + (IF pcValidValues <> "":U THEN ",":U ELSE "":U) +
                          REPLACE(gsm_entity_field_value.entity_field_contents,",":U," ":U).

  END. /* each entity field value */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


