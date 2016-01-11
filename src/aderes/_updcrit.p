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
/*----------------------------------------------------------------------------

File: _updcrit.p - rebuild WHERE and BY combo-box in frame ftoolbar

Description:

Input Parameters:     <none>

Output Parameters:    <none>

Author: Doug Adams

Created: 04/13/94 - 2:52 pm

-----------------------------------------------------------------------------*/

{ aderes/s-define.i }
{ aderes/s-menu.i }

DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-l AS LOGICAL   NO-UNDO.
DEFINE VARIABLE qbf-s AS CHARACTER NO-UNDO.

ASSIGN
  crit-box:DELIMITER                    = CHR(3)
  crit-box:LIST-ITEMS IN FRAME fToolbar = "".

FOR EACH qbf-where WHERE qbf-where.qbf-wcls > ""
  BREAK BY qbf-where.qbf-wtbl:
  /*
   * There is a maximum number of chars that can be displayed. RESULTS
   * will show 240 of them, followed by ... . This is to avoid problems with
   * the number of chars allowed in a frame.
   */
  ASSIGN 
    qbf-s = IF LENGTH(qbf-where.qbf-wcls,"RAW":u) > 240 THEN
              SUBSTRING(qbf-where.qbf-wcls, 1, 240,"FIXED":u) + "...":u
            ELSE qbf-where.qbf-wcls
    qbf-l = crit-box:ADD-LAST(
             (IF FIRST(qbf-where.qbf-wtbl) THEN "SELECT " ELSE "AND SELECT ") +
                REPLACE(qbf-s, CHR(10), " ":u)) IN FRAME fToolbar.
END.

DO qbf-i = 1 TO NUM-ENTRIES(qbf-sortby):
  ASSIGN 
    qbf-l = crit-box:ADD-LAST("SORTED BY "
          + REPLACE(ENTRY(qbf-i, qbf-sortby), "DESC":u, "DESCENDING")
          + (IF INDEX(ENTRY(qbf-i, qbf-sortby), "DESC":u) = 0 THEN
             " ASCENDING" ELSE "")) IN FRAME fToolbar.
END.

IF crit-box:NUM-ITEMS IN FRAME fToolbar > 0 THEN
  crit-box:SCREEN-VALUE IN FRAME fToolbar =
  ENTRY(1, crit-box:LIST-ITEMS IN FRAME fToolbar,CHR(3)).

&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
crit-box:INNER-LINES IN FRAME fToolbar = crit-box:NUM-ITEMS IN FRAME fToolbar.
&ENDIF

/* _updcrit.p - end of file */

