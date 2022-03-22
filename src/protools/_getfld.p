/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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

  
      
      
