/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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

