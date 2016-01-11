/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
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




