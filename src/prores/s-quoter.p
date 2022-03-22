/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
