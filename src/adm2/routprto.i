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

