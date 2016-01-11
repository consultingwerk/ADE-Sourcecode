&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 

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


DEFINE VARIABLE xcObjectType AS CHARACTER  NO-UNDO
    INIT 'SmartToolbar'.
DEFINE VARIABLE xiError141 AS INTEGER INIT 188 NO-UNDO.
DEFINE VARIABLE gcToolbarfile  AS CHARACTER  NO-UNDO INIT 
    'db/icf/dfd/toolbar.dat'.

DEFINE BUFFER bcontainer  FOR ryc_smartobject.
DEFINE BUFFER bMenustruct FOR gsm_menu_structure.
DEFINE BUFFER bAttrValue  FOR ryc_attribute_value. 

DEFINE BUFFER binstance   FOR ryc_object_instance.

DEFINE STREAM convlog.

DEFINE TEMP-TABLE ttToolbar
    FIELD ObjectName  AS CHAR
    FIELD bandlist    AS CHAR 
    FIELD instances   AS INT
    INDEX bands bandlist.

DEFINE TEMP-TABLE ttBand
  FIELD bandname AS CHAR.

DEFINE TEMP-TABLE ttMenu 
   FIELD objectname AS CHAR 
   FIELD menutype   AS CHAR
   FIELD menulabel  AS CHAR
   FIELD parentlabel AS CHAR
   FIELD CODE       AS CHAR 
   FIELD sequence   AS INT
   FIELD parentcode AS CHAR
   FIELD bandlabel  AS CHAR
   FIELD TYPE       AS CHAR
   FIELD reference  AS CHAR
   FIELD action     AS CHAR
   FIELD link       AS CHAR
   FIELD childlist  AS CHAR
   FIELD childbands AS CHAR
   FIELD Changed    AS LOG
   FIELD converted  AS LOG
   FIELD DYNAMIC AS LOG
  INDEX MENU  CODE  
  INDEX MENU1  CODE converted  
  INDEX MENU2 AS priMARY objectname parentlabel sequence.

DEFINE TEMP-TABLE tOldgsm_menu_structure
 FIELD menu_structure_obj AS DECIMAL FORMAT ">>>>>>>>>>>>>>>>>9.999999" LABEL  "Menu Structure Obj" DECIMALS 6 INITIAL 0
 FIELD product_obj AS DECIMAL FORMAT ">>>>>>>>>>>>>>>>>9.999999" LABEL  "Product Obj" DECIMALS 6 INITIAL 0
 FIELD product_module_obj AS DECIMAL FORMAT ">>>>>>>>>>>>>>>>>9.999999" LABEL  "Product Module Obj" DECIMALS 6 INITIAL 0
 FIELD menu_structure_code AS CHARACTER FORMAT "X(10)" LABEL  "Menu Structure Code"
 FIELD menu_structure_description AS CHARACTER FORMAT "X(35)" LABEL  "Menu Structure Description"
 FIELD disabled AS LOGICAL FORMAT "YES/NO" LABEL  "Disabled" INITIAL NO
 FIELD system_owned AS LOGICAL FORMAT "YES/NO" LABEL  "System Owned" INITIAL YES
 FIELD under_development AS LOGICAL FORMAT "YES/NO" LABEL  "Under Development" INITIAL NO
 INDEX XAK1gsm_menu_structure AS  UNIQUE  product_obj product_module_obj menu_structure_code 
 INDEX XIE1gsm_menu_structure menu_structure_code 
 INDEX XIE2gsm_menu_structure menu_structure_description 
 INDEX XPKgsm_menu_structure AS  PRIMARY UNIQUE  menu_structure_obj
 .

DEFINE TEMP-TABLE tOldgsm_menu_item
 FIELD menu_item_obj AS DECIMAL FORMAT ">>>>>>>>>>>>>>>>>9.999999" LABEL  "Menu Item Obj" DECIMALS 6 INITIAL 0
 FIELD menu_structure_obj AS DECIMAL FORMAT ">>>>>>>>>>>>>>>>>9.999999" LABEL  "Menu Structure Obj" DECIMALS 6 INITIAL 0
 FIELD parent_menu_item_obj AS DECIMAL FORMAT ">>>>>>>>>>>>>>>>>9.999999" LABEL  "Parent Menu Item Obj" DECIMALS 6 INITIAL 0
 FIELD menu_item_sequence AS INTEGER FORMAT "->9" LABEL  "Menu Item Sequence" INITIAL 0
 FIELD menu_item_label AS CHARACTER FORMAT "X(28)" LABEL  "Menu Item Label"
 FIELD menu_item_description AS CHARACTER FORMAT "X(35)" LABEL  "Menu Item Description"
 FIELD sub_menu_item AS LOGICAL FORMAT "YES/NO" LABEL  "Sub Menu Item" INITIAL NO
 FIELD ruler_menu_item AS LOGICAL FORMAT "YES/NO" LABEL  "Ruler Menu Item" INITIAL NO
 FIELD toggle_menu_item AS LOGICAL FORMAT "YES/NO" LABEL  "Toggle Menu Item" INITIAL NO
 FIELD object_obj AS DECIMAL FORMAT ">>>>>>>>>>>>>>>>>9.999999" LABEL  "Object Obj" DECIMALS 6 INITIAL 0
 FIELD toolbar_image_sequence AS INTEGER FORMAT "->9" LABEL  "Toolbar Image Sequence" INITIAL 0
 FIELD toolbar_image_filename AS CHARACTER FORMAT "X(70)" LABEL  "Toolbar Image Filename"
 FIELD tooltip_text AS CHARACTER FORMAT "X(70)" LABEL  "Tooltip Text"
 FIELD shortcut_key AS CHARACTER FORMAT "X(15)" LABEL  "Shortcut Key"
 FIELD hide_if_disabled AS LOGICAL FORMAT "YES/NO" LABEL  "Hide if Disabled" INITIAL NO
 FIELD disabled AS LOGICAL FORMAT "YES/NO" LABEL  "Disabled" INITIAL NO
 FIELD instance_attribute_obj AS DECIMAL FORMAT ">>>>>>>>>>>>>>>>>9.999999" LABEL  "Instance Attribute Obj" DECIMALS 6 INITIAL 0
 FIELD system_owned AS LOGICAL FORMAT "YES/NO" LABEL  "System Owned" INITIAL YES
 FIELD under_development AS LOGICAL FORMAT "YES/NO" LABEL  "Under Development" INITIAL NO
 FIELD menu_item_reference AS CHARACTER FORMAT "X(15)" LABEL  "Menu Item Reference"
 FIELD publish_link_list AS CHARACTER FORMAT "X(70)" LABEL  "Publish Link List"
 FIELD publish_event AS CHARACTER FORMAT "X(35)" LABEL  "Publish Event"
 FIELD publish_parameter AS CHARACTER FORMAT "X(70)" LABEL  "Publish Parameter"
 FIELD propagate_links AS CHARACTER FORMAT "X(70)" LABEL  "Propagate Links"
 INDEX XAK1gsm_menu_item AS  UNIQUE  menu_structure_obj parent_menu_item_obj menu_item_sequence 
 INDEX XAK2gsm_menu_item AS  UNIQUE  menu_item_reference 
 INDEX XIE2gsm_menu_item menu_structure_obj toolbar_image_sequence menu_item_sequence 
 INDEX XIE3gsm_menu_item menu_structure_obj menu_item_label 
 INDEX XIE4gsm_menu_item menu_structure_obj menu_item_description 
 INDEX XIE5gsm_menu_item object_obj 
 INDEX XIE6gsm_menu_item instance_attribute_obj 
 INDEX XPKgsm_menu_item AS  PRIMARY UNIQUE  menu_item_obj
 .

DEFINE TEMP-TABLE tOldgsm_object_menu_structure
 FIELD object_obj AS DECIMAL FORMAT ">>>>>>>>>>>>>>>>>9.999999" LABEL  "Object Obj" DECIMALS 6 INITIAL 0
 FIELD menu_structure_obj AS DECIMAL FORMAT ">>>>>>>>>>>>>>>>>9.999999" LABEL  "Menu Structure Obj" DECIMALS 6 INITIAL 0
 FIELD instance_attribute_obj AS DECIMAL FORMAT ">>>>>>>>>>>>>>>>>9.999999" LABEL  "Instance Attribute Obj" DECIMALS 6 INITIAL 0
 FIELD object_menu_structure_obj AS DECIMAL FORMAT ">>>>>>>>>>>>>>>>>9.999999" LABEL  "Object Menu Structure Obj" DECIMALS 6 INITIAL 0
 INDEX XAK1gsm_object_menu_structure AS  UNIQUE  menu_structure_obj object_obj instance_attribute_obj 
 INDEX XAK2gsm_object_menu_structure AS  UNIQUE  object_menu_structure_obj 
 INDEX XIE1gsm_object_menu_structure instance_attribute_obj 
 INDEX XPKgsm_object_menu_structure AS  PRIMARY UNIQUE  object_obj menu_structure_obj instance_attribute_obj
 .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS gcToolbarName gdModule gcFile gcLog gcLoad ~
glTrans gcLogFile buStart 
&Scoped-Define DISPLAYED-OBJECTS gcToolbarName gcFile gcLog gcLoad glTrans ~
gcLogFile 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD checkMenu C-Win 
FUNCTION checkMenu RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createItemCategory C-Win 
FUNCTION createItemCategory RETURNS DECIMAL
  ( pcNameOrLink AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD deleteMenuStructure C-Win 
FUNCTION deleteMenuStructure RETURNS LOGICAL
  ( pccode AS char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD dynamicItem C-Win 
FUNCTION dynamicItem RETURNS CHAR
  (pcRef AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD labelItem C-Win 
FUNCTION labelItem RETURNS DECIMAL
  (pcLabel AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buStart 
     LABEL "Start &Conversion" 
     SIZE 19.8 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE gdModule AS DECIMAL FORMAT "->,>>>,>>>,>>9.999999":U INITIAL 0 
     LABEL "Product module" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1",0.00
     DROP-DOWN-LIST
     SIZE 45.6 BY 1 TOOLTIP "Select Product module for the new toolbar objects" NO-UNDO.

DEFINE VARIABLE gcLog AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL LARGE
     SIZE 126.4 BY 14.1
     FONT 0 NO-UNDO.

DEFINE VARIABLE gcFile AS CHARACTER FORMAT "X(256)":U 
     LABEL "File label" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 TOOLTIP "Label used as submenu label for File (default submenu)" NO-UNDO.

DEFINE VARIABLE gcLoad AS CHARACTER FORMAT "X(256)":U INITIAL "icf/db/icf/dump" 
     LABEL "Load from directory" 
     VIEW-AS FILL-IN 
     SIZE 37.2 BY 1 TOOLTIP "Directory with preconversion dump files; gsmms.d, gsmmi.d and gsmom.d" NO-UNDO.

DEFINE VARIABLE gcLogFile AS CHARACTER FORMAT "X(256)":U INITIAL "convert01-02.log" 
     LABEL "Log file" 
     VIEW-AS FILL-IN 
     SIZE 37.2 BY 1 TOOLTIP "Output log to this file" NO-UNDO.

DEFINE VARIABLE gcToolbarName AS CHARACTER FORMAT "X(256)":U INITIAL "Toolbar" 
     LABEL "Toolbar name" 
     VIEW-AS FILL-IN 
     SIZE 14.4 BY 1 TOOLTIP "Name of new toolbars objects created by the conversion (Number will be added)" NO-UNDO.

DEFINE VARIABLE glTrans AS LOGICAL INITIAL yes 
     LABEL "One transaction" 
     VIEW-AS TOGGLE-BOX
     SIZE 19.2 BY .81 TOOLTIP "Check to do all in one transaction. Uncheck only if system limitations." NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     gcToolbarName AT ROW 1.29 COL 18.2 COLON-ALIGNED
     gdModule AT ROW 2.48 COL 18.2 COLON-ALIGNED
     gcFile AT ROW 3.62 COL 18.2 COLON-ALIGNED
     gcLog AT ROW 4.71 COL 20.2 NO-LABEL
     gcLoad AT ROW 1.29 COL 85.2 COLON-ALIGNED
     glTrans AT ROW 2.57 COL 87.2
     gcLogFile AT ROW 3.62 COL 85.2 COLON-ALIGNED
     buStart AT ROW 1.29 COL 126.2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 147.4 BY 18.43.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Toolbar & Menu Conversion"
         HEIGHT             = 18.43
         WIDTH              = 147.2
         MAX-HEIGHT         = 20.91
         MAX-WIDTH          = 157.6
         VIRTUAL-HEIGHT     = 20.91
         VIRTUAL-WIDTH      = 157.6
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   L-To-R,COLUMNS                                                       */
ASSIGN 
       gcLog:RETURN-INSERTED IN FRAME DEFAULT-FRAME  = TRUE
       gcLog:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

/* SETTINGS FOR COMBO-BOX gdModule IN FRAME DEFAULT-FRAME
   NO-DISPLAY                                                           */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Toolbar  Menu Conversion */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Toolbar  Menu Conversion */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buStart
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buStart C-Win
ON CHOOSE OF buStart IN FRAME DEFAULT-FRAME /* Start Conversion */
DO:
  RUN startConvert.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

ON DELETE OF gsm_menu_item OVERRIDE DO: END.
ON DELETE OF gsm_menu_structure OVERRIDE DO: END.

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  
  FIND FIRST ryc_band WHERE ryc_band.band_name = 'astraFile' no-error.  
  ASSIGN gcFile = ryc_band.band_submenu_label. 

  gdModule:DELIMITER = CHR(1).
  gdModule:LIST-ITEM-PAIRS = ?.
  
  FOR EACH gsc_product_module NO-LOCK:
     gdModule:ADD-LAST(gsc_product_module.product_module_code + ' ' +
                       gsc_product_module.product_module_description,
                       gsc_product_module.product_module_obj).
  END.

  RUN enable_UI.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildMenubars C-Win 
PROCEDURE buildMenubars :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE BUFFER bttMenu FOR ttMenu.

DEFINE BUFFER bstruct      FOR gsm_menu_structure.
DEFINE BUFFER banyStruct   FOR gsm_menu_structure.
DEFINE BUFFER bChildStruct FOR gsm_menu_structure.

DEFINE VARIABLE cCode  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iseq   AS INTEGER    NO-UNDO.
DEFINE VARIABLE iSort  AS INTEGER    NO-UNDO.

RUN showStep('Building menubars').
RUN showStep('<underline>').

FOR EACH ttMenu WHERE ttMenu.TYPE  = 'menubar'
  BY ttMenu.objectname:
 
  cCode = REPLACE(ttMenu.Objectname,gctoolbarname,'MenuBar').
          
  iSeq = 1. 
  DO WHILE TRUE:
    IF CAN-FIND(banyStruct WHERE bAnyStruct.MENU_structure_code = cCode) THEN
      ASSIGN
        iSeq  = iSeq + 1
        cCode = 'Menubar' + STRING(iSeq).
    ELSE LEAVE.
  END.
  CREATE gsm_menu_structure. 
  ASSIGN
    gsm_menu_structure.menu_structure_code        = cCode 
    gsm_menu_structure.menu_structure_description = cCode                                                      
    gsm_menu_structure.menu_structure_type        = 'MenuBar'
    ttMenu.CODE                                   = cCode. 

  FIND gsc_object WHERE gsc_object.OBJECT_filename = ttmenu.objectname. 
  FOR EACH gsm_toolbar_menu_structure OF gsc_object EXCLUSIVE:
    
    FIND bStruct OF gsm_toolbar_menu_structure NO-ERROR.
    IF bStruct.menu_structure_type = 'subMenu' THEN
      DELETE gsm_toolbar_menu_structure.
  END.

  CREATE gsm_toolbar_menu_structure.
  ASSIGN 
    gsm_toolbar_menu_structure.object_obj               = gsc_object.OBJECT_obj 
    gsm_toolbar_menu_structure.MENU_structure_obj       = gsm_menu_structure.MENU_structure_obj
    gsm_toolbar_menu_structure.MENU_structure_sequence  = 0
    gsm_toolbar_menu_structure.MENU_structure_alignment = 'Left'.

  RUN showstep('Created new menu structure ' 
                     + gsm_menu_structure.menu_structure_code 
                     + ' of type MenuBar for toolbar ' 
                     + gsc_object.OBJECT_filename ). 
  iSort = 0.
  FOR EACH bttMenu WHERE bttMenu.objectname  = ttMenu.objectname
                   AND   bttMenu.parentlabel = ttMenu.menulabel                       
                   BY    bttMenu.sequence :
    CREATE gsm_menu_structure_item.
    ASSIGN
      iSort = iSort + 1
      gsm_menu_structure_item.menu_item_sequence = iSort 
      gsm_menu_structure_item.MENU_structure_obj = gsm_menu_structure.MENU_structure_obj. 
    
    IF bttMenu.TYPE = 'action' THEN
    DO:
      
      FIND gsm_menu_item NO-LOCK
           WHERE gsm_menu_item.MENU_item_reference = bttMenu.reference.
      
      gsm_menu_structure_item.MENU_item_obj = gsm_menu_item.MENU_item_obj. 
      
      RUN showstep('Added item ' 
                    + STRING(gsm_menu_structure_item.menu_item_sequence)
                    + ' ' + gsm_menu_item.MENU_item_reference
                    + ' to menu structure '
                    +  gsm_menu_structure.MENU_structure_code).
    END.
    ELSE DO: 
      FIND bChildStruct NO-LOCK 
          WHERE bChildStruct.MENU_structure_code = bttMenu.CODE no-error.
      IF NOT AVAIL bChildStruct THEN
         MESSAGE 'code' bttMenu.CODE SKIP
                 'type'  bttMenu.TYPE     SKIP
                 'label' bttMenu.menulabel
          VIEW-AS ALERT-BOX.
    ELSE
      ASSIGN
         gsm_menu_structure_item.MENU_item_obj 
                                         = bChildStruct.MENU_item_obj
         gsm_menu_structure_item.child_MENU_structure_obj 
                                        = bChildStruct.MENU_structure_obj
         . 
      RUN showstep('Added item ' 
                            + STRING(gsm_menu_structure_item.menu_item_sequence)
                            + ' submenu ' 
                            + bChildStruct.MENU_structure_code  
                            + ' to menu structure '
                            +  gsm_menu_structure.MENU_structure_code).

    END.
  END.

  ASSIGN
    ttMenu.CODE      = cCode
    ttmenu.converted = TRUE.

END.

RUN showstep('').


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildMenus C-Win 
PROCEDURE buildMenus :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcobject     AS CHAR.
  DEFINE INPUT PARAMETER pcMenuLabel  AS CHAR.
  DEFINE input PARAMETER piLevel      AS INTEGER  NO-UNDO.


  FOR EACH ttMenu 
      WHERE ttMenu.objectname = pcObject         
      AND  ttMenu.parentlabel = pcMenulabel.

    RUN showStep(' ' + fill('-',pilevel) 
                 + ' '
                 + (IF NOT ttMenu.DYNAMIC 
                    THEN ttMenu.MENUlabel 
                    ELSE 'Dynamic')
                  + ' ' 
                  + string(ttMenu.sequence) 
                       + ' '
                 + ttMenu.CODE  
                 + (IF ttMenu.menulabel = gcFile 
                    THEN "(" + ttMenu.childbands + ")" ELSE ''  )
                    
                 + ' ' + ttMenu.action 
              
                 ). 
    
    IF NOT ttMenu.dynamic THEN
      RUN buildMenus(pcObject ,ttMenu.MENUlabel,piLevel + 1).
    
    
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildMenuStructures C-Win 
PROCEDURE buildMenuStructures :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cParent AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cLabel  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lRule   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iSequence  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cExit      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cExitLabel AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cList      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lDelete    AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cEntry     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iCount     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE dItemObj   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lChanged   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE iStruct    AS INTEGER    NO-UNDO.

  DEFINE BUFFER bttMenu  FOR  ttMenu. 
      
  DEFINE BUFFER bMenustruct FOR gsm_menu_structure. 
  DEFINE BUFFER btoolbar    FOR gsm_toolbar_menu_structure.

FOR EACH ttToolbar,
    EACH gsc_Object NO-LOCK 
    WHERE gsc_Object.OBJECT_FILENAME = ttToolbar.objectname
BY ttToolbar.objectname:
 /*   
 RUN showstep(gsc_Object.OBJECT_FILENAME).
 */  
 CREATE ttMenu.
 ASSIGN 
     ttMenu.objectname = gsc_Object.OBJECT_FILENAME 
     ttMenu.CODE       = ttMenu.objectname + "-menubar"
     ttMenu.TYPE       = 'Menubar'
     ttMenu.menulabel  = 'Menubar'. 

 FOR EACH gsm_toolbar_menu_structure NO-LOCK OF gsc_object ,
     EACH gsm_menu_structure NO-LOCK OF  gsm_toolbar_menu_structure
     WHERE gsm_menu_structure.MENU_structure_type <> 'toolbar':
    
   FIND ryc_band WHERE ryc_band.band_name = gsm_menu_structure.MENU_structure_code
        NO-LOCK NO-ERROR.
   IF NOT AVAIL ryc_band 
   AND gsm_menu_structure.MENU_structure_code MATCHES '*submenu' THEN
       FIND ryc_band WHERE ryc_band.band_name = 
              substr(gsm_menu_structure.MENU_structure_code,1,
                     index(gsm_menu_structure.MENU_structure_code,'submenu') - 1)
         NO-LOCK NO-ERROR.
   RELEASE bttMenu.
   cParent = ''. 
   IF ryc_band.band_submenu_label = 'Rule' THEN
   DO:
     cLabel = gcFile. 
     cParent = gcFile.
     FIND FIRST ttMenu WHERE ttMenu.objectname = ttToolbar.objectname 
                       AND   ttMenu.menulabel  = gcFile NO-ERROR.  
   END.
   ELSE DO:
      ASSIGN
        cLabel = (IF NUM-ENTRIES(ryc_band.band_submenu_label) = 2 
                  THEN ENTRY(2,ryc_band.band_submenu_label)
                  ELSE ryc_band.band_submenu_label)
        cLabel =  IF REPLACE(cLabel,'&','') = gcFile
                  THEN gcFile 
                  ELSE cLabel
        cParent = cLabel.                       
     FIND first ttMenu 
          WHERE ttMenu.objectname = gsc_Object.OBJECT_FILENAME
          AND   ttMenu.menulabel  = cLabel NO-ERROR.

   END.
   IF AVAIL ttMenu THEN
   DO:
     ASSIGN ttMenu.Childbands = ttMenu.Childbands 
                       + "," + 
                      gsm_menu_structure.MENU_structure_code.
   END.
   ELSE DO:
     IF ryc_band.band_submenu_label = 'Rule' THEN
     DO:
       CREATE ttMenu.
       ASSIGN 
          ttMenu.CODE        = 'DummyFile'
          ttMenu.childbands  = gsm_menu_structure.MENU_structure_code
          ttMenu.bandlabel   = ryc_band.band_submenu_label
          ttMenu.menulabel   = gcFile
          ttMenu.parentlabel = 'menubar'
          ttMenu.objectname  = ttToolbar.objectname
          ttMenu.TYPE        = 'Band'.
            
     END.
     ELSE
     DO:
       IF NUM-ENTRIES(ryc_band.band_submenu_label) = 2 
       AND replace(ENTRY(1,ryc_band.band_submenu_label),'&','') <> 
           replace(gcFile,'&','') THEN
       DO:
         CREATE ttMenu.
         ASSIGN 
          ttMenu.CODE        = 'Dummy' + ENTRY(1,ryc_band.band_submenu_label)
          ttMenu.childbands  = gsm_menu_structure.MENU_structure_code
          ttMenu.bandlabel   = ryc_band.band_submenu_label
          ttMenu.menulabel   = ENTRY(1,ryc_band.band_submenu_label)
          ttMenu.sequence    = gsm_toolbar_menu_structure.menu_structure_sequence
                               * 10
          ttMenu.parentlabel = 'menubar'
          ttMenu.objectname  = ttToolbar.objectname.

       END.

       CREATE ttMenu.
       ASSIGN 
         ttMenu.CODE       = gsm_menu_structure.MENU_structure_code
         ttMenu.bandlabel  = ryc_band.band_submenu_label
         ttMenu.menulabel  = cLabel
         ttMenu.parentlabel = (IF NUM-ENTRIES(ttMenu.bandlabel) = 2 THEN 
                               ENTRY(1,ttMenu.bandlabel)
                               ELSE IF ttMenu.bandlabel = 'rule' 
                               THEN gcFile 
                               ELSE 'Menubar')
         ttMenu.parentLabel = IF REPLACE(ttMenu.parentLabel,'&','') = gcFile
                              THEN gcFile 
                              ELSE ttMenu.parentLabel
         
         ttMenu.childbands  = IF cLabel = gcFile 
                              THEN gsm_menu_structure.MENU_structure_code
                              ELSE ''
         ttMenu.sequence    = gsm_toolbar_menu_structure.menu_structure_sequence
                              * IF NUM-ENTRIES(ttMenu.bandlabel) = 2 
                                THEN 100 ELSE 10
         ttMenu.objectname  = gsc_Object.OBJECT_FILENAME
         ttMenu.DYNAMIC     = ryc_band.inherit_menu_icons
         ttMenu.TYPE        = 'Band'.
       
       IF NUM-ENTRIES(ttMenu.bandlabel) = 2 THEN
       DO:
         FIND LAST bttMenu 
                    WHERE bttMenu.objectname  = gsc_Object.OBJECT_FILENAME
                    AND   bttMenu.ParentLabel = ttMenu.ParentLabel 
                    AND   bttMenu.sequence    < ttMenu.sequence NO-ERROR.
         IF AVAIL bttMenu THEN 
         DO:
           iSequence = ttMenu.sequence.
           ttMenu.Sequence = ttMenu.sequence + 1.
           CREATE ttMenu.
           ASSIGN 
              ttMenu.CODE        = 'RULE'
              ttmenu.reference   = 'RULE'
              ttMenu.menulabel   = '------------------- '  
              ttMenu.parentlabel = bttMenu.ParentLabel
              ttMenu.sequence    = iSequence
              ttMenu.objectname  = gsc_Object.OBJECT_FILENAME
              ttMenu.TYPE        = 'Action'.
         END.
       END.
     END.
   END.

   IF CAN-FIND
         (FIRST gsm_menu_structure_item OF gsm_menu_structure)
          THEN
   DO:
     FIND LAST bttMenu 
          WHERE bttMenu.objectname  = gsc_Object.OBJECT_FILENAME
          AND   bttMenu.ParentLabel = cLabel
          AND   bttMenu.CODE        <> 'RULE'  NO-ERROR.
     
     IF AVAIL bttMenu THEN 
     DO:
       CREATE ttMenu.
       ASSIGN 
          ttMenu.CODE       = 'RULE'
          ttmenu.reference  = 'RULE'
          ttMenu.menulabel  = '-----------------'
          ttMenu.parentlabel = cLabel
          ttMenu.sequence    = gsm_toolbar_menu_structure.menu_structure_sequence
                               * 100 
          ttMenu.objectname  = gsc_Object.OBJECT_FILENAME
          ttMenu.TYPE        = 'Action'.
     
     END.
   END.

   /*
   RUN showstep(' ' 
                 + STRING(gsm_toolbar_menu_structure.menu_structure_sequence)
                 + gsm_menu_structure.MENU_STRUCTURE_CODE
                 + ' ' +
                 gsm_menu_structure.MENU_structure_type
                 + ' ' +
                 (IF AVAIL RYC_BAND THEN ryc_band.band_submenu_label ELSE '<no band>')).
     */
   FOR EACH gsm_menu_structure_item NO-LOCK
        OF gsm_menu_structure,
      EACH  gsm_menu_item NO-LOCK
          WHERE gsm_menu_item.MENU_item_obj = gsm_menu_structure_item.MENU_item_obj
   BY gsm_menu_structure_item.MENU_ITEM_SEQUENCE:
       /*
       RUN showstep('   ' +
                    gsm_menu_item.menu_item_reference
                    + ' ' +
                    gsm_menu_item.menu_item_label
                    ).
         */          
      CREATE ttMenu.
       ASSIGN 
        ttMenu.CODE       =  gsm_menu_structure.MENU_structure_code
                             + ':' +  gsm_menu_item.menu_item_reference
        ttmenu.reference  = gsm_menu_item.menu_item_reference
        ttMenu.bandlabel  = band_submenu_label
        ttMenu.menulabel  = gsm_menu_item.menu_item_label
        ttMenu.parentlabel = cParent
        ttMenu.sequence    = (gsm_toolbar_menu_structure.menu_structure_sequence
                               * 100) 
                             +  gsm_menu_structure_item.MENU_ITEM_SEQUENCE
        ttMenu.objectname  = gsc_Object.OBJECT_FILENAME
        ttMenu.TYPE        = 'Action'
        ttMenu.action      = substr(gsm_menu_item.item_select_type,1,3) 
                             + ':' 
                             + gsm_menu_item.item_select_action
                             + '('
                             + gsm_menu_item.ITEM_select_parameter
                             + ')'
        ttMenu.link        = gsm_menu_item.item_link.
   END.
 END.
END.

FIND FIRST bttMenu WHERE bttMenu.action  = 'pub:exitObject()' NO-ERROR.
IF AVAIL bttMenu THEN
  ASSIGN
  cExit      =  ENTRY(2,bttMenu.CODE,':')
  cExitLabel =  bttMenu.menulabel. 

FOR EACH ttMenu WHERE ttMenu.DYNAMIC = TRUE.
 FIND gsm_menu_structure EXCLUSIVE
      WHERE gsm_menu_structure.MENU_structure_code = ttMenu.CODE NO-ERROR.
 
 IF AVAIL gsm_menu_structure THEN
 DO:
   FOR EACH gsm_toolbar_menu_structure OF gsm_menu_structure EXCLUSIVE-LOCK: 
     iStruct = gsm_toolbar_menu_structure.MENU_structure_sequence. 
     FIND gsc_object OF gsm_toolbar_menu_structure NO-LOCK.
     FOR EACH btoolbar EXCLUSIVE OF gsc_object WHERE
             btoolbar.MENU_structure_sequence > iStruct:
        btoolbar.MENU_structure_sequence = btoolbar.MENU_structure_sequence - 1.
     END.
     DELETE gsm_toolbar_menu_structure.
   END.
   DELETE gsm_menu_structure.
 END.

 ASSIGN 
    ttMenu.CODE      = dynamicItem(ttMenu.CODE)
    ttMenu.reference = ttMenu.CODE
    ttMenu.TYPE      = 'Action'. 
END.

RUN showstep('Remove reduntant bands/menus from File menu(s)').
RUN showstep('<UNDERLINE>').

FOR EACH ttMenu WHERE ttmenu.menulabel = gcFile    
   BY ttmenu.objectname:
   
   cList = ttmenu.Childbands.
   IF cList <> '' THEN 
   DO i = 1 TO NUM-ENTRIES(cList):     
     lDelete = deleteMenuStructure(ENTRY(i,cList)). 
     /* deleted now or already deleted */ 
     IF NOT (lDelete = FALSE) THEN
     DO:
       ttmenu.childbands = TRIM(REPLACE(',' + ttmenu.childbands + ',',',' 
                                + ENTRY(i,cList) + ',',','),',').
       
       FOR EACH bttMenu WHERE bttMenu.code BEGINS ENTRY(i,cList) + ":":
          ASSIGN bttMenu.code = ENTRY(2,bttMenu.code,':').
       END.

     END.
   END.

   /* find the last. */ 
   FOR EACH bttMenu WHERE bttMenu.objectname  = ttMenu.objectname
                    AND   bttMenu.parentlabel = ttMenu.menulabel 
                    BY    bttMenu.sequence  descending:
      iSequence = bttMenu.sequence.
      LEAVE. 
   END.

   /* Add exit if it's not there */
   FIND bttMenu WHERE bttMenu.objectname  = ttMenu.objectname
                AND   bttMenu.parentlabel = ttMenu.menulabel 
                AND   bttMenu.action      = 'pub:exitObject()' NO-ERROR.
   
   IF NOT AVAIL bttMenu AND cExit <> '' THEN
   DO:
     CREATE bttMenu. 
     ASSIGN bttMenu.CODE        = 'RULE'
            bttMenu.reference   = bttMenu.code
            bttMenu.menulabel   = '-----------------'
            bttMenu.parentlabel = ttMenu.menulabel
            bttMenu.sequence    = iSequence + 1
            bttMenu.objectname  = ttMenu.objectname
            bttMenu.TYPE        = 'Action'.
            
     
     CREATE bttMenu. 
     ASSIGN bttMenu.CODE        = cExit
            bttMenu.reference   = bttMenu.code
            bttMenu.menulabel   = cExitLabel
            bttMenu.parentlabel = ttMenu.menulabel
            bttMenu.sequence    = iSequence + 1
            bttMenu.objectname  = ttMenu.objectname
            bttMenu.TYPE        = 'Action'
            bttMenu.action      = 'pub:exitObject()'.
   END.
   lrule = FALSE.
   FOR EACH bttMenu WHERE bttMenu.objectname  = ttMenu.objectname
                    AND   bttMenu.parentlabel = ttMenu.menulabel 
                    BY    bttMenu.sequence :

      cEntry = substr(bttMenu.TYPE,1,1)
               + ":" + entry(1,bttMenu.CODE,':').
      
      
      IF lRule AND bttMenu.code = 'RULE' THEN
         DELETE bttMenu.
      
      ELSE IF NOT CAN-DO(ttmenu.childlist,cEntry) OR bttMenu.code = 'RULE' THEN
      DO:
      
        IF length(centry) + length(ttmenu.childlist) < xiError141 - 2 THEN
          ASSIGN ttmenu.childlist = ttmenu.childlist
                                    + (IF ttMenu.childlist = '' THEN '' ELSE ',') 
                                    + centry.
        ELSE DO:
          ASSIGN ttmenu.childlist = ttmenu.childlist
                                    + (IF ttMenu.childlist = '' THEN '' ELSE ',') 
                                    + CHR(1).

          LEAVE.
        END.      
      END.
      /* duplicate action */
      ELSE IF NUM-ENTRIES(bttMenu.CODE,':') = 1 THEN
      DO:
        DELETE bttMenu. 
      END.

      IF AVAIL bttmenu THEN lrule = bttMenu.code = 'RULE'. 
   END.
END.

RUN showstep('').
RUN showstep('Remove reduntant bands/menus from submenus').
RUN showstep('<UNDERLINE>').

FOR EACH ttMenu WHERE ttMenu.TYPE      = 'band'
                AND   ttMenu.menulabel <> gcfile
                BY ttmenu.CODE:

  ttMenu.changed = FALSE.
  IF NOT ttmenu.DYNAMIC THEN
  FOR EACH bttMenu WHERE  bttMenu.objectname = ttMenu.objectname
                   AND   bttMenu.parentlabel = ttMenu.menulabel 
                   BY    bttMenu.sequence :
    
      cEntry = substr(bttMenu.TYPE,1,1)
                 + ":" + entry(1,bttMenu.CODE,':').

      IF (NOT CAN-DO(ttmenu.childlist,cEntry) OR bttMenu.code = 'RULE') 
         AND NOT CAN-DO(ttmenu.childlist,chr(1)) THEN
      DO:
        IF length(centry) + length(ttmenu.childlist) < xiError141 - 2 THEN
          ASSIGN ttmenu.childlist = ttmenu.childlist
                                    + (IF ttMenu.childlist = '' THEN '' ELSE ',') 
                                    + centry.
        ELSE DO:
          ASSIGN ttmenu.childlist = ttmenu.childlist
                                    + (IF ttMenu.childlist = '' THEN '' ELSE ',') 
                                    + chr(1).

        END.
      END.
      IF NOT bttMenu.code BEGINS ttMenu.code + ':' THEN
      DO:
        ttMenu.Changed = TRUE.
        IF NUM-ENTRIES(bttMenu.code,':') = 2  THEN
        DO:
          lDelete = deleteMenuStructure(ENTRY(1,bttMenu.code,':')). 
          IF NOT lDelete = FALSE THEN
            bttMenu.code = ENTRY(2,bttMenu.code,':').         
        END.
      END.
  END.
END.

RUN showstep('').

RUN buildSubMenus(NO).
RUN buildSubMenus(YES).
RUN buildMenubars.

/*
FOR EACH ttToolbar BY ttToolbar.objectname:    
    RUN showStep(ttToolbar.objectname). 
    FIND ttMenu
         WHERE ttMenu.objectname = ttToolbar.objectname 
         AND   ttMenu.CODE       = ttMenu.objectname + "-menubar" 
         NO-ERROR. 

    IF AVAIL ttMenu THEN
    DO:
      RUN showStep(' ' + ttMenu.CODE). 
      RUN buildMenus (ttToolbar.objectname,
                      'menubar',
                      1).                        
    END.
END.
*/ 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildSubmenus C-Win 
PROCEDURE buildSubmenus :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER plFile AS LOG NO-UNDO.

DEFINE BUFFER bttMenu FOR ttMenu.

DEFINE BUFFER bAnyStruct   FOR gsm_menu_structure.
DEFINE BUFFER bChildStruct FOR gsm_menu_structure.

DEFINE VARIABLE cCode  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iseq   AS INTEGER    NO-UNDO.
DEFINE VARIABLE iSort  AS INTEGER    NO-UNDO.

RUN showStep('Restructuring ' + (if plfile THEN gcfile + ' ' ELSE '') + 'submenus').
RUN showStep('<underline>').

FOR EACH ttMenu WHERE ttMenu.TYPE  = 'band'
                AND  (IF plFile  
                      THEN gcFile =  ttMenu.menulabel
                      ELSE gcFile <> ttMenu.menulabel )              
  BREAK 
    BY ttmenu.childlist
    BY ttmenu.CODE 
    BY ttMenu.objectname:
 
  IF FIRST-OF(ttmenu.childlist) OR CAN-DO(ttmenu.childlist,chr(1)) THEN 
  DO:
    cCode = IF plfile THEN 'File' ELSE ttMenu.CODE.
    IF ttMenu.changed OR plfile THEN
    DO:
      IF CAN-FIND(FIRST bttMenu 
                        WHERE bttMenu.CODE      =  ttmenu.CODE
                        AND   bttmenu.converted = TRUE
                        AND   bttMenu.childlist <> ttmenu.childlist) 
      OR CAN-FIND(FIRST bttMenu 
                        WHERE bttMenu.CODE      = ttmenu.CODE
                        AND   bttmenu.changed   = FALSE) THEN
      
      DO:
        iSeq = 1. 
        DO WHILE TRUE:
          IF CAN-FIND(banyStruct WHERE bAnyStruct.MENU_structure_code = cCode) THEN
            ASSIGN
              iSeq  = iSeq + 1
              cCode = (IF plfile THEN 'File' ELSE ttMenu.CODE) + STRING(iSeq).
          ELSE LEAVE.
        END.
        CREATE gsm_menu_structure. 
        ASSIGN
          gsm_menu_structure.menu_item_obj              = LabelItem(ttmenu.menulabel)
          gsm_menu_structure.menu_structure_code        = cCode 
          gsm_menu_structure.menu_structure_description = cCode                                                      
          gsm_menu_structure.menu_structure_type        = 'SubMenu'
          ttMenu.CODE                                   = cCode. 
        RUN showstep('Created new menu structure ' 
                     + gsm_menu_structure.menu_structure_code ). 
        IF CAN-DO(ttmenu.childlist,chr(1)) THEN
        DO:
          RUN showstep(' NB: This menu has too many items to ensure that it has a unique structure.').
          RUN showstep('     The menu should be manually compared with others with the same message.').
          RUN showstep('').
        END.

      END.
      ELSE
        FIND gsm_menu_structure NO-LOCK
          WHERE gsm_menu_structure.MENU_structure_CODE = ttmenu.CODE.

      FOR EACH gsm_menu_structure_item OF gsm_menu_structure EXCLUSIVE:
        DELETE gsm_menu_structure_item.         
      END.
      iSort = 0.
      FOR EACH bttMenu WHERE bttMenu.objectname  = ttMenu.objectname
                       AND   bttMenu.parentlabel = ttMenu.menulabel                       
                       BY    bttMenu.sequence :
         CREATE gsm_menu_structure_item.
         ASSIGN
           iSort = iSort + 1
           gsm_menu_structure_item.menu_item_sequence = iSort 
           gsm_menu_structure_item.MENU_structure_obj = gsm_menu_structure.MENU_structure_obj. 
         IF bttMenu.TYPE = 'action' THEN
         DO:
           FIND gsm_menu_item NO-LOCK
               WHERE gsm_menu_item.MENU_item_reference = bttMenu.reference NO-ERROR.
           
           IF NOT AVAIL gsm_menu_item THEN
           DO:
              MESSAGE 'Menu item: ' bttMenu.reference 'NOT FOUND'.
              RETURN ERROR. 
           END.

           gsm_menu_structure_item.MENU_item_obj = gsm_menu_item.MENU_item_obj. 
           IF plfile OR NOT bttmenu.CODE BEGINS ttMenu.CODE + ':' THEN
             RUN showstep('Added item ' 
                    + STRING(gsm_menu_structure_item.menu_item_sequence)
                    + ' ' + gsm_menu_item.MENU_item_reference
                    + ' to menu structure '
                    +  gsm_menu_structure.MENU_structure_code).
         END.

         ELSE DO: 
            FIND bChildStruct no-lock
               WHERE bChildStruct.MENU_structure_code = bttMenu.CODE.
           ASSIGN
             gsm_menu_structure_item.MENU_item_obj 
                                          = bChildStruct.MENU_item_obj
             gsm_menu_structure_item.child_MENU_structure_obj 
                                          = bChildStruct.MENU_structure_obj
             . 
           IF plfile OR NOT bttmenu.CODE BEGINS ttMenu.CODE + ':' THEN
              RUN showstep('Added item ' 
                            + STRING(gsm_menu_structure_item.menu_item_sequence)
                            + ' submenu ' 
                            + bChildStruct.MENU_structure_code  
                            + ' to menu structure '
                            +  gsm_menu_structure.MENU_structure_code).

         END.
      END.
    END.
  END.

  /* file menus childlist does not need to be updated as its purpose only 
     is to compare the file menus and any changes here are due to a certain 
     combination of bands so the same changes will always be done under files
     witht he same child list
    */
  ASSIGN
    ttMenu.CODE      = cCode
    ttmenu.converted = TRUE.

END.

RUN showstep('').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildtoolbars C-Win 
PROCEDURE buildtoolbars :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN showstep("Building Toolbars").
  RUN showstep("<underline>").
      
  FOR EACH ttToolbar,
      EACH gsc_Object NO-LOCK 
      WHERE gsc_Object.OBJECT_FILENAME = ttToolbar.objectname
      BY ttToolbar.objectname:
    RUN showstep(gsc_Object.OBJECT_FILENAME).
    
    FOR EACH gsm_toolbar_menu_structure NO-LOCK OF gsc_object ,
    EACH gsm_menu_structure NO-LOCK
       OF  gsm_toolbar_menu_structure
       WHERE gsm_menu_structure.MENU_structure_type <> 'submenu':
    
    FIND ryc_band WHERE ryc_band.band_name = gsm_menu_structure.MENU_structure_code
        NO-LOCK NO-ERROR.
    IF NOT AVAIL ryc_band 
    AND gsm_menu_structure.MENU_structure_code MATCHES '*submenu' THEN
       FIND ryc_band WHERE ryc_band.band_name = 
              substr(gsm_menu_structure.MENU_structure_code,1,
                     index(gsm_menu_structure.MENU_structure_code,'submenu') - 1)
         NO-LOCK NO-ERROR.

    
    RUN showstep(' ' 
                 + STRING(gsm_toolbar_menu_structure.menu_structure_sequence)
                 + gsm_menu_structure.MENU_STRUCTURE_CODE
                 + ' ' +
                 gsm_menu_structure.MENU_structure_type
                 + ' ' +
                 (IF AVAIL RYC_BAND THEN ryc_band.band_submenu_label ELSE '<no band>')).
    FOR EACH gsm_menu_structure_item NO-LOCK
        OF gsm_menu_structure,
      EACH  gsm_menu_item NO-LOCK
          WHERE gsm_menu_item.MENU_item_obj = gsm_menu_structure_item.MENU_item_obj
        BY gsm_menu_structure_item.MENU_ITEM_SEQUENCE:
       RUN showstep('   ' +
                    gsm_menu_item.menu_item_reference
                    + ' ' +
                    gsm_menu_item.menu_item_label
                    ).

    
    END.
    END.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE categorizeItems C-Win 
PROCEDURE categorizeItems :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER pdCategory AS DEC        NO-UNDO.
 DEFINE INPUT  PARAMETER pcType     AS CHARACTER  NO-UNDO.
  


 IF pdCategory = 0 THEN
 FOR EACH gsm_MENU_item NO-LOCK  
   WHERE gsm_menu_item.ITEM_category_obj = 0 
   BREAK BY gsm_menu_item.item_link :
   IF FIRST-OF(gsm_menu_item.item_link) THEN
    RUN showStep(' ' +
                  if gsm_menu_item.item_link <> '' 
                  THEN gsm_menu_item.item_link
                  ELSE '<no link>'   ).

   RUN showstep( '  ' + gsm_Menu_Item.MENU_item_reference
               + ' ' + 
               gsm_menu_item.item_select_type
               + ' ' + 
               gsm_menu_item.item_select_action
               + ' ' + 
               gsm_menu_item.item_select_parameter
                ).

  
 END.
 ELSE
 IF NUM-ENTRIES(pcType,'-') > 1 THEN
 FOR EACH gsm_MENU_item EXCLUSIVE 
       WHERE gsm_menu_item.item_link = pcType:
     gsm_menu_item.ITEM_category_obj = pdCategory.
   RUN showstep( ' ' + gsm_Menu_Item.MENU_item_reference
                 + ' ' + 
                 gsm_menu_item.item_select_type
                 + ' ' + 
                 gsm_menu_item.item_select_action
                 + ' ' + 
                 gsm_menu_item.item_select_parameter
                  ).
 END.
 ELSE 
 FOR EACH gsm_MENU_item EXCLUSIVE 
       WHERE gsm_menu_item.item_control_type = pcType:
     gsm_menu_item.ITEM_category_obj = pdCategory.
     RUN showstep( ' ' + gsm_Menu_Item.MENU_item_reference
                 + ' ' + 
                 gsm_menu_item.item_select_type).

 END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkMenuitems C-Win 
PROCEDURE checkMenuitems :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN showstep('Check').
  RUN showstep('<underline>').

  FOR EACH gsm_menu_item NO-LOCK 
     BY gsm_menu_item.MENU_item_reference:
    
   RUN showstep(gsm_menu_item.MENU_item_reference 
                + ' ' + gsm_menu_item.MENU_item_label).

    FOR EACH gsm_menu_structure_item NO-LOCK 
        WHERE gsm_menu_structure_item.MENU_item_obj = gsm_menu_item.MENU_item_obj:
       FIND gsm_menu_structure OF gsm_menu_structure_item NO-LOCK NO-ERROR.
       IF AVAIL gsm_menu_structure THEN
         RUN showstep(' ' +  MENU_structure_code).
       ELSE
         RUN showstep(' ' +  'no structure found').
    END.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkMenustruct C-Win 
PROCEDURE checkMenustruct :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN showstep('Check').
  RUN showstep('<underline>').

  FOR EACH gsm_menu_structure_item NO-LOCK: 

     FIND gsm_menu_item NO-LOCK 
         WHERE gsm_menu_structure_item.MENU_item_obj = gsm_menu_item.MENU_item_obj
          NO-ERROR.
     FIND gsm_menu_structure OF gsm_menu_structure_item NO-LOCK NO-ERROR.
     
     RUN showstep('Menu item: '  
                  + (IF AVAIL gsm_menu_item 
                     THEN gsm_menu_item.MENU_item_reference 
                     ELSE '<not found: ' + STRING(gsm_menu_structure_item.MENU_item_obj))
                  + ' Menu Structure: '  
                  + IF AVAIL gsm_menu_structure 
                    THEN gsm_menu_structure.MENU_structure_code 
                    ELSE '<not found: ' + STRING(gsm_menu_structure_item.MENU_structure_obj)
                  ).
   
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkStructItems C-Win 
PROCEDURE checkStructItems :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VARIABLE iCount        AS INTEGER FORMAT 'zzz9'  NO-UNDO.
DEFINE VARIABLE iToolBarCount AS INTEGER FORMAT 'zzz9'  NO-UNDO.
DEFINE VARIABLE iMenuCount    AS INTEGER FORMAT 'zzz9'  NO-UNDO.
DEFINE VARIABLE cType         AS CHARACTER              NO-UNDO.
DEFINE VARIABLE lChange       AS LOGICAL                NO-UNDO.
DEFINE VARIABLE cRef          AS CHARACTER              NO-UNDO.
DEFINE VARIABLE iSeq          AS INTEGER                NO-UNDO.

FOR EACH gsm_MENU_structure NO-LOCK
  BY gsm_menu_structure.menu_structure_code:
  
  ASSIGN iCount = 0
         iToolbarCount = 0
         iMenuCount = 0
         ctype = gsm_menu_structure.MENU_structure_type.

  FOR EACH gsm_menu_structure_item OF gsm_MENU_structure NO-LOCK,
      EACH gsm_menu_item 
      WHERE gsm_menu_structure_item.MENU_item_obj = gsm_menu_item.menu_item_obj
      NO-LOCK:

      FIND ryc_action WHERE ryc_action.action_reference = gsm_menu_item.menu_item_reference NO-LOCK
      NO-ERROR. 
    IF AVAIL ryc_action THEN
    ASSIGN 
      iToolbarCount = iToolbarCount 
                    + IF place_action_on_toolbar THEN 1 ELSE 0
      iMenuCount    = iMenuCount 
                    + IF place_action_on_menu THEN 1 ELSE 0.

      iCount = iCount + 1.
  END.
  RUN showStep(gsm_menu_structure.MENU_structure_code 
               + ' ' +
               gsm_menu_structure.MENU_structure_type 
               + ' ' + 
               STRING(itoolbarCount) 
               + ' ' + 
               STRING(imenuCount) 
                ). 
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cleanBands C-Win 
PROCEDURE cleanBands :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cLabel AS CHARACTER  NO-UNDO.
FOR EACH gsm_menu_structure EXCLUSIVE:
  FIND ryc_band WHERE ryc_band.band_name = gsm_menu_structure.MENU_structure_code
        NO-LOCK NO-ERROR.
  IF NOT AVAIL ryc_band 
    AND gsm_menu_structure.MENU_structure_code MATCHES '*submenu' THEN
       FIND ryc_band WHERE ryc_band.band_name = 
              substr(gsm_menu_structure.MENU_structure_code,1,
                      index(gsm_menu_structure.MENU_structure_code,'submenu') - 1)
  NO-LOCK NO-ERROR.
  IF AVAIL ryc_band AND ryc_band.band_submenu_label <> '' THEN
  DO:
    cLabel = ENTRY(num-entries(ryc_band.band_submenu_label),
                  ryc_band.band_submenu_label).

   IF cLabel <> 'RULE' AND cLabel <> '' THEN
     gsm_menu_structure.menu_item_obj  = LabelItem(cLabel).

  END.

  RUN showStep(cLabel + 
                STRING(gsm_menu_structure.menu_item_obj) ).

END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE convertActions C-Win 
PROCEDURE convertActions :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
  DEFINE BUFFER bItem FOR gsm_menu_item.
  DEFINE BUFFER bAnyItem FOR gsm_menu_item.
    
  DEFINE VARIABLE cItemref  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iNum      AS INTEGER    NO-UNDO.

  RUN showstep ("Converting actions").
  RUN showstep ('<underline>').

  FOR EACH ryc_action  NO-LOCK
      ON ERROR UNDO, RETURN ERROR:

    /* if an menu item exists with this ref rename the menu */
    FIND bItem EXCLUSIVE 
          WHERE bItem.MENU_item_reference = ryc_action.action_reference NO-ERROR.
    iNum = 1. /* ensure that 2 is the first we try  */ 
    IF AVAIL bItem THEN
    DO WHILE TRUE:
         IF CAN-FIND(bAnyItem WHERE bAnyItem.MENU_item_reference = cItemref) THEN
         DO:
           ASSIGN 
             iNum = iNum + 1
             cItemref = ryc_action.action_reference + STRING(iNum).
         END.
         ELSE DO:
           bItem.MENU_item_reference = cItemRef.
           RUN showstep('Renamed menu_item ref to '
                        + cItemref 
                        + ' in order to convert '
                        + ryc_action.action_reference ).
           LEAVE.
         END.
    END.
    
    CREATE gsm_menu_item.
    
    ASSIGN
      /* New 
      gsm_menu_item.item_category_obj 
      gsm_menu_item.item_control_style      
      */ 
      gsm_menu_item.menu_item_reference   = ryc_action.action_reference 
      gsm_menu_item.item_control_type     = 'ACTION'
      gsm_menu_item.menu_item_description = IF ryc_action.action_menu_label <> ''
                                             THEN REPLACE(ryc_action.action_menu_label,'&','')
                                             ELSE IF ryc_action.action_label <> ''  
                                                  THEN REPLACE(ryc_action.action_label,'&','')
                                                  ELSE gsm_menu_item.menu_item_reference  
      /*                                            
      gsm_menu_item.menu_item_obj 
      */
      
      gsm_menu_item.toggle_menu_item      = ryc_action.ON_choose_action = 'property'
                                         
       /**    
           ryc_action.place_action_on_menu 
           ryc_action.place_action_on_toolbar
        **/
                                        /*  ryc_action.action_obj */
    
      gsm_menu_item.shortcut_key          = ryc_action.action_accelerator 
      gsm_menu_item.DISABLED              = ryc_action.action_disabled 
      gsm_menu_item.item_toolbar_label    = ryc_action.action_label 
      gsm_menu_item.item_link             = ryc_action.action_link 
      gsm_menu_item.menu_item_label       = ryc_action.action_menu_label 
      gsm_menu_item.item_narration        = ryc_action.action_narration  
      gsm_menu_item.tooltip_text          = ryc_action.action_tooltip 
      gsm_menu_item.object_obj            = ryc_action.object_obj 
      
      gsm_menu_item.item_select_action    =  ryc_action.on_choose_action                                         
      gsm_menu_item.item_select_type      = ryc_action.action_type_code  
      gsm_menu_item.item_select_parameter = ryc_action.action_parameter 

     /*  
      gsm_menu_item.disable_rule = ryc_action.disable_state_list 
      gsm_menu_item.enable_rule  = ryc_action.enable_state_list 
      gsm_menu_item.hide_rule    = ryc_action.hide_state_list
      gsm_menu_item.view_rule    = ryc_action.view_state_list
      */
      gsm_menu_item.image1_down_filename        = ryc_action.image1_down_filename 
      gsm_menu_item.image1_insensitive_filename = ryc_action.image1_insensitive_filename 
      gsm_menu_item.image1_up_filename          = ryc_action.image1_up_filename 
      gsm_menu_item.image2_down_filename        = ryc_action.image2_down_filename 
      gsm_menu_item.image2_insensitive_filename = ryc_action.image2_insensitive_filename 
      gsm_menu_item.image2_up_filename          = ryc_action.image2_up_filename
      gsm_menu_item.item_menu_drop              = ryc_action.initial_code 
      gsm_menu_item.instance_attribute_obj      = ryc_action.instance_attribute_obj
      gsm_menu_item.on_create_publish_event     = ryc_action.on_create_publish_event
      gsm_menu_item.propagate_links             = ryc_action.propagate_links 
      gsm_menu_item.security_token              = ryc_action.security_token
      gsm_menu_item.system_owned                = ryc_action.system_owned 

      .
       /* No equivalent
          gsm_menu_item.substitute_text_property 
          gsm_menu_item.hide_if_disabled 
          gsm_menu_item.product_module_obj  
          gsm_menu_item.under_development 
       */
       

       /* Expired 
          gsm_menu_item.menu_structure_obj
          gsm_menu_item.toolbar_image_filename 
          gsm_menu_item.toolbar_image_sequence  
          gsm_menu_item.publish_event 
          gsm_menu_item.publish_link_list 
          gsm_menu_item.publish_parameter 
          gsm_menu_item.ruler_menu_item
          gsm_menu_item.sub_menu_item  
          gsm_menu_item.parent_menu_item_obj 
           
       */
     VALIDATE gsm_menu_item NO-ERROR.
     IF RETURN-VALUE <> '' THEN
     DO:
       RUN showStep('Error:  ' + RETURN-VALUE ).
       RETURN ERROR.
     END.

     ELSE
       RUN showStep(gsm_menu_item.menu_item_reference).

  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE convertBands C-Win 
PROCEDURE convertBands :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE cLabel AS CHARACTER  NO-UNDO.
RUN showstep ("Converting bands to menu structures").
RUN showstep ('<underline>').
FOR EACH ryc_band NO-LOCK BY ryc_band.band_name :
  DO TRANSACTION:
    CREATE gsm_menu_structure. 
    ASSIGN
     gsm_menu_structure.menu_structure_code        = ryc_band.band_name 
     gsm_menu_structure.disabled                   = ryc_band.band_disabled 
     gsm_menu_structure.system_owned               = ryc_band.system_owned
     gsm_menu_structure.menu_structure_description = ryc_band.band_name                                                      
     gsm_menu_structure.menu_structure_type        = 'Menu&Toolbar'  
     gsm_menu_structure.menu_structure_narrative   = ryc_band.band_narrative  
     cLabel = IF ryc_band.band_submenu_label <> '' 
              THEN ENTRY(num-entries(ryc_band.band_submenu_label),
                         ryc_band.band_submenu_label)
              ELSE ''.


    IF cLabel <> 'RULE' AND cLabel <> '' THEN
       gsm_menu_structure.menu_item_obj  = LabelItem(cLabel).
           /*** Menu structure no conversion data
    gsm_menu_structure.product_obj                = default
    gsm_menu_structure.product_module_obj         = default
    gsm_menu_structure.menu_structure_description = No match! 
    gsm_menu_structure.menu_structure_hidden      = ??
    gsm_menu_structure.under_development          = no match
    gsm_menu_structure.menu_structure_obj         = TRIGGER
    
    ***/

    /****
    ryc_band.band_alignment -- goes to toolbar_menu_structure.. 
    ryc_band.band_obj       -- Key 
    ryc_band.band_sequence  -- goes to  toolbar_menu_structure
    ryc_band.inherit_menu_icons -- not used 
    ryc_band.initial_state      -- not used
    *****/

  END. /* Transaction */
  RUN showstep(ryc_band.band_name).      
END.



  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE convertData C-Win 
PROCEDURE convertData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 gcLog:CURSOR-OFFSET IN FRAME {&FRAME-NAME} = 1.
 
 RUN loadOldRecords NO-ERROR.
 IF ERROR-STATUS:ERROR THEN
  UNDO, RETURN ERROR.

 
 RUN convertMenuItems NO-ERROR.
 IF ERROR-STATUS:ERROR THEN
   UNDO, RETURN ERROR.

 RUN showStep('').
 
 RUN convertMenus no-error. 
 IF ERROR-STATUS:ERROR THEN
    UNDO, RETURN ERROR.
 
 RUN showStep('').
 
 RUN convertActions NO-ERROR.
 IF ERROR-STATUS:ERROR THEN
    UNDO, RETURN ERROR.
 
 RUN showStep('').

 RUN sequenceObjectMenus NO-ERROR.
 IF ERROR-STATUS:ERROR THEN
    UNDO, RETURN ERROR.
  
 RUN showStep('').

 RUN convertBands no-error. 
 IF ERROR-STATUS:ERROR THEN
    UNDO, RETURN ERROR.
  
 RUN showStep('').

 RUN fixBands no-error.
 IF ERROR-STATUS:ERROR THEN
   UNDO, RETURN ERROR.
 

 RUN showStep('').

 RUN createStructureItems NO-ERROR.
 IF ERROR-STATUS:ERROR THEN
    UNDO, RETURN ERROR.
 
 RUN showStep('').
 /****8
 RUN checkmenuitems.

 RUN checkmenustruct.
 **/
 RUN createToolbars NO-ERROR.
 IF ERROR-STATUS:ERROR THEN
    UNDO, RETURN ERROR.
 
 RUN showStep('').
 
 RUN splitBands NO-ERROR. 
 IF ERROR-STATUS:ERROR THEN
   UNDO, RETURN ERROR.


 RUN showStep('').

 RUN normalizeMenuItems NO-ERROR.
  IF ERROR-STATUS:ERROR THEN
    UNDO, RETURN ERROR.
 
 RUN showStep('').
 RUN buildMenuStructures NO-ERROR. 
 IF ERROR-STATUS:ERROR THEN
   UNDO, RETURN ERROR.
  
 RUN createCategories.
 
 RUN showStep('').
 RUN renameMenus NO-ERROR.

 RUN showStep('').
 RUN renameItems NO-ERROR.

 RUN showStep('').
 RUN showunusedbands . 

 RUN showStep('').

 RUN showtoolbars NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE convertMenuItems C-Win 
PROCEDURE convertMenuItems :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 RUN showStep('Converting menu items').
 RUN showStep('<underline>').

 FOR EACH tOldgsm_menu_item NO-LOCK 
     ON ERROR UNDO, RETURN ERROR:  
   
   FIND gsm_menu_item
       WHERE gsm_menu_item.MENU_item_obj = tOldgsm_menu_item.MENU_item_obj
       EXCLUSIVE-LOCK NO-ERROR.
   IF NOT AVAIL gsm_menu_item THEN 
   DO:
     RUN showstep (tOldgsm_menu_item.menu_item_reference).
     NEXT.
   END.

   ASSIGN
      gsm_menu_item.item_control_type = (IF tOldgsm_menu_item.sub_menu_item 
                                         THEN 'Label'
                                         ELSE IF tOldgsm_menu_item.ruler_menu_item 
                                              THEN 'Separator'
                                              ELSE 'Action')
      gsm_menu_item.image1_up_filename =  tOldgsm_menu_item.toolbar_image_filename.
   
   IF tOldgsm_menu_item.publish_event <> '':U THEN
   DO:
     ASSIGN
       gsm_menu_item.item_select_type      = 'Publish':U
       gsm_menu_item.item_select_action    = tOldgsm_menu_item.publish_event
       gsm_menu_item.item_select_parameter = tOldgsm_menu_item.publish_parameter
       gsm_menu_item.item_link             = tOldgsm_menu_item.publish_link_list.
   END.
   ELSE IF gsm_menu_item.item_control_type = 'Action' THEN
     ASSIGN
       gsm_menu_item.item_select_type      = 'Launch':U.
    /*
   RUN showStep(gsm_menu_item.MENU_item_label
                + ' ' + 
                gsm_menu_item.item_control_type
                + ' ' + 
                gsm_menu_item.item_select_type
                + ' ' + 
                gsm_menu_item.item_select_action  
                + IF gsm_menu_item.item_select_parameter <> '' 
                  THEN '(' + gsm_menu_item.item_select_parameter + ')'
                  ELSE ''
                + ' ' + 
                gsm_menu_item.item_link
                + ' ' +
                gsm_menu_item.image1_up_filename
                ).
    */            

 END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE convertMenus C-Win 
PROCEDURE convertMenus :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE BUFFER bStruct FOR gsm_menu_structure.
  
  RUN showStep('Converting menus and creating menu children').
  RUN showStep('<underline>').

  FOR EACH tOldgsm_menu_structure NO-LOCK    
      ON ERROR UNDO, RETURN ERROR: 
    /* if only one sub menu (which is the norm) just make it into the 
       default label. It's no need to have it as a separate menu_structure */
    FIND tOldgsm_menu_item 
    WHERE tOldgsm_menu_item.menu_structure_obj  = tOldgsm_menu_structure.menu_structure_obj
    AND  tOldgsm_menu_item.PARENT_menu_item_obj = 0 NO-LOCK NO-ERROR.
    
    FIND bstruct WHERE bstruct.menu_structure_obj  = tOldgsm_menu_structure.menu_structure_obj
    EXCLUSIVE.
    
    bstruct.MENU_structure_type = 'SubMenu'.
    IF AVAIL tOldgsm_menu_item THEN
      bstruct.MENU_item_obj = tOldgsm_menu_item.menu_item_obj.
                       
    RUN showStep (bstruct.menu_structure_code 
                  + ' (' +
                  bstruct.menu_structure_description
                  + ') ' +
                   
                    (IF AVAIL tOldgsm_menu_item 
                     THEN ' Default label: '
                          + tOldgsm_menu_item.MENU_item_label 
                          + ' (' 
                          + tOldgsm_menu_item.MENU_item_reference 
                          + ')'
                     ELSE '')
                  ).
    
    RUN createMenuChildren(tOldgsm_menu_structure.menu_structure_obj,
                           0,
                           tOldgsm_menu_structure.menu_structure_obj,
                           1) NO-ERROR. 
 
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createCategories C-Win 
PROCEDURE createCategories :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
  DEFINE VARIABLE cSupportedLinks AS CHARACTER  NO-UNDO
        INIT 'navigation-target,tableio-target,commit-target'.
  
  DEFINE VARIABLE cKeepblank  AS CHARACTER  NO-UNDO 
        INIT 'exitObject,ok,cancel' .

  DEFINE VARIABLE i AS INTEGER    NO-UNDO.
  DEFINE VARIABLE dCat AS DECIMAL    NO-UNDO.
  
  DEFINE BUFFER bItem       FOR gsm_menu_item.
  
  FOR EACH ryc_band NO-LOCK  
    BREAK BY ryc_band.band_link:
    
    IF FIRST-OF(ryc_band.band_link) THEN
    DO:
      IF CAN-DO(cSupportedLinks,ryc_band.band_link) THEN
         dCat = createItemCategory(ryc_band.band_link).
      ELSE 
         dCat = 0.
    END.
    
    IF dCat <> 0 THEN
    DO i = 1 TO 2:
     IF i = 1 THEN
      FIND gsm_menu_structure NO-LOCK
         WHERE gsm_menu_structure.MENU_structure_code = ryc_band.band_name
       NO-ERROR.     
     ELSE
       FIND gsm_menu_structure NO-LOCK
          WHERE gsm_menu_structure.MENU_structure_code = 
                       ryc_band.band_name + 'submenu':U 
       NO-ERROR.
     
     
     IF AVAIL gsm_menu_structure THEN
     do:
       FOR EACH gsm_menu_structure_item NO-LOCK
          WHERE gsm_menu_structure_item.MENU_structure_obj
                  = gsm_menu_structure.MENU_structure_obj,
          EACH gsm_menu_item exclusive-LOCK
          WHERE gsm_menu_item.MENU_item_obj = gsm_menu_structure_item.MENU_item_obj
          AND   gsm_menu_item.item_category_obj = 0:
         
        IF gsm_menu_item.item_link = ryc_band.band_link
        OR (gsm_menu_item.item_link = '' AND NOT CAN-DO(ckeepblank,gsm_menu_item.item_select_action))
        THEN
          ASSIGN
            gsm_menu_item.item_link = ''
            gsm_menu_item.item_category_obj = dCat.
        /*
        RUN showstep(' ' + gsm_menu_item.menu_item_reference
                     + ' Link: ' + gsm_menu_item.item_link
                     + ' ' +
                     gsm_menu_item.item_select_action
                     +  ' ' +
                     gsm_menu_item.item_select_parameter
                      ).
         */
      END.

     END.
    END.

    IF LAST-OF(ryc_band.band_link) AND dCat <> 0 THEN
    DO:
      FOR EACH gsm_menu_item NO-LOCK
          WHERE gsm_menu_item.item_category_obj = dCat:
        RUN showstep(' ' + gsm_menu_item.menu_item_reference
                      + ' ' +
                     gsm_menu_item.item_select_action
                     +  ' ' +
                     gsm_menu_item.item_select_parameter
                      ).

      END.
    END.
  END.

  /*

  FOR EACH ryc_band NO-LOCK,
      EACH ryc_band_Action OF ryc_band NO-LOCK,
      EACH ryc_action OF ryc_band_Action NO-LOCK
      BREAK BY :


  END.

  FOR EACH gsm_menu_item NO-LOCK:

    FIND gsm_menu_structure NO-LOCK
        WHERE gsm_menu_structure.MENU_structure_obj
                  = gsm_menu_structure_item.MENU_structure_obj.

    FIND ryc_band WHERE ryc_band.band_name = gsm_menu_structure.MENU_structure_code
        NO-LOCK NO-ERROR.
    
    IF NOT AVAIL ryc_band 
    AND gsm_menu_structure.MENU_structure_code MATCHES '*submenu' THEN
       FIND ryc_band WHERE ryc_band.band_name = 
              substr(gsm_menu_structure.MENU_structure_code,1,
                     index(gsm_menu_structure.MENU_structure_code,'submenu') - 1)
       NO-LOCK NO-ERROR.

    IF  AVAIL ryc_band AND ryc_band.band_link <> ''
    AND  gsm_menu_item.item_category_obj = 0
    AND (gsm_menu_item.item_link = ryc_band.band_link)
         OR  (gsm_menu_item.item_link = '' 
              AND NOT CAN-DO(ckeepblank,gsm_menu_item.item_select_action))
    THEN
    DO:
        dCat = createItemCategory(ryc_band.band_link).

        FIND bItem EXCLUSIVE 
              WHERE bItem.MENU_item_obj  = gsm_menu_item.MENU_item_obj.
        ASSIGN
          gsm_menu_item.item_link = ''
          gsm_menu_item.item_category_obj = dCat.

        RUN showstep( ' ' + gsm_menu_item.menu_item_reference
                      + ' ' +
                      gsm_menu_item.item_link
                      +  ' ' +
                      gsm_menu_item.item_select_action
                      +  ' ' +
                      gsm_menu_item.item_select_parameter
                      ).
    END.
  END.
  */

  dCat = createItemCategory('SubMenu').
  RUN categorizeItems(dCat,'Label').
 
  dCat = createItemCategory('PlaceHolder').
  RUN categorizeItems(dCat,'PlaceHolder').
  
  RUN showStep('Not categorized items sorted by item link').
  RUN categorizeItems(0,'').
 
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createMenuChildren C-Win 
PROCEDURE createMenuChildren :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT PARAMETER pdParent         AS DECIMAL    NO-UNDO.
 DEFINE INPUT PARAMETER pdOldParentItem  AS DECIMAL NO-UNDO.
 DEFINE INPUT PARAMETER pdNewParent      AS DECIMAL NO-UNDO.
 DEFINE INPUT PARAMETER iLevel           AS INT     NO-UNDO.
 
 DEFINE BUFFER bParentStruct FOR gsm_menu_structure. 
 DEFINE BUFFER bnewStruct  FOR gsm_menu_structure. 
 DEFINE BUFFER banyStruct  FOR gsm_menu_structure. 

 DEFINE VARIABLE cStruct AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iSeq    AS INTEGER    NO-UNDO.
 DEFINE VARIABLE iNum    AS INTEGER    NO-UNDO.
                
FIND bParentStruct NO-LOCK
     WHERE bParentStruct.menu_structure_obj = pdParent.

FOR EACH tOldgsm_menu_item NO-LOCK 
    WHERE tOldgsm_menu_item.menu_structure_obj   = bParentStruct.menu_structure_obj
    AND   tOldgsm_menu_item.PARENT_menu_item_obj = pdOldParentItem
    BY tOldgsm_menu_item.menu_ITEM_sequence
    ON ERROR UNDO,RETURN ERROR:
   
  /* If this item was the only submenu at the top it may have been used as 
   label for the structure, if so don't add it to the itemlist for this
   structure */      
  IF bParentStruct.menu_item_obj <> tOldgsm_menu_item.menu_item_obj THEN
  DO:
    CREATE gsm_menu_structure_item.
    
    ASSIGN
      gsm_menu_structure_item.MENU_item_sequence = tOldgsm_menu_item.menu_ITEM_sequence
      gsm_menu_structure_item.menu_structure_obj = pdNewParent
      gsm_menu_structure_item.MENU_item_obj      = tOldgsm_menu_item.menu_item_obj.

    /* If this is a submenu create new menu_structure for it */
    IF tOldgsm_menu_item.sub_menu_item THEN
    DO:      
      CREATE bNewStruct.  
      
      /* Generate Structure ref, start with label and add parent label if it already exists */ 
      cStruct = REPLACE(tOldgsm_menu_item.menu_item_label,'&','').
      DO WHILE TRUE: 
        IF CAN-FIND(banyStruct WHERE bAnyStruct.menu_structure_code = cStruct) THEN
        DO:
          IF iNum = 0 THEN
            ASSIGN
              cStruct = bParentStruct.menu_structure_code + '-' + cStruct
              iNum    =  1.
          ELSE
            ASSIGN 
              cStruct =  bParentStruct.menu_structure_code + '-'
                         + REPLACE(tOLdgsm_menu_item.menu_item_label,'&','')
                         + '-' + STRING(iNum)
              iNum    = iNum + 1. 

        END.
        ELSE LEAVE.
      END.

      ASSIGN
        bNewStruct.MENU_structure_code        = cStruct
       /* Default label .. 
         bNewStruct.MENU_item_obj            = gsm_menu_item.menu_item_obj  */
        bNewStruct.menu_structure_type        = 'SubMenu' 
        bNewStruct.MENU_structure_description = tOldgsm_menu_item.menu_item_description  
        gsm_menu_structure_item.child_menu_structure_obj = bNewStruct.menu_structure_obj.
      VALIDATE bnewstruct NO-ERROR.
      IF RETURN-VALUE <> '' THEN
      DO:
        MESSAGE RETURN-VALUE 
            VIEW-AS ALERT-BOX.
        RETURN ERROR.
      END.

    END.
    VALIDATE gsm_menu_structure_item NO-ERROR.
    IF RETURN-VALUE <> '' THEN
    DO:
      MESSAGE RETURN-VALUE 
         VIEW-AS ALERT-BOX.
        RETURN ERROR.
    END.
    RUN showStep(FILL('-',iLevel) 
                 + (IF AVAIL bNewStruct 
                    THEN (' ' + bNewStruct.MENU_structure_code 
                              + ' (' 
                              + bNewStruct.MENU_structure_description
                              + ')')
                    ELSE '')
                 + ' ' 
                 + tOldgsm_menu_item.MENU_item_label                
                 + ' (' 
                 + tOldgsm_menu_item.MENU_item_reference                
                 + ') '                 
                 ).
  END.
  
  RUN createMenuChildren(pdParent,
                         tOldgsm_menu_item.menu_item_obj,
                         IF AVAIL bNewStruct 
                         THEN bNewstruct.MENU_structure_obj
                         ELSE bParentStruct.menu_structure_obj, 
                         iLevel + IF AVAIL bNewStruct THEN 1 ELSE 0).      
END.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createStructureItems C-Win 
PROCEDURE createStructureItems :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN showStep('Converting band actions into menu structure items').
  RUN showStep('<underline>').

  DEFINE VARIABLE iSeq  AS INTEGER    NO-UNDO.

  FOR EACH ryc_band  NO-LOCK  BY band_name:
    RUN showStep(ryc_baND.BAND_NAME).     
    iSeq = 0.
    FOR EACH ryc_band_action OF ryc_band NO-LOCK,
      EACH ryc_action NO-LOCK OF ryc_band_action
      ON ERROR UNDO, RETURN ERROR
      BY ryc_band_action.band_obj
      BY ryc_band_action.band_action_sequence  :

     FIND gsm_menu_structure WHERE gsm_menu_structure.menu_structure_code
                                   = ryc_band.band_name NO-LOCK NO-ERROR.
     IF NOT AVAIL gsm_menu_structure THEN
     DO:
        MESSAGE  'Band ' ryc_band.band_name ' not converted'
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN ERROR.
     END.
     FIND gsm_menu_item WHERE gsm_menu_item.MENU_item_reference
                              = ryc_action.action_reference NO-LOCK NO-ERROR.
     IF NOT AVAIL gsm_menu_item THEN
     DO:
        MESSAGE  'Action ' ryc_action.action_reference ' not converted'
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN ERROR.
     END.

     CREATE gsm_menu_structure_item.
    
     ASSIGN
      iSeq = iSeq + 1
      gsm_menu_structure_item.MENU_item_sequence = iSeq
      gsm_menu_structure_item.menu_structure_obj = gsm_menu_structure.menu_structure_obj
      gsm_menu_structure_item.MENU_item_obj      = gsm_menu_item.menu_item_obj.

     RUN showStep(' ' 
                  + STRING(gsm_menu_structure_item.MENU_item_sequence,'zzz9')
                  + ' ' +
                  gsm_menu_item.MENU_item_reference).   

     VALIDATE gsm_menu_structure_item NO-ERROR.
     IF RETURN-VALUE <> '' OR ERROR-STATUS:ERROR then
     DO:
       RUN showstep(' Failed' + RETURN-VALUE) .
     END.

    END.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createToolbars C-Win 
PROCEDURE createToolbars :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE BUFFER bToolbarObj FOR gsc_object.
DEFINE BUFFER btoolbarSO  FOR ryc_smartobject.
DEFINE BUFFER bAttrValue  FOR ryc_attribute_value. 
DEFINE BUFFER binstance   FOR ryc_object_instance.

DEFINE VARIABLE iSeq         AS INTEGER    NO-UNDO.
DEFINE VARIABLE iTool        AS INTEGER    NO-UNDO.
DEFINE VARIABLE iBand        AS INTEGER    NO-UNDO.
DEFINE VARIABLE cName        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lBandRemoved AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cBandList    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iInstances   AS INTEGER    NO-UNDO.

FIND gsc_object_type NO-LOCK
    WHERE gsc_object_type.object_type_code = xcObjectType NO-ERROR.
IF NOT AVAIL gsc_object_type THEN 
DO TRANSACTION:     
 CREATE gsc_object_type.
 ASSIGN gsc_object_type.object_type_description  = "Dynamic toolbar object"    
       gsc_object_type.object_type_code = xcObjectType.

 RUN showstep("Created Object type: "
              + gsc_object_type.object_type_code
              + '(' + string(gsc_object_type.object_type_obj) + ')').
 RUN showstep("").

END.

RUN showstep("Creating new toolbars and changing all instances").
RUN showstep("<underline>").

iSeq = 0.

DO FOR bToolbarSO, bToolbarOBJ:

 FOR 
 EACH ryc_attribute_value 
      WHERE ryc_attribute_value.attribute_label = 'toolbarbands' NO-LOCK,
 EACH ryc_object_instance OF ryc_attribute_value NO-LOCK,
 EACH ryc_smartObject OF ryc_object_instance NO-LOCK
 BREAK BY ryc_attribute_value.attribute_value WITH WIDTH 165 DOWN :
  ACCUMULATE ryc_attribute_value.attribute_value (COUNT BY ryc_attribute_value.attribute_value). 
  DO TRANSACTION  ON ERROR UNDO, RETURN ERROR :
    IF FIRST-OF(ryc_attribute_value.attribute_value) THEN
    DO:
      cBandList = ''.
      FOR EACH ttBand:
        DELETE ttBand.
      END.

      DO iBand = 1 TO NUM-ENTRIES(ryc_attribute_value.attribute_value):
        CREATE ttband.
        ASSIGN 
          ttband.bandname = ENTRY(iBand,ryc_attribute_value.attribute_value).
      END.

      /* Make a sorted bandlist */ 
      FOR EACH ttband,
      EACH ryc_band WHERE ryc_band.band_name = ttband.bandname NO-LOCK 
      BY ryc_band.band_sequence:
        cBandlist = cBandlist 
                  + (IF cbandlist = '' THEN '' ELSE ',')
                  + ttband.bandname.
      END.

      /* check if toolbar with this bandlist exists (may be imported) */
      FIND ttToolbar WHERE ttToolbar.Bandlist = cBandList NO-ERROR.
      IF NOT AVAIL ttToolbar THEN
      DO:
        CREATE ttToolbar.
        ASSIGN 
          iSeq      = iSeq + 1
          ttToolbar.ObjectName = gcToolBarname + STRING(iSEq,'99')
          ttToolbar.Bandlist   = cBandlist.
      END.
      
      FIND btoolbarSO WHERE bToolbarSO.OBJECT_filename = ttToolbar.Objectname
         NO-LOCK NO-ERROR. 

      IF NOT AVAIL bToolbarSO THEN
      DO:
        FIND gsc_object WHERE gsc_object.OBJECT_obj = ryc_smartObject.OBJECT_obj
        NO-LOCK.

        CREATE bToolbarSO.
        CREATE bToolbarObj.
        ASSIGN 
         bToolbarSO.object_filename        = ttToolbar.ObjectName 
         bToolbarSO.OBJECT_obj             = bToolbarObj.OBJECT_obj
         /* Copy module, object type and layout from the physical toolbar .. */ 
         bToolbarSO.product_module_obj     = gdModule
         bToolbarSO.object_type_obj        = gsc_object_type.object_type_obj
         bToolbarSO.Layout_obj             = ryc_smartObject.Layout_obj 
         bToolbarSO.Custom_super_procedure = ryc_smartObject.Custom_super_procedure
         bToolbarSO.Static_object          = NO /* just for show..   default,*/
         .
        ASSIGN
          bToolbarObj.object_filename     = bToolbarSO.object_filename
          bToolbarObj.physical_object_obj = gsc_object.OBJECT_obj
          bToolbarObj.product_module_obj  = gdModule
          bToolbarObj.object_type_obj     = gsc_object_type.object_type_obj
          bToolbarObj.container_object    = gsc_object.container_object
          btoolbarObj.generic_object      = NO
          btoolbarObj.logical_object      = YES
          btoolbarObj.Object_Description  = bToolbarObj.object_filename   
          btoolbarObj.RUN_when            = gsc_object.RUN_when
          btoolbarObj.runnable_from_menu  = gsc_object.runnable_from_menu
          .
      
          RUN showstep(bToolbarObj.object_filename ).
        iBand = 0.
        FOR EACH ttband,
        EACH ryc_band WHERE ryc_band.band_name = ttband.bandname NO-LOCK 
        BY ryc_band.band_sequence
        ON ERROR UNDO, RETURN ERROR :
          iBand =  iBand + 1.
          FIND gsm_MENU_structure 
          WHERE gsm_menu_structure.menu_structure_code  = ttband.bandname NO-LOCK.
      
         CREATE gsm_toolbar_menu_structure.
         ASSIGN 
           gsm_toolbar_menu_structure.object_obj               = btoolbarObj.OBJECT_obj 
           gsm_toolbar_menu_structure.MENU_structure_obj       = gsm_menu_structure.MENU_structure_obj
           gsm_toolbar_menu_structure.MENU_structure_sequence  = iBand
           gsm_toolbar_menu_structure.MENU_structure_alignment =
           IF    ryc_band.band_alignment    = "LEF" THEN "Left" 
           ELSE  IF ryc_band.band_alignment = "RIG" THEN "Right" 
           ELSE                                          "Center".
         RUN showstep(' ' 
                     + STRING(gsm_toolbar_menu_structure.MENU_structure_sequence,'zzz9')
                     + ' ' + ttBand.bandname + ' ' 
                     +  gsm_toolbar_menu_structure.MENU_structure_alignment).
        END. 
      END. /* not avail toolbar */
    END. /* first of */
    FIND bAttrValue WHERE battrValue.attribute_value_obj = ryc_attribute_value.attribute_value_obj
    EXCLUSIVE-LOCK.
    FIND bInstance WHERE binstance.OBJECT_instance_obj = ryc_object_instance.OBJECT_instance_obj
    EXCLUSIVE-LOCK.
    ASSIGN 
      bAttrValue.smartobject_obj = bToolbarSO.smartobject_obj
      bInstance.smartobject_obj  = bToolbarSO.smartobject_obj.
  END. /* transaction */
  
  IF LAST-OF(ryc_attribute_value.attribute_value) THEN DO:
     iInstances = 
         ACCUM COUNT BY ryc_attribute_value.attribute_value ryc_attribute_value.attribute_value.
     
     IF iInstances = 1 THEN
       FIND bContainer WHERE bContainer.SmartObject_obj = 
                      ryc_object_instance.container_smartobject_obj NO-LOCK.

     RUN showstep("Changed "  
                  +  STRING(iInstances)
                  + ' ' + gsc_object.object_filename
                  + (IF iInstances = 1 
                     THEN " instance in container " + bContainer.object_filename
                     ELSE " instances") 
                  + " to "  +  bToolbarSO.object_filename 
                  ).
     RUN showstep('').  
   END.
 END. /* for each */
END. /* do for */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createToolbarTT C-Win 
PROCEDURE createToolbarTT :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE BUFFER bObj FOR gsc_object.
  FIND bobj WHERE bobj.OBJECT_filename BEGINS 'rydyntool' .
  FOR each gsc_object WHERE gsc_Object.physical_object_obj = bobj.OBJECT_obj.
    FIND FIRST ttToolbar WHERE tttoolbar.objectname = gsc_Object.object_filename
        NO-ERROR.

    IF NOT AVAIL tttoolbar THEN 
    DO:    
      CREATE tttoolbar. 
       tttoolbar.objectname = gsc_Object.object_filename.
    END.

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY gcToolbarName gcFile gcLog gcLoad glTrans gcLogFile 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE gcToolbarName gdModule gcFile gcLog gcLoad glTrans gcLogFile buStart 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE finalReport C-Win 
PROCEDURE finalReport :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/    
run showstep('Final layout of toolbars' ).
run showstep('<underline>' ).

FIND gsc_object_type NO-LOCK
    WHERE gsc_object_type.OBJECT_type_code = "SmartToolbar".
FOR EACH gsc_object NO-LOCK  
    WHERE gsc_object.LOGICAL OF gsc_Object_type: 
  RUN showStep(gsc_object.OBJECT_filename). 
  FOR EACH gsm_toolbar_menu_structure NO-LOCK OF gsc_object,
      gsm_MENU_structure OF gsm_toolbar_menu_structure :
    FIND gsm_menu_item NO-LOCK 
         WHERE gsm_menu_item.MENU_item_obj = gsm_MENU_structure.MENU_item_obj NO-ERROR.
    RUN showstep(' ' + 
                 string(gsm_toolbar_menu_structure.menu_structure_sequence) 
                 + ' ' +
                 gsm_MENU_structure.MENU_structure_code 
                 + ' ' +
                 gsm_MENU_structure.MENU_structure_type
                 + IF AVAIL gsm_menu_item 
                   THEN gsm_menu_item.MENU_item_label ELSE '').
    RUN showStructure(gsm_MENU_structure.MENU_structure_obj,1).
  END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fixBands C-Win 
PROCEDURE fixBands :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cBandlist    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cBand        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iBand        AS INTEGER    NO-UNDO.
 
/* First check for potential invalid band references and remove them if found
   This is done to avoid creating an extra new toolbars because an instance had 
   an invalid band reference. */  
RUN showstep("Checking for invalid bands in toolbar instances.").
RUN showstep('<underline>'). 

FOR EACH ryc_attribute_value 
    WHERE ryc_attribute_value.attribute_label = 'toolbarbands' NO-LOCK
    ON ERROR UNDO, RETURN ERROR:
   
  cBandList = ryc_attribute_value.attribute_value. 
  DO iBand = 1 TO NUM-ENTRIES(ryc_attribute_value.attribute_value):
     
    IF NOT CAN-FIND(ryc_band WHERE ryc_band.band_name = ENTRY(iBand,ryc_attribute_value.attribute_value)) THEN
    DO:
      FIND ryc_object_instance OF ryc_attribute_value NO-LOCK NO-ERROR.
      FIND ryc_smartObject OF ryc_object_instance NO-LOCK NO-ERROR.
      FIND bcontainer 
         WHERE bcontainer.smartobject_obj = ryc_object_instance.container_smartObject_obj
       NO-LOCK NO-ERROR.  
      RUN showstep("Invalid band "
                 +  ENTRY(iBand,cBandlist) 
                 + (IF AVAIL bContainer 
                    THEN ' removed from container ' + bcontainer.OBJECT_filename 
                    ELSE ' with no container ')).
      ENTRY(iBand,cBandlist) = '':U.
      cBandList = TRIM(REPLACE(','+ cBandList + ',',',,',','),',').
    END.
  END.
  
  IF cBandList <> ryc_attribute_value.attribute_value THEN
  DO TRANSACTION ON ERROR UNDO, RETURN ERROR:
    FIND battrvalue WHERE battrvalue.attribute_value_obj = 
                    ryc_attribute_value.attribute_value_obj EXCLUSIVE.  
    ASSIGN battrvalue.attribute_value = cBandList.
  END. 
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadOldRecords C-Win 
PROCEDURE loadOldRecords :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
 INPUT FROM VALUE(SEARCH(gcLoad + '/gsmms.d')).

 REPEAT:
  CREATE tOldgsm_menu_structure.
  IMPORT tOldgsm_menu_structure.
 END.
 
 FOR EACH tOldgsm_menu_structure.
   IF tOldgsm_menu_structure.MENU_structure_OBJ = 0 THEN
     DELETE tOldgsm_menu_structure.
 END.

 INPUT FROM VALUE(SEARCH(gcLoad + '/gsmmi.d')).

 REPEAT:
   CREATE tOldgsm_menu_item.
   IMPORT tOldgsm_menu_item.
 END.

 FOR EACH tOldgsm_menu_item.
   IF tOldgsm_menu_item.MENU_ITEM_OBJ = 0 THEN
     DELETE tOldgsm_menu_item.
 END.
 
 INPUT FROM VALUE(SEARCH(gcLoad + '/gsmom.d')).

 REPEAT:
   CREATE tOldgsm_object_menu_structure.
   IMPORT tOldgsm_object_menu_structure.
 END.

 FOR EACH tOldgsm_object_menu_structure.
   IF tOldgsm_object_menu_structure.object_menu_structure_OBJ = 0 THEN
     DELETE tOldgsm_object_menu_structure.
 END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE moveToolbarStruct C-Win 
PROCEDURE moveToolbarStruct :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER dStrobj    AS DECIMAL DECIMALS 6   NO-UNDO.
DEFINE INPUT  PARAMETER iinsertafter AS INTEGER    NO-UNDO.

DEF BUFFER bStructItem FOR gsm_toolbar_menu_structure.

FOR EACH bStructItem EXCLUSIVE
    WHERE bStructitem.object_obj = dSTROBJ
    AND   bStructitem.MENU_structure_sequence > iinsertafter
    BY    bStructitem.menu_structure_obj 
    BY    bStructitem.MENU_structure_sequence DESC :
   
   bStructitem.MENU_structure_sequence =  bStructitem.MENU_structure_sequence + 1.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE normalizeMenuItems C-Win 
PROCEDURE normalizeMenuItems :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------ ------------------------------------------------------*/
 DEFINE BUFFER btOldItem      FOR tOldgsm_menu_item.
 
 DEFINE BUFFER bItem       FOR gsm_menu_item.
 DEFINE BUFFER bChangeItem FOR gsm_menu_item.
 DEFINE BUFFER bAnyItem    FOR gsm_menu_item.
 DEFINE BUFFER bOldChild   FOR gsm_menu_item.

 /*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------ ------------------------------------------------------*/
 
 DEFINE VARIABLE cRef      AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDiff     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iDiff     AS INTEGER    NO-UNDO.
 DEFINE VARIABLE iNum      AS INTEGER    NO-UNDO.
 DEFINE VARIABLE lFirst    AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE lChange   AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE hBuf1     AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hBuf2     AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hFld1     AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hFLd2     AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cFld      AS CHARACTER  NO-UNDO.

 RUN showstep("Normalizing menu items").
 RUN showstep("<underline>").
 hBuf1 =  BUFFER  gsm_menu_item:HANDLE.
 hBuf2 =  BUFFER  bItem:HANDLE.

 FOR EACH gsm_menu_item NO-LOCK 
     BY (IF gsm_menu_item.MENU_item_reference BEGINS 'adm2'
         THEN 1 
         ELSE 2)
     BY gsm_menu_item.MENU_item_obj
     ON ERROR UNDO,RETURN ERROR: 

   lFirst = TRUE.
   
   FIND tOldgsm_menu_item 
       WHERE toldgsm_menu_item.MENU_item_obj = gsm_menu_item.MENU_item_obj
       NO-ERROR.
   
   FOR EACH bItem  EXCLUSIVE-LOCK
       WHERE bItem.MENU_item_label  = gsm_menu_item.MENU_item_label
       AND   bItem.MENU_item_obj    > gsm_menu_item.MENU_item_obj
       ON ERROR UNDO,RETURN ERROR:
     
     FIND btOlditem 
         WHERE btolditem.MENU_item_obj = bitem.MENU_item_obj NO-ERROR.


     lChange = false.
     cRef = ''. 
     
     /* Just in case */  
     IF (AVAIL btOlditem AND btOldItem.ruler_menu_item) AND bItem.MENU_item_label <> '' THEN
        NEXT.
     
     /* skip all the web stuff */  
     IF (AVAIL btolditem AND NOT btOldItem.ruler_menu_item
         OR NOT AVAIL btOlditem) AND bItem.MENU_item_label = '' THEN
        NEXT.

     IF (AVAIL tOldgsm_menu_item AND tOldgsm_menu_item.ruler_menu_item) 
     AND (AVAIL btolditem AND btOldItem.ruler_menu_item) THEN
       ASSIGN cRef    = 'RULE'
              lChange = TRUE.

     ELSE DO:
       BUFFER-COMPARE gsm_menu_item 
         EXCEPT 
          MENU_item_reference
          MENU_item_obj
          /*
          disable_rule
          ENABLE_rule
          HIDE_rule
          VIEW_rule
          */
          /* has become image1_up_filename */
          /*,toolbar_image_sequence  ??*/
          /* has become item_select_parameter */
           /* has become item_select_sction */
           /* has become item_link_list */
       TO bItem
        SAVE cDiff.
       
       /* don't allow two action just for this..
        (this is really a hack for delete...) */
       IF cdiff  = 'shortcut_key' THEN
       DO:
         IF gsm_menu_item.shortcut_key = '' THEN
         DO:
           
           FIND bChangeItem EXCLUSIVE
               WHERE bChangeItem.menu_item_obj = gsm_menu_item.menu_item_obj.

           RUN showstep('Copied shortcut key '
                         +  bitem.shortcut_key + ' from '  
                         +  bitem.MENU_item_reference
                         + ' to '
                         +  bChangeitem.MENU_item_reference
                        ).
           ASSIGN bChangeitem.shortcut_key = bitem.shortcut_key.
           
           cDiff = TRIM(REPLACE("," + cdiff + ",",',shortcut_key,',''),',').  
         END.
         ELSE IF bitem.shortcut_key = '' THEN
         DO:
           RUN showstep('Copied shortcut key '
                         +  gsm_menu_item.shortcut_key + ' from ' 
                         +  gsm_menu_item.MENU_item_reference
                         + ' to '
                         +  bitem.MENU_item_reference
                         ).

           bitem.shortcut_key = gsm_menu_item.shortcut_key.
           cDiff = TRIM(REPLACE("," + cdiff + ",",',shortcut_key,',''),',').  
         END.
       END.      
       IF cDiff = 'image1_up_filename'
       OR cDiff = 'tooltip_text'
       OR (NUM-ENTRIES(cDiff) = 2 
           AND CAN-DO(cDiff,'tooltip_text') 
           AND CAN-DO(cdiff,'image1_up_filename')) THEN
       DO:
         RELEASE ryc_action.
         IF bItem.image1_up_filename = ' ' 
         AND (   bitem.TOOLTIP_text = gsm_menu_item.tooltip_text
              OR bitem.TOOLTIP_text = '') THEN
         DO:
           FIND ryc_action NO-LOCK
              WHERE ryc_action.action_reference = bItem.MENU_item_reference
             NO-ERROR.
           IF NOT AVAIL ryc_action 
           OR (AVAIL ryc_action AND NOT ryc_action.place_action_on_toolbar) THEN
             ASSIGN
               bItem.image1_up_filename = gsm_menu_item.image1_up_filename
               bItem.tooltip_text       = gsm_menu_item.tooltip_text                             
               cDiff = ''.
         END.
         ELSE IF gsm_menu_item.image1_up_filename = '':U 
             AND (   bitem.TOOLTIP_text = gsm_menu_item.tooltip_text
                  OR gsm_menu_item.TOOLTIP_text = '') THEN
         DO:
           FIND ryc_action  NO-LOCK
                WHERE ryc_action.action_reference = gsm_menu_item.MENU_item_reference
             NO-ERROR.
         
           IF NOT AVAIL ryc_action 
           OR (AVAIL ryc_action AND NOT ryc_action.place_action_on_toolbar) THEN
           DO:
             FIND bChangeItem EXCLUSIVE
               WHERE bChangeItem.menu_item_obj = gsm_menu_item.menu_item_obj.
             ASSIGN
              bcHANGEItem.image1_up_filename = BiTEM.image1_up_filename
              cDiff = ''.
           END.
         END.

       END.
       lChange = cDiff = ''.
     END.

     IF lChange THEN
     DO:
       IF cREF = '' THEN
       DO:
          IF INDEX(gsm_menu_item.menu_item_reference,'_') > 0 THEN
          DO:
           /* See if label can be used as item ref */ 
           cRef = REPLACE(entry(1,gsm_menu_item.menu_item_label,' '),'&','').
         
           iNum = 1. /* Skip 1 and start on 2 */
           DO WHILE TRUE: 
             IF CAN-FIND(banyItem WHERE bAnyItem.menu_item_reference = cRef) THEN
             DO:
               ASSIGN 
                iNum    = iNum + 1 
                cRef    = REPLACE(entry(1,gsm_menu_item.menu_item_label,' '),'&','')
                          + '-' + STRING(iNum).
             END.
             ELSE LEAVE.
           END.
         END.
       END.

       IF lFirst THEN
       DO:    
         IF cRef <> ''  THEN
         DO:
           RUN showstep('Normalized: '
                      + SUBSTR(gsm_menu_item.item_control_type,1,1)
                      + lc(SUBSTR(gsm_menu_item.item_control_type,2))
                      + ' ' +
                      gsm_menu_item.MENU_item_label
                      + ' reference changed from ' 
                      + gsm_menu_item.MENU_item_reference
                      + ' to ' + cRef). 
         
          FIND bChangeItem EXCLUSIVE
             WHERE bChangeItem.menu_item_obj = gsm_menu_item.menu_item_obj.
           bChangeItem.MENU_item_reference = cRef.
         END.
         ELSE 
           RUN showstep('Normalized: '
                      + SUBSTR(gsm_menu_item.item_control_type,1,1)
                      + lc(SUBSTR(gsm_menu_item.item_control_type,2))
                      + ' ' +
                      gsm_menu_item.MENU_item_label
                      + ' (' 
                      + gsm_menu_item.MENU_item_reference
                      + ')'
                        ).

         lFirst = FALSE.
       END.
       
       /* avoid trigger problems */
       FOR EACH gsm_menu_structure_item EXCLUSIVE
           WHERE gsm_menu_structure_item.menu_item_obj = bItem.menu_item_obj:
          
         FIND gsm_menu_structure OF gsm_menu_structure_item NO-LOCK.
           
         gsm_menu_structure_item.menu_item_obj = gsm_menu_item.menu_item_obj.

         RUN showstep(' Replacing ' + bItem.MENU_item_reference
                      + ' as child of ' 
                      + gsm_menu_structure.menu_structure_code ). 
       END.
       FOR EACH gsm_menu_structure EXCLUSIVE
           WHERE gsm_menu_structure.menu_item_obj = bItem.menu_item_obj:
          
         gsm_menu_structure.menu_item_obj = gsm_menu_item.menu_item_obj.

         RUN showstep(' Replacing ' + bItem.MENU_item_reference
                      + ' as default label for '
                      + gsm_menu_structure.menu_structure_code ). 
       END.
       RUN showstep(' Deleting ' + bItem.MENU_item_reference ).
 
       RUN showstep('').
       DELETE bItem.
     END.
     ELSE
     DO:        
       RUN showstep('Not normalized: ' + bItem.MENU_item_label 
                    + ' (' +  gsm_menu_item.MENU_item_reference  + ')'
                    + ' (' +  bItem.MENU_item_reference  + ')').

       RUN showstep('Differences: ' ).
       DO iDiff = 1 TO NUM-ENTRIES(cDiff):
         cfld = ENTRY(iDiff,cdiff).
         hFld1 = hBuf1:BUFFER-FIELD(cFld).
         hFld2 = hBuf2:BUFFER-FIELD(cFld).
         RUN showstep('    ' + hFld1:NAME + ': '  
                    + "'"  +  hFld1:BUFFER-VALUE + "'" 
                    + "  '"  +  hFld2:BUFFER-VALUE + "'" ).
                    
       END.

       RUN showstep('').        
     END.
   END.
 END.
     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE renameItems C-Win 
PROCEDURE renameItems :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE BUFFER bitem FOR gsm_menu_item.
 DEFINE BUFFER banyitem FOR gsm_menu_item.

 DEFINE VARIABLE cNewName AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cName    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iNum     AS INTEGER    NO-UNDO.

 RUN showStep('Renaming menus items').
 RUN showStep('<underline>').

 FOR EACH gsm_menu_item NO-LOCK:

   cNewName = REPLACE(gsm_menu_item.MENU_item_reference,'Astra','').
   cNewName = REPLACE(cNewName,'Adm2','').
   
   IF cNewName <> gsm_menu_item.MENU_item_reference THEN
   DO:
     FIND bItem EXCLUSIVE 
          WHERE bItem.MENU_item_obj = gsm_menu_item.MENU_item_obj NO-ERROR.
     
     iNum = 1. /* start on 2 */  
     cName = cnewname.
     DO WHILE TRUE:
       IF CAN-FIND(bAnyItem WHERE bAnyItem.MENU_item_reference = cName) THEN
       DO:
         ASSIGN 
           iNum   = iNum + 1
           cName  = cNewName + STRING(iNum).
       END.
       ELSE LEAVE.
     END.
     RUN showstep("Renamed item ref '"
                        + bItem.MENU_item_reference
                        + "' to '" 
                        + cName + "'").
     bItem.MENU_item_reference = cName.
   END.
 END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE renameMenus C-Win 
PROCEDURE renameMenus :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE BUFFER bMenu FOR gsm_menu_structure.
 DEFINE BUFFER bAnyMenu FOR gsm_menu_structure.

 DEFINE VARIABLE cNewName AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cName    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE iNum     AS INTEGER    NO-UNDO.
 DEFINE VARIABLE ldesc   AS LOGICAL    NO-UNDO.

 RUN showStep('Renaming menus').
 RUN showStep('<underline>').

 FOR EACH gsm_menu_structure NO-LOCK:
   lDesc = gsm_menu_structure.menu_structure_code = 
                gsm_menu_structure.menu_structure_description. 
   cNewName = REPLACE(gsm_menu_structure.menu_structure_code,'Astra','').
   cNewName = REPLACE(cNewName,'Adm2','').
   
   IF cNewName <> gsm_menu_structure.menu_structure_code THEN
   DO:
     FIND bMenu EXCLUSIVE 
          WHERE bMenu.MENU_structure_obj  = gsm_menu_structure.MENU_structure_obj NO-ERROR.
     
     iNum = 1. /* start on 2 */  
     cName = cnewname.
     DO WHILE TRUE:
       IF CAN-FIND(bAnyMenu WHERE bAnyMenu.menu_structure_code = cName) THEN
       DO:
         ASSIGN 
           iNum   = iNum + 1
           cName  = cNewName + STRING(iNum).
       END.
       ELSE LEAVE.
     END.
     RUN showstep("Renamed menu code '"
                        + bMenu.menu_structure_code
                        + "' to '" 
                        + cName + "'").
     bMenu.menu_structure_code = cName.
     bMenu.menu_structure_description = cNewName.
   END.
 END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sequenceObjectMenus C-Win 
PROCEDURE sequenceObjectMenus :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VARIABLE iSeq AS INTEGER    NO-UNDO.
 RUN showStep('Adding sequence to object menus').
 RUN showStep('<underline>').

 FOR EACH gsc_object NO-LOCK:
   iSeq = 0.
   FOR EACH gsm_object_menu_structure EXCLUSIVE-LOCK OF gsc_object,
   EACH gsm_menu_structure NO-LOCK OF gsm_object_menu_structure
   BY gsm_object_menu_structure.OBJECT_obj
   BY gsm_menu_structure.menu_structure_code:
     iSeq = iSeq + 1.
     gsm_object_menu_structure.MENU_structure_sequence = iSeq.
   END.
 END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showstep C-Win 
PROCEDURE showstep :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER pcStep AS CHARACTER  NO-UNDO.
  
 DEFINE VARIABLE cLine AS CHARACTER  NO-UNDO.

 IF pcStep = '<underline>' THEN
 DO:
   cLine = fill('-',80).
   pcStep = cLine.
 END.

 gcLog:INSERT-STRING(pcStep + CHR(10)) IN FRAME {&FRAME-NAME}.
 
 
 PUT STREAM convlog UNFORMATTED IF pcStep <> '' THEN pcStep ELSE '   '  SKIP. 
 
  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showStructure C-Win 
PROCEDURE showStructure :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pdObj   AS DECIMAL NO-UNDO.
  DEFINE INPUT  PARAMETER piLevel AS INTEGER NO-UNDO.

  DEFINE BUFFER bstruct FOR gsm_menu_structure.

  FOR EACH gsm_menu_structure_item NO-LOCK WHERE 
           gsm_menu_structure_item.MENU_structure_obj = pdObj:

    FIND gsm_menu_item NO-LOCK
         WHERE gsm_menu_item.menu_item_obj 
                         = gsm_menu_structure_item.menu_item_obj no-error.
    FIND bStruct NO-LOCK 
        WHERE bstruct.MENU_structure_obj 
                   = gsm_menu_structure_item.child_MENU_structure_obj NO-ERROR.
    RUN showStep(' ' + FILL('-',pilevel)                  
                 +  ' ' 
                 + (IF AVAIL bStruct 
                    THEN bStruct.MENU_structure_code + ' ' 
                    ELSE '')

                 + (IF AVAIL gsm_menu_item 
                    THEN gsm_menu_item.MENU_item_reference
                    ELSE '')
                 ).
    IF gsm_menu_structure_item.child_MENU_structure_obj <> 0 THEN
      RUN showStructure(gsm_menu_structure_item.child_MENU_structure_obj,
                        piLevel + 1).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showToolbars C-Win 
PROCEDURE showToolbars :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/    
run showstep('Final layout of toolbars' ).
run showstep('<underline>' ).

FIND gsc_object_type NO-LOCK
    WHERE gsc_object_type.OBJECT_type_code = xcObjectType.
FOR EACH gsc_object NO-LOCK  
    WHERE gsc_object.LOGICAL OF gsc_Object_type
    BY gsc_object.OBJECT_filename: 
  RUN showStep(gsc_object.OBJECT_filename). 
  FOR EACH gsm_toolbar_menu_structure NO-LOCK OF gsc_object,
      gsm_MENU_structure OF gsm_toolbar_menu_structure :
    FIND gsm_menu_item NO-LOCK 
         WHERE gsm_menu_item.MENU_item_obj = gsm_MENU_structure.MENU_item_obj NO-ERROR.
    RUN showstep(' ' + 
                 gsm_MENU_structure.MENU_structure_code 
                 + ' ' +
                 gsm_MENU_structure.MENU_structure_type
                 + ' ' +
                  (IF AVAIL gsm_menu_item 
                   THEN gsm_menu_item.MENU_item_label ELSE '')
                  ).
    RUN showStructure(gsm_MENU_structure.MENU_structure_obj,1).
  END.
  RUN showStep(''). 
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showUnusedBands C-Win 
PROCEDURE showUnusedBands :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE BUFFER bMenu FOR gsm_menu_structure.

 RUN showStep('Not used menu structures').
 RUN showstep('<underline>').

 FOR EACH gsm_menu_structure NO-LOCK:
    IF   NOT CAN-FIND(FIRST gsm_toolbar_menu_structure OF gsm_menu_structure)
    AND  NOT CAN-FIND(FIRST gsm_OBJECT_menu_structure OF gsm_menu_structure) 
    AND  NOT CAN-FIND(FIRST gsm_menu_structure_item 
                            WHERE gsm_menu_structure_item.child_menu_structure_obj =
                                  gsm_menu_structure.menu_structure_obj)   THEN
    DO:
      RUN showstep(gsm_menu_structure.menu_structure_code).
      FOR EACH gsm_menu_structure_item OF gsm_menu_structure EXCLUSIVE:
         FIND gsm_MENU_item NO-LOCK 
             WHERE GSM_menu_item.MENU_item_obj
                                     = gsm_menu_structure_item.MENU_item_obj.
         IF AVAIL gsm_MENU_item THEN
         RUN showstep(" item "
                         + GSM_menu_item.menu_item_reference
                       ).

        /* DELETE gsm_menu_structure_item. */
      END.
      FIND bMenu EXCLUSIVE 
          WHERE bMenu.MENU_structure_obj  = gsm_menu_structure.MENU_structure_obj NO-ERROR.
      /* DELETE bMenu. */
    END.
 END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE splitBands C-Win 
PROCEDURE splitBands :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE iCount        AS INTEGER FORMAT 'zzz9'  NO-UNDO.
DEFINE VARIABLE iToolBarCount AS INTEGER FORMAT 'zzz9'  NO-UNDO.
DEFINE VARIABLE iMenuCount    AS INTEGER FORMAT 'zzz9'  NO-UNDO.
DEFINE VARIABLE cType         AS CHARACTER              NO-UNDO.
DEFINE VARIABLE lChange       AS LOGICAL                NO-UNDO.
DEFINE VARIABLE cRef          AS CHARACTER              NO-UNDO.
DEFINE VARIABLE iSeq          AS INTEGER                NO-UNDO.
DEFINE VARIABLE iToolSeq      AS INTEGER                NO-UNDO.

DEFINE BUFFER bstruct    FOR gsm_MENU_structure.
DEFINE BUFFER bNewstruct FOR gsm_MENU_structure.
DEFINE BUFFER bAnyStruct FOR gsm_MENU_structure.
DEFINE BUFFER bNewItem   FOR gsm_menu_structure_item.
DEFINE BUFFER bToolstr   FOR gsm_toolbar_menu_structure.

RUN showstep("Setting menu structure type and splitting menus if two types required").
RUN showstep("<underline>").

FOR EACH gsm_MENU_structure NO-LOCK 
         WHERE gsm_menu_structure.MENU_structure_type = 'menu&toolbar':
  ASSIGN iCount = 0
         iToolbarCount = 0
         iMenuCount = 0
         ctype = gsm_menu_structure.MENU_structure_type.

  FOR EACH gsm_menu_structure_item OF gsm_MENU_structure NO-LOCK,
      EACH gsm_menu_item 
      WHERE gsm_menu_structure_item.MENU_item_obj = gsm_menu_item.menu_item_obj,
      ryc_action WHERE ryc_action.action_reference = 
                     gsm_menu_item.menu_item_reference NO-LOCK: 
    ASSIGN 
      iToolbarCount = iToolbarCount 
                    + IF place_action_on_toolbar THEN 1 ELSE 0
      iMenuCount    = iMenuCount 
                    + IF place_action_on_menu THEN 1 ELSE 0
      iCount = iCOunt + 1.
  END.

  
  lChange = FALSE.

  IF iCount <> iToolbarCount OR iCount <> iMenuCount THEN
  DO:
    cRef = '':U.
    FIND bStruct WHERE bStruct.menu_structure_code = 
                       gsm_menu_structure.menu_structure_code EXCLUSIVE.

    /* Keep the toolbar if possible as the toolbar_menu_structure alignment
       etc are needed for these  */
    IF iToolbarCount = 0 THEN
      ASSIGN
        bStruct.menu_structure_type = "SubMenu".
    ELSE 
      ASSIGN
        bStruct.menu_structure_type = "Toolbar"
        lChange                     = iMenuCount > 0.
    
    IF bStruct.menu_structure_type <> 'Menu&Toolbar' THEN
       RUN showStep('Changed structure '
                    + bStruct.menu_structure_code 
                    + " to type '"
                    + bStruct.menu_structure_type
                    + "'").

    IF lChange THEN 
    DO:    
      CREATE bNewStruct.
      BUFFER-COPY bStruct 
                  EXCEPT MENU_structure_obj
                         menu_structure_code 
                         menu_structure_type  
      TO bNewStruct.  

      ASSIGN 
        cRef = bStruct.menu_structure_code + "SubMenu"
        iSeq = 1. 
      DO WHILE TRUE:
        IF CAN-FIND(banyStruct WHERE bAnyStruct.MENU_structure_code = Cref) THEN
        DO: 
          ASSIGN
            iSeq = iseq + 1
            cRef =  bStruct.menu_structure_code + "SubMenu" + STRING(iSeq).
        END.
        ELSE LEAVE.
      END.

      ASSIGN 
        bNewStruct.menu_structure_type = "SubMenu"
        bNewStruct.menu_structure_code = cRef
        bStruct.MENU_item_obj          = 0. /* Only the menu need the label */
      
      RUN showStep('Created structure ' 
                   + bNewStruct.menu_structure_code
                   + " as type '"
                   + bNewStruct.menu_structure_type
                   + "'"). 

      FOR EACH gsm_toolbar_menu_structure OF gsm_menu_structure NO-LOCK: 
         
         FIND gsc_object OF gsm_toolbar_menu_structure NO-LOCK.
         
         CREATE bToolstr.
         BUFFER-COPY gsm_toolbar_menu_structure
                     EXCEPT toolbar_menu_structure_obj
                            MENU_structure_obj 
                            menu_structure_sequence
                     TO bToolstr.
         RUN moveToolbarStruct(gsm_toolbar_menu_structure.object_obj,
                               gsm_toolbar_menu_structure.MENU_structure_sequence).
         ASSIGN 
           bToolstr.MENU_structure_sequence = gsm_toolbar_menu_structure.MENU_structure_sequence + 1
           bToolStr.MENU_structure_obj = bNewStruct.MENU_structure_obj.
         
         VALIDATE BTOOLSTR NO-ERROR.
         IF RETURN-VALUE <> '' THEN
         DO:
           RUN SHOWSTEP(RETURN-VALUE).
           RETURN ERROR.
         END.

         RUN showStep(' Inserted on toolbar ' + gsc_object.OBJECT_filename 
                      + ' sequence ' 
                      + STRING( bToolstr.MENU_structure_sequence )
                      ).
      END.

      FOR EACH  gsm_menu_structure_item OF gsm_MENU_structure EXCLUSIVE-LOCK,
        EACH  gsm_menu_item NO-LOCK
        WHERE gsm_menu_structure_item.MENU_item_obj = gsm_menu_item.menu_item_obj,
        EACH  ryc_action WHERE ryc_action.action_reference = 
                               gsm_menu_item.menu_item_reference :

        IF place_action_on_menu THEN
        DO:

          CREATE bNewItem.
          BUFFER-COPY gsm_menu_structure_item 
                      EXCEPT menu_structure_item_obj
                             MENU_structure_obj 
                      TO bNewItem.
          ASSIGN bNewItem.MENU_structure_obj = bNewStruct.menu_structure_obj.

          RUN showStep(' Item ' + gsm_menu_item.menu_item_reference 
                       + ' copied to '
                       + bNewStruct.menu_structure_code
                       + " of type '"
                       + bNewStruct.menu_structure_type
                       + "'"). 

        END.
        IF NOT place_action_on_toolbar THEN
        DO:
          RUN showStep(' Item ' + gsm_menu_item.menu_item_reference 
                       + ' deleted from '
                       + bstruct.menu_structure_code
                       + " of type '"
                       + bStruct.menu_structure_type
                       + "'"). 
          DELETE gsm_menu_structure_item.
        END.
      END.
    END.
  END.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startconvert C-Win 
PROCEDURE startconvert :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lSeparate  AS LOGICAL    NO-UNDO.
  IF NOT checkMenu() THEN RETURN. 
  
  IF gcFile:SCREEN-VALUE IN FRAME {&frame-name} = '' THEN
  DO:

    MESSAGE 'The File label must be entered exactly as it is in the submenu label' 
            ' of the bands.' 
      VIEW-AS ALERT-BOX ERROR.
    RETURN ERROR.
  END.

  IF search(gcToolbarFile) = ? THEN 
  DO:
    MESSAGE "The toolbar file:" gcToolbarfile "was not found." SKIP
            "This file is required to create the toolbars for the instances generated by rywizogenp.".
    RETURN.
  END.

  IF gdModule:SCREEN-VALUE = ? THEN
  DO:
    MESSAGE "Product module must be defined for the new toolbars.".
    APPLY 'ENTRY' TO gdModule.
    RETURN.
  END.

  input FROM VALUE(SEARCH(gcToolbarfile)).
  /* in case something was wrong after this the temp-tables may still be here */
  FOR EACH ttToolbar :
   DELETE tttoolbar.
  END.

  REPEAT:
    CREATE ttToolbar.
    IMPORT ttToolbar.Objectname
           tttoolbar.bandlist.     
  END.
  FOR EACH ttToolbar WHERE ttToolbar.Objectname = '' :
    DELETE tttoolbar.
  END.

  INPUT close.
    
  DO WITH frame {&FRAME-NAME}:
    ASSIGN 
       glTrans
       gcLogfile 
       gcToolbarName
       gdModule
       gcfile
       gcLoad .



    IF NOT glTrans THEN
    DO:
      MESSAGE
        "Running this in separate transactions requires a backup." SKIP(1)
        "Yes, use separate transactions." SKIP 
        "No, use one transaction."
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL
        UPDATE lSeparate.
      IF lSeparate = ? THEN RETURN.
      glTrans = NOT lSeparate.
      DISP glTrans.
    END.
  END.

  OUTPUT STREAM convlog TO VALUE(gclogfile).
  SESSION:SET-WAIT-STATE('general').
  IF glTrans THEN 
  DO TRANSACTION ON ERROR UNDO,LEAVE:
     RUN convertData.
  END.
  ELSE DO ON ERROR UNDO,LEAVE:
    RUN convertData.
  END.
  
  RUN showStep('').
  RUN showStep('Conversion ' +
               IF ERROR-STATUS:ERROR 
               THEN 'failed'
               ELSE 'complete'     ).
  SESSION:SET-WAIT-STATE('').
  OUTPUT STREAM convlog close.


  /*
  buStart:SENSITIVE = false.
   */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION checkMenu C-Win 
FUNCTION checkMenu RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cTop   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cLast  AS CHARACTER  NO-UNDO.
 
 DEFINE BUFFER bband FOR ryc_band.
 
 FOR EACH ryc_band NO-LOCK:
    
   IF CAN-FIND(gsm_menu_structure 
              WHERE gsm_menu_structure.menu_structure_code = ryc_band.band_name) THEN
   DO: 
     MESSAGE "The Band '" ryc_band.band_name "' also exists as a menu_structure."
              SKIP
             "Go to the Administration's Menu Maintenance and rename this Menu Code before continuing the conversion."         
         VIEW-AS ALERT-BOX INFO.
     RETURN FALSE.
   END.
 
   IF NUM-ENTRIES(ryc_band.band_submenu_label) > 2  THEN
   DO:
     cTop = ENTRY(1,ryc_band.band_submenu_label).
     cLast = ENTRY(num-entries(ryc_band.band_submenu_label),ryc_band.band_submenu_label).
     MESSAGE  
       "The submenus " ryc_band.band_submenu_label " on band '" 
        ryc_band.band_name 
       "' cannot be directly converted." SKIP         
       "Create the required submenus in the new maintenance tool after the conversion."
       SKIP
       "Do you want the conversion to use two levels and add it to the menubar?"  SKIP(1)
       "Yes - Add menu '" cTop "' to the menubar with '" cLast  "' as child." SKIP
       "No  - Do a manual change of the band before the conversion."  

     VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lanswer AS LOG.
     IF lanswer = ? THEN undo, RETURN FALSE.
     ELSE DO TRANSACTION:
       FIND bband WHERE bband.band_name = ryc_band.band_name exclusive.
       IF lanswer THEN
         ryc_band.band_submenu_label = cTop + "," + cLast.
       ELSE 
         RETURN FALSE.
       RELEASE bband.
     END.
   END.
 END.
 RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createItemCategory C-Win 
FUNCTION createItemCategory RETURNS DECIMAL
  ( pcNameOrLink AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cLink AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cName AS CHARACTER  NO-UNDO.

  IF NUM-ENTRIES(pcNameOrlink,'-') > 1 THEN
    ASSIGN
      cName = ENTRY(1,pcNameOrlink,'-')
      cLink = pcNameOrLink.
  ELSE
      cName = pcNameOrLink.
  
  FIND FIRST gsc_item_category NO-LOCK
      WHERE gsc_item_category.item_link  = cLink NO-ERROR.
  IF AVAIL gsc_item_category THEN
    RETURN gsc_item_category.item_category_obj.
    
  CREATE gsc_item_category.

  ASSIGN 
    gsc_item_category.item_category_label       = CAPS(SUBSTR(cName,1,1))
                                                  + SUBSTR(cName,2)
    gsc_item_category.item_category_description = gsc_item_category.item_category_label
                                                  + IF clink <> '' 
                                                    THEN ' action items'
                                                    ELSE ' items'
    gsc_item_category.item_link                   = cLink 
    gsc_item_category.system_owned                = TRUE. 

  run showStep('Created category '
               + gsc_item_category.item_category_label
               + ' ' + gsc_item_category.item_category_description).
  RETURN gsc_item_category.item_category_obj.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION deleteMenuStructure C-Win 
FUNCTION deleteMenuStructure RETURNS LOGICAL
  ( pccode AS char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE ldelete  AS LOGICAL    NO-UNDO.

  DEFINE BUFFER bStruct     FOR gsm_menu_structure. 
  DEFINE BUFFER bStructItem FOR gsm_menu_structure_item.
  DEFINE BUFFER btoolbar    FOR gsm_toolbar_menu_structure.
  DEFINE BUFFER bttMenu     FOR ttMenu.

  FIND bStruct WHERE bstruct.MENU_structure_code = pcCode NO-LOCK NO-ERROR.   
  IF NOT AVAIL bStruct THEN
      RETURN ?.

  IF CAN-FIND (FIRST bStructItem 
                WHERE bStructItem.child_MENU_structure_obj 
                    = bStruct.MENU_structure_obj) THEN 
     RETURN FALSE.
     
  IF bStruct.menu_structure_type = 'submenu' 
  AND NOT CAN-FIND(FIRST bttMenu WHERE bttMenu.CODE = bstruct.MENU_structure_code) THEN
     lDelete = TRUE.
        
  /* Delete empty structures  */
  ELSE IF bStruct.menu_structure_type = 'menu&toolbar'
  AND NOT CAN-FIND(FIRST bStructItem OF bStruct) 
  AND NOT CAN-FIND (FIRST bttMenu WHERE bttMenu.CODE = bstruct.MENU_structure_code 
                    AND   bttMenu.menulabel <> gcFile ) THEN
      lDelete = TRUE. 
     
  IF ldelete THEN
  DO:
    FOR EACH bStructItem OF bStruct EXCLUSIVE-LOCK:
       DELETE bStructItem.
    END.
    FOR EACH btoolbar OF bstruct EXCLUSIVE-LOCK: 
       DELETE bToolbar.
    END.
    FIND CURRENT bStruct EXCLUSIVE.
    RUN showStep ('Deleting menu structure ' +  bstruct.MENU_structure_code ).
    DELETE bStruct.
  END.       
     
  RETURN lDelete.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION dynamicItem C-Win 
FUNCTION dynamicItem RETURNS CHAR
  (pcRef AS CHAR):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

DEFINE BUFFER bitem FOR gsm_menu_item.

DEFINE VARIABLE iSeq    AS INTEGER    NO-UNDO.
DEFINE VARIABLE cRef    AS CHARACTER  NO-UNDO.

FIND gsm_menu_item WHERE gsm_menu_item.menu_item_reference = pcRef 
                   AND   gsm_menu_item.item_control_type = 'Placeholder'
                   NO-ERROR.

IF NOT AVAIL gsm_menu_item THEN
DO:
  cRef = pcRef.
  iSeq = 1. /* start on 2 */
  DO WHILE TRUE:
    IF CAN-FIND(bitem WHERE bitem.menu_item_reference = cRef) THEN
    DO:
      ASSIGN
         iseq = iseq + 1 
         cRef = pcRef + string(iSeq).
    END.
    ELSE 
      LEAVE.
  END.

  CREATE gsm_menu_item.
  ASSIGN
    gsm_menu_item.menu_item_reference   = cRef 
   /*
    gsm_menu_item.item_toolbar_label    = pcLabel
    gsm_menu_item.menu_item_label       = pcLabel 
   */
    gsm_menu_item.item_control_type     = 'Placeholder'
    gsm_menu_item.menu_item_description = cRef
    gsm_menu_item.toggle_menu_item      = FALSE. 
END.

RETURN gsm_menu_item.menu_item_reference.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION labelItem C-Win 
FUNCTION labelItem RETURNS DECIMAL
  (pcLabel AS CHAR):
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE BUFFER bitem FOR gsm_menu_item.

DEFINE VARIABLE iSeq    AS INTEGER    NO-UNDO.
DEFINE VARIABLE cRef    AS CHARACTER  NO-UNDO.

FIND gsm_menu_item WHERE gsm_menu_item.menu_item_label   = pcLabel 
                   AND   gsm_menu_item.item_control_type = 'Label'
                   NO-ERROR.


IF NOT AVAIL gsm_menu_item THEN
DO:
  cRef = REPLACE(pcLabel,'&','').
  iSeq = 1. /* start on 2 */
  DO WHILE TRUE:
    IF CAN-FIND(bitem WHERE bitem.menu_item_reference = cRef) THEN
    DO:
      ASSIGN
         iseq = iseq + 1 
         cRef = REPLACE(pcLabel,'&','') + string(iSeq).
    END.
    ELSE 
      LEAVE.
  END.

  CREATE gsm_menu_item.
  ASSIGN
    gsm_menu_item.menu_item_reference   = cRef 
    gsm_menu_item.item_toolbar_label    = pcLabel
    gsm_menu_item.menu_item_label       = pcLabel 
    gsm_menu_item.item_control_type     = 'Label'
    gsm_menu_item.menu_item_description = cRef
    gsm_menu_item.toggle_menu_item      = FALSE. 
END.

RETURN gsm_menu_item.menu_item_obj.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

