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

&scop object-name       gsmcafullo.w
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
&Scoped-define INTERNAL-TABLES gsm_category

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  related_entity_mnemonic category_type category_group category_subgroup~
 category_group_seq category_label category_description~
 owning_entity_mnemonic system_owned validation_min_length~
 validation_max_length view_as_columns view_as_rows category_mandatory~
 category_active
&Scoped-define ENABLED-FIELDS-IN-gsm_category related_entity_mnemonic ~
category_type category_group category_subgroup category_group_seq ~
category_label category_description owning_entity_mnemonic system_owned ~
validation_min_length validation_max_length view_as_columns view_as_rows ~
category_mandatory category_active 
&Scoped-Define DATA-FIELDS  category_obj related_entity_mnemonic category_type category_group~
 category_subgroup category_group_seq category_label category_description~
 owning_entity_mnemonic system_owned validation_min_length~
 validation_max_length view_as_columns view_as_rows category_mandatory~
 category_active
&Scoped-define DATA-FIELDS-IN-gsm_category category_obj ~
related_entity_mnemonic category_type category_group category_subgroup ~
category_group_seq category_label category_description ~
owning_entity_mnemonic system_owned validation_min_length ~
validation_max_length view_as_columns view_as_rows category_mandatory ~
category_active 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "af/obj2/gsmcafullo.i"
&Scoped-define QUERY-STRING-Query-Main FOR EACH gsm_category NO-LOCK ~
    BY gsm_category.related_entity_mnemonic ~
       BY gsm_category.category_type ~
        BY gsm_category.category_group ~
         BY gsm_category.category_subgroup INDEXED-REPOSITION
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH gsm_category NO-LOCK ~
    BY gsm_category.related_entity_mnemonic ~
       BY gsm_category.category_type ~
        BY gsm_category.category_group ~
         BY gsm_category.category_subgroup INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main gsm_category
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main gsm_category


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      gsm_category SCROLLING.
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
         WIDTH              = 46.6.
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
     _TblList          = "icfdb.gsm_category"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "icfdb.gsm_category.related_entity_mnemonic|yes,icfdb.gsm_category.category_type|yes,icfdb.gsm_category.category_group|yes,icfdb.gsm_category.category_subgroup|yes"
     _FldNameList[1]   > icfdb.gsm_category.category_obj
"category_obj" "category_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 21 yes
     _FldNameList[2]   > icfdb.gsm_category.related_entity_mnemonic
"related_entity_mnemonic" "related_entity_mnemonic" "Related Entity" ? "character" ? ? ? ? ? ? yes ? no 10 yes
     _FldNameList[3]   > icfdb.gsm_category.category_type
"category_type" "category_type" ? ? "character" ? ? ? ? ? ? yes ? no 6 yes
     _FldNameList[4]   > icfdb.gsm_category.category_group
"category_group" "category_group" ? ? "character" ? ? ? ? ? ? yes ? no 6 yes
     _FldNameList[5]   > icfdb.gsm_category.category_subgroup
"category_subgroup" "category_subgroup" ? ? "character" ? ? ? ? ? ? yes ? no 6 yes
     _FldNameList[6]   > icfdb.gsm_category.category_group_seq
"category_group_seq" "category_group_seq" ? ? "integer" ? ? ? ? ? ? yes ? no 4 yes
     _FldNameList[7]   > icfdb.gsm_category.category_label
"category_label" "category_label" ? ? "character" ? ? ? ? ? ? yes ? no 56 yes
     _FldNameList[8]   > icfdb.gsm_category.category_description
"category_description" "category_description" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[9]   > icfdb.gsm_category.owning_entity_mnemonic
"owning_entity_mnemonic" "owning_entity_mnemonic" "Owning Entity" ? "character" ? ? ? ? ? ? yes ? no 10 yes
     _FldNameList[10]   > icfdb.gsm_category.system_owned
"system_owned" "system_owned" ? ? "logical" ? ? ? ? ? ? yes ? no 1 yes
     _FldNameList[11]   > icfdb.gsm_category.validation_min_length
"validation_min_length" "validation_min_length" ? ? "integer" ? ? ? ? ? ? yes ? no 4 yes
     _FldNameList[12]   > icfdb.gsm_category.validation_max_length
"validation_max_length" "validation_max_length" ? ? "integer" ? ? ? ? ? ? yes ? no 4 yes
     _FldNameList[13]   > icfdb.gsm_category.view_as_columns
"view_as_columns" "view_as_columns" ? ? "integer" ? ? ? ? ? ? yes ? no 4 yes
     _FldNameList[14]   > icfdb.gsm_category.view_as_rows
"view_as_rows" "view_as_rows" ? ? "integer" ? ? ? ? ? ? yes ? no 4 yes
     _FldNameList[15]   > icfdb.gsm_category.category_mandatory
"category_mandatory" "category_mandatory" ? ? "logical" ? ? ? ? ? ? yes ? no 1 yes
     _FldNameList[16]   > icfdb.gsm_category.category_active
"category_active" "category_active" ? ? "logical" ? ? ? ? ? ? yes ? no 1 yes
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE preTransactionValidate dTables  _DB-REQUIRED
PROCEDURE preTransactionValidate :
/*------------------------------------------------------------------------------
  Purpose:     Procedure used to validate RowObjUpd records server-side
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE cMessageList    AS CHARACTER    NO-UNDO.

DEFINE VARIABLE cValueList      AS CHARACTER    NO-UNDO.

FOR EACH RowObjUpd WHERE CAN-DO('A,C,U':U,RowObjUpd.RowMod): 
  /* For every update, add, or copy, verify that the combination of related_entity_mnemonic, type, group, subgroup is unique. */
  IF (RowObjUpd.RowMod = 'U':U AND
    CAN-FIND(FIRST gsm_category
      WHERE gsm_category.related_entity_mnemonic = rowObjUpd.related_entity_mnemonic
        AND gsm_category.category_type = rowObjUpd.category_type
        AND gsm_category.category_group = rowObjUpd.category_group
        AND gsm_category.category_subgroup = rowObjUpd.category_subgroup
      AND ROWID(gsm_category) <> TO-ROWID(ENTRY(1,RowObjUpd.RowIDent))))
  OR (RowObjUpd.RowMod <> 'U':U AND
    CAN-FIND(FIRST gsm_category
      WHERE gsm_category.related_entity_mnemonic = rowObjUpd.related_entity_mnemonic
        AND gsm_category.category_type = rowObjUpd.category_type
        AND gsm_category.category_group = rowObjUpd.category_group
        AND gsm_category.category_subgroup = rowObjUpd.category_subgroup))
  THEN
    ASSIGN
      cValueList   = STRING(RowObjUpd.related_entity_mnemonic) + ', ' + STRING(RowObjUpd.category_type) + ', ' + STRING(RowObjUpd.category_group) + ', ' + STRING(RowObjUpd.category_subgroup)
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '8' 'gsm_category' 'related_entity_mnemonic' "'related_entity_mnemonic, category_type, category_group, category_subgroup, '" cValueList }.
END.

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

  IF LENGTH(RowObject.related_entity_mnemonic) = 0 OR LENGTH(RowObject.related_entity_mnemonic) = ? THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '1' 'gsm_category' 'related_entity_mnemonic' "'Related Entity Mnemonic'"}.

  IF LENGTH(RowObject.category_type) = 0 OR LENGTH(RowObject.category_type) = ? THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '1' 'gsm_category' 'category_type' "'Category Type'"}.

  IF LENGTH(RowObject.category_description) = 0 OR LENGTH(RowObject.category_description) = ? THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '1' 'gsm_category' 'category_description' "'Category Description'"}.

  ERROR-STATUS:ERROR = NO.
  RETURN cMessageList.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

