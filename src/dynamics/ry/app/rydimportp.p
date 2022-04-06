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
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
&scop object-version    000000


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

DEFINE TEMP-TABLE ttryc_attribute NO-UNDO LIKE ryc_attribute.
DEFINE TEMP-TABLE ttryc_attribute_group NO-UNDO LIKE ryc_attribute_group.
DEFINE TEMP-TABLE ttryc_layout NO-UNDO LIKE ryc_layout.
DEFINE TEMP-TABLE ttryc_smartlink_type NO-UNDO LIKE ryc_smartlink_type.
DEFINE TEMP-TABLE ttryc_supported_link NO-UNDO LIKE ryc_supported_link.
DEFINE TEMP-TABLE ttgsc_object_type NO-UNDO LIKE gsc_object_type.
DEFINE TEMP-TABLE ttgsc_product NO-UNDO LIKE gsc_product.
DEFINE TEMP-TABLE ttgsc_product_module NO-UNDO LIKE gsc_product_module.

DEFINE TEMP-TABLE ttryc_smartobject NO-UNDO LIKE ryc_smartobject.
DEFINE TEMP-TABLE ttryc_object_instance NO-UNDO LIKE ryc_object_instance.
DEFINE TEMP-TABLE ttryc_page NO-UNDO LIKE ryc_page.
DEFINE TEMP-TABLE ttryc_smartlink NO-UNDO LIKE ryc_smartlink.
DEFINE TEMP-TABLE ttryc_attribute_value NO-UNDO LIKE ryc_attribute_value.
DEFINE TEMP-TABLE ttrym_data_version NO-UNDO LIKE rym_data_version.

DISABLE TRIGGERS FOR LOAD OF ryc_attribute.
DISABLE TRIGGERS FOR LOAD OF ryc_attribute_group.
DISABLE TRIGGERS FOR LOAD OF ryc_layout.
DISABLE TRIGGERS FOR LOAD OF ryc_smartlink_type.
DISABLE TRIGGERS FOR LOAD OF ryc_supported_link.
DISABLE TRIGGERS FOR LOAD OF gsc_object_type.
DISABLE TRIGGERS FOR LOAD OF gsc_product.
DISABLE TRIGGERS FOR LOAD OF gsc_product_module.

DISABLE TRIGGERS FOR LOAD OF ryc_smartobject.
DISABLE TRIGGERS FOR LOAD OF ryc_object_instance.
DISABLE TRIGGERS FOR LOAD OF ryc_page.
DISABLE TRIGGERS FOR LOAD OF ryc_smartlink.
DISABLE TRIGGERS FOR LOAD OF ryc_attribute_value.
DISABLE TRIGGERS FOR LOAD OF rym_data_version.

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
  RUN loadRYCSM.  /* ryc_smartlink */
  RUN loadRYCSF.  /* ryc_smartobject_field */
  RUN loadRYCCT.  /* ryc_custom_ui_trigger */
  RUN loadRYCAV.  /* ryc_attribute_value */
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

FOR EACH ryc_smartlink EXCLUSIVE-LOCK
   WHERE ryc_smartlink.container_smartobject_obj = pdSmartObjectObj:
  DELETE ryc_smartlink.
END.

FOR EACH ryc_attribute_value EXCLUSIVE-LOCK
   WHERE ryc_attribute_value.primary_smartobject_obj = pdSmartObjectObj:
  DELETE ryc_attribute_value.
END.

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

