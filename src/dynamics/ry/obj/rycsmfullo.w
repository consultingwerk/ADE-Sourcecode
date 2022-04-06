&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
/* Procedure Description
"Astra 2 Static SmartDataObject Template with wizard.

Use this template to create a new Astra 2 SmartDataObject with the assistance of the SmartDataObject Wizard. When completed, this object can be drawn onto any 'smart' container such as a SmartWindow, SmartDialog or SmartFrame. Non-smart objects, such as web objects, can also access a SmartDataObject by running it persistently and calling its methods."
*/
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Astra 2 Static SmartDataObject Wizard" dTables _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? af/sup/afwizdeltp.p */
/* Astra 2 Static SmartDataObject Wizard
Welcome to the Astra 2 Static SmartDataObject Wizard! During the next few steps, the wizard will lead you through all the stages necessary to create this type of object. If you cancel the wizard at any time, then all your changes will be lost. Once the wizard is completed, it is possible to recall parts of the wizard using the LIST option from the section editor. Press Next to proceed.
af/cod/aftemwiziw.w,af/cod/aftemwizpw.w,adm2/support/_wizqry.w,adm2/support/_wizfld.w,af/cod/aftemwizew.w 
*/
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

&scop object-name       rycsmfullo.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

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
&Scoped-define INTERNAL-TABLES ryc_smartlink ryc_smartlink_type ~
ryc_smartobject

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  container_smartobject_obj link_name source_object_instance_obj~
 target_object_instance_obj smartlink_type_obj-2 object_filename
&Scoped-define ENABLED-FIELDS-IN-ryc_smartlink container_smartobject_obj ~
link_name source_object_instance_obj target_object_instance_obj 
&Scoped-define ENABLED-FIELDS-IN-ryc_smartlink_type smartlink_type_obj-2 
&Scoped-define ENABLED-FIELDS-IN-ryc_smartobject object_filename 
&Scoped-Define DATA-FIELDS  smartlink_obj container_smartobject_obj smartlink_type_obj link_name~
 source_object_instance_obj source_object_name target_object_instance_obj~
 link_name-2 smartlink_type_obj-2 target_object_name system_owned~
 user_defined_link object_filename
&Scoped-define DATA-FIELDS-IN-ryc_smartlink smartlink_obj ~
container_smartobject_obj smartlink_type_obj link_name ~
source_object_instance_obj target_object_instance_obj 
&Scoped-define DATA-FIELDS-IN-ryc_smartlink_type link_name-2 ~
smartlink_type_obj-2 system_owned user_defined_link 
&Scoped-define DATA-FIELDS-IN-ryc_smartobject object_filename 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST   rowObject.link_name-2 = ryc_smartlink_type.link_name~
  rowObject.smartlink_type_obj-2 = ryc_smartlink_type.smartlink_type_obj
&Scoped-Define DATA-FIELD-DEFS "ry/obj/rycsmfullo.i"
&Scoped-define QUERY-STRING-Query-Main FOR EACH ryc_smartlink NO-LOCK, ~
      FIRST ryc_smartlink_type WHERE rydb.ryc_smartlink_type.smartlink_type_obj = rydb.ryc_smartlink.smartlink_type_obj NO-LOCK, ~
      FIRST ryc_smartobject WHERE rydb.ryc_smartobject.smartobject_obj = rydb.ryc_smartlink.container_smartobject_obj NO-LOCK INDEXED-REPOSITION
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH ryc_smartlink NO-LOCK, ~
      FIRST ryc_smartlink_type WHERE rydb.ryc_smartlink_type.smartlink_type_obj = rydb.ryc_smartlink.smartlink_type_obj NO-LOCK, ~
      FIRST ryc_smartobject WHERE rydb.ryc_smartobject.smartobject_obj = rydb.ryc_smartlink.container_smartobject_obj NO-LOCK INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main ryc_smartlink ryc_smartlink_type ~
ryc_smartobject
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main ryc_smartlink
&Scoped-define SECOND-TABLE-IN-QUERY-Query-Main ryc_smartlink_type
&Scoped-define THIRD-TABLE-IN-QUERY-Query-Main ryc_smartobject


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLinkObjectName dTables  _DB-REQUIRED
FUNCTION getLinkObjectName RETURNS CHARACTER
  ( INPUT pdLinkObjectObj   AS DECIMAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}


/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      ryc_smartlink, 
      ryc_smartlink_type
    FIELDS(ryc_smartlink_type.link_name
      ryc_smartlink_type.smartlink_type_obj
      ryc_smartlink_type.system_owned
      ryc_smartlink_type.user_defined_link), 
      ryc_smartobject SCROLLING.
&ANALYZE-RESUME
{&DB-REQUIRED-END}


/* ************************  Frame Definitions  *********************** */


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartDataObject Template
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
         WIDTH              = 62.2.
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
     _TblList          = "icfdb.ryc_smartlink,icfdb.ryc_smartlink_type WHERE icfdb.ryc_smartlink ...,icfdb.ryc_smartobject WHERE icfdb.ryc_smartlink ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST USED, FIRST"
     _JoinCode[2]      = "rydb.ryc_smartlink_type.smartlink_type_obj = rydb.ryc_smartlink.smartlink_type_obj"
     _JoinCode[3]      = "rydb.ryc_smartobject.smartobject_obj = rydb.ryc_smartlink.container_smartobject_obj"
     _FldNameList[1]   > icfdb.ryc_smartlink.smartlink_obj
"smartlink_obj" "smartlink_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 21 yes
     _FldNameList[2]   > icfdb.ryc_smartlink.container_smartobject_obj
"container_smartobject_obj" "container_smartobject_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21 yes
     _FldNameList[3]   > icfdb.ryc_smartlink.smartlink_type_obj
"smartlink_type_obj" "smartlink_type_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 21 yes
     _FldNameList[4]   > icfdb.ryc_smartlink.link_name
"link_name" "link_name" ? ? "character" ? ? ? ? ? ? yes ? no 56 yes
     _FldNameList[5]   > icfdb.ryc_smartlink.source_object_instance_obj
"source_object_instance_obj" "source_object_instance_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21 yes
     _FldNameList[6]   > "_<CALC>"
"getLinkObjectName(RowObject.source_object_instance_obj)" "source_object_name" "Source" "x(25)" "character" ? ? ? ? ? ? no ? no 25 no
     _FldNameList[7]   > icfdb.ryc_smartlink.target_object_instance_obj
"target_object_instance_obj" "target_object_instance_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 21 yes
     _FldNameList[8]   > icfdb.ryc_smartlink_type.link_name
"link_name" "link_name-2" ? ? "character" ? ? ? ? ? ? no ? no 28 yes
     _FldNameList[9]   > icfdb.ryc_smartlink_type.smartlink_type_obj
"smartlink_type_obj" "smartlink_type_obj-2" ? ? "decimal" ? ? ? ? ? ? yes ? no 29.4 yes
     _FldNameList[10]   > "_<CALC>"
"getLinkObjectName(RowObject.target_object_instance_obj)" "target_object_name" "Target" "x(25)" "character" ? ? ? ? ? ? no ? no 25 no
     _FldNameList[11]   > icfdb.ryc_smartlink_type.system_owned
"system_owned" "system_owned" ? ? "logical" ? ? ? ? ? ? no ? no 14.2 yes
     _FldNameList[12]   > icfdb.ryc_smartlink_type.user_defined_link
"user_defined_link" "user_defined_link" ? ? "logical" ? ? ? ? ? ? no ? no 17 yes
     _FldNameList[13]   > icfdb.ryc_smartobject.object_filename
"object_filename" "object_filename" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
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
         rowObject.source_object_name = (getLinkObjectName(RowObject.source_object_instance_obj))
         rowObject.target_object_name = (getLinkObjectName(RowObject.target_object_instance_obj))
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLinkObjectName dTables  _DB-REQUIRED
FUNCTION getLinkObjectName RETURNS CHARACTER
  ( INPUT pdLinkObjectObj   AS DECIMAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF pdLinkObjectObj EQ 0 THEN
      RETURN "THIS-PROCEDURE":U.
  ELSE
  FOR FIRST  ryc_object_instance NO-LOCK
      WHERE ryc_object_instance.OBJECT_instance_obj EQ pdLinkObjectObj,
      FIRST ryc_smartobject NO-LOCK
      WHERE ryc_smartobject.smartobject_obj EQ ryc_object_instance.smartobject_obj:

      RETURN ryc_smartobject.OBJECT_filename.
    

  END.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

