/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _del_cd.p

Description:
   This routine deletes a _code section from the Workshop's internal memory.
   This is more than just deleting the _code record.  Because _code is stored
   in a double-link list, we must make sure the list stays consistent.
   
   Associated _code-text records are also deleted.

Input Parameters:
   p_Code-id -  Recid of _code to be deleted.

Output Parameters:
   <None>
       
Author: Wm. T. Wood 
Date Created: Feb. 8, 1997

----------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p_code-id AS RECID NO-UNDO.

/* Include files */
{ workshop/code.i }        /* Code Section TEMP-TABLE definition            */

DEFINE VARIABLE next-id LIKE _code._next-id.
DEFINE VARIABLE prev-id LIKE _code._prev-id.

/* Find the code record and save the links to and from it. */
FIND _code WHERE RECID(_code) eq p_code-id.   
ASSIGN next-id = _code._next-id
       prev-id = _code._prev-id.

/* This include file actually deletes the old record. */
{ workshop/delet_cd.i }

/* Reconnect the link list. */
IF prev-id ne ? THEN DO:
  FIND _code WHERE RECID(_code) eq prev-id.
  _code._next-id = next-id.
END.
IF next-id ne ? THEN DO:
  FIND _code WHERE RECID(_code) eq next-id.
  _code._prev-id = prev-id.
END.



