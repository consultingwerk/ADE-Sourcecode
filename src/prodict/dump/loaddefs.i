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
/* loaddefs.i - definitions for load .df file

history:
   10/18/99  Mario B.   Create warning mechanisim and add warning for
   SQL-WIDTH.  BUG# 19990825-005.
    D. McMann 04/11/01 Added warning for SQL Table Updates ISSUE 310
-----------------------------------------------------------------------------*/

DEFINE {1} SHARED VARIABLE iarg AS CHARACTER NO-UNDO. /* usually = ilin[2] */
DEFINE {1} SHARED VARIABLE ikwd AS CHARACTER NO-UNDO. /* usually = ilin[1] */
DEFINE {1} SHARED VARIABLE imod AS CHARACTER NO-UNDO. /* add/mod/ren/del */
DEFINE {1} SHARED VARIABLE ipos	AS INTEGER   NO-UNDO. /* line# in file */
DEFINE {1} SHARED VARIABLE ilin AS CHARACTER EXTENT 256 NO-UNDO.

DEFINE {1} SHARED VARIABLE iprimary   AS LOGICAL   NO-UNDO. /* is prim idx */
DEFINE {1} SHARED VARIABLE irename    AS CHARACTER NO-UNDO. /* new name */
DEFINE {1} SHARED VARIABLE icomponent AS INTEGER   NO-UNDO. /* idx-fld seq # */

DEFINE {1} SHARED VARIABLE inoerror AS LOGICAL   NO-UNDO. /* no-error seen? */
DEFINE {1} SHARED VARIABLE ierror   AS INTEGER   NO-UNDO. /* error counter */
DEFINE {1} SHARED VARIABLE iwarn    AS INTEGER   NO-UNDO. /* warning counter */
DEFINE {1} SHARED VARIABLE iwarnlst AS CHARACTER NO-UNDO. /* list for warnings */

DEFINE {1} SHARED VARIABLE file-area-number AS INTEGER INITIAL 6 NO-UNDO.

DEFINE {1} SHARED WORKFILE wdbs NO-UNDO LIKE _Db.
DEFINE {1} SHARED WORKFILE wfil NO-UNDO LIKE _File.
DEFINE {1} SHARED WORKFILE wfit NO-UNDO LIKE _File-trig.
DEFINE {1} SHARED WORKFILE wfld NO-UNDO LIKE _Field.
DEFINE {1} SHARED WORKFILE wflt NO-UNDO LIKE _Field-trig.
DEFINE {1} SHARED WORKFILE widx NO-UNDO LIKE _Index.
DEFINE {1} SHARED WORKFILE wixf NO-UNDO LIKE _Index-field.
DEFINE {1} SHARED WORKFILE wseq NO-UNDO LIKE _Sequence.

/* gate_xxx - for lookup of _for-type -> _fld-stdtype converions */
DEFINE {1} SHARED VARIABLE gate_dbtype AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE gate_proc   AS CHARACTER NO-UNDO. /* xxx_typ.p */

/* dblangcache - list of sql files - _File._Db-lang -> 1 */
DEFINE {1} SHARED VARIABLE dblangcache AS CHARACTER NO-UNDO.

/* kindexcache - list of index names deleted when fields deleted */
DEFINE {1} SHARED VARIABLE kindexcache AS CHARACTER NO-UNDO.

/* frozencache - list of files to be marked frozen */
DEFINE {1} SHARED VARIABLE frozencache AS CHARACTER NO-UNDO.

/* logical used to check the validity of the area-number in a .df file */

DEFINE VARIABLE is-area AS LOGICAL NO-UNDO.
