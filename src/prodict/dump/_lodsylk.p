/***********************************************************************
* Copyright (C) 2000,2007 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/

/* loadsylk 

  fernando   06/20/07  Support for large files
*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

DEFINE NEW SHARED STREAM   loaderr.
DEFINE NEW SHARED STREAM   loadread.

DEFINE NEW SHARED VARIABLE recs   AS INT64   INITIAL 0. /*UNDO*/
DEFINE NEW SHARED VARIABLE errs   AS INTEGER           NO-UNDO.
DEFINE NEW SHARED VARIABLE xpos   AS INTEGER INITIAL ? NO-UNDO.
DEFINE NEW SHARED VARIABLE ypos   AS INTEGER INITIAL ? NO-UNDO.
DEFINE NEW SHARED VARIABLE fil-d  AS CHARACTER         NO-UNDO.

DEFINE            VARIABLE bad-sylk  AS LOGICAL INITIAL FALSE NO-UNDO.
DEFINE            VARIABLE i         AS INTEGER               NO-UNDO.
DEFINE		  VARIABLE tmpfile_i AS CHARACTER     	      NO-UNDO.
DEFINE		  VARIABLE tmpfile_o AS CHARACTER     	      NO-UNDO.

/* LANGUAGE DEPENDENCIES START */ /*----------------------------------------*/
DEFINE VARIABLE new_lang AS CHARACTER EXTENT 8 NO-UNDO INITIAL [
  /*  1*/ "File Not In Standard SYLK Format",
  /*  2*/ "records in SYLK format loaded into",
  /*  3*/ "There was one error encountered during the translation.",
  /*  4*/ "It is listed in the error file",
  /*5,6*/ "There were", "errors encountered during the translation.",
  /*  7*/ "They are listed in the error file",
  /*  8*/ "Can only load SYLK definitions into a {&PRO_DISPLAY_NAME} database."
].

FORM HEADER
   " Importing.  Press " + 
   KBLABEL("STOP") + " to terminate import process. " format "x(60)"
   WITH FRAME importing CENTERED ROW 5 USE-TEXT.


FIND _File WHERE _File._File-name = "sylk" 
             AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN") NO-ERROR.
IF AVAILABLE _File THEN
  FIND _Field "x" OF _File WHERE _Extent = 255 NO-ERROR.

bad-sylk = NOT AVAILABLE _File OR NOT AVAILABLE _Field.
IF bad-sylk AND user_dbtype <> "PROGRESS" THEN DO:
  PAUSE 0.
  MESSAGE new_lang[8] /* not PROGRESS database so can't create 'sylk' file */
    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  user_path = "".
  RETURN.
END.
IF bad-sylk THEN DO:
  MESSAGE "The SYLK system table is either missing from the schema" SKIP 
          "of the database, or is incorrect for the current version" SKIP
          "of the dictionary." SKIP
          "Should the proper definitions be loaded in so that the SYLK" SKIP
          "conversion may continue?"
      	  VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE bad-sylk.
  IF NOT bad-sylk THEN DO:
    user_path = "".
    RETURN.
  END.
  run adecomm/_setcurs.p ("WAIT").
  RUN "prodict/_dctsylk.p".
  run adecomm/_setcurs.p ("").
  user_path = "*C,_lodsylk".
  RETURN.
END.
/* LANGUAGE DEPENDENCIES END */ /*------------------------------------------*/

RUN "adecomm/_tmpfile.p" (INPUT "i", INPUT ".adm", OUTPUT tmpfile_i).
RUN "adecomm/_tmpfile.p" (INPUT "o", INPUT ".adm", OUTPUT tmpfile_o).
RUN "prodict/misc/osquoter.p" (user_env[4],?,?,tmpfile_i).

/* create PROGRESS readable file */
run adecomm/_setcurs.p ("WAIT").
SESSION:IMMEDIATE-DISPLAY = yes.
PAUSE 0 BEFORE-HIDE.
RUN "prodict/misc/_runsylk.i" (INPUT tmpfile_i, INPUT tmpfile_o).
PAUSE BEFORE-HIDE.

/* create and run import program */
  
/* user_env[1]=filename, 
   user_env[6]=fieldnames, 
   user_env[10]=disable trigger flag
*/
OUTPUT STREAM loaderr TO VALUE(user_env[1] + ".e") NO-ECHO.
INPUT STREAM loadread FROM VALUE(tmpfile_o) NO-ECHO NO-MAP.
CREATE ALIAS "DICTDB2" FOR DATABASE VALUE(user_dbname) NO-ERROR.

VIEW FRAME importing.

DO ON STOP UNDO, LEAVE:
  RUN "prodict/misc/_runload.i" (INPUT user_env[10])
       VALUE(user_env[1]) 100 100 user_env[6] 0.
END.

HIDE frame importing NO-PAUSE.
SESSION:IMMEDIATE-DISPLAY = no.
INPUT STREAM loadread CLOSE.
OUTPUT STREAM loaderr CLOSE.
run adecomm/_setcurs.p ("").

IF errs = 0 THEN DO:
  MESSAGE recs new_lang[2] user_env[1] /* records loaded */
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
  OS-DELETE VALUE(user_env[1] + ".e").
END.
ELSE 
  MESSAGE recs new_lang[2] user_env[1] SKIP /* recs loaded */
      	  new_lang[IF errs = 1 THEN 3 ELSE 5] 
      	  (IF errs = 1 THEN "" ELSE STRING(errs) + " " + new_lang[6]) SKIP
          "***" new_lang[IF errs = 1 THEN 4 ELSE 7] user_env[1] + ".e"
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.

OS-DELETE VALUE(tmpfile_i) VALUE(tmpfile_o).
RETURN.

