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
/* Progress Lex Converter 7.1A->7.1C Version 1.26 */

/* y-sort.p - query sort order */

{ aderes/s-system.i }
{ aderes/s-define.i }

DEFINE OUTPUT PARAMETER qbf-chg AS LOGICAL NO-UNDO. /* changed? */

DEFINE VARIABLE qbf-new	 AS CHARACTER   NO-UNDO.
DEFINE VARIABLE qbf-old	 AS CHARACTER   NO-UNDO. 
DEFINE VARIABLE agg-chr	 AS CHARACTER   NO-UNDO. /* aggregate character */
DEFINE VARIABLE agg-tok	 AS CHARACTER   NO-UNDO. /* aggregate token */
DEFINE VARIABLE new-rcg	 AS CHARACTER   NO-UNDO. /* updated qbf-rcg value */
DEFINE VARIABLE qbf-l	 AS LOGICAL     NO-UNDO. /* generic logical */
DEFINE VARIABLE ax-summ  AS LOGICAL     NO-UNDO. /* zap totals only summary */
DEFINE VARIABLE ix       AS INTEGER     NO-UNDO. /* index */
DEFINE VARIABLE f-ix     AS INTEGER     NO-UNDO. /* sort field index */
DEFINE VARIABLE pos      AS INTEGER     NO-UNDO. /* char position */

ASSIGN
  qbf-old = qbf-sortby
  qbf-new = REPLACE(qbf-sortby," DESC":u,"").

RUN aderes/j-field2.p (qbf-tables,"$#12345sdnl@":u,"", 
                       INPUT-OUTPUT qbf-new,OUTPUT qbf-l).

qbf-chg = (qbf-new <> qbf-old).
    
IF qbf-chg THEN DO:
  ASSIGN
    qbf-redraw = TRUE
    qbf-sortby = qbf-new
    .
  RUN aderes/_updcrit.p.
END.

IF qbf-old = "" THEN RETURN. /* no need to fix aggregates */

/* for aggregate fixing, we don't care about asc/desc */
ASSIGN
  qbf-new = REPLACE(qbf-new," DESC":u,"") 
  qbf-old = REPLACE(qbf-old," DESC":u,"").

IF qbf-new <> qbf-old THEN DO:
  /* If there were aggregates based on sort fields that no longer exist, 
     clear them.  Totals only summary is based on the last sort field so
     if that's changed, clear summary specification. */

  IF qbf-new = "" THEN
    ax-summ = qbf-summary AND ENTRY(NUM-ENTRIES(qbf-old), qbf-old) <> "".
  ELSE
    ax-summ = qbf-summary AND
             (ENTRY(NUM-ENTRIES(qbf-new),qbf-new) <>
       	      ENTRY(NUM-ENTRIES(qbf-old),qbf-old)).

  DO ix = 1 TO qbf-rc#:
    IF qbf-rcg[ix] = "" OR qbf-rcg[ix] = "&":u THEN NEXT.
    ASSIGN
      agg-tok = ""
      new-rcg = "".

    IF ax-summ THEN
      ASSIGN   
      	qbf-summary = FALSE
        qbf-rcg[ix] = REPLACE(qbf-rcg[ix],"$":u,""). 
    IF qbf-rcg[ix] = "" THEN NEXT.

    /* rcg could be something like t1$a5 so we have to parse this apart */
    DO pos = 1 TO LENGTH(qbf-rcg[ix],"CHARACTER":u):
      agg-chr = SUBSTRING(qbf-rcg[ix],pos,1,"CHARACTER":u).

      IF CAN-DO("a,n,x,c,t,$":u, agg-chr) THEN DO:
      	 /* process previous token if there is one. */
      	 IF agg-tok <> "" AND agg-tok <> "$":u THEN 
      	   RUN fix_agg.
      	 /* start a new token */
      	 ASSIGN
      	   new-rcg = new-rcg + agg-tok
      	   agg-tok = agg-chr.
      END. /* end start of new token character */
      ELSE 
        agg-tok = agg-tok + agg-chr. 
    END. 

    IF agg-tok <> "$":u THEN
      RUN fix_agg.  /* process last token */
    ASSIGN
      new-rcg     = new-rcg + agg-tok 
      qbf-rcg[ix] = new-rcg.
  END. /* end field loop */
END.

RETURN.

/*-----------------------Internal Procedures------------------------*/

/* Fix up this aggregate token based on new sort fields */
PROCEDURE fix_agg:
  DEFINE VARIABLE e-new AS CHARACTER NO-UNDO.
  DEFINE VARIABLE e-old AS CHARACTER NO-UNDO.

  /* See if this sort field has changed */
  ASSIGN
    f-ix  = INTEGER(SUBSTRING(agg-tok, 2,-1,"CHARACTER":u)) 

    /* This assumes incorrectly that the NEW sort field list will have as
       many fields as the OLD list.  We get an error if the new list has
       fewer fields than the old list. - dma 
    e-old = IF qbf-old > "" AND f-ix > 0 THEN ENTRY(f-ix, qbf-old) ELSE ""
    e-new = IF qbf-new > "" AND f-ix > 0 THEN ENTRY(f-ix, qbf-new) ELSE "".
    */
    e-old = IF qbf-old > "" AND f-ix > 0 AND f-ix <= NUM-ENTRIES(qbf-old) THEN 
              ENTRY(f-ix, qbf-old) ELSE ""
    e-new = IF qbf-new > "" AND f-ix > 0 AND f-ix <= NUM-ENTRIES(qbf-new) THEN 
              ENTRY(f-ix, qbf-new) ELSE "".

  IF f-ix > NUM-ENTRIES(qbf-new) OR e-new <> e-old THEN DO:
    /* Before removing aggregate, see if the sort field is in new
       sort list, just in a different place.  */
    f-ix = IF qbf-new > "" THEN LOOKUP(e-old, qbf-new) ELSE 0.

    IF f-ix > 0 THEN
      SUBSTRING(agg-tok, 2,-1,"CHARACTER":u) = 
        STRING(f-ix). /* update sort fld index */
    ELSE
      agg-tok = "". /* clear this aggregate */
  END.
END.

/* y-sort.p - end of file */

