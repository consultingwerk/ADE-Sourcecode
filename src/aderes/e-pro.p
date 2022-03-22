/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* Progress Lex Converter 7.1A->7.1C Version 1.26 */

/* e-pro.p - program to dump data in 'progress export' format */

DEFINE INPUT PARAMETER qbf-s  AS CHARACTER NO-UNDO. /* Prolog, Body, Epilog */
DEFINE INPUT PARAMETER qbf-n  AS CHARACTER NO-UNDO. /* field name */
DEFINE INPUT PARAMETER qbf-l  AS CHARACTER NO-UNDO. /* field label */
DEFINE INPUT PARAMETER qbf-f  AS CHARACTER NO-UNDO. /* field format */
DEFINE INPUT PARAMETER qbf-p  AS INTEGER   NO-UNDO. /* field position */
DEFINE INPUT PARAMETER qbf-t  AS INTEGER   NO-UNDO. /* field datatype */
DEFINE INPUT PARAMETER qbf-m  AS CHARACTER NO-UNDO. /* left margin */
DEFINE INPUT PARAMETER qbf-b  AS LOGICAL   NO-UNDO. /* is first field? */
DEFINE INPUT PARAMETER qbf-e  AS LOGICAL   NO-UNDO. /* is last field? */
DEFINE INPUT PARAMETER lkup   AS LOGICAL   NO-UNDO. /* is it a lookup field? */
DEFINE INPUT PARAMETER nm-val AS CHARACTER NO-UNDO. /* no match value (lookup)*/

/*----
DEFINE VARIABLE qbf-1 AS CHARACTER NO-UNDO. /* holds -d <mdy> setting */
DEFINE VARIABLE qbf-2 AS INTEGER   NO-UNDO. /* holds -yy <century> setting */
DEFINE VARIABLE qbf-c AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-q AS INTEGER   NO-UNDO. /* seek position */
----*/

CASE qbf-s:
  WHEN "p":u THEN DO:
    /* nothing to do! */
  END.
  WHEN "b":u THEN DO:
    IF qbf-b THEN PUT UNFORMATTED qbf-m 'EXPORT':u.
    IF lkup THEN
      PUT UNFORMATTED 
        SKIP 
      	 qbf-m '  (IF ':u qbf-n ' <> ? THEN STRING(':u qbf-n 
      	   ') ELSE "':u nm-val '")':u SKIP.
    ELSE
      PUT UNFORMATTED 
        SKIP qbf-m '  ':u qbf-n. 
    IF qbf-e THEN PUT UNFORMATTED '.':u SKIP.
  END.
  WHEN "e":u THEN DO:
    /*-----
    IF qbf-b THEN DO:
      PUT UNFORMATTED ".":u SKIP.
      {&FIND_TABLE_BY_ID} INTEGER(ENTRY(1,qbf-tables)).
      ASSIGN
        qbf-c = qbf-rel-buf.tname
        qbf-q = SEEK(OUTPUT).
      RUN <get-date-settings> (OUTPUT qbf-1,OUTPUT qbf-2).
      PUT UNFORMATTED
        "PSC":u                                             SKIP
        "filename=":u   ENTRY(2,qbf-c,".":u)                SKIP
        "records=":u    STRING(qbf-count,"99999999":u)      SKIP
        "ldbname=":u    ENTRY(1,qbf-c,".":u)                SKIP
        "timestamp=":u  STRING(YEAR( TODAY),"9999":u) "/":u
                        STRING(MONTH(TODAY),"99":u  ) "/":u
                        STRING(DAY(  TODAY),"99":u  ) "-":u
                        STRING(TIME,"HH:MM:SS":u)           SKIP
        "numformat=":u  SUBSTRING(STRING(1,"9.":u),2,1,"CHARACTER":u) SKIP
        "dateformat=":u qbf-1 STRING(- qbf-2)               SKIP
        "map=NO-MAP":u                                      SKIP
        ".":u                                               SKIP
        "00":u STRING(qbf-q,"99999999":u)                   SKIP.
      OUTPUT CLOSE.
    END.
    ----*/
  END.
END CASE.

RETURN.

/* e-pro.p - end of file */

