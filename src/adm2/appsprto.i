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
 * Prototype include file: C:\1a\src\adm2\appsprto.i
 * Created from procedure: C:\1a\src\adm2\appserver.p at 15:57 on 02/26/01
 * by the PROGRESS PRO*Tools Prototype Include File Generator
 */

PROCEDURE bindServer IN SUPER:
END PROCEDURE.

PROCEDURE destroyObject IN SUPER:
END PROCEDURE.

PROCEDURE destroyServerObject IN SUPER:
END PROCEDURE.

PROCEDURE disconnectObject IN SUPER:
END PROCEDURE.

PROCEDURE initializeServerObject IN SUPER:
END PROCEDURE.

PROCEDURE restartServerObject IN SUPER:
END PROCEDURE.

PROCEDURE runServerObject IN SUPER:
  DEFINE INPUT PARAMETER phAppService AS HANDLE.
END PROCEDURE.

PROCEDURE startServerObject IN SUPER:
END PROCEDURE.

PROCEDURE unbindServer IN SUPER:
  DEFINE INPUT PARAMETER pcMode AS CHARACTER.
END PROCEDURE.

FUNCTION getAppService RETURNS CHARACTER IN SUPER.

FUNCTION getASBound RETURNS LOGICAL IN SUPER.

FUNCTION getAsDivision RETURNS CHARACTER IN SUPER.

FUNCTION getASHandle RETURNS HANDLE IN SUPER.

FUNCTION getASHasStarted RETURNS LOGICAL IN SUPER.

FUNCTION getASInfo RETURNS CHARACTER IN SUPER.

FUNCTION getASInitializeOnRun RETURNS LOGICAL IN SUPER.

FUNCTION getASUsePrompt RETURNS LOGICAL IN SUPER.

FUNCTION getServerFileName RETURNS CHARACTER IN SUPER.

FUNCTION getServerOperatingMode RETURNS CHARACTER IN SUPER.

FUNCTION runServerProcedure RETURNS HANDLE
  (INPUT pcServerFileName AS CHARACTER,
   INPUT phAppService AS HANDLE) IN SUPER.

FUNCTION setAppService RETURNS LOGICAL
  (INPUT pcAppService AS CHARACTER) IN SUPER.

FUNCTION setASDivision RETURNS LOGICAL
  (INPUT pcDivision AS CHARACTER) IN SUPER.

FUNCTION setASHandle RETURNS LOGICAL
  (INPUT phASHandle AS HANDLE) IN SUPER.

FUNCTION setASInfo RETURNS LOGICAL
  (INPUT pcInfo AS CHARACTER) IN SUPER.

FUNCTION setASInitializeOnRun RETURNS LOGICAL
  (INPUT plInitialize AS LOGICAL) IN SUPER.

FUNCTION setASUsePrompt RETURNS LOGICAL
  (INPUT plFlag AS LOGICAL) IN SUPER.

FUNCTION setServerFileName RETURNS LOGICAL
  (INPUT pcFileName AS CHARACTER) IN SUPER.

FUNCTION setServerOperatingMode RETURNS LOGICAL
  (INPUT pcServerOperatingMode AS CHARACTER) IN SUPER.

FUNCTION getObjectType RETURNS CHARACTER IN SUPER.

