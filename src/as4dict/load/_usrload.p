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

/* userload - user interface and defaults setup for loading */
/* Taken from prodict/user/_usrload.p                       */
/* Initial creation:  May 8, 1995  NHorn                    
       Modification:
            03/21/97 Added Object Library support (user_env[34]) 
                     D. McMann 97-01-20-020
            10/21/97 Added support for RPG Length Names (user_env[29])
                     D. McMann
            07/14/98 Removed security check for p__view not needed
                     D. McMann 
            01/12/99 Added allow_null switch D. McMann        

*/

{ as4dict/dictvar.i shared}
{ as4dict/dump/dumpvar.i shared}

/*
IN:
  user_env[1] = "ALL" or comma-separated list of files
  user_env[9] = type of load (e.g. .df or .d)
                "d" = load file definitions
                "f" = load data file contents
                "h" = hide message, puts up completed message and returns
                "k" = load sequence values
                "u" = load user file contents
                "v" = load view file contents
                "4" = AS/400 definitions
                "4t" = AS/400 trigger definitions
                "s" = load sequence def's

OUT:
  user_env[1] = same as IN
  user_env[2] = physical file or directry name for some input
  user_env[4] = "y" or "n" - stop on first error (if class = "d","4" or "s")
              = error% (if class = "f")
  user_env[5] = comma separated list of "y" (yes) or "n" (no) which
                corresponds to file list in user_env[1], indicating for each,
                whether triggers should be disabled when the load is done.
                (only used for load data file contents, "f").
  user_env[8] = dbname (if class = "d" or "4" or "s")
  user_env[10]= user specified code page
  user_env[29] = whether to do RPG length Names

*/

DEFINE VARIABLE answer           AS LOGICAL        NO-UNDO.
DEFINE VARIABLE canned           AS LOGICAL        NO-UNDO INITIAL TRUE.
DEFINE VARIABLE base             AS CHARACTER      NO-UNDO.
DEFINE VARIABLE class            AS CHARACTER      NO-UNDO.
DEFINE VARIABLE comma            AS CHARACTER      NO-UNDO.
DEFINE VARIABLE err              AS CHARACTER      NO-UNDO.
DEFINE VARIABLE i                AS INTEGER        NO-UNDO.
DEFINE VARIABLE io-file          AS LOGICAL        NO-UNDO.
DEFINE VARIABLE io-frame         AS CHARACTER      NO-UNDO.
DEFINE VARIABLE io-title         AS CHARACTER      NO-UNDO.
DEFINE VARIABLE is-all           AS LOGICAL        NO-UNDO.
DEFINE VARIABLE is-one           AS LOGICAL        NO-UNDO.
DEFINE VARIABLE is-some          AS LOGICAL        NO-UNDO.
DEFINE VARIABLE stop_flg         AS LOGICAL        NO-UNDO.
DEFINE VARIABLE Errors_to_File   AS LOGICAL        NO-UNDO.
DEFINE VARIABLE Errors_to_Screen AS LOGICAL        NO-UNDO.
DEFINE VARIABLE RPG_Names        AS LOGICAL        NO-UNDO.
DEFINE VARIABLE allow_null       AS LOGICAL        NO-UNDO INITIAL TRUE.
DEFINE VARIABLE msg-num          AS INTEGER        NO-UNDO INITIAL 0.
DEFINE VARIABLE noload           AS CHARACTER      NO-UNDO.
DEFINE VARIABLE prefix           AS CHARACTER      NO-UNDO.
DEFINE VARIABLE trash            AS CHARACTER      NO-UNDO.
DEFINE VARIABLE dis_trig         AS CHARACTER      NO-UNDO.
DEFINE VARIABLE codepage         AS CHARACTER      NO-UNDO FORMAT "X(20)".
DEFINE VARIABLE lvar             AS CHAR EXTENT 10 NO-UNDO.
DEFINE VARIABLE lvar#            AS INTEGER        NO-UNDO. 

{prodict/misc/filesbtn.i}

/* standard form */
FORM SKIP({&TFM_WID})
  user_env[2] {&STDPH_FILL} FORMAT "x(80)" AT 2 VIEW-AS FILL-IN SIZE 40 BY 1
         LABEL "Input File"
  btn_File SKIP ({&VM_WIDG})
  {prodict/user/userbtns.i}
  WITH FRAME read-input
  SIDE-LABELS NO-ATTR-SPACE CENTERED 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".

&IF "{&WINDOW-SYSTEM}" BEGINS "MS-Win" &THEN
  &GLOBAL-DEFINE LINEUP 25
  &GLOBAL-DEFINE FILLCH 67
&ELSEIF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN
  &GLOBAL-DEFINE LINEUP 25
  &GLOBAL-DEFINE FILLCH 69
&ELSE
  &GLOBAL-DEFINE LINEUP 25
&ENDIF

/* form for .df file input */
FORM SKIP({&TFM_WID})
  user_env[2] {&STDPH_FILL} FORMAT "x(80)" VIEW-AS FILL-IN SIZE 40 BY 1
         LABEL "Input File" COLON {&LINEUP}
   btn_File  SKIP ({&VM_WIDG})
  user_env[34] {&STDPH_FILL} FORMAT "x(10)" VIEW-AS FILL-IN SIZE 40 BY 1
         LABEL "Database Object Library" COLON {&LINEUP} SKIP
   &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN  
    stop_flg VIEW-AS TOGGLE-BOX LABEL "Stop If Error Found in Definition"
        COLON {&LINEUP} SKIP({&VM_WIDG})
    errors_to_file VIEW-AS TOGGLE-BOX LABEL "Write Errors to Output File"
        COLON {&LINEUP} SKIP({&VM_WIDG})
    errors_to_screen VIEW-AS TOGGLE-BOX LABEL "Display Errors on Screen"
            COLON {&LINEUP} SKIP({&VM_WIDG}) 
    RPG_Names VIEW-AS TOGGLE-BOX LABEL "Create RPG/400 Length Names"
            COLON {&LINEUP} SKIP({&VM_WIDG}) 
    allow_null VIEW-AS TOGGLE-BOX LABEL "Allow SQL Null"
            COLON  {&LINEUP} SKIP({&VM_WIDG})            
  &ELSE
    stop_flg COLON {&LINEUP} LABEL "Stop On Error"
    "  (Stop Loading If Error Found In Definition)" SKIP({&VM_WIDG})
    RPG_Names COLON {&LINEUP} LABEL "RPG Length"
    "  (Generate RPG Length Names)" SKIP({&VM_WIDG})
    allow_null COLON {&LINEUP} LABEL "Allow SQL Null"
    "  (Allow SQL Nulls for characters)" SKIP({&VM_WIDG})
  &ENDIF
   "The Database Object Library is where the objects will be created."
      AT 10 VIEW-AS TEXT SKIP
  "Warning: If a .df file was generated by an incremental dump it"
      AT 10 VIEW-AS TEXT SKIP
  "may contain DROP statements which will cause data to be deleted."
      AT 10 VIEW-AS TEXT SKIP
  "Please refer to the System Administration Guide."
      AT 10 VIEW-AS TEXT 
  {prodict/user/userbtns.i}
  WITH FRAME read-df
  SIDE-LABELS NO-ATTR-SPACE CENTERED 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".

/* form for .d file input */
&GLOBAL-DEFINE DFILE-SPEECH   "Specify an acceptable error percentage.  When this limit is reached,"                                       AT 2     VIEW-AS TEXT      SKIP  "loading will stop.  Enter 0 if any error should stop the load; enter"                                       AT 2     VIEW-AS TEXT      SKIP  "100 if the load should not stop for any error"                                       AT 2     VIEW-AS TEXT SKIP ({&VM_WIDG})

FORM SKIP({&TFM_WID})
  user_env[2] {&STDPH_FILL} FORMAT "x(80)" AT 2 VIEW-AS FILL-IN SIZE 45 BY 1
         LABEL "Input File"
  btn_File  SKIP ({&VM_WIDG})
  {&DFILE-SPEECH}
  "Acceptable Error Percentage:"             AT 2
   i {&STDPH_FILL} FORMAT ">>9" NO-LABEL                     
      VALIDATE(i >= 0 AND i <= 100,
      "Percentage must be between 0 and 100 inclusive.")
  {prodict/user/userbtns.i}
  WITH FRAME read-d-file
  SIDE-LABELS NO-ATTR-SPACE CENTERED 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".


FORM SKIP({&TFM_WID})
  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
    "Input Directory (if different from current directory):" VIEW-AS TEXT AT 2
     user_env[2] {&STDPH_FILL} FORMAT "x(80)" AT 2 VIEW-AS FILL-IN 
          SIZE {&FILLCH} BY 1 NO-LABEL SKIP({&VM_WIDG})
  &ELSE
     user_env[2] {&STDPH_FILL} FORMAT "x(80)" AT 2 VIEW-AS FILL-IN SIZE 50 BY 1
                LABEL "Input Directory" SKIP
    "(Leave blank for current directory)" VIEW-AS TEXT AT 19 SKIP ({&VM_WIDG})
  &ENDIF
  {&DFILE-SPEECH}
  "Acceptable Error Percentage:"             AT 2
   i {&STDPH_FILL} FORMAT ">>9" NO-LABEL                     
      VALIDATE(i >= 0 AND i <= 100,
      "Percentage must be between 0 and 100 inclusive.")
  {prodict/user/userbtns.i}
  WITH FRAME read-d-dir
  SIDE-LABELS NO-ATTR-SPACE CENTERED 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE " " + io-title + " ".

   FORM
      "Please enter a Code Page to use for this load." AT 2 SKIP
      codepage {&STDPH_FILL} LABEL "Code Page" AT 2
      {prodict/user/userbtns.i}
      WITH FRAME get-cp
      SIDE-LABELS NO-ATTR-SPACE CENTERED
      DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
      VIEW-AS DIALOG-BOX TITLE " Code Page ".
                             
/*===============================Triggers=================================*/

DEFINE VAR msg AS CHAR NO-UNDO INITIAL
   "Can not find a file of this name.  Try again.".

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
/*----- HELP -----*/
on HELP of frame read-input or CHOOSE of btn_Help in frame read-input
   RUN "adecomm/_adehelp.p" (INPUT "as4d", INPUT "CONTEXT", 
                             INPUT {&AS4_Load_Data_Definitions_Dlg_Box},
                             INPUT ?).

on HELP of frame read-df or CHOOSE of btn_Help in frame read-df
   RUN "adecomm/_adehelp.p" (INPUT "as4d", INPUT "CONTEXT", 
                             INPUT {&AS4_Load_Data_Definitions_Dlg_Box},
                             INPUT ?).

on HELP of frame read-d-file
   or CHOOSE of btn_Help in frame read-d-file
   RUN "adecomm/_adehelp.p" (INPUT "as4d", INPUT "CONTEXT", 
                             INPUT {&Load_Data_Contents_Dlg_Box},
                             INPUT ?).
on HELP of frame read-d-dir
   or CHOOSE of btn_Help in frame read-d-dir
   RUN "adecomm/_adehelp.p" (INPUT "as4d", INPUT "CONTEXT", 
                             INPUT {&Load_Data_Contents_Some_Dlg_Box},
                             INPUT ?).
                             
on HELP of frame get-cp or CHOOSE of btn_Help in frame get-cp
   RUN "adecomm/_adehelp.p" (INPUT "as4d", INPUT "CONTEXT", 
                             INPUT {&Code_Page_Dlg_Box},
                             INPUT ?).

&ENDIF

/*----- ON GO or OK -----*/
ON GO OF FRAME read-df
DO:
  IF io-file AND SEARCH(user_env[2]:SCREEN-VALUE IN FRAME read-df) = ? THEN DO:
    MESSAGE msg VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    APPLY "ENTRY" TO user_env[2] IN FRAME read-df.
    RETURN NO-APPLY.
  END.
  IF io-file THEN 
    user_env[2]:SCREEN-VALUE = SEARCH(user_env[2]:SCREEN-VALUE IN FRAME read-df).
  ASSIGN user_env[2] = user_env[2]:SCREEN-VALUE IN FRAME read-df.
  run verify-cp.
END.

ON GO OF FRAME read-d-file
DO:
  IF io-file AND SEARCH(user_env[2]:SCREEN-VALUE IN FRAME read-d-file) = ? 
  THEN DO:
    MESSAGE msg VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    APPLY "ENTRY" TO user_env[2] IN FRAME read-d-file.
    RETURN NO-APPLY.
  END.
  ASSIGN user_env[2] = user_env[2]:SCREEN-VALUE IN FRAME read-d-file.
  run verify-cp.
END.

ON GO OF FRAME read-d-dir
DO:
  IF io-file AND SEARCH(user_env[2]:SCREEN-VALUE IN FRAME read-d-dir) = ? 
  THEN DO:
    MESSAGE msg VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    APPLY "ENTRY" TO user_env[2] IN FRAME read-d-dir.
    RETURN NO-APPLY.
  END.
END.

ON GO OF FRAME read-input
DO:
  IF io-file AND SEARCH(user_env[2]:SCREEN-VALUE IN FRAME read-input) = ? THEN DO:
    MESSAGE msg VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    APPLY "ENTRY" TO user_env[2] IN FRAME read-input.
    RETURN NO-APPLY.
  END.
  ASSIGN user_env[2] = user_env[2]:SCREEN-VALUE IN FRAME read-input.
  run verify-cp.
END.
/*----- ON WINDOW-CLOSE -----*/
on WINDOW-CLOSE of frame read-input
   apply "END-ERROR" to frame read-input.
on WINDOW-CLOSE of frame read-df
   apply "END-ERROR" to frame read-df.
on WINDOW-CLOSE of frame read-d-file
   apply "END-ERROR" to frame read-d-file.
on WINDOW-CLOSE of frame read-d-dir
   apply "END-ERROR" to frame read-d-dir.

/*----- LEAVE of fill-ins: trim blanks the user may have typed in filenames---*/
ON LEAVE OF user_env[2] in frame read-input
   user_env[2]:screen-value in frame read-input = 
        TRIM(user_env[2]:screen-value in frame read-input).
ON LEAVE OF user_env[2] in frame read-df
   user_env[2]:screen-value in frame read-df = 
        TRIM(user_env[2]:screen-value in frame read-df).
ON LEAVE OF user_env[34] in frame read-df
   user_env[34]:screen-value in frame read-df = 
        TRIM(user_env[34]:screen-value in frame read-df).
ON LEAVE OF user_env[2] in frame read-d-file
   user_env[2]:screen-value in frame read-d-file = 
        TRIM(user_env[2]:screen-value in frame read-d-file).
ON LEAVE OF user_env[2] in frame read-d-dir
   user_env[2]:screen-value in frame read-d-dir = 
        TRIM(user_env[2]:screen-value in frame read-d-dir).

/*----- HIT of FILE BUTTON -----*/
ON CHOOSE OF btn_File in frame read-input DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT user_env[2]:handle in frame read-input /*Fillin*/,
        INPUT "Find Input File"  /*Title*/,
        INPUT ""                 /*Filter*/,
        INPUT yes                /*Must exist*/).
END.
ON CHOOSE OF btn_File in frame read-df DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT user_env[2]:handle in frame read-df /*Fillin*/,
        INPUT "Find Input File"  /*Title*/,
        INPUT ""                 /*Filter*/,
        INPUT yes                /*Must exist*/).
END.
ON CHOOSE OF btn_File in frame read-d-file DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT user_env[2]:handle in frame read-d-file /*Fillin*/,
        INPUT "Find Input File"  /*Title*/,
        INPUT ""                 /*Filter*/,
        INPUT yes                /*Must exist*/).
END.

ON VALUE-CHANGED of RPG_names in frame read-df DO:
    IF INPUT RPG_Names = TRUE THEN DO:
      MESSAGE "If the above .df file is in an AS/400 format, and you" SKIP
              "do not want the AS/400 names changed, this box should " SKIP
              "not be checked." SKIP (1)
              VIEW-AS ALERT-BOX WARNING BUTTONS OK.      
    END. 
END.              
/*============================Mainline code===============================*/
FIND FIRST as4dict.p__Db NO-LOCK.
ASSIGN user_env[34] = as4dict.p__Db.OBJECTLIB.

ASSIGN
  class    = SUBSTRING(user_env[9],1)
  io-file  = TRUE
  io-frame = ""
  is-all   = (user_env[1] = "ALL")
  is-some  = (user_env[1] MATCHES "*,*")
  is-one   = NOT is-all AND NOT is-some
  prefix   = "".
         
IF dict_rog THEN msg-num = 3. /* look but don't touch */

/*-------------------------------------------------------*/ /* Hide message */
IF class = "h" THEN DO:
   HIDE MESSAGE NO-PAUSE.
   MESSAGE "Load completed." VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
   RETURN.
END.
/*----------------------------------------------*/ /* LOAD FILE DEFINITIONS */
IF class = "d" OR class begins "4" or class = "s" THEN DO:

  ASSIGN
    base        = PDBNAME(user_dbname)
    user_env[2] = (IF class = "s" THEN "_seqdefs.df"
                  ELSE IF class = "4t" THEN "_trgdefs.df"
                  ELSE
                  ((IF base = "" OR base = ? THEN user_dbname ELSE base) 
                                                                 + ".df"))
    io-frame    = "df"
    io-title    = (IF class = "s" THEN "Load Sequence Definitions"
                   ELSE IF class = "4" THEN "Load AS/400 Definitions File"
                   ELSE IF class = "4t" THEN "Load Database Triggers"
                   ELSE "Load Data Definitions")
    user_env[4] = "n"          /* stop on first error - used by _lodsddl.p */
    user_env[8] = user_dbname  /* dbname to load into - used by _lodsddl.p */
    class = "d". /* if class was 's', reassign to run as class 'd' after 
                    input file name default (user_env[2]) */
END.

/*--------------------------------------------*/ /* LOAD DATA FILE CONTENTS */
ELSE IF class = "f" THEN DO FOR _File:

  /* read-only status is relevant only for PROGRESS-db's */
  /* schemaholders can be in read-only mode and still    */
  /* allow data to be loaded!                            */
  IF dict_rog 
    AND msg-num = 3
    AND user_dbtype <> "PROGRESS"
    THEN ASSIGN msg-num = 0. 
                                                        

  FIND _File "as4dict.p__File".
  IF NOT CAN-DO(_Can-read,USERID("as4dict")) THEN msg-num = 4.
  RELEASE _File.
  IF NOT is-all AND NOT is-some THEN
    FIND as4dict.p__File WHERE as4dict.p__file._file-number = file_num 
         AND as4dict.p__file._File-name = user_env[1].
  ASSIGN
    user_env[2] = prefix + (IF is-all OR is-some THEN "" ELSE
                  (IF as4dict.p__File._Dump-name = ?
                  THEN as4dict.p__File._File-name ELSE as4dict.p__File._Dump-name)
                + ".d")
    user_env[4] = "0"
    io-file     = NOT is-all AND NOT is-some /* read from file/dir */
    io-frame    = "d"
    io-title    = "Load Data Contents for"
                + " " + (IF is-all THEN "All Tables" /*allfiles*/
                  ELSE  IF is-some THEN "Some Tables" /*somefiles*/
                  ELSE "Table ~"" + user_env[1] + "~"")
    base        = (IF is-one OR is-some THEN user_env[1] ELSE "")
    user_env[1] = ""
    comma       = ""
    i           = 1.

  /* If user had selected ALL, fill base array with list of files.  
     Otherwise, it is already set to file list.
  */
  IF is-all THEN FOR EACH as4dict.p__File
    WHERE as4dict.p__File._File-number > 0
      AND as4dict.p__File._file-number = file_num
      AND CAN-DO(as4dict.p__File._Can-create,USERID(user_dbname))
      AND (noload = "" OR NOT CAN-DO(noload,as4dict.p__File._For-type))
    BY as4dict.p__File._File-name:
    base = base + (IF base = "" THEN "" ELSE ",") + as4dict.P__File._File-name.
  END.

  /* Run through the file list and cull out the ones that the user
     is not allowed to dump for some reason.
  */
  user_env[5] = "".
  DO i = 1 TO NUM-ENTRIES(base):
    err = ?.
    dis_trig = "y".
    FIND as4dict.p__File
      WHERE as4dict.p__file._file-number = file_num 
        AND as4dict.p__file._File-name = ENTRY(i,base).

    IF NOT CAN-DO(as4dict.p__File._Can-create,USERID(user_dbname)) THEN
      err = as4dict.p__File._File-name
        + " will not be loaded due to insufficient privileges.".
    ELSE
    IF noload <> "" AND CAN-DO(noload,as4dict.p__File._For-type) THEN
      err = "".
        
    ELSE DO:
      {prodict/dump/ltrigchk.i &OK = answer}
      IF NOT answer THEN DO:
         MESSAGE "You do not have privileges to load table" as4dict.p__File._File-name 
                 SKIP
                 "with triggers disabled.  Do you want to load this table" SKIP
                 "anyway even though the triggers will fire?"
                 VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL UPDATE answer.
         IF answer = no THEN
            err = "".  /* don't do this table but no more messages */
         ELSE IF answer = yes THEN DO:
            err = ?.   /* include this table in load */
            dis_trig = "n".
         END.
         ELSE DO:    /* cancel the load operation */
            user_path = "".
            user_cancel = yes.
            RETURN.
         END.
      END.
    END.

    IF err = ? THEN
      ASSIGN
        user_env[1] = user_env[1] + comma + as4dict.p__File._File-name
        user_env[5] = user_env[5] + comma + dis_trig
        comma       = ",".
    ELSE IF err <> "" THEN DO:
      MESSAGE err SKIP "Do you want to continue?"
         VIEW-AS ALERT-BOX ERROR BUTTONS YES-NO UPDATE answer.
      IF answer = FALSE THEN DO:
        user_path = "".
        RETURN.
      END.
    END.

  END.

  /* subsequent removal of files changed from many to one, so reset ui stuff */
  IF (is-some OR is-all) AND NUM-ENTRIES(user_env[1]) = 1 THEN DO:
    FIND as4dict.p__File
      WHERE as4dict.p__File._file-number = file_num
        AND as4dict.p__File._File-name = user_env[1].
    ASSIGN
      is-some     = FALSE
      is-all      = FALSE
      is-one      = TRUE
      user_env[2] = prefix + (IF as4dict.p__File._Dump-name = ?
                    THEN as4dict.p__File._File-name ELSE as4dict.p__File._Dump-name)
                  + ".d"
      io-file     = TRUE
      io-title    = "Load Data Contents for Table ~"" + user_env[1] + "~""
      base        = user_env[1].
  END.

END.

/*-----------------------------------------------------*/ /* LOAD SEQ VALS */
ELSE IF class = "k" THEN DO FOR _File:
  ASSIGN
    user_env[2] = prefix + "_seqvals.d"
    io-title    = "Load Sequence Current Values".
END.

/*--------------------------------------------*/ /* LOAD USER FILE CONTENTS */
ELSE IF class = "u" THEN DO FOR _File:

  IF user_dbtype <> "PROGRESS" THEN msg-num = 1.
  ASSIGN
    user_env[2] = prefix + "_user.d"
    io-title    = "Load User Table Contents".
END.

/*--------------------------------------------*/ /* LOAD VIEW FILE CONTENTS */
ELSE IF class = "v" THEN DO FOR _File:
 
  IF user_dbtype <> "PROGRESS" THEN msg-num = 2.
  ASSIGN
    user_env[2] = prefix + "_view.d"
    io-title    = "Load SQL Views".
END.

IF msg-num > 0 THEN DO:
  MESSAGE (
    IF msg-num = 1 THEN
      "Cannot load User information for non-PROGRESS database."
    ELSE IF msg-num = 2 THEN
      "Cannot load View information for non-PROGRESS database."
    ELSE IF msg-num = 3 THEN
      "The dictionary is in read-only mode - alterations not allowed."
    ELSE
      "You do not have permission to use this option.")
    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  user_path = "".
  user_cancel = yes.
  RETURN.
END.

PAUSE 0.

/* if filename contains the .db, then remove it */
IF INDEX(user_env[2],".db") > 0 THEN
        SUBSTRING(user_env[2],INDEX(user_env[2],".db"),3,"RAW") = "".

IF io-frame = "df" THEN
  DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE WITH FRAME read-df:
    /* Adjust the graphical rectangle and the ok and cancel buttons */
    {adecomm/okrun.i  
        &FRAME  = "FRAME read-df" 
        &BOX    = "rect_Btns"
        &OK     = "btn_OK" 
        {&CAN_BTN}
        {&HLP_BTN}
    }
    ASSIGN
      stop_flg = user_env[4] BEGINS "y".
      Errors_to_File = yes.
      Errors_to_Screen = yes.

    UPDATE user_env[2] user_env[34] btn_File stop_flg 
           Errors_to_file Errors_to_screen 
           RPG_Names btn_OK allow_null btn_Cancel {&HLP_BTN_NAME}.
    ASSIGN user_env[34] = CAPS(user_env[34]).
    IF LAST-EVENT:FUNCTION = "ENDKEY" OR
       LAST-EVENT:FUNCTION = "END-ERROR" THEN UNDO, RETRY.
    user_env[4] = STRING(stop_flg).
    user_env[27] = STRING(Errors_to_File).
    user_env[28] = STRING(Errors_to_Screen).
    user_env[29] = STRING(RPG_Names).   
    user_env[30] = STRING(allow_null).
    { prodict/dictnext.i trash }
    canned = FALSE.
END.
ELSE IF io-frame = "d" THEN DO:
  IF NOT io-file THEN 
    DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE WITH FRAME read-d-dir:
      {adecomm/okrun.i  
        &FRAME  = "FRAME read-d-dir" 
        &BOX    = "rect_Btns"
        &OK     = "btn_OK" 
        {&CAN_BTN}
        {&HLP_BTN}
      }
      ASSIGN
        i      = INTEGER(user_env[4]).

      UPDATE user_env[2] i btn_OK btn_Cancel  {&HLP_BTN_NAME}.
      IF LAST-EVENT:FUNCTION = "ENDKEY"    OR
         LAST-EVENT:FUNCTION = "END-ERROR" THEN UNDO, RETRY.
      RUN "prodict/misc/ostodir.p" (INPUT-OUTPUT user_env[2]).
      DISPLAY user_env[2].
      user_env[4] = STRING(i).
      { prodict/dictnext.i trash }
      canned = FALSE.
    END.
  ELSE
    DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE WITH FRAME read-d-file:
      {adecomm/okrun.i  
        &FRAME  = "FRAME read-d-file" 
        &BOX    = "rect_Btns"
        &OK     = "btn_OK" 
        {&CAN_BTN}
        {&HLP_BTN}
      }
      ASSIGN
        i      = INTEGER(user_env[4]).

      UPDATE user_env[2] btn_File i btn_OK btn_Cancel  {&HLP_BTN_NAME}.
      IF LAST-EVENT:FUNCTION = "ENDKEY"    OR
         LAST-EVENT:FUNCTION = "END-ERROR" THEN UNDO, RETRY.
      DISPLAY user_env[2].
      user_env[4] = STRING(i).
      { prodict/dictnext.i trash }
      canned = FALSE.
    END.
  END.
ELSE
  DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE WITH FRAME read-input:
   {adecomm/okrun.i  
        &FRAME  = "FRAME read-input" 
        &BOX    = "rect_Btns"
        &OK     = "btn_OK" 
        {&CAN_BTN}
        {&HLP_BTN}
    }
    UPDATE user_env[2] btn_File btn_OK btn_Cancel {&HLP_BTN_NAME}.
    IF LAST-EVENT:FUNCTION = "ENDKEY"    OR
       LAST-EVENT:FUNCTION = "END-ERROR" THEN UNDO, RETRY.
    { prodict/dictnext.i trash }
    canned = FALSE.
  END.

HIDE FRAME read-input NO-PAUSE.
HIDE FRAME read-df    NO-PAUSE.
HIDE FRAME read-d-file NO-PAUSE.
HIDE FRAME read-d-dir NO-PAUSE.
IF canned THEN do:
  user_path = "".
  user_cancel = yes.
END.
RETURN.

PROCEDURE verify-cp.
  /* Is there a defined codepage? Try to read it in the trailer, if
   * not, ask for it
   */
  ASSIGN codepage = "".
  RUN read-cp. /* read the code page in the file */
  IF codepage = "" OR codepage = ? THEN 
  DO:
     MESSAGE "There is no Code Page defined in this input file." view-as
        ALERT-BOX ERROR BUTTONS OK.
     RUN get-cp. /* prompt for it */
  END.
  ELSE user_env[10] = codepage.
END PROCEDURE.

PROCEDURE read-cp.
  /* Read trailer of file and find codepage */
  /* (partially stolen from lodtrail.i)     */
  
  DEFINE VARIABLE i     AS INT            NO-UNDO.

  INPUT FROM VALUE(user_env[2]) NO-ECHO NO-MAP.
  SEEK INPUT TO END.
  SEEK INPUT TO SEEK(INPUT) - 11. /* position to beginning of last line */

  READKEY PAUSE 0.
  ASSIGN
    lvar# = 0
    lvar  = ""
    i     = 0.
  DO WHILE LASTKEY <> 13 AND i <> ?: /* get byte count (last line) */
    i = (IF LASTKEY > 47 AND LASTKEY < 58 
          THEN i * 10 + LASTKEY - 48
          ELSE ?).
    READKEY PAUSE 0.
  END.
  IF i > 0 then run get_psc. /* get it */
  ELSE RUN find_psc. /* look for it */
  INPUT CLOSE.
  DO i = 1 TO lvar#:
    IF lvar[i] BEGINS "codepage=" OR lvar[i] BEGINS "cpstream" THEN 
      codepage = SUBSTRING(lvar[i],10).
  END.
END PROCEDURE.

PROCEDURE get_psc:
  /* using the byte count, we scoot right down there and look for
   * the beginning of the trailer ("PSC"). If we don't find it, we
   * will go and look for it.
   */
   
  DEFINE VARIABLE rc AS LOGICAL INITIAL no.
  _psc:
  DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
    SEEK INPUT TO i. /* skip to beginning of "PSC" in file */
    READKEY PAUSE 0. IF LASTKEY <> ASC("P") THEN LEAVE _psc. /* not there!*/
    READKEY PAUSE 0. IF LASTKEY <> ASC("S") THEN LEAVE _psc.
    READKEY PAUSE 0. IF LASTKEY <> ASC("C") THEN LEAVE _psc.
    ASSIGN rc = yes. /* found it! */
    RUN read_bits (INPUT i). /* read trailer bits */
  END.
  IF NOT rc THEN RUN find_psc. /* look for it */
END PROCEDURE.

PROCEDURE find_psc:
  /* If the bytecount at the end of the file is wrong, we will jump
   * back the maximum number of bytes in a trailer and start looking
   * from there. If we still don't find it then tough luck.
   * NOTE: Variable p holds the number of bytes to roll back. AS of
   * 7/21/94, the max size of a trailer (.d) is 204 bytes, if you add
   * anything to this trailer, you must change this number to reflect
   * the number of bytes you added. I'll use 256 to add a little padding. (gfs)
   */
  DEFINE VARIABLE p AS INTEGER INITIAL 256. /* really 204, added extra just in case */
  DEFINE VARIABLE l AS INTEGER.             /* last char position */
  
  SEEK INPUT TO END.
  ASSIGN l = SEEK(INPUT). /* EOF */
  SEEK INPUT TO SEEK(INPUT) - MINIMUM(p,l). /* take p, or size of file */
  IF SEEK(INPUT) = ? THEN RETURN.
  _scan:
  REPEAT ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
    READKEY PAUSE 0.
    p = SEEK(INPUT). /* save off where we are looking */
    IF LASTKEY = ASC("P") THEN DO:
       READKEY PAUSE 0.
       IF LASTKEY <> ASC("S") THEN NEXT.
       ELSE DO: /* found "PS" */
         READKEY PAUSE 0.
         IF LASTKEY <> ASC("C") THEN NEXT.
         ELSE DO: /* found "PSC"! */
           RUN read_bits (INPUT p - 1).
           LEAVE.
         END. /* IF "C" */
       END. /* IF "S" */    
    END. /* IF "P" */
    ELSE IF p >= l THEN LEAVE _scan. /* at EOF, so give up */
  END. /* repeat */
END.

PROCEDURE read_bits:
  /* reads trailer given a starting position 
   */ 
  DEFINE INPUT PARAMETER i as INTEGER. /* "SEEK TO" location */
    
  SEEK INPUT TO i.
  REPEAT:
    IMPORT lvar[lvar# + 1].
    lvar# = lvar# + 1.
  END.
END PROCEDURE. 

PROCEDURE get-cp.
   /* Prompt for codepage */
   DO ON ERROR UNDO, RETRY ON ENDKEY UNDO, LEAVE WITH FRAME get-cp:
      {adecomm/okrun.i
         &FRAME = "FRAME get-cp"
         &BOX   = "rect_Btns"
         &OK    = "btn_OK"
         {&CAN_BTN}
         {&HLP_BTN}
       }
       ASSIGN codepage = SESSION:STREAM.
       UPDATE codepage btn_OK btn_Cancel {&HLP_BTN_NAME}.
       ASSIGN user_env[10] = codepage.
   END.
END PROCEDURE.







