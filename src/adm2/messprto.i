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
 * Prototype include file: S:\astra\object\admenh\dev\src\adm2\messprto.i
 * Created from procedure: S:\astra\object\admenh\dev\src\adm2\messaging.p at 14:23 on 22/03/01
 * by the PROGRESS PRO*Tools Prototype Include File Generator
 */

PROCEDURE destroyObject IN SUPER:
END PROCEDURE.

PROCEDURE errorHandler IN SUPER:
  DEFINE INPUT PARAMETER phMessage AS HANDLE.
  DEFINE INPUT PARAMETER phMessageConsumer AS HANDLE.
  DEFINE OUTPUT PARAMETER phReply AS HANDLE.
END PROCEDURE.

PROCEDURE initializeObject IN SUPER:
END PROCEDURE.

FUNCTION getClientID RETURNS CHARACTER IN SUPER.

FUNCTION getDomain RETURNS CHARACTER IN SUPER.

FUNCTION getJMSpartition RETURNS CHARACTER IN SUPER.

FUNCTION getJMSpassword RETURNS CHARACTER IN SUPER.

FUNCTION getJMSsession RETURNS HANDLE IN SUPER.

FUNCTION getJMSuser RETURNS CHARACTER IN SUPER.

FUNCTION getMessageType RETURNS CHARACTER IN SUPER.

FUNCTION getPingInterval RETURNS INTEGER IN SUPER.

FUNCTION getPromptLogin RETURNS LOGICAL IN SUPER.

FUNCTION getSupportedMessageTypes RETURNS CHARACTER IN SUPER.

FUNCTION setClientID RETURNS LOGICAL
  (INPUT pcClientID AS CHARACTER) IN SUPER.

FUNCTION setDomain RETURNS LOGICAL
  (INPUT pcDomain AS CHARACTER) IN SUPER.

FUNCTION setJMSpartition RETURNS LOGICAL
  (INPUT pcJMSpartition AS CHARACTER) IN SUPER.

FUNCTION setJMSpassword RETURNS LOGICAL
  (INPUT pcJMSpassword AS CHARACTER) IN SUPER.

FUNCTION setJMSuser RETURNS LOGICAL
  (INPUT pcJMSuser AS CHARACTER) IN SUPER.

FUNCTION setMessageType RETURNS LOGICAL
  (INPUT pcType AS CHARACTER) IN SUPER.

FUNCTION setPingInterval RETURNS LOGICAL
  (INPUT piPingInterval AS INTEGER) IN SUPER.

FUNCTION setPromptLogin RETURNS LOGICAL
  (INPUT plPrompt AS LOGICAL) IN SUPER.

FUNCTION getObjectType RETURNS CHARACTER IN SUPER.

