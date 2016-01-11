/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* Progress Lex Converter 7.1A->7.1C Version 1.26 */

/* e-draw.p - Data Export module main procedure */

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/e-define.i }
{ aderes/e-table.i }

FIND FIRST qbf-esys.

DEFINE OUTPUT PARAMETER po_design AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER max_line  AS INTEGER   NO-UNDO.

DEFINE VARIABLE qbf-layout AS CHARACTER EXTENT 128 NO-UNDO.
DEFINE VARIABLE qbf-c      AS CHARACTER            NO-UNDO.
DEFINE VARIABLE qbf-i      AS INTEGER              NO-UNDO.
DEFINE VARIABLE qbf-j      AS INTEGER INIT 1       NO-UNDO.

/*
+----------------------------- Data Export Layout -----------------------------+
|  Fields:                                                                     |
|        :                                                                     |
|        :                                                                     |
|        :                                                                     |
|                                                                              |
|    Export Type: PROGRESS                                                     |
| Output Headers: yes                                                          |
|    Fixed Width: yes                                                          |
|                                                                              |
|   Record start:                                                              |
|     Record end: cr lf                                                        |
|Field delimiter: '"'                                                          |
|Field separator: ' '                                                          |
+------------------------------------------------------------------------------+

po_design = 
  "         1         2         3         4         5         6         7" 
  + CHR(10) +
  "1234567890123456789012345678901234567890123456789012345678901234567890" 
  + CHR(10).
*/

DO qbf-i = 1 TO qbf-rc#:
  IF qbf-rcc[qbf-i] BEGINS "e":u THEN NEXT.

  qbf-c = qbf-rcf[qbf-i].

  IF qbf-i = 1 THEN
    qbf-layout[qbf-i] = "  Fields: ".

  IF qbf-esys.qbf-fixed AND STRING(0,"9.") = "0," THEN
    RUN comma_swap (INPUT-OUTPUT qbf-c).

  qbf-c = ENTRY(1,qbf-rcn[qbf-i])
        + (IF qbf-esys.qbf-fixed THEN ' "' + qbf-c + '"' ELSE '').

  /*
  IF LENGTH(qbf-c,"RAW":u) + 1 + LENGTH(qbf-layout[qbf-j],"RAW":u) > 73 THEN 
    qbf-j = qbf-j + 1.
  */

  IF qbf-layout[qbf-j] = "":u THEN
    qbf-layout[qbf-j] = "        : ":u.

  ASSIGN
   qbf-layout[qbf-j] = qbf-layout[qbf-j] + qbf-c
   qbf-j             = qbf-j + 1.
  /*                      
                      (IF qbf-i < qbf-rc# AND
                         ((NOT qbf-rcc[qbf-i + 1] BEGINS "e":u
                            AND qbf-i + 1 = qbf-rc#) OR
                           NOT qbf-rcc[qbf-i + 1] BEGINS "e":u)
                       THEN ",":u ELSE "":u).
  IF LENGTH(qbf-layout[qbf-j],"RAW":u) > 70 THEN
    qbf-layout[qbf-j] = SUBSTRING(qbf-layout[qbf-j],1,67,"FIXED":u) + "...":u.
  */
END.

ASSIGN
  qbf-j                 = qbf-j - 1
  qbf-layout[qbf-j + 3] = "     Description: " 
                        + STRING(qbf-esys.qbf-desc,"x(40)")
  qbf-layout[qbf-j + 4] = "     Export Type: " 
                        + STRING(qbf-esys.qbf-type,"x(10)")
  qbf-layout[qbf-j + 5] = "  Output Headers: " 
                        + STRING(qbf-esys.qbf-headers,"yes/no")
  qbf-layout[qbf-j + 6] = "     Fixed Width: "
                        + STRING(qbf-esys.qbf-fixed,"yes/no").                                   
ASSIGN
  qbf-i             = qbf-j + 8
  qbf-layout[qbf-i] = "    Record Start: ".
DO qbf-j = 1 TO NUM-ENTRIES(qbf-esys.qbf-lin-beg,",":u):
  qbf-layout[qbf-i] = qbf-layout[qbf-i] 
                    + ENTRY(INTEGER(ENTRY(qbf-j,qbf-esys.qbf-lin-beg)) 
                    + 1,qbf-ascii) + " ".
END.

ASSIGN
  qbf-i             = qbf-i + 1
  qbf-layout[qbf-i] = "      Record End: ".
DO qbf-j = 1 TO NUM-ENTRIES(qbf-esys.qbf-lin-end,",":u):
  qbf-layout[qbf-i] = qbf-layout[qbf-i] 
                    + ENTRY(INTEGER(ENTRY(qbf-j,qbf-esys.qbf-lin-end)) 
                    + 1,qbf-ascii) + " ".
END.

ASSIGN
  qbf-i             = qbf-i + 1
  qbf-layout[qbf-i] = " Field Delimiter: ".
DO qbf-j = 1 TO NUM-ENTRIES(qbf-esys.qbf-fld-dlm,",":u):
  qbf-c             = ENTRY(INTEGER(ENTRY(qbf-j,qbf-esys.qbf-fld-dlm)) 
                    + 1,qbf-ascii) + " ".
  IF qbf-c = "44" THEN
    qbf-layout[qbf-i] = qbf-layout[qbf-i] + "','".
  ELSE
    qbf-layout[qbf-i] = qbf-layout[qbf-i] + qbf-c.
END.

ASSIGN
  qbf-i = qbf-i + 1
  qbf-layout[qbf-i] = " Field Separator: ".
DO qbf-j = 1 TO NUM-ENTRIES(qbf-esys.qbf-fld-sep,",":u):
  qbf-c  = ENTRY(INTEGER(ENTRY(qbf-j,qbf-esys.qbf-fld-sep)) 
         + 1,qbf-ascii) + " " .
  IF qbf-c = "44" THEN
    qbf-layout[qbf-i] = qbf-layout[qbf-i] + "','".
  ELSE
    qbf-layout[qbf-i] = qbf-layout[qbf-i] + qbf-c.
END.

DO qbf-j = EXTENT(qbf-layout) TO 1 BY -1 WHILE qbf-layout[qbf-j] = "":
END.

DO qbf-i = 1 TO qbf-j:
  ASSIGN
    po_design = po_design + qbf-layout[qbf-i] + CHR(10)
    max_line  = MAXIMUM(max_line,LENGTH(qbf-layout[qbf-i],"RAW":u))
    .
END.

RETURN.

/*--------------------------------------------------------------------------*/
/* sub-proc to convert format from ".," to ",." and back */
{ aderes/p-comma.i }

/* e-draw.p - end of file */

