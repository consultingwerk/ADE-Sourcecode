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
 * aderes/u-cprint.p  (user-controlchar-print)
 *
 * This procedure sends the output of the current query to the designated
 * printer. The caller also supplies the control characters to be sent
 * to the printer *before* the RESULTS output.
 *
 * This file is needed by the TTY-to-GUI Converter for those V6 RESULTS
 * applications that have the need to set printer characteristics before
 * sending the output.
 *
 * Input Parameters
 *
 *    arg    A character string holding the destination for the output of
 *           the RESULTS query followed by the printer characteristics.
 *           For example: "lpr,14,15". The procedure will convert "14" and
 *           "15" to ascii codes and put them in the stream for the
 *           printer "lpr"
 *
 *  Output Parameter
 *
 *    qbf-s  True if Results should repaint the user interface.
 */

DEFINE INPUT  PARAMETER arg    AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER qbf-s  AS LOGICAL   NO-UNDO.

{ aderes/u-pvars.i }

DEFINE VARIABLE f-name      AS CHARACTER NO-UNDO.
DEFINE VARIABLE apArgs      AS CHARACTER NO-UNDO.
DEFINE VARIABLE retState    AS LOGICAL   NO-UNDO.
DEFINE VARIABLE qbf-i       AS INTEGER   NO-UNDO.
DEFINE VARIABLE controlChar AS INTEGER   NO-UNDO.

/* Set the cursor to the wait state, in case the printing takes alot of time. */
RUN adecomm/_setcurs.p ("WAIT":u).
RUN adecomm/_tmpfile.p ("res":U, ".tmp":U, OUTPUT f-name).

/* Put the current state of the query into a .p file */
apArgs = f-name + ",":u + qbf-module.

RUN aderes/sffire.p ("AdminProgWrite4GL":u, apArgs, OUTPUT retState).

/* Start the output.  */
OUTPUT TO VALUE(ENTRY(1, arg)).

/*
* The control chars start after the file name in the second entry
* of the argument list.
*/
DO qbf-i = 2 TO NUM-ENTRIES(arg):

  IF ENTRY(qbf-i, arg) = "" THEN NEXT.

  controlChar = INTEGER(ENTRY(qbf-i, arg)).

  IF controlChar = 0 THEN
    PUT CONTROL NULL.
  ELSE
    PUT CONTROL CHR(controlChar).
END.

RUN VALUE(f-name).

OUTPUT CLOSE.

OS-DELETE VALUE(f-name).

RUN adecomm/_setcurs.p ("").

/* u-cprint.p - end of file */

