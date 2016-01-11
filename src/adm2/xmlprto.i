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
 * Prototype include file: S:\astra\object\admenh\dev\src\adm2\xmlprto.i
 * Created from procedure: S:\astra\object\admenh\dev\src\adm2\xml.p at 14:27 on 22/03/01
 * by the PROGRESS PRO*Tools Prototype Include File Generator
 */

PROCEDURE destroyObject IN SUPER:
END PROCEDURE.

PROCEDURE processCDataSection IN SUPER:
  DEFINE INPUT PARAMETER phText AS HANDLE.
  DEFINE INPUT PARAMETER pcPath AS CHARACTER.
END PROCEDURE.

PROCEDURE processDocument IN SUPER:
END PROCEDURE.

PROCEDURE processElement IN SUPER:
  DEFINE INPUT PARAMETER phNode AS HANDLE.
  DEFINE INPUT PARAMETER pcPath AS CHARACTER.
END PROCEDURE.

PROCEDURE processRoot IN SUPER:
END PROCEDURE.

PROCEDURE processText IN SUPER:
  DEFINE INPUT PARAMETER phText AS HANDLE.
  DEFINE INPUT PARAMETER pcPath AS CHARACTER.
END PROCEDURE.

PROCEDURE receiveHandler IN SUPER:
  DEFINE INPUT PARAMETER phMessage AS HANDLE.
END PROCEDURE.

PROCEDURE receiveReplyHandler IN SUPER:
  DEFINE INPUT PARAMETER phMessage AS HANDLE.
END PROCEDURE.

PROCEDURE sendHandler IN SUPER:
  DEFINE INPUT PARAMETER phMessage AS HANDLE.
END PROCEDURE.

PROCEDURE sendReplyHandler IN SUPER:
  DEFINE INPUT PARAMETER phMessage AS HANDLE.
END PROCEDURE.

FUNCTION assignAttribute RETURNS LOGICAL
  (INPUT pdOwner AS DECIMAL,
   INPUT pcName AS CHARACTER,
   INPUT pcValue AS CHARACTER) IN SUPER.

FUNCTION assignNodeValue RETURNS LOGICAL
  (INPUT pdNode AS DECIMAL,
   INPUT pcValue AS CHARACTER) IN SUPER.

FUNCTION createAttribute RETURNS DECIMAL
  (INPUT pdOwner AS DECIMAL,
   INPUT pcName AS CHARACTER,
   INPUT pcValue AS CHARACTER) IN SUPER.

FUNCTION createDocument RETURNS LOGICAL IN SUPER.

FUNCTION createElement RETURNS DECIMAL
  (INPUT pdParent AS DECIMAL,
   INPUT pcName AS CHARACTER,
   INPUT pcText AS CHARACTER) IN SUPER.

FUNCTION createNode RETURNS DECIMAL
  (INPUT pdParent AS DECIMAL,
   INPUT pcName AS CHARACTER,
   INPUT pcType AS CHARACTER) IN SUPER.

FUNCTION createText RETURNS DECIMAL
  (INPUT pdParent AS DECIMAL,
   INPUT pcText AS CHARACTER) IN SUPER.

FUNCTION deleteDocument RETURNS LOGICAL IN SUPER.

FUNCTION getDocumentElement RETURNS DECIMAL IN SUPER.

FUNCTION getDocumentHandle RETURNS HANDLE IN SUPER.

FUNCTION getDocumentInitialized RETURNS LOGICAL IN SUPER.

FUNCTION getDTDPublicId RETURNS CHARACTER IN SUPER.

FUNCTION getDTDSystemID RETURNS CHARACTER IN SUPER.

FUNCTION getUseDTD RETURNS LOGICAL IN SUPER.

FUNCTION getValidateOnLoad RETURNS LOGICAL IN SUPER.

FUNCTION nodeHandle RETURNS HANDLE
  (INPUT pdId AS DECIMAL) IN SUPER.

FUNCTION nodeType RETURNS CHARACTER
  (INPUT pdId AS DECIMAL) IN SUPER.

FUNCTION ownerElement RETURNS DECIMAL
  (INPUT pdAttributeNode AS DECIMAL) IN SUPER.

FUNCTION parentNode RETURNS DECIMAL
  (INPUT pdNode AS DECIMAL) IN SUPER.

FUNCTION setDocumentHandle RETURNS LOGICAL
  (INPUT phDocument AS HANDLE) IN SUPER.

FUNCTION setDTDPublicId RETURNS LOGICAL
  (INPUT pcPublicId AS CHARACTER) IN SUPER.

FUNCTION setDTDSystemID RETURNS LOGICAL
  (INPUT pcSystemId AS CHARACTER) IN SUPER.

FUNCTION setValidateOnLoad RETURNS LOGICAL
  (INPUT plValidateOnLoad AS LOGICAL) IN SUPER.

FUNCTION getObjectType RETURNS CHARACTER IN SUPER.

