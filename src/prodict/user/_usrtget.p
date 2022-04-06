/*********************************************************************
* Copyright (C) 2008,2020 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*************************************************************
   _usrtget.p - select a table 

History:
    laurief  04/09/98  Added p_allw and count to allow us to compare
                       the number of tables selected to the total
                       number of tables available.  This needs to be
                       done in the case where a user is not typing "ALL",
                       instead the user types an "*" in the 
                       select/deselect dialog.  This allows us to 
                       compare count with cache_file# and if they are
                       equal, the .df will contain all database schema
                       info correctly.  BUG 97-07-22-029
   mcmann  04/20/98    Added exclusion of views from table list.
   mcmann  07/09/98    Added AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN")
                       to Find _File
   Mario B 12/11/98   The ALL option was appearing in places where
                      it should not.  Changed display with frame t-type so
                      that p_all and p_allw are ANDed instead of ORed.  That
                      fixed it.  BUG 98-05-06-056  
   Mario B 11/11/98   More fixes to the "ALL" option.  All not needed when
                      pattern matching is presented.  BUG# 19991025-003
   D. McMann 05/10/00 Added ability for user to display hidden files
   D. McMann 07/11/02 redo cache if session:schema-change is set to new objects.
                      20020701-029
   fernando  03/13/06 Storing table names in temp-table - 20050930-006.
   fernando  12/13/07 Handle long list of "some" selected tables 
   fernando  06/26/08 Filter out schema tables for encryption
   tmasood   06/03/20 Fixed issue with display of metaschema tables   

*************************************************************/


{ prodict/dictvar.i }
{ prodict/user/uservar.i }
{ prodict/user/userhue.i }
{ prodict/user/userhdr.f }

/*
INPUT:
user_env[1] MATCHES "*o*":
  If this program sees an "o" (for "optional") in user_env[1], then it
  returns immediately if a filename is currently set (other than
  "ALL").

user_env[1] MATCHES "*a*":
  If this program sees an "a" (for "all"), then "ALL" is a valid
  choice.

user_env[1] MATCHES "*s*":
  If this program sees an "s" (for "some"), then [Return] marks (or
  unmarks) names, and the comma-delimited list of names is returned in
  user_env[1].


OUTPUT:
drec_file
  Contains the recid of the _File record selected, or no record if
  'ALL' or some entered.

user_filename
user_env[1]
  Contains the filename selected, or 'ALL', or a comma-separated list
  of filenames.  If a comma-sep list is returned in user_env[1], 'SOME'
  is returned in user_filename.
*/

DEFINE VARIABLE c          AS CHARACTER              NO-UNDO.
DEFINE VARIABLE g          AS CHARACTER              NO-UNDO.
DEFINE VARIABLE h          AS CHARACTER              NO-UNDO.
DEFINE VARIABLE h2         AS CHARACTER              NO-UNDO.
DEFINE VARIABLE hb         AS INTEGER                NO-UNDO.
DEFINE VARIABLE i          AS INTEGER                NO-UNDO.
DEFINE VARIABLE sh         AS CHARACTER              NO-UNDO.
DEFINE VARIABLE inc-hid    AS LOGICAL INITIAL FALSE  NO-UNDO.
DEFINE VARIABLE j          AS INTEGER                NO-UNDO.
DEFINE VARIABLE l          AS LOGICAL                NO-UNDO.
DEFINE VARIABLE lb         AS INTEGER                NO-UNDO.
DEFINE VARIABLE noselect   AS LOGICAL   INITIAL TRUE NO-UNDO.
DEFINE VARIABLE offset     AS INTEGER   INITIAL 20   NO-UNDO.
DEFINE VARIABLE p_all      AS LOGICAL                NO-UNDO.
DEFINE VARIABLE p_allw     AS LOGICAL                NO-UNDO.
DEFINE VARIABLE count      AS INTEGER   INITIAL 0    NO-UNDO.
DEFINE VARIABLE p_init     AS INTEGER   INITIAL ?    NO-UNDO.
DEFINE VARIABLE p_option   AS LOGICAL                NO-UNDO.
DEFINE VARIABLE p_original AS CHARACTER              NO-UNDO.
DEFINE VARIABLE p_recid    AS INTEGER   INITIAL 1    NO-UNDO.
DEFINE VARIABLE p_some     AS LOGICAL                NO-UNDO.
DEFINE VARIABLE p_spot     AS INTEGER                NO-UNDO.
DEFINE VARIABLE p_touch    AS LOGICAL   INITIAL TRUE NO-UNDO.
DEFINE VARIABLE p_typed    AS CHARACTER INITIAL ""   NO-UNDO.
DEFINE VARIABLE pattern    AS CHARACTER INITIAL "*"  NO-UNDO.
DEFINE VARIABLE point_flag AS LOGICAL   EXTENT  2048 NO-UNDO.
DEFINE VARIABLE redraw     AS LOGICAL   INITIAL TRUE NO-UNDO.
DEFINE VARIABLE small      AS INTEGER                NO-UNDO.
DEFINE VARIABLE isCpUndefined AS LOGICAL             NO-UNDO.
DEFINE VARIABLE use_lchar  AS LOGICAL                NO-UNDO.

/* LANGUAGE DEPENDENCIES START */ /*----------------------------------------*/

DEFINE VARIABLE new_lang AS CHARACTER EXTENT 13 NO-UNDO INITIAL [
  /*  1*/ "(or ~"ALL~" for all tables)", /* length must be <= 26 */
  /*  2*/ "The entered name does not match any table name in this database.",
  /*  3*/ "Use direction keys navigate, or begin typing table name.",
  /*  4*/ "You do not have permission to select tables.",
  /*5,6*/ "Press the", "key to end.",
  /*  7*/ "key.",
  /*  8*/ "when done.",
  /*  9*/ "Press",
  /* 10*/ "to select/deselect",
  /* 11*/ "by pattern.",
  /* 12*/ "There are no tables in this database to select.",
  /* 13*/ "key to show/hide hidden files."
].

FORM
  point_flag[p_recid] FORMAT "*/ "
  cache_file[p_recid] FORMAT "x(34)"
  WITH FRAME t-pick SCROLL 1 NO-LABELS ATTR-SPACE
  COLOR DISPLAY VALUE(pick-fg) PROMPT VALUE(pick-bg)
  SCREEN-LINES - 10 DOWN ROW 7 COLUMN offset. /* see below if changing DOWN */

FORM
  c          LABEL "Table Name" FORMAT "x(26)" NO-ATTR-SPACE SKIP
  p_typed NO-LABEL              FORMAT "x(37)"
  WITH FRAME t-type SIDE-LABELS ATTR-SPACE ROW 3 COLUMN offset
  COLOR DISPLAY VALUE(pick-fg) PROMPT VALUE(pick-bg).
COLOR DISPLAY VALUE(IF pick-bg = "MESSAGES" THEN "INPUT" ELSE pick-bg) p_typed
  WITH FRAME t-type.

FORM
  "Select tables with the [" SPACE(0) c FORMAT "x(14)" SKIP
  "Press [" SPACE(0) g FORMAT "x(32)" SKIP
  h FORMAT "x(34)" h2 FORMAT "x(12)"  SKIP
  sh FORMAT "x(45)"
  WITH FRAME t-help NO-LABELS NO-ATTR-SPACE ROW 1 COLUMN offset
  COLOR DISPLAY VALUE(pick-fg) PROMPT VALUE(pick-bg).

FORM SKIP(1)
  "Enter name of table to" AT 2
  l FORMAT "select./deselect." NO-LABEL SKIP

  "Use * and . for wildcard patterns." AT 2 SKIP(1)

  pattern AT 2 LABEL "Table Name" FORMAT "x(30)" SKIP(1)
  WITH FRAME t-patt OVERLAY ROW 7 CENTERED SIDE-LABELS ATTR-SPACE
  COLOR DISPLAY VALUE(pick-fg) PROMPT VALUE(pick-bg).

/* LANGUAGE DEPENDENCIES END */ /*------------------------------------------*/
/* In case the last change was rolled back, we want to refresh the table list */
IF SESSION:SCHEMA-CHANGE = "New objects" THEN
    ASSIGN cache_dirty = true.

if user_env[42] = "" or user_env[42] = "true" then 
assign cache_dirty = true.

IF cache_dirty THEN RUN "prodict/_dctcach.p" (inc-hid).

i = 0.
FIND _File WHERE _File._File-name = "_File"
             AND _File._Owner = "PUB".
IF NOT CAN-DO(_Can-read,USERID("DICTDB")) THEN i = 4. /* no perm to peek */
IF cache_file# = 0 THEN DO:
  FIND FIRST _File WHERE _Db-recid = drec_db 
                     AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN")
                     AND _Hidden NO-ERROR.
  IF NOT AVAILABLE _File THEN i = 12. /* no files */
END.
IF i > 0 THEN DO:
  MESSAGE new_lang[i] VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  ASSIGN
    drec_file     = ?
    user_path     = ""
    user_filename = ""
    user_env[1]   = "".
  RETURN.
END.

/* 20050930-006
   If the cache information is in the temp-table, run the version that
   reads the temp-table 
*/
IF l_cache_tt THEN DO:
    RUN prodict/user/_usrtget-tt.p.
    RETURN.
END.

IF user_filename <> "" THEN DO:
  { prodict/dictsrch.i
    &vector=cache_file
    &extent=cache_file#
    &tofind=user_filename
    &result=i
  }
  IF i > 0 THEN ASSIGN
    p_init  = MINIMUM(SCREEN-LINES - 10,i)
    p_recid = i.
END.

ASSIGN
  p_option      = user_env[1] MATCHES "*o*" AND drec_file <> ?
  p_all         = user_env[1] MATCHES "*a*"
  p_allw        = user_env[1] MATCHES "***"
  p_some        = user_env[1] MATCHES "*s*"
  p_typed       = (IF user_filename = "SOME" THEN "" ELSE user_filename)
  cache_dirty   = p_some AND p_all OR (p_some AND p_allw) /* this is important! */
  user_filename = "".

IF SESSION:CPINTERNAL EQ "undefined":U THEN
   isCpUndefined = YES.

IF p_all AND p_allw AND cache_file[1] <> "ALL" AND cache_file# >= 1 THEN DO:
  DO i = cache_file# + 1 TO 2 BY -1:
    cache_file[i] = cache_file[i - 1].
  END.
  ASSIGN
    cache_file[1] = "ALL"
    cache_file#   = cache_file# + 1.  
END.
ELSE IF NOT p_all AND p_allw AND cache_file[1] = "ALL" THEN
DO:
  /* This means "ALL" should not be offered BUG# 19991025-003
   * This is certainly strange, but "ALL" may have been put into
   * cache_file[1] before we got here.  It was easier to do this
   * than to modify every program that calls this.
   */
  IF cache_file# > 1 THEN
  DO i = 1 TO cache_file#:
     cache_file[i] = cache_file[i + 1].
     IF i = cache_file# THEN cache_file# = cache_file# - 1.
  END.
  ELSE if cache_file# = 1 THEN
  ASSIGN
     cache_file[1] = ""
     cache_file# = 0.
END.

IF (p_typed = "ALL" AND NOT p_all)
  OR (p_typed = "" AND cache_file# > 0) THEN p_typed = cache_file[1].
p_original =  p_typed.

IF p_option THEN user_filename = p_typed.
ELSE IF p_some THEN 
  DISPLAY
  KBLABEL("RETURN") + "] " + new_lang[7] @ c
  KBLABEL("GO")     + "] " + new_lang[8] @ g
  new_lang[9] + " [" + KBLABEL("GET") + "]/[" + KBLABEL("PUT")
                    + "] " + new_lang[10] @ h 
  new_lang[11] @ h2 
  new_lang[5] + " [" + KBLABEL("RECALL") + "] " + new_lang[13] @ sh
  WITH FRAME t-help.
ELSE DISPLAY (IF p_all AND p_allw THEN new_lang[1] ELSE "") @ c WITH FRAME t-type.
                         /* ^-- (or "ALL" for all files) */
IF NOT p_option THEN DO:
  DISPLAY "" @ cache_file[p_recid] WITH FRAME t-pick.

  user_status = new_lang[5] + " [" + KBLABEL("END-ERROR") + "] " + new_lang[6].
  STATUS DEFAULT user_status.

  IF NOT p_option THEN _pick: DO WHILE TRUE: 

    p_recid = MAXIMUM(1,MINIMUM(cache_file#,p_recid)).

    IF redraw THEN DO WITH FRAME t-pick:
      IF p_init <> ? THEN DOWN p_init - 1.
      ASSIGN
        j      = MAXIMUM(1,FRAME-LINE)
        p_spot = p_recid - j + 1
        p_init = ?.
      UP j - 1.
      IF p_spot < 1 THEN ASSIGN
        p_spot  = 1
        j       = 1
        p_recid = 1.
      i = p_recid.
      DO p_recid = p_spot TO p_spot + FRAME-DOWN - 1:
        IF p_recid > cache_file# THEN
          CLEAR NO-PAUSE.
        ELSE
          DISPLAY point_flag[p_recid] cache_file[p_recid].
        IF p_recid < p_spot + FRAME-DOWN - 1 THEN DOWN.
      END.
      ASSIGN
        p_init  = ?
        redraw  = FALSE
        p_recid = i
        j       = (IF p_init = ? THEN j ELSE p_init).
      UP FRAME-DOWN - j.
    END.

    IF cache_file# > 0 THEN
      DISPLAY point_flag[p_recid] cache_file[p_recid] WITH FRAME t-pick.

    IF cache_file# > 0 AND cache_file[p_recid] BEGINS p_typed AND
      (p_some OR p_recid = cache_file# OR cache_file[p_recid] = p_typed
      OR NOT cache_file[p_recid + 1] BEGINS p_typed) THEN
      COLOR DISPLAY VALUE(pick-bg) cache_file[p_recid] WITH FRAME t-pick.
    IF NOT p_some THEN DO WITH FRAME t-type:
      IF INPUT p_typed <> p_typed THEN DISPLAY p_typed.
      PUT CURSOR ROW 6 COLUMN offset + 2 + LENGTH(p_typed).
    END.
    READKEY.
    IF NOT p_some THEN PUT CURSOR OFF.
    IF cache_file# > 0 THEN
      COLOR DISPLAY VALUE(pick-fg) cache_file[p_recid] WITH FRAME t-pick.
    PAUSE 0.

    IF KEYFUNCTION(LASTKEY) = "BACKSPACE" THEN DO:
      IF LENGTH(p_typed) = 0 THEN NEXT _pick.
      ASSIGN
        p_touch = FALSE
        p_typed = SUBSTRING(p_typed,1,LENGTH(p_typed) - 1)
        i       = (IF p_typed = "" THEN 1 ELSE p_recid).
      DO WHILE i > 1 AND cache_file[i - 1] BEGINS p_typed:
        i = i - 1.
      END.
      IF FRAME-LINE(t-pick) >= p_recid - i THEN
        UP p_recid - i WITH FRAME t-pick.
      ELSE
        redraw = TRUE.
      p_recid = i.
      NEXT _pick.
    END.

    IF KEYFUNCTION(LASTKEY) = CHR(LASTKEY) AND LASTKEY > 32 THEN DO:
      ASSIGN
        p_typed = (IF p_touch THEN "" ELSE p_typed) + CHR(LASTKEY)
        p_touch = FALSE.
      IF   (cache_file# = 0)
        OR (cache_file[p_recid] BEGINS p_typed)
        OR (p_typed < SUBSTRING(cache_file[1],1,LENGTH(p_typed)))
        OR (p_typed > cache_file[cache_file#])
        OR (LENGTH(p_typed) > 1 AND NOT cache_file[p_recid] BEGINS
            SUBSTRING(p_typed,1,LENGTH(p_typed) - 1)) THEN NEXT _pick.
      { prodict/dictsrch.i
        &vector=cache_file
        &extent=cache_file#
        &tofind=p_typed
        &result=j
      }
      IF j < 0 THEN j = p_recid.
      p_spot = j - p_recid + FRAME-LINE(t-pick).
      IF j > 0 THEN p_recid = j.
      IF p_spot < 1 OR p_spot > FRAME-DOWN(t-pick) THEN
        redraw = TRUE.
      ELSE
        UP FRAME-LINE(t-pick) - p_spot WITH FRAME t-pick.
      NEXT _pick.
    END.

    IF p_some AND cache_file# > 0 AND (
        (noselect AND KEYFUNCTION(LASTKEY) = "GO") /*if SOME & none yet marked*/
      OR
        CAN-DO("RETURN,PICK",KEYFUNCTION(LASTKEY) )
      ) THEN DO:
      ASSIGN
        noselect            = FALSE
        point_flag[p_recid] = NOT point_flag[p_recid].
      DISPLAY point_flag[p_recid] WITH FRAME t-pick.
    END.
    /*ELSE*/ /* no else here */
    IF CAN-DO("CURSOR-DOWN,TAB, " + (IF p_some THEN ",RETURN" ELSE ""),
      KEYFUNCTION(LASTKEY)) AND p_recid < cache_file# THEN DO:
      p_recid = p_recid + 1.
      IF FRAME-LINE(t-pick) = FRAME-DOWN(t-pick) THEN
        SCROLL UP WITH FRAME t-pick.
      ELSE
        DOWN WITH FRAME t-pick.
    END.
    ELSE
    IF CAN-DO("CURSOR-UP,BACK-TAB",KEYFUNCTION(LASTKEY))
      AND p_recid > 1 THEN DO:
      p_recid = p_recid - 1.
      IF FRAME-LINE(t-pick) = 1 THEN
        SCROLL DOWN WITH FRAME t-pick.
      ELSE
        UP WITH FRAME t-pick.
    END.
    ELSE IF KEYFUNCTION(LASTKEY) = "RECALL" THEN DO:
      IF inc-hid THEN
        ASSIGN inc-hid = FALSE
                 redraw = TRUE.
      ELSE
        ASSIGN inc-hid = TRUE
               redraw = TRUE.
      RUN prodict/_dctcach.p (inc-hid).
    END.
    ELSE
    IF KEYFUNCTION(LASTKEY) = "PAGE-DOWN" THEN ASSIGN
      p_recid = p_recid + FRAME-DOWN(t-pick)
      redraw  = TRUE.
    ELSE
    IF KEYFUNCTION(LASTKEY) = "PAGE-UP" THEN ASSIGN
      p_recid = p_recid - FRAME-DOWN(t-pick)
      redraw  = TRUE.
    ELSE
    IF CAN-DO("HOME,MOVE",KEYFUNCTION(LASTKEY)) AND p_recid > 1 THEN DO:
      ASSIGN
        p_recid = 1
        redraw  = TRUE.
      UP FRAME-LINE(t-pick) - 1 WITH FRAME t-pick.
    END.
    ELSE
    IF CAN-DO("END,HOME,MOVE",KEYFUNCTION(LASTKEY)) THEN DO:
      ASSIGN
        p_recid = cache_file#
        redraw  = TRUE.
      DOWN FRAME-DOWN(t-pick) - FRAME-LINE(t-pick) WITH FRAME t-pick.
    END.
    ELSE
    IF CAN-DO("GO" + (IF p_some THEN "" ELSE ",RETURN"),KEYFUNCTION(LASTKEY))
      THEN DO:
       IF p_some THEN DO:
         user_filename = "".

         IF NOT isCpUndefined THEN
             user_longchar = "".
         
        /* The commented out sections within this block are because we
         * no longer allow ALL to be in the list when we present the flavor
         * that allows wildcards and the select/deselect of one or more files. 
         * Bug# 19991025-003.
         */

         /* let's do a quick check to see if user selected all */
         DO p_recid = 1 TO cache_file#:
            IF point_flag[p_recid] THEN
               count = count + 1.
         END.

         IF count = cache_file# THEN
            user_filename = "ALL".
         ASSIGN count = 0.

         IF user_filename = "" THEN DO p_recid = 1 TO cache_file#:
           IF point_flag[p_recid] /* OR (p_all AND point_flag[1]) OR (p_allw
              AND point_flag[1]) */ THEN DO:             
             count = count + 1.
             IF COUNT = 1 THEN
                user_filename = cache_file[p_recid].
             ELSE DO:
                IF use_lchar THEN
                   user_longchar = user_longchar + "," + cache_file[p_recid] NO-ERROR.
                ELSE
                   user_filename = user_filename + "," + cache_file[p_recid] NO-ERROR.
                
                IF ERROR-STATUS:ERROR THEN DO:
                    /* if undefined codepage, nothing we can do but error out */
                    IF isCpUndefined THEN
                        user_filename = user_filename + "," + cache_file[p_recid].
                    
                    ASSIGN user_longchar =  user_filename + "," + cache_file[p_recid]. 
                           use_lchar = YES.
                END.
             END.

           END.
           ELSE IF point_flag[p_recid] AND NOT p_all AND NOT p_allw
           THEN count = cache_file# - 1.
        END.

        /* can't happen anymore
           IF user_filename BEGINS "," THEN
          user_filename = SUBSTRING(user_filename,2).
         */
      END. /* if p_some */
      ELSE
      IF p_all AND p_typed = "ALL" THEN user_filename = "ALL".
      ELSE
      IF cache_file[p_recid] BEGINS p_typed AND
        (p_recid = cache_file# OR cache_file[p_recid] = p_typed
        OR NOT cache_file[p_recid + 1] BEGINS p_typed)
        THEN user_filename = cache_file[p_recid].
      ELSE
      IF p_typed <> cache_file[p_recid] THEN DO:
        FIND FIRST _File
          WHERE _File._Db-recid = drec_db
            AND _File._File-name BEGINS p_typed 
            AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN") NO-ERROR.
        IF NOT AVAILABLE _File OR CAN-DO({&INVALID_SCHEMA_TABLES},_File._File-name) THEN DO:
          MESSAGE new_lang[2]. /* bad filename guess */
          BELL.
          NEXT _pick.
        END.
        user_filename = _File._File-name.
      END.
      LEAVE _pick.
    END.
    ELSE
    IF CAN-DO("GET,PUT",KEYFUNCTION(LASTKEY)) AND p_some THEN DO:
      ASSIGN
        noselect = FALSE
        lb = 0
        l = KEYFUNCTION(LASTKEY) = "GET".
      PAUSE 0.
      DISPLAY l WITH FRAME t-patt.
      DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
        UPDATE pattern WITH FRAME t-patt.
      END.
      redraw = KEYFUNCTION(LASTKEY) <> "END-ERROR".
      IF redraw THEN DO i = 1 TO cache_file#:
        IF CAN-DO(pattern,cache_file[i]) THEN
          ASSIGN point_flag[i] = l lb = lb + 1.
      END.
      HIDE FRAME t-patt NO-PAUSE.
      IF redraw AND lb = 0 AND l THEN DO:
        lb = cache_file#.
        FOR EACH _File
          WHERE _File._Db-recid = drec_db 
            AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN")
            AND _File._Hidden
            AND CAN-DO(pattern,_File._File-name)
            AND _File._tbl-type <> "V" :
          ASSIGN lb = lb + 1 cache_file[lb] = _File._File-name.
        END.
        IF lb <> cache_file# THEN DO i = 1 TO lb: /* this is exchange sort */
          hb = i.
          DO j = i + 1 TO lb:
            IF cache_file[j] < cache_file[hb] THEN hb = j.
          END.
          IF hb > i THEN ASSIGN
            c              = cache_file[i]
            cache_file[i]  = cache_file[hb]
            cache_file[hb] = c.
        END. /*--------------------------------------- end of exchange sort */
        ASSIGN
          cache_dirty = lb <> cache_file#
          cache_file# = lb.          
      END.
    END.
    ELSE
    IF CAN-DO("CLEAR,RECALL",KEYFUNCTION(LASTKEY)) THEN DO:
      p_typed = (IF KEYFUNCTION(LASTKEY) = "CLEAR" THEN "" ELSE p_original).
      NEXT _pick.
    END.
    ELSE
    IF KEYFUNCTION(LASTKEY) = "END-ERROR" THEN DO:
      ASSIGN
        user_filename = ""
        user_path     = "".
      LEAVE _pick.
    END.
    ASSIGN
      p_typed = cache_file[MAXIMUM(1,MINIMUM(cache_file#,p_recid))]
      p_touch = TRUE.
   
  END. /* _pick */
END. /* if optional */

FIND FIRST _File WHERE _File._Db-recid = drec_db
  AND _File._File-name = SUBSTRING(user_filename,1,33)
  AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN") 
  AND _File._Tbl-type <> "V" NO-ERROR.
  /* Take a piece of user_filename since it can get pretty long.
  PROGRESS will gronk with "SYSTEM ERROR: fmsrt - maxdlen. (59)" if you
  try to compare a key with a string > 127 chars.  I learned this from
  experience. (Good judgement comes from experience.  Experience comes
  from bad judgement.) */  
ASSIGN
  user_filename = (IF AVAILABLE _File THEN _File._File-name
                  ELSE user_filename)
  user_env[1]   = (IF NOT use_lchar THEN user_filename ELSE "")
  drec_file     = RECID(_File).

IF use_lchar THEN
   user_filename = "SOME".
ELSE
IF user_filename MATCHES "*,*" THEN DO:
   IF p_all OR p_allw AND NOT p_some OR (count = cache_file#)
     THEN user_filename = "ALL".
   ELSE
     user_filename = "SOME".
END.
ELSE
IF user_filename <> "" THEN DO:
  /* I'm guessing this has never and will never execute.  Mario - 12/7/99 */
  IF count >= 1 AND (p_all OR p_allw) AND (count = cache_file#)
    THEN DO:
      user_env[1] = "ALL".
      user_filename = "ALL".
    END.
END.

DISPLAY user_filename WITH FRAME user_ftr.
IF user_filename = "" THEN user_path = "".

HIDE FRAME t-help NO-PAUSE.
HIDE FRAME t-patt NO-PAUSE.
HIDE FRAME t-pick NO-PAUSE.
HIDE FRAME t-type NO-PAUSE.
user_status = ?.
STATUS DEFAULT.
RETURN.


