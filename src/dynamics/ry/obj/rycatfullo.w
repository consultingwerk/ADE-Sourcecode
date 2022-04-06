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

  Description:  Template SmartDataObject Template

  Purpose:      Template SmartDataObject Template

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

&scop object-name       rycatfullo.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Object identifying preprocessor */
&glob   astra2-staticSmartDataObject yes

{src/adm2/globals.i}

&glob DATA-LOGIC-PROCEDURE       ry/obj/rycatlogcp.p

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
&Scoped-define INTERNAL-TABLES ryc_attribute ryc_attribute_group

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  attribute_label attribute_group_obj data_type attribute_narrative~
 override_type runtime_only is_private constant_level derived_value~
 lookup_type lookup_value design_only system_owned
&Scoped-define ENABLED-FIELDS-IN-ryc_attribute attribute_label ~
attribute_group_obj data_type attribute_narrative override_type ~
runtime_only is_private constant_level derived_value lookup_type ~
lookup_value design_only system_owned 
&Scoped-Define DATA-FIELDS  attribute_label ObjectTypes attribute_group_obj attribute_group_name~
 data_type attribute_narrative override_type runtime_only is_private~
 constant_level derived_value lookup_type lookup_value design_only~
 system_owned attribute_obj
&Scoped-define DATA-FIELDS-IN-ryc_attribute attribute_label ~
attribute_group_obj data_type attribute_narrative override_type ~
runtime_only is_private constant_level derived_value lookup_type ~
lookup_value design_only system_owned attribute_obj 
&Scoped-define DATA-FIELDS-IN-ryc_attribute_group attribute_group_name 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "ry/obj/rycatfullo.i"
&Scoped-define QUERY-STRING-Query-Main FOR EACH ryc_attribute NO-LOCK, ~
      FIRST ryc_attribute_group WHERE ryc_attribute_group.attribute_group_obj = ryc_attribute.attribute_group_obj NO-LOCK ~
    BY ryc_attribute.attribute_label INDEXED-REPOSITION
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH ryc_attribute NO-LOCK, ~
      FIRST ryc_attribute_group WHERE ryc_attribute_group.attribute_group_obj = ryc_attribute.attribute_group_obj NO-LOCK ~
    BY ryc_attribute.attribute_label INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main ryc_attribute ryc_attribute_group
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main ryc_attribute
&Scoped-define SECOND-TABLE-IN-QUERY-Query-Main ryc_attribute_group


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
      ryc_attribute, 
      ryc_attribute_group
    FIELDS(ryc_attribute_group.attribute_group_name) SCROLLING.
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
     _TblList          = "ICFDB.ryc_attribute,ICFDB.ryc_attribute_group WHERE ICFDB.ryc_attribute ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION "
     _TblOptList       = ", FIRST USED"
     _OrdList          = "ICFDB.ryc_attribute.attribute_label|yes"
     _JoinCode[2]      = "ICFDB.ryc_attribute_group.attribute_group_obj = ICFDB.ryc_attribute.attribute_group_obj"
     _FldNameList[1]   > ICFDB.ryc_attribute.attribute_label
"attribute_label" "attribute_label" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[2]   > "_<CALC>"
"getObjectTypes()" "ObjectTypes" ? "x(200)" "character" ? ? ? ? ? ? no ? no 200 no
     _FldNameList[3]   > ICFDB.ryc_attribute.attribute_group_obj
"attribute_group_obj" "attribute_group_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 24 yes
     _FldNameList[4]   > ICFDB.ryc_attribute_group.attribute_group_name
"attribute_group_name" "attribute_group_name" ? ? "character" ? ? ? ? ? ? no ? no 56 yes
     _FldNameList[5]   > ICFDB.ryc_attribute.data_type
"data_type" "data_type" ? ? "integer" ? ? ? ? ? ? yes ? no 4 yes
     _FldNameList[6]   > ICFDB.ryc_attribute.attribute_narrative
"attribute_narrative" "attribute_narrative" ? ? "character" ? ? ? ? ? ? yes ? no 1000 yes
     _FldNameList[7]   > ICFDB.ryc_attribute.override_type
"override_type" "override_type" ? ? "character" ? ? ? ? ? ? yes ? no 6000 yes
     _FldNameList[8]   > ICFDB.ryc_attribute.runtime_only
"runtime_only" "runtime_only" ? ? "logical" ? ? ? ? ? ? yes ? no 1 yes
     _FldNameList[9]   > ICFDB.ryc_attribute.is_private
"is_private" "is_private" ? ? "logical" ? ? ? ? ? ? yes ? no 1 yes
     _FldNameList[10]   > ICFDB.ryc_attribute.constant_level
"constant_level" "constant_level" ? ? "character" ? ? ? ? ? ? yes ? no 20 yes
     _FldNameList[11]   > ICFDB.ryc_attribute.derived_value
"derived_value" "derived_value" ? ? "logical" ? ? ? ? ? ? yes ? no 1 yes
     _FldNameList[12]   > ICFDB.ryc_attribute.lookup_type
"lookup_type" "lookup_type" ? ? "character" ? ? ? ? ? ? yes ? no 20 yes
     _FldNameList[13]   > ICFDB.ryc_attribute.lookup_value
"lookup_value" "lookup_value" ? ? "character" ? ? ? ? ? ? yes ? no 1000 yes
     _FldNameList[14]   > ICFDB.ryc_attribute.design_only
"design_only" "design_only" ? ? "logical" ? ? ? ? ? ? yes ? no 1 yes
     _FldNameList[15]   > ICFDB.ryc_attribute.system_owned
"system_owned" "system_owned" ? ? "logical" ? ? ? ? ? ? yes ? no 1 yes
     _FldNameList[16]   > ICFDB.ryc_attribute.attribute_obj
"attribute_obj" "attribute_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 24 yes
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
         rowObject.ObjectTypes = (getObjectTypes())
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

/* ************************  Function Implementations ***************** */

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getObjectTypes dTables  _DB-REQUIRED
FUNCTION getObjectTypes RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: find all object types 
    Notes: chr(10) delimiter used for editor display 
------------------------------------------------------------------------------*/
 /* remove duplicate attributes - remove inherited flag = yes if found */
 DEFINE VARIABLE cObjectTypes AS CHARACTER  NO-UNDO.
 
 FOR EACH ryc_attribute_value NO-LOCK 
     WHERE ryc_attribute_value.attribute_label = 
             {fnarg columnValue 'attribute_label'}
     AND   ryc_attribute_value.object_type_obj <> 0
     AND   ryc_attribute_value.container_smartobject_obj = 0 
     AND   ryc_attribute_value.smartobject_obj =     0
     AND   ryc_attribute_value.OBJECT_instance_obj = 0:
    FIND gsc_object_type 
        WHERE gsc_object_type.OBJECT_type_obj = ryc_attribute_value.OBJECT_type_obj
    NO-LOCK NO-ERROR.
    
    IF AVAIL gsc_object_type THEN
      ASSIGN cObjectTypes = cObjectTypes 
                        + (IF cObjectTypes = '':U THEN '':u ELSE CHR(10))
                        +  gsc_object_type.OBJECT_type_code.
         
 END.
 RETURN cObjectTypes.   
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

