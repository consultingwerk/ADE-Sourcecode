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
&Scoped-define INTERNAL-TABLES gsm_menu_structure

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  control_padding control_spacing disabled menu_item_obj menu_structure_code~
 menu_structure_description menu_structure_hidden menu_structure_type~
 product_module_obj product_obj system_owned under_development~
 menu_structure_narrative
&Scoped-define ENABLED-FIELDS-IN-gsm_menu_structure control_padding ~
control_spacing disabled menu_item_obj menu_structure_code ~
menu_structure_description menu_structure_hidden menu_structure_type ~
product_module_obj product_obj system_owned under_development ~
menu_structure_narrative 
&Scoped-Define DATA-FIELDS  control_padding control_spacing disabled menu_item_obj menu_structure_code~
 menu_structure_description menu_structure_hidden menu_structure_obj~
 menu_structure_type product_module_obj product_obj system_owned~
 under_development menu_structure_narrative
&Scoped-define DATA-FIELDS-IN-gsm_menu_structure control_padding ~
control_spacing disabled menu_item_obj menu_structure_code ~
menu_structure_description menu_structure_hidden menu_structure_obj ~
menu_structure_type product_module_obj product_obj system_owned ~
under_development menu_structure_narrative 
&Scoped-Define MANDATORY-FIELDS  product_obj
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "af/obj2/gsmmsfullo.i"
&Scoped-define QUERY-STRING-Query-Main FOR EACH gsm_menu_structure NO-LOCK INDEXED-REPOSITION
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH gsm_menu_structure NO-LOCK INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main gsm_menu_structure
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main gsm_menu_structure


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      gsm_menu_structure SCROLLING.
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
         HEIGHT             = 1.95
         WIDTH              = 53.4.
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
     _TblList          = "icfdb.gsm_menu_structure"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST"
     _FldNameList[1]   > icfdb.gsm_menu_structure.control_padding
"control_padding" "control_padding" ? ? "integer" ? ? ? ? ? ? yes ? no 22.4 yes
     _FldNameList[2]   > icfdb.gsm_menu_structure.control_spacing
"control_spacing" "control_spacing" ? ? "integer" ? ? ? ? ? ? yes ? no 22.2 yes
     _FldNameList[3]   > icfdb.gsm_menu_structure.disabled
"disabled" "disabled" ? ? "logical" ? ? ? ? ? ? yes ? no 8.2 yes
     _FldNameList[4]   > icfdb.gsm_menu_structure.menu_item_obj
"menu_item_obj" "menu_item_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 33.6 yes
     _FldNameList[5]   > icfdb.gsm_menu_structure.menu_structure_code
"menu_structure_code" "menu_structure_code" "Band Code*" ? "character" ? ? ? ? ? ? yes ? no 28 yes
     _FldNameList[6]   > icfdb.gsm_menu_structure.menu_structure_description
"menu_structure_description" "menu_structure_description" "Band Description*" ? "character" ? ? ? ? ? ? yes ? no 35 yes
     _FldNameList[7]   > icfdb.gsm_menu_structure.menu_structure_hidden
"menu_structure_hidden" "menu_structure_hidden" "Hide band" ? "logical" ? ? ? ? ? ? yes ? no 23 yes
     _FldNameList[8]   > icfdb.gsm_menu_structure.menu_structure_obj
"menu_structure_obj" "menu_structure_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 33.6 yes
     _FldNameList[9]   > icfdb.gsm_menu_structure.menu_structure_type
"menu_structure_type" "menu_structure_type" "Band Type*" ? "character" ? ? ? ? ? ? yes ? no 18.2 yes
     _FldNameList[10]   > icfdb.gsm_menu_structure.product_module_obj
"product_module_obj" "product_module_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 33.6 yes
     _FldNameList[11]   > icfdb.gsm_menu_structure.product_obj
"product_obj" "product_obj" ? ? "decimal" ? ? ? ? ? ? yes ? yes 29.4 yes
     _FldNameList[12]   > icfdb.gsm_menu_structure.system_owned
"system_owned" "system_owned" "System owned" ? "logical" ? ? ? ? ? ? yes ? no 14.2 yes
     _FldNameList[13]   > icfdb.gsm_menu_structure.under_development
"under_development" "under_development" "Under development" ? "logical" ? ? ? ? ? ? yes ? no 19 yes
     _FldNameList[14]   > icfdb.gsm_menu_structure.menu_structure_narrative
"menu_structure_narrative" "menu_structure_narrative" "Detailed Description" ? "character" ? ? ? ? ? ? yes ? no 500 yes
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE preTransactionValidate dTables  _DB-REQUIRED
PROCEDURE preTransactionValidate :
/*------------------------------------------------------------------------------
  Purpose:     Procedure used to validate RowObjUpd records server-side
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE cMessageList    AS CHARACTER    NO-UNDO.

DEFINE VARIABLE cValueList      AS CHARACTER    NO-UNDO.

FOR EACH RowObjUpd WHERE CAN-DO('A,C,U':U,RowObjUpd.RowMod): 
  IF (RowObjUpd.RowMod = 'U':U AND
    CAN-FIND(FIRST gsm_menu_structure
      WHERE gsm_menu_structure.menu_structure_code = rowObjUpd.menu_structure_code
      AND ROWID(gsm_menu_structure) <> TO-ROWID(ENTRY(1,RowObjUpd.RowIDent))))
  OR (RowObjUpd.RowMod <> 'U':U AND
    CAN-FIND(FIRST gsm_menu_structure
      WHERE gsm_menu_structure.menu_structure_code = rowObjUpd.menu_structure_code))
  THEN
    ASSIGN
      cValueList   = STRING(RowObjUpd.menu_structure_code)
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '8' 'gsm_menu_structure' 'menu_structure_code' "'menu structure code, '" cValueList }.

  /* verify that menu item  specified is valid and of type 'Label' */
  IF RowObjUpd.MENU_item_obj > 0 THEN DO:
    FIND gsm_menu_item WHERE gsm_menu_item.MENU_item_obj = RowObjUpd.MENU_item_obj NO-LOCK NO-ERROR.
    IF NOT AVAILABLE gsm_menu_item OR gsm_menu_item.ITEM_control_type <> "Label" THEN
      ASSIGN
        cValueList   = STRING(RowObjUpd.menu_structure_code)
        cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                      {af/sup2/aferrortxt.i 'AF' '5' 'gsm_menu_structure' 'menu_item_obj' "'menu item object, '" cValueList }.
  END.

  /* Verify the label is unique for the current product module */
  IF (RowObjUpd.RowMod = 'U':U AND
    CAN-FIND(FIRST gsm_menu_structure
      WHERE gsm_menu_structure.menu_structure_description = rowObjUpd.menu_structure_description
       AND (gsm_menu_structure.product_module_obj =   rowObjUpd.product_module_obj OR
            gsm_menu_structure.product_module_obj = 0) 
      AND ROWID(gsm_menu_structure) <> TO-ROWID(ENTRY(1,RowObjUpd.RowIDent))))
  OR (RowObjUpd.RowMod <> 'U':U AND
    CAN-FIND(FIRST gsm_menu_structure
      WHERE gsm_menu_structure.menu_structure_description = rowObjUpd.menu_structure_description
       AND (gsm_menu_structure.product_module_obj =   rowObjUpd.product_module_obj OR
            gsm_menu_structure.product_module_obj = 0)))
  THEN
    ASSIGN
      cValueList   = STRING(RowObjUpd.menu_structure_description)
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '8' 'gsm_menu_structure' 'menu_structure_description' "'band description, '" cValueList }.
END.


ERROR-STATUS:ERROR = NO.
RETURN cMessageList.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

{&DB-REQUIRED-START}

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RowObjectValidate dTables  _DB-REQUIRED
PROCEDURE RowObjectValidate :
/*------------------------------------------------------------------------------
  Purpose:     Procedure used to validate RowObject record client-side
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE cMessageList    AS CHARACTER    NO-UNDO.

DEFINE VARIABLE cValueList      AS CHARACTER    NO-UNDO.

  
  IF LENGTH(RowObject.menu_structure_code) = 0 OR LENGTH(RowObject.menu_structure_code) = ? THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '1' 'gsm_menu_structure' 'menu_structure_code' "'Menu Structure Code'"}.

  IF LENGTH(RowObject.menu_structure_description) = 0 OR LENGTH(RowObject.menu_structure_description) = ? THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '1' 'gsm_menu_structure' 'menu_structure_description' "'Menu Structure Description'"}.

  IF LENGTH(RowObject.menu_structure_type) = 0 OR LENGTH(RowObject.menu_structure_type) = ? THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '1' 'gsm_menu_structure' 'menu_structure_type' "'Menu Structure Type'"}.
  ERROR-STATUS:ERROR = NO.
  RETURN cMessageList.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

