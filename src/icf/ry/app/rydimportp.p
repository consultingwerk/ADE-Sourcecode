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
  File: rydimportp.p

  Description:  Repository Data Import Procedure

  Purpose:      Repository Data Import Procedure

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        7287   UserRef:    
                Date:   14/12/2000  Author:     Anthony Swindells

  Update Notes: Fix deployments and imports

  (v:010001)    Task:        7336   UserRef:    
                Date:   18/12/2000  Author:     Anthony Swindells

  Update Notes: Fix deployment package issues

  (v:010002)    Task:        7435   UserRef:    
                Date:   02/01/2001  Author:     Anthony Swindells

  Update Notes: Fix import issues

  (v:010004)    Task:        7811   UserRef:    
                Date:   02/02/2001  Author:     Anthony Swindells

  Update Notes: Enhance Deployment load programs to be more resiliant to changes in data.
                When looking for AK, if not found alos check for obj before creating a new
                one, to cope with code field changing. In RY imports, for every rycso
                imported, first delete data from all other related tables to avoid conflicts in
                import - especially if object is deleted and recreated in wizards.

  (v:010005)    Task:    90000031   UserRef:    
                Date:   22/03/2001  Author:     Anthony Swindells

  Update Notes: removal of Astra 1

-----------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rydimportp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010005


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

DEFINE TEMP-TABLE ttryc_action NO-UNDO LIKE ryc_action.
DEFINE TEMP-TABLE ttryc_attribute NO-UNDO LIKE ryc_attribute.
DEFINE TEMP-TABLE ttryc_attribute_group NO-UNDO LIKE ryc_attribute_group.
DEFINE TEMP-TABLE ttryc_attribute_type NO-UNDO LIKE ryc_attribute_type.
DEFINE TEMP-TABLE ttryc_band NO-UNDO LIKE ryc_band.
DEFINE TEMP-TABLE ttryc_band_action NO-UNDO LIKE ryc_band_action.
DEFINE TEMP-TABLE ttryc_layout NO-UNDO LIKE ryc_layout.
DEFINE TEMP-TABLE ttryc_smartlink_type NO-UNDO LIKE ryc_smartlink_type.
DEFINE TEMP-TABLE ttryc_subscribe NO-UNDO LIKE ryc_subscribe.
DEFINE TEMP-TABLE ttryc_supported_link NO-UNDO LIKE ryc_supported_link.
DEFINE TEMP-TABLE ttryc_ui_trigger NO-UNDO LIKE ryc_ui_trigger.
DEFINE TEMP-TABLE ttryc_valid_ui_trigger NO-UNDO LIKE ryc_valid_ui_trigger.
DEFINE TEMP-TABLE ttryc_widget_type NO-UNDO LIKE ryc_widget_type.
DEFINE TEMP-TABLE ttrym_lookup_field NO-UNDO LIKE rym_lookup_field.
DEFINE TEMP-TABLE ttgsc_object_type NO-UNDO LIKE gsc_object_type.
DEFINE TEMP-TABLE ttgsc_product NO-UNDO LIKE gsc_product.
DEFINE TEMP-TABLE ttgsc_product_module NO-UNDO LIKE gsc_product_module.

DEFINE TEMP-TABLE ttryc_smartobject NO-UNDO LIKE ryc_smartobject.
DEFINE TEMP-TABLE ttryc_object_instance NO-UNDO LIKE ryc_object_instance.
DEFINE TEMP-TABLE ttryc_page NO-UNDO LIKE ryc_page.
DEFINE TEMP-TABLE ttryc_page_object NO-UNDO LIKE ryc_page_object.
DEFINE TEMP-TABLE ttryc_smartlink NO-UNDO LIKE ryc_smartlink.
DEFINE TEMP-TABLE ttryc_smartobject_field NO-UNDO LIKE ryc_smartobject_field.
DEFINE TEMP-TABLE ttryc_custom_ui_trigger NO-UNDO LIKE ryc_custom_ui_trigger.
DEFINE TEMP-TABLE ttryc_attribute_value NO-UNDO LIKE ryc_attribute_value.
DEFINE TEMP-TABLE ttgsc_object NO-UNDO LIKE gsc_object.
DEFINE TEMP-TABLE ttrym_data_version NO-UNDO LIKE rym_data_version.
DEFINE TEMP-TABLE ttrym_wizard_menc NO-UNDO LIKE rym_wizard_menc.
DEFINE TEMP-TABLE ttrym_wizard_objc NO-UNDO LIKE rym_wizard_objc.
DEFINE TEMP-TABLE ttrym_wizard_fold NO-UNDO LIKE rym_wizard_fold.
DEFINE TEMP-TABLE ttrym_wizard_fold_page NO-UNDO LIKE rym_wizard_fold_page.
DEFINE TEMP-TABLE ttrym_wizard_view NO-UNDO LIKE rym_wizard_view.
DEFINE TEMP-TABLE ttrym_wizard_brow NO-UNDO LIKE rym_wizard_brow.

DISABLE TRIGGERS FOR LOAD OF ryc_action.
DISABLE TRIGGERS FOR LOAD OF ryc_attribute.
DISABLE TRIGGERS FOR LOAD OF ryc_attribute_group.
DISABLE TRIGGERS FOR LOAD OF ryc_attribute_type.
DISABLE TRIGGERS FOR LOAD OF ryc_band.
DISABLE TRIGGERS FOR LOAD OF ryc_band_action.
DISABLE TRIGGERS FOR LOAD OF ryc_layout.
DISABLE TRIGGERS FOR LOAD OF ryc_smartlink_type.
DISABLE TRIGGERS FOR LOAD OF ryc_subscribe.
DISABLE TRIGGERS FOR LOAD OF ryc_supported_link.
DISABLE TRIGGERS FOR LOAD OF ryc_ui_trigger.
DISABLE TRIGGERS FOR LOAD OF ryc_valid_ui_trigger.
DISABLE TRIGGERS FOR LOAD OF ryc_widget_type.
DISABLE TRIGGERS FOR LOAD OF rym_lookup_field.
DISABLE TRIGGERS FOR LOAD OF gsc_object_type.
DISABLE TRIGGERS FOR LOAD OF gsc_product.
DISABLE TRIGGERS FOR LOAD OF gsc_product_module.

DISABLE TRIGGERS FOR LOAD OF ryc_smartobject.
DISABLE TRIGGERS FOR LOAD OF ryc_object_instance.
DISABLE TRIGGERS FOR LOAD OF ryc_page.
DISABLE TRIGGERS FOR LOAD OF ryc_page_object.
DISABLE TRIGGERS FOR LOAD OF ryc_smartlink.
DISABLE TRIGGERS FOR LOAD OF ryc_smartobject_field.
DISABLE TRIGGERS FOR LOAD OF ryc_custom_ui_trigger.
DISABLE TRIGGERS FOR LOAD OF ryc_attribute_value.
DISABLE TRIGGERS FOR LOAD OF gsc_object.
DISABLE TRIGGERS FOR LOAD OF rym_data_version.
DISABLE TRIGGERS FOR LOAD OF rym_wizard_menc.
DISABLE TRIGGERS FOR LOAD OF rym_wizard_objc.
DISABLE TRIGGERS FOR LOAD OF rym_wizard_fold.
DISABLE TRIGGERS FOR LOAD OF rym_wizard_fold_page.
DISABLE TRIGGERS FOR LOAD OF rym_wizard_view.
DISABLE TRIGGERS FOR LOAD OF rym_wizard_brow.

DEFINE STREAM sOut1.

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
         HEIGHT             = 5.24
         WIDTH              = 48.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEFINE STREAM sImport.
DEFINE VARIABLE cFullFile           AS CHARACTER  NO-UNDO.

IF CONNECTED('ICFDB') THEN
DO:

  RUN loadRYCAC.  /* ryc_action */
  RUN loadRYCAP.  /* ryc_attribute_group */
  RUN loadRYCAY.  /* ryc_attribute_type */
  RUN loadRYCAT.  /* ryc_attribute */
  RUN loadRYCBD.  /* ryc_band */
  RUN loadRYCBA.  /* ryc_band_action */
  RUN loadRYCLA.  /* ryc_layout */
  RUN loadRYCST.  /* ryc_smartlink_type */
  RUN loadRYCSU.  /* ryc_subscribe */
  RUN loadRYCSL.  /* ryc_supported_link */
  RUN loadRYCUT.  /* ryc_ui_trigger */
  RUN loadRYCWT.  /* ryc_widget_type */
  RUN loadRYCVT.  /* ryc_valid_ui_trigger */
  RUN loadRYMLF.  /* rym_lookup_field */
  RUN loadGSCOT.  /* gsc_object_type */
  RUN loadGSCPR.  /* gsc_product */
  RUN loadGSCPM.  /* gsc_product_module */

  RUN loadRYCSO.  /* ryc_smartobject */
  RUN loadRYCOI.  /* ryc_object_instance */
  RUN loadRYCPA.  /* ryc_page */
  RUN loadRYCPO.  /* ryc_page_object */
  RUN loadRYCSM.  /* ryc_smartlink */
  RUN loadRYCSF.  /* ryc_smartobject_field */
  RUN loadRYCCT.  /* ryc_custom_ui_trigger */
  RUN loadRYCAV.  /* ryc_attribute_value */
  RUN loadGSCOB.  /* gsc_object */
  RUN loadRYMDV.  /* rym_data_version */
  RUN loadRYMWM.  /* rym_wizard_menc */
  RUN loadRYMWO.  /* rym_wizard_objc */
  RUN loadRYMWF.  /* rym_wizard_fold */
  RUN loadRYMFP.  /* rym_wizard_fold_page */
  RUN loadRYMWV.  /* rym_wizard_view */
  RUN loadRYMWB.  /* rym_wizard_brow */

END. /* connected ICFDB */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-deleteRYCSORelated) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteRYCSORelated Procedure 
PROCEDURE deleteRYCSORelated :
/*------------------------------------------------------------------------------
  Purpose:     Delete related tables for rycso to avoid conflicts on import.
               All related data for rycso will be imported anyway.
  Parameters:  input smartobject object number
  Notes:       Triggers are off so will need to manually delete related tables
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pdSmartObjectObj           AS DECIMAL  NO-UNDO.

FOR EACH ryc_object_instance EXCLUSIVE-LOCK
   WHERE ryc_object_instance.container_smartobject_obj = pdSmartObjectObj:
  DELETE ryc_object_instance.
END.

FOR EACH ryc_page EXCLUSIVE-LOCK
   WHERE ryc_page.container_smartobject_obj = pdSmartObjectObj:
  DELETE ryc_page.
END.

FOR EACH ryc_page_object EXCLUSIVE-LOCK
   WHERE ryc_page_object.container_smartobject_obj = pdSmartObjectObj:
  DELETE ryc_page_object.
END.

FOR EACH ryc_smartlink EXCLUSIVE-LOCK
   WHERE ryc_smartlink.container_smartobject_obj = pdSmartObjectObj:
  DELETE ryc_smartlink.
END.

FOR EACH ryc_smartobject_field EXCLUSIVE-LOCK
   WHERE ryc_smartobject_field.smartobject_obj = pdSmartObjectObj:
  DELETE ryc_smartobject_field.
END.

FOR EACH ryc_custom_ui_trigger EXCLUSIVE-LOCK
   WHERE ryc_custom_ui_trigger.smartobject_obj = pdSmartObjectObj:
  DELETE ryc_custom_ui_trigger.
END.

FOR EACH ryc_attribute_value EXCLUSIVE-LOCK
   WHERE ryc_attribute_value.primary_smartobject_obj = pdSmartObjectObj:
  DELETE ryc_attribute_value.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadGSCOB) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadGSCOB Procedure 
PROCEDURE loadGSCOB :
/*------------------------------------------------------------------------------
  Purpose:     load gsc_object
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE dObj                  AS DECIMAL    NO-UNDO.

  ASSIGN cFullFile = SEARCH('icf_dbdata/gscob.d').
  IF cFullFile <> ? THEN INPUT STREAM sImport FROM VALUE(cFullFile).
  IF cFullFile <> ? THEN
  REPEAT:
    CREATE ttgsc_object NO-ERROR.
    IMPORT STREAM sImport ttgsc_object NO-ERROR.
    /* ignore blanks or duff data */
    IF ttgsc_object.object_obj = 0 THEN
    DO:
      DELETE ttgsc_object NO-ERROR.
      NEXT.
    END.
    FIND FIRST gsc_object EXCLUSIVE-LOCK
         WHERE gsc_object.OBJECT_filename = ttgsc_object.OBJECT_filename
         NO-ERROR.
    IF NOT AVAILABLE gsc_object THEN
      FIND FIRST gsc_object EXCLUSIVE-LOCK
           WHERE gsc_object.OBJECT_obj = ttgsc_object.OBJECT_obj
           NO-ERROR.
    IF AVAILABLE gsc_object THEN ASSIGN dObj = gsc_object.OBJECT_obj.
    ELSE ASSIGN dObj = 0.
    BUFFER-COPY ttgsc_object TO gsc_object.
    IF AVAILABLE gsc_object AND dObj <> 0 AND dObj <> gsc_object.OBJECT_obj  THEN
    DO:
      OUTPUT STREAM sOut1 TO VALUE(REPLACE(cFullFile,".d":U,".e":U)) APPEND.
      PUT UNFORMATTED STRING(TODAY) + " ":U + STRING(TIME,"hh:mm":U) + " old gsc_object.object_obj = " + STRING(dObj) + " new gsc_object.object_obj = " + STRING(gsc_object.OBJECT_obj).      
      OUTPUT STREAM sOut1 CLOSE.
    END.
    RELEASE gsc_object NO-ERROR.
    DELETE ttgsc_object NO-ERROR.
  END.
  IF cFullFile <> ? THEN INPUT STREAM sImport CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadGSCOT) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadGSCOT Procedure 
PROCEDURE loadGSCOT :
/*------------------------------------------------------------------------------
  Purpose:     load gsc_object_type
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE dObj                  AS DECIMAL    NO-UNDO.

  ASSIGN cFullFile = SEARCH('icf_dbdata/gscot.d').
  IF cFullFile <> ? THEN INPUT STREAM sImport FROM VALUE(cFullFile).
  IF cFullFile <> ? THEN
  REPEAT:
    CREATE ttgsc_object_type NO-ERROR.
    IMPORT STREAM sImport ttgsc_object_type NO-ERROR.
    /* ignore blanks or duff data */
    IF ttgsc_object_type.object_type_obj = 0 THEN
    DO:
      DELETE ttgsc_object_type NO-ERROR.
      NEXT.
    END.
    FIND FIRST gsc_object_type EXCLUSIVE-LOCK
         WHERE gsc_object_type.object_type_code = ttgsc_object_type.object_type_code
         NO-ERROR.
    IF NOT AVAILABLE gsc_object_type THEN
      FIND FIRST gsc_object_type EXCLUSIVE-LOCK
           WHERE gsc_object_type.object_type_obj = ttgsc_object_type.object_type_obj
           NO-ERROR.
    IF AVAILABLE gsc_object_type THEN ASSIGN dObj = gsc_object_type.object_type_obj.
    ELSE ASSIGN dObj = 0.
    BUFFER-COPY ttgsc_object_type TO gsc_object_type.
    IF AVAILABLE gsc_object_type AND dObj <> 0 AND dObj <> gsc_object_type.object_type_obj  THEN
    DO:
      OUTPUT STREAM sOut1 TO VALUE(REPLACE(cFullFile,".d":U,".e":U)) APPEND.
      PUT UNFORMATTED STRING(TODAY) + " ":U + STRING(TIME,"hh:mm":U) + " old gsc_object_type.object_type_obj = " + STRING(dObj) + " new gsc_object_type.object_type_obj = " + STRING(gsc_object_type.object_type_obj).      
      OUTPUT STREAM sOut1 CLOSE.
    END.
    RELEASE gsc_object_type NO-ERROR.
    DELETE ttgsc_object_type NO-ERROR.
  END.
  IF cFullFile <> ? THEN INPUT STREAM sImport CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadGSCPM) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadGSCPM Procedure 
PROCEDURE loadGSCPM :
/*------------------------------------------------------------------------------
  Purpose:     load gsc_product_module
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE dObj                  AS DECIMAL    NO-UNDO.

  ASSIGN cFullFile = SEARCH('icf_dbdata/gscpm.d').
  IF cFullFile <> ? THEN INPUT STREAM sImport FROM VALUE(cFullFile).
  IF cFullFile <> ? THEN
  REPEAT:
    CREATE ttgsc_product_module NO-ERROR.
    IMPORT STREAM sImport ttgsc_product_module NO-ERROR.
    /* ignore blanks or duff data */
    IF ttgsc_product_module.product_module_obj = 0 THEN
    DO:
      DELETE ttgsc_product_module NO-ERROR.
      NEXT.
    END.
    FIND FIRST gsc_product_module EXCLUSIVE-LOCK
         WHERE gsc_product_module.product_module_code = ttgsc_product_module.product_module_code
         NO-ERROR.
    IF NOT AVAILABLE gsc_product_module THEN
      FIND FIRST gsc_product_module EXCLUSIVE-LOCK
           WHERE gsc_product_module.product_module_obj = ttgsc_product_module.product_module_obj
           NO-ERROR.
    IF AVAILABLE gsc_product_module THEN ASSIGN dObj = gsc_product_module.product_module_obj.
    ELSE ASSIGN dObj = 0.
    BUFFER-COPY ttgsc_product_module TO gsc_product_module.
    IF AVAILABLE gsc_product_module AND dObj <> 0 AND dObj <> gsc_product_module.product_module_obj  THEN
    DO:
      OUTPUT STREAM sOut1 TO VALUE(REPLACE(cFullFile,".d":U,".e":U)) APPEND.
      PUT UNFORMATTED STRING(TODAY) + " ":U + STRING(TIME,"hh:mm":U) + " old gsc_product_module.product_module_obj = " + STRING(dObj) + " new gsc_product_module.product_module_obj = " + STRING(gsc_product_module.product_module_obj).      
      OUTPUT STREAM sOut1 CLOSE.
    END.
    RELEASE gsc_product_module NO-ERROR.
    DELETE ttgsc_product_module NO-ERROR.
  END.
  IF cFullFile <> ? THEN INPUT STREAM sImport CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadGSCPR) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadGSCPR Procedure 
PROCEDURE loadGSCPR :
/*------------------------------------------------------------------------------
  Purpose:     load gsc_product
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE dObj                  AS DECIMAL    NO-UNDO.

  ASSIGN cFullFile = SEARCH('icf_dbdata/gscpr.d').
  IF cFullFile <> ? THEN INPUT STREAM sImport FROM VALUE(cFullFile).
  IF cFullFile <> ? THEN
  REPEAT:
    CREATE ttgsc_product NO-ERROR.
    IMPORT STREAM sImport ttgsc_product NO-ERROR.
    /* ignore blanks or duff data */
    IF ttgsc_product.product_obj = 0 THEN
    DO:
      DELETE ttgsc_product NO-ERROR.
      NEXT.
    END.
    FIND FIRST gsc_product EXCLUSIVE-LOCK
         WHERE gsc_product.product_code = ttgsc_product.product_code
         NO-ERROR.
    IF NOT AVAILABLE gsc_product THEN
      FIND FIRST gsc_product EXCLUSIVE-LOCK
           WHERE gsc_product.product_obj = ttgsc_product.product_obj
           NO-ERROR.
    IF AVAILABLE gsc_product THEN ASSIGN dObj = gsc_product.product_obj.
    ELSE ASSIGN dObj = 0.
    BUFFER-COPY ttgsc_product TO gsc_product.
    IF AVAILABLE gsc_product AND dObj <> 0 AND dObj <> gsc_product.product_obj  THEN
    DO:
      OUTPUT STREAM sOut1 TO VALUE(REPLACE(cFullFile,".d":U,".e":U)) APPEND.
      PUT UNFORMATTED STRING(TODAY) + " ":U + STRING(TIME,"hh:mm":U) + " old gsc_product.product_obj = " + STRING(dObj) + " new gsc_product.product_obj = " + STRING(gsc_product.product_obj).      
      OUTPUT STREAM sOut1 CLOSE.
    END.
    RELEASE gsc_product NO-ERROR.
    DELETE ttgsc_product NO-ERROR.
  END.
  IF cFullFile <> ? THEN INPUT STREAM sImport CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadRYCAC) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadRYCAC Procedure 
PROCEDURE loadRYCAC :
/*------------------------------------------------------------------------------
  Purpose:     load ryc_action
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE dObj                  AS DECIMAL    NO-UNDO.

  ASSIGN cFullFile = SEARCH('icf_dbdata/rycac.d').
  IF cFullFile <> ? THEN INPUT STREAM sImport FROM VALUE(cFullFile).
  IF cFullFile <> ? THEN
  REPEAT:
    CREATE ttryc_action NO-ERROR.
    IMPORT STREAM sImport ttryc_action NO-ERROR.
    /* ignore blanks or duff data */
    IF ttryc_action.action_obj = 0 THEN
    DO:
      DELETE ttryc_action NO-ERROR.
      NEXT.
    END.
    FIND FIRST ryc_action EXCLUSIVE-LOCK
         WHERE ryc_action.action_reference = ttryc_action.action_reference
         NO-ERROR.
    IF NOT AVAILABLE ryc_action THEN
      FIND FIRST ryc_action EXCLUSIVE-LOCK
           WHERE ryc_action.action_obj = ttryc_action.action_obj
           NO-ERROR.
    IF AVAILABLE ryc_action THEN ASSIGN dObj = ryc_action.action_obj.
    ELSE ASSIGN dObj = 0.
    BUFFER-COPY ttryc_action TO ryc_action.
    IF AVAILABLE ryc_action AND dObj <> 0 AND dObj <> ryc_action.action_obj  THEN
    DO:
      OUTPUT STREAM sOut1 TO VALUE(REPLACE(cFullFile,".d":U,".e":U)) APPEND.
      PUT UNFORMATTED STRING(TODAY) + " ":U + STRING(TIME,"hh:mm":U) + " old ryc_action.action_obj = " + STRING(dObj) + " new ryc_action.action_obj = " + STRING(ryc_action.action_obj).      
      OUTPUT STREAM sOut1 CLOSE.
    END.
    RELEASE ryc_action NO-ERROR.
    DELETE ttryc_action NO-ERROR.
  END.
  IF cFullFile <> ? THEN INPUT STREAM sImport CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadRYCAP) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadRYCAP Procedure 
PROCEDURE loadRYCAP :
/*------------------------------------------------------------------------------
  Purpose:     load ryc_attribute_group
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE dObj                  AS DECIMAL    NO-UNDO.

  ASSIGN cFullFile = SEARCH('icf_dbdata/rycap.d').
  IF cFullFile <> ? THEN INPUT STREAM sImport FROM VALUE(cFullFile).
  IF cFullFile <> ? THEN
  REPEAT:
    CREATE ttryc_attribute_group NO-ERROR.
    IMPORT STREAM sImport ttryc_attribute_group NO-ERROR.
    /* ignore blanks or duff data */
    IF ttryc_attribute_group.attribute_group_obj = 0 THEN
    DO:
      DELETE ttryc_attribute_group NO-ERROR.
      NEXT.
    END.
    FIND FIRST ryc_attribute_group EXCLUSIVE-LOCK
         WHERE ryc_attribute_group.attribute_group_name = ttryc_attribute_group.attribute_group_name
         NO-ERROR.
    IF NOT AVAILABLE ryc_attribute_group THEN
      FIND FIRST ryc_attribute_group EXCLUSIVE-LOCK
           WHERE ryc_attribute_group.attribute_group_obj = ttryc_attribute_group.attribute_group_obj
           NO-ERROR.
    IF AVAILABLE ryc_attribute_group THEN ASSIGN dObj = ryc_attribute_group.attribute_group_obj.
    ELSE ASSIGN dObj = 0.
    BUFFER-COPY ttryc_attribute_group TO ryc_attribute_group.
    IF AVAILABLE ryc_attribute_group AND dObj <> 0 AND dObj <> ryc_attribute_group.attribute_group_obj  THEN
    DO:
      OUTPUT STREAM sOut1 TO VALUE(REPLACE(cFullFile,".d":U,".e":U)) APPEND.
      PUT UNFORMATTED STRING(TODAY) + " ":U + STRING(TIME,"hh:mm":U) + " old ryc_attribute_group.attribute_group_obj = " + STRING(dObj) + " new ryc_attribute_group.attribute_group_obj = " + STRING(ryc_attribute_group.attribute_group_obj).      
      OUTPUT STREAM sOut1 CLOSE.
    END.
    RELEASE ryc_attribute_group NO-ERROR.
    DELETE ttryc_attribute_group NO-ERROR.
  END.
  IF cFullFile <> ? THEN INPUT STREAM sImport CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadRYCAT) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadRYCAT Procedure 
PROCEDURE loadRYCAT :
/*------------------------------------------------------------------------------
  Purpose:     load ryc_attribute
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE dObj                  AS DECIMAL    NO-UNDO.

  ASSIGN cFullFile = SEARCH('icf_dbdata/rycat.d').
  IF cFullFile <> ? THEN INPUT STREAM sImport FROM VALUE(cFullFile).
  IF cFullFile <> ? THEN
  REPEAT:
    CREATE ttryc_attribute NO-ERROR.
    IMPORT STREAM sImport ttryc_attribute NO-ERROR.
    /* ignore blanks or duff data */
    IF ttryc_attribute.attribute_obj = 0 THEN
    DO:
      DELETE ttryc_attribute NO-ERROR.
      NEXT.
    END.
    FIND FIRST ryc_attribute EXCLUSIVE-LOCK
         WHERE ryc_attribute.attribute_label = ttryc_attribute.attribute_label
         NO-ERROR.
    IF NOT AVAILABLE ryc_attribute THEN
      FIND FIRST ryc_attribute EXCLUSIVE-LOCK
           WHERE ryc_attribute.attribute_obj = ttryc_attribute.attribute_obj
           NO-ERROR.
    IF AVAILABLE ryc_attribute THEN ASSIGN dObj = ryc_attribute.attribute_obj.
    ELSE ASSIGN dObj = 0.
    BUFFER-COPY ttryc_attribute TO ryc_attribute.
    IF AVAILABLE ryc_attribute AND dObj <> 0 AND dObj <> ryc_attribute.attribute_obj  THEN
    DO:
      OUTPUT STREAM sOut1 TO VALUE(REPLACE(cFullFile,".d":U,".e":U)) APPEND.
      PUT UNFORMATTED STRING(TODAY) + " ":U + STRING(TIME,"hh:mm":U) + " old ryc_attribute.attribute_obj = " + STRING(dObj) + " new ryc_attribute.attribute_obj = " + STRING(ryc_attribute.attribute_obj).      
      OUTPUT STREAM sOut1 CLOSE.
    END.
    RELEASE ryc_attribute NO-ERROR.
    DELETE ttryc_attribute NO-ERROR.
  END.
  IF cFullFile <> ? THEN INPUT STREAM sImport CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadRYCAV) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadRYCAV Procedure 
PROCEDURE loadRYCAV :
/*------------------------------------------------------------------------------
  Purpose:     load ryc_attribute_value
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE dObj                  AS DECIMAL    NO-UNDO.

  ASSIGN cFullFile = SEARCH('icf_dbdata/rycav.d').
  IF cFullFile <> ? THEN INPUT STREAM sImport FROM VALUE(cFullFile).
  IF cFullFile <> ? THEN
  REPEAT:
    CREATE ttryc_attribute_value NO-ERROR.
    IMPORT STREAM sImport ttryc_attribute_value NO-ERROR.
    /* ignore blanks or duff data */
    IF ttryc_attribute_value.attribute_value_obj = 0 THEN
    DO:
      DELETE ttryc_attribute_value NO-ERROR.
      NEXT.
    END.
    FIND FIRST ryc_attribute_value EXCLUSIVE-LOCK
         WHERE ryc_attribute_value.attribute_value_obj = ttryc_attribute_value.attribute_value_obj
         NO-ERROR.
    IF AVAILABLE ryc_attribute_value THEN ASSIGN dObj = ryc_attribute_value.attribute_value_obj.
    ELSE ASSIGN dObj = 0.
    BUFFER-COPY ttryc_attribute_value TO ryc_attribute_value.
    IF AVAILABLE ryc_attribute_value AND dObj <> 0 AND dObj <> ryc_attribute_value.attribute_value_obj  THEN
    DO:
      OUTPUT STREAM sOut1 TO VALUE(REPLACE(cFullFile,".d":U,".e":U)) APPEND.
      PUT UNFORMATTED STRING(TODAY) + " ":U + STRING(TIME,"hh:mm":U) + " old ryc_attribute_value.attribute_value_obj = " + STRING(dObj) + " new ryc_attribute_value.attribute_value_obj = " + STRING(ryc_attribute_value.attribute_value_obj).      
      OUTPUT STREAM sOut1 CLOSE.
    END.
    RELEASE ryc_attribute_value NO-ERROR.
    DELETE ttryc_attribute_value NO-ERROR.
  END.
  IF cFullFile <> ? THEN INPUT STREAM sImport CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadRYCAY) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadRYCAY Procedure 
PROCEDURE loadRYCAY :
/*------------------------------------------------------------------------------
  Purpose:     load ryc_attribute_type
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE dObj                  AS DECIMAL    NO-UNDO.

  ASSIGN cFullFile = SEARCH('icf_dbdata/rycay.d').
  IF cFullFile <> ? THEN INPUT STREAM sImport FROM VALUE(cFullFile).
  IF cFullFile <> ? THEN
  REPEAT:
    CREATE ttryc_attribute_type NO-ERROR.
    IMPORT STREAM sImport ttryc_attribute_type NO-ERROR.
    /* ignore blanks or duff data */
    IF ttryc_attribute_type.attribute_type_obj = 0 THEN
    DO:
      DELETE ttryc_attribute_type NO-ERROR.
      NEXT.
    END.
    FIND FIRST ryc_attribute_type EXCLUSIVE-LOCK
         WHERE ryc_attribute_type.attribute_type_tla = ttryc_attribute_type.attribute_type_tla
         NO-ERROR.
    IF NOT AVAILABLE ryc_attribute_type THEN
      FIND FIRST ryc_attribute_type EXCLUSIVE-LOCK
           WHERE ryc_attribute_type.attribute_type_obj = ttryc_attribute_type.attribute_type_obj
           NO-ERROR.
    IF AVAILABLE ryc_attribute_type THEN ASSIGN dObj = ryc_attribute_type.attribute_type_obj.
    ELSE ASSIGN dObj = 0.
    BUFFER-COPY ttryc_attribute_type TO ryc_attribute_type.
    IF AVAILABLE ryc_attribute_type AND dObj <> 0 AND dObj <> ryc_attribute_type.attribute_type_obj  THEN
    DO:
      OUTPUT STREAM sOut1 TO VALUE(REPLACE(cFullFile,".d":U,".e":U)) APPEND.
      PUT UNFORMATTED STRING(TODAY) + " ":U + STRING(TIME,"hh:mm":U) + " old ryc_attribute_type.attribute_type_obj = " + STRING(dObj) + " new ryc_attribute_type.attribute_type_obj = " + STRING(ryc_attribute_type.attribute_type_obj).      
      OUTPUT STREAM sOut1 CLOSE.
    END.
    RELEASE ryc_attribute_type NO-ERROR.
    DELETE ttryc_attribute_type NO-ERROR.
  END.
  IF cFullFile <> ? THEN INPUT STREAM sImport CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadRYCBA) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadRYCBA Procedure 
PROCEDURE loadRYCBA :
/*------------------------------------------------------------------------------
  Purpose:     load ryc_band_action
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE dObj                  AS DECIMAL    NO-UNDO.

  ASSIGN cFullFile = SEARCH('icf_dbdata/rycba.d').
  IF cFullFile <> ? THEN INPUT STREAM sImport FROM VALUE(cFullFile).
  IF cFullFile <> ? THEN
  REPEAT:
    CREATE ttryc_band_action NO-ERROR.
    IMPORT STREAM sImport ttryc_band_action NO-ERROR.
    /* ignore blanks or duff data */
    IF ttryc_band_action.band_action_obj = 0 THEN
    DO:
      DELETE ttryc_band_action NO-ERROR.
      NEXT.
    END.
    FIND FIRST ryc_band_action EXCLUSIVE-LOCK
         WHERE ryc_band_action.action_obj = ttryc_band_action.action_obj
           AND ryc_band_action.band_obj = ttryc_band_action.band_obj
         NO-ERROR.
    IF NOT AVAILABLE ryc_band_action THEN
      FIND FIRST ryc_band_action EXCLUSIVE-LOCK
           WHERE ryc_band_action.band_action_obj = ttryc_band_action.band_action_obj
           NO-ERROR.
    IF AVAILABLE ryc_band_action THEN ASSIGN dObj = ryc_band_action.band_action_obj.
    ELSE ASSIGN dObj = 0.
    BUFFER-COPY ttryc_band_action TO ryc_band_action.
    IF AVAILABLE ryc_band_action AND dObj <> 0 AND dObj <> ryc_band_action.band_action_obj  THEN
    DO:
      OUTPUT STREAM sOut1 TO VALUE(REPLACE(cFullFile,".d":U,".e":U)) APPEND.
      PUT UNFORMATTED STRING(TODAY) + " ":U + STRING(TIME,"hh:mm":U) + " old ryc_band_action.band_action_obj = " + STRING(dObj) + " new ryc_band_action.band_action_obj = " + STRING(ryc_band_action.band_action_obj).      
      OUTPUT STREAM sOut1 CLOSE.
    END.
    RELEASE ryc_band_action NO-ERROR.
    DELETE ttryc_band_action NO-ERROR.
  END.
  IF cFullFile <> ? THEN INPUT STREAM sImport CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadRYCBD) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadRYCBD Procedure 
PROCEDURE loadRYCBD :
/*------------------------------------------------------------------------------
  Purpose:     load ryc_band
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE dObj                  AS DECIMAL    NO-UNDO.

  ASSIGN cFullFile = SEARCH('icf_dbdata/rycbd.d').
  IF cFullFile <> ? THEN INPUT STREAM sImport FROM VALUE(cFullFile).
  IF cFullFile <> ? THEN
  REPEAT:
    CREATE ttryc_band NO-ERROR.
    IMPORT STREAM sImport ttryc_band NO-ERROR.
    /* ignore blanks or duff data */
    IF ttryc_band.band_obj = 0 THEN
    DO:
      DELETE ttryc_band NO-ERROR.
      NEXT.
    END.
    FIND FIRST ryc_band EXCLUSIVE-LOCK
         WHERE ryc_band.band_name = ttryc_band.band_name
         NO-ERROR.
    IF NOT AVAILABLE ryc_band THEN
      FIND FIRST ryc_band EXCLUSIVE-LOCK
           WHERE ryc_band.band_obj = ttryc_band.band_obj
           NO-ERROR.
    IF AVAILABLE ryc_band THEN ASSIGN dObj = ryc_band.band_obj.
    ELSE ASSIGN dObj = 0.
    BUFFER-COPY ttryc_band TO ryc_band.
    IF AVAILABLE ryc_band AND dObj <> 0 AND dObj <> ryc_band.band_obj  THEN
    DO:
      OUTPUT STREAM sOut1 TO VALUE(REPLACE(cFullFile,".d":U,".e":U)) APPEND.
      PUT UNFORMATTED STRING(TODAY) + " ":U + STRING(TIME,"hh:mm":U) + " old ryc_band.band_obj = " + STRING(dObj) + " new ryc_band.band_obj = " + STRING(ryc_band.band_obj).      
      OUTPUT STREAM sOut1 CLOSE.
    END.
    RELEASE ryc_band NO-ERROR.
    DELETE ttryc_band NO-ERROR.
  END.
  IF cFullFile <> ? THEN INPUT STREAM sImport CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadRYCCT) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadRYCCT Procedure 
PROCEDURE loadRYCCT :
/*------------------------------------------------------------------------------
  Purpose:     load ryc_custom_ui_trigger
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE dObj                  AS DECIMAL    NO-UNDO.

  ASSIGN cFullFile = SEARCH('icf_dbdata/rycct.d').
  IF cFullFile <> ? THEN INPUT STREAM sImport FROM VALUE(cFullFile).
  IF cFullFile <> ? THEN
  REPEAT:
    CREATE ttryc_custom_ui_trigger NO-ERROR.
    IMPORT STREAM sImport ttryc_custom_ui_trigger NO-ERROR.
    /* ignore blanks or duff data */
    IF ttryc_custom_ui_trigger.custom_ui_trigger_obj = 0 THEN
    DO:
      DELETE ttryc_custom_ui_trigger NO-ERROR.
      NEXT.
    END.
    FIND FIRST ryc_custom_ui_trigger EXCLUSIVE-LOCK
         WHERE ryc_custom_ui_trigger.custom_ui_trigger_obj = ttryc_custom_ui_trigger.custom_ui_trigger_obj
         NO-ERROR.
    IF AVAILABLE ryc_custom_ui_trigger THEN ASSIGN dObj = ryc_custom_ui_trigger.custom_ui_trigger_obj.
    ELSE ASSIGN dObj = 0.
    BUFFER-COPY ttryc_custom_ui_trigger TO ryc_custom_ui_trigger.
    IF AVAILABLE ryc_custom_ui_trigger AND dObj <> 0 AND dObj <> ryc_custom_ui_trigger.custom_ui_trigger_obj  THEN
    DO:
      OUTPUT STREAM sOut1 TO VALUE(REPLACE(cFullFile,".d":U,".e":U)) APPEND.
      PUT UNFORMATTED STRING(TODAY) + " ":U + STRING(TIME,"hh:mm":U) + " old ryc_custom_ui_trigger.custom_ui_trigger_obj = " + STRING(dObj) + " new ryc_custom_ui_trigger.custom_ui_trigger_obj = " + STRING(ryc_custom_ui_trigger.custom_ui_trigger_obj).      
      OUTPUT STREAM sOut1 CLOSE.
    END.
    RELEASE ryc_custom_ui_trigger NO-ERROR.
    DELETE ttryc_custom_ui_trigger NO-ERROR.
  END.
  IF cFullFile <> ? THEN INPUT STREAM sImport CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadRYCLA) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadRYCLA Procedure 
PROCEDURE loadRYCLA :
/*------------------------------------------------------------------------------
  Purpose:     load ryc_layout
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE dObj                  AS DECIMAL    NO-UNDO.

  ASSIGN cFullFile = SEARCH('icf_dbdata/rycla.d').
  IF cFullFile <> ? THEN INPUT STREAM sImport FROM VALUE(cFullFile).
  IF cFullFile <> ? THEN
  REPEAT:
    CREATE ttryc_layout NO-ERROR.
    IMPORT STREAM sImport ttryc_layout NO-ERROR.
    /* ignore blanks or duff data */
    IF ttryc_layout.layout_obj = 0 THEN
    DO:
      DELETE ttryc_layout NO-ERROR.
      NEXT.
    END.
    FIND FIRST ryc_layout EXCLUSIVE-LOCK
         WHERE ryc_layout.layout_name = ttryc_layout.layout_name
         NO-ERROR.
    IF NOT AVAILABLE ryc_layout THEN
      FIND FIRST ryc_layout EXCLUSIVE-LOCK
           WHERE ryc_layout.layout_obj = ttryc_layout.layout_obj
           NO-ERROR.
    IF AVAILABLE ryc_layout THEN ASSIGN dObj = ryc_layout.layout_obj.
    ELSE ASSIGN dObj = 0.
    BUFFER-COPY ttryc_layout TO ryc_layout.
    IF AVAILABLE ryc_layout AND dObj <> 0 AND dObj <> ryc_layout.layout_obj  THEN
    DO:
      OUTPUT STREAM sOut1 TO VALUE(REPLACE(cFullFile,".d":U,".e":U)) APPEND.
      PUT UNFORMATTED STRING(TODAY) + " ":U + STRING(TIME,"hh:mm":U) + " old ryc_layout.layout_obj = " + STRING(dObj) + " new ryc_layout.layout_obj = " + STRING(ryc_layout.layout_obj).      
      OUTPUT STREAM sOut1 CLOSE.
    END.
    RELEASE ryc_layout NO-ERROR.
    DELETE ttryc_layout NO-ERROR.
  END.
  IF cFullFile <> ? THEN INPUT STREAM sImport CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadRYCOI) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadRYCOI Procedure 
PROCEDURE loadRYCOI :
/*------------------------------------------------------------------------------
  Purpose:     load ryc_object_instance
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE dObj                  AS DECIMAL    NO-UNDO.

  ASSIGN cFullFile = SEARCH('icf_dbdata/rycoi.d').
  IF cFullFile <> ? THEN INPUT STREAM sImport FROM VALUE(cFullFile).
  IF cFullFile <> ? THEN
  REPEAT:
    CREATE ttryc_object_instance NO-ERROR.
    IMPORT STREAM sImport ttryc_object_instance NO-ERROR.
    /* ignore blanks or duff data */
    IF ttryc_object_instance.object_instance_obj = 0 THEN
    DO:
      DELETE ttryc_object_instance NO-ERROR.
      NEXT.
    END.
    FIND FIRST ryc_object_instance EXCLUSIVE-LOCK
         WHERE ryc_object_instance.container_smartobject_obj = ttryc_object_instance.container_smartobject_obj
           AND ryc_object_instance.OBJECT_instance_obj = ttryc_object_instance.OBJECT_instance_obj
         NO-ERROR.
    IF AVAILABLE ryc_object_instance THEN ASSIGN dObj = ryc_object_instance.object_instance_obj.
    ELSE ASSIGN dObj = 0.
    BUFFER-COPY ttryc_object_instance TO ryc_object_instance.
    IF AVAILABLE ryc_object_instance AND dObj <> 0 AND dObj <> ryc_object_instance.object_instance_obj  THEN
    DO:
      OUTPUT STREAM sOut1 TO VALUE(REPLACE(cFullFile,".d":U,".e":U)) APPEND.
      PUT UNFORMATTED STRING(TODAY) + " ":U + STRING(TIME,"hh:mm":U) + " old ryc_object_instance.object_instance_obj = " + STRING(dObj) + " new ryc_object_instance.object_instance_obj = " + STRING(ryc_object_instance.object_instance_obj).      
      OUTPUT STREAM sOut1 CLOSE.
    END.
    RELEASE ryc_object_instance NO-ERROR.
    DELETE ttryc_object_instance NO-ERROR.
  END.
  IF cFullFile <> ? THEN INPUT STREAM sImport CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadRYCPA) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadRYCPA Procedure 
PROCEDURE loadRYCPA :
/*------------------------------------------------------------------------------
  Purpose:     load ryc_page
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE dObj                  AS DECIMAL    NO-UNDO.

  ASSIGN cFullFile = SEARCH('icf_dbdata/rycpa.d').
  IF cFullFile <> ? THEN INPUT STREAM sImport FROM VALUE(cFullFile).
  IF cFullFile <> ? THEN
  REPEAT:
    CREATE ttryc_page NO-ERROR.
    IMPORT STREAM sImport ttryc_page NO-ERROR.
    /* ignore blanks or duff data */
    IF ttryc_page.page_obj = 0 THEN
    DO:
      DELETE ttryc_page NO-ERROR.
      NEXT.
    END.
    FIND FIRST ryc_page EXCLUSIVE-LOCK
         WHERE ryc_page.page_obj = ttryc_page.page_obj
           AND ryc_page.container_smartobject_obj = ttryc_page.container_smartobject_obj
         NO-ERROR.
    IF AVAILABLE ryc_page THEN ASSIGN dObj = ryc_page.page_obj.
    ELSE ASSIGN dObj = 0.
    BUFFER-COPY ttryc_page TO ryc_page.
    IF AVAILABLE ryc_page AND dObj <> 0 AND dObj <> ryc_page.page_obj  THEN
    DO:
      OUTPUT STREAM sOut1 TO VALUE(REPLACE(cFullFile,".d":U,".e":U)) APPEND.
      PUT UNFORMATTED STRING(TODAY) + " ":U + STRING(TIME,"hh:mm":U) + " old ryc_page.page_obj = " + STRING(dObj) + " new ryc_page.page_obj = " + STRING(ryc_page.page_obj).      
      OUTPUT STREAM sOut1 CLOSE.
    END.
    RELEASE ryc_page NO-ERROR.
    DELETE ttryc_page NO-ERROR.
  END.
  IF cFullFile <> ? THEN INPUT STREAM sImport CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadRYCPO) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadRYCPO Procedure 
PROCEDURE loadRYCPO :
/*------------------------------------------------------------------------------
  Purpose:     load ryc_page_object
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE dObj                  AS DECIMAL    NO-UNDO.

  ASSIGN cFullFile = SEARCH('icf_dbdata/rycpo.d').
  IF cFullFile <> ? THEN INPUT STREAM sImport FROM VALUE(cFullFile).
  IF cFullFile <> ? THEN
  REPEAT:
    CREATE ttryc_page_object NO-ERROR.
    IMPORT STREAM sImport ttryc_page_object NO-ERROR.
    /* ignore blanks or duff data */
    IF ttryc_page_object.page_object_obj = 0 THEN
    DO:
      DELETE ttryc_page_object NO-ERROR.
      NEXT.
    END.
    FIND FIRST ryc_page_object EXCLUSIVE-LOCK
         WHERE ryc_page_object.page_object_obj = ttryc_page_object.page_object_obj
         NO-ERROR.
    IF AVAILABLE ryc_page_object THEN ASSIGN dObj = ryc_page_object.page_object_obj.
    ELSE ASSIGN dObj = 0.
    BUFFER-COPY ttryc_page_object TO ryc_page_object.
    IF AVAILABLE ryc_page_object AND dObj <> 0 AND dObj <> ryc_page_object.page_object_obj  THEN
    DO:
      OUTPUT STREAM sOut1 TO VALUE(REPLACE(cFullFile,".d":U,".e":U)) APPEND.
      PUT UNFORMATTED STRING(TODAY) + " ":U + STRING(TIME,"hh:mm":U) + " old ryc_page_object.page_object_obj = " + STRING(dObj) + " new ryc_page_object.page_object_obj = " + STRING(ryc_page_object.page_object_obj).      
      OUTPUT STREAM sOut1 CLOSE.
    END.
    RELEASE ryc_page_object NO-ERROR.
    DELETE ttryc_page_object NO-ERROR.
  END.
  IF cFullFile <> ? THEN INPUT STREAM sImport CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadRYCSF) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadRYCSF Procedure 
PROCEDURE loadRYCSF :
/*------------------------------------------------------------------------------
  Purpose:     load ryc_smartobject_field
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE dObj                  AS DECIMAL    NO-UNDO.

  ASSIGN cFullFile = SEARCH('icf_dbdata/rycsf.d').
  IF cFullFile <> ? THEN INPUT STREAM sImport FROM VALUE(cFullFile).
  IF cFullFile <> ? THEN
  REPEAT:
    CREATE ttryc_smartobject_field NO-ERROR.
    IMPORT STREAM sImport ttryc_smartobject_field NO-ERROR.
    /* ignore blanks or duff data */
    IF ttryc_smartobject_field.smartobject_field_obj = 0 THEN
    DO:
      DELETE ttryc_smartobject_field NO-ERROR.
      NEXT.
    END.
    FIND FIRST ryc_smartobject_field EXCLUSIVE-LOCK
         WHERE ryc_smartobject_field.smartobject_field_obj = ttryc_smartobject_field.smartobject_field_obj
         NO-ERROR.
    IF AVAILABLE ryc_smartobject_field THEN ASSIGN dObj = ryc_smartobject_field.smartobject_field_obj.
    ELSE ASSIGN dObj = 0.
    BUFFER-COPY ttryc_smartobject_field TO ryc_smartobject_field.
    IF AVAILABLE ryc_smartobject_field AND dObj <> 0 AND dObj <> ryc_smartobject_field.smartobject_field_obj  THEN
    DO:
      OUTPUT STREAM sOut1 TO VALUE(REPLACE(cFullFile,".d":U,".e":U)) APPEND.
      PUT UNFORMATTED STRING(TODAY) + " ":U + STRING(TIME,"hh:mm":U) + " old ryc_smartobject_field.smartobject_field_obj = " + STRING(dObj) + " new ryc_smartobject_field.smartobject_field_obj = " + STRING(ryc_smartobject_field.smartobject_field_obj).      
      OUTPUT STREAM sOut1 CLOSE.
    END.
    RELEASE ryc_smartobject_field NO-ERROR.
    DELETE ttryc_smartobject_field NO-ERROR.
  END.
  IF cFullFile <> ? THEN INPUT STREAM sImport CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadRYCSL) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadRYCSL Procedure 
PROCEDURE loadRYCSL :
/*------------------------------------------------------------------------------
  Purpose:     load ryc_supported_link
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE dObj                  AS DECIMAL    NO-UNDO.

  ASSIGN cFullFile = SEARCH('icf_dbdata/rycsl.d').
  IF cFullFile <> ? THEN INPUT STREAM sImport FROM VALUE(cFullFile).
  IF cFullFile <> ? THEN
  REPEAT:
    CREATE ttryc_supported_link NO-ERROR.
    IMPORT STREAM sImport ttryc_supported_link NO-ERROR.
    /* ignore blanks or duff data */
    IF ttryc_supported_link.supported_link_obj = 0 THEN
    DO:
      DELETE ttryc_supported_link NO-ERROR.
      NEXT.
    END.
    FIND FIRST ryc_supported_link EXCLUSIVE-LOCK
         WHERE ryc_supported_link.object_type_obj = ttryc_supported_link.object_type_obj
           AND ryc_supported_link.smartlink_type_obj = ttryc_supported_link.smartlink_type_obj
         NO-ERROR.
    IF NOT AVAILABLE ryc_supported_link THEN
      FIND FIRST ryc_supported_link EXCLUSIVE-LOCK
           WHERE ryc_supported_link.supported_link_obj = ttryc_supported_link.supported_link_obj
           NO-ERROR.
    IF AVAILABLE ryc_supported_link THEN ASSIGN dObj = ryc_supported_link.supported_link_obj.
    ELSE ASSIGN dObj = 0.
    BUFFER-COPY ttryc_supported_link TO ryc_supported_link.
    IF AVAILABLE ryc_supported_link AND dObj <> 0 AND dObj <> ryc_supported_link.supported_link_obj  THEN
    DO:
      OUTPUT STREAM sOut1 TO VALUE(REPLACE(cFullFile,".d":U,".e":U)) APPEND.
      PUT UNFORMATTED STRING(TODAY) + " ":U + STRING(TIME,"hh:mm":U) + " old ryc_supported_link.supported_link_obj = " + STRING(dObj) + " new ryc_supported_link.supported_link_obj = " + STRING(ryc_supported_link.supported_link_obj).      
      OUTPUT STREAM sOut1 CLOSE.
    END.
    RELEASE ryc_supported_link NO-ERROR.
    DELETE ttryc_supported_link NO-ERROR.
  END.
  IF cFullFile <> ? THEN INPUT STREAM sImport CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadRYCSM) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadRYCSM Procedure 
PROCEDURE loadRYCSM :
/*------------------------------------------------------------------------------
  Purpose:     load ryc_smartlink
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE dObj                  AS DECIMAL    NO-UNDO.

  ASSIGN cFullFile = SEARCH('icf_dbdata/rycsm.d').
  IF cFullFile <> ? THEN INPUT STREAM sImport FROM VALUE(cFullFile).
  IF cFullFile <> ? THEN
  REPEAT:
    CREATE ttryc_smartlink NO-ERROR.
    IMPORT STREAM sImport ttryc_smartlink NO-ERROR.
    /* ignore blanks or duff data */
    IF ttryc_smartlink.smartlink_obj = 0 THEN
    DO:
      DELETE ttryc_smartlink NO-ERROR.
      NEXT.
    END.
    FIND FIRST ryc_smartlink EXCLUSIVE-LOCK
         WHERE ryc_smartlink.smartlink_obj = ttryc_smartlink.smartlink_obj
         NO-ERROR.
    IF AVAILABLE ryc_smartlink THEN ASSIGN dObj = ryc_smartlink.smartlink_obj.
    ELSE ASSIGN dObj = 0.
    BUFFER-COPY ttryc_smartlink TO ryc_smartlink.
    IF AVAILABLE ryc_smartlink AND dObj <> 0 AND dObj <> ryc_smartlink.smartlink_obj  THEN
    DO:
      OUTPUT STREAM sOut1 TO VALUE(REPLACE(cFullFile,".d":U,".e":U)) APPEND.
      PUT UNFORMATTED STRING(TODAY) + " ":U + STRING(TIME,"hh:mm":U) + " old ryc_smartlink.smartlink_obj = " + STRING(dObj) + " new ryc_smartlink.smartlink_obj = " + STRING(ryc_smartlink.smartlink_obj).      
      OUTPUT STREAM sOut1 CLOSE.
    END.
    RELEASE ryc_smartlink NO-ERROR.
    DELETE ttryc_smartlink NO-ERROR.
  END.
  IF cFullFile <> ? THEN INPUT STREAM sImport CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadRYCSO) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadRYCSO Procedure 
PROCEDURE loadRYCSO :
/*------------------------------------------------------------------------------
  Purpose:     load ryc_smartobject
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE dObj                  AS DECIMAL    NO-UNDO.

  ASSIGN cFullFile = SEARCH('icf_dbdata/rycso.d').
  IF cFullFile <> ? THEN INPUT STREAM sImport FROM VALUE(cFullFile).
  IF cFullFile <> ? THEN
  REPEAT:
    CREATE ttryc_smartobject NO-ERROR.
    IMPORT STREAM sImport ttryc_smartobject NO-ERROR.
    /* ignore blanks or duff data */
    IF ttryc_smartobject.smartobject_obj = 0 THEN
    DO:
      DELETE ttryc_smartobject NO-ERROR.
      NEXT.
    END.
    FIND FIRST ryc_smartobject EXCLUSIVE-LOCK
         WHERE ryc_smartobject.OBJECT_filename = ttryc_smartobject.OBJECT_filename
         NO-ERROR.
    /* see if obj avaialble - in case changed name */
    IF NOT AVAILABLE ryc_smartobject THEN
      FIND FIRST ryc_smartobject EXCLUSIVE-LOCK
           WHERE ryc_smartobject.smartobject_obj = ttryc_smartobject.smartobject_obj
           NO-ERROR.
    IF AVAILABLE ryc_smartobject THEN ASSIGN dObj = ryc_smartobject.smartobject_obj.
    ELSE ASSIGN dObj = 0.
    BUFFER-COPY ttryc_smartobject TO ryc_smartobject.
    IF AVAILABLE ryc_smartobject AND dObj <> 0 AND dObj <> ryc_smartobject.smartobject_obj  THEN
    DO:
      OUTPUT STREAM sOut1 TO VALUE(REPLACE(cFullFile,".d":U,".e":U)) APPEND.
      PUT UNFORMATTED STRING(TODAY) + " ":U + STRING(TIME,"hh:mm":U) + " old ryc_smartobject.smartobject_obj = " + STRING(dObj) + " new ryc_smartobject.smartobject_obj = " + STRING(ryc_smartobject.smartobject_obj).      
      OUTPUT STREAM sOut1 CLOSE.
    END.

    /* Delete all related table info for rycso before import rest of details, to
       avoid conflicts and inconsistent data
    */
    RUN deleteRYCSORelated (INPUT ryc_smartobject.smartobject_obj).

    RELEASE ryc_smartobject NO-ERROR.
    DELETE ttryc_smartobject NO-ERROR.
  END.
  IF cFullFile <> ? THEN INPUT STREAM sImport CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadRYCST) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadRYCST Procedure 
PROCEDURE loadRYCST :
/*------------------------------------------------------------------------------
  Purpose:     load ryc_smartlink_type
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE dObj                  AS DECIMAL    NO-UNDO.

  ASSIGN cFullFile = SEARCH('icf_dbdata/rycst.d').
  IF cFullFile <> ? THEN INPUT STREAM sImport FROM VALUE(cFullFile).
  IF cFullFile <> ? THEN
  REPEAT:
    CREATE ttryc_smartlink_type NO-ERROR.
    IMPORT STREAM sImport ttryc_smartlink_type NO-ERROR.
    /* ignore blanks or duff data */
    IF ttryc_smartlink_type.smartlink_type_obj = 0 THEN
    DO:
      DELETE ttryc_smartlink_type NO-ERROR.
      NEXT.
    END.
    FIND FIRST ryc_smartlink_type EXCLUSIVE-LOCK
         WHERE ryc_smartlink_type.link_name = ttryc_smartlink_type.link_name
         NO-ERROR.
    IF NOT AVAILABLE ryc_smartlink_type THEN
      FIND FIRST ryc_smartlink_type EXCLUSIVE-LOCK
           WHERE ryc_smartlink_type.smartlink_type_obj = ttryc_smartlink_type.smartlink_type_obj
           NO-ERROR.
    IF AVAILABLE ryc_smartlink_type THEN ASSIGN dObj = ryc_smartlink_type.smartlink_type_obj.
    ELSE ASSIGN dObj = 0.
    BUFFER-COPY ttryc_smartlink_type TO ryc_smartlink_type.
    IF AVAILABLE ryc_smartlink_type AND dObj <> 0 AND dObj <> ryc_smartlink_type.smartlink_type_obj  THEN
    DO:
      OUTPUT STREAM sOut1 TO VALUE(REPLACE(cFullFile,".d":U,".e":U)) APPEND.
      PUT UNFORMATTED STRING(TODAY) + " ":U + STRING(TIME,"hh:mm":U) + " old ryc_smartlink_type.smartlink_type_obj = " + STRING(dObj) + " new ryc_smartlink_type.smartlink_type_obj = " + STRING(ryc_smartlink_type.smartlink_type_obj).      
      OUTPUT STREAM sOut1 CLOSE.
    END.
    RELEASE ryc_smartlink_type NO-ERROR.
    DELETE ttryc_smartlink_type NO-ERROR.
  END.
  IF cFullFile <> ? THEN INPUT STREAM sImport CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadRYCSU) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadRYCSU Procedure 
PROCEDURE loadRYCSU :
/*------------------------------------------------------------------------------
  Purpose:     load ryc_subscribe
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE dObj                  AS DECIMAL    NO-UNDO.

  ASSIGN cFullFile = SEARCH('icf_dbdata/rycsu.d').
  IF cFullFile <> ? THEN INPUT STREAM sImport FROM VALUE(cFullFile).
  IF cFullFile <> ? THEN
  REPEAT:
    CREATE ttryc_subscribe NO-ERROR.
    IMPORT STREAM sImport ttryc_subscribe NO-ERROR.
    /* ignore blanks or duff data */
    IF ttryc_subscribe.subscribe_obj = 0 THEN
    DO:
      DELETE ttryc_subscribe NO-ERROR.
      NEXT.
    END.
    FIND FIRST ryc_subscribe EXCLUSIVE-LOCK
         WHERE ryc_subscribe.owning_entity_mnemonic = ttryc_subscribe.owning_entity_mnemonic
           AND ryc_subscribe.owning_obj = ttryc_subscribe.owning_obj
           AND ryc_subscribe.SUBSCRIBE_to_event = ttryc_subscribe.SUBSCRIBE_to_event
           AND ryc_subscribe.SUBSCRIBE_in_link = ttryc_subscribe.SUBSCRIBE_in_link
         NO-ERROR.
    IF NOT AVAILABLE ryc_subscribe THEN
      FIND FIRST ryc_subscribe EXCLUSIVE-LOCK
           WHERE ryc_subscribe.subscribe_obj = ttryc_subscribe.subscribe_obj
           NO-ERROR.
    IF AVAILABLE ryc_subscribe THEN ASSIGN dObj = ryc_subscribe.subscribe_obj.
    ELSE ASSIGN dObj = 0.
    BUFFER-COPY ttryc_subscribe TO ryc_subscribe.
    IF AVAILABLE ryc_subscribe AND dObj <> 0 AND dObj <> ryc_subscribe.subscribe_obj  THEN
    DO:
      OUTPUT STREAM sOut1 TO VALUE(REPLACE(cFullFile,".d":U,".e":U)) APPEND.
      PUT UNFORMATTED STRING(TODAY) + " ":U + STRING(TIME,"hh:mm":U) + " old ryc_subscribe.subscribe_obj = " + STRING(dObj) + " new ryc_subscribe.subscribe_obj = " + STRING(ryc_subscribe.subscribe_obj).      
      OUTPUT STREAM sOut1 CLOSE.
    END.
    RELEASE ryc_subscribe NO-ERROR.
    DELETE ttryc_subscribe NO-ERROR.
  END.
  IF cFullFile <> ? THEN INPUT STREAM sImport CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadRYCUT) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadRYCUT Procedure 
PROCEDURE loadRYCUT :
/*------------------------------------------------------------------------------
  Purpose:     load ryc_ui_trigger
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE dObj                  AS DECIMAL    NO-UNDO.

  ASSIGN cFullFile = SEARCH('icf_dbdata/rycut.d').
  IF cFullFile <> ? THEN INPUT STREAM sImport FROM VALUE(cFullFile).
  IF cFullFile <> ? THEN
  REPEAT:
    CREATE ttryc_ui_trigger NO-ERROR.
    IMPORT STREAM sImport ttryc_ui_trigger NO-ERROR.
    /* ignore blanks or duff data */
    IF ttryc_ui_trigger.ui_trigger_obj = 0 THEN
    DO:
      DELETE ttryc_ui_trigger NO-ERROR.
      NEXT.
    END.
    FIND FIRST ryc_ui_trigger EXCLUSIVE-LOCK
         WHERE ryc_ui_trigger.ui_trigger_name = ttryc_ui_trigger.ui_trigger_name
         NO-ERROR.
    IF NOT AVAILABLE ryc_ui_trigger THEN
      FIND FIRST ryc_ui_trigger EXCLUSIVE-LOCK
           WHERE ryc_ui_trigger.ui_trigger_obj = ttryc_ui_trigger.ui_trigger_obj
           NO-ERROR.
    IF AVAILABLE ryc_ui_trigger THEN ASSIGN dObj = ryc_ui_trigger.ui_trigger_obj.
    ELSE ASSIGN dObj = 0.
    BUFFER-COPY ttryc_ui_trigger TO ryc_ui_trigger.
    IF AVAILABLE ryc_ui_trigger AND dObj <> 0 AND dObj <> ryc_ui_trigger.ui_trigger_obj  THEN
    DO:
      OUTPUT STREAM sOut1 TO VALUE(REPLACE(cFullFile,".d":U,".e":U)) APPEND.
      PUT UNFORMATTED STRING(TODAY) + " ":U + STRING(TIME,"hh:mm":U) + " old ryc_ui_trigger.ui_trigger_obj = " + STRING(dObj) + " new ryc_ui_trigger.ui_trigger_obj = " + STRING(ryc_ui_trigger.ui_trigger_obj).      
      OUTPUT STREAM sOut1 CLOSE.
    END.
    RELEASE ryc_ui_trigger NO-ERROR.
    DELETE ttryc_ui_trigger NO-ERROR.
  END.
  IF cFullFile <> ? THEN INPUT STREAM sImport CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadRYCVT) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadRYCVT Procedure 
PROCEDURE loadRYCVT :
/*------------------------------------------------------------------------------
  Purpose:     load ryc_valid_ui_trigger
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE dObj                  AS DECIMAL    NO-UNDO.

  ASSIGN cFullFile = SEARCH('icf_dbdata/rycvt.d').
  IF cFullFile <> ? THEN INPUT STREAM sImport FROM VALUE(cFullFile).
  IF cFullFile <> ? THEN
  REPEAT:
    CREATE ttryc_valid_ui_trigger NO-ERROR.
    IMPORT STREAM sImport ttryc_valid_ui_trigger NO-ERROR.
    /* ignore blanks or duff data */
    IF ttryc_valid_ui_trigger.valid_ui_trigger_obj = 0 THEN
    DO:
      DELETE ttryc_valid_ui_trigger NO-ERROR.
      NEXT.
    END.
    FIND FIRST ryc_valid_ui_trigger EXCLUSIVE-LOCK
         WHERE ryc_valid_ui_trigger.ui_trigger_obj = ttryc_valid_ui_trigger.ui_trigger_obj
           AND ryc_valid_ui_trigger.widget_type_obj = ttryc_valid_ui_trigger.widget_type_obj
         NO-ERROR.
    IF NOT AVAILABLE ryc_valid_ui_trigger THEN
      FIND FIRST ryc_valid_ui_trigger EXCLUSIVE-LOCK
           WHERE ryc_valid_ui_trigger.valid_ui_trigger_obj = ttryc_valid_ui_trigger.valid_ui_trigger_obj
           NO-ERROR.
    IF AVAILABLE ryc_valid_ui_trigger THEN ASSIGN dObj = ryc_valid_ui_trigger.valid_ui_trigger_obj.
    ELSE ASSIGN dObj = 0.
    BUFFER-COPY ttryc_valid_ui_trigger TO ryc_valid_ui_trigger.
    IF AVAILABLE ryc_valid_ui_trigger AND dObj <> 0 AND dObj <> ryc_valid_ui_trigger.valid_ui_trigger_obj  THEN
    DO:
      OUTPUT STREAM sOut1 TO VALUE(REPLACE(cFullFile,".d":U,".e":U)) APPEND.
      PUT UNFORMATTED STRING(TODAY) + " ":U + STRING(TIME,"hh:mm":U) + " old ryc_valid_ui_trigger.valid_ui_trigger_obj = " + STRING(dObj) + " new ryc_valid_ui_trigger.valid_ui_trigger_obj = " + STRING(ryc_valid_ui_trigger.valid_ui_trigger_obj).      
      OUTPUT STREAM sOut1 CLOSE.
    END.
    RELEASE ryc_valid_ui_trigger NO-ERROR.
    DELETE ttryc_valid_ui_trigger NO-ERROR.
  END.
  IF cFullFile <> ? THEN INPUT STREAM sImport CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadRYCWT) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadRYCWT Procedure 
PROCEDURE loadRYCWT :
/*------------------------------------------------------------------------------
  Purpose:     load ryc_widget_type
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE dObj                  AS DECIMAL    NO-UNDO.

  ASSIGN cFullFile = SEARCH('icf_dbdata/rycwt.d').
  IF cFullFile <> ? THEN INPUT STREAM sImport FROM VALUE(cFullFile).
  IF cFullFile <> ? THEN
  REPEAT:
    CREATE ttryc_widget_type NO-ERROR.
    IMPORT STREAM sImport ttryc_widget_type NO-ERROR.
    /* ignore blanks or duff data */
    IF ttryc_widget_type.widget_type_obj = 0 THEN
    DO:
      DELETE ttryc_widget_type NO-ERROR.
      NEXT.
    END.
    FIND FIRST ryc_widget_type EXCLUSIVE-LOCK
         WHERE ryc_widget_type.widget_type_name = ttryc_widget_type.widget_type_name
         NO-ERROR.
    IF NOT AVAILABLE ryc_widget_type THEN
      FIND FIRST ryc_widget_type EXCLUSIVE-LOCK
           WHERE ryc_widget_type.widget_type_obj = ttryc_widget_type.widget_type_obj
           NO-ERROR.
    IF AVAILABLE ryc_widget_type THEN ASSIGN dObj = ryc_widget_type.widget_type_obj.
    ELSE ASSIGN dObj = 0.
    BUFFER-COPY ttryc_widget_type TO ryc_widget_type.
    IF AVAILABLE ryc_widget_type AND dObj <> 0 AND dObj <> ryc_widget_type.widget_type_obj  THEN
    DO:
      OUTPUT STREAM sOut1 TO VALUE(REPLACE(cFullFile,".d":U,".e":U)) APPEND.
      PUT UNFORMATTED STRING(TODAY) + " ":U + STRING(TIME,"hh:mm":U) + " old ryc_widget_type.widget_type_obj = " + STRING(dObj) + " new ryc_widget_type.widget_type_obj = " + STRING(ryc_widget_type.widget_type_obj).      
      OUTPUT STREAM sOut1 CLOSE.
    END.
    RELEASE ryc_widget_type NO-ERROR.
    DELETE ttryc_widget_type NO-ERROR.
  END.
  IF cFullFile <> ? THEN INPUT STREAM sImport CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadRYMDV) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadRYMDV Procedure 
PROCEDURE loadRYMDV :
/*------------------------------------------------------------------------------
  Purpose:     load rym_data_version
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  ASSIGN cFullFile = SEARCH('icf_dbdata/rymdv.d').
  IF cFullFile <> ? THEN INPUT STREAM sImport FROM VALUE(cFullFile).
  IF cFullFile <> ? THEN
  REPEAT:
    CREATE ttrym_data_version NO-ERROR.
    IMPORT STREAM sImport ttrym_data_version NO-ERROR.
    /* ignore blanks or duff data */
    IF ttrym_data_version.data_version_obj = 0 THEN
    DO:
      DELETE ttrym_data_version NO-ERROR.
      NEXT.
    END.
    FIND FIRST rym_data_version EXCLUSIVE-LOCK
         WHERE rym_data_version.related_entity_mnemonic = ttrym_data_version.related_entity_mnemonic
           AND rym_data_version.related_entity_key = ttrym_data_version.related_entity_key
         NO-ERROR.
    IF NOT AVAILABLE rym_data_version THEN
      FIND FIRST rym_data_version EXCLUSIVE-LOCK
           WHERE rym_data_version.data_version_obj = ttrym_data_version.data_version_obj
           NO-ERROR.
    BUFFER-COPY ttrym_data_version TO rym_data_version.
    RELEASE rym_data_version NO-ERROR.
    DELETE ttrym_data_version NO-ERROR.
  END.
  IF cFullFile <> ? THEN INPUT STREAM sImport CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadRYMFP) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadRYMFP Procedure 
PROCEDURE loadRYMFP :
/*------------------------------------------------------------------------------
  Purpose:     load rym_wizard_fold_page
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE dObj                  AS DECIMAL    NO-UNDO.

  ASSIGN cFullFile = SEARCH('icf_dbdata/rymfp.d').
  IF cFullFile <> ? THEN INPUT STREAM sImport FROM VALUE(cFullFile).
  IF cFullFile <> ? THEN
  REPEAT:
    CREATE ttrym_wizard_fold_page NO-ERROR.
    IMPORT STREAM sImport ttrym_wizard_fold_page NO-ERROR.
    /* ignore blanks or duff data */
    IF ttrym_wizard_fold_page.wizard_fold_page_obj = 0 THEN
    DO:
      DELETE ttrym_wizard_fold_page NO-ERROR.
      NEXT.
    END.
    FIND FIRST rym_wizard_fold_page EXCLUSIVE-LOCK
         WHERE rym_wizard_fold_page.PAGE_number = ttrym_wizard_fold_page.PAGE_number
           AND rym_wizard_fold_page.wizard_fold_obj = ttrym_wizard_fold_page.wizard_fold_obj
         NO-ERROR.
    IF NOT AVAILABLE rym_wizard_fold_page THEN
      FIND FIRST rym_wizard_fold_page EXCLUSIVE-LOCK
           WHERE rym_wizard_fold_page.wizard_fold_page_obj = ttrym_wizard_fold_page.wizard_fold_page_obj
           NO-ERROR.
    IF AVAILABLE rym_wizard_fold_page THEN ASSIGN dObj = rym_wizard_fold_page.wizard_fold_page_obj.
    ELSE ASSIGN dObj = 0.
    BUFFER-COPY ttrym_wizard_fold_page TO rym_wizard_fold_page.
    IF AVAILABLE rym_wizard_fold_page AND dObj <> 0 AND dObj <> rym_wizard_fold_page.wizard_fold_page_obj  THEN
    DO:
      OUTPUT STREAM sOut1 TO VALUE(REPLACE(cFullFile,".d":U,".e":U)) APPEND.
      PUT UNFORMATTED STRING(TODAY) + " ":U + STRING(TIME,"hh:mm":U) + " old rym_wizard_fold_page.wizard_fold_page_obj = " + STRING(dObj) + " new rym_wizard_fold_page.wizard_fold_page_obj = " + STRING(rym_wizard_fold_page.wizard_fold_page_obj).      
      OUTPUT STREAM sOut1 CLOSE.
    END.
    RELEASE rym_wizard_fold_page NO-ERROR.
    DELETE ttrym_wizard_fold_page NO-ERROR.
  END.
  IF cFullFile <> ? THEN INPUT STREAM sImport CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadRYMLF) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadRYMLF Procedure 
PROCEDURE loadRYMLF :
/*------------------------------------------------------------------------------
  Purpose:     load rym_lookup_field
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE dObj                  AS DECIMAL    NO-UNDO.

  ASSIGN cFullFile = SEARCH('icf_dbdata/rymlf.d').
  IF cFullFile <> ? THEN INPUT STREAM sImport FROM VALUE(cFullFile).
  IF cFullFile <> ? THEN
  REPEAT:
    CREATE ttrym_lookup_field NO-ERROR.
    IMPORT STREAM sImport ttrym_lookup_field NO-ERROR.
    /* ignore blanks or duff data */
    IF ttrym_lookup_field.lookup_field_obj = 0 THEN
    DO:
      DELETE ttrym_lookup_field NO-ERROR.
      NEXT.
    END.
    FIND FIRST rym_lookup_field EXCLUSIVE-LOCK
         WHERE rym_lookup_field.lookup_field_name = ttrym_lookup_field.lookup_field_name
           AND rym_lookup_field.specific_object_name = ttrym_lookup_field.specific_object_name
         NO-ERROR.
    IF NOT AVAILABLE rym_lookup_field THEN
      FIND FIRST rym_lookup_field EXCLUSIVE-LOCK
           WHERE rym_lookup_field.lookup_field_obj = ttrym_lookup_field.lookup_field_obj
           NO-ERROR.
    IF AVAILABLE rym_lookup_field THEN ASSIGN dObj = rym_lookup_field.lookup_field_obj.
    ELSE ASSIGN dObj = 0.
    BUFFER-COPY ttrym_lookup_field TO rym_lookup_field.
    IF AVAILABLE rym_lookup_field AND dObj <> 0 AND dObj <> rym_lookup_field.lookup_field_obj  THEN
    DO:
      OUTPUT STREAM sOut1 TO VALUE(REPLACE(cFullFile,".d":U,".e":U)) APPEND.
      PUT UNFORMATTED STRING(TODAY) + " ":U + STRING(TIME,"hh:mm":U) + " old rym_lookup_field.lookup_field_obj = " + STRING(dObj) + " new rym_lookup_field.lookup_field_obj = " + STRING(rym_lookup_field.lookup_field_obj).      
      OUTPUT STREAM sOut1 CLOSE.
    END.
    RELEASE rym_lookup_field NO-ERROR.
    DELETE ttrym_lookup_field NO-ERROR.
  END.
  IF cFullFile <> ? THEN INPUT STREAM sImport CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadRYMWB) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadRYMWB Procedure 
PROCEDURE loadRYMWB :
/*------------------------------------------------------------------------------
  Purpose:     load rym_wizard_brow
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE dObj                  AS DECIMAL    NO-UNDO.

  ASSIGN cFullFile = SEARCH('icf_dbdata/rymwb.d').
  IF cFullFile <> ? THEN INPUT STREAM sImport FROM VALUE(cFullFile).
  IF cFullFile <> ? THEN
  REPEAT:
    CREATE ttrym_wizard_brow NO-ERROR.
    IMPORT STREAM sImport ttrym_wizard_brow NO-ERROR.
    /* ignore blanks or duff data */
    IF ttrym_wizard_brow.wizard_brow_obj = 0 THEN
    DO:
      DELETE ttrym_wizard_brow NO-ERROR.
      NEXT.
    END.
    FIND FIRST rym_wizard_brow EXCLUSIVE-LOCK
         WHERE rym_wizard_brow.object_name = ttrym_wizard_brow.object_name
         NO-ERROR.
    IF NOT AVAILABLE rym_wizard_brow THEN
      FIND FIRST rym_wizard_brow EXCLUSIVE-LOCK
           WHERE rym_wizard_brow.wizard_brow_obj = ttrym_wizard_brow.wizard_brow_obj
           NO-ERROR.
    IF AVAILABLE rym_wizard_brow THEN ASSIGN dObj = rym_wizard_brow.wizard_brow_obj.
    ELSE ASSIGN dObj = 0.
    BUFFER-COPY ttrym_wizard_brow TO rym_wizard_brow.
    IF AVAILABLE rym_wizard_brow AND dObj <> 0 AND dObj <> rym_wizard_brow.wizard_brow_obj  THEN
    DO:
      OUTPUT STREAM sOut1 TO VALUE(REPLACE(cFullFile,".d":U,".e":U)) APPEND.
      PUT UNFORMATTED STRING(TODAY) + " ":U + STRING(TIME,"hh:mm":U) + " old rym_wizard_brow.wizard_brow_obj = " + STRING(dObj) + " new rym_wizard_brow.wizard_brow_obj = " + STRING(rym_wizard_brow.wizard_brow_obj).      
      OUTPUT STREAM sOut1 CLOSE.
    END.
    RELEASE rym_wizard_brow NO-ERROR.
    DELETE ttrym_wizard_brow NO-ERROR.
  END.
  IF cFullFile <> ? THEN INPUT STREAM sImport CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadRYMWF) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadRYMWF Procedure 
PROCEDURE loadRYMWF :
/*------------------------------------------------------------------------------
  Purpose:     load rym_wizard_fold
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE dObj                  AS DECIMAL    NO-UNDO.

  ASSIGN cFullFile = SEARCH('icf_dbdata/rymwf.d').
  IF cFullFile <> ? THEN INPUT STREAM sImport FROM VALUE(cFullFile).
  IF cFullFile <> ? THEN
  REPEAT:
    CREATE ttrym_wizard_fold NO-ERROR.
    IMPORT STREAM sImport ttrym_wizard_fold NO-ERROR.
    /* ignore blanks or duff data */
    IF ttrym_wizard_fold.wizard_fold_obj = 0 THEN
    DO:
      DELETE ttrym_wizard_fold NO-ERROR.
      NEXT.
    END.
    FIND FIRST rym_wizard_fold EXCLUSIVE-LOCK
         WHERE rym_wizard_fold.object_name = ttrym_wizard_fold.object_name
         NO-ERROR.
    IF NOT AVAILABLE rym_wizard_fold THEN
      FIND FIRST rym_wizard_fold EXCLUSIVE-LOCK
           WHERE rym_wizard_fold.wizard_fold_obj = ttrym_wizard_fold.wizard_fold_obj
           NO-ERROR.
    IF AVAILABLE rym_wizard_fold THEN ASSIGN dObj = rym_wizard_fold.wizard_fold_obj.
    ELSE ASSIGN dObj = 0.
    BUFFER-COPY ttrym_wizard_fold TO rym_wizard_fold.
    IF AVAILABLE rym_wizard_fold AND dObj <> 0 AND dObj <> rym_wizard_fold.wizard_fold_obj  THEN
    DO:
      OUTPUT STREAM sOut1 TO VALUE(REPLACE(cFullFile,".d":U,".e":U)) APPEND.
      PUT UNFORMATTED STRING(TODAY) + " ":U + STRING(TIME,"hh:mm":U) + " old rym_wizard_fold.wizard_fold_obj = " + STRING(dObj) + " new rym_wizard_fold.wizard_fold_obj = " + STRING(rym_wizard_fold.wizard_fold_obj).      
      OUTPUT STREAM sOut1 CLOSE.
    END.
    RELEASE rym_wizard_fold NO-ERROR.
    DELETE ttrym_wizard_fold NO-ERROR.
  END.
  IF cFullFile <> ? THEN INPUT STREAM sImport CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadRYMWM) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadRYMWM Procedure 
PROCEDURE loadRYMWM :
/*------------------------------------------------------------------------------
  Purpose:     load rym_wizard_menc
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE dObj                  AS DECIMAL    NO-UNDO.

  ASSIGN cFullFile = SEARCH('icf_dbdata/rymwm.d').
  IF cFullFile <> ? THEN INPUT STREAM sImport FROM VALUE(cFullFile).
  IF cFullFile <> ? THEN
  REPEAT:
    CREATE ttrym_wizard_menc NO-ERROR.
    IMPORT STREAM sImport ttrym_wizard_menc NO-ERROR.
    /* ignore blanks or duff data */
    IF ttrym_wizard_menc.wizard_menc_obj = 0 THEN
    DO:
      DELETE ttrym_wizard_menc NO-ERROR.
      NEXT.
    END.
    FIND FIRST rym_wizard_menc EXCLUSIVE-LOCK
         WHERE rym_wizard_menc.object_name = ttrym_wizard_menc.object_name
         NO-ERROR.
    IF NOT AVAILABLE rym_wizard_menc THEN
      FIND FIRST rym_wizard_menc EXCLUSIVE-LOCK
           WHERE rym_wizard_menc.wizard_menc_obj = ttrym_wizard_menc.wizard_menc_obj
           NO-ERROR.
    IF AVAILABLE rym_wizard_menc THEN ASSIGN dObj = rym_wizard_menc.wizard_menc_obj.
    ELSE ASSIGN dObj = 0.
    BUFFER-COPY ttrym_wizard_menc TO rym_wizard_menc.
    IF AVAILABLE rym_wizard_menc AND dObj <> 0 AND dObj <> rym_wizard_menc.wizard_menc_obj  THEN
    DO:
      OUTPUT STREAM sOut1 TO VALUE(REPLACE(cFullFile,".d":U,".e":U)) APPEND.
      PUT UNFORMATTED STRING(TODAY) + " ":U + STRING(TIME,"hh:mm":U) + " old rym_wizard_menc.wizard_menc_obj = " + STRING(dObj) + " new rym_wizard_menc.wizard_menc_obj = " + STRING(rym_wizard_menc.wizard_menc_obj).      
      OUTPUT STREAM sOut1 CLOSE.
    END.
    RELEASE rym_wizard_menc NO-ERROR.
    DELETE ttrym_wizard_menc NO-ERROR.
  END.
  IF cFullFile <> ? THEN INPUT STREAM sImport CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadRYMWO) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadRYMWO Procedure 
PROCEDURE loadRYMWO :
/*------------------------------------------------------------------------------
  Purpose:     load rym_wizard_objc
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE dObj                  AS DECIMAL    NO-UNDO.

  ASSIGN cFullFile = SEARCH('icf_dbdata/rymwo.d').
  IF cFullFile <> ? THEN INPUT STREAM sImport FROM VALUE(cFullFile).
  IF cFullFile <> ? THEN
  REPEAT:
    CREATE ttrym_wizard_objc NO-ERROR.
    IMPORT STREAM sImport ttrym_wizard_objc NO-ERROR.
    /* ignore blanks or duff data */
    IF ttrym_wizard_objc.wizard_objc_obj = 0 THEN
    DO:
      DELETE ttrym_wizard_objc NO-ERROR.
      NEXT.
    END.
    FIND FIRST rym_wizard_objc EXCLUSIVE-LOCK
         WHERE rym_wizard_objc.object_name = ttrym_wizard_objc.object_name
         NO-ERROR.
    IF NOT AVAILABLE rym_wizard_objc THEN
      FIND FIRST rym_wizard_objc EXCLUSIVE-LOCK
           WHERE rym_wizard_objc.wizard_objc_obj = ttrym_wizard_objc.wizard_objc_obj
           NO-ERROR.
    IF AVAILABLE rym_wizard_objc THEN ASSIGN dObj = rym_wizard_objc.wizard_objc_obj.
    ELSE ASSIGN dObj = 0.
    BUFFER-COPY ttrym_wizard_objc TO rym_wizard_objc.
    IF AVAILABLE rym_wizard_objc AND dObj <> 0 AND dObj <> rym_wizard_objc.wizard_objc_obj  THEN
    DO:
      OUTPUT STREAM sOut1 TO VALUE(REPLACE(cFullFile,".d":U,".e":U)) APPEND.
      PUT UNFORMATTED STRING(TODAY) + " ":U + STRING(TIME,"hh:mm":U) + " old rym_wizard_objc.wizard_objc_obj = " + STRING(dObj) + " new rym_wizard_objc.wizard_objc_obj = " + STRING(rym_wizard_objc.wizard_objc_obj).      
      OUTPUT STREAM sOut1 CLOSE.
    END.
    RELEASE rym_wizard_objc NO-ERROR.
    DELETE ttrym_wizard_objc NO-ERROR.
  END.
  IF cFullFile <> ? THEN INPUT STREAM sImport CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadRYMWV) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadRYMWV Procedure 
PROCEDURE loadRYMWV :
/*------------------------------------------------------------------------------
  Purpose:     load rym_wizard_view
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE dObj                  AS DECIMAL    NO-UNDO.

  ASSIGN cFullFile = SEARCH('icf_dbdata/rymwv.d').
  IF cFullFile <> ? THEN INPUT STREAM sImport FROM VALUE(cFullFile).
  IF cFullFile <> ? THEN
  REPEAT:
    CREATE ttrym_wizard_view NO-ERROR.
    IMPORT STREAM sImport ttrym_wizard_view NO-ERROR.
    /* ignore blanks or duff data */
    IF ttrym_wizard_view.wizard_view_obj = 0 THEN
    DO:
      DELETE ttrym_wizard_view NO-ERROR.
      NEXT.
    END.
    FIND FIRST rym_wizard_view EXCLUSIVE-LOCK
         WHERE rym_wizard_view.object_name = ttrym_wizard_view.object_name
         NO-ERROR.
    IF NOT AVAILABLE rym_wizard_view THEN
      FIND FIRST rym_wizard_view EXCLUSIVE-LOCK
           WHERE rym_wizard_view.wizard_view_obj = ttrym_wizard_view.wizard_view_obj
           NO-ERROR.
    IF AVAILABLE rym_wizard_view THEN ASSIGN dObj = rym_wizard_view.wizard_view_obj.
    ELSE ASSIGN dObj = 0.
    BUFFER-COPY ttrym_wizard_view TO rym_wizard_view.
    IF AVAILABLE rym_wizard_view AND dObj <> 0 AND dObj <> rym_wizard_view.wizard_view_obj  THEN
    DO:
      OUTPUT STREAM sOut1 TO VALUE(REPLACE(cFullFile,".d":U,".e":U)) APPEND.
      PUT UNFORMATTED STRING(TODAY) + " ":U + STRING(TIME,"hh:mm":U) + " old rym_wizard_view.wizard_view_obj = " + STRING(dObj) + " new rym_wizard_view.wizard_view_obj = " + STRING(rym_wizard_view.wizard_view_obj).      
      OUTPUT STREAM sOut1 CLOSE.
    END.
    RELEASE rym_wizard_view NO-ERROR.
    DELETE ttrym_wizard_view NO-ERROR.
  END.
  IF cFullFile <> ? THEN INPUT STREAM sImport CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

