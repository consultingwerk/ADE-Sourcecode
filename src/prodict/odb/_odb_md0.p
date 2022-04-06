/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

{ prodict/dictvar.i NEW }
{ prodict/user/uservar.i }
{ prodict/odb/odbvar.i }


FIND FIRST DICTDB._Db WHERE _Db-local NO-LOCK.

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
