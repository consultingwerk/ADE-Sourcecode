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

