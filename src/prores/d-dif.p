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
/* d-dif.p - program to dump data in 'dif' format */

{ prores/s-system.i }
{ prores/s-define.i }

DEFINE VARIABLE qbf-c AS CHARACTER           NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER             NO-UNDO.
DEFINE VARIABLE qbf-j AS INTEGER             NO-UNDO.

DEFINE VARIABLE qbf-b AS CHARACTER           NO-UNDO.
DEFINE VARIABLE qbf-e AS INTEGER   INITIAL 0 NO-UNDO.
DEFINE VARIABLE qbf-k AS INTEGER             NO-UNDO.
DEFINE VARIABLE qbf-m AS CHARACTER EXTENT  5 NO-UNDO.

DEFINE SHARED STREAM qbf-io.

PUT STREAM qbf-io UNFORMATTED
  'DEFINE VARIABLE qbf-a AS CHARACTER NO-UNDO.' SKIP
  'DEFINE VARIABLE qbf-e AS INTEGER   NO-UNDO.' SKIP
  'DEFINE VARIABLE qbf-l AS DECIMAL   NO-UNDO.' SKIP
  'DEFINE VARIABLE qbf-p AS INTEGER   NO-UNDO.' SKIP.

/* write out initialization stuff for calc fields */
{ prores/s-gen1.i }

/* write out prepass code & get qbf-total - needed later */
{ prores/s-gen3.i &count=TRUE }

qbf-c = "".
DO qbf-i = 1 TO 5 WHILE qbf-file[qbf-i] <> "":
  qbf-c = qbf-c + (IF qbf-i = 1 THEN "" ELSE "+")
        + qbf-db[qbf-i] + "." + qbf-file[qbf-i].
END.

PUT STREAM qbf-io UNFORMATTED
  'PUT UNFORMATTED "TABLE" SKIP' SKIP
  '  "0,1" SKIP'                 SKIP
  '  """" "' qbf-c '" """" SKIP' SKIP /*file-name*/
  '  "VECTORS" SKIP'             SKIP
  '  "0,' qbf-rc# '" SKIP'       SKIP /*count chosen*/
  '  """""" SKIP'                SKIP
  '  "TUPLES" SKIP'              SKIP
  '  "0," qbf-total SKIP'        SKIP
  '  """""" SKIP'                SKIP
  '  "DATA" SKIP'                SKIP
  '  "0,0" SKIP'                 SKIP
  '  """""" SKIP.'               SKIP(1).

/* for each with wheres and break-bys */
{ prores/s-gen2.i &by=TRUE &total="qbf-total = 1 TO qbf-total + 1" }

/* calc field code for main loop */
{ prores/s-gen4.i }

PUT STREAM qbf-io UNFORMATTED
  '  PUT UNFORMATTED "-1,0" SKIP "BOT" SKIP.' SKIP.

DO qbf-i = 1 TO qbf-rc#:
  IF qbf-rcc[qbf-i] BEGINS "e" THEN NEXT.
  qbf-c = ENTRY(1,qbf-rcn[qbf-i]).
  IF qbf-rct[qbf-i] = 1 /*char*/ OR qbf-rct[qbf-i] = 2 /*date*/ THEN
    PUT STREAM qbf-io UNFORMATTED
      '  PUT UNFORMATTED "1,0" SKIP """" ' qbf-c ' """" SKIP.' SKIP.
  ELSE
  IF qbf-rct[qbf-i] = 4 /*int*/ THEN
    PUT STREAM qbf-io UNFORMATTED
      '  PUT UNFORMATTED "0," ' qbf-c ' SKIP "V" SKIP.' SKIP.
  ELSE IF qbf-rct[qbf-i] = 5 /*dec*/ THEN
    PUT STREAM qbf-io UNFORMATTED
      'IF ' qbf-c ' = 0 THEN' SKIP
      '  qbf-a = "0.0E+01".' SKIP
      'ELSE' SKIP
      '  ASSIGN' SKIP
      '    qbf-l = (IF ' qbf-c ' < 0' SKIP /* My kingdom for  */
      '            THEN - ' qbf-c     SKIP /* an absolute     */
      '            ELSE '   qbf-c ')' SKIP /* value function! */
      '    qbf-a = STRING(qbf-l)' SKIP
      '    qbf-p = INDEX(qbf-a + ".",".")' SKIP
      '    SUBSTRING(qbf-a,qbf-p,1) = ""' SKIP
      '    qbf-l = LOG(qbf-l,10)' SKIP
      '    qbf-e = TRUNCATE(IF qbf-l < 0 THEN qbf-l - 0.9999999999'
        ' ELSE qbf-l,0)' SKIP
      '    qbf-a = (IF ' qbf-c ' < 0 THEN "-" ELSE "")' SKIP
      '          + SUBSTRING(qbf-a,qbf-p - 1 - qbf-e,1) + "."' SKIP
      '          + SUBSTRING(qbf-a,qbf-p - qbf-e)' SKIP
      '          + "0E" + STRING(qbf-e,"+99").' SKIP
      '  PUT UNFORMATTED "0," qbf-a SKIP "V" SKIP.' SKIP.
  ELSE IF qbf-rct[qbf-i] = 3 /*log*/ THEN
    PUT STREAM qbf-io UNFORMATTED
      '  qbf-a = (IF ' qbf-c
        ' THEN "TRUE" ELSE IF NOT ' qbf-c
        ' THEN "FALSE" ELSE "NA").'
      '  PUT UNFORMATTED "1,0" SKIP qbf-a SKIP.' SKIP.
END.

PUT STREAM qbf-io UNFORMATTED
  'END.' SKIP
  'PUT UNFORMATTED "-1,0" SKIP "EOD" SKIP.' SKIP
  'RETURN.' SKIP.

RETURN.
