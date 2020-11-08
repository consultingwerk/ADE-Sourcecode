&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI ADM2
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWin 
/**********************************************************************
* Copyright (C) 2005-2007 by Progress Software Corporation. All rights*
* reserved.  Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                            *
*                                                                     *
**********************************************************************/
/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: New V9 Version - January 15, 1998

  Modified: 02/11/2002        Mark Davies (MIP)
            Fix for issue #3869 - HIGH-CHARACTER preprocessor is wrong
            Replace HIGH-CHARACTER preprocessor value with value retreived
            from function getHighKey in general manager.
  Modified: 04/03/2002        Mark Davies (MIP)
            Fix for issue #4253 - Filter gives error at run-time and does 
            not set filter state
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AB.              */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

{af/sup2/afglobals.i}

/* Parameters Definitions ---                                           */

DEFINE VARIABLE lInitialized AS LOGICAL INITIAL FALSE.

/* Local Variable Definitions ---                                       */
{src/adm2/schemai.i}

DEFINE VARIABLE gcFilterOrFind      AS CHARACTER    NO-UNDO.
DEFINE VARIABLE glFilterModified    AS LOGICAL      NO-UNDO.
DEFINE VARIABLE gcDataObjectType    AS CHARACTER    NO-UNDO.
/* This variable used to determine if there have been any actual
   changes to the contents of the manual editor.
 */
define variable glManualQuery       as logical      no-undo.

/* the high character is appended to character > operations */

&SCOPED-DEFINE DISABLED-BACKGROUND 8
&SCOPED-DEFINE NON-SORT-COLOR 7

DEFINE VARIABLE cSortBy AS CHARACTER    NO-UNDO.

DEFINE TEMP-TABLE ttCacheSchema     NO-UNDO LIKE ttSchema.

DEFINE TEMP-TABLE ttDataObject      NO-UNDO
    FIELD tSdoHandle        AS HANDLE
    FIELD tSdoOrder         AS INTEGER
    FIELD tFieldNames       AS CHARACTER
    FIELD tFieldValues      AS CHARACTER
    FIELD tFieldOperators   AS CHARACTER
    FIELD tSdoSignature     AS CHARACTER
    FIELD tFilterSettings   AS CHARACTER    /* as stored per profile */
    FIELD tSboHandle        AS HANDLE
    FIELD tMasterObject     AS LOGICAL      INITIAL NO
    field tDbAware          as logical
    INDEX idxOrder
        tSdoOrder
    .

DEFINE VARIABLE grFieldProfileRecord    AS ROWID  NO-UNDO.
DEFINE VARIABLE grAdvancedProfileRecord AS ROWID  NO-UNDO.
DEFINE VARIABLE ghDataSource            AS HANDLE NO-UNDO.
DEFINE VARIABLE ghBrowser               AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

&Scoped-define ADM-SUPPORTED-LINKS Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fMain
&Scoped-define BROWSE-NAME brFilter

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES ttSchema

/* Definitions for BROWSE brFilter                                      */
&Scoped-define FIELDS-IN-QUERY-brFilter ttSchema.INDEX_position ttSchema.COLUMN_label ttSchema.search_from ttSchema.search_to ttSchema.search_contains ttSchema.search_matches (IF ttSchema.TABLE_label <> ? THEN ttSchema.TABLE_label ELSE ttSchema.TABLE_name) @ ttSchema.TABLE_label   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brFilter ttSchema.search_from ttSchema.search_to ttSchema.search_contains ttSchema.search_matches   
&Scoped-define ENABLED-TABLES-IN-QUERY-brFilter ttSchema
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-brFilter ttSchema
&Scoped-define SELF-NAME brFilter
&Scoped-define QUERY-STRING-brFilter FOR EACH ttSchema WHERE NOT ttSchema.adm_column AND ttSchema.table_name <> ""                         AND INDEX(ttschema.COLUMN_name, ~
       "_obj") = 0         BY ttSchema.sdo_order         BY ttSchema.table_sequence         BY ttSchema.index_position         BY ttSchema.column_label
&Scoped-define OPEN-QUERY-brFilter OPEN QUERY {&browse-name}     FOR EACH ttSchema WHERE NOT ttSchema.adm_column AND ttSchema.table_name <> ""                         AND INDEX(ttschema.COLUMN_name, ~
       "_obj") = 0         BY ttSchema.sdo_order         BY ttSchema.table_sequence         BY ttSchema.index_position         BY ttSchema.column_label.
&Scoped-define TABLES-IN-QUERY-brFilter ttSchema
&Scoped-define FIRST-TABLE-IN-QUERY-brFilter ttSchema


/* Definitions for FRAME fMain                                          */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fMain ~
    ~{&OPEN-QUERY-brFilter}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rsPermanent brFilter fiRowsToBatch ToRebuild ~
EdManualQuery 
&Scoped-Define DISPLAYED-OBJECTS rsPermanent fiRowsToBatch ToRebuild ~
EdManualQuery fiManualQuery fiFilterLabel fiFindLabel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD closeChildWindow wWin 
FUNCTION closeChildWindow RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD evaluateOuterJoins wWin 
FUNCTION evaluateOuterJoins RETURNS CHARACTER
  (pcQueryString  AS CHARACTER,
   pcFilterFields AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD evaluateQueryString wWin 
FUNCTION evaluateQueryString RETURNS LOGICAL
  ( INPUT phSdoHandle       AS HANDLE,
    INPUT pcFieldNames      AS CHARACTER ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUpdateActive wWin 
FUNCTION getUpdateActive RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getWindowName wWin 
FUNCTION getWindowName RETURNS CHARACTER
    ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWin AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_afspfoldrw AS HANDLE NO-UNDO.
DEFINE VARIABLE h_dyntoolbar AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE EdManualQuery AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 3000 SCROLLBAR-VERTICAL LARGE
     SIZE 71.6 BY 10.57 NO-UNDO.

DEFINE VARIABLE fiFilterLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Filter" 
      VIEW-AS TEXT 
     SIZE 50 BY .62 NO-UNDO.

DEFINE VARIABLE fiFindLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Find" 
      VIEW-AS TEXT 
     SIZE 50 BY .62 NO-UNDO.

DEFINE VARIABLE fiManualQuery AS CHARACTER FORMAT "X(256)":U INITIAL "Manual Query (not saved):" 
      VIEW-AS TEXT 
     SIZE 50 BY .62 TOOLTIP "If modify query here, this will override filters for now, but is not saved" NO-UNDO.

DEFINE VARIABLE fiRowsToBatch AS INTEGER FORMAT ">>>>>9":U INITIAL 0 
     LABEL "Rows to Batch" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 TOOLTIP "Records to retrieve per Appserver call (default 200)" NO-UNDO.

DEFINE VARIABLE rsPermanent AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Session", "SES",
"Permanent", "PER"
     SIZE 29 BY .95 TOOLTIP "Session filters will be lost when session ends, permanent filters not.To clear the permanent filter, press clear and apply" NO-UNDO.

DEFINE VARIABLE ToRebuild AS LOGICAL INITIAL no 
     LABEL "Rebuild on Reposition" 
     VIEW-AS TOGGLE-BOX
     SIZE 35 BY .81 TOOLTIP "Rebuild dataset on reposition (set to YES for large datasets)" NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brFilter FOR 
      ttSchema SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brFilter
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brFilter wWin _FREEFORM
  QUERY brFilter DISPLAY
      ttSchema.INDEX_position FORMAT "x(12)"  COLUMN-LABEL "Index"
    ttSchema.COLUMN_label   FORMAT "x(25)" COLUMN-LABEL "Column"
    ttSchema.search_from COLUMN-LABEL "From" FORMAT "X(256)" WIDTH 20
    ttSchema.search_to COLUMN-LABEL "To" FORMAT "X(256)" WIDTH 20
    ttSchema.search_contains COLUMN-LABEL "Contains" FORMAT "X(256)" WIDTH 20
    ttSchema.search_matches COLUMN-LABEL "Matches" FORMAT "X(256)" WIDTH 20
    (IF ttSchema.TABLE_label <> ? THEN  ttSchema.TABLE_label ELSE ttSchema.TABLE_name) @ ttSchema.TABLE_label FORMAT "x(25)" COLUMN-LABEL "Table"
ENABLE ttSchema.search_from
ttSchema.search_to
ttSchema.search_contains
ttSchema.search_matches
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 74 BY 12 ROW-HEIGHT-CHARS .62 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fMain
     rsPermanent AT ROW 1.14 COL 2.2 NO-LABEL
     brFilter AT ROW 4.1 COL 4
     fiRowsToBatch AT ROW 4.24 COL 18.2 COLON-ALIGNED
     ToRebuild AT ROW 4.33 COL 35.8
     EdManualQuery AT ROW 6.43 COL 5 NO-LABEL
     fiManualQuery AT ROW 5.57 COL 3.2 COLON-ALIGNED NO-LABEL
     fiFilterLabel AT ROW 17 COL 3.2 COLON-ALIGNED NO-LABEL
     fiFindLabel AT ROW 17 COL 3.2 COLON-ALIGNED NO-LABEL
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 17.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Container Links: Data-Target,Data-Source,Page-Target,Update-Source,Update-Target,Filter-target,Filter-Source
   Design Page: 1
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWin ASSIGN
         HIDDEN             = YES
         TITLE              = "Find / Filter"
         HEIGHT             = 17
         WIDTH              = 80
         MAX-HEIGHT         = 35.67
         MAX-WIDTH          = 204.8
         VIRTUAL-HEIGHT     = 35.67
         VIRTUAL-WIDTH      = 204.8
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWin 
/* ************************* Included-Libraries *********************** */

{src/adm2/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWin
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fMain
   FRAME-NAME                                                           */
/* BROWSE-TAB brFilter rsPermanent fMain */
ASSIGN 
       EdManualQuery:RETURN-INSERTED IN FRAME fMain  = TRUE.

/* SETTINGS FOR FILL-IN fiFilterLabel IN FRAME fMain
   NO-ENABLE                                                            */
ASSIGN 
       fiFilterLabel:HIDDEN IN FRAME fMain           = TRUE.

/* SETTINGS FOR FILL-IN fiFindLabel IN FRAME fMain
   NO-ENABLE                                                            */
ASSIGN 
       fiFindLabel:HIDDEN IN FRAME fMain           = TRUE.

/* SETTINGS FOR FILL-IN fiManualQuery IN FRAME fMain
   NO-ENABLE                                                            */
ASSIGN 
       fiRowsToBatch:PRIVATE-DATA IN FRAME fMain     = 
                "nolookups".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
THEN wWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brFilter
/* Query rebuild information for BROWSE brFilter
     _START_FREEFORM
OPEN QUERY {&browse-name}
    FOR EACH ttSchema WHERE NOT ttSchema.adm_column AND ttSchema.table_name <> ""
                        AND INDEX(ttschema.COLUMN_name, "_obj") = 0
        BY ttSchema.sdo_order
        BY ttSchema.table_sequence
        BY ttSchema.index_position
        BY ttSchema.column_label
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE brFilter */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON END-ERROR OF wWin /* Find / Filter */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-CLOSE OF wWin /* Find / Filter */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWin wWin
ON WINDOW-RESIZED OF wWin /* Find / Filter */
DO:
  DEFINE VARIABLE dObjectWidth  AS DECIMAL  NO-UNDO.
  DEFINE VARIABLE dObjectHeight AS DECIMAL  NO-UNDO.
  DEFINE VARIABLE dNewWidth     AS DECIMAL  NO-UNDO.
  DEFINE VARIABLE dNewHeight    AS DECIMAL  NO-UNDO.
  
  DEFINE VARIABLE dHeight       AS DECIMAL  NO-UNDO.
  DEFINE VARIABLE dWidth        AS DECIMAL  NO-UNDO.
  DEFINE VARIABLE dRow          AS DECIMAL  NO-UNDO.
  DEFINE VARIABLE dCol          AS DECIMAL  NO-UNDO.

  /* make the frame bigger if the window is bigger */

  ASSIGN
      dNewWidth  = {&WINDOW-NAME}:WIDTH
      dNewHeight = {&WINDOW-NAME}:HEIGHT

      FRAME {&FRAME-NAME}:HIDDEN     = TRUE
      FRAME {&FRAME-NAME}:SCROLLABLE = FALSE
      FRAME {&FRAME-NAME}:WIDTH      = MAX(FRAME {&FRAME-NAME}:WIDTH,  dNewWidth )
      FRAME {&FRAME-NAME}:HEIGHT     = MAX(FRAME {&FRAME-NAME}:HEIGHT, dNewHeight)

      /* the toolbar */
      dObjectHeight = DYNAMIC-FUNCTION('getHeight' IN h_dyntoolbar).

  RUN resizeObject IN h_dyntoolbar (INPUT dObjectHeight, INPUT dNewWidth).

  /* the folder window */
  RUN resizeObject IN h_afspfoldrw (INPUT dNewHeight - 1.67 - 0.24,
                                    INPUT dNewWidth - 2).

  RUN getClientRectangle IN h_afspfoldrw (OUTPUT dCol,
                                          OUTPUT dRow,
                                          OUTPUT dWidth,
                                          OUTPUT dHeight).
  
  /* the browser */
  ASSIGN
      brFilter:WIDTH        = dNewWidth - 6.0
      brFilter:HEIGHT       = dNewHeight - brFilter:ROW + 0.50 - 0.24
                            - (IF {fn getTabPosition h_afspfoldrw} = "Upper":U THEN 0 ELSE {fn getTabRowHeight h_afspfoldrw})
      EdManualQuery:WIDTH   = dNewWidth - 8.0
      EdManualQuery:HEIGHT  = dNewHeight - EdManualQuery:ROW + 0.50 - 0.52
                            - (IF {fn getTabPosition h_afspfoldrw} = "Upper":U THEN 0 ELSE {fn getTabRowHeight h_afspfoldrw}).

  /* the frame, in case it actually got smaller */

  rsPermanent:MOVE-TO-TOP().                                      

  ASSIGN
      FRAME {&FRAME-NAME}:WIDTH  = dNewWidth
      FRAME {&FRAME-NAME}:HEIGHT = dNewHeight
      FRAME {&FRAME-NAME}:HIDDEN = FALSE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fMain
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fMain wWin
ON MOUSE-SELECT-DBLCLICK OF FRAME fMain
DO:
    DEFINE VARIABLE cQueryColumns           AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cQueryWhere             AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cQueryString            AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE hContainerSource        AS HANDLE       NO-UNDO.
    DEFINE VARIABLE cLogicalObjectName      AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cRunAttribute           AS CHARACTER    NO-UNDO.                                                         
    DEFINE VARIABLE csdoName                AS CHARACTER    NO-UNDO.                                                     

    FOR EACH ttDataObject:
        {get QueryColumns cQueryColumns ttDataObject.tSdoHandle}.
        {get QueryWhere cQueryWhere ttDataObject.tSdoHandle}.
        {get QueryString cQueryString ttDataObject.tSdoHandle}.
        
        MESSAGE
            "SDO Name = " ENTRY(1, ttDataObject.tSdoSignature) SKIP
            "SBO Name (if any) = " ENTRY(2, ttDataObject.tSdoSignature) SKIP
            "Logical Object Name = " ENTRY(3, ttDataObject.tSdoSignature) SKIP
            "Run Attribute = " ENTRY(4, ttDataObject.tSdoSignature) SKIP(2)
            "Query Columns:" cQueryColumns SKIP
            "Query Where:" cQueryWhere SKIP
            "Query String:" cQueryString
            .
    END.    /* each dataobject */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brFilter
&Scoped-define SELF-NAME brFilter
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brFilter wWin
ON ITERATION-CHANGED OF brFilter IN FRAME fMain
DO:
    DEFINE VARIABLE hColumn AS HANDLE.

    hColumn = BROWSE {&BROWSE-NAME}:GET-BROWSE-COLUMN(5).
    IF ttSchema.word_index
        THEN hColumn:READ-ONLY = FALSE.
        ELSE hColumn:READ-ONLY = TRUE.

    hColumn = BROWSE {&BROWSE-NAME}:GET-BROWSE-COLUMN(6).
    IF ttSchema.COLUMN_datatype = "character"
        THEN hColumn:READ-ONLY = FALSE.
        ELSE hColumn:READ-ONLY = TRUE.

    ttSchema.SEARCH_matches:BGCOLOR IN BROWSE {&BROWSE-NAME} = (IF ttSchema.COLUMN_datatype = "character" THEN ? ELSE {&DISABLED-BACKGROUND}).
    ttSchema.SEARCH_contains:BGCOLOR IN BROWSE {&BROWSE-NAME} = (IF ttSchema.word_index THEN ? ELSE {&DISABLED-BACKGROUND}).


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brFilter wWin
ON ROW-DISPLAY OF brFilter IN FRAME fMain
DO:
    ttSchema.SEARCH_matches:BGCOLOR IN BROWSE {&BROWSE-NAME} = (IF ttSchema.COLUMN_datatype = "character" THEN ? ELSE {&DISABLED-BACKGROUND}).
    ttSchema.SEARCH_contains:BGCOLOR IN BROWSE {&BROWSE-NAME} = (IF ttSchema.word_index THEN ? ELSE {&DISABLED-BACKGROUND}).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brFilter wWin
ON START-SEARCH OF brFilter IN FRAME fMain
DO:
    DEFINE VARIABLE hCurrentColumn  AS HANDLE   NO-UNDO.
    DEFINE VARIABLE rCurrentRow     AS ROWID    NO-UNDO.

    ASSIGN
        hCurrentColumn = {&BROWSE-NAME}:CURRENT-COLUMN
        rCurrentRow    = ROWID({&FIRST-TABLE-IN-QUERY-{&BROWSE-NAME}}).

    IF VALID-HANDLE(hCurrentColumn)
        AND NOT hCurrentColumn:LABEL-BGCOLOR = {&NON-SORT-COLOR} THEN DO:
        ASSIGN
            cSortBy = (IF hCurrentColumn:TABLE <> ? THEN
                             hCurrentColumn:TABLE + '.':U + hCurrentColumn:NAME
                             ELSE hCurrentColumn:NAME).

        RUN openQuery.

        APPLY "ITERATION-CHANGED":U TO brFilter IN FRAME {&FRAME-NAME}.

        IF NUM-RESULTS( '{&BROWSE-NAME}':U ) > 0 THEN DO:
            REPOSITION {&BROWSE-NAME} TO ROWID rCurrentRow NO-ERROR.
            {&BROWSE-NAME}:CURRENT-COLUMN = hCurrentColumn.
            APPLY 'VALUE-CHANGED':U TO {&BROWSE-NAME}.
          END.
    END.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brFilter wWin
ON VALUE-CHANGED OF brFilter IN FRAME fMain
DO:
    DEFINE VARIABLE hColumn AS HANDLE.

    hColumn = BROWSE {&BROWSE-NAME}:GET-BROWSE-COLUMN(5).
    IF ttSchema.word_index
        THEN hColumn:READ-ONLY = FALSE.
        ELSE hColumn:READ-ONLY = TRUE.

    hColumn = BROWSE {&BROWSE-NAME}:GET-BROWSE-COLUMN(6).
    IF ttSchema.COLUMN_datatype = "character" 
        THEN hColumn:READ-ONLY = FALSE.
        ELSE hColumn:READ-ONLY = TRUE.

    glFilterModified = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME EdManualQuery
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL EdManualQuery wWin
ON VALUE-CHANGED OF EdManualQuery IN FRAME fMain
DO:
  ASSIGN glFilterModified = YES
         glManualQuery = yes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiRowsToBatch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiRowsToBatch wWin
ON VALUE-CHANGED OF fiRowsToBatch IN FRAME fMain /* Rows to Batch */
DO:
  ASSIGN glFilterModified = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rsPermanent
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsPermanent wWin
ON VALUE-CHANGED OF rsPermanent IN FRAME fMain
DO:
  DEFINE VARIABLE cButton       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cErrorMessage AS CHARACTER  NO-UNDO.

  /* If this is the case, the user has to clear the permanent filter first */
  IF SELF:PRIVATE-DATA = "PER":U
  THEN DO:
      ASSIGN cErrorMessage = {aferrortxt.i 'AF' '149'}.

      RUN showMessages IN gshSessionManager (INPUT  cErrorMessage,    /* messages */
                                             INPUT  "WAR":U,          /* type */
                                             INPUT  "&OK":U,       /* button list */
                                             INPUT  "&OK":U,          /* default */
                                             INPUT  "&OK":U,           /* cancel */
                                             INPUT  "":U,             /* title */
                                             INPUT  YES,              /* disp. empty */
                                             INPUT  ?,                /* container handle */
                                             OUTPUT cButton           /* button pressed */
                                            ).
      ASSIGN SELF:SCREEN-VALUE = "PER":U.
      RETURN NO-APPLY.
  END.
  ELSE
      ASSIGN glFilterModified = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ToRebuild
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ToRebuild wWin
ON VALUE-CHANGED OF ToRebuild IN FRAME fMain /* Rebuild on Reposition */
DO:
  ASSIGN glFilterModified = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWin 


/* ***************************  Main Block  *************************** */

ON CTRL-PAGE-UP OF FRAME {&FRAME-NAME} ANYWHERE DO:
  PUBLISH "selectPrevTab":U.
END.

ON CTRL-PAGE-DOWN OF FRAME {&FRAME-NAME} ANYWHERE DO:
  PUBLISH "selectNextTab":U.
END.

/* Include custom  Main Block code for SmartWindows. */
{src/adm2/windowmn.i}

ASSIGN
    BROWSE {&browse-name}:COLUMN-RESIZABLE   = TRUE
    BROWSE {&browse-name}:NUM-LOCKED-COLUMNS = 2.

{af/sup2/aficonload.i}
/* Browser column triggers */
ON "VALUE-CHANGED":U OF ttSchema.search_from IN BROWSE {&BROWSE-NAME}
DO:
    ASSIGN glFilterModified = YES.
END.

ON "VALUE-CHANGED":U OF ttSchema.search_to IN BROWSE {&BROWSE-NAME}
DO:
    ASSIGN glFilterModified = YES.
END.

ON "VALUE-CHANGED":U OF ttSchema.search_contains IN BROWSE {&BROWSE-NAME}
DO:
    ASSIGN glFilterModified = YES.
END.

ON "VALUE-CHANGED":U OF ttSchema.search_matches IN BROWSE {&BROWSE-NAME}
DO:
    ASSIGN glFilterModified = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects wWin  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE currentPage  AS INTEGER NO-UNDO.

  ASSIGN currentPage = getCurrentPage().

  CASE currentPage: 

    WHEN 0 THEN DO:
       RUN constructObject (
             INPUT  'adm2/dyntoolbar.w':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'EdgePixels2DeactivateTargetOnHidenoDisabledActionsFlatButtonsyesMenuyesShowBorderyesToolbaryesActionGroupsTableio,NavigationTableIOTypeSaveSupportedLinksNavigation-Source,TableIo-SourceToolbarBandsAstraFilterToolbarAutoSizeyesToolbarDrawDirectionHorizontalLogicalObjectNameFilterToolbarAutoResizeDisabledActionsHiddenActionsUpdateHiddenToolbarBandsHiddenMenuBandsMenuMergeOrder0RemoveMenuOnHidenoCreateSubMenuOnConflictyesNavigationTargetNameHideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_dyntoolbar ).
       RUN repositionObject IN h_dyntoolbar ( 1.00 , 1.00 ) NO-ERROR.
       RUN resizeObject IN h_dyntoolbar ( 1.57 , 80.00 ) NO-ERROR.

       RUN constructObject (
             INPUT  'af/sup2/afspfoldrw.w':U ,
             INPUT  FRAME fMain:HANDLE ,
             INPUT  'FolderLabels':U + '&Filter / Find|Advanced' + 'TabFGcolor':U + 'Default|Default' + 'TabBGcolor':U + 'Default|Default' + 'TabINColor':U + 'GrayText|GrayText' + 'ImageEnabled':U + '' + 'ImageDisabled':U + '' + 'Hotkey':U + '' + 'Tooltip':U + '|Advanced filter settings' + 'TabHidden':U + 'no|no' + 'EnableStates':U + 'All|All' + 'DisableStates':U + 'All|All' + 'VisibleRows':U + '10' + 'PanelOffset':U + '20' + 'FolderMenu':U + '' + 'TabsPerRow':U + '4' + 'TabHeight':U + '3' + 'TabFont':U + '4' + 'LabelOffset':U + '0' + 'ImageWidth':U + '0' + 'ImageHeight':U + '0' + 'ImageXOffset':U + '0' + 'ImageYOffset':U + '2' + 'TabSize':U + 'Proportional' + 'SelectorFGcolor':U + 'Default' + 'SelectorBGcolor':U + 'Default' + 'SelectorFont':U + '4' + 'SelectorWidth':U + '3' + 'TabPosition':U + 'Upper' + 'MouseCursor':U + '' + 'InheritColor':U + 'no' + 'TabVisualization':U + 'TABS' + 'PopupSelectionEnabled':U + 'yes' + 'HideOnInitnoDisableOnInitnoObjectLayout':U ,
             OUTPUT h_afspfoldrw ).
       RUN repositionObject IN h_afspfoldrw ( 2.67 , 2.00 ) NO-ERROR.
       RUN resizeObject IN h_afspfoldrw ( 15.24 , 78.00 ) NO-ERROR.

       /* Links to toolbar h_dyntoolbar. */
       RUN addLink ( h_dyntoolbar , 'ContainerToolbar':U , THIS-PROCEDURE ).

       /* Links to SmartFolder h_afspfoldrw. */
       RUN addLink ( h_afspfoldrw , 'Page':U , THIS-PROCEDURE ).

       /* Adjust the tab order of the smart objects. */
       RUN adjustTabOrder ( h_dyntoolbar ,
             rsPermanent:HANDLE IN FRAME fMain , 'BEFORE':U ).
       RUN adjustTabOrder ( h_afspfoldrw ,
             rsPermanent:HANDLE IN FRAME fMain , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.
  /* Select a Startup page. */
  IF currentPage eq 0
  THEN RUN selectPage IN THIS-PROCEDURE ( 1 ).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyFilter wWin 
PROCEDURE applyFilter :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cFieldNames     AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cFieldValues    AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cFieldOperators AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cFilterSettings AS CHARACTER    NO-UNDO.        
    DEFINE VARIABLE cnt             AS INTEGER.
    DEFINE VARIABLE lValid          AS LOGICAL      NO-UNDO.
    DEFINE VARIABLE lContinue       AS LOGICAL      NO-UNDO.    
    DEFINE VARIABLE lCancel         AS LOGICAL      NO-UNDO.
    DEFINE VARIABLE cHighChar       AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE cQueryString    AS CHARACTER    NO-UNDO.

    cHighChar = DYNAMIC-FUNCTION("getHighKey":U IN gshGenManager, SESSION:CPCOLL).

    ASSIGN lContinue = NO
           lValid    = YES.

    /* There should be only one of these. */
    FIND FIRST ttDataObject NO-ERROR.
    IF AVAIL ttDataobject THEN
    DO:
      /* Is there any unsaved or uncommitted data? */ 
      RUN confirmContinue IN ttDataObject.tSdoHandle (INPUT-OUTPUT lCancel).
      IF lCancel THEN RETURN.
    END.
     
    DEFINE BUFFER bttSchema FOR ttSchema.

    FOR EACH ttDataObject:
        ASSIGN cFieldNames     = "":U
               cFieldValues    = "":U
               cFieldOperators = "":U
               .
        FOR EACH bttSchema WHERE
                 bttSchema.sdo_handle = ttDataObject.tSdoHandle :
            IF NOT lContinue THEN
              RUN validateRecord (BUFFER bttSchema,
                                  OUTPUT lValid,
                                  OUTPUT lContinue) NO-ERROR.
    
            IF  NOT lValid 
            AND NOT lContinue THEN DO:
                RUN openQuery.
                APPLY "ITERATION-CHANGED":U TO brFilter IN FRAME {&FRAME-NAME}.    
                APPLY "entry":U TO brFilter IN FRAME {&FRAME-NAME}.
                RETURN "DoNotExit":U.
            END.
             
            IF bttSchema.SEARCH_from <> "" THEN
            DO:
                cnt = cnt + 1.
                cFieldNames     = cFieldNames     + (IF cnt = 1 THEN "" ELSE ",") + bttSchema.COLUMN_name.
                cFieldValues    = cFieldValues    + (IF cnt = 1 THEN "" ELSE CHR(1)) + bttSchema.SEARCH_from.
                cFieldOperators = cFieldOperators + (IF cnt = 1 THEN "" ELSE ",") + ">=".
            END.
            IF bttSchema.SEARCH_to <> "" THEN
            DO:
                cnt = cnt + 1.
                cFieldNames     = cFieldNames     + (IF cnt = 1 THEN "" ELSE ",") + bttSchema.COLUMN_name.
                cFieldValues    = cFieldValues    + (IF cnt = 1 THEN "" ELSE CHR(1)) + bttSchema.SEARCH_to.
                IF bttSchema.COLUMN_datatype = "Character" THEN cFieldValues = cFieldValues + cHighChar.
                cFieldOperators = cFieldOperators + (IF cnt = 1 THEN "" ELSE ",") + "<=".            
            END.
            IF bttSchema.SEARCH_contains <> "" AND bttSchema.word_index THEN
            DO:
                cnt = cnt + 1.
                cFieldNames     = cFieldNames     + (IF cnt = 1 THEN "" ELSE ",") + bttSchema.COLUMN_name.
                cFieldValues    = cFieldValues    + (IF cnt = 1 THEN "" ELSE CHR(1)) + bttSchema.SEARCH_contains.
                cFieldOperators = cFieldOperators + (IF cnt = 1 THEN "" ELSE ",") + "CONTAINS".            
            END.
            IF bttSchema.SEARCH_matches <> "" AND bttSchema.column_datatype = "Character" THEN
            DO:
                cnt = cnt + 1.
                cFieldNames     = cFieldNames     + (IF cnt = 1 THEN "" ELSE ",") + bttSchema.COLUMN_name.
                cFieldValues    = cFieldValues    + (IF cnt = 1 THEN "" ELSE CHR(1)) + bttSchema.SEARCH_matches.
                cFieldOperators = cFieldOperators + (IF cnt = 1 THEN "" ELSE ",") + "MATCHES".            
            END.
        END.
        /* Remove current setting snd set ttDataObject values */

        DYNAMIC-FUNCTION("removeQuerySelection":U IN ttDataObject.tSdoHandle, 
                         ttDataObject.tFieldNames,
                         ttDataObject.tFieldOperators).

        ASSIGN ttDataObject.tFieldNames     = cFieldNames
               ttDataObject.tFieldValues    = cFieldValues
               ttDataObject.tFieldOperators = cFieldOperators
               .
        /* Synch the editor if the manual editor has not bee
           changed.
         */
        if not glManualQuery then
        do:
            {get QueryString cQueryString ttDataObject.tSdoHandle}. 
            ASSIGN EdManualQuery:SCREEN-VALUE = cQueryString.
        end.
    END.    /* each dataobject */

    IF gcFilterOrFind <> "Find":U THEN 
      RUN assignFilter ( INPUT TRUE /* save */ ).
    ELSE
      RUN assignFind.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignFilter wWin 
PROCEDURE assignFilter :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER plSaveSettings           AS LOGICAL          NO-UNDO.
    
    DEFINE VARIABLE lSuccess AS LOGICAL NO-UNDO.         
    DEFINE VARIABLE cEmptyString AS CHARACTER.
    DEFINE VARIABLE cFilterSettings AS CHARACTER NO-UNDO. 
    
    DEFINE VARIABLE cManualAddQueryWhere          AS CHARACTER  NO-UNDO. 
    DEFINE VARIABLE cManualAssignQuerySelection   AS CHARACTER  NO-UNDO. 
    DEFINE VARIABLE cManualSetQuerySort           AS CHARACTER  NO-UNDO. 
    DEFINE VARIABLE cEntry                        AS CHARACTER  NO-UNDO. 
    DEFINE VARIABLE cBuffer                       AS CHARACTER  NO-UNDO. 
    DEFINE VARIABLE iLoop                         AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cQueryString                  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cQueryWhere                   AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cSaveQueryWhere               AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lSboOpened                    AS LOGICAL    NO-UNDO.

    DO WITH FRAME {&FRAME-NAME}:
        /* There should be only one of these. */
        FIND FIRST ttDataObject NO-ERROR.
        {get QueryString cSaveQueryWhere ttDataObject.tSdoHandle}.
        
        /* Manual query entered.
           glManualQuery tells us that there have been changes to the
           editor.
         */
        IF glManualQuery and EdManualQuery:SCREEN-VALUE <> cSaveQueryWhere THEN
        DO:
            {set QueryWhere EdManualQuery:SCREEN-VALUE ttDataObject.tSdoHandle}.
            ASSIGN lSuccess = YES.
        END.
        ASSIGN fiRowsToBatch
               toRebuild
               .
        {set rowsToBatch fiRowsToBatch ttDataObject.tSdoHandle}.
        {set rebuildOnRepos toRebuild ttDataObject.tSdoHandle}.
    END.    /* not SBO */
                                    
    IF NOT glManualQuery THEN
    DO:
        FOR EACH ttDataObject BY ttDataObject.tSdoOrder DESCENDING:
            ASSIGN lSuccess = DYNAMIC-FUNCTION("assignQuerySelection":U IN ttDataObject.tSdoHandle,
                                               ttDataObject.tFieldNames,
                                               ttDataObject.tFieldValues,
                                               ttDataObject.tFieldOperators).
            IF NOT lSuccess THEN
                LEAVE.
        END.    /* each data object */
    END.    /* not manual */

    IF lSuccess THEN
    DO:
        IF gcDataObjectType EQ "SmartBusinessObject":U THEN
            ASSIGN lSboOpened = NO.
        ELSE
            ASSIGN lSboOpened = YES.
        FOR EACH ttDataObject:
            {set FilterActive "ttDataObject.tFieldNames <> ''" ttDataObject.tSdoHandle}.

            /* Ensure that the SBO query has been re-opened (if this is an SBO)
             * since the opeing of the SBO query will ensure that the various 
             * foreign fields are in place correctly. We only want to do this once,
             * though.
             * 
             * If this is the master data object, then its opening will cause all of the
             * related foreign fields to be set up.                                     */
            IF NOT lSboOpened                        AND
               NOT ttDataObject.tMasterObject        AND
               VALID-HANDLE(ttDataObject.tSboHandle) THEN
                DYNAMIC-FUNCTION("openQuery":U IN ttDataObject.tSboHandle).
          
            ASSIGN lSuccess = DYNAMIC-FUNC('openQuery' IN ttDataObject.tSdoHandle).

            IF NOT lSuccess THEN
                LEAVE.
        END.    /* each data object */
    END.    /* success */
        
    IF lSuccess THEN 
    DO:
        ASSIGN glFilterModified = FALSE
               glManualQuery    = no.
        FOR EACH ttDataObject BY ttDataObject.tSdoOrder DESCENDING:
            /* save these settings, since they apparently work */
            ASSIGN ttDataObject.tFilterSettings = ttDataObject.tFieldNames  + CHR(3)
                                                + ttDataObject.tFieldValues + CHR(3)
                                                + ttDataObject.tFieldOperators.
        END.
        IF plSaveSettings THEN
            RUN saveFilter.
    END.    /* success opeing. */
    ELSE
    DO:
        /* do not save the settings */
        ASSIGN cFilterSettings = "":U + CHR(3) + "":U + CHR(3) + "":U.
        /* clear the filter */
        RUN clearFilter.

        IF gcDataObjectType EQ "SmartBusinessObject":U THEN
            ASSIGN lSboOpened = NO.
        ELSE
            ASSIGN lSboOpened = YES.

        /* reopen the query with no filter in place */
        FOR EACH ttDataObject BY ttdataObject.tSdoOrder DESCENDING:        
            {set FilterActive "ttDataObject.tFieldNames <> ''" ttDataObject.tSdoHandle}.

            /* Ensure that the SBO query has been re-opened (if this is an SBO)
             * since the opeing of the SBO query will ensure that the various 
             * foreign fields are in place correctly. We only want to do this once,
             * though.
             * 
             * If this is the master data object, then its opening will cause all of the
             * related foreign fields to be set up.                                     */
            IF NOT lSboOpened                        AND
               NOT ttDataObject.tMasterObject        AND
               VALID-HANDLE(ttDataObject.tSboHandle) THEN
                DYNAMIC-FUNCTION("openQuery":U IN ttDataObject.tSboHandle).

            DYNAMIC-FUNC('openQuery' IN ttDataObject.tSdoHandle).

            ASSIGN ttDataObject.tFilterSettings = cFilterSettings.
        END.        
        /* even if told not to save, save these blank settings */
        RUN saveFilter.
    END.    /* no success setting filtered queries. */

    DO WITH FRAME {&FRAME-NAME}:
        FIND FIRST ttDataObject.
        {get QueryString cQueryString ttDataObject.tSdoHandle}.
        ASSIGN  EdManualQuery:SCREEN-VALUE = cQueryString.
    END.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignFind wWin 
PROCEDURE assignFind :
/*------------------------------------------------------------------------------
  Purpose:     Action Find
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH ttDataObject:
        DYNAMIC-FUNCTION('findRowWhere':U In ttDataObject.tSdoHandle,
                         INPUT ttDataObject.tFieldNames,
                         INPUT ttDataObject.tFieldValues,
                         INPUT ttDataObject.tFieldOperators).
    END.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cancelObject wWin 
PROCEDURE cancelObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* hide the filter window for later use */

    RUN hideObject.
    CLOSE QUERY {&BROWSE-NAME}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearFilter wWin 
PROCEDURE clearFilter :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE dRowsToBatch    AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE lRebuildOnRepos AS LOGICAL    NO-UNDO.

    RUN selectPage (INPUT 1).

    /* Clear the filter fields */
    FOR EACH ttSchema:
        ASSIGN ttSchema.SEARCH_from     = "":u
               ttSchema.SEARCH_to       = "":u
               ttSchema.SEARCH_matches  = "":u
               ttSchema.SEARCH_contains = "":u.
    END.

    /* Clear the advanced info. */
    DO ON ERROR UNDO, LEAVE:
        RUN getSDODefaults (OUTPUT dRowsToBatch,
                            OUTPUT lRebuildOnRepos).
        ASSIGN fiRowsToBatch:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(dRowsToBatch)
               toRebuild:CHECKED = lRebuildOnRepos
               NO-ERROR.
    END.

    /* Reopen the filter query */
    ASSIGN glFilterModified = YES.
    {&OPEN-QUERY-brFilter}
    
    RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wWin  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWin)
  THEN DELETE WIDGET wWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wWin  _DEFAULT-ENABLE
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
  DISPLAY rsPermanent fiRowsToBatch ToRebuild EdManualQuery fiManualQuery 
          fiFilterLabel fiFindLabel 
      WITH FRAME fMain IN WINDOW wWin.
  ENABLE rsPermanent brFilter fiRowsToBatch ToRebuild EdManualQuery 
      WITH FRAME fMain IN WINDOW wWin.
  {&OPEN-BROWSERS-IN-QUERY-fMain}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exitObject wWin 
PROCEDURE exitObject :
/*------------------------------------------------------------------------------
  Purpose:  Window-specific override of this procedure which destroys 
            its contents and itself.
    Notes:  
------------------------------------------------------------------------------*/

  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSDODefaults wWin 
PROCEDURE getSDODefaults :
/*------------------------------------------------------------------------------
  Purpose:     This procedure returns the default rowsToBatch and rebuildOnRepos
               values.  We can't just do a {get rowsToBatch...} or {get rebuildOnRepos}
               as these attributes are set to the values the user entered on the 
               filter viewer when the SDO is initialised.  We have to go and check
               the attributes saved in the repository cache to get the initial values.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER iRowsToBatch    AS DECIMAL    NO-UNDO INITIAL ?.
DEFINE OUTPUT PARAMETER lRebuildOnRepos AS LOGICAL    NO-UNDO INITIAL ?.

DEFINE VARIABLE rRowid       AS ROWID      NO-UNDO.
DEFINE VARIABLE lExists      AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cSDOSettings AS CHARACTER  NO-UNDO.

DEFINE BUFFER ttDataObject FOR ttDataObject.

/* When the SDO is initialized, the default rowsToBatch and rebuildOnRepos are written to session profile data.     *
 * This is only done if profile information exists for the user which is going to overwrite the default attributes. *
 * To prevent us from making an unnecessary Appserver call, first check if the default profile info exists in the   *
 * local cache.  If it doesn't, we can assume the SDO defaults haven't been overwritten.                            */
IF VALID-HANDLE(gshProfileManager) 
THEN then-blk: DO:
    FIND FIRST ttDataObject NO-ERROR.
    IF NOT AVAIL ttDataObject THEN
        LEAVE then-blk.

    RUN checkProfileDataExists IN gshProfileManager (INPUT "SDO":U,
                                                     INPUT "Attributes":U,
                                                     INPUT ttDataObject.tSdoSignature + ",defAttrs",
                                                     INPUT NO,
                                                     INPUT YES,
                                                     OUTPUT lExists).
    IF lExists = YES THEN 
    DO:
        ASSIGN rRowid = ?.
        RUN getProfileData IN gshProfileManager (INPUT "SDO":U,
                                                 INPUT "Attributes":U,
                                                 INPUT ttDataObject.tSdoSignature + ",defAttrs",
                                                 INPUT NO,
                                                 INPUT-OUTPUT rRowid,
                                                 OUTPUT cSDOSettings).
        IF NUM-ENTRIES(cSDOSettings, CHR(3)) = 2 THEN
            ASSIGN iRowsToBatch    = INTEGER(ENTRY(1, cSDOSettings, CHR(3)))
                   lRebuildOnRepos = LOGICAL(ENTRY(2, cSDOSettings, CHR(3)))
                   NO-ERROR.
    END.

    /* Now check if we have been able to determine what the attributes are.  If not, get them from the SDO. */
    IF (iRowsToBatch = ? OR NOT lExists) 
    AND VALID-HANDLE(ttDataObject.tSDOHandle) THEN
        {get rowsToBatch iRowsToBatch ttDataObject.tSDOHandle}.

    IF (lRebuildOnRepos = ? OR NOT lExists) 
    AND VALID-HANDLE(ttDataObject.tSDOHandle) THEN
        {get rebuildOnRepos lRebuildOnRepos ttDataObject.tSDOHandle}.

END.

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN "":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject wWin 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE hToolbar AS HANDLE     NO-UNDO.
    DEFINE VARIABLE hWidget  AS HANDLE     NO-UNDO.

    /* Set the logical object name to the physical name, so that 
     * security can be applied.                                   */
    {set LogicalObjectName 'afsdofiltw.w'}.

    IF lInitialized THEN RETURN.
    ASSIGN lInitialized = TRUE.

    {set HideOnInit TRUE}.

    RUN SUPER.
    DO WITH FRAME {&FRAME-NAME}:
        IF fiManualQuery:PRIVATE-DATA <> ? THEN
            ASSIGN fiManualQuery = fiManualQuery:PRIVATE-DATA fiManualQuery:SCREEN-VALUE = fiManualQuery:PRIVATE-DATA.
        IF fiFindLabel:PRIVATE-DATA <> ? THEN
            ASSIGN fiFindLabel = fiFindLabel:PRIVATE-DATA fiFindLabel:SCREEN-VALUE = fiFindLabel:PRIVATE-DATA.
        IF fiFilterLabel:PRIVATE-DATA <> ? THEN
            ASSIGN fiFilterLabel = fiFilterLabel:PRIVATE-DATA fiFilterLabel:SCREEN-VALUE = fiFilterLabel:PRIVATE-DATA.
    END.

    /* View page 1 */
    RUN selectPage IN TARGET-PROCEDURE (INPUT 1).

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE okObject wWin 
PROCEDURE okObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  APPLY "ROW-LEAVE" TO BROWSE {&BROWSE-NAME}.

  ASSIGN  BROWSE {&BROWSE-NAME}
      ttSchema.SEARCH_from 
      ttSchema.SEARCH_to 
      ttSchema.SEARCH_contains 
      ttSchema.SEARCH_matches NO-ERROR.
  
  ERROR-STATUS:ERROR = NO.
  
  IF glFilterModified THEN     
     RUN applyFilter.
 
  IF RETURN-VALUE = "":U THEN
     RUN cancelObject.
  
  ELSE RETURN RETURN-VALUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuery wWin 
PROCEDURE openQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
CASE cSortBy:
    WHEN "index" THEN DO:
        OPEN QUERY {&browse-name}
            FOR EACH ttSchema WHERE NOT adm_column AND ttSchema.table_name <> ""
                AND INDEX(ttschema.COLUMN_name, "_obj") = 0
                BY ttSchema.INDEX_position.
    END.
    WHEN "ttSchema.COLUMN_label" THEN DO:
        OPEN QUERY {&browse-name}
            FOR EACH ttSchema WHERE NOT adm_column AND ttSchema.table_name <> ""
                AND INDEX(ttschema.COLUMN_name, "_obj") = 0
                BY ttSchema.COLUMN_label.
    END.
    OTHERWISE DO:
        OPEN QUERY {&browse-name}
            FOR EACH ttSchema WHERE NOT adm_column AND ttSchema.table_name <> ""
                AND INDEX(ttschema.COLUMN_name, "_obj") = 0
                BY ttSchema.TABLE_sequence BY ttSchema.INDEX_position BY ttSchema.COLUMN_label.
    END.

END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE postCreateObjects wWin 
PROCEDURE postCreateObjects :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hAttributeBuffer  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hClassBuffer      AS HANDLE     NO-UNDO.

  /* Fetch the repository class*/
  hClassBuffer = DYNAMIC-FUNCTION("getCacheClassBuffer":U IN gshRepositoryManager, "SmartFolder":U).

  IF VALID-HANDLE(hClassBuffer) THEN
    hAttributeBuffer = hClassBuffer:BUFFER-FIELD("classBufferHandle":U):BUFFER-VALUE.   

  IF VALID-HANDLE(hAttributeBuffer) THEN
  DO:
    hAttributeBuffer:BUFFER-CREATE().

    {fnarg setPopupSelectionEnabled "hAttributeBuffer:BUFFER-FIELD('PopupSelectionEnabled'):BUFFER-VALUE" h_afspfoldrw}.
    {fnarg setTabVisualization      "hAttributeBuffer:BUFFER-FIELD('TabVisualization'):BUFFER-VALUE"      h_afspfoldrw}.
    {fnarg setTabPosition           "hAttributeBuffer:BUFFER-FIELD('TabPosition'):BUFFER-VALUE"           h_afspfoldrw}.

    hAttributeBuffer:BUFFER-DELETE().
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetFilter wWin 
PROCEDURE resetFilter :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE iField          AS INTEGER                          NO-UNDO.
    DEFINE VARIABLE cOperator       AS CHARACTER                        NO-UNDO.    
    DEFINE VARIABLE cValue          AS CHARACTER                        NO-UNDO.
    DEFINE VARIABLE cHighChar       AS CHARACTER    NO-UNDO.

    cHighChar = DYNAMIC-FUNCTION("getHighKey":U IN gshGenManager, SESSION:CPCOLL).

    RUN retrieveFilter.
    
    FOR EACH ttDataObject :
      FOR EACH ttSchema WHERE
               ttSchema.sdo_handle = ttDataObject.tSdoHandle:         
        /* Delete filter field if field is in query and not in saved filter */
        IF LOOKUP(ttSchema.COLUMN_name,ttDataObject.tFieldNames) = 0
        AND DYNAMIC-FUNCTION("columnQuerySelection":U IN ttDataObject.tSdoHandle,
                             ttSchema.COLUMN_name) > '' THEN
           DELETE ttSchema.
      END.
      IF NUM-ENTRIES(ttDataObject.tFilterSettings,CHR(3)) EQ 3 THEN
      DO:
        DO iField = 1 TO NUM-ENTRIES(ttDataObject.tFieldNames):
            FIND FIRST ttSchema WHERE
                       ttSchema.sdo_handle = ttDataObject.tSdoHandle  AND
                       ttSchema.COLUMN_name = ENTRY(iField, ttDataObject.tFieldNames) 
                       NO-ERROR.

            IF AVAILABLE ttSchema THEN
            DO:
                ASSIGN cOperator = ENTRY(iField,ttDataObject.tFieldOperators)
                       cValue = TRIM(ENTRY(iField,ttDataObject.tFieldValues,CHR(1)),cHighChar)
                       .
                CASE cOperator:
                    WHEN ">="       THEN ttSchema.search_from       = cValue.
                    WHEN "<="       THEN ttSchema.search_to         = cValue.
                    WHEN "CONTAINS" THEN ttSchema.search_contains   = cValue.
                    WHEN "MATCHES"  THEN ttSchema.search_matches    = cValue.
                END CASE.
            END.    /* avail ttcschema */
        END.    /* field loop */
      END.  /* if filtersettings */
    END.    /* each data object */
    
    ASSIGN glFilterModified = FALSE
           glManualQuery    = no.
    
    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetSesPerFlag wWin 
PROCEDURE resetSesPerFlag :
/*------------------------------------------------------------------------------
  Purpose:     If we've retreived a filter that's been saved permanently, the user 
               has to save or clear it permanently as well.  This prevents situations 
               where the user has a permanent filter saved, and clears it for session only.
               Next time he starts his session, the filter is back, causing confusion.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cSaveFlag      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hProfileRecord AS HANDLE     NO-UNDO.

ASSIGN cSaveFlag = "SES":U.

IF grAdvancedProfileRecord <> ?
OR grFieldProfileRecord    <> ? 
THEN then-blk: DO:
    ASSIGN hProfileRecord = DYNAMIC-FUNCTION("getProfileTTHandle":U IN gshProfileManager).

    IF VALID-HANDLE(hProfileRecord) 
    THEN DO:
        ASSIGN hProfileRecord = hProfileRecord:DEFAULT-BUFFER-HANDLE.
        IF grFieldProfileRecord <> ? 
        THEN DO:
            hProfileRecord:FIND-BY-ROWID(grFieldProfileRecord) NO-ERROR.
            IF  hProfileRecord:AVAILABLE
            AND hProfileRecord:BUFFER-FIELD("context_id":U):BUFFER-VALUE = "":U 
            THEN DO:
                ASSIGN cSaveFlag = "PER":U.
                LEAVE then-blk.
            END.
        END.

        IF grAdvancedProfileRecord <> ?
        THEN DO:
            hProfileRecord:FIND-BY-ROWID(grAdvancedProfileRecord) NO-ERROR.
            IF  hProfileRecord:AVAILABLE
            AND hProfileRecord:BUFFER-FIELD("context_id":U):BUFFER-VALUE = "":U 
            THEN DO:
                ASSIGN cSaveFlag = "PER":U.
                LEAVE then-blk.
            END.
        END.
    END.
END.

DO WITH FRAME {&FRAME-NAME}:
    ASSIGN rsPermanent:SCREEN-VALUE = cSaveFlag.

    IF cSaveFlag = "PER":U THEN
        ASSIGN rsPermanent:PRIVATE-DATA = "PER":U.
    ELSE
        ASSIGN rsPermanent:PRIVATE-DATA = "SES":U.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retrieveFilter wWin 
PROCEDURE retrieveFilter :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/    
    DEFINE VARIABLE rRowid          AS ROWID      NO-UNDO.
    DEFINE VARIABLE cFilterSettings AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cDummy          AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE lExists         AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE hProfileRecord  AS HANDLE     NO-UNDO.
    DEFINE VARIABLE cSaveFlag       AS CHARACTER  NO-UNDO.

    FOR EACH ttDataObject:
        /* If any information has been stored in profile data, it would already have been cached when the *
         * SDO was started up.  So we're only going to check the local cache.                             */
        RUN checkProfileDataExists IN gshProfileManager (INPUT "SDO":U,
                                                         INPUT "Attributes":U,
                                                         INPUT ttDataObject.tSdoSignature,
                                                         INPUT NO,
                                                         INPUT YES,
                                                         OUTPUT lExists).
        IF lExists 
        THEN DO:
            /* We're making this call only because we need the rowid of the profile record */
            ASSIGN rRowid = ?.
            RUN getProfileData IN gshProfileManager ( INPUT  "SDO":U,
                                                      INPUT  "Attributes":U,
                                                      INPUT  ttDataObject.tSdoSignature,
                                                      INPUT  NO,
                                                      INPUT-OUTPUT rRowid,
                                                      OUTPUT ttDataObject.tFilterSettings).
            ASSIGN grAdvancedProfileRecord = rRowid.
        END.
        ELSE
            ASSIGN grAdvancedProfileRecord = ?.

        /* Get the filter fields */
        RUN checkProfileDataExists IN gshProfileManager (INPUT "BrwFilters":U,
                                                         INPUT "FilterSet":U,
                                                         INPUT ttDataObject.tSdoSignature,
                                                         INPUT NO,
                                                         INPUT YES,
                                                         OUTPUT lExists).
        IF lExists THEN 
        DO:
            ASSIGN rRowid = ?.
            RUN getProfileData IN gshProfileManager ( INPUT "BrwFilters":U,
                                                      INPUT "FilterSet":U,
                                                      INPUT ttDataObject.tSdoSignature,
                                                      INPUT NO,
                                                      INPUT-OUTPUT rRowid,
                                                      OUTPUT ttDataObject.tFilterSettings).
            ASSIGN grFieldProfileRecord = rRowid.
            
            /* Assign our values */    
            IF NUM-ENTRIES(ttDataObject.tFilterSettings, CHR(3)) EQ 3 THEN
            DO:
                ASSIGN ttDataObject.tFieldNames     = ENTRY(1,ttDataObject.tFilterSettings,CHR(3))
                       ttDataObject.tFieldValues    = ENTRY(2,ttDataObject.tFilterSettings,CHR(3))
                       ttDataObject.tFieldOperators = ENTRY(3,ttDataObject.tFilterSettings,CHR(3))
                       .
                /* profiles used to be stored with names only */
                IF INDEX(ttDataObject.tFieldNames,'.':U) = 0 THEN
                  ttDataObject.tFieldNames 
                    = LEFT-TRIM(REPLACE(',' + ttDataObject.tFieldNames,',',',RowObject.'),',').
            END.

        END.
        ELSE
            ASSIGN grFieldProfileRecord = ?.
    END.

    RUN resetSesPerFlag.
        
    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveFilter wWin 
PROCEDURE saveFilter :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE lDelete AS LOGICAL NO-UNDO.

    DEFINE VARIABLE dDefaultRowsToBatch    AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE lDefaultRebuildOnRepos AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE cDummy                 AS CHARACTER  NO-UNDO.

    ASSIGN FRAME {&FRAME-NAME} 
           rsPermanent 
           fiRowsToBatch 
           toRebuild.

    FOR EACH ttDataObject:

        /* Save filter field values entered */
        ASSIGN lDelete = REPLACE(ttDataObject.tFilterSettings, CHR(3), "":U) = "":U.

        IF grFieldProfileRecord = ? AND lDelete = YES THEN. /* ...do nothing.  We can't delete something that doesn't exist */
        ELSE DO:
            RUN setProfileData IN gshProfileManager ( INPUT "BrwFilters":U,
                                                      INPUT "FilterSet":U,
                                                      INPUT ttDataObject.tSdoSignature,
                                                      INPUT grFieldProfileRecord,
                                                      INPUT ttDataObject.tFilterSettings,
                                                      INPUT lDelete,
                                                      INPUT rsPermanent).
            {afcheckerr.i &DISPLAY-ERROR = YES}.

            /* Now make sure the profile record rowid is set correctly */
            IF grFieldProfileRecord = ? THEN /* This will only happen if there was no profile info first time round */
                /* We know we MUST have create profile info, so get it's rowid */
                RUN getProfileData IN gshProfileManager (INPUT "BrwFilters":U,
                                                         INPUT "FilterSet":U,
                                                         INPUT ttDataObject.tSdoSignature,
                                                         INPUT NO,
                                                         INPUT-OUTPUT grFieldProfileRecord,
                                                         OUTPUT cDummy). /* We want the ROWID, not the profile values */
            ELSE
                IF lDelete = YES THEN
                    ASSIGN grFieldProfileRecord = ?.
        END.

        /* Save advanced settings */

        RUN getSDODefaults (OUTPUT dDefaultRowsToBatch,
                            OUTPUT lDefaultRebuildOnRepos).

        /* If the user has entered SDO defaults for his values, delete the profile data */
        ASSIGN lDelete = (fiRowsToBatch = dDefaultRowsToBatch) AND
                         (toRebuild     = lDefaultRebuildOnRepos).

        IF grAdvancedProfileRecord = ? AND lDelete = YES THEN. /* ...do nothing.  We can't delete something that doesn't exist */
        ELSE DO:
            RUN setProfileData IN gshProfileManager ( INPUT "SDO":U,
                                                      INPUT "Attributes":U,
                                                      INPUT ttDataObject.tSdoSignature,
                                                      INPUT grAdvancedProfileRecord,
                                                      INPUT STRING(fiRowsToBatch) + CHR(3) + (IF toRebuild THEN "YES":U ELSE "NO":U),
                                                      INPUT lDelete,
                                                      INPUT rsPermanent).
            {afcheckerr.i &DISPLAY-ERROR = YES}.

            /* Now make sure the profile record rowid is set correctly */
            IF grAdvancedProfileRecord = ? THEN /* This will only happen if there was no profile info first time round */
                /* We know we MUST have create profile info, so get it's rowid */
                RUN getProfileData IN gshProfileManager (INPUT "SDO":U,
                                                         INPUT "Attributes":U,
                                                         INPUT ttDataObject.tSdoSignature,
                                                         INPUT NO,
                                                         INPUT-OUTPUT grAdvancedProfileRecord,
                                                         OUTPUT cDummy). /* We want the ROWID, not the profile values */
            ELSE
                IF lDelete = YES THEN
                    ASSIGN grAdvancedProfileRecord = ?.
        END.
    END.

    RUN resetSesPerFlag.

    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN "":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selectPage wWin 
PROCEDURE selectPage :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER piPageNumber AS INTEGER.

RUN SUPER(piPageNumber).

DO WITH FRAME {&FRAME-NAME}:

  fiFindLabel:HIDDEN = TRUE.
  fiFilterLabel:HIDDEN = TRUE.
  brFilter:HIDDEN = (piPageNumber <> 1).
  EdManualQuery:HIDDEN = (piPageNumber <> 2).
  fiManualQuery:HIDDEN = (piPageNumber <> 2).
  fiRowsToBatch:HIDDEN = (piPageNumber <> 2).
  ToRebuild:HIDDEN = (piPageNumber <> 2).

  IF NOT brFilter:HIDDEN THEN brFilter:MOVE-TO-TOP().
  IF NOT EdManualQuery:HIDDEN THEN EdManualQuery:MOVE-TO-TOP().
  IF NOT fiManualQuery:HIDDEN THEN fiManualQuery:MOVE-TO-TOP().
  IF NOT fiRowsToBatch:HIDDEN THEN fiRowsToBatch:MOVE-TO-TOP().
  IF NOT ToRebuild:HIDDEN THEN ToRebuild:MOVE-TO-TOP().

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDataSourceHandle wWin 
PROCEDURE setDataSourceHandle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcFilterOrFind   AS CHARACTER                    NO-UNDO.
    DEFINE INPUT PARAMETER phDataSource     AS HANDLE                       NO-UNDO.
    DEFINE INPUT PARAMETER phBrowser        AS HANDLE                       NO-UNDO.
    
    DEFINE VARIABLE cQueryWhere                 AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE iRowsToBatch                AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE lRebuild                    AS LOGICAL                  NO-UNDO.
    DEFINE VARIABLE hContainerSource            AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE cLogicalObjectName          AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cRunAttribute               AS CHARACTER                NO-UNDO.                                                         
    DEFINE VARIABLE csdoName                    AS CHARACTER                NO-UNDO.                                                     
    DEFINE VARIABLE cFilterSignature            AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cWindowTitle                AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE hColumn                     AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hBrowser                    AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE cDataHandle                 AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cFieldHandles               AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE iLoop                       AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE cFieldNames                 AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cDisplayedFields            AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cColumnsByTable             AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE hParentWindow               AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hDataObject                 AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE hSBOContainer               AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE cDataObjectNames            AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cDataObjectHandles          AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE iSdoLoop                    AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE cDataContainerName          AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cDataSourceNames            AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cDataObjectName             AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE hMasterDataObject           AS HANDLE                   NO-UNDO.
    DEFINE VARIABLE cSdoOrder                   AS CHARACTER                NO-UNDO.

    IF NOT TRANSACTION THEN EMPTY TEMP-TABLE ttSchema. ELSE FOR EACH ttSchema: DELETE ttSchema. END.
    EMPTY TEMP-TABLE ttDataObject.
    
    /* set the window size appropriately */                          
    {&WINDOW-NAME}:MIN-WIDTH = 80.
    {&WINDOW-NAME}:MIN-HEIGHT = 17.

    /* remember these values for later */
    ASSIGN gcFilterOrFind = pcFilterOrFind
           ghDataSource   = phDataSource
           ghBrowser      = phBrowser
           cRunAttribute  = "":U
           .
    IF gcFilterOrFind = "Find":U 
    THEN DO:
        ASSIGN rsPermanent:VISIBLE IN FRAME {&FRAME-NAME} = NO.
        RUN selectPage(1).
        RUN disableFolderPage IN h_afspfoldrw (2).
    END.
    ELSE DO:
        ASSIGN rsPermanent:VISIBLE IN FRAME {&FRAME-NAME} = YES.
        RUN enableFolderPage IN h_afspfoldrw (2).
    END.

    /* If field is not shown in browser, do not allow  */
    /* filtering on it, as this may cause confusion.   */
    cFieldNames = DYNAMIC-FUNCTION("getDisplayedFields" IN phBrowser).

    {get ObjectType gcDataObjectType phDataSource}.

    {get ContainerSource hContainerSource phDataSource}.
    {get LogicalObjectName cLogicalObjectName hContainerSource}.
    IF cLogicalObjectName EQ "":U OR cLogicalObjectName EQ ? THEN
        ASSIGN cLogicalObjectName = hContainerSource:FILE-NAME.

    IF gcDataObjectType EQ "SmartBusinessObject":U THEN
    DO:
        {get DataObjectNames      cDataObjectNames   phDataSource}.
        {get ContainedDataObjects cDataObjectHandles phDataSource}.
        {get MasterDataObject     hMasterDataObject  phDataSource}.
        {get DataSourceNames      cDataSourceNames   phBrowser}.
        {get DataObjectOrdering   cSdoOrder          phDataSource}.

        IF NUM-ENTRIES(cDataSourceNames) NE 1 THEN
            RUN disableFolderPage IN h_afspfoldrw (2).

        {get LogicalObjectName cDataContainerName phDataSource}.
        IF cDataContainerName EQ "":U OR cDataContainerName EQ ? THEN
            ASSIGN cDataContainerName = phDataSource:FILE-NAME.

        DO iSdoLoop = 1 TO NUM-ENTRIES(cDataObjectHandles):
            ASSIGN hDataObject = WIDGET-HANDLE(ENTRY(iSdoLoop, cDataObjectHandles)).

            /* Only include SDOs which are in the browse's DataSourceNames property. */
            IF LOOKUP(ENTRY(iSdoLoop, cDataObjectNames), cDataSourceNames) EQ 0 THEN
                NEXT.

            RUN describeSchema IN hDataObject ( INPUT  cFieldNames, OUTPUT TABLE ttCacheSchema ).

            /* Ensures that BLOB and CLOB fields are not included in Filter/Find browser */
            FOR EACH ttCacheSchema WHERE ttCacheSchema.column_datatype = "BLOB":U
                                 OR ttCacheSchema.column_datatype = "CLOB":U:
                DELETE ttCacheSchema.
            END. 

            FOR EACH ttCacheSchema:
                CREATE ttSchema.
                BUFFER-COPY ttCacheSchema TO ttSchema.
            END.

            {get LogicalObjectName cSdoName hDataObject}.
            IF cSdoName EQ "":U OR cSdoName EQ ? THEN
              {get ObjectName cSDOName hDataObject}.
            IF cSdoName EQ "":U OR cSdoName EQ ? THEN
              cSdoName = hDataObject:FILE-NAME.

            CREATE ttDataObject.
            ASSIGN ttDataObject.tSdoHandle    = hDataObject
                   ttDataObject.tSdoOrder     = INTEGER(ENTRY(iSdoLoop, cSdoOrder))
                   ttDataObject.tSdoSignature = cSdoName + ",":U + cDataContainerName + "," + cLogicalObjectName + ",":U + cRunAttribute
                   ttDataObject.tSboHandle    = phDataSource
                   ttDataObject.tMasterObject = (hMasterDataObject EQ hDataObject)
                   ttDataObject.tDbAware      = yes
                   .
        END.    /* data objects */
    END.    /* SBO */
    ELSE
    DO:    
        ASSIGN cDataContainerName = "":U.
        RUN describeSchema IN phDataSource ( INPUT  cFieldNames, OUTPUT TABLE ttSchema ).

        /* Ensures that BLOB and CLOB fields are not included in Filter/Find browser */
        FOR EACH ttSchema WHERE ttSchema.column_datatype = "BLOB":U
                             OR ttSchema.column_datatype = "CLOB":U:
            DELETE ttSchema.
        END. 
        
        CREATE ttDataObject.
        {get DbAware ttDataObject.tDbAware phDataSource}.
        
        /* cannot use logical name for Dataview */ 
        IF ttDataObject.tDbAware THEN
          {get LogicalObjectName cSdoName phDataSource}.
        
        IF cSdoName EQ "":U OR cSdoName EQ ? THEN
          {get ObjectName cSDOName phDataSource}.
        
        IF cSdoName EQ "":U OR cSdoName EQ ? THEN
           cSdoName = phDataSource:FILE-NAME.
        ASSIGN ttDataObject.tSdoHandle    = phDataSource
               ttDataObject.tSdoOrder     = 1
               ttDataObject.tSdoSignature = cSdoName + ",":U + cDataContainerName + ",":U + cLogicalObjectName + ",":U + cRunAttribute
               ttDataObject.tSboHandle    = ?
               .        
    END.    /* SDO */

    {get ObjectParent hParentWindow}.

    ASSIGN cWindowTitle   = (IF VALID-HANDLE(hParentWindow) AND hParentWindow:TITLE <> "" THEN " - " + hParentWindow:TITLE ELSE "":U)
           {&WINDOW-NAME}:TITLE = (IF gcFilterOrFind = "Find":U THEN fiFindLabel:SCREEN-VALUE ELSE fiFilterLabel:SCREEN-VALUE)
                                + cWindowTitle.

    IF gcFilterOrFind <> "Find":U THEN
        RUN resetFilter.

    ASSIGN
        hColumn = BROWSE {&BROWSE-name}:FIRST-COLUMN
        hColumn = hColumn:NEXT-COLUMN
        hColumn = hColumn:NEXT-COLUMN
        cSortBy = "ttSchema.sdo_order BY ttSchema.TABLE_sequence BY ttSchema.INDEX_position BY ttSchema.COLUMN_label".
    DO WHILE VALID-HANDLE(hColumn):
        ASSIGN
            hColumn:LABEL-BGCOLOR = {&NON-SORT-COLOR}
            hColumn = hColumn:NEXT-COLUMN.
    END.

     
    /* Display Advanced data for the SDO. */    
    FIND FIRST ttDataObject NO-ERROR.
    IF AVAILABLE ttDataObject THEN
    DO WITH FRAME {&FRAME-NAME}:       
        {get QueryString cQueryWhere ttDataObject.tSdoHandle}.
        ASSIGN EdManualQuery:SCREEN-VALUE = cQueryWhere.

        {get rowsToBatch iRowsToBatch ttDataObject.tSdoHandle}.
        {get rebuildOnRepos lRebuild ttDataObject.tSdoHandle}.

        ASSIGN fiRowsToBatch              = iRowsToBatch
               ToRebuild                  = lRebuild
               fiRowsToBatch:SCREEN-VALUE = STRING(iRowsToBatch)
               toRebuild:SCREEN-VALUE     = STRING(toRebuild).
    END.
    ELSE
        RUN disableFolderPage IN h_afspfoldrw (2).
   
    {&OPEN-QUERY-brFilter}

    APPLY "ITERATION-CHANGED":U TO brFilter IN FRAME {&FRAME-NAME}.

    {&WINDOW-NAME}:WIDTH = 92.
    APPLY "WINDOW-RESIZED" TO {&WINDOW-NAME}.

    RUN viewObject.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE toolbar wWin 
PROCEDURE toolbar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcAction AS CHARACTER.

/*Commented to workaround bug# 20051111-057.
    APPLY "ROW-LEAVE" TO BROWSE {&BROWSE-NAME}.*/

    ASSIGN BROWSE {&BROWSE-NAME}
        ttSchema.SEARCH_from 
        ttSchema.SEARCH_to 
        ttSchema.SEARCH_contains 
        ttSchema.SEARCH_matches NO-ERROR.

    CASE pcAction:
        WHEN "Apply"  THEN RUN applyFilter.
        WHEN "Clear"  THEN RUN clearFilter.
        OTHERWISE
           RUN SUPER (pcAction).
    END CASE.

ERROR-STATUS:ERROR = NO.
RETURN RETURN-VALUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord wWin 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE PARAMETER BUFFER pbttSchema  FOR ttSchema.
DEFINE OUTPUT PARAMETER plValid     AS LOGICAL    NO-UNDO.
DEFINE OUTPUT PARAMETER plContinue  AS LOGICAL    NO-UNDO.

ASSIGN plContinue = NO
       plValid = YES.

DEFINE VARIABLE cErrorMessage   AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cButton         AS CHARACTER    NO-UNDO.
DEFINE VARIABLE cIndexPosition  AS CHARACTER    NO-UNDO.
DEFINE VARIABLE iLoop           AS INTEGER      NO-UNDO.
DEFINE VARIABLE iPos1           AS INTEGER      NO-UNDO.
DEFINE VARIABLE iPos2           AS INTEGER      NO-UNDO.
DEFINE VARIABLE cPos            AS CHARACTER    NO-UNDO.
DEFINE VARIABLE dDecimal        AS DECIMAL      NO-UNDO.
DEFINE VARIABLE tDateFrom       AS DATE         NO-UNDO.
DEFINE VARIABLE tDateTo         AS DATE         NO-UNDO.
DEFINE VARIABLE tDateTimeFrom   AS DATETIME     NO-UNDO.
DEFINE VARIABLE tDateTimeTo     AS DATETIME     NO-UNDO.
DEFINE VARIABLE tDateTimeTZFrom AS DATETIME-TZ  NO-UNDO.
DEFINE VARIABLE tDateTimeTZTo   AS DATETIME-TZ  NO-UNDO.

DEFINE VARIABLE lValidList      AS LOGICAL EXTENT 20 NO-UNDO.

DEFINE BUFFER b2ttSchema FOR ttSchema.

    IF  NOT pbttSchema.column_indexed
    AND (pbttSchema.search_from <> "":u
         OR pbttSchema.search_from <> "":u
         OR pbttSchema.search_matches <> "":u 
         OR pbttSchema.search_contains <> "":u) THEN DO:

        ASSIGN
            cErrorMessage = {af/sup2/aferrortxt.i 'RY' '9' '?' '?' LC(gcFilterOrFind)}.

        RUN showMessages IN gshSessionManager (INPUT  cErrorMessage,    /* messages */
                                               INPUT  "WAR":U,          /* type */
                                               INPUT  "&Yes,&No":U,       /* button list */
                                               INPUT  "&YES":U,          /* default */
                                               INPUT  "&NO":U,           /* cancel */
                                               INPUT  "":U,             /* title */
                                               INPUT  YES,              /* disp. empty */
                                               INPUT  ?,                /* container handle */
                                               OUTPUT cButton           /* button pressed */
                                              ).
        ASSIGN
            plContinue = cButton BEGINS "&Y"
            plValid = IF plContinue THEN YES ELSE NO. /* If the user does not care that the filter is not indexed, then keep validating */
    END.

    IF NOT plValid THEN RETURN.

    /* Assume all valid to start */
    DO iLoop = 1 TO NUM-ENTRIES(pbttSchema.index_position):
      ASSIGN lValidList[iLoop] = YES.
    END.

    IF  pbttSchema.column_indexed
    AND (pbttSchema.search_from <> "":u
         OR pbttSchema.search_to <> "":u
         OR pbttSchema.search_matches <> "":u 
         OR pbttSchema.search_contains <> "":u) THEN
    index-loop:
    DO iLoop = 1 TO NUM-ENTRIES(pbttSchema.index_position):

      /* If 1st element of any index, then it must be ok */
      IF INDEX(pbttSchema.index_position,".1":U) > 0 THEN LEAVE index-loop.

      ASSIGN cIndexPosition = ENTRY(iLoop, pbttSchema.index_position).
      IF NUM-ENTRIES(cIndexPosition,".":U) <> 2 THEN NEXT index-loop.   /* invalid */

      /* Not 1st element of an index, so must check all other fields in this index prior
         to this position and warn if any do not have a value specified
      */
      sub-loop:
      FOR EACH b2ttSchema NO-LOCK
         WHERE b2ttSchema.column_indexed
           AND b2ttSchema.search_from = "":u
           AND b2ttSchema.search_to = "":u
           AND b2ttSchema.search_matches = "":u 
           AND b2ttSchema.search_contains = "":u
           AND ROWID(b2ttSchema) <> ROWID(pbttSchema):
        /* see if field in same index */
        ASSIGN
          iPos1 = INDEX(b2ttSchema.index_position, ENTRY(1, cIndexPosition, ".":U) + ".":U)
          iPos2 = 0
          cPos = "":U.

        IF iPos1 > 0 THEN ASSIGN iPos2 = INDEX(b2ttSchema.index_position, ",":U, iPos1).
        IF iPos1 > 0 AND iPos2 = 0 THEN ASSIGN iPos2 = LENGTH(b2ttSchema.index_position) + 1.
        IF iPos1 > 0 AND iPos2 > iPos1 THEN
          ASSIGN cPos = SUBSTRING(b2ttSchema.index_position, iPos1 + 2, iPos2 - iPos1 - 2) NO-ERROR.

        IF INTEGER(cPos) < INTEGER(ENTRY(2,cIndexPosition,".":U)) THEN
        DO:
          ASSIGN lValidList[iLoop] = NO.
          NEXT index-loop.
        END.
      END.
    END.

    /* If any of the indexes are valid, then all is ok */
    ASSIGN plValid = NO.
    DO iLoop = 1 TO NUM-ENTRIES(pbttSchema.index_position):
      IF lValidList[iLoop] = YES THEN ASSIGN plValid = YES.
    END.

    IF NOT plValid AND plContinue = NO THEN
    DO:
        ASSIGN
            cErrorMessage = {af/sup2/aferrortxt.i 'RY' '9' '?' '?' LC(gcFilterOrFind)}.

        RUN showMessages IN gshSessionManager (INPUT  cErrorMessage,    /* messages */
                                               INPUT  "WAR":U,          /* type */
                                               INPUT  "&Yes,&No":U,     /* button list */
                                               INPUT  "&No":U,          /* default */
                                               INPUT  "&No":U,          /* cancel */
                                               INPUT  "":U,             /* title */
                                               INPUT  YES,              /* disp. empty */
                                               INPUT  ?,                /* container handle */
                                               OUTPUT cButton           /* button pressed */
                                              ).
        ASSIGN
            plContinue = cButton BEGINS "&Y"
            plValid = IF plContinue THEN YES ELSE NO. /* If the user does not care that the filter is not efficient, then keep validating */

    END.

    IF NOT plValid THEN RETURN.

    IF plValid AND pbttSchema.search_from <> "" OR pbttSchema.search_to <> "" THEN DO:

        CASE pbttSchema.column_datatype:
            WHEN "decimal":U OR WHEN "integer":U OR WHEN "INT64":U THEN DO:
                ASSIGN 
                    dDecimal = DECIMAL(pbttSchema.search_from)
                    dDecimal = DECIMAL(pbttSchema.search_to) NO-ERROR.

                IF  ERROR-STATUS:ERROR THEN DO:
                    ASSIGN
                        cErrorMessage = "Invalid data type for " + pbttSchema.COLUMN_label + ".  Should be " + pbttSchema.column_datatype + "."
                        plValid       = NO
                        plContinue    = NO.
                END.
                ELSE IF  pbttSchema.search_to <> "":U
                AND DECIMAL(pbttSchema.search_from) > DECIMAL(pbttSchema.search_to) THEN
                    ASSIGN
                        cErrorMessage = {af/sup2/aferrortxt.i 'AF' '33' '?' '?' "'to value'" "'the from value'"}
                        plValid       = NO
                        plContinue    = NO.
            END.

            WHEN "date":U THEN DO:
                ASSIGN 
                    tDateFrom = DATE(pbttSchema.search_from)
                    tDateTo   = DATE(pbttSchema.search_to) NO-ERROR.

                IF  ERROR-STATUS:ERROR
                OR  (tDateFrom = ? AND pbttSchema.search_from <> "")
                OR  (tDateTo = ?   AND pbttSchema.search_to   <> "":U) THEN DO:
                    ASSIGN
                        cErrorMessage = "Invalid data type for " + pbttSchema.COLUMN_label + ".  Should be " + pbttSchema.column_datatype + "."
                        plValid       = NO
                        plContinue    = NO.

                END.
                ELSE IF  pbttSchema.search_to <> "":U
                AND DATE(pbttSchema.search_from) > DATE(pbttSchema.search_to) THEN
                    ASSIGN
                        cErrorMessage = {af/sup2/aferrortxt.i 'AF' '33' '?' '?' "'to value'" "'the from value'"}
                        plValid = NO.
            END.

            WHEN "datetime":U THEN DO:
                ASSIGN 
                    tDateTimeFrom = DATETIME(pbttSchema.search_from)
                    tDateTimeTo   = DATETIME(pbttSchema.search_to) NO-ERROR.

                IF  ERROR-STATUS:ERROR
                OR  (tDateTimeFrom = ? AND pbttSchema.search_from <> "")
                OR  (tDateTimeTo = ?   AND pbttSchema.search_to   <> "":U) THEN DO:
                    ASSIGN
                        cErrorMessage = "Invalid data type for " + pbttSchema.COLUMN_label + ".  Should be " + pbttSchema.column_datatype + "."
                        plValid       = NO
                        plContinue    = NO.

                END.
                ELSE IF  pbttSchema.search_to <> "":U
                AND DATETIME(pbttSchema.search_from) > DATETIME(pbttSchema.search_to) THEN
                    ASSIGN
                        cErrorMessage = {af/sup2/aferrortxt.i 'AF' '33' '?' '?' "'to value'" "'the from value'"}
                        plValid = NO.
            END.

            WHEN "datetime-tz":U THEN DO:
                ASSIGN 
                    tDateTimeTZFrom = DATETIME-TZ(pbttSchema.search_from)
                    tDateTimeTZTo   = DATETIME-TZ(pbttSchema.search_to) NO-ERROR.

                IF  ERROR-STATUS:ERROR
                OR  (tDateTimeTZFrom = ? AND pbttSchema.search_from <> "")
                OR  (tDateTimeTZTo = ?   AND pbttSchema.search_to   <> "":U) THEN DO:
                    ASSIGN
                        cErrorMessage = "Invalid data type for " + pbttSchema.COLUMN_label + ".  Should be " + pbttSchema.column_datatype + "."
                        plValid       = NO
                        plContinue    = NO.

                END.
                ELSE IF  pbttSchema.search_to <> "":U
                AND DATETIME-TZ(pbttSchema.search_from) > DATETIME-TZ(pbttSchema.search_to) THEN
                    ASSIGN
                        cErrorMessage = {af/sup2/aferrortxt.i 'AF' '33' '?' '?' "'to value'" "'the from value'"}
                        plValid = NO.
            END.

            OTHERWISE DO: /* character, &c. */
                IF  pbttSchema.search_to <> "":U
                AND pbttSchema.search_from > pbttSchema.search_to THEN
                    ASSIGN
                        cErrorMessage = {af/sup2/aferrortxt.i 'AF' '33' '?' '?' "'to value '" "'the from value'"}
                        plValid       = NO
                        plContinue    = NO.
            END.
        END CASE.

        IF NOT plValid THEN DO:
            RUN showMessages IN gshSessionManager (INPUT  cErrorMessage,    /* messages */
                                                   INPUT  "":U,             /* type */
                                                   INPUT  "OK":U,           /* button list */
                                                   INPUT  "OK":U,           /* default */
                                                   INPUT  "OK":U,           /* cancel */
                                                   INPUT  "":U,             /* title */
                                                   INPUT  YES,              /* disp. empty */
                                                   INPUT  ?,                /* container handle */
                                                   OUTPUT cButton           /* button pressed */
                                                  ).
        END.
    END.

    IF NOT plValid THEN RETURN.

    plValid = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE viewObject wWin 
PROCEDURE viewObject :
/*------------------------------------------------------------------------------
  Purpose:     Super Override
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  /* Code placed here will execute PRIOR to standard behavior. */
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
        brFilter:ROW      = {fn getInnerRow h_afspfoldrw} + 0.24
        
        fiRowsToBatch:SIDE-LABEL-HANDLE:ROW = fiRowsToBatch:SIDE-LABEL-HANDLE:ROW
                                            + (brFilter:ROW - fiRowsToBatch:SIDE-LABEL-HANDLE:ROW)
        
        fiRowsToBatch:ROW = brFilter:ROW
        toRebuild:ROW     = fiRowsToBatch:ROW + 0.11
        fiManualQuery:ROW = fiRowsToBatch:ROW + 1.33
        edManualQuery:ROW = fiManualQuery:ROW + 0.86.
  END.
  
  FIND FIRST ttDataObject.
  IF NOT ttDataObject.tDbAware THEN 
    ASSIGN EdManualQuery:READ-ONLY = TRUE
           fiRowsToBatch:SENSITIVE = FALSE
           toRebuild:SENSITIVE     = FALSE.


  RUN SUPER.

  /* Code placed here will execute AFTER standard behavior.    */
  DO WITH FRAME {&FRAME-NAME}:
    rsPermanent:MOVE-TO-TOP().
    APPLY "entry":U TO brFilter.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION closeChildWindow wWin 
FUNCTION closeChildWindow RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  When the parent window is closed, this procedure will be run if it
            exists.  Returning a false indicates that the child window doesn't have
            to be closed with the parent window.  The filter window is only hidden,
            so we don't want to close it when the parent window closes.
    Notes:  
------------------------------------------------------------------------------*/

  RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION evaluateOuterJoins wWin 
FUNCTION evaluateOuterJoins RETURNS CHARACTER
  (pcQueryString  AS CHARACTER,
   pcFilterFields AS CHARACTER):
    
/*------------------------------------------------------------------------------
  Purpose:  Replace OUTER-JOINs in a query with '' if filter criteria is specified
            on fields of the OUTER-JOINed buffers

    Notes: DEPRECATED - only called from evaluateQueryString, which is not in use here, but
           replaced by logic in adm2.
           Will still work as before, but this removes all outer-joins for subsequent tables
           after removing one. This is wrong if a lower table in the query has a parent 
           higher in the query.
           adm2 will only remove it from the table that has an expression
           adm2 will also add it back when the expression is removed        
           
        -  This function passes the request on to the session manager.
------------------------------------------------------------------------------*/

IF VALID-HANDLE(gshSessionManager) THEN
    RETURN DYNAMIC-FUNCTION("filterEvaluateOuterJoins":U IN gshSessionManager, INPUT pcQueryString, INPUT pcFilterFields).
ELSE
    RETURN pcQueryString.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION evaluateQueryString wWin 
FUNCTION evaluateQueryString RETURNS LOGICAL
  ( INPUT phSdoHandle       AS HANDLE,
    INPUT pcFieldNames      AS CHARACTER ):
/*------------------------------------------------------------------------------
  Purpose:  See if a query has OUTER-JOINed buffers. If it has and criteria
            was specified on these OUTER-JOINed buffers, ammend the query string
            to make the reference to the buffer INNER-JOINed
    Notes: DEPRECATED - not in use here. replaced by logic in adm2.     
           Will still work as before, but this removes all outer-joins for subsequent tables
           after removing one. This is wrong if a lower table in the query has a parent 
           higher in the query.
           adm2 will only remove it from the table that has an expression
           adm2 will also add it back when the expression is removed        
  ------------------------------------------------------------------------------*/
    DEFINE VARIABLE cQueryString  AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cFieldNames   AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE iCounter      AS INTEGER    NO-UNDO.
    DEFINE VARIABLE lSuccess      AS LOGICAL    NO-UNDO.

    /* Initialize the RETURN-VALUE */
    ASSIGN lSuccess = FALSE.
    
    /* Get the original query string */
    {get QueryString cQueryString phSdoHandle}.

    IF INDEX(cQueryString, "OUTER-JOIN":U) <> 0 THEN
    DO:
        /* Get the table-name appended to the field-name */
        DO iCounter = 1 TO NUM-ENTRIES(pcFieldNames):
            FIND FIRST ttSchema WHERE
                       ttSchema.sdo_handle  = phSdoHandle AND
                       ttSchema.column_name = ENTRY(iCounter, pcFieldNames)
                       NO-ERROR.

            IF AVAILABLE ttSchema THEN
                ASSIGN cFieldNames = cFieldNames + (IF TRIM(cFieldNames) = "":U THEN "":U ELSE ",":U) + ttSchema.table_name + ".":U + ENTRY(iCounter, pcFieldNames).    
        END.

        IF cFieldNames <> "":U THEN cFieldNames = cFieldNames + ",gsm_account.account_obj".

        /* See whether criteria was specified on OUTER-JOINed tables and ammend the query string accordingly */
        ASSIGN cQueryString = DYNAMIC-FUNCTION("evaluateOuterJoins":U, cQueryString, cFieldNames).

        /* Set the modified query string in the SDO */
        ASSIGN lSuccess = DYNAMIC-FUNCTION("setQueryString" IN phSdoHandle, cQueryString).
    END.
    ELSE
        ASSIGN lSuccess = TRUE.
    
    RETURN lSuccess.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUpdateActive wWin 
FUNCTION getUpdateActive RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Lie to the ok and cancel, so they become visible 
    Notes:  
------------------------------------------------------------------------------*/

  RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getWindowName wWin 
FUNCTION getWindowName RETURNS CHARACTER
    ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the name of this window.
    Notes:  * This is a placeholder funciton so that security can be applied
              to this window.
------------------------------------------------------------------------------*/
    RETURN "Filter Window":U.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

