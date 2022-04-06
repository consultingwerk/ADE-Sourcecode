/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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



