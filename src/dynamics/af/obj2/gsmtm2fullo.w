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


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE Toolbar_band NO-UNDO LIKE gsm_toolbar_menu_structure
       FIELD ToolbarName as char
       FIELD BandName as char.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS dTables 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File:         af/obj2/gsmtm2fullo.w

  Description:  SDO based on tempTables for Menu&Toolbar search dialog

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   24/11/2001  Author:  Don Bulua   

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

&scop object-name       gsmtm2fullo.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Object identifying preprocessor */
&glob   astra2-staticSmartDataObject yes

{src/adm2/globals.i}

&glob DATA-LOGIC-PROCEDURE ry/obj/rytemlogic.p

DEFINE VARIABLE gdBandObject    AS DECIMAL  NO-UNDO.
DEFINE VARIABLE gcbandCode      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gdProductModule AS DECIMAL    NO-UNDO.
DEFINE VARIABLE gdObjectID      AS DECIMAL    NO-UNDO INIT 1.

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
&Scoped-define INTERNAL-TABLES Toolbar_band

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS 
&Scoped-Define DATA-FIELDS  object_obj menu_structure_obj ToolbarName Bandname
&Scoped-define DATA-FIELDS-IN-Toolbar_band object_obj menu_structure_obj 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "af/obj2/gsmtm2fullo.i"
&Scoped-define QUERY-STRING-Query-Main FOR EACH Toolbar_band NO-LOCK INDEXED-REPOSITION
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH Toolbar_band NO-LOCK INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main Toolbar_band
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main Toolbar_band


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBandName dTables  _DB-REQUIRED
FUNCTION getBandName RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getToolbarName dTables  _DB-REQUIRED
FUNCTION getToolbarName RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD openQuery dTables  _DB-REQUIRED
FUNCTION openQuery RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBand dTables  _DB-REQUIRED
FUNCTION setBand RETURNS LOGICAL
  ( pdBandObject AS DECIMAL,
    pcBandCode   AS CHAR ,
    pdProductModule AS DECIMAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}


/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      Toolbar_band SCROLLING.
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
   Temp-Tables and Buffers:
      TABLE: Toolbar_band T "?" NO-UNDO ICFDB gsm_toolbar_menu_structure
      ADDITIONAL-FIELDS:
          FIELD ToolbarName as char
          FIELD BandName as char
      END-FIELDS.
   END-TABLES.
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
     _TblList          = "Temp-Tables.Toolbar_band"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Temp-Tables.Toolbar_band.object_obj
"object_obj" "object_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 33 no
     _FldNameList[2]   > Temp-Tables.Toolbar_band.menu_structure_obj
"menu_structure_obj" "menu_structure_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 33 no
     _FldNameList[3]   > "_<CALC>"
"getToolbarname()" "ToolbarName" "Toolbar Name" "x(45)" "character" ? ? ? ? ? ? no ? no 45 no
     _FldNameList[4]   > "_<CALC>"
"getbandname()" "Bandname" "Band Name" "x(28)" "character" ? ? ? ? ? ? no ? no 28 no
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildToolbarBandChild dTables  _DB-REQUIRED
PROCEDURE buildToolbarBandChild :
/*------------------------------------------------------------------------------
  Purpose:    Search all child bands that contain selected band
  Parameters:  <none>
  Notes:      This procedure is run recursively 
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pdBandObject AS DECIMAL    NO-UNDO.

FOR EACH gsm_menu_structure NO-LOCK,
    EACH gsm_menu_structure_item NO-LOCK
      WHERE gsm_menu_structure.menu_structure_obj = gsm_menu_structure_item.MENU_structure_obj
        AND gsm_menu_structure_item.child_menu_structure_obj = pdBandObject:
   
  /* If the parent band is a menubar, check if it's contained in a toolbar */
  IF gsm_menu_structure.menu_structure_type = "MenuBar":U THEN
  DO:
    FOR EACH gsm_toolbar_menu_structure NO-LOCK
          WHERE gsm_toolbar_menu_structure.MENU_structure_obj = gsm_menu_structure_item.MENU_structure_obj,
        FIRST ryc_smartobject NO-LOCK
         WHERE ryc_smartobject.smartobject_obj = gsm_toolbar_menu_structure.OBJECT_obj :
         
      IF NOT CAN-FIND(FIRST Toolbar_band 
                      WHERE Toolbar_band.object_obj  = gsm_toolbar_menu_structure.object_obj) THEN
      DO:
        CREATE TOOLBAR_Band.
        ASSIGN Toolbar_band.toolbar_menu_structure_obj = gdObjectID
               gdObjectID               = gdObjectID + 1
               Toolbar_band.OBJECT_obj  = gsm_toolbar_menu_structure.object_obj
               Toolbar_band.ToolbarName = ryc_smartobject.Object_filename
               Toolbar_band.BandName    = gcbandCode.
      END.
    END.
  END.
  ELSE IF gsm_menu_structure_item.MENU_structure_obj > 0 THEN
     RUN buildToolbarBandChild (gsm_menu_structure_item.MENU_structure_obj).
 

END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildToolbarBands dTables  _DB-REQUIRED
PROCEDURE buildToolbarBands :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* Build the bands that are directly in the first level of the SmartToolbar */
IF gdProductModule = 0 THEN
  FOR EACH gsm_toolbar_menu_structure NO-LOCK
        WHERE gsm_toolbar_menu_structure.menu_structure_obj = gdBandObject,
      FIRST ryc_smartobject NO-LOCK
        WHERE ryc_smartobject.smartobject_obj =  gsm_toolbar_menu_structure.OBJECT_obj,
      FIRST gsm_menu_structure NO-LOCK
        WHERE gsm_menu_structure.MENU_structure_obj = gsm_toolbar_menu_structure.menu_structure_obj:

       CREATE TOOLBAR_Band.
       ASSIGN Toolbar_band.toolbar_menu_structure_obj = gdObjectID
              gdObjectID               = gdObjectID + 1
              Toolbar_band.OBJECT_obj  = gsm_toolbar_menu_structure.OBJECT_obj
              Toolbar_band.ToolbarName = ryc_smartobject.Object_FILENAME
              Toolbar_band.BandName    = gsm_menu_structure.MENU_structure_code.
  END.
ELSE
  FOR EACH gsm_toolbar_menu_structure  NO-LOCK
        WHERE gsm_toolbar_menu_structure.menu_structure_obj = gdBandObject,
      FIRST ryc_smartobject  NO-LOCK
        WHERE ryc_smartobject.smartOBJECT_obj     =  gsm_toolbar_menu_structure.OBJECT_obj
          AND ryc_smartobject.product_module = gdProductModule,
      FIRST gsm_menu_structure NO-LOCK
        WHERE gsm_menu_structure.MENU_structure_obj = gsm_toolbar_menu_structure.menu_structure_obj:

       CREATE TOOLBAR_Band.
       ASSIGN Toolbar_band.toolbar_menu_structure_obj = gdObjectID
              gdObjectID               = gdObjectID + 1
              Toolbar_band.OBJECT_obj  = gsm_toolbar_menu_structure.OBJECT_obj
              Toolbar_band.ToolbarName = ryc_smartobject.Object_FILENAME
              Toolbar_band.BandName    = gsm_menu_structure.MENU_structure_code.
       
  END.

  RUN buildToolbarBandChild (gdBandObject).

  
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
         rowObject.Bandname = (getbandname())
         rowObject.ToolbarName = (getToolbarname())
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

  /* Code placed here will execute PRIOR to standard behavior. */
  


  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

/* ************************  Function Implementations ***************** */

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBandName dTables  _DB-REQUIRED
FUNCTION getBandName RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
RETURN Toolbar_band.bandName.
/*
  FIND gsm_menu_structure 
    WHERE gsm_menu_structure.menu_structure_obj = Toolbar_band.menu_structure_obj NO-LOCK NO-ERROR.
  IF AVAILABLE gsm_menu_structure  THEN
    RETURN gsm_menu_structure.MENU_structure_code.
  ELSE
    RETURN "".   /* Function return value. */
*/

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getToolbarName dTables  _DB-REQUIRED
FUNCTION getToolbarName RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
 RETURN Toolbar_band.ToolbarName.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION openQuery dTables  _DB-REQUIRED
FUNCTION openQuery RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Notes:       
------------------------------------------------------------------------------*/
  IF gdBandObject > 0 THEN
  DO:
    EMPTY TEMP-TABLE Toolbar_Band  NO-ERROR .
    RUN buildToolbarBands. 
  END.

  RETURN SUPER( ).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBand dTables  _DB-REQUIRED
FUNCTION setBand RETURNS LOGICAL
  ( pdBandObject AS DECIMAL,
    pcBandCode   AS CHAR ,
    pdProductModule AS DECIMAL) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  ASSIGN gdbandObject = pdBandObject
         gcBandCode   = pcBandCode
         gdproductModule = pdProductModule.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

