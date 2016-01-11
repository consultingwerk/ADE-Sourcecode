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




