/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * e-write.p - generate export program wrapper
*/

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/e-define.i }
{ aderes/r-define.i }
{ aderes/j-define.i }

DEFINE INPUT PARAMETER usage AS CHARACTER NO-UNDO.

DEFINE VARIABLE qbf-c  AS CHARACTER  NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-i  AS INTEGER    NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-j  AS INTEGER    NO-UNDO. /* scrap */
DEFINE VARIABLE qbf_m  AS CHARACTER  NO-UNDO. /* indent margin */
DEFINE VARIABLE qbf-u  AS CHARACTER  NO-UNDO. /* program to run */
DEFINE VARIABLE qbf-l  AS LOGICAL    NO-UNDO.
DEFINE VARIABLE fldexp AS CHARACTER  NO-UNDO. /* qbf-rcn element */

/* sum-check tells us whether to check for totals only summary fields.
   It's set to yes as soon as we hit the level where the summary sort
   field is.  There may be summary fields at any level below this.
*/
DEFINE VARIABLE sum-check AS LOGICAL   NO-UNDO INIT NO.

DEFINE BUFFER qbf-sparent FOR qbf-section.

&GLOBAL-DEFINE SET_FLD_NAME ~
    IF INDEX(qbf-rcg[qbf_i],"$":u) > 0 AND qbf-summary THEN ~
      qbf_n = 'qbf-':u + STRING(qbf_i,"999") + '#':u. ~
    ELSE DO: ~
      qbf_n = ENTRY(IF qbf-rcc[qbf_i] BEGINS "e":u THEN 2 ELSE 1, ~
                    qbf-rcn[qbf_i]). ~
    END. 

/*--------------------------------------------------------------------------*/

FIND FIRST qbf-rsys WHERE qbf-rsys.qbf-live.
FIND FIRST qbf-esys.

qbf-u = (IF qbf-esys.qbf-type BEGINS "USER-":u THEN
          qbf-esys.qbf-program
        ELSE
          "aderes/":u + qbf-esys.qbf-program).

/* generate code for PUT CONTROL statements */
RUN control_codes (qbf-esys.qbf-lin-beg, OUTPUT qbf-esys.qbf-code[1]).
RUN control_codes (qbf-esys.qbf-lin-end, OUTPUT qbf-esys.qbf-code[2]).
RUN control_codes (qbf-esys.qbf-fld-dlm, OUTPUT qbf-esys.qbf-code[3]).
RUN control_codes (qbf-esys.qbf-fld-sep, OUTPUT qbf-esys.qbf-code[4]).
/*
qbf-esys.qbf-code[1] -> qbf-esys.qbf-lin-beg - line starter
qbf-esys.qbf-code[2] -> qbf-esys.qbf-lin-end - line delimiter
qbf-esys.qbf-code[3] -> qbf-esys.qbf-fld-dlm - field delimiter
qbf-esys.qbf-code[4] -> qbf-esys.qbf-fld-sep - field separator
*/

RUN generate_prolog. /* *************************************************** */

FOR EACH qbf-section
  WHERE NUM-ENTRIES(qbf-section.qbf-sout,".":u) = 1
  BY qbf-section.qbf-sout:
  RUN generate_body (qbf-section.qbf-sout). /* **************************** */
END.

RUN generate_epilog. /* *************************************************** */

RETURN.

/*--------------------------------------------------------------------------*/

PROCEDURE generate_body:
  DEFINE INPUT PARAMETER qbf_s AS CHARACTER NO-UNDO. /* section to start at */

  DEFINE BUFFER qbf_buffer FOR qbf-section.

  FIND FIRST qbf-section WHERE qbf-section.qbf-sout = qbf_s.

  /* If this is start of a master detail section (or the only section)
     do prepass work for all tables which share the same frame.
  */
  IF qbf-section.qbf-smdl THEN 
    RUN generate_prepass (qbf_s).
  RUN generate_foreach (qbf_s).
  RUN generate_calc    (qbf_s, NUM-ENTRIES(qbf_s,".":u) * 2, "r,p,c,s,d,n,l,x").

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

    qbf_m = FILL(' ':u, NUM-ENTRIES(qbf_s, ".":u) * 2).
    PUT UNFORMATTED
      qbf_m 'qbf-govcnt = qbf-govcnt + 1.':u SKIP
      qbf_m 'IF qbf-govcnt = qbf-governor AND qbf-governor > 0 THEN':u SKIP
      qbf_m '  LEAVE main-loop.':u SKIP(1).
  END.

  RUN generate_end (qbf_s).
END PROCEDURE. /* generate_body */

/*--------------------------------------------------------------------------*/

PROCEDURE generate_count:
  DEFINE INPUT PARAMETER qbf_s AS CHARACTER NO-UNDO. /* section to start at */

  DEFINE BUFFER qbf_buffer FOR qbf-section.

  FIND FIRST qbf-section WHERE qbf-section.qbf-sout = qbf_s.

  RUN generate_foreach (qbf_s).

  FOR EACH qbf_buffer
    WHERE qbf_buffer.qbf-sout BEGINS qbf_s + ".":u
      AND NUM-ENTRIES(qbf_buffer.qbf-sout,".":u) = NUM-ENTRIES(qbf_s,".":u) + 1
    BY INTEGER(
      ENTRY(NUM-ENTRIES(qbf_buffer.qbf-sout,".":u),qbf_buffer.qbf-sout,".":u)):
    RUN generate_count (qbf_buffer.qbf-sout).
  END.

  RUN generate_end (qbf_s).
END PROCEDURE. /* generate_count */

/*--------------------------------------------------------------------------*/

PROCEDURE generate_prolog:

  DEFINE VARIABLE qbf_i AS INTEGER               NO-UNDO. /* scrap/loop */
  DEFINE VARIABLE qbf_t AS CHARACTER INITIAL ""  NO-UNDO. /* table list */
  DEFINE VARIABLE qbf_n AS CHARACTER             NO-UNDO. /* field name */

  FOR EACH qbf-section:
    DO qbf_i = 1 TO NUM-ENTRIES(qbf-section.qbf-stbl):
      IF NOT CAN-DO(qbf_t,ENTRY(qbf_i,qbf-section.qbf-stbl)) THEN
        qbf_t = qbf_t + (IF qbf_t = "" THEN "" ELSE ",":u)
              + ENTRY(qbf_i,qbf-section.qbf-stbl).
    END.
  END.

  /* write out initialization stuff for calc fields */
  { aderes/c-gen1.i &genUsage = usage}

  PUT UNFORMATTED
    'DEFINE VARIABLE qbf-govcnt  AS INTEGER   NO-UNDO.':u SKIP
    'DEFINE VARIABLE qbf-loop    AS INTEGER   NO-UNDO.':u SKIP
    'DEFINE VARIABLE qbf-unknown AS CHARACTER NO-UNDO INITIAL ?.':u SKIP
    'DEFINE VARIABLE qbf-time    AS INTEGER   NO-UNDO.':u SKIP(1).

  { aderes/defbufs.i }  /* Define the table buffers */
  PUT UNFORMATTED SKIP(1).

  /* fields for summary report */
  DO qbf_i = 1 TO qbf-rc#:
    IF INDEX(qbf-rcg[qbf_i],"$":u) > 0 AND qbf-summary THEN
      PUT UNFORMATTED
        'DEFINE VARIABLE qbf-':u STRING(qbf_i,"999":u)
          '# AS DECIMAL NO-UNDO.':u SKIP.
  END.

  PUT UNFORMATTED
    'ASSIGN' SKIP
    '  qbf-count    = 0':u SKIP
    '  qbf-governor = ' STRING(qbf-governor) SKIP
    '  qbf-time     = TIME.':u SKIP(1).

  IF usage = "g":u THEN 
    PUT UNFORMATTED 'OUTPUT TO export.dat.':u SKIP(1).

  IF qbf-esys.qbf-prepass THEN DO:
    FOR EACH qbf-section
      WHERE NUM-ENTRIES(qbf-section.qbf-sout,".":u) = 1
      BY INTEGER(ENTRY(1,qbf-section.qbf-sout,".":u)):
      RUN generate_count (qbf-section.qbf-sout).
    END.
  END.

  DO qbf_i = 1 TO qbf-rc#:
    {&SET_FLD_NAME} /* sets qbf_n */
    DO ON STOP UNDO, LEAVE:
      RUN VALUE (qbf-u) (
        "p":u,
        qbf_n,
        qbf-rcl[qbf_i],
        qbf-rcf[qbf_i],
        qbf_i,
        qbf-rct[qbf_i],
        "",
        qbf_i = 1,
        qbf_i = qbf-rc#,
      	qbf-rcc[qbf_i] BEGINS "x",
      	(IF qbf-rcc[qbf_i] BEGINS "x" THEN ENTRY(7,qbf-rcn[qbf_i]) ELSE "")
        ) NO-ERROR.
    END.

    IF (ERROR-STATUS:ERROR <> FALSE) THEN
      RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l,"error":u,"ok":u,
        SUBSTITUTE("The program that was generated would not compile.  Contact your Systems Administrator for further assistance with the following codes:^^Last five message codes: &1, &2, &3, &4, &5."),
        _MSG(1),_MSG(2),_MSG(3),_MSG(4),_MSG(5)).
  END.

  IF qbf-esys.qbf-prepass THEN
    PUT UNFORMATTED 'qbf-count = 0.':u SKIP.
END PROCEDURE. /* generate_prolog */

/*--------------------------------------------------------------------------*/

PROCEDURE generate_epilog:
  DEFINE VARIABLE qbf_i AS INTEGER   NO-UNDO. /* loop */
  DEFINE VARIABLE qbf_n AS CHARACTER NO-UNDO. /* field name */

  DO qbf_i = 1 TO qbf-rc#:
    {&SET_FLD_NAME} /* sets qbf_n */
    RUN VALUE(qbf-u) (
      "e":u,
      qbf_n,
      qbf-rcl[qbf_i],
      qbf-rcf[qbf_i],
      qbf_i,
      qbf-rct[qbf_i],
      "",
      qbf_i = 1,
      qbf_i = qbf-rc#,
      qbf-rcc[qbf_i] BEGINS "x",
      (IF qbf-rcc[qbf_i] BEGINS "x" THEN ENTRY(7,qbf-rcn[qbf_i]) ELSE "")
      ).
  END.

  PUT UNFORMATTED 'RETURN.':u SKIP.
END PROCEDURE. /* generate_epilog */

/*--------------------------------------------------------------------------*/

/* generate FOR-EACH with WHEREs and BREAK-BYs */
PROCEDURE generate_foreach:
  DEFINE INPUT PARAMETER qbf_s AS CHARACTER NO-UNDO. /* qbf-section.qbf-sout */

  DEFINE VARIABLE qbf_c AS CHARACTER NO-UNDO. /* scrap */
  DEFINE VARIABLE qbf_i AS INTEGER   NO-UNDO. /* scrap/loop */
  DEFINE VARIABLE qbf_k AS INTEGER   NO-UNDO. /* count of counters */

  qbf_m = FILL(' ':u,NUM-ENTRIES(qbf_s,".":u) * 2).

  /* generate foreach and breakby stuff */
  { aderes/c-gen2.i }
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

PROCEDURE generate_display:
  DEFINE INPUT PARAMETER qbf_s AS CHARACTER NO-UNDO. /* qbf-section.qbf-sout */

  DEFINE VARIABLE qbf_a AS LOGICAL   NO-UNDO. /* scrap */
  DEFINE VARIABLE qbf_b AS INTEGER   NO-UNDO. /* first field */
  DEFINE VARIABLE qbf_c AS CHARACTER NO-UNDO. /* scrap */
  DEFINE VARIABLE qbf_e AS INTEGER   NO-UNDO. /* last field */
  DEFINE VARIABLE qbf_i AS INTEGER   NO-UNDO. /* loop */
  DEFINE VARIABLE qbf_l AS CHARACTER NO-UNDO. /* sect disp-list */
  DEFINE VARIABLE qbf_n AS CHARACTER NO-UNDO. /* field name */

  DEFINE BUFFER qbf_sbuffer FOR qbf-section.

  FIND FIRST qbf-section WHERE qbf-section.qbf-sout = qbf_s.

  qbf_m = FILL(' ':u,NUM-ENTRIES(qbf_s,".":u) * 2).

  /* See if there is another section (for outer join).  If there is, see if we
     can find a record for that first table.  If so, the display will happen 
     when we get to that section.  Otherwise we'll have to do it here.  Or 
     we'll get the parent fields once and then again with the children from 
     the outer join section.
  */
  FIND FIRST qbf_sbuffer WHERE qbf_sbuffer.qbf-sout = qbf_s.
  FIND NEXT qbf_sbuffer USE-INDEX qbf-section-ix1 NO-ERROR.
  IF AVAILABLE qbf_sbuffer THEN DO:
    RUN aderes/c-for.p (ENTRY(1,qbf_sbuffer.qbf-stbl), 
                        LENGTH(qbf_m,"CHARACTER":u), 
                        FALSE, "IF NOT CAN-FIND(FIRST":u).
    PUT UNFORMATTED ' THEN':u SKIP.
    qbf_m = qbf_m + "  ":u. /* to indent EXPORT 1 more level */
  END.

  /* If the field belongs to the current section, then display it. 
     For each section above this, display those as well. */
  ASSIGN
    qbf_c = qbf_s
    qbf_l = qbf_s.
  DO WHILE NUM-ENTRIES(qbf_c,".":u) > 1:
    qbf_c = SUBSTRING(qbf_c,1,MAXIMUM(R-INDEX(qbf_c,".":u) - 1,0),
                      "CHARACTER":u).
    FIND FIRST qbf_sbuffer WHERE qbf_sbuffer.qbf-sout = qbf_c no-error.
    qbf_l = qbf_l + ",":u + qbf_c.
  END.

  /* Finds the first field which will be exported
     Removed bug 20000815-005 (dma)
  DO qbf_b = 1 TO qbf-rc#:
    RUN multi_match (qbf_l,qbf-rcs[qbf_b],OUTPUT qbf_a).    
    IF qbf_a THEN LEAVE.
  END.                                                  
  */
  
  /* Finds the last field which will be exported. 
     Removed bug 20000815-005 (dma)
  DO qbf_e = qbf-rc# TO 1 BY -1:
    IF qbf-rcc[qbf_e] BEGINS "e":u THEN NEXT.

    RUN multi_match (qbf_l,qbf-rcs[qbf_e],OUTPUT qbf_a).
    IF qbf_a THEN LEAVE.
  END.
  */
  
  DO qbf_i = 1 TO qbf-rc#:
    RUN multi_match (qbf_l,qbf-rcs[qbf_i],OUTPUT qbf_a).
    
    /* We don't support stacked arrays in export view */
    IF qbf-rcc[qbf_i] BEGINS "e":u THEN NEXT.

    /* When an outer join is present, export ALL fields even though they
       may not belong to this table.  In that case, replace qbf_n with a 
       placeholder field of unknown value. 19981222-017 (dma) */
    IF NOT qbf_a THEN
      qbf_n = "qbf-unknown":U.
    ELSE
      {&SET_FLD_NAME} /* sets qbf_n */

    RUN VALUE(qbf-u) (
      "b":u,
      qbf_n,
      qbf-rcl[qbf_i],
      qbf-rcf[qbf_i],
      qbf_i,
      qbf-rct[qbf_i],
      qbf_m,
      (qbf_i = 1)       /*first field*/ ,
      (qbf_i = qbf-rc#) /*last field*/ ,
      qbf-rcc[qbf_i] BEGINS "x",
      (IF qbf-rcc[qbf_i] BEGINS "x" THEN ENTRY(7,qbf-rcn[qbf_i]) ELSE "")
      ).
  END. /* end of loop over all fields */
  PUT UNFORMATTED SKIP(1).
END PROCEDURE. /* generate_display */

/*--------------------------------------------------------------------------*/

PROCEDURE multi_match:
  /* If at least one member of qbf_a is in qbf_b then return TRUE. */
  
  DEFINE INPUT  PARAMETER qbf_a AS CHARACTER NO-UNDO. /* first string  */
  DEFINE INPUT  PARAMETER qbf_b AS CHARACTER NO-UNDO. /* second string */
  DEFINE OUTPUT PARAMETER qbf_l AS LOGICAL   NO-UNDO. /* output variable */
  DEFINE VARIABLE qbf_k AS INTEGER NO-UNDO. /* loop */

  DO qbf_k = 1 TO NUM-ENTRIES(qbf_b):
    IF CAN-DO(qbf_a,ENTRY(qbf_k,qbf_b)) THEN LEAVE.
  END.

  qbf_l = (qbf_k <= NUM-ENTRIES(qbf_b)).
  
END PROCEDURE. /* multi_match */

/*--------------------------------------------------------------------------*/

PROCEDURE generate_end:
  DEFINE INPUT PARAMETER qbf_s AS CHARACTER NO-UNDO. /* qbf-section.qbf-sout */

  DEFINE VARIABLE qbf_i AS INTEGER   NO-UNDO. /* scrap */
  DEFINE VARIABLE qbf_k AS INTEGER   NO-UNDO. /* hide-rep-vals pseudo-count */

  FIND FIRST qbf-section WHERE qbf-section.qbf-sout = qbf_s.

  qbf_m = FILL(' ':u,NUM-ENTRIES(qbf_s,".":u) * 2).

  /* write out the "end" for the for-each loop */
  PUT UNFORMATTED
    SUBSTRING(qbf_m,3,-1,"CHARACTER":u) 'END.':u SKIP(1).

END PROCEDURE. /* generate_end */

/*--------------------------------------------------------------------------*/

/* This procedure converts a list of ASCII values to */
/* the 4GL code necessary to output those values.    */

PROCEDURE control_codes:
  DEFINE INPUT  PARAMETER qbf_l AS CHARACTER NO-UNDO. /* ascii in */
  DEFINE OUTPUT PARAMETER qbf_s AS CHARACTER NO-UNDO. /* 4gl out */

  DEFINE VARIABLE qbf_i AS INTEGER NO-UNDO. /* scrap/loop */
  DEFINE VARIABLE qbf_v AS INTEGER NO-UNDO. /* value being worked on */
  DEFINE VARIABLE qbf_o AS CHARACTER INITIAL "" NO-UNDO. /* optimized string */

  DO qbf_i = 1 TO NUM-ENTRIES(qbf_l):
    IF ENTRY(qbf_i, qbf_l) <> "" THEN
      ASSIGN
        qbf_v = INTEGER(ENTRY(qbf_i, qbf_l))
        qbf_s = qbf_s
              + (IF qbf_s = "" THEN "" ELSE " ":u)
              + (IF qbf_v = 0 THEN
                  "NULL":u
                ELSE
                  "CHR(":u + STRING(qbf_v) + ")":u
                )
        qbf_o = qbf_o
              + (IF qbf_v < 32 OR qbf_v > 126 THEN
                  ?
                 ELSE IF qbf_v >= 48 AND qbf_v <= 57 THEN
                   CHR(qbf_v)
                 ELSE
                   "~~" + CHR(qbf_v)
                ).
  END.

  IF qbf_o <> "" AND INDEX(qbf_o,'"':u) = 0 THEN
    qbf_s = '"':u + qbf_o + '"':u.
  ELSE
  IF qbf_o <> "" AND INDEX(qbf_o,"'":u) = 0 THEN
    qbf_s = "'":u + qbf_o + "'":u.
END PROCEDURE. /* control_codes */

/*--------------------------------------------------------------------------*/

/* alias_to_tbname */
{ aderes/s-alias.i }

/*--------------------------------------------------------------------------*/

/* e-write.p - end of file */

