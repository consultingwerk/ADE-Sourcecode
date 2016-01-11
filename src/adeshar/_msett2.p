/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * _msett2.p
 *  
 *    CHanges the image path for an existing toolbar button. Sorry about
 *    the poor name. There's only so muchone can do with 8 chars.
 *
 *  Input Parameters
 *
 *    appId            THe application client this item belongs to.
 *    featureId        The feature that the menu item represents.
 *    toolbarId        The toolbar Id
 *    imageType        "up", "down", or "ins"
 *    image            The image of the button
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
define input  parameter imageType    as character no-undo.
define input  parameter image        as character no-undo.
define output parameter s            as logical   no-undo initial false.

find first tbItem where tbItem.featureId = featureId
                     and tbItem.appId = appId 
                     and tbItem.toolbarId = toolbarId no-error.

if not available tbItem then return.


/*
 * Say the record isn't found if the state says deleted
 */

if    tbItem.state = "delete-existing"
   or tbItem.state = "delete-new" then return.

assign
    s                = true
.

if      imageType = "up"   then tbItem.upImage = image.
else if imageType = "down" then tbItem.downImage = image.
else if imageType = "ins"  then tbItem.insImage = image.

/*
 * Set the state. During the update "Modify-****" will delete the
 * existing button and create a new one. That means we don't have to worry
 * about too much here.
 */

if tbItem.state = "" then tbItem.state = "modify-existing".
                     else tbItem.state = "modify-new".





