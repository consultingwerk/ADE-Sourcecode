/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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

