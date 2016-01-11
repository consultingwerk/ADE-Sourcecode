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

File: _cr_cmnu.p

Description:
   Creates the Custom Menus on the Object Palette.
   
Input Parameters:
   ph_widg_submenu : HANDLE of the Widget Submenu in the UIB main window

Output Parameters:
  <none>

Author:  Gerry Seidl

Date Created: 2/10/95

Modified:
  8/1/95 gfs Removed widget-pool "_pal"
----------------------------------------------------------------------------*/
{adeuib/sharvars.i}    /* Most common shared variables        */
{adeuib/custwidg.i}    /* Custom Widget Definitions           */

DEFINE INPUT  PARAMETER ph_widg_submenu AS WIDGET  NO-UNDO.

  DEFINE VAR h               AS WIDGET  NO-UNDO.
  DEFINE VAR hp              AS WIDGET  NO-UNDO.
  DEFINE VAR h_cust_menu     AS WIDGET  NO-UNDO.
  DEFINE VAR h_popup         AS WIDGET  NO-UNDO.    
  DEFINE VAR h_widget_frame  AS WIDGET  NO-UNDO.
  DEFINE VAR i               AS INTEGER NO-UNDO.

  /* First destroy any of the DYNAMIC elements on the widget submenu, and on
     the Widget Palette. */
  h = ph_widg_submenu:LAST-CHILD.
  DO WHILE VALID-HANDLE(h):
    h_cust_menu = h:PREV-SIBLING.  /* Store this before we delete sub-menus */
    IF h:DYNAMIC THEN DELETE WIDGET h.
    h = h_cust_menu.
  END.

  /* Loop though all widgets except pointer and DB fields */
  FOR EACH _palette_item WHERE _palette_item._NAME <> "POINTER" BY _label2:
 
   /* Delete any existing popup menu on the frames in the palette. 
        The up-image is on the frame with the popup menu.
        Find these widgets and delete them.  */
    ASSIGN h_widget_frame = _palette_item._h_up_image:FRAME
           h_popup        = h_widget_frame:POPUP-MENU
           h_cust_menu    = ?
           .
    IF VALID-HANDLE(h_popup) THEN DELETE WIDGET h_popup.
                
    /* Create a POPUP menu of custom widgets to attach to the up image.  The
       first item on this list is always the UIB standard. Also create a 
       submenu for the Main Menubar with the same UIB standard item.  BUT only
       do this if there are other items to add to the list.  */
    CREATE MENU h_popup  
    ASSIGN 
        POPUP-ONLY = YES. 
    CREATE MENU-ITEM hp  
      ASSIGN
        PARENT = h_popup
        LABEL  = "&Default"
        TRIGGERS:
              ON CHOOSE PERSISTENT RUN tool_choose IN _h_uib (1, _palette_item._name, ?).
        END TRIGGERS. 

    /* SmartObjects (& User-Defined) can have a CHOOSE and a NEW instead of a Default */
    IF _palette_item._type <> {&P-BASIC} THEN DO: 
        CHK-DIR:
        DO i = 1 TO NUM-ENTRIES(_palette_item._attr,CHR(10)):
 
         IF ENTRY(i,_palette_item._attr,CHR(10)) BEGINS "DIRECTORY-LIST" 
         THEN DO:
          /* Don't use default on the last menu */
          hp:LABEL = "&Choose " + _palette_item._NAME + "...".
          
          /* Create the Menu-Item in the Sub-menu of the menu-bar */
          CREATE SUB-MENU h_cust_menu 
          ASSIGN          
            LABEL  = _palette_item._label.
          CREATE MENU-ITEM h  
          ASSIGN
            PARENT =  h_cust_menu
            LABEL  = "&Choose " + _palette_item._NAME + "..."
            TRIGGERS:
              ON CHOOSE PERSISTENT RUN tool_choose IN _h_uib (1, _palette_item._name, ?).
            END TRIGGERS. 
           LEAVE CHK-DIR.
         END.
        END.
        /* Is there a NEW option? Add it to both the popup and the menubar */
        IF _palette_item._New_Template <> "" THEN DO:
	  IF NOT VALID-HANDLE(h_cust_menu) THEN DO:
            CREATE SUB-MENU h_cust_menu  
            ASSIGN          
              LABEL  = _palette_item._label.
            /* Create a Default before the new */
            CREATE MENU-ITEM h  
            ASSIGN
              PARENT = h_cust_menu
              LABEL  = "&Default"
              TRIGGERS:
                 ON CHOOSE PERSISTENT RUN tool_choose IN _h_uib (1, _palette_item._name, ?).
              END TRIGGERS. 
	    END.
          CREATE MENU-ITEM h  
          ASSIGN
            PARENT =  h_cust_menu
            LABEL  = "&New " + _palette_item._NAME
            TRIGGERS:
              ON CHOOSE PERSISTENT RUN tool_choose IN _h_uib (1, _palette_item._name, "NEW").
            END TRIGGERS. 
          CREATE MENU-ITEM hp  
          ASSIGN
            PARENT =  h_popup
            LABEL  = "&New " + _palette_item._NAME
            TRIGGERS:
              ON CHOOSE PERSISTENT RUN tool_choose IN _h_uib (1, _palette_item._name, "NEW").
            END TRIGGERS.  
        END.                   
    END.  
    ELSE DO:
      IF NOT VALID-HANDLE(h_cust_menu) THEN
         CREATE SUB-MENU h_cust_menu  
         ASSIGN          
           LABEL  = _palette_item._label.
      /* Create a Default before the new */
      CREATE MENU-ITEM h  
      ASSIGN
        PARENT = h_cust_menu
        LABEL  = "&Default"
        TRIGGERS:
          ON CHOOSE PERSISTENT RUN tool_choose IN _h_uib (1, _palette_item._name, ?).
        END TRIGGERS. 
    END.
          
    IF CAN-FIND (FIRST _custom WHERE _custom._type eq _palette_item._name
                                 AND _custom._name ne "&Default") 
    THEN DO:
      IF NOT VALID-HANDLE(h_cust_menu) THEN DO:
        CREATE SUB-MENU h_cust_menu  
        ASSIGN          
          LABEL  = _palette_item._label.
        CREATE MENU-ITEM h  
        ASSIGN
          PARENT = h_cust_menu
          LABEL  = "&Default"
        TRIGGERS:
          ON CHOOSE PERSISTENT RUN tool_choose IN _h_uib (1, _palette_item._name, ?).
        END TRIGGERS. 
      END.         
      CREATE MENU-ITEM h  
      ASSIGN   /* Add rule to Menu-bar sub-menu */      
          SUBTYPE = "RULE":U
          PARENT =  h_cust_menu.
        
      CREATE MENU-ITEM hp  
      ASSIGN   /* Add rule to popup menu */      
          SUBTYPE = "RULE":U
          PARENT = h_popup.      /* Now add the menu-items.  Order these by _order number. */
      
      FOR EACH _custom WHERE _custom._type eq _palette_item._name
                         AND _custom._name NE "&Default":U:
        /* Add it to the popup */
        CREATE MENU-ITEM hp  
        ASSIGN
            PARENT = h_popup
            LABEL  = _custom._name
            TRIGGERS:
                ON CHOOSE PERSISTENT RUN tool_choose IN _h_uib (1, _palette_item._name, _custom._name).
            END TRIGGERS.
        /* Add it to the menu-bar */
        CREATE MENU-ITEM h  
        ASSIGN
            PARENT = h_cust_menu
            LABEL  = _custom._name
            TRIGGERS:
                ON CHOOSE PERSISTENT RUN tool_choose IN _h_uib (1, _palette_item._name, _custom._name).
            END TRIGGERS.
      END. /* FOR EACH _custom ... */
      
    END. /* IF CAN-FIND (FIRST ... */    
    ELSE DO:
      /* There are no custom widgets for this widget type.  Just add a MENU-ITEM 
      to make the Normal UIB widget (in the Menu-bar). */
      IF    _palette_item._type <= {&P-BASIC} 
         OR NOT VALID-HANDLE(h_cust_menu) THEN 
        CREATE MENU-ITEM h_cust_menu  
        ASSIGN
          LABEL  = _palette_item._label
          TRIGGERS:
            ON CHOOSE PERSISTENT RUN tool_choose IN _h_uib (1, _palette_item._name,?).
          END TRIGGERS.
    END.
    /* Add the popup menu to the frame and the sub-menu to the menu-bar. */
    ASSIGN h_widget_frame:POPUP-MENU = h_popup
           h_cust_menu:PARENT        = ph_widg_submenu.
  END.
  
  /* All the Widget Submenus have been created in the menu-bar.
     Now add a RULE and the Pointer tool */
  CREATE MENU-ITEM h  
  ASSIGN
    SUBTYPE = "RULE":U
    PARENT  = ph_widg_submenu.
  CREATE MENU-ITEM h  
  ASSIGN
    LABEL  = "Poi&nter"
    PARENT = ph_widg_submenu 
    TRIGGERS:
      ON CHOOSE PERSISTENT RUN choose-pointer IN _h_uib.
    END TRIGGERS.
    
RETURN.
