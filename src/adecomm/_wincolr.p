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
