/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/**************************************************************************
    Procedure:  _pwnewpw.p
    
    Purpose:    Execute Procedure Window File->New Procedure Window command.

    Syntax :    RUN adecomm/_pwnewpw.p ( INPUT p_Window ).

    Parameters:
    Description:
    Notes  :
    Authors: John Palazzo
    Date   : February, 1994
**************************************************************************/

/* Procedure Window Global Defines. */
{ adecomm/_pwglob.i }

DEFINE INPUT PARAMETER p_Window AS WIDGET NO-UNDO.

DEFINE VARIABLE pw_Window AS WIDGET  NO-UNDO.
DEFINE VARIABLE pw_Editor AS WIDGET  NO-UNDO.
DEFINE VARIABLE Ed_Font   AS INTEGER NO-UNDO.

DEFINE VARIABLE OK_Close     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE Old_Name     AS CHARACTER NO-UNDO.
DEFINE VARIABLE New_Name     AS CHARACTER NO-UNDO.

DO ON STOP UNDO, LEAVE:
    /* Get widget handle of parent PW editor widget. */
    RUN adecomm/_pwgeteh.p ( INPUT p_Window , OUTPUT pw_Editor ).

    /* Store off the parent PW editor font. */
    ASSIGN Ed_Font = pw_Editor:FONT.
            
    /* Open New Procedure Window. */
    RUN adecomm/_pwmain.p (INPUT p_Window:PRIVATE-DATA
                                     /* PW Parent ID    */,
                           INPUT ""  /* Files to open   */,
                           INPUT ""  /* PW Command      */ ).
    /* Get handle of new PW. */
    ASSIGN pw_Window = SESSION:LAST-CHILD.
  
    /* Get handle of new PW editor widget. */
    RUN adecomm/_pwgeteh.p ( INPUT pw_Window , OUTPUT pw_Editor ).
  
    /* Inherit font of parent editor. */
    IF pw_Editor:FONT <> Ed_Font
    THEN ASSIGN pw_Editor:FONT = Ed_Font.

END.
