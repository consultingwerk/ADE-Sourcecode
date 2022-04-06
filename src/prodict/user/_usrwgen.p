/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* _usrwgen.p */

/* This program generates explicit WORKFILE definitions from file
definitions in the database.  These workfile definitions can then
be customized.

This is useful if you need a workfile to temporarily hold some,
but not all, of the fields in a database file. 

History: 07/09/98 D. McMann Added AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN")
                            to Find of _File
         04/13/00 D. McMann Added support for long path names
         03/05/03 D. McMann Added note about LOB's not in file.
                            
*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

DEFINE VARIABLE answer AS LOGICAL   NO-UNDO.
DEFINE VARIABLE canned AS LOGICAL   NO-UNDO INIT TRUE.
DEFINE VARIABLE fo     AS CHARACTER NO-UNDO.
{prodict/misc/filesbtn.i}

/* LANGUAGE DEPENDENCIES START */ /*----------------------------------------*/

DEFINE VARIABLE new_lang AS CHARACTER EXTENT 4 NO-UNDO INITIAL [
  /* 1*/ "You do not have permission to use this option.",
  /* 2*/ "A file named",
  /* 3*/ "already exists.",
  /* 4*/ "Overwrite it?"
].
FORM 
  SKIP({&TFM_WID})
  fo {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" AT 2 VIEW-AS FILL-IN SIZE 40 BY 1
         LABEL "Output File"
  btn_File SKIP ({&VM_WIDG})
   "NOTE:  Only Non-LOB fields will be included in the output file" AT 2
    VIEW-AS TEXT SKIP ({&VM_WIDG})
  {prodict/user/userbtns.i}
  WITH FRAME genworkf
  SIDE-LABELS CENTERED 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX 
  TITLE " Generate DEFINE WORK-TABLE for ~"" + _File._File-name + "~" ".

/* LANGUAGE DEPENDENCIES END */ /*------------------------------------------*/

/*===============================Triggers=================================*/

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
/*----- HELP -----*/
on HELP of frame genworkf
   or CHOOSE of btn_Help IN FRAME genworkf
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
      	       	     	     INPUT {&Generate_Workfile_Dlg_Box},
      	       	     	     INPUT ?).
&ENDIF


ON GO OF FRAME genworkf
DO:
  DEFINE VAR fil AS CHAR NO-UNDO.

  fil = fo:SCREEN-VALUE IN FRAME genworkf.

  IF SEARCH(fil) <> ? THEN DO:
    answer = FALSE.
    MESSAGE new_lang[2] fil new_lang[3] SKIP new_lang[4]
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer.
    IF NOT answer THEN 
    DO:
      APPLY "ENTRY" TO fo IN FRAME genworkf.
      RETURN NO-APPLY.
    END.
  END.
END.

ON CHOOSE OF btn_File in frame genworkf DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT fo:handle in frame genworkf /*Fillin*/,
        INPUT "Find Output File"  /*Title*/,
        INPUT ""                 /*Filter*/,
        INPUT no                /*Must exist*/).
END.
ON LEAVE OF fo in frame genworkf
   fo:screen-value in frame genworkf = 
        TRIM(fo:screen-value in frame genworkf).

ON WINDOW-CLOSE OF FRAME genworkf
   APPLY "END-ERROR" TO FRAME genworkf.

/*============================Mainline code===============================*/

FIND _File WHERE _File._File-name = "_File"
             AND _File._Owner = "PUB".
answer = CAN-DO(_Can-read,USERID("DICTDB")).
FIND _File WHERE _File._File-name = "_Field"
             AND _File._Owner = "PUB".
answer = answer AND CAN-DO(_Can-read,USERID("DICTDB")).
IF NOT answer THEN DO:
  MESSAGE new_lang[1] VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  user_path = "".
  RETURN.
END.

FIND _File WHERE _Db-recid = drec_db AND _File-name = user_env[1]
             AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN").

ASSIGN
  fo = LC(_File._File-name) + ".i".

/* Adjust the graphical rectangle and the ok and cancel buttons */
{adecomm/okrun.i  
    &FRAME  = "FRAME genworkf" 
    &BOX    = "rect_Btns"
    &OK     = "btn_OK" 
    {&CAN_BTN}
    {&HLP_BTN}
}
PAUSE 0.

work_loop:
DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
  UPDATE fo btn_File btn_OK btn_Cancel {&HLP_BTN_NAME} WITH FRAME genworkf.

  /* Do the work */
  user_env[1] = fo.
  RUN "prodict/misc/_wrkwgen.p".
  canned = FALSE.
END.

IF canned THEN
  user_path = "".

HIDE FRAME genworkf NO-PAUSE.
RETURN.

