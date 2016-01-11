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
/*
* _vgrpti.p
*
*    Returns the information about the report attributes.
*
*  output parameters
*
*    integer    leftOrigin      the left margin
*    integer    topOrigin       the top margin
*    integer    columnSpacing
*    integer    lineSpacing
*    integer    pageLines
*    integer    headBodySpacing
*    integer    bodyFootSpacing
*    character  pageEjectField
*    logical    summary report
*/

{ aderes/s-system.i }
{ aderes/r-define.i }

DEFINE OUTPUT PARAMETER leftOrigin      AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER topOrigin       AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER columnSpacing   AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER lineSpacing     AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER pageLines       AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER headBodySpacing AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER bodyFootSpacing AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER pageEjectField  AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER summaryReport   AS LOGICAL   NO-UNDO.

/*
* First look for the "live" report. Otherwise talke the default
* report layout. Currently there is a max of two records in this
* table.
*/

FIND FIRST qbf-rsys WHERE qbf-rsys.qbf-live = TRUE NO-ERROR.

IF NOT AVAILABLE qbf-rsys THEN
FIND FIRST qbf-rsys WHERE qbf-rsys.qbf-live = FALSE NO-ERROR.

/* Return the information */
ASSIGN
  leftOrigin      = qbf-rsys.qbf-origin-hz
  topOrigin       = qbf-rsys.qbf-origin-vt
  columnSpacing   = qbf-rsys.qbf-space-hz
  lineSpacing     = qbf-rsys.qbf-space-vt
  pageLines       = qbf-rsys.qbf-page-size
  headBodySpacing = qbf-rsys.qbf-header-body
  bodyFootSpacing = qbf-rsys.qbf-body-footer
  pageEjectField  = qbf-rsys.qbf-page-eject
  summaryReport   = qbf-summary
  .

/* vgrpti.p - end of file */

