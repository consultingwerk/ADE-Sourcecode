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

  File: _proobjv.p

  Description: Start the Progress COM Object Viewer executable.

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Gerry Seidl

  Modified: 
     
 *---------------------------------------------------------------------------*/
IF SESSION:WINDOW-SYSTEM BEGINS "MS-WIN" THEN DO:
  FILE-INFO:FILE-NAME = "bin\proobjvw.exe".
  IF FILE-INFO:FULL-PATHNAME NE ? THEN DO:
    RUN WinExec (INPUT FILE-INFO:FULL-PATHNAME, INPUT 1). 
  END.
  ELSE MESSAGE "proobjvw.exe was not found."
         VIEW-AS ALERT-BOX ERROR.
END.
ELSE
  MESSAGE "This program runs only under Microsoft Windows."
    VIEW-AS ALERT-BOX ERROR.
    
PROCEDURE WinExec EXTERNAL "KERNEL32.DLL": 
    DEFINE INPUT PARAMETER prog_name AS CHARACTER. 
    DEFINE INPUT PARAMETER prog_style AS SHORT. 
END.









