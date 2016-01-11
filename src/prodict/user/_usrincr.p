/***********************************************************************
* Copyright (C) 2000,2006 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*
   _usrincr.p  phase 1 of GUI-mode incremental .df maker.  
   See prodict/dump_inc.p for phase 1 of batch incremental .df maker
   See ./dump/_dmpincr.p for phase 2 

   DICTDB  is the current database
           These are the baseline from which DICTDB2 will be compared 
           Definitions in DICTDB2 that are absent or extraneous to DICTDB
           constitute the incremental delta.df
   DICTDB2 is the database chosen to compare against
           This is the database for whom applying the incremental delta.df 
           would produce a database equivalent to DICTDB.

   The aim is to produce a database like DICTDB.  So this .df file will be
   run against a database like DICTDB2 to create a database like DICTDB.
*/

/*
DICTDB  = new definitions
DICTDB2 = old definitions

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

          08/03/2006 fernando   Check permission on DICTDB2 - 20060621-015

*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }
{ prodict/user/userhue.i }
{ prodict/user/userpik.i NEW }

/* LANGUAGE DEPENDENCIES START */ /*----------------------------------------*/
DEFINE VARIABLE new_lang AS CHARACTER EXTENT 45 NO-UNDO INITIAL [
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
  /*23*/ "Create Incremental Definitions File",
  /*24*/ "Set SHDBNAME and MSSDBNAME or ORADBNAME together to allow continuation",
  /*25*/ "Environment variable ",
  /*26*/ " not set properly.  Will be ignored.",
  /*27*/ "Environment variable SHDBNAME is set to """,
  /*28*/ """ as the database schema to compare against current working database """,
  /*29*/ """ does not match your screen selection of """,
  /*30*/ "Do you want to override SHDBNAME value of """,
  /*31*/ """ with your screen selection: """,
  /*32*/ "Incremental Definitions Database Comparison Selection",
  /*33*/ "SHDBNAME value """,
  /*34*/ """ is retained for execution. ",
  /*35*/ """ selection will be ignored.",
  /*36*/ """ is being overridden for execution by replacement value """,
  /*37*/ "Logical database """,
  /*38*/ """ must originate from the db type that corresponds to the set environment variable.",
  /*39*/ """ is not in the schema holder database ",
  /*40*/ "There is already a logical database """, 
  /*41*/ """ opened in another schema holder """, 
  /*42*/ "Aborting: logical database only associated with one schema holder in a session.",
  /*43*/ "Specified schema holder database """, 
  /*44*/ """ had more than one non-PROGRESS logical database.",
  /*45*/ "Your environement variables must select a logical database value when there are more than one in the specified schema holder."
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

DEFINE VARIABLE answer 	     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE c      	     AS CHARACTER NO-UNDO.
DEFINE VARIABLE i      	     AS INTEGER   NO-UNDO.
DEFINE VARIABLE canned       AS LOGICAL   NO-UNDO INIT TRUE.
DEFINE VARIABLE hBuffer      AS HANDLE    NO-UNDO.
DEFINE VARIABLE bufList      AS CHARACTER NO-UNDO EXTENT 4
   INIT ["_db","_File","_Field","_Index"].

/* For DataServer use */
DEFINE VARIABLE ds_shname    AS CHARACTER INITIAL ?  NO-UNDO.
DEFINE VARIABLE ds_dbname    AS CHARACTER INITIAL "" NO-UNDO.
DEFINE VARIABLE user-dbtype2 AS CHARACTER INITIAL ?  NO-UNDO.
DEFINE VARIABLE ds_alias     AS CHARACTER INITIAL ?  NO-UNDO.
DEFINE VARIABLE shdb2-id     AS RECID     INITIAL ?  NO-UNDO.
DEFINE VARIABLE dictdb2-id   AS RECID     INITIAL ?  NO-UNDO.
DEFINE VARIABLE errcode      AS INTEGER   INITIAL ?  NO-UNDO.
/* For DataServer use */

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


/* PROGRESS provides normal legacy execution by default */
ASSIGN s_DbType1    = "PROGRESS"
       s_DbType2    = "PROGRESS"
       user-dbtype2 = "PROGRESS". 

IF OS-GETENV("SHDBNAME") <> ? THEN DO:
  ds_shname = OS-GETENV("SHDBNAME").
  IF ds_shname = "" THEN DO:
    MESSAGE new_lang[25] "SHDBNAME" new_lang[26] /* Env. vars. not set properly */
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    ds_shname = ?.
  END.
END.

IF OS-GETENV("MSSDBNAME") <> ? THEN DO:
  ds_dbname = OS-GETENV("MSSDBNAME").
  IF ds_dbname = "" THEN DO:
    MESSAGE new_lang[25] "MSSDBNAME" new_lang[26] /* Env. vars. not set properly */
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    ds_dbname = ?.
  END.
  IF ds_dbname <> ? AND DBTYPE(ds_dbname) <> "MSS" THEN DO:
    MESSAGE new_lang[37] + ds_dbname + new_lang[38] /* logical db must be correct db type */
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    ds_dbname = ?.
  END.
  if ds_dbname <> ? THEN
    user-dbtype2 = "MSS".
END.
ELSE DO:
  IF OS-GETENV("ORADBNAME") <> ? THEN DO:
    ds_dbname = OS-GETENV("ORADBNAME").
    IF ds_dbname = "" THEN DO:
      MESSAGE new_lang[25] "ORADBNAME" new_lang[26] /* Env. vars. not set properly */
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      ds_dbname = ?.
    END. 
    IF ds_dbname <> ? AND DBTYPE(ds_dbname) <> "ORACLE" THEN DO:
        MESSAGE new_lang[37] + ds_dbname + new_lang[38] /* logical db must be correct db type */
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        ds_dbname = ?.
    END.
    if ds_dbname <> ? THEN
      user-dbtype2 = "ORACLE".
  END.
END.

IF ds_dbname = "" THEN
  ds_dbname = ?. /* If dflt untouched, normalize ds_dbname for legacy execution */

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
  IF cache_db_t[i] <> "PROGRESS"
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

IF ds_shname <> ? AND pik_first <> ds_shname THEN DO:
  MESSAGE new_lang[27] + ds_shname + new_lang[28] + LDBNAME("DICTDB") + """.  """ +
          ds_shname + new_lang[29] + pik_first + """." SKIP(1)
          new_lang[30] + ds_shname + new_lang[31] + pik_first + """ ?"
    VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL
    TITLE new_lang[32] UPDATE lChoice AS LOGICAL.
  CASE lChoice:
    WHEN TRUE THEN /* Yes */ DO:
      MESSAGE new_lang[33] + ds_shname + new_lang[36] + pik_first + """."
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK-CANCEL UPDATE OK AS LOGICAL.
      IF NOT ok THEN DO:
        user_path = "".
        RETURN.
      END.
      ELSE
        ds_shname = pik_first.
    END.
    WHEN FALSE THEN /* No */ DO:
      MESSAGE new_lang[33] ds_shname new_lang[34] + """" + pik_first + new_lang[35]
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK-CANCEL UPDATE OK2 AS LOGICAL.
      IF NOT ok2 THEN DO:
        user_path = "".
        RETURN.
      END.
      ELSE
        pik_first = ds_shname.
    END.
    OTHERWISE DO: /* Cancel */ 
      user_path = "".
      RETURN.
    END.
  END CASE.
END.

IF ds_shname <> ? AND ds_dbname = ? THEN DO:
  MESSAGE new_lang[24] /* Env. vars. not set properly */
    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  user_path = "". 
  RETURN.
END.

CREATE ALIAS "DICTDB2" FOR DATABASE VALUE(pik_first) NO-ERROR.

IF ds_dbname <> ? THEN DO:
  ASSIGN ds_alias = "DICTDB2".

  RUN "prodict/misc/_valsch.p" (INPUT        ds_alias     /* Dictionary Alias Name */,
                                INPUT        pik_first    /* Schema holder name */,
                                INPUT-OUTPUT ds_dbname    /* Logical database name */,
                                INPUT-OUTPUT user-dbtype2 /* Logical database type */,
                                OUTPUT       shdb2-id     /* RECID of DICTDB */,
                                OUTPUT       dictdb2-id   /* RECID of DICTDB2 */,
                                OUTPUT       errcode      /* Error code */).  

  IF errcode > 0 THEN DO:
    CASE errcode:
      WHEN 1 THEN  
        MESSAGE new_lang[37] + ds_dbname + new_lang[39] + ds_shname + """."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      WHEN 2 THEN
        MESSAGE new_lang[40] + ds_dbname + new_lang[41] + SDBNAME(ds_shname) + """."  SKIP(1) new_lang[42]
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      WHEN 3 THEN
        MESSAGE new_lang[43] + ds_shname + new_lang[44] SKIP(1) new_lang[45] 
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      WHEN 4 THEN
        MESSAGE new_lang[37] + ds_dbname + new_lang[39] + ds_shname + """."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    END CASE.
    user_path = "".
    RETURN.
  END.
  
  s_DbRecId = ?. /* Borrow ADE dictionary variable not used by incremental dump */
  IF ds_dbname = ? OR ds_dbname = "" OR dictdb2-id = ? THEN DO:
      user_path = "". 
      RETURN.
  END.
  ELSE DO:
    /* DELETE ALIAS "DICTDBG". */
    /* CREATE ALIAS "DICTDBG" FOR DATABASE VALUE(ds_dbname) NO-ERROR. */
    s_DbRecId = dictdb2-id.
    s_DbType2 = user-dbtype2.
  END.
END.
ELSE DO:
  CREATE BUFFER hBuffer FOR TABLE "DICTDB2._File" NO-ERROR.
  IF VALID-HANDLE(hBuffer) THEN DO:
    /* check all the tables we're interested in */
    REPEAT pik_count = 1 TO 4:
      hBuffer:FIND-FIRST('WHERE DICTDB2._File._File-name = '
                          + QUOTER(bufList[pik_count]) 
                          + ' AND DICTDB2._File._Owner = "PUB"', NO-LOCK) NO-ERROR.
    /* if an error occurred, assume we don't have permissions to read */
    IF ERROR-STATUS:ERROR OR ERROR-STATUS:NUM-MESSAGES > 0 THEN DO:
      ASSIGN C = LDBNAME("DICTDB2").
    END.
    ELSE IF hBuffer:AVAILABLE THEN DO:
      IF NOT CAN-DO(hBuffer::_Can-read,USERID("DICTDB2")) THEN c = LDBNAME("DICTDB2").
        hBuffer:BUFFER-RELEASE().
      END.

      IF c NE ? THEN 
        LEAVE.
      END.

      DELETE OBJECT hBuffer NO-ERROR.
  END.
  ELSE /* if we could not create a buffer, assume we can't read the table */
    ASSIGN C = LDBNAME("DICTDB2").
END.

IF c <> ? THEN DO:
  MESSAGE new_lang[2] SKIP new_lang[3] c /* not enough privs on db */
    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  user_path = "".
  RETURN.
END.

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

