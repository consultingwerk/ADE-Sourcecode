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

/* _usrpick.p - flexible 'pick' program */
/*
pik_chosen - list of chosen element ids (was pik_choice)
pik_column - column position of frame   (0 for default)
pik_count  - number of elements in      (was pik_chextent)
pik_down   - iterations of down frame   (usually 0 for default)
pik_first  - first element out or ?     (same as pik_list[pik_chosen[1]])
pik_hide   - hide frame when done?
pik_init   - initial value to position cursor
pik_list   - list of elements in        (was pik_chlist)
pik_multi  - can pick multiple?         (was pik_multiple)
pik_number - number the elements?       (only with pik_multi)
pik_return - number of elements chosen  (was pik_chcnt)
pik_row    - row position of frame      (0 for default)
pik_skip   - use 'skip number' option   (only with pik_number)
pik_title  - title of frame             (spaces prepended and appended)
pik_wide   - use wide frame?
*/

{ prodict/user/userhue.i }
{ prodict/user/userpik.i }

/*
DEFINE VARIABLE p_mark   AS CHARACTER           INITIAL ""   NO-UNDO.
DEFINE VARIABLE p_recid  AS INTEGER             INITIAL 1    NO-UNDO.
*/
DEFINE VARIABLE p_flag   AS INTEGER EXTENT 2000 INITIAL 0    NO-UNDO.
DEFINE VARIABLE p_flag#  AS INTEGER             INITIAL 0    NO-UNDO.
DEFINE VARIABLE p_init   AS INTEGER             INITIAL ?    NO-UNDO.
DEFINE VARIABLE p_line   AS INTEGER                          NO-UNDO.
DEFINE VARIABLE p_loop   AS INTEGER                          NO-UNDO.
DEFINE VARIABLE p_redraw AS LOGICAL             INITIAL TRUE NO-UNDO.
DEFINE VARIABLE p_spot   AS INTEGER                          NO-UNDO.
DEFINE VARIABLE p_typed  AS CHARACTER           INITIAL ""   NO-UNDO.

DEFINE VARIABLE highnum  AS INTEGER NO-UNDO. /* highest number used */

/*
FORM
  p_mark            FORMAT "x(3)" NO-ATTR-SPACE SPACE(0)
  pik_list[p_recid] FORMAT "x(32)"   ATTR-SPACE SPACE(0)
  WITH FRAME pick1 SCROLL 1 OVERLAY NO-LABELS NO-ATTR-SPACE
  pik_down DOWN ROW pik_row COLUMN pik_column
  TITLE COLOR VALUE(pick-fg) pik_title.
FORM
  p_mark            FORMAT "x(3)" NO-ATTR-SPACE SPACE(0)
  pik_list[p_recid] FORMAT "x(70)"   ATTR-SPACE SPACE(0)
  WITH FRAME pick2 SCROLL 1 OVERLAY NO-LABELS NO-ATTR-SPACE
  pik_down DOWN ROW pik_row COLUMN pik_column
  TITLE COLOR VALUE(pick-fg) pik_title.
*/

/*
FORM
  p_typed FORMAT "x(35)"
  WITH FRAME type1
  OVERLAY NO-LABELS ROW pik_row + pik_down + 2 COLUMN pik_column.
FORM
  p_typed FORMAT "x(72)"
  WITH FRAME type2
  OVERLAY NO-LABELS ROW pik_row + pik_down + 2 COLUMN pik_column.
*/

IF pik_count <= 0 THEN RETURN.

ASSIGN
  pik_number = pik_number AND pik_multi
  pik_skip   = pik_skip   AND pik_number.

IF pik_skip AND pik_list[1] <> "*SKIP UP" THEN DO:
  DO p_recid = pik_count TO 1 BY -1:
    pik_list[p_recid + 2] = pik_list[p_recid].
  END.
  ASSIGN
    pik_list[1] = "*SKIP UP*"
    pik_list[2] = "*SKIP DOWN*"
    pik_count   = pik_count + 2
    nextnum     = 1.
  .
END.

IF pik_skip THEN DO:
  ASSIGN FRAME fskip:HIDDEN = no.
  IF pik_wide THEN 
    ASSIGN FRAME fskip:ROW = FRAME pick2:ROW
           FRAME fskip:COLUMN = FRAME pick2:COLUMN - FRAME fskip:WIDTH - 2.
  ELSE
    ASSIGN FRAME fskip:ROW = FRAME pick1:ROW
           FRAME fskip:COLUMN = FRAME pick1:COLUMN - FRAME fskip:WIDTH - 2.
END.
ELSE FRAME fskip:HIDDEN = yes.

ASSIGN
  pik_chosen = -1
  pik_return = 0
  pik_first  = ?
  pik_row    = (IF pik_row = 0    THEN 5 ELSE pik_row)
  pik_column = (IF pik_column = 0 THEN
               (IF pik_wide THEN 2 ELSE 42) ELSE pik_column)
  p_recid    = 1
  p_mark     = ""
  pik_down   = MINIMUM(pik_count,
               IF pik_wide THEN 12 ELSE SCREEN-LINES - 3 - pik_row).

IF pik_init <> "" THEN DO:
  DO p_spot = 1 TO pik_count:
    IF pik_init = pik_list[p_spot] THEN LEAVE.
  END.
  IF p_spot <= pik_count THEN ASSIGN
    p_init  = MINIMUM(pik_down,p_spot)
    p_recid = p_spot.
END.

_pick:
DO WHILE TRUE:

  p_recid = MINIMUM(pik_count,MAXIMUM(p_recid,1)).
  /*IF LENGTH(p_typed) > 0 THEN DO:
    PAUSE 0.
    IF pik_wide THEN
      DISPLAY p_typed WITH FRAME type2.
    ELSE
      DISPLAY p_typed WITH FRAME type1.
  END.
  ELSE DO:
    HIDE FRAME type1 NO-PAUSE.
    HIDE FRAME type2 NO-PAUSE.
  END.*/

  IF p_redraw THEN DO:
    IF pik_wide THEN
      VIEW FRAME pick2.
    ELSE
      VIEW FRAME pick1.
    ASSIGN
      p_line = MAXIMUM(1,
               IF pik_wide THEN FRAME-LINE(pick2) ELSE FRAME-LINE(pick1))
      p_spot = p_recid - (IF p_init = ? THEN p_line ELSE p_init) + 1.
    IF pik_wide THEN
      UP p_line - 1 WITH FRAME pick2.
    ELSE
      UP p_line - 1 WITH FRAME pick1.
    IF p_spot < 1 THEN ASSIGN
      p_spot  = 1
      p_line  = 1
      p_recid = 1.
    DO pik_return = p_spot TO p_spot + pik_down - 1:
      IF pik_return > pik_count THEN DO:
        IF pik_wide THEN
          CLEAR FRAME pick2 NO-PAUSE.
        ELSE
          CLEAR FRAME pick1 NO-PAUSE.
      END.
      ELSE DO:
        p_mark = (IF pik_number THEN STRING(p_flag[pik_return],">>>")
                 ELSE STRING(p_flag[pik_return] > 0,"*/ ")).
        IF highnum < INT(p_mark) THEN highnum = INT(p_mark).
        IF pik_wide THEN DISPLAY
          p_mark pik_list[pik_return] @ pik_list[p_recid] WITH FRAME pick2.
        ELSE DISPLAY
          p_mark pik_list[pik_return] @ pik_list[p_recid] WITH FRAME pick1.
      END.
      IF pik_return < p_spot + pik_down - 1 THEN
        IF pik_wide THEN
          DOWN 1 WITH FRAME pick2.
        ELSE
          DOWN 1 WITH FRAME pick1.
    END.
    p_line = (IF p_init = ? THEN p_line ELSE p_init).
    IF pik_wide THEN
      UP pik_down - p_line WITH FRAME pick2.
    ELSE
      UP pik_down - p_line WITH FRAME pick1.
    ASSIGN
      p_init     = ?
      pik_return = 0
      p_redraw   = FALSE.
  END.

  p_mark = (IF pik_number THEN STRING(p_flag[p_recid],">>>")
           ELSE STRING(p_flag[p_recid] > 0,"*/ ")).
  IF highnum < INT(p_mark) THEN highnum = INT(p_mark).
  IF pik_wide THEN
    DISPLAY p_mark pik_list[p_recid] WITH FRAME pick2.
  ELSE
    DISPLAY p_mark pik_list[p_recid] WITH FRAME pick1.

  IF pik_wide THEN
    COLOR DISPLAY VALUE(pick-bg) pik_list[p_recid] WITH FRAME pick2.
  ELSE
    COLOR DISPLAY VALUE(pick-bg) pik_list[p_recid] WITH FRAME pick1.
  READKEY.
  IF pik_wide THEN
    COLOR DISPLAY VALUE(pick-fg) pik_list[p_recid] WITH FRAME pick2.
  ELSE
    COLOR DISPLAY VALUE(pick-fg) pik_list[p_recid] WITH FRAME pick1.
  PAUSE 0.

  IF (KEYFUNCTION(LASTKEY) = CHR(LASTKEY) AND LASTKEY > 32)
    OR (KEYFUNCTION(LASTKEY) = "BACKSPACE" AND LENGTH(p_typed) > 0) THEN DO:
    p_typed = (IF KEYFUNCTION(LASTKEY) = "BACKSPACE"
              THEN SUBSTRING(p_typed,1,LENGTH(p_typed) - 1)
              ELSE p_typed + CHR(LASTKEY)).
    IF p_typed = "" OR pik_list[p_recid] BEGINS p_typed THEN NEXT.
    DO p_line = p_recid TO pik_count:
      IF pik_list[p_line] BEGINS p_typed THEN LEAVE.
    END.
    IF p_line > pik_count THEN DO:
      DO p_line = 1 TO p_recid:
        IF pik_list[p_line] BEGINS p_typed THEN LEAVE.
      END.
      IF p_line > p_recid THEN p_line = pik_count + 1.
    END.
    IF p_line > pik_count THEN DO:
      p_typed = CHR(LASTKEY).
      DO p_line = 1 TO pik_count:
        IF pik_list[p_line] BEGINS p_typed THEN LEAVE.
      END.
    END.
    p_spot = p_line - p_recid
           + (IF pik_wide THEN FRAME-LINE(pick2) ELSE FRAME-LINE(pick1)).
    IF p_line <= pik_count THEN p_recid = p_line.
    IF p_spot < 1 OR p_spot > pik_down THEN p_redraw = TRUE.
    ELSE
    IF pik_wide THEN
      UP FRAME-LINE(pick2) - p_spot WITH FRAME pick2.
    ELSE
      UP FRAME-LINE(pick1) - p_spot WITH FRAME pick1.
    NEXT.
  END.

  p_typed = "".
  IF CAN-DO("RETURN,PICK",KEYFUNCTION(LASTKEY)) AND pik_multi THEN DO:
    IF pik_skip AND pik_list[p_recid] = "*SKIP UP*" THEN DO: /* skip up by 1 */
      p_flag# = p_flag# + 1.
      DISPLAY p_flag# + 1 @ nextnum WITH FRAME fskip.
    END.
    ELSE IF pik_skip AND pik_list[p_recid] = "*SKIP DOWN*" THEN DO:
      /* skip down by 1, but stop one above the highest number used */
      highnum = 0.
      DO p_line = 1 TO pik_count: /* look for highest used */
        IF highnum < p_flag[p_line] THEN highnum = p_flag[p_line].
      END.    
      IF p_flag#  > highnum THEN DO:  
        p_flag# = p_flag# - 1. /* decrement */
        DISPLAY p_flag# + 1 @ nextnum WITH FRAME fskip.
      END.
    END.
    ELSE /* flagging an item */
    IF NOT pik_number OR p_flag[p_recid] = 0 THEN DO:
      ASSIGN
        p_flag#         = p_flag# + (IF p_flag[p_recid] = 0 THEN 1 ELSE 0)
        p_flag[p_recid] = (IF p_flag[p_recid] = 0 THEN p_flag# ELSE 0).
      p_mark = (IF pik_number THEN STRING(p_flag[p_recid],">>>")
               ELSE STRING(p_flag[p_recid] > 0,"*/ ")).
      IF pik_skip THEN DISPLAY p_flag# + 1 @ nextnum WITH FRAME fskip.
      IF pik_wide THEN
        DISPLAY p_mark WITH FRAME pick2.
      ELSE
        DISPLAY p_mark WITH FRAME pick1.
    END.
    ELSE DO: /* if turning off and pik_number, then must renumber others */
      DO p_line = 1 TO pik_count:
        IF p_flag[p_line] > p_flag[p_recid] THEN
          p_flag[p_line] = p_flag[p_line] - 1.
      END.
      ASSIGN
        p_flag[p_recid] = 0
        p_flag#         = p_flag# - 1
        p_spot = (IF pik_wide THEN FRAME-LINE(pick2) ELSE FRAME-LINE(pick1)).
      IF pik_skip THEN DISPLAY p_flag# + 1 @ nextnum WITH FRAME fskip.
      IF pik_wide THEN
        UP p_spot - 1 WITH FRAME pick2.
      ELSE
        UP p_spot - 1 WITH FRAME pick1.
      DO p_line = 1 TO pik_down:
        ASSIGN
          p_init = p_recid - p_spot + p_line
          p_mark = (IF pik_number THEN STRING(p_flag[p_init],">>>")
                   ELSE STRING(p_flag[p_init] > 0,"*/ ")).
        IF pik_wide THEN DISPLAY
          p_mark WHEN p_mark <> INPUT FRAME pick2 p_mark WITH FRAME pick2.
        ELSE DISPLAY
          p_mark WHEN p_mark <> INPUT FRAME pick1 p_mark WITH FRAME pick1.
        IF pik_wide THEN
          DOWN WITH FRAME pick2.
        ELSE
          DOWN WITH FRAME pick1.
      END.
      p_init = ?.
      IF pik_wide THEN
        UP FRAME-LINE(pick2) - p_spot WITH FRAME pick2.
      ELSE
        UP FRAME-LINE(pick1) - p_spot WITH FRAME pick1.
    END.
    PAUSE 0.
    IF pik_skip AND (pik_list[p_recid] = "*SKIP UP*" OR 
                     pik_list[p_recid] = "*SKIP DOWN*") THEN .
    ELSE
    IF p_recid < pik_count THEN DO:
      p_recid = p_recid + 1.
      IF pik_wide THEN
        IF FRAME-LINE(pick2) = FRAME-DOWN(pick2) THEN
          SCROLL UP WITH FRAME pick2.
        ELSE
          DOWN WITH FRAME pick2.
      ELSE
        IF FRAME-LINE(pick1) = FRAME-DOWN(pick1) THEN
          SCROLL UP WITH FRAME pick1.
        ELSE
          DOWN WITH FRAME pick1.
    END.
  END.
  ELSE
  IF CAN-DO("CURSOR-DOWN,TAB, ",KEYFUNCTION(LASTKEY))
    AND p_recid < pik_count THEN DO:
    p_recid = p_recid + 1.
    IF pik_wide THEN
      IF FRAME-LINE(pick2) = FRAME-DOWN(pick2) THEN
        SCROLL UP WITH FRAME pick2.
      ELSE
        DOWN WITH FRAME pick2.
    ELSE
      IF FRAME-LINE(pick1) = FRAME-DOWN(pick1) THEN
        SCROLL UP WITH FRAME pick1.
      ELSE
        DOWN WITH FRAME pick1.
  END.
  ELSE
  IF CAN-DO("CURSOR-UP,BACK-TAB",KEYFUNCTION(LASTKEY)) AND p_recid > 1 THEN DO:
    p_recid = p_recid - 1.
    IF pik_wide THEN
      IF FRAME-LINE(pick2) = 1 THEN
        SCROLL DOWN WITH FRAME pick2.
      ELSE
        UP WITH FRAME pick2.
    ELSE
      IF FRAME-LINE(pick1) = 1 THEN
        SCROLL DOWN WITH FRAME pick1.
      ELSE
        UP WITH FRAME pick1.
  END.
  ELSE
  IF KEYFUNCTION(LASTKEY) = "PAGE-DOWN" THEN ASSIGN
    p_recid  = p_recid + pik_down
    p_redraw = TRUE.
  ELSE
  IF KEYFUNCTION(LASTKEY) = "PAGE-UP" THEN ASSIGN
    p_recid  = p_recid - pik_down
    p_redraw = TRUE.
  ELSE
  IF CAN-DO("HOME,MOVE",KEYFUNCTION(LASTKEY)) AND p_recid > 1 THEN DO:
    ASSIGN
      p_recid  = 1
      p_redraw = TRUE.
    IF pik_wide THEN
      UP FRAME-LINE(pick2) - 1 WITH FRAME pick2.
    ELSE
      UP FRAME-LINE(pick1) - 1 WITH FRAME pick1.
  END.
  ELSE
  IF CAN-DO("END,HOME,MOVE",KEYFUNCTION(LASTKEY)) THEN DO:
    ASSIGN
      p_recid  = pik_count
      p_redraw = TRUE.
    IF pik_wide THEN
      DOWN pik_down - FRAME-LINE(pick2) WITH FRAME pick2.
    ELSE
      DOWN pik_down - FRAME-LINE(pick1) WITH FRAME pick1.
  END.
  ELSE
  IF KEYFUNCTION(LASTKEY) = "GO"
    AND pik_skip AND pik_list[p_recid] = "*SKIP*" THEN DO:
    ASSIGN
      p_flag   = 0
      p_flag#  = 0
      p_recid  = 1
      p_redraw = TRUE.
    IF pik_wide THEN
      UP FRAME-LINE(pick2) - 1 WITH FRAME pick2.
    ELSE
      UP FRAME-LINE(pick1) - 1 WITH FRAME pick1.
  END.
  ELSE
  IF CAN-DO("GO,RETURN",KEYFUNCTION(LASTKEY)) THEN DO:
    ASSIGN
      pik_return = (IF pik_multi THEN 0 ELSE 1)
      pik_chosen = (IF pik_multi THEN -1 ELSE p_recid).
    DO p_recid = 1 TO pik_count:
      IF p_flag[p_recid] > 0 THEN ASSIGN
        pik_return = pik_return + 1
        pik_chosen[IF pik_number THEN p_flag[p_recid] ELSE pik_return]
          = p_recid.
    END.
    pik_first = (IF pik_return > 0 AND pik_chosen[1] > 0
                 THEN pik_list[pik_chosen[1]] ELSE ?).
    IF pik_skip THEN pik_return = p_flag#.
    LEAVE _pick.
  END.
  ELSE
  IF CAN-DO("GET,END-ERROR",KEYFUNCTION(LASTKEY)) THEN LEAVE _pick.

  p_line = 1.
END.

ASSIGN
  pik_row    = 0
  pik_column = 0
  pik_title  = ""
  pik_init   = "".
IF pik_wide THEN
  UP FRAME-LINE(pick2) - 1 WITH FRAME pick2.
ELSE
  UP FRAME-LINE(pick1) - 1 WITH FRAME pick1.
IF pik_hide THEN DO:
  /* CLEAR FRAME pick1 ALL NO-PAUSE.
  CLEAR FRAME pick2 ALL NO-PAUSE. */
  HIDE FRAME pick1 NO-PAUSE.
  HIDE FRAME pick2 NO-PAUSE.
  HIDE FRAME fskip NO-PAUSE.
END.
/*HIDE FRAME type1 NO-PAUSE.
HIDE FRAME type2 NO-PAUSE.*/
RETURN.
