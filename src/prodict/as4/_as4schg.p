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

/* _as4schg.p - change _Db record information for as400 dataserver 
   Created from _usrschg.p which is used by other dataservers.
   D. McMann 03/02/95  
   
History:  06/19/96 Added support for logical name D. McMann   
          09/12/96 Added assign of lname if left blank D. McMann
          06/10/99 Add individual connect parameters BUG# 98-07-16-003 Mario B.
          08/02/99 Fix ParmsBox rectangle widget BUG 19990802-10 Mario B.
   
*/

/*
in:  user_env[1] = "add" or "upd"
     user_env[3] = dbtype to add or "" for any AS400    
     user_env[35] = error on connect will equal redo.
 
out: user_env[2] = new _Db._Db-name
     no other environment variables changed
*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }
{ prodict/user/userhue.i }
{ prodict/user/userhdr.f }

DEFINE VARIABLE amode    AS LOGICAL              NO-UNDO. /*true=add,false=modify*/
DEFINE VARIABLE c        AS CHARACTER            NO-UNDO.
DEFINE VARIABLE codepage AS CHARACTER            NO-UNDO format "x(40)".
DEFINE VARIABLE dblst    AS CHARACTER            NO-UNDO.
DEFINE VARIABLE f_comm   AS CHARACTER            NO-UNDO.
DEFINE VARIABLE network  AS CHARACTER            NO-UNDO INITIAL "TCP".
DEFINE VARIABLE host     AS CHARACTER            NO-UNDO.
DEFINE VARIABLE Service AS CHARACTER FORMAT "X(256)" 
     LABEL "Service Name" 
     VIEW-AS FILL-IN 
     SIZE 15 BY 1 NO-UNDO.
DEFINE VARIABLE user_id  AS CHARACTER            NO-UNDO.
DEFINE VARIABLE pass     AS CHARACTER            NO-UNDO.
DEFINE VARIABLE fmode    AS LOGICAL              NO-UNDO. /* part of gateway */
DEFINE VARIABLE i        AS INTEGER  INITIAL 0   NO-UNDO.
DEFINE VARIABLE j        AS INTEGER              NO-UNDO.
DEFINE VARIABLE okay     AS LOGICAL  INIT FALSE  NO-UNDO.
DEFINE VARIABLE ronly    AS LOGICAL              NO-UNDO. /* read only */
DEFINE VARIABLE x-l      AS LOGICAL              NO-UNDO. /* allow set ldb name */
DEFINE VARIABLE canned   AS LOGICAL  INIT TRUE   NO-UNDO.
DEFINE VARIABLE dname    AS CHARACTER            NO-UNDO.
DEFINE VARIABLE ttl      AS CHARACTER            NO-UNDO.
DEFINE VARIABLE lname    AS CHARACTER            NO-UNDO.
DEFINE VARIABLE pname    AS CHARACTER            NO-UNDO.

DEFINE VARIABLE arg_1       AS LOGICAL   NO-UNDO.
DEFINE VARIABLE arg_dt      AS CHARACTER NO-UNDO INITIAL "PROGRESS". 
DEFINE VARIABLE arg_p       AS CHARACTER NO-UNDO.
DEFINE VARIABLE arg_pf      AS CHARACTER NO-UNDO.
DEFINE VARIABLE arg_u       AS CHARACTER NO-UNDO.
DEFINE VARIABLE arg_tl      AS CHARACTER NO-UNDO.
DEFINE VARIABLE arg_network AS CHARACTER NO-UNDO.
DEFINE VARIABLE arg_host    AS CHARACTER NO-UNDO.
DEFINE VARIABLE arg_service AS CHARACTER NO-UNDO.
DEFINE VARIABLE args        AS CHARACTER NO-UNDO EXTENT 4.

DEFINE RECTANGLE ParmsBox
       NO-FILL
       EDGE-PIXELS 2
       SIZE-CHARS 76 BY 4.5
       GRAPHIC-EDGE.

/* LANGUAGE DEP  END.ENCIES START */ /*----------------------------------------*/
DEFINE VARIABLE new_lang AS CHARACTER EXTENT 3 NO-UNDO INITIAL [
  /* 1*/ "There is currently a database using this name as a dbname or alias",
  /* 2*/ "Internal Dictionary Error: inconsistent dbtype encountered.",
  /* 3*/ "Database Library Name may not be left blank or unknown."
].

FORM
  SKIP ({&TFM_WID})
  pname         FORMAT "x(10)" COLON 24 LABEL "Dictionary Library Name" 
  _Db._Db-type  FORMAT "x(10)" COLON 60 LABEL "Database Type" 
     {&STDPH_FILL}  SKIP ({&VM_WID}) 
  lname         FORMAT "x(10)" COLON 24 LABEL "Logical Database Name"
  codepage FORMAT "x(10)"      COLON 60 LABEL "Code-Page"
     {&STDPH_FILL}  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN SKIP (1) &ENDIF
  " CONNECT Parameters " AT 4
  network  FORMAT "x(10)"      COLON 18  LABEL "Network" 
  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
           HELP "Enter AS400SNA or TCP"
  &ELSE
           VIEW-AS COMBO-BOX SORT LIST-ITEMS "TCP", "AS400SNA" 
	   SIZE 16 BY 1
  &ENDIF	   
     {&STDPH_FILL}  SKIP ({&VM_WID})
  host     FORMAT "x(10)"      COLON 18 LABEL "Host Name"	   
  service   COLON 52  {&STDPH_FILL}  SKIP ({&VM_WID})
  user_id  FORMAT "x(10)"      COLON 18 LABEL "User ID"
  pass     FORMAT "x(10)"      COLON 52 LABEL "Password"
     {&STDPH_FILL}  SKIP (1)
  "Other CONNECT Statement Parameters:" AT 2 VIEW-AS TEXT SKIP({&VM_WID})
  f_comm                   AT 2 NO-LABEL {&STDPH_EDITOR}
      VIEW-AS EDITOR 
      &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
      	 SIZE 76 BY 3 BUFFER-LINES 3
      &ELSE 
      	 SIZE 76 BY 3 SCROLLBAR-VERTICAL
      &ENDIF
  SKIP({&VM_WIDG})
  {prodict/user/userbtns.i}

  &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
  BACKGROUND ParmsBox AT COLUMN 2 ROW 5
  &ELSE
  BACKGROUND ParmsBox AT COLUMN 2 ROW 4
  &ENDIF

  WITH FRAME userschg ROW 1 CENTERED SIDE-LABELS 
      DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
      VIEW-AS DIALOG-BOX     TITLE ttl. 
      

/*================================Triggers=================================*/

/*----- LEAVE of DATABASE LIBRARY NAME -----*/
ON LEAVE OF pname IN FRAME userschg DO:

    Define variable btn_ok   as logical initial true.
  
    /* If logical name was edited and name is in use: */
    dname = TRIM(INPUT FRAME userschg pname).
    IF pname ENTERED 
      THEN DO:  /* pname ENTERED */
        IF LDBNAME(dname) <> ?
          THEN DO:
            MESSAGE new_lang[1] VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            RETURN NO-APPLY.
        END.
     END.    /* pname ENTERED */
END.

ON LEAVE OF lname IN FRAME userschg DO:

    Define variable btn_ok   as logical initial true.
    
    ASSIGN dname = TRIM(INPUT FRAME userschg lname).
    /* If logical name was edited and name is in use: */
    IF lname ENTERED THEN DO: 
       IF dname = "" or dname = ? THEN 
          ASSIGN lname = INPUT FRAME userschg pname
                 lname:SCREEN-VALUE IN FRAME userschg = lname.
       ASSIGN dname = TRIM(INPUT FRAME userschg lname).          
       IF LDBNAME(dname) <> ? THEN DO:
         MESSAGE new_lang[1] VIEW-AS ALERT-BOX ERROR BUTTONS OK.
         RETURN NO-APPLY.
       END.    /* lname ENTERED */    
       ELSE IF user_env[1] = "chg" THEN DO:    
         IF NOT CONNECTED(_Db._Db-name) THEN DO:
           message "Changing the logical database name causes"  skip
                    "the Data Administration tool to close."     skip
                    "You can then continue working with the "    skip
                    "tool by restarting it."                     skip(1)
                    "Do you want to make the change?"
                    view-as alert-box QUESTION buttons yes-no 
                    update btn_ok.
            if btn_ok 
              THEN ASSIGN user_path = "*E"
                          okay      = FALSE.
           END.               
           ELSE DO:
              message "Changing the logical database name causes"  skip
                      "the DB2/400 database to be disconnected and" SKIP
                      "reconnected using the new logical name." SKIP (1)                      
                      "Do you want to make the change?"
              view-as alert-box QUESTION buttons yes-no 
              update btn_ok.
              IF btn_ok 
                THEN ASSIGN user_path = "*C,_as4crcn"
                            okay      = TRUE.                          
              ELSE 
                ASSIGN okay = false
                       lname:SCREEN-VALUE IN FRAME userschg = _db._Db-name
                       lname = _Db._Db-name.    
           END.            
       END.    
    END.
    /* lname blank */ 

    ELSE IF dname = "" or dname = ? THEN 
        ASSIGN lname = INPUT FRAME userschg pname
               lname:SCREEN-VALUE IN FRAME userschg = lname.
                  
END.                  

/*----- LEAVE of code-page -----*/
{prodict/gate/gat_cpvl.i
  &frame    = "userschg"
  &variable = "codepage"
  &adbtype  = "user_env[3]" 
  }  /* checks if codepage contains convertable code-page */

/*----- LEAVE OF user_id -----*/
ON LEAVE of user_id
DO:
   user_id = CAPS(user_id:SCREEN-VALUE).
   DISPLAY user_id WITH FRAME userschg.
END.

/*----- LEAVE OF pass -----*/
ON LEAVE of pass
DO:
   pass = CAPS(pass:SCREEN-VALUE).
   DISPLAY pass WITH FRAME userschg.
END.

/*----- GO or OK -----*/
ON GO OF FRAME userschg DO:

    dname = TRIM(INPUT FRAME userschg pname).
    IF dname = "" OR dname = ? THEN DO:
        MESSAGE new_lang[3] VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        APPLY "ENTRY" TO pname IN FRAME userschg.
        RETURN NO-APPLY.
     END.
     IF INPUT FRAME userschg lname = "" or INPUT FRAME userschg lname = ? THEN
        ASSIGN lname = INPUT FRAME userschg pname
               lname:SCREEN-VALUE IN FRAME userschg = lname.
END.

/*----- ENTRY of Pass -----*/
ON ENTRY OF pass
DO:
   APPLY "SELECTION" TO SELF.
END.

/*-----WINDOW-CLOSE-----*/
ON WINDOW-CLOSE OF FRAME userschg
    APPLY "END-ERROR" TO FRAME userschg.


/*----- HELP -----*/
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
ON HELP OF FRAME userschg OR CHOOSE of btn_Help IN FRAME userschg DO:
    RUN "adecomm/_adehelp.p" (INPUT "admn", INPUT "CONTEXT", 
                              INPUT {&Create_DataServer_Schema_Dlg_Box},
      	       	     	      INPUT ?).
    END.
&ENDIF

/*============================Mainline Code===============================*/

 IF  user_env[1] = "add"  OR user_env[1] = "redo" THEN 
                    ttl =  "Create DB2/400 DataServer Schema".
         ELSE  
                   ttl =   "Edit DB2/400 Connection Information".

ASSIGN
  amode    = (user_env[1] = "add")
  fmode    = (user_env[3] <> "")
  dblst    = (IF fmode THEN user_env[3] ELSE SUBSTRING(GATEWAYS,10)).
             /* 10 = LENGTH("PROGRESS") + 2 */
	     
IF NOT amode
  THEN DO:
    FIND _Db WHERE RECID(_Db) = drec_db NO-ERROR.
    IF NOT _Db._Db-slave THEN i = 1. /* no _Db rec */
    IF fmode AND dblst <> user_dbtype THEN i = 2. /* inconsistent dbtype */
    END.

if user_env[1] = "add"
  then do:
    { prodict/dictgate.i &action=query &dbtype=dblst &dbrec=? &output=codepage }
    assign codepage = ENTRY(11,codepage).
 END.
 else assign
    codepage = _DB._Db-xl-name.

IF i > 0 THEN DO:
  MESSAGE new_lang[i] VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
  END.

  IF amode or user_env[1] = "redo" THEN
      ASSIGN x-l   = yes.
  ELSE x-l = no.
  
{adecomm/okrun.i  
  &FRAME  = "FRAME userschg" 
  &BOX    = "rect_Btns"
  &OK     = "btn_OK" 
  {&CAN_BTN}
  {&HLP_BTN}
}
  
DO TRANSACTION:
  IF AVAILABLE _Db AND (_Db._Db-addr = ? OR _Db._Db-addr = "") THEN 
    ASSIGN _Db._Db-addr = _Db._Db-name.
END.

ASSIGN f_comm:RETURN-INSERT in frame userschg = yes
       pass:BLANK           in frame userschg = yes
       pname  = (IF AVAILABLE _Db THEN _Db._Db-addr ELSE "")
       lname  = (IF AVAILABLE _Db THEN _Db._Db-name ELSE "")
       arg_dt = (IF AVAILABLE _Db THEN _Db._Db-type ELSE "").

IF pname <> "" /* AND NUM-DBS > 0 AND NOT x-l */ THEN
DO:

   RUN prodict/misc/_getconp.p (INPUT        lname,
                                INPUT-OUTPUT pname,
                                INPUT-OUTPUT lname,
                                INPUT-OUTPUT arg_dt,
                                OUTPUT       arg_tl,
                                OUTPUT       arg_pf,
                                OUTPUT       arg_1,
                                OUTPUT       arg_network,
                                OUTPUT       arg_host,
                                OUTPUT       arg_service,
                                OUTPUT       arg_u,
                                OUTPUT       arg_p,
                                OUTPUT       args[2],
                                OUTPUT       args[3],
                                OUTPUT       args[4]).

   ASSIGN
      network = arg_network
      service = arg_service
      host    = arg_host
      user_id = arg_u
      pass    = arg_p
      f_comm  = (IF NOT arg_1     THEN "-1 "         ELSE "") + 
                (IF arg_pf  <> "" THEN "-pf "   + arg_pf  + " " ELSE "") +
                (IF arg_tl  <> "" THEN "-trig " + arg_tl  + " " ELSE "") +
                (IF args[2] <> "" THEN            args[2] + " " ELSE "") +
                (IF args[3] <> "" THEN            args[3] + " " ELSE "") +
                args[4].

END.

DISPLAY
 pname
 lname
 _Db._Db-type WHEN AVAILABLE _Db
 codepage
 network
 host
 service
 user_id
 pass
 f_comm
 WITH FRAME userschg.
 IF INDEX(dblst,",") = 0 THEN
    DISPLAY dblst @ _Db._Db-type WITH FRAME userschg.

 _trx: 
 DO TRANSACTION WITH FRAME userschg:

    DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:

      PROMPT-FOR
        pname WHEN x-l  
        lname 
        codepage     WHEN amode  or x-l
	network
	host
	service
	user_id
	pass
        f_comm
        btn_OK
        btn_Cancel
        {&HLP_BTN_NAME}.
       canned = false.
    END.
    
    IF canned THEN UNDO _trx,LEAVE _trx.

    IF amode THEN DO: /* create a new _Db for a schema for a Non-PROGRESS db 
                               _Db-misc1[08] is assigned to 7 because client needs to
                               know that is a version 7 schema holder for the AS400 
                               database.  */
        CREATE _Db.
        ASSIGN
            _Db._Db-slave = TRUE
            _Db._Db-type  = CAPS(INPUT _Db._Db-type)             
            user_dbtype   = _Db._Db-type.
        IF NOT fmode THEN 
          &IF "{&WINDOW-SYSTEM}" = "TTY"
            &THEN
          	 user_path = "1=sys,_usrsget".
            &ELSE
          	 user_path = "1=sys,_guisget".
            &ENDIF
        { prodict/dictgate.i &action=query &dbtype=_Db._Db-type &dbrec=? &output=c }

        IF INDEX(ENTRY(1,c),"a") > 0 THEN DO:
            { prodict/dictgate.i &action=add
              &dbtype=_Db._Db-type &dbrec=RECID(_Db) &output=c }
        END.
     END.   /* create a new _Db for a schema for a Non-PROGRESS db */
    
    IF okay THEN 
        DISCONNECT VALUE(_DB._Db-name).

    ASSIGN
      _Db._Db-name    = CAPS(INPUT lname)
      user_env[2]     = _Db._Db-name
      _Db._Db-addr    = CAPS(INPUT pname)
      _Db._Db-comm    =
         (IF INPUT network <> "" THEN
	     "-N " + TRIM(INPUT network) + " "
	  ELSE
	     "") +
	 (IF INPUT host    <> "" THEN
	     "-H " + TRIM(INPUT host)    + " "
	  ELSE
	     "") +
	 (IF INPUT service <> "" THEN
	     "-S " + TRIM(INPUT service) + " "
	  ELSE
	     "") +
	 (IF INPUT user_id <> "" THEN
	     "-U " + TRIM(INPUT user_id) + " "
	  ELSE
	     "") +
	 (IF INPUT pass    <> "" THEN
	     "-P " + TRIM(INPUT pass)    + " "
	  ELSE
	     "") +
	 TRIM(INPUT f_comm)
      /* Remove any line feeds (which we get on WINDOWS) */
      _Db._Db-comm    = REPLACE(_Db._Db-comm, CHR(13), "")
      user_dbname     = _Db._Db-name
      .             

    { prodict/gate/gat_cp1a.i &incpname = "codepage" }
    /* This is assigned here so the client knows that this is a version 7 database
          being created.  It will be assigned again in prodict/as4/_as4crcn since the
          load program overwrites.  */
          
     IF x-l  THEN ASSIGN _db._Db-misc1[8] = 7.
     IF okay THEN DO:
        ASSIGN user_dbname = _Db._Db-name
               user_env[1] = "connect".
     END.                      
 END.   /* _trx: do transaction */

IF canned  AND user_env[1] = "redo" THEN ASSIGN user_path = "_as4_del,_usrsget".   
ELSE IF canned THEN ASSIGN user_path = "".

 RELEASE _Db.   /* I'm not sure why we need this? (los) */

HIDE FRAME userschg NO-PAUSE.      
RETURN.



