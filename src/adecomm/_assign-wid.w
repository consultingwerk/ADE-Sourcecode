&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/***********************************************************************
* Copyright (C) 2007-2008 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*------------------------------------------------------------------------

  File: adecomm/_assign-wid.w

  Description: This is the 'Runtime Widget-id Assignment Tool' main window. 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Marcelo Ferrante
  
  Created: May 09, 2007

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
{protools/ptlshlp.i}  /* help definitions        */
{src/adm2/globals.i}
{src/adm2/ttaction.i}
{src/adm2/tttoolbar.i}
{src/adm2/treettdef.i}
{adecomm/dswid.i}

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE gcStatus    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE ghDSLibrary AS HANDLE    NO-UNDO.

DEFINE TEMP-TABLE ttBrowser NO-UNDO
FIELD cKey            AS CHARACTER
FIELD cLabel          AS CHARACTER
FIELD cContainer      AS CHARACTER
FIELD cContainerPath  AS CHARACTER
FIELD cContainerName  AS CHARACTER
FIELD cExpanded       AS CHARACTER
FIELD lParentExpanded AS LOGICAL
FIELD WidgetID        AS INTEGER
FIELD iOrder          AS INTEGER
FIELD cStatus         AS CHARACTER /*U=Updated;D=Deleted;SD=Deleted by the sync process*/
FIELD cParent         AS CHARACTER
FIELD cTTName         AS CHARACTER
FIELD cTTFieldID      AS CHARACTER
INDEX ckey AS PRIMARY UNIQUE cContainer cKey cParent.

/*This temp-table is used in syncStaticObject to store the InstanceChildren record before
  the container is synchronized, and then detect the deletions.*/
DEFINE TEMP-TABLE beforeInstanceChildren NO-UNDO LIKE InstanceChildren.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME brObjects

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttBrowser

/* Definitions for BROWSE brObjects                                     */
&Scoped-define FIELDS-IN-QUERY-brObjects ttBrowser.cExpanded ttBrowser.cLabel ttBrowser.WidgetID   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brObjects ttBrowser.WidgetID   
&Scoped-define ENABLED-TABLES-IN-QUERY-brObjects ttBrowser
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brObjects ttBrowser
&Scoped-define SELF-NAME brObjects
&Scoped-define QUERY-STRING-brObjects FOR EACH ttBrowser NO-LOCK       WHERE ttBrowser.cContainer      = coContainer:SCREEN-VALUE AND             ttBrowser.lParentExpanded = TRUE AND             ttBrowser.cStatus NE "D":U             BY ttBrowser.iOrder INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-brObjects OPEN QUERY {&SELF-NAME} FOR EACH ttBrowser NO-LOCK       WHERE ttBrowser.cContainer      = coContainer:SCREEN-VALUE AND             ttBrowser.lParentExpanded = TRUE AND             ttBrowser.cStatus NE "D":U             BY ttBrowser.iOrder INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-brObjects ttBrowser
&Scoped-define FIRST-TABLE-IN-QUERY-brObjects ttBrowser


/* Definitions for FRAME DEFAULT-FRAME                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME ~
    ~{&OPEN-QUERY-brObjects}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-4 buAdd RECT-5 RECT-8 rcRight rcBrowser ~
rcToolbar fiXMLFileName coContainer brObjects buNew buOpen buTree buSync ~
buCancel buRemove buSave 
&Scoped-Define DISPLAYED-OBJECTS fiXMLFileName coContainer 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD checkTransaction C-Win 
FUNCTION checkTransaction RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFileExtension C-Win 
FUNCTION getFileExtension RETURNS CHARACTER
  (INPUT pcFileName AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD isABRunning C-Win 
FUNCTION isABRunning RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setWidgetStatus C-Win 
FUNCTION setWidgetStatus RETURNS LOGICAL
  (INPUT pcStatus AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU m_File 
       MENU-ITEM m_Exit         LABEL "Exit"          .

DEFINE SUB-MENU m_Options 
       MENU-ITEM m_AssignonAdd  LABEL "Assign Default Values on Add"
              TOGGLE-BOX
       MENU-ITEM m_Assign_Default_Values LABEL "Re-assign Default Values".

DEFINE SUB-MENU m_Help 
       MENU-ITEM m__About_Runtime_Widget-id_As LABEL " About Runtime Widget-id Assignment Tool".

DEFINE MENU MENU-BAR-C-Win MENUBAR
       SUB-MENU  m_File         LABEL "File"          
       SUB-MENU  m_Options      LABEL "Options"       
       SUB-MENU  m_Help         LABEL "Help"          .


/* Definitions of the field level widgets                               */
DEFINE BUTTON buAdd 
     IMAGE-UP FILE "adeicon/add.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "Add Containers" 
     SIZE 5 BY 1.14 TOOLTIP "Add Containers to XML file".

DEFINE BUTTON buCancel 
     IMAGE-UP FILE "adeicon/cancel.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "Cancel" 
     SIZE 5 BY 1.14 TOOLTIP "Cancel Updates".

DEFINE BUTTON buNew 
     IMAGE-UP FILE "adeicon/new.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "New" 
     SIZE 5 BY 1.14 TOOLTIP "New XML file".

DEFINE BUTTON buOpen 
     IMAGE-UP FILE "adeicon/open.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "Open" 
     SIZE 5 BY 1.14 TOOLTIP "Open XML file".

DEFINE BUTTON buRemove 
     IMAGE-UP FILE "adeicon/delete.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "Remove Container" 
     SIZE 5 BY 1.14 TOOLTIP "Remove Container from XML file".

DEFINE BUTTON buSave 
     IMAGE-UP FILE "adeicon/save.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "Save" 
     SIZE 5 BY 1.14 TOOLTIP "Save to XML file".

DEFINE BUTTON buSync 
     IMAGE-UP FILE "adeicon/synch.gif":U
     IMAGE-INSENSITIVE FILE "adeicon/synchd.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "Synchronize" 
     SIZE 5 BY 1.14 TOOLTIP "Synchronize XML data with source object".

DEFINE BUTTON buTree 
     IMAGE-UP FILE "adeicon/collapseall.gif":U
     IMAGE-INSENSITIVE FILE "adeicon/collapsealld.gif":U NO-FOCUS FLAT-BUTTON
     LABEL "Collapse All" 
     SIZE 5 BY 1.14 TOOLTIP "Collapse All".

DEFINE VARIABLE coContainer AS CHARACTER FORMAT "X(256)":U INITIAL "0" 
     LABEL "Container" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","0"
     DROP-DOWN-LIST
     SIZE 56.6 BY 1 NO-UNDO.

DEFINE VARIABLE fiXMLFileName AS CHARACTER FORMAT "X(1024)":U 
     LABEL "XML File Name" 
     CONTEXT-HELP-ID 0
     VIEW-AS FILL-IN 
     SIZE 51.2 BY 1 NO-UNDO.

DEFINE RECTANGLE rcBrowser
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 69.4 BY 17.62.

DEFINE RECTANGLE rcRight
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE .2 BY 1.33.

DEFINE RECTANGLE rcToolbar
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 69.4 BY 1.33.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE .2 BY 1.33.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE .2 BY 1.33.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE .2 BY 1.33.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brObjects FOR 
      ttBrowser SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brObjects
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brObjects C-Win _FREEFORM
  QUERY brObjects NO-LOCK DISPLAY
      ttBrowser.cExpanded LABEL "" FORMAT "X(1)" WIDTH 2
      ttBrowser.cLabel FORMAT "X(128)" WIDTH 50
      ttBrowser.WidgetID

ENABLE ttBrowser.WidgetID
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-BOX NO-LABELS NO-ASSIGN NO-ROW-MARKERS SEPARATORS SIZE 67 BY 14.76 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     buAdd AT ROW 1.24 COL 12.6 WIDGET-ID 208
     fiXMLFileName AT ROW 2.71 COL 16 COLON-ALIGNED WIDGET-ID 230
     coContainer AT ROW 3.86 COL 2.4 WIDGET-ID 2
     brObjects AT ROW 5 COL 2.2 WIDGET-ID 200
     buNew AT ROW 1.24 COL 1.6 WIDGET-ID 60
     buOpen AT ROW 1.24 COL 6.6 WIDGET-ID 6
     buTree AT ROW 1.19 COL 39.6 WIDGET-ID 4
     buSync AT ROW 1.19 COL 33.6 WIDGET-ID 224
     buCancel AT ROW 1.24 COL 27.6 WIDGET-ID 12
     buRemove AT ROW 1.24 COL 17.6 WIDGET-ID 206
     buSave AT ROW 1.24 COL 22.6 WIDGET-ID 10
     RECT-4 AT ROW 1.1 COL 12 WIDGET-ID 216
     RECT-5 AT ROW 1.1 COL 33 WIDGET-ID 218
     RECT-8 AT ROW 1.1 COL 39 WIDGET-ID 226
     rcRight AT ROW 1.1 COL 45 WIDGET-ID 228
     rcBrowser AT ROW 2.43 COL 1 WIDGET-ID 232
     rcToolbar AT ROW 1.1 COL 1 WIDGET-ID 234
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1.14
         SIZE 70.2 BY 19.57 DROP-TARGET WIDGET-ID 100.


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
         TITLE              = "Runtime WIDGET-ID Assignment Tool"
         HEIGHT             = 19.19
         WIDTH              = 69.6
         MAX-HEIGHT         = 45.67
         MAX-WIDTH          = 280
         VIRTUAL-HEIGHT     = 45.67
         VIRTUAL-WIDTH      = 280
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

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU MENU-BAR-C-Win:HANDLE.

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT C-Win:LOAD-ICON("adeicon/assignwid.ico":U) THEN
    MESSAGE "Unable to load icon: adeicon/assignwid.ico"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME                                                           */
/* BROWSE-TAB brObjects coContainer DEFAULT-FRAME */
ASSIGN 
       brObjects:COLUMN-RESIZABLE IN FRAME DEFAULT-FRAME       = TRUE.

/* SETTINGS FOR COMBO-BOX coContainer IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
ASSIGN 
       fiXMLFileName:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brObjects
/* Query rebuild information for BROWSE brObjects
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH ttBrowser NO-LOCK
      WHERE ttBrowser.cContainer      = coContainer:SCREEN-VALUE AND
            ttBrowser.lParentExpanded = TRUE AND
            ttBrowser.cStatus NE "D":U
            BY ttBrowser.iOrder INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE brObjects */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Runtime WIDGET-ID Assignment Tool */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF FOCUS:NAME = "WidgetID":U THEN
  DO:
        ASSIGN ttBrowser.WidgetID = INT(FOCUS:SCREEN-VALUE).
        APPLY "LEAVE":U TO FOCUS.
  END.

IF NOT checkTransaction() THEN
   RETURN NO-APPLY.

IF VALID-HANDLE(ghDSLibrary) THEN
    DELETE OBJECT ghDSLibrary NO-ERROR.
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Runtime WIDGET-ID Assignment Tool */
DO:
  /* This event will close the window and terminate the procedure.  */

  IF VALID-HANDLE(FOCUS) AND FOCUS:NAME = "WidgetID":U THEN
  DO:
      ASSIGN ttBrowser.WidgetID = INT(FOCUS:SCREEN-VALUE).
      APPLY "LEAVE":U TO FOCUS.
  END.

  IF NOT checkTransaction() THEN
   RETURN NO-APPLY.

  IF VALID-HANDLE(ghDSLibrary) THEN
      DELETE OBJECT ghDSLibrary NO-ERROR.

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-MAXIMIZED OF C-Win /* Runtime WIDGET-ID Assignment Tool */
DO:
  RUN windowResized.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-RESIZED OF C-Win /* Runtime WIDGET-ID Assignment Tool */
DO:
  RUN windowResized.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DEFAULT-FRAME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DEFAULT-FRAME C-Win
ON DROP-FILE-NOTIFY OF FRAME DEFAULT-FRAME
DO:
DEFINE VARIABLE cFileType AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cFileExt  AS CHARACTER   NO-UNDO.

/*If a transaction is opened, this option is disabled*/
IF gcStatus = "Started":U THEN
   RETURN NO-APPLY.

/*Checks that only one file was dropped*/
IF SELF:GET-DROPPED-FILE(2) NE "" THEN
DO:
    MESSAGE "Only one file at time could be dropped in this window"
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RETURN NO-APPLY.
END.

ASSIGN FILE-INFO:FILE-NAME = SELF:GET-DROPPED-FILE(1)
       cFileType = FILE-INFO:FILE-TYPE.

/*If the dropped file is not a file, just return no-apply*/
IF INDEX(cFileType, "F") EQ 0 THEN RETURN NO-APPLY.

/*Gets the extension of the file*/
ASSIGN cFileExt = getFileExtension(FILE-INFO:FILE-NAME).

IF cFileExt = "xml":U THEN
RUN loadXML (INPUT FILE-INFO:FILE-NAME) NO-ERROR.
IF ERROR-STATUS:ERROR THEN RETURN NO-APPLY.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brObjects
&Scoped-define SELF-NAME brObjects
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brObjects C-Win
ON LEFT-MOUSE-DBLCLICK OF brObjects IN FRAME DEFAULT-FRAME
DO:
DEFINE VARIABLE cParentKey AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cParentExpanded AS CHARACTER   NO-UNDO.

DEFINE VARIABLE rRow        AS ROWID       NO-UNDO.
DEFINE VARIABLE iCurrentRow AS INTEGER     NO-UNDO.

DEFINE BUFFER bBrowser FOR TEMP-TABLE ttBrowser.

IF brObjects:QUERY:NUM-RESULTS = 0 THEN
    RETURN NO-APPLY.

ASSIGN cParentKey      = ttBrowser.cKey
       cParentExpanded = ttBrowser.cExpanded
       rRow            = ROWID(ttBrowser)
       iCurrentRow     = brObjects:FOCUSED-ROW.

IF cParentExpanded = "" THEN RETURN NO-APPLY.

FOR EACH ttBrowser WHERE ttBrowser.cParent = cParentKey:

    IF ttBrowser.cExpanded NE "" THEN
    ASSIGN ttBrowser.cExpanded = IF ttBrowser.cExpanded = "-" THEN "+" ELSE ttBrowser.cExpanded 
           ttBrowser.lParentExpanded = FALSE.

    FOR EACH bBrowser WHERE bBrowser.cParent = ttBrowser.cKey:
           ASSIGN bBrowser.lParentExpanded = FALSE.
    END. /*FOR EACH bBrowser*/

    IF cParentExpanded = "+" OR cParentExpanded = ">" OR cParentExpanded = "<" THEN
        ASSIGN ttBrowser.lParentExpanded = TRUE.
    ELSE
        ASSIGN ttBrowser.lParentExpanded = FALSE.

END. /*FOR EACH ttBrowser*/

{&BROWSE-NAME}:SET-REPOSITIONED-ROW(iCurrentRow,"CONDITIONAL").
{&OPEN-QUERY-{&BROWSE-NAME}}      
REPOSITION {&BROWSE-NAME} TO ROWID rRow NO-ERROR.

IF cParentExpanded = "+" THEN
   ASSIGN ttBrowser.cExpanded = "-".
ELSE
   ASSIGN ttBrowser.cExpanded = "+".

RUN updateSyncStatus.
{&BROWSE-NAME}:REFRESH().

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buAdd
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buAdd C-Win
ON CHOOSE OF buAdd IN FRAME DEFAULT-FRAME /* Add Containers */
DO:
DEFINE VARIABLE cCurrentContainers AS CHARACTER   NO-UNDO.

FOR EACH Container NO-LOCK:
    ASSIGN cCurrentContainers = cCurrentContainers + "," + TRIM(Container.contPath + "/" + Container.contName, "/").
END.

ASSIGN cCurrentContainers = TRIM(cCurrentContainers, ",").
RUN adecomm/_getwidobjs.w (INPUT cCurrentContainers,
                           INPUT fiXMLFileName:SCREEN-VALUE,
                           INPUT MENU-ITEM m_AssignonAdd:CHECKED IN MENU MENU-BAR-C-Win,
                           INPUT-OUTPUT DATASET dsWidgetID BY-REFERENCE).

RUN fillComboBox (TRUE).
APPLY "VALUE-CHANGED":U TO coContainer.
DATASET dsWidgetID:WRITE-XML("FILE", fiXMLFileName:SCREEN-VALUE IN FRAME {&FRAME-NAME}, TRUE).

IF NOT CAN-FIND(FIRST Container) THEN
setWidgetStatus("XMLEmpty":U).
ELSE
setWidgetStatus("Finished":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buCancel C-Win
ON CHOOSE OF buCancel IN FRAME DEFAULT-FRAME /* Cancel */
DO:
DEFINE VARIABLE lButton AS LOGICAL     NO-UNDO.

MESSAGE "Are you sure you want to undo the changes?" SKIP(1)
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lButton.

      IF lButton = YES THEN
        RUN undoTransaction.

      ELSE RETURN NO-APPLY.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buNew
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buNew C-Win
ON CHOOSE OF buNew IN FRAME DEFAULT-FRAME /* New */
DO:
DEFINE VARIABLE cFile AS CHARACTER   NO-UNDO.

IF NOT checkTransaction() THEN
   RETURN NO-APPLY.

  SYSTEM-DIALOG GET-FILE cFile
     FILTERS "Widget-id XML File (*.xml)" "*.xml"
     TITLE "New Widget-id XML File"
     DEFAULT-EXTENSION "xml"
     CREATE-TEST-FILE
     IN WINDOW c-win.

  /*User cancelled in the system-dialog get-file window.*/
  IF cFile = "":U THEN
    RETURN NO-APPLY.

ASSIGN fiXMLFileName:SCREEN-VALUE = cFile.
DATASET dsWidgetID:EMPTY-DATASET().
RUN fillComboBox (TRUE).
{&OPEN-QUERY-{&BROWSE-NAME}}
setWidgetStatus("XMLEmpty":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buOpen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buOpen C-Win
ON CHOOSE OF buOpen IN FRAME DEFAULT-FRAME /* Open */
DO:
DEFINE VARIABLE cFile AS CHARACTER   NO-UNDO.
  
  SYSTEM-DIALOG GET-FILE cFile
     FILTERS "Widget-id XML File (*.xml)" "*.xml"
     TITLE "Open Widget-id XML File"
     IN WINDOW c-win.

  IF cFile = "":U THEN RETURN NO-APPLY.
RUN loadXML (INPUT cFile).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buRemove
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buRemove C-Win
ON CHOOSE OF buRemove IN FRAME DEFAULT-FRAME /* Remove Container */
DO:
  RUN deleteContainer.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buSave C-Win
ON CHOOSE OF buSave IN FRAME DEFAULT-FRAME /* Save */
DO:
  RUN commitTransaction.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buSync
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buSync C-Win
ON CHOOSE OF buSync IN FRAME DEFAULT-FRAME /* Synchronize */
DO:
DEFINE VARIABLE hProcLibrary AS HANDLE      NO-UNDO.
DEFINE VARIABLE lChanged     AS LOGICAL     NO-UNDO.
RUN adecomm/_setcurs.p (INPUT "WAIT":U).
/*If the AppBuilder is running, check for objects in design mode*/

IF isABRunning() THEN
DO:
    RUN adeuib/_widfunc.p PERSISTENT SET hProcLibrary.

    IF DYNAMIC-FUNCTION('getAppBuilderStatus':U IN hProcLibrary) = "Runtime":U THEN
        RUN syncRuntimeObject (OUTPUT lChanged).

    ELSE DO:

    RUN getDesignObjectNames IN hProcLibrary (INPUT "", INPUT-OUTPUT TABLE ttObjectNames).

    FIND FIRST ttObjectNames WHERE ttObjectNames.cName = coContainer:SCREEN-VALUE NO-LOCK NO-ERROR.

    IF NOT AVAILABLE(ttObjectNames) THEN
    DO:
        MESSAGE "Container '" + coContainer:SCREEN-VALUE + "' must be opened in the AppBuilder, or executed before to use this feature."
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        DELETE OBJECT hProcLibrary.
        RETURN NO-APPLY.
    END.

    IF ttObjectNames.isStatic = TRUE THEN
    DO:
        FIND FIRST ttBrowser NO-LOCK.
        FILE-INFO:FILE-NAME = ttBrowser.cContainer.

        RUN syncStaticObject IN hProcLibrary (INPUT cContainerName,
                                              INPUT cContainerPath,
                                              INPUT FILE-INFO:FULL-PATHNAME,
                                              INPUT MENU-ITEM m_AssignonAdd:CHECKED IN MENU MENU-BAR-C-Win,
                                              OUTPUT lChanged,
                                              INPUT-OUTPUT DATASET dsWidgetID BY-REFERENCE).
    END. /*IF ttObjectName.isStatic = TRUE THEN*/
    ELSE RUN syncDynObject (OUTPUT lChanged).
    END.
END. /*IF isABRunning() THEN*/
ELSE RUN syncRuntimeObject (OUTPUT lChanged).

IF NOT lChanged THEN
DO:
    MESSAGE "No changes were found during the synchronization."
         VIEW-AS ALERT-BOX INFORMATION
         TITLE c-win:TITLE.
    RETURN NO-APPLY.
END.
RUN fillBrowseTempTable.
{&OPEN-QUERY-{&BROWSE-NAME}}
setWidgetStatus("Started":U).
DELETE OBJECT hProcLibrary.
RUN adecomm/_setcurs.p (INPUT "":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buTree
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buTree C-Win
ON CHOOSE OF buTree IN FRAME DEFAULT-FRAME /* Collapse All */
DO:
DEFINE VARIABLE rRow        AS ROWID       NO-UNDO.
DEFINE VARIABLE iCurrentRow AS INTEGER     NO-UNDO.

DEFINE BUFFER bBrowser FOR TEMP-TABLE ttBrowser.

ASSIGN rRow            = ROWID(ttBrowser)
       iCurrentRow     = brObjects:FOCUSED-ROW.

IF SELF:TOOLTIP = "Expand all":U THEN
DO:
    FOR EACH ttBrowser:
        ASSIGN ttBrowser.lParentExpanded = TRUE.

        IF ttBrowser.cExpanded NE "" THEN
           ASSIGN ttBrowser.cExpanded = "-".

        FOR EACH bBrowser WHERE bBrowser.cParent = ttBrowser.cKey:
            ASSIGN bBrowser.lParentExpanded = TRUE.
        END. /*FOR EACH bBrowser*/

    END.
    ASSIGN SELF:TOOLTIP = "Collapse All":U.
    SELF:LOAD-IMAGE("adeicon/collapseall.gif").
    RUN updateSyncStatus.
END.
ELSE DO:
    FOR EACH ttBrowser WHERE ttBrowser.lParentExpanded = TRUE:

        IF ttBrowser.cExpanded EQ "" AND ttBrowser.cParent NE "" THEN
            ASSIGN ttBrowser.lParentExpanded = FALSE.
        ELSE ASSIGN ttBrowser.cExpanded = IF ttBrowser.cExpanded NE "" THEN "+" ELSE "".

        FOR EACH bBrowser WHERE bBrowser.cParent = ttBrowser.cKey:
               ASSIGN bBrowser.lParentExpanded = FALSE.
        END. /*FOR EACH bBrowser*/
    END.

    ASSIGN SELF:TOOLTIP = "Expand All":U.
    SELF:LOAD-IMAGE("adeicon/expandall.gif").
END.

{&browse-name}:SET-REPOSITIONED-ROW(iCurrentRow,"CONDITIONAL").
{&OPEN-QUERY-{&BROWSE-NAME}}      
REPOSITION {&browse-name}  TO ROWID rRow NO-ERROR.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coContainer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coContainer C-Win
ON VALUE-CHANGED OF coContainer IN FRAME DEFAULT-FRAME /* Container */
DO:
IF NOT checkTransaction() THEN
   RETURN NO-APPLY.
  
RUN fillBrowseTempTable.

{&OPEN-QUERY-{&BROWSE-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Assign_Default_Values
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Assign_Default_Values C-Win
ON CHOOSE OF MENU-ITEM m_Assign_Default_Values /* Re-assign Default Values */
DO:
  DEFINE VARIABLE iWidgetID       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hProcGap        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE isFirstInstance AS LOGICAL   NO-UNDO INITIAL TRUE.
  DEFINE VARIABLE isFirstAction   AS LOGICAL   NO-UNDO INITIAL TRUE.
  DEFINE VARIABLE isFirstPage     AS LOGICAL   NO-UNDO INITIAL TRUE.
  DEFINE VARIABLE isFirstTreeNode AS LOGICAL   NO-UNDO INITIAL TRUE.
  DEFINE VARIABLE cOldObjectType  AS CHARACTER NO-UNDO.

  DEFINE BUFFER bttBrowser FOR ttBrowser.

  RUN adecomm/_widgaps.p PERSISTENT SET hProcGap.

  FOR EACH bttBrowser WHERE bttBrowser.cContainer = coContainer:SCREEN-VALUE IN FRAME {&FRAME-NAME} AND
            bttBrowser.cttName NE ""
            BY bttBrowser.iOrder:

            CASE bttBrowser.cttName:
                WHEN "Action":U THEN
                DO:
                    IF isFirstAction THEN
                        ASSIGN iWidgetID = 0
                               isFirstAction = FALSE.
                    ASSIGN iWidgetID = iWidgetID + DYNAMIC-FUNCTION('getWidgetIDGap':U IN hProcGap, INPUT "SmartToolbarActions":U).
                END.
                WHEN "Pages":U THEN
                DO:
                    IF isFirstPage THEN
                        ASSIGN iWidgetID = 0
                               isFirstPage = FALSE.
                    ASSIGN iWidgetID = iWidgetID + DYNAMIC-FUNCTION('getWidgetIDGap':U IN hProcGap, INPUT "SmartFolderPage":U).
                END.
                WHEN "TreeNode":U THEN
                DO:
                    IF isFirstTreeNode THEN
                        ASSIGN iWidgetID = 0
                               isFirstTreeNode = FALSE.
                    ASSIGN iWidgetID = iWidgetID + DYNAMIC-FUNCTION('getWidgetIDGap':U IN hProcGap, INPUT "TreeNode":U).
                END.
                WHEN "Instance":U THEN
                DO:
                    IF isFirstInstance THEN
                        ASSIGN iWidgetID = 0
                               isFirstInstance = FALSE.

                    FIND FIRST Instance WHERE Instance.contPath = bttBrowser.cContainerPath AND
                                              Instance.contName = bttBrowser.cContainerName AND
                                              Instance.ID       = bttBrowser.cTTFieldID NO-LOCK NO-ERROR.
                         IF NOT AVAILABLE(instance)
                         THEN NEXT.
                    ASSIGN iWidgetID      = iWidgetID + DYNAMIC-FUNCTION('getWidgetIDGap':U IN hProcGap, INPUT IF cOldObjectType = "":U THEN "FRAME":U ELSE cOldObjectType)
                           cOldObjectType = Instance.ObjectType.
                END.
                WHEN "InstanceChildren":U THEN
                DO:
                    FIND FIRST InstanceChildren WHERE InstanceChildren.contPath = bttBrowser.cContainerPath AND
                                                      InstanceChildren.contName = bttBrowser.cContainerName AND
                                                      InstanceChildren.ID       = bttBrowser.cTTName        AND
                                                      InstanceChildren.parentInstanceID = bttBrowser.cParent NO-LOCK.
                    ASSIGN iWidgetID = iWidgetID + DYNAMIC-FUNCTION('getWidgetIDGap':U IN hProcGap, INPUT InstanceChildren.ObjectType).
                END.
            END.

            ASSIGN bttBrowser.cStatus  = "U":U
                   bttBrowser.WidgetID = iWidgetID.
  END.

  {&OPEN-QUERY-{&BROWSE-NAME}}

  IF gcStatus NE "Started":U THEN
    setWidgetStatus("Started":U).
  DELETE OBJECT hProcGap NO-ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Exit C-Win
ON CHOOSE OF MENU-ITEM m_Exit /* Exit */
DO:
  APPLY "WINDOW-CLOSE":U TO c-win.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m__About_Runtime_Widget-id_As
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m__About_Runtime_Widget-id_As C-Win
ON CHOOSE OF MENU-ITEM m__About_Runtime_Widget-id_As /*  About Runtime Widget-id Assignment Tool */
DO:
      RUN adecomm/_adehelp.p ( "ptls", "CONTEXT":U, {&WidgetID_Runtime_Assignment_Utility},?).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
   RUN adecomm/_dswidfunc.p PERSISTENT SET ghDSLibrary.
   setWidgetStatus("ToolEmpty":U).
   coContainer:DELETE(1).
   MENU-ITEM m_AssignonAdd:CHECKED = TRUE.
IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

ON 'LEAVE':U OF ttBrowser.WidgetID
DO:
    IF SELF:MODIFIED THEN
    DO:
        IF INT(SELF:SCREEN-VALUE) > 65535 THEN
        DO:
            MESSAGE 'Widget-id value cannot be greater than 65535'
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            RETURN NO-APPLY.
        END.

        FIND CURRENT ttBrowser EXCLUSIVE-LOCK.

        ASSIGN ttBrowser.cStatus = "U" 
               ttBrowser.WidgetID = INT(SELF:SCREEN-VALU).

        FIND CURRENT ttBrowser NO-LOCK.

        SELF:MODIFIED = FALSE.
    END. /*IF SELF:MODIFIED THEN*/
END. /*ON 'LEAVE':U OF ttBrowser.WidgetID*/

ON 'ENTRY':U OF ttBrowser.WidgetID
DO:
    IF ttBrowser.cLabel = "Pages":U OR
         ttBrowser.cLabel = "TreeView Nodes":U OR
       ttBrowser.cLabel = "Toolbar Buttons":U OR
       ttBrowser.cLabel = "Instances":U THEN
       RETURN NO-APPLY.
END. /*ON 'ENTRY':U OF ttBrowser.WidgetID*/

ON 'VALUE-CHANGED':U OF ttBrowser.WidgetID
DO:
   IF gcStatus NE "Started":U THEN
    setWidgetStatus("Started":U).
END. /*ON 'LEAVE':U OF ttBrowser.WidgetID*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE commitTransaction C-Win 
PROCEDURE commitTransaction :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH ttBrowser WHERE ttBrowser.cStatus = "D":U
                   BREAK BY ttBrowser.cContainer:
    IF FIRST-OF(ttBrowser.cContainer) THEN
    DO:
         RUN removeContainer (INPUT ttBrowser.cContainerPath, INPUT ttBrowser.cContainerName, YES).
    END. /*IF FIRST-OF(ttBrowser.cContainer THEN*/

            DELETE ttBrowser.
END.

IF NOT CAN-FIND (FIRST Container) THEN
DO:
   setWidgetStatus("XMLEmpty":U).
   DATASET dsWidgetID:WRITE-XML("FILE", fiXMLFileName:SCREEN-VALUE IN FRAME {&FRAME-NAME}, TRUE).
   RETURN.
END.

IF FOCUS:NAME = "WidgetID":U THEN
DO:
    ASSIGN ttBrowser.WidgetID = INT(FOCUS:SCREEN-VALUE) NO-ERROR.
    APPLY "LEAVE":U TO FOCUS.
END.

DATASET dsWidgetID:ACCEPT-CHANGES().

FOR EACH ttBrowser WHERE ttBrowser.cStatus = "U":U:

    CASE ttBrowser.cTTName:
        WHEN "Pages":U THEN
        DO:
            FIND FIRST Pages WHERE Pages.contName = ttBrowser.cContainerName AND
                                   Pages.contPath = ttBrowser.cContainerPath AND
                                   Pages.PageNumber = INT(ttBrowser.cTTFieldID)
                                   NO-ERROR.

            ASSIGN Pages.WidgetID = ttBrowser.WidgetID.
        END. /*WHEN "Pages":U THEN*/

        WHEN "Action":U THEN
        DO:
            FIND FIRST Action WHERE Action.contName = ttBrowser.cContainerName AND
                                    Action.contPath = ttBrowser.cContainerPath AND
                                    Action.actionID = ttBrowser.cTTFieldID
                                   NO-ERROR.

            ASSIGN Action.WidgetID = ttBrowser.WidgetID.
        END. /*WHEN "Action":U THEN*/

        WHEN "Instance":U THEN
        DO:
            FIND FIRST Instance WHERE Instance.contName = ttBrowser.cContainerName AND
                                      Instance.contPath = ttBrowser.cContainerPath AND
                                      Instance.ID       = ttBrowser.cTTFieldID
                                      NO-ERROR.

            ASSIGN Instance.WidgetID = ttBrowser.WidgetID.
        END. /*WHEN "Instance":U THEN*/

        WHEN "InstanceChildren":U THEN
        DO:
            FIND FIRST InstanceChildren WHERE InstanceChildren.contName         = ttBrowser.cContainerName AND
                                              InstanceChildren.contPath         = ttBrowser.cContainerPath AND
                                              InstanceChildren.ID               = ttBrowser.cTTFieldID     AND
                                              InstanceChildren.parentInstanceID = ttBrowser.cParent
                                              NO-ERROR.

            ASSIGN InstanceChildren.WidgetID = ttBrowser.WidgetID.
        END. /*WHEN "InstanceChildren":U THEN*/
        
        WHEN "TreeNode":U THEN
        DO:
            FIND FIRST TreeNode WHERE TreeNode.contName = ttBrowser.cContainerName AND
                                      TreeNode.contPath = ttBrowser.cContainerPath AND
                                      TreeNode.ID       = ttBrowser.cTTFieldID
                                      NO-ERROR.

            ASSIGN TreeNode.WidgetID = ttBrowser.WidgetID.
        END. /*WHEN "TreeNode":U THEN*/
    END CASE. /*CASE ttBrowser.cTTName:*/

    ASSIGN ttBrowser.cStatus = "":U.
END. /*FOR EACH ttBrowser WHERE ttBrowser.cStatus = "U":U:*/

DATASET dsWidgetID:WRITE-XML("FILE", fiXMLFileName:SCREEN-VALUE IN FRAME {&FRAME-NAME}, TRUE).

setWidgetStatus("Finished":U).

IF coContainer:SCREEN-VALUE NE "" THEN
    APPLY "VALUE-CHANGED":U TO coContainer.
RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteContainer C-Win 
PROCEDURE deleteContainer :
/*------------------------------------------------------------------------------
  Purpose: This procedure performs a logical deletion of the container. The
           physical deletion of the container is performed in commitTransaction.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FOR EACH ttBrowser WHERE ttBrowser.cContainer = coContainer:SCREEN-VALUE IN FRAME {&FRAME-NAME}:
    ASSIGN ttBrowser.cStatus = "D":U.
END.
coContainer:DELETE(coContainer:SCREEN-VALUE).
coContainer:SCREEN-VALUE IN FRAME {&FRAME-NAME} = coContainer:ENTRY(1) NO-ERROR.

{&OPEN-QUERY-{&BROWSE-NAME}}
setWidgetStatus("Started":U).
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
  DISPLAY fiXMLFileName coContainer 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE RECT-4 buAdd RECT-5 RECT-8 rcRight rcBrowser rcToolbar fiXMLFileName 
         coContainer brObjects buNew buOpen buTree buSync buCancel buRemove 
         buSave 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fillBrowseTempTable C-Win 
PROCEDURE fillBrowseTempTable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE iOrder AS INTEGER     NO-UNDO.
DEFINE VARIABLE cContainerFile  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cContainerPath  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cContainerName  AS CHARACTER  NO-UNDO.

/*Clean the temp-table*/
EMPTY TEMP-TABLE ttBrowser.

ASSIGN cContainerFile = REPLACE(coContainer:SCREEN-VALUE IN FRAME {&FRAME-NAME}, "~\", "/").

IF INDEX(cContainerFile, "/") > 0 THEN
   ASSIGN cContainerPath = SUBSTRING(cContainerFile, 1, R-INDEX(cContainerFile, "/") - 1)
          cContainerName = SUBSTRING(cContainerFile, R-INDEX(cContainerFile, "/") + 1).
ELSE ASSIGN cContainerPath = ""
            cContainerName = cContainerFile.

FOR EACH Container NO-LOCK WHERE Container.contPath = cContainerPath AND
                                 Container.contName = cContainerName:

    IF CAN-FIND(FIRST Pages WHERE Pages.contPath = Container.contPath AND
                                  Pages.contName = Container.contName) THEN
    DO:
        CREATE ttBrowser.
        ASSIGN iOrder                    = iOrder + 1
               ttBrowser.cKey            = "Pages"
               ttBrowser.cLabel          = "Pages"
               ttBrowser.cContainer      = TRIM(Container.contPath + "/" + Container.contName, "/")
               ttBrowser.cContainerName  = Container.contName
               ttBrowser.cContainerPath  = Container.contPath
               ttBrowser.cExpanded       = "-"
               ttBrowser.lParentExpanded = TRUE
               ttBrowser.WidgetID        = 0
               ttBrowser.iOrder          = iOrder
               ttBrowser.cParent         = ""
               ttBrowser.cStatus         = ""
               ttBrowser.cTTName         = ""
               ttBrowser.cTTFieldID      = "".

        FOR EACH Pages NO-LOCK WHERE Pages.contPath = Container.contPath AND
                                     Pages.contName = Container.contName:
            CREATE ttBrowser.
            ASSIGN iOrder                    = iOrder + 1
                   ttBrowser.cKey            = "Page" + STRING(Pages.pageNumber)
                   ttBrowser.cLabel          = FILL(" ", 4) + STRING(Pages.pageNumber) + " (" + Pages.pageLabel + ")"
                   ttBrowser.cContainer      = TRIM(Container.contPath + "/" + Container.contName, "/")
                   ttBrowser.cContainerName  = Container.contName
                   ttBrowser.cContainerPath  = Container.contPath
                   ttBrowser.cExpanded       = ""
                   ttBrowser.lParentExpanded = TRUE
                   ttBrowser.WidgetID        = Pages.WidgetID
                   ttBrowser.iOrder          = iOrder
                   ttBrowser.cParent         = "Pages"
                   ttBrowser.cStatus         = ""
                   ttBrowser.cTTName         = "Pages"
                   ttBrowser.cTTFieldID      = STRING(Pages.pageNumber).
        END. /*FOR EACH Pages NO-LOCK WHERE Pages.parentID = Container.ID:*/

    END. /*IF CAN-FIND(FIRST Pages WHERE Pages.parentID = Container.ID) THEN*/

    IF CAN-FIND(FIRST Action WHERE Action.contPath = Container.contPath AND
                                   Action.contName = Container.contName) THEN
    DO:
        CREATE ttBrowser.
        ASSIGN iOrder                    = iOrder + 100000
               ttBrowser.cKey            = "Actions"
               ttBrowser.cLabel          = "Toolbar Buttons"
               ttBrowser.cContainer      = TRIM(Container.contPath + "/" + Container.contName, "/")
               ttBrowser.cContainerName  = Container.contName
               ttBrowser.cContainerPath  = Container.contPath
               ttBrowser.cExpanded       = "-"
               ttBrowser.lParentExpanded = TRUE
               ttBrowser.WidgetID        = 0
               ttBrowser.iOrder          = iOrder
               ttBrowser.cParent         = ""
               ttBrowser.cStatus         = ""
               ttBrowser.cTTName         = ""
               ttBrowser.cTTFieldID      = "".

        FOR EACH Action NO-LOCK WHERE Action.contPath = Container.contPath AND
                                      Action.contName = Container.contName:
            CREATE ttBrowser.
            ASSIGN iOrder                    = iOrder + 1
                   ttBrowser.cKey            = STRING(Action.actionID)
                   ttBrowser.cLabel          = FILL(" ", 4) + Action.actionID
                   ttBrowser.cContainer      = TRIM(Container.contPath + "/" + Container.contName, "/")
                   ttBrowser.cContainerName  = Container.contName
                   ttBrowser.cContainerPath  = Container.contPath
                   ttBrowser.cExpanded       = ""
                   ttBrowser.lParentExpanded = TRUE
                   ttBrowser.WidgetID        = Action.WidgetID
                   ttBrowser.iOrder          = iOrder
                   ttBrowser.cParent         = "Actions"
                   ttBrowser.cStatus         = ""
                   ttBrowser.cTTName         = "Action"
                   ttBrowser.cTTFieldID      = Action.actionID.
        END. /*FOR EACH Pages NO-LOCK WHERE Pages.parentID = Container.ID:*/
    END. /*IF CAN-FIND(FIRST Action WHERE Action.parentID = Container.ID) THEN*/

    IF CAN-FIND(FIRST Instance WHERE Instance.contPath = Container.contPath AND
                                     Instance.contName = Container.contName) THEN
    DO:
        CREATE ttBrowser.
        ASSIGN iOrder                    = 200000
               ttBrowser.cKey            = "Instances"
               ttBrowser.cLabel          = "Instances"
               ttBrowser.cContainer      = TRIM(Container.contPath + "/" + Container.contName, "/")
               ttBrowser.cContainerName  = Container.contName
               ttBrowser.cContainerPath  = Container.contPath
               ttBrowser.cExpanded       = "-"
               ttBrowser.lParentExpanded = TRUE
               ttBrowser.WidgetID        = 0
               ttBrowser.iOrder          = iOrder
               ttBrowser.cParent         = ""
               ttBrowser.cStatus         = ""
               ttBrowser.cTTName         = ""
               ttBrowser.cTTFieldID      = "".

        FOR EACH Instance  NO-LOCK WHERE Instance.contPath = Container.contPath AND
                                         Instance.contName = Container.contName:

            CREATE ttBrowser.
            ASSIGN iOrder                    = iOrder + 10000
                   ttBrowser.cKey            = Instance.ID
                   ttBrowser.cLabel          = FILL(" ", 4) + Instance.ID
                   ttBrowser.cContainer      = TRIM(Container.contPath + "/" + Container.contName, "/")
                   ttBrowser.cContainerName  = Container.contName
                   ttBrowser.cContainerPath  = Container.contPath
                   ttBrowser.cExpanded       = IF CAN-FIND(FIRST InstanceChildren WHERE InstanceChildren.parentInstanceID = Instance.ID         AND
                                                                                        InstanceChildren.contPath         = Instance.contPath   AND
                                                                                        InstanceChildren.contName         = Instance.contName)  THEN "-" ELSE ""
                   ttBrowser.lParentExpanded = TRUE
                   ttBrowser.WidgetID        = Instance.WidgetID
                   ttBrowser.iOrder          = iOrder
                   ttBrowser.cParent         = "Instances"
                   ttBrowser.cStatus         = ""
                   ttBrowser.cTTName         = "Instance"
                   ttBrowser.cTTFieldID      = Instance.ID.

            FOR EACH InstanceChildren NO-LOCK 
                         WHERE InstanceChildren.parentInstanceID = Instance.ID         AND
                               InstanceChildren.contPath         = Instance.contPath   AND
                               InstanceChildren.contName         = Instance.contName:

                CREATE ttBrowser.
                ASSIGN iOrder                    = iOrder + 1
                       ttBrowser.cKey            = InstanceChildren.ID
                       ttBrowser.cLabel          = FILL(" ", 8) + InstanceChildren.ID
                       ttBrowser.cContainer      = TRIM(Container.contPath + "/" + Container.contName, "/")
                       ttBrowser.cContainerName  = Container.contName
                       ttBrowser.cContainerPath  = Container.contPath
                       ttBrowser.cExpanded       = ""
                       ttBrowser.lParentExpanded = TRUE
                       ttBrowser.WidgetID        = InstanceChildren.WidgetID
                       ttBrowser.iOrder          = iOrder
                       ttBrowser.cParent         = Instance.ID
                       ttBrowser.cStatus         = ""
                       ttBrowser.cTTName         = "InstanceChildren"
                       ttBrowser.cTTFieldID      = InstanceChildren.ID.
            END. /*FOR EACH InstanceChildren NO-LOCK */
        END. /*FOR EACH Instance WHERE Instance.parentID = Container.id NO-LOCK:*/
    END. /*IF CAN-FIND(FIRST Instance WHERE Instance.contID = Container.ID) THEN*/


    IF CAN-FIND(FIRST TreeNode WHERE TreeNode.contPath = Container.contPath AND
                                     TreeNode.contName = Container.contName) THEN
    DO:
        CREATE ttBrowser.
        ASSIGN iOrder                    = 300000
               ttBrowser.cKey            = "TreeNodes":U
               ttBrowser.cLabel          = "TreeView Nodes":U
               ttBrowser.cContainer      = TRIM(Container.contPath + "/" + Container.contName, "/")
               ttBrowser.cContainerName  = Container.contName
               ttBrowser.cContainerPath  = Container.contPath
               ttBrowser.cExpanded       = "-":U
               ttBrowser.lParentExpanded = TRUE
               ttBrowser.WidgetID        = 0
               ttBrowser.iOrder          = iOrder
               ttBrowser.cParent         = "":U
               ttBrowser.cStatus         = "":U
               ttBrowser.cTTName         = "":U
               ttBrowser.cTTFieldID      = "":U.

        FOR EACH TreeNode  NO-LOCK WHERE TreeNode.contPath = Container.contPath AND
                                         TreeNode.contName = Container.contName:

            CREATE ttBrowser.
            ASSIGN iOrder                    = iOrder + 10000
                   ttBrowser.cKey            = TreeNode.ID
                   ttBrowser.cLabel          = FILL(" ", 4) + TreeNode.cLabel
                   ttBrowser.cContainer      = TRIM(Container.contPath + "/" + Container.contName, "/")
                   ttBrowser.cContainerName  = Container.contName
                   ttBrowser.cContainerPath  = Container.contPath
                   ttBrowser.cExpanded       = "":U
                   ttBrowser.lParentExpanded = TRUE
                   ttBrowser.WidgetID        = TreeNode.WidgetID
                   ttBrowser.iOrder          = iOrder
                   ttBrowser.cParent         = "TreeNodes":U
                   ttBrowser.cStatus         = "":U
                   ttBrowser.cTTName         = "TreeNode":U
                   ttBrowser.cTTFieldID      = TreeNode.ID.
        END.
    END.
END. /*FOR EACH Container NO-LOCK*/

RUN updateSyncStatus.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fillComboBox C-Win 
PROCEDURE fillComboBox :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER plFillBrowser AS LOGICAL     NO-UNDO.
/*If we blank the list-item-pairs, then the add-last method raises an error,
  that is why we create a dummy item*/
coContainer:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = "0,0".

FOR EACH Container NO-LOCK:
    coContainer:ADD-FIRST(Container.contPath + (IF Container.contPath NE "" THEN "/" ELSE "") + Container.contName + " (" + Container.ObjectType + ")", Container.contPath + (IF Container.contPath NE "" THEN "/" ELSE "") + Container.contName).
END.

IF plFillBrowser THEN
RUN fillBrowseTempTable.

coContainer:DELETE("0") IN FRAME {&FRAME-NAME} NO-ERROR.
coContainer:SCREEN-VALUE IN FRAME {&FRAME-NAME} = coContainer:ENTRY(1) NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadXML C-Win 
PROCEDURE loadXML :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcXMLFileName AS CHARACTER   NO-UNDO.

DEFINE VARIABLE lOk AS LOGICAL     NO-UNDO.

IF NOT checkTransaction() THEN
   RETURN ERROR.

ASSIGN lOk = DATASET dsWidgetID:READ-XML("FILE":U, pcXMLFileName, "EMPTY":U, ?, FALSE) NO-ERROR.

IF NOT lOk THEN
DO:
    MESSAGE "The XML file cannot be loaded."
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RETURN ERROR.
END.

RUN fillComboBox (TRUE).
fiXMLFileName:SCREEN-VALUE IN FRAME {&FRAME-NAME} = pcXMLFileName.
setWidgetStatus("Finished").
APPLY "VALUE-CHANGED":U TO coContainer.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE removeContainer C-Win 
PROCEDURE removeContainer :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcPath            AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcName            AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER plDeleteContainer AS LOGICAL   NO-UNDO.

FIND FIRST Container WHERE Container.contPath = pcPath AND
                           Container.contName = pcName.
FOR EACH Instances OF Container:
    DELETE Instances.
END.
FOR EACH Instance OF Container:
    DELETE Instance.
END.
FOR EACH InstanceChildren OF Container:
    DELETE InstanceChildren.
END.
FOR EACH ParentPages OF Container:
    DELETE ParentPages.
END.
FOR EACH Pages OF Container:
    DELETE Pages.
END.
FOR EACH Actions OF Container:
    DELETE Actions.
END.
FOR EACH Action OF Container:
    DELETE Action.
END.

IF plDeleteContainer THEN
    DELETE Container.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE syncDynObject C-Win 
PROCEDURE syncDynObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER plChanged AS LOGICAL NO-UNDO.

DEFINE VARIABLE cPropertyNames  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPropertyValues AS CHARACTER NO-UNDO.
DEFINE VARIABLE dObjectID       AS DECIMAL   NO-UNDO.
DEFINE VARIABLE cObjectType     AS CHARACTER NO-UNDO.
DEFINE VARIABLE cRootNodeCode   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFile           AS CHARACTER NO-UNDO.
DEFINE VARIABLE cPath           AS CHARACTER NO-UNDO.
DEFINE VARIABLE cInstances      AS CHARACTER NO-UNDO.
DEFINE VARIABLE iItems          AS INTEGER   NO-UNDO.
DEFINE VARIABLE iItem           AS INTEGER   NO-UNDO.
DEFINE VARIABLE cItem           AS CHARACTER NO-UNDO.
DEFINE VARIABLE iLastPage       AS INTEGER   NO-UNDO.
DEFINE VARIABLE cActions        AS CHARACTER NO-UNDO.
DEFINE VARIABLE cNodes          AS CHARACTER NO-UNDO.

TEMP-TABLE Pages:TRACKING-CHANGES            = TRUE.
TEMP-TABLE Action:TRACKING-CHANGES           = TRUE.
TEMP-TABLE Instance:TRACKING-CHANGES         = TRUE.
TEMP-TABLE TreeNode:TRACKING-CHANGES         = TRUE.
TEMP-TABLE InstanceChildren:TRACKING-CHANGES = TRUE.

    /*Gets the class name and instanceID for the current container*/
    ASSIGN cPropertyNames = "ClassName,InstanceId,RootNodeCode":U.
    RUN getInstanceProperties IN gshRepositoryManager (
        INPUT        coContainer:SCREEN-VALUE IN FRAME {&FRAME-NAME},
        INPUT        "", 
        INPUT-OUTPUT cPropertyNames,
              OUTPUT cPropertyValues) NO-ERROR.

    ASSIGN dObjectId     = DECIMAL(ENTRY(LOOKUP("InstanceId":U, cPropertyNames), cPropertyValues, CHR(1)))
           cObjectType   = ENTRY(LOOKUP("ClassName":U, cPropertyNames), cPropertyValues, CHR(1))
           cRootNodeCode = IF CAN-DO(cPropertyNames, "RootNodeCode":U) THEN ENTRY(LOOKUP("RootNodeCode":U, cPropertyNames), cPropertyValues, CHR(1)) ELSE "".

    /*Get the object instance to later check for deletions*/
    RUN getContainedInstanceNames IN gshRepositoryManager (
        INPUT  coContainer:SCREEN-VALUE,
        OUTPUT cInstances) NO-ERROR.

    DYNAMIC-FUNCTION('createDynContainerDetails':U IN ghDSLibrary,
        INPUT  coContainer:SCREEN-VALUE,
        INPUT  dObjectId,
        INPUT  cRootNodeCode,
        INPUT  MENU-ITEM m_AssignonAdd:CHECKED IN MENU MENU-BAR-C-Win,
        INPUT  DATASET dsWidgetID BY-REFERENCE,
        OUTPUT iLastPage,
        OUTPUT plChanged,
        OUTPUT cNodes,
        INPUT-OUTPUT cActions).

    /*Check if instance were deleted*/
    FOR EACH Instance WHERE Instance.contPath = "":U AND
                            Instance.contName = coContainer:SCREEN-VALUE:
        IF NOT CAN-DO(cInstances, Instance.ID) THEN
        DO:
            DELETE Instance.
            ASSIGN plChanged = TRUE.
        END.
    END. /*FOR EACH Instance WHERE Instance.contPath = "":U*/

    /*Check for deleted actions*/
    FOR EACH Action WHERE Action.contPath = "" AND
                          Action.contName = coContainer:SCREEN-VALUE:

        IF NOT CAN-DO(cActions, Action.actionID) THEN
        DO:
            DELETE Action.
            ASSIGN plChanged = TRUE.
        END.
    END. /* Action WHERE Action.contPath = "" AND */

    /*Check if some Page was deleted from the container*/
    FOR EACH Pages WHERE Pages.contPath = "":U AND
                         Pages.contName = coContainer:SCREEN-VALUE AND
                         Pages.pageNumber GT iLastPage:
            DELETE Pages.
            ASSIGN plChanged = TRUE.
    END. /*FOR EACH Pages WHERE Pages.contPath = "":U AND*/

    FOR EACH TreeNode WHERE TreeNode.contPath = "":U AND
                            TreeNode.contName = coContainer:SCREEN-VALUE:
        IF NOT CAN-DO(cNodes, TreeNode.ID) THEN
        DO:
            DELETE TreeNode.
            ASSIGN plChanged = TRUE.
        END.
    END.

TEMP-TABLE Pages:TRACKING-CHANGES            = FALSE.
TEMP-TABLE Action:TRACKING-CHANGES           = FALSE.
TEMP-TABLE Instance:TRACKING-CHANGES         = FALSE.
TEMP-TABLE TreeNode:TRACKING-CHANGES         = FALSE.
TEMP-TABLE InstanceChildren:TRACKING-CHANGES = FALSE.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE syncRuntimeObject C-Win 
PROCEDURE syncRuntimeObject :
/*------------------------------------------------------------------------------
    Purpose: Gets runtime objects information and compare it with the XML file
             information.
    Parameters: <none>
    Notes: This procedure is called from the Synchronization button (buSync) if
           the AppBuilder is not running, or if the AppBuilder is running but
           the object is in run mode.
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER plChanged AS LOGICAL    NO-UNDO.

DEFINE VARIABLE cObjectName     AS CHARACTER NO-UNDO.
DEFINE VARIABLE lStatic         AS LOGICAL   NO-UNDO.

RUN getRuntimeObjectNames IN ghDSLibrary (INPUT SESSION:FIRST-CHILD, INPUT "":U, INPUT-OUTPUT TABLE ttObjectNames).

FIND FIRST ttObjectNames WHERE ttObjectNames.cName = coContainer:SCREEN-VALUE IN FRAME {&FRAME-NAME} NO-LOCK NO-ERROR.

{get LogicalObjectName cObjectName ttObjectNames.hHandle} NO-ERROR.
ASSIGN lStatic = (cObjectName = "":U OR cObjectName = ?).

    IF NOT AVAILABLE(ttObjectNames) THEN
    DO:
        MESSAGE "Container '" + coContainer:SCREEN-VALUE + "' must be opened in the AppBuilder, or executed before to use this feature."
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN.
    END.

    IF lStatic THEN
        RUN syncStaticObject (OUTPUT plChanged).
    ELSE
        RUN syncDynObject (OUTPUT plChanged).

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE syncStaticObject C-Win 
PROCEDURE syncStaticObject :
/*------------------------------------------------------------------------------
    Purpose:
    Parameters: <none>
    Notes:
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER plChanged AS LOGICAL    NO-UNDO.

DEFINE VARIABLE tmpChanged      AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cObjectName     AS CHARACTER NO-UNDO.
DEFINE VARIABLE lStatic         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE cInstances      AS CHARACTER NO-UNDO.
DEFINE VARIABLE iInstances      AS INTEGER   NO-UNDO.
DEFINE VARIABLE iInstance       AS INTEGER   NO-UNDO.
DEFINE VARIABLE lIsVisual       AS LOGICAL   NO-UNDO.
DEFINE VARIABLE hInstance       AS HANDLE    NO-UNDO.
DEFINE VARIABLE cActions        AS CHARACTER NO-UNDO.
DEFINE VARIABLE iField          AS INTEGER    NO-UNDO.
DEFINE VARIABLE cField          AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFields         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cPath           AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFile           AS CHARACTER NO-UNDO.
DEFINE VARIABLE lDuplicateNames AS LOGICAL   NO-UNDO.
DEFINE VARIABLE iLastPage       AS INTEGER   NO-UNDO.
DEFINE VARIABLE iTempPages      AS INTEGER    NO-UNDO.
DEFINE VARIABLE iLastWidgetID   AS INTEGER   NO-UNDO.
DEFINE VARIABLE cOldObjectType  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cInstanceNames  AS CHARACTER NO-UNDO.
DEFINE VARIABLE cInstanceID     AS CHARACTER  NO-UNDO.

RUN getRuntimeObjectNames IN ghDSLibrary (INPUT SESSION:FIRST-CHILD, INPUT "":U, INPUT-OUTPUT TABLE ttObjectNames).

FIND FIRST ttObjectNames WHERE ttObjectNames.cName = coContainer:SCREEN-VALUE IN FRAME {&FRAME-NAME} NO-LOCK NO-ERROR.

{get LogicalObjectName cObjectName ttObjectNames.hHandle} NO-ERROR.
ASSIGN lStatic = (cObjectName = "":U OR cObjectName = ?).

TEMP-TABLE Pages:TRACKING-CHANGES            = TRUE.
TEMP-TABLE Action:TRACKING-CHANGES           = TRUE.
TEMP-TABLE Instance:TRACKING-CHANGES         = TRUE.
TEMP-TABLE TreeNode:TRACKING-CHANGES         = TRUE.
TEMP-TABLE InstanceChildren:TRACKING-CHANGES = TRUE.
        
{get ContainerTarget cInstances ttObjectNames.hHandle}.

    IF NOT AVAILABLE(ttObjectNames) THEN
    DO:
        MESSAGE "Container '" + coContainer:SCREEN-VALUE + "' must be opened in the AppBuilder, or executed before to use this feature."
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
        RETURN.
    END.

    DYNAMIC-FUNCTION('splitFileName':U IN ghDSLibrary, INPUT coContainer:SCREEN-VALUE, OUTPUT cPath, OUTPUT cFile).

        ASSIGN iInstances = NUM-ENTRIES(cInstances).

        REPEAT iInstance = 1 TO iInstances:

            ASSIGN hInstance   = WIDGET-HANDLE(ENTRY(iInstance, cInstances))
                   lIsVisual   = DYNAMIC-FUNCTION('instanceOf' IN hInstance, INPUT "visual":U) NO-ERROR.

            IF NOT lIsVisual OR lIsVisual = ? THEN
                NEXT.

            /*Get all the instance names to later check if some instance was deleted.*/
            {get ObjectName cInstanceID hInstance}.
            ASSIGN cInstanceNames = cInstanceNames + cInstanceID + ",":U
                   iTempPages     = iLastPage.

            /*Get the Instance Children to later check for deletions.*/
            IF DYNAMIC-FUNCTION('instanceOf' IN hInstance, INPUT "Filter":U) THEN
            DO: 
                {get DisplayedFields cFields hInstance}.
                REPEAT iField = 1 TO NUM-ENTRIES(cFields):
                    ASSIGN cField = ENTRY(iField, cFields).

                    CREATE beforeInstanceChildren.
                    ASSIGN beforeInstanceChildren.ID               = cField
                           beforeInstanceChildren.contPath         = cPath
                           beforeInstanceChildren.contName         = cFile
                           beforeInstanceChildren.parentInstanceID = cInstanceID
                           beforeInstanceChildren.ObjectType       = "SmartFilterField":U.

                END.
            END.

            DYNAMIC-FUNCTION('createContainerDetails':U IN ghDSLibrary,
                INPUT cFile,
                INPUT cPath,
                INPUT hInstance,
                INPUT cInstanceID,
                INPUT TRUE,
                INPUT MENU-ITEM m_AssignonAdd:CHECKED IN MENU MENU-BAR-C-Win,
                INPUT DATASET dsWidgetID BY-REFERENCE,
                OUTPUT lDuplicateNames,
                OUTPUT iTempPages,
                OUTPUT tmpChanged,
                INPUT-OUTPUT cActions,
                INPUT-OUTPUT iLastWidgetID,
                INPUT-OUTPUT cOldObjectType).
                
                IF tmpChanged = TRUE AND plChanged = FALSE THEN
                    ASSIGN plChanged = TRUE.
                IF iTempPages > iLastPage THEN
                    ASSIGN iLastPage = iTempPages. 
        END. /*REPEAT iInstance = 1 TO iInstances:*/

        /*If we have actions, we have to create them*/
        IF cActions NE "" THEN
        DO:
            DYNAMIC-FUNCTION('createActions':U IN ghDSLibrary,
                INPUT cFile,
                INPUT cPath,
                INPUT cActions,
                INPUT DATASET dsWidgetID BY-REFERENCE).
        END. /*IF cActions NE "" THEN*/

        ASSIGN cInstanceNames = TRIM(cInstanceNames, ",").
        FOR EACH Instance WHERE Instance.contPath = cPath AND
                                Instance.contName = cFile:

            IF NOT CAN-DO(cInstanceNames, Instance.ID) THEN
            DO:
                DELETE Instance.
                ASSIGN plChanged = TRUE.
            END.
        END. /*FOR EACH Instance WHERE Instance.contPath = "":U*/

        /*Remove the deleted instance children.*/
        FOR EACH InstanceChildren WHERE InstanceChildren.contPath = cPath AND
                                        InstanceChildren.contName = cFile:
            IF NOT CAN-FIND(beforeInstanceChildren WHERE
                            beforeInstanceChildren.contPath         = InstanceChildren.contPath AND
                            beforeInstanceChildren.contName         = InstanceChildren.contName AND
                            beforeInstanceChildren.parentInstanceID = InstanceChildren.parentInstanceID AND
                            beforeInstanceChildren.ID               = InstanceChildren.ID) THEN
            DO:
                DELETE InstanceChildren.
                ASSIGN plChanged = TRUE.
            END.
        END. /* FOR EACH InstanceChildren WHERE InstanceChildren.contPath = cPath AND */

        /*Check for deleted actions*/
        FOR EACH Action WHERE Action.contPath = cPath AND
                              Action.contName = cFile:

            IF NOT CAN-DO(cActions, Action.actionID) THEN
            DO:
                DELETE Action.
                ASSIGN plChanged = TRUE.
            END.
        END. /* Action WHERE Action.contPath = "" AND */

        /*Check if some Page was deleted from the container*/
        FOR EACH Pages WHERE Pages.contPath = cPath AND
                             Pages.contName = cFile AND
                             Pages.pageNumber GT iLastPage:
                DELETE Pages.
                ASSIGN plChanged = TRUE.
        END. /*FOR EACH Pages WHERE Pages.contPath = "":U AND*/

TEMP-TABLE Pages:TRACKING-CHANGES            = FALSE.
TEMP-TABLE Action:TRACKING-CHANGES           = FALSE.
TEMP-TABLE Instance:TRACKING-CHANGES         = FALSE.
TEMP-TABLE TreeNode:TRACKING-CHANGES         = FALSE.
TEMP-TABLE InstanceChildren:TRACKING-CHANGES = FALSE.
EMPTY TEMP-TABLE beforeInstanceChildren.
RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE undoTransaction C-Win 
PROCEDURE undoTransaction :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DATASET dsWidgetID:REJECT-CHANGES().

FOR EACH ttBrowser WHERE ttBrowser.cStatus = "D":U
                         BREAK BY ttBrowser.cContainer:
    IF FIRST-OF(ttBrowser.cContainer) THEN
    DO:
        FIND FIRST Container WHERE Container.contPath = ttBrowser.cContainerPath AND
                                   Container.contName = ttBrowser.cContainerName
                                   NO-LOCK NO-ERROR.
           coContainer:ADD-FIRST(Container.contPath + (IF Container.contPath = "" THEN "" ELSE "/") + Container.contName + " (" + Container.ObjectType + ")", (Container.contPath + (IF Container.contPath = "" THEN "" ELSE "/") + Container.contName)) IN FRAME {&FRAME-NAME}.
           ASSIGN coContainer:SCREEN-VALUE = ttBrowser.cContainer.
    END.
END.

setWidgetStatus("Finished":U).
APPLY "VALUE-CHANGED":U TO coContainer.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateSyncStatus C-Win 
PROCEDURE updateSyncStatus :
/*--------------------------------------------------------------------------------
  Purpose: This procedure detects if objects were added or deleted from the
           container.
  Parameters:  <none>
  Notes: This works for Container Instances, Instance Children, TreeNodes, Pages
         and Toolbar Actions.
         If one of those items were added (ROW-STATE(<table>)) = 3, this is
         marked with ">". But if an item is removed (ROW-STATE(before_table) = 1),
         this is marked as "<", this is for information only, after the updates
         are saved, the deleted items are removed from the browser.
--------------------------------------------------------------------------------*/
DEFINE VARIABLE iLastBrowser AS INTEGER NO-UNDO.

/*Checks for new added objects*/
FOR EACH Instance WHERE ROW-STATE(Instance) = 3:
    FIND FIRST ttBrowser WHERE ttBrowser.cTTName = "Instance":U AND
                               ttBrowser.cTTFieldID = Instance.ID. 
    ASSIGN ttBrowser.cExpanded = ">".
END.

FOR EACH InstanceChildren WHERE ROW-STATE(InstanceChildren) = 3:
    FIND FIRST ttBrowser WHERE ttBrowser.cTTName = "InstanceChildren":U AND
                               ttBrowser.cTTFieldID = InstanceChildren.ID AND
                               ttBrowser.cParent = InstanceChildren.parentInstanceID. 
    ASSIGN ttBrowser.cExpanded = ">".
END.

FOR EACH Action WHERE ROW-STATE(Action) = 3:
    FIND FIRST ttBrowser WHERE ttBrowser.cTTName = "Action":U AND
                               ttBrowser.cTTFieldID = Action.actionID. 
    ASSIGN ttBrowser.cExpanded = ">".
END.

FOR EACH Pages WHERE ROW-STATE(Pages) = 3:
    FIND FIRST ttBrowser WHERE ttBrowser.cTTName = "Pages":U AND
                               ttBrowser.cTTFieldID = STRING(Pages.pageNumber). 
    ASSIGN ttBrowser.cExpanded = ">".
END.

FOR EACH TreeNode WHERE ROW-STATE(TreeNode) = 3:
    FIND FIRST ttBrowser WHERE ttBrowser.cTTName = "TreeNode":U AND
                               ttBrowser.cTTFieldID = TreeNode.ID. 
    ASSIGN ttBrowser.cExpanded = ">".
END.

/*Checks for deleted objects*/
/*DELETED ACTIONS*/
FOR EACH before_action WHERE ROW-STATE(before_Action) = 1:
    FIND FIRST ttBrowser WHERE ttBrowser.cTTName = "Action":U AND
                               ttBrowser.cTTFieldID = before_Action.actionID NO-ERROR.
    IF AVAILABLE(ttBrowser) THEN
    DO:
        ASSIGN ttBrowser.cExpanded = "<".
        NEXT.
    END.

    FIND LAST ttBrowser WHERE ttBrowser.cTTName = "Action" NO-LOCK NO-ERROR.
    IF AVAILABLE(ttBrowser) THEN
        ASSIGN iLastBrowser = IF iLastBrowser NE 0 THEN iLastBrowser + 1 ELSE ttBrowser.iOrder + 1.
    ELSE ASSIGN iLastBrowser = 100001.

    /*The procedure fillBrowseTempTable does not create the Actions parent node, if there are not Actions in the container.
      So this procedure has to create the Actions parent node, just to show the Actions that were deleted in the right place.*/
    IF NOT CAN-FIND(FIRST ttBrowser WHERE ttBrowser.cContainerPath = before_action.contPath AND
                                          ttBrowser.cContainerName = before_action.contName AND
                                          ttBrowser.cKey           = "Actions":U) THEN
    DO:
        CREATE ttBrowser.
        ASSIGN iOrder                    = iLastBrowser
               ttBrowser.cKey            = "Actions"
               ttBrowser.cLabel          = "Toolbar Buttons"
               ttBrowser.cContainer      = coContainer:SCREEN-VALUE IN FRAME {&FRAME-NAME}
               ttBrowser.cContainerName  = before_action.contName
               ttBrowser.cContainerPath  = before_action.contPath
               ttBrowser.cExpanded       = "-"
               ttBrowser.lParentExpanded = TRUE
               ttBrowser.WidgetID        = 0
               ttBrowser.iOrder          = iOrder
               ttBrowser.cParent         = ""
               ttBrowser.cStatus         = ""
               ttBrowser.cTTName         = ""
               ttBrowser.cTTFieldID      = "".
    END.

    CREATE ttBrowser.
    ASSIGN iOrder                    = iLastBrowser
           ttBrowser.cKey            = STRING(before_action.actionID)
           ttBrowser.cLabel          = FILL(" ", 4) + before_action.actionID
           ttBrowser.cContainer      = coContainer:SCREEN-VALUE IN FRAME {&FRAME-NAME}
           ttBrowser.cExpanded       = "<"
           ttBrowser.lParentExpanded = TRUE
           ttBrowser.WidgetID        = before_action.WidgetID
           ttBrowser.iOrder          = iOrder
           ttBrowser.cParent         = "Actions"
           ttBrowser.cStatus         = ""
           ttBrowser.cTTName         = "Action"
           ttBrowser.cTTFieldID      = before_action.actionID.
END. /* FOR EACH before_action WHERE ROW-STATE(before_Action) = 1: */

/*DELETED TREENODES*/
ASSIGN iLastBrowser = 0.
FOR EACH before_TreeNode WHERE ROW-STATE(before_TreeNode) = 1:
    FIND FIRST ttBrowser WHERE ttBrowser.cTTName = "TreeNode":U AND
                               ttBrowser.cTTFieldID = STRING(before_TreeNode.ID) NO-ERROR.
    IF AVAILABLE(ttBrowser) THEN
    DO:
        ASSIGN ttBrowser.cExpanded = "<".
        NEXT.
    END.

    FIND LAST ttBrowser WHERE ttBrowser.cTTName = "TreeNode" NO-LOCK NO-ERROR.
    IF AVAILABLE(ttBrowser) THEN
        ASSIGN iLastBrowser = IF iLastBrowser NE 0 THEN iLastBrowser + 1 ELSE ttBrowser.iOrder + 1.
    ELSE ASSIGN iLastBrowser = 300001.

    /*The procedure fillBrowseTempTable does not create the parentPages node, if there are not pages in the container.
      So this procedure has to create the parentPage node, just to show the pages that were deleted in the right place.*/
    IF NOT CAN-FIND(FIRST ttBrowser WHERE ttBrowser.cContainerPath = before_TreeNode.contPath AND
                                          ttBrowser.cContainerName = before_TreeNode.contName AND
                                          ttBrowser.cKey           = "TreeNodes":U) THEN
    DO:
        CREATE ttBrowser.
        ASSIGN iOrder                    = iLastBrowser
               ttBrowser.cKey            = "TreeNodes"
               ttBrowser.cLabel          = "TreeView Nodes":U
               ttBrowser.cContainer      = coContainer:SCREEN-VALUE IN FRAME {&FRAME-NAME}
               ttBrowser.cContainerName  = before_TreeNode.contName
               ttBrowser.cContainerPath  = before_TreeNode.contPath
               ttBrowser.cExpanded       = "-"
               ttBrowser.lParentExpanded = TRUE
               ttBrowser.WidgetID        = 0
               ttBrowser.iOrder          = iOrder
               ttBrowser.cParent         = ""
               ttBrowser.cStatus         = ""
               ttBrowser.cTTName         = ""
               ttBrowser.cTTFieldID      = "".
    END.

    CREATE ttBrowser.
    ASSIGN iOrder                    = iLastBrowser + 1
           ttBrowser.cKey            = before_TreeNode.ID
           ttBrowser.cLabel          = FILL(" ", 4) + before_TreeNode.cLabel
           ttBrowser.cContainer      = coContainer:SCREEN-VALUE IN FRAME {&FRAME-NAME}
           ttBrowser.cContainerName  = before_TreeNode.contName
           ttBrowser.cContainerPath  = before_TreeNode.contPath
           ttBrowser.cExpanded       = "<":U
           ttBrowser.lParentExpanded = TRUE
           ttBrowser.WidgetID        = before_TreeNode.WidgetID
           ttBrowser.iOrder          = iOrder
           ttBrowser.cParent         = "TreeNodes":U
           ttBrowser.cStatus         = "":U
           ttBrowser.cTTName         = "TreeNode":U
           ttBrowser.cTTFieldID      = before_TreeNode.ID.
END. /*FOR EACH before_pages WHERE ROW-STATE(before_Pages) = 1:*/

/*DELETED PAGES*/
ASSIGN iLastBrowser = 0.
FOR EACH before_Pages WHERE ROW-STATE(before_Pages) = 1:
    FIND FIRST ttBrowser WHERE ttBrowser.cTTName = "Pages":U AND
                               ttBrowser.cTTFieldID = STRING(before_Pages.pageNumber) NO-ERROR.
    IF AVAILABLE(ttBrowser) THEN
    DO:
        ASSIGN ttBrowser.cExpanded = "<".
        NEXT.
    END.

    FIND LAST ttBrowser WHERE ttBrowser.cTTName = "Pages" NO-LOCK NO-ERROR.
    IF AVAILABLE(ttBrowser) THEN
        ASSIGN iLastBrowser = IF iLastBrowser NE 0 THEN iLastBrowser + 1 ELSE ttBrowser.iOrder + 1.
    ELSE ASSIGN iLastBrowser = 1.

    /*The procedure fillBrowseTempTable does not create the parentPages node, if there are not pages in the container.
      So this procedure has to create the parentPage node, just to show the pages that were deleted in the right place.*/
    IF NOT CAN-FIND(FIRST ttBrowser WHERE ttBrowser.cContainerPath = before_Pages.contPath AND
                                          ttBrowser.cContainerName = before_Pages.contName AND
                                          ttBrowser.cKey           = "Pages":U) THEN
    DO:
        CREATE ttBrowser.
        ASSIGN iOrder                    = iLastBrowser
               ttBrowser.cKey            = "Pages"
               ttBrowser.cLabel          = "Pages"
               ttBrowser.cContainer      = coContainer:SCREEN-VALUE IN FRAME {&FRAME-NAME}
               ttBrowser.cContainerName  = before_Pages.contName
               ttBrowser.cContainerPath  = before_Pages.contPath
               ttBrowser.cExpanded       = "-"
               ttBrowser.lParentExpanded = TRUE
               ttBrowser.WidgetID        = 0
               ttBrowser.iOrder          = iOrder
               ttBrowser.cParent         = ""
               ttBrowser.cStatus         = ""
               ttBrowser.cTTName         = ""
               ttBrowser.cTTFieldID      = "".
    END.

    CREATE ttBrowser.
    ASSIGN iOrder                    = iLastBrowser + 1
           ttBrowser.cKey            = "Page" + STRING(before_Pages.pageNumber)
           ttBrowser.cLabel          = FILL(" ", 4) + STRING(before_Pages.pageNumber) /*+ " (" + before_Pages.pageLabel + ")"*/
           ttBrowser.cContainer      = coContainer:SCREEN-VALUE IN FRAME {&FRAME-NAME}
           ttBrowser.cContainerName  = before_Pages.contName
           ttBrowser.cContainerPath  = before_Pages.contPath
           ttBrowser.cExpanded       = "<"
           ttBrowser.lParentExpanded = TRUE
           ttBrowser.WidgetID        = before_Pages.WidgetID
           ttBrowser.iOrder          = iOrder
           ttBrowser.cParent         = "Pages"
           ttBrowser.cStatus         = ""
           ttBrowser.cTTName         = "Pages"
           ttBrowser.cTTFieldID      = STRING(before_Pages.pageNumber).
END. /*FOR EACH before_pages WHERE ROW-STATE(before_Pages) = 1:*/

/*DELETE INSTANCES*/
ASSIGN iLastBrowser = 0.
FOR EACH before_Instance WHERE ROW-STATE(before_Instance) = 1:
    FIND FIRST ttBrowser WHERE ttBrowser.cTTName = "Instance":U AND
                               ttBrowser.cTTFieldID = before_Instance.ID NO-ERROR.
    IF AVAILABLE(ttBrowser) THEN
    DO:
        ASSIGN ttBrowser.cExpanded = "<".
        NEXT.
    END.

    FIND LAST ttBrowser WHERE ttBrowser.cTTName = "Instance" NO-LOCK NO-ERROR.
    IF AVAILABLE(ttBrowser) THEN
        ASSIGN iLastBrowser = IF iLastBrowser NE 0 THEN iLastBrowser + 1 ELSE ttBrowser.iOrder + 1.
    ELSE ASSIGN iLastBrowser =  200001.

    /*The procedure fillBrowseTempTable does not create the Instance parent node, if there are not instances in the container.
      So this procedure has to create the Instance parent node, just to show the Instances that were deleted in the right place.*/
    IF NOT CAN-FIND(FIRST ttBrowser WHERE ttBrowser.cContainerPath = before_Instance.contPath AND
                                          ttBrowser.cContainerName = before_Instance.contName AND
                                          ttBrowser.cKey           = "Instances":U) THEN
    DO:
        CREATE ttBrowser.
        ASSIGN iOrder                    = iLastBrowser
               ttBrowser.cKey            = "Instances"
               ttBrowser.cLabel          = "Instances"
               ttBrowser.cContainer      = coContainer:SCREEN-VALUE IN FRAME {&FRAME-NAME}
               ttBrowser.cContainerName  = before_Instance.contName
               ttBrowser.cContainerPath  = before_Instance.contPath
               ttBrowser.cExpanded       = "-"
               ttBrowser.lParentExpanded = TRUE
               ttBrowser.WidgetID        = 0
               ttBrowser.iOrder          = iOrder
               ttBrowser.cParent         = ""
               ttBrowser.cStatus         = ""
               ttBrowser.cTTName         = ""
               ttBrowser.cTTFieldID      = "".
    END.

    CREATE ttBrowser.
    ASSIGN iOrder                    = iLastBrowser
           ttBrowser.cKey            = before_Instance.ID
           ttBrowser.cLabel          = FILL(" ", 4) + before_Instance.ID
           ttBrowser.cContainer      = coContainer:SCREEN-VALUE IN FRAME {&FRAME-NAME}
           ttBrowser.cExpanded       = "<"
           ttBrowser.lParentExpanded = TRUE
           ttBrowser.WidgetID        = before_Instance.WidgetID
           ttBrowser.iOrder          = iOrder
           ttBrowser.cParent         = "Instances"
           ttBrowser.cStatus         = ""
           ttBrowser.cTTName         = "Instance"
           ttBrowser.cTTFieldID      = before_Instance.ID.

    /*DELETED INSTANCE CHILDREN*/
    FOR EACH before_InstanceChildren WHERE before_InstanceChildren.contPath         = before_Instance.contPath AND
                                           before_InstanceChildren.contName         = before_Instance.contName AND
                                           before_InstanceChildren.parentInstanceID = before_Instance.ID
                                           NO-LOCK:
        FIND FIRST ttBrowser WHERE ttBrowser.cTTName = "InstanceChildren":U AND
                                   ttBrowser.cParent = before_InstanceChildren.parentInstanceID AND
                                   ttBrowser.cTTFieldID = before_InstanceChildren.ID NO-ERROR.
        IF AVAILABLE(ttBrowser) THEN
        DO:
            ASSIGN ttBrowser.cExpanded = "<".
            NEXT.
        END.

        ASSIGN iLastBrowser = iLastBrowser + 1.
        CREATE ttBrowser.
        ASSIGN iOrder                    = iLastBrowser
               ttBrowser.cKey            = before_InstanceChildren.ID
               ttBrowser.cLabel          = FILL(" ", 8) + before_InstanceChildren.ID
               ttBrowser.cContainer      = coContainer:SCREEN-VALUE IN FRAME {&FRAME-NAME}
               ttBrowser.cExpanded       = "<"
               ttBrowser.lParentExpanded = TRUE
               ttBrowser.WidgetID        = before_InstanceChildren.WidgetID
               ttBrowser.iOrder          = iOrder
               ttBrowser.cParent         = before_Instance.ID
               ttBrowser.cStatus         = ""
               ttBrowser.cTTName         = "InstanceChildren"
               ttBrowser.cTTFieldID      = before_InstanceChildren.ID.
    END. /* FOR EACH before_InstanceChildren  */
END. /* FOR EACH before_Instance WHERE ROW-STATE(before_Instance) = 1: */

ASSIGN iLastBrowser = 0.
FOR EACH before_InstanceChildren WHERE ROW-STATE(before_InstanceChildren) = 1:
    FIND FIRST ttBrowser WHERE ttBrowser.cTTName = "InstanceChildren":U AND
                               ttBrowser.cTTFieldID = before_InstanceChildren.ID AND
                               ttBrowser.cParent = before_InstanceChildren.parentInstanceID NO-ERROR.
    IF AVAILABLE(ttBrowser) THEN
    DO:
        ASSIGN ttBrowser.cExpanded = "<".
        NEXT.
    END.

    FIND LAST ttBrowser WHERE ttBrowser.cTTName = "InstanceChildren" AND 
                              ttBrowser.cParent = before_InstanceChildren.parentInstanceID
                              NO-LOCK NO-ERROR.
    IF AVAILABLE(ttBrowser) THEN
        ASSIGN iLastBrowser = IF iLastBrowser NE 0 THEN iLastBrowser + 1 ELSE ttBrowser.iOrder + 1.
    ELSE DO:
        FIND LAST ttBrowser WHERE ttBrowser.cTTFieldID = before_InstanceChildren.parentInstanceID
                              NO-LOCK NO-ERROR.
        IF AVAILABLE(ttBrowser) THEN
           ASSIGN iLastBrowser = IF iLastBrowser NE 0 THEN iLastBrowser + 1 ELSE ttBrowser.iOrder + 1.
         ASSIGN iLastBrowser =  200001.
    END.

    ASSIGN iLastBrowser = iLastBrowser + 1.
    CREATE ttBrowser.
    ASSIGN iOrder                    = iLastBrowser
           ttBrowser.cKey            = before_InstanceChildren.ID
           ttBrowser.cLabel          = FILL(" ", 8) + before_InstanceChildren.ID
           ttBrowser.cContainer      = coContainer:SCREEN-VALUE IN FRAME {&FRAME-NAME}
           ttBrowser.cExpanded       = "<"
           ttBrowser.lParentExpanded = TRUE
           ttBrowser.WidgetID        = before_InstanceChildren.WidgetID
           ttBrowser.iOrder          = iOrder
           ttBrowser.cParent         = before_InstanceChildren.parentInstanceID
           ttBrowser.cStatus         = ""
           ttBrowser.cTTName         = "InstanceChildren"
           ttBrowser.cTTFieldID      = before_InstanceChildren.ID.
END. /*FOR EACH before_InstanceChildren WHERE ROW-STATE(before_InstanceChildren) = 1:*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE windowResized C-Win 
PROCEDURE windowResized :
/*------------------------------------------------------------------------------
  Purpose: Resizes the objects in the window.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE dWinWidth  AS DECIMAL    NO-UNDO.
DEFINE VARIABLE dWinHeight AS DECIMAL    NO-UNDO.

FRAME {&FRAME-NAME}:SCROLLABLE = TRUE  NO-ERROR.

IF c-win:WIDTH < rcRight:COL IN FRAME {&frame-name} THEN
ASSIGN dWinWidth   = rcRight:COL
       c-win:WIDTH = dWinWidth.
ELSE
ASSIGN dWinWidth  = c-win:WIDTH.

IF c-win:HEIGHT < brObjects:ROW + brObjects:ROW-HEIGHT-CHARS * 9 THEN
ASSIGN dWinHeight = brObjects:ROW + brObjects:ROW-HEIGHT-CHARS * 9
       c-win:HEIGHT = dWinHeight - 1.
ELSE  
ASSIGN dWinHeight = c-win:HEIGHT + 1.

 ASSIGN rcBrowser:WIDTH     = dWinWidth
        rcToolbar:WIDTH     = dWinWidth
        brObjects:WIDTH     = dWinWidth - 2.5
        fiXMLFileName:WIDTH = dWinWidth - fiXMLFileName:COL
        coContainer:WIDTH   = dWinWidth - coContainer:COL
        NO-ERROR.

 FRAME {&frame-name}:SCROLLABLE = FALSE NO-ERROR.
 FRAME {&frame-name}:WIDTH  = dWinWidth  NO-ERROR.
 FRAME {&frame-name}:HEIGHT = dWinHeight - 0.1 NO-ERROR.

 ASSIGN brObjects:HEIGHT = dWinHeight - brObjects:ROW - 0.3
        rcBrowser:HEIGHT = dWinHeight - rcBrowser:ROW - 0.1 NO-ERROR.

RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION checkTransaction C-Win 
FUNCTION checkTransaction RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE lButton AS LOGICAL     NO-UNDO.

IF gcStatus = "Started":U THEN
DO:
    MESSAGE "Current values have not been saved." SKIP(1)
            "Do you wish to save current values before you proceed?"
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL UPDATE lButton.

    IF lButton = ? THEN
        RETURN FALSE.

    IF lButton = NO THEN
        RUN undoTransaction.

    IF lButton= YES THEN
        RUN commitTransaction.
END.
  
RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFileExtension C-Win 
FUNCTION getFileExtension RETURNS CHARACTER
  (INPUT pcFileName AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cFileExt AS CHARACTER   NO-UNDO.

ASSIGN cFileExt = REPLACE(pcFileName, "/", "~\")
       cFileExt = SUBSTRING(cFileExt, R-INDEX(cFileExt, ".") + 1, -1).

RETURN cFileExt.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION isABRunning C-Win 
FUNCTION isABRunning RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iLevel          AS INTEGER NO-UNDO INITIAL 1. 
  
  REPEAT WHILE PROGRAM-NAME(iLevel) <> ?.
    IF PROGRAM-NAME(iLevel) = "adeuib/_uibmain.p" THEN RETURN TRUE.
    ASSIGN iLevel = iLevel + 1.
  END.

  RETURN FALSE.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setWidgetStatus C-Win 
FUNCTION setWidgetStatus RETURNS LOGICAL
  (INPUT pcStatus AS CHARACTER) :
/*-------------------------------------------------------------------------------
  Purpose:  Sets the toolbar button and widget status.
  
    Notes: Possible values:
           'Started': A transaction is started.
           'Finished': A transaction is finished
           'ToolEmpty': There are not XML file loaded in the tool
           'XMLEmpty': The XML file beign edited is empty (no container is added)  
-------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:

CASE pcStatus:

    WHEN 'Started':U THEN
      ASSIGN buNew:SENSITIVE       = FALSE
             buOpen:SENSITIVE      = FALSE
             buAdd:SENSITIVE       = FALSE
             buRemove:SENSITIVE    = FALSE
             buSave:SENSITIVE      = TRUE
             buCancel:SENSITIVE    = TRUE 
             buSync:SENSITIVE      = FALSE
             buTree:SENSITIVE      = TRUE
             coContainer:SENSITIVE = FALSE
             MENU-ITEM m_Assign_Default_Values:SENSITIVE IN MENU menu-bar-c-win = FALSE.

    WHEN 'Finished':U THEN
      ASSIGN buNew:SENSITIVE       = TRUE
             buOpen:SENSITIVE      = TRUE
             buAdd:SENSITIVE       = TRUE
             buRemove:SENSITIVE    = TRUE
             buSave:SENSITIVE      = FALSE
             buCancel:SENSITIVE    = FALSE
             buSync:SENSITIVE      = TRUE
             buTree:SENSITIVE      = TRUE
             coContainer:SENSITIVE = TRUE
             MENU-ITEM m_Assign_Default_Values:SENSITIVE IN MENU menu-bar-c-win = TRUE.

    WHEN 'ToolEmpty':U THEN
      ASSIGN buNew:SENSITIVE       = TRUE
             buOpen:SENSITIVE      = TRUE
             buAdd:SENSITIVE       = FALSE
             buRemove:SENSITIVE    = FALSE
             buSave:SENSITIVE      = FALSE
             buCancel:SENSITIVE    = FALSE
             buSync:SENSITIVE      = FALSE
             buTree:SENSITIVE      = FALSE
             coContainer:SENSITIVE = FALSE
             MENU-ITEM m_Assign_Default_Values:SENSITIVE IN MENU menu-bar-c-win = FALSE.

    WHEN 'XMLEmpty':U THEN
      ASSIGN buNew:SENSITIVE       = TRUE
             buOpen:SENSITIVE      = TRUE
             buAdd:SENSITIVE       = TRUE
             buRemove:SENSITIVE    = FALSE
             buSave:SENSITIVE      = FALSE
             buCancel:SENSITIVE    = FALSE
             buSync:SENSITIVE      = FALSE
             buTree:SENSITIVE      = FALSE
             coContainer:SENSITIVE = FALSE
             MENU-ITEM m_Assign_Default_Values:SENSITIVE IN MENU menu-bar-c-win = FALSE.
END CASE.

ASSIGN gcStatus = pcStatus.

END.
RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

