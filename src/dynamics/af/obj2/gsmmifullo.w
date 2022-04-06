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
&Scoped-define INTERNAL-TABLES gsm_menu_item gsc_language

/* Definitions for QUERY Query-Main                                     */
&Scoped-Define ENABLED-FIELDS  disabled disable_rule enable_rule hide_if_disabled hide_rule~
 image1_down_filename image1_insensitive_filename image1_up_filename~
 image2_down_filename image2_insensitive_filename image2_up_filename~
 instance_attribute_obj item_category_obj item_control_style~
 item_control_type item_link item_menu_drop item_select_action~
 item_select_parameter item_select_type item_toolbar_label~
 menu_item_description menu_item_label menu_item_reference object_obj~
 on_create_publish_event product_module_obj propagate_links security_token~
 shortcut_key substitute_text_property system_owned toggle_menu_item~
 tooltip_text under_development image_alternate_rule item_narration~
 source_language_obj
&Scoped-define ENABLED-FIELDS-IN-gsm_menu_item disabled disable_rule ~
enable_rule hide_if_disabled hide_rule image1_down_filename ~
image1_insensitive_filename image1_up_filename image2_down_filename ~
image2_insensitive_filename image2_up_filename instance_attribute_obj ~
item_category_obj item_control_style item_control_type item_link ~
item_menu_drop item_select_action item_select_parameter item_select_type ~
item_toolbar_label menu_item_description menu_item_label ~
menu_item_reference object_obj on_create_publish_event product_module_obj ~
propagate_links security_token shortcut_key substitute_text_property ~
system_owned toggle_menu_item tooltip_text under_development ~
image_alternate_rule item_narration source_language_obj 
&Scoped-Define DATA-FIELDS  disabled disable_rule enable_rule hide_if_disabled hide_rule~
 image1_down_filename image1_insensitive_filename image1_up_filename~
 image2_down_filename image2_insensitive_filename image2_up_filename~
 instance_attribute_obj item_category_obj item_control_style~
 item_control_type item_link item_menu_drop item_select_action~
 item_select_parameter item_select_type item_toolbar_label~
 menu_item_description menu_item_label menu_item_obj menu_item_reference~
 object_obj on_create_publish_event product_module_obj propagate_links~
 security_token shortcut_key substitute_text_property system_owned~
 toggle_menu_item tooltip_text under_development image_alternate_rule~
 item_narration source_language_obj language_code language_name
&Scoped-define DATA-FIELDS-IN-gsm_menu_item disabled disable_rule ~
enable_rule hide_if_disabled hide_rule image1_down_filename ~
image1_insensitive_filename image1_up_filename image2_down_filename ~
image2_insensitive_filename image2_up_filename instance_attribute_obj ~
item_category_obj item_control_style item_control_type item_link ~
item_menu_drop item_select_action item_select_parameter item_select_type ~
item_toolbar_label menu_item_description menu_item_label menu_item_obj ~
menu_item_reference object_obj on_create_publish_event product_module_obj ~
propagate_links security_token shortcut_key substitute_text_property ~
system_owned toggle_menu_item tooltip_text under_development ~
image_alternate_rule item_narration source_language_obj 
&Scoped-define DATA-FIELDS-IN-gsc_language language_code language_name 
&Scoped-Define MANDATORY-FIELDS 
&Scoped-Define APPLICATION-SERVICE 
&Scoped-Define ASSIGN-LIST 
&Scoped-Define DATA-FIELD-DEFS "af/obj2/gsmmifullo.i"
&Scoped-define QUERY-STRING-Query-Main FOR EACH gsm_menu_item NO-LOCK, ~
      FIRST gsc_language WHERE gsc_language.language_obj = gsm_menu_item.source_language_obj NO-LOCK INDEXED-REPOSITION
{&DB-REQUIRED-START}
&Scoped-define OPEN-QUERY-Query-Main OPEN QUERY Query-Main FOR EACH gsm_menu_item NO-LOCK, ~
      FIRST gsc_language WHERE gsc_language.language_obj = gsm_menu_item.source_language_obj NO-LOCK INDEXED-REPOSITION.
{&DB-REQUIRED-END}
&Scoped-define TABLES-IN-QUERY-Query-Main gsm_menu_item gsc_language
&Scoped-define FIRST-TABLE-IN-QUERY-Query-Main gsm_menu_item
&Scoped-define SECOND-TABLE-IN-QUERY-Query-Main gsc_language


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

{&DB-REQUIRED-START}

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Query-Main FOR 
      gsm_menu_item, 
      gsc_language SCROLLING.
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
         HEIGHT             = 1.76
         WIDTH              = 69.
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
     _TblList          = "ICFDB.gsm_menu_item,ICFDB.gsc_language WHERE ICFDB.gsm_menu_item ..."
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST"
     _JoinCode[2]      = "gsc_language.language_obj = gsm_menu_item.source_language_obj"
     _FldNameList[1]   > icfdb.gsm_menu_item.disabled
"disabled" "disabled" ? ? "logical" ? ? ? ? ? ? yes ? no 8.2 yes
     _FldNameList[2]   > icfdb.gsm_menu_item.disable_rule
"disable_rule" "disable_rule" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[3]   > icfdb.gsm_menu_item.enable_rule
"enable_rule" "enable_rule" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[4]   > icfdb.gsm_menu_item.hide_if_disabled
"hide_if_disabled" "hide_if_disabled" ? ? "logical" ? ? ? ? ? ? yes ? no 14.4 yes
     _FldNameList[5]   > icfdb.gsm_menu_item.hide_rule
"hide_rule" "hide_rule" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[6]   > icfdb.gsm_menu_item.image1_down_filename
"image1_down_filename" "image1_down_filename" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[7]   > icfdb.gsm_menu_item.image1_insensitive_filename
"image1_insensitive_filename" "image1_insensitive_filename" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[8]   > icfdb.gsm_menu_item.image1_up_filename
"image1_up_filename" "image1_up_filename" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[9]   > icfdb.gsm_menu_item.image2_down_filename
"image2_down_filename" "image2_down_filename" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[10]   > icfdb.gsm_menu_item.image2_insensitive_filename
"image2_insensitive_filename" "image2_insensitive_filename" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[11]   > icfdb.gsm_menu_item.image2_up_filename
"image2_up_filename" "image2_up_filename" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[12]   > icfdb.gsm_menu_item.instance_attribute_obj
"instance_attribute_obj" "instance_attribute_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 33.6 yes
     _FldNameList[13]   > icfdb.gsm_menu_item.item_category_obj
"item_category_obj" "item_category_obj" ? ? "character" ? ? ? ? ? ? yes ? no 29 yes
     _FldNameList[14]   > icfdb.gsm_menu_item.item_control_style
"item_control_style" "item_control_style" "Style" ? "character" ? ? ? ? ? ? yes ? no 11 yes
     _FldNameList[15]   > icfdb.gsm_menu_item.item_control_type
"item_control_type" "item_control_type" "Item Type*" "X(12)" "character" ? ? ? ? ? ? yes ? no 12 yes
     _FldNameList[16]   > icfdb.gsm_menu_item.item_link
"item_link" "item_link" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[17]   > icfdb.gsm_menu_item.item_menu_drop
"item_menu_drop" "item_menu_drop" "Menu Drop Function" ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[18]   > icfdb.gsm_menu_item.item_select_action
"item_select_action" "item_select_action" ? ? "character" ? ? ? ? ? ? yes ? no 35 yes
     _FldNameList[19]   > icfdb.gsm_menu_item.item_select_parameter
"item_select_parameter" "item_select_parameter" "Parameter" ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[20]   > icfdb.gsm_menu_item.item_select_type
"item_select_type" "item_select_type" "Action Type" ? "character" ? ? ? ? ? ? yes ? no 10.6 yes
     _FldNameList[21]   > icfdb.gsm_menu_item.item_toolbar_label
"item_toolbar_label" "item_toolbar_label" "Toolbar Label" ? "character" ? ? ? ? ? ? yes ? no 28 yes
     _FldNameList[22]   > icfdb.gsm_menu_item.menu_item_description
"menu_item_description" "menu_item_description" "Description*" ? "character" ? ? ? ? ? ? yes ? no 35 yes
     _FldNameList[23]   > icfdb.gsm_menu_item.menu_item_label
"menu_item_label" "menu_item_label" "Menu Label*" ? "character" ? ? ? ? ? ? yes ? no 28 yes
     _FldNameList[24]   > icfdb.gsm_menu_item.menu_item_obj
"menu_item_obj" "menu_item_obj" ? ? "decimal" ? ? ? ? ? ? no ? no 33.6 yes
     _FldNameList[25]   > icfdb.gsm_menu_item.menu_item_reference
"menu_item_reference" "menu_item_reference" "Item Reference*" ? "character" ? ? ? ? ? ? yes ? no 19.4 yes
     _FldNameList[26]   > icfdb.gsm_menu_item.object_obj
"object_obj" "object_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 33.6 yes
     _FldNameList[27]   > icfdb.gsm_menu_item.on_create_publish_event
"on_create_publish_event" "on_create_publish_event" "Create Event" ? "character" ? ? ? ? ? ? yes ? no 35 yes
     _FldNameList[28]   > icfdb.gsm_menu_item.product_module_obj
"product_module_obj" "product_module_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 33.6 yes
     _FldNameList[29]   > icfdb.gsm_menu_item.propagate_links
"propagate_links" "propagate_links" ? ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[30]   > icfdb.gsm_menu_item.security_token
"security_token" "security_token" ? ? "character" ? ? ? ? ? ? yes ? no 28 yes
     _FldNameList[31]   > icfdb.gsm_menu_item.shortcut_key
"shortcut_key" "shortcut_key" ? ? "character" ? ? ? ? ? ? yes ? no 15 yes
     _FldNameList[32]   > icfdb.gsm_menu_item.substitute_text_property
"substitute_text_property" "substitute_text_property" "Label Substitute" ? "character" ? ? ? ? ? ? yes ? no 35 yes
     _FldNameList[33]   > icfdb.gsm_menu_item.system_owned
"system_owned" "system_owned" ? ? "logical" ? ? ? ? ? ? yes ? no 13.8 yes
     _FldNameList[34]   > icfdb.gsm_menu_item.toggle_menu_item
"toggle_menu_item" "toggle_menu_item" ? ? "logical" ? ? ? ? ? ? yes ? no 17.2 yes
     _FldNameList[35]   > icfdb.gsm_menu_item.tooltip_text
"tooltip_text" "tooltip_text" "Tooltip" ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[36]   > icfdb.gsm_menu_item.under_development
"under_development" "under_development" "Under Devel." ? "logical" ? ? ? ? ? ? yes ? no 18.6 yes
     _FldNameList[37]   > icfdb.gsm_menu_item.image_alternate_rule
"image_alternate_rule" "image_alternate_rule" "Alternate Image rule" ? "character" ? ? ? ? ? ? yes ? no 70 yes
     _FldNameList[38]   > icfdb.gsm_menu_item.item_narration
"item_narration" "item_narration" ? ? "character" ? ? ? ? ? ? yes ? no 500 yes
     _FldNameList[39]   > ICFDB.gsm_menu_item.source_language_obj
"source_language_obj" "source_language_obj" ? ? "decimal" ? ? ? ? ? ? yes ? no 33.6 yes
     _FldNameList[40]   > ICFDB.gsc_language.language_code
"language_code" "language_code" ? ? "character" ? ? ? ? ? ? no ? no 15.2 yes
     _FldNameList[41]   > ICFDB.gsc_language.language_name
"language_name" "language_name" ? ? "character" ? ? ? ? ? ? no ? no 35 yes
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
 DEFINE VARIABLE dLoginCompanyObj AS DECIMAL    NO-UNDO.

 /* Populate the menu_item_reference */
  FOR EACH rowObjUpd WHERE CAN-DO("A,C,U":U, rowObjUpd.RowMod):
    IF rowObjUpd.menu_item_reference = "AutoGenerate":U THEN DO:
      dLoginCompanyObj = DECIMAL(DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                      INPUT "CurrentOrganisationObj":U,
                                                      INPUT NO)) NO-ERROR.
      
      ASSIGN rowObjUpd.menu_item_reference = DYNAMIC-FUNCTION("getNextSequenceValue":U IN gshGenManager,
                                                              INPUT dLoginCompanyObj,
                                                              INPUT "GSMMI":U,
                                                              INPUT "MNU"
                                                              ).
    END.    
  
    /* For control type, set values to blank for non applicable fields*/
    IF RowObjUpd.item_control_type <> "Action":U AND RowObjUpd.item_control_type <> "" THEN
    DO:
       IF RowObjUpd.item_control_type ="PlaceHolder":U THEN 
       DO:
         IF LOOKUP("Item_toolbar_label":U,RowObjUpd.ChangedFields) = 0 THEN
            RowObjUpd.ChangedFields = RowObjUpd.ChangedFields  + ",Item_toolbar_label":U.
         IF LOOKUP("Item_tooltip_text":U,RowObjUpd.ChangedFields) = 0  THEN
            RowObjUpd.ChangedFields = RowObjUpd.ChangedFields  + ",Item_tooltip_text":U.
       END.
  
       IF LOOKUP("Item_select_type":U,RowObjUpd.ChangedFields) = 0 THEN
          RowObjUpd.ChangedFields = RowObjUpd.ChangedFields +  "Item_select_type":U.
       IF LOOKUP("Item_select_action":U,RowObjUpd.ChangedFields) = 0 THEN
          RowObjUpd.ChangedFields = RowObjUpd.ChangedFields  + ",Item_select_action":U.
       IF LOOKUP("Item_select_parameter":U,RowObjUpd.ChangedFields) = 0 THEN
          RowObjUpd.ChangedFields = RowObjUpd.ChangedFields  + ",Item_select_parameter":U.
       IF LOOKUP("Item_control_style":U,RowObjUpd.ChangedFields) = 0 THEN
          RowObjUpd.ChangedFields = RowObjUpd.ChangedFields  + ",Item_control_style":U.
       IF LOOKUP("object_obj":U,RowObjUpd.ChangedFields) = 0 THEN
          RowObjUpd.ChangedFields = RowObjUpd.ChangedFields  + ",object_obj":U.
       IF LOOKUP("instance_attribute_obj":U,RowObjUpd.ChangedFields) = 0 THEN
          RowObjUpd.ChangedFields = RowObjUpd.ChangedFields  + ",instance_attribute_obj":U.
       IF LOOKUP("image1_up_filename":U,RowObjUpd.ChangedFields) = 0 THEN
          RowObjUpd.ChangedFields = RowObjUpd.ChangedFields  + ",image1_up_filename":U.
       IF LOOKUP("image2_up_filename":U,RowObjUpd.ChangedFields) = 0 THEN
          RowObjUpd.ChangedFields = RowObjUpd.ChangedFields  + ",image2_up_filename":U.
  
       IF RowObjUpd.item_control_type ="Separator":U THEN 
       DO:
         IF LOOKUP("security_token":U,RowObjUpd.ChangedFields) = 0 THEN
            RowObjUpd.ChangedFields = RowObjUpd.ChangedFields  + ",security_token":U.
         IF LOOKUP("item_link":U,RowObjUpd.ChangedFields) = 0 THEN
            RowObjUpd.ChangedFields = RowObjUpd.ChangedFields  + ",item_link":U.
         IF LOOKUP("on_create_publish_event":U,RowObjUpd.ChangedFields) = 0  THEN
            RowObjUpd.ChangedFields = RowObjUpd.ChangedFields  + ",on_create_publish_event":U.
         IF LOOKUP("item_menu_drop":U,RowObjUpd.ChangedFields) = 0 THEN
            RowObjUpd.ChangedFields = RowObjUpd.ChangedFields  + ",item_menu_drop":U.
         IF LOOKUP("Substitute_text_property":U,RowObjUpd.ChangedFields) = 0  THEN
            RowObjUpd.ChangedFields = RowObjUpd.ChangedFields  + ",Substitute_text_property":U.
         IF LOOKUP("enable_rule":U,RowObjUpd.ChangedFields) = 0  THEN
            RowObjUpd.ChangedFields = RowObjUpd.ChangedFields  + ",enable_rule":U.
         IF LOOKUP("hide_rule":U,RowObjUpd.ChangedFields) = 0  THEN
            RowObjUpd.ChangedFields = RowObjUpd.ChangedFields  + ",hide_rule":U.
         IF LOOKUP("image_alternate_rule":U,RowObjUpd.ChangedFields) = 0  THEN
            RowObjUpd.ChangedFields = RowObjUpd.ChangedFields  + ",image_alternate_rule":U.
       END.
  
  
       ASSIGN  RowObjUpd.Item_select_type       = ""    
               RowObjUpd.Item_select_action     = ""    
               RowObjUpd.Item_select_parameter  = ""    
               RowObjUpd.item_control_style     = "" 
               RowObjUpd.item_toolbar_label     = ""
               RowObjUpd.tooltip_text           = ""
               RowObjUpd.ITEM_control_style     = ""
               RowObjUpd.OBJECT_obj             = 0
               RowObjUpd.instance_attribute_obj = 0
               RowObjUpd.image1_up_filename     = IF RowObjUpd.item_control_type = "Label":U
                                                  THEN RowObjUpd.image1_up_filename
                                                  ELSE ""
               RowObjUpd.image2_up_filename     = IF RowObjUpd.item_control_type = "Label":U
                                                  THEN RowObjUpd.image2_up_filename
                                                  ELSE ""
               NO-ERROR.
       IF RowObjUpd.item_control_type = "Separator":U  THEN
         ASSIGN  RowObjUpd.Substitute_text_property = "" 
                 RowObjUpd.Item_link                = "" 
                 RowObjUpd.item_control_style       = "" 
                 RowObjUpd.enable_rule              = ""
                 RowObjUpd.Hide_rule                = ""
                 RowObjUpd.IMAGE_alternate          = ""
               NO-ERROR.   
    END. /* End item_control_type <> "Action" */
  
    IF RowObjUpd.ITEM_select_type = "LAUNCH":U THEN DO:
       IF LOOKUP("item_select_action":U,RowObjUpd.ChangedFields) = 0  THEN
            RowObjUpd.ChangedFields = RowObjUpd.ChangedFields  + ",item_select_action":U.
       IF LOOKUP("item_select_parameter":U,RowObjUpd.ChangedFields) = 0  THEN
            RowObjUpd.ChangedFields = RowObjUpd.ChangedFields  + ",item_select_parameter":U.
        
       ASSIGN RowObjUpd.item_select_action   = ""
              RowObjUpd.item_select_parameter = "".
    END.
    ELSE DO:
       IF LOOKUP("object_obj":U,RowObjUpd.ChangedFields) = 0 THEN
          RowObjUpd.ChangedFields = RowObjUpd.ChangedFields  + ",object_obj":U.
       IF LOOKUP("instance_attribute_obj":U,RowObjUpd.ChangedFields) = 0 THEN
          RowObjUpd.ChangedFields = RowObjUpd.ChangedFields  + ",instance_attribute_obj":U.
       IF RowObjUpd.ITEM_select_type = "PROPERTY":U THEN
         IF LOOKUP("Item_select_parameter":U,RowObjUpd.ChangedFields) = 0 THEN
          RowObjUpd.ChangedFields = RowObjUpd.ChangedFields  + ",Item_select_parameter":U.
       
       ASSIGN RowObjUpd.OBJECT_obj             = 0
              RowObjUpd.instance_attribute_obj = 0
              RowObjUpd.Item_select_parameter  = IF RowObjUpd.ITEM_select_type = "PROPERTY":U 
                                                 THEN ""
                                                 ELSE RowObjUpd.Item_select_parameter.
  
    END.
  END. 
 
  
  
    
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
    CAN-FIND(FIRST gsm_menu_item
      WHERE gsm_menu_item.menu_item_reference = rowObjUpd.menu_item_reference
      AND ROWID(gsm_menu_item) <> TO-ROWID(ENTRY(1,RowObjUpd.RowIDent))))
  OR (RowObjUpd.RowMod <> 'U':U AND
    CAN-FIND(FIRST gsm_menu_item
      WHERE gsm_menu_item.menu_item_reference = rowObjUpd.menu_item_reference))
  THEN
    ASSIGN
      cValueList   = STRING(RowObjUpd.menu_item_reference)
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '8' 'gsm_menu_item' '' "'Item Reference, '" cValueList }.
  
  /* verify the category entered is valid */
   
  IF rowObjUpd.item_category_obj > 0  OR rowObjUpd.item_category_obj = ? THEN
  DO:
     IF NOT CAN-FIND(FIRST gsc_item_category
                     WHERE gsc_item_category.ITEM_category_obj =  rowObjUpd.ITEM_category_obj)  THEN
      ASSIGN
        cValueList   = STRING(RowObjUpd.ITEM_category_obj)
        cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                      {af/sup2/aferrortxt.i 'AF' '5' 'gsm_menu_item' '' "'item_category_obj, '" cValueList }.
  END.
    /* verify product module is valid */
  IF rowObjUpd.product_module_obj > 0 THEN
  DO:
     IF NOT CAN-FIND(FIRST gsc_product_module
                     WHERE gsc_product_module.product_module_obj = rowObjUpd.product_module_obj)  THEN
      ASSIGN
        cValueList   = STRING(RowObjUpd.ITEM_category_obj)
        cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                      {af/sup2/aferrortxt.i 'AF' '5' 'gsm_menu_item' '' "'product_module_obj, '" cValueList }.
  END.
  
    /* verify Object File is valid */
  IF rowObjUpd.object_obj > 0  THEN
  DO:
     IF NOT CAN-FIND(FIRST ryc_smartobject
                     WHERE ryc_smartobject.smartobject_obj = rowObjUpd.object_obj)  THEN
      ASSIGN
        cValueList   = STRING(RowObjUpd.ITEM_category_obj)
        cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                      {af/sup2/aferrortxt.i 'AF' '5' 'gsm_menu_item' '' "'object_obj, '" cValueList }.
  END.

  /* verify Object File Instance is valid */
  IF rowObjUpd.instance_attribute_obj > 0 THEN
  DO:
     IF NOT CAN-FIND(FIRST gsc_instance_attribute
                     WHERE gsc_instance_attribute.instance_attribute_obj = rowObjUpd.instance_attribute_obj)  THEN
      ASSIGN
        cValueList   = STRING(RowObjUpd.ITEM_category_obj)
        cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                      {af/sup2/aferrortxt.i 'AF' '5' 'gsm_menu_item' '' "'instance_attribute_obj, '" cValueList }.
  END.


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


 
  IF LENGTH(RowObject.menu_item_reference) = 0 OR LENGTH(RowObject.menu_item_reference) = ? THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '1' 'gsm_menu_item' 'menu_item_reference' "'Item Reference'"}.

  IF LENGTH(RowObject.Item_control_type) = 0 OR LENGTH(RowObject.Item_control_type) = ? THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '1' 'gsm_menu_item' 'Item_control_type' "'Item Type'"}.

  
  IF LENGTH(RowObject.menu_item_label) = 0 OR LENGTH(RowObject.menu_item_label) = ? THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '1' 'gsm_menu_item' 'menu_item_label' "'Menu Label'"}.

  IF LENGTH(RowObject.menu_item_description) = 0 OR LENGTH(RowObject.menu_item_description) = ? THEN
    ASSIGN
      cMessageList = cMessageList + (IF NUM-ENTRIES(cMessageList,CHR(3)) > 0 THEN CHR(3) ELSE '':U) + 
                    {af/sup2/aferrortxt.i 'AF' '1' 'gsm_menu_item' 'menu_item_description' "'Item Description'"}.


  ERROR-STATUS:ERROR = NO.
  RETURN cMessageList.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

{&DB-REQUIRED-END}

