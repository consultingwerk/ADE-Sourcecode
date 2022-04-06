/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*
File: prodict/send_sql.p

Description:
    UI to _snd_sql.i to allow users to send an sql-file to a foreign db
    
History:
    95/08   hutegger    created
*/
/*--------------------------------------------------------------------*/

define variable l_cmmnt-chr     as character format "xxxxx" init ?.
define variable l_db-name       as character format "x(32)".
define variable l_db-type       as character format "x(8)".
define variable l_debug         as logical   format "on/off".
define variable l_eosttmnt      as character format "xxxx".
define variable l_owner         as character format "x(32)".
define variable l_sql-file      as character format "x(32)".

form
  l_db-name     colon 20 label "DB-Name"   
  l_owner       colon 20 label "Owner"            /* only for oracle */
  l_sql-file    colon 20 label "SQL-File"
  l_cmmnt-chr   colon 20 label "Comment-Chars"
  l_eosttmnt    colon 20 label "End-Of-Statement"     /* ";" or "go" */
  l_db-type     colon 20 label "DB-Type" /* "ORACLE" or "<anything>" */
  l_debug       colon 20 label "Debugging-Mode"  /* on/off */
  with side-labels centered row 5
  frame frm_snd_sql.

update 
  l_db-name
  l_owner
  l_sql-file
  l_cmmnt-chr
  l_eosttmnt
  l_db-type
  l_debug
  with frame frm_snd_sql.

if LDBNAME("DICTDBG") = ?
 then do:
  create alias DICTDBG for database value(l_db-name) no-error.
  end.

if LDBNAME("DICTDBG") = ? then leave.

if LDBNAME("DICTDB") = ?
 then do:
  create alias DICTDB for database value(SDBNAME("DICTDBG")) no-error.
  end.

if LDBNAME("DICTDB") = ? then leave.

run prodict/gate/_snd_sql.p 
  ( INPUT l_cmmnt-chr,
    INPUT l_debug,
    INPUT l_db-name,
    INPUT l_db-type,
    INPUT l_eosttmnt,
    INPUT l_owner,
    INPUT l_sql-file
  ).

/*--------------------------------------------------------------------*/
