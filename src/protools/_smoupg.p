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
/**************************************************************************
    Procedure:  _smoupg.p

    Purpose:    Checks to see if the UIB is running and if it is
                it launches adeuib/_smoupg.w.

    Parameters: None

    Description:
    Notes  :
    Authors: Gerry Seidl
    Date   : 9/12/96
**************************************************************************/

DEFINE VARIABLE level          AS INTEGER NO-UNDO INITIAL 1. 
DEFINE VARIABLE uib_is_running AS LOGICAL NO-UNDO INITIAL NO.

REPEAT WHILE PROGRAM-NAME(level) <> ?.
  IF PROGRAM-NAME(level) = "adeuib/_uibmain.p" THEN uib_is_running = TRUE.
  ASSIGN level = level + 1.
END.
IF NOT uib_is_running THEN DO:
  MESSAGE "The UIB is not running. You must start the UIB before running the SmartObject Upgrade Utility." VIEW-AS ALERT-BOX ERROR.
  RETURN.
END.
ELSE
  RUN adeuib/_smoupg.w PERSISTENT.

RETURN.
