/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * Prototype include file: S:\astra\object\admenh\dev\src\adm2\routprto.i
 * Created from procedure: S:\astra\object\admenh\dev\src\adm2\router.p at 14:24 on 22/03/01
 * by the PROGRESS PRO*Tools Prototype Include File Generator
 */

PROCEDURE initializeObject IN SUPER:
END PROCEDURE.

PROCEDURE obtainInMsgTarget IN SUPER:
  DEFINE INPUT PARAMETER phMessage AS HANDLE.
  DEFINE OUTPUT PARAMETER phInMessageTarget AS HANDLE.
END PROCEDURE.

PROCEDURE processFileRefs IN SUPER:
END PROCEDURE.

PROCEDURE routeBytesMessage IN SUPER:
  DEFINE INPUT PARAMETER phMessage AS HANDLE.
  DEFINE OUTPUT PARAMETER pohInMessageTarget AS HANDLE.
END PROCEDURE.

PROCEDURE routeDocument IN SUPER:
  DEFINE OUTPUT PARAMETER pohInMessageTarget AS HANDLE.
END PROCEDURE.

PROCEDURE routeMessage IN SUPER:
  DEFINE INPUT PARAMETER phMessage AS HANDLE.
  DEFINE OUTPUT PARAMETER pohInMessageTarget AS HANDLE.
END PROCEDURE.

FUNCTION createDocument RETURNS LOGICAL IN SUPER.

FUNCTION getExternalRefList RETURNS CHARACTER IN SUPER.

FUNCTION getInternalRefList RETURNS CHARACTER IN SUPER.

FUNCTION getRouterSource RETURNS CHARACTER IN SUPER.

FUNCTION getSchemaManager RETURNS HANDLE IN SUPER.

FUNCTION internalSchemaFile RETURNS CHARACTER
  (INPUT pcNameSpace AS CHARACTER) IN SUPER.

FUNCTION setExternalRefList RETURNS LOGICAL
  (INPUT pcExternalRefList AS CHARACTER) IN SUPER.

FUNCTION setInternalRefList RETURNS LOGICAL
  (INPUT pcInternalRefList AS CHARACTER) IN SUPER.

FUNCTION setRouterSource RETURNS LOGICAL
  (INPUT pcRouterSource AS CHARACTER) IN SUPER.

FUNCTION startB2BObject RETURNS HANDLE
  (INPUT pcContainer AS CHARACTER) IN SUPER.

FUNCTION getObjectType RETURNS CHARACTER IN SUPER.

