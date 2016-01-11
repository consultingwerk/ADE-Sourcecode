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
 * _msetu.p
 *
 *    Sets the list of users who can use this feature. The current security
 *    state of the feature IS not changed
 *
 *  Input
 *
 *    appId        THe application
 *
 *    featureName  The feature
 *
 *    userList     THe list of users who can and cannot use the feature
 *
 *  Output
 *
 */

{ adecomm/_mtemp.i }
{ {&mdir}/_mnudefs.i }

define input  parameter appId     as character no-undo.
define input  parameter featureId as character no-undo.
define input  parameter userList  as character no-undo.
define output parameter s         as logical   no-undo initial false.

find first mnuFeatures where mnuFeatures.appId = appId 
                          and mnuFeatures.featureId = featureId no-error.

if not available mnuFeatures then return.

assign
    mnuFeatures.securityList = userList
    s                        = true
.

