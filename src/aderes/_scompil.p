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
/* s-compil.p - Do a test compile for some expression or piece of include
      	        code.

   ***The caller is responsible for deleting the test compile files when
   done.  They are qbf_tc.p. and qbf_tc.d for the XREF file.
*/

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/j-define.i }

/***
   The first two parameters are relevant if this is an expression for a 
   calculated field.  Otherwise p_ix should be set to 0 and datatype
   is ignored.
*/
DEFINE INPUT  PARAMETER p_type AS INTEGER   NO-UNDO. /* datatype if new field */
DEFINE INPUT  PARAMETER p_ix   AS INTEGER   NO-UNDO. /* field index */
DEFINE INPUT  PARAMETER p_exp  AS CHARACTER NO-UNDO. /* expression to compile */
DEFINE INPUT  PARAMETER p_xref AS LOGICAL   NO-UNDO. /* generate xref file? */
DEFINE OUTPUT PARAMETER p_ok   AS LOGICAL   NO-UNDO. /* compiled? */

DEFINE VARIABLE qbf_i AS INTEGER NO-UNDO. /* loop */

OUTPUT TO "qbf_tc.p":u NO-ECHO NO-MAP. /* tc = test compile */

{ aderes/defbufs.i }
DO qbf_i = 1 TO NUM-ENTRIES(qbf-tables):
  {&FIND_TABLE_BY_ID} INTEGER(ENTRY(qbf_i,qbf-tables)).
  PUT UNFORMATTED
    'FIND FIRST ':u qbf-rel-buf.tname
    ' NO-LOCK NO-ERROR.':u SKIP.
END.

/* p_ix may be the index for a new or existing calculated field */
DO qbf_i = 1 TO MAXIMUM(qbf-rc#,p_ix):
  IF qbf_i > qbf-rc# OR qbf-rcc[qbf_i] > "" THEN DO:
    IF qbf_i > qbf-rc# AND qbf-rcc[qbf_i] = "" THEN
      PUT UNFORMATTED
        'DEFINE VARIABLE qbf-':u STRING(qbf_i,"999":u).
    ELSE
    IF qbf-rcc[qbf_i] > "" THEN
      PUT UNFORMATTED
        'DEFINE VARIABLE ':u ENTRY(1,qbf-rcn[qbf_i]).

    PUT UNFORMATTED
      ' AS ':u
      ENTRY(IF qbf_i > qbf-rc# THEN p_type ELSE qbf-rct[qbf_i],
            "CHARACTER,DATE     ,LOGICAL  ,DECIMAL  ,DECIMAL  ":u)
      ' NO-UNDO.':u SKIP.
  END.
END.
PUT UNFORMATTED
  'DEFINE VARIABLE qbf-day-names   AS CHARACTER NO-UNDO.':u SKIP
  'DEFINE VARIABLE qbf-month-names AS CHARACTER NO-UNDO.':u SKIP(1).

/* new calculated field */
IF p_ix > 0 AND p_ix > qbf-rc# THEN
  PUT UNFORMATTED
    'qbf-':u STRING(p_ix,"999":u) ' = ':u p_exp '.':u SKIP.

/* existing calculated field */
ELSE
IF p_ix > 0 AND p_ix <= qbf-rc# THEN
  PUT UNFORMATTED
    ENTRY(1,qbf-rcn[p_ix]) ' = ':u p_exp '.':u SKIP.
ELSE
  PUT UNFORMATTED
    p_exp SKIP.

OUTPUT CLOSE.
HIDE MESSAGE NO-PAUSE.
DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
  IF p_xref THEN
    COMPILE "qbf_tc.p":u XREF "qbf_tc.d":u.
  ELSE
    COMPILE "qbf_tc.p":u.
END.
p_ok = (COMPILER:ERROR = FALSE).

/*------------------------------------------------------------*/

/* alias_to_tbname (for defbufs.i) */
{ aderes/s-alias.i }

/* _scompil.p - end of file */

