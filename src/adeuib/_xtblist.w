&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME f_dlg
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: _xtblist.w

  Description: Let the user view and modify a list of tables (in the form
               db.table).

  Input-Output Parameters:
      pcTblList - Comma delimeted list of tables.


  Author: Wm.T.Wood 

  Created: February 15, 1995

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
&IF DEFINED(UIB_is_Running) eq 0 &THEN
  DEFINE INPUT-OUTPUT PARAMETER pcTblList AS CHAR NO-UNDO.
&ELSE
  DEFINE VAR pcTblList AS CHAR NO-UNDO INITIAL "".
&ENDIF

/* Shared Variable Definitions ---                                      */
&GLOBAL-DEFINE WIN95-BTN YES
{adecomm/adestds.i} /* Standard Definitions                             */ 
{adeuib/uibhlp.i}   /* Help pre-processor directives                    */
{adeuib/uniwidg.i}  /* Necessary for selection of temp-tables           */
DEFINE SHARED VARIABLE _h_win AS WIDGET-HANDLE                    NO-UNDO.

/* Local Variable Definitions --                                        */
DEFINE VAR db_name AS CHAR NO-UNDO.
define var wintitle as char no-undo init "External Tables":L.
DEFINE VAR l_ok        AS LOGICAL     NO-UNDO.
  DEFINE VAR new-item    AS CHARACTER   NO-UNDO.
  DEFINE VAR i           AS INTEGER     NO-UNDO.
  DEFINE VAR fl_name     AS CHARACTER   NO-UNDO.
  DEFINE VAR tt-info     AS CHARACTER   NO-UNDO.




/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f_dlg

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbl-list b_add 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&Scoped-define List-1 b_delete b_move_up b_move_down 




/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b_add 
     LABEL "Add...":L 
     SIZE 15 BY 1.125.

DEFINE BUTTON b_delete 
     LABEL "Delete":L 
     SIZE 15 BY 1.125.

DEFINE BUTTON b_move_down 
     LABEL "Move Down":L 
     SIZE 15 BY 1.125.

DEFINE BUTTON b_move_up 
     LABEL "Move Up":L 
     SIZE 15 BY 1.125.

DEFINE VARIABLE tbl-list AS CHARACTER 
     VIEW-AS SELECTION-LIST MULTIPLE SCROLLBAR-VERTICAL 
     SIZE 39 BY 5.76 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f_dlg
     tbl-list AT ROW 1.52 COL 3 NO-LABEL
     b_add AT ROW 1.52 COL 43
     b_delete AT ROW 3 COL 43
     b_move_up AT ROW 4.52 COL 43
     b_move_down AT ROW 6 COL 43
     SPACE(1.00) SKIP(0.49)
    WITH
    &if DEFINED(IDE-IS-RUNNING) = 0  &then 
    VIEW-AS DIALOG-BOX TITLE wintitle
    &else
    NO-BOX
    &endif
    KEEP-TAB-ORDER NO-HELP 
         SIDE-LABELS THREE-D  SCROLLABLE.



/* *********************** Procedure Settings ************************ */




/* ***************  Runtime Attributes and UIB Settings  ************** */

/* SETTINGS FOR DIALOG-BOX f_dlg
   UNDERLINE Default                                                    */
ASSIGN 
       FRAME f_dlg:SCROLLABLE       = FALSE
       FRAME f_dlg:HIDDEN           = TRUE.

/* SETTINGS FOR BUTTON b_add IN FRAME f_dlg
   NO-DISPLAY                                                           */
/* SETTINGS FOR BUTTON b_delete IN FRAME f_dlg
   NO-DISPLAY NO-ENABLE 1                                               */
/* SETTINGS FOR BUTTON b_move_down IN FRAME f_dlg
   NO-DISPLAY NO-ENABLE 1                                               */
/* SETTINGS FOR BUTTON b_move_up IN FRAME f_dlg
   NO-DISPLAY NO-ENABLE 1                                               */
/* SETTINGS FOR SELECTION-LIST tbl-list IN FRAME f_dlg
   NO-DISPLAY                                                           */
/* _RUN-TIME-ATTRIBUTES-END */

/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME b_add
ON CHOOSE OF b_add IN FRAME f_dlg /* Add... */
DO:
  RUN choose-add-tables.
END.

&Scoped-define SELF-NAME b_delete
ON CHOOSE OF b_delete IN FRAME f_dlg /* Delete */
DO:
  DEFINE VAR i      AS INTEGER NO-UNDO.
  DEFINE VAR choice AS CHAR NO-UNDO.
  DEFINE VAR l_ok   AS LOGICAL NO-UNDO.
  
  choice = tbl-list:SCREEN-VALUE.
  DO i = 1 TO NUM-ENTRIES(choice):
    l_ok = tbl-list:DELETE(ENTRY(i,choice)).
  END.
  /* Select the first item in the list, if available */
  IF tbl-list:NUM-ITEMS eq 0
  THEN DISABLE {&LIST-1} WITH FRAME {&FRAME-NAME}.
  ELSE tbl-list:SCREEN-VALUE = tbl-list:ENTRY(1).
END.

&Scoped-define SELF-NAME b_move_down
ON CHOOSE OF b_move_down IN FRAME f_dlg /* Move Down */
DO:
  DEFINE VAR i           AS INTEGER NO-UNDO.
  DEFINE VAR ipos        AS INTEGER NO-UNDO.
  DEFINE VAR choice      AS CHAR NO-UNDO.
  DEFINE VAR swap-item   AS CHAR NO-UNDO.
  DEFINE VAR choice-item AS CHAR NO-UNDO.
  DEFINE VAR new-swap    AS CHAR NO-UNDO.
  DEFINE VAR new-choice  AS CHAR NO-UNDO.
  DEFINE VAR l_ok        AS LOGICAL NO-UNDO.
  
  ASSIGN choice = tbl-list:SCREEN-VALUE.
  DO i = NUM-ENTRIES(choice) TO 1 BY -1:
    ASSIGN choice-item = ENTRY (i,choice) 
           ipos        = tbl-list:LOOKUP(choice-item)
           .
    IF ipos < tbl-list:NUM-ITEMS THEN DO:
      /* Get the item above the current choice and swap it with the 
         current choice. */
      swap-item  = tbl-list:ENTRY(ipos + 1).
      IF LOOKUP(swap-item,choice) eq 0
      THEN ASSIGN
             new-choice = choice-item
             new-swap   = swap-item
             l_ok = tbl-list:REPLACE( new-choice, swap-item)
             l_ok = tbl-list:REPLACE( new-swap, choice-item)
             ENTRY(i,choice) = new-choice.
    END.
  END.
  /* reset the value of the choice. */
  tbl-list:SCREEN-VALUE = choice.
END.

&Scoped-define SELF-NAME b_move_up
ON CHOOSE OF b_move_up IN FRAME f_dlg /* Move Up */
DO:
  DEFINE VAR i           AS INTEGER NO-UNDO.
  DEFINE VAR ipos        AS INTEGER NO-UNDO.
  DEFINE VAR choice      AS CHAR NO-UNDO.
  DEFINE VAR swap-item   AS CHAR NO-UNDO.
  DEFINE VAR choice-item AS CHAR NO-UNDO.
  DEFINE VAR new-swap    AS CHAR NO-UNDO.
  DEFINE VAR new-choice  AS CHAR NO-UNDO.
  DEFINE VAR l_ok        AS LOGICAL NO-UNDO.
  
  ASSIGN choice = tbl-list:SCREEN-VALUE.
  DO i = 1 TO NUM-ENTRIES(choice):
    ASSIGN choice-item = ENTRY (i,choice) 
           ipos        = tbl-list:LOOKUP (choice-item).
    IF ipos > 1 THEN DO:
      /* Get the item above the current choice and swap it with the '
         current choice. */
      swap-item  = tbl-list:ENTRY(ipos - 1).
      IF LOOKUP(swap-item,choice) eq 0
      THEN ASSIGN
             new-choice = choice-item
             new-swap   = swap-item
             l_ok = tbl-list:REPLACE( new-swap, choice-item)
             l_ok = tbl-list:REPLACE( new-choice, swap-item)
             ENTRY(i,choice) = new-choice.
    END.
  END.
  /* reset the value of the choice. */
  tbl-list:SCREEN-VALUE = choice.
END.

&Scoped-define SELF-NAME tbl-list
ON VALUE-CHANGED OF tbl-list IN FRAME f_dlg
DO:
  /* LIST-1 buttons are disabled if the list is empty */
  IF b_delete:SENSITIVE AND SELF:SCREEN-VALUE eq ""
  THEN DISABLE {&LIST-1} WITH FRAME {&FRAME-NAME}.
  ELSE IF NOT b_delete:SENSITIVE AND SELF:SCREEN-VALUE ne "" 
  THEN DO:
    /* Don't enable the "Move Up/Down" buttons if only one item in list */
    ASSIGN b_delete:SENSITIVE = YES
           b_move_up:SENSITIVE = (tbl-list:NUM-ITEMS > 1)
           b_move_down:SENSITIVE = b_move_up:SENSITIVE
           .
  END.
END.

&UNDEFINE SELF-NAME

/* *************************  Standard Buttons ************************ */

{ adecomm/okbar.i &TOOL = "AB"
                  &CONTEXT = {&External_Tables_Dlg_Box}
                  }
FRAME {&FRAME-NAME}:DEFAULT-BUTTON = btn_OK:HANDLE.

/* ***************************  Main Block  *************************** */

&if DEFINED(IDE-IS-RUNNING) = 0  &then
/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.
&ENDIF

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

/* Populate the selection list */
tbl-list:LIST-ITEMS = pcTblList.
/* If pcTblList is empty, just add some tables and return */
IF pcTblList eq "" THEN DO:
  /** this is ok for ide event as the addtables will use hte currently active dialog 
      intended for xtbllist */
  RUN add-tables.
  /* Return the current value in the list. */
  pcTblList = tbl-list:LIST-ITEMS.   
END.
ELSE DO:
   
    {adeuib/ide/dialoginit.i "FRAME f_dlg:handle"}
    &if DEFINED(IDE-IS-RUNNING) <> 0  &then
    dialogService:View(). 
    &endif
    /* Now enable the interface and wait for the exit condition.            */
    /* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
    &scoped-define CANCEL-EVENT U2
    {adeuib/ide/dialogstart.i btn_ok btn_cancel wintitle}
    MAIN-BLOCK:
    DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
       ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
        RUN enable_UI.
    &if DEFINED(IDE-IS-RUNNING) = 0  &then
        WAIT-FOR GO OF FRAME {&FRAME-NAME}. 
    &ELSE
        WAIT-FOR "choose" of btn_ok in frame {&FRAME-NAME} or "u2" of this-procedure.       
        if cancelDialog THEN UNDO, LEAVE.  
    &endif
    
       /* Return the current value in the list. */
       pcTblList = tbl-list:LIST-ITEMS.
       /* Note that LIST-ITEMS will be "?" if the list is empty. */
       IF pcTblList eq ? THEN pcTblList = "".
    END.
    RUN disable_UI.
END.

/* **********************  Internal Procedures  *********************** */
PROCEDURE choose-add-tables :
    &if DEFINED(IDE-IS-RUNNING) <> 0  &then
        dialogService:SetCurrentEvent(this-procedure,"add-tables").
        run runChildDialog in hOEIDEService (dialogService) .
    &else 
        run add-tables.   
    &endif
end procedure.    

PROCEDURE add-tables :
/*------------------------------------------------------------------------------
  Purpose:      Add tables to the list of tables.  
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FIND _P WHERE _P._WINDOW-HANDLE = _h_win.
  /* Omit D and W types-- those are used to track temp-table info for
     SmartDataViewer and Web-Objects by AB and not meant to be exposed to
     user here. jep-code 4/22/98 */
  IF CAN-FIND(FIRST _TT WHERE _TT._p-recid = RECID(_P)
                          AND NOT CAN-DO("D,W":U,_TT._TABLE-TYPE)) THEN
  DO:
    FOR EACH _TT WHERE _TT._p-recid = RECID(_P)
                   AND NOT CAN-DO("D,W":U,_TT._TABLE-TYPE):
      tt-info = tt-info + ",":U + _TT._LIKE-DB + ".":U + _TT._LIKE-TABLE +
                "|":U + (IF _TT._NAME = ? THEN "?":U ELSE _TT._NAME).
    END.
    tt-info = LEFT-TRIM(tt-info,",":U).
  END.
  ELSE tt-info = ?.
  /* Select some tables */
  &if DEFINED(IDE-IS-RUNNING) <> 0  &then
      RUN adeuib/ide/_dialog_tblsel.p (true, tt-info, INPUT-OUTPUT db_name,
                                       INPUT-OUTPUT fl_name,
                                       OUTPUT l_OK). 
  &else    
  
      RUN adecomm/_tblsel.p (true, tt-info, INPUT-OUTPUT db_name,
                             INPUT-OUTPUT fl_name,
                             OUTPUT l_OK).
  &endif
  /* Add any new tables (unless they are already in the list). */
  IF l_OK THEN DO WITH FRAME {&FRAME-NAME}:
    DO i = 1 TO NUM-ENTRIES(fl_name):
      new-item = db_name + ".":U + ENTRY(i, fl_name).
      IF tbl-list:LOOKUP(new-item) eq 0 
      THEN l_OK = tbl-list:ADD-LAST(new-item).
    END.
  END.
END PROCEDURE.



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
  HIDE FRAME f_dlg.
END PROCEDURE.



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
  ENABLE tbl-list b_add 
      WITH FRAME f_dlg.
  VIEW FRAME f_dlg.
  {&OPEN-BROWSERS-IN-QUERY-f_dlg}
END PROCEDURE.
  