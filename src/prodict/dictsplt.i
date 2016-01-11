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


/* dictsplt.i - this routine will split a string into several array elements */

/*
  {&src} = variable to split into array elements
  {&dst} = array variable to hold pieces
  {&num} = number of pieces
  {&len} = maximum length of each piece
  {&chr} = char to split at (e.g. " " or ",")
*/

{&dst}[1] = {&src}.

DO j = 1 TO {&num} - 1:
  IF LENGTH({&dst}[j],"character") > {&len} THEN
    ASSIGN
      i             = R-INDEX({&dst}[j],"{&chr}",{&len})
      i             = (IF i = 0 THEN {&len} ELSE i)
      {&dst}[j + 1] = TRIM(SUBSTRING({&dst}[j],i + 1,-1,"character"))
      {&dst}[j    ] = SUBSTRING({&dst}[j],1,i,"character").
  ELSE
    {&dst}[j + 1] = "".
END.
