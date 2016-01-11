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

/*------------------------------------------------------------------
   Add/Modify/Delete users from the user list (_User table).

   Author: Tony Lavinio, Laura Stern
-------------------------------------------------------------------*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

/* LANGUAGE DEPENDENCIES START */ /*---------------------------------------*/

DEFINE VARIABLE new_lang AS CHARACTER EXTENT 26 NO-UNDO INITIAL [
  /*  1*/ "This function only works on PROGRESS databases.",
  /*  2*/ "You may not use this function with a blank userid.",
  /*  3*/ "You must be a Security Administrator to execute this function.",
  /*  4*/ "You may delete the current User only if it is the only User left.",
  /*  5*/ "Are you sure that you want to remove this user?",
  /*  6*/ "Undo all changes made in this dialog box?",
  /*  7*/ "(no password)",
  /*  8*/ "(password assigned)",
  /*  9*/ "Add User",
  /* 10*/ "Modify User Name",
  /* 11*/ "You did not type the same password each time.",
  /* 12*/ "No User record was created.",
  /* 13*/ "The dictionary is in read-only mode - alterations not allowed.",
      	  /* 14 - 17 used together */
  /* 14*/ "You have removed all security administrators, leaving none of",
  /* 15*/ "the remaining users with security administrator privileges.",
  /* 16*/ "There must be at least one user with security administrator",
  /* 17*/ "privileges.",
      	  /* 18 - 22 used together */
  /* 18*/ "You are about to end the transacton in which",
  /* 19*/ "you have deleted the last User record.  When",
  /* 20*/ "you do this, you will force all users to have",
  /* 21*/ "security administrator privileges.",
  /* 22*/ "Do you want to do this?  (If not, either cancel",
  /* 23*/ "out or add back a security administrator.)",
  /* 24*/ "This User ID already exists.",
  /* 25*/ "User IDs must be unique within each database.",
  /* 26*/ "The User ID cannot be the unknown value."
].

/* Form variables */
DEFINE VARIABLE ulist AS CHAR NO-UNDO INITIAL ?
   VIEW-AS SELECTION-LIST SINGLE INNER-CHARS 12 INNER-LINES 6 SCROLLBAR-V.

DEFINE BUTTON btn_add LABEL "&Add..."    SIZE 12 BY 1.
DEFINE BUTTON btn_mod LABEL "&Modify..." SIZE 12 BY 1.
DEFINE BUTTON btn_del LABEL "&Delete..." SIZE 12 BY 1.

/* Miscellaneous */
DEFINE VARIABLE stat AS LOGICAL NO-UNDO.
DEFINE VARIABLE answer        AS LOGICAL               NO-UNDO.
DEFINE VARIABLE changed       AS LOGICAL INITIAL NO    NO-UNDO.
DEFINE VARIABLE istrans       AS LOGICAL INITIAL TRUE. /* (not no-undo!) */
DEFINE VARIABLE user_cnt_in   AS INTEGER INITIAL 0     NO-UNDO. 
DEFINE VARIABLE user_cnt_out  AS INTEGER INITIAL 0     NO-UNDO. 
DEFINE VARIABLE ix            AS INTEGER INITIAL 0     NO-UNDO.
DEFINE VARIABLE num  	      AS INTEGER               NO-UNDO.
DEFINE VARIABLE ldummy        AS LOGICAL               NO-UNDO.

FORM
   SKIP({&TFM_WID})
   ulist       	     LABEL "User ID's"  COLON 12	     SKIP({&VM_WIDG})

   _User._Userid     LABEL "User ID"   COLON 12 
      	       	     	      	       VIEW-AS TEXT          SKIP
   _User._User-Name  LABEL "User Name" COLON 12  
      	       	     FORMAT "x(30)"    VIEW-AS TEXT SKIP
   _User._Password   LABEL "Password"  COLON 12
      	       	     FORMAT "x(20)"    VIEW-AS TEXT  
   {prodict/user/userbtns.i}
   btn_add     	     	      	       AT COL 32 ROW 2       SKIP({&VM_WID})
   btn_mod     	     	      	       AT 32   	      	     SKIP({&VM_WID})   
   btn_del     	     	      	       AT 32   	      	     SKIP({&VM_WID})
   WITH FRAME usr_lst
   CENTERED SIDE-LABELS 
   DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
   VIEW-AS DIALOG-BOX TITLE "Edit User List".

FORM
   SKIP({&TFM_WID})
   _User._Userid     {&STDPH_FILL} LABEL "User ID"   COLON 12 SKIP ({&VM_WID})
   _User._User-Name  {&STDPH_FILL} LABEL "User Name" COLON 12 SKIP ({&VM_WID})
   _User._Password   {&STDPH_FILL} LABEL "Password"  COLON 12 BLANK
   {prodict/user/userbtns.i}
   WITH FRAME usr_mod
   CENTERED SIDE-LABELS 
   DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
   VIEW-AS DIALOG-BOX.

/* LANGUAGE DEPENDENCIES END */ /*-----------------------------------------*/


/*========================Internal Procedures=============================*/

/*--------------------------------------------------------------------
   Show information on the user selected in the information area.

   Input Parameter:
      p_Id = If ? - We've already got the record, display values 
      	     else - Get the record with this userid and 
      	       	    display the values (it may be "" if no users).
---------------------------------------------------------------------*/
PROCEDURE Show_User:

   DEFINE INPUT PARAMETER p_Id AS CHAR NO-UNDO.

   /* Find user record unless we've got it already */
   IF p_Id <> ? THEN   
      FIND _User WHERE _User._Userid = p_Id NO-ERROR.
   IF AVAILABLE _User THEN
      DISPLAY 
	 _User._Userid 
	 _User._User-name 
	 new_lang[IF _User._Password = ENCODE("") THEN 7 ELSE 8] 
	    @ _User._Password
	 WITH FRAME usr_lst.
   ELSE
      DISPLAY 
      	 "" @ _User._Userid
      	 "" @ _User._User-name
      	 "" @ _User._Password
      	 WITH FRAME usr_lst.
END.


/*===============================Triggers=================================*/

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
/*----- HELP -----*/
on HELP of frame usr_lst
   or CHOOSE of btn_Help in frame usr_lst
   RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
      	       	     	     INPUT {&Edit_User_List_Dlg_Box},
      	       	     	     INPUT ?).

on HELP of frame usr_mod
   or CHOOSE of btn_Help in frame usr_mod
do: 
   IF FRAME usr_mod:TITLE = new_lang[9] then
     RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
       	       	     	       INPUT {&Add_User_Dlg_Box},
      	       	     	       INPUT ?).
   else
     RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
      	       	     	       INPUT {&Modify_User_Dlg_Box},
      	       	     	       INPUT ?).
end.
&ENDIF


/*----- ON HIT OF OK BUTTON or GO -----*/
ON GO OF FRAME usr_lst
DO:
   DEFINE VAR rec_id AS RECID NO-UNDO.

   /* user_cnt_out: 0=none, 1=many - that's all we need to know */
   user_cnt_out = (IF AVAILABLE _User THEN 1 ELSE 0).

   IF user_cnt_in = 0 AND user_cnt_out = 0 
      THEN RETURN.   /* don't care */
   ELSE
   IF user_cnt_out > 0 THEN DO: 
      /* some user left (though may not be one we had to start with -
      	 killed last sec adm? */
      rec_id = RECID(_User). /* save current id */
      answer = FALSE.
      FOR EACH _User WHILE NOT answer:
      	 RUN "prodict/_dctadmn.p"  /* determines if user is sec administrator */
         (INPUT _User._Userid, OUTPUT answer).
      END.
      IF NOT answer THEN DO:
      	 /* There are no administrators */
      	 MESSAGE new_lang[14] SKIP  
      	       	 new_lang[15] SKIP
      	         new_lang[16] SKIP
      	         new_lang[17] 	 
      	       	 VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      	 FIND _User WHERE RECID(_User) = rec_id. /* Reset current user rec */
      	 RETURN NO-APPLY.
      END.
   END.
   ELSE DO: /* user_cnt_out = 0 */
      /* Make sure user wants to set all schema table privileges to * */
      MESSAGE new_lang[18] SKIP
      	      new_lang[19] SKIP
      	      new_lang[20] SKIP
      	      new_lang[21] SKIP(1)
      	      new_lang[22] SKIP
      	      new_lang[23] 	 
      	      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer.
      IF NOT answer THEN 
       	 RETURN NO-APPLY.
      
      /* set the security administrator fields back to "*" */
      FIND _File "_File" WHERE _File._Db-recid = drec_db.
      FIND _Field "_Can-read"   OF _File.
      _Field._Can-write = "*".
      FIND _Field "_Can-write"  OF _File.
      _Field._Can-write = "*".
      FIND _Field "_Can-create" OF _File.
      _Field._Can-write = "*".
      FIND _Field "_Can-delete" OF _File.
      _Field._Can-write = "*".
 
      FIND _File "_Field" WHERE _File._Db-recid = drec_db.
      FIND _Field "_Can-read"   OF _File.
      _Field._Can-write = "*".
      FIND _Field "_Can-write"  OF _File.
      _Field._Can-write = "*".
 
      FIND _File "_User" WHERE _File._Db-recid = drec_db.
      ASSIGN
	_File._Can-create = "*"
	_File._Can-delete = "*".
   END.
END.

/*----- ON HIT of CANCEL BUTTON or ENDKEY -----*/
ON CHOOSE OF btn_Cancel IN FRAME usr_lst OR ENDKEY OF FRAME usr_lst
DO:
   IF NOT changed THEN RETURN.  

   answer = yes.
   MESSAGE new_lang[6] /* Are you sure */
      VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer.
   IF NOT answer THEN
      RETURN NO-APPLY.
   ELSE
      changed = no.  /* reset */
END.


/*----- VALUE-CHANGED OF USER LIST -----*/
ON VALUE-CHANGED OF ulist IN FRAME usr_lst
   RUN Show_User (INPUT SELF:SCREEN-VALUE).


/*----- DEFAULT-ACTION (DBL-CLICK) OF USER LIST -----*/
ON DEFAULT-ACTION OF ulist IN FRAME usr_lst
   APPLY "CHOOSE" TO btn_mod IN FRAME usr_lst.


/*----- HIT OF ADD BUTTON -----*/
ON CHOOSE OF btn_add IN FRAME usr_lst 
DO:
   DEFINE VARIABLE passwd AS CHARACTER NO-UNDO.
   DEFINE VARIABLE encpwd AS CHARACTER NO-UNDO.
   
   /*----- GO or HIT of OK BUTTON IN ADD FRAME -----*/
   ON GO OF FRAME usr_mod
   DO:	 
      IF _User._Userid:SCREEN-VALUE IN FRAME usr_mod = "?" THEN DO:
      	 MESSAGE new_lang[26] VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      	 APPLY "ENTRY" TO _User._Userid IN FRAME usr_mod.
      	 RETURN NO-APPLY.
      END.

      /* Verify password if one was typed in */
      passwd = INPUT FRAME usr_mod _User._Password.
      IF passwd = ? THEN passwd = "".
      encpwd = ENCODE(passwd).
      IF passwd <> "" THEN DO:
	 RUN "prodict/user/_usrpwd2.p" (INPUT encpwd, OUTPUT answer).
	 IF answer = NO THEN DO:
	    MESSAGE new_lang[11] SKIP  /* didn't type same passwd each time */
		    new_lang[12]       /* no user record created */
		    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
	    RETURN NO-APPLY.
	 END.
	 ELSE IF answer = ? THEN 
	    RETURN NO-APPLY.
      END.
   END.
   /*-End of OK trigger-*/

   /*----- LEAVE of USERID IN ADD FRAME -----*/
   ON LEAVE OF _User._Userid IN FRAME usr_mod
   DO:
      /* Make sure Id is unique */
      IF SELF:SCREEN-VALUE <> "?" AND
      	 (CAN-FIND(_User USING INPUT FRAME usr_mod _User._Userid)) THEN DO:
      	 MESSAGE new_lang[24] SKIP new_lang[25] /* Id not unique */
      	    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      	 RETURN NO-APPLY.
      END. 	 
   END.
   /*-End of LEAVE trigger-*/

   FRAME usr_mod:TITLE = new_lang[9].
   DO ON ERROR UNDO, LEAVE  ON ENDKEY UNDO, LEAVE:
      CREATE _User.

      UPDATE _User._Userid _User._User-name _User._Password
      	     btn_OK btn_Cancel {&HLP_BTN_NAME}
      	     WITH FRAME usr_mod.

      ASSIGN
	_User._Password  = encpwd
        changed = yes.
   
      /* Add new Id to list and show user info.  If Id is null, store  
      	 blank in the list to get around select list limitations.
      	 When we look for " " vs. "" we still find the correct user 
      	 record.
      */
      IF _User._Userid = "" THEN
      	 ASSIGN
      	    stat = ulist:ADD-LAST(" ") IN FRAME usr_lst
      	    ulist:SCREEN-VALUE IN FRAME usr_lst = " ". 
      ELSE
      	 ASSIGN
      	    stat = ulist:ADD-LAST(_User._Userid) IN FRAME usr_lst
      	    ulist:SCREEN-VALUE IN FRAME usr_lst = _User._Userid.
      RUN Show_User (INPUT ?).

      ASSIGN
      	 num = num + 1
      	 btn_mod:sensitive IN FRAME usr_lst = yes
      	 btn_del:sensitive IN FRAME usr_lst = yes.
   END.
END.


/*----- HIT OF MODIFY BUTTON -----*/
ON CHOOSE OF btn_mod IN FRAME usr_lst 
DO:
   FRAME usr_mod:TITLE = new_lang[10].
   DISPLAY _User._Userid WITH FRAME usr_mod.

   DO ON ERROR UNDO, LEAVE  ON ENDKEY UNDO, LEAVE:
      UPDATE _User._User-name 
      	     btn_OK btn_Cancel {&HLP_BTN_NAME}
      	     WITH FRAME usr_mod.

      changed = yes.
      Run Show_User (INPUT ?).      
   END.
END.


/*----- HIT OF DELETE BUTTON -----*/
ON CHOOSE OF btn_del IN FRAME usr_lst 
DO:
   DEFINE VAR rec_id  AS RECID NO-UNDO.
   DEFINE VAR del_uid AS CHAR  NO-UNDO.  /* User id deleted */

   rec_id = RECID(_User).  /* save current recid and user id */
   del_uid = _User._Userid.

   /* Do some checking if user tries to delete his own Id */
   IF _User._Userid = USERID(user_dbname) THEN DO:
      FIND FIRST _User WHERE _Userid <> USERID(user_dbname) NO-ERROR.
      IF AVAILABLE _User THEN DO:
       	 MESSAGE new_lang[4] /* can only delete self if last user */
      	    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
       	 RETURN.
      END.
      FIND _User WHERE RECID(_User) = rec_id. /* re-find user to delete */
   END.

   DO ON ERROR UNDO,LEAVE:
      MESSAGE new_lang[5] 
      	 VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer.
      IF answer THEN DO:
       	 DELETE _User.
      	 changed = yes.
   
      	 /* Reset choose to item above one just deleted */
      	 RUN "adecomm/_delitem.p" (INPUT ulist:HANDLE IN FRAME usr_lst,
      	       	     	      	  INPUT (if del_uid = "" then " " else del_uid),
      	       	     	      	  OUTPUT num).
      	 IF num > 0 THEN
      	    RUN Show_User (INPUT ulist:SCREEN-VALUE IN FRAME usr_lst).
      	 ELSE DO:
      	    ASSIGN
      	       btn_mod:sensitive IN FRAME usr_lst = no
      	       btn_del:sensitive IN FRAME usr_lst = no.
      	    RUN Show_User (INPUT "").
      	 END.
      END.
   END.
END.


/*----- WINDOW-CLOSE -----*/
ON WINDOW-CLOSE OF FRAME usr_lst
   APPLY "END-ERROR" TO FRAME usr_lst.
ON WINDOW-CLOSE OF FRAME usr_mod
   APPLY "END-ERROR" to FRAME usr_mod.


/*============================Mainline code===============================*/

DO ON ERROR UNDO:
  istrans = FALSE.
  UNDO,LEAVE.
END.
 
RUN "prodict/_dctadmn.p" (INPUT USERID(user_dbname),OUTPUT answer).
IF NOT answer                THEN ix = 3. /* secu admin? */
IF istrans OR PROGRESS = "Run-Time" OR
   CAN-DO("READ-ONLY",DBRESTRICTIONS(user_dbname)) 
      	       	     	     THEN ix = 13. /* r/o mode */
IF USERID(user_dbname) = "" AND CAN-FIND(FIRST _User)
                             THEN ix = 2. /* userid set? */
IF user_dbtype <> "PROGRESS" THEN ix = 1. /* dbtype okay */

IF ix <> 0 THEN DO:
  MESSAGE new_lang[ix] VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

/* user_cnt_in: 0=none, 1=many - that's all we need to know */
FIND FIRST _User NO-ERROR.
user_cnt_in = (IF AVAILABLE _User THEN 1 ELSE 0).

PAUSE 0.

/* Adjust the graphical rectangle and the ok and cancel buttons */
{adecomm/okrun.i  
    &FRAME  = "FRAME usr_lst" 
    &BOX    = "rect_Btns"
    &OK     = "btn_OK" 
    {&CAN_BTN}
    {&HLP_BTN}
}
{adecomm/okrun.i  
    &FRAME  = "FRAME usr_mod" 
    &BOX    = "rect_Btns"
    &OK     = "btn_OK" 
    {&CAN_BTN}
    {&HLP_BTN}
}

/* Fill the list of current users and remember the first to set selection */
num = 0.
FOR EACH _User:
   /* to get around null-string in select list problem: */
   IF _User._Userid = "" THEN 
      stat = ulist:ADD-LAST(" ") IN FRAME usr_lst.
   ELSE
      stat = ulist:ADD-LAST(_User._Userid) IN FRAME usr_lst.
   num = num + 1.
END.
FIND FIRST _User NO-ERROR.
IF AVAILABLE _User THEN DO:
   ulist = _User._Userid.
   /* to get around null-string in select list problem: */
   IF ulist = "" THEN ulist = " ". 
END.

IF ulist <> ? THEN DO:
   DISPLAY ulist WITH FRAME usr_lst.
   RUN Show_User (ulist).
END.

DO TRANSACTION ON ERROR UNDO, LEAVE  ON ENDKEY UNDO, LEAVE:
   ENABLE
      ulist
      btn_add 
      btn_mod WHEN num > 0
      btn_del WHEN num > 0
      btn_OK btn_Cancel {&HLP_BTN_NAME}
      WITH FRAME usr_lst.

   ASSIGN
      ldummy = btn_mod:MOVE-AFTER-TAB-ITEM(btn_add:HANDLE IN FRAME usr_lst).
      ldummy = btn_del:MOVE-AFTER-TAB-ITEM(btn_mod:HANDLE IN FRAME usr_lst).
   WAIT-FOR CHOOSE OF btn_OK IN FRAME usr_lst OR
      GO OF FRAME usr_lst
      FOCUS ulist.
END.

HIDE FRAME usr_lst NO-PAUSE.
RETURN.
