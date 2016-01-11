/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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

