/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* l-write.p - generate labels program */

{ prores/s-system.i }
{ prores/s-define.i }

DEFINE INPUT PARAMETER qbf-f AS CHARACTER NO-UNDO.

DEFINE VARIABLE qbf-a AS LOGICAL            NO-UNDO.
DEFINE VARIABLE qbf-c AS CHARACTER          NO-UNDO.
DEFINE VARIABLE qbf-g AS CHARACTER EXTENT { prores/s-limlbl.i } NO-UNDO.
DEFINE VARIABLE qbf-h AS INTEGER            NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER            NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER            NO-UNDO.
DEFINE VARIABLE qbf-l AS INTEGER            NO-UNDO. /* left-curly brace */
DEFINE VARIABLE qbf-m AS CHARACTER          NO-UNDO. /* mandatory */
DEFINE VARIABLE qbf-n AS INTEGER  INITIAL 0 NO-UNDO.
DEFINE VARIABLE qbf-p AS CHARACTER          NO-UNDO. /* indent */
DEFINE VARIABLE qbf-r AS INTEGER            NO-UNDO. /* right-curly brace */
DEFINE VARIABLE qbf-s AS CHARACTER          NO-UNDO.

DEFINE STREAM qbf-io.

RUN prores/s-prefix.p (qbf-dir-nam,OUTPUT qbf-p).
IF qbf-f BEGINS "_" THEN 
  qbf-p = "".

OUTPUT STREAM qbf-io TO VALUE(qbf-p + qbf-f + ".p") NO-ECHO NO-MAP.
/*--------------------------------------------------------------------------*/
IF true or NOT qbf-f BEGINS "_" THEN DO:
  PUT STREAM qbf-io UNFORMATTED
    '/*' SKIP
    'version= ' qbf-vers SKIP
    'config= label' SKIP.
  PUT STREAM qbf-io CONTROL 'name= '. EXPORT STREAM qbf-io qbf-name.

  /* file,relation,where */
  DO qbf-i = 1 TO 5 WHILE qbf-file[qbf-i] <> "":
    PUT STREAM qbf-io CONTROL 'file' STRING(qbf-i) '= '.
    EXPORT STREAM qbf-io
      qbf-db[qbf-i] + "." + qbf-file[qbf-i]
      qbf-of[qbf-i]
      qbf-where[qbf-i].
  END.

  DO qbf-i = 1 TO 5 WHILE qbf-order[qbf-i] <> "":
    PUT STREAM qbf-io UNFORMATTED 'order' STRING(qbf-i) '= "'
      SUBSTRING(qbf-order[qbf-i],1,INDEX(qbf-order[qbf-i] + " "," ") - 1) '" "'
      (IF qbf-order[qbf-i] MATCHES "* DESC" THEN 'de' ELSE 'a') 'scending"'
      SKIP.
  END.

  PUT STREAM qbf-io UNFORMATTED 'omit-blank= '
    STRING(qbf-l-attr[6] <> 0,"true/false") SKIP.
  DO qbf-i = 1 TO 7:
    IF qbf-i = 6 THEN qbf-i = 7.
    PUT STREAM qbf-io UNFORMATTED
      ENTRY(qbf-i,'left-margin,label-spacing,total-height,top-margin,'
      + 'number-across,,number-copies') '= ' qbf-l-attr[qbf-i] SKIP.
  END.

  DO qbf-i = 1 TO { prores/s-limlbl.i }:
    IF qbf-l-text[qbf-i] = "" THEN NEXT.
    PUT STREAM qbf-io CONTROL 'text' qbf-i '= '.
    EXPORT STREAM qbf-io qbf-l-text[qbf-i].
  END.
  PUT STREAM qbf-io UNFORMATTED '*/' SKIP(1).
END.
/*--------------------------------------------------------------------------*/

/*--------------------------------------------------------------------------*/
qbf-n = 1.
DO qbf-i = 1 TO { prores/s-limlbl.i }:
  ASSIGN
    qbf-g[qbf-n] = qbf-g[qbf-n] + qbf-l-text[qbf-i]
    qbf-j        = LENGTH(qbf-g[qbf-n]).
  IF qbf-j > 1 AND SUBSTRING(qbf-g[qbf-n],qbf-j,1) = "~~" THEN
    qbf-g[qbf-n] = SUBSTRING(qbf-g[qbf-n],1,qbf-j - 1).
  ELSE
    qbf-n = qbf-n + 1.
END.

DO qbf-i = 1 TO { prores/s-limlbl.i }:
  IF qbf-i > qbf-l-attr[3]  THEN qbf-g[qbf-i] = "".
  ELSE IF qbf-g[qbf-i] = "" THEN qbf-g[qbf-i] = " ".
END.
qbf-n = 0.
DO qbf-i = qbf-l-attr[3] TO 1 BY -1 WHILE qbf-n = 0:
  IF qbf-g[qbf-i] <> " " THEN qbf-n = qbf-i.
  IF qbf-g[qbf-i] =  " " THEN qbf-g[qbf-i] = "".
END.

DO qbf-h = 1 TO qbf-n:
  IF LENGTH(qbf-g[qbf-h]) = 0 THEN NEXT.
  /*IF INDEX(qbf-g[qbf-h],'"') > 0 THEN
    DO qbf-l = LENGTH(qbf-g[qbf-h]) TO 1 BY -1:
      IF SUBSTRING(qbf-g[qbf-h],qbf-l,1) = '"'
        THEN SUBSTRING(qbf-g[qbf-h],qbf-l,1) = '""'.
    END.*/
  ASSIGN
    qbf-g[qbf-h] = '"' + qbf-g[qbf-h] + '"'
    qbf-l        = INDEX(qbf-g[qbf-h],qbf-left)
    qbf-r        = INDEX(qbf-g[qbf-h],qbf-right).
  DO WHILE qbf-l > 0 AND qbf-r > qbf-l:
    qbf-c = SUBSTRING(qbf-g[qbf-h],qbf-l + 1,qbf-r - qbf-l - 1).
    IF qbf-c = "TODAY" THEN
      qbf-c = 'STRING(TODAY,"99/99/99")'.
    ELSE DO:
      ASSIGN
        qbf-i = INDEX(qbf-c,".")
        qbf-j = R-INDEX(qbf-c,".").
      IF qbf-i = 0 THEN /* no file or db qualifier */
        DO qbf-i = 1 TO 5 WHILE qbf-file[qbf-i] <> "":
          RUN prores/s-lookup.p 
            (qbf-db[qbf-i],qbf-file[qbf-i],qbf-c,"FIELD:RECID",OUTPUT qbf-s).
          IF qbf-s = ? THEN NEXT.
          qbf-c = qbf-db[qbf-i] + "." + qbf-file[qbf-i] + "." + qbf-c.
          LEAVE.
        END.
      ELSE
      IF qbf-i = qbf-j THEN /* no db qualifier */
        DO qbf-i = 1 TO 5 WHILE qbf-file[qbf-i] <> "":
          IF qbf-file[qbf-i] <> SUBSTRING(qbf-c,1,qbf-j - 1) THEN NEXT.
          qbf-c = qbf-db[qbf-i] + "." + qbf-c.
        END.
      RUN prores/s-lookup.p (qbf-c,"","","FIELD:TYP&FMT",OUTPUT qbf-s).
      qbf-a = ENTRY(1,qbf-s) <> "1". /* character */
      IF NOT qbf-a THEN DO: /* character */
        ASSIGN
          qbf-s = SUBSTRING(qbf-s,INDEX(qbf-s,",") + 1)
          qbf-j = LENGTH(STRING("",qbf-s))
          qbf-a = TRUE.
        IF qbf-s = FILL(SUBSTRING(qbf-s,1,1),LENGTH(qbf-s)) THEN qbf-a = FALSE.
        IF INDEX("XNA!9",SUBSTRING(qbf-s,1,1)) > 0
          AND (SUBSTRING(qbf-s,2) = "("   + STRING(qbf-j) + ")"
            OR SUBSTRING(qbf-s,2) = "(0"  + STRING(qbf-j) + ")"
            OR SUBSTRING(qbf-s,2) = "(00" + STRING(qbf-j) + ")")
          THEN qbf-a = FALSE.
      END.

      /* double-up embedded escape characters */
      IF INDEX(qbf-s,"~~") > 0 THEN
        DO qbf-j = LENGTH(qbf-s) TO 1 BY -1:
          IF SUBSTRING(qbf-s,qbf-j,1) = "~~" THEN
            SUBSTRING(qbf-s,qbf-j,1) = "~~~~".
        END.

      /* change unknown value into "" */
      RUN prores/s-lookup.p (qbf-c,"","","FIELD:MAND",OUTPUT qbf-m).
      IF qbf-a THEN
        IF qbf-m BEGINS "n" THEN
          qbf-c = 'TRIM(IF ' + qbf-c + ' = ? THEN "" ELSE STRING(' + qbf-c
                + ',"' + SUBSTRING(qbf-s,INDEX(qbf-s,",") + 1) + '"))'.
        ELSE
          qbf-c = 'TRIM(STRING(' + qbf-c
                + ',"' + SUBSTRING(qbf-s,INDEX(qbf-s,",") + 1) + '"))'.
      ELSE
        IF qbf-m BEGINS "n" THEN
          qbf-c = '(IF ' + qbf-c + ' = ? THEN "" ELSE ' + qbf-c + ')'.
    END.
    ASSIGN
      SUBSTRING(qbf-g[qbf-h],qbf-l,qbf-r - qbf-l + 1) = '" + ' + qbf-c + ' + "'
      qbf-l = INDEX(qbf-g[qbf-h],qbf-left)
      qbf-r = INDEX(qbf-g[qbf-h],qbf-right).
  END.
  IF qbf-g[qbf-h] BEGINS '"" + ' THEN qbf-g[qbf-h] = SUBSTRING(qbf-g[qbf-h],6).
  IF qbf-g[qbf-h] MATCHES '* + ""' THEN
    qbf-g[qbf-h] = SUBSTRING(qbf-g[qbf-h],1,LENGTH(qbf-g[qbf-h]) - 5).
END.

PUT STREAM qbf-io UNFORMATTED
  'DEFINE VARIABLE qbf-b AS CHARACTER EXTENT ' STRING(qbf-n,"Z9")
     ' NO-UNDO.' SKIP
  'DEFINE VARIABLE qbf-c AS INTEGER             NO-UNDO.' SKIP
  'DEFINE VARIABLE qbf-i AS INTEGER             NO-UNDO.' SKIP
  'DEFINE VARIABLE qbf-l AS CHARACTER           NO-UNDO.' SKIP
  'DEFINE VARIABLE qbf-n AS INTEGER   INITIAL 0 NO-UNDO.' SKIP
  'DEFINE VARIABLE qbf-t AS INTEGER             NO-UNDO.' SKIP(1).

/* write out initialization stuff for calc fields */
{ prores/s-gen1.i }
PUT STREAM qbf-io UNFORMATTED 'qbf-total = 0.' SKIP.

/* write out prepass code */
{ prores/s-gen3.i &count=FALSE }

{ prores/s-gen2.i
  &by=TRUE
  &on="' ON ERROR UNDO,RETURN ON ENDKEY UNDO,RETURN'"
}

/* calc field code for main loop */
{ prores/s-gen4.i }

qbf-p = (IF qbf-l-attr[7] = 1 THEN '' ELSE '  ').
IF qbf-l-attr[7] > 1 THEN PUT STREAM qbf-io UNFORMATTED
  '  DO qbf-c = 1 TO ' qbf-l-attr[7] ':' SKIP.
PUT STREAM qbf-io UNFORMATTED
  qbf-p '  ASSIGN' SKIP
  qbf-p '    qbf-total = qbf-total - 1' SKIP
  qbf-p '    qbf-i = 1' SKIP.

DO qbf-i = 1 TO qbf-n:
  qbf-c = (IF qbf-l-attr[2] = 0 OR qbf-l-attr[5] = 1 THEN
            'qbf-b[qbf-i] = '
            + (IF qbf-l-attr[1] = 0
              THEN ''
              ELSE '"' + FILL(' ',qbf-l-attr[1]) + '" + '
            )
          ELSE
            'OVERLAY(qbf-b[qbf-i],'
            + STRING(qbf-l-attr[1] + 1)
            + ' + qbf-n * ' + STRING(qbf-l-attr[2]) + ',LENGTH(qbf-l)) = '
          ).
  PUT STREAM qbf-io UNFORMATTED
    qbf-p '    qbf-l = ' qbf-g[qbf-i] SKIP
  /*qbf-p '    qbf-l = (IF qbf-l = ? THEN "" ELSE qbf-l)' SKIP*/
    qbf-p '    ' qbf-c 'qbf-l' SKIP.

  IF qbf-i < qbf-n THEN PUT STREAM qbf-io UNFORMATTED
    qbf-p '    qbf-i = '
    (IF qbf-l-attr[6] = 0 THEN 'qbf-i + 1'
      ELSE '(IF LENGTH(qbf-l) > 0 THEN qbf-i + 1 ELSE qbf-i)') SKIP.
END.

PUT STREAM qbf-io UNFORMATTED
  qbf-p '    qbf-n = qbf-n + 1.' SKIP
  qbf-p '  IF qbf-n = ' qbf-l-attr[5] ' THEN DO:' SKIP
  qbf-p '    PUT UNFORMATTED SKIP(' qbf-l-attr[4] ')'.
DO qbf-i = 1 TO qbf-n:
  PUT STREAM qbf-io UNFORMATTED SKIP qbf-p '      qbf-b[' qbf-i '] " " SKIP'.
END.
PUT STREAM qbf-io UNFORMATTED
  '(' qbf-l-attr[3] - qbf-l-attr[4] - qbf-n ').' SKIP
  qbf-p '    ASSIGN' SKIP
  qbf-p '      qbf-b = ""' SKIP
  qbf-p '      qbf-n = 0.' SKIP
  qbf-p '  END.' SKIP.
IF qbf-l-attr[7] > 1 THEN PUT STREAM qbf-io UNFORMATTED '  END.' SKIP.
PUT STREAM qbf-io UNFORMATTED
  'END.' SKIP(1)
  'IF qbf-n > 0 THEN' SKIP
  '  PUT UNFORMATTED SKIP(' qbf-l-attr[4] ')'.
DO qbf-i = 1 TO qbf-n:
  PUT STREAM qbf-io UNFORMATTED SKIP '    qbf-b[' qbf-i '] " " SKIP'.
END.
PUT STREAM qbf-io UNFORMATTED
  '(' qbf-l-attr[3] - qbf-l-attr[4] - qbf-n ').' SKIP
  'qbf-total = - qbf-total.' SKIP
  'RETURN.' SKIP.
/*--------------------------------------------------------------------------*/
OUTPUT STREAM qbf-io CLOSE.

RETURN.
