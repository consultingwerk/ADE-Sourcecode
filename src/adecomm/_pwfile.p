/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/**************************************************************************
    Procedure:  _pwfile.p
    
    Purpose:    Execute Procedure Window File menu commands.

    Syntax :    RUN adecomm/_pwfile.p ( INPUT p_Action ) .

    Parameters:
    Description:
    Notes  :    Added "ADD-REPOS" feature to support IZ 2513 Error when
                trying to save structured include in Dynamics framework.

    Authors: John Palazzo
    Date   : January, 1994
**************************************************************************/

/* Procedure Window Global Defines include. */
{ adecomm/_pwglob.i }

/* Procedure Window Attributes include. */
{ adecomm/_pwattr.i }

DEFINE INPUT PARAMETER p_Action AS CHARACTER NO-UNDO.

DEFINE VARIABLE pw_Window       AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE pw_Editor       AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE h_cwin          AS WIDGET-HANDLE NO-UNDO.

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
    
    CASE p_Action:
    
        WHEN "NEW"      THEN RUN adecomm/_pwnew.p.
        
        WHEN "OPEN"     THEN RUN adecomm/_pwopen.p.

        WHEN "NEW-PWIN" THEN RUN adecomm/_pwnewpw.p ( INPUT pw_Window ).

        WHEN "ADD-REPOS" THEN RUN adecomm/_pwaddfile.p (INPUT pw_Editor).

        WHEN "SAVE"     THEN RUN adecomm/_pwsave.p (INPUT pw_Editor).
        
        WHEN "SAVE-AS"  THEN RUN adecomm/_pwsavas.p (INPUT pw_Editor).
        
        WHEN "PRINT"    THEN RUN adecomm/_pwprint.p.
        
        WHEN "CLOSE"    THEN RUN adecomm/_pwclose.p.
        
    END CASE.
    LEAVE.
  END. /* REPEAT */                                                   

  /* Repoint current-window. */
  IF VALID-HANDLE( h_cwin ) THEN ASSIGN CURRENT-WINDOW = h_cwin .
END. /* DO */
