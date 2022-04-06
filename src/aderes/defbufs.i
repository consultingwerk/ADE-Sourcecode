/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
   defbufs.i - generate code which defines shared buffers for all the
      	       query tables.

   Arguments:
      &mode - Either "NEW SHARED ", "SHARED " or nothing.  
      	      Note trailing blank.

   Requirements:
     Caller must have variable qbf_i defined.
     s-define.i and j-define.i must be included.
     aderes/s-alias.i must be included.
*/

/*
  > DEFINE [NEW] SHARED BUFFER customer FOR demo.customer.
  > DEFINE [NEW] SHARED BUFFER order FOR demo.order.
*/

DEFINE BUFFER qbf_sbuffer FOR qbf-section. /* don't mess up callers buffer */
DEFINE VARIABLE bufname AS CHAR NO-UNDO.
DEFINE VARIABLE tname   AS CHAR NO-UNDO.

FOR EACH qbf_sbuffer BY qbf_sbuffer.qbf-sfrm:
   DO qbf_i = 1 TO NUM-ENTRIES(qbf_sbuffer.qbf-stbl):
      {&FIND_TABLE_BY_ID} INTEGER(ENTRY(qbf_i,qbf_sbuffer.qbf-stbl)).
      ASSIGN
      	tname = qbf-rel-buf.tname
        bufname = {&TBNAME_TO_BUFNAME}.
      RUN alias_to_tbname (tname, FALSE, OUTPUT tname).
      PUT UNFORMATTED
      	 'DEFINE {&mode}BUFFER ':u bufname ' FOR ':u tname '.':u SKIP.

      /* If there is an inner join across a master detail split then 
      	 define another buffer for the inner join table (the first table 
      	 in the child).  Otherwise we'll have the same buffer in both 
      	 parent and child queries and Progress makes a fuss.
      	 (Only need for form and browse since it is only a problem with
      	 DEFINE QUERY usage.)
      */
      IF CAN-DO("b,f":u, qbf-module) AND
         qbf_i = 1 AND 	      	       /* first table of section */
	 qbf_sbuffer.qbf-smdl AND      /* start of master detail section */
	 NOT qbf_sbuffer.qbf-sojo AND  /* inner join */
	 NUM-ENTRIES(qbf_sbuffer.qbf-sout, ".") > 1 /* not first section*/
      THEN DO:
	bufname = "qbfbuf-":u + SUBSTRING(bufname,1,25,"CHARACTER":u).
	PUT UNFORMATTED
	  'DEFINE {&mode}BUFFER ':u bufname ' FOR ':u tname '.':u SKIP.
      END.
   END.
END.
PUT UNFORMATTED SKIP.

/* defbufs.i - end of file */


