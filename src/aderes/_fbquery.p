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
/* _fbquery.p - Generate code to define a new shared query or to
      	        define the same query shared and open it.

   A qbf-section buffer for the section to generate query for must be
   available.
*/

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/j-define.i }

DEFINE INPUT PARAMETER qbf-sfx  AS CHAR	NO-UNDO. /* frame suffix */
DEFINE INPUT PARAMETER qbf-sect AS CHAR	NO-UNDO. /* section for frame */
DEFINE INPUT PARAMETER qbf-mode AS CHAR NO-UNDO. /* NEW SHARED, SHARED or "" */
DEFINE INPUT PARAMETER flag     AS INT  NO-UNDO. /* 1 = define, 2 = open */
      	       	     	      	       	     	 /* not used if mode=SHARED */
DEFINE INPUT PARAMETER qbf-marg AS CHAR NO-UNDO. /* margin */

DEFINE VARIABLE qbf_i AS INTEGER   NO-UNDO.  /* for defbufs.i */
DEFINE VARIABLE qbf_j AS INTEGER   NO-UNDO.  /* scrap */
DEFINE VARIABLE qbf_k AS INTEGER   NO-UNDO.  /* scrap */
DEFINE VARIABLE qbf_l AS CHARACTER NO-UNDO.  /* scrap */
DEFINE VARIABLE qbf_m AS INTEGER   NO-UNDO.  /* scrap */
DEFINE VARIABLE qbf_n AS CHARACTER NO-UNDO.  /* field to add to list */
DEFINE VARIABLE qbf_s AS CHARACTER NO-UNDO.  /* scrap */

FIND FIRST qbf-section WHERE qbf-section.qbf-sout = qbf-sect.

IF qbf-mode <> "SHARED":u THEN 
   /* This "NEW SHARED" or not shared (for generated .p) code
      will be in the main generated .p */
   IF flag = 1 THEN
     RUN define_query.
   ELSE
     RUN open_query.
ELSE DO:
   /* the shared def and open will be in a separate .p so that when the
      query changes with query by example we only have to recompile a 
      small .p.
   */
   OUTPUT TO VALUE(qbf-tempdir + "q":u + qbf-sfx + ".p":u) NO-ECHO NO-MAP.
   /*
   > DEFINE SHARED BUFFER customer FOR demo.customer.
   > DEFINE SHARED BUFFER order FOR demo.order.
   */
   { aderes/defbufs.i &mode = "SHARED " }
   RUN define_query.
   RUN open_query.
   OUTPUT CLOSE.
END.

/*--------------------------------------------------------------------------*/

/* Define the query for a frame */
PROCEDURE define_query:
  DEFINE VARIABLE qbf_i	  AS INTEGER   NO-UNDO. /* scrap/loop */
  DEFINE VARIABLE ctbl	  AS CHARACTER NO-UNDO. /* 1st child table index */
  DEFINE VARIABLE tbls	  AS CHARACTER NO-UNDO. /* list of table indices */
  DEFINE VARIABLE bufname AS CHARACTER NO-UNDO.
  DEFINE VARIABLE tbl_id  AS CHARACTER NO-UNDO. /* 1 table id */

  /*
  > DEFINE <NEW> SHARED QUERY qbf-query-1
  >   FOR demo.customer, demo.order
  >   SCROLLING.
  */
  RUN aderes/_yichild.p (qbf-section.qbf-sout,OUTPUT ctbl).

  tbls = qbf-section.qbf-stbl + (IF ctbl = ? THEN "" ELSE ",":u + ctbl).

  PUT UNFORMATTED
    qbf-marg 'DEFINE ':u qbf-mode (IF qbf-mode > '' THEN ' ':u ELSE '')
      'QUERY qbf-query-':u qbf-sfx SKIP
    qbf-marg '  FOR ':u.

  DO qbf_i = 1 TO NUM-ENTRIES(tbls):
    tbl_id = ENTRY(qbf_i,tbls).
    {&FIND_TABLE_BY_ID} INTEGER(tbl_id).
    ASSIGN
      bufname = qbf-rel-buf.tname
      qbf_s   = "".

    IF tbl_id = ctbl THEN DO:
      /* For inner join reference to child table, use a different buffer.
      	 Otherwise we reference the same buffer in parent and child queries
      	 and Progress complains.
      */
      bufname = {&TBNAME_TO_BUFNAME}.
      bufname = "qbfbuf-":u + SUBSTRING(bufname,1,25,"CHARACTER":u).
    END.
    PUT UNFORMATTED
      (IF qbf_i > 1 THEN ',':u + CHR(10) ELSE '')
      (IF qbf_i > 1 THEN '  ':u ELSE '')
      bufname.

    /* Omit FIELDS() support for Beta 
      SKIP.
      qbf-marg '    FIELDS(':u.

    /* field list support */
    DO qbf_j = 1 TO qbf-rc#:
      /* does field belong to this section? */
      IF NOT CAN-DO(qbf-rcs[qbf_j],qbf-sect) THEN NEXT.
  
      qbf_m = IF qbf-rcc[qbf_j] > "" THEN NUM-ENTRIES(qbf-rcc[qbf_j]) ELSE 2.

      DO qbf_k = 2 TO qbf_m:
        qbf_n = IF qbf-rcc[qbf_j] = "" THEN qbf-rcn[qbf_j]
                ELSE IF CAN-DO("s,d,n,l":u,ENTRY(1,qbf-rcc[qbf_j]))
                     THEN ENTRY(qbf_k,qbf-rcc[qbf_j])
                ELSE "".

        IF qbf_n = "" OR LOOKUP(qbf_s,qbf_n) > 0 OR
          ENTRY(1,qbf_n,".":u) + ".":u + ENTRY(2,qbf_n,".":u) <> bufname
          THEN NEXT.

        qbf_s = qbf_s + (IF qbf_s = "" THEN "" ELSE ",":u) + qbf_n.
  
        IF INDEX(qbf_s,",":u) > 0 THEN 
          PUT UNFORMATTED SKIP.
        PUT UNFORMATTED 
          qbf-marg FILL(' ':u, (IF qbf_s = qbf_n THEN 0 ELSE 11)) qbf_n.
      END.
    END. /* field list support */
    PUT UNFORMATTED ')':u.
    */
  END.

  PUT UNFORMATTED SKIP '  SCROLLING.':u SKIP(1).
END.

/*--------------------------------------------------------------------------*/

/* Open the query for this frame */
PROCEDURE open_query:
  DEFINE VAR ctbl AS CHARACTER NO-UNDO. /* child table */

  /*
  > OPEN QUERY qbf-query-1
  >   FOR EACH demo.customer
  >   WHERE cust-num > 10
  >   BY demo.customer.cust-num INDEXED-REPOSITION.
  */
  PUT UNFORMATTED 
    qbf-marg 'OPEN QUERY qbf-query-':u qbf-sfx SKIP.
  RUN aderes/c-for.p (qbf-section.qbf-stbl, LENGTH(qbf-marg,"CHARACTER":u) + 2, 
                      TRUE, "FOR":u).

  /* This will cause the parent query to find only records where
     there exists a detail record. i.e., It forces this to be an
     inner join even though the frames are split.  For an outer
     join, we just wouldn't do this code.  
     Progress doesn't allow CAN-FIND phrase in open query statement (why?)
     so we have to use FIRST which actually fetches a record - too bad.
  */
  RUN aderes/_yichild.p (qbf-section.qbf-sout,OUTPUT ctbl).

  IF ctbl <> ? THEN DO:
    PUT UNFORMATTED
      ', ':u SKIP.
    RUN aderes/c-for.p (ctbl,LENGTH(qbf-marg,"CHARACTER":u) + 4,TRUE,"FIRST":u).
  END.

  /* prescan qbf-section.qbf-sort for calculated fields -dma */
  IF qbf-section.qbf-sort <> "" THEN DO:
    /* qbf-sort entry will be either field name e.g., "balance" or "qbf-002" 
       or field name followed by " DESC" e.g., "balance DESC".
    */
    qbf_l = "".
    DO qbf_j = 1 TO NUM-ENTRIES(qbf-section.qbf-sort):
      DO qbf_k = 1 TO qbf-rc#:
        /* See if sort field name matches entry 1 of qbf-rcn */
        IF (REPLACE(ENTRY(qbf_j,qbf-section.qbf-sort)," DESC":u,"") =
          ENTRY(1,qbf-rcn[qbf_k])) THEN LEAVE.
      END.
    
      /* qbf-l will be either the name of the field or the calc field
         expression (which is second entry in qbf-rcn), followed
         by "DESC" if appropriate.
      */   
      qbf_l = qbf_l + (IF qbf_l > "" THEN CHR(3) ELSE "")
            + (IF qbf_k <= qbf-rc# AND qbf-rcc[qbf_k] > "" THEN
               "(":u 
               + SUBSTRING(qbf-rcn[qbf_k],INDEX(qbf-rcn[qbf_k],",":u) + 1,-1,
                           "CHARACTER":u) 
               + ")":u
               + (IF INDEX(ENTRY(qbf_j,qbf-section.qbf-sort)," DESC":u) > 0 THEN 
                   " DESC":u ELSE "")
               ELSE ENTRY(qbf_j,qbf-section.qbf-sort)).
    END.
  
    PUT UNFORMATTED SKIP
      qbf-marg '  BY ':u REPLACE(qbf_l,CHR(3),' BY ':u).
  END.

  /* Only make it indexed-reposition for form when there's only 1 table
     so form may be updateable and we want to get at added records quickly.
     Also, Progress doesn't let you do it if another table is mentioned
     in the query (which it will be if we added on the inner join FIRST
     clause).
  */
  PUT UNFORMATTED
    (IF qbf-module = "f" AND NUM-ENTRIES(qbf-section.qbf-stbl) = 1 AND
     ctbl = ? THEN 
      ' INDEXED-REPOSITION':u ELSE "")
    '.':u SKIP.

END PROCEDURE.  /* open_query */

/*--------------------------------------------------------------------------*/
/* alias_to_tbname */
{ aderes/s-alias.i }

/* _fbquery.p - end of file */

