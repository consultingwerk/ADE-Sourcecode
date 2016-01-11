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
/*
* _aint.p
*
*    This module handles the admin's integration procedures.
*/

&GLOBAL-DEFINE WIN95-BTN YES

&Scoped-define FRAME-NAME aint

{ aderes/s-system.i }
{ aderes/s-define.i }
{ adecomm/adestds.i }
{ aderes/_alayout.i }
{ aderes/reshlp.i }

/* The code title has to cover the fillin as well as the button,
 * which is ADM_H_SLIST_OFF + ADM_H_GAP + ADM_W_BUTTON */
DEFINE VARIABLE cTitle      AS CHARACTER NO-UNDO FORMAT "X(44)":u.

DEFINE VARIABLE dirty       AS LOGICAL   NO-UNDO INITIAL FALSE.
DEFINE VARIABLE hooks       AS CHARACTER NO-UNDO.
DEFINE VARIABLE iTitle      AS CHARACTER NO-UNDO FORMAT "X({&ADM_W_SLIST})":u.
DEFINE VARIABLE program     AS CHARACTER NO-UNDO.
DEFINE VARIABLE temp_list   AS CHARACTER NO-UNDO EXTENT {&ahHookSize}.
DEFINE VARIABLE work_around AS INTEGER   NO-UNDO INITIAL 1.

DEFINE BUTTON codeFile LABEL "&Files...":L
  SIZE 11 BY {&H_OKBTN}.

{ aderes/_asbar.i }

/* ************************  Frame Definitions  *********************** */

FORM
  SKIP({&VM_WID})

  iTitle AT {&ADM_X_START} VIEW-AS TEXT
  SKIP({&VM_WID})

  hooks AT {&ADM_X_START} NO-LABEL
    VIEW-AS SELECTION-LIST SINGLE SCROLLBAR-VERTICAL SCROLLBAR-HORIZONTAL
    INNER-CHARS 40 INNER-LINES 9
  SKIP({&VM_WID})

  SKIP({&TFM_WID})
  cTitle AT {&ADM_X_START} VIEW-AS TEXT

  program AT {&ADM_X_START} FORMAT "X(128)":u NO-LABEL {&STDPH_FILL}
    VIEW-AS FILL-IN SIZE {&ADM_W_SFILL} BY {&H_OKBTN}

  codeFile AT ROW-OF program COLUMN-OF program + {&ADM_H_SFILL_OFF}

  /* The rectangle is needed to make the Sullivan Bar show up
     under the selection list */
  SKIP({&VM_WID})

  { adecomm/okform.i 
    &BOX    = rect_btns
    &STATUS = NO
    &OK     = qbf-ok
    &CANCEL = qbf-ee
    &HELP   = qbf-help}

  WITH FRAME {&FRAME-NAME}
  VIEW-AS DIALOG-BOX NO-LABELS SIDE-LABELS THREE-D
  DEFAULT-BUTTON qbf-ok CANCEL-BUTTON qbf-ee SCROLLABLE
  TITLE "Integration Procedures":L.

ON CHOOSE OF codeFile IN FRAME {&FRAME-NAME} DO: /* File ... */
  DEFINE VARIABLE f-name AS CHARACTER NO-UNDO.
  DEFINE VARIABLE ans    AS LOGICAL   NO-UNDO.

  RUN adecomm/_getfile.p (?, "", "", "Link Procedure to Option", "OPEN":u,
                          INPUT-OUTPUT f-name, OUTPUT ans).

  IF f-name <> "" THEN DO:
    APPLY "ENTRY":u TO program.
    program:SCREEN-VALUE = f-name.
    APPLY "LEAVE":u TO program.
  END.
END.

ON DEFAULT-ACTION OF hooks IN FRAME {&FRAME-NAME}
  APPLY "ENTRY":u TO program.

ON VALUE-CHANGED OF hooks IN FRAME {&FRAME-NAME} DO:
  DEFINE VARIABLE hookIndex AS INTEGER.

  CASE hooks:SCREEN-VALUE:
    WHEN "Logo Screen" THEN 
      hookIndex = {&ahLogo}.
    WHEN "Menu Item Override" THEN 
      hookIndex = {&ahFeatCheckCode}.
    WHEN "Login Program" THEN 
      hookIndex = {&ahLogin}.
    WHEN "Initialize Vars and Interface" THEN 
      hookIndex = {&ahSharedVar}.
    WHEN "Feature Security" THEN 
      hookIndex = {&ahSecFeatCode}.
    WHEN "Table Selection Security" THEN 
      hookIndex = {&ahSecWhereCode}.
    WHEN "Table Security" THEN 
      hookIndex = {&ahSecTableCode}.
    WHEN "Field Security" THEN 
      hookIndex = {&ahSecFieldCode}.
    WHEN "Query Directory Switch" THEN 
      hookIndex = {&ahDirSwitchCode}.
  END.

  /* Change the screen value to what the user wants to see */
  ASSIGN
    program:SCREEN-VALUE = temp_list[hookIndex]
    program              = program:SCREEN-VALUE
    cTitle:SCREEN-VALUE  = "&Procedure for: " + hooks:SCREEN-VALUE
    work_around          = hookIndex
    .
END.

ON ALT-I OF FRAME {&FRAME-NAME}
  APPLY "ENTRY":U TO hooks IN FRAME {&FRAME-NAME}.

ON ALT-P OF FRAME {&FRAME-NAME} 
  APPLY "ENTRY":u TO program IN FRAME {&FRAME-NAME}.

ON GO OF FRAME {&FRAME-NAME} DO:
  DEFINE VARIABLE qbf-i AS INTEGER NO-UNDO.

  IF dirty = FALSE THEN RETURN.

  /* The user has competed and wants the hooks to be stored. Transfer the
     information. */
  RUN adecomm/_setcurs.p ("WAIT":u).

  DO qbf-i = 1 TO {&ahHookSize}:
    qbf-u-hook[qbf-i] = IF (temp_list[qbf-i] = "") THEN ? ELSE temp_list[qbf-i].
  END.

  /* Update the configuration file. That is where this information is 
     stored.  */
  _configDirty = TRUE.
  RUN aderes/_awrite.p (0).
  RUN aderes/_ainti.p.
  RUN adecomm/_setcurs.p ("").
END.

ON LEAVE OF program IN FRAME {&FRAME-NAME} DO:
  DEFINE VARIABLE ans AS LOGICAL NO-UNDO.

  IF program:SCREEN-VALUE = program THEN RETURN.
  RUN save_old (work_around).
END.

/*--------------------------- Main Block ------------------------- */
FRAME {&FRAME-NAME}:HIDDEN = TRUE.

{ aderes/_arest.i 
  &FRAME-NAME = {&FRAME-NAME}
  &HELP-NO    = {&Options_Dlg_Box}}

{ adecomm/okrun.i 
  &FRAME = "FRAME {&FRAME-NAME}"
  &BOX   = rect_btns
  &OK    = qbf-ok
  &HELP  = qbf-help}

ASSIGN
  hooks:SENSITIVE             = TRUE
  program:SENSITIVE           = TRUE
  codeFile:SENSITIVE          = TRUE
  iTitle:SENSITIVE            = TRUE
  cTitle:SENSITIVE            = TRUE
  iTitle:SCREEN-VALUE         = "&Integration Point:"
  .

RUN init_hooks_list.

FRAME {&FRAME-NAME}:HIDDEN = FALSE.

DO ON ERROR UNDO, LEAVE ON ENDKEY UNDO, LEAVE:
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.

/* ----------------------------------------------------------- */
PROCEDURE init_hooks_list:
  DEFINE VARIABLE ans     AS LOGICAL NO-UNDO.
  DEFINE VARIABLE qbf-i   AS INTEGER NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      ans = hooks:ADD-LAST("Feature Security")
      ans = hooks:ADD-LAST("Field Security")
      ans = hooks:ADD-LAST("Initialize Vars and Interface")
      ans = hooks:ADD-LAST("Login Program")
      ans = hooks:ADD-LAST("Logo Screen")
      ans = hooks:ADD-LAST("Menu Item Override")
      ans = hooks:ADD-LAST("Query Directory Switch")
      ans = hooks:ADD-LAST("Table Security")
      ans = hooks:ADD-LAST("Table Selection Security")
      .

    /*
    * Copy the information from the permanent data structure. This
    * preserves the original values if the user hits cancel.
    * If the user chooses ok, the values are copied back.
    * Each time the user changes a value it is validated immediately.
    */
    DO qbf-i = 1 TO {&ahHookSize}:
      temp_list[qbf-i] = IF (qbf-u-hook[qbf-i] = ?) 
                         THEN "" ELSE qbf-u-hook[qbf-i].
    END.

    ASSIGN
      hooks:SCREEN-VALUE   = hooks:ENTRY(1)
      program:SCREEN-VALUE = temp_list[{&ahSecFeatCode}]
      program              = program:SCREEN-VALUE
      work_around          = {&ahSecFeatCode}
      cTitle:SCREEN-VALUE  = "&Procedure for: " + hooks:SCREEN-VALUE
      .
  END.
END PROCEDURE.

/* ----------------------------------------------------------- */
PROCEDURE save_old:
  DEFINE INPUT PARAMETER slot AS INTEGER NO-UNDO.

  ASSIGN
    program         = REPLACE(program:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                              CHR(10)," ":u)
    dirty           = TRUE
    temp_list[slot] = program.
  .
END PROCEDURE.

&UNDEFINE FRAME-NAME

/* _aint.p - end of file */

