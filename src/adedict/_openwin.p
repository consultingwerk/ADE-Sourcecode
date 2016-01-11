/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _openwin.p

Description:
   A new object has just been selected or double clicked on.  Prepare for
   showing the properties for the selected schema object by opening the 
   window.  

   If the window is already open, don't do anything.  We only want to 
   de-iconify or move to the front if user explicitly asked for
   properties - not if they just switch objects or delete an object 
   causing a different one to be current etc and this code is called in 
   all of these situations.

Input Parameter:
   p_Title  - The title for the window.
   p_Frame  - The widget handle of the frame to be displayed in the window.
      	      It is used to determine the height and width for the window.
   p_Obj    - Object # (which type of prop window is it?)

Input/Output Parameter:
   p_WinHdl - Widget handle for the window to open or refresh. 

Author: Laura Stern

Date Created: 06/08/92 

----------------------------------------------------------------------------*/

{adedict/dictvar.i shared}


Define INPUT   	    parameter p_Title  as char	      	NO-UNDO.
Define INPUT   	    parameter p_Frame  as widget-handle NO-UNDO.
Define INPUT        parameter p_Obj    as integer       NO-UNDO.
Define INPUT-OUTPUT parameter p_WinHdl as widget-handle NO-UNDO.

Define var wid  as decimal NO-UNDO.
Define var ht   as decimal NO-UNDO.
Define var newx as integer NO-UNDO.
Define var newy as integer NO-UNDO.

/* If window isn't open yet, then open it */
if p_WinHdl = ? then
do:
   assign
      /* Add on fudge factor for window decorations.  It doesn't have to
      	 be accurate.
      */ 
      ht = p_Frame:height-pixels + 30
      wid = p_Frame:width-pixels + 15
      newx = s_win_Browse:x + 60
      newy = s_win_Browse:y + 30.

   if newx + wid > session:width-pixels then
      newx = session:width-pixels - wid.
   if newy + ht > session:height-pixels then
      newy = session:height-pixels - ht.

   /* Create with the default size */
   create window p_WinHdl
      assign
         title = p_Title
      	 message-area = no
      	 status-area = no
      	 scroll-bars = no
      	 x = (if s_x_Win[p_Obj] = ? then newx else s_x_Win[p_Obj])
      	 y = (if s_y_Win[p_Obj] = ? then newy else s_y_Win[p_Obj])
      triggers:
         on window-close PERSISTENT 
  	  run adedict/_closwin.p.
      end triggers.
   s_Res = p_WinHdl:load-icon("adeicon/dict%").	/* set minimize icon */

   /* Then resize to fit the frame */
   assign
      ht = p_Frame:height-chars
      wid = p_Frame:width-chars
      p_WinHdl:height-chars = ht
      p_WinHdl:width-chars = wid
      p_WinHdl:max-height = ht
      p_WinHdl:max-width = wid
      p_WinHdl:visible = yes.

   CURRENT-WINDOW = p_WinHdl.
   apply "entry" to p_WinHdl. /* give the window focus */
end.














