/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
* sffire.p
*
*    Provide an interface so vars can programitcally fire off
*    a Results feature.
*
* Input Parameter
*
*    featureId    The feature
*    args         A comma seperated list of args to be passed to feature.
*                 For Results predefined features the caller is
*                 advised to pass a ?.
*
* Output Parameter
*
*    qbf-s        False if feature was/did not execute
*/

{ aderes/_fdefs.i }
{ aderes/s-system.i }

DEFINE INPUT  PARAMETER featureId AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER args      AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER qbf-s     AS LOGICAL   NO-UNDO.

RUN adeshar/_mfiref.p({&resId}, featureId, args, OUTPUT qbf-s).

/* sffire.p - end of file */

