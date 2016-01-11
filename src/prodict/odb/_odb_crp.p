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

/* ODBC stored procedures definitions 

  History:  DLM 01/28/98 Added files to handle procedures
  
*/

DEFINE INPUT PARAMETER dbkey AS RECID NO-UNDO.

FIND _File
  WHERE _File._Db-recid = dbkey
    AND _File._File-name = "SQLTables" NO-ERROR.
IF AVAILABLE _File THEN DO:
  find _db where RECID(_Db) = dbkey.
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

 

RETURN.
