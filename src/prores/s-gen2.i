/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* s-gen2.i - for each with wheres and break-bys */

PUT STREAM qbf-io UNFORMATTED 'FOR '.

DO qbf-i = 1 TO 5 WHILE qbf-file[qbf-i] <> "":
  qbf-c = (IF qbf-asked[qbf-i] = "" THEN
            qbf-of[qbf-i]
          ELSE IF qbf-of[qbf-i] = "" THEN
            "WHERE " + qbf-asked[qbf-i]
          ELSE IF qbf-of[qbf-i] BEGINS "OF" THEN
            qbf-of[qbf-i] + " WHERE " + qbf-asked[qbf-i]
          ELSE
            "WHERE (" + SUBSTRING (qbf-of[qbf-i],7) + ") AND (" + qbf-asked[qbf-i] + ")"
          ).
  IF qbf-c <> "" THEN qbf-c = " " + qbf-c.
  PUT STREAM qbf-io UNFORMATTED
    'EACH ' qbf-db[qbf-i] '.' qbf-file[qbf-i] qbf-c ' NO-LOCK'.
  IF qbf-i < 5 AND qbf-file[qbf-i + 1] <> "" THEN
    PUT STREAM qbf-io UNFORMATTED ',' SKIP '  '.
END.

qbf-c = ''.
DO qbf-i = 1 TO 5 WHILE qbf-order[qbf-i] <> "":
  qbf-c = qbf-c + ' BY ' + qbf-order[qbf-i].
END.
IF {&by} AND qbf-c <> "" THEN
  PUT STREAM qbf-io UNFORMATTED SKIP ' {&break}' qbf-c.

PUT STREAM qbf-io UNFORMATTED SKIP
  '  {&total}' {&on} ':' SKIP.
