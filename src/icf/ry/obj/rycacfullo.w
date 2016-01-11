&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          rydb             PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
{adecomm/appserv.i}
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
&Scoped-define INTERNAL-TABLES ryc_action

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  action_accelerator action_disabled action_label action_link~
 action_menu_label action_narration action_parameter action_reference~
 action_tooltip action_type_code disable_state_list enable_state_list~
 image1_down_filename image1_insensitive_filename image1_up_filename~
 image2_down_filename image2_insensitive_filename image2_up_filename~
 initial_code instance_attribute_obj object_obj on_choose_action~
 on_create_publish_event place_action_on_menu place_action_on_toolbar~
 propagate_links security_token system_owned
&Scoped-define ENABLED-FIELDS-IN-ryc_action action_accelerator ~
action_disabled action_label action_link action_menu_label action_narration ~
action_parameter action_reference action_tooltip action_type_code ~
disable_state_list enable_state_list image1_down_filename ~
image1_insensitive_filename image1_up_filename image2_down_filename ~
image2_insensitive_filename image2_up_filename initial_code ~
instance_attribute_obj object_obj on_choose_action on_create_publish_event ~
place_action_on_menu place_action_on_toolbar propagate_links security_token ~
system_owned 
&Scoped-Define DATA-FIELDS  action_accelerator action_disabled action_label action_link~
 action_menu_label action_narration action_obj action_parameter~
 action_reference action_tooltip action_type_code disable_state_list~
 enable_state_list image1_down_filename image1_insensitive_filename~
 image1_up_filename image2_down_filename image2_insensitive_filename~
 image2_up_filename initial_code instance_attribute_obj object_obj~
 on_choose_action on_create_publish_event place_action_on_menu~
 place_action_on_toolbar propagate_links security_token system_owned
&Scoped-define DATA-FIELDS-IN-ryc_action action_accelerator action_disabled ~
action_label action_link action_menu_label action_narration action_obj ~
action_parameter action_reference action_tooltip action_type_code ~
disable_state_list enable_state_list image1_down_filename ~
image1_insensitive_filename image1_up_filename image2_down_filename ~
image2_insensitive_filename image2_up_filename initial_code ~
instance_attribute_obj object_obj on_choose_action on_create_publish_event ~
place_action_on_menu place_action_on_toolbar propagate_links security_token ~
system_owned 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "ry/obj/rycacfullo.i"
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH ryc_action NO-LOCK INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main ryc_action
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main ryc_action


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      ryc_action SCROLLING.
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
     _TblList          = "RYDB.ryc_action"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > RYDB.ryc_action.action_accelerator
"action_accelerator" "action_accelerator" ? ? "character" ? ? ? ? ? ? yes ? no 17.4 yes
     _FldNameList[2]   > RYDB.ryc_action.action_disabled
"action_disabled" "action_disabled" ? ? "logical" ? ? ? ? ? ? yes ? no 14.8 yes
     _FldNameList[3]   > RYDB.ryc_action.action_label
"action_label" "action_label" ? ? "character" ? ? ? ? ? ? yes ? no 28 yes
     _FldNameList[4]   > RYDB.ryc_action.action_link
"action_link" "action_link" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[5]   > RYDB.ryc_action.action_menu_label
"action_menu_label" "action_menu_label" ? ? "character" ? ? ? ? ? ? yes ? no 28 yes
     _FldNameList[6]   > RYDB.ryc_action.action_narration
"action_narration" "action_narration" ? ? "character" ? ? ? ? ? ? yes ? no 500 yes
     _FldNameList[7]   > RYDB.ryc_action.action_obj
"action_obj" "action_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 21.6 yes
     _FldNameList[8]   > RYDB.ryc_action.action_parameter
"action_parameter" "action_parameter" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[9]   > RYDB.ryc_action.action_reference
"action_reference" "action_reference" ? ? "character" ? ? ? ? ? ? yes ? no 16.6 yes
     _FldNameList[10]   > RYDB.ryc_action.action_tooltip
"action_tooltip" "action_tooltip" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[11]   > RYDB.ryc_action.action_type_code
"action_type_code" "action_type_code" ? ? "character" ? ? ? ? ? ? yes ? no 17 yes
     _FldNameList[12]   > RYDB.ryc_action.disable_state_list
"disable_state_list" "disable_state_list" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[13]   > RYDB.ryc_action.enable_state_list
"enable_state_list" "enable_state_list" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[14]   > RYDB.ryc_action.image1_down_filename
"image1_down_filename" "image1_down_filename" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[15]   > RYDB.ryc_action.image1_insensitive_filename
"image1_insensitive_filename" "image1_insensitive_filename" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[16]   > RYDB.ryc_action.image1_up_filename
"image1_up_filename" "image1_up_filename" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[17]   > RYDB.ryc_action.image2_down_filename
"image2_down_filename" "image2_down_filename" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[18]   > RYDB.ryc_action.image2_insensitive_filename
"image2_insensitive_filename" "image2_insensitive_filename" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[19]   > RYDB.ryc_action.image2_up_filename
"image2_up_filename" "image2_up_filename" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[20]   > RYDB.ryc_action.initial_code
"initial_code" "initial_code" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[21]   > RYDB.ryc_action.instance_attribute_obj
"instance_attribute_obj" "instance_attribute_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21.6 yes
     _FldNameList[22]   > RYDB.ryc_action.object_obj
"object_obj" "object_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21.6 yes
     _FldNameList[23]   > RYDB.ryc_action.on_choose_action
"on_choose_action" "on_choose_action" ? ? "character" ? ? ? ? ? ? yes ? no 35 yes
     _FldNameList[24]   > RYDB.ryc_action.on_create_publish_event
"on_create_publish_event" "on_create_publish_event" ? ? "character" ? ? ? ? ? ? yes ? no 35 yes
     _FldNameList[25]   > RYDB.ryc_action.place_action_on_menu
"place_action_on_menu" "place_action_on_menu" ? ? "logical" ? ? ? ? ? ? yes ? no 21.4 yes
     _FldNameList[26]   > RYDB.ryc_action.place_action_on_toolbar
"place_action_on_toolbar" "place_action_on_toolbar" ? ? "logical" ? ? ? ? ? ? yes ? no 23.2 yes
     _FldNameList[27]   > RYDB.ryc_action.propagate_links
"propagate_links" "propagate_links" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[28]   > RYDB.ryc_action.security_token
"security_token" "security_token" ? ? "character" ? ? ? ? ? ? yes ? no 28 yes
     _FldNameList[29]   > RYDB.ryc_action.system_owned
"system_owned" "system_owned" ? ? "logical" ? ? ? ? ? ? yes ? no 14.2 yes
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

