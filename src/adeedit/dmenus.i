/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*---------------------------------------------------------------------------
  dmenus.i
  DEFINE MENUS for Editor
----------------------------------------------------------------------------*/

/* The conditional menu accelerator definitions below are used to support
   menu accelerators in both GUI and TTY environments.  The TTY accelerators
   follow the keyfunction mappings defined in adeedit/dbftrigs.i.
*/

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
DEFINE VARIABLE mi_mrulist  AS HANDLE    EXTENT 9 NO-UNDO.
DEFINE VARIABLE mi_rule     AS HANDLE             NO-UNDO.

DEFINE TEMP-TABLE mruWork LIKE MRU_Files.
&ENDIF

DEFINE VARIABLE mi_AddRepos AS HANDLE             NO-UNDO.
DEFINE VARIABLE mi_rule_pr1 AS HANDLE             NO-UNDO.
DEFINE VARIABLE mi_Print    AS HANDLE             NO-UNDO.
DEFINE VARIABLE mi_rule_pr2 AS HANDLE             NO-UNDO.
DEFINE VARIABLE mi_Exit     AS HANDLE             NO-UNDO.

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN

/* File */
&SCOPED-DEFINE NEW-ACCEL        "SHIFT-F3"
&SCOPED-DEFINE OPEN-ACCEL       "F3"
&SCOPED-DEFINE CLOSE-ACCEL      "F8"
&SCOPED-DEFINE PWIN-ACCEL       "CTRL-F3"
&SCOPED-DEFINE SAVE-ACCEL       "F6"
&SCOPED-DEFINE SAVEAS-ACCEL     "SHIFT-F6"
/* Edit */
&SCOPED-DEFINE UNDO-ACCEL       "CTRL-Z"
&SCOPED-DEFINE CUT-ACCEL        "CTRL-X"
&SCOPED-DEFINE COPY-ACCEL       "CTRL-C"
&SCOPED-DEFINE PASTE-ACCEL      "CTRL-V"
/* Search */
&SCOPED-DEFINE FIND-ACCEL       "CTRL-F"
&SCOPED-DEFINE FIND-NEXT-ACCEL  "F9"
&SCOPED-DEFINE FIND-PREV-ACCEL  "SHIFT-F9"
&SCOPED-DEFINE REPLACE-ACCEL    "CTRL-R"
&SCOPED-DEFINE GOTOLINE-ACCEL   "CTRL-G"
/* Buffers */
&SCOPED-DEFINE LIST-ACCEL       "CTRL-L"
&SCOPED-DEFINE NEXT-ACCEL       "F7"
&SCOPED-DEFINE PREV-ACCEL       "SHIFT-F7"
/* Compile */
&SCOPED-DEFINE RUN-ACCEL        KBLABEL("GO")
&SCOPED-DEFINE CHECK-ACCEL      "SHIFT-F2"
&SCOPED-DEFINE DEBUG-ACCEL      "SHIFT-F4"
&SCOPED-DEFINE CMSG-ACCEL       "CTRL-E"

&ELSE

/* File */
&SCOPED-DEFINE NEW-ACCEL        KBLABEL("NEW")
&SCOPED-DEFINE OPEN-ACCEL       KBLABEL("GET")
&SCOPED-DEFINE CLOSE-ACCEL      KBLABEL("CLEAR")
&SCOPED-DEFINE SAVE-ACCEL       KBLABEL("PUT")
&SCOPED-DEFINE SAVEAS-ACCEL     KBLABEL("SAVE-AS")
/* Edit */
&SCOPED-DEFINE CUT-ACCEL        KBLABEL("CUT")
&SCOPED-DEFINE COPY-ACCEL       KBLABEL("COPY")
&SCOPED-DEFINE PASTE-ACCEL      KBLABEL("PASTE")
/* Search */
&SCOPED-DEFINE FIND-ACCEL       KBLABEL("FIND")
&SCOPED-DEFINE FIND-NEXT-ACCEL  KBLABEL("FIND-NEXT")
&SCOPED-DEFINE FIND-PREV-ACCEL  KBLABEL("FIND-PREVIOUS")
&SCOPED-DEFINE REPLACE-ACCEL    KBLABEL("REPLACE")
&SCOPED-DEFINE GOTOLINE-ACCEL   KBLABEL("GOTO")
/* Buffers */
&SCOPED-DEFINE LIST-ACCEL       KBLABEL("BREAK-LINE")
&SCOPED-DEFINE NEXT-ACCEL       KBLABEL("NEXT-FRAME")
&SCOPED-DEFINE PREV-ACCEL       KBLABEL("PREV-FRAME")
/* Compile */
&SCOPED-DEFINE RUN-ACCEL        KBLABEL("GO")
&SCOPED-DEFINE CHECK-ACCEL      KBLABEL("COMPILE")
&SCOPED-DEFINE DEBUG-ACCEL      ?
&SCOPED-DEFINE CMSG-ACCEL       ?

&ENDIF

/* Menu definitions here must be kept in sync with Procedure
   MenuAccelInit in adeedit/pmenus.i. Any added items, removed
   items, or items whose internal menu-item names are changed
   must be reflected in MenuAccelInit. -jep 06/29/99 */
   
/* Note: Triggers are defined here with the menu item definitions so that
   when they are referenced on more than one main menubar, their trigger
   actions will always fire correctly. See notes in on-line programming help
   for menu-items regarding using the ON statement vs TRIGGER define block
   when referencing the same sub-menu on more than one main menu.
   -jep 06/29/99 */
   
DEFINE SUB-MENU mnu_File
  MENU-ITEM _New       LABEL "&New      " ACCELERATOR {&NEW-ACCEL}
  TRIGGERS:
    ON CHOOSE RUN NewFile.
  END.
  MENU-ITEM _Open      LABEL "&Open...  " ACCELERATOR {&OPEN-ACCEL}
  TRIGGERS:
    ON CHOOSE RUN OpenFile.
  END.
  MENU-ITEM _Close     LABEL "&Close    " ACCELERATOR {&CLOSE-ACCEL}
  TRIGGERS:
    ON CHOOSE RUN CloseFile ( INPUT ProEditor ) .
  END.
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  RULE
  MENU-ITEM _New_PW    LABEL "New Procedure &Window" ACCELERATOR {&PWIN-ACCEL}
  TRIGGERS:
    ON CHOOSE RUN NewPW.
  END.
&ENDIF
  RULE
  MENU-ITEM _Save      LABEL "&Save      "       ACCELERATOR {&SAVE-ACCEL}
  TRIGGERS:
    ON CHOOSE RUN SaveFile (INPUT ProEditor ) .
  END.
  MENU-ITEM _Save_as   LABEL "Save &As..." ACCELERATOR {&SAVEAS-ACCEL}
  TRIGGERS:
    ON CHOOSE RUN SaveAsFile ( INPUT ProEditor ) .
  END.

/* IZ 2513 Add to Repository and Print menu items are created dynamically in adeedit/pinit.i. */

DEFINE SUB-MENU mnu_Edit
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  MENU-ITEM _Undo           LABEL "&Undo"             ACCELERATOR {&UNDO-ACCEL}
  TRIGGERS:
    ON CHOOSE RUN EditUndo ( ProEditor ) .
  END.
  RULE
&ENDIF
  MENU-ITEM _Cut            LABEL "Cu&t             " ACCELERATOR {&CUT-ACCEL}
  TRIGGERS:
    ON CHOOSE RUN EditCut ( ProEditor ) .
  END.
  MENU-ITEM _Copy           LABEL "&Copy            " ACCELERATOR {&COPY-ACCEL}
  TRIGGERS:
    ON CHOOSE RUN EditCopy ( ProEditor ) .
  END.
  MENU-ITEM _Paste          LABEL "&Paste           " ACCELERATOR {&PASTE-ACCEL}
  TRIGGERS:
    ON CHOOSE RUN EditPaste ( ProEditor ) .
  END.
  RULE
  MENU-ITEM _Insert_File    LABEL "&Insert File...  "
  TRIGGERS:
    ON CHOOSE RUN InsertFile ( ProEditor ) .
  END.
  MENU-ITEM _Field_Selector LABEL "Insert Fie&lds..."
  TRIGGERS:
    ON CHOOSE RUN FieldSelector( ProEditor ).
  END.
  .

  DEFINE SUB-MENU mnu_Search
  MENU-ITEM _Find      LABEL "&Find...      " ACCELERATOR {&FIND-ACCEL}
  TRIGGERS:
    ON CHOOSE RUN FindText( INPUT ProEditor ) .
  END.
  MENU-ITEM _Find_Next LABEL "Find &Next    " ACCELERATOR {&FIND-NEXT-ACCEL}
  TRIGGERS:
    ON CHOOSE RUN FindNext ( INPUT ProEditor , INPUT Find_Criteria ).
  END.
  MENU-ITEM _Find_Prev LABEL "Find &Previous" ACCELERATOR {&FIND-PREV-ACCEL}
  TRIGGERS:
    ON CHOOSE RUN FindPrev ( INPUT ProEditor , INPUT Find_Criteria ).
  END.
  MENU-ITEM _Replace   LABEL "&Replace...   " ACCELERATOR {&REPLACE-ACCEL}
  TRIGGERS:
    ON CHOOSE RUN ReplaceText ( INPUT ProEditor ) .
  END.
  RULE
  MENU-ITEM _Goto_Line LABEL "&Goto Line... " ACCELERATOR {&GOTOLINE-ACCEL}
  TRIGGERS:
    ON CHOOSE RUN GotoLine ( INPUT ProEditor ) .
  END.
  .

DEFINE SUB-MENU mnu_Buffer
  MENU-ITEM _BuffList    LABEL "&List...        " ACCELERATOR {&LIST-ACCEL}
  TRIGGERS:
    ON CHOOSE RUN BufferList ( INPUT win_ProEdit, INPUT ProEditor ).
  END.
  MENU-ITEM _Next        LABEL "&Next Buffer    " ACCELERATOR {&NEXT-ACCEL}
  TRIGGERS:
    ON CHOOSE RUN NextBuffer.
  END.
  MENU-ITEM _Prev        LABEL "&Previous Buffer" ACCELERATOR {&PREV-ACCEL}
  TRIGGERS:
    ON CHOOSE RUN PrevBuffer.
  END.
  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  MENU-ITEM _BufFont     LABEL "&Font..."
  TRIGGERS:
    ON CHOOSE RUN BufChangeFont ( INPUT ProEditor ) .
  END.
  &ENDIF
  MENU-ITEM _BufSettings LABEL "&Information..."
  TRIGGERS:
    ON CHOOSE RUN DlgBufSettings ( INPUT ProEditor ) .
  END.
  .

DEFINE SUB-MENU mnu_Compile
  MENU-ITEM _Run          LABEL "&Run               " ACCELERATOR {&RUN-ACCEL}
  TRIGGERS:
    ON CHOOSE RUN RunFile( INPUT "RUN" ).
  END.
  MENU-ITEM _Check_Syntax LABEL "&Check Syntax      " ACCELERATOR {&CHECK-ACCEL}
  TRIGGERS:
    ON CHOOSE RUN RunFile( INPUT "CHECK-SYNTAX" ).
  END.
&IF OPSYS <> "VMS" &THEN
  MENU-ITEM _Debug 	  LABEL "&Debug             " ACCELERATOR {&DEBUG-ACCEL}
  TRIGGERS:
    ON CHOOSE RUN RunFile( INPUT "DEBUG" ).
  END.
&ENDIF
  RULE
  MENU-ITEM _Comp_Msgs    LABEL "Compiler &Messages..." ACCELERATOR {&CMSG-ACCEL}
  TRIGGERS:
    ON CHOOSE RUN CompilerMessages.
  END.
  .

/* ADE Standard Tools Menu Include. */
{ adecomm/toolmenu.i &EXCLUDE_EDIT=yes
                     &DEF_TRIGGERS=yes
                     &PERSISTENT=PERSISTENT}

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
DEFINE SUB-MENU mnu_Options
  MENU-ITEM _Editor_Prefs  LABEL "&Preferences..."
  TRIGGERS:
    ON CHOOSE RUN DlgSysOptions .
  END.
  MENU-ITEM _Menu_Accels  LABEL "&Menu Accelerators..."
  TRIGGERS:
    ON CHOOSE RUN DlgMenuAccels.
  END.
  MENU-ITEM _DefFont      LABEL "Default &Font..."
  TRIGGERS:
    ON CHOOSE RUN ChangeDefFont.
  END.
  .
&ENDIF

DEFINE SUB-MENU mnu_OptionsAdv
  MENU-ITEM _Editor_Prefs  LABEL "&Preferences..."
  TRIGGERS:
    ON CHOOSE RUN DlgSysOptions .
  END.
  MENU-ITEM _Editing_Options LABEL "&Editing Options..."
  TRIGGERS:
    ON CHOOSE RUN EditingOptions ( ProEditor ).
  END.
  MENU-ITEM _Menu_Accels  LABEL "&Menu Accelerators..."
  TRIGGERS:
    ON CHOOSE RUN DlgMenuAccels.
  END.
  MENU-ITEM _DefFont      LABEL "Default &Font..."
  TRIGGERS:
    ON CHOOSE RUN ChangeDefFont.
  END.
  .

/* FRAME f_Buffers is defined in adeedit/dsystem.i. See comments there. */
ON HELP OF FRAME f_Buffers ANYWHERE 
    RUN EditHelp( INPUT ProEditor , 
                  INPUT "edit" , 
                  INPUT 0 /* Zero means Help Topics */ ).

DEFINE SUB-MENU mnu_Help SUB-MENU-HELP
&IF ( "{&WINDOW-SYSTEM}" <> "TTY" ) &THEN
    MENU-ITEM _Help_Master   LABEL "OpenEdge &Master Help"
    TRIGGERS:
      ON CHOOSE RUN adecomm/_adehelp.p 
                  ( INPUT "mast", INPUT "TOPICS", INPUT ?, INPUT ? ).
    END.
    MENU-ITEM _Help_Topics   LABEL "Procedure Editor &Help Topics"
    TRIGGERS:
      ON CHOOSE RUN adecomm/_adehelp.p 
                  ( INPUT "edit" , INPUT "TOPICS" , INPUT ? , INPUT ? ).
    END.
    RULE
&ENDIF
    MENU-ITEM _Menu_Messages LABEL "M&essages..."
    TRIGGERS:
      ON CHOOSE RUN prohelp/_msgs.p.
    END.
    MENU-ITEM _Menu_Recent   LABEL "&Recent Messages..."
    TRIGGERS:
      ON CHOOSE RUN prohelp/_rcntmsg.p.
    END.
&IF ( "{&WINDOW-SYSTEM}" = "TTY" ) &THEN
    MENU-ITEM _Keyboard      LABEL "&Keyboard..."
    TRIGGERS:
      ON CHOOSE RUN prohelp/_keybrd.p.
    END.
&ENDIF
    RULE
    MENU-ITEM _About         LABEL "&About Procedure Editor"
    TRIGGERS:
      ON CHOOSE RUN adecomm/_about.p ( "Procedure Editor" , "adeicon/edit%" ).
    END.
    .

DEFINE MENU mnb_ProEdit
  MENUBAR
  SUB-MENU mnu_File    LABEL "&File"
  SUB-MENU mnu_Edit    LABEL "&Edit"
  SUB-MENU mnu_Search  LABEL "&Search"
  SUB-MENU mnu_Buffer  LABEL "&Buffer"
  SUB-MENU mnu_Compile LABEL "&Compile"
  SUB-MENU mnu_Tools   LABEL "&Tools"
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  SUB-MENU mnu_Options LABEL "&Options"
&ENDIF
  SUB-MENU mnu_Help    LABEL "&Help"
  .

DEFINE MENU mnb_ProEditAdv
  MENUBAR
  SUB-MENU mnu_File    LABEL "&File"
  SUB-MENU mnu_Edit    LABEL "&Edit"
  SUB-MENU mnu_Search  LABEL "&Search"
  SUB-MENU mnu_Buffer  LABEL "&Buffer"
  SUB-MENU mnu_Compile LABEL "&Compile"
  SUB-MENU mnu_Tools   LABEL "&Tools"
  SUB-MENU mnu_OptionsAdv LABEL "&Options"
  SUB-MENU mnu_Help    LABEL "&Help"
  .

ON MENU-DROP OF MENU mnu_Edit IN MENU mnb_ProEdit
  RUN EditMenuDrop ( ProEditor ).

ON MENU-DROP OF MENU mnu_Edit IN MENU mnb_ProEditAdv
  RUN EditMenuDrop ( ProEditor ).

ON MENU-DROP OF MENU mnu_Buffer IN MENU mnb_ProEdit
  RUN BufferMenuDrop .

ON MENU-DROP OF MENU mnu_Buffer IN MENU mnb_ProEditAdv
  RUN BufferMenuDrop .


/*-----------   Tools Menu Triggers  --------------*/
DEFINE VARIABLE h_sm          AS HANDLE      NO-UNDO.
{ adecomm/toolrun.i 
      &MENUBAR="mnb_Proedit"
      &EXCLUDE_EDIT=yes
}

h_sm = MENU mnb_ProEditADv:HANDLE.
{ adecomm/toolrun.i 
      &MENUBAR="mnb_ProeditAdv"
      &EXCLUDE_EDIT=yes
      &TOOL_RUN=yes
}

&IF DEFINED(ED_POPUP) <> 0 &THEN
/*-----------   Edit Popup Menu Triggers  --------------*/
&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
ON MENU-DROP OF MENU mnu_EdPopup
  RUN EdPopupDrop ( ProEditor ).
&ENDIF

ON CHOOSE OF MENU-ITEM m_Indent /* Indent */
  RUN ApplyTab ( ProEditor, YES ) .

ON CHOOSE OF MENU-ITEM m_UnIndent /* UnIndent */
  RUN ApplyBackTab ( ProEditor, YES ) .

ON CHOOSE OF MENU-ITEM m_Comment /* Comment */
  RUN CommentSelection ( ProEditor, YES ) .

ON CHOOSE OF MENU-ITEM m_UnComment /* Uncomment */
  RUN CommentSelection ( ProEditor, NO ) .

ON CHOOSE OF MENU-ITEM m_File_Contents
  RUN InsertFile ( ProEditor ) .

ON CHOOSE OF MENU-ITEM m_DB_Fields
  RUN FieldSelector( ProEditor ).

ON CHOOSE OF MENU-ITEM m_Cut
  RUN EditCut ( ProEditor ) .

ON CHOOSE OF MENU-ITEM m_Copy
  RUN EditCopy ( ProEditor ) .

ON CHOOSE OF MENU-ITEM m_Paste
  RUN EditPaste ( ProEditor ) .

ON CHOOSE OF MENU-ITEM m_Run
  RUN RunFile( INPUT "RUN" ).

ON CHOOSE OF MENU-ITEM m_Check_Syntax
  RUN RunFile( INPUT "CHECK-SYNTAX" ).

ON CHOOSE OF MENU-ITEM m_Keyword_Help
    RUN EditHelp( INPUT ProEditor , 
                  INPUT "edit" , 
                  INPUT ? ).

&ENDIF
