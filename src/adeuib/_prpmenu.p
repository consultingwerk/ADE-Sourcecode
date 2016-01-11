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

File: _prpmenu.p

Description:
    Display editor for the menu associated with the h_self menu-item or menu.

Input Parameters:
   h_self : The handle of the menu-item widget we are editing

Output Parameters:
   <None>

Author: Wm.T.Wood

Date Created: February 3, 1993

----------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER h_self   AS WIDGET                             NO-UNDO.

{adeuib/uniwidg.i}              /* Universal widget definition              */
{adeuib/layout.i}               /* Multilayout TEMP-TABLE definitions       */

DEFINE BUFFER parent_U FOR _U.

DEFINE var 	menu_recid	AS RECID		NO-UNDO.
DEFINE var 	self_recid	AS RECID		NO-UNDO.
DEFINE var 	is_menubar      AS LOGICAL      	NO-UNDO.
DEFINE var 	pressed_OK	AS LOGICAL      	NO-UNDO.
DEFINE var 	delete_menu	AS LOGICAL      	NO-UNDO.
DEFINE var 	h_menu		AS WIDGET		NO-UNDO.
DEFINE var 	h_parent	AS WIDGET		NO-UNDO.

/* Find the recid of the selected widget (used to initialize focus in
   the menu editor to a menu-item, and not to a menu-bar). */
FIND _U WHERE _U._HANDLE eq h_self.
self_recid = RECID(_U).

/* Find the handle and recid of the menu that h_self is part of */
h_menu = h_self.
DO WHILE h_menu <> ? AND h_menu:TYPE <> "MENU":
  h_menu = h_menu:PARENT.
END.

IF h_menu <> ? THEN DO:
  FIND _U WHERE _U._HANDLE = h_menu.
  menu_recid = RECID(_U).
  /* Find the parent for this menu */
  FIND parent_U WHERE RECID (parent_U) = _U._parent-recid .
  ASSIGN h_parent   = parent_U._HANDLE
         is_menubar = (_U._SUBTYPE eq "MENUBAR").
  IF is_menubar  THEN FIND _C WHERE RECID(_C) = parent_U._x-recid.
  /* Now update the menu and draw the new one */
  RUN adeuib/_edtmenu.p (_U._parent-recid, _U._SUBTYPE, self_recid,
               INPUT-OUTPUT menu_recid, OUTPUT pressed_OK, OUTPUT delete_menu).
 
   /* **************************************************************** */
  /* NOTE: Do NOT USE _U after this point (because the menu, and its  */
  /* universal widget record, might have been deleted).               */
  /* **************************************************************** */
 
  IF pressed_OK THEN DO:
    RUN adeuib/_updmenu.p (delete_menu, menu_recid, OUTPUT h_menu).
    IF is_menubar THEN DO:        
      _C._menu-recid = IF delete_menu THEN ? ELSE menu_recid.
      IF h_menu <> h_parent:MENUBAR THEN h_parent:MENUBAR = h_menu.
    END.
    ELSE DO:
      parent_U._popup-recid = IF delete_menu THEN ? ELSE menu_recid.
      IF h_menu <> h_parent:POPUP-MENU THEN h_parent:POPUP-MENU = h_menu.
    END.
  END.
END.
