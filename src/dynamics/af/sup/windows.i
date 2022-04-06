/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* ====================================================================
   file      windows.i
   by        Jurjen Dijkstra, 1997
             mailto:jurjen.dijkstra@wxs.nl
             http://www.pugcentral.org/api
   language  Progress 8.2A
   ==================================================================== */

&IF DEFINED(WINDOWS_I)=0 &THEN
&GLOBAL-DEFINE WINDOWS_I


&IF "{&OPSYS}":U="WIN32":U &THEN
   /* 32-bit definitions, Progress 8.2+ */

   /* data types */
   &Glob HWND long
   &Glob BOOL long
   &Glob HINSTANCE long
   &Glob INT long
   &GLOB INTSIZE 4

   /* libraries */
   &GLOB USER   "user32"
   &GLOB KERNEL "kernel32"
   &GLOB SHELL  "shell32"
   &GLOB MAPI   "mapi32"
   &GLOB GDI    "gdi32"
   &GLOB MMEDIA "winmm"
   &GLOB A A
&ELSE
   /* 16-bit definitions, Progress 7 to 8.1 */

   /* data types */
   &Glob HWND short
   &Glob BOOL short
   &Glob HINSTANCE short
   &Glob INT short
   &GLOB INTSIZE 2

   /* libraries */
   &GLOB USER   "user.exe"
   &GLOB KERNEL "kernel.exe"
   &GLOB SHELL  "shell.dll"
   &GLOB MAPI   "mapi.dll"
   &GLOB GDI    "gdi.exe"
   &GLOB A

&ENDIF

/* messages */
&Glob WM_PAINT 15
&Glob WM_HSCROLL 276
&Glob WM_VSCROLL 277
&Glob WM_LBUTTONDOWN 513
&Glob WM_LBUTTONUP 514
&Glob WM_RBUTTONDOWN 516
&Glob WM_RBUTTONUP 517
&GLOB WM_USER 1024

/* mouse buttons */
&Glob MK_LBUTTON 1
&Glob MK_RBUTTON 2

/* scrollbars */
&Glob SB_HORZ 0
&Glob SB_VERT 1
&Glob SB_BOTH 3
&Glob SB_THUMBPOSITION 4

/* editors */
&IF "{&OPSYS}":U="WIN32":U &THEN
   &GLOB EM_SETPASSWORDCHAR 204
&ELSE
    &GLOB EM_SETPASSWORDCHAR {&WM_USER} + 28
&ENDIF

/* some window styles */
&GLOB GWL_STYLE -16
&GLOB WS_MAXIMIZEBOX 65536
&GLOB WS_MINIMIZEBOX 131072
&GLOB WS_THICKFRAME  262144
&GLOB WS_CAPTION 12582912
&GLOB WS_BORDER 8388608

/* some extended window styles */
&GLOB GWL_EXSTYLE -20
&GLOB WS_EX_CONTEXTHELP 1024
&GLOB WS_EX_PALETTEWINDOW 392

/* system commands/menu */
&GLOB SC_SIZE      61440  
&GLOB SC_MINIMIZE  61472
&GLOB SC_MAXIMIZE  61488  
&GLOB MF_BYCOMMAND 0

/* placement order (Z-order) */
&GLOB HWND_TOPMOST -1
&GLOB HWND_NOTOPMOST -2

/* window-positioning flags */
&GLOB SWP_NOSIZE 1
&GLOB SWP_NOMOVE 2
&GLOB SWP_NOZORDER 4
&GLOB SWP_NOACTIVATE 16 
&GLOB SWP_FRAMECHANGED 32
&GLOB SWP_SHOWWINDOW 64


/* get a handle to the procedure definitions */
&IF DEFINED(DONTDEFINE-HPAPI)=0 &THEN
   DEFINE NEW GLOBAL SHARED VARIABLE hpApi AS HANDLE NO-UNDO.
   IF NOT VALID-HANDLE(hpApi) THEN RUN af/sup/windows.p PERSISTENT SET hpApi.

   /* forward function declarations. Must not be included in windows.p : */
   {af/sup/winfunc.i}
&ENDIF

&ENDIF  /* &IF DEFINED(WINDOWS_I)=0 */

