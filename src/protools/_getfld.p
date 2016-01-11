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
/*PROGRAM NAME: _getfld.p
 * AUTHOR      : Tammy Marshall
 * DATE        : 04/01/99
 * DESCRIPTION : Assigns field information to the FieldDetails temp-table
 *               record for the currently selected field (in the DB 
 *               Connections PRO*Tool Schema window).  The FieldDetails 
 *               temp-table is then used to display the field info in the 
 *               Field Details window called from the Schema window.
 * */
 
{protools/_schdef.i} /* FieldDetails temp table definition */
 
DEFINE INPUT PARAMETER pcDBType AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pcDBName AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR FieldDetails.

DEFINE VARIABLE rDB AS RECID NO-UNDO.

IF pcDBType = "PROGRESS" THEN
    FIND tinydict._db WHERE tinydict._db._db-name = ? AND 
        tinydict._db._db-type = "PROGRESS" NO-LOCK NO-ERROR. /*local */
ELSE
    FIND tinydict._db WHERE tinydict._db._db-name = pcDBName AND 
        tinydict._db._db-type = pcDBType NO-LOCK NO-ERROR. /* foreign */
rDB = RECID(tinydict._db).

FIND FIRST FieldDetails.
FIND tinydict._File WHERE RECID(tinydict._db) = rDB AND
  tinydict._File._File-Name = FieldDetails.tblname NO-LOCK NO-ERROR.
IF AVAILABLE tinydict._File THEN 
  FIND tinydict._Field WHERE tinydict._Field._File-recid = RECID(tinydict._File) AND
    tinydict._Field._Field-name = FieldDetails.fldname NO-LOCK NO-ERROR.
  IF AVAILABLE tinydict._Field THEN DO:
    ASSIGN 
      FieldDetails.tdesc = _Field._Desc
      FieldDetails.datatype = _Field._Data-type
      FieldDetails.initval = _Field._Initial
      FieldDetails.tlabel = _Field._Label
      FieldDetails.tmandatory = _Field._Mandatory
      FieldDetails.tformat = _Field._Format
      FieldDetails.tdec = _Field._Decimals
      FieldDetails.torder = _Field._Order
      FieldDetails.textent = _Field._Extent
      FieldDetails.valexp = _Field._Valexp
      FieldDetails.valmsg = _Field._Valmsg
      FieldDetails.thelp = _Field._Help
      FieldDetails.collabel = _Field._Col-label
      FieldDetails.casesensitive = _Field._Fld-case
      FieldDetails.viewas = _Field._View-as.
      
    /* Schema trigger */  
    FIND tinydict._Field-Trig WHERE _Field-Trig._File-Recid = RECID(_File) AND
      _Field-Trig._Field-Recid = RECID(_Field) AND 
      _Field-Trig._Event = "ASSIGN" NO-LOCK NO-ERROR.
    IF AVAILABLE tinydict._Field-Trig THEN
      ASSIGN FieldDetails.asgntrig = _Field-Trig._Proc-Name.
  END.  /* if avail _field */

  
      
      
