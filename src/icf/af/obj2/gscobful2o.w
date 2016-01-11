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
  File: gscobful2o.w

  Description:  Template Astra 2 SmartDataObject Templat

  Purpose:      Template Astra 2 SmartDataObject Template

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:        6180   UserRef:    
                Date:   28/06/2000  Author:     Anthony Swindells

  Update Notes: V9 Templates

  (v:010001)    Task:           0   UserRef:    
                Date:   11/05/2001  Author:     Mark Davies (MIP)

  Update Notes: Renamed field object_filename from Object Filename to Object Name

  (v:010002)    Task:           0   UserRef:    
                Date:   12/13/2001  Author:     Mark Davies (MIP)

  Update Notes: Fix for issue #3590 - The Master Object viewer does not reflect the correct product module in the ROM Tool

------------------------------------------------------------------*/
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

&scop object-name       gscobful2o.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataObject yes

{af/sup2/afglobals.i}

&glob DATA-LOGIC-PROCEDURE       af/obj2/gscoblog2p.p

DEFINE TEMP-TABLE ttRycSmartObject RCODE-INFORMATION /* Defined same as RowobjUpd temp table */
    {ry/obj/rycsoful2o.i}
    {src/adm2/rupdflds.i}.

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
&Scoped-define INTERNAL-TABLES gsc_object ryc_smartobject ~
gsc_product_module

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  object_type_obj dProductObj product_module_obj object_description~
 object_filename object_path toolbar_multi_media_obj toolbar_image_filename~
 tooltip_text runnable_from_menu disabled run_persistent run_when~
 security_object_obj container_object physical_object_obj logical_object~
 generic_object required_db_list cCustomSuperProcedure dLayoutObj~
 dSDOSmartObject edShutdownMessageText lStaticObject lSystemOwned~
 lTemplateSmartObject
&Scoped-define ENABLED-FIELDS-IN-gsc_object object_type_obj ~
product_module_obj object_description object_filename object_path ~
toolbar_multi_media_obj toolbar_image_filename tooltip_text ~
runnable_from_menu disabled run_persistent run_when security_object_obj ~
container_object physical_object_obj logical_object generic_object ~
required_db_list 
&Scoped-Define DATA-FIELDS  object_obj object_type_obj product_obj dProductObj product_module_obj~
 object_description object_filename object_path toolbar_multi_media_obj~
 toolbar_image_filename tooltip_text runnable_from_menu disabled~
 run_persistent run_when security_object_obj container_object~
 physical_object_obj logical_object generic_object required_db_list~
 layout_obj custom_super_procedure sdo_smartobject_obj shutdown_message_text~
 static_object system_owned template_smartobject cCustomSuperProcedure~
 smartobject_obj object_extension dLayoutObj product_module_code~
 dSDOSmartObject product_module_description edShutdownMessageText~
 lStaticObject lSystemOwned lTemplateSmartObject
&Scoped-define DATA-FIELDS-IN-gsc_object object_obj object_type_obj ~
product_module_obj object_description object_filename object_path ~
toolbar_multi_media_obj toolbar_image_filename tooltip_text ~
runnable_from_menu disabled run_persistent run_when security_object_obj ~
container_object physical_object_obj logical_object generic_object ~
required_db_list object_extension 
&Scoped-define DATA-FIELDS-IN-ryc_smartobject layout_obj ~
custom_super_procedure sdo_smartobject_obj shutdown_message_text ~
static_object system_owned template_smartobject smartobject_obj 
&Scoped-define DATA-FIELDS-IN-gsc_product_module product_obj ~
product_module_code product_module_description 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "af/obj2/gscobful2o.i"
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH gsc_object NO-LOCK, ~
      FIRST ryc_smartobject WHERE ryc_smartobject.object_obj = gsc_object.object_obj NO-LOCK, ~
      FIRST gsc_product_module WHERE gsc_product_module.product_module_obj = gsc_object.product_module_obj NO-LOCK ~
    BY gsc_object.object_filename INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main gsc_object ryc_smartobject ~
gsc_product_module
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main gsc_object
&Scoped-define SECOND-TABLE-IN-QUERY-Query-Main ryc_smartobject
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
      gsc_object, 
      ryc_smartobject
    FIELDS(ryc_smartobject.layout_obj
      ryc_smartobject.custom_super_procedure
      ryc_smartobject.sdo_smartobject_obj
      ryc_smartobject.shutdown_message_text
      ryc_smartobject.static_object
      ryc_smartobject.system_owned
      ryc_smartobject.template_smartobject
      ryc_smartobject.smartobject_obj), 
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
         WIDTH              = 57.4.
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
     _TblList          = "icfdb.gsc_object,icfdb.ryc_smartobject WHERE icfdb.gsc_object ...,icfdb.gsc_product_module WHERE icfdb.gsc_object ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST USED, FIRST, FIRST"
     _OrdList          = "icfdb.gsc_object.object_filename|yes"
     _JoinCode[2]      = "ryc_smartobject.object_obj = gsc_object.object_obj"
     _JoinCode[3]      = "icfdb.gsc_product_module.product_module_obj = icfdb.gsc_object.product_module_obj"
     _FldNameList[1]   > icfdb.gsc_object.object_obj
"object_obj" "object_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 21 yes
     _FldNameList[2]   > icfdb.gsc_object.object_type_obj
"object_type_obj" "object_type_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21 yes
     _FldNameList[3]   > icfdb.gsc_product_module.product_obj
"product_obj" "product_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 33 yes
     _FldNameList[4]   > "_<CALC>"
"RowObject.product_obj" "dProductObj" "Product Obj" ">>>>>>>>>>>>>>>>>9.999999999" "Decimal" ? ? ? ? ? ? yes ? no 24 no
     _FldNameList[5]   > icfdb.gsc_object.product_module_obj
"product_module_obj" "product_module_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21 yes
     _FldNameList[6]   > icfdb.gsc_object.object_description
"object_description" "object_description" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[7]   > icfdb.gsc_object.object_filename
"object_filename" "object_filename" "Object Name" ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[8]   > icfdb.gsc_object.object_path
"object_path" "object_path" ? ? "character" ? ? ? ? ? ? yes ? no 140 yes
     _FldNameList[9]   > icfdb.gsc_object.toolbar_multi_media_obj
"toolbar_multi_media_obj" "toolbar_multi_media_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21 yes
     _FldNameList[10]   > icfdb.gsc_object.toolbar_image_filename
"toolbar_image_filename" "toolbar_image_filename" ? ? "character" ? ? ? ? ? ? yes ? no 140 yes
     _FldNameList[11]   > icfdb.gsc_object.tooltip_text
"tooltip_text" "tooltip_text" ? ? "character" ? ? ? ? ? ? yes ? no 140 yes
     _FldNameList[12]   > icfdb.gsc_object.runnable_from_menu
"runnable_from_menu" "runnable_from_menu" ? ? "logical" ? ? ? ? ? ? yes ? no 1 yes
     _FldNameList[13]   > icfdb.gsc_object.disabled
"disabled" "disabled" ? ? "logical" ? ? ? ? ? ? yes ? no 1 yes
     _FldNameList[14]   > icfdb.gsc_object.run_persistent
"run_persistent" "run_persistent" ? ? "logical" ? ? ? ? ? ? yes ? no 1 yes
     _FldNameList[15]   > icfdb.gsc_object.run_when
"run_when" "run_when" ? ? "character" ? ? ? ? ? ? yes ? no 6 yes
     _FldNameList[16]   > icfdb.gsc_object.security_object_obj
"security_object_obj" "security_object_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21 yes
     _FldNameList[17]   > icfdb.gsc_object.container_object
"container_object" "container_object" ? ? "logical" ? ? ? ? ? ? yes ? no 1 yes
     _FldNameList[18]   > icfdb.gsc_object.physical_object_obj
"physical_object_obj" "physical_object_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21 yes
     _FldNameList[19]   > icfdb.gsc_object.logical_object
"logical_object" "logical_object" ? ? "logical" ? ? ? ? ? ? yes ? no 1 yes
     _FldNameList[20]   > icfdb.gsc_object.generic_object
"generic_object" "generic_object" ? ? "logical" ? ? ? ? ? ? yes ? no 1 yes
     _FldNameList[21]   > icfdb.gsc_object.required_db_list
"required_db_list" "required_db_list" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[22]   > icfdb.ryc_smartobject.layout_obj
"layout_obj" "layout_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 29.4 yes
     _FldNameList[23]   > icfdb.ryc_smartobject.custom_super_procedure
"custom_super_procedure" "custom_super_procedure" ? ? "character" ? ? ? ? ? ? no ? no 70 yes
     _FldNameList[24]   > icfdb.ryc_smartobject.sdo_smartobject_obj
"sdo_smartobject_obj" "sdo_smartobject_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 29.4 yes
     _FldNameList[25]   > icfdb.ryc_smartobject.shutdown_message_text
"shutdown_message_text" "shutdown_message_text" ? ? "character" ? ? ? ? ? ? no ? no 70 yes
     _FldNameList[26]   > icfdb.ryc_smartobject.static_object
"static_object" "static_object" ? ? "logical" ? ? ? ? ? ? no ? no 12.2 yes
     _FldNameList[27]   > icfdb.ryc_smartobject.system_owned
"system_owned" "system_owned" ? ? "logical" ? ? ? ? ? ? no ? no 14.2 yes
     _FldNameList[28]   > icfdb.ryc_smartobject.template_smartobject
"template_smartobject" "template_smartobject" ? ? "logical" ? ? ? ? ? ? no ? no 21 yes
     _FldNameList[29]   > "_<CALC>"
"RowObject.custom_super_procedure" "cCustomSuperProcedure" "Custom Super Procedure" "x(70)" "character" ? ? ? ? ? ? yes ? no 70 no
     _FldNameList[30]   > icfdb.ryc_smartobject.smartobject_obj
"smartobject_obj" "smartobject_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 29.4 yes
     _FldNameList[31]   > icfdb.gsc_object.object_extension
"object_extension" "object_extension" ? ? "character" ? ? ? ? ? ? no ? no 35 yes
     _FldNameList[32]   > "_<CALC>"
"RowObject.layout_obj" "dLayoutObj" "Layout" ">>>>>>>>>>>>>9.999999999" "Decimal" ? ? ? ? ? ? yes ? no 24.6 no
     _FldNameList[33]   > icfdb.gsc_product_module.product_module_code
"product_module_code" "product_module_code" ? ? "character" ? ? ? ? ? ? no ? no 20.6 yes
     _FldNameList[34]   > "_<CALC>"
"RowObject.sdo_smartobject_obj" "dSDOSmartObject" "SDO Smart Object" ">>>>>>>>>>>>>9.999999999" "Decimal" ? ? ? ? ? ? yes ? no 24.6 no
     _FldNameList[35]   > icfdb.gsc_product_module.product_module_description
"product_module_description" "product_module_description" ? ? "character" ? ? ? ? ? ? no ? no 35 yes
     _FldNameList[36]   > "_<CALC>"
"RowObject.shutdown_message_text" "edShutdownMessageText" "Shutdown Message Text" "x(70)" "character" ? ? ? ? ? ? yes ? no 70 no
     _FldNameList[37]   > "_<CALC>"
"RowObject.static_object" "lStaticObject" "Static Object" "Yes/No" "Logical" ? ? ? ? ? ? yes ? no 12.2 no
     _FldNameList[38]   > "_<CALC>"
"RowObject.system_owned" "lSystemOwned" "System Owned" "Yes/No" "Logical" ? ? ? ? ? ? yes ? no 14.2 no
     _FldNameList[39]   > "_<CALC>"
"RowObject.template_smartobject" "lTemplateSmartObject" "Template Smart Object" "Yes/No" "Logical" ? ? ? ? ? ? yes ? no 21.6 no
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
         rowObject.cCustomSuperProcedure = (RowObject.custom_super_procedure)
         rowObject.dLayoutObj = (RowObject.layout_obj)
         rowObject.dProductObj = (RowObject.product_obj)
         rowObject.dSDOSmartObject = (RowObject.sdo_smartobject_obj)
         rowObject.edShutdownMessageText = (RowObject.shutdown_message_text)
         rowObject.lStaticObject = (RowObject.static_object)
         rowObject.lSystemOwned = (RowObject.system_owned)
         rowObject.lTemplateSmartObject = (RowObject.template_smartobject)
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

