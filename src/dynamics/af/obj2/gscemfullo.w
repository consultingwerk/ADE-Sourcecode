&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
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
  File: gscemfullo.w

  Description:  Template Astra 2 SmartDataObject Templat

  Purpose:      Template Astra 2 SmartDataObject Template

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        6180   UserRef:    
                Date:   28/06/2000  Author:     Anthony Swindells

  Update Notes: V9 Templates

  (v:010001)    Task:           0   UserRef:    
                Date:   11/28/2001  Author:     Mark Davies (MIP)

  Update Notes: Fix for issue #2589 - "Mnemonic" should be removed from all visible entity labels

  (v:010002)    Task:                UserRef:    
                Date:   APR/11/2002  Author:     Mauricio J. dos Santos (MJS) 
                                                 mdsantos@progress.com
  Update Notes: Adapted for WebSpeed by changing SESSION:PARAM = "REMOTE" 
                to SESSION:CLIENT-TYPE = "WEBSPEED" in rowObjectValidate.

-------------------------------------------------------------------*/
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

&scop object-name       gscemfullo.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataObject yes

{af/sup2/afglobals.i}

/* temp-table to maintain entity display fields */
{af/sup2/gscedtable.i}

/* definitions for afcheckerr.i */
{af/sup2/afcheckerr.i &define-only = YES}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Global-define DATA-LOGIC-PROCEDURE af/obj2/gscemlogcp.p

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
&Scoped-define INTERNAL-TABLES gsc_entity_mnemonic

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  entity_mnemonic entity_mnemonic_description entity_mnemonic_short_desc~
 auto_properform_strings entity_mnemonic_label_prefix~
 entity_description_field entity_description_procedure entity_narration~
 entity_object_field table_has_object_field entity_key_field~
 table_prefix_length field_name_separator auditing_enabled deploy_data~
 entity_dbname replicate_entity_mnemonic replicate_key scm_field_name~
 version_data reuse_deleted_keys EntityObjectProductModule EntityObjectClass~
 AssociateDataFields
&Scoped-define ENABLED-FIELDS-IN-gsc_entity_mnemonic entity_mnemonic ~
entity_mnemonic_description entity_mnemonic_short_desc ~
auto_properform_strings entity_mnemonic_label_prefix ~
entity_description_field entity_description_procedure entity_narration ~
entity_object_field table_has_object_field entity_key_field ~
table_prefix_length field_name_separator auditing_enabled deploy_data ~
entity_dbname replicate_entity_mnemonic replicate_key scm_field_name ~
version_data reuse_deleted_keys 
&Scoped-Define DATA-FIELDS  entity_mnemonic entity_mnemonic_description entity_mnemonic_short_desc~
 auto_properform_strings entity_mnemonic_label_prefix entity_mnemonic_obj~
 entity_description_field entity_description_procedure entity_narration~
 entity_object_field table_has_object_field entity_key_field~
 table_prefix_length field_name_separator auditing_enabled deploy_data~
 entity_dbname replicate_entity_mnemonic replicate_key scm_field_name~
 version_data reuse_deleted_keys EntityObjectProductModule EntityObjectClass~
 AssociateDataFields RVDataExists
&Scoped-define DATA-FIELDS-IN-gsc_entity_mnemonic entity_mnemonic ~
entity_mnemonic_description entity_mnemonic_short_desc ~
auto_properform_strings entity_mnemonic_label_prefix entity_mnemonic_obj ~
entity_description_field entity_description_procedure entity_narration ~
entity_object_field table_has_object_field entity_key_field ~
table_prefix_length field_name_separator auditing_enabled deploy_data ~
entity_dbname replicate_entity_mnemonic replicate_key scm_field_name ~
version_data reuse_deleted_keys 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "af/obj2/gscemfullo.i"
&Scoped-define QUERY-STRING-Query-Main FOR EACH gsc_entity_mnemonic NO-LOCK ~
    BY gsc_entity_mnemonic.entity_mnemonic INDEXED-REPOSITION
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH gsc_entity_mnemonic NO-LOCK ~
    BY gsc_entity_mnemonic.entity_mnemonic INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main gsc_entity_mnemonic
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main gsc_entity_mnemonic


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      gsc_entity_mnemonic SCROLLING.
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
         HEIGHT             = 1.76
         WIDTH              = 61.8.
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
     _TblList          = "icfdb.gsc_entity_mnemonic"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "icfdb.gsc_entity_mnemonic.entity_mnemonic|yes"
     _FldNameList[1]   > icfdb.gsc_entity_mnemonic.entity_mnemonic
"entity_mnemonic" "entity_mnemonic" ? ? "character" ? ? ? ? ? ? yes ? no 16 yes
     _FldNameList[2]   > icfdb.gsc_entity_mnemonic.entity_mnemonic_description
"entity_mnemonic_description" "entity_mnemonic_description" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[3]   > icfdb.gsc_entity_mnemonic.entity_mnemonic_short_desc
"entity_mnemonic_short_desc" "entity_mnemonic_short_desc" ? ? "character" ? ? ? ? ? ? yes ? no 35 yes
     _FldNameList[4]   > icfdb.gsc_entity_mnemonic.auto_properform_strings
"auto_properform_strings" "auto_properform_strings" ? ? "logical" ? ? ? ? ? ? yes ? no 1 yes
     _FldNameList[5]   > icfdb.gsc_entity_mnemonic.entity_mnemonic_label_prefix
"entity_mnemonic_label_prefix" "entity_mnemonic_label_prefix" ? ? "character" ? ? ? ? ? ? yes ? no 56 yes
     _FldNameList[6]   > icfdb.gsc_entity_mnemonic.entity_mnemonic_obj
"entity_mnemonic_obj" "entity_mnemonic_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 21 yes
     _FldNameList[7]   > icfdb.gsc_entity_mnemonic.entity_description_field
"entity_description_field" "entity_description_field" ? ? "character" ? ? ? ? ? ? yes ? no 140 yes
     _FldNameList[8]   > icfdb.gsc_entity_mnemonic.entity_description_procedure
"entity_description_procedure" "entity_description_procedure" ? ? "character" ? ? ? ? ? ? yes ? no 140 yes
     _FldNameList[9]   > icfdb.gsc_entity_mnemonic.entity_narration
"entity_narration" "entity_narration" ? ? "character" ? ? ? ? ? ? yes ? no 1000 yes
     _FldNameList[10]   > icfdb.gsc_entity_mnemonic.entity_object_field
"entity_object_field" "entity_object_field" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[11]   > icfdb.gsc_entity_mnemonic.table_has_object_field
"table_has_object_field" "table_has_object_field" ? ? "logical" ? ? ? ? ? ? yes ? no 1 yes
     _FldNameList[12]   > icfdb.gsc_entity_mnemonic.entity_key_field
"entity_key_field" "entity_key_field" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[13]   > icfdb.gsc_entity_mnemonic.table_prefix_length
"table_prefix_length" "table_prefix_length" ? ? "integer" ? ? ? ? ? ? yes ? no 4 yes
     _FldNameList[14]   > icfdb.gsc_entity_mnemonic.field_name_separator
"field_name_separator" "field_name_separator" ? ? "character" ? ? ? ? ? ? yes ? no 20 yes
     _FldNameList[15]   > icfdb.gsc_entity_mnemonic.auditing_enabled
"auditing_enabled" "auditing_enabled" ? ? "logical" ? ? ? ? ? ? yes ? no 1 yes
     _FldNameList[16]   > icfdb.gsc_entity_mnemonic.deploy_data
"deploy_data" "deploy_data" ? ? "logical" ? ? ? ? ? ? yes ? no 11.8 yes
     _FldNameList[17]   > icfdb.gsc_entity_mnemonic.entity_dbname
"entity_dbname" "entity_dbname" ? ? "character" ? ? ? ? ? ? yes ? no 35 yes
     _FldNameList[18]   > icfdb.gsc_entity_mnemonic.replicate_entity_mnemonic
"replicate_entity_mnemonic" "replicate_entity_mnemonic" ? ? "character" ? ? ? ? ? ? yes ? no 25.2 yes
     _FldNameList[19]   > icfdb.gsc_entity_mnemonic.replicate_key
"replicate_key" "replicate_key" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[20]   > icfdb.gsc_entity_mnemonic.scm_field_name
"scm_field_name" "scm_field_name" ? ? "character" ? ? ? ? ? ? yes ? no 35 yes
     _FldNameList[21]   > icfdb.gsc_entity_mnemonic.version_data
"version_data" "version_data" ? ? "logical" ? ? ? ? ? ? yes ? no 12.2 yes
     _FldNameList[22]   > icfdb.gsc_entity_mnemonic.reuse_deleted_keys
"reuse_deleted_keys" "reuse_deleted_keys" ? ? "logical" ? ? ? ? ? ? yes ? no 19.4 yes
     _FldNameList[23]   > "_<CALC>"
""""":U /* This is determined from the Repository*/" "EntityObjectProductModule" ? "x(8)" "Character" ? ? ? ? ? ? yes ? no 8 no
     _FldNameList[24]   > "_<CALC>"
""""":U /* This is determined from the Repository*/" "EntityObjectClass" ? "x(8)" "character" ? ? ? ? ? ? yes ? no 8 no
     _FldNameList[25]   > "_<CALC>"
"YES" "AssociateDataFields" ? "YES/NO" "Logical" ? ? ? ? ? ? yes ? no 4.2 no
     _FldNameList[26]   > "_<CALC>"
"CAN-FIND(FIRST gst_record_version WHERE gst_record_version.entity_mnemonic = RowObject.entity_mnemonic)" "RVDataExists" "Record Version!Data Exists" "Yes/No" "Logical" ? ? ? ? ? ? no ? no 3.6 no
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

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DATA.CALCULATE dTables  DATA.CALCULATE _DB-REQUIRED
PROCEDURE DATA.CALCULATE :
/*------------------------------------------------------------------------------
  Purpose:     Calculate all the Calculated Expressions found in the
               SmartDataObject.
  Parameters:  <none>
------------------------------------------------------------------------------*/
      ASSIGN 
         rowObject.AssociateDataFields = (YES)
         rowObject.EntityObjectClass = ("":U /* This is determined from the Repository*/)
         rowObject.EntityObjectProductModule = ("":U /* This is determined from the Repository*/)
         rowObject.RVDataExists = (CAN-FIND(FIRST gst_record_version WHERE gst_record_version.entity_mnemonic = RowObject.entity_mnemonic))
      .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dataAvailable dTables  _DB-REQUIRED
PROCEDURE dataAvailable :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       Publishes populateRelatedData to populate the datafield 
               maintenance SDO with temp table records for the current
               entity's instances.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcRelative AS CHARACTER NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER( INPUT pcRelative).

  /* Code placed here will execute AFTER standard behavior.    */
  PUBLISH 'populateRelatedData':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

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

