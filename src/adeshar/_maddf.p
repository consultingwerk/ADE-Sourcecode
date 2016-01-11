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
 *  _maddf.p
 *
 *    Add a menu feature.
 *
 *  Input Parameters
 *
 *    id              The unique caharacter string identifying this feature.
 *    mtype           The type of the feature, either for submenu or menu item.
 *                    See _mnudefs.i.
 *    f               The fucntion to execute when the feature is chosen.
 *    args            The args to be passed to the function,
 *    defaultLabel    The default label for any future menu item that is
 *                    attached to the feature.
 *    defaultUpIcon   The default icon for this feature, if it is added to
 *                    a toolbar.
 *    defaultDownIcon The default icon for this feature, if it is added to
 *                    a toolbar.
 *    defaultInsIcon  The default icon for this feature, if it is added to
 *                    a toolbar.
 *    microHelp       A short piece of descriptive text.
 *    userDefined     Application or end user defined.
 *
 *  Output Parameters
 *
 *    s            True if the feature was added
 *
 *
 *  IF the arguments get changed for this function then _mwrite
 *  *MUST* be changed to reflect updated argument list!
 */

{ adecomm/_mtemp.i }
{ {&mdir}/_mnudefs.i}

define input  parameter appId           as character no-undo.
define input  parameter id              as character no-undo.
define input  parameter mtype           as character no-undo.
define input  parameter f               as character no-undo.
define input  parameter args            as character no-undo.
define input  parameter defaultLabel    as character no-undo.
define input  parameter defaultUpIcon   as character no-undo.
define input  parameter defaultDownIcon as character no-undo.
define input  parameter defaultInsIcon  as character no-undo.
define input  parameter microHelp       as character no-undo.
define input  parameter userDefined     as logical   no-undo.
define input  parameter prvData         as character no-undo.
define input  parameter secureList      as character no-undo.
define output parameter s               as logical   no-undo initial false.

define variable makeIt as logical no-undo initial true.

/*message "id        " id skip
        "app       " appId skip
        "function  " f  skip
        "args      " args skip
        "defLabel  " defaultLabel skip
        "defUpIcon " defaultUpIcon skip
        "defUpIcon " defaultDownIcon skip
        "userDef   " userDefined skip
        view-as alert-box error buttons ok.*/

/*
 * See if the the application is registered
 */

find first mnuApp where mnuApp.appId = appId no-error.
if not available mnuApp then return.

/*
 * First see if there is already a feature. If there is don't leave right
 * away. See if the feature has been marked for delete. If it has been marked
 * for delete then unmark it
 */

find first mnuFeatures where mnuFeatures.appId = appId 
                          and mnuFeatures.featureId = id no-error.

if available mnuFeatures then do:

    /*
     * OK, there's an existing record. Set state to modify, if this
     * record existed before.
     */

    if mnuFeatures.state = "delete-new" then
        assign
            mnuFeatures.state = "create"
            s = true
            makeIt = false
        .

    if mnuFeatures.state = "delete-existing" then
        assign
            mnuFeatures.state = "modify-existing"
            s = true
            makeIt = false
        .

    /*
     * Fall through. If any of the attr of a feature have changed they
     * will be updated.
     */

    if s = false then return.

end.

/*
 * The client is adding a new feature to the list.
 */

if makeIt then do:

    /*
     * Some of the attrs of a feature can't be changed. They will only
     * be assigned when the record is created.
     */

    create mnuFeatures.

    assign
        mnuFeatures.appId        = appId
        mnuFeatures.featureId    = id
        mnuFeatures.type         = mtype
        mnuFeatures.state        = "create"
        mnuFeatures.securityList = secureList
        mnuFeatures.secure       = false
    .

end.

/*
 * Change ? to "". That makes the rest of the code a little easier to
 * deal with. Eventually, all values should be checked. And submenus
 * don't have any function, even if one was provided!
 */

assign
    mnuFeatures.functionId        = if mtype = {&mnuSubMenuType}
                                          then "" else f
    mnuFeatures.args              = if args = ?
                                          then "" else args
    mnuFeatures.defaultLabel      = if defaultLabel = ?
                                          then "" else defaultLabel
    mnuFeatures.defaultUpIcon     = if defaultUpIcon = ?
                                          then "" else defaultUpIcon
    mnuFeatures.defaultDownIcon   = if defaultDownIcon = ?
                                          then "" else defaultDownIcon
    mnuFeatures.defaultInsIcon   = if defaultInsIcon = ?
                                          then "" else defaultInsIcon
    mnuFeatures.microHelp        = if microHelp = ?
                                          then "" else microHelp
    mnuFeatures.userDefined      = if userDefined = ?
                                          then true else userDefined
    mnuFeatures.prvData          = if prvData = ?
                                          then "" else prvData
.


