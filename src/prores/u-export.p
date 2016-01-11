/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* u-export.p - sample export format program */

{ prores/s-define.i}

/*
this program exports data in the following fashion:

a) numeric fields are output as regular numbers.
b) dates are written in yyyymmdd format.
c) strings are surrounded by quote marks.
c) logicals are written as 'true' or 'false'.
e) fields are separated by commas.
f) lines are terminated by LF or CRLF, depending on opsys.
*/

/* necessary shared definitions */
/*** removed see s-define.i ?

DEFINE SHARED VARIABLE qbf-asked AS CHARACTER EXTENT  5 NO-UNDO.
DEFINE SHARED VARIABLE qbf-db    AS CHARACTER EXTENT  5 NO-UNDO.
DEFINE SHARED VARIABLE qbf-file  AS CHARACTER EXTENT  5 NO-UNDO.
DEFINE SHARED VARIABLE qbf-of    AS CHARACTER EXTENT  5 NO-UNDO.
DEFINE SHARED VARIABLE qbf-order AS CHARACTER EXTENT  5 NO-UNDO.
DEFINE SHARED VARIABLE qbf-rc#   AS INTEGER             NO-UNDO.
DEFINE SHARED VARIABLE qbf-rcn   AS CHARACTER EXTENT 64 NO-UNDO.
DEFINE SHARED VARIABLE qbf-rct   AS INTEGER   EXTENT 64 NO-UNDO.
***/

/* this stream is already opened for us */
DEFINE SHARED STREAM   qbf-io.

DEFINE VARIABLE qbf-c AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO.

/* write out definition for shared variable */
PUT STREAM qbf-io UNFORMATTED
  'DEFINE SHARED VARIABLE qbf-total AS INTEGER NO-UNDO.' SKIP
  'qbf-total = 0.' SKIP.

/* write out for-each statement */
PUT STREAM qbf-io UNFORMATTED 'FOR '.
DO qbf-i = 1 TO 5 WHILE qbf-file[qbf-i] <> "":
  qbf-c = (IF qbf-asked[qbf-i] = "" THEN
            qbf-of[qbf-i]
          ELSE IF qbf-of[qbf-i] = "" THEN
            "WHERE " + qbf-asked[qbf-i]
          ELSE IF qbf-of[qbf-i] BEGINS "OF" THEN
            qbf-of[qbf-i] + " WHERE " + qbf-asked[qbf-i]
          ELSE
            "(" + qbf-of[qbf-i] + ") AND (" + qbf-where[qbf-i] + ")"
          ).
  IF qbf-c <> "" THEN qbf-c = " " + qbf-c.
  PUT STREAM qbf-io UNFORMATTED
    'EACH ' (IF qbf-db[qbf-i] = "" THEN "" ELSE qbf-db[qbf-i] + ".")
    qbf-file[qbf-i] qbf-c ' NO-LOCK'.
  IF qbf-i < 5 AND qbf-file[qbf-i + 1] <> "" THEN
    PUT STREAM qbf-io UNFORMATTED ',' SKIP '  '.
END.

/* this builds the by-clause part of the for-each */
qbf-c = ''.
DO qbf-i = 1 TO 5 WHILE qbf-order[qbf-i] <> "":
  qbf-c = qbf-c + ' BY ' + qbf-order[qbf-i].
END.
IF qbf-c <> "" THEN PUT STREAM qbf-io UNFORMATTED SKIP qbf-c.

PUT STREAM qbf-io UNFORMATTED SKIP
  '  qbf-total = 1 TO qbf-total + 1:' SKIP
  '  PUT UNFORMATTED'.

/* output the field list */
DO qbf-i = 1 TO qbf-rc#: /* count_chosen */

  IF qbf-rct[qbf-i] = 1 THEN /* character */
    qbf-c = '"~~"" ' + qbf-rcn[qbf-i] + ' "~~""'.
  ELSE
  IF qbf-rct[qbf-i] = 2 THEN /* date */
    qbf-c = 'STRING(DAY(' + qbf-rcn[qbf-i] + ') + 100 * MONTH('
          + qbf-rcn[qbf-i] + ') + 10000 * YEAR(' + qbf-rcn[qbf-i]
          + '),"99999999")'.
  ELSE
  IF qbf-rct[qbf-i] = 3 THEN /* logical */
    qbf-c = 'TRIM(STRING(' + qbf-rcn[qbf-i] + ',"true/false"))'.
  ELSE
    qbf-c = qbf-rcn[qbf-i].

  PUT STREAM qbf-io UNFORMATTED SKIP
    '    ' qbf-c ' ' (IF qbf-i = qbf-rc# THEN 'SKIP' ELSE '","').
END.

/* end the beast */
PUT STREAM qbf-io UNFORMATTED
  '.' SKIP
  'END.' SKIP
  'RETURN.' SKIP.

RETURN.
