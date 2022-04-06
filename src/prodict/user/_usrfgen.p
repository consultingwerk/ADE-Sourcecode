/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* This program generates explicit FRAME definitions from file
definitions in the database.  These frame definitions can then
be customized.

This is especially useful if the default frame for a file won't
fit completely on the screen.  This program allows you to make
a form statement up that matches the default frame, and then you
can remove the fields that are not necessary. 

D. McMann 04/13/00 Added support for long path name
D. McMann 03/05/03 Added support for blocking LOB fields

*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

DEFINE VARIABLE answer AS LOGICAL                 NO-UNDO.
DEFINE VARIABLE canned AS LOGICAL   INITIAL TRUE  NO-UNDO.
DEFINE VARIABLE fa     AS LOGICAL   INITIAL TRUE  NO-UNDO.
DEFINE VARIABLE fl     AS LOGICAL   INITIAL FALSE NO-UNDO.
DEFINE VARIABLE fm     AS LOGICAL   INITIAL FALSE NO-UNDO.
DEFINE VARIABLE fo     AS CHARACTER               NO-UNDO.
DEFINE VARIABLE fq     AS LOGICAL   INITIAL FALSE NO-UNDO.
DEFINE VARIABLE fs     AS LOGICAL   INITIAL TRUE  NO-UNDO.
DEFINE VARIABLE ft     AS CHAR      INITIAL "N" NO-UNDO.
DEFINE VARIABLE fv     AS LOGICAL   INITIAL TRUE  NO-UNDO.
DEFINE VARIABLE diff   AS DECIMAL                 NO-UNDO.
DEFINE VARIABLE lablhndl AS WIDGET-HANDLE         NO-UNDO.
{prodict/misc/filesbtn.i}

/* LANGUAGE DEPENDENCIES START */ /*----------------------------------------*/
DEFINE VARIABLE new_lang AS CHARACTER EXTENT 4 NO-UNDO INITIAL [
  /* 1*/ "A file named",
  /* 2*/ "already exists.",
  /* 3*/ "Overwrite it?",
  /* 4*/ "You do not have permission to use this option."
].
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
&IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN  
&GLOBAL-DEFINE COL2COLON 43
&GLOBAL-DEFINE COL2LEFT  30
&GLOBAL-DEFINE COL1COLON 12
&GLOBAL-DEFINE FILLCH    36
&ELSE
&GLOBAL-DEFINE COL2COLON 42
&GLOBAL-DEFINE COL2LEFT  29
&GLOBAL-DEFINE COL1COLON 12
&GLOBAL-DEFINE FILLCH    32
&ENDIF
FORM 
  SKIP({&TFM_WID})
  fo {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" AT 2 VIEW-AS FILL-IN SIZE {&FILLCH} BY 1
         LABEL "Output File"
  btn_File SKIP ({&VM_WIDG})
  fq VIEW-AS TOGGLE-BOX LABEL "Fully Qualified Names" AT 2
  fa VIEW-AS TOGGLE-BOX LABEL "Fully Expanded Arrays" COLON {&COL2LEFT} 
        SKIP({&VM_WIDG})
  fl VIEW-AS RADIO-SET RADIO-BUTTONS 
        "Dictionary", yes, "Explicit", no, "None", ?
        LABEL "Labeling" COLON {&COL1COLON}
  fs VIEW-AS RADIO-SET RADIO-BUTTONS "Side", yes, "Top", no, "None", ?
        LABEL "Labels" COLON {&COL2COLON} SKIP({&VM_WIDG})
  fv VIEW-AS RADIO-SET RADIO-BUTTONS 
        "Dictionary", yes, "Explicit", no, "None", ?
        LABEL "Validation" COLON {&COL1COLON} SKIP({&VM_WIDG})
  fm VIEW-AS RADIO-SET RADIO-BUTTONS "Dictionary", yes, "Explicit", no
     LABEL "Formatting" COLON {&COL1COLON} SKIP ({&VM_WIDG})
    "NOTE:  Only Non-LOB fields will be included in the output file" AT 2
    VIEW-AS TEXT SKIP ({&VM_WIDG})
  {prodict/user/userbtns.i}
  ft VIEW-AS RADIO-SET RADIO-BUTTONS "Normal", "N", "Dialog-Box", "D", 
        "Overlay", "O", "Top-only", "T"
       LABEL "Frame Type" AT ROW-OF fv COLUMN-OF fv /*Adjust horiz later*/

  WITH FRAME genframe
  SIDE-LABELS CENTERED 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE " Generate FORM for ~"" + user_env[1] + "~" ".
&ELSE
FORM 
  SKIP({&TFM_WID})
  fo {&STDPH_FILL} FORMAT "x({&PATH_WIDG})" COLON 13 VIEW-AS FILL-IN SIZE 40 BY 1
         LABEL "Output File"
  btn_File SKIP ({&VM_WIDG})
  fq FORMAT "Yes/No"    LABEL "Fully Qualify Names?" COLON 23 SKIP(0.1)
  fa FORMAT "Yes/No"    LABEL "Fully Expand Arrays?" COLON 23 SKIP(1)
  ft FORMAT "X(1)"  LABEL "Frame Type"           COLON 13
    "(N)ormal/(D)ialog/(O)verlay/(T)op-Only"         AT    22 SKIP(0.1)
  fm FORMAT "Dict/Expl" LABEL "Formatting"           COLON 13
    "Dictionary/Explicit"                                        AT    22 SKIP
  fv FORMAT "Dict/Expl" LABEL "Validation"           COLON 13
    "Dictionary/Explicit/?=None"                                 AT    22 SKIP
  fl FORMAT "Dict/Expl" LABEL "Labeling"             COLON 13
    "Dictionary/Explicit/?=None"                     AT    22 SKIP 
  fs FORMAT "Side/Top"  LABEL "Labels"               COLON 13
    "Side/Top/?=None"                                AT    22 SKIP(1)
   "NOTE:  Only Non-LOB fields will be included in the output file" AT 2
    VIEW-AS TEXT SKIP ({&VM_WIDG})
  {prodict/user/userbtns.i}
  WITH FRAME genframe
  SIDE-LABELS CENTERED 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE " Generate FORM for ~"" + user_env[1] + "~" ".
&ENDIF
/* LANGUAGE DEPENDENCIES END */ /*------------------------------------------*/

/*===============================Triggers=================================*/

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
/*----- HELP -----*/
on HELP of frame genframe
   or CHOOSE of btn_Help in frame genframe
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
                                               INPUT {&Generate_Form_Dlg_Box},
                                               INPUT ?).
&ENDIF


ON GO OF FRAME genframe
DO:
  DEFINE VAR fil AS CHAR NO-UNDO.

  fil = fo:SCREEN-VALUE IN FRAME genframe.

  IF SEARCH(fil) <> ? THEN DO:
    answer = FALSE.
    MESSAGE new_lang[1] fil new_lang[2] SKIP new_lang[3]
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer.
    IF NOT answer THEN 
    DO:
      APPLY "ENTRY" TO fo IN FRAME genframe.
      RETURN NO-APPLY.
    END.
  END.

  IF fl:SCREEN-VALUE IN FRAME genframe = ? OR 
     fs:SCREEN-VALUE IN FRAME genframe = ? THEN DO:
    ASSIGN fl = ? fs = ?.
    DISPLAY fl fs WITH FRAME genframe.
  END.
END.

ON CHOOSE OF btn_File in frame genframe DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT fo:handle in frame genframe /*Fillin*/,
        INPUT "Find Output File"  /*Title*/,
        INPUT ""                 /*Filter*/,
        INPUT no                /*Must exist*/).
END.
ON LEAVE OF fo in frame genframe
   fo:screen-value in frame genframe = 
        TRIM(fo:screen-value in frame genframe).

ON WINDOW-CLOSE OF FRAME genframe
   APPLY "END-ERROR" TO FRAME genframe.



/*============================Mainline code===============================*/

DO FOR DICTDB._File:
  FIND _File "_File".
  answer = CAN-DO(_Can-read,USERID("DICTDB")).
  FIND _File "_Field".
  answer = answer AND CAN-DO(_Can-read,USERID("DICTDB")).
  IF NOT answer THEN DO:
    MESSAGE new_lang[4] VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    user_path = "".
    RETURN.
  END.
END.

PAUSE 0.
ASSIGN
  fo = LC(user_env[1]) + ".f".

DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN  
  /*Have to move ft over so its colon lines up with the fs guy--alas,
  form statement doesn't allow ROW-OF fv COLON {&COL2COLON}*/
  ASSIGN 
    FRAME genframe:width = FRAME genframe:width + 2
    diff = fs:COLUMN - ft:COLUMN
    ft:COLUMN = fs:COLUMN
    lablhndl = ft:SIDE-LABEL-HANDLE
    lablhndl:COLUMN = lablhndl:COLUMN + diff.
&ENDIF

  /* Adjust the graphical rectangle and the ok and cancel buttons */
  {adecomm/okrun.i  
    &FRAME  = "FRAME genframe" 
    &BOX    = "rect_Btns"
    &OK     = "btn_OK" 
    {&CAN_BTN}
    {&HLP_BTN}
  }
UPDATE fo btn_File fq fa ft fm fv fl fs 
               btn_OK btn_Cancel {&HLP_BTN_NAME}
         WITH FRAME genframe.

  /* Do the work */
  ASSIGN
    user_env[1] = fo
    user_env[2] = STRING(fq,"Y/N")
    user_env[3] = STRING(fa,"Y/N")
    user_env[4] = STRING(fm,"N/Y")
    user_env[5] = STRING(fv,"D/E")
    user_env[6] = STRING(fl,"D/E")
    user_env[7] = (IF fs THEN "S" ELSE IF NOT fs THEN "T" ELSE "N")
    user_env[8] = ft.
  
  RUN "prodict/misc/_wrkfgen.p".
  canned = FALSE.
END.

IF canned THEN
  user_path = "".

HIDE FRAME genframe NO-PAUSE.
RETURN.

