/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 *  _msepnm.p
 *
 * This function exists to create a unique seperator name, so that 
 * the application doesn't have to worry about it. However,
 * the app has to call this function before creating the sep, 
 * the app needs this name to be added to the list, as well as
 * the database, and the names have to match.
 */

{ adecomm/_mtemp.i }
{ {&mdir}/_mnudefs.i}

define input  parameter appId   as character no-undo.
define output parameter sepName as character no-undo.

find first mnuApp where mnuApp.appId = appId.
if not available mnuApp then return.

assign 
    sepName = {&mnuSepFeature} + FILL(" ", mnuApp.sepCount)
    mnuApp.sepCount = mnuApp.sepCount + 1
.
