/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* PROGRAM NAME: _getTblFldIdx.p
 * AUTHOR      : Don Bulua
 * DATE        : 04/12/04
 * DESCRIPTION : Retrieves meta schema information for the specified table and
                 stores all info in temp tables: TableDetails, FieldDetails
                 IndexDetails and IndxFldDetails.
                 
 * Parameters  : pcDBType   Type of Database   'PROGRESS'  for Progress databases
 *               pcDBName   Name of Database for foreign databases only
                 pcTable    Name of Table
 *      Notes  : Assumes the alias for tinydict was set to the database name           
 * */
 
{protools/_schdef.i} /* TableDetails temp table definition */
 
DEFINE INPUT        PARAMETER pcDBType AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER pcDBName AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER pcTable  AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER TABLE FOR TableDetails.
DEFINE OUTPUT PARAMETER TABLE FOR FieldDetails.
DEFINE OUTPUT PARAMETER TABLE FOR IndexDetails.
DEFINE OUTPUT PARAMETER TABLE FOR IndxFldDetails.

DEFINE VARIABLE rDB AS RECID NO-UNDO.

EMPTY TEMP-TABLE TableDetails.
EMPTY TEMP-TABLE FieldDetails.
EMPTY TEMP-TABLE IndexDetails.
EMPTY TEMP-TABLE IndxFldDetails.


IF pcDBType = "PROGRESS":U THEN
  FIND tinydict._db WHERE tinydict._db._db-name = ? AND 
       tinydict._db._db-type = "PROGRESS" NO-LOCK NO-ERROR. /*local */
ELSE
  FIND tinydict._db WHERE tinydict._db._db-name = pcDBName AND 
       tinydict._db._db-type = pcDBType NO-LOCK NO-ERROR. /* foreign */
rDB = RECID(tinydict._db).

FIND tinydict._File WHERE RECID(tinydict._db) = rDB 
                      AND tinydict._File._File-Name = pcTable NO-LOCK NO-ERROR.
IF AVAILABLE tinydict._File THEN 
DO:
  CREATE TableDetails.
  ASSIGN 
    TableDetails.name     = pcTable
    TableDetails.tdesc    = tinydict._File._Desc
    TableDetails.tlabel   = tinydict._File._File-Label
    TableDetails.valexp   = tinydict._File._Valexp
    TableDetails.valmsg   = tinydict._File._Valmsg
    TableDetails.replproc = tinydict._File._Fil-misc2[6].
  
  /* Schema triggers */
  FOR EACH tinydict._File-Trig WHERE tinydict._File-Trig._File-Recid = RECID(_File) NO-LOCK:
    CASE _File-Trig._Event:
      WHEN "CREATE":U THEN 
        ASSIGN TableDetails.crtrig     = tinydict._File-Trig._Proc-Name.
      WHEN "DELETE":U THEN 
        ASSIGN TableDetails.deltrig    = tinydict._File-Trig._Proc-Name.
      WHEN "FIND":U THEN 
        ASSIGN TableDetails.fndtrig    = tinydict._File-Trig._Proc-Name.
      WHEN "WRITE":U THEN 
        ASSIGN TableDetails.wrtrig     = tinydict._File-Trig._Proc-Name.
      WHEN "REPLICATION-CREATE":U THEN 
        ASSIGN TableDetails.repcrtrig  = tinydict._File-Trig._Proc-Name.
      WHEN "REPLICATION-DELETE":U THEN 
        ASSIGN TableDetails.repdeltrig = tinydict._File-Trig._Proc-Name.
      WHEN "REPLICATION-WRITE":U THEN 
        ASSIGN TableDetails.repwrtrig  = tinydict._File-Trig._Proc-Name.
    END CASE.  
  END.  /* for each trigger */
  
  /* Storage Area */
  IF tinydict._File._For-type <> ? THEN
    ASSIGN TableDetails.storarea = "n/a".
  ELSE IF INTEGER(DBVERSION(pcDBName)) >=  9  THEN
    RUN protools/_storarea.p (RECID(tinydict._File), OUTPUT TableDetails.storarea).
    
  /* Retrieve all fields for the specified table */
  FOR EACH tinydict._Field WHERE tinydict._Field._File-recid = RECID(tinydict._File) NO-LOCK:
     CREATE FieldDetails.
     ASSIGN
       FieldDetails.tblname       = pcTable
	   FieldDetails.fldname 	  = tinydict._Field._Field-name
	   FieldDetails.tdesc 	  	  = tinydict._Field._Desc
	   FieldDetails.datatype 	  = tinydict._Field._Data-type
	   FieldDetails.initval  	  = tinydict._Field._Initial
	   FieldDetails.tlabel 		  = tinydict._Field._Label
	   FieldDetails.tmandatory    = tinydict._Field._Mandatory
	   FieldDetails.tformat 	  = tinydict._Field._Format
	   FieldDetails.tdec 		  = tinydict._Field._Decimals
	   FieldDetails.torder 		  = tinydict._Field._Order
	   FieldDetails.textent 	  = tinydict._Field._Extent
	   FieldDetails.valexp 		  = tinydict._Field._Valexp
	   FieldDetails.valmsg 		  = tinydict._Field._Valmsg
	   FieldDetails.thelp 		  = tinydict._Field._Help
	   FieldDetails.collabel 	  = tinydict._Field._Col-label
	   FieldDetails.casesensitive = tinydict._Field._Fld-case
	   FieldDetails.viewas 		  = tinydict._Field._View-as.

   	/* Schema trigger */  
     FIND tinydict._Field-Trig 
          WHERE _Field-Trig._File-Recid  = RECID(_File) 
            AND _Field-Trig._Field-Recid = RECID(_Field) 
            AND _Field-Trig._Event       = "ASSIGN" NO-LOCK NO-ERROR.
     IF AVAILABLE tinydict._Field-Trig THEN
      	ASSIGN FieldDetails.asgntrig = tinydict._Field-Trig._Proc-Name.  
  END. /* End For each _field */
  
  /* Find Indexes */
  FOR EACH tinydict._Index WHERE tinydict._Index._File-recid = RECID(tinydict._File) NO-LOCK:
     CREATE IndexDetails.
  	 ASSIGN 
  	    IndexDetails.tblname    = pcTable
  	    IndexDetails.idxname    = tinydict._Index._Index-name
  	    IndexDetails.tdesc      = tinydict._Index._Desc
  	    IndexDetails.lactive    = tinydict._Index._Active
  	    IndexDetails.lunique    = tinydict._Index._Unique
  	    IndexDetails.lwordindex = IF tinydict._Index._Wordidx = 1 THEN TRUE ELSE FALSE.
  	      
  	 IF tinydict._File._Prime-Index = RECID(tinydict._Index) THEN IndexDetails.lprimary = yes.
  	    
  	 FIND LAST tinydict._Index-Field OF tinydict._Index NO-LOCK NO-ERROR.
  	 IF AVAILABLE tinydict._Index-Field THEN IndexDetails.labbrev = tinydict._Index-Field._Abbreviate.
  	    
  	 FOR EACH tinydict._Index-Field WHERE tinydict._Index-Field._Index-recid = RECID(tinydict._Index) NO-LOCK:
  	    CREATE IndxFldDetails.
  	    ASSIGN
  	       IndxFldDetails.tblname = IndexDetails.tblname
  	       IndxFldDetails.idxname = tinydict._Index._Index-name
  	       IndxFldDetails.idxseq  = tinydict._Index-Field._Index-seq
  	       IndxFldDetails.lasc    = tinydict._Index-Field._Ascending.
  	        
  	    FIND tinydict._Field WHERE RECID(tinydict._Field) = tinydict._Index-Field._Field-recid NO-LOCK NO-ERROR.
  	    IF AVAIL tinydict._Field THEN 
           ASSIGN IndxFldDetails.fldname = tinydict._Field._Field-name
  	              IndxFldDetails.fldtype = tinydict._Field._Data-Type.
     END. /* For each _index-field */		        
  END.  /* for each index field */
					
END.  /* if avail _file */

/* _gettbl.p - end of file */
