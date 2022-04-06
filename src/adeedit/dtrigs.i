/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------------
  dtrigs.i
  Define Triggers For Editor.
----------------------------------------------------------------------------*/

/*-------------------------  MENU TRIGGERS    ------------------------------*/


/*-----------   File Menu Triggers  --------------*/
ON CHOOSE OF MENU-ITEM _New      IN MENU mnu_File
  RUN NewFile.

ON CHOOSE OF MENU-ITEM _Open     IN MENU mnu_File
  RUN OpenFile.

ON CHOOSE OF MENU-ITEM _Close    IN MENU mnu_File
  RUN CloseFile ( INPUT ProEditor ) .

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
ON CHOOSE OF MENU-ITEM _New_PW IN MENU mnu_File
  RUN NewPW.
&ENDIF

ON CHOOSE OF MENU-ITEM _Save     IN MENU mnu_File
  RUN SaveFile (INPUT ProEditor ) .

ON CHOOSE OF MENU-ITEM _Save_as  IN MENU mnu_File
  RUN SaveAsFile ( INPUT ProEditor ) .

/* IZ 2513 : Triggers for Add to Repos and Print are defined in pmenus.i. */

/*-----------   Edit Menu Triggers  --------------*/
ON MENU-DROP OF MENU mnu_Edit
  RUN EditMenuDrop ( ProEditor ).

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
ON CHOOSE OF MENU-ITEM _Undo IN MENU mnu_Edit
  RUN EditUndo ( ProEditor ) .
&ENDIF

ON CHOOSE OF MENU-ITEM _Cut IN MENU mnu_Edit
  RUN EditCut ( ProEditor ) .

ON CHOOSE OF MENU-ITEM _Copy IN MENU mnu_Edit
  RUN EditCopy ( ProEditor ) .

ON CHOOSE OF MENU-ITEM _Paste IN MENU mnu_Edit
  RUN EditPaste ( ProEditor ) .

ON CHOOSE OF MENU-ITEM _Insert_File   IN MENU mnu_Edit
  RUN InsertFile ( ProEditor ) .

ON CHOOSE OF MENU-ITEM _Field_Selector    IN MENU mnu_Edit
  RUN FieldSelector( ProEditor ).

/*-----------   Search Menu Triggers  --------------*/
ON CHOOSE OF MENU-ITEM _Find     IN MENU mnu_Search
  RUN FindText( INPUT ProEditor ) .

ON CHOOSE OF MENU-ITEM _Find_Next  IN MENU mnu_Search
  RUN FindNext ( INPUT ProEditor , INPUT Find_Criteria ).
  
ON CHOOSE OF MENU-ITEM _Find_Prev  IN MENU mnu_Search
  RUN FindPrev ( INPUT ProEditor , INPUT Find_Criteria ).

ON CHOOSE OF MENU-ITEM _Replace  IN MENU mnu_Search
  RUN ReplaceText ( INPUT ProEditor ) .

ON CHOOSE OF MENU-ITEM _Goto_Line IN MENU mnu_Search
  RUN GotoLine ( INPUT ProEditor ) .

/*-----------   Buffer Menu Triggers  --------------*/
ON MENU-DROP OF MENU mnu_Buffer
  RUN BufferMenuDrop .

ON CHOOSE OF MENU-ITEM _BuffList  IN MENU mnu_Buffer
  RUN BufferList ( INPUT win_ProEdit, INPUT ProEditor ).

ON CHOOSE OF MENU-ITEM _Next      IN MENU mnu_Buffer
  RUN NextBuffer.

ON CHOOSE OF MENU-ITEM _Prev   IN MENU mnu_Buffer
  RUN PrevBuffer.

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
ON CHOOSE OF MENU-ITEM _BufFont IN MENU mnu_Buffer
  RUN BufChangeFont ( INPUT ProEditor ) .
&ENDIF

ON CHOOSE OF MENU-ITEM _BufSettings   IN MENU mnu_Buffer
  RUN DlgBufSettings ( INPUT ProEditor ) .

/*-----------   Compile Menu Triggers  --------------*/
ON CHOOSE OF MENU-ITEM _Run      IN MENU mnu_Compile
  RUN RunFile( INPUT "RUN" ).

ON CHOOSE OF MENU-ITEM _Check_Syntax IN MENU mnu_Compile
  RUN RunFile( INPUT "CHECK-SYNTAX" ).

&IF OPSYS <> "VMS" &THEN
ON CHOOSE OF MENU-ITEM _Debug IN MENU mnu_Compile
  RUN RunFile( INPUT "DEBUG" ).
&ENDIF

ON CHOOSE OF MENU-ITEM _Comp_Msgs IN MENU mnu_Compile
  RUN CompilerMessages.

/*-----------   Tools Menu Triggers  --------------*/
{ adecomm/toolrun.i 
      &MENUBAR="mnb_Proedit"
      &EXCLUDE_EDIT=yes
}

  
/*-----------   Options Menu Triggers  --------------*/
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
ON CHOOSE OF MENU-ITEM _Editor_Opts IN MENU mnu_Options
  RUN DlgSysOptions .

ON CHOOSE OF MENU-ITEM _Menu_Accels IN MENU mnu_Options
  RUN DlgMenuAccels.

ON CHOOSE OF MENU-ITEM _DefFont IN MENU mnu_Options
  RUN ChangeDefFont.
&ENDIF

/*-----------   Help Menu Triggers   ---------------*/

/* FRAME f_Buffers is defined in adeedit/dsystem.i. See comments there. */
ON HELP OF FRAME f_Buffers ANYWHERE 
    RUN EditHelp( INPUT ProEditor , 
                  INPUT "edit" , 
                  INPUT 0 /* Zero means Help Topics */ ).

&IF ( "{&WINDOW-SYSTEM}" <> "TTY" ) &THEN
ON CHOOSE OF MENU-ITEM _Help_Topics IN MENU mnu_Help
    RUN adecomm/_adehelp.p 
        ( INPUT "edit" , INPUT "TOPICS" , INPUT ? , INPUT ? ).
&ENDIF

&IF ( "{&WINDOW-SYSTEM}" = "TTY" ) &THEN
ON CHOOSE OF MENU-ITEM _Keyboard IN MENU mnu_Help
    RUN prohelp/_keybrd.p.
&ENDIF

ON CHOOSE OF MENU-ITEM _Menu_Messages IN MENU mnu_Help
    RUN prohelp/_msgs.p.

ON CHOOSE OF MENU-ITEM _Menu_Recent IN MENU mnu_Help
    RUN prohelp/_rcntmsg.p.

ON CHOOSE OF MENU-ITEM _About IN MENU mnu_Help
    RUN adecomm/_about.p ( "Procedure Editor" , "adeicon/edit%" ).


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
