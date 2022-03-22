/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* _usrvgen.p */

/* This program generates CREATE VIEW statements from _View records
stored in the database.  These CREATE VIEW statements can then be
run on another database to define those views. 

History:  Added _Owner to _file Finds 07/14/98 D. McMann
          Added support for long path names 04/13/00 D. McMann

*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

DEFINE VARIABLE answer        AS LOGICAL INITIAL TRUE  NO-UNDO.
DEFINE VARIABLE canned  AS LOGICAL INITIAL TRUE  NO-UNDO.
DEFINE VARIABLE fo   AS CHARACTER              NO-UNDO.
DEFINE VARIABLE fn   AS CHARACTER              NO-UNDO.
DEFINE VARIABLE ft   AS CHARACTER INITIAL "."  NO-UNDO.
DEFINE VARIABLE allusers AS LOGICAL  INITIAL true NO-UNDO.
DEFINE VARIABLE usrnm   AS CHARACTER              NO-UNDO.
DEFINE VARIABLE uidtag  AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE allviews AS LOGICAL            NO-UNDO.
{prodict/misc/filesbtn.i}

/* LANGUAGE DEPENDENCIES START */ /*---------------------------------------*/
DEFINE VARIABLE new_lang AS CHARACTER EXTENT 7 NO-UNDO INITIAL [
  /* 1*/ "Could not find a user in the connected database with this userid.",
  /* 2*/ "A file named",
  /* 3*/ "already exists.",
  /* 4*/ "Overwrite it?",
  /* 5*/ "All Views",
  /* 6*/ "You do not have permission to use this option.",
  /* 7*/ "(Enter a Userid or ~"ALL~")"
].
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN  
&GLOBAL-DEFINE FILLCH 40
&GLOBAL-DEFINE LINEUP 23
FORM 
  SKIP({&TFM_WID})
  "Output File:" AT 2 VIEW-AS TEXT SKIP({&VM_WID})
  fo {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" AT 2
         VIEW-AS FILL-IN SIZE {&FILLCH} BY 1
  btn_File SKIP ({&VM_WIDG})
  "Statement Termination Character:" AT 2 VIEW-AS TEXT SKIP({&VM_WID})
  ft AT 2 VIEW-AS RADIO-SET HORIZONTAL
&IF "{&WINDOW-SYSTEM}" begins "MS-Win" &THEN  
        RADIO-BUTTONS "~" . ~"", ".", "~" ; ~"", ";"
&ELSE
        RADIO-BUTTONS "~".~"", ".", "~";~"", ";"
&ENDIF
  {prodict/user/userbtns.i}
  WITH FRAME createview
  NO-LABELS ATTR-SPACE ROW 3 CENTERED 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX
  TITLE " Dump CREATE VIEW of ~"" + fn + "~" ".

FORM
  SKIP({&TFM_WID})
  "Output File:" AT 2 VIEW-AS TEXT SKIP({&VM_WID})
  fo {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" AT 2
         VIEW-AS FILL-IN SIZE {&FILLCH} BY 1
  btn_File SKIP ({&VM_WIDG})
  "Which Users:" AT 2 VIEW-AS TEXT SKIP({&VM_WID})
  allusers AT 2 VIEW-AS RADIO-SET HORIZONTAL 
        RADIO-BUTTONS "All Users",yes,"Single User",no
  usrnm {&STDPH_FILL} SKIP ({&VM_WIDG})
  "Statement Termination Character:" AT 2 VIEW-AS TEXT SKIP({&VM_WID})
  ft AT 2 VIEW-AS RADIO-SET HORIZONTAL
&IF "{&WINDOW-SYSTEM}" begins "MS-Win" &THEN  
        RADIO-BUTTONS "~" . ~"", ".", "~" ; ~"", ";"
&ELSE
        RADIO-BUTTONS "~".~"", ".", "~";~"", ";"
&ENDIF
  {prodict/user/userbtns.i}
  WITH FRAME createallviews
  NO-LABELS ATTR-SPACE ROW 3 CENTERED 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX
  TITLE " Dump CREATE VIEW of All Views".
&ELSE
FORM
  SKIP({&TFM_WID})
  fo {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" LABEL "Output File"
        COLON 23 VIEW-AS FILL-IN SIZE 40 BY 1
  btn_File SKIP ({&VM_WIDG})
  ft LABEL " Statement Termination"  FORMAT "x"  COLON 23 SPACE(1)
    "(~".~" or ~"~;~")"                                   SKIP({&VM_WIDG})
  " This program generates a SQL DDL program containing CREATE VIEW statements" 
                                                                                     VIEW-AS TEXT      SKIP(0.1)
  " equivalent to those originally used to define the view.  The generated"
                                                                                     VIEW-AS TEXT      SKIP(0.1)
  " program makes the assumption that all necessary permissions are available"
                                                                                     VIEW-AS TEXT      SKIP(0.1)
  " It does NOT generate any GRANT or REVOKE statements to set permissions"
                                                                                     VIEW-AS TEXT      SKIP(0.1)
  " on the views."                           VIEW-AS TEXT     
  {prodict/user/userbtns.i}
  WITH FRAME createview
  SIDE-LABELS ATTR-SPACE ROW 3 CENTERED 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX
  TITLE " Dump CREATE VIEW of ~"" + fn + "~" ".
FORM
  SKIP({&TFM_WID})
  fo {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" LABEL "Output File"
        COLON 23 VIEW-AS FILL-IN SIZE 40 BY 1
  btn_File SKIP ({&VM_WIDG})
  ft LABEL "Statement Termination"  FORMAT "x"  COLON 23 SPACE(1)
    "(~".~" or ~"~;~")"                                   SKIP({&VM_WIDG})
  usrnm LABEL "Which User"                            COLON 23 SPACE(1)
  uidtag FORMAT "x(25)" NO-LABEL                                    SKIP({&VM_WIDG})
  " This program generates a SQL DDL program containing CREATE VIEW statements" 
                                                                                     VIEW-AS TEXT      SKIP(0.1)
  " equivalent to those originally used to define the view.  The generated"
                                                                                     VIEW-AS TEXT      SKIP(0.1)
  " program makes the assumption that all necessary permissions are available"
                                                                                     VIEW-AS TEXT      SKIP(0.1)
  " It does NOT generate any GRANT or REVOKE statements to set permissions"
                                                                                     VIEW-AS TEXT      SKIP(0.1)
  " on the views."                           VIEW-AS TEXT     
  {prodict/user/userbtns.i}

  WITH FRAME createallviews
  SIDE-LABELS ATTR-SPACE ROW 3 CENTERED 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX
  TITLE " Dump CREATE VIEW of All Views".
&ENDIF
/* LANGUAGE DEPENDENCIES END */ /*-----------------------------------------*/


/*===============================Triggers=================================*/

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
/*----- HELP -----*/
on HELP of frame createview
   or CHOOSE of btn_Help in frame createview
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
                                               INPUT {&Dump_Create_View_Dlg_Box},
                                               INPUT ?).
on HELP of frame createallviews
   or CHOOSE of btn_Help in frame createallviews
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
                                               INPUT {&Dump_Create_View_All_Dlg_Box},
                                               INPUT ?).
&ENDIF


ON GO OF FRAME createview
DO:
  DEFINE VAR fil AS CHAR NO-UNDO.

  fil = fo:SCREEN-VALUE IN FRAME createview.

  IF SEARCH(fil) <> ? THEN DO:
    answer = FALSE.
    MESSAGE new_lang[2] fil new_lang[3] SKIP new_lang[4]
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer.
    IF NOT answer THEN 
    DO:
      APPLY "ENTRY" TO fo IN FRAME createview.
      RETURN NO-APPLY.
    END.
  END.
END.

ON GO OF FRAME createallviews
DO:
  DEFINE VAR fil AS CHAR NO-UNDO.
  DEFINE VAR uid AS CHAR NO-UNDO.

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN  
  IF allusers:SCREEN-VALUE = "yes" THEN
        uid = "ALL".
  ELSE DO:
        uid = usrnm:SCREEN-VALUE.
        usrnm = uid.
  END.
&ELSE
  uid  = usrnm:SCREEN-VALUE.
&ENDIF
  IF uid <> "ALL" AND NOT CAN-FIND(_User WHERE _User._Userid = uid) THEN DO:
    MESSAGE new_lang[1] VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    APPLY "ENTRY" TO usrnm IN FRAME createallviews.
    RETURN NO-APPLY.
  END.

  fil = fo:SCREEN-VALUE IN FRAME createview.

  IF SEARCH(fil) <> ? THEN DO:
    answer = FALSE.
    MESSAGE new_lang[2] fil new_lang[3] SKIP new_lang[4]
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer.
    IF NOT answer THEN 
    DO:
      APPLY "ENTRY" TO fo IN FRAME createview.
      RETURN NO-APPLY.
    END.
  END.
END.

ON WINDOW-CLOSE OF FRAME createview
   APPLY "END-ERROR" TO FRAME createview.

ON CHOOSE OF btn_File in frame createview DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT fo:handle in frame createview /*Fillin*/,
        INPUT "Find Output File"  /*Title*/,
        INPUT ""                 /*Filter*/,
        INPUT no                /*Must exist*/).
END.

ON LEAVE OF fo in frame createview
   fo:screen-value in frame createview = 
        TRIM(fo:screen-value in frame createview).
ON WINDOW-CLOSE OF FRAME createallviews
   APPLY "END-ERROR" TO FRAME createallviews.

ON CHOOSE OF btn_File in frame createallviews DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT fo:handle in frame createallviews /*Fillin*/,
        INPUT "Find Output File"  /*Title*/,
        INPUT ""                 /*Filter*/,
        INPUT no                /*Must exist*/).
END.
ON LEAVE OF fo in frame createallviews
   fo:screen-value in frame createallviews = 
        TRIM(fo:screen-value in frame createallviews).

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN  
ON VALUE-CHANGED OF allusers IN FRAME createallviews DO:
   DEFINE VARIABLE dummyl AS LOGICAL NO-UNDO.

   IF allusers:SCREEN-VALUE = "yes" THEN DO:
        usrnm:SENSITIVE = FALSE.
        usrnm:SCREEN-VALUE = "".
   END.
   ELSE DO:
        usrnm = "".
        usrnm:SENSITIVE = TRUE.
        dummyl = usrnm:MOVE-AFTER-TAB-ITEM(allusers:HANDLE).
        APPLY "ENTRY" TO usrnm.
   END.
END.
&ENDIF

/*============================Mainline code===============================*/

DO FOR DICTDB._File:
  FIND _File "_View" WHERE _File._Owner = "PUB" NO-LOCK.
  IF NOT CAN-DO(_Can-read,USERID("DICTDB")) THEN DO:
    MESSAGE new_lang[6] VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    user_path = "".
    RETURN.
  END.
END.

FIND DICTDB._View WHERE DICTDB._View._View-name = user_env[1] NO-ERROR.
ASSIGN
  fo = (IF user_env[1] = "ALL" THEN DBNAME ELSE user_env[1]) + ".p"
  fn = (IF user_env[1] = "ALL" THEN new_lang[5] ELSE user_env[1])

allviews = IF user_env[1] = "ALL" THEN yes ELSE NO.

/* Adjust the graphical rectangle and the ok and cancel buttons */
IF allviews THEN DO:
  {adecomm/okrun.i  
     &FRAME  = "FRAME createallviews" 
     &BOX    = "rect_Btns"
     &OK     = "btn_OK" 
     {&CAN_BTN}
     {&HLP_BTN}
  }
END.
ELSE DO:
  {adecomm/okrun.i  
     &FRAME  = "FRAME createview" 
     &BOX    = "rect_Btns"
     &OK     = "btn_OK" 
     {&CAN_BTN}
     {&HLP_BTN}
  }
END.
PAUSE 0.

IF allviews THEN
  DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN  
  UPDATE
    fo btn_File
    ft
    allusers
    btn_OK 
    btn_Cancel
    {&HLP_BTN_NAME}
    WITH FRAME createallviews.
  IF allusers THEN usrnm = "ALL".
&ELSE
uidtag = new_lang[7].
usrnm = "ALL".
DISPLAY uidtag WITH FRAME createallviews.
  UPDATE
    fo btn_File
    ft
    usrnm 
    btn_OK 
    btn_Cancel
    {&HLP_BTN_NAME}
    WITH FRAME createallviews.
&ENDIF

  ASSIGN
    user_env[2] = fo  /* output file */
    user_env[3] = usrnm  /* userid */
    user_env[4] = ft. /* statement terminator */
  
  RUN "prodict/misc/_wrkvgen.p".
  canned = FALSE.

END.
ELSE DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:

  UPDATE
    fo btn_File
    ft
    btn_OK 
    btn_Cancel
    {&HLP_BTN_NAME}
    WITH FRAME createview.

  ASSIGN
    user_env[2] = fo  /* output file */
    user_env[3] = ""  /* userid */
    user_env[4] = ft. /* statement terminator */
  
  RUN "prodict/misc/_wrkvgen.p".
  canned = FALSE.
END.

HIDE FRAME createview NO-PAUSE.
HIDE FRAME createallviews NO-PAUSE.
IF canned THEN
   user_path = "".
RETURN.

