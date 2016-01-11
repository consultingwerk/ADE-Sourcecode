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

/* _usrincr.p */

/*
for each file:
  match up filename
  match up indexnames
  match up fieldnames
  handle differences
end.

match up:
  find object of same name.
  if found, leave.
  otherwise, make note and continue until all matched.
  if none left over, assume deletes.
  otherwise, ask if renamed.
  return.
end.

History:  07/14/98 DLM Added _Owner to _File Finds
          04/12/00 DLM Added support for long path names
*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }
{ prodict/user/userhue.i }
{ prodict/user/userpik.i NEW }

/* LANGUAGE DEPENDENCIES START */ /*----------------------------------------*/
DEFINE VARIABLE new_lang AS CHARACTER EXTENT 23 NO-UNDO INITIAL [
  /* 1*/ "The current database must have a DBTYPE of ~"PROGRESS~".",
  /* 2*/ "You do not have permission to use this option",
  /* 3*/ "with database",
  /* 4*/ "There are no other PROGRESS databases to compare.",
  /* 5*/ "BOTH of the databases to be compared must be connected.",
  /* 6*/ "Dump Incremental Definitions",
  /* 7*/ "A file already exists with the name:",
  /* 8*/ "Overwrite it?",
  /* 9*/ "This procedure compares the data",
  /*10*/ "definitions stored in the database you",
  /*11*/ "choose with the schema of the current",
  /*12*/ "database.  This produces a new",
  /*13*/ "definition file with all new, changed",
  /*14*/ "and deleted data definitions.",
  /*15*/ "~n",
  /*16*/ "This new file can be used to upgrade an",
  /*17*/ "existing schema to be identical with",
  /*18*/ "the schema in the current database.",
  /*19*/ "(Run ~"Load Data Definitions~" from",
  /*20*/ "the database you want to upgrade",
  /*21*/ "with input from the new definition",
  /*22*/ "file produced by this procedure).",
  /*23*/ "Create Incremental Definitions File"
].

FORM
  new_lang[9]  FORMAT "x(39)" SKIP
  new_lang[10] FORMAT "x(39)" SKIP
  new_lang[11] FORMAT "x(39)" SKIP
  new_lang[12] FORMAT "x(39)" SKIP
  new_lang[13] FORMAT "x(39)" SKIP
  new_lang[14] FORMAT "x(39)" SKIP
  new_lang[15] FORMAT "x(39)" SKIP
  new_lang[16] FORMAT "x(39)" SKIP
  new_lang[17] FORMAT "x(39)" SKIP
  new_lang[18] FORMAT "x(39)" SKIP
  new_lang[19] FORMAT "x(39)" SKIP
  new_lang[20] FORMAT "x(39)" SKIP
  new_lang[21] FORMAT "x(39)" SKIP
  new_lang[22] FORMAT "x(39)" SKIP
  WITH FRAME help1 OVERLAY NO-ATTR-SPACE 
  ROW 2 COLUMN 1 USE-TEXT NO-LABELS.

/* LANGUAGE DEPENDENCIES END */ /*------------------------------------------*/


DEFINE VARIABLE answer 	AS LOGICAL   NO-UNDO.
DEFINE VARIABLE c      	AS CHARACTER NO-UNDO.
DEFINE VARIABLE i      	AS INTEGER   NO-UNDO.
DEFINE VARIABLE canned  AS LOGICAL   NO-UNDO INIT TRUE.
{prodict/misc/filesbtn.i}

FORM                                                SKIP({&TFM_WID})
  user_env[2] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" AT 2 VIEW-AS FILL-IN SIZE 40 BY 1
         LABEL "Output File"
  btn_File                                          SKIP ({&VM_WIDG})
  user_env[5] {&STDPH_FILL} FORMAT "x(80)" COLON 13 VIEW-AS FILL-IN SIZE 40 BY 1
	 LABEL "Code Page"
  {prodict/user/userbtns.i}
  WITH FRAME dump1 
  SIDE-LABELS ATTR-SPACE CENTERED 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE " Dump Incremental Definitions ".



/*===============================Triggers=================================*/

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
/*----- HELP -----*/
/* This is the only frame used in the GUI environment */
on HELP of frame dump1
   or CHOOSE of btn_Help in frame dump1
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
      	       	     	     INPUT {&Dump_Incremental_Definitions_Dlg_Box},
      	       	     	     INPUT ?).
&ENDIF


ON GO OF FRAME dump1
DO:
  IF SEARCH(user_env[2]:SCREEN-VALUE IN FRAME dump1) <> ? THEN DO:
    answer = FALSE.
    MESSAGE new_lang[7] SKIP user_env[2]:SCREEN-VALUE SKIP(1) new_lang[8]
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer.
    IF NOT answer THEN 
    DO:
      APPLY "ENTRY" TO user_env[2] IN FRAME dump1.
      RETURN NO-APPLY.
    END.
  END.
END.

ON WINDOW-CLOSE OF FRAME dump1
   APPLY "END-ERROR" TO FRAME dump1.

/*----- LEAVE of fill-ins: trim blanks the user may have typed in filenames---*/
ON LEAVE OF user_env[2] in frame dump1
   user_env[2]:screen-value in frame dump1 = 
        TRIM(user_env[2]:screen-value in frame dump1).
{prodict/user/usrdump1.i
  &frame    = "dump1"
  &variable = "user_env[5]"
  }  /* checks if user_env[5] contains convertable code-page */
  
/*----- HIT of FILE BUTTON -----*/
ON CHOOSE OF btn_File in frame dump1 DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT user_env[2]:handle in frame dump1 /*Fillin*/,
        INPUT "Find Output File"  /*Title*/,
        INPUT ""                 /*Filter*/,
        INPUT no                 /*Must exist*/).
END.


/*============================Mainline code===============================*/

IF user_dbtype <> "PROGRESS" THEN DO:
  MESSAGE new_lang[1] /* both dbs must be 'progress' */
    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  user_path = "".
  RETURN.
END.

DELETE ALIAS "DICTDB2".
ASSIGN
  user_env[2] = "delta.df"
  c           = ?
  pik_row     = 4
  pik_down    = SCREEN-LINES - 13
  pik_column  = 42
  pik_count   = 0
  pik_title   = new_lang[23].
DO i = 1 TO cache_db#:
  IF   cache_db_t[i] <> "PROGRESS"
    OR cache_db_l[i] = LDBNAME("DICTDB") THEN NEXT.
  ASSIGN
    pik_count = pik_count + 1
    pik_list[pik_count] = cache_db_l[i].
END.

IF pik_count = 0 THEN DO:
  MESSAGE new_lang[4] SKIP new_lang[5] /* no other dbs to compare to */
    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  user_path = "".
  RETURN.
END.

&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
  DISPLAY new_lang[9]  new_lang[10] new_lang[11] new_lang[12]
      	  new_lang[13] new_lang[14] new_lang[15] new_lang[16]
      	  new_lang[17] new_lang[18] new_lang[19] new_lang[20]
      	  new_lang[21] new_lang[22] 
      	  WITH FRAME help1.
  RUN "prodict/user/_usrpick.p".
  HIDE FRAME help1.
&ELSE
  pik_text = "".
  DO i = 9 TO 22:
    pik_text = pik_text + new_lang[i].
    IF new_lang[i] <> "~n" AND i <> 22 THEN
       pik_text = pik_text + "~n".
  END.
  pik_help = {&Pick_DB_For_Incr_Dump_Dlg_Box}.
  RUN "prodict/gui/_guipick.p".
&ENDIF

IF pik_first = ? THEN DO:
  user_path = "".
  RETURN.
END.
CREATE ALIAS "DICTDB2" FOR DATABASE VALUE(pik_first) NO-ERROR.

/*
DO FOR DICTDB2._File:
  FIND DICTDB2._File "_Db" WHERE DICTDB2._File._Owner = "PUB" NO-LOCK.
  IF NOT CAN-DO(_Can-read,USERID("DICTDB2")) THEN c = LDBNAME("DICTDB2").
  
  FIND DICTDB2._File "_File" WHERE DICTDB2._File._Owner = "PUB" NO-LOCK.
  IF NOT CAN-DO(_Can-read,USERID("DICTDB2")) THEN c = LDBNAME("DICTDB2").
  
  FIND DICTDB2._File "_Field" WHERE DICTDB2._File._Owner = "PUB" NO-LOCK.
  IF NOT CAN-DO(_Can-read,USERID("DICTDB2")) THEN c = LDBNAME("DICTDB2").
  FIND DICTDB2._File "_Index" WHERE DICTDB2._File._Owner = "PUB" NO-LOCK.
  IF NOT CAN-DO(_Can-read,USERID("DICTDB2")) THEN c = LDBNAME("DICTDB2").
END.
*/

DO FOR DICTDB._File:
  FIND DICTDB._File "_Db" WHERE DICTDB._File._Owner = "PUB" NO-LOCK.
  IF NOT CAN-DO(_Can-read,USERID("DICTDB")) THEN c = LDBNAME("DICTDB").
  
  FIND DICTDB._File "_File" WHERE DICTDB._File._Owner = "PUB" NO-LOCK.
  IF NOT CAN-DO(_Can-read,USERID("DICTDB")) THEN c = LDBNAME("DICTDB").
  
  FIND DICTDB._File "_Field" WHERE DICTDB._File._Owner = "PUB" NO-LOCK.
  IF NOT CAN-DO(_Can-read,USERID("DICTDB")) THEN c = LDBNAME("DICTDB").
  
  FIND DICTDB._File "_Index" WHERE DICTDB._File._Owner = "PUB" NO-LOCK.
  IF NOT CAN-DO(_Can-read,USERID("DICTDB")) THEN c = LDBNAME("DICTDB").
END.

IF c <> ? THEN DO:
  MESSAGE new_lang[2] SKIP new_lang[3] c /* not enough privs on db */
    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  user_path = "".
  RETURN.
END.

assign user_env[2] = "delta.df".

/*--- code-page - stuff: assign default-value   <hutegger> ---*/
if  SESSION:CHARSET = ?
 or SESSION:STREAM  = ?
 then assign 
  user_env[5]           = "<internal defaults apply>"
  user_env[5]:SENSITIVE = false.
 else assign  
  user_env[5]           = SESSION:STREAM
  user_env[5]:SENSITIVE = true.
  

PAUSE 0.
/* Adjust the graphical rectangle and the ok and cancel buttons */
{adecomm/okrun.i  
   &FRAME  = "FRAME dump1" 
   &BOX    = "rect_Btns"
   &OK     = "btn_OK" 
   {&CAN_BTN}
   {&HLP_BTN}
}

DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
  answer = TRUE.
  UPDATE user_env[2] btn_File user_env[5]
      	 btn_OK btn_Cancel {&HLP_BTN_NAME}
      	 WITH FRAME dump1.

  { prodict/dictnext.i c }
  canned = FALSE.
END.

HIDE FRAME dump1 NO-PAUSE.
IF canned THEN
   user_path = "".
RETURN.

