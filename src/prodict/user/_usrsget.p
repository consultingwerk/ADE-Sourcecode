/*********************************************************************
* Copyright (C) 2006 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* Progress Lex Converter 7.1A->7.1B Version 1.11 */

/* _usrsget.p - select working schema */

/*
user_env[1] = "dis" - this program disconnects a database
user_env[1] = "new" - this may be the first database connected
user_env[1] = "get" - user wants to select a database to work with
user_env[1] = "sys" - dictionary forcing user to pick a database
*/
/*

History:
    mcmann      98/01/14    Changed connect message to 10 instead of 9
    laurief     97/12/18    Made V8 to "generic version" changes
    laurief     97/05/12    Changed some messages to alert boxes (95-09-27-025)
    gfs         94/06/23    Fixed F4 prob on disconnect 94-06-02-005
    hutegger    94/05/05    "automatically get select-dialogbox after
                            connecting to an n. db (n > 1)" was switched
                            off; I switched it on again.      
    hutegger    94/05/05    I inserted an extention of user_path, in case
                            there are more then 1 db left after disconnect
                            1. commit transaction; 
                            2. call this routine again
    fernando    02/17/06    Handle V9 db's - don't let user select them - 20050510-008

*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }
{ prodict/user/userhue.i }
{ prodict/user/userhdr.f }

DEFINE VARIABLE answer AS LOGICAL                 NO-UNDO.
DEFINE VARIABLE choice AS INTEGER   INITIAL ?     NO-UNDO.
DEFINE VARIABLE d_char AS CHARACTER EXTENT  4     NO-UNDO.
DEFINE VARIABLE d_log  AS LOGICAL                 NO-UNDO.
DEFINE VARIABLE dbpick AS CHARACTER               NO-UNDO.
DEFINE VARIABLE i      AS INTEGER                 NO-UNDO.
DEFINE VARIABLE is_dis AS LOGICAL                 NO-UNDO.
DEFINE VARIABLE j      AS INTEGER   INITIAL 0     NO-UNDO.
DEFINE VARIABLE l      AS LOGICAL                 NO-UNDO.
DEFINE VARIABLE look   AS LOGICAL   INITIAL FALSE NO-UNDO.
DEFINE VARIABLE old_db AS INTEGER   INITIAL ?     NO-UNDO.
DEFINE VARIABLE oldbs  AS INTEGER   INITIAL 0     NO-UNDO.
DEFINE VARIABLE olname AS CHARACTER               NO-UNDO.
DEFINE VARIABLE p_down AS INTEGER                 NO-UNDO.
DEFINE VARIABLE p_init AS INTEGER   INITIAL ?     NO-UNDO.
DEFINE VARIABLE p_line AS INTEGER                 NO-UNDO.
DEFINE VARIABLE redraw AS LOGICAL   INITIAL TRUE  NO-UNDO.
DEFINE VARIABLE rpos   AS INTEGER                 NO-UNDO.
DEFINE VARIABLE typed  AS CHARACTER INITIAL ""    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE fast_track AS LOGICAL. /* FT active? */
DEFINE VARIABLE old_dbver AS CHARACTER            NO-UNDO.

/* LANGUAGE DEPENDENCIES START */ /*----------------------------------------*/
DEFINE VARIABLE new_lang AS CHARACTER EXTENT 22 NO-UNDO INITIAL [
  /*  1*/ "Are you sure that you want to disconnect database",
  /*  2*/ "Nothing was disconnected.",
  /*  3*/ "Cannot disconnect a database if it is not connected.",
  /*  4*/ "has been disconnected.",
  /*  5*/ "There are only" , 
  /*  6*/ "databases connected.  Please use the ",
  /*  7*/ "dictionary from ", 
  /*  8*/ "{&PRO_DISPLAY_NAME} to view/edit these databases.",
  /*  9*/ "ERROR! Database type inconsistency in _usrsget.p",
/*10,11*/ "Database", "is not connected.  Would you like to connect it?",
  /* 12*/ "",  /* reserved */
  /* 13*/ "is the only database connected - it is already selected.",
  /* 14*/ "You have been automatically switched to database",
/*15,16*/ "The", "Dictionary can not be used with a {&PRO_DISPLAY_NAME}",
  /* 17*/ "database.",
  /* 18*/ "There are no databases connected to select!",
  /* 19*/ "This copy of {&PRO_DISPLAY_NAME} does not support database type",
  /* 20*/ "There are no databases connected for you to disconnect.",
  /* 21*/ "You have to leave Fast Track before disconnecting a database",
  /* 22*/ "is the only selectable database connected - it is already selected."
].

FORM
  d_char[1] FORMAT "x(18)"  LABEL "Logical DBName"  ATTR-SPACE SPACE(0)
  d_char[2] FORMAT "x(20)"  LABEL "Physical DBName"
  d_char[3] FORMAT "x(12)"  LABEL "DB Type"         ATTR-SPACE SPACE(0)
  d_char[4] FORMAT "x(18)"  LABEL "Schema Holder"
  d_log     FORMAT "yes/no" LABEL "Con"             ATTR-SPACE
  WITH FRAME schema_stuff NO-ATTR-SPACE USE-TEXT
  ROW 4 COLUMN 1 SCROLL 1 p_down DOWN TITLE COLOR NORMAL
  " Select " + TRIM(STRING(is_dis,"Database to Disconnect/Working Database"))
	     + " ".

/* LANGUAGE DEPENDENCIES END */ /*------------------------------------------*/

FUNCTION isOlderDBVersion RETURNS LOGICAL (INPUT pos AS INTEGER) FORWARD.


is_dis = user_env[1] = "dis".

IF is_dis AND NUM-DBS = 0 THEN DO:
  MESSAGE new_lang[20] VIEW-AS ALERT-BOX. /* nothing to disconnect */
  user_path = "".
  RETURN.
END.

RUN "prodict/_dctsget.p".

IF is_dis THEN DO: /* removed unconnected items from list */
  DO i = 1 TO cache_db#:
    IF CONNECTED(cache_db_l[i]) THEN ASSIGN
      j             = j + 1
      cache_db_e[j] = cache_db_e[i]
      cache_db_l[j] = cache_db_l[i]
      cache_db_p[j] = cache_db_p[i]
      cache_db_s[j] = cache_db_s[i]
      cache_db_t[j] = cache_db_t[i].
  END.
  cache_db# = j.
END.

DO i = 1 TO cache_db#:
  IF cache_db_l[i] = user_dbname AND old_db = ? THEN old_db = i.
  IF  isOlderDBVersion(i) THEN oldbs = oldbs + 1.
  old_dbver = "V" + DBVERSION(cache_db#).
END.

ASSIGN
  cache_dirty = TRUE
  p_down      = MINIMUM(cache_db#,SCREEN-LINES - 8)
  p_init      = MINIMUM(p_down,old_db)
  rpos        = (IF old_db = ? THEN 1 ELSE old_db).

IF cache_db# = oldbs AND oldbs > 0 THEN DO:
  IF not is_dis THEN
    MESSAGE new_lang[5] old_dbver new_lang[6] SKIP /* only non-V8 dbs connected */
      	    new_lang[7] old_dbver new_lang[8] VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  look = TRUE.
END.
IF cache_db# = 0 OR cache_db# = oldbs THEN DO:
  ASSIGN
    user_path     = ""
    user_dbname   = ""
    user_dbtype   = ""
    user_filename = "".
  DISPLAY user_dbname user_filename WITH FRAME user_ftr.
  IF CAN-DO("get,new",user_env[1]) AND oldbs = 0 THEN
    MESSAGE new_lang[18] VIEW-AS ALERT-BOX. /* no dbs connected */
  IF NOT (look AND is_dis) THEN RETURN.
END.

/* <hutegger> 94/05/05 user should be automatically prompted to select */
/* the current working db, if there are more then 1 db's connected     */
/*
IF old_db <> ? AND user_env[1] = "new" THEN
  choice = old_db.
ELSE
*/
IF cache_db# = 1 AND NOT look THEN DO:
  choice = 1.
  IF user_env[1] = "get" THEN 
    MESSAGE cache_db_l[1] new_lang[13] VIEW-AS ALERT-BOX. /* only 1 db to choose */
  IF cache_db_l[1] <> olname AND
    (user_env[1] = "new"
    OR (user_env[1] = "sys" AND user_dbname <> cache_db_l[1])) THEN
    MESSAGE new_lang[14] '"' + cache_db_l[1] + '"'. /* auto-switch to db... */
END.
ELSE IF ((cache_db# - oldbs) = 1) AND NOT look THEN DO:

  /* check if we only have one db that can be selected, for instance, if you have
     a db from an older version and a db from the current release, then you can only
     select the current version db. We do that only if the user is trying to select
     a different database, or it's a db that just got connected.
  */
  IF (user_env[1] = "get" AND user_dbname <> "") OR user_env[1] = "new" THEN DO:
     /* there is only 1 db that can be selected - find out which one */      
     choice = 1.

     DO WHILE isOlderDBVersion(choice) AND choice <= cache_db#:
           choice = choice + 1.
     END.
    
     /* message is only needed if the user is trying to select a db */
     IF user_env[1] = "get" THEN
         MESSAGE cache_db_l[choice] new_lang[22] /* only 1 selectable db */
                VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
  END.
  
END.

DO WHILE choice = ?:

  rpos = MINIMUM(cache_db#,MAXIMUM(rpos,1)).

  IF redraw THEN DO:
    ASSIGN
      p_line = MAXIMUM(1,FRAME-LINE(schema_stuff))
      j      = rpos - (IF p_init = ? THEN p_line ELSE p_init) + 1.
    UP p_line - 1 WITH FRAME schema_stuff.
    IF j < 1 THEN ASSIGN
      j      = 1
      p_line = 1
      rpos   = 1.
    DO i = j TO j + p_down - 1:
      IF i > cache_db# THEN
        CLEAR FRAME schema_stuff NO-PAUSE.
      ELSE
        DISPLAY
          cache_db_l[i] @ d_char[1]
          SUBSTRING(cache_db_p[i]
                   ,MAXIMUM(1,LENGTH(cache_db_p[i],"character") - 20)
                   ,21
                   ,"character"
                   )
            @ d_char[2]
          cache_db_e[i] @ d_char[3]
          cache_db_s[i] @ d_char[4]
          CONNECTED(cache_db_l[i]) @ d_log
          WITH FRAME schema_stuff.
      IF i < j + p_down - 1 THEN
        DOWN WITH FRAME schema_stuff.
    END.
    p_line = (IF p_init = ? THEN p_line /*1*/ ELSE p_init).
    UP p_down - p_line WITH FRAME schema_stuff.
    ASSIGN
      p_init = ?
      redraw = FALSE.
  END.

  DISPLAY
    cache_db_l[rpos] @ d_char[1]
    SUBSTRING(cache_db_p[rpos]
             ,MAXIMUM(1,LENGTH(cache_db_p[rpos],"character") - 20)
             ,21
             ,"character"
             )
      @ d_char[2]
    cache_db_e[rpos] @ d_char[3]
    cache_db_s[rpos] @ d_char[4]
    CONNECTED(cache_db_l[rpos]) @ d_log
    WITH FRAME schema_stuff.
  COLOR DISPLAY MESSAGES d_char[1 FOR 4] d_log WITH FRAME schema_stuff.
  READKEY.
  COLOR DISPLAY NORMAL d_char[1 FOR 4] d_log WITH FRAME schema_stuff.
  PAUSE 0.

  IF ( KEYFUNCTION(LASTKEY) = CHR(LASTKEY) 
   AND LASTKEY >= 32
     )
   OR ( KEYFUNCTION(LASTKEY) = "BACKSPACE"
   AND  LENGTH(typed,"character") > 0
      )
   THEN DO:
    typed = (IF KEYFUNCTION(LASTKEY) = "BACKSPACE"
        THEN SUBSTRING(typed,1,LENGTH(typed,"character") - 1,"character")
        ELSE typed + CHR(LASTKEY)).
    IF typed = "" OR cache_db_l[rpos] BEGINS typed THEN NEXT.
    DO p_line = rpos TO cache_db#:
      IF cache_db_l[p_line] BEGINS typed THEN LEAVE.
    END.
    IF p_line > cache_db# THEN DO:
      DO p_line = 1 TO rpos:
        IF cache_db_l[p_line] BEGINS typed THEN LEAVE.
      END.
      IF p_line > rpos THEN p_line = cache_db# + 1.
    END.
    IF p_line > cache_db# THEN DO:
      typed = CHR(LASTKEY).
      DO p_line = 1 TO cache_db#:
        IF cache_db_l[p_line] BEGINS typed THEN LEAVE.
      END.
    END.
    IF p_line <= cache_db# THEN ASSIGN
      rpos   = p_line
      redraw = TRUE.
    NEXT.
  END.

  typed = "".
  IF KEYFUNCTION(LASTKEY) = "CURSOR-DOWN" AND rpos < cache_db# THEN DO:
    rpos = rpos + 1.
    IF FRAME-LINE(schema_stuff) = FRAME-DOWN(schema_stuff) THEN
      SCROLL UP WITH FRAME schema_stuff.
    ELSE
      DOWN WITH FRAME schema_stuff.
  END.
  ELSE
  IF KEYFUNCTION(LASTKEY) = "CURSOR-UP" AND rpos > 1 THEN DO:
    rpos = rpos - 1.
    IF FRAME-LINE(schema_stuff) = 1 THEN
      SCROLL DOWN WITH FRAME schema_stuff.
    ELSE
      UP WITH FRAME schema_stuff.
  END.
  ELSE
  IF KEYFUNCTION(LASTKEY) = "PAGE-DOWN" THEN ASSIGN
    rpos   = rpos + p_down
    redraw = TRUE.
  ELSE
  IF KEYFUNCTION(LASTKEY) = "PAGE-UP" THEN ASSIGN
    rpos   = rpos - p_down
    redraw = TRUE.
  ELSE
  IF CAN-DO("HOME,MOVE",KEYFUNCTION(LASTKEY)) AND rpos > 1 THEN DO:
    ASSIGN
      rpos   = 1
      redraw = TRUE.
    UP FRAME-LINE(schema_stuff) - 1 WITH FRAME schema_stuff.
  END.
  ELSE
  IF CAN-DO("END,HOME,MOVE",KEYFUNCTION(LASTKEY)) THEN DO:
    ASSIGN
      rpos   = cache_db#
      redraw = TRUE.
    DOWN p_down - FRAME-LINE(schema_stuff) WITH FRAME schema_stuff.
  END.
  ELSE
  IF CAN-DO("GO,RETURN,END-ERROR",KEYFUNCTION(LASTKEY)) THEN DO:
    l = KEYFUNCTION(LASTKEY) = "END-ERROR".
    IF NOT l AND NOT is_dis
      AND isOlderDBVersion(rpos)   THEN DO:
      /*old_dbver = "V" + DBVERSION(cache_db#).*/
	  old_dbver = "V" + DBVERSION(cache_db_l[rpos]).
      MESSAGE new_lang[15] PROVERSION new_lang[16] old_dbver new_lang[17] VIEW-AS ALERT-BOX. /* cannot use V5/V6/V7/V8 db and V9 dict together */
      NEXT.
    END.
    ELSE
    /*-----
    IF NOT l AND NOT CAN-DO(GATEWAYS,cache_db_t[rpos]) THEN DO:
      MESSAGE new_lang[19] cache_db_e[rpos] VIEW-AS ALERT-BOX. /* unsupported dbtype */
      NEXT.
    END.
    ------*/ 
    ASSIGN
      choice = (IF l THEN old_db ELSE rpos)
      choice = (IF choice = ? THEN 1 ELSE choice).
  END.

  p_line = 1.
END.

dbpick = cache_db_l[choice].
IF KEYFUNCTION(LASTKEY)  = "END-ERROR" THEN user_path = "".

IF is_dis THEN _discon: DO: /*-----------------------------*/ /* disconnect */
  IF KEYFUNCTION(LASTKEY) = "END-ERROR" THEN LEAVE _discon.
  answer = FALSE.
  RUN "prodict/user/_usrdbox.p" (INPUT-OUTPUT answer,?,?,
    new_lang[1] + ' "' + dbpick + '"?'). /* discon? */
  IF NOT answer OR answer = ? THEN DO:
    MESSAGE new_lang[2] VIEW-AS ALERT-BOX. /* nothing disconnected */
    user_path = "".
    LEAVE _discon.
  END.
  /* If dictionary was started from Fast Track, return here.     */
  /* (Disconnecting within Fast Track doesn't make sense because */
  /* file-caching is done at startup-time when ft.p is run.      */
  IF fast_track THEN DO:
    BELL.
    MESSAGE new_lang[21].
    PAUSE 0.
    RETURN.
  END.
  DISCONNECT VALUE(dbpick).
  RUN "prodict/_dctsget.p". /* recache list */
  MESSAGE dbpick new_lang[4] VIEW-AS ALERT-BOX. /* disconnected */
  IF  (        user_dbname  = dbpick
    OR SDBNAME(user_dbname) = dbpick )
    THEN DO:
    ASSIGN
      user_dbname   = ""
      user_dbtype   = ""
      user_filename = "".
    /* recount the residing db's:                                   */
    /* if disconnecting a shemaholder, then don't count NEITHER the */
    /* schemaholder NOR its schemas; else don't count only the      */
    /* disconnected db                                              */
    ASSIGN j = 0.
    DO i = 1 TO cache_db#:
      IF  ( cache_db_l[i] <> dbpick
        OR  cache_db_t[i] <> "PROGRESS" )
        AND cache_db_s[i] <> dbpick AND
        NOT isOlderDBVersion(i)           
        THEN j = j + 1.
    END.

    if j > 1 then assign user_path = "*C,1=get,_usrsget" + user_path.
    DISPLAY user_dbname user_filename WITH FRAME user_ftr.
  END.
END. /*---------------------------------------------------------------------*/
ELSE _select: DO: /*-------------------------------------------*/ /* select */
  IF KEYFUNCTION(LASTKEY) = "END-ERROR" THEN LEAVE _select.
  ASSIGN
    user_dbname   = dbpick
    user_dbtype   = cache_db_t[choice]
    cache_dirty   = TRUE
    user_filename = ""
    drec_db       = ?
    drec_file     = ?.
  { prodict/user/usercon.i user_filename }

  CREATE ALIAS "DICTDB" FOR DATABASE VALUE(cache_db_s[choice]) NO-ERROR.
  IF LDBNAME("DICTDBG") <> ? THEN DELETE ALIAS "DICTDBG".
  IF user_dbtype = "PROGRESS" THEN
    dbpick = ?.
  ELSE IF CONNECTED(dbpick) THEN
    CREATE ALIAS "DICTDBG" FOR DATABASE VALUE(dbpick) NO-ERROR.
  RUN "prodict/_dctsset.p" (dbpick).

  IF NOT CONNECTED(user_dbname) AND CAN-DO(DATASERVERS,user_dbtype) THEN DO:
    answer = TRUE.
    RUN "prodict/user/_usrdbox.p" (INPUT-OUTPUT answer,?,?,
      new_lang[10] + ' "' + user_dbname + '" ' + new_lang[11]).
    IF answer THEN user_path = "*C,1=usr,_usrscon".
  END.
END. /*---------------------------------------------------------------------*/

HIDE FRAME schema_stuff NO-PAUSE.
RETURN.


FUNCTION isOlderDBVersion RETURNS LOGICAL (INPUT pos AS INTEGER):

  IF index(cache_db_t[pos],"/V5") <> 0
   or index(cache_db_t[pos],"/V6") <> 0
   or index(cache_db_t[pos],"/V7") <> 0
   or index(cache_db_t[pos],"/V8") <> 0
   or index(cache_db_t[pos],"/V9") <> 0 THEN  
   /*(CAN-DO("PROGRESS/V5,PROGRESS/V6,PROGRESS/V7,PROGRESS/V8",cache_db_t[pos])*/
     RETURN YES.
   ELSE 
     RETURN NO.
   
END FUNCTION.
