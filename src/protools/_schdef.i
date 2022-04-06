/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*PROGRAM NAME: _schdef.i
 * AUTHOR      : Tammy Marshall
 * DATE        : 04/01/99
 * DESCRIPTION : Defines the TableDetails, FieldDetails, and IndexDetails 
 *               temporary tables used to get the Table, Field and Index
 *               details to display in the Details windows of the DB
 *               Connections PRO*Tool.
 * */

DEFINE TEMP-TABLE TableDetails
  FIELD name AS CHARACTER
  FIELD storarea AS CHARACTER
  FIELD multitenant AS LOGICAL
  FIELD keepdefaultarea AS LOGICAL
  FIELD tlabel AS CHARACTER
  FIELD tdesc AS CHARACTER
  FIELD replproc AS CHARACTER
  FIELD valexp AS CHARACTER
  FIELD valmsg AS CHARACTER
  FIELD crtrig AS CHARACTER
  FIELD deltrig AS CHARACTER
  FIELD fndtrig AS CHARACTER
  FIELD wrtrig AS CHARACTER
  FIELD repcrtrig AS CHARACTER
  FIELD repdeltrig AS CHARACTER
  FIELD repwrtrig AS CHARACTER.
  
DEFINE TEMP-TABLE FieldDetails
  FIELD tblname AS CHARACTER
  FIELD fldname AS CHARACTER
  FIELD datatype AS CHARACTER
  FIELD tformat AS CHARACTER
  FIELD torder AS INTEGER
  FIELD tlabel AS CHARACTER
  FIELD tdec AS INTEGER
  FIELD collabel AS CHARACTER
  FIELD textent AS INTEGER
  FIELD asgntrig AS CHARACTER
  FIELD initval AS CHARACTER
  FIELD thelp AS CHARACTER
  FIELD valexp AS CHARACTER
  FIELD valmsg AS CHARACTER
  FIELD tdesc AS CHARACTER
  FIELD viewas AS CHARACTER
  FIELD tmandatory AS LOGICAL
  FIELD casesensitive AS LOGICAL.
  
DEFINE TEMP-TABLE IndexDetails
  FIELD tblname AS CHARACTER
  FIELD idxname AS CHARACTER
  FIELD tdesc AS CHARACTER
  FIELD lactive AS LOGICAL
  FIELD lprimary AS LOGICAL
  FIELD lunique AS LOGICAL
  FIELD lwordindex AS LOGICAL
  FIELD labbrev AS LOGICAL.
  
DEFINE TEMP-TABLE IndxFldDetails
  FIELD tblname AS CHARACTER
  FIELD idxname AS CHARACTER
  FIELD idxseq AS INTEGER
  FIELD fldname AS CHARACTER
  FIELD fldtype AS CHARACTER
  FIELD lasc AS LOGICAL.
  
  
  
