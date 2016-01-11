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
 version_data
&Scoped-define ENABLED-FIELDS-IN-gsc_entity_mnemonic entity_mnemonic ~
entity_mnemonic_description entity_mnemonic_short_desc ~
auto_properform_strings entity_mnemonic_label_prefix ~
entity_description_field entity_description_procedure entity_narration ~
entity_object_field table_has_object_field entity_key_field ~
table_prefix_length field_name_separator auditing_enabled deploy_data ~
entity_dbname replicate_entity_mnemonic replicate_key scm_field_name ~
version_data 
&Scoped-Define DATA-FIELDS  entity_mnemonic entity_mnemonic_description entity_mnemonic_short_desc~
 auto_properform_strings entity_mnemonic_label_prefix entity_mnemonic_obj~
 entity_description_field entity_description_procedure entity_narration~
 entity_object_field table_has_object_field entity_key_field~
 table_prefix_length field_name_separator auditing_enabled deploy_data~
 entity_dbname replicate_entity_mnemonic replicate_key scm_field_name~
 version_data
&Scoped-define DATA-FIELDS-IN-gsc_entity_mnemonic entity_mnemonic ~
entity_mnemonic_description entity_mnemonic_short_desc ~
auto_properform_strings entity_mnemonic_label_prefix entity_mnemonic_obj ~
entity_description_field entity_description_procedure entity_narration ~
entity_object_field table_has_object_field entity_key_field ~
table_prefix_length field_name_separator auditing_enabled deploy_data ~
entity_dbname replicate_entity_mnemonic replicate_key scm_field_name ~
version_data 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "af/obj2/gscemfullo.i"
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
     _TblList          = "icfdb.gsc_entity_mnemonic"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "icfdb.gsc_entity_mnemonic.entity_mnemonic|yes"
     _FldNameList[1]   > icfdb.gsc_entity_mnemonic.entity_mnemonic
"entity_mnemonic" "entity_mnemonic" ? ? "character" ? ? ? ? ? ? yes ? no 16 yes
     _FldNameList[2]   > icfdb.gsc_entity_mnemonic.entity_mnemonic_description
"entity_mnemonic_description" "entity_mnemonic_description" "Entity Tablename" ? "character" ? ? ? ? ? ? yes ? no 70 yes
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
  Purpose:     Procedure run as part of transaction but at end - to update
               entity display field information
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE BUFFER bgsc_entity_display_field FOR gsc_entity_display_field.

row-loop:
FOR EACH RowObjUpd WHERE CAN-DO("A,C,U":U,RowObjUpd.RowMod):

  IF NOT CAN-FIND(FIRST ttDisplayField
                  WHERE ttDisplayField.entity_mnemonic = RowObjUpd.entity_mnemonic) THEN
    NEXT row-loop.
  
  /* Got correct rowobjupd record for temp-table display fields */
  DO FOR bgsc_entity_display_field:

    /* Delete entity display fields no longer valid or required */
    FOR EACH bgsc_entity_display_field EXCLUSIVE-LOCK
       WHERE bgsc_entity_display_field.entity_mnemonic = rowObjUpd.entity_mnemonic:

      IF NOT CAN-FIND(FIRST ttDisplayField
                      WHERE ttDisplayField.DISPLAY_field_name = bgsc_entity_display_field.DISPLAY_field_name
                        AND ttDisplayField.cInclude = YES) THEN
      DO:
        DELETE bgsc_entity_display_field.
        {af/sup2/afcheckerr.i}
      END.
      
    END.

    /* add/update entity display fields specified for include */      
    FOR EACH ttDisplayField
       WHERE ttDisplayField.cInclude = YES:
      
      FIND FIRST bgsc_entity_display_field EXCLUSIVE-LOCK
           WHERE bgsc_entity_display_field.entity_mnemonic = rowObjUpd.entity_mnemonic
             AND bgsc_entity_display_field.DISPLAY_field_name = ttDisplayField.DISPLAY_field_name
           NO-ERROR.
      IF NOT AVAILABLE bgsc_entity_display_field THEN
      DO:
        CREATE bgsc_entity_display_field.
        {af/sup2/afcheckerr.i}
      END.

      BUFFER-COPY ttDisplayField EXCEPT entity_display_field_obj cInclude cLabel cColLabel cFormat iOrder TO bgsc_entity_display_field.
      {af/sup2/afcheckerr.i}

      VALIDATE bgsc_entity_display_field NO-ERROR.
      {af/sup2/afcheckerr.i}
    
    END.
  
  END. /* do for bgsc_entity_display_field */

END. /* row-loop - loop around rowobjupd records */

ERROR-STATUS:ERROR = NO.
RETURN.
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

DEFINE VARIABLE cValueList      AS CHARACTER    NO-UNDO.

FOR EACH RowObjUpd WHERE CAN-DO('A,C,U':U,RowObjUpd.RowMod): 
  IF (RowObjUpd.RowMod = 'U':U AND
    CAN-FIND(FIRST gsc_entity_mnemonic
      WHERE gsc_entity_mnemonic.entity_mnemonic = rowObjUpd.entity_mnemonic
      AND ROWID(gsc_entity_mnemonic) <> TO-ROWID(ENTRY(1,RowObjUpd.RowIDent))))
  OR (RowObjUpd.RowMod <> 'U':U AND
    CAN-FIND(FIRST gsc_entity_mnemonic
      WHERE gsc_entity_mnemonic.entity_mnemonic = rowObjUpd.entity_mnemonic))
  THEN
    ASSIGN
      cValueList   = STRING(RowObjUpd.entity_mnemonic)
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '8' 'gsc_entity_mnemonic' '' "'entity_mnemonic, '" cValueList }.
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

DEFINE VARIABLE cMessageList        AS CHARACTER    NO-UNDO.
DEFINE VARIABLE hAppServerPortion   AS HANDLE       NO-UNDO.
DEFINE VARIABLE cValueList          AS CHARACTER    NO-UNDO.

  IF LENGTH(RowObject.entity_mnemonic) = 0 OR LENGTH(RowObject.entity_mnemonic) = ? THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '1' 'gsc_entity_mnemonic' 'entity_mnemonic' "'Entity Mnemonic'"}.

  IF LENGTH(RowObject.entity_mnemonic_description) = 0 OR LENGTH(RowObject.entity_mnemonic_description) = ? THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '1' 'gsc_entity_mnemonic' 'entity_mnemonic_description' "'Entity Mnemonic Description'"}.

  IF LENGTH(RowObject.entity_mnemonic_short_desc) = 0 OR LENGTH(RowObject.entity_mnemonic_short_desc) = ? THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '1' 'gsc_entity_mnemonic' 'entity_mnemonic_short_desc' "'Entity Mnemonic Short Description'"}.

  IF LENGTH(RowObject.entity_dbname) = 0 OR LENGTH(RowObject.entity_dbname) = ? THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '1' 'gsc_entity_mnemonic' 'entity_dbname' "'Entity DbName'"}.


  /** Pass the related data through to the server-side (db aware) connection
   *  ----------------------------------------------------------------------- **/
  IF NOT (SESSION:REMOTE OR SESSION:PARAM = "REMOTE":U) THEN
  DO:
      {get asHandle hAppServerPortion}.
      IF VALID-HANDLE(hAppServerPortion) THEN
      DO:
          RUN sendRelatedData IN hAppServerPortion ( INPUT TABLE ttDisplayField) NO-ERROR.
      END.    /* valid client side exists. */
  END.    /* client side only */

  ERROR-STATUS:ERROR = NO.
  RETURN cMessageList.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sendRelatedData dTables 
PROCEDURE sendRelatedData :
/*------------------------------------------------------------------------------
  Purpose:     This procedure exists to receive details of the temp-table for
               updating the entity display field records
  Parameters:  see below
  Notes:       On the client, the viewer runs this from collect changes to pass
               the temp-table details in.
               On the server, this is sent from the client as part of 
               rowobjectvalidate.
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER TABLE FOR ttDisplayField.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

