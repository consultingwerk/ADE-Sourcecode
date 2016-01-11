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
/*PROGRAM NAME: _idxlist.p
 * AUTHOR      : Tammy Marshall
 * DATE        : 04/01/99
 * DESCRIPTION : Returns a list of index names to populate the selection list
 *               of indices in the DB Connections PRO*Tool Schema window.
 * */
 
DEFINE INPUT PARAMETER pcDBType AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcDBName AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcTableName AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER cIndxList AS CHARACTER NO-UNDO.

DEFINE VARIABLE rDB AS RECID NO-UNDO.  /* recid of _db */

IF pcDBType = "PROGRESS" THEN
    FIND tinydict._db WHERE tinydict._db._db-name = ? AND 
        tinydict._db._db-type = "PROGRESS" NO-LOCK NO-ERROR. /*local */
ELSE
    FIND tinydict._db WHERE tinydict._db._db-name = pcDBName AND 
        tinydict._db._db-type = pcDBType NO-LOCK NO-ERROR. /* foreign */
rDB = RECID(tinydict._db).

FIND tinydict._File WHERE tinydict._File._Db-Recid = rDB AND
  tinydict._File._File-Name = pcTableName NO-LOCK NO-ERROR.
IF AVAILABLE tinydict._File THEN 
  FOR EACH tinydict._Index OF tinydict._File NO-LOCK:
    IF cIndxList <> "" THEN cIndxList = cIndxList + ",".
    ASSIGN cIndxList = cIndxList + _Index._Index-Name.
  END.  /* for each _field */
 
