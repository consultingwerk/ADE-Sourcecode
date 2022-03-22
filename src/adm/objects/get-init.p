/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* get-init.p - This procedure is passed the name of a table and
   retrieves the value of the _template field for that table in
   the current DICTDB database, and returns that RECID value to
   the caller (adm-add-record in tableio.i). 
   Parameters: INPUT table-name
               OUTPUT RECIF of _template record for that table 
   Notes:      This needs to be a separate procedure because the 
               value of DICTDB may be changed at runtime.        
               The table-name may or may not have a db-name qualifier.
               
*/

  DEFINE INPUT PARAMETER p-table-name AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER p-table-recid AS RECID NO-UNDO.
  
  FIND DICTDB._file WHERE _file._file-name = SUBSTR(p-table-name, INDEX(p-table-name, ".":U) + 1) 
                      AND _file._tbl-type = "T":U 
                      AND (_file._owner = "PUB":U OR _file._owner = "_FOREIGN":U) 
       NO-LOCK.       /* Only tables owned by PUB AND _FOREIGN are 4GL visible. */

  p-table-recid = _file._template.

