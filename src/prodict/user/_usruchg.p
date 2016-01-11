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

/* Progress Lex Converter 7.1A->7.1B Version 1.11 

History: 07/09/98 D. McMann Added AND _File._Owner = "PUB" to FIND _File

*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

/* LANGUAGE DEPENDENCIES START */ /*---------------------------------------*/

DEFINE VARIABLE qbf AS CHARACTER EXTENT 12 NO-UNDO INITIAL [
  "Next",   "Prev",      "First",    "Last",   "Add",  "Modify",
  "Delete", "CallAdmin", "Security", "Report", "Undo", "Exit"
].
FORM
  qbf[ 1] /*Next*/      FORMAT "x(4)" HELP "Look at the next user."
  qbf[ 2] /*Prev*/      FORMAT "x(4)" HELP "Look at the previous user."
  qbf[ 3] /*First*/     FORMAT "x(5)" HELP "Look at the first user."
  qbf[ 4] /*Last*/      FORMAT "x(4)" HELP "Look at the last user."
  qbf[ 5] /*Add*/       FORMAT "x(3)" HELP "Add a new user."
  qbf[ 6] /*Modify*/    FORMAT "x(6)"
    HELP "Change this user's name and/or password."
  qbf[ 7] /*Delete*/    FORMAT "x(6)" HELP "Delete the displayed user."
  qbf[ 8] /*CallAdmin*/ FORMAT "x(9)"
    HELP "Call to the Security Administrator program."
  qbf[ 9] /*Security*/  FORMAT "x(8)"
    HELP "Go to the Change Data Security program."
  qbf[10] /*Report*/    FORMAT "x(6)"
    HELP "List the current users."
  SKIP 
  qbf[11] /*Undo*/      FORMAT "x(4)"
    HELP "Undo this session's changes to the user list."
  qbf[12] /*Exit*/      FORMAT "x(4)"
    HELP "Exit User Editor, save changes, and return to menu."
  WITH FRAME qbf ATTR-SPACE NO-BOX NO-LABELS OVERLAY
  ROW SCREEN-LINES - 5 COLUMN 3 CENTERED.
/*       "Revoke:Revoke access privileges to tables.", */
/*       "Grant:Grant access privileges to tables.", */

DEFINE VARIABLE new_lang AS CHARACTER EXTENT 20 NO-UNDO INITIAL [
  /*  1*/ "This function only works on PROGRESS databases.",
  /*  2*/ "You may not use this function with a blank userid.",
  /*  3*/ "You must be a Security Administrator to execute this function.",
  /*  4*/ "You may delete the current User only if it is the only User left.",
  /*  5*/ "Are you sure that you want to remove this user?",
  /*  6*/ "Undo all changes since selection of User Editor from menu?",
  /*7,8*/ "The user named", "has no password assigned.",
  /*  9*/ "You have reached the last user in the table.",
  /* 10*/ "You have reached the first user in the table.",
  /* 11*/ "You did not type the same password each time.",
  /* 12*/ "No User record was created.",
  /* 13*/ ?, /* see below */
  /* 14*/ "The dictionary is in read-only mode - alterations not allowed.",
  /* 15*/ "There are no users in the _User table.",
  /* 16*/ "You haven't yet made changes that need to be undone!",
      	  /* 17 - 20 used together */
  /* 17*/ "You have removed all security administrators, leaving none of",
  /* 18*/ "the remaining users with security administrator privileges.",
  /* 19*/ "There must be at least one user with security administrator",
  /* 20*/ "privileges."
].
new_lang[13] = "You are about to end the transaction in which you have "
             + "deleted the last User record.!When you do this, you force "
             + "all users to have security administrator privileges. ! "
             + "Do you want to do this?!"
             + "(If not, undo changes or add back a security administrator)".

FORM " " SKIP
  WITH FRAME usr_box OVERLAY
  ROW 2 COLUMN 2 SCREEN-LINES - 6 DOWN NO-LABELS NO-ATTR-SPACE WIDTH 78
  USE-TEXT.

FORM
  _User._Userid    LABEL "User ID"
    VALIDATE(NOT CAN-FIND(_User USING _User._Userid),
    "User IDs must be unique within each database.")
  _User._User-Name LABEL "User Name"
  _User._Password  LABEL "Password" BLANK
  WITH FRAME usr_lst
  OVERLAY ROW 3 COLUMN 3 NO-LABELS ATTR-SPACE SCREEN-LINES - 12 DOWN SCROLL 1.

/* LANGUAGE DEPENDENCIES END */ /*-----------------------------------------*/

DEFINE VARIABLE answer     AS LOGICAL               NO-UNDO.
DEFINE VARIABLE i          AS INTEGER INITIAL 0     NO-UNDO.
DEFINE VARIABLE in_trans   AS LOGICAL INITIAL FALSE NO-UNDO.
DEFINE VARIABLE j          AS INTEGER               NO-UNDO.
DEFINE VARIABLE passwd     AS CHARACTER             NO-UNDO.
DEFINE VARIABLE qbf#       AS INTEGER INITIAL 1     NO-UNDO.
DEFINE VARIABLE qbf_disp   AS RECID   INITIAL ?     NO-UNDO.
DEFINE VARIABLE qbf_home   AS RECID                 NO-UNDO.
DEFINE VARIABLE qbf_rec    AS RECID                 NO-UNDO.
DEFINE VARIABLE qbf_was    AS INTEGER INITIAL 2     NO-UNDO.
DEFINE VARIABLE redraw     AS LOGICAL INITIAL TRUE  NO-UNDO.
DEFINE VARIABLE user-cnt-i AS INTEGER INITIAL 0     NO-UNDO.
DEFINE VARIABLE user-cnt-o AS INTEGER               NO-UNDO.
DEFINE VARIABLE istrans AS LOGICAL INITIAL TRUE. /*UNDO (not no-undo!) */
DO ON ERROR UNDO:
  istrans = FALSE.
  UNDO,LEAVE.
END.
 
RUN "prodict/_dctadmn.p" (INPUT USERID(user_dbname),OUTPUT answer).
IF istrans OR PROGRESS = "Run-Time"
  OR CAN-DO("READ-ONLY",DBRESTRICTIONS(user_dbname)) THEN i = 14. /* r/o mode */
IF NOT answer                THEN i = 3. /* secu admin? */
IF USERID(user_dbname) = "" AND CAN-FIND(FIRST _User)
                             THEN i = 2. /* userid set? */
IF user_dbtype <> "PROGRESS" THEN i = 1. /* dbtype okay */

/* user-cnt-i: 0=none, 1=one, 2=many - that's all we need to know */
FOR EACH _User WHILE user-cnt-i < 2:
  user-cnt-i = user-cnt-i + 1.
END.

IF i <> 0 THEN DO:
  MESSAGE new_lang[i] VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

PAUSE 0.
VIEW FRAME usr_box.

qbf_block:
DO FOR _User TRANSACTION ON ERROR UNDO,RETRY:

  FIND FIRST _User NO-ERROR.
  PAUSE 0.
  VIEW FRAME usr_lst.

  qbf_inner:
  DO WHILE TRUE WITH FRAME usr_lst:
    qbf_rec = RECID(_User).

    IF redraw THEN DO:
      DISPLAY qbf WITH FRAME qbf.
      FIND FIRST _User NO-ERROR.
      ASSIGN
        qbf_disp = ?
        qbf_home = RECID(_User)
        redraw   = FALSE.
      IF qbf_rec <> ? THEN
        FIND _User WHERE RECID(_User) = qbf_rec NO-ERROR.
      ASSIGN
        qbf_rec = RECID(_User)
        j       = (IF FRAME-LINE = 0 THEN 1 ELSE FRAME-LINE)
        i       = 3.
      UP j - 1.
      IF j > 1 THEN DO i = 2 TO j WHILE AVAILABLE _User:
        FIND PREV _User NO-ERROR.
      END.
      IF NOT AVAILABLE _User THEN DO:
        FIND FIRST _User NO-ERROR.
        j = i - 2.
      END.
      DO i = 1 TO FRAME-DOWN:
        IF INPUT _User-name = (IF AVAILABLE _User THEN _User-name ELSE "")
          AND INPUT _Userid = (IF AVAILABLE _User THEN _Userid ELSE "") THEN .
        ELSE IF AVAILABLE _User THEN
          DISPLAY _Userid _User-name "" @ _Password.
        ELSE
          CLEAR NO-PAUSE.
        COLOR DISPLAY VALUE(IF RECID(_User) = qbf_rec AND RECID(_User) <> ?
          THEN "MESSAGES" ELSE "NORMAL") _Userid _User-name.
        DOWN.
        FIND NEXT _User NO-ERROR.
      END.
      IF qbf_rec <> ? THEN
        FIND _User WHERE RECID(_User) = qbf_rec NO-ERROR.
      UP FRAME-DOWN - j + 1.
    END.

    IF qbf_was <> FRAME-LINE THEN DO:
      i = FRAME-LINE.
      DOWN qbf_was - i.
      COLOR DISPLAY NORMAL _Userid _User-name.
      DOWN i - qbf_was.
      IF qbf_rec <> ? THEN COLOR DISPLAY MESSAGES _Userid _User-name.
      qbf_was = FRAME-LINE.
    END.

    IF AVAILABLE _User AND qbf_disp <> RECID(_User) THEN
      DISPLAY _Userid _User-name "" @ _Password.
    qbf_disp = RECID(_User).

    ON CURSOR-LEFT BACK-TAB.
    ON CURSOR-RIGHT     TAB.
    _choose: DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
      IF qbf# > 12 THEN qbf# = qbf# - 12.
      IF qbf# >= 1 AND qbf# <= 12 THEN NEXT-PROMPT qbf[qbf#] WITH FRAME qbf.
      CHOOSE FIELD qbf NO-ERROR AUTO-RETURN GO-ON ("CURSOR-UP" "CURSOR-DOWN")
        WITH FRAME qbf.
      qbf# = FRAME-INDEX.
      IF KEYFUNCTION(LASTKEY) = CHR(LASTKEY) AND CHR(LASTKEY) <> "."
        AND NOT qbf[qbf#] BEGINS CHR(LASTKEY) THEN UNDO,RETRY _choose.
    END.
    ON CURSOR-LEFT  CURSOR-LEFT.
    ON CURSOR-RIGHT CURSOR-RIGHT.
    i = LOOKUP(KEYFUNCTION(LASTKEY),
        "CURSOR-DOWN,CURSOR-UP,,END,,,,,,,,END-ERROR,PAGE-DOWN,PAGE-UP").
    IF i > 0 THEN qbf# = i.
    IF CAN-DO("HOME,MOVE",KEYFUNCTION(LASTKEY)) THEN
      qbf# = (IF qbf_rec = qbf_home THEN 4 ELSE 3).

    HIDE MESSAGE NO-PAUSE.
    redraw = qbf# > 2.

    IF qbf# = 1 THEN DO: /*---------------------------------- start of NEXT */
      FIND NEXT _User NO-ERROR.
      IF NOT AVAILABLE _User THEN DO:
        FIND LAST _User NO-ERROR.
        MESSAGE new_lang[IF AVAILABLE _User THEN 9 ELSE 15].
      END.
      ELSE DO:
        IF FRAME-LINE = FRAME-DOWN THEN qbf_was = qbf_was - 1.
        IF FRAME-LINE = FRAME-DOWN THEN
          SCROLL UP.
        ELSE
          DOWN.
      END.
    END. /*---------------------------------------------------- end of NEXT */
    ELSE
    IF qbf# = 2 THEN DO: /*---------------------------------- start of PREV */
      FIND PREV _User NO-ERROR.
      IF NOT AVAILABLE _User THEN DO:
        FIND FIRST _User NO-ERROR.
        MESSAGE new_lang[IF AVAILABLE _User THEN 10 ELSE 15].
      END.
      ELSE DO:
        IF FRAME-LINE = 1 THEN qbf_was = qbf_was + 1.
        IF FRAME-LINE = 1 THEN
          SCROLL DOWN.
        ELSE
          UP.
      END.
    END. /*---------------------------------------------------- end of PREV */
    ELSE
    IF qbf# = 3 THEN DO: /*--------------------------------- start of FIRST */
      FIND FIRST _User NO-ERROR.
      UP FRAME-LINE - 1.
      MESSAGE new_lang[IF AVAILABLE _User THEN 10 ELSE 15].
    END. /*--------------------------------------------------- end of FIRST */
    ELSE
    IF qbf# = 4 THEN DO: /*---------------------------------- start of LAST */
      FIND LAST _User NO-ERROR.
      DOWN FRAME-DOWN - FRAME-LINE.
      MESSAGE new_lang[IF AVAILABLE _User THEN 9 ELSE 15].
    END. /*---------------------------------------------------- end of LAST */
    ELSE
    IF qbf# = 5 THEN _qbf5: DO ON ERROR UNDO,LEAVE: /*-------- start of ADD */
      IF FRAME-LINE < FRAME-DOWN THEN DO:
        COLOR DISPLAY NORMAL _Userid _User-name _Password.
        SCROLL FROM-CURRENT DOWN.
      END.
      DISPLAY "" @ _Userid "" @ _User-name "" @ _Password.
      DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
        PROMPT-FOR _Userid _User-name _Password.
      END.
      passwd = ENCODE(INPUT _Password).
      IF KEYFUNCTION(LASTKEY) = "END-ERROR" THEN LEAVE _qbf5.
      IF INPUT _Password <> "" THEN DO:
        RUN "prodict/user/_usrpwd2.p" (INPUT passwd, OUTPUT answer).
        if answer = NO THEN DO:
          MESSAGE new_lang[11] SKIP /* didn't type same passwd each time */
               	  new_lang[12] 	    /* no user record created */
      	       	  VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        END.
        IF answer <> YES THEN LEAVE _qbf5.
      END.
      CREATE _User.
      ASSIGN
        _Userid    = INPUT _Userid
        _User-name = INPUT _User-name
        _Password  = passwd.
      IF INPUT _Password = "" THEN /* note: user xxx has no passwd */
        MESSAGE new_lang[7] + " ~"" + _Userid + "~" " + new_lang[8].
      qbf_was = (IF FRAME-LINE = 1 THEN FRAME-DOWN ELSE FRAME-LINE - 1).
      DOWN FRAME-DOWN - FRAME-LINE.
      in_trans = TRUE.
    END. /*----------------------------------------------------- end of ADD */
    ELSE
    IF qbf# = 6 AND qbf_rec <> ? THEN /*------------------- start of MODIFY */
      DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
      PROMPT-FOR _User-name.
      ASSIGN
        in_trans   = in_trans OR _User-name ENTERED
        _User-name = INPUT _User-name.
    END. /*-------------------------------------------------- end of MODIFY */
    ELSE
    IF qbf# = 7 AND qbf_rec <> ? THEN DO: /*--------------- start of DELETE */
      IF _Userid = USERID(user_dbname) THEN DO:
        FIND FIRST _User WHERE _Userid <> USERID(user_dbname) NO-ERROR.
        IF AVAILABLE _User THEN DO:
          MESSAGE new_lang[4]. /* can only delete self if last user */
      	  FIND _User WHERE _User._UserId = USERID(user_dbname). /* refind */
          NEXT.
        END.
        FIND _User WHERE RECID(_User) = qbf_rec.
      END.
      DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
        answer = FALSE. /* are you sure... delete? */
        RUN "prodict/user/_usrdbox.p"
          (INPUT-OUTPUT answer,?,?,new_lang[5]).
        IF answer THEN DO:
          DELETE _User.
          in_trans = in_trans OR answer.
        END.
      END.
    END. /*-------------------------------------------------- end of DELETE */
    ELSE
    IF qbf# = 8 THEN DO: /*---------------------------- start of CALL-ADMIN */
      user_path = "_usradmn,_usruchg".
      LEAVE qbf_inner.
    END. /*---------------------------------------------- end of CALL-ADMIN */
    ELSE
    IF qbf# = 9 THEN DO: /*------------------------------ start of SECURITY */
      user_path = "1=o,_usrtget,9=rw,_usrsecu".
      LEAVE qbf_inner.
    END. /*------------------------------------------------ end of SECURITY */
    ELSE
    IF qbf# = 10 THEN DO: /*------------------------------- start of REPORT */
      user_path = "_rptuqik,_usruchg".
      LEAVE qbf_inner.
    END. /*-------------------------------------------------- end of REPORT */
    ELSE
    IF qbf# = 11 THEN DO: /*--------------------------------- start of UNDO */
      IF in_trans THEN DO:
        answer = FALSE. /* undo session? */
        RUN "prodict/user/_usrdbox.p"
          (INPUT-OUTPUT answer,?,?,new_lang[6]).
        IF answer THEN DO:
          in_trans = FALSE.
          UNDO qbf_block,RETRY qbf_block.
        END.
      END.
      ELSE
        MESSAGE new_lang[16]. /* what changes? */
    END. /*---------------------------------------------------- end of UNDO */
    ELSE
    IF qbf# = 12 THEN _qbf12: DO: /*------------------------- start of EXIT */
      /* user-cnt-o: 0=none, 1=one, 2=many - that's all we need to know */
      user-cnt-o  = 0.
      FOR EACH _User WHILE user-cnt-o < 2:
        user-cnt-o = user-cnt-o + 1.
      END.

      IF user-cnt-i = 0 AND user-cnt-o = 0 THEN .   /* don't care */
      ELSE
      IF user-cnt-o > 0 THEN DO: /* chgd or added _User: kill last sec adm? */
        answer = FALSE.
        FOR EACH _User WHILE NOT answer:
          RUN "prodict/_dctadmn.p"
            (INPUT _User._Userid, OUTPUT answer).
        END.
        IF NOT answer THEN DO:
      	  MESSAGE new_lang[17] SKIP
      	       	  new_lang[18] SKIP
      	       	  new_lang[19] SKIP
      	       	  new_lang[20]
      	       	  VIEW-AS ALERT-BOX ERROR BUTTONS OK.
          LEAVE _qbf12.
        END.
      END.
      ELSE
      IF user-cnt-i > 0 AND user-cnt-o = 0 THEN DO: /* last _User deleted */
        answer = FALSE.
        RUN "prodict/user/_usrdbox.p"
          (INPUT-OUTPUT answer,?,?,new_lang[13]).
        IF NOT answer THEN LEAVE _qbf12.

        /* set the security administrator fields back to "*" */
        FIND _File "_File" WHERE _File._Db-recid = drec_db
                             AND _File._Owner = "PUB".
        FIND _Field "_Can-read"   OF _File.
        _Field._Can-write = "*".
        FIND _Field "_Can-write"  OF _File.
        _Field._Can-write = "*".
        FIND _Field "_Can-create" OF _File.
        _Field._Can-write = "*".
        FIND _Field "_Can-delete" OF _File.
        _Field._Can-write = "*".

        FIND _File "_Field" WHERE _File._Db-recid = drec_db
                              AND _File._Owner = "PUB" .
        FIND _Field "_Can-read"   OF _File.
        _Field._Can-write = "*".
        FIND _Field "_Can-write"  OF _File.
        _Field._Can-write = "*".

        FIND _File "_User" WHERE _File._Db-recid = drec_db
                             AND _File._Owner = "PUB".
        ASSIGN
          _File._Can-create = "*"
          _File._Can-delete = "*".
      END.

      LEAVE qbf_inner.
    END. /*---------------------------------------------------- end of EXIT */
    ELSE
    IF qbf_rec <> ? AND qbf# = 13 THEN DO: /*----------- start of NEXT-PAGE */
      DO i = 1 TO FRAME-DOWN WHILE AVAILABLE _User:
        FIND NEXT _User NO-ERROR.
      END.
      IF NOT AVAILABLE _User THEN DO:
        DOWN FRAME-DOWN - FRAME-LINE.
        FIND LAST _User NO-ERROR.
      END.
    END. /*----------------------------------------------- end of NEXT-PAGE */
    ELSE
    IF qbf_rec <> ? AND qbf# = 14 THEN DO: /*----------- start of PREV-PAGE */
      DO i = 1 TO FRAME-DOWN WHILE AVAILABLE _User:
        FIND PREV _User NO-ERROR.
      END.
      IF NOT AVAILABLE _User THEN DO:
        FIND FIRST _User NO-ERROR.
        UP FRAME-LINE - 1.
      END.
    END. /*----------------------------------------------- end of PREV-PAGE */

  END. /* iterating block */

END. /* scoping block */


HIDE FRAME qbf     NO-PAUSE.
HIDE FRAME usr_box NO-PAUSE.
HIDE FRAME usr_lst NO-PAUSE.
RETURN.

