/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _updmenu.p

Description:
    Go through the _U & _M records and build the total menu from
    new widgets.  If delete_menu is TRUE then we delete the menu. 
    The base menu is pointed to by menu_recid.  We get the _U and _M for
    it and instatiate all new menus after deleting the old menu widgets.

Input Parameters:
   delete_menu : If TRUE we delete the whole menu.
   menu_recid  : The RECID of the menu to instatiate.
Output Parameters:
   h_menu      : The handle of the menu created ( = _U._HANDLE) which can
   	         be used by the calling program to attach the menu to the
   	         widget (eg. h_win:MENUBAR = h_menu).
   	         
Author: Wm.T.Wood

Date Created: December 16, 1992 

----------------------------------------------------------------------------*/
DEFINE INPUT        PARAMETER 	delete_menu	AS LOGICAL      	NO-UNDO.
DEFINE INPUT        PARAMETER 	menu_recid 	AS RECID		NO-UNDO.
DEFINE OUTPUT       PARAMETER   h_menu          AS WIDGET-HANDLE        NO-UNDO.

/* ===================================================================== */
/*                    SHARED VARIABLES Definitions                       */
/* ===================================================================== */
{adeuib/uniwidg.i}
{adeuib/triggers.i}
{adeuib/sharvars.i}

/* Local Variables */
DEFINE VAR h_child	AS WIDGET-HANDLE	NO-UNDO.

FIND _U WHERE RECID(_U) = menu_recid NO-ERROR.
IF NOT AVAILABLE _U THEN DO:
  MESSAGE "UIB Error: _U = " menu_recid "not found in _updmenu.p.".
  RETURN.
END.
FIND _M WHERE RECID(_M) = _U._x-recid.

/* Erase the old menu */
IF _U._HANDLE <> ? THEN DO:
  h_menu = _U._HANDLE.
  IF VALID-HANDLE(_U._HANDLE) THEN DELETE WIDGET h_menu.
  _U._HANDLE = ?.
  VALIDATE _U.
END. 

/* If delete menu, then delete the widget records (note that menu edit has
   deleted all the children _U records already).  Also we need to delete
   any triggers on _U. */
IF delete_menu THEN DO:
  FOR EACH _TRG WHERE _TRG._wRECID = menu_recid:
    DELETE _TRG.
  END.
  DELETE _M.
  DELETE _U.
  h_menu = ?.
END.
ELSE DO:
  /* Make a new menu (but only if there are some children). */
  IF _M._child-recid <> ? THEN DO:
    /* Remove old handles which should now be invalid */
    RUN zero_handles (_M._child-recid).

    /* Create the menu. Note that title is not setable. Don't set the trigger
       on menubars (thought this doesn't matter). */
    IF _U._SUBTYPE = "MENUBAR" 
    THEN CREATE MENU h_menu
            ASSIGN POPUP-ONLY = FALSE. 
    ELSE DO:
      CREATE MENU h_menu
            ASSIGN POPUP-ONLY = TRUE
            TRIGGERS:
               ON MENU-DROP PERSISTENT
                  RUN changewidg IN _h_uib (h_menu, yes /* Deselect all */ ).
            END TRIGGERS. 
      /* Add a label, if applicable */
      IF TRIM(_U._LABEL) NE "" THEN h_menu:TITLE = _U._LABEL.                  
    END.
    
    _U._HANDLE = h_menu.
    /* Show the rest of the menu */
    RUN showmenu (_M._child-recid, h_menu).
  END.
END.

/* Go through a menu tree and zero-out the widget handles (because if we create
   new menus, we don't want a conflict _U:_HANDLE index */
procedure zero_handles.
  def input parameter u-rec as recid		no-undo.

  define buffer ipU for _U.
  define buffer ipM for _M.
  
  /* Zero-out this menu-item. */
  FIND ipU WHERE RECID(ipU) = u-rec.
  FIND ipM WHERE RECID(ipM) = ipU._x-recid.
  ipU._HANDLE = ?.
  VALIDATE ipU.
  /* Repeat for children and siblings. */
  if ipM._child-recid <> ?   THEN run zero_handles (ipM._child-recid).
  if ipM._sibling-recid <> ? THEN run zero_handles (ipM._sibling-recid).
  
end procedure.

/* showmenu: Takes a _U recid and builds up a tree of menu-widgets. */
procedure showmenu.
  def input parameter u-rec as recid		no-undo.
  def input parameter h_mnu as widget 		no-undo.

  define buffer ipU for _U.
  define buffer ipM for _M.
  
  define var h_mi	as widget		no-undo.
  define var lbl        as char 		no-undo.
  
  /* Figure out a the type of menu element and build it */
  FIND ipU WHERE RECID(ipU) = u-rec.
  FIND ipM WHERE RECID(ipM) = ipU._x-recid.

  /* Account for the string attribute in the label */
  IF ipU._LABEL-ATTR EQ "" THEN lbl = ipU._LABEL.
  ELSE RUN adeuib/_strfmt.p (ipU._LABEL, ipU._LABEL-ATTR, no, OUTPUT lbl).
  CASE ipU._TYPE:
    WHEN "SUB-MENU" THEN DO:
    	CREATE SUB-MENU h_mi
    		ASSIGN	PARENT	 = h_mnu
    			LABEL	 = lbl
    		TRIGGERS:
                  ON MENU-DROP PERSISTENT
                    RUN changewidg IN _h_uib (h_mi, yes /* Deselect all */ ).
    		END TRIGGERS.
    END.
    
    WHEN "MENU-ITEM" THEN DO:
     	CREATE MENU-ITEM h_mi
    		ASSIGN  LABEL    	= lbl
    			TOGGLE-BOX 	= (ipU._SUBTYPE = "TOGGLE-BOX")
    			SUBTYPE  	= IF (ipU._SUBTYPE = "TOGGLE-BOX") 
    						THEN "NORMAL"
    						ELSE ipU._SUBTYPE
    			PARENT   	= h_mnu
    		TRIGGERS:
    		  /* Normal items will respond to CHOOSE,  toggle-boxes to 
    		     VALUE-CHANGED. */
    		  ON CHOOSE, VALUE-CHANGED PERSISTENT 
                     RUN changewidg IN _h_uib (h_mi, yes /* Deselect all */ ).
    		END TRIGGERS.
    	/* Add accelerator keys only to normal menu-items. */	
    	IF h_mi:SUBTYPE = "NORMAL" AND LENGTH(ipM._ACCELERATOR) > 0
    	THEN h_mi:ACCELERATOR = ipM._ACCELERATOR.  
    END.
    			
    OTHERWISE MESSAGE "Developer Error: Invalid menu type - " ipU._TYPE
    		VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  END CASE.
  /* Now assign the handle to the U record */
  ipU._HANDLE = h_mi.

  /* Create children and siblings. */
  if ipM._child-recid <> ?   THEN run showmenu (ipM._child-recid, h_mi).
  if ipM._sibling-recid <> ? THEN run showmenu (ipM._sibling-recid, h_mnu).
end procedure.



