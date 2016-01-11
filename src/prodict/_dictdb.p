/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*-----------------------------------------------------------------------

File: prodict/_dictdb.p

Copied from from adecomm/_dictdb.p to remove dependency on ADECOMM for 
dictionaries.

Description:   
   This procedure checks the setting of DICTDB. In case it's ? or pointing
   to a non-progress db it resets it to the first PROGRESS-db it finds

Shared Output:
   DICTDB       pointing at valid db

History:
    created 11/26/02 D. McMann

-----------------------------------------------------------------------*/

define variable l_dbnr          as integer.

/*-----------------------------  TRIGGERS  ----------------------------*/

/*--------------------------  INT.-PROCEDURES  ------------------------*/

/*--------------------------  INITIALIZATIONS  ------------------------*/

/*-----------------------------  MAIN-CODE  ---------------------------*/

if NUM-DBS > 0 AND LDBNAME("DICTDB") = ?
 OR  DBTYPE("DICTDB") <> "PROGRESS" then do:  /* change/set DICTDB alias */
  repeat while l_dbnr < NUM-DBS and DBTYPE(l_dbnr) <> "PROGRESS":
    assign l_dbnr = l_dbnr + 1.
  end.
  
  if l_dbnr <= NUM-DBS
   then create alias DICTDB for database value(LDBNAME(l_dbnr)).
   
end.     /* change/set DICTDB alias */
ELSE IF INTEGER(DBVERSION("DICTDB")) < 10 THEN DO:
  DO l_dbnr = 1 TO NUM-DBS:
    IF DBTYPE(l_dbnr) <> "PROGRESS" THEN NEXT.
    IF INTEGER(DBVERSION(l_dbnr)) < 10 THEN NEXT.
    ELSE LEAVE.
  END.
 
  IF l_dbnr <= NUM-DBS THEN
    CREATE ALIAS DICTDB FOR DATABASE VALUE(LDBNAME(l_dbnr)).
END.
/*---------------------------------------------------------------------*/
