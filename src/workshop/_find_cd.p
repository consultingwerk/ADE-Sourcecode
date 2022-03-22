/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _find_cd.p

Description:
   This routine finds particular code blocks and returns there recid.
   This is implemented as a seperate .p
   
   Associated _code-text records are also deleted.

Input Parameters:
   p_Proc-id - Recid of the procedure file
   p_case    - The case we are looking for. 
   p_subcase - The subcase (of the case) we are looking for. 
     This file finds the:
      FIRST - first code block (p_subcase ignored)
      LAST  - last code block  (p_subcase ignored)     

Output Parameters:
   p_Code-id -  Recid of _code found (or ? if none exist).
       
Author: Wm. T. Wood 
Date Created: Feb. 8, 1997

----------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER p_proc-id AS INTEGER NO-UNDO.
DEFINE INPUT  PARAMETER p_case    AS CHAR    NO-UNDO.
DEFINE INPUT  PARAMETER p_subcase AS CHAR    NO-UNDO.
DEFINE OUTPUT PARAMETER p_code-id AS RECID   NO-UNDO.

/* Include files */
{ workshop/code.i }        /* Code Section TEMP-TABLE definition            */

DEFINE VARIABLE next-id LIKE _code._next-id.
DEFINE VARIABLE prev-id LIKE _code._prev-id.

CASE p_case:
  WHEN "FIRST":U THEN DO:
    /* Find the code record and save the links to and from it. */
    FIND FIRST _code WHERE _code._P-recid eq p_Proc-ID
                       AND _code._prev-id eq ? NO-ERROR.   
  END.
     
  WHEN "LAST":U THEN DO:
    /* Find the code record and save the links to and from it. */
    FIND LAST _code WHERE _code._P-recid eq p_Proc-ID
                      AND _code._next-id eq ? NO-ERROR.
  END.
     
END CASE.

/* return the recid of the code block found. */
IF AVAILABLE _code THEN p_code-id = RECID(_code).
