/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* c-edit.i - general-purpose editor include file */

/*
called by s-edit.p and l-edit.p

required variable definitions:
  DEFINE VARIABLE qbf#  AS INTEGER               NO-UNDO. /* action */
  DEFINE VARIABLE qbf-a AS LOGICAL               NO-UNDO. /* misc flag */
  DEFINE VARIABLE qbf-c AS CHARACTER             NO-UNDO. /* current line */
  DEFINE VARIABLE qbf-f AS CHARACTER INITIAL  "" NO-UNDO. /* find string */
  DEFINE VARIABLE qbf-i AS INTEGER               NO-UNDO. /* loop */
  DEFINE VARIABLE qbf-j AS INTEGER               NO-UNDO. /* loop */
  DEFINE VARIABLE qbf-k AS CHARACTER             NO-UNDO. /* keyboard map */
  DEFINE VARIABLE qbf-o AS CHARACTER             NO-UNDO. /* optimization */
  DEFINE VARIABLE qbf-s AS INTEGER INITIAL     0 NO-UNDO. /* used with qbf-o */
  DEFINE VARIABLE qbf-v AS LOGICAL INITIAL FALSE NO-UNDO. /* overtype flag */
  DEFINE VARIABLE qbf-w AS LOGICAL INITIAL  TRUE NO-UNDO. /* redraw flag */
  DEFINE VARIABLE qbf-x AS INTEGER INITIAL     1 NO-UNDO. /* x-position */
  DEFINE VARIABLE qbf-y AS INTEGER INITIAL     1 NO-UNDO. /* y-position */

passed parameters:
  {&array}  = name of text array
  {&col}    = x-position of text field relative to qbf-edit
  {&extent} = maximum number of lines
  {&go}     = what to do when [go] key pressed
  {&wide}   = width of text field

optional passed parameters:
  {&prefix} = added before <field-name> when GET key pressed
  {&suffix} = appended to <field-name> when GET key pressed
*/

{ prores/c-field.i
  &new=NEW &down="SCREEN-LINES - 9" &row="ROW 5" &column="COLUMN 35"
  &title=qbf-c
}

qbf-k = "TAB,BACK-TAB,BACKSPACE,RIGHT-END,CLEAR,INSERT-MODE,CURSOR-LEFT,"
      + "CURSOR-RIGHT,LEFT-END,DELETE-CHARACTER,RECALL,END-ERROR,FIND,GET,GO,"
      + "HELP,HOME,CURSOR-DOWN,CURSOR-UP,NEW-LINE,PAGE-DOWN,PAGE-UP,BLOCK,"
      + "DELETE-LINE,RETURN,BREAK-LINE,APPEND-LINE".

/*
1: TAB          | 10: DELETE-CHARACTER | 19: CURSOR-UP
2: BACK-TAB     | 11: RECALL           | 20: NEW-LINE
3: BACKSPACE    | 12: END-ERROR        | 21: PAGE-DOWN
4: RIGHT-END    | 13: FIND             | 22: PAGE-UP
5: CLEAR        | 14: GET              | 23: BLOCK
6: INSERT-MODE  | 15: GO               | 24: DELETE-LINE
7: CURSOR-LEFT  | 16: HELP             | 25: RETURN
8: CURSOR-RIGHT | 17: HOME             | 26: BREAK-LINE
9: LEFT-END     | 18: CURSOR-DOWN      | 27: APPEND-LINE
*/

FORM
  qbf-c FORMAT "x(64)"
  HEADER
  qbf-o FORMAT "x(64)"
  WITH FRAME qbf-input ROW 6 CENTERED ATTR-SPACE NO-LABELS OVERLAY.

/* debugging
OUTPUT TO VALUE(qbf-tempdir + ".d") NO-ECHO.
DO qbf-i = 1 TO {&extent}:
  IF {&array}[qbf-i] <> "" THEN EXPORT qbf-i {&array}[qbf-i].
END.
OUTPUT CLOSE.
*/

_wipe-out:
DO TRANSACTION:
  DO WHILE TRUE ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE WITH FRAME qbf-edit:
    
    READKEY PAUSE 0.
    IF qbf-w AND LASTKEY = -1 THEN DO:
      qbf-c = {&array}[qbf-y].
      DISPLAY
        qbf-y WHEN qbf-y <> INPUT FRAME qbf-edit qbf-y
        qbf-c WHEN qbf-c <> INPUT FRAME qbf-edit qbf-c.
      qbf-j = FRAME-LINE.
      UP qbf-j - 1.
      DO qbf-i = qbf-y - qbf-j + 1 TO qbf-y - qbf-j + FRAME-DOWN:
        COLOR DISPLAY INPUT qbf-c.
        qbf-c = {&array}[qbf-i].
        DISPLAY
          qbf-i WHEN qbf-i <> INPUT FRAME qbf-edit qbf-y @ qbf-y
          qbf-c WHEN qbf-c <> INPUT FRAME qbf-edit qbf-c.
        IF LASTKEY = -1 THEN READKEY PAUSE 0.
        IF LASTKEY <> -1 THEN LEAVE.
        IF FRAME-LINE < FRAME-DOWN THEN DOWN. ELSE qbf-w = FALSE.
      END.
      DOWN qbf-j - FRAME-LINE.
      STATUS DEFAULT qbf-lang[6].
      /*Press [GO] to save, [END-ERROR] to exit, or [GET] to insert fields.*/
    END.

    ASSIGN
      qbf-a = TRUE
      qbf-c = SUBSTRING({&array}[qbf-y],1,{&wide}).
    DISPLAY
      qbf-y WHEN qbf-y <> INPUT FRAME qbf-edit qbf-y
      qbf-c WHEN qbf-c <> INPUT FRAME qbf-edit qbf-c.

    COLOR DISPLAY INPUT qbf-c.
    DO WHILE TRUE: /* within-same-line processing block */
      qbf-x = MAXIMUM(MINIMUM(qbf-x,{&wide}),1).

      PUT CURSOR
        ROW FRAME-LINE + FRAME-ROW - 1
        COLUMN FRAME-COL + {&col} + qbf-x.
      
      IF LASTKEY <> -1 THEN .
      ELSE
      IF qbf-w THEN
        READKEY PAUSE 0.
      ELSE
        READKEY.
      
      ASSIGN
        qbf-s = 0
        qbf-a = FALSE
        qbf#  = LOOKUP(KEYFUNCTION(LASTKEY),qbf-k).

      IF LASTKEY < 1 THEN LEAVE. /*no-op*/
      ELSE IF qbf# = 1 THEN /*tab*/
        qbf-x = MINIMUM(TRUNCATE(qbf-x / 5 + 1,0) * 5,{&wide}).
      ELSE IF qbf# = 2 THEN /*back-tab*/
        qbf-x = MAXIMUM(TRUNCATE(qbf-x / 5 - .2,0) * 5,1).
      ELSE IF qbf# = 3 THEN /*backspace*/
        ASSIGN
          SUBSTRING(qbf-c,MAXIMUM(qbf-x - 1,1),1) = ""
          qbf-x = MAXIMUM(1,qbf-x - 1)
          qbf-s = qbf-x
          qbf-o = SUBSTRING(qbf-c,qbf-x) + " ".
      ELSE IF qbf# = 4 THEN /*right-end*/
        qbf-x = MINIMUM(LENGTH(qbf-c) + 1,{&wide}).
      ELSE IF qbf# = 5 THEN /*clear*/
        ASSIGN
          qbf-s = (IF LENGTH(qbf-c) > qbf-x THEN qbf-x ELSE 0)
          qbf-o = (IF qbf-s = 0 THEN "" ELSE
                  FILL(" ",LENGTH(qbf-c) - qbf-x + 1))
          qbf-c = SUBSTRING(qbf-c,1,qbf-x - 1).
      ELSE IF qbf# = 6 THEN DO: /*insert-mode*/
        qbf-v = NOT qbf-v.
        PUT SCREEN ROW SCREEN-LINES + 3 COLUMN 79 - LENGTH(qbf-lang[1])
          STRING(qbf-v,qbf-lang[1] + "/"). /*'Insert'*/
      END.
      ELSE IF qbf# = 7 THEN /*cursor-left*/
        qbf-x = MAXIMUM(1,qbf-x - 1).
      ELSE IF qbf# = 8 THEN /*cursor-right*/
        qbf-x = MINIMUM(qbf-x + 1,{&wide}).
      ELSE IF qbf# = 9 THEN /*left-end*/
        qbf-x = 1.
      ELSE IF qbf# = 10 THEN /*delete-character*/
        ASSIGN
          SUBSTRING(qbf-c,qbf-x,1) = ""
          qbf-s = qbf-x
          qbf-o = SUBSTRING(qbf-c,qbf-x) + " ".
      ELSE IF qbf# = 11 THEN /*recall*/
        ASSIGN
          qbf-s = 1
          qbf-o = {&array}[qbf-y]
                + (IF LENGTH({&array}[qbf-y]) > LENGTH(qbf-c) THEN ""
                  ELSE FILL(" ",LENGTH(qbf-c) - LENGTH({&array}[qbf-y])))
          qbf-x = 1
          qbf-c = {&array}[qbf-y].
      ELSE IF qbf# >= 12 THEN LEAVE.
      ELSE IF (LASTKEY >= 32 AND LASTKEY < 127)
           OR (LASTKEY > 127 AND LASTKEY < 255) THEN DO:
           
        ASSIGN
          SUBSTRING(qbf-c,qbf-x,IF qbf-v THEN 0 ELSE 1) = CHR(LASTKEY)
          qbf-c = SUBSTRING(qbf-c,1,{&wide})
          qbf-s = qbf-x
          qbf-o = (IF qbf-v THEN SUBSTRING(qbf-c,qbf-x) ELSE CHR(LASTKEY))
          qbf-x = qbf-x + 1.
      END.
      ELSE
        BELL.

      IF qbf-s > 0 THEN DO:
        qbf-s = qbf-s + FRAME-COL + {&col}.
        
        /* 19990615-015 
        IF IS-ATTR-SPACE THEN PUT SCREEN
          ROW FRAME-LINE + FRAME-ROW - 1 COLUMN qbf-s qbf-o.
        ELSE
        PUT SCREEN COLOR INPUT 
          ROW FRAME-LINE + FRAME-ROW - 1 COLUMN qbf-s qbf-o.
        */
        DISPLAY qbf-c.

        DO WHILE qbf-c MATCHES "* ":
          qbf-c = SUBSTRING(qbf-c,1,LENGTH(qbf-c) - 1).
        END.
      END.
      READKEY PAUSE 0. /* Set LASTKEY to -1 */

    END. /* DO WHILE TRUE */
    PUT CURSOR OFF.

    DISPLAY qbf-c WHEN qbf-c <> INPUT FRAME qbf-edit qbf-c.
    {&array}[qbf-y] = qbf-c.

    IF qbf# = 12 THEN DO: /*end-error*/
      qbf-a = FALSE.
      RUN prores/s-box.p (INPUT-OUTPUT qbf-a,?,?,"#2").
      /*'Are you sure you want to exit text editing?'*/
      qbf-a = NOT qbf-a.
      IF NOT qbf-a THEN DO:
        /* {&go}  This used to be here July 7, 1993 which made
        ** undo not work!! GJO
        */
        UNDO _wipe-out,LEAVE _wipe-out.
      END.
      /*
      IF qbf-a THEN DO:
        {&array} = "".
        INPUT FROM VALUE(qbf-tempdir + ".d") NO-ECHO.
        REPEAT:
          IMPORT qbf-i {&array}[qbf-i].
        END.
        INPUT CLOSE.
        LEAVE.
      END.
      */
    END.
    ELSE
    IF qbf# = 13 THEN DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE: /*find*/
      /* qbf-lang[4] = 'Type the search string'*/
      qbf-o = qbf-lang[4]. /*Type the search string*/
      UPDATE qbf-f WITH FRAME qbf-input.
      IF qbf-f = ? OR qbf-f = "" THEN UNDO,LEAVE.
      qbf-j = 0.
      DO qbf-i = qbf-y + 1 TO {&extent} WHILE qbf-j = 0:
        IF INDEX({&array}[qbf-i],qbf-f) > 0 THEN qbf-j = qbf-i.
      END.
      DO qbf-i = 1 TO qbf-y WHILE qbf-j = 0:
        IF INDEX({&array}[qbf-i],qbf-f) > 0 THEN qbf-j = qbf-i.
      END.
      HIDE MESSAGE NO-PAUSE.
      IF qbf-j = 0 THEN
        MESSAGE qbf-lang[7]. /* Search string not found. */
      ELSE
        ASSIGN
          qbf-w = TRUE
          qbf-y = qbf-j.
      IF qbf-y < FRAME-LINE THEN UP FRAME-LINE - qbf-y.
      IF qbf-y + FRAME-DOWN - FRAME-LINE > {&extent} THEN
        DOWN FRAME-DOWN - FRAME-LINE.
    END.
    ELSE
    IF qbf# = 14 THEN DO: /*get*/
      IF qbf-file[1] = "" THEN NEXT.
      qbf-c = ' ' + qbf-lang[5] + ' '.  /*'" Choose a Field "'*/
      PAUSE 0.
      VIEW FRAME qbf-pick.
      qbf-c = "".
      RUN prores/s-field.p ("field","","*",INPUT-OUTPUT qbf-c).
      HIDE FRAME qbf-pick NO-PAUSE.
      IF qbf-c <> "" THEN
        ASSIGN
          qbf-c = {&prefix} qbf-c {&suffix}
          SUBSTRING({&array}[qbf-y],qbf-x,0) = qbf-c
          qbf-x = MINIMUM(qbf-x + LENGTH(qbf-c),{&wide})
          qbf-w = TRUE.
    END.
    ELSE
    IF qbf# = 15 THEN DO: /*go*/
      {&go}
      qbf-a = TRUE.
      LEAVE.
    END.
    ELSE
    IF qbf# = 16 THEN /*help*/
      RUN prores/applhelp.p.
    ELSE
    IF qbf# = 17 THEN DO: /*home*/
      ASSIGN
        qbf-w = TRUE
        qbf-y = (IF qbf-y = FRAME-LINE THEN {&extent} ELSE 1).
      UP FRAME-LINE - (IF qbf-y = 1 THEN 1 ELSE FRAME-DOWN).
    END.
    ELSE
    IF qbf# = 18 OR (qbf# = 25 AND NOT qbf-v) THEN DO:
      /*cursor-down,(return&!insmode)*/
      qbf-x = (IF qbf# = 25 THEN 1 ELSE qbf-x).
      IF qbf-y = {&extent} THEN NEXT.
      qbf-y = qbf-y + 1.
      IF FRAME-LINE = FRAME-DOWN THEN
        SCROLL UP.
      ELSE
        DOWN.
    END.
    ELSE
    IF qbf# = 19 THEN DO: /*cursor-up*/
      IF qbf-y = 1 THEN NEXT.
      qbf-y = qbf-y - 1.
      IF FRAME-LINE = 1 THEN
        SCROLL DOWN.
      ELSE
        UP.
    END.
    ELSE
    IF (qbf# = 25 AND qbf-v) OR qbf# = 20 OR qbf# = 26 THEN DO:
      /*(return&ins-mode),new-line,break-line*/
      IF qbf-y = {&extent} AND qbf# = 25 THEN qbf-x = 1.
      IF qbf-y = {&extent} THEN NEXT.
      qbf-w = TRUE.
      DO qbf-i = {&extent} TO qbf-y + 1 BY -1:
        {&array}[qbf-i] = {&array}[qbf-i - 1].
      END.
      IF qbf# = 20 THEN
        ASSIGN
          qbf-x               = 1
          {&array}[qbf-y + 1] = "".
      ELSE
        ASSIGN
          {&array}[qbf-y + 1] = SUBSTRING({&array}[qbf-y],qbf-x)
          {&array}[qbf-y    ] = SUBSTRING({&array}[qbf-y],1,qbf-x - 1).

      IF qbf# = 25 THEN DO:
        ASSIGN
          qbf-x = 1
          qbf-y = qbf-y + 1.
        IF FRAME-LINE = FRAME-DOWN THEN
          SCROLL UP.
        ELSE
          DOWN.
      END.

    END.
    ELSE
    IF qbf# = 21 THEN DO: /*page-down*/
      ASSIGN
        qbf-y = qbf-y + FRAME-DOWN
        qbf-w = TRUE.
      IF qbf-y + FRAME-DOWN - FRAME-LINE > {&extent} THEN
        qbf-y = {&extent} - FRAME-DOWN + FRAME-LINE.
    END.
    ELSE
    IF qbf# = 22 THEN DO: /*page-up*/
      ASSIGN
        qbf-y = MAXIMUM(IF qbf-y - FRAME-DOWN < FRAME-LINE THEN
                  FRAME-LINE
                ELSE
                  qbf-y - FRAME-DOWN,1)
        qbf-w = TRUE.
      IF qbf-y = 1 THEN UP FRAME-LINE - 1.
    END.
    ELSE
    IF qbf# = 23 THEN DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE: /*block*/
      ASSIGN
        qbf-c = ""
        qbf-o = qbf-lang[3]. /*Type the name of the file to merge*/
      UPDATE qbf-c WITH FRAME qbf-input.
      qbf-c = SEARCH(qbf-c).
      IF qbf-c = ? THEN UNDO,LEAVE.
      ASSIGN
        qbf-i = qbf-y
        qbf-w = TRUE.

      IF CAN-DO("MSDOS,VMS,BTOS",OPSYS) THEN DO:
        RUN prores/s-quoter.p (qbf-c,qbf-tempdir + "2.d").
        INPUT FROM VALUE(qbf-tempdir + "2.d") NO-ECHO.
      END.
      ELSE
        INPUT THROUGH quoter VALUE(qbf-c) NO-ECHO.

      REPEAT qbf-i = qbf-y TO {&extent}:
        IMPORT {&array}[qbf-i].
      END.
      INPUT CLOSE.
    END.
    ELSE
    IF qbf# = 24 OR qbf# = 27 THEN DO: /*delete-line,append-line*/
      qbf-x = MINIMUM(IF qbf# = 24 THEN 1 ELSE LENGTH(qbf-c) + 1,{&wide}).
      IF qbf# = 27
        AND LENGTH({&array}[qbf-y] + {&array}[qbf-y + 1]) + 1 > {&wide}
        THEN NEXT.
      {&array}[qbf-y] = (IF qbf# = 24 THEN {&array}[qbf-y + 1] ELSE
                        {&array}[qbf-y] + " " + TRIM({&array}[qbf-y + 1])).
      DO qbf-i = qbf-y + 1 TO {&extent} - 1:
        {&array}[qbf-i] = {&array}[qbf-i + 1].
      END.
      ASSIGN
        {&array}[{&extent}] = ""
        qbf-w               = TRUE.
    END.

    HIDE FRAME qbf-input NO-PAUSE.
  END.
END.

PUT SCREEN
  ROW SCREEN-LINES + 3
  COLUMN 80 - LENGTH(qbf-lang[1])
  FILL(" ",LENGTH(qbf-lang[1])).
