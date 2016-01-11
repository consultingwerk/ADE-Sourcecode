&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          asdb             PROGRESS
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

&scop object-name       gsmddfullo.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010000

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
&Scoped-define INTERNAL-TABLES gsm_dataset_deployment gsc_deploy_dataset

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  deploy_dataset_obj deployment_number deployment_description deployment_date~
 deployment_time baseline_deployment xml_filename xml_exception_file~
 import_date import_time import_user
&Scoped-define ENABLED-FIELDS-IN-gsm_dataset_deployment deploy_dataset_obj ~
deployment_number deployment_description deployment_date deployment_time ~
baseline_deployment xml_filename xml_exception_file import_date import_time ~
import_user 
&Scoped-Define DATA-FIELDS  dataset_deployment_obj deploy_dataset_obj dataset_code owner_site_code~
 deployment_number deployment_description deployment_date deployment_time~
 baseline_deployment xml_filename xml_exception_file import_date import_time~
 import_user
&Scoped-define DATA-FIELDS-IN-gsm_dataset_deployment dataset_deployment_obj ~
deploy_dataset_obj deployment_number deployment_description deployment_date ~
deployment_time baseline_deployment xml_filename xml_exception_file ~
import_date import_time import_user 
&Scoped-define DATA-FIELDS-IN-gsc_deploy_dataset dataset_code ~
owner_site_code 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "af/obj2/gsmddfullo.i"
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH gsm_dataset_deployment NO-LOCK, ~
      FIRST gsc_deploy_dataset WHERE gsc_deploy_dataset.deploy_dataset_obj = gsm_dataset_deployment.deploy_dataset_obj NO-LOCK ~
    BY gsm_dataset_deployment.deploy_dataset_obj ~
       BY gsm_dataset_deployment.deployment_number INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main gsm_dataset_deployment ~
gsc_deploy_dataset
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main gsm_dataset_deployment
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
      gsm_dataset_deployment, 
      gsc_deploy_dataset
    FIELDS(gsc_deploy_dataset.dataset_code
      gsc_deploy_dataset.owner_site_code) SCROLLING.
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
     _TblList          = "asdb.gsm_dataset_deployment,ASDB.gsc_deploy_dataset WHERE asdb.gsm_dataset_deployment ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST USED"
     _OrdList          = "asdb.gsm_dataset_deployment.deploy_dataset_obj|yes,asdb.gsm_dataset_deployment.deployment_number|yes"
     _JoinCode[2]      = "ASDB.gsc_deploy_dataset.deploy_dataset_obj = ASDB.gsm_dataset_deployment.deploy_dataset_obj"
     _FldNameList[1]   > ASDB.gsm_dataset_deployment.dataset_deployment_obj
"dataset_deployment_obj" "dataset_deployment_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 21 yes
     _FldNameList[2]   > ASDB.gsm_dataset_deployment.deploy_dataset_obj
"deploy_dataset_obj" "deploy_dataset_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21 yes
     _FldNameList[3]   > asdb.gsc_deploy_dataset.dataset_code
"dataset_code" "dataset_code" ? ? "character" ? ? ? ? ? ? no ? no 13 yes
     _FldNameList[4]   > ASDB.gsc_deploy_dataset.owner_site_code
"owner_site_code" "owner_site_code" ? ? "character" ? ? ? ? ? ? no ? no 20 yes
     _FldNameList[5]   > ASDB.gsm_dataset_deployment.deployment_number
"deployment_number" "deployment_number" ? ? "decimal" ? ? ? ? ? ? yes ? no 21 yes
     _FldNameList[6]   > ASDB.gsm_dataset_deployment.deployment_description
"deployment_description" "deployment_description" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[7]   > ASDB.gsm_dataset_deployment.deployment_date
"deployment_date" "deployment_date" ? ? "date" ? ? ? ? ? ? yes ? no 4 yes
     _FldNameList[8]   > ASDB.gsm_dataset_deployment.deployment_time
"deployment_time" "deployment_time" ? ? "integer" ? ? ? ? ? ? yes ? no 4 yes
     _FldNameList[9]   > ASDB.gsm_dataset_deployment.baseline_deployment
"baseline_deployment" "baseline_deployment" ? ? "logical" ? ? ? ? ? ? yes ? no 1 yes
     _FldNameList[10]   > ASDB.gsm_dataset_deployment.xml_filename
"xml_filename" "xml_filename" ? ? "character" ? ? ? ? ? ? yes ? no 140 yes
     _FldNameList[11]   > ASDB.gsm_dataset_deployment.xml_exception_file
"xml_exception_file" "xml_exception_file" ? ? "character" ? ? ? ? ? ? yes ? no 140 yes
     _FldNameList[12]   > ASDB.gsm_dataset_deployment.import_date
"import_date" "import_date" ? ? "date" ? ? ? ? ? ? yes ? no 4 yes
     _FldNameList[13]   > ASDB.gsm_dataset_deployment.import_time
"import_time" "import_time" ? ? "integer" ? ? ? ? ? ? yes ? no 4 yes
     _FldNameList[14]   > ASDB.gsm_dataset_deployment.import_user
"import_user" "import_user" ? ? "character" ? ? ? ? ? ? yes ? no 40 yes
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

  DEFINE BUFFER bRowObjUpd FOR RowObjUpd.

  FOR EACH RowObjUpd WHERE CAN-DO('A,C,U':U,RowObjUpd.RowMod): 
    IF (RowObjUpd.RowMod = 'U':U AND
      CAN-FIND(FIRST gsm_dataset_deployment
        WHERE gsm_dataset_deployment.deploy_dataset_obj = RowObjUpd.deploy_dataset_obj
          AND gsm_dataset_deployment.deployment_number = RowObjUpd.deployment_number
          AND ROWID(gsm_dataset_deployment) <> TO-ROWID(ENTRY(1,RowObjUpd.RowIDent))))
    OR (RowObjUpd.RowMod <> 'U':U AND
      CAN-FIND(FIRST gsm_dataset_deployment
        WHERE gsm_dataset_deployment.deploy_dataset_obj = RowObjUpd.deploy_dataset_obj
          AND gsm_dataset_deployment.deployment_number = RowObjUpd.deployment_number))
    THEN
      ASSIGN
        cValueList   = STRING(RowObjUpd.deploy_dataset_obj) + ', ':U + STRING(RowObjUpd.deployment_number)
        cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                      {af/sup2/aferrortxt.i 'AF' '8' 'gsm_dataset_deployment' '' "'deploy_dataset_obj, deployment_number, '" cValueList }.
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

  IF RowObject.deploy_dataset_obj = 0 OR RowObject.deploy_dataset_obj = ? THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '1' 'gsm_dataset_deployment' 'deploy_dataset_obj' "'Deploy Dataset Obj'"}.

  IF LENGTH(RowObject.deployment_description) = 0 OR LENGTH(RowObject.deployment_description) = ? THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '1' 'gsc_dataset_entity' 'deplolyment_description' "'Deployment Description'"}.

  IF RowObject.deployment_date = ? THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '1' 'gsm_dataset_deployment' 'deployment_date' "'Deployment Date'"}.

  IF RowObject.deployment_time = 0 OR RowObject.deployment_time = ? THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '1' 'gsm_dataset_deployment' 'deployment_time' "'Deployment Time'"}.

  ERROR-STATUS:ERROR = NO.
  RETURN cMessageList.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

