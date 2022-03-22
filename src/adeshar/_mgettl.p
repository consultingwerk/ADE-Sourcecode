/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * _mgettl
 *
 *	Returns a comma seperated list of all the features that
 *      are represented in a toolbar
 *
 * If the toolbar is empty then an empty list is returned
 */

{ adecomm/_mtemp.i }
{ {&mdir}/_mnudefs.i}

define input  parameter appId    as character no-undo.
define output parameter itemList as character no-undo initial "".

define variable look as character initial "".

/*
 * First, check to see if the menu named provided actually exists
 */

find first tbItem where tbItem.appId = appId no-error.

IF (not available tbItem) THEN return.

/*
 * Walk the temp table and build the list.
 */

for each tbItem:

    assign
        itemList = itemList + look + tbItem.featureId
        look = ","
    .

end.

