/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* fbfuncs.i - Internal procedures and global-defines common to browse 
      	       and form (b-write and f-write).

   Internal Procedures:	
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
      generate_stored_ids
*/

/*--------------------------------------------------------------------------*/

PROCEDURE button_last:

  /* Begin the trigger.  If I'm not open, then return. */
  /*
  > ON CHOOSE OF b_last IN FRAME qbf-form-1 DO:
  >   DEFINE VARIABLE ok AS LOGICAL NO-UNDO. 
  >   IF NOT qbf-flag-1 THEN RETURN.
  >   ok = CURRENT-WINDOW:LOAD-MOUSE-POINTER("WAIT").
  */
  PUT UNFORMATTED
    'ON CHOOSE OF b_last IN FRAME ':u qbf-section.qbf-sfrm ' DO:':u SKIP
    '  DEFINE VARIABLE ok AS LOGICAL NO-UNDO.':u SKIP
    '  IF NOT qbf-flag-':u qbf-sfx ' THEN RETURN.':u SKIP
    &IF "{&WINDOW-SYSTEM}":u BEGINS "MS-WIN":u &THEN
    '  ok = SESSION:SET-WAIT-STATE("GENERAL").':u SKIP.
    &ELSE
    '  ok = CURRENT-WINDOW:LOAD-MOUSE-POINTER("WAIT").':u SKIP.
    &ENDIF

  /* Check for 'someone else deleted a record out from under us' case. */
  /*
  >   /* for form */
  >   GET LAST qbf-query-1 NO-LOCK.
  > OR
  >   /* for browse */
  >   APPLY "END" TO qbf-browse-1 IN FRAME qbf-form-1.
  >
  >   ok = CURRENT-WINDOW:LOAD-MOUSE-POINTER("").
  >   IF NOT AVAILABLE demo.customer THEN DO:
  >     RUN get-first-1.
  >     RETURN.
  >   END.
  */
  IF qbf-module = "f":u THEN
    PUT UNFORMATTED
      '  GET LAST qbf-query-':u qbf-sfx ' NO-LOCK.':u SKIP.
  ELSE
    PUT UNFORMATTED
      '  APPLY "END" TO qbf-browse-':u qbf-sfx 
      	 ' IN FRAME qbf-form-':u qbf-sfx '.':u SKIP.
  PUT UNFORMATTED
    &IF "{&WINDOW-SYSTEM}":u BEGINS "MS-WIN":u &THEN
    '  ok = SESSION:SET-WAIT-STATE("").':u SKIP
    &ELSE
    '  ok = CURRENT-WINDOW:LOAD-MOUSE-POINTER("").':u SKIP
    &ENDIF
    '  IF NOT AVAILABLE ':u qbf-buf ' THEN DO:':u SKIP
    '    RUN get-first-':u qbf-sfx '.':u SKIP
    '    RETURN.':u SKIP
    '  END.':u SKIP.

  /* If we're ok - either display the frame (form) or reposition to
     last record (browse). We know there are at least 2 records because
     otherwise, last button would have been gray and we wouldn't get
     here.  So we don't have to check for any-prev; we know there is one.
  */
  /*
  >   RUN display-form-1.
  >   RUN button-state-1 ("l,n", no).
  >   RUN any-prev-1.
  >   RUN button-state-1 ("f,p", anyprev).
  > OR
  >   ok = qbf-browse-1:SELECT-FOCUSED-ROW().
  >   RUN button-state-1 ("l", no).
  >   RUN button-state-1 ("f", yes).
  */
  IF qbf-module = "f":u THEN
    PUT UNFORMATTED
      '  RUN display-form-':u qbf-sfx '.':u SKIP
      '  RUN button-state-':u qbf-sfx '("l,n", no).':u SKIP
      '  RUN any-prev-':u qbf-sfx '.':u SKIP
      '  RUN button-state-':u qbf-sfx '("f,p", anyprev).':u SKIP.
  ELSE
    PUT UNFORMATTED
      '  ok = qbf-browse-':u qbf-sfx ':SELECT-FOCUSED-ROW().':u SKIP
      '  RUN button-state-':u qbf-sfx '("l", no).':u SKIP
      '  RUN button-state-':u qbf-sfx '("f", yes).':u SKIP.

  /* Get 'First' for each of my immediate children */
  /*
  >  RUN get-first-2.
  */
  RUN first_to_kids (qbf-section.qbf-sout,'  ':u).

  /* End the trigger. */
  /*
  > END.
  */
  PUT UNFORMATTED
    'END.':u SKIP(1).

END PROCEDURE. /* button_last */

/*--------------------------------------------------------------------------*/

/* Generate code for Count button trigger */
PROCEDURE button_count:
  /*
  > ON CHOOSE OF b_count IN FRAME qbf-form-1 DO:
  >   DEFINE VARIABLE ok  AS LOGICAL NO-UNDO.
  >   DEFINE VARIABLE lck AS LOGICAL NO-UNDO.
  >   IF NOT qbf-flag-1 THEN 
  >     qbf-count = 0.
  >   ELSE DO ON STOP UNDO, LEAVE:
  >	ok = CURRENT-WINDOW:LOAD-MOUSE-POINTER("WAIT").
  >	qbf-count = 0.
  >
  >     /* for form only: save where we are */
  >     qbf-startids[1] = STRING(current-result-row("qbf-query-1")).
  >     IF qbf-startids[1] = ? THEN qbf-startids[1] = "".
  >	qbf_startids[1] = qbf-startids[1] + "," + STRING(ROWID(demo.Customer)). 
  >
  >	GET FIRST qbf-query-1 NO-LOCK NO-WAIT.
  >	DO WHILE AVAILABLE demo.customer: 
  >	  qbf-count = qbf-count + 1.
  >	  GET NEXT qbf-query-1 NO-LOCK NO-WAIT.
  >       IF LOCKED demo.customer THEN LEAVE.
  >     END.
  >
  >     IF LOCKED demo.customer THEN DO: /* Sybase case */
  >       MESSAGE "Record locked.  Count cannot be performed."
  >         VIEW-AS ALERT-BOX WARNING.
  >       lck = TRUE.
  >     END.
  >
  >     /* For Browse: this resyncs the buffer w/o messing with the screen */
  >     ok = qbf-browse-1:FETCH-SELECTED-ROW(1) IN FRAME qbf-form-1.
  > OR
  >     /* For Form */
  >     IF qbf-startids[1] <> "" THEN 
  >	  RUN reset-current-1("count").
  >
  >	ok = CURRENT-WINDOW:LOAD-MOUSE-POINTER("").
  >   END.
  > 
  >   IF NOT lck THEN
  >     MESSAGE
  >       "The number of records is" qbf-count 
  >       VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
  >END.
  */
  PUT UNFORMATTED
    'ON CHOOSE OF b_count IN FRAME ':u qbf-section.qbf-sfrm ' DO:':u SKIP
    '  DEFINE VARIABLE ok  AS LOGICAL NO-UNDO.':u SKIP
    '  DEFINE VARIABLE lck AS LOGICAL NO-UNDO.':u SKIP(1)
    '  IF NOT qbf-flag-':u qbf-sfx ' THEN':u SKIP
    '    qbf-count = 0.':u SKIP
    '  ELSE DO ON STOP UNDO, LEAVE:':u SKIP
    &IF "{&WINDOW-SYSTEM}":u BEGINS "MS-WIN":u &THEN
    '    ok = SESSION:SET-WAIT-STATE("GENERAL").':u SKIP
    &ELSE
    '	 ok = CURRENT-WINDOW:LOAD-MOUSE-POINTER("WAIT").':u SKIP
    &ENDIF
    '	 qbf-count = 0.':u SKIP.

  IF qbf-module = "f":u THEN
    RUN generate_store_ids (qbf-section.qbf-sfrm, FALSE, "    ":u).

  PUT UNFORMATTED
    '	 GET FIRST qbf-query-':u qbf-sfx ' NO-LOCK NO-WAIT.':u SKIP
    '	 DO WHILE (AVAILABLE ':u qbf-buf '):':u SKIP
    '	   qbf-count = qbf-count + 1.':u SKIP
    '	   GET NEXT qbf-query-':u qbf-sfx ' NO-LOCK NO-WAIT.':u SKIP
    '      IF LOCKED ':u qbf-buf ' THEN LEAVE.':u SKIP
    '	 END.':u SKIP(1)
    '    IF LOCKED ':u qbf-buf ' THEN DO:':u SKIP
    '      MESSAGE "':u 'Record locked.  Count cannot be performed.' '"':u SKIP
    '        VIEW-AS ALERT-BOX WARNING.':u SKIP
    '      lck = TRUE.':u SKIP
    '    END.':u SKIP.

  IF qbf-module = "f":u THEN
    PUT UNFORMATTED
      '    IF qbf-startids[':u qbf-sfx '] <> "" THEN':u SKIP
      '	     RUN reset-current-':u qbf-sfx '("count").':u SKIP.
  ELSE
    PUT UNFORMATTED
      '    ok = qbf-browse-':u qbf-sfx 
      ':FETCH-SELECTED-ROW(1) IN FRAME qbf-form-':u qbf-sfx '.':u SKIP.
  PUT UNFORMATTED
    &IF "{&WINDOW-SYSTEM}":u BEGINS "MS-WIN":u &THEN
    '    ok = SESSION:SET-WAIT-STATE("").':u SKIP
    &ELSE
    '	 ok = CURRENT-WINDOW:LOAD-MOUSE-POINTER("").':u SKIP
    &ENDIF
    '  END.':u SKIP(1)
    '  IF NOT lck THEN':u SKIP
    '    MESSAGE':u SKIP
    '      "The number of records counted is" qbf-count':u SKIP
    '      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.':u SKIP
    'END.':u SKIP(1).
END PROCEDURE. /* button_count */

/*--------------------------------------------------------------------------*/

/* Work way through, closing all your subordinate queries. */
PROCEDURE close_kids:
  DEFINE INPUT PARAMETER qbf_clear AS LOGICAL NO-UNDO. /* clear frame? */

  DEFINE VARIABLE qbf_c AS CHARACTER NO-UNDO. /* suffix */
  DEFINE VARIABLE qbf_k AS INTEGER   NO-UNDO. /* counter */
  DEFINE BUFFER qbf_sbuffer FOR qbf-section.
  /*
  >   CLEAR FRAME qbf-form-2 NO-PAUSE.
  >   CLOSE QUERY qbf-query-2.
  >   RUN button-state-2("a", no).
  >   qbf-flag-2 = FALSE.
  */
  FOR EACH qbf_sbuffer 
    WHERE qbf_sbuffer.qbf-sout BEGINS qbf-section.qbf-sout + ".":u
    BY qbf_sbuffer.qbf-sfrm:
    ASSIGN
      qbf_c = ENTRY({&FNAM_COMP},qbf_sbuffer.qbf-sfrm,"-":u)
      qbf_k = qbf_k + 1.
    IF qbf_clear THEN
    PUT UNFORMATTED
      '    CLEAR FRAME ':u qbf_sbuffer.qbf-sfrm ' NO-PAUSE.':u SKIP.
    PUT UNFORMATTED
      '    CLOSE QUERY qbf-query-':u qbf_c '.':u SKIP
      '    RUN button-state-':u qbf_c '("a", no).':u SKIP.
  END.
  IF qbf_k > 1 THEN PUT UNFORMATTED '  ASSIGN':u SKIP '  ':u.
  FOR EACH qbf_sbuffer 
    WHERE qbf_sbuffer.qbf-sout BEGINS qbf-section.qbf-sout + ".":u
    BY qbf_sbuffer.qbf-sfrm:
    PUT UNFORMATTED
      '    qbf-flag-':u ENTRY({&FNAM_COMP},qbf_sbuffer.qbf-sfrm,"-":u) 
      ' = FALSE':u.
    IF qbf_k > 1 THEN PUT UNFORMATTED SKIP '  ':u.
  END.
  IF qbf_k > 0 THEN PUT UNFORMATTED '.':u SKIP.
END PROCEDURE. /* close_kids */

/*--------------------------------------------------------------------------*/

/* Apply a 'First' event to each of my immediate children */
PROCEDURE first_to_kids:
  DEFINE INPUT PARAMETER qbf_s    AS CHARACTER NO-UNDO. /* section */
  DEFINE INPUT PARAMETER qbf_marg AS CHARACTER NO-UNDO. /* indent margin*/

  DEFINE VARIABLE qbf_m AS CHARACTER NO-UNDO. /* frame suffix */
  DEFINE BUFFER qbf_sbuffer FOR qbf-section.
  /*
  >  RUN get-first-2.
  */
  FOR EACH qbf_sbuffer
    WHERE qbf_sbuffer.qbf-sout BEGINS qbf_s + ".":u
      AND NUM-ENTRIES(qbf_sbuffer.qbf-sout,".":u) = NUM-ENTRIES(qbf_s,".":u) + 1
      BY qbf_sbuffer.qbf-sout:
    qbf_m = ENTRY({&FNAM_COMP},qbf_sbuffer.qbf-sfrm,"-":u).
    PUT UNFORMATTED
      qbf_marg 'RUN get-first-':u qbf_m '.':u SKIP.
  END.
END PROCEDURE. /* first_to_kids */

/*--------------------------------------------------------------------------*/

/*
  This finds all simple character expression constants and allows them to
  be displayed as literals as opposed to fill-ins.
*/
PROCEDURE optimize_literals:
  DEFINE VARIABLE qbf_l AS INTEGER   NO-UNDO. /* loop */
  DEFINE VARIABLE qbf_t AS CHARACTER NO-UNDO. /* test text */

  DO qbf_l = 1 TO qbf-rc#:
    IF qbf-rcc[qbf_l] = ""
      OR qbf-rcl[qbf_l] <> ""
      OR qbf-rcc[qbf_l] <> "s":u
      OR SUBSTRING(qbf-rcn[qbf_l],9,1,"CHARACTER":u) <> '"':u
      OR SUBSTRING(qbf-rcn[qbf_l],LENGTH(qbf-rcn[qbf_l],"CHARACTER":u),1,
                   "CHARACTER":u) <> '"':u
      THEN NEXT.
    qbf_t = REPLACE(SUBSTRING(qbf-rcn[qbf_l],9,-1,"CHARACTER":u),'""':u,'"':u).

    IF qbf-rcf[qbf_l] <> 
      SUBSTITUTE("x(&1)":u,LENGTH(qbf_t,"CHARACTER":u) - 2) THEN NEXT.
    qbf-o = qbf-o + (IF qbf-o = "" THEN "" ELSE ",":u) + STRING(qbf_l).
  END.
END PROCEDURE. /* optimize_literals */

/*--------------------------------------------------------------------------*/

/* Generate code that will reset the cursor back to a specific record
   in the result set.  
*/
PROCEDURE generate_reset_current:
  DEFINE BUFFER qbf_sbuffer FOR qbf-section.
  DEFINE VARIABLE ix   AS INTEGER   NO-UNDO.
  DEFINE VARIABLE tbls AS CHARACTER NO-UNDO.

  /* First make a list of the tables involved in this frame */
  FOR EACH qbf_sbuffer WHERE qbf_sbuffer.qbf-sfrm = qbf-section.qbf-sfrm:
    DO ix = 1 TO NUM-ENTRIES(qbf_sbuffer.qbf-stbl):
      {&FIND_TABLE_BY_ID} INTEGER(ENTRY(ix,qbf_sbuffer.qbf-stbl)).
      tbls = tbls + (IF tbls = "" THEN "" ELSE ",":u) + qbf-rel-buf.tname.
    END.
  END.

  /*
  > PROCEDURE reset-current-1:
  >   DEFINE INPUT PARAMETER caller AS CHARACTER NO-UNDO.
  >   DEFINE VARIABLE qbf_ix AS INTEGER NO-UNDO.
  >   DEFINE VARIABLE ok     AS LOGICAL NO-UNDO.
  >   DEFINE VARIABLE match  AS LOGICAL NO-UNDO.
  >  
  >   /* If there's only 1 table, we'll reposition by id since it's
  >      much faster and since we may not have a current row if the
  >      user just did LAST (Progress starts at the back end and
  >      doesn't know which record # it's at within the query).
  >      Otherwise, unless current row is unknown, position by row
  >      since with multiple tables, positioning by id puts you in
  >      an unpredictable place within the repeating set of records.
  >      Positioning by row should always work unless someone changed 
  >      the database or the record no longer matches the query. So
  >      always see if the rowids match.
  >   */
  >   IF NUM-ENTRIES(qbf-startids[1]) > 2 AND
  >      ENTRY(1,qbf-startids[1]) <> "" THEN DO:
  >     REPOSITION qbf-query-1 TO ROW INTEGER(ENTRY(1,qbf-startids[1])) 
  >       NO-ERROR.
  >     IF NOT ERROR-STATUS:ERROR THEN
  >       GET NEXT qbf-query-1 NO-LOCK. /* form only */
  >     match = (AVAILABLE sports.customer).
  >   END.
  >   DO qbf_ix = 3 TO NUM-ENTRIES(qbf-startids[1]) WHILE match:
  >	qbf_id = TO-ROWID(ENTRY(qbf_ix, qbf-startids[1])).
  >	IF STRING(qbf_id) = "" THEN LEAVE.
  >	IF qbf_ix = 3 AND ROWID(sports.Invoice) <> qbf_id THEN
  >	  match = FALSE.
  >   END.
  >   /* Try to position by ids instead.  If we already tried by row 
  >      and failed, record may still be there - just in a different place.  
  >   */
  >   IF NOT match THEN DO:
  >	qbf_id = TO-ROWID(ENTRY(2, qbf-startids[1])).
  >	REPOSITION qbf-query-1 TO ROWID qbf_id NO-ERROR.
  >     IF NOT ERROR-STATUS:ERROR THEN
  >	  GET NEXT qbf-query-1 NO-LOCK.  /* form only */
  >     match = (AVAILABLE sports.customer).
  >	DO qbf_ix = 3 TO NUM-ENTRIES(qbf-startids[1]) WHILE match:
  >	  qbf_id = TO-ROWID(ENTRY(qbf_ix, qbf-startids[1])).
  >       IF STRING(qbf_id) = "" THEN LEAVE.
  >	  IF ix = 3 AND ROWID(sports.Invoice) <> qbf_id THEN
  >	    match = FALSE.
  >	END.
  >   END.
  >   qbf-startids[1] = "".  
  >   IF NOT match THEN DO:
  >     /* for form only and only if can add */
  >     IF qbf_currid <> "" THEN DO:
  >	  REPOSITION qbf-query-1 TO ROWID qbf_currid NO-ERROR.
  >       IF NOT ERROR-STATUS:ERROR THEN
  >	    GET NEXT qbf-query-1 NO-LOCK.  
  >       qbf_currid = "".
  >       RETURN.
  >     END.
  >     IF caller = "first" THEN
  >       GET FIRST qbf-query-1 NO-LOCK.
  >     ELSE 
  >       RUN get-first-1.
  >     END.
  >   END.
  >   ELSE /* browse only */
  >     ok = qbf-browse-1:SELECT-FOCUSED-ROW() IN FRAME qbf-form-1.
  > END.
  */
  
  /* Procedure header and match by row part */
  PUT UNFORMATTED
    'PROCEDURE reset-current-':u qbf-sfx ':':u SKIP
    '  DEFINE INPUT PARAMETER caller AS CHARACTER NO-UNDO.':u SKIP
    '  DEFINE VARIABLE qbf_ix AS INTEGER NO-UNDO.':u SKIP
    '  DEFINE VARIABLE ok     AS LOGICAL NO-UNDO.':u SKIP
    '  DEFINE VARIABLE match  AS LOGICAL NO-UNDO.':u SKIP(1)
    '  IF NUM-ENTRIES(qbf-startids[':u qbf-sfx ']) > 2 AND':u SKIP
    ' 	  ENTRY(1,qbf-startids[':u qbf-sfx ']) <> "" THEN DO:':u SKIP
    '    REPOSITION qbf-query-':u qbf-sfx 
      	 ' TO ROW INTEGER(ENTRY(1,qbf-startids[':u qbf-sfx '])) NO-ERROR.':u 
      	 SKIP.
  IF qbf-module = "f":u THEN
    PUT UNFORMATTED
      '    IF NOT ERROR-STATUS:ERROR THEN':u SKIP
      '      GET NEXT qbf-query-':u qbf-sfx ' NO-LOCK.':u SKIP.
  PUT UNFORMATTED
    '    match = (AVAILABLE ':u ENTRY(1,tbls) ').':u SKIP
    '  END.':u SKIP.
  IF NUM-ENTRIES(tbls) > 1 THEN DO:
    PUT UNFORMATTED
      '  DO qbf_ix = 3 TO NUM-ENTRIES(qbf-startids[':u qbf-sfx 
	  ']) WHILE match:':u SKIP
      '    qbf_id = TO-ROWID(ENTRY(qbf_ix,qbf-startids[':u qbf-sfx '])).':u SKIP
      '    IF STRING(qbf_id) = "" THEN LEAVE.':u SKIP.
    DO ix = 2 TO NUM-ENTRIES(tbls):
      PUT UNFORMATTED
	'    IF qbf_ix = ':u ix + 1 ' AND ROWID(':u ENTRY(ix,tbls) 
	      ') <> qbf_id THEN':u SKIP
	'       match = FALSE.':u SKIP.
    END.
    PUT UNFORMATTED
      '  END.':u SKIP.
  END.

  /* Match by ROWID part */
  PUT UNFORMATTED
    '  IF NOT match THEN DO:':u SKIP
    '    qbf_id = TO-ROWID(ENTRY(2, qbf-startids[':u qbf-sfx '])).':u SKIP
    '    REPOSITION qbf-query-':u qbf-sfx ' TO ROWID qbf_id NO-ERROR.':u SKIP.
  IF qbf-module = "f":u THEN
    PUT UNFORMATTED
      '    IF NOT ERROR-STATUS:ERROR THEN':u SKIP
      '      GET NEXT qbf-query-':u qbf-sfx ' NO-LOCK.':u SKIP.
  PUT UNFORMATTED
    '    match = (AVAILABLE ':u ENTRY(1,tbls) ').':u SKIP.
  IF NUM-ENTRIES(tbls) > 1 THEN DO:
    PUT UNFORMATTED
      '    DO qbf_ix = 3 TO NUM-ENTRIES(qbf-startids[':u qbf-sfx 
	      ']) WHILE match:':u SKIP
      '      qbf_id = TO-ROWID(ENTRY(qbf_ix,qbf-startids[':u 
      	       qbf-sfx '])).':u SKIP
      '      IF STRING(qbf_id) = "" THEN LEAVE.':u SKIP.
    DO ix = 2 TO NUM-ENTRIES(tbls):
      PUT UNFORMATTED
	'      IF qbf_ix = ':u ix + 1 ' AND ROWID(':u ENTRY(ix,tbls) 
		') <> qbf_id THEN':u SKIP
	'         match = FALSE.':u SKIP.
    END.
    PUT UNFORMATTED
      '    END.':u SKIP.
  END.
 
  /* Reset of startids and no match processing */
  PUT UNFORMATTED
    '  END.':u SKIP
    '  qbf-startids[':u qbf-sfx '] = "". ':u SKIP
    '  IF NOT match THEN DO:':u SKIP.
  IF qbf-module = "f":u AND updateable AND can_add AND can_upd THEN
    PUT UNFORMATTED
      '    IF qbf_currid <> ? THEN DO:':u SKIP
      '      REPOSITION qbf-query-':u qbf-sfx 
      	       ' TO ROWID qbf_currid NO-ERROR.':u SKIP
      '      IF NOT ERROR-STATUS:ERROR THEN':u SKIP
      '	       GET NEXT qbf-query-':u qbf-sfx ' NO-LOCK.':u SKIP
      '      qbf_currid = ?.':u SKIP
      '      RETURN.':u SKIP
      '    END.':u SKIP.
  PUT UNFORMATTED
    '    IF caller = "first" THEN':u SKIP
    '      GET FIRST qbf-query-':u qbf-sfx ' NO-LOCK.':u SKIP
    '    ELSE':u SKIP
    '      RUN get-first-':u qbf-sfx '.':u SKIP
    '  END.':u SKIP.
  IF qbf-module = "b":u THEN
    PUT UNFORMATTED
      '  ELSE':u SKIP
      '    ok = qbf-browse-':u qbf-sfx 
      	    ':SELECT-FOCUSED-ROW() IN FRAME qbf-form-':u qbf-sfx '.':u SKIP.
  PUT UNFORMATTED
    'END.':u SKIP(1).
END. /* generate_reset_current */


/*--------------------------------------------------------------------------*/
/* Generate the code which will enable or disable certain buttons because 
   we are at the end of the record set or there are no records in the 
   result set etc.  The add button isn't affected since we can add whether
   there is a current record or not.

   Input Parameter: 
      supported - list of the supported buttons (e.g., "f,l,n,p,u" for first,
      	       	  last, next, prev, update buttons or "f,l" for first, last).
      	       	  This is so the code will work for both form and browse
      	       	  which contain different button sets.
*/
PROCEDURE generate_button_state:
  DEFINE INPUT PARAMETER supported AS CHAR NO-UNDO.

  /*
  > /* which  - indicates which buttons to toggle.  A comma separated list
  >             of button indicators or "a" for all or "u" for update 
  >             buttons. Specific button indicators are:
  >    	    "f" - first
  >         "p" - prev
  >    	    "l" - last
  >         "n" - next
  >    active - yes if buttons are to be enabled, no to disable.
  > */
  > PROCEDURE button-state-1:
  >   DEFINE INPUT PARAMETER which  AS CHAR    NO-UNDO.
  >   DEFINE INPUT PARAMETER active AS LOGICAL NO-UNDO.
  >
  >  IF which = "a" OR CAN-DO(which, "f") THEN
  >    b_first:SENSITIVE IN FRAME qbf-form-1 = active.
  >  IF which = "a" OR CAN-DO(which, "p") THEN
  >    b_prev:SENSITIVE IN FRAME qbf-form-1 = active.
  >  IF which = "a" OR CAN-DO(which, "n") THEN
  >    b_next:SENSITIVE IN FRAME qbf-form-1 = active.
  >  IF which = "a" OR CAN-DO(which, "l") THEN
  >    b_last:SENSITIVE IN FRAME qbf-form-1 = active.
  >  IF which = "a" OR CAN-DO(which, "u") THEN
  >    ASSIGN
  >      b_update:SENSITIVE IN FRAME qbf-form-1 = active
  >      b_copy:SENSITIVE IN FRAME qbf-form-1 = active
  >      b_delete:SENSITIVE IN FRAME qbf-form-1 = active.
  > END.
  */
  PUT UNFORMATTED 
    'PROCEDURE button-state-':u qbf-sfx ':':u SKIP
    '  DEFINE INPUT PARAMETER which  AS CHAR    NO-UNDO.':u SKIP
    '  DEFINE INPUT PARAMETER active AS LOGICAL NO-UNDO.':u SKIP(1).
  IF CAN-DO (supported, "f":u) THEN
    PUT UNFORMATTED
      '  IF which = "a" OR CAN-DO(which,"f") THEN':u SKIP
      '    b_first:SENSITIVE IN FRAME ':u qbf-section.qbf-sfrm ' = active.':u 
      SKIP.
  IF CAN-DO (supported, "p":u) THEN
    PUT UNFORMATTED
      '  IF which = "a" OR CAN-DO(which,"p") THEN':u SKIP
      '    b_prev:SENSITIVE IN FRAME ':u qbf-section.qbf-sfrm ' = active.':u
      SKIP.
  IF CAN-DO (supported, "n":u) THEN
    PUT UNFORMATTED
      '  IF which = "a" OR CAN-DO(which,"n") THEN':u SKIP
      '    b_next:SENSITIVE IN FRAME ':u qbf-section.qbf-sfrm ' = active.':u 
      SKIP.
  IF CAN-DO (supported, "l":u) THEN
    PUT UNFORMATTED
      '  IF which = "a" OR CAN-DO(which,"l") THEN':u SKIP
      '    b_last:SENSITIVE IN FRAME ':u qbf-section.qbf-sfrm ' = active.':u
      SKIP.

  /* supported indicates if the buttons are supported in general for this
     view.  updateable may still be false, if for example there are fields
     from 2 tables in the form - in that case the update buttons will never
     be sensitive.  Beyond that, we have to see if these operations are 
     allowed from an admin and security point of view (can_add etc.).
  */
  IF CAN-DO (supported, "u":u) AND updateable AND 
     (can_upd OR can_del) THEN DO:
    PUT UNFORMATTED
      '  IF which = "a" OR CAN-DO(which,"u") THEN':u SKIP
      '    ASSIGN':u SKIP.
    IF can_upd THEN
      PUT UNFORMATTED
        '      b_update:SENSITIVE IN FRAME ':u qbf-section.qbf-sfrm 
      	  ' = active':u SKIP.
    IF can_add AND can_upd THEN
      PUT UNFORMATTED
        '      b_copy:SENSITIVE IN FRAME ':u qbf-section.qbf-sfrm 
      	  ' = active':u SKIP.
    IF can_del THEN
      PUT UNFORMATTED
        '      b_delete:SENSITIVE IN FRAME ':u qbf-section.qbf-sfrm
      	  ' = active':u SKIP.
    PUT UNFORMATTED 
      '    .':u SKIP.  /* end of assign */
  END.
  PUT UNFORMATTED
    'END.':u SKIP(1).
END. /* generate_button_state */

/*--------------------------------------------------------------------------*/
/* Generate the code to see if there are any previous records or not.
*/
PROCEDURE generate_any_prev:

  /* 
  > PROCEDURE any-prev-1:
  >   GET PREV qbf-query-1 NO-LOCK NO-WAIT.
  >   anyprev = (AVAILABLE demo.customer OR LOCKED demo.customer).
  >   /* restore query to where we were */
  >   IF anyprev THEN
  >     GET NEXT qbf-query-1 NO-LOCK.
  >   ELSE
  >     GET FIRST qbf-query-1 NO-LOCK.
  */

  PUT UNFORMATTED 
    'PROCEDURE any-prev-':u qbf-sfx ':':u SKIP
    '  GET PREV qbf-query-':u qbf-sfx ' NO-LOCK NO-WAIT.':u SKIP
    '  anyprev = (AVAILABLE ':u qbf-buf ' OR LOCKED ':u qbf-buf ').':u SKIP
    '  IF anyprev THEN':u SKIP
    '    GET NEXT qbf-query-':u qbf-sfx ' NO-LOCK.':u SKIP
    '  ELSE':u SKIP
    '    GET FIRST qbf-query-':u qbf-sfx ' NO-LOCK.':u SKIP
    'END.':u SKIP(1).
END.  /* generate_any_prev */

/*--------------------------------------------------------------------------*/
/* Generate the code to see if there are any next records or not.
*/
PROCEDURE generate_any_next:

  /* 
  > PROCEDURE any-next-1:
  >   GET NEXT qbf-query-1 NO-LOCK NO-WAIT.
  >   anynext = (AVAILABLE demo.customer OR LOCKED demo.customer).
  >   /* restore query to where we were */
  >   IF anynext THEN
  >     GET PREV qbf-query-1 NO-LOCK.
  >   ELSE
  >     GET LAST qbf-query-1 NO-LOCK.
  */

  PUT UNFORMATTED 
    'PROCEDURE any-next-':u qbf-sfx ':':u SKIP
    '  GET NEXT qbf-query-':u qbf-sfx ' NO-LOCK NO-WAIT.':u SKIP
    '  anynext = (AVAILABLE ':u qbf-buf ' OR LOCKED ':u qbf-buf ').':u SKIP
    '  IF anynext THEN':u SKIP
    '    GET PREV qbf-query-':u qbf-sfx ' NO-LOCK.':u SKIP
    '  ELSE':u SKIP
    '    GET LAST qbf-query-':u qbf-sfx ' NO-LOCK.':u SKIP
    'END.':u SKIP(1).
END.  /* generate_any_next */

/*--------------------------------------------------------------------------*/

/* Generate the code at the end of the epilog section.

   Input Parameter: 
      p_index - index into the qbf-frame temp table fields (for form
      	        vs. browse)
*/
PROCEDURE end_epilog:
  DEFINE INPUT PARAMETER p_index AS INTEGER NO-UNDO.

  /* list of the start table (parent table) for all sections */
  DEFINE VARIABLE par_tbls AS CHARACTER NO-UNDO INIT "".

  /*
  > RUN get-first-1.
  > DEFINE VARIABLE ok AS LOGICAL NO-UNDO.
  > ok = FRAME qbf-form-2:MOVE-TO-TOP().
  >
  > DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
  >   WAIT-FOR U1 OF qbf-widxit.
  > END.
  >
  */
  FIND FIRST qbf-section WHERE qbf-section.qbf-sout = "1":u.
  PUT UNFORMATTED SKIP
    'RUN get-first-1.':u SKIP(1).

  FIND FIRST qbf-frame 
    WHERE INDEX(qbf-frame.qbf-fflg[p_index], "t":u) > 0 NO-ERROR.
  IF AVAILABLE qbf-frame THEN DO:
    FIND FIRST qbf-section WHERE qbf-section.qbf-stbl = qbf-frame.qbf-ftbl.
    PUT UNFORMATTED
      'DEFINE VARIABLE ok AS LOGICAL NO-UNDO.':u SKIP
      'ok = FRAME ':u qbf-section.qbf-sfrm ':MOVE-TO-TOP().':u SKIP.
  END.

  PUT UNFORMATTED
    'DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:':u SKIP
    '  WAIT-FOR ':u 
      (IF usage = "r":u THEN 'U1':u ELSE 'GO':u)
      ' OF qbf-widxit.':u SKIP
    'END.':u SKIP(1).

  /*
  > /* Results environment only */
  > RUN aderes/_fbid.p ("b":u, 1, STRING(ROWID(Customer))). 
  > RUN aderes/_fbid.p ("b":u, 2, STRING(ROWID(Order))). 
  >
  > HIDE FRAME qbf-form-1 NO-PAUSE.
  > IF qbf-flag-1 THEN CLOSE QUERY qbf-query-1.
  > HIDE FRAME qbf-form-2 NO-PAUSE.
  > IF qbf-flag-2 THEN CLOSE QUERY qbf-query-2.
  >
  */
  IF usage = "r":u THEN 
    RUN generate_store_ids ("", TRUE, "").

  FOR EACH qbf-section BREAK BY qbf-section.qbf-sfrm:
    qbf-sfx = ENTRY({&FNAM_COMP},qbf-section.qbf-sfrm,"-":u).
    IF FIRST-OF(qbf-section.qbf-sfrm) THEN DO:
      /* it's a convenient time to find par_tbls */
      par_tbls = par_tbls + (IF par_tbls = "" THEN "" ELSE ",":u) + 
      	         ENTRY(1,qbf-section.qbf-stbl).
      PUT UNFORMATTED
        'HIDE FRAME ':u qbf-section.qbf-sfrm ' NO-PAUSE.':u SKIP
        'IF qbf-flag-':u qbf-sfx ' THEN CLOSE QUERY qbf-query-':u qbf-sfx '.':u.
    END.
    IF LAST(qbf-section.qbf-sfrm) THEN PUT UNFORMATTED SKIP(1).
    ELSE
    IF FIRST-OF(qbf-section.qbf-sfrm) THEN PUT UNFORMATTED SKIP.
  END.

  /* we support now -dma 
  /* If there's any outer join within a section - display disclaimer */
  IF usage = "r":u THEN DO:
     FIND FIRST qbf-where WHERE  
       qbf-where.qbf-wojo AND
       NOT CAN-DO(par_tbls, STRING(qbf-where.qbf-wtbl)) NO-ERROR.
     IF AVAILABLE qbf-where THEN
      RUN adecomm/_statdsp.p (wGlbStatus, 1, 
      	SUBSTITUTE("No complete join support within a &1 section",
      	  (IF qbf-module = "b":u THEN "browse" ELSE "form"))).
  END.
  */
END. /* end_epilog */

/*--------------------------------------------------------------------------*/

/* Generate the code to store the current ROWID(s) that represent 
   the current position in the query.
   (This may or may not get called from inside a qbf-section loop.)

   Input Parameter: 
      p_frame  - Only do it for this frame or "" for all frames.
      p_extern - TRUE: we're generating code to store ids into a results 
      	       	       variable
      	         FALSE: we're generating code to store ids into a variable 
      	       	     	that's also in the generated code
      p_margin - Indent margin
*/
PROCEDURE generate_store_ids:
  DEFINE INPUT PARAMETER p_frame  AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER p_extern AS LOGICAL   NO-UNDO.
  DEFINE INPUT PARAMETER p_margin AS CHARACTER NO-UNDO.

  DEFINE BUFFER qbf_sbuffer FOR qbf-section.
  DEFINE VARIABLE ix  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE sfx AS CHARACTER NO-UNDO.

  FIND FIRST qbf_sbuffer.
  {&FIND_TABLE_BY_ID} INTEGER(ENTRY(1,qbf_sbuffer.qbf-stbl)).
  PUT UNFORMATTED
     p_margin 'IF AVAILABLE (':u qbf-rel-buf.tname ') THEN DO:':u SKIP.

  FOR EACH qbf_sbuffer BREAK BY qbf_sbuffer.qbf-sfrm:
    IF p_frame <> "" AND p_frame <> qbf_sbuffer.qbf-sfrm THEN NEXT.

    IF FIRST-OF(qbf_sbuffer.qbf-sfrm) THEN DO:
      sfx = ENTRY({&FNAM_COMP},qbf_sbuffer.qbf-sfrm,"-":u).
      IF p_extern THEN
        PUT UNFORMATTED
          p_margin '  RUN aderes/_fbid.p ("b":u, ':u sfx 
    	     ', STRING(current-result-row("qbf-query-':u sfx '"))).':u SKIP.
      ELSE
        PUT UNFORMATTED
          p_margin '  qbf-startids[':u sfx 
      	    '] = STRING(current-result-row("qbf-query-':u sfx '")).':u SKIP
          p_margin '  IF qbf-startids[':u sfx '] = ? THEN qbf-startids[':u 
      	    sfx '] = "".':u SKIP.
    END.

    DO ix = 1 TO NUM-ENTRIES(qbf_sbuffer.qbf-stbl):
      {&FIND_TABLE_BY_ID} INTEGER(ENTRY(ix,qbf_sbuffer.qbf-stbl)).
      IF p_extern THEN
        PUT UNFORMATTED
    	  p_margin '  RUN aderes/_fbid.p ("b":u, ':u sfx ', STRING(ROWID(':u 
    	    qbf-rel-buf.tname '))).':u SKIP.
      ELSE
      	PUT UNFORMATTED
      	  p_margin '  qbf-startids[':u sfx '] = qbf-startids[':u sfx
      	    '] + "," + STRING(ROWID(':u qbf-rel-buf.tname ')).':u SKIP.
    END.

    /* cleanup unknown values */
    IF p_extern THEN
      PUT UNFORMATTED
    	p_margin '  RUN aderes/_fbid.p ("c":u, ':u sfx ', "").':u SKIP.
  END.

  PUT UNFORMATTED
     p_margin 'END.':u SKIP.
END. /* generate_store_ids */

/* fbfuncs.i - end of file */

