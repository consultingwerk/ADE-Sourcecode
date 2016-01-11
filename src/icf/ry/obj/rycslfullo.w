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
/*---------------------------------------------------------------------------------
  File: rycslfullo.w

  Description:  Supported Link Maintenance SDO

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   06/27/2002  Author:     Chris Koster

  Update Notes: Created from Template rysttasdoo.w

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

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

&scop object-name       rycslfullo.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Object identifying preprocessor */
&glob   astra2-staticSmartDataObject yes

{src/adm2/globals.i}

&GLOB DATA-LOGIC-PROCEDURE ry/obj/rycsllogcp.p

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
&Scoped-define INTERNAL-TABLES ryc_supported_link ryc_smartlink_type ~
gsc_object_type

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  deactivated_link_on_hide link_source link_target object_type_obj~
 smartlink_type_obj
&Scoped-define ENABLED-FIELDS-IN-ryc_supported_link ~
deactivated_link_on_hide link_source link_target object_type_obj ~
smartlink_type_obj 
&Scoped-Define DATA-FIELDS  deactivated_link_on_hide link_source link_target object_type_obj~
 smartlink_type_obj supported_link_obj link_name user_defined_link~
 object_type_code object_type_description
&Scoped-define DATA-FIELDS-IN-ryc_supported_link deactivated_link_on_hide ~
link_source link_target object_type_obj smartlink_type_obj ~
supported_link_obj 
&Scoped-define DATA-FIELDS-IN-ryc_smartlink_type link_name ~
user_defined_link 
&Scoped-define DATA-FIELDS-IN-gsc_object_type object_type_code ~
object_type_description 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "ry/obj/rycslfullo.i"
&Scoped-define QUERY-STRING-Query-Main FOR EACH ryc_supported_link NO-LOCK, ~
      FIRST ryc_smartlink_type WHERE ryc_smartlink_type.smartlink_type_obj = ryc_supported_link.smartlink_type_obj NO-LOCK, ~
      FIRST gsc_object_type WHERE gsc_object_type.object_type_obj = ryc_supported_link.object_type_obj NO-LOCK INDEXED-REPOSITION
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH ryc_supported_link NO-LOCK, ~
      FIRST ryc_smartlink_type WHERE ryc_smartlink_type.smartlink_type_obj = ryc_supported_link.smartlink_type_obj NO-LOCK, ~
      FIRST gsc_object_type WHERE gsc_object_type.object_type_obj = ryc_supported_link.object_type_obj NO-LOCK INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main ryc_supported_link ~
ryc_smartlink_type gsc_object_type
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main ryc_supported_link
&Scoped-define SECOND-TABLE-IN-QUERY-Query-Main ryc_smartlink_type
&Scoped-define THIRD-TABLE-IN-QUERY-Query-Main gsc_object_type


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      ryc_supported_link, 
      ryc_smartlink_type, 
      gsc_object_type SCROLLING.
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
     _TblList          = "ICFDB.ryc_supported_link,ICFDB.ryc_smartlink_type WHERE ICFDB.ryc_supported_link ...,ICFDB.gsc_object_type WHERE ICFDB.ryc_supported_link ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST, FIRST"
     _JoinCode[2]      = "ryc_smartlink_type.smartlink_type_obj = ryc_supported_link.smartlink_type_obj"
     _JoinCode[3]      = "gsc_object_type.object_type_obj = ryc_supported_link.object_type_obj"
     _FldNameList[1]   > ICFDB.ryc_supported_link.deactivated_link_on_hide
"deactivated_link_on_hide" "deactivated_link_on_hide" ? ? "logical" ? ? ? ? ? ? yes ? no 24.6 yes
     _FldNameList[2]   > ICFDB.ryc_supported_link.link_source
"link_source" "link_source" ? ? "logical" ? ? ? ? ? ? yes ? no 11.4 yes
     _FldNameList[3]   > ICFDB.ryc_supported_link.link_target
"link_target" "link_target" ? ? "logical" ? ? ? ? ? ? yes ? no 10.8 yes
     _FldNameList[4]   > ICFDB.ryc_supported_link.object_type_obj
"object_type_obj" "object_type_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 33.6 yes
     _FldNameList[5]   > ICFDB.ryc_supported_link.smartlink_type_obj
"smartlink_type_obj" "smartlink_type_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 33.6 yes
     _FldNameList[6]   > ICFDB.ryc_supported_link.supported_link_obj
"supported_link_obj" "supported_link_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 33.6 yes
     _FldNameList[7]   > ICFDB.ryc_smartlink_type.link_name
"link_name" "link_name" ? ? "character" ? ? ? ? ? ? no ? no 28 yes
     _FldNameList[8]   > ICFDB.ryc_smartlink_type.user_defined_link
"user_defined_link" "user_defined_link" ? ? "logical" ? ? ? ? ? ? no ? no 17 yes
     _FldNameList[9]   > ICFDB.gsc_object_type.object_type_code
"object_type_code" "object_type_code" ? ? "character" ? ? ? ? ? ? no ? no 17.2 yes
     _FldNameList[10]   > ICFDB.gsc_object_type.object_type_description
"object_type_description" "object_type_description" ? ? "character" ? ? ? ? ? ? no ? no 35 yes
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

