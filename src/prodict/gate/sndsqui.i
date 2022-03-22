/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------

File: prodict/gate/sndsqui.i

Description:
    UI-wrapper to  _snd_sql.i to allow users to send an sql-file to 
    a foreign db
    

Textual-Parameters:
    &edb-type   { ORACLE | **ODBC** | SYBASE-10 | MS SQL Server }
    
History:
    96/07   kkelley     Changed field labels and added title
    95/08   hutegger    created

                            
--------------------------------------------------------------------*/
/*h-*/

/*----------------------------  DEFINES  ---------------------------*/

define variable l_cmmnt-chr     as character format "xxxxx" init ?.
define variable l_db-name       as character format "x(32)".
define variable l_db-type       as character format "x(20)".
define variable l_debug         as logical   format "on/off".
define variable l_eosttmnt      as character format "xxxx".
define variable l_owner         as character format "x(32)".
define variable l_sql-file      as character format "x(32)".

&SCOPED-DEFINE DATASERVER YES
{ prodict/user/uservar.i }
&UNDEFINE DATASERVER
{ prodict/odb/odbvar.i NEW }

                /*## UI-Part ##*/
form
  l_db-name     colon 20 label "DB Name"
    help "Logical name of Schema Image"
        &if "{&edb-type}" = "ORACLE"
            &then
  l_owner       colon 20 label "Owner" 
    help "Owner name to verify object can safely be dropped"
            &endif
  l_sql-file    colon 20 label "SQL File"
    help "Name and relative path of file containing SQL"
  l_cmmnt-chr   colon 20 label "Comment Chars"
    help "Character string put at beginning of comment-line"
        &if "{&edb-type}" = " "
            &then
  l_db-type     colon 18 label "DB Type"
    view-as radio-set horizontal radio-buttons 
    "MS SQL Server","MS SQL Server","ORACLE","ORACLE","SYBASE-10","SYBASE-10"
/*
        &elseif "{&edb-type}" = "**ODBC**"
            &then
  l_db-type     colon 18 label "DB Type"
    view-as radio-set horizontal radio-buttons 
    "MS SQL Server","MS SQL Server","SYBASE-10","SYBASE-10"
*/
            &endif
  l_debug       colon 20 label "Debugging Mode"  /* on/off */
    help "Off: only errors  On: errors plus debugging-messages"
  with side-labels centered row 5 title "Send DDL"
  frame frm_snd_sql.
                /*## UI-Part ##*/

/*------------------------  INT.-PROCEDURES  -----------------------*/

/*------------------------  INITIALIZATIONS  -----------------------*/

assign
  l_db-name  = ldbname("DICTDBG")
  l_sql-file = ""
        &if "{&edb-type}" = "**ODBC**"
            &then
  l_db-type  = entry(lookup(user_env[22],"mss,s10")
                    ,"MS SQL Server,SYBASE-10")
            &else
  l_db-type  = "{&edb-type}"
            &endif
  l_owner    = ""
  l_debug    = FALSE.

/*---------------------------  MAIN-CODE  --------------------------*/

/*--------------------------------------------------------------------*/

                /*## UI-Part ##*/
update 
  l_db-name
        &if "{&edb-type}" = "ORACLE"
            &then
  l_owner
            &endif
  l_sql-file
  l_cmmnt-chr
        &if "{&edb-type}" = " "
            &then
  l_db-type
            &endif
  l_debug
  with frame frm_snd_sql.
                /*## UI-Part ##*/

case l_db-type:
  when "MS SQL Server" then assign
                             l_eosttmnt = "go"
                             l_db-type  = "mssqlsrv".
  when "ORACLE"        then assign
                             l_eosttmnt = ";".
  when "SYBASE-10"     then assign
                             l_eosttmnt = "go"
                             l_db-type  = "SYB10".
  end case.


if LDBNAME("DICTDBG") <> l_db-name
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
