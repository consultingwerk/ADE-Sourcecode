/*********************************************************************
* Copyright (C) 2006,2014 by Progress Software Corporation. All      *
* rights reserved.  Prior versions of this work may contain portions *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* _lodseqs.p - load _Sequence file from _Seqvals.d and set w/ CURRENT-VALUE 

  History:  D. McMann 08/08/02  Eliminated any sequences whose name begins "$" - Peer Direct
            fernando  05/25/06  Added support for large sequences
*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

DEFINE VARIABLE cerror    AS CHARACTER           NO-UNDO.
DEFINE VARIABLE codepage  AS CHARACTER           NO-UNDO init "UNDEFINED".
DEFINE VARIABLE i         AS INTEGER             NO-UNDO.
DEFINE VARIABLE lvar      AS CHARACTER EXTENT 10 NO-UNDO.
DEFINE VARIABLE lvar#     AS INTEGER             NO-UNDO.
DEFINE VARIABLE tmpfile   AS CHARACTER           NO-UNDO.
DEFINE VARIABLE newAppCtx AS LOGICAL   INIT NO   NO-UNDO.

/* check if LDBNAME(dbname) is a keyword; if yes, throw error and return */
IF  KEYWORD(LDBNAME(user_dbname)) <> ? THEN DO:
    message QUOTER(LDBNAME(user_dbname)) " used as logical database name is a reserved keyword. Please try again. "
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    RETURN.
END.    

RUN adecomm/_setcurs.p ("WAIT").
RUN "adecomm/_tmpfile.p" (INPUT "", INPUT ".adm", OUTPUT tmpfile).
OUTPUT TO VALUE(tmpfile) NO-MAP NO-ECHO NO-MAP.

/* NOTE: now we have to check for overflow errors. Since we may be loading
   sequence values into 32-bit and 64-bit sequences, the overflow is different
   for each one of them (int X int64). So now we import and call current-value()
   with the NO-ERROR clause and check for errors.
*/
PUT UNFORMATTED
  'DEFINE VARIABLE seqname   AS CHARACTER NO-UNDO.' SKIP
  'DEFINE VARIABLE seqnumber AS CHARACTER NO-UNDO.' SKIP
  'DEFINE VARIABLE seqvalue  AS INT64     NO-UNDO.' SKIP
  'REPEAT:' SKIP
  '  IMPORT seqnumber seqname seqvalue NO-ERROR.' SKIP
  '  IF ERROR-STATUS:ERROR THEN DO:' SKIP
  '     IF SESSION:WINDOW-SYSTEM NE "TTY" THEN' SKIP
  '        MESSAGE "Error loading value for " seqname ": "' SKIP
  '        ERROR-STATUS:GET-MESSAGE(1) VIEW-AS ALERT-BOX ERROR.' 
  '     ELSE ' SKIP
  '         MESSAGE "Error loading value for " seqname ": "' SKIP
  '         ERROR-STATUS:GET-MESSAGE(1).' 
  '  END.' SKIP
  '  IF INDEX(seqname,".") = 0 THEN seqname = "' LDBNAME(user_dbname)
    '." + seqname.' SKIP
  '  CASE seqname:' SKIP.
FOR EACH _Sequence WHERE _Sequence._Db-recid = drec_db
                     AND NOT _Sequence._Seq-name BEGINS "$" NO-LOCK:
  PUT UNFORMATTED 
    '    WHEN "' LDBNAME(user_dbname) '.' _Sequence._Seq-Name '" THEN DO:' SKIP
    '      CURRENT-VALUE(' _Sequence._Seq-Name ',' LDBNAME(user_dbname)
      ') = seqvalue NO-ERROR.' SKIP
      '     IF ERROR-STATUS:ERROR OR ERROR-STATUS:NUM-MESSAGES > 1 THEN DO:' SKIP
      '      IF SESSION:WINDOW-SYSTEM NE "TTY" THEN' SKIP
      '         MESSAGE "Error loading value for ' _Sequence._Seq-Name ': "' SKIP
      '         ERROR-STATUS:GET-MESSAGE(1) VIEW-AS ALERT-BOX ERROR.' 
      '      ELSE ' SKIP
      '         MESSAGE "Error loading value for ' _Sequence._Seq-Name ': "' SKIP
      '         ERROR-STATUS:GET-MESSAGE(1).' 
      '     END.' SKIP
      SKIP
      'END.' SKIP.
END.
PUT UNFORMATTED
  '    OTHERWISE DO:' SKIP
  '      IF SESSION:WINDOW-SYSTEM NE "TTY" THEN' SKIP
  '        MESSAGE "_Seqvals.d had a value of" seqvalue "for" seqname "but no sequence was found with a matching name." VIEW-AS ALERT-BOX ERROR.' SKIP
  '      ELSE DO:' SKIP
  '        MESSAGE "_Seqvals.d had a value of" seqvalue "for" seqname.' SKIP
  '        MESSAGE "but no sequence was found with a matching name.".' SKIP
  '      END.' SKIP
  '    END.' SKIP
  '  END CASE.' SKIP
  'END.' SKIP
  'RETURN.' SKIP.
OUTPUT CLOSE.

/***** Don't need this right now...
{prodict/dump/lodtrail.i
  &file    = "user_env[2]"
  &entries = " " 
  }  /* read trailer, sets variables: codepage and cerror */
*/

/* auditing - start a new application context so that one can report
all the records that are loaded as a group.
*/
IF AUDIT-CONTROL:APPL-CONTEXT-ID = ? THEN DO:
 ASSIGN newAppCtx = YES.
 AUDIT-CONTROL:SET-APPL-CONTEXT("Data Administration", "Load Sequence Current Values", "").
END.

ASSIGN codepage = user_env[10]. /* codepage set in _usrload.p */
IF codepage <> "UNDEFINED" AND SESSION:CHARSET <> ? THEN
   ASSIGN cerror = CODEPAGE-CONVERT("a",SESSION:CHARSET,codepage).
ELSE ASSIGN cerror = "no-convert".

IF cerror = ?
 THEN DO:  /* conversion needed but NOT possible */

  OS-DELETE VALUE(tmpfile).
  run adecomm/_setcurs.p ("").
  MESSAGE "Sequence values NOT loaded." 
       	  VIEW-AS ALERT-BOX INFORMATION BUTTONS OK. 

  END.     /* conversion needed but NOT possible */

 ELSE DO:  /* conversion not needed OR needed and possible */

  if cerror = "no-convert"
   then INPUT FROM VALUE(user_env[2]) NO-ECHO NO-MAP NO-CONVERT.
   else INPUT FROM VALUE(user_env[2]) NO-ECHO NO-MAP
               CONVERT SOURCE codepage TARGET SESSION:CHARSET.

  RUN VALUE(tmpfile).

  INPUT CLOSE.

  OS-DELETE VALUE(tmpfile).
  run adecomm/_setcurs.p ("").

  /* auditing of application data */
  AUDIT-CONTROL:LOG-AUDIT-EVENT(10214, 
                                PDBNAME("dictdb") + "._sequence" /* db-name.table-name */, 
                                "" /* detail */).

  MESSAGE "Load of sequence values completed."
          VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.

  END.     /* conversion not needed OR needed and possible */

  /* for auditing - clear the application context, if we have set one */
  IF newAppCtx THEN
     AUDIT-CONTROL:CLEAR-APPL-CONTEXT.

RETURN.
