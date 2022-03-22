/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/**************************************************************************
    Procedure:  _pwhelp.p
    
    Purpose:    Execute Procedure Window Help menu commands.

    Syntax :    RUN adecomm/_pwhelp.p ( INPUT p_Action ) .

    Parameters:
    Description:
    Notes  :
    Authors: John Palazzo
    Date   : January, 1994
**************************************************************************/

/* Procedure Window Global Defines include. */
{ adecomm/_pwglob.i }

/* Procedure Window Attributes include. */
{ adecomm/_pwattr.i }

/* Help Related Defines for Procedure Windows. */
{ adecomm/commeng.i }


DEFINE INPUT PARAMETER p_Action AS CHARACTER NO-UNDO.

DEFINE VARIABLE pw_Window       AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE pw_Editor       AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE h_cwin          AS WIDGET-HANDLE NO-UNDO.

/* MAIN */
DO:
  REPEAT ON STOP UNDO, RETRY:
    IF RETRY THEN LEAVE.
    /* Get widget handle of Procedure Window. */
    RUN adecomm/_pwgetwh.p ( INPUT SELF , OUTPUT pw_Window ).
    /* Get widget handle of Procedure Window editor widget. */
    RUN adecomm/_pwgeteh.p ( INPUT pw_Window , OUTPUT pw_Editor ).

    /* Save current-window handle to restore later. */
    ASSIGN h_cwin         = CURRENT-WINDOW
           CURRENT-WINDOW = pw_Window.
    
    CASE p_Action:

        WHEN "KEYWORD"  THEN
            RUN adecomm/_kwhelp.p ( INPUT pw_Editor , 
                                    INPUT "comm"    , 
                                    INPUT 0 /* Zero is Help Topics */  ).
        WHEN "KEYWORD-HELP"  THEN
            RUN adecomm/_kwhelp.p ( INPUT pw_Editor , 
                                    INPUT "comm"    , 
                                    INPUT ? ).
        WHEN "TOPICS" THEN
            RUN adecomm/_adehelp.p 
                ( INPUT "comm" , INPUT "TOPICS" ,
                  INPUT {&Procedure_Window_Contents} , INPUT ? ).    

        WHEN "MASTER" THEN
            RUN adecomm/_adehelp.p 
                ( INPUT "mast" , INPUT "TOPICS" ,
                  INPUT ? , INPUT ? ).    

        WHEN "CONTENTS" THEN
            RUN adecomm/_adehelp.p 
                ( INPUT "comm" , INPUT "CONTEXT" ,
                  INPUT {&Procedure_Window_Contents} , INPUT ? ).    

        WHEN "MESSAGES" THEN
            RUN prohelp/_msgs.p.

        WHEN "RECENT-MESSAGES" THEN
            RUN prohelp/_rcntmsg.p.

        OTHERWISE
            MESSAGE PROGRAM-NAME(1) "received invalid action:" p_Action "."
                VIEW-AS ALERT-BOX ERROR.

    END CASE.
    LEAVE.
  END. /* REPEAT */                                                   

  /* Repoint current-window. */
  IF VALID-HANDLE( h_cwin ) THEN ASSIGN CURRENT-WINDOW = h_cwin .
END. /* DO */
