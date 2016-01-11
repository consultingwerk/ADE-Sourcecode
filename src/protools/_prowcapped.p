/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*-----------------------------------------------------------------------------

  File: _prowcapped.p

  Description: Start the Progress Web Client Application Editor executable.

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Gerry Seidl

  Created: 05/23/2000

  Modified: 03/13/01 gfs Updated the name of the exe called.
     
 *---------------------------------------------------------------------------*/
IF SESSION:WINDOW-SYSTEM BEGINS "MS-WIN" THEN DO:
  FILE-INFO:FILE-NAME = "bin\prowcappmgr.exe":U.
  IF FILE-INFO:FULL-PATHNAME NE ? THEN DO:
    RUN WinExec (INPUT FILE-INFO:FULL-PATHNAME, INPUT 1). 
  END.
  ELSE MESSAGE "prowcappmgr.exe was not found."
         VIEW-AS ALERT-BOX ERROR.
END.
ELSE
  MESSAGE "This program runs only under Microsoft Windows."
    VIEW-AS ALERT-BOX ERROR.
    
PROCEDURE WinExec EXTERNAL "KERNEL32.DLL": 
    DEFINE INPUT PARAMETER prog_name AS CHARACTER. 
    DEFINE INPUT PARAMETER prog_style AS SHORT. 
END.









