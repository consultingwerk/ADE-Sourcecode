/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * Prototype include file: S:\astra\object\admenh\dev\src\adm2\consprto.i
 * Created from procedure: S:\astra\object\admenh\dev\src\adm2\consumer.p at 14:22 on 22/03/01
 * by the PROGRESS PRO*Tools Prototype Include File Generator
 */

PROCEDURE assignUnsubscribe IN SUPER:
  DEFINE INPUT PARAMETER pcDestination AS CHARACTER.
  DEFINE INPUT PARAMETER pcSubscription AS CHARACTER.
  DEFINE INPUT PARAMETER plUnsubscribe AS LOGICAL.
END PROCEDURE.

PROCEDURE createConsumers IN SUPER:
END PROCEDURE.

PROCEDURE destroyObject IN SUPER:
END PROCEDURE.

PROCEDURE errorHandler IN SUPER:
  DEFINE INPUT PARAMETER phMessage AS HANDLE.
  DEFINE INPUT PARAMETER phMessageConsumer AS HANDLE.
  DEFINE OUTPUT PARAMETER phReply AS HANDLE.
END PROCEDURE.

PROCEDURE initializeObject IN SUPER:
END PROCEDURE.

PROCEDURE messageHandler IN SUPER:
  DEFINE INPUT PARAMETER phMessage AS HANDLE.
  DEFINE INPUT PARAMETER phMessageConsumer AS HANDLE.
  DEFINE OUTPUT PARAMETER phReply AS HANDLE.
END PROCEDURE.

PROCEDURE processDestinations IN SUPER:
END PROCEDURE.

PROCEDURE startWaitFor IN SUPER:
END PROCEDURE.

PROCEDURE stopHandler IN SUPER:
  DEFINE INPUT PARAMETER phMessage AS HANDLE.
  DEFINE INPUT PARAMETER phMessageConsumer AS HANDLE.
  DEFINE OUTPUT PARAMETER phReply AS HANDLE.
END PROCEDURE.

FUNCTION defineDestination RETURNS LOGICAL
  (INPUT pcDestination AS CHARACTER,
   INPUT pcColumns AS CHARACTER,
   INPUT pcValues AS CHARACTER) IN SUPER.

FUNCTION getDestinations RETURNS CHARACTER IN SUPER.

FUNCTION getInMessageTarget RETURNS HANDLE IN SUPER.

FUNCTION getLogFile RETURNS CHARACTER IN SUPER.

FUNCTION getRouterTarget RETURNS HANDLE IN SUPER.

FUNCTION getSelectors RETURNS CHARACTER IN SUPER.

FUNCTION getShutDownDest RETURNS CHARACTER IN SUPER.

FUNCTION getSubscriptions RETURNS CHARACTER IN SUPER.

FUNCTION getWaiting RETURNS LOGICAL IN SUPER.

FUNCTION setDestinations RETURNS LOGICAL
  (INPUT pcDestinations AS CHARACTER) IN SUPER.

FUNCTION setInMessageTarget RETURNS LOGICAL
  (INPUT phTarget AS HANDLE) IN SUPER.

FUNCTION setLogFile RETURNS LOGICAL
  (INPUT pcLogFile AS CHARACTER) IN SUPER.

FUNCTION setRouterTarget RETURNS LOGICAL
  (INPUT phTarget AS HANDLE) IN SUPER.

FUNCTION setSelectors RETURNS LOGICAL
  (INPUT pcSelectors AS CHARACTER) IN SUPER.

FUNCTION setShutDownDest RETURNS LOGICAL
  (INPUT pcShutDownDest AS CHARACTER) IN SUPER.

FUNCTION setSubscriptions RETURNS LOGICAL
  (INPUT pcSubscriptions AS CHARACTER) IN SUPER.

FUNCTION setWaiting RETURNS LOGICAL
  (INPUT plWaiting AS LOGICAL) IN SUPER.

FUNCTION getObjectType RETURNS CHARACTER IN SUPER.

