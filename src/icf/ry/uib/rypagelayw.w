&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          sports2000       PROGRESS
*/
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

  Modified: 11/27/2001          Mark Davies (MIP)
            Ask question before deleting page layout.
            Fix for issue #3308 - Save PageLayout overrides objects attribute
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

{adeuib/uibhlp.i}          /* Help File Preprocessor Directives         */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE hGenObj               AS HANDLE     NO-UNDO.
DEFINE VARIABLE iNumDataObjects       AS INTEGER    NO-UNDO.
/* Mode for adding Contained objects -- not to be confused with 
 * modes for adding layouts
 */
DEFINE VARIABLE laddMode              AS LOGICAL    NO-UNDO. /* object mode*/
DEFINE VARIABLE glNewObject           AS LOGICAL    NO-UNDO.
/* Shared Variable Definitions ---                                      */
{adeuib/uniwidg.i}

/* From sharvars.i - only want this shared var. */
DEFINE SHARED VAR _h_func_lib      AS HANDLE       NO-UNDO. 
DEFINE VARIABLE lEmpty             AS LOGICAL      NO-UNDO.  /* page layout mode*/
DEFINE VARIABLE lModified          AS LOGICAL      NO-UNDO.  /* page layout mode*/
DEFINE VARIABLE glDisplayRepository     AS LOGICAL          NO-UNDO.

{afglobals.i}
 
/* temp-table definitions */

DEFINE TEMP-TABLE ttObjectInfo NO-UNDO
    FIELD ttObjectName  AS CHARACTER
    FIELD ttObjectDesc  AS CHARACTER.

DEFINE TEMP-TABLE ttObject      NO-UNDO
    FIELD ObjectName            AS CHARACTER        FORMAT "X(30)":U
    FIELD TemplateObj           AS LOGICAL          FORMAT "yes/no":U                       INITIAL NO
    FIELD InstanceObjId         AS DECIMAL          FORMAT ">>>>>>>>>>>>>>>>>9.999999999"   DECIMALS 9
    FIELD Position              AS CHARACTER        FORMAT "X(8)"
    FIELD ObjectType            AS CHARACTER        FORMAT "X(8)"
    FIELD ObjectDescription     AS CHARACTER        FORMAT "X(20)"
    FIELD ProductModule         AS CHARACTER        FORMAT "X(8)"
    FIELD tObjectInstanceObj    AS DECIMAL          /* Used for setting properties */
    FIELD tAttributeLabels      AS CHARACTER        /* Used for setting properties */
    FIELD tAttributeValues      AS CHARACTER        /* Used for setting properties */
    .

DEFINE temp-TABLE ttLink        NO-UNDO
    FIELD LinkName          AS CHARACTER        FORMAT "X(8)"
    FIELD LinkSource        AS CHARACTER        FORMAT "X(8)"
    FIELD LinkTarget        AS CHARACTER        FORMAT "X(8)"
    .

/* function definitions*/
FUNCTION templateObjectName RETURNS CHARACTER 
    (INPUT cObjectName AS CHARACTER ) IN hGenObj.

FUNCTION getLinkNames RETURNS CHARACTER
  ( /* parameter-definitions */ ) IN hgenobj.

DEFINE VARIABLE gcAttributeLabels           AS CHARACTER            NO-UNDO.
DEFINE VARIABLE gcAttributevalues           AS CHARACTER            NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME LinkBrowse

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttLink ttObject

/* Definitions for BROWSE LinkBrowse                                    */
&Scoped-define FIELDS-IN-QUERY-LinkBrowse ttLink.LinkSource ttLink.LinkName ttLink.LinkTarget   
&Scoped-define ENABLED-FIELDS-IN-QUERY-LinkBrowse   
&Scoped-define SELF-NAME LinkBrowse
&Scoped-define OPEN-QUERY-LinkBrowse OPEN QUERY {&SELF-NAME} FOR EACH ttLink NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-LinkBrowse ttLink
&Scoped-define FIRST-TABLE-IN-QUERY-LinkBrowse ttLink


/* Definitions for BROWSE objectBrowse                                  */
&Scoped-define FIELDS-IN-QUERY-objectBrowse if substring(ttObject.Position,1,1) = "M" then "Main" else "Bottom" Substring(ttObject.Position,2,1) if substring(ttObject.Position,3,1) eq "R" then "Right Justified" else if substring(ttObject.Position,3,1) eq "C" then "Centered" else substring(ttObject.Position,3,1) ttObject.ObjectName ttObject.ObjectDescription ttObject.TemplateObj ttObject.ObjectType ttObject.InstanceObjId ttObject.ProductModule   
&Scoped-define ENABLED-FIELDS-IN-QUERY-objectBrowse   
&Scoped-define SELF-NAME objectBrowse
&Scoped-define OPEN-QUERY-objectBrowse OPEN QUERY {&SELF-NAME} FOR EACH ttObject NO-LOCK     BY ttObject.Position INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-objectBrowse ttObject
&Scoped-define FIRST-TABLE-IN-QUERY-objectBrowse ttObject


/* Definitions for FRAME DEFAULT-FRAME                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME ~
    ~{&OPEN-QUERY-LinkBrowse}~
    ~{&OPEN-QUERY-objectBrowse}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS buAddLayout fiLayoutName fiLayoutDescription ~
fiProductModule fiObjectName fiObjectDescription RECT-18 RECT-19 RECT-21 
&Scoped-Define DISPLAYED-OBJECTS fiLayoutName fiLayoutDescription ~
fiProductModule coObjectType toBottom fiObjectName fiObjectDescription ~
coRow coPosition coLinkSource coLinkType coLinkTarget 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD ifLinks C-Win 
FUNCTION ifLinks RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD parseLink C-Win 
FUNCTION parseLink RETURNS CHARACTER
  ( INPUT cName AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU m_File 
       MENU-ITEM m_OpenLayout   LABEL "Open"          
       MENU-ITEM m_AddLayout    LABEL "Add"           
       MENU-ITEM m_UpdateLayout LABEL "Update"        
              DISABLED
       MENU-ITEM m_SaveLayout   LABEL "Save"          
              DISABLED
       MENU-ITEM m_CloseLayout  LABEL "Close"         
              DISABLED
       RULE
       MENU-ITEM m_Exit         LABEL "Exit"          .

DEFINE MENU MENU-BAR-C-Win MENUBAR
       SUB-MENU  m_File         LABEL "File"          
       MENU-ITEM m_Help         LABEL "Help"          .


/* Definitions of the field level widgets                               */
DEFINE BUTTON buAddLayout 
     LABEL "Add" 
     SIZE 15 BY 1.14.

DEFINE BUTTON buAddLink 
     LABEL "Add" 
     SIZE 15 BY 1.14 TOOLTIP "Add Link".

DEFINE BUTTON buAddObject 
     LABEL "Add" 
     SIZE 15 BY 1.14 TOOLTIP "Add Object to Page Layout".

DEFINE BUTTON buCancelUpdate 
     LABEL "Cancel" 
     SIZE 15 BY 1.14 TOOLTIP "Cancel Modifications to Object Position".

DEFINE BUTTON buCloseLayout 
     LABEL "Close" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buDeleteLink 
     LABEL "Delete" 
     SIZE 15 BY 1.14 TOOLTIP "Delete Link".

DEFINE BUTTON buDeleteObject 
     LABEL "Delete" 
     SIZE 15 BY 1.14 TOOLTIP "Delete Object from Page Layout".

DEFINE BUTTON buObjectLookup 
     LABEL "..." 
     SIZE 4 BY 1.

DEFINE BUTTON buProductLookup 
     LABEL "..." 
     SIZE 4 BY 1.

DEFINE BUTTON buProperties 
     LABEL "Properties" 
     SIZE 15 BY 1.14 TOOLTIP "Cancel Modifications to Object Position".

DEFINE BUTTON buSaveLayout 
     LABEL "Save" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON buSaveObject 
     LABEL "Save" 
     SIZE 15 BY 1.14 TOOLTIP "Save Modifications to  Object Position on Page Layout".

DEFINE BUTTON buUpdateLayout 
     LABEL "Update" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE coLinkSource AS CHARACTER FORMAT "X(256)":U 
     LABEL "Link Source" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 40 BY 1 TOOLTIP "Link Source" NO-UNDO.

DEFINE VARIABLE coLinkTarget AS CHARACTER FORMAT "X(256)":U 
     LABEL "Link Target" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 40 BY 1 TOOLTIP "Link Target" NO-UNDO.

DEFINE VARIABLE coLinkType AS CHARACTER FORMAT "X(256)":U 
     LABEL "Link Type" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 40 BY 1 TOOLTIP "Link Type" NO-UNDO.

DEFINE VARIABLE coObjectType AS CHARACTER FORMAT "X(256)":U 
     LABEL "Object Type" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 46.8 BY 1 NO-UNDO.

DEFINE VARIABLE coPosition AS CHARACTER FORMAT "X(256)":U INITIAL "0" 
     LABEL "Position" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "1","1",
                     "2","2",
                     "3","3",
                     "4","4",
                     "5","5",
                     "6","6",
                     "7","7",
                     "8","8",
                     "9","9",
                     "Center","C",
                     "Right Justify","R"
     DROP-DOWN-LIST
     SIZE 15.8 BY 1 TOOLTIP "Horizontal Position" NO-UNDO.

DEFINE VARIABLE coRow AS CHARACTER FORMAT "X(256)":U INITIAL "0" 
     LABEL "Row" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "1","2","3","4","5","6","7","8","9" 
     DROP-DOWN-LIST
     SIZE 10 BY 1 TOOLTIP "Vertical Position" NO-UNDO.

DEFINE VARIABLE fiLayoutDescription AS CHARACTER FORMAT "X(256)":U 
     LABEL "Layout Description" 
     VIEW-AS FILL-IN 
     SIZE 70.4 BY 1 NO-UNDO.

DEFINE VARIABLE fiLayoutName AS CHARACTER FORMAT "X(256)":U 
     LABEL "Layout Object Name" 
     VIEW-AS FILL-IN 
     SIZE 29 BY 1 TOOLTIP "Name of the new page layout object." NO-UNDO.

DEFINE VARIABLE fiObjectDescription AS CHARACTER FORMAT "X(256)":U 
     LABEL "Description" 
     VIEW-AS FILL-IN 
     SIZE 42 BY 1 NO-UNDO.

DEFINE VARIABLE fiObjectName AS CHARACTER FORMAT "X(256)":U 
     LABEL "Object Name" 
     VIEW-AS FILL-IN 
     SIZE 34 BY 1 NO-UNDO.

DEFINE VARIABLE fiProductModule AS CHARACTER FORMAT "X(256)":U 
     LABEL "Product Module" 
     VIEW-AS FILL-IN 
     SIZE 41.8 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 146.2 BY 9.71.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 146.2 BY 9.19.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 146.2 BY 5.

DEFINE VARIABLE toBottom AS LOGICAL INITIAL no 
     LABEL "Bottom" 
     VIEW-AS TOGGLE-BOX
     SIZE 13.4 BY .81 TOOLTIP "Check to place object on Bottom area of Page layout. Main is default area." NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY LinkBrowse FOR 
      ttLink SCROLLING.

DEFINE QUERY objectBrowse FOR 
      ttObject SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE LinkBrowse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS LinkBrowse C-Win _FREEFORM
  QUERY LinkBrowse NO-LOCK DISPLAY
      ttLink.LinkSource FORMAT "X(30)":U
      ttLink.LinkName FORMAT "X(30)":U
      ttLink.LinkTarget FORMAT "X(30)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 113 BY 5.33 ROW-HEIGHT-CHARS .66 EXPANDABLE TOOLTIP "Browse Page Layout Links".

DEFINE BROWSE objectBrowse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS objectBrowse C-Win _FREEFORM
  QUERY objectBrowse NO-LOCK DISPLAY
      if substring(ttObject.Position,1,1) = "M" then "Main"
else "Bottom" COLUMN-LABEL "Area" FORMAT "x(8)":U
      Substring(ttObject.Position,2,1) COLUMN-LABEL "Row" FORMAT "x(3)":U
      if substring(ttObject.Position,3,1) eq "R" then "Right Justified" else if substring(ttObject.Position,3,1)  eq "C" then "Centered" else substring(ttObject.Position,3,1) COLUMN-LABEL "Position" FORMAT "x(15)":U
      ttObject.ObjectName WIDTH 20
      ttObject.ObjectDescription FORMAT "X(30)":U
      ttObject.TemplateObj
      ttObject.ObjectType FORMAT "X(15)":U
      ttObject.InstanceObjId
      ttObject.ProductModule
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 113 BY 7.1 ROW-HEIGHT-CHARS .67 EXPANDABLE TOOLTIP "Browse Contained Objects on Page Layout".


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     buAddLayout AT ROW 1.43 COL 122.4
     fiLayoutName AT ROW 1.71 COL 21.6 COLON-ALIGNED
     buUpdateLayout AT ROW 2.62 COL 122.4
     fiLayoutDescription AT ROW 2.71 COL 21.6 COLON-ALIGNED
     fiProductModule AT ROW 3.76 COL 21.6 COLON-ALIGNED
     buProductLookup AT ROW 3.76 COL 65.4
     buSaveLayout AT ROW 3.81 COL 122.4
     coObjectType AT ROW 4.81 COL 21.4 COLON-ALIGNED
     buCloseLayout AT ROW 5 COL 122.4
     toBottom AT ROW 6.86 COL 131
     fiObjectName AT ROW 7.19 COL 21.6 COLON-ALIGNED
     buObjectLookup AT ROW 7.19 COL 57.8
     fiObjectDescription AT ROW 7.19 COL 75 COLON-ALIGNED
     coRow AT ROW 7.62 COL 129 COLON-ALIGNED
     coPosition AT ROW 8.67 COL 129 COLON-ALIGNED
     objectBrowse AT ROW 8.91 COL 6
     buAddObject AT ROW 9.86 COL 122.4
     buSaveObject AT ROW 11.05 COL 122.4
     buDeleteObject AT ROW 12.24 COL 122.4
     buCancelUpdate AT ROW 13.43 COL 122.4
     buProperties AT ROW 14.62 COL 122.4
     coLinkSource AT ROW 17.05 COL 17 COLON-ALIGNED
     coLinkType AT ROW 18 COL 17 COLON-ALIGNED
     coLinkTarget AT ROW 18.95 COL 17 COLON-ALIGNED
     LinkBrowse AT ROW 20.14 COL 6.2
     buAddLink AT ROW 21.33 COL 122.4
     buDeleteLink AT ROW 22.52 COL 122.4
     RECT-18 AT ROW 6.52 COL 2
     RECT-19 AT ROW 16.57 COL 2
     RECT-21 AT ROW 1.24 COL 2
     "  Contained Objects" VIEW-AS TEXT
          SIZE 20 BY .62 AT ROW 6.29 COL 9
     "  Links" VIEW-AS TEXT
          SIZE 11 BY .62 AT ROW 16.24 COL 9
     " Page Layout" VIEW-AS TEXT
          SIZE 14 BY .62 TOOLTIP "Add, Update, Save or Cancel a Page Layout" AT ROW 1 COL 9
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 148.8 BY 24.95.


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
         TITLE              = "Page Layout"
         HEIGHT             = 24.86
         WIDTH              = 148.8
         MAX-HEIGHT         = 34.33
         MAX-WIDTH          = 204.8
         VIRTUAL-HEIGHT     = 34.33
         VIRTUAL-WIDTH      = 204.8
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU MENU-BAR-C-Win:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
                                                                        */
/* BROWSE-TAB objectBrowse coPosition DEFAULT-FRAME */
/* BROWSE-TAB LinkBrowse coLinkTarget DEFAULT-FRAME */
/* SETTINGS FOR BUTTON buAddLink IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON buAddObject IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON buCancelUpdate IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON buCloseLayout IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON buDeleteLink IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON buDeleteObject IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON buObjectLookup IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON buProductLookup IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON buProperties IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON buSaveLayout IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON buSaveObject IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON buUpdateLayout IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX coLinkSource IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX coLinkTarget IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX coLinkType IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX coObjectType IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX coPosition IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX coRow IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
ASSIGN 
       fiLayoutDescription:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

ASSIGN 
       fiLayoutName:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

ASSIGN 
       fiObjectDescription:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

ASSIGN 
       fiObjectName:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

ASSIGN 
       fiProductModule:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

/* SETTINGS FOR BROWSE LinkBrowse IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
ASSIGN 
       LinkBrowse:COLUMN-RESIZABLE IN FRAME DEFAULT-FRAME       = TRUE
       LinkBrowse:COLUMN-MOVABLE IN FRAME DEFAULT-FRAME         = TRUE.

/* SETTINGS FOR BROWSE objectBrowse IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
ASSIGN 
       objectBrowse:COLUMN-RESIZABLE IN FRAME DEFAULT-FRAME       = TRUE
       objectBrowse:COLUMN-MOVABLE IN FRAME DEFAULT-FRAME         = TRUE.

/* SETTINGS FOR TOGGLE-BOX toBottom IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE LinkBrowse
/* Query rebuild information for BROWSE LinkBrowse
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttLink NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE LinkBrowse */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE objectBrowse
/* Query rebuild information for BROWSE objectBrowse
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttObject NO-LOCK
    BY ttObject.Position INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _OrdList          = "ttObject.Position|yes"
     _Query            is OPENED
*/  /* BROWSE objectBrowse */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Page Layout */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Page Layout */
DO:
  /* This event will close the window and terminate the procedure.  */
 
  IF lmodified AND NOT lempty THEN
      MESSAGE "Save Page Layout before Exit?" 
                VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL
                       TITLE "" UPDATE choice AS LOGICAL.
    ELSE ASSIGN choice = NO. 

    IF choice = ?  THEN RETURN NO-APPLY. /* they cancelled */

      DO WITH FRAME {&FRAME-NAME}:
        IF choice THEN APPLY "choose" TO buSaveLayout.   /* save the page layout */
        ELSE ERROR-STATUS:ERROR = NO.

        IF NOT ERROR-STATUS:ERROR THEN DO:
          ASSIGN ERROR-STATUS:ERROR = NO.
          APPLY "CLOSE":U TO THIS-PROCEDURE.   
        END. /*not error-stauts error*/
      END. /*DO WITH FRAME*/
  
  IF VALID-HANDLE(hGenObj) THEN RUN killPlip IN hGenObj.
  
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DEFAULT-FRAME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DEFAULT-FRAME C-Win
ON HELP OF FRAME DEFAULT-FRAME
DO:
  /* Help for this Frame */
  RUN adecomm/_adehelp.p
                ("ICAB":U, "CONTEXT":U, {&Page_Layout_Window}  , "":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buAddLayout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buAddLayout C-Win
ON CHOOSE OF buAddLayout IN FRAME DEFAULT-FRAME /* Add */
DO:
   
  /* clear the fill-ins of any values */
  RUN ClearScreen.
  glNewObject = TRUE.
  /* display the  initial screen values */
  ASSIGN lempty = YES.
  RUN InitializeScreen IN THIS-PROCEDURE.
  RUN setLayoutButtons("Add":U).

  /* empty all the temp-tables */
  EMPTY TEMP-TABLE ttlink.
  EMPTY TEMP-TABLE ttobject.
  RUN displayBrowse.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buAddLink
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buAddLink C-Win
ON CHOOSE OF buAddLink IN FRAME DEFAULT-FRAME /* Add */
DO:
  RUN addLink.
  ASSIGN buDeleteLink:SENSITIVE = iflinks().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buAddObject
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buAddObject C-Win
ON CHOOSE OF buAddObject IN FRAME DEFAULT-FRAME /* Add */
DO:
  RUN AddObject.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buCancelUpdate
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buCancelUpdate C-Win
ON CHOOSE OF buCancelUpdate IN FRAME DEFAULT-FRAME /* Cancel */
DO:
  ASSIGN lAddMode = YES.
  RUN setMode.    /* yes = addmode */
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buCloseLayout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buCloseLayout C-Win
ON CHOOSE OF buCloseLayout IN FRAME DEFAULT-FRAME /* Close */
DO:
  
    IF lmodified AND NOT lempty THEN
      MESSAGE "Save Page Layout before Close?" 
                VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL
                       TITLE "" UPDATE choice AS LOGICAL.
    ELSE ASSIGN choice = NO. 

      IF choice = ?  THEN RETURN NO-APPLY. /* they cancelled */

      DO WITH FRAME {&FRAME-NAME}:
        IF choice THEN APPLY "choose" TO buSaveLayout.   /* save the page layout */
        ELSE ERROR-STATUS:ERROR = NO.

        IF NOT ERROR-STATUS:ERROR THEN DO:
          ASSIGN ERROR-STATUS:ERROR = NO
                 lempty = YES            /* only set these flags if we had */
                 lmodified = NO.         /* success */
          APPLY "choose":U TO buAddLayout. /* blank screen*/ 
          RUN disableScreen.
          APPLY "entry":U TO  buAddLayout.
          RETURN NO-APPLY.
        END. /*not error-stauts error*/
      END. /*DO WITH FRAME*/
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buDeleteLink
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buDeleteLink C-Win
ON CHOOSE OF buDeleteLink IN FRAME DEFAULT-FRAME /* Delete */
DO:
  RUN DeleteLink.
  ASSIGN buDeleteLink:SENSITIVE = iflinks().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buDeleteObject
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buDeleteObject C-Win
ON CHOOSE OF buDeleteObject IN FRAME DEFAULT-FRAME /* Delete */
DO:
  RUN DeleteObject.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buObjectLookup
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buObjectLookup C-Win
ON CHOOSE OF buObjectLookup IN FRAME DEFAULT-FRAME /* ... */
DO:
  DEFINE VARIABLE cObjName AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cObjDesc AS CHARACTER NO-UNDO.

  ASSIGN cObjName = fiObjectName:SCREEN-VALUE.

  RUN ry/obj/glookup.w (OUTPUT cObjName, OUTPUT cObjDesc).
  ASSIGN fiObjectName:SCREEN-VALUE = cObjName
         fiObjectDescription:SCREEN-VALUE = cObjDesc.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buProductLookup
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buProductLookup C-Win
ON CHOOSE OF buProductLookup IN FRAME DEFAULT-FRAME /* ... */
DO:
  DEFINE VARIABLE cMod AS CHARACTER NO-UNDO.
  
  RUN ry/obj/gModLookup.w ( INPUT DYNAMIC-FUNCTION("productModuleNames":U, INPUT glDisplayRepository),
                            OUTPUT cMod).

  IF cMod NE "":U THEN
      ASSIGN fiProductModule:SCREEN-VALUE = cmod.

  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buProperties
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buProperties C-Win
ON CHOOSE OF buProperties IN FRAME DEFAULT-FRAME /* Properties */
DO:
    RUN setProperties.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buSaveLayout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buSaveLayout C-Win
ON CHOOSE OF buSaveLayout IN FRAME DEFAULT-FRAME /* Save */
DO:
  DEFINE VARIABLE cErrorText AS CHARACTER NO-UNDO.
  
  SESSION:SET-WAIT-STATE("GENERAL":U).
  RUN ValidateLayout(OUTPUT cErrorText).

  IF cErrorText EQ "":U THEN DO:

       RUN SaveLayout.
       RUN disableScreen.
       ASSIGN buAddLayout:SENSITIVE = YES
              buSaveLayout:SENSITIVE = NO
              buUpdateLayout:SENSITIVE = YES
              MENU-ITEM m_AddLayout:SENSITIVE IN MENU MENU-BAR-C-Win = YES
              MENU-ITEM m_saveLayout:SENSITIVE IN MENU MENU-BAR-C-Win = NO
              MENU-ITEM m_Updatelayout:SENSITIVE IN MENU MENU-BAR-C-Win = YES.
  END.
  ELSE ASSIGN ERROR-STATUS:ERROR = YES.
  SESSION:SET-WAIT-STATE("":U).
  glNewObject = FALSE.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buSaveObject
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buSaveObject C-Win
ON CHOOSE OF buSaveObject IN FRAME DEFAULT-FRAME /* Save */
DO:
  /* if non-visual object then nothing can be modified */
  IF ttobject.POSITION BEGINS "M0":U THEN RETURN NO-APPLY.
  
  /* if visual object then positioning can be modified and saved */
  RUN saveObject.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buUpdateLayout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buUpdateLayout C-Win
ON CHOOSE OF buUpdateLayout IN FRAME DEFAULT-FRAME /* Update */
DO:
  glNewObject = FALSE.
  RUN UpdateLayout.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiLayoutDescription
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiLayoutDescription C-Win
ON LEAVE OF fiLayoutDescription IN FRAME DEFAULT-FRAME /* Layout Description */
DO:
  IF SELF:SCREEN-VALUE NE fiLayoutDescription THEN
      ASSIGN lmodified = YES
             lempty = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiLayoutName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiLayoutName C-Win
ON LEAVE OF fiLayoutName IN FRAME DEFAULT-FRAME /* Layout Object Name */
DO:
    
  IF SELF:SCREEN-VALUE NE fiLayoutName THEN
      ASSIGN lmodified = YES
             lempty = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiObjectName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiObjectName C-Win
ON LEAVE OF fiObjectName IN FRAME DEFAULT-FRAME /* Object Name */
DO:
   
  DEFINE VARIABLE iNumObjects AS INTEGER NO-UNDO.
  DEFINE VARIABLE wh AS WIDGET-HANDLE.
  ASSIGN wh = LAST-EVENT:WIDGET-ENTER.

  /* if we are pressing the lookup button anyway then don't do a lookup */
  IF wh:NAME = "buObjectLookup":U AND LAST-EVENT:LABEL NE "tab":U THEN RETURN.
  IF SELF:SCREEN-VALUE = "":U OR SELF:SCREEN-VALUE = ? THEN RETURN.

  RUN getObjectNames IN hgenobj (INPUT  SELF:SCREEN-VALUE, 
                                 OUTPUT iNumObjects,
                                 OUTPUT TABLE ttObjectInfo).
  
  IF iNumObjects > 1 THEN DO:
      
      RUN ry/obj/gPartialLookup(INPUT TABLE ttObjectInfo, OUTPUT fiObjectName, OUTPUT fiObjectDescription).
      ASSIGN fiObjectDescription:SCREEN-VALUE = fiObjectDescription
             fiObjectName:SCREEN-VALUE        = fiObjectName.
  END.
  ELSE IF iNumObjects < 1 THEN 
      ASSIGN SELF:SCREEN-VALUE                = " ":U
             fiObjectDescription:SCREEN-VALUE = " ":U.
  ELSE do:
      /* if exactly one name */
      FIND FIRST ttobjectinfo.
      ASSIGN SELF:SCREEN-VALUE                = ttObjectInfo.ttObjectName
             fiObjectDescription:SCREEN-VALUE = ttObjectInfo.ttObjectDesc.
  END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiProductModule
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiProductModule C-Win
ON LEAVE OF fiProductModule IN FRAME DEFAULT-FRAME /* Product Module */
DO:
  IF SELF:SCREEN-VALUE NE fiProductModule THEN
      ASSIGN lmodified = YES
             lempty = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_AddLayout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_AddLayout C-Win
ON CHOOSE OF MENU-ITEM m_AddLayout /* Add */
DO:
  APPLY "choose":U TO buAddLayout IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_CloseLayout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_CloseLayout C-Win
ON CHOOSE OF MENU-ITEM m_CloseLayout /* Close */
DO:
 APPLY "choose":U TO buCloseLayout IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Exit C-Win
ON CHOOSE OF MENU-ITEM m_Exit /* Exit */
DO:
apply "window-close" to c-win.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_OpenLayout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_OpenLayout C-Win
ON CHOOSE OF MENU-ITEM m_OpenLayout /* Open */
DO:
  glNewObject = FALSE.
  RUN OpenLayout.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_SaveLayout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_SaveLayout C-Win
ON CHOOSE OF MENU-ITEM m_SaveLayout /* Save */
DO:
  APPLY "choose" TO buSaveLayout IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_UpdateLayout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_UpdateLayout C-Win
ON CHOOSE OF MENU-ITEM m_UpdateLayout /* Update */
DO:
APPLY "choose":U TO buUpdateLayout IN FRAME {&FRAME-NAME}.
          
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME objectBrowse
&Scoped-define SELF-NAME objectBrowse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL objectBrowse C-Win
ON MOUSE-SELECT-DBLCLICK OF objectBrowse IN FRAME DEFAULT-FRAME
DO:
    ASSIGN laddmode          = NO
           gcAttributeLabels = "":U
           gcAttributeValues = "":U
           .
    IF BROWSE {&BROWSE-NAME}:SELECT-FOCUSED-ROW() THEN
        GET CURRENT {&BROWSE-NAME}.

    RUN viewObject.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL objectBrowse C-Win
ON VALUE-CHANGED OF objectBrowse IN FRAME DEFAULT-FRAME
DO:
/*   RUN viewObject. */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toBottom
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toBottom C-Win
ON VALUE-CHANGED OF toBottom IN FRAME DEFAULT-FRAME /* Bottom */
DO:
  assign
      coRow:SCREEN-VALUE = IF toBottom:CHECKED THEN "9":U ELSE "1":U
      coRow:SENSITIVE = NOT toBottom:CHECKED.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME LinkBrowse
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

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
  RUN enable_UI.
  RUN initializeObject.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addLink C-Win 
PROCEDURE addLink :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE BUFFER ttSource FOR ttObject.
DEFINE BUFFER ttTarget FOR ttObject.
DEFINE VARIABLE i  AS INTEGER   NO-UNDO.


DO WITH FRAME {&FRAME-NAME}:
    ASSIGN coLinkSource
           coLinkTarget
           coLinkType.
END.
IF coLinkSource EQ " ":U OR coLinkSource EQ "":U THEN DO:
    MESSAGE "You must specify a Link Source.":U
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RETURN.
END.

IF coLinkSource EQ " ":U OR coLinkSource EQ "":U THEN DO:
  MESSAGE "You must specify a Link Target.":U
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
  RETURN.
END.

IF coLinkType EQ " ":U OR coLinkType EQ "":U THEN DO:
  MESSAGE "You must specify a Link Type.":U
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
  RETURN.
END.

/* if link already exists then tell user and don't create it */
FIND FIRST ttlink WHERE ttlink.linkName = coLinkType
                    AND ttlink.linkSource = coLinkSource
                    AND ttlink.linkTarget = coLinktarget NO-LOCK NO-ERROR.
IF AVAILABLE ttlink THEN 
  MESSAGE "This link already exists."
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
  
ELSE DO:

  /* create link record */
  CREATE ttlink.
  ASSIGN  ttlink.linkName     = coLinkType
          ttlink.linkSource   = coLinkSource
          ttlink.linkTarget   = coLinkTarget.
          
  ASSIGN lModified = YES
         lEmpty = NO.
  RUN DISPLAYBrowse.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AddObject C-Win 
PROCEDURE AddObject :
/*------------------------------------------------------------------------------
  Purpose:    creates  ttobject to display in the object browser.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cPosn       AS CHARACTER     NO-UNDO.
DEFINE VARIABLE dsmobj      AS DECIMAL       NO-UNDO.
DEFINE VARIABLE objtype     AS CHARACTER     NO-UNDO.
DEFINE VARIABLE isTemplate  AS LOGICAL       NO-UNDO.
DEFINE VARIABLE cDesc       AS CHARACTER     NO-UNDO.
DEFINE VARIABLE cMod        AS CHARACTER     NO-UNDO.
DEFINE VARIABLE cRelative   AS CHARACTER     NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:

    IF fiObjectName:SCREEN-VALUE NE "":U THEN DO:
      ASSIGN fiObjectName
             fiObjectDescription
             coPosition
             coRow
             .

      RUN getObjectInfo IN hGenObj (fiObjectName, 
                              OUTPUT dsmobj,
                              OUTPUT ObjType, 
                              OUTPUT IsTemplate,
                              OUTPUT cDesc,
                              OUTPUT cMod,
                              OUTPUT cRelative).

      /* if non-visual object then posn on screen is ignored */
      IF LOOKUP(objtype, "SDO,SBO":U) NE 0
        THEN ASSIGN iNumDataObjects = iNumDataObjects + 1
                    cposn           = "M0":U + STRING(iNumDataObjects).
        ELSE 
            ASSIGN cPosn = IF toBottom:CHECKED THEN "B9":U + coPosition
                            ELSE "M":U + coRow + coPosition.

      FIND ttObject WHERE ttObject.POSITION = cPosn NO-ERROR.
      IF AVAILABLE ttObject THEN DO:
          MESSAGE "Object Already Exists at Position:" cPosn
              VIEW-AS ALERT-BOX.
          RETURN.
      END.
      CREATE ttObject.

      ASSIGN 
             ttObject.ObjectName    = fiObjectName
             ttObject.TemplateObj   = IsTemplate                  
             ttObject.POSITION      = cPosn
             ttObject.InstanceObjID = dsmobj
             ttObject.ObjectType    = objType
             ttObject.ObjectDescription = fiObjectDescription
             ttObject.ProductModule = cMod.
          
      /* add object to link source and target combo-box lists */
       coLinkSource:ADD-LAST(ttobject.POSITION + " ":U 
                             + ttobject.objectName + " <":U + objType + ">":U ).
       coLinkTarget:ADD-LAST(ttobject.POSITION + " ":U 
                             + ttobject.objectName + " <":U + objType + ">":U ).

      /* if folder object then add special link to link temp-table and 
       * browser
       */
      IF ttObject.objectName = "afspfoldrw.w":U THEN DO:
      
        CREATE ttlink.
        ASSIGN  ttlink.linkName     = "page":U
                ttlink.linkSource   = ttobject.POSITION + " ":U 
                             + ttobject.objectName + " <":U + objType + ">":U 
                ttlink.linkTarget   = "<container>":U .
      END.

      /* re-display the object browser now so the new object shows up */
      RUN displayBrowse.
      ASSIGN fiObjectName:SCREEN-VALUE = " ":U
             fiObjectDescription:SCREEN-VALUE = " ":U.
      ASSIGN lmodified = YES
             lempty = NO.
    END. /* END if fiobjectname */
    ELSE DO:
      MESSAGE "You must specify an Object to Add"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
      APPLY "entry" TO fiObjectName.
    END.
END. /* end do with frame */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ClearScreen C-Win 
PROCEDURE ClearScreen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
    ASSIGN fiLayoutName:SCREEN-VALUE = "":U
           fiLayoutName = "":U
           fiLayoutDescription:SCREEN-VALUE = "":U
           fiLayoutDescription = "":U
           fiProductModule:SCREEN-VALUE = "":U
           fiProductModule = "":U
           fiObjectName:SCREEN-VALUE = "":U
           fiObjectDescription:SCREEN-VALUE = "":U
           toBottom:CHECKED = NO
           coPosition = "1":U
           coRow = "1":U.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteLink C-Win 
PROCEDURE deleteLink :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE lok AS LOGICAL.

  DO WITH FRAME {&FRAME-NAME}:

    lok = LinkBrowse:FETCH-SELECTED-ROW(1) NO-ERROR.  /* populate the tt buffer */
    IF lok THEN DO:
      FIND CURRENT ttLink EXCLUSIVE-LOCK.
      DELETE ttLink.
      lok = LinkBrowse:DELETE-SELECTED-ROWS() IN FRAME {&FRAME-NAME}.   /* delete from browse */
      ASSIGN lmodified = YES.
    END.
    
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteObject C-Win 
PROCEDURE deleteObject :
/*------------------------------------------------------------------------------
  Purpose:    delete ttobject from temp-table and object browser.
              also deletes any links created for that object or 
              references to the object in source/target combos.
              
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE lok   AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cName AS CHARACTER NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:

  /* fetch the row to delete */
 lok = ObjectBrowse:FETCH-SELECTED-ROW(1).  /* populate the tt buffer */
 
 ASSIGN cName = ttobject.POSITION + " ":U 
                  + ttobject.objectName + " <":U + ttobject.objectType + ">":U.
 
 IF lok THEN DO:
   /* delete from source and target link combo-boxes */
   coLinkSource:DELETE(cname). 
   coLinkTarget:DELETE(cname). 
  
   /* delete any links created in tt for this object */
   FOR EACH ttlink:
       IF ttlink.LinkSource BEGINS ttobject.POSITION OR
           ttlink.linkTarget BEGINS ttobject.POSITION
            THEN DELETE ttlink.
   END.
   
   

   /* delete it from the temp table */
   FIND CURRENT ttobject EXCLUSIVE-LOCK.
   DELETE ttObject.
   lok = ObjectBrowse:DELETE-SELECTED-ROWS().   /* delete from browse */

   ASSIGN fiObjectName = "":U 
          fiObjectName:SCREEN-VALUE = "":U
          lAddMode = YES
          lModified = YES.
   RUN setMode.    /* yes = addmode */
   
 END. /* if lok then do */
END.
RUN displayBrowse.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DisablePosition C-Win 
PROCEDURE DisablePosition :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER cPos AS CHARACTER NO-UNDO.
DO WITH FRAME {&FRAME-NAME}:

     /* if data object -- non-visual so disable posn info */
     

 ASSIGN     ToBottom:SENSITIVE             =  IF cPos BEGINS "M0":U THEN NO ELSE YES
            coRow:SENSITIVE                =  IF cPos BEGINS "M0":U THEN NO ELSE YES
            coPosition:SENSITIVE           =  IF cPos BEGINS "M0":U THEN NO ELSE YES
            .
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disableScreen C-Win 
PROCEDURE disableScreen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:

ASSIGN buAddLayout:SENSITIVE             = YES
       MENU-ITEM m_AddLayout:SENSITIVE IN MENU MENU-BAR-C-Win    = YES
       MENU-ITEM m_OpenLayout:SENSITIVE IN MENU MENU-BAR-C-Win   = YES
       MENU-ITEM m_SaveLayout:SENSITIVE IN MENU MENU-BAR-C-Win   = NO
       MENU-ITEM m_updateLayout:SENSITIVE IN MENU MENU-BAR-C-Win   = IF lempty THEN NO ELSE YES
       MENU-ITEM m_closeLayout:SENSITIVE IN MENU MENU-BAR-C-Win   = IF lempty THEN NO ELSE YES

       buSaveLayout:SENSITIVE            = NO
       buupdateLayout:SENSITIVE          = IF lempty THEN NO ELSE YES
       buCloseLayout:SENSITIVE           = IF lempty THEN NO ELSE YES
       buAddObject:SENSITIVE             = NO
       buSaveObject:SENSITIVE            = NO
       buDeleteObject:SENSITIVE          = NO
       buCancelUpdate:SENSITIVE          = NO
       buProperties:SENSITIVE            = NO
       buAddLink:SENSITIVE               = NO
       buDeleteLink:SENSITIVE            = NO
       fiObjectName:SENSITIVE            = YES
       fiObjectName:READ-ONLY            = YES
       fiObjectDescription:SENSITIVE     = YES
       fiObjectDescription:READ-ONLY     = YES
       fiProductModule:SENSITIVE         = YES
       fiProductModule:READ-ONLY         = YES
       fiLayoutName:SENSITIVE        =  YES
       fiLayoutName:READ-ONLY        = YES
       coObjectType:SENSITIVE        =  no 
       fiLayoutDescription:READ-ONLY = YES
       buObjectLookup:SENSITIVE      =  no
       buProductLookup:SENSITIVE     =  NO
       toBottom:SENSITIVE            =  NO   
       coRow:SENSITIVE               =  NO   
       coPosition:SENSITIVE          =  NO   
       objectBrowse:SENSITIVE        =  no  
       coLinkSource:SENSITIVE        =  no 
       coLinkType:SENSITIVE          =  no 
       coLinkTarget:SENSITIVE        =  no
       LinkBrowse:SENSITIVE          =  no 
       .

END. /* do with frame */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayBrowse C-Win 
PROCEDURE displayBrowse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

{&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DisplayObject C-Win 
PROCEDURE DisplayObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE lok AS LOGICAL NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
 ASSIGN laddmode = NO.
 RUN setMode.  /* addmode = no */
 

  /* fetch the row to modify */
/*  lok = ObjectBrowse:FETCH-SELECTED-ROW(1).  /* populate the tt buffer */ */

 RUN ViewObject.
 ASSIGN fiObjectName:SENSITIVE = NO
        fiObjectDescription:SENSITIVE = NO
        laddmode = NO.
        
END.
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
  DISPLAY fiLayoutName fiLayoutDescription fiProductModule coObjectType toBottom 
          fiObjectName fiObjectDescription coRow coPosition coLinkSource 
          coLinkType coLinkTarget 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE buAddLayout fiLayoutName fiLayoutDescription fiProductModule 
         fiObjectName fiObjectDescription RECT-18 RECT-19 RECT-21 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject C-Win 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cProfileData            AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE rRowid                  AS ROWID                    NO-UNDO.

    /* initialize the api - if not already running. */
    /* 
    hGenObj = DYNAMIC-FUNC("get-proc-hdl" IN _h_func_lib, INPUT "ry/app/ryreposobp.p":u) NO-ERROR.
    */

    RUN ry/app/ryreposobp.p PERSISTENT SET hGenObj.
    
    /* Display Repository?  */
    ASSIGN rRowid = ?.
    RUN getProfileData IN gshProfileManager ( INPUT        "General":U,
                                              INPUT        "DispRepos":U,
                                              INPUT        "DispRepos":U,
                                              INPUT        NO,
                                              INPUT-OUTPUT rRowid,
                                                    OUTPUT cProfileData).
    ASSIGN glDisplayRepository                           = (cProfileData EQ "YES":U)
           lEmpty                                        = YES
           lModified                                     = NO
           coObjectType:DELIMITER IN FRAME {&FRAME-NAME} = CHR(3)
           .
    RUN populateObjectType.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeScreen C-Win 
PROCEDURE initializeScreen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  /* initialize screen-values */
  ASSIGN coRow:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "1":U
         coPosition:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "1":U
         coLinkSource:LIST-ITEMS = "<container>":U
         coLinkSource:SCREEN-VALUE = "<container>":U
         coLinkTarget:LIST-ITEMS = "<container>":U
         coLinkTarget:SCREEN-VALUE = "<container>":U
         coLinkType:LIST-ITEMS = getLinkNames()
         coLinkType:SCREEN-VALUE = ENTRY(1,colinkType:LIST-ITEMS).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openLayout C-Win 
PROCEDURE openLayout :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cMod     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cObjCode AS CHARACTER  NO-UNDO.


/* clear the fill-ins of any values */
  RUN ClearScreen.
 
  DO WITH FRAME {&FRAME-NAME}:

    RUN ry/obj/gLayoutLookup.w (OUTPUT fiLayoutName, 
                                OUTPUT fiLayoutDescription,
                                OUTPUT fiProductModule, 
                                OUTPUT cObjCode).

    ASSIGN fiLayoutName:SCREEN-VALUE        = fiLayoutName
           fiLayoutDescription:SCREEN-VALUE = fiLayoutDescription
           fiProductModule:SCREEN-VALUE     = fiProductModule
           coObjectType:SCREEN-VALUE        = cObjCode.
  END.

   DO WITH FRAME {&FRAME-NAME}:
 

    IF filayoutName:SCREEN-VALUE EQ "":U /*OR 
       filayoutName:SCREEN-VALUE EQ ? */ THEN
      MESSAGE "Please specify a Layout Object to open.":U
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
    ELSE DO:
      /*set screen back to initial state */
      RUN InitializeScreen IN THIS-PROCEDURE.

      /* empty all the temp-tables */
      EMPTY TEMP-TABLE ttlink.
      EMPTY TEMP-TABLE ttobject.
      RUN getLayoutObjects IN hgenobj (INPUT fiLayoutName:SCREEN-VALUE,
                                       OUTPUT TABLE ttobject).
      RUN getLayoutLinks IN hgenobj (INPUT fiLayoutName:SCREEN-VALUE,
                                     OUTPUT TABLE ttlink).

      FOR EACH ttobject:
          
       /* find any link where source or target is this object*/
       /* and update the link source and target to display more info*/
         FOR EACH ttlink:
             IF ttlink.linksource = ttobject.POSITION THEN
             ASSIGN ttlink.linksource = ttobject.POSITION + " ":U 
                             + ttobject.objectName + " <":U + ttobject.objectType 
                             + ">":U.
             

             IF ttlink.linkTarget = ttobject.POSITION THEN
             ASSIGN ttlink.linkTarget = ttobject.POSITION + " ":U 
                             + ttobject.objectName + " <":U + ttobject.objectType 
                             + ">":U.
             
         END. /* end for each ttlink*/

         
       /* add object to link source and target combo-box lists */
       coLinkSource:ADD-LAST(ttobject.POSITION + " ":U 
                             + ttobject.objectName + " <":U + ttobject.objectType + ">":U ).
       
       coLinkTarget:ADD-LAST(ttobject.POSITION + " ":U 
                             + ttobject.objectName + " <":U + ttobject.objectType + ">":U ).
       
      END. /* end for each ttobject*/
      /* set layout modes*/
      ASSIGN lempty = NO.

      /* set buttons */
      RUN setLayoutButtons("update":U).
      RUN displayBrowse.
    END. /* end else do*/
  END. /* end do with frame */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateObjectType C-Win 
PROCEDURE populateObjectType :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hCombo              AS HANDLE                       NO-UNDO.
    DEFINE VARIABLE cLipString          AS CHARACTER                    NO-UNDO.
    DEFINE VARIABLE dProductModuleObj   AS DECIMAL                      NO-UNDO.
    DEFINE VARIABLE dObjectTypeObj      AS DECIMAL                      NO-UNDO.

    
    /* Object Type */
    ASSIGN hCombo     = coObjectType:HANDLE IN FRAME {&FRAME-NAME}
           cLipString = "":U
           .

    RUN ry/prc/rygetobjtype.p (INPUT hCombo:DELIMITER, OUTPUT cLipString).

    ASSIGN hCombo:LIST-ITEM-PAIRS = cLipString
           hCombo:SCREEN-VALUE    = hCombo:ENTRY(1)
           NO-ERROR.

    IF dObjectTypeObj EQ 0 THEN
        ASSIGN coObjectType:SCREEN-VALUE = coObjectType:ENTRY(1) NO-ERROR.
    ELSE
        ASSIGN coObjectType:SCREEN-VALUE = STRING(dObjectTypeObj) NO-ERROR.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveLayout C-Win 
PROCEDURE saveLayout :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cErrorText     AS CHARACTER    NO-UNDO.
DEFINE VARIABLE dcontainer     AS DECIMAL      NO-UNDO.
DEFINE VARIABLE dContainerType AS DECIMAL      NO-UNDO.
DEFINE VARIABLE dSmartObject   AS DECIMAL      NO-UNDO.  /* Smart Object ID */
DEFINE VARIABLE dObjectType    AS DECIMAL      NO-UNDO.  /* Object Type ID */
DEFINE VARIABLE dInstance      AS DECIMAL      NO-UNDO.
DEFINE VARIABLE cattrnames     AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cattrvalues    AS CHARACTER    NO-UNDO.
DEFINE VARIABLE dSourceID      AS DECIMAL      NO-UNDO.
DEFINE VARIABLE dTargetID      AS DECIMAL      NO-UNDO.
DEFINE VARIABLE cButton        AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cAnswer        AS CHARACTER    NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
  ASSIGN
    coObjectType
  .
END.

ASSIGN cErrorText = "":U.
   /* Only ask question if it is a new object */ 
   IF NOT glNewObject THEN DO:
      RUN askQuestion IN gshSessionManager (INPUT "Do you wish to delete this page layout before recreating?",    /* messages */
                                            INPUT "&Yes,&No":U,     /* button list */
                                            INPUT "&No":U,         /* default */
                                            INPUT "&No":U,          /* cancel */
                                            INPUT "Delete First":U, /* title */
                                            INPUT "":U,             /* datatype */
                                            INPUT "":U,             /* format */
                                            INPUT-OUTPUT cAnswer,   /* answer */
                                            OUTPUT cButton          /* button pressed */
                                            ).
  
      IF REPLACE(cButton,"&":U,"":U) = "YES":U THEN DO:
        SESSION:SET-WAIT-STATE("GENERAL":U).
        RUN deleteObject IN hGenObj
            (INPUT  fiLayoutName,
             OUTPUT cErrorText).
        SESSION:SET-WAIT-STATE("":U).
        IF cErrorText NE "":U THEN DO:   
            RUN showMessages IN gshSessionManager (INPUT  cErrorText,            /* message to display */
                                                   INPUT  "ERR":U,                  /* error type */
                                                   INPUT  "&OK":U,                  /* button list */
                                                   INPUT  "&OK":U,                  /* default button */ 
                                                   INPUT  "&OK":U,                  /* cancel button */
                                                   INPUT  "DeleteFirst failed":U,   /* error window title */
                                                   INPUT  YES,                      /* display if empty */ 
                                                   INPUT  THIS-PROCEDURE,           /* container handle */ 
                                                   OUTPUT cButton                   /* button pressed */
                                                  ).
            RETURN.
        END.
      END.
    END. /* Not a New Object */

    /* Generate the object and smartobject records for the new layout,
       along with their default attributes.
    */
  tran-block:
  DO TRANSACTION ON ERROR UNDO tran-block, LEAVE tran-block:
ASSIGN cattrnames = "template":U
        cattrvalues = "yes":U
       
     .
    SESSION:SET-WAIT-STATE("GENERAL":U).
    RUN storeObject IN hGenObj
        (INPUT coObjectType,            /* Object Type -- NB: Change later! */
         INPUT fiProductModule,         /* Product Module code */
         INPUT FiLayoutName,            /* Object Name */
         INPUT FiLayoutDescription,     /* Object Description */
         INPUT cattrnames,
         INPUT cattrvalues,
         OUTPUT dContainer).        
    SESSION:SET-WAIT-STATE("":U).
    IF RETURN-VALUE NE "":U THEN
    DO:
      ASSIGN cErrorText = RETURN-VALUE.
      RUN showMessages IN gshSessionManager (INPUT  cErrorText,               /* message to display */
                                             INPUT  "ERR":U,                  /* error type */
                                             INPUT  "&OK":U,                  /* button list */
                                             INPUT  "&OK":U,                  /* default button */ 
                                             INPUT  "&OK":U,                  /* cancel button */
                                             INPUT  "Error from Container creation":U,                /* error window title */
                                             INPUT  YES,                      /* display if empty */ 
                                             INPUT  THIS-PROCEDURE,           /* container handle */ 
                                             OUTPUT cButton                   /* button pressed */
                                            ).
      
      
        UNDO tran-block, LEAVE tran-block.
    END.

    
    /* Now create placeholder instances for the objects.  */
  
    FOR EACH ttObject:
      SESSION:SET-WAIT-STATE("GENERAL":U).
      RUN StoreObjectInstance IN hGenObj
        (INPUT dContainer,           
         INPUT IF ttObject.TemplateObj THEN   /* SmartObject name or templ. */
                 templateObjectName(ttObject.ObjectType)
               ELSE ttObject.ObjectName,            
         
         INPUT  ttObject.POSITION,    /* layout position */
         OUTPUT dSmartObject,        /* Smart Object ID */
         OUTPUT dInstance).          /* Instance Object ID */
      SESSION:SET-WAIT-STATE("":U).
      
      IF RETURN-VALUE NE "":U THEN
      DO:
        ASSIGN cErrorText = RETURN-VALUE.
        RUN showMessages IN gshSessionManager (INPUT  cErrorText,               /* message to display */
                                               INPUT  "ERR":U,                  /* error type */
                                               INPUT  "&OK":U,                  /* button list */
                                               INPUT  "&OK":U,                  /* default button */ 
                                               INPUT  "&OK":U,                  /* cancel button */
                                               INPUT  "Error from Instance creation":U,                /* error window title */
                                               INPUT  YES,                      /* display if empty */ 
                                               INPUT  THIS-PROCEDURE,           /* container handle */ 
                                               OUTPUT cButton                   /* button pressed */
                                              ).
        UNDO tran-block, LEAVE tran-block.
      END.
      /* Save the Instance Object ID in the temp-table so that later we
         use it to replace the sequence number when creating the links. 
         NB: Do we also need to save other obj values? */
      ELSE ttObject.InstanceObjID = dInstance.

        RUN StoreAttributeValues IN hGenObj ( INPUT 0,  /* derived from the smartobject */
                                              INPUT dSmartObject,
                                              INPUT dContainer,
                                              INPUT ttObject.InstanceObjID,
                                              INPUT ttObject.tAttributeLabels,
                                              INPUT ttObject.tAttributeValues ).
        IF RETURN-VALUE NE "":U THEN
        DO:
          ASSIGN cErrorText = RETURN-VALUE.
          RUN showMessages IN gshSessionManager (INPUT  cErrorText,               /* message to display */
                                                 INPUT  "ERR":U,                  /* error type */
                                                 INPUT  "&OK":U,                  /* button list */
                                                 INPUT  "&OK":U,                  /* default button */ 
                                                 INPUT  "&OK":U,                  /* cancel button */
                                                 INPUT  "Error from Instance creation":U,                /* error window title */
                                                 INPUT  YES,                      /* display if empty */ 
                                                 INPUT  THIS-PROCEDURE,           /* container handle */ 
                                                 OUTPUT cButton                   /* button pressed */
                                                ).
          UNDO tran-block, LEAVE tran-block.
        END.

      

    END.   /* END FOR EACH ttObject */

    /* NB: In generateObjectController there's code to deal with 
       DataSourceNames; what do we do with that? Also, do we need to
       set something about PArent Menu? */
    
   /* Now create links to connect the objects.*/
    FOR EACH ttLink:

        IF ttLink.LinkSource NE "<container>":U THEN     
        DO:
            /* Translate the position of the object to an Object ID */
            FIND ttObject WHERE parseLink(ttLink.LinkSource) = ttObject.POSITION.
            dSourceID = ttObject.InstanceObjID.
        END.    /* END DO for LinkSource */
        ELSE dSourceID = 0.

        IF ttLink.LinkTarget NE "<container>":U THEN     
        DO:
            /* Translate the position of the object to an Object ID */
            FIND ttObject WHERE parseLink(ttLink.LinkTarget) = ttObject.POSITION.
            dTargetID = ttObject.InstanceObjID.
        END.    /* END DO for LinkSource */
        ELSE dTargetID = 0.
        
        SESSION:SET-WAIT-STATE("GENERAL":U).
        RUN StoreLink IN hgenObj
            (INPUT ttLink.LinkName,   /* NB: User Link Name removed for now */
             INPUT dContainer,        /* Container ID */
             INPUT dSourceID,         /* Link Source (0 for Container) */
             INPUT dTargetID).        /* Link Target (0 for Container) */
        SESSION:SET-WAIT-STATE("":U).

        IF RETURN-VALUE NE "":U THEN DO:
          ASSIGN cErrorText = RETURN-VALUE.
          RUN showMessages IN gshSessionManager (INPUT  cErrorText,               /* message to display */
                                                 INPUT  "ERR":U,                  /* error type */
                                                 INPUT  "&OK":U,                  /* button list */
                                                 INPUT  "&OK":U,                  /* default button */ 
                                                 INPUT  "&OK":U,                  /* cancel button */
                                                 INPUT  "Error from Link creation":U,                /* error window title */
                                                 INPUT  YES,                      /* display if empty */ 
                                                 INPUT  THIS-PROCEDURE,           /* container handle */ 
                                                 OUTPUT cButton                   /* button pressed */
                                                ).
          UNDO tran-block, LEAVE tran-block.
        END.  /* END DO on error */
    END.   /* END DO for each SmartLink */
  END.   /* END TRANSACTION */
  
  IF cerrorText EQ "":U THEN DO:
      SESSION:SET-WAIT-STATE("":U).
      MESSAGE "Page Layout ":U + fiLayoutName + " Saved.":U
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
      ASSIGN lempty = NO
             lmodified = NO.
  END.
RETURN.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveObject C-Win 
PROCEDURE saveObject :
/*------------------------------------------------------------------------------
  Purpose:  User can modify and save the object position   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE cNewPosn AS CHARACTER NO-UNDO.
DEFINE VARIABLE cOldPosn AS CHARACTER NO-UNDO.

 /* save off the record we are modifying*/
 ASSIGN cOldPosn = ttobject.POSITION.

 /* assign the new position*/
 DO WITH FRAME {&FRAME-NAME}:
     ASSIGN toBottom
            coRow
            coPosition.
 END.

 ASSIGN cNewPosn =
           IF toBottom:CHECKED THEN "B9":U + coPosition
           ELSE "M":U + coRow + coPosition.

 IF ttobject.POSITION NE cNewPosn THEN DO:

   /* check if any other object already has this new position */
   /* if so, then give error */
   FIND FIRST ttObject WHERE ttObject.POSITION = cNewPosn NO-ERROR.
      IF AVAILABLE ttObject THEN DO:
         MESSAGE "Object Already Exists at Position:" cNewPosn
              VIEW-AS ALERT-BOX.
          RETURN.
      END.

   /* if unique posn, then assign it 
   */
   FIND FIRST ttobject WHERE ttobject.POSITION = cOldPosn.
   ASSIGN ttobject.POSITION = cNewPosn.

   /* also need to change the link tt and list-items */
   FOR EACH ttlink:
       IF ttlink.linkSOURCE BEGINS cOldPosn THEN 
           ttlink.linkSOURCE = REPLACE(ttlink.linkSOURCE,cOldPosn,cNewPosn).
       IF ttlink.linkTARGET BEGINS cOldPosn THEN 
           ttlink.linkTARGET = REPLACE(ttlink.linkTARGET,cOldPosn,cNewPosn).
   END.
   coLinkSource:LIST-ITEMS = REPLACE(coLinkSource:LIST-ITEMS,cOldPosn,cNewPosn).
   coLinktarget:LIST-ITEMS = REPLACE(coLinkTarget:LIST-ITEMS,cOldPosn,cNewPosn).

 END. /* end if oldposn ne newposn */

 ASSIGN ttObject.tAttributeLabels = gcAttributeLabels
        ttObject.tAttributeValues = gcAttributeValues
        .

 ASSIGN laddMode = YES
        lModified = YES.
 RUN setMode.  /* addmode = no */
 RUN displayBrowse.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setLayoutButtons C-Win 
PROCEDURE setLayoutButtons :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER mode AS CHARACTER NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:

CASE mode:
    WHEN "add":U OR WHEN "update":U THEN
 
      ASSIGN 
        MENU-ITEM m_AddLayout:SENSITIVE IN MENU MENU-BAR-C-Win      = NO
        MENU-ITEM m_OpenLayout:SENSITIVE IN MENU MENU-BAR-C-Win     = NO
        MENU-ITEM m_SaveLayout:SENSITIVE IN MENU MENU-BAR-C-Win     = YES
        MENU-ITEM m_UpdateLayout:SENSITIVE IN MENU MENU-BAR-C-Win   = NO
        MENU-ITEM m_CloseLayout:SENSITIVE IN MENU MENU-BAR-C-Win   = YES

        buAddLayout:SENSITIVE             = NO
        buSaveLayout:SENSITIVE            = YES
        buUpdateLayout:SENSITIVE          = NO
        buCloseLayout:SENSITIVE           = YES

        buAddObject:SENSITIVE             = YES
        buSaveObject:SENSITIVE            = NO
        buDeleteObject:SENSITIVE          = NO
        buCancelUpdate:SENSITIVE          = NO
        buProperties:SENSITIVE            = NO

        buAddLink:SENSITIVE               = YES
        buDeleteLink:SENSITIVE            = IfLinks()

        buProductLookup:SENSITIVE     =  YES
        buObjectLookup:SENSITIVE      =  YES

        fiObjectName:SENSITIVE           = YES
        fiObjectName:READ-ONLY           = NO
        fiObjectDescription:READ-ONLY     = YES
        fiProductModule:SENSITIVE         = YES
        fiProductModule:READ-ONLY        = NO
        fiLayoutName:SENSITIVE       =  YES
        fiLayoutName:READ-ONLY      =  NO
        fiLayoutDescription:READ-ONLY =  NO
        fiLayoutDescription:SENSITIVE =  YES
        coObjectType:SENSITIVE        =  mode = "Add":U

        objectBrowse:SENSITIVE        =  YES  
        coLinkSource:SENSITIVE        =  YES
        coLinkType:SENSITIVE          =  YES
        coLinkTarget:SENSITIVE        =  YES
        LinkBrowse:SENSITIVE          =  YES 

        Tobottom:SENSITIVE = YES
        coRow:SENSITIVE    = YES
        coPosition:SENSITIVE    = YES
        .
        
   
    END CASE. /* case */
      
    
        
END. /* end do with frame */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setMode C-Win 
PROCEDURE setMode :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN buAddObject:SENSITIVE         = lAddMode
               buSaveObject:SENSITIVE        = NOT lAddMode
               buDeleteObject:SENSITIVE      = NOT lAddMode
               buCancelUpdate:SENSITIVE      = NOT laddmode
               buProperties:SENSITIVE        = NOT lAddMode AND CAN-DO("SmartToolbar,DynBrow,SDO",ttObject.objectType)
               fiObjectName:SENSITIVE        = lAddMode
               fiObjectDescription:SENSITIVE = lAddMode
               fiLayoutName:SENSITIVE        = laddmode
               fiLayoutDescription:SENSITIVE = laddmode 
               fiProductModule:SENSITIVE     = laddmode
               fiObjectName:SENSITIVE        = laddmode 
               buObjectLookup:SENSITIVE      = laddmode
               fiObjectDescription:SENSITIVE = laddmode
               objectBrowse:SENSITIVE        = laddmode  
               coLinkSource:SENSITIVE        = laddmode 
               coLinkType:SENSITIVE          = laddmode 
               coLinkTarget:SENSITIVE        = laddmode
               LinkBrowse:SENSITIVE          = laddmode 
               buAddLink:SENSITIVE           = laddmode
               buDeleteLink:SENSITIVE        = IF iflinks() THEN laddmode ELSE FALSE               
               coRow:SENSITIVE               = YES      WHEN lAddMode
               coPosition:SENSITIVE          = YES      WHEN lAddMode
               .
    END.    /* with frame ... */

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setProperties C-Win 
PROCEDURE setProperties :
/*------------------------------------------------------------------------------
  Purpose:    display the curr browse record in the viewer  
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cSdoname AS CHARACTER  NO-UNDO.

IF NOT AVAILABLE ttobject THEN RETURN.
  DO WITH FRAME {&FRAME-NAME}:
  
    ASSIGN 
      fiObjectName:SCREEN-VALUE = ttobject.objectname.
    
    IF ttobject.objectname <> "":U THEN DO:
      
        FIND FIRST ttlink NO-LOCK
          WHERE ttlink.linkName   = "Data":U
          AND   ENTRY(2,ttlink.linkTarget," ":U) = ttobject.objectname NO-ERROR.

      IF AVAILABLE ttLink THEN
          ASSIGN cSdoName = ENTRY(2,ttlink.linkSource," ":U).
      ELSE
          ASSIGN cSdoName = "":U.

      RUN af/cod2/afpropwin.p ( INPUT  ttObject.ObjectName,
                                INPUT  ttObject.tObjectInstanceObj,
                                INPUT  cSDOName,
                                INPUT  (IF ttObject.tObjectInstanceObj EQ 0 THEN NO ELSE YES),    /* return only changes? */
                                OUTPUT gcAttributeLabels,
                                OUTPUT gcAttributeValues ) NO-ERROR.
        IF ERROR-STATUS:ERROR OR RETURN-VALUE <> "":U THEN
            MESSAGE RETURN-VALUE 
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.       
    END.

    RUN setMode.  
  
  END. /* do with frame */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE UpdateLayout C-Win 
PROCEDURE UpdateLayout :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* disable/enable for update mode*/
RUN setLayoutButtons("update":U).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateLayout C-Win 
PROCEDURE validateLayout :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER cErrorText AS CHARACTER NO-UNDO.

ASSIGN cErrorText = "":U.
DO WITH FRAME {&FRAME-NAME}:
    ASSIGN fiLayoutName
           fiLayoutDescription
           fiProductModule.
END.

IF fiLayoutName EQ "":U THEN DO:
      ASSIGN cErrorText = 
          "Please enter a Layout Object Name.":U.
          MESSAGE cErrortext VIEW-AS ALERT-BOX INFO BUTTONS OK.
      APPLY "entry":U TO fiLayoutName IN FRAME {&FRAME-NAME}.
      RETURN.
END.

IF fiLayoutDescription EQ "":U THEN DO:
      ASSIGN cErrorText = 
          "Please enter a Layout Description":U.
          MESSAGE cErrortext VIEW-AS ALERT-BOX INFO BUTTONS OK.
      APPLY "entry":U TO fiLayoutDescription IN FRAME {&FRAME-NAME}.
      RETURN.
END.

IF fiProductModule EQ "":U THEN DO:
      ASSIGN cErrorText = 
          "Please enter a Product Module.":U.
          MESSAGE cErrortext VIEW-AS ALERT-BOX INFO BUTTONS OK.
      APPLY "entry":U TO fiProductModule IN FRAME {&FRAME-NAME}.
      RETURN.
END.

RUN validatePositions(OUTPUT cErrorText).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validatePositions C-Win 
PROCEDURE validatePositions :
/*------------------------------------------------------------------------------
  Purpose:     Look at the positions of the objects and make sure they don't have
               any skipped rows or positions within main or bottom area. For
               example, can't have row 2 if no row 1. Can't have posn 4 if no 3.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER cText AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPrevArea     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPrevRow      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPrevPosn     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cArea         AS CHARACTER NO-UNDO.
DEFINE VARIABLE cRow          AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPosn         AS CHARACTER NO-UNDO.
DEFINE BUFFER   ttBuf         FOR ttObject.

ASSIGN cText = "":U
       cPrevPosn = "":U
       cPrevArea = "":U
       cPrevRow  = "":U.

FOR EACH ttBuf BY ttBuf.POSITION:
  
    ASSIGN cPosn = SUBSTR(ttBuf.POSITION,3,1)
           cArea = SUBSTR(ttBuf.POSITION,1,1)
           cRow  = SUBSTR(ttBuf.POSITION,2,1).
    
    IF cArea EQ "M":U AND cRow = "0":U THEN NEXT.   /* ignore data objects as they are not visual*/

    IF cPrevArea NE "":U THEN DO:  /* then this isn't first ttBuf rec */
        IF cArea EQ cPrevArea THEN DO:
      
            /* if area is the same and row is the same and posn isn't c or r*/
            /* then check that the posn isn't out of sequence */
            IF cRow EQ cPrevRow AND LOOKUP(cPosn,"C,R":U) EQ 0 THEN DO:
                  IF lookup(cPrevPosn,"C,R":U) EQ 0 AND 
                      cPosn NE string(int(cPrevPosn) + 1)
                  THEN DO:
                    ASSIGN cText = ttBuf.POSITION + ": You omitted position ":U 
                           + STRING(int(cPrevPosn) + 1) +
                           " in area ":U + cArea.
                    MESSAGE cText
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
                    LEAVE.
                  END. /* END IF LOOKUP */
            END. /* END IF CROW EQ PREV*/
            /* else means this is a different row than previous rec */
            /* so make sure this row isn't out of sequence          */
            ELSE IF cRow NE STRING(INT(cPrevRow) + 1) AND LOOKUP(cPosn,"C,R":U) EQ 0 THEN DO: 
                ASSIGN cText = ttBuf.position + ": You omitted row ":U 
                           + STRING(int(cPrevRow) + 1) + " in area ":U +
                           cArea.
                    MESSAGE cText
                        VIEW-AS ALERT-BOX INFO BUTTONS OK.
                    LEAVE.
            END. /*end else if crow */
            /* different row, is posn 1? */
            ELSE IF LOOKUP(cposn,"C,R,1":U) EQ 0 THEN DO:
                ASSIGN cText = ttBuf.POSITION + ": You omitted Position 1 in area ":U +
                    IF carea = "M":U  THEN "Main":U ELSE "Bottom":U.
                MESSAGE cText
                    VIEW-AS ALERT-BOX INFO BUTTONS OK.
                LEAVE.
            END.
        END.
        /* first ttBuf rec in that area                              */
        /* it should always be row 1 since it is the first in that area */
        ELSE do:
            
            IF cRow NE "1":U AND cArea = "M":U THEN DO: 
              ASSIGN cText = ttBuf.position + ": You omitted Row 1 in Area ":U + 
                 "Main":U .
              MESSAGE cText VIEW-AS ALERT-BOX INFO BUTTONS OK.
              LEAVE.
            END.

            IF cPosn NE "C":U AND cPosn NE "R":U
            AND int(cPosn) > 1 THEN DO: 
               ASSIGN cText = ttBuf.position + ": You omitted Position 1 in Area ":U + 
                   IF cArea EQ "M":U THEN "Main":U ELSE "Bottom":U.
               MESSAGE cText VIEW-AS ALERT-BOX INFO BUTTONS OK.
               LEAVE.
            END.
        END. /* END ELSE DO */
    END. /* end if prevarea Ne "" */
    /* first object in the whole temptable */
    ELSE do:
       
        IF cRow NE "1":U AND cArea = "M":U THEN DO:
          ASSIGN cText = ttBuf.position + ": You omitted Row 1 in Area ":U + 
            "Main":U .
          MESSAGE cText VIEW-AS ALERT-BOX INFO BUTTONS OK.
          LEAVE.
        END. /* end if crow ne 1*/
        IF cPosn NE "C":U AND cPosn NE "R":U
            AND int(cPosn) > 1 THEN DO: 
               ASSIGN cText = ttBuf.position + ": You omitted Position 1 in Area ":U + 
                   IF cArea = "M":U THEN "Main":U ELSE "Bottom":U.
               MESSAGE cText VIEW-AS ALERT-BOX INFO BUTTONS OK.
               LEAVE.
            END. /* end cposn ne "c"*/
    END. /* end else do*/
    
    ASSIGN cPrevArea = cArea
           cPrevRow  = cRow
           cPrevPosn = cPosn.
    
END. /* end for each ttBuf */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE viewObject C-Win 
PROCEDURE viewObject :
/*------------------------------------------------------------------------------
  Purpose:    display the curr browse record in the viewer  
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF NOT AVAILABLE ttobject THEN RETURN.
DO WITH FRAME {&FRAME-NAME}:

ASSIGN fiObjectName:SCREEN-VALUE         = ttobject.objectname
        fiObjectDescription:SCREEN-VALUE = "":U
        .

   /* figure out if we need to disable the position info */
   /* we do this if object is non-visual like sdo,sbo    */
   RUN  disablePosition(ttobject.POSITION).
   ASSIGN toBottom:CHECKED = 
            IF ttobject.POSITION BEGINS "B":U THEN YES
            ELSE NO.
   /* if visual object then show its posn */
   IF SUBSTRING(ttobject.POSITION,2,1) NE "0":U THEN
       ASSIGN
          coRow:SCREEN-VALUE = substring(ttobject.POSITION,2,1)
          coPosition:SCREEN-VALUE = substring(ttobject.position,3,1).
                    
 
RUN setMode.  
END. /* do with frame */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION ifLinks C-Win 
FUNCTION ifLinks RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  FIND FIRST ttlink NO-ERROR. 
  IF AVAILABLE ttlink 
    THEN RETURN TRUE.
  ELSE RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION parseLink C-Win 
FUNCTION parseLink RETURNS CHARACTER
  ( INPUT cName AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Return the position part of the link source or link target
            to store in the ttlink table since it is unique.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cStr AS CHARACTER NO-UNDO.
  ASSIGN cStr = IF cName BEGINS "<container>":U 
                THEN "<container>":U
                ELSE SUBSTR(cName,1,3).

  RETURN cStr.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

