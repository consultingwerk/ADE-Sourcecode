&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: _tabedit.w 

  Description: This is the code for the tab editor dialog box. It's called
               from the property sheet for the frame, via _prpobj.w.

  Input Parameters: frame-recid - the recid of the frame selected for 
                                  tab editing.

  Output Parameters:
      <none>

  Author:  Patrick Leach

  Created: 10/30/95
  
  Modified on 02/10/98 GFS Exclude widgets with NO-TAB-STOP set.
  
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
&GLOBAL-DEFINE WIN95-BTN YES

{adeuib/uniwidg.i}
{adeuib/sharvars.i}
{adeuib/layout.i}

/* Parameters Definitions ---                                           */

DEFINE INPUT PARAMETER frame-recid AS RECID NO-UNDO.

/* Local Variable Definitions ---                                       */

DEFINE TEMP-TABLE _TAB NO-UNDO
    FIELD  _objRECID    AS RECID
    FIELD  _objNAME     AS CHAR FORMAT "X(32)":U LABEL "Object"
    FIELD  _objPage     AS CHAR FORMAT "x(3)"  LABEL "Page"
    FIELD  _objTABORDER AS INTEGER
  INDEX _objTABORDER IS UNIQUE PRIMARY _objTABORDER.
  
DEFINE BUFFER _X_TAB FOR _TAB. /* used for creating the temp-table entries */
                               /* and for manipulating the entries in the  */
                               /* browser.                                 */
DEFINE BUFFER w_U FOR _U. /* used for tabbable widget NOT parent frame     */
DEFINE BUFFER t_P FOR _P.

DEFINE VARIABLE cur-rec   AS RECID NO-UNDO. /* to manipulate the browse entries */
DEFINE VARIABLE first-rec AS RECID INITIAL ? NO-UNDO.
DEFINE VARIABLE last-rec  AS RECID INITIAL ? NO-UNDO.
DEFINE VARIABLE saved-rec AS RECID NO-UNDO.

DEFINE VARIABLE hBrowse       AS HANDLE  NO-UNDO.
DEFINE VARIABLE i             AS INTEGER NO-UNDO.
DEFINE VARIABLE j             AS INTEGER NO-UNDO.
DEFINE VARIABLE lShowLabels   AS LOGICAL NO-UNDO.
DEFINE VARIABLE num-objs      AS INTEGER NO-UNDO.
DEFINE VARIABLE temp-taborder AS INTEGER NO-UNDO.
DEFINE VARIABLE dummy         AS LOGICAL NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame
&Scoped-define BROWSE-NAME tab-browse

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES _TAB

/* Definitions for BROWSE tab-browse                                    */
&Scoped-define FIELDS-IN-QUERY-tab-browse _TAB._objNAME _TAB._objPage   
&Scoped-define ENABLED-FIELDS-IN-QUERY-tab-browse   
&Scoped-define SELF-NAME tab-browse
&Scoped-define QUERY-STRING-tab-browse FOR EACH _TAB BY _TAB._objTABORDER
&Scoped-define OPEN-QUERY-tab-browse OPEN QUERY tab-browse FOR EACH _TAB BY _TAB._objTABORDER.
&Scoped-define TABLES-IN-QUERY-tab-browse _TAB
&Scoped-define FIRST-TABLE-IN-QUERY-tab-browse _TAB


/* Definitions for DIALOG-BOX Dialog-Frame                              */
&Scoped-define OPEN-BROWSERS-IN-QUERY-Dialog-Frame ~
    ~{&OPEN-QUERY-tab-browse}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tab_options_cb tab-browse tab-label 
&Scoped-Define DISPLAYED-OBJECTS tab_options_cb tab-label 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON btn-movedown 
     LABEL "Move &Down" 
     SIZE 15 BY 1.14.

DEFINE BUTTON btn-movefirst 
     LABEL "Move &First" 
     SIZE 15 BY 1.14.

DEFINE BUTTON btn-movelast 
     LABEL "Move &Last" 
     SIZE 15 BY 1.14.

DEFINE BUTTON btn-moveup 
     LABEL "Move &Up" 
     SIZE 15 BY 1.14.

DEFINE VARIABLE tab_options_cb AS CHARACTER FORMAT "X(25)":U INITIAL "Default" 
     LABEL "Tabbing &Options" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Default","Custom","Left-To-Right By Columns","Left-To-Right By Rows","Right-To-Left By Columns","Right-To-Left By Rows" 
     DROP-DOWN-LIST
     SIZE 30 BY 1 NO-UNDO.

DEFINE VARIABLE tab-label AS CHARACTER FORMAT "X(50)":U INITIAL "  Tabbable Objects in" 
      VIEW-AS TEXT 
     SIZE 55 BY .81
     BGCOLOR 1 FGCOLOR 15  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY tab-browse FOR 
      _TAB SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE tab-browse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS tab-browse Dialog-Frame _FREEFORM
  QUERY tab-browse NO-LOCK DISPLAY
      _TAB._objNAME _TAB._objPage
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-LABELS NO-COLUMN-SCROLLING SIZE 39 BY 9.14 NO-EMPTY-SPACE.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     tab_options_cb AT ROW 1.81 COL 18 COLON-ALIGNED
     tab-browse AT ROW 5.05 COL 3
     btn-movefirst AT ROW 6.67 COL 44
     btn-moveup AT ROW 8 COL 44
     btn-movedown AT ROW 9.33 COL 44
     btn-movelast AT ROW 10.67 COL 44
     tab-label AT ROW 3.67 COL 3 NO-LABEL
     SPACE(1.00) SKIP(9.78)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Tab Editor -".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Compile into: 
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
   L-To-R                                                               */
/* BROWSE-TAB tab-browse tab_options_cb Dialog-Frame */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON btn-movedown IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON btn-movefirst IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON btn-movelast IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON btn-moveup IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tab-label IN FRAME Dialog-Frame
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE tab-browse
/* Query rebuild information for BROWSE tab-browse
     _START_FREEFORM
OPEN QUERY tab-browse FOR EACH _TAB BY _TAB._objTABORDER.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE tab-browse */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Tab Editor - */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-movedown
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-movedown Dialog-Frame
ON CHOOSE OF btn-movedown IN FRAME Dialog-Frame /* Move Down */
DO:
  DEFINE VARIABLE iRow AS INTEGER    NO-UNDO.
  
  ASSIGN cur-rec = RECID (_TAB)
         i       = _TAB._objTABORDER
         iRow    = tab-browse:focused-row.

  FIND _X_TAB WHERE _X_TAB._objTABORDER = i + 1 NO-ERROR. /* get next entry */

  IF AVAILABLE _X_TAB THEN DO:
    ASSIGN temp-taborder       = _TAB._objTABORDER
           _TAB._objTABORDER   = _X_TAB._objTABORDER
           _X_TAB._objTABORDER = temp-taborder.

    /* Update the taborder field for the _U's */
    RUN update_U.

    tab-browse:MAX-DATA-GUESS IN FRAME {&FRAME-NAME} = num-objs.
    {&OPEN-QUERY-tab-browse}

    tab-browse:SET-REPOSITIONED-ROW(MIN(tab-browse:DOWN, iRow + 1),"ALWAYS").
    REPOSITION tab-browse TO RECID cur-rec.
    
    ASSIGN dummy   = tab-browse:SELECT-FOCUSED-ROW ()
           cur-rec = RECID (_TAB).
    
    IF RECID (_X_TAB) = last-rec THEN 
      last-rec = RECID (_TAB).
       
    IF RECID (_TAB) = first-rec THEN
      first-rec = RECID (_X_TAB).

    RUN update-buttons ('ENABLED':U).

  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-movefirst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-movefirst Dialog-Frame
ON CHOOSE OF btn-movefirst IN FRAME Dialog-Frame /* Move First */
DO:
  /* Save off the recid of the one being   */
  /* moved to the first position for later */
  /* reference.                            */
  ASSIGN i                 = _TAB._objTABORDER
         saved-rec         = RECID (_TAB)
         _TAB._objTABORDER = ?.
  
  /* Iterate through each of the _TABs that have */
  /* a sequence number less than the _TAB with   */
  /* focus. Do in descending order.              */
  j = i.
  FOR EACH _TAB WHERE _TAB._objTABORDER < i BY _TAB._objTABORDER DESCENDING:
    ASSIGN _TAB._objTABORDER = j
           j = j - 1.

    /* Update the _U record for this _TAB. */
    FIND w_U WHERE RECID (w_U) = _TAB._objRECID.
    w_U._TAB-ORDER = _TAB._objTABORDER.
  END.

  /* Find the _TAB that was selected, and */
  /* set its taborder and sequence to 1   */
  /* since it's now first. Update the _U  */
  /* as well.                             */  
  FIND _TAB WHERE RECID (_TAB) = saved-rec.
  _TAB._objTABORDER = 1.
  FIND w_U WHERE RECID (w_U) = _TAB._objRECID.
  w_U._TAB-ORDER = _TAB._objTABORDER.

  tab-browse:MAX-DATA-GUESS IN FRAME {&FRAME-NAME} = num-objs.
  {&OPEN-QUERY-tab-browse}

  /* Init cur-rec, buttons, etc. */
  RUN init-record-vars.
  RUN update-buttons ('ENABLED':U).  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-movelast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-movelast Dialog-Frame
ON CHOOSE OF btn-movelast IN FRAME Dialog-Frame /* Move Last */
DO:
  /* Save off the recid of the one being   */
  /* moved to the first position for later */
  /* reference.                            */
  ASSIGN i                 = _TAB._objTABORDER
         saved-rec         = RECID (_TAB)
         _TAB._objTABORDER = ?.
  
  /* Iterate through each of the _TABs that have */
  /* a sequence number less than the _TAB with   */
  /* focus. Do in ascending order.               */
  j = i.
  FOR EACH _TAB WHERE _TAB._objTABORDER > i:
    ASSIGN _TAB._objTABORDER = j
           j = j + 1.

    /* Update the _U record for this _TAB. */
    FIND w_U WHERE RECID (w_U) = _TAB._objRECID.
    w_U._TAB-ORDER = _TAB._objTABORDER.
  END.

  /* Find the _TAB that was selected, and */
  /* set its taborder and sequence to the */
  /* number of _TABs created at startup.  */
  /* Update _U as well with new taborder. */  
  FIND _TAB WHERE RECID (_TAB) = saved-rec.
  _TAB._objTABORDER = num-objs.
  FIND w_U WHERE RECID (w_U) = _TAB._objRECID.
  w_U._TAB-ORDER = _TAB._objTABORDER.

  tab-browse:MAX-DATA-GUESS IN FRAME {&FRAME-NAME} = num-objs.
  {&OPEN-QUERY-tab-browse}
  tab-browse:SET-REPOSITIONED-ROW(tab-browse:DOWN, "ALWAYS").

  REPOSITION tab-browse TO RECID saved-rec.
  dummy = tab-browse:SELECT-FOCUSED-ROW ().

  /* Init cur-rec, buttons, etc. */
  FIND FIRST _TAB NO-ERROR.
  IF AVAILABLE _TAB THEN
    first-rec = RECID (_TAB).
  FIND LAST _TAB NO-ERROR.
  ASSIGN last-rec = RECID (_TAB)
         cur-rec  = last-rec.
  RUN update-buttons ('ENABLED':U).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn-moveup
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn-moveup Dialog-Frame
ON CHOOSE OF btn-moveup IN FRAME Dialog-Frame /* Move Up */
DO:
  DEFINE VARIABLE iRow AS INTEGER    NO-UNDO.

  ASSIGN cur-rec = RECID (_TAB)
         i       = _TAB._objTABORDER
         iRow    = tab-browse:FOCUSED-ROW.

  FIND _X_TAB WHERE _X_TAB._objTABORDER = i - 1 NO-ERROR. /* get previous entry */

  IF AVAILABLE _X_TAB THEN DO:
    ASSIGN temp-taborder       = _TAB._objTABORDER
           _TAB._objTABORDER   = _X_TAB._objTABORDER
           _X_TAB._objTABORDER = temp-taborder.
           
    /* Update the taborder field for the _U's */
    RUN update_U.

    tab-browse:MAX-DATA-GUESS IN FRAME {&FRAME-NAME} = num-objs.
    {&OPEN-QUERY-tab-browse}
   
    tab-browse:SET-REPOSITIONED-ROW (MAX(1, iRow - 1),"ALWAYS").
    REPOSITION tab-browse TO RECID cur-rec.
    
    ASSIGN dummy   = tab-browse:SELECT-FOCUSED-ROW ()
           cur-rec = RECID (_TAB).
    
    IF RECID (_X_TAB) = first-rec THEN
      first-rec = RECID (_TAB).
    
    IF RECID (_TAB) = last-rec THEN
      last-rec = RECID (_X_TAB).

    RUN update-buttons ('ENABLED':U).

  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME tab-browse
&Scoped-define SELF-NAME tab-browse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tab-browse Dialog-Frame
ON VALUE-CHANGED OF tab-browse IN FRAME Dialog-Frame
DO:
  cur-rec = RECID (_TAB).
  IF tab_options_cb:SCREEN-VALUE = "Custom":U THEN
    RUN update-buttons ('ENABLED').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tab_options_cb
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tab_options_cb Dialog-Frame
ON VALUE-CHANGED OF tab_options_cb IN FRAME Dialog-Frame /* Tabbing Options */
DO:
  
  /* Set _C._tabbing so that it has the current value of the combo box */

  IF tab_options_cb:SCREEN-VALUE = "Left-To-Right By Columns":U THEN
    _C._tabbing = "L-To-R,COLUMNS":U.
  ELSE IF tab_options_cb:SCREEN-VALUE = "Left-To-Right By Rows":U THEN
    _C._tabbing = "L-To-R":U.
  ELSE IF tab_options_cb:SCREEN-VALUE = "Right-To-Left By Columns":U THEN
    _C._tabbing = "R-To-L,COLUMNS":U.
  ELSE IF tab_options_cb:SCREEN-VALUE = "Right-To-Left By Rows":U THEN
    _C._tabbing = "R-To-L":U.
  ELSE IF tab_options_cb:SCREEN-VALUE = "Custom":U THEN
    _C._tabbing = "Custom":U.
  ELSE 
    _C._tabbing = "Default":U.

  RUN load-tab-table.
  
  IF tab_options_cb:SCREEN-VALUE = "Custom":U THEN DO:
    RUN init-record-vars.
    RUN update-buttons ("ENABLED":U).
  END.
  ELSE
    RUN update-buttons ("DISABLED":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


{adeuib/uibhlp.i}
{adecomm/okbar.i &TOOL = "AB"
                 &CONTEXT = {&Tab_Editor_Dlg_Box}}       

/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Get the _C record of the frame. */
FIND _U WHERE RECID(_U) eq frame-recid.
FIND _C WHERE RECID(_C) eq _U._x-recid.

/* Get handle of the browse to adjust columns and labels */
hBrowse        = tab-browse:HANDLE IN FRAME {&FRAME-NAME}.


IF VALID-HANDLE(_h_win) THEN DO:
  FIND t_P WHERE t_P._WINDOW-HANDLE = _h_win NO-ERROR.
  IF AVAILABLE t_P AND CAN-DO (t_P._links, "PAGE-TARGET") THEN lShowLabels = YES.
END.  /* If valid handle (_h_win) */
IF lShowLabels THEN
  ASSIGN hBrowse:LABELS = TRUE
         hBrowse        = hbrowse:FIRST-COLUMN
         hBrowse:WIDTH  = 28
         hBrowse:LABEL  = "Object"
         hBrowse        = hBrowse:NEXT-COLUMN
         hBrowse:LABEL  = "Page".
ELSE
  ASSIGN hBrowse        = hbrowse:FIRST-COLUMN
         hBrowse        = hBrowse:NEXT-COLUMN
         hBrowse:WIDTH-PIXELS  = 1.


/* What is the current tabbing order? */

/* Note: in v8.1A BETA, the tabbing order was incorrectly written out as
   "L-to-R, COLUMNS" (with a space).  Remove any of these spaces. */
_C._tabbing = REPLACE (_C._tabbing, ", COLUMNS", ",COLUMNS").

tab_options_cb:SCREEN-VALUE = IF _C._tabbing = "L-To-R,COLUMNS":U THEN
                                "Left-To-Right By Columns":U
                              ELSE IF _C._tabbing = "R-To-L,COLUMNS":U THEN
                                "Right-To-Left By Columns":U
                              ELSE IF _C._tabbing = "L-To-R":U THEN
                                "Left-To-Right By Rows":U
                              ELSE IF _C._tabbing = "R-TO-L":U THEN
                                "Right-To-Left By Rows":U
                              ELSE IF _C._tabbing = "Custom":U THEN
                                "Custom":U
                              ELSE
                                "Default":U.

/* Combo boxes need an assign to move the screen-value into the */
/* record buffer. Without this ASSIGN, the value is remembered  */
/* each time the tab editor is displayed.                       */

ASSIGN tab_options_cb.

RUN load-tab-table.
RUN init-record-vars.
  
/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO TRANSACTION ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
             ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  FRAME {&FRAME-NAME}:WIDTH = 5 + tab-label:WIDTH. 
  RUN enable_UI.

  /* Turn on the buttons and the browser, if CUSTOM. */
  IF tab_options_cb:SCREEN-VALUE = "CUSTOM":U THEN
    RUN update-buttons ('ENABLED':U).

  /* Set the separator (above the browse) with the name */
  /* of the selected frame.                             */
  ASSIGN tab-label:SCREEN-VALUE = "  Tabbable Objects in " + _U._NAME
         FRAME {&FRAME-NAME}:TITLE  = "Tab Editor - " + _U._NAME.

  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
  RUN adeuib/_winsave.p (_U._WINDOW-HANDLE, FALSE).
END.

RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Dialog-Frame  _DEFAULT-DISABLE
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
  HIDE FRAME Dialog-Frame.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Dialog-Frame  _DEFAULT-ENABLE
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
  DISPLAY tab_options_cb tab-label 
      WITH FRAME Dialog-Frame.
  ENABLE tab_options_cb tab-browse tab-label 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE init-record-vars Dialog-Frame 
PROCEDURE init-record-vars :
/*------------------------------------------------------------------------------
  Purpose: Initialize the first, last, and current records. This routine 
           must be called anytime the tabbing option is changed to CUSTOM.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Find the last first, and first last so that */
  /* _TAB is at first record whenever CUSTOM is  */
  /* selected.                                   */
  
  FIND LAST _TAB NO-ERROR.
  IF AVAILABLE _TAB THEN last-rec = RECID (_TAB).

  FIND FIRST _TAB NO-ERROR.
  IF AVAILABLE _TAB THEN
    ASSIGN first-rec = RECID (_TAB)
           cur-rec   = first-rec.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE load-tab-table Dialog-Frame 
PROCEDURE load-tab-table :
/*------------------------------------------------------------------------------
  Purpose: fills the tab temp-table with the tabable objects according to
           the specified tab order.
  Parameters: <none>
  Notes:       
------------------------------------------------------------------------------*/

/* First, delete the old _TAB temptable */

FOR EACH _TAB:
  DELETE _TAB.
END.

/* Next, re-order the objects, according to the */
/* the order string passed in.                  */
IF _C._tabbing <> "CUSTOM":U THEN
  RUN adeuib/_tabordr.p (INPUT 'NORMAL':U, INPUT frame-recid).

/* Finally, create the _TAB temptable, and then */
/* open the query.                              */          
num-objs = 0.
for-each-widget:
FOR EACH w_U WHERE w_U._PARENT-RECID = frame-recid
            AND w_U._STATUS eq 'NORMAL':U
            AND RECID(w_U) ne frame-recid /* Dialog-boxes are their own parent. */
            AND NOT CAN-DO('QUERY,TEXT,IMAGE,RECTANGLE,LABEL':U,
                            w_U._TYPE)
            AND NOT w_U._NO-TAB-STOP /* Do not include widgets with NO-TAB-STOP set */
            BY w_U._TAB-ORDER:
  IF w_U._TYPE = "SmartObject":U THEN DO:
    FIND _S WHERE RECID(_S) eq w_U._x-recid /* AND _s._page-number eq 0 */ NO-ERROR.
    IF NOT AVAILABLE _S THEN NEXT for-each-widget.
    IF NOT _S._VISUAL THEN NEXT for-each-widget.
  END.
  IF w_U._TYPE = "BUTTON" THEN DO:
    FIND _L WHERE _L._u-recid = RECID(w_U) AND _L._LO-NAME = "Master Layout":U.
    IF _L._NO-FOCUS THEN NEXT for-each-widget.
  END.
  IF w_U._TYPE = "FILL-IN":U AND w_U._SUBTYPE = "TEXT":U THEN NEXT for-each-widget.
  CREATE _TAB.
  ASSIGN num-objs          = num-objs + 1
         _TAB._objRECID    = RECID (w_U)
         _TAB._objTABORDER = num-objs
         w_U._TAB-ORDER    = num-objs.
  IF AVAILABLE _S THEN _TAB._objPage = string(_S._page-number).
  IF lShowLabels AND _TAB._objPage = "":U THEN _TAB._objPage = "0":U.
  IF NOT lShowLabels AND _TAB._objPage = "0":U THEN _TAB._objPage = "":U.

  IF _U._DBNAME <> ? THEN
    _TAB._objNAME = w_U._TABLE + "." + w_U._NAME.
  ELSE
    _TAB._objNAME = w_U._NAME.

  IF _C._tabbing = "CUSTOM":U THEN
    _U._TAB-ORDER = _TAB._objTABORDER.
END.

tab-browse:MAX-DATA-GUESS IN FRAME {&FRAME-NAME} = num-objs.
{&OPEN-QUERY-tab-browse}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE update-buttons Dialog-Frame 
PROCEDURE update-buttons :
/*------------------------------------------------------------------------------
  Purpose: Set the sensitivity of the move buttons and the browser.
  Parameters: btn-states - either "ENABLED" or "DISABLED".
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER btn-states AS CHAR NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
  IF btn-states = "ENABLED":U THEN
    ASSIGN btn-movefirst:SENSITIVE = (cur-rec <> first-rec)
           btn-moveup:SENSITIVE    = btn-movefirst:SENSITIVE
           btn-movedown:SENSITIVE  = (cur-rec <> last-rec)
           btn-movelast:SENSITIVE  = btn-movedown:SENSITIVE.
  ELSE
    ASSIGN btn-movefirst:SENSITIVE = NO
           btn-moveup:SENSITIVE    = NO
           btn-movedown:SENSITIVE  = NO
           btn-movelast:SENSITIVE  = NO.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE update_U Dialog-Frame 
PROCEDURE update_U :
/*------------------------------------------------------------------------------
  Purpose: Update the _U records with the taborder values stored in
           _TAB and _X_TAB buffers.     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
  FIND w_U WHERE RECID (w_U) = _TAB._objRECID.
  w_U._TAB-ORDER = _TAB._objTABORDER.
  FIND w_U WHERE RECID (w_U) = _X_TAB._objRECID.
  w_U._TAB-ORDER = _X_TAB._objTABORDER.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

