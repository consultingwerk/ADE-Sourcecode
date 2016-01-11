/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
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



