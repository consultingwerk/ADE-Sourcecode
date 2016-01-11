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
/*PROGRAM NAME: _tbllist.p
 * AUTHOR      : Tammy Marshall
 * DATE        : 04/01/99
 * DESCRIPTION : Returns a list of table names to populate the selection list
 *               of tables in the DB Connections PRO*Tool Schema window.
 * */
 
DEFINE INPUT PARAMETER pcDBType AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcDBName AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pcTableList AS CHARACTER NO-UNDO.

DEFINE VARIABLE rDB AS RECID NO-UNDO.

IF pcDBType = "PROGRESS":U THEN
    FIND tinydict._db WHERE tinydict._db._db-name = ? AND 
        tinydict._db._db-type = "PROGRESS":U NO-LOCK NO-ERROR. /*local */
ELSE
    FIND tinydict._db WHERE tinydict._db._db-name = pcDBName AND 
        tinydict._db._db-type = pcDBType NO-LOCK NO-ERROR. /* foreign */
rDB = RECID(tinydict._db).

IF DBVERSION(pcDBName) < "9":U THEN DO:
  FOR EACH tinydict._File WHERE RECID(tinydict._db) = rDB AND
    NOT tinydict._File._Hidden NO-LOCK BY tinydict._File._File-Name:
      
      IF pcTableList <> "" THEN pcTableList = pcTableList + ",":U.
      ASSIGN pcTableList = pcTableList + _File._File-Name.
  END.  /* for each _File */
END.  /* db version less than 9 */
ELSE DO:
  /* Need to check the File-Number for V9 or greater db's, anything less 
     than 0 is metaschema table and anything greater than 32K is SQL92 
     system catalog tables */
  FOR EACH tinydict._File NO-LOCK 
    WHERE RECID(tinydict._db) = rDB AND
          NOT tinydict._File._Hidden AND
          (tinydict._File._File-Number > 0 AND 
           tinydict._File._File-Number < 32768) 
    USE-INDEX _File-Name:
    
    IF pcTableList <> "" THEN 
      pcTableList = pcTableList + ",":U.
    ASSIGN pcTableList = pcTableList + tinydict._File._File-Name.
  END.  /* for each _File */
END.  /* else do - db version is 9 or greater */

/* _tbllist.p - end of file */
