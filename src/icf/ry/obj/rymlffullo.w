&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          rydb             PROGRESS
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
  File: rymlffullo.w

  Description:  Lookup Field Full SDO

  Purpose:      Lookup Field Full SDO

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        6478   UserRef:    
                Date:   16/08/2000  Author:     Anthony Swindells

  Update Notes: Created from Template rysttasdoo.w

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

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

&scop object-name       rymlffullo.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010001

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
&Scoped-define INTERNAL-TABLES rym_lookup_field

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  lookup_field_name specific_object_name sdf_filename base_query_string~
 disable_lookup query_tables rows_to_batch key_field_name key_field_format~
 key_field_datatype displayed_field_name displayed_field_format~
 displayed_field_datatype field_label field_tooltip browse_title~
 browse_field_list browse_field_datatypes browse_field_formats~
 linked_field_list linked_field_datatypes linked_field_formats~
 linked_widget_list
&Scoped-define ENABLED-FIELDS-IN-rym_lookup_field lookup_field_name ~
specific_object_name sdf_filename base_query_string disable_lookup ~
query_tables rows_to_batch key_field_name key_field_format ~
key_field_datatype displayed_field_name displayed_field_format ~
displayed_field_datatype field_label field_tooltip browse_title ~
browse_field_list browse_field_datatypes browse_field_formats ~
linked_field_list linked_field_datatypes linked_field_formats ~
linked_widget_list 
&Scoped-Define DATA-FIELDS  lookup_field_name specific_object_name sdf_filename base_query_string~
 disable_lookup query_tables rows_to_batch key_field_name key_field_format~
 key_field_datatype displayed_field_name displayed_field_format~
 displayed_field_datatype field_label field_tooltip browse_title~
 browse_field_list browse_field_datatypes browse_field_formats~
 linked_field_list linked_field_datatypes linked_field_formats~
 linked_widget_list lookup_field_obj
&Scoped-define DATA-FIELDS-IN-rym_lookup_field lookup_field_name ~
specific_object_name sdf_filename base_query_string disable_lookup ~
query_tables rows_to_batch key_field_name key_field_format ~
key_field_datatype displayed_field_name displayed_field_format ~
displayed_field_datatype field_label field_tooltip browse_title ~
browse_field_list browse_field_datatypes browse_field_formats ~
linked_field_list linked_field_datatypes linked_field_formats ~
linked_widget_list lookup_field_obj 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "ry/obj/rymlffullo.i"
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH rym_lookup_field NO-LOCK INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main rym_lookup_field
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main rym_lookup_field


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      rym_lookup_field SCROLLING.
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
     _TblList          = "rydb.rym_lookup_field"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > rydb.rym_lookup_field.lookup_field_name
"lookup_field_name" "lookup_field_name" ? ? "character" ? ? ? ? ? ? yes ? no 35 yes
     _FldNameList[2]   > rydb.rym_lookup_field.specific_object_name
"specific_object_name" "specific_object_name" ? ? "character" ? ? ? ? ? ? yes ? no 35 yes
     _FldNameList[3]   > rydb.rym_lookup_field.sdf_filename
"sdf_filename" "sdf_filename" "SDF Filename" ? "character" ? ? ? ? ? ? yes ? no 35 yes
     _FldNameList[4]   > rydb.rym_lookup_field.base_query_string
"base_query_string" "base_query_string" ? ? "character" ? ? ? ? ? ? yes ? no 3000 yes
     _FldNameList[5]   > rydb.rym_lookup_field.disable_lookup
"disable_lookup" "disable_lookup" ? ? "logical" ? ? ? ? ? ? yes ? no 14.8 yes
     _FldNameList[6]   > rydb.rym_lookup_field.query_tables
"query_tables" "query_tables" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[7]   > rydb.rym_lookup_field.rows_to_batch
"rows_to_batch" "rows_to_batch" ? ">>>>>9" "integer" ? ? ? ? ? ? yes ? no 14 yes
     _FldNameList[8]   > rydb.rym_lookup_field.key_field_name
"key_field_name" "key_field_name" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[9]   > rydb.rym_lookup_field.key_field_format
"key_field_format" "key_field_format" ? ? "character" ? ? ? ? ? ? yes ? no 15.6 yes
     _FldNameList[10]   > rydb.rym_lookup_field.key_field_datatype
"key_field_datatype" "key_field_datatype" ? ? "character" ? ? ? ? ? ? yes ? no 17.8 yes
     _FldNameList[11]   > rydb.rym_lookup_field.displayed_field_name
"displayed_field_name" "displayed_field_name" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[12]   > rydb.rym_lookup_field.displayed_field_format
"displayed_field_format" "displayed_field_format" ? ? "character" ? ? ? ? ? ? yes ? no 21.2 yes
     _FldNameList[13]   > rydb.rym_lookup_field.displayed_field_datatype
"displayed_field_datatype" "displayed_field_datatype" ? ? "character" ? ? ? ? ? ? yes ? no 23.4 yes
     _FldNameList[14]   > rydb.rym_lookup_field.field_label
"field_label" "field_label" ? ? "character" ? ? ? ? ? ? yes ? no 28 yes
     _FldNameList[15]   > rydb.rym_lookup_field.field_tooltip
"field_tooltip" "field_tooltip" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[16]   > rydb.rym_lookup_field.browse_title
"browse_title" "browse_title" ? ? "character" ? ? ? ? ? ? yes ? no 35 yes
     _FldNameList[17]   > rydb.rym_lookup_field.browse_field_list
"browse_field_list" "browse_field_list" ? ? "character" ? ? ? ? ? ? yes ? no 500 yes
     _FldNameList[18]   > rydb.rym_lookup_field.browse_field_datatypes
"browse_field_datatypes" "browse_field_datatypes" ? ? "character" ? ? ? ? ? ? yes ? no 500 yes
     _FldNameList[19]   > rydb.rym_lookup_field.browse_field_formats
"browse_field_formats" "browse_field_formats" ? ? "character" ? ? ? ? ? ? yes ? no 500 yes
     _FldNameList[20]   > rydb.rym_lookup_field.linked_field_list
"linked_field_list" "linked_field_list" ? ? "character" ? ? ? ? ? ? yes ? no 500 yes
     _FldNameList[21]   > rydb.rym_lookup_field.linked_field_datatypes
"linked_field_datatypes" "linked_field_datatypes" ? ? "character" ? ? ? ? ? ? yes ? no 500 yes
     _FldNameList[22]   > rydb.rym_lookup_field.linked_field_formats
"linked_field_formats" "linked_field_formats" ? ? "character" ? ? ? ? ? ? yes ? no 500 yes
     _FldNameList[23]   > rydb.rym_lookup_field.linked_widget_list
"linked_widget_list" "linked_widget_list" ? ? "character" ? ? ? ? ? ? yes ? no 500 yes
     _FldNameList[24]   > rydb.rym_lookup_field.lookup_field_obj
"lookup_field_obj" "lookup_field_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 29.4 yes
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowObjectValidate dTables 
PROCEDURE rowObjectValidate :
/*------------------------------------------------------------------------------
  Purpose:     This validation will occur client side as it does not require a 
               DB connection and the db-required flag has been disabled.
  Parameters:  <none>
  Notes:       Here we validate individual fields that are mandatory have been
               entered. Checks that require db reads will be done later in one
               of the transaction validation routines.
               This procedure should batch up the errors using a chr(3) delimiter
               so that all the errors can be dsplayed to the user in one go.
               Be sure not to leave the error status raised !!!
------------------------------------------------------------------------------*/

DEFINE VARIABLE cMessageList                  AS CHARACTER  NO-UNDO.

IF LENGTH(RowObject.LOOKUP_field_name) = 0 THEN
  ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE "":U) +
                        {af/sup2/aferrortxt.i 'AF' '1' 'rym_lookup_field' 'lookup_field_name' "'lookup field name'"}
                        .
RETURN cMessageList.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

