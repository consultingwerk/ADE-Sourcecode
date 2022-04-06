/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
