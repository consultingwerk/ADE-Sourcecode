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

/* userdump - user interface and defaults setup for dumping */

/*
IN:
  user_env[1] = "ALL" or comma-separated list of files
  user_env[9] = type of dump (e.g. .df or .d or bulk-load file)
		"4" = dump file definitions with AS/400 stuff
		"5" = dump file definitions in V5 format
		"a" = dump auto-connect records
		"c" = dump collation tables
		"b" = make bulkload description file
		"d" = dump definitions
		"f" = dump data file contents
		"s" = dump sequence definitions
		"k" = dump sequence values
		"u" = dump user file contents
		"v" = dump view file contents

OUT:
  user_env[1] = same as IN
  user_env[2] = physical file or directory name for some output
  user_env[3] = "MAP <name>" or "NO-MAP" OR ""
  user_env[4] = comma separated list of "y" (yes) or "n" (no) which
		corresponds to file list in user_env[1], indicating for each 
		whether triggers should be disabled when the dump is done.
		(only used for dump data file contents, "f").
  user_env[5] = "<source-code-page>,<target-code-page>" or "UNDEFINED"
                (only for .df- and .d-files!)  /*hutegger*/
  user_env[9] = same as IN
  user_env[26] = "y" or "n" to dump Field._Field-rpos or not.

history:
    mcmann      08/12/03    Add GET-DIR functionality
    mcmann      00/04/13    Added support for long path names
    Mario B     99/03/15    Added user_env[26] for conditional dump of 
                            _Field._Field-rpos
    mcmann      98/07/13    Added _Owner to _File finds
    gfs         95/05/31    allow dumping of hidden files if flag set
    gfs         94/11/04    add check for _File._Can-dump
    gfs         94/11/01    changed code-page to code page
    gfs         94/07/30    fixed dialogs
    gfs         94/06/23    changed default value logic for codepage
    hutegger    94/02/22    code-page support
    hutegger    94/05/04    change default-value for mapping to "NO-MAP"
    mcmann      03/02/04    Added LOB Directory
    mcmann      03/06/13    Removed lob directory from dump of df file
    mcmann      03/10/17    Add NO-LOCK statement to _Db find in support of on-line schema add
    
*/
/*h-*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }
{ prodict/fhidden.i}

DEFINE VARIABLE answer   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE canned   AS LOGICAL    NO-UNDO INITIAL TRUE.
DEFINE VARIABLE base     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE class    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE comma    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dump-as  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE err      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE i        AS INTEGER    NO-UNDO.
DEFINE VARIABLE io-file  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE io-mapc  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE io-mapl  AS INTEGER    NO-UNDO INITIAL 0.
DEFINE VARIABLE io-title AS CHARACTER  NO-UNDO.
DEFINE VARIABLE is-all   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE is-one   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE is-some  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE msg-num  AS INTEGER    NO-UNDO INITIAL 0.
DEFINE VARIABLE nodump   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE prefix   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE trash    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dis_trig AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dmp-rpos AS LOGICAL    NO-UNDO INITIAL TRUE.
DEFINE VARIABLE inclob   AS LOGICAL    NO-UNDO INITIAL TRUE.
DEFINE VARIABLE s_res    AS LOGICAL    NO-UNDO.

{prodict/misc/filesbtn.i}

DEFINE BUTTON btn_dir
  SIZE 11 by 1.
DEFINE BUTTON btn_dir2
  SIZE 11 by 1 .

&IF "{&OPSYS}" <> "MSDOS" and "{&OPSYS}" <> "WIN32" &THEN
    &SCOPED-DEFINE SLASH /
&ELSE 
    &SCOPED-DEFINE SLASH ~~~\
&ENDIF

FORM SKIP({&TFM_WID})
  user_env[2] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" COLON 12 VIEW-AS FILL-IN SIZE 40 BY 1
	 LABEL "Output File"
  btn_File                                        SKIP ({&VM_WIDG})
  user_env[5] {&STDPH_FILL} FORMAT "x(80)" COLON 12 VIEW-AS FILL-IN SIZE 40 BY 1
	 LABEL "Code Page"
  {prodict/user/userbtns.i}
  WITH FRAME write-def-file
  SIDE-LABELS ATTR-SPACE CENTERED 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".

FORM SKIP({&TFM_WID})
  user_env[2] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" COLON 15 VIEW-AS FILL-IN SIZE 40 BY 1
	 LABEL "Output File"
  btn_File                                        SKIP ({&VM_WIDG})
  user_env[5] {&STDPH_FILL} FORMAT "x(80)" COLON 15 VIEW-AS FILL-IN SIZE 40 BY 1
	 LABEL "Code Page" SKIP ({&VM_WIDG})
  dmp-rpos VIEW-AS TOGGLE-BOX COLON 15 
        LABEL "Include &POSITION for .r Compatibility"	 	 
  {prodict/user/userbtns.i}
  WITH FRAME write-output-file
  SIDE-LABELS ATTR-SPACE CENTERED 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".

FORM SKIP({&TFM_WID})
   user_env[2] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" COLON 15 VIEW-AS FILL-IN SIZE 40 BY 1
	  LABEL "Output File"  btn_File  SKIP ({&VM_WIDG})
   &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
    "  Include LOB:" VIEW-AS TEXT AT 2  inclob LABEL "yes/no" view-as toggle-box SKIP ({&VM_WIDG}) 
    "LOB Directory:" VIEW-AS TEXT AT 2  user_env[30] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" NO-LABEL VIEW-AS FILL-IN 
       SIZE 40 BY 1    SKIP ({&VM_WIDG})
  &ELSE
    "  Include LOB:" VIEW-AS TEXT AT 2  inclob LABEL "yes/no" view-as toggle-box SKIP ({&VM_WIDG}) 
     user_env[30] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" COLON 15 VIEW-AS FILL-IN SIZE 40 BY 1 
        LABEL "Lob Directory" btn_dir LABEL "Dir..."  SKIP ({&VM_WIDG})
   &ENDIF
  user_env[5] {&STDPH_FILL} FORMAT "x(80)" COLON 15 VIEW-AS FILL-IN SIZE 40 BY 1
	 LABEL "Code Page" SKIP ({&VM_WIDG})
  {prodict/user/userbtns.i}
  WITH FRAME write-boutput-file
  SIDE-LABELS ATTR-SPACE CENTERED 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
 
  &IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN  
    &GLOBAL-DEFINE RADBTNVOFF 1.2
    &GLOBAL-DEFINE RADBTNHOFF 13
    &GLOBAL-DEFINE FILLCH 55
  &ELSE
    &GLOBAL-DEFINE RADBTNVOFF 0.9
    &GLOBAL-DEFINE RADBTNHOFF 12
    &GLOBAL-DEFINE FILLCH 47
  &ENDIF

  FORM SKIP({&TFM_WID})
    "Output File:":t20 VIEW-AS TEXT AT 2
    user_env[2] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" AT 2 VIEW-AS FILL-IN SIZE 40 BY 1
    btn_File                                        SKIP ({&VM_WIDG})
  
    "  Include LOB:" VIEW-AS TEXT AT 2  inclob LABEL "yes/no" view-as toggle-box SKIP ({&VM_WID}) 
    "LOB Directory:" VIEW-AS TEXT AT 2 
    user_env[30] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" AT 2 VIEW-AS FILL-IN SIZE 40 BY 1 
         btn_dir LABEL "Dir..." SKIP ({&VM_WIDG})
   "Character Mapping:":t26 VIEW-AS TEXT AT 2
    io-mapl VIEW-AS RADIO-SET
	RADIO-BUTTONS "NO-MAP", 1, "Map", 2 AT 2    SKIP ({&VM_WIDG})
    "Code Page:":t18 VIEW-AS TEXT AT 2
    user_env[5] {&STDPH_FILL} FORMAT "x(80)" AT 2 VIEW-AS FILL-IN SIZE 40 BY 1
   {prodict/user/userbtns.i}
    io-mapc {&STDPH_FILL} FORMAT "X(20)"
	AT ROW-OF io-mapl + {&RADBTNVOFF} COLUMN-OF io-mapl + {&RADBTNHOFF}
    WITH FRAME write-dump-file
    NO-LABELS NO-ATTR-SPACE CENTERED 
    DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
    VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".

  FORM SKIP({&TFM_WID})
    "Output Directory (if different from current directory):":t63 VIEW-AS TEXT AT 2
    user_env[2] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" AT 2 VIEW-AS FILL-IN 
	SIZE {&FILLCH} BY 1   btn_dir2 LABEL "Dir..."    SKIP({&VM_WIDG})
    "  Include LOB:" VIEW-AS TEXT AT 2 inclob LABEL "yes/no" view-as toggle-box SKIP ({&VM_WIDG})
    "LOB Directory: (Blank = Current Directory)" VIEW-AS TEXT AT 2
    user_env[30] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" AT 2 VIEW-AS FILL-IN 
      SIZE {&FILLCH} BY 1  btn_dir LABEL "Dir..."  SKIP ({&VM_WIDG})
    "Character Mapping:":t26 VIEW-AS TEXT AT 2
    io-mapl VIEW-AS RADIO-SET
	RADIO-BUTTONS "NO-MAP", 1, "Map", 2 AT 2    SKIP ({&VM_WIDG})
    "Code Page:":t18 VIEW-AS TEXT AT 2
    user_env[5] {&STDPH_FILL} FORMAT "x(80)" AT 2 VIEW-AS FILL-IN SIZE 40 BY 1
    {prodict/user/userbtns.i}
    io-mapc {&STDPH_FILL} FORMAT "X(20)"
	AT ROW-OF io-mapl + {&RADBTNVOFF} COLUMN-OF io-mapl + {&RADBTNHOFF}
    WITH FRAME write-dump-dir
    NO-LABELS NO-ATTR-SPACE CENTERED 
    DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
    VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".
&ELSE       /* tty */
  FORM SKIP({&TFM_WID})
    user_env[2] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" COLON 19 VIEW-AS FILL-IN SIZE 40 BY 1
	 LABEL "Output File"  btn_File SKIP ({&VM_WIDG})
     "Include LOB:" VIEW-AS TEXT AT 4 inclob LABEL "yes/no" view-as toggle-box SKIP ({&VM_WID})
     "LOB Directory:" VIEW-AS TEXT at 2 user_env[30] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})"  VIEW-AS FILL-IN SIZE 40 BY 1 SKIP ({&VM_WIDG})
    io-mapc {&STDPH_FILL} LABEL "Character Mapping"
	FORMAT "x(20)" COLON 19
    "(Blank = Default Map; use" COLON 41
    "~"NO-MAP~" to turn off mapping)" COLON 41       SKIP ({&VM_WIDG})
    user_env[5] {&STDPH_FILL} FORMAT "x(80)" COLON 19 VIEW-AS FILL-IN SIZE 40 BY 1
	 LABEL "Code Page"
    {prodict/user/userbtns.i}
    WITH FRAME write-dump-file
    NO-LABELS SIDE-LABELS NO-ATTR-SPACE CENTERED 
    DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
    VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".

  FORM SKIP({&TFM_WID})
    user_env[2] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" COLON 17 VIEW-AS FILL-IN SIZE 50 BY 1
	 LABEL "Output Directory"  SKIP ({&VM_WID})
    "(Blank = Current Directory)" VIEW-AS TEXT COLON 19 SKIP ({&VM_WIDG})
     "Include LOB:" VIEW-AS TEXT AT 6 inclob LABEL "yes/no" view-as toggle-box SKIP ({&VM_WID})     
     "LOB Directory:" VIEW-AS TEXT AT 4
      user_env[30] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})"  VIEW-AS FILL-IN SIZE 40 BY 1 SKIP ({&VM_WID})
      "(Blank = Current Directory)" VIEW-AS TEXT COLON 19 SKIP ({&VM_WIDG})
    io-mapc {&STDPH_FILL} LABEL "Character Mapping"
	FORMAT "x(20)" COLON 19
    "(Blank = Default Map; use" COLON 41
    "~"NO-MAP~" to turn off mapping)" COLON 41       SKIP ({&VM_WIDG})
    user_env[5] {&STDPH_FILL} FORMAT "x(80)" COLON 19 VIEW-AS FILL-IN SIZE 40 BY 1
	 LABEL "Code Page"
    {prodict/user/userbtns.i}
    WITH FRAME write-dump-dir
    NO-LABELS SIDE-LABELS NO-ATTR-SPACE CENTERED 
    DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
    VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".
&ENDIF


/*===============================Triggers=================================*/

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
/*----- HELP -----*/
on HELP of frame write-output-file
   or CHOOSE of btn_Help in frame write-output-file   
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
			     INPUT {&Dump_Stuff_Dlg_Box},
			     INPUT ?).

on HELP of frame write-boutput-file
   or CHOOSE of btn_Help in frame write-boutput-file
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
			     INPUT {&Make_Bulk_Load_Dlg_Box},
			     INPUT ?).

on HELP of frame write-boutput-file
   or CHOOSE of btn_Help in frame write-output-file
   /*Note: may be overridden below for bulk loader stuff*/
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
			     INPUT {&Dump_Stuff_Dlg_Box},
			     INPUT ?).

on HELP of frame write-def-file 
   or CHOOSE of btn_Help in frame write-def-file
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
			     INPUT {&Dump_Stuff_Dlg_Box},
			     INPUT ?).

on HELP of frame write-dump-file 
   or CHOOSE of btn_Help in frame write-dump-file
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
			     INPUT {&Dump_Data_Contents_Dlg_Box},
			     INPUT ?).

on HELP of frame write-dump-dir
   or CHOOSE of btn_Help in frame write-dump-dir
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
			     INPUT {&Dump_Data_Contents_Some_Dlg_Box},
			     INPUT ?).

  ON CHOOSE OF btn_dir in frame write-dump-file DO:
   RUN "prodict/misc/_dirbtn.p"
       (INPUT user_env[30]:handle in frame write-dump-file /*Fillin*/,
        INPUT "Find Lob Directory"  /*Title*/,
        INPUT ""                 /*Filter*/).
  END.

  ON CHOOSE OF btn_dir2 in frame write-dump-dir DO:
   RUN "prodict/misc/_dirbtn.p"
       (INPUT user_env[2]:handle in frame write-dump-dir /*Fillin*/,
        INPUT "Find Lob Directory"  /*Title*/,
        INPUT ""                 /*Filter*/).
  END.

  ON CHOOSE OF btn_dir in frame write-dump-dir DO:
   RUN "prodict/misc/_dirbtn.p"
       (INPUT user_env[30]:handle in frame write-dump-dir /*Fillin*/,
        INPUT "Find Lob Directory"  /*Title*/,
        INPUT ""                 /*Filter*/).
  END.

  ON CHOOSE OF btn_dir in frame write-boutput-file DO:
   RUN "prodict/misc/_dirbtn.p"
       (INPUT user_env[30]:handle in frame write-boutput-file /*Fillin*/,
        INPUT "Find Lob Directory"  /*Title*/,
        INPUT ""                 /*Filter*/).
  END.
&ENDIF


/*----- ON GO or OK -----*/
ON GO OF FRAME write-output-file
DO:
  DEFINE VAR basename AS CHAR NO-UNDO.
  DEFINE VAR fil      AS CHAR NO-UNDO.
  DEFINE VAR prefix   AS CHAR NO-UNDO.

  fil = user_env[2]:SCREEN-VALUE IN FRAME write-output-file.
  /* check file name entered */
  FILE-INFO:FILE-NAME = fil.
  IF INDEX(FILE-INFO:FILE-TYPE,"D") > 0 OR
    SUBSTRING(fil,LENGTH(fil),1,"CHARACTER":U) = "{&SLASH}" THEN DO:
    MESSAGE "The file name entered is invalid." VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY" TO user_env[2].
    RETURN NO-APPLY.
  END.
    
  RUN prodict/misc/osprefix.p
    ( INPUT  fil,
      OUTPUT prefix,
      OUTPUT basename
      ).
  if basename = fil then assign fil = "./" + fil.
  
  IF /*io-file AND*/ (SEARCH(fil) <> ?) THEN DO:
    answer = FALSE.
    MESSAGE "A file already exists with the name:" SKIP fil SKIP(1) "Overwrite?"
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer.
    IF NOT answer THEN 
    DO:
      APPLY "ENTRY" TO user_env[2] IN FRAME write-output-file.
      RETURN NO-APPLY.
    END. 
  END.

  /* Assign value of toggle to user_env[26] for dump of _Field._Field-rpos */
  ASSIGN dmp-rpos.
  user_env[26] = (IF NOT dmp-rpos THEN "n" ELSE "y").
END.

ON GO OF FRAME write-boutput-file
DO:
  DEFINE VAR basename AS CHAR NO-UNDO.
  DEFINE VAR fil      AS CHAR NO-UNDO.
  DEFINE VAR prefix   AS CHAR NO-UNDO.

  fil = user_env[2]:SCREEN-VALUE IN FRAME write-boutput-file.
  /* check file name entered */
  FILE-INFO:FILE-NAME = fil.
  IF INDEX(FILE-INFO:FILE-TYPE,"D") > 0 OR
    SUBSTRING(fil,LENGTH(fil),1,"CHARACTER":U) = "{&SLASH}" THEN DO:
    MESSAGE "The file name entered is invalid." VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY" TO user_env[2].
    RETURN NO-APPLY.
  END.
    
  RUN prodict/misc/osprefix.p
    ( INPUT  fil,
      OUTPUT prefix,
      OUTPUT basename
      ).
  if basename = fil then assign fil = "./" + fil.
  
  IF /*io-file AND*/ (SEARCH(fil) <> ?) THEN DO:
    answer = FALSE.
    MESSAGE "A file already exists with the name:" SKIP fil SKIP(1) "Overwrite?"
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer.
    IF NOT answer THEN 
    DO:
      APPLY "ENTRY" TO user_env[2] IN FRAME write-boutput-file.
      RETURN NO-APPLY.
    END. 
  END.
  user_env[26] =  "n" .
END.


ON GO OF FRAME write-def-file
DO:
  DEFINE VAR basename AS CHAR NO-UNDO.
  DEFINE VAR fil      AS CHAR NO-UNDO.
  DEFINE VAR prefix   AS CHAR NO-UNDO.

  fil = user_env[2]:SCREEN-VALUE IN FRAME write-def-file.
  /* check file name entered */
  FILE-INFO:FILE-NAME = fil.
  IF INDEX(FILE-INFO:FILE-TYPE,"D") > 0 OR
    SUBSTRING(fil,LENGTH(fil),1,"CHARACTER":U) = "{&SLASH}" THEN DO:
    MESSAGE "The file name entered is invalid." VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY" TO user_env[2].
    RETURN NO-APPLY.
  END.

  RUN prodict/misc/osprefix.p
    ( INPUT  fil,
      OUTPUT prefix,
      OUTPUT basename
      ).
  if basename = fil then assign fil = "./" + fil.
  
  IF /*io-file AND*/ (SEARCH(fil) <> ?) THEN DO:
    answer = FALSE.
    MESSAGE "A file already exists with the name:" SKIP fil SKIP(1) "Overwrite?"
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer.
    IF NOT answer THEN 
    DO:
      APPLY "ENTRY" TO user_env[2] IN FRAME write-def-file.
      RETURN NO-APPLY.
    END.
  END.
END.

ON GO OF FRAME write-dump-file
DO:
  DEFINE VAR basename AS CHAR NO-UNDO.
  DEFINE VAR fil      AS CHAR NO-UNDO.
  DEFINE VAR prefix   AS CHAR NO-UNDO.

  io-mapc = io-mapc:SCREEN-VALUE. /*To cover GUI case where not in UPDATE*/
  fil = user_env[2]:SCREEN-VALUE IN FRAME write-dump-file.
  /* check file name entered */
  FILE-INFO:FILE-NAME = fil.
  IF INDEX(FILE-INFO:FILE-TYPE,"D") > 0 OR
    SUBSTRING(fil,LENGTH(fil),1,"CHARACTER":U) = "{&SLASH}" THEN DO:
    MESSAGE "The file name entered is invalid." VIEW-AS ALERT-BOX ERROR.
    APPLY "ENTRY" TO user_env[2].
    RETURN NO-APPLY.
  END.

  RUN prodict/misc/osprefix.p
    ( INPUT  fil,
      OUTPUT prefix,
      OUTPUT basename
      ).
  if basename = fil then assign fil = "./" + fil.
  
  IF io-file AND (SEARCH(fil) <> ?) THEN DO:
    answer = FALSE.
    MESSAGE "A file already exists with the name:" SKIP fil SKIP(1) "Overwrite?"
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer.
    IF NOT answer THEN 
    DO:
      APPLY "ENTRY" TO user_env[2] IN FRAME write-dump-file.
      RETURN NO-APPLY.
    END.
  END.

  IF inclob:SCREEN-VALUE IN FRAME write-dump-file = "no" THEN
      ASSIGN user_env[31] = " NO-LOBS"
             user_env[30] = "".
  ELSE
      ASSIGN user_env[31] = ""
             user_env[30] = user_env[30]:SCREEN-VALUE IN FRAME write-dump-file.
END.

ON GO OF FRAME write-dump-dir
DO:
  DEFINE VAR dir   AS CHAR    NO-UNDO.
  DEFINE VAR exist AS LOGICAL NO-UNDO.
  DEFINE VAR fil   AS CHAR    NO-UNDO.
  DEFINE VAR i     AS INTEGER NO-UNDO.

  assign
    dir     = user_env[2]:SCREEN-VALUE IN FRAME write-dump-dir
    exist   = false
    io-mapc = io-mapc:SCREEN-VALUE. /*To cover GUI case where not in UPDATE*/

  if dir = "" then assign dir = "./".
  
  DO i = 1 to NUM-ENTRIES(user_env[1])
    WHILE NOT exist:
    ASSIGN fil = dir + ENTRY(i,user_env[1]) + ".d".
    IF (SEARCH(fil) <> ?) THEN ASSIGN exist = true.
  END.
    
  IF exist THEN DO:
    answer = FALSE.
    MESSAGE "One or more of the files already exist in this directory." SKIP 
            "Overwrite them?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer.
    IF NOT answer THEN 
    DO:
      APPLY "ENTRY" TO user_env[2] IN FRAME write-dump-dir.
      RETURN NO-APPLY.
    END.
  END.

   IF inclob:SCREEN-VALUE IN FRAME write-dump-dir = "no" THEN
      ASSIGN user_env[31] = " NO-LOBS"
             user_env[30] = "".
  ELSE
      ASSIGN user_env[31] = ""
             user_env[30] = user_env[30]:SCREEN-VALUE IN FRAME write-dump-dir.
END.

/*----- ON WINDOW-CLOSE -----*/
on WINDOW-CLOSE of frame write-output-file
   apply "END-ERROR" to frame write-output-file.
on WINDOW-CLOSE of frame write-boutput-file
   apply "END-ERROR" to frame write-boutput-file.
on WINDOW-CLOSE of frame write-dump-file
   apply "END-ERROR" to frame write-dump-file.
on WINDOW-CLOSE of frame write-dump-dir
   apply "END-ERROR" to frame write-dump-dir.

/*----- LEAVE of fill-ins: trim blanks the user may have typed in filenames---*/
ON LEAVE OF user_env[2] in frame write-output-file
   user_env[2]:screen-value in frame write-output-file = 
	TRIM(user_env[2]:screen-value in frame write-output-file).

ON LEAVE OF user_env[2] in frame write-boutput-file
   user_env[2]:screen-value in frame write-boutput-file = 
	TRIM(user_env[2]:screen-value in frame write-boutput-file).

ON LEAVE OF user_env[2] in frame write-dump-file
   user_env[2]:screen-value in frame write-dump-file = 
	TRIM(user_env[2]:screen-value in frame write-dump-file).

ON LEAVE OF user_env[2] in frame write-dump-dir DO:
  user_env[2]:screen-value in frame write-dump-dir = 
	TRIM(user_env[2]:screen-value in frame write-dump-dir).
  IF user_env[2]:screen-value in frame write-dump-dir <> "" THEN DO:
    ASSIGN FILE-INFO:FILE-NAME = user_env[2]:screen-value in frame write-dump-dir .
    IF SUBSTRING(FILE-INFO:FILE-TYPE,1,1) <> "D" THEN DO:
      MESSAGE FILE-INFO:FILE-NAME "is not a directory or can not be found" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
    END.
  END.
END.

ON LEAVE OF user_env[30] in frame write-dump-file DO:
  user_env[30]:screen-value in frame write-dump-file = 
	TRIM(user_env[30]:screen-value in frame write-dump-file).
  IF user_env[30]:screen-value in frame write-dump-file <> "" THEN DO:
    ASSIGN FILE-INFO:FILE-NAME = user_env[30]:screen-value in frame write-dump-file .
    IF SUBSTRING(FILE-INFO:FILE-TYPE,1,1) <> "D" THEN DO:
      MESSAGE FILE-INFO:FILE-NAME "is not a directory or can not be found" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
    END.
  END.
END.

ON LEAVE OF user_env[30] in frame write-dump-dir DO:
   user_env[30]:screen-value in frame write-dump-dir = 
	TRIM(user_env[30]:screen-value in frame write-dump-dir).
   IF user_env[30]:screen-value in frame write-dump-dir <> "" THEN DO:
    ASSIGN FILE-INFO:FILE-NAME = user_env[30]:screen-value in frame write-dump-dir .
    IF SUBSTRING(FILE-INFO:FILE-TYPE,1,1) <> "D" THEN DO:
      MESSAGE FILE-INFO:FILE-NAME "is not a directory or can not be found" VIEW-AS ALERT-BOX ERROR.
      RETURN NO-APPLY.
    END.
  END.
END.

ON VALUE-CHANGED OF inclob IN FRAME write-boutput-file DO:
  IF inclob:SCREEN-VALUE IN FRAME write-boutput-file = "no" THEN
    ASSIGN user_env[30]:SENSITIVE IN FRAME write-boutput-file = FALSE
           user_env[30]:SCREEN-VALUE IN FRAME write-boutput-file = ""
           user_env[30] = "".
  ELSE
    user_env[30]:SENSITIVE IN FRAME write-boutput-file = TRUE.
END.

ON VALUE-CHANGED OF inclob IN FRAME write-dump-file 
DO:
    IF SELF:screen-value = "yes" THEN
      ASSIGN user_env[30]:sensitive in frame write-dump-file = YES
             s_res = user_env[30]:MOVE-AFTER-TAB-ITEM(inclob:HANDLE).
    ELSE
     ASSIGN user_env[30]:SENSITIVE IN FRAME write-dump-file = NO.            

   &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
     IF SELF:screen-value = "yes" THEN
       ASSIGN btn_dir:SENSITIVE IN FRAME write-dump-file = YES
              s_res = btn_dir:MOVE-AFTER-TAB-ITEM(user_env[30]:HANDLE).
     ELSE 
       ASSIGN btn_dir:SENSITIVE IN FRAME write-dump-file = NO.
   &ENDIF
END.

ON VALUE-CHANGED OF inclob IN FRAME write-dump-dir 
DO:
    IF SELF:screen-value = "yes" THEN
      ASSIGN user_env[30]:sensitive in frame write-dump-dir = YES
             s_res = user_env[30]:MOVE-AFTER-TAB-ITEM(inclob:HANDLE).           
    ELSE 
     ASSIGN user_env[30]:SENSITIVE IN FRAME write-dump-dir = NO.
            
   &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
     IF SELF:screen-value = "yes" THEN
       ASSIGN btn_dir:SENSITIVE IN FRAME write-dump-dir = YES
              s_res = btn_dir:MOVE-AFTER-TAB-ITEM(user_env[30]:HANDLE).
     ELSE
       ASSIGN btn_dir:SENSITIVE IN FRAME write-dump-dir = NO.
   &ENDIF
END.

/* code-page-stuff    <hutegger> 94/02 */
  
{prodict/user/usrdump1.i
  &frame    = "write-dump-dir"
  &variable = "user_env[5]"
  }  /* checks if user_env[5] contains convertable code-page */
  
{prodict/user/usrdump1.i
  &frame    = "write-dump-file"
  &variable = "user_env[5]"
  }  /* checks if user_env[5] contains convertable code-page */
  
{prodict/user/usrdump1.i
  &frame    = "write-output-file"
  &variable = "user_env[5]"
  }  /* checks if user_env[5] contains convertable code-page */
  
 {prodict/user/usrdump1.i
  &frame    = "write-boutput-file"
  &variable = "user_env[5]"
  }  /* checks if user_env[5] contains convertable code-page */ 
  
/*----- HIT of FILE BUTTON -----*/
ON CHOOSE OF btn_File in frame write-output-file DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT user_env[2]:handle in frame write-output-file /*Fillin*/,
	INPUT "Find Output File"  /*Title*/,
	INPUT ""                 /*Filter*/,
	INPUT no                 /*Must exist*/).
END.
ON CHOOSE OF btn_File in frame write-boutput-file DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT user_env[2]:handle in frame write-boutput-file /*Fillin*/,
	INPUT "Find Output File"  /*Title*/,
	INPUT ""                 /*Filter*/,
	INPUT no                 /*Must exist*/).
END.

ON CHOOSE OF btn_File in frame write-dump-file DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT user_env[2]:handle in frame write-dump-file /*Fillin*/,
	INPUT "Find Output File"  /*Title*/,
	INPUT ""                 /*Filter*/,
	INPUT no                 /*Must exist*/).
END.

ON CHOOSE OF btn_File in frame write-def-file DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT user_env[2]:handle in frame write-def-file /*Fillin*/,
	INPUT "Find Output File"  /*Title*/,
	INPUT ""                 /*Filter*/,
	INPUT no                 /*Must exist*/).
END.

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN  

ON VALUE-CHANGED OF io-mapl IN FRAME write-dump-file DO:
   DEFINE VARIABLE dummyl AS LOGICAL NO-UNDO.

   IF io-mapl:SCREEN-VALUE = "1" THEN DO:
	io-mapc:SENSITIVE = FALSE.
	io-mapc:SCREEN-VALUE = "".
   END.
   ELSE DO:
	io-mapc = "".
	io-mapc:SENSITIVE = TRUE.
	dummyl = io-mapc:MOVE-AFTER-TAB-ITEM(io-mapl:HANDLE).
   END.
END.
ON VALUE-CHANGED OF io-mapl IN FRAME write-dump-dir DO:
   DEFINE VARIABLE dummyl AS LOGICAL NO-UNDO.

   IF io-mapl:SCREEN-VALUE = "1" THEN DO:
	io-mapc:SENSITIVE = FALSE.
	io-mapc:SCREEN-VALUE = "".
   END.
   ELSE DO:
	io-mapc = "".
	io-mapc:SENSITIVE = TRUE.
	dummyl = io-mapc:MOVE-AFTER-TAB-ITEM(io-mapl:HANDLE).
   END.
END.
&ENDIF
/*============================Mainline code===============================*/

ASSIGN
&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 
  io-mapc  = "NO-MAP"
&ENDIF
  class    = SUBSTRING(user_env[9],1,1)
  io-file  = TRUE
  is-all   = (user_env[1] = "ALL")
  is-some  = (user_env[1] MATCHES "*,*")
  is-one   = NOT is-all AND NOT is-some
  prefix   = ""
  dmp-rpos:HIDDEN IN FRAME write-output-file = 
  (IF class = "d" THEN FALSE ELSE TRUE).

/* Set default value for codepage gfs:94-04-28-043 */

IF SESSION:CHARSET = "UNDEFINED" THEN 
DO:
    FIND FIRST _db NO-LOCK.
    ASSIGN user_env[5]  = _db._db-xl-name. /* db codepage */
END.
ELSE IF SESSION:STREAM  = "UNDEFINED" THEN
    ASSIGN user_env[5]  = SESSION:CHARSET.
ELSE ASSIGN user_env[5] = SESSION:STREAM.
ASSIGN user_env[5]:SENSITIVE = true.

IF user_env[1] <> "" AND NOT is-all AND NOT is-some THEN DO FOR _File:
  FIND _File WHERE _Db-recid = drec_db AND _File-name = user_env[1]
               AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN" ).
  dump-as = (IF _File._Dump-name = ?
	    THEN SUBSTRING(_File._File-name,1,8)
	    ELSE _File._Dump-name).
END.

/*----------------------------------------------*/ /* DUMP FILE DEFINITIONS */
IF class = "d" OR class = "4" THEN DO FOR _File:
  FIND _File WHERE _File._File-name = "_Db"
               AND _File._Owner = "PUB".
  IF NOT CAN-DO(_Can-read,USERID("DICTDB")) THEN msg-num = 3.
  FIND _File WHERE _File._File-name = "_File"
               AND _File._Owner = "PUB".
  IF NOT CAN-DO(_Can-read,USERID("DICTDB")) THEN msg-num = 3.
  FIND _File WHERE _File._File-name = "_Field"
               AND _File._Owner = "PUB".
  IF NOT CAN-DO(_Can-read,USERID("DICTDB")) THEN msg-num = 3.
  FIND _File where _File._File-name = "_Index"
               AND _File._Owner = "PUB".
  IF NOT CAN-DO(_Can-read,USERID("DICTDB")) THEN msg-num = 3.
  IF is-all OR is-some 
   then do:
    if PDBNAME(user_dbname) <> ?
     THEN RUN "prodict/misc/osprefix.p"
             ( INPUT PDBNAME(user_dbname),
               OUTPUT trash,
               OUTPUT dump-as
               ).
      else assign dump-as = user_dbname.
     end.          
  ASSIGN
    user_env[2] = (IF class = "4" THEN "_trgdefs.df"
		  ELSE prefix + dump-as + ".df")
    io-title    = (IF class = "4" THEN "Dump Database Triggers for "
		  ELSE "Dump Data Definitions for ")
		+ (IF is-all THEN "All Tables"
		  ELSE IF is-some THEN "Some Tables"
		  ELSE "Table" + ' "' + user_env[1] + '"').

END.

/*--------------------------------------------*/ /* DUMP DATA FILE CONTENTS */
ELSE IF class = "f" THEN DO FOR _File:

  nodump = "u".
  { prodict/dictgate.i &action=undumpload
    &dbtype=user_dbtype &dbrec=drec_db &output=nodump
  }

  FIND _File "_File".
  IF NOT CAN-DO(_Can-read,USERID("DICTDB")) THEN msg-num = 3.
  ASSIGN
    user_env[2] = prefix + (IF is-all OR is-some THEN "" ELSE dump-as + ".d")
    io-file     = NOT is-all AND NOT is-some
    io-title    = "Dump Data Contents for "
		+ (IF is-all THEN "All Tables"
		  ELSE IF is-some THEN "Some Tables"
		  ELSE "Table" + ' "' + user_env[1] + '"')
    base        = (IF is-one OR is-some THEN user_env[1] ELSE "")
    user_env[1] = ""
    comma       = ""
    i           = 1.

  /* If user had selected ALL, fill base array with list of files.  
     Otherwise, it is already set to file list.
  */
  IF is-all THEN FOR EACH _File
    WHERE _File._File-number > 0
      AND (IF NOT fHidden THEN NOT _File._Hidden ELSE _File._File-Number > 0)
      AND _File._Tbl-Type <> "V"
      AND _File._Db-recid = drec_db
      AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN" )
      AND CAN-DO(_File._Can-read,USERID(user_dbname))
      AND CAN-DO(_File._Can-dump,USERID(user_dbname))
      AND (nodump = "" OR NOT CAN-DO(nodump,_File._For-type))
    BY _File._File-name:
    base = base + (IF base = "" THEN "" ELSE ",") + _File._File-name.
  END.

  /* Run through the file list and cull out the ones that the user
     is not allowed to dump for some reason.
  */
  user_env[4] = "".
  DO i = 1 TO NUM-ENTRIES(base):
    err = ?.
    dis_trig = "y".
    FIND _File
      WHERE _File._Db-recid = drec_db AND _File._File-name = ENTRY(i,base)
        AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN" ).
    IF NOT CAN-DO(_File._Can-read,USERID(user_dbname)) OR 
       NOT CAN-DO(_File._Can-dump,USERID(user_dbname)) THEN
      err = _File._File-name
	+ " will not be dumped due to insufficient privileges.".
    ELSE 
    IF nodump <> "" AND CAN-DO(nodump,_File._For-type) THEN
      err = "".
	/*SUBSTITUTE("&1 is a &2 &3 and cannot be dumped.",
	  _File._File-name,user_dbtype,_File._For-type).*/
    ELSE DO:
      {prodict/dump/dtrigchk.i &OK = answer}
      IF NOT answer THEN DO:
	 MESSAGE "You do not have privileges to dump table" _File._File-name 
		 SKIP
		 "with triggers disabled.  Do you want to dump this table" SKIP
		 "anyway even though the FIND trigger will fire?"
		 VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL UPDATE answer.
	 IF answer = no THEN
	    err = "".  /* don't do this table but no more messages */
	 ELSE IF answer = yes THEN DO:
	    err = ?.   /* include this table in dump */
	    dis_trig = "n".
	 END.
	 ELSE DO:    /* cancel the dump operation */
	    user_path = "".
	    RETURN.
	 END.
      END.
    END.

    IF err = ? THEN
      ASSIGN
	user_env[1] = user_env[1] + comma + _File._File-name
	user_env[4] = user_env[4] + comma + dis_trig
	comma       = ",".
    ELSE IF err <> "" THEN DO:
      answer = TRUE.
      IF NUM-ENTRIES(base) = 1 THEN DO:
         MESSAGE err VIEW-AS ALERT-BOX ERROR BUTTONS OK.
         user_path = "".
         RETURN.
      END.
      ELSE DO:
         MESSAGE err SKIP "Do you want to continue?"
	    VIEW-AS ALERT-BOX ERROR BUTTONS YES-NO UPDATE answer.
         IF answer = FALSE THEN DO:
	    user_path = "".
	    return.
         END.
      END.
    END.
  END.  /* end of DO i = 2 TO NUM-ENTRIES(base) */

  /* subsequent removal of files changed from many to one, so reset ui stuff */
  IF (is-some OR is-all) AND NUM-ENTRIES(user_env[1]) = 1 THEN DO:
    FIND _File
      WHERE _File._Db-recid = drec_db
	AND _File._File-name = user_env[1]
      AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN" ).
    ASSIGN
      is-some     = FALSE
      is-all      = FALSE
      is-one      = TRUE
      user_env[2] = prefix + (IF _File._Dump-name = ?
		    THEN _File._File-name ELSE _File._Dump-name)
		  + ".d"
      io-file     = TRUE
      io-title    = "Dump Data Contents for Table ~"" + user_env[1] + "~""
      base        = user_env[1].
  END.


END.

/*-----------------------------------------------------*/ /* DUMP SEQ DEFS */
ELSE IF class = "s" THEN DO FOR _File:
  FIND _File "_Sequence".
  IF NOT CAN-DO(_Can-read,USERID("DICTDB")) THEN msg-num = 3.
  IF user_dbtype <> "PROGRESS" THEN msg-num = 1.
  ASSIGN
    user_env[2] = prefix + "_seqdefs.df"
    io-title    = "Dump Sequence Definitions".
END.

/*-----------------------------------------------------*/ /* DUMP SEQ VALS */
ELSE IF class = "k" THEN DO FOR _File:
  FIND _File "_Sequence".
  IF NOT CAN-DO(_Can-read,USERID("DICTDB")) THEN msg-num = 3.
  IF user_dbtype <> "PROGRESS" THEN msg-num = 1.
  ASSIGN
    user_env[2] = prefix + "_seqvals.d"
    io-title    = "Dump Sequence Current Values".
END.

/*------------------------------------------*/ /* DUMP AUTO-CONNECT RECORDS */
ELSE IF class = "a" THEN DO FOR _File:
  FIND _File "_Db".
  IF NOT CAN-DO(_Can-read,USERID("DICTDB")) THEN msg-num = 3.
  IF user_dbtype <> "PROGRESS" THEN msg-num = 1.
  ASSIGN
    user_env[2] = prefix + "_auto.df"
    io-title    = "Dump Auto-Connect Records".
END.

/*------------------------------------------*/ /* DUMP COLLATION stuff */
ELSE IF class = "c" THEN DO FOR _File:
  FIND _File "_Db".
  IF NOT CAN-DO(_Can-read,USERID("DICTDB")) THEN msg-num = 3.
  IF user_dbtype <> "PROGRESS" THEN msg-num = 1.
  ASSIGN
    user_env[2] = prefix + "_tran.df"
    io-title    = "Dump Collation Tables".
END.

/*--------------------------------------------*/ /* DUMP USER FILE CONTENTS */
ELSE IF class = "u" THEN DO FOR _File:
  FIND _File "_User".
  IF NOT CAN-DO(_Can-read,USERID("DICTDB")) THEN msg-num = 3.
  IF user_dbtype <> "PROGRESS" THEN msg-num = 1.
  ASSIGN
    user_env[2] = prefix + "_user.d"
    io-title    = "Dump User Table Contents".
END.

/*--------------------------------------------*/ /* DUMP VIEW FILE CONTENTS */
ELSE IF class = "v" THEN DO FOR _File:
  FIND _File "_View".
  IF NOT CAN-DO(_Can-read,USERID("DICTDB")) THEN msg-num = 3.
  IF user_dbtype <> "PROGRESS" THEN msg-num = 2.
  ASSIGN
    user_env[2] = prefix + "_view.d"
    io-title    = "Dump SQL Views".
END.

/*---------------------------------*/ /* DUMP FILE DEFINITIONS IN V5 FORMAT */
ELSE IF class = "5" THEN DO FOR _File:
  FIND _File "_File".
  IF NOT CAN-DO(_File._Can-read,USERID("DICTDB")) THEN msg-num = 3.
  FIND _File "_Field".
  IF NOT CAN-DO(_File._Can-read,USERID("DICTDB")) THEN msg-num = 3.
  FIND _File "_Index".
  IF NOT CAN-DO(_File._Can-read,USERID("DICTDB")) THEN msg-num = 3.
  IF user_dbtype <> "PROGRESS" THEN msg-num = 4.
  IF is-all OR is-some  
   then do:
    if PDBNAME(user_dbname) <> ?
     THEN RUN "prodict/misc/osprefix.p"
             ( INPUT PDBNAME(user_dbname),
               OUTPUT trash,
               OUTPUT dump-as
               ).
      else assign dump-as = user_dbname.
     end.          
  ASSIGN
    user_env[2] = prefix + dump-as + ".df"
    io-title    = "Dump Definitions in V5 Format for "
		+ (IF is-all THEN "All Tables"
		  ELSE IF is-some THEN "Some Tables"
		  ELSE "Table" + ' "' + user_env[1] + '"').
END.
/*-------------------------------------*/ /* MAKE BULKLOAD DESCRIPTION FILE */
ELSE IF class = "b" THEN DO FOR _File:
  FIND _File "_File".
  IF NOT CAN-DO(_File._Can-read,USERID("DICTDB")) THEN msg-num = 3.
  FIND _File "_Field".
  IF NOT CAN-DO(_File._Can-read,USERID("DICTDB")) THEN msg-num = 3.
  FIND _File "_Index".
  IF NOT CAN-DO(_File._Can-read,USERID("DICTDB")) THEN msg-num = 3.
  IF user_dbtype <> "PROGRESS" THEN msg-num = 5.
  IF is-all OR is-some  
   then do:
    if PDBNAME(user_dbname) <> ?
      THEN RUN "prodict/misc/osprefix.p"
              ( INPUT PDBNAME(user_dbname),
              OUTPUT trash,
              OUTPUT dump-as
              ).
      else assign dump-as = user_dbname.
     end.          
  ASSIGN
    user_env[2] = prefix + dump-as + ".fd"
    io-title    = "Make Bulk Load Description File for "
		+ (IF is-all THEN "All Tables"
		  ELSE IF is-some THEN "Some Tables"
		  ELSE "Table" + ' "' + user_env[1] + '"').
END.

IF msg-num > 0 THEN DO:
  MESSAGE (
    IF      msg-num = 1 THEN
      "Cannot dump User information from a non-PROGRESS database."
    ELSE IF msg-num = 2 THEN
      "Cannot dump View information from a non-PROGRESS database."
    ELSE IF msg-num = 3 THEN
      "You do not have permission to use this option."
    ELSE IF msg-num = 4 THEN
      "You can only dump definitions in V5 format for PROGRESS databases."
    ELSE /*IF msg-num = 5 THEN*/
      "You can only create bulkload description files for PROGRESS databases.")
    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  user_path = "".
  RETURN.
END.

/* Adjust the graphical rectangle and the ok and cancel buttons */
IF class = "f" THEN DO:
   IF io-file THEN DO:
     {adecomm/okrun.i  
	&FRAME  = "FRAME write-dump-file" 
	&BOX    = "rect_Btns"
	&OK     = "btn_OK" 
	{&CAN_BTN}
	{&HLP_BTN}
     }
   END.
   ELSE DO:
     {adecomm/okrun.i  
	&FRAME  = "FRAME write-dump-dir" 
	&BOX    = "rect_Btns"
	&OK     = "btn_OK" 
	{&CAN_BTN}
	{&HLP_BTN}
     }
   END.
END.
ELSE DO:
  IF class <> "b" THEN DO:
    {adecomm/okrun.i  
       &FRAME  = "FRAME write-output-file" 
       &BOX    = "rect_Btns"
       &OK     = "btn_OK" 
       {&CAN_BTN}
       {&HLP_BTN}
    }
  END.
  ELSE DO:
    {adecomm/okrun.i  
     &FRAME  = "FRAME write-boutput-file" 
     &BOX    = "rect_Btns"
     &OK     = "btn_OK" 
     {&CAN_BTN}
     {&HLP_BTN}
    }
  END.
END.

IF    class = "5"  /* version 5 .df */
   or class = "k"  /* sequence def's */
   or class = "s"  /* sequence-values */
   THEN DO:
     {adecomm/okrun.i  
       &FRAME  = "FRAME write-def-file" 
       &BOX    = "rect_Btns"
       &OK     = "btn_OK" 
       {&CAN_BTN}
       {&HLP_BTN}
     }  
END.
 
PAUSE 0.
user_env[3] = "".

/* If name contains the .db, remove it */
IF INDEX(user_env[2],".db") > 0 THEN
	SUBSTRING(user_env[2],INDEX(user_env[2],".db"),3,"RAW") = "".

DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
  IF  class = "5"  /* version 5 .df */
   or class = "k"  /* sequence def's */
   or class = "s"   /* sequence-values */   
    THEN UPDATE user_env[2] 
	   btn_File      
	   user_env[5]
	   btn_OK 
	   btn_Cancel
	   {&HLP_BTN_NAME}
	   WITH FRAME write-def-file.
  ELSE IF class = "b" THEN
      UPDATE UNLESS-HIDDEN user_env[2] 
	   btn_File
       inclob
       user_env[30]
       &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN  
        btn_dir
       &ENDIF
	   user_env[5] 
	   btn_OK 
	   btn_Cancel
	   {&HLP_BTN_NAME}
	   WITH FRAME write-boutput-file.
  ELSE IF class <> "f" 
    THEN UPDATE UNLESS-HIDDEN user_env[2] 
	   btn_File    
	   user_env[5] 
	   dmp-rpos
	   btn_OK 
	   btn_Cancel
	   {&HLP_BTN_NAME}
	   WITH FRAME write-output-file.
  
  ELSE DO:
    IF io-file THEN
       UPDATE user_env[2] 
	   btn_File   
       inclob
       user_env[30]
	   &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN  
        btn_dir
	    io-mapl
	   &ELSE
	    io-mapc 
	   &ENDIF
	   user_env[5] 
           btn_OK 
	   btn_Cancel
	   {&HLP_BTN_NAME}
	   WITH FRAME write-dump-file.
    ELSE
       UPDATE user_env[2] 
             &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN  
                btn_dir2
             &ENDIF
             inclob
             user_env[30]
	         &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN  
               btn_dir
	           io-mapl 
	         &ELSE
	           io-mapc 
	         &ENDIF
	         user_env[5] btn_OK btn_Cancel {&HLP_BTN_NAME}
	   WITH FRAME write-dump-dir.
    
    &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN  
      CASE io-mapl:
	  WHEN 1 THEN user_env[3] = "NO-MAP".
	  WHEN 2 THEN user_env[3] = io-mapc.
      END CASE.
    &ELSE
      IF io-mapc <> "" THEN user_env[3] = io-mapc.
    &ENDIF
  END.
  IF NOT io-file THEN
    RUN "prodict/misc/ostodir.p" (INPUT-OUTPUT user_env[2]).

  { prodict/dictnext.i trash }
  canned = FALSE.
END.

HIDE MESSAGE NO-PAUSE.

HIDE FRAME write-output-file NO-PAUSE.
HIDE FRAME write-dump-file NO-PAUSE.
HIDE FRAME write-dump-dir NO-PAUSE.
IF canned THEN
  user_path = "".
RETURN.


