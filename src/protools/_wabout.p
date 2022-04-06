/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*-----------------------------------------------------------------------------

  File: _wabout.w

  Description: call to Shell About

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Gerry Seidl

  Modified on 01/15/96 by gfs - ported to WIN32
 *---------------------------------------------------------------------------*/
IF OPSYS EQ "WIN32" THEN
  RUN ShellAboutA (INPUT 0, 
                  INPUT "Windows Information#", 
                  INPUT "",
                  INPUT 0).

ELSE
  RUN ShellAbout (INPUT 0, 
                  INPUT "PRO*Tools", 
                  INPUT "",
                  INPUT 0).
        
/* WIN API entry points */
/* 32bit version */        
PROCEDURE ShellAboutA EXTERNAL "shell32.dll":
    DEFINE INPUT PARAMETER hWnd    AS LONG.
    DEFINE INPUT PARAMETER AppName AS CHAR.
    DEFINE INPUT PARAMETER AppInfo AS CHAR.  
    DEFINE INPUT PARAMETER hIcon   AS LONG.
END.
/* 16bit version */
PROCEDURE ShellAbout EXTERNAL "shell.exe":
    DEFINE INPUT PARAMETER hWnd    AS SHORT.
    DEFINE INPUT PARAMETER AppName AS CHAR.
    DEFINE INPUT PARAMETER AppInfo AS CHAR.  
    DEFINE INPUT PARAMETER hIcon   AS SHORT.
END.

