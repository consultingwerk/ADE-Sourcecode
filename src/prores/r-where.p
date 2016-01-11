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
/* r-where.p - called by d-main.p l-main.p and r-main.p */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/t-define.i }

DEFINE VARIABLE qbf-c AS CHARACTER          NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER            NO-UNDO.
DEFINE VARIABLE qbf-m AS CHARACTER EXTENT 6 NO-UNDO.

{ prores/s-top.i } /* frame definition */

DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE WITH FRAME qbf-top:
  IF      qbf-file[2] = "" THEN .
  ELSE IF qbf-file[3] = "" THEN CHOOSE FIELD qbf-file[1 FOR 2].
  ELSE IF qbf-file[4] = "" THEN CHOOSE FIELD qbf-file[1 FOR 3].
  ELSE IF qbf-file[5] = "" THEN CHOOSE FIELD qbf-file[1 FOR 4].
  ELSE                          CHOOSE FIELD qbf-file[1 FOR 5].
  qbf-i = (IF qbf-file[2] = "" THEN 1 ELSE FRAME-INDEX).
  IF qbf-i > 0 THEN
    RUN prores/s-where.p (TRUE,qbf-db[qbf-i] + "." + qbf-file[qbf-i],
                          INPUT-OUTPUT qbf-where[qbf-i]).
END.
COLOR DISPLAY NORMAL qbf-file[1 FOR 5] WITH FRAME qbf-top.

RETURN.
