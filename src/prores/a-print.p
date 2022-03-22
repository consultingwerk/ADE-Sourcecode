/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* a-print.p - manage output devices */

{ prores/s-system.i }
{ prores/s-print.i }
{ prores/t-define.i }

DEFINE VARIABLE qbf-a AS LOGICAL                           NO-UNDO.
DEFINE VARIABLE qbf-c AS CHARACTER                         NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER                           NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER                           NO-UNDO.
DEFINE VARIABLE qbf-m AS CHARACTER EXTENT  8 FORMAT "x(3)" NO-UNDO.
DEFINE VARIABLE qbf-p AS CHARACTER EXTENT  4               NO-UNDO.
DEFINE VARIABLE qbf-v AS CHARACTER                         NO-UNDO.
DEFINE VARIABLE qbf-y AS CHARACTER EXTENT 72 FORMAT "x(3)" NO-UNDO.
DEFINE VARIABLE qbf-z AS CHARACTER EXTENT  6               NO-UNDO.

DEFINE NEW SHARED VARIABLE qbf-t AS CHARACTER EXTENT 8 NO-UNDO.

{ prores/a-edit.i NEW } /* needs qbf-m[1..6] and qbf-y[1..72] defined */

FORM
  qbf-lang[17]               FORMAT "x(16)" SPACE(0) ":"
    qbf-printer[qbf-device]  FORMAT "x(32)" ATTR-SPACE SKIP
  qbf-lang[18]               FORMAT "x(16)" SPACE(0) ":"
    qbf-pr-dev[qbf-device]   FORMAT "x(40)" ATTR-SPACE SKIP
  qbf-lang[19]               FORMAT "x(16)" SPACE(0) ":"
    qbf-pr-width[qbf-device] FORMAT ">>9"   ATTR-SPACE SKIP
  qbf-lang[20]               FORMAT "x(16)" SPACE(0) ":"
    qbf-pr-type[qbf-device]  FORMAT "x(4)"  ATTR-SPACE
    qbf-lang[21] FORMAT "x(32)" SKIP /* "see below" */
  WITH FRAME qbf-print NO-ATTR-SPACE NO-LABELS OVERLAY ROW 10 COLUMN 2 NO-BOX.
FORM
  qbf-pr-width[qbf-device]
    VALIDATE(qbf-pr-width[qbf-device] > 0 AND qbf-pr-width[qbf-device] <= 255,
    qbf-lang[9])
  qbf-pr-type[qbf-device]
    VALIDATE(CAN-DO("term,to,view,file,page,prog"
    + (IF CAN-DO("OS2,UNIX",OPSYS) THEN ",thru" ELSE ""),
    qbf-pr-type[qbf-device]),qbf-lang[10])
  WITH FRAME qbf-print.
/* VALIDATE: "Must be less than 256 but greater than 0" */
/* VALIDATE: "Type must be one of term, thru, to, view, file, page or prog" */

FORM
  /*  term = TERMINAL, as in OUTPUT TO TERMINAL PAGED              */
  /*  to   = TO a device, such as OUTPUT TO PRINTER                */
  /*  thru = THROUGH a UNIX or OS/2 spooler or filter              */
  /*  view = Send the report to a file, then execute this program  */
  /*  file = Ask the user for a filename for the output destination*/
  /*  page = To screen with prev-page and next-page                */
  /*  prog = Call a 4GL program to start/end output stream         */
  "  term =" qbf-lang[22] FORMAT "x(69)" SKIP
  "  to   =" qbf-lang[23] FORMAT "x(69)" SKIP
  "  thru =" qbf-lang[24] FORMAT "x(69)" SKIP
  "  view =" qbf-lang[25] FORMAT "x(69)" SKIP
  "  file =" qbf-lang[26] FORMAT "x(69)" SKIP
  "  page =" qbf-lang[27] FORMAT "x(69)" SKIP
  "  prog =" qbf-lang[28] FORMAT "x(69)" SKIP
  WITH FRAME qbf-help ROW 14 COLUMN 2 NO-BOX NO-ATTR-SPACE NO-LABELS OVERLAY.

FORM
  /*1:"    *                   - All users are allowed access."              */
  /*2:"    <user>,<user>,etc.  - Only these users have access."              */
  /*3:"    !<user>,!<user>,*   - All except these users have access."        */
  /*4:"    acct*               - Only users that begin with ~"acct~" allowed"*/
  /*5:"List users by their login IDs, and separate them with commas."        */
  /*6:"IDs may contain wildcards.  Use exclamation marks to exclude users."  */
  qbf-p[1] FORMAT "x(76)" SKIP
  qbf-p[2] FORMAT "x(76)" SKIP
  qbf-p[3] FORMAT "x(76)" SKIP
  qbf-p[4] FORMAT "x(76)" SKIP
  qbf-z[1] FORMAT "x(78)" NO-ATTR-SPACE SKIP
  qbf-z[2] FORMAT "x(78)" NO-ATTR-SPACE SKIP
  qbf-z[3] FORMAT "x(78)" NO-ATTR-SPACE SKIP
  qbf-z[4] FORMAT "x(78)" NO-ATTR-SPACE SKIP
  qbf-z[5] FORMAT "x(78)" NO-ATTR-SPACE SKIP
  qbf-z[6] FORMAT "x(78)" NO-ATTR-SPACE SKIP
  WITH FRAME qbf-perm ROW 11 COLUMN 2 NO-BOX ATTR-SPACE NO-LABELS OVERLAY.

{ prores/t-set.i &mod=a &set=5 }
ASSIGN
  qbf-z[1] = qbf-lang[ 2]  /* can-do and permissions explanation */
  qbf-z[2] = qbf-lang[ 3]
  qbf-z[3] = qbf-lang[ 4]
  qbf-z[4] = qbf-lang[ 5]
  qbf-z[5] = qbf-lang[ 6]
  qbf-z[6] = qbf-lang[ 7]
  qbf-t[1] = qbf-lang[21]  /*'  Initialization'*/
  qbf-t[2] = qbf-lang[22]  /*'                '*/
  qbf-t[3] = qbf-lang[23]  /*'    Normal Print'*/
  qbf-t[4] = qbf-lang[24]  /*'      Compressed'*/
  qbf-t[5] = qbf-lang[25]  /*'        Bold  ON'*/
  qbf-t[6] = qbf-lang[26]. /*'        Bold OFF'*/
{ prores/t-set.i &mod=a &set=10 }
ASSIGN
  qbf-t[7] = qbf-lang[17]  /*'Desc for listing'*/
  qbf-t[8] = qbf-lang[18]. /*'     Device name'*/

/*
  " A. Add New Output Device "
  " C. Choose Device To Edit "
  " G. General Device Characteristics "
  " S. Control Sequences  "
  " P. Printer Permissions "
  " D. Delete Current Device "
*/
DISPLAY
  qbf-lang[7]           @ qbf-p[1] FORMAT "x(10)" /*"Select:"*/
            qbf-lang[1] @ qbf-m[1] FORMAT "x(45)" SKIP /*Add*/
  SPACE(13) qbf-lang[2] @ qbf-m[2] FORMAT "x(45)" SKIP /*Choose*/
  qbf-lang[8]           @ qbf-p[2] FORMAT "x(10)" /*"Update:"*/
            qbf-lang[3] @ qbf-m[3] FORMAT "x(45)" SKIP /*General*/
  SPACE(13) qbf-lang[4] @ qbf-m[4] FORMAT "x(45)" SKIP /*Control*/
  SPACE(13) qbf-lang[5] @ qbf-m[5] FORMAT "x(45)" SKIP /*Perms*/
  SPACE(13) qbf-lang[6] @ qbf-m[6] FORMAT "x(45)" SKIP /*Delete*/
  WITH FRAME qbf-menu ROW 3 COLUMN 2 NO-BOX ATTR-SPACE NO-LABELS OVERLAY.
COLOR DISPLAY MESSAGES qbf-p[1 FOR 2] WITH FRAME qbf-menu.

DISPLAY qbf-lang[17 FOR 4] "(" + qbf-lang[21] + ")" @ qbf-lang[21]
  WITH FRAME qbf-print.
DISPLAY qbf-lang[22 FOR 7] WITH FRAME qbf-help.
ON CURSOR-UP BACK-TAB. ON CURSOR-DOWN TAB.

DO WHILE TRUE ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
  DISPLAY
    qbf-printer[qbf-device]
    qbf-pr-dev[qbf-device]
    qbf-pr-width[qbf-device]
    qbf-pr-type[qbf-device]
    WITH FRAME qbf-print.
  qbf-i = 0.
  STATUS DEFAULT qbf-lang[30]. /*Press [END-ERROR] when done updating*/
  CHOOSE FIELD qbf-m[1 FOR 6] AUTO-RETURN WITH FRAME qbf-menu.
  STATUS DEFAULT.
  qbf-i = FRAME-INDEX.
  IF qbf-i = 0 THEN UNDO,RETRY.
  ON CURSOR-UP CURSOR-UP. ON CURSOR-DOWN CURSOR-DOWN.

  IF qbf-i = 1 THEN DO: /* Add New Output Device */
    qbf-device = qbf-printer#.
    IF qbf-printer# = { prores/s-limprn.i } THEN
      /*Maximum number of output devices has been reached.*/
      RUN prores/s-error.p ("#11").
    ELSE
      ASSIGN
        qbf-device               = qbf-printer# + 1
        qbf-printer[qbf-device]  = ""
        qbf-pr-perm[qbf-device]  = "*"
        qbf-pr-dev[qbf-device]   = ""
        qbf-pr-boff[qbf-device]  = ""
        qbf-pr-bon[qbf-device]   = ""
        qbf-pr-comp[qbf-device]  = ""
        qbf-pr-init[qbf-device]  = ""
        qbf-pr-norm[qbf-device]  = ""
        qbf-pr-width[qbf-device] = 80
        qbf-pr-type[qbf-device]  = "to".
  END.
  ELSE
  IF qbf-i = 2 THEN DO: /* Choose Device To Edit */
    RUN prores/c-print.p (OUTPUT qbf-a).
    IF NOT qbf-a THEN UNDO,RETRY.
    IF qbf-pr-perm[qbf-device] = "" THEN 
      qbf-pr-perm[qbf-device] = "*".
    IF qbf-pr-width[qbf-device] = 0 THEN 
      qbf-pr-width[qbf-device] = 80.
    DISPLAY
      qbf-printer[qbf-device]
      qbf-pr-dev[qbf-device]
      qbf-pr-width[qbf-device]
      qbf-pr-type[qbf-device]
      WITH FRAME qbf-print.
  END.
  /* no ELSE here! */
  IF qbf-i <= 3 THEN DO: /* General Device Characteristics */
    COLOR DISPLAY NORMAL qbf-m[1 FOR 2] WITH FRAME qbf-menu.
    COLOR DISPLAY MESSAGES qbf-m[3] WITH FRAME qbf-menu.
    NEXT-PROMPT qbf-m[3] WITH FRAME qbf-menu.
    VIEW FRAME qbf-help.
    DISPLAY "(" + qbf-lang[21] + ")" @ qbf-lang[21] WITH FRAME qbf-print.
    HIDE FRAME qbf-ctrl NO-PAUSE.
    HIDE FRAME qbf-perm NO-PAUSE.
    DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
      SET
        qbf-printer[qbf-device]
        qbf-pr-dev[qbf-device]
        qbf-pr-width[qbf-device]
        qbf-pr-type[qbf-device]
        WITH FRAME qbf-print.
      qbf-c = qbf-pr-dev[qbf-device].
      IF KEYWORD(qbf-c) = "TERMINAL"
        OR (qbf-pr-type[qbf-device] = "term" AND qbf-c = "")
        THEN qbf-c = "TERMINAL".
      IF qbf-c = "TERMINAL" AND qbf-pr-type[qbf-device] <> "term" THEN DO:
        /*Only device type "term" can output to TERMINAL.*/
        RUN prores/s-error.p ("#12").
        UNDO,RETRY.
      END.
      IF qbf-pr-type[qbf-device] = "prog" THEN DO:
        IF qbf-c MATCHES "*~~.p" THEN SUBSTRING(qbf-c,LENGTH(qbf-c),1) = "r".
        qbf-v = SEARCH(qbf-c).
        IF qbf-v = ? THEN
          qbf-v = SEARCH(SUBSTRING(qbf-c,1,LENGTH(qbf-c) - 1) + "p").
        IF qbf-v = ? THEN DO:
          /*Could not find that program name with current PROPATH.*/
          RUN prores/s-error.p ("#13").
          UNDO,RETRY.
        END.
        qbf-c = SUBSTRING(qbf-c,1,LENGTH(qbf-c) - 1) + "p".
      END.
      qbf-pr-dev[qbf-device] = qbf-c.
      IF qbf-device > qbf-printer# THEN qbf-printer# = qbf-device.
    END.
    COLOR DISPLAY NORMAL qbf-m[3] WITH FRAME qbf-menu.
  END.
  ELSE
  IF qbf-i = 4 THEN DO: /* Control Sequences */
    HIDE FRAME qbf-help NO-PAUSE.
    HIDE FRAME qbf-perm NO-PAUSE.
    DISPLAY "" @ qbf-lang[21] WITH FRAME qbf-print.
    RUN prores/a-edit.p.
  END.
  ELSE
  IF qbf-i = 5 THEN DO: /* Printer Permissions */
    HIDE FRAME qbf-ctrl NO-PAUSE.
    HIDE FRAME qbf-help NO-PAUSE.
    DISPLAY "" @ qbf-lang[21] WITH FRAME qbf-print.
    PAUSE 0.
    ASSIGN
      qbf-p[1] = qbf-pr-perm[qbf-device]
      qbf-p[2] = ""
      qbf-p[3] = ""
      qbf-p[4] = "".
    DO qbf-j = 1 TO 3 WHILE LENGTH(qbf-p[qbf-j]) > 76:
      DO qbf-i = 76 TO 1 BY -1
        WHILE SUBSTRING(qbf-p[qbf-j],qbf-i,1) <> ",":
      END.
      ASSIGN
        qbf-i            = (IF qbf-i = 0 THEN 76 ELSE qbf-i)
        qbf-p[qbf-j + 1] = SUBSTRING(qbf-p[qbf-j],qbf-i + 1)
        qbf-p[qbf-j    ] = SUBSTRING(qbf-p[qbf-j],1,qbf-i).
    END.
    DISPLAY qbf-z[1 FOR 6] WITH FRAME qbf-perm.
    DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE WITH FRAME qbf-perm:
      UPDATE qbf-p[1] qbf-p[2] qbf-p[3] qbf-p[4].
      IF qbf-p[2] <> "" AND NOT qbf-p[1] MATCHES "*," THEN
        qbf-p[1] = qbf-p[1] + ",".
      IF qbf-p[3] <> "" AND NOT qbf-p[2] MATCHES "*," THEN
        qbf-p[2] = qbf-p[2] + ",".
      IF qbf-p[4] <> "" AND NOT qbf-p[3] MATCHES "*," THEN
        qbf-p[3] = qbf-p[3] + ",".
      qbf-c = qbf-p[1] + qbf-p[2] + qbf-p[3] + qbf-p[4].
      IF qbf-c MATCHES "*," THEN qbf-c = SUBSTRING(qbf-c,1,LENGTH(qbf-c) - 1).
      qbf-pr-perm[qbf-device] = qbf-c.
    END.
    HIDE FRAME qbf-perm NO-PAUSE.
    VIEW FRAME qbf-help.
  END.
  ELSE
  IF qbf-i = 6 THEN DO: /* Delete Current Device */
    IF qbf-printer# = 0 THEN UNDO,RETRY.
    IF qbf-printer# = 1 THEN DO:
      /*There must be at least one output device!*/
      RUN prores/s-error.p ("#31").
      UNDO,RETRY.
    END.
    qbf-a = FALSE.
    RUN prores/s-box.p (INPUT-OUTPUT qbf-a,?,?,"#32").
    /*Are you sure that you want to delete this printer?*/
    IF qbf-a THEN DO:
      DO qbf-i = qbf-device TO qbf-printer#:
        ASSIGN
          qbf-printer[qbf-i]  = qbf-printer[qbf-i + 1]
          qbf-pr-perm[qbf-i]  = qbf-pr-perm[qbf-i + 1]
          qbf-pr-dev[qbf-i]   = qbf-pr-dev[qbf-i + 1]
          qbf-pr-boff[qbf-i]  = qbf-pr-boff[qbf-i + 1]
          qbf-pr-bon[qbf-i]   = qbf-pr-bon[qbf-i + 1]
          qbf-pr-comp[qbf-i]  = qbf-pr-comp[qbf-i + 1]
          qbf-pr-init[qbf-i]  = qbf-pr-init[qbf-i + 1]
          qbf-pr-norm[qbf-i]  = qbf-pr-norm[qbf-i + 1]
          qbf-pr-width[qbf-i] = qbf-pr-width[qbf-i + 1]
          qbf-pr-type[qbf-i]  = qbf-pr-type[qbf-i + 1].
      END.
      ASSIGN
        qbf-printer# = qbf-printer# - 1
        qbf-device   = MINIMUM(qbf-device,qbf-printer#).
    END.
  END.
  ON CURSOR-UP BACK-TAB. ON CURSOR-DOWN TAB.

END.

ON CURSOR-UP CURSOR-UP. ON CURSOR-DOWN CURSOR-DOWN.
HIDE FRAME qbf-ctrl  NO-PAUSE.
HIDE FRAME qbf-help  NO-PAUSE.
HIDE FRAME qbf-menu  NO-PAUSE.
HIDE FRAME qbf-perm  NO-PAUSE.
HIDE FRAME qbf-print NO-PAUSE.
HIDE MESSAGE NO-PAUSE.
STATUS DEFAULT.
RETURN.
