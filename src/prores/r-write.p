/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* r-write.p - generate report program */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/r-define.i }

DEFINE INPUT PARAMETER qbf-f AS CHARACTER NO-UNDO.

DEFINE VARIABLE qbf-b AS CHARACTER           NO-UNDO.
DEFINE VARIABLE qbf-c AS CHARACTER           NO-UNDO.
DEFINE VARIABLE qbf-e AS INTEGER   INITIAL 0 NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER             NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER             NO-UNDO.
DEFINE VARIABLE qbf-k AS INTEGER             NO-UNDO.
DEFINE VARIABLE qbf-l AS INTEGER             NO-UNDO.
DEFINE VARIABLE qbf-m AS CHARACTER EXTENT  9 NO-UNDO.
DEFINE VARIABLE qbf-s AS INTEGER             NO-UNDO.
DEFINE VARIABLE qbf-w AS INTEGER   EXTENT  9 NO-UNDO.
DEFINE VARIABLE qbf-x AS INTEGER             NO-UNDO.
DEFINE VARIABLE qbf-y AS CHARACTER EXTENT  9 NO-UNDO.

DEFINE STREAM qbf-io.

RUN prores/s-prefix.p (qbf-dir-nam,OUTPUT qbf-c).
IF qbf-f BEGINS "_" THEN qbf-c = "".

qbf-s = qbf-r-size - qbf-r-attr[1] + 1. /* report width */

/*
I turned off the STATUS DEFAULT ... stuff since it seems to no longer
be needed.  Code generation is fairly quick; and I think that the extra
time to load the language program (which will probably displace this
procedure in the edit-buffer for low -e values) most likely will slow
the system down more than displaying the status messages will 'appear'
to 'speed' it up (by giving the user something to watch).

from t-r-eng.p: (set #1)
  qbf-lang[ 1] = 'Writing report structure...'
  qbf-lang[ 2] = 'Writing report definitions...'
  qbf-lang[ 3] = 'Writing report header...'
  qbf-lang[ 4] = 'Writing report footer...'
  qbf-lang[ 5] = 'Writing report prepass code...'
  qbf-lang[ 6] = 'Writing report order and group information...'
  qbf-lang[ 7] = 'Writing report form...'
  qbf-lang[ 8] = 'Writing report body...'
  qbf-lang[ 9] = 'Writing report array handling...'
*/

OUTPUT STREAM qbf-io TO VALUE(qbf-c + qbf-f + ".p") NO-ECHO NO-MAP.
/*--------------------------------------------------------------------------*/
IF true or NOT qbf-f BEGINS "_" THEN DO:
  /*STATUS DEFAULT "Writing report structure..."*/

  PUT STREAM qbf-io UNFORMATTED
    '/*' SKIP
    'config= report' SKIP
    'version= ' qbf-vers SKIP.

  PUT STREAM qbf-io CONTROL 'name= '. EXPORT STREAM qbf-io qbf-name.
  DO qbf-i = 1 TO 9:
    PUT STREAM qbf-io UNFORMATTED ENTRY(qbf-i,
      'left-margin,page-size,column-spacing,line-spacing,top-margin,'
        + 'before-body,after-body,summary,page-eject')
      '= '
      (IF qbf-i = 8 THEN
        ENTRY(qbf-r-attr[8] + 1,"false,true")
      ELSE
        STRING(qbf-r-attr[qbf-i])
      ) SKIP.
  END.

  /* file,relation,where */
  DO qbf-i = 1 TO 5 WHILE qbf-file[qbf-i] <> "":
    PUT STREAM qbf-io CONTROL 'file' STRING(qbf-i) '= '.
    EXPORT STREAM qbf-io
      qbf-db[qbf-i] + "." + qbf-file[qbf-i]
      qbf-of[qbf-i]
      qbf-where[qbf-i].
  END.

  /*order*/
  DO qbf-i = 1 TO 5 WHILE qbf-order[qbf-i] <> "":
    PUT STREAM qbf-io UNFORMATTED 'order' STRING(qbf-i) '= "'
      SUBSTRING(qbf-order[qbf-i],1,INDEX(qbf-order[qbf-i] + " "," ") - 1)
      '" "'
      (IF qbf-order[qbf-i] MATCHES "* DESC" THEN 'de' ELSE 'a')
      'scending"' SKIP.
  END.

  /* header1,2,3 */
  DO qbf-i = 1 TO 8:
    ASSIGN
      qbf-j = qbf-i * 3 - 2
      qbf-c = ENTRY(qbf-i,"first-only,last-only,top-left,top-center,"
            + "top-right,bottom-left,bottom-center,bottom-right").
    PUT STREAM qbf-io CONTROL qbf-c '= '.
    EXPORT STREAM qbf-io qbf-r-head[qbf-j FOR 3].
  END.

  /* fields,label,format,accum */
  DO qbf-i = 1 TO qbf-rc#:
    PUT STREAM qbf-io CONTROL 'field' STRING(qbf-i) '= '.
    EXPORT STREAM qbf-io
      qbf-rcn[qbf-i] qbf-rcl[qbf-i] qbf-rcf[qbf-i] qbf-rca[qbf-i]
      ENTRY(qbf-rct[qbf-i],qbf-dtype) qbf-rcc[qbf-i].
  END.

  PUT STREAM qbf-io UNFORMATTED '*/' SKIP(1).
END.
/*--------------------------------------------------------------------------*/
/*STATUS DEFAULT "Writing report definitions..."*/

PUT STREAM qbf-io UNFORMATTED
  'DEFINE VARIABLE qbf-i AS INTEGER NO-UNDO.' SKIP
  'DEFINE VARIABLE qbf-t AS INTEGER NO-UNDO.' SKIP.

/* write out initialization stuff for calc fields */
{ prores/s-gen1.i }

/* fields for summary report */
DO qbf-i = 1 TO qbf-rc#:
  IF INDEX(qbf-rca[qbf-i],"$") > 0 AND qbf-r-attr[8] = 1 THEN
    PUT STREAM qbf-io UNFORMATTED
      'DEFINE VARIABLE qbf-' STRING(qbf-i,"999") '# AS DECIMAL NO-UNDO.' SKIP.
  IF INDEX(qbf-rca[qbf-i],"&") > 0 AND NOT qbf-rcc[qbf-i] BEGINS "e" THEN
    PUT STREAM qbf-io UNFORMATTED
      'DEFINE VARIABLE qbf-' STRING(qbf-i,"999")
        '& LIKE ' ENTRY(1,qbf-rcn[qbf-i]) ' INITIAL ? NO-UNDO.' SKIP.
END.

PUT STREAM qbf-io UNFORMATTED SKIP(1)
  'ASSIGN' SKIP
  '  qbf-total = 0' SKIP
  '  qbf-t     = TIME.' SKIP(1).


/* If there are no headers but there's top spacing, put a flag into
   first header temporarily to force a FORM HEADER with skips - the 
   only way to cause spacing to happen.
*/
qbf-k = 0.
DO qbf-i = 7 TO 15 WHILE qbf-k = 0:
  qbf-k = qbf-k + LENGTH(qbf-r-head[qbf-i]).
END.
IF qbf-k = 0 AND qbf-r-attr[5] > 1 THEN 
  qbf-r-head[7] = CHR(5). /* flag w/ not-printable character */

qbf-k = 0.
DO qbf-i = 1 TO 24 WHILE qbf-k = 0:
  qbf-k = qbf-k + LENGTH(qbf-r-head[qbf-i]).
END.
IF qbf-k > 0 THEN DO:
  PUT STREAM qbf-io UNFORMATTED SKIP 'DO FOR '.
  DO qbf-i = 1 TO 5 WHILE qbf-file[qbf-i] <> "":
    PUT STREAM qbf-io UNFORMATTED
      (IF qbf-i = 1 THEN '' ELSE ',')
      qbf-db[qbf-i] '.' qbf-file[qbf-i].
  END.
  PUT STREAM qbf-io UNFORMATTED ':' SKIP.
END.

/*--------------------------------------------------------------------------*/
/*STATUS DEFAULT "Writing report header..."*/
/*STATUS DEFAULT "Writing report footer..."*/

DO qbf-l = 6 TO 15 BY 9: /* 6=header 15=footer */
  ASSIGN
    qbf-j = 0
    qbf-m = ""
    qbf-w = 0
    qbf-x = 0
    qbf-y = "".
  DO qbf-i = 1 TO 9:
    IF qbf-r-head[qbf-i + qbf-l] = "" THEN NEXT.
    qbf-j = qbf-j + 1.
    RUN prores/r-expand.p (INPUT qbf-r-head[qbf-i + qbf-l],
                           OUTPUT qbf-m[qbf-i],OUTPUT qbf-w[qbf-i]).
    qbf-x = MAXIMUM(qbf-x,qbf-w[qbf-i]).
  END.

  IF qbf-j = 0 THEN NEXT.

  /* generate 'left' and 'right' portions of headers and footers */
  qbf-j = { prores/s-max3.i qbf-w[7] qbf-w[8] qbf-w[9] }.
  DO qbf-i = 1 TO 3:
    IF qbf-w[qbf-i] > 0 AND qbf-w[qbf-i + 6] > 0
      AND qbf-w[qbf-i] + qbf-w[qbf-i + 6] < qbf-s THEN
      qbf-y[qbf-i * 2 - 1] = qbf-m[qbf-i] + ' SPACE('
                           + STRING(MAXIMUM(0,qbf-s - qbf-w[qbf-i] - qbf-j))
                           + ') ' + qbf-m[qbf-i + 6].
    ELSE DO:
      IF qbf-w[qbf-i] > 0 THEN qbf-y[qbf-i * 2 - 1] = qbf-m[qbf-i].
      IF qbf-w[qbf-i + 6] > 0 THEN
        qbf-y[qbf-i * 2] = 'SPACE(' + STRING(MAXIMUM(0,qbf-s - qbf-j)) + ') '
                         + qbf-m[qbf-i + 6].
    END.
  END.

  /* generate 'centered' portion of headers and footers */
  qbf-j = MAXIMUM(0,(qbf-s - {prores/s-max3.i qbf-w[4] qbf-w[5] qbf-w[6]}) / 2).
  IF qbf-w[4] > 0 THEN qbf-y[7] = 'SPACE(' + STRING(qbf-j) + ') ' + qbf-m[4].
  IF qbf-w[5] > 0 THEN qbf-y[8] = 'SPACE(' + STRING(qbf-j) + ') ' + qbf-m[5].
  IF qbf-w[6] > 0 THEN qbf-y[9] = 'SPACE(' + STRING(qbf-j) + ') ' + qbf-m[6].

  /* now write out form definition */
  PUT STREAM qbf-io UNFORMATTED '  FORM HEADER'.
  qbf-k = (IF qbf-l = 6  AND qbf-r-attr[5] > 1 THEN qbf-r-attr[5] - 1
      ELSE IF qbf-l = 15 AND qbf-r-attr[7] > 0 THEN qbf-r-attr[7] ELSE ?).
  IF qbf-k <> ? THEN
    PUT STREAM qbf-io UNFORMATTED SKIP '    SKIP(' qbf-k ')'.
  qbf-j = 0.
  DO qbf-i = 1 TO 9:
    qbf-k = (IF qbf-l = 6 THEN ((qbf-i + 5) MODULO 9) + 1 ELSE qbf-i).
    IF qbf-y[qbf-k] = "" THEN NEXT.
    PUT STREAM qbf-io UNFORMATTED SKIP '    ' 
      (IF INDEX(qbf-y[qbf-k],CHR(5)) > 0 THEN '""' ELSE qbf-y[qbf-k]) ' SKIP'.
    qbf-j = qbf-j + 1.
  END.
  IF qbf-l = 6 AND qbf-r-attr[6] > 0 THEN PUT STREAM qbf-io UNFORMATTED
    (IF qbf-j = 0 THEN ' SKIP' ELSE '') '(' qbf-r-attr[6] ') '.
  PUT STREAM qbf-io UNFORMATTED SKIP
    '    WITH FRAME qbf-' STRING(qbf-l = 6,"header/footer")
      ' PAGE-' (IF qbf-l = 6 THEN "TOP" ELSE "BOTTOM")
      ' COLUMN ' qbf-r-attr[1]
      ' WIDTH ' MAXIMUM(qbf-r-size - 1 + qbf-r-attr[1],qbf-x)
      ' NO-ATTR-SPACE NO-LABELS NO-BOX.' SKIP
    '  VIEW FRAME qbf-' STRING(qbf-l = 6,"header/footer") '.' SKIP(1).
END.
IF qbf-r-head[7] = CHR(5) THEN qbf-r-head[7] = "".


/*--------------------------------------------------------------------------*/
/*STATUS DEFAULT "Writing report first-frame..."*/
/*STATUS DEFAULT "Writing report last-frame..."*/

ASSIGN
  qbf-m = ""
  qbf-w = 0.
DO qbf-i = 1 TO 6:
  IF qbf-r-head[qbf-i] = "" THEN NEXT.
  RUN prores/r-expand.p
    (INPUT qbf-r-head[qbf-i],OUTPUT qbf-m[qbf-i],OUTPUT qbf-w[qbf-i]).
END.

/* report first-page-only frame */
{ prores/r-write.i
  &base=1
  &first="SKIP '    SKIP(1)'"
  &name=qbf-first
  &disp="SKIP '  DISPLAY WITH FRAME qbf-first.'"
}
/* report last-page-only frame */
{ prores/r-write.i
  &base=4
  &last="SKIP '    SKIP(1)'"
  &name=qbf-last
}


IF qbf-k > 0 THEN
  PUT STREAM qbf-io UNFORMATTED SKIP 'END.' SKIP(1).

/*--------------------------------------------------------------------------*/
/*STATUS DEFAULT "Writing report prepass code..."*/

{ prores/s-gen3.i &count=FALSE }

/*--------------------------------------------------------------------------*/
/*STATUS DEFAULT "Writing report order and group information..."*/

{ prores/s-gen2.i &by=TRUE &break=" BREAK" &total="qbf-total = 1 TO qbf-total + 1" }

/* page-eject beasty */
/* if we are page-ejecting on the last break group, and we are also */
/* doing a summary report, then move the page-eject up one level of */
/* break group so we don't end up with one record per page.         */

qbf-i = qbf-r-attr[9].
IF qbf-r-attr[8] = 1 AND (qbf-i = 5 OR qbf-order[qbf-i + 1] = "")
  THEN qbf-i = qbf-i - 1.
IF qbf-i > 0 THEN
  PUT STREAM qbf-io UNFORMATTED
    '  IF FIRST-OF('
      SUBSTRING(qbf-order[qbf-i],1,INDEX(qbf-order[qbf-i] + " "," ") - 1)
      ') AND NOT FIRST('
      SUBSTRING(qbf-order[qbf-i],1,INDEX(qbf-order[qbf-i] + " "," ") - 1)
      ') THEN PAGE.' SKIP.

/*--------------------------------------------------------------------------*/
/*STATUS DEFAULT "Writing report form..."*/

/* calc field code for main loop */
{ prores/s-gen4.i }

PUT STREAM qbf-io UNFORMATTED '  FORM' SKIP.
DO qbf-i = 1 TO qbf-rc#:

  ASSIGN
    qbf-c = (IF INDEX(qbf-rca[qbf-i],"$") > 0 THEN
              'qbf-' + STRING(qbf-i,"999") + '#'
            ELSE
              ENTRY(1,qbf-rcn[qbf-i]))
    qbf-b = qbf-rcf[qbf-i]
    qbf-j = 0.
  IF qbf-rcc[qbf-i] BEGINS "e" THEN
    ASSIGN
      qbf-e = MAXIMUM(qbf-e,INTEGER(SUBSTRING(qbf-rcc[qbf-i],2)))
      qbf-c = SUBSTRING(qbf-rcn[qbf-i],1,LENGTH(qbf-rcn[qbf-i]) - 2)
            + '[qbf-i]'.

  /* mash format up for summarized nonnumeric fields */
  IF INDEX(qbf-rca[qbf-i],"$") = 0 THEN .
  ELSE IF qbf-rct[qbf-i] = 1 THEN /*char*/ qbf-j = LENGTH(STRING(   "",qbf-b)).
  ELSE IF qbf-rct[qbf-i] = 2 THEN /*date*/ qbf-j = LENGTH(STRING(TODAY,qbf-b)).
  ELSE IF qbf-rct[qbf-i] = 3 THEN /*log */ qbf-j = LENGTH(STRING( TRUE,qbf-b)).
  IF qbf-j > 0 THEN qbf-b = FILL(">",qbf-j - 1) + "9".

  /* fake-out HH:MM - only problem is we loose aggregate capability */
  /*IF qbf-b BEGINS "HH:MM" AND qbf-rct[qbf-i] = 4 /*integer*/ THEN
    qbf-b = FILL("9",LENGTH(qbf-rcf[qbf-i])).*/

  /* double-up embedded escape characters */
  IF INDEX(qbf-b,"~~") > 0 THEN
    DO qbf-j = LENGTH(qbf-b) TO 1 BY -1:
      IF SUBSTRING(qbf-b,qbf-j,1) = "~~" THEN
        SUBSTRING(qbf-b,qbf-j,1) = "~~~~".
    END.

  PUT STREAM qbf-io UNFORMATTED
    '    ' qbf-c
      ' COLUMN-LABEL "' qbf-rcl[qbf-i]
      '" FORMAT "' qbf-b '" VIEW-AS FILL-IN'.

  PUT STREAM qbf-io UNFORMATTED
    (IF qbf-rcn[qbf-i + 1] <> "" AND qbf-r-attr[3] <> 1
      THEN ' SPACE(' + STRING(qbf-r-attr[3]) + ')' ELSE '') SKIP.
END.
IF qbf-r-attr[4] > 1 THEN
  PUT STREAM qbf-io UNFORMATTED '  SKIP(' qbf-r-attr[4] - 1 ')' SKIP.
PUT STREAM qbf-io UNFORMATTED
  '    WITH NO-ATTR-SPACE COLUMN ' qbf-r-attr[1]
    ' WIDTH ' qbf-r-size - 1 + qbf-r-attr[1]
    ' NO-BOX NO-VALIDATE.' SKIP.

/*--------------------------------------------------------------------------*/

IF qbf-r-attr[8] = 1 THEN DO:
  ASSIGN
    qbf-c = ""
    qbf-j = 0
    qbf-k = 0.
  DO qbf-i = 1 TO 5 WHILE qbf-order[qbf-i] <> "":
    qbf-c = SUBSTRING(qbf-order[qbf-i],1,INDEX(qbf-order[qbf-i] + " "," ") - 1).
  END.
  DO qbf-i = 1 TO qbf-rc#:
    IF INDEX(qbf-rca[qbf-i],"$") = 0 THEN NEXT.
    PUT STREAM qbf-io UNFORMATTED
      '  ACCUMULATE ' ENTRY(1,qbf-rcn[qbf-i]) ' (SUB-'
        STRING(qbf-rct[qbf-i] < 4,"COUNT/TOTAL") /*1:char,2:date,3:log*/
        ' BY ' qbf-c ').' SKIP.
    ASSIGN
      qbf-j = qbf-j + 1
      qbf-k = MAXIMUM(qbf-i,qbf-k).
  END.

  IF qbf-j > 1 THEN PUT STREAM qbf-io UNFORMATTED '  ASSIGN'.
  DO qbf-i = 1 TO qbf-rc#:
    IF INDEX(qbf-rca[qbf-i],"$") = 0 THEN NEXT.
    PUT STREAM qbf-io UNFORMATTED
      (IF qbf-j = 1 THEN '' ELSE '  ')
      '  qbf-' STRING(qbf-i,"999") '# = (ACCUM SUB-'
        STRING(qbf-rct[qbf-i] < 4,"COUNT/TOTAL") /*1:char,2:date,3:log*/
        ' BY ' qbf-c ' ' ENTRY(1,qbf-rcn[qbf-i]) ')'
      (IF qbf-i = qbf-k THEN '.' ELSE '') SKIP.
  END.

  PUT STREAM qbf-io UNFORMATTED
    '  IF NOT LAST-OF(' qbf-c ') THEN NEXT.' SKIP.
    /*'  IF LAST-OF(' qbf-c ') THEN ' SKIP.*/

END.

/*--------------------------------------------------------------------------*/
/*STATUS DEFAULT "Writing report body..."*/

PUT STREAM qbf-io UNFORMATTED
  '  DISPLAY'.

DO qbf-i = 1 TO qbf-rc#:
  qbf-c = (IF INDEX(qbf-rca[qbf-i],"$") > 0 AND qbf-r-attr[8] = 1 THEN
            'qbf-' + STRING(qbf-i,"999") + '#'
          ELSE
            ENTRY(1,qbf-rcn[qbf-i])).
  IF qbf-rcc[qbf-i] BEGINS "e" THEN DO:
    qbf-c = SUBSTRING(qbf-c,1,LENGTH(qbf-c) - 2).
    PUT STREAM qbf-io UNFORMATTED
      SKIP '    ' qbf-c '[1] @ ' + qbf-c + '[qbf-i]'.
  END.
  /*ELSE IF qbf-rcf[qbf-i] BEGINS "HH:MM" AND qbf-rct[qbf-i] = 4 /*int*/ THEN
    PUT STREAM qbf-io UNFORMATTED SKIP
      '    STRING(' qbf-c ',"' qbf-rcf[qbf-i] '") @ ' qbf-c.*/
  ELSE IF qbf-rca[qbf-i] = "&" AND NOT qbf-rcc[qbf-i] BEGINS "e" THEN
    PUT STREAM qbf-io UNFORMATTED SKIP
      '    ' qbf-c ' WHEN ' qbf-c ' <> qbf-' STRING(qbf-i,"999") '&'.
  ELSE IF qbf-rca[qbf-i] = "" OR qbf-rca[qbf-i] = "$" THEN
    PUT STREAM qbf-io UNFORMATTED SKIP '    ' qbf-c.
  ELSE DO qbf-j = 1 TO 6:
    ASSIGN
      qbf-b = STRING(qbf-j)
      qbf-b
        = (IF INDEX(qbf-rca[qbf-i],"a" + qbf-b) > 0 THEN ' SUB-AVERAGE' ELSE '')
        + (IF INDEX(qbf-rca[qbf-i],"n" + qbf-b) > 0 THEN ' SUB-MINIMUM' ELSE '')
        + (IF INDEX(qbf-rca[qbf-i],"x" + qbf-b) > 0 THEN ' SUB-MAXIMUM' ELSE '')
        + (IF INDEX(qbf-rca[qbf-i],"c" + qbf-b) > 0 THEN ' SUB-COUNT'   ELSE '')
        + (IF INDEX(qbf-rca[qbf-i],"t" + qbf-b) > 0 THEN ' SUB-TOTAL'   ELSE '')
      qbf-b = SUBSTRING(qbf-b,2).
    IF qbf-b = "" THEN NEXT.
    IF qbf-j < 6 THEN
      qbf-b = qbf-b + " BY "
        + SUBSTRING(qbf-order[qbf-j],1,INDEX(qbf-order[qbf-j] + " "," ") - 1).
/*
    DO qbf-k = 1 TO (IF qbf-j = 6 THEN 0 ELSE qbf-j):
      qbf-b = qbf-b + " BY "
        + SUBSTRING(qbf-order[qbf-k],1,INDEX(qbf-order[qbf-k] + " "," ") - 1).
    END.
*/
    PUT STREAM qbf-io UNFORMATTED SKIP '    ' qbf-c ' (' qbf-b ')'.
  END.
END.
PUT STREAM qbf-io UNFORMATTED '.' SKIP.

/*--------------------------------------------------------------------------*/
IF qbf-e > 1 THEN DO:
  /*STATUS DEFAULT "Writing report array handling..."*/

  PUT STREAM qbf-io UNFORMATTED
    '  DO qbf-i = 2 TO ' STRING(qbf-e) ':' SKIP
    '    DOWN.' SKIP
    '    CLEAR.' SKIP
    '    DISPLAY'.
  DO qbf-i = 1 TO qbf-rc#:
    IF NOT qbf-rcc[qbf-i] BEGINS "e" THEN NEXT.
    qbf-c = SUBSTRING(qbf-rcn[qbf-i],1,LENGTH(qbf-rcn[qbf-i]) - 2).
    PUT STREAM qbf-io UNFORMATTED
      SKIP '      ' qbf-c '[qbf-i]'
      (IF INTEGER(SUBSTRING(qbf-rcc[qbf-i],2)) < qbf-e
        THEN ' WHEN qbf-i <= ' + SUBSTRING(qbf-rcc[qbf-i],2)
        ELSE '').
  END.
  PUT STREAM qbf-io UNFORMATTED
    '.' SKIP
    '  END.' SKIP.
END.

/*--------------------------------------------------------------------------*/
/* Hide repeating value assignments */
qbf-j = 0.
DO qbf-i = 1 TO qbf-rc# WHILE qbf-j < 2:
  IF INDEX(qbf-rca[qbf-i],"&") > 0 AND NOT qbf-rcc[qbf-i] BEGINS "e" THEN
    qbf-j = qbf-j + 1.
END.
IF qbf-j > 0 THEN DO:
  IF qbf-j > 1 THEN PUT STREAM qbf-io UNFORMATTED '  ASSIGN'.
  DO qbf-i = 1 TO qbf-rc#:
    IF INDEX(qbf-rca[qbf-i],"&") = 0 OR qbf-rcc[qbf-i] BEGINS "e" THEN NEXT.
    IF qbf-j > 1 THEN PUT STREAM qbf-io UNFORMATTED SKIP '  '.
    PUT STREAM qbf-io UNFORMATTED
      '  qbf-' STRING(qbf-i,"999") '& = ' ENTRY(1,qbf-rcn[qbf-i]).
  END.
  PUT STREAM qbf-io UNFORMATTED '.' SKIP.
END.

/*--------------------------------------------------------------------------*/

PUT STREAM qbf-io UNFORMATTED 'END.' SKIP(1).

/*--------------------------------------------------------------------------*/

IF qbf-r-head[4] + qbf-r-head[5] + qbf-r-head[6] <> "" THEN
  PUT STREAM qbf-io UNFORMATTED
    '  DISPLAY WITH FRAME qbf-last.' SKIP.

PUT STREAM qbf-io UNFORMATTED
  'PAGE.' SKIP
  'RETURN.' SKIP.

OUTPUT STREAM qbf-io CLOSE.
/*STATUS DEFAULT.*/

RETURN.
