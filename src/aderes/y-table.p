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
/* y-table.p - select tables */

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/j-define.i }

DEFINE OUTPUT PARAMETER qbf-chg AS LOGICAL NO-UNDO. /* has it changed ?? */

DEFINE VARIABLE qbf-c  AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-k  AS INTEGER   NO-UNDO. /* table index */
DEFINE VARIABLE qbf-o  AS CHARACTER NO-UNDO. /* original setting when started */
DEFINE VARIABLE qbf-l  AS LOGICAL   NO-UNDO. /* scrap */
DEFINE VARIABLE pos    AS INTEGER   NO-UNDO. /* detail tbl position */

ASSIGN
  qbf-o     = qbf-tables
  qbf-chg   = FALSE.

/* los - As far as I can tell qbf-depth is always 0 and I don't know
   what it means anyway!  But leave this in anyway.
*/
IF qbf-depth > 0 THEN DO:
  /* run automatic file joiner (a la Joe Alsop) */
  qbf-k = INTEGER(ENTRY(1,qbf-tables)).
  RUN aderes/j-table1.p ("*":u, yes, INPUT-OUTPUT qbf-k).
  IF qbf-k = 0 AND qbf-tables = "" THEN qbf-module = ?.
  IF qbf-k = 0 THEN RETURN.
  qbf-tables = STRING(qbf-k).
  RUN aderes/j-same.p (qbf-k,OUTPUT qbf-tables,OUTPUT qbf-c).
  RUN aderes/j-link.p.
END.
ELSE IF qbf-depth = 0 THEN DO:
  /* run side-by-side file picker (default) */
  RUN aderes/j-table2.p (INPUT-OUTPUT qbf-tables, OUTPUT qbf-l).

  IF qbf-l THEN DO:
    IF qbf-tables = "" THEN qbf-module = ?.
    IF qbf-module = ? THEN RETURN.

    RUN aderes/j-link.p.
  END.
END.

/* remove WHERE-clauses for deselected tables */
FOR EACH qbf-where WHERE NOT CAN-DO(qbf-tables,STRING(qbf-where.qbf-wtbl)):
  DELETE qbf-where.
END.

IF qbf-l THEN DO:
   
   assign
      qbf-redraw = TRUE
      qbf-chg    = TRUE
      qbf-dirty  = TRUE
    .


  IF qbf-o <> qbf-tables THEN DO:
    ASSIGN
      qbf-field  = (IF qbf-module = "l" THEN TRUE ELSE FALSE).

      /* Fix master detail if tables were removed or changed around.  Leave
       it with the same table as the first detail table if that table is
       still in the query and it's not the first table now.
       Otherwise, leave it at the same physical split point (i.e., between 
       tables 1 and 2 or 2 and 3) if we can.
    */
    IF qbf-detail > 0 AND 
       LOOKUP(STRING(qbf-detail),qbf-tables) < 2 THEN DO:
      pos = LOOKUP(STRING(qbf-detail),qbf-o). /* old pos of first child tbl */
      IF pos > NUM-ENTRIES(qbf-tables) THEN
        qbf-detail = 0. /* nothing after split point - clear this */
      ELSE
        qbf-detail = INTEGER(ENTRY(pos,qbf-tables)).
    END.
  END.

  RUN adecomm/_setcurs.p ("WAIT":u).
  RUN aderes/s-level.p. 
  IF qbf-o <> qbf-tables THEN RUN aderes/y-field.p (OUTPUT qbf-l).
END.

IF qbf-rc# = 0 AND qbf-module <> "l" THEN 
  qbf-tables = "".
IF qbf-tables = "" THEN 
  ASSIGN
    qbf-field  = FALSE
    qbf-module = ?.

RETURN.

/* y-table.p - end of file */

