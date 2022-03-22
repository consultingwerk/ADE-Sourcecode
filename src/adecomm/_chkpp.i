/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
