&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
  File: chart-ocx.w
  Description: Charting demo routine for
               Microsoft Chart Control version 5.00.00
               By Visual Components, Inc.
  By: Kwang-Hang Koh
      Gintic Institute of Manufacturing Technology
      Singapore
  Date: October 1997
------------------------------------------------------------------------*/
CREATE WIDGET-POOL.

DEF VAR i-cnt1   AS I NO-UNDO.
DEF VAR i-cnt2   AS I NO-UNDO.
DEF VAR i-type   AS I EXTENT 12 NO-UNDO 
  INITIAL [0,1,2,3,4,5,6,7,8,9,14,16] . /* map available chart-types nos. */
DEF VAR ch-chart AS COM-HANDLE NO-UNDO.

DEFINE TEMP-TABLE tt_charttable
    FIELD tt_column AS CHARACTER
    FIELD tt_data   AS CHARACTER
    FIELD tt_quantity AS INTEGER
    INDEX tx_type AS PRIMARY UNIQUE tt_column tt_data.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS co_column co_charttype 
&Scoped-Define DISPLAYED-OBJECTS co_column co_charttype 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of handles for OCX Containers                            */
DEFINE VARIABLE MSChart AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE chMSChart AS COMPONENT-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE co_charttype AS CHARACTER FORMAT "X(20)":U 
     LABEL "Chart Type" 
     VIEW-AS COMBO-BOX INNER-LINES 8
     LIST-ITEMS "3DBar","2DBar","3DLine","2DLine","3DArea","2DArea","3DStep","2DStep","3DCombination","2DCombination","2DPie","2DXY" 
     DROP-DOWN-LIST
     SIZE 25 BY 1 TOOLTIP "Change chart type" NO-UNDO.

DEFINE VARIABLE co_column AS CHARACTER FORMAT "X(20)":U 
     LABEL "Column" 
     VIEW-AS COMBO-BOX INNER-LINES 8
     DROP-DOWN-LIST
     SIZE 38.2 BY 1 TOOLTIP "Change chart type" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     co_column AT ROW 1 COL 7.6 COLON-ALIGNED
     co_charttype AT ROW 1 COL 57.8 COLON-ALIGNED
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 158 BY 28.1.


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
         TITLE              = "MSChart OCX Demo"
         HEIGHT             = 28.1
         WIDTH              = 158
         MAX-HEIGHT         = 28.1
         MAX-WIDTH          = 158
         VIRTUAL-HEIGHT     = 28.1
         VIRTUAL-WIDTH      = 158
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
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 


/* **********************  Create OCX Containers  ********************** */

&ANALYZE-SUSPEND _CREATE-DYNAMIC

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN

CREATE CONTROL-FRAME MSChart ASSIGN
       FRAME           = FRAME DEFAULT-FRAME:HANDLE
       ROW             = 2.14
       COLUMN          = 1
       HEIGHT          = 26.95
       WIDTH           = 158
       HIDDEN          = no
       SENSITIVE       = yes.
      MSChart:NAME = "MSChart":U .
/* MSChart OCXINFO:CREATE-CONTROL from: {31291E80-728C-11CF-93D5-0020AF99504A} type: MSChart */
      MSChart:MOVE-AFTER(co_charttype:HANDLE IN FRAME DEFAULT-FRAME).

&ENDIF

&ANALYZE-RESUME /* End of _CREATE-DYNAMIC */


/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* MSChart OCX Demo */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* MSChart OCX Demo */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME co_charttype
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL co_charttype C-Win
ON VALUE-CHANGED OF co_charttype IN FRAME DEFAULT-FRAME /* Chart Type */
DO:
  IF co_charttype <> co_charttype:SCREEN-VALUE THEN DO:
    ASSIGN co_charttype
           ch-chart:ChartType = i-type[co_charttype:LOOKUP(co_charttype)].
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME co_column
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL co_column C-Win
ON VALUE-CHANGED OF co_column IN FRAME DEFAULT-FRAME /* Column */
DO:

    RUN mip-set-value (co_column:SCREEN-VALUE).

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

PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  ASSIGN 
    co_charttype = co_charttype:ENTRY(1).
  RUN enable_UI.

  ASSIGN 
    ch-chart = chMSChart:Controls:Item(1)
    ch-chart:charttype   = 0.

  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE control_load C-Win  _CONTROL-LOAD
PROCEDURE control_load :
/*------------------------------------------------------------------------------
  Purpose:     Load the OCXs    
  Parameters:  <none>
  Notes:       Here we load, initialize and make visible the 
               OCXs in the interface.                        
------------------------------------------------------------------------------*/

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN
DEFINE VARIABLE UIB_S    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE OCXFile  AS CHARACTER  NO-UNDO.

OCXFile = SEARCH( "afchartfxd.wrx":U ).
IF OCXFile = ? THEN
  OCXFile = SEARCH(SUBSTRING(THIS-PROCEDURE:FILE-NAME, 1,
                     R-INDEX(THIS-PROCEDURE:FILE-NAME, ".":U), "CHARACTER":U) + "wrx":U).

IF OCXFile <> ? THEN
DO:
  ASSIGN
    chMSChart = MSChart:COM-HANDLE
    UIB_S = chMSChart:LoadControls( OCXFile, "MSChart":U)
  .
  RUN initialize-controls IN THIS-PROCEDURE NO-ERROR.
END.
ELSE MESSAGE "afchartfxd.wrx":U SKIP(1)
             "The binary control file could not be found. The controls cannot be loaded."
             VIEW-AS ALERT-BOX TITLE "Controls Not Loaded".

&ENDIF

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
  RUN control_load.
  DISPLAY co_column co_charttype 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE co_column co_charttype 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mip-populate-combo-boxes C-Win 
PROCEDURE mip-populate-combo-boxes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DO WITH FRAME {&FRAME-NAME}:

        FOR EACH tt_charttable
            BREAK BY tt_charttable.tt_column:
            IF FIRST-OF(tt_charttable.tt_column)
            THEN
                co_column:ADD-LAST(tt_charttable.tt_column).
        END.

        ASSIGN
            co_column:SCREEN-VALUE = ENTRY(1,co_column:LIST-ITEMS).
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mip-set-value C-Win 
PROCEDURE mip-set-value :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER ip_column AS CHARACTER NO-UNDO.

    DEFINE VARIABLE lv_count AS INTEGER NO-UNDO.

    FOR EACH tt_charttable 
        WHERE tt_charttable.tt_column = ip_column NO-LOCK:
        ASSIGN
            lv_count = lv_count + 1.
    END.

    ASSIGN
        ch-chart:RowCount    = 1
        ch-chart:ColumnCount = lv_count
        lv_count             = 0.

    FOR EACH tt_charttable 
        WHERE tt_charttable.tt_column = ip_column NO-LOCK:
        ASSIGN
            lv_count             = lv_count + 1
            ch-chart:Column      = lv_count
            ch-chart:Data        = tt_charttable.tt_quantity
            ch-chart:ColumnLabel = tt_charttable.tt_data.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

