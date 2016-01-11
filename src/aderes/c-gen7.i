/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* c-gen7.i - generate_for 
   
   Generate the FOR part of the FOR EACH statement w/o BREAK BY or other
   loop code.   This is for Report and Export.

   The following variables must be defined:
      qbf_c - character scrap

   Arguments: 
      &tables - the table(s) involved in the FOR statement.
      &margin - the indent margin (# of blanks)
      &sbuffer - buffer holding qbf-section info
*/

/*--------------------------------------------------------------------------*/

RUN aderes/c-for.p ({&tables}, {&margin}, FALSE, "FOR":u).

/* If there is a child across master-detail boundary to do an inner join:
   add on CAN-FIND clause (e.g., CAN-FIND FIRST order OF customer).
   ** We're either dealing with all tables of a section or just one table
   at a time (for percent total).  If last table in the set matches the
   last table in the section - use the normal _yichild code to determine
   inner join across sections.  Otherwise we have a table which is not
   the last in the section (so by definition the next table in the section
   is inner joined to it) so the inner "child" is this next table.
*/
qbf_c = ?.
IF ENTRY(NUM-ENTRIES({&tables}), {&tables}) = 
  ENTRY(NUM-ENTRIES({&sbuffer}.qbf-stbl), {&sbuffer}.qbf-stbl) THEN
  RUN aderes/_yichild.p ({&sbuffer}.qbf-sout, OUTPUT qbf_c).
ELSE 
  qbf_c = ENTRY(LOOKUP({&tables}, {&sbuffer}.qbf-stbl) + 1, 
      	        {&sbuffer}.qbf-stbl).

IF qbf_c <> ? THEN DO:
  /* See if there's a where clause for the last table involved in the FOR
     clause.
  */
  FIND FIRST qbf-where WHERE qbf-where.qbf-wtbl = 
    INTEGER(ENTRY(NUM-ENTRIES({&tables}), {&tables}))
    NO-ERROR.
  PUT UNFORMATTED SKIP.
  RUN aderes/c-for.p (qbf_c, INTEGER({&margin}) + 2, FALSE, 
      	       	     	IF AVAILABLE qbf-where AND
      	       	     	   (qbf-where.qbf-wask <> "" OR
      	       	     	    qbf-where.qbf-wrel BEGINS "WHERE":u OR
      	       	     	    qbf-where.qbf-wsec <> "" OR
      	       	     	    qbf-where.qbf-acls <> "")
      	       	     	THEN      	       	     	
      	       	     	   "AND CAN-FIND(FIRST":u
      	       	        ELSE
      	       	     	   "WHERE CAN-FIND(FIRST":u
      	       	       ).
END.

/* c-gen7.i - end of file */

