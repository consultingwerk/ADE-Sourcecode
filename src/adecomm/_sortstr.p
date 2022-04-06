/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
** Program:         adecomm/_sortstr.p
** Author:          Robert Ryan
** Date:            3/15/94
** Purpose:         Sorts an input list, usually file names
**
** Input-output:    pSortString - any string separated by a delimter
** Input            pDelim - delimiter character (if blank, comma used)
*/

define input-output parameter pSortString as char.
define input        parameter pDelim as char.
define var          i as integer no-undo. 
define temp-table   _SORTSTR
                    field fSortString as char.


if pDelim = "" then pDelim = ",".
if num-entries(pSortString,pDelim) = 1 then return.

do i = 1 to num-entries(pSortString,pDelim):
  create _SORTSTR.
  _SORTSTR.fSortString = entry(i,pSortString,pDelim).
end.

pSortString = "".
for each _SORTSTR by fSortString:
  pSortString = if pSortString = "" then _SORTSTR.fSortString
                else pSortString + pDelim + _SORTSTR.fSortString.
end.
