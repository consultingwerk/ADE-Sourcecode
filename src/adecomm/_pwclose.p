/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/**************************************************************************
    Procedure:  _pwclose.p
    
    Purpose:    Execute Procedure Window File->Close command.

    Syntax :    RUN adecomm/_pwclose.p.

    Parameters:
    Description:
    Notes  :
    Authors: John Palazzo
    Date   : January, 1994
**************************************************************************/

/* Procedure Window Global Defines. */
{ adecomm/_pwglob.i }

DEFINE VARIABLE pw_Window AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE pw_Editor AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE OK_Close    AS LOGICAL   NO-UNDO.

/* --- Begin SCM changes --- */
DEFINE VAR scm_ok       AS LOGICAL           NO-UNDO.
DEFINE VAR scm_context  AS CHARACTER         NO-UNDO.
DEFINE VAR scm_filename AS CHARACTER         NO-UNDO.
/* --- End SCM changes ----- */

DO ON STOP UNDO, LEAVE:
    /* Get widget handles of Procedure Window and its editor widget. */
    RUN adecomm/_pwgetwh.p ( INPUT SELF , OUTPUT pw_Window ).
    RUN adecomm/_pwgeteh.p  ( INPUT pw_Window , OUTPUT pw_Editor ).
    
    /* --- Begin SCM changes --- */
    ASSIGN scm_context  = STRING( pw_Editor )
           scm_filename = pw_Editor:NAME .
    RUN adecomm/_adeevnt.p 
        (INPUT  {&PW_NAME} , INPUT "Before-Close",
         INPUT scm_context , INPUT scm_filename , 
         OUTPUT scm_ok ).
    IF scm_ok = FALSE THEN RETURN ERROR.
    /* --- End SCM changes ----- */

    RUN adecomm/_pwclosf.p ( INPUT pw_Window, INPUT pw_Editor ,
                           INPUT "Close", OUTPUT OK_Close ).

    IF OK_Close <> TRUE THEN RETURN ERROR.

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
    
    RUN adecomm/_pwdelpw.p (INPUT pw_Window ).
     
END.
