/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* _usrexpo.p - get fields, etc. for export */

/*
This program does the initial for both 'sylk' and 'dif' format dumps.

IN:
user_env[1] = db filename to export
user_env[9] = 'dif' for dif format
            = 'sylk' for sylk format
            = 'ascii' for ascii format
            = 'ws' for wordstar format
            = 'word' for microsoft word format
            = 'wperf' for wordperfect format
            = 'ofisw' for btos ofiswriter format

OUT:
user_env[ 1] = db filename to export
user_env[ 2] = 'WHERE' clause
user_env[ 3] = 'BY' clause
user_env[ 4] = export '.dif', '.slk', or '.txt' filename
user_env[ 5] = count of field names to export
user_env[ 6] = comma-delimited list of field names to export
user_env[ 7] = ?, or filename to save generated code
user_env[ 8] = y/n, include field headers (_dmpasci.p only)
user_env[ 9] = format type
user_env[10] = field delimiter character (_dmpasci.p only)
user_env[11] = field separator character (_dmpasci.p only)
user_env[12] = line delimiter character (_dmpasci.p only)
user_env[13] = line starter character (_dmpasci.p only)
user_env[14] = "y" - disable triggers, "n" - do not disable triggers

HISTORY:
03/04/03 by mcmann Added block for blobs and clobs
04/17/01 by mcmann Added ldbname to compile check and delete of temp file.
                   20010412-001
07/13/98 by mcmann Added _Owner to _File finds
08/01/95 by tomn - added support for mnemonics
07/28/94 by gfs - added context-sensitive help to export dlg.
07/08/94 by gfs - added validation to the ascii export frame
06/24/94 by gfs - added syntax check to validate WHERE and/or BY
06/23/94 by gfs - previous change backed out - will go in 7.4
06/23/94 by gfs - changed field labels for ascii export.
10/15/03 D. McMann  Add support for datetime and datetime-tz  

*/
{ prodict/dictvar.i }
{ prodict/user/uservar.i }
{ prodict/user/userhue.i }
{ prodict/user/userpik.i NEW }

DEFINE VARIABLE anywhere  AS LOGICAL INITIAL FALSE NO-UNDO.
DEFINE VARIABLE anysort   AS LOGICAL INITIAL FALSE NO-UNDO.
DEFINE VARIABLE canned    AS LOGICAL INITIAL TRUE  NO-UNDO.
DEFINE VARIABLE allorsome AS LOGICAL INITIAL FALSE NO-UNDO.
DEFINE VARIABLE dis_trigs AS LOGICAL INITIAL NO    NO-UNDO.
DEFINE VARIABLE dummyl    AS LOGICAL               NO-UNDO.
DEFINE VARIABLE i         AS INTEGER               NO-UNDO.
DEFINE VARIABLE typ       AS CHARACTER             NO-UNDO.
DEFINE VARIABLE upath     AS CHARACTER             NO-UNDO.
DEFINE VARIABLE out_lbl   AS CHAR FORMAT "X(13)" NO-UNDO INIT "&Output File:".
{prodict/misc/filesbtn.i}

/* LANGUAGE DEPENDENCIES START */ /*----------------------------------------*/
DEFINE VARIABLE new_lang AS CHARACTER EXTENT 5 NO-UNDO INITIAL [
  /*1,2*/ "Fields for", "Export",
  /*  3*/ "You do not have permission to read from this table.",
  /*  4*/ "A file already exists with the name:",
  /*  5*/ "Overwrite it?"
].

/*---------------- FRAME export-stuff --------------------------------------*/
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
&IF "{&WINDOW-SYSTEM}" begins "MS-Win" &THEN
&GLOBAL-DEFINE EDITLINES 2
&GLOBAL-DEFINE FILLCH    55
&ELSE
&GLOBAL-DEFINE EDITLINES 3
&GLOBAL-DEFINE FILLCH    57
&ENDIF
FORM
  SKIP({&TFM_WID})
  out_lbl AT 2 VIEW-AS TEXT NO-LABEL SKIP({&VM_WID})
  user_env[4] {&STDPH_FILL} NO-LABEL FORMAT "x({&PATH_WIDG})" AT 2 
        VIEW-AS FILL-IN SIZE {&FILLCH} BY 1
  btn_File  SKIP ({&VM_WIDG})
  "Fields to Export:    " AT 2 VIEW-AS TEXT SKIP({&VM_WID})
  allorsome VIEW-AS RADIO-SET RADIO-BUTTONS "&Selected", no, "All (&Max 255)", yes
            NO-LABEL AT 2 SKIP({&VM_WIDG})
  "Records to Export:" AT 2 VIEW-AS TEXT SKIP({&VM_WID})
  anywhere VIEW-AS RADIO-SET RADIO-BUTTONS "&All", no, "Use &WHERE-Clause ", yes
                       NO-LABEL AT 2
  user_env[2] NO-LABEL FORMAT "X(128)"
        VIEW-AS EDITOR INNER-LINES {&EDITLINES} INNER-CHARS 40 
        SCROLLBAR-VERTICAL {&STDPH_ED4GL_SMALL}
        AT ROW-OF anywhere COLUMN 26 SKIP({&VM_WIDG})
  "Record Sorting:" AT 2 VIEW-AS TEXT SKIP({&VM_WID})
  anysort VIEW-AS RADIO-SET RADIO-BUTTONS "Use &Primary Index", 
        no, "Use &BY-Clause", yes NO-LABEL AT 2
  user_env[3] NO-LABEL FORMAT "x(128)" 
        VIEW-AS EDITOR INNER-LINES {&EDITLINES} INNER-CHARS 40 
        SCROLLBAR-VERTICAL {&STDPH_ED4GL_SMALL}
        AT ROW-OF anysort COLUMN 26 SKIP({&VM_WIDG})
  "Database Triggers: " AT 2 VIEW-AS TEXT /*SKIP({&VM_WID})*/
  dis_trigs VIEW-AS TOGGLE-BOX LABEL "&Disable During Export"
         SKIP({&VM_WIDG})
     "  NOTE: LOB or Array fields cannot be exported and are excluded from the list." AT 3 VIEW-AS TEXT SKIP({&VM_WIDG})
  {prodict/user/userbtns.i}
  WITH FRAME export-stuff
  CENTERED SIDE-LABELS SCROLLABLE 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE "Export " + (IF user_env[9] EQ "ascii" THEN "Text" ELSE user_env[9]).
  
  /* Added to support "Output File:" fill-in label mnemonic (tomn 8/1/95) */
  ASSIGN
    user_env[4]:SIDE-LABEL-HANDLE IN FRAME export-stuff = out_lbl:HANDLE
    user_env[4]:LABEL = out_lbl.
&ELSE
FORM
  SKIP(.5)
  "Output File:" AT 2 SKIP
  user_env[4] {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" NO-LABEL AT 4
        VIEW-AS FILL-IN SIZE 50 BY 1 
  btn_File SKIP(1)
  "WHERE-Clause Criteria for Records to be Exported (Default = All):" 
                                                                                        AT 2 VIEW-AS TEXT SKIP
  user_env[2] NO-LABEL FORMAT "x(60)"               AT 4 SPACE(1)  SKIP(1)

  "BY-Clause for Sorting Records (Default = Use Primary Index):"     
        AT 2 VIEW-AS TEXT SKIP
  user_env[3] NO-LABEL  FORMAT "x(60)"                  AT 4           SKIP(1)

  allorsome FORMAT "All/Some"
    LABEL "Export (A)ll Fields (max 255) Or (S)elected Fields" AT 2   SKIP
  "(LOB or Array fields cannot be exported and are excluded from the list)" 
                                                                                        AT 4 VIEW-AS TEXT SKIP(1)

  dis_trigs LABEL "Disable Triggers During Export?" AT 2 
  {prodict/user/userbtns.i}
  WITH FRAME export-stuff
  ROW 2 CENTERED SIDE-LABELS SCROLLABLE 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE "Export " + (IF user_env[9] EQ "ascii" THEN "Text" ELSE user_env[9]).
&ENDIF

/*---------------- FRAME export-ascii --------------------------------------*/
&IF "{&WINDOW-SYSTEM}" begins "MS-Win" &THEN
&GLOBAL-DEFINE LINEUP 19
&ELSE
&GLOBAL-DEFINE LINEUP 21
&ENDIF
FORM
  SKIP({&TFM_WID})
  user_env[13] {&STDPH_FILL} LABEL "Record &Start String" FORMAT "x(20)" 
        COLON {&LINEUP} SKIP ({&VM_WID})
  user_env[12] {&STDPH_FILL} LABEL "Record &End String" FORMAT "x(20)" 
        COLON {&LINEUP} SKIP({&VM_WIDG})
  user_env[10] {&STDPH_FILL} LABEL "Field &Delimiter" FORMAT "x(20)" 
        COLON {&LINEUP} SKIP ({&VM_WID})
  user_env[11] {&STDPH_FILL} LABEL "Field Se&parator" FORMAT "x(20)" 
        COLON {&LINEUP} SKIP ({&VM_WIDG})
  "Note: three-digit octal codes are allowed,"
        AT 2 VIEW-AS TEXT SKIP
  "such as ~~012." AT 2 VIEW-AS TEXT
  {prodict/user/userbtns.i}
  WITH FRAME export-ascii
  CENTERED SIDE-LABELS
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE "Output Record Formatting".
/* LANGUAGE DEPENDENCIES END */ /*------------------------------------------*/

/*==========================Internal Procedures=========================*/

/*----------------------------------------------------------
   Do frame validation when user hits OK or GO.

   Input Parameter: 
      p_file    = name of file to export to
      p_disable = disable trigger widget (yes or no)

   Returns: "error" or "".
----------------------------------------------------------*/
PROCEDURE Validate_Frame:
   DEFINE INPUT PARAMETER p_file    AS WIDGET-HANDLE NO-UNDO.
   DEFINE INPUT PARAMETER p_disable AS WIDGET-HANDLE NO-UNDO.
   DEFINE VARIABLE        ok        AS LOGICAL       NO-UNDO.
   DEFINE VARIABLE        tmpfile   AS CHARACTER     NO-UNDO.

   /* See if user has permission to import with triggers
      disabled.  If not, ask if he wants to continue
      anyway.
   */
   IF p_disable:SCREEN-VALUE = "yes" THEN
   DO:
      /*{prodict/dump/ltrigchk.i &OK = ok}*/
      Define var trig_found as logical NO-UNDO.

      trig_found = no.
      find _File-trig of _File where _File-trig._Event = "FIND" NO-ERROR.
      if AVAILABLE _File-trig then
        trig_found = yes.

      if trig_found then
         ok = CAN-DO(_File._Can-Load,USERID(user_dbname)).
      else
         ok = yes.
      IF NOT ok THEN DO:
         MESSAGE "You do not have permission to export" SKIP 
                 "with triggers disabled."
                 VIEW-AS ALERT-BOX ERROR BUTTON OK.
         p_disable:SCREEN-VALUE = "no".
         RETURN "error".
      END.
   END.

  IF SEARCH(p_file:SCREEN-VALUE) <> ? THEN DO:
    ok = false.
    MESSAGE new_lang[4] SKIP p_file:SCREEN-VALUE SKIP(1)  new_lang[5] 
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE ok.
    IF NOT ok THEN DO:
      APPLY "ENTRY" TO p_file.
      RETURN "error".
    END.
  END.
  /* gfs: check to see if what was entered compiles */
  IF user_env[2]:SCREEN-VALUE IN FRAME export-stuff <> "" OR
     user_env[3]:SCREEN-VALUE IN FRAME export-stuff <> "" THEN
  DO:
     RUN "adecomm/_tmpfile.p"(INPUT "", INPUT ".adm", OUTPUT tmpfile).
     OUTPUT TO VALUE(tmpfile) NO-MAP.
        PUT UNFORMATTED
           "OUTPUT TO " user_env[4] "." SKIP
           "FOR EACH " LDBNAME("DICTDB") "." user_env[1] " "
                        user_env[2]:SCREEN-VALUE " "
                        user_env[3]:SCREEN-VALUE ":" SKIP
           "END." SKIP
           "OUTPUT CLOSE.".
     OUTPUT CLOSE.
     COMPILE VALUE(tmpfile) NO-ERROR.
     IF COMPILER:ERROR THEN
     DO:
       MESSAGE "The syntax entered for WHERE and/or BY is invalid." CHR(10)
               "Re-check the syntax you entered." VIEW-AS ALERT-BOX
               ERROR BUTTONS OK.
       IF user_env[2]:SCREEN-VALUE <> "" THEN APPLY "ENTRY" TO user_env[2].
       ELSE APPLY "ENTRY" TO user_env[3].
       OS-DELETE VALUE(tmpfile).
       RETURN "ERROR".
     END. 
     OS-DELETE VALUE(tmpfile).
     RETURN "".
  END.
END.

/*=============================Triggers=================================*/

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
/*----- HELP -----*/
on HELP of frame export-stuff
   or CHOOSE of btn_Help in frame export-stuff DO:
   IF user_env[2]:SELECTION-TEXT <> "" OR user_env[3]:SELECTION-TEXT <> "" THEN 
   DO:
     IF user_env[2]:SELECTION-TEXT <> "" THEN
       RUN "adecomm/_kwhelp.p" (INPUT user_env[2]:HANDLE,
                                INPUT "admn",
                                INPUT {&Export_Stuff_Dlg_Box}).
     IF user_env[3]:SELECTION-TEXT <> "" THEN
       RUN "adecomm/_kwhelp.p" (INPUT user_env[3]:HANDLE,
                                INPUT "admn",
                                INPUT {&Export_Stuff_Dlg_Box}).
   END.
   ELSE  
     RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
                                    INPUT {&Export_Stuff_Dlg_Box},
                                                 INPUT ?).
END.

on HELP of frame export-ascii
   or CHOOSE of btn_Help in frame export-ascii
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
                                               INPUT {&Output_Record_Dlg_Box},
                                               INPUT ?).
&ENDIF


/*----- ON GO or OK -----*/
ON GO OF FRAME export-stuff
DO:
  run Validate_Frame (INPUT user_env[4]:HANDLE IN FRAME export-stuff,
                                   INPUT dis_trigs:HANDLE IN FRAME export-stuff).
  if RETURN-VALUE = "error" THEN
     RETURN NO-APPLY.
END.

ON WINDOW-CLOSE OF FRAME export-stuff
   APPLY "END-ERROR" TO FRAME export-stuff.
ON WINDOW-CLOSE OF FRAME export-ascii
   APPLY "END-ERROR" TO FRAME export-ascii.

/*----- HIT of FILE BUTTON -----*/
ON CHOOSE OF btn_File in frame export-stuff DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT user_env[4]:handle in frame export-stuff /*Fillin*/,
        INPUT "Find Output File"  /*Title*/,
        INPUT ""                 /*Filter*/,
        INPUT no                 /*Must exist*/).
END.

/*----- LEAVE of fill-ins: trim blanks the user may have typed in filenames---*/
ON LEAVE OF user_env[4] in frame export-stuff
   user_env[4]:screen-value in frame export-stuff = 
        TRIM(user_env[4]:screen-value in frame export-stuff).

ON LEAVE OF user_env[11] IN FRAME export-ascii DO:
    IF user_env[11]:SCREEN-VALUE = "~"" OR user_env[11]:SCREEN-VALUE = "~'" THEN DO:
        MESSAGE "Quote marks cannot be used as separators."
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        RETURN NO-APPLY.
    END.
END.

ON GO OF FRAME export-ascii DO:
    IF user_env[10]:SCREEN-VALUE = user_env[11]:SCREEN-VALUE THEN DO:
        MESSAGE "You can not use the same character for delimiter and separator."
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        APPLY "ENTRY" TO user_env[10] IN FRAME export-ascii.
        RETURN NO-APPLY.
    END.
END.

/*----- WHERE-Clause and BY-Clause radio-sets ------------*/
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
ON VALUE-CHANGED OF anywhere IN FRAME export-stuff DO:
   IF anywhere:SCREEN-VALUE = "no" THEN DO:
        user_env[2]:SENSITIVE = FALSE.
        user_env[2]:SCREEN-VALUE = "".
   END.
   ELSE DO:
        user_env[2]:SENSITIVE = TRUE.
        user_env[2]:SCREEN-VALUE = "WHERE ".
        dummyl = user_env[2]:MOVE-AFTER-TAB-ITEM(anywhere:HANDLE).
        user_env[2]:CURSOR-OFFSET = 7.
        APPLY "ENTRY" TO user_env[2].
   END.
END.
ON VALUE-CHANGED OF anysort IN FRAME export-stuff DO:
   IF anysort:SCREEN-VALUE = "no" THEN DO:
        user_env[3]:SENSITIVE = FALSE.
        user_env[3]:SCREEN-VALUE = "".
   END.
   ELSE DO:
        user_env[3]:SENSITIVE = TRUE.
        user_env[3]:SCREEN-VALUE = "BY ".
        dummyl = user_env[3]:MOVE-AFTER-TAB-ITEM(anysort:HANDLE).
        user_env[3]:CURSOR-OFFSET = 4.
        APPLY "ENTRY" TO user_env[3].
   END.
END.

&ENDIF

/*==========================Mainline code================================*/

FIND _File WHERE _Db-recid = drec_db AND _File-name = user_env[1]
             AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN" ).

IF NOT CAN-DO(_File._Can-read,USERID(user_dbname)) THEN DO:
  MESSAGE new_lang[3] VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  user_path =  "".
  RETURN.
END.

ASSIGN
  typ          = user_env[9]
  user_env[ 2] = ""
  user_env[ 3] = ""
  user_env[ 6] = ""
  user_env[ 7] = ?
  user_env[ 8] = "n"
  user_env[ 9] = CAPS(typ)
  user_env[13] = "".

{adecomm/okrun.i  
      &FRAME  = "FRAME export-stuff" 
      &BOX    = "rect_Btns"
      &OK     = "btn_OK" 
      {&CAN_BTN}
      {&HLP_BTN}
}
IF typ = "ascii" THEN DO:
  {adecomm/okrun.i  
      &FRAME  = "FRAME export-ascii" 
      &BOX    = "rect_Btns"
      &OK     = "btn_OK" 
      {&CAN_BTN}
      {&HLP_BTN}
  }
END.

DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:

  CASE typ:
        WHEN "dif" THEN
            user_env[4] = user_env[1] + ".dif".
        WHEN "sylk" THEN
            user_env[4] = user_env[1] + ".slk".
        WHEN "ascii" THEN
            user_env[ 4] = user_env[1] + ".txt".
        WHEN "ws" THEN
          ASSIGN
            user_env[ 4] = user_env[1] + ".dat"
            user_env[ 9] = "WORDSTAR"
            user_env[10] = "~""
            user_env[11] = ","
            user_env[12] = "~~015~~012".
        WHEN "word" THEN
          ASSIGN
            user_env[ 4] = user_env[1] + ".doc"
            user_env[ 8] = "y"
            user_env[ 9] = "MICROSOFT WORD"
            user_env[10] = ""     /* was: "~"" */
            user_env[11] = CHR(9) /* was: ","  */
            user_env[12] = "~~015~~012".
        WHEN "wperf" THEN
          ASSIGN
            user_env[ 4] = user_env[1] + ".dat"
            user_env[ 9] = "WORDPERFECT"
            user_env[10] = ""
            user_env[11] = "~~022~~015~~012"  /* ctrl-R cr lf */
            user_env[12] = "~~005~~015~~012". /* ctrl-E cr lf */
        WHEN "ofisw" THEN
          ASSIGN
            user_env[ 4] = user_env[1] + ".dat"
            user_env[ 9] = "OFISWRITER"
            user_env[10] = ""
            user_env[11] = "|"    /* field sep */
            user_env[12] = "~~012" /* end-of-line */
            user_env[13] = "*".   /* record marker */
  END CASE.        
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  UPDATE
    user_env[4] btn_File
    allorsome
    anywhere
    anysort
    dis_trigs
    btn_OK btn_Cancel {&HLP_BTN_NAME}
    WITH FRAME export-stuff.
  IF anywhere THEN 
     user_env[2] = user_env[2]:SCREEN-VALUE IN FRAME export-stuff.
  IF anysort THEN 
     user_env[3] = user_env[3]:SCREEN-VALUE IN FRAME export-stuff.
&ELSE
  UPDATE
    user_env[4] btn_File
    user_env[2]
    user_env[3]
    allorsome
    dis_trigs
    btn_OK btn_Cancel {&HLP_BTN_NAME}
    WITH FRAME export-stuff.
&ENDIF
  IF typ = "ascii" 
  THEN DO:
    ASSIGN
      user_env[13] = ""
      /* Use 012 on all opsys, currently bug in quoter with 015,012 */
      /* Our dump and reload works fine on DOS and OS2 with just 012. */
      /*
      user_env[12] = (IF CAN-DO("MSDOS,OS2",OPSYS) THEN "~~015~~012" ELSE "~~012")
      */
      user_env[12] = "~~012"
      user_env[10] = "~""
      user_env[11] = ",".

    UPDATE
      user_env[13] /*line starter*/
      user_env[12] /*line term*/
      user_env[10] /*quoting char*/
      user_env[11] /*field delimiter*/
      btn_OK btn_Cancel {&HLP_BTN_NAME}
      WITH FRAME export-ascii.
      
  END.
  canned = FALSE.
END.

IF canned THEN DO:
  user_path = "".
  HIDE FRAME export-stuff NO-PAUSE.
  HIDE FRAME export-ascii NO-PAUSE.
  RETURN.
  END.


&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
IF NOT anywhere THEN user_env[2] = "".
IF NOT anysort THEN user_env[3] = "".
&ELSE
IF TRIM(user_env[2]) = "all" THEN user_env[2] = "".
IF user_env[2] <> "" AND NOT (user_env[2] BEGINS "WHERE ") THEN 
        user_env[2] = "WHERE " + user_env[2]. /*qual*/
IF user_env[3] <> "" AND NOT (user_env[3] BEGINS "BY ") THEN 
        user_env[3] = "BY " + user_env[3].    /*sort*/
&ENDIF
user_env[14] = (if dis_trigs then "y" else "n").

IF allorsome THEN DO:
  FOR EACH _Field OF _File WHERE _Field._Extent = 0 
                             AND _Field._Data-type <> "BLOB" 
                             AND _Field._Data-type <> "CLOB"
                             AND _Field._Data-type <> "XLOB"
                              BY _Field._Order:
    ASSIGN
      i           = i + 1
      user_env[6] = user_env[6]
                  + (IF i = 1 THEN "" ELSE ",")
                  + _Field._Field-name.
    IF i = 255 THEN LEAVE.
  END.
  user_env[5] = STRING(i).
END.
ELSE DO:
  ASSIGN
    pik_column = 25
    pik_row    = 4
    pik_hide   = TRUE
    pik_init   = ""
    pik_wide   = FALSE
    pik_count  = 0
    pik_list   = ""
    pik_multi  = TRUE
    pik_number = TRUE
    pik_title  = new_lang[1] + " " + user_env[9] + " " + new_lang[2].
  FOR EACH _Field OF _File WHERE _Field._Extent = 0
                             AND _Field._Data-type <> "BLOB" 
                             AND _Field._Data-type <> "CLOB"
                             AND _Field._Data-type <> "XLOB"
                             BY _Field._Order:
    ASSIGN
      pik_count = pik_count + 1
      pik_list[pik_count] = _Field._Field-name.
  END.
  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
    RUN "prodict/user/_usrpick.p".
  &ELSE
    pik_help = {&Fields_For_Export_Dlg_Box}.
    RUN "prodict/gui/_guipick.p".
  &ENDIF
  pik_return = MINIMUM(pik_return,255).
  DO i = 1 TO pik_return:
    user_env[6] = user_env[6]
                + (IF i = 1 THEN "" ELSE ",")
                + pik_list[pik_chosen[i]].
  END.
  user_env[5] = STRING(pik_return).
END.

IF user_env[6] = "" THEN user_path = "".

{ prodict/dictnext.i upath }

HIDE FRAME export-stuff NO-PAUSE.
HIDE FRAME export-ascii NO-PAUSE.
RETURN.


