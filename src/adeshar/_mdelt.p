/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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

