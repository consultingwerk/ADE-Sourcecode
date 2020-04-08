/***********************************************************************
* Copyright (C) 2000,2006,2008,2011,2019 by Progress Software          *
* Corporation. All rights reserved.  Prior versions of this work may   *
* contain portions contributed by participants of Possenet.            *
*                                                                      *
***********************************************************************/
/* loaddefs.i - definitions for load .df file

history:
   10/18/99  Mario B.   Create warning mechanisim and add warning for
   SQL-WIDTH.  BUG# 19990825-005.
    D. McMann 04/11/01 Added warning for SQL Table Updates ISSUE 310
   fernando   08/21/06 Fixing load of collation into pre-10.1A db (20060413-001)
   fernando   04/30/08 Adding ttFldOrder temp-table
   kmayur     06/21/11 Added wcon table for constraint dump OE00195067
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

&IF DEFINED(NO_TABLES) EQ 0 &THEN

/* 20060413-001 - making wdbs a temp-table */
DEFINE {1} SHARED TEMP-TABLE wdbs NO-UNDO LIKE _Db.
 
DEFINE {1} SHARED TEMP-TABLE wfil NO-UNDO LIKE _File.
DEFINE {1} SHARED TEMP-TABLE wfit NO-UNDO LIKE _File-trig.
DEFINE {1} SHARED TEMP-TABLE wfld NO-UNDO LIKE _Field.
DEFINE {1} SHARED TEMP-TABLE wflt NO-UNDO LIKE _Field-trig.
DEFINE {1} SHARED TEMP-TABLE widx NO-UNDO LIKE _Index.
DEFINE {1} SHARED TEMP-TABLE wixf NO-UNDO LIKE _Index-field.
DEFINE {1} SHARED TEMP-TABLE wseq NO-UNDO LIKE _Sequence.
DEFINE {1} SHARED TEMP-TABLE wcon NO-UNDO LIKE _Constraint.

DEFINE {1} SHARED TEMP-TABLE ttFldOrder NO-UNDO
    FIELD FILE-NAME  AS CHAR
    FIELD Field-Name AS CHAR
    FIELD Prev-Order AS INT
    FIELD isOrderUpdated as LOGICAL.

&ENDIF

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
DEFINE STREAM   constlog.
DEFINE VARIABLE cnstrpt_name       AS CHARACTER   NO-UNDO.
