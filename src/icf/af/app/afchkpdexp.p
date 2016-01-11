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
  File: afchkpdexp.p

  Description:  CheckUser Profile data exists

  Purpose:      CheckUser Profile data exists
                Procedure to check whether profile data exists for the current
                logged in user for the specified profile type / code / key.
                This procedure supports the passing of partial information, e.g.
                only the profile type, the type and code, etc.
                If the permanent data only flag is set to NO, then if any database
                entries exist for the session only, this will also return TRUE.

  Parameters:   input profile type code
                input profile code
                input profile data key
                input check permanent data only flag YES/NO, default = YES
                output exists flag YES/NO

  History:
  --------
  (v:010000)    Task:        5933   UserRef:    
                Date:   06/06/2000  Author:     Anthony Swindells

  Update Notes: Created from Template aftemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afchkpdexp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010000


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

{af/sup2/afglobals.i}     /* Astra global shared variables */

DEFINE INPUT PARAMETER  pcProfileTypeCode             AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcProfileCode                 AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  pcProfileDataKey              AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  plCheckPermanentOnly          AS LOGICAL    NO-UNDO.
DEFINE OUTPUT PARAMETER plExists                      AS LOGICAL    NO-UNDO.

ASSIGN plExists = NO.

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

  DEFINE VARIABLE cUserObj                  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dUserObj                  AS DECIMAL INITIAL 0 NO-UNDO.

  ASSIGN plExists = NO.

  cUserObj = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                     INPUT "currentUserObj":U,
                                                     INPUT NO).
  ASSIGN dUserObj = DECIMAL(cUserObj) NO-ERROR.

  IF dUserObj > 0 THEN
  findloop:
  FOR EACH gsc_profile_type NO-LOCK
     WHERE gsc_profile_type.profile_type_code BEGINS pcProfileTypeCode,
      EACH gsc_profile_code NO-LOCK
     WHERE gsc_profile_code.profile_type_obj = gsc_profile_type.profile_type_obj
       AND gsc_profile_code.profile_code BEGINS pcProfileCode,
      EACH gsm_profile_data NO-LOCK
     WHERE gsm_profile_data.USER_obj = dUserObj
       AND gsm_profile_data.profile_type_obj = gsc_profile_type.profile_type_obj
       AND gsm_profile_data.profile_code_obj = gsc_profile_code.profile_code_obj
       AND gsm_profile_data.profile_data_key BEGINS pcProfileDataKey:

    IF plCheckPermanentOnly AND gsm_profile_data.CONTEXT_id <> "":U THEN NEXT findloop.

    /* found one so leave */  
    ASSIGN plExists = YES.
    LEAVE findloop.
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


