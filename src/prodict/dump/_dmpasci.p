/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*

File: dump/_dmpasci.p 

Description:
    program to dump data in 'ascii' format

Input Parameters:
    user_env[ 1] = filename to export
    user_env[ 2] = 'where' clause
    user_env[ 3] = 'by' clause
    user_env[ 4] = output file name
    user_env[ 5] = number of fields
    user_env[ 6] = field list, comma delimited
    user_env[ 7] = ?, or filename to save generated code in
    user_env[ 8] = 'y' for first line to be field names, 'n' for no header
    user_env[ 9] = format name for message
    user_env[10] = field delimiter (e.g. quotes)
    user_env[11] = field separator (e.g. commas)
    user_env[12] = record separator (e.g. linefeeds)
    user_env[13] = record starter
    user_env[14] = "y" - disable triggers, "n" - do not disable triggers

History:
    95/07   hutegger    prepend <db>.<table> to field-names in order to
                        make generated program work with multiple-schema-
                        environement
    10/15/03 D. McMann  Add support for datetime and datetime-tz  

*/
/*h-*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

DEFINE NEW SHARED VARIABLE totrecs AS INTEGER NO-UNDO.
DEFINE VARIABLE i         AS INTEGER   NO-UNDO.
DEFINE VARIABLE dbfn      AS CHARACTER NO-UNDO.
DEFINE VARIABLE qual      AS CHARACTER NO-UNDO.
DEFINE VARIABLE sort      AS CHARACTER NO-UNDO.
DEFINE VARIABLE fld-sep   AS CHARACTER NO-UNDO.
DEFINE VARIABLE rec-end   AS CHARACTER NO-UNDO.
DEFINE VARIABLE rec-beg   AS CHARACTER NO-UNDO.
DEFINE VARIABLE fld-dlm   AS CHARACTER NO-UNDO.
DEFINE VARIABLE tmpfile   AS CHARACTER NO-UNDO.

/* LANGUAGE DEPENDENCIES START */ /*----------------------------------------*/
DEFINE VARIABLE new_lang AS CHARACTER EXTENT 2 NO-UNDO INITIAL [
  /* 1*/ "records were dumped in",
  /* 2*/ "format to"
].

FORM HEADER
   " Exporting.  Press " +
     KBLABEL("STOP") + " to terminate export process. " format "x(60)" skip(0.5)
   WITH FRAME exporting CENTERED ROW 5 USE-TEXT.

/* LANGUAGE DEPENDENCIES END */ /*------------------------------------------*/

RUN "prodict/_dctquot.p" (INPUT user_env[10],'"',OUTPUT fld-dlm).
RUN "prodict/_dctquot.p" (INPUT user_env[11],'"',OUTPUT fld-sep).
RUN "prodict/_dctquot.p" (INPUT user_env[12],'"',OUTPUT rec-end).
RUN "prodict/_dctquot.p" (INPUT user_env[13],'"',OUTPUT rec-beg).

ASSIGN
  fld-dlm = SUBSTRING(fld-dlm,2,LENGTH(fld-dlm) - 2)
  fld-sep = SUBSTRING(fld-sep,2,LENGTH(fld-sep) - 2)
  rec-beg = SUBSTRING(rec-beg,2,LENGTH(rec-beg) - 2)
  rec-end = SUBSTRING(rec-end,2,LENGTH(rec-end) - 2)
  dbfn    = user_dbname + "." + user_env[1]
  qual    = user_env[2]
  sort    = user_env[3]
  totrecs = 0.

IF user_env[7] = ?
 THEN RUN "adecomm/_tmpfile.p" (INPUT "", INPUT ".adm", OUTPUT tmpfile).
OUTPUT TO VALUE(IF user_env[7] = ?
                 THEN tmpfile
                 ELSE user_env[7]
               ) NO-MAP.
PUT UNFORMATTED
  "DEFINE SHARED VARIABLE totrecs AS INTEGER NO-UNDO."      SKIP
  "DEFINE VARIABLE hlddt AS CHARACTER NO-UNDO. "            SKIP
  "OUTPUT TO ~"" user_env[4] "~" NO-MAP."                   SKIP
  "ASSIGN totrecs = 0."                                     SKIP.

IF user_env[14] = "y"
 THEN PUT UNFORMATTED
   "DISABLE TRIGGERS FOR DUMP OF " dbfn "."                 SKIP.

IF INTEGER(DBVERSION("DICTDB")) > 8 THEN
  FIND DICTDB._File
    WHERE DICTDB._File._Db-recid  = drec_db
    AND   DICTDB._File._File-name = user_env[1]
    AND (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN").
ELSE
  FIND DICTDB._File
    WHERE DICTDB._File._Db-recid  = drec_db
    AND   DICTDB._File._File-name = user_env[1].    

IF user_env[8] = "y"
 THEN DO:

  PUT UNFORMATTED
    "PUT UNFORMATTED".

  DO i = 1 TO NUM-ENTRIES(user_env[6]): /* count_chosen */

    FIND DICTDB._Field OF DICTDB._File
      WHERE DICTDB._Field._Field-name = ENTRY(i,user_env[6]).
    PUT UNFORMATTED                                         SKIP
      "  ~""
      fld-dlm DICTDB._Field._Field-name fld-dlm
      ( IF i < INTEGER(user_env[5])
         THEN fld-sep
         ELSE rec-end
      )
      "~"".

    END.

  PUT UNFORMATTED
    "."                                                     SKIP.

  END.

PUT UNFORMATTED
  "FOR EACH " SPACE(0) dbfn                                 SKIP
  "  " qual " " sort ":"                                    SKIP
  "  ASSIGN totrecs = totrecs + 1."                         SKIP.

DO i = 1 TO NUM-ENTRIES(user_env[6]): /* count_chosen */

  FIND DICTDB._Field OF DICTDB._File
    WHERE DICTDB._Field._Field-name = ENTRY(i,user_env[6]).
  IF CAN-DO("datetime,datetime-tz",DICTDB._Field._Data-type) THEN DO:
    PUT UNFORMATTED 
      '  ASSIGN hlddt = ISO-DATE(' dbfn + "." + DICTDB._Field._Field-name ').' SKIP.
    PUT UNFORMATTED "  PUT UNFORMATTED ~"" 
      ( IF i = 1 THEN rec-beg ELSE "" ) fld-dlm "~" 
      hlddt  ~"" fld-dlm ( IF i < INTEGER(user_env[5]) THEN fld-sep ELSE rec-end )
          "~"" "."      SKIP.
  END.
  ELSE
    PUT UNFORMATTED
      "  PUT UNFORMATTED ~"" 
      ( IF i = 1
         THEN rec-beg
         ELSE ""
      )
      fld-dlm "~" "
      dbfn + "." + DICTDB._Field._Field-name
      " ~"" fld-dlm
      ( IF i < INTEGER(user_env[5])
         THEN fld-sep
         ELSE rec-end
      )
      "~"" "."                                                SKIP.
END.

PUT UNFORMATTED
  "  END."                                                  SKIP
  "OUTPUT CLOSE."                                           SKIP
  "RETURN."                                                 SKIP.

OUTPUT CLOSE.

IF user_env[7] = ?
 THEN DO:
  SESSION:IMMEDIATE-DISPLAY = yes.
  VIEW FRAME exporting.
  run adecomm/_setcurs.p ("WAIT").

  DO ON STOP UNDO, LEAVE:
    RUN VALUE(tmpfile).
    END.

  HIDE FRAME exporting NO-PAUSE.
  SESSION:IMMEDIATE-DISPLAY = no.
  run adecomm/_setcurs.p ("").

  MESSAGE totrecs new_lang[1] user_env[9] new_lang[2] user_env[4]
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
  OS-DELETE VALUE(tmpfile).
END.

RETURN.
