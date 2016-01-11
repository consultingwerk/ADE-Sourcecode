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
/* s-print.p - output printer control codes */

{ prores/s-system.i }
{ prores/s-print.i }

DEFINE INPUT PARAMETER qbf-t AS INTEGER NO-UNDO.
/*
qbf-t = 1 - output initialization string   (qbf-pr-init)
      = 2 - output normal print string     (qbf-pr-norm)
      = 3 - output compressed print string (qbf-pr-comp)
      = 4 - output bold-on print string    (qbf-pr-bon)
      = 5 - output bold-off print string   (qbf-pr-boff)
*/

/* only execute this program for "to", "thru" and "file" device types */
IF CAN-DO("term,view,page,prog",qbf-pr-type[qbf-device]) THEN RETURN.

DEFINE VARIABLE qbf-b AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-l AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-s AS CHARACTER NO-UNDO.

qbf-s = (IF qbf-t = 1 THEN qbf-pr-init[qbf-device]
    ELSE IF qbf-t = 2 THEN qbf-pr-norm[qbf-device]
    ELSE IF qbf-t = 3 THEN qbf-pr-comp[qbf-device]
    ELSE IF qbf-t = 4 THEN qbf-pr-bon[qbf-device]
    ELSE IF qbf-t = 5 THEN qbf-pr-boff[qbf-device]
    ELSE "").

DO qbf-l = 1 TO NUM-ENTRIES(qbf-s):
  IF ENTRY(qbf-l,qbf-s) = "" THEN NEXT.
  qbf-b = INTEGER(ENTRY(qbf-l,qbf-s)).
  IF qbf-b = 0 THEN PUT CONTROL NULL. ELSE PUT CONTROL CHR(qbf-b).
END.

RETURN.
