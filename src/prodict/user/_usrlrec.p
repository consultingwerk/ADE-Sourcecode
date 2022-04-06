/***********************************************************************
* Copyright (C) 2000,2006 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/

/* Progress Lex Converter 7.1A->7.1B Version 1.11 */

/* _usrlrec.p - build a new .d from existing .d when .e contains errors 
   History:  D. McMann 04/13/00 Added support for long path names
             D. McMann 06/07/00 Added check for quoter.

*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

DEFINE VARIABLE canned     AS LOGICAL   NO-UNDO INIT TRUE.
DEFINE VARIABLE answer     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE dot_d_file AS CHARACTER NO-UNDO.
DEFINE VARIABLE dot_e_file AS CHARACTER NO-UNDO.
DEFINE VARIABLE scrap      AS CHARACTER NO-UNDO.
DEFINE VARIABLE third_file AS CHARACTER NO-UNDO.
DEFINE VARIABLE msgReco1   AS CHARACTER VIEW-AS EDITOR NO-BOX INNER-CHARS 70 INNER-LINES 4 NO-UNDO.
{prodict/misc/filesbtn.i &NAME = btn_File_d}
{prodict/misc/filesbtn.i &NAME = btn_File_e &NOACC=yes}
{prodict/misc/filesbtn.i &NAME = btn_File_third &NOACC=yes}

/* LANGUAGE DEPENDENCIES START */ /*----------------------------------------*/
DEFINE VARIABLE new_lang AS CHARACTER EXTENT 5 NO-UNDO INITIAL [
  /* 1*/ "A file already exists named:",
  /* 2*/ "Overwrite it?",
  /* 3*/ "error.d", /* it would not be a good idea to change this name here */
  /* 4*/ "Can not find",
  /* 5*/ "file with this name."
].

&IF "{&WINDOW-SYSTEM}" begins "MS-Win" &THEN
  &GLOBAL-DEFINE LINEUP 20
  &GLOBAL-DEFINE FILLCH 35
&ELSE
  &GLOBAL-DEFINE LINEUP 20
  &GLOBAL-DEFINE FILLCH 37
&ENDIF

FORM
 
&IF "{&WINDOW-SYSTEM}" <> "TTY" 
&THEN
   SKIP({&TFM_WID})
  msgReco1 NO-LABEL AT 2 SKIP ({&VM_WIDG})
&ELSE
  "When a data load encounters errors, an error file is produced." 
                                         AT 2   VIEW-AS TEXT        SKIP({&VM_WID})
  "This utility takes the error file and the original data file"
                                         AT 2   VIEW-AS TEXT        SKIP({&VM_WID})
  "and produces a new data file with only the bad records.  This"
                                         AT 2   VIEW-AS TEXT        SKIP({&VM_WID})
  "new file can then be edited and reloaded."                   
                                         AT 2    VIEW-AS TEXT  SKIP({&VM_WIDG})
&ENDIF
  dot_d_file {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" VIEW-AS FILL-IN SIZE {&FILLCH} BY 1 
        LABEL "Original Data File" COLON {&LINEUP}
  btn_File_d SKIP ({&VM_WIDG})

  dot_e_file {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" VIEW-AS FILL-IN SIZE {&FILLCH} BY 1
         LABEL "Error File" COLON {&LINEUP}
 btn_File_e SKIP ({&VM_WIDG})
  third_file {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" VIEW-AS FILL-IN SIZE {&FILLCH} BY 1
        LABEL "Output Data File" COLON {&LINEUP}
  btn_File_third SKIP ({&VM_WIDG})
  {prodict/user/userbtns.i}

  WITH FRAME recovery 
  CENTERED  SIDE-LABELS 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE "Reconstruct Bad Load Records".

&IF "{&WINDOW-SYSTEM}" <> "TTY" 
&THEN
ASSIGN msgReco1:SCREEN-VALUE =
  "When a data load encounters errors, an error file is produced. " +
  "This utility takes the error file and the original data file " +
  "and produces a new data file with only the bad records.  This " +
  "new file can then be edited and reloaded.".
msgReco1:READ-ONLY = yes.
&ENDIF
  
/* LANGUAGE DEPENDENCIES END */ /*------------------------------------------*/


/*===============================Triggers=================================*/

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
/*----- HELP -----*/
on HELP of frame recovery
   or CHOOSE of btn_Help in frame recovery
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
                                               INPUT {&Reconstruct_Bad_Load_Records_Dlg_Box},
                                               INPUT ?).
&ENDIF


ON GO OF FRAME recovery
DO:
  if SEARCH(dot_d_file:SCREEN-VALUE IN FRAME recovery) = ? THEN DO:
    MESSAGE new_lang[4] ".d" new_lang[5]
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    APPLY "ENTRY" TO dot_d_file IN FRAME recovery.
    RETURN NO-APPLY.
  END.

  if SEARCH(dot_e_file:SCREEN-VALUE IN FRAME recovery) = ? THEN DO:
    MESSAGE new_lang[4] ".e" new_lang[5]
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    APPLY "ENTRY" TO dot_e_file IN FRAME recovery.
    RETURN NO-APPLY.
  END.

  IF SEARCH(third_file:SCREEN-VALUE IN FRAME recovery) <> ? THEN DO:
    answer = FALSE.
    MESSAGE new_lang[1] SKIP third_file:SCREEN-VALUE SKIP(1) new_lang[2]
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer.
    IF NOT answer THEN 
    DO:
      APPLY "ENTRY" TO third_file IN FRAME recovery.
      RETURN NO-APPLY.
    END.
  END.
END.

/*----- LEAVE of fill-ins: trim blanks the user may have typed in ------*/
ON LEAVE OF dot_d_file in frame recovery
   dot_d_file:screen-value in frame recovery = 
        TRIM(dot_d_file:screen-value in frame recovery).
ON LEAVE OF dot_e_file in frame recovery
   dot_e_file:screen-value in frame recovery = 
        TRIM(dot_e_file:screen-value in frame recovery).
ON LEAVE OF third_file in frame recovery
   third_file:screen-value in frame recovery = 
        TRIM(third_file:screen-value in frame recovery).

/*----- HIT of FILE BUTTON -----*/
ON CHOOSE OF btn_File_d in frame recovery DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT dot_d_file:handle in frame recovery /*Fillin*/,
        INPUT "Find Data File"  /*Title*/,
        INPUT "*.d"             /*Filter*/,
        INPUT yes               /*Must exist*/).
END.
ON CHOOSE of btn_File_e in frame recovery DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT dot_e_file:handle in frame recovery /*Fillin*/,
        INPUT "Find Error File"  /*Title*/,
        INPUT "*.e"             /*Filter*/,
        INPUT yes               /*Must exist*/).
END.
ON CHOOSE of btn_File_third in frame recovery DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT third_file:handle in frame recovery /*Fillin*/,
        INPUT "Specify New Data File"  /*Title*/,
        INPUT "*.d"             /*Filter*/,
        INPUT no                /*Must exist*/).
END.
/*----- WINDOW-CLOSE --------*/
ON WINDOW-CLOSE OF FRAME recovery
   APPLY "END-ERROR" to frame recovery.
      


/*============================Mainline code===============================*/
IF CAN-DO("MSDOS,WIN32",OPSYS) THEN DO: 
  IF SEARCH("quoter.exe") = ? THEN DO:
    MESSAGE "Unable to find the quoter utility.  Make sure that" SKIP
            "{&PRO_DISPLAY_NAME}' bin directory is in your PATH." SKIP
    VIEW-AS ALERT-BOX ERROR.
    ASSIGN user_path = "".
    RETURN.
  END.
END.
ELSE  IF OPSYS = "UNIX" THEN DO: 
  IF SEARCH("quoter") = ? THEN DO:
    MESSAGE "Unable to find the quoter utility.  Make sure that" SKIP
            "{&PRO_DISPLAY_NAME}' bin directory is in your PATH." SKIP
    VIEW-AS ALERT-BOX ERROR.
    ASSIGN user_path = "".
    RETURN.
  END.
END.

ASSIGN
  third_file = new_lang[3]. /* "error.d" */

/* Adjust the graphical rectangle and the ok and cancel buttons */
  &IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN   
    { prodict/user/userctr.i
        &FRAME = "FRAME recovery"
    }
&ENDIF
    {adecomm/okrun.i  
        &FRAME  = "FRAME recovery" 
        &BOX    = "rect_Btns"
        &OK     = "btn_OK" 
        {&CAN_BTN}
        {&HLP_BTN}
    }

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  ENABLE msgReco1 WITH FRAME recovery.
&ENDIF
DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
  UPDATE dot_d_file btn_File_d dot_e_file btn_File_e third_file btn_File_third
               btn_OK btn_Cancel {&HLP_BTN_NAME}
               WITH FRAME recovery.
  ASSIGN
    user_env[1] = SEARCH(dot_d_file)
    user_env[2] = SEARCH(dot_e_file)
    user_env[3] = third_file.
  { prodict/dictnext.i scrap }

  canned = FALSE.
END.

IF canned THEN
  user_path = "".
HIDE FRAME recovery NO-PAUSE.
HIDE MESSAGE NO-PAUSE.
RETURN.

