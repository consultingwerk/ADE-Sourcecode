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

/**************************************************************************
    Procedure:  _taskbar.p                                       
    Purpose:    Locates the Windows 95 taskbar and returns information
                about it.
                Orientation: LEFT,TOP,RIGHT or BOTTOM of screen
                Height in pixels
                Width  in pixels
                Auto-Hide on/off
    Syntax :    RUN adecomm/_taskbar.p (OUTPUT Orientation,
                                        OUTPUT TBHeight,
                                        OUTPUT TBWidth,
                                        OUTPUT Auto-Hide).
    Author : Gerry Seidl
    Date   : 02/01/96
    
    Modified: 10/21/96 gfs Switched ordinals because NT 4.0 ordinals are
                           different than Windows 95.
**************************************************************************/
DEFINE OUTPUT PARAMETER TBOrientation AS CHARACTER NO-UNDO INITIAL ?.
DEFINE OUTPUT PARAMETER TBHeight      AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER TBWidth       AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER AutoHide      AS LOGICAL   NO-UNDO INITIAL NO.

DEFINE VARIABLE TBhWnd        AS INTEGER NO-UNDO.
DEFINE VARIABLE wrect         AS MEMPTR  NO-UNDO.
DEFINE VARIABLE wrect-left    AS INTEGER NO-UNDO.
DEFINE VARIABLE wrect-top     AS INTEGER NO-UNDO.
DEFINE VARIABLE wrect-right   AS INTEGER NO-UNDO.
DEFINE VARIABLE wrect-bottom  AS INTEGER NO-UNDO.

IF NOT SESSION:WINDOW-SYSTEM BEGINS "MS-WIN" THEN RETURN.

IF OPSYS = "WIN32" THEN
  RUN FindWindowA("Shell_TrayWnd", "", OUTPUT TBhWnd).
ELSE
  RUN FindWindow("Shell_TrayWnd", "", OUTPUT TBhWnd).   
  
IF TBhWnd NE 0 THEN DO: /* found Windows 95 TaskBar window */
  IF OPSYS = "WIN32" THEN DO:
    SET-SIZE(wrect) = 16. /* 4 INTEGERS at 4 bytes each */
    RUN GetWindowRect(TBhWnd, OUTPUT wrect).
    ASSIGN wrect-left    = GET-LONG(wrect,1)
           wrect-top     = GET-LONG(wrect,5)
           wrect-right   = GET-LONG(wrect,9)
           wrect-bottom  = GET-LONG(wrect,13). 
  END. 
  ELSE DO:
    SET-SIZE(wrect) = 8. /* 4 INTEGERS at 2 bytes each */
    RUN GetWindowRect16(TBhWnd, OUTPUT wrect).
    ASSIGN wrect-left    = GET-SHORT(wrect,1)
           wrect-top     = GET-SHORT(wrect,3)
           wrect-right   = GET-SHORT(wrect,5)
           wrect-bottom  = GET-SHORT(wrect,7).   
  END.
  ASSIGN      
    TBHeight      = wrect-bottom - wrect-top
    TBWidth       = wrect-right - wrect-left.

  /*MESSAGE "Upper left coordinate: " "(" wrect-left "," wrect-top ")" skip
          "Lower right coordinate: " "(" wrect-right "," wrect-bottom ")" skip
          "Height: " TBHeight skip
          "Width: " TBWidth
          view-as alert-box.*/
  SET-SIZE(wrect) = 0.

  IF TBHeight < 10 OR TBWidth < 10 THEN AutoHide = TRUE. 

  IF wrect-left <= 0 AND wrect-top <= 0 THEN DO:
    /* either top or left */
    IF TBHeight >= SESSION:HEIGHT-P THEN TBOrientation = "LEFT".
    ELSE TBOrientation = "TOP".
  END.
  ELSE IF wrect-left <=0 AND wrect-top > 0  THEN TBOrientation = "BOTTOM".
  ELSE IF wrect-left > 0 AND wrect-top <= 0 THEN TBOrientation = "RIGHT".
END.

RETURN.

/* Windows API procedures */  
/* WIN32 versions */
PROCEDURE FindWindowA EXTERNAL "USER32.DLL":
  DEFINE INPUT  PARAMETER lpClassName  AS CHARACTER.
  DEFINE INPUT  PARAMETER lpWindowName AS CHARACTER.
  DEFINE RETURN PARAMETER hWnd         AS LONG.
END.

PROCEDURE GetWindowRect EXTERNAL "USER32.DLL":
  DEFINE INPUT  PARAMETER  hWnd   AS LONG.
  DEFINE OUTPUT PARAMETER  lpRect AS MEMPTR.
END.

/* WIN16 versions */
PROCEDURE FindWindow EXTERNAL "USER.EXE":
  DEFINE INPUT  PARAMETER lpClassName  AS CHARACTER.
  DEFINE INPUT  PARAMETER lpWindowName AS CHARACTER.
  DEFINE RETURN PARAMETER hWnd         AS SHORT.
END.

PROCEDURE GetWindowRect16 EXTERNAL "USER.EXE" ORDINAL 32:
  DEFINE INPUT  PARAMETER  hWnd   AS SHORT.
  DEFINE OUTPUT PARAMETER  lpRect AS MEMPTR.
END.

