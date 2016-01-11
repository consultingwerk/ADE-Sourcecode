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


/* _dmpsddl.p - dump AS/400 data definitions */

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
      	       	     	   auto connect and collate/translate info.
                     "s" - sequences.
     user_env[25]  = "AUTO" or ""
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
       Initial Creation:  95-05-01   NEH  Taken from prodict/dump/_dmpsddl
                                          Modified for AS/400.  
                                          
                History:  06/10/99 DLM Added stored procedure support     
*/
/*h-*/

{ as4dict/dictvar.i shared }
{ as4dict/dump/dumpvar.i shared }

DEFINE VARIABLE file_len    AS INTEGER      NO-UNDO.
DEFINE VARIABLE i           AS INTEGER      NO-UNDO.
DEFINE VARIABLE Seqs        AS CHARACTER    NO-UNDO.
DEFINE VARIABLE stopped     AS LOGICAL      NO-UNDO init true.

DEFINE NEW SHARED STREAM ddl.
DEFINE NEW SHARED FRAME working.

/* put in dump var when merging */
/* Define shared var dump_format as char NO-UNDO. */

/* LANGUAGE DEPENDENCIES START */ /*----------------------------------------*/

{ as4dict/dump/as4dmpdf.f &FRAME = "working" }

if TERMINAL <> ""
 then DISPLAY
    ""   @ as4dict.p__db._db-name
    ""	 @ as4dict.p__File._File-name   
    ""   @ as4dict.p__Field._Field-name
    ""   @ as4dict.p__Index._Index-name
    ""   @ as4dict.p__Seq._Seq-name
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

/* We call _dmpdefs.p with 2 parameters, the second of which would be
   the dbrecid which is meaningless to the AS400 P__ files, since we
   can only be working with 1 database at a time. So, the 2nd parameter
   is dummied out.                                                   */
   
DO ON STOP UNDO, LEAVE:
  if user_env[9] = "s" then DO:
      if TERMINAL <> "" then 
      DISPLAY user_dbname @ as4dict.p__db._db-name 
      	"" @ as4dict.p__seq._Seq-Name  
      	WITH FRAME working.            
    RUN "as4dict/dump/_dmpdefs.p" ("s", 0).
    end.
  else 
    FOR EACH as4dict.p__File
      WHERE ( if user_filename = "ALL"
                then as4dict.p__File._Hidden <> "Y" 
              else if user_filename begins "SOME"
                then CAN-DO(user_env[1],as4dict.p__File._File-name)
              else as4dict.p__file._file-name = user_filename
            )
      BREAK BY as4dict.p__File._File-num:
      IF dump_format <> "AS400" AND as4dict.p__File._For-info = "PROCEDURE"
        THEN NEXT.
      if   FIRST(as4dict.p__File._File-num) 
       then do:  /* first _file of this _db */

        if  user_filename = "ALL"
         or user_filename = "SOME MORE"                     
         or user_filename = "ONE MORE"
         then do:  /* we need db-token */
          if TERMINAL <> ""
           then DISPLAY "ALL" @ as4dict.p__db._db-name
              WITH FRAME working.
          RUN "as4dict/dump/_dmpdefs.p" ("d", 0).
          end.     /* we need db-token */
  
        if user_filename = "ALL"
         then do:  /* "all" to dump */
          if TERMINAL <> ""
           then DISPLAY
              user_dbname @ as4dict.p__db._db-name
      	      "ALL"       @ as4dict.p__Seq._Seq-Name
      	      WITH FRAME working.
 
        RUN "as4dict/dump/_dmpdefs.p" ("s", 0).  
        end.     /* "all" to dump */        
      end.     /* first _file of this _db */
        
 /*   else  */
      if TERMINAL <> "" then
         DISPLAY user_dbname @ as4dict.p__db._db-name
      	    WITH FRAME working.
  
      if TERMINAL <> "" then 
        DISPLAY as4dict.p__File._File-name WITH FRAME working.
        
      RUN "as4dict/dump/_dmpdefs.p" ("t", as4dict.P__file._file-num).
      
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
	      (if user_env[9] = "s" then "sequence definitions" else
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
	      (if user_env[9] = "s" then "sequence definitions" else
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




