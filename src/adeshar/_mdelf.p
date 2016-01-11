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
 *  _mdelf.p
 *
 *    Deletes a feature from the feature list, if there is no menu
 *    item representing the feature.
 *
 * Input Parameters
 *
 *    appId      The application.
 *    featureId  The feature.
 * 
 *  Output Parameters
 *
 *    status     True if the item was deleted.
 */

{ adecomm/_mtemp.i }
{ {&mdir}/_mnudefs.i}

define input  parameter appId     as character no-undo.
define input  parameter featureId as character no-undo.
define output parameter s         as logical   no-undo initial false.

find first mnuFeatures where mnuFeatures.appId = appId
                         and mnuFeatures.featureId = featureId no-error.

/*
 * If we can't find a record then return.
 */

if not available mnuFeatures then return.

/*
 * Now check to see if there is a menu item or toolbar representing. If there
 * is the feature can't be deleted.
 */

find first mnuItems where mnuItems.appId = appId
                      and mnuItems.featureId = featureId
                      and mnuItems.state <> "delete-existing"
                      and mnuItems.state <> "delete-new" no-error.

if available mnuItems then return.

/*
 * If there is a toolbar button in any toolbar belonging to this application
 * then the feature can not be deleted.
 */

find first tbItem where tbItem.appId = appId
                    and tbItem.featureId = featureId
                    and tbItem.state <> "delete-existing"
                    and tbItem.state <> "delete-new" no-error.

if available tbItem then return.

/*
 * Ok, the feature can be marked for deletion
 */

assign
    s = true
.

if mnuFeatures.state = "modify-new" then mnuFeatures.state = "delete-new".
if mnuFeatures.state = "modify-existing"
    then mnuFeatures.state = "delete-existing".
if mnuFeatures.state = "" then mnuFeatures.state = "delete-existing".
if mnuFeatures.state = "create" then mnuFeatures.state = "delete-new".

