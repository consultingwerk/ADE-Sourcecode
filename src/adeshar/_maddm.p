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
 *  _maddm.p
 *
 *    Add a menu item
 */

{ adecomm/_mtemp.i }
{ {&mdir}/_mnudefs.i}

define input  parameter appId    as character no-undo.
define input  parameter labl     as character no-undo.
define input  parameter prvData  as character no-undo.
define input  parameter sensFunc as character no-undo.
define output parameter s        as logical   no-undo initial false.

define variable makeIt as logical no-undo initial true.
/*
 * The user wants to add a new menu to the menubar. If the menu item is
 * already then see if the feature has been marked for delete. 
 */

find first mnuMenu where     mnuMenu.appId = appId
                          and mnuMenu.labl = labl no-error.

if available mnuMenu then do:

        if mnuMenu.state = "delete-new" then
        assign
            mnuMenu.state = "create"
            s = true
            makeIt = false
        .

    if mnuMenu.state = "delete-existing" then
        assign
            mnuMenu.state = "modify-existing"
            s = true
            makeIt = false
        .

    /*
     * Fall through. If any of the attr of a feature have changed they
     * will be updated.
     */

    if s = false then return.

end.

if makeIt then do:

    /*
     * Some of the attrs of a feature can't be changed. These will only
     * be assigned when the record is created.
     */

    create mnuMenu.

    assign
        mnuMenu.appId  = appId
        mnuMenu.menuId = ""
        mnuMenu.type   = {&mnuMenuType}
        mnuMenu.state  = "create"
    .

end.

assign
    mnuMenu.labl         = labl
    mnuMenu.prvData       = prvData
    mnuMenu.sensFunction  = sensFunc
    s                     = true
.

