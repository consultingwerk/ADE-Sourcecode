/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * _maddt.p
 *  
 *    Add a new item to a toolbar.
 *
 *  Input Parameters
 *
 *    appId            The application client this item belongs to.
 *    featureId        The feature that the menu item represents.
 *    tFrame           The toolbar frame
 *    upImage          The up image icon
 *    downImage        The down image icon
 *    x                THe X position of the item in the toolbar
 *    y                The Y position of the item in the toolbar
 *    iType            The type of menu item. See _mnudefs.i for list.
 *    userDefined      
 *    prvData          A character field that can be used by the application
 *
 *  Output Parameters
 *
 *    tbItem           The handle of the newly created item
 *    s                The state. False if the feature does not exist.
 *                     This routine does no "publically" announce if there
 *                     is a failure.
 */

{ adecomm/_mtemp.i }
{ {&mdir}/_mnudefs.i }

define input  parameter appId        as character no-undo.
define input  parameter featureId    as character no-undo.
define input  parameter toolbarId    as character no-undo.
define input  parameter upImage      as character no-undo.
define input  parameter downImage    as character no-undo.
define input  parameter insImage     as character no-undo.
define input  parameter x            as integer   no-undo.
define input  parameter y            as integer   no-undo.
define input  parameter w            as integer   no-undo.
define input  parameter h            as integer   no-undo.
define input  parameter iType	     as character no-undo.
define input  parameter userDefined  as logical	  no-undo.
define input  parameter prvData      as character no-undo.
define output parameter s            as logical   no-undo initial false.

define variable makeTb as logical no-undo initial true.

/*message "appId     " appId     skip
          "featureId " featureId skip
          "toolbarId " toolbarId skip
          "upImage   " upImage   skip
          "x         " x         skip
          "y         " y         skip
        view-as alert-box error buttons ok.*/
/*
 * First check to see if the feature is available in the list of
 * features. If not. Exit. 
 */

find first mnuFeatures where mnuFeatures.appId = appId
                        and   mnuFeatures.featureId = featureId
                        and   mnuFeatures.secure = false no-error.

if (not available mnuFeatures) then return.

find first tbItem where tbItem.featureId = featureId
                     and tbItem.appId = appId 
                     and tbItem.toolbarId = toolbarId no-error.

/*
 * if the record exists then check to see if it has been marked for delete.
 * if it has then then unmark the record. and then return.
 */

if available tbItem then do:

    /*
     * OK. There's an existing record. Set state to modify if this was an
     * existing record, existing before the editting began.
     */

    if tbItem.state = "delete-new" then
      assign
        tbItem.state = "create"
        s = true
        makeTb = false
      .

    if tbItem.state = "delete-existing" then
      assign
        tbItem.state = "modify-existing"
        s = true
        makeTb = false
     .

    /*
     * Fall through. That way, if any of the fields have changed, they
     * will be updated.
     */
    if s = false then return.
end.

s = true.
		
if makeTb then do:
  create tbItem.
  tbItem.state = "create".
end.

assign
  tbItem.appId        = appId
  tbItem.featureId    = featureId
  tbItem.toolbarId    = toolbarId
  tbItem.upImage      = if upImage = ? then "" else upImage
  tbItem.downImage    = if downImage = ? then "" else downImage
  tbItem.insImage     = if insImage = ? then "" else insImage
  tbItem.x            = x
  tbItem.y            = y
  tbItem.w            = w
  tbItem.h            = h
  tbItem.type         = {&tbItemType}
  tbItem.userDefined  = userDefined
  tbItem.prvData      = if prvData = ? then "" else prvData
.



