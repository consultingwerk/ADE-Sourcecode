&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
          icfdb            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
{adecomm/appserv.i}
DEFINE VARIABLE h_Astra                    AS HANDLE          NO-UNDO.
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS dTables 
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

DEFINE VARIABLE cClassesToRetrieve AS CHARACTER  NO-UNDO.

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
&Scoped-define INTERNAL-TABLES gsc_object_type ryc_smartobject ~
gsc_product_module

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  object_filename object_description template_smartobject product_module_code~
 object_type_code object_type_description
&Scoped-define ENABLED-FIELDS-IN-gsc_object_type object_type_code ~
object_type_description 
&Scoped-define ENABLED-FIELDS-IN-ryc_smartobject object_filename ~
object_description template_smartobject 
&Scoped-define ENABLED-FIELDS-IN-gsc_product_module product_module_code 
&Scoped-Define DATA-FIELDS  object_filename object_description template_smartobject product_module_code~
 object_type_code object_type_description
&Scoped-define DATA-FIELDS-IN-gsc_object_type object_type_code ~
object_type_description 
&Scoped-define DATA-FIELDS-IN-ryc_smartobject object_filename ~
object_description template_smartobject 
&Scoped-define DATA-FIELDS-IN-gsc_product_module product_module_code 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "ry/obj/dlayoutlookup.i"
&Scoped-define QUERY-STRING-Query-Main FOR EACH gsc_object_type ~
      WHERE LOOKUP(gsc_object_type.object_type_code, cClassesToRetrieve) > 0 NO-LOCK, ~
      EACH ryc_smartobject OF gsc_object_type  ~
      WHERE ryc_smartobject.object_type_obj = ~
icfdb.gsc_object_type.object_type_obj ~
 AND ryc_smartobject.template_smartobject NO-LOCK, ~
      FIRST gsc_product_module WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj NO-LOCK INDEXED-REPOSITION
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH gsc_object_type ~
      WHERE LOOKUP(gsc_object_type.object_type_code, cClassesToRetrieve) > 0 NO-LOCK, ~
      EACH ryc_smartobject OF gsc_object_type  ~
      WHERE ryc_smartobject.object_type_obj = ~
icfdb.gsc_object_type.object_type_obj ~
 AND ryc_smartobject.template_smartobject NO-LOCK, ~
      FIRST gsc_product_module WHERE gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj NO-LOCK INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main gsc_object_type ryc_smartobject ~
gsc_product_module
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main gsc_object_type
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
      gsc_object_type, 
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
     _TblList          = "icfdb.gsc_object_type,icfdb.ryc_smartobject OF icfdb.gsc_object_type ,icfdb.gsc_product_module WHERE icfdb.ryc_smartobject ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ",, FIRST,"
     _Where[1]         = "LOOKUP(gsc_object_type.object_type_code, cClassesToRetrieve) > 0"
     _Where[2]         = "ICFDB.ryc_smartobject.object_type_obj =
icfdb.gsc_object_type.object_type_obj
 AND ICFDB.ryc_smartobject.template_smartobject"
     _JoinCode[3]      = "gsc_product_module.product_module_obj = ryc_smartobject.product_module_obj"
     _FldNameList[1]   > ICFDB.ryc_smartobject.object_filename
"object_filename" "object_filename" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[2]   > icfdb.ryc_smartobject.object_description
"object_description" "object_description" ? ? "character" ? ? ? ? ? ? yes ? no 35 yes
     _FldNameList[3]   > ICFDB.ryc_smartobject.template_smartobject
"template_smartobject" "template_smartobject" ? ? "logical" ? ? ? ? ? ? yes ? no 21 yes
     _FldNameList[4]   > ICFDB.gsc_product_module.product_module_code
"product_module_code" "product_module_code" ? ? "character" ? ? ? ? ? ? yes ? no 20.6 yes
     _FldNameList[5]   > ICFDB.gsc_object_type.object_type_code
"object_type_code" "object_type_code" ? ? "character" ? ? ? ? ? ? yes ? no 17.2 yes
     _FldNameList[6]   > ICFDB.gsc_object_type.object_type_description
"object_type_description" "object_type_description" ? ? "character" ? ? ? ? ? ? yes ? no 35 yes
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

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject dTables  _DB-REQUIRED
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/

  IF VALID-HANDLE(gshRepositoryManager) THEN
    ASSIGN cClassesToRetrieve = DYNAMIC-FUNCTION("getClassChildrenFromDB":U IN gshRepositoryManager, INPUT "dynMenc,dynFold,dynObjc")
           cClassesToRetrieve = REPLACE(cClassesToRetrieve, CHR(3), ",":U).

  /* Code placed here will execute PRIOR to standard behavior. */

  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

