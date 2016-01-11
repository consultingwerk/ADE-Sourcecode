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
 *  _mdelsm.p
 *
 *    Deletes all the menu items from a sub menu
 *
 *  Input Parameters
 *
 *    a     THe application
 *    l     The label of the submenu to be deleted.
 *    s     The status. False if there is no sub menu with the label.
 */

{ adecomm/_mtemp.i }
{ {&mdir}/_mnudefs.i}

define input  parameter appId as character no-undo.
define input  parameter labl  as character no-undo.
define output parameter s     as logical   no-undo initial false.

define variable parentId as character no-undo.
define variable iLabel   as character no-undo.

{ {&mdir}/_mwo1.i &labl = labl}

/*
 * Walk through the menu items and see which are attached to the submenu
 */

for each mnuItems:

    if (mnuItems.appId = appId) and (mnuItems.parentId = labl) then do:
        
        run {&mdir}/_mdeli.p(appId, mnuItems.labl, true, output s).
    end.
end. 



