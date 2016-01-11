/*********************************************************************
* Copyright (C) 2000, 2011 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* login.p - prompt user for userid and password and set the userid */

DEFINE VARIABLE id       LIKE _User._Userid.
DEFINE VARIABLE password LIKE _Password.
DEFINE VARIABLE tries    AS INTEGER NO-UNDO.
DEFINE VARIABLE hCP      AS HANDLE  NO-UNDO.
DEFINE VARIABLE setdbclnt AS LOGICAL NO-UNDO.
DEFINE VARIABLE currentdb AS CHARACTER FORMAT "x(32)":u NO-UNDO.
create Client-Principal hCP. /* create a CLIENT-PRINCIPAL only once during login*/

IF USERID("DICTDB") <> "" OR NOT CAN-FIND(FIRST DICTDB._User) THEN RETURN.
DO ON ENDKEY UNDO, RETURN:  /*return if they hit endkey*/
  /* reset id and password to blank in case of retry */
  id = "".
  password = "".
  UPDATE SPACE(2) id SKIP  password PASSWORD-FIELD
    WITH CENTERED ROW 8 SIDE-LABELS ATTR-SPACE
	 TITLE " Database " + LDBNAME("DICTDB") + " ".

  currentdb = LDBNAME("DICTDB":u).
  /* Use SET-DB-CLIENT instead of SETUSERID */ 
  hCP:Initialize(id,?,?,password).
  setdbclnt = Set-DB-Client(hCP,currentdb) NO-ERROR. 

  if not setdbclnt then do:
    MESSAGE "Sorry, userid/password is incorrect.".
    IF tries > 1 THEN QUIT.   /* only allow 3 tries*/
    tries = tries + 1.
    UNDO, RETRY.
  END.
  HIDE ALL.
  RETURN.
END.
Delete Object hCP.
hCP = ?.
QUIT.
