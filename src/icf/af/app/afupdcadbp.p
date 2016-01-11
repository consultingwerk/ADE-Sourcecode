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
  File: afupdcadbp.p

  Description:  update changes in client cache to databa

  Purpose:      This procedure will update the modified details from the client
                cache temp-table into the database, and reset the action flag
                on the updated temp-tables to NON to ensure they are not
                updated again.
                Run from updateCachetoDb in Profile Manager.

  Parameters:   Input comma delimited list of profile type codes to update
                input-output cache temp-table

  History:
  --------
  (v:010000)    Task:        5933   UserRef:    
                Date:   12/06/2000  Author:     Anthony Swindells

  Update Notes: Created from Template aftemprocp.p

  (v:010001)    Task:        6030   UserRef:    
                Date:   19/06/2000  Author:     Robin Roos

  Update Notes: Activate object controller actions appropriately

  (v:010003)    Task:        6145   UserRef:    
                Date:   25/06/2000  Author:     Anthony Swindells

  Update Notes: locking issues

-------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afupdcadbp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010003


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

{af/sup2/afglobals.i}     /* Astra global shared variables */

{af/app/afttprofiledata.i}

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


DEFINE INPUT PARAMETER  pcProfileTypeCodes            AS CHARACTER  NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttProfileData.

DEFINE BUFFER bgsm_profile_data FOR gsm_profile_data.

trn-block:
DO FOR bgsm_profile_data TRANSACTION ON ERROR UNDO trn-block, LEAVE trn-block:


  profiletypeloop:
  FOR EACH ttProfileData
     WHERE ttProfileData.cAction <> "NON":U
       AND ttProfileData.CONTEXT_id = "":U:


    IF pcProfileTypeCodes <> "":U AND
       LOOKUP(ttProfileData.cProfileTypeCode, pcProfileTypeCodes) = 0 THEN
      NEXT profiletypeloop.

    FIND FIRST bgsm_profile_data EXCLUSIVE-LOCK
         WHERE bgsm_profile_data.user_obj = ttProfileData.user_obj
           AND bgsm_profile_data.profile_type_obj = ttProfileData.profile_type_obj
           AND bgsm_profile_data.profile_code_obj = ttProfileData.profile_code_obj
           AND bgsm_profile_data.profile_data_key = ttProfileData.profile_data_key
           AND bgsm_profile_data.context_id = ttProfileData.context_id
         NO-ERROR.
    IF NOT AVAILABLE bgsm_profile_data AND ttProfileData.cAction <> "DEL":U THEN
    DO:
      CREATE bgsm_profile_data NO-ERROR.
      IF ERROR-STATUS:ERROR THEN UNDO trn-block, LEAVE trn-block.
    END.

    IF AVAILABLE bgsm_profile_data AND ttProfileData.cAction <> "DEL":U THEN
    DO:
      ASSIGN
        bgsm_profile_data.user_obj = ttProfileData.user_obj
        bgsm_profile_data.profile_type_obj = ttProfileData.profile_type_obj
        bgsm_profile_data.profile_code_obj = ttProfileData.profile_code_obj
        bgsm_profile_data.profile_data_key = ttProfileData.profile_data_key
        bgsm_profile_data.context_id = ttProfileData.context_id               
        bgsm_profile_data.profile_data_value = ttProfileData.profile_data_value
        .
      VALIDATE bgsm_profile_data NO-ERROR.
      IF ERROR-STATUS:ERROR THEN UNDO trn-block, LEAVE trn-block.
    END.

    IF AVAILABLE bgsm_profile_data AND ttProfileData.cAction = "DEL":U THEN
    DO:
      DELETE bgsm_profile_data NO-ERROR.
      IF ERROR-STATUS:ERROR THEN UNDO trn-block, LEAVE trn-block.
    END.

    /* Finally update temp-table action. */
    IF ttProfileData.cAction = "DEL":U THEN
      DELETE ttProfileData.
    ELSE
      ASSIGN ttProfileData.cAction = "NON":U.

  END.

END.  /* trn-block*/
{af/sup2/afcheckerr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


