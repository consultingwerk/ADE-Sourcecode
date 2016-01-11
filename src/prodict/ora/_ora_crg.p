/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* _ora_crg - Generic Stored procedures buffer for Oracle databases.

   Modified:  DLM 12/29/97 Added _ianum
              DLM 07/13/98 Added _Owner to _File Find

 */

DEFINE INPUT PARAMETER dbkey AS RECID NO-UNDO.

FIND _File
  WHERE _File._Db-recid = dbkey
    AND _File._File-name = "PROC-TEXT-BUFFER" 
    AND _File._Owner = "_FOREIGN" NO-ERROR.
IF AVAILABLE _File THEN RETURN.

CREATE _File.
ASSIGN
  _File._Db-recid     = dbkey
  _File._File-name    = "PROC-TEXT-BUFFER"
  _File._For-type     = "GENERIC-BUFFER"
  _File._For-name     = "NONAME"
  _File._Last-change  = 2146431
  _File._ianum        = 6
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
  _Field._Fld-stdtype  = 4096
  _Field._Fld-stoff    = 1
  _Field._For-name     = "NONAME"
  _Field._For-type     = "char".

/* Dummy Stored procedures buffer SQL pass thru. */
CREATE _File.
ASSIGN
  _File._Db-recid     = dbkey
  _File._File-name    = "SEND-SQL-STATEMENT"
  _File._For-type     = "PROCEDURE"
  _File._For-name     = "SEND-SQL-STATEMENT"
  _File._Last-change  = 2146431
  _File._ianum        = 6
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
  _Field._Fld-stdtype  = 4096
  _Field._Fld-stoff    = 1
  _Field._For-name     = "sql-statement"
  _Field._For-type     = "char".

/* Dummy Stored procedures buffer SQL pass thru. */
FIND _File
  WHERE _File._Db-recid = dbkey
    AND _File._File-name = "CloseAllProcs" NO-ERROR.
IF AVAILABLE _File THEN RETURN.

CREATE _File.
ASSIGN
  _File._Db-recid     = dbkey
  _File._File-name    = "CloseAllProcs"
  _File._For-type     = "PROCEDURE"
  _File._For-name     = "CLOSEALLPROCS"
  _File._Last-change  = 2146431
  _File._ianum        = 6
  _File._Hidden       = TRUE.

RETURN.
