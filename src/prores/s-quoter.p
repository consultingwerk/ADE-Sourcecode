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
/* s-quoter.p - run quoter on <qbf-i>, producing <qbf-o> */

DEFINE INPUT PARAMETER qbf-i AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER qbf-o AS CHARACTER NO-UNDO.


OS-DELETE VALUE(qbf-o) NO-ERROR.

IF OPSYS = "MSDOS" THEN
  DOS SILENT quoter VALUE(qbf-i) > VALUE(qbf-o).

ELSE IF OPSYS = "OS2" THEN
  OS2 SILENT quoter VALUE(qbf-i) > VALUE(qbf-o).

ELSE IF OPSYS = "UNIX" THEN
  UNIX SILENT quoter VALUE(qbf-i) > VALUE(qbf-o).

ELSE IF OPSYS = "VMS" THEN
  VMS SILENT PROGRESS/TOOLS=QUOTER/OUTPUT= VALUE(qbf-o) VALUE(qbf-i).

ELSE IF OPSYS = "BTOS" THEN
  BTOS OS-QUOTER VALUE(qbf-i) VALUE(qbf-o).
  /*BTOS SILENT "[Sys]<Dlc>Quoter.Run" Quoter VALUE(qbf-i) > VALUE(qbf-o).*/

RETURN.
