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

/* usersecu - file/field level can-do security program

   History: D. McMann 07/09/98 Added AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN")
                               to FIND _File.

 */

{ prodict/dictvar.i }
{ prodict/user/uservar.i }
{ prodict/user/userhue.i }
{ prodict/user/userhdr.f }
{ prodict/user/userpik.i NEW }

/* LANGUAGE DEPENDENCIES START */ /*----------------------------------------*/

DEFINE VARIABLE qbf AS CHARACTER EXTENT 11 NO-UNDO INITIAL [
  "NextField",     "PrevField", "ForwardTable",
  "BackwardTable", "Modify",    "SwitchTable",
  "JumpField",     "CallAdmin", "UserEditor",
  "Report",        "Exit"
 ].

FORM
  qbf[ 1] /*NextField*/     FORMAT "x(9)"  HELP "Next Field."
  qbf[ 2] /*PrevField*/     FORMAT "x(9)"  HELP "Previous Field."
  qbf[ 3] /*ForwardTable*/  FORMAT "x(12)" HELP "Next Table."
  qbf[ 4] /*BackwardTable*/ FORMAT "x(13)" HELP "Previous Table."
  qbf[ 5] /*Modify*/        FORMAT "x(6)"  HELP "Modify above permissions."
  qbf[ 6] /*SwitchTable*/   FORMAT "x(11)" HELP "Switch to a different table."
    SKIP 
  qbf[ 7] /*JumpField*/     FORMAT "x(9)"  HELP "Jump to a specific field."
  qbf[ 8] /*CallAdmin*/     FORMAT "x(9)"
    HELP "Call to the Security Administrator program."
  qbf[ 9] /*UserEditor*/    FORMAT "x(10)" HELP "Go to ~"Edit User List~"."
  qbf[10] /*Report*/        FORMAT "x(6)"  HELP "List the current users."
  qbf[11] /*Exit*/          FORMAT "x(4)"  HELP "Exit ~"Change Data Security~"."
  WITH FRAME qbf NO-BOX NO-LABELS ATTR-SPACE
  ROW SCREEN-LINES - 3 COLUMN 1.

DEFINE VARIABLE new_lang AS CHARACTER EXTENT 10 NO-UNDO INITIAL [
  /* 1*/ "You must be a Security Administrator to execute this function.",
  /* 2*/ "",   /* goes with 1 */

  /* 3*/ "You need Database Security Administrator privileges in the master",
  /* 4*/ "PROGRESS DB which contains the schema of this database to continue.",

  /* 5*/ "You may not use this function with a blank userid.  This applies to",
  /* 6*/ "both the PROGRESS DB and the specific foreign DB, if appropriate.",

  /* 7*/ "The dictionary is in read-only mode - alterations not allowed.",
  /* 8*/ "You can only alter security on SQL tables with GRANT and REVOKE.",
  /* 9*/ "There are no fields in this table to jump to!",

  /*10*/ "You cannot change permissions to exclude yourself."
].

FORM
  _File._Can-read   COLON 12 VIEW-AS EDITOR INNER-LINES 1 INNER-CHARS 63 SKIP
  _File._Can-write  COLON 12 VIEW-AS EDITOR INNER-LINES 1 INNER-CHARS 63 SKIP
  _File._Can-create COLON 12 VIEW-AS EDITOR INNER-LINES 1 INNER-CHARS 63 SKIP
  _File._Can-delete COLON 12 VIEW-AS EDITOR INNER-LINES 1 INNER-CHARS 63 SKIP
  _File._Can-dump   COLON 12 VIEW-AS EDITOR INNER-LINES 1 INNER-CHARS 63 SKIP
  _File._Can-load   COLON 12 VIEW-AS EDITOR INNER-LINES 1 INNER-CHARS 63 SKIP(1)
  {prodict/user/usersecu.i}
  WITH FRAME fil ROW 2 COLUMN 1 ATTR-SPACE SIDE-LABELS
  TITLE COLOR NORMAL ' Table Name: "' + _File._File-name + '" '.

FORM
  _Field._Field-name COLON 12 FORMAT "x(32)" SKIP(1)
  _Field._Can-read   COLON 12 VIEW-AS EDITOR INNER-LINES 1 INNER-CHARS 63 SKIP
  _Field._Can-write  COLON 12 VIEW-AS EDITOR INNER-LINES 1 INNER-CHARS 63 SKIP(3)
  {prodict/user/usersecu.i}
  WITH FRAME fld ROW 2 COLUMN 1 ATTR-SPACE SIDE-LABELS
  TITLE COLOR NORMAL ' Table Name: "' + _File._File-name + '" '.

/* LANGUAGE DEPENDENCIES END */ /*------------------------------------------*/

DEFINE VARIABLE i       AS INTEGER               NO-UNDO.
DEFINE VARIABLE l       AS LOGICAL               NO-UNDO.
DEFINE VARIABLE msg-num AS INTEGER INITIAL     0 NO-UNDO.
DEFINE VARIABLE qbf#    AS INTEGER               NO-UNDO.
DEFINE VARIABLE r-o     AS LOGICAL               NO-UNDO.
DEFINE VARIABLE re-use  AS LOGICAL INITIAL FALSE NO-UNDO.

DEFINE VARIABLE istrans AS LOGICAL INITIAL TRUE. /*UNDO (not no-undo!) */
DO ON ERROR UNDO:
  istrans = FALSE.
  UNDO,LEAVE.
END.

FIND _File WHERE RECID(_File) = drec_file.

r-o = user_env[9] = "ro".
IF ((istrans
  OR PROGRESS = "Run-Time"
  OR CAN-DO("READ-ONLY",DBRESTRICTIONS(user_dbname))) AND NOT r-o)
  OR _File._Db-lang <> 0 THEN DO:
  MESSAGE new_lang[IF _File._Db-lang <> 0 THEN 8 ELSE 7]
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  HIDE MESSAGE NO-PAUSE.
  IF KEYFUNCTION(LASTKEY) = "END-ERROR" THEN DO:
    user_path = "".
    RETURN.
  END.
  IF KEYFUNCTION(LASTKEY) = "GET" THEN DO:
    user_path = "1=,_usrtget,9=" + user_env[9] + ",_usrsecu".
    RETURN.
  END.
END.
IF dict_rog THEN r-o = TRUE.

RUN "prodict/_dctadmn.p" (INPUT USERID("DICTDB"),OUTPUT l).
IF NOT l                 THEN msg-num = 1. /* secu admin? */
IF NOT l AND user_dbtype <> "PROGRESS"
                         THEN msg-num = 3. /* secu admn in pro db */
IF USERID("DICTDB") = "" THEN msg-num = 5. /* userid set? */

IF msg-num <> 0 THEN DO:
  MESSAGE new_lang[msg-num] SKIP
      	  new_lang[msg-num + 1] VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

/*
----------------- Table Name: ________________________________ ---------------
|   Can-Read: *                                                              |
|  Can-Write: *                                                              |
| Can-Create: *                                                              |
| Can-Delete: *                                                              |
| Can-Dump:   *                                                              |
| Can-Load:   *                                                              |
------------------------------------------------------------------------------

----------------- Table Name: ________________________________ ---------------3
| Field Name: ________________________________                               |4
|                                                                            |5
|   Can-Read: *                                                              |6
|  Can-Write: *                                                              |7
------------------------------------------------------------------------------8
*/

/* use these statements to man-handle scoping */
RELEASE _Field.

PAUSE 0.
DISPLAY qbf WITH FRAME qbf.

_outer: DO WHILE TRUE:

  IF AVAILABLE _Field THEN DO:
    HIDE FRAME fil NO-PAUSE.
    DISPLAY _Field._Field-name
      _Field._Can-read _Field._Can-write WITH FRAME fld.
  END.
  ELSE DO:
    HIDE FRAME fld NO-PAUSE.
    DISPLAY _File._Can-read   _File._Can-write
            _File._Can-create _File._Can-delete 
            _File._Can-dump   _File._Can-load
      	 WITH FRAME fil.
  END.

  IF NOT re-use THEN DO:
    ON CURSOR-LEFT BACK-TAB.
    ON CURSOR-RIGHT     TAB.
    _choose: DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
      IF qbf# >= 1 AND qbf# <= 11 THEN NEXT-PROMPT qbf[qbf#] WITH FRAME qbf.
      CHOOSE FIELD qbf NO-ERROR AUTO-RETURN GO-ON ("CURSOR-UP" "CURSOR-DOWN")
        WITH FRAME qbf.
      qbf# = FRAME-INDEX.
      IF KEYFUNCTION(LASTKEY) = CHR(LASTKEY) AND CHR(LASTKEY) <> "."
        AND NOT qbf[qbf#] BEGINS CHR(LASTKEY) THEN UNDO,RETRY _choose.
    END.
    ON CURSOR-LEFT  CURSOR-LEFT.
    ON CURSOR-RIGHT CURSOR-RIGHT.
    i = LOOKUP(KEYFUNCTION(LASTKEY),
        "CURSOR-DOWN,CURSOR-UP,PAGE-DOWN,PAGE-UP,,GET,PUT,,,,END-ERROR").
    IF i > 0 THEN qbf# = i.
    IF KEYFUNCTION(LASTKEY) = "PICK" THEN qbf# = 7.
    IF CHR(LASTKEY) = "." THEN qbf# = 11.
  END.

  IF (qbf# = 5 OR qbf# = 8) AND r-o THEN DO:
    MESSAGE new_lang[7]. /* sorry, r-o mode */
    NEXT _outer.
  END.

  IF qbf# = 1 THEN DO: /*------------------------------------ start of NEXT */
    IF NOT AVAILABLE _Field THEN
      FIND FIRST _Field OF _File NO-ERROR.
    ELSE
      FIND NEXT _Field OF _File NO-ERROR.
  END. /*------------------------------------------------------ end of NEXT */
  ELSE
  IF qbf# = 2 THEN DO: /*------------------------------------ start of PREV */
    IF NOT AVAILABLE _Field THEN
      FIND LAST _Field OF _File NO-ERROR.
    ELSE
      FIND PREV _Field OF _File NO-ERROR.
  END. /*------------------------------------------------------ end of PREV */
  ELSE
  IF qbf# = 3 OR qbf# = 4 THEN DO: /*------------ start of FORWARD/BACKWARD */
    IF qbf# = 4 THEN DO:
      FIND PREV _File
        WHERE _File._Db-recid = drec_db
          AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN")
          AND NOT _File._Hidden NO-ERROR.
      IF NOT AVAILABLE _File THEN
        FIND LAST _File
          WHERE _File._Db-recid = drec_db
            AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN")
            AND NOT _File._Hidden NO-ERROR.
    END.
    ELSE DO:
      FIND NEXT _File
        WHERE _File._Db-recid = drec_db
          AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN")
          AND NOT _File._Hidden NO-ERROR.
      IF NOT AVAILABLE _File THEN
        FIND FIRST _File
          WHERE _File._Db-recid = drec_db
            AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN")
            AND NOT _File._Hidden NO-ERROR.
    END.
    IF NOT AVAILABLE _File THEN LEAVE _outer.
    RELEASE _Field.
    ASSIGN
      drec_file     = RECID(_File)
      pik_count     = 0
      user_filename = _File._File-name.
    DISPLAY user_filename WITH FRAME user_ftr.
    HIDE FRAME fld NO-PAUSE.
    HIDE FRAME fil NO-PAUSE.
  END. /*------------------------------------------ end of FORWARD/BACKWARD */
  ELSE
  IF qbf# = 5 THEN DO TRANSACTION: /*---------------------- start of MODIFY */
    i = 0.
    DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
      IF AVAILABLE _Field THEN DO:
        IF i = 1 THEN NEXT-PROMPT _Field._Can-read  WITH FRAME fld.
        IF i = 2 THEN NEXT-PROMPT _Field._Can-write WITH FRAME fld.
        SET
          _Field._Can-read _Field._Can-write
          WITH FRAME fld EDITING:
            READKEY.
            APPLY (IF CAN-DO("PAGE-UP,PAGE-DOWN,GET,PUT",KEYFUNCTION(LASTKEY))
              THEN KEYCODE(KBLABEL("GO")) ELSE LASTKEY).
          END.
        i = 0.
        IF NOT CAN-DO(_Field._Can-read ,USERID("DICTDB")) THEN i = 1.
        IF NOT CAN-DO(_Field._Can-write,USERID("DICTDB")) THEN i = 2.
      END.
      ELSE DO:
        IF i = 1 THEN NEXT-PROMPT _File._Can-read   WITH FRAME fil.
        IF i = 2 THEN NEXT-PROMPT _File._Can-write  WITH FRAME fil.
        IF i = 3 THEN NEXT-PROMPT _File._Can-create WITH FRAME fil.
        IF i = 4 THEN NEXT-PROMPT _File._Can-delete WITH FRAME fil.
        IF i = 5 THEN NEXT-PROMPT _File._Can-dump   WITH FRAME fil.
        IF i = 6 THEN NEXT-PROMPT _File._Can-load   WITH FRAME fil.
        SET
          _File._Can-read   _File._Can-write
          _File._Can-create _File._Can-delete
          _File._Can-dump   _File._Can-load
          WITH FRAME fil EDITING:
            READKEY.
            APPLY (IF CAN-DO("PAGE-UP,PAGE-DOWN,GET,PUT",KEYFUNCTION(LASTKEY))
              THEN KEYCODE(KBLABEL("GO")) ELSE LASTKEY).
          END.
        i = 0.
        IF NOT CAN-DO(_File._Can-read  ,USERID("DICTDB")) THEN i = 1.
        IF NOT CAN-DO(_File._Can-write ,USERID("DICTDB")) THEN i = 2.
        IF NOT CAN-DO(_File._Can-create,USERID("DICTDB")) THEN i = 3.
        IF NOT CAN-DO(_File._Can-delete,USERID("DICTDB")) THEN i = 4.
        IF NOT CAN-DO(_File._Can-dump  ,USERID("DICTDB")) THEN i = 5.
        IF NOT CAN-DO(_File._Can-load  ,USERID("DICTDB")) THEN i = 6.
      END.
      IF i > 0 THEN DO:
        MESSAGE new_lang[10]. /* cannot exclude self */
        UNDO,RETRY.
      END.
    END.
    ASSIGN
      i      = LOOKUP(KEYFUNCTION(LASTKEY),"PAGE-DOWN,PAGE-UP,,,,GET,PUT,")
      re-use = i > 0
      qbf#   = (IF re-use THEN i ELSE qbf#).
    IF re-use THEN NEXT _outer.
  END. /*---------------------------------------------------- end of MODIFY */
  ELSE
  IF qbf# = 6 THEN DO: /*---------------------------- start of SWITCH-TABLE */
    user_path = "1=,_usrtget,9=" + user_env[9] + ",_usrsecu".
    LEAVE _outer.
  END. /*---------------------------------------------- end of SWITCH-TABLE */
  ELSE
  IF qbf# = 7 THEN _qbf7: DO: /*----------------------- start of JUMP-FIELD */
    IF pik_count = 0 THEN DO:
      ASSIGN
        pik_first   = ?
        pik_count   = 1
        pik_list[1] = "<<table security>>".
      FOR EACH _Field OF _File:
        ASSIGN
          pik_count           = pik_count + 1
          pik_list[pik_count] = _Field._Field-name.
      END.
    END.
    IF pik_count > 1 THEN
      RUN "prodict/user/_usrpick.p".
    ELSE
      MESSAGE new_lang[9]. /* there ain't no fields */
    IF pik_first <> ? THEN FIND FIRST _Field OF _File
      WHERE _Field._Field-name = pik_first NO-ERROR.
  END. /*------------------------------------------------ end of JUMP-FIELD */
  ELSE
  IF qbf# = 8 THEN DO: /*------------------------------ start of CALL-ADMIN */
    user_path = "!PROGRESS,_usradmn,_usrsecu".
    LEAVE _outer.
  END. /*------------------------------------------------ end of CALL-ADMIN */
  ELSE
  IF qbf# = 9 THEN DO: /*----------------------------- start of USER-EDITOR */
    user_path = "!PROGRESS,_usruchg".
    LEAVE _outer.
  END. /*----------------------------------------------- end of USER-EDITOR */
  ELSE
  IF qbf# = 10 THEN DO: /*--------------------------------- start of REPORT */
    user_path = "_rptuqik,_usrsecu".
    LEAVE _outer.
  END. /*---------------------------------------------------- end of REPORT */
  ELSE
  IF qbf# = 11 THEN DO: /*----------------------------------- start of EXIT */
    user_path = "".
    LEAVE _outer.
  END. /*------------------------------------------------------ end of EXIT */

  IF re-use AND qbf# <> 5 THEN qbf# = 5. ELSE re-use = FALSE.
END.

HIDE FRAME fil      NO-PAUSE.
HIDE FRAME fld      NO-PAUSE.
HIDE FRAME qbf      NO-PAUSE.
HIDE MESSAGE NO-PAUSE.
RETURN.

