/*********************************************************************
* Copyright (C) 2000-2002 by Progress Software Corporation ("PSC"),  *
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
 * Prototype include file: C:\posse_main\src\adm2\saxprto.i
 * Created from procedure: C:\posse_main\src\adm2\sax.p at 16:19 on 03/12/02
 * by the PROGRESS PRO*Tools Prototype Include File Generator
 */

PROCEDURE characters IN SUPER:
  DEFINE INPUT PARAMETER pmCharArray AS MEMPTR.
  DEFINE INPUT PARAMETER piArrayLength AS INTEGER.
END PROCEDURE.

PROCEDURE endDocument IN SUPER:
END PROCEDURE.

PROCEDURE endElement IN SUPER:
  DEFINE INPUT PARAMETER pcNamespaceURI AS CHARACTER.
  DEFINE INPUT PARAMETER pcLocalName AS CHARACTER.
  DEFINE INPUT PARAMETER pcQName AS CHARACTER.
END PROCEDURE.

PROCEDURE endPrefixMapping IN SUPER:
  DEFINE INPUT PARAMETER pcPrefix AS CHARACTER.
END PROCEDURE.

PROCEDURE error IN SUPER:
  DEFINE INPUT PARAMETER pcMessage AS CHARACTER.
END PROCEDURE.

PROCEDURE fatalError IN SUPER:
  DEFINE INPUT PARAMETER pcMessage AS CHARACTER.
END PROCEDURE.

PROCEDURE ignorableWhitespace IN SUPER:
  DEFINE INPUT PARAMETER pcCharArray AS CHARACTER.
  DEFINE INPUT PARAMETER piArrayLength AS INTEGER.
END PROCEDURE.

PROCEDURE initializeObject IN SUPER:
END PROCEDURE.

PROCEDURE notationDecl IN SUPER:
  DEFINE INPUT PARAMETER pcName AS CHARACTER.
  DEFINE INPUT PARAMETER pcPublicID AS CHARACTER.
  DEFINE INPUT PARAMETER pcSystemID AS CHARACTER.
END PROCEDURE.

PROCEDURE processingInstruction IN SUPER:
  DEFINE INPUT PARAMETER pcTarget AS CHARACTER.
  DEFINE INPUT PARAMETER pcData AS CHARACTER.
END PROCEDURE.

PROCEDURE resolveEntity IN SUPER:
  DEFINE INPUT PARAMETER pcPublicID AS CHARACTER.
  DEFINE INPUT PARAMETER pcSystemID AS CHARACTER.
  DEFINE OUTPUT PARAMETER pcFilePath AS CHARACTER.
  DEFINE OUTPUT PARAMETER pmMemPointer AS MEMPTR.
END PROCEDURE.

PROCEDURE startDocument IN SUPER:
END PROCEDURE.

PROCEDURE startElement IN SUPER:
  DEFINE INPUT PARAMETER pcNamespaceURI AS CHARACTER.
  DEFINE INPUT PARAMETER pcLocalName AS CHARACTER.
  DEFINE INPUT PARAMETER pcQName AS CHARACTER.
  DEFINE INPUT PARAMETER phAttributes AS HANDLE.
END PROCEDURE.

PROCEDURE startPrefixMapping IN SUPER:
  DEFINE INPUT PARAMETER pcPrefix AS CHARACTER.
  DEFINE INPUT PARAMETER pcURI AS CHARACTER.
END PROCEDURE.

PROCEDURE unparsedEntityDecl IN SUPER:
  DEFINE INPUT PARAMETER pcName AS CHARACTER.
  DEFINE INPUT PARAMETER pcPublicID AS CHARACTER.
  DEFINE INPUT PARAMETER pcSystemID AS CHARACTER.
  DEFINE INPUT PARAMETER pcNotationName AS CHARACTER.
END PROCEDURE.

PROCEDURE warning IN SUPER:
  DEFINE INPUT PARAMETER pcMessage AS CHARACTER.
END PROCEDURE.

FUNCTION getContextMode RETURNS LOGICAL IN SUPER.

FUNCTION getNode RETURNS DECIMAL IN SUPER.

FUNCTION getParentNode RETURNS DECIMAL IN SUPER.

FUNCTION getSequence RETURNS INTEGER IN SUPER.

FUNCTION getStackHandle RETURNS HANDLE IN SUPER.

FUNCTION getPath RETURNS CHARACTER IN SUPER.

FUNCTION setContextMode RETURNS LOGICAL
  (INPUT plContextMode AS LOGICAL) IN SUPER.

FUNCTION setNode RETURNS LOGICAL
  (INPUT dNode AS DECIMAL) IN SUPER.

FUNCTION setParentNode RETURNS LOGICAL
  (INPUT dParentNode AS DECIMAL) IN SUPER.

FUNCTION setSequence RETURNS LOGICAL
  (INPUT iSequence AS INTEGER) IN SUPER.

FUNCTION setPath RETURNS LOGICAL
  (INPUT pcPath AS CHARACTER) IN SUPER.

FUNCTION getObjectType RETURNS CHARACTER IN SUPER.

