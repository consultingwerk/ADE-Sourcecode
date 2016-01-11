/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------
File: grptrig.i
Description:
   The trigger definitions for keystrokes that should work in all windows
   of the UIB.  These are things like
       ON CTRL-X OF _h_win ANYWHERE PERSISTENT RUN choose_cut.
Input Parameters:
   &of-widget-list : Can be blank if you want to just
                   ON CTRL-X ANYWHERE ...        
Author: Wm.T.Wood Sept. 13, 1993
----------------------------------------------------------------------------*/
/* ****************** File Menu ******************* */
ON SHIFT-F3 {&of-widget-list} ANYWHERE PERSISTENT RUN choose_file_new     IN _h_uib.
ON F3       {&of-widget-list} ANYWHERE PERSISTENT RUN choose_file_open    IN _h_uib.
ON CTRL-F3  {&of-widget-list} ANYWHERE PERSISTENT RUN choose_new_pw       IN _h_uib.
ON F6       {&of-widget-list} ANYWHERE PERSISTENT RUN choose_file_save    IN _h_uib.
ON SHIFT-F6 {&of-widget-list} ANYWHERE PERSISTENT RUN choose_file_save_as IN _h_uib.
ON F8       {&of-widget-list} ANYWHERE PERSISTENT RUN choose_close        IN _h_uib.
ON SHIFT-F8 {&of-widget-list} ANYWHERE PERSISTENT RUN choose_close_all    IN _h_uib.
/* ****************** Edit Menu ******************* */
ON CTRL-Z   {&of-widget-list} ANYWHERE PERSISTENT RUN choose_undo         IN _h_uib.
ON CTRL-X   {&of-widget-list} ANYWHERE PERSISTENT RUN choose_cut          IN _h_uib.
ON CTRL-C   {&of-widget-list} ANYWHERE PERSISTENT RUN choose_copy         IN _h_uib.
ON CTRL-V   {&of-widget-list} ANYWHERE PERSISTENT RUN choose_paste        IN _h_uib.
ON DEL      {&of-widget-list} ANYWHERE PERSISTENT RUN choose_erase        IN _h_uib.
/* ***************** Compile Menu ****************** */
ON GO       {&of-widget-list} ANYWHERE PERSISTENT RUN choose_run          IN _h_uib.
ON Shift-F2 {&of-widget-list} ANYWHERE PERSISTENT RUN choose_check_syntax IN _h_uib.
ON SHIFT-F4 {&of-widget-list} ANYWHERE PERSISTENT RUN choose_debug        IN _h_uib.
ON F5       {&of-widget-list} ANYWHERE PERSISTENT RUN choose_code_preview IN _h_uib.
/* ****************** Tools Menu ******************* */
ON CTRL-W   {&of-widget-list} ANYWHERE PERSISTENT RUN choose_uib_browser  IN _h_uib.
/* ****************** Window Menu ******************* */
ON CTRL-T   {&of-widget-list} ANYWHERE PERSISTENT RUN choose_show_palette IN _h_uib.
ON CTRL-S   {&of-widget-list} ANYWHERE PERSISTENT RUN choose_codedit      IN _h_uib.
ON CTRL-P   {&of-widget-list} ANYWHERE PERSISTENT RUN choose_attributes   IN _h_uib.
