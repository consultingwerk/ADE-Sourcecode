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



