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
/* _rdraw.p - does on-screen layout for r-main.p */

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/r-define.i }

DEFINE INPUT  PARAMETER pi_frame  AS HANDLE NO-UNDO.

DEFINE VARIABLE v_l3a   AS INTEGER   NO-UNDO. /* adjustment for width */
DEFINE VARIABLE v_l3i   AS INTEGER   NO-UNDO. /* loop counter */
DEFINE VARIABLE v_l3n   AS HANDLE    NO-UNDO. /* next available widget */
DEFINE VARIABLE v_l3q   AS INTEGER   NO-UNDO. /* sequence w/in section */
DEFINE VARIABLE v_l3w   AS HANDLE    NO-UNDO. /* current widget */
DEFINE VARIABLE v_l3x   AS INTEGER   NO-UNDO. /* width */
DEFINE VARIABLE v_l3y   AS INTEGER   NO-UNDO. /* next y position */

DEFINE VARIABLE v_head  AS LOGICAL   NO-UNDO. /* shown l/r hdr yet?*/
DEFINE VARIABLE v_foot  AS LOGICAL   NO-UNDO. /* shown l/r ftr yet?*/
DEFINE VARIABLE v_scrap AS CHARACTER NO-UNDO.
DEFINE VARIABLE v_count AS INTEGER   NO-UNDO. /* scrap value */
DEFINE VARIABLE v_outer AS INTEGER   NO-UNDO. /* outer loop */
DEFINE VARIABLE v_inner AS INTEGER   NO-UNDO. /* inner loop */
DEFINE VARIABLE v_third AS INTEGER   NO-UNDO. /* inner-inner loop */

/* Used for ordering the qbf-section temptable in a depth-first fashion. */
DEFINE VARIABLE v_tree     AS INTEGER NO-UNDO.

DEFINE VARIABLE has_agg    AS LOGICAL   NO-UNDO. /* section has aggregates */
DEFINE VARIABLE last_row   AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-i      AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-j      AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-l      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE qbf-h      AS INTEGER   NO-UNDO EXTENT 10.

DEFINE VARIABLE v_col      AS INTEGER   NO-UNDO.
DEFINE VARIABLE v_fc       AS INTEGER   NO-UNDO.
DEFINE VARIABLE v_frmwid   AS INTEGER   NO-UNDO. /* width of widest frame */
DEFINE VARIABLE v_isagg    AS LOGICAL   NO-UNDO. /* aggregates are present */
DEFINE VARIABLE v_label    AS CHARACTER NO-UNDO. /* stacked field labels */
DEFINE VARIABLE v_lblrows  AS INTEGER   NO-UNDO. /* max # rows for label */
DEFINE VARIABLE v_row      AS INTEGER   NO-UNDO.
DEFINE VARIABLE v_row1     AS INTEGER   NO-UNDO. /* 1st relative label row */
DEFINE VARIABLE v_tonly    AS LOGICAL   NO-UNDO. /* Totals Only is present */
DEFINE VARIABLE v_width    AS INTEGER   NO-UNDO. /* report width in bytes */

/* band text data */
DEFINE TEMP-TABLE tt_draw
  FIELD tf_band AS INTEGER   INITIAL ?
  FIELD tf_text AS CHARACTER INITIAL ""
  FIELD tf_sctr AS INTEGER   INITIAL 0
  FIELD tf_seq  AS INTEGER   INITIAL 0
  FIELD tf_row  AS INTEGER   INITIAL 0
  INDEX ti_draw IS UNIQUE PRIMARY tf_sctr tf_band tf_seq.

/* list of sections by frame */
DEFINE TEMP-TABLE tt_frame
  FIELD fname AS CHARACTER INITIAL ?  /* frame */
  FIELD sname AS CHARACTER INITIAL "" /* section list */
  FIELD rname AS CHARACTER INITIAL "" /* sort field list */
  INDEX fname IS UNIQUE PRIMARY fname.

DEFINE BUFFER tt_copy     FOR tt_draw.
DEFINE BUFFER tt_left     FOR tt_draw. /* left headers/footers */
DEFINE BUFFER tt_right    FOR tt_draw. /* right headers/footers */
DEFINE BUFFER qbf-sparent FOR qbf-section.

/*
tt_draw.tf_band = 1100 - Cover Page Text (9)
                  1300 - Center Header (2)
                  1400 - Left Header (1)
                  1500 - Right Header (3)
                  1600 - First-page-only Header (7) /* moved from 1200 */

                  2100 - Field Labels
                  2200 - Field Label Underlines
                  2300 - Field Formats
                  2400 - Master/Detail Aggregate Band
                  2500 - WHERE Clauses
                  2600 - Aggregate Fields & Underlines
                  2700 - Report Aggregate Fields & Underlines

                  4000 - Last-page-only Footer (8) /* moved from 4400 */
                  4100 - Left Footer (4)
                  4200 - Right Footer (6)
                  4300 - Center Footer (5)
                  4500 - Final Page Text (10)
*/

/*--------------------------------------------------------------------------*/

FIND FIRST qbf-rsys WHERE qbf-rsys.qbf-live.

RUN rebranch (1,"").

/* build list of sections by frame */
FOR EACH qbf-section:
  FIND FIRST tt_frame WHERE tt_frame.fname = qbf-section.qbf-sfrm NO-ERROR.
  IF NOT AVAILABLE tt_frame THEN DO:
    CREATE tt_frame.
    tt_frame.fname = qbf-section.qbf-sfrm.
  END.

  ASSIGN
    tt_frame.sname = (IF tt_frame.sname = "" THEN "" ELSE
                        tt_frame.sname + ",":u) + qbf-section.qbf-sout
    tt_frame.rname = qbf-section.qbf-sort.
END.

/* determine width of all fields */
FOR EACH tt_frame:
  ASSIGN
    v_isagg   = FALSE
    v_col     = MAXIMUM(1,qbf-rsys.qbf-origin-hz)
    v_width   = qbf-rsys.qbf-origin-hz 
    v_lblrows = 0.

  v_outer-1:
  DO v_outer = 1 TO qbf-rc#:
    /* does field belong to this frame? */
    ASSIGN qbf-l = NO.
    DO qbf-i = 1 TO NUM-ENTRIES(qbf-rcs[v_outer]): 
      IF CAN-DO(tt_frame.sname, ENTRY(qbf-i, qbf-rcs[v_outer])) THEN LEAVE.
      IF qbf-i = NUM-ENTRIES(qbf-rcs[v_outer]) THEN NEXT v_outer-1.
    END.
    
    RUN aderes/r-label.p (v_outer,OUTPUT qbf-rcw[v_outer],OUTPUT v_inner). 
    
    ASSIGN v_lblrows = MAXIMUM(v_lblrows,v_inner).
      
    IF INTEGER(ENTRY({&R_COL}, qbf-rcp[v_outer])) > 0 THEN 
      ASSIGN v_col = INTEGER(ENTRY({&R_COL},qbf-rcp[v_outer])).

    ASSIGN
      v_width = MAXIMUM(v_col + qbf-rcw[v_outer] - 1,v_width)
      v_col   = v_col + qbf-rsys.qbf-space-hz + qbf-rcw[v_outer]
      v_isagg = v_isagg OR LENGTH(qbf-rcg[v_outer],"CHARACTER":u) > 1
      v_tonly = v_tonly OR INDEX(qbf-rcg[v_outer], "~$":u) > 0
      .
  END.
 
  IF v_isagg THEN 
    ASSIGN v_width = v_width + 6.
  IF v_tonly THEN 
    ASSIGN v_width = v_width + (IF v_isagg THEN 6 ELSE 12).

  ASSIGN v_frmwid = MAXIMUM(v_frmwid,v_width).
END. /* FOR EACH tt_frame */

ASSIGN v_width = v_frmwid.
  
/*--------------------------------------------------------------------------*/

/* generate code for all header and footer sections */
FOR EACH qbf-hsys WHERE qbf-hsys.qbf-hpos > 0:
  ASSIGN
    qbf-hsys.qbf-hgen = ""
    qbf-hsys.qbf-hwid = 0
    qbf-hsys.qbf-hmax = 0.
    
  DO v_outer = 1 TO EXTENT(qbf-hsys.qbf-htxt):
    RUN aderes/c-header.p (qbf-hsys.qbf-htxt[v_outer], INPUT FALSE,
                           OUTPUT qbf-hsys.qbf-hgen[v_outer],
                           OUTPUT qbf-hsys.qbf-hwid[v_outer]).
    ASSIGN qbf-hsys.qbf-hmax = MAXIMUM(qbf-hsys.qbf-hmax, 
                                       qbf-hsys.qbf-hwid[v_outer]).

    /* IF qbf-hpos <= 6 AND v_outer = 1 THEN */
    IF v_outer = 1 THEN
      ASSIGN qbf-h[qbf-hpos] = qbf-hwid[v_outer].    
  END.
END.

/* determine the largest value */
ASSIGN
  v_width = MAXIMUM(qbf-h[2],                 /* center header       */
                    qbf-h[1] + qbf-h[3] + 1,  /* left + right header */
                    qbf-h[4] + qbf-h[6] + 1,  /* left + right footer */
                    qbf-h[5],                 /* center footer       */
                    qbf-h[7],                 /* first-page header   */
                    qbf-h[8],                 /* last-page  footer   */
                    v_width).                 /* calc. report width  */

ASSIGN qbf-rsys.qbf-width = v_width.
     
IF qbf-rsys.qbf-width > 255 THEN DO:
  RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l,"warning":u,"ok":u, 
    SUBSTITUTE('Your report is &1 characters wide, but the maximum is 255.  You may have to adjust field formats or remove some fields to reduce the report width by &2 characters.',
    qbf-rsys.qbf-width,qbf-rsys.qbf-width - 255)).
      
  IF "{&WINDOW-SYSTEM}":u BEGINS "MS-WIN":u THEN
    ASSIGN
      qbf-rsys.qbf-width = 255
      v_width            = qbf-rsys.qbf-width.
END.

RUN insert_headers ( 9,1100,?    ). /* Cover Page Text        */
/*RUN insert_headers ( 7,1200,?    ). /* First-page-only Header */*/
RUN insert_headers ( 2,1300,?    ). /* Center Header          */
RUN insert_headers ( 1,1400,TRUE ). /* Left Header            */
RUN insert_headers ( 3,1500,FALSE). /* Right Header           */
RUN insert_headers ( 7,1600,?    ). /* First-page-only Header */
RUN insert_headers ( 8,4000,?    ). /* Last-page-only Footer  */
RUN insert_headers ( 4,4100,TRUE ). /* Left Footer            */
RUN insert_headers ( 6,4200,FALSE). /* Right Footer           */
RUN insert_headers ( 5,4300,?    ). /* Center Footer          */
/*RUN insert_headers ( 8,4400,?    ). /* Last-page-only Footer  */*/
RUN insert_headers (10,4500,?    ). /* Final Page Text        */

/* combine left & right headers, and likewise for left & right footers */
FOR EACH tt_left WHERE tt_left.tf_band = 1400 OR tt_left.tf_band = 4100,
  EACH tt_right WHERE tt_right.tf_band = tt_left.tf_band + 100
  AND tt_left.tf_seq = tt_right.tf_seq:
  
  ASSIGN v_inner = LENGTH(tt_left.tf_text,"RAW":u).
  
  IF RIGHT-TRIM(SUBSTRING(tt_right.tf_text,1,v_inner,"RAW":u)) <> "" THEN NEXT.
  
  ASSIGN
    SUBSTRING(tt_right.tf_text,1,v_inner,"RAW":u) = tt_left.tf_text
    tt_left.tf_text                               = tt_right.tf_text.

  DELETE tt_right.
END.
  
FOR EACH tt_frame BREAK BY tt_frame.fname:
  ASSIGN 
    v_fc    = INTEGER(ENTRY(3,tt_frame.fname,"-":u))
    has_agg = FALSE.

  IF FIRST-OF(tt_frame.fname) THEN
    ASSIGN
      v_row    = 1
      v_col    = MAXIMUM(1, qbf-rsys.qbf-origin-hz)
      last_row = v_row.
           
  v_outer-2:
  DO v_outer = 1 TO qbf-rc#:
    /* does field belong to this frame? */
    ASSIGN qbf-l = NO.
    DO qbf-i = 1 TO NUM-ENTRIES(qbf-rcs[v_outer]): 
      IF CAN-DO(tt_frame.sname, ENTRY(qbf-i, qbf-rcs[v_outer])) THEN LEAVE.
      IF qbf-i = NUM-ENTRIES(qbf-rcs[v_outer]) THEN NEXT v_outer-2.
    END.

    IF INTEGER(ENTRY({&R_COL}, qbf-rcp[v_outer])) > 0 THEN 
      ASSIGN v_col   = INTEGER(ENTRY({&R_COL}, qbf-rcp[v_outer])).

    IF INTEGER(ENTRY({&R_ROW}, qbf-rcp[v_outer])) > 0 THEN 
      ASSIGN v_row   = INTEGER(ENTRY({&R_ROW}, qbf-rcp[v_outer])).
    ELSE
      ASSIGN v_row = last_row.
    ASSIGN last_row = v_row.

    /* 2100 - Field Labels */
    ASSIGN
      v_label = REPLACE(
                REPLACE(qbf-rcl[v_outer], "!":u, CHR(10)),
                CHR(10) + CHR(10), "!":u)
      v_count = 0.
      
    DO v_inner = NUM-ENTRIES(v_label, CHR(10)) TO 1 BY -1:
      ASSIGN v_row1 = v_lblrows - NUM-ENTRIES(v_label, CHR(10)).
      FIND FIRST tt_draw
        WHERE tt_draw.tf_band = 2100
          AND tt_draw.tf_sctr = v_fc
          AND tt_draw.tf_seq  = v_row + v_row1 + v_inner - 1 NO-ERROR.
      IF NOT AVAILABLE tt_draw THEN 
        CREATE tt_draw.
      ASSIGN
        tt_draw.tf_band = 2100
        tt_draw.tf_sctr = v_fc
        tt_draw.tf_seq  = v_row + v_row1 + v_inner - 1
        v_scrap         = ENTRY(v_inner, v_label, CHR(10)).
              
      IF qbf-rct[v_outer] = 4 OR qbf-rct[v_outer] = 5 THEN
        ASSIGN v_scrap = FILL(" ":u,qbf-rcw[v_outer] - LENGTH(v_scrap,"RAW":u)) 
                       + v_scrap.
      ASSIGN
        tt_draw.tf_row = v_row + v_row1 + v_inner - 1
        
        OVERLAY(tt_draw.tf_text, v_col, qbf-rcw[v_outer],"RAW":u) =
          STRING(v_scrap, "x(":u + STRING(qbf-rcw[v_outer]) + ")":u)
        v_count = v_count + 1.
    END. /* DO v_inner */
    
    /* Fill out the blank line records */
    DO v_inner = v_row - 1 TO 1 BY -1:
      FIND FIRST tt_draw
        WHERE tt_draw.tf_band = 2100
          AND tt_draw.tf_sctr = v_fc
          AND tt_draw.tf_seq  = v_inner NO-ERROR.
      IF AVAILABLE tt_draw THEN NEXT.
      
      CREATE tt_draw.
      ASSIGN
        tt_draw.tf_text = " "
        tt_draw.tf_band = 2100
        tt_draw.tf_sctr = v_fc
        tt_draw.tf_seq  = v_inner.
    END.

    /* 2200 - Field Label Underlines */
    FIND FIRST tt_draw
      WHERE tt_draw.tf_band = 2200
        AND tt_draw.tf_sctr = v_fc NO-ERROR.
    IF NOT AVAILABLE tt_draw THEN 
      CREATE tt_draw.
    ASSIGN
      tt_draw.tf_band = 2200
      tt_draw.tf_sctr = v_fc
      OVERLAY(tt_draw.tf_text, v_col, qbf-rcw[v_outer],"RAW":u) =
        FILL("-":u,qbf-rcw[v_outer]).

    /* 2300 - Field Formats */
    FIND FIRST tt_draw
      WHERE tt_draw.tf_band = 2300
        AND tt_draw.tf_sctr = v_fc
        AND tt_draw.tf_seq  = v_row NO-ERROR.
    IF NOT AVAILABLE tt_draw THEN 
      CREATE tt_draw.
    ASSIGN
      tt_draw.tf_band = 2300
      tt_draw.tf_sctr = v_fc
      tt_draw.tf_seq  = v_row
      v_scrap         = qbf-rcf[v_outer]. /* new */

    /* right-justify integer or decimal field formats */
    IF qbf-rct[v_outer] = 4 OR qbf-rct[v_outer] = 5 THEN DO:
      IF SESSION:NUMERIC-FORMAT <> "AMERICAN":u THEN 
        RUN adecomm/_convert.p ("A-TO-N":u,v_scrap,
                                SESSION:NUMERIC-SEPARATOR,
                                SESSION:NUMERIC-DECIMAL,
                                OUTPUT v_scrap).
      ASSIGN v_scrap = FILL(" ":u,qbf-rcw[v_outer] - LENGTH(v_scrap,"RAW":u)) 
                     + v_scrap.
    END.  

    ASSIGN OVERLAY(tt_draw.tf_text,v_col,qbf-rcw[v_outer],"RAW":u) = v_scrap. 

    /* Fill out the blank line records */
    DO v_inner = v_row - 1 TO 1 BY -1:
      FIND FIRST tt_draw
        WHERE tt_draw.tf_band = 2300
          AND tt_draw.tf_sctr = v_fc
          AND tt_draw.tf_seq  = v_inner NO-ERROR.
      IF AVAILABLE tt_draw THEN NEXT.
      
      CREATE tt_draw.
      ASSIGN
        tt_draw.tf_text = " ":u
        tt_draw.tf_band = 2300
        tt_draw.tf_sctr = v_fc
        tt_draw.tf_seq  = v_inner.
    END.

    /*
    ** 0: BY ...
    ** 1: total    TOTAL
    ** 2: count    COUNT
    ** 3: maximum  MAX
    ** 4: minimum  MIN
    ** 5: average  AVG
    */
    
    /* 2600 - Aggregate Fields */
    DO v_inner = 1 TO NUM-ENTRIES(qbf-sortby):
      /*
      message
        "fname" tt_frame.fname skip
        "sname" tt_frame.sname skip
        "rname" tt_frame.rname skip
        "qbf-sortby" entry(v_inner,qbf-sortby)
        view-as alert-box title "2600".
      */

      IF NOT CAN-DO(tt_frame.rname,ENTRY(v_inner,qbf-sortby)) 
        AND qbf-detail > 0 THEN NEXT.

      /* indicate order-by field for aggregate fields */
      ASSIGN v_isagg = FALSE.
      DO v_third = 1 TO 5:
        IF INDEX(qbf-rcg[v_outer], 
          SUBSTRING("tcxna":u,v_third,1,"CHARACTER":u) 
            + STRING(v_inner)) > 0 THEN ASSIGN v_isagg = TRUE.
      END.
      /*
      message
        "v_isagg" v_isagg skip
        view-as alert-box title "2600".
      */

      IF NOT v_isagg THEN NEXT.
             
      FIND FIRST tt_draw
        WHERE tt_draw.tf_band = 2600 + v_inner
          AND tt_draw.tf_sctr = v_fc
          AND tt_draw.tf_seq  = 0 NO-ERROR.
      IF NOT AVAILABLE tt_draw THEN 
        CREATE tt_draw.
      ASSIGN
        tt_draw.tf_band = 2600 + v_inner
        tt_draw.tf_sctr = v_fc
        tt_draw.tf_seq  = 0
        tt_draw.tf_text = FILL("  ":u,v_inner)
        /*
        tt_draw.tf_text = string(tt_draw.tf_band) + ":"
                        + string(tt_draw.tf_sctr,"99") + ":" 
                        + string(tt_draw.tf_seq,"99") + " " 
                        + FILL("  ":u,v_inner)
        */
                        + "BREAK BY " + ENTRY(v_inner, qbf-sortby)
        .

      DO v_third = 1 TO 5:
        IF INDEX(qbf-rcg[v_outer],
          SUBSTRING("tcxna":u,v_third,1,"CHARACTER":u) 
            + STRING(v_inner)) = 0 THEN NEXT.
        FIND FIRST tt_draw
          WHERE tt_draw.tf_band = 2600 + v_inner
            AND tt_draw.tf_sctr = v_fc
            AND tt_draw.tf_seq  = v_third NO-ERROR.
        IF NOT AVAILABLE tt_draw THEN 
          CREATE tt_draw.
        ASSIGN
          has_agg         = TRUE
          tt_draw.tf_band = 2600 + v_inner
          tt_draw.tf_sctr = v_fc
          tt_draw.tf_seq  = v_third
          /*
          v_scrap = (IF qbf-rcw[v_outer] = 1 THEN
                      SUBSTRING("tcxna":u, v_third,1,"CHARACTER":u)
                    ELSE IF qbf-rcw[v_outer] = 2 THEN
                      ENTRY(v_third,"to,co,mx,mn,av":u)
                    ELSE
                      ENTRY(v_third,"total,count,maximum,minimum,average":u)
                    )
          */
          v_scrap = SUBSTRING(qbf-rcl[v_outer],1,qbf-rcw[v_outer],"RAW":u)
          OVERLAY(tt_draw.tf_text, v_col,qbf-rcw[v_outer],"RAW":u) =
            STRING(v_scrap,"x(":u + STRING(qbf-rcw[v_outer]) + ")":u)
          OVERLAY(tt_draw.tf_text, v_width - 4, 5,"RAW":u) =
            ENTRY(v_third,"TOTAL,COUNT,MAX  ,MIN  ,AVG  ":u).
      END. /* v_third */
    END. /* v_inner - (aggregate fields) */

    /* 2700 - report aggregates */
    DO v_third = 1 TO 5:
      IF INDEX(qbf-rcg[v_outer], 
        SUBSTRING("tcxna":u,v_third,1,"CHARACTER":u) + "0":u) = 0 THEN NEXT.

      FIND FIRST tt_draw
        WHERE tt_draw.tf_band = 2700 /*+ v_inner*/
          AND tt_draw.tf_sctr = v_fc + 10
          AND tt_draw.tf_seq  = v_third NO-ERROR.
      IF NOT AVAILABLE tt_draw THEN 
        CREATE tt_draw.
      ASSIGN
        tt_draw.tf_band = 2700 /*+ v_inner*/
        tt_draw.tf_sctr = v_fc + 10
        tt_draw.tf_seq  = v_third
        /*
        v_scrap = (IF qbf-rcw[v_outer] = 1 THEN
                     SUBSTRING("tcxna":u, v_third, 1,"CHARACTER":u)
                   ELSE IF qbf-rcw[v_outer] = 2 THEN
                     ENTRY(v_third, "to,co,mx,mn,av":u)
                   ELSE
                     ENTRY(v_third, "total,count,maximum,minimum,average":u)
                   )
        */
        v_scrap = SUBSTRING(qbf-rcl[v_outer],1,qbf-rcw[v_outer],"RAW":u)
        OVERLAY(tt_draw.tf_text, v_col, qbf-rcw[v_outer],"RAW":u) =
          STRING(v_scrap, "x(":u + STRING(qbf-rcw[v_outer]) + ")":u)
        OVERLAY(tt_draw.tf_text, v_width - 4, 5,"RAW":u) =
          ENTRY(v_third, "TOTAL,COUNT,MAX  ,MIN  ,AVG  ":u).
    END. /* v_third */

    /* 2700 - totals only summary aggregates - dma */
    IF INDEX(qbf-rcg[v_outer], "~$":u) > 0 THEN DO:
      FIND FIRST tt_draw
        WHERE tt_draw.tf_band = 2700 
          AND tt_draw.tf_sctr = v_fc + 10
          AND tt_draw.tf_seq  = 6 NO-ERROR.
      IF NOT AVAILABLE tt_draw THEN
        CREATE tt_draw.
      ASSIGN
        tt_draw.tf_band = 2700 
        tt_draw.tf_sctr = v_fc + 10
        tt_draw.tf_seq  = 6
        v_scrap = (IF qbf-rcw[v_outer] = 1 THEN "T":u
                   ELSE IF qbf-rcw[v_outer] = 2 THEN "TO":u
                   ELSE "T/O":u)
        OVERLAY(tt_draw.tf_text, v_col, qbf-rcw[v_outer],"RAW":u) =
          STRING(v_scrap, "x(":u + STRING(qbf-rcw[v_outer]) + ")":u)
        OVERLAY(tt_draw.tf_text, v_width - 10, 11,"RAW":u) =
          "TOTALS ONLY":u
        .
    END.

    ASSIGN v_col = v_col + qbf-rsys.qbf-space-hz + qbf-rcw[v_outer].
  END. /* v_outer (thru fields) */

  /* field format underline */
  FIND FIRST tt_draw 
    WHERE tt_draw.tf_band = 2200
      AND tt_draw.tf_sctr = v_fc NO-ERROR.

  IF AVAILABLE tt_draw THEN DO:
    CREATE tt_copy.
    ASSIGN
      tt_copy.tf_band = 2390 /* 2399 */
      tt_copy.tf_text = tt_draw.tf_text
      tt_copy.tf_sctr = tt_draw.tf_sctr
      tt_copy.tf_seq  = tt_draw.tf_seq.
  END.

  /* create section aggregate band if 
     a. WHERE clause or sort field present and
     c. aggregates present 
  */
  IF (CAN-FIND(FIRST qbf-where) OR NUM-ENTRIES(qbf-sortby) > 0)
    AND has_agg THEN DO:

    IF AVAILABLE tt_draw THEN DO:
      CREATE tt_copy.
      ASSIGN
        tt_copy.tf_band = 2690 /* 2699 */
        tt_copy.tf_text = tt_draw.tf_text
        tt_copy.tf_sctr = tt_draw.tf_sctr
        tt_copy.tf_seq  = tt_draw.tf_seq.
    END.

    FIND FIRST tt_draw
      WHERE tt_draw.tf_band = 2400
        AND tt_draw.tf_sctr = v_fc
        AND tt_draw.tf_seq  = 0 NO-ERROR.
    IF NOT AVAILABLE tt_draw THEN 
      CREATE tt_draw.
    ASSIGN
      tt_draw.tf_band = 2400
      tt_draw.tf_sctr = v_fc
      tt_draw.tf_seq  = 0
      tt_draw.tf_text = (IF qbf-detail = 0 THEN "Detail Aggregates":t20
      /*
      tt_draw.tf_text = string(tt_draw.tf_band) + ":"
                      + string(tt_draw.tf_sctr,"99") + ":"
                      + string(tt_draw.tf_seq,"99") + " " 
                      + (IF qbf-detail = 0 THEN "Detail Aggregates":t20
      */
                        ELSE IF v_fc = 1 THEN "Master Aggregates":t20
                        ELSE "Detail Aggregates":t20)
      .
  END.
END. /* FOR EACH qbf-section (tt_frame) */

/* report width band */
FIND FIRST tt_draw
  WHERE tt_draw.tf_band = 1000
    AND tt_draw.tf_sctr = 1
    AND tt_draw.tf_seq  = 0 NO-ERROR.

IF NOT AVAILABLE tt_draw THEN 
  CREATE tt_draw.
ASSIGN
  tt_draw.tf_band = 1000
  tt_draw.tf_sctr = 1
  tt_draw.tf_seq  = 0
  tt_draw.tf_text = "Report Width:":t32
  .

/* Report aggregate section band */
FIND FIRST tt_draw
  WHERE tt_draw.tf_band = 2700 NO-ERROR.
IF AVAILABLE tt_draw THEN DO:
  CREATE tt_draw.
  ASSIGN
    tt_draw.tf_band = 2400
    tt_draw.tf_sctr = 9
    tt_draw.tf_seq  = 0
    tt_draw.tf_text = "Report Aggregates":t20
    /*
    tt_draw.tf_text = string(tt_draw.tf_band) + ":"
                    + string(tt_draw.tf_sctr,"99") + ":"
                    + string(tt_draw.tf_seq,"99") + " " 
                    + "Report Aggregates":t20
    */
    .
END.

/*------------------ Create dynamic visual widgets -------------------------*/

ASSIGN
  pi_frame:FONT       = 0
  v_l3n               = pi_frame:FIRST-CHILD /* field group */
  v_l3n               = v_l3n:FIRST-CHILD    /* first widget */
  v_l3n:VISIBLE       = FALSE
  pi_frame:SCROLLABLE = TRUE
  glbCharWidth        = FONT-TABLE:GET-TEXT-WIDTH-PIXELS("a":u,0)
  glbCharHeight       = FONT-TABLE:GET-TEXT-HEIGHT-PIXELS(0)
  .
  
CREATE TEXT v_l3n ASSIGN FRAME = pi_frame.
ASSIGN
  v_l3x               = pi_frame:WIDTH-PIXELS
  v_l3n:VISIBLE       = FALSE
  v_l3n:WIDTH-PIXELS  = v_width * glbCharWidth
  v_l3n:HEIGHT-PIXELS = glbCharHeight
  v_l3a               = v_l3n:WIDTH-PIXELS + 1
                      + pi_frame:BORDER-LEFT-PIXELS
                      + pi_frame:BORDER-RIGHT-PIXELS.

/* To avoid one error message, make sure frame is wide enough here. 
   And, to avoid a different problem, if it is too wide, we'll adjust
   it later, when all the widgets have been resized to fit.
*/
IF pi_frame:VIRTUAL-WIDTH-PIXELS < v_l3a THEN 
  ASSIGN pi_frame:VIRTUAL-WIDTH-PIXELS = v_l3a.
  
IF pi_frame:WIDTH-PIXELS < v_l3x THEN
  ASSIGN
    pi_frame:VIRTUAL-WIDTH-PIXELS = pi_frame:VIRTUAL-WIDTH-PIXELS 
                                  - pi_frame:WIDTH-PIXELS + v_l3x.
    pi_frame:WIDTH-PIXELS         = v_l3x.
    

/* headers */
DO v_l3i = 1000 TO 1600 BY 100:
  FOR EACH tt_draw WHERE tt_draw.tf_band = v_l3i v_l3q = 1 TO v_l3q + 1:
    /* create section band */
    IF v_l3q = 1 AND (v_l3i <> 1500 OR NOT v_head) THEN DO:
      IF v_l3i = 1400 THEN v_head = TRUE.
      IF v_l3n = ? THEN
        CREATE TEXT v_l3w ASSIGN FRAME = pi_frame.
      ELSE
        ASSIGN v_l3w = v_l3n.
      ASSIGN
        v_l3w:AUTO-RESIZE   = FALSE
        v_l3w:FONT          = 0
        v_l3w:FGCOLOR       = 9
        v_l3w:BGCOLOR       = 11 /*IF qbf-threed THEN 11 ELSE 8*/
        v_l3w:FORMAT        = "x(60)":u
        v_l3w:SCREEN-VALUE  =  (IF v_l3i = 1000 THEN (tt_draw.tf_text + " ":u 
                                         + STRING(v_width) + " (":u 
                                         + qbf-rsys.qbf-format + " ":u
                                         + qbf-rsys.qbf-dimen + ")":u)
                         ELSE IF v_l3i = 1100 THEN "Cover Page Text":t32
                         ELSE IF v_l3i = 1300 THEN "Center Header":t32
                         ELSE IF v_l3i = 1600 THEN "First-page-only Header":t32
                         ELSE                      "Left and Right Headers":t32)
        v_l3w:WIDTH-PIXELS  = MAXIMUM(pi_frame:WIDTH-PIXELS,
                                      v_width * glbCharWidth)
        v_l3w:HEIGHT-PIXELS = glbCharHeight.

      RUN next_sibling.
    END.

    /* show text */
    IF v_l3n = ? THEN
      CREATE TEXT v_l3w ASSIGN FRAME = pi_frame.
    ELSE
      ASSIGN v_l3w = v_l3n.
    ASSIGN
      tt_draw.tf_text     = RIGHT-TRIM(tt_draw.tf_text)
      /*
      tt_draw.tf_text     = string(tt_draw.tf_band) + ":"
                          + string(tt_draw.tf_sctr,"99") + ":"
                          + string(tt_draw.tf_seq,"99") + " " 
                          + RIGHT-TRIM(tt_draw.tf_text)
      */
      v_l3w:AUTO-RESIZE   = FALSE
      v_l3w:FONT          = 0
      v_l3w:FGCOLOR       = ?
      v_l3w:BGCOLOR       = ?      
      v_l3w:FORMAT        = SUBSTITUTE("x(&1)":u, 
                              MAXIMUM(1, LENGTH(tt_draw.tf_text,"RAW":u)))
      v_l3w:SCREEN-VALUE  = (IF v_l3i = 1000 THEN " ":u ELSE
                               SUBSTRING(tt_draw.tf_text,1,v_width,"FIXED":u))
      v_l3w:WIDTH-PIXELS  = v_width * glbCharWidth
      v_l3w:HEIGHT-PIXELS = glbCharHeight
      .
   
    RUN next_sibling.
  END.
END.
/*--------------------------------------------------------------------------*/

FOR EACH tt_draw 
  WHERE tt_draw.tf_sctr > 0 AND tt_draw.tf_band > 1000
  BREAK BY tt_draw.tf_sctr v_l3q = 1 TO v_l3q + 1:

  /* create section band */
  IF FIRST-OF(tt_draw.tf_sctr) AND tt_draw.tf_sctr < 9 THEN DO:
    IF v_l3n = ? THEN
      CREATE TEXT v_l3w ASSIGN FRAME = pi_frame.
    ELSE
      ASSIGN v_l3w = v_l3n.
    ASSIGN
      v_l3w:AUTO-RESIZE   = FALSE
      v_l3w:FONT          = 0
      v_l3w:FGCOLOR       = 9
      v_l3w:BGCOLOR       = 11 /*IF qbf-threed THEN 11 ELSE 8*/
      v_label             = (IF qbf-detail > 0 AND v_l3q = 1 THEN 
      /*
      v_label             = string(tt_draw.tf_band) + ":"
                          + string(tt_draw.tf_sctr,"99") + ":"
                          + string(tt_draw.tf_seq,"99") + " " 
                          + (IF qbf-detail > 0 AND v_l3q = 1 THEN 
      */
                               "Master Fields":t32 
                             ELSE "Detail Fields":t32)
      v_l3w:FORMAT        = SUBSTITUTE("x(&1)":u, LENGTH(v_label,"RAW":u))
      v_l3w:SCREEN-VALUE  = v_label
      v_l3w:WIDTH-PIXELS  = MAXIMUM(pi_frame:WIDTH-PIXELS, 
                                    v_width * glbCharWidth)
      v_l3w:HEIGHT-PIXELS = glbCharHeight.

    RUN next_sibling.
  END.

  /* create summary line band */
  IF tt_draw.tf_band >= 2400 AND tt_draw.tf_band < 2690 /*<= 2698*/
    AND tt_draw.tf_seq = 0 THEN DO:
      
    IF v_l3n = ? THEN
      CREATE TEXT v_l3w ASSIGN FRAME = pi_frame.
    ELSE
      ASSIGN v_l3w = v_l3n.
    ASSIGN
      v_l3w:AUTO-RESIZE   = FALSE
      v_l3w:FONT          = 0
      v_l3w:FGCOLOR       = 9
      v_l3w:BGCOLOR       = 11 /*IF qbf-threed THEN 11 ELSE 8 */
      v_label             = tt_draw.tf_text
      v_l3w:FORMAT        = SUBSTITUTE("x(&1)":u, LENGTH(v_label,"RAW":u))
      v_l3w:SCREEN-VALUE  = v_label
      v_l3w:WIDTH-PIXELS  = MAXIMUM(pi_frame:WIDTH-PIXELS,
                                    v_width * glbCharWidth)
      v_l3w:HEIGHT-PIXELS = glbCharHeight.

    RUN next_sibling.

    IF v_l3q > 1 THEN NEXT.
  END.

  /* show text */
  IF v_l3n = ? THEN
    CREATE TEXT v_l3w ASSIGN FRAME = pi_frame.
  ELSE
    ASSIGN v_l3w = v_l3n.
  ASSIGN
    tt_draw.tf_text     = RIGHT-TRIM(tt_draw.tf_text)
    /*
    tt_draw.tf_text     = string(tt_draw.tf_band) + ":"
                        + string(tt_draw.tf_sctr,"99") + ":"
                        + string(tt_draw.tf_seq,"99") + " " 
                        + RIGHT-TRIM(tt_draw.tf_text)
    */
    v_l3w:AUTO-RESIZE   = FALSE
    v_l3w:FONT          = 0
    v_l3w:FGCOLOR       = ?
    v_l3w:BGCOLOR       = ?
    v_l3w:FORMAT        = SUBSTITUTE("x(&1)":u,
                            MAXIMUM(1, LENGTH(tt_draw.tf_text,"RAW":u)))
    v_l3w:WIDTH-PIXELS  = (v_width /*+ 11*/) * glbCharWidth
    v_l3w:SCREEN-VALUE  = SUBSTRING(tt_draw.tf_text,1,
                                    v_width /*+ 11*/,"FIXED":u)
    v_l3w:HEIGHT-PIXELS = glbCharHeight
    .

  RUN next_sibling.
END. /* FOR EACH tt_draw */

/*--------------------------------------------------------------------------*/

/* footers */
DO v_l3i = 4000 TO 4500 BY 100:
  FOR EACH tt_draw WHERE tt_draw.tf_band = v_l3i v_l3q = 1 TO v_l3q + 1:
    /* create section band */
    IF v_l3q = 1 AND (v_l3i <> 4200 OR NOT v_foot) THEN DO:
      IF v_l3i = 4100 THEN ASSIGN v_foot = TRUE.
      IF v_l3n = ? THEN
        CREATE TEXT v_l3w ASSIGN FRAME = pi_frame.
      ELSE
        ASSIGN v_l3w = v_l3n.
      ASSIGN
        v_l3w:AUTO-RESIZE = FALSE
        v_l3w:FONT    = 0
        v_l3w:FGCOLOR = 9
        v_l3w:BGCOLOR = 11 /*IF qbf-threed THEN 11 ELSE 8*/
        v_l3w:FORMAT  = "x(32)":u
        v_l3w:SCREEN-VALUE = (IF v_l3i = 4500 THEN "Final Page Text":t32
                         ELSE IF v_l3i = 4000 THEN "Last-page-only Footer":t32
                         ELSE IF v_l3i = 4300 THEN "Center Footer":t32
                         ELSE                      "Left and Right Footers":t32)
        v_l3w:WIDTH-PIXELS  = MAXIMUM(pi_frame:WIDTH-PIXELS, 
                                      v_width * glbCharWidth)
        v_l3w:HEIGHT-PIXELS = glbCharHeight.

      RUN next_sibling.
    END.
    
    /* show text */
    IF v_l3n = ? THEN
      CREATE TEXT v_l3w ASSIGN FRAME = pi_frame.
    ELSE
      ASSIGN v_l3w = v_l3n.
    ASSIGN
      tt_draw.tf_text     = RIGHT-TRIM(tt_draw.tf_text)
      v_l3w:AUTO-RESIZE   = FALSE
      v_l3w:FONT          = 0
      v_l3w:FGCOLOR       = ?
      v_l3w:BGCOLOR       = ?
      v_l3w:FORMAT        = SUBSTITUTE("x(&1)":u,
                              MAXIMUM(1, LENGTH(tt_draw.tf_text,"RAW":u)))
      v_l3w:SCREEN-VALUE  = SUBSTRING(tt_draw.tf_text,1,v_width,"FIXED":u)
      v_l3w:WIDTH-PIXELS  = v_width * glbCharWidth
      v_l3w:HEIGHT-PIXELS = glbCharHeight
      .
     
    RUN next_sibling.
  END.
END.
/*--------------------------------------------------------------------------*/

/* now hide extra widgets */
DO WHILE v_l3n <> ?:
  ASSIGN
    v_l3n:VISIBLE = FALSE
    v_l3n         = v_l3n:NEXT-SIBLING.
END.

/* Finish sizing out frame. */
IF pi_frame:VIRTUAL-WIDTH-PIXELS < v_l3a THEN 
  ASSIGN pi_frame:VIRTUAL-WIDTH-PIXELS = v_l3a.
  
IF pi_frame:WIDTH-PIXELS <> v_l3x THEN
  ASSIGN
    pi_frame:VIRTUAL-WIDTH-PIXELS = pi_frame:VIRTUAL-WIDTH-PIXELS 
                                  - pi_frame:WIDTH-PIXELS + v_l3x
    pi_frame:WIDTH-PIXELS         = v_l3x.

ASSIGN v_l3i = MAXIMUM(v_l3y + pi_frame:BORDER-TOP-PIXELS +
                       pi_frame:BORDER-BOTTOM-PIXELS + 2,
                       CURRENT-WINDOW:HEIGHT-PIXELS - pi_frame:Y).

IF pi_frame:VIRTUAL-HEIGHT-PIXELS <> v_l3i THEN 
  ASSIGN pi_frame:VIRTUAL-HEIGHT-PIXELS = v_l3i.

/* final fudge to accomodate vertical scrollbar -dma */
ASSIGN pi_frame:VIRTUAL-WIDTH = pi_frame:VIRTUAL-WIDTH + 3 NO-ERROR.

RETURN.

/*--------------------------------------------------------------------------*/
/* generic code to lay out all header and footer stuff */
PROCEDURE insert_headers:
  DEFINE INPUT PARAMETER pi_pos  AS INTEGER NO-UNDO.
  DEFINE INPUT PARAMETER pi_sect AS INTEGER NO-UNDO.
  DEFINE INPUT PARAMETER pi_side AS LOGICAL NO-UNDO. /* t/f/?=left/rit/cent */
  
  DEFINE VARIABLE iv_scrap  AS INTEGER NO-UNDO.
  DEFINE VARIABLE iv_margin AS INTEGER NO-UNDO.
  DEFINE VARIABLE iv_loop   AS INTEGER NO-UNDO.

  FIND FIRST qbf-hsys WHERE qbf-hsys.qbf-hpos = pi_pos NO-ERROR.
  IF NOT AVAILABLE qbf-hsys THEN RETURN.

  /* find # of usable lines */ 
  DO iv_scrap = EXTENT(qbf-hsys.qbf-htxt) TO 1 BY -1:
    IF TRIM(qbf-hsys.qbf-htxt[iv_scrap]) <> "" THEN LEAVE.
  END.

  DO iv_loop = 1 TO iv_scrap:
    ASSIGN
      iv_margin = (IF pi_side THEN         /* pi_side=TRUE =left-justified  */
                    qbf-rsys.qbf-origin-hz /*- 1*/
                  ELSE IF NOT pi_side THEN /*        =FALSE=right-justified */
                    MAXIMUM(0, v_width - qbf-hsys.qbf-hwid[iv_loop])
                  ELSE                     /*        =?    =centered        */
                    MAXIMUM(0, (v_width - qbf-hsys.qbf-hwid[iv_loop]) / 2)
                  )
      iv_margin = (IF pi_side THEN iv_margin - 1 ELSE iv_margin).

    CREATE tt_draw.
    ASSIGN
      tt_draw.tf_seq  = iv_loop
      tt_draw.tf_band = pi_sect
      tt_draw.tf_text = FILL(" ":u,iv_margin) + qbf-hsys.qbf-hgen[iv_loop].
  END.
    
  RELEASE tt_draw.
END PROCEDURE. /* insert_headers */

/*--------------------------------------------------------------------------*/
/* this orders query sections in a depth-first fashion */
PROCEDURE rebranch:
  DEFINE INPUT PARAMETER ip_level AS INTEGER   NO-UNDO. /* level */
  DEFINE INPUT PARAMETER ip_tree  AS CHARACTER NO-UNDO. /* tree */
  DEFINE BUFFER ib_section FOR qbf-section.
  
  FOR EACH ib_section
    WHERE NUM-ENTRIES(ib_section.qbf-sout,".":u) = ip_level
      AND ib_section.qbf-sout BEGINS ip_tree
    BY INTEGER(ENTRY(ip_level, ib_section.qbf-sout, ".":u)):
    ASSIGN
      v_tree              = v_tree + 1
      ib_section.qbf-sctr = v_tree.
      
    RUN rebranch (ip_level + 1, ib_section.qbf-sout + ".":u).
  END.
END PROCEDURE. /* rebranch */

/*--------------------------------------------------------------------------*/
/* setup to display next widget sibling */
PROCEDURE next_sibling:
  IF v_l3y + v_l3w:HEIGHT-PIXELS + 25 > pi_frame:VIRTUAL-HEIGHT-PIXELS THEN
    pi_frame:VIRTUAL-HEIGHT-PIXELS = v_l3y + v_l3w:HEIGHT-PIXELS + 50.
  ASSIGN
    v_l3w:X       = 0
    v_l3w:Y       = v_l3y
    v_l3w:VISIBLE = TRUE
    v_l3y         = v_l3y + v_l3w:HEIGHT-PIXELS
    v_l3n         = v_l3w:NEXT-SIBLING.
END PROCEDURE.

/* r-draw.p - end of file */

