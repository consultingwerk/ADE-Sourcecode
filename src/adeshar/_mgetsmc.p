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
 *  _mgetsmc.p
 *
 *    Figure out if the are any children attached to a submenu. THis
 *    function is needed because the information may or may not be simple
 *    to find. Given the model, where the widgets aren't created until
 *    _mupdatm is run, then there could be children attached to a submenu
 *    but the information isn't available in the FIRST-CHILD.
 *    Alwasy use our tables!
 *
 *  Input Parameters
 *
 *    a         THe application
 *    l         The lable of the menu item to be deleted.
 *    s         The status. False if there are 0 children.
 */

{ adecomm/_mtemp.i }
{ {&mdir}/_mnudefs.i}

define input  parameter appId   as character no-undo.
define input  parameter labl    as character no-undo.
define output parameter s       as logical   no-undo initial false.


{ {&mdir}/_mwo1.i &labl = labl}

/*
 * See if there any other menu items that are attached to the
 * menu item in question that are not "deleted"
 */
   
find first mnuItems where mnuItems.parentId = labl
                     and   mnuItems.appId = appId 
                     and  not    (mnuItems.state = "delete-existing"
                              or  mnuItems.state = "delete-new")
                     no-error.

if available mnuItems then s = true.





