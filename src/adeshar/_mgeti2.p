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


