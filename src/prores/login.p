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
/* login.p - prompt user for userid and password and set the userid */

DEFINE VARIABLE id       LIKE _User._Userid.
DEFINE VARIABLE password LIKE _Password.
DEFINE VARIABLE tries    AS INTEGER NO-UNDO.

IF USERID("DICTDB") <> "" OR NOT CAN-FIND(FIRST DICTDB._User) THEN RETURN.
DO ON ENDKEY UNDO, RETURN:  /*return if they hit endkey*/
  /* reset id and password to blank in case of retry */
  id = "".
  password = "".
  UPDATE SPACE(2) id SKIP  password BLANK
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
