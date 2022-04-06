/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------------
  dbftrigs.i
  Define Triggers For Individual Editor Buffers.
  These triggers are defined as PERSISTENT.
----------------------------------------------------------------------------*/


/*-------------------------  EDITOR KEY TRIGGERS  --------------------------*/

/* CTRL-TAB on Windows moves the focus to the next active field when inside
   an editor widget. In Motif, TAB moves the focus. So we trap both and
   force them to act as Editor TAB. In DOS, CTRL-TAB is NEXT-FRAME and the
   Editor uses it to perform the Next Buffer option, so we trap TAB only
   in DOS.

   A similar situation is true for BACK-TAB and SHIFT-TAB, except we
   can treat them as Editor BACK-TAB for all platforms.
*/
&IF LOOKUP(OPSYS, "MSDOS,WIN32":u ) = 0 &THEN
ON TAB,CTRL-TAB PERSISTENT
  RUN ApplyTab ( INPUT p_Buffer , YES ).
&ELSE
ON TAB PERSISTENT
  RUN ApplyTab ( INPUT p_Buffer , YES ).
&ENDIF

ON BACK-TAB,SHIFT-TAB PERSISTENT
   RUN ApplyBackTab ( INPUT p_Buffer , YES ).

&IF ( "{&WINDOW-SYSTEM}" = "TTY" ) &THEN


/*-----------	File Triggers  --------------*/
ON NEW	      /* File->New */ PERSISTENT
   RUN NewFile.

ON GET	      /* File->Open */ PERSISTENT
   RUN OpenFile.

ON PUT /* File->Save */ PERSISTENT
   RUN SaveFile (INPUT p_Buffer) .

ON SAVE-AS /* File->Save As */ PERSISTENT
   RUN SaveAsFile (INPUT p_Buffer ) .

ON CLOSE,CLEAR /* File->Close */ PERSISTENT
   RUN CloseFile (INPUT p_Buffer ).

ON EXIT /* File->Exit */ PERSISTENT
   RUN WinExitEditor.

/*-----------	Edit Triggers  --------------*/
ON BLOCK PERSISTENT
   RUN SelectSetStart( INPUT p_Buffer ).

ON CUT PERSISTENT
   RUN EditCut ( INPUT p_Buffer ).

ON COPY PERSISTENT
   RUN EditCopy ( INPUT p_Buffer ).

ON PASTE PERSISTENT
   RUN EditPaste ( INPUT p_Buffer ).

/*-----------	Search Menu Triggers  --------------*/
ON FIND /* Search->Find */ PERSISTENT
  RUN FindText ( INPUT p_Buffer ) .

ON FIND-NEXT   /* Search->Find */ PERSISTENT
  RUN FindNext ( INPUT p_Buffer , INPUT Find_Criteria ).

ON FIND-PREVIOUS   /* Search->Find */ PERSISTENT
  RUN FindPrev ( INPUT p_Buffer , INPUT Find_Criteria ).

ON REPLACE /* Search->Replace  */ PERSISTENT
  RUN ReplaceText ( INPUT p_Buffer ).

ON GOTO /* Search->Goto-Line  */ PERSISTENT
  RUN GotoLine ( INPUT p_Buffer ).

/*-----------	Buffer Menu Triggers  --------------*/
ON BREAK-LINE /* Buffer->List */ PERSISTENT
  RUN BufferList ( INPUT p_Window , INPUT p_Buffer ).

ON NEXT-FRAME /* Buffer->Next */ PERSISTENT
  RUN NextBuffer.

ON PREV-FRAME,PAGE-LEFT /* Buffer->Previous */ PERSISTENT
  RUN PrevBuffer.

/*-----------	Compile Menu Triggers  --------------*/
ON GO /* Compile->Run */ PERSISTENT
  RUN RunFile ( INPUT "RUN" ).

ON COMPILE /* Compile->Check-Syntax */ PERSISTENT
  RUN RunFile ( INPUT "CHECK-SYNTAX" ).

&ENDIF
