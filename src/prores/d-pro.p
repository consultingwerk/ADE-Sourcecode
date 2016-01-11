/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* d-pro.p - program to dump data in 'progress export' format */

{ prores/s-system.i }
{ prores/s-define.i }

DEFINE VARIABLE qbf-c AS CHARACTER           NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER             NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER             NO-UNDO.

DEFINE VARIABLE qbf-b AS CHARACTER           NO-UNDO.
DEFINE VARIABLE qbf-e AS INTEGER   INITIAL 0 NO-UNDO.
DEFINE VARIABLE qbf-k AS INTEGER             NO-UNDO.
DEFINE VARIABLE qbf-m AS CHARACTER EXTENT  5 NO-UNDO.

DEFINE SHARED STREAM qbf-io.

/* write out initialization stuff for calc fields */
{ prores/s-gen1.i }

/* write out prepass code */
{ prores/s-gen3.i &count=FALSE }

/* for each with wheres and break-bys */
{ prores/s-gen2.i &by=TRUE &total="qbf-total = 1 TO qbf-total + 1" }

/* calc field code for main loop */
{ prores/s-gen4.i }

PUT STREAM qbf-io UNFORMATTED
  '  EXPORT'.

DO qbf-i = 1 TO qbf-rc#: /* count_chosen */
  IF qbf-rcc[qbf-i] BEGINS "e" THEN NEXT.
  PUT STREAM qbf-io UNFORMATTED SKIP '    ' ENTRY(1,qbf-rcn[qbf-i]).
END.

PUT STREAM qbf-io UNFORMATTED
  '.' SKIP
  'END.' SKIP
  'RETURN.' SKIP.

RETURN.
