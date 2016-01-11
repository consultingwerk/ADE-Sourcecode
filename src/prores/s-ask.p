/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* s-ask.p - handle run-time where-clause questions */

{ prores/s-system.i }
{ prores/s-define.i }
{ prores/t-define.i }

DEFINE INPUT-OUTPUT PARAMETER qbf-a AS LOGICAL NO-UNDO.
/*
input value:  TRUE  = do asking
              FALSE = load up qbf-asked "pretty" qbf-where for x(70) format
              ?     = same as false, but no format
return value: TRUE  = all okay
              FALSE = end-error pressed
*/

DEFINE VARIABLE qbf-c AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-d AS CHARACTER NO-UNDO. /* datatype */
DEFINE VARIABLE qbf-j AS INTEGER   NO-UNDO. /* outer loop */
DEFINE VARIABLE qbf-l AS INTEGER   NO-UNDO. /* position of {{ */
DEFINE VARIABLE qbf-n AS CHARACTER NO-UNDO. /* field-name */
DEFINE VARIABLE qbf-p AS CHARACTER NO-UNDO. /* comparison */
DEFINE VARIABLE qbf-q AS CHARACTER NO-UNDO. /* user's question */
DEFINE VARIABLE qbf-r AS INTEGER   NO-UNDO. /* position of }} */
DEFINE VARIABLE qbf-t AS CHARACTER NO-UNDO. /* format */
DEFINE VARIABLE qbf-v AS CHARACTER NO-UNDO. /* value holder */
DEFINE VARIABLE qbf-x AS CHARACTER NO-UNDO. /* context */

IF qbf-a <> TRUE THEN DO: /* false or ? */
  DO qbf-j = 1 TO 5:
    ASSIGN
      qbf-asked[qbf-j] = ""
      qbf-c            = qbf-where[qbf-j]
      qbf-l            = INDEX(qbf-c,"~{~{") + 2
      qbf-r            = INDEX(qbf-c,"~}~}") - qbf-l.
    IF qbf-c = "" THEN NEXT.
    DO WHILE qbf-l > 1 AND qbf-r > 0:
      ASSIGN
        SUBSTRING(qbf-c,qbf-l - 2,qbf-r + 4)
              = "[" + ENTRY(1,SUBSTRING(qbf-c,qbf-l,qbf-r)) + "]"
        qbf-l = INDEX(qbf-c,"~{~{") + 2
        qbf-r = INDEX(qbf-c,"~}~}") - qbf-l.
    END.
    ASSIGN
      qbf-asked[qbf-j] = (IF qbf-a = ? THEN "" ELSE " WHERE ") + qbf-c
      qbf-l            = LENGTH(qbf-db[qbf-j]) + LENGTH(qbf-file[qbf-j]) + 1.
    IF NOT qbf-a AND qbf-l + LENGTH(qbf-asked[qbf-j]) > 70 THEN
      qbf-asked[qbf-j] = SUBSTRING(qbf-asked[qbf-j],1,67 - qbf-l) + "...".
  END.
  qbf-a = TRUE.
  RETURN.
END.

qbf-a = TRUE.

{ prores/t-set.i &mod=s &set=2 }

qbf-outer:
DO qbf-j = 1 TO 5:
  ASSIGN
    qbf-asked[qbf-j] = qbf-where[qbf-j]
    qbf-l            = INDEX(qbf-asked[qbf-j],"~{~{")
    qbf-r            = INDEX(qbf-asked[qbf-j],"~}~}").
  /*    v-- qbf-l                               qbf-r --v     */
  /* ...{{data-type,db.file.field,comparison:explanation}}... */
  /*      |.qbf-d.| |...qbf-n...| |.qbf-p..| |..qbf-q..|      */
  DO WHILE qbf-l > 0 AND qbf-r > qbf-l:
    ASSIGN
      qbf-q = SUBSTRING(qbf-asked[qbf-j],qbf-l + 2,qbf-r - qbf-l - 2)
      qbf-d = ENTRY(1,qbf-q)
      qbf-n = ENTRY(2,qbf-q)
      qbf-n = SUBSTRING(qbf-n,R-INDEX(qbf-n,".") + 1) /* strip [[db.]file.] */
      qbf-p = ENTRY(3,SUBSTRING(qbf-q,1,INDEX(qbf-q,":") - 1))
      qbf-q = SUBSTRING(qbf-q,INDEX(qbf-q,":") + 1)

      /*'Please enter the {1} value to compare with "{2}".'*/
      qbf-c = qbf-lang[22]
      SUBSTRING(qbf-c,INDEX(qbf-c,"~{1~}"),3) = qbf-d
      SUBSTRING(qbf-c,INDEX(qbf-c,"~{2~}"),3) = qbf-n.
    STATUS INPUT qbf-c.

    RUN prores/s-quote.p (qbf-q,?,OUTPUT qbf-q).

    RUN prores/s-lookup.p
      (qbf-db[qbf-j],qbf-file[qbf-j],qbf-n,"FIELD:TYP&FMT",OUTPUT qbf-t).
    qbf-t = SUBSTRING(qbf-t,INDEX(qbf-t,",") + 1).
    IF { prores/s-size.i &type=LOOKUP(qbf-d,qbf-dtype) &format=qbf-t } > 72 THEN
      qbf-t = (IF qbf-d = "character" THEN "x(72)"
          ELSE IF qbf-d = "logical"   THEN
            LC(TRIM(ENTRY(1,qbf-boolean)) + "/" + TRIM(ENTRY(2,qbf-boolean)))
          ELSE IF qbf-d = "date"      THEN "99/99/99"
          ELSE                             "->>>,>>>,>>9.<<<<<<<<<<").
    RUN prores/s-quote.p (qbf-t,?,OUTPUT qbf-t).

    ASSIGN
      /*'Context: {1} is {2} some {3} value.'*/
      qbf-x = qbf-lang[25]
      SUBSTRING(qbf-x,INDEX(qbf-x,"~{1~}"),3) = qbf-n
      SUBSTRING(qbf-x,INDEX(qbf-x,"~{2~}"),3) = qbf-p
      SUBSTRING(qbf-x,INDEX(qbf-x,"~{3~}"),3) = qbf-d.
    RUN prores/s-quote.p (qbf-x,'"',OUTPUT qbf-x).

    OUTPUT TO VALUE(qbf-tempdir + ".p") NO-ECHO NO-MAP.
    PUT UNFORMATTED
      'DEFINE OUTPUT PARAMETER qbf-v AS CHARACTER NO-UNDO.' SKIP.
    IF qbf-d <> "character" THEN
      PUT UNFORMATTED
        'DEFINE VARIABLE qbf-v2 AS ' CAPS(qbf-d)
          (IF qbf-d = "date" THEN ' INITIAL TODAY' ELSE '')
          ' NO-UNDO.' SKIP.
    PUT UNFORMATTED
      'DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:' SKIP
      '  FORM SKIP(1)' SKIP
      '    "' qbf-q '" SKIP(1)' SKIP /* user's question goes here */
        '    qbf-v' (IF qbf-d = "character" THEN '' ELSE '2')
        ' FORMAT "' qbf-t '" SKIP(1)' SKIP
      '    HEADER SKIP(1)' SKIP
      '    ' qbf-x ' SKIP' SKIP /*"Context"*/
      '    WITH FRAME qbf-ask OVERLAY ATTR-SPACE NO-LABELS ROW 5 CENTERED' SKIP
      '    TITLE COLOR NORMAL " ' qbf-lang[12] ' ".' SKIP /*"Enter a Value"*/
      '  UPDATE qbf-v' (IF qbf-d = "character" THEN '' ELSE '2')
        ' WITH FRAME qbf-ask.' SKIP
      'END.' SKIP.
    IF qbf-d = "decimal" THEN
      PUT UNFORMATTED
        'qbf-v = (IF qbf-v2 > -1 AND qbf-v2 < 0 THEN "-" ELSE "") + '
        'STRING(TRUNCATE(qbf-v2,0)) + '
        '(IF qbf-v2 = TRUNCATE(qbf-v2,0) THEN "" ELSE ".") + '
        'SUBSTRING(STRING(qbf-v2 - TRUNCATE(qbf-v2,0)),'
        'IF qbf-v2 < 0 THEN 3 ELSE 2).' SKIP.
    ELSE
    IF qbf-d = "date" THEN
      PUT UNFORMATTED 'qbf-v = STRING(MONTH(qbf-v2)) + "/" + '
        'STRING(DAY(qbf-v2)) + "/" + STRING(YEAR(qbf-v2)).' SKIP.
    ELSE
    IF qbf-d <> "character" THEN
      PUT UNFORMATTED 'qbf-v = STRING(qbf-v2).' SKIP.
    PUT UNFORMATTED
      'HIDE FRAME qbf-ask NO-PAUSE.' SKIP
      'RETURN.' SKIP.
    OUTPUT CLOSE.
    COMPILE VALUE(qbf-tempdir + ".p") ATTR-SPACE.

    ASSIGN
      qbf-c      = qbf-module
      qbf-module = "ask," + qbf-db[qbf-j] + "." + qbf-file[qbf-j] + "." + qbf-n
      qbf-v      = "".
    RUN VALUE(qbf-tempdir + ".p") (OUTPUT qbf-v).
    qbf-module = qbf-c.

    /*----------------------------------------------------------------------*/
    IF KEYFUNCTION(LASTKEY) = "END-ERROR" THEN LEAVE qbf-outer.
    STATUS INPUT.
    /* add quotes/stars, etc. on the value */
    IF qbf-d = "character" AND qbf-v MATCHES '"*"' THEN
      qbf-v = SUBSTRING(qbf-v,2,LENGTH(qbf-v) - 2).
    IF qbf-p = qbf-lang[8] /*"Contains"*/ THEN qbf-v = "*" + qbf-v + "*".
    IF qbf-d = "character" THEN
      RUN prores/s-quote.p (qbf-v,'"',OUTPUT qbf-v).
    ELSE IF qbf-v = ? THEN qbf-v = "?".

    ASSIGN
      SUBSTRING(qbf-asked[qbf-j],qbf-l,qbf-r - qbf-l + 2) = qbf-v
      qbf-l = INDEX(qbf-asked[qbf-j],"~{~{")
      qbf-r = INDEX(qbf-asked[qbf-j],"~}~}").
  END.
END.

qbf-a = KEYFUNCTION(LASTKEY) <> "END-ERROR".

{ prores/t-reset.i }
RETURN.
