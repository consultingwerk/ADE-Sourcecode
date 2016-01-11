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
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
