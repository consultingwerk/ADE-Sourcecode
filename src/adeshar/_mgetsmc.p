/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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





