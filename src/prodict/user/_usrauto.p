/***********************************************************************
* Copyright (C) 2000,2006 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/

/* _usrauto.p - editor for auto-connect progress dbs 
 *
 * HISTORY:
 * 04/12/00 by DLM - Added long path name support
 * 07/14/98 by DLM - Added _Owner to _File finds 
 * 07/13/94 by gfs - 94-06-28-062
 * 07/12/94 by gfs - 94-06-28-098, 94-06-29-035, 94-06-29-076.
 */

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

DEFINE VARIABLE answer   AS LOGICAL                NO-UNDO.
DEFINE VARIABLE args     AS CHARACTER EXTENT  5    NO-UNDO.
DEFINE VARIABLE i        AS INTEGER                NO-UNDO.
DEFINE VARIABLE in_trans AS LOGICAL                NO-UNDO.
DEFINE VARIABLE j        AS INTEGER                NO-UNDO.
DEFINE VARIABLE qbf#     AS INTEGER   INITIAL 1    NO-UNDO.
DEFINE VARIABLE qbf#list AS CHARACTER              NO-UNDO.
DEFINE VARIABLE qbf_disp AS RECID     INITIAL ?    NO-UNDO.
DEFINE VARIABLE qbf_home AS RECID                  NO-UNDO.
DEFINE VARIABLE qbf_rec  AS RECID                  NO-UNDO.
DEFINE VARIABLE qbf_was  AS INTEGER   INITIAL 2    NO-UNDO.
DEFINE VARIABLE redraw   AS LOGICAL   INITIAL TRUE NO-UNDO.
DEFINE VARIABLE ctr      AS INTEGER                NO-UNDO.
DEFINE VARIABLE rc       AS LOGICAL   INITIAL NO   NO-UNDO.
DEFINE BUFFER   xdb     FOR DICTDB._Db.

/* LANGUAGE DEPENDENCIES START */ /*---------------------------------------*/

DEFINE VARIABLE qbf AS CHARACTER EXTENT 9 NO-UNDO INITIAL [
  "Next", "Prev", "First", "Last", "Add", "Modify", "Delete", "Undo", "Exit"
].
FORM
  qbf[1] /*Next*/   FORMAT "x(4)" HELP "Look at the next connect record."
  qbf[2] /*Prev*/   FORMAT "x(4)" HELP "Look at the previous connect record."
  qbf[3] /*First*/  FORMAT "x(5)" HELP "Look at the first connect record."
  qbf[4] /*Last*/   FORMAT "x(4)" HELP "Look at the last connect record."
  qbf[5] /*Add*/    FORMAT "x(3)" HELP "Add a new connect record."
  qbf[6] /*Modify*/ FORMAT "x(6)" HELP "Update the displayed connect record."
  qbf[7] /*Delete*/ FORMAT "x(6)" HELP "Delete the displayed connect record."
  qbf[8] /*Undo*/   FORMAT "x(4)"
    HELP "Undo this session's changes to the connect records."
  qbf[9] /*Exit*/   FORMAT "x(4)"
    HELP "Exit, save changes, and return to menu."
  WITH FRAME qbf NO-BOX NO-LABELS ATTR-SPACE
  ROW SCREEN-LINES - 2 CENTERED.

DEFINE VARIABLE new_lang AS CHARACTER EXTENT 12 NO-UNDO INITIAL [
  /* 1*/ "The dictionary is in read-only mode - alterations not allowed.",
  /* 2*/ "You do not have permission to use this option.",
  /* 3*/ "You have reached the last connect record in the table.",
  /* 4*/ "You have reached the first connect record in the table.",
  /* 5*/ "Are you sure that you want to remove the connect record for",
  /* 6*/ "Undo all changes since this option entered from menu?",
  /* 7*/ "You haven't yet made changes that need to be undone!",
  /* 8*/ "You cannot delete an autoconnect record for a connected database.",
  /* 9*/ "This name already used for a sub-schema or auto-connect record.",
  /*10*/ "Logical name may not be left blank or unknown.",
  /*11*/ "You cannot use the same logical name as the currently selected database.",
  /*12*/ "Physical name may not be left blank or unknown."
].

DO FOR DICTDB._Db:
  FORM
    _Db-name LABEL "Database Name" SKIP
    WITH FRAME db_list ROW 1 COLUMN 1 ATTR-SPACE 13 DOWN SCROLL 1 USE-TEXT.

  FORM
    _Db-name LABEL "Logical Database Name" AT 2 SKIP
    " Physical Database Name:" SKIP
    _Db-addr FORMAT "x({&PATH_WIDG})" view-as FILL-IN SIZE 51 by 1 NO-LABEL AT 5 SKIP (1)
    " CONNECT statement parameters for auto-connect:" SKIP
    args[1] AT 5 FORMAT "x(51)" NO-LABEL SKIP
    args[2] AT 5 FORMAT "x(51)" NO-LABEL SKIP
    args[3] AT 5 FORMAT "x(51)" NO-LABEL SKIP
    args[4] AT 5 FORMAT "x(51)" NO-LABEL SKIP
    args[5] AT 5 FORMAT "x(51)" NO-LABEL SKIP (1)
    " If the above-named {&PRO_DISPLAY_NAME} database is referenced in a "    SKIP
    " program, and is not connected, the parameters stored here "  SKIP
    " will be used for an ~"auto-connect~". For DataServers, use " SKIP
    " the Edit Connection Information Utility. " SKIP
   WITH FRAME db_long ROW 1 COLUMN 17 ATTR-SPACE SIDE-LABELS.
END.

/*
123456789012345678901234567890123456789012345678901234567890123456789012345678

12345678901234567
+--------------++-------------------------------------------------------------+
| idx1         || Database name: ____________                                 |
| index2       ||                                                             |
| idx3         || Enter physical database name below:                         |
|              ||    :___________________________________________________     |
|              ||                                                             |
|              || Enter UNIX-style parameters for auto-connection below:      |
| index-4      ||    :___________________________________________________     |
| idx_5        ||    :___________________________________________________     |
| ix#6         ||    :___________________________________________________     |
| index007     ||    :___________________________________________________     |
| 123456789012 ||    :___________________________________________________     |
|              || When the above-named database is called for in a PROGRESS   |
|              || program, and PROGRESS sees that the above-named database is |
|              || not connected, but the current database is connected, the   |
|              || parameters stored here will be used for an "auto-connect".  |
|              || NOTE: Please use "Edit Connection Parameters..." in the     |
|              ||       "DataServer" menu for Non-PROGRESS databases.         |
+--------------++-------------------------------------------------------------+
*/

/* LANGUAGE DEPENDENCIES END */ /*-----------------------------------------*/

/*===============================Triggers=================================*/

ON LEAVE of _Db-name IN FRAME db_long
DO:
   RUN "adecomm/_valname.p" (INPUT SELF:SCREEN-VALUE, INPUT no, OUTPUT answer).
   IF NOT answer THEN
      RETURN NO-APPLY.
END.

ON LEAVE of _Db-addr IN FRAME db_long
DO:
   _Db-addr:SCREEN-VALUE = REPLACE(_Db-addr:SCREEN-VALUE, ".db", "").
END.

ON GO OF FRAME db_long 
DO:
   DEFINE VAR scr_val AS CHAR               NO-UNDO.
   DEFINE VAR i       AS INT                NO-UNDO. /* counter */
   DEFINE VAR rc      AS LOGICAL INITIAL no NO-UNDO. /* result code */

   IF _Db-addr:SCREEN-VALUE = "" OR
      _Db-addr:SCREEN-VALUE = ?  THEN DO:
        MESSAGE new_lang[12] VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        APPLY "ENTRY" TO _Db-addr IN FRAME db_long.
        RETURN NO-APPLY.
   END.
   _Db-addr:SCREEN-VALUE = REPLACE(_Db-addr:SCREEN-VALUE, ".db", "").
   scr_val = _Db-Name:SCREEN-VALUE IN FRAME db_long.
   IF scr_val = "" OR scr_val = "?" THEN DO:
      MESSAGE new_lang[10] VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      APPLY "ENTRY" TO _Db-Name IN FRAME db_long.
      RETURN NO-APPLY.
   END.
   IF LDBNAME(user_dbname) = _Db-Name:SCREEN-VALUE THEN DO:
      MESSAGE new_lang[11] VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      APPLY "ENTRY" to _Db-Name IN FRAME db_long.
      RETURN NO-APPLY.
   END.
END.
/*============================Mainline code===============================*/

DO FOR DICTDB._File:
  FIND _File "_Db" WHERE _File._Owner = "PUB" NO-LOCK.
  IF NOT CAN-DO(_Can-read,USERID("DICTDB")) THEN DO:
    MESSAGE new_lang[2] /* no permission */
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    user_path = "".
    RETURN.
  END.
  /* In qbf#list, negative numbers are the negated subscripts */
  /* from new_lang[] to display when that option is disabled. */
  qbf#list = "1,2,3,4,"
           + (IF dict_rog THEN "-1" ELSE
              IF NOT CAN-DO(_Can-create,USERID("DICTDB")) THEN "-2" ELSE "5")
           + "," +
             (IF dict_rog THEN "-1" ELSE
              IF NOT CAN-DO(_Can-write ,USERID("DICTDB")) THEN "-2" ELSE "6")
           + "," +
             (IF dict_rog THEN "-1" ELSE
              IF NOT CAN-DO(_Can-delete,USERID("DICTDB")) THEN "-2" ELSE "7")
           + "," +
             (IF dict_rog THEN "-1" ELSE
              IF NOT CAN-DO(_Can-create,USERID("DICTDB")) THEN "-2" ELSE "8")
           + ",9,10".
END.

qbf_block:
DO FOR DICTDB._Db TRANSACTION ON ERROR UNDO,RETRY:

  in_trans = FALSE. /* no changes made yet */
  FIND FIRST _Db WHERE _Db-type = "PROGRESS" AND NOT _Db-local NO-ERROR.
  PAUSE 0.
  VIEW FRAME db_list.
  VIEW FRAME db_long.

  DO WHILE TRUE:
    qbf_rec = RECID(_Db).

    IF redraw THEN DO:
      FIND FIRST _Db WHERE _Db-type = "PROGRESS" AND NOT _Db-local NO-ERROR.
      ASSIGN
        qbf_disp = ?
        qbf_home = RECID(_Db)
        redraw   = FALSE.
      DISPLAY qbf WITH FRAME qbf.
      IF qbf_rec <> ? THEN FIND _Db WHERE RECID(_Db) = qbf_rec NO-ERROR.
      ASSIGN
        qbf_rec = RECID(_Db)
        j       = (IF FRAME-LINE(db_list) = 0 THEN 1 ELSE FRAME-LINE(db_list))
        i       = 3.
      UP j - 1 WITH FRAME db_list.
      IF j > 1 THEN DO i = 2 TO j WHILE AVAILABLE _Db:
        FIND PREV _Db WHERE _Db-type = "PROGRESS" AND NOT _Db-local NO-ERROR.
      END.
      IF NOT AVAILABLE _Db THEN DO:
        FIND FIRST _Db WHERE _Db-type = "PROGRESS" AND NOT _Db-local NO-ERROR.
        j = i - 2.
      END.
      DO i = 1 TO FRAME-DOWN(db_list):
        IF AVAILABLE _Db THEN
          DISPLAY _Db-name WITH FRAME db_list.
        ELSE
          CLEAR FRAME db_list NO-PAUSE.
        COLOR DISPLAY VALUE(IF RECID(_Db) = qbf_rec AND RECID(_Db) <> ?
          THEN "MESSAGES" ELSE "NORMAL") _Db-name WITH FRAME db_list.
        DOWN WITH FRAME db_list.
        FIND NEXT _Db WHERE _Db-type = "PROGRESS" AND NOT _Db-local NO-ERROR.
      END.
      IF qbf_rec <> ? THEN
        FIND _Db WHERE RECID(_Db) = qbf_rec NO-ERROR.
      UP FRAME-DOWN(db_list) - j + 1 WITH FRAME db_list.
    END.

    IF qbf_was <> FRAME-LINE(db_list) THEN DO WITH FRAME db_list:
      i = FRAME-LINE.
      DOWN qbf_was - i.
      COLOR DISPLAY NORMAL _Db-name.
      DOWN i - qbf_was.
      IF AVAILABLE _Db THEN COLOR DISPLAY MESSAGES _Db-name.
      qbf_was = FRAME-LINE.
    END.

    ASSIGN
      args[1] = (IF AVAILABLE _Db THEN _Db-comm ELSE "")
      args[2] = ""
      args[3] = ""
      args[4] = ""
      args[5] = "".
    IF LENGTH(args[1]) > 51 THEN ASSIGN
      i       = R-INDEX(args[1]," ",51)
      args[2] = SUBSTRING(args[1],i + 1)
      args[1] = SUBSTRING(args[1],1,i).
    IF LENGTH(args[2]) > 51 THEN ASSIGN
      i       = R-INDEX(args[2]," ",51)
      args[3] = SUBSTRING(args[2],i + 1)
      args[2] = SUBSTRING(args[2],1,i).
    IF LENGTH(args[3]) > 51 THEN ASSIGN
      i       = R-INDEX(args[3]," ",51)
      args[4] = SUBSTRING(args[3],i + 1)
      args[3] = SUBSTRING(args[3],1,i).
    IF LENGTH(args[4]) > 51 THEN ASSIGN
      i       = R-INDEX(args[4]," ",51)
      args[5] = SUBSTRING(args[4],i + 1)
      args[4] = SUBSTRING(args[4],1,i).

/*
    READKEY PAUSE 0.
    IF LASTKEY = -1 AND AVAILABLE _Db AND qbf_disp <> RECID(_Db) THEN DO:
      DISPLAY _Db-name args WITH FRAME db_long.
      qbf_disp = RECID(_Db).
    END.
*/
    IF AVAILABLE _Db AND qbf_disp <> RECID(_Db) THEN DO:
      DISPLAY _Db-name _Db-addr args WITH FRAME db_long.
      qbf_disp = RECID(_Db).
    END.


    ON CURSOR-LEFT BACK-TAB.
    ON CURSOR-RIGHT     TAB.
    _choose: DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
      IF qbf# >= 1 AND qbf# <= 9 THEN NEXT-PROMPT qbf[qbf#] WITH FRAME qbf.
      CHOOSE FIELD qbf NO-ERROR AUTO-RETURN WITH FRAME qbf.
      qbf# = FRAME-INDEX.
      IF KEYFUNCTION(LASTKEY) = CHR(LASTKEY) AND CHR(LASTKEY) <> "."
        AND NOT qbf[qbf#] BEGINS CHR(LASTKEY) THEN UNDO,RETRY _choose.
    END.
    ON CURSOR-LEFT  CURSOR-LEFT.
    ON CURSOR-RIGHT CURSOR-RIGHT.
    i = LOOKUP(KEYFUNCTION(LASTKEY),"CURSOR-DOWN,CURSOR-UP,,END,,,,,.").
    IF i > 0 THEN qbf# = i.
    i = LOOKUP(KEYFUNCTION(LASTKEY),"PAGE-DOWN,PAGE-UP,,,,,,,END-ERROR").
    IF i > 0 THEN qbf# = i.
    IF CAN-DO("HOME,MOVE",KEYFUNCTION(LASTKEY)) THEN
      qbf# = (IF qbf_rec = qbf_home THEN 4 ELSE 3).
    HIDE MESSAGE NO-PAUSE.

    IF qbf# <> 5 AND qbf# < 8 AND NOT AVAILABLE _Db THEN NEXT.

    IF ENTRY(qbf#,qbf#list) BEGINS "-" THEN DO:
      MESSAGE new_lang[- INTEGER(ENTRY(qbf#,qbf#list))]. /* not allowed */
      NEXT.
    END.
    IF qbf# > 2 THEN redraw = TRUE.

    IF qbf# = 1 THEN DO: /*---------------------------------- start of NEXT */
      FIND NEXT _Db WHERE _Db-type = "PROGRESS" AND NOT _Db-local NO-ERROR.
      IF NOT AVAILABLE _Db THEN DO:
        MESSAGE new_lang[3].
        FIND LAST _Db WHERE _Db-type = "PROGRESS" AND NOT _Db-local NO-ERROR.
      END.
      ELSE DO WITH FRAME db_list:
        IF FRAME-LINE = FRAME-DOWN THEN qbf_was = qbf_was - 1.
        IF FRAME-LINE = FRAME-DOWN THEN SCROLL UP. ELSE DOWN.
      END.
    END. /*---------------------------------------------------- end of NEXT */
    ELSE
    IF qbf# = 2 THEN DO: /*---------------------------------- start of PREV */
      FIND PREV _Db WHERE _Db-type = "PROGRESS" AND NOT _Db-local NO-ERROR.
      IF NOT AVAILABLE _Db THEN DO:
        MESSAGE new_lang[4].
        FIND FIRST _Db WHERE _Db-type = "PROGRESS" AND NOT _Db-local NO-ERROR.
      END.
      ELSE DO WITH FRAME db_list:
        IF FRAME-LINE = 1 THEN qbf_was = qbf_was + 1.
        IF FRAME-LINE = 1 THEN SCROLL DOWN. ELSE UP.
      END.
    END. /*---------------------------------------------------- end of PREV */
    ELSE
    IF qbf# = 3 THEN DO: /*--------------------------------- start of FIRST */
      FIND FIRST _Db WHERE _Db-type = "PROGRESS" AND NOT _Db-local NO-ERROR.
      UP FRAME-LINE(db_list) - 1 WITH FRAME db_list.
      MESSAGE new_lang[4].
    END. /*--------------------------------------------------- end of FIRST */
    ELSE
    IF qbf# = 4 THEN DO: /*---------------------------------- start of LAST */
      FIND LAST _Db WHERE _Db-type = "PROGRESS" AND NOT _Db-local NO-ERROR.
      DOWN FRAME-DOWN(db_list) - FRAME-LINE(db_list) WITH FRAME db_list.
      MESSAGE new_lang[3].
    END. /*---------------------------------------------------- end of LAST */
    ELSE
    IF qbf# = 5 THEN DO: /*----------------------------------- start of ADD */
      DISPLAY "" @ _Db-name "" @ _Db-addr
        "" @ args[1] "" @ args[2] "" @ args[3] "" @ args[4] "" @ args[5]
        WITH FRAME db_long.
      COLOR DISPLAY NORMAL _Db-name WITH FRAME db_list.
      RELEASE _Db.
      DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
        PROMPT-FOR _Db-name _Db-addr TEXT(args) WITH FRAME db_long.

        FIND FIRST _Db WHERE _Db-name = INPUT FRAME db_long _Db-name NO-ERROR.
        IF AVAILABLE _Db THEN DO:
          MESSAGE new_lang[9]. /* already used */
          UNDO,RETRY.
        END.
        CREATE _Db.
        ASSIGN
          _Db-name _Db-addr args
          _Db-type  = "PROGRESS"
          _Db-slave = FALSE
          _Db-comm  = args[1] + " " + args[2] + " "
                    + args[3] + " " + args[4] + " " + args[5]
          in_trans  = TRUE.
        DOWN FRAME-DOWN(db_list) - FRAME-LINE(db_list) WITH FRAME db_list.
      END.
      IF NOT AVAILABLE _Db AND qbf_rec <> ? THEN
        FIND _Db WHERE RECID(_Db) = qbf_rec.
      IF AVAILABLE _Db THEN
        COLOR DISPLAY MESSAGES _Db-name WITH FRAME db_list.
    END. /*----------------------------------------------------- end of ADD */
    ELSE
    IF qbf# = 6 AND qbf_rec <> ? THEN DO: /*--------------- start of MODIFY */
      DISPLAY _Db-name _Db-addr args WITH FRAME db_long.
      _qbf6: DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
        SET _Db-name _Db-addr TEXT(args) WITH FRAME db_long.

        FIND FIRST xdb
          WHERE xdb._Db-name = INPUT FRAME db_long _Db-name
            AND RECID(xdb) <> RECID(_Db) NO-ERROR.
        IF AVAILABLE xdb THEN DO:
          MESSAGE new_lang[9]. /* already used */
          UNDO _qbf6,RETRY _qbf6.
        END.
      END.
      ASSIGN
        in_trans = TRUE
        _Db-comm = args[1] + " " + args[2] + " "
                 + args[3] + " " + args[4] + " " + args[5].
      IF _Db-name ENTERED THEN
        DOWN FRAME-DOWN(db_list) - FRAME-LINE(db_list) WITH FRAME db_list.
    END. /*-------------------------------------------------- end of MODIFY */
    ELSE
    IF qbf# = 7 AND qbf_rec <> ? THEN _qbf7: DO: /*-------- start of DELETE */
      IF CONNECTED(_Db-name) THEN DO:
        MESSAGE new_lang[8]. /* can't delete connected db */
        LEAVE _qbf7.
      END.
      answer = FALSE. /* are you sure... delete? */
      RUN "prodict/user/_usrdbox.p" (INPUT-OUTPUT answer,?,?,
        new_lang[5] + ' "' + _Db-name + '"?').
      IF answer THEN DO:
        IF user_dbname = _Db-name THEN        
            ASSIGN user_dbname = "".
            
        DELETE _Db.
        FIND FIRST _Db WHERE _Db-type = "PROGRESS" AND NOT _Db-local NO-ERROR.
        UP FRAME-LINE(db_list) - 1 WITH FRAME db_list.
        IF NOT AVAILABLE _Db THEN
          DISPLAY "" @ _Db-name
            "" @ args[1] "" @ args[2] "" @ args[3] "" @ args[4] "" @ args[5]
            WITH FRAME db_long.
      END.
      in_trans = in_trans OR answer.
    END. /*-------------------------------------------------- end of DELETE */
    ELSE
    IF qbf# = 8 THEN DO: /*---------------------------------- start of UNDO */
      IF in_trans THEN DO:
        answer = FALSE. /* undo session? */
        RUN "prodict/user/_usrdbox.p"
          (INPUT-OUTPUT answer,?,?,new_lang[6]).
        IF answer THEN UNDO qbf_block,RETRY qbf_block.
      END.
      ELSE
        MESSAGE new_lang[7]. /* what changed? */
    END. /*---------------------------------------------------- end of UNDO */
    ELSE
    IF qbf# = 9 THEN /*-------------------------------------- start of EXIT */
      LEAVE qbf_block.
    /*--------------------------------------------------------- end of EXIT */

  END. /* iterating block */
END. /* scoping block */

HIDE FRAME qbf     NO-PAUSE.
HIDE FRAME db_long NO-PAUSE.
HIDE FRAME db_list NO-PAUSE.
RETURN.

