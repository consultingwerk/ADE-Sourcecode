/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* Progress Lex Converter 7.1A->7.1C Version 1.26 */

/* c-for.p - generate query phrase with WHEREs and OFs */

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/j-define.i }
{ aderes/r-define.i }

/*
 * There are many sources for the WHERE clauses.
 * rel = relation 'where' or 'of' clause
 * whr = user-entered 'where' clause
 * sec = security restrictive 'where' clause
 * 
 * rel    whr    sec    -> output
 * ------ ------ ------    ------
 * -      -      -      -> -
 * OF     -      -      -> OF 1
 * WHERE  -      -      -> WHERE 1
 * -      WHERE  -      -> WHERE 2
 * OF     WHERE  -      -> OF 1 WHERE 2
 * WHERE  WHERE  -      -> WHERE (1) AND (2)
 * -      -      WHERE  -> WHERE 3
 * OF     -      WHERE  -> OF 1 WHERE 3
 * WHERE  -      WHERE  -> WHERE (1) AND (3)
 * -      WHERE  WHERE  -> WHERE (2) AND (3)
 * OF     WHERE  WHERE  -> OF 1 WHERE (2) AND (3)
 * WHERE  WHERE  WHERE  -> WHERE (1) AND (2) AND (3)
 */

/* 
   qbf-t = comma-sep list of tables for FOR EACH 
   qbf-m = margin (number of spaces to indent code) 
   qbf-q = true - used with OPEN QUERY, false otherwise 
   qbf-p = starting phrase ("FOR", "FIRST", "WHERE CAN-FIND(FIRST")
*/
DEFINE INPUT PARAMETER qbf-t AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER qbf-m AS INTEGER   NO-UNDO.
DEFINE INPUT PARAMETER qbf-q AS LOGICAL   NO-UNDO. /* not used */
DEFINE INPUT PARAMETER qbf-p AS CHARACTER NO-UNDO.

DEFINE VARIABLE beg-byte AS INTEGER   NO-UNDO. 
DEFINE VARIABLE end-byte AS INTEGER   NO-UNDO. 
DEFINE VARIABLE idx-byte AS INTEGER   NO-UNDO. 
DEFINE VARIABLE qbf-c	 AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-s	 AS CHARACTER NO-UNDO. /* field list */
DEFINE VARIABLE qbf-i	 AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-j	 AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-k	 AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-n	 AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE tblid	 AS CHARACTER NO-UNDO. /* table id */
DEFINE VARIABLE bufname  AS CHARACTER NO-UNDO.
DEFINE VARIABLE newfield AS CHARACTER NO-UNDO.

IF ((qbf-m = 0 OR (CAN-FIND(FIRST qbf-hsys) AND qbf-m = 2))
  AND CAN-DO("r,e":u,qbf-module)) THEN
  PUT UNFORMATTED
    FILL(' ':u, qbf-m) "main-loop:":u SKIP.
    
PUT UNFORMATTED
  FILL(' ':u, qbf-m) qbf-p ' ':u.

DO qbf-i = 1 TO NUM-ENTRIES(qbf-t):
  tblid = ENTRY(qbf-i,qbf-t).
  FIND FIRST qbf-where WHERE qbf-where.qbf-wtbl = INTEGER(tblid) NO-ERROR.
  qbf-c = "".

  IF AVAILABLE qbf-where THEN DO:
    IF qbf-where.qbf-wask BEGINS "WHERE":u THEN
      qbf-where.qbf-wask = 
        TRIM(SUBSTRING(qbf-where.qbf-wask,6,-1,"CHARACTER":u)).
    IF qbf-where.qbf-wsec BEGINS "WHERE":u THEN
      qbf-where.qbf-wsec = 
        TRIM(SUBSTRING(qbf-where.qbf-wsec,6,-1,"CHARACTER":u)).

    /*
     * FWI: Parenthesis, or the lack of them, is important. Do not
     * add parenthesis to all substitutions. Syntax error will be generated.
     * The &1 substitutions will have the keyword WHERE or OR in it.
     */
    CASE (IF qbf-where.qbf-wrel BEGINS "OF":u THEN "O":u
        ELSE IF qbf-where.qbf-wrel = "" THEN "-":u ELSE "W":u)
          + (IF qbf-where.qbf-wask = "" THEN "-":u ELSE "W":u)
          + (IF qbf-where.qbf-wsec = "" THEN "-":u ELSE "W":u)
          + (IF qbf-where.qbf-acls = "" THEN "-":u ELSE "W":u):
      WHEN "----":u THEN qbf-c = "".
      WHEN "O---":u THEN qbf-c = "&1":u.
      WHEN "W---":u THEN qbf-c = "&1":u.
      WHEN "-W--":u THEN qbf-c = "WHERE (&2)":u.
      WHEN "OW--":u THEN qbf-c = "&1 WHERE &2":u.
      WHEN "WW--":u THEN qbf-c = "&1 AND (&2)":u.
      WHEN "--W-":u THEN qbf-c = "WHERE (&3)":u.
      WHEN "O-W-":u THEN qbf-c = "&1 WHERE (&3)":u.
      WHEN "W-W-":u THEN qbf-c = "&1 AND (&3)":u.
      WHEN "-WW-":u THEN qbf-c = "WHERE (&2) AND (&3)":u.
      WHEN "OWW-":u THEN qbf-c = "&1 WHERE (&2) AND (&3)":u.
      WHEN "WWW-":u THEN qbf-c = "&1 AND (&2) AND (&3)":u.
      WHEN "---W":u THEN qbf-c = "WHERE (&4)":u.
      WHEN "-W-W":u THEN qbf-c = "WHERE (&2) AND (&4)":u.
      WHEN "--WW":u THEN qbf-c = "WHERE (&3) AND (&4)":u.
      WHEN "-WWW":u THEN qbf-c = "WHERE (&2) AND (&3) AND (&4)":u.
      WHEN "O--W":u THEN qbf-c = "&1 WHERE (&4)":u.
      WHEN "OW-W":u THEN qbf-c = "&1 WHERE (&2) AND (&4)":u.
      WHEN "O-WW":u THEN qbf-c = "&1 WHERE (&3) AND (&4)":u.
      WHEN "OWWW":u THEN qbf-c = "&1 WHERE (&2) AND (&3) AND (&4)":u.
      WHEN "W--W":u THEN qbf-c = "&1 AND (&4)":u.
      WHEN "WW-W":u THEN qbf-c = "&1 AND (&2) AND (&4)":u.
      WHEN "W-WW":u THEN qbf-c = "&1 AND (&3) AND (&4)":u.
      WHEN "WWWW":u THEN qbf-c = "&1 AND (&2) AND (&3) AND (&4)":u.
    END CASE.

    qbf-c = SUBSTITUTE(qbf-c, 
      	       	       qbf-where.qbf-wrel, 
      	       	       qbf-where.qbf-wask, 
      	       	       qbf-where.qbf-wsec, 
      	       	       qbf-where.qbf-acls).
  END. /* qbf-where */

  IF qbf-c <> "" THEN qbf-c = " ":u + qbf-c.

  IF qbf-p = "FOR":u THEN
    PUT UNFORMATTED 'EACH ':u.

  {&FIND_TABLE_BY_ID} INTEGER(tblid).

  /*
   * The following line is commented out because it break aliases. We
   * don't want to get the real table name in this case, unless
   * someone was trying to fix a bug for an "obscure" code generation
   * problem. Until it is resolved the commented line of code
   * will be replaced by the line underneath it. djl
   */
  /* RUN alias_to_tbname (qbf-rel-buf.tname, FALSE, OUTPUT bufname).*/
  ASSIGN
    bufname = qbf-rel-buf.tname
    qbf-s   = "".

  /* For "FIRST" inner join reference to child table, use a different buffer.
     Otherwise we reference the same buffer in parent and child DEFINE
     QUERYs and Progress complains. */
  IF qbf-p = "FIRST":u THEN 
    ASSIGN
      bufname = {&TBNAME_TO_BUFNAME}
      bufname = "qbfbuf-":u + SUBSTR(bufname,1,25,"CHARACTER":u)
      qbf-c   = REPLACE(qbf-c, qbf-rel-buf.tname + ".":u, bufname + ".":u).

  PUT UNFORMATTED bufname.

  /*
  /* only support FIELDS on inner-most table for now */
  IF CAN-DO("r,l,e":u,qbf-module) 
    AND INDEX(qbf-p,"FIRST":u) = 0 
    AND qbf-i = NUM-ENTRIES(qbf-t) THEN DO:
    PUT UNFORMATTED
      SKIP FILL(' ':u, qbf-m) '    FIELDS(':u.

    /* query fields */
    DO qbf-j = 1 TO qbf-rc#:
      qbf-n = IF qbf-rcc[qbf-j] > "" THEN NUM-ENTRIES(qbf-rcc[qbf-j]) ELSE 2.

      DO qbf-k = 2 TO qbf-n:
        newfield = IF qbf-rcc[qbf-j] = "" THEN qbf-rcn[qbf-j]
                   ELSE IF CAN-DO("s,d,n,l",ENTRY(1,qbf-rcc[qbf-j]))
                        THEN ENTRY(qbf-k,qbf-rcc[qbf-j])
                   ELSE "".
        IF newfield = "" OR LOOKUP(qbf-s,newfield) > 0 OR
          ENTRY(1,newfield,".":u) + ".":u + ENTRY(2,newfield,".":u) <> bufname
          THEN NEXT.

        RUN new_field.
      END.
    END. /* query fields */

    /* header/footer VALUE fields */
    FOR EACH qbf-hsys:
      DO qbf-j = 1 TO 8:
        ASSIGN
          idx-byte = 1
          beg-byte = INDEX(qbf-hsys.qbf-htxt[qbf-j],"~{VALUE":u,idx-byte).

        DO WHILE beg-byte > 0:
          ASSIGN
            end-byte = INDEX(qbf-hsys.qbf-htxt[qbf-j],"~}":u,beg-byte + 1)
            newfield = SUBSTRING(qbf-hsys.qbf-htxt[qbf-j],beg-byte,
                         end-byte - beg-byte + 1,"CHARACTER":u)
            newfield = SUBSTRING(ENTRY(1,newfield,";":u),8,-1,"CHARACTER":u)
            .
    
          IF ENTRY(1,newfield,".":u) + ".":u + ENTRY(1,newfield,".":u) =
            bufname THEN 
            RUN new_field.
 
          ASSIGN
            idx-byte = end-byte + 1
            beg-byte = INDEX(qbf-hsys.qbf-htxt[qbf-j],"~{VALUE":u,idx-byte).
        END.
      END.
    END. /* header/footer VALUE fields */

    PUT UNFORMATTED ')':u.
  END.
  */

  /* convert calc field in WHERE clause to 4GL */
  RUN calcfld_to_4gl (INPUT-OUTPUT qbf-c).
  
  PUT UNFORMATTED 
    (IF CAN-DO("b,f":u,qbf-module) AND AVAILABLE qbf-where 
       AND qbf-where.qbf-wojo THEN ' OUTER-JOIN':u ELSE '')
    (IF qbf-p BEGINS "FOR":u THEN ' NO-LOCK':u ELSE '').

  IF qbf-c > "" THEN 
    PUT UNFORMATTED 
      SKIP FILL(' ':u,qbf-m) ' ':u qbf-c. 

  PUT UNFORMATTED 
    (IF qbf-p MATCHES "*CAN-FIND*":u THEN ') ':u ELSE 
     IF qbf-i < NUM-ENTRIES(qbf-t) THEN ',':u ELSE '') /*SKIP*/.

  /*PUT UNFORMATTED FILL(' ':u,qbf-m + 2).*/
END.

/*--------------------------------------------------------------------------*/
PROCEDURE new_field:
  qbf-s = qbf-s + (IF qbf-s = "" THEN "" ELSE ",":u) + newfield.

  IF INDEX(qbf-s,",":u) > 0 THEN 
    PUT UNFORMATTED SKIP
      FILL(' ':u, qbf-m + (IF qbf-s = newfield THEN 0 ELSE 9)) newfield.
  ELSE
    PUT UNFORMATTED 
      FILL(' ':u, (IF qbf-s = newfield THEN 0 ELSE 9)) newfield.
END PROCEDURE.

/*--------------------------------------------------------------------------*/
/* alias_to_tbname */
{ aderes/s-alias.i }

/*--------------------------------------------------------------------------*/
/* calcfld_to_4gl */
{ aderes/_calc4gl.i }

/* c-for.p - end of file */

