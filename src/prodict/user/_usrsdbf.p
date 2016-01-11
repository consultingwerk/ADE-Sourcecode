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

/* usersdbf - translate dbase .dbf and .ndx into .df file

   History:  07/14/98 DLM Added _Owner to _File finds
   
 */

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

DEFINE VARIABLE i       AS INTEGER              NO-UNDO.
DEFINE VARIABLE msg-num AS INTEGER INITIAL 0    NO-UNDO.
DEFINE VARIABLE nuxi    AS LOGICAL INITIAL TRUE NO-UNDO.
DEFINE VARIABLE scrap   AS CHARACTER            NO-UNDO.
DEFINE VARIABLE canned  AS LOGICAL INITIAL TRUE NO-UNDO.
{prodict/misc/filesbtn.i &NAME = btn_File1}
{prodict/misc/filesbtn.i &NAME = btn_File4}
{prodict/misc/filesbtn.i &NAME = btn_File5}
{prodict/misc/filesbtn.i &NAME = btn_File6}
{prodict/misc/filesbtn.i &NAME = btn_File7}
{prodict/misc/filesbtn.i &NAME = btn_File8}
{prodict/misc/filesbtn.i &NAME = btn_File9}
{prodict/misc/filesbtn.i &NAME = btn_File10}
{prodict/misc/filesbtn.i &NAME = btn_File11}
{prodict/misc/filesbtn.i &NAME = btn_File12}
{prodict/misc/filesbtn.i &NAME = btn_File13}

/* LANGUAGE DEPENDENCIES START */ /*---------------------------------------*/
DEFINE VARIABLE new_lang AS CHARACTER EXTENT 3 NO-UNDO INITIAL [
  /* 1*/ "Cannot find file",
  /* 2*/ "The dictionary is in read-only mode - alterations not allowed.",
  /* 3*/ "You do not have permission to use this option."
].
&IF "{&WINDOW-SYSTEM}" begins "MS-Win" &THEN
&GLOBAL-DEFINE LINEUP 14
&ELSE
&GLOBAL-DEFINE LINEUP 16
&ENDIF
FORM
  SKIP({&TFM_WID})
  user_env[1] {&STDPH_FILL} FORMAT "x(80)" VIEW-AS FILL-IN SIZE 49 BY 1 
        COLON {&LINEUP} LABEL "&dBASE File"
  btn_File1 SKIP({&VM_WIDG})
  user_env[4] {&STDPH_FILL} FORMAT "x(80)" VIEW-AS FILL-IN SIZE 49 BY 1 
        COLON {&LINEUP} LABEL "Index File #&1"
  btn_File4 SKIP ({&VM_WID})
  user_env[5] {&STDPH_FILL} FORMAT "x(80)" VIEW-AS FILL-IN SIZE 49 BY 1 
        COLON {&LINEUP} LABEL "Index File #&2"
  btn_File5 SKIP ({&VM_WID})
  user_env[6] {&STDPH_FILL} FORMAT "x(80)" VIEW-AS FILL-IN SIZE 49 BY 1 
        COLON {&LINEUP} LABEL "Index File #&3"
  btn_File6 SKIP ({&VM_WID})
  user_env[7] {&STDPH_FILL} FORMAT "x(80)" VIEW-AS FILL-IN SIZE 49 BY 1 
        COLON {&LINEUP}  LABEL "Index File #&4"
  btn_File7 SKIP ({&VM_WID})
  user_env[8] {&STDPH_FILL} FORMAT "x(80)" VIEW-AS FILL-IN SIZE 49 BY 1 
        COLON {&LINEUP} LABEL "Index File #&5"
  btn_File8 SKIP ({&VM_WID})
  user_env[9] {&STDPH_FILL} FORMAT "x(80)" VIEW-AS FILL-IN SIZE 49 BY 1 
        COLON {&LINEUP} LABEL "Index File #&6"
  btn_File9 SKIP ({&VM_WID})
  user_env[10] {&STDPH_FILL} FORMAT "x(80)" VIEW-AS FILL-IN 
        SIZE 49 BY 1 LABEL "Index File #&7" COLON {&LINEUP}
  btn_File10 SKIP ({&VM_WID})
  user_env[11] {&STDPH_FILL} FORMAT "x(80)" VIEW-AS FILL-IN 
        SIZE 49 BY 1 LABEL "Index File #&8" COLON {&LINEUP}
  btn_File11 SKIP ({&VM_WID})
  user_env[12] {&STDPH_FILL} FORMAT "x(80)" VIEW-AS FILL-IN 
        SIZE 49 BY 1 LABEL "Index File #&9" COLON {&LINEUP}
  btn_File12 SKIP ({&VM_WID})
  user_env[13] {&STDPH_FILL} FORMAT "x(80)" VIEW-AS FILL-IN 
        SIZE 49 BY 1 LABEL "Index File #1&0" COLON {&LINEUP}
  btn_File13 SKIP({&VM_WIDG})
  "If there are more than 10 index files, this dialog           "
                                                                     COLON {&LINEUP} VIEW-AS TEXT 
  "can be used again to import the additional indexes           "
                                                                      COLON {&LINEUP}  VIEW-AS TEXT 
  "(this will not harm the existing definition).            " 
                                        COLON {&LINEUP} VIEW-AS TEXT
  {prodict/user/userbtns.i}
  WITH FRAME dbdefs 
  CENTERED SIDE-LABELS 
  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
  VIEW-AS DIALOG-BOX 
  TITLE " Import dBASE II, III, III+ and IV Definitions ".

/* LANGUAGE DEPENDENCIES END */ /*-----------------------------------------*/


/*===============================Triggers=================================*/

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
/*----- HELP -----*/
on HELP of frame dbdefs
   or CHOOSE of btn_Help in frame dbdefs
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
                                               INPUT {&Import_dBase_Definitions_Dlg_Box},
                                               INPUT ?).
&ENDIF


ON GO OF FRAME dbdefs
DO:
  DEFINE VAR in_fil AS CHAR NO-UNDO.
  DEFINE VAR fil    AS CHAR NO-UNDO.

  fil_loop:
  DO i = 1 TO 13:
    IF i = 2 THEN i = 4. /* skip to iteration 4, i will increment from there */
    in_fil = INPUT FRAME dbdefs user_env[i].
   
    /* If blank or a file that's found, it's good - except for the first
       one which can't be blank.
    */
    IF (in_fil = "" AND i > 1) OR SEARCH(in_fil) <> ? THEN NEXT fil_loop.

    IF in_fil <> "" THEN DO:
      /* Otherwise tack on the proper extension and look again */
      fil = in_fil + (IF i = 1 THEN ".dbf" ELSE ".ndx").
      IF SEARCH(fil) <> ? THEN DO:
        DISPLAY fil @ user_env[i] WITH FRAME dbdefs.
        NEXT fil_loop.
      END.
  
      /* Still not found - try upper case extension */
      fil = in_fil + (IF i = 1 THEN ".DBF" ELSE ".NDX").
      IF SEARCH(fil) <> ? THEN DO:
        DISPLAY fil @ user_env[i] WITH FRAME dbdefs.
        NEXT fil_loop.
      END.
    END.

    MESSAGE new_lang[1] (in_fil) /* can't find fil ... */
                  VIEW-AS ALERT-BOX ERROR BUTTONS OK.
   
    /* I should be able to do this: APPLY "ENTRY" TO user_env[i] IN FRAME..
       but it doesn't let me! - it wants a constant subscript so:
    */
    CASE i:
      WHEN 1  THEN APPLY "ENTRY" TO user_env[1]  IN FRAME dbdefs.
      WHEN 4  THEN APPLY "ENTRY" TO user_env[4]  IN FRAME dbdefs.
      WHEN 5  THEN APPLY "ENTRY" TO user_env[5]  IN FRAME dbdefs.
      WHEN 6  THEN APPLY "ENTRY" TO user_env[6]  IN FRAME dbdefs.
      WHEN 7  THEN APPLY "ENTRY" TO user_env[7]  IN FRAME dbdefs.
      WHEN 8  THEN APPLY "ENTRY" TO user_env[8]  IN FRAME dbdefs.
      WHEN 9  THEN APPLY "ENTRY" TO user_env[9]  IN FRAME dbdefs.
      WHEN 10 THEN APPLY "ENTRY" TO user_env[10] IN FRAME dbdefs.
      WHEN 11 THEN APPLY "ENTRY" TO user_env[11] IN FRAME dbdefs.
      WHEN 12 THEN APPLY "ENTRY" TO user_env[12] IN FRAME dbdefs.
      WHEN 13 THEN APPLY "ENTRY" TO user_env[13] IN FRAME dbdefs.
    END.      
    RETURN NO-APPLY.
  END.
END.

ON WINDOW-CLOSE OF FRAME dbdefs
   APPLY "END-ERROR" TO FRAME dbdefs.

/*----- HIT of FILE BUTTONS -----*/
ON CHOOSE OF btn_File1 in frame dbdefs DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT user_env[1]:handle in frame dbdefs /*Fillin*/,
        INPUT "Find dBASE File"  /*Title*/,
        INPUT "*.DBF"             /*Filter*/,
        INPUT yes                /*Must exist*/).
END.
ON CHOOSE OF btn_File4 in frame dbdefs DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT user_env[4]:handle in frame dbdefs /*Fillin*/,
        INPUT "Find Index File"  /*Title*/,
        INPUT "*.NDX"             /*Filter*/,
        INPUT yes                /*Must exist*/).
END.
ON CHOOSE OF btn_File5 in frame dbdefs DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT user_env[5]:handle in frame dbdefs /*Fillin*/,
        INPUT "Find Index File"  /*Title*/,
        INPUT "*.NDX"             /*Filter*/,
        INPUT yes                /*Must exist*/).
END.
ON CHOOSE OF btn_File6 in frame dbdefs DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT user_env[6]:handle in frame dbdefs /*Fillin*/,
        INPUT "Find Index File"  /*Title*/,
        INPUT "*.NDX"             /*Filter*/,
        INPUT yes                /*Must exist*/).
END.
ON CHOOSE OF btn_File7 in frame dbdefs DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT user_env[7]:handle in frame dbdefs /*Fillin*/,
        INPUT "Find Index File"  /*Title*/,
        INPUT "*.NDX"             /*Filter*/,
        INPUT yes                /*Must exist*/).
END.
ON CHOOSE OF btn_File8 in frame dbdefs DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT user_env[8]:handle in frame dbdefs /*Fillin*/,
        INPUT "Find Index File"  /*Title*/,
        INPUT "*.NDX"             /*Filter*/,
        INPUT yes                /*Must exist*/).
END.
ON CHOOSE OF btn_File9 in frame dbdefs DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT user_env[9]:handle in frame dbdefs /*Fillin*/,
        INPUT "Find Index File"  /*Title*/,
        INPUT "*.NDX"             /*Filter*/,
        INPUT yes                /*Must exist*/).
END.
ON CHOOSE OF btn_File10 in frame dbdefs DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT user_env[10]:handle in frame dbdefs /*Fillin*/,
        INPUT "Find Index File"  /*Title*/,
        INPUT "*.NDX"             /*Filter*/,
        INPUT yes                /*Must exist*/).
END.
ON CHOOSE OF btn_File11 in frame dbdefs DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT user_env[11]:handle in frame dbdefs /*Fillin*/,
        INPUT "Find Index File"  /*Title*/,
        INPUT "*.NDX"             /*Filter*/,
        INPUT yes                /*Must exist*/).
END.
ON CHOOSE OF btn_File12 in frame dbdefs DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT user_env[12]:handle in frame dbdefs /*Fillin*/,
        INPUT "Find Index File"  /*Title*/,
        INPUT "*.NDX"             /*Filter*/,
        INPUT yes                /*Must exist*/).
END.
ON CHOOSE OF btn_File13 in frame dbdefs DO:
   RUN "prodict/misc/_filebtn.p"
       (INPUT user_env[13]:handle in frame dbdefs /*Fillin*/,
        INPUT "Find Index File"  /*Title*/,
        INPUT "*.NDX"             /*Filter*/,
        INPUT yes                /*Must exist*/).
END.
/*----- LEAVE of fill-ins: trim blanks the user may have typed in filenames---*/
ON LEAVE OF user_env[1] in frame dbdefs
   user_env[1]:screen-value in frame dbdefs = 
        TRIM(user_env[1]:screen-value in frame dbdefs).
ON LEAVE OF user_env[4] in frame dbdefs
   user_env[4]:screen-value in frame dbdefs = 
        TRIM(user_env[4]:screen-value in frame dbdefs).
ON LEAVE OF user_env[5] in frame dbdefs
   user_env[5]:screen-value in frame dbdefs = 
        TRIM(user_env[5]:screen-value in frame dbdefs).
ON LEAVE OF user_env[6] in frame dbdefs
   user_env[6]:screen-value in frame dbdefs = 
        TRIM(user_env[6]:screen-value in frame dbdefs).
ON LEAVE OF user_env[7] in frame dbdefs
   user_env[7]:screen-value in frame dbdefs = 
        TRIM(user_env[7]:screen-value in frame dbdefs).
ON LEAVE OF user_env[8] in frame dbdefs
   user_env[8]:screen-value in frame dbdefs = 
        TRIM(user_env[8]:screen-value in frame dbdefs).
ON LEAVE OF user_env[9] in frame dbdefs
   user_env[9]:screen-value in frame dbdefs = 
        TRIM(user_env[9]:screen-value in frame dbdefs).
ON LEAVE OF user_env[10] in frame dbdefs
   user_env[10]:screen-value in frame dbdefs = 
        TRIM(user_env[10]:screen-value in frame dbdefs).
ON LEAVE OF user_env[11] in frame dbdefs
   user_env[11]:screen-value in frame dbdefs = 
        TRIM(user_env[11]:screen-value in frame dbdefs).
ON LEAVE OF user_env[12] in frame dbdefs
   user_env[12]:screen-value in frame dbdefs = 
        TRIM(user_env[12]:screen-value in frame dbdefs).
ON LEAVE OF user_env[13] in frame dbdefs
   user_env[13]:screen-value in frame dbdefs = 
        TRIM(user_env[13]:screen-value in frame dbdefs).


/*============================Mainline code===============================*/

IF dict_rog THEN msg-num = 2. /* look but don't touch */
ELSE DO FOR DICTDB._File i = 1 TO 3:
  FIND DICTDB._File
    WHERE DICTDB._File._File-name = ENTRY(i,"_File,_Field,_Index")
      AND DICTDB._File._Owner = "PUB".
  IF   NOT CAN-DO(_Can-read,  USERID("DICTDB"))
    OR NOT CAN-DO(_Can-write, USERID("DICTDB"))
    OR NOT CAN-DO(_Can-delete,USERID("DICTDB"))
    OR NOT CAN-DO(_Can-create,USERID("DICTDB")) THEN msg-num = 3.
END.

IF msg-num > 0 THEN DO:
  MESSAGE new_lang[msg-num] VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  user_path = "".
  RETURN.
END.

user_env = "".

PAUSE 0.
/* Adjust the graphical rectangle and the ok and cancel buttons */
{prodict/user/userctr.i
    &FRAME = "FRAME dbdefs"
}
{adecomm/okrun.i  
    &FRAME  = "FRAME dbdefs" 
    &BOX    = "rect_Btns"
    &OK     = "btn_OK" 
    {&CAN_BTN}
    {&HLP_BTN}
}
DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
  UPDATE user_env[1] /*nuxi*/ btn_File1
         user_env[4] btn_File4
         user_env[5] btn_File5
         user_env[6] btn_File6
         user_env[7] btn_File7
         user_env[8] btn_File8
         user_env[9] btn_File9
         user_env[10] btn_File10
         user_env[11] btn_File11
         user_env[12] btn_File12
         user_env[13] btn_File13
               btn_OK btn_Cancel {&HLP_BTN_NAME}
               WITH FRAME dbdefs.
  canned = FALSE.
END.

user_env[2] = STRING(nuxi,"y/n").
if canned THEN 
  user_path = "".

HIDE FRAME dbdefs NO-PAUSE.
RETURN.

