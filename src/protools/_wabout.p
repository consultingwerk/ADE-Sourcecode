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

