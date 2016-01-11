/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/******************************************************************************* 
*
*   PROGRAM:  _login.p
*
*   PROGRAM SUMMARY:
*       Prompt user for userid and password and set the userid.
*       Caller must include login.i NEW.
*
*   RUN/CALL SYNTAX:
*       { login.i NEW }
*       RUN login.p
*
*   PARAMETERS/ARGUMENTS LIST:
*       None
*
*******************************************************************************/


DEFINE INPUT PARAMETER viewAsDialog AS LOGICAL NO-UNDO.

{ login.i }
DEFINE VARIABLE tries    AS INTEGER NO-UNDO.


IF USERID("DICTDB") <> "" OR NOT CAN-FIND(FIRST DICTDB._User) THEN 
    RETURN.

DO ON ENDKEY UNDO, LEAVE:

    currentdb = LDBNAME("DICTDB").

    /* reset id and password to blank in case of retry */
    ASSIGN id = ""
           password = "".

    if viewAsDialog then do:

      DISPLAY currentdb WITH FRAME logindb_frame view-as dialog-box.

      UPDATE id password ok_btn cancel_btn help_btn {&WHEN_HELP}
             WITH FRAME logindb_frame view-as dialog-box.
    end.
    else do:
      DISPLAY currentdb WITH FRAME login_frame.

      UPDATE id password ok_btn cancel_btn help_btn {&WHEN_HELP}
             WITH FRAME login_frame.
    end.
    IF SETUSERID(id,password,"DICTDB") <> TRUE THEN DO:
        MESSAGE "Userid/Password is incorrect."
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        IF tries > 1 THEN 
            QUIT. /* only allow 3 tries*/
        tries = tries + 1.
        UNDO, RETRY.
    END.
END.
HIDE FRAME login_frame.


