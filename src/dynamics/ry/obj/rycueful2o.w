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
  File: rycueful2o.w

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

  Update Notes: Added procedure noTreeFilter to indicate that no Filter should be set at this level.

-------------------------------------------------------------------*/
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

&scop object-name       rycueful2o.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Astra 2 object identifying preprocessor */
&glob   astra2-staticSmartDataObject yes

{af/sup2/afglobals.i}

&glob DATA-LOGIC-PROCEDURE       ry/obj/rycuelog2p.p

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
&Scoped-define INTERNAL-TABLES ryc_ui_event gsc_object_type ryc_smartobject

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  object_type_obj container_smartobject_obj smartobject_obj~
 object_instance_obj event_name constant_value action_type action_target~
 event_action event_parameter event_disabled primary_smartobject_obj
&Scoped-define ENABLED-FIELDS-IN-ryc_ui_event object_type_obj ~
container_smartobject_obj smartobject_obj object_instance_obj event_name ~
constant_value action_type action_target event_action event_parameter ~
event_disabled primary_smartobject_obj 
&Scoped-Define DATA-FIELDS  ui_event_obj object_type_obj object_type_code container_smartobject_obj~
 smartobject_obj object_filename object_instance_obj event_name~
 constant_value action_type action_target event_action event_parameter~
 event_disabled primary_smartobject_obj
&Scoped-define DATA-FIELDS-IN-ryc_ui_event ui_event_obj object_type_obj ~
container_smartobject_obj smartobject_obj object_instance_obj event_name ~
constant_value action_type action_target event_action event_parameter ~
event_disabled primary_smartobject_obj 
&Scoped-define DATA-FIELDS-IN-gsc_object_type object_type_code 
&Scoped-define DATA-FIELDS-IN-ryc_smartobject object_filename 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "ry/obj/rycueful2o.i"
&Scoped-define QUERY-STRING-Query-Main FOR EACH ryc_ui_event NO-LOCK, ~
      FIRST gsc_object_type WHERE gsc_object_type.object_type_obj = ryc_ui_event.object_type_obj NO-LOCK, ~
      FIRST ryc_smartobject WHERE ryc_smartobject.smartobject_obj = ryc_ui_event.smartobject_obj NO-LOCK INDEXED-REPOSITION
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH ryc_ui_event NO-LOCK, ~
      FIRST gsc_object_type WHERE gsc_object_type.object_type_obj = ryc_ui_event.object_type_obj NO-LOCK, ~
      FIRST ryc_smartobject WHERE ryc_smartobject.smartobject_obj = ryc_ui_event.smartobject_obj NO-LOCK INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main ryc_ui_event gsc_object_type ~
ryc_smartobject
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main ryc_ui_event
&Scoped-define SECOND-TABLE-IN-QUERY-Query-Main gsc_object_type
&Scoped-define THIRD-TABLE-IN-QUERY-Query-Main ryc_smartobject


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSDOLevel dTables  _DB-REQUIRED
FUNCTION getSDOLevel RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}


/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      ryc_ui_event, 
      gsc_object_type, 
      ryc_smartobject SCROLLING.
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
     _TblList          = "icfdb.ryc_ui_event,icfdb.gsc_object_type WHERE icfdb.ryc_ui_event ...,icfdb.ryc_smartobject WHERE icfdb.ryc_ui_event ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST, FIRST"
     _JoinCode[2]      = "icfdb.gsc_object_type.object_type_obj = icfdb.ryc_ui_event.object_type_obj"
     _JoinCode[3]      = "icfdb.ryc_smartobject.smartobject_obj = icfdb.ryc_ui_event.smartobject_obj"
     _FldNameList[1]   > icfdb.ryc_ui_event.ui_event_obj
"ui_event_obj" "ui_event_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 21 yes
     _FldNameList[2]   > icfdb.ryc_ui_event.object_type_obj
"object_type_obj" "object_type_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21 yes
     _FldNameList[3]   > icfdb.gsc_object_type.object_type_code
"object_type_code" "object_type_code" ? ? "character" ? ? ? ? ? ? no ? no 30 yes
     _FldNameList[4]   > icfdb.ryc_ui_event.container_smartobject_obj
"container_smartobject_obj" "container_smartobject_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21 yes
     _FldNameList[5]   > icfdb.ryc_ui_event.smartobject_obj
"smartobject_obj" "smartobject_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21 yes
     _FldNameList[6]   > icfdb.ryc_smartobject.object_filename
"object_filename" "object_filename" ? ? "character" ? ? ? ? ? ? no ? no 140 yes
     _FldNameList[7]   > icfdb.ryc_ui_event.object_instance_obj
"object_instance_obj" "object_instance_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21 yes
     _FldNameList[8]   > icfdb.ryc_ui_event.event_name
"event_name" "event_name" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[9]   > icfdb.ryc_ui_event.constant_value
"constant_value" "constant_value" ? ? "logical" ? ? ? ? ? ? yes ? no 1 yes
     _FldNameList[10]   > icfdb.ryc_ui_event.action_type
"action_type" "action_type" ? ? "character" ? ? ? ? ? ? yes ? no 6 yes
     _FldNameList[11]   > icfdb.ryc_ui_event.action_target
"action_target" "action_target" ? ? "character" ? ? ? ? ? ? yes ? no 56 yes
     _FldNameList[12]   > icfdb.ryc_ui_event.event_action
"event_action" "event_action" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[13]   > icfdb.ryc_ui_event.event_parameter
"event_parameter" "event_parameter" ? ? "character" ? ? ? ? ? ? yes ? no 140 yes
     _FldNameList[14]   > icfdb.ryc_ui_event.event_disabled
"event_disabled" "event_disabled" ? ? "logical" ? ? ? ? ? ? yes ? no 1 yes
     _FldNameList[15]   > icfdb.ryc_ui_event.primary_smartobject_obj
"primary_smartobject_obj" "primary_smartobject_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21 yes
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE noTreeFilter dTables 
PROCEDURE noTreeFilter :
/*------------------------------------------------------------------------------
  Purpose:     This will ensure that the filter from the TreeView filter viewer
               is not set for this object.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSDOLevel dTables  _DB-REQUIRED
FUNCTION getSDOLevel RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN "ObjectInstance".   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

