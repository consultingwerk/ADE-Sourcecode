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
            tinydict._StorageObject._Object-number = tinydict._File._File-number 
            NO-ERROR.
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
