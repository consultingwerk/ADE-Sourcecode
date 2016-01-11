/*********************************************************************
* Copyright (C) 2007 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* Created:  fernando 12/04/07

             Wrapper for MSS or ODBC schema pull that can be executed in batch
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
 
&SCOPED-DEFINE DATASERVER YES
&SCOPED-DEFINE FOREIGN_SCHEMA_TEMP_TABLES INCLUDE
{ prodict/odb/odbvar.i NEW }
{ prodict/dictvar.i NEW }
{ prodict/user/uservar.i NEW }

DEFINE INPUT PARAMETER p_db_name    AS CHAR. 
DEFINE INPUT PARAMETER p_obj_name   AS CHAR.
DEFINE INPUT PARAMETER p_obj_owner  AS CHAR.
DEFINE INPUT PARAMETER p_obj_type   AS CHAR.

/* Initialize variables */
ASSIGN
  user_dbtype   = DBTYPE(p_db_name)
  user_filename = ""
  drec_file     = ?
  odb_dbname    = p_db_name
  cache_dirty   = TRUE
  user_env[1]   = "upd"
  user_env[2]   = p_db_name
  user_env[3]   = user_dbtype.

IF user_dbtype NE "MSS" AND user_dbtype NE "ODBC" THEN
DO:
    MESSAGE "Database" p_db_name "has invalid type".
    RETURN ERROR.
END.

CREATE ALIAS "DICTDBG" FOR DATABASE VALUE(p_db_name) NO-ERROR.

/* Get the RECID for the database in the schema holder */
FIND DICTDB._Db WHERE DICTDB._Db._Db-name = p_db_name NO-LOCK NO-ERROR.
drec_db = RECID(DICTDB._Db).

/* Initialize variables */
ASSIGN
   user_dbname = p_db_name
   user_env[1] = p_db_name
   user_env[2] = p_db_name.

DO TRANSACTION:
    CREATE s_ttb_link.
    ASSIGN
       s_level   = 0
       s_ldbname = p_db_name
       s_master  = ""
       s_lnkname = ""
       s_ttb_link.level    = 0
       s_ttb_link.master   = ""
       s_ttb_link.name     = ""
       s_ttb_link.srchd    = false
       s_ttb_link.presel-n = p_obj_name
       s_ttb_link.presel-o = p_obj_owner
       s_ttb_link.presel-t = p_obj_type
       /* for _odb_get.p */
       /* "{AUTO},<name>,<owner>,<type>,<qualifier>"*/
       user_env[25] = "AUTO," + p_obj_name + "," + 
                      p_obj_owner + "," + 
                      p_obj_type + ",*"
      . 
END. /* transaction */

/* Determine what to pull  */
IF DBTYPE(p_db_name) = "MSS" THEN
    RUN prodict/mss/_mss_get.p.  
ELSE 
    RUN prodict/odb/_odb_get.p.

FIND FIRST gate-work NO-ERROR.
IF NOT AVAILABLE gate-work THEN DO:
    MESSAGE "No objects found.".
    RETURN.
END.

/* Pull */
IF DBTYPE(p_db_name) = "MSS" THEN
   RUN prodict/mss/_mss_pul.p.
ELSE
   RUN prodict/odb/_odb_pul.p.

find first gate-work where gate-work.gate-slct = TRUE no-error.
IF NOT AVAILABLE gate-work THEN DO:
    MESSAGE "No objects selected to be pulled.".
    RETURN.
END.

RUN prodict/gate/_gat_cro.p. /* Create the objects in the schema-holder */
