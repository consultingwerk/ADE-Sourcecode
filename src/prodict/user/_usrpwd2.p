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

/* _usrpwd2.p - user password verification procedure */

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
  DICTDB._User._Password {&STDPH_FILL} BLANK AT 2 LABEL "Password"
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
  p_ok = p_newpwd = ENCODE(INPUT FRAME usr_passwd _Password).
  RETURN.
END.

p_ok = ?.
RETURN.
