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
/* s-level.p - Reset qbf-section after field/level/outerjoin change.
               Also, adjust rows and columns for new field or master-detail 
      	       changes.
*/ 

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/j-define.i }
{ aderes/fbdefine.i }

DEFINE VARIABLE qbf-c  AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-c2 AS CHARACTER NO-UNDO. /* more scrap */
DEFINE VARIABLE qbf-h  AS INTEGER   NO-UNDO. /* loop */
DEFINE VARIABLE qbf-i  AS INTEGER   NO-UNDO. /* loop */
DEFINE VARIABLE qbf-j  AS INTEGER   NO-UNDO. /* loop */
DEFINE VARIABLE qbf-k  AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-p  AS INTEGER   NO-UNDO. /* position */
DEFINE VARIABLE row    AS INTEGER   NO-UNDO. /* row # */
DEFINE VARIABLE s_chg  AS LOGICAL   NO-UNDO INIT NO. /* section change flag */
DEFINE VARIABLE outer  AS LOGICAL   NO-UNDO. /* outer join? */
DEFINE VARIABLE aggs   AS LOGICAL   NO-UNDO INIT NO. /* any aggregates ? */
DEFINE VARIABLE tbl_id AS CHARACTER NO-UNDO INIT "". /* table id */

DEFINE BUFFER b_section FOR qbf-section.

/* Used for adjusting form field rows in sections after they've gotten
   merged or split apart and also for adjusting row/col of new fields.

   *** We decided, in the end to NOT adjust for merged or split sections.
   You get kind of funny results and there's one case - if you reverse
   the table order but leave everything else the same - the algorithm
   doesn't work.  This algorithm took a long time to figure out so 
   I'm leaving here for future reference for now.  Commented out with
   /*@@@@*/ type comments.
*/
DEFINE TEMP-TABLE sect_info NO-UNDO
  /*@@@@
  FIELD sect#   AS CHARACTER		/* new section outline # */
  @@@@*/
  FIELD frm_sfx AS CHARACTER		/* new frame suffix */

  FIELD ix_frst AS INTEGER INIT 0   /* index of first new field */
  FIELD ix_last AS INTEGER INIT 0   /* index of last new field */
  FIELD ix_end  AS INTEGER          /* index of last field in section */
  FIELD contig  AS LOGICAL INIT yes /* are new fields contiguous? */
  FIELD maxrw_r AS INTEGER INIT 0	/* max row in report */
  FIELD maxrw_f AS INTEGER INIT 0	/* max row in form */
  FIELD maxrw_l AS INTEGER INIT 0	/* max row in label */

  /*@@@@@@@@@
  /* This stuff only applies to the form view: */
  FIELD in_flds AS CHARACTER INIT ""	/* fields moved to this section */
  FIELD in_dir  AS CHARACTER INIT ""	/* fields moved from elsewhere: 
					   to P(arent) or to C(child) */
  FIELD out_dir AS CHARACTER INIT ""    /* fields moved from here: 
      	       	     	       	           to P(arent) or to C(child) */
  FIELD in_min  AS INTEGER   INIT 99999 /* original min row of moved fields */
  FIELD in_max  AS INTEGER   INIT 0     /* original max row of moved fields */
  FIELD e_min   AS INTEGER   INIT 99999 /* original min row of existing fields 
      	       	     	               	   (flds whose section didn't change) */
  FIELD e_max   AS INTEGER   INIT 0     /* original max row of existing fields 
      	       	     	      	           (flds whose section didn't change) */
  @@@@@@@@@*/
  .

DEFINE TEMP-TABLE old_sects NO-UNDO  /* copy of qbf-section info "before" */
  FIELD sect# AS CHARACTER
  FIELD frm   AS CHARACTER
  .
   
/*================================Mainline==================================*/

IF NUM-ENTRIES(qbf-tables) = 0 THEN RETURN.

/*--------------------------------------------------------------------------*/
/* Regenerate qbf-section information. 

   This "kind of" handles more robust join capabilities than we currently 
   support - i.e.., multiple join branches. But, of course, it also works for 
   the simple, one branch case.  If we ever move to multi-join branch
   support the handling of siblings (e.g., customer, order of customer, state 
   of customer) would need revisiting.  These should probably always be in 
   separate sections no matter what instead of lumped with the parent where
   you would get one FOR each with all 3 tables and thus a cross product 
   between 2 sets of child records.
*/

/* Before deleting qbf-section, copy stuff we need to remember. */
FOR EACH qbf-section:
  CREATE old_sects.
  ASSIGN
    old_sects.sect# = qbf-section.qbf-sout
    old_sects.frm = qbf-section.qbf-sfrm.
  DELETE qbf-section.
END.

CREATE qbf-section.
ASSIGN
  qbf-section.qbf-sout = "1":u
  qbf-section.qbf-stbl = ENTRY(1,qbf-tables)
  qbf-section.qbf-smdl = yes.

DO qbf-i = 2 TO NUM-ENTRIES(qbf-tables):
  /* Find the WHERE record for this table and the section containing
     the table which this table is related to.  e.g., if we're looking
     at Order (of Customer) find the section containing Customer. (It
     must be there since children always come after their parent in 
     tables list.)  The new table will be added to that section unless
     there is some reason to split it off (as described below).
  */
  ASSIGN
    tbl_id = ENTRY(qbf-i, qbf-tables)
    qbf-c  = ENTRY(NUM-ENTRIES(qbf-section.qbf-stbl),qbf-section.qbf-stbl)
           + ",":u + tbl_id.

  FIND FIRST qbf-where WHERE qbf-where.qbf-wtbl = INTEGER(tbl_id) NO-ERROR.
  FIND qbf-section WHERE CAN-DO(qbf-section.qbf-stbl, qbf-where.qbf-wrid).

  /* For report, see if last table of this section so far has aggregates */
  IF CAN-DO("r,e":u,qbf-module) THEN
    RUN any_aggregates 
      (qbf-c,
       ENTRY(NUM-ENTRIES(qbf-section.qbf-stbl),qbf-section.qbf-stbl), 
       OUTPUT aggs).

  /* If outer join clause (reports or export only) or previous table had 
     any aggregates (reports only) OR break point of master-detail (for
     browse,form,report) then create a new section.
  */
  outer = (IF AVAILABLE qbf-where AND qbf-where.qbf-wojo THEN yes ELSE no).
  IF (CAN-DO("r,e":u,qbf-module) AND (outer OR aggs)) OR
     (qbf-detail = INTEGER(tbl_id) AND CAN-DO("b,f,r":u,qbf-module)) THEN DO:

    /* To determine what section # to assign find the last record at
       the same level under this parent.  e.g., If we have Customer,
       Order of Customer, Order-line of Order and State of Customer, 
       if they are all outer joins, and we're up to State, what we'll 
       have so far is Customer: 1, Order: 1.1 and Order-line: 1.1.1.
       So we want to make State 1.2.
    */

    ASSIGN
      qbf-c = qbf-section.qbf-sout  /* parent section, e.g., 1 */
      qbf-k = NUM-ENTRIES(qbf-c, ".":u) + 1.

    FIND LAST b_section WHERE 
      NUM-ENTRIES(b_section.qbf-sout, ".":u) = qbf-k AND
      b_section.qbf-sout BEGINS qbf-c + ".":u 
      USE-INDEX qbf-section-ix1 NO-ERROR.  /* this would find 1.1 */

    CREATE qbf-section.
    ASSIGN
      qbf-k = (IF AVAILABLE b_section 
      	       THEN INTEGER(ENTRY(qbf-k, b_section.qbf-sout, ".":u)) + 1 ELSE 1)
      qbf-section.qbf-sout = qbf-c + ".":u + STRING(qbf-k)
      qbf-section.qbf-smdl = (IF CAN-DO("b,f,r":u,qbf-module) 
                              THEN (qbf-detail = INTEGER(tbl_id))
                              ELSE no)
      qbf-section.qbf-sojo = outer. 
  END.

  qbf-section.qbf-stbl = qbf-section.qbf-stbl
                       + (IF qbf-section.qbf-stbl = "" THEN "" ELSE ",":u)
                       + tbl_id.
END.

RUN assign_frames.

/* Remove any form/browse frame records that no longer match any section. */
FOR EACH qbf-frame:
  FIND qbf-section WHERE qbf-section.qbf-stbl = qbf-frame.qbf-ftbl NO-ERROR.
  IF NOT AVAILABLE qbf-section THEN DELETE qbf-frame.
END.      

/*--------------------------------------------------------------------------*/
/* reattach order-by to proper sections */

DO qbf-i = 1 TO NUM-ENTRIES(qbf-sortby):

  /* calculated field */
  DO qbf-h = 1 TO qbf-rc#:
    IF ENTRY(1,qbf-rcn[qbf-h]) = REPLACE(ENTRY(qbf-i,qbf-sortby)," DESC":u,"")
      AND qbf-rcc[qbf-h] > "" THEN LEAVE.
  END.

  /* look for calculated field table at lowest level */
  IF qbf-h <= qbf-rc# THEN
  DO qbf-j = 2 TO NUM-ENTRIES(qbf-rcc[qbf-h]):
    RUN lookup_table (SUBSTRING(ENTRY(qbf-j,qbf-rcc[qbf-h]),1,
                                R-INDEX(ENTRY(qbf-j,qbf-rcc[qbf-h]),".":u) - 1,
                                "CHARACTER":u),
                      OUTPUT qbf-k).
    
    IF qbf-k > 0 THEN
      qbf-p = MAXIMUM(qbf-p,LOOKUP(qbf-tables,STRING(qbf-k))).
  END.
  
  /* database field */
  ELSE
    RUN lookup_table (SUBSTRING(ENTRY(qbf-i,qbf-sortby),1,
                                R-INDEX(ENTRY(qbf-i,qbf-sortby),".":u) - 1,
                                "CHARACTER":u),
                      OUTPUT qbf-k).
                    
  FIND FIRST qbf-section
    WHERE CAN-DO(qbf-section.qbf-stbl,STRING(qbf-k)) NO-ERROR.
  IF AVAILABLE qbf-section THEN DO:
    IF qbf-summary AND qbf-i = NUM-ENTRIES(qbf-sortby) THEN
      qbf-section.qbf-sxtb = ENTRY(qbf-i,qbf-sortby).

    qbf-section.qbf-sort = qbf-section.qbf-sort
                         + (IF qbf-section.qbf-sort = "" THEN "" ELSE ",":u)
                         + ENTRY(qbf-i,qbf-sortby).
  END.
  ELSE /* order-by no longer applies.  yank it. */
    ASSIGN
      ENTRY(qbf-i,qbf-sortby) = ""
      qbf-sortby              = REPLACE(TRIM(qbf-sortby,",":u),",,":u,",":u)
      qbf-i                   = qbf-i - 1.
    /* ^^ back up over last one and try again */
END.

/*--------------------------------------------------------------------------*/
/* Reattach fields to their appropriate sections and destroy fields that 
   no longer have table owners.  As we go, store information in sect_info 
   temp table for possible fixup of field positions. */
qbf-k = 0.
_outer:
DO qbf-i = 1 TO qbf-rc#:
  qbf-c = qbf-rcn[qbf-i].

  CASE SUBSTRING(qbf-rcc[qbf-i],1,1,"CHARACTER":u):
    WHEN "" THEN DO: /* database field */
      RUN lookup_table (SUBSTRING(qbf-c,1,R-INDEX(qbf-c,".":u) - 1,
                                  "CHARACTER":u),
                        OUTPUT qbf-p).

      IF NOT CAN-DO(qbf-tables,STRING(qbf-p)) THEN NEXT _outer.
      FIND FIRST qbf-section WHERE CAN-DO(qbf-section.qbf-stbl,STRING(qbf-p)).

      RUN Record_Sect_Info (qbf-rcs[qbf-i], qbf-section.qbf-sout, qbf-i).
      qbf-rcs[qbf-i] = qbf-section.qbf-sout.
    END.
    WHEN "c":u THEN DO: /* counter */
      qbf-c = "".

      FOR EACH qbf-section
        WHERE qbf-section.qbf-smdl OR qbf-section.qbf-sojo
        BY NUM-ENTRIES(qbf-section.qbf-sout):
        qbf-c = qbf-c + (IF qbf-c = "" THEN "" ELSE ",":u)
              + qbf-section.qbf-sout.
      END.
      
      ASSIGN
        qbf-c2         = qbf-rcs[qbf-i]  /* save old value */
        qbf-rcs[qbf-i] = (IF INDEX(qbf-rcc[qbf-i],"<":u) > 0 THEN
                           ENTRY(1,qbf-c)
                         ELSE IF INDEX(qbf-rcc[qbf-i],">":u) > 0 THEN
                           ENTRY(NUM-ENTRIES(qbf-c),qbf-c)
                         ELSE
                           qbf-c)
        .

      RUN Record_Sect_Info (qbf-c2, qbf-rcs[qbf-i], qbf-i).
    END.
    WHEN "e":u THEN DO: /* stacked array */
      RUN lookup_table (SUBSTRING(ENTRY(2,qbf-c),1,
                                  R-INDEX(ENTRY(2,qbf-c),".":u) - 1,
                                  "CHARACTER":u),
                        OUTPUT qbf-p).
      IF NOT CAN-DO(qbf-tables,STRING(qbf-p)) THEN NEXT _outer.
      FIND FIRST qbf-section WHERE CAN-DO(qbf-section.qbf-stbl,STRING(qbf-p)).
      RUN Record_Sect_Info (qbf-rcs[qbf-i], qbf-section.qbf-sout, qbf-i).
      qbf-rcs[qbf-i] = qbf-section.qbf-sout.
    END.
    WHEN "p":u OR WHEN "r":u THEN DO: /* %total or running-total */
      RUN lookup_table (SUBSTRING(ENTRY(2,qbf-c),1,
                                  R-INDEX(ENTRY(2,qbf-c),".":u) - 1,
                                  "CHARACTER":u),
                        OUTPUT qbf-p).
      IF NOT CAN-DO(qbf-tables,STRING(qbf-p)) THEN NEXT _outer.
      FIND FIRST qbf-section WHERE CAN-DO(qbf-section.qbf-stbl,STRING(qbf-p)).
      RUN Record_Sect_Info (qbf-rcs[qbf-i], qbf-section.qbf-sout, qbf-i).
      qbf-rcs[qbf-i] = qbf-section.qbf-sout.
    END.
    WHEN "d":u OR WHEN "l":u OR WHEN "n":u OR WHEN "s":u THEN DO: /* expr */
      ASSIGN
        qbf-c2         = qbf-rcs[qbf-i]  /* save old value */
        qbf-rcs[qbf-i] = "1":u.
      
      DO qbf-h = 2 TO NUM-ENTRIES(qbf-rcc[qbf-i]):
        qbf-c = ENTRY(qbf-h,qbf-rcc[qbf-i]).
        RUN lookup_table (SUBSTRING(qbf-c,1,R-INDEX(qbf-c,".":u) - 1,
                                    "CHARACTER":u),
                          OUTPUT qbf-p).
        IF NOT CAN-DO(qbf-tables,STRING(qbf-p)) THEN NEXT _outer.
        FIND FIRST qbf-section WHERE CAN-DO(qbf-section.qbf-stbl,STRING(qbf-p)).
        IF NUM-ENTRIES(qbf-section.qbf-sout,".":u) >
          NUM-ENTRIES(qbf-rcs[qbf-i],".":u) THEN
          qbf-rcs[qbf-i] = qbf-section.qbf-sout.
      END.
      RUN Record_Sect_Info (qbf-c2, qbf-rcs[qbf-i], qbf-i).
    END.
    WHEN "x":u THEN DO: /* lookup field */
      qbf-c = qbf-rcn[qbf-i].
      RUN lookup_table (ENTRY(2,qbf-c),OUTPUT qbf-p).
      IF NOT CAN-DO(qbf-tables,STRING(qbf-p)) THEN NEXT _outer.
      FIND FIRST qbf-section WHERE CAN-DO(qbf-section.qbf-stbl,STRING(qbf-p)).
      RUN Record_Sect_Info (qbf-rcs[qbf-i], qbf-section.qbf-sout, qbf-i).
      qbf-rcs[qbf-i] = qbf-section.qbf-sout.
    END.
  END CASE.

  /* After removing a field, the qbf-rcx arrays are already fixed up but 
     we still need this for calc'ed fields that refer to a table. If that
     table is gone, the calc'ed field must go too.  Also, if someone 
     deleted a table from the schema (maybe!?).
  */
  ASSIGN
    qbf-k          = qbf-k + 1
    qbf-rcc[qbf-k] = qbf-rcc[qbf-i]
    qbf-rcf[qbf-k] = qbf-rcf[qbf-i]
    qbf-rcg[qbf-k] = qbf-rcg[qbf-i]
    qbf-rcl[qbf-k] = qbf-rcl[qbf-i]
    qbf-rcn[qbf-k] = qbf-rcn[qbf-i]
    qbf-rcp[qbf-k] = qbf-rcp[qbf-i]
    qbf-rct[qbf-k] = qbf-rct[qbf-i]
    qbf-rcw[qbf-k] = qbf-rcw[qbf-i].
END. /* _outer */

DO qbf-i = qbf-rc# + 1 TO EXTENT(qbf-rcn):
  ASSIGN
    qbf-rcc[qbf-i] = ""
    qbf-rcf[qbf-i] = ""
    qbf-rcg[qbf-i] = ""
    qbf-rcl[qbf-i] = ""
    qbf-rcn[qbf-i] = ""
    qbf-rcp[qbf-i] = ""
    qbf-rct[qbf-i] = 0
    qbf-rcw[qbf-i] = 0.
END.
qbf-rc# = qbf-k.

/*RUN aderes/j-level.p. */ /* Don't think we need this -los -10/14/93 */

FOR EACH old_sects:
  DELETE old_sects.
END.

/*--------------------------------------------------------------------------*/

IF s_chg THEN 
  /* Adjust form view rows if necessary for merged or split sections. */
  adjust_loop:
  DO qbf-i = 1 TO qbf-rc#:
     /*@@@@@@@@@@@@
     row = INTEGER({aderes/strtoe.i &str="ENTRY({&F_ROW}, qbf-rcp[qbf-i])"}).
  
     /* Position is relative (no explicit row and column),
        so leave it that way. 
     */
     IF row = 0 THEN NEXT adjust_loop. 

     FIND FIRST sect_info WHERE sect_info.sect# = qbf-rcs[qbf-i].
  
     IF sect_info.in_dir = "C":u THEN DO:
	IF CAN-DO(sect_info.in_flds, qbf-rcn[qbf-i]) THEN
	   /* Field moved into child frame - shift so it's at top of frame */
	   row = row - (sect_info.in_min - 1).
	ELSE
	   /* move existing field down to accomodate new fields at top */
	   row = row + sect_info.in_max - (sect_info.in_min - 1).
     END.
     ELSE IF sect_info.in_dir = "P":u THEN DO:
	IF CAN-DO(sect_info.in_flds, qbf-rcn[qbf-i]) THEN
	   /* Place new field below existing fields in frame */
	   row = row + sect_info.e_max.
     END.
  
     /* No ELSE here.  I believe both IF's can only be true if we have
	at least 3 levels - e.g., in the middle section some stuff moves
	up to parent and some stuff moves down to a child.  Right now
	there are only 2 levels, but someday??
     */
     IF sect_info.out_dir = "C":u OR sect_info.out_dir = "P":u THEN DO:
	/* Fields have moved out.  This is not strictly necessary but it's 
	   nicer to eliminate any white space at top of frame. 
	   Don't move new fields that have just moved in to child frame
	   since they've already been positioned at the top of the frame.
	*/
	IF NOT (sect_info.in_dir = "C":u AND 
          CAN-DO(sect_info.in_flds, qbf-rcn[qbf-i])) THEN
	  row = row - (sect_info.e_min - 1).
     END.
     ENTRY({&F_ROW}, qbf-rcp[qbf-i]) = {aderes/numtoa.i &num="row"}.
     @@@@@@@@@*/
     /* This replaces above algorithm - we just clear all rows and columns
        and form will go back to a default layout.
     */
     ENTRY({&F_ROW}, qbf-rcp[qbf-i]) = "".
     ENTRY({&F_COL}, qbf-rcp[qbf-i]) = "".
  END. /* _adjust-loop */
/* We won't have a change of master-detail AND new fields.  It will be one
   or the other.
*/
ELSE DO:
  /* Fix up row and columns for new fields in each section for each view. */
  FOR EACH sect_info:

    IF sect_info.ix_frst > 0 THEN DO:
      RUN Fix_Position (sect_info.maxrw_f, {&F_COL}, {&F_ROW}).

      /*--- Only forms for now
      RUN Fix_Position (sect_info.maxrw_r, {&R_COL}, {&R_ROW}).
      RUN Fix_Position (sect_info.maxrw_l, {&L_COL}, {&L_ROW}).
      -----*/
    END.
  END.
END.

RETURN.

/*===========================Sub-Procedures=================================*/

/* Procedures lookup_table - looks up table reference in relationship 
   table and returns the index. */
{ aderes/p-lookup.i }

/*--------------------------------------------------------------------------*/

/* Record information in sect_info temp table.  There are two situations we
   are trying to correct.
   1. When we merge or split sections in the form view (change master-detail)
      the row's of the fields need to be changed so that the fields don't 
      end up on top of each other (merge) or with big gaps at the top of
      a frame (split).
   2. When we've just added new fields, the row and column is left 0
      meaning progress will position them after the previously named field.
      If none of the fields in the section are explicitly positioned, then
      there's no problem.  However, if the existing fields have explicit 
      positions, new fields in the middle of the field list or ones
      at the end of the list which follow a field that is positioned in the
      middle of the display somewhere, will come out overlapping other fields.
      We want to reposition these so there's no overlap - so the user
      is guaranteed to at least see that they're there.
*/
PROCEDURE Record_Sect_Info:
   DEFINE INPUT PARAMETER old_sect AS CHARACTER NO-UNDO.
   DEFINE INPUT PARAMETER new_sect AS CHARACTER NO-UNDO.
   DEFINE INPUT PARAMETER p_ix     AS INTEGER   NO-UNDO. /*index into qbf-rcx*/

   /*@@@@
   DEFINE VAR dir     AS CHAR NO-UNDO.  /* direction */
   @@@*/
   DEFINE VAR old_frm AS CHAR NO-UNDO.
   DEFINE VAR new_frm AS CHAR NO-UNDO.
   
   /* label is a different beasty for now. Field and master-detail changes
      in label don't affect other views and vice-versa. */
   IF qbf-module = "l":u THEN RETURN.
   
   FIND FIRST old_sects WHERE old_sects.sect# = old_sect NO-ERROR.
   IF AVAILABLE old_sects AND old_sects.frm <> "" THEN
      old_frm = ENTRY(3,old_sects.frm,"-":u).

   /*FIND qbf-section WHERE qbf-section.qbf-sout = new_sect */
   /* When user selects Master-Detail and defines a Counter calc field
      for all sections, new_sect is a list, i.e. '1,1.1'.  Field properties 
      are the same for all sections, so we'll take the first section. -dma
   */
   FIND qbf-section WHERE qbf-section.qbf-sout = ENTRY(1,new_sect).

   new_frm = ENTRY(3,qbf-section.qbf-sfrm,"-":u).

   FIND FIRST sect_info WHERE sect_info.frm_sfx = new_frm NO-ERROR.
   IF NOT AVAILABLE sect_info THEN DO:
     CREATE sect_info.
     /*@@@ sect_info.sect# = new_sect. @@@*/
     sect_info.frm_sfx = new_frm.
   END.
   s_chg = s_chg OR (old_frm <> "" AND (old_frm <> new_frm)).

   /* Store maximum row info for each view. */
   ASSIGN
     sect_info.maxrw_f = MAXIMUM(sect_info.maxrw_f, 
       INTEGER({aderes/strtoe.i &str="ENTRY({&F_ROW}, qbf-rcp[p_ix])"}))
     /*--- Only forms for now--
     sect_info.maxrw_r = MAXIMUM(sect_info.maxrw_r, 
       INTEGER({aderes/strtoe.i &str="ENTRY({&R_ROW}, qbf-rcp[p_ix])"}))
     sect_info.maxrw_l = MAXIMUM(sect_info.maxrw_l, 
       INTEGER({aderes/strtoe.i &str="ENTRY({&L_ROW}, qbf-rcp[p_ix])"}))
     -----*/
     sect_info.ix_end = p_ix. /* end index so far */
   
   IF old_sect = "" THEN DO:
     /* This is a new field. Keep track of the index of the first one.
        Also we'll want to know if the new fields are all at the end
        of the list (i.e., contiguous and at the end).  
     */
     IF sect_info.ix_frst = 0 THEN
       ASSIGN
         sect_info.ix_frst = p_ix
         sect_info.ix_last = p_ix.
     ELSE DO:
       IF p_ix <> sect_info.ix_last + 1 THEN
         sect_info.contig = no.
       sect_info.ix_last = p_ix.
     END.

     /* New field - doesn't participate in merge/split info. */
     RETURN. 
   END.

   /*@@@@@@@@@
   row = INTEGER({aderes/strtoe.i &str="ENTRY({&F_ROW}, qbf-rcp[p_ix])"}).

   IF old_frm = new_frm THEN 
      ASSIGN
	 sect_info.e_min = MINIMUM(sect_info.e_min, row)
	 sect_info.e_max = MAXIMUM(sect_info.e_max, row).
   ELSE DO:
      s_chg = yes.
      ASSIGN
      	 sect_info.in_flds = sect_info.in_flds +
			    (IF sect_info.in_flds = "" THEN "" ELSE ",") +
			    qbf-rcn[p_ix]
	 sect_info.in_min = MINIMUM(sect_info.in_min, row)
	 sect_info.in_max = MAXIMUM(sect_info.in_max, row).

      IF NUM-ENTRIES(old_sect, ".":u) < NUM-ENTRIES(new_sect, ".":u) THEN 
      	 dir = "C":u. /* e.g., section 1 -> 1.1 */
      ELSE
      	 dir = "P":u. /* e.g., section 1.1 -> 1 */

      sect_info.in_dir = dir.

      FIND FIRST sect_info WHERE sect_info.frm = old_frm NO-ERROR.
      IF NOT AVAILABLE sect_info THEN DO:
         CREATE sect_info.
         sect_info.sect# = old_sect.
         sect_info.frm = old_frm.
      END.
      sect_info.out_dir = dir.
   END.
   @@@@@@@@@*/
END.

/*--------------------------------------------------------------------------*/

/* See comment above (on procedure Record_Sect_Info).  This fixes up
   for condition #2 - new fields.
*/
PROCEDURE Fix_Position:
  DEFINE INPUT PARAMETER max_row AS INTEGER NO-UNDO. /* max row of fld in sect*/
  DEFINE INPUT PARAMETER col_ix  AS INTEGER NO-UNDO. /* col entry in qbf-rcp */
  DEFINE INPUT PARAMETER row_ix  AS INTEGER NO-UNDO. /* row entry in qbf-rcp */

  DEFINE VARIABLE ix AS INTEGER NO-UNDO.
  DEFINE VARIABLE frst_only AS LOGICAL NO-UNDO INITIAL false.

  /* If there are no rows and columns yet, do nothing. 
     Default layout will occur on all fields and all will be fine.
  */
  IF max_row = 0 THEN RETURN.

  /* If all the new fields are at the end, then just position the first
     one to after the last existing field and all the others will just
     follow "naturally".  Otherwise position one per row at the end.
     This is gross but for now it's too complex to emulate layout for the
     set of new fields.
  */
  IF sect_info.contig AND sect_info.ix_last = sect_info.ix_end THEN
    frst_only = true.

  DO ix = sect_info.ix_frst TO sect_info.ix_last:
    IF INTEGER({aderes/strtoe.i &str="ENTRY(row_ix, qbf-rcp[ix])"}) = 0 THEN
      ASSIGN
	max_row = max_row + 1
	ENTRY(col_ix, qbf-rcp[ix]) = STRING(1)
	ENTRY(row_ix, qbf-rcp[ix]) = {aderes/numtoa.i &num="max_row"}.
    IF frst_only THEN LEAVE.
  END.
END.

/*--------------------------------------------------------------------------*/

/* Determine if there are any aggregate fields or totals only summary
   for this table. 
*/
PROCEDURE any_aggregates:
  DEFINE INPUT  PARAMETER p_lst AS CHARACTER NO-UNDO.  /* tables to compare */
  DEFINE INPUT  PARAMETER p_tid AS CHARACTER NO-UNDO.  /* table id as string */
  DEFINE OUTPUT PARAMETER p_agg AS LOGICAL NO-UNDO.

  DEFINE VARIABLE ix AS INTEGER NO-UNDO.
  DEFINE VARIABLE ag AS LOGICAL NO-UNDO.

  {&FIND_TABLE_BY_ID} INTEGER(p_tid).

  /*            
   * The following block of code used to abort when M:1 relationship existed 
   * between the 2 tables that are being compared. 
   * To fix IZ 197/198: This next block of code will now also abort if there 
   * is no relationship at all between the 2 files that are being compared.
   * 
   */
   
  IF CAN-DO(qbf-rel-buf.rels, ">":u + ENTRY(2, p_lst)) OR           /* M:1 */
      (NOT CAN-DO(qbf-rel-buf.rels, "=":U + ENTRY(2,p_lst) )        /* 1:1 */
         AND NOT can-do(qbf-rel-buf.rels, "?":U + ENTRY(2,p_lst))   /* probably M:M */
           AND NOT can-do(qbf-rel-buf.rels, "<":U + ENTRY(2,p_lst))     /*1:M */
             AND NOT can-do(qbf-rel-buf.rels, "*":U + ENTRY(2,p_lst)))  /* M:M */
  THEN DO:
    p_agg = FALSE.
    RETURN.
  END.

  DO ix = 1 TO qbf-rc#:
    /* We only care about total, avg and count.  max & min don't screw
       up when used with a multi-table FOR EACH.  */
    ag = qbf-module = "r":u AND
      	 (INDEX(qbf-rcg[ix], "t":u) > 0 OR
      	  INDEX(qbf-rcg[ix], "c":u) > 0 OR 
      	  INDEX(qbf-rcg[ix], "a":u) > 0).
    IF (SUBSTRING(qbf-rcn[ix],1,R-INDEX(qbf-rcn[ix],".":u) - 1,
                  "CHARACTER":u) = 
      qbf-rel-buf.tname)       /* db.tbl of field match table name? */
      AND qbf-rcg[ix] <> "&":u /* if hide repeating -> no aggregate */
      /* totals only or report aggregates */
      AND (INDEX(qbf-rcg[ix],"$":u) > 0 OR ag) THEN DO:
      p_agg = TRUE.
      RETURN.
    END.
  END.
END.

/*--------------------------------------------------------------------------*/

PROCEDURE assign_frames:
  DEFINE VARIABLE viewnm AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cnt    AS INTEGER   NO-UNDO.
  
  DEFINE BUFFER qbf-sparent FOR qbf-section.
  
  viewnm = (IF qbf-module = "r":u          THEN "report":u ELSE
	    IF CAN-DO ("f,b":u,qbf-module) THEN "form":u ELSE
	    IF qbf-module = "e":u      	   THEN "export":u 
	       	     	      	       	   ELSE "").
  IF viewnm = "" THEN RETURN.  /* don't need for labels */
  
  qbf-i = 0. /* frame counter */
  FOR EACH qbf-section
    BY NUM-ENTRIES(qbf-section.qbf-sout,".":u)
    cnt = 1 TO cnt + 1: /* block counter */
  
    /* If not the start of a master detail level and it has a parent,
       get the parent.  This will happen when there is a section for
       a separate query for doing an outer join or because parent has
       an aggregate that needs to be accumulated in it's own loop.
    */
    IF NOT qbf-section.qbf-smdl AND 
       NUM-ENTRIES(qbf-section.qbf-sout,".":u) > 1 THEN
      FIND FIRST qbf-sparent
	WHERE qbf-section.qbf-sout BEGINS qbf-sparent.qbf-sout + ".":u
	  AND NUM-ENTRIES(qbf-section.qbf-sout,".":u)
	    = NUM-ENTRIES(qbf-sparent.qbf-sout,".":u) + 1.
    ELSE
      RELEASE qbf-sparent.
  
    /* If we got parent, there's no master-detail split so use parent's
       frame, otherwise, use a new frame.
    */
    ASSIGN
      qbf-i                = qbf-i + (IF AVAILABLE qbf-sparent THEN 0 ELSE 1)
      qbf-section.qbf-sfrm = (IF AVAILABLE qbf-sparent THEN
			       qbf-sparent.qbf-sfrm
			     ELSE
			       "qbf-":u + viewnm + STRING(- qbf-i)
			     )
      qbf-section.qbf-sctr = cnt.
  END.
END.

/* s-level.p - end of file */

