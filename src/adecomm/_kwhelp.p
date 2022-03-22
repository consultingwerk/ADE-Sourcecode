/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/**************************************************************************
    Procedure:  _kwhelp.p
    
    Purpose:    Invokes PROGRESS On-Line Language Reference Help to
                search for keyword help on code selected in an editor
                widget.
                
    Syntax:     RUN adecomm/_kwhelp.p ( INPUT p_Editor    ,
                                        INPUT p_Tool_Name ,
                                        INPUT p_Context ) .

    Parameters:
    
    Description:
                If p_Editor has text selected, partial help is invoked to
                search for the selected text in the Progress On-line Language 
                Reference.  Otherwise, help is invoked for the specified
                ADE Tool (p_Tool_Name) and context (p_Context). If
                p_Context is Unknown (?), a PARTIAL-KEY help is invoked
                for the Language Reference help.
    Notes  :
                The p_Editor widget is presumed to be of :TYPE = "EDITOR".
                
                Here is a sample call.  Proeditor is a widget handle and
                the third parameter is shown as a Preprocessor value.
                
                ON HELP OF ProEditor
                RUN adecomm/_kwhelp.p ( INPUT ProEditor , 
                                        INPUT "edit"    , 
                                        INPUT {&Procedure_Editor_Window} ).
    Authors: John Palazzo
    Date   : January, 1994
**************************************************************************/

DEFINE INPUT PARAMETER p_Editor    AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT PARAMETER p_Tool_Name AS CHARACTER     NO-UNDO.
DEFINE INPUT PARAMETER p_Context   AS INTEGER       NO-UNDO.

/*----------------------------------------------------------------------
   For Keyword/Syntax Help, trim off leading/trailing periods, colons, 
   quotes, and parenthesis. This converts strings like "ENTERED(" to 
   "ENTERED" and "END." to "END".  Improves searching.
----------------------------------------------------------------------*/
&SCOPED-DEFINE Trim_Chars    ". : ( ) ' """
    
DEFINE VARIABLE Code_String AS CHARACTER NO-UNDO.
    
/* proc-main */
DO ON STOP UNDO, LEAVE :

    IF ( SESSION:WINDOW-SYSTEM = "TTY" )
    THEN DO:
        RUN adecomm/_adehelp.p
            ( INPUT p_Tool_Name , INPUT "CONTEXT" , INPUT p_Context ,
              INPUT ? ).
        RETURN.
    END.

    /* If text selected, get Language Keyword Syntax Help. Else, get
       application help. */
    IF ( p_Editor:TEXT-SELECTED )
    THEN DO:
        ASSIGN Code_String = TRIM( TRIM( p_Editor:SELECTION-TEXT ) , 
                                        {&Trim_Chars} ) NO-ERROR.
        IF ( ERROR-STATUS:NUM-MESSAGES > 0 )
        THEN DO:
            MESSAGE "Selected text is too large to process." SKIP(1)
                    ERROR-STATUS:GET-MESSAGE(1)
                    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            RETURN.
        END.
        
        RUN adecomm/_adehelp.p
            ( INPUT "lgrf" , INPUT "PARTIAL-KEY" , INPUT ? ,
              INPUT Code_String ).
    END.
    ELSE DO:
        CASE p_Context:
          WHEN 0 THEN
            RUN adecomm/_adehelp.p
                ( INPUT p_Tool_Name , INPUT "TOPICS" , INPUT ? , INPUT ? ).
          WHEN ? THEN
            RUN adecomm/_adehelp.p
                ( INPUT "lgrf" , INPUT "PARTIAL-KEY" , INPUT ? , INPUT Code_String ).
          OTHERWISE
            RUN adecomm/_adehelp.p
               ( INPUT p_Tool_Name , INPUT "CONTEXT" , INPUT p_Context , INPUT ? ).
        END CASE.
    END.

END.
