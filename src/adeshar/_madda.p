/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * _madda.p
 *
 *    Register an application with the menu subsystem.
 *
 *  Input Parameter
 *
 *    appId      THe name of the applciation
 *
 *    prvData    The application's private data
 *
 *    prvHandle  The application's private handle. 
 *
 *  Output Parameter
 *
 *    s   Returns false if there is already an application with the name.
 */

{ adecomm/_mtemp.i }
{ {&mdir}/_mnudefs.i }

define input  parameter appId     as character no-undo.
define input  parameter prvhandle as widget    no-undo.
define input  parameter prvData   as character no-undo.
define output parameter s         as logical   no-undo initial false.

define variable lJunk as logical no-undo.

find first mnuApp where mnuApp.appId = appId no-error.
if available mnuApp then return.

create mnuApp.

assign
    mnuApp.appId     = appId
    mnuApp.prvHandle = prvHandle
    mnuApp.prvData   = if prvData = ? then "" else prvData
    mnuApp.sepCount  = 1
    mnuApp.sNum      = {&sNumOffset}
    s                = true
.

/*
 * Provide the only features that comes with the menu package, the
 * seperator and sub menu. And do this before going to the application or file
 * for the information
 */

run {&mdir}/_maddf.p(appId, {&mnuSepFeature},
                            {&mnuSepType},
                            ?, 
                            ?,
                            {&mnuSepFeature},
                            ?,
                            ?,
                            ?,
                            {&mnuSepHelp},
                            FALSE,
                            "",
                            "*",
                            output lJunk).
