/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/

/* _dmpsddl.p - dump data definitions */

/*
in:  user_env[1]   = containing comma-separated list of filenames in
                     current database, *only* if user_filename = "SOME".
     user_env[2]   = Name of file to dump to.
     user_env[5]   = "<internal defaults apply>" or "<target-code-page>"
                     (only for "d"!)   /* hutegger 94/02 */
     user_env[6]   = "no-alert-boxes" or something else
     user_env[9]   = "d" - dump defs 
      	       	     	 - if user selected a specific table: translates into
      	       	     	   "t" for dumpdefs.
      	       	     	 - if user selected ALL: translates into "d","s"
      	       	     	   and "t" for dumpdefs where "d" will output both
      	       	     	   auto connect and collation info.
                     "a" - auto connect 
      	       	     "c" - collation info
                     "s" - sequences.
     user_env[25]  = "AUTO" or ""
     user_env[26]  = "y" or "n" yes/no to dump field Field._Field-rpos (POSITION)
     user_filename = "ALL"        all files of a schema
                     "SOME"       some of the files of the first schema
                     "SOME MORE"  some of the files of a following schema
                     "ONE"        one file of the first schema
                     "ONE MORE"   one file of a following schema
                     
When dumping automatically all definitions of all schemas, the .df-file 
should contain only one trailer - at the very   end. Therefor the batch-
program passes "AUTO" to suppress the trailer for the 1. to 
n-1. db.
"" symbolizes the default-behaviour (:= generate trailer).

History:
    D. McMann   10/03/02    Added USE-INDEX for On-line schema add
    D. McMann   09/30/02    Added check for SQL92 tables.
    D. McMann   02/09/12    Changed where check for owner is done 20020912-009
    Mario B     99/03/15    Added user_env[26] for dump _Field._Field-rpos
    hutegger    95/01/24    single-files in multiple schemas
    hutegger    94/06/09    batch-automatism
    hutegger    94/02/24    code-page - support and trailer-info added
        
*/
/*h-*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }
{ prodict/fhidden.i}

DEFINE VARIABLE Dbs         AS CHARACTER    NO-UNDO.
DEFINE VARIABLE file_len    AS INTEGER      NO-UNDO.
DEFINE VARIABLE i           AS INTEGER      NO-UNDO.
DEFINE VARIABLE Seqs        AS CHARACTER    NO-UNDO.
DEFINE VARIABLE stopped     AS LOGICAL      NO-UNDO init true.

DEFINE NEW SHARED STREAM ddl.


/* LANGUAGE DEPENDENCIES START */ /*----------------------------------------*/

FORM
  Dbs 	       	    LABEL "Database"  COLON 11 FORMAT "x(32)" SKIP
  _File._File-name  LABEL "Table"     COLON 11 FORMAT "x(32)" SKIP
  Seqs 	       	    LABEL "Sequence"  COLON 11 FORMAT "x(32)" SKIP
  HEADER 
    "Dumping Definitions.  Press " +
     KBLABEL("STOP") + " to terminate the dump process." format "x(70)"
  WITH FRAME working 
  ROW 4 CENTERED SIDE-LABELS ATTR-SPACE USE-TEXT &IF "{&WINDOW-SYSTEM}" <> "TTY"
  &THEN VIEW-AS DIALOG-BOX THREE-D TITLE "Dump Data Definitions" &ENDIF.

COLOR DISPLAY MESSAGES
  _File._File-name Dbs Seqs
  WITH FRAME working.

if TERMINAL <> ""
 then DISPLAY
    ""   @ Dbs
    ""	 @ _File._File-name
    ""   @ Seqs
    WITH FRAME working.

/* LANGUAGE DEPENDENCIES END */ /*------------------------------------------*/

if TERMINAL <> "" 
 then run adecomm/_setcurs.p ("WAIT").

if  user_env[5] = " "
 OR user_env[5] = ? 
 then assign user_env[5] = "<internal defaults apply>".
 
if user_env[5] = "<internal defaults apply>"
 then OUTPUT STREAM ddl TO VALUE(user_env[2]) NO-ECHO NO-MAP NO-CONVERT.
 else OUTPUT STREAM ddl TO VALUE(user_env[2]) NO-ECHO NO-MAP
             CONVERT SOURCE SESSION:CHARSET TARGET user_env[5].

assign SESSION:IMMEDIATE-DISPLAY = yes.

DO ON STOP UNDO, LEAVE:
  if user_env[9] = "a" then DO:
    if TERMINAL <> "" then 
      DISPLAY "(Auto-Connect)" @ Dbs WITH FRAME working.
    RUN "prodict/dump/_dmpdefs.p" ("a",drec_db,user_env[26]).
    end.
  else if user_env[9] = "c" then DO:
    if TERMINAL <> "" then 
      DISPLAY user_dbname + " (Collate)" @ Dbs WITH FRAME working.
    RUN "prodict/dump/_dmpdefs.p" ("c",drec_db, user_env[26]).
    end.
  else if user_env[9] = "s" then DO:
    if TERMINAL <> "" then 
      DISPLAY user_dbname @ Dbs 
      	"ALL" @ Seqs 
      	WITH FRAME working.
    RUN "prodict/dump/_dmpdefs.p" ("s",drec_db,user_env[26]).
    end.
  else 
    FOR EACH DICTDB._File
      WHERE _File._Db-recid = drec_db
        AND ( if user_filename = "ALL"
              then (IF NOT fHidden THEN NOT DICTDB._File._Hidden
	      	    	    	   ELSE DICTDB._File._File-Number > 0 )
             else if user_filename begins "SOME"
              then CAN-DO(user_env[1],DICTDB._File._File-name)
              else RECID(DICTDB._File) = drec_file
           )
        USE-INDEX _File-name
      BREAK BY DICTDB._File._File-name:

      if   FIRST(DICTDB._File._File-name) 
       then do:  /* first _file of this _db */

        if  user_filename = "ALL"
         or user_filename = "SOME MORE"
         or user_filename = "ONE MORE"
         then do:  /* we need db-token */
          if TERMINAL <> ""
           then DISPLAY "ALL" @ Dbs
              WITH FRAME working.
          RUN "prodict/dump/_dmpdefs.p" ("d",drec_db,user_env[26]).
          end.     /* we need db-token */
  
        if user_filename = "ALL"
         then do:  /* "all" to dump */
          if TERMINAL <> ""
           then DISPLAY
              user_dbname @ Dbs
      	      "ALL"       @ Seqs
      	      WITH FRAME working.
          RUN "prodict/dump/_dmpdefs.p" ("s",drec_db,user_env[26]).
          end.     /* "all" to dump */
        
        end.     /* first _file of this _db */
        
      else
        if TERMINAL <> "" then
          DISPLAY user_dbname @ Dbs
      	    WITH FRAME working.

     /* This check has to be done after the FIRST-OF statment if SQL92
        tables are also in the database 20020912-009*/         
      IF INTEGER(DBVERSION("DICTDB")) > 8         
        AND (DICTDB._File._Owner <> "PUB" AND DICTDB._File._Owner <> "_FOREIGN")
          THEN NEXT.

      /* Do not dump SQL92 tables */
      IF DICTDB._File._Db-lang > 1 THEN NEXT.

      if TERMINAL <> "" then 
        DISPLAY _File._File-name WITH FRAME working.
      RUN "prodict/dump/_dmpdefs.p" ("t",RECID(_File),user_env[26]).
      end. /* for each _file */

  if user_env[25] <> "AUTO"
   then do:  /* no other _db-schema will follow -> trailer */
      {prodict/dump/dmptrail.i
        &entries      = " "
        &seek-stream  = "ddl"
        &stream       = "stream ddl"
        }  /* adds trailer with code-page-entry to end of file */
        end.    /* no other _db-schema will follow -> trailer */  

  stopped = false.
  end.

file_len = SEEK(ddl).
OUTPUT STREAM ddl CLOSE.

SESSION:IMMEDIATE-DISPLAY = no.
if TERMINAL <> "" then 
  run adecomm/_setcurs.p ("").

if user_env[6] = "no-alert-boxes"
then do:  /* output WITHOUT alert-box */

  if stopped then 
     MESSAGE "Dump terminated.".
   else do:
    if file_len < 3 
     then do:  /* the file is empty - nothing to dump */

      OS-DELETE VALUE(user_env[2]). 
      if TERMINAL <> "" then 
        MESSAGE "There were no " +  
	      (if user_env[9] = "a" then "auto-connect records" else
	       if user_env[9] = "s" then "sequence definitions" else
				         "data definitions"     ) + 
	      " to dump."                                            SKIP
	      "The output file has been deleted.".
      end.
    else 
      if TERMINAL <> "" then 
        MESSAGE "Dump of definitions completed.".
    end.
  
  end.      /* output WITHOUT alert-box */

 else do:  /* output WITH alert-box */

  if stopped
   then MESSAGE "Dump terminated."
      	   VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
   else do:
    if file_len < 3 
     then do:  /* the file is empty - nothing to dump */

      OS-DELETE VALUE(user_env[2]). 
      if TERMINAL <> ""
       then MESSAGE "There were no " +  
	      (if user_env[9] = "a" then "auto-connect records" else
	       if user_env[9] = "s" then "sequence definitions" else
				         "data definitions"     ) + 
	      " to dump."                                            SKIP
	      "The output file has been deleted."
	      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
      end.
    else if TERMINAL <> ""
     then MESSAGE "Dump of definitions completed." 
	      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    end.
  
  end.     /* output WITH alert-box */

if TERMINAL <> ""
 then HIDE FRAME working NO-PAUSE.

RETURN.



