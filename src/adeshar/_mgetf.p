/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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




