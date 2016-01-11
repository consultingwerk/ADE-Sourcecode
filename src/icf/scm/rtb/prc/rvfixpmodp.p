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
  File: rvfixpmodp.p

  Description:  Fix RV product modules

  Purpose:      Noddy to fix product modules in RV database - main use was following schema
                changes that added product module field to many extra tables.
                The product module was originally on the workspace item table, so used this
                as a base to start.

  Parameters:

  History:
  --------
  (v:010000)    Task:        7361   UserRef:    
                Date:   21/12/2000  Author:     Anthony Swindells

  Update Notes: Allow product module changes in RV and track changes

--------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rvfixpmodp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010000


/* Astra object identifying preprocessor */
&glob   AstraProcedure    yes

{af/sup2/afglobals.i}

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
         HEIGHT             = 7.91
         WIDTH              = 49.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DISABLE TRIGGERS FOR LOAD OF rvm_workspace_item.
DISABLE TRIGGERS FOR LOAD OF rvt_deleted_item.
DISABLE TRIGGERS FOR LOAD OF rvm_configuration_item.
DISABLE TRIGGERS FOR LOAD OF rvt_item_version.

MESSAGE "Do you want to fix the 0 product modules in the RV database due to the schema changes." SKIP(1)
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
        UPDATE lContinue AS LOGICAL.
IF NOT lContinue THEN RETURN.

SESSION:SET-WAIT-STATE("general":U).

/* prime new field - task product module */
workspace-item-loop:
FOR EACH rvm_workspace_item EXCLUSIVE-LOCK:
  IF rvm_workspace_item.task_version_number <> 0 AND
     rvm_workspace_item.task_product_module_obj = 0 THEN
    ASSIGN rvm_workspace_item.task_product_module_obj = rvm_workspace_item.product_module_obj.
END. /* workspace item loop */

/* fix item versions with 0 product module */
item-version-loop:
FOR EACH rvt_item_version EXCLUSIVE-LOCK:
  IF rvt_item_version.product_module_obj <> 0 THEN NEXT item-version-loop.
  FIND FIRST rvm_configuration_item NO-LOCK
       WHERE rvm_configuration_item.configuration_type = rvt_item_version.configuration_type
         AND rvm_configuration_item.scm_object_name = rvt_item_version.scm_object_name
       NO-ERROR.

  IF NOT AVAILABLE rvm_configuration_item THEN
    MESSAGE "rvt_item_version" SKIP rvt_item_version.configuration_type SKIP rvt_item_version.scm_object_name.

  ASSIGN rvt_item_version.product_module_obj = rvm_configuration_item.product_module_obj.
  IF rvt_item_version.baseline_version_number <> 0 THEN
    ASSIGN rvt_item_version.baseline_product_module_obj = rvm_configuration_item.product_module_obj.
  IF rvt_item_version.previous_version_number <> 0 THEN
    ASSIGN rvt_item_version.previous_product_module_obj = rvm_configuration_item.product_module_obj.
END. /* item version loop */

/* fix deleted items with 0 product module */
deleted-item-loop:
FOR EACH rvt_deleted_item EXCLUSIVE-LOCK:
  IF rvt_deleted_item.product_module_obj <> 0 THEN NEXT deleted-item-loop.
  FIND FIRST rvm_configuration_item NO-LOCK
       WHERE rvm_configuration_item.configuration_type = rvt_deleted_item.configuration_type
         AND rvm_configuration_item.scm_object_name = rvt_deleted_item.scm_object_name
       NO-ERROR.

  IF NOT AVAILABLE rvm_configuration_item THEN
  DO:
    DELETE rvt_deleted_item NO-ERROR.
  END.
  ELSE  
    ASSIGN rvt_deleted_item.product_module_obj = rvm_configuration_item.product_module_obj.
END. /* deleted item loop */


SESSION:SET-WAIT-STATE("":U).

MESSAGE "Completed fix of RV product modules." 
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
RETURN.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
