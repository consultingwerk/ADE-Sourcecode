/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 *  _mdelsm.p
 *
 *    Deletes all the menu items from a sub menu
 *
 *  Input Parameters
 *
 *    a     THe application
 *    l     The label of the submenu to be deleted.
 *    s     The status. False if there is no sub menu with the label.
 */

{ adecomm/_mtemp.i }
{ {&mdir}/_mnudefs.i}

define input  parameter appId as character no-undo.
define input  parameter labl  as character no-undo.
define output parameter s     as logical   no-undo initial false.

define variable parentId as character no-undo.
define variable iLabel   as character no-undo.

{ {&mdir}/_mwo1.i &labl = labl}

/*
 * Walk through the menu items and see which are attached to the submenu
 */

for each mnuItems:

    if (mnuItems.appId = appId) and (mnuItems.parentId = labl) then do:
        
        run {&mdir}/_mdeli.p(appId, mnuItems.labl, true, output s).
    end.
end. 



