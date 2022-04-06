&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          icfdb            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
{adecomm/appserv.i}
DEFINE VARIABLE h_Astra                    AS HANDLE          NO-UNDO.
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" dTables _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" dTables _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "SmartDataObjectWizard" dTables _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* SmartDataObject Wizard
Welcome to the SmartDataObject Wizard! During the next few steps, the wizard will lead you through creating a SmartDataObject. You will define the query that you will use to retrieve data from your database(s) and define a set of field values to make available to visualization objects. Press Next to proceed.
adm2/support/_wizqry.w,adm2/support/_wizfld.w 
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS dTables 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: rysttasdoo.w

  Description:  Template Astra 2 SmartDataObject Template

  Purpose:      Template Astra 2 SmartDataObject Template

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        6180   UserRef:    
                Date:   28/06/2000  Author:     Anthony Swindells

  Update Notes: V9 Templates

--------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       gscdefullo.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataObject yes

{af/sup2/afglobals.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartDataObject
&Scoped-define DB-AWARE yes

&Scoped-define ADM-SUPPORTED-LINKS Data-Source,Data-Target,Navigation-Target,Update-Target,Commit-Target,Filter-Target


/* Db-Required definitions. */
&IF DEFINED(DB-REQUIRED) = 0 &THEN
    &GLOBAL-DEFINE DB-REQUIRED TRUE
&ENDIF
&GLOBAL-DEFINE DB-REQUIRED-START   &IF {&DB-REQUIRED} &THEN
&GLOBAL-DEFINE DB-REQUIRED-END     &ENDIF


&Scoped-define QUERY-NAME Query-Main

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES gsc_dataset_entity gsc_deploy_dataset

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  deploy_dataset_obj entity_sequence entity_mnemonic primary_entity~
 join_entity_mnemonic join_field_list filter_where_clause~
 delete_related_records keep_own_site_data overwrite_records deletion_action~
 relationship_obj use_relationship exclude_field_list
&Scoped-define ENABLED-FIELDS-IN-gsc_dataset_entity deploy_dataset_obj ~
entity_sequence entity_mnemonic primary_entity join_entity_mnemonic ~
join_field_list filter_where_clause delete_related_records ~
keep_own_site_data overwrite_records deletion_action relationship_obj ~
use_relationship exclude_field_list 
&Scoped-Define DATA-FIELDS  dataset_entity_obj deploy_dataset_obj dataset_code entity_sequence~
 entity_mnemonic primary_entity join_entity_mnemonic join_field_list~
 filter_where_clause delete_related_records keep_own_site_data~
 overwrite_records deletion_action relationship_obj use_relationship~
 exclude_field_list
&Scoped-define DATA-FIELDS-IN-gsc_dataset_entity dataset_entity_obj ~
deploy_dataset_obj entity_sequence entity_mnemonic primary_entity ~
join_entity_mnemonic join_field_list filter_where_clause ~
delete_related_records keep_own_site_data overwrite_records deletion_action ~
relationship_obj use_relationship exclude_field_list 
&Scoped-define DATA-FIELDS-IN-gsc_deploy_dataset dataset_code 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "af/obj2/gscdefullo.i"
&Scoped-define QUERY-STRING-Query-Main FOR EACH gsc_dataset_entity NO-LOCK, ~
      FIRST gsc_deploy_dataset WHERE gsc_deploy_dataset.deploy_dataset_obj = gsc_dataset_entity.deploy_dataset_obj NO-LOCK ~
    BY gsc_dataset_entity.deploy_dataset_obj ~
       BY gsc_dataset_entity.entity_sequence INDEXED-REPOSITION
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH gsc_dataset_entity NO-LOCK, ~
      FIRST gsc_deploy_dataset WHERE gsc_deploy_dataset.deploy_dataset_obj = gsc_dataset_entity.deploy_dataset_obj NO-LOCK ~
    BY gsc_dataset_entity.deploy_dataset_obj ~
       BY gsc_dataset_entity.entity_sequence INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main gsc_dataset_entity ~
gsc_deploy_dataset
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main gsc_dataset_entity
&Scoped-define SECOND-TABLE-IN-QUERY-Query-Main gsc_deploy_dataset


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      gsc_dataset_entity, 
      gsc_deploy_dataset
    FIELDS(gsc_deploy_dataset.dataset_code) SCROLLING.
&ANALYZE-RESUME
{&DB-REQUIRED-END}


/* ************************  Frame Definitions  *********************** */


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataObject
   Allow: Query
   Frames: 0
   Add Fields to: Neither
   Other Settings: PERSISTENT-ONLY COMPILE APPSERVER DB-AWARE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW dTables ASSIGN
         HEIGHT             = 1.62
         WIDTH              = 57.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB dTables 
/* ************************* Included-Libraries *********************** */

{src/adm2/data.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW dTables
  VISIBLE,,RUN-PERSISTENT                                               */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK QUERY Query-Main
/* Query rebuild information for SmartDataObject Query-Main
     _TblList          = "icfdb.gsc_dataset_entity,icfdb.gsc_deploy_dataset WHERE icfdb.gsc_dataset_entity ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST USED"
     _OrdList          = "icfdb.gsc_dataset_entity.deploy_dataset_obj|yes,icfdb.gsc_dataset_entity.entity_sequence|yes"
     _JoinCode[2]      = "icfdb.gsc_deploy_dataset.deploy_dataset_obj = icfdb.gsc_dataset_entity.deploy_dataset_obj"
     _FldNameList[1]   > icfdb.gsc_dataset_entity.dataset_entity_obj
"dataset_entity_obj" "dataset_entity_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 21 yes
     _FldNameList[2]   > icfdb.gsc_dataset_entity.deploy_dataset_obj
"deploy_dataset_obj" "deploy_dataset_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21 yes
     _FldNameList[3]   > icfdb.gsc_deploy_dataset.dataset_code
"dataset_code" "dataset_code" ? ? "character" ? ? ? ? ? ? no ? no 13 yes
     _FldNameList[4]   > icfdb.gsc_dataset_entity.entity_sequence
"entity_sequence" "entity_sequence" ? ? "integer" ? ? ? ? ? ? yes ? no 4 yes
     _FldNameList[5]   > icfdb.gsc_dataset_entity.entity_mnemonic
"entity_mnemonic" "entity_mnemonic" ? ? "character" ? ? ? ? ? ? yes ? no 16 yes
     _FldNameList[6]   > icfdb.gsc_dataset_entity.primary_entity
"primary_entity" "primary_entity" ? ? "logical" ? ? ? ? ? ? yes ? no 1 yes
     _FldNameList[7]   > icfdb.gsc_dataset_entity.join_entity_mnemonic
"join_entity_mnemonic" "join_entity_mnemonic" ? ? "character" ? ? ? ? ? ? yes ? no 16 yes
     _FldNameList[8]   > icfdb.gsc_dataset_entity.join_field_list
"join_field_list" "join_field_list" ? ? "character" ? ? ? ? ? ? yes ? no 140 yes
     _FldNameList[9]   > icfdb.gsc_dataset_entity.filter_where_clause
"filter_where_clause" "filter_where_clause" ? ? "character" ? ? ? ? ? ? yes ? no 1000 yes
     _FldNameList[10]   > icfdb.gsc_dataset_entity.delete_related_records
"delete_related_records" "delete_related_records" ? ? "logical" ? ? ? ? ? ? yes ? no 22.8 yes
     _FldNameList[11]   > icfdb.gsc_dataset_entity.keep_own_site_data
"keep_own_site_data" "keep_own_site_data" ? ? "logical" ? ? ? ? ? ? yes ? no 19.4 yes
     _FldNameList[12]   > icfdb.gsc_dataset_entity.overwrite_records
"overwrite_records" "overwrite_records" ? ? "logical" ? ? ? ? ? ? yes ? no 17.6 yes
     _FldNameList[13]   > icfdb.gsc_dataset_entity.deletion_action
"deletion_action" "deletion_action" ? ? "character" ? ? ? ? ? ? yes ? no 14.4 yes
     _FldNameList[14]   > icfdb.gsc_dataset_entity.relationship_obj
"relationship_obj" "relationship_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 33.6 yes
     _FldNameList[15]   > icfdb.gsc_dataset_entity.use_relationship
"use_relationship" "use_relationship" ? ? "logical" ? ? ? ? ? ? yes ? no 16 yes
     _FldNameList[16]   > icfdb.gsc_dataset_entity.exclude_field_list
"exclude_field_list" "exclude_field_list" ? ? "character" ? ? ? ? ? ? yes ? no 500 no
     _Design-Parent    is WINDOW dTables @ ( 1.14 , 2.6 )
*/  /* QUERY Query-Main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK dTables 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN initializeObject.
  &ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI dTables  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE endTransactionValidate dTables  _DB-REQUIRED
PROCEDURE endTransactionValidate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cMessageList    AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE lPrimary        AS LOGICAL      NO-UNDO.

  /* Validation to ensure that at least one entity is a primary entity of the dataset */
  FIND FIRST RowObjUpd NO-ERROR.
  IF AVAILABLE RowObjUpd THEN 
  DO:
    FOR EACH gsc_dataset_entity WHERE gsc_dataset_entity.deploy_dataset_obj = RowObjUpd.deploy_dataset_obj NO-LOCK:
      IF gsc_dataset_entity.primary_entity THEN lPrimary = TRUE.
    END.  /* for each dataset entity */

    IF NOT lPrimary THEN 
      ASSIGN
        cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) +
                       {af/sup2/aferrortxt.i 'AF' '18' 'gsc_dataset_entity' 'primary_entity' "'Dataset'" "'a Primary Entity'"}.
  END.  /* if avail */

  ERROR-STATUS:ERROR = NO.
  RETURN cMessageList.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE preTransactionValidate dTables  _DB-REQUIRED
PROCEDURE preTransactionValidate :
/*------------------------------------------------------------------------------
  Purpose:     Procedure used to validate RowObjUpd records server-side
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cMessageList    AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cRowMod         AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cValueList      AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE lPrimary        AS LOGICAL      NO-UNDO.

  DEFINE BUFFER bRowObjUpd FOR RowObjUpd.

  FOR EACH RowObjUpd WHERE CAN-DO('A,C,U':U,RowObjUpd.RowMod): 
    IF (RowObjUpd.RowMod = 'U':U AND
      CAN-FIND(FIRST gsc_dataset_entity
        WHERE gsc_dataset_entity.deploy_dataset_obj = RowObjUpd.deploy_dataset_obj
          AND gsc_dataset_entity.entity_sequence = RowObjUpd.entity_sequence
          AND ROWID(gsc_dataset_entity) <> TO-ROWID(ENTRY(1,RowObjUpd.RowIDent))))
    OR (RowObjUpd.RowMod <> 'U':U AND
      CAN-FIND(FIRST gsc_dataset_entity
        WHERE gsc_dataset_entity.deploy_dataset_obj = RowObjUpd.deploy_dataset_obj
          AND gsc_dataset_entity.entity_sequence = RowObjUpd.entity_sequence))
    THEN
      ASSIGN
        cValueList   = STRING(RowObjUpd.deploy_dataset_obj) + ', ':U + STRING(RowObjUpd.entity_sequence)
        cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                      {af/sup2/aferrortxt.i 'AF' '8' 'gsc_dataset_entity' '' "'deploy_dataset_obj, entity_sequence, '" cValueList }.
  END.

  /* If the primary entity is being turned on for an existing dataset entity 
     or a new dataset entity then we need to turn if off for all other 
     dataset entities in the dataset */
  FOR EACH RowObjUpd WHERE CAN-DO('A,C,U':U,RowObjUpd.RowMod):
    cRowMod = RowObjUpd.RowMod.
    /* Deterine if primary entity has changed for an existing record */
    IF RowObjUpd.RowMod = 'U':U THEN
    DO:
      FIND FIRST bRowObjUpd WHERE bRowObjUpd.RowIdent = RowObjUpd.RowIdent NO-ERROR.
      IF AVAILABLE bRowObjUpd THEN
      DO:
        IF bRowObjUpd.primary_entity NE RowObjUpd.primary_entity THEN
        DO:
          IF RowObjUpd.primary_entity THEN
            lPrimary = TRUE.
          ELSE lPrimary = FALSE.
        END.  /* if primary entity changed */
      END.  /* if avail bRowObjUpd */
    END.  /* if RowMod = U */
    ELSE DO:
      IF RowObjUpd.primary_entity THEN
        lPrimary = TRUE.
      ELSE lPrimary = FALSE.
    END.  /* else do RowMod = A or C */

    /* Go through entities of the dataset and change primary entity if apporpriate */
    FOR EACH gsc_dataset_entity
      WHERE gsc_dataset_entity.deploy_dataset_obj = RowObjUpd.deploy_dataset_obj:

      /* If entity adding or changing is the primary entity and we are not 
         on the current record for an update. */
      IF lPrimary AND 
        (gsc_dataset_entity.dataset_entity_obj NE RowObjUpd.dataset_entity_obj OR 
         cRowMod = 'C':U) THEN 
        gsc_dataset_entity.primary_entity = FALSE.

    END.  /* for each */
  END.  /* for each RowObjUpd */

  ERROR-STATUS:ERROR = NO.
  RETURN cMessageList.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowObjectValidate dTables 
PROCEDURE rowObjectValidate :
/*------------------------------------------------------------------------------
  Purpose:     Procedure used to validate RowObject record client-side
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cMessageList    AS CHARACTER    NO-UNDO.
  DEFINE VARIABLE cValueList      AS CHARACTER    NO-UNDO.

  /* The filter where clause cannot include "WHERE" in it */
  IF RowObject.filter_where_clause MATCHES('*WHERE*') THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                     {af/sup2/aferrortxt.i 'AF' '112' 'gsc_dataset_entity' 'filter_where_clause' "'Filter Where Clause'" "'WHERE'"}.

  IF RowObject.deploy_dataset_obj = 0 OR RowObject.deploy_dataset_obj = ? THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '1' 'gsc_dataset_entity' 'deploy_dataset_obj' "'Deploy Dataset Obj'"}.

  IF RowObject.entity_sequence = 0 OR RowObject.entity_sequence = ? THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '1' 'gsc_dataset_entity' 'entity_sequence' "'Entity Sequence'"}.

  IF LENGTH(RowObject.entity_mnemonic) = 0 OR LENGTH(RowObject.entity_mnemonic) = ? THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '1' 'gsc_dataset_entity' 'entity_mnemonic' "'Entity Mnemonic'"}.

  ERROR-STATUS:ERROR = NO.
  RETURN cMessageList.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

