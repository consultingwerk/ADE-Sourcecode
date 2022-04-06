/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * Prototype include file: S:\astra\object\admenh\dev\src\adm2\fieldprto.i
 * Created from procedure: S:\astra\object\admenh\dev\src\adm2\field.p at 14:18 on 22/03/01
 * by the PROGRESS PRO*Tools Prototype Include File Generator
 */

PROCEDURE initializeObject IN SUPER:
END PROCEDURE.

PROCEDURE resizeObject IN SUPER:
  DEFINE INPUT PARAMETER pidHeight AS DECIMAL.
  DEFINE INPUT PARAMETER pidWidth AS DECIMAL.
END PROCEDURE.

FUNCTION getDataModified RETURNS LOGICAL IN SUPER.

FUNCTION getDisplayField RETURNS LOGICAL IN SUPER.

/* This have been overidden in static object with mismatching data types
FUNCTION getDataValue RETURNS CHARACTER IN SUPER.

FUNCTION getDisplayedValue RETURNS CHARACTER IN SUPER.
*/

FUNCTION getEnableField RETURNS LOGICAL IN SUPER.

FUNCTION getFieldEnabled RETURNS LOGICAL IN SUPER.

FUNCTION getFieldName RETURNS CHARACTER IN SUPER.

FUNCTION getCustomSuperProc RETURNS CHARACTER IN SUPER.

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

/* This have been overidden in static object with mismatching data types
FUNCTION setDataValue RETURNS LOGICAL
  (INPUT pcValue AS CHARACTER) IN SUPER.

FUNCTION setDisplayedValue RETURNS LOGICAL
  (INPUT pcValue AS CHARACTER) IN SUPER.
*/
  
FUNCTION setCustomSuperProc RETURNS LOGICAL
  (INPUT pcCustomSuperProc AS CHARACTER) IN SUPER.

FUNCTION getObjectType RETURNS CHARACTER IN SUPER.

