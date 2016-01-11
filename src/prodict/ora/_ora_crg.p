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
