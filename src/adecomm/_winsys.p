/***********************************************************************
* Copyright (C) 2000,2007,2012 by Progress Software Corporation. All rights *
* reserved. Prior versions of this work may contain portions           *
* contributed by participants of Possenet.                             *
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
  DEFINE VARIABLE BuildNumber    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE PlatformId     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE ProductType    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE Other          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE OSstr          AS CHARACTER NO-UNDO.

&SCOPED-DEFINE VER_PLATFORM_WIN32_NT      2
&SCOPED-DEFINE VER_NT_WORKSTATION         1

  /* set up pointers */
  SET-SIZE(lpmemorystatus)   = 64.  /* sizeof(MEMORYSTATUSEX) */
  PUT-LONG(lpmemorystatus,1) = 64.  /* dwLength */
  SET-SIZE(lpVersionInfo)    = 156. /* sizeof(OSVERSIONINFOEX) */
  PUT-LONG(lpVersionInfo,1)  = 156. /* dwOSVersionInfoSize */

  CASE PROCESS-ARCHITECTURE :
      WHEN 32 THEN
        SET-SIZE(lpsysteminfo) = 36.  /* sizeof(SYSTEM_INFO) in 32-bit process */
      WHEN 64 THEN
        SET-SIZE(lpsysteminfo) = 48.  /* sizeof(SYSTEM_INFO) in 64-bit process */
  END CASE.

  /* Call Windows API */
  RUN GlobalMemoryStatusEx (INPUT-OUTPUT lpmemorystatus).
  RUN GetNativeSystemInfo (INPUT-OUTPUT lpsysteminfo).
  RUN GetVersionExA (INPUT-OUTPUT lpVersionInfo).
 
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
    MinorVersion = GET-LONG(lpVersionInfo,9)     /* dwMinorVersion */
    BuildNumber  = GET-LONG(lpVersionInfo,13)    /* dwBuildNumber */
    PlatformId   = GET-LONG(lpVersionInfo,17)    /* dwPlatformId */
    ProductType  = GET-BYTE(lpVersionInfo,155)   /* wProductType */
    Other        = GET-STRING(lpVersionInfo,21). /* szCSDVersion */

  CASE MajorVersion:
      WHEN 4 THEN ASSIGN OSstr = "WinNT ":U.
      WHEN 5 THEN
        CASE MinorVersion:
          /* Values 1 and 2 can be one of several versions of Windows but
          ** we have always just reported XP and it's not worth doing all
          ** of the work required to identify each one individually.
          */
          WHEN 0 THEN ASSIGN OSstr = "Windows 2000 ":U.
          WHEN 1 OR WHEN 2 THEN ASSIGN OSstr = "Windows XP ":U.
        END CASE.
      WHEN 6 THEN
        CASE MinorVersion:
          WHEN 0 THEN ASSIGN OSstr = IF ProductType = {&VER_NT_WORKSTATION} THEN "Windows Vista ":U ELSE "Windows Server 2008 ":U.
          WHEN 1 THEN ASSIGN OSstr = IF ProductType = {&VER_NT_WORKSTATION} THEN "Windows 7 ":U ELSE "Windows Server 2008 R2 ":U.
          WHEN 2 THEN ASSIGN OSstr = IF ProductType = {&VER_NT_WORKSTATION} THEN "Windows 8 ":U ELSE "Windows Server 2012 ":U.
        END CASE.
  END CASE.

  ASSIGN  OSstr = OSstr + "(" + 
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

END.

/*
** Procedures ..............
*/

/* Win32 API calls */
PROCEDURE GetVersionExA EXTERNAL "kernel32.dll":
  DEFINE INPUT-OUTPUT PARAMETER lpVersionInfo AS MEMPTR.
END.

PROCEDURE GlobalMemoryStatusEx EXTERNAL "kernel32.dll":
  DEFINE INPUT-OUTPUT PARAMETER lpmemorystatus AS MEMPTR.
END.

PROCEDURE GetNativeSystemInfo EXTERNAL "kernel32.dll":
  DEFINE INPUT-OUTPUT PARAMETER lpSystemInfo AS MEMPTR.
END.
