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

/*--------------------------------------------------------------------

File: adecomm/_getdbs.p

Description:
    
    creates s_ttb_db-records for all connected physical PROGRESS-Dbs
    and all auto-connect records.
            
Input-Parameters:
    none

Output-Parameters:
    none
    
Used/Modified Shared Objects:
    s_ttb_db    Temp-Table containing a record for EACH AND EVERY
                available DB


Author: Tom Hutegger

History:
    hutegger    95/06   creation
    hutegger    95/08   added dbrcd, empty and dspnm fields

                            
--------------------------------------------------------------------*/
/*h-*/

/*----------------------------  DEFINES  ---------------------------*/

{ prodict/dictvar.i NEW }

define         variable     l_curr-db as integer init 1.
define         variable     l_dbnr    as integer.

{ adecomm/getdbs.i }

/*------------------------  INT.-PROCEDURES  -----------------------*/

/*---------------------------  MAIN-CODE  --------------------------*/


/* determine current DICTDB */

repeat l_dbnr = 1 to NUM-DBS:
  if LDBNAME("DICTDB") = LDBNAME(l_dbnr)
   then assign l_curr-db = l_dbnr.
  end.


/* generate temp-table records for all available dbs */

repeat l_dbnr = 1 to NUM-DBS:

if DBTYPE(l_dbnr) <> "PROGRESS" then next.  /* SchemaHolders later */

  run adecomm/_setalia.p
    ( INPUT l_dbnr
    ).

  run adecomm/_getpdbs.p
    ( INPUT l_dbnr
    ).

  end.


/* reset DICTDB to the db it pointed when we came in, or delete it */

if LDBNAME(l_curr-db) = ?
 then delete alias DICTDB.
 else run adecomm/_setalia.p
        ( INPUT l_curr-db
        ).

/*------------------------------------------------------------------*/
