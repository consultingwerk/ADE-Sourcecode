/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 *
 *  _mgeti2.p
 *
 *	return all the information about a particular menu item,
 *      based on the feature id.
 */
{ adecomm/_mtemp.i }
{ {&mdir}/_mnudefs.i}

define input  parameter appId        as character no-undo.
define input  parameter featureId    as character no-undo.
define output parameter labl         as character no-undo.
define output parameter itype        as character no-undo.
define output parameter userDefined  as logical   no-undo.
define output parameter itemHandle   as widget    no-undo.
define output parameter parentHandle as widget    no-undo.
define output parameter parentId     as character no-undo.
define output parameter found        as logical   no-undo initial false.

find first mnuItems where mnuItems.featureId = featureId
                     and   mnuItems.appId = appId no-error.

IF (not available mnuItems) THEN return.

/*
 * Say the record isn't found is the state says its deleted
 */

if    mnuItems.state = "delete-existing"
   or mnuItems.state = "delete-new" then return.

assign
    found        = true
    labl         = mnuItems.labl
    itype        = mnuItems.type
    userDefined  = mnuItems.userDefined
    parentId     = mnuItems.parentId
    itemHandle   = mnuItems.handle
    parentHandle = if (mnuItems.handle <> ?)
                       then mnuItems.handle:PARENT else ?
.

{ {&mdir}/_mwo1o.i &labl = labl}


