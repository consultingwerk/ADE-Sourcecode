/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 *  _mgeti.p
 *
 *    Returns all info about a menu item, using the label as the search
 *    criteria
 */
{ adecomm/_mtemp.i }
{ {&mdir}/_mnudefs.i}

define input  parameter appId        as character no-undo.
define input  parameter labl         as character no-undo.
define output parameter featureId    as character no-undo.
define output parameter iType        as character no-undo.
define output parameter userDefined  as logical   no-undo.
define output parameter itemHandle   as widget    no-undo.
define output parameter parentHandle as widget    no-undo.
define output parameter found        as logical   no-undo initial false.

{ {&mdir}/_mwo1.i &labl = labl}

find first mnuItems where mnuItems.labl = labl
                     and   mnuItems.appId = appId no-error.

IF (not available mnuItems) THEN return.

/*
 * Say the record isn't found is the state says its deleted
 */

if    mnuItems.state = "delete-existing"
   or mnuItems.state = "delete-new" then return.

assign
    found        = true
    featureId    = mnuItems.featureId
    iType        = mnuItems.type
    userDefined  = mnuItems.userDefined
    itemHandle   = mnuItems.handle

    /*
     * There may not be a parent when aked for the information. This can
     * happen when a menu item is newly created and before the update.
     */
    parentHandle = if (mnuItems.handle <> ?)
                       then mnuItems.handle:PARENT else ?
.



