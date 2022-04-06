/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * _mgetfl
 *
 *	Returns a comma seperated list of all the labels in the feature list
 */

{ adecomm/_mtemp.i }
{ {&mdir}/_mnudefs.i }

define input  parameter appId       as character no-undo.
define input  parameter secure      as logical   no-undo.
define output parameter featureList as character no-undo initial "".

define variable look as character initial "".

/*
 * Walk the temp table and build the list
 */

for each mnuFeatures:

    /*
     * Add the feature to the list if the feature belongs to the app
     * and *if* the caller wants the secured feature then add to the list
     */
     
    if mnuFeatures.appId = appId then	do:

        if secure = true then do:

            if mnuFeatures.secure = false then
                assign
                    featureList = featureList + look + mnuFeatures.featureId
                    look = ","
                .
        end.
        else do:

            assign
                featureList = featureList + look + mnuFeatures.featureId
                look = ","
            .

        end.
  
    end.
end.
