&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME hWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS hWin 
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
/*----------------------------------------------------------------------

  File: _walker.w

  Description: 
      Walks all the widgets on the screen.

  Input Parameters:
      <none>
       
  Output Parameters:
      <none>

  Author: Wm. T. Wood, Gerry Seidl

  Created: Sept. 1994
  
  Modified:
    01/04/2001 (Tim Townsend) Changed to preserve physical row position
                              when repositioning.
  
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
{ protools/ptlshlp.i  } /* help definitions   */
{ adecomm/_adetool.i  } /* define as ADE tool */
{ protools/_runonce.i } /* allow one instance */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VAR show_levels AS INTEGER NO-UNDO. 
DEFINE VAR save_recid  AS RECID   NO-UNDO.
DEFINE VAR mode        AS CHAR    NO-UNDO INITIAL "NO-ADE".

/* Temp-Table/Browser Definitions ---                                   */
DEFINE TEMP-TABLE tt
  FIELD handle       AS HANDLE
  FIELD name         AS CHAR
  FIELD level        AS INTEGER  
  FIELD parent-recid AS RECID
  FIELD expanded     AS LOGICAL
  FIELD visible      AS LOGICAL      
  .
DEFINE BUFFER x_tt FOR tt.

DEFINE QUERY wlist FOR tt SCROLLING.

DEFINE BROWSE   wlist
       QUERY    wlist
       DISPLAY  FILL("     ",tt.level - 1) + 
                (IF NOT CAN-FIND (FIRST x_tt WHERE x_tt.parent-recid eq RECID(tt))
                 THEN "  "
                 ELSE (IF tt.expanded THEN "- " ELSE "+ " )) + 
                tt.name FORMAT "X(1024)"
       WITH SIZE 50 BY 14
            FONT 4
            &IF "{&WINDOW-SYSTEM}" NE "OSF/Motif" &THEN
                SEPARATORS
            &ENDIF
            NO-LABELS EXPANDABLE.      

&Scoped-define OPEN-QUERY-wlist OPEN QUERY wlist FOR EACH tt WHERE tt.level <= show_levels AND tt.visible.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WINDOW
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btn_expand btn_collapse btn_level-1 ~
btn_level-2 btn_level-3 btn_level-4 btn_level-5 btn_level-all levels 
&Scoped-Define DISPLAYED-OBJECTS levels 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR hWin AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU m_File 
       MENU-ITEM m_Exit         LABEL "E&xit"         .

DEFINE SUB-MENU m_View 
       MENU-ITEM m_User_Defined_Objects LABEL "&User Application Objects"
              TOGGLE-BOX
       MENU-ITEM m_All_Objects  LABEL "&All Objects"  
              TOGGLE-BOX
       RULE
       MENU-ITEM m_Refresh      LABEL "&Refresh"      .

DEFINE SUB-MENU m_Help 
       MENU-ITEM m_Contents     LABEL "&Help Topics"  
       MENU-ITEM m_Tool_Help    LABEL "&Control Hierarchy Help" ACCELERATOR "F1"
       RULE
       MENU-ITEM m_About        LABEL "&About Control Hierarchy".

DEFINE MENU MENU-BAR-hWin MENUBAR
       SUB-MENU  m_File         LABEL "&File"         
       SUB-MENU  m_View         LABEL "&View"         
       SUB-MENU  m_Help         LABEL "&Help"         .


/* Definitions of the field level widgets                               */
DEFINE BUTTON btn_collapse 
     LABEL "-":L 
     SIZE 4 BY 1.

DEFINE BUTTON btn_expand 
     LABEL "+":L 
     SIZE 4 BY 1.

DEFINE BUTTON btn_level-1 
     LABEL "1":L 
     SIZE 4 BY 1.

DEFINE BUTTON btn_level-2 
     LABEL "2":L 
     SIZE 4 BY 1.

DEFINE BUTTON btn_level-3 
     LABEL "3":L 
     SIZE 4 BY 1.

DEFINE BUTTON btn_level-4 
     LABEL "4":L 
     SIZE 4 BY 1.

DEFINE BUTTON btn_level-5 
     LABEL "5":L 
     SIZE 4 BY 1.

DEFINE BUTTON btn_level-all 
     LABEL "...":L 
     SIZE 4 BY 1.

DEFINE VARIABLE levels AS CHARACTER FORMAT "X(21)":U 
      VIEW-AS TEXT 
     SIZE 17 BY .95.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f
     btn_expand AT ROW 1 COL 1
     btn_collapse AT ROW 1 COL 5
     btn_level-1 AT ROW 1 COL 27
     btn_level-2 AT ROW 1 COL 31
     btn_level-3 AT ROW 1 COL 35
     btn_level-4 AT ROW 1 COL 39
     btn_level-5 AT ROW 1 COL 43
     btn_level-all AT ROW 1 COL 47
     levels AT ROW 1.05 COL 8 COLON-ALIGNED NO-LABEL
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 77.2 BY 19.43.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: WINDOW
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW hWin ASSIGN
         HIDDEN             = YES
         TITLE              = "Control Hierarchy"
         HEIGHT             = 19.43
         WIDTH              = 77.2
         MAX-HEIGHT         = 44.43
         MAX-WIDTH          = 256
         VIRTUAL-HEIGHT     = 44.43
         VIRTUAL-WIDTH      = 256
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU MENU-BAR-hWin:HANDLE.

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT hWin:LOAD-ICON("adeicon/cntrlhry":U) THEN
    MESSAGE "Unable to load icon: adeicon/cntrlhry"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW hWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f
                                                                        */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(hWin)
THEN hWin:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME hWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL hWin hWin
ON END-ERROR OF hWin /* Control Hierarchy */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE
DO:
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL hWin hWin
ON ENTRY OF hWin /* Control Hierarchy */
DO:
  /* Reassign Current-window so dialog-boxes come up correctly */
  CURRENT-WINDOW = THIS-PROCEDURE:CURRENT-WINDOW.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL hWin hWin
ON WINDOW-CLOSE OF hWin /* Control Hierarchy */
DO:
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL hWin hWin
ON WINDOW-MAXIMIZED OF hWin /* Control Hierarchy */
DO:
  /* Make sure that the window's new size does not cover the taskbar */
  ASSIGN SELF:x = SESSION:WORK-AREA-X
         SELF:y = SESSION:WORK-AREA-Y
         SELF:HEIGHT-PIXELS = SESSION:WORK-AREA-HEIGHT-PIXELS
         SELF:WIDTH-PIXELS  = SESSION:WORK-AREA-WIDTH-PIXELS.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL hWin hWin
ON WINDOW-RESIZED OF hWin /* Control Hierarchy */
DO:
  DEFINE VARIABLE hCol AS HANDLE NO-UNDO.
  
  /* Resize the frame and browse widget to the window */
  ASSIGN hCol                  = BROWSE wlist:FIRST-COLUMN
         FRAME f:HIDDEN        = TRUE
         FRAME f:WIDTH-P       = SELF:WIDTH-P
         FRAME f:HEIGHT-P      = SELF:HEIGHT-P
         BROWSE wlist:WIDTH-P  = FRAME f:WIDTH-P - 
           (FRAME F:BORDER-LEFT-P + FRAME F:BORDER-RIGHT-P)
         BROWSE wlist:HEIGHT-P = FRAME f:HEIGHT-P - 
           (FRAME F:BORDER-TOP-P + FRAME F:BORDER-BOTTOM-P) - btn_expand:HEIGHT-P
         hCol:WIDTH            = BROWSE wlist:WIDTH
         FRAME f:SCROLLABLE    = FALSE
         FRAME f:HIDDEN        = FALSE NO-ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn_collapse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_collapse hWin
ON CHOOSE OF btn_collapse IN FRAME f /* - */
DO:
  DEFINE BUFFER child_tt FOR tt.
  IF AVAILABLE tt AND tt.expanded THEN DO:
    /* Don't collapse something that has no children */
    IF CAN-FIND (FIRST child_tt WHERE child_tt.parent-recid eq RECID(tt))
    THEN DO:
      RUN adecomm/_setcurs.p ("WAIT").
      /* Store the current recid */
      save_recid = RECID(tt).
      RUN set_expansion (RECID(tt), NO).
      RUN reopen_query(yes).
      RUN adecomm/_setcurs.p ("").
    END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn_expand
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_expand hWin
ON CHOOSE OF btn_expand IN FRAME f /* + */
DO:
  IF AVAILABLE tt AND tt.expanded eq NO THEN DO:
    RUN adecomm/_setcurs.p ("WAIT").
    /* Store the current recid */
    save_recid = RECID(tt).
    RUN set_expansion (RECID(tt), YES).
    RUN reopen_query(yes).
    RUN adecomm/_setcurs.p ("").
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn_level-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_level-1 hWin
ON CHOOSE OF btn_level-1 IN FRAME f /* 1 */
DO:
  /* Store the current recid, change the display level, and reopen the query. */
  ASSIGN save_recid = IF AVAILABLE tt THEN RECID(tt) ELSE ? 
         show_levels = integer(self:LABEL)
         levels:SCREEN-VALUE = "Level 1"   /* Show user what levels are shown */
         .
  RUN reopen_query(yes).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn_level-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_level-2 hWin
ON CHOOSE OF btn_level-2 IN FRAME f /* 2 */
DO:
  /* Store the current recid, change the display level, and reopen the query. */
  ASSIGN save_recid = IF AVAILABLE tt THEN RECID(tt) ELSE ? 
         show_levels = integer(self:LABEL)    
         /* Show user what levels are shown */     
         levels:SCREEN-VALUE = "Levels 1 - " + SELF:LABEL
         .
  RUN reopen_query(yes).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn_level-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_level-3 hWin
ON CHOOSE OF btn_level-3 IN FRAME f /* 3 */
DO:
  /* Store the current recid, change the display level, and reopen the query. */
  ASSIGN save_recid = IF AVAILABLE tt THEN RECID(tt) ELSE ? 
         show_levels = integer(self:LABEL)   
         /* Show user what levels are shown */     
         levels:SCREEN-VALUE = "Levels 1 - " + SELF:LABEL
         .
  RUN reopen_query(yes).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn_level-4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_level-4 hWin
ON CHOOSE OF btn_level-4 IN FRAME f /* 4 */
DO:
  /* Store the current recid, change the display level, and reopen the query. */
  ASSIGN save_recid = IF AVAILABLE tt THEN RECID(tt) ELSE ? 
         show_levels = integer(self:LABEL)   
         /* Show user what levels are shown */     
         levels:SCREEN-VALUE = "Levels 1 - " + SELF:LABEL
         .
  RUN reopen_query(yes).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn_level-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_level-5 hWin
ON CHOOSE OF btn_level-5 IN FRAME f /* 5 */
DO:
  /* Store the current recid, change the display level, and reopen the query. */
  ASSIGN save_recid = IF AVAILABLE tt THEN RECID(tt) ELSE ? 
         show_levels = integer(self:LABEL)   
         /* Show user what levels are shown */     
         levels:SCREEN-VALUE = "Levels 1 - " + SELF:LABEL
         .
  RUN reopen_query(yes).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn_level-all
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_level-all hWin
ON CHOOSE OF btn_level-all IN FRAME f /* ... */
DO:
  /* Store the current recid, change the display level, and reopen the query. */
  ASSIGN save_recid = IF AVAILABLE tt THEN RECID(tt) ELSE ? 
         show_levels = 1000000   
         /* Show user what levels are shown */     
         levels:SCREEN-VALUE = "All Levels"
         .
  RUN reopen_query(yes).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_About
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_About hWin
ON CHOOSE OF MENU-ITEM m_About /* About Control Hierarchy */
DO:
    RUN adecomm/_about.p (INPUT "Control Hierarchy", INPUT "adeicon/cntrlhry").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_All_Objects
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_All_Objects hWin
ON VALUE-CHANGED OF MENU-ITEM m_All_Objects /* All Objects */
DO:
  IF SELF:CHECKED = YES THEN DO:
    ASSIGN MENU-ITEM m_User_Defined_objects:CHECKED IN MENU MENU-BAR-hWin = NO
           mode = "ALL".
    RUN Refresh.
  END.
  ELSE RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Contents
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Contents hWin
ON CHOOSE OF MENU-ITEM m_Contents /* Help Topics */
DO:
  RUN adecomm/_adehelp.p ( "ptls", "TOPICS", {&Control_Hierarchy}, ? ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Exit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Exit hWin
ON CHOOSE OF MENU-ITEM m_Exit /* Exit */
DO:
   APPLY "CLOSE":U TO THIS-PROCEDURE.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Refresh
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Refresh hWin
ON CHOOSE OF MENU-ITEM m_Refresh /* Refresh */
DO:
  RUN Refresh.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Tool_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Tool_Help hWin
ON CHOOSE OF MENU-ITEM m_Tool_Help /* Control Hierarchy Help */
DO:
  RUN adecomm/_adehelp.p ( "ptls", "CONTEXT", {&Control_Hierarchy}, ? ).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_User_Defined_Objects
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_User_Defined_Objects hWin
ON VALUE-CHANGED OF MENU-ITEM m_User_Defined_Objects /* User Application Objects */
DO:
  IF SELF:CHECKED = YES THEN DO:
    ASSIGN MENU-ITEM m_All_Objects:CHECKED IN MENU MENU-BAR-hWin = NO
           mode = "NO-ADE".
    RUN Refresh.
  END.
  ELSE RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK hWin 


/* ***************************  Main Block  *************************** */
  
/* Add the browse to the frame */
DEFINE FRAME {&FRAME-NAME} wlist AT ROW 2 COL 1. 
  
/* Add a call to request the Default-Action when an item is dbl-clicked */ 
ON DEFAULT-ACTION OF wlist IN FRAME {&FRAME-NAME} DO:
  DEFINE BUFFER child_tt FOR tt.
  RUN adecomm/_setcurs.p ("WAIT").
  IF AVAILABLE tt THEN DO:
    /* Don't expand/collapse something that has no children */
    IF CAN-FIND (FIRST child_tt WHERE child_tt.parent-recid eq RECID(tt))
    THEN DO:
      /* Store the current recid */
      save_recid = RECID(tt).
      RUN set_expansion (RECID(tt), NOT tt.expanded).
      RUN reopen_query(yes).
    END.
  END. 
  RUN adecomm/_setcurs.p("").
END.
ASSIGN MENU-ITEM m_User_Defined_objects:CHECKED IN MENU MENU-BAR-hWin = YES
       MENU-ITEM m_All_Objects:CHECKED IN MENU MENU-BAR-hWin          = NO.
       
/* Send messages to alert boxes because there is no message area.       */
THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  APPLY "window-resized" TO {&WINDOW-NAME}.
  RUN enable_UI.
  /* Create the list of widgets. */
  RUN create_list (SESSION, 1, ?).
  /* Show user what levels are shown */     
  ASSIGN show_levels = 1000000   
         levels:SCREEN-VALUE = "All Levels".
  .
  {&OPEN-QUERY-wlist} 
  ENABLE wlist WITH FRAME {&FRAME-NAME}.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

PROCEDURE LockWindowUpdate EXTERNAL "USER32.DLL":u:
    DEFINE INPUT  PARAMETER intWindowHwnd AS LONG NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE create_list hWin 
PROCEDURE create_list :
/* -----------------------------------------------------------
  Purpose: create the temp-table containing all the items in
           that parent to a widget.
  Parameters:  phParent - Pointer to the aggregate
               pLevel   - the level    
               prParent - Parent Recid
  Notes:       
-------------------------------------------------------------*/
  DEF INPUT PARAMETER phParent AS WIDGET  NO-UNDO.
  DEF INPUT PARAMETER pLevel   AS INTEGER NO-UNDO.
  DEF INPUT PARAMETER prParent AS RECID   NO-UNDO.
  
  DEF VAR elist AS CHARACTER     NO-UNDO INITIAL "User Interface Builder,PROGRESS,PRO*Tools,Data Dictionary,Procedure Editor,Data Administration,Librarian,Results,Translation Manager,Application Compiler,Control Hierarchy,Run Procedure,Color Changer,PRO*Spy".
  DEF VAR h     AS WIDGET-HANDLE NO-UNDO.
  
  /* Make a record in the temp-table */
  h = phParent:FIRST-CHILD.
  DO WHILE VALID-HANDLE(h):
     IF h:TYPE = "WINDOW" AND mode = "NO-ADE" THEN
       IF CAN-DO(elist,TRIM(h:TITLE))        OR 
         h:TITLE = ?                         OR
         h:TITLE BEGINS "Procedure -"        OR
         h:TITLE BEGINS "Procedure Editor -" OR
         h:TITLE BEGINS "User Interface Builder -" THEN DO:
           ASSIGN h = h:NEXT-SIBLING. /* skip it */
           NEXT.
       END.
    /* Create a record for this thing */
    CREATE tt.
    ASSIGN tt.level = pLevel
           tt.parent-recid = prParent
           tt.expanded = YES
           tt.visible = YES
           tt.handle = h.
           tt.name =  LC(h:TYPE) + ": "
           .
    /* Make the name more descriptive. */
    CASE h:TYPE:
      WHEN "WINDOW":U OR WHEN "DIALOG-BOX":U THEN 
        tt.name = tt.name + (IF h:TITLE EQ ? THEN STRING(h) ELSE h:TITLE).
      WHEN "FRAME":U THEN DO:
        tt.name = tt.name + IF h:TITLE eq ? THEN STRING(h) ELSE h:TITLE.
        END.
      WHEN "FIELD-GROUP":U THEN
        tt.name = tt.name + STRING(h).
      OTHERWISE DO:
        IF CAN-QUERY(h, "LABEL":U) AND h:LABEL ne ? AND h:LABEL ne "":U THEN 
          tt.name = tt.name + h:LABEL.
        ELSE IF CAN-QUERY(h, "NAME-":U) AND h:NAME ne ? THEN
          tt.name = tt.name + h:NAME.
        ELSE IF CAN-QUERY(h, "SCREEN-VALUE":U) AND h:SCREEN-VALUE ne ? THEN
          tt.name = tt.name + "'":U + h:SCREEN-VALUE + "'":U.
        ELSE tt.name = tt.name + "@ X=" + STRING(h:X) + ", Y=" + STRING(h:Y).
      END.
    END CASE.
    /* Call recursively, if necessary */
    IF CAN-QUERY(h,"FIRST-CHILD") THEN RUN create_list (h, pLevel + 1, RECID(tt)).
    
    /* Get the next sibling. */
    h = h:NEXT-SIBLING.
  END.     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI hWin  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(hWin)
  THEN DELETE WIDGET hWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI hWin  _DEFAULT-ENABLE
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
  DISPLAY levels 
      WITH FRAME f IN WINDOW hWin.
  ENABLE btn_expand btn_collapse btn_level-1 btn_level-2 btn_level-3 
         btn_level-4 btn_level-5 btn_level-all levels 
      WITH FRAME f IN WINDOW hWin.
  {&OPEN-BROWSERS-IN-QUERY-f}
  VIEW hWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Refresh hWin 
PROCEDURE Refresh :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR xname LIKE tt.name.
  
  RUN adecomm/_setcurs.p ("WAIT").
  /* save off old name */
  IF save_recid <> ? THEN DO:
      FIND x_tt WHERE RECID(x_tt) = save_recid NO-ERROR. 
      IF AVAILABLE x_tt THEN xname = x_tt.name.
      ELSE save_recid = ?.
  END.   
  /* clear original widget list */
  FOR EACH tt: DELETE tt. END.
  
  /* Create the list of widgets. */
  RUN create_list (SESSION, 1, ?).
  
  IF xname <> "" AND save_recid <> ? THEN DO:
      /* try to maintain previous position */
      FIND FIRST tt WHERE tt.name = xname NO-ERROR.
      IF NOT AVAILABLE tt THEN DO:
          FIND FIRST tt NO-ERROR.
          IF AVAILABLE tt THEN save_recid = RECID(tt).
      END.
      ELSE save_recid = RECID(tt).
  END.  
  RUN reopen_query(no).
  RUN adecomm/_setcurs.p ("").
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE reopen_query hWin 
PROCEDURE reopen_query :
/* -----------------------------------------------------------
  Purpose:  Remember where we are in the query, reopen the query
            and reposition to that point.   
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
def input        param pPreserve            as log         no-undo.

def var iPos                 as int                        no-undo.

  /* store current position */
  iPos = BROWSE wlist:FOCUSED-ROW.
  /* lock window */
  run LockWindowUpdate({&WINDOW-NAME}:hwnd).
  /* Reopen query */
  {&OPEN-QUERY-wlist}
  /* Repositon query */
  IF save_recid NE ? THEN DO:
      FIND FIRST x_tt WHERE RECID(x_tt) = save_recid NO-ERROR.
      IF AVAILABLE x_tt THEN DO:
          DO WHILE x_tt.level > show_levels: /* if wrong level, find parent that is*/
              save_recid = x_tt.parent-recid.
              FIND x_tt WHERE RECID(x_tt) = save_recid.
          END.
          if pPreserve then
            wlist:SET-REPOSITIONED-ROW(iPos,"ALWAYS":u) in frame {&FRAME-NAME}.
          else
            wlist:SET-REPOSITIONED-ROW(wlist:DOWN,"CONDITIONAL":u) in frame {&FRAME-NAME}.
          REPOSITION wlist TO RECID save_recid.
      END. 
  END.   
  /* unlock window */
  run LockWindowUpdate(0).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set_expansion hWin 
PROCEDURE set_expansion :
/* -----------------------------------------------------------
  Purpose: If a list record is selected, then mark it as 
           expanded (or collapsed).  Mark its descendends as
           visible (or not).
           it and all its descendants.  
  Parameters:  pRecid  - Recid to expand
               pExpand - TRUE if we want to expand, FALSE for collapse
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pRecid  AS RECID   NO-UNDO.
  DEFINE INPUT PARAMETER pExpand AS LOGICAL NO-UNDO.
  
  DEFINE BUFFER child_tt FOR tt.
  
  FIND tt WHERE RECID(tt) eq pRECID NO-ERROR.
  IF AVAILABLE tt THEN DO:
    tt.expanded = pExpand.
    FOR EACH child_tt WHERE child_tt.parent-recid eq pRecid:
      RUN set_visible (RECID(child_tt), pExpand).
    END.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set_visible hWin 
PROCEDURE set_visible :
/* -----------------------------------------------------------
  Purpose: Mark the current record as visible (or not), if it
           is set the wrong way.
           visible (or not).
           it and all its descendants.  
  Parameters: pRecid   - Recid to expand
              pVisible - TRUE if we want to expand, FALSE for collapse
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pRecid   AS RECID   NO-UNDO.
  DEFINE INPUT PARAMETER pVisible AS LOGICAL NO-UNDO.
  
  DEFINE BUFFER child_tt FOR tt.
  
  FIND tt WHERE RECID(tt) eq pRECID NO-ERROR.
  IF AVAILABLE tt THEN DO:
    tt.visible = pVisible.
    FOR EACH child_tt WHERE child_tt.parent-recid eq pRecid:
      IF NOT pVisible OR (tt.expanded AND pVisible)
      THEN RUN set_visible (RECID(child_tt), pVisible).
    END.
  END.   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

