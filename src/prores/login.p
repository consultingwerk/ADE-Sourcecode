/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* login.p - prompt user for userid and password and set the userid */

DEFINE VARIABLE id       LIKE _User._Userid.
DEFINE VARIABLE password LIKE _Password.
DEFINE VARIABLE tries    AS INTEGER NO-UNDO.

IF USERID("DICTDB") <> "" OR NOT CAN-FIND(FIRST DICTDB._User) THEN RETURN.
DO ON ENDKEY UNDO, RETURN:  /*return if they hit endkey*/
  /* reset id and password to blank in case of retry */
  id = "".
  password = "".
  UPDATE SPACE(2) id SKIP  password PASSWORD-FIELD
    WITH CENTERED ROW 8 SIDE-LABELS ATTR-SPACE
	 TITLE " Database " + LDBNAME("DICTDB") + " ".

  IF SETUSERID(id,password,"DICTDB") <> TRUE THEN DO:
    MESSAGE "Sorry, userid/password is incorrect.".
    IF tries > 1 THEN QUIT.   /* only allow 3 tries*/
    tries = tries + 1.
    UNDO, RETRY.
  END.
  HIDE ALL.
  RETURN.
END.
QUIT.
