/***********************************************************************
* Copyright (C) 2000,2006 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/

/* Progress Lex Converter 7.1A->7.1B Version 1.11
   History:  D. McMann 10/23/02 Changed BLANK to PASSWORD-FIELD
 
 */

{ prodict/dictvar.i }
{ prodict/user/uservar.i }


/* LANGUAGE DEPENDENCIES START */ /*---------------------------------------*/
DEFINE VARIABLE new_lang AS CHARACTER EXTENT 10 NO-UNDO INITIAL [
  /*  1*/ "This function only works on {&PRO_DISPLAY_NAME} databases.",
  /*  2*/ "You may not use this function with a blank userid.",
  /*  3*/ "You must be a Security Administrator to execute this function.",
  /*  4*/ "Your userid does not exist in the User table.",
  /*  5*/ "You did not type the same password each time.",
  /*  6*/ "Your password has not been changed.",
  /*7,8*/ "The user named", "now has no password assigned.",
  /*  9*/ "Your new password has been set.",
  /* 10*/ "The dictionary is in read-only mode - alterations not allowed."
].
/* LANGUAGE DEPENDENCIES END */ /*-----------------------------------------*/

DEFINE VARIABLE answer      AS LOGICAL     NO-UNDO.
DEFINE VARIABLE canned      AS LOGICAL     NO-UNDO INITIAL TRUE.
DEFINE VARIABLE msg-num     AS INTEGER     NO-UNDO INITIAL 0.
DEFINE VARIABLE new-pwd_enc AS CHARACTER   NO-UNDO.
DEFINE VARIABLE new-pwd     AS CHARACTER   NO-UNDO.

FORM
  SKIP({&TFM_WID})
  DICTDB._User._Password {&STDPH_FILL} PASSWORD-FIELD      AT 2 LABEL "New Password"
  "(case-sensitive)"
  {prodict/user/userbtns.i}
  WITH FRAME usr_please 
    CENTERED SIDE-LABELS ATTR-SPACE 
    DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
    VIEW-AS DIALOG-BOX TITLE "Change Password".


/*===============================Triggers=================================*/

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
/*----- HELP -----*/
on HELP of frame usr_please
   or CHOOSE of btn_Help in frame usr_please
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
      	       	     	     INPUT {&Change_Your_Password_Dlg_Box},
      	       	     	     INPUT ?).
&ENDIF

ON WINDOW-CLOSE OF FRAME usr_please
   APPLY "END-ERROR" TO FRAME usr_please.


/*==========================Mainline Code================================*/

/*RUN prodict/_dctadmn.p (INPUT USERID(user_dbname),OUTPUT answer).*/
IF dict_rog                  THEN msg-num = 10. /* r/o mode   */
IF NOT CAN-FIND(DICTDB._User WHERE DICTDB._User._Userid = USERID(user_dbname))
                             THEN msg-num = 4. /* not in user */
/*IF NOT answer              THEN msg-num = 3. /* secu admin? */*/
IF USERID(user_dbname) = ""  THEN msg-num = 2. /* userid set? */
IF user_dbtype <> "PROGRESS" THEN msg-num = 1. /* dbtype okay */

IF msg-num <> 0 THEN DO:
  MESSAGE new_lang[msg-num] VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

/* Adjust the graphical rectangle and the ok and cancel buttons */
{adecomm/okrun.i  
    &FRAME  = "FRAME usr_please" 
    &BOX    = "rect_Btns"
    &OK     = "btn_OK" 
    {&CAN_BTN}
    {&HLP_BTN}
}
PAUSE 0.
VIEW FRAME usr_please.
DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
  PROMPT-FOR _Password btn_OK btn_Cancel {&HLP_BTN_NAME} WITH FRAME usr_please.

  new-pwd = INPUT FRAME usr_please _Password.
  new-pwd_enc = ENCODE(new-pwd).
  canned = FALSE.
END.
HIDE FRAME usr_please NO-PAUSE.

IF canned THEN RETURN.

/* Verify the password by having user retype it */
IF new-pwd_enc <> ENCODE("") THEN DO:
  RUN "prodict/user/_usrpwd2.p" (INPUT new-pwd_enc, OUTPUT answer).
  if answer = NO THEN DO:
    MESSAGE new_lang[5] SKIP /* didn't type same passwd each time */
	    new_lang[6]      /* password not changed */
	    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN.
  END.
  ELSE IF answer = ? THEN RETURN.  /* user cancelled out */
END.

FIND DICTDB._User WHERE DICTDB._User._Userid = USERID(user_dbname).
DO ON ERROR UNDO, LEAVE:
  DICTDB._User._Password = new-pwd_enc.
  
  IF new-pwd = "" THEN /* note: user xxx has no passwd */
    MESSAGE new_lang[7] + " ~"" + _Userid + "~" " + new_lang[8]
	    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
  ELSE
    MESSAGE new_lang[9]	/* password was set */
	    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
END.
RETURN.
