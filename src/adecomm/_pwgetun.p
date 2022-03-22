/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/**************************************************************************
    Procedure:  _pwgetun.p
    
    Purpose:    Returns a Procedure Window Untitled procedure name.
    
    Syntax :    RUN adecomm/_pwgetun.p ( OUTPUT p_Untitled_Name ).

    Parameters:
    Description:
        An Untitled Procedure Window has a procedure name of the form
            "Untitled:n"
        where n is some number from 1 to 9999.
        
        The untitled name algorithm:
        
          1. Search all the windows in the current session looking for
             Untitled Procedure Windows, regardless of how a Procedure
             Window was created.
             
          2. Return the maximum Untitled procedure number plus one as
             the next Untitled procedure number.
             
             For example, if there are two open Untitled PW's, Untitled:1
             and Untitled:5, the name of the next Untitled PW will be
             Untitled:6.
    
    Notes  :
    Authors: John Palazzo
    Date   : January, 1994
**************************************************************************/

/* Procedure Window Global Defines. */
{ adecomm/_pwglob.i }

DEFINE OUTPUT PARAMETER p_Untitled_Name AS CHARACTER NO-UNDO.

DEFINE VARIABLE pw_Window AS HANDLE   NO-UNDO.
DEFINE VARIABLE pw_Editor AS HANDLE   NO-UNDO.
DEFINE VARIABLE l_count   AS INTEGER  NO-UNDO.

DO:
  /* Start with the session's first window. */
  /* ksu 94/02/24 SUBSTRING use default mode */
  ASSIGN pw_Window = SESSION:FIRST-CHILD.
  DO WHILE VALID-HANDLE( pw_Window ):
    /* Is this a Procedure Window? Check :NAME to verify that it is. */
    IF pw_Window:NAME = {&PW_NAME} THEN DO:                                     
      /* Get the PW's editor handle. */
      RUN adecomm/_pwgeteh.p (pw_Window,OUTPUT pw_Editor ).

      IF pw_Editor:NAME BEGINS {&PW_Untitled} THEN
        ASSIGN l_count = MAXIMUM(l_count,
          INTEGER(SUBSTRING(pw_Editor:NAME,
            R-INDEX(pw_Editor:NAME,":":u) + 1,-1,"CHARACTER":u))).
    END.
    ASSIGN pw_Window = pw_Window:NEXT-SIBLING.
  END.
  ASSIGN l_count = l_count + 1
         p_Untitled_Name = {&PW_Untitled} + TRIM(STRING(l_Count,">>>9":u)).
END.

/* _pwgetun.p - end of file */

