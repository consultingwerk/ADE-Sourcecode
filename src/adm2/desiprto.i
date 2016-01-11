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

