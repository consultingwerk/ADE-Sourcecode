/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* c-gen5.i - generate_prepass procedure used to generate calc field 
      	      prepass code.  */

/* Make sure field is percent total field and if so get table id of field */
&GLOBAL-DEFINE CHECK_FIELD ~
  IF NOT qbf-rcc[qbf_i] BEGINS "p" THEN NEXT. ~
  fldexp = qbf-rcn[qbf_i]. ~
  {&FIND_TABLE_BY_NAME} ~
  SUBSTRING(ENTRY(2,fldexp), 1, ~
  R-INDEX(ENTRY(2,fldexp),".":u) - 1,"CHARACTER":u).

PROCEDURE generate_prepass:
  DEFINE INPUT PARAMETER qbf_s  AS CHARACTER NO-UNDO. /* section */

  DEFINE VARIABLE tbls   AS CHARACTER         NO-UNDO. /* list of tables */
  DEFINE VARIABLE qbf_i  AS INTEGER           NO-UNDO. /* scrap/loop */
  DEFINE VARIABLE qbf_j  AS INTEGER           NO-UNDO. /* scrap/loop */
  DEFINE VARIABLE qbf_k  AS INTEGER INITIAL 0 NO-UNDO. /* 0=none,1=one,2=many */
  DEFINE VARIABLE qbf_c  AS CHARACTER         NO-UNDO. /* child tbls (c-gen7) */
  DEFINE VARIABLE qbf_m  AS CHARACTER         NO-UNDO. /* indent margin */
  DEFINE VARIABLE marg#  AS INTEGER           NO-UNDO. /* # margin blanks */
  DEFINE VARIABLE fldexp AS CHARACTER         NO-UNDO. /* qbf-rcn entry */
  DEFINE VARIABLE tname  AS CHARACTER         NO-UNDO.

  DEFINE BUFFER qbf_sbuffer FOR qbf-section.

  /* Find all the tables that are used in this frame. */
  FIND FIRST qbf-section WHERE qbf-section.qbf-sout = qbf_s.
  tbls = "".
  FOR EACH qbf_sbuffer WHERE qbf_sbuffer.qbf-sfrm = qbf-section.qbf-sfrm:
    tbls = tbls + (IF tbls = "" THEN "" ELSE ",") + qbf_sbuffer.qbf-stbl.
  END.

  /* If there is a percent total field for any table involved in the
     query than we'll generate some code.
  */
  DO qbf_i = 1 TO qbf-rc# WHILE qbf_k < 2:
    {&CHECK_FIELD}
    IF CAN-DO(tbls, STRING(qbf-rel-buf.tid)) THEN
      qbf_k = qbf_k + 1.
  END.

  IF qbf_k = 0 THEN RETURN.

  ASSIGN
    marg# = NUM-ENTRIES(qbf_s,".":u) * 2 - 2
    qbf_m = FILL(' ':u, marg#).

  /* If total is being calculated for each child group we must
     zero out the variables before totaling again.
  */
  IF NUM-ENTRIES(qbf_s, ".") > 1 THEN
    DO qbf_i = 1 TO qbf-rc#:
      {&CHECK_FIELD}
      IF CAN-DO(tbls, STRING(qbf-rel-buf.tid)) THEN
	PUT UNFORMATTED
	  qbf_m ENTRY(1,fldexp) '% = 0.':u SKIP.
    END.

  DO qbf_j = 1 TO NUM-ENTRIES(tbls):
    /* Generate for each phrase - pass the actual section that this 
       table came from.
    */
    FIND FIRST qbf_sbuffer 
      WHERE CAN-DO(qbf_sbuffer.qbf-stbl, ENTRY(qbf_j, tbls)).
    { aderes/c-gen7.i &tables = "ENTRY(qbf_j, tbls)" 
      	       	      &margin = "marg# + ((qbf_j - 1) * 2)"
      	       	      &sbuffer = "qbf_sbuffer"
    } 

    qbf_m = qbf_m + "  ".
    PUT UNFORMATTED 
      ':':u SKIP
      qbf_m 'ASSIGN':u.
  
    DO qbf_i = 1 TO qbf-rc#:
      /* If we find a percent total field that belongs to this
    	 table then we'll generate totalling code here. 
      */
      {&CHECK_FIELD}
      IF NOT (STRING(qbf-rel-buf.tid) = ENTRY(qbf_j, tbls)) 
        THEN NEXT.
  
      PUT UNFORMATTED SKIP
        qbf_m '  ':u 
        ENTRY(1,fldexp)
        '% = ':u ENTRY(1,fldexp)
        '% + ':u ENTRY(2,fldexp).
    END.
    PUT UNFORMATTED
      '.':u SKIP.
  END.
  DO qbf_j = NUM-ENTRIES(tbls) TO 1 BY -1:
    qbf_m = SUBSTRING(qbf_m, 3,-1,"CHARACTER":u).  /* chop off 2 each time */
    PUT UNFORMATTED
      qbf_m 'END.':u SKIP.
  END.
  PUT UNFORMATTED SKIP(1).

END PROCEDURE. /* generate_prepass */

/* c-gen5.i - end of file */

