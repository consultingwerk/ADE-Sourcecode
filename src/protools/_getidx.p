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
/*PROGRAM NAME: _getidx.p
 * AUTHOR      : Tammy Marshall
 * DATE        : 04/01/99
 * DESCRIPTION : Assigns index information to the IndexDetails and IndxFldDetails
 *               temp-table records for the currently selected index (in the DB 
 *               Connections PRO*Tool Schema window).  The IndexDetails and
 *               IndxFldDetails temp-tables are then used to display the index
 *               and index field info in the Index Details window called from the 
 *               Schema window.
 * */
 
{protools/_schdef.i} /* IndexDetails temp table definition */
 
DEFINE INPUT PARAMETER pcDBType AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcDBName AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR IndexDetails.
DEFINE OUTPUT PARAMETER TABLE FOR IndxFldDetails.

DEFINE VARIABLE rDB AS RECID NO-UNDO.

IF pcDBType = "PROGRESS" THEN
    FIND tinydict._db WHERE tinydict._db._db-name = ? AND 
        tinydict._db._db-type = "PROGRESS" NO-LOCK NO-ERROR. /*local */
ELSE
    FIND tinydict._db WHERE tinydict._db._db-name = pcDBName AND 
        tinydict._db._db-type = pcDBType NO-LOCK NO-ERROR. /* foreign */
rDB = RECID(tinydict._db).

FIND FIRST IndexDetails.
FIND tinydict._File WHERE RECID(tinydict._db) = rDB AND
  tinydict._File._File-Name = IndexDetails.tblname NO-LOCK NO-ERROR.
IF AVAILABLE tinydict._File THEN 
  FIND tinydict._Index WHERE tinydict._Index._File-recid = RECID(tinydict._File) AND
    tinydict._Index._Index-name = IndexDetails.idxname NO-LOCK NO-ERROR.
  IF AVAILABLE tinydict._Index THEN DO:
    ASSIGN 
      IndexDetails.tdesc = _Index._Desc
      IndexDetails.lactive = _Index._Active
      IndexDetails.lunique = _Index._Unique.
    IF _Index._Wordidx = 1 THEN IndexDetails.lwordindex = TRUE.
    ELSE IndexDetails.lwordindex = FALSE.

    IF tinydict._File._Prime-Index = RECID(_Index) THEN IndexDetails.lprimary = yes.
    
    FIND LAST _Index-Field OF _Index NO-LOCK NO-ERROR.
    IF AVAILABLE _Index-Field THEN IndexDetails.labbrev = _Index-Field._Abbreviate.
    
    FOR EACH tinydict._Index-Field WHERE 
      _Index-Field._Index-recid = RECID(_Index) NO-LOCK:
      
      CREATE IndxFldDetails.
      ASSIGN
        IndxFldDetails.tblname = IndexDetails.tblname
        IndxFldDetails.idxname = _Index._Index-name
        IndxFldDetails.idxseq = _Index-Field._Index-seq
        IndxFldDetails.lasc = _Index-Field._Ascending.
        
      FIND tinydict._Field WHERE RECID(_Field) = _Index-Field._Field-recid NO-LOCK NO-ERROR.
      IF AVAIL _Field THEN ASSIGN
        IndxFldDetails.fldname = _Field._Field-name
        IndxFldDetails.fldtype = _Field._Data-Type.
        
    END.  /* for each index field */
  END.  /* if avail _index */

  
      
      
