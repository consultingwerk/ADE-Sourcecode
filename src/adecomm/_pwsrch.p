/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/**************************************************************************
    Procedure:  _pwsrch.p
    
    Purpose:    Execute Procedure Window Search menu commands.

    Syntax :    RUN adecomm/_pwsrch.p ( INPUT p_Action ) .

    Parameters:
    Description:
    Notes  :
    Authors: John Palazzo
    Date   : January, 1994
**************************************************************************/

/* ADE Standards Include. */
&GLOBAL-DEFINE WIN95-BTN YES

{ adecomm/adestds.i }
IF NOT initialized_adestds
THEN RUN adecomm/_adeload.p.

/* Procedure Window Global Defines. */
{ adecomm/_pwglob.i }

/* Procedure Window Attributes include. */
{ adecomm/_pwattr.i }

/* Search defines and procedures. */
{ adecomm/dsearch.i }
{ adecomm/psearch.i }       

DEFINE INPUT PARAMETER p_Action AS CHARACTER NO-UNDO.

DEFINE VARIABLE pw_Window       AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE pw_Editor       AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE hAttr_Field     AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE l_ok            AS LOGICAL       NO-UNDO.
DEFINE VARIABLE h_cwin          AS WIDGET-HANDLE NO-UNDO.


PROCEDURE GetSrchAttr.
/**************************************************************************
    Purpose:    Gets the persistent PW Search Attributes and assigns them
                to the appropriate Common Dialog field variables.

    Syntax :    RUN GetSrchAttr ( INPUT p_Editor , INPUT p_Action ) .

    Parameters:
    Description:
    Notes  :
    Authors: John Palazzo
    Date   : January, 1994
**************************************************************************/

DEFINE INPUT PARAMETER p_Editor AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT PARAMETER p_Action AS CHARACTER     NO-UNDO.
        
DEFINE VARIABLE hFind_Text      AS WIDGET-HANDLE NO-UNDO.        
DEFINE VARIABLE hRepl_Text      AS WIDGET-HANDLE NO-UNDO.        

DO:
    /* Get the persistent Find Field values. */
    RUN GetFrameAttr ( INPUT p_Editor:FRAME , INPUT {&PW_Find_Text} ,
                       OUTPUT hFind_Text ).
    ASSIGN Find_Text = hFind_Text:PRIVATE-DATA .
    
    IF p_Action BEGINS "FIND"
    THEN DO:
    ASSIGN Find_Direction                 =
                ENTRY( {&PW_Find_Direction_Pos} , p_Editor:PRIVATE-DATA )
           Find_Filters[ Case_Sensitive ] =
              ( ENTRY( {&PW_Find_Case_Pos} , p_Editor:PRIVATE-DATA ) =
                STRING( TRUE , Find_Filters[1]:FORMAT IN FRAME FindText ) )
           Find_Filters[ Wrap_Around ]    =
              ( ENTRY( {&PW_Find_Wrap_pos} , p_Editor:PRIVATE-DATA ) =
                STRING( TRUE , Find_Filters[2]:FORMAT IN FRAME FindText ) )
           .
    END. /* Find */                         
           
    IF p_Action BEGINS "REPLACE"
    THEN DO:
    /* Get the persistent Replace Field values. */
    RUN GetFrameAttr ( INPUT p_Editor:FRAME , INPUT {&PW_Replace_Text} ,
                       OUTPUT hRepl_Text ).
    ASSIGN Replace_Text = hRepl_Text:PRIVATE-DATA .
    
    ASSIGN Replace_Filters[ Case_Sensitive ] =
              ( ENTRY( {&PW_Replace_Case_Pos} , p_Editor:PRIVATE-DATA ) =
                STRING( TRUE , Replace_Filters[1]:FORMAT IN FRAME ReplaceText ) )
           /* Wrap not supported in Replace.
           Replace_Filters[ Wrap_Around ]    =
              ( ENTRY( {&PW_Replace_Wrap_pos} , p_Editor:PRIVATE-DATA ) =
                STRING( TRUE , Replace_Filters[2]:FORMAT IN FRAME ReplaceText ) )
           */
           .
    END. /* Replace */
END.

END PROCEDURE.


PROCEDURE PutSrchAttr.
/**************************************************************************
    Purpose:    Puts the Search Common Dialogs field variable values into
                the persistent PW Search Attributes.

    Syntax :    RUN PutSrchAttr ( INPUT p_Editor , p_Action ) .

    Parameters:
    Description:
    Notes  :
    Authors: John Palazzo
    Date   : January, 1994
**************************************************************************/
        
DEFINE INPUT PARAMETER p_Editor AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT PARAMETER p_Action AS CHARACTER     NO-UNDO.

DEFINE VARIABLE hFind_Text      AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE hRepl_Text      AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE Private_Data    AS CHARACTER     NO-UNDO.        

DO:
    /* Put the dialog values back into the PW Attribute Fields. */
    RUN GetFrameAttr ( INPUT p_Editor:FRAME , INPUT {&PW_Find_Text} ,
                       OUTPUT hFind_Text ).
    RUN GetFrameAttr ( INPUT p_Editor:FRAME , INPUT {&PW_Replace_Text} ,
                       OUTPUT hRepl_Text ).

    /* Bug workaround - ENTRY statement balks at :PRIVATE-DATA. */
    ASSIGN Private_Data = p_Editor:PRIVATE-DATA.             
    /* FIND */
    ASSIGN hFind_Text:PRIVATE-DATA        = Find_Text
           ENTRY( {&PW_Find_Direction_Pos} , Private_Data )
                = Find_Direction
           ENTRY( {&PW_Find_Case_Pos} , Private_Data )
                = STRING( Find_Filters[Case_Sensitive] )
           ENTRY( {&PW_Find_Wrap_Pos} , Private_Data )
                = STRING( Find_Filters[ Wrap_Around ]  )
           .
    /* REPLACE */
    ASSIGN hRepl_Text:PRIVATE-DATA        = Replace_Text
           ENTRY( {&PW_Replace_Case_Pos} , Private_Data )
                = STRING( Replace_Filters[Case_Sensitive] )
           .
    ASSIGN p_Editor:PRIVATE-DATA = Private_Data.
END.

END PROCEDURE.


/* MAIN */
DO:
  REPEAT ON STOP UNDO, RETRY:
    IF RETRY THEN LEAVE.
    /* Get widget handles of Procedure Window and its editor widget. */
    RUN adecomm/_pwgetwh.p ( INPUT SELF , OUTPUT pw_Window ).
    RUN adecomm/_pwgeteh.p ( INPUT pw_Window , OUTPUT pw_Editor ).

    /* Save current-window handle to restore later. */
    ASSIGN h_cwin         = CURRENT-WINDOW
           CURRENT-WINDOW = pw_Window.               
    
    /* Get the current values of the Search fields. */
    RUN GetSrchAttr ( INPUT pw_Editor , p_Action ).
            
    CASE p_Action:
        WHEN "FIND"      THEN RUN FindText ( pw_Editor ).
           
        WHEN "FIND-NEXT" THEN RUN FindNext ( pw_Editor , FIND-NEXT-OCCURRENCE ).
        
        WHEN "FIND-PREV" THEN RUN FindPrev ( pw_Editor , FIND-PREV-OCCURRENCE ).
        
        WHEN "REPLACE"   THEN RUN ReplaceText ( pw_Editor ).
        
        WHEN "GOTO-LINE" THEN RUN GotoLine ( pw_Editor ).
    END CASE.

    /* Put the current values of the Search fields to the PW attribtes. */
    RUN PutSrchAttr ( INPUT pw_Editor , p_Action ).

    LEAVE.
  END. /* REPEAT */                                                   

  /* Repoint current-window. */
  IF VALID-HANDLE( h_cwin ) THEN ASSIGN CURRENT-WINDOW = h_cwin .
END. /* DO */
