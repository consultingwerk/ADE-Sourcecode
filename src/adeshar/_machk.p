/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * _machk.p
 *
 *    Allows the application to check the state of all features.
 *
 *    This is intended to be called in application code.
 */

{ adecomm/_mtemp.i }
{ {&mdir}/_mnudefs.i }

define input  parameter appId as character no-undo.
define output parameter s     as logical   no-undo initial false.

define variable i         as integer no-undo initial 1.

find first mnuApp where mnuApp.appId = appId no-error.
if not available mnuApp then return.

/*
 * If there's no function to tell us the state of the items then
 * go away
 */

if (mnuApp.sensFunction = ?) or (mnuApp.sensFunction = "") then return.

/*
 * Ask the application the state of the menu item
 */

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
                                     mnuApp.mFeatureList,
                                     mnuApp.prvHandle,
                                     mnuApp.prvData,
                                     input-output mnuApp.mSensList,
                                     input-output mnuApp.mToggList).

end.

/*
 * Now walk through the responses and set the values. We make the huge
 * assumption that the application didn't screw up anything.
 *
 * The following is based on the fact that the menuitems table is
 * indexed. We'll walk through each menuitem. The applications prebuilt
 * feature list is in the same order. This "fact" allows us to loop
 * on mnuItems and not on mnuFeatures. If we looped on menu
 * features then we'd need a find statement.
 */

assign
    s = true
.

for each mnuItems:

    if (mnuItems.appId = appId) then do:
	
        /*
         * Make sure that there is really a menu item out there.
         * There is always a record in the mnuItmes list, even
         * if the user doesn't haver permission to use the
         * feature. When the user can't use a feature then the
         * widget is NULL. For performance, we use this as the
         * indicator. It saves an extra search.
         */

        IF valid-handle(mnuItems.handle) then do:
           
          mnuItems.handle:SENSITIVE = entry(i, mnuApp.mSensList) = "true".

          if mnuItems.type = {&mnuToggleType} then
              mnuItems.handle:CHECKED =
                  (entry(i, mnuApp.mToggList) = "true").
        end.
        else if mnuItems.handle <> ? then
            message "Invalid Handle found during menu check for:"
            mnuItems.featureId skip
            view-as alert-box.

        i = i + 1.
    end.
end.

/*
 * Now on to the toolbar items. A sperate list of features is maintained
 * for features in the toolbar. Although most features on a toolbar will
 * also be on a menu it is faster to have two lists and make two calls.
 * Otherwise there would have to a be a combined list (which would not
 * allow for a simple "for each mnuItem" with easy access to the handle
 * or to walk through all the features, regardless if a feature is in a
 * toolbar or menu (an application may have
 * features that they put elswhere in their GUI, say a dialog box. Menu
 * features have grown beyond just the menu system). Also, walking the
 * feature list would require an extra find per feature to get back to the
 * handle. So make two calls.
 */

/*
 * Don't worry about the function no being here. It was already checked
 * when we went through the menus. But don't do anything if the
 * toolbar frame isn't visible or if we don't have one!
 */

if    mnuApp.toolbar = ?
   or valid-handle(mnuApp.toolbar) = false then return.

/*if mnuApp.toolbar:VISIBLE = false then return.*/

run value(mnuApp.sensFunction)(mnuApp.appId,
                                 mnuApp.tFeatureList,
                                 mnuApp.prvHandle,
                                 mnuApp.prvData,
                                 input-output mnuApp.tSensList,
                                 input-output mnuApp.tToggList).

i = 1.
for each tbItem:

    if (tbItem.appId = appId) then do:
	
        /*
         * Make sure that the info returned by the app is legal.
         */

        assign
            tbItem.handle:SENSITIVE = entry(i, mnuApp.tSensList) = "true"
            i = i + 1
        .
    end.
end.

