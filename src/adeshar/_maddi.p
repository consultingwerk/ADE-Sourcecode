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
 * _maddi.p
 *  
 *    Add a new menu item to a menu.
 *
 *  Input Parameters
 *
 *    appId            THe application client this item belongs to.
 *    featureId        The feature that the menu item represents.
 *    parentId         The menu the menu item is to be added.
 *    l                The label of the menu item
 *    iType            The type of menu item. See _mnudefs.i for list.
 *    userDefined      
 *    prvData          A character field that can be used by the application
 *
 *  Output Parameters
 *
 *    s                The state. False if the feature or parent do not exist.
 *                     This routine does no "publically" announce if there
 *                     is a failure.
 */
{ adecomm/_mtemp.i }
{ {&mdir}/_mnudefs.i}

define input  parameter appId        as character no-undo.
define input  parameter featureId    as character no-undo.
define input  parameter parentId     as character no-undo.
define input  parameter labl         as character no-undo.
define input  parameter iType	     as character no-undo.
define input  parameter userDefined  as logical	  no-undo.
define input  parameter prvData      as character no-undo.
define output parameter s            as logical   no-undo initial false.

define variable makeIt as logical no-undo initial true.

/*message "featureId " featureId "xxx" skip
        "label     " labl "xxx" skip
        "parentId  " parentId skip
	"type      " iType
        view-as alert-box error buttons ok.*/
/*
 * First check to see if the feature is available in the list of
 * features. If not. Exit. Menu spes are different. They can be in
 * muliple places.
 */

if featureId <> {&mnuSepFeature} then do:

    find first mnuFeatures where mnuFeatures.appId = appId
                           and  mnuFeatures.featureId = featureId 
                           and  mnuFeatures.secure = false no-error.

    IF (not available mnuFeatures) THEN return.

end.

/*
 * Make sure that there is something to attach to.
 */

find first mnuMenu where mnuMenu.labl = parentId 
                    and  mnuMenu.appId = appId no-error.

if not available mnuMenu then return.

/*
 * The following insert works around a problem with trailing blanks
 * in our sep names
 */

{ {&mdir}/_mwo1.i &labl = labl}

/*
 * The user wants to add a new menuitem to the menubar. If the menu item is
 * already anywhere on a menu then see if the item has been marked for delete. 
 */
if featureId <> {&mnuSepFeature} then do:

    find first mnuItems where mnuItems.appId = appId
                        and   mnuItems.labl = labl no-error.

    if available mnuItems then do:

        assign
            s = true
            makeIt = false
        .
    
        if mnuItems.state = "delete-new" then mnuItems.state = "create".
        if mnuItems.state = "delete-existing" then do:
    
            mnuItems.state = "modify-existing".
    
            /*
             * If the user has deleted the menu during this edit session
             * and now wnat to reattach then note that "a move" has occured.
             * THe menu update will physically
             * then move the menu item. Also give the menu item an updated
             * sequence number. Otherwise, the menu item may appear in the
             * wrong position in an edit list
             */
    
            if mnuItems.origParent = ? then do:
    
                find first mnuApp where mnuApp.appId = appid.
                assign
                    mnuItems.origParent = mnuItems.parentId 
                    mnuItems.sNum = mnuApp.sNum
                    mnuItems.handle:PRIVATE-DATA = string(mnuItems.sNum)
                    mnuApp.sNum = mnuApp.sNum + {&sNumOffset}
                .
    
            end.
        end.
    
        /*
         * Fall through. If any of the attr of a feature have changed they
         * will be updated.
         */
    
        if s = false then return.
    
    end.
end.

/*
 * If we have to make a new menu item then we now have to worry about
 * the current type. If the type is seperator then don't allow certain
 * attrs. If the menu item is a submenu then make some checks with regards
 * to what is available in the menu table.
 */

if makeIt = true then do:

    IF featureId = {&mnuSepFeature} THEN DO:

        /*
         * Seps are not under complete app control. We decide the actual
         * label, don't allow any functions etc
         */
        assign
            iType = {&mnuSepType}
            prvData = ""
            userDefined = false
        .
    
    END.
    ELSE IF mnuFeatures.type = {&mnuSubMenuType} THEN DO:
        
        /*
         * SUbmenus are not under complete app control.  We don't allow any
         * functions etc. Also, they share properties
         * of both menu item and menus, so a record will exist in both
         * tables for submenus. Check to see if this item exists in either
         * table
         */

        find first mnuItems where (mnuItems.labl = labl) 
                             and   (mnuItems.appId = appId)
                             and   (mnuItems.parentId = parentId) no-error.

        IF (available mnuItems) THEN return.

        find first mnuItems where (mnuItems.labl = labl) 
                            and   (mnuItems.appId = appId) no-error.
    
        IF (available mnuItems) THEN return.    

        assign
            iType = {&mnuSubMenuType}
            prvData = ""
            userDefined = false
        .

        /*
         * Submenus are special. They have proeprties of both the menu item and
         * menu. So We have a record in both tables! But, we don't want to
         * create another widget, so build the menu record by hand instead
         * of calling _maddm.i
         */

        create mnuMenu.

        assign
            mnuMenu.appId      = appId
            mnuMenu.labl       = labl
            mnuMenu.prvData    = prvData
            mnuMenu.type       = {&mnuSubMenuType}
            mnuMenu.state      = "create"
        .

    end.

    /*
     * The preliminaries for the special types of menu itmes have been
     * completed. Create the record and set the important information.
     */

    find first mnuApp where mnuApp.appId = appid.
    create mnuItems.

    assign
        mnuItems.appId      = appId
        mnuItems.featureId  = featureId
        mnuItems.type       = iType
        mnuItems.state      = "create"
        s                   = true
        mnuItems.origParent = ?
        mnuItems.sNum       = mnuApp.sNum
        mnuApp.sNum         = mnuApp.sNum + {&sNumOffset}
    .

end.

assign
    mnuItems.labl       = labl
    mnuItems.parentId  = parentId
    mnuItems.userDefined = userDefined
    mnuItems.prvData     = prvData
.

