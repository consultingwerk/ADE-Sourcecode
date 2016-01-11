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
 * Prototype include file: C:\adm91a\src\adm2\fieldprto.i
 * Created from procedure: C:\adm91a\src\adm2\field.p at 13:04 on 06/24/99
 * by the PROGRESS PRO*Tools Prototype Include File Generator
 */

PROCEDURE initializeObject IN SUPER:
END PROCEDURE.

FUNCTION getDataModified RETURNS LOGICAL IN SUPER.

FUNCTION getDisplayField RETURNS LOGICAL IN SUPER.

FUNCTION getEnableField RETURNS LOGICAL IN SUPER.

FUNCTION getFieldEnabled RETURNS LOGICAL IN SUPER.

FUNCTION getFieldName RETURNS CHARACTER IN SUPER.

FUNCTION setDataModified RETURNS LOGICAL
  (INPUT plModified AS LOGICAL) IN SUPER.

FUNCTION setDisplayField RETURNS LOGICAL
  (INPUT plDisplay AS LOGICAL) IN SUPER.

FUNCTION setEnableField RETURNS LOGICAL
  (INPUT plEnable AS LOGICAL) IN SUPER.

FUNCTION setFieldEnabled RETURNS LOGICAL
  (INPUT plEnabled AS LOGICAL) IN SUPER.

FUNCTION setFieldName RETURNS LOGICAL
  (INPUT pcField AS CHARACTER) IN SUPER.

