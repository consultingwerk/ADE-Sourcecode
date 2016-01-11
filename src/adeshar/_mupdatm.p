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
 * _mupdatm.p
 *  
 *    Reconcile the state of the menubar. Walk through each record
 *    in the feature, menu, and menu item temp tables and see if any of the
 *    records are dirty. Then do what is required to make the menubar in
 *    synch with the temp tables
 *
 *  Input Parameters
 *
 *    appId            THe application client this item belongs to.
 *
 * Stuff to know:
 *
 * There can only be one feature attached to a menu item. This is an
 * explicit design decision. Much of the code assumes this fact!
 *
 * The states are maintained in the various calls that
 * deal with records. The current state indicates what we should do
 * with the record.
 */

{ adecomm/_mtemp.i}
{ {&mdir}/_mnudefs.i}

define input parameter appId   as character no-undo.

find first mnuApp where mnuApp.appId = appId.

run synchFeatures.
run synchMenus.
run synchMenuItems.
run makeFeatureList.

procedure makeFeatureList.

/*
 * This procedure creates the comma seperated list of features
 * currently available in the menus. This list is created for performance
 * reasons. This list is sent everytime _machk.p is called. The is built
 * only when needed.
 *
 * And since this is being driven off of the list of available menus then
 * the current user has permission to to use the feature. WHy? We don't
 * create a menu item the user can not use.
 */

define variable lookAhead as character no-undo initial "".

assign
    mnuApp.mFeatureList = ""
    mnuApp.mSensList = ""
    mnuApp.mToggList = ""
.

for each mnuItems where mnuItems.appId = appId:

    /*
     * Now find the feature attached to this menu item
     */

    find first mnuFeatures
         where mnuItems.featureId = mnuFeatures.featureId
         and   mnuItems.appId = mnuFeatures.appId.

    assign
        mnuApp.mFeatureList = mnuApp.mFeatureList
                              + lookAhead
                              + mnuFeatures.featureId 

        mnuApp.mSensList   = mnuApp.mSensList
                             + lookAhead
                             + "true" 

        mnuApp.mToggList    = mnuApp.mToggList
                              + lookAhead
                              + "true" 

        lookAhead = ","
    .

end.

end.
procedure synchFeatures.

/*
 * Work only with the records that belong to the named application
 */

    for each mnuFeatures where mnuFeatures.appId = appId:

        case mnuFeatures.state:

            when "create"          or
            when "modify-existing" or
            when "modify-new" then do:

                /*
                 * is there naything to do besides setting the state
                 * to "already existing". In the case of modify, the
                 * record has already changed. Its just that there
                 * are no GUI things attached to a feature.
                 */

                mnuFeatures.state = "".
 
            end.
  
            when "delete-existing" or
            when "delete-new" then do:
    
                delete mnuFeatures.
            end.
        end case.
    end.
end procedure.

procedure synchMenus.

    define variable subMenu as widget no-undo.

    /*
     * Just in case, if there's no menu bar then let the client know and go
     *  away
     */

    if mnuApp.menubar = ? or (not valid-handle(mnuApp.menubar)) then do:

        if mnuApp.displayMessages then
            message "Attempting to attach a sub menu to an" skip
                    "invalid menubar widget." skip
            view-as alert-box.
        return.
    end.

    /*
     * Work only with the records that belong to the named application.
     * And don't delete submenus
     */
    for each mnuMenu where mnuMenu.appId = appId:

        case mnuMenu.state:
    
            /*
             * If the the state is "create" or "modify-new" then
             * create the widgets. "Modify-new" means that
             * the record was created and changed during this edit
             * session. THerefore there is no widget
             */
                 
            when "create"     or
            when "modify-new" then do:
               
                /*
                 * Deal with submenus. If the menu is a submenu then
                 * don't create it. That is handled as part of 
                 * synchMenuItem
                 */

                if mnuMenu.type = {&mnuSubMenuType} then next.

                create sub-menu subMenu
                assign
                    label         = mnuMenu.labl
                    parent        = mnuApp.menuBar
                    private-data  = mnuMenu.prvData
                    /*
                     * This only works because a user can't change
                     * the items in the toolbar. Of course, having to
                     * hardcode the string doesn't help I18N either.
                     * The menu system will have to add an attr in a future
                     * release.
                     */
                    sub-menu-help = (mnuMenu.labl = "&Help")
                .

                assign
                    mnuMenu.menuHandle = subMenu
                    mnuMenu.state = ""
                .

            end.
    
            when "delete-existing" or
            when "delete-new"      then do:

                    /*
                     * Delete the menu. But check the handle first. The
                     * sub menu widget may have laready been deleted. This
                     * can happen if the parent-handle of this menu has
                     * already been deleted. If a parent in the hierarchy
                     * is deleted, then all the siblings go too!
                     */

                    if valid-handle(mnuMenu.menuHandle) = true
                        then delete widget mnuMenu.menuHandle.
                    delete mnuMenu.
            end.
    
            when "modify-existing" then do:

                /*
                 * What does it mena to have a modified menu handle. We
                 * can't delete the menu, cuz all of its children will go
                 * away too.
                 */    
                assign
                    mnuMenu.state = ""
                .    

            end.
        end case.
    end.
end procedure.

procedure synchMenuItems.

    define variable menuItem as widget no-undo.

    /*
     * Work only with the records that belong to the named application. Work
     * with submenus, except for delete. Delete has to be done after the
     * children have been deleted.
     */
    for each mnuItems where mnuItems.appId = appId:

        case mnuItems.state:
   
            /*
             * Read notes in synchMenu about modify-new"
             */
            when "create"     or
            when "modify-new" then do:

                run createMenuItem.
    
            end.
   
            when "delete-existing" or
            when "delete-new" then do:

                define variable parentId as character no-undo.
                define variable labl     as character no-undo.

                /*
                 * Save some information needed after the record is
                 * gone. Use it to decide if the parent menu should
                 * be sensitive
                 */

                assign
                    parentId  = mnuItems.parentId
                    labl      = mnuItems.labl
                .

                /*
                 * Remove the widget. If it is exists/valid
                 */

                if valid-handle(mnuItems.handle) = true
                    then delete widget mnuItems.handle.
                delete mnuItems.

            end.    

            when "modify-existing" then do:

                /*
                 * Change the "simple" things
                 */    

                assign
                    mnuItems.handle:LABEL = mnuItems.labl
                    mnuItems.state = ""
                .

                /*
                 * If the menu item was moved from one sub-menu to another
                 * it must be reparented.
                 */

                if mnuItems.origParent <> ? then do:

                    /*
                     * Find the handle of the new parent
                     */

                    find first mnuMenu where mnuMenu.appId = mnuItems.appId
                                       and   mnuMenu.labl = mnuItems.parentId.

                    /*
                     * Progress doesn't allow us to set the parent after
                     * the menu item has a parent. So to move the menu item
                     * we have to delete and then create.
                     */

                    if valid-handle(mnuItems.handle) = true
                        then delete widget mnuItems.handle.
                    run createMenuItem.

                    mnuItems.origParent = ?.
                end.

            end.
        end case.
    end.
end.

procedure createMenuItem.

define variable menuItem as widget no-undo.

/*
 * Set the state, even if there is no real menu structure. There are
 * applications that want to create a menu structure without widgets (the
 * Results TTY to GUI converter comes to mind). The menu structure is
 * later properly instantiated.
 */

assign
    mnuItems.state = ""
.

/*
 * Get the widget handle that this item is attached to.
 */
                    
find first mnuMenu where mnuMenu.labl = mnuItems.parentId 
                    and   mnuMenu.appId = mnuItems.appId no-error.

/*
 * If there is no parent handle then let the applicationknow about it,
 * if the display flag is on. This may, or may not be a problem
 */

if    mnuMenu.menuHandle = ?
   or (not valid-handle(mnuMenu.menuHandle)) then do:

    return.
end.
/*
 * The menu now has a child. Make sure that the menu is sensitive. Do it now,
 * beacuse submenu eventually change the mnuMenu record.
 */

assign
    mnuMenu.menuHandle:SENSITIVE = true
.

/* Create the menu item, depending on the subclass
 */
                    
if (mnuItems.featureId = {&mnuSepFeature}) then do:
                    
    CREATE MENU-ITEM menuItem 
        ASSIGN
            SUBTYPE = "RULE"
            PARENT  = mnuMenu.menuHandle
        .
end.
else if mnuItems.type = {&mnuSubMenuType} then do:

    CREATE SUB-MENU menuItem
        ASSIGN 
            LABEL        = mnuItems.labl
            PARENT       = mnuMenu.menuHandle
            PRIVATE-DATA = mnuItems.prvData
    .

    /*
     * The first find of mnuMenu found the parent record that the submenu
     * is attached to. Now find the menu record for the submenu. We have to
     * to store the newly created handle for all the children of the submenu
     */

    find first mnuMenu where mnuMenu.labl = mnuItems.labl 
                        and   mnuMenu.appId = mnuItems.appId no-error.

    assign
        mnuMenu.menuHandle = menuItem
        mnuMenu.state = ""
    .
end.
else do:

   find first mnuFeatures
       where mnuFeatures.appId = mnuItems.appId
         and mnuFeatures.featureId = mnuItems.featureId.

    CREATE MENU-ITEM menuItem
        ASSIGN
            LABEL        = mnuItems.labl
            TOGGLE-BOX   = (mnuItems.type = {&mnuToggleType})
            SUBTYPE      = "NORMAL"
            PARENT       = mnuMenu.menuHandle
            PRIVATE-DATA = mnuItems.prvData
        TRIGGERS:
            ON CHOOSE, VALUE-CHANGED persistent
                run {&mdir}/_mfire.p(mnuItems.appId,
                                     mnuItems.featureId,
                                     menuItem).

         END TRIGGERS.
                    
    /*
     * Hard code, for now, the basic accelerators Results needs to support.
     * Hopefully, in future releases, this can be configured.
     */

    case mnuFeatures.featureId:

        when "FileOpen"         then menuItem:ACCELERATOR = "F3".
        when "NewDuplicateView" then menuItem:ACCELERATOR = "SHIFT-F3".
        when "FileSave"         then menuItem:ACCELERATOR = "F6".
        when "FileSaveAs"       then menuItem:ACCELERATOR = "SHIFT-F6".
        when "FileClose"        then menuItem:ACCELERATOR = "F8".

    end.
end.

assign
    mnuItems.handle = menuItem
    mnuItems.state = ""

.

end procedure.

