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
 * _mfiref.p
 *
 *   Execute a feature that takes variable arguemnts. This file is
 *   expected to be called directly by an application
 *
 *  Input Parameters
 *
 *    addId      The application
 *    featureId  The feature to fire
 *    args       A comma seperated list
 *    useDef     Ignore the args and use the default (i.e., what is defined
 *               with the feature.
 */

{ adecomm/_mtemp.i }
{ {&mdir}/_mnudefs.i }

define input  parameter appId     as character no-undo.
define input  parameter featureId as character no-undo.
define input  parameter args      as character no-undo.
define output parameter s         as logical   no-undo initial false.

define variable sensList as character no-undo initial "true".
define variable toggList as character no-undo initial "true".

find first mnuApp where mnuApp.appID = appId.
if not available mnuApp then return.

/*
 * Get the feature record. The function information is stored there.
 */

find first mnuFeatures where mnuFeatures.featureId = featureId
                          and mnuFeatures.appId     = appId no-error.

if not available mnuFeatures then return.

/*
 * If there is no function then don't consider it a problem. Just return.
 */

if    mnuFeatures.functionId = ?
   or mnuFeatures.functionId = "" then return.

/*
 * Don't assume that the client is calling this feature in the
 * proper state. Ask the client.
 */

badCheck:
do on stop undo badCheck, retry badCheck:

    if retry then do:
         message "Sensitive Function Not Found or has a problem." skip
                 "appId     " mnuApp.appId skip
                 "function  " mnuApp.sensFunction skip
         view-as alert-box error buttons ok.

         return.
    end.

    run value(mnuApp.sensFunction)(mnuApp.appId,
                                   mnuFeatures.featureId,
                                   mnuApp.prvHandle,
                                   mnuApp.prvData,
                                   input-output sensList,
                                   input-output toggList).

end.

if sensList <> "true" then return.

badfile:
do on stop undo badfile, retry badfile:

    define variable arg1 as character no-undo.

    if retry then do:

        message "Function Not Found or has a problem (_mfiref)." skip
	        "appId     " mnuFeatures.appId skip
                "feature   " mnuFeatures.featureId skip
                "function  " mnuFeatures.functionId skip
                "args      " mnuFeatures.args skip
                "vars      " args skip
                "user def  " mnuFeatures.userDefined skip
        view-as alert-box error buttons ok.

        /*
         * Reset the cursor, just in case the app has set it to the
         * watch cursor.
         */

        run adecomm/_setcurs.p("").

        leave badfile.
    end.

    s = true.

    if num-entries(mnuFeatures.args) = 1 then do:

        if args = ? then arg1 = mnuFeatures.args.
                    else arg1 = args.
        
        run value(mnuFeatures.functionId)(?, mnuFeatures.featureId,
                                           mnuFeatures.appId,
                                           arg1,
                                           mnuApp.prvHandle,
                                           mnuFeatures.prvData).
    end.
    else do:

        /*
         * The second form is "f, arg...."
         * So pull oput the the function f and pass the variable passed in
         */

        define variable arg2 as character no-undo.
        define variable loc  as integer   no-undo.

        arg1 = entry(1, mnuFeatures.args).

       if args = ? then
         assign
           loc  = INDEX(mnuFeatures.args,",")
           arg2 = SUBSTRING(mnuFeatures.args,loc + 1,-1,"CHARACTER":u)
           .
        else
            arg2 = ENTRY(2,mnuFeatures.args) + "," + args.

        run value(mnuFeatures.functionId)(?, mnuFeatures.featureId,
                                           mnuFeatures.appId,
                                           arg1,
                                           arg2,
                                           mnuApp.prvHandle,
                                           mnuFeatures.prvData).
    end.
end.

