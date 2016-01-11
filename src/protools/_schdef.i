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
  
  
  
