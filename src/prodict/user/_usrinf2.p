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

/*
  Display some interesting session information.
*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

DEFINE INPUT PARAMETER p_DbId AS RECID NO-UNDO.  /* not used here */

DEFINE VARIABLE codepage  AS CHARACTER          NO-UNDO.
DEFINE VARIABLE collname  AS CHARACTER          NO-UNDO.
DEFINE VARIABLE conn      AS LOGICAL     	NO-UNDO.
DEFINE VARIABLE drest     AS CHARACTER   	NO-UNDO.
DEFINE VARIABLE dtype     AS CHARACTER   	NO-UNDO.
DEFINE VARIABLE dvers     AS CHARACTER   	NO-UNDO.
DEFINE VARIABLE fcomma	  AS CHARACTER          NO-UNDO.
DEFINE VARIABLE fpoint	  AS CHARACTER          NO-UNDO.
DEFINE VARIABLE i	  AS INTEGER            NO-UNDO.
DEFINE VARIABLE j	  AS INTEGER            NO-UNDO.
DEFINE VARIABLE lname     AS CHARACTER   	NO-UNDO.
DEFINE VARIABLE mdy	  AS CHARACTER          NO-UNDO.
DEFINE VARIABLE num       AS INTEGER            NO-UNDO.
DEFINE VARIABLE pname     AS CHARACTER   	NO-UNDO.
DEFINE VARIABLE prpath	  AS CHARACTER EXTENT 6 NO-UNDO.
DEFINE VARIABLE scharset  AS CHARACTER   	NO-UNDO.
DEFINE VARIABLE sname     AS CHARACTER   	NO-UNDO.
DEFINE VARIABLE sstream   AS CHARACTER   	NO-UNDO.
DEFINE VARIABLE tmpfile   AS CHARACTER          NO-UNDO.
DEFINE VARIABLE uid       AS CHARACTER   	NO-UNDO.
DEFINE VARIABLE yy	  AS INTEGER            NO-UNDO.

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
   uid      FORMAT "x(50)"  LABEL "Database User Id"    COLON 19 SKIP
   codepage FORMAT "x(50)"  LABEL "Database code page"  COLON 19 SKIP
   collname FORMAT "x(50)"  LABEL "Database collation"  COLON 19 SKIP
   WITH FRAME dbs SIDE-LABELS ATTR-SPACE CENTERED USE-TEXT STREAM-IO
   TITLE " Currently Selected Database ".


ASSIGN
  fpoint   = SUBSTRING(STRING(1,"9."),2,1)
  fcomma   = STRING(fpoint = ".",",/.")
  scharset = SESSION:CHARSET
  prpath   = PROPATH
  sstream  = SESSION:STREAM.

{ prodict/dictsplt.i &src=PROPATH &dst=prpath &num=6 &len=60 &chr="," }

RUN "prodict/_dctyear.p" (OUTPUT mdy,OUTPUT yy).

/* LANGUAGE DEPENDENCIES START */ /*----------------------------------------*/

IF user_dbname = ? OR user_dbname = "" THEN 
  /* if only db is non-V7, show info on the first one. */
  DISPLAY STREAM rpt
    NUM-DBS      @ num
    IF NUM-DBS > 0 THEN yes ELSE no @ conn
    PDBNAME(1)   @ pname
    LDBNAME(1)   @ lname
    SDBNAME(1)   @ sname
    DBTYPE(1)	 @ dtype
    DBVERSION(1) @ dvers
    DBREST(1)    @ drest
    USERID(LDBNAME(1)) @ uid  
    ?            @ codepage
    ?            @ collname
    WITH FRAME dbs.
  ELSE DO:
    RUN prodict/user/_usrinf3.p 
      (INPUT  user_dbname,
       INPUT  user_dbtype,
       OUTPUT codepage, 
       OUTPUT collname).
    DISPLAY STREAM rpt
      NUM-DBS    	     @ num
      yes		     @ conn
      PDBNAME(user_dbname)   @ pname
      LDBNAME(user_dbname)   @ lname
      SDBNAME(user_dbname)   @ sname
      DBTYPE(user_dbname)    @ dtype
      DBVERSION(user_dbname) @ dvers
      DBREST(user_dbname)    @ drest
      USERID(user_dbname)    @ uid
      codepage
      collname
      WITH FRAME dbs.
    END.
        

DISPLAY STREAM rpt
  OPSYS      FORMAT "x(55)" LABEL "Operating System" COLON 18 SKIP
  PROGRESS   FORMAT "x(55)" LABEL "Module type"      COLON 18 SKIP
  PROVERSION FORMAT "x(55)" LABEL "PRO version"      COLON 18 SKIP
  GATEWAYS   FORMAT "x(55)" LABEL "DataServers"      COLON 18 SKIP
  WITH FRAME ops SIDE-LABELS ATTR-SPACE CENTERED USE-TEXT STREAM-IO
  TITLE " PROGRESS and Operating System ".

DISPLAY STREAM rpt
  yy       FORMAT ">>>9"  LABEL "-yy century setting"     COLON 22
  fpoint   FORMAT "x"     LABEL "Decimal point character" COLON 56 SKIP
  mdy      FORMAT "x(4)"  LABEL "-d dmy date setting"     COLON 22
  fcomma   FORMAT "x"     LABEL "Thousands separator"     COLON 56 SKIP(1)
  sstream  FORMAT "x(20)" LABEL "Session stream"          COLON 22 SKIP
  scharset FORMAT "x(20)" LABEL "Session charset"         COLON 22 SKIP(1)
  "PROPATH =" NO-ATTR-SPACE                             AT 2  
              prpath[1] FORMAT "x(60)" NO-LABEL         AT 12 SKIP
      	      prpath[2] FORMAT "x(60)" NO-LABEL       	AT 12 SKIP
      	      prpath[3] FORMAT "x(60)" NO-LABEL       	AT 12 SKIP
      	      prpath[4] FORMAT "x(60)" NO-LABEL       	AT 12 SKIP
      	      prpath[5] FORMAT "x(60)" NO-LABEL       	AT 12 SKIP
      	      prpath[6] FORMAT "x(60)" NO-LABEL       	AT 12 SKIP
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
