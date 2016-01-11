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
 *  _mdeli.p
 *
 *    Deletes a menu item from the screen and removes it from the
 *     internal data structures.
 *
 *  Input Parameters
 *
 *    a     THe application
 *    l     The lable of the menu item to be deleted.
 *    delSm	Delete the children of a sm if true.
 *    s     The status. False if there is no menu item with the label.
 */

{ adecomm/_mtemp.i }
{ {&mdir}/_mnudefs.i}

define input  parameter appId as character no-undo.
define input  parameter labl  as character no-undo.
define input  parameter delSm as logical   no-undo.
define output parameter s     as logical   no-undo initial false.

define variable parentId    as character no-undo.
define variable iLabel      as character no-undo.
define variable areChildren as logical   no-undo.

{ {&mdir}/_mwo1.i &labl = labl}

find first mnuItems where mnuItems.labl = labl
                     and   mnuItems.appId = appId no-error.

IF (not available mnuItems) THEN return.

/*
 * *Before* removing the menu item, decide if this is a sub menu. If it
 * is only allow delete if there is nothing attached to this sub menu.
 */

if mnuItems.type = {&mnuSubMenuType} then do:

    run {&mdir}/_mgetsmc.p(appId, labl, output areChildren).
    
    if areChildren = true then do:
        
        /*
         * There are things attached to this submenu. How do we handle it?
         */

        if delSm = true then do:
        
            /* 
             * Delete the items belonging to this submenu
             */
             
            run {&mdir}/_mdelsm.p(appId, mnuItems.labl, output s).
        end.
        else do:

            message "Cannot remove this sub menu." skip
                    "There are items still attached." skip
                    view-as alert-box error buttons ok.
            return.
        end.
    end.

    /*
     * If this a submenu then we have to mark the menu part of the
     * submenu as deleted.
     */

    find first mnuMenu where mnuMenu.appId = appId
                        and   mnuMenu.labl = labl no-error.

    if mnuMenu.state = "modify-new" then mnuMenu.state = "delete-new".
    if mnuMenu.state = "modify-existing" 
        then mnuMenu.state = "delete-existing".
    if mnuMenu.state = "" then mnuMenu.state = "delete-existing".
    if mnuMenu.state = "create" then mnuMenu.state = "delete-new".

end.

assign
    s         = true
.

if mnuItems.state = "modify-new" then mnuItems.state = "delete-new".
if mnuItems.state = "modify-existing" 
    then mnuItems.state = "delete-existing".
if mnuItems.state = "" then mnuItems.state = "delete-existing".
if mnuItems.state = "create" then mnuItems.state = "delete-new".




