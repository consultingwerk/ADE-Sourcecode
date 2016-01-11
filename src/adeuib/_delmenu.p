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
/*----------------------------------------------------------------------------

File: _delmenu.p

Description:
    Go through the _U & _M records and set the status of menu records to
    p_status.  If p_status is "DELETED" then it also deletes the menu widgets
    (by deleting the parent menu) and sets the WIDGET-HANDLES to ?.

Input Parameters:
   menu_recid   The RECID of the menu to instatiate.
   p_status   : Status to set the menu widgets to.
   p_trash    : If TRUE, then delete the menu temp-table records as well as
                the widgets.  
Output Parameters:
   <none>
   
Author: Wm.T.Wood

Date Created: March 1, 1993

----------------------------------------------------------------------------*/
DEFINE INPUT        PARAMETER 	menu_recid 	AS RECID		NO-UNDO.
DEFINE INPUT        PARAMETER 	p_status 	AS CHARACTER      	NO-UNDO.
DEFINE INPUT        PARAMETER 	p_trash  	AS LOGICAL      	NO-UNDO.

/* ===================================================================== */
/*                    SHARED VARIABLES Definitions                       */
/* ===================================================================== */
{adeuib/uniwidg.i}
{adecomm/adefext.i}
{adeuib/triggers.i}

/* Local Variables */
DEFINE VAR h_menu	AS WIDGET-HANDLE	NO-UNDO.

FIND _U WHERE RECID(_U) = menu_recid NO-ERROR.
IF NOT AVAILABLE _U THEN DO:
  MESSAGE "{&UIB_NAME} Error: _U = " menu_recid "not found in _delmenu.p.".
  RETURN.
END.

FIND _M WHERE RECID(_M) = _U._x-recid.

/* Now set the status for the _U and its children */
_U._STATUS = p_status.

/* Set the status of all children (MENUS should have no siblings). */
IF _M._child-recid <> ? THEN RUN set_status (_M._child-recid).

/* Erase the menu, if p_status is DELETED or we are "trashing it" */
IF (p_status = "DELETED" OR p_trash) THEN DO:
  /* Delete Triggers */
  FOR EACH _TRG WHERE _TRG._wRECID = RECID(_U):
     IF p_trash THEN DELETE _TRG.
     ELSE ASSIGN _TRG._STATUS = "DELETED".
  END.

  IF _U._HANDLE <> ? THEN DELETE WIDGET _U._HANDLE.
  
  ASSIGN _U._HANDLE        = ?
         _U._WINDOW-HANDLE = ?.
  VALIDATE _U.
  IF p_trash THEN DO:
    DELETE _U.
    DELETE _M.
  END.
END.

/* Go through a menu tree and set the status of each menu-element and 
   zero out the widget handles (if necessary). */
procedure set_status.
  def input parameter u-rec as recid		no-undo.

  define buffer ipU for _U.
  define buffer ipM for _M.
  
  /* Find the menu record */
  FIND ipU WHERE RECID(ipU) = u-rec.
  FIND ipM WHERE RECID(ipM) = ipU._x-recid.

  /* Set the Status and Handle (if necessary) of the menu. */
  ipU._STATUS = p_status.
  IF (p_status = "DELETED" OR p_trash) THEN DO:
    /* Delete Triggers */
    FOR EACH _TRG WHERE _TRG._wRECID = RECID(ipU):
      IF p_trash THEN DELETE _TRG.
      ELSE ASSIGN _TRG._STATUS = "DELETED".
    END.
  END.


  /* Repeat for children and siblings. */
  if ipM._child-recid <> ?   THEN run set_status (ipM._child-recid).
  if ipM._sibling-recid <> ? THEN run set_status (ipM._sibling-recid).

  /* Trash this menu-element (if necessary) */
  IF p_trash THEN DO:
    DELETE ipU.
    DELETE ipM.
  END.
  ELSE IF p_status = "DELETED" 
  THEN ASSIGN ipU._HANDLE        = ?
              ipU._WINDOW-HANDLE = ? .
  VALIDATE ipU.
    
end procedure.


