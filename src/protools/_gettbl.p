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
/*PROGRAM NAME: _gettbl.p
 * AUTHOR      : Tammy Marshall
 * DATE        : 04/01/99
 * DESCRIPTION : Assigns table information to the TableDetails temp-table
 *               record for the currently selected table (in the DB 
 *               Connections PRO*Tool Schema window).  The TableDetails 
 *               temp-table is then used to display the field info in the 
 *               Table Details window called from the Schema window.
 * */
 
{protools/_schdef.i} /* TableDetails temp table definition */
 
DEFINE INPUT        PARAMETER pcDBType AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER pcDBName AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR TableDetails.

DEFINE VARIABLE rDB AS RECID NO-UNDO.

IF pcDBType = "PROGRESS":U THEN
  FIND tinydict._db WHERE tinydict._db._db-name = ? AND 
       tinydict._db._db-type = "PROGRESS" NO-LOCK NO-ERROR. /*local */
ELSE
  FIND tinydict._db WHERE tinydict._db._db-name = pcDBName AND 
       tinydict._db._db-type = pcDBType NO-LOCK NO-ERROR. /* foreign */
rDB = RECID(tinydict._db).

FIND FIRST TableDetails.
FIND tinydict._File WHERE RECID(tinydict._db) = rDB AND
  tinydict._File._File-Name = TableDetails.name NO-LOCK NO-ERROR.
IF AVAILABLE tinydict._File THEN DO:
  ASSIGN 
    TableDetails.tdesc    = _File._Desc
    TableDetails.tlabel   = _File._File-Label
    TableDetails.valexp   = _File._Valexp
    TableDetails.valmsg   = _File._Valmsg
    TableDetails.replproc = _File._Fil-misc2[6].
  
  /* Schema triggers */
  FOR EACH tinydict._File-Trig WHERE _File-Trig._File-Recid = RECID(_File) NO-LOCK:
    CASE _File-Trig._Event:
      WHEN "CREATE":U THEN 
        ASSIGN TableDetails.crtrig     = _File-Trig._Proc-Name.
      WHEN "DELETE":U THEN 
        ASSIGN TableDetails.deltrig    = _File-Trig._Proc-Name.
      WHEN "FIND":U THEN 
        ASSIGN TableDetails.fndtrig    = _File-Trig._Proc-Name.
      WHEN "WRITE":U THEN 
        ASSIGN TableDetails.wrtrig     = _File-Trig._Proc-Name.
      WHEN "REPLICATION-CREATE":U THEN 
        ASSIGN TableDetails.repcrtrig  = _File-Trig._Proc-Name.
      WHEN "REPLICATION-DELETE":U THEN 
        ASSIGN TableDetails.repdeltrig = _File-Trig._Proc-Name.
      WHEN "REPLICATION-WRITE":U THEN 
        ASSIGN TableDetails.repwrtrig  = _File-Trig._Proc-Name.
    END CASE.  
  END.  /* for each trigger */
  
  /* Storage Area */
  IF tinydict._File._For-type <> ? THEN
    ASSIGN TableDetails.storarea = "n/a".
  ELSE IF DBVERSION(pcDBName) >= "9":U THEN
    RUN protools/_storarea.p (RECID(tinydict._File), OUTPUT TableDetails.storarea).
END.  /* if avail _file */

/* _gettbl.p - end of file */
