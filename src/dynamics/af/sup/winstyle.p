/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* =====================================================================
   File    : WinStyle.p
   by      : Jurjen Dijkstra, 1997
             mailto:jurjen.dijkstra@wxs.nl
             http://www.pugcentral.org/api
   purpose : a couple of procedures to change the appearance of a window
   ===================================================================== */

{af/sup/windows.i}
{af/sup/proextra.i}

PROCEDURE DeleteMinMaxButtons :
  define input parameter hClient as integer. /* hWnd */

  def var hNonClient as integer no-undo. /* hWnd */
  def var style as integer no-undo.
  def var oldstyle as integer no-undo.
  def var MaxAvail as integer no-undo.
  def var MinAvail as integer no-undo.


  run FindCaptionParent(hClient, output hNonClient).
  if hNonClient=0 then return.

  run GetWindowLong{&A} in hpApi(hNonClient, 
                                 {&GWL_STYLE}, 
                                 output style).


  run Bit_And in hpExtra(input style,
                         {&WS_MAXIMIZEBOX},
                         output MaxAvail).
  run Bit_And in hpExtra(input style,
                         {&WS_MINIMIZEBOX},
                         output MinAvail).
  if MaxAvail=0 and MinAvail=0 then return. /* ready */

  run Bit_Remove in hpExtra(input-output style, 
                           {&WS_MAXIMIZEBOX}).
  run Bit_Remove in hpExtra(input-output style, 
                            {&WS_MINIMIZEBOX}).

  /* the THICKFRAME allows resizing the frame
     with the mouse. Makes no sense anymore, so delete it: */
  run Bit_Remove in hpExtra(input-output style,  
                            {&WS_THICKFRAME}).

  run SetWindowLong{&A} in hpApi(hNonClient, 
                                {&GWL_STYLE}, 
                                style, 
                                output oldstyle).

  /* there is now a little gap between the Client-area and
     the Nonclient-area because the THICKFRAME is replaced
     by a normal (thinner) frame. Fix it by shrinking the frame 
     until it tightly fits around the client-area. */
  def var width as integer no-undo.
  def var height as integer no-undo.
  run FitFrame(hNonClient, output width, output height).
  run SetWindowPos in hpApi
      (hNonclient, 
       0,
       0, 
       0, 
       width, 
       height, 
       {&SWP_NOMOVE} + {&SWP_NOZORDER} + {&SWP_NOACTIVATE} + {&SWP_FRAMECHANGED}
      ).

  /* remove the corresponding items from the system menu. They are
     already greyed since the buttons are gone */
  run NoSizingMenu(hNonClient).

END PROCEDURE.


PROCEDURE AddHelpButton :

  define input parameter hClient as integer. /* hWnd */

  def var hNonClient as integer no-undo.  /* hWnd */
  def var style as integer no-undo.
  def var oldstyle as integer no-undo.

  run FindCaptionParent(hClient, output hNonClient).
  if hNonClient=0 then return.

  /* it is impossible to create a helpbutton when 
     the window has minimize/maximize-buttons, so
     these must first be removed                  */
  run DeleteMinMaxButtons(hClient).

  run GetWindowLong{&A} in hpApi(hNonClient, 
                                 {&GWL_EXSTYLE}, 
                                 output style).
  run Bit_Or in hpExtra(input-output style, 
                       {&WS_EX_CONTEXTHELP}).
  run SetWindowLong{&A} in hpApi(hNonClient, 
                                 {&GWL_EXSTYLE}, 
                                 style, 
                                 output oldstyle).

  /* The caption needs to be redrawn now : */
  run FlashWindow in hpApi (hNonClient,0).

END PROCEDURE.


PROCEDURE AddPaletteStyle :

  define input parameter hClient as integer. /* hWnd */

  def var hNonClient as integer no-undo.  /* hWnd */
  def var style as integer no-undo.
  def var oldstyle as integer no-undo.

  run FindCaptionParent(hClient, output hNonClient).
  if hNonClient=0 then return.

  /* window must be invisble. Else it's very confusing for Windows */
  run ShowWindow in hpApi(hNonClient, 0). /* 0 = SW_HIDE */

  run GetWindowLong{&A} in hpApi(hNonClient, 
                                 {&GWL_EXSTYLE}, 
                                 output style).
  run Bit_Or in hpExtra(input-output style, 
                        {&WS_EX_PALETTEWINDOW}).
  run SetWindowLong{&A} in hpApi(hNonClient, 
                                 {&GWL_EXSTYLE}, 
                                 style, 
                                 output oldstyle).

  /* WS_EX_PALETTEWINDOW includes the WS_EX_TOPMOST style
     but this one cannot be set afterwards. To add the
     WS_EX_TOPMOST style to an existing window you must
     use SetWindowPos. Great, we need SetWindowPos anyway
     to apply SWP_FRAMECHANGED                         */

  /* The caption needs to be redrawn now : */
  def var width as integer no-undo.
  def var height as integer no-undo.
  run FitFrame(hNonClient, output width, output height).
  run SetWindowPos in hpApi
      (hNonclient, 
       {&HWND_TOPMOST},
       0, 
       0, 
       width, 
       height, 
       {&SWP_NOMOVE} + {&SWP_NOACTIVATE} + {&SWP_FRAMECHANGED} + {&SWP_SHOWWINDOW}
      ).

END PROCEDURE.


/* ------------------------------------------------------------
   the next internal procedures must be considered 'private';
   they are not designed to be run from an external procedure  
   ------------------------------------------------------------ */

PROCEDURE NoSizingMenu :
  define input parameter hNonClient as integer. /* hwnd */
  def var hSysmenu as integer no-undo.
  run GetSystemMenu in hpApi (hNonClient, 0, output hSysmenu).
  run DeleteMenu in hpApi (hSysmenu, {&SC_SIZE}    , {&MF_BYCOMMAND}).
  run DeleteMenu in hpApi (hSysmenu, {&SC_MINIMIZE}, {&MF_BYCOMMAND}).
  run DeleteMenu in hpApi (hSysmenu, {&SC_MAXIMIZE}, {&MF_BYCOMMAND}).
END PROCEDURE.


PROCEDURE FindCaptionParent :
  define input parameter hClient as integer. /* hwnd */
  define output parameter hNonClient as integer. /* hwnd */

  /* hClient can be the hWnd of any widget.
     This procedure travels up the GetParent-chain until
     it finds the hWnd of the NonClient-window that has
     direct access to the caption */

  def var style as integer no-undo.
  def var result as integer no-undo initial 0.

  hNonClient = hClient.
  do while result=0 and hNonClient<>0 :
    run GetWindowLong{&A} in hpApi(hClient, 
                                  {&GWL_STYLE}, 
                                  output style).
    run Bit_And in hpExtra(style, 
                          {&WS_CAPTION}, 
                          output result).
    if result=0 then do:
       hNonClient = GetParent(hClient).
       hClient    = hNonClient.
    end.
  end.

END PROCEDURE.


PROCEDURE FitFrame :
  define input parameter hNonClient as integer. /* hwnd */
  define output parameter width as integer.
  define output parameter height as integer.

  def var lpRect as memptr.
  def var style as integer.

  /* the lpPoint structure is defined as LEFT,TOP,RIGHT,BOTTOM. */
  set-size(lpRect) = 4 * {&INTSIZE}.

  /* get the dimensions of the client area: */
  run GetClientRect in hpApi(hNonClient, output lpRect).

  /* let Windows calculate how large the NonClient area must be
     to fit exactly around the Client area: */
  run GetWindowLong{&A} in hpApi(hNonClient, 
                                 {&GWL_STYLE}, 
                                 output style).
  run AdjustWindowRect in hpApi(input-output lpRect, style, 0).

  /* so these will be the new dimensions of the Nonclient area: */
  width  =   get-{&INT}(lpRect, 1 + 2 * {&INTSIZE}) 
           - get-{&INT}(lpRect, 1 + 0 * {&INTSIZE}). 
  height =   get-{&INT}(lpRect, 1 + 3 * {&INTSIZE}) 
           - get-{&INT}(lpRect, 1 + 1 * {&INTSIZE}). 


END PROCEDURE.
