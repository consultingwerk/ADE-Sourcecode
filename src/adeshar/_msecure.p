/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * _msecure
 *
 *    Calls the supplied function with the list of all features.
 *    If the function is not defined then use menu default security.
 */

{ adecomm/_mtemp.i }
{ {&mdir}/_mnudefs.i }

define input  parameter appId            as character no-undo.
define input  parameter userName         as character no-undo.
define output parameter s                as logical   no-undo initial false.

find first mnuApp where mnuApp.appId = appId no-error.
if not available mnuApp then return.

assign
    s = true
.

if    mnuApp.secureFunction = ?
   or mnuApp.secureFunction = "" then do:

    /*
     * Menu security. Simply do a can-do
     */

    for each mnuFeatures:

        if (mnuFeatures.appId = appId) then

            mnuFeatures.secure =
                not can-do(mnuFeatures.securityList, userName).

    end.
end.
else do:

    /*
     * The application has its own security. Get the list of all features and
     * build the default return list. The menu system doesn't provide
     * a precompiled list of a ll features. That information isn't needed
     * that often, and since we only expect, as a typical number, about 100-200
     * features. The performance hit shouldn't be much of an issue.
     */

    define variable featureList as character no-undo.
    define variable canUseList  as character no-undo.
    define variable i           as integer   no-undo.
    define variable lookAhead   as character no-undo initial "".

    run {&mdir}/_mgetfl.p(appId, false, output featureList).

    do i = 1 to num-entries(featureList):

        assign
            canUseList = canUseList + lookAhead + "true"
            lookAhead = ","
        .

    end.

    run value(mnuApp.secureFunction)(featureList, userName,
                                                    input-output canUseList).

    /*
     * Now unpack the application's decision about security.
     */

    i = 1.

    for each mnuFeatures:

        if (mnuFeatures.appId = appId) then do:

            assign
                mnuFeatures.secure = (not (entry(i, canUseList) = "true"))
                i = i + 1
            .

        end.
    end.
end.

/*****
 * A debugging aid
 *
    define stream xxx.
    output stream xxx to "secure.txt" no-echo.

    for each mnuFeatures:

        put stream xxx unformatted
            featureId ' ' securityList ' ' secure skip
        .
    end.
output stream xxx close.
****/

