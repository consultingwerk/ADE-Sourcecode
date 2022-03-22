/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * Prototype include file: S:\astra\object\admenh\dev\src\adm2\desiprto.i
 * Created from procedure: S:\astra\object\admenh\dev\src\adm2\design.p at 14:20 on 22/03/01
 * by the PROGRESS PRO*Tools Prototype Include File Generator
 */

PROCEDURE destroyObject IN SUPER:
END PROCEDURE.

FUNCTION getDataObjectHandle RETURNS HANDLE IN SUPER.

FUNCTION getDataSource RETURNS HANDLE IN SUPER.

FUNCTION getDesignTimeHideMenu RETURNS LOGICAL IN SUPER.

FUNCTION getFilterTarget RETURNS CHARACTER IN SUPER.

FUNCTION linkHandles RETURNS CHARACTER
  (INPUT pcLink AS CHARACTER) IN SUPER.

FUNCTION setDesignTimeHideMenu RETURNS LOGICAL
  (INPUT plLog AS LOGICAL) IN SUPER.

