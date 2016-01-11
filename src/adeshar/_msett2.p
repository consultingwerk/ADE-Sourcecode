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
 * _msett2.p
 *  
 *    CHanges the image path for an existing toolbar button. Sorry about
 *    the poor name. There's only so muchone can do with 8 chars.
 *
 *  Input Parameters
 *
 *    appId            THe application client this item belongs to.
 *    featureId        The feature that the menu item represents.
 *    toolbarId        The toolbar Id
 *    imageType        "up", "down", or "ins"
 *    image            The image of the button
 *
 *  Output Parameters
 *
 *    s                The state. False if the feature does not exist.
 *                     This routine does no "publically" announce if there
 *                     is a failure.
 */

{ adecomm/_mtemp.i }
{ {&mdir}/_mnudefs.i}

define input  parameter appId        as character no-undo.
define input  parameter featureId    as character no-undo.
define input  parameter toolbarId    as character no-undo.
define input  parameter imageType    as character no-undo.
define input  parameter image        as character no-undo.
define output parameter s            as logical   no-undo initial false.

find first tbItem where tbItem.featureId = featureId
                     and tbItem.appId = appId 
                     and tbItem.toolbarId = toolbarId no-error.

if not available tbItem then return.


/*
 * Say the record isn't found if the state says deleted
 */

if    tbItem.state = "delete-existing"
   or tbItem.state = "delete-new" then return.

assign
    s                = true
.

if      imageType = "up"   then tbItem.upImage = image.
else if imageType = "down" then tbItem.downImage = image.
else if imageType = "ins"  then tbItem.insImage = image.

/*
 * Set the state. During the update "Modify-****" will delete the
 * existing button and create a new one. That means we don't have to worry
 * about too much here.
 */

if tbItem.state = "" then tbItem.state = "modify-existing".
                     else tbItem.state = "modify-new".





