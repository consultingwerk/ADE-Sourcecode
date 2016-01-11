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

File: uibmtrig.i

Description:
   The trigger definitions for the main routine of the UIB.

Input Parameters:
   <None>

Output Parameters:
   <None>

Author: D. Ross Hunter,  Wm.T.Wood

Date Created: 1992 

Modified on 01/23/98 gfs Added DROP-FILE-NOTIFY trigger for main window
                         and add trigger for TOP-ONLY
            04/21/99 tsm Added CHOOSE trigger for Print option (mi_print)
            05/07/99 tsm Added support for MRU Filelist 
            05/17/99 tsm Added support for Save All option
            05/20/99 xbo Added support for New ADM2 class option    
----------------------------------------------------------------------------*/
/* ===================================================================== */
/*               Keystrokes that should work in all windows              */
/* ===================================================================== */

/* ****************** File Menu ******************* */

/* Create a new window (.w file) */
ON CHOOSE OF MENU-ITEM mi_new IN MENU m_file RUN choose_file_new.

/* Open a File */
ON CHOOSE OF MENU-ITEM mi_open IN MENU m_file RUN choose_file_open.

/* Close only the current window */
ON CHOOSE OF MENU-ITEM mi_close  IN MENU m_file RUN choose_close.
/* Close one or more windows */
ON CHOOSE OF MENU-ITEM mi_close_all   IN MENU m_file RUN choose_close_all.

/* Save a File */
ON CHOOSE OF MENU-ITEM mi_save     IN MENU m_file RUN choose_file_save.
ON CHOOSE OF MENU-ITEM mi_save_as  IN MENU m_file RUN choose_file_save_as.
ON CHOOSE OF MENU-ITEM mi_save_all IN MENU m_file RUN choose_file_save_all.

/* Print a File */
ON CHOOSE OF MENU-ITEM mi_print   IN MENU m_file RUN choose_file_print.

/* ****************** Edit Menu ******************* */

/* Undo the Last Action */
ON CHOOSE OF MENU-ITEM mi_undo IN MENU m_edit RUN choose_undo.

/* Cut/Copy/Paste */
ON CHOOSE OF MENU-ITEM mi_cut IN MENU m_edit RUN choose_cut.
ON CHOOSE OF MENU-ITEM mi_copy IN MENU m_edit RUN choose_copy.
ON CHOOSE OF MENU-ITEM mi_paste IN MENU m_edit RUN choose_paste.


/* ***************** Compile Menu ****************** */
/* Running (or hitting GO/F2 in any window) test-runs the window */
ON CHOOSE OF MENU-ITEM mi_run in MENU m_compile RUN choose_run.

/* Check Syntax of current window */
ON CHOOSE OF MENU-ITEM mi_check IN MENU m_compile RUN choose_check_syntax.

/* Debug current window */
ON CHOOSE OF MENU-ITEM mi_debugger IN MENU m_compile RUN choose_debug.

/* Previewer : This is the code previewer */
ON CHOOSE OF MENU-ITEM mi_preview RUN choose_code_preview.

 
/* ****************** Tools Menu ******************* */

/* Open a New Procedure Window. */
ON CHOOSE OF MENU-ITEM mi_new_pw RUN choose_new_pw.

/* New ADM2 Class... */
ON CHOOSE OF MENU-ITEM mi_new_adm2_class RUN choose_new_adm2_class.


/* Run XFTR Editor */
/*ON CHOOSE OF MENU-ITEM mi_xftr_edit RUN adeuib/_xftred.w.*/


/* ****************** Window Menu ******************* */

ON WINDOW-CLOSE OF _h_object_win DO:
  /* Hide the window, if it is visible. (i.e.  If someone applies the event to
     the palette window when it is hidden, then do nothing.) */
  IF _h_object_win:VISIBLE THEN RUN choose_show_palette.
END.

/* **************************** Options Menu *************************** */
ON CHOOSE OF MENU-ITEM mi_user_prefs IN MENU m_options RUN edit_preferences.

/* ****************** Toolbox Menubar ******************* */
ON VALUE-CHANGED OF MENU-ITEM mi_top_only _h_object_win:TOP-ONLY = SELF:CHECKED.

/* Load in the Custom Widgets file */
ON CHOOSE OF MENU-ITEM mi_get_custom RUN get_custom_widget_defs.

/* Add a new ocx to the Palette */
ON CHOOSE OF MENU-ITEM mi_ocx_palette RUN add_palette_custom_widget_defs.
ON CHOOSE OF MENU-ITEM mi_ocx_submenu RUN add_submenu_custom_widget_defs.


ON VALUE-CHANGED OF MENU-ITEM mi_menu_only 
   RUN switch_palette_menu (INPUT SELF:CHECKED).
ON CHOOSE OF MENU-ITEM mi_save_palette RUN save_palette. 
 
/* ===================================================================== */
/*                         Help System Definitions                       */
/* ===================================================================== */
/* Help on the menu window; the tool window */
ON HELP OF _h_menu_win 
  RUN adecomm/_adehelp.p ( "AB", "TOPICS", {&UIB_Main_Window}, ? ).

ON HELP OF _h_object_win
  RUN adecomm/_adehelp.p ( "AB", "CONTEXT", {&Widget_Palette}, ? ).
    

/* ********************************************************************** */
/*                            Other Triggers                              */
/* ********************************************************************** */

/* Double-Clicking in the Status line changes the page number, or locks
   the page.  Note that the handles of the text areas in the status bar
   are stored in the PRIVATE-DATA of the status line. */  
ASSIGN h = WIDGET-HANDLE(ENTRY(2,_h_status_line:PRIVATE-DATA))
       h:SENSITIVE = yes.
ON MOUSE-SELECT-DBLCLICK OF h DO: 
  /* Don't do anything if there is no window, or the window does not
     support pages. */
  IF VALID-HANDLE(_h_win) THEN DO: 
    FIND _P WHERE _P._WINDOW-HANDLE eq _h_win.
    IF CAN-DO(_P._links, "Page-Target") THEN RUN choose_goto_page.
  END.
END. 

/* Lock/Unlock the current tool. */
ASSIGN h = WIDGET-HANDLE(ENTRY(4,_h_status_line:PRIVATE-DATA))
       h:SENSITIVE = yes.
ON MOUSE-SELECT-DBLCLICK OF h 

    RUN tool_choose IN THIS-PROCEDURE (3, ?, ?).

/* Before we leave the UIB main window, make sure any user changes to
   cur_widg_name and cur_widg_text are dealt with.

   [This is because clicking in another window does not explicitly send
   LEAVE to the fields in the main window].  First check for VALID-HANDLE
   to avoid changing deleted widgets or current widget UNKNOWN.

   Note 1:
   We don't need to check for changes on fill-ins that aren't sensitive.

   Note 2:
   This code is also in uibmproa.i PROCEDURE display_current. Its needed there
   because under Windows, clicking back into the design window's frame
   does not fire this LEAVE event.  It does under Motif. I think this
   is a bug, but I'll have to figure it out better and log a separate bug.
   This trigger fixes bug 94-03-11-046. (jep 08/08/94).
*/
ON LEAVE OF _h_menu_win
DO:
DO WITH FRAME action_icons:
   IF VALID-HANDLE(h_display_widg) THEN
   DO:
     IF cur_widg_name:SENSITIVE AND INPUT cur_widg_name ne display_name 
     THEN APPLY "LEAVE":U TO cur_widg_name.
     IF cur_widg_text:SENSITIVE AND INPUT cur_widg_text ne display_text
     THEN APPLY "LEAVE":U TO cur_widg_text.
   END.
END.

END.

/* Change the Label/text/value of the displayed widget */
ON RETURN, LEAVE OF cur_widg_text IN FRAME action_icons RUN change_label.

/* Change the name of the displayed widget - Note that TEXT widgets don't */
/* have a name that the user can change. This procedure can find an error */
/* on leaving cur_widg_name.  This sets the error flag.                   */
ON RETURN, LEAVE OF cur_widg_name IN FRAME action_icons RUN change_name.

/* Process Drop operation. If file names are dropped onto the UIB's 
   main window, we will try to open them - it's magic! */
ON DROP-FILE-NOTIFY OF _h_menu_win 
DO:
  DEFINE VARIABLE i           AS INTEGER NO-UNDO.
  DEFINE VARIABLE h_curwin    AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRepDesignManager    AS HANDLE  NO-UNDO.
  
  ASSIGN h_curwin = _h_win.

  /* Deselect the currently selected widgets */
  RUN deselect_all (?, ?).
  RUN setstatus (?, "Opening file...").

  /* Run through list of dropped files and open each one */
  DO i = 1 TO _h_menu_win:NUM-DROPPED-FILES:
    IF CAN-DO(_AB_Tools, "Enable-ICF":U) THEN
    DO:
       hRepDesignManager = DYNAMIC-FUNCTION("getManagerHandle":U, INPUT "RepositoryDesignManager":U) NO-ERROR.
       IF VALID-HANDLE(hRepDesignManager) THEN
          DYNAMIC-FUNCTION("openRyObjectAB" IN hRepDesignManager, INPUT _h_menu_win:GET-DROPPED-FILE(i) ).
    END. 
    RUN adeuib/_open-w.p (INPUT _h_menu_win:GET-DROPPED-FILE(i), 
                          "", INPUT "Window").
  END.
  
  /* Release memory reserved by drag operation */
  _h_menu_win:END-FILE-DROP(). 

  /* Reset the status area */
  RUN setstatus ("":U, "":U).

  /* Return to pointer mode. */
  IF _next_draw NE ? THEN RUN choose-pointer.

  /* If no file was opened, leave now. */
  IF (_h_win = ?) OR (_h_win = h_curwin) THEN RETURN.

  /* Special Sanity check -- sanitize our records.*/
  RUN adeuib/_sanitiz.p.
END.



