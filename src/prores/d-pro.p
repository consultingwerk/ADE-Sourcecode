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
/* d-pro.p - program to dump data in 'progress export' format */

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

/* write out initialization stuff for calc fields */
{ prores/s-gen1.i }

/* write out prepass code */
{ prores/s-gen3.i &count=FALSE }

/* for each with wheres and break-bys */
{ prores/s-gen2.i &by=TRUE &total="qbf-total = 1 TO qbf-total + 1" }

/* calc field code for main loop */
{ prores/s-gen4.i }

PUT STREAM qbf-io UNFORMATTED
  '  EXPORT'.

DO qbf-i = 1 TO qbf-rc#: /* count_chosen */
  IF qbf-rcc[qbf-i] BEGINS "e" THEN NEXT.
  PUT STREAM qbf-io UNFORMATTED SKIP '    ' ENTRY(1,qbf-rcn[qbf-i]).
END.

PUT STREAM qbf-io UNFORMATTED
  '.' SKIP
  'END.' SKIP
  'RETURN.' SKIP.

RETURN.
