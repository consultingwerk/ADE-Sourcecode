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

