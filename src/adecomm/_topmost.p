/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: _topmost.p

  Description: Defines a window to be TOP-MOST or not.

  Input Parameters:
       usrhwnd (int) - hWnd of Progress window client area
       mode    (log) - turn TOP-MOST on or off

  Output Parameters:
       rc (int)      - return code (non-zero = ok)

  Author: Gerry Seidl

  Created: Sept 9, 1994 
  
  Modified by: GFS 05/08/95 Cleaned up.
               GFS 01/15/96 Ported to WIN32
------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER usrhwnd AS INTEGER NO-UNDO. /* hWnd of window (really client area only) */
DEFINE INPUT  PARAMETER mode    AS LOGICAL NO-UNDO. /* yes = on, no = off */
DEFINE OUTPUT PARAMETER rc      AS INTEGER NO-UNDO. /* non-zero = ok */

DEFINE VARIABLE topmost         AS INTEGER NO-UNDO.
DEFINE VARIABLE flags           AS INTEGER NO-UNDO INITIAL  3.  /* 0x0001 OR 0x0002 */  
DEFINE VARIABLE parent          AS INTEGER NO-UNDO.             /* hold parent hWnd */

IF OPSYS = "WIN32" THEN DO:
  RUN GetParent ( INPUT usrhwnd, OUTPUT parent).

  RUN SetWindowPos ( INPUT  parent,
                       INPUT  (IF mode THEN -1 ELSE -2),
                       INPUT  0,
                       INPUT  0,
                       INPUT  0,
                       INPUT  0,
                       INPUT  flags,
                       OUTPUT rc ).
END.
ELSE DO:
  RUN GetParent16 ( INPUT usrhwnd, OUTPUT parent).

  RUN SetWindowPos16 ( INPUT  parent,
                     INPUT  (IF mode THEN -1 ELSE -2),
                     INPUT  0,
                     INPUT  0,
                     INPUT  0,
                     INPUT  0,
                     INPUT  flags,
                     OUTPUT rc ).
END.

/* 32bit DLLs */
PROCEDURE SetWindowPos EXTERNAL "user32.dll":
  DEFINE INPUT PARAMETER hWnd            AS LONG.
  DEFINE INPUT PARAMETER hWndInsertAfter AS LONG.
  DEFINE INPUT PARAMETER x               AS LONG.
  DEFINE INPUT PARAMETER y               AS LONG.
  DEFINE INPUT PARAMETER cx              AS LONG.
  DEFINE INPUT PARAMETER cy              AS LONG.
  DEFINE INPUT PARAMETER wflags          AS LONG.   
  DEFINE RETURN PARAMETER rc             AS LONG.
END.

PROCEDURE GetParent EXTERNAL "user32.dll":
  DEFINE INPUT  PARAMETER hWnd1           AS LONG.
  DEFINE RETURN PARAMETER hWnd2           AS LONG.
END. 
              
/* 16bit DLLs */
PROCEDURE SetWindowPos16 EXTERNAL "user.exe" ORDINAL 232:
  DEFINE INPUT PARAMETER hWnd            AS SHORT.
  DEFINE INPUT PARAMETER hWndInsertAfter AS SHORT.
  DEFINE INPUT PARAMETER x               AS SHORT.
  DEFINE INPUT PARAMETER y               AS SHORT.
  DEFINE INPUT PARAMETER cx              AS SHORT.
  DEFINE INPUT PARAMETER cy              AS SHORT.
  DEFINE INPUT PARAMETER wflags          AS SHORT.   
  DEFINE RETURN PARAMETER rc             AS SHORT.
END.

PROCEDURE GetParent16 EXTERNAL "user.exe" ORDINAL 46:
  DEFINE INPUT  PARAMETER hWnd1           AS SHORT.
  DEFINE RETURN PARAMETER hWnd2           AS SHORT.
END.

