/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 *
 *  _mgett2.p
 *
 *	return all the information about a particular toolbar button
 *      based on the feature id.
 */

{ adecomm/_mtemp.i }
{ {&mdir}/_mnudefs.i}

define input  parameter appId        as character no-undo.
define input  parameter featureId    as character no-undo.
define input  parameter toolbarId    as character no-undo.
define output parameter upImage      as character no-undo.
define output parameter downImage    as character no-undo.
define output parameter insImage     as character no-undo.
define output parameter itype        as character no-undo.
define output parameter userDefined  as logical   no-undo.
define output parameter prvData      as character no-undo.
define output parameter x            as integer   no-undo.
define output parameter y            as integer   no-undo.
define output parameter w            as integer   no-undo.
define output parameter h            as integer   no-undo.
define output parameter itemHandle   as widget    no-undo.
define output parameter editHandle   as widget    no-undo.
define output parameter found        as logical   no-undo initial false.

find first tbItem where tbItem.featureId = featureId
                     and tbItem.appId = appId 
                     and tbItem.toolbarId = toolbarId no-error.

IF (not available tbItem) THEN return.

/*
 * Say the record isn't found if the state says deleted
 */

if    tbItem.state = "delete-existing"
   or tbItem.state = "delete-new" then return.

assign
    found        = true
    upImage      = tbItem.upImage
    downImage    = tbItem.downImage
    insImage     = tbItem.insImage
    itype        = tbItem.type
    userDefined  = tbItem.userDefined
    prvData      = tbItem.prvData
    x            = tbItem.x
    y            = tbItem.y
    w            = tbItem.w
    h            = tbItem.h
    itemHandle   = tbItem.handle
    editHandle   = tbItem.editHandle
.




