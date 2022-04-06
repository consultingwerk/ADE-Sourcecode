/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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



