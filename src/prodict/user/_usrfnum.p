/***********************************************************************
* Copyright (C) 2000,2006 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/

/* userfnum - resequences all _Order fields in a file to multiples of
              <x>, starting with <y>.
              
   History:  D. McMann 06/10/02 Added check for new SESSION attribute
                                schema change.           
*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

DEFINE VARIABLE fa      AS LOGICAL INITIAL FALSE NO-UNDO.
DEFINE VARIABLE fb      AS INTEGER INITIAL 10    NO-UNDO.
DEFINE VARIABLE fi      AS INTEGER INITIAL 10    NO-UNDO.
DEFINE VARIABLE msg     AS CHARACTER             NO-UNDO.
DEFINE VARIABLE msg-num AS INTEGER INITIAL 0     NO-UNDO.
DEFINE VARIABLE numfld  AS INTEGER               NO-UNDO.
DEFINE VARIABLE canned  AS LOGICAL INITIAL TRUE  NO-UNDO.

DEFINE BUFFER xfile FOR _File.

/* LANGUAGE DEPENDENCIES START */ /*----------------------------------------*/
DEFINE VARIABLE new_lang AS CHARACTER EXTENT 11 NO-UNDO INITIAL [
  /*  1*/ "The dictionary is in read-only mode - alterations not allowed.",
  /*  2*/ "You do not have permission to use this option.",
  /*  3*/ "You cannot change the order of {&PRO_DISPLAY_NAME}/SQL columns.",
  /*  4*/ "The definitions for this table have been frozen.",
  /*  5*/ "Starting number and/or increment will cause Order to",
  /*  6*/ "overflow when renumbering.  Please try smaller values.",
  /*7-9*/ "Table ", "contains", "fields.",
  /* 10*/ "There are no fields in this table to be renumbered.",
  /* 11*/ "SESSION:SCHEMA-CHANGE set to New Objects, changes not allowed."
].

FORM SKIP(1)
  fa AT 2 LABEL "Sort by Field Name or Order"
     FORMAT "Field Name/Order" "(F/O)" SKIP(1)
  fb AT 2 LABEL "Start Numbering From"
     FORMAT ">>>>9"
     VALIDATE(fb >= 0,"Starting number must be a non-negative integer") SKIP
  fi AT 2 LABEL "   Increment Each By"
     FORMAT ">>>>9"
     VALIDATE(fi > 0,"Increment must be a positive integer") SKIP(1)
  msg AT 2 FORMAT "x(30)" NO-LABEL
  {prodict/user/userbtns.i}
  WITH FRAME reseq 
  SIDE-LABELS ATTR-SPACE ROW 5 CENTERED DEFAULT-BUTTON btn_OK 
  VIEW-AS DIALOG-BOX
  TITLE " Resequence Order of Fields in ~"" + _File._File-name + "~" ".

/* LANGUAGE DEPENDENCIES END */ /*------------------------------------------*/


FIND _File WHERE RECID(_File) = drec_file.
numfld = _File._numfld - 1.

FIND xfile "_Field".
IF NOT CAN-DO(xfile._Can-write,USERID("DICTDB")) THEN msg-num = 2.
ELSE IF _File._Db-lang > 0                       THEN msg-num = 3.
ELSE IF _File._Frozen                            THEN msg-num = 4.
ELSE IF dict_rog                                 THEN msg-num = 1.
ELSE IF numfld = 0                               THEN msg-num = 10.
ELSE IF SESSION:SCHEMA-CHANGE = "New Objects"    THEN msg-num = 11.
.

IF msg-num > 0 THEN DO:
  MESSAGE new_lang[msg-num] VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  user_path = "".
  RETURN.
END.

/* Adjust the ok and cancel buttons */
{adecomm/okrun.i  
   &BOX    = "rect_Btns"
   &FRAME  = "FRAME reseq"
   &OK     = "btn_OK"
   &CANCEL = "btn_Cancel"}

PAUSE 0. 
/* File "x" contains <y> fields. */
DISPLAY
   new_lang[7] + new_lang[8] + ' ' + STRING(numfld) + ' ' + new_lang[9]
   @ msg WITH FRAME reseq.

DISPLAY fa fb fi WITH FRAME reseq.
work_loop:
DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
  SET fa fb fi btn_OK btn_Cancel WITH FRAME reseq.
  IF fb + fi * (numfld - 1) > 99999 THEN DO:
    MESSAGE new_lang[5].
    MESSAGE new_lang[6].
    UNDO work_loop,RETRY work_loop.
  END.
  canned = FALSE.
END.

HIDE FRAME reseq NO-PAUSE.

IF canned THEN
  user_path = "".
ELSE DO:
  ASSIGN
    user_env[1] = STRING(fa,"f/o")
    user_env[2] = STRING(fb)
    user_env[3] = STRING(fi).

   RUN "prodict/misc/_wrkfnum.p".
END.

RETURN.



