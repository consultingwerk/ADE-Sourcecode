&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          rydb             PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
{adecomm/appserv.i}
DEFINE VARIABLE h_Astra                    AS HANDLE          NO-UNDO.
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
/*------------------------------------------------------------------------

  File:  

  Description: from DATA.W - Template For SmartData objects in the ADM

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Modified:     February 24, 1999
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

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
&Scoped-define INTERNAL-TABLES ryc_smartobject_field

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  database_field database_table enable_on_create enable_on_modify~
 field_column_label field_datatype field_default field_enabled field_format~
 field_label field_name field_sequence field_tooltip field_view_as~
 filter_field find_field index_list initial_focus_field smartfield_filename~
 smartobject_obj sort_descending sort_field use_as_description_field~
 use_as_object_field use_as_title_field widget_type_obj
&Scoped-define ENABLED-FIELDS-IN-ryc_smartobject_field database_field ~
database_table enable_on_create enable_on_modify field_column_label ~
field_datatype field_default field_enabled field_format field_label ~
field_name field_sequence field_tooltip field_view_as filter_field ~
find_field index_list initial_focus_field smartfield_filename ~
smartobject_obj sort_descending sort_field use_as_description_field ~
use_as_object_field use_as_title_field widget_type_obj 
&Scoped-Define DATA-FIELDS  database_field database_table enable_on_create enable_on_modify~
 field_column_label field_datatype field_default field_enabled field_format~
 field_label field_name field_sequence field_tooltip field_view_as~
 filter_field find_field index_list initial_focus_field smartfield_filename~
 smartobject_field_obj smartobject_obj sort_descending sort_field~
 use_as_description_field use_as_object_field use_as_title_field~
 widget_type_obj
&Scoped-define DATA-FIELDS-IN-ryc_smartobject_field database_field ~
database_table enable_on_create enable_on_modify field_column_label ~
field_datatype field_default field_enabled field_format field_label ~
field_name field_sequence field_tooltip field_view_as filter_field ~
find_field index_list initial_focus_field smartfield_filename ~
smartobject_field_obj smartobject_obj sort_descending sort_field ~
use_as_description_field use_as_object_field use_as_title_field ~
widget_type_obj 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "ry/obj/rycsffullo.i"
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH ryc_smartobject_field NO-LOCK INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main ryc_smartobject_field
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main ryc_smartobject_field


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      ryc_smartobject_field SCROLLING.
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
     _TblList          = "RYDB.ryc_smartobject_field"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > RYDB.ryc_smartobject_field.database_field
"database_field" "database_field" ? ? "character" ? ? ? ? ? ? yes ? no 35 yes
     _FldNameList[2]   > RYDB.ryc_smartobject_field.database_table
"database_table" "database_table" ? ? "character" ? ? ? ? ? ? yes ? no 35 yes
     _FldNameList[3]   > RYDB.ryc_smartobject_field.enable_on_create
"enable_on_create" "enable_on_create" ? ? "logical" ? ? ? ? ? ? yes ? no 16.8 yes
     _FldNameList[4]   > RYDB.ryc_smartobject_field.enable_on_modify
"enable_on_modify" "enable_on_modify" ? ? "logical" ? ? ? ? ? ? yes ? no 16.8 yes
     _FldNameList[5]   > RYDB.ryc_smartobject_field.field_column_label
"field_column_label" "field_column_label" ? ? "character" ? ? ? ? ? ? yes ? no 28 yes
     _FldNameList[6]   > RYDB.ryc_smartobject_field.field_datatype
"field_datatype" "field_datatype" ? ? "character" ? ? ? ? ? ? yes ? no 15 yes
     _FldNameList[7]   > RYDB.ryc_smartobject_field.field_default
"field_default" "field_default" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[8]   > RYDB.ryc_smartobject_field.field_enabled
"field_enabled" "field_enabled" ? ? "logical" ? ? ? ? ? ? yes ? no 12.8 yes
     _FldNameList[9]   > RYDB.ryc_smartobject_field.field_format
"field_format" "field_format" ? ? "character" ? ? ? ? ? ? yes ? no 28 yes
     _FldNameList[10]   > RYDB.ryc_smartobject_field.field_label
"field_label" "field_label" ? ? "character" ? ? ? ? ? ? yes ? no 28 yes
     _FldNameList[11]   > RYDB.ryc_smartobject_field.field_name
"field_name" "field_name" ? ? "character" ? ? ? ? ? ? yes ? no 35 yes
     _FldNameList[12]   > RYDB.ryc_smartobject_field.field_sequence
"field_sequence" "field_sequence" ? ? "integer" ? ? ? ? ? ? yes ? no 9.4 yes
     _FldNameList[13]   > RYDB.ryc_smartobject_field.field_tooltip
"field_tooltip" "field_tooltip" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[14]   > RYDB.ryc_smartobject_field.field_view_as
"field_view_as" "field_view_as" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[15]   > RYDB.ryc_smartobject_field.filter_field
"filter_field" "filter_field" ? ? "logical" ? ? ? ? ? ? yes ? no 9.4 yes
     _FldNameList[16]   > RYDB.ryc_smartobject_field.find_field
"find_field" "find_field" ? ? "logical" ? ? ? ? ? ? yes ? no 9 yes
     _FldNameList[17]   > RYDB.ryc_smartobject_field.index_list
"index_list" "index_list" ? ? "character" ? ? ? ? ? ? yes ? no 35 yes
     _FldNameList[18]   > RYDB.ryc_smartobject_field.initial_focus_field
"initial_focus_field" "initial_focus_field" ? ? "logical" ? ? ? ? ? ? yes ? no 16.2 yes
     _FldNameList[19]   > RYDB.ryc_smartobject_field.smartfield_filename
"smartfield_filename" "smartfield_filename" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[20]   > RYDB.ryc_smartobject_field.smartobject_field_obj
"smartobject_field_obj" "smartobject_field_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 21.6 yes
     _FldNameList[21]   > RYDB.ryc_smartobject_field.smartobject_obj
"smartobject_obj" "smartobject_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21.6 yes
     _FldNameList[22]   > RYDB.ryc_smartobject_field.sort_descending
"sort_descending" "sort_descending" ? ? "logical" ? ? ? ? ? ? yes ? no 15.8 yes
     _FldNameList[23]   > RYDB.ryc_smartobject_field.sort_field
"sort_field" "sort_field" ? ? "logical" ? ? ? ? ? ? yes ? no 8.8 yes
     _FldNameList[24]   > RYDB.ryc_smartobject_field.use_as_description_field
"use_as_description_field" "use_as_description_field" ? ? "logical" ? ? ? ? ? ? yes ? no 22.8 yes
     _FldNameList[25]   > RYDB.ryc_smartobject_field.use_as_object_field
"use_as_object_field" "use_as_object_field" ? ? "logical" ? ? ? ? ? ? yes ? no 18.4 yes
     _FldNameList[26]   > RYDB.ryc_smartobject_field.use_as_title_field
"use_as_title_field" "use_as_title_field" ? ? "logical" ? ? ? ? ? ? yes ? no 16.2 yes
     _FldNameList[27]   > RYDB.ryc_smartobject_field.widget_type_obj
"widget_type_obj" "widget_type_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21.6 yes
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
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH RowObjUpd WHERE RowMod = "A":

        FIND ryc_widget_type NO-LOCK WHERE WIDGET_type_name = "FILLIN".
        ASSIGN RowObjUpd.WIDGET_type_obj = ryc_widget_type.WIDGET_type_obj.
        MESSAGE "about to assign with smartobject_obj=" RowObjUpd.smartobject_obj.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

