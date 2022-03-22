/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * Prototype include file: S:\astra\object\admenh\dev\src\adm2\prodprto.i
 * Created from procedure: S:\astra\object\admenh\dev\src\adm2\producer.p at 14:24 on 22/03/01
 * by the PROGRESS PRO*Tools Prototype Include File Generator
 */

PROCEDURE destroyObject IN SUPER:
END PROCEDURE.

PROCEDURE initializeObject IN SUPER:
END PROCEDURE.

PROCEDURE replyHandler IN SUPER:
  DEFINE INPUT PARAMETER phReply AS HANDLE.
  DEFINE INPUT PARAMETER phConsumer AS HANDLE.
  DEFINE OUTPUT PARAMETER phResponse AS HANDLE.
END PROCEDURE.

PROCEDURE sendMessage IN SUPER:
  DEFINE INPUT PARAMETER pcDestination AS CHARACTER.
  DEFINE INPUT PARAMETER plReplyRequired AS LOGICAL.
  DEFINE INPUT PARAMETER pcReplySelector AS CHARACTER.
  DEFINE OUTPUT PARAMETER pcMessageID AS CHARACTER.
END PROCEDURE.

FUNCTION getCurrentMessage RETURNS HANDLE IN SUPER.

FUNCTION getOutMessageSource RETURNS HANDLE IN SUPER.

FUNCTION getPersistency RETURNS CHARACTER IN SUPER.

FUNCTION getPriority RETURNS INTEGER IN SUPER.

FUNCTION getTimeToLive RETURNS DECIMAL IN SUPER.

FUNCTION setCurrentMessage RETURNS LOGICAL
  (INPUT phMessage AS HANDLE) IN SUPER.

FUNCTION setOutMessageSource RETURNS LOGICAL
  (INPUT phSource AS HANDLE) IN SUPER.

FUNCTION setPersistency RETURNS LOGICAL
  (INPUT pcPersistency AS CHARACTER) IN SUPER.

FUNCTION setPriority RETURNS LOGICAL
  (INPUT piPriority AS INTEGER) IN SUPER.

FUNCTION setTimeToLive RETURNS LOGICAL
  (INPUT pdTimeToLive AS DECIMAL) IN SUPER.

FUNCTION getObjectType RETURNS CHARACTER IN SUPER.

