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
 * _mchgi.p
 *
 *    Change the label of a menu item
 */

{ adecomm/_mtemp.i }
{ {&mdir}/_mnudefs.i}

define input  parameter appId     as character no-undo.
define input  parameter menuId    as character no-undo.
define input  parameter featureId as character no-undo.
define input  parameter newLabel  as character no-undo.
define output parameter s         as logical   no-undo initial false.

define variable oldLabel as character no-undo.

/* Make sure that the feature really exists, and don't even allow
 * seps to be changed.
 */

find first mnuFeatures where mnuFeatures.featureId = featureId 
                       and   mnuFeatures.appId     = appId no-error.

if (not available mnuFeatures) then return.

if (featureId = {&mnuSepFeature}) then return.

/*
 * If this label already is being used in the menu then don't
 * continue the operation.
 */

find first mnuItems where (mnuItems.parentId = menuId)
                    and   (mnuItems.appId    = appId)
                    and   (mnuItems.state    <> "delete-existing")
                    and   (mnuItems.state    <> "delete-new")
                    and   (mnuItems.labl     = newLabel) no-error.

IF (available mnuItems) THEN return.

/*
 * Find the menu item attached to this feature and change the label.
 */

find first mnuItems where mnuItems.featureId = featureId
                    and   mnuItems.appId     = appId.

/*
 * Say the record isn't found if the state says deleted
 */

if    mnuItems.state = "delete-existing"
   or mnuItems.state = "delete-new" then return.

assign
	s = true
        oldLabel = mnuItems.labl
	mnuItems.labl = newLabel
.

/*
 * Set the state. The work done to the labels is done at update time.
 */

if mnuItems.state = "" then mnuItems.state = "modify-existing".
                       else mnuItems.state = "modify-new".

/*
 * Update the attached children of the sub menu.
 */

if mnuFeatures.type = {&mnuSubMenuType} then do:

    find first mnuMenu where mnuMenu.appId = appId 
                       and   mnuMenu.labl = oldLabel.

    mnuMenu.labl = newLabel.

    find first mnuItems where mnuItems.appId = appId
                        and   mnuItems.parentId = oldLabel no-error.

    if available mnuItems then do:

        for each mnuItems where mnuItems.appId = appId
                          and   mnuItems.parentId = oldLabel:

            mnuItems.parentId = newLabel.
        end.
    end.
end.



