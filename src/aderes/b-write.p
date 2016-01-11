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
/* b-write.p - generate browse program 
 
   Input Parameter:
      usage - Indicates what the output file will be used for. e.g., 
	      "r" for running during a results session, "s" for
	      a saved query, or "g" for a .p to use outside results.
*/
 
{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/j-define.i }
{ aderes/y-define.i }
{ aderes/fbdefine.i }
{ aderes/s-menu.i } 
 
DEFINE INPUT PARAMETER usage AS CHARACTER NO-UNDO.
 
&global-define UseButtonImages TRUE
 
DEFINE VARIABLE qbf-i    AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-j    AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-l    AS LOGICAL   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-sfx  AS CHARACTER NO-UNDO. /* frame suffix */
DEFINE VARIABLE qbf-psfx AS CHARACTER NO-UNDO. /* parent suffix */
DEFINE VARIABLE qbf-o    AS CHARACTER NO-UNDO. /* optimized literals */
 
/* qbf-tbl is the real, qualified table name (don't need for browse)
   qbf-buf is the qualified buffer name which for most tables is the same
	   as qbf-tbl but may not be if table is an alias (e.g., demo.manager).
	   This is the string that users see and is used to refer to the 
	   table in all generated code.
*/
DEFINE VARIABLE qbf-tbl  AS CHARACTER         NO-UNDO. 
DEFINE VARIABLE qbf-buf  AS CHARACTER         NO-UNDO.
 
/* These are needed for fbfuncs.i to compile though they aren't used for
   browse.
*/
DEFINE VARIABLE updateable AS LOGICAL   NO-UNDO. 
DEFINE VARIABLE a_supp     AS LOGICAL   NO-UNDO. /* add supported?*/
DEFINE VARIABLE d_supp     AS LOGICAL   NO-UNDO. /* delete supported?*/
DEFINE VARIABLE u_supp     AS LOGICAL   NO-UNDO. /* update supported?*/
DEFINE VARIABLE can_add    AS LOGICAL   NO-UNDO. /* can add? */
DEFINE VARIABLE can_del    AS LOGICAL   NO-UNDO. /* can delete?*/
DEFINE VARIABLE can_upd    AS LOGICAL   NO-UNDO. /* can update?*/
 
DEFINE BUFFER qbf-sparent FOR qbf-section.
 
/*------------------------------------------------------------------------ 
   Global defines (in fbdefine.i)
      FNAM_COMP
      CALCULATED 
      TEXT_LIT   
      NOT_SUPPORTED_IN_BROWSE
      NOT_SUPPORTE_IN_FORM
 
   Internal Procedures: (in fbfuncs.i)
      button_last
      button_count
      close_kids
      first_to_kids
      optimize_literals
      generate_reset_current
      generate_button_state
      generate_any_prev
      generate_any_next
      end_epilog
-------------------------------------------------------------------------*/
{ aderes/fbfuncs.i }
 
/*--------------------------------------------------------------------------*/
 
RUN aderes/_fbempty.p (usage).
IF RETURN-VALUE = "error":u THEN 
  RETURN "error":u.
 
/* For browse, we will not include constant text strings since it doesn't
   make much sense.  However, we need to figure out if there are any so
   we can skip them.
*/
RUN optimize_literals.
RUN generate_prolog. 
 
/* There shouldn't be any sections where outer join flag is true
   anymore in form mode.  That is, it used to create a new section
   for outer joins so there would be a separate FOR EACH for the child 
   table.  This is not supported right now.
   But leave this as example in case this changes.
*/
FOR EACH qbf-section
  WHERE qbf-section.qbf-smdl
  BY qbf-section.qbf-sfrm:
 
  {&FIND_TABLE_BY_ID} INTEGER(ENTRY(1,qbf-section.qbf-stbl)).
  ASSIGN
    qbf-buf = qbf-rel-buf.tname
    qbf-sfx = ENTRY({&FNAM_COMP},qbf-section.qbf-sfrm,"-":u).
  RUN generate_frame.  
END.
 
FOR EACH qbf-section BY qbf-section.qbf-sfrm:
  qbf-i = R-INDEX(qbf-section.qbf-sout,".":u).
  IF qbf-i > 0 THEN
    FIND FIRST qbf-sparent WHERE qbf-sparent.qbf-sout = 
      SUBSTRING(qbf-section.qbf-sout,1,qbf-i - 1,"CHARACTER":u).
 
  {&FIND_TABLE_BY_ID} INTEGER(ENTRY(1,qbf-section.qbf-stbl)).
  ASSIGN
    qbf-sfx = ENTRY({&FNAM_COMP},qbf-section.qbf-sfrm,"-":u)
    qbf-psfx = (IF qbf-i = 0 
      THEN "" 
      ELSE ENTRY({&FNAM_COMP},qbf-sparent.qbf-sfrm,"-":u))
    qbf-buf = qbf-rel-buf.tname.
 
  RUN button_first.
  RUN button_last.
  RUN button_count.
  RUN iteration_change.
 
  IF usage = "r":u THEN 
    RUN generate_reset_current.
  RUN generate_button_state("f,l":u).
  RUN generate_any_prev.
  RUN generate_any_next.
END.
 
RUN generate_epilog. 
 
RETURN "".
 
/*--------------------------------------------------------------------------*/
 
PROCEDURE button_first:
 
  /* The trigger will just call an internal procedure */
  /*
  > ON CHOOSE OF b_first IN FRAME qbf-form-1 
  >   RUN get-first-1.
  */
  PUT UNFORMATTED
    'ON CHOOSE OF b_first IN FRAME ':u qbf-section.qbf-sfrm SKIP
    '  RUN get-first-':u qbf-sfx '.':u SKIP(1).
 
  /* Begin the procedure. */
  /*
  > PROCEDURE get-first-1:
  >   DEFINE VARIABLE ok AS LOGICAL NO-UNDO.
  */
  PUT UNFORMATTED
    'PROCEDURE get-first-':u qbf-sfx ':':u SKIP
    '  DEFINE VARIABLE ok AS LOGICAL NO-UNDO.':u SKIP(1).
 
  /* If child query, die now if parent unavailable. 
     Otherwise, open the query.  Parent query only needs to be opened  
     once, so don't do it here.
  */
  /*
  >   IF NOT qbf-flag-1 THEN RETURN.
  >   OPEN QUERY qbf-query-2
  >     FOR EACH demo.order OF demo.customer
  >     BY demo.order.order-num.
  */
  IF qbf-psfx <> "" THEN DO:
    PUT UNFORMATTED
      '  IF NOT qbf-flag-':u qbf-psfx ' THEN RETURN.':u SKIP.
    RUN aderes/_fbquery.p (qbf-sfx, qbf-section.qbf-sout,"",2,"  ":u).
  END.
 
  /* Now open the thing and check for an empty query and */
  /* if not empty set the current record. */
  /*
  >   /* results environment only */
  >   qbf-flag-1 = no.
  >   IF qbf-startids[1] <> "" THEN DO: 
  >     ok = CURRENT-WINDOW:LOAD-MOUSE-POINTER("WAIT").
  >     RUN reset-current-1("first").
  >     ok = CURRENT-WINDOW:LOAD-MOUSE-POINTER("").
  >     qbf-flag-1 = (AVAILABLE demo.customer).
  >   END.
  >   IF NOT qbf-flag-1 THEN
  >
  >   /* all environments */
  >   APPLY "HOME" TO qbf-browse-1 IN FRAME qbf-form-1.
  >   qbf-flag-1 = (AVAILABLE demo.customer).
  >   IF qbf-flag-1 THEN DO:
  >     ok = qbf-browse-1:SELECT-FOCUSED-ROW().
  >     RUN any-prev-1.
  >     RUN button-state-1 ("f", anyprev).
  >     RUN any-next-1.
  >     RUN button-state-1 ("l", anynext).
  */
  IF usage = "r":u THEN 
    PUT UNFORMATTED
      '  qbf-flag-':u qbf-sfx ' = no.':u SKIP
      '  IF qbf-startids[':u qbf-sfx '] <> "" THEN DO:':u SKIP
      &IF "{&WINDOW-SYSTEM}":u BEGINS "MS-WIN":u &THEN
      '    ok = SESSION:SET-WAIT-STATE("GENERAL").':u SKIP
      &ELSE
      '    ok = CURRENT-WINDOW:LOAD-MOUSE-POINTER("WAIT").':u SKIP
      &ENDIF
      '    RUN reset-current-':u qbf-sfx '("first").':u SKIP
      &IF "{&WINDOW-SYSTEM}":u BEGINS "MS-WIN":u &THEN
      '    ok = SESSION:SET-WAIT-STATE("").':u SKIP
      &ELSE
      '    ok = CURRENT-WINDOW:LOAD-MOUSE-POINTER("").':u SKIP
      &ENDIF
      '    qbf-flag-':u qbf-sfx ' = (AVAILABLE ':u qbf-buf ').':u SKIP
      '  END.':u SKIP
      '  IF NOT qbf-flag-':u qbf-sfx ' THEN':u.
 
  PUT UNFORMATTED
    '  APPLY "HOME" TO qbf-browse-':u qbf-sfx 
       ' IN FRAME qbf-form-':u qbf-sfx '.':u SKIP
    '  qbf-flag-':u qbf-sfx ' = (AVAILABLE ':u qbf-buf ').':u SKIP
    '  IF qbf-flag-':u qbf-sfx ' THEN DO:':u SKIP
    '    ok = qbf-browse-':u qbf-sfx ':SELECT-FOCUSED-ROW().':u SKIP
    '    RUN any-prev-':u qbf-sfx '.':u SKIP
    '    RUN button-state-':u qbf-sfx '("f", anyprev).':u SKIP
    '    RUN any-next-':u qbf-sfx '.':u SKIP
    '    RUN button-state-':u qbf-sfx '("l", anynext).':u SKIP.
 
  /* Get 'First' for each of my immediate children */
  /*
  >  RUN get-first-2.
  */
  RUN first_to_kids (qbf-section.qbf-sout,'    ':u).
 
  /* If no records in parent, close child queries and clear */
  /*
  >   END.
  >   ELSE DO:
  >     CLOSE QUERY qbf-query-1.
  >     RUN button-state-1 ("a", no).
  >     CLOSE QUERY qbf-query-2.
  >     qbf-flag-2 = FALSE.
  >   END.
  > END.
  */
  PUT UNFORMATTED
    '  END.':u SKIP
    '  ELSE DO:':u SKIP
    '    CLOSE QUERY qbf-query-':u qbf-sfx '.':u SKIP
    '    RUN button-state-':u qbf-sfx '("a", no).':u SKIP.
  RUN close_kids (FALSE).
  PUT UNFORMATTED
    '  END.':u SKIP
    'END.':u SKIP(1).
END PROCEDURE. /* button_first */
 
/*--------------------------------------------------------------------------*/
/* Generate iteration-changed trigger */
PROCEDURE iteration_change:
  DEFINE BUFFER qbf_sbuffer FOR qbf-section.
 
  /* Reopen query for children since parent record changed. */
  /*
  > ON ITERATION-CHANGED OF BROWSE qbf-browse-1 DO:
  >  OPEN QUERY qbf-query-2
  >   FOR EACH res.order OF res.customer.
  >  RUN any-prev-1.
  >  RUN button-state-1("f", anyprev).
  >  RUN any-next-1.
  >  RUN button-state-1("l", anynext).
  >  RUN get-first-2.
  > END.
  */
 
  PUT UNFORMATTED
    'ON ITERATION-CHANGED OF BROWSE qbf-browse-':u qbf-sfx ' DO:':u SKIP.
  FOR EACH qbf_sbuffer
    WHERE qbf_sbuffer.qbf-sout BEGINS qbf-section.qbf-sout + ".":u 
      BY qbf_sbuffer.qbf-sout:
    RUN aderes/_fbquery.p (ENTRY({&FNAM_COMP},qbf_sbuffer.qbf-sfrm,"-":u), 
			   qbf_sbuffer.qbf-sout,"",2,"  ":u).
  END.
  PUT UNFORMATTED
    '  RUN any-prev-':u qbf-sfx '.':u SKIP
    '  RUN button-state-':u qbf-sfx '("f", anyprev).':u SKIP
    '  RUN any-next-':u qbf-sfx '.':u SKIP
    '  RUN button-state-':u qbf-sfx '("l", anynext).':u SKIP.
 
  RUN first_to_kids (qbf-section.qbf-sout,'  ':u).
  PUT UNFORMATTED
    'END.':u SKIP(1).
END.
 
/*--------------------------------------------------------------------------*/
 
PROCEDURE generate_prolog:
  DEFINE VARIABLE qbf_i AS INTEGER NO-UNDO. /* for defbufs.i */
 
  PUT UNFORMATTED
    'DEFINE VARIABLE qbf-count AS INTEGER NO-UNDO.':u SKIP.
 
  /* If in results use shared widget handle which corresponds to exit
     menu handle.  Otherwise, make a local one.
  */
  IF usage = "r":u THEN DO:
    PUT UNFORMATTED
      'DEFINE VARIABLE qbf-startids AS CHARACTER EXTENT 2 INIT ["':u 
	 qbf-rowids[1] '","':u qbf-rowids[2] '"].':u SKIP
      'DEFINE SHARED VARIABLE qbf-widxit AS HANDLE NO-UNDO.':u SKIP.
    ASSIGN
      qbf-rowids     = ""
      qbf-use-rowids = NO.
  END.
  ELSE
    PUT UNFORMATTED
      'DEFINE VARIABLE qbf-widxit AS HANDLE NO-UNDO.':u SKIP.
 
  /* Define "any" flags and button variables for form. */
  PUT UNFORMATTED
    'DEFINE VARIABLE qbf_id  AS ROWID NO-UNDO.':u SKIP
    'DEFINE VARIABLE anyprev AS LOGICAL NO-UNDO.':u SKIP
    'DEFINE VARIABLE anynext AS LOGICAL NO-UNDO.':u SKIP(1)
    &if {&UseButtonImages} &then
      'DEFINE BUTTON b_first IMAGE FILE "adeicon/pvfirst"':u SKIP
      '          IMAGE-DOWN        FILE "adeicon/pvfirstd"':u SKIP
      '          IMAGE-INSENSITIVE FILE "adeicon/pvfirstx"':u SKIP
      /*'          SIZE 5 BY 1.':u SKIP*/
      '          SIZE-PIXELS 32 BY 24.':u SKIP
      'DEFINE BUTTON b_last  IMAGE FILE "adeicon/pvlast"':u SKIP
      '          IMAGE-DOWN        FILE "adeicon/pvlastd"':u SKIP
      '          IMAGE-INSENSITIVE FILE "adeicon/pvlastx"':u SKIP
      /*'          SIZE 5 BY 1.':u SKIP.*/
      '          SIZE-PIXELS 32 BY 24.':u SKIP.
    &else
      'DEFINE BUTTON b_first LABEL "|<" SIZE 5 BY 1.':u SKIP
      'DEFINE BUTTON b_last  LABEL ">|" SIZE 5 BY 1.':u SKIP.
    &endif
  PUT UNFORMATTED
    'DEFINE BUTTON b_count  LABEL "&Count"  SIZE 8 BY 1.':u SKIP(1).
 
  { aderes/defbufs.i &mode = "NEW SHARED " }  /* Define the table buffers */
  PUT UNFORMATTED SKIP(1).
 
  /*
  > DEFINE VARIABLE qbf-flag-1 AS LOGICAL NO-UNDO.
  > DEFINE QUERY qbf-query-1
  >   FOR demo.customer
  >   SCROLLING.
  > DEFINE BROWSE qbf-browse-1 QUERY qbf-query-1 NO-LOCK
  >   DISPLAY
  >     res.customer.Cust-num LABEL "Cust num" FORMAT ">>>>9":u 
  >     res.customer.Name LABEL "Name" FORMAT "x(20)":u 
  >    WITH 6 DOWN FONT 0 WIDTH 90.
  */
  FOR EACH qbf-section BY qbf-section.qbf-sfrm:
    qbf-sfx = ENTRY({&FNAM_COMP},qbf-section.qbf-sfrm,"-":u).
    PUT UNFORMATTED
      'DEFINE VARIABLE qbf-flag-':u qbf-sfx ' AS LOGICAL NO-UNDO.':u SKIP.
 
    /* generate define query code */
    RUN aderes/_fbquery.p (qbf-sfx, qbf-section.qbf-sout, "", 1, "").
 
    PUT UNFORMATTED 
      'DEFINE BROWSE qbf-browse-':u qbf-sfx ' QUERY qbf-query-':u qbf-sfx
	 ' NO-LOCK':u SKIP
      '  DISPLAY':u SKIP.
    RUN generate_browse_fields.
 
    FIND FIRST qbf-frame 
      WHERE qbf-frame.qbf-ftbl = qbf-section.qbf-stbl NO-ERROR.
 
    /* Use the fHeader frame as an arbitrary frame to get border sizes. 
       It has to be a frame without NO-BOX.
    */
    PUT UNFORMATTED
      SKIP
      'WITH ':u
      (IF AVAILABLE qbf-frame AND qbf-frame.qbf-fbht > 0 THEN 
	 STRING(qbf-frame.qbf-fbht) ELSE 
	 IF qbf-detail = 0 THEN '{&BRW_HT_1}':u ELSE '{&BRW_HT_2}':u)
      ' DOWN FONT 0 NO-COLUMN-SCROLLING WIDTH ':u
      (IF usage = "r":u 
	 THEN {aderes/numtoa.i &num="MAX(def-win-wid, qbf-win:WIDTH) - 
		     FRAME fHeader:BORDER-LEFT - FRAME fHeader:BORDER-RIGHT"}
	 ELSE '78':u)
      '.':u SKIP(1).
  END.
END PROCEDURE. /* generate_prolog */
 
/*--------------------------------------------------------------------------*/
 
PROCEDURE generate_epilog:
  DEFINE VARIABLE frst   AS LOGICAL   NO-UNDO INIT YES. /* 1st frm displayed? */
  DEFINE VARIABLE hjunk  AS HANDLE    NO-UNDO.
 
  /*
  > /* Setting qbf-widxit will only be done if generating stand-alone .p. */
  > qbf-widxit = FRAME qbf-form-1:HANDLE.
  >
  > OPEN QUERY qbf-query-1
  >   FOR EACH res.customer.
  >
  > /* This will only be done if generating code to run during results session*/
  > RUN b-store.p (yes, "qbf-form-1":u, FRAME qbf-browse-1:HANDLE).
  >
  > ENABLE
  >   qbf-browse-1
  >   b_first last b_count
  >   WITH FRAME qbf-form-1
  >
  > /* only for results session */
  > RUN b-store.p ("qbf-form-2":u, FRAME qbf-browse-2:HANDLE).
  >
  > ENABLE
  >   qbf-browse-2
  >   b_first b_last b_count
  >   WITH FRAME qbf-form-2
  >
  */
  IF usage <> "r":u THEN DO:
    FIND FIRST qbf-section.
    PUT UNFORMATTED
      'qbf-widxit = FRAME ':u qbf-section.qbf-sfrm ':HANDLE.':u SKIP.
  END.
 
  FOR EACH qbf-section BREAK BY qbf-section.qbf-sfrm:
    qbf-sfx = ENTRY({&FNAM_COMP},qbf-section.qbf-sfrm,"-":u).
 
    IF qbf-section.qbf-sout = "1":u THEN /* only open query on parent frame */
      /* generate open query code */
      RUN aderes/_fbquery.p (qbf-sfx, qbf-section.qbf-sout, "", 2, "").
    IF FIRST-OF(qbf-section.qbf-sfrm) THEN DO:
      IF usage = "r":u THEN DO:
        PUT UNFORMATTED
          'RUN aderes/b-store.p (':u frst ', "':u qbf-section.qbf-sfrm 
          '", FRAME ':u qbf-section.qbf-sfrm ':HANDLE).':u SKIP(1).
          frst = no.
      END.
      
      PUT UNFORMATTED
        'ENABLE':u SKIP
        '  qbf-browse-':u qbf-sfx SKIP
        '  b_first b_last b_count':u SKIP ''
        '  WITH FRAME ':u qbf-section.qbf-sfrm '.':u SKIP(1).
    END.
  END.
 
  RUN end_epilog ({&B_IX}).
END PROCEDURE. /* generate_epilog */
 
/*--------------------------------------------------------------------------*/
 
/* layout the frame */
PROCEDURE generate_frame:
 
  DEFINE VARIABLE ttl AS CHARACTER NO-UNDO. /* title for frame */
  DEFINE VARIABLE ix  AS INTEGER   NO-UNDO.
 
  /*
  > FORM
  >   qbf-browse-1 SKIP(.5)
  >   b_first AT 2 b_last b_count SKIP(.5)
  >   WITH FRAME qbf-form-1
  >   OVERLAY WIDTH 100 
  >   TITLE "res.customer".
  */
 
  PUT UNFORMATTED
    'FORM':u SKIP
    '  qbf-browse-':u qbf-sfx ' SKIP(.4)':u SKIP
    '  b_first AT 2 b_last b_count SKIP(.4)':u SKIP
    '  WITH FRAME ':u qbf-section.qbf-sfrm SKIP
    '  OVERLAY':u.
 
  /* Should we display in 3D? -dma */
  IF "{&WINDOW-SYSTEM}":u BEGINS "MS-WIN":u 
    AND qbf-threed AND usage = "r":u THEN
    PUT UNFORMATTED
      ' THREE-D':u.
 
  IF usage = "r":u THEN
    PUT UNFORMATTED
      ' WIDTH ':u {aderes/numtoa.i &num="MAX(def-win-wid, qbf-win:WIDTH)"}.
 
  FIND FIRST qbf-frame WHERE qbf-frame.qbf-ftbl = qbf-section.qbf-stbl NO-ERROR.
  IF AVAILABLE(qbf-frame) AND qbf-frame.qbf-frow[{&B_IX}] > 0 THEN
    PUT UNFORMATTED
      ' ROW ':u {aderes/numtoa.i &num="qbf-frame.qbf-frow[{&B_IX}]"}.  
  /* Default Title for frames is:
     "[Master | Detail] - tbl1,tbl2" up to 80 chars. 
  */
  DO ix = 1 TO NUM-ENTRIES(qbf-section.qbf-stbl):
    {&FIND_TABLE_BY_ID} INTEGER(ENTRY(ix, qbf-section.qbf-stbl)).
    ttl = ttl + (IF ttl = "" THEN "" ELSE ",":u) + 
	    (IF qbf-hidedb THEN ENTRY(2,qbf-rel-buf.tname,".":u)
			   ELSE qbf-rel-buf.tname).
  END.
  IF qbf-detail <> 0 THEN
    ttl = (IF qbf-section.qbf-sout = "1":u THEN "Master" ELSE "Detail")
	    + " - ":u + ttl.
  IF LENGTH(ttl,"RAW":u) > 77 THEN 
    ttl = SUBSTRING(ttl,1,77,"FIXED":u) + "...":u.
  PUT UNFORMATTED 
    SKIP
    '  TITLE "':u ttl '".':u SKIP(1).
END PROCEDURE. /* generate_frame */
 
/*--------------------------------------------------------------------------*/
 
PROCEDURE generate_browse_fields:
  DEFINE VARIABLE qbf_i  AS INTEGER   NO-UNDO. /* scrap/loop */
  DEFINE VARIABLE qbf_j  AS INTEGER   NO-UNDO. /* field count */
  DEFINE VARIABLE qbf_k  AS INTEGER   NO-UNDO. /* scrap/count */
  DEFINE VARIABLE qbf_l  AS CHARACTER NO-UNDO. /* sections using this frame */
  DEFINE VARIABLE qbf_n  AS CHARACTER NO-UNDO. /* field name */
  DEFINE VARIABLE qbf_t  AS CHARACTER NO-UNDO. /* format */
  DEFINE VARIABLE fldexp AS CHARACTER NO-UNDO. /* qbf-rcn element */
  DEFINE VARIABLE fname  AS CHARACTER NO-UNDO. /* another field name */
  DEFINE VARIABLE cnt    AS INTEGER   NO-UNDO INIT 100. /* character count */
  DEFINE VARIABLE lbl    AS CHARACTER NO-UNDO.
 
  DEFINE BUFFER qbf_sbuffer FOR qbf-section.
 
  /* Construct list of sections using this frame. */
  ASSIGN
    qbf_j = 0
    qbf_l = "".
  {&GET_FRAME_SECTIONS}
 
  DO qbf_i = 1 TO qbf-rc#:
    IF {&NOT_SUPPORTED_IN_BROWSE} OR {&TEXT_LIT} THEN NEXT.
    {&IF_NOT_IN_FRAME_THEN_NEXT}
 
    /* Start a new statement every 20 fields to avoid exceeding Progress
       statement limit.  Progress merges all frames with same name 
       into one frame.
       BUT We can't do this for browse definition!  Instead we count 
       characters (see below).
    */
    /*-------------
    IF qbf_j MODULO 21 = 20 THEN
      PUT UNFORMATTED SKIP
	'  WITH FRAME ':u qbf-section.qbf-sfrm '.':u SKIP
	'FORM':u SKIP.
    ------*/
 
    ASSIGN
      qbf_j  = qbf_j + 1
      qbf_t  = qbf-rcf[qbf_i]
      lbl    = REPLACE(qbf-rcl[qbf_i], '"':u, '""':u)
      {&FB_FIX_LABEL}
      fldexp = qbf-rcn[qbf_i].
 
    IF CAN-DO("s*,d*,n*,l*":u, qbf-rcc[qbf_i]) THEN DO:
      /* Calculated expression */
      qbf_n = SUBSTRING(fldexp,INDEX(fldexp,",":u) + 1,-1,"CHARACTER":u).
 
      /* Make sure the expression isn't the same as one of the regular
	 fields - i.e., if user chooses constant string based on City
	 and City is already selected, then just skip it.
      */
      DO qbf_k = 1 TO qbf-rc#:
	IF qbf_n = ENTRY(1, qbf-rcn[qbf_k]) THEN LEAVE.
      END.
      IF qbf_k <= qbf-rc# THEN NEXT.
    END.
    ELSE 
      /* field name */
      qbf_n = ENTRY(1,fldexp).
 
    /* We have a 4096 character limit on statement length. */
    cnt = cnt + 
	  2 + LENGTH(qbf_n,"RAW":u) + 
	  9 + (IF qbf-rcl[qbf_i] = "" THEN 0 ELSE LENGTH(lbl,"RAW":u)) +
	  10 + LENGTH(qbf_t,"RAW":u) + 
	  5. /* need this but not sure why - CR's? line feeds? */
    IF cnt > 4096 THEN DO:
      RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l,"information":u,"ok":u,
        SUBSTITUTE("The selected field names, labels, and formats exceed the internal limit of 4096 characters.  The last &1 field(s) will not be included in the browse.",
        (qbf-rc# - qbf_i + 1))).
      LEAVE.
    END.
 
    PUT UNFORMATTED SKIP
      '  ':u qbf_n
      (IF qbf-rcl[qbf_i] = "" THEN ' NO-LABEL':u
			      ELSE ' LABEL "':u + lbl + '"':u)
      ' FORMAT "':u qbf_t '"':u.
  END.  
END PROCEDURE. /* generate_browse_fields */
 
/*--------------------------------------------------------------------------*/
 
/* alias_to_tbname */
{ aderes/s-alias.i }
 
/* b-write.p - end of file */
