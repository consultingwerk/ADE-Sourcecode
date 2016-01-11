/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*-----------------------------------------------------------------------------

  File: _osprmt.p

  Description: Start an OS prompt.

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Gerry Seidl

  Modified on 
     08/22/96 by gfs - changed to work on Windows NT
     01/16/96 by gfs - ported to WIN32
 *---------------------------------------------------------------------------*/
IF SESSION:WINDOW-SYSTEM BEGINS "MS-WIN" THEN DO:
  DEFINE VARIABLE windir        AS MEMPTR.
  DEFINE VARIABLE windowsdir    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE outsize       AS INTEGER   NO-UNDO.
  
  /* Get Windows directory */
  SET-SIZE(windir) = 80.
  IF OPSYS = "WIN32" THEN RUN GetWindowsDirectoryA(windir, 80, OUTPUT outsize).
  ELSE RUN GetWindowsDirectory(windir, 80, OUTPUT outsize).
  ASSIGN windowsdir = get-string(windir,1).      

  /* Find out what's available on the system to get a DOS Prompt */
  ASSIGN FILE-INFO:FILE-NAME = OS-GETENV("COMSPEC"). /* Environment variable */
  IF FILE-INFO:FULL-PATHNAME = ? THEN DO:
    ASSIGN FILE-INFO:FILE-NAME = windowsdir + "/DOSPRMPT.PIF". /* Windows 3.1 */
    IF FILE-INFO:FULL-PATHNAME = ? THEN DO:
      ASSIGN FILE-INFO:FILE-NAME = windowsdir + "/COMMAND.COM". /* Windows 95 */
      IF FILE-INFO:FULL-PATHNAME = ? THEN DO:
        ASSIGN FILE-INFO:FILE-NAME = windowsdir + "/SYSTEM32/CMD.EXE". /* Windows NT */
        IF FILE-INFO:FULL-PATHNAME = ? THEN DO:
          MESSAGE "Cannot create DOS prompt." VIEW-AS ALERT-BOX ERROR.         
          RETURN.
        END.
      END.
    END.
  END.
  IF OPSYS = "WIN32" THEN
    RUN WinExec (INPUT FILE-INFO:FULL-PATHNAME, INPUT 1). 
  ELSE
    RUN WinExec16 (INPUT FILE-INFO:FULL-PATHNAME, INPUT 1). 
END.
ELSE IF SESSION:WINDOW-SYSTEM = "OSF/MOTIF" THEN
    OS-COMMAND SILENT "xterm &".

/* 32bit version */
PROCEDURE WinExec EXTERNAL "KERNEL32.DLL": 
    DEFINE INPUT PARAMETER prog_name AS CHARACTER. 
    DEFINE INPUT PARAMETER prog_style AS SHORT. 
END.

/* 16bit version */
PROCEDURE WinExec16 EXTERNAL "krnl386.exe" ORDINAL 166: 
    DEFINE INPUT PARAMETER prog_name AS CHARACTER. 
    DEFINE INPUT PARAMETER prog_style AS SHORT. 
END.

/* 32bit version */
PROCEDURE GetWindowsDirectoryA EXTERNAL "KERNEL32.DLL":
  DEFINE INPUT PARAMETER dirname AS MEMPTR.
  DEFINE INPUT PARAMETER bufsize AS LONG.
  DEFINE RETURN PARAMETER len    AS LONG. 
END.

/* 16bit version */
PROCEDURE GetWindowsDirectory EXTERNAL "KERNEL.EXE":
  DEFINE INPUT PARAMETER dirname AS MEMPTR.
  DEFINE INPUT PARAMETER bufsize AS SHORT.
  DEFINE RETURN PARAMETER len    AS SHORT. 
END.










