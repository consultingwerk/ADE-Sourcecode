/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * Prototype include file: S:\astra\object\admenh\dev\src\adm2\msghprto.i
 * Created from procedure: S:\astra\object\admenh\dev\src\adm2\msghandler.p at 14:21 on 22/03/01
 * by the PROGRESS PRO*Tools Prototype Include File Generator
 */

PROCEDURE sendMessage IN SUPER:
END PROCEDURE.

FUNCTION getCurrentMessageId RETURNS CHARACTER IN SUPER.

FUNCTION getDestination RETURNS CHARACTER IN SUPER.

FUNCTION getInMessageSource RETURNS HANDLE IN SUPER.

FUNCTION getOutMessageTarget RETURNS HANDLE IN SUPER.

FUNCTION getReplyRequired RETURNS LOGICAL IN SUPER.

FUNCTION getReplySelector RETURNS CHARACTER IN SUPER.

FUNCTION setCurrentMessageId RETURNS LOGICAL
  (INPUT pcCurrentMessageID AS CHARACTER) IN SUPER.

FUNCTION setDestination RETURNS LOGICAL
  (INPUT pcDestination AS CHARACTER) IN SUPER.

FUNCTION setInMessageSource RETURNS LOGICAL
  (INPUT phSource AS HANDLE) IN SUPER.

FUNCTION setOutMessageTarget RETURNS LOGICAL
  (INPUT phTarget AS HANDLE) IN SUPER.

FUNCTION setReplyRequired RETURNS LOGICAL
  (INPUT plReplyRequired AS LOGICAL) IN SUPER.

FUNCTION setReplySelector RETURNS LOGICAL
  (INPUT pcReplySelector AS CHARACTER) IN SUPER.

FUNCTION getObjectType RETURNS CHARACTER IN SUPER.

