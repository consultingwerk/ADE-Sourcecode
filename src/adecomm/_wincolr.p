/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _wincolr.p

Description:
    Get the current Windows foreground & background colors and update two
    unused COLOR-TABLE slots temporarily.  These values are not written to
    the registry, but used for display only by the Choose Color dialog 
    (adecomm/_chscolr.p).

Input Parameters:
    ppfgcolor: (INT) _L parent foreground COLOR-TABLE value
    ppbgcolor: (INT) _L parent background COLOR-TABLE value

Output Parameters:
    pfgcolor:  (INT) New parent foreground value if _L parent is unknown
    pbgcolor   (INT) New parent background value if _L parent if unknown

Author:  D.M.Adams
Created: 08/24/99
----------------------------------------------------------------------------*/          

DEFINE INPUT  PARAMETER ppbgcolor AS INTEGER   NO-UNDO.
DEFINE INPUT  PARAMETER ppfgcolor AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER pbgcolor  AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER pfgcolor  AS INTEGER   NO-UNDO.

DEFINE VARIABLE iBGColor  AS INTEGER   NO-UNDO. /* Windows window color */
DEFINE VARIABLE iFGColor  AS INTEGER   NO-UNDO. /* Windows text color */

RUN GetSysColor (8, OUTPUT iFGColor). /* window */
RUN GetSysColor (5, OUTPUT iBGColor). /* text */

/* Set foreground color. Find first unused color slot. */
IF ppfgcolor EQ ? THEN DO:
  DO pfgcolor = 1 TO 255:
    IF COLOR-TABLE:GET-RGB-VALUE(pfgcolor) = 0 THEN LEAVE.
  END.
  IF pfgcolor = 255 THEN DO:
   pfgcolor = ?.
   RETURN.
  END.
  ASSIGN
    COLOR-TABLE:NUM-ENTRIES = pfgcolor + 2
    pfgcolor                = pfgcolor + 1.

  COLOR-TABLE:SET-DYNAMIC(pfgcolor, yes).
  COLOR-TABLE:SET-RGB-VALUE(pfgcolor,iFGColor).
END.
ELSE
  pfgcolor = ppfgcolor.

/* Set background color. Find next unused color slot. */
IF ppbgcolor = ? THEN DO:
  DO pbgcolor = pfgcolor TO 255:
    IF COLOR-TABLE:GET-RGB-VALUE(pbgcolor) = 0 THEN LEAVE.
  END.
  IF pbgcolor = 255 THEN DO:
    pbgcolor = ?.
    RETURN.
  END.
  ASSIGN
    COLOR-TABLE:NUM-ENTRIES = pbgcolor + 2
    pbgcolor                = pbgcolor + 1.

  COLOR-TABLE:SET-DYNAMIC(pbgcolor, yes).
  COLOR-TABLE:SET-RGB-VALUE(pbgcolor,iBGColor).
END.
ELSE
  pbgcolor = ppbgcolor.

/* Win32 API calls */
PROCEDURE GetSysColor EXTERNAL "user32.dll":
  DEFINE INPUT  PARAMETER nIndex    AS LONG.
  DEFINE RETURN PARAMETER iWinColor AS HANDLE TO LONG.
END.

/* Do not erase (dma)
  ASSIGN 
    iRed    = (iWinColor MODULO 256)
    iGreen  = ((iWinColor - iRed) / 256) MODULO 256
    iBlue   = (((iWinColor - iRed) / 256) - iGreen)
    .
*/

/* _wincolr.p - end of file */
