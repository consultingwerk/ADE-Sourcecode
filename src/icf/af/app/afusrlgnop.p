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
  File: afusrlgnop.p

  Description:  User Login Organisations

  Purpose:      Compiles a list of user organisations that a given user has access to

  Parameters:

  History:
  --------
  (v:010000)    Task:    90000002   UserRef:    Astra
                Date:   29/03/2001  Author:     Anthony Swindells

  Update Notes: Initial load of Astra code into ICF

  (v:010100)    Task:    90000045   UserRef:    POSSE
                Date:   21/04/2001  Author:     Phil Magnay

  Update Notes: Security Manager Logic

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afusrlgnop.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010100


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

{af/sup2/afglobals.i}     /* Astra global shared variables */

DEFINE INPUT PARAMETER  pdUserObj                   AS DECIMAL      NO-UNDO.
DEFINE OUTPUT PARAMETER pcOrganisations             AS CHARACTER    NO-UNDO.

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
         HEIGHT             = 6.38
         WIDTH              = 44.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

    DEFINE BUFFER bgsm_user_allocation                  FOR gsm_user_allocation.
    DEFINE BUFFER bgsm_login_company                    FOR gsm_login_company.

    /* if there are NO specific login companies to which this user is denied access, list all the login companies*/
    IF NOT CAN-FIND(FIRST bgsm_user_allocation
                WHERE bgsm_user_allocation.USER_obj = pdUserObj
                AND   bgsm_user_allocation.login_organisation_obj = 0
                AND   bgsm_user_allocation.owning_entity_mnemonic = 'GSMLG':U) THEN
    DO:
      FOR EACH bgsm_login_company NO-LOCK:
        ASSIGN pcOrganisations = pcOrganisations + bgsm_login_company.login_company_name + " (" + bgsm_login_company.login_company_short_name + ")," + string(bgsm_login_company.login_company_obj) + ",".
      END.
    END.
    /* if there ARE specific login companies to which this user has restricted access, list only those login companies they have access to */
    ELSE
    DO:
      FOR EACH bgsm_login_company NO-LOCK:
        IF NOT CAN-FIND(FIRST bgsm_user_allocation
                        WHERE bgsm_user_allocation.USER_obj = pdUserObj
                          AND bgsm_user_allocation.login_organisation_obj = 0
                          AND bgsm_user_allocation.owning_entity_mnemonic = 'GSMLG':U
                          AND bgsm_user_allocation.owning_obj = bgsm_login_company.login_company_obj) THEN
        ASSIGN pcOrganisations = pcOrganisations + bgsm_login_company.login_company_name + " (" + bgsm_login_company.login_company_short_name + ")," + string(bgsm_login_company.login_company_obj) + ",".
      END.
    END.

    ERROR-STATUS:ERROR = NO.
    RETURN.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


