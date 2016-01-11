&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*------------------------------------------------------------------------

  File:              sessinfo.w

  Description:       Displays the configuration and connection temp-table
                     contents.

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author:            Bruce Gruenbaum

  Created:           11/17/2001

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
{src/adm2/globals.i}

/* Local Variable Definitions ---                                       */

DEFINE TEMP-TABLE ttHandle NO-UNDO
  FIELD cHandle    AS CHARACTER
  FIELD hHandle    AS HANDLE
  FIELD cFieldList AS CHARACTER
  INDEX pudx IS UNIQUE PRIMARY
    cHandle
  .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME brTT

/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS coTT lRemote brTT 
&Scoped-Define DISPLAYED-OBJECTS coTT lRemote 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD addHandle C-Win 
FUNCTION addHandle RETURNS LOGICAL
  ( INPUT phHandle AS HANDLE,
    INPUT pcFieldList AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD closeQuery C-Win 
FUNCTION closeQuery RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD whackTempTables C-Win 
FUNCTION whackTempTables RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE coTT AS CHARACTER FORMAT "X(256)":U 
     LABEL "Session Table" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 65 BY 1 NO-UNDO.

DEFINE VARIABLE lRemote AS LOGICAL INITIAL no 
     LABEL "Remote" 
     VIEW-AS TOGGLE-BOX
     SIZE 13.4 BY .81 NO-UNDO.


/* Browse definitions                                                   */
DEFINE BROWSE brTT
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTT C-Win _STRUCTURED
  
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 95 BY 15 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     coTT AT ROW 1.48 COL 15 COLON-ALIGNED
     lRemote AT ROW 1.57 COL 83.4
     brTT AT ROW 3 COL 3
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 99 BY 18.


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
         TITLE              = "Session Table Information"
         HEIGHT             = 18
         WIDTH              = 100
         MAX-HEIGHT         = 35
         MAX-WIDTH          = 200
         VIRTUAL-HEIGHT     = 35
         VIRTUAL-WIDTH      = 200
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
/* BROWSE-TAB brTT lRemote DEFAULT-FRAME */
ASSIGN 
       FRAME DEFAULT-FRAME:RESIZABLE        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Session Table Information */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Session Table Information */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-RESIZED OF C-Win /* Session Table Information */
DO:
  RUN resixeBrowse.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME coTT
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL coTT C-Win
ON VALUE-CHANGED OF coTT IN FRAME DEFAULT-FRAME /* Session Table */
DO:
  RUN fillBrowse.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lRemote
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lRemote C-Win
ON VALUE-CHANGED OF lRemote IN FRAME DEFAULT-FRAME /* Remote */
DO:
  ASSIGN {&SELF-NAME}.
  RUN getHandles.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brTT
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
   whackTempTables().
   RUN disable_UI.
END.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  RUN enable_UI.

  /* Minimum Pixels */
  {&WINDOW-NAME}:MIN-WIDTH-PIXELS  = {&WINDOW-NAME}:WIDTH-PIXELS.
  {&WINDOW-NAME}:MIN-HEIGHT-PIXELS = {&WINDOW-NAME}:HEIGHT-PIXELS.
  /* Minimum Characters */
  {&WINDOW-NAME}:MIN-WIDTH-CHARS  = {&WINDOW-NAME}:WIDTH-CHARS.
  {&WINDOW-NAME}:MIN-HEIGHT-CHARS = {&WINDOW-NAME}:HEIGHT-CHARS.

  RUN getHandles.

  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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
  DISPLAY coTT lRemote 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE coTT lRemote 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fillBrowse C-Win 
PROCEDURE fillBrowse :
/*------------------------------------------------------------------------------
  Purpose:     Opens a query on the temp-table and associates it with the 
               browse.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hBrowse AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hQuery  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuffer AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTT     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hColumn AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iCount  AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iColumn AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hField  AS HANDLE     NO-UNDO.
  DEFINE BUFFER bttHandle FOR ttHandle.

  DO WITH FRAME {&FRAME-NAME}:

    ASSIGN
      coTT
      hBrowse = BROWSE brTT:HANDLE
    .

    closeQuery().

    FIND bttHandle 
      WHERE bttHandle.cHandle = coTT.

    hTT = bttHandle.hHandle.

    /* Create a buffer against the temp-table because we don't want 
       to play around in the default buffer */
    CREATE BUFFER hBuffer FOR TABLE hTT:DEFAULT-BUFFER-HANDLE.

    CREATE QUERY hQuery.
    hQuery:ADD-BUFFER(hBuffer).
    hQuery:QUERY-PREPARE("FOR EACH " + hBuffer:NAME).
    hQuery:QUERY-OPEN().

    hBrowse:QUERY = hQuery.
    iColumn = 0.
    DO iCount = 1 TO hBuffer:NUM-FIELDS:
      hField = hBuffer:BUFFER-FIELD(iCount).
      IF CAN-DO(bttHandle.cFieldList,hField:NAME) THEN
      DO:
        iColumn = iColumn + 1.
        hBrowse:ADD-LIKE-COLUMN(hField).
        hColumn = hBrowse:GET-BROWSE-COLUMN(iColumn).
        IF LENGTH(hColumn:LABEL) > hField:WIDTH-CHARS
        THEN
          ASSIGN
            hColumn:WIDTH = LENGTH(hColumn:LABEL).
        ELSE
          ASSIGN
            hColumn:WIDTH = hField:WIDTH-CHARS.
      END.
    END.

    hBrowse:SENSITIVE   = YES.
/*    hBrowse:RESIZABLE   = YES. */
    hBrowse:COLUMN-RESIZABLE = YES.

    brTT:SENSITIVE  = YES.
/*    brTT:RESIZABLE  = YES. */
    brTT:COLUMN-RESIZABLE = YES.

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getHandles C-Win 
PROCEDURE getHandles :
/*------------------------------------------------------------------------------
  Purpose:     Gets the handles to the temp-tables.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hHandle1 AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hHandle2 AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hHandle3 AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hHandle4 AS HANDLE     NO-UNDO.

  whackTempTables().

  IF lRemote THEN
  DO:
    RUN af/app/afcfminfop.p ON SERVER gshAstraAppServer 
      (OUTPUT TABLE-HANDLE hHandle1, 
       OUTPUT TABLE-HANDLE hHandle2, 
       OUTPUT TABLE-HANDLE hHandle3, 
       OUTPUT TABLE-HANDLE hHandle4).
  END.
  ELSE
  DO:
    RUN obtainCFMTables        IN THIS-PROCEDURE (OUTPUT hHandle1, OUTPUT hHandle2).
    RUN obtainConnectionTables IN THIS-PROCEDURE (OUTPUT hHandle3, OUTPUT hHandle4).
  END.

  addHandle(hHandle1, "!cValue,*").
  addHandle(hHandle2, "cManagerName,cFileName,cSuperOf,cHandleName").
  addHandle(hHandle3, "cServiceType,cSTProcName").
  addHandle(hHandle4, "*").

  RUN loadCombo.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadCombo C-Win 
PROCEDURE loadCombo :
/*------------------------------------------------------------------------------
  Purpose:     Loads the list of temp-tables into the combo box.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cList   AS CHARACTER  NO-UNDO.
  DEFINE BUFFER bttHandle FOR ttHandle.

  FOR EACH bttHandle:
    cList = cList + (IF cList = "":U THEN "":U ELSE ",":U)
          + bttHandle.cHandle.
  END.

  ASSIGN coTT:LIST-ITEMS IN FRAME {&FRAME-NAME} = cList.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resixeBrowse C-Win 
PROCEDURE resixeBrowse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hBrowse     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFrame      AS HANDLE     NO-UNDO.

  DEFINE VARIABLE iBrowseDown AS INTEGER    NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:

    /* Get the handles of the browse and its frame */
    ASSIGN
      hBrowse     = BROWSE brTT:HANDLE
      hFrame      = FRAME {&FRAME-NAME}:HANDLE
      .

    ASSIGN
      hFrame:HEIGHT         = {&WINDOW-NAME}:HEIGHT
      hFrame:WIDTH          = {&WINDOW-NAME}:WIDTH
      hFrame:VIRTUAL-HEIGHT = hFrame:HEIGHT
      hFrame:VIRTUAL-WIDTH  = hFrame:WIDTH
      hBrowse:HEIGHT        = hFrame:HEIGHT - 2
      hBrowse:WIDTH         = hFrame:WIDTH  - 4
      NO-ERROR.

    ASSIGN
      iBrowseDown = (hBrowse:HEIGHT - 2 ) / (hBrowse:ROW-HEIGHT + 0.2)
      NO-ERROR.

    IF hBrowse:DOWN = iBrowseDown
    THEN
      ASSIGN
        hBrowse:DOWN = iBrowseDown - 1
    NO-ERROR.
    ASSIGN
      hBrowse:DOWN = iBrowseDown
      NO-ERROR.

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION addHandle C-Win 
FUNCTION addHandle RETURNS LOGICAL
  ( INPUT phHandle AS HANDLE,
    INPUT pcFieldList AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:  Adds a handle to the temp-table. 
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE BUFFER bttHandle FOR ttHandle.

  DO TRANSACTION:
    CREATE bttHandle.
    ASSIGN
      bttHandle.cHandle = phHandle:NAME
      bttHandle.hHandle = phHandle
      bttHandle.cFieldList = pcFieldList
    .
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION closeQuery C-Win 
FUNCTION closeQuery RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hQuery AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBuffer AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hBrowse AS HANDLE     NO-UNDO.

  hBrowse = BROWSE brTT:HANDLE.

  /* Close the existing query on the browse */
  hQuery = hBrowse:QUERY.
  hBrowse:QUERY = ?.
  IF VALID-HANDLE(hQuery) THEN
  DO:
    hBuffer = hQuery:GET-BUFFER-HANDLE(1).
    IF hQuery:IS-OPEN THEN
      hQuery:QUERY-CLOSE().
    DELETE OBJECT hQuery.
    hQuery = ?.
    IF VALID-HANDLE(hBuffer) THEN
    DO:
      DELETE OBJECT hBuffer.
      hBuffer = ?.
    END.
  END.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION whackTempTables C-Win 
FUNCTION whackTempTables RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hTT     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cList   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cHandle AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hBuffer AS HANDLE     NO-UNDO.

  DEFINE BUFFER bttHandle FOR ttHandle.

  /* First close the query to get rid of the extra buffer that we use for the
     query and to make sure we don't whack the temp-table from under the 
     query. */
  closeQuery().

  /* Build up a list of the temp-tables in the session widget pool as these
     will have come across from the AppServer */
  hBuffer = SESSION:FIRST-BUFFER.

  /* Walk through the list of buffers that belong to Dynamic Temp Tables*/
  do-ltt:
  DO WHILE VALID-HANDLE(hBuffer) AND VALID-HANDLE(hBuffer:TABLE-HANDLE):
    /* Convert the handle to a string */
    cHandle = STRING(hBuffer:TABLE-HANDLE).
  
    /* If the handle is not in cList, add it */
    IF NOT CAN-DO(cList,cHandle) THEN
      cList = cList + (IF cList = "" THEN "" ELSE ",")
            + cHandle.
  
    /* Go on to the next Buffer */
    hBuffer = hBuffer:NEXT-SIBLING.
  END.
  
  /* Now we have a list of all the dynamic temp-tables */

  /* Go through the table that contains the handles to the tables and if 
     the temp-table handle is in the list of temp-tables we created above,
     whack the whole temp-table, otherwise we have a memory leak */
  FOR EACH bttHandle:
    hTT = bttHandle.hHandle.
    IF VALID-HANDLE(hTT) AND
       CAN-DO(cList,STRING(hTT)) THEN
      DELETE OBJECT hTT.

    DELETE bttHandle. /* Delete the record from the bttHandle table */
  END.


  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

