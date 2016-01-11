/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
*
*  _mgett3.
*
*	return all the information about a particular toolbar button
*      based on the x,y position.
*/

{ adecomm/_mtemp.i }
{ {&mdir}/_mnudefs.i}

DEFINE INPUT  PARAMETER appId        AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER toolbarId    AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER x            AS INTEGER   NO-UNDO.
DEFINE INPUT  PARAMETER y            AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER featureId    AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER upImage      AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER downImage    AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER insImage     AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER itype        AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER userDefined  AS LOGICAL   NO-UNDO.
DEFINE OUTPUT PARAMETER prvData      AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER w            AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER h            AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER itemHandle   AS HANDLE    NO-UNDO.
DEFINE OUTPUT PARAMETER editHandle   AS HANDLE    NO-UNDO.
DEFINE OUTPUT PARAMETER found        AS LOGICAL   NO-UNDO.

FIND FIRST tbItem WHERE tbItem.x         = x AND
                        tbItem.y         = y AND
                        tbItem.appId     = appId AND
                        tbItem.toolbarId = toolbarId NO-ERROR.
IF (NOT AVAILABLE tbItem) THEN RETURN.

/* Say the record isn't found if the state says deleted. */
IF tbItem.state = "delete-existing" OR
   tbItem.state = "delete-new" THEN RETURN.

ASSIGN
  found        = TRUE
  featureId    = tbItem.featureId
  upImage      = tbItem.upImage
  downImage    = tbItem.downImage
  insImage     = tbItem.insImage
  itype        = tbItem.type
  userDefined  = tbItem.userDefined
  prvData      = tbItem.prvData
  w            = tbItem.w
  h            = tbItem.h
  itemHandle   = tbItem.handle
  editHandle   = tbItem.editHandle
  .




