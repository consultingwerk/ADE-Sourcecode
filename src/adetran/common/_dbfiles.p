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
/*------------------------------------------------------------------------

  File: _dbfiles.p
  Description: By using the _dbutil prostrct list <dbname> foo
    we return a list of files related to this database.
  Input Parameters:
      pDBFile = database name (no extension)
  Output Parameters:
      pFiles  = list of files related to this database. CHR(3) is the separator character
  Author: SLK
  Created: August 1998
  Modified:
------------------------------------------------------------------------ */
DEFINE INPUT  PARAMETER pDBFile AS CHARACTER                        NO-UNDO.
DEFINE OUTPUT PARAMETER pFiles  AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE cTmpFile        AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE cDBFile         AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE cProcessFile    AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE lAction         AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE cInputLine      AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE cLookFor        AS CHARACTER INITIAL ", Name: "     NO-UNDO.
DEFINE VARIABLE cFileName       AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE iLoc            AS INTEGER                          NO-UNDO.
DEFINE VARIABLE cDBFileNoExt    AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE cDbutil         AS CHARACTER                        NO-UNDO.

DEFINE STREAM sInStream.

RUN adecomm/_tmpfile.p (INPUT "":U,
                        INPUT ".tmp",
                        OUTPUT cTmpFile).
RUN adecomm/_tmpfile.p (INPUT "":U,
                        INPUT ".str",
                        OUTPUT cProcessFile).

GET-KEY-VALUE SECTION "Startup" KEY "DLC" VALUE cDbutil.
ASSIGN cDbutil = cDbutil + '\bin\_dbutil.exe'.
IF SEARCH(cDbutil) = ? THEN 
    MESSAGE "%DLC%\bin\_dbutil not found; the database cannot be deleted":U.
ASSIGN   
   cDBFileNoExt = ENTRY(1, pDBFile, ".")
   lAction = '"' + cdbutil + '"' + ' prostrct list ' + cDBFileNoExt
   + ' ':U + cTmpFile + ' >> ':U + cProcessFile.
IF FILE-INFO:FULL-PATHNAME <> ? THEN
   OS-COMMAND SILENT VALUE(lAction).
IF SEARCH(cProcessFile) <> ? THEN
DO:
   INPUT STREAM sInStream FROM VALUE(cProcessFile) NO-ECHO.
   REPEAT:
      IMPORT STREAM sInStream UNFORMATTED cInputLine.
      ASSIGN iLoc = INDEX(cInputLine,cLookFor).
      IF iLoc <> 0 THEN
      DO:
         ASSIGN cDBFile = TRIM(SUBSTRING(cInputLine,iLoc + LENGTH(cLookFor))).
         ASSIGN pFiles = IF pFiles = "":U THEN cDBFile
                         ELSE pFiles + CHR(3) + cDBFile.
      END. /* Found NAME: */
   END. /* repeat */
   /* Include also log,structure and backup files */
   ASSIGN pFiles = IF pFiles = "":U THEN cDBFileNoExt + ".lg"
                   ELSE pFiles + CHR(3) + cDBFileNoExt + ".lg".
   ASSIGN pFiles = IF pFiles = "":U THEN cDBFileNoExt + ".st"
                   ELSE pFiles + CHR(3) + cDBFileNoExt + ".st".
   ASSIGN pFiles = IF pFiles = "":U THEN cDBFileNoExt + ".bku"
                   ELSE pFiles + CHR(3) + cDBFileNoExt + ".bku".
END. /* found the result file */

/* delete all the temporary files */
FILE-INFO:FILE-NAME = cTmpFile.
IF FILE-INFO:FULL-PATHNAME <> ? THEN
  OS-DELETE VALUE(FILE-INFO:FULL-PATHNAME).
FILE-INFO:FILE-NAME = cProcessFile.
IF FILE-INFO:FULL-PATHNAME <> ? THEN
  OS-DELETE VALUE(FILE-INFO:FULL-PATHNAME).

/* EOF */
