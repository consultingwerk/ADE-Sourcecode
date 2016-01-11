/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * _mgetml
 *
 *	Returns a comma seperated list of all the menu labels
 */

{ adecomm/_mtemp.i }
{ {&mdir}/_mnudefs.i}

define input  parameter appId    as character no-undo.
define output parameter menuList as character no-undo initial "".

define variable look as character initial "".

/*
 * Walk the temp table and build the list
 */

for each mnuMenu:

    if mnuMenu.appId = appId then	

        assign
            menuList = menuList + look + mnuMenu.labl
            look = ","
        .

end.
