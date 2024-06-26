/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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

