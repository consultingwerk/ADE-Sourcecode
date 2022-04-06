/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------

File: adecomm/_getpdbs.p

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


Author: Laurie Furgal

History:
    laurief    97/04   creation

--------------------------------------------------------------------*/
/*h-*/

/*----------------------------  DEFINES  ---------------------------*/

{ adecomm/getdbs.i }

define INPUT PARAMETER        t_db-num    as integer.

/*------------------------  INT.-PROCEDURES  -----------------------*/

/*---------------------------  MAIN-CODE  --------------------------*/


  find first DICTDB._Db NO-LOCK
   where DICTDB._Db._Db-name = ?.
  find first DICTDB._File of DICTDB._Db
    where DICTDB._File._File-num > 0
    no-lock no-error.

  create s_ttb_db.
  assign
    s_ttb_db.cnnctd = TRUE
    s_ttb_db.dbnr   = t_db-num * 2
    s_ttb_db.dbrcd  = RECID(DICTDB._Db)
    s_ttb_db.dbtyp  = "PROGRESS"
    s_ttb_db.dspnm  = LDBNAME(t_db-num)
    s_ttb_db.empty  = NOT available DICTDB._File
    s_ttb_db.ldbnm  = LDBNAME(t_db-num)
    s_ttb_db.local  = yes
    s_ttb_db.pdbnm  = PDBNAME(t_db-num)
    s_ttb_db.sdbnm  = LDBNAME(t_db-num)
    s_ttb_db.vrsn   = DBVERSION(t_db-num).

  run adecomm/_getfdbs.p
    ( INPUT t_db-num * 2 + 1,
      INPUT s_ttb_db.ldbnm,
      INPUT s_ttb_db.vrsn
    ).
