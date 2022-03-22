/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* Progress Lex Converter 7.1A->7.1B Version 1.11 */

/* _usrscon - connect databases */
/*
user_env[1] = "usr" to assume connecting database named in user_dbname
user_env[1] = "env" to assume connecting database named in user_env[2]
user_env[1] = "" otherwise
*/

/* history:
95-04-17    j. palazzo  Added arg_network, arg_host, arg_service.
              We don't actually use them since they are not prompted for
              directly in the character Connect Database dialog. They are
              just output parameter placeholders.
              
94-05-02    hutegger    deleted bi and ai - fill-ins from dialog-box
              changed tty-DlgBox to ask for multi-user
              
D. McMann 02/21/03 Replaced GATEWAYS with DATASERVERS              
*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }
{ prodict/user/userhue.i }
{ prodict/user/userhdr.f }

DEFINE VARIABLE trash       AS CHARACTER NO-UNDO.
DEFINE VARIABLE arg_1       AS LOGICAL   NO-UNDO.
DEFINE VARIABLE arg_db      AS CHARACTER NO-UNDO.
DEFINE VARIABLE arg_ld      AS CHARACTER NO-UNDO.
DEFINE VARIABLE arg_dt      AS CHARACTER NO-UNDO INITIAL "PROGRESS":u.
DEFINE VARIABLE arg_p       AS CHARACTER NO-UNDO.
DEFINE VARIABLE arg_pf      AS CHARACTER NO-UNDO.
DEFINE VARIABLE arg_u       AS CHARACTER NO-UNDO.
DEFINE VARIABLE arg_tl      AS CHARACTER NO-UNDO.
DEFINE VARIABLE arg_network AS CHARACTER NO-UNDO.
DEFINE VARIABLE arg_host    AS CHARACTER NO-UNDO.
DEFINE VARIABLE arg_service AS CHARACTER NO-UNDO.
DEFINE VARIABLE ix          AS INTEGER   NO-UNDO.
DEFINE VARIABLE stri        AS CHARACTER NO-UNDO.
DEFINE VARIABLE args        AS CHARACTER NO-UNDO EXTENT 4.
DEFINE VARIABLE canned      AS LOGICAL   NO-UNDO INITIAL TRUE.

DEFINE NEW GLOBAL SHARED VARIABLE fast_track AS LOGICAL. /* FT active? */
/*
{prodict/misc/filesbtn.i &NAME = btn_Filen}
{prodict/misc/filesbtn.i &NAME = btn_Filet}
{prodict/misc/filesbtn.i &NAME = btn_Filep}
*/

/* LANGUAGE DEPENDENCIES START */ /*----------------------------------------*/

DEFINE VARIABLE new_lang AS CHARACTER EXTENT 3 NO-UNDO INITIAL [
  /* 1*/ "You must supply a physical name or parameter file",
  /* 2*/ "You have to leave Fast Track before connecting a new database",
  /* 3*/ "The connection parameters contain a wrong -dt entry"
  ].
/*
 *FORM
 *  arg_db LABEL "Physical Name"  FORMAT "x(70)" COLON 17       /* -db */
 *      	       	     	        VIEW-AS FILL-IN SIZE 38 BY 1
 *  btn_Filen                                                   SKIP
 *
 *  arg_ld LABEL "Logical Name"   FORMAT "x(32)" COLON 17       SKIP    /* -ld */
 *  arg_dt LABEL "Database Type" 	FORMAT "x(12)" COLON 17       SKIP    /* -dt */
 *  arg_u  LABEL "Userid"       	FORMAT "x(50)" COLON 17       SKIP    /* -U */
 *  arg_p  LABEL "Password"      	FORMAT "x(50)" COLON 17 BLANK SKIP    /* -P */
 *  arg_1  LABEL "Multiple Users"                COLON 17       SKIP    /* -1 */
 *  arg_tl LABEL "Trigger Location" FORMAT "x(70)" COLON 17             /*-trig*/
 *      	       	     	      	VIEW-AS FILL-IN SIZE 38 BY 1
 *  btn_Filet                                                   SKIP
 *  arg_pf LABEL "Parameter File" FORMAT "x(70)" COLON 17		      /* -PF */
 *      	       	     	        VIEW-AS FILL-IN SIZE 38 BY 1
 *  btn_Filep                                                   SKIP(1)
 *
 *  "Other CONNECT-Statement parameters:"       	     	AT 2  SKIP
 *  args[2] NO-LABEL   	      	 FORMAT "x(64)" AT 4  	      SKIP
 *  args[3] NO-LABEL   	      	 FORMAT "x(64)" AT 4  	      SKIP
 *  args[4] NO-LABEL   	      	 FORMAT "x(64)" AT 4
 *
 *  {prodict/user/userbtns.i}
 *
 *  WITH FRAME con-man
 *  ROW 2 CENTERED SIDE-LABELS ATTR-SPACE
 *  DEFAULT-BUTTON btn_OK CANCEL-BUTTON btn_Cancel
 *  VIEW-AS DIALOG-BOX TITLE " Connect Database ".
 */
/* LANGUAGE DEPENDENCIES END */ /*------------------------------------------*/

/*===============================Triggers=================================*/

/*
&IF "{&WINDOW-SYSTEM}":u <> "TTY":u &THEN
ON HELP OF FRAME con-man
  RUN adecomm/_adehelp.p ("admn":u,"CONTEXT":u,{&Connect_Database_Dlg_Box},?).
&ENDIF

/*----- GO or HIT of OK BUTTON -----*/
ON GO OF FRAME con-man DO:	/* or OK Button because of auto-go */
  DEFINE VARIABLE num AS INTEGER NO-UNDO.

  ASSIGN
    INPUT FRAME con-man arg_db
    arg_ld arg_u arg_p arg_1 arg_pf arg_tl
    args[2] args[3] args[4].

  IF (arg_db = "" OR arg_db = ?) AND (arg_pf = "" OR arg_pf = ?) THEN DO:
    MESSAGE new_lang[1] /* must supply dbname or -pf file */
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN NO-APPLY.
  END.

  args[1] = arg_db.
  IF arg_ld <> "" THEN args[1] = args[1] + ' -ld ':u + arg_ld.
  IF arg_dt <> "" THEN args[1] = args[1] + ' -dt ':u + arg_dt.
  IF arg_tl <> "" THEN args[1] = args[1] + ' -trig ':u + arg_tl.
  IF arg_pf <> "" THEN args[1] = args[1] + ' -pf ':u + arg_pf.
  IF NOT arg_1    THEN args[1] = args[1] + ' -1':u.
  IF arg_u  <> "" THEN args[1] = args[1] + ' -U ':u  + arg_u.
  IF arg_p  <> "" THEN args[1] = args[1] + ' -P ':u  + arg_p.

  /* The only way to really see if connect succeeded is to compare
    num-dbs before and after.  Certain conditions - like database
    already connected, do not raise error.
  */
  num = NUM-DBS.
  MESSAGE "Connecting".
  DO ON ERROR UNDO, LEAVE:
    CONNECT VALUE(args[1]) VALUE(args[2]) VALUE(args[3]) VALUE(args[4]).
  END.
  HIDE MESSAGE NO-PAUSE.

  IF NUM-DBS = num THEN DO:
    APPLY "ENTRY":u TO arg_db.
    RETURN NO-APPLY.  /* an error occurred */
  END.
END.

/*----- LEAVE of LOGICAL NAME -----*/
ON LEAVE OF arg_ld IN FRAME con-man DO:
  IF CAN-DO("DICTDB,DICTDB2,DICTDBG":u, INPUT FRAME con-man arg_ld) THEN DO:
    MESSAGE
      "You cannot connect a database with a logical name of " +
      INPUT FRAME con-man arg_ld + ".":u
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN NO-APPLY.
  END.
END.

/*----- LEAVE of DATABASE TYPE -----* /
 * not updateable anymore <hutegger>
 *ON LEAVE OF arg_dt IN FRAME con-man
 *DO:
 *  IF NOT CAN-DO(GATEWAYS, INPUT FRAME con-man arg_dt) THEN DO:
 *    MESSAGE "This copy of PROGRESS does not support that database type."
 *      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
 *    RETURN NO-APPLY.
 *  END.
 *END.
 */

/*----- HIT OF FILE BUTTONS -----*/
ON CHOOSE OF btn_Filen IN FRAME con-man
  RUN prodict/misc/_filebtn.p (arg_db:HANDLE IN FRAME con-man /*Fillin*/,
                               "Find Database File"           /*Title*/,
                               "*.db":u                       /*Filter*/,
                               yes                            /*Must exist*/).

ON CHOOSE OF btn_Filet IN FRAME con-man
  RUN prodict/misc/_filebtn.p (arg_tl:HANDLE IN FRAME con-man /*Fillin*/,
                               "Find Procedure Library File"  /*Title*/,
                               "*.pl":u                       /*Filter*/,
                               no                             /*Must exist*/).

ON CHOOSE OF btn_Filep IN FRAME con-man
  RUN prodict/misc/_filebtn.p (arg_pf:handle in frame con-man /*Fillin*/,
                               "Find Parameter File"          /*Title*/,
                               "*.pf":u                       /*Filter*/,
                               yes                            /*Must exist*/).

/*----- LEAVE OF FILE NAME FIELDS -----*/
ON LEAVE OF arg_db IN FRAME con-man
  arg_db:SCREEN-VALUE IN FRAME con-man =
     TRIM(arg_db:SCREEN-VALUE IN FRAME con-man).

ON LEAVE OF arg_tl IN FRAME con-man
  arg_tl:SCREEN-VALUE IN FRAME con-man =
    TRIM(arg_tl:SCREEN-VALUE IN FRAME con-man).

ON LEAVE OF arg_pf IN FRAME con-man
  arg_pf:SCREEN-VALUE IN FRAME con-man =
    TRIM(arg_pf:SCREEN-VALUE IN FRAME con-man).
*/

/*============================Mainline code===============================*/

/* If dictionary was started from Fast Track, return here.                  */
/* (Connecting within Fast Track doesn't make sense because file=-caching   */
/*  is done at startup-time when ft.p is run                                */
IF fast_track THEN DO:
  MESSAGE new_lang[2] VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

/* if current db not connected, set default params */
IF user_env[1] = "usr":u
  AND NOT CONNECTED(user_dbname)
  AND user_dbname <> ""
  AND user_dbtype <> "PROGRESS":u
  AND CAN-DO(DATASERVERS,user_dbtype) THEN DO: /* current db not connected */
  ASSIGN
    arg_db = user_dbname
    arg_ld = user_dbname
    arg_dt = user_dbtype.
  IF NUM-DBS > 0 THEN
    RUN adecomm/_getconp.p (INPUT        user_dbname,
                            INPUT-OUTPUT arg_db,
                            INPUT-OUTPUT arg_ld,
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

  IF arg_dt <> user_dbtype THEN DO:
    MESSAGE new_lang[3] VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN.
  END.
END.        /* current db not connected */

IF user_env[1] = "env":u THEN DO:
  ASSIGN
    arg_db  = user_env[2]
    arg_dt  = "PROGRESS":u
    arg_ld  = ""
    arg_tl  = ""
    arg_pf  = ""
    arg_1   = FALSE
    arg_u   = ""
    arg_p   = ""
    args[2] = ""
    args[3] = ""
    args[4] = "".

  RUN prodict/misc/osprefix.p
    (INPUT user_env[2],OUTPUT trash,OUTPUT arg_ld).

  ix = LENGTH(arg_ld, "CHARACTER":u) - 2.
  IF ix > 1 AND SUBSTRING(arg_ld, ix, 3, "CHARACTER":u) = ".db":u THEN
    arg_ld = SUBSTRING(arg_ld, 1, ix - 1, "CHARACTER":u).
END.

/* Removed spaces from line break which were causing problems */
ASSIGN args[2] = TRIM(args[2] + args[3] + args[4]).

RUN adecomm/_dbconnx.p (INPUT        YES,
                        INPUT-OUTPUT arg_db,
                        INPUT-OUTPUT arg_ld,
                        INPUT-OUTPUT arg_dt,
                        INPUT-OUTPUT arg_1,
                        INPUT-OUTPUT arg_network,
                        INPUT-OUTPUT arg_host,
                        INPUT-OUTPUT arg_service,
                        INPUT-OUTPUT arg_u,
                        INPUT-OUTPUT arg_p,
                        INPUT-OUTPUT arg_tl,
                        INPUT-OUTPUT arg_pf,
                        INPUT-OUTPUT args[2],
                        OUTPUT       stri).

canned = (IF arg_ld = ? THEN YES ELSE NO).

/* Even if there's an error do this.  We may have gotten an error on
 * one database, but another may have been connected successfully.
 */
RUN prodict/_dctsget.p.

{ prodict/user/usercon.i }

IF canned THEN
  user_path = "".

HIDE FRAME con-man NO-PAUSE.

RETURN.

/* _usrscon.p - end of file */

