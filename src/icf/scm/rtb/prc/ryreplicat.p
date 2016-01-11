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

  (v:010007)    Task:    90000021   UserRef:    
                Date:   02/12/2002  Author:     Dynamics Admin User

  Update Notes: 

----------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

{af/sup2/afglobals.i}

/* Define RTB global shared variables - used for RTB integration hooks (if installed) */
DEFINE NEW GLOBAL SHARED VARIABLE grtb-wspace-id  AS CHARACTER    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE grtb-task-num   AS INTEGER      NO-UNDO.

&scop object-name       ryreplicat.p
DEFINE VARIABLE lv_this_object_name               AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010000


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

DEFINE INPUT PARAMETER ip_table_buffer_handle     AS HANDLE       NO-UNDO.
DEFINE INPUT PARAMETER ip_old_buffer_handle       AS HANDLE       NO-UNDO.
DEFINE INPUT PARAMETER ip_table_name              AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER ip_table_fla               AS CHARACTER    NO-UNDO.  
DEFINE INPUT PARAMETER ip_table_pk_fields         AS CHARACTER    NO-UNDO.             
DEFINE INPUT PARAMETER ip_action                  AS CHARACTER    NO-UNDO.   
DEFINE INPUT PARAMETER ip_new                     AS LOGICAL      NO-UNDO. 
DEFINE INPUT PARAMETER ip_primary_fla             AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER ip_primary_key_fields      AS CHARACTER    NO-UNDO.

DEFINE VARIABLE lActionUnderway                   AS LOGICAL      NO-UNDO.

DEFINE VARIABLE lv_workspace_obj                  AS DECIMAL      NO-UNDO.
DEFINE VARIABLE lv_task_number                    AS INTEGER      NO-UNDO.

DEFINE VARIABLE lv_workspace_code                 AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lv_creating_item                  AS LOGICAL      NO-UNDO.
DEFINE VARIABLE lv_deleting_item                  AS LOGICAL      NO-UNDO.
DEFINE VARIABLE lv_arguments                      AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lv_version_number                 AS INTEGER      NO-UNDO.
DEFINE VARIABLE lv_logical_db_name                AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lv_alias                          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lv_inherited_modification_type    AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lv_object_name                    AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lv_object_name_ext                AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lv_object_name_ado                AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lv_nulls_in_primary_key           AS LOGICAL      NO-UNDO.

DEFINE BUFFER lb_gsc_object             FOR gsc_object.

&SCOPED-DEFINE VER-INCREMENT   010000
&SCOPED-DEFINE REV-INCREMENT   000100
&SCOPED-DEFINE PAT-INCREMENT   000001

DEFINE VARIABLE hScmTool                          AS HANDLE       NO-UNDO.

DEFINE VARIABLE lv_error_status                   AS LOGICAL      NO-UNDO.
DEFINE VARIABLE lv_return_value                   AS CHARACTER    NO-UNDO.

DEFINE VARIABLE lv_scm_object_exists              AS LOGICAL      NO-UNDO.
DEFINE VARIABLE lv_scm_object_exists_in_ws        AS LOGICAL      NO-UNDO.
DEFINE VARIABLE lv_scm_version_in_workspace       AS INTEGER      NO-UNDO.
DEFINE VARIABLE lv_scm_checked_out_in_workspace   AS LOGICAL      NO-UNDO.
DEFINE VARIABLE lv_scm_version_task_number        AS INTEGER      NO-UNDO.
DEFINE VARIABLE lv_scm_highest_version            AS INTEGER      NO-UNDO.

{af/sup2/afcheckerr.i &define-only = YES}

/* Database logical name for primary table */
DEFINE VARIABLE gcDBName                          AS CHARACTER    NO-UNDO.

DEFINE VARIABLE lc_configuration_type             AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lc_type_table_name                AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lc_scm_identifying_fieldname      AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lc_scm_identifying_fieldext       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lc_scm_primary_key_fields         AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lc_description_fieldname          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lc_product_module_fieldname       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lc_object_type_fieldname          AS CHARACTER    NO-UNDO.

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
  ( ip_buffer_handle          AS HANDLE
  , ip_description_fieldname  AS CHARACTER
  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQuotedFieldValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQuotedFieldValue Procedure 
FUNCTION getQuotedFieldValue RETURNS CHARACTER
  ( ip_buffer_handle          AS HANDLE
  , ip_description_fieldname  AS CHARACTER
  )  FORWARD.

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
         HEIGHT             = 19.76
         WIDTH              = 52.2.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

ASSIGN
  lc_configuration_type         = "RYCSO":U
  lc_type_table_name            = "ryc_smartobject":U
  lc_scm_identifying_fieldname  = "object_filename":U
  lc_scm_identifying_fieldext   = "object_extension":U
  lc_scm_primary_key_fields     = "smartobject_obj":U
  lc_description_fieldname      = "object_filename"
  lc_product_module_fieldname   = "product_module_obj":U
  lc_object_type_fieldname      = "object_type_obj":U
  .

/* DO NOTHING IF NO RTB CONNECTED */
IF NOT CONNECTED("RTB":U)
THEN RETURN.

/* Check if SCM checks on */
FIND FIRST gsc_security_control NO-LOCK
  NO-ERROR.
IF AVAILABLE gsc_security_control
AND gsc_security_control.scm_checks_on = NO
THEN RETURN.

ASSIGN
  lv_arguments = "TableName="        + ip_table_name
               + "TableFLa="         + ip_table_fla
               + "TablePkFields="    + ip_table_pk_fields
               + "Action="           + ip_action
               + "New="              + STRING(ip_new)
               + "PrimaryFla="       + ip_primary_fla
               + "PrimaryKeyFields=" + ip_primary_key_fields
               .

/* ignore CREATE actions - this work is done on WRITE NEW */

/* remove extraneuous control characters put in there by ERwin */
RUN fixTablePkFields.

IF VALID-HANDLE(gshSessionManager)
THEN
  RUN getActionUnderway IN gshSessionManager
                       (INPUT  "SCM":U
                       ,INPUT  "ANY":U
                       ,INPUT  "":U
                       ,INPUT  "":U
                       ,INPUT  "":U
                       ,INPUT  NO
                       ,OUTPUT lActionUnderway).

IF lActionUnderway = YES
THEN RETURN.

IF deletionUnderway(FALSE)
AND ip_table_fla <> ip_primary_fla
THEN RETURN.

/* create trigger does nothing */
IF ip_action = "CREATE"
THEN DO:
  ASSIGN
    lv_return_value = lv_return_value
    NO-ERROR. /* clear error status */
  RETURN.    
END.

outer-block:
DO ON ERROR UNDO outer-block, RETURN RETURN-VALUE:

  RUN startPersistentProcs.
  IF RETURN-VALUE <> "":U
  THEN RETURN RETURN-VALUE.

  /* Set Action Underway for "DYN" */
  IF VALID-HANDLE(gshSessionManager)
  THEN
    RUN setActionUnderway IN gshSessionManager
                         (INPUT "DYN":U
                         ,INPUT ip_action
                         ,INPUT ""
                         ,INPUT ip_primary_fla
                         ,INPUT ip_primary_key_fields
                         ).

  RUN doReplication NO-ERROR.

  lv_error_status = ERROR-STATUS:ERROR.
  lv_return_value = RETURN-VALUE.

  /* Clear Action Underway for "DYN" */
  IF VALID-HANDLE(gshSessionManager)
  THEN DO:

    RUN getActionUnderway IN gshSessionManager
                         (INPUT  "DYN":U
                         ,INPUT ip_action
                         ,INPUT ""
                         ,INPUT ip_primary_fla
                         ,INPUT ip_primary_key_fields
                         ,INPUT  YES
                         ,OUTPUT lActionUnderway).

    IF ip_table_fla <> ip_primary_fla
    THEN DO:
      RUN getActionUnderway IN gshSessionManager
                           (INPUT "DYN":U
                           ,INPUT "DEL":U
                           ,INPUT lv_object_name
                           ,INPUT "RYCSO":U
                           ,INPUT "":U
                           ,INPUT  YES
                           ,OUTPUT lActionUnderway).
    END.

  END.

  RUN stopPersistentProcs.

  IF lv_error_status 
  THEN RETURN ERROR lv_return_value.
  ELSE RETURN lv_return_value.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-createItem) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createItem Procedure 
PROCEDURE createItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lv_product_module_obj       AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE lv_object_type_obj          AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE lv_object_description       AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE iRecid                      AS RECID      NO-UNDO.
  DEFINE VARIABLE cError                      AS CHARACTER  NO-UNDO.

  /* see if this item, which is new to the repository, exists in the SCM tool */
  RUN scmObjectExists.

  IF lv_scm_object_exists
  THEN DO:
    /* a couple of checks first */
    IF NOT lv_scm_object_exists_in_ws 
    THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '26' '?' '?' lv_object_name lv_workspace_code lv_arguments}.
          
    IF NOT lv_scm_checked_out_in_workspace 
    THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '27' '?' '?' lv_object_name lv_workspace_code lv_arguments}. 
         
    IF lv_scm_version_task_number <> lv_task_number 
    THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '28' '?' '?' lv_object_name lv_task_number lv_scm_version_task_number}.
  END.
  ELSE DO:
    /* before we create the workspace object we must ensire that a version record exists.
    Pre-existence of this item is not a problem */

    /* Find current version of object in the workspace */
    FIND FIRST rtb_object NO-LOCK
      WHERE rtb_object.wspace-id  = lv_workspace_code
      AND   rtb_object.obj-type   = "PCODE":U
      AND   rtb_object.object     = lv_object_name_ado
      NO-ERROR.
    IF NOT AVAILABLE rtb_object
    THEN DO:

      /* get product module */
      IF lc_product_module_fieldname <> ""
      THEN DO:
        /* determine the product module from the primary table buffer */
        lv_product_module_obj = DECIMAL(getFieldValue(ip_table_buffer_handle, lc_product_module_fieldname)).
      END.
      ELSE
        RETURN ERROR {af/sup2/aferrortxt.i 'RV' '14' '?' '?' lc_configuration_type lv_task_number lv_arguments}.
      FIND gsc_product_module no-lock
        WHERE gsc_product_module.product_module_obj = lv_product_module_obj
        NO-ERROR.

      /* get object type */
      IF lc_object_type_fieldname <> ""
      THEN DO:
        /* determine the product module from the primary table buffer */
        lv_object_type_obj = DECIMAL(getFieldValue(ip_table_buffer_handle, lc_object_type_fieldname)).
      END.
      ELSE
        RETURN ERROR {af/sup2/aferrortxt.i 'RV' '14' '?' '?' lc_configuration_type lv_task_number lv_arguments}.
      FIND gsc_object_type no-lock
        WHERE gsc_object_type.object_type_obj = lv_object_type_obj
        NO-ERROR.

      /* get object description */
      IF lc_description_fieldname <> ""
      THEN DO:
        /* determine the product module from the primary table buffer */
        lv_object_description = getFieldValue(ip_table_buffer_handle, lc_description_fieldname).
      END.
      ELSE
        RETURN ERROR {af/sup2/aferrortxt.i 'RV' '14' '?' '?' lc_configuration_type lv_task_number lv_arguments}.

      IF VALID-HANDLE(hScmTool)
      THEN DO:

        RUN scmCreateObjectControl IN hScmTool
                                  (INPUT lv_object_name
                                  ,INPUT "PCODE":U
                                  ,INPUT (IF AVAILABLE gsc_object_type    THEN gsc_object_type.object_type_code       ELSE "":U)
                                  ,INPUT (IF AVAILABLE gsc_product_module THEN gsc_product_module.product_module_code ELSE "":U)
                                  ,INPUT (IF AVAILABLE gsc_object_type    THEN gsc_object_type.object_type_code       ELSE "":U)
                                  ,INPUT "00000"
                                  ,INPUT lv_object_description
                                  ,INPUT "":U       /* ip_options                */
                                  ,INPUT lv_task_number
                                  ,INPUT NO         /* ip_ui_on                  */
                                  ,INPUT "central"  /* ip_share_status           */
                                  ,INPUT YES        /* ip_create_physical_file   */
                                  ,INPUT "":U       /* ip_physical_file_template */
                                  ,OUTPUT iRecid
                                  ,OUTPUT cError).
        IF cError <> "":U
        THEN RETURN ERROR cError.

      END.


    END.

  END.

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

  DEFINE VARIABLE cError                      AS CHARACTER  NO-UNDO.

  /* the user has chosen to delete the record in the Primary table which is this data item.
     In response we need to remove it from the workspace and notify the SCM tool that it has been
     removed.
  */
  /* see if this item, which should be in the repository, exists in the SCM tool */
  RUN scmObjectExists.

  IF NOT lv_scm_object_exists
  THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '26' '?' '?' lv_object_name lv_workspace_code lv_arguments}.
          
  IF NOT lv_scm_object_exists_in_ws 
  THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '26' '?' '?' lv_object_name lv_workspace_code lv_arguments}.

  IF VALID-HANDLE(hScmTool)
  THEN DO:
    RUN scmDeleteObjectControl IN hScmTool
                              (INPUT rtb_object.pmod
                              ,INPUT "PCODE":U
                              ,INPUT rtb_object.object
                              ,INPUT lv_task_number
                              ,INPUT "no-prompt"  /* ip_params */
                              ,OUTPUT cError).
      
      IF cError <> "":U
      THEN RETURN ERROR cError.
  END.

  /*
  We may experience timing issues to do with item deletions.
  For instance, is the REPLICATION-DELETE trigger on the primary table ALWAYS the last REPLICATION trigger to fire
  in the case of a ParentDelete=Cascade scenario?
  This may later cause us to "mark an item for deletion" as opposed to actually deleting it at this time.
  */

  ERROR-STATUS:ERROR = NO.

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

  DEFINE VARIABLE lv_buffer_handle      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lv_query_handle       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lv_query_string       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lv_idx                AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lv_ok                 AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE cOldObjectName        AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cNewObjectName        AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE dOldProductModule     AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dNewProductModule     AS DECIMAL    NO-UNDO.

  IF ip_table_fla = ip_primary_fla
  THEN DO:

    /*
    this is the primary table - no need to open a query.
    Indeed we cannot open a query because this would fail to find the record if it is being deleted
    */

    ASSIGN
      lv_nulls_in_primary_key = FALSE  /* although there were nulls we have found a corresponding record, so continue. */
      gcDBName                = ip_table_buffer_handle:DBNAME
      cNewObjectName          = getFieldValue(ip_table_buffer_handle, lc_scm_identifying_fieldname)
      lv_object_name          = cNewObjectName
      .

    IF VALID-HANDLE(ip_old_buffer_handle)
    AND CAN-QUERY(ip_old_buffer_handle,"available":U)
    AND ip_old_buffer_handle:AVAILABLE = TRUE
    THEN ASSIGN cOldObjectName = getFieldValue(ip_old_buffer_handle, lc_scm_identifying_fieldname).
    ELSE ASSIGN cOldObjectName = cNewObjectName.

    IF cOldObjectName = "":U
    OR cOldObjectName = ?
    THEN
      ASSIGN
        cOldObjectName = cNewObjectName.

    /* PM? - Should we rename in RTB  */
    IF  cNewObjectName <> ?
    AND cNewObjectName <> "":U
    AND cNewObjectName <> cOldObjectName
    THEN RETURN ERROR {af/sup2/aferrortxt.i 'AF' '110' '?' '?' cOldObjectName cNewObjectName lv_arguments}.

    IF lc_product_module_fieldname <> "":U
    THEN DO:
      
      ASSIGN
        dNewProductModule = DECIMAL(getFieldValue(ip_table_buffer_handle, lc_product_module_fieldname)).
  
      IF VALID-HANDLE(ip_old_buffer_handle)
      AND CAN-QUERY(ip_old_buffer_handle,"available":U)
      AND ip_old_buffer_handle:AVAILABLE = TRUE
      THEN
        ASSIGN
          dOldProductModule = DECIMAL(getFieldValue(ip_old_buffer_handle, lc_product_module_fieldname)).
      ELSE
        ASSIGN
          dOldProductModule = dNewProductModule.

    END.
    ELSE
      ASSIGN
        dNewProductModule = 0
        dOldProductModule = 0
        .

    /* We cannot move product module in RTB  */
    IF  dNewProductModule <> ?
    AND dNewProductModule <> 0
    AND dOldProductModule <> 0
    AND dOldProductModule <> ?
    AND dNewProductModule <> dOldProductModule
    THEN RETURN ERROR {af/sup2/aferrortxt.i 'AF' '110' '?' '?' dOldProductModule dNewProductModule lv_arguments}.

    RETURN.

  END.

  CREATE BUFFER lv_buffer_handle FOR TABLE lc_type_table_name.
  ASSIGN
    gcDBName = lv_buffer_handle:DBNAME.

  ASSIGN
    lv_query_string = "FOR EACH " + lc_type_table_name + " NO-LOCK WHERE ".

  DO lv_idx = 1 TO NUM-ENTRIES(ip_primary_key_fields):
    ASSIGN
      lv_nulls_in_primary_key = LOOKUP(getQuotedFieldValue(ip_table_buffer_handle, ENTRY(lv_idx,ip_primary_key_fields)),",?,0") > 0.
    IF lv_idx > 1
    THEN
      ASSIGN
        lv_query_string = lv_query_string + " AND ".
    ASSIGN
      lv_query_string = lv_query_string + lc_type_table_name + "." + ENTRY(lv_idx,lc_scm_primary_key_fields) + " = " + getQuotedFieldValue(ip_table_buffer_handle, ENTRY(lv_idx,ip_primary_key_fields)) + " ".                                                                                                                                  
  END.

  DO ON ERROR UNDO, RETURN ERROR {af/sup2/aferrortxt.i 'RV' '19' '?' '?' lv_query_string lc_scm_identifying_fieldname lv_arguments}:

    CREATE QUERY lv_query_handle.

    ASSIGN
      lv_ok = lv_query_handle:SET-BUFFERS(lv_buffer_handle)
      NO-ERROR.
    IF NOT lv_ok
    THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '19' '?' '?' lv_query_string lc_scm_identifying_fieldname lv_arguments}.

    lv_query_string = DYNAMIC-FUNCTION("fixQueryString":U IN gshSessionManager, INPUT lv_query_string).
    ASSIGN
      lv_ok = lv_query_handle:QUERY-PREPARE(lv_query_string)
      NO-ERROR.
    IF NOT lv_ok
    THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '19' '?' '?' lv_query_string lc_scm_identifying_fieldname lv_arguments}.

    ASSIGN
      lv_ok = lv_query_handle:QUERY-OPEN()
      NO-ERROR.
    IF NOT lv_ok
    THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '19' '?' '?' lv_query_string lc_scm_identifying_fieldname lv_arguments}.

    ASSIGN
      lv_ok = lv_query_handle:GET-FIRST()
      NO-ERROR.

  END.

  IF NOT lv_buffer_handle:AVAILABLE
  THEN DO:
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
      RETURN ERROR {af/sup2/aferrortxt.i 'RV' '20' '?' '?' lv_query_string lc_scm_identifying_fieldname lv_arguments}.
    END.

    RETURN ERROR {af/sup2/aferrortxt.i 'RV' '19' '?' '?' lv_query_string lc_scm_identifying_fieldname lv_arguments}.

  END.

  ASSIGN
   lv_object_name          = getFieldValue(lv_buffer_handle, lc_scm_identifying_fieldname)
   lv_nulls_in_primary_key = FALSE  /* although there were nulls we have found a corresponding record, so continue. */
   .

  /* cleanup dynamic query */        
  lv_buffer_handle:BUFFER-RELEASE() NO-ERROR.

  /* For some reason this handle is sometimes invalid when creating Dynamic Objects */
  IF VALID-HANDLE(lv_query_handle)
  THEN DO:
    lv_query_handle:QUERY-CLOSE().
    DELETE OBJECT lv_query_handle.
  END.

  DELETE OBJECT lv_buffer_handle.

  ASSIGN
    lv_buffer_handle = ?
    lv_query_handle  = ?
    .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-determineObjectNameExt) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE determineObjectNameExt Procedure 
PROCEDURE determineObjectNameExt :
/*------------------------------------------------------------------------------
  Purpose:     work out object name either from table if primary table else
               using dynamic query to get record and obtain name from field
               on table.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hBufferHandle         AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQueryHandle          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cQueryString          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lQueryOK              AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE cQueryObjectFullName  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryObjectName      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryObjectExt       AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cQueryTableName       AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cQueryObjectFieldName AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cQueryObjectFieldExt  AS CHARACTER    NO-UNDO.

  ASSIGN
    cQueryTableName        = "gsc_object":U
    cQueryObjectFieldName  = "object_filename":U
    cQueryObjectFieldExt   = "object_extension":U
    cQueryObjectFullName   = lv_object_name
    cQueryObjectName       = lv_object_name
    cQueryObjectExt        = "":U.
    .

  CREATE BUFFER hBufferHandle FOR TABLE cQueryTableName.
  ASSIGN
    gcDBName = hBufferHandle:DBNAME.

  ASSIGN
    cQueryString = "FOR EACH " + cQueryTableName + " NO-LOCK "
                 + "  WHERE "  + cQueryTableName + "." + cQueryObjectFieldName
                 + " = "       + '"' + cQueryObjectFullName + '"'
                 + " ".
  DO ON ERROR UNDO, RETURN ERROR {af/sup2/aferrortxt.i 'RV' '19' '?' '?' cQueryString cQueryObjectFieldName lv_arguments}:

    CREATE QUERY hQueryHandle.

    ASSIGN
      lQueryOK = hQueryHandle:SET-BUFFERS(hBufferHandle)
      NO-ERROR.
    IF NOT lQueryOK
    THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '19' '?' '?' cQueryString cQueryObjectFieldName lv_arguments}.

    cQueryString = DYNAMIC-FUNCTION("fixQueryString":U IN gshSessionManager, INPUT cQueryString).
    ASSIGN
      lQueryOK = hQueryHandle:QUERY-PREPARE(cQueryString)
      NO-ERROR.
    IF NOT lQueryOK
    THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '19' '?' '?' cQueryString cQueryObjectFieldName lv_arguments}.

    ASSIGN
      lQueryOK = hQueryHandle:QUERY-OPEN()
      NO-ERROR.
    IF NOT lQueryOK
    THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '19' '?' '?' cQueryString cQueryObjectFieldName lv_arguments}.

    ASSIGN
      lQueryOK = hQueryHandle:GET-FIRST()
      NO-ERROR.

  END.

  IF NOT hBufferHandle:AVAILABLE
  THEN DO:
    /* cleanup dynamic query */

    hBufferHandle:BUFFER-RELEASE() NO-ERROR.
    hQueryHandle:QUERY-CLOSE().
    DELETE OBJECT hQueryHandle.
    DELETE OBJECT hBufferHandle.
    ASSIGN
      hBufferHandle = ?
      hQueryHandle  = ?
      .

    RETURN ERROR {af/sup2/aferrortxt.i 'RV' '19' '?' '?' cQueryString cQueryObjectFieldName lv_arguments}.

  END.

  ASSIGN
    cQueryObjectName = getFieldValue(hBufferHandle, cQueryObjectFieldName)
    cQueryObjectExt  = getFieldValue(hBufferHandle, cQueryObjectFieldExt)
    .
  IF cQueryObjectExt <> "":U
  THEN ASSIGN cQueryObjectFullName = cQueryObjectName + "." + cQueryObjectExt.
  ELSE ASSIGN cQueryObjectFullName = cQueryObjectName.

  ASSIGN
    lv_object_name     = cQueryObjectFullName
    lv_object_name_ext = cQueryObjectExt
    .

  /* cleanup dynamic query */        
  hBufferHandle:BUFFER-RELEASE() NO-ERROR.

  /* For some reason this handle is sometimes invalid when creating Dynamic Objects */
  IF VALID-HANDLE(hQueryHandle)
  THEN DO:
    hQueryHandle:QUERY-CLOSE().
    DELETE OBJECT hQueryHandle.
  END.

  DELETE OBJECT hBufferHandle.

  ASSIGN
    hBufferHandle = ?
    hQueryHandle  = ?
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

  DEFINE VARIABLE cScmTaskNumber              AS INTEGER INITIAL 0 NO-UNDO.
  DEFINE VARIABLE cScmTaskSummary             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cScmTaskDescription         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cScmTaskProgrammer          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cScmTaskUserref             AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cScmTaskWorkspace           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cScmTaskEnteredDate         AS DATE       NO-UNDO.
  DEFINE VARIABLE cScmTaskStatus              AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cScmTaskOpen                AS LOGICAL    NO-UNDO.

  /* and we need to know the user's "current" task */

  IF VALID-HANDLE(hScmTool)
  THEN DO:
    RUN scmGetTaskInfo IN hScmTool
                      (INPUT-OUTPUT cScmTaskNumber
                      ,OUTPUT cScmTasksummary
                      ,OUTPUT cScmTaskdescription
                      ,OUTPUT cScmTaskProgrammer
                      ,OUTPUT cScmTaskUserref
                      ,OUTPUT cScmTaskWorkspace
                      ,OUTPUT cScmTaskEntereddate
                      ,OUTPUT cScmTaskStatus
                      ).
  END.

  ASSIGN
    lv_task_number = cScmTaskNumber
    cScmTaskOpen   = (cScmTaskstatus = "W") /* W = Work in progress */
    .

  IF lv_task_number = ? 
  THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '5' '?' '?' lv_arguments}.

  IF NOT cScmTaskOpen        
  THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '25' '?' '?' lv_arguments}.

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
  ASSIGN
    lv_workspace_code = Grtb-wspace-id.

  IF lv_workspace_code = ?
  OR lv_workspace_code = ""
  THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '2' '?' '?' lv_arguments}.

  ASSIGN
    lv_arguments = lv_arguments + "~nWORKSPACE='" + lv_workspace_code + "'".

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
  Notes:       Replication of objects are as follows
  
     CREATE :  Nothing, this will be handled by the WRITE section

     WRITE  :  Find the RTB object else create the record
               Checkout the object in the current workspace

     DELETE :  Find the RTB object
               Delete object records from workspace

     UPDATE :

------------------------------------------------------------------------------*/

  DO ON ERROR UNDO, RETURN ERROR RETURN-VALUE:

    /* Determine the action to follow */
    ASSIGN    
      lv_creating_item = (ip_action = "WRITE"  AND ip_table_fla = ip_primary_fla AND ip_new )
      lv_deleting_item = (ip_action = "DELETE" AND ip_table_fla = ip_primary_fla)
      .

    /* First we need to determine the object name */
    RUN determineObjectName.
    RUN determineObjectNameExt.

    /* do nothing if doing an assignment */
    IF assignmentUnderway(FALSE)
    THEN RETURN.

    /* Some of the involved tables have nulls-allowed relationships to the primary table. We return if the primary key is null.*/
    IF lv_nulls_in_primary_key
    THEN RETURN.

    /* We need to determine the Workspace */
    RUN determineWorkspace.
    IF RETURN-VALUE <> "":U
    THEN RETURN ERROR RETURN-VALUE.

    /* We need to determine the Task */
    RUN determineTask.
    IF RETURN-VALUE <> "":U
    THEN RETURN ERROR RETURN-VALUE.

    ASSIGN
      lv_object_name_ado = lv_object_name.
    IF VALID-HANDLE(hScmTool)
    THEN
      RUN scmADOExtAdd IN hScmTool (INPUT-OUTPUT lv_object_name_ado).

    /* now check for availability of the RTB object itself in the designated workspace */
    FIND FIRST rtb_object NO-LOCK
      WHERE rtb_object.wspace-id  = lv_workspace_code
      AND   rtb_object.obj-type   = "PCODE":U
      AND   rtb_object.object     = lv_object_name_ado
      NO-ERROR.

/*
{af/sup/afdebug.i}
MESSAGE
  SKIP lv_object_name
  SKIP lv_object_name_ext
  SKIP lv_object_name_ado
  SKIP AVAILABLE(rtb_object)
  SKIP "ACT  " ip_action
  SKIP "CRE  " lv_creating_item
  SKIP "DEL  " lv_deleting_item
  SKIP "WORK " lv_workspace_code
  SKIP "TASK " lv_task_number
  VIEW-AS ALERT-BOX INFORMATION.
*/  

    IF lv_creating_item
    THEN DO:

      RUN createItem NO-ERROR.
      IF RETURN-VALUE <> "":U
      OR ERROR-STATUS:ERROR
      THEN RETURN ERROR RETURN-VALUE.

    END. /* creating the item */
    ELSE
    IF lv_deleting_item
    THEN DO:   

      IF AVAILABLE (rtb_object)
      THEN DO:

        RUN deleteItem NO-ERROR.
        IF RETURN-VALUE <> "":U
        OR ERROR-STATUS:ERROR
        THEN RETURN ERROR RETURN-VALUE.

      END.
      ELSE DO:
        /* attempt to delete data in the repository when we have no record of it existing in that workspace  - let the deletion proceed */
      END.
      deletionUnderway(TRUE).

    END. /* item pre-exists */
    ELSE DO:

      IF NOT AVAILABLE (rtb_object) 
      THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '11' '?' '?' ip_primary_fla lv_object_name lv_workspace_code lv_arguments}.

      FIND FIRST rtb_ver NO-LOCK
        WHERE rtb_ver.obj-type = rtb_object.obj-type
        AND rtb_ver.object     = rtb_object.object
        AND rtb_ver.pmod       = rtb_object.pmod
        AND rtb_ver.version    = rtb_object.version
        NO-ERROR.

      IF NOT AVAILABLE rtb_ver
      THEN RETURN ERROR  {af/sup2/aferrortxt.i 'RV' '7' '?' '?' ip_primary_fla rtb_object.object lv_arguments}.

      RUN updateItem NO-ERROR.
      IF RETURN-VALUE <> "":U
      OR ERROR-STATUS:ERROR
      THEN RETURN ERROR RETURN-VALUE.

    END.

    /* successful completion */
    ERROR-STATUS:ERROR = FALSE.
    RETURN.
      
  END. /* do on error undo, return return-value */

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

  ASSIGN
    ip_table_pk_fields = REPLACE(REPLACE(REPLACE(ip_table_pk_fields," ",""),CHR(13),""),CHR(10),"").

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

  IF VALID-HANDLE(hScmTool)
  THEN DO:

    RUN scmObjectExists IN hScmTool
                       (INPUT  lv_object_name_ado
                       ,INPUT  lv_workspace_code
                       ,OUTPUT lv_scm_object_exists
                       ,OUTPUT lv_scm_object_exists_in_ws
                       ,OUTPUT lv_scm_version_in_workspace
                       ,OUTPUT lv_scm_checked_out_in_workspace
                       ,OUTPUT lv_scm_version_task_number
                       ,OUTPUT lv_scm_highest_version
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

  IF CONNECTED("rtb":U)
  AND NOT VALID-HANDLE(hScmTool)
  AND (SEARCH("rtb/prc/afrtbprocp.p":U) <> ?
    OR SEARCH("rtb/prc/afrtbprocp.p":U) <> ?)
  THEN
    RUN rtb/prc/afrtbprocp.p PERSISTENT SET hScmTool.

  IF NOT VALID-HANDLE(hScmTool)
  THEN DO:
    RETURN ERROR "Could not start SCM procedure (rtb/prc/afrtbprocp.p) for Roundtable API".
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

&IF DEFINED(EXCLUDE-updateItem) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateItem Procedure 
PROCEDURE updateItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iRecid                      AS RECID      NO-UNDO.
  DEFINE VARIABLE cError                      AS CHARACTER  NO-UNDO.

  /* Is the record checked out ? */ 

  RUN scmObjectExists.

  IF NOT lv_scm_object_exists_in_ws
  THEN
    RETURN ERROR {af/sup2/aferrortxt.i 'RV' '24' '?' '?' lv_object_name lv_workspace_code lv_arguments}.

  IF lv_scm_checked_out_in_workspace
  THEN DO:
    /* the item is checked out explicitly */
    IF lv_scm_version_task_number <> lv_task_number 
    THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '12' '?' '?' ip_primary_fla lv_object_name lv_task_number lv_scm_version_task_number lv_arguments}.
    /* this item is explicitly checked out */
  END.
  ELSE DO:
    /* Checkout the item */
    IF VALID-HANDLE(hScmTool)
    THEN DO:
      RUN scmCheckOutObjectControl IN hScmTool
                                  (INPUT "patch":U
                                  ,INPUT rtb_object.pmod
                                  ,INPUT "PCODE":U
                                  ,INPUT rtb_object.object
                                  ,INPUT lv_task_number
                                  ,INPUT NO /* ip_ui_on */
                                  ,INPUT NO /* ip_allow_nonprimary */
                                  ,INPUT NO /* ip_allow_orphans */
                                  ,OUTPUT iRecid
                                  ,OUTPUT cError).
      IF cError <> "":U
      THEN RETURN ERROR cError.

    END.

  END.

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
  DEFINE VARIABLE lv_assignment_underway  AS LOGICAL.    

  DO lv_idx = 1 TO NUM-ENTRIES(ip_primary_key_fields):        
    IF lv_idx > 1 THEN lv_primary_key_values = lv_primary_key_values + CHR(3).
    lv_primary_key_values = lv_primary_key_values + getFieldValue(ip_table_buffer_handle, ENTRY(lv_idx,ip_primary_key_fields)).
  END.

  RUN getActionUnderway IN gshSessionManager
                       (INPUT  "DYN":U
                       ,INPUT  "ASS":U
                       ,INPUT  lv_object_name
                       ,INPUT  "":U
                       ,INPUT  "":U
                       ,INPUT  ip_remove
                       ,OUTPUT lv_assignment_underway).

  RETURN lv_assignment_underway.

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

  DEFINE VARIABLE lv_buffer_handle        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lv_primary_key_values   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lv_idx                  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lv_deletion_underway    AS LOGICAL    NO-UNDO.

  DO lv_idx = 1 TO NUM-ENTRIES(ip_primary_key_fields):        
    IF lv_idx > 1 THEN lv_primary_key_values = lv_primary_key_values + CHR(3).
    lv_primary_key_values = lv_primary_key_values + getFieldValue(ip_table_buffer_handle, ENTRY(lv_idx,ip_primary_key_fields)).
  END.

  RUN getActionUnderway IN gshSessionManager
                       (INPUT  "DYN":U
                       ,INPUT  "DEL":U
                       ,INPUT  "":U
                       ,INPUT  ip_primary_fla
                       ,INPUT  lv_primary_key_values
                       ,INPUT  ip_remove
                       ,OUTPUT lv_deletion_underway).

  RETURN lv_deletion_underway.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFieldValue Procedure 
FUNCTION getFieldValue RETURNS CHARACTER
  ( ip_buffer_handle          AS HANDLE
  , ip_description_fieldname  AS CHARACTER
  ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE h_buffer_field AS HANDLE NO-UNDO.

  ASSIGN
    h_buffer_field = ip_buffer_handle:BUFFER-FIELD(ip_description_fieldname)
    NO-ERROR.

  IF ERROR-STATUS:ERROR
  THEN RETURN "".  /* field not found in buffer */

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
  ( ip_buffer_handle          AS HANDLE
  , ip_description_fieldname  AS CHARACTER
  ) :
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
  THEN DO:
    IF h_buffer_field:DATA-TYPE = "CHARACTER"  
    THEN RETURN "'" + h_buffer_field:BUFFER-VALUE() + "'".
    ELSE RETURN       h_buffer_field:BUFFER-VALUE().
  END.
  ELSE RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

