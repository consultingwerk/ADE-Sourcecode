/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* _runsylk.i - takes a .sl files and makes it a .d file */

DEFINE INPUT PARAMETER file_in  AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER file_out AS CHARACTER NO-UNDO.

DEFINE VARIABLE line-no   AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-x       AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-y       AS INTEGER   NO-UNDO.
DEFINE VARIABLE chr-val   AS CHARACTER NO-UNDO.
DEFINE VARIABLE curr-c    AS INTEGER   NO-UNDO.
DEFINE VARIABLE curr-col  AS INTEGER   NO-UNDO.
DEFINE VARIABLE curr-r    AS INTEGER   NO-UNDO.
DEFINE VARIABLE curr-row  AS INTEGER   NO-UNDO.
DEFINE VARIABLE f-x       AS INTEGER   NO-UNDO.
DEFINE VARIABLE f-y       AS INTEGER   NO-UNDO.
DEFINE VARIABLE first-chr AS CHARACTER NO-UNDO.
DEFINE VARIABLE i         AS INTEGER   NO-UNDO.
DEFINE VARIABLE in-line   AS CHARACTER NO-UNDO.
DEFINE VARIABLE k-data    AS CHARACTER NO-UNDO.
DEFINE VARIABLE line-len  AS INTEGER   NO-UNDO.
DEFINE VARIABLE looking   AS LOGICAL   NO-UNDO.
DEFINE VARIABLE max-col   AS INTEGER   NO-UNDO.
DEFINE VARIABLE ndx       AS INTEGER   NO-UNDO.
DEFINE VARIABLE num-col   AS INTEGER   NO-UNDO.
DEFINE VARIABLE s-x       AS INTEGER   NO-UNDO.
DEFINE VARIABLE s-y       AS INTEGER   NO-UNDO.

DEFINE STREAM in-stream.
DEFINE STREAM out-stream.

/* LANGUAGE DEPENDENCIES START */ /*----------------------------------------*/

FORM
  line-no LABEL "Working on line"
  WITH FRAME working ROW 5 CENTERED ATTR-SPACE SIDE-LABELS.
COLOR DISPLAY MESSAGES line-no WITH FRAME working.

/* LANGUAGE DEPENDENCIES END */ /*------------------------------------------*/

INPUT STREAM in-stream FROM VALUE(file_in) NO-ECHO NO-MAP.
OUTPUT STREAM out-stream TO VALUE(file_out) NO-ECHO NO-MAP.

ASSIGN
  line-no  = 0
  curr-row = 1
  curr-col = 1.

REPEAT:
  IMPORT STREAM in-stream in-line.
  ASSIGN
    line-no   = line-no + 1
    first-chr = SUBSTRING(in-line,1,1)
    line-len  = LENGTH(in-line).
  DISPLAY line-no WITH FRAME working.
  IF INDEX("CEF",first-chr) = 0 THEN NEXT.
  IF first-chr = "E" THEN LEAVE. /* E signifies THE END OF SYLK FILE */
  IF first-chr = "F" THEN DO:    /* F signifies FORMATTING PHRASE */
    ASSIGN
      f-y     = 0                /* BUT IT MIGHT HAVE ROW & COL COORDs */
      f-x     = 0
      chr-val = ""
      ndx     = INDEX(in-line,";X").
    IF ndx <> 0 THEN DO:
      ASSIGN
        ndx     = ndx + 2
        looking = TRUE.
      DO WHILE looking:  /* looking for X VALUE */
        ASSIGN
          chr-val = chr-val + SUBSTRING(in-line,ndx,1)
          ndx     = ndx + 1.
        IF ndx > line-len THEN looking = FALSE.
        IF SUBSTRING(in-line,ndx,1) = ";" THEN looking = FALSE.
      END.
      f-x = INTEGER(chr-val).
    END.
    ASSIGN
      chr-val = ""
      ndx     = INDEX(in-line,";Y").
    IF ndx <> 0 THEN DO:
      ASSIGN
        ndx     = ndx + 2
        looking = TRUE.
      DO WHILE looking:  /* looking for Y VALUE */
        ASSIGN
          chr-val = chr-val + SUBSTRING(in-line,ndx,1)
          ndx     = ndx + 1.
        IF ndx > line-len THEN looking = FALSE.
        IF SUBSTRING(in-line,ndx,1) = ";" THEN looking = FALSE.
      END.
      f-y = INTEGER(chr-val).
    END.
    /* logic to figure out row and col */
    IF f-y <> 0 THEN curr-row = f-y.
    IF f-x <> 0 THEN curr-col = f-x.
  END.  /* RTD F */
  IF first-chr = "C" THEN DO:     /* C signifies ACTUAL DATA LINE */
    ASSIGN
      c-x     = 0
      c-y     = 0
      k-data  = ""
      chr-val = "".

    ndx = INDEX(in-line,";X").
    IF ndx <> 0 THEN DO:
      ASSIGN
        ndx     = ndx + 2
        looking = TRUE.
      DO WHILE looking:  /* looking for X VALUE */
        ASSIGN
          chr-val = chr-val + SUBSTRING(in-line,ndx,1)
          ndx     = ndx + 1.
        IF ndx > line-len THEN looking = FALSE.
        IF SUBSTRING(in-line,ndx,1) = ";" THEN looking = FALSE.
      END.
      c-x = INTEGER(chr-val).
    END.
    ASSIGN
      chr-val = ""
      ndx     = INDEX(in-line,";Y").
    IF ndx <> 0 THEN DO:
      ASSIGN
        ndx     = ndx + 2
        looking = TRUE.
      DO WHILE looking:  /* looking for Y VALUE */
        ASSIGN
          chr-val = chr-val + SUBSTRING(in-line,ndx,1)
          ndx     = ndx + 1.
        IF ndx > line-len THEN looking = FALSE.
        IF SUBSTRING(in-line,ndx,1) = ";" THEN looking = FALSE.
      END.
      c-y = INTEGER(chr-val).
    END.
    ASSIGN
      chr-val = ""
      ndx     = INDEX(in-line,";K").
    IF ndx <> 0 THEN DO:
      ASSIGN
        ndx     = ndx + 2
        looking = TRUE.
      DO WHILE looking:  /* looking for K (DATA) VALUE */
        ASSIGN
          chr-val = chr-val + SUBSTRING(in-line,ndx,1)
          ndx     = ndx + 1.
        IF ndx > line-len THEN looking = FALSE.
        IF SUBSTRING(in-line,ndx,1) = ";" THEN looking = FALSE.
      END.
      k-data = chr-val.
    END.
    ELSE DO:  /* look for a the S value then the R & C values. */
      ASSIGN
        chr-val = ""
        s-x     = 0
        s-y     = 0
        ndx     = INDEX(in-line,";S").
      IF ndx <> 0 THEN DO:   /* if there was an S then look for */
        ASSIGN
          ndx     = INDEX(in-line,";R")  /* the R & C values. */
          chr-val = "".
        IF ndx <> 0 THEN DO:
          ASSIGN
            ndx     = ndx + 2
            looking = TRUE.
          DO WHILE looking:  /* looking for R (ROW) VALUE */
            ASSIGN
              chr-val = chr-val + SUBSTRING(in-line,ndx,1)
              ndx     = ndx + 1.
            IF ndx > line-len THEN looking = FALSE.
            IF SUBSTRING(in-line,ndx,1) = ";" THEN looking = FALSE.
          END.
          s-y = INTEGER(chr-val).
        END.
        ASSIGN
          ndx     = INDEX(in-line,";C")  /* the R & C values. */
          chr-val = "".
        IF ndx <> 0 THEN DO:
          ASSIGN
            ndx     = ndx + 2
            looking = TRUE.
          DO WHILE looking:  /* looking for R (ROW) VALUE */
            ASSIGN
              chr-val = chr-val + SUBSTRING(in-line,ndx,1)
              ndx     = ndx + 1.
            IF ndx > line-len THEN looking = FALSE.
            IF SUBSTRING(in-line,ndx,1) = ";" THEN looking = FALSE.
          END.
          s-x = INTEGER(chr-val).
        END.
        IF s-y <> 0 THEN curr-r = s-y.
        IF s-x <> 0 THEN curr-c = s-x.

        FIND sylk WHERE sylk.y = curr-r.
        k-data = sylk.x[curr-c].
      END.

    END. /* having S VALUE */
    IF c-y <> 0 THEN curr-row = c-y.
    IF c-x <> 0 THEN curr-col = c-x.
    IF max-col < curr-col THEN max-col = curr-col.
    /* at this point I have the data point and data */

    /* find the sylk record */
    FIND sylk WHERE sylk.y = curr-row NO-ERROR.
    IF NOT AVAILABLE sylk THEN DO:
      CREATE sylk.
      sylk.y = curr-row.
    END.
    sylk.x[curr-col] = k-data.
  END.    /* IF RTD = C */
END.  /* repeat */

FOR EACH sylk:
  DO i = 1 TO max-col:
    PUT STREAM out-stream UNFORMATTED
      (IF sylk.x[i] = "" THEN "-" ELSE sylk.x[i]).
    IF i < max-col THEN PUT STREAM out-stream UNFORMATTED " ".
  END.
  PUT STREAM out-stream UNFORMATTED SKIP.
  DELETE sylk.
END.

INPUT  STREAM in-stream  CLOSE.
OUTPUT STREAM out-stream CLOSE.
HIDE FRAME working NO-PAUSE.
RETURN.
