/*********************************************************************
* Copyright (C) 2005,2012 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/**************************************************************************
    Procedure:  _getwver.p

    Purpose:    Calls the Windows API to get the version of MS-Windows.

    Syntax :    RUN adecomm/_getwver.p (OUTPUT WinVer ).

    Parameters:
        Winver   : returns the Windows version

    Notes  :
    Author : Gerry Seidl
    Date   : 11/22/95

    Modified on 01/15/96 by gfs - ported to WIN32.
    
**************************************************************************/
DEFINE OUTPUT PARAMETER WinVer   AS DECIMAL NO-UNDO INIT 0.
DEFINE VARIABLE         RawVer   AS INTEGER NO-UNDO.

IF LOOKUP(SESSION:WINDOW-SYSTEM,"MS-WINDOWS,MS-WIN95,MS-WINXP") = 0 THEN RETURN.

IF OPSYS EQ "WIN32" THEN DO: /* 32bit version */
  DEFINE VARIABLE lpVersionInfo AS MEMPTR.
  DEFINE VARIABLE dwMajorVersion AS INTEGER.
  DEFINE VARIABLE dwMinorVersion AS INTEGER.

  SET-SIZE(lpVersionInfo)   = 148. /* sizeof(OSVERSIONINFO) */
  PUT-LONG(lpVersionInfo,1) = 148. /* dwOSVersionInfoSize */

  RUN GetVersionExA (INPUT-OUTPUT lpVersionInfo).
  dwMajorVersion = GET-LONG(lpVersionInfo, 5).  /* dwMajorVersion */
  dwMinorVersion = GET-LONG(lpVersionInfo, 9).  /* dwMinorVersion */

  ASSIGN WinVer = dwMajorVersion +
                  IF dwMinorVersion < 10 THEN dwMinorVersion / 10
				                         ELSE dwMinorVersion / 100.

  SET-SIZE(lpVersionInfo) = 0.

END.

/* Call to Windows API */
PROCEDURE GetVersionExA EXTERNAL "kernel32.dll":
  DEFINE INPUT-OUTPUT PARAMETER lpVersionInfo AS MEMPTR.
END.
