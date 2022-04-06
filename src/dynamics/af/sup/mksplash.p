/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* ===================================================================
   file     : MkSplash.p
   by       : Jurjen Dijkstra, 1997
   language : Progress 8.2A on Windows 95
   purpose  : changes the appearance of a normal Progress window
              into a Splash window, e.g. no caption, no border, 
              centered to screen, stay-on-top.
   params   : hClient    = HWND of a client window
              ThinBorder = YES if a WS_BORDER style is wanted
                           NO creates no border at all
   usage    : during mainblock:
              run MkSplash.p ({&WINDOW-NAME}:HWND, YES).
   =================================================================== */

define input parameter hClient as integer.
define input parameter ThinBorder as logical.

  {af/sup/windows.i}
  {af/sup/proextra.i}

  def var hNonclient as integer no-undo.
  def var style as integer no-undo.
  def var oldstyle as integer no-undo.

  run GetParent in hpApi(hClient, output hNonclient).

  /* delete the caption and the thickframe */
  run GetWindowLong{&A} in hpApi(hNonclient, {&GWL_STYLE}, output style).
  run Bit_Remove in hpExtra(input-output style, {&WS_CAPTION}).
  run Bit_Remove in hpExtra(input-output style, {&WS_THICKFRAME}).
  run SetWindowLong{&A} in hpApi(hNonclient, {&GWL_STYLE}, style, output oldstyle).

  /* the next block creates a thin border around the window. 
     This has to be done in a second SetWindowLong */
  if ThinBorder then do:
    run GetWindowLong{&A} in hpApi(hNonclient, {&GWL_STYLE}, output style).
    run Bit_Or in hpExtra(input-output style, {&WS_BORDER}).
    run SetWindowLong{&A} in hpApi(hNonclient, {&GWL_STYLE}, style, output oldstyle).
  end.

  /* The above changes in window styles are usually done before the window is
     created. Now we are actually too late, windows will not respond with an 
     automatic redraw of the window. We will have to force it. This is done by
     calling SetWindowPos with the SWP_FRAMECHANGED flag. 
     Since we are calling SetWindowPos we might as well ask it to perform 
     some other actions, like:
       make this a TOPMOST window,
       change the coordinates (centered to screen)
  */

  def var lpRect as memptr.
  def var width as integer.
  def var height as integer.

  /* the lpPoint structure is defined as LEFT,TOP,RIGHT,BOTTOM. */
  set-size(lpRect) = 4 * {&INTSIZE}.

  /* get the dimensions of the client area: */
  run GetWindowRect in hpApi(hClient, output lpRect).
  /* I wonder if it would have been better to use:
     run GetClientRect in hpApi(hNonClient, output lpRect). */

  /* let Windows calculate how large the NonClient area must be
     to fit exactly around the Client area: */
  run AdjustWindowRect in hpApi(input-output lpRect, style, 0).

  /* so these will be the new dimensions of the Nonclient area: */
  width  =   get-{&INT}(lpRect, 1 + 2 * {&INTSIZE}) 
           - get-{&INT}(lpRect, 1 + 0 * {&INTSIZE}). 
  height =   get-{&INT}(lpRect, 1 + 3 * {&INTSIZE}) 
           - get-{&INT}(lpRect, 1 + 1 * {&INTSIZE}). 

  /* Do it. SWP_FRAMECHANGED is the most important flag here */
  run SetWindowPos in hpApi
      (hNonclient, 
       {&HWND_TOPMOST},
       INTEGER((session:width-pixels - width) / 2), 
       INTEGER((session:height-pixels - height) / 2), 
       width, 
       height, 
       {&SWP_NOACTIVATE} + {&SWP_FRAMECHANGED}
      ).


RETURN.
