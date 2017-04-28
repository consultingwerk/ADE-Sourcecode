/*********************************************************************
* Copyright (C) 2000,2016 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* _usrfixd.p

pik_count  - number of elements in      (was pik_chextent)
pik_list   - list of elements in        (was pik_chlist)
pik_lower  - lower values for list of elements
pik_upper  - upper values for list of elements
*/

/*input:*/
DEFINE SHARED VARIABLE pik_count AS INTEGER               NO-UNDO.
DEFINE SHARED VARIABLE pik_list  AS CHARACTER EXTENT 4000 NO-UNDO.

/*output:*/
DEFINE SHARED VARIABLE pik_lower AS INTEGER   EXTENT 4000 NO-UNDO.
DEFINE SHARED VARIABLE pik_upper AS INTEGER   EXTENT 4000 NO-UNDO.

/*local:*/
DEFINE        VARIABLE p_flow    AS INTEGER               NO-UNDO.
DEFINE        VARIABLE p_down    AS INTEGER               NO-UNDO.
DEFINE        VARIABLE p_recid   AS INTEGER INITIAL     1 NO-UNDO.
DEFINE        VARIABLE p_init    AS INTEGER INITIAL     ? NO-UNDO.
DEFINE        VARIABLE p_line    AS INTEGER               NO-UNDO.
DEFINE        VARIABLE p_loop    AS INTEGER               NO-UNDO.
DEFINE        VARIABLE p_redraw  AS LOGICAL INITIAL  TRUE NO-UNDO.
DEFINE        VARIABLE p_spot    AS INTEGER               NO-UNDO.
DEFINE        VARIABLE i         AS INTEGER               NO-UNDO.

/*frame:*/
FORM
  pik_list[p_recid] FORMAT "x(32)"
  pik_lower[p_recid] FORMAT ">>>>>"
  pik_upper[p_recid] FORMAT ">>>>>"
  WITH FRAME pick SCROLL 1 NO-LABELS ATTR-SPACE
  p_down DOWN ROW 3 CENTERED
  TITLE "Fixed-Length Field Columns". 

IF pik_count <= 0 THEN RETURN.

ASSIGN
  p_recid = 1
  p_down  = MINIMUM(pik_count,SCREEN-LINES - 8).

DO WHILE TRUE WITH FRAME pick:

  p_recid = MINIMUM(pik_count,MAXIMUM(p_recid,1)).

  IF p_redraw THEN DO:
    ASSIGN
      p_line = MAXIMUM(1,FRAME-LINE)
      p_spot = p_recid - (IF p_init = ? THEN p_line ELSE p_init) + 1.
    UP p_line - 1.
    IF p_spot < 1 THEN ASSIGN
      p_spot  = 1
      p_line  = 1
      p_recid = 1.
    DO p_flow = p_spot TO p_spot + p_down - 1:
      IF p_flow > pik_count THEN DO:
        CLEAR NO-PAUSE.
      END.
      ELSE DO:
        DISPLAY
          pik_list[p_flow]  @ pik_list[p_recid]
          pik_lower[p_flow] @ pik_lower[p_recid]
          pik_upper[p_flow] @ pik_upper[p_recid].
      END.
      IF p_flow < p_spot + p_down - 1 THEN DOWN 1.
    END.
    p_line = (IF p_init = ? THEN p_line ELSE p_init).
    UP p_down - p_line.
    ASSIGN
      p_init     = ?
      p_redraw   = FALSE.
  END.

  DISPLAY pik_list[p_recid].
  
  /* The user is going to stay in this loop until he enters a valid pair
   * or hits F4
   */
  DO WHILE TRUE:
   UPDATE pik_lower[p_recid] pik_upper[p_recid]
    EDITING:
      READKEY.
      APPLY (IF CAN-DO(
          "*-UP,*-DOWN,GO,END,HOME,MOVE,GET,END-ERROR"
          ,KEYFUNCTION(LASTKEY))
        THEN KEYCODE(KBLABEL("GO")) ELSE LASTKEY).
    END.
    /* If user wants to bail out, zero out arrays and leave block */
    IF KEYFUNCTION(lastkey) = "END-ERROR" THEN DO:
      DO i = 1 TO p_recid:
        ASSIGN pik_lower[i] = 0
               pik_upper[i] = 0.
      END.
      LEAVE.
    END.
    /* Error checking on the pair entered */
    IF pik_lower[p_recid] > pik_upper[p_recid] THEN
      MESSAGE "The starting column cannot be larger than the ending column"
        VIEW-AS ALERT-BOX ERROR.
    ELSE IF pik_lower[p_recid] EQ 0                 OR 
            pik_upper[p_recid] EQ 0                 THEN
           MESSAGE "Columns must be greater than zero." VIEW-AS ALERT-BOX ERROR.
    ELSE LEAVE. /* OK */
  END.
  
  IF CAN-DO("RETURN,CURSOR-DOWN,TAB",KEYFUNCTION(LASTKEY))
    AND p_recid < pik_count THEN DO:
    p_recid = p_recid + 1.
    IF FRAME-LINE = FRAME-DOWN THEN
      SCROLL UP.
    ELSE
      DOWN.
  END.
  ELSE
  IF CAN-DO("CURSOR-UP,BACK-TAB",KEYFUNCTION(LASTKEY)) AND p_recid > 1 THEN DO:
    p_recid = p_recid - 1.
    IF FRAME-LINE = 1 THEN
      SCROLL DOWN.
    ELSE
      UP.
  END.
  ELSE
  IF KEYFUNCTION(LASTKEY) = "PAGE-DOWN" THEN ASSIGN
    p_recid  = p_recid + p_down
    p_redraw = TRUE.
  ELSE
  IF KEYFUNCTION(LASTKEY) = "PAGE-UP" THEN ASSIGN
    p_recid  = p_recid - p_down
    p_redraw = TRUE.
  ELSE
  IF CAN-DO("HOME,MOVE",KEYFUNCTION(LASTKEY)) AND p_recid > 1 THEN DO:
    ASSIGN
      p_recid  = 1
      p_redraw = TRUE.
    UP FRAME-LINE - 1.
  END.
  ELSE
  IF CAN-DO("END,HOME,MOVE",KEYFUNCTION(LASTKEY)) THEN DO:
    ASSIGN
      p_recid  = pik_count
      p_redraw = TRUE.
    DOWN p_down - FRAME-LINE.
  END.
  ELSE
  IF CAN-DO("GO,GET,END-ERROR",KEYFUNCTION(LASTKEY)) THEN LEAVE.

  p_line = 1.
END.

HIDE FRAME pick NO-PAUSE.
RETURN.
