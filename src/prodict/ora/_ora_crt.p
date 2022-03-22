/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* _ora_crt - base argument for oracle meta-schema

   Created 03/10/98 D. McMann  Creating _file for TableSpaces
    
  Modified: DLM 07/13/98 Added _Owner to _File Find       
   
*/

DEFINE INPUT PARAMETER dbkey AS RECID NO-UNDO.

IF dbkey = ? THEN RETURN.

FIND _Db WHERE RECID(_Db) = dbkey NO-LOCK NO-ERROR.

IF NOT AVAILABLE _Db THEN RETURN.

ELSE IF _Db._Db-type <> "ORACLE" THEN RETURN.

FIND _File
  WHERE _File._Db-recid = dbkey
    AND _File._File-name = "oracle_tablespace" 
    AND (_File._Owner = "_FOREIGN" OR _File._owner = "PUB") NO-ERROR.
IF AVAILABLE _File THEN RETURN.

CREATE _File.
ASSIGN
  _File._Db-recid    = dbkey
  _File._File-name   = "oracle_tablespace"
  _File._For-Type    = "TABLE"
  _File._For-Name    = "ts$"
  _File._For-Owner   = "sys"
  _File._ianum = 6
  _File._Last-change = 2146431
  _File._Hidden      = TRUE.

CREATE _Field. /* file: ts$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "TS#"
  _Field._Data-Type    = "integer"
  _Field._Initial      = ?
  _Field._Mandatory    = yes
  _Field._Format       = "->>>>>>>>>9"
  _Field._Order        = 10
  _Field._Fld-stdtype  = 8192
  _Field._Fld-stoff    = 1
  _Field._For-maxsize  = 10
  _Field._For-Name = "TS#"
  _Field._For-Type = "number".

CREATE _Field. /* file: ts$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "NAME"
  _Field._Data-Type    = "character"
  _Field._Initial      = ?
  _Field._Mandatory    = YES
  _Field._Format       = "x(30)"
  _Field._Decimal      = 30
  _Field._Order        = 20
  _Field._Fld-stdtype  = 4096
  _Field._Fld-stoff    = 2
  _Field._For-maxsize  = 30
  _Field._For-Name = "NAME"
  _Field._For-Type = "VarChar2".

CREATE _Field. /* file: ts$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "OWNER#"
  _Field._Data-Type    = "integer"
  _Field._Initial      = ?
  _Field._Mandatory    = YES
  _Field._Format       = "->>>>>>>>>9"
  _Field._Order        = 30
  _Field._Fld-stdtype  = 8192
  _Field._Fld-stoff    = 3
  _Field._For-maxsize  = 10
  _Field._For-Name = "OWNER#"
  _Field._For-Type = "number".

CREATE _Field. /* file: ts$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "ONLINE$"
   _Field._Data-Type    = "integer"
  _Field._Initial      = ?
  _Field._Mandatory    = YES
  _Field._Format       = "->>>>>>>>>9"
  _Field._Order        = 40
  _Field._Fld-stdtype  = 8192
  _Field._Fld-stoff    = 4
  _Field._For-maxsize  = 10  
  _Field._For-Name =  "ONLINE$"
  _Field._For-Type = "number".

CREATE _Field. /* file: ts$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "UNDOFILE#"
  _Field._Data-Type    = "integer"
  _Field._Initial      = ?
  _Field._Mandatory    = NO
  _Field._Format       = "->>>>>>>>>9"
  _Field._Order        = 50
  _Field._Fld-stdtype  = 8192
  _Field._Fld-stoff    = 5
  _Field._For-maxsize  = 10  
  _Field._For-Name = "UNDOFILE#"
  _Field._For-Type = "number".

CREATE _Field. /* file: ts$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "UNDOBLOCK#"
  _Field._Data-Type    = "integer"
  _Field._Initial      = ?
  _Field._Mandatory    = no
  _Field._Format       = "->>>>>>>>>9"
  _Field._Order        = 60
  _Field._Fld-stdtype  = 8192
  _Field._Fld-stoff    = 6
  _Field._For-maxsize  = 10
  _Field._For-Name = "UNDOBLOCK#"
  _Field._For-Type = "number".

CREATE _Field. /* file: ts$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "BLOCKSIZE"
  _Field._Data-Type    = "integer"
  _Field._Initial      = ?
  _Field._Mandatory    = yes
  _Field._Format       = "->>>>>>>>>9"
  _Field._Order        = 70
  _Field._Fld-stdtype  = 8192
  _Field._Fld-stoff    = 7
  _Field._For-maxsize  = 10  
  _Field._For-Name = "BLOCKSIZE"
  _Field._For-Type = "number".

CREATE _Field. /* file: ts$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "INC#"
  _Field._Data-Type    = "integer"
  _Field._Initial      = ?
  _Field._Mandatory    = YES
  _Field._Format       = "->>>>>>>>>9"
  _Field._Order        = 80
  _Field._Fld-stdtype  = 8192
  _Field._Fld-stoff    = 8
  _Field._For-maxsize  = 10  
  _Field._For-Name     = "INC#"
  _Field._For-Type = "number".

CREATE _Field. /* file: ts$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "SCNWRP"
  _Field._Data-Type    = "integer"
  _Field._Initial      = ?
  _Field._Mandatory    = no
  _Field._Format       = "->>>>>>>>>9"
  _Field._Order        = 90
  _Field._Fld-stdtype  = 8192
  _Field._Fld-stoff    = 9
  _Field._For-maxsize  = 10  
  _Field._For-Name = "SCNWRP"
  _Field._For-Type = "number".

CREATE _Field. /* file: ts$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "SCNBAS"
  _Field._Data-Type    = "integer"
  _Field._Initial      = ?
  _Field._Mandatory    = no
  _Field._Format       = "->>>>>>>>>9"
  _Field._Order        = 100
  _Field._Fld-stdtype  = 8192
  _Field._Fld-stoff    = 10
  _Field._For-maxsize  = 10  
  _Field._For-Name = "SCNBAS"
  _Field._For-Type = "number".

CREATE _Field. /* file: ts$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "DFLMINEXT"
  _Field._Data-Type    = "integer"
  _Field._Initial      = ?
  _Field._Mandatory    = YES
  _Field._Format       = "->>>>>>>>>9"
  _Field._Order        = 110
  _Field._Fld-stdtype  = 8192
  _Field._Fld-stoff    = 11
  _Field._For-maxsize  = 10  
  _Field._For-Name = "DFLMINEXT"
  _Field._For-Type = "number".

CREATE _Field. /* file: ts$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "DFLMAXEXT"
  _Field._Data-Type    = "integer"
  _Field._Initial      = ?
  _Field._Mandatory    = YES
  _Field._Format       = "->>>>>>>>>9"
  _Field._Order        = 120
  _Field._Fld-stdtype  = 8192
  _Field._Fld-stoff    = 12
  _Field._For-maxsize  = 10  
  _Field._For-Name =  "DFLMAXEXT"
  _Field._For-Type = "number".

CREATE _Field. /* file: ts$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "DFLINIT"
  _Field._Data-Type    = "integer"
  _Field._Initial      = ?
  _Field._Mandatory    = YES
  _Field._Format       = "->>>>>>>>>9"
  _Field._Order        = 130
  _Field._Fld-stdtype  = 8192
  _Field._Fld-stoff    = 13
  _Field._For-maxsize  = 10  
  _Field._For-Name = "DFLINIT"
  _Field._For-Type = "number".

CREATE _Field. /* file: ts$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "DFLINCR"
  _Field._Data-Type    = "integer"
  _Field._Initial      = ?
  _Field._Mandatory    = yes
  _Field._Format       = "->>>>>>>>>9"
  _Field._Order        = 140
  _Field._Fld-stdtype  = 8192
  _Field._Fld-stoff    = 14
  _Field._For-maxsize  = 10  
  _Field._For-Name = "DFLINCR"
  _Field._For-Type = "number".
  
CREATE _Field. /* file: ts$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "DFLEXTPCT"
  _Field._Data-Type    = "integer"
  _Field._Initial      = ?
  _Field._Mandatory    = YES
  _Field._Format       = "->>>>>>>>>9"
  _Field._Order        = 150
  _Field._Fld-stdtype  = 8192
  _Field._Fld-stoff    = 15
  _Field._For-maxsize  = 10  
  _Field._For-Name = "DFLEXTPCT"
  _Field._For-Type = "number".
  

RETURN.


