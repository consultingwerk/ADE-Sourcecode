/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
{adeuib/sharvars.i}
{adeuib/uniwidg.i}              /* Universal widget definition              */
{adeuib/layout.i}               /* Multilayout TEMP-TABLE definitions       */
{adecomm/oeideservice.i}

function findWidgetName return character (WidgetParentrecId as recid) in  _h_uib.   

DEFINE BUFFER parent_U FOR _U.

DEFINE var 	menu_recid	AS RECID		NO-UNDO.
DEFINE var 	self_recid	AS RECID		NO-UNDO.
DEFINE var 	is_menubar      AS LOGICAL      	NO-UNDO.
DEFINE var 	pressed_OK	AS LOGICAL      	NO-UNDO.
DEFINE var 	delete_menu	AS LOGICAL      	NO-UNDO.
DEFINE var 	h_menu		AS WIDGET		NO-UNDO.
DEFINE var 	h_parent	AS WIDGET		NO-UNDO.
define variable cmenuname as character no-undo.
define variable cmenuparent as character no-undo.
define variable cLabel   as character no-undo.
define variable cType as character no-undo.
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
  cmenuname = _U._name.
  clabel = _U._label.
  ctype = _U._type.
  /* Find the parent for this menu */
  FIND parent_U WHERE RECID (parent_U) = _U._parent-recid .
  ASSIGN h_parent   = parent_U._HANDLE
         is_menubar = (_U._SUBTYPE eq "MENUBAR").
         cmenuparent =  findWidgetName (RECID (parent_U)).
 
  IF is_menubar  THEN FIND _C WHERE RECID(_C) = parent_U._x-recid.
  /* Now update the menu and draw the new one */
  if OEIDE_CanLaunchDialog() then
      RUN adeuib/ide/_dialog_edtmenu.p (_U._parent-recid, _U._SUBTYPE, self_recid,
               INPUT-OUTPUT menu_recid, OUTPUT pressed_OK, OUTPUT delete_menu).
  
  else
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
    if OEIDEIsRunning then
         WidgetEvent(_h_win,
                      cmenuname,
                      clabel,
                      ctype,
                      cmenuparent,
                     if delete_menu then "DELETE" else "MENUUPDATE").
  END.
END.




