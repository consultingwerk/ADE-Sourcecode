/*********************************************************************
* Copyright (C) 2000-2025 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* Progress Lex Converter 7.1A->7.1B Version 1.11 */

/* _usrpwd2.p - user password verification procedure 
   Modified on 04/16/25 by Talha Masood. Replaced ENCODE with GENERATE-PASSWORD-HASH to support FIPS
               05/14/25 by Talha Masood. Allowed _Password to have value greater than 16 characters */


{prodict/user/uservar.i}

/* New password entered - in encoded form */
DEFINE INPUT  PARAMETER p_newpwd AS CHAR    NO-UNDO. 

/* Set to yes if user types password correctly, no if password doesn't match
   or ? if user cancels out of box. */
DEFINE OUTPUT PARAMETER p_ok     AS LOGICAL NO-UNDO. 

FORM
  SKIP({&TFM_WID})
  "For verification purposes, please type     " AT 2 VIEW-AS TEXT SKIP
  "the same password in again. Remember"       AT 2 VIEW-AS TEXT SKIP
  "that passwords are case-sensitive.        " AT 2 VIEW-AS TEXT SKIP({&VM_WIDG})
  DICTDB._User._Password {&STDPH_FILL} PASSWORD-FIELD AT 2 VIEW-AS FILL-IN SIZE 34 BY 1 FORMAT "X(80)" LABEL "Password"
  {prodict/user/userbtns.i}
  WITH FRAME usr_passwd 
    CENTERED SIDE-LABELS ATTR-SPACE 
    DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
    VIEW-AS DIALOG-BOX TITLE "Password Verification".


/*===============================Triggers=================================*/

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
/*----- HELP -----*/
on HELP of frame usr_passwd
   or CHOOSE of btn_Help in frame usr_passwd
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
      	       	     	     INPUT {&Password_Verification_Dlg_Box},
      	       	     	     INPUT ?).
&ENDIF

ON WINDOW-CLOSE OF FRAME usr_passwd
   APPLY "END-ERROR" TO FRAME usr_passwd.


/*==========================Mainline Code================================*/

{adecomm/okrun.i  
    &FRAME  = "FRAME usr_passwd" 
    &BOX    = "rect_Btns"
    &OK     = "btn_OK" 
    {&CAN_BTN}
    {&HLP_BTN}
}

DO ON ERROR UNDO, LEAVE  ON ENDKEY UNDO, LEAVE:
  PROMPT-FOR _User._Password btn_OK btn_Cancel {&HLP_BTN_NAME}
         WITH FRAME usr_passwd.
  IF SECURITY-POLICY:FIPS-MODE OR p_newpwd BEGINS "uphA1::" THEN
     p_ok = SECURITY-POLICY:VALIDATE-PASSWORD(INPUT FRAME usr_passwd _Password,p_newpwd).
   ELSE
     p_ok = p_newpwd = ENCODE(INPUT FRAME usr_passwd _Password).
  RETURN.
END.

p_ok = ?.
RETURN.
