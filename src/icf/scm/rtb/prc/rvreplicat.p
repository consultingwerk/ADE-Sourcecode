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
  File: rvreplicat.p

  Description:  SCM Replication Trigger Code
  
  Purpose:      This procedure is called from replication triggers for SCM control. It is used
                to do all SCM  checks such as whether the object is checked out in a valid
                task, etc.
                These hooks can be disabled if no SCM is being used, either by
                disconnecting the RVDB database or setting the flag on the security
                control table that disables all SCM checks - i.e. this file.

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        5461   UserRef:    astra2
                Date:   17/04/2000  Author:     Anthony Swindells

  Update Notes: Created from Template aftemprocp.p

  (v:010001)    Task:        5512   UserRef:    
                Date:   19/04/2000  Author:     Robin Roos

  Update Notes: Create a new parameter which indicates whether the record is NEW.  Use this to implement CREATE behaviour for Write of a New recodr.  At Create time, not all of the information necessary for creating an entry in roundtable is available.  By the time the Write occurs we presume that this info is available.

  (v:010002)    Task:    90000097   UserRef:    
                Date:   30/04/2001  Author:     Anthony Swindells

  Update Notes: Change code to rather work with new XML mechanism and remove use
                of transaction and action tables.

  (v:010003)    Task:    90000177   UserRef:    
                Date:   07/27/2001  Author:     Pieter J Meyer

  Update Notes: XML Hooks

-----------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

{af/sup2/afglobals.i}

/* Define RTB global shared variables - used for RTB integration hooks (if installed) */
DEFINE NEW GLOBAL SHARED VARIABLE grtb-wspace-id    AS CHARACTER    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE grtb-task-num     AS INTEGER      NO-UNDO.

&scop object-name       rvreplicat.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

DEFINE INPUT PARAMETER ip_table_buffer_handle   AS HANDLE       NO-UNDO.
DEFINE INPUT PARAMETER ip_old_buffer_handle     AS HANDLE       NO-UNDO.
DEFINE INPUT PARAMETER ip_table_name            AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER ip_table_fla             AS CHARACTER    NO-UNDO.  
DEFINE INPUT PARAMETER ip_table_pk_fields       AS CHARACTER    NO-UNDO.             
DEFINE INPUT PARAMETER ip_action                AS CHARACTER    NO-UNDO.   
DEFINE INPUT PARAMETER ip_new                   AS LOGICAL      NO-UNDO. 
DEFINE INPUT PARAMETER ip_primary_fla           AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER ip_primary_key_fields    AS CHARACTER    NO-UNDO.

DEFINE VARIABLE lv_workspace_obj                AS DECIMAL      NO-UNDO.
DEFINE VARIABLE lv_task_number                  AS INTEGER      NO-UNDO.

/*
DEFINE VARIABLE lv_site_number                  AS INTEGER      NO-UNDO.
*/

DEFINE VARIABLE lv_workspace_code               AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lv_creating_item                AS LOGICAL      NO-UNDO.
DEFINE VARIABLE lv_deleting_item                AS LOGICAL      NO-UNDO.
DEFINE VARIABLE lv_arguments                    AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lv_version_number               AS INTEGER      NO-UNDO.
DEFINE VARIABLE lv_transaction_id               AS INTEGER      NO-UNDO.
DEFINE VARIABLE lv_logical_db_name              AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lv_alias                        AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lv_inherited_modification_type  AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lv_object_name                  AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lv_nulls_in_primary_key         AS LOGICAL      NO-UNDO.

DEFINE BUFFER lb_previous_item_version  FOR rvt_item_version.
DEFINE BUFFER lb_new_item_version       FOR rvt_item_version.
DEFINE BUFFER lb_item_version           FOR rvt_item_version.
DEFINE BUFFER lb_gsc_object             FOR gsc_object.

&SCOPED-DEFINE VER-INCREMENT   010000
&SCOPED-DEFINE REV-INCREMENT   000100
&SCOPED-DEFINE PAT-INCREMENT   000001

DEFINE VARIABLE hScmTool        AS HANDLE NO-UNDO.

DEFINE VARIABLE lv_error_status AS LOGICAL NO-UNDO.
DEFINE VARIABLE lv_return_value AS CHARACTER NO-UNDO.


DEFINE VARIABLE lv_scm_object_exists                    AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lv_scm_object_exists_in_ws              AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lv_scm_version_in_workspace             AS INTEGER   NO-UNDO.
DEFINE VARIABLE lv_scm_checked_out_in_workspace         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lv_scm_version_task_number              AS INTEGER   NO-UNDO.
DEFINE VARIABLE lv_scm_highest_version                  AS INTEGER   NO-UNDO.

{af/sup2/afcheckerr.i &define-only = YES}

/* Database logical name for primary table */
DEFINE VARIABLE gcDBName                                AS CHARACTER  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-assignmentUnderway) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignmentUnderway Procedure 
FUNCTION assignmentUnderway RETURNS LOGICAL
  ( ip_remove AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deletionUnderway) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD deletionUnderway Procedure 
FUNCTION deletionUnderway RETURNS LOGICAL
  ( ip_remove AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFieldValue Procedure 
FUNCTION getFieldValue RETURNS CHARACTER
  ( ip_buffer_handle AS HANDLE,
    ip_description_fieldname AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQuotedFieldValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQuotedFieldValue Procedure 
FUNCTION getQuotedFieldValue RETURNS CHARACTER
  ( ip_buffer_handle AS HANDLE,
    ip_description_fieldname AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


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
         HEIGHT             = 29.24
         WIDTH              = 52.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* DO NOTHING IF NO RV or RTB CONNECTED */
IF NOT CONNECTED("RVDB":U) THEN RETURN.
/* DO NOTHING IF NO RTB CONNECTED */
IF NOT CONNECTED("RTB":U) THEN RETURN.

/* Check if SCM checks on */
FIND FIRST gsc_security_control NO-LOCK NO-ERROR.
IF AVAILABLE gsc_security_control
   AND gsc_security_control.scm_checks_on = NO THEN RETURN.

lv_arguments =  "TableName=" + ip_table_name +
                "TableFLa=" + ip_table_fla +
                "TablePkFields=" + ip_table_pk_fields +
                "Action=" + ip_action +
                "New=" + STRING(ip_new) +
                "PrimaryFla=" + ip_primary_fla +
                "PrimaryKeyFields=" + ip_primary_key_fields.

/* ignore CREATE actions - this work is done on WRITE NEW */

RUN fixTablePkFields.  /* remove extraneuous control characters put in there by ERwin */

/* is the configuration item being deleted as part of this transaction? */
    
IF deletionUnderway(FALSE) AND ip_table_fla <> ip_primary_fla THEN RETURN.    

/* create trigger does nothing */
IF ip_action = "CREATE" THEN 
DO:
    ASSIGN lv_return_value = lv_return_value NO-ERROR. /* clear error status */
    RETURN.    
END.

outer-block:
DO ON ERROR UNDO outer-block, RETURN RETURN-VALUE:
    RUN startPersistentProcs.
    IF RETURN-VALUE <> "":U THEN RETURN RETURN-VALUE.

    RUN doReplication NO-ERROR.
    lv_error_status = ERROR-STATUS:ERROR.
    lv_return_value = RETURN-VALUE.

    RUN stopPersistentProcs.

    IF lv_error_status 
        THEN RETURN ERROR lv_return_value.
        ELSE RETURN lv_return_value.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-changeProductModule) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changeProductModule Procedure 
PROCEDURE changeProductModule :
/*------------------------------------------------------------------------------
  Purpose:     To move object to new module - if not registered yet !
  Parameters:  input object name
               input old module obj
               input new module obj
  Notes:       Only of object does not exist in RTB already - i.e. it is a new
               logical object not registered yet.
               Called from determine object name for primary table if product
               module has actually changed.
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pcObjectName             AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER pdOldModuleObj           AS DECIMAL    NO-UNDO.
DEFINE INPUT PARAMETER pdNewModuleObj           AS DECIMAL    NO-UNDO.

DEFINE VARIABLE cErrorText                      AS CHARACTER  NO-UNDO.

FIND FIRST rvm_configuration_item NO-LOCK
     WHERE rvm_configuration_item.scm_object_name = pcObjectName
       AND rvm_configuration_item.product_module_obj = pdOldModuleObj
     NO-ERROR.

IF NOT AVAILABLE rvm_configuration_item
OR rvm_configuration_item.scm_registered = YES
THEN RETURN. /* SCM will do it */

FIND FIRST rvm_configuration_item NO-LOCK
     WHERE rvm_configuration_item.scm_object_name = pcObjectName
       AND rvm_configuration_item.product_module_obj = pdNewModuleObj
     NO-ERROR.
IF AVAILABLE rvm_configuration_item
THEN RETURN. /* SCM done it */

IF Grtb-wspace-id = "":U THEN RETURN.

FIND FIRST rvm_workspace NO-LOCK
     WHERE rvm_workspace.workspace_code = Grtb-wspace-id
     NO-ERROR.

IF NOT AVAILABLE rvm_workspace THEN RETURN.

/* need to fix product module on RV tables as this object is a new object not yet registered in SCM */

DEFINE BUFFER brvm_configuration_item FOR rvm_configuration_item.
DEFINE BUFFER brvt_item_version FOR rvt_item_version.
DEFINE BUFFER brvm_workspace_item FOR rvm_workspace_item.

tran-block:
DO FOR brvm_configuration_item, brvt_item_version, brvm_workspace_item
       TRANSACTION ON ERROR UNDO tran-block, LEAVE tran-block: 

  FIND FIRST brvm_configuration_item EXCLUSIVE-LOCK
       WHERE brvm_configuration_item.scm_object_name = pcObjectName
         AND brvm_configuration_item.product_module_obj = pdOldModuleObj
       NO-ERROR.
  IF NOT AVAILABLE brvm_configuration_item THEN
  DO:
    ASSIGN cErrorText = {af/sup2/aferrortxt.i 'AF' '29' '?' '?' "'Configuration Item Record'"}.
    UNDO tran-block, LEAVE tran-block.
  END.
  
  ASSIGN
    brvm_configuration_item.product_module_obj = pdNewModuleObj
    .
  VALIDATE brvm_configuration_item NO-ERROR.
  {af/sup2/afcheckerr.i &no-return = YES}    
  cErrorText = cMessageList.
  IF cErrorText <> "":U THEN UNDO tran-block, LEAVE tran-block.

  FIND FIRST brvt_item_version EXCLUSIVE-LOCK
       WHERE brvt_item_version.configuration_type = brvm_configuration_item.configuration_type
         AND brvt_item_version.scm_object_name = brvm_configuration_item.scm_object_name
         AND brvt_item_version.product_module_obj = pdOldModuleObj
         AND brvt_item_version.ITEM_version_number = 010000
       NO-ERROR.
  IF AVAILABLE brvt_item_version THEN
  DO:
    ASSIGN
      brvt_item_version.product_module_obj = pdNewModuleObj
      .
    VALIDATE brvt_item_version NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}    
    cErrorText = cMessageList.
    IF cErrorText <> "":U THEN UNDO tran-block, LEAVE tran-block.
  END.

  FIND FIRST brvm_workspace_item EXCLUSIVE-LOCK
       WHERE brvm_workspace_item.workspace_obj        = rvm_workspace.workspace_obj
         AND brvm_workspace_item.configuration_type   = brvm_configuration_item.configuration_type
         AND brvm_workspace_item.scm_object_name      = brvm_configuration_item.scm_object_name
         AND brvm_workspace_item.product_module_obj   = pdOldModuleObj
         AND brvm_workspace_item.ITEM_version_number  = 010000
       NO-ERROR.
  IF AVAILABLE brvm_workspace_item THEN
  DO:
    ASSIGN
      brvm_workspace_item.product_module_obj = pdNewModuleObj
      brvm_workspace_item.task_product_module_obj = pdNewModuleObj
      .
    VALIDATE brvm_workspace_item NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}    
    cErrorText = cMessageList.
    IF cErrorText <> "":U THEN UNDO tran-block, LEAVE tran-block.
  END.

END. /* tran-block */

RETURN cErrorText.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-checkOutItemIfRequired) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkOutItemIfRequired Procedure 
PROCEDURE checkOutItemIfRequired :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* is the item checked out */
    
    FIND FIRST rvt_workspace_checkout NO-LOCK
        WHERE rvt_workspace_checkout.workspace_obj = lv_workspace_obj
        AND   rvt_workspace_checkout.workspace_item_obj = rvm_workspace_item.workspace_item_obj
        AND   rvt_workspace_checkout.configuration_type = ip_primary_fla
        NO-ERROR.
    IF AVAILABLE(rvt_workspace_checkout) THEN
    DO:
        /* the item is checked out explicitly */
        IF rvt_workspace_checkout.task_number <> lv_task_number 
            THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '12' '?' '?' ip_primary_fla lv_object_name lv_task_number rvt_workspace_checkout.task_number lv_arguments}.
            
        /* this item is explicitly checked out */
    END.
    ELSE DO:
        /* this item is not explicitly checked out */
        
        /* check out this object */
        
        {af/sup/afvalidtrg.i &ACTION=CREATE &TABLE=rvt_workspace_checkout}.
        ASSIGN
            rvt_workspace_checkout.workspace_obj      = lv_workspace_obj
            rvt_workspace_checkout.task_number        = lv_task_number
            rvt_workspace_checkout.configuration_type = ip_primary_fla
            rvt_workspace_checkout.workspace_item_obj = rvm_workspace_item.workspace_item_obj
            rvt_workspace_checkout.modification_type  = "UNK" /*lv_inherited_modification_type */   /* use that for the generic Configuration Type or Workspace check out record */            
            .
        {af/sup/afvalidtrg.i &ACTION=VALIDATE &TABLE=rvt_workspace_checkout}       
        
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-clear-return-value) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clear-return-value Procedure 
PROCEDURE clear-return-value :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RETURN "".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createNewItemVersion) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createNewItemVersion Procedure 
PROCEDURE createNewItemVersion :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE lv_primary_key_values AS CHARACTER.    
DEFINE VARIABLE lv_idx AS INTEGER.
DEFINE VARIABLE cObjectExt AS CHARACTER NO-UNDO.
DEFINE VARIABLE cObjectName AS CHARACTER NO-UNDO.

    /* First Check assuming that extension is inc as part of object_filename */
    FIND FIRST lb_gsc_object NO-LOCK
         WHERE lb_gsc_object.OBJECT_filename = rvm_configuration_item.scm_object_name
         NO-ERROR.
    /* If not available, then check with object_extension field */
    IF NOT AVAILABLE lb_gsc_object THEN DO:
       IF R-INDEX(rvm_configuration_item.scm_object_name,".") > 0 THEN DO:
           cObjectExt = ENTRY(NUM-ENTRIES(rvm_configuration_item.scm_object_name,"."),rvm_configuration_item.scm_object_name,".").
           cObjectName = REPLACE(rvm_configuration_item.scm_object_name,("." + cObjectExt),"").
           IF cObjectExt <> "" THEN
               FIND FIRST lb_gsc_object NO-LOCK
                    WHERE lb_gsc_object.Object_filename = cObjectName AND
                          lb_gsc_object.Object_Extension = cObjectExt NO-ERROR. 
       END.
    END.

    IF lv_scm_object_exists THEN
    DO:
        /* the item exists in the SCM tool, and is checked out there, so it is the version in the SCM tool that we must create */
        lv_version_number = lv_scm_version_in_workspace.
    END.
    ELSE DO:
        /* now determine the "last" version number of this item - regardless of workspace */
        /* the code below requires a schema change to become more efficient */
        
        FIND LAST lb_item_version NO-LOCK
            WHERE lb_item_version.configuration_type = rvm_configuration_item.configuration_type
            AND   lb_item_version.scm_object_name  = rvm_configuration_item.scm_object_name
            AND   lb_item_version.product_module_obj  = rvm_configuration_item.product_module_obj
            USE-INDEX XAK1rvt_item_version
            NO-ERROR.
        lv_version_number = (IF AVAILABLE(lb_item_version) THEN lb_item_version.item_version_number ELSE 0). 
           
        /* create the new item version */
        
        lv_version_number = lv_version_number + {&VER-INCREMENT}. /* new creation of an item in a workspace is always VER */       
    END.
    
    
    IF NOT CAN-FIND(
        FIRST rvt_item_version 
        WHERE rvt_item_version.configuration_type  = rvm_configuration_item.configuration_type
        AND   rvt_item_version.scm_object_name   = rvm_configuration_item.scm_object_name
        AND   rvt_item_version.product_module_obj = rvm_configuration_item.product_module_obj
        AND   rvt_item_version.item_version_number = lv_version_number
        ) THEN
    DO:
        /* create the item version from scratch */    
        {af/sup/afvalidtrg.i &ACTION=CREATE &TABLE=rvt_item_version}
        ASSIGN 
            rvt_item_version.configuration_type  = rvm_configuration_item.configuration_type
            rvt_item_version.scm_object_name   = rvm_configuration_item.scm_object_name
            rvt_item_version.item_version_number = lv_version_number
            rvt_item_version.product_module_obj = rvm_configuration_item.product_module_obj
            rvt_item_version.task_number         = lv_task_number
                    
            /* this is a brand new item, therefor is a baseline */
            
            rvt_item_version.baseline_version_number = 0
            rvt_item_version.baseline_product_module_obj = 0
            rvt_item_version.previous_version_number = 0
            rvt_item_version.previous_product_module_obj = 0
            rvt_item_version.versions_since_baseline = 0       
            rvt_item_version.baseline_version = TRUE                
                      
            /* end of the ASSIGN */
            .
        
        IF ip_table_fla = ip_primary_fla AND rvc_configuration_type.description_field <> ""
        THEN rvt_item_version.item_description = getFieldValue(ip_table_buffer_handle, rvc_configuration_type.description_field).

        /* use object description if there is one */
        IF AVAILABLE lb_gsc_object AND lb_gsc_object.OBJECT_description <> "":U THEN
          ASSIGN 
            rvt_item_version.item_description = lb_gsc_object.OBJECT_description.

        {af/sup/afvalidtrg.i &ACTION=VALIDATE &TABLE=rvt_item_version}                        
    END.
    ELSE DO:
        FIND FIRST rvt_item_version EXCLUSIVE-LOCK
            WHERE rvt_item_version.configuration_type  = rvm_configuration_item.configuration_type
            AND   rvt_item_version.scm_object_name   = rvm_configuration_item.scm_object_name
            AND   rvt_item_version.product_module_obj = rvm_configuration_item.product_module_obj
            AND   rvt_item_version.item_version_number = lv_version_number.

        /* this item will now be a baseline */
        ASSIGN
            rvt_item_version.baseline_version_number = 0
            rvt_item_version.baseline_product_module_obj = 0
            rvt_item_version.previous_version_number = 0
            rvt_item_version.previous_product_module_obj = 0
            rvt_item_version.versions_since_baseline = 0       
            rvt_item_version.baseline_version = TRUE                
            rvt_item_version.task_number = lv_task_number.
    
        IF ip_table_fla = ip_primary_fla AND rvc_configuration_type.description_field <> ""
            THEN rvt_item_version.item_description = getFieldValue(ip_table_buffer_handle, rvc_configuration_type.description_field).

        /* use object description if there is one */
        IF AVAILABLE lb_gsc_object AND lb_gsc_object.OBJECT_description <> "":U THEN
          ASSIGN 
            rvt_item_version.item_description = lb_gsc_object.OBJECT_description.
        
        {af/sup/afvalidtrg.i &ACTION=VALIDATE &TABLE=rvt_item_version}        
    END.
    
    
    /* assign this version to the workspace */
    
    {af/sup/afvalidtrg.i &ACTION=CREATE &TABLE=rvm_workspace_item}
    ASSIGN
        rvm_workspace_item.workspace_obj = lv_workspace_obj
        rvm_workspace_item.configuration_type = ip_primary_fla
        rvm_workspace_item.scm_object_name = lv_object_name
        rvm_workspace_item.item_version_number = lv_version_number
        rvm_workspace_item.task_version_number = lv_version_number
        
        /* when an item is created we cannot predict which product-modile it will belong to */
                
        rvm_workspace_item.product_module_obj = rvm_configuration_item.product_module_obj /* we must use the product module from the CI, even though this will sometimes be zero. */
        rvm_workspace_item.task_product_module_obj = rvm_configuration_item.product_module_obj /* we must use the product module from the CI, even though this will sometimes be zero. */
        .
    {af/sup/afvalidtrg.i &ACTION=VALIDATE &TABLE=rvm_workspace_item}        

    /* check out this new object */
    {af/sup/afvalidtrg.i &ACTION=CREATE &TABLE=rvt_workspace_checkout}
    ASSIGN
        rvt_workspace_checkout.workspace_obj = lv_workspace_obj
        rvt_workspace_checkout.task_number = lv_task_number
        rvt_workspace_checkout.configuration_type = ip_primary_fla
        rvt_workspace_checkout.workspace_item_obj = rvm_workspace_item.workspace_item_obj
        rvt_workspace_checkout.modification_type = "UNK"       /* always UNK for creation of an item */
        .
    {af/sup/afvalidtrg.i &ACTION=VALIDATE &TABLE=rvt_workspace_checkout}    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createNewVersionFromOld) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createNewVersionFromOld Procedure 
PROCEDURE createNewVersionFromOld :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cObjectExt AS CHARACTER NO-UNDO.
DEFINE VARIABLE cObjectName AS CHARACTER NO-UNDO.

    /* find the previous item version */
    /* First Check assuming that extension is inc as part of object_filename */
    FIND FIRST lb_gsc_object NO-LOCK
         WHERE lb_gsc_object.OBJECT_filename = lv_object_name
         NO-ERROR.
    /* If not available, then check with object_extension field */
    IF NOT AVAILABLE lb_gsc_object THEN DO:
       IF R-INDEX(lv_object_name,".") > 0 THEN DO:
           cObjectExt = ENTRY(NUM-ENTRIES(lv_object_name,"."),lv_object_name,".").
           cObjectName = REPLACE(lv_object_name,("." + cObjectExt),"").
           IF cObjectExt <> "" THEN
               FIND FIRST lb_gsc_object NO-LOCK
                    WHERE lb_gsc_object.Object_filename = cObjectName AND
                          lb_gsc_object.Object_Extension = cObjectExt NO-ERROR. 
       END.
    END.
    
    FIND lb_previous_item_version NO-LOCK
        WHERE lb_previous_item_version.configuration_type = ip_primary_fla
        AND   lb_previous_item_version.scm_object_name  = lv_object_name
        AND   lb_previous_item_version.item_version_number = rvm_workspace_item.item_version_number
        AND   lb_previous_item_version.product_module_obj = rvm_workspace_item.product_module_obj
        .  /* failure would break RI constraints and so is not checked for here */                                                                                      
    
    /* find the next version number */
    
    FIND LAST lb_item_version NO-LOCK
        WHERE lb_item_version.configuration_type = rvm_configuration_item.configuration_type
        AND   lb_item_version.scm_object_name  = rvm_configuration_item.scm_object_name
        AND   lb_item_version.product_module_obj  = rvm_configuration_item.product_module_obj
        USE-INDEX XAK1rvt_item_version
        NO-ERROR.
    lv_version_number = (IF AVAILABLE(lb_item_version) THEN lb_item_version.item_version_number ELSE 0). 
       
    /* create the new item version */
    
    CASE rvt_workspace_checkout.modification_type:
        WHEN "VER" THEN lv_version_number = lv_version_number + {&VER-INCREMENT}.
        WHEN "REV" THEN lv_version_number = lv_version_number + {&REV-INCREMENT}.
        WHEN "PAT" THEN lv_version_number = lv_version_number + {&PAT-INCREMENT}.
        WHEN "UNK" THEN lv_version_number = lv_version_number + {&PAT-INCREMENT}.
        OTHERWISE RETURN ERROR {af/sup2/aferrortxt.i 'RV' '13' '?' '?' rvt_workspace_checkout.modification_type lv_arguments}.
    END CASE.
    
    {af/sup/afvalidtrg.i &ACTION=CREATE &TABLE=rvt_item_version}
    ASSIGN 
        rvt_item_version.configuration_type  = rvm_configuration_item.configuration_type
        rvt_item_version.scm_object_name   = rvm_configuration_item.scm_object_name
        rvt_item_version.product_module_obj   = rvm_configuration_item.product_module_obj
        rvt_item_version.item_version_number = lv_version_number
        rvt_item_version.task_number         = lv_task_number
    
        /* this is based on the previous item */
        
        rvt_item_version.baseline_version_number = lb_previous_item_version.baseline_version_number
        rvt_item_version.baseline_product_module_obj = lb_previous_item_version.baseline_product_module_obj
        rvt_item_version.previous_version_number = lb_previous_item_version.item_version_number
        rvt_item_version.previous_product_module_obj = lb_previous_item_version.product_module_obj
        rvt_item_version.versions_since_baseline = lb_previous_item_version.versions_since_baseline + 1
        
        /* update the task version number */
        
        rvm_workspace_item.task_product_module_obj = rvm_configuration_item.product_module_obj
        rvm_workspace_item.task_version_number = lv_version_number.
        
        /* end of the ASSIGN */
        .
        
    IF ip_table_fla = ip_primary_fla AND rvc_configuration_type.description_field <> ""
        THEN rvt_item_version.item_description = getFieldValue(ip_table_buffer_handle, rvc_configuration_type.description_field).

    /* use object description if there is one */
    IF AVAILABLE lb_gsc_object AND lb_gsc_object.OBJECT_description <> "":U THEN
      ASSIGN 
        rvt_item_version.item_description = lb_gsc_object.OBJECT_description.
        
    {af/sup/afvalidtrg.i &ACTION=VALIDATE &TABLE=rvt_item_version}            
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteItem) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteItem Procedure 
PROCEDURE deleteItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lv_delete_the_version AS LOGICAL.
  DEFINE BUFFER lb_rvt_item_version FOR rvt_item_version.

  DEFINE VARIABLE cRelativePath                   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFile1                          AS CHARACTER  NO-UNDO.

    /* the user has chosen to delete the record in the Primary table which is this data item.
       In response we need to remove it from the workspace and notify the SCM tool that it has been
       removed.
    */
    
    /* we may experience timing issues to do with item deletions.  For instance, is the REPLICATION-DELETE trigger on the primary table ALWAYS the last REPLICATION trigger to fire in the case of a ParentDelete=Cascade scenario?  This may later cause us to "mark an item for deletion" as opposed to actually deleting it at this time. */
    IF rvm_workspace_item.task_product_module_obj <> 0 THEN
      FIND FIRST rvm_configuration_item NO-LOCK
          WHERE rvm_configuration_item.configuration_type = ip_primary_fla
          AND   rvm_configuration_item.scm_object_name = lv_object_name
          AND   rvm_configuration_item.product_module_obj = rvm_workspace_item.task_product_module_obj
          NO-ERROR.
    ELSE
      FIND FIRST rvm_configuration_item NO-LOCK
          WHERE rvm_configuration_item.configuration_type = ip_primary_fla
          AND   rvm_configuration_item.scm_object_name = lv_object_name
          AND   rvm_configuration_item.product_module_obj = rvm_workspace_item.product_module_obj
          NO-ERROR.
        
    IF NOT AVAILABLE rvm_configuration_item 
        THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '23' '?' '?' lv_object_name ip_primary_fla lv_arguments}.
              
    /* I rely here on the fact that to get this far in the process the item must (a) have been checked out, and (b) a new version nust have been created. */
    /* it is possible in principle to delete a workspace item from an administrative tool instead of a DELETE trigger, but more rigorous rules must be used in order to achieve that */

    IF rvm_configuration_item.scm_registered THEN
    DO:
        FIND FIRST rvt_deleted_item NO-LOCK        
            WHERE rvt_deleted_item.workspace_obj = lv_workspace_obj        
            AND   rvt_deleted_item.scm_object_name = lv_object_name
            NO-ERROR.
        
        IF AVAILABLE rvt_deleted_item THEN
        DO:
            IF rvt_deleted_item.task_number = lv_task_number THEN
            DO:
                /* this item was previously deleted under this task - deleting it a second time does not need to create another record here */
            END.
            ELSE DO:
                /* this item was previously deleted under a different task - you cannot delete it again! */
                RETURN ERROR {af/sup2/aferrortxt.i 'RV' '21' '?' '?' lv_object_name lv_workspace_code lv_task_number}.
            END.
        END.
        ELSE DO:
            CREATE rvt_deleted_item.
            ASSIGN  
                rvt_deleted_item.workspace_obj      = lv_workspace_obj
                rvt_deleted_item.task_number        = lv_task_number
                rvt_deleted_item.scm_object_name    = lv_object_name
                rvt_deleted_item.product_module_obj = rvm_configuration_item.product_module_obj
                rvt_deleted_item.configuration_type = ip_primary_fla.      
        END.
    END.
    
    /* now we can delete the item */                                                                  

    IF rvm_workspace_item.task_version_number <> 0 THEN
    DO:
        FIND FIRST rvt_item_version EXCLUSIVE-LOCK
            WHERE rvt_item_version.configuration_type = rvm_workspace_item.configuration_type
            AND   rvt_item_version.scm_object_name = rvm_workspace_item.scm_object_name
            AND   rvt_item_version.product_module_obj = rvm_workspace_item.task_product_module_obj
            AND   rvt_item_version.item_version_number = rvm_workspace_item.task_version_number
            NO-ERROR.
        lv_delete_the_version = AVAILABLE(rvt_item_version).        
    END.
    ELSE lv_delete_the_version = FALSE.
                                                                
/* MESSAGE "About to delete rvm_workspace_item for " lv_object_name. */
                                                                          
    {af/sup/afvalidtrg.i &ACTION=DELETE &TABLE=rvm_workspace_item}

/* MESSAGE "Deletion complete for rvm_workspace_item for " lv_object_name "return-value=" RETURN-VALUE. */
    
    /* the two can-find checks below do a double check to make sure that this item version is not in a workspace before
    we delete it.  The same checks are performed by the triggers, but I don't want to have the action so far undone by 
    violating RI in this regard. */
    
    lv_delete_the_version = lv_delete_the_version AND NOT 
        CAN-FIND(
            FIRST rvm_workspace_item 
            WHERE rvm_workspace_item.configuration_type  = rvt_item_version.configuration_type                                                            
            AND   rvm_workspace_item.scm_object_name     = rvt_item_version.scm_object_name
            AND   rvm_workspace_item.product_module_obj  = rvt_item_version.product_module_obj
            AND   rvm_workspace_item.item_version_number = rvt_item_version.item_version_number
        ).
        
    lv_delete_the_version = lv_delete_the_version AND NOT 
        CAN-FIND(
            FIRST rvm_workspace_item 
            WHERE rvm_workspace_item.configuration_type  = rvt_item_version.configuration_type                                                            
            AND   rvm_workspace_item.scm_object_name     = rvt_item_version.scm_object_name
            AND   rvm_workspace_item.task_product_module_obj  = rvt_item_version.product_module_obj
            AND   rvm_workspace_item.task_version_number = rvt_item_version.item_version_number
        ).
                
                     
    lv_delete_the_version = lv_delete_the_version AND NOT 
        CAN-FIND(
            FIRST lb_rvt_item_version 
            WHERE lb_rvt_item_version.configuration_type      = rvt_item_version.configuration_type                                                            
            AND   lb_rvt_item_version.scm_object_name         = rvt_item_version.scm_object_name
            AND   lb_rvt_item_version.previous_product_module_obj = rvt_item_version.product_module_obj
            AND   lb_rvt_item_version.previous_version_number = rvt_item_version.item_version_number
        ).
                
    lv_delete_the_version = lv_delete_the_version AND NOT 
        CAN-FIND(
            FIRST lb_rvt_item_version 
            WHERE lb_rvt_item_version.configuration_type      = rvt_item_version.configuration_type                                                            
            AND   lb_rvt_item_version.scm_object_name         = rvt_item_version.scm_object_name
            AND   lb_rvt_item_version.baseline_product_module_obj = rvt_item_version.product_module_obj
            AND   lb_rvt_item_version.baseline_version_number = rvt_item_version.item_version_number
        ).

                                                            
    IF lv_delete_the_version THEN
    DO:
        DEFINE VARIABLE lv_deleted_version_number AS INTEGER NO-UNDO.
        DEFINE VARIABLE lv_deleted_module         AS DECIMAL NO-UNDO.
        ASSIGN
          lv_deleted_version_number = rvt_item_version.item_version_number
          lv_deleted_module = rvt_item_version.product_module_obj
          .

        {af/sup/afvalidtrg.i &ACTION=DELETE &TABLE=rvt_item_version}

        /* since we've just deleted the version, delete the item if it is unregistered and no longer has any versions. */
                                                                                           
        IF rvm_configuration_item.scm_registered = FALSE 
        AND NOT CAN-FIND(
            FIRST rvt_item_version 
            WHERE rvt_item_version.scm_object_name     =  rvm_configuration_item.scm_object_name
            AND   rvt_item_version.configuration_type  =  rvm_configuration_item.configuration_type
            AND   rvt_item_version.product_module_obj  =  rvm_configuration_item.product_module_obj
            AND   rvt_item_version.item_version_number <> lv_deleted_version_number) THEN
        DO:
            /* PM-RTB? The sub-part of object should handle this automatically */
            /* Delete .ado file if it has been created */
            FIND FIRST gsc_product_module NO-LOCK
                 WHERE gsc_product_module.product_module_obj = rvm_configuration_item.product_module_obj
                 NO-ERROR.
            ASSIGN cRelativePath = "":U.
              IF VALID-HANDLE(hScmTool)
              AND AVAILABLE gsc_product_module
              THEN
                RUN scmGetModuleDir IN hScmTool (INPUT gsc_product_module.product_module_code,
                                                 OUTPUT cRelativePath).
            IF cRelativePath <> "":U
            THEN
              ASSIGN
                cRelativePath = TRIM(REPLACE(cRelativePath,"~\":U,"/":U),"/":U) + "/":U.

            ASSIGN
              cFile1 = rvm_configuration_item.scm_object_name.
            RUN scmADOExtReplace IN hScmTool (INPUT-OUTPUT cFile1).
            ASSIGN
              cFile1 = cRelativePath + cFile1.

            /* escalate lock status and delete the record */            
            FIND CURRENT rvm_configuration_item EXCLUSIVE-LOCK NO-WAIT.
            IF LOCKED(rvm_configuration_item) 
                THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '29' '?' '?' 'rvm_configuration_item'}.
            {af/sup/afvalidtrg.i &ACTION=DELETE &TABLE=rvm_configuration_item}

            IF SEARCH(cFile1) <> ? THEN
            DO: /* delete .ado file */
              OS-DELETE VALUE(cFile1).    
            END.

        END.
    END.

  ERROR-STATUS:ERROR = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteItemAndAction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteItemAndAction Procedure 
PROCEDURE deleteItemAndAction :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE lv_return_value AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_error        AS LOGICAL   NO-UNDO.    
    
    RUN deleteItem NO-ERROR.
    lv_return_value = RETURN-VALUE.
    lv_error = ERROR-STATUS:ERROR.
    
    
    
    
    
    IF lv_error OR lv_return_value <> ""
        THEN RETURN ERROR lv_return_value.
        ELSE RETURN lv_return_value.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-determineConfigurationType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE determineConfigurationType Procedure 
PROCEDURE determineConfigurationType :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* first of all a safety check - the primary FLA must exist as a valid configuration type */

    FIND FIRST rvc_configuration_type NO-LOCK
        WHERE rvc_configuration_type.configuration_type = ip_primary_fla
        NO-ERROR.
        
    IF NOT AVAILABLE(rvc_configuration_type) 
        THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '7' '?' '?' ip_primary_fla lv_arguments}.
    IF rvc_configuration_type.type_locked 
        THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '8' '?' '?' ip_primary_fla lv_arguments}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-determineObjectName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE determineObjectName Procedure 
PROCEDURE determineObjectName :
/*------------------------------------------------------------------------------
  Purpose:     work out object name either from table if primary table else
               using dynamic query to get record and obtain name from field
               on table.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE lv_buffer_handle AS HANDLE NO-UNDO.
DEFINE VARIABLE lv_query_handle AS HANDLE NO-UNDO.
DEFINE VARIABLE lv_query_string AS CHARACTER.
DEFINE VARIABLE lv_idx AS INTEGER.
DEFINE VARIABLE lv_ok AS LOGICAL.

DEFINE VARIABLE cOldObjectName AS CHARACTER NO-UNDO.
DEFINE VARIABLE cNewObjectName AS CHARACTER NO-UNDO.
DEFINE VARIABLE dOldProductModule AS DECIMAL NO-UNDO.
DEFINE VARIABLE dNewProductModule AS DECIMAL NO-UNDO.
                                  
    IF ip_table_fla = ip_primary_fla THEN
    DO:
        /* this is the primary table - no need to open a query.  Indeed we cannot open a query because this would
           fail to find the record if it is being deleted */

        ASSIGN
            gcDBName = ip_table_buffer_handle:DBNAME
            cNewObjectName = getFieldValue(ip_table_buffer_handle, rvc_configuration_type.scm_identifying_fieldname)
            lv_object_name = cNewObjectName
            lv_nulls_in_primary_key = FALSE.  /* although there were nulls we have found a corresponding record, so continue. */
            
        IF VALID-HANDLE(ip_old_buffer_handle) AND
           CAN-QUERY(ip_old_buffer_handle,"available":U) AND
           ip_old_buffer_handle:AVAILABLE = TRUE
            THEN cOldObjectName = getFieldValue(ip_old_buffer_handle, rvc_configuration_type.scm_identifying_fieldname).
            ELSE cOldObjectName = cNewObjectName.

        IF cOldObjectName = "":U OR cOldObjectName = ? THEN
          ASSIGN cOldObjectName = cNewObjectName.
        IF cNewObjectName <> ? AND cNewObjectName <> "":U AND cNewObjectName <> cOldObjectName THEN 
        DO:
          RUN renameObject(
              INPUT cOldObjectName, 
              INPUT cNewObjectName).
          IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
        END.

        IF rvc_configuration_type.product_module_fieldname <> "":U THEN
        DO:
          dNewProductModule = DECIMAL(getFieldValue(ip_table_buffer_handle, rvc_configuration_type.product_module_fieldname)).
      
          IF VALID-HANDLE(ip_old_buffer_handle) AND
             CAN-QUERY(ip_old_buffer_handle,"available":U) AND
             ip_old_buffer_handle:AVAILABLE = TRUE
              THEN dOldProductModule = DECIMAL(getFieldValue(ip_old_buffer_handle, rvc_configuration_type.product_module_fieldname)).
              ELSE dOldProductModule = dNewProductModule.
        END.
        ELSE
          ASSIGN
            dNewProductModule = 0
            dOldProductModule = 0
            .

        IF dNewProductModule <> ? AND dNewProductModule <> 0 AND dNewProductModule <> dOldProductModule THEN
        DO:
          RUN changeProductModule (INPUT cNewObjectName,
                                   INPUT dOldProductModule,
                                   INPUT dNewProductModule).
          IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
        END.
        
        RETURN.
    END.
        
    CREATE BUFFER lv_buffer_handle FOR TABLE rvc_configuration_type.type_table_name.
    ASSIGN gcDBName = lv_buffer_handle:DBNAME.

    lv_query_string = "FOR EACH " + rvc_configuration_type.type_table_name + " NO-LOCK WHERE ".
    
    DO lv_idx = 1 TO NUM-ENTRIES(ip_primary_key_fields):
        lv_nulls_in_primary_key = LOOKUP(getQuotedFieldValue(ip_table_buffer_handle, ENTRY(lv_idx,ip_primary_key_fields)),",?,0") > 0.
        IF lv_idx > 1 THEN lv_query_string = lv_query_string + " AND ".
        lv_query_string = lv_query_string + rvc_configuration_type.type_table_name + "." + ENTRY(lv_idx,rvc_configuration_type.scm_primary_key_fields) + " = " + getQuotedFieldValue(ip_table_buffer_handle, ENTRY(lv_idx,ip_primary_key_fields)) + " ".                                                                                                                                  
    END.
    
    DO ON ERROR UNDO, RETURN ERROR {af/sup2/aferrortxt.i 'RV' '19' '?' '?' lv_query_string rvc_configuration_type.scm_identifying_fieldname lv_arguments}:
        CREATE QUERY lv_query_handle.
        
        ASSIGN lv_ok = lv_query_handle:SET-BUFFERS(lv_buffer_handle) NO-ERROR.
        IF NOT lv_ok THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '19' '?' '?' lv_query_string rvc_configuration_type.scm_identifying_fieldname lv_arguments}.
        
        lv_query_string = DYNAMIC-FUNCTION("fixQueryString":U IN gshSessionManager, INPUT lv_query_string).
        ASSIGN lv_ok = lv_query_handle:QUERY-PREPARE(lv_query_string) NO-ERROR.
        IF NOT lv_ok THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '19' '?' '?' lv_query_string rvc_configuration_type.scm_identifying_fieldname lv_arguments}.
        
        ASSIGN lv_ok = lv_query_handle:QUERY-OPEN() NO-ERROR.
        IF NOT lv_ok THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '19' '?' '?' lv_query_string rvc_configuration_type.scm_identifying_fieldname lv_arguments}.
        
        ASSIGN lv_ok = lv_query_handle:GET-FIRST() NO-ERROR.
    END.
    
    IF NOT lv_buffer_handle:AVAILABLE THEN
    DO:
        /* cleanup dynamic query */
        
        lv_buffer_handle:BUFFER-RELEASE() NO-ERROR.
        lv_query_handle:QUERY-CLOSE().
        DELETE OBJECT lv_query_handle.
        DELETE OBJECT lv_buffer_handle.
        ASSIGN
          lv_buffer_handle = ?
          lv_query_handle = ?
          .
        
        IF lv_nulls_in_primary_key 
            THEN RETURN.
            ELSE DO:
                /* MESSAGE lv_arguments VIEW-AS ALERT-BOX. */
                RETURN ERROR {af/sup2/aferrortxt.i 'RV' '20' '?' '?' lv_query_string rvc_configuration_type.scm_identifying_fieldname lv_arguments}.
            END.
    END.
    
    ASSIGN
        lv_object_name = getFieldValue(lv_buffer_handle, rvc_configuration_type.scm_identifying_fieldname)
        lv_nulls_in_primary_key = FALSE.  /* although there were nulls we have found a corresponding record, so continue. */

    /* cleanup dynamic query */        
        
    lv_buffer_handle:BUFFER-RELEASE() NO-ERROR.
    lv_query_handle:QUERY-CLOSE().
    DELETE OBJECT lv_query_handle.
    DELETE OBJECT lv_buffer_handle.
    
    ASSIGN
      lv_buffer_handle = ?
      lv_query_handle = ?
      .
                 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-determineTask) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE determineTask Procedure 
PROCEDURE determineTask :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE lv_task_open AS LOGICAL NO-UNDO.
    
    /* and we need to know the user's "current" task */
        
    RUN scmGetTask (INPUT lv_workspace_code, OUTPUT lv_task_number, OUTPUT lv_task_open).
    IF lv_task_number = ? 
        THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '5' '?' '?' lv_arguments}.
        
    IF NOT lv_task_open        
        THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '25' '?' '?' lv_arguments}.
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-determineTransactionId) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE determineTransactionId Procedure 
PROCEDURE determineTransactionId :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    /* determine the transaction_id */

    IF gcDbName <> "":U THEN
      ASSIGN lv_alias = gcDbName.
    ELSE
      ASSIGN lv_alias = SUBSTRING(ip_primary_fla,1,2) + "db".
    lv_transaction_id = DBTASKID(lv_alias).
    IF lv_transaction_id = ? 
        THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '1' '?' '?' lv_alias lv_arguments}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-determineWorkspace) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE determineWorkspace Procedure 
PROCEDURE determineWorkspace :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* get the Workspace details */
    
    RUN scmGetWorkspace(OUTPUT lv_workspace_code).  /* put logical db name onto the workspace record */
    IF lv_workspace_code = ? OR lv_workspace_code = ""
        THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '2' '?' '?' lv_arguments}.
    
    lv_arguments = lv_arguments + "~nWORKSPACE='" + lv_workspace_code + "'".

    FIND FIRST rvm_workspace NO-LOCK 
        WHERE rvm_workspace.workspace_code = lv_workspace_code
        NO-ERROR.
    IF NOT AVAILABLE (rvm_workspace) 
        THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '3' '?' '?' lv_workspace_code lv_arguments}.

    /* the workspace does exist */
    
    IF rvm_workspace.workspace_locked 
        THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '4' '?' '?' lv_workspace_code lv_arguments}.
    
    /* record the workspace OBJ for future reference */
    
    lv_workspace_obj = rvm_workspace.workspace_obj.    
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doReplication) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doReplication Procedure 
PROCEDURE doReplication :
/*------------------------------------------------------------------------------
  Purpose:     Guts of replication code
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DO ON ERROR UNDO, RETURN ERROR RETURN-VALUE:
    
        lv_creating_item = (ip_action = "WRITE"  AND ip_table_fla = ip_primary_fla AND ip_new ).
        lv_deleting_item = (ip_action = "DELETE" AND ip_table_fla = ip_primary_fla).
    
        /* Some of the involved tables have nulls-allowed relationships to the primary table.  Before letting the 
           versioning system kick in we return if the primary key is null */
    
        RUN determineConfigurationType.
        IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
        
        RUN determineObjectName. 
        IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
    
        /* do nothing if doing an assignment */
        IF assignmentUnderway(FALSE) THEN RETURN.    
        
        IF lv_nulls_in_primary_key THEN RETURN.
        
        RUN determineTransactionId.
        IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
        RUN determineWorkspace.
        IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
        RUN determineTask.
        IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
/*
        RUN determineSite.
        IF RETURN-VALUE <> "":U THEN RETURN ERROR RETURN-VALUE.
*/
    
        /* now check for availability of the configuration item itself in the designated workspace */
    
        FIND FIRST rvm_workspace_item EXCLUSIVE-LOCK
            WHERE rvm_workspace_item.configuration_type = ip_primary_fla
            AND   rvm_workspace_item.scm_object_name    = lv_object_name
            AND   rvm_workspace_item.workspace_obj      = lv_workspace_obj
            NO-ERROR.
/*
        /* check product module owned by site */
        IF AVAILABLE rvm_workspace_item 
        /* AND lv_site_number > 0 */
        THEN DO:
          IF rvm_workspace_item.task_product_module_obj <> 0
          THEN
            FIND FIRST gsc_product_module NO-LOCK
                 WHERE gsc_product_module.product_module_obj = rvm_workspace_item.task_product_module_obj
                 NO-ERROR.
          ELSE
            FIND FIRST gsc_product_module NO-LOCK
                 WHERE gsc_product_module.product_module_obj = rvm_workspace_item.product_module_obj
                 NO-ERROR.
          IF AVAILABLE gsc_product_module
             AND LENGTH(gsc_product_module.product_module_code) > 2 THEN
          DO:
            DEFINE VARIABLE lv_check_site AS INTEGER NO-UNDO.
            DEFINE VARIABLE lv_message    AS CHARACTER NO-UNDO.
            ASSIGN lv_check_site = -1.
            ASSIGN lv_check_site = INTEGER(SUBSTRING(gsc_product_module.product_module_code,1,3))
               NO-ERROR.
            IF lv_check_site <> lv_site_number THEN
            DO:
              ASSIGN lv_message = "The object: " + TRIM(lv_object_name) + " cannot be processed because the product module: " + TRIM(gsc_product_module.product_module_code)
                                  +  " does not belong to the current site: " + STRING(lv_site_number) + CHR(10) +
                                  "Please first move the object to a product module owned by this site and try again.".            
              RETURN ERROR {af/sup2/aferrortxt.i 'AF' '17' '?' '?' lv_message}.
            END.
          END.
        END.
*/
    
        IF lv_creating_item THEN
        DO:
            FIND FIRST rvt_deleted_item EXCLUSIVE-LOCK
                WHERE rvt_deleted_item.task_number        = lv_task_number
                AND   rvt_deleted_item.scm_object_name    = lv_object_name
                AND   rvt_deleted_item.configuration_type = ip_primary_fla
                AND   rvt_deleted_item.workspace_obj      = lv_workspace_obj
                NO-ERROR.
            IF AVAILABLE rvt_deleted_item THEN
            DO:
                /* creation is fine even if WorkspaceItem does already exist */
                DELETE rvt_deleted_item.
            END.
            
/*
            DO:
                /* these checks can no longer be relied upon as imports are performed on objects which exist in the repository */
                /* be more particular about when creations are permitted */
                IF AVAILABLE (rvm_workspace_item) THEN 
                    RETURN ERROR {af/sup2/aferrortxt.i 'RV' '10' '?' '?' ip_primary_fla lv_object_name lv_workspace_code lv_arguments}.
            
                IF CAN-FIND(FIRST rvm_configuration_item WHERE rvm_configuration_item.scm_object_name = lv_object_name) 
                    THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '22' '?' '?' ip_primary_fla lv_object_name lv_arguments}.                
            END.
*/
            /* the item is being created and does not yet exist.  Therefor we can now create the item version, and check the item out */       
            RUN findOrCreateItem.
            RUN createNewItemVersion.
            RUN writeTransActionRecords.
        END. /* creating the item */
        ELSE IF lv_deleting_item THEN 
        DO:   
/*             IF NOT AVAILABLE (rvm_workspace_item)                                                                           */
/*                 THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '11' '?' '?' ip_primary_fla lv_object_name lv_workspace_code lv_arguments}. */
            
            IF AVAILABLE (rvm_workspace_item) THEN
            DO:
                RUN performDeleteCheckoutCheck.
                RUN deleteItemAndAction.            
            END.
            ELSE DO:
                /* attempt to delete data in the repository when we have not record of it existing in that workspace  - let the deletion proceed */
            END.
            deletionUnderway(TRUE).
            
        END. /* item pre-exists */
        ELSE DO:

            IF NOT AVAILABLE (rvm_workspace_item) 
                 THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '11' '?' '?' ip_primary_fla lv_object_name lv_workspace_code lv_arguments}. 
            
            IF rvm_workspace_item.task_product_module_obj <> 0 THEN
              FIND FIRST rvm_configuration_item NO-LOCK
                  WHERE rvm_configuration_item.configuration_type = ip_primary_fla
                  AND   rvm_configuration_item.scm_object_name = lv_object_name
                  AND   rvm_configuration_item.product_module_obj = rvm_workspace_item.task_product_module_obj
                  NO-ERROR.
            ELSE
              FIND FIRST rvm_configuration_item NO-LOCK
                  WHERE rvm_configuration_item.configuration_type = ip_primary_fla
                  AND   rvm_configuration_item.scm_object_name = lv_object_name
                  AND   rvm_configuration_item.product_module_obj = rvm_workspace_item.product_module_obj
                  NO-ERROR.
                                                                          
            IF NOT AVAILABLE rvm_configuration_item 
                THEN RETURN ERROR  {af/sup2/aferrortxt.i 'RV' '7' '?' '?' ip_primary_fla lv_object_name lv_arguments}.
               
            IF rvm_configuration_item.scm_registered
                THEN RUN performWriteCheckoutCheck.
                ELSE RUN checkOutItemIfRequired.
    
            /* do we need to create a new version of this item */       
            IF rvm_workspace_item.task_version_number = 0 
                THEN RUN createNewVersionFromOld.
    
            RUN writeTransActionRecords.                       
        END.
        
        /* successful completion */
        ERROR-STATUS:ERROR = FALSE.
        RETURN.
        
    END. /* do on error undo, return return-value */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findOrCreateItem) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findOrCreateItem Procedure 
PROCEDURE findOrCreateItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR lv_product_module_obj AS DECIMAL.
   

    /* see if this item, which is new to the repository, exists in the SCM tool */
    
    RUN scmObjectExists (        
        INPUT  lv_object_name,
        INPUT  lv_workspace_code,
        OUTPUT lv_scm_object_exists,
        OUTPUT lv_scm_object_exists_in_ws,
        OUTPUT lv_scm_version_in_workspace,
        OUTPUT lv_scm_checked_out_in_workspace,
        OUTPUT lv_scm_version_task_number,
        OUTPUT lv_scm_highest_version).        
        
    IF lv_scm_object_exists THEN
    DO:
        /* a couple of checks first */
        
        IF NOT lv_scm_object_exists_in_ws 
            THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '26' '?' '?' lv_object_name lv_workspace_code lv_arguments}.
            
        IF NOT lv_scm_checked_out_in_workspace 
            THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '27' '?' '?' lv_object_name lv_workspace_code lv_arguments}. 
           
        IF lv_scm_version_task_number <> lv_task_number 
            THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '28' '?' '?' lv_object_name lv_task_number lv_scm_version_task_number}.
    END.
    /* before we create the workspace item we must ensire that a configuration item record exists.  Pre-existence of this item is not a problem */

    /* get product module */
    IF rvc_configuration_type.product_module_fieldname <> "" THEN
    DO:
        /* determine the product module from the primary table buffer */
        lv_product_module_obj = DECIMAL(getFieldValue(ip_table_buffer_handle, rvc_configuration_type.product_module_fieldname)).
    END.
    ELSE IF rvc_configuration_type.product_module_obj <> 0 THEN  
    DO:
        /* use the default product module obj from the configuration type table */
        lv_product_module_obj = rvc_configuration_type.product_module_obj.
    END.
    ELSE RETURN ERROR {af/sup2/aferrortxt.i 'RV' '14' '?' '?' rvc_configuration_type.configuration_type rvt_workspace_checkout.task_number lv_arguments}.

/*
    /* check product module owned by site */
    IF lv_product_module_obj <> 0
    /* AND lv_site_number > 0 */
    THEN
    DO:
      FIND FIRST gsc_product_module NO-LOCK
           WHERE gsc_product_module.product_module_obj = lv_product_module_obj
           NO-ERROR.
      IF AVAILABLE gsc_product_module
         AND LENGTH(gsc_product_module.product_module_code) > 2 THEN
      DO:
        DEFINE VARIABLE lv_check_site AS INTEGER NO-UNDO.
        DEFINE VARIABLE lv_message    AS CHARACTER NO-UNDO.
        ASSIGN lv_check_site = -1.
        ASSIGN lv_check_site = INTEGER(SUBSTRING(gsc_product_module.product_module_code,1,3))
           NO-ERROR.
        IF lv_check_site <> lv_site_number THEN
        DO:
          ASSIGN lv_message = "The object: " + TRIM(lv_object_name) + " cannot be processed because the product module: " + TRIM(gsc_product_module.product_module_code)
                              +  " does not belong to the current site: " + STRING(lv_site_number) + CHR(10) +
                              "Please first move the object to a product module owned by this site and try again.".            
          RETURN ERROR {af/sup2/aferrortxt.i 'AF' '17' '?' '?' lv_message}.
        END.
      END.
    END.
*/
        
    FIND FIRST rvm_configuration_item NO-LOCK
        WHERE rvm_configuration_item.configuration_type = ip_primary_fla
        AND   rvm_configuration_item.scm_object_name = lv_object_name
        AND   rvm_configuration_item.product_module_obj = lv_product_module_obj
        NO-ERROR.
                                                      
    IF NOT AVAILABLE rvm_configuration_item THEN
    DO:
        /* we're going to create a new CI. */
        
        {af/sup/afvalidtrg.i &ACTION=CREATE &TABLE=rvm_configuration_item}.
        ASSIGN
            rvm_configuration_item.configuration_type = ip_primary_fla
            rvm_configuration_item.scm_object_name = lv_object_name
            rvm_configuration_item.product_module_obj = lv_product_module_obj
            rvm_configuration_item.scm_registered = lv_scm_object_exists /* this new item is not yet registered in the SCM tool */
            .
            
        {af/sup/afvalidtrg.i &ACTION=VALIDATE &TABLE=rvm_configuration_item}.   
                                  
    END.
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fixTablePkFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fixTablePkFields Procedure 
PROCEDURE fixTablePkFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE before AS CHARACTER.
        
    ip_table_pk_fields = REPLACE(REPLACE(REPLACE(ip_table_pk_fields," ",""),CHR(13),""),CHR(10),"").
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-performDeleteCheckoutCheck) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE performDeleteCheckoutCheck Procedure 
PROCEDURE performDeleteCheckoutCheck :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /* is the item checked out */
    
    FIND FIRST rvt_workspace_checkout NO-LOCK
        WHERE rvt_workspace_checkout.workspace_obj = lv_workspace_obj
        AND   rvt_workspace_checkout.workspace_item_obj = rvm_workspace_item.workspace_item_obj
        AND   rvt_workspace_checkout.configuration_type = ip_primary_fla
        NO-ERROR.
    IF AVAILABLE(rvt_workspace_checkout) THEN
    DO:
        /* the item is checked out explicitly */
        IF rvt_workspace_checkout.task_number <> lv_task_number 
            THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '12' '?' '?' ip_primary_fla lv_object_name lv_task_number rvt_workspace_checkout.task_number lv_arguments}.
            
        /* this item is explicitly checked out */
    END.
    ELSE DO:
        /* this item is not explicitly checked out */
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-performWriteCheckoutCheck) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE performWriteCheckoutCheck Procedure 
PROCEDURE performWriteCheckoutCheck :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* is the item checked out */
    
    FIND FIRST rvt_workspace_checkout NO-LOCK
        WHERE rvt_workspace_checkout.workspace_obj = lv_workspace_obj
        AND   rvt_workspace_checkout.workspace_item_obj = rvm_workspace_item.workspace_item_obj
        AND   rvt_workspace_checkout.configuration_type = ip_primary_fla
        NO-ERROR.
    IF AVAILABLE(rvt_workspace_checkout) THEN
    DO:
        /* the item is checked out explicitly */
        IF rvt_workspace_checkout.task_number <> lv_task_number 
            THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '12' '?' '?' ip_primary_fla lv_object_name lv_task_number rvt_workspace_checkout.task_number lv_arguments}.
            
        /* this item is explicitly checked out */
    END.
    ELSE RETURN ERROR {af/sup2/aferrortxt.i 'RV' '24' '?' '?' lv_object_name lv_workspace_code lv_arguments}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-renameObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE renameObject Procedure 
PROCEDURE renameObject :
/*------------------------------------------------------------------------------
  Purpose:     Deal with rename of object in version tables - if not registered yet !
  Parameters:  input old object name
               input new object name
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER pOldObjectName AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pNewobjectName AS CHARACTER NO-UNDO.

DEFINE VARIABLE cErrorText                      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cRelativePath                   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFile1                          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFile2                          AS CHARACTER  NO-UNDO.

IF Grtb-wspace-id = "":U THEN RETURN.

FIND FIRST rvm_workspace NO-LOCK
     WHERE rvm_workspace.workspace_code = Grtb-wspace-id
     NO-ERROR.

IF NOT AVAILABLE rvm_workspace THEN RETURN.

FIND FIRST rvm_configuration_item NO-LOCK
     WHERE rvm_configuration_item.scm_object_name = pOldObjectName
     NO-ERROR.

IF NOT AVAILABLE rvm_configuration_item  THEN RETURN.

IF rvm_configuration_item.scm_registered = YES THEN
DO:
  ASSIGN cErrorText = {af/sup2/aferrortxt.i 'AF' '13' '?' '?' "'Object Name'"}.
  RETURN ERROR cErrorText.
END.

FIND FIRST rvm_configuration_item NO-LOCK
     WHERE rvm_configuration_item.scm_object_name = pNewobjectName
     NO-ERROR.
IF AVAILABLE rvm_configuration_item THEN
DO:
  ASSIGN cErrorText = {af/sup2/aferrortxt.i 'AF' '13' '?' '?' "'Object Name'"}.
  RETURN ERROR cErrorText.
END.

DEFINE BUFFER brvm_configuration_item FOR rvm_configuration_item.
DEFINE BUFFER brvt_item_version FOR rvt_item_version.
DEFINE BUFFER brvm_workspace_item FOR rvm_workspace_item.

tran-block:
DO FOR brvm_configuration_item, brvt_item_version, brvm_workspace_item
       TRANSACTION ON ERROR UNDO tran-block, LEAVE tran-block: 

  FOR EACH brvm_configuration_item EXCLUSIVE-LOCK
     WHERE brvm_configuration_item.scm_object_name = pOldObjectName:
    
    ASSIGN brvm_configuration_item.scm_object_name = pNewObjectName.
    VALIDATE brvm_configuration_item NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}    
    cErrorText = cMessageList.
    IF cErrorText <> "":U THEN UNDO tran-block, LEAVE tran-block.
  
  END.
    
  FOR EACH brvt_item_version  EXCLUSIVE-LOCK
     WHERE brvt_item_version.scm_object_name = pOldObjectName:
      
    ASSIGN brvt_item_version.scm_object_name = pNewObjectName.
    VALIDATE brvt_item_version NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}    
    cErrorText = cMessageList.
    IF cErrorText <> "":U THEN UNDO tran-block, LEAVE tran-block.
    
  END.

  FOR EACH brvm_workspace_item  EXCLUSIVE-LOCK
     WHERE brvm_workspace_item.scm_object_name = pOldObjectName:
      
    ASSIGN brvm_workspace_item.scm_object_name = pNewObjectName.
    VALIDATE brvm_workspace_item NO-ERROR.
    {af/sup2/afcheckerr.i &no-return = YES}    
    cErrorText = cMessageList.
    IF cErrorText <> "":U THEN UNDO tran-block, LEAVE tran-block.

  END.

END. /* tran-block */

/* PM-RTB? The subpart in RTB should take care of this */
/* renamed ok, now try and rename any xml file that exists for object */
IF cErrorText = "":U THEN
DO:

  FOR EACH rvt_item_version NO-LOCK
     WHERE rvt_item_version.scm_object_name = pNewObjectName,
     FIRST gsc_product_module NO-LOCK
     WHERE gsc_product_module.product_module_obj = rvt_item_version.product_module_obj:

    /* Figure out path for object product module */
    ASSIGN cRelativePath = "":U.
      IF VALID-HANDLE(hScmTool)
      THEN
        RUN scmGetModuleDir IN hScmTool (INPUT gsc_product_module.product_module_code,
                                             OUTPUT cRelativePath).
    IF cRelativePath <> "":U THEN
      ASSIGN
        cRelativePath = TRIM(REPLACE(cRelativePath,"~\":U,"/":U),"/":U) + "/":U.

    ASSIGN
      cFile1 = pOldObjectName
      cFile2 = pNewObjectName.
    RUN scmADOExtReplace IN hScmTool (INPUT-OUTPUT cFile1).
    RUN scmADOExtReplace IN hScmTool (INPUT-OUTPUT cFile2).
    ASSIGN
      cFile1 = cRelativePath + cFile1
      cFile2 = cRelativePath + cFile2.

    IF SEARCH(cFile1) <> ?
    AND SEARCH(cFile2) = ?
    THEN DO: /* rename .ado file */
      OS-RENAME VALUE(cFile1) VALUE(cFile2).    
    END.
  END.

END.

ERROR-STATUS:ERROR = NO.
RETURN cErrorText.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmCheckOutObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmCheckOutObject Procedure 
PROCEDURE scmCheckOutObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER ip_workspace_code        AS CHARACTER.
DEFINE INPUT PARAMETER ip_task_number           AS INTEGER.
DEFINE INPUT PARAMETER ip_scm_object_name        AS CHARACTER.
DEFINE INPUT PARAMETER ip_scm_code              AS CHARACTER.


DEFINE VARIABLE scm_inherited_modification_type AS CHARACTER.

    DEFINE BUFFER lb_workspace FOR rvm_workspace.
    DEFINE BUFFER lb_workspace_checkout FOR rvt_workspace_checkout.
    DEFINE BUFFER lb_configuration_type FOR rvc_configuration_type.
    DEFINE BUFFER lb_workspace_item FOR rvm_workspace_item.
    DEFINE BUFFER lb_configuration_item FOR rvm_configuration_item.
    
    FIND FIRST lb_workspace NO-LOCK
        WHERE lb_workspace.workspace_code = ip_workspace_code
        NO-ERROR.
    
    IF NOT AVAILABLE(lb_workspace) 
        THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '16' '?' '?' ip_workspace_code ''}. /* write it */
    
    IF lb_workspace.workspace_locked 
        THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '4' '?' '?' lb_workspace.workspace_code ''}.
    
    FIND FIRST lb_workspace_checkout NO-LOCK
        WHERE lb_workspace_checkout.workspace_obj = lv_workspace_obj
        AND   lb_workspace_checkout.workspace_item_obj = 0 /* NULL */
        AND   lb_workspace_checkout.configuration_type = "" /* NULL */
        NO-ERROR.
    
    IF AVAILABLE lb_workspace_checkout THEN
    DO:
        IF lb_workspace_checkout.task_number <> lv_task_number 
            THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '6' '?' '?' lv_workspace_code lv_task_number rvt_workspace_checkout.task_number ''}.
        scm_inherited_modification_type = lb_workspace_checkout.modification_type.
    END.
                                              
    FIND FIRST lb_configuration_type NO-LOCK
        WHERE lb_configuration_type.scm_code = ip_scm_code 
        NO-ERROR.
        
    IF NOT AVAILABLE(lb_configuration_type) 
        THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '15' '?' '?' ip_scm_code lv_arguments}.
        
    /* is the configuration type checked out under a different task? */
    
    FIND FIRST lb_workspace_checkout NO-LOCK
        WHERE lb_workspace_checkout.workspace_obj = lv_workspace_obj
        AND   lb_workspace_checkout.workspace_item_obj = 0 /* NULL */
        AND   lb_workspace_checkout.configuration_type = ip_primary_fla
        NO-ERROR.
        
    IF AVAILABLE lb_workspace_checkout THEN
    DO: 
        IF lb_workspace_checkout.task_number <> lv_task_number 
            THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '9' '?' '?' ip_primary_fla lv_task_number lb_workspace_checkout.task_number ''}.        
        scm_inherited_modification_type = lb_workspace_checkout.modification_type.
    END.

    FIND FIRST lb_workspace_item NO-LOCK
        WHERE lb_workspace_item.workspace_obj = lb_workspace.workspace_obj
        AND   lb_workspace_item.configuration_type = lb_configuration_type.configuration_type
        AND   lb_workspace_item.scm_object_name = ip_scm_object_name
        NO-ERROR.
        
    IF NOT AVAILABLE lb_workspace_item 
        THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '18' '?' '?' ip_scm_code ip_scm_object_name ip_workspace_code}.        
                                          
    FIND lb_configuration_item NO-LOCK
        WHERE lb_configuration_item.configuration_type = lb_configuration_type.configuration_type
        AND   lb_configuration_item.scm_object_name = ip_scm_object_name
        AND   lb_configuration_item.product_module_obj = lb_workspace_item.product_module_obj
        NO-ERROR.
        
    IF NOT AVAILABLE(lb_configuration_item)                                                                                                  
        THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '17' '?' '?' ip_primary_fla ip_workspace_code}.        

/* not finished - determine other data items for creation below, but also perform check for generic check-uot records as before */
                                                                                              
    
       
        
        {af/sup/afvalidtrg.i &ACTION=CREATE &TABLE=rvt_workspace_checkout}.
        ASSIGN
            rvt_workspace_checkout.workspace_obj      = lb_workspace.workspace_obj
            rvt_workspace_checkout.task_number        = ip_task_number
            rvt_workspace_checkout.configuration_type = lb_configuration_type.configuration_type
            rvt_workspace_checkout.workspace_item_obj = lb_workspace_item.workspace_item_obj
            rvt_workspace_checkout.modification_type  = scm_inherited_modification_type  /* use that for the generic Configuration Type or Workspace check out record */            
            .
        {af/sup/afvalidtrg.i &ACTION=VALIDATE &TABLE=rvt_workspace_checkout}            

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmConfigurationItemCreated) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmConfigurationItemCreated Procedure 
PROCEDURE scmConfigurationItemCreated :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER ip_workspace_code        AS CHARACTER.
DEFINE INPUT PARAMETER ip_task_number           AS INTEGER.
DEFINE INPUT PARAMETER ip_scm_objet_name        AS CHARACTER.
DEFINE INPUT PARAMETER ip_scm_code              AS CHARACTER.
DEFINE INPUT PARAMETER ip_product_module_code   AS CHARACTER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmConfigurationItemDeleted) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmConfigurationItemDeleted Procedure 
PROCEDURE scmConfigurationItemDeleted :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER ip_workspace_code        AS CHARACTER.
DEFINE INPUT PARAMETER ip_task_number           AS INTEGER.
DEFINE INPUT PARAMETER ip_scm_objet_name        AS CHARACTER.
DEFINE INPUT PARAMETER ip_scm_code              AS CHARACTER.
DEFINE INPUT PARAMETER ip_product_module_code   AS CHARACTER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmGetTask) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmGetTask Procedure 
PROCEDURE scmGetTask :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER ip_workspace_code AS CHARACTER.
DEFINE OUTPUT PARAMETER op_task_number    AS INTEGER.
DEFINE OUTPUT PARAMETER op_task_open       AS LOGICAL.

DEFINE VARIABLE lv_task_number      AS INTEGER INITIAL 0 NO-UNDO.
DEFINE VARIABLE lv_task_summary     AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_task_description AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_task_programmer  AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_task_userref     AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_task_workspace   AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_task_entered_date AS DATE NO-UNDO.
DEFINE VARIABLE lv_task_status      AS CHARACTER NO-UNDO.

  IF VALID-HANDLE(hScmTool) THEN
  DO:
    RUN scmGetTaskInfo IN hScmTool (INPUT-OUTPUT lv_task_number,
                                        OUTPUT lv_task_summary,
                                        OUTPUT lv_task_description,
                                        OUTPUT lv_task_programmer,
                                        OUTPUT lv_task_userref,
                                        OUTPUT lv_task_workspace,
                                        OUTPUT lv_task_entered_date,
                                        OUTPUT lv_task_status).
  END.

  op_task_number = lv_task_number.
  op_task_open = (lv_task_status = "W"). /* W = Work in progress */
                
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmGetWorkspace) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmGetWorkspace Procedure 
PROCEDURE scmGetWorkspace :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER op_workspace_code AS CHARACTER NO-UNDO.
                                                            
ASSIGN op_workspace_code = Grtb-wspace-id.
                                     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-scmObjectExists) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scmObjectExists Procedure 
PROCEDURE scmObjectExists :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER ip_object_name                        AS CHARACTER.
  DEFINE INPUT  PARAMETER ip_workspace_code                     AS CHARACTER.
  DEFINE OUTPUT PARAMETER op_object_exists                      AS LOGICAL.
  DEFINE OUTPUT PARAMETER op_object_exists_in_workspace         AS LOGICAL.
  DEFINE OUTPUT PARAMETER op_version_in_workspace               AS INTEGER.
  DEFINE OUTPUT PARAMETER op_checked_out_in_workspace           AS LOGICAL.
  DEFINE OUTPUT PARAMETER op_version_task_number                AS INTEGER. 
  DEFINE OUTPUT PARAMETER op_highest_version                    AS INTEGER. 

  DEFINE VARIABLE cObjectName                                   AS CHARACTER  NO-UNDO.

  IF VALID-HANDLE(hScmTool)
  THEN DO:

    ASSIGN
      cObjectName = ip_object_name.
    RUN scmADOExtReplace IN hScmTool
                        (INPUT-OUTPUT cObjectName).

    RUN scmObjectExists IN hScmTool
                       (INPUT  cObjectName
                       ,INPUT  ip_workspace_code
                       ,OUTPUT op_object_exists
                       ,OUTPUT op_object_exists_in_workspace
                       ,OUTPUT op_version_in_workspace
                       ,OUTPUT op_checked_out_in_workspace
                       ,OUTPUT op_version_task_number
                       ,OUTPUT op_highest_version
                       ).
  END.
  ELSE DO:
    RETURN ERROR "Scm Tool handle (hScmTool) not valid!".
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-startPersistentProcs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startPersistentProcs Procedure 
PROCEDURE startPersistentProcs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE VARIABLE lv_proc_hdl AS HANDLE NO-UNDO.
      IF NOT CONNECTED("RTB":U)
      THEN RETURN.

      IF NOT VALID-HANDLE(hScmTool)
      AND CONNECTED("rtb":U)
      AND (SEARCH("rtb/prc/afrtbprocp.p":U) <> ?
        OR SEARCH("rtb/prc/afrtbprocp.p":U) <> ?)
      THEN
        RUN rtb/prc/afrtbprocp.p PERSISTENT SET hScmTool.

      IF NOT VALID-HANDLE(hScmTool)
      THEN DO:
          RETURN ERROR "Could not start SCM procedure (rtb/prc/afrtbprocp.p) for Roundtable API and you have the RTB database connected".
      END.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-stopPersistentProcs) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE stopPersistentProcs Procedure 
PROCEDURE stopPersistentProcs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(hScmTool)
    THEN DO:
        RUN killPlip IN hScmTool.
    END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-writeTransActionRecords) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE writeTransActionRecords Procedure 
PROCEDURE writeTransActionRecords :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Not required now as using XML mechanism
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-assignmentUnderway) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignmentUnderway Procedure 
FUNCTION assignmentUnderway RETURNS LOGICAL
  ( ip_remove AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE lv_buffer_handle        AS HANDLE NO-UNDO.
DEFINE VARIABLE lv_primary_key_values   AS CHARACTER.
DEFINE VARIABLE lv_idx                  AS INTEGER.
DEFINE VARIABLE lv_deletion_underway    AS LOGICAL.    
    
    
    
    DO lv_idx = 1 TO NUM-ENTRIES(ip_primary_key_fields):        
        IF lv_idx > 1 THEN lv_primary_key_values = lv_primary_key_values + CHR(3).
        lv_primary_key_values = lv_primary_key_values + getFieldValue(ip_table_buffer_handle, ENTRY(lv_idx,ip_primary_key_fields)).
    END.
    
        
    FIND FIRST rvt_action_underway EXCLUSIVE-LOCK
         WHERE rvt_action_underway.action_scm_object_name = lv_object_name
         AND   rvt_action_underway.action_type = "ASS"
         NO-ERROR.
    
    lv_deletion_underway = AVAILABLE rvt_action_underway.

    /****    
    MESSAGE {&line-number} PROGRAM-NAME(1) SKIP
        "Deletion Underway: " 
        lv_object_name SKIP
        lv_deletion_underway SKIP 
        ip_remove skip
        lv_primary_key_values SKIP 
        lv_arguments 
        VIEW-AS ALERT-BOX. 
    ****/

    IF lv_deletion_underway AND ip_remove THEN DELETE rvt_action_underway.
    
    RETURN lv_deletion_underway.
        
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deletionUnderway) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION deletionUnderway Procedure 
FUNCTION deletionUnderway RETURNS LOGICAL
  ( ip_remove AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE lv_buffer_handle        AS HANDLE NO-UNDO.
DEFINE VARIABLE lv_primary_key_values   AS CHARACTER.
DEFINE VARIABLE lv_idx                  AS INTEGER.
DEFINE VARIABLE lv_deletion_underway    AS LOGICAL.    
    
    
    
    DO lv_idx = 1 TO NUM-ENTRIES(ip_primary_key_fields):        
        IF lv_idx > 1 THEN lv_primary_key_values = lv_primary_key_values + CHR(3).
        lv_primary_key_values = lv_primary_key_values + getFieldValue(ip_table_buffer_handle, ENTRY(lv_idx,ip_primary_key_fields)).
    END.
    
        
    FIND FIRST rvt_action_underway 
         WHERE rvt_action_underway.action_table_fla = ip_primary_fla
         AND   rvt_action_underway.action_primary_key = lv_primary_key_values
         AND   rvt_action_underway.action_type = "DEL"
         NO-ERROR.
    
    lv_deletion_underway = AVAILABLE rvt_action_underway.
    
/* MESSAGE "Deletion Underway: " lv_deletion_underway SKIP lv_primary_key_values SKIP lv_arguments VIEW-AS ALERT-BOX. */

    IF lv_deletion_underway AND ip_remove THEN DELETE rvt_action_underway.
    
    RETURN lv_deletion_underway.
        
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFieldValue Procedure 
FUNCTION getFieldValue RETURNS CHARACTER
  ( ip_buffer_handle AS HANDLE,
    ip_description_fieldname AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE h_buffer_field AS HANDLE NO-UNDO.

    ASSIGN
        h_buffer_field = ip_buffer_handle:BUFFER-FIELD(ip_description_fieldname)
        NO-ERROR.
        
    IF ERROR-STATUS:ERROR THEN RETURN "".  /* field not found in buffer */
    
    IF VALID-HANDLE(h_buffer_field) 
        THEN RETURN h_buffer_field:BUFFER-VALUE().
        ELSE RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQuotedFieldValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQuotedFieldValue Procedure 
FUNCTION getQuotedFieldValue RETURNS CHARACTER
  ( ip_buffer_handle AS HANDLE,
    ip_description_fieldname AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE h_buffer_field AS HANDLE NO-UNDO.

    ASSIGN
        h_buffer_field = ip_buffer_handle:BUFFER-FIELD(ip_description_fieldname)
        NO-ERROR.
        
    IF ERROR-STATUS:ERROR THEN RETURN "".  /* field not found in buffer */
    
    IF VALID-HANDLE(h_buffer_field) THEN
    DO:
        IF h_buffer_field:DATA-TYPE = "CHARACTER"  
            THEN RETURN "'" + h_buffer_field:BUFFER-VALUE() + "'".
            ELSE RETURN h_buffer_field:BUFFER-VALUE().
    END.
    ELSE RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

