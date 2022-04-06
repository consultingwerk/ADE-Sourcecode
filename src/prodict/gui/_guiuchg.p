/***********************************************************************
* Copyright (C) 2000-2011 by Progress Software Corporation.            *
* All rights reserved.  Prior versions of this work may contain        *
* portions contributed by participants of Possenet.                    *
*                                                                      *
***********************************************************************/

/*------------------------------------------------------------------
   Add/Modify/Delete users from the user list (_User table).

   Author: Tony Lavinio, Laura Stern
   
   History:
        tomn    12/06/95    Changed "FIND FIRST _User ... " in 
                            "delete user" trigger to
                            "CAN-FIND(FIRST _User ... " so current _User
                            record does not have to be reset
        D. McMann 10/23/02  Changed BLANK to PASSWORD-FIELD
        fernando  09/22/09  Reset other can-fields when unsetting sec admin
        Rajinder  04/18/11 OE00208533  fixed error if domain name is empty.
                            
-------------------------------------------------------------------*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

/* LANGUAGE DEPENDENCIES START */ /*---------------------------------------*/

DEFINE VARIABLE new_lang AS CHARACTER EXTENT 27 NO-UNDO INITIAL [
  /*  1*/ "This function only works on {&PRO_DISPLAY_NAME} databases.",
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
  /* 26*/ "The User ID cannot be the unknown value.",
  /* 27 */ " Invalid domain name entered."
].

/* Form variables */
DEFINE VARIABLE ulist AS CHAR NO-UNDO INITIAL ?
   VIEW-AS SELECTION-LIST SINGLE INNER-CHARS 45 INNER-LINES 8 SCROLLBAR-V.

DEFINE BUTTON btn_add LABEL "&Add..."    SIZE 12 BY 1.
DEFINE BUTTON btn_mod LABEL "&Modify..." SIZE 12 BY 1.
DEFINE BUTTON btn_del LABEL "&Delete..." SIZE 12 BY 1.

/* Miscellaneous */
DEFINE VARIABLE stat          AS LOGICAL NO-UNDO.
DEFINE VARIABLE answer        AS LOGICAL               NO-UNDO.
DEFINE VARIABLE changed       AS LOGICAL INITIAL NO    NO-UNDO.
DEFINE VARIABLE istrans       AS LOGICAL INITIAL TRUE. /* (not no-undo!) */
DEFINE VARIABLE user_cnt_in   AS INTEGER INITIAL 0     NO-UNDO. 
DEFINE VARIABLE user_cnt_out  AS INTEGER INITIAL 0     NO-UNDO. 
DEFINE VARIABLE ix            AS INTEGER INITIAL 0     NO-UNDO.
DEFINE VARIABLE num  	      AS INTEGER               NO-UNDO.
DEFINE VARIABLE lhasPassword  AS LOGICAL               NO-UNDO.
 

DEFINE VARIABLE domainType    AS CHARACTER INITIAL "_oeusertable" NO-UNDO.
 /*
DEFINE VARIABLE cmb-domain-name AS CHARACTER FORMAT "X(256)":U 
     LABEL "Domain Name"
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST SORT
     SIZE 42 BY 1
      NO-UNDO.
*/
define button btnDomain size 19 by 1.

define buffer b_user for dictdb._user.

DEFINE QUERY qUser FOR  b_user SCROLLING.

DEFINE BROWSE bUser QUERY qUser
    DISPLAY b_User._Userid  column-label "User ID" 
            b_User._Domain-Name  column-label "Domain Name" 
            width 42      
            b_User._User-Name  column-label "User Name"  width 20
            b_User._Password <> ENCODE("") @ lhasPassword 
                                          column-label "Password"        
            b_User._Sql-only-user column-label "SQL Only"
            
    WITH NO-ROW-MARKERS SEPARATORS 6 down.

FORM
   bUser  AT ROW 1.24 COL 1.8  SKIP({&VM_WIDG}) 
   {prodict/user/userbtns.i}
   btn_add     	     	      	       AT COL 103 ROW 1.24 SKIP({&VM_WID})
   btn_mod     	     	      	       AT 103	           SKIP({&VM_WID})   
   btn_del     	     	      	       AT 103  	      	   SKIP({&VM_WID})
   WITH FRAME usr_lst WIDTH 116 /* no particular reason */
   CENTERED SIDE-LABELS 
   DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
   VIEW-AS DIALOG-BOX TITLE "Edit User List".

FORM
   SKIP({&TFM_WID})
   _User._Userid      {&STDPH_FILL} LABEL "User ID"   COLON 16 
    view-as fill-in size 17 by 1   SKIP ({&VM_WID})
   _user._domain-name    {&STDPH_FILL} LABEL "Domain Name"     COLON 16 
    view-as fill-in size 64 by 1    
     btnDomain label "Select Domain..." SKIP({&VM_WID})
    /* cmb-domain-name at col 16 row-of btnDomain  colon-aligned */
   _User._User-Name   {&STDPH_FILL} LABEL "User Name"     COLON 16 
    view-as fill-in size 64 by 1   SKIP ({&VM_WID})
   _User._Password    {&STDPH_FILL} LABEL "Password"     COLON 16 PASSWORD-FIELD  
    view-as fill-in size 17 by 1   SKIP ({&VM_WID})
   _User._sql-only-user {&STDPH_FILL} LABEL "SQL Only"  COLON 16
   {prodict/user/userbtns.i}
   WITH FRAME usr_mod 
   CENTERED SIDE-LABELS   
   width 103
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

function FullUserId returns char(id as char, name as char):
    if name = "" then 
        return id.
    else 
        return id + "@" + name.           
end.     

function GetDomainList returns char (pType as char,pdelimiter as char):
    define variable domainList as character no-undo. 
    run prodict/pro/_pro_domain_list.p(pType,pdelimiter,output domainList). 
    return domainlist.
end.     

procedure openQuery:
    define input  parameter rcurrent as rowid no-undo.    
    open query qUser for each b_user no-lock by b_user._userid by b_user._domain-name .
    if rCurrent = ? then
        reposition quser to row 1.
    else do:
        reposition quser to rowid rCurrent. 
    end.    
end.
/*  
Procedure initModFrame: 
    /* "fillin" "combo" or "browse" */
    define input  parameter pMode as character no-undo.
    define variable hlabel as handle no-undo.
    
    do with frame usr_mod:
       _User._Domain-name:hidden = pmode = "combo" .
       btnDomain:hidden = pmode <> "browse".
       cmb-domain-name:hidden = pmode <> "combo" .
       if pmode = "combo" then 
       do: 
           if cmb-domain-name:list-items = ? then
               cmb-domain-name:list-items = getDomainList(domainType,cmb-domain-name:delimiter).     
           cmb-domain-name:inner-lines = min(9,num-entries(cmb-domain-name:list-items)).
       end.   
   end.  
end procedure.   
   */
Procedure selectDomain :
    define variable domaindlg as prodict.pro._domain-sel-presenter no-undo.
    domaindlg = new  prodict.pro._domain-sel-presenter ().
    do with frame usr_mod:
      
       domaindlg:Row = btnDomain:row + btnDomain:height +  frame usr_mod:row + 0.5.
       domaindlg:Col =  _user._domain-name:col + frame usr_mod:col .
       domaindlg:QueryString = "for each ttdomain where ttdomain.DomainTypeName = " + quoter(domainType) .
   
       domaindlg:Title = "Select Domain".
/*    glInSelect = true. /* stop end-error anywhere trigger */*/
       if domaindlg:Wait() then 
         _user._domain-name:screen-value = domaindlg:ColumnValue("ttdomain.Name").
/*    glInSelect = false.*/
   end.
end.   

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
   if integer(dbversion("DICTDB":U)) > 10 then 
      user_cnt_out = (IF can-find( first _User where _User._sql-only-user = false ) THEN 1 ELSE 0).
   
   else  
      user_cnt_out = (IF can-find( first _User) THEN 1 ELSE 0).

   IF user_cnt_in = 0 AND user_cnt_out = 0 
      THEN RETURN.   /* don't care */
   ELSE
   IF user_cnt_out > 0 THEN DO: 
      /* some user left (though may not be one we had to start with -
      	 killed last sec adm? */
      rec_id = RECID(_User). /* save current id */
      answer = FALSE.
      if integer(dbversion("DICTDB":U)) > 10 then 
      do:
          FOR EACH _User where _User._sql-only-user = false WHILE NOT answer:
              RUN "prodict/_dctadmn.p"  /* determines if user is sec administrator */
                 (FullUserId(_User._Userid,_User._Domain-Name), OUTPUT answer).
          END.
      end.
      else do:
          FOR EACH _User  WHILE NOT answer:
              RUN "prodict/_dctadmn.p"  /* determines if user is sec administrator */
                (FullUserId(_User._Userid,_User._Domain-Name), OUTPUT answer).
         END.
      end.          
     
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
      FIND _File "_File" WHERE _File._Db-recid = drec_db
                           AND _File._Owner = "PUB".
      FIND _Field "_Can-read"   OF _File.
      _Field._Can-write = "*".
      FIND _Field "_Can-write"  OF _File.
      _Field._Can-write = "*".
      FIND _Field "_Can-create" OF _File.
      _Field._Can-write = "*".
      FIND _Field "_Can-delete" OF _File.
      _Field._Can-write = "*".
 
      FIND _File "_Field" WHERE _File._Db-recid = drec_db
                            AND _File._Owner = "PUB".
      FIND _Field "_Can-read"   OF _File.
      _Field._Can-write = "*".
      FIND _Field "_Can-write"  OF _File.
      _Field._Can-write = "*".
 
      FIND _File "_User" WHERE _File._Db-recid = drec_db
                           AND _File._Owner = "PUB".
      ASSIGN
	   _File._Can-create = "*"
	   _File._Can-delete = "*".

      FIND _File "_Db-Option" NO-ERROR.
      IF AVAILABLE _File THEN
          ASSIGN _File._Can-create = "*" 
                 _File._Can-write = "*"
                 _File._Can-delete = "*".

      FIND _File "_Db-Detail" NO-ERROR.
      IF AVAILABLE _File THEN
          ASSIGN _File._Can-create = "*" 
                 _File._Can-write = "*"
                 _File._Can-delete = "*".

      FIND _File "_Db".
      FIND _Field "_Db-guid" OF _File NO-ERROR.
      IF AVAILABLE _Field THEN
          ASSIGN _Field._Can-write = "*".

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

/*----- DEFAULT-ACTION (DBL-CLICK) OF USER LIST -----*/
ON DEFAULT-ACTION OF bUser IN FRAME usr_lst
   APPLY "CHOOSE" TO btn_mod IN FRAME usr_lst.


/*----- HIT OF tenant BUTTON -----*/
ON CHOOSE OF btnDomain IN FRAME usr_mod 
do: 
    run selectDomain.
end.

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

      /* Make sure Id is unique */
      IF SELF:SCREEN-VALUE <> "?" AND
         (CAN-FIND(_User USING INPUT FRAME usr_mod _User._Userid
                         WHERE INPUT _User._Domain-Name = _User._Domain-Name)) THEN DO:
         MESSAGE new_lang[24] SKIP new_lang[25] /* Id not unique */
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
         APPLY "ENTRY" TO _User._Userid IN FRAME usr_mod.   
         RETURN NO-APPLY.
      END.   

      /* Verify password if one was typed in */
      passwd = INPUT FRAME usr_mod _User._Password.
      IF passwd = ? THEN passwd = "".
      encpwd = ENCODE(passwd).
      
      IF _User._Domain-Name:screen-value <> "" then
      DO:
         IF NOT can-find(FIRST DICTDB._sec-authentication-domain 
                           WHERE DICTDB._sec-authentication-domain._Domain-name = _User._Domain-Name:screen-value) then
         DO:
             MESSAGE new_lang[27]
                  VIEW-AS ALERT-BOX.
             RETURN NO-APPLY.
         END.                     
      END.
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
     
       
   END.   /*-End of OK trigger-*/

   /*----- LEAVE of USERID IN ADD FRAME -----*/
/*  moved to ON GO...
   ON LEAVE OF _User._Userid IN FRAME usr_mod
   DO:
      /* Make sure Id is unique */
      IF SELF:SCREEN-VALUE <> "?" AND
      	 (CAN-FIND(_User USING INPUT FRAME usr_mod _User._Userid
      	                 WHERE cmb-domain-name:INPUT-VALUE = _User._Domain-Name)) THEN DO:
      	 MESSAGE new_lang[24] SKIP new_lang[25] /* Id not unique */
      	    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      	 RETURN NO-APPLY.
      END. 	 
   END.
   /*-End of LEAVE trigger-*/
*/
  
   
   FRAME usr_mod:TITLE = new_lang[9].
   DO ON ERROR UNDO, LEAVE  ON ENDKEY UNDO, LEAVE WITH FRAME usr_mod:
      
      CREATE _User.
      DISPLAY "" @ _User._Userid
              "" @ _User._Domain-Name 
              "" @ _User._User-name
              "" @ _User._Password
              _User._sql-only-user
             . 
      SET    _User._Userid 
             _User._Domain-Name  
              btnDomain         
             _User._User-name 
             _User._Password 
             _User._sql-only-user
      	     btn_OK btn_Cancel {&HLP_BTN_NAME}. 
       
      ASSIGN      
        _User._Password  = encpwd
        changed = yes.
         
      ASSIGN
      	 num = num + 1
      	 btn_mod:sensitive IN FRAME usr_lst = yes
      	 btn_del:sensitive IN FRAME usr_lst = yes.
      	       	 
      /* validate ensures row is written to buffer (in case not all fields in (a unique?) index is updated) */	 
     
      validate _user.
       
      run openQuery(rowid(_user)).
   
   END.
      
END.


/*----- HIT OF MODIFY BUTTON -----*/
ON CHOOSE OF btn_mod IN FRAME usr_lst 
DO:
   FRAME usr_mod:TITLE = new_lang[10].
   
   /* we avoid combo for domain-name since the combo has _oeusertable domains
      but we do allow a domain to change to another type even if it has users */
   
   btnDomain:hidden = yes.  
   find _user where rowid(_user) = rowid(b_user) exclusive no-error.
  
   if avail _user then 
   do:
       DISPLAY _User._Userid 
               _User._domain-name 
               IF _User._Password = ENCODE("") THEN "" ELSE "aaaaaaaaaaaa" @ _User._Password
               _User._sql-only-user 
       
       WITH FRAME usr_mod.
       DO ON ERROR UNDO, LEAVE  ON ENDKEY UNDO, LEAVE:
          UPDATE _User._Domain-Name  
                 btnDomain         
                 _User._User-name 
                _User._sql-only-user
          	     btn_OK btn_Cancel {&HLP_BTN_NAME}
          	     WITH FRAME usr_mod.
    
    /*      _User._Domain-Name = cmb-domain-name:INPUT-VALUE. */
          changed = yes.
          reposition qUser to rowid rowid(_user).
          display b_User._User-name with browse buser.    
       END.
      
   end.
END.


/*----- HIT OF DELETE BUTTON -----*/
ON CHOOSE OF btn_del IN FRAME usr_lst 
DO:
   DEFINE VAR row_id  AS ROWID NO-UNDO.
    
   DEFINE VAR prev_id  AS ROWID NO-UNDO.
   DEFINE VAR del_uid AS CHAR  NO-UNDO.  /* User id deleted */
   
   if avail b_user then 
   do:
       row_id = ROWID(b_User).  /* save current recid and user id */
       get prev qUser.
       prev_id  = ROWID(b_User).
       reposition qUser to rowid row_id.
       del_uid = FullUserId(b_User._Userid,b_User._Domain-Name).
        
       /* Do some checking if user tries to delete his own Id */ 
       IF del_uid = USERID(user_dbname) THEN DO:
          IF CAN-FIND(FIRST _User WHERE ROWID(_User) ne row_id)  THEN 
          DO:
           	 MESSAGE new_lang[4] /* can only delete self if last user */
          	    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
           	 RETURN.
          END.
       END.
       find _user where rowid(_user) =  row_id  exclusive .
       DO ON ERROR UNDO,LEAVE:
          MESSAGE new_lang[5] 
          	 VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE answer.
          IF answer THEN DO:
             find current _user exclusive. 
           	 DELETE _User.
           	 num = num - 1.
          	 changed = yes.
             
             get next qUser.
             if avail b_user then 
             do:
              
                 run openQuery(ROWID(b_User)). 
             end.
             else if prev_id <> ? then
             do:
                 run openQuery(prev_id). 
             end.    
             else do:
                 run openQuery(?). 
                 if not avail b_user then
          	     DO:
          	         ASSIGN
          	             btn_mod:sensitive IN FRAME usr_lst = no
          	             btn_del:sensitive IN FRAME usr_lst = no.
          	     END.
          	 end.
          END.
       END.
   end.
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
IF USERID(user_dbname) = "" then 
do:
    if integer(dbversion("DICTDB":U)) > 10 then
    do: 
        if CAN-FIND(FIRST _User where _user._sql-only-user = false) THEN 
            ix = 2. /* userid set? */
    end.
    else do: 
        if CAN-FIND(FIRST _User) then
            ix = 2. /* userid set? */
    end. 
end.
IF user_dbtype <> "PROGRESS" THEN ix = 1. /* dbtype okay */

IF ix <> 0 THEN DO:
  MESSAGE new_lang[ix] VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

/* user_cnt_in: 0=none, 1=many - that's all we need to know */
if integer(dbversion("DICTDB":U)) > 10 then 
do:     
    
    FIND FIRST _User where _User._sql-only-user = false  NO-ERROR.
end.
else do:
    FIND FIRST _User NO-ERROR.
end.

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

/* Fill the list of current users  */
num = 0.

FOR EACH _User no-lock:
   num = num + 1.
END.

run openQuery(?). 
 
DO TRANSACTION ON ERROR UNDO, LEAVE  ON ENDKEY UNDO, LEAVE:
   ENABLE
      bUser
      btn_add 
      btn_mod WHEN num > 0
      btn_del WHEN num > 0
      btn_OK btn_Cancel {&HLP_BTN_NAME}
      WITH FRAME usr_lst.
   
   btn_mod:MOVE-AFTER-TAB-ITEM(btn_add:HANDLE IN FRAME usr_lst).
   btn_del:MOVE-AFTER-TAB-ITEM(btn_mod:HANDLE IN FRAME usr_lst).
   WAIT-FOR CHOOSE OF btn_OK IN FRAME usr_lst OR
      GO OF FRAME usr_lst
      FOCUS bUser.
END.

HIDE FRAME usr_lst NO-PAUSE.
RETURN.
