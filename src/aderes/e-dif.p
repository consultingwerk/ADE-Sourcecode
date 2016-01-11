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

/* e-dif.p - program to dump data in 'dif' format */

{ aderes/s-define.i }
{ aderes/e-define.i }
{ aderes/j-define.i }

/* dump dates as numbers?  Lotus 1-2-3 uses 12/30/1899 as base date. */

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
    IF qbf-b THEN DO:
      {&FIND_TABLE_BY_ID} INTEGER(ENTRY(1,qbf-tables)).
      PUT UNFORMATTED
        qbf-m 'DEFINE VARIABLE qbf-a AS CHARACTER NO-UNDO.':u SKIP
        qbf-m 'DEFINE VARIABLE qbf-d AS INTEGER   NO-UNDO.':u SKIP
        qbf-m 'DEFINE VARIABLE qbf-e AS INTEGER   NO-UNDO.':u SKIP
        qbf-m 'DEFINE VARIABLE qbf-l AS DECIMAL   NO-UNDO.':u SKIP
        qbf-m 'DEFINE VARIABLE qbf-p AS INTEGER   NO-UNDO.':u SKIP(1)
        qbf-m 'PUT UNFORMATTED':u SKIP
        qbf-m '  "TABLE"   SKIP "0,1" SKIP """" "':u
      	  qbf-rel-buf.tname
          '" """" SKIP':u SKIP
        qbf-m '  "VECTORS" SKIP "0,':u qbf-rc# '" SKIP """""" SKIP':u SKIP
        qbf-m '  "TUPLES"  SKIP "0," qbf-count':u
          (IF qbf-esys.qbf-headers THEN ' + 1':u ELSE '')
          ' SKIP """""" SKIP':u SKIP
        qbf-m '  "DATA"    SKIP "0,0" SKIP """""" SKIP':u.
    END.
    IF qbf-b AND qbf-esys.qbf-headers THEN
      PUT UNFORMATTED SKIP(1)
        qbf-m '  "-1,0" SKIP "BOT" SKIP'.
    IF qbf-esys.qbf-headers THEN
      PUT UNFORMATTED SKIP
        qbf-m '  "1,0" SKIP """':u qbf-l '""" SKIP':u.
    IF qbf-e AND qbf-esys.qbf-headers THEN
      PUT UNFORMATTED SKIP
        qbf-m '  "E" SKIP':u.
    IF qbf-e THEN
      PUT UNFORMATTED '.':u SKIP(1).
  END.
  WHEN "b":u THEN DO:
    IF qbf-b THEN
      PUT UNFORMATTED
        qbf-m 'PUT UNFORMATTED "-1,0" SKIP "BOT" SKIP.':u SKIP.
    IF qbf-t = 2 AND qbf-esys.qbf-base <> ? THEN qbf-t = - 2.
    CASE qbf-t:
      WHEN 1 /*char*/ THEN
        PUT UNFORMATTED
          qbf-m 'qbf-a = (IF ':u qbf-n
            ' = ? THEN "NA" ELSE """" + ':u qbf-n ' + """").':u SKIP
          qbf-m 'PUT UNFORMATTED "1,0" SKIP qbf-a SKIP.':u SKIP.
      WHEN 2 /*date - as string*/ THEN
        PUT UNFORMATTED
          qbf-m 'qbf-a = (IF ':u qbf-n
            ' = ? THEN "NA" ELSE """" + STRING(':u qbf-n ') + """").':u SKIP
          qbf-m 'PUT UNFORMATTED "1,0" SKIP qbf-a SKIP.':u SKIP.
      WHEN -2 /*date - as number*/ THEN
        PUT UNFORMATTED
          qbf-m 'IF ':u qbf-n ' = ? THEN':u                            SKIP
          qbf-m '  qbf-a = "NA".':u                                    SKIP
          qbf-m 'ELSE IF ':u qbf-n ' = ':u qbf-esys.qbf-base ' THEN':u SKIP
          qbf-m '  qbf-a = "0.0E+01".':u                               SKIP
          qbf-m 'ELSE':u                                               SKIP
          qbf-m '  ASSIGN':u                                           SKIP
          qbf-m '    qbf-d = ':u qbf-n ' - ':u qbf-esys.qbf-base       SKIP
          qbf-m '    qbf-l = ABSOLUTE(qbf-d)':u                        SKIP
          qbf-m '    qbf-a = STRING(qbf-l)':u                          SKIP
          qbf-m '    qbf-p = INDEX(qbf-a + ".",".")':u                 SKIP
          qbf-m '    SUBSTRING(qbf-a,qbf-p,1,"CHARACTER":u) = ""':u    SKIP
          qbf-m '    qbf-l = LOG(qbf-l,10)':u                          SKIP
          qbf-m '    qbf-e = TRUNCATE(IF qbf-l < 0 THEN ':u
            'qbf-l - 0.9999999999 ELSE qbf-l,0)':u                     SKIP
          qbf-m '    qbf-a = (IF qbf-d < 0 THEN "-" ELSE "")':u        SKIP
          qbf-m '          + SUBSTRING(qbf-a,qbf-p - 1 - qbf-e,1,"CHARACTER":u)':u   SKIP
          qbf-m '          + "."':u                                    SKIP
          qbf-m '          + SUBSTRING(qbf-a,qbf-p - qbf-e,-1,"CHARACTER":u)':u         SKIP
          qbf-m '          + "0E" + STRING(qbf-e,"+99").':u            SKIP
          qbf-m 'PUT UNFORMATTED "0," qbf-a SKIP "V" SKIP.':u          SKIP.
      WHEN 3 /*log*/ THEN
        PUT UNFORMATTED
          qbf-m 'qbf-a = (IF ':u qbf-n
            ' THEN "TRUE" ELSE IF NOT ':u qbf-n
            ' THEN "FALSE" ELSE "NA").':u
          qbf-m 'PUT UNFORMATTED "1,0" SKIP qbf-a SKIP.':u SKIP.
      WHEN 4 /*int*/ THEN
        PUT UNFORMATTED
          qbf-m 'qbf-a = (IF ':u qbf-n
            ' = ? THEN "NA" ELSE STRING(':u qbf-n ')).':u SKIP
          qbf-m 'PUT UNFORMATTED "0," qbf-a SKIP "V" SKIP.':u SKIP.
      WHEN 5 /*dec*/ THEN
        PUT UNFORMATTED
          qbf-m 'IF ':u qbf-n ' = ? THEN':u                           SKIP
          qbf-m '  qbf-a = "NA".':u                                   SKIP
          qbf-m 'ELSE IF ':u qbf-n ' = 0 THEN':u                      SKIP
          qbf-m '  qbf-a = "0.0E+01".':u                              SKIP
          qbf-m 'ELSE':u                                              SKIP
          qbf-m '  ASSIGN':u                                          SKIP
          qbf-m '    qbf-l = ABSOLUTE(':u qbf-n ')':u                 SKIP
          qbf-m '    qbf-a = STRING(qbf-l)':u                         SKIP
          qbf-m '    qbf-p = INDEX(qbf-a + ".",".")':u                SKIP
          qbf-m '    SUBSTRING(qbf-a,qbf-p,1,"CHARACTER":u) = ""':u   SKIP
          qbf-m '    qbf-l = LOG(qbf-l,10)':u                         SKIP
          qbf-m '    qbf-e = TRUNCATE(IF qbf-l < 0 THEN ':u
            'qbf-l - 0.9999999999 ELSE qbf-l,0)':u                    SKIP
          qbf-m '    qbf-a = (IF ':u qbf-n ' < 0 THEN "-" ELSE "")':u SKIP
          qbf-m '          + SUBSTRING(qbf-a,qbf-p - 1 - qbf-e,1,"CHARACTER":u)':u  SKIP
          qbf-m '          + "."':u                                   SKIP
          qbf-m '          + SUBSTRING(qbf-a,qbf-p - qbf-e,-1,"CHARACTER":u)':u        SKIP
          qbf-m '          + "0E" + STRING(qbf-e,"+99").':u           SKIP
          qbf-m 'PUT UNFORMATTED "0," qbf-a SKIP "V" SKIP.':u         SKIP.
    END CASE.
    IF qbf-e THEN
      PUT UNFORMATTED qbf-m 'PUT UNFORMATTED "E" SKIP.':u SKIP.
  END.
  WHEN "e":u THEN DO:
    IF qbf-b THEN
      PUT UNFORMATTED
        qbf-m 'PUT UNFORMATTED "-1,0" SKIP "EOD" SKIP.':u SKIP(1).
  END.
END CASE.

RETURN.

/* e-dif.p - end of file */

