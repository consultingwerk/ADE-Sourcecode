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
&scop object-name       rycsoful2o.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000
/* Parameters Definitions ---                                           */
/* Local Variable Definitions ---                                       */
/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataObject yes
{af/sup2/afglobals.i}


{ry/inc/ryrepprmod.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Global-define DATA-LOGIC-PROCEDURE ry/obj/rycsolog2p.p

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
&Scoped-define INTERNAL-TABLES ryc_smartobject gsc_product_module

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  object_type_obj dProductObj product_module_obj object_description~
 object_filename object_path runnable_from_menu disabled run_persistent~
 run_when security_smartobject_obj container_object generic_object~
 required_db_list layout_obj sdo_smartobject_obj shutdown_message_text~
 static_object system_owned template_smartobject customization_result_obj~
 deployment_type design_only extends_smartobject_obj object_is_runnable
&Scoped-define ENABLED-FIELDS-IN-ryc_smartobject object_type_obj ~
product_module_obj object_description object_filename object_path ~
runnable_from_menu disabled run_persistent run_when ~
security_smartobject_obj container_object generic_object required_db_list ~
layout_obj sdo_smartobject_obj shutdown_message_text static_object ~
system_owned template_smartobject customization_result_obj deployment_type ~
design_only extends_smartobject_obj object_is_runnable 
&Scoped-Define DATA-FIELDS  smartobject_obj object_type_obj product_obj dProductObj product_module_obj~
 object_description object_filename object_path runnable_from_menu disabled~
 run_persistent run_when security_smartobject_obj container_object~
 generic_object required_db_list layout_obj sdo_smartobject_obj~
 shutdown_message_text static_object system_owned template_smartobject~
 object_extension product_module_code product_module_description~
 customization_result_obj deployment_type design_only~
 extends_smartobject_obj object_is_runnable CustomizedResultCode
&Scoped-define DATA-FIELDS-IN-ryc_smartobject smartobject_obj ~
object_type_obj product_module_obj object_description object_filename ~
object_path runnable_from_menu disabled run_persistent run_when ~
security_smartobject_obj container_object generic_object required_db_list ~
layout_obj sdo_smartobject_obj shutdown_message_text static_object ~
system_owned template_smartobject object_extension customization_result_obj ~
deployment_type design_only extends_smartobject_obj object_is_runnable 
&Scoped-define DATA-FIELDS-IN-gsc_product_module product_obj ~
product_module_code product_module_description 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "ry/obj/rycsoful2o.i"
&Scoped-define QUERY-STRING-Query-Main FOR EACH ryc_smartobject NO-LOCK, ~
      FIRST gsc_product_module WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj NO-LOCK ~
    BY ryc_smartobject.object_filename INDEXED-REPOSITION
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH ryc_smartobject NO-LOCK, ~
      FIRST gsc_product_module WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj NO-LOCK ~
    BY ryc_smartobject.object_filename INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main ryc_smartobject ~
gsc_product_module
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main ryc_smartobject
&Scoped-define SECOND-TABLE-IN-QUERY-Query-Main gsc_product_module


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getResultCode dTables  _DB-REQUIRED
FUNCTION getResultCode RETURNS CHARACTER
  ( pdCustomizationResultObj AS DECIMAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}


/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      ryc_smartobject, 
      gsc_product_module SCROLLING.
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
     _TblList          = "ICFDB.ryc_smartobject,ICFDB.gsc_product_module WHERE ICFDB.ryc_smartobject ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST"
     _OrdList          = "ICFDB.ryc_smartobject.object_filename|yes"
     _JoinCode[2]      = "gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj"
     _FldNameList[1]   > icfdb.ryc_smartobject.smartobject_obj
"smartobject_obj" "smartobject_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 29.4 yes
     _FldNameList[2]   > icfdb.ryc_smartobject.object_type_obj
"object_type_obj" "object_type_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 29.4 yes
     _FldNameList[3]   > icfdb.gsc_product_module.product_obj
"product_obj" "product_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 33 yes
     _FldNameList[4]   > "_<CALC>"
"RowObject.product_obj" "dProductObj" "Product Obj" "->>>>>>>>>>>>>>>>>9.999999999" "Decimal" ? ? ? ? ? ? yes ? no 33.6 no
     _FldNameList[5]   > icfdb.ryc_smartobject.product_module_obj
"product_module_obj" "product_module_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 29.4 yes
     _FldNameList[6]   > icfdb.ryc_smartobject.object_description
"object_description" "object_description" ? ? "character" ? ? ? ? ? ? yes ? no 35 yes
     _FldNameList[7]   > icfdb.ryc_smartobject.object_filename
"object_filename" "object_filename" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[8]   > icfdb.ryc_smartobject.object_path
"object_path" "object_path" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[9]   > icfdb.ryc_smartobject.runnable_from_menu
"runnable_from_menu" "runnable_from_menu" ? ? "logical" ? ? ? ? ? ? yes ? no 20.4 yes
     _FldNameList[10]   > icfdb.ryc_smartobject.disabled
"disabled" "disabled" ? ? "logical" ? ? ? ? ? ? yes ? no 8.2 yes
     _FldNameList[11]   > icfdb.ryc_smartobject.run_persistent
"run_persistent" "run_persistent" ? ? "logical" ? ? ? ? ? ? yes ? no 13.8 yes
     _FldNameList[12]   > icfdb.ryc_smartobject.run_when
"run_when" "run_when" ? ? "character" ? ? ? ? ? ? yes ? no 10.4 yes
     _FldNameList[13]   > icfdb.ryc_smartobject.security_smartobject_obj
"security_smartobject_obj" "security_smartobject_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 33 yes
     _FldNameList[14]   > icfdb.ryc_smartobject.container_object
"container_object" "container_object" ? ? "logical" ? ? ? ? ? ? yes ? no 15.8 yes
     _FldNameList[15]   > icfdb.ryc_smartobject.generic_object
"generic_object" "generic_object" ? ? "logical" ? ? ? ? ? ? yes ? no 14.2 yes
     _FldNameList[16]   > icfdb.ryc_smartobject.required_db_list
"required_db_list" "required_db_list" ? ? "character" ? ? ? ? ? ? yes ? no 35 yes
     _FldNameList[17]   > icfdb.ryc_smartobject.layout_obj
"layout_obj" "layout_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 29.4 yes
     _FldNameList[18]   > icfdb.ryc_smartobject.sdo_smartobject_obj
"sdo_smartobject_obj" "sdo_smartobject_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 29.4 yes
     _FldNameList[19]   > icfdb.ryc_smartobject.shutdown_message_text
"shutdown_message_text" "shutdown_message_text" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[20]   > icfdb.ryc_smartobject.static_object
"static_object" "static_object" ? ? "logical" ? ? ? ? ? ? yes ? no 12.2 yes
     _FldNameList[21]   > icfdb.ryc_smartobject.system_owned
"system_owned" "system_owned" ? ? "logical" ? ? ? ? ? ? yes ? no 14.2 yes
     _FldNameList[22]   > icfdb.ryc_smartobject.template_smartobject
"template_smartobject" "template_smartobject" ? ? "logical" ? ? ? ? ? ? yes ? no 21 yes
     _FldNameList[23]   > icfdb.ryc_smartobject.object_extension
"object_extension" "object_extension" ? ? "character" ? ? ? ? ? ? no ? no 35 yes
     _FldNameList[24]   > icfdb.gsc_product_module.product_module_code
"product_module_code" "product_module_code" ? ? "character" ? ? ? ? ? ? no ? no 20.6 yes
     _FldNameList[25]   > icfdb.gsc_product_module.product_module_description
"product_module_description" "product_module_description" ? ? "character" ? ? ? ? ? ? no ? no 35 yes
     _FldNameList[26]   > ICFDB.ryc_smartobject.customization_result_obj
"customization_result_obj" "customization_result_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 33.6 yes
     _FldNameList[27]   > ICFDB.ryc_smartobject.deployment_type
"deployment_type" "deployment_type" ? ? "character" ? ? ? ? ? ? yes ? no 35 yes
     _FldNameList[28]   > ICFDB.ryc_smartobject.design_only
"design_only" "design_only" ? ? "logical" ? ? ? ? ? ? yes ? no 11.4 yes
     _FldNameList[29]   > ICFDB.ryc_smartobject.extends_smartobject_obj
"extends_smartobject_obj" "extends_smartobject_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 33.6 yes
     _FldNameList[30]   > ICFDB.ryc_smartobject.object_is_runnable
"object_is_runnable" "object_is_runnable" ? ? "logical" ? ? ? ? ? ? yes ? no 17 no
     _FldNameList[31]   > "_<CALC>"
"getResultCode(RowObject.customization_result_obj)" "CustomizedResultCode" "CustomizedResultCode" "x(35)" "character" ? ? ? ? ? ? no ? no 35 no
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
         rowObject.CustomizedResultCode = (getResultCode(RowObject.customization_result_obj))
         rowObject.dProductObj = (RowObject.product_obj)
      .

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject dTables 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cFilterSetClause  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFilterSetCode    AS CHARACTER  NO-UNDO.

  DYNAMIC-FUNCTION("setOpenOnInit", FALSE).

  RUN SUPER.
  /*
  RUN getFilterSetClause IN gshGenManager (INPUT-OUTPUT cFilterSetCode,           /* FilterSetCode        */
                                           INPUT        "GSCPM,RYCSO":U,          /* EntityList           */
                                           INPUT        "gsc_product_module,":U,  /* BufferList           */
                                           INPUT        "":U,                     /* AdditionalArguments  */
                                           OUTPUT       cFilterSetClause).        /* FilterSetClause      */

  DYNAMIC-FUNCTION("addQueryWhere":U, cFilterSetClause, "gsc_product_module":U, "AND":U).
  {set manualAddQueryWhere cFilterSetClause}.
  */
  DYNAMIC-FUNCTION("OpenQuery").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getResultCode dTables  _DB-REQUIRED
FUNCTION getResultCode RETURNS CHARACTER
  ( pdCustomizationResultObj AS DECIMAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  FIND FIRST ryc_customization_result
       WHERE ryc_customization_result.customization_result_obj = pdCustomizationResultObj
       NO-LOCK NO-ERROR.

  IF AVAILABLE ryc_customization_result THEN
    RETURN "(" + TRIM(ryc_customization_result.customization_result_code) + ")":U.   
  ELSE 
    RETURN "":U.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

