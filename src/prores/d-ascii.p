/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* d-ascii.p - program to dump data in various 'ascii' formats */

{ prores/s-system.i }
{ prores/s-define.i }

DEFINE VARIABLE qbf-c AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-n AS LOGICAL   NO-UNDO.
DEFINE VARIABLE qbf-o AS CHARACTER NO-UNDO EXTENT 4.

DEFINE VARIABLE qbf-b AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-e AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-k AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-m AS CHARACTER NO-UNDO EXTENT 5.

DEFINE SHARED STREAM qbf-io.

DO qbf-j = 1 TO 4:
  ASSIGN qbf-o[qbf-j] = "".
  DO qbf-i = 1 TO 12:
    IF ENTRY(qbf-i,qbf-d-attr[qbf-j + 2]) <> "" THEN
      ASSIGN qbf-o[qbf-j] = qbf-o[qbf-j] + " "
               + (IF ENTRY(qbf-i,qbf-d-attr[qbf-j + 2]) = "0" THEN "NULL"
                  ELSE "CHR(" + ENTRY(qbf-i,qbf-d-attr[qbf-j + 2]) + ")").
  END.
  ASSIGN qbf-n = qbf-n OR qbf-o[qbf-j] MATCHES "*NULL*".
END.
/*
qbf-o[1] -> qbf-d-attr[3] - line starter
qbf-o[2] -> qbf-d-attr[4] - line delimiter
qbf-o[3] -> qbf-d-attr[5] - field delimiter
qbf-o[4] -> qbf-d-attr[6] - field separator
*/

/* write out initialization stuff for calc fields */
{ prores/s-gen1.i }

IF qbf-d-attr[2] BEGINS "t" THEN DO:
  IF qbf-rcc[qbf-i] BEGINS "e" THEN NEXT.

  DO qbf-i = 1 TO qbf-rc#: /* count_chosen */

    /* Create new PUT statement for every 20 fields.  This avoids the dreaded
       '...cannot be more than 4096 characters in a single statement.' */
    IF qbf-i = 1 OR qbf-i MOD 20 = 0 THEN DO:
      IF qbf-i > 1 THEN PUT STREAM qbf-io UNFORMATTED '.' SKIP(1).

      PUT STREAM qbf-io UNFORMATTED
        'PUT ' (IF qbf-n THEN 'CONTROL' ELSE 'UNFORMATTED') SKIP.
      IF qbf-o[1] <> "" THEN 
        PUT STREAM qbf-io UNFORMATTED SKIP '   ' qbf-o[1].
    END.

    PUT STREAM qbf-io UNFORMATTED SKIP
      '  ' qbf-o[3] ' "'
      ENTRY(1,qbf-rcn[qbf-i])
      '"' qbf-o[3]
      (IF qbf-i < qbf-rc# THEN qbf-o[4] ELSE qbf-o[2]).
  END.
  PUT STREAM qbf-io UNFORMATTED '.' SKIP.
END.

/* write out prepass code */
{ prores/s-gen3.i &count=FALSE }

/* for each with wheres and break-bys */
{ prores/s-gen2.i &by=TRUE &total="qbf-total = 1 TO qbf-total + 1" }

/* calc field code for main loop */
{ prores/s-gen4.i }

DO qbf-i = 1 TO qbf-rc#: /* count_chosen */
  IF qbf-rcc[qbf-i] BEGINS "e" THEN NEXT.
  ASSIGN qbf-j = { prores/s-size.i 
                    &type=qbf-rct[qbf-i] 
                    &format=qbf-rcf[qbf-i] }.

  /* Create new PUT statement for every 20 fields.  This avoids the dreaded
     '...cannot be more than 4096 characters in a single statemtent.' -dma */
  IF qbf-i = 1 OR qbf-i MOD 20 = 0 THEN DO:
    IF qbf-i > 1 THEN 
      PUT STREAM qbf-io UNFORMATTED '.' SKIP(1).

    PUT STREAM qbf-io UNFORMATTED
      '  PUT ' (IF qbf-n THEN 'CONTROL' ELSE 'UNFORMATTED').
    IF qbf-o[1] <> "" THEN 
      PUT STREAM qbf-io UNFORMATTED SKIP '   ' qbf-o[1].
  END.

  IF CAN-DO(qbf-d-attr[7],STRING(qbf-rct[qbf-i])) THEN
    PUT STREAM qbf-io UNFORMATTED SKIP '   ' qbf-o[3].

  ASSIGN qbf-c = qbf-rcf[qbf-i].
  /* double-up embedded escape characters */
  IF qbf-d-attr[1] = "FIXED" AND INDEX(qbf-c,"~~") > 0 THEN
    DO qbf-k = LENGTH(qbf-c) TO 1 BY -1:
      IF SUBSTRING(qbf-c,qbf-k,1) = "~~" THEN
        ASSIGN SUBSTRING(qbf-c,qbf-k,1) = "~~~~".
    END.

  PUT STREAM qbf-io UNFORMATTED SKIP
    '    ' (IF qbf-d-attr[1] = "FIXED"
      THEN '(IF ' + ENTRY(1,qbf-rcn[qbf-i]) + ' = ? THEN "?'
           + FILL(' ',qbf-j - 1) + '" ELSE STRING('
      ELSE '')
    ENTRY(1,qbf-rcn[qbf-i])
    (IF qbf-d-attr[1] = "FIXED" THEN ',"' + qbf-c + '"))' ELSE '') SKIP
    '   '.

  IF CAN-DO(qbf-d-attr[7],STRING(qbf-rct[qbf-i])) THEN
    PUT STREAM qbf-io UNFORMATTED qbf-o[3].

  PUT STREAM qbf-io UNFORMATTED
    (IF qbf-i < qbf-rc# THEN qbf-o[4] ELSE qbf-o[2]).
END.

PUT STREAM qbf-io UNFORMATTED
  '.' SKIP
  'END.' SKIP
  'RETURN.' SKIP.

RETURN.

/* d-ascii.p - end of file */

