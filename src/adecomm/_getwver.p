/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/**************************************************************************
    Procedure:  _getwver.p

    Purpose:    Calls the Windows API to get the version of MS-Windows.
                For Windows 3.1 returns 3.10
                For Windows 95  returns 3.95
                
                On WIN32
                For Windows 95  returns 4.00
                For Windows NT  returns 3.51

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

  SET-SIZE(lpVersionInfo)   = 148.
  PUT-LONG(lpVersionInfo,1) = 148.

  RUN GetVersionExA (INPUT-OUTPUT lpVersionInfo).
  ASSIGN WinVer = get-long(lpVersionInfo,5) + (get-long(lpVersionInfo,9) / 100).

  SET-SIZE(lpVersionInfo) = 0.

END.
ELSE DO: /* 16bit version */
  RUN GetVersion (OUTPUT RawVer).

  ASSIGN WinVer = (RawVer MOD 256) + (((RawVer / 256 ) MOD 265) / 100).
END.

/* Call to Windows API */
PROCEDURE GetVersionExA EXTERNAL "kernel32.dll":
  DEFINE INPUT-OUTPUT PARAMETER lpVersionInfo AS MEMPTR.
END.

PROCEDURE GetVersion EXTERNAL "krnl386.exe":
  DEFINE RETURN PARAMETER RawVer AS SHORT.
END.
