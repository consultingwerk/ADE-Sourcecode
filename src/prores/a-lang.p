/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* a-lang.p - set current language */

{ prores/s-system.i }
{ prores/t-define.i }
{ prores/s-menu.i }
{ prores/t-set.i &mod=a &set=3 } /* needed to establish context for later */

DEFINE VARIABLE qbf-c AS CHARACTER             NO-UNDO.
DEFINE VARIABLE qbf-d AS CHARACTER             NO-UNDO.
DEFINE VARIABLE qbf-e AS CHARACTER INITIAL "r" NO-UNDO. /* extension */
DEFINE VARIABLE qbf-i AS INTEGER               NO-UNDO.
DEFINE VARIABLE qbf-l AS CHARACTER INITIAL ""  NO-UNDO.
DEFINE VARIABLE qbf-t AS CHARACTER INITIAL ""  NO-UNDO.

qbf-m-now = "".

qbf-d = SEARCH("prores/reslang/t-a-" + qbf-langset + ".p").
IF qbf-d = ? THEN qbf-d = SEARCH("prores/reslang/t-a-" + qbf-langset + ".r").
IF qbf-d = ? THEN qbf-d = SEARCH("prores/reslang/t-a-eng.p").
IF qbf-d = ? THEN qbf-d = SEARCH("prores/reslang/t-a-eng.r").
RUN prores/s-prefix.p (qbf-d,OUTPUT qbf-d).

/*--------------------------------------------------------------------------*/
/* allow .p's to be found when .r's missing (for development work only) */
IF SEARCH(qbf-d + "t-a-" + qbf-langset + ".p") <> ? THEN qbf-e = "p".

IF OPSYS = "OS2" THEN
  INPUT THROUGH
    VALUE("dir " + qbf-d + "t-a-???." + qbf-e + "|quoter") NO-ECHO NO-MAP.
ELSE
IF OPSYS = "UNIX" THEN
  INPUT THROUGH
    VALUE("ls " + qbf-d + "t-a-???." + qbf-e) NO-ECHO NO-MAP.
ELSE
IF OPSYS = "MSDOS" THEN
  DOS SILENT VALUE("dir " + qbf-d + "t-a-???." + qbf-e + "|quoter>"
    + qbf-tempdir + ".d").
ELSE
IF OPSYS = "VMS" THEN DO:
  qbf-c = qbf-d + "t-a-%%%." + qbf-e.
  IF INDEX(qbf-c,"/") > 0 THEN
    RUN prores/s-extra.p (INPUT-OUTPUT qbf-c).
  VMS SILENT VALUE(
    'dir/brief/notr/nosize/nodate/nohead/out=' + qbf-tempdir + '.d ' + qbf-c).
END.
ELSE
IF OPSYS = "BTOS" THEN
  BTOS SILENT "[Sys]<Sys>Files.run" Files
    VALUE(qbf-d + "t-a-???." + qbf-e)
    "No" VALUE(qbf-tempdir + ".d") "No" 1.

IF CAN-DO("BTOS,VMS,MSDOS",OPSYS) THEN
  INPUT FROM VALUE(qbf-tempdir + ".d") NO-ECHO NO-MAP.

REPEAT:
  qbf-c = "".
  IMPORT qbf-c.
  IF OPSYS = "OS2" AND LENGTH(qbf-c) > 40 THEN
    qbf-c = SUBSTRING(qbf-c,41).
  ELSE
  IF CAN-DO("MSDOS,OS2",OPSYS) THEN
    qbf-c = TRIM(SUBSTRING(qbf-c,1,8))
          + (IF SUBSTRING(qbf-c,10,3) = "" THEN ""
            ELSE "." + TRIM(SUBSTRING(qbf-c,10,3))).
  IF qbf-c BEGINS qbf-d THEN
    qbf-c = SUBSTRING(qbf-c,LENGTH(qbf-d) + 1).
  IF OPSYS = "VMS" AND INDEX(qbf-c,"]") > 0 THEN
    qbf-c = SUBSTRING(qbf-c,R-INDEX(qbf-c,"]") + 1).
  IF OPSYS = "VMS" AND INDEX(qbf-c,">") > 0 THEN
    qbf-c = SUBSTRING(qbf-c,R-INDEX(qbf-c,">") + 1).

  IF NOT qbf-c BEGINS "t-a-" THEN NEXT.

  qbf-l = qbf-l + (IF qbf-l = "" THEN "" ELSE ",") + SUBSTRING(qbf-c,5,3).
END.

INPUT CLOSE.
/*--------------------------------------------------------------------------*/

RUN prores/s-vector.p (TRUE,INPUT-OUTPUT qbf-l).

qbf-c = qbf-langset.
DO qbf-i = 1 TO NUM-ENTRIES(qbf-l):
  ASSIGN
    qbf-langnow = ""
    qbf-langset = ENTRY(qbf-i,qbf-l).
  { prores/t-set.i &mod=a &set=3 }
  qbf-t = qbf-t + (IF qbf-t = "" THEN "" ELSE ",")
        + ENTRY(qbf-i,qbf-l) + " - " + qbf-lang[19].
END.
ASSIGN
  qbf-langnow = ""
  qbf-langset = qbf-c.
/* now get back correct language set */
{ prores/t-set.i &mod=a &set=3 }

RUN prores/c-entry.p (qbf-t,"r004c020",OUTPUT qbf-i).

IF qbf-i = 0 OR qbf-langset = ENTRY(qbf-i,qbf-l) THEN RETURN.

qbf-langset = ENTRY(qbf-i,qbf-l).
{ prores/t-set.i &mod=a &set=3 }
{ prores/t-init.i }
{ prores/t-reset.i }

RETURN.
