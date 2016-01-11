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
* _addlist.p
*
*   Returns list of calculated fields for Where Builder
*/

{ aderes/j-define.i }
{ aderes/s-alias.i } 
{ aderes/s-define.i }
{ adeshar/quryshar.i }

DEFINE OUTPUT PARAMETER qbf-f AS CHARACTER NO-UNDO.

DEFINE VARIABLE qbf-i   AS INTEGER   NO-UNDO.
DEFINE VARIABLE refName AS CHARACTER NO-UNDO.

/* For RESULTS, _AliasList should only contain one table name */
RUN alias_to_tbname (_AliasList,TRUE,OUTPUT refName).

/* Make sure we grab calc fields from the proper qbf-section */
IF AVAILABLE qbf-rel-buf THEN
  FIND FIRST qbf-section 
    WHERE CAN-DO(qbf-section.qbf-stbl,STRING(qbf-rel-buf.tid)) NO-ERROR.
IF NOT AVAILABLE qbf-section THEN RETURN.

DO qbf-i = 1 TO qbf-rc#:
  /*
  message
    "sout" qbf-section.qbf-sout skip
    "rcn" qbf-rcn[qbf-i] skip
    "rcs" qbf-rcs[qbf-i] skip
    view-as alert-box title "_addlist.p".
  */

  IF qbf-rcc[qbf-i] = "" OR NOT CAN-DO("s,d,n,l":u,
    SUBSTRING(qbf-rcc[qbf-i],1,1,"CHARACTER":u)) 
    OR qbf-section.qbf-sout <> qbf-rcs[qbf-i] THEN NEXT.

  qbf-f = qbf-f
        + (IF qbf-f = "" THEN "" ELSE ",":u)
        + ENTRY(1,qbf-rcn[qbf-i]).
END.

RETURN.

/* _calcfld.p - end of file */

