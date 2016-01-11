/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* u-browse.i - code for scrolling browse routine for query module */

/*
&buff=    name of defined buffer that will be used in where clauses
&fields=  list of field names, qualified with buffer name
&where=   where clause (optional, may be omitted entirely)
&join=    definition of shared buffer for joining
&file=    databasename.filename
&colorlo= NORMAL color
&colorhi= MESSAGES color
&msgtop=  words "At Top"
&msgbot=  words "At Bottom"
&msgall=  words "All Shown"
&msgnon=  text  "   ---   "
&msglin=  text of status line message
&msgtit=  text for title of frame
&putcol=  put screen column for msg??? texts above
&down=    number of iterations for down frame


typical example of usage:
{ prores/u-browse.i
  &buff=   "order"
  &fields= "order.Order-num order.Cust-num order.Odate"
  &where=  "OF customer"
  &join=   "DEFINE SHARED BUFFER customer FOR demo.customer."
  &file=   "demo.order"
  &colorlo="NORMAL"
  &colorhi="MESSAGES"
  &msgall= "All Shown"
  &msgtop= " At Top  "
  &msgbot= "At Bottom"
  &msgnon= "---------"
  &msglin= "Press [F5] to set different browse fields."
  &msgtit= "Browse"
  &putcol=  35
  &down=    14
}
*/

DEFINE VARIABLE qbf#  AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-c AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-d AS ROWID     NO-UNDO.
DEFINE VARIABLE qbf-e AS ROWID     NO-UNDO.
DEFINE VARIABLE qbf-h AS ROWID     NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-n AS LOGICAL   NO-UNDO.
DEFINE VARIABLE qbf-o AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-p AS LOGICAL   NO-UNDO.
DEFINE VARIABLE qbf-w AS LOGICAL   NO-UNDO.

{&join}
DEFINE SHARED BUFFER {&buff} FOR {&file}.

STATUS DEFAULT "{&msglin}".
/*Press [GET] to set different browse fields.*/

DO WITH FRAME qbf-brow:
  qbf-d = ROWID({&buff}).
  FIND LAST {&buff} {&where} NO-LOCK NO-ERROR.
  qbf-e = ROWID({&buff}).
  FIND FIRST {&buff} {&where} NO-LOCK NO-ERROR.
  ASSIGN
    qbf-h = ROWID({&buff})
    qbf-j = 0
    qbf-w = TRUE.
  IF qbf-d <> ? THEN
    FIND FIRST {&buff} WHERE ROWID({&buff}) = qbf-d NO-LOCK NO-ERROR.
  FORM
    {&fields}
    WITH SCROLL 1 OVERLAY {&down} DOWN ROW 4 CENTERED
    COLOR DISPLAY "{&colorlo}" PROMPT "{&colorhi}"
    TITLE COLOR "{&colorlo}" " {&msgtit} - ~"{&file}~" ".
  VIEW.
  DO WHILE TRUE:

    IF qbf-w THEN DO:
      ASSIGN
        qbf-d = ROWID({&buff})
        qbf-i = FRAME-LINE
        qbf-w = FALSE
        qbf-p = TRUE
        qbf-n = TRUE.
      IF qbf-i > 1 THEN DO qbf-j = 2 TO FRAME-LINE:
        IF AVAILABLE {&buff} THEN
          FIND PREV {&buff} {&where} NO-LOCK NO-ERROR.
        IF NOT AVAILABLE {&buff} THEN qbf-i = qbf-i - 1.
      END.
      UP FRAME-LINE - 1.
      IF NOT AVAILABLE {&buff} THEN
        FIND FIRST {&buff} {&where} NO-LOCK NO-ERROR.
      IF ROWID({&buff}) = qbf-h THEN qbf-p = FALSE.
      DO qbf-j = 1 TO FRAME-DOWN:
        IF AVAILABLE {&buff} THEN
          DISPLAY {&fields}.
        ELSE
          CLEAR NO-PAUSE.
        IF qbf-j = FRAME-DOWN THEN LEAVE.
        DOWN.
        IF AVAILABLE {&buff} THEN
          FIND NEXT {&buff} {&where} NO-LOCK NO-ERROR.
      END.
      IF NOT AVAILABLE {&buff} OR ROWID({&buff}) = qbf-e THEN qbf-n = FALSE.
      FIND {&buff} WHERE ROWID({&buff}) = qbf-d NO-LOCK NO-ERROR.
      UP FRAME-DOWN - qbf-i.
    END.

    qbf-c = (IF NOT qbf-p AND NOT qbf-n THEN "{&msgall}"   /*all*/
        ELSE IF NOT qbf-p               THEN "{&msgtop}"   /*top*/
        ELSE IF NOT qbf-n               THEN "{&msgbot}"   /*bot*/
        ELSE                                 "{&msgnon}"). /*---*/
    IF qbf-c <> qbf-o THEN
      PUT SCREEN ROW SCREEN-LINES COLUMN {&putcol} COLOR "{&colorlo}" qbf-c.
    IF AVAILABLE {&buff} THEN       DISPLAY              {&fields}.
    IF AVAILABLE {&buff} THEN COLOR DISPLAY "{&colorhi}" {&fields}.
    READKEY.
    PAUSE 0.
    ASSIGN
      qbf-o = qbf-c
      qbf#  = LOOKUP(KEYFUNCTION(LASTKEY),"CURSOR-DOWN,TAB, ,"
            + "CURSOR-UP,BACK-TAB,BACKSPACE,PAGE-UP,PAGE-DOWN,"
            + "HOME,MOVE,HELP,GO,RETURN,END-ERROR,GET").
    IF qbf# = 0 THEN NEXT.
    IF qbf# = 10 THEN qbf# = 9.
    IF qbf# = 9 AND ROWID({&buff}) = qbf-h THEN qbf# = 10.

    IF qbf# >= 1 AND qbf# <= 3 THEN DO:
      qbf-d = ROWID({&buff}).
      IF qbf-d = qbf-e THEN NEXT.
      FIND NEXT {&buff} {&where} NO-LOCK NO-ERROR.
      IF ROWID({&buff}) = qbf-e THEN qbf-n = FALSE.
      IF AVAILABLE {&buff} THEN DO:
        COLOR DISPLAY "{&colorlo}" {&fields}.
        IF FRAME-LINE = FRAME-DOWN THEN DO:
          SCROLL UP.
          qbf-p = TRUE.
        END.
        ELSE
          DOWN.
      END.
      ELSE
        FIND {&buff} WHERE ROWID({&buff}) = qbf-d NO-LOCK NO-ERROR.
      NEXT.
    END.

    IF qbf# >= 4 AND qbf# <= 6 THEN DO:
      qbf-d = ROWID({&buff}).
      IF qbf-d = qbf-h THEN NEXT.
      FIND PREV {&buff} {&where} NO-LOCK NO-ERROR.
      IF ROWID({&buff}) = qbf-h THEN qbf-p = FALSE.
      IF AVAILABLE {&buff} THEN DO:
        COLOR DISPLAY "{&colorlo}" {&fields}.
        IF FRAME-LINE = 1 THEN DO:
          SCROLL DOWN.
          qbf-n = TRUE.
        END.
        ELSE
          UP.
      END.
      ELSE
        FIND {&buff} WHERE ROWID({&buff}) = qbf-d NO-LOCK NO-ERROR.
      NEXT.
    END.

    IF AVAILABLE {&buff} THEN COLOR DISPLAY "{&colorlo}" {&fields}.
    qbf-w = TRUE.
    IF qbf# = 7 OR qbf# = 8 THEN DO:
      DO qbf-j = 1 TO FRAME-DOWN WHILE AVAILABLE {&buff}:
        IF qbf# = 7 THEN
          FIND PREV {&buff} {&where} NO-LOCK NO-ERROR.
        ELSE
          FIND NEXT {&buff} {&where} NO-LOCK NO-ERROR.
      END.
      IF AVAILABLE {&buff} THEN NEXT.
      qbf# = qbf# + 2.
    END.

    IF qbf# = 9 OR qbf# = 10 THEN DO:
      UP FRAME-LINE - (IF qbf# = 9 THEN 1 ELSE FRAME-DOWN).
      IF qbf# = 9 THEN
        FIND FIRST {&buff} {&where} NO-LOCK NO-ERROR.
      ELSE
        FIND LAST {&buff} {&where} NO-LOCK NO-ERROR.
      NEXT.
    END.

    IF qbf# = 11 THEN RUN prores/applhelp.p. /* qbf-module = "browse,db.fil" */
    IF qbf# = 14 THEN RELEASE {&buff}.
    IF qbf# >= 12 AND qbf# <= 15 THEN LEAVE.

  END.

  HIDE FRAME qbf-brow NO-PAUSE.
  qbf-d = ROWID({&buff}).
END.
STATUS DEFAULT.
RETURN.
