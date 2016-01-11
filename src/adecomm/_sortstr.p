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
