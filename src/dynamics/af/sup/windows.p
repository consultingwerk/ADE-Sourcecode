/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

&if '{&OPSYS}' ne 'Unix' &then
/* ====================================================================
   file      windows.p
   by        Jurjen Dijkstra, 1997
             mailto:jurjen.dijkstra@wxs.nl
             http://www.pugcentral.org/api
   language  Progress 8.2A
   purpose   declarations for windows API procedures
   ==================================================================== */

&GLOB DONTDEFINE-HPAPI
{af/sup/windows.i}

PROCEDURE AdjustWindowRect EXTERNAL {&USER} :
  define input-output parameter lpRect as MEMPTR.
  define input parameter dwstyle as long.
  define input parameter bMenu as {&BOOL}.
END.

PROCEDURE ClientToScreen EXTERNAL {&USER}:
    DEFINE INPUT PARAMETER win-handle AS {&HWND}.
    DEFINE INPUT PARAMETER lppoint AS MEMPTR.
END.

PROCEDURE CreateProcess{&A} EXTERNAL {&KERNEL} :
  define input parameter lpApplicationName as long. /* NULL */
  define input parameter lpCommandline     as char.
  define input parameter lpProcessAttributes as long.
  define input parameter lpThreadAttributes as long.
  define input parameter bInheritHandles as {&BOOL}.
  define input parameter dCreationFlags as LONG.
  define input parameter lpEnvironment as LONG.
  define input parameter lpCurrentDirectory as long.
  define input parameter lpStartupInfo as long.
  define input parameter lpProcessInformation as long. 
  define return parameter bResult as {&BOOL}. 
END PROCEDURE.

PROCEDURE DeleteMenu EXTERNAL {&USER} :
   define input parameter hMenu as {&INT}.
   define input parameter uPosition as {&INT}.
   define input parameter uFlags as {&INT}.
END.

PROCEDURE EnumPrinters{&A} EXTERNAL "winspool.drv" :
   DEFINE INPUT PARAMETER Flags as LONG.       /* Local, shared, network,etc.. */
   DEFINE INPUT PARAMETER Name as CHAR.        /* LEAVE AS NULL ie.: 0 */
   DEFINE INPUT PARAMETER Level as LONG.       /* Type of info to return: 1,2,5 on W95 */
   DEFINE INPUT PARAM pPrinterEnum as LONG.    /* points to PRINTER_INFO_n structures */
   DEFINE INPUT PARAM cbBuf as LONG.           /* Tells function the size of pPrinterEnum */
   DEFINE OUTPUT PARAM pcbNeeded as LONG.      /* Number of bytes copied or required */
   DEFINE OUTPUT PARAM pcReturned as LONG.     /* Number of PRINTER_INFO_n   structures returned */
   DEFINE RETURN PARAM RetValue as SHORT.      /* A Bool value = zero if failure */
END PROCEDURE.

PROCEDURE FindExecutable{&A} EXTERNAL {&SHELL} :
  define input parameter lpFile as char.
  define input parameter lpDirectory as char.
  define input-output parameter lpResult as char.
  define return parameter hInstance as {&INT}.
END.

PROCEDURE FlashWindow EXTERNAL {&USER} :
   define input parameter hwnd as {&HWND}.
   define input parameter bInvert as {&BOOL}.
END.

PROCEDURE FormatMessage{&A} EXTERNAL {&KERNEL} :
  define input parameter  dwFlags as long.
  define input parameter  lpSource as long.
  define input parameter  dwMessageID as LONG. 
  define input parameter  dwLanguageID as LONG. 
  define output parameter lpBuffer as char.
  define input parameter  nSize as long.
  define input parameter  lpArguments as long.
END PROCEDURE.

PROCEDURE FreeLibrary EXTERNAL {&KERNEL} :
  define input parameter hproc as {&HINSTANCE}.
END.

PROCEDURE GetClientRect EXTERNAL {&USER} :
  define input parameter hwnd as {&HWND}.
  define output parameter lpRect as MEMPTR.
END PROCEDURE.

procedure GetDC external {&USER} :
  define input  parameter hwnd as {&HWND}.
  define return parameter hdc as {&INT}.
end procedure.

procedure GetDeviceCaps external {&GDI} :
  define input  parameter  hdc as {&INT}.
  define input  parameter  nIndex as {&INT}.
  define return parameter  capability as {&INT}.
end procedure.

PROCEDURE GetLastError external {&KERNEL} :
  define return parameter dwMessageID as {&INT}. 
END PROCEDURE.

PROCEDURE GetModuleFileName EXTERNAL {&KERNEL}:
  DEFINE INPUT PARAMETER hInst AS {&INT}.
  DEFINE OUTPUT PARAMETER lpszFileName AS CHAR.
  DEFINE INPUT PARAMETER cbFileName AS {&INT}.
  DEFINE RETURN PARAMETER bSuccess AS {&INT}.
END.

PROCEDURE GetParent EXTERNAL {&USER} :
   define input  parameter thishwnd as {&HWND}.
   define return parameter parenthwnd as {&HWND}.
END PROCEDURE.

PROCEDURE GetProfileString{&A} EXTERNAL {&KERNEL} :
  DEFINE INPUT  PARAMETER lpAppName        AS CHAR.
  DEFINE INPUT  PARAMETER lpKeyName        AS CHAR.
  DEFINE INPUT  PARAMETER lpDefault        AS CHAR.
  DEFINE OUTPUT PARAMETER lpReturnedString AS CHAR.
  DEFINE INPUT  PARAMETER nSize            AS {&INT}.
END.

PROCEDURE GetSystemMenu EXTERNAL {&USER} :
  define input parameter hwnd as {&HWND}.
  define input parameter bRevert as {&BOOL}.
  define return parameter hMenu as {&INT}.
END.

&IF "{&OPSYS}"="WIN32" &THEN
  PROCEDURE GetUserName{&A} external "advapi32.dll" :
     define input-output parameter lpBuffer as char.
     define input-output parameter nSize as long.
  END PROCEDURE.
&ELSE
  /* There is no 16-bit equivalent for this function.
     Create a stub OR create a wrapper to a thunked call.
     This would be a stub: */
  PROCEDURE GetUserName{&A} :
     define input-output parameter lpBuffer as char.
     define input-output parameter nSize as integer.
     lpBuffer="".
  END PROCEDURE.
&ENDIF

PROCEDURE GetWindowLong{&A} EXTERNAL {&USER} :
   define input parameter phwnd as {&HWND}.
   define input parameter cindex as {&INT}.
   define return parameter currentlong as long.
END PROCEDURE.

PROCEDURE GetWindowRect EXTERNAL {&USER} :
  define input parameter hwnd as {&HWND}.
  define output parameter lpRect as MEMPTR.
END PROCEDURE.

PROCEDURE InvalidateRect EXTERNAL {&USER} :
   define input parameter hWnd as {&HWND}.
   define input parameter lpRect as {&INT}.
   define input parameter bErase as {&BOOL}.
END PROCEDURE.

PROCEDURE LoadLibrary{&A} EXTERNAL {&KERNEL}:
  define input parameter libname as char.
  define return parameter hproc as {&HINSTANCE}.
END.

PROCEDURE MAPISendMail external {&MAPI}:
  define input parameter lhSession  as long.
  define input parameter ulUIParam  as long.
  define input parameter lpMessage  as MEMPTR.
  define input parameter flFlags    as long.
  define input parameter ulReserved as long.
  define return parameter wretcode as {&INT}.
END.

procedure mciGetErrorString{&A} external {&MMEDIA} :
   define input parameter  mciError       as {&INT}.
   define output parameter lpszErrorText  as CHAR.
   define input parameter  cchErrorText   as {&INT}.
end procedure.

procedure mciSendCommand{&A} external {&MMEDIA} :
   define input parameter  IDDevice   as {&INT}.
   define input parameter  uMsg       as {&INT}.
   define input parameter  fdwCommand as {&INT}.
   define input parameter  dwParam    as LONG.
   define return parameter mciError   as {&INT}.
end procedure.

PROCEDURE PostMessage{&A} EXTERNAL {&USER}:
    DEFINE INPUT PARAMETER hwnd   AS {&HWND}.
    DEFINE INPUT PARAMETER umsg   AS {&INT}.
    DEFINE INPUT PARAMETER wparam AS {&INT}.
    DEFINE INPUT PARAMETER lparam AS LONG.
END.

procedure ReleaseDC external {&USER} :
  define input  parameter hwnd as {&HWND}.
  define input  parameter hdc  as {&INT}.
  define return parameter ok   as {&INT}.
end procedure.

PROCEDURE SendMessage{&A} EXTERNAL {&USER}:
    DEFINE INPUT PARAMETER hwnd   AS {&HWND}.
    DEFINE INPUT PARAMETER umsg   AS {&INT}.
    DEFINE INPUT PARAMETER wparam AS {&INT}.
    DEFINE INPUT PARAMETER lparam AS LONG.
END.

PROCEDURE SetCursorPos EXTERNAL {&USER}:
    DEFINE INPUT PARAMETER x-pos AS {&INT}.
    DEFINE INPUT PARAMETER y-pos AS {&INT}.
END.

PROCEDURE SetWindowContextHelpId EXTERNAL {&USER}:
  define input parameter hwnd as {&HWND}.
  define input parameter ContextID as {&INT}.
END PROCEDURE.

PROCEDURE SetWindowLong{&A} EXTERNAL {&USER} :
   define input parameter phwnd as {&HWND}.
   define input parameter cindex as {&INT}.
   define input parameter newlong as long.
   define return parameter oldlong as long.
END PROCEDURE.

PROCEDURE SetWindowPos EXTERNAL {&USER} :
  define input parameter hwnd as {&HWND}.
  define input parameter hwndInsertAfter as {&HWND}.
  define input parameter x as {&INT}.
  define input parameter y as {&INT}.
  define input parameter cx as {&INT}.
  define input parameter cy as {&INT}.
  define input parameter fuFlags as long.
END PROCEDURE.

PROCEDURE ShellExecute{&A} EXTERNAL {&SHELL} :
  define input parameter hwnd as {&HWND}.
  define input parameter lpOperation as char.
  define input parameter lpFile as char.
  define input parameter lpParameters as char.
  define input parameter lpDirectory as char.
  define input parameter nShowCmd as {&INT}.
  define return parameter hInstance as {&INT}.
END PROCEDURE.

PROCEDURE ShowScrollBar EXTERNAL {&USER}:
  DEFINE INPUT PARAMETER hWnd  AS {&HWND}.
  DEFINE INPUT PARAMETER fnBar AS {&INT}. 
  DEFINE INPUT PARAMETER fShow AS {&BOOL}.
END.

PROCEDURE ShowWindow EXTERNAL {&USER}:
  DEFINE INPUT PARAMETER hWnd  AS {&HWND}.
  DEFINE INPUT PARAMETER nCmdShow AS {&INT}. 
END.

PROCEDURE SystemParametersInfo{&A} EXTERNAL {&USER} :
  define input parameter uiAction as {&INT}.
  define input parameter uiParam  as {&INT}.
  define input parameter pvParam  as MEMPTR.  /* PVOID, might consider LONG */
  define input parameter fWinIni  as {&INT}.
END.

PROCEDURE WaitForSingleObject EXTERNAL {&KERNEL} :
  define input parameter hObject as {&INT}.
  define input parameter dwTimeout as LONG.
END PROCEDURE.

PROCEDURE WinExec EXTERNAL {&KERNEL} :
  define input parameter lpszCmdLine as char.
  define input parameter fuCmdShow as {&INT}.
  define return parameter nTask as {&INT}.
END.

PROCEDURE WinHelp{&A} EXTERNAL {&USER}.
  define input parameter hwndmain as {&HWND}.
  define input parameter lpszHelp as char.
  define input parameter uCommand as {&INT}.
  define input parameter dwData   as LONG.
END.

&endif    /* OPSYS <> UNIX */
