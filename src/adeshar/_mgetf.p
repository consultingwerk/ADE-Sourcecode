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
 *  _mgetf.p
 *
 *    Retuns the information about a feature
 */

{ adecomm/_mtemp.i }
{ {&mdir}/_mnudefs.i}

define input  parameter appId           as character no-undo.
define input  parameter featureId       as character no-undo.
define output parameter ftype           as character no-undo.
define output parameter func            as character no-undo.
define output parameter args            as character no-undo.
define output parameter defaultLabel    as character no-undo.
define output parameter defaultUpIcon   as character no-undo.
define output parameter defaultDownIcon as character no-undo.
define output parameter defaultInsIcon  as character no-undo.
define output parameter microHelp       as character no-undo.
define output parameter prvData         as character no-undo.
define output parameter userDefined     as logical   no-undo.
define output parameter found           as logical   no-undo.

found = false.

find first mnuFeatures where     mnuFeatures.featureId = featureId 
                              and mnuFeatures.appId = appId  no-error.

if (not available mnuFeatures) then return.

assign
	found           = true
        ftype           = mnuFeatures.type
	func            = mnuFeatures.functionId
	userDefined     = mnuFeatures.userDefined
	args            = mnuFeatures.args
	defaultLabel    = mnuFeatures.defaultLabel
	defaultUpIcon   = mnuFeatures.defaultUpIcon
	defaultDownIcon = mnuFeatures.defaultDownIcon
	defaultInsIcon  = mnuFeatures.defaultInsIcon
	microHelp       = mnuFeatures.microHelp
        prvData         = mnuFeatures.prvData
.




