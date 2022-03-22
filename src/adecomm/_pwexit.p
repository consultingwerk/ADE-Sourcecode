/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/**************************************************************************
    Procedure:  _pwexit.p
    
    Purpose:    Attempt to close all open Procedure Windows for a specified
                Parent.
    
    Syntax :    RUN adecomm/_pwexit.p ( INPUT  p_Parent_ID ,
                                        OUTPUT p_OK_Close ).

    Parameters:
        INPUT
        p_Parent_ID
            - String value indicating "Parent" of Procedure Window.
              Pass Null ("") if no parent. The p_Parent_ID parameter should be
              the name of the calling tool.  When the tool exits, it calls
              adecomm/_pwexit.p and passes p_Parent_ID again. This procedure
              uses p_Parent_ID to determine which Procedure Windows to close.

              Its best to pass the application's or tool's startup procedure
              name. This allows adecomm/_pwexit.p to determine if the caller
              is the startup routine. If it is, then all PW's are closed,
              not just those owned by the caller. This takes care of those
              PW's created by PRO*Tools.

        OUTPUT
        p_OK_Close  
            - If all PW's of the Parent are closed successfully, p_OK_Close is
              returned as TRUE. Otherwise, its returned as FALSE or Unknown.
                 
    Description:
    
          1. Search all the windows in the current session looking for
             Procedure Windows belonging to the Parent specified by
             p_Parent_Id. 
             
          2. Tell the PW to close. If all PW's of the Parent are closed
             successfully, p_OK_Close is returned as TRUE. Otherwise, its
             returned as FALSE or Unknown.
    
    Notes  :
    Authors: John Palazzo
    Date   : January, 1994
**************************************************************************/

/* Procedure Window Global Defines. */
{ adecomm/_pwglob.i }

DEFINE INPUT  PARAMETER p_Parent_ID AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER p_OK_Close  AS LOGICAL   NO-UNDO INIT TRUE.

DEFINE VARIABLE pw_Window  AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE pw_Editor  AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE Del_Window AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE Modified   AS LOGICAL       NO-UNDO.
DEFINE VARIABLE Pro_Quit   AS LOGICAL       NO-UNDO.
DEFINE VARIABLE Start_Proc AS CHARACTER     NO-UNDO.

/* --- Begin SCM changes --- */
DEFINE VAR scm_ok       AS LOGICAL           NO-UNDO.
DEFINE VAR scm_context  AS CHARACTER         NO-UNDO.
DEFINE VAR scm_filename AS CHARACTER         NO-UNDO.
/* --- End SCM changes ----- */

/* Internal Procedure Include. */
{ adecomm/pruntool.i }

REPEAT ON STOP UNDO, RETRY:
    IF RETRY
    THEN DO:
        ASSIGN p_OK_Close = FALSE.
        RETURN ERROR.
    END.
    
    /* Start with the session's first window. */
    ASSIGN pw_Window   = SESSION:FIRST-CHILD
           p_Parent_ID = ( IF p_Parent_ID = ? THEN "?" ELSE p_Parent_ID )
           .
           
    IF p_Parent_ID <> "" AND p_Parent_ID <> ? THEN
    DO:
        /* Check if the parent is the startup procedure. If so, user
           is exiting Progress. Set Pro_Quit so all PW will be deleted.
        */
        RUN RunBy (INPUT ? , OUTPUT Start_Proc).
        ASSIGN Pro_Quit = (p_Parent_ID = Start_Proc).
    END.
    
    DO WHILE VALID-HANDLE( pw_Window ):
        /* Is this a Procedure Window and is it a "child window" of the
           Parent window passed?
        */
        IF pw_Window:NAME = {&PW_NAME}
           AND (pw_WINDOW:PRIVATE-DATA = p_Parent_ID OR Pro_Quit)
        THEN DO:                                                           
            /* Get widget handle of Procedure Window editor widget. */
            RUN adecomm/_pwgeteh.p ( INPUT pw_Window , OUTPUT pw_Editor ).
            RUN adecomm/_pwfmod.p ( INPUT pw_Editor , OUTPUT Modified ).
           
            /* --- Begin SCM changes --- */
            ASSIGN scm_context  = STRING( pw_Editor )
                   scm_filename = pw_Editor:NAME .
            RUN adecomm/_adeevnt.p
                (INPUT  {&PW_NAME} , INPUT "Before-Close",
                 INPUT scm_context , INPUT scm_filename ,
                 OUTPUT scm_ok ).
            IF scm_ok = FALSE THEN
            DO:
                ASSIGN p_OK_Close = FALSE.  /* Cancel */
                RETURN.
            END.
            /* --- End SCM changes ----- */
            
            IF ( Modified = TRUE )
            THEN DO:
            
                RUN adecomm/_pwclosf.p ( INPUT pw_Window, INPUT pw_Editor ,
                                       INPUT "Exit", OUTPUT p_OK_Close ).
                /*
                ** Next two statements by changed by R. Ryan to allow cancel
                ** to process seperately from pressing NO.
                */
                IF p_OK_Close = FALSE THEN RETURN ERROR.
                IF p_OK_Close = ? THEN LEAVE.
            END.

            /* --- Begin SCM changes --- */
            RUN adecomm/_adeevnt.p
                (INPUT  {&PW_NAME} , INPUT "Close",
                 INPUT scm_context , INPUT scm_filename ,
                 OUTPUT scm_ok ).
            /* --- End SCM changes ----- */
 
            /* --- Begin SCM changes --- */
            /* Do custom shutdown -- this is generally a no-op, but it can
               be used to cleanup custom modifications. */
            RUN adecomm/_adeevnt.p 
                ( INPUT {&PW_NAME} ,
                  INPUT "SHUTDOWN",
                  INPUT STRING(pw_Window) , STRING(pw_Window:PRIVATE-DATA) ,
                  OUTPUT scm_ok ).
            /* --- End SCM changes ----- */

            /* Now close/delete the window. */
            ASSIGN Del_Window = pw_Window
                   pw_Window  = pw_Window:NEXT-SIBLING.
            RUN adecomm/_pwdelpw.p (INPUT Del_Window ).
        END.
        ELSE ASSIGN pw_Window = pw_Window:NEXT-SIBLING.
    END.

    LEAVE.

END.
