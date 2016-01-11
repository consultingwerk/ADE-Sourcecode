/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* r-label.p - How big is this thing, really - for report mode. */

/*
Input:
   qbf-ix  = index into qbf-rc. arrays

Output:
   qbf-len = actual width of field  
   qbf-ht  = height of label in lines
*/

{ aderes/s-system.i }
{ aderes/s-define.i }

DEFINE INPUT  PARAMETER qbf-ix  AS INTEGER           NO-UNDO.
DEFINE OUTPUT PARAMETER qbf-len AS INTEGER INITIAL 1 NO-UNDO.
DEFINE OUTPUT PARAMETER qbf-ht  AS INTEGER INITIAL 1 NO-UNDO.

DEFINE VARIABLE qbf-c AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO.

/* The length will be the max of the label (assumed to be a top-label-
   so it may be the longest line of a multi-line label) and the
   data itself.  First deal with label.
*/
ASSIGN
  qbf-c = qbf-rcl[qbf-ix]
  qbf-i = INDEX(qbf-rcl[qbf-ix], "!!":u).
DO WHILE qbf-i > 0:
  ASSIGN
    SUBSTRING(qbf-c,qbf-i,2,"CHARACTER":u) = "/":u
    qbf-i                                  = INDEX(qbf-c, "!!":u).
END.
qbf-i = INDEX(qbf-c, "!":u).
IF qbf-i = 0 THEN 
  qbf-len = LENGTH(qbf-c,"RAW":u).
  
DO WHILE qbf-i > 0:
  ASSIGN
    qbf-ht  = qbf-ht + 1
    qbf-len = MAXIMUM(qbf-len,qbf-i - 1)
    qbf-c   = SUBSTRING(qbf-c,qbf-i + 1,-1,"CHARACTER":u)
    qbf-i   = INDEX(qbf-c, "!":u).
    
  IF qbf-i = 0 THEN 
    qbf-len = MAXIMUM(qbf-len,LENGTH(qbf-c,"RAW":u)).
END.

/* Now get the data length in raw bytes */
ASSIGN qbf-len = MAXIMUM(qbf-len, {aderes/s-size.i &type=qbf-rct[qbf-ix] 
      	       	                    &format=qbf-rcf[qbf-ix]}) NO-ERROR.

/* Check for lookup no-match value which may be longer than the normal
   data.  */
IF qbf-rcc[qbf-ix] = "x":u THEN
  qbf-len = MAXIMUM(qbf-len, LENGTH(ENTRY(7,qbf-rcn[qbf-ix]),"RAW":u)).

RETURN.

/* r-label.p - end of file */

