/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/********************************************************************/
/* Encrypted code which is part of this file is subject to the      */
/* Possenet End User Software License Agreement Version 1.0         */
/* (the "License"); you may not use this file except in             */
/* compliance with the License. You may obtain a copy of the        */
/* License at http://www.possenet.org/license.html                  */
/********************************************************************/

/**************************************************************************
  pedit.i 
  Edit  Procedures for Editor
***************************************************************************/

&IF "{&WINDOW-SYSTEM}" <> "TTY":U &THEN
PROCEDURE EditUndo.
/*---------------------------------------------------------------------------

    Syntax       RUN EditUndo ( INPUT p_Buffer ) .
    
    Purpose      Undoes the last edit action.
    
    Remarks      The p_Buffer is presumed to be of :TYPE = "EDITOR".
               
    Return Value NONE.

---------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p_Buffer AS WIDGET-HANDLE NO-UNDO .

  DO ON STOP UNDO, LEAVE ON ERROR UNDO, LEAVE :

    IF p_Buffer:EDIT-CAN-UNDO THEN p_Buffer:EDIT-UNDO().

  END. /* DO ON STOP */
  
/* We don't need to do this for functions implemented via editor widget.
  /* Put focus back in editor widget. */
  APPLY "ENTRY" TO p_Buffer.
*/
  
END PROCEDURE.  /* EditUndo. */

&ENDIF 


PROCEDURE EditCut.
/*---------------------------------------------------------------------------

    Syntax       RUN EditCut ( INPUT p_Buffer ) .
    
    Purpose      Copies the contents of the current selection to the OS's
                 Native Clipboard, overwriting the clipboards previous contents,
                 and then deletes the current selection and its contents.
    
    Remarks      The p_Buffer is presumed to be of :TYPE = "EDITOR".
               
    Return Value NONE.

---------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p_Buffer AS WIDGET-HANDLE NO-UNDO .

  DEFINE VAR Status_Error   AS LOGICAL       NO-UNDO.
  DEFINE VAR vWindow        AS WIDGET-HANDLE NO-UNDO.
  DEFINE VAR Clip_Multiple  AS LOGICAL       NO-UNDO INIT FALSE.
  
  &IF "{&WINDOW-SYSTEM}" <> "TTY":U &THEN
  ASSIGN Status_Error = p_Buffer:EDIT-CUT() NO-ERROR.
  &ELSE
  DO ON STOP UNDO, LEAVE ON ERROR UNDO, LEAVE :
    /* ADE only works with a single clipboard format - text only. */
    ASSIGN Clip_Multiple     = CLIPBOARD:MULTIPLE
           CLIPBOARD:MULTIPLE = FALSE.
    RUN SelectSetEnd( INPUT p_Buffer ) .
    IF ( p_Buffer:TEXT-SELECTED = TRUE ) THEN
    DO: /* Text is selected. */
        /* Can Progress ditem handle the text to be cut? */
        ASSIGN CLIPBOARD:VALUE = p_Buffer:SELECTION-TEXT NO-ERROR.
      
        IF ( ERROR-STATUS:NUM-MESSAGES > 0 ) THEN
        DO:
            ASSIGN vWindow = p_Buffer:FRAME
                   vWindow = vWindow:PARENT   /* Window */
            . /* ASSIGN */

            MESSAGE "Text is too large to cut." SKIP(1)
                    ERROR-STATUS:GET-MESSAGE(1)
                    VIEW-AS ALERT-BOX ERROR BUTTONS OK IN WINDOW vWindow.
        END.
        ELSE DO:
            ASSIGN Status_Error = p_Buffer:REPLACE-SELECTION-TEXT("").
        END.
        RUN DeselectText ( INPUT p_Buffer ).
    END.
  END. /* DO ON STOP */
  /* Restore clipboard multiple value. */
  ASSIGN  CLIPBOARD:MULTIPLE = Clip_Multiple. 
  
  /* Put focus back in editor widget. */
  APPLY "ENTRY" TO p_Buffer.
  &ENDIF
  
END PROCEDURE.  /* EditCut. */

PROCEDURE EditCopy.
/*---------------------------------------------------------------------------

    Syntax       RUN EditCopy ( INPUT p_Buffer ) .
    
    Purpose      Copies the contents of the current selection to the OS's
                 Native Clipboard, overwriting its previous contents.
  
    Remarks      The p_Buffer widget is presumed to be of :TYPE = "EDITOR".
               
    Return Value NONE.

---------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p_Buffer AS WIDGET-HANDLE NO-UNDO .
  
  DEFINE VAR Status_Error   AS LOGICAL       NO-UNDO.
  DEFINE VAR vWindow        AS WIDGET-HANDLE NO-UNDO.
  DEFINE VAR Clip_Multiple  AS LOGICAL       NO-UNDO INIT FALSE.
  
  &IF "{&WINDOW-SYSTEM}" <> "TTY":U &THEN
  ASSIGN Status_Error = p_Buffer:EDIT-COPY() NO-ERROR.
  &ELSE
  DO ON STOP UNDO, LEAVE ON ERROR UNDO, LEAVE :
    /* ADE only works with a single clipboard format - text only. */
    ASSIGN Clip_Multiple     = CLIPBOARD:MULTIPLE
           CLIPBOARD:MULTIPLE = FALSE.
    RUN SelectSetEnd( INPUT p_Buffer ) .
    IF p_Buffer:TEXT-SELECTED THEN
    DO: /* Text is selected. */      
        /* Can Progress ditem handle the text to be cut? */
        ASSIGN CLIPBOARD:VALUE = p_Buffer:SELECTION-TEXT NO-ERROR.
        IF ( ERROR-STATUS:NUM-MESSAGES > 0 ) THEN
        DO:
            ASSIGN vWindow = p_Buffer:FRAME
                   vWindow = vWindow:PARENT   /* Window */
            . /* ASSIGN */
            MESSAGE "Text is too large to copy." SKIP(1)
                    ERROR-STATUS:GET-MESSAGE(1)
                    VIEW-AS ALERT-BOX ERROR BUTTONS OK IN WINDOW vWindow.
        END.
        RUN DeselectText ( INPUT p_Buffer ).
    END.
  END. /* DO ON STOP */
  
  /* Restore clipboard multiple value. */
  ASSIGN  CLIPBOARD:MULTIPLE = Clip_Multiple. 
  
  /* Put focus back in editor widget. */
  APPLY "ENTRY" TO p_Buffer.
  &ENDIF

END PROCEDURE.  /* EditCopy. */


PROCEDURE EditPaste.
/*---------------------------------------------------------------------------

    Syntax       RUN EditPaste ( INPUT p_Buffer ).
    
    Purpose      Inserts the contents of the OS's clipboard at the current
                 position (insert point).  Does not change the clipboard's
                 contents.
    
    Remarks      The p_Buffer widget is presumed to be of :TYPE = "EDITOR".
               
    Return Value NONE.

---------------------------------------------------------------------------*/
  
  DEFINE INPUT PARAMETER p_Buffer AS WIDGET-HANDLE NO-UNDO .

  DEFINE VAR Status_Error   AS LOGICAL NO-UNDO.
  DEFINE VAR Paste_Text     AS CHAR    NO-UNDO.
  DEFINE VAR vWindow        AS WIDGET  NO-UNDO.
  DEFINE VAR Clip_Multiple  AS LOGICAL NO-UNDO INIT FALSE.
  
  &IF "{&WINDOW-SYSTEM}" <> "TTY":U &THEN
  IF p_Buffer:EDIT-CAN-PASTE THEN
    ASSIGN Status_Error = p_Buffer:EDIT-PASTE() NO-ERROR.
  &ELSE

  DO ON STOP UNDO, LEAVE ON ERROR UNDO, LEAVE :
    /* ADE only works with a single clipboard format - text only. */
    ASSIGN Clip_Multiple     = CLIPBOARD:MULTIPLE
           CLIPBOARD:MULTIPLE = FALSE.
  
    IF CLIPBOARD:NUM-FORMATS > 0 THEN  /* Clipboard not empty. */
    DO:
      ASSIGN vWindow = p_Buffer:FRAME
             vWindow = vWindow:PARENT   /* Window */
      . /* ASSIGN */

      RUN SelectSetEnd( INPUT p_Buffer ) .

      /* Can Progress ditem handle the text to be pasted? */
      ASSIGN Paste_Text = CLIPBOARD:VALUE NO-ERROR.
      IF ( ERROR-STATUS:NUM-MESSAGES > 0 ) THEN
      DO:
            MESSAGE "Text is too large to paste." SKIP(1)
                    ERROR-STATUS:GET-MESSAGE(1)
                    VIEW-AS ALERT-BOX ERROR BUTTONS OK IN WINDOW vWindow.
      END.
      ELSE DO:
         /* If something selected, replace it with clipboard value. */
        IF p_Buffer:TEXT-SELECTED THEN
             ASSIGN Status_Error = 
                    p_Buffer:REPLACE-SELECTION-TEXT( CLIPBOARD:VALUE ) .
        ELSE /* Insert pasted text at current insert point. */
             ASSIGN Status_Error = 
                    p_Buffer:INSERT-STRING( CLIPBOARD:VALUE ) .
        IF ( Status_Error = FALSE )
        THEN MESSAGE "Cannot paste.  Editor is full."
                  VIEW-AS ALERT-BOX ERROR BUTTONS OK IN WINDOW vWindow.
      END.

      RUN DeselectText ( INPUT p_Buffer ).
    END .
  END. /* DO ON STOP */
  
  /* Restore clipboard multiple value. */
  ASSIGN  CLIPBOARD:MULTIPLE = Clip_Multiple. 
  
  /* Put focus back in editor widget. */
  APPLY "ENTRY" TO p_Buffer.
  &ENDIF
  
END PROCEDURE.  /* EditPaste. */

PROCEDURE IndentSelection:
/*---------------------------------------------------------------------------

    Syntax       RUN IndentSelection ( INPUT p_Buffer, INPUT pi_indent ) .
    
    Purpose      Indent the selected text in the p_Buffer Editor widget
                 by pi_indent.
    Remarks      The p_Buffer widget is presumed to be of :TYPE = "EDITOR".
                 The value or pi_indent can be
                      >0       Indent that much 
                      0        Return (do nothing)
                      <0       Remove the indent
               
    Return Value NONE.

---------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p_Buffer  AS WIDGET-HANDLE NO-UNDO .
  DEFINE INPUT PARAMETER pi_indent AS INTEGER       NO-UNDO .
  
  DEFINE VAR Status_Error   AS LOGICAL NO-UNDO.
  DEFINE VAR New_Text       AS CHAR    NO-UNDO.
  DEFINE VAR vWindow        AS WIDGET  NO-UNDO.
  DEFINE VAR start          AS INTEGER NO-UNDO.
  DEFINE VAR First_Indent   AS INTEGER NO-UNDO.
  DEFINE VAR Last_Char      AS CHAR    NO-UNDO.
  DEFINE VAR IndentDone     AS LOGICAL NO-UNDO.
    
  DO ON STOP UNDO, LEAVE ON ERROR UNDO, LEAVE :

    &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
    RUN SelectSetEnd( INPUT p_Buffer ) .
    &ENDIF
   
    /* adecomm/peditor.i */
    RUN Indent_Selection (INPUT p_Buffer, INPUT pi_indent, OUTPUT IndentDone).
    IF IndentDone THEN RETURN.
    
    IF p_Buffer:TEXT-SELECTED AND pi_indent NE 0
    THEN DO: /* Text is selected and there is something to do */
    
        /* Can Progress ditem handle the text to be indented? */
        ASSIGN New_Text = p_Buffer:SELECTION-TEXT NO-ERROR.
        IF ( ERROR-STATUS:NUM-MESSAGES > 0 )
        THEN DO:
            ASSIGN vWindow = p_Buffer:FRAME
                   vWindow = vWindow:PARENT   /* Window */
            . /* ASSIGN */
            MESSAGE "Selection is too large to indent." SKIP(1)
                    ERROR-STATUS:GET-MESSAGE(1)
                    VIEW-AS ALERT-BOX ERROR BUTTONS OK IN WINDOW vWindow.
        END.
        ELSE DO:
             ASSIGN start = p_Buffer:SELECTION-START. 
             
             /* If last character is EOL, go one character before it for selection end.
                Otherwise, indent is added to following line as well. */
             ASSIGN Last_Char = SUBSTRING(p_Buffer:SELECTION-TEXT, LENGTH(p_Buffer:SELECTION-TEXT, "CHARACTER":u)).
             IF Last_Char = CHR(10) THEN
             DO:
                 ASSIGN Status_Error = p_Buffer:SET-SELECTION(start, p_Buffer:SELECTION-END - 1) NO-ERROR.
                 ASSIGN New_Text = p_Buffer:SELECTION-TEXT NO-ERROR.
             END.

             IF pi_indent > 0   /* Indent */
             THEN ASSIGN New_Text = REPLACE(New_Text,CHR(10), CHR(10) + FILL(" ",pi_indent))
                         New_Text = FILL(" ", pi_indent) + New_Text.
             ELSE DO:           /* Unindent */
                ASSIGN New_Text = REPLACE(New_Text,CHR(10) + FILL(" ", ABS(pi_indent)), CHR(10)).
                /* Find the first n-spaces and remove them. */
                ASSIGN First_Indent = INDEX(New_Text , FILL(" ", ABS(pi_indent))).
                ASSIGN SUBSTRING(New_Text, First_Indent, ABS(pi_indent)) = "" NO-ERROR.
             END.
             
             ASSIGN Status_Error = p_Buffer:REPLACE-SELECTION-TEXT( New_Text) .

             ASSIGN Status_Error = p_Buffer:SET-SELECTION(start, start + LENGTH(New_Text,"CHARACTER")).
       END.
       &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
       RUN DeselectText ( INPUT p_Buffer ).
       &ENDIF      
    END.
  END. /* DO ON STOP */
  
  /* Put focus back in editor widget. */
  APPLY "ENTRY" TO p_Buffer.

END PROCEDURE.  /* IndentSelection */


PROCEDURE CommentSelection:
/*---------------------------------------------------------------------------

    Syntax       RUN CommentSelection ( INPUT p_Buffer, INPUT pl_comment ) .
    
    Purpose      Comment/Uncomment the selected text in the p_Buffer Editor 
                 widget.
    Remarks      The p_Buffer widget is presumed to be of :TYPE = "EDITOR".
                 The value or pl_comment is logical and can be can be
                      YES   Add Comments
                      NO    Remove Comments
               
    Return Value NONE.

---------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p_Buffer   AS WIDGET-HANDLE NO-UNDO .
  DEFINE INPUT PARAMETER pl_comment AS LOGICAL       NO-UNDO .
  
  DEFINE VAR Status_Error   AS LOGICAL NO-UNDO.
  DEFINE VAR New_Text       AS CHAR    NO-UNDO.
  DEFINE VAR vWindow        AS WIDGET  NO-UNDO.
  DEFINE VAR start          AS INTEGER NO-UNDO.
  DEFINE VAR Comment_Start  AS INTEGER NO-UNDO.
  DEFINE VAR Comment_End    AS INTEGER NO-UNDO.
  DEFINE VAR Can_Uncomment  AS LOGICAL NO-UNDO.
  DEFINE VAR Last_Char      AS CHAR    NO-UNDO.
  DEFINE VAR CommmentDone   AS LOGICAL NO-UNDO.
  DEFINE VAR line_count     AS INTEGER NO-UNDO.
  DEFINE VAR comment_text   AS CHAR    NO-UNDO.
  DEFINE VAR line_text      AS CHAR    NO-UNDO.
  DEFINE VAR comment_lines  AS INTEGER NO-UNDO.

  DO ON STOP UNDO, LEAVE ON ERROR UNDO, LEAVE :

    &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
    RUN SelectSetEnd( INPUT p_Buffer ) .
    &ENDIF
   
    /* adecomm/peditor.i */
    RUN Comment_Selection (INPUT p_Buffer, INPUT pl_comment, OUTPUT CommmentDone ).
    IF CommmentDone THEN RETURN.

    IF p_Buffer:TEXT-SELECTED
    THEN DO: /* Text is selected  */      
        ASSIGN vWindow = p_Buffer:FRAME
               vWindow = vWindow:PARENT  /* Window */
               .
        
        /* Excluding white space, determine if the selected text starts
           with "/*" and ends with "*/". */
        ASSIGN New_Text = TRIM(p_Buffer:SELECTION-TEXT) NO-ERROR.
        IF ( ERROR-STATUS:NUM-MESSAGES = 0 ) THEN
            ASSIGN Comment_Start = INDEX( New_Text , "/*":u )
                   Comment_End   = R-INDEX( New_Text , "*/":u )
                   Can_Uncomment = (Comment_Start = 1 AND
                                    Comment_End = LENGTH(New_Text, "CHARACTER":u) - 1)
                   NO-ERROR.

        /* Get the actual comment start and comment end locations. */
        ASSIGN Comment_Start = INDEX( p_Buffer:SELECTION-TEXT , "/*":u ) NO-ERROR.
        ASSIGN Comment_End   = R-INDEX( p_Buffer:SELECTION-TEXT , "*/":u ) NO-ERROR.
                   
        /* Can Progress ditem handle the text to be cut? */
        ASSIGN New_Text = p_Buffer:SELECTION-TEXT NO-ERROR.
        IF ( ERROR-STATUS:NUM-MESSAGES > 0 )
        THEN DO:
            MESSAGE "Selection is too large to comment." SKIP(1)
                    ERROR-STATUS:GET-MESSAGE(1)
                    VIEW-AS ALERT-BOX ERROR BUTTONS OK IN WINDOW vWindow.
        END.
        ELSE IF pl_comment eq NO AND NOT Can_Uncomment
        THEN DO: 
            MESSAGE 'Cannot uncomment selection.' SKIP
                    'Selected text must start with /* and end with */.'
                    VIEW-AS ALERT-BOX ERROR BUTTONS OK IN WINDOW vWindow.
        END.
        ELSE DO:
             ASSIGN start = p_Buffer:SELECTION-START.

             /* If last character is EOL, go one character before it for selection end.
                Otherwise, end comment is added to following line. */
             ASSIGN Last_Char = SUBSTRING(p_Buffer:SELECTION-TEXT, LENGTH(p_Buffer:SELECTION-TEXT, "CHARACTER":u)).
             IF Last_Char = CHR(10) THEN
             DO:
                 ASSIGN Status_Error = p_Buffer:SET-SELECTION(start, p_Buffer:SELECTION-END - 1) NO-ERROR.
                 ASSIGN New_Text = p_Buffer:SELECTION-TEXT NO-ERROR.
             END.

             /* If we are going to comment the section, then surround the 
                text with '/**/'. For multiple lines, enclose each line in
                comments. Reverse the process when we uncomment. */
             IF pl_comment EQ yes
             THEN DO:
               comment_lines = NUM-ENTRIES(New_Text, CHR(10)).
               COMMENT_CODE:
               DO line_count = 1 TO NUM-ENTRIES(New_Text, CHR(10)):
                 line_text = ENTRY(line_count, New_Text, CHR(10)).
                 /* If the last element in the selection is a blank line, we don't comment
                    it because its really just a blank line following the selection text. */
                 IF FALSE /* line_count = comment_lines AND TRIM(line_text) = "" */ THEN LEAVE COMMENT_CODE.
                 ELSE DO:
                   IF comment_lines > 1 THEN DO: /* Comment a line. */
                     /* If its a blank line, add two spaces to it for compatibility with
                        advanced editor. */
                     IF TRIM(line_text) = "" THEN DO: /* Blank line. */
                       comment_text = comment_text + "/* " + RIGHT-TRIM(line_text) + "  " + " */".
                     END.
                     ELSE DO: /* Not a blank line. */
                       comment_text = comment_text + "/* " + RIGHT-TRIM(line_text) + " */".
                     END.
                     /* Don't add carriage return to last line. It gets one from the selection replacement. */
                     IF line_count < comment_lines THEN comment_text = comment_text + CHR(10).
                   END.
                   ELSE /* Comment portion of a line. */
                     comment_text = comment_text + "/* " + line_text + " */".
                 END.
               END.
               ASSIGN New_Text = comment_text.
             END.
             ELSE DO:
               comment_lines = NUM-ENTRIES(New_Text, CHR(10)).
               UNCOMMENT_CODE:
               DO line_count = 1 TO NUM-ENTRIES(New_Text, CHR(10)):
                 line_text = ENTRY(line_count, New_Text, CHR(10)).
                 IF TRIM(line_text) = "" THEN /* Don't uncomment blank lines. */
                   comment_text = comment_text + line_text.
                 ELSE DO:
                     /* Get the actual comment start and comment end locations and then
                        remove the comment characters. */
                     ASSIGN Comment_End   = R-INDEX( line_text , " */":u ) NO-ERROR.
                     ASSIGN SUBSTRING( line_text , Comment_End , LENGTH( " */":u, "CHARACTER":u ) ) = "*/":u NO-ERROR.
                     ASSIGN Comment_End   = R-INDEX( line_text , "*/":u ) NO-ERROR.
                     ASSIGN SUBSTRING( line_text , Comment_End , LENGTH( "*/":u, "CHARACTER":u ) ) = "" NO-ERROR.
                     ASSIGN Comment_Start = INDEX( line_text , "/* ":u ) NO-ERROR.
                     ASSIGN SUBSTRING( line_text , Comment_Start, LENGTH( "/* ":u, "CHARACTER":u ) ) = "/*":u NO-ERROR.
                     ASSIGN Comment_Start = INDEX( line_text , "/*":u ) NO-ERROR.
                     ASSIGN SUBSTRING( line_text , Comment_Start, LENGTH( "/*":u, "CHARACTER":u ) ) = "" NO-ERROR.
                     comment_text = comment_text + line_text.
                     /* Add carriage return when one or more lines is selected but not for
                        the last line. Thats added by replace-selection-text. -jep */
                     IF comment_lines > 1 AND line_count < comment_lines THEN
                       comment_text = comment_text + CHR(10).
                 END.
                 /* Support uncommenting of pre-9.1A comments. */
                 ASSIGN comment_text = REPLACE(comment_text, CHR(10) + " * ", CHR(10) ).
               END.
               ASSIGN New_Text = comment_text.
             END.
             
             ASSIGN Status_Error = p_Buffer:REPLACE-SELECTION-TEXT( New_Text ).
             ASSIGN Status_Error = p_Buffer:SET-SELECTION(start, p_Buffer:CURSOR-OFFSET).
       END.
       &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
       RUN DeselectText ( INPUT p_Buffer ).
       &ENDIF      
    END.
  END. /* DO ON STOP */
  
  /* Put focus back in editor widget. */
  APPLY "ENTRY" TO p_Buffer.

END PROCEDURE.  /* CommentSelection */


PROCEDURE CommentBox:
/*---------------------------------------------------------------------------

    Syntax       RUN CommentBox ( INPUT p_Buffer, INPUT pl_comment ) .
    
    Purpose      Box Comment/Uncomment the selected text in the p_Buffer Editor.

    Remarks      The p_Buffer widget is presumed to be of :TYPE = "EDITOR".
                 The value or pl_comment is logical and can be can be
                      YES   Add Comments
                      NO    Remove Comments
                      
                 Box Uncomment is not currently supported.

---------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER p_Buffer    AS WIDGET-HANDLE NO-UNDO.
  DEFINE INPUT  PARAMETER pl_comment  AS LOGICAL       NO-UNDO.
  
  DEFINE VAR Status_Error   AS LOGICAL NO-UNDO.
  DEFINE VAR New_Text       AS CHAR    NO-UNDO.
  DEFINE VAR vWindow        AS WIDGET  NO-UNDO.
  DEFINE VAR start          AS INTEGER NO-UNDO.
  DEFINE VAR Comment_Start  AS INTEGER NO-UNDO.
  DEFINE VAR Comment_End    AS INTEGER NO-UNDO.
  DEFINE VAR Can_Uncomment  AS LOGICAL NO-UNDO.
  DEFINE VAR Last_Char      AS CHAR    NO-UNDO.
  DEFINE VAR CommmentDone   AS LOGICAL NO-UNDO.
  DEFINE VAR line_count     AS INTEGER NO-UNDO.
  DEFINE VAR comment_text   AS CHAR    NO-UNDO.
  DEFINE VAR line_text      AS CHAR    NO-UNDO.
  DEFINE VAR comment_lines  AS INTEGER NO-UNDO.
  DEFINE VAR max_line_width AS INTEGER NO-UNDO.

  DO ON STOP UNDO, LEAVE ON ERROR UNDO, LEAVE :

    &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
    RUN SelectSetEnd( INPUT p_Buffer ) .
    &ENDIF
   
    /* adecomm/peditor.i */
    RUN Comment_Box (INPUT p_Buffer, INPUT pl_comment, OUTPUT CommmentDone ).
    IF CommmentDone THEN RETURN.

    IF p_Buffer:TEXT-SELECTED
    THEN DO: /* Text is selected  */      
        ASSIGN vWindow = p_Buffer:FRAME
               vWindow = vWindow:PARENT  /* Window */
               .
        
        /* Excluding white space, determine if the selected text starts
           with "/*" and ends with "*/". */
        ASSIGN New_Text = TRIM(p_Buffer:SELECTION-TEXT) NO-ERROR.
        IF ( ERROR-STATUS:NUM-MESSAGES = 0 ) THEN
            ASSIGN Comment_Start = INDEX( New_Text , "/*":u )
                   Comment_End   = R-INDEX( New_Text , "*/":u )
                   Can_Uncomment = (Comment_Start = 1 AND
                                    Comment_End = LENGTH(New_Text, "CHARACTER":u) - 1)
                   NO-ERROR.

        /* Get the actual comment start and comment end locations. */
        ASSIGN Comment_Start = INDEX( p_Buffer:SELECTION-TEXT , "/*":u ) NO-ERROR.
        ASSIGN Comment_End   = R-INDEX( p_Buffer:SELECTION-TEXT , "*/":u ) NO-ERROR.
                   
        /* Can Progress ditem handle the text to be cut? */
        ASSIGN New_Text = p_Buffer:SELECTION-TEXT NO-ERROR.
        IF ( ERROR-STATUS:NUM-MESSAGES > 0 )
        THEN DO:
            MESSAGE "Selection is too large to comment." SKIP(1)
                    ERROR-STATUS:GET-MESSAGE(1)
                    VIEW-AS ALERT-BOX ERROR BUTTONS OK IN WINDOW vWindow.
        END.
        ELSE IF pl_comment eq NO AND NOT Can_Uncomment
        THEN DO: 
            MESSAGE 'Cannot uncomment selection.' SKIP
                    'Selected text must start with /* and end with */.'
                    VIEW-AS ALERT-BOX ERROR BUTTONS OK IN WINDOW vWindow.
        END.
        ELSE DO:
             ASSIGN start = p_Buffer:SELECTION-START.

             /* If last character is EOL, go one character before it for selection end.
                Otherwise, end comment is added to following line. */
             ASSIGN Last_Char = SUBSTRING(p_Buffer:SELECTION-TEXT, LENGTH(p_Buffer:SELECTION-TEXT, "CHARACTER":u)).
             IF Last_Char = CHR(10) THEN
             DO:
                 ASSIGN Status_Error = p_Buffer:SET-SELECTION(start, p_Buffer:SELECTION-END - 1) NO-ERROR.
                 ASSIGN New_Text = p_Buffer:SELECTION-TEXT NO-ERROR.
             END.

             /* If we are going to comment the section, then surround the 
                text with '/**/'. For multiple lines, enclose each line in
                comments. Reverse the process when we uncomment. */
             IF pl_comment EQ yes
             THEN DO:
               /* First scan the lines to comment for the maximum line width. */
               comment_lines = NUM-ENTRIES(New_Text, CHR(10)).
               COMMENT_CODE:
               DO line_count = 1 TO NUM-ENTRIES(New_Text, CHR(10)):
                 line_text = ENTRY(line_count, New_Text, CHR(10)).
                 max_line_width = MAX(max_line_width, LENGTH(line_text, "CHARACTER":U)).
               END.
               comment_text = " " + REPLACE(new_text, CHR(10), CHR(10) + " ":U).
               /* Now add a comment box line before and after the selected text. */
               comment_text = "/*":u + FILL('*':u, MAX(max_line_width, 1)) + CHR(10) +
                              comment_text + CHR(10) +
                              FILL('*':u, MAX(max_line_width, 1)) + "*/":u NO-ERROR.
                              
               New_Text = comment_text.
             END.
             ELSE DO:
               /* Uncomment Box not supported. */
             END.
             ASSIGN Status_Error = p_Buffer:REPLACE-SELECTION-TEXT( New_Text ).
             ASSIGN Status_Error = p_Buffer:SET-SELECTION(start, p_Buffer:CURSOR-OFFSET).
       END.
       &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
       RUN DeselectText ( INPUT p_Buffer ).
       &ENDIF      
    END.
  END. /* DO ON STOP */
  
  /* Put focus back in editor widget. */
  APPLY "ENTRY" TO p_Buffer.

END PROCEDURE.  /* CommentBox */


PROCEDURE InsertFile.
  /*--------------------------------------------------------------------------
    Purpose:        Executes the INSERT command, which reads a file into the
                    current cursor position of the current editor file.

    Run Syntax:     RUN InsertFile ( INPUT p_Buffer ).

    Parameters:
	INPUT
		p_Buffer	WIDGET-HANDLE
	                Edit Buffer handle to insert file into.

    Description:

    Notes:
  ---------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p_Buffer AS WIDGET-HANDLE NO-UNDO .

  DEFINE VARIABLE Dlg_Answer   AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE File_Name    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE h_cwin       AS WIDGET    NO-UNDO.
  DEFINE VARIABLE Insert_File  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE Insert_OK    AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE Pressed_OK   AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE Remote_File  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE vWindow      AS WIDGET    NO-UNDO.
  DEFINE VARIABLE Web_File     AS LOGICAL   NO-UNDO.
  
  INSERT_BLOCK:
  DO WHILE TRUE ON STOP UNDO , LEAVE :
  
    ASSIGN 
      vWindow        = p_Buffer:FRAME
      vWindow        = vWindow:PARENT /* Window */
      h_cwin         = CURRENT-WINDOW /* Save current-window to restore later. */
      CURRENT-WINDOW = vWindow.
           
    /* Insert file on remote WebSpeed agent. */
    IF SEARCH("adeuib/_uibinfo.r":U) <> ? THEN
        RUN adeuib/_uibinfo.p (?, "SESSION":U, "REMOTE":U, 
                               OUTPUT Remote_File) NO-ERROR.
    IF Remote_File = "TRUE":U AND vWindow:PRIVATE-DATA = "_ab.p":U THEN
      RUN adeweb/_webfile.w ("uib":U, "Open":U, "Open":U, "":U,
                             INPUT-OUTPUT File_Name, OUTPUT Insert_File, 
                             OUTPUT Pressed_OK) NO-ERROR.
    
    /* Insert local file. */
    ELSE
      RUN adeedit/_dlggetf.p 
        ( INPUT "Insert File" ,
          INPUT NO ,
          INPUT 1 /* Initial_Filter */ ,
          INPUT-OUTPUT Insert_File ,
          OUTPUT Pressed_OK ) .
  
    IF ( Pressed_OK = NO ) THEN LEAVE INSERT_BLOCK.

    ASSIGN Insert_OK = p_Buffer:INSERT-FILE( Insert_File ) NO-ERROR.
    IF ( Insert_OK = NO ) THEN
      RUN adecomm/_s-alert.p (INPUT-OUTPUT Dlg_Answer, "error":U, "ok":U,
        SUBSTITUTE("&1^Unable to find or open file.^^The file may not exist or may be too large to insert into the current buffer.", 
        Insert_File)).
    LEAVE INSERT_BLOCK.
    
  END.  /* DO INSERT_BLOCK. */

  /* Repoint current-window. */
  IF VALID-HANDLE( h_cwin ) THEN ASSIGN CURRENT-WINDOW = h_cwin .

  APPLY "ENTRY":U TO p_Buffer .
  RETURN.

END PROCEDURE.  /* InsertFile. */

PROCEDURE FieldSelector.
  /*--------------------------------------------------------------------------
    Purpose:        Allows user to select database fields to insert
                    into the current buffer.

    Run Syntax:     RUN FieldSelector.

    Parameters:     

    Description:

    Notes:
  ---------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_Buffer AS WIDGET-HANDLE NO-UNDO.
  
  DEFINE VARIABLE v_Schema_Fields AS CHARACTER NO-UNDO.
  DEFINE VARIABLE Function_Return AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE OK_Pressed      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE h_cwin          AS WIDGET    NO-UNDO.
  DEFINE VARIABLE vWindow         AS WIDGET    NO-UNDO.

  /*--------------------------------------------------------------------------
     Make sure the tool can be found.
  ---------------------------------------------------------------------------*/
  DO ON STOP UNDO, LEAVE:
    ASSIGN vWindow = p_Buffer:FRAME
           vWindow = vWindow:PARENT   /* Window */
    . /* ASSIGN */
    /* Save current-window handle to restore later. */
    ASSIGN h_cwin         = CURRENT-WINDOW
           CURRENT-WINDOW = vWindow.
    
    RUN adecomm/_fldsel.p
    ( INPUT TRUE /* p_Multi */ ,
      INPUT ?    /* data type */ ,
      INPUT ?    /* tt info */ ,
      INPUT-OUTPUT Ed_Schema_Prefix ,
      INPUT-OUTPUT Ed_Schema_Database ,
      INPUT-OUTPUT Ed_Schema_Table ,
      INPUT-OUTPUT v_Schema_Fields ,
      OUTPUT OK_Pressed )   NO-ERROR.
  END. /* DO ON STOP */
  
  /* Repoint current-window. */
  IF VALID-HANDLE( h_cwin ) THEN ASSIGN CURRENT-WINDOW = h_cwin .

  IF OK_Pressed = FALSE THEN RETURN.  /* User cancelled Schema Pick. */
 
  /*--------------------------------------------------------------------------
     If text is selected, replace it with field list.  Otherwise, insert 
     field list at current insert point.
  ---------------------------------------------------------------------------*/
  v_Schema_Fields = REPLACE( v_Schema_Fields , "," , " " ).
  IF ( p_Buffer:TEXT-SELECTED )
    THEN Function_Return = p_Buffer:REPLACE-SELECTION-TEXT( v_Schema_Fields ).
    ELSE Function_Return = p_Buffer:INSERT-STRING( v_Schema_Fields ).

END PROCEDURE.  /* FieldSelector. */


&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
/* These Procedures are used for text selection in TTY only. */
PROCEDURE SelectSetStart.
  /*--------------------------------------------------------------------------
    Purpose:        Sets the selection start mark for TTY Editor.

    Run Syntax:     RUN SelectSetStart( INPUT p_Buffer ).

    Parameters:
        INPUT
            p_Buffer    WIDGET-HANDLE
                Edit Buffer handle.

    Description:

    Notes:
  ---------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p_Buffer AS WIDGET-HANDLE NO-UNDO .
  
  DEFINE VARIABLE Error_Status AS LOGICAL NO-UNDO.
  
  IF ( SESSION:WINDOW-SYSTEM <> "TTY" ) THEN RETURN.

  IF ( p_Buffer:EMPTY )
  THEN RUN DeselectText( INPUT p_Buffer ).
  ELSE DO:
      Edit_Selection_Start = p_Buffer:CURSOR-OFFSET .
      Edit_Selection_End   = ?.
  END.

END PROCEDURE .

PROCEDURE SelectSetEnd.
  /*--------------------------------------------------------------------------
    Purpose:        Sets the selection end mark for TTY Editor.

    Run Syntax:     RUN SelectSetEnd( INPUT p_Buffer ).

    Parameters:
        INPUT
            p_Buffer    WIDGET-HANDLE
                Edit Buffer handle.

    Description:

    Notes:
  ---------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p_Buffer AS WIDGET-HANDLE NO-UNDO .

  DEFINE VARIABLE Error_Status AS LOGICAL NO-UNDO .

  IF ( SESSION:WINDOW-SYSTEM <> "TTY" ) THEN RETURN.

  IF ( p_Buffer:EMPTY ) OR ( Edit_Selection_Start = ? )
  THEN RUN DeselectText( INPUT p_Buffer ).
  ELSE DO:
      Edit_Selection_End  = p_Buffer:CURSOR-OFFSET .
      Error_Status        = p_Buffer:SET-SELECTION( Edit_Selection_Start ,
                                                    Edit_Selection_End ) .
  END.

END PROCEDURE .


PROCEDURE DeselectText .
  /*--------------------------------------------------------------------------
    Purpose:        Deselects any currently Selected Text (Used for TTY Only).

    Run Syntax:     RUN DeselectText( INPUT p_Buffer ).

    Parameters:
        INPUT
            p_Buffer    WIDGET-HANDLE
                Edit Buffer handle.

    Description:

    Notes:
  ---------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p_Buffer AS WIDGET-HANDLE NO-UNDO .
  
  DEFINE VARIABLE Error_Status AS LOGICAL NO-UNDO.


  IF ( SESSION:WINDOW-SYSTEM <> "TTY" ) THEN RETURN.

  Edit_Selection_Start = ?.
  Edit_Selection_End   = ?.  
  IF ( p_Buffer:EMPTY ) THEN RETURN.

  Error_Status         = p_Buffer:CLEAR-SELECTION().

END PROCEDURE .

/* TTY Only PROCEDURES */
&ENDIF

PROCEDURE EditHelp .
/*---------------------------------------------------------------------------
    Purpose:    Invokes PROGRESS On-Line Language Reference Help to
                search for keyword help on code selected in an editor
                widget.
                
    Syntax:     RUN EditHelp ( INPUT p_Editor    ,
                               INPUT p_Tool_Name ,
                               INPUT p_Context ) .

    Parameters:
    
    Description:
                If p_Editor has text selected, partial help is invoked to
                search for the selected text in the Progress On-line Language 
                Reference.  Otherwise, help is invoked for the specified
                ADE Tool (p_Tool_Name) and context (p_Context).
    Notes  :
                This internal procedure calls an external procedure
                adecomm/_kwhelp.p with the same parameters to perform
                the actual Keyword Help processing. See that procedure
                for further details on parameters, comments, etc..

    Authors: John Palazzo
---------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p_Editor    AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT PARAMETER p_Tool_Name AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAMETER p_Context   AS INTEGER       NO-UNDO.

DO ON STOP UNDO, LEAVE:

    RUN adecomm/_kwhelp.p ( INPUT p_Editor    ,
                            INPUT p_Tool_Name ,
                            INPUT p_Context ) .
END.

END PROCEDURE.


PROCEDURE ApplyTab.
/*---------------------------------------------------------------------------
    Syntax      
        RUN ApplyTab ( INPUT p_Editor ,
                       INPUT p_Return_Error ).
    
    Purpose     
        Inserts a Tab-space into an editor widget.
    
    Description
        Instead of a TAB CHAR, this routine inserts enough spaces
        to position the text cursor at a "tab stop". If text is selected,
        its indented to next tab stop, provided selection starts at leftmost
        margin of edit area. Otherwise, selected text is indented by a full
        tab.
                
    Remarks      
        The p_Editor widget is presumed to be of :TYPE = "EDITOR".
                
        Here is a sample call.  The example is for a simple
        UI Trigger.
                
            ON TAB,CTRL-TAB OF e IN FRAME y
            DO:
              RUN ApplyTab( e:HANDLE , NO ).
              RETURN NO-APPLY.
            END.
            
        For a PERSISTENT Trigger, here is a sample call:
        
            ON TAB,CTRL-TAB PERSISTENT
                RUN ApplyTab( e:HANDLE , YES ). 

               
    Return Value NONE.
---------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p_Editor       AS WIDGET-HANDLE.
  DEFINE INPUT PARAMETER p_Return_Error AS LOGICAL.
  
  DEFINE VAR Tab_Char AS CHAR    INIT " " NO-UNDO.
  DEFINE VAR Tab_Stop AS INTEGER INIT 4   NO-UNDO.
  DEFINE VAR Tab_Over AS INTEGER NO-UNDO.
  DEFINE VAR Temp     AS LOGICAL NO-UNDO.
  DEFINE VAR TabDone  AS LOGICAL NO-UNDO.

  DO:
  &IF ( "{&WINDOW-SYSTEM}" <> "TTY" ) &THEN

  &IF DEFINED(ADESTDSI) <> 0 &THEN
  ASSIGN Tab_Stop = editor_tab WHEN editor_tab <> ?. /* From adestds.i */
  &ENDIF

  /* adecomm/peditor.i */
  RUN Apply_Tab ( INPUT p_Editor , OUTPUT TabDone ).
  IF TabDone THEN RETURN.
                 
  IF ( p_Editor:TEXT-SELECTED ) THEN
  DO: /* Text selected: Indent it. */
      ASSIGN Tab_Over = LENGTH(p_Editor:SELECTION-TEXT, "CHARACTER":u) -
                        LENGTH(LEFT-TRIM(p_Editor:SELECTION-TEXT), "CHARACTER":u) NO-ERROR.
      IF Tab_Over > 0 THEN
      DO:
        ASSIGN Tab_Over = ( Tab_Stop - ( Tab_Over MOD Tab_Stop ) ) /*  + 1 */ .
        ASSIGN Tab_Over = ( Tab_Over - Tab_Stop ) WHEN Tab_Over > Tab_Stop.
      END.
      ELSE
        Tab_Over = Tab_Stop.
      RUN IndentSelection (INPUT p_Editor , INPUT Tab_Over).
  END.
  ELSE
  DO: /* Otherwise, insert TAB.    */ 
      ASSIGN Tab_Over = ( Tab_Stop - ( p_Editor:CURSOR-CHAR MOD Tab_Stop ) ) + 1.
      ASSIGN Tab_Over = ( Tab_Over - Tab_Stop ) WHEN Tab_Over > Tab_Stop.
      ASSIGN Temp = p_Editor:INSERT-STRING( FILL(Tab_Char , Tab_Over) ).
  END.
  
  &ELSE
  /* In TTY, so just execute the TTY editor widget insert-tab method. */
  Temp = p_Editor:INSERT-TAB().
  &ENDIF
  
  END.
  
  IF p_Return_Error THEN RETURN ERROR.
END PROCEDURE.


PROCEDURE ApplyBackTab .
/*---------------------------------------------------------------------------
    Syntax      
        RUN ApplyBackTab ( INPUT p_Editor ,
                           INPUT p_Return_Error ).
    
    Purpose     
        Moves cursor back to a space tab-stop in an editor widget.

    Description
        If text is selected, its unindented to next tab stop, provided
        selection starts at leftmost margin of edit area. Otherwise,
        selected text is unindented by a full tab.
        
    Remarks      
        The p_Editor widget is presumed to be of :TYPE = "EDITOR".
                
        Here is a sample call.  The example is for a simple
        UI Trigger.
                
            ON BACK-TAB,SHIFT-TAB OF e IN FRAME y
            DO:
              RUN ApplyBackTab( e:HANDLE , NO ).
              RETURN NO-APPLY.
            END.
            
        For a PERSISTENT Trigger, here is a sample call:
        
            ON BACK-TAB,SHIFT-TAB PERSISTENT
                RUN ApplyBackTab( e:HANDLE , YES ). 

    Return Value NONE.
---------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p_Editor       AS WIDGET-HANDLE.
  DEFINE INPUT PARAMETER p_Return_Error AS LOGICAL.

  DEFINE VAR Tab_Char AS CHAR    INIT " " NO-UNDO.
  DEFINE VAR Tab_Stop AS INTEGER INIT 4   NO-UNDO.
  DEFINE VAR Tab_Over AS INTEGER NO-UNDO.
  DEFINE VAR Tab_Back AS INTEGER NO-UNDO.
  DEFINE VAR Temp     AS LOGICAL NO-UNDO.
  DEFINE VAR BackTabDone AS LOGICAL NO-UNDO.

  &IF ( "{&WINDOW-SYSTEM}" = "TTY" ) &THEN
  Temp = p_Editor:INSERT-BACKTAB().
  &ELSE
  DO:

    &IF DEFINED(ADESTDSI) <> 0 &THEN
    ASSIGN Tab_Stop = editor_tab WHEN editor_tab <> ?. /* From adestds.i */
    &ENDIF

    /* adecomm/peditor.i */
    RUN Apply_BackTab ( INPUT p_Editor , OUTPUT BackTabDone ).
    IF BackTabDone THEN RETURN.

    IF ( p_Editor:TEXT-SELECTED ) THEN
    DO: /* Text selected: Unindent it. */
      ASSIGN Tab_Over = LENGTH(p_Editor:SELECTION-TEXT, "CHARACTER":u) -
                        LENGTH(LEFT-TRIM(p_Editor:SELECTION-TEXT), "CHARACTER":u) NO-ERROR.
      IF Tab_Over > 0 THEN
      DO:
        ASSIGN Tab_Over = ( Tab_Stop - ( Tab_Over MOD Tab_Stop ) ) /*  + 1 */ .
        ASSIGN Tab_Over = ( Tab_Over - Tab_Stop ) WHEN Tab_Over > Tab_Stop.
      END.
      ELSE
        Tab_Over = Tab_Stop.
      ASSIGN Tab_Back = Tab_Over.
      RUN IndentSelection (INPUT p_Editor , INPUT - (Tab_Back) ).
    END.
    ELSE
    DO: /* Otherwise, backtab.    */ 
      Tab_Over = ( Tab_Stop - ( p_Editor:CURSOR-CHAR MOD Tab_Stop ) ) + 1.
      Tab_Back = ( Tab_Stop - ( Tab_Over MOD Tab_Stop ) ).
      IF ( p_Editor:CURSOR-CHAR - Tab_Back < 1 )
      THEN
          ASSIGN p_Editor:CURSOR-CHAR = 1 NO-ERROR.   
      ELSE
          ASSIGN p_Editor:CURSOR-CHAR = ( p_Editor:CURSOR-CHAR - Tab_Back ) NO-ERROR.
    END.

  END.
  &ENDIF

  IF p_Return_Error THEN RETURN ERROR.
END PROCEDURE.

/* Additional editor procedures. */
{adecomm/peditor.i}
