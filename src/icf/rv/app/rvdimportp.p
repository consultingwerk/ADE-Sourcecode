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
  File: rvdimportp.p

  Description:  Version Data Import Procedure
  
  Purpose:      Version Data Import Procedure

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        7287   UserRef:    
                Date:   14/12/2000  Author:     Anthony Swindells

  Update Notes: Fix deployments and imports

  (v:010001)    Task:        7336   UserRef:    
                Date:   18/12/2000  Author:     Anthony Swindells

  Update Notes: Fix deployment package issues

  (v:010002)    Task:        7361   UserRef:    
                Date:   20/12/2000  Author:     Anthony Swindells

  Update Notes: Allow product module changes in RV and track changes

  (v:010003)    Task:        7403   UserRef:    
                Date:   27/12/2000  Author:     Anthony Swindells

  Update Notes: Fix import issues - add extra error handling and duplicate handling to deployments

  (v:010004)    Task:        7435   UserRef:    
                Date:   02/01/2001  Author:     Anthony Swindells

  Update Notes: Fix import issues

  (v:010005)    Task:        7811   UserRef:    
                Date:   02/02/2001  Author:     Anthony Swindells

  Update Notes: Enhance Deployment load programs to be more resiliant to changes in data.
                When looking for AK, if not found alos check for obj before creating a new
                one, to cope with code field changing.
                In RY imports, for every rycso imported, first delete data from all other related
                tables to avoid conflicts in import - especially if object is deleted and
                recreated in wizards.

----------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       rvdimportp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010001


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

DEFINE TEMP-TABLE ttrvc_configuration_type NO-UNDO LIKE rvc_configuration_type.
DEFINE TEMP-TABLE ttrvm_workspace NO-UNDO LIKE rvm_workspace.
DEFINE TEMP-TABLE ttrvm_workspace_module NO-UNDO LIKE rvm_workspace_module.
DEFINE TEMP-TABLE ttrvm_configuration_item NO-UNDO LIKE rvm_configuration_item.
DEFINE TEMP-TABLE ttrvm_workspace_item NO-UNDO LIKE rvm_workspace_item.
DEFINE TEMP-TABLE ttrvt_item_version NO-UNDO LIKE rvt_item_version.

DISABLE TRIGGERS FOR LOAD OF rvc_configuration_type.
DISABLE TRIGGERS FOR LOAD OF rvm_workspace.
DISABLE TRIGGERS FOR LOAD OF rvm_workspace_module.
DISABLE TRIGGERS FOR LOAD OF rvm_configuration_item.
DISABLE TRIGGERS FOR LOAD OF rvm_workspace_item.
DISABLE TRIGGERS FOR LOAD OF rvt_item_version.

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

IF CONNECTED('rvdb') THEN
DO:
  
  RUN loadRVCCT.  /* rvc_configuration_type */
  RUN loadRVMWS.  /* rvm_workspace */
  RUN loadRVMWM.  /* rvm_workspace_module */
  RUN loadRVMCI.  /* rvm_configuration_item */
  RUN loadRVMWI.  /* rvm_workspace_item */
  RUN loadRVTIV.  /* rvt_item_version */

END. /* connected RYDB */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-loadRVCCT) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadRVCCT Procedure 
PROCEDURE loadRVCCT :
/*------------------------------------------------------------------------------
  Purpose:     rvc_configuration_type
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
  DEFINE VARIABLE dObj                  AS DECIMAL    NO-UNDO.

  ASSIGN cFullFile = SEARCH('icf_dbdata/rvcct.d').
  IF cFullFile <> ? THEN INPUT STREAM sImport FROM VALUE(cFullFile).
  IF cFullFile <> ? THEN
  REPEAT:
    CREATE ttrvc_configuration_type NO-ERROR.
    IMPORT STREAM sImport ttrvc_configuration_type NO-ERROR.
    /* ignore blanks or duff data */
    IF ttrvc_configuration_type.configuration_type_obj = 0 THEN
    DO:
      DELETE ttrvc_configuration_type NO-ERROR.
      NEXT.
    END.
    FIND FIRST rvc_configuration_type EXCLUSIVE-LOCK
         WHERE rvc_configuration_type.configuration_type = ttrvc_configuration_type.configuration_type
         NO-ERROR.
    IF NOT AVAILABLE rvc_configuration_type THEN
      FIND FIRST rvc_configuration_type EXCLUSIVE-LOCK
           WHERE rvc_configuration_type.configuration_type_obj = ttrvc_configuration_type.configuration_type_obj
           NO-ERROR.
    IF AVAILABLE rvc_configuration_type THEN ASSIGN dObj = rvc_configuration_type.configuration_type_obj.
    ELSE ASSIGN dObj = 0.
    BUFFER-COPY ttrvc_configuration_type TO rvc_configuration_type.
    IF AVAILABLE rvc_configuration_type AND dObj <> 0 AND dObj <> rvc_configuration_type.configuration_type_obj  THEN
    DO:
      OUTPUT STREAM sOut1 TO VALUE(REPLACE(cFullFile,".d":U,".e":U)) APPEND.
      PUT UNFORMATTED STRING(TODAY) + " ":U + STRING(TIME,"hh:mm":U) + " old rvc_configuration_type.configuration_type_obj = " + STRING(dObj) + " new rvc_configuration_type.configuration_type_obj = " + STRING(rvc_configuration_type.configuration_type_obj).      
      OUTPUT STREAM sOut1 CLOSE.
    END.
    RELEASE rvc_configuration_type NO-ERROR.
    DELETE ttrvc_configuration_type NO-ERROR.
  END.
  IF cFullFile <> ? THEN INPUT STREAM sImport CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadRVMCI) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadRVMCI Procedure 
PROCEDURE loadRVMCI :
/*------------------------------------------------------------------------------
  Purpose:     rvm_configuration_item
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE dObj                  AS DECIMAL    NO-UNDO.
  
  ASSIGN cFullFile = SEARCH('icf_dbdata/rvmci.d').
  IF cFullFile <> ? THEN INPUT STREAM sImport FROM VALUE(cFullFile).
  IF cFullFile <> ? THEN
  REPEAT:
    CREATE ttrvm_configuration_item NO-ERROR.
    IMPORT STREAM sImport ttrvm_configuration_item NO-ERROR.
    /* ignore blanks or duff data */
    IF ttrvm_configuration_item.configuration_item_obj = 0 THEN
    DO:
      DELETE ttrvm_configuration_item NO-ERROR.
      NEXT.
    END.
    FIND FIRST rvm_configuration_item EXCLUSIVE-LOCK
         WHERE rvm_configuration_item.configuration_type = ttrvm_configuration_item.configuration_type
           AND rvm_configuration_item.scm_object_name = ttrvm_configuration_item.scm_object_name
           AND rvm_configuration_item.product_module_obj = ttrvm_configuration_item.product_module_obj
         NO-ERROR.
    IF NOT AVAILABLE rvm_configuration_item THEN
      FIND FIRST rvm_configuration_item EXCLUSIVE-LOCK
           WHERE rvm_configuration_item.configuration_item_obj = ttrvm_configuration_item.configuration_item_obj
           NO-ERROR.
    IF AVAILABLE rvm_configuration_item THEN ASSIGN dObj = rvm_configuration_item.configuration_item_obj.
    ELSE ASSIGN dObj = 0.
    BUFFER-COPY ttrvm_configuration_item TO rvm_configuration_item.
    IF AVAILABLE rvm_configuration_item AND dObj <> 0 AND dObj <> rvm_configuration_item.configuration_item_obj  THEN
    DO:
      OUTPUT STREAM sOut1 TO VALUE(REPLACE(cFullFile,".d":U,".e":U)) APPEND.
      PUT UNFORMATTED STRING(TODAY) + " ":U + STRING(TIME,"hh:mm":U) + " old rvm_configuration_item.configuration_item_obj = " + STRING(dObj) + " new rvm_configuration_item.configuration_item_obj = " + STRING(rvm_configuration_item.configuration_item_obj).      
      OUTPUT STREAM sOut1 CLOSE.
    END.
    RELEASE rvm_configuration_item NO-ERROR.
    DELETE ttrvm_configuration_item NO-ERROR.
  END.
  IF cFullFile <> ? THEN INPUT STREAM sImport CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadRVMWI) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadRVMWI Procedure 
PROCEDURE loadRVMWI :
/*------------------------------------------------------------------------------
  Purpose:     rvm_workspace_item
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dObj                  AS DECIMAL    NO-UNDO.

  ASSIGN cFullFile = SEARCH('icf_dbdata/rvmwi.d').
  IF cFullFile <> ? THEN INPUT STREAM sImport FROM VALUE(cFullFile).
  IF cFullFile <> ? THEN
  REPEAT:
    CREATE ttrvm_workspace_item NO-ERROR.
    IMPORT STREAM sImport ttrvm_workspace_item NO-ERROR.
    /* ignore blanks or duff data */
    IF ttrvm_workspace_item.workspace_item_obj = 0 THEN
    DO:
      DELETE ttrvm_workspace_item NO-ERROR.
      NEXT.
    END.
    FIND FIRST rvm_workspace_item EXCLUSIVE-LOCK
         WHERE rvm_workspace_item.workspace_obj = ttrvm_workspace_item.workspace_obj
           AND rvm_workspace_item.configuration_type = ttrvm_workspace_item.configuration_type
           AND rvm_workspace_item.scm_object_name = ttrvm_workspace_item.scm_object_name
         NO-ERROR.
    IF NOT AVAILABLE rvm_workspace_item THEN
      FIND FIRST rvm_workspace_item EXCLUSIVE-LOCK
           WHERE rvm_workspace_item.workspace_item_obj = ttrvm_workspace_item.workspace_item_obj
           NO-ERROR.
    IF AVAILABLE rvm_workspace_item THEN ASSIGN dObj = rvm_workspace_item.workspace_item_obj.
    ELSE ASSIGN dObj = 0.
    BUFFER-COPY ttrvm_workspace_item TO rvm_workspace_item.
    IF AVAILABLE rvm_workspace_item AND dObj <> 0 AND dObj <> rvm_workspace_item.workspace_item_obj  THEN
    DO:
      OUTPUT STREAM sOut1 TO VALUE(REPLACE(cFullFile,".d":U,".e":U)) APPEND.
      PUT UNFORMATTED STRING(TODAY) + " ":U + STRING(TIME,"hh:mm":U) + " old rvm_workspace_item.workspace_item_obj = " + STRING(dObj) + " new rvm_workspace_item.workspace_item_obj = " + STRING(rvm_workspace_item.workspace_item_obj).      
      OUTPUT STREAM sOut1 CLOSE.
    END.
    RELEASE rvm_workspace_item NO-ERROR.
    DELETE ttrvm_workspace_item NO-ERROR.
  END.
  IF cFullFile <> ? THEN INPUT STREAM sImport CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadRVMWM) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadRVMWM Procedure 
PROCEDURE loadRVMWM :
/*------------------------------------------------------------------------------
  Purpose:     rvm_workspace_module
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dObj                  AS DECIMAL    NO-UNDO.

  ASSIGN cFullFile = SEARCH('icf_dbdata/rvmwm.d').
  IF cFullFile <> ? THEN INPUT STREAM sImport FROM VALUE(cFullFile).
  IF cFullFile <> ? THEN
  REPEAT:
    CREATE ttrvm_workspace_module NO-ERROR.
    IMPORT STREAM sImport ttrvm_workspace_module NO-ERROR.
    /* ignore blanks or duff data */
    IF ttrvm_workspace_module.workspace_module_obj = 0 THEN
    DO:
      DELETE ttrvm_workspace_module NO-ERROR.
      NEXT.
    END.
    FIND FIRST rvm_workspace_module EXCLUSIVE-LOCK
         WHERE rvm_workspace_module.workspace_obj = ttrvm_workspace_module.workspace_obj
           AND rvm_workspace_module.product_module_obj = ttrvm_workspace_module.product_module_obj
         NO-ERROR.
    IF NOT AVAILABLE rvm_workspace_module THEN
      FIND FIRST rvm_workspace_module EXCLUSIVE-LOCK
           WHERE rvm_workspace_module.workspace_module_obj = ttrvm_workspace_module.workspace_module_obj
           NO-ERROR.
    IF AVAILABLE rvm_workspace_module THEN ASSIGN dObj = rvm_workspace_module.workspace_module_obj.
    ELSE ASSIGN dObj = 0.
    BUFFER-COPY ttrvm_workspace_module TO rvm_workspace_module.
    IF AVAILABLE rvm_workspace_module AND dObj <> 0 AND dObj <> rvm_workspace_module.workspace_module_obj  THEN
    DO:
      OUTPUT STREAM sOut1 TO VALUE(REPLACE(cFullFile,".d":U,".e":U)) APPEND.
      PUT UNFORMATTED STRING(TODAY) + " ":U + STRING(TIME,"hh:mm":U) + " old rvm_workspace_module.workspace_module_obj = " + STRING(dObj) + " new rvm_workspace_module.workspace_module_obj = " + STRING(rvm_workspace_module.workspace_module_obj).      
      OUTPUT STREAM sOut1 CLOSE.
    END.
    RELEASE rvm_workspace_module NO-ERROR.
    DELETE ttrvm_workspace_module NO-ERROR.
  END.
  IF cFullFile <> ? THEN INPUT STREAM sImport CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadRVMWS) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadRVMWS Procedure 
PROCEDURE loadRVMWS :
/*------------------------------------------------------------------------------
  Purpose:     rvm_workspace
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dObj                  AS DECIMAL    NO-UNDO.

  ASSIGN cFullFile = SEARCH('icf_dbdata/rvmws.d').
  IF cFullFile <> ? THEN INPUT STREAM sImport FROM VALUE(cFullFile).
  IF cFullFile <> ? THEN
  REPEAT:
    CREATE ttrvm_workspace NO-ERROR.
    IMPORT STREAM sImport ttrvm_workspace NO-ERROR.
    /* ignore blanks or duff data */
    IF ttrvm_workspace.workspace_obj = 0 THEN
    DO:
      DELETE ttrvm_workspace NO-ERROR.
      NEXT.
    END.
    FIND FIRST rvm_workspace EXCLUSIVE-LOCK
         WHERE rvm_workspace.workspace_code = ttrvm_workspace.workspace_code
         NO-ERROR.
    IF NOT AVAILABLE rvm_workspace THEN
      FIND FIRST rvm_workspace EXCLUSIVE-LOCK
           WHERE rvm_workspace.workspace_obj = ttrvm_workspace.workspace_obj
           NO-ERROR.
    IF AVAILABLE rvm_workspace THEN ASSIGN dObj = rvm_workspace.workspace_obj.
    ELSE ASSIGN dObj = 0.
    BUFFER-COPY ttrvm_workspace TO rvm_workspace.
    IF AVAILABLE rvm_workspace AND dObj <> 0 AND dObj <> rvm_workspace.workspace_obj  THEN
    DO:
      OUTPUT STREAM sOut1 TO VALUE(REPLACE(cFullFile,".d":U,".e":U)) APPEND.
      PUT UNFORMATTED STRING(TODAY) + " ":U + STRING(TIME,"hh:mm":U) + " old rvm_workspace.workspace_obj = " + STRING(dObj) + " new rvm_workspace.workspace_obj = " + STRING(rvm_workspace.workspace_obj).      
      OUTPUT STREAM sOut1 CLOSE.
    END.
    RELEASE rvm_workspace NO-ERROR.
    DELETE ttrvm_workspace NO-ERROR.
  END.
  IF cFullFile <> ? THEN INPUT STREAM sImport CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadRVTIV) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadRVTIV Procedure 
PROCEDURE loadRVTIV :
/*------------------------------------------------------------------------------
  Purpose:     rvt_item_version
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dObj                  AS DECIMAL    NO-UNDO.

  ASSIGN cFullFile = SEARCH('icf_dbdata/rvtiv.d').
  IF cFullFile <> ? THEN INPUT STREAM sImport FROM VALUE(cFullFile).
  IF cFullFile <> ? THEN
  REPEAT:
    CREATE ttrvt_item_version NO-ERROR.
    IMPORT STREAM sImport ttrvt_item_version NO-ERROR.
    /* ignore blanks or duff data */
    IF ttrvt_item_version.item_version_obj = 0 THEN
    DO:
      DELETE ttrvt_item_version NO-ERROR.
      NEXT.
    END.
    FIND FIRST rvt_item_version EXCLUSIVE-LOCK
         WHERE rvt_item_version.configuration_type = ttrvt_item_version.configuration_type
           AND rvt_item_version.scm_object_name = ttrvt_item_version.scm_object_name
           AND rvt_item_version.product_module_obj = ttrvt_item_version.product_module_obj
           AND rvt_item_version.ITEM_version_number = ttrvt_item_version.ITEM_version_number
         NO-ERROR.
    IF NOT AVAILABLE rvt_item_version THEN
      FIND FIRST rvt_item_version EXCLUSIVE-LOCK
           WHERE rvt_item_version.item_version_obj = ttrvt_item_version.item_version_obj
           NO-ERROR.
    IF AVAILABLE rvt_item_version THEN ASSIGN dObj = rvt_item_version.item_version_obj.
    ELSE ASSIGN dObj = 0.
    BUFFER-COPY ttrvt_item_version TO rvt_item_version.
    IF AVAILABLE rvt_item_version AND dObj <> 0 AND dObj <> rvt_item_version.item_version_obj  THEN
    DO:
      OUTPUT STREAM sOut1 TO VALUE(REPLACE(cFullFile,".d":U,".e":U)) APPEND.
      PUT UNFORMATTED STRING(TODAY) + " ":U + STRING(TIME,"hh:mm":U) + " old rvt_item_version.item_version_obj = " + STRING(dObj) + " new rvt_item_version.item_version_obj = " + STRING(rvt_item_version.item_version_obj).      
      OUTPUT STREAM sOut1 CLOSE.
    END.
    
    RELEASE rvt_item_version NO-ERROR.
    DELETE ttrvt_item_version NO-ERROR.
  END.
  IF cFullFile <> ? THEN INPUT STREAM sImport CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

