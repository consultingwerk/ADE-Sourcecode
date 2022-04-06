&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          icfdb            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
{adecomm/appserv.i}
DEFINE VARIABLE h_Astra                    AS HANDLE          NO-UNDO.
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS dTables 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    File        : dopendialog.w
    Purpose     : SmartDataObject, it is used in Open Object Dialog to 
                  locate and open an object in the repository.

    Syntax      : 

    History     : 08/06/2002     Update by            Don Bulua
                  IZ: 5536 Removed the appBuilder shared temp table 
                  includes and proc createRYObject so SDO works across 
                  appServer. Moved procedure to container.
                  
                  02/25/2002      Updated by          Ross Hunter
                  Allow opening of Dynamic Viewers (DynView)

                  11/07/2001      Updated by          John Palazzo (jep)
                  IZ 2342 : MRU List doesn't work with dynamics objects.

                  10/11/2001      Updated by          John Palazzo (jep)
                  IZ 2467 - Open object cannot open Static SDV.
                  Fix: Added object_extension so AppBuilder can form
                  the file name to open correctly.

                  09/30/2001      Updated by          John Palazzo (jep)
                  IZ 2009 Objects the AB can't open are in dialog
                  Fix: Filter the Object Type combo query and the
                  SDO query with preprocessor gcOpenObjectTypes, which
                  lists the object type codes that the AB knows to open.
                  
                  08/16/2001      created by          Yongjian Gu
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


/* IZ 2009: jep-icf: Valid object_type_code the AppBuilder can open. */
&GLOBAL-DEFINE gcOpenObjectTypes DynDataView,StaticDataView,DynObjc,DynMenc,DynFold,DynTree,DynBrow,DynView,DynSDO,Shell,hhpFile,hhcFile,DatFile,CGIProcedure,SBO,StaticSO,StaticFrame,StaticSDF,StaticDiag,StaticCont,StaticMenc,StaticObjc,StaticFold,StaticSDV,StaticSDB,SDO,JavaScript,CGIWrapper,SmartViewer,SmartQuery,SmartPanel,SmartFrame,SmartBrowser,SmartB2BObject,Container,Procedure,Window,SmartWindow,SmartFolder,SmartDialog,DLProc,SmartSender,SmartReceiver,SmartLOBField

DEFINE VARIABLE gcOpenObjectTypes AS CHARACTER  NO-UNDO.
ASSIGN gcOpenObjectTypes = "{&gcOpenObjectTypes}":U.

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
&Scoped-Define ENABLED-FIELDS  product_obj layout_obj sdo_smartobject_obj shutdown_message_text~
 system_owned template_smartobject product_module_description~
 customization_result_obj deployment_type design_only~
 extends_smartobject_obj object_is_runnable
&Scoped-define ENABLED-FIELDS-IN-ryc_smartobject layout_obj ~
sdo_smartobject_obj shutdown_message_text system_owned template_smartobject ~
customization_result_obj deployment_type design_only ~
extends_smartobject_obj object_is_runnable 
&Scoped-define ENABLED-FIELDS-IN-gsc_product_module product_obj ~
product_module_description 
&Scoped-Define DATA-FIELDS  smartobject_obj object_type_obj product_obj dProductObj product_module_obj~
 object_description object_filename object_path runnable_from_menu disabled~
 run_persistent run_when security_smartobject_obj container_object~
 generic_object required_db_list layout_obj sdo_smartobject_obj~
 shutdown_message_text static_object system_owned template_smartobject~
 object_extension product_module_code product_module_description~
 customization_result_obj deployment_type design_only~
 extends_smartobject_obj object_type_code relative_path object_is_runnable
&Scoped-define DATA-FIELDS-IN-ryc_smartobject smartobject_obj ~
object_type_obj product_module_obj object_description object_filename ~
object_path runnable_from_menu disabled run_persistent run_when ~
security_smartobject_obj container_object generic_object required_db_list ~
layout_obj sdo_smartobject_obj shutdown_message_text static_object ~
system_owned template_smartobject object_extension customization_result_obj ~
deployment_type design_only extends_smartobject_obj object_is_runnable 
&Scoped-define DATA-FIELDS-IN-gsc_object_type object_type_code 
&Scoped-define DATA-FIELDS-IN-gsc_product_module product_obj ~
product_module_code product_module_description relative_path 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "ry/obj/dopendialog.i"
&Scoped-define QUERY-STRING-Query-Main FOR EACH ryc_smartobject ~
      WHERE ryc_smartobject.customization_result_obj = 0 ~
USE-INDEX XAK1ryc_smartObject NO-LOCK, ~
      EACH gsc_object_type OF ryc_smartobject NO-LOCK, ~
      FIRST gsc_product_module OF ryc_smartobject NO-LOCK INDEXED-REPOSITION
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH ryc_smartobject ~
      WHERE ryc_smartobject.customization_result_obj = 0 ~
USE-INDEX XAK1ryc_smartObject NO-LOCK, ~
      EACH gsc_object_type OF ryc_smartobject NO-LOCK, ~
      FIRST gsc_product_module OF ryc_smartobject NO-LOCK INDEXED-REPOSITION.
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


/* ************************  Function Prototypes ********************** */

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getObjectTypes dTables  _DB-REQUIRED
FUNCTION getObjectTypes RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}


/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      ryc_smartobject, 
      gsc_object_type
    FIELDS(gsc_object_type.object_type_code), 
      gsc_product_module
    FIELDS(gsc_product_module.product_obj
      gsc_product_module.product_module_code
      gsc_product_module.product_module_description
      gsc_product_module.relative_path) SCROLLING.
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
         WIDTH              = 50.
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
     _TblList          = "ICFDB.ryc_smartobject,ICFDB.gsc_object_type OF ICFDB.ryc_smartobject,ICFDB.gsc_product_module OF ICFDB.ryc_smartobject"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", USED, FIRST USED"
     _Where[1]         = "ICFDB.ryc_smartobject.customization_result_obj = 0
USE-INDEX XAK1ryc_smartObject"
     _JoinCode[3]      = "gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj"
     _FldNameList[1]   > icfdb.ryc_smartobject.smartobject_obj
"smartobject_obj" "smartobject_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 29.4 yes ?
     _FldNameList[2]   > icfdb.ryc_smartobject.object_type_obj
"object_type_obj" "object_type_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 29.4 yes ?
     _FldNameList[3]   > icfdb.gsc_product_module.product_obj
"product_obj" "product_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 33.6 yes ?
     _FldNameList[4]   > "_<CALC>"
"RowObject.product_obj" "dProductObj" "Product Obj" "->>>>>>>>>>>>>>>>>9.999999999" "Decimal" ? ? ? ? ? ? no ? no 33.6 no ?
     _FldNameList[5]   > icfdb.ryc_smartobject.product_module_obj
"product_module_obj" "product_module_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 29.4 yes ?
     _FldNameList[6]   > icfdb.ryc_smartobject.object_description
"object_description" "object_description" ? ? "character" ? ? ? ? ? ? no ? no 35 yes ?
     _FldNameList[7]   > icfdb.ryc_smartobject.object_filename
"object_filename" "object_filename" ? ? "character" ? ? ? ? ? ? no ? no 35 yes ?
     _FldNameList[8]   > icfdb.ryc_smartobject.object_path
"object_path" "object_path" ? ? "character" ? ? ? ? ? ? no ? no 70 yes ?
     _FldNameList[9]   > icfdb.ryc_smartobject.runnable_from_menu
"runnable_from_menu" "runnable_from_menu" ? ? "logical" ? ? ? ? ? ? no ? no 20.4 yes ?
     _FldNameList[10]   > icfdb.ryc_smartobject.disabled
"disabled" "disabled" ? ? "logical" ? ? ? ? ? ? no ? no 8.2 yes ?
     _FldNameList[11]   > icfdb.ryc_smartobject.run_persistent
"run_persistent" "run_persistent" ? ? "logical" ? ? ? ? ? ? no ? no 13.8 yes ?
     _FldNameList[12]   > icfdb.ryc_smartobject.run_when
"run_when" "run_when" ? ? "character" ? ? ? ? ? ? no ? no 10.4 yes ?
     _FldNameList[13]   > icfdb.ryc_smartobject.security_smartobject_obj
"security_smartobject_obj" "security_smartobject_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 29.4 yes ?
     _FldNameList[14]   > icfdb.ryc_smartobject.container_object
"container_object" "container_object" ? ? "logical" ? ? ? ? ? ? no ? no 15.8 yes ?
     _FldNameList[15]   > icfdb.ryc_smartobject.generic_object
"generic_object" "generic_object" ? ? "logical" ? ? ? ? ? ? no ? no 14.2 yes ?
     _FldNameList[16]   > icfdb.ryc_smartobject.required_db_list
"required_db_list" "required_db_list" ? ? "character" ? ? ? ? ? ? no ? no 35 yes ?
     _FldNameList[17]   > icfdb.ryc_smartobject.layout_obj
"layout_obj" "layout_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 33.6 yes ?
     _FldNameList[18]   > icfdb.ryc_smartobject.sdo_smartobject_obj
"sdo_smartobject_obj" "sdo_smartobject_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 33.6 yes ?
     _FldNameList[19]   > icfdb.ryc_smartobject.shutdown_message_text
"shutdown_message_text" "shutdown_message_text" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes ?
     _FldNameList[20]   > icfdb.ryc_smartobject.static_object
"static_object" "static_object" ? ? "logical" ? ? ? ? ? ? no ? no 13.6 yes ?
     _FldNameList[21]   > icfdb.ryc_smartobject.system_owned
"system_owned" "system_owned" ? ? "logical" ? ? ? ? ? ? yes ? no 14.2 yes ?
     _FldNameList[22]   > icfdb.ryc_smartobject.template_smartobject
"template_smartobject" "template_smartobject" ? ? "logical" ? ? ? ? ? ? yes ? no 21 yes ?
     _FldNameList[23]   > icfdb.ryc_smartobject.object_extension
"object_extension" "object_extension" ? ? "character" ? ? ? ? ? ? no ? no 35 yes ?
     _FldNameList[24]   > icfdb.gsc_product_module.product_module_code
"product_module_code" "product_module_code" ? ? "character" ? ? ? ? ? ? no ? no 20.6 yes ?
     _FldNameList[25]   > icfdb.gsc_product_module.product_module_description
"product_module_description" "product_module_description" ? ? "character" ? ? ? ? ? ? yes ? no 35 yes ?
     _FldNameList[26]   > icfdb.ryc_smartobject.customization_result_obj
"customization_result_obj" "customization_result_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 33.6 yes ?
     _FldNameList[27]   > icfdb.ryc_smartobject.deployment_type
"deployment_type" "deployment_type" ? ? "character" ? ? ? ? ? ? yes ? no 35 yes ?
     _FldNameList[28]   > icfdb.ryc_smartobject.design_only
"design_only" "design_only" ? ? "logical" ? ? ? ? ? ? yes ? no 11.4 yes ?
     _FldNameList[29]   > icfdb.ryc_smartobject.extends_smartobject_obj
"extends_smartobject_obj" "extends_smartobject_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 33.6 yes ?
     _FldNameList[30]   > icfdb.gsc_object_type.object_type_code
"object_type_code" "object_type_code" ? ? "character" ? ? ? ? ? ? no ? no 30 yes ?
     _FldNameList[31]   > ICFDB.gsc_product_module.relative_path
"relative_path" "relative_path" ? ? "character" ? ? ? ? ? ? no ? no 70 no ?
     _FldNameList[32]   > ICFDB.ryc_smartobject.object_is_runnable
"object_is_runnable" "object_is_runnable" ? ? "logical" ? ? ? ? ? ? yes ? no 17 no ?
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

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject dTables  _DB-REQUIRED
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cWhere       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cObjectTypes AS CHARACTER  NO-UNDO.

  {set openOnInit FALSE}.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

  /* Add all the classes we may open to the query */

  IF VALID-HANDLE(gshRepositoryManager) THEN
    ASSIGN cObjectTypes = getObjectTypes()
           cWhere            = "LOOKUP(gsc_object_type.object_type_code, '" + cObjectTypes + "') > 0".

  DYNAMIC-FUNCTION("addQueryWhere":U IN TARGET-PROCEDURE
                  ,INPUT cWhere
                  ,INPUT "":U
                  ,INPUT "AND":U).
  {set manualAddQueryWhere cWhere}.

  DYNAMIC-FUNCTION("openQuery":U IN TARGET-PROCEDURE).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

/* ************************  Function Implementations ***************** */

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjectTypes dTables  _DB-REQUIRED
FUNCTION getObjectTypes RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a list off supported object types.
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cObjectTypes AS CHARACTER  NO-UNDO.
ASSIGN cObjectTypes = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT gcOpenObjectTypes)
       cObjectTypes = REPLACE(cObjectTypes, CHR(3), ",":U).

RETURN cObjectTypes.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

