/***********************************************************************
* Copyright (C) 2000-2011 by Progress Software Corporation.            *
* All rights reserved.  Prior versions of this work may contain        *
* portions contributed by participants of Possenet.                    *
*                                                                      *
***********************************************************************/

/* Progress Lex Converter 7.1A->7.1B Version 1.11 

History: 07/09/98 D. McMann Added AND _File._Owner = "PUB" to FIND _File
         10/23/02 D. McMann Changed BLANK to PASSWORD-FIELD
         09/22/09 fernando  Reset other can-fields when unsetting sec admin
         04/18/11 Rajinder  OE00208533  fixed error if domain name is empty.

*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

/* LANGUAGE DEPENDENCIES START */ /*---------------------------------------*/

DEFINE VARIABLE qbf AS CHARACTER EXTENT 12 NO-UNDO INITIAL [
  "Next",   "Prev",      "First",    "Last",   "Add",  "Modify",
  "Delete", "CallAdmin", "Security", "Report", "Undo", "Exit"
].
FORM
  qbf[ 1] /*Next*/      FORMAT "x(4)" HELP "Look at the next user."
  qbf[ 2] /*Prev*/      FORMAT "x(4)" HELP "Look at the previous user."
  qbf[ 3] /*First*/     FORMAT "x(5)" HELP "Look at the first user."
  qbf[ 4] /*Last*/      FORMAT "x(4)" HELP "Look at the last user."
  qbf[ 5] /*Add*/       FORMAT "x(3)" HELP "Add a new user."
  qbf[ 6] /*Modify*/    FORMAT "x(6)"
    HELP "Change this user's name and/or password."
  qbf[ 7] /*Delete*/    FORMAT "x(6)" HELP "Delete the displayed user."
  qbf[ 8] /*CallAdmin*/ FORMAT "x(9)"
    HELP "Call to the Security Administrator program."
  qbf[ 9] /*Security*/  FORMAT "x(8)"
    HELP "Go to the Change Data Security program."
  qbf[10] /*Report*/    FORMAT "x(6)"
    HELP "List the current users."
  SKIP 
  qbf[11] /*Undo*/      FORMAT "x(4)"
    HELP "Undo this session's changes to the user list."
  qbf[12] /*Exit*/      FORMAT "x(4)"
    HELP "Exit User Editor, save changes, and return to menu."
  WITH FRAME qbf ATTR-SPACE NO-BOX NO-LABELS OVERLAY
  ROW SCREEN-LINES - 5 COLUMN 3 CENTERED.
/*       "Revoke:Revoke access privileges to tables.", */
/*       "Grant:Grant access privileges to tables.", */

 

DEFINE VARIABLE new_lang AS CHARACTER EXTENT 20 NO-UNDO INITIAL [
  /*  1*/ "This function only works on {&PRO_DISPLAY_NAME} databases.",
  /*  2*/ "You may not use this function with a blank userid.",
  /*  3*/ "You must be a Security Administrator to execute this function.",
  /*  4*/ "You may delete the current User only if it is the only User left.",
  /*  5*/ "Are you sure that you want to remove this user?",
  /*  6*/ "Undo all changes since selection of User Editor from menu?",
  /*7,8*/ "The user named", "has no password assigned.",
  /*  9*/ "You have reached the last user in the table.",
  /* 10*/ "You have reached the first user in the table.",
  /* 11*/ "You did not type the same password each time.",
  /* 12*/ "No User record was created.",
  /* 13*/ ?, /* see below */
  /* 14*/ "The dictionary is in read-only mode - alterations not allowed.",
  /* 15*/ "There are no users in the _User table.",
  /* 16*/ "You haven't yet made changes that need to be undone!",
      	  /* 17 - 20 used together */
  /* 17*/ "You have removed all security administrators, leaving none of",
  /* 18*/ "the remaining users with security administrator privileges.",
  /* 19*/ "There must be at least one user with security administrator",
  /* 20*/ "privileges." 
].
new_lang[13] = "You are about to end the transaction in which you have "
             + "deleted the last User record.!When you do this, you force "
             + "all users to have security administrator privileges. ! "
             + "Do you want to do this?!"
             + "(If not, undo changes or add back a security administrator)".
 
define variable fi-domain-name as character 
                view-as fill-in 
                size 40 by 1  /* fit with button */
                format "x(255)" /*"x(64)" in db */  
                no-undo 
                label "Domain Name".
                
define button btnDomain label "Select Domain...".
define variable  hasPassword as logical no-undo.
 

/*
FORM " " SKIP
  WITH FRAME usr_box OVERLAY
  ROW 2 COLUMN 2 SCREEN-LINES - 6 DOWN NO-LABELS NO-ATTR-SPACE WIDTH 78
  USE-TEXT.
*/
FORM
  _User._Userid      LABEL "User ID"
  _User._Domain-name LABEL "Domain Name"  VIEW-AS FILL-IN SIZE 25 BY 1
  _User._User-Name   VIEW-AS FILL-IN SIZE 15 BY 1   LABEL "User Name"
  _User._sql-only      LABEL "SQL Only" 
  hasPassword label "Password"
  WITH FRAME usr_lst   
  OVERLAY ROW 3 COLUMN 2 NO-LABELS ATTR-SPACE SCREEN-LINES - 12 DOWN SCROLL 1 /*WIDTH 76*/ .

/* avoid warning in gui compile */
&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
    &scoped-define col 13
&ELSE
    &scoped-define col 20
&ENDIF
 
FORM
  _User._Userid  colon {&col}   label "User ID"
/*
    VALIDATE(NOT CAN-FIND(_User USING _User._Userid),
    "User IDs must be unique within each database.")
*/
 
  fi-domain-name colon {&col} label "Domain Name"  
  btndomain
  _User._User-Name   colon {&col} label "User Name"
             view-as fill-in size 40 by 1 
  _User._Password    colon {&col} label "Password" password-field
  _User._sql-only    colon {&col} label "SQL Only" 
  WITH FRAME usr_edit  view-as dialog-box
  OVERLAY ROW 4 centered side-LABELS ATTR-SPACE.

/* LANGUAGE DEPENDENCIES END */ /*-----------------------------------------*/

DEFINE VARIABLE answer     AS LOGICAL               NO-UNDO.
DEFINE VARIABLE i          AS INTEGER INITIAL 0     NO-UNDO.
DEFINE VARIABLE in_trans   AS LOGICAL INITIAL FALSE NO-UNDO.
DEFINE VARIABLE j          AS INTEGER               NO-UNDO.
DEFINE VARIABLE passwd     AS CHARACTER             NO-UNDO.
DEFINE VARIABLE qbf#       AS INTEGER INITIAL 1     NO-UNDO.
DEFINE VARIABLE qbf_disp   AS RECID   INITIAL ?     NO-UNDO.
DEFINE VARIABLE qbf_home   AS RECID                 NO-UNDO.
DEFINE VARIABLE qbf_rec    AS RECID                 NO-UNDO.
DEFINE VARIABLE qbf_was    AS INTEGER INITIAL 2     NO-UNDO.
DEFINE VARIABLE redraw     AS LOGICAL INITIAL TRUE  NO-UNDO.
DEFINE VARIABLE user-cnt-i AS INTEGER INITIAL 0     NO-UNDO.
DEFINE VARIABLE user-cnt-o AS INTEGER               NO-UNDO.
DEFINE VARIABLE istrans AS LOGICAL INITIAL TRUE. /*UNDO (not no-undo!) */

/** Functions ***********************************/
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

/*** triggers  ***********************************/

/*----- HIT OF tenant BUTTON -----*/
ON CHOOSE OF btnDomain IN FRAME usr_edit 
do: 
     
    run selectDomain(fi-domain-name:handle in frame usr_edit).
    
end.

/*** main  ***********************************/

DO ON ERROR UNDO:
  istrans = FALSE.
  UNDO,LEAVE.
END.
 

RUN "prodict/_dctadmn.p" (INPUT USERID(user_dbname),OUTPUT answer).
IF istrans OR PROGRESS = "Run-Time"
  OR CAN-DO("READ-ONLY",DBRESTRICTIONS(user_dbname)) THEN i = 14. /* r/o mode */
IF NOT answer                THEN i = 3. /* secu admin? */
 
IF USERID(user_dbname) = "" THEN
DO:
    if integer(dbversion("DICTDB":U)) > 10 then
    do: 
        if CAN-FIND(FIRST _User where _user._sql-only-user = false) THEN 
            i = 2. /* userid set? */
    end.
    else do: 
        if CAN-FIND(FIRST _User) then
            i = 2. /* userid set? */
    end.
END.

IF user_dbtype <> "PROGRESS" THEN i = 1. /* dbtype okay */
 
/* user-cnt-i: 0=none, 1=one, 2=many - that's all we need to know */     
if integer(dbversion("DICTDB":U)) > 10 then 
do:
    FOR EACH _User where _User._sql-only-user = false WHILE user-cnt-i < 2:
      user-cnt-i = user-cnt-i + 1.
    END.
               
end.
else do:
    FOR EACH _User WHILE user-cnt-i < 2:
      user-cnt-i = user-cnt-i + 1.
    END.
end.    

IF i <> 0 THEN DO:
  MESSAGE new_lang[i] VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

PAUSE 0.
/*VIEW FRAME usr_box.*/

qbf_block:
DO FOR _User TRANSACTION ON ERROR UNDO,RETRY:

  FIND FIRST _User NO-ERROR.
   
  
  PAUSE 0.
  VIEW FRAME usr_lst.
   
  qbf_inner:
  DO WHILE TRUE WITH FRAME usr_lst:
    qbf_rec = RECID(_User).

    IF redraw THEN DO:
      DISPLAY qbf WITH FRAME qbf.
      FIND FIRST _User NO-ERROR.
      ASSIGN
        qbf_disp = ?
        qbf_home = RECID(_User)
        redraw   = FALSE.
      IF qbf_rec <> ? THEN
        FIND _User WHERE RECID(_User) = qbf_rec NO-ERROR.
      ASSIGN
        qbf_rec = RECID(_User)
        j       = (IF FRAME-LINE = 0 THEN 1 ELSE FRAME-LINE)
        i       = 3.
      UP j - 1.
      IF j > 1 THEN DO i = 2 TO j WHILE AVAILABLE _User:
        FIND PREV _User NO-ERROR.
      END.
      IF NOT AVAILABLE _User THEN DO:
        FIND FIRST _User NO-ERROR.
        j = i - 2.
      END.
      DO i = 1 TO FRAME-DOWN:
          /*
        IF INPUT _User-name = (IF AVAILABLE _User THEN _User-name ELSE "")
          AND INPUT _Userid = (IF AVAILABLE _User THEN _Userid ELSE "") THEN .
        ELSE*/
         IF AVAILABLE _User THEN
          DISPLAY _Userid _Domain-name _User-name _sql-only 
          
/*          _User._Password <> ENCODE("") @ hasPassword*/
          
          .
        ELSE
          CLEAR NO-PAUSE.
        COLOR DISPLAY VALUE(IF RECID(_User) = qbf_rec AND RECID(_User) <> ?
          THEN "MESSAGES" ELSE "NORMAL") _Userid _Domain-name _User-name _sql-only hasPassword.
        DOWN.
        FIND NEXT _User NO-ERROR.
      END.
      IF qbf_rec <> ? THEN
        FIND _User WHERE RECID(_User) = qbf_rec NO-ERROR.
      UP FRAME-DOWN - j + 1.
    END.

    IF qbf_was <> FRAME-LINE THEN DO:
      i = FRAME-LINE.
      DOWN qbf_was - i.
      COLOR DISPLAY NORMAL _Userid _Domain-name _User-name _sql-only hasPassword.
      DOWN i - qbf_was.
      IF qbf_rec <> ? THEN COLOR DISPLAY MESSAGES _Userid _Domain-name _User-name _sql-only hasPassword.
      qbf_was = FRAME-LINE.
    END.

    IF AVAILABLE _User AND qbf_disp <> RECID(_User) THEN
      DISPLAY _Userid _Domain-name _User-name _sql-only
/*       _User._Password <> ENCODE("") @ hasPassword*/
        .
    qbf_disp = RECID(_User).

    ON CURSOR-LEFT BACK-TAB.
    ON CURSOR-RIGHT     TAB.
    _choose: DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
      IF qbf# > 12 THEN qbf# = qbf# - 12.
      IF qbf# >= 1 AND qbf# <= 12 THEN NEXT-PROMPT qbf[qbf#] WITH FRAME qbf.
      CHOOSE FIELD qbf NO-ERROR AUTO-RETURN GO-ON ("CURSOR-UP" "CURSOR-DOWN")
        WITH FRAME qbf.
      qbf# = FRAME-INDEX.
      IF KEYFUNCTION(LASTKEY) = CHR(LASTKEY) AND CHR(LASTKEY) <> "."
        AND NOT qbf[qbf#] BEGINS CHR(LASTKEY) THEN UNDO,RETRY _choose.
    END.
    ON CURSOR-LEFT  CURSOR-LEFT.
    ON CURSOR-RIGHT CURSOR-RIGHT.
    i = LOOKUP(KEYFUNCTION(LASTKEY),
        "CURSOR-DOWN,CURSOR-UP,,END,,,,,,,,END-ERROR,PAGE-DOWN,PAGE-UP").
    IF i > 0 THEN qbf# = i.
    IF CAN-DO("HOME,MOVE",KEYFUNCTION(LASTKEY)) THEN
      qbf# = (IF qbf_rec = qbf_home THEN 4 ELSE 3).

    HIDE MESSAGE NO-PAUSE.
    redraw = qbf# > 2.

    IF qbf# = 1 THEN DO: /*---------------------------------- start of NEXT */
      FIND NEXT _User NO-ERROR.
      IF NOT AVAILABLE _User THEN DO:
        FIND LAST _User NO-ERROR.
        MESSAGE new_lang[IF AVAILABLE _User THEN 9 ELSE 15].
      END.
      ELSE DO:
        IF FRAME-LINE = FRAME-DOWN THEN qbf_was = qbf_was - 1.
        IF FRAME-LINE = FRAME-DOWN THEN
          SCROLL UP.
        ELSE
          DOWN.
      END.
    END. /*---------------------------------------------------- end of NEXT */
    ELSE
    IF qbf# = 2 THEN DO: /*---------------------------------- start of PREV */
      FIND PREV _User NO-ERROR.
      IF NOT AVAILABLE _User THEN DO:
        FIND FIRST _User NO-ERROR.
        MESSAGE new_lang[IF AVAILABLE _User THEN 10 ELSE 15].
      END.
      ELSE DO:
        IF FRAME-LINE = 1 THEN qbf_was = qbf_was + 1.
        IF FRAME-LINE = 1 THEN
          SCROLL DOWN.
        ELSE
          UP.
      END.
    END. /*---------------------------------------------------- end of PREV */
    ELSE
    IF qbf# = 3 THEN DO: /*--------------------------------- start of FIRST */
      FIND FIRST _User NO-ERROR.
      UP FRAME-LINE - 1.
      MESSAGE new_lang[IF AVAILABLE _User THEN 10 ELSE 15].
    END. /*--------------------------------------------------- end of FIRST */
    ELSE
    IF qbf# = 4 THEN DO: /*---------------------------------- start of LAST */
      FIND LAST _User NO-ERROR.
      DOWN FRAME-DOWN - FRAME-LINE.
      MESSAGE new_lang[IF AVAILABLE _User THEN 9 ELSE 15].
    END. /*---------------------------------------------------- end of LAST */
    ELSE
    IF qbf# = 5 THEN 
    _qbf5: 
    DO ON ERROR UNDO,LEAVE: /*-------- start of ADD */
      FRAME usr_edit:title = "Add User".
      /* Workaround bug inner-lines is included in size.
         View the frame with inner-lines 1 before call to initModFrame, 
         which increases the inner-lines again.  */      
      do with frame usr_edit:
          
          VIEW FRAME usr_edit.
          
          DISPLAY "" @ _Userid "" @ fi-domain-name "" @ _User-name "" @ _Password NO @ _sql-only.
          DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE :
            PROMPT-FOR 
                _Userid 
                fi-domain-name 
                btndomain 
                _User-name 
                _Password 
                _sql-only.
          END.
          passwd = ENCODE(INPUT _Password).
          IF KEYFUNCTION(LASTKEY) = "END-ERROR" THEN LEAVE _qbf5.
          IF INPUT _Password <> "" THEN DO:
            RUN "prodict/user/_usrpwd2.p" (INPUT passwd, OUTPUT answer).
            IF answer = NO THEN DO:
              MESSAGE new_lang[11] SKIP /* didn't type same passwd each time */
                   	  new_lang[12] 	    /* no user record created */
          	       	  VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            END.
            IF answer <> YES THEN LEAVE _qbf5.
          END.
          CREATE _User.
          ASSIGN
            _Userid    = INPUT FRAME usr_edit _Userid
            _User-name = INPUT FRAME usr_edit _User-name
            _Password  = passwd
            _Domain-name = FRAME usr_edit fi-domain-name
            _sql-only = INPUT FRAME usr_edit _sql-only.
          IF INPUT _Password = "" THEN /* note: user xxx has no passwd */
            MESSAGE new_lang[7] + " ~"" + _Userid + "~" " + new_lang[8].
      end. /* do with frame usr_edit */
      qbf_was = (IF FRAME-LINE = 1 THEN FRAME-DOWN ELSE FRAME-LINE - 1).
      DOWN FRAME-DOWN - FRAME-LINE .
      in_trans = TRUE.
   
    END. /*----------------------------------------------------- end of ADD */
    ELSE
    IF qbf# = 6 AND qbf_rec <> ? THEN /*------------------- start of MODIFY */
    DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE WITH FRAME usr_edit:
      FRAME usr_edit:title = "Modify User".
      
      btnDomain:hidden = yes.
      DISPLAY _Userid 
              _Domain-name @ fi-domain-name
              _User-name
              _sql-only.
      PROMPT-FOR  
                 fi-domain-name
                 btndomain 
                 _User-name 
/*                _Password*/
                _sql-only.
      ASSIGN
        in_trans   = in_trans OR _User-name ENTERED
        _User-name = INPUT FRAME usr_edit _User-name 
        _Domain-name = INPUT FRAME usr_edit fi-domain-name
        _sql-only = INPUT FRAME usr_edit _sql-only.
         
    END. /*-------------------------------------------------- end of MODIFY */
    ELSE
    IF qbf# = 7 AND qbf_rec <> ? THEN DO: /*--------------- start of DELETE */
      IF FullUserId(_Userid,_Domain-name) = USERID(user_dbname) THEN DO:
        FIND FIRST _User WHERE _Userid <> USERID(user_dbname) NO-ERROR.
        IF AVAILABLE _User THEN DO:
          MESSAGE new_lang[4]. /* can only delete self if last user */
      	 
      	  FIND _User WHERE _User._UserId = USERID(user_dbname). /* refind */
      	  
          NEXT.
        END.
        FIND _User WHERE RECID(_User) = qbf_rec.
      END.
      DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
        answer = FALSE. /* are you sure... delete? */
        RUN "prodict/user/_usrdbox.p"
          (INPUT-OUTPUT answer,?,?,new_lang[5]).
        IF answer THEN DO:
          DELETE _User.
          in_trans = in_trans OR answer.
        END.
      END.
    END. /*-------------------------------------------------- end of DELETE */
    ELSE
    IF qbf# = 8 THEN DO: /*---------------------------- start of CALL-ADMIN */
      user_path = "_usradmn,_usruchg".
      LEAVE qbf_inner.
    END. /*---------------------------------------------- end of CALL-ADMIN */
    ELSE
    IF qbf# = 9 THEN DO: /*------------------------------ start of SECURITY */
      user_path = "1=o,_usrtget,9=rw,_usrsecu".
      LEAVE qbf_inner.
    END. /*------------------------------------------------ end of SECURITY */
    ELSE
    IF qbf# = 10 THEN DO: /*------------------------------- start of REPORT */
      user_path = "_rptuqik,_usruchg".
      LEAVE qbf_inner.
    END. /*-------------------------------------------------- end of REPORT */
    ELSE
    IF qbf# = 11 THEN DO: /*--------------------------------- start of UNDO */
      IF in_trans THEN DO:
        answer = FALSE. /* undo session? */
        RUN "prodict/user/_usrdbox.p"
          (INPUT-OUTPUT answer,?,?,new_lang[6]).
        IF answer THEN DO:
          in_trans = FALSE.
          UNDO qbf_block,RETRY qbf_block.
        END.
      END.
      ELSE
        MESSAGE new_lang[16]. /* what changes? */
    END. /*---------------------------------------------------- end of UNDO */
    ELSE
    IF qbf# = 12 THEN _qbf12: DO: /*------------------------- start of EXIT */
      /* user-cnt-o: 0=none, 1=one, 2=many - that's all we need to know */
      user-cnt-o  = 0.
      
      if integer(dbversion("DICTDB":U)) > 10 then 
      do:      
          FOR EACH _User where _User._sql-only-user = false WHILE user-cnt-o < 2:
            user-cnt-o = user-cnt-o + 1.
          END.
      end.
      else do:
          FOR EACH _User WHILE user-cnt-o < 2:
            user-cnt-o = user-cnt-o + 1.
          END.
      end.
      
      IF user-cnt-i = 0 AND user-cnt-o = 0 THEN .   /* don't care */
      ELSE
      IF user-cnt-o > 0 THEN DO: /* chgd or added _User: kill last sec adm? */
        answer = FALSE.
        
        if integer(dbversion("DICTDB":U)) > 10 then 
        do:
            FOR EACH _User where _User._sql-only-user = false WHILE NOT answer:
              RUN "prodict/_dctadmn.p"  /* determines if user is sec administrator */
                  (FullUserId(_User._Userid,_User._Domain-Name), OUTPUT answer).  
            END.
        end.
        else do:
            FOR EACH _User WHILE NOT answer:
              RUN "prodict/_dctadmn.p"  /* determines if user is sec administrator */
                  (FullUserId(_User._Userid,_User._Domain-Name), OUTPUT answer).  
            END.  
        end.
        
        IF NOT answer THEN DO:
      	  MESSAGE new_lang[17] SKIP
      	       	  new_lang[18] SKIP
      	       	  new_lang[19] SKIP
      	       	  new_lang[20]
      	       	  VIEW-AS ALERT-BOX ERROR BUTTONS OK.
          LEAVE _qbf12.
        END.
      END.
      ELSE /* last non sql _User deleted */
      IF user-cnt-i > 0 AND user-cnt-o = 0 THEN DO: 
        answer = FALSE.
        RUN "prodict/user/_usrdbox.p"
          (INPUT-OUTPUT answer,?,?,new_lang[13]).
        IF NOT answer THEN LEAVE _qbf12.

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
                              AND _File._Owner = "PUB" .
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

      LEAVE qbf_inner.
    END. /*---------------------------------------------------- end of EXIT */
    ELSE
    IF qbf_rec <> ? AND qbf# = 13 THEN DO: /*----------- start of NEXT-PAGE */
      DO i = 1 TO FRAME-DOWN WHILE AVAILABLE _User:
        FIND NEXT _User NO-ERROR.
      END.
      IF NOT AVAILABLE _User THEN DO:
        DOWN FRAME-DOWN - FRAME-LINE.
        FIND LAST _User NO-ERROR.
      END.
    END. /*----------------------------------------------- end of NEXT-PAGE */
    ELSE
    IF qbf_rec <> ? AND qbf# = 14 THEN DO: /*----------- start of PREV-PAGE */
      DO i = 1 TO FRAME-DOWN WHILE AVAILABLE _User:
        FIND PREV _User NO-ERROR.
      END.
      IF NOT AVAILABLE _User THEN DO:
        FIND FIRST _User NO-ERROR.
        UP FRAME-LINE - 1.
      END.
    END. /*----------------------------------------------- end of PREV-PAGE */

  END. /* iterating block */

END. /* scoping block */


HIDE FRAME qbf     NO-PAUSE.
/*HIDE FRAME usr_box NO-PAUSE.*/
HIDE FRAME usr_lst NO-PAUSE.
RETURN.

/**** prcedures  ******************************************************/
/*
Procedure initModFrame: 
    /* "fillin" "combo" or "browse" */
    define input  parameter pMode as character no-undo.
    define variable hlabel as handle no-undo.
 
    do with frame usr_edit:
       display cdomainlabel. 
       fi-domain-name:hidden = pmode = "combo" .
              
       /* tty */
/*       fi-domain-name:side-label-handle:hidden = pmode = "combo" .*/
       
       btnDomain:hidden = pmode <> "browse".
       			  
       cmb-domain-name:hidden = pmode <> "combo".
/*       cmb-domain-name:side-label-handle:hidden = pmode <> "combo".*/
       
     /*  if pmode = "combo" then 
       do: 
           if cmb-domain-name:list-items = ? then
               cmb-domain-name:list-items = getDomainList("_oeusertable",cmb-domain-name:delimiter).     
           cmb-domain-name:inner-lines = min(9,num-entries(cmb-domain-name:list-items)).
       end.  */ 
   end.  
   catch e as Progress.Lang.Error :
   		message e:GetMessage(1).
   end catch.
end procedure.   
*/
Procedure selectDomain :
    define input  parameter hField as handle no-undo.
    define variable domaindlg as prodict.pro._domain-sel-presenter no-undo.
    domaindlg = new  prodict.pro._domain-sel-presenter ().
    do with frame usr_edit:
      
       domaindlg:Row = hField:row + hField:height +  hField:frame:row  .
        
       domaindlg:QueryString = "for each ttdomain where ttdomain.DomainTypeName = " + quoter("_oeusertable") .
   
       domaindlg:Title = "Select Authentication System Domain".
/*    glInSelect = true. /* stop end-error anywhere trigger */*/
       if domaindlg:Wait() then 
           hField:screen-value = domaindlg:ColumnValue("ttdomain.Name").
/*    glInSelect = false.*/
   end.
end.   
