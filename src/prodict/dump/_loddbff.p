/*********************************************************************
* Copyright (C) 2000,2007 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* loaddbff 

  fernando   06/20/07  Support for large files
*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

DEFINE NEW SHARED STREAM loadread.
DEFINE NEW SHARED STREAM loaderr.
DEFINE NEW SHARED VARIABLE recs   AS INT64   INITIAL 0. /*UNDO*/
DEFINE NEW SHARED VARIABLE errs   AS INTEGER           NO-UNDO.
DEFINE NEW SHARED VARIABLE xpos   AS INTEGER INITIAL ? NO-UNDO.
DEFINE NEW SHARED VARIABLE ypos   AS INTEGER INITIAL ? NO-UNDO.
DEFINE NEW SHARED VARIABLE fil-d  AS CHARACTER         NO-UNDO.

DEFINE VARIABLE i         AS INTEGER   NO-UNDO.
DEFINE VARIABLE reason    AS CHARACTER NO-UNDO.
DEFINE VARIABLE answer    AS LOGICAL   NO-UNDO.
DEFINE VARIABLE tmpfile_e AS CHARACTER NO-UNDO.
DEFINE VARIABLE tmpfile_d AS CHARACTER NO-UNDO.

/* LANGUAGE DEPENDENCIES START */ /*----------------------------------------*/
DEFINE VARIABLE new_lang AS CHARACTER EXTENT 8 NO-UNDO INITIAL [
  /*  1*/ "Data Conversion Complete", /* DO NOT CHANGE - output from 'dbf' */
  /*  2*/ "records in DBF format loaded into",
  /*  3*/ "There was one error encountered during the translation.",
  /*  4*/ "It is listed in the error file",
  /*5,6*/ "There were", "errors encountered during the translation.",
  /*  7*/ "They are listed in the error file",
  /*  8*/ "Do you want to continue?"
].
/* LANGUAGE DEPENDENCIES END */ /*------------------------------------------*/


RUN "adecomm/_tmpfile.p" (INPUT "e", INPUT ".adm", OUTPUT tmpfile_e).
RUN "adecomm/_tmpfile.p" (INPUT "d", INPUT ".adm", OUTPUT tmpfile_d).
RUN "prodict/misc/osdbfutl.p"
  ("1",user_env[3],user_env[4],tmpfile_e,tmpfile_d).

INPUT FROM VALUE(tmpfile_e) NO-ECHO.
REPEAT:
  IMPORT reason.
  IF reason = "" OR reason = new_lang[1] THEN NEXT.
  answer = no.
  MESSAGE reason SKIP new_lang[8] 
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer.
  IF answer = no THEN DO:
    HIDE MESSAGE NO-PAUSE.
    user_path = "".
    RETURN.
  END.
END.
INPUT CLOSE.

/* create and run import program */

/* user_env[1]=filename, user_env[6]=fieldnames */
run adecomm/_setcurs.p ("WAIT").
OUTPUT STREAM loaderr TO VALUE(user_env[1] + ".e") NO-ECHO.
INPUT STREAM loadread FROM VALUE(tmpfile_d) NO-ECHO NO-MAP.
CREATE ALIAS "DICTDB2" FOR DATABASE VALUE(user_dbname) NO-ERROR.

DO ON STOP UNDO, LEAVE:
   RUN "prodict/misc/_runload.i" (INPUT "n")
      VALUE(user_env[1]) 100 100 user_env[6] 0.
END.

INPUT STREAM loadread CLOSE.
OUTPUT STREAM loaderr CLOSE.
run adecomm/_setcurs.p ("").

IF errs = 0 THEN DO:
  MESSAGE recs new_lang[2] user_env[1] /* records loaded */
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
  OS-DELETE VALUE(user_env[1] + ".e").  /* delete temp external files */
END.
ELSE
  MESSAGE recs new_lang[2] user_env[1] SKIP
      	  new_lang[IF errs = 1 THEN 3 ELSE 5] 
      	  (IF errs = 1 THEN "" ELSE STRING(errs) + " " + new_lang[6]) SKIP
          "***" new_lang[IF errs = 1 THEN 4 ELSE 7] user_env[1] + ".e"
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.

OS-DELETE VALUE(tmpfile_e) VALUE(tmpfile_d).
RETURN.
