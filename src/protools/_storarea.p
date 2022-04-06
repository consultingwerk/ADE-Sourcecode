/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: _storarea.p 

  Description: 

  Note: Called by protools/_gettbl.p.  This file relies on tinydict alias 
        having been predefined.
  
  Input Parameters:
      pRecid    - RECID of tinydict

  Output Parameters:
      pStorArea - value of metaschema _Area._Area-name for this database.

  Author:  D.M.ADams
  Created: 09/24/99
  History: 08/16/00 D. McMann Added _Db-recid for _StorageObject find 20000815029
------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pRecid    AS RECID     NO-UNDO.
DEFINE OUTPUT PARAMETER pStorArea AS CHARACTER NO-UNDO.

FIND tinydict._File WHERE RECID(tinydict._File) = pRecid NO-ERROR.
IF AVAILABLE tinydict._File THEN DO:
  
  IF tinydict._File._File-number <> ? THEN DO:
    FIND tinydict._StorageObject NO-LOCK
      WHERE tinydict._StorageObject._Db-recid = tinydict._File._Db-recid AND
            tinydict._StorageObject._Object-type   = 1 AND
            tinydict._StorageObject._Object-number = tinydict._File._File-number and
            tinydict._StorageObject._Partitionid = 0 NO-ERROR.
    IF AVAILABLE tinydict._StorageObject THEN                      
      FIND tinydict._Area NO-LOCK 
        WHERE tinydict._Area._Area-number = tinydict._StorageObject._Area-number 
        NO-ERROR.
    ELSE
      FIND tinydict._Area NO-LOCK 
        WHERE tinydict._Area._Area-number = 6 NO-ERROR.
  END.    /* if filenumer <> ? */
  ELSE
    FIND tinydict._Area NO-LOCK 
      WHERE tinydict._Area._Area-number = tinydict._File._ianum NO-ERROR.
      
  IF AVAILABLE _Area THEN
    ASSIGN pStorArea = tinydict._Area._Area-name. 
END.
  
/* _storarea.p - end of file */
