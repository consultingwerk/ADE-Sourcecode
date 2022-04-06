/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _find-db.p

Description:
    If a user builds a query with one db, but wants to load it using a different
    database, but with the same tables this lets him do it. (sort of )
    Scan all connected database (listed in valid-dbs)looking for the first one
    that has a table named tbl-nm.  Then output db-switches which is a list
    of databases that can be substituted.

Input Parameters:
   tbl-nm      - The name of the table we are looking for.
   valid-dbs   - A list of valid connected databases
   
INPUT-OUTPUT Parameters:
   db-switch   - A CHR(4) delimitted list of database pairs that can be switched.

Output Parameters:
   <None>

Author: D. Ross Hunter


Date Created:  1997

---------------------------------------------------------------------------- */
DEFINE INPUT        PARAMETER tbl-nm    AS  CHARACTER                     NO-UNDO.
DEFINE INPUT        PARAMETER valid-dbs AS  CHARACTER                     NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER db-switch AS  CHARACTER                     NO-UNDO.

DEFINE         VARIABLE  i             AS  INTEGER                        NO-UNDO.
DEFINE         VARIABLE  tmp-switch    AS  CHARACTER                      NO-UNDO.
  
DO i = 1 TO NUM-ENTRIES(valid-dbs):
  FIND FIRST DICTDB._DB NO-LOCK WHERE
             DICTDB._DB._DB-NAME = ENTRY(i,valid-dbs) NO-ERROR.
  IF NOT AVAILABLE DICTDB._DB THEN FIND FIRST DICTDB._DB NO-LOCK NO-ERROR.
  IF AVAILABLE DICTDB._DB THEN DO:
    IF CAN-FIND(FIRST _FILE OF DICTDB._DB
                WHERE _FILE._FILE-NAME = ENTRY(2,tbl-nm,".":U))
    THEN DO:
      tmp-switch = ENTRY(1,tbl-nm,".":U) + CHR(4) +
                   IF DICTDB._DB._DB-NAME NE ? THEN
                      DICTDB._DB._DB-NAME ELSE ENTRY(i,valid-dbs).
                   IF NOT CAN-DO(tmp-switch,db-switch) THEN
                      db-switch = db-switch +
                                  (IF db-switch eq "" THEN "" ELSE ",":U) +
                                   tmp-switch.
    END. /* We have found a DB with this table in it */
  END. /* We have a DICTDB._DB record */
END. /* looking through the valid-dbs */
