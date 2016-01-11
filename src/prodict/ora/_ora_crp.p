/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* _ora_crp - base procedure for oracle meta-schema 

   Modified:  DLM 12/29/97 Added _ianum
              DLM 07/13/98 Added _Owner to _File Find


*/

DEFINE INPUT PARAMETER dbkey AS RECID NO-UNDO.

return.

FIND _File
  WHERE _File._Db-recid = dbkey
    AND _File._File-name = "oracle_procedures" 
    AND _File._Owner = "_FOREIGN" NO-ERROR.
IF AVAILABLE _File THEN RETURN.

CREATE _File.
ASSIGN
  _File._Db-recid    = dbkey
  _File._File-name   = "oracle_procedures"
  _File._For-Type    = "TABLE"
  _File._For-Name    = "PROCEDURE$"
  _File._For-Owner   = "sys"
  _File._ianum       = 6
  _File._Last-change = 2146431
  _File._Hidden      = TRUE.

CREATE _Field. /* file: procedure$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "OBJ#"
  _Field._Data-Type    = "integer"
  _Field._Initial      = ?
  _Field._Mandatory    = yes
  _Field._Format       = "->>>>>>>>>9"
  _Field._Order        = 10
  _Field._Fld-stdtype  = 8192
  _Field._Fld-stoff    = 1
  _Field._For-Maxsize  = 12
  _Field._For-Name = "OBJ#"
  _Field._For-Type = "number".

CREATE _Field. /* file: procedure$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "AUDIT$"
  _Field._Data-Type    = "character"
  _Field._Initial      = ?
  _Field._Mandatory    = no
  _Field._Format       = "x(32)"
  _Field._Decimal      = 32
  _Field._Order        = 20
  _Field._Fld-stdtype  = 4096
  _Field._Fld-stoff    = 2
  _Field._For-Maxsize  = 32
  _Field._For-Name = "AUDIT$"
  _Field._For-Type = "char".

CREATE _Field. /* file: procedure$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "STORAGESIZE"
  _Field._Data-Type    = "integer"
  _Field._Initial      = ?
  _Field._Mandatory    = no
  _Field._Format       = "->>>>>>>>>9"
  _Field._Order        = 30
  _Field._Fld-stdtype  = 8192
  _Field._Fld-stoff    = 3
  _Field._For-Maxsize  = 12
  _Field._For-Name = "STORAGESIZE"
  _Field._For-Type = "number".


CREATE _Field. /* file: procedure$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "OPTIONS"
  _Field._Data-Type    = "integer"
  _Field._Initial      = ?
  _Field._Mandatory    = no
  _Field._Format       = "->>>>>>>>>9"
  _Field._Order        = 40
  _Field._Fld-stdtype  = 8192
  _Field._Fld-stoff    = 4
  _Field._For-Maxsize  = 12
  _Field._For-Name = "OPTIONS"
  _Field._For-Type = "number".

RETURN.
