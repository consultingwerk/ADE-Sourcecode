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
