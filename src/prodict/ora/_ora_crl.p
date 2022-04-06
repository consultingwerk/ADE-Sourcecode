/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* _ora_crl - base sys.link$ & sys.syn$ for oracle meta-schema 

   Modified:  DLM 12/29/97 Added _ianum
              DLM 07/13/98 Added _Owner to _File Find

*/

DEFINE INPUT PARAMETER dbkey AS RECID NO-UNDO.

FIND _File
  WHERE _File._Db-recid = dbkey
    AND _File._File-name = "oracle_links" 
    AND _File._Owner = "_FOREIGN" NO-ERROR.
IF NOT AVAILABLE _File THEN DO:

    CREATE _File.
    ASSIGN
      _File._Db-recid    = dbkey
      _File._File-name   = "oracle_links"
      _File._For-Type    = "TABLE"
      _File._For-Name    = "link$"
      _File._For-Owner   = "sys"
      _File._Last-change = 2146431
      _File._ianum       = 6
      _File._Hidden      = TRUE.

    CREATE _Field. /* file: link$ */
    ASSIGN
      _Field._File-recid   = RECID(_File)
      _Field._Field-Name   = "OWNER#"
      _Field._Data-Type    = "integer"
      _Field._Initial      = ?
      _Field._Mandatory    = yes
      _Field._Format       = "->>>>>>>>>9"
      _Field._Order        = 10
      _Field._Fld-stdtype  = 8192
      _Field._Fld-stoff    = 1
      _Field._For-Maxsize  = 12
      _Field._For-Name     = "OWNER#"
      _Field._For-Type     = "number".

    CREATE _Field. /* file: link$ */
    ASSIGN
      _Field._File-recid   = RECID(_File)
      _Field._Field-Name   = "NAME"
      _Field._Data-Type    = "character"
      _Field._Initial      = ?
      _Field._Mandatory    = yes
      _Field._Format       = "x(30)"
      _Field._Decimals     = 30
      _Field._Order        = 20
      _Field._Fld-stdtype  = 4096
      _Field._Fld-stoff    = 2
      _Field._For-Maxsize  = 128
      _Field._For-Name     = "NAME"
      _Field._For-Type     = "char".
END.

FIND _File
  WHERE _File._Db-recid = dbkey
    AND _File._File-name = "oracle_synonyms" NO-ERROR.
IF NOT AVAILABLE _File THEN DO:

    CREATE _File.
    ASSIGN
      _File._Db-recid    = dbkey
      _File._File-name   = "oracle_synonyms"
      _File._For-Type    = "TABLE"
      _File._For-Name    = "syn$"
      _File._For-Owner   = "sys"
      _File._Last-change = 2146431
      _File._ianum       = 6
      _File._Hidden      = TRUE.

    CREATE _Field. /* file: syn$ */
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
      _Field._For-Name     = "OBJ#"
      _Field._For-Type     = "number".

    CREATE _Field. /* file: syn$ */
    ASSIGN
      _Field._File-recid   = RECID(_File)
      _Field._Field-Name   = "NODE"
      _Field._Data-Type    = "character"
      _Field._Initial      = ?
      _Field._Mandatory    = no
      _Field._Format       = "x(30)"
      _Field._Decimals     = 30
      _Field._Order        = 20
      _Field._Fld-stdtype  = 4096
      _Field._Fld-stoff    = 2
      _Field._For-Maxsize  = 128
      _Field._For-Name     = "NODE"
      _Field._For-Type     = "char".

    CREATE _Field. /* file: syn$ */
    ASSIGN
      _Field._File-recid   = RECID(_File)
      _Field._Field-Name   = "OWNER"
      _Field._Data-Type    = "character"
      _Field._Initial      = ?
      _Field._Mandatory    = no
      _Field._Format       = "x(30)"
      _Field._Decimals     = 30
      _Field._Order        = 30
      _Field._Fld-stdtype  = 4096
      _Field._Fld-stoff    = 3
      _Field._For-Maxsize  = 30
      _Field._For-Name     = "OWNER"
      _Field._For-Type     = "char".

    CREATE _Field. /* file: syn$ */
    ASSIGN
      _Field._File-recid   = RECID(_File)
      _Field._Field-Name   = "NAME"
      _Field._Data-Type    = "character"
      _Field._Initial      = ?
      _Field._Mandatory    = yes
      _Field._Format       = "x(30)"
      _Field._Decimals     = 30
      _Field._Order        = 40
      _Field._Fld-stdtype  = 4096
      _Field._Fld-stoff    = 4
      _Field._For-Maxsize  = 30
      _Field._For-Name     = "NAME"
      _Field._For-Type     = "char".
END.


FIND _File
  WHERE _File._Db-recid = dbkey
    AND _File._File-name = "oracle_views" NO-ERROR.
IF NOT AVAILABLE _File THEN DO:

    CREATE _File.
    ASSIGN
      _File._Db-recid    = dbkey
      _File._File-name   = "oracle_views"
      _File._For-Type    = "TABLE"
      _File._For-Name    = "view$"
      _File._For-Owner   = "sys"
      _File._ianum       = 6
      _File._Last-change = 2146431
      _File._Hidden      = TRUE.

    CREATE _Field. /* file: view$ */
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
      _Field._For-Name     = "OBJ#"
      _Field._For-Type     = "number".

    CREATE _Field. /* file: view$ */
    ASSIGN
      _Field._File-recid   = RECID(_File)
      _Field._Field-Name   = "COLS"
      _Field._Data-Type    = "integer"
      _Field._Initial      = ?
      _Field._Mandatory    = yes
      _Field._Format       = "->>>>>>>>>9"
      _Field._Order        = 20
      _Field._Fld-stdtype  = 8192
      _Field._Fld-stoff    = 2
      _Field._For-Maxsize  = 12
      _Field._For-Name = "COLS"
      _Field._For-Type = "number".

    CREATE _Field. /* file: view$ */
    ASSIGN
      _Field._File-recid   = RECID(_File)
      _Field._Field-Name   = "TEXT_"
      _Field._Data-Type    = "character"
      _Field._Initial      = ?
      _Field._Mandatory    = no
      _Field._Format       = "x(64)"
      _Field._Decimals     = ?
      _Field._Order        = 30
      _Field._Fld-stdtype  = 16384
      _Field._Fld-stoff    = 3
      _Field._For-Maxsize  = 0
      _Field._For-Name     = "TEXT"
      _Field._For-Type     = "long".
END.

RETURN.









