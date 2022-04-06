&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE giWidth  AS INTEGER    NO-UNDO.
DEFINE VARIABLE giHeight AS INTEGER    NO-UNDO.
DEFINE VARIABLE giLeft   AS INTEGER    NO-UNDO.
DEFINE VARIABLE ghBrowse AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghQuery  AS HANDLE     NO-UNDO.
DEFINE VARIABLE ghTable  AS HANDLE     NO-UNDO.
DEFINE VARIABLE gcTableName  AS CHARACTER  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS buAll buReset buSome coDatabase coIndex ~
toShowSystem edFields toShowIndex raPrefix edWhere 
&Scoped-Define DISPLAYED-OBJECTS coDatabase coIndex fiIndex toShowSystem ~
edFields toShowIndex raPrefix edWhere 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD populateMenu C-Win 
FUNCTION populateMenu RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON buAll  NO-FOCUS FLAT-BUTTON
     LABEL "&A" 
     SIZE 4.8 BY 1.14 TOOLTIP "Display All Data"
     BGCOLOR 8 .

DEFINE BUTTON buReset  NO-FOCUS FLAT-BUTTON
     LABEL "&R" 
     SIZE 4.8 BY 1.14 TOOLTIP "Reset File Information"
     BGCOLOR 8 .

DEFINE BUTTON buSome  NO-FOCUS FLAT-BUTTON
     LABEL "&S" 
     SIZE 4.8 BY 1.14 TOOLTIP "Display Some Data"
     BGCOLOR 8 .

DEFINE VARIABLE coDatabase AS CHARACTER FORMAT "X(256)":U 
     LABEL "Database" 
     VIEW-AS COMBO-BOX INNER-LINES 8
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 26.6 BY 1 NO-UNDO.

DEFINE VARIABLE coIndex AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 8
     DROP-DOWN-LIST
     SIZE 32.4 BY 1 NO-UNDO.

DEFINE VARIABLE edFields AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL LARGE
     SIZE 40 BY 8 NO-UNDO.

DEFINE VARIABLE edWhere AS CHARACTER 
     VIEW-AS EDITOR LARGE
     SIZE 79.6 BY 1.52 NO-UNDO.

DEFINE VARIABLE fiIndex AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 7 BY 1 NO-UNDO.

DEFINE VARIABLE raPrefix AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "&None", "1",
"&Table", "2",
"&Database", "3"
     SIZE 33.6 BY .71 NO-UNDO.

DEFINE VARIABLE toShowIndex AS LOGICAL INITIAL no 
     LABEL "Show &Index Fields Only" 
     VIEW-AS TOGGLE-BOX
     SIZE 33.2 BY .71 NO-UNDO.

DEFINE VARIABLE toShowSystem AS LOGICAL INITIAL no 
     LABEL "&System Files" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .81 TOOLTIP "Select to also show system for the selected database" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     buAll AT ROW 12.43 COL 6.6
     buReset AT ROW 12.43 COL 11.8
     buSome AT ROW 12.43 COL 1.4
     coDatabase AT ROW 1 COL 10 COLON-ALIGNED
     coIndex AT ROW 1 COL 55 COLON-ALIGNED NO-LABEL
     fiIndex AT ROW 1 COL 87.8 COLON-ALIGNED NO-LABEL
     toShowSystem AT ROW 1.19 COL 39.4
     edFields AT ROW 2.14 COL 57 NO-LABEL
     toShowIndex AT ROW 10.19 COL 57
     raPrefix AT ROW 11 COL 57 NO-LABEL
     edWhere AT ROW 12.05 COL 17.4 NO-LABEL
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 96 BY 12.57.


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
         TITLE              = "Database Clipboard Select"
         HEIGHT             = 12.57
         WIDTH              = 96
         MAX-HEIGHT         = 45.33
         MAX-WIDTH          = 256
         VIRTUAL-HEIGHT     = 45.33
         VIRTUAL-WIDTH      = 256
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
                                                                        */
ASSIGN 
       edFields:RETURN-INSERTED IN FRAME DEFAULT-FRAME  = TRUE.

ASSIGN 
       edWhere:RETURN-INSERTED IN FRAME DEFAULT-FRAME  = TRUE.

/* SETTINGS FOR FILL-IN fiIndex IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
ASSIGN 
       fiIndex:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Database Clipboard Select */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Database Clipboard Select */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-RESIZED OF C-Win /* Database Clipboard Select */
DO:
  DEFINE VARIABLE iMoveRight  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iMoveDown   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iLeft       AS INTEGER    NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      FRAME {&FRAME-NAME}:SCROLLABLE    = FALSE
      FRAME {&FRAME-NAME}:HIDDEN        = TRUE
      {&WINDOW-NAME}:WIDTH-PIXELS       = MAX(giWidth,{&WINDOW-NAME}:WIDTH-PIXELS)
      {&WINDOW-NAME}:HEIGHT-PIXELS      = MAX(giHeight,{&WINDOW-NAME}:HEIGHT-PIXELS)
      FRAME {&FRAME-NAME}:WIDTH-PIXELS  = {&WINDOW-NAME}:WIDTH-PIXELS
      FRAME {&FRAME-NAME}:HEIGHT-PIXELS = {&WINDOW-NAME}:HEIGHT-PIXELS
      edFields:X             = MAX(giLeft,{&WINDOW-NAME}:WIDTH-PIXELS - edFields:WIDTH-PIXELS)
      coIndex:X              = edFields:X
      fiIndex:X              = coIndex:X + coIndex:WIDTH-PIXELS + 1
      fiIndex:WIDTH-PIXELS   = FRAME {&FRAME-NAME}:WIDTH-PIXELS - fiIndex:X
      edWhere:Y              = {&WINDOW-NAME}:HEIGHT-PIXELS - edWhere:HEIGHT-PIXELS
      edWhere:WIDTH-PIXELS   = {&WINDOW-NAME}:WIDTH-PIXELS  - edWhere:X
      raPrefix:X             = edFields:X
      raPrefix:Y             = edWhere:Y - raPrefix:HEIGHT-PIXELS
      toShowindex:X          = edFields:X
      toShowindex:Y          = raPrefix:Y - toShowIndex:HEIGHT-PIXELS
      edFields:HEIGHT-PIXELS = toShowIndex:Y - edFields:Y
      buSome:Y               = {&WINDOW-NAME}:HEIGHT-PIXELS - buSome:HEIGHT-PIXELS
      buAll:Y                = {&WINDOW-NAME}:HEIGHT-PIXELS - buAll:HEIGHT-PIXELS
      buReset:Y              = {&WINDOW-NAME}:HEIGHT-PIXELS - buReset:HEIGHT-PIXELS
      FRAME {&FRAME-NAME}:HIDDEN = FALSE
      NO-ERROR.
  IF VALID-HANDLE(ghBrowse) THEN
    ASSIGN
      ghBrowse:WIDTH-PIXELS  = edFields:X - ghBrowse:X - 2
      ghBrowse:HEIGHT-PIXELS = edWhere:Y - ghBrowse:Y - 2.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buAll
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buAll C-Win
ON CHOOSE OF buAll IN FRAME DEFAULT-FRAME /* A */
DO:

  DEFINE VARIABLE cQuery  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFields AS CHARACTER  NO-UNDO.

  RUN buildQueryString(gcTableName, OUTPUT cQuery, OUTPUT cFields).

  RUN populateBrowse (cQuery,cFields,?).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buReset
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buReset C-Win
ON CHOOSE OF buReset IN FRAME DEFAULT-FRAME /* R */
DO:
  APPLY "VALUE-CHANGED" TO coDatabase.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME buSome
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL buSome C-Win
ON CHOOSE OF buSome IN FRAME DEFAULT-FRAME /* S */
DO:

  DEFINE VARIABLE cQuery  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFields AS CHARACTER  NO-UNDO.

  RUN buildQueryString(gcTableName, OUTPUT cQuery, OUTPUT cFields).

  RUN populateBrowse (cQuery,cFields,50).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coDatabase
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coDatabase C-Win
ON VALUE-CHANGED OF coDatabase IN FRAME DEFAULT-FRAME /* Database */
DO:
  RUN populateTable.
  RUN trigValueChanged.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coIndex
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coIndex C-Win
ON VALUE-CHANGED OF coIndex IN FRAME DEFAULT-FRAME
DO:
  RUN populateFields.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME raPrefix
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL raPrefix C-Win
ON VALUE-CHANGED OF raPrefix IN FRAME DEFAULT-FRAME
DO:
  ASSIGN 
    raPrefix.

  RUN populateFields.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toShowIndex
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toShowIndex C-Win
ON VALUE-CHANGED OF toShowIndex IN FRAME DEFAULT-FRAME /* Show Index Fields Only */
DO:
  RUN populateFields.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME toShowSystem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL toShowSystem C-Win
ON VALUE-CHANGED OF toShowSystem IN FRAME DEFAULT-FRAME /* System Files */
DO:
  RUN populateTable.
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
DO:
   RUN disable_UI.
   QUIT.
END.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  SESSION:DEBUG-ALERT = YES.

  populateMenu().
  RUN populateDatabase IN THIS-PROCEDURE.
  APPLY "VALUE-CHANGED" TO coDatabase.

  DEFINE SUB-MENU mClipBoard 
    MENU-ITEM mAssign  LABEL "&Assign Statement" ACCELERATOR "CTRL-A"
    MENU-ITEM mTAssign LABEL "A&ssign (2 Tables)" ACCELERATOR "CTRL-S"
    MENU-ITEM mDisplay LABEL "&Display" ACCELERATOR "CTRL-D".

  DEFINE MENU mMenu MENUBAR
    SUB-MENU mClipBoard LABEL "&Clipboard".

  ASSIGN 
    CURRENT-WINDOW:MENUBAR = MENU mMenu:HANDLE.

  ON CHOOSE OF MENU-ITEM mAssign
    RUN setClipboard ("mAssign").

  ON CHOOSE OF MENU-ITEM mTAssign
    RUN setClipboard ("mTAssign").

  ON CHOOSE OF MENU-ITEM mDisplay
    RUN setClipboard ("mDisplay").

  ASSIGN
    giWidth  = FRAME {&FRAME-NAME}:WIDTH-PIXELS
    giHeight = FRAME {&FRAME-NAME}:HEIGHT-PIXELS
    giLeft   = coIndex:X.

  RUN enable_UI.
  APPLY "VALUE-CHANGED":U TO ghBrowse.

  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildBrowse C-Win 
PROCEDURE buildBrowse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
  IF VALID-HANDLE (ghBrowse) THEN DO:
    DELETE OBJECT ghBrowse.
    ghBrowse = ?.
  END.

  CREATE BROWSE ghBrowse
    TRIGGERS:            
      ON 'VALUE-CHANGED':U 
        PERSISTENT RUN trigValueChanged IN THIS-PROCEDURE.
      ON 'start-search':U 
        PERSISTENT RUN trigStartSearch IN THIS-PROCEDURE.
    END TRIGGERS.
  ASSIGN 
    ghBrowse:FRAME            = FRAME {&FRAME-NAME}:HANDLE
    ghBrowse:ROW              = 2.5                       
    ghBrowse:COL              = 1.5                      
    ghBrowse:SEPARATORS       = TRUE                     
    ghBrowse:ROW-MARKERS      = FALSE                     
    ghBrowse:EXPANDABLE       = TRUE                      
    ghBrowse:COLUMN-RESIZABLE = TRUE                      
    ghBrowse:ALLOW-COLUMN-SEARCHING = TRUE                
    ghBrowse:QUERY            = ghQuery
    ghBrowse:X                = FRAME {&FRAME-NAME}:X
    ghBrowse:Y                = edFields:Y
    ghBrowse:WIDTH-PIXELS     = edFields:X - ghBrowse:X - 2
    ghBrowse:HEIGHT-PIXELS    = edWhere:Y - ghBrowse:Y - 2.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildQueryString C-Win 
PROCEDURE buildQueryString :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER pcTable  AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcQuery  AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcFields AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE iLoop   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hTable  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hField  AS HANDLE     NO-UNDO.

  CREATE BUFFER hTable FOR TABLE TRIM(pcTable).

  IF VALID-HANDLE(hTable) THEN
  DO iLoop  = 1 TO hTable:NUM-FIELDS:
    ASSIGN
      hField = hTable:BUFFER-FIELD(iLoop).
    IF VALID-HANDLE(hField) THEN
    ASSIGN
      pcFields = pcFields + ",":U WHEN pcFields <> "":U
      pcFields = pcFields + hTable:NAME + ".":U + hField:NAME.
  END.

  pcQuery = "FOR EACH ":U + hTable:DBNAME + ".":U + hTable:NAME + ":":U.

  DELETE OBJECT hTable.
  ASSIGN hTable = ?.

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
  DISPLAY coDatabase coIndex fiIndex toShowSystem edFields toShowIndex raPrefix 
          edWhere 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE buAll buReset buSome coDatabase coIndex toShowSystem edFields 
         toShowIndex raPrefix edWhere 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getQueryData C-Win 
PROCEDURE getQueryData :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcQuery             AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcFieldList         AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcRecords           AS INTEGER    NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE-HANDLE phDataTable.

DEFINE VARIABLE hDataBuffer                 AS HANDLE     NO-UNDO.
DEFINE VARIABLE hQuery                      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hBuffer                     AS HANDLE     NO-UNDO.
DEFINE VARIABLE cTableName                  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTableList                  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cBufferName                 AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cBufferHandles              AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFieldName                  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFieldHandles                  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hDataField                  AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTempField                  AS HANDLE     NO-UNDO.

DEFINE VARIABLE iLoop                       AS INTEGER    NO-UNDO.
DEFINE VARIABLE iCount                      AS INTEGER    NO-UNDO.
DEFINE VARIABLE cWidget                     AS CHARACTER  NO-UNDO.

  ASSIGN
    phDataTable = ?
    cWidget     = "WIDGETPOOL":U.

  /*Create a query*/
  CREATE WIDGET-POOL cWidget.
  CREATE QUERY hQuery IN WIDGET-POOL cWidget NO-ERROR.

  /*Get the list of tables in the query, and create buffer in the query*/
  BUFFER-LOOP:
  DO iLoop = 1 to NUM-ENTRIES(pcQuery," ":U):
    IF CAN-DO("EACH,FIRST,LAST":U,ENTRY(iLoop,pcQuery," ":U))
    THEN DO:
      ASSIGN
        cTableName = REPLACE(REPLACE(ENTRY(iLoop + 1,pcQuery," "),",":U,"":U),":":U,"":U).
      CREATE BUFFER hBuffer FOR TABLE cTableName IN WIDGET-POOL cWidget NO-ERROR.
      IF ERROR-STATUS:ERROR THEN NEXT BUFFER-LOOP.
      hQuery:ADD-BUFFER(hBuffer) NO-ERROR.
      IF ERROR-STATUS:ERROR THEN NEXT BUFFER-LOOP.
      ASSIGN
        cTableList = cTableList + ",":U WHEN cTableList <> "":U
        cTableList     = cTableList + IF NUM-ENTRIES(cTableName,".":U) >= 2 THEN ENTRY(2,cTableName,".":U) ELSE cTableName
        cBufferHandles = cBufferHandles + ",":U WHEN cBufferHandles <> "":U
        cBufferHandles = cBufferHandles + STRING(hBuffer).

    END.
  END.

  /* Get Field Handles, assuming all fields in table.field format */
  DO iLoop = 1 TO NUM-ENTRIES(pcFieldList):
    ASSIGN
      cFieldName     = ENTRY(2,ENTRY(iLoop,pcFieldList),".":U)
      cBufferName    = ENTRY(1,ENTRY(iLoop,pcFieldList),".":U)
      hBuffer        = WIDGET-HANDLE(ENTRY(LOOKUP(cBufferName,cTableList),cBufferHandles))
      hDataField     = hBuffer:BUFFER-FIELD(cFieldName)
      cFieldHandles  = cFieldHandles + ",":U WHEN cFieldHandles <> "":U
      cFieldHandles  = cFieldHandles + STRING(hDataField).
  END.

  /* Create the dynamic temp-table */
  CREATE TEMP-TABLE phDataTable.

  /* Add selected fields to the temp-table*/
  DO iLoop = 1 TO NUM-ENTRIES(cFieldHandles):
    ASSIGN
      hDataField = WIDGET-HANDLE(ENTRY(iLoop,cFieldHandles)).
    phDataTable:ADD-LIKE-FIELD(hDataField:NAME,hDataField).
  END.

  /* Prepare the temp-table*/
  phDataTable:TEMP-TABLE-PREPARE("DataTable":U).

  /* Store the handle to the buffer for the temp-table */
  ASSIGN
    hDataBuffer = phDataTable:DEFAULT-BUFFER-HANDLE.

  hQuery:QUERY-PREPARE(pcQuery).
  hQuery:QUERY-OPEN() NO-ERROR.
  hQuery:GET-FIRST() NO-ERROR.

  RECORD-LOOP:
  REPEAT WHILE NOT hQuery:QUERY-OFF-END:

    /* Create a temp-table record */
    hDataBuffer:BUFFER-CREATE().

    /* Loop through the fields in the temp table */
    DO iLoop = 1 TO hDataBuffer:NUM-FIELDS:
      /* Get the handle to the current field */
      ASSIGN
        hDataField = hDataBuffer:BUFFER-FIELD(iLoop).
      DO:
        /* Get the handle of the corresponding field in the cFieldHandles list and assign the temp-table field to the database field*/
        ASSIGN
          hTempField = WIDGET-HANDLE(ENTRY(iLoop,cFieldHandles))
          hDataField:BUFFER-VALUE = hTempField:BUFFER-VALUE.
      END.
    END.

    /* Release the temp-table record */
    hDataBuffer:BUFFER-RELEASE().
    /* Get the next result in the query */
    ASSIGN
      iCount = iCount + 1.
    IF pcRecords <> ? AND iCount >= pcRecords THEN
      LEAVE RECORD-LOOP.
    hQuery:GET-NEXT().

  END.

  /* Cleanup */
  hQuery:QUERY-CLOSE.

  DO iLoop = 1 TO NUM-ENTRIES(cBufferHandles):
    ASSIGN
      hBuffer = WIDGET-HANDLE(ENTRY(iLoop,cBufferHandles)).
    IF VALID-HANDLE(hBuffer) THEN
      DELETE OBJECT hBuffer NO-ERROR.
    ASSIGN 
      hBuffer = ?.
  END.

  DELETE WIDGET-POOL cWidget.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateBrowse C-Win 
PROCEDURE populateBrowse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER pcQuery   AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcFields  AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcRecords AS INTEGER    NO-UNDO.

  DEFINE VARIABLE cWhere  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFields AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hTable  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hField  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBField AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cLabels AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hDataTable AS HANDLE.
  DEFINE VARIABLE hDataBuffer AS HANDLE NO-UNDO.

    IF VALID-HANDLE(ghBrowse) THEN DO:
      IF ghQuery:IS-OPEN THEN
        ghQuery:QUERY-CLOSE().
      DELETE OBJECT ghQuery.
      ghQuery = ?.
    END.
    IF VALID-HANDLE(hDataTable) THEN DO:
      DELETE OBJECT hDataTable.
      hDataTable = ?.
    END.

    RUN getQueryData (pcQuery,pcFields,pcRecords,OUTPUT TABLE-HANDLE hDataTable).

    ASSIGN
      hDataBuffer = hDataTable:DEFAULT-BUFFER-HANDLE.
    CREATE QUERY ghQuery.
    ghQuery:ADD-BUFFER(hDataBuffer).
    ghQuery:QUERY-PREPARE("FOR EACH ":U + hDataBuffer:NAME + " NO-LOCK:":U).

    RUN buildBrowse IN THIS-PROCEDURE.

    ASSIGN
      ghBrowse:VISIBLE   = NO
      ghBrowse:SENSITIVE = NO.

    DO iLoop = 1 TO hDataBuffer:NUM-FIELDS:
      ASSIGN
        hField = hDataBuffer:BUFFER-FIELD(iLoop)
        hField = ghBrowse:ADD-LIKE-COLUMN(hField).
    END.

    ghQuery:QUERY-OPEN().

    ASSIGN
      ghBrowse:NUM-LOCKED-COLUMNS = 1
      ghBrowse:VISIBLE   = YES
      ghBrowse:SENSITIVE = YES.

    ghBrowse:SELECT-ROW(1).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateDatabase C-Win 
PROCEDURE populateDatabase :
/*------------------------------------------------------------------------------
  Purpose:     Populates database combo
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE VARIABLE iLoop AS INTEGER INITIAL 1 NO-UNDO.

    DO WITH FRAME {&FRAME-NAME}:
        ASSIGN 
            coDatabase:LIST-ITEMS = "":U
            iLoop = 1.

        DO WHILE iLoop <= NUM-DBS:
            coDatabase:ADD-LAST(LC(LDBNAME(iLoop))).
            ASSIGN iLoop = iLoop + 1.
        END.
        IF coDatabase:LIST-ITEMS <> "":U AND coDatabase:LIST-ITEMS <> ? 
        THEN
            ASSIGN coDatabase:SCREEN-VALUE = ENTRY(1,coDatabase:LIST-ITEMS).

    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateFields C-Win 
PROCEDURE populateFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE iLoop     AS INTEGER    NO-UNDO.
DEFINE VARIABLE hTable    AS HANDLE     NO-UNDO.
DEFINE VARIABLE hField    AS HANDLE     NO-UNDO.
DEFINE VARIABLE cPrefix   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cIndex    AS CHARACTER  NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
  ASSIGN
    edFields:SCREEN-VALUE = "":U.

    CREATE BUFFER hTable FOR TABLE TRIM(gcTableName).

    IF VALID-HANDLE(hTable) THEN DO:
      CASE raPrefix:
        WHEN "1":U THEN cPrefix = "":U.
        WHEN "2":U THEN cPrefix = hTable:NAME + ".":U.
        WHEN "3":U THEN cPrefix = hTable:DBNAME + ".":U + hTable:NAME + ".":U.
      END CASE.

      /*Show all fields*/
      IF NOT toShowIndex:CHECKED THEN
      DO iLoop  = 1 TO hTable:NUM-FIELDS:
        ASSIGN
          hField = hTable:BUFFER-FIELD(iLoop).
        IF VALID-HANDLE(hField) THEN
        edFields:INSERT-STRING(cPrefix + hField:NAME + CHR(10)).    
      END.
      ELSE DO:
        IF coIndex:SCREEN-VALUE = "":U THEN LEAVE.
        ASSIGN
          iLoop = 0.
        REPEAT WHILE cIndex <> ?:
          ASSIGN
            iLoop = iLoop + 1
            cIndex = hTable:INDEX-INFORMATION(iLoop).
          IF cIndex <> ? AND ENTRY(1,coIndex:SCREEN-VALUE,"|":U) = ENTRY(1,cIndex) THEN
          DO iLoop  = 5 TO NUM-ENTRIES(cIndex) BY 2:
            ASSIGN
              hField = hTable:BUFFER-FIELD(ENTRY(iLoop,cIndex)).
            IF VALID-HANDLE(hField) THEN
            edFields:INSERT-STRING(cPrefix + hField:NAME + CHR(10)).    
          END.
        END.
      END.

    END.

  IF NUM-ENTRIES(coIndex:SCREEN-VALUE,"|":U) >= 2 THEN
  ASSIGN
    fiIndex:SCREEN-VALUE = ENTRY(2,coIndex:SCREEN-VALUE,"|":U).

  IF VALID-HANDLE(hTable) 
  THEN DO:
      DELETE OBJECT hTable.
      hTable = ?.
  END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateIndex C-Win 
PROCEDURE populateIndex :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE iLoop     AS INTEGER    NO-UNDO.
DEFINE VARIABLE hTable    AS HANDLE     NO-UNDO.
DEFINE VARIABLE cPrefix   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cIndex    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cAttrib   AS CHARACTER  NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
  ASSIGN
    coIndex:LIST-ITEM-PAIRS = ?.
    CREATE BUFFER hTable FOR TABLE TRIM(gcTableName).

    IF VALID-HANDLE(hTable) THEN DO:
      ASSIGN
        iLoop = 0.
      REPEAT WHILE cIndex <> ?:
        ASSIGN
          iLoop = iLoop + 1
          cIndex = hTable:INDEX-INFORMATION(iLoop).
          IF cIndex <> ? THEN DO:
            ASSIGN
              cAttrib = "|":U   + IF ENTRY(2,cIndex) = "1":U THEN "U":U ELSE " ":U
              cAttrib = cAttrib + IF ENTRY(3,cIndex) = "1":U THEN "P":U ELSE " ":U
              cAttrib = cAttrib + IF ENTRY(4,cIndex) = "1":U THEN "W":U ELSE " ":U.
            coIndex:ADD-LAST(ENTRY(1,cIndex),ENTRY(1,cIndex) + cAttrib).

          END.
      END.
      coIndex:SCREEN-VALUE = ENTRY(2,coIndex:LIST-ITEM-PAIRS).
    END.
  DELETE OBJECT hTable.
  hTable = ?.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE populateTable C-Win 
PROCEDURE populateTable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cWhere AS CHARACTER  NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    IF NOT toShowSystem:CHECKED THEN
    ASSIGN
      cWhere = " WHERE _file._tbl-type <> 'V' ":U.
    RUN populateBrowse ("FOR EACH ":U + coDatabase:SCREEN-VALUE + "._file":U + cWhere + ":":U,"_file._file-name,_file._dump-name",?).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setClipBoard C-Win 
PROCEDURE setClipBoard :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcAction  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLoop       AS INTEGER    NO-UNDO.
DEFINE VARIABLE cField      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFieldOnly  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iMax        AS INTEGER    NO-UNDO.
DEFINE VARIABLE cFill       AS CHARACTER  NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    CASE pcAction:
      WHEN "mAssign":U THEN
      DO:
        ASSIGN
          CLIPBOARD:VALUE = "ASSIGN":U + CHR(10) + "  ":U + REPLACE(edFields:SCREEN-VALUE,CHR(10),CHR(10) + "  ":U)
          CLIPBOARD:VALUE = SUBSTRING(CLIPBOARD:VALUE,1,LENGTH(CLIPBOARD:VALUE) - 3) + ".":U + CHR(10).
      END.
      WHEN "mTAssign":U THEN
      DO:
        ASSIGN
          CLIPBOARD:VALUE = "ASSIGN":U + CHR(10).
        DO iLoop = 1 TO NUM-ENTRIES(edFields:SCREEN-VALUE,CHR(10)) - 1:
          ASSIGN
            iMax = MAX(iMax,LENGTH(ENTRY(iLoop,edFields:SCREEN-VALUE,CHR(10)))).
        END.
        DO iLoop = 1 TO NUM-ENTRIES(edFields:SCREEN-VALUE,CHR(10)) - 1:
          ASSIGN
            cField          = ENTRY(iLoop,edFields:SCREEN-VALUE,CHR(10))
            cFieldOnly      = ENTRY(NUM-ENTRIES(cField,".":U),cField,".":U)
            cFill           = FILL(" ":U,iMax - LENGTH(cField))
            CLIPBOARD:VALUE = CLIPBOARD:VALUE + "  ":U + cField + cFill + " = bBuffer.":U + cFieldOnly + CHR(10).
        END.
        ASSIGN
          CLIPBOARD:VALUE = SUBSTRING(CLIPBOARD:VALUE,1,LENGTH(CLIPBOARD:VALUE) - 3) + ".":U + CHR(10).
      END.
      WHEN "mDisplay":U THEN
      DO:
        ASSIGN
          CLIPBOARD:VALUE = "DISPLAY":U + CHR(10) + "  ":U + REPLACE(edFields:SCREEN-VALUE,CHR(10),CHR(10) + "  ":U)
          CLIPBOARD:VALUE = SUBSTRING(CLIPBOARD:VALUE,1,LENGTH(CLIPBOARD:VALUE) - 3) + ".":U + CHR(10).
      END.
    END CASE.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trigValueChanged C-Win 
PROCEDURE trigValueChanged :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE VARIABLE hColumn AS HANDLE     NO-UNDO.
DEFINE VARIABLE hField  AS HANDLE     NO-UNDO.

  ASSIGN
    hColumn = ghBrowse:GET-BROWSE-COLUMN(1)
    hField  = hColumn:BUFFER-FIELD.

  IF hField:NAME = "_file-name":U THEN
  DO:
    ASSIGN  
      gcTableName  = hField:BUFFER-VALUE.

    RUN populateIndex.
    RUN populateFields.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION populateMenu C-Win 
FUNCTION populateMenu RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

