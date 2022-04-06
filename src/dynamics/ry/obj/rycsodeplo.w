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
  File: rycsodeplo.w

  Description:  Object Deployment Destination SDO

  Purpose:      Object Deployment Destination SDO

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   09/17/2002  Author:     

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

&scop object-name       rycsodeplo.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Object identifying preprocessor */
&glob   astra2-staticSmartDataObject yes

{src/adm2/globals.i}

&glob DATA-LOGIC-PROCEDURE .p

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
&Scoped-define INTERNAL-TABLES gsc_object_type ryc_smartobject

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  object_type_code object_path object_filename object_extension~
 object_description calcDeplString disabled-2 design_only runnable_from_menu~
 run_when system_owned required_db_list object_type_description disabled~
 deployment_type
&Scoped-define ENABLED-FIELDS-IN-gsc_object_type object_type_code ~
object_type_description disabled 
&Scoped-define ENABLED-FIELDS-IN-ryc_smartobject object_path ~
object_filename object_extension object_description disabled-2 design_only ~
runnable_from_menu run_when system_owned required_db_list deployment_type 
&Scoped-Define DATA-FIELDS  object_type_code object_path object_filename object_extension~
 object_description calcDeplString disabled-2 design_only runnable_from_menu~
 run_when system_owned required_db_list object_type_description disabled~
 deployment_type
&Scoped-define DATA-FIELDS-IN-gsc_object_type object_type_code ~
object_type_description disabled 
&Scoped-define DATA-FIELDS-IN-ryc_smartobject object_path object_filename ~
object_extension object_description disabled-2 design_only ~
runnable_from_menu run_when system_owned required_db_list deployment_type 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST   rowObject.disabled-2 = ryc_smartobject.disabled
&Scoped-Define DATA-FIELD-DEFS "ry/obj/rycsodeplo.i"
&Scoped-define QUERY-STRING-Query-Main FOR EACH gsc_object_type ~
      WHERE gsc_object_type.static_object = TRUE ~
 NO-LOCK, ~
      EACH ryc_smartobject WHERE ryc_smartobject.object_type_obj = gsc_object_type.object_type_obj ~
  AND ryc_smartobject.static_object = TRUE NO-LOCK ~
    BY gsc_object_type.object_type_code DESCENDING ~
       BY ryc_smartobject.object_filename INDEXED-REPOSITION
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH gsc_object_type ~
      WHERE gsc_object_type.static_object = TRUE ~
 NO-LOCK, ~
      EACH ryc_smartobject WHERE ryc_smartobject.object_type_obj = gsc_object_type.object_type_obj ~
  AND ryc_smartobject.static_object = TRUE NO-LOCK ~
    BY gsc_object_type.object_type_code DESCENDING ~
       BY ryc_smartobject.object_filename INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main gsc_object_type ryc_smartobject
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main gsc_object_type
&Scoped-define SECOND-TABLE-IN-QUERY-Query-Main ryc_smartobject


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD buildDeploymentString dTables  _DB-REQUIRED
FUNCTION buildDeploymentString RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}


/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
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
     _TblList          = "ICFDB.gsc_object_type,ICFDB.ryc_smartobject WHERE ICFDB.gsc_object_type ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "ICFDB.gsc_object_type.object_type_code|no,ICFDB.ryc_smartobject.object_filename|yes"
     _Where[1]         = "gsc_object_type.static_object = TRUE
"
     _JoinCode[2]      = "ryc_smartobject.object_type_obj = gsc_object_type.object_type_obj
  AND ryc_smartobject.static_object = TRUE"
     _FldNameList[1]   > ICFDB.gsc_object_type.object_type_code
"object_type_code" "object_type_code" "Class Code" ? "character" ? ? ? ? ? ? yes ? no 17.2 no
     _FldNameList[2]   > ICFDB.ryc_smartobject.object_path
"object_path" "object_path" ? "X(15)" "character" ? ? ? ? ? ? yes ? no 15 no
     _FldNameList[3]   > ICFDB.ryc_smartobject.object_filename
"object_filename" "object_filename" "Filename" "X(21)" "character" ? ? ? ? ? ? yes ? no 21 no
     _FldNameList[4]   > ICFDB.ryc_smartobject.object_extension
"object_extension" "object_extension" "Extension" "X(5)" "character" ? ? ? ? ? ? yes ? no 16 no
     _FldNameList[5]   > ICFDB.ryc_smartobject.object_description
"object_description" "object_description" "Description" "X(30)" "character" ? ? ? ? ? ? yes ? no 30 no
     _FldNameList[6]   > "_<CALC>"
"buildDeploymentString()" "calcDeplString" "Deploy To" "x(20)" "character" ? ? ? ? ? ? yes ? no 20 no
     _FldNameList[7]   > ICFDB.ryc_smartobject.disabled
"disabled" "disabled-2" "Object Disabled" ? "logical" ? ? ? ? ? ? yes ? no 8.2 no
     _FldNameList[8]   > ICFDB.ryc_smartobject.design_only
"design_only" "design_only" "Development Object" ? "logical" ? ? ? ? ? ? yes ? no 11.4 no
     _FldNameList[9]   > ICFDB.ryc_smartobject.runnable_from_menu
"runnable_from_menu" "runnable_from_menu" ? ? "logical" ? ? ? ? ? ? yes ? no 20.4 no
     _FldNameList[10]   > ICFDB.ryc_smartobject.run_when
"run_when" "run_when" ? ? "character" ? ? ? ? ? ? yes ? no 10.4 no
     _FldNameList[11]   > ICFDB.ryc_smartobject.system_owned
"system_owned" "system_owned" ? ? "logical" ? ? ? ? ? ? yes ? no 14.2 no
     _FldNameList[12]   > ICFDB.ryc_smartobject.required_db_list
"required_db_list" "required_db_list" ? ? "character" ? ? ? ? ? ? yes ? no 35 no
     _FldNameList[13]   > ICFDB.gsc_object_type.object_type_description
"object_type_description" "object_type_description" "Class Description" "X(25)" "character" ? ? ? ? ? ? yes ? no 25 no
     _FldNameList[14]   > ICFDB.gsc_object_type.disabled
"disabled" "disabled" "Class Disabled" ? "logical" ? ? ? ? ? ? yes ? no 8.2 no
     _FldNameList[15]   > ICFDB.ryc_smartobject.deployment_type
"deployment_type" "deployment_type" ? "X(25)" "character" ? ? ? ? ? ? yes ? no 25 no
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
         rowObject.calcDeplString = (buildDeploymentString())
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
  DEFINE VARIABLE cDataFieldChildren AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cWhere             AS CHARACTER  NO-UNDO.

  {set openOnInit FALSE}.

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

  /* We don't want any datafields or it's children */

  ASSIGN cDataFieldChildren = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "dataField":U)
         cWhere             = "LOOKUP(gsc_object_type.object_type_code,'" + cDataFieldChildren + "') = 0".

  RUN updateAddQueryWhere IN TARGET-PROCEDURE (INPUT cWhere, INPUT "object_type_code":U). 
  DYNAMIC-FUNCTION("openQuery":U IN TARGET-PROCEDURE).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

/* ************************  Function Implementations ***************** */

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION buildDeploymentString dTables  _DB-REQUIRED
FUNCTION buildDeploymentString RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDeploymentString AS CHARACTER  NO-UNDO.

  {get RowObject hRowObject}.

  IF hRowObject:AVAILABLE 
  THEN DO:
      ASSIGN cDeploymentString = hRowObject:BUFFER-FIELD("deployment_type"):BUFFER-VALUE
             cDeploymentString = REPLACE(cDeploymentString, "SRV":U, "Servers")
             cDeploymentString = REPLACE(cDeploymentString, "CLN":U, "Clients")
             cDeploymentString = REPLACE(cDeploymentString, "WEB":U, "Web").
  END.

  RETURN cDeploymentString.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

