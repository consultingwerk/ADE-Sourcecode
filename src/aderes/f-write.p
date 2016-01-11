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
 * f-write.p - generate query form program 
 
   Input Parameter:
      usage - Indicates what the output file will be used for. e.g., 
	      "r" for running during a results session, "s" for
	      a saved query, or "g" for a .p to use outside results.
*/
 
&GLOBAL-DEFINE WIN95-BTN YES

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/j-define.i }
{ aderes/y-define.i }
{ aderes/fbdefine.i }
{ aderes/_fdefs.i }
{ aderes/s-menu.i }
{ aderes/reshlp.i }
{ adecomm/adestds.i }
 
DEFINE INPUT PARAMETER usage AS CHARACTER NO-UNDO.
 
&global-define UseButtonImages TRUE
 
DEFINE VARIABLE qbf-i    AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-j    AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-sfx  AS CHARACTER NO-UNDO. /* frame suffix */
DEFINE VARIABLE qbf-psfx AS CHARACTER NO-UNDO. /* parent suffix */
DEFINE VARIABLE qbf-o    AS CHARACTER NO-UNDO INIT "". /* optimized literals */
DEFINE VARIABLE fwid     AS HANDLE    NO-UNDO. /* temp fill widg hdl */
DEFINE VARIABLE frmwid   AS DECIMAL   NO-UNDO. /* frame width */
DEFINE VARIABLE flst-idx AS INTEGER   NO-UNDO INIT 1. /* field list group */
 
/* Updateable is set on a frame by frame basis based on # of tables in
   the form, the user setting from frame properties and whether or not
   the database is read only.  
 
   The *_supp variables indicate if these features are supported based on 
   results security.  This applies to any table, thus any frame.
 
   For each frame, the can_* variables combine the value of the *_supp 
   variables plus takes into account if these features are supported 
   for the table involved in this frame based on dictionary security
   (If there's more than 1 table updateable will be false anyway).
   Note: in order to add can_upd must also be true.
 
   If either updateable or the can_* variable is false, the function button 
   is grayed out and the button trigger code isn't generated. (This last is 
   important for db security since the code won't even compile if there's a 
   CREATE cust statement in the .p when user doesn't have add privileges on 
   cust.
*/
DEFINE VARIABLE updateable AS LOGICAL   NO-UNDO. 
DEFINE VARIABLE a_supp     AS LOGICAL   NO-UNDO. /* add supported?*/
DEFINE VARIABLE d_supp     AS LOGICAL   NO-UNDO. /* delete supported?*/
DEFINE VARIABLE u_supp     AS LOGICAL   NO-UNDO. /* update supported?*/
DEFINE VARIABLE can_add    AS LOGICAL   NO-UNDO. /* can add? */
DEFINE VARIABLE can_del    AS LOGICAL   NO-UNDO. /* can delete?*/
DEFINE VARIABLE can_upd    AS LOGICAL   NO-UNDO. /* can update?*/
 
/* qbf-tbl is the real, qualified table name (e.g., demo.customer)
   qbf-buf is the qualified buffer name which for most tables is the same
	   as qbf-tbl but may not be if table is an alias (e.g., demo.manager).
	   This is the string that users see and is used to refer to the 
	   table in all generated code.
   qbf-par is the qualified buffer name of the parent table in the query.
*/
DEFINE VARIABLE qbf-tbl  AS CHARACTER NO-UNDO. 
DEFINE VARIABLE qbf-buf  AS CHARACTER NO-UNDO. 
DEFINE VARIABLE qbf-par  AS CHARACTER NO-UNDO.
 
DEFINE BUFFER qbf-sparent FOR qbf-section.

DEFINE TEMP-TABLE fldlst /* dma */
  FIELD tt-index  AS INTEGER
  FIELD tt-frame  AS CHARACTER
  FIELD tt-fields AS CHARACTER
  INDEX tt-frame IS PRIMARY UNIQUE tt-frame tt-index
  .
  
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
 
/*-----------------------------------------------------------------------*/
 
RUN aderes/_fbempty.p (usage).
IF RETURN-VALUE = "error":u THEN 
  RETURN "error":u.
 
RUN optimize_literals.
RUN generate_prolog. 
 
/* For Windows, the height of a fill-in with fixed font is not 1
   and the width of the fill-in is kind of indeterminate.
   To determine accurate values, create a temporary widget and query 
   its size after setting the format.  
   It doesn't hurt to do this on all platforms.
*/
CREATE FILL-IN fwid
  ASSIGN
    VISIBLE = FALSE
    FONT    = 0.
 
/* Clear the frame object TEMP-TABLE */
IF usage = "r":u THEN
  FOR EACH qbf-fwid:
    DELETE qbf-fwid.
  END.
    
/* See if the update functions are supported from Admin point of view 
   and from schema security point of view 
*/
RUN adeshar/_mgetfs.p ({&resId}, {&rfRecordAdd},    OUTPUT a_supp).
RUN adeshar/_mgetfs.p ({&resId}, {&rfRecordUpdate}, OUTPUT u_supp).
RUN adeshar/_mgetfs.p ({&resId}, {&rfRecordDelete}, OUTPUT d_supp).
 
/* There shouldn't be any sections where outer join flag is true
   anymore in form mode.  i.e., it used to create a new section
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
    /* won't need qbf-tbl for these functions */
    qbf-sfx = ENTRY({&FNAM_COMP},qbf-section.qbf-sfrm,"-":u).
 
  /* We'll size to fill results window if we're running results now so
     determine what the frame size will be.
  */
  IF usage = "r":u THEN DO:
    /* get frame properties */
    FIND FIRST qbf-frame 
	WHERE qbf-frame.qbf-ftbl = qbf-section.qbf-stbl NO-ERROR.
  
 
    frmwid = (IF AVAILABLE qbf-frame AND qbf-frame.qbf-fwdt > 0 THEN
		MAX(qbf-win:WIDTH, qbf-frame.qbf-fwdt)
	      ELSE
		MAX(qbf-win:WIDTH, def-win-wid)
	     ).
 
    IF frmwid > def-win-wid AND NOT AVAILABLE qbf-frame THEN DO:
      CREATE qbf-frame.
      qbf-frame.qbf-ftbl = qbf-section.qbf-stbl.
      qbf-frame.qbf-fwdt = qbf-win:WIDTH.
    END.
  END.
 
  RUN set_updateable.
  RUN generate_frame (FALSE).  
 
  /* Make the dialog slightly bigger on Windows: the border takes away 
     from the usable space and makes things not fit.
  */
  &IF "{&WINDOW-SYSTEM}":u BEGINS "MS-WIN":u &THEN 
    frmwid = frmwid + 2.
  &ENDIF
 
  IF updateable AND can_upd THEN 
    RUN generate_frame (TRUE).
  IF usage = "r":u THEN
    RUN generate_qbe_frame.
END.
DELETE WIDGET fwid. /* don't need temp widget anymore */
 
FOR EACH qbf-section BY qbf-section.qbf-sfrm:
  qbf-i = R-INDEX(qbf-section.qbf-sout,".":u).
  IF qbf-i > 0 THEN
    FIND FIRST qbf-sparent WHERE qbf-sparent.qbf-sout = 
      SUBSTRING(qbf-section.qbf-sout,1,qbf-i - 1,"CHARACTER":u).
 
  RUN set_updateable.
  {&FIND_TABLE_BY_ID} INTEGER(ENTRY(1,qbf-section.qbf-stbl)).
  ASSIGN
    qbf-sfx = ENTRY({&FNAM_COMP},qbf-section.qbf-sfrm,"-":u)
    qbf-psfx = (IF qbf-i = 0 THEN "" 
                ELSE ENTRY({&FNAM_COMP},qbf-sparent.qbf-sfrm,"-":u))
    qbf-buf = qbf-rel-buf.tname
    qbf-tbl = qbf-buf.
  RUN alias_to_tbname (qbf-tbl, FALSE, OUTPUT qbf-tbl).
  IF qbf-psfx = "" THEN /* we're at top level */  
    qbf-par = qbf-buf.  /* save name of parent */
 
  IF usage <> "g":u THEN
    RUN field_list (qbf-section.qbf-sfrm).

  RUN button_first.
  RUN button_last.
  RUN button_next.
  RUN button_prev.
  RUN button_count.
  IF updateable THEN DO:
    IF can_add AND can_upd THEN DO:
      RUN button_add.
      RUN button_copy.
    END.
    IF can_upd THEN
      RUN button_update.
    IF can_del THEN
      RUN button_delete.
  END.
  IF usage = "r":u THEN
    RUN button_query.
 
  RUN generate_reset_current.
  RUN generate_display ("").
  RUN generate_button_state("f,l,p,n,u":u).
  RUN generate_any_prev.
  RUN generate_any_next.
  IF updateable AND can_upd THEN DO:
    RUN generate_display ("dlg-":u).
    RUN generate_update.
  END.
END.
 
RUN generate_epilog. 

RETURN "".
 
/*--------------------------------------------------------------------------*/
PROCEDURE set_updateable:
 
  DEFINE VARIABLE usr_lst AS CHARACTER NO-UNDO. /* e.g., can-write users */
  DEFINE VARIABLE dbnam   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE realtbl AS CHARACTER NO-UNDO.
 
 
  /* Get form entry corresponding to current section */
  FIND FIRST qbf-frame WHERE qbf-frame.qbf-ftbl = qbf-section.qbf-stbl NO-ERROR.
 
  /* updateable if only 1 table, not read-only, and Full Progress. */
  updateable = (NUM-ENTRIES(qbf-section.qbf-stbl) = 1).
  IF updateable AND AVAILABLE qbf-frame AND qbf-frame.qbf-frow[{&F_IX}] > 0 THEN
    updateable = (INDEX(qbf-frame.qbf-fflg[{&F_IX}], "r":u) = 0).
  IF updateable THEN DO:
    {&FIND_TABLE_BY_ID} INTEGER(qbf-section.qbf-stbl).
    dbnam = ENTRY(1,qbf-rel-buf.tname, ".":u).
    updateable = NOT CAN-DO(DBRESTRICTIONS(dbnam), "Read-Only":u).
  END.
  updateable = (PROGRESS = "FULL":u).
  
  ASSIGN
    can_add = a_supp
    can_del = d_supp
    can_upd = u_supp.
 
  /* Only check schema security if we can update in general */
  IF updateable AND (can_add OR can_del OR can_upd) THEN DO:
    RUN alias_to_tbname (qbf-rel-buf.tname, FALSE, OUTPUT realtbl).
    IF can_add THEN DO:
      RUN aderes/s-schema.p (realtbl, "", "", "FILE:CAN-CREATE":u,
			     OUTPUT usr_lst).
      can_add = CAN-DO(usr_lst, USERID(dbnam)).
    END.
    IF can_del THEN DO:
      RUN aderes/s-schema.p (realtbl, "", "", "FILE:CAN-DELETE":u,
			     OUTPUT usr_lst).
      can_del = CAN-DO(usr_lst, USERID(dbnam)).
    END.
    IF can_upd THEN DO:
      RUN aderes/s-schema.p (realtbl, "", "", "FILE:CAN-WRITE":u,
			     OUTPUT usr_lst).
      can_upd = CAN-DO(usr_lst, USERID(dbnam)).
    END.
  END.
END.
 
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
 
  /* If not outermost query, die now if parent unavailable. */
  /*
  >   IF NOT qbf-flag-1 THEN RETURN.
  >   /* the following may happen if we just deleted detail record 
  >      which was also the parent! - i.e., if we have an alias and 
  >      record is joined to itself.
  >   */
  >   IF NOT AVAILABLE junk.customer THEN DO:
  >     APPLY "CHOOSE" TO b_next IN FRAME qbf-form-1. 
  >     RETURN.
  >   END.   
  */
  IF qbf-psfx <> "" THEN
    PUT UNFORMATTED
      '  IF NOT qbf-flag-':u qbf-psfx ' THEN RETURN.':u SKIP
      '  IF NOT AVAILABLE ':u qbf-par ' THEN DO:':u SKIP
      '    APPLY "CHOOSE" TO b_next IN FRAME qbf-form-':u qbf-psfx '.' SKIP
      '    RETURN.':u SKIP
      '  END.':u SKIP.
 
  /* Now open the thing and check for an empty query and */
  /* if not empty display the frame. */
  /*
  >   /* results environment only */
  >   RUN qbfq1.p. /* opens the query */ 
  > OR
  >   /* For non-results environment only */
  >   OPEN QUERY qbf-query-1 
  >     FOR EACH demo.customer.
  >
  >   qbf-flag-1 = FALSE.
  >   IF qbf-startids[1] <> "" THEN DO:
  >     ok = CURRENT-WINDOW:LOAD-MOUSE-POINTER("WAIT").
  >     RUN reset-current-1("first").
  >     ok = CURRENT-WINDOW:LOAD-MOUSE-POINTER("").
  >     qbf-flag-1 = (AVAILABLE demo.customer).
  >   END.
  >   IF NOT qbf-flag-1 THEN DO:
  >     GET FIRST qbf-query-1 NO-LOCK.
  >     qbf-flag-1 = (AVAILABLE demo.customer).
  >   END.
  >   IF qbf-flag-1 THEN DO:
  >     RUN display-form-1.
  >     RUN any-prev-1.
  >     RUN button-state-1 ("f,p", anyprev).
  >     RUN any-next-1.
  >     RUN button-state-1 ("l,n", anynext).
  >     RUN button-state-1 ("u", TRUE). /* all update buttons */
  */
 
  IF usage = "r":u THEN 
    PUT UNFORMATTED
      '  RUN qbfq':u qbf-sfx '.p.':u SKIP.
  ELSE
    RUN aderes/_fbquery.p (qbf-sfx, qbf-section.qbf-sout, "", 2, "  ":u).
 
  PUT UNFORMATTED
    '  qbf-flag-':u qbf-sfx ' = FALSE.':u SKIP
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
    '  IF NOT qbf-flag-':u qbf-sfx ' THEN DO:':u SKIP
    '    GET FIRST qbf-query-':u qbf-sfx ' NO-LOCK.':u SKIP
    '    qbf-flag-':u qbf-sfx ' = (AVAILABLE ':u qbf-buf ').':u SKIP
    '  END.':u SKIP
    '  IF qbf-flag-':u qbf-sfx ' THEN DO:':u SKIP
    '    RUN display-form-':u qbf-sfx '.':u SKIP
    '    RUN any-prev-':u qbf-sfx '.':u SKIP
    '    RUN button-state-':u qbf-sfx '("f,p", anyprev).':u SKIP
    '    RUN any-next-':u qbf-sfx '.':u SKIP
    '    RUN button-state-':u qbf-sfx '("l,n", anynext).':u SKIP
    '    RUN button-state-':u qbf-sfx '("u", TRUE).':u SKIP.
 
  /* Get 'First' for each of my immediate children */
  /*
  >   RUN get-first-2.
  */
  RUN first_to_kids (qbf-section.qbf-sout,'    ':u).
 
  /* If no records in parent, close child queries and clear */
  /*
  >   END.
  >   ELSE DO:
  >     CLEAR FRAME qbf-form-1 NO-PAUSE.
  >     CLOSE QUERY qbf-query-1.
  >     RUN button-state-1 ("a", FALSE).
  >     CLEAR FRAME qbf-form-2 NO-PAUSE.
  >     CLOSE QUERY qbf-query-2.
  >     RUN button-state-2 ("a", FALSE).
  >     qbf-flag-2 = FALSE.
  >   END.
  > END.
  */
  PUT UNFORMATTED
    '  END.':u SKIP
    '  ELSE DO:':u SKIP
    '    CLEAR FRAME ':u qbf-section.qbf-sfrm ' NO-PAUSE.':u SKIP
    '    CLOSE QUERY qbf-query-':u qbf-sfx '.':u SKIP
    '    RUN button-state-':u qbf-sfx '("a", FALSE).':u SKIP.
  RUN close_kids (TRUE).
  PUT UNFORMATTED
    '  END.':u SKIP
    'END.':u SKIP(1).
END PROCEDURE. /* button_first */
 
/*--------------------------------------------------------------------------*/
 
PROCEDURE button_next:
  /* Begin the trigger.  If I'm not open, then return. */
  /*
  > ON CHOOSE OF b_next IN FRAME qbf-form-1 DO:
  >   IF NOT qbf-flag-1 THEN RETURN.
  */
  PUT UNFORMATTED
    'ON CHOOSE OF b_next IN FRAME ':u qbf-section.qbf-sfrm ' DO:':u SKIP
    '  IF NOT qbf-flag-':u qbf-sfx ' THEN RETURN.':u SKIP.
 
  /* Check for 'someone else deleted a record out from under us' case. */
  /* If we're ok, display the frame */
  /*
  >   GET NEXT qbf-query-1 NO-LOCK.
  >   IF NOT AVAILABLE demo.customer THEN DO:
  >     /* someone else deleted a record out from under us */
  >     RUN button-state-2 ("l", TRUE).
  >     APPLY "CHOOSE" TO b_last IN FRAME qbf-form-1.
  >     RETURN.
  >   END.
  >   RUN display-form-1.
  >   RUN button-state-1("f,p", TRUE).
  >   RUN any-next-1.
  >   RUN button-state-1("l,n", anynext).
  */
  PUT UNFORMATTED
    '  GET NEXT qbf-query-':u qbf-sfx ' NO-LOCK.':u SKIP
    '  IF NOT AVAILABLE ':u qbf-buf ' THEN DO:':u SKIP
    '    RUN button-state-':u qbf-sfx '("l", TRUE).':u SKIP
    '    APPLY "CHOOSE" TO b_last IN FRAME ':u qbf-section.qbf-sfrm '.':u SKIP
    '    RETURN.':u SKIP
    '  END.':u SKIP
    '  RUN display-form-':u qbf-sfx '.':u SKIP
    '  RUN button-state-':u qbf-sfx '("f,p", TRUE).':u SKIP
    '  RUN any-next-':u qbf-sfx '.':u SKIP
    '  RUN button-state-':u qbf-sfx '("l,n", anynext).':u SKIP.
 
 
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
END PROCEDURE. /* button_next */
 
/*--------------------------------------------------------------------------*/
 
PROCEDURE button_prev:
  /* Begin the trigger.  If I'm not open, then return. */
  /*
  > ON CHOOSE OF b_prev IN FRAME qbf-form-1 DO:
  >   IF NOT qbf-flag-1 THEN RETURN.
  */
  PUT UNFORMATTED
    'ON CHOOSE OF b_prev IN FRAME ':u qbf-section.qbf-sfrm ' DO:':u SKIP
    '  IF NOT qbf-flag-':u qbf-sfx ' THEN RETURN.':u SKIP.
 
  /* Check for 'someone else deleted a record out from under us' case. */
  /* If we're ok, display the frame */
  /*
  >   GET PREV qbf-query-1 NO-LOCK.
  >   IF NOT AVAILABLE demo.customer THEN DO:
  >     RUN get-first-1.
  >     RETURN.
  >   END.
  >   RUN display-form-1.
  >   RUN button-state-1 ("l,n", TRUE).
  >   RUN any-prev-1.
  >   RUN button-state-1 ("f,p", anyprev).
  */
  PUT UNFORMATTED
    '  GET PREV qbf-query-':u qbf-sfx ' NO-LOCK.':u SKIP
    '  IF NOT AVAILABLE ':u qbf-buf ' THEN DO:':u SKIP
    '    RUN get-first-':u qbf-sfx '.':u SKIP
    '    RETURN.':u SKIP
    '  END.':u SKIP
    '  RUN display-form-':u qbf-sfx '.':u SKIP
    '  RUN button-state-':u qbf-sfx '("l,n", TRUE).':u SKIP
    '  RUN any-prev-':u qbf-sfx '.':u SKIP
    '  RUN button-state-':u qbf-sfx '("f,p", anyprev).':u SKIP.
 
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
 
END PROCEDURE. /* button_prev */
 
/*--------------------------------------------------------------------------*/
 
PROCEDURE button_add:
  /*
  > ON CHOOSE OF b_add IN FRAME qbf-form-1 DO:
  >   qbf_currid = ROWID(demo.customer).
  >   DO TRANSACTION ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE 
  >      ON STOP UNDO, LEAVE:
  >     CREATE demo.customer.
  >     FRAME dlg-qbf-form-1:TITLE = "Add - " + FRAME dlg-qbf-form-1:TITLE.
  >     RUN update-form-1(FALSE).
  >     FRAME dlg-qbf-form-1:TITLE = SUBSTRING(FRAME dlg-qbf-form-1:TITLE,6,-1,"CHARACTER":u).
  >     IF RETURN-VALUE = "cancel" THEN 
  >       UNDO, LEAVE.
  >   END.
  > END.
  */
  PUT UNFORMATTED
    'ON CHOOSE OF b_add IN FRAME ':u qbf-section.qbf-sfrm ' DO:':u SKIP
    '  qbf_currid = ROWID(':u qbf-buf ').':u SKIP
    '  DO TRANSACTION':u SKIP
    '     ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE ON STOP UNDO, LEAVE:':u SKIP
    '    CREATE ':u qbf-buf  '.':u SKIP
    '    FRAME dlg-qbf-form-':u qbf-sfx ':TITLE = "':u 'Add'
	    ' - " + FRAME dlg-qbf-form-':u qbf-sfx ':TITLE.':u SKIP
    '    RUN update-form-':u qbf-sfx '(FALSE).':u SKIP
    '    FRAME dlg-qbf-form-':u qbf-sfx ':TITLE = ':u SKIP
    '      SUBSTRING(FRAME dlg-qbf-form-':u
	   qbf-sfx ':TITLE, ':u LENGTH("Add - ","CHARACTER":u) + 1 
	   ',-1,"CHARACTER":u).':u SKIP
    '    IF RETURN-VALUE = "cancel" THEN':u SKIP
    '      UNDO, LEAVE.':u SKIP
    '  END.':u SKIP
    'END.':u SKIP(1).
END PROCEDURE. /* button_add */
 
/*--------------------------------------------------------------------------*/
 
PROCEDURE button_update:
  /*
  > ON CHOOSE OF b_update IN FRAME qbf-form-1 DO:
  >   FRAME dlg-qbf-form-1:TITLE = "Update - " + FRAME dlg-qbf-form-1:TITLE.
  >   RUN update-form-1(FALSE).
  >   /* In case record had changed when we re-read it, it looks funny
  >      if user doesn't see newest values in the main form so display it.
  >   */
  >   RUN display-form-1.
  >   FRAME dlg-qbf-form-1:TITLE = SUBSTRING(FRAME dlg-qbf-form-1:TITLE,9,-1,"CHARACTER":u).
  > END.
  */
  PUT UNFORMATTED
    'ON CHOOSE OF b_update IN FRAME ':u qbf-section.qbf-sfrm ' DO:':u SKIP
    '  FRAME dlg-qbf-form-':u qbf-sfx ':TITLE = "':u 'Update'
	  ' - " + FRAME dlg-qbf-form-':u qbf-sfx ':TITLE.':u SKIP
    '  RUN update-form-':u qbf-sfx '(FALSE).':u SKIP
    '  RUN display-form-':u qbf-sfx '.':u SKIP
    '  FRAME dlg-qbf-form-':u qbf-sfx ':TITLE = ':u SKIP
    '    SUBSTRING(FRAME dlg-qbf-form-':u
	 qbf-sfx ':TITLE, ':u LENGTH("Update - ","CHARACTER":u) + 1 
	 ',-1,"CHARACTER":u).':u SKIP
    'END.':u SKIP(1).
END PROCEDURE.  /* button_update */
 
/*--------------------------------------------------------------------------*/
 
PROCEDURE button_copy:
  DEFINE VARIABLE dbnam  AS CHARACTER NO-UNDO.   /* just db part */
  DEFINE VARIABLE tbnam  AS CHARACTER NO-UNDO.   /* just table part */
  DEFINE VARIABLE ix     AS INTEGER   NO-UNDO.   /* scrap/index */
  DEFINE VARIABLE dbid   AS ROWID     NO-UNDO.   /* ROWID of _Db record */
 
  /*
  > ON CHOOSE OF b_copy IN FRAME qbf-form-1 DO:
  >   DEFINE BUFFER qbf-bufx FOR demo.customer.
  >   DO TRANSACTION ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE 
  >      ON STOP UNDO, LEAVE:
  >     FIND qbf-bufx WHERE ROWID(qbf-bufx) = ROWID(demo.customer) NO-LOCK.
  >     RUN display-dlg-form-1(TRUE).
  >     qbf_currid = ROWID(demo.customer).
  >     CREATE demo.customer.
  >     FRAME dlg-qbf-form-1:TITLE = "Copy - " + FRAME dlg-qbf-form-1:TITLE.
  >     RUN update-form-1(TRUE).
  >     FRAME dlg-qbf-form-1:TITLE = SUBSTRING(FRAME dlg-qbf-form-1:TITLE,7,-1,"CHARACTER":u).
  >     IF RETURN-VALUE = "cancel" THEN 
  >       UNDO, LEAVE.
  >     ASSIGN
  >       demo.customer.Address = qbf-bufx.Address
  >       demo.customer.zip = qbf-bufx.zip.
  >     /* Don't do ROWID till we have to since this forces create of key
  >        and may prematurely get a dup key error on the default values.
  >     */
  >     qbf_id = ROWID(demo.customer).
  >     RELEASE demo.customer.
  >     qbf-startids[1] = "," + STRING(qbf_id).
  >     RUN get-first-1.
  >   END.
  >   /* Getting the ROWID may cause a duplicate key error. Make sure the
  >      dialog goes away or we'll run into a GUI WAIT-FOR problem.
  >   */
  >   HIDE FRAME dlg-qbf-form-1.
  > END.
  */
  PUT UNFORMATTED
    'ON CHOOSE OF b_copy IN FRAME ':u qbf-section.qbf-sfrm ' DO:':u SKIP
    '  DEFINE BUFFER qbf-bufx FOR ':u qbf-tbl '.':u SKIP(1)
    '  DO TRANSACTION':u SKIP
    '     ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE ON STOP UNDO, LEAVE:':u SKIP
    '    FIND qbf-bufx WHERE ROWID(qbf-bufx) = ROWID(':u qbf-buf 
           ') NO-LOCK.':u SKIP
    '    RUN display-dlg-form-':u qbf-sfx '(TRUE).':u SKIP
    '    qbf_currid = ROWID(':u qbf-buf ').':u SKIP
    '    CREATE ':u qbf-buf '.' SKIP
    '    FRAME dlg-qbf-form-':u qbf-sfx ':TITLE = "':u 'Copy'
	    ' - " + FRAME dlg-qbf-form-':u qbf-sfx ':TITLE.':u SKIP
    '    RUN update-form-':u qbf-sfx '(TRUE).':u SKIP
    '    FRAME dlg-qbf-form-':u qbf-sfx ':TITLE = ':u SKIP
    '      SUBSTRING(FRAME dlg-qbf-form-':u
	   qbf-sfx ':TITLE, ':u LENGTH("Copy - ","CHARACTER":u) + 1 
	   ',-1,"CHARACTER":u).':u SKIP
    '    IF RETURN-VALUE = "cancel" THEN':u SKIP
    '      UNDO, LEAVE.':u SKIP.
  
 
  /* Copy all the field values from the current record (in buffer qbf-bufx)
     to the new buffer record (e.g., customer) except for the ones that
     were just updated.  We can't do this before hand (when we could copy
     all fields without worrying about clobbering anything) because if
     there are any unique indices, we will get a duplicate error.  Whereas
     if we do it afterward, the user may now have changed one of the
     fields that particpate in this unique index so it will be ok.
  */
  ASSIGN
    ix    = INDEX(qbf-tbl, ".")
    dbnam = SUBSTRING(qbf-tbl,1,ix - 1,"CHARACTER":u)
    tbnam = SUBSTRING(qbf-tbl,ix + 1,-1,"CHARACTER":u).
 
  /* This generates an ASSIGN to copy all the fields.  We have to do
     it in a separate .p so that if the alias changed, it will
     take effect and we'll get the fields from the correct database.
  */
  CREATE ALIAS QBF$0 FOR DATABASE VALUE(SDBNAME(dbnam)).
  RUN aderes/_fcopy.p (dbnam, tbnam, qbf-buf, qbf-section.qbf-sout).
 
  PUT UNFORMATTED
    '    qbf_id = ROWID(':u qbf-buf ').':u SKIP
    '    RELEASE ':u qbf-buf '.':u SKIP
    '    qbf-startids[':u qbf-sfx '] = "," + STRING(qbf_id).':u SKIP
    '    RUN get-first-':u qbf-sfx '.':u SKIP
    '  END.':u SKIP
    '  HIDE FRAME dlg-qbf-form-':u qbf-sfx '.':u SKIP
    'END.':u SKIP(1).
END PROCEDURE. /* button_copy */
 
/*--------------------------------------------------------------------------*/
 
PROCEDURE button_delete:
 
  /*
  > ON CHOOSE OF b_delete IN FRAME qbf-form-1 DO:
  >   DEFINE VARIABLE qbf_kill AS LOGICAL INITIAL FALSE NO-UNDO.
  >   MESSAGE "Are you sure you want to remove this customer record?"
  >           VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE qbf_kill.
  >   IF NOT qbf_kill THEN RETURN NO-APPLY.
  >   DO TRANSACTION 
  >      ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE ON STOP UNDO, LEAVE:
  >     qbf_id = ROWID(demo.Customer).
  >     FIND demo.Customer WHERE ROWID(demo.Customer) = qbf_id EXCLUSIVE-LOCK.
  >     DELETE demo.customer.
  >     RUN button-state-1 ("n", TRUE).
  >     APPLY "CHOOSE" TO b_next IN FRAME qbf-form-1.
  >     RUN get-first-2.  /* for children */
  >   END.
  > END.
  */
  PUT UNFORMATTED
    'ON CHOOSE OF b_delete IN FRAME ':u qbf-section.qbf-sfrm ' DO:':u SKIP
    '  DEFINE VARIABLE qbf_kill AS LOGICAL INITIAL FALSE NO-UNDO.':u SKIP(1)
    '  MESSAGE':u SKIP
    '     "Are you sure you want to remove this ' qbf-buf ' record?"' SKIP
    '     VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE qbf_kill.':u SKIP
    '  IF NOT qbf_kill THEN RETURN NO-APPLY.':u SKIP
    '  DO TRANSACTION':u SKIP
    '     ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE ON STOP UNDO, LEAVE:':u SKIP
    '    qbf_id = ROWID(':u qbf-buf ').':u SKIP
    '    FIND ':u qbf-buf ' WHERE ROWID(':u qbf-buf 
	   ') = qbf_id EXCLUSIVE-LOCK.':u SKIP
    '    DELETE ':u qbf-buf '.':u SKIP
    '    RUN button-state-':u qbf-sfx '("n", TRUE).':u SKIP
    '    APPLY "CHOOSE" TO b_next IN FRAME ':u qbf-section.qbf-sfrm '.' SKIP.
  RUN first_to_kids (qbf-section.qbf-sout,'    ':u).
  PUT UNFORMATTED
    '  END.':u SKIP
    'END.':u SKIP(1).
END PROCEDURE. /* button_delete */
 
/*--------------------------------------------------------------------------*/
 
PROCEDURE button_query:
  DEFINE VARIABLE qbf_i   AS INTEGER NO-UNDO. /* scrap/loop */
  DEFINE VARIABLE ix_min  AS INTEGER NO-UNDO INIT 0.
  DEFINE VARIABLE ix_max  AS INTEGER NO-UNDO INIT 0.
  DEFINE VARIABLE ix_skip AS CHAR    NO-UNDO INIT "".
 
  DEFINE BUFFER qbf_sbuffer FOR qbf-section.
 
  /* Determine the min and max index into the qbf-rcx arrays for this frame. */
  DO qbf_i = 1 TO qbf-rc#:
    IF {&TEXT_LIT} OR {&CALCULATED} THEN NEXT.
    IF qbf-rcs[qbf_i] = qbf-section.qbf-sout THEN DO: 
      /* Is this field in this frame? */
      IF ix_min = 0 THEN
	ix_min = qbf_i.  /* lowest field ix in this frame */
      ix_max = qbf_i. /* highest field ix in this frame so far */
    END.
  END. 
  /* Set ix_skip to the list of field indexes between min and max that 
     aren't in the frame - fields in 1 frame aren't necessarily contiguous.
  */
  DO qbf_i = ix_min TO ix_max WHILE ix_min > 0:
    IF qbf-rcs[qbf_i] <> qbf-section.qbf-sout THEN 
      /* Is this field not in this frame? */
      ix_skip = ix_skip + (IF ix_skip = "" THEN "" ELSE ",") + STRING(qbf_i).
  END.
 
  /*
  > ON CHOOSE OF b_query IN FRAME qbf-form-1 DO:
  This:
  >   MESSAGE "There are no fields to query on."
  >           VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
  Or:
  >   ON GO OF FRAME qbe-qbf-form-1 DO:
  >     RUN aderes/f-qbe.p (FRAME qbe-qbf-form-1:HANDLE).
  >     IF RETURN-VALUE = "error" THEN
  >       RETURN NO-APPLY.
  >   END.
  >
  >   ON CHOOSE OF b_clear IN FRAME qbe-qbf-form-1 DO:
  >     ASSIGN
  >       qbf-qbefld[3]:SCREEN-VALUE IN FRAME qbf-qbf-form-1 = ""
  >       qbf-qbefld[5]:SCREEN-VALUE IN FRAME qbf-qbf-form-1 = ""
  >       qbf-qbefld[6]:SCREEN-VALUE IN FRAME qbf-qbf-form-1 = ""
  >       .
  >   END.
  >
  >   DO TRANSACTION 
  >      ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE ON STOP UNDO, LEAVE:
  >     UPDATE
  >       qbf-qbefld[3]
  >       qbf-qbefld[5]
  >       qbf-qbefld[6]
  >       b_ok b_cancel b_clear b_help
  >       WITH FRAME qbe-qbf-form-1.
  >     RUN aderes/_fbquery.p ("  ", "1", "SHARED", 0, "").
  >     RUN aderes/_fbquery.p ("  ", "1.1", "SHARED", 0, "").
  >     /* the following is done to parent frame */
  >     RUN get-first-1.
  >   END.
  > END.
  */
  
 PUT UNFORMATTED
    'ON CHOOSE OF b_query IN FRAME ':u qbf-section.qbf-sfrm ' DO:':u SKIP.
  IF ix_min = 0 THEN DO: /* ix_min = 0 if there are no fields in the frame */
    PUT UNFORMATTED
      '  MESSAGE "There are no fields to query on."':u SKIP   
      '    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.':u SKIP
      'END.':u SKIP(1).
    RETURN.
  END.
 
  PUT UNFORMATTED
    '  ON GO OF FRAME qbe-':u qbf-section.qbf-sfrm ' DO:':u SKIP
    '    RUN aderes/f-qbe.p (FRAME qbe-':u 
	    qbf-section.qbf-sfrm ':HANDLE).':u SKIP
    '    IF RETURN-VALUE = "error" THEN':u SKIP
    '      RETURN NO-APPLY.':u SKIP
    '  END.':u SKIP(1)
    '  ON CHOOSE OF b_clear IN FRAME qbe-':u 
	 qbf-section.qbf-sfrm ' DO:':u SKIP
    '    ASSIGN':u SKIP.
 
  /* Output fields for ASSIGN statement. */
  DO qbf_i = ix_min TO ix_max WHILE ix_min > 0:
    /* Skip to next field in this frame if fields aren't contiguous. */
    DO WHILE CAN-DO(ix_skip, STRING(qbf_i)):
       qbf_i = qbf_i + 1.
    END. 
    IF {&TEXT_LIT} OR {&CALCULATED} THEN NEXT.

    IF qbf_i MODULO 21 = 20 THEN 
      PUT UNFORMATTED
	'    .':u SKIP
	'    ASSIGN':u SKIP.
    PUT UNFORMATTED
      '      qbf-qbefld[':u qbf_i ']:SCREEN-VALUE IN FRAME qbe-':u
	 qbf-section.qbf-sfrm ' = ""':u SKIP.
  END.
 
  PUT UNFORMATTED
    '    .':u SKIP
    '  END.':u SKIP(1)
    '  DO TRANSACTION':u SKIP
    '     ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE ON STOP UNDO, LEAVE:':u SKIP
    '    UPDATE':u SKIP.
 
  /* Output fields for UPDATE statement. */
  DO qbf_i = ix_min TO ix_max WHILE ix_min > 0:
    /* Skip to next field in this frame if fields aren't contiguous. */
    DO WHILE CAN-DO(ix_skip, STRING(qbf_i)):
       qbf_i = qbf_i + 1.
    END. 
    IF {&TEXT_LIT} OR {&CALCULATED} THEN NEXT.
    PUT UNFORMATTED
      '      qbf-qbefld[':u qbf_i ']':u SKIP.
  END. 
 
  PUT UNFORMATTED
    '      b_ok b_cancel b_clear b_help':u SKIP
    '      WITH FRAME qbe-':u qbf-section.qbf-sfrm '.':u SKIP.
 
  /* Regen the open query code for each frame. */
  FOR EACH qbf_sbuffer: 
    PUT UNFORMATTED
      '    RUN aderes/_fbquery.p ("':u 
	   ENTRY({&FNAM_COMP},qbf_sbuffer.qbf-sfrm,"-":u) '", "':u 
	   qbf_sbuffer.qbf-sout '", "SHARED", 0, "").':u SKIP.
  END.
 
  /* NOTE: the parent is the immediate parent - if we ever have more than
     2 levels, we'll need the top parent here.
  */
  PUT UNFORMATTED
    '    RUN get-first-':u 
	 (IF qbf-psfx = "" THEN qbf-sfx ELSE qbf-psfx) '.':u SKIP
    '  END.':u SKIP
    'END.':u SKIP(1).
END.  /* end button_query */
 
/*--------------------------------------------------------------------------*/
 
PROCEDURE generate_display:
  DEFINE INPUT PARAMETER qbf_dlg AS CHARACTER NO-UNDO. /* "dlg-" or "" */
 
  /*
  > PROCEDURE display-form-1:  /* or display-dlg-form-1 */
  >   /* Only for dlg case: */
  >   DEFINE INPUT PARAMETER p_copy AS LOGICAL NO-UNDO.
  >
  >   FIND FIRST qbf-004-buffer WHERE qbf-004-buffer.Cust-Num = 
  >     res2.Invoice.Cust-Num NO-LOCK NO-ERROR.
  >   qbf-003 = res2.Invoice.Amount * 100 / qbf-003%
  >
  >   DISPLAY
  >     demo.customer.cust-num
  >     demo.customer.name 
  >     qbf-003
  >     qbf-004 WHEN qbf-004 <> ?
  >     "?" WHEN qbf-004 = ? @ qbf-004
  >     WITH FRAME qbf-form-1.
  */
  PUT UNFORMATTED
    'PROCEDURE display-':u qbf_dlg 'form-':u qbf-sfx ':':u SKIP.
 
  IF qbf_dlg <> "" THEN
    PUT UNFORMATTED
      '  DEFINE INPUT PARAMETER p_copy AS LOGICAL NO-UNDO.':u SKIP.
      
  /* do calc field work now. */
  RUN generate_calc (qbf-section.qbf-sout,2,"s,d,n,l,x":u).
 
  RUN field_display ("  ":u, "DISPLAY":u, qbf_dlg).
 
  PUT UNFORMATTED
    'END.':u SKIP(1).
END.  /* end generate_display */
 
/*--------------------------------------------------------------------------*/
 
PROCEDURE generate_update:
 
  /*
  > PROCEDURE update-form-1:
  >   DEFINE INPUT PARAMETER qbf_copy AS LOGICAL NO-UNDO.
  >   DEFINE VARIABLE qbf_can AS LOGICAL INITIAL TRUE NO-UNDO.
  >   DEFINE VARIABLE qbf_new AS LOGICAL              NO-UNDO.
  >   DO TRANSACTION 
  >      ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE ON STOP UNDO, LEAVE:
  >     qbf_new = NEW(demo.Customer).
  >     IF NOT qbf_new THEN DO:
  >       qbf_id = ROWID(demo.Customer).
  >       FIND demo.Customer WHERE ROWID(demo.Customer) = qbf_id EXCLUSIVE-LOCK.
  >     END.
  >     IF NOT qbf_copy THEN
  >       RUN display-dlg-form-1(FALSE).
  >     SET
  >       demo.Customer.Cust-num
  >       WITH FRAME dlg_update-form-1.
  >     HIDE FRAME dlg-qbf-form-1.
  >     IF NOT qbf_copy THEN DO:
  >       /* Don't do ROWID till we have to since this forces create of key
  >          and may prematurely get a dup key error on the default values.
  >       */
  >       qbf_id = ROWID(demo.Customer).
  >       RELEASE demo.Customer.
  >       qbf-startids[1] = "," + STRING(qbf_id).
  >       RUN get-first-1.
  >     END.
  >     qbf_can = FALSE.
  >   END.
  >   /* Progress isn't smart enough to do this if STOP is hit */
  >   HIDE FRAME dlg-qbf-form-1. 
  >   IF qbf_can THEN RETURN "cancel".
  >   RETURN "".
  > END PROCEDURE.
  */
  PUT UNFORMATTED
    'PROCEDURE update-form-':u qbf-sfx ':':u SKIP
    '  DEFINE INPUT PARAMETER qbf_copy AS LOGICAL NO-UNDO.':u SKIP
    '  DEFINE VARIABLE qbf_can AS LOGICAL INITIAL TRUE NO-UNDO.':u SKIP
    '  DEFINE VARIABLE qbf_new AS LOGICAL              NO-UNDO.':u SKIP(1)
    '  DO TRANSACTION':u SKIP
    '     ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE ON STOP UNDO, LEAVE:':u SKIP
    '    qbf_new = NEW(':u qbf-buf ').':u SKIP
    '    IF NOT qbf_new THEN DO:':u SKIP
    '      qbf_id = ROWID(':u qbf-buf ').':u SKIP
    '      FIND ':u qbf-buf ' WHERE ROWID(':u qbf-buf 
	     ') = qbf_id EXCLUSIVE-LOCK.':u SKIP
    '    END.':u SKIP
    '    IF NOT qbf_copy THEN':u SKIP
    '      RUN display-dlg-form-':u qbf-sfx '(FALSE).':u SKIP.
  RUN field_display ("    ":u, "SET":u, "dlg-":u).

  PUT UNFORMATTED 
    '    HIDE FRAME dlg-':u qbf-section.qbf-sfrm '.':u SKIP
    '    IF NOT qbf_copy THEN DO:':u SKIP
    '      qbf_id = ROWID(':u qbf-buf ').':u SKIP
    '      RELEASE ':u qbf-buf '.':u SKIP
    '      qbf-startids[':u qbf-sfx '] = "," + STRING(qbf_id).':u SKIP
    '      RUN get-first-':u qbf-sfx '.':u SKIP
    '    END.':u SKIP
    '    qbf_can = FALSE.':u SKIP
    '  END.':u SKIP
    '  HIDE FRAME dlg-':u qbf-section.qbf-sfrm '.':u SKIP
    '  IF qbf_can THEN RETURN "cancel".':u SKIP
    '  RETURN "".':u SKIP
    'END PROCEDURE.':u SKIP(1).
END PROCEDURE. /* generate_update */
 
/*--------------------------------------------------------------------------*/
 
PROCEDURE generate_prolog:
  DEFINE VARIABLE qbf_i AS INTEGER NO-UNDO.  /* for defbufs.i */
 
  /* write out initialization stuff for calc fields */
  { aderes/c-gen1.i &genUsage = usage}
 
  /* If in RESULTS use shared handle which corresponds to exit
     menu handle.  Otherwise, make a local one.
  */
  IF usage = "r" THEN
    PUT UNFORMATTED
      'DEFINE SHARED VARIABLE qbf-widxit AS HANDLE NO-UNDO.':u SKIP.
  ELSE
    PUT UNFORMATTED
      'DEFINE VARIABLE qbf-widxit AS HANDLE NO-UNDO.':u SKIP.
 
  /* Define "any" flags and button variables for form. */
  PUT UNFORMATTED
    'DEFINE VARIABLE qbf_id      AS ROWID   NO-UNDO.':u SKIP
    'DEFINE VARIABLE qbf_currid  AS ROWID   NO-UNDO.':u SKIP
    'DEFINE VARIABLE anyprev     AS LOGICAL NO-UNDO.':u SKIP
    'DEFINE VARIABLE anynext     AS LOGICAL NO-UNDO.':u SKIP(1)
    &if {&UseButtonImages} &then
      'DEFINE BUTTON b_first IMAGE FILE "adeicon/pvfirst"':u SKIP
      '          IMAGE-DOWN        FILE "adeicon/pvfirstd"':u SKIP
      '          IMAGE-INSENSITIVE FILE "adeicon/pvfirstx"':u SKIP
      /*'          SIZE 5 BY 1.':u SKIP*/
      '          SIZE-PIXELS 32 BY 24.':u SKIP
      'DEFINE BUTTON b_last  IMAGE FILE "adeicon/pvlast"':u SKIP
      '          IMAGE-DOWN        FILE "adeicon/pvlastd"':u SKIP
      '          IMAGE-INSENSITIVE FILE "adeicon/pvlastx"':u SKIP
      /*'          SIZE 5 BY 1.':u SKIP*/
      '          SIZE-PIXELS 32 BY 24.':u SKIP
      'DEFINE BUTTON b_next  IMAGE FILE "adeicon/pvforw"':u SKIP
      '          IMAGE-DOWN        FILE "adeicon/pvforwd"':u SKIP
      '          IMAGE-INSENSITIVE FILE "adeicon/pvforwx"':u SKIP
      /*'          SIZE 5 BY 1.':u SKIP*/
      '          SIZE-PIXELS 32 BY 24.':u SKIP
      'DEFINE BUTTON b_prev  IMAGE FILE "adeicon/pvback"':u SKIP
      '          IMAGE-DOWN        FILE "adeicon/pvbackd"':u SKIP
      '          IMAGE-INSENSITIVE FILE "adeicon/pvbackx"':u SKIP
      /*'          SIZE 5 BY 1.':u SKIP.*/
      '          SIZE-PIXELS 32 BY 24.':u SKIP.
    &else
      'DEFINE BUTTON b_first LABEL "|<" SIZE 5 BY 1.':u SKIP
      'DEFINE BUTTON b_last  LABEL ">|" SIZE 5 BY 1.':u SKIP
      'DEFINE BUTTON b_next  LABEL ">"  SIZE 5 BY 1.':u SKIP
      'DEFINE BUTTON b_prev  LABEL "<"  SIZE 5 BY 1.':u SKIP.
    &endif
  PUT UNFORMATTED
    'DEFINE BUTTON b_add    LABEL "&Add..."    SIZE 11 BY 1 FONT 1.':u SKIP
    'DEFINE BUTTON b_update LABEL "&Update..." SIZE 11 BY 1 FONT 1.':u SKIP
    'DEFINE BUTTON b_copy   LABEL "Cop&y..."   SIZE 11 BY 1 FONT 1.':u SKIP
    'DEFINE BUTTON b_delete LABEL "De&lete"    SIZE 11 BY 1 FONT 1.':u SKIP
    'DEFINE BUTTON b_count  LABEL "&Count"     SIZE 8  BY 1 FONT 1.':u SKIP
    'DEFINE BUTTON b_ok     LABEL "OK"         SIZE 8  BY 1':u  SKIP
    '              MARGIN-EXTRA DEFAULT AUTO-GO FONT 1.':u SKIP
    'DEFINE BUTTON b_cancel LABEL "Cancel" SIZE 8 BY 1':u  SKIP
    '              MARGIN-EXTRA DEFAULT AUTO-ENDKEY FONT 1.':u SKIP
    'DEFINE BUTTON b_clear  LABEL "&Clear Criteria"  SIZE 17 BY 1':u SKIP
    '              MARGIN-EXTRA DEFAULT FONT 1.':u SKIP
    'DEFINE BUTTON b_help  LABEL "&Help"  SIZE 7 BY 1':u SKIP
    '              MARGIN-EXTRA DEFAULT FONT 1.':u SKIP(1)
    '&GLOBAL-DEFINE CLR BGC 8 FGC 0  /* black on gray */':u SKIP(1).
 
  /*
  > DEFINE VARIABLE qbf-startids AS CHARACTER EXTENT 2 INIT [8347, 4632].
  >
  > /* results env. only */
  > DEFINE VARIABLE qbf-qbefld AS CHAR EXTENT 100 NO-UNDO.
  > DEFINE BUTTON b_query LABEL "Query by Example..." SIZE 23 BY 1 FONT 1.
  >
  > DEFINE NEW SHARED BUFFER customer FOR demo.customer.
  > DEFINE NEW SHARED BUFFER order FOR demo.order.
  */
  /* In results we split open query into separate .p for performance
     so buffers must be shared.
  */
  IF usage = "r":u THEN DO:
    PUT UNFORMATTED 
      'DEFINE VARIABLE qbf-startids AS CHARACTER EXTENT 2 INIT ["':u 
	 qbf-rowids[1] '","':u qbf-rowids[2] '"].':u SKIP
      'DEFINE VARIABLE qbf-qbefld  AS CHAR EXTENT ':u qbf-rc# 
	 ' NO-UNDO.':u SKIP
      'DEFINE BUTTON b_query LABEL "Query by &Example..." SIZE 23 BY 1 FONT 1.':u 
      SKIP(1).
    ASSIGN
      qbf-rowids = ""
      qbf-use-rowids = NO.
  END.
  ELSE
    PUT UNFORMATTED
      'DEFINE VARIABLE qbf-startids AS CHARACTER EXTENT 2 INIT ["",""].':u SKIP.
 
  { aderes/defbufs.i &mode = "NEW SHARED " }  /* Define the table buffers */
 
  /*
  > DEFINE VARIABLE qbf-flag-1 AS LOGICAL INITIAL FALSE NO-UNDO.
  > DEFINE NEW SHARED QUERY qbf-query-1
  >   FOR demo.customer
  >   SCROLLING.
  >
  > /* If running in results the open will be in a separate .p 
  >    so generate it now.
  > */
  > OPEN QUERY qbf-query-1
  >   FOR EACH demo.customer
  >   WHERE cust-num > 10
  >   BY demo.customer.cust-num.
  */
  FOR EACH qbf-section BY qbf-section.qbf-sfrm:
    qbf-sfx = ENTRY({&FNAM_COMP},qbf-section.qbf-sfrm,"-":u).
    PUT UNFORMATTED
      'DEFINE VARIABLE qbf-flag-':u qbf-sfx
	' AS LOGICAL INITIAL FALSE NO-UNDO.':u SKIP.
    /* generate define query code */
    RUN aderes/_fbquery.p (qbf-sfx, qbf-section.qbf-sout, 
			  (IF usage = "r":u THEN "NEW SHARED":u ELSE ""),1,"").
    /* also generate separate .p for the open query code */
    IF usage = "r":u THEN
      RUN aderes/_fbquery.p (qbf-sfx,qbf-section.qbf-sout,"SHARED":u,0,"").
  END.
 
END PROCEDURE. /* generate_prolog */
 
/*--------------------------------------------------------------------------*/
 
PROCEDURE generate_epilog:
  DEFINE VARIABLE frst   AS LOGICAL   NO-UNDO INIT YES. /* 1st frm displayed? */
 
  /*
  > /* Setting qbf-widxit will only be done if generating stand-alone .p. */
  > qbf-widxit = FRAME qbf-form-1:HANDLE.
  >
  > /* This will only be done if generating code to run during results session*/
  > RUN aderes/f-store.p (1, "qbf-form-1", FRAME qbf-form-1:HANDLE, 
  >    FRAME dlg-qbf-form-1:HANDLE, FRAME qbe-qbf-form-1:HANDLE).
  >
  > &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
  >   RUN aderes/f-fixup.p (FRAME qbf-form-1:HANDLE).
  >   RUN aderes/f-fixup.p (FRAME dlg-qbf-form-1:HANDLE).
  >   RUN aderes/f-fixup.p (FRAME qbe-qbf-form-1:HANDLE).
  > &ENDIF
  >
  > /* This will only be done if generating code to run during results session*/
  > RUN aderes/_fbframe.p (TRUE, FRAME qbf-form-1:HANDLE, {&F_IX}).
  >
  > ENABLE
  >   b_first b_prev b_next b_last b_add b_update b_copy b_delete b_count
  >   WITH FRAME qbf-form-1
  >
  > /* only for results session */
  > RUN aderes/f-store.p (2, "qbf-form-2", FRAME qbf-form-2:HANDLE, 
  >    dlg-qbf-form-2:HANDLE, FRAME qbe-qbf-form-2:HANDLE).
  >
  > &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
  >   RUN aderes/f-fixup.p (FRAME qbf-form-2:HANDLE).
  >   RUN aderes/f-fixup.p (FRAME dlg-qbf-form-2:HANDLE).
  >   RUN aderes/f-fixup.p (FRAME qbe-qbf-form-2:HANDLE).
  > &ENDIF
  >
  > /* This will only be done if generating code to run during results session*/
  > RUN aderes/_fbframe.p (FALSE, FRAME qbf-form-2:HANDLE, {&F_IX}).
  >
  > ENABLE
  >   b_first b_prev b_next b_last b_add b_update b_copy b_delete b_count
  >   WITH FRAME qbf-form-2
  >
  */
  IF usage <> "r":u THEN DO:
    FIND FIRST qbf-section.
    PUT UNFORMATTED
      'qbf-widxit = FRAME ':u qbf-section.qbf-sfrm ':HANDLE.':u SKIP.
  END.
 
  FOR EACH qbf-section BREAK BY qbf-section.qbf-sfrm:
    IF FIRST-OF(qbf-section.qbf-sfrm) THEN DO:
 
      /* This also gets associated qbf-frame buffer if there is one */
      Run set_updateable.
      qbf-sfx = ENTRY({&FNAM_COMP},qbf-section.qbf-sfrm,"-":u).
      
      /* f-store must come before fixup.p */
      IF usage = "r":u THEN DO:
	PUT UNFORMATTED
	  'RUN aderes/f-store.p (':u qbf-sfx ', "':u qbf-section.qbf-sfrm 
	  '", FRAME ':u qbf-section.qbf-sfrm ':HANDLE,':u SKIP.
	IF updateable AND can_upd THEN
	  PUT UNFORMATTED
	    '   FRAME dlg-':u qbf-section.qbf-sfrm ':HANDLE,':u.
	ELSE
	  PUT UNFORMATTED 
	    '   ?,':u.
	PUT UNFORMATTED 
	  ' FRAME qbe-':u qbf-section.qbf-sfrm ':HANDLE).':u SKIP(1).
      END.
 
      PUT UNFORMATTED
	'&IF "~{&WINDOW-SYSTEM~}" BEGINS "MS-WIN" &THEN':u SKIP
	'  RUN aderes/f-fixup.p (FRAME ':u 
	    qbf-section.qbf-sfrm ':HANDLE).':u SKIP.
      IF updateable AND can_upd THEN
	PUT UNFORMATTED
	  '  RUN aderes/f-fixup.p (FRAME ':u 
	      "dlg-" + qbf-section.qbf-sfrm ':HANDLE).':u SKIP.
      IF usage = "r":u THEN
	PUT UNFORMATTED
	  '  RUN aderes/f-fixup.p (FRAME ':u 
	      "qbe-":u + qbf-section.qbf-sfrm ':HANDLE).':u SKIP.
      PUT UNFORMATTED
	'&ENDIF':u SKIP(1).
      
 
      /* fbframe must come after fixup.p */
      IF usage = "r":u THEN DO:
	PUT UNFORMATTED
	  'RUN aderes/_fbframe.p (':u frst ', FRAME ':u
	    qbf-section.qbf-sfrm ':HANDLE, {&F_IX}).':u SKIP(1).
	frst = FALSE.
      
 
	PUT UNFORMATTED
	  'IF FRAME qbe-':u + qbf-section.qbf-sfrm ':HEIGHT > ':u
	    {aderes/numtoa.i &num="SESSION:HEIGHT"} ' THEN':u SKIP
	  '  ASSIGN':u SKIP
	  '    FRAME qbe-':u + qbf-section.qbf-sfrm ':SCROLLABLE = TRUE':u
	  SKIP
	  '    FRAME qbe-':u + qbf-section.qbf-sfrm ':HEIGHT = ':u
	    {aderes/numtoa.i &num="SESSION:HEIGHT"} '.':u SKIP.
      END.
 
      IF updateable AND can_upd THEN
	PUT UNFORMATTED
	  'IF FRAME dlg-':u + qbf-section.qbf-sfrm ':HEIGHT > ':u
	    {aderes/numtoa.i &num="SESSION:HEIGHT"} ' THEN':u SKIP
	  '  ASSIGN':u SKIP
	  '    FRAME dlg-':u + qbf-section.qbf-sfrm ':SCROLLABLE = TRUE':u
	  SKIP
	  '    FRAME dlg-':u + qbf-section.qbf-sfrm ':HEIGHT = ':u
	    {aderes/numtoa.i &num="SESSION:HEIGHT"} '.':u SKIP.
    
      /* run time adjustment of query-by-example button */ 
      IF usage = "r":u THEN 
	PUT UNFORMATTED
	  'ASSIGN':u SKIP
	  '  b_query:ROW IN FRAME ':u qbf-section.qbf-sfrm ' =':u SKIP
	  '    b_count:ROW IN FRAME ':u qbf-section.qbf-sfrm 
	  ' + b_count:HEIGHT IN FRAME ':u qbf-section.qbf-sfrm 
	  ' + .2':u SKIP
	  '  b_help:COL IN FRAME qbe-':u + qbf-section.qbf-sfrm ' =':u SKIP
	  '    FRAME qbe-':u + qbf-section.qbf-sfrm 
	  ':WIDTH - b_help:WIDTH - 1.':u SKIP(1).

      PUT UNFORMATTED
	'ENABLE':u SKIP
	'  b_first b_prev b_next b_last b_count':u SKIP ''.
      IF updateable THEN DO:
	PUT UNFORMATTED         
	  (IF can_add AND can_upd THEN '  b_add':u ELSE '':u)
	  (IF can_upd THEN             '  b_update':u ELSE '':u)
	  (IF can_add AND can_upd THEN '  b_copy':u ELSE '':u)
	  (IF can_del THEN             '  b_delete':u ELSE '':u).
	IF can_upd OR can_del THEN 
	  PUT UNFORMATTED SKIP.
      END.
      PUT UNFORMATTED
	(IF usage = "r":u THEN '  b_query':u ELSE '':u) SKIP 
	'  WITH FRAME ':u qbf-section.qbf-sfrm '.':u SKIP(1).
    END.
  END.
 
  RUN end_epilog ({&F_IX}).
END PROCEDURE. /* generate_epilog */
 
/*--------------------------------------------------------------------------*/
/* layout the frame */
 
PROCEDURE generate_frame:
  DEFINE INPUT PARAMETER is_dlg AS LOGICAL   NO-UNDO. 
 
  DEFINE VARIABLE qbf_i AS INTEGER   NO-UNDO. /* scrap/loop */
  DEFINE VARIABLE qbf_j AS INTEGER   NO-UNDO. /* field count */
  DEFINE VARIABLE qbf_k AS INTEGER   NO-UNDO. /* scrap/count */
  DEFINE VARIABLE qbf_l AS CHARACTER NO-UNDO. /* sections using this frame */
  DEFINE VARIABLE qbf_n AS CHARACTER NO-UNDO. /* field name */
  DEFINE VARIABLE qbf_t AS CHARACTER NO-UNDO. /* format */
  DEFINE VARIABLE maxrw AS DECIMAL   NO-UNDO INITIAL 0. /* maximum row */
  DEFINE VARIABLE len   AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lbl   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE clm   AS DECIMAL   NO-UNDO. /* column */
  
  DEFINE BUFFER qbf_sbuffer FOR qbf-section.
 
  /* Construct list of sections using this frame. */
  ASSIGN
    qbf_j = 0
    qbf_l = "".
  {&GET_FRAME_SECTIONS}
 
  PUT UNFORMATTED 'FORM':u.
   
  DO qbf_i = 1 TO qbf-rc#:
 
    IF {&NOT_SUPPORTED_IN_FORM} THEN NEXT. 
    {&IF_NOT_IN_FRAME_THEN_NEXT}
 
    /* Start a new frame every 20 fields to avoid exceeding Progress
       statement limit.  Progress merges all frames with same name 
       into one frame.
    */
    IF qbf_j MODULO 21 = 20 THEN
      PUT UNFORMATTED SKIP
	'  WITH FRAME ':u
	(IF is_dlg THEN 'dlg-':u ELSE "":u) qbf-section.qbf-sfrm '.':u SKIP
	'FORM':u SKIP.
  
    ASSIGN
      qbf_j = qbf_j + 1
      qbf_k = 0
      qbf_t = qbf-rcf[qbf_i]
      qbf_n = ENTRY(1,qbf-rcn[qbf_i]).
 
    IF {&TEXT_LIT} THEN /* just put the constant string in the frame */
      PUT UNFORMATTED SKIP
	'  ':u SUBSTRING(qbf-rcn[qbf_i],9,-1,"CHARACTER":u).
    ELSE DO:
      IF qbf-rcl[qbf_i] <> "" THEN
	ASSIGN
	  lbl = REPLACE(qbf-rcl[qbf_i], '"':u, '""':u)
	  {&FB_FIX_LABEL}.
      ASSIGN len = {aderes/s-size.i &type=qbf-rct[qbf_i] 
                                    &format=qbf_t} NO-ERROR.

      PUT UNFORMATTED SKIP
	'  ':u qbf_n
        (IF qbf-rcl[qbf_i] = "" THEN ' NO-LABEL':u
	 ELSE ' LABEL "':u + lbl + '"':u)
	    ' FORMAT "':u (IF len > 320 THEN 'X(320)':u ELSE qbf_t) '"':u.
 
      /* As we're creating the main frame, create the TEMP-TABLE entries
	 that we need later to match handles back to the qbf-rcx array.
	     For now we'll just store the array index and frame suffix.  Later, 
	 when f-store gets called from the generated code, we'll plop in the 
	 handles. 
      */
      IF NOT is_dlg AND usage = "r":u THEN DO:
	CREATE qbf-fwid.
	ASSIGN
	  qbf-fwid.qbf-fwix = qbf_i
	  qbf-fwid.qbf-fwfram = INTEGER(qbf-sfx).
      END.
    END.
 
    clm = DECIMAL({aderes/strtoe.i &str="ENTRY({&F_COL},qbf-rcp[qbf_i])"}).
 
    IF clm <> 0 THEN DO:
      PUT UNFORMATTED
	' AT ROW ':u ENTRY({&F_ROW},qbf-rcp[qbf_i])
	' COLUMN ':u {aderes/numtoa.i &num=clm}.
    
      maxrw = MAX(maxrw, 
	    DECIMAL({aderes/strtoe.i &str="ENTRY({&F_ROW},qbf-rcp[qbf_i])"})).
    END.
    ELSE 
      /* If no fields have a specified position maxrw will be 0 anyway.
	 If there are some (not all) fields with no position specified, 
	 it's because they were just added.  We would have put the first
	 of them explicitly at the max row.  However, the next n of them
	 may extend to other rows.  In that case leave maxrw 0 so
	 the buttons just follow the last field listed instead of 
	 the field with the highest stored row #.
      */
      maxrw = 0.
 
    PUT UNFORMATTED
      SKIP
      IF is_dlg THEN '    ~{&CLR~} VIEW-AS FILL-IN':u
		ELSE '    VIEW-AS FILL-IN':u.
 
    /* Make sure widget fits in the window. Set format of temp widget 
       so we can get accurate size info. 
    */
    fwid:FORMAT      = qbf-rcf[qbf_i].
    fwid:WIDTH       = fwid:WIDTH NO-ERROR. /* avoids nasty error about > 320 */
    fwid:AUTO-RESIZE = YES. /* setting width keeps turning this off so reset */
    len              = FONT-TABLE:GET-TEXT-WIDTH(lbl,0) + 2.

    IF usage = "r":u THEN DO:
      IF clm + fwid:WIDTH + len > frmwid - 2 THEN
	PUT UNFORMATTED
	  ' SIZE ':u 
	    {aderes/numtoa.i &num="frmwid - 2 - len - clm"} ' BY ':u 
	    {aderes/numtoa.i &num="fwid:HEIGHT"}.
    END.
      
    /* get list of fields by frame for ON MOUSE-SELECT-DOWN trigger, to be
       used to set form field index to link with field properties dialog */
    IF usage <> "g":u THEN
      RUN generate_field_list (qbf-section.qbf-sfrm,qbf_n).
  END. /* each column */
  
  RUN generate_endframe (is_dlg, maxrw, "dlg-":u).
END PROCEDURE. /* generate_frame */
 
/*--------------------------------------------------------------------------*/
 
/* layout the query by example frame */
 
PROCEDURE generate_qbe_frame:
  DEFINE VARIABLE qbf_i AS INTEGER   NO-UNDO. /* scrap/loop */
  DEFINE VARIABLE qbf_j AS INTEGER   NO-UNDO. /* field count */
  DEFINE VARIABLE qbf_k AS INTEGER   NO-UNDO. /* scrap/count */
  DEFINE VARIABLE qbf_l AS CHARACTER NO-UNDO. /* sections using this frame */
  DEFINE VARIABLE qbf_n AS CHARACTER NO-UNDO. /* field name */
  DEFINE VARIABLE maxrw AS DECIMAL   NO-UNDO INITIAL 0. /* maximum row */
  DEFINE VARIABLE len   AS INTEGER   NO-UNDO. /* fill-in/label length */
  DEFINE VARIABLE lbl   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE clm   AS DECIMAL   NO-UNDO. /* column */
  
 
  DEFINE BUFFER qbf_sbuffer FOR qbf-section.
 
  /* Construct list of sections using this frame. */
  ASSIGN
    qbf_j = 0
    qbf_l = "".
  {&GET_FRAME_SECTIONS}
 
  PUT UNFORMATTED 
    'FORM':u.
  
   DO qbf_i = 1 TO qbf-rc#:
     IF {&NOT_SUPPORTED_IN_FORM} THEN NEXT.
     {&IF_NOT_IN_FRAME_THEN_NEXT}
 
    /* Start a new frame every 20 fields to avoid exceeding Progress
       statement limit.  Progress merges all frames with same name 
       into one frame.
    */
    IF qbf_j MODULO 21 = 20 THEN
      PUT UNFORMATTED SKIP
	'  WITH FRAME qbe-':u qbf-section.qbf-sfrm '.':u SKIP
	'FORM' SKIP.
 
    /*clm = DECIMAL(ENTRY({&F_COL},qbf-rcp[qbf_i])).*/
    clm = DECIMAL({aderes/strtoe.i &str="ENTRY({&F_COL},qbf-rcp[qbf_i])"}).
    
 
    IF {&TEXT_LIT} THEN  /* Just put the text constant in the frame */
      PUT UNFORMATTED SKIP
	'  ':u SUBSTRING(qbf-rcn[qbf_i],9,-1,"CHARACTER":u).
    ELSE DO:
    /* Field name is the element of the qbf-qbefld array with array index
       corresponding to the qbf-rcn entry.
    */
      ASSIGN
	qbf_j = qbf_j + 1
	qbf_n = "qbf-qbefld[":u + STRING(qbf_i) + "]":u.
      ASSIGN len = {aderes/s-size.i &type=qbf-rct[qbf_i] 
                                    &format=qbf-rcf[qbf_i]} NO-ERROR.

      IF len > 320 THEN len = 320.  /* Progress chokes on format otherwise! */
 
      /* Set format of temp widget so we can get accurate size info. 
	 Have to avoid 320 error again since decorations may push it over.
      */
      fwid:FORMAT = SUBSTITUTE ("X(&1)", len).
      fwid:WIDTH = fwid:WIDTH NO-ERROR.  /* avoids nasty error about > 320 */
      fwid:AUTO-RESIZE = YES.     /* setting width turns this off so reset */
 
      /* Real fill-in's format will have extra characters:
	 the size is based on the real format but we want the user
	 to be able to type extra characters for the qbe keywords.
      */
      len = len + 20.
 
      ASSIGN
	lbl = REPLACE(qbf-rcl[qbf_i], '"':u, '""':u)
	{&FB_FIX_LABEL}.
 
      PUT UNFORMATTED SKIP
	'  ':u qbf_n
	  (IF qbf-rcl[qbf_i] = "" THEN
	    ' NO-LABEL':u
	  ELSE
	    ' LABEL "':u + lbl + '"':u
	  )
	  ' FORMAT "X(':u len ')"':u SKIP.
      len = FONT-TABLE:GET-TEXT-WIDTH(lbl,0) + 2.
      PUT UNFORMATTED
	'    VIEW-AS FILL-IN SIZE ':u 
	  (IF clm + fwid:WIDTH  + len > frmwid - 2 
	     THEN {aderes/numtoa.i &num="frmwid - 2 - len - clm"} 
	     ELSE {aderes/numtoa.i &num="fwid:WIDTH"})
	  ' BY ':u {aderes/numtoa.i &num="fwid:HEIGHT"}.
    END.
 
    IF clm <> 0 THEN DO:
      PUT UNFORMATTED
	' AT ROW ':u ENTRY({&F_ROW},qbf-rcp[qbf_i])
	' COLUMN ':u {aderes/numtoa.i &num=clm}.
    
      maxrw = MAX(maxrw, 
	 DECIMAL({aderes/strtoe.i &str="ENTRY({&F_ROW},qbf-rcp[qbf_i])"})).
    END.
    ELSE 
      /* (See comment in generate_frame above) */
      maxrw = 0.
 
    PUT UNFORMATTED
      ' ~{&CLR~}':u.  /* color phrase */
  END. /* each column */
 
  RUN generate_endframe (TRUE, maxrw, "qbe-":u).
END PROCEDURE. /* generate_qbe_frame */
 
/*--------------------------------------------------------------------------*/
 
/* generate the last part of the frame definition - buttons & frame phrase */
 
PROCEDURE generate_endframe:
  DEFINE INPUT PARAMETER is_dlg AS LOGICAL NO-UNDO. /* is it a dialog box? */
  DEFINE INPUT PARAMETER maxrw  AS DECIMAL NO-UNDO. /* max row of fields */
  DEFINE INPUT PARAMETER pfix   AS CHAR    NO-UNDO. /* frame name prefix */
  /* current qbf-section buffer is for this frame */
 
  DEFINE VARIABLE ttl    AS CHARACTER NO-UNDO INIT "". /* title for frame */
  DEFINE VARIABLE ix     AS INTEGER   NO-UNDO.
 
  IF NOT is_dlg THEN DO:
    /* If no explicit rows were assigned, just let the buttons 
       continue to the next row.  Otherwise, we must position them
       after the max row in case the last field mentioned was not 
       at the highest row in the form.
    */
    IF maxrw > 0 THEN 
      PUT UNFORMATTED SKIP
	'  b_first AT COL 2 ROW ':u {aderes/numtoa.i &num="maxrw + 1.5"}.
    ELSE
      PUT UNFORMATTED SKIP
	'  SKIP(.5)':u SKIP
	'  b_first AT 2':u.
    PUT UNFORMATTED
      ' b_prev b_next b_last SPACE(3) b_count':u.
    PUT UNFORMATTED
      (IF usage = "r":u THEN ' SPACE(3)':u ELSE ' SKIP':u) SKIP 
	'  b_add':u
      (IF usage = "r":u THEN "" ELSE ' AT 2':u)
	' b_update b_copy b_delete':u.
    IF usage = "r":u THEN
      PUT UNFORMATTED
	' SKIP(.5)':u SKIP '  b_query AT 2':u.
    PUT UNFORMATTED
      ' SKIP(.5)':u SKIP
      '  WITH FRAME ':u qbf-section.qbf-sfrm SKIP
      '  SIDE-LABELS OVERLAY FONT 0':u.
  END.
  ELSE DO:
    IF maxrw > 0 THEN 
      PUT UNFORMATTED SKIP
	'  b_ok AT COLUMN 2 ROW ':u {aderes/numtoa.i &num="maxrw + 1.5"}.
    ELSE
      PUT UNFORMATTED SKIP
	'  SKIP(1)':u SKIP
	'  b_ok AT 2':u.
    PUT UNFORMATTED
      ' b_cancel':u.
    IF pfix BEGINS "qbe":u THEN 
      PUT UNFORMATTED
	' SPACE(':u {aderes/numtoa.i &num="{&HM_DBTNG}"} ') b_clear b_help':u.
    PUT UNFORMATTED
      ' SKIP(.5)':u SKIP
      '  WITH FRAME ':u pfix + qbf-section.qbf-sfrm SKIP
      '  DEFAULT-BUTTON b_ok CANCEL-BUTTON b_cancel':u SKIP
      '  SIDE-LABELS VIEW-AS DIALOG-BOX FONT 0':u.
  END.
 
  /* get frame properties */
  FIND FIRST qbf-frame WHERE qbf-frame.qbf-ftbl = qbf-section.qbf-stbl NO-ERROR.
 
  /* Size to fill results window if we're running results now. */
  IF usage = "r":u THEN 
    PUT UNFORMATTED
      ' WIDTH ':u {aderes/numtoa.i &num=frmwid}.
  ELSE IF usage = "g":u THEN    
    PUT UNFORMATTED
      ' SCROLLABLE':u.
 
  /* Should we display in 3D? -dma */
  IF "{&WINDOW-SYSTEM}":u BEGINS "MS-WIN":u 
    AND qbf-threed AND usage = "r":u THEN
    PUT UNFORMATTED
      ' THREE-D':u.
 
  IF NOT is_dlg AND
     AVAILABLE(qbf-frame) AND qbf-frame.qbf-frow[{&F_IX}] > 0 THEN
    PUT UNFORMATTED
      ' ROW ':u {aderes/numtoa.i &num="qbf-frame.qbf-frow[{&F_IX}]"}.  
 
  /* Default Title for main frames is:
     "[Master | Detail] - tbl1,tbl2" up to 80 chars. 
     QBE dialog will be just "Query by Example".  Other dialogs will just
     be table name (leave out Master/Detail part).
  */
  IF pfix BEGINS "qbe":u THEN 
    ttl = "Query by Example".
  ELSE DO:
    DO ix = 1 TO NUM-ENTRIES(qbf-section.qbf-stbl):
      {&FIND_TABLE_BY_ID} INTEGER(ENTRY(ix, qbf-section.qbf-stbl)).
      ttl = ttl + (IF ttl = "" THEN "" ELSE ",":u) + 
	    (IF qbf-hidedb THEN ENTRY(2,qbf-rel-buf.tname,".":u)
			   ELSE qbf-rel-buf.tname).
    END.
    IF NOT is_dlg AND qbf-detail <> 0 THEN
      ttl = (IF qbf-section.qbf-sout = "1":u THEN "Master - " ELSE "Detail - ")
	  + ttl.
    IF LENGTH(ttl,"RAW":u) > 77 THEN 
      ttl = SUBSTRING(ttl,1,77,"FIXED":u) + "...":u.
  END.
  PUT UNFORMATTED
    SKIP
    '  TITLE "':u ttl '".':u SKIP(1).
  
 
  IF is_dlg THEN DO:
    PUT UNFORMATTED
      'ON WINDOW-CLOSE OF FRAME ':u pfix + qbf-section.qbf-sfrm SKIP
      '  APPLY "END-ERROR" TO SELF.':u SKIP(1).
    IF pfix BEGINS "qbe":u AND usage = "r":u THEN
      PUT UNFORMATTED
	'ON HELP OF FRAME ':u pfix + qbf-section.qbf-sfrm 
	' OR CHOOSE OF b_help IN FRAME ':u pfix + qbf-section.qbf-sfrm SKIP
	'  RUN adecomm/_adehelp.p ("res", "CONTEXT", ':u
	   {&QBE_Dlg_Box} ', ?).':u SKIP(1).
  END.
END.  /* generate_endframe */
 
/*--------------------------------------------------------------------------*/
 
PROCEDURE field_display:
  DEFINE INPUT PARAMETER qbf_marg AS CHARACTER NO-UNDO. /* indent margin */
  DEFINE INPUT PARAMETER qbf_cmd  AS CHARACTER NO-UNDO. /* eg,DISPLAY or SET */
  DEFINE INPUT PARAMETER qbf_dlg  AS CHARACTER NO-UNDO. /* "dlg-" or "" */
 
  DEFINE VARIABLE qbf_i   AS INTEGER   NO-UNDO. /* scrap/loop */
  DEFINE VARIABLE qbf_n   AS CHARACTER NO-UNDO. /* field name */
  DEFINE VARIABLE realfld AS CHARACTER NO-UNDO.
  DEFINE VARIABLE dbnam   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE usr_lst AS CHARACTER NO-UNDO. /* e.g., can-write users */
  DEFINE VARIABLE add_when AS LOGICAL  NO-UNDO. 
 
  /*
  >   DISPLAY
  >     demo.customer.cust-num
  >     demo.customer.name 
  >     qbf-003
  >     qbf-004 WHEN qbf-004 <> ?
  >     "?" WHEN qbf-004 = ? @ qbf-004
  >     WITH FRAME qbf-form-1.
  > or
  >   SET
  >     demo.customer.cust-num
  >     qbf-002
  >     b_ok b_cancel
  >     WITH FRAME qbf-form-1.
  */
  
  /* actually write display statement */
  PUT UNFORMATTED
    qbf_marg qbf_cmd SKIP.
 
  DO qbf_i = 1 TO qbf-rc#:
    IF {&TEXT_LIT} OR {&NOT_SUPPORTED_IN_FORM} THEN NEXT.
    /* skip calc'ed fields on update */
    IF {&CALCULATED} AND qbf_cmd <> "DISPLAY":u THEN NEXT. 
    IF NOT CAN-DO(qbf-rcs[qbf_i],qbf-section.qbf-sout) THEN NEXT.
 
    qbf_n = ENTRY(1,qbf-rcn[qbf_i]).
 
    IF qbf_dlg <> "" OR qbf_cmd <> "DISPLAY":u THEN DO:
      /* make sure user has can-write access to the field. */
      RUN alias_to_tbname (qbf_n, TRUE, OUTPUT realfld).
      RUN aderes/s-schema.p (realfld, "", "",
			     "FIELD:CAN-WRITE":u, OUTPUT usr_lst).
      dbnam = ENTRY(1, qbf_n, ".":u).
      add_when = FALSE.
      IF NOT CAN-DO(usr_lst, USERID(dbnam)) THEN 
        IF qbf_cmd <> "DISPLAY":u THEN
          NEXT. /* don't generate SET code for this field */
        ELSE  
          add_when = TRUE. /* this will be displayed except for copy */
    END.
 
    IF qbf-rcc[qbf_i] BEGINS "x":u THEN
      PUT UNFORMATTED
	    qbf_marg '  ':u qbf_n ' WHEN ':u qbf_n ' <> ?':u SKIP
	    qbf_marg '  "':u ENTRY(7,qbf-rcn[qbf_i]) '" WHEN ':u 
	      qbf_n ' = ? @ ':u qbf_n SKIP.
    ELSE DO:
      IF add_when THEN
        PUT UNFORMATTED
	       qbf_marg '  ':u qbf_n ' WHEN NOT p_copy':u SKIP
          qbf_marg '  ':u '"" WHEN p_copy @ ':u qbf_n SKIP.
      ELSE
        PUT UNFORMATTED
	       qbf_marg '  ':u qbf_n SKIP.
    END.   
  END. /* end of loop over all fields */
 
  IF qbf_dlg <> "" AND qbf_cmd <> "DISPLAY":u THEN
    PUT UNFORMATTED
      SKIP 
      qbf_marg '  b_ok b_cancel':u SKIP.
  PUT UNFORMATTED
    qbf_marg '  WITH FRAME ':u qbf_dlg + qbf-section.qbf-sfrm '.':u SKIP.
 
END PROCEDURE. /* field_display */
 
/*--------------------------------------------------------------------------*/
PROCEDURE generate_field_list:
  DEFINE INPUT PARAMETER qbf-f AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER qbf-n AS CHARACTER NO-UNDO.

  /* This block ensures that we limit 20 fields to each fldlst record, used
     later for 'ON MOUSE-SELECT-DOWN' and 'ON ENTRY' events -dma */
  REPEAT:
    FIND FIRST fldlst WHERE fldlst.tt-frame = qbf-f 
      AND fldlst.tt-index = flst-idx NO-ERROR.
    IF NOT AVAILABLE fldlst THEN DO:
      CREATE fldlst.
      ASSIGN
	fldlst.tt-index = flst-idx
	fldlst.tt-frame = qbf-f.
    END.
    ELSE IF NUM-ENTRIES(fldlst.tt-fields) = 20 THEN DO:
      flst-idx = flst-idx + 1.
      NEXT.
    END.

    IF NOT CAN-DO(fldlst.tt-fields,qbf-n) THEN
    fldlst.tt-fields = fldlst.tt-fields
		     + (IF fldlst.tt-fields = "" THEN "" ELSE ",":u)
		     + qbf-n + ' IN FRAME ':u + qbf-f.
    LEAVE.
  END.
END PROCEDURE.
/*--------------------------------------------------------------------------*/
PROCEDURE field_list:
  DEFINE INPUT PARAMETER qbf-f AS CHARACTER NO-UNDO.

  FOR EACH fldlst:
    PUT UNFORMATTED 
      'ON MOUSE-SELECT-DOWN OF ':u SKIP.

    DO qbf-i = 1 TO NUM-ENTRIES(fldlst.tt-fields):
      PUT UNFORMATTED 
        '  ':u ENTRY(qbf-i,fldlst.tt-fields) 
        (IF qbf-i < NUM-ENTRIES(fldlst.tt-fields) THEN ",":u ELSE "") SKIP.
    END.

    PUT UNFORMATTED 
      '  APPLY "ENTRY" TO SELF.':u SKIP(1).

    PUT UNFORMATTED
      'ON ENTRY OF ':u SKIP.

    DO qbf-i = 1 TO NUM-ENTRIES(fldlst.tt-fields):
      PUT UNFORMATTED 
        '  ':u ENTRY(qbf-i,fldlst.tt-fields) 
        (IF qbf-i < NUM-ENTRIES(fldlst.tt-fields) THEN ",":u ELSE "") SKIP.
    END.

    PUT UNFORMATTED 
      '  qbf-index = INTEGER(SELF:PRIVATE-DATA).':u SKIP(1).
  END.
END PROCEDURE.
/*--------------------------------------------------------------------------*/
/* alias_to_tbname */
{ aderes/s-alias.i }
 
/*--------------------------------------------------------------------------*/
 
/* PROCEDURE generate_calc: calculated field code for display */
{ aderes/c-gen4.i }
 
/* f-write.p - end of file */
 
