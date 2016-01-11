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
  File: ryreplicat.p

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

{src/adm2/globals.i}

/* Define RTB global shared variables - used for RTB integration hooks (if installed) */
DEFINE NEW GLOBAL SHARED VARIABLE grtb-wspace-id  AS CHARACTER    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE grtb-task-num   AS INTEGER      NO-UNDO.

&scop object-name       ryreplicat.p
DEFINE VARIABLE lv_this_object_name               AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010002


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

DEFINE INPUT PARAMETER phTableBufferHandle        AS HANDLE       NO-UNDO.
DEFINE INPUT PARAMETER phOldBufferHandle          AS HANDLE       NO-UNDO.
DEFINE INPUT PARAMETER pcTableName                AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER pcTableFla                 AS CHARACTER    NO-UNDO.  
DEFINE INPUT PARAMETER pcTablePkFields            AS CHARACTER    NO-UNDO.             
DEFINE INPUT PARAMETER pcAction                   AS CHARACTER    NO-UNDO.   
DEFINE INPUT PARAMETER lNew                       AS LOGICAL      NO-UNDO. 
DEFINE INPUT PARAMETER pcPrimaryFla               AS CHARACTER    NO-UNDO.
DEFINE INPUT PARAMETER pcPrimaryKeyFields         AS CHARACTER    NO-UNDO.

DEFINE VARIABLE lActionUnderway                   AS LOGICAL      NO-UNDO.

DEFINE VARIABLE dWorkspace_obj                    AS DECIMAL      NO-UNDO.
DEFINE VARIABLE iTaskNumber                       AS INTEGER      NO-UNDO.

DEFINE VARIABLE cWorkspaceCode                    AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lCreatingItem                     AS LOGICAL      NO-UNDO.
DEFINE VARIABLE lDeletingItem                     AS LOGICAL      NO-UNDO.
DEFINE VARIABLE cArguments                        AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iVersionNumber                    AS INTEGER      NO-UNDO.
DEFINE VARIABLE lLogicalDbName                    AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cAlias                            AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cInheritedModificationType        AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cObjectName                       AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cObjectName_ext                   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cObjectName_ado                   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cObjectDescription                AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lNullsInPrimaryKey                AS LOGICAL      NO-UNDO.

DEFINE BUFFER lb_ryc_smartobject             FOR ryc_smartobject.

&SCOPED-DEFINE VER-INCREMENT   010000
&SCOPED-DEFINE REV-INCREMENT   000100
&SCOPED-DEFINE PAT-INCREMENT   000001

DEFINE VARIABLE hScmTool                          AS HANDLE       NO-UNDO.

DEFINE VARIABLE lErrorStatus                      AS LOGICAL      NO-UNDO.
DEFINE VARIABLE cReturnValue                      AS CHARACTER    NO-UNDO.

DEFINE VARIABLE lScmObjectExists                  AS LOGICAL      NO-UNDO.
DEFINE VARIABLE lScmObjectExistsInWs              AS LOGICAL      NO-UNDO.
DEFINE VARIABLE iScmVersionInWorkspace            AS INTEGER      NO-UNDO.
DEFINE VARIABLE lScmCheckedOutInWorkspace         AS LOGICAL      NO-UNDO.
DEFINE VARIABLE iScmVersionTaskNumber             AS INTEGER      NO-UNDO.
DEFINE VARIABLE iScmHighestVersion                AS INTEGER      NO-UNDO.

{checkerr.i &define-only = YES}

/* Database logical name for primary table */
DEFINE VARIABLE gcDBName                          AS CHARACTER    NO-UNDO.
                                                
DEFINE VARIABLE cConfigurationType                AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cTypeTableName                    AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cScmIdentifyingFieldname          AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cScmIdentifyingFieldext           AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cScmPrimaryKeyFields              AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cDescriptionFieldname             AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cProductModuleFieldname           AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cObjectTypeFieldname              AS CHARACTER    NO-UNDO.

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
  cConfigurationType          = "RYCSO":U
  cTypeTableName              = "ryc_smartobject":U
  cScmIdentifyingFieldname    = "object_filename":U
  cScmIdentifyingFieldext     = "object_extension":U
  cScmPrimaryKeyFields        = "smartobject_obj":U
  cDescriptionFieldname       = "object_description"
  cProductModuleFieldname     = "product_module_obj":U
  cObjectTypeFieldname        = "object_type_obj":U
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
  cArguments = "TableName="          + pcTableName          + "~n"
               + "TableFLa="         + pcTableFla           + "~n"
               + "TablePkFields="    + pcTablePkFields      + "~n"
               + "Action="           + pcAction             + "~n"
               + "New="              + STRING(lNew)         + "~n"
               + "PrimaryFla="       + pcPrimaryFla         + "~n"
               + "PrimaryKeyFields=" + pcPrimaryKeyFields   + "~n"
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

IF lActionUnderway = YES THEN RETURN.

IF deletionUnderway(FALSE)
AND pcTableFla <> pcPrimaryFla
THEN RETURN.

/* create trigger does nothing */
IF pcAction = "CREATE"
THEN DO:
  ASSIGN
    cReturnValue = cReturnValue
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
                         ,INPUT pcAction
                         ,INPUT ""
                         ,INPUT pcPrimaryFla
                         ,INPUT pcPrimaryKeyFields
                         ).

  RUN doReplication NO-ERROR.

  lErrorStatus = ERROR-STATUS:ERROR.
  cReturnValue = RETURN-VALUE.

  /* Clear Action Underway for "DYN" */
  IF VALID-HANDLE(gshSessionManager)
  THEN DO:

    RUN getActionUnderway IN gshSessionManager
                         (INPUT  "DYN":U
                         ,INPUT pcAction
                         ,INPUT ""
                         ,INPUT pcPrimaryFla
                         ,INPUT pcPrimaryKeyFields
                         ,INPUT  YES
                         ,OUTPUT lActionUnderway).

    IF pcTableFla <> pcPrimaryFla
    THEN DO:
      RUN getActionUnderway IN gshSessionManager
                           (INPUT "DYN":U
                           ,INPUT "DEL":U
                           ,INPUT cObjectName
                           ,INPUT "RYCSO":U
                           ,INPUT "":U
                           ,INPUT  YES
                           ,OUTPUT lActionUnderway).
    END.

  END.

  RUN stopPersistentProcs.

  IF lErrorStatus 
  THEN RETURN ERROR cReturnValue.
  ELSE RETURN cReturnValue.

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

  DEFINE VARIABLE dProductModuleObj         AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE dObjectTypeObj            AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cObjectDescription        AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE iRecid                    AS RECID      NO-UNDO.
  DEFINE VARIABLE cError                    AS CHARACTER  NO-UNDO.

  /* see if this item, which is new to the repository, exists in the SCM tool */
  RUN scmObjectExists.

  IF lScmObjectExists
  THEN DO:
    /* a couple of checks first */
    IF NOT lScmObjectExistsInWs 
    THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '26' '?' '?' cObjectName cWorkspaceCode cArguments}.
          
    IF NOT lScmCheckedOutInWorkspace 
    THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '27' '?' '?' cObjectName cWorkspaceCode cArguments}. 
         
    IF iScmVersionTaskNumber <> iTaskNumber 
    THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '28' '?' '?' cObjectName iTaskNumber iScmVersionTaskNumber}.
  END.
  ELSE DO:
    /* before we create the workspace object we must ensure that a version record exists.
    Pre-existence of this item is not a problem */

    /* Find current version of object in the workspace */
    FIND FIRST rtb_object NO-LOCK
      WHERE rtb_object.wspace-id  = cWorkspaceCode
      AND   rtb_object.obj-type   = "PCODE":U
      AND   rtb_object.object     = cObjectName_ado
      NO-ERROR.
    IF NOT AVAILABLE rtb_object
    THEN DO:

      /* get product module */
      IF cProductModuleFieldname <> ""
      THEN DO:
        /* determine the product module from the primary table buffer */
        dProductModuleObj = DECIMAL(getFieldValue(phTableBufferHandle, cProductModuleFieldname)).
      END.
      ELSE
        RETURN ERROR {af/sup2/aferrortxt.i 'RV' '14' '?' '?' cConfigurationType iTaskNumber cArguments}.
      FIND gsc_product_module no-lock
        WHERE gsc_product_module.product_module_obj = dProductModuleObj
        NO-ERROR.

      /* get object type */
      IF cObjectTypeFieldname <> ""
      THEN DO:
        /* determine the product module from the primary table buffer */
        dObjectTypeObj = DECIMAL(getFieldValue(phTableBufferHandle, cObjectTypeFieldname)).
      END.
      ELSE
        RETURN ERROR {af/sup2/aferrortxt.i 'RV' '14' '?' '?' cConfigurationType iTaskNumber cArguments}.
      FIND gsc_object_type no-lock
        WHERE gsc_object_type.object_type_obj = dObjectTypeObj
        NO-ERROR.

      /* get object description */
      IF cDescriptionFieldname <> ""
      THEN DO:
        /* determine the product module from the primary table buffer */
        cObjectDescription = getFieldValue(phTableBufferHandle, cDescriptionFieldname).
        
        /* If the Object Description is blank when the object is created, then set the description 
           to be the same as the Object Name  */
        IF cObjectDescription = "":U THEN
        cObjectDescription = getFieldValue(phTableBufferHandle, cScmIdentifyingFieldname).
      END.
      ELSE
        RETURN ERROR {af/sup2/aferrortxt.i 'RV' '14' '?' '?' cConfigurationType iTaskNumber cArguments}.

      IF VALID-HANDLE(hScmTool)
      THEN DO:
        RUN scmCreateObjectControl IN hScmTool
                                  (INPUT cObjectName
                                  ,INPUT "PCODE":U
                                  ,INPUT (IF AVAILABLE gsc_object_type    THEN gsc_object_type.object_type_code       ELSE "":U)
                                  ,INPUT (IF AVAILABLE gsc_product_module THEN gsc_product_module.product_module_code ELSE "":U)
                                  ,INPUT (IF AVAILABLE gsc_object_type    THEN gsc_object_type.object_type_code       ELSE "":U)
                                  ,INPUT "00000"
                                  ,INPUT cObjectDescription
                                  ,INPUT "":U       /* ip_options                */
                                  ,INPUT iTaskNumber
                                  ,INPUT NO         /* ip_ui_on                  */
                                  ,INPUT "central"  /* ip_share_status           */
                                  ,INPUT YES        /* ip_create_physical_file   */
                                  ,INPUT "":U       /* ip_physical_file_template */
                                  ,OUTPUT iRecid
                                  ,OUTPUT cError).
        IF cError <> "":U
        THEN RETURN ERROR cError.

      END. /* IF VALID-HANDLE(hScmTool) ...*/
    END. /* IF NOT AVAILABLE rtb_object ...*/
  END. /* IF lScmObjectExists ...*/

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

  IF NOT lScmObjectExists
  THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '26' '?' '?' cObjectName cWorkspaceCode cArguments}.
          
  IF NOT lScmObjectExistsInWs 
  THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '26' '?' '?' cObjectName cWorkspaceCode cArguments}.

  IF VALID-HANDLE(hScmTool)
  THEN DO:
    RUN scmDeleteObjectControl IN hScmTool
                              (INPUT rtb_object.pmod
                              ,INPUT "PCODE":U
                              ,INPUT rtb_object.object
                              ,INPUT iTaskNumber
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
  DEFINE VARIABLE hBufferHandle          AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cWhereString           AS CHARACTER  NO-UNDO.  
  DEFINE VARIABLE iIdx                   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lOk                    AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE cOldObjectName         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cNewObjectName         AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE dOldProductModule      AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cOldProductModuleCode  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE dNewProductModule      AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cNewProductModuleCode  AS CHARACTER  NO-UNDO.
    
  IF pcTableFla = pcPrimaryFla
  THEN DO:
    /*
    this is the primary table - no need to open a query.
    Indeed we cannot open a query because this would fail to find the record if it is being deleted
    */

    ASSIGN
      lNullsInPrimaryKey = FALSE  /* although there were nulls we have found a corresponding record, so continue. */
      gcDBName           = phTableBufferHandle:DBNAME
      cNewObjectName     = getFieldValue(phTableBufferHandle, cScmIdentifyingFieldname)
      cObjectName        = cNewObjectName
      .

    IF VALID-HANDLE(phOldBufferHandle)
    AND CAN-QUERY(phOldBufferHandle,"AVAILABLE":U)
    AND phOldBufferHandle:AVAILABLE = TRUE
    THEN ASSIGN cOldObjectName = getFieldValue(phOldBufferHandle, cScmIdentifyingFieldname).
    ELSE ASSIGN cOldObjectName = cNewObjectName.

    IF cOldObjectName = "":U
    OR cOldObjectName = ?
    THEN
      ASSIGN
        cOldObjectName = cNewObjectName.

    /* Product Modules - Should be renamed in RTB  */
    IF  cNewObjectName <> ?
    AND cNewObjectName <> "":U
    AND cNewObjectName <> cOldObjectName
    THEN RETURN ERROR {af/sup2/aferrortxt.i 'AF' '110' '?' '?' cOldObjectName cNewObjectName cArguments}.

    IF cProductModuleFieldname <> "":U
    THEN DO:
      
      ASSIGN
        dNewProductModule = DECIMAL(getFieldValue(phTableBufferHandle, cProductModuleFieldname)).
  
      IF VALID-HANDLE(phOldBufferHandle)
      AND CAN-QUERY(phOldBufferHandle,"available":U)
      AND phOldBufferHandle:AVAILABLE = TRUE
      THEN
        ASSIGN
          dOldProductModule = DECIMAL(getFieldValue(phOldBufferHandle, cProductModuleFieldname)).
      ELSE
        ASSIGN
          dOldProductModule = dNewProductModule.

    END.
    ELSE
      ASSIGN
        dNewProductModule = 0
        dOldProductModule = 0
        .

    /* We cannot move product module in ICFDB - this has to be done from RTB.   */
    IF  dNewProductModule <> ?
    AND dNewProductModule <> 0
    AND dOldProductModule <> 0
    AND dOldProductModule <> ?
    AND dNewProductModule <> dOldProductModule
    THEN DO:
        /* Find the names of the product modules and use these instead of the _obj values in the error message */
        FIND FIRST gsc_product_module WHERE product_module_obj = dNewProductModule NO-LOCK NO-ERROR.
        IF AVAILABLE gsc_product_module THEN
            ASSIGN
               cNewProductModuleCode = "product module " + gsc_product_module.product_module_code
                                     + "(" + STRING(dNewProductModule) + ")".

        FIND FIRST gsc_product_module WHERE product_module_obj = dOldProductModule NO-LOCK NO-ERROR.
        IF AVAILABLE gsc_product_module THEN
            ASSIGN
               cOldProductModuleCode = "product module " + gsc_product_module.product_module_code
                                     + "(" + STRING(dOldProductModule) + ")".
                                     
        /* Pass a message back informing the user that the product modules are different. */
        RETURN ERROR {af/sup2/aferrortxt.i 'AF' '110' '?' '?' cOldProductModuleCode cNewProductModuleCode cArguments}.
    END.
    
    RETURN.
  END.
  
  /* If we are not in a delete event, then the buffer that is passed into the replication 
     procedure is not valid - it does not yet exist in memory - but has been written to the 
     database. Therefore we have to create a new separate buffer to access the object details. 
  */
  IF NOT lDeletingItem THEN DO:
    CREATE BUFFER hBufferHandle FOR TABLE cTypeTableName.
    ASSIGN
      gcDBName = hBufferHandle:DBNAME.
  
    ASSIGN
      cWhereString = "WHERE ":U.
  
    DO iIdx = 1 TO NUM-ENTRIES(pcPrimaryKeyFields):
      ASSIGN
        lNullsInPrimaryKey = LOOKUP(getQuotedFieldValue(phTableBufferHandle, ENTRY(iIdx,pcPrimaryKeyFields)),',?,0,"0"') > 0.
      
      IF iIdx > 1
      THEN
        ASSIGN
          cWhereString = cWhereString + " AND ".
      ASSIGN
        cWhereString = cWhereString + cTypeTableName + "." + ENTRY(iIdx,cScmPrimaryKeyFields) + " = " + getQuotedFieldValue(phTableBufferHandle, ENTRY(iIdx,pcPrimaryKeyFields)) + " ". 
    END.
    IF lNullsInPrimaryKey THEN
    RETURN.
    ELSE
    hBufferHandle:FIND-FIRST(cWherestring, NO-LOCK) NO-ERROR. 
  
    IF NOT hBufferHandle:AVAILABLE
    THEN DO:
      /* cleanup dynamic query */
  
      hBufferHandle:BUFFER-RELEASE() NO-ERROR.
      DELETE OBJECT hBufferHandle.
      ASSIGN
        hBufferHandle = ?
        .
  
      IF lNullsInPrimaryKey 
      THEN RETURN.
      ELSE DO:
        RETURN ERROR {af/sup2/aferrortxt.i 'RV' '20' '?' '?' cWhereString cScmIdentifyingFieldname cArguments}.
      END.
  
      RETURN ERROR {af/sup2/aferrortxt.i 'RV' '19' '?' '?' cWhereString cScmIdentifyingFieldname cArguments}.
  
    END.
  
    ASSIGN
     cObjectName          = getFieldValue(hBufferHandle, cScmIdentifyingFieldname)
     lNullsInPrimaryKey = FALSE  /* although there were nulls we have found a corresponding record, so continue. */
     .
  
    /* cleanup dynamic query */        
    hBufferHandle:BUFFER-RELEASE() NO-ERROR.
  
    DELETE OBJECT hBufferHandle.
  
    ASSIGN
      hBufferHandle = ?
      .
  END.
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
  DEFINE VARIABLE cWhereString          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lQueryOK              AS LOGICAL    NO-UNDO.

  DEFINE VARIABLE cQueryObjectFullName  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryObjectName      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cQueryObjectExt       AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE cQueryTableName       AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cQueryObjectFieldName AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cQueryObjectFieldExt  AS CHARACTER    NO-UNDO.

  ASSIGN
    cQueryTableName        = "ryc_smartobject":U
    cQueryObjectFieldName  = "object_filename":U
    cQueryObjectFieldExt   = "object_extension":U
    cQueryObjectFullName   = cObjectName
    cQueryObjectName       = cObjectName
    cQueryObjectExt        = "":U.
    .

  /* If we are deleting and item, it is not gonig to be possible to create 
   a new buffer for the table, as this has already been deleted at this stage.
   Instead, we can use the buffer that is benig passed in, as thi sstill exists 
   in memory - and can be accessed directly. 
   
   So for the delete event the phTableBufferHandle can be used directly. 
  */

  IF lDeletingItem THEN DO:    
    /* First of all, we only want to check if the current buffer is for the 
       table defined in the cQueryTablename variable. We are not interested in 
       other buffers.  */
    IF phTableBufferHandle:TABLE = cQueryTableName THEN DO:
      /* Make sure the buffer is available. */
      IF phTableBufferHandle:AVAILABLE THEN DO:
        ASSIGN
          cQueryObjectName = getFieldValue(phTableBufferHandle, cQueryObjectFieldName)
          cQueryObjectExt  = getFieldValue(phTableBufferHandle, cQueryObjectFieldExt)
          .
        IF cQueryObjectExt <> "":U
        THEN ASSIGN cQueryObjectFullName = cQueryObjectName + "." + cQueryObjectExt.
        ELSE ASSIGN cQueryObjectFullName = cQueryObjectName.
  
        ASSIGN
          cObjectName     = cQueryObjectFullName
          cObjectName_ext = cQueryObjectExt
          .        
      END.       
      /* Buffer is not available - finding the object is therefore going to fail */
      ELSE DO:
        RETURN ERROR {af/sup2/aferrortxt.i 'RV' '19' '?' '?' cWhereString cQueryObjectFieldName cArguments}.  
      END.
      
    END.
  
  END.
  ELSE DO:
    /* If we are in a write event, then the buffer that is passed into the 
       replaication code is not yet been committed to memory, and is therefore 
       not available directly from the phTableBufferHandle. It has been written 
       to the database however, and we can therefore create a new buffer and access 
       the record from there.
         */
    CREATE BUFFER hBufferHandle FOR TABLE cQueryTableName .
    ASSIGN
      gcDBName = hBufferHandle:DBNAME.
  
    ASSIGN
      cWhereString = "WHERE ":U  + cQueryTableName + ".":U + cQueryObjectFieldName + " = ":U + QUOTER(cQueryObjectFullName).
               
    hBufferHandle:FIND-FIRST(cWhereString, NO-LOCK) NO-ERROR. 
    
    IF NOT hBufferHandle:AVAILABLE
    THEN DO:
      /* cleanup dynamic query */
  
      hBufferHandle:BUFFER-RELEASE() NO-ERROR.
      DELETE OBJECT hBufferHandle.
      ASSIGN
        hBufferHandle = ?
        .
  
      RETURN ERROR {af/sup2/aferrortxt.i 'RV' '19' '?' '?' cWhereString cQueryObjectFieldName cArguments}.
  
    END.
  
    ASSIGN
      cQueryObjectName = getFieldValue(hBufferHandle, cQueryObjectFieldName)
      cQueryObjectExt  = getFieldValue(hBufferHandle, cQueryObjectFieldExt)
      .
    IF cQueryObjectExt <> "":U
    THEN ASSIGN cQueryObjectFullName = cQueryObjectName + "." + cQueryObjectExt.
    ELSE ASSIGN cQueryObjectFullName = cQueryObjectName.
  
    ASSIGN
      cObjectName     = cQueryObjectFullName
      cObjectName_ext = cQueryObjectExt
      .
  
    /* cleanup dynamic query */        
    hBufferHandle:BUFFER-RELEASE() NO-ERROR.
  
    DELETE OBJECT hBufferHandle.
  
    ASSIGN
      hBufferHandle = ?
      .  
  END.
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
    iTaskNumber = cScmTaskNumber
    cScmTaskOpen   = (cScmTaskstatus = "W") /* W = Work in progress */
    .

  IF iTaskNumber = ? OR 
     iTaskNumber = 0 
  THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '5' '?' '?' cArguments}.

  IF NOT cScmTaskOpen        
  THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '25' '?' '?' cArguments}.

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
    cWorkspaceCode = Grtb-wspace-id.

  IF cWorkspaceCode = ?
  OR cWorkspaceCode = ""
  THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '2' '?' '?' cArguments}.

  ASSIGN
    cArguments = cArguments + "~nWORKSPACE='" + cWorkspaceCode + "'".

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
      lCreatingItem = (pcAction = "WRITE"  AND pcTableFla = pcPrimaryFla AND lNew )
      lDeletingItem = (pcAction = "DELETE" AND pcTableFla = pcPrimaryFla)
      .
    
    /* First we need to determine the object name */
    RUN determineObjectName.
    
    /* Some of the involved tables have nulls-allowed relationships to the primary table. We return if the primary key is null.*/
    IF lNullsInPrimaryKey
    THEN RETURN.
    
    RUN determineObjectNameExt.

    /* do nothing if doing an assignment */
    IF assignmentUnderway(FALSE)
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
      cObjectName_ado = cObjectName.
    IF VALID-HANDLE(hScmTool)
    THEN
      RUN scmADOExtAdd IN hScmTool (INPUT-OUTPUT cObjectName_ado).

    /* now check for availability of the RTB object itself in the designated workspace */
    FIND FIRST rtb_object NO-LOCK
      WHERE rtb_object.wspace-id  = cWorkspaceCode
      AND   rtb_object.obj-type   = "PCODE":U
      AND   rtb_object.object     = cObjectName_ado
      NO-ERROR.

/*
{af/sup/afdebug.i}
MESSAGE
  SKIP cObjectName
  SKIP cObjectName_ext
  SKIP cObjectName_ado
  SKIP AVAILABLE(rtb_object)
  SKIP "ACT  " pcAction
  SKIP "CRE  " lCreatingItem
  SKIP "DEL  " lDeletingItem
  SKIP "WORK " cWorkspaceCode
  SKIP "TASK " iTaskNumber
  VIEW-AS ALERT-BOX INFORMATION.
*/  

    IF lCreatingItem
    THEN DO:

      RUN createItem NO-ERROR.
      IF RETURN-VALUE <> "":U
      OR ERROR-STATUS:ERROR
      THEN RETURN ERROR RETURN-VALUE.

    END. /* creating the item */
    ELSE
    IF lDeletingItem
    THEN DO:   

      IF AVAILABLE rtb_object
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

      IF NOT AVAILABLE rtb_object 
      THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '11' '?' '?' pcPrimaryFla cObjectName cWorkspaceCode cArguments}.

      FIND FIRST rtb_ver NO-LOCK
        WHERE rtb_ver.obj-type = rtb_object.obj-type
        AND rtb_ver.object     = rtb_object.object
        AND rtb_ver.pmod       = rtb_object.pmod
        AND rtb_ver.version    = rtb_object.version
        NO-ERROR.

      IF NOT AVAILABLE rtb_ver
      THEN RETURN ERROR  {af/sup2/aferrortxt.i 'RV' '7' '?' '?' pcPrimaryFla rtb_object.object cArguments}.

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
  ASSIGN
    pcTablePkFields = REPLACE(REPLACE(REPLACE(pcTablePkFields," ",""),CHR(13),""),CHR(10),"").

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
                       (INPUT  cObjectName_ado
                       ,INPUT  cWorkspaceCode
                       ,OUTPUT lScmObjectExists
                       ,OUTPUT lScmObjectExistsInWs
                       ,OUTPUT iScmVersionInWorkspace
                       ,OUTPUT lScmCheckedOutInWorkspace
                       ,OUTPUT iScmVersionTaskNumber
                       ,OUTPUT iScmHighestVersion
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
  DEFINE VARIABLE cNewObjectDescription       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cOldObjectDescription       AS CHARACTER  NO-UNDO. 

  /* Is the record checked out ? */ 
  RUN scmObjectExists.

  IF NOT lScmObjectExistsInWs
  THEN
    RETURN ERROR {af/sup2/aferrortxt.i 'RV' '11' '?' '?' pcPrimaryFla cObjectName cWorkspaceCode cArguments}.

  IF lScmCheckedOutInWorkspace
  THEN DO:
    /* the item is checked out explicitly */
    IF iScmVersionTaskNumber <> iTaskNumber 
    THEN RETURN ERROR {af/sup2/aferrortxt.i 'RV' '12' '?' '?' pcPrimaryFla cObjectName iTaskNumber iScmVersionTaskNumber cArguments}.
    /* this item is explicitly checked out */
    
    /* Check if the description of the object has changed - 
       if it has we need to update this in RTB as well*/
    IF cDescriptionFieldname <> "":U
    THEN DO:
      ASSIGN 
        cNewObjectDescription = getFieldValue(phTableBufferHandle, cDescriptionFieldname)
        .                       
      
      IF VALID-HANDLE(phOldBufferHandle)
      AND CAN-QUERY(phOldBufferHandle,"AVAILABLE":U)
      AND phOldBufferHandle:AVAILABLE = TRUE
      THEN 
        ASSIGN cOldObjectDescription = getFieldValue(phOldBufferHandle, cDescriptionFieldname).
      ELSE 
        ASSIGN cOldObjectDescription = cNewObjectDescription.        
    END. /* IF cDescriptionFieldname <> "":U ...*/
      
    IF cNewObjectDescription <> cOldObjectDescription THEN DO:    
      RUN scmUpdateObjectDescription IN hScmTool (INPUT cWorkspaceCode, 
                                                  INPUT rtb_object.OBJECT, 
                                                  INPUT "PCODE":U,       /* PCODE */
                                                  INPUT YES, /* Overwrite */
                                                  INPUT cNewObjectDescription).   
    END.
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
                                  ,INPUT iTaskNumber
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

  DO lv_idx = 1 TO NUM-ENTRIES(pcPrimaryKeyFields):        
    IF lv_idx > 1 THEN lv_primary_key_values = lv_primary_key_values + CHR(3).
    lv_primary_key_values = lv_primary_key_values + getFieldValue(phTableBufferHandle, ENTRY(lv_idx,pcPrimaryKeyFields)).
  END.

  RUN getActionUnderway IN gshSessionManager
                       (INPUT  "DYN":U
                       ,INPUT  "ASS":U
                       ,INPUT  cObjectName
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

  DO lv_idx = 1 TO NUM-ENTRIES(pcPrimaryKeyFields):        
    IF lv_idx > 1 THEN lv_primary_key_values = lv_primary_key_values + CHR(3).
    lv_primary_key_values = lv_primary_key_values + getFieldValue(phTableBufferHandle, ENTRY(lv_idx,pcPrimaryKeyFields)).
  END.

  RUN getActionUnderway IN gshSessionManager
                       (INPUT  "DYN":U
                       ,INPUT  "DEL":U
                       ,INPUT  "":U
                       ,INPUT  pcPrimaryFla
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
    THEN RETURN "'"        + h_buffer_field:BUFFER-VALUE() + "'".
    ELSE RETURN  TRIM(QUOTER( h_buffer_field:BUFFER-VALUE() )).
  END.
  ELSE RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

