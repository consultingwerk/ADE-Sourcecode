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
 * s-where.p - wrapper for adeshar/_query.p
 */

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/j-define.i }
{ aderes/s-alias.i }
{ adeshar/quryshar.i "NEW GLOBAL" }
{ adecomm/tt-brws.i "NEW"}
{ adeuib/brwscols.i NEW } /* for query builder compatibility */

DEFINE OUTPUT PARAMETER qbf-chg AS LOGICAL NO-UNDO. /* changed? */

/* for query builder compatibility */
DEFINE NEW SHARED VARIABLE _query-u-rec AS RECID NO-UNDO. 

DEFINE VARIABLE qbf-c   AS CHARACTER NO-UNDO. /* old WHERE clause */
DEFINE VARIABLE qbf-i   AS INTEGER   NO-UNDO. /* table index */
DEFINE VARIABLE qbf-m   AS LOGICAL   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-new AS CHARACTER NO-UNDO CASE-SENSITIVE. /* new phrase */
DEFINE VARIABLE qbf-old AS CHARACTER NO-UNDO CASE-SENSITIVE. /* old phrase */

qbf-i = INTEGER(ENTRY(1, qbf-tables)).

IF NUM-ENTRIES(qbf-tables) > 1 THEN
  RUN aderes/j-table1.p (qbf-tables, YES, INPUT-OUTPUT qbf-i).
 
IF qbf-i = 0 OR qbf-i = ? THEN RETURN.
FIND FIRST qbf-where WHERE qbf-where.qbf-wtbl = qbf-i NO-ERROR.
{&FIND_TABLE_BY_ID} qbf-i.

ASSIGN
  _TblList   = qbf-rel-buf.tname
  _Where[1]  = (IF AVAILABLE qbf-where THEN qbf-where.qbf-wcls ELSE "")
  qbf-c      = _Where[1]
  qbf-old    = _Where[1]
  .

RUN alias_to_tbname (qbf-rel-buf.tname, FALSE, OUTPUT _AliasList).

_Callback = IF _fieldcheck <> ? THEN _fieldcheck ELSE "".

RUN adeshar/_query.p ("",                /* browser-name */
                      qbf-hidedb,        /* suppress_dbname */
                      "Results_Where":u, /* application */
                      "Where":u,         /* pcValidStates */
                      NO,                /* plVisitFields */
                      YES,               /* auto_check */
               OUTPUT qbf-m).            /* cancelled? */

IF _Where[1] = ? THEN 
  ASSIGN
    _Where[1] = ""
    qbf-new   = ""
    .
ELSE
  ASSIGN
    qbf-new = _Where[1].

FIND FIRST qbf-where WHERE qbf-where.qbf-wtbl = qbf-i NO-ERROR.
IF NOT AVAILABLE qbf-where AND _Where[1] > "" THEN 
  CREATE qbf-where.
 
IF AVAILABLE qbf-where THEN 
  ASSIGN
    /*qbf-chg            = (qbf-where.qbf-wcls <> _Where[1]) */
    qbf-chg            = qbf-old <> qbf-new
    qbf-dirty          = qbf-dirty OR qbf-chg
    qbf-where.qbf-wtbl = qbf-i
    qbf-where.qbf-wcls = REPLACE(_Where[1],CHR(13),' ':u)
    qbf-where.qbf-wask = "".
   
IF qbf-chg THEN DO:
  RUN aderes/_updcrit.p.
  qbf-redraw = CAN-DO("b,f":u,qbf-module).
END.
  
RUN adecomm/_setcurs.p ("").

RETURN.

/* s-where.p - end of file */

