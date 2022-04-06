/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------

File:
    prodict/gate/_snd_sql.p
 
Description:
    call the db-type specifique _snd_sql.p routine

Input Parameters:
    p_cmmnt-chr     character-string to indicate a comment line
    p_debug         debugging output wanted or not
    p_db-name       name of 
    p_db-type       db-type of foreign db
    p_eosttmnt      end of statement ("go" or ";")
    p_owner         only used for oracle
    p_sql-file      name of sql-file to apply

Output Parameters:
    none
        
History:    
    95/09   hutegger    replaced &DEBUG preprocessor variable with
                        parameter p_debug
    95/08   hutegger    swithced .i and .p fiels around to get 
                        _snd_sql.p to have defined input-parameters
                        instead of user_env-variables
    00/03/31 D. McMann Added MSS for database type.

--------------------------------------------------------------------*/
/*h-*/

define input parameter p_cmmnt-chr  as character.
define input parameter p_debug      as logical.
define input parameter p_db-name    as character.
define input parameter p_db-type    as character.
define input parameter p_eosttmnt   as character.
define input parameter p_owner      as character.
define input parameter p_sql-file   as character.

define variable odbtyp   as character.
      
/*---------------------  INTERNAL PROCEDURES  ----------------------*/

/*---------------------------  TRIGGERS  ---------------------------*/

/*-----------------------  INITIALIZATIONS  ------------------------*/

assign
  odbtyp = {adecomm/ds_type.i
             &direction = "odbc"
             &from-type = "odbtyp"
             }.

/*---------------------------  MAIN-CODE  --------------------------*/

if p_db-type = "ORACLE"
 then RUN prodict/ora/_snd_sql.p
        ( INPUT p_cmmnt-chr,
          INPUT p_db-name,
          INPUT p_debug,
          INPUT p_eosttmnt,
          INPUT p_owner,
          INPUT p_sql-file
        ).
ELSE IF p_db-type = "MSS" THEN
  RUN prodict/mss/_snd_sql.p
        ( INPUT p_cmmnt-chr,
          INPUT p_db-name,
          INPUT p_debug,
          INPUT p_eosttmnt,
          INPUT p_owner,
          INPUT p_sql-file
        ).
else if LOOKUP(p_db-type,odbtyp) <> 0
 then RUN prodict/odb/_snd_sql.p
        ( INPUT p_cmmnt-chr,
          INPUT p_db-name,
          INPUT p_debug,
          INPUT p_eosttmnt,
          INPUT p_owner,
          INPUT p_sql-file
        ).

/*------------------------------------------------------------------*/
