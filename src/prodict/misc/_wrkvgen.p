/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*

_wrkvgen.p  - creates file with CREATE VIEW statements

user_env[1] = view name or "ALL"
user_env[2] = output file
user_env[3] = userid
user_env[4] = statement terminator

HISTORY:

tomn        12/05/95    Added spacing to frame "working" to fix 4041 
                        errors on intl windows platforms  
gfs         07/03/94    94-07-07-075, 94-07-07-066.

*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

DEFINE VARIABLE lin  AS CHARACTER EXTENT 32 NO-UNDO.
DEFINE VARIABLE lin# AS INTEGER   INITIAL 1 NO-UNDO.
DEFINE VARIABLE c    AS CHARACTER           NO-UNDO.
DEFINE VARIABLE f    AS LOGICAL             NO-UNDO.
DEFINE VARIABLE i    AS INTEGER             NO-UNDO.
DEFINE STREAM code.

FORM
  SKIP(1)
  _View._View-name LABEL "Working on View" AT 3
  SKIP(1)
  WITH FRAME working 
  WIDTH 58 SIDE-LABELS ROW 5 CENTERED &IF "{&WINDOW-SYSTEM}" <> "TTY"
  &THEN VIEW-AS DIALOG-BOX THREE-D TITLE "Dump CREATE VIEW Statement" &ENDIF.
  
COLOR DISPLAY MESSAGES _View._View-name WITH FRAME working.

SESSION:IMMEDIATE-DISPLAY = yes.
PAUSE 0.
OUTPUT STREAM code TO VALUE(user_env[2]) NO-ECHO NO-MAP.

FOR EACH _View WHERE (IF user_env[1] = "ALL"
  /*THEN (user_env[3] = "ALL" OR user_env[3] = ENTRY(1,_View._Can-read))*/
    THEN (user_env[3] = "ALL" OR CAN-DO(_View._Can-read, user_env[3]) )
  ELSE _View-name = user_env[1]):

  IF TERMINAL <> "" THEN
    DISPLAY _View._View-name WITH FRAME working.

  ASSIGN
    lin    = ""
    lin[1] = "DROP VIEW " + _View._View-Name + user_env[4]
    lin[2] = "CREATE VIEW " + _View._View-Name
    lin#   = 3
    f      = TRUE.

  FOR EACH _View-col OF _View BREAK BY _Vcol-Order:
    IF   INDEX(_Col-name,"-") > 0
      OR INDEX(_Col-name,"#") > 0
      OR INDEX(_Col-name,"%") > 0
      OR INDEX(_Col-name,"&") > 0
      OR INDEX(_Col-name,"$") > 0 THEN f = FALSE.
    IF NOT f THEN LEAVE.
  END.

  IF f THEN DO:
    lin[lin#] = "  (".
    FOR EACH _View-col OF _View BREAK BY _Vcol-Order:
      IF LENGTH(lin[lin#]) + LENGTH(_Col-name) > 76 THEN ASSIGN
        lin#      = lin# + 1
        lin[lin#] = "  ".
      lin[lin#] = lin[lin#] + _Col-name.
      IF NOT LAST(_Vcol-Order) THEN lin[lin#] = lin[lin#] + ",".
    END.
    ASSIGN
      lin[lin#] = lin[lin#] + ")"
      lin# = lin# + 1.
  END.

  ASSIGN
    lin[lin#] = "  AS SELECT"
    lin#      = lin# + 1
    lin[lin#] = "  ".

  FOR EACH _View-col OF _View BREAK BY _Vcol-Order:
    c = _Base-col.
    IF c MATCHES "(*)" THEN c = SUBSTRING(c,2,LENGTH(c) - 2).
    IF LENGTH(lin[lin#]) + LENGTH(c) > 76 THEN ASSIGN
      lin#      = lin# + 1
      lin[lin#] = "  ".
    lin[lin#] = lin[lin#] + c.
    IF NOT LAST(_Vcol-Order) THEN lin[lin#] = lin[lin#] + ",".
  END.

  ASSIGN
    lin# = lin# + 1
    lin[lin#] = "  FROM " + _Base-Tables.

  IF _Where-Cls <> ? THEN ASSIGN
    lin# = lin# + 1
    lin[lin#] = "  WHERE " + _Where-Cls.

  IF _Group-By <> ? THEN ASSIGN
    lin# = lin# + 1
    lin[lin#] = "  " + (IF _Updatable
                THEN "WITH CHECK OPTION"
                ELSE "GROUP BY " + _Group-By).

  lin[lin#] = lin[lin#] + user_env[4]. /* statement terminator */

  DO i = 1 TO lin#:
    PUT STREAM code lin[i] FORMAT "x(" + STRING(LENGTH(lin[i])) + ")" SKIP.
  END.
  PUT STREAM code UNFORMATTED SKIP(1).

END. /* for each _View */
OUTPUT STREAM code CLOSE.
HIDE FRAME working NO-PAUSE.
SESSION:IMMEDIATE-DISPLAY = no.
MESSAGE "Output Completed" VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
RETURN.

/*
_View            _Base-Tables char         x(60)
                 _Can-Create  char         x(60)
                 _Can-Delete  char         x(60)
                 _Can-Read    char         x(60)
                 _Can-Write   char         x(60)
                 _Group-By    char         x(60)
                 _Updatable   logi         yes/no
                 _View-Def    char         x(60)
               * _View-Name   char         x(18)
                 _Where-Cls   char         x(60)

_View-Col        _Base-Col    char         x(60)
                 _Can-Create  char         x(60)
                 _Can-Write   char         x(60)
             idx _Col-Name    char         x(18)
             idx _Vcol-Order  inte         >>>9
                 _View-Name   char         x(18)
*/
