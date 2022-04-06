/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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

