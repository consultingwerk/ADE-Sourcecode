/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 *  _mreset.p
 *
 *    Delete all the entries in all the menu and menu item tables.
 *    Optionally delete the features (except for the the
 *    seperator feature).
 *
 *  Input Parameters
 *
 *     appId       - The application
 *     delFeatures - Delete the non-user defined features.
 *     delUser     - Delete the user defined features
 *     delMenu     - Delete the actual menu widgets.
 *     delSMenu    - If delMenu is true and this is true then only
 *                   submenu will be delete from the list of menus
 *     menuBar     - The menubar.
 */

{ adecomm/_mtemp.i }
{ {&mdir}/_mnudefs.i}

define input  parameter appId       as character no-undo.
define input  parameter delFeatures as logical   no-undo.
define input  parameter delUser	    as logical   no-undo.
define input  parameter delMenu     as logical   no-undo.
define input  parameter delSMenu    as logical   no-undo.
define input  parameter menuBar     as widget    no-undo.

define variable s      as logical no-undo.

/*
 * Delete all features, if desired
 */

if delFeatures = true or delUser = true then do:

    for each mnuFeatures where mnuFeatures.appId = appId:
            
        /*
         * Delete the application feature if the user wants to
         */
             
         if (delFeatures = true) and (mnuFeatures.userDefined = false)
             then delete mnuFeatures.
    end.

    /*
     * It was easier just to delete the seperator feature. Now readd it. If
     * it wasn't deleted then this function will not add a dup, but will
     * return with no error
     */

    run {&mdir}/_maddf.p(appId, {&mnuSepFeature},
                                {&mnuItemType},
                                ?, 
                                ?,
                                {&mnuSepFeature},
                                ?,
                                ?,
                                ?,
                                {&mnuSepHelp},
                                FALSE,
                                "",
                                "*",
                                output s).
end.

for each mnuMenu where mnuMenu.appId = appId:

    if delMenu then do:

        /*
         * Delete if we can delete menu items and if delete Sub menu
         * is on then only delete submenus.
         */

        if (delSMenu and mnuMenu.type <> {&mnuSubMenuType}) then next.

        if valid-handle(mnuMenu.menuHandle) then
            delete widget mnuMenu.menuHandle.
    end.
    
delete mnuMenu.
end.

for each mnuItems where mnuItems.appId = appId:
    
    if delMenu and valid-handle(mnuItems.handle) then
         delete widget mnuItems.handle. 
    
    delete mnuItems.
end.

find first mnuApp where mnuApp.appId = appId.
mnuApp.menuBar = menuBar.




