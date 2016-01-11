/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* c-gen6.i - generate_summary procedure used to generate code for
      	      totals-only reports.  */

/* code for totals-only reports */
PROCEDURE generate_summary:
  DEFINE INPUT PARAMETER qbf_s AS CHARACTER NO-UNDO. /* qbf-section.qbf-sout */

  DEFINE VARIABLE qbf_m AS CHARACTER   	     	NO-UNDO. /* indent margin */
  DEFINE VARIABLE qbf_b AS CHARACTER INITIAL "" NO-UNDO. /* order-by */
  DEFINE VARIABLE qbf_i AS INTEGER              NO-UNDO. /* scrap */
  DEFINE VARIABLE qbf_j AS INTEGER   INITIAL  0 NO-UNDO. /* counter */
  DEFINE VARIABLE qbf_k AS INTEGER   INITIAL  0 NO-UNDO. /* scrap */
  DEFINE VARIABLE qbf_n AS CHARACTER            NO-UNDO. /* field name */

  /* Totals-Only (summary) only applies to the leaf-most sections of a
     report.  If this section has any children, then nope. 
     Who says? - los !?!?
  */

  ASSIGN
    qbf_m = FILL(' ':u,NUM-ENTRIES(qbf_s,".":u) * 2)
    qbf_b = ENTRY(1,ENTRY(NUM-ENTRIES(qbf-sortby),qbf-sortby)," ":u).

  /* If qbf_b is a calc field, then convert to 4GL */
  DO qbf_i = 1 TO qbf-rc#:
    IF ENTRY(1,qbf-rcn[qbf_i]) = qbf_b AND qbf-rcc[qbf_i] > "" THEN DO:
      qbf_b = SUBSTRING(qbf-rcn[qbf_i],INDEX(qbf-rcn[qbf_i],",":u) + 1,-1,
                        "CHARACTER":u).
      LEAVE.
    END.
  END.

  DO qbf_i = 1 TO qbf-rc#:
    IF NOT CAN-DO(qbf-rcs[qbf_i],qbf_s)
      OR INDEX(qbf-rcg[qbf_i],"$":u) = 0 THEN NEXT.

    qbf_n = ENTRY(1,qbf-rcn[qbf_i]).
    PUT UNFORMATTED
      qbf_m 'ACCUMULATE ':u ENTRY(1,qbf_n) ' (SUB-':u
        STRING(qbf-rct[qbf_i] < 4,'COUNT/TOTAL':u) /*1:char,2:date,3:log*/
        ' BY ':u qbf_b ').':u SKIP.
    ASSIGN
      qbf_j = qbf_j + 1
      qbf_k = MAXIMUM(qbf_i,qbf_k).
  END.

  IF qbf_j > 0 THEN DO:
    IF qbf_j > 1 THEN 
      PUT UNFORMATTED qbf_m 'ASSIGN':u SKIP.
    DO qbf_i = 1 TO qbf-rc#:
      IF NOT CAN-DO(qbf-rcs[qbf_i],qbf_s)
	OR INDEX(qbf-rcg[qbf_i],"$":u) = 0 THEN NEXT.
  
      qbf_n = ENTRY(1,qbf-rcn[qbf_i]).
      PUT UNFORMATTED 
	qbf_m (IF qbf_j = 1 THEN '' ELSE '  ':u)
	'qbf-':u STRING(qbf_i,"999":u) '# = (ACCUM SUB-':u
	  STRING(qbf-rct[qbf_i] < 4,'COUNT/TOTAL':u) /*1:char,2:date,3:log*/
	  ' BY ':u qbf_b ' ':u ENTRY(1,qbf_n) ')':u
	(IF qbf_i = qbf_k THEN '.':u ELSE '') SKIP.
    END.
  END.
  
  PUT UNFORMATTED 
    qbf_m 'IF LAST-OF(':u qbf_b ') THEN':u SKIP.

END PROCEDURE. /* generate_summary */

/* c-gen6.i - end of file */

