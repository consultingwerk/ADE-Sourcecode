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

/* Progress Lex Converter 7.1A->7.1B Version 1.11 */

/* _usrimpo.p - get fields, etc. for import */

/*
This program does the initial for 'sylk', 'dif', 'dbase' and 'ascii'
format loads.

IN:
user_env[1]  = db filename to import
user_env[9]  = 'dif'   for dif format
             = 'sylk'  for sylk format
             = 'dbf'   for dbase format
             = 'ascii' for ascii delimited format
             = 'fixed' for ascii fixed-length field format
 
OUT: 
user_env[1]  = db filename to import
user_env[2]  = *reserved*
user_env[3]  = used for import-specific parameters
user_env[4]  = import '.dif', '.slk' or '.dbf' filename
user_env[5]  = count of field names to import
user_env[6]  = space-delimited list of field names to import
               skip-fields denoted by '^'
user_env[7]  = column ranges for 'fixed' (suitable for osquoter)
user_env[8]  = *reserved*
user_env[9]  = *reserved*
user_env[10] = "y" - disable triggers, "n" - do not disable triggers

history:  Added check to find quoter D. McMann 06/05/00

*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }
{ prodict/user/userhue.i }
{ prodict/user/userpik.i NEW }

DEFINE NEW SHARED VARIABLE pik_lower  AS INTEGER   EXTENT 2000 NO-UNDO.
DEFINE NEW SHARED VARIABLE pik_upper  AS INTEGER   EXTENT 2000 NO-UNDO.

DEFINE VARIABLE canned    AS LOGICAL INITIAL TRUE  NO-UNDO.
DEFINE VARIABLE allorsome AS LOGICAL INITIAL FALSE NO-UNDO.
DEFINE VARIABLE dis_trigs AS LOGICAL INITIAL NO    NO-UNDO.
DEFINE VARIABLE i         AS INTEGER               NO-UNDO.
DEFINE VARIABLE j         AS INTEGER               NO-UNDO.
DEFINE VARIABLE nuximode  AS LOGICAL INITIAL TRUE  NO-UNDO.
DEFINE VARIABLE typ       AS CHARACTER             NO-UNDO.
DEFINE VARIABLE upath     AS CHARACTER             NO-UNDO.
DEFINE VARIABLE importlab AS CHARACTER INITIAL "&Import File:"
  FORMAT "X(13)" NO-UNDO.
DEFINE VARIABLE msgEd     AS CHARACTER VIEW-AS EDITOR NO-BOX SIZE 55 BY 7 NO-UNDO.
  
{prodict/misc/filesbtn.i}
&IF "{&WINDOW-SYSTEM}" begins "MS-Win" &THEN
  &GLOBAL-DEFINE ARMSG_ROW_OFFSET - 0.25
&ELSE
  &GLOBAL-DEFINE ARMSG_ROW_OFFSET
&ENDIF

/* LANGUAGE DEPENDENCIES START */ /*----------------------------------------*/
DEFINE VARIABLE new_lang AS CHARACTER EXTENT 6 NO-UNDO INITIAL [
  /*1,2*/ "Fields for", "Import",
  /*  3*/ "You do not have permission to create records in this table.",
  /*  4*/ "Cannot find a file of this name.  Try again.",
  /*  5*/ "Quote marks can't be used as separators",
  /*  6*/ "(they are already the delimiters)."
].

/*------------------- FRAME import-stuff ----------------------------------*/
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
FORM
  SKIP({&TFM_WID})
  importlab AT 2 VIEW-AS TEXT NO-LABEL SKIP({&VM_WID})
  user_env[4] {&STDPH_FILL} NO-LABEL FORMAT "x(80)" AT 2 
        VIEW-AS FILL-IN SIZE 40 BY 1
  btn_File  SKIP ({&VM_WIDG})
  "Fields to Import:      " AT 2 VIEW-AS TEXT SKIP({&VM_WID})
  allorsome VIEW-AS RADIO-SET RADIO-BUTTONS "&Selected", no, "&All (Max 255)", yes
            NO-LABEL AT 2 SKIP({&VM_WIDG})
  "Database Triggers:      " AT 2 VIEW-AS TEXT SKIP({&VM_WID})
  dis_trigs VIEW-AS TOGGLE-BOX LABEL "&Disable During Import"
        AT 2
  {prodict/user/userbtns.i}
  "Note: array fields cannot be      " VIEW-AS TEXT 
        AT ROW-OF allorsome {&ARMSG_ROW_OFFSET} COLUMN 25 SKIP
  "imported, and are excluded      " VIEW-AS TEXT AT 25
  "from the selection list.      " VIEW-AS TEXT AT 25
  WITH FRAME import-stuff
  CENTERED SIDE-LABELS 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE "Import " + user_env[9].
  
  /* Added to support "Import File:" fill-in label mnemonic (tomn 8/1/95) */
  ASSIGN
    user_env[4]:SIDE-LABEL-HANDLE IN FRAME import-stuff = importlab:HANDLE
    user_env[4]:LABEL = importlab.
&ELSE

FORM
  SKIP({&TFM_WID})
  user_env[4] {&STDPH_FILL} FORMAT "x(80)" AT 2 VIEW-AS FILL-IN SIZE 40 BY 1
         LABEL "Import File"
  btn_File  SKIP ({&VM_WIDG})
  allorsome FORMAT "All/Some"
    LABEL "Import (A)ll Fields (max 255) Or (S)elected Fields" 
                                                                         AT 2                          SKIP
  "(Array fields cannot be imported and are excluded from the list)" 
                                                                         AT 4 VIEW-AS TEXT SKIP(1)

  dis_trigs LABEL "Disable Triggers During Import?" AT 2
  {prodict/user/userbtns.i}
  WITH FRAME import-stuff
  CENTERED SIDE-LABELS 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE "Import " + user_env[9].
&ENDIF

/*------------------- FRAME import-dbf ----------------------------------*/
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
FORM
  SKIP({&TFM_WID})
  importlab AT 2 VIEW-AS TEXT NO-LABEL SKIP({&VM_WID})
  user_env[4] {&STDPH_FILL} NO-LABEL FORMAT "x(80)" AT 2 
        VIEW-AS FILL-IN SIZE 40 BY 1
  btn_File  SKIP ({&VM_WIDG})
  "Fields to Import:      " AT 2 VIEW-AS TEXT SKIP({&VM_WID})
  allorsome VIEW-AS RADIO-SET RADIO-BUTTONS "&Selected", no, "&All (Max 255)", yes
            NO-LABEL AT 2 SKIP({&VM_WIDG})
  "Origin of File:      " AT 2 VIEW-AS TEXT SKIP({&VM_WID})
  nuximode VIEW-AS RADIO-SET RADIO-BUTTONS "IBM/PC or &Compatible", yes,
                                           "&Other", no
        NO-LABEL AT 2 SKIP({&VM_WIDG})
  "Database Triggers:      " AT 2 VIEW-AS TEXT SKIP({&VM_WID})
  dis_trigs VIEW-AS TOGGLE-BOX LABEL "&Disable During Import"
        AT 2
  {prodict/user/userbtns.i}
  "Note: array fields cannot be      " VIEW-AS TEXT 
        AT ROW-OF allorsome {&ARMSG_ROW_OFFSET} COLUMN 25 SKIP
  "imported, and are excluded      " VIEW-AS TEXT AT 25
  "from the selection list.      " VIEW-AS TEXT AT 25
  WITH FRAME import-dbf
  CENTERED SIDE-LABELS
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE "Import " + user_env[9].
  
  /* Added to support "Import File:" fill-in label mnemonic (tomn 8/1/95) */
  ASSIGN
    user_env[4]:SIDE-LABEL-HANDLE IN FRAME import-dbf = importlab:HANDLE
    user_env[4]:LABEL = importlab.
&ELSE

FORM
  SKIP({&TFM_WID})
  user_env[4] {&STDPH_FILL} FORMAT "x(80)" AT 2 VIEW-AS FILL-IN SIZE 40 BY 1
         LABEL "Import File"
  btn_File  SKIP(1)
  nuximode FORMAT "yes/no"
    LABEL "Originated on IBM/PC or Compatibles (Intel 80x8x)" 
                                                                         AT 2              SKIP(1)

  allorsome FORMAT "All/Some"
    LABEL "Import (A)ll Fields (max 255) Or (S)elected Fields" 
                                                                         AT 2              SKIP
  "(Array fields cannot be imported and are excluded from the list)" 
                                                                         AT 4 VIEW-AS TEXT SKIP(1)

  dis_trigs LABEL "Disable Triggers During Import?" AT 2
  {prodict/user/userbtns.i}
  WITH FRAME import-dbf
  CENTERED SIDE-LABELS
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE "Import " + user_env[9].
&ENDIF


/*------------------- FRAME import-ascii ----------------------------------*/
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
FORM
  SKIP({&TFM_WID})
  importlab AT 2 VIEW-AS TEXT NO-LABEL SKIP({&VM_WID})
  user_env[4] {&STDPH_FILL} NO-LABEL FORMAT "x(80)" AT 2 
        VIEW-AS FILL-IN SIZE 40 BY 1
  btn_File  SKIP ({&VM_WIDG})
  "Fields to Import:      " AT 2 VIEW-AS TEXT SKIP({&VM_WID})
  allorsome VIEW-AS RADIO-SET RADIO-BUTTONS "&Selected", no, "&All (Max 255)", yes
            NO-LABEL AT 2 SKIP({&VM_WIDG})
  user_env[3] {&STDPH_FILL} FORMAT "X" 
        LABEL "Field Separation &Character" AT 2 SKIP({&VM_WIDG})
  "Database Triggers:      " AT 2 VIEW-AS TEXT SKIP({&VM_WID})
  dis_trigs VIEW-AS TOGGLE-BOX LABEL "&Disable During Import" AT 2
  {prodict/user/userbtns.i}
  "Note: array fields cannot be      " VIEW-AS TEXT 
        AT ROW-OF allorsome {&ARMSG_ROW_OFFSET} COLUMN 25 SKIP
  "imported, and are excluded      " VIEW-AS TEXT AT 25
  "from the selection list.      " VIEW-AS TEXT AT 25
  WITH FRAME import-ascii
  CENTERED SIDE-LABELS
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE "Import " + user_env[9].
  
  /* Added to support "Import File:" fill-in label mnemonic (tomn 8/1/95) */
  ASSIGN
    user_env[4]:SIDE-LABEL-HANDLE IN FRAME import-ascii = importlab:HANDLE
    user_env[4]:LABEL = importlab.
&ELSE

FORM
  SKIP({&TFM_WID})
  user_env[4] {&STDPH_FILL} FORMAT "x(80)" AT 2 VIEW-AS FILL-IN SIZE 40 BY 1
         LABEL "Import File"
  btn_File  SKIP ({&VM_WID})
  SKIP(1)
  user_env[3] FORMAT "x" LABEL "Field Separation Character"
                                                                         AT 2              SKIP(1)
  allorsome FORMAT "All/Some"
    LABEL "Import (A)ll Fields (max 255) Or (S)elected Fields" 
                                                                         AT 2                          SKIP
  "(Array fields cannot be imported and are excluded from the list)" 
                                                                         AT 4 VIEW-AS TEXT SKIP(1)

  dis_trigs LABEL "Disable Triggers During Import?" AT 2
  {prodict/user/userbtns.i}
  WITH FRAME import-ascii
  CENTERED SIDE-LABELS
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX TITLE "Import " + user_env[9].
&ENDIF

                              
/*------------------- FRAME import-fixed ----------------------------------*/
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
FORM
  SKIP({&TFM_WID})
  importlab AT 2 VIEW-AS TEXT NO-LABEL SKIP({&VM_WID})
  user_env[4] {&STDPH_FILL} NO-LABEL FORMAT "x(80)" AT 2 
        VIEW-AS FILL-IN 
&IF "{&WINDOW-SYSTEM}" begins "MS-Win" &THEN  
  SIZE 43 BY 1
&ELSE
  SIZE 51 BY 1
&ENDIF
  btn_File  SKIP ({&VM_WIDG})
  "Database Triggers:      " AT 2 VIEW-AS TEXT SKIP({&VM_WID})
  dis_trigs VIEW-AS TOGGLE-BOX LABEL "&Disable During Import"
        AT 2 SKIP({&VM_WIDG})
  msgEd NO-LABEL AT 2 SKIP  
  {prodict/user/userbtns.i}

  WITH FRAME import-fixed
  CENTERED SIDE-LABELS
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel 
  VIEW-AS DIALOG-BOX TITLE "Import " + user_env[9].

/* Setup the message */
ASSIGN
  msgEd:SCREEN-VALUE = "After leaving this form, you will be presented with a scrolling " + 
                   "list of all fields in this table.  For each field there are two "   + 
                   "fill-in areas for entering the starting and ending columns that "   +  
                   "correspond to the position of that field's data in the text "       + 
                   "file.  If you do not want a particular field to be imported "       + 
                   "leave these values blank."                     + CHR(10) + CHR(10) +
                   "Note: array fields cannot be imported and are excluded from the list."
  msgEd:READ-ONLY    = YES.
  
  /* Added to support "Import File:" fill-in label mnemonic (tomn 8/1/95) */
  ASSIGN
    user_env[4]:SIDE-LABEL-HANDLE IN FRAME import-fixed = importlab:HANDLE
    user_env[4]:LABEL = importlab.
&ELSE
FORM
  SKIP({&TFM_WID})
  user_env[4] {&STDPH_FILL} FORMAT "x(80)" AT 2 VIEW-AS FILL-IN SIZE 40 BY 1
         LABEL "Import File"
  btn_File SKIP(1)
  dis_trigs LABEL "Disable Triggers During Import?"                   AT 2 SKIP(1)
  "After leaving this form, you will be presented with a scrolling"   AT 2 VIEW-AS TEXT SKIP
  "list of all fields in this table.  For each field there are two"   AT 2 VIEW-AS TEXT SKIP
  "fill-in areas for entering the starting and ending columns that"   AT 2 VIEW-AS TEXT SKIP
  "correspond to the position of that field's data in the text"       AT 2 VIEW-AS TEXT SKIP
  "file.  If you do not want a particular field to be imported"       AT 2 VIEW-AS TEXT SKIP
  "leave these values blank."                                         AT 2 VIEW-AS TEXT
  SKIP({&VM_WIDG})
  "Note: array fields cannot be imported and are excluded from the list."  AT 2 VIEW-AS TEXT
  {prodict/user/userbtns.i}

  WITH FRAME import-fixed
  ROW 2 SIDE-LABELS
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel 
  VIEW-AS DIALOG-BOX TITLE "Import " + user_env[9].
&ENDIF

/* LANGUAGE DEPENDENCIES END */ /*------------------------------------------*/


/*==========================Internal Procedures=========================*/

/*----------------------------------------------------------
   Do frame validation when user hits OK or GO.

   Input Parameter: 
      p_file    = name of file to import from      
      p_disable = disable trigger widget (yes or no)

   Returns: "error" or "".
----------------------------------------------------------*/
PROCEDURE Validate_Frame:
   DEFINE INPUT PARAMETER p_file    AS WIDGET-HANDLE NO-UNDO.
   DEFINE INPUT PARAMETER p_disable AS WIDGET-HANDLE NO-UNDO.

   DEFINE VARIABLE ok AS LOGICAL NO-UNDO.

   /* See if user has permission to import with triggers
      disabled.  If not, ask if he wants to continue
      anyway.
   */
   IF p_disable:SCREEN-VALUE = "yes" THEN
   DO:
      {prodict/dump/ltrigchk.i &OK = ok}
      IF NOT ok THEN DO:
         MESSAGE "You do not have permission to import" SKIP 
                 "with triggers disabled."
                 VIEW-AS ALERT-BOX ERROR BUTTON OK.
         p_disable:SCREEN-VALUE = "no".
         RETURN "error".
      END.
   END.

  IF SEARCH(p_file:SCREEN-VALUE) = ? THEN DO:
    MESSAGE new_lang[4] VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    APPLY "ENTRY" TO p_file.
    RETURN "error".
  END.

  RETURN "".
END.


/*==============================Triggers================================*/

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
/*----- HELP -----*/
on HELP of frame import-stuff
   or CHOOSE of btn_Help in frame import-stuff
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
                                               INPUT {&Import_Stuff_Dlg_Box},
                                               INPUT ?).

on HELP of frame import-dbf
   or CHOOSE of btn_Help in frame import-dbf
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
                                               INPUT {&Import_dBase_File_Contents_Dlg_Box},
                                               INPUT ?).

on HELP of frame import-ascii
   or CHOOSE of btn_Help in frame import-ascii
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
                                               INPUT {&Import_Delimited_ASCII_Dlg_Box},
                                               INPUT ?).

on HELP of frame import-fixed
   or CHOOSE of btn_Help in frame import-fixed
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
                                               INPUT {&Import_Fixed_Length_Dlg_Box},
                                               INPUT ?).
&ENDIF

/*----- ON GO or OK -----*/
ON GO OF FRAME import-stuff
DO:
  run Validate_Frame (INPUT user_env[4]:HANDLE IN FRAME import-stuff,
                                   INPUT dis_trigs:HANDLE IN FRAME import-stuff).
  if RETURN-VALUE = "error" THEN
     RETURN NO-APPLY.
END.

ON GO OF FRAME import-dbf
DO:
  run Validate_Frame (INPUT user_env[4]:HANDLE IN FRAME import-dbf,
                                   INPUT dis_trigs:HANDLE IN FRAME import-dbf).
  if RETURN-VALUE = "error" THEN
     RETURN NO-APPLY.
END.

ON GO OF FRAME import-ascii
DO:
  ASSIGN INPUT FRAME import-ascii user_env[3].
  IF user_env[3] = '"' OR user_env[3] = "'" THEN DO:
    MESSAGE new_lang[5] SKIP new_lang[6] VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    APPLY "ENTRY" TO user_env[3] IN FRAME import-ascii.
    RETURN NO-APPLY.
  END.

  run Validate_Frame (INPUT user_env[4]:HANDLE IN FRAME import-ascii,
                                   INPUT dis_trigs:HANDLE IN FRAME import-ascii).
  if RETURN-VALUE = "error" THEN
     RETURN NO-APPLY.
END.

ON GO OF FRAME import-fixed
DO:
  run Validate_Frame (INPUT user_env[4]:HANDLE IN FRAME import-fixed,
                                   INPUT dis_trigs:HANDLE IN FRAME import-fixed).
  if RETURN-VALUE = "error" THEN
     RETURN NO-APPLY.
END.

ON WINDOW-CLOSE OF FRAME import-stuff
   APPLY "END-ERROR" TO FRAME import-stuff.
ON WINDOW-CLOSE OF FRAME import-dbf
   APPLY "END-ERROR" TO FRAME import-dbf.
ON WINDOW-CLOSE OF FRAME import-ascii
   APPLY "END-ERROR" TO FRAME import-ascii.
ON WINDOW-CLOSE OF FRAME import-fixed
   APPLY "END-ERROR" TO FRAME import-fixed.

/*----- HIT of FILE BUTTON -----*/
ON CHOOSE OF btn_File in frame import-stuff DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT user_env[4]:handle in frame import-stuff /*Fillin*/,
        INPUT "Find Input File"  /*Title*/,
        INPUT ""                 /*Filter*/,
        INPUT yes                /*Must exist*/).
END.
ON CHOOSE OF btn_File in frame import-ascii DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT user_env[4]:handle in frame import-ascii /*Fillin*/,
        INPUT "Find Input File"  /*Title*/,
        INPUT ""                 /*Filter*/,
        INPUT yes                /*Must exist*/).
END.
ON CHOOSE OF btn_File in frame import-fixed DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT user_env[4]:handle in frame import-fixed /*Fillin*/,
        INPUT "Find Input File"  /*Title*/,
        INPUT ""                 /*Filter*/,
        INPUT yes                /*Must exist*/).
END.
ON CHOOSE OF btn_File in frame import-dbf DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT user_env[4]:handle in frame import-dbf /*Fillin*/,
        INPUT "Find Input File"  /*Title*/,
        INPUT ""                 /*Filter*/,
        INPUT yes                /*Must exist*/).
END.

/*----- LEAVE of fill-ins: trim blanks the user may have typed in filenames---*/
ON LEAVE OF user_env[4] in frame import-stuff
   user_env[4]:screen-value in frame import-stuff = 
        TRIM(user_env[4]:screen-value in frame import-stuff).
ON LEAVE OF user_env[4] in frame import-ascii
   user_env[4]:screen-value in frame import-ascii = 
        TRIM(user_env[4]:screen-value in frame import-ascii).
ON LEAVE OF user_env[4] in frame import-fixed
   user_env[4]:screen-value in frame import-fixed = 
        TRIM(user_env[4]:screen-value in frame import-fixed).
ON LEAVE OF user_env[4] in frame import-dbf
   user_env[4]:screen-value in frame import-dbf = 
        TRIM(user_env[4]:screen-value in frame import-dbf).


/*=================================Mainline code==========================*/

FIND _File WHERE RECID(_File) = drec_file.

IF NOT CAN-DO(_File._Can-create,USERID(user_dbname)) THEN DO:
  MESSAGE new_lang[3] VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  user_path =  "".
  RETURN.
END.

IF CAN-DO("MSDOS,WIN32",OPSYS) THEN DO: 
  IF SEARCH("quoter.exe") = ? THEN DO:
    MESSAGE "Unable to find the quoter utility.  Make sure that" SKIP
            "Progress' bin directory is in your PATH." SKIP
    VIEW-AS ALERT-BOX ERROR.
    ASSIGN user_path = "".
    RETURN.
  END.
END.
ELSE  IF OPSYS = "UNIX" THEN DO: 
  IF SEARCH("quoter") = ? THEN DO:
    MESSAGE "Unable to find the quoter utility.  Make sure that" SKIP
            "Progress' bin directory is in your PATH." SKIP
    VIEW-AS ALERT-BOX ERROR.
    ASSIGN user_path = "".
    RETURN.
  END.
END.

ASSIGN
  typ         = user_env[9]
  user_env[2] = ""  /* reserved for child to call _lodsddl.p */
  user_env[3] = ""
  user_env[6] = ""
  user_env[7] = ""
  user_env[8] = "" /* reserved for child to call _lodsddl.p */
  user_env[9] = CAPS(typ).

/* Adjust the graphical rectangle and the ok and cancel buttons */
IF typ = "dbf" THEN DO:
  {adecomm/okrun.i  
      &FRAME  = "FRAME import-dbf" 
      &BOX    = "rect_Btns"
      &OK     = "btn_OK" 
      {&CAN_BTN}
      {&HLP_BTN}
  }
END.
ELSE IF typ = "ascii" THEN DO:
  {adecomm/okrun.i  
      &FRAME  = "FRAME import-ascii" 
      &BOX    = "rect_Btns"
      &OK     = "btn_OK" 
      {&CAN_BTN}
      {&HLP_BTN}
  }
END.
ELSE IF typ = "fixed" THEN DO:
  {adecomm/okrun.i  
      &FRAME  = "FRAME import-fixed" 
      &BOX    = "rect_Btns"
      &OK     = "btn_OK" 
      {&CAN_BTN}
      {&HLP_BTN}
  }
END.
ELSE DO:
  {adecomm/okrun.i  
      &FRAME  = "FRAME import-stuff" 
      &BOX    = "rect_Btns"
      &OK     = "btn_OK" 
      {&CAN_BTN}
      {&HLP_BTN}
  }
END.

IF typ = "dif" THEN DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
  ASSIGN
    user_env[4] = user_env[1] + ".dif"
    pik_title   = new_lang[1] + " DIF " + new_lang[2].
  DO ON ERROR UNDO,RETRY:
    UPDATE
      user_env[4] /*destinf*/ btn_File
      allorsome
      dis_trigs
      btn_OK btn_Cancel {&HLP_BTN_NAME}
      WITH FRAME import-stuff.
    IF SEARCH(user_env[4]) = ? THEN DO:
      MESSAGE new_lang[4]. /* file not found */
      UNDO,RETRY.
    END.
    canned = FALSE.
  END.
END.
ELSE
IF typ = "sylk" THEN DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
  ASSIGN
    user_env[4] = user_env[1] + ".slk"
    pik_title   = new_lang[1] + " SYLK " + new_lang[2].
  DO ON ERROR UNDO,RETRY:
    UPDATE
      user_env[4] /*destinf*/ btn_File
      allorsome
      dis_trigs
      btn_OK btn_Cancel {&HLP_BTN_NAME}
      WITH FRAME import-stuff.
    IF SEARCH(user_env[4]) = ? THEN DO:
      MESSAGE new_lang[4]. /* file not found */
      UNDO,RETRY.
    END.
    canned = FALSE.
  END.
END.
ELSE
IF typ = "dbf" THEN DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
  ASSIGN
    user_env[4] = user_env[1] + ".dbf"
    user_env[9] = "dBase File Contents"
    pik_title   = new_lang[1] + " " + user_env[9] + " " + new_lang[2].
  DO ON ERROR UNDO,RETRY:
    UPDATE
      user_env[4] /*destinf*/ btn_File
      nuximode
      allorsome
      dis_trigs
      btn_OK btn_Cancel {&HLP_BTN_NAME}
      WITH FRAME import-dbf.
    IF SEARCH(user_env[4]) = ? THEN DO:
      MESSAGE new_lang[4]. /* file not found */
      UNDO,RETRY.
    END.
    canned = FALSE.
  END.
  user_env[3] = STRING(nuximode,"1/0").
END.
ELSE
IF typ = "ascii" THEN DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
  ASSIGN
    user_env[3] = "," /* delimiter */
    user_env[4] = user_env[1] + ".txt"
    user_env[7] = ?
    user_env[9] = "Delimited Text"
    pik_title   = new_lang[1] + " " + user_env[9] + " " + new_lang[2].
  DO ON ERROR UNDO,RETRY:
    UPDATE
      user_env[4] /*destinf*/ btn_File
      user_env[3] /*delimiter*/
      allorsome
      dis_trigs
      btn_OK btn_Cancel {&HLP_BTN_NAME}
      WITH FRAME import-ascii.
    IF SEARCH(user_env[4]) = ? THEN DO:
      MESSAGE new_lang[4]. /* file not found */
      UNDO,RETRY.
    END.
    canned = FALSE.
  END.
END.
ELSE
IF typ = "fixed" THEN DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
  ASSIGN
    user_env[3] = ?
    user_env[4] = user_env[1] + ".dat"
    user_env[9] = "Fixed-Length"
    pik_title   = new_lang[1] + " " + user_env[9] + " " + new_lang[2].
  DO ON ERROR UNDO,RETRY:
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
    ENABLE msgEd WITH FRAME import-fixed.
&ENDIF
    UPDATE
      user_env[4] /*destinf*/ btn_File
      dis_trigs 
      btn_OK btn_Cancel {&HLP_BTN_NAME}
      WITH FRAME import-fixed.
    IF SEARCH(user_env[4]) = ? THEN DO:
      MESSAGE new_lang[4]. /* file not found */
      UNDO,RETRY.
    END.
    canned = FALSE.
  END.
END.

IF canned THEN DO:
  user_path = "".
  HIDE FRAME import-stuff NO-PAUSE.
  HIDE FRAME import-dbf   NO-PAUSE.
  HIDE FRAME import-ascii NO-PAUSE.
  HIDE FRAME import-fixed NO-PAUSE.
  HIDE MESSAGE NO-PAUSE.
  RETURN.
END.

user_env[10] = (if dis_trigs then "y" else "n").

IF typ = "fixed" THEN DO:
  FOR EACH _Field OF _File WHERE _Field._Extent = 0 BY _Field._Order:
    ASSIGN
      pik_count = pik_count + 1
      pik_list[pik_count] = _Field._Field-name.
  END.
  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN 
    RUN "prodict/user/_usrfixd.p".
  &ELSE
    RUN "prodict/gui/_guifixd.p".
  &ENDIF
  DO j = 1 TO pik_count:
    IF pik_lower[j] = 0 OR pik_upper[j] = 0 THEN NEXT.
    ASSIGN
      i           = i + 1
      user_env[6] = user_env[6] + (IF i = 1 THEN "" ELSE " ") + pik_list[j]
      user_env[7] = user_env[7]
                  + (IF user_env[7] = "" THEN "" ELSE ",")
                  + STRING(pik_lower[j])
                  + (IF pik_upper[j] = pik_lower[j] THEN ""
                    ELSE "-" + STRING(pik_upper[j])).
    IF i = 255 THEN LEAVE.
  END.
  user_env[5] = STRING(i).
END.
ELSE
IF allorsome THEN DO:
  FOR EACH _Field OF _File WHERE _Field._Extent = 0
    BY _Field._Order:
    ASSIGN
      i = i + 1
      user_env[6] = user_env[6]
                  + (IF i = 1 THEN "" ELSE " ")
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
    pik_skip   = TRUE.
  FOR EACH _Field OF _File WHERE _Field._Extent = 0 BY _Field._Order:
    ASSIGN
      pik_count = pik_count + 1
      pik_list[pik_count] = _Field._Field-name.
  END.
  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
    RUN "prodict/user/_usrpick.p".
  &ELSE
    pik_help = {&Fields_For_Import_Dlg_Box}.
    RUN "prodict/gui/_guipick.p".
  &ENDIF
  pik_return = MINIMUM(pik_return,255).
  DO i = 1 TO pik_return:
    user_env[6] = user_env[6]
                + (IF i = 1 THEN "" ELSE " ")
                + (IF pik_chosen[i] = -1 THEN "^"
                  ELSE pik_list[pik_chosen[i]]).
  END.
  user_env[5] = STRING(pik_return).
END.

IF user_env[6] = "" THEN user_path = "".

{ prodict/dictnext.i upath }

HIDE FRAME import-stuff NO-PAUSE.
HIDE FRAME import-dbf   NO-PAUSE.
HIDE FRAME import-ascii NO-PAUSE.
HIDE FRAME import-fixed NO-PAUSE.
RETURN.

