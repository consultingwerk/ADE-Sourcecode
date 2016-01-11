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

