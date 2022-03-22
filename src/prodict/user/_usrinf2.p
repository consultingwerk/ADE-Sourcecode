/*********************************************************************
* Copyright (C) 2006,2014,2020 by Progress Software Corporation. All *
* rights reserved.  Prior versions of this work may contain portions *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* Progress Lex Converter 7.1A->7.1B Version 1.11 */

/*
  Display some interesting session information.
  Increased number of extents for propath so all .pl's will show 20010411-002
  
  D. McMann 02/21/03 Replaced GATEWAYS with DATASERVERS and remved PROGRESS
  fernando  06/06/06 Large sequence and large index support.
  Kberlia   10/30/20 Added default area support to show the db objects information in session info dialogue box.
*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

DEFINE INPUT PARAMETER p_DbId AS RECID NO-UNDO.  /* not used here */

DEFINE VARIABLE codepage  AS CHARACTER          NO-UNDO.
DEFINE VARIABLE collname  AS CHARACTER          NO-UNDO.
DEFINE VARIABLE conn      AS LOGICAL             NO-UNDO.
DEFINE VARIABLE drest     AS CHARACTER           NO-UNDO.
DEFINE VARIABLE dtype     AS CHARACTER           NO-UNDO.
DEFINE VARIABLE dvers     AS CHARACTER           NO-UNDO.
DEFINE VARIABLE fcomma          AS CHARACTER          NO-UNDO.
DEFINE VARIABLE fpoint          AS CHARACTER          NO-UNDO.
DEFINE VARIABLE i          AS INTEGER            NO-UNDO.
DEFINE VARIABLE j          AS INTEGER            NO-UNDO.
DEFINE VARIABLE lname     AS CHARACTER           NO-UNDO.
DEFINE VARIABLE mdy          AS CHARACTER          NO-UNDO.
DEFINE VARIABLE num       AS INTEGER            NO-UNDO.
DEFINE VARIABLE pname     AS CHARACTER           NO-UNDO.
DEFINE VARIABLE prpath          AS CHARACTER EXTENT 20 NO-UNDO.
DEFINE VARIABLE scharset  AS CHARACTER           NO-UNDO.
DEFINE VARIABLE sname     AS CHARACTER           NO-UNDO.
DEFINE VARIABLE sstream   AS CHARACTER           NO-UNDO.
DEFINE VARIABLE tmpfile   AS CHARACTER          NO-UNDO.
DEFINE VARIABLE uid       AS CHARACTER           NO-UNDO.
DEFINE VARIABLE yy        AS INTEGER        NO-UNDO.
DEFINE VARIABLE idx       AS INTEGER        NO-UNDO.
DEFINE VARIABLE Large_Sequence AS CHARACTER NO-UNDO.
DEFINE VARIABLE Large_Keys     AS CHARACTER NO-UNDO.
DEFINE VARIABLE Is_Partitioned AS CHARACTER NO-UNDO.
DEFINE VARIABLE Is_Multitenant     AS CHARACTER NO-UNDO.
DEFINE VARIABLE Is_CDCEnabled      AS CHARACTER NO-UNDO.
DEFINE VARIABLE l_seq          AS LOGICAL   /*UNDO*/.
DEFINE VARIABLE l_keys         AS LOGICAL   /*UNDO*/.
DEFINE VARIABLE IsPartitioned  AS LOGICAL /*UNDO*/.
DEFINE VARIABLE IsMultitenant  AS LOGICAL /*UNDO*/.
DEFINE VARIABLE IsCDCEnabled   AS LOGICAL /*UNDO*/.
DEFINE VARIABLE is_Tbldfltarea AS CHARACTER NO-UNDO.
DEFINE VARIABLE is_Idxdfltarea AS CHARACTER NO-UNDO.
DEFINE VARIABLE is_Lobdfltarea AS CHARACTER NO-UNDO.

DEFINE SHARED STREAM rpt.

FORM
   num      FORMAT ">>9"    LABEL "Connected DBs"       COLON 19 SKIP
   conn     FORMAT "yes/no" LABEL "Connected"           COLON 19 SKIP
   pname    FORMAT "x(50)"  LABEL "Physical name"       COLON 19 SKIP
   lname    FORMAT "x(50)"  LABEL "Logical name"        COLON 19 SKIP
   sname    FORMAT "x(50)"  LABEL "Schema holder"       COLON 19 SKIP
   dtype    FORMAT "x(50)"  LABEL "Database type"       COLON 19 SKIP
   dvers    FORMAT "x(50)"  LABEL "Database version"    COLON 19 SKIP
   drest    FORMAT "x(50)"  LABEL "Restrictions"        COLON 19 SKIP
   uid      FORMAT "x(50)"  LABEL "Database user id"    COLON 19 SKIP
   codepage FORMAT "x(50)"  LABEL "Database code page"  COLON 19 SKIP
   collname FORMAT "x(50)"  LABEL "Database collation"  COLON 19 SKIP
   WITH FRAME dbs SIDE-LABELS ATTR-SPACE CENTERED USE-TEXT STREAM-IO
   TITLE " Currently Selected Database ".

FORM
   num      FORMAT ">>9"    LABEL "Connected DBs"       COLON 20 SKIP
   conn     FORMAT "yes/no" LABEL "Connected"           COLON 20 SKIP
   pname    FORMAT "x(50)"  LABEL "Physical name"       COLON 20 SKIP
   lname    FORMAT "x(50)"  LABEL "Logical name"        COLON 20 SKIP
   sname    FORMAT "x(50)"  LABEL "Schema holder"       COLON 20 SKIP
   dtype    FORMAT "x(50)"  LABEL "Database type"       COLON 20 SKIP
   dvers    FORMAT "x(50)"  LABEL "Database version"    COLON 20 SKIP
   drest    FORMAT "x(50)"  LABEL "Restrictions"        COLON 20 SKIP
   uid      FORMAT "x(50)"  LABEL "Database user id"    COLON 20 SKIP
   codepage FORMAT "x(50)"  LABEL "Database code page"  COLON 20 SKIP
   collname FORMAT "x(50)"  LABEL "Database collation"  COLON 20 SKIP
   Large_Sequence FORMAT "x(20)"  LABEL "64-bit Sequences" COLON 20 SKIP
   Large_Keys     FORMAT "x(20)"  LABEL "Large key entries"  COLON 20 SKIP
   is_Multitenant FORMAT "x(20)"  LABEL "Multi-tenancy" COLON 20 SKIP
   is_Partitioned FORMAT "x(20)"  LABEL "Table Partitioning" COLON 20 SKIP
   is_CDCEnabled  FORMAT "x(20)"  LABEL "Change Data Capture" COLON 20 SKIP
   is_Tbldfltarea FORMAT "x(40)"  LABEL "Default area (table)" COLON 21 SKIP 
   is_Idxdfltarea FORMAT "x(40)"  LABEL "Default area (index)" COLON 21 SKIP
   is_Lobdfltarea FORMAT "x(40)"  LABEL "Default area (lob)"   COLON 21 SKIP
   WITH FRAME dbs-2 SIDE-LABELS ATTR-SPACE CENTERED USE-TEXT STREAM-IO
   TITLE " Currently Selected Database ".

ASSIGN
  fpoint   = SUBSTRING(STRING(1,"9."),2,1)
  fcomma   = STRING(fpoint = ".",",/.")
  scharset = SESSION:CHARSET
  prpath   = PROPATH
  sstream  = SESSION:STREAM.

FIND FIRST dictdb._Db SHARE-LOCK NO-ERROR.
IF AVAILABLE dictdb._Db THEN 
DO:
   IF _Db._Db-misc1[1] <> ? THEN
   DO:
      FIND dictdb._Area WHERE dictdb._Area._Area-number = dictdb._Db._Db-misc1[1] NO-LOCK NO-ERROR.
      IF AVAILABLE dictdb._Area THEN
         ASSIGN is_Tbldfltarea = dictdb._Area._Area-name.
   END.
   IF _Db._Db-misc1[2] <> ? THEN
   DO:
      FIND dictdb._Area WHERE dictdb._Area._Area-number = dictdb._Db._Db-misc1[2] NO-LOCK NO-ERROR.
      IF AVAILABLE dictdb._Area THEN
         ASSIGN is_Idxdfltarea = dictdb._Area._Area-name.
   END.
   IF _Db._Db-misc1[3] <> ? THEN
   DO:
      FIND dictdb._Area WHERE dictdb._Area._Area-number = dictdb._Db._Db-misc1[3] NO-LOCK NO-ERROR.
      IF AVAILABLE dictdb._Area THEN
         ASSIGN is_Lobdfltarea = dictdb._Area._Area-name.
   END.
END.
RELEASE dictdb._Db.  
   
{ prodict/dictsplt.i &src=PROPATH &dst=prpath &num=20 &len=60 &chr="," }

RUN "prodict/_dctyear.p" (OUTPUT mdy,OUTPUT yy).

/* LANGUAGE DEPENDENCIES START */ /*----------------------------------------*/
IF user_dbname = ? OR user_dbname = "" THEN DO:
  /* if only db is non-V10, show info on the first one. */

  /* 20060209-012
     Make sure we omit the password, after the '/' character, in case
     this is an ORACLE schema.
  */
  ASSIGN uid = USERID(LDBNAME(1))
         idx = INDEX(uid,"/").

  IF idx > 0 THEN
     uid = SUBSTRING(uid,1,idx - 1).

  DISPLAY STREAM rpt
    NUM-DBS      @ num
    IF NUM-DBS > 0 THEN YES ELSE NO @ conn
    PDBNAME(1)   @ pname
    LDBNAME(1)   @ lname
    SDBNAME(1)   @ sname
    DBTYPE(1)         @ dtype
    DBVERSION(1) @ dvers
    DBREST(1)    @ drest
    uid  
    ?            @ codepage
    ?            @ collname
    WITH FRAME dbs.
  END.
  ELSE DO:
    RUN prodict/user/_usrinf3.p 
      (INPUT  user_dbname,
       INPUT  user_dbtype,
       OUTPUT codepage, 
       OUTPUT collname,
       OUTPUT l_seq,
       OUTPUT l_keys,
       OUTPUT isMultitenant,
       OUTPUT isPartitioned,
       OUTPUT isCDCEnabled).

    /* 20060209-012
       Make sure we omit the password, after the '/' character, in case
       this is an ORACLE schema.
    */
    ASSIGN uid = USERID(user_dbname)
           idx = INDEX(uid,"/").

    IF idx > 0 THEN
       uid = SUBSTRING(uid,1,idx - 1).

    /* if this is not a Progress db, or it's running with a pre-10.1B release,
       where large sequence and large keys support is not available, don't bother 
       displaying information.
    */
    IF user_dbtype NE "PROGRESS" OR (l_seq = ? AND l_keys = ?) THEN
    DISPLAY STREAM rpt
      NUM-DBS                 @ num
      YES                     @ conn
      PDBNAME(user_dbname)   @ pname
      LDBNAME(user_dbname)   @ lname
      SDBNAME(user_dbname)   @ sname
      DBTYPE(user_dbname)    @ dtype
      DBVERSION(user_dbname) @ dvers
      DBREST(user_dbname)    @ drest
      uid
      codepage
      collname
      WITH FRAME dbs.
    ELSE
      DISPLAY STREAM rpt
            NUM-DBS                 @ num
            YES                     @ conn
            PDBNAME(user_dbname)   @ pname
            LDBNAME(user_dbname)   @ lname
            SDBNAME(user_dbname)   @ sname
            DBTYPE(user_dbname)    @ dtype
            DBVERSION(user_dbname) @ dvers
            DBREST(user_dbname)    @ drest
            uid
            codepage
            collname
            (IF isMultitenant = ? THEN "n/a" ELSE 
                    IF isMultitenant THEN "enabled" 
                        ELSE "not enabled") @ is_Multitenant
            (IF isPartitioned = ? THEN "n/a" ELSE 
                    IF isPartitioned THEN "enabled" 
                        ELSE "not enabled") @ is_Partitioned 
            (IF isCDCEnabled = ? THEN "n/a" ELSE 
                    IF isCDCEnabled THEN "enabled" 
                        ELSE "not enabled") @ is_CDCEnabled 
            (IF l_seq = ? THEN "n/a" ELSE 
                    IF l_seq THEN "enabled" 
                        ELSE "not enabled") @ Large_Sequence
            (IF l_keys = ? THEN "n/a" ELSE 
                    IF l_keys THEN "enabled" 
                        ELSE "not enabled") @ Large_Keys
            (IF is_Tbldfltarea = "" THEN "undefined" ELSE
            is_Tbldfltarea) @ is_Tbldfltarea
            (IF is_Idxdfltarea = "" THEN "undefined" ELSE
            is_Idxdfltarea) @ is_Idxdfltarea
            (IF is_Lobdfltarea = "" THEN "undefined" ELSE
            is_Lobdfltarea) @ is_Lobdfltarea
            WITH FRAME dbs-2.
    END.
        

DISPLAY STREAM rpt
  OPSYS       FORMAT "x(55)" LABEL "Operating System" COLON 18 SKIP
  PROVERSION  FORMAT "x(55)" LABEL "PRO version"      COLON 18 SKIP
  DATASERVERS FORMAT "x(55)" LABEL "DataServers"      COLON 18 SKIP
  WITH FRAME ops SIDE-LABELS ATTR-SPACE CENTERED USE-TEXT STREAM-IO
  TITLE " OpenEdge and Operating System ".

DISPLAY STREAM rpt
  yy       FORMAT ">>>9"  LABEL "-yy century setting"     COLON 22
  fpoint   FORMAT "x"     LABEL "Decimal point character" COLON 56 SKIP
  mdy      FORMAT "x(4)"  LABEL "-d dmy date setting"     COLON 22
  fcomma   FORMAT "x"     LABEL "Thousands separator"     COLON 56 SKIP(1)
  sstream  FORMAT "x(20)" LABEL "Session stream"          COLON 22 SKIP
  scharset FORMAT "x(20)" LABEL "Session charset"         COLON 22 SKIP(1)
  "PROPATH =" NO-ATTR-SPACE                             AT 2  
              prpath[1] FORMAT "x(60)" NO-LABEL         AT 12 SKIP
                    prpath[2] FORMAT "x(60)" NO-LABEL               AT 12 SKIP
                    prpath[3] FORMAT "x(60)" NO-LABEL               AT 12 SKIP
                    prpath[4] FORMAT "x(60)" NO-LABEL               AT 12 SKIP
                    prpath[5] FORMAT "x(60)" NO-LABEL               AT 12 SKIP
                    prpath[6] FORMAT "x(60)" NO-LABEL               AT 12 SKIP
              prpath[7] FORMAT "x(60)" NO-LABEL               AT 12 SKIP
                    prpath[8] FORMAT "x(60)" NO-LABEL               AT 12 SKIP
              prpath[9] FORMAT "x(60)" NO-LABEL               AT 12 SKIP
                    prpath[10] FORMAT "x(60)" NO-LABEL               AT 12 SKIP
              prpath[11] FORMAT "x(60)" NO-LABEL        AT 12 SKIP
                    prpath[12] FORMAT "x(60)" NO-LABEL               AT 12 SKIP
                    prpath[13] FORMAT "x(60)" NO-LABEL               AT 12 SKIP
                    prpath[14] FORMAT "x(60)" NO-LABEL               AT 12 SKIP
                    prpath[15] FORMAT "x(60)" NO-LABEL               AT 12 SKIP
                    prpath[16] FORMAT "x(60)" NO-LABEL               AT 12 SKIP
              prpath[17] FORMAT "x(60)" NO-LABEL               AT 12 SKIP
                    prpath[18] FORMAT "x(60)" NO-LABEL               AT 12 SKIP
              prpath[19] FORMAT "x(60)" NO-LABEL               AT 12 SKIP
                    prpath[20] FORMAT "x(60)" NO-LABEL               AT 12 SKIP
  WITH FRAME env SIDE-LABELS ATTR-SPACE CENTERED USE-TEXT STREAM-IO
  TITLE " Environment/Startup Parameters ".

DISPLAY STREAM rpt
  SCREEN-LINES  FORMAT ">>9"    LABEL "Screen lines"  COLON 15 SKIP
  MESSAGE-LINES FORMAT ">>9"    LABEL "Message lines" COLON 15 SKIP
  IS-ATTR-SPACE FORMAT "yes/no" LABEL "Space-taking"  COLON 15 SKIP
  TERMINAL      FORMAT "x(30)"  LABEL "Terminal type" COLON 15 SKIP(1)
  WITH FRAME scr SIDE-LABELS ATTR-SPACE CENTERED USE-TEXT STREAM-IO
  TITLE " Screen ".

/* LANGUAGE DEPENDENCIES END */ /*------------------------------------------*/

RETURN.
