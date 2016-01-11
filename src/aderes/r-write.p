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
/*
 * r-write.p - generate report program
 */

{ aderes/s-system.i }
{ aderes/e-define.i }
{ aderes/s-define.i }
{ aderes/r-define.i }
{ aderes/j-define.i }

DEFINE INPUT PARAMETER usage AS CHARACTER NO-UNDO.

DEFINE VARIABLE qbf-c  AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-e  AS INTEGER   NO-UNDO. /* extent of field */
DEFINE VARIABLE qbf-i  AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-j  AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf_m  AS CHARACTER NO-UNDO. /* indent margin */
DEFINE VARIABLE qbf-x  AS INTEGER   NO-UNDO. /* report width */
DEFINE VARIABLE fldexp AS CHARACTER NO-UNDO. /* qbf-rcn element */

/* sum-check tells us whether to check for totals only summary fields.
   It's set to yes as soon as we hit the level where the summary sort
   field is.  There may be summary fields at any level below this.
*/
DEFINE VARIABLE sum-check AS LOGICAL   NO-UNDO INIT NO.

DEFINE BUFFER qbf-sparent FOR qbf-section.

/*--------------------------------------------------------------------------*/

FIND FIRST qbf-rsys WHERE qbf-rsys.qbf-live.

qbf-x = qbf-rsys.qbf-width - qbf-rsys.qbf-origin-hz + 1. /* report width */

RUN generate_prolog.

FOR EACH qbf-section
  WHERE NUM-ENTRIES(qbf-section.qbf-sout,".":u) = 1
  BY qbf-section.qbf-sout:
  RUN generate_body (qbf-section.qbf-sout).
END.

RUN generate_epilog. 

RETURN.

/*--------------------------------------------------------------------------*/

PROCEDURE generate_body:
  DEFINE INPUT PARAMETER qbf_s AS CHARACTER NO-UNDO. /* section to start at */

  DEFINE BUFFER qbf_buffer FOR qbf-section.

  FIND FIRST qbf-section WHERE qbf-section.qbf-sout = qbf_s.

  /* If this is start of a master detail section (or the only section)
     do prepass work for all tables which share the same frame.  */
  IF qbf-section.qbf-smdl THEN 
    RUN generate_prepass (qbf_s).

  RUN generate_foreach (qbf_s).

  /* Frames belong scoped to the master block, not the procedure block.  By
     scoping in this way, aggregates are properly displayed for break groups
     and report total -dma 
  */
  FOR EACH qbf_buffer
    WHERE qbf_buffer.qbf-smdl AND qbf_buffer.qbf-sout BEGINS qbf_s
    AND NUM-ENTRIES(qbf_s,".":u) = 1
    BY qbf_buffer.qbf-sfrm:
    RUN generate_frame (qbf_buffer.qbf-sout).
  END.

  RUN generate_calc (qbf_s, NUM-ENTRIES(qbf_s,".":u) * 2,"r,p,c,s,d,n,l,x":u).

  /* A totals only summary can only start at the level where the sort field
     (x-tab sort field) is or below depending on which field is being
     totalled.
  */
  IF NOT sum-check AND qbf-section.qbf-sxtb <> "" THEN
    sum-check = YES.
  IF sum-check THEN
    RUN generate_summary (qbf_s).

  RUN generate_display (qbf_s).

  FOR EACH qbf_buffer
    WHERE qbf_buffer.qbf-sout BEGINS qbf_s + ".":u
      AND NUM-ENTRIES(qbf_buffer.qbf-sout,".":u) = NUM-ENTRIES(qbf_s,".":u) + 1
    BY INTEGER(
      ENTRY(NUM-ENTRIES(qbf_buffer.qbf-sout,".":u),qbf_buffer.qbf-sout,".":u)):
    RUN generate_body (qbf_buffer.qbf-sout).
  END.

  /* moved from c-gen2.i */
  FIND LAST qbf-sparent.
  IF qbf-sparent.qbf-sout = qbf_s AND qbf-governor > 0
    AND ((usage = "g":u AND qbf-govergen) OR usage <> "g":u) THEN DO:

    qbf_m = FILL(' ':u,(NUM-ENTRIES(qbf_s, ".":u) * 2) + 
                         (IF CAN-FIND(FIRST qbf-hsys) THEN 2 ELSE 0)).
    PUT UNFORMATTED
      qbf_m 'qbf-govcnt = qbf-govcnt + 1.':u SKIP
      qbf_m 'IF qbf-govcnt = qbf-governor AND qbf-governor > 0 THEN':u SKIP
      qbf_m '  LEAVE main-loop.':u SKIP(1).
  END.

  RUN generate_end (qbf_s).
END PROCEDURE. /* generate_body */

/*--------------------------------------------------------------------------*/

PROCEDURE generate_prolog:

  DEFINE VARIABLE qbf_h AS LOGICAL INITIAL FALSE NO-UNDO. /* has headers? */
  DEFINE VARIABLE qbf_i AS INTEGER               NO-UNDO. /* scrap/loop */
  DEFINE VARIABLE qbf_t AS CHARACTER INITIAL ""  NO-UNDO. /* table list */

  FOR EACH qbf-section:
    DO qbf_i = 1 TO NUM-ENTRIES(qbf-section.qbf-stbl):
      IF NOT CAN-DO(qbf_t,ENTRY(qbf_i,qbf-section.qbf-stbl)) THEN
        qbf_t = qbf_t + (IF qbf_t = "" THEN "" ELSE ",":u)
              + ENTRY(qbf_i,qbf-section.qbf-stbl).
    END.
  END.

  /* write out initialization stuff for calc fields */
  { aderes/c-gen1.i &genUsage = usage }

  PUT UNFORMATTED
    'DEFINE VARIABLE qbf-govcnt AS INTEGER NO-UNDO.':u SKIP
    'DEFINE VARIABLE qbf-loop   AS INTEGER NO-UNDO.':u SKIP
    'DEFINE VARIABLE qbf-time   AS INTEGER NO-UNDO.':u SKIP(1).

  { aderes/defbufs.i }  /* Define the table buffers */
  PUT UNFORMATTED SKIP(1).

  /* fields for summary report */
  DO qbf_i = 1 TO qbf-rc#:
    IF INDEX(qbf-rcg[qbf_i],"$":u) > 0 AND qbf-summary THEN
      PUT UNFORMATTED
        'DEFINE VARIABLE qbf-':u STRING(qbf_i,"999":u)
          '# AS DECIMAL NO-UNDO.':u SKIP.
    IF INDEX(qbf-rcg[qbf_i],"&":u) > 0 AND NOT qbf-rcc[qbf_i] BEGINS "e":u THEN
      PUT UNFORMATTED
        'DEFINE VARIABLE qbf-':u STRING(qbf_i,"999":u)
        '& LIKE ':u ENTRY(1,qbf-rcn[qbf_i]) 
        ' INITIAL ? NO-UNDO.':u SKIP.
  END.

  PUT UNFORMATTED
    'ASSIGN':u SKIP
    '  qbf-count    = 0':u SKIP
    '  qbf-governor = ':u STRING(qbf-governor) SKIP
    '  qbf-time     = TIME.':u SKIP(1).

  IF usage = "g":u THEN
    PUT UNFORMATTED
      'OUTPUT TO TERMINAL PAGED.':u SKIP(1).

  /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

  /* DO FOR ... record scoping */
  FOR EACH qbf-hsys WHERE qbf-hsys.qbf-hpos > 0 WHILE NOT qbf_h:
    DO qbf_i = 1 TO EXTENT(qbf-hsys.qbf-htxt) WHILE NOT qbf_h:
      qbf_h = qbf-hsys.qbf-htxt[qbf_i] <> "".
    END.
  END.
  IF qbf_h THEN DO:
    PUT UNFORMATTED SKIP 'DO FOR ':u.

    DO qbf_i = 1 TO NUM-ENTRIES(qbf_t):
      {&FIND_TABLE_BY_ID} INTEGER(ENTRY(qbf_i,qbf_t)). 

      PUT UNFORMATTED
        (IF qbf_i = 1 THEN '' ELSE ',':u)
      	qbf-rel-buf.tname.
    END.
    PUT UNFORMATTED ':':u SKIP.
  END.

  /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
  
  /* generate code for all header and footer sections */
  FOR EACH qbf-hsys WHERE qbf-hsys.qbf-hpos > 0:
    ASSIGN
      qbf-hsys.qbf-hgen = ""
      qbf-hsys.qbf-hwid = 0
      qbf-hsys.qbf-hmax = 0.

    DO qbf_i = 1 TO EXTENT(qbf-hsys.qbf-htxt):
      IF qbf-hsys.qbf-htxt[qbf_i] = "" THEN NEXT.

      RUN aderes/c-header.p (qbf-hsys.qbf-htxt[qbf_i], INPUT TRUE,
        OUTPUT qbf-hsys.qbf-hgen[qbf_i], OUTPUT qbf-hsys.qbf-hwid[qbf_i]).

      qbf-hsys.qbf-hmax = MAXIMUM(qbf-hsys.qbf-hmax,
                                  qbf-hsys.qbf-hwid[qbf_i]).
    END.
  END.

  /* parameters: &base, &disp, &first, &last, &name and &page */

  /* 9 = report cover page frame */
  RUN special_headers (9,TRUE,TRUE,"cover":u).
  IF CAN-FIND(FIRST qbf-hsys WHERE qbf-hsys.qbf-hpos = 9) THEN
    PUT UNFORMATTED
      '  DISPLAY WITH FRAME qbf-cover.':u SKIP(1).

  RUN header_footer (1). /* generate header */

  /* 7 = report first-page-only frame */
  RUN special_headers (7,TRUE,FALSE,"first":u).
  IF CAN-FIND(FIRST qbf-hsys WHERE qbf-hsys.qbf-hpos = 7) THEN
    PUT UNFORMATTED
      '  FORM WITH FRAME qbf-first PAGE-TOP.':u SKIP
      '  VIEW FRAME qbf-first.':u SKIP(1).

  IF CAN-FIND(FIRST qbf-hsys WHERE qbf-hsys.qbf-hpos = 9) OR
     CAN-FIND(FIRST qbf-hsys WHERE qbf-hsys.qbf-hpos = 7) THEN
    PUT UNFORMATTED
      '  PAGE.':u SKIP
      '  PUT UNFORMATTED SKIP.':u SKIP /* This forces PROGRESS to flush      */
                                       /* pending page-top frames, so we can */
                                       /* hide this one so it won't show up  */
                                       /* after the first instance.          */
      '  HIDE FRAME qbf-first.':u SKIP(1).
    /* If we don't flush, then this HIDE actually cancels the pending VIEW! */

  RUN header_footer (4). /* generate footer */

  /* 8 = report last-page-only frame */
  RUN special_headers (8,FALSE,TRUE,"last":u).

  /* 10 = report final page frame */
  RUN special_headers (10,TRUE,TRUE,"final":u).

  /* bug 96-06-29-034
  IF qbf_h THEN 
    PUT UNFORMATTED SKIP 'END.':u SKIP(1).
  */
END PROCEDURE. /* generate_prolog */

/*--------------------------------------------------------------------------*/

PROCEDURE generate_epilog:
  qbf_m = IF CAN-FIND(FIRST qbf-hsys) THEN "  ":u ELSE "".

  IF CAN-FIND(FIRST qbf-hsys WHERE qbf-hsys.qbf-hpos = 8) THEN
    PUT UNFORMATTED
      qbf_m 'DISPLAY WITH FRAME qbf-last USE-TEXT STREAM-IO.':u SKIP.

  IF CAN-FIND(FIRST qbf-hsys WHERE qbf-hsys.qbf-hpos = 10) THEN DO:
    PUT UNFORMATTED
      qbf_m 'PAGE.':u SKIP.
    FIND FIRST qbf-hsys WHERE qbf-hsys.qbf-hpos >= 1 
                          AND qbf-hsys.qbf-hpos <= 3 NO-ERROR.
    IF AVAILABLE qbf-hsys THEN
      PUT UNFORMATTED qbf_m 'HIDE FRAME qbf-header.':u SKIP.
    FIND FIRST qbf-hsys WHERE qbf-hsys.qbf-hpos >= 4 
                          AND qbf-hsys.qbf-hpos <= 6 NO-ERROR.
    IF AVAILABLE qbf-hsys THEN
      PUT UNFORMATTED qbf_m 'HIDE FRAME qbf-footer.':u SKIP.
    PUT UNFORMATTED
      qbf_m 'DISPLAY WITH FRAME qbf-final USE-TEXT STREAM-IO.':u SKIP.
  END.

  PUT UNFORMATTED
    qbf_m 'PAGE.':u SKIP.

  IF CAN-FIND(FIRST qbf-hsys) THEN 
    PUT UNFORMATTED
    /* bug 96-06-29-034 */
    'END.':u SKIP(1).

  PUT UNFORMATTED
    'OUTPUT CLOSE.':u SKIP
    'RETURN.':u SKIP.

  /* save RAM */
  FOR EACH qbf-hsys:
    ASSIGN
      qbf-hsys.qbf-hgen = ""
      qbf-hsys.qbf-hwid = 0
      qbf-hsys.qbf-hmax = 0.
  END.
END PROCEDURE. /* generate_epilog */

/*--------------------------------------------------------------------------*/

/* generate FOR-EACH with WHEREs and BREAK-BYs */
PROCEDURE generate_foreach:
  DEFINE INPUT PARAMETER qbf_s AS CHARACTER NO-UNDO. /* qbf-section.qbf-sout */

  DEFINE VARIABLE qbf_c AS CHARACTER NO-UNDO. /* scrap */
  DEFINE VARIABLE qbf_i AS INTEGER   NO-UNDO. /* scrap/loop */
  DEFINE VARIABLE qbf_k AS INTEGER   NO-UNDO. /* count of counters */
  DEFINE VARIABLE qbf_t AS INTEGER   NO-UNDO. /* eject table id */
  DEFINE VARIABLE sexp  AS CHARACTER NO-UNDO. /* sort expression */

  qbf_m = FILL(' ':u,(NUM-ENTRIES(qbf_s,".":u) * 2) 
                      + (IF CAN-FIND(FIRST qbf-hsys) THEN 2 ELSE 0)).

  /* generate FOR EACH and BREAK BY stuff */
  { aderes/c-gen2.i }

  /* page-eject beasty */
  /* if we are page-ejecting on the last break group, and we are also */
  /* doing a summary report, then move the page-eject up one level of */
  /* break group so we don't end up with one record per page.         */
  qbf_i = LOOKUP(qbf-rsys.qbf-page-eject, REPLACE(qbf-sortby," DESC":u,"")).
  
  IF qbf-summary AND qbf_i = NUM-ENTRIES(qbf-sortby) THEN
    qbf_i = qbf_i - 1.

  RUN lookup_table (qbf-rsys.qbf-page-eject, OUTPUT qbf_t).

  FIND FIRST qbf-section WHERE qbf-section.qbf-sout = qbf_s.

  IF CAN-DO(qbf-section.qbf-stbl, STRING(qbf_t)) AND qbf_i > 0 
    AND qbf-sortby > "" THEN
    PUT UNFORMATTED qbf_m
      SUBSTITUTE('  IF FIRST-OF(&1) AND NOT FIRST(&1) THEN PAGE.':u,
                 ENTRY(qbf_i, REPLACE(qbf-sortby," DESC":u,""))) SKIP.
END PROCEDURE. /* generate_foreach */

/*--------------------------------------------------------------------------*/

/* PROCEDURE generate_calc: calc field code for main loop */
{ aderes/c-gen4.i }

/*--------------------------------------------------------------------------*/

/* PROCEDURE generate_prepass: calc field prepass code */
{ aderes/c-gen5.i }

/*--------------------------------------------------------------------------*/

/* PROCEDURE generate_summary: totals only summary code */
{ aderes/c-gen6.i }

/*--------------------------------------------------------------------------*/

PROCEDURE generate_frame:
  DEFINE INPUT PARAMETER qbf_s AS CHARACTER NO-UNDO. /* qbf-section.qbf-sout */

  DEFINE VARIABLE qbf_c AS INTEGER   NO-UNDO. /* scrap/column */
  DEFINE VARIABLE qbf_i AS INTEGER   NO-UNDO. /* scrap/loop */
  DEFINE VARIABLE qbf_j AS INTEGER   NO-UNDO. /* scrap/count */
  DEFINE VARIABLE qbf_k AS INTEGER   NO-UNDO. /* scrap/count */
  DEFINE VARIABLE qbf_l AS CHARACTER NO-UNDO. /* sections using this frame */
  DEFINE VARIABLE qbf_n AS CHARACTER NO-UNDO. /* field name */
  DEFINE VARIABLE qbf_t AS CHARACTER NO-UNDO. /* format */

  DEFINE BUFFER qbf_buffer FOR qbf-section.

  FIND FIRST qbf-section WHERE qbf-section.qbf-sout = qbf_s.

  ASSIGN
    /*qbf_m = "    ":u*/
    qbf_m = IF CAN-FIND(FIRST qbf-hsys) THEN "    ":u ELSE "  ":u
    qbf_j = 0
    qbf_l = "".

  FOR EACH qbf_buffer WHERE qbf_buffer.qbf-sfrm = qbf-section.qbf-sfrm:
    qbf_l = qbf_l + (IF qbf_l = "" THEN "" ELSE ",":u)
          + qbf_buffer.qbf-sout.
  END.

  PUT UNFORMATTED SKIP(1) qbf_m 'FORM':u.

  DO qbf_i = 1 TO qbf-rc#:
    /* if at least one member of qbf_l is in qbf-rcs[qbf_i] then proceed. */
    DO qbf_k = 1 TO NUM-ENTRIES(qbf-rcs[qbf_i]):
      IF CAN-DO(qbf_l,ENTRY(qbf_k,qbf-rcs[qbf_i])) THEN LEAVE.
    END.
    IF qbf_k > NUM-ENTRIES(qbf-rcs[qbf_i]) THEN NEXT.

    IF qbf_j > 0 AND qbf-rsys.qbf-space-hz <> 1 THEN
      PUT UNFORMATTED
        SUBSTITUTE(' SPACE(&1)':u,qbf-rsys.qbf-space-hz).

    ASSIGN
      fldexp = qbf-rcn[qbf_i]
      qbf_j  = qbf_j + 1
      qbf_k  = 0
      qbf_n  = (IF INDEX(qbf-rcg[qbf_i],"$":u) > 0 THEN
                 'qbf-':u + STRING(qbf_i,"999":u) + '#':u
               ELSE
                 ENTRY(1,fldexp))
      qbf_t  = qbf-rcf[qbf_i].

    IF qbf-rcc[qbf_i] BEGINS "e":u THEN
      ASSIGN
        qbf-e = MAXIMUM(qbf-e,INTEGER(SUBSTRING(qbf-rcc[qbf_i],2,-1,
                                                "CHARACTER":u)))
        qbf_n = ENTRY(2,fldexp) + '[qbf-loop]':u.

    /* mash format up for summarized nonnumeric fields */
    IF INDEX(qbf-rcg[qbf_i],"$":u) > 0 AND qbf-rct[qbf_i] < 4 THEN
      ASSIGN qbf_k = {aderes/s-size.i &type=qbf-rct[qbf_i] 
                                      &format=qbf_t} NO-ERROR.
    IF qbf_k > 0 THEN 
      qbf_t = FILL(">":u, qbf_k - 1) + "9":u.

    /* fake-out HH:MM - only problem is we loose aggregate capability */
    /*IF qbf_t BEGINS "HH:MM":u AND qbf-rct[qbf_i] = 4 /*integer*/ THEN
      qbf_t = FILL("9":u, LENGTH(qbf-rcf[qbf_i],"CHARACTER":u)).*/

    PUT UNFORMATTED SKIP
      qbf_m '  ':u qbf_n
        (IF qbf-rcl[qbf_i] = "" THEN
          ' NO-LABEL':u
        ELSE
          ' COLUMN-LABEL "':u + REPLACE(qbf-rcl[qbf_i],'"':u,'""':u) + '"':u
        )
        ' FORMAT "':u REPLACE(qbf_t,"~~":u,"~~~~":u) '"':u.

    IF ENTRY({&R_COL},qbf-rcp[qbf_i]) <> "" OR
       ENTRY({&R_ROW},qbf-rcp[qbf_i]) <> "" THEN
      PUT UNFORMATTED 
        ' AT ROW ':u (IF INTEGER (ENTRY ({&R_ROW},qbf-rcp[qbf_i])) > 0 THEN
                     ENTRY ({&R_ROW},qbf-rcp[qbf_i]) ELSE "1":u)
        ' COLUMN ':u (IF INTEGER (ENTRY ({&R_COL},qbf-rcp[qbf_i])) > 0 THEN
                     ENTRY ({&R_COL},qbf-rcp[qbf_i]) ELSE "1":u)
        .
  END. /* each column */

  IF qbf-rsys.qbf-space-vt > 1 OR 
    (NUM-ENTRIES(qbf-section.qbf-sout,".":u) = 1 AND qbf-detail > 0) THEN
    PUT UNFORMATTED SKIP
      qbf_m '  SKIP(':u MAXIMUM(1,qbf-rsys.qbf-space-vt - 1) ')':u.

  PUT UNFORMATTED SKIP qbf_m
    '  WITH FRAME ':u qbf-section.qbf-sfrm
    ' DOWN COLUMN ':u qbf-rsys.qbf-origin-hz
    ' WIDTH ':u (qbf-rsys.qbf-width - 1 + qbf-rsys.qbf-origin-hz + 20) SKIP
    qbf_m '  NO-ATTR-SPACE NO-VALIDATE NO-BOX USE-TEXT STREAM-IO.':u SKIP(1).
END PROCEDURE. /* generate_frame */

/*--------------------------------------------------------------------------*/

PROCEDURE generate_display:
  DEFINE INPUT PARAMETER qbf_s AS CHARACTER NO-UNDO. /* qbf-section.qbf-sout */

  DEFINE VARIABLE qbf_b AS CHARACTER NO-UNDO. /* brk grp stuff */
  DEFINE VARIABLE qbf_c AS CHARACTER NO-UNDO. /* scrap */
  DEFINE VARIABLE qbf_d AS LOGICAL   NO-UNDO. /* display gen'd? */
  DEFINE VARIABLE qbf_i AS INTEGER   NO-UNDO. /* inner loop */
  DEFINE VARIABLE qbf_k AS INTEGER   NO-UNDO. /* scrap loop */
  DEFINE VARIABLE qbf_l AS CHARACTER NO-UNDO. /* sect disp-list */
  DEFINE VARIABLE qbf_n AS CHARACTER NO-UNDO. /* field name */
  DEFINE VARIABLE qbf_o AS INTEGER   NO-UNDO. /* outer loop */
  DEFINE VARIABLE frst  AS LOGICAL   NO-UNDO. /* first one? */
  DEFINE BUFFER   qbf_sbuffer FOR qbf-section.

  FIND FIRST qbf-section WHERE qbf-section.qbf-sout = qbf_s.
  FIND FIRST qbf_sbuffer WHERE qbf_sbuffer.qbf-sout = qbf_s.

  /* If the field belongs to the current section, then display it. 
     Otherwise, for each parent section where the frame is the 
     same, display those variables as well. This will be the case  
     for an outer join/non-master-detail split query (i.e., 2 
     queries, therefore, 2 sections, but 1 frame) or if we have inner
     join, 1 frame but parent has aggregates and needs it's own loop.
  */
  ASSIGN
    qbf_m = FILL(' ':u,(NUM-ENTRIES(qbf_s, ".":u) * 2) 
                        + (IF CAN-FIND(FIRST qbf-hsys) THEN 4 ELSE 2))
    qbf_c = qbf_s
    qbf_l = qbf_s.

  DO WHILE NUM-ENTRIES(qbf_c,".":u) > 1:
    qbf_c = SUBSTRING(qbf_c,1,MAXIMUM(R-INDEX(qbf_c,".":u) - 1,0),
                      "CHARACTER":u).
    FIND FIRST qbf_sbuffer WHERE qbf_sbuffer.qbf-sout = qbf_c AND
      	       qbf_sbuffer.qbf-sfrm = qbf-section.qbf-sfrm NO-ERROR.
    IF NOT AVAILABLE qbf_sbuffer THEN LEAVE.
    qbf_l = qbf_l + ",":u + qbf_c.
  END.

  DO qbf_o = 1 TO qbf-rc#:
    /* if at least one member of qbf_l is in qbf-rcs[qbf_o] then proceed. */
    DO qbf_k = 1 TO NUM-ENTRIES(qbf-rcs[qbf_o]):
      IF CAN-DO(qbf_l,ENTRY(qbf_k,qbf-rcs[qbf_o])) THEN LEAVE.
    END.
    IF qbf_k > NUM-ENTRIES(qbf-rcs[qbf_o]) THEN NEXT.

    fldexp = qbf-rcn[qbf_o].
    IF NOT qbf_d THEN
      PUT UNFORMATTED
        SUBSTRING(qbf_m,3,-1,"CHARACTER":u) 'DISPLAY':u SKIP.

    ASSIGN
      qbf_d = TRUE
      qbf_n = (IF INDEX(qbf-rcg[qbf_o],"$":u) > 0 AND qbf-summary THEN
                'qbf-':u + STRING(qbf_o,"999":u) + '#':u
              ELSE
                ENTRY(IF qbf-rcc[qbf_o] BEGINS "e":u THEN 2 ELSE 1,
                  fldexp)
              ).

    IF qbf-rcc[qbf_o] BEGINS "e":u THEN /* stacked array */
      PUT UNFORMATTED
        qbf_m qbf_n '[1] @ ':u qbf_n '[qbf-loop]':u SKIP.
    ELSE IF qbf-rcc[qbf_o] BEGINS "x":u THEN DO: /* lookup field */
      /* see comment below */
      IF qbf-rcg[qbf_o] <> "&":u
        OR qbf-rcg[qbf_o] = "&":u AND CAN-DO(qbf-rcs[qbf_o],qbf_s) THEN DO:
        PUT UNFORMATTED
          qbf_m qbf_n ' WHEN ':u qbf_n ' <> ?':u.
        IF qbf-rcg[qbf_o] = "&":u THEN
          PUT UNFORMATTED
           ' AND ':u qbf_n ' <> qbf-':u STRING(qbf_o,"999":u) '&':u.
        PUT UNFORMATTED
          SKIP
          qbf_m '"':u ENTRY(7,fldexp) '" WHEN ':u 
        qbf_n ' = ?':u.
        IF qbf-rcg[qbf_o] = "&":u THEN
          PUT UNFORMATTED
   	    ' AND ':u qbf_n ' <> qbf-':u STRING(qbf_o,"999":u) '&':u.
        PUT UNFORMATTED
          ' @ ':u qbf_n SKIP.
      END.
    END.
    ELSE IF qbf-rcg[qbf_o] = "&":u AND NOT qbf-rcc[qbf_o] BEGINS "e":u THEN DO:
      /* Hide repeating values 
         No need to display ever in this block, if hide-repeating-values 
         set AND this field comes from a higher-level FOR-EACH group.    
      */
      IF CAN-DO(qbf-rcs[qbf_o],qbf_s) THEN
        PUT UNFORMATTED
          qbf_m qbf_n
           ' WHEN ':u qbf_n ' <> qbf-':u STRING(qbf_o,"999":u) '&':u SKIP.
    END.
    ELSE IF qbf-rcg[qbf_o] = "" OR qbf-rcg[qbf_o] = "$":u OR
      	    qbf-rcs[qbf_o] <> qbf_s THEN  
      /* Non aggregate (rcg = nothing or just total only summary) OR
      	 if it is an aggregate but this field is not in this section,
      	 we want to print the value but not add to the aggregate.
      	 For example, for 1 section outer join, if parent is involved
      	 in a total, we want to print parent field in child for each loop
      	 but only add into total once in parent for each loop.
      */
      PUT UNFORMATTED qbf_m qbf_n SKIP.
    ELSE 
      /* We have an aggregate that we want to process. */
      DO qbf_i = 1 TO NUM-ENTRIES(qbf-sortby) + 1:
	ASSIGN
	  qbf_b = STRING(IF qbf_i = NUM-ENTRIES(qbf-sortby) + 1 
      	       	  THEN 0 ELSE qbf_i)
	  qbf_b = (IF INDEX(qbf-rcg[qbf_o],"a":u + qbf_b) > 0
		  THEN ' SUB-AVERAGE':u ELSE '')
		+ (IF INDEX(qbf-rcg[qbf_o],"n":u + qbf_b) > 0
		  THEN ' SUB-MINIMUM':u ELSE '')
		+ (IF INDEX(qbf-rcg[qbf_o],"x":u + qbf_b) > 0
		  THEN ' SUB-MAXIMUM':u ELSE '')
		+ (IF INDEX(qbf-rcg[qbf_o],"c":u + qbf_b) > 0
		  THEN ' SUB-COUNT':u   ELSE '')
		+ (IF INDEX(qbf-rcg[qbf_o],"t":u + qbf_b) > 0
		  THEN ' SUB-TOTAL':u   ELSE '')
	  qbf_b = SUBSTRING(qbf_b,2,-1,"CHARACTER":u).

	IF qbf_b = "" THEN NEXT.

	IF qbf_i <= NUM-ENTRIES(qbf-sortby) THEN DO:

          /* Is this a calculated field? */
          DO qbf_k = 1 TO qbf-rc#:
            IF ENTRY(1,qbf-rcn[qbf_k]) =
              REPLACE(ENTRY(qbf_i,qbf-sortby)," DESC":u,"") THEN LEAVE.
          END.

          IF qbf_k <= qbf-rc# AND qbf-rcc[qbf_k] > "" THEN
            qbf_c = "(":u
                  + SUBSTRING(qbf-rcn[qbf_k],INDEX(qbf-rcn[qbf_k],",":u) + 1,
                              -1,"CHARACTER":U)
                  + ")":u
                  .
          ELSE
            qbf_c = ENTRY(1,ENTRY(qbf_i,qbf-sortby)," ":u).

	  qbf_b = qbf_b + " BY ":u + qbf_c.
        END.

	PUT UNFORMATTED qbf_m qbf_n ' (':u qbf_b ')':u SKIP.
      END.
  END. /* end of loop over all fields */

  IF qbf_d THEN
    PUT UNFORMATTED
      qbf_m 'WITH FRAME ':u qbf-section.qbf-sfrm '.':u SKIP(1).

  /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
  /* stacked array stuff */

  IF qbf_d AND qbf-e > 1 THEN DO:

    frst = TRUE.
    DO qbf_o = 1 TO qbf-rc#:
      IF NOT CAN-DO(qbf-rcs[qbf_o],qbf_s)
        OR NOT qbf-rcc[qbf_o] BEGINS "e":u THEN NEXT.

      /* Don't want this unless there is an array field for this section.
      	 Otherwise we get a bunch of empty space 
      */
      IF frst THEN DO:
	PUT UNFORMATTED
	  qbf_m 'DO qbf-loop = 2 TO ':u STRING(qbf-e) ':':u SKIP
	  qbf_m '  DOWN WITH FRAME ':u qbf-section.qbf-sfrm '.':u SKIP
	  qbf_m '  CLEAR FRAME ':u qbf-section.qbf-sfrm '.':u SKIP
	  qbf_m '  DISPLAY':u SKIP.
      	frst = FALSE.
      END.

      qbf_n = ENTRY(2,qbf-rcn[qbf_o]).
      PUT UNFORMATTED
        qbf_m '    ':u qbf_n '[qbf-loop]':u
        (IF INTEGER(SUBSTRING(qbf-rcc[qbf_o],2,-1,"CHARACTER":u)) < qbf-e
          THEN ' WHEN qbf-loop <= ':u 
             + SUBSTRING(qbf-rcc[qbf_o],2,-1,"CHARACTER":u)
          ELSE '') SKIP.
    END.
    IF frst = FALSE THEN
      PUT UNFORMATTED
	qbf_m '    WITH FRAME ':u qbf-section.qbf-sfrm '.':u SKIP
	qbf_m 'END.':u SKIP.
  END.
END PROCEDURE. /* generate_display */

/*--------------------------------------------------------------------------*/

PROCEDURE generate_end:
  DEFINE INPUT PARAMETER qbf_s AS CHARACTER NO-UNDO. /* qbf-section.qbf-sout */

  DEFINE VARIABLE qbf_i AS INTEGER   NO-UNDO. /* scrap */
  DEFINE VARIABLE qbf_k AS INTEGER   NO-UNDO. /* hide-rep-vals pseudo-count */
  DEFINE VARIABLE qbf_b AS CHARACTER NO-UNDO. /* order-by field */

  FIND FIRST qbf-section WHERE qbf-section.qbf-sout = qbf_s.

  ASSIGN
    qbf_m = FILL(' ':u,(NUM-ENTRIES(qbf_s, ".":u) * 2) + 
                        + (IF CAN-FIND(FIRST qbf-hsys) THEN 2 ELSE 0))
    qbf_k = 0. /* =0 for no hides, =1 for one hide, =2 for >1 hides */

  /* Hide Repeating Value assignments */
  DO qbf_i = 1 TO qbf-rc# WHILE qbf_k < 2:
    IF    CAN-DO(qbf-rcs[qbf_i],qbf_s)
      AND INDEX(qbf-rcg[qbf_i],"&":u) > 0
      AND NOT qbf-rcc[qbf_i] BEGINS "e":u THEN qbf_k = qbf_k + 1.
  END.

  IF qbf_k > 0 THEN DO:
    IF qbf_k > 1 THEN PUT UNFORMATTED qbf_m 'ASSIGN':u.
    DO qbf_i = 1 TO qbf-rc#:
      IF   NOT CAN-DO(qbf-rcs[qbf_i],qbf_s)
        OR INDEX(qbf-rcg[qbf_i],"&":u) = 0
        OR qbf-rcc[qbf_i] BEGINS "e":u THEN NEXT.

      IF qbf_k > 1 THEN PUT UNFORMATTED SKIP qbf_m.
      PUT UNFORMATTED
        qbf_m 'qbf-':u STRING(qbf_i,"999":u) '& = ':u 
        ENTRY(1,qbf-rcn[qbf_i]).
    END.
    PUT UNFORMATTED '.':u SKIP.
  END.

  /* down phrase - only do it if no totals only summary or if we've started 
     a totals only summary and this is the section with the summary sort
     field - and then only do it for last of the group.
  */
  IF NOT qbf-summary OR qbf-section.qbf-sxtb <> "" THEN DO:
    IF qbf-summary THEN DO:
      qbf_b = ENTRY(1,ENTRY(NUM-ENTRIES(qbf-sortby),qbf-sortby)," ":u).

      /* If qbf_b is a calc field, then convert to 4GL */
      DO qbf_i = 1 TO qbf-rc#:
        IF ENTRY(1,qbf-rcn[qbf_i]) = qbf_b AND qbf-rcc[qbf_i] > "" THEN DO:
          qbf_b = SUBSTRING(qbf-rcn[qbf_i],INDEX(qbf-rcn[qbf_i],",":u) + 1,-1,
                            "CHARACTER":u).
          LEAVE.
        END.
      END.

      PUT UNFORMATTED
        qbf_m 'IF LAST-OF(':u qbf_b ') THEN':u SKIP
      	'  ':u.
    END.
    PUT UNFORMATTED
      qbf_m 'DOWN WITH FRAME ':u qbf-section.qbf-sfrm '.':u SKIP.
  END.

  /* write out the "end" for the for-each loop */
  PUT UNFORMATTED
    SUBSTRING(qbf_m,3,-1,"CHARACTER":u) 'END.':u.

  /* looking for the first qbf-section (sparent) record and testing the value
     of sout is intended to force RESULTS to insert a blank line between the
     last detail record and the next master record.  This should only come 
     into play for master-detail reports. -dma
  */
  FIND FIRST qbf-sparent.
  IF qbf-section.qbf-sout > qbf-sparent.qbf-sout AND qbf-detail > 0 THEN DO:

    PUT UNFORMATTED SKIP
      SUBSTRING(qbf_m,3,-1,"CHARACTER":u)
      'DISPLAY WITH FRAME ':u qbf-section.qbf-sfrm '.':u.
  END.

  PUT UNFORMATTED SKIP(1).
END PROCEDURE. /* generate_end */

/*--------------------------------------------------------------------------*/

/* generate first-page-only or last-page-only frames */
/* also does work for cover-page and final-page frames */
/* used to be include file s-gen6.i */

PROCEDURE special_headers:
  DEFINE INPUT PARAMETER qbf_b AS INTEGER   NO-UNDO. /* was: {&base} */
  DEFINE INPUT PARAMETER qbf_f AS LOGICAL   NO-UNDO. /* was: {&first} */
  DEFINE INPUT PARAMETER qbf_l AS LOGICAL   NO-UNDO. /* was: {&last} */
  DEFINE INPUT PARAMETER qbf_n AS CHARACTER NO-UNDO. /* was: {&name} */

  DEFINE VARIABLE qbf_i AS INTEGER NO-UNDO. /* scrap/loop */
  DEFINE VARIABLE qbf_j AS INTEGER NO-UNDO. /* scrap/loop */
  DEFINE VARIABLE qbf_p AS INTEGER NO-UNDO. /* space */

  FIND FIRST qbf-hsys WHERE qbf-hsys.qbf-hpos = qbf_b NO-ERROR.
  IF NOT AVAILABLE qbf-hsys THEN RETURN.

  PUT UNFORMATTED '  FORM HEADER':u.
  IF qbf_l THEN PUT UNFORMATTED SKIP '    SKIP(1)':u.
  qbf_p = MAXIMUM(0,(qbf-x - qbf-hsys.qbf-hmax) / 2).

  /* find # of usable lines */
  DO qbf_j = EXTENT(qbf-hsys.qbf-htxt) TO 1 BY -1:
    IF TRIM(qbf-hsys.qbf-htxt[qbf_j]) <> "" THEN LEAVE.
  END.

  DO qbf_i = 1 TO qbf_j:
    PUT UNFORMATTED SKIP '    ':u.

    IF qbf_p >= 0 AND qbf-hsys.qbf-hgen[qbf_i] > "" THEN
      PUT UNFORMATTED '"':u + FILL(' ',MAXIMUM(0,qbf_p)) + '"':u.

    IF qbf-hsys.qbf-hgen[qbf_i] > "" THEN
      PUT UNFORMATTED ' + ':u.

    IF qbf_i <= EXTENT(qbf-hsys.qbf-htxt) THEN
      PUT UNFORMATTED qbf-hsys.qbf-hgen[qbf_i] 
        ' FORMAT "x(':u STRING(qbf-rsys.qbf-width) ')" SKIP':u.
  END.

  IF qbf_f THEN PUT UNFORMATTED SKIP '    SKIP(1)':u.
  PUT UNFORMATTED SKIP
    '    WITH FRAME qbf-':u qbf_n ' COLUMN ':u qbf-rsys.qbf-origin-hz
    ' WIDTH ':u MAXIMUM(qbf-rsys.qbf-width - 1 + qbf-rsys.qbf-origin-hz + 20,
                        qbf-hsys.qbf-hmax)
    ' NO-ATTR-SPACE NO-LABELS NO-VALIDATE ':u SKIP
    '    NO-BOX USE-TEXT STREAM-IO.':u SKIP(1).
END PROCEDURE. /* special_headers */

/*--------------------------------------------------------------------------*/

/*
We try to lay out header frames like this:
  |  center  |
  |left right|
but if the left and/or right are too long, we
will do this:
  |  center  |
  |left>>>>  |
  |  <<<right|
The algorithm interleaves the left and right, so
something with mixed long and short lines ends up
looking like this:
  |  center  |
  |  center  |
  |left>>>>  |
  |  <<<right|
  |left right|
*/

PROCEDURE header_footer:
  DEFINE INPUT PARAMETER qbf_t AS INTEGER NO-UNDO. /* 1=header 4=footer */

  DEFINE BUFFER qbf-hleft   FOR qbf-hsys.
  DEFINE BUFFER qbf-hcenter FOR qbf-hsys.
  DEFINE BUFFER qbf-hright  FOR qbf-hsys.

  DEFINE VARIABLE qbf_i  AS INTEGER NO-UNDO. /* inner loop and scrap */
  DEFINE VARIABLE qbf_j  AS INTEGER NO-UNDO. /* scrap */
  DEFINE VARIABLE qbf_hl AS INTEGER NO-UNDO. /* # left lines */
  DEFINE VARIABLE qbf_hc AS INTEGER NO-UNDO. /* # center lines */
  DEFINE VARIABLE qbf_hr AS INTEGER NO-UNDO. /* # right lines */
  DEFINE VARIABLE qbf_l  AS INTEGER NO-UNDO. /* line counter */
  DEFINE VARIABLE qbf_o  AS INTEGER NO-UNDO. /* outer loop */
  DEFINE VARIABLE qbf_w  AS INTEGER NO-UNDO. /* widths */

  FIND FIRST qbf-hleft   WHERE qbf-hleft.qbf-hpos   = qbf_t     NO-ERROR.
  FIND FIRST qbf-hcenter WHERE qbf-hcenter.qbf-hpos = qbf_t + 1 NO-ERROR.
  FIND FIRST qbf-hright  WHERE qbf-hright.qbf-hpos  = qbf_t + 2 NO-ERROR.

  IF    NOT AVAILABLE qbf-hleft
    AND NOT AVAILABLE qbf-hcenter
    AND NOT AVAILABLE qbf-hright THEN NEXT.

  /* find # of usable left header/footer lines */
  IF AVAILABLE qbf-hleft THEN
  DO qbf_hl = EXTENT(qbf-hsys.qbf-htxt) TO 1 BY -1:
    IF TRIM(qbf-hleft.qbf-htxt[qbf_hl]) <> "" THEN LEAVE.
  END.
 
  /* find # of usable center header/footer lines */
  IF AVAILABLE qbf-hcenter THEN
  DO qbf_hc = EXTENT(qbf-hsys.qbf-htxt) TO 1 BY -1:
    IF TRIM(qbf-hcenter.qbf-htxt[qbf_hc]) <> "" THEN LEAVE.
  END.
 
  /* find # of usable right header/footer lines */
  IF AVAILABLE qbf-hright THEN
  DO qbf_hr = EXTENT(qbf-hsys.qbf-htxt) TO 1 BY -1:
    IF TRIM(qbf-hright.qbf-htxt[qbf_hr]) <> "" THEN LEAVE.
  END.
 
  qbf_l = MAXIMUM(qbf_hl,qbf_hc,qbf_hr).

  /* if we can put left and right lines side-by-side, then do it now. */
  IF qbf_hl > 0 AND qbf_hr > 0 THEN
    DO qbf_i = 1 TO qbf_l:
      qbf_w = qbf-hleft.qbf-hwid[qbf_i] + qbf-hright.qbf-hwid[qbf_i].
      IF qbf_w < qbf-x THEN
        ASSIGN
          qbf-hleft.qbf-hgen[qbf_i]  =
            (IF qbf-hleft.qbf-hwid[qbf_i] = 0 AND
                qbf-hright.qbf-hwid[qbf_i] = 0 
      	     THEN ' ':u 
             ELSE 
      	       (qbf-hleft.qbf-hgen[qbf_i] +
                 (IF qbf-hright.qbf-hgen[qbf_i] > "" 
      	       	  THEN
      	       	    (IF qbf-hleft.qbf-hgen[qbf_i] > "" 
      	       	      THEN ' + "':u
      	              ELSE '"':u)
                     + FILL(' ':u, MAXIMUM(0, qbf-x - qbf_w)) + '" + ':u
                     + qbf-hright.qbf-hgen[qbf_i]
                  ELSE '')))
          qbf-hleft.qbf-hwid[qbf_i]  = qbf-x
          qbf-hright.qbf-hgen[qbf_i] = ''
          qbf-hright.qbf-hwid[qbf_i] = 0
      	  qbf_hl = MAX(qbf_hl, qbf_hr).
    END.

  /* generate right portion of headers and footers */
  IF qbf_hr > 0 THEN
    DO qbf_i = 1 TO qbf_l:
      qbf_w = qbf-hright.qbf-hwid[qbf_i].
      qbf-hright.qbf-hgen[qbf_i] = 
        (IF qbf-hright.qbf-hwid[qbf_i] = 0 THEN ' ':u
         ELSE ('"' + FILL(' ':u, MAXIMUM(0, qbf-x - qbf_w)) + '" + ':u
                   + qbf-hright.qbf-hgen[qbf_i])).
    END.

  /* generate 'centered' portion of headers and footers */
  IF qbf_hc > 0 THEN
    DO qbf_i = 1 TO qbf_l:
      qbf_w = MAXIMUM(0,(qbf-x - qbf-hcenter.qbf-hwid[qbf_i]) / 2).
      IF qbf-hcenter.qbf-hwid[qbf_i] > 0 THEN
        qbf-hcenter.qbf-hgen[qbf_i] =
          ('"':u + FILL(' ':u, qbf_w) + '" + ':u + qbf-hcenter.qbf-hgen[qbf_i]).
    END.

  /* now write out form definition */
  PUT UNFORMATTED '  FORM HEADER':u.
  qbf_i = (IF qbf_t = 1  AND qbf-rsys.qbf-origin-vt > 1 THEN
            qbf-rsys.qbf-origin-vt 
          ELSE IF qbf_t <> 1 AND qbf-rsys.qbf-body-footer > 0 THEN
            qbf-rsys.qbf-body-footer
          ELSE
            ?).

  IF qbf_i <> ? THEN
    PUT UNFORMATTED SKIP '    SKIP(':u qbf_i ')':u.

  qbf_j = 0.
  DO qbf_o = 1 TO 3:
    FIND FIRST qbf-hsys WHERE qbf-hsys.qbf-hpos =
      INTEGER(ENTRY(qbf_o,STRING(qbf_t = 1,"2,1,3/4,6,5":u))) NO-ERROR.
    IF NOT AVAILABLE qbf-hsys THEN NEXT.

    CASE qbf-hsys.qbf-hpos:
      WHEN 1 OR WHEN 4 THEN qbf_l = qbf_hl.
      WHEN 2 OR WHEN 5 THEN qbf_l = qbf_hc.
      WHEN 3 OR WHEN 6 THEN qbf_l = qbf_hr.
    END CASE.

    DO qbf_i = 1 TO qbf_l:
      IF qbf_hl > 0 AND qbf_hr > 0 AND qbf_o > 1
        AND (qbf-hsys.qbf-hpos = 3 OR qbf-hsys.qbf-hpos = 6) THEN NEXT.

      IF LENGTH(TRIM(qbf-hsys.qbf-hgen[qbf_i]),"CHARACTER":u) = 0 THEN 
        PUT UNFORMATTED SKIP
          '    " " SKIP':u.
      ELSE DO:
        IF INDEX(qbf-hsys.qbf-hgen[qbf_i],"+":u) = 0 THEN
          qbf-hsys.qbf-hgen[qbf_i] = TRIM(qbf-hsys.qbf-hgen[qbf_i])
                                   + ' + ""':u.

        PUT UNFORMATTED SKIP
          '    ':u TRIM(qbf-hsys.qbf-hgen[qbf_i])
          ' FORMAT "x(':u STRING(qbf-rsys.qbf-width) ')" SKIP':u.
      END.

      qbf_j = qbf_j + 1.
    END. 
  END.

  IF qbf_t = 1 AND qbf-rsys.qbf-header-body > 0 THEN
    PUT UNFORMATTED
      (IF qbf_j = 0 THEN ' SKIP':u ELSE '')
      '(':u qbf-rsys.qbf-header-body ') ':u.

  PUT UNFORMATTED SKIP
    '    WITH FRAME qbf-':u STRING(qbf_t = 1,"header/footer":u)
    ' PAGE-':u (IF qbf_t = 1 THEN "TOP":u ELSE "BOTTOM":u)
    ' COLUMN ':u qbf-rsys.qbf-origin-hz 
    ' WIDTH ':u MAXIMUM(qbf-x,
                        qbf-rsys.qbf-width - 1 + qbf-rsys.qbf-origin-hz + 20)
    ' NO-ATTR-SPACE ':u SKIP
    '    NO-VALIDATE NO-LABELS NO-BOX USE-TEXT STREAM-IO.':u SKIP
    '  VIEW FRAME qbf-':u STRING(qbf_t = 1,"header/footer":u) '.':u SKIP(1).
END PROCEDURE. /* procedure header_footer */

/*--------------------------------------------------------------------------*/

/* alias_to_tbname */
{ aderes/s-alias.i }

/*--------------------------------------------------------------------------*/

/* lookup table id */
{ aderes/p-lookup.i }

/*--------------------------------------------------------------------------*/

/* r-write.p - end of file */

