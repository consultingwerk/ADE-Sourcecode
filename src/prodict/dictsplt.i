/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
