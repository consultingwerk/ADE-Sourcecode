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
/*
* i-write.p - write out directory file
*/

{ aderes/s-system.i }
{ aderes/i-define.i }

DEFINE INPUT PARAMETER qbf-f AS CHARACTER NO-UNDO. /* forward address */

DEFINE VARIABLE qbf-i AS INTEGER NO-UNDO. /* scrap/loop */
DEFINE VARIABLE qbf-l AS LOGICAL NO-UNDO. /* scrap/loop */

problemo:
DO ON ERROR UNDO problemo, RETRY problemo:
  IF RETRY THEN DO:
    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l,"error":u,"ok":u,
      SUBSTITUTE("There is a problem writing &1.  The directory can not be updated.",qbf-qdfile)).

    RETURN "Error: No write":u.
  END.

  IF SEARCH(qbf-qdfile) <> ? THEN
    OS-COPY VALUE(qbf-qdfile) VALUE("qbf.d":u).

  OUTPUT TO VALUE(qbf-qdfile) NO-ECHO.
  PUT UNFORMATTED
    '/*':u SKIP
    'config= directory':u  SKIP
    'version= ':u qbf-vers SKIP.

    IF qbf-f <> ? THEN 
      PUT UNFORMATTED 'forward= "':u qbf-f '"':u SKIP.

    DO qbf-i = 1 TO EXTENT(qbf-dir-ent):
      IF qbf-dir-ent[qbf-i] = "" THEN NEXT.
      PUT CONTROL 'query[':u STRING(qbf-dir-num[qbf-i]) ']= ':u '"" ':u.
      EXPORT
        qbf-dir-ent[qbf-i]
        qbf-dir-dbs[qbf-i].
    END.

    PUT UNFORMATTED '*/':u SKIP.
  OUTPUT CLOSE.
END.
RETURN "Ok":u.

/* i-write.p - end of file */

