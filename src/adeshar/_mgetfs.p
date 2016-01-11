/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * _mgetfs.p
 *
 *    Gets the current security state of the features
 *
 *  Input
 *
 *    appId        THe application
 *
 *    featureName  The feature
 *
 *  Output
 *
 *    canUse       True if the user can "see" this features
 */

{ adecomm/_mtemp.i }
{ {&mdir}/_mnudefs.i }

define input  parameter appId     as character no-undo.
define input  parameter featureId as character no-undo.
define output parameter canUse    as logical   no-undo initial false.

find first mnuFeatures where mnuFeatures.appId = appId 
                          and mnuFeatures.featureId = featureId no-error.

if not available mnuFeatures then return.

/*
 * The field secure stores the availability of this feature oppisite the
 * way it is presented to the caller.
 */

assign
    canUse = not mnuFeatures.secure
.

