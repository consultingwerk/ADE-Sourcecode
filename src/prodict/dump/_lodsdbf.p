/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* loadsdbf - translate dbase .dbf and .ndx into .df file */

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

/* The file to display - if this is ? then use sho_pages. */
DEFINE VARIABLE sho_file  AS CHARACTER INITIAL ?   NO-UNDO.

/* Data to display - 1 line per array element */
DEFINE VARIABLE sho_pages AS CHARACTER EXTENT 1024 NO-UNDO. 

/* The number of lines to display (only used with sho_pages) */
DEFINE VARIABLE sho_limit AS INTEGER               NO-UNDO.

/* The title for the frame */
DEFINE VARIABLE sho_title AS CHARACTER             NO-UNDO.

/* LANGUAGE DEPENDENCIES START */ /*----------------------------------------*/
DEFINE VARIABLE new_lang AS CHARACTER EXTENT 8 NO-UNDO INITIAL [
  /*  1*/ "",
  /*  2*/ "Could not find DBF Utility with current path.",
  /*  3*/ "Could not find file",
  /*  4*/ "Could not find index",
  /*  5*/ "These are the messages from the <dbf> utility.",
  /*  6*/ "To load the definitions, press OK, otherwise Cancel",
  /*  7*/ "Converting",
  /*  8*/ "<dbf> Utility Messages"
].
/* LANGUAGE DEPENDENCIES END */ /*------------------------------------------*/

/*
user_env[1] = dbf file name
user_env[2] = nuxi mode? (y/n)
user_env[4..13] = ndx file name(s)

dbf utility params:
Usage: dbf <dbfmode> <nuximode> <args...>
  dbfmode =  1 (produce .d file)
          =  2 (produce old V5 format .df file (table info))
          =  3 (produce old V5 format .df file (index info))
          = -2 (produce new V6 format .df file (table info))
          = -3 (produce new V6 format .df file (index info))
  nuximode = 0 .dbf file created by 680x0 (lsb, msb format)
           = 1 .dbf file created by 80x86 (msb, lsb format)
  args... =
    if dbfmode = 1: filename.dbf filename.err >filename.d
               = 2: filename.dbf filename.err >filename.df
               = 3: filename.dbf filename.ndx filename.err >filename.df
*/

DEFINE VARIABLE c      AS CHARACTER NO-UNDO.
DEFINE VARIABLE dbffil AS CHARACTER NO-UNDO.
DEFINE VARIABLE dbfutl AS CHARACTER NO-UNDO.
DEFINE VARIABLE errmsg AS CHARACTER NO-UNDO.
DEFINE VARIABLE i      AS INTEGER   NO-UNDO.
DEFINE VARIABLE nuxi   AS CHARACTER NO-UNDO.

ASSIGN
  dbfutl = SEARCH(IF OPSYS = "UNIX"  THEN "dbf"
           ELSE   IF CAN-DO("MSDOS,WIN32",OPSYS) THEN "dbf.exe"
           ELSE   ?)
  errmsg = ?
  dbffil = SEARCH(user_env[1])
  nuxi   = STRING(user_env[2] = "y","1/0").

IF dbfutl = ? THEN errmsg = new_lang[2].
ELSE IF dbffil = ? THEN errmsg = new_lang[3] + ' "' + user_env[1] + '"'.

IF errmsg <> ? THEN DO:
  MESSAGE errmsg VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

run adecomm/_setcurs.p ("WAIT").

OUTPUT TO "_dict.err" NO-ECHO.
PUT UNFORMATTED '"' new_lang[7] ' <' dbffil '>"' SKIP. /* converting... */
OUTPUT CLOSE.
c = "-2 " + nuxi + " " + dbffil + " _dict.tmp >_dict.ddl".
IF CAN-DO("MSDOS,WIN32",OPSYS) THEN DOS  SILENT VALUE(dbfutl) VALUE(c).
ELSE IF OPSYS = "UNIX"  THEN UNIX SILENT VALUE(dbfutl) VALUE(c).
RUN "prodict/misc/osappend.p" ("_dict.tmp","_dict.err").
OS-DELETE "_dict.tmp".

DO i = 4 TO 13:
  IF user_env[i] = "" OR user_env[i] = ? THEN NEXT.
  IF SEARCH(user_env[i]) = ? THEN DO:
    OUTPUT TO "_dict.err" APPEND.
    PUT UNFORMATTED new_lang[4] '"' user_env[i] '"' SKIP. /* ndx not found */
    OUTPUT CLOSE.
    NEXT.
  END.

  c = "-3 " + nuxi + " " + dbffil + " " + SEARCH(user_env[i])
    + " _dict.tmp >>_dict.ddl".
  IF CAN-DO("MSDOS,WIN32",OPSYS) THEN DOS  SILENT VALUE(dbfutl) VALUE(c).
  ELSE IF OPSYS = "UNIX"  THEN UNIX SILENT VALUE(dbfutl) VALUE(c).

  OUTPUT TO "_dict.err" NO-ECHO APPEND.
  PUT UNFORMATTED SKIP(1)
    '"' new_lang[7] ' <' SEARCH(user_env[i]) '>"' SKIP. /* converting... */
  OUTPUT CLOSE.
  RUN "prodict/misc/osappend.p" ("_dict.tmp","_dict.err").
  OS-DELETE "_dict.tmp".
END.

run adecomm/_setcurs.p ("").

ASSIGN
  sho_file = "_dict.err"
  sho_title = new_lang[8]
  user_env[5] = ""
  user_env[6] = new_lang[5]  /* dbf messages */
  user_env[7] = new_lang[6]. /* ok/cancel instructions */
RUN "prodict/user/_usershw.p" 
   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 
   (INPUT 0).
   &ELSE
   /* help contexts are only defined for gui */
   (INPUT {&Import_dBase_Definition_Results_Dlg_Box}).
   &ENDIF

IF RETURN-VALUE = "ok" THEN DO:
  ASSIGN
    user_env[2] = "_dict.ddl"
    user_env[8] = user_dbname.
  RUN "prodict/dump/_lodsddl.p".
END.

OS-DELETE "_dict.err" "_dict.ddl".

RETURN.
