&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME f_dlg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS f_dlg 
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f_dlg

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbl-list b_add 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&Scoped-define List-1 b_delete b_move_up b_move_down 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



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
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER NO-HELP 
         SIDE-LABELS THREE-D  SCROLLABLE 
         TITLE "External Tables":L.

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
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
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME b_add
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_add f_dlg
ON CHOOSE OF b_add IN FRAME f_dlg /* Add... */
DO:
  RUN add-tables.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_delete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_delete f_dlg
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_move_down
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_move_down f_dlg
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_move_up
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_move_up f_dlg
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tbl-list
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tbl-list f_dlg
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK f_dlg 


/* *************************  Standard Buttons ************************ */

{ adecomm/okbar.i &TOOL = "AB"
                  &CONTEXT = {&External_Tables_Dlg_Box}
                  }
FRAME {&FRAME-NAME}:DEFAULT-BUTTON = btn_OK:HANDLE.

/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

/* Populate the selection list */
tbl-list:LIST-ITEMS = pcTblList.

/* If pcTblList is empty, just add some tables and return */
IF pcTblList eq "" THEN DO:
  RUN add-tables.
  /* Return the current value in the list. */
  pcTblList = tbl-list:LIST-ITEMS.   
END.
ELSE DO:
  /* Now enable the interface and wait for the exit condition.            */
  /* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
  MAIN-BLOCK:
  DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
     ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
    RUN enable_UI.
    WAIT-FOR GO OF FRAME {&FRAME-NAME}.
    /* Return the current value in the list. */
    pcTblList = tbl-list:LIST-ITEMS.
    /* Note that LIST-ITEMS will be "?" if the list is empty. */
    IF pcTblList eq ? THEN pcTblList = "".
  END.
  RUN disable_UI.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE add-tables f_dlg 
PROCEDURE add-tables :
/*------------------------------------------------------------------------------
  Purpose:      Add tables to the list of tables.  
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR l_ok        AS LOGICAL     NO-UNDO.
  DEFINE VAR new-item    AS CHARACTER   NO-UNDO.
  DEFINE VAR i           AS INTEGER     NO-UNDO.
  DEFINE VAR fl_name     AS CHARACTER   NO-UNDO.
  DEFINE VAR tt-info     AS CHARACTER   NO-UNDO.

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
  RUN adecomm/_tblsel.p (true, tt-info, INPUT-OUTPUT db_name,
                         INPUT-OUTPUT fl_name,
                         OUTPUT l_OK).

  /* Add any new tables (unless they are already in the list). */
  IF l_OK THEN DO WITH FRAME {&FRAME-NAME}:
    DO i = 1 TO NUM-ENTRIES(fl_name):
      new-item = db_name + ".":U + ENTRY(i, fl_name).
      IF tbl-list:LOOKUP(new-item) eq 0 
      THEN l_OK = tbl-list:ADD-LAST(new-item).
    END.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI f_dlg _DEFAULT-DISABLE
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI f_dlg _DEFAULT-ENABLE
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


