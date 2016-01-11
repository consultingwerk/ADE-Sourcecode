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
 * _mgettl
 *
 *	Returns a comma seperated list of all the features that
 *      are represented in a toolbar
 *
 * If the toolbar is empty then an empty list is returned
 */

{ adecomm/_mtemp.i }
{ {&mdir}/_mnudefs.i}

define input  parameter appId    as character no-undo.
define output parameter itemList as character no-undo initial "".

define variable look as character initial "".

/*
 * First, check to see if the menu named provided actually exists
 */

find first tbItem where tbItem.appId = appId no-error.

IF (not available tbItem) THEN return.

/*
 * Walk the temp table and build the list.
 */

for each tbItem:

    assign
        itemList = itemList + look + tbItem.featureId
        look = ","
    .

end.

