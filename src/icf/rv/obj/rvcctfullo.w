&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          asdb             PROGRESS
          rvdb             PROGRESS
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

&scop object-name       rvcctfullo.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataObject yes

{af/sup2/afglobals.i}

&glob DATA-LOGIC-PROCEDURE       rv/obj/rvcctlogcp.p

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
&Scoped-define INTERNAL-TABLES rvc_configuration_type gsc_product_module

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  configuration_type type_table_name type_description type_locked~
 type_deployable baseline_frequency scm_code scm_identifying_fieldname~
 scm_primary_key_fields description_fieldname product_module_obj~
 product_module_fieldname dataset_code
&Scoped-define ENABLED-FIELDS-IN-rvc_configuration_type configuration_type ~
type_table_name type_description type_locked type_deployable ~
baseline_frequency scm_code scm_identifying_fieldname ~
scm_primary_key_fields description_fieldname product_module_obj ~
product_module_fieldname dataset_code 
&Scoped-Define DATA-FIELDS  configuration_type type_table_name type_description type_locked~
 type_deployable baseline_frequency scm_code scm_identifying_fieldname~
 scm_primary_key_fields description_fieldname product_module_obj~
 product_module_code product_module_fieldname configuration_type_obj~
 dataset_code
&Scoped-define DATA-FIELDS-IN-rvc_configuration_type configuration_type ~
type_table_name type_description type_locked type_deployable ~
baseline_frequency scm_code scm_identifying_fieldname ~
scm_primary_key_fields description_fieldname product_module_obj ~
product_module_fieldname configuration_type_obj dataset_code 
&Scoped-define DATA-FIELDS-IN-gsc_product_module product_module_code 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "rv/obj/rvcctfullo.i"
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH rvc_configuration_type NO-LOCK, ~
      FIRST gsc_product_module WHERE gsc_product_module.product_module_obj = rvc_configuration_type.product_module_obj NO-LOCK ~
    BY rvc_configuration_type.configuration_type INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main rvc_configuration_type ~
gsc_product_module
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main rvc_configuration_type
&Scoped-define SECOND-TABLE-IN-QUERY-Query-Main gsc_product_module


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      rvc_configuration_type, 
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
         WIDTH              = 57.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB dTables 
/* ************************* Included-Libraries *********************** */

{src/adm2/data.i}
{src/adm2/datalogic.i}

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
     _TblList          = "rvdb.rvc_configuration_type,ASDB.gsc_product_module WHERE rvdb.rvc_configuration_type ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST USED"
     _OrdList          = "rvdb.rvc_configuration_type.configuration_type|yes"
     _JoinCode[2]      = "ASDB.gsc_product_module.product_module_obj = RVDB.rvc_configuration_type.product_module_obj"
     _FldNameList[1]   > RVDB.rvc_configuration_type.configuration_type
"configuration_type" "configuration_type" ? ? "character" ? ? ? ? ? ? yes ? no 16 yes
     _FldNameList[2]   > RVDB.rvc_configuration_type.type_table_name
"type_table_name" "type_table_name" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[3]   > RVDB.rvc_configuration_type.type_description
"type_description" "type_description" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[4]   > RVDB.rvc_configuration_type.type_locked
"type_locked" "type_locked" ? ? "logical" ? ? ? ? ? ? yes ? no 1 yes
     _FldNameList[5]   > RVDB.rvc_configuration_type.type_deployable
"type_deployable" "type_deployable" ? ? "logical" ? ? ? ? ? ? yes ? no 1 yes
     _FldNameList[6]   > RVDB.rvc_configuration_type.baseline_frequency
"baseline_frequency" "baseline_frequency" ? ? "integer" ? ? ? ? ? ? yes ? no 4 yes
     _FldNameList[7]   > RVDB.rvc_configuration_type.scm_code
"scm_code" "scm_code" ? ? "character" ? ? ? ? ? ? yes ? no 30 yes
     _FldNameList[8]   > RVDB.rvc_configuration_type.scm_identifying_fieldname
"scm_identifying_fieldname" "scm_identifying_fieldname" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[9]   > RVDB.rvc_configuration_type.scm_primary_key_fields
"scm_primary_key_fields" "scm_primary_key_fields" ? ? "character" ? ? ? ? ? ? yes ? no 140 yes
     _FldNameList[10]   > RVDB.rvc_configuration_type.description_fieldname
"description_fieldname" "description_fieldname" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[11]   > RVDB.rvc_configuration_type.product_module_obj
"product_module_obj" "product_module_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21 yes
     _FldNameList[12]   > ASDB.gsc_product_module.product_module_code
"product_module_code" "product_module_code" ? ? "character" ? ? ? ? ? ? no ? no 20 yes
     _FldNameList[13]   > RVDB.rvc_configuration_type.product_module_fieldname
"product_module_fieldname" "product_module_fieldname" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[14]   > RVDB.rvc_configuration_type.configuration_type_obj
"configuration_type_obj" "configuration_type_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 21 yes
     _FldNameList[15]   > RVDB.rvc_configuration_type.dataset_code
"dataset_code" "dataset_code" ? ? "character" ? ? ? ? ? ? yes ? no 20 yes
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject dTables  _DB-REQUIRED
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.
  /***DIAG***/
  MESSAGE {&line-number} PROGRAM-NAME(1) SKIP
      VALID-HANDLE(ghDataLogicProcedure)
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

