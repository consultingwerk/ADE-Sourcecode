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
DEFINE INPUT PARAMETER  rbs     AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  dtype   AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAMETER  dlmtr   AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER rvalue  AS CHARACTER  NO-UNDO.

DEFINE VARIABLE line            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE radio-text      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE r-item1         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE r-item2         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE ix              AS INTEGER    NO-UNDO.
DEFINE VARIABLE cnt             AS INTEGER    NO-UNDO.
DEFINE VARIABLE cTmp            AS CHARACTER  NO-UNDO.

IF dlmtr = "":U OR dlmtr = ? THEN dlmtr = ",":U.
ASSIGN cnt = NUM-ENTRIES(rbs,CHR(10)).

IF cnt = 1 THEN DO:
  DO ix = 1 TO NUM-ENTRIES(rbs,dlmtr):
    cTmp = cTmp + dlmtr + (IF ix MOD 2 = 1 THEN CHR(10) ELSE "":U) +
           ENTRY(ix, rbs, dlmtr).
  END. /* Do ix 1 to num-items */
  ASSIGN rbs = TRIM(cTmp,CHR(10) + dlmtr)
         cnt = NUM-ENTRIES(rbs,CHR(10)).
END.

/* CNT is the number of radio-item, radio-value pairs in rbs.
   rbs will look like "Item 1", 0, "Item 2", 2, "Item 3", 4.
   Note that we need to remove all the "quotes" and we do not care
   about the output values.  So we will return a 
     rvalue = "Item 1, value, Item 2, value, Item 3, value"  */

DO ix = 1 to cnt:
  ASSIGN line    = ENTRY(ix, rbs, CHR(10)).
  IF NUM-ENTRIES(LINE,"~"":U) > 2 THEN DO:
    ASSIGN r-item1 = TRIM(REPLACE(ENTRY (2, line, "~"":U), dlmtr, 
                                  IF dlmtr = CHR(3) THEN CHR(5) ELSE CHR(3)))
           r-item2 = TRIM (ENTRY (2, ENTRY(3, line, "~"":U),dlmtr)).
    IF NUM-ENTRIES(line,"~"") > 3 AND r-item2 = "":U THEN
      /* It must be a character radio-set and the values have quotes */
      r-item2 = "~"":U + ENTRY(4,line,"~"":U) + "~"":U.

    radio-text = (IF ix > 1 THEN
                    radio-text + dlmtr + r-item1 + dlmtr + r-item2
                  ELSE
                    r-item1 + dlmtr + r-item2).
  END.
  ELSE
    radio-text = radio-text + line.
END.

ASSIGN rvalue = radio-text.

/* _rbtns.p - end of file */

