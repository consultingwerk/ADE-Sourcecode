/*********************************************************************
* Copyright (C) 2007 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* 
   Created:  fernando 12/04/07

             Wrapper for ORACLE, MSS or ODBC schema pull that can be executed 
             in batch  mode.
                  
                  
   Input: p_sh_name   - schema holder logical name
          p_db_name   - logical name of schema image
          p_obj_name  - object name for object selection
          p_obj_owner - owner name for object selection
          p_obj_type  - type for object selection
          
          p_obj_* can be '*' to match all, a string or a string containing '*'
          (i.e. 'cust*').

          Both databases need to be connected and the user connected
          must have permissions to query the schema information.

  History:  
 
*/

define input parameter p_sh_name       as character. 
define input parameter p_db_name       as character. 
define input parameter p_obj_name      as character.
define input parameter p_obj_owner     as character. 
define input parameter p_obj_type      as character. 

DEFINE VARIABLE cDbType  AS CHARACTER NO-UNDO.

IF NOT CONNECTED(p_sh_name) THEN DO:
    MESSAGE "Database" p_sh_name "is not connected.".
    RETURN ERROR.
END.

IF NOT CONNECTED(p_db_name) THEN DO:
    MESSAGE "Database" p_db_name "is not connected.".
    RETURN ERROR.
END.

IF CAN-DO("READ-ONLY", DBRESTRICTIONS(p_sh_name)) THEN DO:
    MESSAGE "Database" p_sh_name "is read-only.".
    RETURN ERROR.
END.

cDbType = DBTYPE(p_db_name).

CREATE ALIAS "DICTDB" FOR DATABASE VALUE(p_sh_name).

PAUSE 0 BEFORE-HIDE.

IF cDbType = "ORACLE" THEN DO:
   RUN prodict/ora/_bpullora.p (p_db_name, p_obj_name, p_obj_owner, p_obj_type ).
END.
ELSE IF cDbType = "MSS" OR cDbType = "ODBC" THEN DO:
    RUN prodict/odb/_bpullodb.p (p_db_name, p_obj_name, p_obj_owner, p_obj_type).
END.
ELSE DO:
    MESSAGE "This utility only works with DataServer Schemas.".
END.


