/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 *  _mresett.p
 *
 *    Delete all the entries in the toolbar data structures.
 */

{ adecomm/_mtemp.i }
{ {&mdir}/_mnudefs.i}

define input  parameter appId as character no-undo.

define variable handle as widget  no-undo.
define variable s      as logical no-undo.

/*
 * Delete the widget first
 */
for each tbItem:

    if tbItem.appId <> appId then next.

    if valid-handle(tbItem.handle) then delete widget  tbItem.handle.
    if valid-handle(tbItem.editHandle) then delete widget  tbItem.editHandle.

    delete tbItem.
end.
