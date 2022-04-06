/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* this creates the sylk file definition */

FIND FIRST _Db WHERE _Db._Db-local NO-LOCK.

FIND _File "sylk" OF _Db NO-ERROR.
IF AVAILABLE _File AND _File._Frozen THEN RETURN.

IF AVAILABLE _File THEN DO:
  FOR EACH _Index OF _File:
    FOR EACH _Index-field OF _Index:
      DELETE _Index-field.
    END.
    DELETE _Index.
  END.
  FOR EACH _Field OF _File:
    DELETE _Field.
  END.
  DELETE _File.
END.

CREATE _File.
ASSIGN
  _File._Db-recid  = RECID(_Db)
  _File._File-name = "sylk"
  _File._Hidden    = TRUE.

CREATE _Field.
ASSIGN
  _Field._Field-name = "x"
  _Field._Data-type  = "character"
  _Field._Order      = 20
  _Field._File-recid = RECID(_File)
  _Field._Format     = "x(40)"
  _Field._Initial    = ""
  _Field._Extent     = 255.

CREATE _Field.
ASSIGN
  _Field._Field-name = "y"
  _Field._Data-type  = "integer"
  _Field._Order      = 10
  _Field._File-recid = RECID(_File)
  _Field._Format     = "->,>>>,>>9"
  _Field._Initial    = "0".

CREATE _Index.
ASSIGN
  _Index._Index-name = "sylk"
  _File._Prime-Index = RECID(_Index)
  _Index._File-recid = RECID(_File)
  _Index._Unique     = TRUE
  _Index._Active     = TRUE.

CREATE _Index-field.
ASSIGN
  _Index-field._Index-recid = RECID(_Index)
  _Index-field._Field-recid = RECID(_Field)
  _Index-field._Ascending   = TRUE
  _Index-field._Index-seq   = 1.

RETURN.
