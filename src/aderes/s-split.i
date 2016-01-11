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
/* s-split.i - this routine will split a string into several array elements */

/*
  {&src} = variable to split into array elements
  {&dst} = array variable to hold pieces
  {&num} = number of pieces
  {&len} = maximum length of each piece
  {&chr} = char to split at (e.g. " " or ",")
*/

ASSIGN
  {&dst}    = ""
  {&dst}[1] = {&src}.

DO qbf-h = 1 TO {&num} - 1:
  IF LENGTH({&dst}[qbf-h],"CHARACTER":u) > {&len} THEN 
    ASSIGN
      qbf-i             = R-INDEX({&dst}[qbf-h],"{&chr}":u,{&len})
      qbf-i             = (IF qbf-i = 0 THEN {&len} ELSE qbf-i)
      {&dst}[qbf-h + 1] = TRIM(SUBSTRING({&dst}[qbf-h],qbf-i + 1,-1,
                                         "CHARACTER":u))
      {&dst}[qbf-h    ] = SUBSTRING({&dst}[qbf-h],1,qbf-i,"CHARACTER":u).
  ELSE
    {&dst}[qbf-h + 1] = "".
END.

/* s-split.i - end of file */

