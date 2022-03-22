/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * _mcheckm.p
 *
 *    Calls application callback to detirmine if menus should be dithered.
 *
 *    Because there are fewer menus across the top and because this function
 *    is used sparingly we'll build the lists on the fly.
 */

{ adecomm/_mtemp.i }
{ {&mdir}/_mnudefs.i}

define input  parameter appId as character no-undo.
define output parameter s     as logical   no-undo initial false.

define variable menuList  as character no-undo.
define variable sensList  as character no-undo.
define variable toggList  as character no-undo.
define variable lookAhead as character no-undo initial "".
define variable i         as integer   no-undo initial 1.

find first mnuApp where mnuApp.appId = appId no-error.
if not available mnuApp then return.

/*
 * If there's no function to tell us the state of the items then
 * go away
 */

if (mnuApp.sensFunction = ?) or (mnuApp.sensFunction = "") then return.

/* 
 * Walk through each menu and have the application verify its state. Only
 * do it for the menu bar though. The submenu's are handled as
 * features/menuitems.
 */

assign
    menuList = ""
    sensList = ""
    toggList = ""
    s        = true
.

for each mnuMenu where mnuMenu.appId = appId
                   and mnuMenu.type <> {&mnuSubMenuType}:

    assign
        menuList = menuList + lookAhead + mnuMenu.labl
        sensList = sensList + lookAhead + "true"
        toggList = toggList + lookAhead + "true"
        lookAhead = ","
    .

end.

badfile:
do on stop undo badfile, retry badfile:

    if retry then do:
         message "Sensitive Function Not Found or has a problem." skip
                 "appId     " mnuApp.appId skip
                 "function  " mnuApp.sensFunction skip
         view-as alert-box error buttons ok.

         return.
    end.

    run value(mnuApp.sensFunction)(mnuApp.appId,
                                     menuList,
                                     mnuApp.prvHandle,
                                     mnuApp.prvData,
                                     input-output sensList,
                                     input-output toggList).

end.

for each mnuMenu where mnuMenu.appId = appId
                   and mnuMenu.type <> {&mnuSubMenuType}:

    assign
        mnuMenu.menuHandle:SENSITIVE = (entry(i, sensList) = "true")
        i = i + 1
    .
end.
