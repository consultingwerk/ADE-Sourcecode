/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 *  _mgetm.p
 *
 *    Get the information for the menu
 */
{ adecomm/_mtemp.i }
{ {&mdir}/_mnudefs.i}

define input  parameter appId        as character no-undo.
define input  parameter labl         as character no-undo.
define output parameter menuHandle   as widget    no-undo.
define output parameter prvData      as character no-undo.
define output parameter found        as logical   no-undo initial false.

find first mnuMenu where     mnuMenu.appId = appId
                          and mnuMenu.labl = labl no-error.

if (not available mnuMenu) then return.

assign
    found        = true
    menuHandle	 = mnuMenu.menuHandle
    prvData      = mnuMenu.prvData
.

