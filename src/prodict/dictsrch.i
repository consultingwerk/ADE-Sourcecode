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


/* dictsrch.i - BINARY SEARCH THROUGH A SORTED ARRAY. */
/*
Necessary definitions:
DEFINE VARIABLE hb AS INTEGER NO-UNDO.
DEFINE VARIABLE lb AS INTEGER NO-UNDO.

&vector = array name
&extent = array limit
&tofind = value to find
&result = holds element number in array or -1 for not found
*/

ASSIGN
  hb = {&extent}
  lb = 1
  {&result} = 1.

DO WHILE {&result} <> -1:
  {&result} = TRUNCATE((hb + lb) / 2,0).
  IF hb < 1 OR lb > {&extent} OR hb < lb THEN {&result} = -1.
  ELSE IF {&vector}[{&result}] BEGINS {&tofind} THEN LEAVE.
  ELSE IF {&tofind} > {&vector}[{&result}] THEN lb = {&result} + 1.
  ELSE IF {&tofind} < {&vector}[{&result}] THEN hb = {&result} - 1.
  /*ELSE IF {&tofind} = {&vector}[{&result}] THEN LEAVE.*/
END.
DO WHILE {&result} > 1:
  IF {&vector}[{&result} - 1] BEGINS {&tofind} THEN
    {&result} = {&result} - 1.
  ELSE
    LEAVE.
END.
