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
 *  _mdelt.p
 *
 *    Marks the button for delete.
 *
 *  Input Parameters
 *
 *    appId     THe application id
 *    featureId The feature that is represneted by the button.
 *    toolbarId The toolbar this button is attached to.
 *    s  The status. False if there is no menu item with the label.
 */

{ adecomm/_mtemp.i }
{ {&mdir}/_mnudefs.i}

define input  parameter appId     as character no-undo.
define input  parameter featureId as character no-undo.
define input  parameter toolbarId as character no-undo.
define output parameter s     as logical   no-undo initial false.

find first tbItem where tbItem.featureId = featureId
                     and tbItem.appId = appId 
                     and tbItem.toolbarId = toolbarId no-error.

IF (not available tbItem) THEN return.

assign
    s         = true
.

/*
 * Mark this record for deletion
 */ 
if tbItem.state = "modify-new" then tbItem.state = "delete-new".
if tbItem.state = "modify-existing" then tbItem.state = "delete-existing".
if tbItem.state = "" then tbItem.state = "delete-existing".
if tbItem.state = "create" then tbItem.state = "delete-new".

