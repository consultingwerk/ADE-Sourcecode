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
/*----------------------------------------------------------------------------

File: _chkpp.i

Description:
   Contains the Chk_PP procedure that determines whether any databases
   are in use when either the admin tool or the dictionary tool are used.

Author: Bruce Gruenbaum

Date Created: 05/17/2000

----------------------------------------------------------------------------*/

PROCEDURE Chk_PPs:
  /* Finds all persistent procedures and generates a list of databases which they
   * use. The user gets a warning message stating that if they modify the schema
   * of any of these database, PROGRESS will restart and all unsaved work will
   * be lost.
   */
  DEFINE VARIABLE h          AS HANDLE    NO-UNDO. /* procedure handle */
  DEFINE VARIABLE dbentry    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE run_dblist AS CHARACTER NO-UNDO. /* list of databases */
  DEFINE VARIABLE i          AS INTEGER   NO-UNDO.
  
  ASSIGN h  = SESSION:FIRST-PROCEDURE.
  DO WHILE VALID-HANDLE(h):
    IF NOT (h:FILE-NAME BEGINS "adetran") THEN 
    DO i = 1 TO NUM-ENTRIES(h:DB-REFERENCES):
      ASSIGN dbentry = ENTRY(i,h:DB-REFERENCES).
      IF dbentry NE "PROGRESST":U AND
         LOOKUP(dbentry, run_dblist) = 0 THEN
        ASSIGN run_dblist = run_dblist + (IF run_dblist NE "" THEN "," + dbentry ELSE dbentry).
    END.
    h = h:NEXT-SIBLING.
  END.
  IF run_dblist NE "" THEN
    MESSAGE "The following database" + (IF NUM-ENTRIES(run_dblist) > 1 THEN "s are" ELSE " is") + 
            " currently in use by running procedures:" skip(1)
            run_dblist skip(1)
            "Making schema changes to" + 
            (IF NUM-ENTRIES(run_dblist) > 1 THEN " any of these databases" ELSE " this database") +
            " at this time will" {&SKP}
            "cause PROGRESS to initiate a session restart causing all" {&SKP}
            "unsaved work to be lost."
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
END PROCEDURE.
