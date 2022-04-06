&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v7r7
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS WINDOW-1 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*-----------------------------------------------------------------------------

File: _selevnt.p

Description:
    Asks the user for a valid event.

Input Parameters:
    p_wtype    - Widget Type (used to determine custom list of events).
               - IF p_wtype = "ALL" then list all events.
    p_wsub     - Widget SubType [eg. MENU-ITEM or TOGGLE-BOX]
                 (used to determine custom list of events).
    p_other    - Other events this widget uses (e.g. if this is a VBX,
                 these are the VBX events.)
    p_cur_win_type  Is true if we are working in GUI mode and
                    false if we are in TTY mode. Used to disable Event
                    radio-set options not supported in TTY.
    p_p-recid  - Recid of the procedure object file. Used to display or
                 or not display the Filters, depending on whether or
                 not the procedure object supports defining Special
                 Events only (such as for Web Object).
    
Input/Output Parameters:
    choice - the initial choice - also returned. The initial value is
             returned if cancel is hit.

Output Parameters:
   none

Author: D. Ross Hunter , Wm.T.Wood

Date Created: February 10, 1993 

Modified on 1/27/98 GFS Added DROP-FILE-NOTIFY event for drag & drop support
            3/10/98 GFS Added VALUE-CHANGED for FILL-IN
            5/25/99 TSM Added START-ROW-RESIZE and END-ROW-RESIZE for BROWSE
                        and VALUE-CHANGED for EDITOR
----------------------------------------------------------------------------*/
DEFINE INPUT        PARAMETER p_wtype AS CHARACTER  NO-UNDO.
DEFINE INPUT        PARAMETER p_wsub  AS CHARACTER  NO-UNDO.
DEFINE INPUT        PARAMETER p_other AS CHARACTER  NO-UNDO.
DEFINE INPUT        PARAMETER p_cur_win_type AS LOGICAL INITIAL TRUE NO-UNDO.
DEFINE INPUT        PARAMETER p_p-recid AS RECID NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER choice  AS CHARACTER  NO-UNDO.

DEFINE VAR method_return        AS LOGICAL NO-UNDO.
DEFINE VAR display_filters      AS LOGICAL NO-UNDO INITIAL YES.
DEFINE VAR special_events_only  AS LOGICAL NO-UNDO INITIAL NO.
        
&Scoped-define USE-3D YES
&GLOBAL-DEFINE WIN95-BTN YES
{adeuib/pre_proc.i}
{adecomm/adestds.i}   /* Standard Definitions                       */ 
{adeuib/uibhlp.i}     /* Help pre-processor directives              */
{adeuib/uniwidg.i}    /* Universal widget TEMP-TABLE definitions    */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

DEFINE BUFFER b_P FOR _P.

/* Definitions of the field level widgets                               */
DEFINE BUTTON b_key LABEL "&Keyboard Event..." SIZE-CHAR 30 BY 1.125.

/* Buttons for the bottom of the screen                                      */
DEFINE BUTTON btn_ok     LABEL "OK":C12     {&STDPH_OKBTN} AUTO-GO.
DEFINE BUTTON btn_cancel LABEL "Cancel":C12 {&STDPH_OKBTN} AUTO-ENDKEY.
DEFINE BUTTON btn_help   LABEL "&Help":C12  {&STDPH_OKBTN}.

DEFINE VARIABLE possibilities AS CHARACTER FORMAT "X(40)" NO-UNDO.
DEFINE VARIABLE filterTitle AS CHARACTER FORMAT "X(16)"
	LABEL "Event Filters" NO-UNDO.
DEFINE VARIABLE sl_choices AS CHARACTER
     VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL
     SIZE-CHAR 38 BY 10   NO-UNDO.
DEFINE VARIABLE event_type AS INTEGER LABEL "Event Filter" 
     VIEW-AS RADIO-SET RADIO-BUTTONS 
	"Common Events",              1,
	"Direct Manipulation Events", 2,
	"Portable Mouse Events",      3,
	"Three-Button Mouse Events",  4, 
	"Developer Events",           5 NO-UNDO.
 
/* Definitions of the frame widgets                                     */
DEFINE FRAME f_events
      SKIP({&TFM_WID})
     "Event Name:"       VIEW-AS TEXT AT 2 SKIP({&VM_WID})
     choice              AT 2 NO-LABEL FORMAT "X(36)" SKIP({&VM_WIDG})
     filterTitle	 VIEW-AS TEXT AT 45 SKIP({&VM_WID})
     event_type          AT 45 NO-LABEL SKIP({&VM_WID})
     b_key               AT 45
     possibilities       VIEW-AS TEXT NO-LABEL AT ROW-OF filterTitle COL 2
     sl_choices          AT ROW-OF event_type COL 2 NO-LABEL

   {adecomm/okform.i
      &STATUS = "no"
      &OK     = "btn_ok"
      &CANCEL = "btn_cancel"
      &HELP   = "btn_help"}

    WITH SIDE-LABELS DEFAULT-BUTTON btn_ok TITLE "Choose Event"
	VIEW-AS DIALOG-BOX THREE-D.

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* ASSIGN RUN TIME ATTRIBUTES                                           */

/* Run time layout for button area. */
{adecomm/okrun.i  
   &FRAME = "FRAME f_events" 
   &OK    = "btn_ok" 
   &HELP  = "btn_help"
}
/*  TEXT TEXT-2 10.36 3 "Event Choice:"  */
/*  TEXT TEXT-3 1.52 36 "Event Types:"  */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM MAIN-BLOCK 

/* ---------------------- My Trigger Code -------------------- */
ON CHOOSE OF btn_help IN FRAME f_events OR HELP OF FRAME f_events
  RUN adecomm/_adehelp.p ( "AB", "CONTEXT", {&Events_Dlg_Box}, ? ).

ON VALUE-CHANGED OF event_type DO:
  IF INTEGER(SELF:SCREEN-VALUE) <> event_type THEN DO:
    event_type = INTEGER(SELF:SCREEN-VALUE).
    RUN show_choices.
  END.
END.

ON VALUE-CHANGED OF sl_choices DO:
 choice:SCREEN-VALUE IN FRAME f_events = SELF:SCREEN-VALUE.
END.

ON DEFAULT-ACTION OF sl_choices DO:
 APPLY "GO":U TO FRAME f_events.
END.

/* Choose a keyboard event */
ON CHOOSE OF b_key DO:
  DEFINE VAR key_event AS CHAR NO-UNDO.
  RUN adeuib/_selkey.p (OUTPUT key_event).
  IF LENGTH(key_event) > 0 THEN DO:
   /* Show the choice and also remove the hiliting on the select-list */
    ASSIGN choice:SCREEN-VALUE IN FRAME f_events = key_event
           sl_choices:SCREEN-VALUE IN FRAME f_events = ?.
  END.
END.

ON WINDOW-CLOSE OF FRAME f_events
DO:
    APPLY "END-ERROR":U TO SELF.
END.

/* Make sure we have a valid name */
ON GO OF FRAME f_events
DO:
  DEF VAR a_ok AS LOGICAL NO-UNDO.
  DEF VAR h_dummy AS WIDGET NO-UNDO.

  /*
   * Check first to see if the choice is a valid widget.
   * If it isn't then test if its a valid "other" or special
   * event, like an OCX event.
   */ 
     
  ASSIGN
    choice:SCREEN-VALUE = TRIM(choice:SCREEN-VALUE) 
    h_dummy = ?
    .

  IF NOT special_events_only THEN
  DO:    
    ASSIGN a_ok = VALID-EVENT (h_dummy, choice:SCREEN-VALUE).
      
    IF (NOT a_ok) AND (p_other <> "FFQ") THEN
      ASSIGN a_ok = CAN-DO(p_other, choice:SCREEN-VALUE).
  
    IF (NOT a_ok) AND (choice:SCREEN-VALUE = "DEFINE_QUERY") AND (p_other = "FFQ":U) THEN
        ASSIGN a_ok = TRUE.
  END.
  ELSE
    ASSIGN a_ok = CAN-DO(p_other, choice:SCREEN-VALUE).
        
  IF NOT a_ok THEN DO:
     MESSAGE CAPS(choice:SCREEN-VALUE) "is not a valid event name."
       	      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
     choice:SCREEN-VALUE = choice.
     RETURN NO-APPLY.
  END.
END.

/* ----------------------------------------------------------- */
/* Main Code Block - Enable Widgets, Exit condition, Clean-up  */
/* ----------------------------------------------------------- */

/* If this procedure object doesn't supports Special Events only,
   then we do not display the Filters. We'll also change the list
   of events to display based on this fact as well. */
FIND b_P WHERE RECID(b_P) = p_p-recid NO-ERROR.
IF AVAILABLE b_P AND p_other <> "SE_INSERT_EVENT":U THEN
DO:
    ASSIGN special_events_only = CAN-DO(b_P._Editing, "Special-Events-Only":u).
    ASSIGN display_filters = NOT special_events_only.
END.
/* We use p_other to force the full Choose Event dialog to display when
   called by the Insert Event name Section Editor command. Fixes
   bug 98-09-09-056. - jep */
IF p_other = "SE_INSERT_EVENT":U THEN
    ASSIGN p_other = ?.

/* Best choices for events. */
ASSIGN event_type = 1. 
RUN enable_UI.  
RUN show_choices.

IF p_wtype <> "{&WT-CONTROL}" THEN
  UPDATE sl_choices event_type WHEN (display_filters) b_key WHEN (display_filters)
         btn_ok btn_cancel btn_help choice
       WITH FRAME f_events.
ELSE
  UPDATE sl_choices event_type WHEN (display_filters)
         btn_ok btn_cancel btn_help choice
       WITH FRAME f_events.
&ANALYZE-RESUME

/******************************************************************/
/*                     Internal Procedures                        */
/******************************************************************/
/* Default Enabling Procedure */
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI _DEFAULT-ENABLE 
PROCEDURE enable_UI.

DO WITH FRAME f_events:

  IF (display_filters = NO) THEN
  DO:
    /* Adjust the layout to hide the event filters. */
    ASSIGN FRAME f_events:HIDDEN = TRUE
           FilterTitle:HIDDEN   = TRUE
           event_type:HIDDEN    = TRUE
           b_key:HIDDEN         = TRUE
           NO-ERROR.

    ASSIGN FilterTitle:COL  = 2
           event_type:COL   = 2
           b_key:COL        = 2
           NO-ERROR.

    ASSIGN btn_Help:COL = (btn_cancel:COL + btn_cancel:WIDTH + 2) NO-ERROR.
    ASSIGN FRAME f_events:WIDTH =
           (btn_help:COL + btn_help:WIDTH + 2) NO-ERROR.

  END.

  DISPLAY sl_choices WITH FRAME f_events.

  /* Show the current choice, if it fits */
  IF (sl_choices:LOOKUP(choice) > 0) THEN sl_choices:SCREEN-VALUE = choice.
  ELSE sl_choices:SCREEN-VALUE = ?.

  IF display_filters THEN
  DO:
    DISPLAY choice sl_choices event_type
      WITH FRAME f_events.
  END.

  IF NOT p_cur_win_type  /* If not GUI, disable non-tty events. */
  THEN ASSIGN method_return = event_type:DISABLE("Direct Manipulation Events")
              method_return = event_type:DISABLE("Portable Mouse Events")
              method_return = event_type:DISABLE("Three-Button Mouse Events")
              .
  /*
   * VBX Controls handle character events through VBX events 
   */
  IF p_wtype = "{&WT-CONTROL}" 
  THEN ASSIGN method_return = event_type:DISABLE("Portable Mouse Events")
              method_return = event_type:DISABLE("Three-Button Mouse Events")
              . 
END. /* WITH */
END PROCEDURE. 
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE show_choices _DEFAULT-ENABLE 
PROCEDURE show_choices.
  /* show_choices: Looks at the event_type and sets the choices selection list. */
  DEF VAR h AS WIDGET NO-UNDO.
  DEF VAR lst AS CHAR NO-UNDO.
          
  /* Show name for possibilities */
  CASE event_type:
    WHEN 1 THEN possibilities = IF p_wtype = "ALL" 
                                THEN "Common Events:"
                                ELSE IF p_wtype = "{&WT-CONTROL}"
                                    THEN ("Common " 
                                         + "{&WT-CONTROL}"
                                         + " Events:")
                                ELSE ("Common " 
                                     + SUBSTRING(p_wtype, 1, 1)
                                     + LC(SUBSTRING(p_wtype, 2))
                                     + " Events:").
    WHEN 2 THEN possibilities = "Direct Manipulation Events (GUI only):".
    WHEN 3 THEN possibilities = "Portable Mouse Events (GUI only):".
    WHEN 4 THEN possibilities = "Three-Button Mouse Events (GUI only):".
    WHEN 5 THEN possibilities = "Developer Events:".
  END CASE.
  DISPLAY possibilities WITH FRAME f_events.
  
  /* Now compute the possibilites */
  ASSIGN h              = (sl_choices:HANDLE IN FRAME f_events)
         h:SCREEN-VALUE = ?
         h:LIST-ITEMS   = "".

  IF NOT special_events_only THEN
  DO:
  CASE event_type:
    /* Best Choices - should be dependent on widget type ...*/
    WHEN 1 THEN DO:
      CASE p_wtype:
        WHEN "ALL":U THEN /* List all events */
          lst = "ANY-KEY,ANY-PRINTABLE,CHOOSE,CLEAR,DDE-NOTIFY,":U +
          "DEFAULT-ACTION,DEFINE_QUERY,DROP-FILE-NOTIFY,END-ERROR,END-SEARCH,ENDKEY,ENTRY,":U +
          "GO,HELP,ITERATION-CHANGED,LEAVE,MENU-DROP,OFF-END,OFF-HOME,":U +
          "PARENT-WINDOW-CLOSE,RECALL,ROW-DISPLAY,ROW-ENTRY,ROW-LEAVE,":U + 
          "SCROLL-NOTIFY,START-SEARCH,VALUE-CHANGED,WINDOW-CLOSE,":U + 
          "WINDOW-MAXIMIZED,WINDOW-MINIMIZED,WINDOW-RESTORED,WINDOW-RESIZED":U.
        WHEN "BROWSE":U THEN
          lst = "ANY-KEY,ANY-PRINTABLE,DEFAULT-ACTION,":U + 
                (IF p_other = "FFQ" THEN "DEFINE_QUERY,":U ELSE "":U) +
                "DROP-FILE-NOTIFY,END,ENDKEY,END-ERROR,":U +
                "END-SEARCH,ENTRY,GO,HELP,HOME,ITERATION-CHANGED,LEAVE,":U +
                "OFF-END,OFF-HOME,ROW-DISPLAY,ROW-ENTRY,ROW-LEAVE,":U +
                "SCROLL-NOTIFY,START-SEARCH,VALUE-CHANGED":U.
        WHEN "DIALOG-BOX":U THEN
          lst = "WINDOW-CLOSE,DROP-FILE-NOTIFY,END-ERROR,ENDKEY,ENTRY,":U +
                (IF p_other = "FFQ" THEN "DEFINE_QUERY,":U ELSE "":U) +
                "GO,HELP,LEAVE":U.
        WHEN "FRAME":U THEN
          lst = "DDE-NOTIFY,":U +
                (IF p_other = "FFQ" THEN "DEFINE_QUERY,":U ELSE "":U) +
                "DROP-FILE-NOTIFY,END-ERROR,ENDKEY,ENTRY,GO,HELP,LEAVE":U.
        WHEN "IMAGE":U OR WHEN "RECTANGLE":U OR WHEN "TEXT":U THEN
          lst = "MOUSE-SELECT-CLICK,MOUSE-SELECT-DBLCLICK":U.
        WHEN "MENU-ITEM":U THEN 
          lst = IF p_wSub eq "NORMAL":U THEN "CHOOSE":U ELSE "VALUE-CHANGED":U.
        WHEN "QUERY":U THEN
          lst = "DEFINE_QUERY":U.
        WHEN "SUB-MENU" OR WHEN "MENU" THEN
          lst = IF p_wSub eq "MENUBAR" THEN "":U ELSE "MENU-DROP":U.
        WHEN "WINDOW":U THEN
          lst = "DROP-FILE-NOTIFY,ENTRY,HELP,LEAVE,PARENT-WINDOW-CLOSE,WINDOW-CLOSE,":U +
                "WINDOW-MAXIMIZED,WINDOW-MINIMIZED,WINDOW-RESTORED,":U + 
                "WINDOW-RESIZED":U.
        WHEN "{&WT-CONTROL}" THEN
          lst = "ENTRY,LEAVE,HELP,TAB,BACK-TAB,GO,END-ERROR":U.
        OTHERWISE /* All field-level widgets */
        DO:
          IF display_filters THEN
          lst = "ANY-KEY,ANY-PRINTABLE,":U
              + (IF p_wtype = "BUTTON":U THEN "CHOOSE,":U ELSE "")
              + (IF p_wtype = "SELECTION-LIST":U THEN "DEFAULT-ACTION,":U ELSE "":U)
              + "DROP-FILE-NOTIFY,END-ERROR,ENDKEY,ENTRY,GO,HELP,LEAVE":U
              + (IF CAN-DO("COMBO-BOX,EDITOR,FILL-IN,RADIO-SET,SELECTION-LIST,SLIDER,TOGGLE-BOX":U,
                           p_wtype) 
                 THEN ",VALUE-CHANGED":U ELSE "":U)
          .
        END.
      END CASE.
      IF (p_other <> "FFQ":U) AND (NUM-ENTRIES(p_other) > 0) THEN
          lst = (lst + "," + p_other).
    END. /* WHEN 1: */

    /* Direct Manipulation Mouse Events */
    WHEN 2 THEN DO:
      CASE p_wtype:
        WHEN "WINDOW":U  THEN lst = "WINDOW-RESIZED":U.
        WHEN "MENU" OR WHEN "SUB-MENU" OR WHEN "MENU-ITEM" THEN lst = "":U.
        OTHERWISE DO:
          lst = "SELECTION,DESELECTION".
          IF p_wtype NE "DIALOG-BOX":U THEN lst = lst +
                 ",START-MOVE,END-MOVE,START-RESIZE,END-RESIZE":U.
           /* Frames have additional direct manipulation events */
          IF CAN-DO("ALL,DIALOG-BOX,FRAME":U, p_wtype) THEN lst = lst + 
                 ",EMPTY-SELECTION,START-BOX-SELECTION,END-BOX-SELECTION":U.
           /* Browsers have additional direct manipulation events */
          IF CAN-DO("ALL,BROWSE":U, p_wtype) THEN lst = lst +
                 ",START-ROW-RESIZE,END-ROW-RESIZE":U.
          /* Don't forget to add the window events */
          IF p_wtype = "ALL":U THEN lst = lst + ",WINDOW-RESIZED":U.
        END.
      END CASE.
    END.
    
    /* Portable Mouse Events */
    WHEN 3 THEN
      IF CAN-DO ("MENU,SUB-MENU,MENU-ITEM", p_wtype) THEN lst = "":U.
      ELSE lst =
"MOUSE-SELECT-DOWN,MOUSE-SELECT-UP,MOUSE-SELECT-CLICK,MOUSE-SELECT-DBLCLICK,~
MOUSE-MENU-DOWN,MOUSE-MENU-UP,MOUSE-MENU-CLICK,MOUSE-MENU-DBLCLICK,~
MOUSE-EXTEND-DOWN,MOUSE-EXTEND-UP,MOUSE-EXTEND-CLICK,MOUSE-EXTEND-DBLCLICK,~
MOUSE-MOVE-DOWN,MOUSE-MOVE-UP,MOUSE-MOVE-CLICK,MOUSE-MOVE-DBLCLICK":U.

    /* 3-Button Mouse Events */
    WHEN 4 THEN
      IF CAN-DO ("MENU,SUB-MENU,MENU-ITEM", p_wtype) THEN lst = "":U.
      ELSE lst =
"LEFT-MOUSE-DOWN,LEFT-MOUSE-UP,LEFT-MOUSE-CLICK,LEFT-MOUSE-DBLCLICK,~
MIDDLE-MOUSE-DOWN,MIDDLE-MOUSE-UP,MIDDLE-MOUSE-CLICK,MIDDLE-MOUSE-DBLCLICK,~
RIGHT-MOUSE-DOWN,RIGHT-MOUSE-UP,RIGHT-MOUSE-CLICK,RIGHT-MOUSE-DBLCLICK":U.

    /* User specified events */
    WHEN 5 THEN lst = "U1,U2,U3,U4,U5,U6,U7,U8,U9,U10":U.
      
  END CASE.
  END.
  ELSE
  DO:
    ASSIGN lst = p_other.
  END.

  /* Display possibilities */
  h:LIST-ITEMS = TRIM(lst, ",":U).
  
END PROCEDURE. /* show_choices. */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


