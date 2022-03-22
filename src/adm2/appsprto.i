/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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

