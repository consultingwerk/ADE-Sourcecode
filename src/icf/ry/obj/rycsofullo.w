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

DEFINE VARIABLE ghDataSource AS HANDLE       NO-UNDO.
DEFINE VARIABLE gcTable AS CHARACTER    NO-UNDO.

DEFINE VARIABLE cRunWhenTla         AS CHARACTER INITIAL "ANY,NOR,ONE,":U.
DEFINE VARIABLE cRunWhenDesc        AS CHARACTER INITIAL "Anytime,When no other running,With only one instance,":U.

DEFINE VARIABLE gcEntityMnemonic    AS CHARACTER    NO-UNDO.

{af/sup2/afrun2.i &Define-only = YES}

{af/sup2/afglobals.i}

&SCOPED-DEFINE ttName ttGscObject
{ry/inc/gscobttdef.i}
&UNDEFINE ttName
&SCOPED-DEFINE ttName ttRycAttributeValue
{ry/inc/rycavttdef.i}
&UNDEFINE ttName
&SCOPED-DEFINE ttName ttRycObjectInstance
{ry/inc/rycoittdef.i}
&UNDEFINE ttName
&SCOPED-DEFINE ttName ttRycPage
{ry/inc/rycpattdef.i}
&UNDEFINE ttName
&SCOPED-DEFINE ttName ttRycSmartlink
{ry/inc/rycsmttdef.i}
&UNDEFINE ttName

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
gsc_product_module gsc_object ryc_layout gsm_multi_media gsc_product

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  object_filename static_object template_smartobject system_owned~
 custom_super_procedure shutdown_message_text layout_obj object_obj~
 object_type_obj product_module_obj sdo_smartobject_obj securityObject~
 toolbarMultiMedia physicalObject dObjectInstance
&Scoped-define ENABLED-FIELDS-IN-ryc_smartobject object_filename ~
static_object template_smartobject system_owned custom_super_procedure ~
shutdown_message_text layout_obj object_obj object_type_obj ~
product_module_obj sdo_smartobject_obj 
&Scoped-Define DATA-FIELDS  object_filename product_module_code object_type_code layout_name~
 layout_code object_description static_object template_smartobject~
 system_owned custom_super_procedure shutdown_message_text container_object~
 layout_obj object_obj object_type_obj product_module_obj~
 sdo_smartobject_obj smartobject_obj disabled layout_supported~
 object_type_description object_type_obj-2 db_connection_pf_file~
 number_of_users product_module_description product_module_installed~
 product_module_obj-2 product_obj disabled-2 generic_object logical_object~
 object_filename-2 object_obj-2 object_path object_type_obj-3~
 physical_object_obj product_module_obj-3 required_db_list~
 runnable_from_menu run_persistent run_when security_object_obj~
 toolbar_image_filename toolbar_multi_media_obj tooltip_text layout_filename~
 layout_narrative layout_obj-2 layout_type sample_image_filename~
 system_owned-2 multi_media_description product_code db_connection_pf_file-2~
 securityObject number_of_users-2 toolbarMultiMedia product_description~
 physicalObject product_installed dObjectInstance product_obj-2 runWhen~
 supplier_organisation_obj physical_file_name owning_obj~
 multi_media_type_obj multi_media_obj creation_date category_obj~
 object_extension
&Scoped-define DATA-FIELDS-IN-ryc_smartobject object_filename static_object ~
template_smartobject system_owned custom_super_procedure ~
shutdown_message_text layout_obj object_obj object_type_obj ~
product_module_obj sdo_smartobject_obj smartobject_obj 
&Scoped-define DATA-FIELDS-IN-gsc_object_type object_type_code disabled ~
layout_supported object_type_description object_type_obj-2 
&Scoped-define DATA-FIELDS-IN-gsc_product_module product_module_code ~
db_connection_pf_file number_of_users product_module_description ~
product_module_installed product_module_obj-2 product_obj 
&Scoped-define DATA-FIELDS-IN-gsc_object object_description ~
container_object disabled-2 generic_object logical_object object_filename-2 ~
object_obj-2 object_path object_type_obj-3 physical_object_obj ~
product_module_obj-3 required_db_list runnable_from_menu run_persistent ~
run_when security_object_obj toolbar_image_filename toolbar_multi_media_obj ~
tooltip_text object_extension 
&Scoped-define DATA-FIELDS-IN-ryc_layout layout_name layout_code ~
layout_filename layout_narrative layout_obj-2 layout_type ~
sample_image_filename system_owned-2 
&Scoped-define DATA-FIELDS-IN-gsm_multi_media multi_media_description ~
physical_file_name owning_obj multi_media_type_obj multi_media_obj ~
creation_date category_obj 
&Scoped-define DATA-FIELDS-IN-gsc_product product_code ~
db_connection_pf_file-2 number_of_users-2 product_description ~
product_installed product_obj-2 supplier_organisation_obj 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE Astra
&Scoped-Define ASSIGN-LIST   rowObject.object_type_obj-2 = gsc_object_type.object_type_obj~
  rowObject.product_module_obj-2 = gsc_product_module.product_module_obj~
  rowObject.disabled-2 = gsc_object.disabled~
  rowObject.object_filename-2 = gsc_object.object_filename~
  rowObject.object_obj-2 = gsc_object.object_obj~
  rowObject.object_type_obj-3 = gsc_object.object_type_obj~
  rowObject.product_module_obj-3 = gsc_object.product_module_obj~
  rowObject.layout_obj-2 = ryc_layout.layout_obj~
  rowObject.system_owned-2 = ryc_layout.system_owned~
  rowObject.db_connection_pf_file-2 = gsc_product.db_connection_pf_file~
  rowObject.number_of_users-2 = gsc_product.number_of_users~
  rowObject.product_obj-2 = gsc_product.product_obj
&Scoped-Define DATA-FIELD-DEFS "ry/obj/rycsofullo.i"
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH ryc_smartobject NO-LOCK, ~
      FIRST gsc_object_type WHERE gsc_object_type.object_type_obj = ryc_smartobject.object_type_obj NO-LOCK, ~
      FIRST gsc_product_module WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj NO-LOCK, ~
      FIRST gsc_object WHERE gsc_object.object_obj = ryc_smartobject.object_obj NO-LOCK, ~
      FIRST ryc_layout WHERE ryc_layout.layout_obj = ryc_smartobject.layout_obj OUTER-JOIN NO-LOCK, ~
      FIRST gsm_multi_media WHERE gsm_multi_media.multi_media_obj = gsc_object.toolbar_multi_media_obj OUTER-JOIN NO-LOCK, ~
      FIRST gsc_product WHERE gsc_product.product_obj = gsc_product_module.product_obj NO-LOCK ~
    BY ryc_smartobject.object_filename INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main ryc_smartobject gsc_object_type ~
gsc_product_module gsc_object ryc_layout gsm_multi_media gsc_product
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main ryc_smartobject
&Scoped-define SECOND-TABLE-IN-QUERY-Query-Main gsc_object_type
&Scoped-define THIRD-TABLE-IN-QUERY-Query-Main gsc_product_module
&Scoped-define FOURTH-TABLE-IN-QUERY-Query-Main gsc_object
&Scoped-define FIFTH-TABLE-IN-QUERY-Query-Main ryc_layout
&Scoped-define SIXTH-TABLE-IN-QUERY-Query-Main gsm_multi_media
&Scoped-define SEVENTH-TABLE-IN-QUERY-Query-Main gsc_product


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD objectType dTables 
FUNCTION objectType RETURNS CHARACTER
  ( pdObjectTypeObj AS DECIMAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD runWhen dTables  _DB-REQUIRED
FUNCTION runWhen RETURNS CHARACTER
  ( pcRunWhen AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD securityObjectName dTables 
FUNCTION securityObjectName RETURNS CHARACTER
  ( pdSecurityObjectObj AS DECIMAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      ryc_smartobject, 
      gsc_object_type, 
      gsc_product_module, 
      gsc_object, 
      ryc_layout, 
      gsm_multi_media, 
      gsc_product SCROLLING.
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
   Partition: Astra
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
         WIDTH              = 60.8.
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
     _TblList          = "ICFDB.ryc_smartobject,ICFDB.gsc_object_type WHERE ICFDB.ryc_smartobject ...,ICFDB.gsc_product_module WHERE ICFDB.ryc_smartobject ...,ICFDB.gsc_object WHERE ICFDB.ryc_smartobject ...,ICFDB.ryc_layout WHERE ICFDB.ryc_smartobject ...,ICFDB.gsm_multi_media WHERE ICFDB.gsc_object ...,ICFDB.gsc_product WHERE ICFDB.gsc_product_module ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST, FIRST, FIRST, FIRST OUTER, FIRST OUTER, FIRST"
     _OrdList          = "ICFDB.ryc_smartobject.object_filename|yes"
     _JoinCode[2]      = "ICFDB.gsc_object_type.object_type_obj = ICFDB.ryc_smartobject.object_type_obj"
     _JoinCode[3]      = "ICFDB.gsc_product_module.product_module_obj = ICFDB.ryc_smartobject.product_module_obj"
     _JoinCode[4]      = "ICFDB.gsc_object.object_obj = ICFDB.ryc_smartobject.object_obj"
     _JoinCode[5]      = "ICFDB.ryc_layout.layout_obj = ICFDB.ryc_smartobject.layout_obj"
     _JoinCode[6]      = "ICFDB.gsm_multi_media.multi_media_obj = ICFDB.gsc_object.toolbar_multi_media_obj"
     _JoinCode[7]      = "ICFDB.gsc_product.product_obj = ICFDB.gsc_product_module.product_obj"
     _FldNameList[1]   > ICFDB.ryc_smartobject.object_filename
"object_filename" "object_filename" ? "X(35)" "character" ? ? ? ? ? ? yes ? no 35 yes
     _FldNameList[2]   > ICFDB.gsc_product_module.product_module_code
"product_module_code" "product_module_code" "Product Module" ? "character" ? ? ? ? ? ? no ? no 20.6 yes
     _FldNameList[3]   > ICFDB.gsc_object_type.object_type_code
"object_type_code" "object_type_code" "Object Type" ? "character" ? ? ? ? ? ? no ? no 17.2 yes
     _FldNameList[4]   > ICFDB.ryc_layout.layout_name
"layout_name" "layout_name" ? ? "character" ? ? ? ? ? ? no ? no 28 yes
     _FldNameList[5]   > ICFDB.ryc_layout.layout_code
"layout_code" "layout_code" ? ? "character" ? ? ? ? ? ? no ? no 12 yes
     _FldNameList[6]   > ICFDB.gsc_object.object_description
"object_description" "object_description" ? ? "character" ? ? ? ? ? ? no ? no 35 yes
     _FldNameList[7]   > ICFDB.ryc_smartobject.static_object
"static_object" "static_object" "Static" ? "logical" ? ? ? ? ? ? yes ? no 12.2 yes
     _FldNameList[8]   > ICFDB.ryc_smartobject.template_smartobject
"template_smartobject" "template_smartobject" "Template" ? "logical" ? ? ? ? ? ? yes ? no 21 yes
     _FldNameList[9]   > ICFDB.ryc_smartobject.system_owned
"system_owned" "system_owned" ? ? "logical" ? ? ? ? ? ? yes ? no 14.2 yes
     _FldNameList[10]   > ICFDB.ryc_smartobject.custom_super_procedure
"custom_super_procedure" "custom_super_procedure" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[11]   > ICFDB.ryc_smartobject.shutdown_message_text
"shutdown_message_text" "shutdown_message_text" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[12]   > ICFDB.gsc_object.container_object
"container_object" "container_object" ? ? "logical" ? ? ? ? ? ? no ? no 15.8 yes
     _FldNameList[13]   > ICFDB.ryc_smartobject.layout_obj
"layout_obj" "layout_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21.6 yes
     _FldNameList[14]   > ICFDB.ryc_smartobject.object_obj
"object_obj" "object_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21.6 yes
     _FldNameList[15]   > ICFDB.ryc_smartobject.object_type_obj
"object_type_obj" "object_type_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21.6 yes
     _FldNameList[16]   > ICFDB.ryc_smartobject.product_module_obj
"product_module_obj" "product_module_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21.6 yes
     _FldNameList[17]   > ICFDB.ryc_smartobject.sdo_smartobject_obj
"sdo_smartobject_obj" "sdo_smartobject_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21.6 yes
     _FldNameList[18]   > ICFDB.ryc_smartobject.smartobject_obj
"smartobject_obj" "smartobject_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 21.6 yes
     _FldNameList[19]   > ICFDB.gsc_object_type.disabled
"disabled" "disabled" ? ? "logical" ? ? ? ? ? ? no ? no 8.2 yes
     _FldNameList[20]   > ICFDB.gsc_object_type.layout_supported
"layout_supported" "layout_supported" ? ? "logical" ? ? ? ? ? ? no ? no 16.8 yes
     _FldNameList[21]   > ICFDB.gsc_object_type.object_type_description
"object_type_description" "object_type_description" ? ? "character" ? ? ? ? ? ? no ? no 35 yes
     _FldNameList[22]   > ICFDB.gsc_object_type.object_type_obj
"object_type_obj" "object_type_obj-2" ? ? "decimal" ? ? ? ? ? ? no ? no 21.6 yes
     _FldNameList[23]   > ICFDB.gsc_product_module.db_connection_pf_file
"db_connection_pf_file" "db_connection_pf_file" ? ? "character" ? ? ? ? ? ? no ? no 70 yes
     _FldNameList[24]   > ICFDB.gsc_product_module.number_of_users
"number_of_users" "number_of_users" ? ? "integer" ? ? ? ? ? ? no ? no 15.8 yes
     _FldNameList[25]   > ICFDB.gsc_product_module.product_module_description
"product_module_description" "product_module_description" ? ? "character" ? ? ? ? ? ? no ? no 35 yes
     _FldNameList[26]   > ICFDB.gsc_product_module.product_module_installed
"product_module_installed" "product_module_installed" ? ? "logical" ? ? ? ? ? ? no ? no 23.4 yes
     _FldNameList[27]   > ICFDB.gsc_product_module.product_module_obj
"product_module_obj" "product_module_obj-2" ? ? "decimal" ? ? ? ? ? ? no ? no 21.6 yes
     _FldNameList[28]   > ICFDB.gsc_product_module.product_obj
"product_obj" "product_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 21.6 yes
     _FldNameList[29]   > ICFDB.gsc_object.disabled
"disabled" "disabled-2" ? ? "logical" ? ? ? ? ? ? no ? no 8.2 yes
     _FldNameList[30]   > ICFDB.gsc_object.generic_object
"generic_object" "generic_object" ? ? "logical" ? ? ? ? ? ? no ? no 14.2 yes
     _FldNameList[31]   > ICFDB.gsc_object.logical_object
"logical_object" "logical_object" ? ? "logical" ? ? ? ? ? ? no ? no 13.6 yes
     _FldNameList[32]   > ICFDB.gsc_object.object_filename
"object_filename" "object_filename-2" ? ? "character" ? ? ? ? ? ? no ? no 35 yes
     _FldNameList[33]   > ICFDB.gsc_object.object_obj
"object_obj" "object_obj-2" ? ? "decimal" ? ? ? ? ? ? no ? no 21.6 yes
     _FldNameList[34]   > ICFDB.gsc_object.object_path
"object_path" "object_path" ? ? "character" ? ? ? ? ? ? no ? no 70 yes
     _FldNameList[35]   > ICFDB.gsc_object.object_type_obj
"object_type_obj" "object_type_obj-3" ? ? "decimal" ? ? ? ? ? ? no ? no 21.6 yes
     _FldNameList[36]   > ICFDB.gsc_object.physical_object_obj
"physical_object_obj" "physical_object_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 21.6 yes
     _FldNameList[37]   > ICFDB.gsc_object.product_module_obj
"product_module_obj" "product_module_obj-3" ? ? "decimal" ? ? ? ? ? ? no ? no 21.6 yes
     _FldNameList[38]   > ICFDB.gsc_object.required_db_list
"required_db_list" "required_db_list" ? ? "character" ? ? ? ? ? ? no ? no 35 yes
     _FldNameList[39]   > ICFDB.gsc_object.runnable_from_menu
"runnable_from_menu" "runnable_from_menu" ? ? "logical" ? ? ? ? ? ? no ? no 20.4 yes
     _FldNameList[40]   > ICFDB.gsc_object.run_persistent
"run_persistent" "run_persistent" ? ? "logical" ? ? ? ? ? ? no ? no 13.8 yes
     _FldNameList[41]   > ICFDB.gsc_object.run_when
"run_when" "run_when" ? ? "character" ? ? ? ? ? ? no ? no 10.4 yes
     _FldNameList[42]   > ICFDB.gsc_object.security_object_obj
"security_object_obj" "security_object_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 21.6 yes
     _FldNameList[43]   > ICFDB.gsc_object.toolbar_image_filename
"toolbar_image_filename" "toolbar_image_filename" ? ? "character" ? ? ? ? ? ? no ? no 70 yes
     _FldNameList[44]   > ICFDB.gsc_object.toolbar_multi_media_obj
"toolbar_multi_media_obj" "toolbar_multi_media_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 22.4 yes
     _FldNameList[45]   > ICFDB.gsc_object.tooltip_text
"tooltip_text" "tooltip_text" ? ? "character" ? ? ? ? ? ? no ? no 70 yes
     _FldNameList[46]   > ICFDB.ryc_layout.layout_filename
"layout_filename" "layout_filename" ? ? "character" ? ? ? ? ? ? no ? no 70 yes
     _FldNameList[47]   > ICFDB.ryc_layout.layout_narrative
"layout_narrative" "layout_narrative" ? ? "character" ? ? ? ? ? ? no ? no 500 yes
     _FldNameList[48]   > ICFDB.ryc_layout.layout_obj
"layout_obj" "layout_obj-2" ? ? "decimal" ? ? ? ? ? ? no ? no 21.6 yes
     _FldNameList[49]   > ICFDB.ryc_layout.layout_type
"layout_type" "layout_type" ? ? "character" ? ? ? ? ? ? no ? no 11.8 yes
     _FldNameList[50]   > ICFDB.ryc_layout.sample_image_filename
"sample_image_filename" "sample_image_filename" ? ? "character" ? ? ? ? ? ? no ? no 70 yes
     _FldNameList[51]   > ICFDB.ryc_layout.system_owned
"system_owned" "system_owned-2" ? ? "logical" ? ? ? ? ? ? no ? no 14.2 yes
     _FldNameList[52]   > ICFDB.gsm_multi_media.multi_media_description
"multi_media_description" "multi_media_description" ? ? "character" ? ? ? ? ? ? no ? no 35 yes
     _FldNameList[53]   > ICFDB.gsc_product.product_code
"product_code" "product_code" ? ? "character" ? ? ? ? ? ? no ? no 13 yes
     _FldNameList[54]   > ICFDB.gsc_product.db_connection_pf_file
"db_connection_pf_file" "db_connection_pf_file-2" ? ? "character" ? ? ? ? ? ? no ? no 70 yes
     _FldNameList[55]   > "_<CALC>"
"security_object_obj" "securityObject" "Security Object" "999999999999999999.999999999" "Decimal" ? ? ? ? ? ? yes ? no 29.4 no
     _FldNameList[56]   > ICFDB.gsc_product.number_of_users
"number_of_users" "number_of_users-2" ? ? "integer" ? ? ? ? ? ? no ? no 15.8 yes
     _FldNameList[57]   > "_<CALC>"
"toolbar_multi_media_obj" "toolbarMultiMedia" "Multi Media" "999999999999999999.999999999" "Decimal" ? ? ? ? ? ? yes ? no 29.4 no
     _FldNameList[58]   > ICFDB.gsc_product.product_description
"product_description" "product_description" ? ? "character" ? ? ? ? ? ? no ? no 35 yes
     _FldNameList[59]   > "_<CALC>"
"physical_object_obj" "physicalObject" "Physical Object" "999999999999999999.999999999" "Decimal" ? ? ? ? ? ? yes ? no 29.4 no
     _FldNameList[60]   > ICFDB.gsc_product.product_installed
"product_installed" "product_installed" ? ? "logical" ? ? ? ? ? ? no ? no 15.8 yes
     _FldNameList[61]   > "_<CALC>"
"decimal(smartobject_obj)" "dObjectInstance" "Object Instance" "999999999999999999.999999999" "Decimal" ? ? ? ? ? ? yes ? no 25 no
     _FldNameList[62]   > ICFDB.gsc_product.product_obj
"product_obj" "product_obj-2" ? ? "decimal" ? ? ? ? ? ? no ? no 29.4 yes
     _FldNameList[63]   > "_<CALC>"
"runWhen(RowObject.run_when)" "runWhen" "Run When" "x(8)" "character" ? ? ? ? ? ? no ? no 8 no
     _FldNameList[64]   > ICFDB.gsc_product.supplier_organisation_obj
"supplier_organisation_obj" "supplier_organisation_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 29.4 yes
     _FldNameList[65]   > ICFDB.gsm_multi_media.physical_file_name
"physical_file_name" "physical_file_name" ? ? "character" ? ? ? ? ? ? no ? no 70 yes
     _FldNameList[66]   > ICFDB.gsm_multi_media.owning_obj
"owning_obj" "owning_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 29.4 yes
     _FldNameList[67]   > ICFDB.gsm_multi_media.multi_media_type_obj
"multi_media_type_obj" "multi_media_type_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 29.4 yes
     _FldNameList[68]   > ICFDB.gsm_multi_media.multi_media_obj
"multi_media_obj" "multi_media_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 29.4 yes
     _FldNameList[69]   > ICFDB.gsm_multi_media.creation_date
"creation_date" "creation_date" ? ? "date" ? ? ? ? ? ? no ? no 13 yes
     _FldNameList[70]   > ICFDB.gsm_multi_media.category_obj
"category_obj" "category_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 29.4 yes
     _FldNameList[71]   > ICFDB.gsc_object.object_extension
"object_extension" "object_extension" ? ? "character" ? ? ? ? ? ? no ? no 35 yes
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beginTransactionValidate dTables  _DB-REQUIRED
PROCEDURE beginTransactionValidate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE cMessageList    AS CHARACTER    NO-UNDO.   
    DEFINE VARIABLE cObjectExt      AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cObjectFilename AS CHARACTER NO-UNDO.

    FOR EACH RowObjUpd WHERE RowObjUpd.rowMod = "D":U:
        FIND FIRST gsc_object EXCLUSIVE-LOCK
             WHERE gsc_object.OBJECT_filename = rowObjUpd.OBJECT_filename
            NO-ERROR.
        IF NOT AVAILABLE gsc_object THEN /* Find gsc_object where filename excludes file extension*/
          IF R-INDEX(rowObjUpd.Object_filename,".") > 0 THEN DO:
             cObjectExt = ENTRY(NUM-ENTRIES(rowObjUpd.Object_filename,"."),rowObjUpd.Object_filename,".").
             cObjectFileName = REPLACE(rowObjUpd.Object_filename,("." + cObjectExt),"").
             FIND FIRST gsc_object NO-LOCK
                   WHERE gsc_object.Object_filename = cObjectFileName AND
                         gsc_object.Object_Extension = cObjectExt NO-ERROR.
          END.
        IF AVAILABLE gsc_object THEN
            DELETE gsc_object NO-ERROR.
        FOR EACH ttGscObject 
            WHERE (IF ttGscObject.object_Extension <> "":U THEN
                        ttGscObject.object_filename + "." + ttGscObject.object_Extension
                   ELSE 
                      ttGscObject.object_filename)
                   = RowObjUpd.object_filename:
            DELETE ttGscObject NO-ERROR.
        END.
    END.

    {set CheckCurrentChanged FALSE}.

    FIND FIRST ttGscObject NO-ERROR.
    IF AVAILABLE ttGscObject THEN
    DO:
        {af/sup2/afrun2.i &PLIP  = 'ry/app/gscobplipp.p'
                          &IProc = 'updateGscObject'
                          &OnApp = 'yes'
                          &PList = "(INPUT-OUTPUT TABLE ttGscObject)"
                          &Auto-kill = YES}
    END.

    FOR EACH RowObjUpd WHERE LOOKUP(RowObjUpd.RowMod,"A,C":U) <> 0:
        FIND ttGscObject 
            WHERE ttGscObject.object_filename = RowObjUpd.object_filename NO-ERROR.
        IF NOT AVAILABLE ttGscObject THEN /* Search with separate file extension */ 
            IF R-INDEX(rowObjUpd.Object_filename,".") > 0 THEN DO:
               cObjectExt = ENTRY(NUM-ENTRIES(rowObjUpd.Object_filename,"."),rowObjUpd.Object_filename,".").
               cObjectFileName = REPLACE(rowObjUpd.Object_filename,("." + cObjectExt),"").
               FIND ttGscObject 
                   WHERE ttGscObject.object_filename = cObjectFileName AND
                         ttGscObject.object_Extension = cObjectExt NO-ERROR.
            END.
        ASSIGN
            rowObjUpd.object_obj = IF AVAILABLE ttGscObject THEN ttGscObject.object_obj ELSE rowObjUpd.object_obj.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DATA.CALCULATE dTables  DATA.CALCULATE _DB-REQUIRED
PROCEDURE DATA.CALCULATE :
/*------------------------------------------------------------------------------
  Purpose:     Calculate all the Calculated Expressions found in the
               SmartDataObject.
  Parameters:  <none>
------------------------------------------------------------------------------*/
      ASSIGN 
         rowObject.dObjectInstance = (decimal(smartobject_obj))
         rowObject.physicalObject = (physical_object_obj)
         rowObject.runWhen = (runWhen(RowObject.run_when))
         rowObject.securityObject = (security_object_obj)
         rowObject.toolbarMultiMedia = (toolbar_multi_media_obj)
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE endTransactionValidate dTables  _DB-REQUIRED
PROCEDURE endTransactionValidate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE cMessageList       AS CHARACTER     NO-UNDO.

/*
FOR EACH RowObjUpd WHERE LOOKUP(RowObjUpd.RowMod,"A,C,U":U) <> 0:
    FOR EACH ttRycAttributeValue WHERE LOOKUP(ttRycAttributeValue.RowMod,"A,C":U) <> 0:
        ASSIGN
            ttRycAttributeValue.smartobject_obj = RowObjUpd.smartobject_obj
            ttRycAttributeValue.primary_smartobject_obj = RowObjUpd.smartobject_obj.
    END.
    FOR EACH ttRycPage WHERE LOOKUP(ttRycPage.RowMod,"A,C":U) <> 0:
        ASSIGN
            ttRycPage.container_smartobject_obj = RowObjUpd.smartobject_obj.
    END.
    FOR EACH ttRycObjectInstance WHERE LOOKUP(ttRycObjectInstance.RowMod,"A,C":U) <> 0:
        ASSIGN
            ttRycObjectInstance.container_smartobject_obj = RowObjUpd.smartobject_obj.
    END.
END.
*/

/*
FIND FIRST ttRycAttributeValue NO-ERROR.
IF AVAILABLE ttRycAttributeValue THEN
DO:
    {af/sup2/afrun2.i &PLIP  = 'ry/app/rycavplipp.p'
                      &IProc = 'updateRycAttributeValue'
                      &OnApp = 'yes'
                      &PList = "(INPUT-OUTPUT TABLE ttRycAttributeValue)"
                      &Auto-kill = YES}
    IF anyMessage() THEN RETURN. 
END.


FIND FIRST ttRycObjectInstance NO-ERROR.
IF AVAILABLE ttRycObjectInstance THEN
DO:
    {af/sup2/afrun2.i &PLIP  = 'ry/app/rycoiplipp.p'
                      &IProc = 'updateRycObjectInstance'
                      &OnApp = 'yes'
                      &PList = "(INPUT-OUTPUT TABLE ttRycObjectInstance)"
                      &Auto-kill = YES}
    IF anyMessage() THEN RETURN.
END.


FIND FIRST ttRycPage NO-ERROR.
IF AVAILABLE ttRycPage THEN
DO:
    {af/sup2/afrun2.i &PLIP  = 'ry/app/rycpaplipp.p'
                      &IProc = 'updateRycPage'
                      &OnApp = 'yes'
                      &PList = "(INPUT-OUTPUT TABLE ttRycPage)"
                      &Auto-kill = YES}
    IF anyMessage() THEN RETURN.
END.


FIND FIRST ttRycSmartLink NO-ERROR.
IF AVAILABLE ttRycSmartLink THEN
DO:
    {af/sup2/afrun2.i &PLIP  = 'ry/app/rycsmplipp.p'
                      &IProc = 'updateRycSmartLink'
                      &OnApp = 'yes'
                      &PList = "(INPUT-OUTPUT TABLE ttRycSmartLink)"
                      &Auto-kill = YES}
    IF anyMessage() THEN RETURN.
END.
*/

/* pass back errors in return value and ensure error status not left raised */
ERROR-STATUS:ERROR = NO.
RETURN cMessageList.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject dTables 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hDataSource     AS HANDLE       NO-UNDO.
    DEFINE VARIABLE cFields         AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE hUpdateSource   AS HANDLE       NO-UNDO.

  /* Code placed here will execute PRIOR to standard behavior. */
    IF NOT(SESSION:REMOTE OR SESSION:PARAMETER = "REMOTE":U) THEN DO:
        {get DataSource hDataSource}.

        IF VALID-HANDLE(hDataSource) THEN
            gcEntityMnemonic = DYNAMIC-FUNCTION("getUserProperty":U IN hDataSource, INPUT "owningEntityMnemonic").

    END.

    CASE gcEntityMnemonic:
        WHEN "GSCOT":U THEN
            ASSIGN 
                cFields = "ryc_smartobject.object_type_obj,object_type_obj".
    END CASE.

    IF  cFields <> "" THEN
        {set ForeignFields cFields}.

    RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

    DYNAMIC-FUNCTION("setUserProperty":U, INPUT "owningEntityMnemonic", INPUT "RYCSO":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE preTransactionValidate dTables  _DB-REQUIRED
PROCEDURE preTransactionValidate :
/*------------------------------------------------------------------------------
  Purpose     To perform validation that requires access to the database but
               that can occur before the transaction has started.
  Parameters:  <none>
  Notes:       Batch up errors using a chr(3) delimiter and be sure not to leave
               the error status raised.
------------------------------------------------------------------------------*/

DEFINE VARIABLE cMessageList                  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cText                         AS CHARACTER  NO-UNDO.

FOR EACH RowObjUpd WHERE LOOKUP(RowObjUpd.RowMod,"A,C,U":U) <> 0:
     IF  RowObjUpd.RowMod = "A":U
     OR  RowObjUpd.RowMod = "C":U THEN
         ASSIGN
            rowObjUpd.object_obj = -1.

    /* ensure object file name specified is unique */

    IF (RowObjUpd.RowMod = "U":U
    AND CAN-FIND(FIRST ryc_smartobject
        WHERE ryc_smartobject.object_filename = RowObjUpd.object_filename
        AND   ROWID(ryc_smartobject) <> TO-ROWID(ENTRY(1, RowObjUpd.ROWIDent))))
    OR    (RowObjUpd.RowMod <> "U":U
    AND CAN-FIND(FIRST ryc_smartobject
        WHERE ryc_smartobject.object_filename = RowObjUpd.object_filename)) THEN
        ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE "":U) +
               {af/sup2/aferrortxt.i 'AF' '8' 'ryc_smartobject' 'object_filename' "'object file name'" RowObjUpd.object_filename "'. Please use a different object name'"}
               .
    /* ensure layout is valid */
    IF  RowObjUpd.layout_obj <> 0
    AND NOT CAN-FIND(FIRST ryc_layout
        WHERE ryc_layout.layout_obj = RowObjUpd.layout_obj) THEN DO:
        ASSIGN
            cText = ". The layout object: " + STRING(rowObjUpd.layout_obj) + " does not exist.".  
        ASSIGN
            cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE "":U) + 
            {af/sup2/aferrortxt.i 'AF' '5' 'ryc_smartobject' 'layout_obj' "'layout obj'" cText}
            .
    END.
    /* ensure object type is valid */
    IF NOT CAN-FIND(FIRST gsc_object_type
        WHERE gsc_object_type.object_type_obj = RowObjUpd.object_type_obj) THEN DO:
            ASSIGN
                cText = ". The product module object: " + STRING(rowObjUpd.product_module_obj) + " does not exist.".  
            ASSIGN
                cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE "":U) +
                {af/sup2/aferrortxt.i 'AF' '5' 'ryc_smartobject' 'product_module_obj' "'product module obj'" cText}
                .
    END.
    /* ensure product module is valid */
    IF NOT CAN-FIND(FIRST gsc_product_module
        WHERE gsc_product_module.product_module_obj = RowObjUpd.product_module_obj) THEN DO:
        ASSIGN
            cText = ". The product module object: " + STRING(rowObjUpd.product_module_obj) + " does not exist.".  
        ASSIGN
            cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE "":U) +
            {af/sup2/aferrortxt.i 'AF' '5' 'ryc_smartobject' 'product_module_obj' "'product module obj'" cText}
            .
    END.
END.

/* pass back errors in return value and ensure error status not left raised */
ERROR-STATUS:ERROR = NO.
RETURN cMessageList.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

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
DEFINE VARIABLE cMessageList            AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cDataTarget             AS CHARACTER    NO-UNDO.
DEFINE VARIABLE hDataTarget             AS HANDLE       NO-UNDO.
DEFINE VARIABLE iLoop                   AS INTEGER      NO-UNDO.
DEFINE VARIABLE hAsHandle               AS HANDLE       NO-UNDO.

IF  RowObject.product_module_obj = 0 THEN
    ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE "":U) +
                        {af/sup2/aferrortxt.i 'AF' '1' 'ryc_smartobject' 'product_module_obj' "'product module code'"}
                        .
IF  RowObject.object_type_obj = 0 THEN
    ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE "":U) +
                        {af/sup2/aferrortxt.i 'AF' '1' 'ryc_smartobject' 'object_type_obj' "'object type code'"}
                        .
IF LENGTH(RowObject.object_filename) = 0 THEN
   ASSIGN cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE "":U) +
                        {af/sup2/aferrortxt.i 'AF' '1' 'ryc_smartobject' 'object_filename' "'object file name'"}
                        .

{get DataTarget cDataTarget}.

DataTargetLoop:
DO iLoop = 1 TO NUM-ENTRIES(cDataTarget):
    hDataTarget = WIDGET-HANDLE(ENTRY(iLoop, cDataTarget)). /* in this case, I have only one data target with fetchRycsoRecords in it */
    IF  VALID-HANDLE(hDataTarget) AND LOOKUP("fetchRycsoRecords", hDataTarget:INTERNAL-ENTRIES) > 0 THEN DO:
        RUN fetchRycsoRecords IN hDataTarget(OUTPUT TABLE ttGscObject
                                             /*, 
                                             OUTPUT TABLE ttRycAttributeValue,                                             
                                             OUTPUT TABLE ttRycObjectInstance,
                                             OUTPUT TABLE ttRycPage,
                                             OUTPUT TABLE ttRycSmartLink */ ).
        LEAVE DataTargetLoop.
    END.
END.

IF NOT CAN-FIND(FIRST ttGscObject) THEN
    cMessageList = cMessageList + "No gsc_object record available for ryc_smartobject update".
ELSE 
DO:
    IF  NOT (SESSION:REMOTE OR SESSION:PARAMETER = "remote":u) THEN
        {get asHandle hAsHandle}.

    IF  VALID-HANDLE(hAsHandle) THEN
        RUN sendTempTable IN hAsHandle (INPUT TABLE ttGscObject
                                        /* ,
                                        INPUT TABLE ttRycAttributeValue,
                                        INPUT TABLE ttRycObjectInstance,
                                        INPUT TABLE ttRycPage,
                                        INPUT TABLE ttRycSmartLink */ ).
END.

RETURN cMessageList.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sendTempTable dTables  _DB-REQUIRED
PROCEDURE sendTempTable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER TABLE FOR ttGscObject.
/*
DEFINE INPUT PARAMETER TABLE FOR ttRycAttributeValue.
DEFINE INPUT PARAMETER TABLE FOR ttRycObjectInstance.
DEFINE INPUT PARAMETER TABLE FOR ttRycPage.
DEFINE INPUT PARAMETER TABLE FOR ttRycSmartLink.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION objectType dTables 
FUNCTION objectType RETURNS CHARACTER
  ( pdObjectTypeObj AS DECIMAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION runWhen dTables  _DB-REQUIRED
FUNCTION runWhen RETURNS CHARACTER
  ( pcRunWhen AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

    RETURN ENTRY(LOOKUP(pcRunWhen, cRunWhenTla), cRunWhenDesc).   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION securityObjectName dTables 
FUNCTION securityObjectName RETURNS CHARACTER
  ( pdSecurityObjectObj AS DECIMAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN "".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

