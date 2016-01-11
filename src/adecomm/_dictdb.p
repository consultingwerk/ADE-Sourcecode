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

/*-----------------------------------------------------------------------

File: adecomm/_dictdb.p

Description:   
   This procedure checks the setting of DICTDB. In case it's ? or pointing
   to a non-progress db it resets it to the first PROGRESS-db it finds

Shared Output:
   DICTDB       pointing at valid db

History:
    95/08     hutegger    creation
    09/16/02  D. McMann  Added check for DBVERSION of DICTDB 20020916-024

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
ELSE IF INTEGER(DBVERSION("DICTDB")) < 9 THEN DO:
  DO l_dbnr = 1 TO NUM-DBS:
    IF DBTYPE(l_dbnr) <> "PROGRESS" THEN NEXT.
    IF INTEGER(DBVERSION(l_dbnr)) < 9 THEN NEXT.
    ELSE LEAVE.
  END.
 
  IF l_dbnr <= NUM-DBS THEN
    CREATE ALIAS DICTDB FOR DATABASE VALUE(LDBNAME(l_dbnr)).
END.
/*---------------------------------------------------------------------*/
