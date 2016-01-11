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




