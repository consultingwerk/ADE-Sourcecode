/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * u-login.p - sample RESULTS login procedure. This is not the
 *             same file as aderes/_slogin.r. That file, the
 *             default login file for RESULTS, contains the
 *             login dialog box that conforms to the PROGRESS
 *             style conventions.
 */

DEFINE VARIABLE id        AS CHARACTER FORMAT "x(16)":u LABEL "Id".
DEFINE VARIABLE password  AS CHARACTER FORMAT "x(16)":u LABEL "Password".
DEFINE VARIABLE currentdb AS CHARACTER FORMAT "x(32)":u NO-UNDO.
DEFINE VARIABLE qbf-i     AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-s     AS CHARACTER NO-UNDO.
DEFINE VARIABLE tries     AS INTEGER   NO-UNDO.

DEFINE BUTTON ok_btn     LABEL "  OK  " AUTO-GO.
DEFINE BUTTON cancel_btn LABEL "Cancel" AUTO-ENDKEY.

DEFINE FRAME login_frame.

FORM
  "Enter a User Id and Password for" VIEW-AS TEXT SKIP
  "database:" VIEW-AS TEXT currentdb VIEW-AS TEXT NO-LABEL SKIP(1)
  id COLON 12 SKIP
  password COLON 12 PASSWORD-FIELD SKIP(1)
  ok_btn AT 10 cancel_btn AT 18

  WITH FRAME login_frame CENTERED SIDE-LABELS ATTR-SPACE THREE-D
  DEFAULT-BUTTON ok_btn CANCEL-BUTTON cancel_btn VIEW-AS DIALOG-BOX
  &IF "{&WINDOW-SYSTEM}":u = "TTY":u &THEN
    ROW 2 TITLE " Login "
  &ELSE
    NO-BOX
  &ENDIF
  .

HIDE MESSAGE NO-PAUSE.

/* Prompt for userid and password in all connected Progress databases 
   (if not supplied as startup parameters).  Non-Progress databases 
   MUST supply userid/passwd using -U and -P startup parameters. */
qbf-s = LDBNAME("DICTDB":u).
IF NUM-DBS > 1 AND LDBNAME("DICTDB":u) = "DICTDB":u THEN DO ON ERROR UNDO,LEAVE:
  BELL.
  MESSAGE
    "You cannot use security if you have more than one database" SKIP
    "connected and the logical name of one database is DICTDB."
    VIEW-AS ALERT-BOX WARNING.
END.
ELSE DO qbf-i = 1 to NUM-DBS:
  IF DBTYPE(qbf-i) <> "PROGRESS":u THEN NEXT.
  CREATE ALIAS "DICTDB":u FOR DATABASE VALUE(LDBNAME(qbf-i)).

  IF USERID("DICTDB":u) <> "" OR NOT CAN-FIND(FIRST DICTDB._User) THEN
    RETURN.

  DO ON ENDKEY UNDO, LEAVE:
    currentdb = LDBNAME("DICTDB":u).
    DISPLAY currentdb WITH FRAME login_frame.

    /* reset id and password to blank in case of retry */
    ASSIGN
      id       = ""
      password = "".
    UPDATE 
      id password ok_btn cancel_btn
      WITH FRAME login_frame.

    IF SETUSERID(id,password,"DICTDB":u) <> TRUE THEN DO:
      MESSAGE "Userid/password is incorrect."
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      IF tries > 1 THEN 
        QUIT. /* only allow 3 tries*/
      tries = tries + 1.
      UNDO, RETRY.
    END.
  END.
  HIDE FRAME login_frame.
END.
IF qbf-s <> ? THEN
  CREATE ALIAS "DICTDB":u FOR DATABASE VALUE(qbf-s).
HIDE MESSAGE NO-PAUSE.

RETURN.

/* u-login.p - end of file */

