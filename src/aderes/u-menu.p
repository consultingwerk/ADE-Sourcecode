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
 * u-menu2.p
 *
 *    An example file to provide the program interface that is expected by
 *    Results. The Admin is going to provide their own security.
 *
 *    Results will call this file for each feature. This file
 *    must return true if the user is allowed to use the feature.
 *
 *    Use the Admin->Integratio Procedures... menu to hook this function
 *    into Results. In the dialog box choose the "Feature Security Code" and
 *    change the codepath.
 *
 *    This function, if hooked in as is, will allow any user to access
 *    all functions.
 */

define input  parameter feature as character no-undo.
define output parameter mState  as logical   no-undo initial true.

return.

