/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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

