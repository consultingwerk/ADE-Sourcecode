/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 *  _mmclose.p
 *
 *    Write out the current state of the menus into the file name provided
 *    by the user. We will overwrite the existing file without asking for
 *    permission!
 */

{adecomm/_mtemp.i}
{{&mdir}/_mnudefs.i}

define input  parameter appId     as character no-undo.
define input  parameter fileName  as character no-undo.

run {&mdir}/_mwrite.p(appId, fileName, "mt", "m").

