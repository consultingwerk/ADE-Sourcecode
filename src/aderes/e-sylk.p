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

/* e-sylk.p - program to dump data in 'sylk' format */

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

CASE qbf-s:
  WHEN "p":u THEN DO:
    IF qbf-b AND qbf-esys.qbf-headers THEN
      PUT UNFORMATTED
        qbf-m 'qbf-count = qbf-count + 1.' SKIP.
    IF qbf-b THEN
      PUT UNFORMATTED
        qbf-m 'PUT UNFORMATTED':u SKIP qbf-m '  "ID~;PROGRESS" SKIP':u.
    IF qbf-esys.qbf-headers THEN
      PUT UNFORMATTED SKIP
        qbf-m '  "C~;Y1~;X':u qbf-p '~;K':u '""':u qbf-l '""" SKIP':u.
    IF qbf-e THEN
      PUT UNFORMATTED '.':u SKIP(1).
  END.
  WHEN "b":u THEN DO:
    IF lkup THEN
      qbf-n = '(IF ':u + qbf-n + ' <> ? THEN STRING(':u + qbf-n +
      	      ') ELSE "':u + 
      	      (IF qbf-t > 2 THEN '""':u ELSE "":u) +
      	      nm-val +
      	      (IF qbf-t > 2 THEN '""':u ELSE "":u) +
      	      '")':u.
    PUT UNFORMATTED
      qbf-m 'PUT UNFORMATTED':u SKIP 
      qbf-m '  "C~;Y" qbf-count "~;X':u qbf-p '~;K" ':u.

    IF lkup THEN
      PUT UNFORMATTED SKIP qbf-m '  ':u.

    IF qbf-t = 1 /*char*/ OR qbf-t = 2 /*date*/ THEN
      PUT UNFORMATTED '"""" ':u qbf-n ' """"':u.
    ELSE
      PUT UNFORMATTED qbf-n.

    PUT UNFORMATTED ' SKIP.':u SKIP.
  END.
  WHEN "e":u THEN DO:
    IF qbf-b THEN
      PUT UNFORMATTED qbf-m 'PUT UNFORMATTED "E" SKIP.':u SKIP(1).
  END.
END CASE.

RETURN.

/* e-sylk.p - end of file */

