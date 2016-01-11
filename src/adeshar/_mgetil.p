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
 * _mgetil
 *
 *	Returns a comma seperated list of all the menu items attached to
 * a particular menu.
 *
 * If the menu provided by the caller is empty then an empty list is returned
 */

{ adecomm/_mtemp.i }
{ {&mdir}/_mnudefs.i}

define input  parameter appId    as character no-undo.
define input  parameter menuName as character no-undo.
define output parameter itemList as character no-undo initial "".

define variable look  as character initial "".
define variable token as character.

/*
 * First, check to see if the menu named provided actually exists
 */

find first mnuMenu where mnuMenu.labl = menuName
                    and   mnuMenu.appId = appId no-error.

IF (not available mnuMenu) THEN return.

/*
 * Walk the temp table and build the list. Use the ids and not the widgets,
 * since an item may be created in an edit session ...
 */

for each mnuItems where (mnuItems.parentId = mnuMenu.labl)
                    and (mnuItems.appId = appId):

    if    mnuItems.state = "delete-existing" 
       or mnuItems.state = "delete-new" then next.

    token = mnuItems.labl.

    /*
     * Worry about the seperators. Rearrange the name to what the
     * user expects
     */

    { {&mdir}/_mwo1o.i &labl = token}

    assign
        itemList = itemList + look + token
        look = ","
    .
end.



