/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
  13/2/09 hdaniels 
----------------------------------------------------------------------------*/
{adeuib/sharvars.i}    /* Most common shared variables        */
{adeuib/custwidg.i}    /* Custom Widget Definitions           */

define input  parameter ph_widg_submenu as WIDGET  no-undo.

define var h               as WIDGET  no-undo.
define var hp              as WIDGET  no-undo.
define var h_cust_menu     as WIDGET  no-undo.
define var h_popup         as WIDGET  no-undo.    
define var h_widget_frame  as WIDGET  no-undo.
define var i               as integer no-undo.

/* First destroy any of the DYNAMIC elements on the widget submenu, and on
  the Widget Palette. */
h = ph_widg_submenu:LAST-CHILD.
do while VALID-HANDLE(h):
    h_cust_menu = h:PREV-SIBLING.  /* Store this before we delete sub-menus */
    if h:DYNAMIC then delete widget h.
    h = h_cust_menu.
end.

/* Loop though all widgets except pointer and DB fields */
for each _palette_item where _palette_item._NAME <> "POINTER" by _label2:
     
       /* Delete any existing popup menu on the frames in the palette. 
	    The up-image is on the frame with the popup menu.
	    Find these widgets and delete them.  */
    assign h_widget_frame = _palette_item._h_up_image:FRAME
           h_popup        = h_widget_frame:POPUP-MENU
           h_cust_menu    = ?
           .
    if VALID-HANDLE(h_popup) then delete widget h_popup.
                
	/* Create a POPUP menu of custom widgets to attach to the up image.  The
	   first item on this list is always the UIB standard. Also create a 
	   submenu for the Main Menubar with the same UIB standard item.  BUT only
	   do this if there are other items to add to the list.  */
    create menu h_popup  
    assign 
        POPUP-ONLY = yes. 
    
    create menu-item hp  
      assign
        PARENT = h_popup
        label  = "&Default"
        triggers:
            on choose persistent run tool_choose in _h_uib (1, _palette_item._name, ?).
        end triggers. 
    
	/* SmartObjects (& User-Defined) can have a CHOOSE and a NEW instead of a Default */
    if _palette_item._type <> {&P-BASIC} then 
    do: 
        CHK-DIR:
        do i = 1 to NUM-ENTRIES(_palette_item._attr,CHR(10)): 
            if ENTRY(i,_palette_item._attr,CHR(10)) begins "DIRECTORY-LIST" then 
            do:
                /* Don't use default on the last menu */
                hp:LABEL = "&Choose " + _palette_item._NAME + "...".
          
                /* Create the Menu-Item in the Sub-menu of the menu-bar */
                create sub-menu h_cust_menu 
                  assign          
                    label  = _palette_item._label.
                
                create menu-item h  
                  assign
                    PARENT =  h_cust_menu
                    label  = "&Choose " + _palette_item._NAME + "..."
                  triggers:
                      on choose persistent run tool_choose in _h_uib (1, _palette_item._name, ?).
                  end triggers. 
                
                LEAVE CHK-DIR.
            end. /* if entry ... begins "directory-list" */
        end. /*do i = 1 to NUM-ENTRIES */
        
        /* Is there a NEW option? Add it to both the popup and the menubar */
        if _palette_item._New_Template <> "" then 
        do:
            if not VALID-HANDLE(h_cust_menu) then 
            do:
                create sub-menu h_cust_menu  
                  assign          
                    label  = _palette_item._label.
                /* Create a Default before the new */
                create menu-item h  
                  assign
                    PARENT = h_cust_menu
                    label  = "&Default"
                  triggers:
                     on choose persistent run tool_choose in _h_uib (1, _palette_item._name, ?).
                  end triggers. 
            end.
            
            create menu-item h  
              assign
                PARENT =  h_cust_menu
                label  = "&New " + _palette_item._NAME
              triggers:
                on choose persistent run tool_choose in _h_uib (1, _palette_item._name, "NEW").
              end triggers. 
            
            create menu-item hp  
              assign
                PARENT =  h_popup
                label  = "&New " + _palette_item._NAME
              triggers:
                on choose persistent run tool_choose in _h_uib (1, _palette_item._name, "NEW").
              end triggers.  
        end.   /* _palette_item._New_Template <> "" */                 
    end.  /* _palette_item._type <> {&P-BASIC}*/
    else do:
        if not VALID-HANDLE(h_cust_menu) then
            create sub-menu h_cust_menu  
              assign          
                label  = _palette_item._label.
        
        /* Create a Default before the new */
        create menu-item h  
          assign
            PARENT = h_cust_menu
            label  = "&Default"
          triggers:
            on choose persistent run tool_choose in _h_uib (1, _palette_item._name, ?).
          end triggers. 
    end. /* else (type = {&P-BASIC})*/
      
    if can-find (first _custom where _custom._type eq _palette_item._name
                                 and _custom._name ne "&Default") then 
    do:
        if not VALID-HANDLE(h_cust_menu) then 
        do:       
            create sub-menu h_cust_menu  
              assign          
                label  = _palette_item._label.
        
            create menu-item h  
              assign
                PARENT = h_cust_menu
                label  = "&Default"
            triggers:
              on choose persistent run tool_choose in _h_uib (1, _palette_item._name, ?).
            end triggers. 
        end.         
        
        create menu-item h  
          assign   /* Add rule to Menu-bar sub-menu */      
            SUBTYPE = "RULE":U
            PARENT =  h_cust_menu.
        
        create menu-item hp  
          assign   /* Add rule to popup menu */      
            SUBTYPE = "RULE":U
            PARENT = h_popup.      
        /* Now add the menu-items.  Order these by _order number. */
        for each _custom where _custom._type eq _palette_item._name
                           and _custom._name ne "&Default":U:
            /* Add it to the popup */
            create menu-item hp  
              assign
                PARENT = h_popup
                label  = _custom._name
              triggers:
                on choose persistent run tool_choose in _h_uib (1, _palette_item._name, _custom._name).
              end triggers.
            /* Add it to the menu-bar */
            create menu-item h  
            assign
                PARENT = h_cust_menu
                label  = _custom._name
                triggers:
                    on choose persistent run tool_choose in _h_uib (1, _palette_item._name, _custom._name).
                end triggers.
        end. /* FOR EACH _custom ... */         
    end. /* IF CAN-FIND (FIRST _custom  */    
    else do:
        /* There are no custom widgets for this widget type.  Just add a MENU-ITEM 
           to make the Normal UIB widget (in the Menu-bar). */
        if _palette_item._type <= {&P-BASIC} 
        or not VALID-HANDLE(h_cust_menu) then 
            create menu-item h_cust_menu  
              assign
                label  = _palette_item._label
               triggers:
                 on choose persistent run tool_choose in _h_uib (1, _palette_item._name,?).
               end triggers.
    end.
    
    /* Add the popup menu to the frame and the sub-menu to the menu-bar. */
    assign h_widget_frame:POPUP-MENU = h_popup
           h_cust_menu:PARENT        = ph_widg_submenu.
end. /* for each _palette */
  
    /* All the Widget Submenus have been created in the menu-bar.
   Now add a RULE and the Pointer tool */
create menu-item h  
  assign
    SUBTYPE = "RULE":U
    PARENT  = ph_widg_submenu.
create menu-item h  
  assign
    label  = "Poi&nter"
    PARENT = ph_widg_submenu 
  triggers:
    on choose persistent run choose-pointer in _h_uib.
  end triggers.

return.
