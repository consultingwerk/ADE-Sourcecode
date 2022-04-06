/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/***************************************************************************
  psearch.i
  Search Procedures for Editor.
***************************************************************************/

/* jep note source-editor - temp define */
&SCOPED-DEFINE FIND-REPEAT-LAST 64

PROCEDURE FindText.
 
/*--------------------------------------------------------------------------
    Purpose:        Executes the FIND command, which allows user to
                    search for specific text strings in the edit buffer.

    Run Syntax:     RUN FindText (INPUT p_Buffer ) .

    Parameters:
    
          INPUT
                    p_Buffer  (WIDGET-HANDLE)
                            Handle to edit buffer to perform Find on.

    Description:

    Notes:
        <EDITOR>:SEARCH Invalid Flag combinations are:

        (FIND-NEXT-OCCURRENCE + FIND-PREV-OCCURRENCE)  or  (FIND-GLOBAL)
 
---------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p_Buffer AS WIDGET-HANDLE NO-UNDO.

  DEFINE VAR vWindow        AS WIDGET-HANDLE NO-UNDO.
  
  ON HELP OF FRAME FindText ANYWHERE
    RUN adecomm/_srchhlp.p( INPUT "Find_Dialog_Box" ).
  ON CHOOSE OF btn_Find_Help IN FRAME FindText 
    RUN adecomm/_srchhlp.p( INPUT "Find_Dialog_Box" ).

  ON GO OF FRAME FindText 
  DO:
    HIDE FRAME FindText NO-PAUSE.
    
    Find_Command = IF Find_Direction:SCREEN-VALUE IN FRAME FindText = "DOWN"
                    THEN FIND-NEXT-OCCURRENCE
                    ELSE FIND-PREV-OCCURRENCE.
    ASSIGN
      Find_Text = INPUT FRAME FindText Find_Text
      INPUT FRAME FindText Find_Filters[1]
      INPUT FRAME FindText Find_Filters[2]
      INPUT FRAME FindText Find_Direction
      Find_Executed = TRUE.
    
    /* Allow user to search for question mark ( ? ). Needs special handling. */
    RUN MakeQMark ( INPUT-OUTPUT Find_Text , INPUT p_Buffer:LARGE ).
    RUN FindAssign ( OUTPUT Find_Criteria ) .
    RUN FindAgain (INPUT p_Buffer , 
                   INPUT Find_Command , INPUT Find_Criteria ).
  END.

  ON WINDOW-CLOSE OF FRAME FindText
  DO:
    APPLY "END-ERROR" TO FRAME FindText.
  END.
                                           
  &IF ( "{&WINDOW-SYSTEM}" <> "TTY" ) &THEN
  /* If text is selected (highlighted), use as default Find_Text. GUI Only. */
  IF p_Buffer:TEXT-SELECTED
      THEN ASSIGN Find_Text = p_Buffer:SELECTION-TEXT .
  &ENDIF
    
  DLG_FIND:
  DO ON ENDKEY UNDO DLG_FIND , LEAVE DLG_FIND : 
    ASSIGN vWindow    = p_Buffer:FRAME
           vWindow    = vWindow:PARENT   /* Window */
           Search_All = FALSE
    . /* ASSIGN */

    DISPLAY
      Find_Direction Find_Filters[1] 
      Find_Direction Find_Filters[2] 
      WITH FRAME FindText IN WINDOW vWindow.
    ENABLE ALL EXCEPT btn_Find_Help WITH FRAME FindText.
    ENABLE btn_Find_Help {&WHEN_HELP} WITH FRAME FindText.
    UPDATE Find_Text WITH FRAME FindText.
  END.

  HIDE FRAME FindText NO-PAUSE.
  APPLY "ENTRY" TO p_Buffer .

END PROCEDURE.        /* FindText */



PROCEDURE ReplaceText.
 
/*--------------------------------------------------------------------------
    Purpose:        Executes the REPLACE command, which allows user to
                    search for specific text strings in the edit buffer
                    and replace them with different strings.

    Run Syntax:     RUN ReplaceText ( INPUT p_Buffer ) .

    Parameters:
          INPUT
                    p_Buffer  (WIDGET-HANDLE)
                            Handle to edit buffer to perform Replace on.

    Description:

    Notes:

        <EDITOR>:REPLACE Invalid Flag combinations are:

            (FIND-NEXT-OCCURRENCE + FIND-PREV-OCCURRENCE)  or
            (SELECT) or (FIND-GLOBAL + FIND-WRAP-AROUND)
 
---------------------------------------------------------------------------*/
  
  DEFINE INPUT PARAMETER p_Buffer AS WIDGET-HANDLE NO-UNDO.

  DEFINE VAR vWindow        AS WIDGET-HANDLE NO-UNDO.
  DEFINE VAR Pressed_Cancel AS LOGICAL       NO-UNDO.
  DEFINE VAR Case_Text      AS CHARACTER CASE-SENSITIVE NO-UNDO.
  DEFINE VAR mystat         AS LOGICAL      NO-UNDO.
  ON HELP OF FRAME ReplaceText ANYWHERE
    RUN adecomm/_srchhlp.p ( INPUT "Replace_Dialog_Box" ).
  ON CHOOSE OF btn_Replace_Help IN FRAME ReplaceText 
    RUN adecomm/_srchhlp.p ( INPUT "Replace_Dialog_Box" ).

  ON WINDOW-CLOSE OF FRAME ReplaceText
  DO:
    APPLY "END-ERROR" TO FRAME ReplaceText.
  END.
  
  ON GO OF FRAME ReplaceText 
  DO:
    HIDE FRAME ReplaceText NO-PAUSE.

    ASSIGN
        Find_Text    = INPUT FRAME ReplaceText Find_Text
        Replace_Text = INPUT FRAME ReplaceText Replace_Text
        INPUT FRAME ReplaceText Replace_Filters[1]
/* Wrap not currently supported for Replace.
        INPUT FRAME ReplaceText Replace_Filters[2]
*/
        &IF DEFINED(SEARCH_ALL) <> 0 &THEN
        INPUT FRAME ReplaceText Search_Filters[1]
        &ENDIF
     . /* END ASSIGN */
    
    /* Supports searching multiple "sections", ie Section Editor. */
    ASSIGN Search_All = Search_Filters[1].
    
    /* Allow user to search for question mark ( ? ). Needs special handling. */
    RUN MakeQMark ( INPUT-OUTPUT Find_Text , INPUT p_Buffer:LARGE ).
    /* For replace text, convert unknown value to single question mark only. */
    IF Replace_Text = ? THEN
        ASSIGN Replace_Text = "?".

    &IF ( "{&WINDOW-SYSTEM}" <> "TTY" ) &THEN
    /* If case sensitive search and text selected does not match exactly the
       text user entered, clear internal var to skip selected text.
       taj: bug 19981015-051 also clear the 'real' selection so it will
       re-select it later.
     */
    ASSIGN Case_Text = Find_Sel_Text.
    IF Replace_Filters[1] AND (Find_Text <> Case_Text) THEN DO:
        mystat = p_buffer:CLEAR-SELECTION().
        ASSIGN Find_Sel_Text = "".
    END.
    &ENDIF

    IF ( SESSION:WINDOW-SYSTEM = "TTY" ) THEN
        APPLY "ENTRY" TO p_Buffer.  /* Focus must be here for replace. */
    RUN ReplaceConfirm ( INPUT p_Buffer ).    
  END.        /* Replace OK Pressed. */

  ON CHOOSE OF btn_Replace_All IN FRAME ReplaceText
  DO:
    ASSIGN
        Find_Text    = INPUT FRAME ReplaceText Find_Text
        Replace_Text = INPUT FRAME ReplaceText Replace_Text
        INPUT FRAME ReplaceText Replace_Filters[1]
/* Wrap not currently supported for Replace.
        INPUT FRAME ReplaceText Replace_Filters[2]
*/
        &IF DEFINED(SEARCH_ALL) <> 0 &THEN
        INPUT FRAME ReplaceText Search_Filters[1]
        &ENDIF
     . /* END ASSIGN */
    
    /* Supports searching multiple "sections", ie Section Editor. */
    ASSIGN Search_All = Search_Filters[1].

    HIDE FRAME ReplaceText NO-PAUSE.
    RUN ReplaceAll ( INPUT p_Buffer ) .
    
  END.        /* Replace OK Pressed. */

  DO: /* Replace Main */
    ASSIGN  Replace_Criteria    = 0
            Last_Replace_Find   = FIND-NEXT-OCCURRENCE + FIND-SELECT
            Find_Sel_Text       = p_Buffer:SELECTION-TEXT
          &IF NOT "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
          /* MSW LARGE ED does not support SELECTION-START/END.  Under MSW,
             the Editor widget maintains a highlight, so we don't need
             to set them. */
            Find_Sel_Start      = p_Buffer:SELECTION-START
            Find_Sel_End        = p_Buffer:SELECTION-END
          &ENDIF
    . /* END ASSIGN. */

    &IF ( "{&WINDOW-SYSTEM}" <> "TTY" ) &THEN
    /* Supported under GUI platforms only. */
    IF ( Find_Sel_Text <> "" ) THEN ASSIGN Find_Text = Find_Sel_Text .
    &ENDIF
   
    ASSIGN vWindow = p_Buffer:FRAME
           vWindow = vWindow:PARENT   /* Window */
    . /* ASSIGN */

    /* Global Search in Section Editor always sets to False. */
    ASSIGN Search_Filters[1] = FALSE.
    
    DISPLAY  Replace_Filters[1]
/* Wrap not currently supported for Replace. */
/*           Replace_Filters[2]              */
             &IF DEFINED(SEARCH_ALL) <> 0 &THEN
             Search_Filters[1]
             &ENDIF
             WITH FRAME ReplaceText IN WINDOW vWindow.
    ENABLE ALL EXCEPT btn_Replace_Help WITH FRAME ReplaceText.
    ENABLE btn_Replace_Help {&WHEN_HELP} WITH FRAME ReplaceText.

    DLG_REPLACE:
    DO ON STOP   UNDO DLG_REPLACE , RETRY DLG_REPLACE
       ON ENDKEY UNDO DLG_REPLACE , RETRY DLG_REPLACE :
      IF RETRY THEN
      DO:
        ASSIGN Pressed_Cancel = TRUE.
        LEAVE DLG_REPLACE.
      END.
      UPDATE Find_Text Replace_Text
            GO-ON ( CHOOSE OF btn_Replace_All )
            WITH FRAME ReplaceText.
    END.
    
    HIDE FRAME ReplaceText NO-PAUSE.
    APPLY "ENTRY" TO p_Buffer .

    IF Search_All AND Pressed_Cancel THEN RETURN "_CANCEL":U.

  END. /* Replace Main */
  
END PROCEDURE.        /* ReplaceText */



PROCEDURE ReplaceConfirm .
 
/*--------------------------------------------------------------------------
    Purpose:        Executes the REPLACE CONFIRM command, which confirms
                    with user before replacing each occurrence of the Find 
                    Text with the Replace Text.

    Run Syntax:     RUN ReplaceConfirm ( INPUT p_Buffer ) .

    Parameters:
          INPUT
                    p_Buffer  (WIDGET-HANDLE)
                            Handle to edit buffer to perform Replace on.

    Description:

    Notes:

        <EDITOR>:REPLACE Invalid Flag combinations are:

            (FIND-NEXT-OCCURRENCE + FIND-PREV-OCCURRENCE)  or
            (SELECT) or (FIND-GLOBAL + FIND-WRAP-AROUND)
 
---------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p_Buffer AS WIDGET-HANDLE NO-UNDO.
    
    DEFINE VAR Confirm_Replace  AS LOGICAL NO-UNDO INIT YES.
    DEFINE VAR Return_Status    AS LOGICAL NO-UNDO.
    DEFINE VAR First_Occurrence AS LOGICAL NO-UNDO.
    DEFINE VAR Found_One        AS LOGICAL NO-UNDO.
    DEFINE VAR Return_Value     AS CHAR    NO-UNDO.
    DEFINE VAR vWindow          AS WIDGET-HANDLE NO-UNDO.

    ASSIGN vWindow = p_Buffer:FRAME
           vWindow = vWindow:PARENT   /* Window */
    . /* ASSIGN */
    
    ASSIGN Replace_Command   = FIND-NEXT-OCCURRENCE + FIND-SELECT
           Last_Replace_Find = Replace_Command.
    /* Assigns Replace_Criteria. */
    RUN ReplaceAssign.
    ASSIGN Replace_Flags = Replace_Command + Replace_Criteria.
    
    ASSIGN Wrap_Find        = NO
           First_Occurrence = TRUE
    . /* END ASSIGN. */
    Continue_Search:
    DO WHILE TRUE:
        /* taj 19981015-051: check if find_text is equal to what is
         * really selected (don't just compare it to find_sel_text
         * which was created for case-sensitive checks). 
         */
      IF ( First_Occurrence ) AND ( SESSION:WINDOW-SYSTEM <> "TTY" )
         AND ( Find_Text <> "" ) AND ( Find_Text = p_buffer:SELECTION-TEXT )
      THEN DO:
          /* If text already selected, don't skip it. */
          ASSIGN Text_Found       = TRUE
          &IF NOT "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
          /* MSW LARGE ED does not support SET-SELECTION.  Under MSW,
             the Editor widget maintains a highlight, so we don't need
             to set it. */
                 Return_Status    = p_Buffer:SET-SELECTION( Find_Sel_Start, 
                                                            Find_Sel_End )
          &ENDIF
          . /* END ASSIGN. */
      END.
      ELSE
          ASSIGN Text_Found = p_Buffer:SEARCH(Find_Text, Replace_Flags ) .
   
      IF Text_Found 
      THEN DO:
        ASSIGN Found_One = TRUE.
        ASSIGN Confirm_Replace = YES.
        &IF ( "{&WINDOW-SYSTEM}" = "TTY" ) &THEN
        RUN ChrReplacePrompt( OUTPUT Confirm_Replace ).
        &ELSE
        DO ON STOP UNDO, LEAVE:
            MESSAGE "Replace this occurrence?"
                    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL
                            UPDATE Confirm_Replace IN WINDOW vWindow.
        END.
        &ENDIF

        CASE Confirm_Replace :
            /* User pressed Cancel. */
            WHEN ? 
                THEN DO:
                  IF Search_All THEN ASSIGN Return_Value = "_CANCEL":U + STRING(Found_One).
                  LEAVE Continue_Search.
                END.
            /* Replace current occurrence of selected text. */
            WHEN YES
               THEN DO:
                 ASSIGN Return_Status = 
                        p_Buffer:REPLACE-SELECTION-TEXT(Replace_Text) NO-ERROR.
                 IF ( Return_Status = FALSE )
                 THEN MESSAGE "Cannot replace. Editor is full."
                      VIEW-AS ALERT-BOX ERROR BUTTONS OK IN WINDOW vWindow. 
               END.
            /* No replace, continue searching. No-op here. */        
            OTHERWISE
                DO:
                  IF Search_All THEN ASSIGN Return_Value = "_SKIP":U + STRING(Found_One).
                END.
        END CASE.
        
      END.  /* Text_Found */
      ELSE 
      DO:
        IF Search_All THEN ASSIGN Return_Value = STRING(Text_Found) + STRING(Found_One).
        ELSE DO:
          IF First_Occurrence THEN
            MESSAGE "Find text not found."
              VIEW-AS ALERT-BOX INFORMATION BUTTONS OK IN WINDOW vWindow.
          ELSE
            MESSAGE "Replace complete."
              VIEW-AS ALERT-BOX INFORMATION BUTTONS OK IN WINDOW vWindow.
        END.
        LEAVE Continue_Search.
      END.
      ASSIGN First_Occurrence = FALSE.
      
    END.   /* Continue_Search */
    IF Search_All THEN RETURN Return_Value.
END PROCEDURE.        /* ReplaceConfirm */
  

&IF ( "{&WINDOW-SYSTEM}" = "TTY" ) &THEN
PROCEDURE ChrReplacePrompt.
/*----------------------------------------------------------------------------

    Purpose :   Character UI Search->Replace Prompt.

    Syntax  :   RUN ChrReplacePrompt( OUTPUT p_Return_Value ).

    Parameters:
----------------------------------------------------------------------------*/

    DEFINE OUTPUT PARAMETER p_Return_Value AS LOGICAL INIT ?.

    DEFINE VAR v_Response       AS CHARACTER FORMAT "!" NO-UNDO.
    DEFINE VAR Appl_Alert_Boxes AS LOGICAL INIT ?       NO-UNDO.
    DEFINE VAR h_bar            AS HANDLE               NO-UNDO.

    on ANY-PRINTABLE,GO,RETURN,ENTER,END-ERROR of focus
    do:
      assign v_Response = last-event:function.
      if ( lookup( v_Response, "Y,N,C,GO,RETURN,ENTER,END-ERROR, " ) > 0 ) then
      do:
        if ( lookup( v_Response , "Y,GO,RETURN,ENTER, " ) > 0 ) then
          assign p_Return_Value = YES.
        else if ( v_Response = "N" ) then
          assign p_Return_Value = NO.
        else if ( lookup( v_Response , "C,END-ERROR" ) > 0 ) then
          assign p_Return_Value = ?.
        apply "U1":u to focus.
      end.
      else bell.

      return no-apply.
    end.

    repeat on stop   undo, RETRY
           on error  undo, retry
           on endkey undo, retry :

        if not retry then
        do:
            assign v_Response = "Y".
            hide message no-pause.
            /* If user has this set to TRUE, then our replace message
               will appear in an alert box and screw everything up.
               So we ensure its FALSE and we reset on the way out.
            */
            assign Appl_Alert_Boxes         = SESSION:APPL-ALERT-BOXES
                   SESSION:APPL-ALERT-BOXES = FALSE.
            /* Turn off the active window menubar to prevent any
               accelerators from firing. - jep */
            assign h_bar           = active-window:menubar
                   h_bar:SENSITIVE = FALSE NO-ERROR.
            message "Replace this occurrence (Y-Yes, N-No, C-Cancel)?" .
            assign SESSION:APPL-ALERT-BOXES = Appl_Alert_Boxes.
            /* wait-for needed to keep cursor on the current text to
               be replaced. */
            wait-for U1 of focus.
        end.
        else
            assign p_Return_value = ?.

        /* Reset this setting to what user had it at. */
        if Appl_Alert_Boxes <> ?
        then assign SESSION:APPL-ALERT-BOXES = Appl_Alert_Boxes.

        /* Turn the active window menubar back on. */
        assign h_bar           = active-window:menubar
               h_bar:SENSITIVE = TRUE NO-ERROR.
        assign h_bar = active-window NO-ERROR.
        leave.
    end.

END PROCEDURE.
&ENDIF

PROCEDURE ReplaceAll .
 
/*--------------------------------------------------------------------------
    Purpose:        Executes the REPLACE ALL command, which replaces all
                    occurrences of the Find Text with the Replace Text
                    string.

    Run Syntax:     RUN ReplaceAll ( INPUT p_Buffer ) .

    Parameters:
          INPUT
                    p_Buffer  (WIDGET-HANDLE)
                            Handle to edit buffer to perform Replace on.

    Description:

    Notes:

        <EDITOR>:REPLACE Invalid Flag combinations are:

            (FIND-NEXT-OCCURRENCE + FIND-PREV-OCCURRENCE)  or
            (SELECT) or (FIND-GLOBAL + FIND-WRAP-AROUND)
 
---------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p_Buffer AS WIDGET-HANDLE NO-UNDO.

    DEFINE VAR vWindow          AS WIDGET-HANDLE NO-UNDO.

    ASSIGN vWindow = p_Buffer:FRAME
           vWindow = vWindow:PARENT   /* Window */
    . /* ASSIGN */
    
    ASSIGN Replace_Command   = FIND-GLOBAL
           Last_Replace_Find = Replace_Command .
    /* Assigns Replace_Criteria. */    
    RUN ReplaceAssign.
    
    
    ASSIGN Replace_Flags = Replace_Command + Replace_Criteria.

    ASSIGN Text_Found = p_Buffer:REPLACE(Find_Text, Replace_Text, Replace_Flags).
    IF Search_All THEN RETURN "_REPLACE-ALL":U + STRING(Text_Found).

    IF NOT Text_Found THEN
      MESSAGE "Find text not found."
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK IN WINDOW vWindow.
    ELSE
      MESSAGE "Replace All complete." p_Buffer:NUM-REPLACED "occurrences replaced."
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK IN WINDOW vWindow.

END PROCEDURE.        /* ReplaceAll */


PROCEDURE FindAssign.
 
/*--------------------------------------------------------------------------
    Purpose:        Assigns the Find Text and Find Criteria.

    Run Syntax:     RUN FindAssign ( OUTPUT p_Find_Criteria ) .

    Parameters:
    
   Description:
   
    Notes:
 
---------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER p_Find_Criteria AS INTEGER NO-UNDO .

  DO:
    ASSIGN
        p_Find_Criteria = FIND-SELECT

        p_Find_Criteria = IF Find_Filters[Case_Sensitive]
                          THEN p_Find_Criteria + FIND-CASE-SENSITIVE
                          ELSE p_Find_Criteria

        p_Find_Criteria = IF Find_Filters[Wrap_Around]
                          THEN p_Find_Criteria + FIND-WRAP-AROUND
                          ELSE p_Find_Criteria
    . /* END ASSIGN. */
  END.
                     
END PROCEDURE.        /* FindAssign */


PROCEDURE ReplaceAssign.
 
/*--------------------------------------------------------------------------
    Purpose:        Assigns the Find/Replace Text and Find/Replace Criteria.

    Run Syntax:     RUN ReplaceAssign.

    Parameters:
    
   Description:
   
    Notes:
 
---------------------------------------------------------------------------*/

  ASSIGN
    Replace_Criteria = 0
  
    Replace_Criteria = IF Replace_Filters[Case_Sensitive]
                       THEN Replace_Criteria + FIND-CASE-SENSITIVE
                       ELSE Replace_Criteria
  . /* END ASSIGN. */
  
END PROCEDURE.        /* ReplaceAssign */


PROCEDURE FindNext.
/*--------------------------------------------------------------------------
    Purpose:        Executes the FIND NEXT command.

    Run Syntax:     RUN FindNext ( INPUT p_Buffer , INPUT p_Find_Criteria).

    Parameters:
        p_Buffer p_Find_Criteria

    Description:

    Notes:
---------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p_Buffer AS WIDGET-HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p_Find_Criteria AS INTEGER NO-UNDO.

  /* Set basic Find Criteria. */
  RUN FindAssign ( OUTPUT p_Find_Criteria ) .
  &IF ( "{&WINDOW-SYSTEM}" <> "TTY" ) &THEN
  /* Supported under GUI only. */
  /* Assign Find Text the Currently Selected text, if any. */
  Find_Text = ( IF p_Buffer:TEXT-SELECTED
                   THEN p_Buffer:SELECTION-TEXT
                   ELSE Find_Text ) .
  &ENDIF
  /* Allow user to search for question mark ( ? ). Needs special handling. */
  RUN MakeQMark ( INPUT-OUTPUT Find_Text , INPUT p_Buffer:LARGE ).
  RUN FindAgain (INPUT p_Buffer ,
                 INPUT FIND-NEXT-OCCURRENCE + {&FIND-REPEAT-LAST}, INPUT p_Find_Criteria).

END PROCEDURE.          /* FindNext */



PROCEDURE FindPrev.
/*--------------------------------------------------------------------------
    Purpose:        Executes the FIND PREVIOUS command.

    Run Syntax:     RUN FindPrev (INPUT p_Buffer , INPUT p_Find_Criteria).

    Parameters:
        p_Buffer p_Find_Criteria

    Description:

    Notes:
 
---------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p_Buffer AS WIDGET-HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p_Find_Criteria AS INTEGER NO-UNDO.

  /* Set basic Find Criteria. */
  RUN FindAssign ( OUTPUT p_Find_Criteria ) .
  &IF ( "{&WINDOW-SYSTEM}" <> "TTY" ) &THEN
  /* Supported under GUI only. */
  /* Assign Find Text the Currently Selected text, if any. */
  Find_Text = ( IF p_Buffer:TEXT-SELECTED
                   THEN p_Buffer:SELECTION-TEXT
                   ELSE Find_Text ) .
  &ENDIF

  /* Allow user to search for question mark ( ? ). Needs special handling. */
  RUN MakeQMark ( INPUT-OUTPUT Find_Text , INPUT p_Buffer:LARGE ).
  RUN FindAgain (INPUT p_Buffer ,
                 INPUT FIND-PREV-OCCURRENCE + {&FIND-REPEAT-LAST}, INPUT p_Find_Criteria).

END PROCEDURE.          /* FindPrev */



PROCEDURE FindAgain.
 
/*--------------------------------------------------------------------------
    Purpose:        Re-Executes the previous FIND command.

    Run Syntax:     RUN FindAgain ( INPUT p_Buffer ,
                                        INPUT p_Again_Find_Command ,
                                    INPUT p_Again_Find_Criteria ).

    Parameters:
        
    Description:

    Notes:
 
---------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p_Buffer               AS WIDGET-HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p_Again_Find_Command  AS INTEGER NO-UNDO.
  DEFINE INPUT PARAMETER p_Again_Find_Criteria AS INTEGER NO-UNDO.
  
  DEFINE VARIABLE Again_Find_Flags AS INTEGER NO-UNDO.
  DEFINE VARIABLE First_Occurrence AS LOGICAL NO-UNDO.
  DEFINE VARIABLE vWindow          AS WIDGET-HANDLE NO-UNDO.

    ASSIGN vWindow = p_Buffer:FRAME
           vWindow = vWindow:PARENT   /* Window */
    . /* ASSIGN */
    

    ASSIGN Again_Find_Flags = p_Again_Find_Command + p_Again_Find_Criteria
           Wrap_Find        = NO
    . /* END ASSIGN. */

    Continue_Search:
    DO WHILE TRUE:

      ASSIGN Text_Found = p_Buffer:SEARCH(Find_Text, Again_Find_Flags)  .
      IF (Search_All = TRUE) THEN RETURN STRING(Text_Found).

      IF Text_Found THEN LEAVE Continue_Search.
      MESSAGE "Find text not found."
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK IN WINDOW vWindow.
      LEAVE Continue_Search.
      
    END.   /* Continue_Search */
      
END PROCEDURE.          /* FindAgain */


PROCEDURE MakeQMark.
/*--------------------------------------------------------------------------
    Purpose:        Makes the unknown value a question mark and allows for
                    proper searching of the literal "?".

    Run Syntax:     RUN MakeQMark ( INPUT-OUTPUT p_String , INPUT p_Large ).

    Parameters:
        
    Description:
       If string is Unknown Value, convert it to a single Question Mark for
       All platforms, except MSW LARGE editor - convert to two qmarks.
       This is because the MSW LARGE Editor treats ? as a wildcard, whereas
       two are taken to mean the literal ?. 

       This allows user to search for instances of a question mark in their
       code.
       
    Notes:
---------------------------------------------------------------------------*/

    DEFINE INPUT-OUTPUT PARAMETER p_String AS CHARACTER NO-UNDO.
    DEFINE INPUT        PARAMETER p_Large  AS LOGICAL   NO-UNDO.

    IF p_String = ? OR p_String = "?" THEN
      ASSIGN p_String = IF ( SESSION:WINDOW-SYSTEM BEGINS "MS-WIN" AND
                              p_Large = TRUE )
                        THEN "??"
                        ELSE "?".

END PROCEDURE.


PROCEDURE GotoLine.
/*--------------------------------------------------------------------------
    Purpose:
        Executes GOTO-LINE command, allowing user to move the text
        cursor to a specified line number within the edit buffer.

    Run Syntax:    
        RUN GotoLine (INPUT p_Buffer ) . 

    Parameters:

    Description:

    Notes:
--------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p_Buffer AS WIDGET-HANDLE NO-UNDO.
  
  DEFINE VARIABLE vWindow         AS WIDGET-HANDLE NO-UNDO.

  ON HELP OF FRAME Goto_Line ANYWHERE
    RUN adecomm/_srchhlp.p ( INPUT "Goto_Line_Dialog_Box" ).
  ON CHOOSE OF btn_GL_Help IN FRAME Goto_Line
    RUN adecomm/_srchhlp.p ( INPUT "Goto_Line_Dialog_Box" ).

  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
  ON RETURN,ENTER OF Goto_Line IN FRAME Goto_Line
      APPLY "GO" TO FRAME Goto_Line.
  &ENDIF

  ON GO OF FRAME Goto_Line
  DO:
    HIDE FRAME Goto_Line NO-PAUSE.
    ASSIGN Goto_Line = INPUT FRAME Goto_Line Goto_Line.
    RUN MoveCursor ( INPUT p_Buffer , INPUT Goto_Line ).
  END.

  Goto_Line = p_Buffer:CURSOR-LINE.
  DLG_GOTO:
  DO ON STOP   UNDO DLG_GOTO, LEAVE DLG_GOTO
     ON ERROR  UNDO DLG_GOTO, LEAVE DLG_GOTO
     ON ENDKEY UNDO DLG_GOTO, LEAVE DLG_GOTO:
    
    ASSIGN vWindow = p_Buffer:FRAME
           vWindow = vWindow:PARENT   /* Window */
    . /* ASSIGN */

    
    UPDATE Goto_Line btn_GL_OK btn_GL_Cancel btn_GL_Help {&WHEN_HELP}
           GO-ON( GO,WINDOW-CLOSE ) 
           WITH FRAME Goto_Line IN WINDOW vWindow.
  
  END.

  HIDE FRAME Goto_Line NO-PAUSE.
  APPLY "ENTRY" TO p_Buffer.

END.        /* GotoLine */


PROCEDURE MoveCursor.
/*--------------------------------------------------------------------------
    Purpose:        Moves editor cursor to a specified line number, column 1.
    Run Syntax:     RUN MoveCursor ( INPUT p_Buffer , INPUT p_Cursor_Line ).

    Parameters:     p_Buffer p_Cursor_Line

    Description:
        If entered line is greater than number of lines in buffer, then
        move to EOF.

        If entered line 0, goto line 1.

    Notes:
 
--------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p_Buffer      AS WIDGET-HANDLE NO-UNDO.
    DEFINE INPUT PARAMETER p_Cursor_Line AS INTEGER       NO-UNDO.

    DEFINE VARIABLE Move_to_EOF AS LOGICAL NO-UNDO.

    IF p_Buffer:EMPTY THEN RETURN.
    /* If entered line is greater than number of lines in buffer, then
       move to EOF. */
    IF p_Cursor_Line > p_Buffer:NUM-LINES
        THEN ASSIGN Move_to_EOF = p_Buffer:MOVE-TO-EOF().
    ELSE DO:
    /* If entered line 0, goto line 1. */
        IF ( p_Cursor_Line < 1 ) THEN ASSIGN p_Cursor_Line = 1.

        ASSIGN p_Buffer:CURSOR-LINE = p_Cursor_Line.
    END.

END PROCEDURE. /* MoveCursor */
