/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* d-write.p - generate data export program */

{ prores/s-system.i }
{ prores/s-define.i }

DEFINE INPUT PARAMETER qbf-f AS CHARACTER NO-UNDO.

DEFINE VARIABLE qbf-c AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO.
DEFINE NEW SHARED STREAM qbf-io.

RUN prores/s-prefix.p (qbf-dir-nam,OUTPUT qbf-c).
IF qbf-f BEGINS "_" THEN 
  qbf-c = "".

OUTPUT STREAM qbf-io TO VALUE(qbf-c + qbf-f + ".p") NO-ECHO NO-MAP.
/*--------------------------------------------------------------------------*/
IF true or NOT qbf-f BEGINS "_" THEN DO:
  PUT STREAM qbf-io UNFORMATTED
    '/*' SKIP
    'version= ' qbf-vers SKIP
    'config= export' SKIP.
  PUT STREAM qbf-io CONTROL 'name= '. EXPORT STREAM qbf-io qbf-name.
  PUT STREAM qbf-io CONTROL 'type= '. EXPORT STREAM qbf-io qbf-d-attr[1].
  PUT STREAM qbf-io CONTROL 'use-headings= '.
  EXPORT STREAM qbf-io qbf-d-attr[2].

  DO qbf-i = 3 TO 6:
    qbf-c = qbf-d-attr[qbf-i].
    DO WHILE qbf-c <> "" AND SUBSTRING(qbf-c,LENGTH(qbf-c),1) = ",":
      qbf-c = SUBSTRING(qbf-c,1,LENGTH(qbf-c) - 1).
    END.
    IF qbf-c = "" THEN NEXT.
    PUT STREAM qbf-io CONTROL
      (IF qbf-i = 3 OR qbf-i = 4 THEN 'record'    ELSE 'field'    ) '-'
      (IF qbf-i = 3 OR qbf-i = 5 THEN 'delimiter' ELSE 'separator') '= '.
    EXPORT STREAM qbf-io qbf-c.
  END.

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
  DO qbf-i = 1 TO qbf-rc#:
    PUT STREAM qbf-io CONTROL 'field' STRING(qbf-i) '= '.
    EXPORT STREAM qbf-io
      qbf-rcn[qbf-i] qbf-rcl[qbf-i] qbf-rcf[qbf-i] qbf-rca[qbf-i]
      ENTRY(qbf-rct[qbf-i],qbf-dtype) qbf-rcc[qbf-i].
  END.
  PUT STREAM qbf-io UNFORMATTED '*/' SKIP(1).
END.
/*--------------------------------------------------------------------------*/

/*--------------------------------------------------------------------------*/
IF      qbf-d-attr[1] = "PROGRESS" THEN RUN prores/d-pro.p.
ELSE IF qbf-d-attr[1] = "DIF"      THEN RUN prores/d-dif.p.
ELSE IF qbf-d-attr[1] = "SYLK"     THEN RUN prores/d-sylk.p.
ELSE IF qbf-d-attr[1] = "USER"     THEN RUN VALUE(qbf-u-expo).
ELSE                                    RUN prores/d-ascii.p.
/*--------------------------------------------------------------------------*/

OUTPUT STREAM qbf-io CLOSE.
RETURN.
