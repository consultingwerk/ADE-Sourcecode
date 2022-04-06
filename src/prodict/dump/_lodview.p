/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* _lodview.p - load _View, _View-ref and _View-col records */
/*
Views will now be dumped into one file, _View.d.  Previously, we dumped
views into three files (_View.d, _View-ref.d and _View-col.d), one for
each schema file that they occupied.  They are all stored in one physical
file now when dumped, and each section is delimited by a period "." alone
on the line, which PROGRESS interprets as the ENDKEY (end of file).

The View Load procedure bends over backwards, though, to maintain version 5
compatibility.  It first looks for _View-ref.d and _View-col.d in the same
directory as _View.d, and if it finds them it uses the old 3-file reload
format.  Otherwise, it uses the new 1-file format.

To avoid finding the _View.d file in one directory and the _View-ref.d and
_View-col.d files in another directory further up the search path, we do
special file-prefix checking to enforce the SEARCH function so that it only
looks in the same place that the _View.d file was found.
*/
/*
Only the new one-file - all-information _View.d contains a trailer with
the codepage-parameter. So we check for a trailer only with _View.d; also 
we differ between input "no-convert" and "input convert" only with
_View.d   <hutegger> 03/03
*/
/*h-*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

DEFINE VARIABLE cerror    AS CHARACTER            NO-UNDO.
DEFINE VARIABLE codepage  AS CHARACTER            NO-UNDO init "UNDEFINED".
DEFINE VARIABLE errbyte   AS INTEGER              NO-UNDO.
DEFINE VARIABLE errline   AS INTEGER              NO-UNDO.
DEFINE VARIABLE errs      AS INTEGER              NO-UNDO.
DEFINE VARIABLE i         AS INTEGER              NO-UNDO.
DEFINE VARIABLE lvar      AS CHARACTER EXTENT 10  NO-UNDO.
DEFINE VARIABLE lvar#     AS INTEGER              NO-UNDO.
DEFINE VARIABLE fil-e     AS CHARACTER            NO-UNDO.
DEFINE VARIABLE recs      AS INTEGER.              /*UNDO*/
DEFINE VARIABLE recs2     AS INTEGER              NO-UNDO.
DEFINE VARIABLE terrors   AS INTEGER              NO-UNDO.
DEFINE VARIABLE vcol      AS CHARACTER INITIAL "" NO-UNDO.
DEFINE VARIABLE vmsg      AS CHARACTER            NO-UNDO.
DEFINE VARIABLE vorg      AS CHARACTER            NO-UNDO.
DEFINE VARIABLE vpath     AS CHARACTER            NO-UNDO.
DEFINE VARIABLE vrecs     AS INTEGER              NO-UNDO.
DEFINE VARIABLE vref      AS CHARACTER INITIAL "" NO-UNDO.



ASSIGN
  vorg  = SEARCH(user_env[2])
  vpath = SUBSTRING(vorg,1,LENGTH(vorg) - LENGTH(user_env[2])).

IF NOT user_env[2] MATCHES "*~.d" THEN DO:
  MESSAGE "File name containing View information must end in ~".d~"."
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  user_path = "".
  RETURN.
END.
fil-e = SUBSTRING(user_env[2],1,LENGTH(user_env[2]) - 1) + "e".

run adecomm/_setcurs.p ("WAIT").


IF user_env[2] MATCHES "*_View~.d" THEN DO:
  ASSIGN
    vcol = SUBSTRING(user_env[2],1,LENGTH(user_env[2]) - 2) + "-col.d"
    vref = SUBSTRING(user_env[2],1,LENGTH(user_env[2]) - 2) + "-ref.d".
  IF SEARCH(vcol) <> vpath + vcol OR SEARCH(vref) <> vpath + vref THEN ASSIGN
    vcol = ""
    vref = "".
END.
/*** Don't need this right now 
{prodict/dump/lodtrail.i
  &file    = "user_env[2]"
  &entries = " " 
  }  /* read trailer, sets variables: codepage and cerror */
*/
/* gfs: The codepage is now set by _usrload.p */
ASSIGN codepage = user_env[10].

IF   codepage        <> "UNDEFINED" 
 AND SESSION:CHARSET <> ?
 then assign cerror = CODEPAGE-CONVERT("a",SESSION:CHARSET,codepage).
 else assign cerror = "no-convert".
 
IF cerror = ?
 THEN DO:  /* conversion needed but NOT possible */

  run adecomm/_setcurs.p ("").
  MESSAGE "View information NOT loaded." 
       	  VIEW-AS ALERT-BOX INFORMATION BUTTONS OK. 

  END.     /* conversion needed but NOT possible */

 ELSE DO:  /* conversion not needed OR needed and possible */
 
  OUTPUT TO VALUE(fil-e) NO-ECHO.
  if cerror = "undefined"
   then INPUT FROM VALUE(SEARCH(user_env[2])) NO-ECHO NO-MAP NO-CONVERT.
   else INPUT FROM VALUE(SEARCH(user_env[2])) NO-ECHO NO-MAP
                   CONVERT SOURCE codepage TARGET SESSION:CHARSET.

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
  REPEAT FOR DICTDB._View ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
    IF RETRY
     THEN DO:
      errs = errs + 1.
      PUT UNFORMATTED
        ">> ERROR READING LINE #" errline " (OFFSET=" errbyte ")" SKIP
        "** Tolerable load error rate is: 0%." SKIP
        "** Loading table _View is aborted." SKIP.
      LEAVE.
      END.
    CREATE _View.
    ASSIGN
      errbyte = SEEK(INPUT)
      errline = errline + 1
      recs    = recs + 1.
    IMPORT _View.
    END. /* end repeat */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
  ASSIGN
    vrecs   = recs
    terrors = errs.

  IF errs > 0 THEN PUT UNFORMATTED FILL("-",78) SKIP.

  IF vcol <> ""
   THEN DO:
    INPUT CLOSE.
    INPUT FROM VALUE(vcol) NO-ECHO NO-MAP.
    END.
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
  REPEAT FOR DICTDB._View-col ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
    IF RETRY
     THEN DO:
      errs = errs + 1.
      PUT UNFORMATTED
        ">> ERROR READING LINE #" errline " (OFFSET=" errbyte ")" SKIP
        "** Tolerable load error rate is: 0%." SKIP
        "** Loading table _View-col is aborted." SKIP.
      LEAVE.
      END.
    CREATE _View-col.
    ASSIGN
      errbyte = SEEK(INPUT)
      errline = errline + 1
      recs    = recs + 1.
    IMPORT _View-col.
    END. /* end repeat */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
  IF recs = 0 AND vrecs > 0
   THEN DO:
    PUT UNFORMATTED
      "Warning!  Inconsistent load counts between _View and _View-ref" SKIP
      "Not enough _View-ref records read to satisfy _View records"     SKIP.
    errs = errs + 1.
    END.
  ASSIGN
    terrors = terrors + errs
    recs2   = recs.

  IF errs > 0 THEN PUT UNFORMATTED FILL("-",78) SKIP.

  IF vref <> ""
   THEN DO:
    INPUT CLOSE.
    INPUT FROM VALUE(vref) NO-ECHO NO-MAP.
    END.
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
  REPEAT FOR DICTDB._View-ref ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
    IF RETRY 
     THEN DO:
      errs = errs + 1.
      PUT UNFORMATTED
        ">> ERROR READING LINE #" errline " (OFFSET=" errbyte ")" SKIP
        "** Tolerable load error rate is: 0%." SKIP
        "** Loading table _View-ref is aborted." SKIP.
      LEAVE.
      END.
    CREATE _View-ref.
    ASSIGN
      errbyte = SEEK(INPUT)
      errline = errline + 1
      recs    = recs + 1.
    IMPORT _View-ref.
    END. /* end repeat */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
  IF recs = 0 AND vrecs > 0 
   THEN DO:
    PUT UNFORMATTED
      "Warning!  Inconsistent load counts between _View and _View-col" SKIP
      "Not enough _View-col records read to satisfy _View records"     SKIP.
    errs = errs + 1.
    END.
  ASSIGN
    terrors = terrors + errs
    vmsg    = STRING(vrecs + recs2 + recs).

  INPUT CLOSE.
  OUTPUT CLOSE.

/* in case views loaded from V5 dumps, fix up Auth-id */
  DO TRANSACTION:
    FOR EACH DICTDB._View WHERE DICTDB._View._Auth-id = ?:
      DICTDB._View._Auth-id = ENTRY(1,DICTDB._View._Can-read).
      FOR EACH DICTDB._View-col OF DICTDB._View:
        DICTDB._View-col._Auth-id = DICTDB._View._Auth-id.
        END.
      FOR EACH DICTDB._View-ref OF DICTDB._View:
        DICTDB._View-ref._Auth-id = DICTDB._View._Auth-id.
        END.
      END.
    END.

  run adecomm/_setcurs.p ("").

  IF terrors = 0 
   THEN DO:
    OS-DELETE VALUE(fil-e).
    MESSAGE "View information loaded successfully." SKIP
        	  vmsg "records read."
        	  VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    END.
   ELSE DO:
    MESSAGE terrors "error(s) in loading View definitions." SKIP
        	  "Error listing contained in file" fil-e SKIP
        	  vmsg "records read." 
        	  VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    END.

  END.     /* conversion not needed OR needed and possible */


RETURN.
