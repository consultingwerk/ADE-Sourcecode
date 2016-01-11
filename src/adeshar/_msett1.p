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
 * _msett1.p
 *  
 *    CHanges the editHandle for an existing toolbar button. This function
 *    is needed because the editHandle is not known until the user
 *    decides to edit the toolbar. That situation occurs long after the
 *    record for the toolbar button is created.
 *
 *  Input Parameters
 *
 *    appId            THe application client this item belongs to.
 *    featureId        The feature that the menu item represents.
 *    toolbarId        The toolbar Id
 *    editHandle       THe handle of the edit button.
 *
 *  Output Parameters
 *
 *    s                The state. False if the feature does not exist.
 *                     This routine does no "publically" announce if there
 *                     is a failure.
 */
{ adecomm/_mtemp.i }
{ {&mdir}/_mnudefs.i}

define input  parameter appId        as character no-undo.
define input  parameter featureId    as character no-undo.
define input  parameter toolbarId    as character no-undo.
define input  parameter editHandle   as widget    no-undo.
define output parameter s            as logical   no-undo initial false.

find first tbItem where tbItem.featureId = featureId
                     and tbItem.appId = appId 
                     and tbItem.toolbarId = toolbarId no-error.

if not available tbItem then return.

assign
    s                 = true
    tbItem.editHandle = editHandle
.



