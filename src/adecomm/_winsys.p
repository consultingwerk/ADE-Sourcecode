/***********************************************************************
* Copyright (C) 2000,2007,2012,2014 by Progress Software Corporation.  *
* All rights reserved. Prior versions of this work may contain         *
* portions contributed by participants of Possenet.                    *
*                                                                      *
***********************************************************************/
/*
  Procedure:    adecomm/_winsys.p
  Author:       R. Ryan 
  Created:      1/95
  Purpose:      written by Bob Ryan (from gfs's API examples) to
                provide basic windows' system information to better
                help tech support
              
  Modified on 01/15/95 by gfs - ported to Win32
              01/29/98 by gfs - fixed up second line message
              04/18/98 by gfs - Increased format of numerics
              07/24/98 by gfs - State real O/S in message
              12/16/99 by gfs - Reworked O/S message to say Win2000 instead
                                on WinNT. Also, changed version info to format:
                                (<major>.<minor>.<build>:<SP svcpack#>)
*/          

DEFINE OUTPUT PARAMETER pLabel1 AS CHARACTER.
DEFINE OUTPUT PARAMETER pLabel2 AS CHARACTER.

IF OPSYS EQ "WIN32" THEN DO:
  DEFINE VARIABLE lpmemorystatus AS MEMPTR.
  DEFINE VARIABLE lpsysteminfo   AS MEMPTR.
  DEFINE VARIABLE procnum        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE proctype       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE TotPhysMem     AS INT64     NO-UNDO.
  DEFINE VARIABLE FreePhysMem    AS INT64   NO-UNDO.
  DEFINE VARIABLE lpVersionInfo  AS MEMPTR.
  DEFINE VARIABLE MajorVersion   AS INTEGER   NO-UNDO.
  DEFINE VARIABLE MinorVersion   AS INTEGER   NO-UNDO.
  DEFINE VARIABLE BuildNumber    AS INTEGER   NO-UNDO INIT ?.
  DEFINE VARIABLE Other          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE OSstr          AS CHARACTER NO-UNDO INIT "".
  DEFINE VARIABLE lpOSName       AS MEMPTR.

  /* set up pointers */
  SET-SIZE(lpmemorystatus)   = 64.  /* sizeof(MEMORYSTATUSEX) */
  PUT-LONG(lpmemorystatus,1) = 64.  /* dwLength */
  SET-SIZE(lpVersionInfo)    = 156. /* sizeof(OSVERSIONINFOEX) */
  PUT-LONG(lpVersionInfo,1)  = 156. /* dwOSVersionInfoSize */

  /* Get the OS version info struct */
  RUN proGetVersionExA (INPUT-OUTPUT lpVersionInfo).

  /* Get the OS name */
  SET-SIZE(lpOSName) = 32.
  RUN proGetVersionNameA (INPUT lpVersionInfo, INPUT-output lpOSName, 32).
  OSstr = GET-STRING(lpOSName, 1).

  CASE PROCESS-ARCHITECTURE :
      WHEN 32 THEN
        SET-SIZE(lpsysteminfo) = 36.  /* sizeof(SYSTEM_INFO) in 32-bit process */
      WHEN 64 THEN
        SET-SIZE(lpsysteminfo) = 48.  /* sizeof(SYSTEM_INFO) in 64-bit process */
  END CASE.

  /* Call Windows API */
  RUN GlobalMemoryStatusEx (INPUT-OUTPUT lpmemorystatus).
  RUN GetNativeSystemInfo (INPUT-OUTPUT lpsysteminfo).

  /* Extract data from pointers */
  ASSIGN
    TotPhysMem   = GET-INT64(lpmemorystatus,9)  / 1024  /* ullTotalPhys */
    FreePhysMem  = GET-INT64(lpmemorystatus,17) / 1024  /* ullAvailPhys */
    ProcNum      = GET-SHORT(lpsysteminfo,1).           /* wProcessorArchitecture */

  CASE procnum:
    WHEN 0 THEN ProcType = "x86".  /* PROCESSOR_ARCHITECTURE_INTEL */
    WHEN 6 THEN ProcType = "IA64". /* PROCESSOR_ARCHITECTURE_IA64 */
    WHEN 9 THEN ProcType = "x64".  /* PROCESSOR_ARCHITECTURE_AMD64 */
    OTHERWISE ProcType = "unknown architecture".
  END CASE.

  ASSIGN
    MajorVersion = GET-LONG(lpVersionInfo,5)     /* dwMajorVersion */
    MinorVersion = GET-LONG(lpVersionInfo,9)     /* dwMinorVersion */.

  /* If this is a pre-Windows 8.1 version get the build number and
  ** service pack description. Windows 8.1 and later don't provide
  ** accurate information so we can't display it.
  */ 
  IF MajorVersion < 6 OR (MajorVersion = 6 AND MinorVersion <= 2) THEN
  DO:
    ASSIGN
      BuildNumber  = GET-LONG(lpVersionInfo,13)    /* dwBuildNumber */
      Other        = GET-STRING(lpVersionInfo,21). /* szCSDVersion */
  END.

  ASSIGN  OSstr = OSstr + " (" + 
          STRING(MajorVersion) + "." + 
          STRING(MinorVersion) + 
          (IF STRING(BuildNumber) NE ? THEN "." + STRING(BuildNumber) ELSE "").

  IF Other NE ? AND Other NE "" THEN 
   ASSIGN OSstr = OSstr + ":" + REPLACE(Other,"Service Pack":U,"SP":U).

  ASSIGN pLabel1 = OSstr + ")":U + " on ":U + ProcType NO-ERROR.
  ASSIGN pLabel2 = "Phys. memory: " + TRIM(STRING(TotPhysMem, ">>>,>>>,>>9K")) + " with "
                   + TRIM(STRING(FreePhysMem, ">>>,>>>,>>9K free")) NO-ERROR.
 
  /* free pointers */
  SET-SIZE(lpmemorystatus) = 0.
  SET-SIZE(lpsysteminfo)   = 0.
  SET-SIZE(lpVersionInfo)  = 0.  
  SET-SIZE(lpOSName)       = 0.

END.

/*
** Procedures ..............
*/

PROCEDURE proGetVersionExA EXTERNAL "proosver.dll":
  DEFINE INPUT-OUTPUT PARAMETER lpVersionInfo AS MEMPTR.
END.

PROCEDURE proGetVersionNameA EXTERNAL "proosver.dll":
  DEFINE INPUT        PARAMETER lpVersionInfo AS MEMPTR.
  DEFINE INPUT-output PARAMETER osName AS memptr.
  DEFINE INPUT        PARAMETER buffLen AS LONG.
END.

/* Win32 API calls */
PROCEDURE GlobalMemoryStatusEx EXTERNAL "kernel32.dll":
  DEFINE INPUT-OUTPUT PARAMETER lpmemorystatus AS MEMPTR.
END.

PROCEDURE GetNativeSystemInfo EXTERNAL "kernel32.dll":
  DEFINE INPUT-OUTPUT PARAMETER lpSystemInfo AS MEMPTR.
END.
