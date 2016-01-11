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
DEFINE         VARIABLE  set-switch    AS  LOGICAL                        NO-UNDO.
DEFINE         VARIABLE  tmp-switch    AS  CHARACTER                      NO-UNDO.
  
DO i = 1 TO NUM-ENTRIES(valid-dbs):
  FIND FIRST DICTDB._DB WHERE
             DICTDB._DB._DB-NAME = ENTRY(i,valid-dbs) NO-LOCK NO-ERROR.
  IF NOT AVAILABLE DICTDB._DB THEN FIND FIRST DICTDB._DB NO-LOCK NO-ERROR.
  IF AVAILABLE DICTDB._DB THEN DO:
    IF INTEGER(DBVERSION("DICTDB":U)) > 8 THEN
      set-switch = CAN-FIND(FIRST DICTDB._FILE OF DICTDB._DB
                        WHERE LOOKUP(DICTDB._FILE._OWNER,"PUB,_FOREIGN":U) > 0 AND
                              _FILE._FILE-NAME = ENTRY(2,tbl-nm,".":U)).
    ELSE
      set-switch = CAN-FIND(FIRST _FILE OF DICTDB._DB
                        WHERE _FILE._FILE-NAME = ENTRY(2,tbl-nm,".":U)).

    IF set-switch THEN DO:
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
