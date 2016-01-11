/*********************************************************************
* Copyright (C) 2007 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* Created:  fernando 12/04/07

             Wrapper for ORACLE schema pull that can be executed in batch
             mode.
                  
                  
   Input: p_db_name   - logical name of schema image
          p_obj_name  - object name for object selection
          p_obj_owner - owner name for object selection
          p_obj_type  - type for object selection
          
          p_obj_* can be '*' to match all, a string or a string containing '*'
          (i.e. 'cust*').

          Database must already be connected and the user connected
          must have permissions to query the schema information.

  History:  
 
*/
 
{ prodict/ora/oravar.i NEW }
&SCOPED-DEFINE DATASERVER YES
&SCOPED-DEFINE FOREIGN_SCHEMA_TEMP_TABLES INCLUDE
{ prodict/dictvar.i NEW }
&UNDEFINE FOREIGN_SCHEMA_TEMP_TABLES
{ prodict/user/uservar.i NEW}
&UNDEFINE DATASERVER

DEFINE NEW SHARED VARIABLE odb_username AS CHARACTER NO-UNDO.

define input parameter p_db_name       as character. 
DEFINE INPUT PARAMETER obj_name  AS CHAR.
DEFINE INPUT PARAMETER obj_owner  AS CHAR.
DEFINE INPUT PARAMETER obj_qualifier AS CHAR.

DEFINE VARIABLE p_database_type  AS CHAR NO-UNDO.
DEFINE VARIABLE p_user_name      AS CHAR NO-UNDO.

ASSIGN
user_env[2] = p_db_name 
user_env[1] = "upd"
p_user_name = "*".

FIND DICTDB._Db WHERE DICTDB._Db._Db-name = user_env[2].
ASSIGN p_database_type = DBTYPE(p_db_name).

CREATE ALIAS "DICTDBG" FOR DATABASE VALUE(p_db_name) NO-ERROR.

ASSIGN
  user_env[3]   = p_database_type
  cache_dirty   = TRUE
  user_dbname   = user_env[2]
  user_dbtype   = p_database_type
  user_filename = ""
  drec_file     = ?
  drec_db       = RECID(DICTDB._Db)
  user_env[25]  = "AUTO".

/*
** Create objects in the schema holder to match objects in Oracle.
**
** We have to create the record in table s_ttb_link and the variables
** s_* below so that the link table logic in ora_lkm will work properly.
**
*/
do transaction:
    create s_ttb_link.
    assign
       s_ttb_link.level    = 0
       s_ttb_link.master   = ""
       s_ttb_link.name     = ""
       s_ttb_link.slctd    = true
       s_ttb_link.srchd    = false
       s_ttb_link.presel-n = obj_name
       s_ttb_link.presel-o = obj_owner 
       s_ttb_link.presel-t = obj_qualifier.
end. /* transaction */

assign
   s_level      = 0
   s_ldbname    = p_db_name
   s_master     = ""
   s_lnkname    = ""
   s_name-hlp   = "*"
   s_owner-hlp  = p_user_name 
   s_qual-hlp   = "*"
   s_type-hlp   = "*".

RUN prodict/ora/_ora_lkg.p.

find first gate-work NO-ERROR.
IF NOT AVAILABLE gate-work THEN DO:
    MESSAGE "No objects found.".
    RETURN.
END.

RUN prodict/ora/_ora_lks.p.

find first gate-work where gate-work.gate-slct = TRUE no-error.
IF NOT AVAILABLE gate-work THEN DO:
    MESSAGE "No objects selected to be pulled.".
    RETURN.
END.

RUN prodict/ora/_ora_pul.p. 
RUN prodict/gate/_gat_cro.p. 
