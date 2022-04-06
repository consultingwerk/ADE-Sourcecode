/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* s-quoter.p - run quoter on <qbf-i>, producing <qbf-o> */

DEFINE INPUT PARAMETER qbf-i AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER qbf-o AS CHARACTER NO-UNDO.

/* JEP WIN32 7/11/97 3:55PM */
CASE OPSYS:

    WHEN "MSDOS":u OR WHEN "WIN32":u OR WHEN "UNIX":u OR WHEN "OS2":u THEN
        OS-COMMAND SILENT quoter VALUE(qbf-i) > VALUE(qbf-o).

    WHEN "VMS":u THEN
        VMS SILENT PROGRESS/TOOLS=QUOTER/OUTPUT= VALUE(qbf-o) VALUE(qbf-i).

    WHEN "BTOS":u THEN
      BTOS OS-QUOTER VALUE(qbf-i) VALUE(qbf-o).
      /*BTOS SILENT "[Sys]<Dlc>Quoter.Run" Quoter VALUE(qbf-i) > VALUE(qbf-o).*/

END CASE.

RETURN.

/* s-quoter.p - end of file */

