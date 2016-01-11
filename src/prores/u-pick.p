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
/* u-pick.p - scrolling list using comma-sep-list as argument */

/* part of a set comprised of u-dump.p u-load.p u-pick.p u-used.p */

/* Returns the selected file name from the list */
DEFINE OUTPUT PARAMETER qbf-o AS CHARACTER INITIAL "" NO-UNDO.

/* Cache the list for faster scrolling.  The 128 limit is arbitrary. */
DEFINE VARIABLE qbf-list  AS CHARACTER EXTENT 128 NO-UNDO.
DEFINE VARIABLE qbf-list# AS INTEGER   INITIAL  0 NO-UNDO.

/*local:*/
DEFINE VARIABLE qbf-d AS INTEGER                NO-UNDO. /* down-frame */
DEFINE VARIABLE qbf-i AS INTEGER                NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-l AS INTEGER                NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-r AS INTEGER                NO-UNDO. /* array pointer */
DEFINE VARIABLE qbf-s AS INTEGER                NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-t AS CHARACTER INITIAL   "" NO-UNDO. /* type-search text */
DEFINE VARIABLE qbf-w AS LOGICAL   INITIAL TRUE NO-UNDO. /* redraw flag */

/*forms:*/
FORM
  qbf-t FORMAT "x(32)"
  WITH FRAME qbf-pick SCROLL 1 OVERLAY NO-LABELS ATTR-SPACE
  qbf-d DOWN ROW 5 COLUMN 22
  TITLE COLOR NORMAL " File for Storing Report ".

FORM
  qbf-t FORMAT "x(32)"
  WITH FRAME qbf-type OVERLAY NO-LABELS ATTR-SPACE
  ROW qbf-d + 7 COLUMN 22.

ASSIGN
  qbf-list#           = 1
  qbf-list[qbf-list#] = "<<create new file>>".

/* Include first 128 files in database which are dbtype "progress" */
/* and not hidden. */
FIND RESULTSDB._Db WHERE RESULTSDB._Db._Db-name = ?.
FOR EACH RESULTSDB._File OF RESULTSDB._Db WHERE NOT RESULTSDB._File._Hidden
  BY RESULTSDB._File._File-name
  WHILE qbf-list# < 128:
  
  /* filter out sql92 tables and views */
  IF INTEGER(DBVERSION("RESULTSDB":U)) > 8 THEN
    IF (RESULTSDB._File._Owner <> "PUB":U AND RESULTSDB._File._Owner <> "_FOREIGN":U)
    THEN NEXT.
      
  ASSIGN
    qbf-list#           = qbf-list# + 1
    qbf-list[qbf-list#] = RESULTSDB._File._File-name.
END.

ASSIGN
  qbf-r = 1
  qbf-d = MINIMUM(qbf-list#,SCREEN-LINES - 11).

PAUSE 0 BEFORE-HIDE.
VIEW FRAME qbf-pick.

DO WHILE TRUE:

  /* make sure pointer not off end of list */
  qbf-r = MINIMUM(qbf-list#,MAXIMUM(qbf-r,1)).
  IF qbf-r < FRAME-LINE(qbf-pick) THEN
    DOWN qbf-r - FRAME-LINE(qbf-pick) WITH FRAME qbf-pick.

  /* if any type-search, the display type-search frame */
  IF LENGTH(qbf-t) > 0 THEN
    DISPLAY qbf-t WITH FRAME qbf-type.
  ELSE
    HIDE FRAME qbf-type NO-PAUSE.

  /* this is frame redraw logic. */
  IF qbf-w THEN DO:
    ASSIGN
      qbf-l = MAXIMUM(1,FRAME-LINE(qbf-pick))
      qbf-s = qbf-r - qbf-l + 1
      qbf-w  = FALSE.
    UP qbf-l - 1 WITH FRAME qbf-pick.
    IF qbf-s < 1 THEN
      ASSIGN
        qbf-s = 1
        qbf-l = 1
        qbf-r = 1.
    DO qbf-i = qbf-s TO qbf-s + qbf-d - 1:
      IF qbf-i > qbf-list# THEN
        CLEAR FRAME qbf-pick NO-PAUSE.
      ELSE
        DISPLAY qbf-list[qbf-i] @ qbf-t WITH FRAME qbf-pick.
      IF qbf-i < qbf-s + qbf-d - 1 THEN DOWN 1 WITH FRAME qbf-pick.
    END.
    UP qbf-d - qbf-l WITH FRAME qbf-pick.
  END.

  DISPLAY qbf-list[qbf-r] @ qbf-t WITH FRAME qbf-pick.

  /* highlight current entry, read keystroke, un-highlight. */
  COLOR DISPLAY MESSAGES qbf-t WITH FRAME qbf-pick.
  READKEY.
  COLOR DISPLAY NORMAL   qbf-t WITH FRAME qbf-pick.

  /* Handle type-search.  Look from current position to end-of-list,     */
  /* then from top-of-list to current position, until found.  If not     */
  /* found, delete any previous text typed from the search-string and    */
  /* then try again, with just the most recent character typed.  If      */
  /* found, then this last character becomes the new type-search string. */
  IF (KEYFUNCTION(LASTKEY) = CHR(LASTKEY) AND LASTKEY >= 32)
    OR (KEYFUNCTION(LASTKEY) = "BACKSPACE" AND LENGTH(qbf-t) > 0) THEN DO:
    qbf-t = (IF KEYFUNCTION(LASTKEY) = "BACKSPACE"
            THEN SUBSTRING(qbf-t,1,LENGTH(qbf-t) - 1)
            ELSE qbf-t + CHR(LASTKEY)).
    IF qbf-t = "" OR qbf-list[qbf-r] BEGINS qbf-t THEN NEXT.
    DO qbf-l = qbf-r TO qbf-list#:
      IF qbf-list[qbf-l] BEGINS qbf-t THEN LEAVE.
    END.
    IF qbf-l > qbf-list# THEN DO:
      DO qbf-l = 1 TO qbf-r:
        IF qbf-list[qbf-l] BEGINS qbf-t THEN LEAVE.
      END.
      IF qbf-l > qbf-r THEN qbf-l = qbf-list# + 1.
    END.
    IF qbf-l > qbf-list# THEN DO:
      qbf-t = CHR(LASTKEY).
      DO qbf-l = 1 TO qbf-list#:
        IF qbf-list[qbf-l] BEGINS qbf-t THEN LEAVE.
      END.
    END.
    ASSIGN
      qbf-l = (IF qbf-l <= qbf-list# THEN qbf-l ELSE qbf-r)
      qbf-s = qbf-l - qbf-r + FRAME-LINE(qbf-pick)
      qbf-r = qbf-l.
    IF qbf-s < 1 OR qbf-s > qbf-d THEN
      qbf-w = TRUE.
    ELSE
      UP FRAME-LINE(qbf-pick) - qbf-s WITH FRAME qbf-pick.
    NEXT.
  END.

  /* Any cursor-motion keys reset the type-search string */
  qbf-t = "".

  IF CAN-DO("CURSOR-DOWN,TAB",KEYFUNCTION(LASTKEY))
    AND qbf-r < qbf-list# THEN DO:
    qbf-r = qbf-r + 1.
    IF FRAME-LINE(qbf-pick) = FRAME-DOWN(qbf-pick) THEN
      SCROLL UP WITH FRAME qbf-pick.
    ELSE
      DOWN WITH FRAME qbf-pick.
  END.
  ELSE
  IF CAN-DO("CURSOR-UP,BACK-TAB",KEYFUNCTION(LASTKEY)) AND qbf-r > 1 THEN DO:
    qbf-r = qbf-r - 1.
    IF FRAME-LINE(qbf-pick) = 1 THEN
      SCROLL DOWN WITH FRAME qbf-pick.
    ELSE
      UP WITH FRAME qbf-pick.
  END.
  ELSE
  IF KEYFUNCTION(LASTKEY) = "PAGE-DOWN" THEN DO:
    ASSIGN
      qbf-r = qbf-r + qbf-d
      qbf-w = TRUE.
    IF qbf-r + qbf-d - FRAME-LINE(qbf-pick) > qbf-list# THEN DO:
      qbf-r = qbf-list#.
      DOWN MINIMUM(qbf-list#,qbf-d) - FRAME-LINE(qbf-pick)
        WITH FRAME qbf-pick.
    END.
  END.
  ELSE
  IF KEYFUNCTION(LASTKEY) = "PAGE-UP" THEN
    ASSIGN
      qbf-r = qbf-r - qbf-d
      qbf-w = TRUE.
  ELSE
  IF CAN-DO("HOME,MOVE",KEYFUNCTION(LASTKEY)) THEN DO:
    /* if at first position in file, [home] key moves to end, else to home. */
    IF qbf-r > 1 THEN
      UP FRAME-LINE(qbf-pick) - 1 WITH FRAME qbf-pick.
    ELSE
      DOWN qbf-d - FRAME-LINE(qbf-pick) WITH FRAME qbf-pick.
    ASSIGN
      qbf-r = (IF qbf-r = 1 THEN qbf-list# ELSE 1)
      qbf-w = TRUE.
  END.
  ELSE
  IF CAN-DO("GO,RETURN,END-ERROR",KEYFUNCTION(LASTKEY)) THEN DO:
    IF KEYFUNCTION(LASTKEY) <> "END-ERROR" THEN qbf-o = qbf-list[qbf-r].
    LEAVE.
  END.

END.

HIDE FRAME qbf-pick NO-PAUSE.
HIDE FRAME qbf-type NO-PAUSE.
PAUSE BEFORE-HIDE.

RETURN.
