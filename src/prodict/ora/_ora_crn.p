/*********************************************************************
* Copyright (C) 2011 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* _ora_crn - base constraints for oracle meta-schema 

   Modified:  kmayur 06/21/11 created 

*/

DEFINE INPUT PARAMETER dbkey AS RECID NO-UNDO.

FIND _Db WHERE RECID(_Db) = dbkey NO-LOCK NO-ERROR.

FIND _File
  WHERE _File._Db-recid = dbkey
    AND _File._File-name = "oracle_constraint" 
    AND _File._Owner = "_FOREIGN" NO-ERROR.
IF AVAILABLE _File THEN RETURN.

CREATE _File.
ASSIGN
  _File._Db-recid    = dbkey
  _File._File-name   = "oracle_constraint"
  _File._For-Type    = "TABLE"
  _File._For-Name    = "con$"
  _File._For-Owner   = "sys"
  _File._Last-change = 2146431
  _File._ianum       = 6
  _File._Hidden      = TRUE.

CREATE _Field. /* file: con$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "NAME"
  _Field._Data-Type    = "character"
  _Field._Initial      = ?
  _Field._Mandatory    = YES
  _Field._Format       = "x(30)"
  _Field._Decimal      = 30
  _Field._Order        = 10
  _Field._Fld-stdtype  = 4096
  _Field._Fld-stoff    = 1
  _Field._For-maxsize  = 30
  _Field._For-Name     = "NAME"
  _Field._For-Type     = "VarChar2".


CREATE _Field. /* file: con$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "CON#"
  _Field._Data-Type    = "integer"
  _Field._Initial      = ?
  _Field._Mandatory    = yes
  _Field._Format       = "->>>>>>>>>9"
  _Field._Order        = 20
  _Field._Fld-stdtype  = 8192
  _Field._Fld-stoff    = 2
  _Field._For-Maxsize  = 12
  _Field._For-Name     = "CON#"
  _Field._For-Type     = "number".

FIND _File
  WHERE _File._Db-recid = dbkey
    AND _File._File-name = "oracle_cons" 
    AND _File._Owner = "_FOREIGN" NO-ERROR.
IF AVAILABLE _File THEN RETURN.

CREATE _File.
ASSIGN
  _File._Db-recid    = dbkey
  _File._File-name   = "oracle_cons"
  _File._For-Type    = "TABLE"
  _File._For-Name    = "cdef$"
  _File._For-Owner   = "sys"
  _File._Last-change = 2146431
  _File._ianum       = 6
  _File._Hidden      = TRUE.

CREATE _Field. /* file: cdef$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "CON#"
  _Field._Data-Type    = "integer"
  _Field._Initial      = ?
  _Field._Mandatory    = yes
  _Field._Format       = "->>>>>>>>>9"
  _Field._Order        = 10
  _Field._Fld-stdtype  = 8192
  _Field._Fld-stoff    = 1
  _Field._For-Maxsize  = 12
  _Field._For-Name     = "CON#"
  _Field._For-Type     = "number".
  
CREATE _Field. /* file: cdef$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "OBJ#"
  _Field._Data-Type    = "integer"
  _Field._Initial      = ?
  _Field._Mandatory    = yes
  _Field._Format       = "->>>>>>>>>9"
  _Field._Order        = 20
  _Field._Fld-stdtype  = 8192
  _Field._Fld-stoff    = 2
  _Field._For-Maxsize  = 12
  _Field._For-Name     = "OBJ#"
  _Field._For-Type     = "number".  
  
CREATE _Field. /* file: cdef$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "TYPE#"
  _Field._Data-Type    = "integer"
  _Field._Initial      = ?
  _Field._Mandatory    = yes
  _Field._Format       = "->>>>>>>>>9"
  _Field._Order        = 30
  _Field._Fld-stdtype  = 8192
  _Field._Fld-stoff    = 3
  _Field._For-Maxsize  = 12
  _Field._For-Name     = "TYPE#"
  _Field._For-Type     = "number".    


CREATE _Field. /* file: cdef$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "ROBJ#"
  _Field._Data-Type    = "integer"
  _Field._Initial      = ?
  _Field._Mandatory    = no
  _Field._Format       = "->>>>>>>>>9"
  _Field._Order        = 40
  _Field._Fld-stdtype  = 8192
  _Field._Fld-stoff    = 4
  _Field._For-Maxsize  = 12
  _Field._For-Name     = "ROBJ#"
  _Field._For-Type     = "number".

CREATE _Field. /* file: cdef$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "RCON#"
  _Field._Data-Type    = "integer"
  _Field._Initial      = ?
  _Field._Mandatory    = no
  _Field._Format       = "->>>>>>>>>9"
  _Field._Order        = 50
  _Field._Fld-stdtype  = 8192
  _Field._Fld-stoff    = 5
  _Field._For-Maxsize  = 12
  _Field._For-Name     = "RCON#"
  _Field._For-Type     = "number".

CREATE _Field. /* file: cdef$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "CONDITION"
  _Field._Data-Type    = "character"
  _Field._Initial      = ?
  _Field._Mandatory    = no
  _Field._Format       = "x(32)"
  _Field._Decimals     = ?
  _Field._Order        = 60
  _Field._Fld-stdtype  = 16384
  _Field._Fld-stoff    = 6
  _Field._For-Maxsize  = 0
  _Field._For-Name = "CONDITION"
  _Field._For-Type = "long".

CREATE _Field. /* file: cdef$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "ENABLED"
  _Field._Data-Type    = "integer"
  _Field._Initial      = ?
  _Field._Mandatory    = no
  _Field._Format       = "->>>>>>>>>9"
  _Field._Order        = 70
  _Field._Fld-stdtype  = 8192
  _Field._Fld-stoff    = 7
  _Field._For-Maxsize  = 12
  _Field._For-Name     = "ENABLED"
  _Field._For-Type     = "number".
    
FIND _File
  WHERE _File._Db-recid = dbkey
    AND _File._File-name = "oracle_cons_fld" 
    AND _File._Owner = "_FOREIGN" NO-ERROR.
IF AVAILABLE _File THEN RETURN.

CREATE _File.
ASSIGN
  _File._Db-recid    = dbkey
  _File._File-name   = "oracle_cons_fld"
  _File._For-Type    = "TABLE"
  _File._For-Name    = "ccol$"
  _File._For-Owner   = "sys"
  _File._Last-change = 2146431
  _File._ianum       = 6
  _File._Hidden      = TRUE.

CREATE _Field. /* file: con$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "CON#"
  _Field._Data-Type    = "integer"
  _Field._Initial      = ?
  _Field._Mandatory    = yes
  _Field._Format       = "->>>>>>>>>9"
  _Field._Order        = 10
  _Field._Fld-stdtype  = 8192
  _Field._Fld-stoff    = 1
  _Field._For-Maxsize  = 12
  _Field._For-Name     = "CON#"
  _Field._For-Type     = "number".
  
CREATE _Field. /* file: con$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "COL#"
  _Field._Data-Type    = "integer"
  _Field._Initial      = ?
  _Field._Mandatory    = yes
  _Field._Format       = "->>>>>>>>>9"
  _Field._Order        = 20
  _Field._Fld-stdtype  = 8192
  _Field._Fld-stoff    = 2
  _Field._For-Maxsize  = 12
  _Field._For-Name     = "COL#"
  _Field._For-Type     = "number".  


RETURN.
