/***********************************************************************
* Copyright (C) 2000,2007 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/

/* --------------------------------------------------------------------

File: prodict/ora/_ora_md1.p

Description:
    this program assumes that it has an empty progress database.  it
    then connects to an oracle database and proceeds to suck over the
    definitions for all tables defined to have an owner matching the value
    of the variable 'ora_username'

Input:
    none
    
Output:
    none
    
History:
    95/09   hutegger    introduced l_debug variable to turn debugging 
                        of snd_sql on/off
    95/04   hutegger    adjusted to use _syb_pul routines
    ?       ?           created

    97/12   mcmann      Changed number of cursors from 50 to 10 so that
                        an oracle error message will not be issued.
    01/13/98 mcmann     Removed assignment of cursors since the dataserver
                        now handles releasing cursors properly.
    05/01/98 mcmann     Removed message about no gate-work since user has
                        already been given this message 98-04-29-066  
    05/07/99 mcmann     Added space between user name and connection parms
                        when @ is used.   
    06/04/02 mcmann     Added check for error creating hidden files.                 
    06/13/07 fernando   Unicode support

--------------------------------------------------------------------*/
/*h-*/

&SCOPED-DEFINE DATASERVER YES
&SCOPED-DEFINE FOREIGN_SCHEMA_TEMP_TABLES INCLUDE
{ prodict/dictvar.i NEW }
&UNDEFINE FOREIGN_SCHEMA_TEMP_TABLES
&UNDEFINE DATASERVER

{ prodict/ora/oravar.i }
{ prodict/user/uservar.i }

DEFINE NEW SHARED VARIABLE l_closelog  AS logical   NO-UNDO.

DEFINE VARIABLE j           AS INTEGER   NO-UNDO.
DEFINE VARIABLE i           AS INTEGER   NO-UNDO.
DEFINE VARIABLE l_debug     AS logical   NO-UNDO.

DEFINE VARIABLE connection_string as CHARACTER NO-UNDO.
DEFINE VARIABLE l_ora_username    as CHARACTER NO-UNDO.
DEFINE VARIABLE ora_lang            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE nls_upp             AS CHARACTER  NO-UNDO.
DEFINE STREAM code.
OUTPUT STREAM code TO VALUE("enable.sql") NO-ECHO NO-MAP.
DEFINE VARIABLE user_env_save5 AS CHARACTER NO-UNDO.
DEFINE VARIABLE user_env_save26 AS CHARACTER NO-UNDO.
DEFINE VARIABLE user_env_save31 AS CHARACTER NO-UNDO.
DEFINE VARIABLE user_env_save36 AS CHARACTER NO-UNDO.
/*------------------------------------------------------------------*/

/* connect up the database to work with ------------------------------------*/
if not connected(osh_dbname) 
 then CONNECT VALUE(osh_dbname) -1.

/* create _db record and load oracle definitions ---------------------------*/
assign user_env[1] = ora_username.

create alias DICTDB for database value(osh_dbname).

RUN prodict/ora/_ora_md2.p.
IF RETURN-VALUE = "2" THEN
    RETURN "2".

/* connect to oracle database ----------------------------------------------*/
/* disconnect-connect is to reload schema cache -- workaround */
DISCONNECT VALUE(osh_dbname).
CONNECT VALUE(osh_dbname) -1.

ASSIGN 
  user_dbname       = ora_dbname
  user_dbtype       = {adecomm/ds_type.i
                        &direction = "etoi"
                        &from-type = "user_env[22]"
                        }
  l_ora_username    = ora_username
  user_env[25]      = "AUTO-PROTOXXX,*,ora_username,*,*".

IF ora_conparms <> "" and ora_conparms <> ?
  THEN DO:
    IF INDEX(ora_conparms,"@") = 0
      then 
        assign 
          connection_string = ora_conparms
          l_ora_username    = ora_username.
      else 
        assign 
          connection_string = " "
          l_ora_username    = ora_username + " " + ora_conparms.
   END.

IF ora_password = "" or ora_password = ?
  THEN 
    CONNECT VALUE(ora_dbname)
        -dt VALUE(user_dbtype)
        -ld VALUE(ora_dbname)
        -U  VALUE(l_ora_username)
            VALUE(connection_string). 
  ELSE
    CONNECT VALUE(ora_dbname)
        -dt VALUE(user_dbtype)
        -ld VALUE(ora_dbname)
        -U  VALUE(l_ora_username)
        -P  VALUE(ora_password)
            VALUE(connection_string).

CREATE ALIAS "DICTDBG" FOR DATABASE VALUE(ora_dbname) NO-ERROR.

ASSIGN
    user_env_save5  = user_env[5]
    user_env_save26 = user_env[26]
    user_env_save31 = user_env[31]
    user_env_save36 = user_env[36].
    
/* Verify tablespaces for tables and indexes */
RUN prodict/ora/_ora_vts.p.
IF RETURN-VALUE = "1" THEN
   RETURN "1".
   
/* if unicode types, make sure database is Oracle V9 or later */
IF unicodeTypes THEN DO:
   RUN prodict/ora/_get_oraver.p (OUTPUT j).
   IF j < 9 THEN DO:
       RETURN "3".
   END.
END.

Assign 
     nls_upp = user_env[40].
IF nls_upp = "y" THEN DO:
    RUN prodict/ora/_ora_nlsvld.p(OUTPUT i).
    IF i = 0 THEN DO:
       RETURN "4".
   END.
END.

/*
** Create the schema in Oracle 
*/
RUN "prodict/gate/_snd_sql.p"
  ( INPUT user_env[31],
    INPUT l_debug,
    INPUT ora_dbname,
    INPUT user_dbtype,
    INPUT user_env[5],
    INPUT user_env[26],
    INPUT osh_dbname + ".sql"
  ).


IF (SESSION:BATCH-MODE and not logfile_open)
  THEN DO:
    output stream logfile to value(user_env[2] + ".log") 
        unbuffered no-map no-echo append. 
    assign
     l_closelog   = true
     logfile_open = true. 
    END.


IF SESSION:BATCH-MODE AND logfile_open THEN 
   PUT STREAM logfile UNFORMATTED 
       " " skip 
       "-- ++ " skip
       "-- Getting List of Objects from foreign DB Schema" skip
       "-- -- " skip(2).

/*
** We have to create the record in table s_ttb_link and the variables
** s_* below so that the link table logic in ora_lkm will work properly.
*/
create s_ttb_link.
assign
   s_ttb_link.level    = 0
   s_ttb_link.master   = ""
   s_ttb_link.name     = ""
   s_ttb_link.slctd    = true
   s_ttb_link.srchd    = false
   s_ttb_link.presel-n = "*"
   s_ttb_link.presel-o = ora_username
   s_ttb_link.presel-t = "*"
   s_level             = 0
   s_master            = ""
   s_lnkname           = ""
   s_name-hlp          = "*"
   s_owner-hlp         = ora_username
   s_qual-hlp          = "*"
   s_type-hlp          = "*".

/* the following find is just as a workaround for a bug
 */ 
find first s_ttb_link.


/*
** Create a list of all the appropriate objects we want from
** the oracle database.
*/
    RUN prodict/ora/_ora_lkg.p.
    RUN prodict/ora/_ora_lks.p.


/*
** we check if there is something to pull, if not we just skip the rest
** of this routine
*/
find first gate-work
  where gate-work.gate-slct = TRUE
  no-error.
if available gate-work
  then do:   /* found at least one object to pull */

    IF SESSION:BATCH-MODE AND logfile_open
      THEN 
        PUT STREAM logfile UNFORMATTED 
           " " skip 
           "-- ++ " skip
           "-- Importing Objects into the {&PRO_DISPLAY_NAME} Schema Holder" skip
           "-- -- " skip(2).

/*
** Create objects in the schema holder to match objects in Oracle.
*/

    RUN prodict/ora/_ora_pul.p. 
    RUN prodict/gate/_gat_cro.p. 

    IF SESSION:BATCH-MODE and logfile_open
      THEN
        PUT STREAM logfile UNFORMATTED
            " " skip
            "-- ++ " skip
            "-- Fixing schema to resemble original {&PRO_DISPLAY_NAME} database." skip
            "-- -- " skip(2).

 
    ASSIGN     
    user_env[5]     = user_env_save5  
    user_env[26]    = user_env_save26 
    user_env[31]    = user_env_save31
    user_env[36]    = user_env_save36
    user_env[25]    = "**all**".

IF movedata THEN DO:
   FOR EACH s_ttb_con WHERE s_ttb_con.cons_type = "FOREIGN KEY":
        PUT STREAM code UNFORMATTED "ALTER TABLE " + s_ttb_con.tab_name + " ENABLE CONSTRAINT " + s_ttb_con.const_name SKIP. 
        PUT STREAM code UNFORMATTED user_env[5] SKIP.
   END.
END.

    RUN prodict/ora/_ora_md5.p (osh_dbname, pro_dbname).


 end.     /* found at least one object to pull */


/*
** The logfile will be closed as soon as we leave this procedure
** because it was opened in this procedure.
*/ 
IF l_closelog
  THEN DO:
    OUTPUT STREAM logfile CLOSE. 
    logfile_open = false. 
    END.


RETURN.

/*------------------------------------------------------------------*/


