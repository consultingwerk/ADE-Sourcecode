/*********************************************************************
* Copyright (C) 2000,2007 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* _ora_crc - base columns for oracle meta-schema 

   Modified:  DLM 12/29/97 Added _ianum
              DLM 07/13/98 Added _Owner to _File Find
         fernando 06/11/07 Unicode support - new field
*/

DEFINE INPUT PARAMETER dbkey AS RECID NO-UNDO.

DEFINE VARIABLE isNew AS LOGICAL NO-UNDO INITIAL NO.

FIND _Db WHERE RECID(_Db) = dbkey NO-LOCK NO-ERROR.

IF NOT AVAILABLE _Db THEN RETURN.
ELSE IF _Db._Db-type <> "ORACLE" THEN RETURN.

FIND _File
  WHERE _File._Db-recid = dbkey
    AND _File._File-name = "oracle_columns" 
    AND (_File._Owner = "_FOREIGN" OR _File._owner = "PUB") NO-ERROR.

IF NOT AVAILABLE _File THEN DO:

ASSIGN isNew = YES.

CREATE _File.
ASSIGN
  _File._Db-recid    = dbkey
  _File._File-name   = "oracle_columns"
  _File._For-Type    = "TABLE"
  _File._For-Name    = "col$"
  _File._For-Owner   = "sys"
  _File._ianum       = 6
  _File._Last-change = 2146431
  _File._Hidden      = TRUE.

CREATE _Field. /* file: col$ */
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

CREATE _Field. /* file: col$ */
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
  _Field._For-Name = "COL#"
  _Field._For-Type = "number".

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "NAME"
  _Field._Data-Type    = "character"
  _Field._Initial      = ?
  _Field._Mandatory    = yes
  _Field._Format       = "x(30)"
  _Field._Decimals     = 30
  _Field._Order        = 30
  _Field._Fld-stdtype  = 4096
  _Field._Fld-stoff    = 3
  _Field._For-Maxsize  = 30
  _Field._For-Name = "NAME"
  _Field._For-Type = "char".

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "TYPE#"
  _Field._Data-Type    = "integer"
  _Field._Initial      = ?
  _Field._Mandatory    = yes
  _Field._Format       = "->>>>>>>>>9"
  _Field._Order        = 40
  _Field._Fld-stdtype  = 8192
  _Field._Fld-stoff    = 4
  _Field._For-Maxsize  = 12
  _Field._For-Name = "TYPE#"
  _Field._For-Type = "number".

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "LENGTH_"
  _Field._Data-Type    = "integer"
  _Field._Initial      = ?
  _Field._Mandatory    = yes
  _Field._Format       = "->>>>>>>>>9"
  _Field._Order        = 50
  _Field._Fld-stdtype  = 8192
  _Field._Fld-stoff    = 5
  _Field._For-Maxsize  = 12
  _Field._For-Name = "LENGTH"
  _Field._For-Type = "number".

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "PRECISION_"
  _Field._Data-Type    = "integer"
  _Field._Initial      = ?
  _Field._Mandatory    = no
  _Field._Format       = "->>>>>>>>>9"
  _Field._Order        = 60
  _Field._Fld-stdtype  = 8192
  _Field._Fld-stoff    = 6
  _Field._For-Maxsize  = 12
  _Field._For-Name = (IF _Db._Db-misc1[3] = 7 THEN "PRECISION"
                             ELSE "PRECISION#")
  _Field._For-Type = "number".

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "SCALE"
  _Field._Data-Type    = "integer"
  _Field._Initial      = ?
  _Field._Mandatory    = no
  _Field._Format       = "->>>>>>>>>9"
  _Field._Order        = 70
  _Field._Fld-stdtype  = 8192
  _Field._Fld-stoff    = 7
  _Field._For-Maxsize  = 12
  _Field._For-Name = "SCALE"
  _Field._For-Type = "number".

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "NULL$"
  _Field._Data-Type    = "integer"
  _Field._Initial      = ?
  _Field._Mandatory    = yes
  _Field._Format       = "->>>>>>>>>9"
  _Field._Order        = 80
  _Field._Fld-stdtype  = 8192
  _Field._Fld-stoff    = 8
  _Field._For-Maxsize  = 12
  _Field._For-Name = "NULL$"
  _Field._For-Type = "number".

CREATE _Field. /* file: col$ */
ASSIGN
  _Field._File-recid   = RECID(_File)
  _Field._Field-Name   = "DEFAULT$"
  _Field._Data-Type    = "character"
  _Field._Initial      = ?
  _Field._Mandatory    = no
  _Field._Format       = "x(32)"
  _Field._Decimals     = ?
  _Field._Order        = 90
  _Field._Fld-stdtype  = 16384
  _Field._Fld-stoff    = 9
  _Field._For-Maxsize  = 0
  _Field._For-Name = "DEFAULT$"
  _Field._For-Type = "long".

END.
ELSE DO:

/* This field was added to 10.1C for the Unicode Support. Make sure that we
  add it if this was an pre-10.1C schema holder
*/
   FIND _Field OF _File WHERE _Field._File-recid   = RECID(_File) 
                     AND _Field._Field-Name   = "CHARSETFORM" NO-ERROR.
   IF NOT AVAILABLE(_Field) AND NOT CAN-DO("READ-ONLY",DBRESTRICTIONS("DICTDB")) THEN
      ASSIGN isNew = YES.
END.

/* if this is a new schema, or if the field doesn't exist, then create it */
IF isNew THEN DO:

    CREATE _Field. /* file: col$ */
    ASSIGN
      _Field._File-recid   = RECID(_File)
      _Field._Field-Name   = "CHARSETFORM"
      _Field._Data-Type    = "integer"
      _Field._Initial      = ?
      _Field._Mandatory    = yes
      _Field._Format       = "->>>>>>>>>9"
      _Field._Order        = 100
      _Field._Fld-stdtype  = 8192
      _Field._Fld-stoff    = 10
      _Field._For-Maxsize  = 12
      _Field._For-Name = "CHARSETFORM"
      _Field._For-Type = "number".
END.


RETURN.
