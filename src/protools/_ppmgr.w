&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: _ppmgr.w

  Description: Creates a TEMP-TABLE of all the persistent-procedures
               (SESSION:FIRST-PROCEDURE) in this PROGRESS Session and 
               lets the user:
                   a) APPLY "CLOSE"
                   b) DELETE PROCEDURE
                   c) View Internal Entries  

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: William T. Wood

  Created: July 6, 1994
   
  Modified by: Gerry Seidl - UI redone and logic fixed up
                           - handle DISPATCH.
                           - changed from dialog-box to window,
                             added menubar, view filter and adapted
                             freeform query.
                           - Added display of DB-REFs and Params of IPs 
        GFS 06/19/98 - Correctly handle Functions and v9 smartobjects.
        GFS 08/06/98 - Fix UIB-MODE, SmartInfo for V9 and allow a user to
                       execute a function with no parameters.
        GFS 02/04/99 - Added Super procedures
        JEP 10/20/99 - Check for ADEPersistent first, then SmartObject
                       design mode.
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/
CREATE WIDGET-POOL.

{ protools/ptlshlp.i } /* help definitions */
{ adecomm/_adetool.i }
{ protools/_runonce.i }
/* ***************************  Definitions  ************************** */

/* Local Definitions ---                                           */
DEFINE TEMP-TABLE pp
    FIELD pHandle    AS WIDGET-HANDLE
    FIELD cFileName  AS CHARACTER     FORMAT "X(256)":U LABEL "Title"
    FIELD ptype      AS INTEGER
    INDEX cFileName  IS PRIMARY cFileName  
    .

&IF "{&WINDOW-SYSTEM}" EQ "OSF/MOTIF" &THEN
  DEFINE TEMP-TABLE sort-ie /* used to sort internal entries on Motif */
    FIELD ie AS CHAR
    INDEX ie IS PRIMARY ie.
&ENDIF
    
DEFINE VAR h             AS WIDGET-HANDLE NO-UNDO.
DEFINE VAR ldummy        AS LOGICAL NO-UNDO.
DEFINE VAR isSmartObject AS LOGICAL NO-UNDO.

/* Shared Definitions ---                                               */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME browser_pp

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES pp

/* Definitions for BROWSE browser_pp                                    */
&Scoped-define FIELDS-IN-QUERY-browser_pp pp.cFileName WITH NO-LABELS   
&Scoped-define ENABLED-FIELDS-IN-QUERY-browser_pp   
&Scoped-define SELF-NAME browser_pp
&Scoped-define OPEN-QUERY-browser_pp OPEN QUERY browser_pp FOR EACH pp.
&Scoped-define TABLES-IN-QUERY-browser_pp pp
&Scoped-define FIRST-TABLE-IN-QUERY-browser_pp pp


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS browser_pp Btn_Close Btn_Delete int-entries ~
Btn_Run_In paramlist dbrefs superProcs RECT-1 RECT-2 r_intent r_objects 
&Scoped-Define DISPLAYED-OBJECTS int-entries paramlist dbrefs uid ~
superProcs lbl_po lbl_ie 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU m_File 
       MENU-ITEM m_Exit         LABEL "E&xit"         .

DEFINE SUB-MENU m_View 
       MENU-ITEM m_Refresh      LABEL "&Refresh List of Procedure Objects"
       RULE
       MENU-ITEM m_Hide_UIB     LABEL "Hide &UIB-Mode Objects"
              TOGGLE-BOX
       MENU-ITEM m_Hide_ADE     LABEL "Hide ADE &Procedures"
              TOGGLE-BOX.

DEFINE SUB-MENU m_Help 
       MENU-ITEM m_Help_Topics  LABEL "&Help Topics"  
       MENU-ITEM m_Contents     LABEL "&Procedure Object Viewer Help" ACCELERATOR "F1"
       RULE
       MENU-ITEM m_About        LABEL "&About Procedure Object Viewer".

DEFINE MENU MENU-BAR-C-Win MENUBAR
       SUB-MENU  m_File         LABEL "&File"         
       SUB-MENU  m_View         LABEL "&View"         
       SUB-MENU  m_Help         LABEL "&Help"         .


/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Close 
     LABEL "&Apply  ~"Close~"":L 
     SIZE 16 BY 1.

DEFINE BUTTON Btn_Delete 
     LABEL "&Delete":L 
     SIZE 9 BY 1.

DEFINE BUTTON Btn_Run_In 
     LABEL "&RUN Entry":L 
     SIZE 13 BY 1.

DEFINE BUTTON b_smartinfo 
     LABEL "Smart&Info...":L 
     SIZE 12 BY 1.

DEFINE VARIABLE lbl_ie AS CHARACTER FORMAT "X(256)":U INITIAL " Internal Entries" 
      VIEW-AS TEXT 
     SIZE 12 BY .62 NO-UNDO.

DEFINE VARIABLE lbl_po AS CHARACTER FORMAT "X(256)":U INITIAL " Procedure Objects" 
      VIEW-AS TEXT 
     SIZE 16 BY .62 NO-UNDO.

DEFINE VARIABLE uid AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 29 BY .81 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 40 BY 5.95.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 40 BY 7.14.

DEFINE RECTANGLE r_intent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 40 BY 14.48.

DEFINE RECTANGLE r_objects
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 39 BY 14.48.

DEFINE VARIABLE dbrefs AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL 
     SIZE 38 BY 5.24 NO-UNDO.

DEFINE VARIABLE int-entries AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE SORT 
     SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL 
     SIZE 38 BY 6.67 NO-UNDO.

DEFINE VARIABLE paramlist AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE 
     SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL 
     SIZE 38 BY 4.52 NO-UNDO.

DEFINE VARIABLE superProcs AS CHARACTER 
     VIEW-AS SELECTION-LIST SINGLE 
     SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL 
     SIZE 38 BY 6.43 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY browser_pp FOR 
      pp SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE browser_pp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS browser_pp C-Win _FREEFORM
  QUERY browser_pp NO-LOCK DISPLAY
      pp.cFileName WITH NO-LABELS
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS NO-COLUMN-SCROLLING SIZE 37 BY 12.14
         FONT 4 ROW-HEIGHT-CHARS .62.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     browser_pp AT ROW 1.71 COL 3
     Btn_Close AT ROW 14.33 COL 3
     Btn_Delete AT ROW 14.33 COL 19
     b_smartinfo AT ROW 14.33 COL 28
     int-entries AT ROW 1.71 COL 43 NO-LABEL
     Btn_Run_In AT ROW 8.86 COL 55
     paramlist AT ROW 10.76 COL 43 NO-LABEL
     dbrefs AT ROW 1.71 COL 84 NO-LABEL
     uid AT ROW 14.81 COL 92 COLON-ALIGNED NO-LABEL
     superProcs AT ROW 7.91 COL 84 NO-LABEL
     lbl_po AT ROW 1 COL 1 COLON-ALIGNED NO-LABEL
     lbl_ie AT ROW 1 COL 41 COLON-ALIGNED NO-LABEL
     RECT-1 AT ROW 1.24 COL 83
     RECT-2 AT ROW 7.43 COL 83
     r_intent AT ROW 1.24 COL 42
     r_objects AT ROW 1.24 COL 2
     "Super Procedures" VIEW-AS TEXT
          SIZE 18 BY .57 AT ROW 7.19 COL 84
     "Unique-ID:" VIEW-AS TEXT
          SIZE 10 BY .81 AT ROW 14.81 COL 83
     "Databases Referenced" VIEW-AS TEXT
          SIZE 23 BY .57 AT ROW 1 COL 84
     "Parameters" VIEW-AS TEXT
          SIZE 11 BY .57 AT ROW 10.05 COL 43
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 123.8 BY 15.1
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Procedure Object Viewer"
         HEIGHT             = 15.05
         WIDTH              = 123.8
         MAX-HEIGHT         = 20.91
         MAX-WIDTH          = 146.2
         VIRTUAL-HEIGHT     = 20.91
         VIRTUAL-WIDTH      = 146.2
         MAX-BUTTON         = no
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         FONT               = 4
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU MENU-BAR-C-Win:HANDLE.

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT C-Win:LOAD-ICON("adeicon\procedur":U) THEN
    MESSAGE "Unable to load icon: adeicon\procedur"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   Custom                                                               */
/* BROWSE-TAB browser_pp 1 DEFAULT-FRAME */
/* SETTINGS FOR BUTTON b_smartinfo IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN lbl_ie IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN lbl_po IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN uid IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE browser_pp
/* Query rebuild information for BROWSE browser_pp
     _START_FREEFORM
OPEN QUERY browser_pp FOR EACH pp.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* BROWSE browser_pp */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Procedure Object Viewer */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Procedure Object Viewer */
DO:
  /* These events will close the window and terminate the procedure.      */
  /* (NOTE: this will override any user-defined triggers previously       */
  /*  defined on the window.)                                             */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME browser_pp
&Scoped-define SELF-NAME browser_pp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL browser_pp C-Win
ON ITERATION-CHANGED OF browser_pp IN FRAME DEFAULT-FRAME
DO:  
   IF AVAILABLE(pp) THEN DO:
     RUN Set_Internal_Entries.
     ASSIGN dbrefs:LIST-ITEMS    = pp.pHandle:DB-REFERENCES
            uid:SCREEN-VALUE     = STRING(pp.pHandle:UNIQUE-ID).
                              
     RUN List-Params.
     /* Is this a SmartObject? */
     /* V8-style */
     isSmartObject = CAN-DO (pp.pHandle:INTERNAL-ENTRIES, "Dispatch":U) AND
                     CAN-DO (pp.pHandle:INTERNAL-ENTRIES, "get-attribute":U).
     /* v9-style */
     IF CAN-DO (pp.pHandle:INTERNAL-ENTRIES, "getObjectVersion":U) THEN DO:
         isSmartObject = 
          DYNAMIC-FUNCTION("getObjectVersion":U IN pp.pHandle) BEGINS "ADM":U
            NO-ERROR.
         IF isSmartObject = ? THEN isSmartObject = FALSE.
     END.
     RUN List-SuperProcedures.
   END.
   ELSE isSmartObject = no.
   b_SmartInfo:SENSITIVE = isSmartObject.
   
   /* Disable buttons that act on the current pp */
   IF AVAILABLE (pp) ne btn_Close:SENSITIVE
   THEN ASSIGN btn_Close:SENSITIVE = AVAILABLE(pp)
               btn_Delete:SENSITIVE = AVAILABLE (pp)
               btn_Run_In:SENSITIVE = int-entries:SCREEN-VALUE NE "" AND
                                      int-entries:SCREEN-VALUE NE ?
               .
   
   IF int-entries:NUM-ITEMS > 0 THEN DO:
       ASSIGN int-entries:SCREEN-VALUE = int-entries:ENTRY(1).
       APPLY "VALUE-CHANGED" TO int-entries.
   END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Close
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Close C-Win
ON CHOOSE OF Btn_Close IN FRAME DEFAULT-FRAME /* Apply  "Close" */
DO:
  /* Apply "CLOSE" to the procedure.  This might not do any good. */
  APPLY "CLOSE":U TO pp.pHandle.
  
  IF VALID-HANDLE(pp.pHandle)
  THEN MESSAGE "Applying CLOSE to" pp.cFileName "did not close the procedure."
               SKIP
               "The 'Delete Procedure' button should work."
               VIEW-AS ALERT-BOX INFORMATION.
  ELSE RUN check_procedures.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Delete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Delete C-Win
ON CHOOSE OF Btn_Delete IN FRAME DEFAULT-FRAME /* Delete */
DO:
  /* DELETE this procedure.  This should work, but it did not. */
  DELETE PROCEDURE pp.pHandle.
  
  IF VALID-HANDLE(pp.pHandle)
  THEN MESSAGE "Deleting the procedure" pp.cFileName "did not work."
               SKIP
               "The procedure is still in memory.  Perhaps there is an"
               "active WAIT-FOR in the procedure."
               VIEW-AS ALERT-BOX WARNING.
  ELSE RUN check_procedures.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Run_In
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Run_In C-Win
ON CHOOSE OF Btn_Run_In IN FRAME DEFAULT-FRAME /* RUN Entry */
DO:  
  DEFINE VARIABLE adm-method AS CHARACTER NO-UNDO.
  /* Run the current entry in the current persistent procedure.  This may
     cause an error (but that is ok). */
  RUN-IN-BLOCK:
  DO ON ERROR UNDO RUN-IN-BLOCK, LEAVE RUN-IN-BLOCK:
    IF REPLACE(SELF:LABEL,"&","") EQ "Run entry" THEN DO:
      IF ENTRY(1,pp.pHandle:GET-SIGNATURE(int-entries:SCREEN-VALUE)) = "FUNCTION":U THEN DO:
        DEFINE VARIABLE abtitle AS CHARACTER NO-UNDO.
        ASSIGN abtitle = "Return value of function " + int-entries:SCREEN-VALUE.
        CASE ENTRY(2,pp.pHandle:GET-SIGNATURE(int-entries:SCREEN-VALUE)):
          WHEN "CHARACTER" THEN DO:
            DEFINE VARIABLE rc AS CHARACTER NO-UNDO.
            ASSIGN rc = DYNAMIC-FUNCTION(int-entries:SCREEN-VALUE IN pp.pHandle).
            MESSAGE rc VIEW-AS ALERT-BOX TITLE abtitle.
          END.
          WHEN "INTEGER" THEN DO:
            DEFINE VARIABLE ri AS INTEGER NO-UNDO.
            ASSIGN ri = DYNAMIC-FUNCTION(int-entries:SCREEN-VALUE IN pp.pHandle).
            MESSAGE ri VIEW-AS ALERT-BOX TITLE abtitle.
          END.
          WHEN "DECIMAL" THEN DO:
            DEFINE VARIABLE rd AS DECIMAL NO-UNDO.
            ASSIGN rd = DYNAMIC-FUNCTION(int-entries:SCREEN-VALUE IN pp.pHandle).
            MESSAGE rd VIEW-AS ALERT-BOX TITLE abtitle.
          END.
          WHEN "LOGICAL" THEN DO:
            DEFINE VARIABLE rl AS LOGICAL NO-UNDO.
            ASSIGN rl = DYNAMIC-FUNCTION(int-entries:SCREEN-VALUE IN pp.pHandle).
            MESSAGE rl VIEW-AS ALERT-BOX TITLE abtitle.
          END.
          WHEN "WIDGET-HANDLE" THEN DO:
            DEFINE VARIABLE rh AS WIDGET-HANDLE NO-UNDO.
            ASSIGN rh = DYNAMIC-FUNCTION(int-entries:SCREEN-VALUE IN pp.pHandle).
            MESSAGE STRING(rh) VIEW-AS ALERT-BOX TITLE abtitle.
          END.
        END CASE.
        DYNAMIC-FUNCTION(int-entries:SCREEN-VALUE IN pp.pHandle).
      END.
      ELSE
        RUN VALUE(int-entries:SCREEN-VALUE) IN pp.pHandle.
    END.
    ELSE IF REPLACE(SELF:LABEL,"&","") EQ "Dispatch" THEN DO:
      IF int-entries:SCREEN-VALUE BEGINS "adm-" THEN
        ASSIGN adm-method = REPLACE(int-entries:SCREEN-VALUE,"adm-","").
      ELSE IF int-entries:SCREEN-VALUE BEGINS "local-" THEN
        ASSIGN adm-method = REPLACE(int-entries:SCREEN-VALUE,"local-","").
      RUN Dispatch IN pp.pHandle (adm-method).
    END.
  END.
  RUN Check_Procedures.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_smartinfo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_smartinfo C-Win
ON CHOOSE OF b_smartinfo IN FRAME DEFAULT-FRAME /* SmartInfo... */
DO:  
  IF CAN-DO (pp.pHandle:INTERNAL-ENTRIES, "getObjectVersion":U) THEN DO: /* v9 */
    IF DYNAMIC-FUNCTION("getObjectVersion":U IN pp.pHandle) BEGINS "ADM":U THEN
      RUN adm2/support/_so-info.w (INPUT pp.pHandle, INPUT "SmartInfo").
  END.
  ELSE
    RUN adm/support/_so-info.w (INPUT pp.pHandle, INPUT "SmartInfo").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME int-entries
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL int-entries C-Win
ON VALUE-CHANGED OF int-entries IN FRAME DEFAULT-FRAME
DO:
  DEFINE VARIABLE params AS CHARACTER NO-UNDO INITIAL "".
  
  /* Set the RUN..IN button to be sensitive only if there is a valid item
     selected in the list. */
  IF SELF:SCREEN-VALUE NE "" THEN DO:
    ASSIGN params = ENTRY(3,pp.pHandle:GET-SIGNATURE(SELF:SCREEN-VALUE)) NO-ERROR.
    IF (params NE "" AND KEYWORD(ENTRY(1,params," ")) NE ?) /*OR 
      ENTRY(1,pp.pHandle:GET-SIGNATURE(SELF:SCREEN-VALUE)) = "FUNCTION":U */ THEN 
        btn_Run_In:SENSITIVE = NO.
    ELSE btn_Run_In:SENSITIVE = YES.
    RUN List-Params.
  END.
  ELSE btn_Run_In:SENSITIVE = NO.
  IF (SELF:SCREEN-VALUE BEGINS "adm-"    OR 
      SELF:SCREEN-VALUE BEGINS "local-") AND
     SELF:LOOKUP("Dispatch")      NE ?   AND
     SELF:LOOKUP("Get-Attribute") NE ?   THEN
    Btn_Run_In:LABEL = "Di&spatch".
  ELSE Btn_Run_In:LABEL = "&Run entry".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_About
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_About C-Win
ON CHOOSE OF MENU-ITEM m_About /* About Procedure Object Viewer */
DO:
    RUN adecomm/_about.p (INPUT "Procedure Object Viewer", INPUT "adeicon/procedur").  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Contents
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Contents C-Win
ON CHOOSE OF MENU-ITEM m_Contents /* Procedure Object Viewer Help */
DO:
  RUN adecomm/_adehelp.p ( "ptls", "CONTEXT", {&Procedure_Object_Viewer}, ? ).    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Exit C-Win
ON CHOOSE OF MENU-ITEM m_Exit /* Exit */
DO:
  APPLY "CLOSE" TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Help_Topics
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Help_Topics C-Win
ON CHOOSE OF MENU-ITEM m_Help_Topics /* Help Topics */
DO:
  RUN adecomm/_adehelp.p ( "ptls", "TOPICS", {&Procedure_Object_Viewer}, ? ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Hide_ADE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Hide_ADE C-Win
ON VALUE-CHANGED OF MENU-ITEM m_Hide_ADE /* Hide ADE Procedures */
DO:
  RUN Open_Query.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Hide_UIB
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Hide_UIB C-Win
ON VALUE-CHANGED OF MENU-ITEM m_Hide_UIB /* Hide UIB-Mode Objects */
DO:
  RUN Open_Query.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Refresh
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Refresh C-Win
ON CHOOSE OF MENU-ITEM m_Refresh /* Refresh List of Procedure Objects */
DO:
  RUN Build_PP_List.
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

/* Make adjustments if running on Win95 font */
IF SESSION:PIXELS-PER-COLUMN = 5 THEN
  ASSIGN lbl_po:WIDTH = lbl_po:WIDTH + 5
         lbl_ie:WIDTH = lbl_ie:WIDTH + 4.
         
/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  ASSIGN MENU-ITEM m_Hide_ADE:CHECKED IN MENU MENU-BAR-C-Win = YES
         MENU-ITEM m_Hide_UIB:CHECKED IN MENU MENU-BAR-C-Win = YES.
  RUN Build_PP_List.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Build_PP_List C-Win 
PROCEDURE Build_PP_List :
/*------------------------------------------------------------------------------
  Purpose:     Builds the Persistent Procedure List
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE setDesignMode AS LOGICAL NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    FOR EACH pp. DELETE pp. END. /* Whack old list */
    /* Find the handles, filenames, etc of all persistent procedures.       */
    h = SESSION:FIRST-PROCEDURE.
    DO WHILE VALID-HANDLE(h):
      CREATE pp.
      ASSIGN pp.pHANDLE = h
             pp.cFileName = h:FILE-NAME
             h = h:NEXT-SIBLING
             setDesignMode = FALSE
             .
             
      /* Add " (design)" to name to indicate the version of a SmartObject in
       * UIB "design" mode. This differentiates it from another instance which
       * may be part of a running container
       */
      IF CAN-DO(pp.pHANDLE:INTERNAL-ENTRIES,"ADEPersistent":U) THEN 
        pp.ptype = 1. /* ADE proc */
      ELSE IF CAN-DO(pp.pHANDLE:INTERNAL-ENTRIES,"get-attribute":U) /* V8-style */ THEN DO:
        RUN get-attribute IN pp.pHANDLE ("UIB-MODE":U).
        ASSIGN setDesignMode = RETURN-VALUE NE ?.
      END.
      ELSE IF CAN-DO(pp.pHandle:INTERNAL-ENTRIES,"getUIBMode":U) 
      AND INDEX(pp.cFileName,"smart.p":U) = 0 /* v9-style */ THEN 
        setDesignMode = DYNAMIC-FUNCTION("getUIBMode":U IN pp.pHANDLE) = "Design":U 
        NO-ERROR.
      
      IF setDesignMode THEN
          ASSIGN pp.cFileName = pp.cFileName + " (design)":U
                 pp.ptype     = 2.       
    END.
    
    /* Show the query */
    RUN Open_Query.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE check_procedures C-Win 
PROCEDURE check_procedures :
/* -----------------------------------------------------------
  Purpose: Go through all the procedures we have a record of
           and see if any are deleted.  If they are, then 
           reopen the query.    
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  def var lReOpen  as logical.
  def var oldrecid as recid.
  
  IF AVAILABLE(pp) THEN oldrecid = RECID(pp).
  /* Have any procedures been deleted? */
  lReOpen = NO.
  FOR EACH pp:
    IF NOT VALID-HANDLE(pp.pHandle) THEN DO:
      lReOpen = YES.
      DELETE pp.
    END.
  END.
  
  /* Reset the query & and empty the selection list, if necessary. */
  IF lReOpen THEN DO:
    RUN Open_Query.
    RUN Set_Selections.
  END.
  ELSE DO:
    FIND pp WHERE RECID(pp) = oldrecid NO-ERROR.
    IF AVAILABLE (pp) THEN RUN Repos(oldrecid).
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
  DISPLAY int-entries paramlist dbrefs uid superProcs lbl_po lbl_ie 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE browser_pp Btn_Close Btn_Delete int-entries Btn_Run_In paramlist 
         dbrefs superProcs RECT-1 RECT-2 r_intent r_objects 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE List-Params C-Win 
PROCEDURE List-Params :
/*------------------------------------------------------------------------------
  Purpose:     List Parameters of currently selected IP or Function
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE VARIABLE plist AS CHARACTER NO-UNDO.
   DEFINE VARIABLE i     AS INTEGER   NO-UNDO.
   
   DO WITH FRAME {&FRAME-NAME}:
     ASSIGN paramlist:LIST-ITEMS = ""
            plist                = pp.pHandle:GET-SIGNATURE(int-entries:SCREEN-VALUE).
     /* If it's a Function, insert a line indicating the data type of the return value */
     IF ENTRY(1,plist) = "FUNCTION":U THEN DO:
       IF paramlist:ADD-LAST("FUNCTION returns ":U + CAPS(ENTRY(2,plist))) THEN.
     END.
     
     IF NUM-ENTRIES(plist) > 2 THEN
     DO i = 3 TO NUM-ENTRIES(plist):
         IF paramlist:ADD-LAST(ENTRY(i,plist)) THEN.
     END.
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE List-SuperProcedures C-Win 
PROCEDURE List-SuperProcedures :
/*------------------------------------------------------------------------------
  Purpose:     List of the selected procedure's super procedures
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE i AS INTEGER NO-UNDO.
  DEFINE BUFFER xpp FOR pp.
  
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN superProcs:LIST-ITEMS = "".
    DO i = 1 TO NUM-ENTRIES(pp.pHandle:SUPER-PROCEDURES):
      FIND xpp WHERE xpp.pHandle = WIDGET-HANDLE(ENTRY(i,pp.pHandle:SUPER-PROCEDURES)) NO-ERROR.
      IF AVAILABLE xpp THEN
        superProcs:ADD-LAST(xpp.cFileName).
      ELSE
        superProcs:ADD-LAST("Handle: " + ENTRY(i,pp.pHandle:SUPER-PROCEDURES)).
    END.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Open_Query C-Win 
PROCEDURE Open_Query :
/*------------------------------------------------------------------------------
  Purpose:     Re/Opens the Query.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
  OPEN QUERY browser_pp FOR EACH pp WHERE
      (IF MENU-ITEM m_Hide_ADE:CHECKED IN MENU MENU-BAR-C-Win THEN 
         pp.ptype NE 1 
       ELSE TRUE) AND
       (IF MENU-ITEM m_Hide_UIB:CHECKED IN MENU MENU-BAR-C-Win THEN
         pp.ptype NE 2
         ELSE TRUE).
  ASSIGN browser_pp:SENSITIVE = YES.
  RUN Set_Selections.
  APPLY "ITERATION-CHANGED":U TO browser_pp.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Repos C-Win 
PROCEDURE Repos :
/*------------------------------------------------------------------------------
  Purpose:     Reposition browser.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER oldrecid AS RECID.
  
  DEFINE VARIABLE h AS HANDLE  NO-UNDO.
  DEFINE VARIABLE l AS LOGICAL NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}: 
    ASSIGN h = browser_pp:HANDLE
           l = h:SET-REPOSITIONED-ROW (MAX(1,h:FOCUSED-ROW), "CONDITIONAL").
  
    REPOSITION browser_pp TO RECID(oldrecid).
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Set_Internal_Entries C-Win 
PROCEDURE Set_Internal_Entries :
/*------------------------------------------------------------------------------
  Purpose:     Sets the contents of the int-entries selection list.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
     ASSIGN int-entries:HIDDEN = yes.
     &IF "{&WINDOW-SYSTEM}" EQ "OSF/Motif" &THEN
       /* This code is here to sort the internal-entries in alphabetical order
        * since the 'SORT' option on a selection-list in Motif does not work
        */
       DEFINE VARIABLE i      AS INTEGER   NO-UNDO.
       DEFINE VARIABLE sorted AS CHARACTER NO-UNDO INITIAL "".
       
       FOR EACH sort-ie: DELETE sort-ie. END.
       IF NUM-ENTRIES(pp.pHandle:INTERNAL-ENTRIES) > 0 THEN DO:
         DO i = 1 TO NUM-ENTRIES(pp.pHandle:INTERNAL-ENTRIES):
           CREATE sort-ie.
           ASSIGN ie = ENTRY(i,pp.pHandle:INTERNAL-ENTRIES).
         END.
         FOR EACH sort-ie BY ie:
           ASSIGN sorted = sorted + (IF sorted NE "" THEN "," ELSE "") + sort-ie.ie.
         END.
       END.
       ASSIGN int-entries:LIST-ITEMS = sorted.
     &ELSE  
       int-entries:LIST-ITEMS = pp.pHandle:INTERNAL-ENTRIES.
     &ENDIF
     ASSIGN int-entries:HIDDEN = no.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Set_Selections C-Win 
PROCEDURE Set_Selections :
/* -----------------------------------------------------------
  Purpose:     Position selections on the browser and sel-list.
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
    FIND FIRST pp WHERE
      (IF MENU-ITEM m_Hide_ADE:CHECKED IN MENU MENU-BAR-C-Win THEN 
         pp.ptype NE 1 
       ELSE TRUE) AND
       (IF MENU-ITEM m_Hide_UIB:CHECKED IN MENU MENU-BAR-C-Win THEN
         pp.ptype NE 2
         ELSE TRUE) NO-ERROR.
    IF AVAILABLE pp THEN DO:
        IF browser_pp:SELECT-ROW(1) IN FRAME {&FRAME-NAME} THEN.
    END.
    ELSE
        ASSIGN Btn_Delete:SENSITIVE = no
               Btn_Close:SENSITIVE  = no
               Btn_Run_In:SENSITIVE = no
               int-entries:LIST-ITEMS IN FRAME {&FRAME-NAME} = "":U
               dbrefs:LIST-ITEMS      IN FRAME {&FRAME-NAME} = "":U
               paramlist:LIST-ITEMS   IN FRAME {&FRAME-NAME} = "":U
               superProcs:LIST-ITEMS  IN FRAME {&FRAME-NAME} = "":U
               uid:SCREEN-VALUE       IN FRAME {&FRAME-NAME} = "":U.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

