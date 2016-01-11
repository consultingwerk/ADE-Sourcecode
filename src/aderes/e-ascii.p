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

/* e-ascii.p - program to dump data in various 'ascii' formats */

{ aderes/e-define.i }

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

FIND FIRST qbf-esys.

DEFINE VARIABLE qbf-c AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO. /* format width */
DEFINE VARIABLE qbf-j AS CHARACTER NO-UNDO. /* fixed-width justification */

/*
qbf-esys.qbf-code[1] -> qbf-esys.qbf-lin-beg - line starter
qbf-esys.qbf-code[2] -> qbf-esys.qbf-lin-end - line delimiter
qbf-esys.qbf-code[3] -> qbf-esys.qbf-fld-dlm - field delimiter
qbf-esys.qbf-code[4] -> qbf-esys.qbf-fld-sep - field separator
*/

CASE qbf-s:
  WHEN "p":u THEN DO: /*----------------------------------------------------*/
    IF qbf-esys.qbf-headers THEN DO:
      IF qbf-b THEN
        PUT UNFORMATTED qbf-m 'PUT CONTROL':u.
      IF qbf-b AND qbf-esys.qbf-code[1] <> "" THEN
        PUT UNFORMATTED SKIP qbf-m '  ':u qbf-esys.qbf-code[1].

      ASSIGN qbf-i = {aderes/s-size.i &type=1 &format=qbf-f} NO-ERROR.
      ASSIGN
        qbf-l = (IF qbf-esys.qbf-fixed AND LENGTH(qbf-l,"RAW":u) > qbf-i THEN
                  SUBSTRING(qbf-l,1,qbf-i,"RAW":u)
                ELSE IF qbf-esys.qbf-fixed THEN
                  qbf-l + FILL(' ':u,qbf-i - LENGTH(qbf-l,"RAW":u))
                ELSE
                  qbf-l
                ).

      PUT UNFORMATTED SKIP qbf-m '  ':u.

      IF qbf-esys.qbf-code[3] <> ""
        AND (qbf-esys.qbf-dlm-typ = "*":u
          OR INDEX(qbf-esys.qbf-dlm-typ,"1":u) > 0) THEN
        PUT UNFORMATTED qbf-esys.qbf-code[3] ' ':u.

      PUT UNFORMATTED '"':u qbf-l '"':u.

      IF qbf-esys.qbf-code[3] <> ""
        AND (qbf-esys.qbf-dlm-typ = "*":u
          OR INDEX(qbf-esys.qbf-dlm-typ,"1":u) > 0) THEN
        PUT UNFORMATTED ' ':u qbf-esys.qbf-code[3].

      IF qbf-esys.qbf-code[IF qbf-e THEN 2 ELSE 4] <> "" THEN
        PUT UNFORMATTED SKIP
          qbf-m '  ':u qbf-esys.qbf-code[IF qbf-e THEN 2 ELSE 4].
      IF qbf-e THEN
        PUT UNFORMATTED '.':u SKIP(1).
    END.
  END.
  WHEN "b":u THEN DO: /*----------------------------------------------------*/
    IF qbf-b THEN
      PUT UNFORMATTED qbf-m 'PUT CONTROL':u.
    IF qbf-b AND qbf-esys.qbf-code[1] <> "" THEN
      PUT UNFORMATTED SKIP qbf-m '  ':u qbf-esys.qbf-code[1].

    ASSIGN qbf-i = {aderes/s-size.i &type=qbf-t &format=qbf-f} NO-ERROR.
    qbf-j = FILL(' ':u,qbf-i - 1).

    PUT UNFORMATTED SKIP qbf-m '  ':u.

    IF qbf-esys.qbf-code[3] <> ""
      AND (qbf-esys.qbf-dlm-typ = "*":u
        OR INDEX(qbf-esys.qbf-dlm-typ,STRING(qbf-t)) > 0) THEN
      PUT UNFORMATTED qbf-esys.qbf-code[3] ' ':u.

    qbf-f = '"':u + REPLACE(qbf-f,"~~":u,"~~~~":u) + '"':u.
    PUT UNFORMATTED
      (IF qbf-esys.qbf-fixed THEN
        IF lkup THEN
          '(IF ':u + qbf-n + ' = ? THEN STRING("':u + nm-val + 
      	    '","X(':u + STRING(qbf-i) + ')") ELSE STRING(':u
      	ELSE
          '(IF ':u + qbf-n + ' = ? THEN "?':u + qbf-j + '" ELSE STRING(':u
      ELSE /* not fixed */
        IF lkup THEN
          '(IF ':u + qbf-n + ' = ? THEN "':u + nm-val + '" ELSE STRING(':u
        ELSE
          ''
      )
      qbf-n
      (IF qbf-esys.qbf-fixed THEN
        ',':u + qbf-f + '))':u
      ELSE
        IF lkup THEN
      	  '))':u
        ELSE
          ''
      ).

    IF qbf-esys.qbf-code[3] <> ""
      AND (qbf-esys.qbf-dlm-typ = "*":u
        OR INDEX(qbf-esys.qbf-dlm-typ,STRING(qbf-t)) > 0) THEN
      PUT UNFORMATTED ' ':u qbf-esys.qbf-code[3].

    IF qbf-esys.qbf-code[IF qbf-e THEN 2 ELSE 4] <> "" THEN
      PUT UNFORMATTED SKIP
        qbf-m '  ':u qbf-esys.qbf-code[IF qbf-e THEN 2 ELSE 4].
    IF qbf-e THEN
      PUT UNFORMATTED '.':u SKIP(1).
  END.
  WHEN "e":u THEN DO: /*----------------------------------------------------*/
    /* nothing */
  END.
END CASE.
 
RETURN.

/* e-ascii.p - end of file */

