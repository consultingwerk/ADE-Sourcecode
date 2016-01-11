/***********************************************************************
* Copyright (C) 2000,2007 by Progress Software Corporation. All rights *
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
  DEFINE VARIABLE PctMemInUse    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE SwapFree       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE TotPhysMem     AS INT64     NO-UNDO.
  DEFINE VARIABLE FreePhysMem    AS INT64   NO-UNDO.
  DEFINE VARIABLE lpVersionInfo  AS MEMPTR.
  DEFINE VARIABLE MajorVersion   AS INTEGER   NO-UNDO.
  DEFINE VARIABLE MinorVersion   AS INTEGER   NO-UNDO.
  DEFINE VARIABLE BuildNumber    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE PlatformId     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE Other          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE OSstr          AS CHARACTER NO-UNDO.

&SCOPED-DEFINE VER_PLATFORM_WIN32_WINDOWS 1
&SCOPED-DEFINE VER_PLATFORM_WIN32_NT      2

  /* set up pointers */
  SET-SIZE(lpmemorystatus)   = 64.
  PUT-LONG(lpmemorystatus,1) = 64.
  SET-SIZE(lpsysteminfo)     = 40.  
  SET-SIZE(lpVersionInfo)    = 148.
  PUT-LONG(lpVersionInfo,1)  = 148.
  
  /* Call Windows API */
  RUN GlobalMemoryStatusEx (INPUT-OUTPUT lpmemorystatus).
  RUN GetSystemInfo (INPUT-OUTPUT lpsysteminfo).
  RUN GetVersionExA (INPUT-OUTPUT lpVersionInfo).
 
  /* Extract data from pointers */
  ASSIGN
    PctMemInUse  = GET-LONG(lpmemorystatus,5)
    TotPhysMem   = GET-INT64(lpmemorystatus,9)  / 1024
    FreePhysMem  = GET-INT64(lpmemorystatus,17) / 1024
    ProcNum      = GET-SHORT(lpsysteminfo,1)
    ProcType     = STRING(GET-LONG(lpsysteminfo,25))
    SwapFree     = GET-LONG(lpmemorystatus,21) / 1024.
  CASE procnum:
    WHEN 0 THEN ProcType = "Intel "   + (IF ProcType = "586" THEN "Pentium" ELSE ProcType).
    WHEN 1 THEN ProcType = "MIPS "    + Proctype.
    WHEN 2 THEN ProcType = "ALPHA "   + Proctype.
    WHEN 3 THEN ProcType = "PowerPC " + ProcType.
    OTHERWISE ProcType = "unknown processor".
  END CASE.

  ASSIGN
    MajorVersion = GET-LONG(lpVersionInfo,5)
    MinorVersion = GET-LONG(lpVersionInfo,9)
    BuildNumber  = GET-LONG(lpVersionInfo,13)
    PlatformId   = GET-LONG(lpVersionInfo,17)
    Other        = GET-STRING(lpVersionInfo,21).

  IF PlatformId = {&VER_PLATFORM_WIN32_NT} THEN DO:
    CASE MajorVersion:
        WHEN 4 THEN ASSIGN OSstr = "WinNT ":U.
        WHEN 5 THEN ASSIGN OSstr = IF MinorVersion = 0 THEN "Win2000 ":U       ELSE "WinXP ":U.
        WHEN 6 THEN ASSIGN OSstr = IF MinorVersion = 0 THEN "Windows Vista ":U ELSE "":U.
    END CASE.

    ASSIGN  OSstr = OSstr + "(" + 
            STRING(MajorVersion) + "." + 
            STRING(MinorVersion) + 
            (IF STRING(BuildNumber) NE ? THEN "." + STRING(BuildNumber) ELSE "").
  END.
  ELSE IF PlatformId = {&VER_PLATFORM_WIN32_WINDOWS} THEN
    CASE MinorVersion:
      WHEN 10   THEN OSstr = "Win98":U.
      OTHERWISE      OSStr = "Win95":U. 
    END CASE.
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
ELSE DO:
  /* Win16 version */
  def var FreeRes  as int format ">>9%" no-undo.
  def var wFlags   as int no-undo.
  def var c        as int no-undo.
  def var Math     as int no-undo.
  def var CPU      as int no-undo.
  def var FreeMem  as int no-undo.
  def var ExecMode as int no-undo.
  def var WinMode  as char format "x(30)".
  def var WinMem   as dec format ">>>,>>> KB".  
  def var WinCPU   as char no-undo.
  def var Win87    as char no-undo.

  run GetWinFlags(output wFlags).
  run GetFreeSpace(output FreeMem).
  run GetFreeSystemResources(input 0, output FreeRes).

  ExecMode = wFlags.

  repeat c = 1 to 5:
    ExecMode = ExecMode / 2.
  end.

  if ExecMode MOD 2 = 0 then
    WinMode = " Windows Enhanced Mode".
  else
    WinMode = " Windows Standard Mode".

  WinMem = FreeMem / 1024.

  Math = wFlags / 1024.
  if Math MOD 2 = 0 then 
    Win87 = "".
  else
  /* gandy 
    Win87 = " (Math Co-Proc)". 
  */
     Win87 = "".

  assign CPU = wFlags.
  repeat c = 1 to 4:
    CPU = CPU / 2.
    if CPU MOD 2 = 0 then do:
      case c:
        when 1 then WinCPU = "286".
        when 2 then WinCPU = "386".
        when 3 then WinCPU = "486". 
        when 4 then WinCpu = "586".
      end case.  
      leave.
    end.    
  end.

  pLabel1 = WinCpu + WinMode + Win87.
  pLabel2 = string(WinMem,">>>,>>> KB Memory") + " (" + string(FreeRes,">>9% Free") + ")".

END.
/*
** Procedures ..............
*/
/* Win16 API calls */
procedure GetFreeSpace external "krnl386.exe":
  define return parameter amount as long.
end.

procedure GetWinFlags external "krnl386.exe":
  define return parameter wFlags as long.
end.

procedure GetFreeSystemResources external "user.exe":
  define input parameter flags as short.
  define return parameter res as short.
end.

PROCEDURE GetVersionExA EXTERNAL "kernel32.dll":
  DEFINE INPUT-OUTPUT PARAMETER lpVersionInfo AS MEMPTR.
END.

/* Win32 API calls */
procedure GlobalMemoryStatusEx external "kernel32.dll":
  define input-output parameter lpmemorystatus as memptr.
end.

procedure GetSystemInfo external "kernel32.dll":
  define input-output parameter lpSystemInfo as memptr.
end.
