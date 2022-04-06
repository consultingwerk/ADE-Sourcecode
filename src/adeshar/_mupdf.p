/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 *  _mupdf.p
 *
 *    Updates non promary key information for a feature. Nor can the
 *    feature type, prvHandle, or _sensfunction be changed.
 *
 *    If a label or toolbar button is attached to the feature and
 *    updateIfItem is true then the screen will be updated.
 *
 * Input Parameters
 *
 *    appId        The application.
 *    featureId    The feature.
 *    updateIfItem True if the record should be updated if there is
 *                 a menu item attached
 *    function
 *    args
 *    defaultLabel
 *    defaultUpIcon
 *    defaultDownIcon
 *    shortHelp
 *    
 * 
 *  Output Parameters
 *
 *    status     True if the item was updated.
 */

{ adecomm/_mtemp.i }
{ {&mdir}/_mnudefs.i}

define input  parameter appId        as character no-undo.
define input  parameter featureId    as character no-undo.
define input  parameter updateIfItem as logical   no-undo.
define input  parameter fName        as character no-undo.
define input  parameter args         as character no-undo.
define input  parameter defLabel     as character no-undo.
define input  parameter defUpIcon    as character no-undo.
define input  parameter defDownIcon  as character no-undo.
define input  parameter defInsIcon   as character no-undo.
define input  parameter microHelp    as character no-undo.
define output parameter s            as logical   no-undo initial false.

find first mnuFeatures where     mnuFeatures.appId = appId
                              and mnuFeatures.featureId = featureId no-error.

/*
 * If we can't find a record then return.
 */

if not available mnuFeatures then return.

/*
 * Say this record can't be found if it is marked for deletion
 */
 
if    mnuFeatures.state = "delete-existing"
   or mnuFeatures.state = "delete-new" then return.	

/*
 * If the user is worried about updatting attached menu or toolbars look
 * for them. Do the search for the records though. We may need the records.
 * If an icon or menu label has changed, we'll want to update the screen.
 */

find first mnuItems where     mnuItems.appId = appId
                           and mnuItems.featureId = featureId no-error.

if (available mnuItems) and (updateIfItem = false) then return.

/*
 * If there is a toolbar button in any toolbar belonging to this application
 * then the feature can not be updated.
 */

find first tbItem where     tbItem.appId = appId
                         and tbItem.featureId = featureId no-error.

if (available tbItem) and (updateIfItem = false) then return.

/*
 * Ok, the feature can be updated. Now check to see if there are changes.
 * And only change things that really have changed.
 */
 
if mnuFeatures.functionId <> fName then do:

    assign
        mnuFeatures.functionId = fName
        s = true
    .
    	
end.

if mnuFeatures.args <> args then do:

    assign
        mnuFeatures.args = args
        s = true
    .
    	
end.

if mnuFeatures.defaultLabel <> defLabel then do:

    assign
        mnuFeatures.defaultLabel = defLabel
        s = true
    .
    
    /*
     * If there is a menu item attached then change the label
     */
    
    if available mnuItems then do:
    
        assign
            mnuItems.labl = defLabel
        .
        
        /*
         * Change the state. If the state is delete then changing the
         * label won't hurt
         */
         
        if mnuItems.state = "create" then mnuItems.state = "modify-new".
       	if mnuItems.state = "" then mnuItems.state = "modify-existing".
      
    end.
    
end.

if mnuFeatures.defaultUpIcon <> defUpIcon then do:

    assign
        mnuFeatures.defaultUpIcon = defUpIcon
        s = true
    .
    
    /*
     * If there is a toolbar button attached then change the image
     */
    
    if available tbItem then do:
    
        assign
            tbItem.upImage = defUpIcon
        .
        
        /*
         * Change the state. If the state is delete then changing the
         * image won't hurt
         */
         
        if tbItem.state = "create" then tbItem.state = "modify-new".
       	if tbItem.state = "" then tbItem.state = "modify-existing".
      
    end.
    
end.

if mnuFeatures.defaultDownIcon <> defDownIcon then do:

    assign
        mnuFeatures.defaultDownIcon = defDownIcon
        s = true
    .
    
    /*
     * If there is a toolbar button attached then change the image
     */
    
    if available tbItem then do:
    
        assign
            tbItem.downImage = defDownIcon
        .
        
        /*
         * Change the state. If the state is delete then changing the
         * image won't hurt
         */
         
        if tbItem.state = "create" then tbItem.state = "modify-new".
       	if tbItem.state = "" then tbItem.state = "modify-existing".
      
    end.
end.

if mnuFeatures.defaultInsIcon <> defInsIcon then do:

    assign
        mnuFeatures.defaultInsIcon = defInsIcon
        s = true
    .
    
    /*
     * If there is a toolbar button attached then change the image
     */
    
    if available tbItem then do:
    
        assign
            tbItem.insImage = defInsIcon
        .
        
        /*
         * Change the state. If the state is delete then changing the
         * image won't hurt
         */
         
        if tbItem.state = "create" then tbItem.state = "modify-new".
       	if tbItem.state = "" then tbItem.state = "modify-existing".
      
    end.
end.

if mnuFeatures.microHelp <> microHelp then do:

    assign
        mnuFeatures.microHelp = microHelp
        s = true
    .

end.
/*
 * Set the menu state to reflect the changes, if something really changed
 */

if s = false then return.

if mnuFeatures.state = "" then mnuFeatures.state = "modify-existing".
if mnuFeatures.state = "create" then mnuFeatures.state = "modify-new".




