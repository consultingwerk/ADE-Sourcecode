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

{ prodict/dictvar.i NEW }
{ prodict/user/uservar.i }
{ prodict/odb/odbvar.i }


FIND FIRST DICTDB._Db WHERE _Db-local.

ASSIGN
  drec_db      = RECID(DICTDB._Db).

IF SESSION:BATCH-MODE and logfile_open THEN DO: 
    PUT STREAM logfile UNFORMATTED
        " " skip 
        "-- ++ " skip
        "-- Creating SQL to create database objects " skip
        "-- -- " skip(2).
END.

RUN prodict/misc/_wrktgen.p.

IF SESSION:BATCH-MODE and NOT logfile_open THEN DO:
    OUTPUT STREAM logfile TO VALUE(user_env[2] + ".log") 
           APPEND UNBUFFERED NO-MAP NO-ECHO.
    logfile_open = true. 
END.

stages_complete[odb_create_sql] = TRUE. 

IF not stages[odb_dump_data] THEN RETURN.

IF movedata THEN DO:
  /* dump the data in Progress format */

  OUTPUT TO dump.tmp NO-ECHO NO-MAP.
  IF SESSION:BATCH-MODE and logfile_open THEN 
      PUT STREAM logfile UNFORMATTED 
          " " skip
          "-- ++ " skip
          "-- Dumping data " skip
          "-- -- " skip(2).
 
  RUN prodict/dump_d.p ("ALL","","").

END.

stages_complete[odb_dump_data] = TRUE. 

RETURN.
