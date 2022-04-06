/*********************************************************************
* Copyright (C) 2011 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* MSS stored procedures definitions 

  History:  DLM 01/28/98 Added files to handle procedures
            DLM 10/17/03 Add NO-LOCK statement to _Db find in support of on-line schema add
            musingh 03/30/11 Added additional _Fields to the SQLColumns_buffer.
  
*/
DEFINE VARIABLE batch_mode    AS LOGICAL INITIAL NO       NO-UNDO.
DEFINE INPUT PARAMETER dbkey AS RECID NO-UNDO.
batch_mode = SESSION:BATCH-MODE.

FIND _File
  WHERE _File._Db-recid = dbkey
    AND _File._File-name = "SQLTables" NO-ERROR.
IF AVAILABLE _File THEN DO:
  find _db where RECID(_Db) = dbkey NO-LOCK.
  IF NOT batch_mode THEN
  MESSAGE "Meta schema definitions for" _db-name "already exists.".
  RETURN.
END. 


CREATE _File.
ASSIGN
  _File._Db-recid     = dbkey 
  _File._File-name    = "SQLTables"
  _File._ianum        = 6
  _File._For-type     = "PROCEDURE"
  _File._Last-change  = 2146431
  _File._Hidden       = TRUE
  _File._For-name     = "SQLTables"
  _File._For-Owner    = "".

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "Qualifier"
  _Field._Data-Type    = "character"
  _Field._Initial      = ""
  _Field._Mandatory    = yes
  _Field._Format       = "x(76)"
  _Field._Order        = 10
  _Field._Fld-stdtype  = 36
  _Field._Fld-stoff    = 1
  _Field._For-name     = "Qualifier"
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "char".

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "Owner"
  _Field._Data-Type    = "character"
  _Field._Initial      = ""
  _Field._Mandatory    = yes
  _Field._Format       = "x(76)"
  _Field._Order        = 20
  _Field._Fld-stdtype  = 36
  _Field._Fld-stoff    = 2
  _Field._For-name     = "Owner"
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "char".

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "Name"
  _Field._Data-Type    = "character"
  _Field._Initial      = ""
  _Field._Mandatory    = yes
  _Field._Format       = "x(76)"
  _Field._Order        = 30
  _Field._Fld-stdtype  = 36
  _Field._Fld-stoff    = 3
  _Field._For-name     = "Name"
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "char".

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "Type"
  _Field._Data-Type    = "character"
  _Field._Initial      = ""
  _Field._Mandatory    = yes
  _Field._Format       = "x(76)"
  _Field._Order        = 40
  _Field._Fld-stdtype  = 36
  _Field._Fld-stoff    = 4
  _Field._For-name     = "Type"
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "char".
 
/* Stored procedure for SQLTables ODBC call. */
CREATE _File.
ASSIGN
  _File._Db-recid     = dbkey
  _File._File-name    = "SQLTables_buffer"
  _File._For-type     = "buffer"
  _File._Last-change  = 2146431
  _File._Hidden       = TRUE
  _File._For-name     = "SQLTables_buffer"
  _File._For-Owner    = "".


CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "Qualifier"
  _Field._Data-Type    = "character"
  _Field._Initial      = ""
  _Field._Mandatory    = yes
  _Field._Format       = "x(76)"
  _Field._Order        = 10
  _Field._Fld-stdtype  = 36
  _Field._Fld-stoff    = 1
  _Field._For-name     = "Qualifier"
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "char".

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "Owner"
  _Field._Data-Type    = "character"
  _Field._Initial      = ""
  _Field._Mandatory    = yes
  _Field._Format       = "x(76)"
  _Field._Order        = 20
  _Field._Fld-stdtype  = 36
  _Field._Fld-stoff    = 2
  _Field._For-name     = "Owner"
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "char".

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "Name"
  _Field._Data-Type    = "character"
  _Field._Initial      = ""
  _Field._Mandatory    = yes
  _Field._Format       = "x(76)"
  _Field._Order        = 30
  _Field._Fld-stdtype  = 36
  _Field._Fld-stoff    = 3
  _Field._For-name     = "Name"
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "char".

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "Type"
  _Field._Data-Type    = "character"
  _Field._Initial      = ""
  _Field._Mandatory    = yes
  _Field._Format       = "x(76)"
  _Field._Order        = 40
  _Field._Fld-stdtype  = 36
  _Field._Fld-stoff    = 4
  _Field._For-name     = "Type"
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "char".

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "Remark"
  _Field._Data-Type    = "character"
  _Field._Initial      = ""
  _Field._Mandatory    = yes
  _Field._Format       = "x(76)"
  _Field._Order        = 50
  _Field._Fld-stdtype  = 36
  _Field._Fld-stoff    = 5
  _Field._For-name     = "Type"
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "char".

/* Stored procedure for SQLColumns ODBC call. */
CREATE _File.
ASSIGN
  _File._Db-recid     = dbkey 
  _File._File-name    = "SQLColumns"
  _File._ianum        = 6
  _File._For-type     = "PROCEDURE"
  _File._Last-change  = 2146431
  _File._Hidden       = TRUE
  _File._For-name     = "SQLColumns"
  _File._For-Owner    = "".

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "Qualifier"
  _Field._Data-Type    = "character"
  _Field._Initial      = ""
  _Field._Mandatory    = yes
  _Field._Format       = "x(76)"
  _Field._Order        = 10
  _Field._Fld-stdtype  = 36
  _Field._Fld-stoff    = 1
  _Field._For-name     = "Qualifier"
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "char".

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "Owner"
  _Field._Data-Type    = "character"
  _Field._Initial      = ""
  _Field._Mandatory    = yes
  _Field._Format       = "x(76)"
  _Field._Order        = 20
  _Field._Fld-stdtype  = 36
  _Field._Fld-stoff    = 2
  _Field._For-name     = "Owner"
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "char".

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "Name"
  _Field._Data-Type    = "character"
  _Field._Initial      = ""
  _Field._Mandatory    = yes
  _Field._Format       = "x(76)"
  _Field._Order        = 30
  _Field._Fld-stdtype  = 36
  _Field._Fld-stoff    = 3
  _Field._For-name     = "Name"
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "char".

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "Column-name"
  _Field._Data-Type    = "character"
  _Field._Initial      = ""
  _Field._Mandatory    = yes
  _Field._Format       = "x(76)"
  _Field._Order        = 40
  _Field._Fld-stdtype  = 36
  _Field._Fld-stoff    = 4
  _Field._For-name     = "Column-name"
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "char".

/* Stored procedure for SQLColumns ODBC call. */
CREATE _File.
ASSIGN
  _File._Db-recid     = dbkey
  _File._File-name    = "SQLColumns_buffer"
  _File._ianum        = 6
  _File._For-type     = "buffer"
  _File._Last-change  = 2146431
  _File._Hidden       = TRUE
  _File._For-name     = "SQLColumns_buffer"
  _File._For-Owner    = "".


CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "Qualifier"
  _Field._Data-Type    = "character"
  _Field._Initial      = ""
  _Field._Mandatory    = yes
  _Field._Format       = "x(76)"
  _Field._Order        = 10
  _Field._Fld-stdtype  = 36
  _Field._Fld-stoff    = 1
  _Field._For-name     = "Qualifier"
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "char".

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "Owner"
  _Field._Data-Type    = "character"
  _Field._Initial      = ""
  _Field._Mandatory    = yes
  _Field._Format       = "x(76)"
  _Field._Order        = 20
  _Field._Fld-stdtype  = 36
  _Field._Fld-stoff    = 2
  _Field._For-name     = "Owner"
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "char".

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "Name"
  _Field._Data-Type    = "character"
  _Field._Initial      = ""
  _Field._Mandatory    = yes
  _Field._Format       = "x(76)"
  _Field._Order        = 30
  _Field._Fld-stdtype  = 36
  _Field._Fld-stoff    = 3
  _Field._For-name     = "Name"
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "char".

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "Column-name"
  _Field._Data-Type    = "character"
  _Field._Initial      = ""
  _Field._Mandatory    = yes
  _Field._Format       = "x(76)"
  _Field._Order        = 40
  _Field._Fld-stdtype  = 36
  _Field._Fld-stoff    = 4
  _Field._For-name     = "Column-name"
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "char".

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "Data-type"
  _Field._Data-Type    = "integer"
  _Field._Initial      = "0" 
  _Field._Mandatory    = yes
  _Field._Format       = "99999"
  _Field._Order        = 50
  _Field._Fld-stdtype  = 32
  _Field._Fld-stoff    = 5
  _Field._For-name     = "Data-type"
  _Field._For-type     = "smallint".

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "Type-name"
  _Field._Data-Type    = "character"
  _Field._Initial      = ""   
  _Field._Mandatory    = yes
  _Field._Format       = "x(76)"
  _Field._Order        = 60   
  _Field._Fld-stdtype  = 36
  _Field._Fld-stoff    = 6
  _Field._For-name     = "Type-name"
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "char".  
 
CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "Precision"
  _Field._Data-Type    = "integer"
  _Field._Initial      = "0"
  _Field._Mandatory    = yes
  _Field._Format       = "9999999999"
  _Field._Order        = 70
  _Field._Fld-stdtype  = 33 
  _Field._Fld-stoff    = 7
  _Field._For-name     = "Precision"
  _Field._For-type     = "integer".


CREATE _Field. /* file: col$ */  
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "Length"
  _Field._Data-Type    = "integer"
  _Field._Initial      = "0"
  _Field._Mandatory    = yes
  _Field._Format       = "999999999"
  _Field._Order        = 80
  _Field._Fld-stdtype  = 33 
  _Field._Fld-stoff    = 8
  _Field._For-name     = "Length"
  _Field._For-type     = "integer".  
 
 
CREATE _Field. /* file: col$ */  
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "Scale"  
  _Field._Data-Type    = "integer"
  _Field._Initial      = "0"
  _Field._Mandatory    = yes
  _Field._Format       = "99999"
  _Field._Order        = 90
  _Field._Fld-stdtype  = 32
  _Field._Fld-stoff    = 9
  _Field._For-name     = "Scale"
  _Field._For-type     = "smallint".
 
   
CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "Radix"
  _Field._Data-Type    = "integer"
  _Field._Initial      = "0"
  _Field._Mandatory    = yes
  _Field._Format       = "99999"
  _Field._Order        = 100 
  _Field._Fld-stdtype  = 32
  _Field._Fld-stoff    = 10 
  _Field._For-name     = "Radix"
  _Field._For-type     = "smallint".

CREATE _Field. /* file: col$ */ 
ASSIGN 
  _Field._File-recid   = RECID(_File) 
  _Field._Field-Name   = "Nullable" 
  _Field._Data-Type    = "integer" 
  _Field._Initial      = "0"    
  _Field._Mandatory    = yes 
  _Field._Format       = "99999" 
  _Field._Order        = 110 
  _Field._Fld-stdtype  = 32 
  _Field._Fld-stoff    = 11 
  _Field._For-name     = "Nullable" 
  _Field._For-type     = "smallint". 


CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "Remarks"
  _Field._Data-Type    = "character"
  _Field._Initial      = ""
  _Field._Mandatory    = yes
  _Field._Format       = "x(76)"
  _Field._Order        = 120 
  _Field._Fld-stdtype  = 36
  _Field._Fld-stoff    = 12 
  _Field._For-name     = "Remarks"
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "char".

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "column-def"
  _Field._Data-Type    = "character"
  _Field._Initial      = ""
  _Field._Mandatory    = yes
  _Field._Format       = "x(76)"
  _Field._Order        = 130 
  _Field._Fld-stdtype  = 36
  _Field._Fld-stoff    = 13 
  _Field._For-name     = "column-def"
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "char".


CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "sql-data-type"
  _Field._Data-Type    = "integer"
  _Field._Initial      = "0" 
  _Field._Mandatory    = yes
  _Field._Format       = "99999"
  _Field._Order        = 140
  _Field._Fld-stdtype  = 32
  _Field._Fld-stoff    = 14
  _Field._For-name     = "sql-data-type"
  _Field._For-type     = "smallint".

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "sql-datetime-sub"
  _Field._Data-Type    = "integer"
  _Field._Initial      = "0" 
  _Field._Mandatory    = yes
  _Field._Format       = "99999"
  _Field._Order        = 150
  _Field._Fld-stdtype  = 32
  _Field._Fld-stoff    = 15
  _Field._For-name     = "sql-datetime-sub"
  _Field._For-type     = "smallint".

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "char-octet-length"
  _Field._Data-Type    = "integer"
  _Field._Initial      = "0" 
  _Field._Mandatory    = yes
  _Field._Format       = "99999"
  _Field._Order        = 160
  _Field._Fld-stdtype  = 32
  _Field._Fld-stoff    = 16
  _Field._For-name     = "char-octet-length"
  _Field._For-type     = "integer".

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "ordinal-pos"
  _Field._Data-Type    = "integer"
  _Field._Initial      = "0" 
  _Field._Mandatory    = yes
  _Field._Format       = "99999"
  _Field._Order        = 170
  _Field._Fld-stdtype  = 32
  _Field._Fld-stoff    = 17
  _Field._For-name     = "ordinal-pos"
  _Field._For-type     = "integer".
CREATE _Field. /* file: col$ */

ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "is-nullable"
  _Field._Data-Type    = "character"
  _Field._Initial      = ""   
  _Field._Mandatory    = yes
  _Field._Format       = "x(76)"
  _Field._Order        = 180   
  _Field._Fld-stdtype  = 36
  _Field._Fld-stoff    = 18
  _Field._For-name     = "is-nullable"
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "char".  


CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "ss-data-type"
  _Field._Data-Type    = "integer"
  _Field._Initial      = "0" 
  _Field._Mandatory    = yes
  _Field._Format       = "99999"
  _Field._Order        = 190
  _Field._Fld-stdtype  = 32
  _Field._Fld-stoff    = 19
  _Field._For-name     = "ss-data-type"
  _Field._For-type     = "integer".

/* Stored procedure for SQLStatistics ODBC call. */
CREATE _File.
ASSIGN
  _File._Db-recid     = dbkey 
  _File._File-name    = "SQLStatistics"
  _File._ianum        = 6
  _File._For-type     = "PROCEDURE"
  _File._Last-change  = 2146431
  _File._Hidden       = TRUE
  _File._For-name     = "SQLStatistics"
  _File._For-Owner    = "".

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "Qualifier"
  _Field._Data-Type    = "character"
  _Field._Initial      = ""
  _Field._Mandatory    = yes
  _Field._Format       = "x(76)"
  _Field._Order        = 10
  _Field._Fld-stdtype  = 36
  _Field._Fld-stoff    = 1
  _Field._For-name     = "Qualifier"
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "char".

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "Owner"
  _Field._Data-Type    = "character"
  _Field._Initial      = ""
  _Field._Mandatory    = yes
  _Field._Format       = "x(76)"
  _Field._Order        = 20
  _Field._Fld-stdtype  = 36
  _Field._Fld-stoff    = 2
  _Field._For-name     = "Owner"
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "char".

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "Name"
  _Field._Data-Type    = "character"
  _Field._Initial      = ""
  _Field._Mandatory    = yes
  _Field._Format       = "x(76)"
  _Field._Order        = 30
  _Field._Fld-stdtype  = 36
  _Field._Fld-stoff    = 3
  _Field._For-name     = "Name"
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "char".

/* Stored procedure for SQLStatistics ODBC call. */
CREATE _File.
ASSIGN
  _File._Db-recid     = dbkey
  _File._File-name    = "SQLStatistics_buffer"
  _File._ianum        = 6
  _File._For-type     = "buffer"
  _File._Last-change  = 2146431
  _File._Hidden       = TRUE
  _File._For-name     = "SQLStatistics_buffer"
  _File._For-Owner    = "".


CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "Qualifier"
  _Field._Data-Type    = "character"
  _Field._Initial      = ""
  _Field._Mandatory    = yes
  _Field._Format       = "x(76)"
  _Field._Order        = 10
  _Field._Fld-stdtype  = 36
  _Field._Fld-stoff    = 1
  _Field._For-name     = "Qualifier"
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "char".

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "Owner"
  _Field._Data-Type    = "character"
  _Field._Initial      = ""
  _Field._Mandatory    = yes
  _Field._Format       = "x(76)"
  _Field._Order        = 20
  _Field._Fld-stdtype  = 36
  _Field._Fld-stoff    = 2
  _Field._For-name     = "Owner"
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "char".

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "Name"
  _Field._Data-Type    = "character"
  _Field._Initial      = ""
  _Field._Mandatory    = yes
  _Field._Format       = "x(76)"
  _Field._Order        = 30
  _Field._Fld-stdtype  = 36
  _Field._Fld-stoff    = 3
  _Field._For-name     = "Name"
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "char".


CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "non-unique"
  _Field._Data-Type    = "integer"
  _Field._Initial      = "0" 
  _Field._Mandatory    = yes
  _Field._Format       = "99999"
  _Field._Order        = 40 
  _Field._Fld-stdtype  = 32
  _Field._Fld-stoff    = 4
  _Field._For-name     = "non-unique"
  _Field._For-type     = "smallint".

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "index-qualifier"
  _Field._Data-Type    = "character"
  _Field._Initial      = ""   
  _Field._Mandatory    = yes
  _Field._Format       = "x(76)"
  _Field._Order        = 50   
  _Field._Fld-stdtype  = 36
  _Field._Fld-stoff    = 5
  _Field._For-name     = "index-qualifier"
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "char".  

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "index-name"
  _Field._Data-Type    = "character"
  _Field._Initial      = ""   
  _Field._Mandatory    = yes
  _Field._Format       = "x(76)"
  _Field._Order        = 60   
  _Field._Fld-stdtype  = 36
  _Field._Fld-stoff    = 6
  _Field._For-name     = "index-name"
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "char".  

 
CREATE _Field. /* file: col$ */ 
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "Type" 
  _Field._Data-Type    = "integer"
  _Field._Initial      = "0"
  _Field._Mandatory    = yes
  _Field._Format       = "99999"
  _Field._Order        = 70
  _Field._Fld-stdtype  = 32
  _Field._Fld-stoff    = 7
  _Field._For-name     = "Type"
  _Field._For-type     = "smallint".

  
CREATE _Field. /* file: col$ */  
ASSIGN 
  _Field._File-recid   = RECID(_File) 
  _Field._Field-Name   = "seq-in-index" 
  _Field._Data-Type    = "integer" 
  _Field._Initial      = "0" 
  _Field._Mandatory    = yes 
  _Field._Format       = "99999" 
  _Field._Order        = 80  
  _Field._Fld-stdtype  = 32 
  _Field._Fld-stoff    = 8 
  _Field._For-name     = "seq-in-index"
  _Field._For-type     = "smallint".

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "Column-name"
  _Field._Data-Type    = "character"
  _Field._Initial      = ""
  _Field._Mandatory    = yes
  _Field._Format       = "x(76)"
  _Field._Order        = 90 
  _Field._Fld-stdtype  = 36
  _Field._Fld-stoff    = 9 
  _Field._For-name     = "Column-name"
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "char".

 
CREATE _Field. /* file: col$ */ 
ASSIGN 
  _Field._File-recid   = RECID(_File) 
  _Field._Field-Name   = "collation"
  _Field._Data-Type    = "character" 
  _Field._Initial      = "" 
  _Field._Mandatory    = yes
  _Field._Format       = "x(1)"
  _Field._Order        = 100 
  _Field._Fld-stdtype  = 36 
  _Field._Fld-stoff    = 10 
  _Field._For-name     = "collation" 
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "char".    
 
 
 
CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "Cardnality"
  _Field._Data-Type    = "integer"
  _Field._Initial      = "0"
  _Field._Mandatory    = yes
  _Field._Format       = "9999999999"
  _Field._Order        = 110 
  _Field._Fld-stdtype  = 33 
  _Field._Fld-stoff    = 11 
  _Field._For-name     = "Cardnality"
  _Field._For-type     = "integer".


CREATE _Field. /* file: col$ */  
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "Pages"
  _Field._Data-Type    = "integer"
  _Field._Initial      = "0"
  _Field._Mandatory    = yes
  _Field._Format       = "999999999"
  _Field._Order        = 120 
  _Field._Fld-stdtype  = 33 
  _Field._Fld-stoff    = 12 
  _Field._For-name     = "Pages"
  _Field._For-type     = "integer".  

/* Stored procedure for GetInfo ODBC call. */
CREATE _File.
ASSIGN
  _File._Db-recid     = dbkey
  _File._File-name    = "GetInfo"
  _File._ianum        = 6
  _File._For-type     = "PROCEDURE"
  _File._Last-change  = 2146431
  _File._Hidden       = TRUE
  _File._For-name     = "GetInfo"
  _File._For-Owner    = "".
 
CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "unused"
  _Field._Data-Type    = "integer"
  _Field._Initial      = "0"
  _Field._Mandatory    = yes
  _Field._Format       = "999999999"
  _Field._Order        = 10
  _Field._Fld-stdtype  = 33
  _Field._Fld-stoff    = 1
  _Field._For-name     = "unused"
  _Field._For-type     = "integer".

CREATE _File.
ASSIGN
  _File._Db-recid     = dbkey
  _File._File-name    = "GetInfo_buffer"
  _File._ianum        = 6
  _File._For-type     = "buffer"
  _File._Last-change  = 2146431
  _File._Hidden       = TRUE
  _File._For-name     = "GetInfo_buffer"
  _File._For-Owner    = "".
 
CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "escape_char"
  _Field._Data-Type    = "character"
  _Field._Initial      = ""
  _Field._Mandatory    = yes
  _Field._Format       = "x(1)"
  _Field._Order        = 10
  _Field._Fld-stdtype  = 36
  _Field._Fld-stoff    = 1
  _Field._For-name     = "escape_char"
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "char".

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "driver_name"
  _Field._Data-Type    = "character"
  _Field._Initial      = ""
  _Field._Mandatory    = yes
  _Field._Format       = "x(32)"
  _Field._Order        = 20
  _Field._Fld-stdtype  = 36
  _Field._Fld-stoff    = 2
  _Field._For-name     = "driver_name"
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "char".

CREATE _Field. /* file: col$ */ 
ASSIGN 
  _Field._File-recid   = RECID(_File) 
  _Field._Field-Name   = "driver_version" 
  _Field._Data-Type    = "character" 
  _Field._Initial      = "" 
  _Field._Mandatory    = yes 
  _Field._Format       = "x(32)" 
  _Field._Order        = 30  
  _Field._Fld-stdtype  = 36 
  _Field._Fld-stoff    = 3 
  _Field._For-name     = "driver_version" 
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "char".    

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "dbms_version"
  _Field._Data-Type    = "character"
  _Field._Initial      = ""
  _Field._Mandatory    = yes
  _Field._Format       = "x(32)"
  _Field._Order        = 40
  _Field._Fld-stdtype  = 36
  _Field._Fld-stoff    = 4
  _Field._For-name     = "dbms_version"
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "char".

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "odbc_version"
  _Field._Data-Type    = "character"
  _Field._Initial      = ""
  _Field._Mandatory    = yes
  _Field._Format       = "x(32)"
  _Field._Order        = 50
  _Field._Fld-stdtype  = 36
  _Field._Fld-stoff    = 5
  _Field._For-name     = "odbc_version"
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "char".

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "dbms_name"
  _Field._Data-Type    = "character"
  _Field._Initial      = ""
  _Field._Mandatory    = yes
  _Field._Format       = "x(32)"
  _Field._Order        = 60
  _Field._Fld-stdtype  = 36
  _Field._Fld-stoff    = 6
  _Field._For-name     = "dbms_name"
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "char".

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "prgrs_srvr_version"
  _Field._Data-Type    = "character"
  _Field._Initial      = ""
  _Field._Mandatory    = yes
  _Field._Format       = "x(32)"
  _Field._Order        = 70
  _Field._Fld-stdtype  = 36
  _Field._Fld-stoff    = 7
  _Field._For-name     = "prgrs_srvr_version"
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "char".

 
CREATE _Field. /* file: col$ */ 
ASSIGN 
  _Field._File-recid   = RECID(_File) 
  _Field._Field-Name   = "prgrs_clnt_version"
  _Field._Data-Type    = "character"  
  _Field._Initial      = ""    
  _Field._Mandatory    = yes 
  _Field._Format       = "x(32)" 
  _Field._Order        = 80    
  _Field._Fld-stdtype  = 36 
  _Field._Fld-stoff    = 8 
  _Field._For-name     = "prgrs_clnt_version" 
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "char".   
   
CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "quote_char"
  _Field._Data-Type    = "character"
  _Field._Initial      = ""
  _Field._Mandatory    = yes
  _Field._Format       = "x(1)"
  _Field._Order        = 90
  _Field._Fld-stdtype  = 36
  _Field._Fld-stoff    = 9
  _Field._For-name     = "quote_char"
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "char".

  
CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "do_extents"
  _Field._Data-Type    = "character"
  _Field._Initial      = ""
  _Field._Mandatory    = yes
  _Field._Format       = "x(1)"
  _Field._Order        = 100
  _Field._Fld-stdtype  = 36
  _Field._Fld-stoff    = 10 
  _Field._For-name     = "do_extents"
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "char".

 
/* Stored procedure for GetFieldIds ODBC call. */
CREATE _File.
ASSIGN
  _File._Db-recid     = dbkey
  _File._File-name    = "GetFieldIds"
  _File._ianum        = 6
  _File._For-type     = "PROCEDURE"
  _File._Last-change  = 2146431
  _File._Hidden       = TRUE
  _File._For-name     = "GetFieldIds"
  _File._For-Owner    = "".

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "logical-file-name"
  _Field._Data-Type    = "character"
  _Field._Initial      = ""
  _Field._Mandatory    = yes
  _Field._Format       = "x(76)"
  _Field._Order        = 10
  _Field._Fld-stdtype  = 36
  _Field._Fld-stoff    = 1
  _Field._For-name     = "logical-file-name"
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "char".
 

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "file-name"
  _Field._Data-Type    = "character"
  _Field._Initial      = ""
  _Field._Mandatory    = yes
  _Field._Format       = "x(76)"
  _Field._Order        = 20
  _Field._Fld-stdtype  = 36
  _Field._Fld-stoff    = 2
  _Field._For-name     = "file-name"
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "char".

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "file-num"
  _Field._Data-Type    = "integer"
  _Field._Initial      = "0"
  _Field._Mandatory    = yes
  _Field._Format       = "999999999"
  _Field._Order        = 30
  _Field._Fld-stdtype  = 33
  _Field._Fld-stoff    = 3
  _Field._For-name     = "file-num"
  _Field._For-type     = "integer".

 
CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "spcl-len"
  _Field._Data-Type    = "integer"
  _Field._Initial      = "0"
  _Field._Mandatory    = yes
  _Field._Format       = "999999999"
  _Field._Order        = 40
  _Field._Fld-stdtype  = 33
  _Field._Fld-stoff    = 4 
  _Field._For-name     = "spcl-len"
  _Field._For-type     = "smallint".

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "user-len"
  _Field._Data-Type    = "integer"
  _Field._Initial      = "0"
  _Field._Mandatory    = yes
  _Field._Format       = "999999999"
  _Field._Order        = 50
  _Field._Fld-stdtype  = 33
  _Field._Fld-stoff    = 5 
  _Field._For-name     = "user-len"
  _Field._For-type     = "smallint".

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "table-len"
  _Field._Data-Type    = "integer"
  _Field._Initial      = "0"
  _Field._Mandatory    = yes
  _Field._Format       = "999999999"
  _Field._Order        = 60
  _Field._Fld-stdtype  = 33
  _Field._Fld-stoff    = 6 
  _Field._For-name     = "table-len"
  _Field._For-type     = "smallint".

/* Stored procedure for GetFieldIds ODBC call. */
CREATE _File.
ASSIGN
  _File._Db-recid     = dbkey
  _File._File-name    = "GetFieldIds_buffer"
  _File._ianum        = 6
  _File._For-type     = "buffer"
  _File._Last-change  = 2146431
  _File._Hidden       = TRUE
  _File._For-name     = "GetFieldIds_buffer"
  _File._For-Owner    = "".


CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "field-name"
  _Field._Data-Type    = "character"
  _Field._Initial      = ""
  _Field._Mandatory    = yes
  _Field._Format       = "x(76)"
  _Field._Order        = 10
  _Field._Fld-stdtype  = 36
  _Field._Fld-stoff    = 1
  _Field._For-name     = "field-name"
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "char".

/* Stored procedure for sending an info string to PROGRESS. */
CREATE _File.
ASSIGN
  _File._Db-recid     = dbkey
  _File._File-name    = "SendInfo"
  _File._ianum        = 6
  _File._For-type     = "PROCEDURE"
  _File._Last-change  = 2146431
  _File._Hidden       = TRUE
  _File._For-name     = "SendInfo"
  _File._For-Owner    = "".

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "info"
  _Field._Data-Type    = "character"
  _Field._Initial      = ""
  _Field._Mandatory    = yes
  _Field._Format       = "x(76)"
  _Field._Order        = 10
  _Field._Fld-stdtype  = 36
  _Field._Fld-stoff    = 1
  _Field._For-name     = "info"
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "char".
 

/* Stored procedure for CloseAllProcs ODBC call. */
CREATE _File.
ASSIGN
  _File._Db-recid     = dbkey
  _File._File-name    = "CloseAllProcs"
  _File._ianum        = 6
  _File._For-type     = "PROCEDURE"
  _File._Last-change  = 2146431
  _File._Hidden       = TRUE
  _File._For-name     = "CloseAllProcs"
  _File._For-Owner    = "".

/* OE00195067 BEGIN: Stored procedure for SQLConstraintInfo ODBC call. */
CREATE _File.
ASSIGN
  _File._Db-recid     = dbkey
  _File._File-name    = "_Constraint_Info"
  _File._ianum        = 6
  _File._For-type     = "PROCEDURE"
  _File._Last-change  = 2146431
  _File._Hidden       = TRUE
  _File._For-name     = "_Constraint_Info"
  _File._For-Owner    = "".

CREATE _Field. /* file: SQLConstraintInfo$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "Qualifier"
  _Field._Data-Type    = "character"
  _Field._Initial      = ""
  _Field._Mandatory    = yes
  _Field._Format       = "x(76)"
  _Field._Order        = 10
  _Field._Fld-stdtype  = 36
  _Field._Fld-stoff    = 1
  _Field._For-name     = "Qualifier"
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "char".
 
/* OE00195067 END */

/* PROC-Q */
/* Generic Stored procedures buffer.					  */
CREATE _File.
ASSIGN
  _File._Db-recid     = dbkey
  _File._File-name    = "PROC-TEXT-BUFFER-Q"
  _File._ianum        = 6
  _File._For-type     = "GENERIC-BUFFER"
  _File._For-name     = "NONAME"
  _File._Last-change  = 2146431
  _File._Hidden       = TRUE.
  _File._For-Owner    = "".

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "proc-text-q"
  _Field._Data-Type    = "character"
  _Field._Initial      = ?
  _Field._Mandatory    = yes
  _Field._Format       = "x(76)"
  _Field._Order        = 10
  _Field._Fld-stdtype  = 36
  _Field._Fld-stoff    = 1
  _Field._For-name     = "NONAME"
  _Field._For-type     = "char".

/* Generic Stored procedures buffer.					  */
CREATE _File.
ASSIGN
  _File._Db-recid     = dbkey
  _File._File-name    = "PROC-TEXT-BUFFER"
  _File._ianum        = 6
  _File._For-type     = "GENERIC-BUFFER"
  _File._For-name     = "NONAME"
  _File._Last-change  = 2146431
  _File._Hidden       = TRUE.
  _File._For-Owner    = "".

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "proc-text"
  _Field._Data-Type    = "character"
  _Field._Initial      = ?
  _Field._Mandatory    = yes
  _Field._Format       = "x(76)"
  _Field._Order        = 10
  _Field._Fld-stdtype  = 36
  _Field._Fld-stoff    = 1
  _Field._For-name     = "NONAME"
  _Field._For-type     = "char".

/* Dummy Stored procedures SQL pass thru. 				*/
CREATE _File.
ASSIGN
  _File._Db-recid     = dbkey
  _File._File-name    = "SEND-SQL-STATEMENT"
  _File._ianum        = 6
  _File._For-type     = "PROCEDURE"
  _File._For-name     = "SEND-SQL-STATEMENT"
  _File._Last-change  = 2146431
  _File._Hidden       = TRUE.
 
CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "sql-statement"
  _Field._Data-Type    = "character"
  _Field._Initial      = ""
  _Field._Mandatory    = yes
  _Field._Format       = "x(76)"
  _Field._Order        = 10
  _Field._Fld-stdtype  = 36
  _Field._Fld-stoff    = 1
  _Field._For-name     = "sql-statement"
  _Field._For-type     = "char".

/*
   The following _file and _field records are for support of stored
   procedures in ODBC
*/
   
CREATE _File.
ASSIGN _File._Db-recid = dbkey
       _File._File-name = "SQLProcs_buffer"
       _File._ianum     = 6
       _File._For-type = "buffer"          /* FOREIGN-TYPE */
       _File._For-name = "SQLProcs_buffer" /* FOREIGN-NAME */
       _File._Hidden = yes
       _File._Dump-name = "SQLProcs1"      /* DUMP-NAME */
       _File._For-owner = ""               /* FOREIGN-OWNER */
       _File._Fil-misc1[1] = ?             /* PROGRESS-RECID */
       _File._Fil-misc1[3] = ?             /* INDEX-FREE-FLD */
       _File._Fil-misc2[4] = ? .           /* FLD-NAMES-LIST */
       
       
CREATE _Field.
ASSIGN _Field._File-recid = RECID(_File)
       _Field._Field-Name = "Qualifier"
       _Field._Data-Type = "character"
       _Field._Mandatory = yes             /* MANDATORY */
       _Field._Format = "x(76)"            /* FORMAT */
       _Field._Order = 10                  /* ORDER */
       _Field._Fld-stdtype = 36          
       _Field._Fld-stoff = 1               /* FOREIGN-POS */
       _Field._For-name = "Qualifier"      /* FOREIGN-NAME */
       _Field._For-type = "char"           /* FOREIGN-TYPE */
       _Field._Fld-misc1[1] = 500          /* DSRVR-PRECISION */
       _Field._Fld-misc1[2] = ?            /* DSRVR-SCALE */
       _Field._Fld-misc1[3] = ?            /* DSRVR-LENGTH */
       _Field._Fld-misc1[4] = ?            /* DSRVR-FLDMISC */
       _Field._Fld-misc2[4] = ?.           /* MISC-PROPERTIES */
       
       
CREATE _Field.
ASSIGN _Field._File-recid = RECID(_File)
       _Field._Field-Name = "Owner"
       _Field._Data-Type = "character"
       _Field._Mandatory = yes
       _Field._Format = "x(76)"
       _Field._Order = 20
       _Field._Fld-stdtype = 36
       _Field._Fld-stoff = 2
       _Field._For-name = "Owner"
       _Field._For-type = "char"
       _Field._Fld-misc1[1] = 500 
       _Field._Fld-misc1[2] = ? 
       _Field._Fld-misc1[3] = ? 
       _Field._Fld-misc1[4] = ? 
       _Field._Fld-misc2[4] = ?.
       
CREATE _Field.
ASSIGN _Field._File-recid = RECID(_File)
       _Field._Field-Name = "Name"
       _Field._Data-Type = "character"
       _Field._Mandatory = yes
       _Field._Format = "x(76)"
       _Field._Order = 30
       _Field._Fld-stdtype = 36
       _Field._Fld-stoff = 3
       _Field._For-name = "Name"
       _Field._For-type = "char"
       _Field._Fld-misc1[1] = 500 
       _Field._Fld-misc1[2] = ? 
       _Field._Fld-misc1[3] = ? 
       _Field._Fld-misc1[4] = ? 
       _Field._Fld-misc2[4] = ?.
       
CREATE _Field.
ASSIGN _Field._File-recid = RECID(_File)
       _Field._Field-Name = "num_input_parms"
       _Field._Data-Type = "integer"
       _Field._Mandatory = yes
       _Field._Format = "99999"
       _Field._Order = 40
       _Field._Fld-stdtype = 32
       _Field._Fld-stoff = 4
       _Field._For-name = "num_input_parms"
       _Field._For-type = "smallint"
       _Field._Fld-misc1[1] = ?
       _Field._Fld-misc1[2] = ?
       _Field._Fld-misc1[3] = ?
       _Field._Fld-misc1[4] = ?
       _Field._Fld-misc2[4] = ?.
       
CREATE _Field.
ASSIGN _Field._File-recid = RECID(_File)
       _Field._Field-Name = "num_output_parms"
       _Field._Data-Type = "integer"
       _Field._Mandatory = yes
       _Field._Format = "99999"
       _Field._Order = 50
       _Field._Fld-stdtype = 32
       _Field._Fld-stoff = 5
       _Field._For-name = "num_output_parms"
       _Field._For-type = "smallint"
       _Field._Fld-misc1[1] = ?
       _Field._Fld-misc1[2] = ?
       _Field._Fld-misc1[3] = ?
       _Field._Fld-misc1[4] = ?
       _Field._Fld-misc2[4] = ?.

CREATE _Field.
ASSIGN _Field._File-recid = RECID(_File)
       _Field._Field-Name = "num_result_sets"
       _Field._Data-Type = "integer"
       _Field._Mandatory = yes
       _Field._Format = "99999"
       _Field._Order = 60
       _Field._Fld-stdtype = 32
       _Field._Fld-stoff = 6
       _Field._For-name = "num_result_sets"
       _Field._For-type = "smallint"
       _Field._Fld-misc1[1] = ?
       _Field._Fld-misc1[2] = ?
       _Field._Fld-misc1[3] = ?
       _Field._Fld-misc1[4] = ?
       _Field._Fld-misc2[4] = ?.

CREATE _Field.
ASSIGN _Field._File-recid = RECID(_File)
       _Field._Field-Name = "Remarks"
       _Field._Data-Type = "character"
       _Field._Mandatory = yes
       _Field._Format = "x(76)"
       _Field._Order = 70
       _Field._Fld-stdtype = 36
       _Field._Fld-stoff = 7
       _Field._For-name = "Remarks"
       _Field._For-type = "char"
       _Field._Fld-misc1[1] = 500
       _Field._Fld-misc1[2] = ? 
       _Field._Fld-misc1[3] = ? 
       _Field._Fld-misc1[4] = ? 
       _Field._Fld-misc2[4] = ?.
       
CREATE _Field.
ASSIGN _Field._File-recid = RECID(_File)
       _Field._Field-Name = "Procedure_type"
       _Field._Data-Type = "integer"
       _Field._Mandatory = yes
       _Field._Format = "99999"
       _Field._Order = 80
       _Field._Fld-stdtype = 32
       _Field._Fld-stoff = 8
       _Field._For-name = "Procedure_type"
       _Field._For-type = "smallint"
       _Field._Fld-misc1[1] = ?
       _Field._Fld-misc1[2] = ?
       _Field._Fld-misc1[3] = ?
       _Field._Fld-misc1[4] = ?
       _Field._Fld-misc2[4] = ?.


create _File.
assign _File._Db-recid = dbkey
       _File._File-name = "SQLProcCols_buffer"
       _File._ianum     = 6
       _File._For-type = "buffer" 
       _File._For-name = "SQLProcCols_buffer"    
       _File._Hidden = yes
       _File._Dump-name = "SQLProcCols1"   
       _File._For-owner = ""      
       _File._Fil-misc1[1] = ?        
       _File._Fil-misc1[3] = ?      
       _File._Fil-misc2[4] = ?.      
     
       
create _Field.
assign _Field._File-recid = RECID(_File)
       _Field._Field-Name = "Qualifier"
       _Field._Data-Type = "character"
       _Field._Mandatory = yes          
       _Field._Format = "x(76)"    
       _Field._Order = 10       
       _Field._Fld-stdtype = 36          
       _Field._Fld-stoff = 1           
       _Field._For-name = "Qualifier"   
       _Field._For-type = "char"    
       _Field._Fld-misc1[1] = 500    
       _Field._Fld-misc1[2] = ?     
       _Field._Fld-misc1[3] = ?     
       _Field._Fld-misc1[4] = ?     
       _Field._Fld-misc2[4] = ?.     
       
       
create _Field.
assign _Field._File-recid = RECID(_File)
       _Field._Field-Name = "Owner"
       _Field._Data-Type = "character"
       _Field._Mandatory = yes
       _Field._Format = "x(76)"
       _Field._Order = 20
       _Field._Fld-stdtype = 36
       _Field._Fld-stoff = 2
       _Field._For-name = "Owner"
       _Field._For-type = "char"
       _Field._Fld-misc1[1] = 500 
       _Field._Fld-misc1[2] = ? 
       _Field._Fld-misc1[3] = ? 
       _Field._Fld-misc1[4] = ? 
       _Field._Fld-misc2[4] = ?.
       
create _Field.
assign _Field._File-recid = RECID(_File)
       _Field._Field-Name = "Name"
       _Field._Data-Type = "character"
       _Field._Mandatory = yes
       _Field._Format = "x(76)"
       _Field._Order = 30
       _Field._Fld-stdtype = 36
       _Field._Fld-stoff = 3
       _Field._For-name = "Name"
       _Field._For-type = "char"
       _Field._Fld-misc1[1] = 500 
       _Field._Fld-misc1[2] = ? 
       _Field._Fld-misc1[3] = ? 
       _Field._Fld-misc1[4] = ? 
       _Field._Fld-misc2[4] = ?.
       
create _Field.
assign _Field._File-recid = RECID(_File)
       _Field._Field-Name = "Column-Name"
       _Field._Data-Type = "character"
       _Field._Mandatory = yes
       _Field._Format = "x(76)"
       _Field._Order = 40
       _Field._Fld-stdtype = 36
       _Field._Fld-stoff = 4
       _Field._For-name = "Column-Name"
       _Field._For-type = "char"
       _Field._Fld-misc1[1] = 500 
       _Field._Fld-misc1[2] = ? 
       _Field._Fld-misc1[3] = ? 
       _Field._Fld-misc1[4] = ? 
       _Field._Fld-misc2[4] = ?.


create _Field.
assign _Field._File-recid = RECID(_File)
       _Field._Field-Name = "Column-Type"
       _Field._Data-Type = "integer"
       _Field._Mandatory = yes
       _Field._Format = "99999"
       _Field._Order = 50
       _Field._Fld-stdtype = 32
       _Field._Fld-stoff = 5
       _Field._For-name = "Column-Type"
       _Field._For-type = "smallint"
       _Field._Fld-misc1[1] = ? 
       _Field._Fld-misc1[2] = ? 
       _Field._Fld-misc1[3] = ? 
       _Field._Fld-misc1[4] = ? 
       _Field._Fld-misc2[4] = ?.
       
create _Field.
assign _Field._File-recid = RECID(_File)
       _Field._Field-Name = "Data-Type"
       _Field._Data-Type = "integer"
       _Field._Mandatory = yes
       _Field._Format = "99999"
       _Field._Order = 60
       _Field._Fld-stdtype = 32
       _Field._Fld-stoff = 6
       _Field._For-name = "Data-Type"
       _Field._For-type = "smallint"
       _Field._Fld-misc1[1] = ? 
       _Field._Fld-misc1[2] = ? 
       _Field._Fld-misc1[3] = ? 
       _Field._Fld-misc1[4] = ? 
       _Field._Fld-misc2[4] = ?.
       
create _Field.
assign _Field._File-recid = RECID(_File)
       _Field._Field-Name = "Type-Name"
       _Field._Data-Type = "character"
       _Field._Mandatory = yes
       _Field._Format = "x(76)"
       _Field._Order = 70
       _Field._Fld-stdtype = 36
       _Field._Fld-stoff = 7
       _Field._For-name = "Type-Name"
       _Field._For-type = "char"
       _Field._Fld-misc1[1] = 500 
       _Field._Fld-misc1[2] = ? 
       _Field._Fld-misc1[3] = ? 
       _Field._Fld-misc1[4] = ? 
       _Field._Fld-misc2[4] = ?.


create _Field.
assign _Field._File-recid = RECID(_File)
       _Field._Field-Name = "Precision"
       _Field._Data-Type = "integer"
       _Field._Mandatory = yes
       _Field._Format = "999999999"
       _Field._Order = 80
       _Field._Fld-stdtype = 33
       _Field._Fld-stoff = 8
       _Field._For-name = "Precision"
       _Field._For-type = "integer"
       _Field._Fld-misc1[1] = ? 
       _Field._Fld-misc1[2] = ? 
       _Field._Fld-misc1[3] = ? 
       _Field._Fld-misc1[4] = ? 
       _Field._Fld-misc2[4] = ?.

create _Field.
assign _Field._File-recid = RECID(_File)
       _Field._Field-Name = "Length"
       _Field._Data-Type = "integer"
       _Field._Mandatory = yes
       _Field._Format = "999999999"
       _Field._Order = 90
       _Field._Fld-stdtype = 33
       _Field._Fld-stoff = 9
       _Field._For-name = "Length"
       _Field._For-type = "integer"
       _Field._Fld-misc1[1] = ? 
       _Field._Fld-misc1[2] = ? 
       _Field._Fld-misc1[3] = ? 
       _Field._Fld-misc1[4] = ? 
       _Field._Fld-misc2[4] = ?.


create _Field.
assign _Field._File-recid = RECID(_File)
       _Field._Field-Name = "Scale"
       _Field._Data-Type = "integer"
       _Field._Mandatory = yes
       _Field._Format = "99999"
       _Field._Order = 100
       _Field._Fld-stdtype = 32
       _Field._Fld-stoff = 10
       _Field._For-name = "Scale"
       _Field._For-type = "smallint"
       _Field._Fld-misc1[1] = ? 
       _Field._Fld-misc1[2] = ? 
       _Field._Fld-misc1[3] = ? 
       _Field._Fld-misc1[4] = ? 
       _Field._Fld-misc2[4] = ?.

create _Field.
assign _Field._File-recid = RECID(_File)
       _Field._Field-Name = "Radix"
       _Field._Data-Type = "integer"
       _Field._Mandatory = yes
       _Field._Format = "99999"
       _Field._Order = 110
       _Field._Fld-stdtype = 32
       _Field._Fld-stoff = 11
       _Field._For-name = "Radix"
       _Field._For-type = "Smallint"
       _Field._Fld-misc1[1] = ? 
       _Field._Fld-misc1[2] = ? 
       _Field._Fld-misc1[3] = ? 
       _Field._Fld-misc1[4] = ? 
       _Field._Fld-misc2[4] = ?.

create _Field.
assign _Field._File-recid = RECID(_File)
       _Field._Field-Name = "Nullable"
       _Field._Data-Type = "integer"
       _Field._Mandatory = yes
       _Field._Format = "99999"
       _Field._Order = 120
       _Field._Fld-stdtype = 32
       _Field._Fld-stoff = 12
       _Field._For-name = "Nullable"
       _Field._For-type = "smallint"
       _Field._Fld-misc1[1] = ? 
       _Field._Fld-misc1[2] = ? 
       _Field._Fld-misc1[3] = ? 
       _Field._Fld-misc1[4] = ? 
       _Field._Fld-misc2[4] = ?.


create _Field.
assign _Field._File-recid = RECID(_File)
       _Field._Field-Name = "Remarks"
       _Field._Data-Type = "character"
       _Field._Mandatory = yes
       _Field._Format = "x(76)"
       _Field._Order = 130
       _Field._Fld-stdtype = 36
       _Field._Fld-stoff = 13
       _Field._For-name = "Remarks"
       _Field._For-type = "char"
       _Field._Fld-misc1[1] = 500 
       _Field._Fld-misc1[2] = ? 
       _Field._Fld-misc1[3] = ? 
       _Field._Fld-misc1[4] = ? 
       _Field._Fld-misc2[4] = ?.

/* Stored procedure for SQLSpecialColumns_buffer ODBC call. */
CREATE _File.
ASSIGN
  _File._Db-recid     = dbkey
  _File._File-name    = "SQLSpecialColumns_buffer"
  _File._ianum        = 6
  _File._For-type     = "buffer"
  _File._Last-change  = 2146431
  _File._Hidden       = TRUE
  _File._For-name     = "SQLSpecialColumns_buffer"
  _File._For-Owner    = "".


CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "Scope"
  _Field._Data-Type    = "integer"
  _Field._Initial      = ""
  _Field._Mandatory    = yes
  _Field._Format       = "99999"
  _Field._Order        = 10
  _Field._Fld-stdtype  = 32
  _Field._Fld-stoff    = 1
  _Field._For-name     = "Scope"
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "smallint".

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "Column-name"
  _Field._Data-Type    = "character"
  _Field._Initial      = ""
  _Field._Mandatory    = yes
  _Field._Format       = "x(76)"
  _Field._Order        = 20
  _Field._Fld-stdtype  = 36
  _Field._Fld-stoff    = 2
  _Field._For-name     = "Column-name"
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "char".

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "Data-type"
  _Field._Data-Type    = "integer"
  _Field._Initial      = "0" 
  _Field._Mandatory    = yes
  _Field._Format       = "99999"
  _Field._Order        = 30
  _Field._Fld-stdtype  = 32
  _Field._Fld-stoff    = 3
  _Field._For-name     = "Data-type"
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "smallint".

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "Type-name"
  _Field._Data-Type    = "character"
  _Field._Initial      = ""   
  _Field._Mandatory    = yes
  _Field._Format       = "x(76)"
  _Field._Order        = 40   
  _Field._Fld-stdtype  = 36
  _Field._Fld-stoff    = 4
  _Field._For-name     = "Type-name"
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "char".  

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "Precision"
  _Field._Data-Type    = "integer"
  _Field._Initial      = "0"
  _Field._Mandatory    = yes
  _Field._Format       = "9999999999"
  _Field._Order        = 50
  _Field._Fld-stdtype  = 33 
  _Field._Fld-stoff    = 5
  _Field._For-name     = "Precision"
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "integer".


CREATE _Field. /* file: col$ */  
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "Length"
  _Field._Data-Type    = "integer"
  _Field._Initial      = "0"
  _Field._Mandatory    = yes
  _Field._Format       = "999999999"
  _Field._Order        = 60
  _Field._Fld-stdtype  = 33 
  _Field._Fld-stoff    = 6
  _Field._For-name     = "Length"
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "integer".  
 
CREATE _Field. /* file: col$ */  
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "Scale"  
  _Field._Data-Type    = "integer"
  _Field._Initial      = "0"
  _Field._Mandatory    = yes
  _Field._Format       = "99999"
  _Field._Order        = 70
  _Field._Fld-stdtype  = 32
  _Field._Fld-stoff    = 7
  _Field._For-name     = "Scale"
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "smallint".
 
CREATE _Field. /* file: col$ */  
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "pseudo"  
  _Field._Data-Type    = "integer"
  _Field._Initial      = "0"
  _Field._Mandatory    = yes
  _Field._Format       = "99999"
  _Field._Order        = 80
  _Field._Fld-stdtype  = 32
  _Field._Fld-stoff    = 8
  _Field._For-name     = "Pseudo"
  _Field._Fld-misc1[1] = 500
  _Field._For-type     = "smallint".
 
CREATE _File.
ASSIGN _File._Db-recid = dbkey
       _File._File-name = "SQLProcedures"
       _File._ianum     = 6
       _File._For-type = "PROCEDURE"      
       _File._For-name = "SQLProcedures"  
       _File._Hidden = yes
       _File._Dump-name = "SQLProcedures" 
       _File._For-owner = ""              
       _File._Fil-misc1[1] = ?            
       _File._Fil-misc1[3] = ?            
       _File._Fil-misc2[4] = ?.          
      
       
CREATE _Field.
ASSIGN _Field._File-recid = RECID(_File)
       _Field._Field-Name = "Qualifier"
       _Field._Data-Type = "character"
       _Field._Mandatory = yes           
       _Field._Format = "x(76)"          
       _Field._Order = 10              
       _Field._Fld-stdtype = 36          
       _Field._Fld-stoff = 1           
       _Field._For-name = "Qualifier"  
       _Field._For-type = "char"        
       _Field._Fld-misc1[1] = 500       
       _Field._Fld-misc1[2] = ?         
       _Field._Fld-misc1[3] = ?         
       _Field._Fld-misc1[4] = ?         
       _Field._Fld-misc2[4] = ?.        
       
       
CREATE _Field.
ASSIGN _Field._File-recid = RECID(_File)
       _Field._Field-Name = "Owner"
       _Field._Data-Type = "character"
       _Field._Mandatory = yes
       _Field._Format = "x(76)"
       _Field._Order = 20
       _Field._Fld-stdtype = 36
       _Field._Fld-stoff = 2
       _Field._For-name = "Owner"
       _Field._For-type = "char"
       _Field._Fld-misc1[1] = 500 
       _Field._Fld-misc1[2] = ? 
       _Field._Fld-misc1[3] = ? 
       _Field._Fld-misc1[4] = ? 
       _Field._Fld-misc2[4] = ?.
       
CREATE _Field.
ASSIGN _Field._File-recid = RECID(_File)
       _Field._Field-Name = "Name"
       _Field._Data-Type = "character"
       _Field._Mandatory = yes
       _Field._Format = "x(76)"
       _Field._Order = 30
       _Field._Fld-stdtype = 36
       _Field._Fld-stoff = 3
       _Field._For-name = "Name"
       _Field._For-type = "char"
       _Field._Fld-misc1[1] = 500 
       _Field._Fld-misc1[2] = ? 
       _Field._Fld-misc1[3] = ? 
       _Field._Fld-misc1[4] = ? 
       _Field._Fld-misc2[4] = ?.
       
CREATE _File.
ASSIGN _File._Db-recid = dbkey
       _File._File-name = "SQLProcColumns"
       _File._ianum     = 6
       _File._For-type = "PROCEDURE" 
       _File._For-name = "SQLProcColumns"
       _File._Hidden = yes
       _File._Dump-name = "SQLProcColumns"
       _File._For-owner = ""      
       _File._Fil-misc1[1] = ?    
       _File._Fil-misc1[3] = ?    
       _File._Fil-misc2[4] = ?.
       
CREATE _Field.
ASSIGN _Field._File-recid = RECID(_File)
       _Field._Field-Name = "Qualifier"
       _Field._Data-Type = "character"
       _Field._Mandatory = yes
       _Field._Format = "x(76)"
       _Field._Order = 10      
       _Field._Fld-stdtype = 36          
       _Field._Fld-stoff = 1   
       _Field._For-name = "Qualifier" 
       _Field._For-type = "char"     
       _Field._Fld-misc1[1] = 500    
       _Field._Fld-misc1[2] = ?      
       _Field._Fld-misc1[3] = ?      
       _Field._Fld-misc1[4] = ?      
       _Field._Fld-misc2[4] = ?.
       
CREATE _Field.
ASSIGN _Field._File-recid = RECID(_File)
       _Field._Field-Name = "Owner"
       _Field._Data-Type = "character"
       _Field._Mandatory = yes
       _Field._Format = "x(76)"
       _Field._Order = 20
       _Field._Fld-stdtype = 36
       _Field._Fld-stoff = 2
       _Field._For-name = "Owner"
       _Field._For-type = "char"
       _Field._Fld-misc1[1] = 500
       _Field._Fld-misc1[2] = ? 
       _Field._Fld-misc1[3] = ? 
       _Field._Fld-misc1[4] = ? 
       _Field._Fld-misc2[4] = ?.
       
CREATE _Field.
ASSIGN _Field._File-recid = RECID(_File)
       _Field._Field-Name = "ProcName"
       _Field._Data-Type = "character"
       _Field._Mandatory = yes
       _Field._Format = "x(76)"
       _Field._Order = 30
       _Field._Fld-stdtype = 36
       _Field._Fld-stoff = 3
       _Field._For-name = "ProcName"
       _Field._For-type = "char"
       _Field._Fld-misc1[1] = 500
       _Field._Fld-misc1[2] = ? 
       _Field._Fld-misc1[3] = ? 
       _Field._Fld-misc1[4] = ? 
       _Field._Fld-misc2[4] = ?.

CREATE _Field.
ASSIGN _Field._File-recid = RECID(_File)
       _Field._Field-Name = "ColName"
       _Field._Data-Type = "character"
       _Field._Mandatory = yes
       _Field._Format = "x(76)"
       _Field._Order = 40
       _Field._Fld-stdtype = 36
       _Field._Fld-stoff = 4
       _Field._For-name = "ColName"
       _Field._For-type = "char"
       _Field._Fld-misc1[1] = 500
       _Field._Fld-misc1[2] = ? 
       _Field._Fld-misc1[3] = ? 
       _Field._Fld-misc1[4] = ? 
       _Field._Fld-misc2[4] = ?.

/***** Prime Index to RECID support - Begin code change *********************/ 

/* Stored procedure for SQLSpecialColumns ODBC call. */
CREATE _File.
ASSIGN
  _File._Db-recid     = dbkey 
  _File._File-name    = "SQLSpecialColumns"
  _File._ianum        = 6
  _File._For-type     = "PROCEDURE"
  _File._For-name     = "SQLSpecialColumns"
  _File._Hidden       = TRUE
  _File._Dump-name     = "SQLSpecialColumns"
  _File._For-Owner    = "".

CREATE _Field.
ASSIGN _Field._File-recid = RECID(_File)
       _Field._Field-Name = "Qualifier"
       _Field._Data-Type = "character"
       _Field._Mandatory = yes
       _Field._Format = "x(76)"
       _Field._Order = 10      
       _Field._Fld-stdtype = 36          
       _Field._Fld-stoff = 1   
       _Field._For-name = "Qualifier" 
       _Field._For-type = "char"     
       _Field._Fld-misc1[1] = 500    
       _Field._Fld-misc1[2] = ?      
       _Field._Fld-misc1[3] = ?      
       _Field._Fld-misc1[4] = ?      
       _Field._Fld-misc2[4] = ?.
       
CREATE _Field.
ASSIGN _Field._File-recid = RECID(_File)
       _Field._Field-Name = "Owner"
       _Field._Data-Type = "character"
       _Field._Mandatory = yes
       _Field._Format = "x(76)"
       _Field._Order = 20
       _Field._Fld-stdtype = 36
       _Field._Fld-stoff = 2
       _Field._For-name = "Owner"
       _Field._For-type = "char"
       _Field._Fld-misc1[1] = 500
       _Field._Fld-misc1[2] = ? 
       _Field._Fld-misc1[3] = ? 
       _Field._Fld-misc1[4] = ? 
       _Field._Fld-misc2[4] = ?.
       
CREATE _Field.
ASSIGN _Field._File-recid = RECID(_File)
       _Field._Field-Name = "TableName"
       _Field._Data-Type = "character"
       _Field._Mandatory = yes
       _Field._Format = "x(76)"
       _Field._Order = 30
       _Field._Fld-stdtype = 36
       _Field._Fld-stoff = 3
       _Field._For-name = "TableName"
       _Field._For-type = "char"
       _Field._Fld-misc1[1] = 500
       _Field._Fld-misc1[2] = ? 
       _Field._Fld-misc1[3] = ? 
       _Field._Fld-misc1[4] = ? 
       _Field._Fld-misc2[4] = ?.

/***** Prime Index to RECID support - End of code change *********************/ 

RETURN.
