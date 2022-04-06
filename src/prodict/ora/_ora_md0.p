/*********************************************************************
* Copyright (C) 2007 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------

file: prodict/ora/_ora_md0.p

Description:
    creates empty SI, creates SQL and ev. dumps the data from the
    PROGRESS source-db

Input:
    none

Output:
    nnoe

Changed/Used Shared Objects:
    s_xxx       ...

History:
    hutegger    94/05/12    stripped ".sql" from user_env[2], now
                            assigned in _wrktgen.p

    mcmann      97/12/29    Removed reference to oracle 6
    mcmann      03/10/17    Add NO-LOCK statement to _Db find in support of on-line schema add
    fernando    06/11/07    Unicode support
--------------------------------------------------------------------*/
/*h-*/

{ prodict/dictvar.i NEW}
{ prodict/user/uservar.i }
{ prodict/ora/oravar.i }

/*----------------------- INTERNAL PROCEDURES ----------------------*/
/*---------------------------- TRIGGERS ----------------------------*/
/*------------------------- INITIALIZATIONS ------------------------*/
/*--------------------------- MAIN-BLOCK ---------------------------*/

FIND FIRST _DB
  WHERE _Db._Db-type = "ORACLE"
  NO-LOCK NO-ERROR.
IF NOT AVAILABLE _Db
 THEN FIND FIRST _Db WHERE _Db-local NO-LOCK.

ASSIGN
  drec_db      = RECID(_Db)
  ora_codepage = ( if   ora_codepage <> ""
                    then ora_codepage
                    else _Db._Db-xl-name
                 )
  user_env[11] = (IF unicodeTypes THEN "nvarchar2" ELSE "varchar2")
  .
 
/*------------------------------------------------------------------*/

IF SESSION:BATCH-MODE and logfile_open
 THEN PUT STREAM logfile UNFORMATTED
        " " skip
        "-- ++ " skip
        "-- Creating SQL to create database objects " skip
        "-- -- " skip(2).

RUN "prodict/misc/_wrktgen.p".

IF SESSION:BATCH-MODE 
 and NOT logfile_open
 THEN DO:
  OUTPUT STREAM logfile TO VALUE(user_env[2] + ".log")
         APPEND UNBUFFERED NO-MAP NO-ECHO.
  logfile_open = true.
  END.

/*------------------------------------------------------------------*/

IF movedata
 THEN DO:  /* dump data */
  /* dump the data in Progress format */
  OUTPUT TO dump.tmp NO-ECHO NO-MAP.

  IF SESSION:BATCH-MODE and logfile_open
   THEN PUT STREAM logfile UNFORMATTED
          " " skip
          "-- ++ " skip
          "-- Dumping data " skip
          "-- -- " skip(2).


  RUN "prodict/dump_d.p" ("ALL","","").
  OUTPUT CLOSE.

  END.     /* dump data */


/*------------------------------------------------------------------*/
