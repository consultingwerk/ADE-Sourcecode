&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          icfdb            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
{adecomm/appserv.i}
DEFINE VARIABLE h_Astra                    AS HANDLE          NO-UNDO.
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS dTables 
/*********************************************************************
* Copyright (C) 2001 by Progress Software Corporation ("PSC"),       *
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
/*--------------------------------------------------------------------------
    File        : dobjectlookup.w
    Purpose     : SmartDataObject, it is used to display repository objects
                  in a lookup dialog.

    Syntax      : RUN ry/obj/dobjectlookup.w.

    History     : 016/08/2001      created by          Yongjian Gu
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
&Scoped-define INTERNAL-TABLES ryc_smartobject gsc_object_type ~
gsc_product_module

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS 
&Scoped-Define DATA-FIELDS  smartobject_obj object_type_obj object_type_code product_module_obj~
 product_module_code object_description object_filename object_path~
 runnable_from_menu disabled run_persistent run_when~
 security_smartobject_obj container_object physical_smartobject_obj~
 static_object generic_object required_db_list
&Scoped-define DATA-FIELDS-IN-ryc_smartobject smartobject_obj ~
object_type_obj product_module_obj object_description object_filename ~
object_path runnable_from_menu disabled run_persistent run_when ~
security_smartobject_obj container_object physical_smartobject_obj ~
static_object generic_object required_db_list 
&Scoped-define DATA-FIELDS-IN-gsc_object_type object_type_code 
&Scoped-define DATA-FIELDS-IN-gsc_product_module product_module_code 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "ry/obj/dobjectlookup.i"
&Scoped-define QUERY-STRING-Query-Main FOR EACH ryc_smartobject NO-LOCK, ~
      FIRST gsc_object_type WHERE gsc_object_type.object_type_obj = ryc_smartobject.object_type_obj NO-LOCK, ~
      FIRST gsc_product_module WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj NO-LOCK ~
    BY ryc_smartobject.object_filename INDEXED-REPOSITION
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH ryc_smartobject NO-LOCK, ~
      FIRST gsc_object_type WHERE gsc_object_type.object_type_obj = ryc_smartobject.object_type_obj NO-LOCK, ~
      FIRST gsc_product_module WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj NO-LOCK ~
    BY ryc_smartobject.object_filename INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main ryc_smartobject gsc_object_type ~
gsc_product_module
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main ryc_smartobject
&Scoped-define SECOND-TABLE-IN-QUERY-Query-Main gsc_object_type
&Scoped-define THIRD-TABLE-IN-QUERY-Query-Main gsc_product_module


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      ryc_smartobject, 
      gsc_object_type
    FIELDS(gsc_object_type.object_type_code), 
      gsc_product_module
    FIELDS(gsc_product_module.product_module_code) SCROLLING.
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
         WIDTH              = 55.
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
     _TblList          = "icfdb.ryc_smartobject,icfdb.gsc_object_type WHERE icfdb.ryc_smartobject ...,icfdb.gsc_product_module WHERE icfdb.ryc_smartobject ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST USED, FIRST USED"
     _OrdList          = "icfdb.ryc_smartobject.object_filename|yes"
     _JoinCode[2]      = "icfdb.gsc_object_type.object_type_obj = icfdb.ryc_smartobject.object_type_obj"
     _JoinCode[3]      = "icfdb.gsc_product_module.product_module_obj = icfdb.ryc_smartobject.product_module_obj"
     _FldNameList[1]   > icfdb.ryc_smartobject.smartobject_obj
"smartobject_obj" "smartobject_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 29.4 yes
     _FldNameList[2]   > icfdb.ryc_smartobject.object_type_obj
"object_type_obj" "object_type_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 29.4 yes
     _FldNameList[3]   > icfdb.gsc_object_type.object_type_code
"object_type_code" "object_type_code" ? "X(30)" "character" ? ? ? ? ? ? no ? no 30 yes
     _FldNameList[4]   > icfdb.ryc_smartobject.product_module_obj
"product_module_obj" "product_module_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 29.4 yes
     _FldNameList[5]   > icfdb.gsc_product_module.product_module_code
"product_module_code" "product_module_code" ? ? "character" ? ? ? ? ? ? no ? no 20.6 yes
     _FldNameList[6]   > icfdb.ryc_smartobject.object_description
"object_description" "object_description" ? ? "character" ? ? ? ? ? ? no ? no 35 yes
     _FldNameList[7]   > icfdb.ryc_smartobject.object_filename
"object_filename" "object_filename" ? ? "character" ? ? ? ? ? ? no ? no 35 yes
     _FldNameList[8]   > icfdb.ryc_smartobject.object_path
"object_path" "object_path" ? ? "character" ? ? ? ? ? ? no ? no 70 yes
     _FldNameList[9]   > icfdb.ryc_smartobject.runnable_from_menu
"runnable_from_menu" "runnable_from_menu" ? ? "logical" ? ? ? ? ? ? no ? no 20.4 yes
     _FldNameList[10]   > icfdb.ryc_smartobject.disabled
"disabled" "disabled" ? ? "logical" ? ? ? ? ? ? no ? no 8.2 yes
     _FldNameList[11]   > icfdb.ryc_smartobject.run_persistent
"run_persistent" "run_persistent" ? ? "logical" ? ? ? ? ? ? no ? no 13.8 yes
     _FldNameList[12]   > icfdb.ryc_smartobject.run_when
"run_when" "run_when" ? ? "character" ? ? ? ? ? ? no ? no 10.4 yes
     _FldNameList[13]   > icfdb.ryc_smartobject.security_smartobject_obj
"security_smartobject_obj" "security_smartobject_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 29.4 yes
     _FldNameList[14]   > icfdb.ryc_smartobject.container_object
"container_object" "container_object" ? ? "logical" ? ? ? ? ? ? no ? no 15.8 yes
     _FldNameList[15]   > icfdb.ryc_smartobject.physical_smartobject_obj
"physical_smartobject_obj" "physical_smartobject_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 29.4 yes
     _FldNameList[16]   > icfdb.ryc_smartobject.static_object
"static_object" "static_object" ? ? "logical" ? ? ? ? ? ? no ? no 13.6 yes
     _FldNameList[17]   > icfdb.ryc_smartobject.generic_object
"generic_object" "generic_object" ? ? "logical" ? ? ? ? ? ? no ? no 14.2 yes
     _FldNameList[18]   > icfdb.ryc_smartobject.required_db_list
"required_db_list" "required_db_list" ? ? "character" ? ? ? ? ? ? no ? no 35 yes
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

